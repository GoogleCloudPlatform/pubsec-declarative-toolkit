Getting Started
===============

There are some prerequisites in order to deploy the sandbox.

Prerequisites
-------------

*   GCP Organization
*   GCP Account
*   [Cloud Shell](https://cloud.google.com/shell)
*   [kpt](https://github.com/GoogleContainerTools/kpt)
*   [git](https://git-scm.com/)

Cloud Shell comes pre-installed with git and kpt.

Sandbox comes with a bootstrap shell script that will create a project with a private GKE cluster that is pre-configured with Config Connector [https://cloud.google.com/config-connector/docs/overview](https://cloud.google.com/config-connector/docs/overview). The user that executes the bootstrap process must have certain required permissions in order to setup the configuration project. You can either grant the following roles or create a customer role with the required permissions.

### Predefined Roles

Role

Description

Command

Folder Creator

Used to create Folder for Configuratio Project

`gcloud organizations add-iam-policy-binding $ORG_ID --member="user:${USER_EMAIL}" --role='roles/resourcemanager.folderCreator'`

Project Creator

Required to create project for hosting GKE Cluster

`gcloud organizations add-iam-policy-binding $ORG_ID --member="user:${USER_EMAIL}" --role='roles/resourcemanager.projectCreator'`

Billing Account User

Required to attach a billing account to the host project

`gcloud organizations add-iam-policy-binding $ORG_ID --member="user:${USER_EMAIL}" --role='roles/billing.user'`

EITHER

Organization Policy Administrator

Required to adjust Organizational Policies on the configuration project folder

`gcloud organizations add-iam-policy-binding $ORG_ID --member="user:${USER_EMAIL}" --role='roles/orgpolicy.policyAdmin'`

Security Administrator

Required to apply IAM Policies to a Service Account at the Org level

`gcloud organizations add-iam-policy-binding $ORG_ID --member="user:${USER_EMAIL}" --role='roles/iam.securityAdmin'`

OR JUST

Organization Administrator

Required to apply IAM Policies to a Service Account at the Org Level and adjust org policies

`gcloud organizations add-iam-policy-binding $ORG_ID --member="user:${USER_EMAIL}" --role='roles/resourcemanager.organizationAdmin'`

### Custom Role - Required Permissions

If you wish to create a custom role for the bootstrap process then the following permissions need to be added to the role. _NOTE_: The user will also need to assigned the Organization Policy Administrator Role as these permission can not be assigned to a custom role.

Quickstart
----------

[![Open in Cloud Shell](https://gstatic.com/cloudssh/images/open-btn.svg)](https://ssh.cloud.google.com/cloudshell/editor?cloudshell_git_repo=git@github.com:GoogleCloudPlatform/gcp-pbmm-sandbox.git&cloudshell_workspace=.&cloudshell_tutorial=docs/cloudshell-tutorial.md)

### Alternatives

*   In CloudShell you can run:

    teachme docs/cloudshell-tutorial.md
    

*   You can download the `bootstrap` script and following the steps in the following [Docs](docs/cloudshell-tutorial.md). To get download `bootstrap.sh` download it from the [releases page](https://github.com/GoogleCloudPlatform/gcp-pbmm-sandbox/releases) or use the following command:

    release=v0.0.1
    wget https://github.com/GoogleCloudPlatform/gcp-pbmm-sandbox/releases/download/${release}/bootstrap.sh