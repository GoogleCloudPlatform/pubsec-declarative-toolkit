#!/bin/bash

# Create the Bootstrap Folder and capute its ID
gcloud resource-manager folders create \
--display-name=$FOLDER_NAME \
--organization=$ORG_ID

FOLDER_ID=$(gcloud resource-manager folders list --organization $ORG_ID --filter="display_name:${FOLDER_NAME}" --format='value(ID)')

# Creat the Configuration Project
gcloud project create $PROJECT_ID \
--folder $FOLDER_ID

# Configure the Cloud Shell ENV
gcloud config set project $PROJECT_ID
gcloud beta billing projects link "${PROJECT_ID}" --billing-account "${BILLING_ID}" --quiet

# Enable the Required Services
gcloud services enable compute.googleapis.com
gcloud services enable container.googleapis.com
gcloud services enable cloudresourcemanager.googleapis.com

# Configure Common ENV Vars
CLUSTER=config-controller
NETWORK=config-network
SUBNETWORK=config-subnet
REGION=northamerica-northeast1
AUTHORIZED_NETWORKS=$(dig +short myip.opendns.com @resolver1.opendns.com)/32
SA_NAME=config-control
SA_EMAIL=${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com

# Create the Network
gcloud compute networks create $NETWORK --subnet-mode custom

# Create the GKE Cluster to act as the Config Controller
gcloud container clusters create $CLUSTER --enable-binauthz \
--machine-type e2-standard-4 --image-type cos_containerd --num-nodes 1 \
--enable-shielded-nodes --no-enable-basic-auth --enable-ip-alias --shielded-secure-boot \
--workload-pool ${PROJECT_ID}.svc.id.goog --network $NETWORK --create-subnetwork name=$SUBNETWORK \
--region $REGION --enable-private-nodes \
--master-ipv4-cidr $MASTER_IPV4 \
--enable-master-authorized-networks \
--master-authorized-networks $AUTHORIZED_NETWORKS \
--enable-dataplane-v2 \
--release-channel regular \
--addons ConfigConnector \
--enable-stackdriver-kubernetes

# Creat the SA for Config Connector to use
gcloud iam service-account create $SA_NAME
gcloud projects add-iam-policy-binding $PROJECT_ID \
--member="serviceAccount:${SA_EMAIL}" \
--role="roles/owner"

gcloud iam service-accounts add-iam-policy-binding \
${SA_EMAIL} \
--member="serviceAccount:${PROJECT_ID}.svc.id.goog[cnrm-system/cnrm-controller-manager]" \
--role="roles/iam.workloadIdentityUser"

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

# Configure the config connector agent
gcloud container clusters get-credentials $CLUSTER --region $REGION
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

kubectl apply -f configconnector.yaml
kubectl create namespace config-control
kubectl annotate namespace config-control cnrm.cloud.google.com/project-id=${PROJECT_ID}