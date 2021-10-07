#!/bin/bash

# Name of this project
PROGRAM_NAME="PBMM Sandbox"

# Config Controller release version
CC_RELEASE="Preview"

# Log file name
LOGFILE="bootstrap-log-$(date +"%FT%T").log"

# Helper function to show which arguments are required and optional
usage() {
    echo -e "\e[1m\e[91mERROR:\e[0m ($0) Folder and Org ID argument required.\nUsage: -f <FOLDER NAME> -o <ORG ID> [-p <PROJECT ID>] [-b <BILLING ID>]" 1>&2; exit;
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
                break;
                ;;
            "Quit")
                exit
                ;;
            *)
                echo -e "\e[1m\e[91mERROR:\e[0m Invalid selection."
                ;;
        esac
    done
}

setup_options() {
    echo -e "\nDo you want to install the ${PROGRAM_NAME} in a standalone GKE Cluster or Config Controller (${CC_RELEASE})?"
    echo "1) Standalone GKE Cluster"
    echo "2) Config Controller (${CC_RELEASE})"
    echo "3) Quit"

    read -p "#? " SETUP_CHOICE

    if [ $SETUP_CHOICE == "3" ]; then
        exit
    fi
}

# Read the options / arguments and set the script variables
while getopts ":f:o:p:" opt; do
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
    PROJECT_ID="gcp-sandbox-${RANDOM}"
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

    echo -e "\e[32mCreating Folder (${FOLDER_NAME})...." 2>&1 | tee -a $LOGFILE    
    # Create the Bootstrap Folder and capture its ID
    gcloud resource-manager folders create \
    --display-name=$FOLDER_NAME \
    --organization=$ORG_ID \
    &>> $LOGFILE

    FOLDER_ID=$(gcloud resource-manager folders list --organization $ORG_ID --filter="display_name:${FOLDER_NAME}" --format="value(ID)")
fi

# Check to see if the project already exists; if not then create it
if [ -z $(gcloud projects list --filter="PROJECT_ID:${PROJECT_ID}" --format="value(PROJECT_ID)") ]; then
    echo -e "\e[32mCreating Project (${$PROJECT_ID})...." 2>&1 | tee -a $LOGFILE
    # Creat the Configuration Project
    gcloud projects create $PROJECT_ID \
    --folder $FOLDER_ID \
    &>> $LOGFILE
fi

# Configure the Cloud Shell ENV
gcloud config set project $PROJECT_ID  > /dev/null 2>&1
gcloud beta billing projects link "${PROJECT_ID}" --billing-account "${BILLING_ID}" --quiet  > /dev/null 2>&1

