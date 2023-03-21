#!/bin/bash

###########
# Use this script to deploy an Autopilot Config Controller Cluster
##########

# Bash safeties: exit on error, pipelines can't hide errors
set -eo pipefail

if [ $# -eq 0 ]; then
    print_error "No input file provided.
Usage: bash setup-kcc.sh PATH_TO_ENV_FILE"
    exit 1
fi

# source the env file
source $1

# Project should already be linked to a client billing account
gcloud config set project $PROJECT_ID
gcloud services enable krmapihosting.googleapis.com container.googleapis.com cloudresourcemanager.googleapis.com cloudbilling.googleapis.com serviceusage.googleapis.com servicedirectory.googleapis.com dns.googleapis.com
export PROJECT_NUM=$(gcloud projects describe $PROJECT_ID --format="value(projectNumber)")

# VPC
gcloud compute networks create $NETWORK --subnet-mode=custom

# Subnet
gcloud compute networks subnets create $SUBNET  \
--network $NETWORK \
--range 192.168.0.0/16 \
--region $REGION \
--stack-type=IPV4_ONLY \
--enable-private-ip-google-access \
--enable-flow-logs --logging-aggregation-interval=interval-5-sec --logging-flow-sampling=1.0 --logging-metadata=include-all

# Cloud router and Cloud NAT
gcloud compute routers create kcc-router --project=$PROJECT_ID  --network=$NETWORK  --asn=64513 --region=$REGION
gcloud compute routers nats create kcc-router --router=kcc-router --region=$REGION --auto-allocate-nat-external-ips --nat-all-subnet-ip-ranges --enable-logging

# enable logging for dns
gcloud dns policies create dnspolicy1 \
--networks=$NETWORK \
--enable-logging \
--description="dns policy to enable logging"

# private ip for apis
gcloud compute addresses create apis-private-ip \
--global \
--purpose=PRIVATE_SERVICE_CONNECT \
--addresses=10.255.255.254 \
--network=$NETWORK

# private endpoint
gcloud compute forwarding-rules create endpoint1 \
--global \
--network=$NETWORK \
--address=apis-private-ip \
--target-google-apis-bundle=all-apis \
--service-directory-registration=projects/$PROJECT_ID/locations/$REGION

# private dns zone for googleapis.com
gcloud dns managed-zones create googleapis \
--description="dns zone for googleapis" \
--dns-name=googleapis.com \
--networks=$NETWORK \
--visibility=private

gcloud dns record-sets create googleapis.com. --zone="googleapis" --type="A" --ttl="300" --rrdatas="10.255.255.254"

gcloud dns record-sets create *.googleapis.com. --zone="googleapis" --type="CNAME" --ttl="300" --rrdatas="googleapis.com."

# private dns zone for gcr.io
gcloud dns managed-zones create gcrio \
--description="dns zone for gcrio" \
--dns-name=gcr.io \
--networks=$NETWORK \
--visibility=private

gcloud dns record-sets create gcr.io. --zone="gcrio" --type="A" --ttl="300" --rrdatas="10.255.255.254"

gcloud dns record-sets create *.gcr.io. --zone="gcrio" --type="CNAME" --ttl="300" --rrdatas="gcr.io."

# Allow egress to AZDO (optional) - should be revised periodically - https://learn.microsoft.com/en-us/azure/devops/organizations/security/allow-list-ip-url?view=azure-devops&tabs=IP-V4#ip-addresses-and-range-restrictions
gcloud compute firewall-rules create allow-egress-azure --action ALLOW --rules tcp:22,tcp:443 --destination-ranges 13.107.6.0/24,13.107.9.0/24,13.107.42.0/24,13.107.43.0/24 --direction EGRESS --priority 5000 --network $NETWORK --enable-logging

# Allow egress to Github (optional) - should be revised periodically - https://api.github.com/meta
gcloud compute firewall-rules create allow-egress-github --action ALLOW --rules tcp:22,tcp:443 --destination-ranges 192.30.252.0/22,185.199.108.0/22,140.82.112.0/20,143.55.64.0/20,20.201.28.151/32,20.205.243.166/32,102.133.202.242/32,20.248.137.48/32,20.207.73.82/32,20.27.177.113/32,20.200.245.247/32,20.233.54.53/32,20.201.28.152/32,20.205.243.160/32,102.133.202.246/32,20.248.137.50/32,20.207.73.83/32,20.27.177.118/32,20.200.245.248/32,20.233.54.52/32 --direction EGRESS --priority 5001 --network $NETWORK --enable-logging

# Allow egress to internal, peered vpc and secondary ranges
# 172.16.0.0/28 - KCC Autopilot Cluster
# 172.16.0.32/28 - GKE Cluster
gcloud compute firewall-rules create allow-egress-internal --action ALLOW --rules=all --destination-ranges 192.168.0.0/16,$MASTER_IPV4_CIDR_BLOCK,172.16.0.128/28,172.16.0.32/28,10.0.0.0/8 --direction EGRESS --priority 1000 --network $NETWORK --enable-logging

# Deny egress to internet
gcloud compute firewall-rules create deny-egress-internet --action DENY --rules=all --destination-ranges 0.0.0.0/0 --direction EGRESS --priority 65535 --network $NETWORK --enable-logging

# Create and Config controller
gcloud anthos config controller create $CLUSTER_NAME --location $REGION --network $NETWORK --subnet $SUBNET --master-ipv4-cidr-block=$MASTER_IPV4_CIDR_BLOCK --full-management

# Config controller get credentials
gcloud anthos config controller get-credentials $CLUSTER_NAME --location $REGION
kubens config-control

# Export the yakima service account email
export SA_EMAIL="$(kubectl get ConfigConnectorContext -n config-control \
    -o jsonpath='{.items[0].spec.googleServiceAccount}' 2> /dev/null)"

# Assign the serviceusage.serviceUsageConsumer role to the yakima service account
# This is required to deploy the gke cluster
gcloud projects add-iam-policy-binding "${PROJECT_ID}" \
  --member "serviceAccount:${SA_EMAIL}" \
  --role "roles/serviceusage.serviceUsageConsumer" \
  --project "${PROJECT_ID}"

# Assign the container.clusterAdmin role to the yakima service account
# This is required to deploy the gke cluster
gcloud projects add-iam-policy-binding "${PROJECT_ID}" \
  --member "serviceAccount:${SA_EMAIL}" \
  --role "roles/container.clusterAdmin" \
  --project "${PROJECT_ID}"

# Assign the iam.serviceAccountUser role to the default compute account
# This is required to deploy the gke cluster
export DEFAULT_COMPUTE_ACCOUNT=$(gcloud iam service-accounts list --filter='Compute Engine default' --format json |jq .[].email | sed 's/"//g')

gcloud projects add-iam-policy-binding "${PROJECT_ID}" \
  --member "serviceAccount:${DEFAULT_COMPUTE_ACCOUNT}" \
  --role "roles/iam.serviceAccountUser" \
  --project "${PROJECT_ID}"

# Assign the iam.serviceAccountUser role to the yakima service account
# This is required to deploy the gke worker node pool
gcloud projects add-iam-policy-binding "${PROJECT_ID}" \
  --member "serviceAccount:${SA_EMAIL}" \
  --role "roles/iam.serviceAccountUser" \
  --project "${PROJECT_ID}"

# Assign the krmapihosting.serviceAgent role to the yakima service account
# This is required to deploy the gke worker node pool
gcloud projects add-iam-policy-binding "${PROJECT_ID}" \
  --member "serviceAccount:${SA_EMAIL}" \
  --role "roles/krmapihosting.serviceAgent" \
  --project "${PROJECT_ID}"
