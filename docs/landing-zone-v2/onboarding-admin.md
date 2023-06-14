# Platform or Security Admin Onboarding

<!-- vscode-markdown-toc -->
* [Introduction](#Introduction)
* [Setup](#Setup)
* [Add admin folder](#Addadminfolder)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

## <a name='Introduction'></a>Introduction

This package creates a folder in GCP and grant admin privileges on that folder to a user. This user can use this folder to experiment solutions in GCP.

This procedure must only be executed on an `Experimentation` Landing zone.

## <a name='Setup'></a>Setup

1. Move to the folder where the `gatekeeper-policies`, `core-landing-zone` and `clients` folders are located

    ```shell
    cd <FOLDER>
    ```

1. Create the following folder structure for admins

    ```text
    ├── admins
    │   ├── <admin1-name>
    │   ├── <admin2-name>
    │   ├── ...
    ├── clients
    │   ├── <client1-name>
    │   ├── <client2-name>
    │   ├── ...
    ├── core-landing-zone
    ├── gatekeeper-policies
    ```

## <a name='Addadminfolder'></a>Add admin folder

1. Get the experimentation/admin-folder package

> **!!! Update the command below with the proper VERSION, you can locate it in the package's CHANGELOG.md, for example, '0.0.1'. Use 'main' if not available but
> we strongly recommend using versions over main. Alternatively, each package CHANGELOG.md contains the history if there is a requirement to use an older version.**

- Experimentation

    ```kpt
    kpt pkg get https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit.git/solutions/experimentation/admin-folder@<VERSION> ./admins/<admin name>
    ```

1. Customize the `admins/<admin name>/admin-folder/setters.yaml` file

1. Render the Configs

    ```bash
    kpt fn render admins/<admin name>/admin-folder
    ```

1. Deploy the infrastructure using either kpt or gitops-git or gitops-oci
