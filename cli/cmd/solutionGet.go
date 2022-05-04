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
	
	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"
	"github.com/spf13/cobra"
)

var branch, subFolder string

// solutionCmd represents the create command
var solutionGetCmd = &cobra.Command{
	Use:   "get",
	Short: "Get a solution from a remote git repo",
	Example: ` arete solution get git@github.com:accountName/solutionName.git`,
	Args: cobra.MinimumNArgs(1),
	Run: func(cmd *cobra.Command, args []string) {
		log.Logger = log.Output(zerolog.ConsoleWriter{Out: os.Stdout})

		sl := solutionsList{}

		err := sl.getRemoteSolutions(args[0], true, branch, subFolder)

		if err != nil {
			log.Fatal().Err(err).Msg("")
		}

		log.Info().Msg("Solution Added")
	},
}

// init the command and add flags
func init() {
	solutionCmd.AddCommand(solutionGetCmd)

	solutionGetCmd.Flags().StringVar(&branch, "branch", "main", "If the solutions.yaml file is in a different branch from the default")

	solutionGetCmd.Flags().StringVar(&subFolder, "sub-folder", "/", "If the solutions.yaml file is not in the root of the repo then provide the path here.")
}