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
	"bufio"
	"net/http"
	"os"
	"strings"
	"fmt"
	"arete/pkg/utils"
	"github.com/spf13/cobra"
	"github.com/spf13/viper"
	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"
	"gopkg.in/yaml.v3"
)

type solutionsList struct {
	Solutions map[string]solution `yaml:"solutions"`
}

type solution struct {
	Description string `yaml:"description"`
	Url string `yaml:"url"`
}

func (s solutionsList) String() string {
	return fmt.Sprintf("%s", s.Solutions)
}

// solutionCmd represents the create command
var solutionCmd = &cobra.Command{
	Use:   "solution",
	Short: "Manage Solutions",
}

// init the command and add flags
func init() {
	rootCmd.AddCommand(solutionCmd)
}

// Get the Solutions.yaml file from GitHub
// @TODO: Need to figure out how to track modifications to the cached solutions.yaml file
// so as to not override them
func GetCoreSolutions() (*solutionsList, error) {
	log.Logger = log.Output(zerolog.ConsoleWriter{Out: os.Stdout})

	var lines []string
	ret := ""

	resp, err := http.Get("https://raw.githubusercontent.com/GoogleCloudPlatform/gcp-pbmm-sandbox/main/solutions/solutions.yaml?token=" + viper.GetString("git_token"))

	if err != nil {
		log.Error().Err(err).Msg("")
		return nil, err
	}

	if viper.GetBool("verbose") {
		log.Debug().Msg(resp.Status)
	}

	defer resp.Body.Close()

	scanner := bufio.NewScanner(resp.Body)

	for scanner.Scan() {
		lines = append(lines, scanner.Text())
	}

	if err := scanner.Err(); err != nil {
		log.Error().Err(err).Msg("")
		return nil, err
	}

	ret = strings.Join(lines, "\n")

	utils.WriteToCache(&ret, "solutions.yaml")

	// Update the Solutions list yaml file from GitHub
	sl := solutionsList{}

	err = yaml.Unmarshal([]byte(ret), &sl)

	if err != nil {
		log.Error().Err(err).Msg("")
		return nil, err
	}

	return &sl, nil
}