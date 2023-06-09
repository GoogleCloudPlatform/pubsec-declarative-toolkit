# Client Onboarding

<!-- vscode-markdown-toc -->
* [Introduction](#Introduction)
* [Setup](#Setup)
* [Add client-setup package](#Addclient-setuppackage)
* [Add the client-landing-zone package](#Addtheclient-landing-zonepackage)
* [Next Step](#NextStep)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

## <a name='Introduction'></a>Introduction

You will execute this procedure to provision the foundational resources in GCP for each client. These resources are required before you can create application project.

## <a name='Setup'></a>Setup

1. Move to the folder where the `gatekeeper-policies` and `core-landing-zone` packages are located

    ```shell
    cd <FOLDER>
    ```

1. Create the following folder structure for clients

    ```text
    ├── clients
    │   ├── <client1-name>
    │   ├── <client2-name>
    │   ├── ...
    ├── core-landing-zone
    ├── gatekeeper-policies
    ```

## <a name='Addclient-setuppackage'></a>Add client-setup package

1. Get the client-setup package

> **!!! Update the command below with the proper VERSION, you can locate it in the package's CHANGELOG.md, for example, '0.0.1'. Use 'main' if not available but
> we strongly recommend using versions over main. Alternatively, each package CHANGELOG.md contains the history if there is a requirement to use an older version.**

- Experimentation

  you do not require this package.

- DEV, PREPROD, PROD

  ```shell
  kpt pkg get https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit.git/solutions/client-setup@<VERSION> ./clients/<client name>
  ```

1. Customize the `clients/<client name>/client-setup/setters.yaml` file

  > **!!! There is a folder in that package called `root-sync-git`. This folder can be deleted if your are not using a `Gitops - Git` deployment solution. But, if you are, you should now create a new repository for this client and add the client-landing-zone package to that repo**

1. Render the Configs

    ```shell
    kpt fn render clients/<client name>/client-setup
    ```

1. Deploy the infrastructure using either kpt or gitops-git or gitops-oci

## <a name='Addtheclient-landing-zonepackage'></a>Add the client-landing-zone package

1. Get the client-landing-zone package

> **!!! Update the command below with the proper VERSION, you can locate it in the package's CHANGELOG.md, for example, '0.0.1'. Use 'main' if not available but
> we strongly recommend using versions over main. Alternatively, each package CHANGELOG.md contains the history if there is a requirement to use an older version.**

- Experimentation

  ```shell
  kpt pkg get https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit.git/solutions/experimentation/client-landing-zone@<VERSION> ./clients/<client name>
  ```

- DEV, PREPROD, PROD

  ```shell
  kpt pkg get https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit.git/solutions/client-landing-zone@<VERSION> ./clients/<client name>
  ```

1. Customize the `clients/<client name>/client-landing-zone/setters.yaml` file

1. Render the Configs

    ```shell
    kpt fn render clients/<client name>/client-landing-zone
    ```

1. Deploy the infrastructure using either kpt or gitops-git or gitops-oci

## <a name='NextStep'></a>Next Step

Execute the project onboarding [procedure](onboarding-project.md).
