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

package cmdcreate

import (
	"os"
	"path/filepath"
	"strings"

	"arete/pkg/utils"

	"github.com/manifoldco/promptui"
	"github.com/rs/zerolog/log"
	"github.com/spf13/viper"
	"gopkg.in/yaml.v3"
)

var currentRegions = []string{"us-central1", "us-east1", "northamerica-northeast1",	"northamerica-northeast2",	 "europe-north1",	"europe-west1",	"europe-west3",	"australia-southeast1",	"australia-southeast2",	"asia-northeast1",	"asia-northeast2"}

type createSteps struct {
	Clusters []clusters `yaml:"clusters"`
}

type clusters struct{
	Cluster string `yaml:"cluster"`
	Steps []string `yaml:""`
}

func (cs *createSteps) clusterExists(cluster string) bool {
	for _, cls := range cs.Clusters {
		if cls.Cluster == cluster {
			return true
		}
	}

	return false
}

// Does the step exist in the .create yaml file
func (cs *createSteps) stepExists(cluster string, step string) bool {
	for _, cls := range cs.Clusters {
		if cls.Cluster == cluster {
			for _, stp := range cls.Steps {
				if stp == step {
					return true
				}
			}

			return false;
		}
	}

	return false
}

// createCmd represents the create command
func CmdcreateRun(instanceName string, region string, project string, billing string) {
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

	// project flag not provided to create a random project name based on the cluster name and random string
	if project == "" {
		project = instanceName + "-" + utils.RandomString(5)
		log.Info().Msgf("Project name will be set to: %s", project)
	}

	// check to see if the .create yaml file exists, if not create it
	// The .create file keeps track of steps that have already been completed for repeated calls to the create function.
	createStepsFile := filepath.Join(viper.GetString("cache"), ".create")
	createSteps := createSteps{}

	if _, err := os.Stat(createStepsFile); err != nil {
		createYaml := "clusters:\n  - cluster: " + instanceName + "\n    steps:\n"

		utils.WriteToCache(&createYaml, ".create", false)
	} else {
		stepsFileContents, err := os.ReadFile(createStepsFile)

		if err == nil {
			yaml.Unmarshal(stepsFileContents, &createSteps)
		}

		if(!createSteps.clusterExists(instanceName)) {
			createYaml := "  - cluster: " + instanceName + "\n    steps:\n"

			if err := utils.WriteToCache(&createYaml, ".create", true); err != nil {
				log.Fatal().Err(err).Msg("")
			}

			stepsFileContents, err := os.ReadFile(createStepsFile)

			if err == nil {
				yaml.Unmarshal(stepsFileContents, &createSteps)
			}
		}
	}

	// Test if project exists
	rtr, err := utils.CallCommand(utils.Gcloud, []string{"projects", "list", "--filter=projectId:" + project , "--format=\"yaml\""}, false)

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

		billRes, err := utils.CallCommand(utils.Gcloud, cmdArgs, false)

		if err != nil {
			log.Fatal().Err(err).Msg("Unable to assign billing account to project: " + string(billRes))
		}
	}

	// If the GCP services have not already been enabled by the cli then let's do it.
	if !createSteps.stepExists(instanceName, "services") {
		log.Info().Msg("Enabling required services...")

		cmdArgs := []string{"services", "enable", "krmapihosting.googleapis.com", "container.googleapis.com", "cloudresourcemanager.googleapis.com", "cloudbilling.googleapis.com", "--project=" + project}

		_, err := utils.CallCommand(utils.Gcloud, cmdArgs, true)

		if err != nil {
			log.Fatal().Err(err).Msg("")
		}

		saveStep(instanceName, "services")
	}

	networkConfig := map[string]interface{}{"name": "kcc-controller", "subnet-name": "kcc-regional-subnet", "cidr": "192.168.0.0/16"}

	if viper.InConfig("network") {
		networkConfig = viper.GetStringMap("network")
	}

	// If the VPC has not already been created by the cli then let's do it
	if !createSteps.stepExists(instanceName, "network") {
		// BUT first let's check to make sure that the network with the same name doesn't already exist
		cmdArgs := []string{"compute", "networks", "list", "--project=" + project, "--filter=name:" + networkConfig["name"].(string), "--format=\"yaml\""}

		ret, err := utils.CallCommand(utils.Gcloud, cmdArgs, false)

		if err != nil {
			log.Fatal().Err(err).Msg(string(ret))
		}

		if len(string(ret)) == 0 {
			cmdArgs = []string{"compute", "networks", "create", networkConfig["name"].(string), "--project=" + project, "--subnet-mode=custom"}

			log.Info().Msg("Creating Network...")

			ret, err = utils.CallCommand(utils.Gcloud, cmdArgs, false)

			if err != nil {
				log.Fatal().Err(err).Msg(string(ret))
			}

			saveStep(instanceName, "network")
		} else {
			saveStep(instanceName, "network")
		}
	}

	// If the subnet on the VPC has not already been created by the cli then let's do it
	if !createSteps.stepExists(instanceName, "subnet") {
		// BUT first let's check to make sure that a subnet with the same name doesn't already exist
		cmdArgs := []string{"compute", "networks", "subnets", "list", "--project=" + project, "--filter=name:" + networkConfig["subnet-name"].(string), "--format=\"yaml\""}

		ret, err := utils.CallCommand(utils.Gcloud, cmdArgs, false)

		if err != nil {
			log.Fatal().Err(err).Msg(string(ret))
		}

		if len(string(ret)) == 0 || strings.Contains(strings.ToLower(string(ret)), "warning") {
			cmdArgs = []string{"compute", "networks", "subnets", "create", networkConfig["subnet-name"].(string), "--network=" + networkConfig["name"].(string), "--range=" + networkConfig["cidr"].(string), "--enable-private-ip-google-access", "--region=" + region, "--project=" + project}

			log.Info().Msg("Creating subnet....")

			ret, err = utils.CallCommand(utils.Gcloud, cmdArgs, false)

			if err != nil {
				log.Fatal().Err(err).Msg(string(ret))
			}

			saveStep(instanceName, "subnet")
		} else { 
			saveStep(instanceName, "subnet")
		}
	}

	// If config controller hasn't already been setup by the cli then let's do it
	if !createSteps.stepExists(instanceName, "config-controller") {
		cmdArgs := []string{"anthos", "config", "controller", "create", instanceName, "--location=" + region, "--network=" + networkConfig["name"].(string), "--subnet=" + networkConfig["subnet-name"].(string), "--project=" + project}

		log.Info().Msg("Creating Config Controller Cluster....")

		_, err := utils.CallCommand(utils.Gcloud, cmdArgs, true)

		if err != nil {
			log.Fatal().Err(err).Msg("")
		}

		saveStep(instanceName, "config-controller")
	}

	// Adding service account to the owners role
	if !createSteps.stepExists(instanceName, "add-policy") {
		cmdArgs := []string{"container", "clusters", "get-credentials", "krmapihost-" + instanceName, "--region=" + region, "--project=" + project}

		_, err := utils.CallCommand(utils.Gcloud, cmdArgs, false)

		if err != nil {
			log.Fatal().Err(err).Msg("Unable to get configconnectorcontext")
		}

		cmdArgs = []string{"get", "ConfigConnectorContext", "-n", "config-control", "-o", "jsonpath='{.items[0].spec.googleServiceAccount}'"}

		ret, err := utils.CallCommand(utils.Kubectl, cmdArgs, false)

		if err != nil {
			log.Fatal().Err(err).Msg("Unable to get configconnectorcontext")
		}

		sa := strings.Replace(strings.Split(strings.Split(string(ret), "@")[0], "'")[1] + "@" + strings.Split(string(ret), "@")[1], "'", "",1)

		cmdArgs = []string{"projects", "add-iam-policy-binding", project, `--member=serviceAccount:` + sa, `--role=roles/owner`, `--condition=None`}

		log.Info().Msg("Add SA to roles/owner role...")
		ret, err = utils.CallCommand(utils.Gcloud, cmdArgs, false)

		if err != nil {
			log.Fatal().Err(err).Msg("Unable to add roles/owner to " + sa + string(ret))
		}

		saveStep(instanceName, "add-policy")
	}

	log.Info().Msg("Config Controller setup complete")
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

	_, err = utils.CallCommand(utils.Gcloud, cmdArgs, true)

	if err != nil {
		return err
	}

	return nil
}

// Generic select prompt from a gcloud list command
func selectGcloudPrompt(args []string, label string) (string, error) {
	var opts []string

	if viper.GetBool("verbose") {
		log.Debug().Msg("Calling gcloud "+label+" list")
	}

	out, err := utils.CallCommand(utils.Gcloud, args, false)

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
func saveStep(cluster string, step string) error {
	step = "      - " + step + "\n"

	if err := utils.WriteToCache(&step, ".create", true); err != nil {
		return err
	}

	return nil
}
