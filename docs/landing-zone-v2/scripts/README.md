# Deployment of KRM Landing Zone v2

## Table of Contents
<!-- vscode-markdown-toc -->
- [KRM Landing Zone v2](#krm-landing-zone-v2)
  - [Table of Contents](#table-of-contents)
  - [Introduction](#introduction)
  - [Implementation](#implementation)

## <a name='Introduction'></a>Introduction

This solution for those using GitHub as their Git repository, deploys the Landing Zone specified in https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit/tree/main/docs/landing-zone-v2#option-1---org-level-folder

The script provided creates:
- Initial Organization configuration.
- A GCP folder to host the landing zone hierarchy.
- A config controller project.
- A VPC, a subnet and a Cloud NAT.
- Private Service Connect to access googleapis.com and gcr.io
- VPC firewall rules.
- A config controller cluster.
- IAM permission for the "Yakima" service account.
- A Private GitHub Repository
- Create your Landing zone (Gatekeeper policies & Core-landing-zone OR Experimentation)

## <a name='Implementation'></a>Implementation

1. Clone Repo and get into the Bootstrap directory

Once this Repository has been cloned to your local repository, run the following command.

```shell
git clone https://github.com/yw-liftandshift/KCC-Landing-Zone.git
cd KCC-Landing-Zone/docs/scripts/bootstrap
```

2. Define environment variables

Modify the .env.sample file, If Landing Zone is being deployed on the Organizational level, remove or comment out "export ROOT_FOLDER_ID=<Folder ID>". Export the Git Token and ensure it has access rights to create Git repositories.

```shell
export TOKEN=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
```
## Follow PART A: If you are deploying the core-landing-zone
```shell
export GATEKEEPER_VERSION=<Version ID> # This Version is for the kpt package in the gatekeeper policies deployment. You can find the different versions in the CHANGELOG.md file within the gatekeeper-policies folder or use "main"
export CORE_LZ_VERSION=<Version ID> # This Version is for the kpt package in the core landing zone deployment. You can find the different versions in the CHANGELOG.md file within the core-landing-zone folder or use "main"
```

## Follow PART B: If you are deploying the experimentation landing zone
```shell
export EXPERIMENTATION_VERSION=<Version ID> # This Version is for the kpt packages in the experimentation deployment. You can find the different versions in the CHANGELOG.md file within the experimentation folder or use "main"
```

3. Execute setup-kcc.sh

Change permissions of the setup-kcc.sh file in order to execute it.
Remove the -f, If Landing Zone is being deployed on the Organizational level.

Note: -a: autopilot. It will deploy an autopilot cluster instead of a standard cluster
      -f: folder_opt. It will bootstrap the landing zone in a folder instead than at the org level"

```shell
chmod +x setup-kcc.sh
```

```shell
./setup-kcc.sh -af PATH_TO_ENV_FILE
```

4. Move both packages into the Git Config Directory
## PART A
```shell
mv gatekeeper-policies core-landing-zone PATH_TO_CONFIG_SYNC_DIR
```
## PART B
```shell
mv experimentation PATH_TO_CONFIG_SYNC_DIR
```

5. Hydrate Files

Once the script is done executing, modify the setters.yaml files for all packages and ensure the project naming is compliant based on the gatekeeper policies constraints. Also, ensure the Storage bucket names are globally unique. Get into the Git Repo the execute this command.

## PART A
```shell
kpt fn render gatekeeper-policies
kpt fn render core-landing-zone
```
## PART B
```shell
kpt fn render admin-folder
kpt fn render client-landing-zone
kpt fn render client-project
kpt fn render core-landing-zone
```

6. Commit Changes to Git Repo

```shell
# Checkout the main branch
git checkout -b main
# Review changes
git diff
# Prepare your commit by staging the files
git add .
# Commit your changes
git commit -m "<MEANINGFUL MESSAGE GOES HERE>"
# Push your changes to origin
git push --set-upstream origin main
```

## <a name='NextStep'></a>Next Step

Execute the client onboarding [procedure](onboarding-client.md).

## <a name='CleanUp'></a>Clean Up

Follow the below steps to delete the provisioned infrastructure and Config Controller instances.

If you want the deployed resources to live on and just destroy the Config Controller instance you can do so by running `gcloud anthos config controller instance-name --location instance-region`. This will remove the config controller instances but leave the resources it deployed untouched.

To reacquire the resources you will need to redeploy a new instance and deploy the same configs to it. Config Controller should reattach to the previously deployed instances and start managing them again.


## <a name='clean-up-gitops'></a>GitOps

First delete the Rootsync deployment. This will prevent the resources from self-healing.

```shell
kubectl delete root-sync landing-zone -n config-management-system
```

Now we can delete our KCC resources from the Config Controller instance.

```shell
kubectl delete gcp --all
```

Once the resources have been deleted you can delete the config controller instance .

If you have forgotten the name of the instance you can run `gcloud config controller list` to reveal the instances in your project.

```shell
export CLUSTER="kcc cluster name"
export REGION=northamerica-northeast1
gcloud anthos config controller delete $CLUSTER --location $REGION
```

