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
	"arete/internal/cmdsolutiondeploy"
	"github.com/spf13/cobra"
)

// dryRun or live apply the solution. This is set from a flag
var dryRun bool

// fromCache tells the CLI to not download the solution from GIT but use the local cache version
var fromCache bool

// solutionDeployCmd is the cobra command that represents the solution deploy sub command
var solutionDeployCmd = &cobra.Command{
	Use:   "deploy <solution-name>",
	Short: "Deploy a solution",
	Args: cobra.MinimumNArgs(1),
	Run: func(cmd *cobra.Command, args []string) {
		cmdsolutiondeploy.SolutiondeployRun(args[0], fromCache, dryRun)
	},
}

// init the command and add flags
func init() {
	solutionCmd.AddCommand(solutionDeployCmd)

	solutionDeployCmd.Flags().BoolVar(&dryRun, "dry-run", false, "kpt will validate the resources in the package and print which resources will be applied and which resources will be pruned, but no resources will be changed.")

	solutionDeployCmd.Flags().BoolVar(&fromCache, "from-cache", false, "Don't pull down a copy of the solution from the remote GIT URL but use the local cached version")
}