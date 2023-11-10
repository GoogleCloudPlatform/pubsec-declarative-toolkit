#!/bin/bash

# script to bootstrap a Config Controller project

# Bash safeties: exit on error, pipelines can't hide errors
set -o errexit
set -o pipefail

# get the directory of this script
SCRIPT_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# source print-colors.sh for better readability of the script's outputs
# shellcheck source-path=scripts/bootstrap # tell shellcheck where to look
source "${SCRIPT_ROOT}/../common/print-colors.sh"

# Set a default value for the options
autopilot_opt=false
folder_opt=false

# Use getopts to parse the options
while getopts ":af" opt; do
  case ${opt} in
    a ) # If the -a option is provided, set autopilot_opt to true
      autopilot_opt=true
      ;;
    f ) # If the -f option is provided, set folder_opt to true
      folder_opt=true
      ;;
    \? ) # If an invalid option is provided, print usage information and exit
      print_error "Usage: bash setup-kcc.sh [-af] PATH_TO_ENV_FILE
        -a: autopilot. It will deploy an autopilot cluster instead of a standard cluster
        -f: folder_opt. It will bootstrap the landing zone in a folder instead than at the org level"
      exit 1
      ;;
  esac
done

# Shift the positional parameters to remove the options that have been parsed by getopts
shift $((OPTIND -1))

