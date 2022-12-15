#!/bin/bash
# Copyright 2022 Google LLC
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

set -e

usage() {
  cat <<EOF
Usage: $0 [PARAMs]
example create 2min (notice the -d false)
root_@cloudshell:~/pubsec-declarative-toolkit/solutions/document-processing (pdt-tgz)$ ./deployment.sh -b pdt-tgz -u pdt2 -c true -l false -d false
example delete 20sec (notice the -c false and the previous -p project id)
root_@cloudshell:~/pubsec-declarative-toolkit/solutions/document-processing (pdt-tgz)$ ./deployment.sh -b pdt-tgz -u pdt2 -c false -l false -d true -p kcc-lz-9672

-b [boot proj id] string     : boot/source project (separate from project for KCC cluster)
-u [unique] true/false       : unique identifier for your project - take your org/domain 1st letters forward/reverse - ie: landging.gcp.zone lgz
-c [create] true/false       : create deployment
-l [landingzone] true false  : deploy landing zone
-d [delete] true/false       : delete deployment
-p [KCC project] string      : target KCC project: ie controller-lgz-1201
EOF
}

# set for michael@cloudshell:~/dev/pdt-oldev/obriensystems/pubsec-declarative-toolkit/solutions/landing-zone (kcc-lz-8597)$ ./deployment.sh -b pdt-oldev -u pdtoldev -c false -l true -d false -p kcc-lz-8597

# for eash of override - key/value pairs for constants - shared by all scripts
source ./vars.sh

