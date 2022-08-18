// Copyright 2021 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

package cmdsolutiondeploy

import (
	"fmt"
	"os"
	"path/filepath"
	"strings"
	"strconv"
	"reflect"
	"errors"

	"arete/pkg/utils"
	"arete/internal/cmdsolution"
	solutionFilev1 "arete/pkg/api/solution/v1"

	"gopkg.in/yaml.v3"
	"github.com/manifoldco/promptui"
	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"
	"github.com/spf13/viper"
	"sigs.k8s.io/kustomize/kyaml/kio"
	kyaml "sigs.k8s.io/kustomize/kyaml/yaml"
)

// PromptIdentifier is the comment pattern that will be searched for in the solutions
// yaml config files
const PromptIdentifier = "# arete-prompt"

// Prompts store the found key/value scalar yaml nodes in a solutions config files
// as well as the prompted results from the user
type Prompts struct {
	Prompts []Prompt
	Results []Result
}

type Prompt struct {
	Name string
	Value string
}

type Result struct {
	Name string
	Value string
}

var decoder map[string]interface{}

// SetPrompt adds a new prompt to the prompt struct map
func (p *Prompts) SetPrompt(node *kyaml.MapNode) {
	if testPromptComment(node.Value.YNode().LineComment) {
		p.Prompts = append(p.Prompts, Prompt{Name: node.Key.YNode().Value, Value: node.Value.YNode().Value})
	}
}

// run the prompts that have been set to get user input
func (p *Prompts) runPrompts() {

	fmt.Println("Please set this solutions required values")

	for _, v := range p.Prompts {
		prompt := promptui.Prompt{
			Label: v.Name,
		}

		result, err := prompt.Run()

		if err != nil {
			log.Fatal().Err(err).Msg("Error running prompt command")
		}

		p.Results = append(p.Results, Result{Name: v.Name, Value: result})
	}
}