standalone_setup() {
    echo -e "\e[32mEnabling Services...." 2>&1 | tee -a $LOGFILE
    # Enable the Required Services
    gcloud services enable compute.googleapis.com &>> $LOGFILE
    gcloud services enable container.googleapis.com &>> $LOGFILE
    gcloud services enable cloudresourcemanager.googleapis.com &>> $LOGFILE

    # Configure Common ENV Vars
    CLUSTER=config-controller
    NETWORK=config-network
    SUBNETWORK=config-subnet
    REGION=northamerica-northeast1
    MASTER_IPV4=172.16.0.32/28
    AUTHORIZED_NETWORKS=$(dig +short myip.opendns.com @resolver1.opendns.com)/32
    SA_NAME=config-control
    SA_EMAIL=${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com

    echo -e "\e[32mCreating VPC (${NETWORK})...." 2>&1 | tee -a $LOGFILE
    # Create the Network
    gcloud compute networks create $NETWORK --subnet-mode custom &>> $LOGFILE

    echo -e "\e[32mConfiguring Org Policies for GKE on folder (${FOLDER_ID})...." 2>&1 | tee -a $LOGFILE
    gcloud resource-manager org-policies disable-enforce constraints/compute.requireOsLogin \
    --folder ${FOLDER_ID} &>> $LOGFILE

    gcloud resource-manager org-policies disable-enforce constraints/compute.requireShieldedVm \
    --folder ${FOLDER_ID} &>> $LOGFILE

    cat > restrictVpcPeering.yaml << ENDOFFILE
constraint: constraints/compute.restrictVpcPeering
listPolicy:
  allValues: ALLOW
ENDOFFILE

    gcloud resource-manager org-policies set-policy restrictVpcPeering.yaml  \
    --folder ${FOLDER_ID} &>> $LOGFILE

    echo -e "\e[32mCreating GKE Cluster (${CLUSTER})...." 2>&1 | tee -a $LOGFILE
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
    --enable-stackdriver-kubernetes \
    &>> $LOGFILE

    # Creat the SA for Config Connector to use
    echo -e "\e[32mCreating Service Account and adding to owner role (${SA_NAME})...." 2>&1 | tee -a $LOGFILE
    gcloud iam service-accounts create $SA_NAME &>> $LOGFILE
    gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:${SA_EMAIL}" \
    --role="roles/owner" \
    &>> $LOGFILE

    echo -e "\e[32mAdding SA to requires roles (${SA_NAME})...." 2>&1 | tee -a $LOGFILE
    gcloud iam service-accounts add-iam-policy-binding \
    ${SA_EMAIL} \
    --member="serviceAccount:${PROJECT_ID}.svc.id.goog[cnrm-system/cnrm-controller-manager]" \
    --role="roles/iam.workloadIdentityUser" &>> $LOGFILE

    gcloud organizations add-iam-policy-binding ${ORG_ID}  --member=serviceAccount:${SA_EMAIL} \
    --role=roles/billing.user &>> $LOGFILE
    gcloud organizations add-iam-policy-binding ${ORG_ID}  --member=serviceAccount:${SA_EMAIL} \
    --role=roles/compute.networkAdmin &>> $LOGFILE
    gcloud organizations add-iam-policy-binding ${ORG_ID}  --member=serviceAccount:${SA_EMAIL} \
        --role=roles/compute.xpnAdmin &>> $LOGFILE
    gcloud organizations add-iam-policy-binding ${ORG_ID}  --member=serviceAccount:${SA_EMAIL} \
        --role=roles/iam.organizationRoleAdmin &>> $LOGFILE
    gcloud organizations add-iam-policy-binding ${ORG_ID}  --member=serviceAccount:${SA_EMAIL} \
        --role=roles/orgpolicy.policyAdmin &>> $LOGFILE
    gcloud organizations add-iam-policy-binding ${ORG_ID}  --member=serviceAccount:${SA_EMAIL} \
        --role=roles/resourcemanager.folderAdmin &>> $LOGFILE
    gcloud organizations add-iam-policy-binding ${ORG_ID}  --member=serviceAccount:${SA_EMAIL} \
        --role=roles/resourcemanager.organizationAdmin &>> $LOGFILE
    gcloud organizations add-iam-policy-binding ${ORG_ID}  --member=serviceAccount:${SA_EMAIL} \
        --role=roles/resourcemanager.projectCreator &>> $LOGFILE
    gcloud organizations add-iam-policy-binding ${ORG_ID}  --member=serviceAccount:${SA_EMAIL} \
        --role=roles/resourcemanager.projectDeleter &>> $LOGFILE
    gcloud organizations add-iam-policy-binding ${ORG_ID}  --member=serviceAccount:${SA_EMAIL} \
        --role=roles/resourcemanager.projectIamAdmin &>> $LOGFILE
    gcloud organizations add-iam-policy-binding ${ORG_ID}  --member=serviceAccount:${SA_EMAIL} \
        --role=roles/resourcemanager.projectMover &>> $LOGFILE
    gcloud organizations add-iam-policy-binding ${ORG_ID}  --member=serviceAccount:${SA_EMAIL} \
        --role=roles/logging.configWriter &>> $LOGFILE
    gcloud organizations add-iam-policy-binding ${ORG_ID}  --member=serviceAccount:${SA_EMAIL} \
        --role=roles/resourcemanager.projectIamAdmin &>> $LOGFILE
    gcloud organizations add-iam-policy-binding ${ORG_ID}  --member=serviceAccount:${SA_EMAIL} \
        --role=roles/serviceusage.serviceUsageAdmin &>> $LOGFILE
    gcloud organizations add-iam-policy-binding ${ORG_ID}  --member=serviceAccount:${SA_EMAIL} \
        --role=roles/bigquery.dataEditor &>> $LOGFILE
    gcloud organizations add-iam-policy-binding ${ORG_ID}  --member=serviceAccount:${SA_EMAIL} \
        --role=roles/storage.admin &>> $LOGFILE

    # Configure the config connector agent
    gcloud container clusters get-credentials $CLUSTER --region $REGION &>> $LOGFILE
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

    echo -e "\e[32mSetting up config connector on standalone cluster...." 2>&1 | tee -a $LOGFILE
    kubectl apply -f configconnector.yaml &>> $LOGFILE
    kubectl create namespace config-control &>> $LOGFILE
    kubectl annotate namespace config-control cnrm.cloud.google.com/project-id=${PROJECT_ID} &>> $LOGFILE

    echo -e "\e[32mStandalong GKE cluster completed\e[0m" 2>&1 | tee -a $LOGFILE

    rm configconnector.yaml 1>&2
    rm restrictVpcPeering.yaml 1>&2

    exit
}

cc_setup() {
    # Bootstrap the project and install / setup Config Controller
    gcloud services enable krmapihosting.googleapis.com \
        container.googleapis.com \
        cloudresourcemanager.googleapis.com

    gcloud alpha anthos config controller create my-awesome-kcc \
        --location=us-central1

    gcloud alpha anthos config controller get-credentials my-awesome-kcc \
        --location us-central1

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

    exit
}

# Standalong GKE or Config Controller?
if [ $SETUP_CHOICE == "1" ]; then
    standalone_setup
elif [ $SETUP_CHOICE == "2"]; then
    cc_setup
fi