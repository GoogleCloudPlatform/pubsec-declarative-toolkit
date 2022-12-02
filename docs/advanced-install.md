Advanced Install
==================================

This assumes you are running in Cloud Shell which has all of the prerequisites installed. 

If you are not the following resources are required.
* [Google Cloud SDK version >= 325.0.0](https://cloud.google.com/sdk/docs/downloads-versioned-archives)
* [kpt](https://kpt.dev/installation/)
* [kubectl](https://kubernetes.io/docs/tasks/tools/) ( >= v1.20)

## 1. Set environment variables that match your environment
```
# note: CLUSTER, NETWORK, SUBNET can be renamed to anything, CC_PROJECT_ID must be a unique name (use your org name/date combo) - like controller-lgz-0919, the rest are derived.
# note: for multiple billing accounts - set the BILLING_ID manually
gcloud config set project <your bootstrap project id>
export CC_PROJECT_ID=controller-lgz-0919
export REGION=northamerica-northeast2
export CLUSTER=pdt
export NETWORK=pdt-vpc
export SUBNET=pdt
export BOOT_PROJECT_ID=$(gcloud config list --format 'value(core.project)')
export ORG_ID=$(gcloud projects get-ancestors $BOOT_PROJECT_ID --format='get(id)' | tail -1)
export BILLING_ID=$(gcloud alpha billing projects describe $BOOT_PROJECT_ID '--format=value(billingAccountName)' | sed 's/.*\///')
```

## 2. Create Project
```
gcloud projects create $CC_PROJECT_ID --name="Config Controller" --labels=type=infrastructure-automation --set-as-default
```

## 3. Enable Billing
```
gcloud beta billing projects link $CC_PROJECT_ID --billing-account $BILLING_ID
```

## 4. Set the project ID
```
The project should already be set during the last step: create project, otherwise run the following

gcloud config set project $CC_PROJECT_ID
```

## 5. Enable the required services
```
gcloud services enable krmapihosting.googleapis.com container.googleapis.com cloudresourcemanager.googleapis.com accesscontextmanager.googleapis.com
```

## 6. Create a network and subnet
```
gcloud compute networks create $NETWORK --subnet-mode=custom
gcloud compute networks subnets create $SUBNET --network $NETWORK --range 192.168.0.0/16 --region $REGION
```

## 7. Create the Config Controller Instance
```
gcloud anthos config controller create $CLUSTER --location $REGION --network $NETWORK --subnet $SUBNET
```

Verify the Config Controller Cluster is up
```
gcloud anthos config controller list
NAME: pdt
LOCATION: northamerica-northeast1
STATE: RUNNING
```

## 8. Get Credentials
```
gcloud anthos config controller get-credentials $CLUSTER  --location $REGION
kubens config-control
```

## 9. Assign Permissions to the config connector Service Account.

```
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

## 10. Now you are ready to deploy a solution!
see for example the [Landing Zone](/solutions/landing-zone) solution

## 11. Development Operations: Delete the Config Controller Cluster
Optional operation: In the CC cluster project
```
gcloud anthos config controller delete --location $REGION $CLUSTER --quiet
```
## 12. Development Operations: Re Create the Config Controller Cluster
Optional Operation: Override the requireShieldedVm organization policy only on the CC project before re creating the CC cluster - by deferring to the Google Default over the inherited value. See https://console.cloud.google.com/iam-admin/orgpolicies/compute-requireOsLogin


