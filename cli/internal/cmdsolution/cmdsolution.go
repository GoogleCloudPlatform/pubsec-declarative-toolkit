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

package cmdsolution

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
	solutionFilev1 "arete/pkg/api/solution/v1"

	"github.com/rs/zerolog/log"
	"github.com/spf13/viper"
	"gopkg.in/yaml.v3"
)

// solutions List struct stores the YAML list of solutions from either
// the GitHub core solutions, local cached copy and / or the merged version of both
type SolutionsList struct {
	Solutions []Solution `yaml:"solutions"`
}

type Solution struct {
	Solution string `yaml:"solution"`
	Description string `yaml:"description"`
	Url string `yaml:"url"`
}

// String return a simple string representation of the Solutions maps
func (s SolutionsList) String() string {
	return fmt.Sprintf("%s", s.Solutions)
}

// Compare 2 solutionlists and return a combined list of unique solutions
func (firstSL *SolutionsList) compareSolutions (secondSL *SolutionsList) error {
	
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
// TODO: Where do we store a list of the global solutions other then GitHub solutions.yaml file? This is to manual
func (sl *SolutionsList) GetSolutions() error {
	err := sl.GetRemoteSolutions("https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit", true, "main", "solutions")

	if err != nil {
		return err
	}

	return nil
}

// Get a GitHub raw filefrom the url, branch and subFolder provided
func getGitHubRaw(url string, branch string, subFolder string, file string) (string, error) {
	var lines []string
	ret := ""

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

	reg := regexp.MustCompile(`^https://github.com/([a-zA-Z0-9-/]*)`)
	res := reg.FindStringSubmatch(url)

	// If the repo is private then a token can be passed in the URL to get access to the solutions file
	gitToken := viper.GetString("git_token")

	if len(res) == 2 {
		url = "https://"

		if  gitToken != "" {
			url = url + gitToken + "@"
		}

		url = url + "raw.githubusercontent.com/" + res[1] + "/" + branch + "/" + subFolder + "/" + file
	} else {
		return ret, errors.New("malformed URL, unable to process")
	}

	if viper.GetBool("verbose") {
		log.Debug().Msgf("Getting %s from url: %s", file, url)
	}

	resp, err := http.Get(url)

	if err != nil || resp.StatusCode == 404 {
		return ret, err
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

	return ret, nil
}

// Get the solution.yaml file from a GitHub repo.
func (sl *SolutionsList) GetRemoteSolution(url string, branch string, subFolder string) error {
	ret, err := getGitHubRaw(url, branch, subFolder, "solution.yaml")

	if err != nil {
		return err
	}

	solutionFile := solutionFilev1.SolutionFile{}

	yaml.Unmarshal([]byte(ret), &solutionFile)

	if !solutionFile.Spec.IsEmpty() {
		sol := make([]Solution, 1)
		sol[0].Url = solutionFile.Spec.Url
		sol[0].Description = solutionFile.Spec.Description
		sol[0].Solution = solutionFile.Name

		sl.Solutions = append(sl.Solutions, sol[0])

		var cachedSolutions SolutionsList

		if err := cachedSolutions.getCacheSolutions(); err != nil {
			return err
		}

		sl.compareSolutions(&cachedSolutions)

		yamlout, err := yaml.Marshal(&sl)

		if err != nil {
			return err
		}
		
		ret = string(yamlout)
	
	 	utils.WriteToCache(&ret, "solutions.yaml", false)
	}

	return nil
}

// Get the solutions.yaml file from GitHub. If writeToCache is true then create or overwrite the local
// cached copy of the solutions.yaml file
func (sl *SolutionsList) GetRemoteSolutions(url string, writeToCache bool, branch string, subFolder string) error {
	ret, err := getGitHubRaw(url, branch, subFolder, "solutions.yaml")

	if err != nil {
		return err
	}

	err = yaml.Unmarshal([]byte(ret), &sl)

	if err != nil {
		return err
	}

	if writeToCache {
		var cachedSolutions SolutionsList
		if err := cachedSolutions.getCacheSolutions(); err != nil {
			return err
		}

		sl.compareSolutions(&cachedSolutions)

		yamlout, err := yaml.Marshal(&sl)

		if err != nil {
			return err
		}
		
		ret = string(yamlout)
	
	 	utils.WriteToCache(&ret, "solutions.yaml", false)
	}

	return nil 
}

// Get the cached solutions.yaml file
func (sl *SolutionsList) getCacheSolutions() error {
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
func (sl *SolutionsList) GetUrl(solutionName string) (string, error) {
	for _, solution := range sl.Solutions {
		if solution.Solution == solutionName {
			return solution.Url, nil
		}
	}

	return "", errors.New("solution not found")
}