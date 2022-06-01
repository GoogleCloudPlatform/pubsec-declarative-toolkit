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
	"os"
	"path/filepath"
	"strings"

	"arete/pkg/utils"

	"github.com/manifoldco/promptui"
	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"
	"github.com/spf13/cobra"
	"github.com/spf13/viper"
	"gopkg.in/yaml.v3"
)

var region, project, billing string
var gcloud string = "gcloud"
var currentRegions = []string{"us-central1", "us-east1", "northamerica-northeast1", "europe-north1", "australia-southeast1", "asia-northeast1"}

type createSteps struct {
	Steps []step `yaml:"steps"`
}

type step struct {
	Step string `yaml:"step"`
}

// Does the step exist in the .create yaml file
func (cs *createSteps) stepExists(step string) bool {
	for _, stp := range cs.Steps {
		if stp.Step == step {
			return true
		}
	}

	return false
}

// createCmd represents the create command
var createCmd = &cobra.Command{
	Use:   "create <instance-name>",
	Short: "Create a new Config Controller instance",
	Long: `
 The arete create command will create a new config controller instance for you, it can either use an existing project or create
 a new one for you. Arete will check to make sure that the project exists, if it does not exist then arete will attempt to
 create project and either prompt for a billing account or if the --billing flag is present it will use that billing ID`,
	Example: ` arete create my-awesome-kcc --region=us-central1 # This will create a new project and prompt for billing ID
 arete create my-awesome-kcc --region=us-central1 --project=my-awesome-project # This will utilize an existing project`,
	Args: cobra.MinimumNArgs(1),
	Run: func(cmd *cobra.Command, args []string) {
		log.Logger = log.Output(zerolog.ConsoleWriter{Out: os.Stderr})

		regionFound := false
		regionMsg := "Unsupported region. Please choose one of: \n"

		for i := 0; i < len(currentRegions); i++ {
			regionMsg += " - " + currentRegions[i] + "\n"
			if region == currentRegions[i] {
				regionFound = true
			}
		}

		if !regionFound {
			log.Fatal().Msg(regionMsg)
		}

		// check to see if the .create yaml file exists, if not create it
		// The .create file keeps track of steps that have already been completed for repeated calls to the create function.
		createStepsFile := filepath.Join(viper.GetString("cache"), ".create")
		createSteps := createSteps{}

		if _, err := os.Stat(createStepsFile); err != nil {
			createYaml := "steps:\n"

			utils.WriteToCache(&createYaml, ".create", false)
		} else {
			stepsFileContents, err := os.ReadFile(createStepsFile)

			if err == nil {
				yaml.Unmarshal(stepsFileContents, &createSteps)
			}
		}

		// project flag not provided to create a random project name based on the cluster name and random string
		if project == "" {
			project = args[0] + "-" + utils.RandomString(5)
			log.Info().Msgf("Project name will be set to: %s", project)
		}

		// Test if project exists
		rtr, err := utils.CallCommand(gcloud, []string{"projects", "list", "--filter=projectId:" + project , "--format=\"yaml\""}, false)

		if err != nil {
			log.Fatal().Err(err).Msg("")
		}

		// If no project exists (or the user doesn't have access to it) let's create one
		if len(string(rtr)) == 0 {
			// billing flag not used, pull billing accounts and prompt the user to select one
			if billing == "" {
				billing, err = selectGcloudPrompt([]string{"alpha", "billing", "accounts", "list", "--format=value[separator=' - '](NAME, ACCOUNT_ID)"}, "billing account")

				if err != nil {
					log.Fatal().Err(err).Msg("Unable to generate billing prompt")
				}
			}

			err := createProject(project, billing)

			if err != nil {
				log.Fatal().Err(err).Msg("")
			}

			cmdArgs := []string{"beta", "billing", "projects", "link", project, "--billing-account", billing}

			billRes, err := utils.CallCommand(gcloud, cmdArgs, false)

			if err != nil {
				log.Fatal().Err(err).Msg("Unable to assign billing account to project: " + string(billRes))
			}
		}

		// If the GCP services have not already been enabled by the cli then let's do it.
		if !createSteps.stepExists("services") {
			log.Info().Msg("Enabling required services...")

			cmdArgs := []string{"services", "enable", "krmapihosting.googleapis.com", "container.googleapis.com", "cloudresourcemanager.googleapis.com", "cloudbilling.googleapis.com", "--project=" + project}

			_, err := utils.CallCommand(gcloud, cmdArgs, true)

			if err != nil {
				log.Fatal().Err(err).Msg("")
			}

			saveStep("services")
		}

		networkConfig := map[string]interface{}{"name": "kcc-controller", "subnet-name": "kcc-regional-subnet", "cidr": "192.168.0.0/16"}

		if viper.InConfig("network") {
			networkConfig = viper.GetStringMap("network")
		}

		// If the VPC has not already been created by the cli then let's do it
		if !createSteps.stepExists("network") {
			// BUT first let's check to make sure that the network with the same name doesn't already exist
			cmdArgs := []string{"compute", "networks", "list", "--project=" + project, "--filter=name:" + networkConfig["name"].(string), "--format=\"yaml\""}

			ret, err := utils.CallCommand(gcloud, cmdArgs, false)

			if err != nil {
				log.Fatal().Err(err).Msg(string(ret))
			}

			if len(string(ret)) == 0 {
				cmdArgs = []string{"compute", "networks", "create", networkConfig["name"].(string), "--project=" + project, "--subnet-mode=custom"}

				log.Info().Msg("Creating Network...")

				ret, err = utils.CallCommand(gcloud, cmdArgs, false)

				if err != nil {
					log.Fatal().Err(err).Msg(string(ret))
				}

				saveStep("network")
			} else {
				saveStep("network")
			}
		}

		// If the subnet on the VPC has not already been created by the cli then let's do it
		if !createSteps.stepExists("subnet") {
			// BUT first let's check to make sure that a subnet with the same name doesn't already exist
			cmdArgs := []string{"compute", "networks", "subnets", "list", "--project=" + project, "--filter=name:" + networkConfig["subnet-name"].(string), "--format=\"yaml\""}

			ret, err := utils.CallCommand(gcloud, cmdArgs, false)

			if err != nil {
				log.Fatal().Err(err).Msg(string(ret))
			}

			if len(string(ret)) == 0 || strings.Contains(strings.ToLower(string(ret)), "warning") {
				cmdArgs = []string{"compute", "networks", "subnets", "create", networkConfig["subnet-name"].(string), "--network=" + networkConfig["name"].(string), "--range=" + networkConfig["cidr"].(string), "--enable-private-ip-google-access", "--region=" + region, "--project=" + project}

				log.Info().Msg("Creating subnet....")

				ret, err = utils.CallCommand(gcloud, cmdArgs, false)

				if err != nil {
					log.Fatal().Err(err).Msg(string(ret))
				}

				saveStep("subnet")
			} else { 
				saveStep("subnet")
			}
		}

		// If config controller hasn't already been setup by the cli then let's do it
		if !createSteps.stepExists("config-controller") {
			cmdArgs := []string{"anthos", "config", "controller", "create", args[0], "--location=" + region, "--network=" + networkConfig["name"].(string), "--subnet=" + networkConfig["subnet-name"].(string), "--project=" + project}

			log.Info().Msg("Creating Config Controller Cluster....")

			_, err := utils.CallCommand(gcloud, cmdArgs, true)

			if err != nil {
				log.Fatal().Err(err).Msg("")
			}

			saveStep("config-controller")
		}

		// Adding service account to the owners role
		if !createSteps.stepExists("add-policy") {
			cmdArgs := []string{"container", "clusters", "get-credentials", "krmapihost-" + args[0], "--region=" + region, "--project=" + project}

			_, err := utils.CallCommand(gcloud, cmdArgs, false)

			if err != nil {
				log.Fatal().Err(err).Msg("Unable to get configconnectorcontext")
			}

			cmdArgs = []string{"get", "ConfigConnectorContext", "-n", "config-control", "-o", "jsonpath='{.items[0].spec.googleServiceAccount}'"}

			ret, err := utils.CallCommand("kubectl", cmdArgs, false)

			if err != nil {
				log.Fatal().Err(err).Msg("Unable to get configconnectorcontext")
			}

			sa := strings.Replace(strings.Split(strings.Split(string(ret), "@")[0], "'")[1] + "@" + strings.Split(string(ret), "@")[1], "'", "",1)

			cmdArgs = []string{"projects", "add-iam-policy-binding", project, `--member=serviceAccount:` + sa, `--role=roles/owner`, `--condition=None`}

			log.Info().Msg("Add SA to roles/owner role...")
			ret, err = utils.CallCommand(gcloud, cmdArgs, false)

			if err != nil {
				log.Fatal().Err(err).Msg("Unable to add roles/owner to " + sa + string(ret))
			}

			saveStep("add-policy")
		}

		log.Info().Msg("Config Controller setup complete")
	},
}

