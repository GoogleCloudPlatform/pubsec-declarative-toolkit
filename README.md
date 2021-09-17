# Kubernetes Config Connector Guardrails Deployment

Deployment of the GCP Guardrails Accelerator using Config Connector.

# Install Options
- Config Controller (Beta, Only available in `us-central1`)
- Install in standalone Kubernetes Cluster

## Create Folder and Project

```
FOLDER_NAME=CONFIG_CONTROLLER
ORG_ID=<gcp-org-id>
```

### Create the Folder and Project
```
gcloud resource-manager folders create \
   --display-name=$FOLDER_NAME \
   --organization=$ORG_ID
```

Get the Folder ID
```
FOLDER_ID=$(gcloud resource-manager folders list --organization $ORG_ID --filter="display_name:${FOLDER_NAME}" --format='value(ID)')
PROJECT_ID=MY-UNIQUE-PROJECT-ID
BILLING_ID=selectedbillingid
```

```
gcloud projects create $PROJECT_ID \
      --folder $FOLDER_ID
```

## Standalone Kubernetes Cluster Install

Set your project context
```
gcloud config set project $PROJECT_ID
gcloud beta billing projects link "${PROJECT_ID}" --billing-account "${BILLING_ID}" --quiet 
```

## Enable Required Services
```
gcloud services enable compute
gcloud services enable container
```

Set ENV Variables
```
CLUSTER=kcc-control
NETWORK=kcc-net
SUBNETWORK=kcc-subnet
REGION=northamerica-northeast1
MASTER_IPV4=172.16.0.32/28
AUTHORIZED_NETWORKS=0.0.0.0/32
SA_NAME=kcc-primary
SA_EMAIL=${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com
```

```
gcloud compute network create
gcloud compute networks create $NETWORK --subnet-mode custom
```

```
gcloud container clusters create $CLUSTER --enable-binauthz \
--machine-type e2-standard-4  --image-type cos_containerd --num-nodes 1 \
--enable-shielded-nodes --no-enable-basic-auth --enable-ip-alias --shielded-secure-boot \
--workload-pool ${PROJECT_ID}.svc.id.goog --network $NETWORK --create-subnetwork name=$SUBNETWORK --region $REGION \
--enable-private-nodes \
--master-ipv4-cidr $MASTER_IPV4 \
--enable-master-authorized-networks \
--master-authorized-networks $AUTHORIZED_NETWORKS \
--enable-dataplane-v2 \
--release-channel regular \
--addons ConfigConnector \
--enable-stackdriver-kubernetes
```

```
gcloud iam service-accounts create $SA_NAME
gcloud projects add-iam-policy-binding $PROJECT_ID \
--member="serviceAccount:${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com" \
--role="roles/owner"
```

```
gcloud iam service-accounts add-iam-policy-binding \
${SA_EMAIL} \
    --member="serviceAccount:${PROJECT_ID}.svc.id.goog[cnrm-system/cnrm-controller-manager]" \
    --role="roles/iam.workloadIdentityUser"
```

```
gcloud projects add-iam-policy-binding $PROJECT_ID \
--member="user:user@domain.com" \
--role="roles/container.admin"
```

```
gcloud organizations add-iam-policy-binding ${ORG_ID}  --member=serviceAccount:${SA_EMAIL} \
    --role=roles/billing.user
gcloud organizations add-iam-policy-binding ${ORG_ID}  --member=serviceAccount:${SA_EMAIL} \
    --role=roles/compute.networkAdmin
gcloud organizations add-iam-policy-binding ${ORG_ID}  --member=serviceAccount:${SA_EMAIL} \
    --role=roles/compute.xpnAdmin
gcloud organizations add-iam-policy-binding ${ORG_ID}  --member=serviceAccount:${SA_EMAIL} \
    --role=roles/iam.organizationRoleAdmin
gcloud organizations add-iam-policy-binding ${ORG_ID}  --member=serviceAccount:${SA_EMAIL} \
    --role=roles/orgpolicy.policyAdmin
gcloud organizations add-iam-policy-binding ${ORG_ID}  --member=serviceAccount:${SA_EMAIL} \
    --role=roles/resourcemanager.folderAdmin
gcloud organizations add-iam-policy-binding ${ORG_ID}  --member=serviceAccount:${SA_EMAIL} \
    --role=roles/resourcemanager.organizationAdmin
gcloud organizations add-iam-policy-binding ${ORG_ID}  --member=serviceAccount:${SA_EMAIL} \
    --role=roles/resourcemanager.projectCreator
gcloud organizations add-iam-policy-binding ${ORG_ID}  --member=serviceAccount:${SA_EMAIL} \
    --role=roles/resourcemanager.projectDeleter
gcloud organizations add-iam-policy-binding ${ORG_ID}  --member=serviceAccount:${SA_EMAIL} \
    --role=roles/resourcemanager.projectIamAdmin
gcloud organizations add-iam-policy-binding ${ORG_ID}  --member=serviceAccount:${SA_EMAIL} \
    --role=roles/resourcemanager.projectMover
gcloud organizations add-iam-policy-binding ${ORG_ID}  --member=serviceAccount:${SA_EMAIL} \
    --role=roles/logging.configWriter
gcloud organizations add-iam-policy-binding ${ORG_ID}  --member=serviceAccount:${SA_EMAIL} \
    --role=roles/resourcemanager.projectIamAdmin
gcloud organizations add-iam-policy-binding ${ORG_ID}  --member=serviceAccount:${SA_EMAIL} \
    --role=roles/serviceusage.serviceUsageAdmin
gcloud organizations add-iam-policy-binding ${ORG_ID}  --member=serviceAccount:${SA_EMAIL} \
    --role=roles/bigquery.dataEditor
gcloud organizations add-iam-policy-binding ${ORG_ID}  --member=serviceAccount:${SA_EMAIL} \
    --role=roles/storage.admin
```

