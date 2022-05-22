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

### Compile the CLI ###

In order to compile the CLI manually you can use the normal [Go](https://go.dev) compile and install process:

You can Git clone the repo or even use kpt (`kpt pkg get git@github.com:GoogleCloudPlatform/pubsec-declarative-toolkit.git/cli`)to get the cli package and then run

```
cd cli
go install
```

add the location where the executable is installed in to your path

```
export PATH=$PATH:/path/to/your/install/directory
```

For more information read: https://go.dev/doc/tutorial/compile-install

### Technical ###

Arete utilizes / expects that the following executables are installed and globally avaiable:

- [Gcloud](https://cloud.google.com/sdk/gcloud)
- [Kpt](https://kpt.dev/)
- [Kubectl](https://kubernetes.io/docs/tasks/tools/)

Arete assumes that user authorization for gloud and the correct context for kubectl has already been completed by the user prior to calling arete.

Arete is written in [Go](https://go.dev) utilizing the following primary packages:

- [Cobra](https://github.com/spf13/cobra)
- [Viper](https://github.com/spf13/viper)