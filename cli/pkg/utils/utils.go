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
	"path/filepath"
	"bufio"

	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"
	"github.com/spf13/viper"
)

const charset = "abcdefghijklmnopqrstuvwxyz0123456789"

var seededRand *rand.Rand = rand.New(
  rand.NewSource(time.Now().UnixNano()))

func init() {
	log.Logger = log.Output(zerolog.ConsoleWriter{Out: os.Stdout})
}

// Creating a random string
// Copied from: https://www.calhoun.io/creating-random-strings-in-go/
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

// Write some data to the local cache dir in the specifiec name. This will create or overwrite the file if append is false
func WriteToCache(data *string, fileName string, append bool) error {
	file := filepath.Join(viper.GetString("cache"), fileName)

	opts := os.O_RDWR|os.O_CREATE

	if append {
		opts = opts|os.O_APPEND
	}

	f, err := os.OpenFile(file, opts, 0600)

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

// CallCommand will execute a local command with the args that are passed in and either return the combined output/err of that comand
// or stream the commands output/error to stdout
func CallCommand(command string, args []string, stream bool) ([]byte, error) {	
	if viper.GetBool("verbose") {
		log.Debug().Msg(command + " " + strings.Join(args, " "))
	}

	cmd := exec.Command(command, args...)

	if stream {
		cmdErr, err := cmd.StderrPipe()

		if err != nil {
			return nil, err
		}

		cmdOut, err := cmd.StdoutPipe()

		if err != nil {
			return nil, err
		}

		cmd.Start()

		errScanner := bufio.NewScanner(cmdErr)
		outScanner := bufio.NewScanner(cmdOut)

		for errScanner.Scan() {
			log.Info().Msg(errScanner.Text())
		}

		for outScanner.Scan() {
			log.Info().Msg(outScanner.Text())
		}

		cmd.Wait()

		return nil, nil
	} else {
		output, err := cmd.CombinedOutput()

		if err != nil {
			return nil, err
		}

		return output, nil
	}
}