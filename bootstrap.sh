#!/bin/bash
# Copyright 2021 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


# Name of this project
PROGRAM_NAME="PBMM Sandbox"

# Config Controller release version
CC_RELEASE="GA"

# Log file name
LOGFILE="bootstrap-log-$(date +"%FT%T").log"

# Configure Common ENV Vars
CLUSTER=config-controller
NETWORK=config-network
SUBNETWORK=config-subnet
REGION=northamerica-northeast1
MASTER_IPV4=172.16.0.32/28
AUTHORIZED_NETWORKS=$(dig +short myip.opendns.com @resolver1.opendns.com)/32
SA_NAME=config-control

# Colors for console output
BLUE="\e[34m"
RED="\e[91m"
GREEN="\e[32m"
RESET="\e[0m"
BOLD="\e[1m"

# Helper function to show which arguments are required and optional
usage() {
    echo -e "${BOLD}${RED}ERROR:${RESET} ($0) Folder and Org ID argument required.\n${BLUE}Usage:${RESET} -f <FOLDER NAME> -o <ORG ID> [-p <PROJECT ID>] [-b <BILLING ID>]" 1>&2; exit;
}

# Starter function to get the ball rolling
setup_options() {
    echo -e "\n${BOLD}${BLUE}${PROGRAM_NAME} Environment Setup${RESET}"
    echo -e "\nDo you want to install the ${PROGRAM_NAME} in a ${GREEN}standalone GKE Cluster${RESET} or ${GREEN}Config Controller (${CC_RELEASE})${RESET}?"
    echo "1) Standalone GKE Cluster"
    echo "2) (${CC_RELEASE}) Config Controller"
    echo "3) Quit"

    read -p "#? " SETUP_CHOICE

    if [ $SETUP_CHOICE == "3" ]; then
        exit
    fi
}

# Helper function to pull the list of billing accounts the current user has access to and choose one to use
billing() {
    shopt -s extglob
    STR="@("
    while IFS= read -r LINE; do
        BA+=("${LINE}")        
        STR+="${LINE}|"
    done < <(gcloud alpha billing accounts list --format="value[separator=' - '](NAME, ACCOUNT_ID)")
    STR=("${STR:0:-1})")

    echo -e "\nPlease choose a billing account that will be used for the sandbox:"
    select BID in "${BA[@]}" "Quit"; do
        case ${BID} in
            $STR)
                BILLING_ID=${BID: -20}
                break
                ;;
            "Quit")
                exit
                ;;
            *)
                echo -e "${BOLD}${RED}ERROR:${RESET} Invalid selection."
                break
                ;;
        esac
    done
}

# Execute a command, add it to the logfile and test the output status for any errors.
exec_cmd() {
    "$@" 2>&1 | tee -a $LOGFILE

    if [ ${PIPESTATUS[0]} -ne 0 ]; then
        exit ${PIPESTATUS[0]}
    fi
}

# Log text message to log file and console, remove colour coding from log file text
log_message () {
    set -- echo -e "$@"

    $@
    $@ | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[mGK]//g" | tee -a $LOGFILE > /dev/null
}

# Read the options / arguments and set the script variables
while getopts ":f:o:p:b:" opt; do
    case "${opt}" in
        f)
            FOLDER_NAME=${OPTARG}
            ;;
        o)
            ORG_ID=${OPTARG}
            ;;
        p)
            PROJECT_ID=${OPTARG}
            ;;
        b)
            BILLING_ID=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

# If the requried folder name and org id are not provide show the options usages.
if [ -z "${FOLDER_NAME}" ] || [ -z "${ORG_ID}" ]; then
    usage
fi

# If project id is not provided, use the default with a random string. This can still cause collisions, random is only so random :)
if [ -z "${PROJECT_ID}" ]; then
    PROJECT_ID="config-${RANDOM}"
fi


# Choose a setup path. Standalong or Config Controller
if [ -z "${SETUP_CHOICE}" ]; then
    setup_options
fi

# If no billing id is provided, then search the current users billing ids and allow them to select one
if [ -z "${BILLING_ID}" ]; then
    billing
fi

# Create the log file
touch $LOGFILE

# Check to see if the folder already exists; if not then create it
FOLDER_ID=$(gcloud resource-manager folders list --organization $ORG_ID --filter="display_name:${FOLDER_NAME}" --format="value(ID)")

if [ -z "${FOLDER_ID}" ]; then
    unset FOLDER_ID

    log_message "${GREEN}Creating Folder (${FOLDER_NAME})....${RESET}"
    # Create the Bootstrap Folder and capture its ID
    exec_cmd gcloud resource-manager folders create --display-name=$FOLDER_NAME --organization=$ORG_ID

    FOLDER_ID=$(gcloud resource-manager folders list --organization $ORG_ID --filter="display_name:${FOLDER_NAME}" --format="value(ID)")
fi

