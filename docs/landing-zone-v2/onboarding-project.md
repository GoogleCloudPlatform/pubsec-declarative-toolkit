# Project Onboarding

<!-- vscode-markdown-toc -->
* [Introduction](#Introduction)
* [Setup](#Setup)
* [Add client project package](#Addclientprojectpackage)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

## <a name='Introduction'></a>Introduction

You will execute this procedure to provision the service project in GCP for applications.

## <a name='Setup'></a>Setup

1. Move to the folder where the `gatekeeper-policies`, `core-landing-zone` and `clients` folders are located

    ```shell
    cd <FOLDER>
    ```

1. Create the following folder structure for projects

    ```text
    ├── clients
    │   ├── <client1-name>
    │   ├── <client2-name>
    |   ├── ...
    ├── core-landing-zone
    ├── gatekeeper-policies
    ├── projects
    │   ├── <project1-id>
    │   ├── <project2-id>
    |   ├── ...
    ```

## <a name='Addclientprojectpackage'></a>Add client project package

1. Get the client project package

> **!!! Update the command below with the proper VERSION, you can locate it in the package's CHANGELOG.md, for example, '0.0.1'. Use 'main' if not available but
> we strongly recommend using versions over main. Alternatively, each package CHANGELOG.md contains the history if there is a requirement to use an older version.**

- Experimentation

  ```shell
  kpt pkg get https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit.git/solutions/experimentation/client-project@<VERSION> ./projects/<project-id>
  ```

- DEV, PREPROD, PROD

  ```shell
  kpt pkg get https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit.git/solutions/client-project-setup@<VERSION> ./projects/<project-id>
  ```

1. Customize the `setters.yaml` file

- Experimentation

  `projects/<project-id>/client-project/setters.yaml`

- DEV, PREPROD, PROD

  `projects/<project-id>/client-project-setup/setters.yaml`

  > **!!! There is a folder in the `client-project-setup` package called `root-sync-git`. This folder can be deleted if your are not using a `Gitops - Git` deployment solution. But, if you are, you should now create a new repository for this project and configure the setters.yaml file accordingly.**

1. Render the Configs

- Experimentation

    ```shell
    kpt fn render projects/<project-id>/client-project
    ```

- DEV, PREPROD, PROD

    ```shell
    kpt fn render projects/<project-id>/client-project-setup
    ```

1. Deploy the infrastructure using either kpt or gitops-git or gitops-oci