// solutionDeployCmd is the cobra command that represents the solution deploy sub command
func SolutiondeployRun(solutionName string, fromCache bool, dryRun bool) {
		pr := Prompts{}
		solutionFile := solutionFilev1.SolutionFile{}

		log.Logger = log.Output(zerolog.ConsoleWriter{Out: os.Stdout})

		sl := cmdsolution.SolutionsList{}
		err := sl.GetSolutions()

		if err != nil {
			log.Fatal().Err(err).Msg("")
		}

		url, err := sl.GetUrl(solutionName)

		if err != nil {
			if viper.GetBool("verbose") {
				log.Debug().Msg(sl.String())
			}

			log.Fatal().Err(err).Msg("")
		}

		cacheDir := viper.GetString("cache") + "/" + solutionName

		_, statErr := os.Stat(cacheDir)

		if !fromCache {
			if statErr == nil {
				os.RemoveAll(cacheDir)
			}

			log.Info().Msg("Pulling package from repo...")
			
			// Use KPT to pull down the package
			resp, err := utils.CallCommand(utils.Kpt, []string{"pkg", "get", url, cacheDir}, false)
			
			if err != nil {
				log.Error().Err(err).Msg(string(resp))
				return
			}

			if viper.GetBool("verbose") {
				log.Debug().Msg(string(resp))
			}
		} else {

			if statErr != nil {
				log.Fatal().Err(statErr).Msg("from-cache was used but that solution was not found in local cache dir")
			}

			log.Info().Msg("Using local cached copy of the package...")
		}

		data, err := os.ReadFile(filepath.Join(cacheDir, "Kptfile"))

		if err != nil {
			log.Error().Err(err).Msg("Unable to read Kptfile for solution")
			return
		}

		// Unmarshal the Kptfile YAML file and search for any configPaths in the pipline / mutators
		// section. If found then  parse the configPath file mutator and search for the PromptIdentifier
		yaml.Unmarshal(data, &decoder)
		
		for pipeline, configPaths := range decoder {
			if pipeline == "pipeline" && reflect.TypeOf(configPaths).Kind() == reflect.Map {
				for mutator, mutators := range configPaths.(map[string]interface{}) {
					if mutator == "mutators" && reflect.TypeOf(mutators).Kind() == reflect.Slice {
						for configPath, path := range mutators.([]interface{})[0].(map[string]interface{}) {
							if configPath == "configPath" {
								processConfigMutator(filepath.Join(cacheDir, path.(string)), &pr)
							}
						}
					}
				}
			}
		}

		log.Info().Msg("Updating solutions settings....")
		
		res, err := utils.CallCommand(utils.Kpt, []string{"fn", "render", cacheDir}, false)

		if err != nil {
			log.Fatal().Err(err).Msg("Rendering KPT solution failed: " + cacheDir)
		}


		if viper.GetBool("verbose") {
			log.Debug().Msg(strings.TrimSuffix(string(res), "\n"))
		}

		solutionYaml := filepath.Join(cacheDir, "solution.yaml")
		_, statErr = os.Stat(solutionYaml)

		if statErr == nil {
			data, err := os.ReadFile(solutionYaml)

			if err != nil {
				log.Error().Msg("solution.yaml file found but unable to parse")
				return
			}

			yaml.Unmarshal(data, &solutionFile)

			if !solutionFile.Deploy.IsEmpty() &&
			!solutionFile.Deploy.Stage.IsEmpty() &&
			!solutionFile.Deploy.Stage.Infra.IsEmpty() {
				if !solutionFile.Deploy.Stage.Infra.Requires.IsEmpty() {
					useKCCSA, _ := strconv.ParseBool(solutionFile.Deploy.Stage.Infra.Requires.UseConfigConnectorSA)

					err := setKubeContext(solutionFile.Deploy.Stage.Infra.KubeContext)

					if err != nil {
						log.Error().Err(err).Msg("There was an error while tyring to set the kube context using the infra deploy stage in the solutions solution.yaml file")
						err = nil
					}

					saAccount, err := getConfigConnector()

					if err != nil {
						log.Fatal().Err(err).Msg("Unable to find config connector installed on cluster")
					}

					if !useKCCSA {
						saAccount = ""
					} else {
						saAccount = "serviceAccount:" + saAccount
					}

					err = createPolicyBindingCall(solutionFile.Deploy.Stage.Infra.Requires.Iam, saAccount)

					if err != nil {
						log.Error().Err(err).Msg("Unable to set IAM policies for infra deploy stage")
					}
				}
			}
		}

		log.Info().Msg("Getting kubectl current context....")

		config, err := utils.CallCommand(utils.Kubectl, []string{"config", "current-context"}, false)

		if err != nil {
			log.Error().Err(err).Msg(string(config))
			return
		}

		if viper.GetBool("verbose") {
			log.Debug().Msg(string(config))
		}

		lbl := "Is this the correct kubectl context: " + strings.TrimSuffix(string(config), "\n")
		kbctlPrompt := promptui.Select {
			Label: lbl,
			Items: []string{"Yes", "No"},
		}

		_, yn, err := kbctlPrompt.Run()

		if err != nil {
			log.Error().Err(err).Msg("")
		}

		if yn == "No" {
			log.Error().Msg("Please change your kubectl context to proper context and run again")
			os.Exit(1)
		}

		res, err = utils.CallCommand(utils.Kpt, []string{"live", "init", cacheDir}, false)

		if err != nil {
			log.Fatal().Err(err).Msg("Unable to inialize kpt for " + cacheDir)
		}

		if viper.GetBool("verbose") {
			log.Debug().Msg(strings.TrimSuffix(string(res), "\n"))
		}

		var cmdArgs []string

		if !dryRun {
			cmdArgs = []string{"live", "apply", "--install-resource-group", cacheDir}
		} else {
			cmdArgs = []string{"live", "apply", "--dry-run", cacheDir}
		}

		log.Info().Msg("Executing kpt live apply.....")
		
		// Streaming output since we are not setting the reconcile timeout. Good idea?
		res, err = utils.CallCommand(utils.Kpt, cmdArgs, true)

		if err != nil {
			log.Fatal().Err(err).Msg("Applying solution using KPT failed" + cacheDir)
		}

		if viper.GetBool("verbose") || dryRun {
			log.Debug().Msg(strings.TrimSuffix(string(res), "\n"))
		}

		if !dryRun {
			log.Info().Msg("Solution has been deployed")
		}
}

// testPromptComment tests line comments to see if the PromptIdentifier is present
func testPromptComment(lineComment string) bool {
	return strings.HasPrefix(lineComment, PromptIdentifier)
}

// process the Kptfile mutators configPaths and search for any comments that match the PromptIdentifier
func processConfigMutator(configPath string, pr *Prompts) {
	data, err := os.ReadFile(configPath)

	if err != nil {
		log.Error().Err(err).Msg("Unable to read configPath file")
		return
	}

	kptFile, _ := kio.FromBytes(data)

	if len(kptFile) > 0 {
		walk(kptFile[0], pr)
		pr.runPrompts()

		err := modifyConfig(pr, configPath, data)

		if err != nil {
			log.Fatal().Err(err).Msg("Unable to modify solutions config file")
		}
	} else {
		if viper.GetBool("verbose") {
			log.Debug().Msg("No Kptfile was found for the solution or the Kptfile is malformed")
		}
	}
}

