#!/bin/bash
# Copyright 2024 Google LLC
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
./gcloud-lz.sh -b boot-lz-cdd -c true -d false 
-b [boot proj id] string     : boot/source project
-c [create] true/false       : lz create
-d [deletebj true/false      : lz delete

EOF
}

# for ease of override - key/value pairs for constants - shared by all scripts
source ./vars.sh

echo "Landing Zone orchestration start"

deployment() {
  
  echo "Date: $(date)"
  echo "Timestamp: $(date +%s)"
  echo "running with: -b $BOOT_PROJECT_ID"
  # reset project from 
  gcloud config set project "${BOOT_PROJECT_ID}"
  echo "Switched back to boot project ${BOOT_PROJECT_ID}"

start=`date +%s`
echo "Start: ${start}"
# Set Vars for Permissions application
MIDFIX=$UNIQUE
echo "unique string: $MIDFIX"
echo "REGION: $REGION" # defined in vars.sh
echo "NETWORK: $NETWORK"
echo "SUBNET: $SUBNET"
echo "BOOT_PROJECT_ID: $BOOT_PROJECT_ID"
BILLING_FORMAT="--format=value(billingAccountName)"
BILLING_ID=$(gcloud billing projects describe "$BOOT_PROJECT_ID" $BILLING_FORMAT | sed 's/.*\///')
echo "BILLING_ID: ${BILLING_ID}"
ORG_ID=$(gcloud projects get-ancestors "$BOOT_PROJECT_ID" --format='get(id)' | tail -1)
echo "ORG_ID: ${ORG_ID}"
# not required yet
#EMAIL=$(gcloud config list --format json|jq .core.account | sed 's/"//g')

if [[ "$CREATE_LZ" != false ]]; then
  create_core_landing_zone
fi

if [[ "$DELETE_LZ" != false ]]; then
  delete_all
fi
}



create_core_landing_zone() {
  # organization policies - on folder
  
  # organization policy overrides - folder
  

  echo "Creating project: ${AUDIT_PROJECT_ID} on folder: ${ROOT_FOLDER_ID}"
  gcloud projects create "$AUDIT_PROJECT_ID" --name="${AUDIT_PROJECT_ID}" --set-as-default --folder="$ROOT_FOLDER_ID"
  gcloud config set project "${AUDIT_PROJECT_ID}"
  # enable billing
  echo "Enabling billing on account: ${BILLING_ID}"
  gcloud beta billing projects link "${AUDIT_PROJECT_ID}" --billing-account "${BILLING_ID}"
  echo "sleep 20 sec before enabling services"
  sleep 20
  gcloud services enable compute.googleapis.com

  echo "Create VPC: ${NETWORK}"
  gcloud compute networks create "$NETWORK" --subnet-mode=custom
  echo "Create subnet ${SUBNET} off VPC: ${NETWORK}"
  gcloud compute networks subnets create "$SUBNET" --network "$NETWORK" --range "$CIDR_VPC" --region "$REGION"

  # org sink: management-platform

  # org sink: access

  # org sink: security
}

create_client_setup() {
  # organization policy overrides - folder

}
create_client_landing_zone() {
  # organization policy overrides - folder
  
}
create_client_project_setup() {
  # organization policy overrides - folder
  
}



delete_all() {

  # delete VPC (routes and firewalls will be deleted as well)
  echo "deleting subnet ${SUBNET}"
  gcloud compute networks subnets delete "${SUBNET}" --region="$REGION" --project="$AUDIT_PROJECT_ID" -q
  echo "deleting vpc ${NETWORK}"
  gcloud compute networks delete "${NETWORK}" --project="$AUDIT_PROJECT_ID" -q

  # disable billing before deletion - to preserve the project/billing quota
  gcloud alpha billing projects unlink "${AUDIT_PROJECT_ID}"
  # delete cc project
  gcloud projects delete "$AUDIT_PROJECT_ID" --quiet
}


create_service_accounts() {
  echo "Create service accounts"
  gcloud iam service-accounts create "$SERVICE_ACCOUNT_M4A_INSTALL" --project="$PROJECT_ID"
}

UNIQUE=
BOOT_PROJECT_ID=


while getopts ":b:c:d:" PARAM; do
  case $PARAM in
    b)
      BOOT_PROJECT_ID=${OPTARG}
      ;;
    c)
      CREATE_LZ=${OPTARG}
      ;;
    d)
      DELETE_LZ=${OPTARG}
      ;;
    ?)
      usage
      exit
      ;;
  esac
done

#  echo "Options are: -b boot_project -c create -d delete"
if [[ -z $BOOT_PROJECT_ID ]]; then
  usage
  exit 1
fi

deployment "$BOOT_PROJECT_ID" "$CREATE_LZ" "$DELETE_LZ"
printf "**** Done ****\n"