if [ $# -eq 0 ]; then
    print_error "Usage: bash setup-kcc.sh [-af] PATH_TO_ENV_FILE
        -a: autopilot. It will deploy an autopilot cluster instead of a standard cluster
        -f: folder_opt. It will bootstrap the landing zone in a folder instead than at the org level"
    exit 1
fi

# source the env file
# shellcheck disable=SC1090 # don't look for sourced file, it won't exist in this repo
source "$1"

print_info "Update the logging for region"
gcloud alpha logging settings update --organization="$ORG_ID" --storage-location="$REGION"

print_info "create folder and project"
# folder_opt: deploy in a folder instead than at the org level
if [ "$folder_opt" = true ]; then
  gcloud resource-manager folders create --display-name="$LZ_FOLDER_NAME" --folder="$ROOT_FOLDER_ID" --format="value(name)"
  gcloud projects create "$PROJECT_ID" --set-as-default --folder="$ROOT_FOLDER_ID"
else
  gcloud resource-manager folders create --display-name="$LZ_FOLDER_NAME" --organization="$ORG_ID" --format="value(name)"
  gcloud projects create "$PROJECT_ID" --set-as-default --organization="$ORG_ID"
fi

print_info "Link billing account"
gcloud beta billing projects link "$PROJECT_ID" --billing-account "$BILLING_ID"
print_info "sleep 30s to allow for project creation before enabling services"
sleep 30
gcloud config set project "$PROJECT_ID"

print_info "Enable services"
gcloud services enable krmapihosting.googleapis.com container.googleapis.com cloudresourcemanager.googleapis.com cloudbilling.googleapis.com serviceusage.googleapis.com servicedirectory.googleapis.com dns.googleapis.com

print_info "VPC"
gcloud compute networks create "$NETWORK" --subnet-mode=custom

print_info "Subnet"
gcloud compute networks subnets create "$SUBNET"  \
--network "$NETWORK" \
--range 192.168.0.0/16 \
--region "$REGION" \
--stack-type=IPV4_ONLY \
--enable-private-ip-google-access \
--enable-flow-logs --logging-aggregation-interval=interval-5-sec --logging-flow-sampling=1.0 --logging-metadata=include-all

print_info "Cloud router and Cloud NAT"
gcloud compute routers create kcc-router --project="$PROJECT_ID"  --network="$NETWORK"  --asn=64513 --region="$REGION"
gcloud compute routers nats create kcc-router --router=kcc-router --region="$REGION" --auto-allocate-nat-external-ips --nat-all-subnet-ip-ranges --enable-logging

print_info "enable logging for dns"
gcloud dns policies create dnspolicy1 \
--networks="$NETWORK" \
--enable-logging \
--description="dns policy to enable logging"

print_info "private ip for apis"
gcloud compute addresses create apis-private-ip \
--global \
--purpose=PRIVATE_SERVICE_CONNECT \
--addresses=10.255.255.254 \
--network="$NETWORK"

print_info "sleep 15s to allow for address to create"
sleep 15

print_info "private endpoint"
gcloud compute forwarding-rules create endpoint1 \
--global \
--network="$NETWORK" \
--address=apis-private-ip \
--target-google-apis-bundle=all-apis \
--service-directory-registration=projects/"$PROJECT_ID"/locations/"$REGION"

print_info "private dns zone for googleapis.com"
gcloud dns managed-zones create googleapis \
--description="dns zone for googleapis" \
--dns-name=googleapis.com \
--networks="$NETWORK" \
--visibility=private

gcloud dns record-sets create googleapis.com. --zone="googleapis" --type="A" --ttl="300" --rrdatas="10.255.255.254"

gcloud dns record-sets create "*.googleapis.com." --zone="googleapis" --type="CNAME" --ttl="300" --rrdatas="googleapis.com."

print_info "private dns zone for gcr.io"
gcloud dns managed-zones create gcrio \
--description="dns zone for gcrio" \
--dns-name=gcr.io \
--networks="$NETWORK" \
--visibility=private

gcloud dns record-sets create gcr.io. --zone="gcrio" --type="A" --ttl="300" --rrdatas="10.255.255.254"

gcloud dns record-sets create "*.gcr.io." --zone="gcrio" --type="CNAME" --ttl="300" --rrdatas="gcr.io."

print_info "Allow egress to AZDO (optional)"
# Should be revised periodically - https://learn.microsoft.com/en-us/azure/devops/organizations/security/allow-list-ip-url?view=azure-devops&tabs=IP-V4#ip-addresses-and-range-restrictions
gcloud compute firewall-rules create allow-egress-azure --action ALLOW --rules tcp:22,tcp:443 --destination-ranges 13.107.6.0/24,13.107.9.0/24,13.107.42.0/24,13.107.43.0/24 --direction EGRESS --priority 5000 --network "$NETWORK" --enable-logging

print_info "Allow egress to Github (optional)"
# Should be revised periodically - https://api.github.com/meta
gcloud compute firewall-rules create allow-egress-github --action ALLOW --rules tcp:22,tcp:443 --destination-ranges 192.30.252.0/22,185.199.108.0/22,140.82.112.0/20,143.55.64.0/20,20.201.28.151/32,20.205.243.166/32,102.133.202.242/32,20.248.137.48/32,20.207.73.82/32,20.27.177.113/32,20.200.245.247/32,20.233.54.53/32,20.201.28.152/32,20.205.243.160/32,102.133.202.246/32,20.248.137.50/32,20.207.73.83/32,20.27.177.118/32,20.200.245.248/32,20.233.54.52/32 --direction EGRESS --priority 5001 --network "$NETWORK" --enable-logging

print_info "Allow egress to internal, peered vpc and secondary ranges"
gcloud compute firewall-rules create allow-egress-internal --action ALLOW --rules=all --destination-ranges 192.168.0.0/16,172.16.0.128/28,10.0.0.0/8 --direction EGRESS --priority 1000 --network "$NETWORK" --enable-logging

print_info "Deny egress to internet"
gcloud compute firewall-rules create deny-egress-internet --action DENY --rules=all --destination-ranges 0.0.0.0/0 --direction EGRESS --priority 65535 --network "$NETWORK" --enable-logging

print_info "Create Config controller"
# autopilot_opt: Deploy an autopilot cluster instead of a standard cluster
if [ "$autopilot_opt" = true ]; then
  gcloud anthos config controller create "$CLUSTER" --location "$REGION" --network "$NETWORK" --subnet "$SUBNET" --master-ipv4-cidr-block="172.16.0.128/28" --full-management
else
  gcloud anthos config controller create "$CLUSTER" --location "$REGION" --network "$NETWORK" --subnet "$SUBNET"
fi

print_info "Config controller get credentials"
gcloud anthos config controller get-credentials "$CLUSTER" --location "$REGION"

SA_EMAIL="$(kubectl get ConfigConnectorContext -n config-control \
    -o jsonpath='{.items[0].spec.googleServiceAccount}' 2> /dev/null)"

gcloud organizations add-iam-policy-binding "${ORG_ID}" \
  --member="serviceAccount:${SA_EMAIL}" \
  --role=roles/resourcemanager.organizationAdmin \
  --condition=None

gcloud projects add-iam-policy-binding "${PROJECT_ID}" \
  --member "serviceAccount:${SA_EMAIL}" \
  --role "roles/serviceusage.serviceUsageConsumer" \
  --project "${PROJECT_ID}"

print_info "Create git-creds for Repo access"
kubectl create secret generic git-creds --namespace="config-management-system" --from-literal=username="${GIT_USERNAME}" --from-literal=token="${TOKEN}"

cat << EOF > ./root-sync.yaml
apiVersion: configsync.gke.io/v1beta1
kind: RootSync
metadata:
  name: root-sync
  namespace: config-management-system
spec:
  sourceFormat: unstructured
  git:
    repo: "https://github.com/$GIT_USERNAME/$CONFIG_SYNC_REPO.git"
    branch: main # eg. : main
    dir: "${CONFIG_SYNC_DIR}" # eg.: csync/deploy/<env>
    revision: "${CONFIG_SYNC_VERSION}"
    auth: token
    secretRef:
      name: git-creds
EOF

print_info "Apply root sync"
kubectl apply -f root-sync.yaml

# Further steps
print_warning "The root-sync.yaml file should be checked into the <tier1-REPO>"

print_info "Create a Private repository to store your Landing zone configurations"
curl -H "Authorization: token $TOKEN" -d "{\"name\": \"$CONFIG_SYNC_REPO\", \"private\": true}" https://api.github.com/user/repos

# Create the folder structure using Git
git clone git@github.com:$GIT_USERNAME/$CONFIG_SYNC_REPO.git
cd "$CONFIG_SYNC_REPO" || exit
mkdir "$CONFIG_SYNC_DIR"

# Get packages
if [ -n "$GATEKEEPER_VERSION" ]; then
    kpt pkg get https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit.git/solutions/gatekeeper-policies@$GATEKEEPER_VERSION
fi

if [ -n "$CORE_LZ_VERSION" ]; then
    kpt pkg get https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit.git/solutions/core-landing-zone@$CORE_LZ_VERSION
fi

if [ -n "$EXPERIMENTATION" ]; then
    kpt pkg get https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit.git/solutions/experimentation@$EXPERIMENTATION_VERSION
fi

print_info "Private GitHub repository \"$CONFIG_SYNC_REPO\" with folder \"$CONFIG_SYNC_DIR\" created successfully."

print_info "--------------------------------------------------------------------"

print_info "Modify the setters.yaml files in all packages then render all packages"