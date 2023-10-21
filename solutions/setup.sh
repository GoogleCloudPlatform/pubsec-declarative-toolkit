#!/bin/bash
# Copyright 2023 Google LLC
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
verify: run from pubsec-declarative-toolkit/solutions
verify: cluster already created by setup-kcc.sh in gcp-tools

create cluster
./setup.sh -b kcc-oi -u oi -c true -l false -r false -d false

deploy lz
./setup.sh -b kcc-oi -u oi -c false -l true -r false -d false -p kcc-oi-629

-b [boot proj id] string     : boot/source project (separate from project for KCC cluster)
-u [unique] true/false       : unique identifier for your project - take your org/domain 1st letters forward/reverse - ie: landging.gcp.zone lgz
-c [create] true/false       : create cluster
-l [landingzone] true false  : deploy landing zone
-l [landingzone] true false  : remove landing zone
-d [delete] true/false       : delete cluster
-p [KCC project] string      : target KCC project: ie controller-lgz-1201
EOF
}

# set for michael@cloudshell:~/dev/pdt-oldev/obriensystems/pubsec-declarative-toolkit/solutions/landing-zone (kcc-lz-8597)$ ./deployment.sh -b pdt-oldev -u pdtoldev -c false -l true -d false -p kcc-lz-8597

# for eash of override - key/value pairs for constants - shared by all scripts
source ./vars.sh

