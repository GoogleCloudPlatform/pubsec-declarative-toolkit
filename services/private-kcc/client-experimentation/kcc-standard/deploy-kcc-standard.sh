#!/bin/bash
# Script to deploy a Standard Config Controller Cluster
set -eo pipefail

echo_log() {
    echo "[INFO] $1"
}

print_error() {
    echo "[ERROR] $1" >&2
}

if [ $# -eq 0 ]; then
    print_error "No input file provided.\nUsage: bash setup-kcc.sh PATH_TO_ENV_FILE"
    exit 1
fi

if [ -f "$1" ]; then
    # shellcheck source=/dev/null
    source "$1"
else
    print_error "Environment file not found at $1"
    exit 1
fi

# validate required environment variables
REQUIRED_VARS=("PROJECT_ID" "NETWORK" "SUBNET" "REGION" "CLUSTER_NAME")
for VAR in "${REQUIRED_VARS[@]}"; do
    if [ -z "${!VAR}" ]; then
        print_error "$VAR is not set in the environment file."
        exit 1
    fi
done

# enable necessary APIs
echo_log "Enabling required Google Cloud services..."
gcloud config set project "$PROJECT_ID"
gcloud services enable \
    krmapihosting.googleapis.com \
    container.googleapis.com \
    cloudresourcemanager.googleapis.com \
    cloudbilling.googleapis.com \
    serviceusage.googleapis.com \
    servicedirectory.googleapis.com \
    dns.googleapis.com

# create VPC
echo_log "Creating VPC: $NETWORK"
gcloud compute networks create "$NETWORK" --subnet-mode=custom

# create Subnet
echo_log "Creating Subnet: $SUBNET"
gcloud compute networks subnets create "$SUBNET" \
    --network "$NETWORK" \
    --range 192.168.0.0/16 \
    --region "$REGION" \
    --stack-type=IPV4_ONLY \
    --enable-private-ip-google-access \
    --enable-flow-logs \
    --logging-aggregation-interval=interval-5-sec \
    --logging-flow-sampling=1.0 \
    --logging-metadata=include-all

# create cloud router and NAT
echo_log "Setting up Cloud Router and NAT..."
gcloud compute routers create kcc-router --project="$PROJECT_ID" \
    --network="$NETWORK" --asn=64513 --region="$REGION"
gcloud compute routers nats create kcc-router \
    --router=kcc-router --region="$REGION" \
    --auto-allocate-nat-external-ips \
    --nat-all-subnet-ip-ranges \
    --enable-logging

# configure DNS policies
echo_log "Configuring DNS policies..."
gcloud dns policies create dnspolicy1 \
    --networks="$NETWORK" \
    --enable-logging \
    --description="DNS policy to enable logging"

# reserve private IP for APIs
echo_log "Reserving private IP for APIs..."
gcloud compute addresses create apis-private-ip \
    --global \
    --purpose=PRIVATE_SERVICE_CONNECT \
    --addresses=10.255.255.254 \
    --network="$NETWORK"

# Create private endpoint
echo_log "Creating private endpoint..."
gcloud compute forwarding-rules create endpoint1 \
    --global \
    --network="$NETWORK" \
    --address=apis-private-ip \
    --target-google-apis-bundle=all-apis \
    --service-directory-registration=projects/"$PROJECT_ID"/locations/"$REGION"

# Configure private DNS zones
echo_log "Configuring private DNS zones..."
gcloud dns managed-zones create googleapis \
    --description="DNS zone for googleapis" \
    --dns-name=googleapis.com \
    --networks="$NETWORK" \
    --visibility=private
gcloud dns record-sets create googleapis.com. --zone="googleapis" --type="A" --ttl="300" --rrdatas="10.255.255.254"
gcloud dns record-sets create "*.googleapis.com." --zone="googleapis" --type="CNAME" --ttl="300" --rrdatas="googleapis.com."

# repeat for gcr.io zone
gcloud dns managed-zones create gcrio \
    --description="DNS zone for gcr.io" \
    --dns-name=gcr.io \
    --networks="$NETWORK" \
    --visibility=private
gcloud dns record-sets create gcr.io. --zone="gcrio" --type="A" --ttl="300" --rrdatas="10.255.255.254"
gcloud dns record-sets create "*.gcr.io." --zone="gcrio" --type="CNAME" --ttl="300" --rrdatas="gcr.io."

# create firewall rules
echo_log "Creating firewall rules..."
create_firewall_rule() {
    local RULE_NAME=$1
    local ACTION=$2
    local RULES=$3
    local DEST_RANGES=$4
    local DIRECTION=$5
    local PRIORITY=$6

    gcloud compute firewall-rules create "$RULE_NAME" \
        --action "$ACTION" \
        --rules "$RULES" \
        --destination-ranges "$DEST_RANGES" \
        --direction "$DIRECTION" \
        --priority "$PRIORITY" \
        --network "$NETWORK" \
        --enable-logging
}

create_firewall_rule "allow-egress-azure" ALLOW "tcp:22,tcp:443" "13.107.6.0/24,13.107.9.0/24,13.107.42.0/24,13.107.43.0/24" EGRESS 5000
create_firewall_rule "allow-egress-github" ALLOW "tcp:22,tcp:443" "192.30.252.0/22,185.199.108.0/22,140.82.112.0/20" EGRESS 5001
create_firewall_rule "allow-egress-internal" ALLOW "all" "192.168.0.0/16,172.16.0.128/28,10.0.0.0/8" EGRESS 1000
create_firewall_rule "deny-egress-internet" DENY "all" "0.0.0.0/0" EGRESS 65535

# create Config Controller
echo_log "Creating Config Controller..."
gcloud anthos config controller create "$CLUSTER_NAME" \
    --location "$REGION" \
    --network "$NETWORK" \
    --subnet "$SUBNET"

echo_log "Fetching credentials for Config Controller..."
gcloud anthos config controller get-credentials "$CLUSTER_NAME" --location "$REGION"
kubens config-control

# configure IAM roles
echo_log "Configuring IAM roles..."
SA_EMAIL="$(kubectl get ConfigConnectorContext -n config-control \
    -o jsonpath='{.items[0].spec.googleServiceAccount}' 2>/dev/null)"
DEFAULT_COMPUTE_ACCOUNT=$(gcloud iam service-accounts list --filter='Compute Engine default' --format json | jq -r '.[].email')

assign_role() {
    local MEMBER=$1
    local ROLE=$2

    gcloud projects add-iam-policy-binding "$PROJECT_ID" \
        --member "$MEMBER" \
        --role "$ROLE"
}

assign_role "serviceAccount:${SA_EMAIL}" "roles/serviceusage.serviceUsageConsumer"
assign_role "serviceAccount:${SA_EMAIL}" "roles/container.clusterAdmin"
assign_role "serviceAccount:${DEFAULT_COMPUTE_ACCOUNT}" "roles/iam.serviceAccountUser"
assign_role "serviceAccount:${SA_EMAIL}" "roles/iam.serviceAccountUser"
assign_role "serviceAccount:${SA_EMAIL}" "roles/krmapihosting.serviceAgent"

echo_log "Cluster setup completed successfully."
