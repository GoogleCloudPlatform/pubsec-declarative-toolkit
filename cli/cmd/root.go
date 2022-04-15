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
	"github.com/spf13/cobra"
	"github.com/spf13/viper"
	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"
)

// verbose states if the -v or --verbose flag as been set for debug purposes
var verbose bool

// rootCmd represents the base command when called without any subcommands
var rootCmd = &cobra.Command{
	Use:   "arete",
	Short: "Arete makes deploying GCP infrastructure easier",
	Long: `Arete is a wrapper that makes deploying solutions onto Google Cloud Platform easier.
	
It utilizes Googles Config Connector and Config Controller to deploy declaritive resources into your environment
with as little changes as required.`,
}

// Execute adds all child commands to the root command and sets flags appropriately.
// This is called by main.main(). It only needs to happen once to the rootCmd.
func Execute() {
	log.Logger = log.Output(zerolog.ConsoleWriter{Out: os.Stderr})

	err := rootCmd.Execute()
	if err != nil {
		log.Error().Err(err).Msg("")
	}
}

func init() {
	rootCmd.PersistentFlags().BoolVarP(&verbose, "verbose", "v", false, "verbose output")
	viper.BindPFlag("verbose", rootCmd.PersistentFlags().Lookup("verbose"))
}


