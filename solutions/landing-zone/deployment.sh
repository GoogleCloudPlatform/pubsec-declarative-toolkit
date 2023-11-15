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
example 
./deployment.sh -b pubsec-declarative-agz -u pdt1 -c false -l true -d false -p controller-agz-1201

-b [boot proj id] string     : boot/source project (separate from project for KCC cluster)
-u [unique] true/false       : unique identifier for your project - take your org/domain 1st letters forward/reverse - ie: landging.gcp.zone lgz
-c [create] true/false       : create deployment
-l [landingzone] true false  : deploy landing zone
-d [delete] true/false       : delete deployment
-p [KCC project] string      : target KCC project: ie controller-lgz-1201
EOF
}

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
export CC_PROJECT_RAND=$(shuf -i 0-10000 -n 1)
export CC_PROJECT_ID=${KCC_PROJECT_ID}-${CC_PROJECT_RAND}
echo "CC_PROJECT_ID: $CC_PROJECT_ID"
#export BOOT_PROJECT_ID=$(gcloud config list --format 'value(core.project)')
echo "BOOT_PROJECT_ID: $BOOT_PROJECT_ID"
export BILLING_ID=$(gcloud alpha billing projects describe $BOOT_PROJECT_ID '--format=value(billingAccountName)' | sed 's/.*\///')
echo "BILLING_ID: ${BILLING_ID}"
#ORGID=$(gcloud organizations list --format="get(name)" --filter=displayName=$DOMAIN)
ORGID=$(gcloud projects get-ancestors $BOOT_PROJECT_ID --format='get(id)' | tail -1)
echo "ORGID: ${ORGID}"

# switch back to/create kcc project - not in a folder
if [[ "$CREATE_KCC" != false ]]; then
  # switch back to/create kcc project - not in a folder
  gcloud projects create $CC_PROJECT_ID --name="${KCC_PROJECT_NAME}" --set-as-default
  echo "Created KCC project: ${CC_PROJECT_ID}"
  gcloud config set project "${CC_PROJECT_ID}"
  # enable billing
  gcloud beta billing projects link ${CC_PROJECT_ID} --billing-account ${BILLING_ID}
  # enable apis
  echo "Enabling APIs"
  gcloud services enable  krmapihosting.googleapis.com container.googleapis.com cloudresourcemanager.googleapis.com
  #compute.googleapis.com
  # create VPC
  echo "Create VPC: ${NETWORK}"
  gcloud compute networks create $NETWORK --subnet-mode=custom
  # create subnet
  echo "Create subnet ${SUBNET} off VPC: ${NETWORK}"
  gcloud compute networks subnets create $SUBNET --network $NETWORK --range $CIDR_KCC_VPC --region $REGION

  # create KCC cluster
  # 3 KCC clusters max per region with 25 vCPU default quota
  startb=`date +%s`
  echo "Creating Anthos KCC autopilot cluster ${CLUSTER} in region ${REGION} in subnet ${SUBNET} off VPC ${NETWORK}"
  gcloud alpha anthos config controller create $CLUSTER --location $REGION --network $NETWORK --subnet $SUBNET --full-management
  endb=`date +%s`
  runtimeb=$((endb-startb))
  echo "Cluster create time: ${runtimeb} sec"

  gcloud anthos config controller get-credentials $CLUSTER  --location $REGION
  # set default kubectl namespace to avoid -n or --all-namespaces
  kubens config-control
else
  gcloud config set project "${CC_PROJECT_ID}"
  echo "Switched to KCC project ${CC_PROJECT_ID}"
fi
  
  # Assign Permissions to the KCC Service Account - will need a currently running kcc cluster
#USER="$(kubectl get ConfigConnectorContext -n config-control -o jsonpath='{.items[0].spec.googleServiceAccount}' 2> /dev/null)"
#echo "USER: ${USER}"
##ROLES=("roles/billing.projectManager" "roles/orgpolicy.policyAdmin" "roles/resourcemanager.folderCreator" "roles/resourcemanager.organizationViewer" "roles/resourcemanager.projectCreator" "roles/billing.projectManager" "roles/billing.viewer")
ROLES=("roles/bigquery.dataEditor" "roles/serviceusage.serviceUsageAdmin" "roles/logging.configWriter" "roles/resourcemanager.projectIamAdmin" "roles/resourcemanager.organizationAdmin" "roles/iam.organizationRoleAdmin" "roles/compute.networkAdmin" "roles/resourcemanager.folderAdmin" "roles/resourcemanager.projectCreator" "roles/resourcemanager.projectDeleter" "roles/resourcemanager.projectMover" "roles/iam.securityAdmin" "roles/orgpolicy.policyAdmin" "roles/serviceusage.serviceUsageConsumer" "roles/billing.user" "roles/accesscontextmanager.policyAdmin" "roles/compute.xpnAdmin" "roles/iam.serviceAccountAdmin" "roles/serviceusage.serviceUsageConsumer" "roles/logging.admin") 
#for i in "${ROLES[@]}" ; do
  # requires iam.securityAdmin
  #ROLE=`gcloud organizations get-iam-policy $ORGID --filter="bindings.members:$USER" --flatten="bindings[].members" --format="table(bindings.role)" | grep $i`
  #if [ -z "$ROLE" ]
    #then
#      echo "Applying role $i to $USER"
#      gcloud organizations add-iam-policy-binding $ORGID  --member=user:$USER --role=$i --quiet > /dev/null 1>&1
    #else
      #echo "Role $i already set on $USER"
    #fi
#done
 
  echo "List Clusters:"
  gcloud anthos config controller list

  # delete
if [[ "$DELETE_KCC" != false ]]; then
  # https://cloud.google.com/sdk/gcloud/reference/anthos/config/controller/delete
  echo "Delete Cluster ${CLUSTER} in region ${REGION}"
  startd=`date +%s`
  # note: cluster name is krmapihost-$CLUSTER
  gcloud anthos config controller delete --location $REGION $CLUSTER --quiet
  endd=`date +%s`
  runtimed=$((endd-startd))
  echo "Cluster delete time: ${runtimed} sec"

  # delete VPC (routes and firewalls will be deleted as well)
  echo "deleting subnet ${SUBNET}"
  gcloud compute networks subnets delete ${SUBNET} --region=$REGION -q
  echo "deleting vpc ${NETWORK}"
  gcloud compute networks delete ${NETWORK} -q

  # disable billing before deletion - to preserve the project/billing quota
  gcloud alpha billing projects unlink ${CC_PROJECT_ID} 
  # delete cc project
  gcloud projects delete $CC_PROJECT_ID --quiet
fi

end=`date +%s`
runtime=$((end-start))
echo "Total Duration: ${runtime} sec"
  echo "Date: $(date)"
  echo "Timestamp: $(date +%s)"


  gcloud config set project "${BOOT_PROJECT_ID}"
  echo "Switched back to boot project ${BOOT_PROJECT_ID}"  
}

UNIQUE=
DEPLOY_LZ=false
CREATE_KCC=false
DELETE_KCC=false
KCC_PROJECT_ID=
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