// modifyConfig will modify the configPath file using a simple search replace for the key/value scalar values that
// have the prompt identifier
func modifyConfig(pr *Prompts, configPath string, orgData []byte) error {
	newContent := string(orgData)

	for i, p := range pr.Prompts {
		newContent = strings.Replace(newContent, p.Name + ": " + p.Value, pr.Results[i].Name + ": " + pr.Results[i].Value, 1)
	}

	if err := os.WriteFile(configPath, []byte(newContent), 0644); err != nil {
		return err
	}

	return nil
}

// walk the kyaml.RNode to check the type. Keeping this function in-case there is a use-case
// that the walkMapping doesn't cover and more node types need to be added here.
func walk(node *kyaml.RNode, pr *Prompts) error {
	switch node.YNode().Kind {
	case kyaml.MappingNode:
		if err := walkMapping(node, pr); err != nil {
			return err
		}
	}
	return nil
}

// walkMapping walks the YAML mapping node type. This should be the only real node type we care about
// since we can keep diving through the scalars and maps in this reoccuring function.
func walkMapping(object *kyaml.RNode, pr *Prompts) error {
	return object.VisitFields( func(node *kyaml.MapNode) error {
		if node.Value.YNode().Kind == kyaml.MappingNode {
			walkMapping(node.Value, pr)
		}

		pr.SetPrompt(node)
		return nil
	})
}

// create a gcloud add-iam-policy-binding call based upon the IAM structure in the solution.yaml file
func createPolicyBindingCall(iam []solutionFilev1.Iam, memberReplacement string) error {
	if len(iam) > 0 {
		log.Info().Msg("Setting IAM policies...")
	} else {
		return nil
	}
	
	level := ""
	member := ""

	for _, iam := range iam {
		switch strings.ToLower(iam.Resource.Level) {
		case "org", "organization", "organizations", "orgs":
			level = "organizations"
		case "project", "prj", "projects", "proj":
			level = "projects"
		}

		if level == "" {
			return errors.New("unable to determine resource level for iam, check your solution.yaml manifest")
		}

		if memberReplacement == "" {
			member = iam.Member
		} else {
			member = memberReplacement
		}

		memberKey := fmt.Sprintf("--member=%s", member)
		role := fmt.Sprintf("--role=%s", iam.Role)
		
		ret, err := utils.CallCommand(utils.Gcloud, []string{level, "add-iam-policy-binding", iam.Resource.Id, memberKey, role}, false)

		if err != nil {
			return err
		}

		if viper.GetBool("verbose") {
			log.Debug().Msg(string(ret))
		}
	}

	return nil
}

// set the kube context based upon the settings specified in the solution.yaml file
func setKubeContext (kubeContext *solutionFilev1.KubeContext) error {
	if !kubeContext.IsEmpty() {
		log.Info().Msg("Checking kube context settings...")
		cmdArgs := []string{"container", "clusters", "get-credentials"}

		if len(kubeContext.ClusterName) == 0 {
			return errors.New("unable to set kube context as the cluster name key is missing in the solution.yaml")
		} else {
			cmdArgs = append(cmdArgs, kubeContext.ClusterName)
		}

		if len(kubeContext.Region) > 0 && len(kubeContext.Zone) > 0 {
			return errors.New("region and zone have both been set in the kube context. Set region key if the  config connector cluster is regional OR set zone if the cluster is zonal, not both")
		} else {
			if len(kubeContext.Region) > 0 {
				cmdArgs = append(cmdArgs, "--region=" + kubeContext.Region)
			} else if len(kubeContext.Zone) > 0 {
				cmdArgs = append(cmdArgs, "--zone=" + kubeContext.Zone)
			}
		}

		if len(kubeContext.Project) == 0 {
			return errors.New("project key is not set in the kubecontext, project is required")
		}

		cmdArgs = append(cmdArgs, "--project=" + kubeContext.Project)

		useInternalIP, _ := strconv.ParseBool(kubeContext.InternalIP)

		if useInternalIP {
			cmdArgs = append(cmdArgs, "--internal-ip")
		}

		ret, err := utils.CallCommand(utils.Gcloud, cmdArgs, false)

		if err != nil {
			return err
		}

		if viper.GetBool("verbose") {
			log.Debug().Msg(string(ret))
		}
	}

	return nil
}

// check if config connector is install on the k8s cluster. This will use the currently set kube context.
func getConfigConnector() (string, error) {
	log.Info().Msg("Checking for config connector...")

	cmdArgs := []string{"get", "ConfigConnectorContext", "-n", "config-control", "-o", "jsonpath='{.items[0].spec.googleServiceAccount}'"}
	saAccount, err := utils.CallCommand(utils.Kubectl, cmdArgs, false)

	if err != nil {
		if len(saAccount) > 0 {
			err = errors.New(string(saAccount) + err.Error())
		}

		return "", err
	}

	return strings.Replace(string(saAccount), "'", "", -1), nil
}