deployment() {
  echo "Date: $(date)"
  echo "Timestamp: $(date +%s)"
  echo "running with: -b $BOOT_PROJECT_ID -u $UNIQUE -c $CREATE_KCC -l $DEPLOY_LZ -d $DELETE_KCC -p $KCC_PROJECT_ID"
  # reset project from KCC project - if rerunning script or after an error
  gcloud config set project "${BOOT_PROJECT_ID}"
  echo "Switched back to boot project ${BOOT_PROJECT_ID}"

start=`date +%s`
echo "Start: ${start}"
# Set Vars for Permissions application
export MIDFIX=$UNIQUE
echo "unique string: $MIDFIX"
#export REGION=northamerica-northeast1
echo "REGION: $REGION" # defined in vars.sh
export NETWORK=$PREFIX-${MIDFIX}-vpc
echo "NETWORK: $NETWORK"
export SUBNET=$PREFIX-${MIDFIX}-sn
echo "SUBNET: $SUBNET"
export CLUSTER=$PREFIX-${MIDFIX}
echo "CLUSTER: $CLUSTER"
if [[ "$CREATE_KCC" != false ]]; then
  export CC_PROJECT_RAND=$(shuf -i 0-10000 -n 1)
  export CC_PROJECT_ID=${KCC_PROJECT_NAME}-${CC_PROJECT_RAND}
  echo "Creating project: $CC_PROJECT_ID"
else
  export CC_PROJECT_ID=${KCC_PROJECT_ID}
  echo "Reusing project: $CC_PROJECT_ID"
fi

echo "CC_PROJECT_ID: $KCC_PROJECT_ID"
#export BOOT_PROJECT_ID=$(gcloud config list --format 'value(core.project)')
echo "BOOT_PROJECT_ID: $BOOT_PROJECT_ID"
export BILLING_ID=$(gcloud alpha billing projects describe $BOOT_PROJECT_ID '--format=value(billingAccountName)' | sed 's/.*\///')
echo "BILLING_ID: ${BILLING_ID}"
#ORGID=$(gcloud organizations list --format="get(name)" --filter=displayName=$DOMAIN)
ORG_ID=$(gcloud projects get-ancestors $BOOT_PROJECT_ID --format='get(id)' | tail -1)
echo "ORG_ID: ${ORG_ID}"
export EMAIL=$(gcloud config list --format json|jq .core.account | sed 's/"//g')


# enable permissions on existing user
#gcloud organizations add-iam-policy-binding $ORG_ID  --member=user:$EMAIL --role=roles/iam.serviceAccountTokenCreator --quiet > /dev/null 1>&1
#gcloud organizations add-iam-policy-binding $ORG_ID  --member=user:$EMAIL --role=roles/orgpolicy.policyAdmin --quiet > /dev/null 1>&1
#gcloud organizations add-iam-policy-binding $ORG_ID  --member=user:$EMAIL --role=roles/resourcemanager.folderAdmin --quiet > /dev/null 1>&1
#gcloud organizations add-iam-policy-binding $ORG_ID  --member=user:$EMAIL --role=roles/resourcemanager.organizationAdmin --quiet > /dev/null 1>&1
#gcloud organizations add-iam-policy-binding $ORG_ID  --member=user:$EMAIL --role=roles/resourcemanager.projectCreator --quiet > /dev/null 1>&1
#gcloud organizations add-iam-policy-binding $ORG_ID  --member=user:$EMAIL --role=roles/billing.projectManager --quiet > /dev/null 1>&1


# switch back to/create kcc project - not in a folder
if [[ "$CREATE_KCC" != false ]]; then
  # switch back to/create kcc project - not in a folder
  echo "Creating KCC project: ${CC_PROJECT_ID}"
  gcloud projects create $CC_PROJECT_ID --name="${CC_PROJECT_ID}" --set-as-default
  gcloud config set project "${CC_PROJECT_ID}"
  # enable billing
  gcloud beta billing projects link ${CC_PROJECT_ID} --billing-account ${BILLING_ID}
  # enable apis
  echo "API's before"
  gcloud services list --enabled | grep NAME

  echo "Enabling APIs"
  # DocAI
  gcloud services enable documentai.googleapis.com
  # AutoML
  # NLP API
  # (cloud) Healthcare NLP API - https://cloud.google.com/healthcare-api/docs/how-tos/nlp
  gcloud services enable healthcare.googleapis.com
  # vertex AI api
  gcloud services enable aiplatform.googleapis.com
  # artifact registry ok
  #cloud storage
  gcloud services enable notebooks.googleapis.com
  gcloud services enable dataflow.googleapis.com

  # CSR (up from AR) (for cloud run) ok

  # app engine ok

  # BigQuery ok
  #gcloud services enable bigquerymigration.googleapis.com
  #gcloud services enable bigquery.googleapis.com
  #gcloud services enable bigquerystorage.googleapis.com
  #gcloud services enable krmapihosting.googleapis.com 
  gcloud services enable container.googleapis.com
  #compute.googleapis.com
  #gcloud services enable cloudresourcemanager.googleapis.com 
  #gcloud services enable accesscontextmanager.googleapis.com 
  gcloud services enable cloudbilling.googleapis.com


  echo "API's after"
  gcloud services list --enabled | grep NAME

  # create VPC
  #echo "Create VPC: ${NETWORK}"
  #gcloud compute networks create $NETWORK --subnet-mode=custom
  # create subnet
  #echo "Create subnet ${SUBNET} off VPC: ${NETWORK}"
  #gcloud compute networks subnets create $SUBNET --network $NETWORK --range $CIDR_KCC_VPC --region $REGION

  # create KCC cluster
  # 3 KCC clusters max per region with 25 vCPU default quota
  #startb=`date +%s`
  #echo "Creating Anthos KCC autopilot cluster ${CLUSTER} in region ${REGION} in subnet ${SUBNET} off VPC ${NETWORK}"
  #gcloud alpha anthos config controller create $CLUSTER --location $REGION --network $NETWORK --subnet $SUBNET --full-management
  #endb=`date +%s`
  #runtimeb=$((endb-startb))
  #echo "Cluster create time: ${runtimeb} sec"

  #gcloud anthos config controller get-credentials $CLUSTER  --location $REGION
  # set default kubectl namespace to avoid -n or --all-namespaces
  #kubens config-control

  #echo "List Clusters:"
  #gcloud anthos config controller list
else
  echo "Switching to KCC project ${KCC_PROJECT_ID}"
  gcloud config set project "${KCC_PROJECT_ID}"

  #gcloud anthos config controller get-credentials $CLUSTER  --location $REGION
  # set default kubectl namespace to avoid -n or --all-namespaces
  #kubens config-control
fi
  

if [[ "$DEPLOY_LZ" != false ]]; then
  # Landing zone deployment
  # https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit/tree/main/solutions/landing-zone#0-set-default-logging-storage-location

  gcloud organizations add-iam-policy-binding "${ORG_ID}" --member "user:${EMAIL}" --role roles/logging.admin
  gcloud alpha logging settings update --organization=$ORG_ID --storage-location=$REGION

  # Assign Permissions to the KCC Service Account - will need a currently running kcc cluster
  #export SA_EMAIL="$(kubectl get ConfigConnectorContext -n config-control -o jsonpath='{.items[0].spec.googleServiceAccount}' 2> /dev/null)"

  SA = "SA-${KCC_PROJECT_ID}"
  gcloud iam service-accounts create "${SA}" --display-name "${SA} service account" --project=${KCC_PROJECT_ID} --quiet
  act=`gcloud iam service-accounts list --project="${KCC_PROJECT_ID}" --filter=tfadmin --format="value(email)"`

  echo "SA_EMAIL: ${SA}"
  #ROLES=("roles/bigquery.dataEditor" "roles/serviceusage.serviceUsageAdmin" "roles/logging.configWriter" "roles/resourcemanager.projectIamAdmin" "roles/resourcemanager.organizationAdmin" "roles/iam.organizationRoleAdmin" "roles/compute.networkAdmin" "roles/resourcemanager.folderAdmin" "roles/resourcemanager.projectCreator" "roles/resourcemanager.projectDeleter" "roles/resourcemanager.projectMover" "roles/iam.securityAdmin" "roles/orgpolicy.policyAdmin" "roles/serviceusage.serviceUsageConsumer" "roles/billing.user" "roles/accesscontextmanager.policyAdmin" "roles/compute.xpnAdmin" "roles/iam.serviceAccountAdmin" "roles/serviceusage.serviceUsageConsumer" "roles/logging.admin") 
  ROLES=("roles/bigquery.dataEditor" "roles/serviceusage.serviceUsageAdmin" "roles/logging.configWriter") 
  for i in "${ROLES[@]}" ; do
    # requires iam.securityAdmin
    #ROLE=`gcloud organizations get-iam-policy $ORG_ID --filter="bindings.members:$SA_EMAIL" --flatten="bindings[].members" --format="table(bindings.role)" | grep $i`
    #echo $ROLE
    #if [ -z "$ROLE" ]; then
        echo "Applying role $i to $SA"
        gcloud organizations add-iam-policy-binding $ORG_ID  --member=serviceAccount:$SA_EMAIL --role=$i --quiet > /dev/null 1>&1
    #else
    #    echo "Role $i already set on $USER"
    #fi
  done
 

  # fetch the LZ
  #cd ../../../
  # check for existing landing-zone

  #kpt pkg get https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit.git/solutions/landing-zone landing-zone
  # cp the setters.yaml
  #cp pubsec-declarative-toolkit/solutions/landing-zone/setters.yaml landing-zone/ 
  #cp pubsec-declarative-toolkit/solutions/landing-zone/.krmignore landing-zone/ 

  #echo "kpt live init"
  #kpt live init landing-zone --namespace config-control --force
  #echo "kpt fn render"
  #kpt fn render landing-zone
  #echo "kpt live apply"
  #kpt live apply landing-zone --reconcile-timeout=2m --output=table
  #echo "Wait 2 min"
  #count=$(kubectl get gcp | grep UpdateFailed | wc -l)
  #echo "UpdateFailed: $count"
  #count=$(kubectl get gcp | grep UpToDate | wc -l)
  #echo "UpToDate: $count"
  #kubectl get gcp
fi




 # delete
if [[ "$DELETE_KCC" != false ]]; then
  echo "Deleting ${CC_PROJECT_ID}"
  # stay in current dir
  # will take up to 15-45 min and may hang unless liens are removed
  # 3 problematic projects
  #gcloud config set project audit-prj-id-oldv1
  #AUDIT_LIEN=$(gcloud alpha resource-manager liens list)
  #gcloud alpha resource-manager liens delete $AUDIT_LIEN

  #gcloud config set project net-host-prj-prod-oldv1
  #PROD_LIEN=$(gcloud alpha resource-manager liens list)
  #gcloud alpha resource-manager liens delete $PROD_LIEN

  #gcloud config set project net-host-prj-nonprod-oldv1
  #NONPROD_LIEN=$(gcloud alpha resource-manager liens list)
  #gcloud alpha resource-manager liens delete $NONPROD_LIEN

  #kpt live destroy landing-zone

  # delete kpt pkg get
  #rm -rf landing-zone
  # https://cloud.google.com/sdk/gcloud/reference/anthos/config/controller/delete
  #echo "Delete Cluster ${CLUSTER} in region ${REGION}"
  #startd=`date +%s`
  # note: cluster name is krmapihost-$CLUSTER
  #gcloud anthos config controller delete --location $REGION $CLUSTER --quiet
  #endd=`date +%s`
  #runtimed=$((endd-startd))
  #echo "Cluster delete time: ${runtimed} sec"

  # delete VPC (routes and firewalls will be deleted as well)
  #echo "deleting subnet ${SUBNET}"
  #gcloud compute networks subnets delete ${SUBNET} --region=$REGION -q
  #echo "deleting vpc ${NETWORK}"
  #gcloud compute networks delete ${NETWORK} -q

  # disable billing before deletion - to preserve the project/billing quota
  echo "disable billing on - and delete ${CC_PROJECT_ID}"
  gcloud alpha billing projects unlink ${CC_PROJECT_ID} 
  # delete cc project
  gcloud projects delete $CC_PROJECT_ID --quiet
fi

  gcloud config set project "${BOOT_PROJECT_ID}"
  echo "Switched back to boot project ${BOOT_PROJECT_ID}" 
  # go back to the script dir
  ##cd pubsec-declarative-toolkit/solutions/document-processing 
}


UNIQUE=
DEPLOY_LZ=false
CREATE_KCC=false
DELETE_KCC=false
BOOT_PROJECT_ID=

while getopts ":b:u:c:l:d:p:" PARAM; do
  case $PARAM in
    b)
      BOOT_PROJECT_ID=${OPTARG}
      ;;
    u)
      UNIQUE=${OPTARG}
      ;;
    c)
      CREATE_KCC=${OPTARG}
      ;;
    l)
      DEPLOY_LZ=${OPTARG}
      ;;
    d)
      DELETE_KCC=${OPTARG}
      ;;
    p)
      KCC_PROJECT_ID=${OPTARG}
      ;;  
    ?)
      usage
      exit
      ;;
  esac
done

#  echo "Options are: -c true/false (create kcc), -l true/false (deploy landing zone) -d true/false (delete kcc) -p kcc-project-id"


if [[ -z $UNIQUE ]]; then
  usage
  exit 1
fi

deployment $BOOT_PROJECT_ID $UNIQUE $CREATE_KCC $DEPLOY_LZ $DELETE_KCC $KCC_PROJECT_ID
printf "**** Done ****\n"