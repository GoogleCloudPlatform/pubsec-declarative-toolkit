# Advanced Install

This assumes you are running in Cloud Shell which has all of the prerequisites installed.

If you are not the following resources are required.

* [Google Cloud SDK version >= 325.0.0](https://cloud.google.com/sdk/docs/downloads-versioned-archives)
* [kpt](https://kpt.dev/installation/)
* [kubectl](https://kubernetes.io/docs/tasks/tools/) ( >= v1.20)

## 1. Set environment variables that match your environment

```bash
CLUSTER=<cluster-name>
REGION=<supported-region>
PROJECT_ID=<project-id>
NETWORK=<vpc-name>
SUBNET=<subnet-name>
ORG_ID=<your_org_id>
BILLING_ID=<your_billing_id>
```

## 2. Create Project

```bash
gcloud projects create $PROJECT_ID --name="Config Controller" --labels=type=infrastructure-automation --set-as-default
```

## 3. Enable Billing

```bash
gcloud beta billing projects link $PROJECT_ID --billing-account $BILLING_ID
```

## 4. Set the project ID

```bash
gcloud config set project $PROJECT_ID
```

## 5. Enable the required services

```bash
gcloud services enable krmapihosting.googleapis.com container.googleapis.com cloudresourcemanager.googleapis.com accesscontextmanager.googleapis.com
```

## 6. Create a network and subnet

```bash
gcloud compute networks create $NETWORK --subnet-mode=custom
gcloud compute networks subnets create $SUBNET  \
--network $NETWORK \
--range 192.168.0.0/16 \
--region $REGION
```

## 7. Create the Config Controller Instance

### GKE Autopilot - recommended

Fully managed cluster

```bash
gcloud anthos config controller create $CLUSTER --location $REGION --network $NETWORK --subnet $SUBNET --full-management
```

### GKE Standard

```bash
gcloud anthos config controller create $CLUSTER --location $REGION --network $NETWORK --subnet $SUBNET
```

### Get Credentials

```bash
gcloud anthos config controller get-credentials $CLUSTER  --location $REGION
kubens config-control
```

## 8. Assign Permissions to the config connector Service Account

Note: ORG_ID will be set from step

```bash
export ORG_ID=$ORG_ID
export SA_EMAIL="$(kubectl get ConfigConnectorContext -n config-control \
    -o jsonpath='{.items[0].spec.googleServiceAccount}' 2> /dev/null)"
gcloud organizations add-iam-policy-binding "${ORG_ID}" \
    --member "serviceAccount:${SA_EMAIL}" \
    --role "roles/resourcemanager.folderAdmin"
gcloud organizations add-iam-policy-binding "${ORG_ID}" \
    --member "serviceAccount:${SA_EMAIL}" \
    --role "roles/resourcemanager.projectCreator"
gcloud organizations add-iam-policy-binding "${ORG_ID}" \
    --member "serviceAccount:${SA_EMAIL}" \
    --role "roles/resourcemanager.projectDeleter"
gcloud organizations add-iam-policy-binding "${ORG_ID}" \
    --member "serviceAccount:${SA_EMAIL}" \
    --role "roles/iam.securityAdmin"
gcloud organizations add-iam-policy-binding "${ORG_ID}" \
    --member "serviceAccount:${SA_EMAIL}" \
    --role "roles/orgpolicy.policyAdmin"
gcloud organizations add-iam-policy-binding "${ORG_ID}" \
    --member "serviceAccount:${SA_EMAIL}" \
    --role "roles/serviceusage.serviceUsageConsumer"
gcloud organizations add-iam-policy-binding "${ORG_ID}" \
    --member "serviceAccount:${SA_EMAIL}" \
    --role "roles/billing.user"
```

## 9. Now you are ready to deploy a solution