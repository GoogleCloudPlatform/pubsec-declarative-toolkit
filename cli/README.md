# Arete CLI #

## Description ##
Arete is the Public Sector Declarative Toolkits simplified workflow by providing a CLI that can be utilzied to either:

- Standup a `Config Connector` cluster
- Deploy a Solution into your GCP environment

## Table of Contents ##

- [Arete Technical Overview](#technical)
- [What is a Solution / Service](./docs/solutions.md)
- [Config Controller Setup](./docs/create.md)
- [Config / Cache Management](./docs/config.md)


### Technical ###

Arete utilizes / expects that the following executables are installed and globally avaiable:

- [Gcloud](https://cloud.google.com/sdk/gcloud)
- [Kpt](https://kpt.dev/)
- [Kubectl](https://kubernetes.io/docs/tasks/tools/)

Arete assumes that user authorization for gloud and the correct context for kubectl has already been completed by the user prior to calling arete.


Arete is written in [Go](https://go.dev) utilizing the following primary packages:

- [Cobra](https://github.com/spf13/cobra)
- [Viper](https://github.com/spf13/viper)