Get context on the cluster
```
gcloud container clusters get-credentials $CLUSTER --region $REGION
```

```
cat > configconnector.yaml << EOF
# configconnector.yaml
apiVersion: core.cnrm.cloud.google.com/v1beta1
kind: ConfigConnector
metadata:
  # the name is restricted to ensure that there is only one
  # ConfigConnector resource installed in your cluster
  name: configconnector.core.cnrm.cloud.google.com
spec:
 mode: cluster
 googleServiceAccount: "${SA_EMAIL}"
EOF
```

kubectl apply -f configconnector.yaml

Create a Namespace for the resources
```
kubectl create namespace config-control
```

Annotage it with the project ID
```
kubectl annotate namespace config-control cnrm.cloud.google.com/project-id=${PROJECT_ID}
```

## Config Controller installation

Bootstrap Project and Config Controller.

```
gcloud services enable krmapihosting.googleapis.com \
    container.googleapis.com \
    cloudresourcemanager.googleapis.com
```

This will take 15 or so minutes
```
gcloud alpha anthos config controller create my-awesome-kcc \
    --location=us-central1
```

```
gcloud alpha anthos config controller get-credentials my-awesome-kcc \
    --location us-central1
```

Give the Controller Permissions

```
export PROJECT_ID=$(gcloud config get-value project)
export SA_EMAIL="$(kubectl get ConfigConnectorContext -n config-control \
    -o jsonpath='{.items[0].spec.googleServiceAccount}' 2> /dev/null)"

gcloud organizations add-iam-policy-binding ${ORG_ID}  --member=serviceAccount:${SA_EMAIL} \
    --role=roles/billing.user
gcloud organizations add-iam-policy-binding ${ORG_ID}  --member=serviceAccount:${SA_EMAIL} \
    --role=roles/compute.networkAdmin
gcloud organizations add-iam-policy-binding ${ORG_ID}  --member=serviceAccount:${SA_EMAIL} \
    --role=roles/compute.xpnAdmin
gcloud organizations add-iam-policy-binding ${ORG_ID}  --member=serviceAccount:${SA_EMAIL} \
    --role=roles/iam.organizationRoleAdmin
gcloud organizations add-iam-policy-binding ${ORG_ID}  --member=serviceAccount:${SA_EMAIL} \
    --role=roles/orgpolicy.policyAdmin
gcloud organizations add-iam-policy-binding ${ORG_ID}  --member=serviceAccount:${SA_EMAIL} \
    --role=roles/resourcemanager.folderAdmin
gcloud organizations add-iam-policy-binding ${ORG_ID}  --member=serviceAccount:${SA_EMAIL} \
    --role=roles/resourcemanager.organizationAdmin
gcloud organizations add-iam-policy-binding ${ORG_ID}  --member=serviceAccount:${SA_EMAIL} \
    --role=roles/resourcemanager.projectCreator
gcloud organizations add-iam-policy-binding ${ORG_ID}  --member=serviceAccount:${SA_EMAIL} \
    --role=roles/resourcemanager.projectDeleter
gcloud organizations add-iam-policy-binding ${ORG_ID}  --member=serviceAccount:${SA_EMAIL} \
    --role=roles/resourcemanager.projectIamAdmin
gcloud organizations add-iam-policy-binding ${ORG_ID}  --member=serviceAccount:${SA_EMAIL} \
    --role=roles/resourcemanager.projectMover
gcloud organizations add-iam-policy-binding ${ORG_ID}  --member=serviceAccount:${SA_EMAIL} \
    --role=roles/logging.configWriter
gcloud organizations add-iam-policy-binding ${ORG_ID}  --member=serviceAccount:${SA_EMAIL} \
    --role=roles/resourcemanager.projectIamAdmin
gcloud organizations add-iam-policy-binding ${ORG_ID}  --member=serviceAccount:${SA_EMAIL} \
    --role=roles/serviceusage.serviceUsageAdmin
gcloud organizations add-iam-policy-binding ${ORG_ID}  --member=serviceAccount:${SA_EMAIL} \
    --role=roles/bigquery.dataEditor
gcloud organizations add-iam-policy-binding ${ORG_ID}  --member=serviceAccount:${SA_EMAIL} \
    --role=roles/storage.admin
```

## Getting Up and Running

Assume you have SSH access to this repo.

```
kpt pkg get git@github.com:cartyc/gcp-sandbox.git/sandbox
```