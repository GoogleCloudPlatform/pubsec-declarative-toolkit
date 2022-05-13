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
	"fmt"
	"net/http"
	"os"
	"path/filepath"
	"reflect"
	"strings"
	"errors"
	"regexp"

	"arete/pkg/utils"

	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"
	"github.com/spf13/cobra"
	"github.com/spf13/viper"
	"gopkg.in/yaml.v3"
)

// solutions List struct stores the YAML list of solutions from either
// the GitHub core solutions, local cached copy and / or the merged version of both
type solutionsList struct {
	Solutions []solution `yaml:"solutions"`
}

type solution struct {
	Solution string `yaml:"solution"`
	Description string `yaml:"description"`
	Url string `yaml:"url"`
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

// String return a simple string representation of the Solutions maps
func (s solutionsList) String() string {
	return fmt.Sprintf("%s", s.Solutions)
}

// Compare 2 solutionlists and return a combined list of unique solutions
func (firstSL *solutionsList) compareSolutions (secondSL *solutionsList) error {
	log.Logger = log.Output(zerolog.ConsoleWriter{Out: os.Stdout})
	var found bool

	if len(firstSL.Solutions) == 0 && len(secondSL.Solutions) > 0 {
		firstSL.Solutions = secondSL.Solutions

		return nil
	}

	for _, sSolution := range secondSL.Solutions {
		found = false
		for _, fSolution := range firstSL.Solutions {
			if reflect.DeepEqual(fSolution, sSolution) {
				found = true
			}
		}

		if !found {
			firstSL.Solutions = append(firstSL.Solutions, sSolution)
		}
	}

	return nil
}

// Get the solutions list which is a combination of the GitHub solutions file and
// any modification to the local cached solutions file.
func (sl *solutionsList) GetSolutions() error {
	log.Logger = log.Output(zerolog.ConsoleWriter{Out: os.Stdout})


	err := sl.getRemoteSolutions("https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit", true, "main", "solutions")

	if err != nil {
		return err
	}

	return nil
}

// Get the Solutions.yaml file from GitHub. If writeToCache is true then create or overwrite the local
// cached copy of the solutions.yaml file
func (sl *solutionsList) getRemoteSolutions(url string, writeToCache bool, branch string, subFolder string) error {
	log.Logger = log.Output(zerolog.ConsoleWriter{Out: os.Stdout})

	if branch == "" {
		branch = "main"
	}

	// Remove prefix and suffix forward slashes
	if subFolder == "" {
		subFolder = "/"
	} else if strings.Index(subFolder, "/") == 0 {
		subFolder = strings.Replace(subFolder, "/", "", 1)
	}
	
	subFolder = strings.TrimSuffix(subFolder, "/")

	var lines []string
	var ret string

	reg := regexp.MustCompile(`^https://github.com/([a-zA-Z0-9-/]*)`)
	res := reg.FindStringSubmatch(url)

	if len(res) == 2 {
		url = "https://raw.githubusercontent.com/" + res[1] + "/" + branch + "/" + subFolder + "/solutions.yaml"
	} else {
		return errors.New("malformed URL, unable to process")
	}

	// If the repo is private then a token can be passed in the URL to get access to the solutions file
	gitToken := viper.GetString("git_token")

	if  gitToken != "" {
		url += "?token=" + gitToken
	}

	if viper.GetBool("verbose") {
		log.Debug().Msg("Getting solutions.yaml from url: " + url)
	}

	resp, err := http.Get(url)

	if err != nil || resp.StatusCode == 404 {
		return err
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
		log.Fatal().Err(err).Msg("")
	}

	ret = strings.Join(lines, "\n")

	err = yaml.Unmarshal([]byte(ret), &sl)

	if err != nil {
		return err
	}

	if writeToCache {
		var cachedSolutions solutionsList
		if err := cachedSolutions.getCacheSolutions(); err != nil {
			return err
		}

		sl.compareSolutions(&cachedSolutions)

		yamlout, err := yaml.Marshal(&sl)

		if err != nil {
			return err
		}

		lic, err := os.ReadFile(filepath.Join("static", "license.txt"))

		if err != nil {
			return err
		}

		ret = string(append(lic, yamlout...))

	
	 	utils.WriteToCache(&ret, "solutions.yaml", false)
	}

	return nil 
}

// Get the cached solutions.yaml file
func (sl *solutionsList) getCacheSolutions() error {
	log.Logger = log.Output(zerolog.ConsoleWriter{Out: os.Stdout})

	solutionsFile := filepath.Join(viper.GetString("cache"), "solutions.yaml")
	cacheSl, err := os.ReadFile(solutionsFile)

	if err != nil {
		os.Create(solutionsFile)
	}

	err = yaml.Unmarshal(cacheSl, &sl)

	if err != nil {
		return err
	}

	return nil
}

// GetUrl will search the solution list for the passed in solution and return
// the URL or error if the solution is not found
func (sl *solutionsList) GetUrl(solutionName string) (string, error) {
	for _, solution := range sl.Solutions {
		if solution.Solution == solutionName {
			return solution.Url, nil
		}
	}

	return "", errors.New("solution not found")
}