# Check to see if the project already exists; if not then create it
if [ -z $(gcloud projects list --filter="PROJECT_ID:${PROJECT_ID}" --format="value(PROJECT_ID)") ]; then
    log_message "${GREEN}Creating Project (${PROJECT_ID})....${RESET}"
    # Creat the Configuration Project
    exec_cmd gcloud projects create $PROJECT_ID --folder $FOLDER_ID
fi

# Configure the Cloud Shell ENV
log_message  "${GREEN}Setting gcloud context to active project...${RESET}"
exec_cmd gcloud config set project $PROJECT_ID

log_message "${GREEN}Getting project number for active project...${RESET}"
PROJECT_NUMBER=$(exec_cmd gcloud projects list --filter="project_id: ${PROJECT_ID}" --format="value(PROJECT_NUMBER)")

log_message "${GREEN}Adding billing account to project...${RESET}"
exec_cmd gcloud beta billing projects link ${PROJECT_ID} --billing-account ${BILLING_ID}

standalone_setup() {
    SA_EMAIL=${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com

    log_message "${GREEN}Enabling Services....${RESET}"
    # Enable the Required Services
    exec_cmd gcloud services enable compute.googleapis.com
    exec_cmd gcloud services enable container.googleapis.com
    exec_cmd gcloud services enable cloudresourcemanager.googleapis.com
    exec_cmd gcloud services enable cloudbilling.googleapis.com


    if [ -z $(gcloud compute networks list --filter="name=('${NETWORK}')" --format="value(NAME)") ]; then
        log_message "${GREEN}Creating VPC (${NETWORK})....${RESET}"
        # Create the Network
        exec_cmd gcloud compute networks create $NETWORK --subnet-mode custom
    fi

    log_message "${GREEN}Configuring Org Policies for GKE on folder (${FOLDER_ID})....${RESET}"
    exec_cmd gcloud resource-manager org-policies disable-enforce constraints/compute.requireOsLogin --folder ${FOLDER_ID}

    exec_cmd gcloud resource-manager org-policies disable-enforce constraints/compute.requireShieldedVm  --folder ${FOLDER_ID}

    cat > restrictVpcPeering.yaml << ENDOFFILE
constraint: constraints/compute.restrictVpcPeering
listPolicy:
  allValues: ALLOW
ENDOFFILE

    exec_cmd gcloud resource-manager org-policies set-policy restrictVpcPeering.yaml --folder ${FOLDER_ID}

    if [ -z $(gcloud container clusters list --filter="name=('${CLUSTER}')" --format="value(NAME)") ]; then
        log_message "${GREEN}Creating GKE Cluster (${CLUSTER}) (may take several minutes)....${RESET}"
        # Create the GKE Cluster to act as the Config Controller
        exec_cmd gcloud container clusters create $CLUSTER --enable-binauthz \
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
    fi

    if [ -z $(gcloud iam service-accounts list --filter="EMAIL:${SA_EMAIL}" --format="value(EMAIL)") ]; then
        # Creat the SA for Config Connector to use
        log_message "${GREEN}Creating Service Account(${SA_NAME})....${RESET}"
        exec_cmd gcloud iam service-accounts create $SA_NAME
    fi

    log_message "${GREEN}Adding to owner role to Service Account...${RESET}"
    exec_cmd gcloud projects add-iam-policy-binding $PROJECT_ID --member="serviceAccount:${SA_EMAIL}" --role="roles/owner"

    log_message "${GREEN}Adding logging and monitoring roles to default compute engine service account...{$RESET}"
    exec_cmd gcloud projects add-iam-policy-binding $PROJECT_ID  \
    --member="serviceAccount:${PROJECT_NUMBER}-compute@developer.gserviceaccount.com" \
    --role="roles/logging.logWriter"

    exec_cmd gcloud projects add-iam-policy-binding $PROJECT_ID  \
    --member="serviceAccount:${PROJECT_NUMBER}-compute@developer.gserviceaccount.com" \
    --role="roles/monitoring.metricWriter"

    exec_cmd gcloud projects add-iam-policy-binding $PROJECT_ID  \
    --member="serviceAccount:${PROJECT_NUMBER}-compute@developer.gserviceaccount.com" \
    --role="roles/stackdriver.resourceMetadata.writer"

    log_message "${GREEN}Adding SA GKE Workload Identity (${SA_NAME})....${RESET}"
    exec_cmd gcloud iam service-accounts add-iam-policy-binding ${SA_EMAIL} \
    --member="serviceAccount:${PROJECT_ID}.svc.id.goog[cnrm-system/cnrm-controller-manager]" \
    --role="roles/iam.workloadIdentityUser"

    set_sa_policies

    # Configure the config connector agent
    exec_cmd gcloud container clusters get-credentials $CLUSTER --region $REGION
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

    log_message "${GREEN}Setting up config connector on standalone cluster....${RESET}"
    exec_cmd kubectl apply -f configconnector.yaml
    exec_cmd kubectl create namespace config-control
    exec_cmd kubectl annotate namespace config-control cnrm.cloud.google.com/project-id=${PROJECT_ID}

    log_message "${GREEN}Standalone GKE cluster completed${RESET}"

    rm configconnector.yaml 1>&2
    rm restrictVpcPeering.yaml 1>&2

    exit
}

cc_setup() {
    log_message "${GREEN}Enabling Services....${RESET}"
    exec_cmd gcloud services enable krmapihosting.googleapis.com container.googleapis.com cloudresourcemanager.googleapis.com cloudbilling.googleapis.com
    
    log_message "${GREEN}Creating VPC (${NETWORK}) with default subnets...${RESET}"
    # Create the Network
    exec_cmd gcloud compute networks create $NETWORK --subnet-mode auto
    
    # Bootstrap the project and install / setup Config Controller
    log_message "${GREEN}Bootstrapping Config Controller (may take several minutes)...${RESET}"       

    exec_cmd gcloud alpha anthos config controller create my-awesome-kcc --location=us-central1 --network=$NETWORK

    exec_cmd gcloud alpha anthos config controller get-credentials my-awesome-kcc --location us-central1

    exec_cmd gcloud container clusters get-credentials $(gcloud container clusters list --project ${PROJECT_ID} --format="value(NAME)") --region us-central1

    SA_EMAIL="$(kubectl get ConfigConnectorContext -n config-control \
        -o jsonpath='{.items[0].spec.googleServiceAccount}' 2> /dev/null)"

    set_sa_policies

    log_message "${GREEN}Config Controller Setup completed${RESET}"

    exit
}

set_sa_policies() {
    log_message "${GREEN}Adding SA to requires roles (${SA_EMAIL})....${RESET}"
    exec_cmd gcloud organizations add-iam-policy-binding ${ORG_ID}  --member=serviceAccount:${SA_EMAIL} --role=roles/billing.user
    exec_cmd gcloud organizations add-iam-policy-binding ${ORG_ID}  --member=serviceAccount:${SA_EMAIL} --role=roles/compute.networkAdmin
    exec_cmd gcloud organizations add-iam-policy-binding ${ORG_ID}  --member=serviceAccount:${SA_EMAIL} --role=roles/compute.xpnAdmin
    exec_cmd gcloud organizations add-iam-policy-binding ${ORG_ID}  --member=serviceAccount:${SA_EMAIL} --role=roles/iam.organizationRoleAdmin
    exec_cmd gcloud organizations add-iam-policy-binding ${ORG_ID}  --member=serviceAccount:${SA_EMAIL} --role=roles/orgpolicy.policyAdmin
    exec_cmd gcloud organizations add-iam-policy-binding ${ORG_ID}  --member=serviceAccount:${SA_EMAIL} --role=roles/resourcemanager.folderAdmin
    exec_cmd gcloud organizations add-iam-policy-binding ${ORG_ID}  --member=serviceAccount:${SA_EMAIL} --role=roles/resourcemanager.organizationAdmin
    exec_cmd gcloud organizations add-iam-policy-binding ${ORG_ID}  --member=serviceAccount:${SA_EMAIL} --role=roles/resourcemanager.projectCreator
    exec_cmd gcloud organizations add-iam-policy-binding ${ORG_ID}  --member=serviceAccount:${SA_EMAIL} --role=roles/resourcemanager.projectDeleter
    exec_cmd gcloud organizations add-iam-policy-binding ${ORG_ID}  --member=serviceAccount:${SA_EMAIL} --role=roles/resourcemanager.projectIamAdmin
    exec_cmd gcloud organizations add-iam-policy-binding ${ORG_ID}  --member=serviceAccount:${SA_EMAIL} --role=roles/resourcemanager.projectMover
    exec_cmd gcloud organizations add-iam-policy-binding ${ORG_ID}  --member=serviceAccount:${SA_EMAIL} --role=roles/logging.configWriter
    exec_cmd gcloud organizations add-iam-policy-binding ${ORG_ID}  --member=serviceAccount:${SA_EMAIL} --role=roles/resourcemanager.projectIamAdmin
    exec_cmd gcloud organizations add-iam-policy-binding ${ORG_ID}  --member=serviceAccount:${SA_EMAIL} --role=roles/serviceusage.serviceUsageAdmin
    exec_cmd gcloud organizations add-iam-policy-binding ${ORG_ID}  --member=serviceAccount:${SA_EMAIL} --role=roles/bigquery.dataEditor
    exec_cmd gcloud organizations add-iam-policy-binding ${ORG_ID}  --member=serviceAccount:${SA_EMAIL} --role=roles/storage.admin
}

# Standalong GKE or Config Controller?
if [ $SETUP_CHOICE == "1" ]; then
    standalone_setup
elif [ $SETUP_CHOICE == "2" ]; then
    cc_setup
fi
