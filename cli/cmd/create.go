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
	"arete/internal/cmdcreate"
	"github.com/spf13/cobra"
)

var region, project, billing string

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
		cmdcreate.CmdcreateRun(args[0], region, project, billing)
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