deployment() {
  
  echo "Date: $(date)"
  echo "Timestamp: $(date +%s)"
  echo "running with: -b $BOOT_PROJECT_ID -u $UNIQUE -c $CREATE_KCC -l $DEPLOY_LZ -r $REMOVE_LZ -d $DELETE_KCC -p $KCC_PROJECT_ID"
  # reset project from KCC project - if rerunning script or after an error
  gcloud config set project "${BOOT_PROJECT_ID}"
  echo "Switched back to boot project ${BOOT_PROJECT_ID}"


start=`date +%s`
echo "Start: ${start}"
# Set Vars for Permissions application
export MIDFIX=$UNIQUE
echo "unique string: $MIDFIX"
echo "REGION: $REGION" # defined in vars.sh
#export NETWORK=$PREFIX-${MIDFIX}-vpc
echo "NETWORK: $NETWORK"
#export SUBNET=$PREFIX-${MIDFIX}-sn
echo "SUBNET: $SUBNET"
#export CLUSTER=$PREFIX-${MIDFIX}
echo "CLUSTER: $CLUSTER"
if [[ "$CREATE_KCC" != false ]]; then
  export CC_PROJECT_RAND=$(shuf -i 0-10000 -n 1)
  export CC_PROJECT_ID=${KCC_PROJECT_NAME}-${CC_PROJECT_RAND}
  echo "Creating project: $CC_PROJECT_ID"
  #export CC_PROJECT_ID=${KCC_PROJECT_ID}
else
  export CC_PROJECT_ID=${KCC_PROJECT_ID}
  echo "Reusing project: $CC_PROJECT_ID"
fi

echo "CC_PROJECT_ID: $CC_PROJECT_ID"
#export BOOT_PROJECT_ID=$(gcloud config list --format 'value(core.project)')
echo "BOOT_PROJECT_ID: $BOOT_PROJECT_ID"
export BILLING_ID=$(gcloud billing projects describe $BOOT_PROJECT_ID '--format=value(billingAccountName)' | sed 's/.*\///')
echo "BILLING_ID: ${BILLING_ID}"
#ORGID=$(gcloud organizations list --format="get(name)" --filter=displayName=$DOMAIN)
ORG_ID=$(gcloud projects get-ancestors $BOOT_PROJECT_ID --format='get(id)' | tail -1)
echo "ORG_ID: ${ORG_ID}"
export EMAIL=$(gcloud config list --format json|jq .core.account | sed 's/"//g')


# switch back to/create kcc project - not in a folder
if [[ "$CREATE_KCC" != false ]]; then


  echo "applying roles to the super admin SUPER_ADMIN_EMAIL: ${SUPER_ADMIN_EMAIL}"
  # securityAdmin required
  gcloud organizations add-iam-policy-binding $ORG_ID --member=user:$SUPER_ADMIN_EMAIL --role=roles/resourcemanager.organizationAdmin --quiet #> /dev/null 1>&1
  gcloud organizations add-iam-policy-binding $ORG_ID --member=user:$SUPER_ADMIN_EMAIL --role=roles/resourcemanager.folderAdmin --quiet #> /dev/null 1>&1
  gcloud organizations add-iam-policy-binding $ORG_ID --member=user:$SUPER_ADMIN_EMAIL --role=roles/resourcemanager.projectIamAdmin --quiet #> /dev/null 1>&1
  gcloud organizations add-iam-policy-binding $ORG_ID --member=user:$SUPER_ADMIN_EMAIL --role=roles/compute.networkAdmin --quiet #> /dev/null 1>&1
  gcloud organizations add-iam-policy-binding $ORG_ID --member=user:$SUPER_ADMIN_EMAIL --role=roles/accesscontextmanager.policyAdmin --quiet #> /dev/null 1>&1
  gcloud organizations add-iam-policy-binding $ORG_ID --member=user:$SUPER_ADMIN_EMAIL --role=roles/servicedirectory.editor --quiet #> /dev/null 1>&1
  gcloud organizations add-iam-policy-binding $ORG_ID --member=user:$SUPER_ADMIN_EMAIL --role=roles/dns.admin --quiet #> /dev/null 1>&1
  gcloud organizations add-iam-policy-binding $ORG_ID --member=user:$SUPER_ADMIN_EMAIL --role=roles/logging.admin --quiet #> /dev/null 1>&1

#  ROLES=("roles/servicedirectory.editor" "roles/dns.admin" "roles/logging.admin" "roles/accesscontextmanager.policyAdmin") 
#  ROLES=( "roles/resourcemanager.organizationAdmin" "roles/resourcemanager.folderAdmin" "roles/resourcemanager.projectIamAdmin" "roles/compute.networkAdmin" ) 
#  for i in "${ROLES[@]}" ; do
#    ROLE=`gcloud organizations get-iam-policy $ORG_ID --filter="bindings.members:$SUPER_ADMIN_EMAIL" --flatten="bindings[].members" --format="table(bindings.role)" | grep $i`
#    if [ -z "$ROLE" ]; then
#        echo "Applying role $i to $SUPER_ADMIN_EMAIL"
#        gcloud organizations add-iam-policy-binding $ORG_ID --member=user:$SUPER_ADMIN_EMAIL --role=$i --quiet #> /dev/null 1>&1
#    else
#        echo "Role $i already set on $SUPER_ADMIN_EMAIL"
#    fi
#  done

  # "roles/billing.user" 'roles/bigquery.dataEditor" "roles/iam.serviceAccountAdmin" "roles/orgpolicy.policyAdmin" "roles/iam.securityAdmin" "roles/logging.configWriter" "roles/serviceusage.serviceUsageAdmin" "roles/iam.organizationRoleAdmin" "roles/compute.networkAdmin" "roles/compute.xpnAdmin" "roles/serviceusage.serviceUsageConsumer"

 


  # switch back to/create kcc project - not in a folder
  echo "Creating KCC project: ${CC_PROJECT_ID}"
  #gcloud projects create $CC_PROJECT_ID --name="${CC_PROJECT_ID}" --set-as-default
  gcloud projects create $CC_PROJECT_ID --name="${CC_PROJECT_ID}" --set-as-default --folder="$ROOT_FOLDER_ID"
#  echo "Reusing project: $CC_PROJECT_ID"
  gcloud config set project "${CC_PROJECT_ID}"
  # enable billing
  gcloud beta billing projects link ${CC_PROJECT_ID} --billing-account ${BILLING_ID}

  echo "sleep 45 sec before enabling services"
  sleep 45
  
  # enable apis
  echo "Enabling APIs"
  gcloud services enable krmapihosting.googleapis.com 
  gcloud services enable container.googleapis.com
  #compute.googleapis.com
  gcloud services enable cloudresourcemanager.googleapis.com 
  gcloud services enable accesscontextmanager.googleapis.com 
  gcloud services enable cloudbilling.googleapis.com
  gcloud services enable serviceusage.googleapis.com 
  gcloud services enable servicedirectory.googleapis.com 
  gcloud services enable dns.googleapis.com

  gcloud logging settings update --organization=$ORG_ID --storage-location=$REGION

  # create VPC
  echo "Create VPC: ${NETWORK}"
  gcloud compute networks create $NETWORK --subnet-mode=custom
  # create subnet
  echo "Create subnet ${SUBNET} off VPC: ${NETWORK}"
  gcloud compute networks subnets create $SUBNET --network $NETWORK --range $CIDR_KCC_VPC --region $REGION --stack-type=IPV4_ONLY
  #--enable-private-ip-google-access \
  #--enable-flow-logs --logging-aggregation-interval=interval-5-sec --logging-flow-sampling=1.0 --logging-metadata=include-all

  # Cloud router and Cloud NAT - both not required because dev envs are not using PSC and the GKE cluster is using a public endpoint
  #gcloud compute routers create kcc-router --project=$CC_PROJECT_ID  --network=$NETWORK  --asn=64513 --region=$REGION
  #gcloud compute routers nats create kcc-router --router=kcc-router --region=$REGION --auto-allocate-nat-external-ips --nat-all-subnet-ip-ranges 
  # --enable-logging

  echo "create default firewalls"
  #gcloud compute firewall-rules create allow-egress-tcp-udp-icmp --network $NETWORK --allow tcp,udp,icmp --source-ranges 0.0.0.0/0 --direction EGRESS --priority 1000
  #gcloud compute firewall-rules create allow-egress-ssh --network $NETWORK --allow tcp:22,tcp:3389,icmp --direction EGRESS --priority 1010

  # create KCC cluster
  # 3 KCC clusters max per region with 25 vCPU default quota
  startb=`date +%s`
  echo "Creating Anthos KCC autopilot cluster ${CLUSTER} in region ${REGION} in subnet ${SUBNET} off VPC ${NETWORK}"
  # autopilot_opt: Deploy an autopilot cluster instead of a standard cluster
  gcloud anthos config controller create $CLUSTER --location $REGION --network $NETWORK --subnet $SUBNET --master-ipv4-cidr-block="172.16.0.128/28" --full-management

  endb=`date +%s`
  runtimeb=$((endb-startb))
  echo "Cluster create time: ${runtimeb} sec"
  gcloud anthos config controller get-credentials $CLUSTER --location $REGION
  echo "List Clusters:"
  gcloud anthos config controller list


  export SA_EMAIL="$(kubectl get ConfigConnectorContext -n config-control -o jsonpath='{.items[0].spec.googleServiceAccount}' 2> /dev/null)"
  echo "applying 2 roles to the yakima gke service account to prep for kpt deployment: $SA_EMAIL"
  gcloud organizations add-iam-policy-binding "${ORG_ID}" --member="serviceAccount:${SA_EMAIL}" --role=roles/resourcemanager.organizationAdmin --condition=None --quiet
  gcloud projects add-iam-policy-binding "${KCC_PROJECT_ID}" --member "serviceAccount:${SA_EMAIL}" --role "roles/serviceusage.serviceUsageConsumer" --project "${KCC_PROJECT_ID}" --quiet
  # need service account admin for kubectl describe iamserviceaccount.iam.cnrm.cloud.google.com/gatekeeper-admin-sa
  # Warning  UpdateFailed  36s (x9 over 6m44s)  iamserviceaccount-controller  Update call failed: error applying desired state: summary: Error creating service account: googleapi: Error 403: Permission 'iam.serviceAccounts.create' denied on resource (or it may not exist).
  roles/iam.serviceAccountCreator

else
  echo "Switching to KCC project ${KCC_PROJECT_ID}"
  gcloud config set project "${KCC_PROJECT_ID}"

  gcloud anthos config controller get-credentials $CLUSTER  --location $REGION
  # set default kubectl namespace to avoid -n or --all-namespaces
  kubens config-control
  echo "kubectl get gcp"
  kubectl get gcp
  echo "kubectl get pods --all-namespaces"
  kubectl get pods --all-namespaces
fi


if [[ "$DEPLOY_LZ" != false ]]; then
  # Landing zone deployment
  # https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit/tree/main/solutions/landing-zone#0-set-default-logging-storage-location

  # Assign Permissions to the KCC Service Account - will need a currently running kcc cluster
  #export SA_EMAIL="$(kubectl get ConfigConnectorContext -n config-control -o jsonpath='{.items[0].spec.googleServiceAccount}' 2> /dev/null)"

#  echo "SA_EMAIL: ${SA_EMAIL}"
  # "roles/billing.user" 'roles/bigquery.dataEditor" "roles/iam.serviceAccountAdmin" "roles/orgpolicy.policyAdmin" "roles/iam.securityAdmin" "roles/logging.configWriter" "roles/serviceusage.serviceUsageAdmin" "roles/iam.organizationRoleAdmin" "roles/compute.networkAdmin" "roles/compute.xpnAdmin" "roles/serviceusage.serviceUsageConsumer"
#  ROLES=( "roles/resourcemanager.organizationAdmin" "roles/resourcemanager.folderAdmin" "roles/resourcemanager.projectIamAdmin" "roles/compute.networkAdmin" "roles/accesscontextmanager.policyAdmin" "roles/servicedirectory.editor" "roles/dns.admin" "roles/logging.admin" ) 

  
#  for i in "${ROLES[@]}" ; do
    # requires iam.securityAdmin
    #ROLE=`gcloud organizations get-iam-policy $ORG_ID --filter="bindings.members:$SA_EMAIL" --flatten="bindings[].members" --format="table(bindings.role)" | grep $i`
    #echo $ROLE
    #if [ -z "$ROLE" ]; then
#        echo "Applying role $i to $SA_EMAIL"
#        gcloud organizations add-iam-policy-binding $ORG_ID  --member=serviceAccount:$SA_EMAIL --role=$i --quiet #> /dev/null 1>&1
    #else
    #    echo "Role $i already set on $USER"
    #fi
  
#  done

  # fetch the LZ
  cd ../../../kpt
  # check for existing landing-zone

  #kpt pkg get https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit.git/solutions/core-landing-zone@main 
  # cp the setters.yaml
  cp ../github/pubsec-declarative-toolkit/solutions/core-landing-zone/setters.yaml core-landing-zone/ 
  #cp pubsec-declarative-toolkit/solutions/landing-zone/.krmignore landing-zone/ 

  echo "kpt live init"
  kpt live init core-landing-zone --namespace config-control --force
  echo "kpt fn render"
  kpt fn render core-landing-zone --truncate-output=false
  echo "kpt live apply"
  kpt live apply core-landing-zone --reconcile-timeout=5m --output=table
  echo "Wait 2 min"
  count=$(kubectl get gcp | grep UpdateFailed | wc -l)
  echo "UpdateFailed: $count"
  count=$(kubectl get gcp | grep UpToDate | wc -l)
  echo "UpToDate: $count"
  # set default kubectl namespace to avoid -n or --all-namespaces
  kubens config-control
  kubectl get gcp

  echo "sleep 60 sec"
  sleep 60
  # check projects-sa and verify billing
  echo "check iamserviceaccount.iam.cnrm.cloud.google.com/projects-sa before verifying billing"
  kubectl describe iamserviceaccount.iam.cnrm.cloud.google.com/projects-sa
  # needs to be set on the billing page
  #gcloud beta billing accounts add-iam-policy-binding "${BILLING_ID}" --member "serviceAccount:projects-sa@${KCC_PROJECT_ID}.iam.gserviceaccount.com" --role "roles/billing.user"

  cd ../github/pubsec-declarative-toolkit/solutions

fi

if [[ "$REMOVE_LZ" != false ]]; then
  echo "deleting lz on ${CLUSTER} in region ${REGION}"
  kubectl get gcp
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

  cd ../../../kpt
  kpt live destroy core-landing-zone
  #kubectl delete gcp --all
  cd ../github/pubsec-declarative-toolkit/solutions
fi

  # delete
if [[ "$DELETE_KCC" != false ]]; then
  echo "Deleting cluster ${CLUSTER} in region ${REGION}"
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

  #kpt live destroy core-landing-zone

  # delete kpt pkg get
  #rm -rf landing-zone
  # https://cloud.google.com/sdk/gcloud/reference/anthos/config/controller/delete
  echo "Delete Cluster ${CLUSTER} in region ${REGION}"
  startd=`date +%s`
  # note: cluster name is krmapihost-$CLUSTER
  gcloud anthos config controller delete --location $REGION $CLUSTER --quiet
  endd=`date +%s`
  runtimed=$((endd-startd))
  echo "Cluster delete time: ${runtimed} sec"

  # delete VPC (routes and firewalls will be deleted as well)
  #echo "deleting subnet ${SUBNET}"
  #gcloud compute networks subnets delete ${SUBNET} --region=$REGION -q
  #echo "deleting vpc ${NETWORK}"
  #gcloud compute networks delete ${NETWORK} -q

  # disable billing before deletion - to preserve the project/billing quota
  #gcloud alpha billing projects unlink ${CC_PROJECT_ID} 
  # delete cc project
  #gcloud projects delete $CC_PROJECT_ID --quiet
fi

end=`date +%s`
runtime=$((end-start))
echo "Total Duration: ${runtime} sec"
  echo "Date: $(date)"
  echo "Timestamp: $(date +%s)"

  gcloud config set project "${BOOT_PROJECT_ID}"
  echo "Switched back to boot project ${BOOT_PROJECT_ID}" 
  # go back to the script dir
  #cd pubsec-declarative-toolkit/solutions/landing-zone 
}

UNIQUE=
DEPLOY_LZ=false
CREATE_KCC=false
DELETE_KCC=false
REMOVE_LZ=false
BOOT_PROJECT_ID=

while getopts ":b:u:c:l:d:r:p:" PARAM; do
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
    r)
      REMOVE_LZ=${OPTARG}
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

#  echo "Options are: -c true/false (create kcc), -l true/false (deploy landing zone) -r (remove lz) -d true/false (delete kcc) -p kcc-project-id"


if [[ -z $UNIQUE ]]; then
  usage
  exit 1
fi

deployment $BOOT_PROJECT_ID $UNIQUE $CREATE_KCC $DEPLOY_LZ $REMOVE_LZ $DELETE_KCC $KCC_PROJECT_ID
printf "**** Done ****\n"