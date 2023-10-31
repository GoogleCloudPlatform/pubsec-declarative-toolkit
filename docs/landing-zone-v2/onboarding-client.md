# Client Onboarding

<!-- vscode-markdown-toc -->
- [Client Onboarding](#client-onboarding)
  - [Introduction](#introduction)
  - [Setup](#setup)
  - [Add client-setup package](#add-client-setup-package)
  - [Add the client-landing-zone package](#add-the-client-landing-zone-package)
  - [Next Step](#next-step)

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
  PACKAGE="solutions/client-setup"
  VERSION=$(curl -s $URL | jq -r ".\"$PACKAGE\"")
  CLIENT_NAME=initial-client
  kpt pkg get https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit.git/${PACKAGE}@${VERSION} ./clients/${CLIENT_NAME}
  ```

  [Releases List](https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit/releases?q=%22solutions%2Fclient-setup%22&expanded=true)

1. Customize the `clients/<client name>/client-setup/setters.yaml` file

  > **!!! There is a folder in that package called `root-sync-git`. This folder can be deleted if your are not using a `Gitops - Git` deployment solution. But, if you are, you should now create a new repository for this client and add the client-landing-zone package to that repo**

1. Render the Configs

    ```shell
    kpt fn render clients/${CLIENT_NAME}/client-setup
    ```

1. Deploy the infrastructure using either kpt or gitops-git or gitops-oci

## <a name='Addtheclient-landing-zonepackage'></a>Add the client-landing-zone package

1. Get the client-landing-zone package

> **!!! Update the command below with the proper VERSION, you can locate it in the package's CHANGELOG.md, for example, '0.0.1'. Use 'main' if not available but
> we strongly recommend using versions over main. Alternatively, each package CHANGELOG.md contains the history if there is a requirement to use an older version.**

- Experimentation

  ```shell
  PACKAGE="solutions/experimentation/client-landing-zone"
  VERSION=$(curl -s $URL | jq -r ".\"$PACKAGE\"")
  CLIENT_NAME=initial-client
  kpt pkg get https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit.git/${PACKAGE}@${VERSION} ./clients/${CLIENT_NAME}
  ```

  [Releases List](https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit/releases?q=experimentation%2Fclient-landing-zone&expanded=true)

- DEV, PREPROD, PROD

  ```shell
  PACKAGE="solutions/client-landing-zone"
  VERSION=$(curl -s $URL | jq -r ".\"$PACKAGE\"")
  CLIENT_NAME=initial-client
  kpt pkg get https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit.git/${PACKAGE}@${VERSION} ./clients/${CLIENT_NAME}
  ```

  [Releases List](https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit/releases?q=solutions%2Fclient-landing-zone&expanded=true)

1. Customize the `clients/${CLIENT_NAME}/client-landing-zone/setters.yaml` file

2. Render the Configs

    ```shell
    kpt fn render clients/${CLIENT_NAME}/client-landing-zone
    ```

3. Deploy the infrastructure using either kpt or gitops-git or gitops-oci

4. **TEMPORARY WORKAROUND** because of current location limitations when creating the Private Service Connect resource ([PSC](https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit/blob/main/solutions/client-landing-zone/client-folder/standard/applications-infrastructure/host-project/network/psc/google-apis/psc.yaml)).  It must be created manually with gcloud, Config Connector will then acquire it.
    ```bash
    # these temporary roles will be required to run the gcloud command:
    #   - Compute Network Admin (roles/compute.networkAdmin),
    #   - Service Directory Editor (roles/servicedirectory.editor)
    #   - DNS Administrator (roles/dns.admin)
    # https://cloud.google.com/vpc/docs/configure-private-service-connect-apis#roles

    HOST_PROJECT_ID='client-host-project-id'
    gcloud compute forwarding-rules create standardpscapisfw \
      --global \
      --network=global-standard-vpc \
      --address=standard-psc-apis-ip \
      --target-google-apis-bundle=all-apis \
      --project=${HOST_PROJECT_ID} \
      --service-directory-registration=projects/${HOST_PROJECT_ID}/locations/northamerica-northeast1
    ```

## <a name='NextStep'></a>Next Step

Execute the project onboarding [procedure](onboarding-project.md).
