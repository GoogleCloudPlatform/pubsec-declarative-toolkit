#!/bin/bash

###########
# Use this script to destroy a deployed Config Controller Autopilot Cluster
##########

# Bash safeties: exit on error, pipelines can't hide errors
set -eo pipefail

if [ $# -eq 0 ]; then
    print_error "No input file provided.
Usage: bash setup-kcc.sh PATH_TO_ENV_FILE"
    exit 1
fi

# shellcheck source=/dev/null
# source the env file
source "$1"

# Project should already be linked to a client billing account
gcloud config set project $PROJECT_ID
gcloud config set compute/region $REGION

# Config controller get credentials
gcloud anthos config controller get-credentials $CLUSTER_NAME --location $REGION
kubens config-control

# Export the yakima service account email before deleting the cluster
SA_EMAIL="$(kubectl get ConfigConnectorContext -n config-control \
    -o jsonpath='{.items[0].spec.googleServiceAccount}' 2> /dev/null)"

# Delete Config controller
gcloud anthos config controller delete $CLUSTER_NAME --location $REGION --quiet

# Delete firewall rules
gcloud compute firewall-rules delete allow-egress-azure --quiet
gcloud compute firewall-rules delete allow-egress-github --quiet
gcloud compute firewall-rules delete allow-egress-internal --quiet
gcloud compute firewall-rules delete deny-egress-internet --quiet

# Delete DNS configuration
gcloud dns record-sets delete gcr.io. --zone="gcrio" --type="A" --quiet
gcloud dns record-sets delete *.gcr.io. --zone="gcrio" --type="CNAME" --quiet
gcloud dns record-sets delete googleapis.com. --zone="googleapis" --type="A" --quiet
gcloud dns record-sets delete *.googleapis.com. --zone="googleapis" --type="CNAME" --quiet
gcloud dns managed-zones delete gcrio --quiet
gcloud dns managed-zones delete googleapis --quiet

# Delete Cloud router and Cloud NAT
gcloud compute routers delete kcc-router --quiet

# Delete private endpoint
gcloud compute forwarding-rules delete endpoint1 --project=$PROJECT_ID --global --quiet

# Delte private ip for apis
gcloud compute addresses delete apis-private-ip --global --quiet

# Subnet
gcloud compute networks subnets delete $SUBNET --quiet

# VPC
gcloud compute networks delete $NETWORK --quiet

# Delete DNS remaining policy
gcloud dns policies update dnspolicy1 --networks=
gcloud dns policies delete dnspolicy1 --quiet

# Remove the serviceusage.serviceUsageConsumer role to the yakima service account
gcloud projects remove-iam-policy-binding "${PROJECT_ID}" \
  --member "serviceAccount:${SA_EMAIL}" \
  --role "roles/serviceusage.serviceUsageConsumer" \
  --project "${PROJECT_ID}"

# Remove the container.clusterAdmin role to the yakima service account
gcloud projects remove-iam-policy-binding "${PROJECT_ID}" \
  --member "serviceAccount:${SA_EMAIL}" \
  --role "roles/container.clusterAdmin" \
  --project "${PROJECT_ID}"

# Remove the iam.serviceAccountUser role to the default compute account
DEFAULT_COMPUTE_ACCOUNT=$(gcloud iam service-accounts list --filter='Compute Engine default' --format json |jq .[].email | sed 's/"//g')

gcloud projects remove-iam-policy-binding "${PROJECT_ID}" \
  --member "serviceAccount:${DEFAULT_COMPUTE_ACCOUNT}" \
  --role "roles/iam.serviceAccountUser" \
  --project "${PROJECT_ID}"

# Remove the iam.serviceAccountUser role to the yakima service account
gcloud projects remove-iam-policy-binding "${PROJECT_ID}" \
  --member "serviceAccount:${SA_EMAIL}" \
  --role "roles/iam.serviceAccountUser" \
  --project "${PROJECT_ID}"

# Remove the krmapihosting.serviceAgent role to the yakima service account
gcloud projects remove-iam-policy-binding "${PROJECT_ID}" \
  --member "serviceAccount:${SA_EMAIL}" \
  --role "roles/krmapihosting.serviceAgent" \
  --project "${PROJECT_ID}"

# Disable services
# Use --force flag to prevent COMMON_SU_SERVICE_HAS_USAGE Error
gcloud services disable krmapihosting.googleapis.com container.googleapis.com cloudresourcemanager.googleapis.com cloudbilling.googleapis.com serviceusage.googleapis.com servicedirectory.googleapis.com dns.googleapis.com --force