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

package cmd

import (
	"arete/pkg/utils"

	"fmt"
	"os"
	"strings"
	
	"github.com/manifoldco/promptui"
	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"
	"github.com/spf13/cobra"
	"github.com/spf13/viper"
	"sigs.k8s.io/kustomize/kyaml/kio"
	kyaml "sigs.k8s.io/kustomize/kyaml/yaml"
)

const PromptIdentifier = "# arete-prompt"
var dryRun bool

type SetPrompts struct {
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

// solutionCmd represents the create command
var solutionDeployCmd = &cobra.Command{
	Use:   "deploy <solution-name>",
	Short: "Deploy a solution",
	Args: cobra.MinimumNArgs(1),
	Run: func(cmd *cobra.Command, args []string) {
		var url string
		var pipeline interface{}
		var mutator map[string]interface{}
		pr := SetPrompts{}

		log.Logger = log.Output(zerolog.ConsoleWriter{Out: os.Stdout})

		sl, err := GetCoreSolutions() // Update the core solutions from GitHub

		if err != nil {
			return
		}

		if url = sl.Solutions[args[0]].Url; url == "" {
			if viper.GetBool("verbose") {
				log.Debug().Msg(sl.String())
			}

			log.Fatal().Msg("Solution not found in list")
		}

		cacheDir := viper.GetString("cache") + "/" + args[0]

		if _, err := os.Stat(cacheDir); err == nil {
			os.RemoveAll(cacheDir)
		}

		log.Info().Msg("Pulling package from repo...")

		// Use KPT to pull down the package
		resp, err := utils.CallCommand("kpt", []string{"pkg", "get", url, cacheDir})
		
		if err != nil {
			log.Error().Err(err).Msg(string(resp))
			return
		}

		if viper.GetBool("verbose") {
			log.Debug().Msg(string(resp))
		}

		data, err := os.ReadFile(cacheDir + "/Kptfile")

		if err != nil {
			log.Error().Err(err).Msg("Unable to read Kptfile for solution")
			return
		}

		kptFile, _ := kio.FromBytes(data)

		if pipeline, err = kptFile[0].GetFieldValue("pipeline"); err != nil {
			log.Fatal().Err(err).Msg("Unable to find solutions Kptfile pipeline")
		}

		for i, pipe := range pipeline.(map[string]interface{}) {
			if i == "mutators" {
				for _, pipe := range pipe.([]interface{}) {
					mutator = pipe.(map[string]interface{})

					if configPath, ex := mutator["configPath"]; ex {
						processConfigMutator(cacheDir + "/" + configPath.(string), &pr)
					}
				}
			}
		}

		log.Info().Msg("Updating solutions settings....")
		
		res, err := utils.CallCommand("kpt", []string{"fn", "render", cacheDir})

		if err != nil {
			log.Fatal().Err(err).Msg("Rendering KPT solution failed: " + cacheDir)
		}

		if viper.GetBool("verbose") {
			log.Debug().Msg(strings.TrimSuffix(string(res), "\n"))
		}

		log.Info().Msg("Getting kubectl current context....")

		config, err := utils.CallCommand("kubectl", []string{"config", "current-context"})

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

		res, err = utils.CallCommand("kpt", []string{"live", "init", cacheDir})

		if err != nil {
			log.Fatal().Err(err).Msg("Unable to inialize kpt for " + cacheDir)
		}

		if viper.GetBool("verbose") {
			log.Debug().Msg(strings.TrimSuffix(string(res), "\n"))
		}

		var cmdArgs []string

		if !dryRun {
			cmdArgs = []string{"live", "apply", "--reconcile-timeout=2m", cacheDir}
		} else {
			cmdArgs = []string{"live", "apply", "--reconcile-timeout=2m", "--dry-run", cacheDir}
		}

		log.Info().Msg("Executing kpt live apply.....")
		
		res, err = utils.CallCommand("kpt", cmdArgs)

		if err != nil {
			log.Fatal().Err(err).Msg("Applying solution using KPT failed" + cacheDir)
		}

		if viper.GetBool("verbose") || dryRun {
			log.Debug().Msg(strings.TrimSuffix(string(res), "\n"))
		}

		if !dryRun {
			log.Info().Msg("Solution has been deployed")
		}
	},
}

// init the command and add flags
func init() {
	solutionCmd.AddCommand(solutionDeployCmd)

	solutionDeployCmd.Flags().BoolVar(&dryRun, "dry-run", false, "kpt will validate the resources in the package and print which resources will be applied and which resources will be pruned, but no resources will be changed.")
}

func processConfigMutator(configPath string, pr *SetPrompts) {
	data, err := os.ReadFile(configPath)

	if err != nil {
		log.Error().Err(err).Msg("Unable to read configPath file")
		return
	}

	kptFile, _ := kio.FromBytes(data)

	if dataMap := kptFile[0].GetDataMap(); len(dataMap) != 0 {
		setPrompts(dataMap, pr)

		walk(kptFile[0], "", pr)

		if pr, l := comparePrompts(pr); l > 0 {
			runPrompts(pr)

			err := modifyConfig(pr, configPath, data)

			if err != nil {
				log.Fatal().Err(err).Msg("Unable to modify solution setter config file")
			}
		} else {
			log.Info().Msg("No solution substitutions were found")
		}
	}
}

func modifyConfig(pr *SetPrompts, configPath string, orgData []byte) error {
	newContent := string(orgData)

	for i, p := range pr.Prompts {
		newContent = strings.Replace(newContent, p.Name + ": " + p.Value, pr.Results[i].Name + ": " + pr.Results[i].Value, 1)
	}

	os.WriteFile(configPath, []byte(newContent), 0644)

	return nil
}

func runPrompts(prs *SetPrompts) {

	fmt.Println("Please set this solutions required values")

	for _, v := range prs.Prompts {
		prompt := promptui.Prompt{
			Label: v.Name,
		}

		result, err := prompt.Run()

		if err != nil {
			log.Fatal().Err(err).Msg("Error running prompt command")
		}

		prs.Results = append(prs.Results, Result{Name: v.Name, Value: result})
	}
}

func comparePrompts(pr *SetPrompts) (*SetPrompts, int) {
	newPrompts  := SetPrompts{}

	for _, r := range pr.Results {
		for _, v := range pr.Prompts {
			if r.Value == v.Value {
				newPrompts.Prompts = append(newPrompts.Prompts, Prompt{Name: v.Name, Value: v.Value})
			}
		}
	}
	return &newPrompts, len(newPrompts.Prompts)
}

func setPrompts(dataMap map[string]string, pr *SetPrompts) {
	for k, v := range dataMap {
		pr.Prompts = append(pr.Prompts, Prompt{Name: k, Value: v})
	}	
}

// Walk pattern was copied from the KPT apply-setters function
// https://github.com/GoogleContainerTools/kpt-functions-catalog/tree/master/functions/go/apply-setters

func walk(node *kyaml.RNode, p string, pr *SetPrompts) error {
	switch node.YNode().Kind {
	case kyaml.DocumentNode:
		fmt.Println("DocumentNode")
	case kyaml.MappingNode:
		if err := walkMapping(node, p); err != nil {
			return err
		}

		return node.VisitFields( func(node *kyaml.MapNode) error {
			return walk(node.Value, p + " " + node.Key.YNode().Value, pr)
		})
	case kyaml.SequenceNode:
		fmt.Println("Seq")
	case kyaml.ScalarNode:
		return visitScalar(node, p, pr)
	}

	return nil
}

func walkMapping(object *kyaml.RNode, path string) error {
	return object.VisitFields( func(node *kyaml.MapNode) error {
		lineComment := node.Key.YNode().LineComment

		if !testPromptComment(lineComment) {
			return nil
		}


		return nil
	})
}

func visitScalar(node *kyaml.RNode, path string, pr *SetPrompts) error {
	if !testPromptComment(node.YNode().LineComment) {
		return nil
	}

	pr.Results = append(pr.Results, Result{Value: node.YNode().Value})

	return nil
}

// testPromptComment tests line comments to see if the PromptIdentifier is present
func testPromptComment(lineComment string) bool {
	return strings.HasPrefix(lineComment, PromptIdentifier)
}
