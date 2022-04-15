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
	"os/exec"
	"os"
	"strings"
	"github.com/manifoldco/promptui"
	"github.com/spf13/cobra"
	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"
	"arete/pkg/utils"
)

var region, project, billing string
var gcloud string = "gcloud"

// createCmd represents the create command
var createCmd = &cobra.Command{
	Use:   "create <instance-name>",
	Short: "Create a new Config Controller instance",
	Example: ` arete create my-awesome-kcc --region=us-central1
	arete create my-awesome-kcc --region=us-central1 --project=my-awesome-project --billing=111111-111A1A-AAAAA1`,
	Args: cobra.MinimumNArgs(1),
	Run: func(cmd *cobra.Command, args []string) {
		log.Logger = log.Output(zerolog.ConsoleWriter{Out: os.Stderr})

		if project == "" {
			project = args[0] + "-" + utils.RandomString(5)
			log.Info().Msgf("Project name will be set to: %s", project)
		}

		if billing == "" {
			if rtr := billingPrompt(); rtr != 0 {
				return
			}
		}
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

// billingPrompt will pull the list of billing accounts using glcoud that the current user has access to
// and prompt them to select one to use to for the command
func billingPrompt() int {
	var opts []string

	if verbose {
		log.Debug().Msg("Calling gcloud alpha billing accounts list")
	}

	args := []string{"alpha", "billing", "accounts", "list", "--format=value[separator=' - '](NAME, ACCOUNT_ID)"}
	cmd := exec.Command(gcloud, args...)
	out, err := cmd.CombinedOutput()

	if err != nil {
		log.Error().Err(err).Msg(string(out))
		return 1
	}

	sp := strings.Split(string(out), "\n")
	sp = sp[:len(sp)-1] // pop off the last element as it's a blank newline element

	for i := 0; i < len(sp); i++ {
		opts = append(opts, sp[i])
	}

	 prompt := promptui.Select{
		 Label: "Choose a billing account",
		 Items: opts,
	 }

	 _, result, err := prompt.Run()

	 if err != nil {
		 log.Error().Err(err).Msg("Prompt failed")
		 return 1
	 }
	billing = result[strings.Index(result, " - ") + 3:]

	return 0
}