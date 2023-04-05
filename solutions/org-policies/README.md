# Introduction

A package to create GCP Organization Policies.

The `organization` folder contains a file for each policy to be applied.

The `exceptions` folder can be used to manage exceptions at the folder and/or project level.

## Requirements

- A management project with KCC installed.
- The `landing-zone` package containing the `policies` namespace and associated resources.

## Usage

Get the package by running the following, optionally setting the revision and destination folder:

`kpt pkg get <REPO_URL>.git/org-policies@<REVISION> <DESTINATION_FOLDER>`

Modify `setters.yaml` according to instructions that file's comments and each policy file.
