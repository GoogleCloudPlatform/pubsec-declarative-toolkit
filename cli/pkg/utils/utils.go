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
package utils

import (
	"math/rand"
	"time"
	"os"
	"os/exec"
	"strings"
	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"
	"github.com/spf13/viper"
)

// Creating a random string
// Copied from: https://www.calhoun.io/creating-random-strings-in-go/

const charset = "abcdefghijklmnopqrstuvwxyz0123456789"

var seededRand *rand.Rand = rand.New(
  rand.NewSource(time.Now().UnixNano()))

func init() {
	log.Logger = log.Output(zerolog.ConsoleWriter{Out: os.Stdout})
}

func stringWithCharset(length int, charset string) string {
  b := make([]byte, length)
  for i := range b {
    b[i] = charset[seededRand.Intn(len(charset))]
  }
  return string(b)
}

func RandomString(length int) string {
  return stringWithCharset(length, charset)
}

// Write some data to the local cache dir in the specifiec name. This will either create
// or update the file with the new content
func WriteToCache(data *string, fileName string) error {
	file := viper.GetString("cache") + "/" + fileName

	f, err := os.OpenFile(file, os.O_RDWR|os.O_CREATE, 0600)

	if err != nil {
		log.Error().Err(err). Msg("Unable to create / open file")
		return err
	}

	defer f.Close()
	if viper.GetBool("verbose") {
		log.Debug().Msgf("Writing data to local cache file %s", file)
	}
	if _, wErr := f.WriteString(*data); wErr != nil {
		log.Error().Err(wErr).Msg("")
		return wErr
	}

	return nil
}

func CallCommand(command string, args []string) ([]byte, error) {	
	//args := []string{"alpha", "billing", "accounts", "list", "--format=value[separator=' - '](NAME, ACCOUNT_ID)"}

	if viper.GetBool("verbose") {
		log.Debug().Msg(command + " " + strings.Join(args, " "))
	}

	cmd := exec.Command(command, args...)
	out, err := cmd.CombinedOutput()

	if err != nil {
		return out, err
	}

	return out, nil
}