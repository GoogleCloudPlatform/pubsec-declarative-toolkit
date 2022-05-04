Advanced Install
==================================

This assumes you are running in Cloud Shell which has all of the prerequisites installed. 

If you are not the following resources are required.
* [Google Cloud SDK version >= 325.0.0](https://cloud.google.com/sdk/docs/downloads-versioned-archives)
* [kpt](https://kpt.dev/installation/)
* [kubectl](https://kubernetes.io/docs/tasks/tools/) ( >= v1.20)

1. Set Project ID, Cluster and Region Environment Variables
```
CLUSTER=config-controller
REGION=northamerica-northeast1
PROJECT_ID=<project_id>
NETWORK=config-control
SUBNET=config-control-subnet
```

2. Create Project
```
gcloud projects create $PROJECT_ID --name="Config Controller" --labels=type=infrastructure-automation --set-as-default
```

3. Enable Billing
```
gcloud beta billing projects link unique-project-name --billing-account 0X0X0X-0X0X0X-0X0X0X
```

4. Set the project ID
```
gcloud config set project $PROJECT_ID
```

5. Enable the required services
```
gcloud services enable krmapihosting.googleapis.com \
    container.googleapis.com \
    cloudresourcemanager.googleapis.com
```

6. Create a network and subnet
```
gcloud compute network create $NETWORK --subnet-mode=custom
gcloud compute network subnets create $SUBNET  \
--network $NETWORK \
--range 192.168.0.0/16 \
--region $REGION
```

7. Create the Config Controller Instance
```
gcloud anthos config controller create main --location us-east1 --network $NETWORK --subnet $SUBNET
```
```
gcloud container clusters get-credentials $CLUSTER --region $REGION
kubens config-control
```

8. Assign Permissions to the config connector Service Account.

```
export ORG_ID=0X0X0X-0X0X0X-0X0X0X
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

9. Now you are ready to deploy a solution!