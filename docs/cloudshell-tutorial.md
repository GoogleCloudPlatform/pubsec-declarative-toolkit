# PBMM Sandbox

##

This tutorial shows you how to deploy the **[PBMM Sandbox environment](https://github.com/GoogleCloudPlatform/gcp-pbmm-sandbox.git)** on Google Cloud.

To get started, you will need your GCP Organization ID.

Let's get started!

## Pre-requirements (1 of 2)

In order to get started you need to find the GCP Organization ID you wish to run the PBMM Sandbox in. To get this run:

```bash
gcloud organizations list
```
Once you have copied / taken note of the `ID:` of the organization you wish to use, continue to the next step.

## Pre-requirements (2 of 2)

Now, let's make the bootstrap.sh file executabe by running the following command:

```bash
chmod +X bootstrap.sh
```

Now that the bootstrap.sh file is executable, continue to the next step.

## Bootstrapping

Now we can run the bootstrap.sh to start setting up the environment. You have 2 choices that bootstrap will prompt you to choose from:

1. A standalone GKE Cluster that will be used to run Kubernetes Config Connector to create the rest of the PBMM Sandbox
2. A Config Controller cluster. This is still in PREVIEW and currently isn't PBMM supported.

**Bootstrap Switches**

`bootstrap.sh`

-o ORG_ID <- The organization ID we captured in the first step

-f FOLDER_NAME <- A name for the folder where the PBMM sandbox enviroment will be setup under

[-p PROJECT_ID] <- OPTIONAL: A GCP project ID that already exists. By default bootstrap will great a project called: bootstrap-####

[-b BILLING_ID] <- OPTIONAL: The GCP billing account ID that will be used to add to the project. By default bootstrap will prompt you to choose a billing ID you have access to

**EXAMPLE**
```bash
./bootstrap.sh -o 12345678 -f PBMM_SANDBOX
```

That's it!

The next page will discuss more about the bootstrap process if you want to know more.

## Bootstrap process

**LOG FILE**

The bootstrap program will create a log file in the same directory that bootstrap.sh is run. All outputs from the bootstrap commands
are saved into this log file so if there is an error or you just want to see the glcoud commands outputs you can check that log file out.

**RE-RUN**

If you want to re-run bootstrap in case there was an error but don't want to re-create the project then you can just run:

```bash
./bootstrap.sh -o ORG_ID -f FOLDER_NAME -p PROJECT_ID
```

bootstrap will not attempt to re-create the folder and will use the project_id provided for all other commands