// init the command and add flags
func init() {
	rootCmd.AddCommand(createCmd)

	createCmd.Flags().StringVarP(&project, "project", "p", "", "The new project ID to create for the Config Controller cluster. Default: <instance-name>")

	createCmd.Flags().StringVarP(&region, "region", "r", "", "REQUIRED: The GCP region to use when creating the instance")
	createCmd.MarkFlagRequired("region")

	createCmd.Flags().StringVarP(&billing, "billing", "b", "", "Billing account to be used for project and resources")
}

// Create a project at either the org or at a folder level.
func createProject(project string, billing string) error {
	var folderId string

	orgId, err := selectGcloudPrompt([]string{"organizations", "list", "--format=value[separator=' - '](DISPLAY_NAME, ID)"}, "organization ID")

	if err != nil {
		return err
	}

	prompt := promptui.Select{
		Label: "Would you like the project to be created at the Org level or in a folder",
		Items: []string{"Organization Level", "Folder Level"},
	}

	_, result, err := prompt.Run()

	if err != nil {
		return err
	}

	cmdArgs := []string{"projects", "create", project, "--set-as-default", "--labels=created-with-arete=true"}

	if result == "Folder Level" {
		folderId, err = selectGcloudPrompt([]string{"resource-manager", "folders", "list", "--organization="+orgId,  "--format=value[separator=' - '](DISPLAY_NAME, ID)"}, "folder")

		if err != nil {
			return err
		}

		cmdArgs = append(cmdArgs, "--folder="+folderId)
	} else {
		cmdArgs = append(cmdArgs, "--organization="+orgId)
	}

	_, err = utils.CallCommand(gcloud, cmdArgs, true)

	if err != nil {
		return err
	}

	return nil
}

// Generic select prompt from a gcloud list command
func selectGcloudPrompt(args []string, label string) (string, error) {
	var opts []string

	if verbose {
		log.Debug().Msg("Calling gcloud "+label+" list")
	}

	out, err := utils.CallCommand("gcloud", args, false)

	if err != nil {
		return "", err
	}

	sp := strings.Split(string(out), "\n")
	sp = sp[:len(sp)-1] // pop off the last element as it's a blank newline element

	for i := 0; i < len(sp); i++ {
		opts = append(opts, sp[i])
	}

	prompt := promptui.Select{
		Label: "Choose a " + label,
		Items: opts,
	}

	_, result, err := prompt.Run()

	if err != nil {
		return "", err
	}

	return result[strings.Index(result, " - ")+3:], nil
}

// Save a step to the cache .create file for future tracking
func saveStep(step string) error {
	step = "- step: " + step + "\n"

	if err := utils.WriteToCache(&step, ".create", true); err != nil {
		return err
	}

	return nil
}
