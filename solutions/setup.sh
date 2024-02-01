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

create cluster in new project
./setup.sh -b kcc-oi -u oi -n true -c true -l false -h false -r false -d false -j false


deploy lz
./setup.sh -b kcc-oi -u oi -n false -c false -l true -h false -r false -d false -j false -p kcc-oi-629

delete lz, kcc cluster and project in order
./setup.sh -b kcc-oi -u oi -n false -c false -l false -h false -r true -d true -j false -p kcc-oi-629

-b [boot proj id] string     : boot/source project (separate from project for KCC cluster)
-u [unique] true/false       : unique identifier for your project - take your org/domain 1st letters forward/reverse - ie: landging.gcp.zone lgz
-n [create] true/false       : create project
-c [create] true/false       : create cluster
-l [landingzone] true/false  : deploy landing zone
-h [hub] true/false          : deploy hub
-r [landingzone] true/false  : remove landing zone + hub
-d [delete] true/false       : delete cluster
-j [delete] true/false       : delete project
-p [KCC project] string      : target KCC project: ie kcc-ol-1201
EOF
}

# set for michael@cloudshell:~/dev/pdt-oldev/obriensystems/pubsec-declarative-toolkit/solutions/landing-zone (kcc-lz-8597)$ ./deployment.sh -b pdt-oldev -u pdtoldev -c false -l true -d false -p kcc-lz-8597

# for eash of override - key/value pairs for constants - shared by all scripts
source ./vars.sh

# the following can be overriden by vars.sh above
CIDR_KCC_VPC=192.168.0.0/16
#LZ_FOLDER_NAME_PREFIX=landing-zone-1
NETWORK=kcc-vpc
SUBNET=kcc-sn
# don't reset - passed in select runs via vars.sh where cluster is already up
#KCC_PROJECT_NUMBER=
CLUSTER=kcc

deployment() {
  
  echo "Date: $(date)"
  echo "Timestamp: $(date +%s)"
  echo "running with: -b $BOOT_PROJECT_ID -u $UNIQUE -c $CREATE_KCC -l $DEPLOY_LZ -h $DEPLOY_HUB -r $REMOVE_LZ -d $DELETE_KCC -p $KCC_PROJECT_ID"
  # reset project from KCC project - if rerunning script or after an error
  gcloud config set project "${BOOT_PROJECT_ID}"
  echo "Switched back to boot project ${BOOT_PROJECT_ID}"

start=`date +%s`
echo "Start: ${start}"
# Set Vars for Permissions application
MIDFIX=$UNIQUE
echo "unique string: $MIDFIX"
echo "REGION: $REGION" # defined in vars.sh
# NETWORK=$PREFIX-${MIDFIX}-vpc
echo "NETWORK: $NETWORK"
# SUBNET=$PREFIX-${MIDFIX}-sn
echo "SUBNET: $SUBNET"
# CLUSTER=$PREFIX-${MIDFIX}
echo "CLUSTER: $CLUSTER"
if [[ "$CREATE_PROJ" != false ]]; then
  CC_PROJECT_RAND=$(shuf -i 0-10000 -n 1)
  CC_PROJECT_ID=${KCC_PROJECT_NAME}-${CC_PROJECT_RAND}
  echo "Creating project: $CC_PROJECT_ID"
  # set KCC project id for case where we initially create the KCC cluster without rerunning with passed in -p project_id
  KCC_PROJECT_ID=$CC_PROJECT_ID
  ##CC_PROJECT_ID=${KCC_PROJECT_ID}
else
  CC_PROJECT_ID=${KCC_PROJECT_ID}
  echo "Reusing project: $CC_PROJECT_ID"
fi

echo "CC_PROJECT_ID: $CC_PROJECT_ID"
#BOOT_PROJECT_ID=$(gcloud config list --format 'value(core.project)')
echo "BOOT_PROJECT_ID: $BOOT_PROJECT_ID"
BILLING_FORMAT="--format=value(billingAccountName)"
BILLING_ID=$(gcloud billing projects describe $BOOT_PROJECT_ID $BILLING_FORMAT | sed 's/.*\///')
echo "BILLING_ID: ${BILLING_ID}"
#ORGID=$(gcloud organizations list --format="get(name)" --filter=displayName=$DOMAIN)
ORG_ID=$(gcloud projects get-ancestors $BOOT_PROJECT_ID --format='get(id)' | tail -1)
echo "ORG_ID: ${ORG_ID}"
# not required yet
#EMAIL=$(gcloud config list --format json|jq .core.account | sed 's/"//g')

# switch back to/create kcc project - not in a folder
if [[ "$CREATE_PROJ" != false ]]; then

  echo "applying roles to the super admin SUPER_ADMIN_EMAIL: ${SUPER_ADMIN_EMAIL}"
  # securityAdmin required
  # there are issues with a ROLES list over 5 in this case - break out for selective application
  gcloud organizations add-iam-policy-binding $ORG_ID --member=user:$SUPER_ADMIN_EMAIL --role=roles/resourcemanager.organizationAdmin --quiet > /dev/null 1>&1
  gcloud organizations add-iam-policy-binding $ORG_ID --member=user:$SUPER_ADMIN_EMAIL --role=roles/resourcemanager.folderAdmin --quiet > /dev/null 1>&1
  gcloud organizations add-iam-policy-binding $ORG_ID --member=user:$SUPER_ADMIN_EMAIL --role=roles/resourcemanager.projectIamAdmin --quiet > /dev/null 1>&1
  gcloud organizations add-iam-policy-binding $ORG_ID --member=user:$SUPER_ADMIN_EMAIL --role=roles/compute.networkAdmin --quiet > /dev/null 1>&1
  gcloud organizations add-iam-policy-binding $ORG_ID --member=user:$SUPER_ADMIN_EMAIL --role=roles/accesscontextmanager.policyAdmin --quiet > /dev/null 1>&1
  gcloud organizations add-iam-policy-binding $ORG_ID --member=user:$SUPER_ADMIN_EMAIL --role=roles/servicedirectory.editor --quiet > /dev/null 1>&1
  gcloud organizations add-iam-policy-binding $ORG_ID --member=user:$SUPER_ADMIN_EMAIL --role=roles/dns.admin --quiet > /dev/null 1>&1
  gcloud organizations add-iam-policy-binding $ORG_ID --member=user:$SUPER_ADMIN_EMAIL --role=roles/logging.admin --quiet > /dev/null 1>&1
  # for viewing buckets under logging project
  gcloud organizations add-iam-policy-binding $ORG_ID --member=user:$SUPER_ADMIN_EMAIL --role=roles/storage.admin --quiet > /dev/null 1>&1

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
  echo "Creating KCC project: ${CC_PROJECT_ID} on folder: ${ROOT_FOLDER_ID}"
  #gcloud projects create $CC_PROJECT_ID --name="${CC_PROJECT_ID}" --set-as-default
  gcloud projects create $CC_PROJECT_ID --name="${CC_PROJECT_ID}" --set-as-default --folder="$ROOT_FOLDER_ID"
  gcloud config set project "${CC_PROJECT_ID}"
  # enable billing
  echo "Enabling billing on account: ${BILLING_ID}"
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
  gcloud services enable anthos.googleapis.com


  gcloud logging settings update --organization=$ORG_ID --storage-location=$REGION

  # create VPC
  echo "Create VPC: ${NETWORK}"
  gcloud compute networks create $NETWORK --subnet-mode=custom
  # create subnet
  echo "Create subnet ${SUBNET} off VPC: ${NETWORK} using ${CIDR_KCC_VPC} on region: ${REGION}"
  gcloud compute networks subnets create $SUBNET --network $NETWORK --range $CIDR_KCC_VPC --region $REGION --stack-type=IPV4_ONLY
  #--enable-private-ip-google-access \
  #--enable-flow-logs --logging-aggregation-interval=interval-5-sec --logging-flow-sampling=1.0 --logging-metadata=include-all

  # Cloud router and Cloud NAT - both not required because dev envs are not using PSC and the GKE cluster is using a public endpoint
  #gcloud compute routers create kcc-router --project=$CC_PROJECT_ID  --network=$NETWORK  --asn=64513 --region=$REGION
  #gcloud compute routers nats create kcc-nat --router=kcc-router --region=$REGION --auto-allocate-nat-external-ips --nat-all-subnet-ip-ranges 
  # --enable-logging

  echo "create default firewalls"
  #gcloud compute firewall-rules create allow-egress-tcp-udp-icmp --network $NETWORK --allow tcp,udp,icmp --source-ranges 0.0.0.0/0 --direction EGRESS --priority 1000
  #gcloud compute firewall-rules create allow-egress-ssh --network $NETWORK --allow tcp:22,tcp:3389,icmp --direction EGRESS --priority 1010
 
else
  echo "Switching to KCC project ${KCC_PROJECT_ID}"
  gcloud config set project "${KCC_PROJECT_ID}"
fi

  # SET management project number
  #KCC_PROJECT_NUMBER=$(gcloud projects list --filter="${KCC_PROJECT_ID}" '--format=value(PROJECT_NUMBER)')
  #echo "KCC_PROJECT_NUMBER: $KCC_PROJECT_NUMBER"

if [[ "$CREATE_KCC" != false ]]; then
  # create KCC cluster
  # 3 KCC clusters max per region with 25 vCPU default quota
  startb=`date +%s`
  echo "Creating Anthos KCC autopilot cluster ${CLUSTER} in region ${REGION} in subnet ${SUBNET} off VPC ${NETWORK} on project ${KCC_PROJECT_ID}"
  # autopilot_opt: Deploy an autopilot cluster instead of a standard cluster
  gcloud anthos config controller create $CLUSTER --location $REGION --network $NETWORK --subnet $SUBNET --master-ipv4-cidr-block="172.16.0.128/28" --full-management

  endb=`date +%s`
  runtimeb=$((endb-startb))
  echo "Cluster create time: ${runtimeb} sec"
  gcloud anthos config controller get-credentials $CLUSTER --location $REGION
  echo "List Clusters:"
  gcloud anthos config controller list

  SA_EMAIL="$(kubectl get ConfigConnectorContext -n config-control -o jsonpath='{.items[0].spec.googleServiceAccount}' 2> /dev/null)"
  echo "post GKE cluster create - applying 2 roles to org: ${ORG_ID} and project: ${KCC_PROJECT_ID} on the yakima gke service account to prep for kpt deployment: $SA_EMAIL"
  gcloud organizations add-iam-policy-binding "${ORG_ID}" --member="serviceAccount:${SA_EMAIL}" --role=roles/resourcemanager.organizationAdmin --condition=None --quiet  > /dev/null 1>&1
  gcloud projects add-iam-policy-binding "${KCC_PROJECT_ID}" --member "serviceAccount:${SA_EMAIL}" --role "roles/serviceusage.serviceUsageConsumer" --project "${KCC_PROJECT_ID}" --quiet  > /dev/null 1>&1
  # need service account admin for kubectl describe iamserviceaccount.iam.cnrm.cloud.google.com/gatekeeper-admin-sa
  # Warning  UpdateFailed  36s (x9 over 6m44s)  iamserviceaccount-controller  Update call failed: error applying desired state: summary: Error creating service account: googleapi: Error 403: Permission 'iam.serviceAccounts.create' denied on resource (or it may not exist).
  ##roles/iam.serviceAccountCreator
  gcloud organizations add-iam-policy-binding "${ORG_ID}" --member="serviceAccount:${SA_EMAIL}" --role=roles/iam.organizationRoleAdmin --condition=None --quiet > /dev/null 1>&1
  gcloud organizations add-iam-policy-binding "${ORG_ID}" --member="serviceAccount:${SA_EMAIL}" --role=roles/iam.serviceAccountAdmin --condition=None --quiet > /dev/null 1>&1
fi

if [[ "$DEPLOY_LZ" != false ]]; then
    echo "wait 60 sec to let the GKE cluster stabilize 15 workloads"
    #sleep 60

    # generate setters.yaml
    REL_ROOT_PACKAGE="solutions"
    REL_SUB_PACKAGE="core-landing-zone"
    REL_PACKAGE="${REL_ROOT_PACKAGE}/${REL_SUB_PACKAGE}"
    # SET management project number 
    KCC_PROJECT_NUMBER=$(gcloud projects list --filter="${CC_PROJECT_ID}" '--format=value(PROJECT_NUMBER)')
    echo "KCC_PROJECT_NUMBER: $KCC_PROJECT_NUMBER"

    DIRECTORY_CUSTOMER_ID=$(gcloud organizations list --filter="${DIRECTORY_CUSTOMER_ID}" '--format=value(DIRECTORY_CUSTOMER_ID)')
    echo "DIRECTORY_CUSTOMER_ID: $DIRECTORY_CUSTOMER_ID"

    # reference https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit/blob/gh446-hub/solutions/core-landing-zone/setters.yaml
cat << EOF > ./${REL_SUB_PACKAGE}/setters-${REL_SUB_PACKAGE}.yaml
apiVersion: v1
kind: ConfigMap
metadata: # kpt-merge: /setters
  name: setters
  annotations:
    config.kubernetes.io/local-config: "true"
data: 
  org-id: "${ORG_ID}"
  lz-folder-id: "${ROOT_FOLDER_ID}"
  billing-id: "${BILLING_ID}"
  management-project-id: "${KCC_PROJECT_ID}"
  management-project-number: "${KCC_PROJECT_NUMBER}"
  management-namespace: config-control
  allowed-trusted-image-projects: |
    - "projects/cos-cloud"
  allowed-contact-domains: |
    - "@${CONTACT_DOMAIN}"
  allowed-policy-domain-members: |
    - "${DIRECTORY_CUSTOMER_ID}"
  allowed-vpc-peering: |
    - "under:organizations/${ORG_ID}"
  logging-project-id: logging-project-${PREFIX}
  security-incident-log-bucket: security-incident-log-bucket-${PREFIX}
  platform-and-component-log-bucket: platform-and-component-log-bucket-${PREFIX}
  retention-locking-policy: "false"
  retention-in-days: "1"
  security-incident-log-bucket-retention-locking-policy: "false"
  security-incident-log-bucket-retention-in-seconds: "86400"  
  dns-project-id: dns-project-${PREFIX}
  dns-name: "${CONTACT_DOMAIN}."
EOF

    echo "generated derived setters-${REL_SUB_PACKAGE}.yaml"

  # Landing zone deployment
  # https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit/tree/main/solutions/landing-zone#0-set-default-logging-storage-location

  # fetch the LZ
  cd ../../../

  if [ -d "${KPT_FOLDER_NAME}" ] 
  then
    echo "Directory ${KPT_FOLDER_NAME} exists - using it" 
  else
    echo "Creating ${KPT_FOLDER_NAME}"
    mkdir ${KPT_FOLDER_NAME}
  fi
  
  cd $KPT_FOLDER_NAME

  # URL from https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit/blob/main/docs/landing-zone-v2/README.md#fetch-the-packages
  REL_URL="https://raw.githubusercontent.com/GoogleCloudPlatform/pubsec-declarative-toolkit/main/.release-please-manifest.json"
  # check for existing landing-zone
  echo "deploying ${REL_SUB_PACKAGE}"
  REL_VERSION=$(curl -s $REL_URL | jq -r ".\"$REL_PACKAGE\"")
  echo "get kpt release package $REL_PACKAGE version $REL_VERSION"
  rm -rf $REL_SUB_PACKAGE
  kpt pkg get https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit.git/${REL_PACKAGE}@${REL_VERSION}
  # cp the setters.yaml
  echo "copy over generated setters.yaml"
  cp ../$REPO_ROOT/pubsec-declarative-toolkit/$REL_PACKAGE/setters-${REL_SUB_PACKAGE}.yaml $REL_SUB_PACKAGE/setters.yaml
  #cp pubsec-declarative-toolkit/solutions/landing-zone/.krmignore landing-zone/ 

  # see requireShiededVM and restrictVPCPeering removal to recreate a cluster
  # https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit/issues/588
  #echo "removing org/org-policies folder"
  #rm -rf $REL_SUB_PACKAGE/org/org-policies

  echo "kpt live init"
  kpt live init $REL_SUB_PACKAGE --namespace config-control
  # --force
  echo "kpt fn render"
  kpt fn render $REL_SUB_PACKAGE --truncate-output=false
  #kpt alpha live plan $REL_SUB_PACKAGE
  echo "kpt live apply after 60s wait"
  sleep 60  
  #kpt live apply $REL_SUB_PACKAGE
  kpt live apply $REL_SUB_PACKAGE --reconcile-timeout=15m --output=table

  echo "check status"
  kpt live status $REL_SUB_PACKAGE --inv-type remote --statuses InProgress,NotFound

  echo "Wait 2 min"
  count=$(kubectl get gcp | grep UpdateFailed | wc -l)
  echo "UpdateFailed: $count"
  count=$(kubectl get gcp | grep UpToDate | wc -l)
  echo "UpToDate: $count"
  # set default kubectl namespace to avoid -n or --all-namespaces
  kubens config-control
  #
  echo "sleep 60 sec - then check 5 namespaces projects/networking/heirarchy/policies/logging"
  sleep 60
  kubectl get gcp
  kubectl get gcp -n projects
  kubectl get gcp -n networking
  kubectl get gcp -n hierarchy
  kubectl get gcp -n policies
  kubectl get gcp -n logging
  kubectl get gcp -n config-management-monitoring

  
  # check projects-sa and verify billing
  echo "check iamserviceaccount.iam.cnrm.cloud.google.com/projects-sa before verifying billing"
  kubectl describe iamserviceaccount.iam.cnrm.cloud.google.com/projects-sa
  # needs to be set on the billing page
  echo " bind billing ${BILLING_ID} to serviceAccount:projects-sa@${KCC_PROJECT_ID}.iam.gserviceaccount.com"
  gcloud beta billing accounts add-iam-policy-binding "${BILLING_ID}" --member "serviceAccount:projects-sa@${KCC_PROJECT_ID}.iam.gserviceaccount.com" --role "roles/billing.user"

  cd ../$REPO_ROOT/pubsec-declarative-toolkit/solutions
fi

if [[ "$DEPLOY_HUB" != false ]]; then
    echo "wait 60 sec to let the GKE cluster stabilize 15 workloads"
    #sleep 60

    # generate setters.yaml
    REL_ROOT_PACKAGE="solutions"
    # betweeen solutions and hub-env in this example = project but could be 2+ dirs
    REL_MID_PACKAGE="project"
    REL_SUB_PACKAGE="hub-env"
    REL_PACKAGE="${REL_ROOT_PACKAGE}/${REL_MID_PACKAGE}/${REL_SUB_PACKAGE}"
    # SET management project number 
    KCC_PROJECT_NUMBER=$(gcloud projects list --filter="${CC_PROJECT_ID}" '--format=value(PROJECT_NUMBER)')
    echo "KCC_PROJECT_NUMBER: $KCC_PROJECT_NUMBER"

    DIRECTORY_CUSTOMER_ID=$(gcloud organizations list --filter="${DIRECTORY_CUSTOMER_ID}" '--format=value(DIRECTORY_CUSTOMER_ID)')
    echo "DIRECTORY_CUSTOMER_ID: $DIRECTORY_CUSTOMER_ID"

    # reference https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit/blob/gh446-hub/solutions/project/hub-env/setters.yaml
    # original: hub-admin: group:group@domain.com
    echo "using hub project id: ${HUB_PROJECT_ID_PREFIX}-${PREFIX}"
cat << EOF > ./${REL_MID_PACKAGE}/${REL_SUB_PACKAGE}/setters-${REL_SUB_PACKAGE}.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: setters
  annotations:
    config.kubernetes.io/local-config: "true"
data:
  org-id: "${ORG_ID}"
  project-billing-id: "${BILLING_ID}"
  project-parent-folder: ${HUB_PROJECT_PARENT_FOLDER}
  hub-project-id: ${HUB_PROJECT_ID_PREFIX}-${PREFIX}
  management-project-id: ${HUB_PROJECT_ID_PREFIX}-${PREFIX}
  # must be config-control due to hardcoding
  management-namespace: config-control
  hub-admin: ${HUB_ADMIN_GROUP_EMAIL}
  project-allowed-restrict-vpc-peering: |
    - under:organizations/${ORG_ID}
  project-allowed-vm-external-ip-access: |
    - "projects/${HUB_PROJECT_ID_PREFIX}-${PREFIX}/zones/${REGION}-a/instances/fgt-primary-instance"
    - "projects/${HUB_PROJECT_ID_PREFIX}-${PREFIX}/zones/${REGION}-b/instances/fgt-secondary-instance"
  project-allowed-vm-can-ip-forward: |
    - "projects/${HUB_PROJECT_ID_PREFIX}-${PREFIX}/zones/${REGION}-a/instances/fgt-primary-instance"
    - "projects/${HUB_PROJECT_ID_PREFIX}-${PREFIX}/zones/${REGION}-b/instances/fgt-secondary-instance"
  fgt-primary-image: ${FORTIGATE_PRIMARY_IMAGE}
  fgt-primary-license: |
    LICENSE
  fgt-secondary-image: ${FORTIGATE_SECONDARY_IMAGE}
  fgt-secondary-license: |
    LICENSE
EOF

    echo "generated derived setters-${REL_SUB_PACKAGE}.yaml"

  # Landing zone deployment
  # https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit/tree/main/solutions/landing-zone#0-set-default-logging-storage-location

  # fetch the hub-env
  cd ../../../

  if [ -d "${KPT_FOLDER_NAME}" ] 
  then
    echo "Directory ${KPT_FOLDER_NAME} exists - using it" 
  else
    echo "Creating ${KPT_FOLDER_NAME}"
    mkdir ${KPT_FOLDER_NAME}
  fi

  cd $KPT_FOLDER_NAME

  
  # URL from https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit/blob/main/docs/landing-zone-v2/README.md#fetch-the-packages
  REL_URL="https://raw.githubusercontent.com/GoogleCloudPlatform/pubsec-declarative-toolkit/main/.release-please-manifest.json"
  # check for existing landing-zone
  echo "deploying ${REL_SUB_PACKAGE}"
  REL_VERSION=$(curl -s $REL_URL | jq -r ".\"$REL_PACKAGE\"")
  echo "get kpt release package $REL_PACKAGE version $REL_VERSION"
  #rm -rf $REL_SUB_PACKAGE
  #kpt pkg get https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit.git/${REL_PACKAGE}@${REL_VERSION}
  # cp the setters.yaml
  echo "copy over generated setters.yaml"
  cp ../$REPO_ROOT/pubsec-declarative-toolkit/$REL_PACKAGE/setters-${REL_SUB_PACKAGE}.yaml $REL_SUB_PACKAGE/setters.yaml

  # list of changes to main
  ###################################3 
  # add org-id to setters.yaml
  # https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit/issues/573
  # comment out hardcoded dependson and project for now in hub-env/project.yaml
  # https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit/issues/596

  echo "kpt live init"
  #kpt live init $REL_SUB_PACKAGE --namespace config-control --force
  echo "kpt fn render"
  kpt fn render $REL_SUB_PACKAGE --truncate-output=false
  #kpt alpha live plan $REL_SUB_PACKAGE
  echo "kpt live apply"
  # without a timeout the command never terminates
  #kpt live apply $REL_SUB_PACKAGE --reconcile-timeout=10m
  kpt live apply $REL_SUB_PACKAGE --reconcile-timeout=15m --output=table

  echo "Wait 2 min"
  count=$(kubectl get gcp | grep UpdateFailed | wc -l)
  echo "UpdateFailed: $count"
  count=$(kubectl get gcp | grep UpToDate | wc -l)
  echo "UpToDate: $count"
  # set default kubectl namespace to avoid -n or --all-namespaces
  kubens config-control
  #
  echo "sleep 60 sec - then check 5 namespaces projects/networking/heirarchy/policies/logging"
  sleep 60
  kubectl get gcp
  kubectl get gcp -n projects
  kubectl get gcp -n networking
  kubectl get gcp -n hierarchy
  kubectl get gcp -n policies
  kubectl get gcp -n logging

  # check services skipped
  kpt live status core-landing-zone | grep not
  
  # check projects-sa and verify billing
  echo "check iamserviceaccount.iam.cnrm.cloud.google.com/projects-sa before verifying billing"
  kubectl describe iamserviceaccount.iam.cnrm.cloud.google.com/projects-sa
  # needs to be set on the billing page
  # https://console.cloud.google.com/billing
  # not for direct billing accounts though - just shared billing
  gcloud beta billing accounts add-iam-policy-binding "${BILLING_ID}" --member "serviceAccount:projects-sa@${KCC_PROJECT_ID}.iam.gserviceaccount.com" --role "roles/billing.user"

  cd ../$REPO_ROOT/pubsec-declarative-toolkit/solutions
fi

if [[ "$REMOVE_LZ" != false ]]; then
  echo "deleting lz on ${CLUSTER} in region ${REGION}"
  #kubectl get gcp
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


  echo "moving to folder ../../../$KPT_FOLDER_NAME"
  cd ../../../kpt
  #cd $KPT_FOLDER_NAME

  REL_SUB_PACKAGE="core-landing-zone"
  echo "deleting REL_SUB_PACKAGE: $REL_SUB_PACKAGE"
  kpt live destroy $REL_SUB_PACKAGE
  # all packages delete
  #kubectl delete gcp --all
  # sub packages delete

  cd ../$REPO_ROOT/pubsec-declarative-toolkit/solutions
  echo "wait 60 sec for gcp services to finish deleting before an optional GKE cluster delete"
  sleep 60
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
fi

if [[ "$DELETE_PROJ" != false ]]; then
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
  # go back to the script dir
  #cd pubsec-declarative-toolkit/solutions/landing-zone 
}

UNIQUE=
DEPLOY_LZ=false
DEPLOY_HUB=false
CREATE_KCC=false
DELETE_KCC=false
REMOVE_LZ=false
BOOT_PROJECT_ID=
DELETE_PROJ=false
CREATE_PROJ=false

while getopts ":b:u:n:c:l:h:d:r:j:p:" PARAM; do
  case $PARAM in
    b)
      BOOT_PROJECT_ID=${OPTARG}
      ;;
    u)
      UNIQUE=${OPTARG}
      ;;
    n)
      CREATE_PROJ=${OPTARG}
      ;;
    c)
      CREATE_KCC=${OPTARG}
      ;;
    l)
      DEPLOY_LZ=${OPTARG}
      ;;
    h)
      DEPLOY_HUB=${OPTARG}
      ;;      
    r)
      REMOVE_LZ=${OPTARG}
      ;;      
    d)
      DELETE_KCC=${OPTARG}
      ;;
    j)
      DELETE_PROJ=${OPTARG}
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

#  echo "Options are: -n true/false (create proj) -c true/false (create kcc), -l true/false (deploy landing zone) -h true/false (deploy hub) -r (remove lz) -d true/false (delete kcc) -j true/false (delete proj) -p kcc-project-id"


if [[ -z $UNIQUE ]]; then
  usage
  exit 1
fi
echo "existing project: $KCC_PROJECT_ID"
deployment $BOOT_PROJECT_ID $UNIQUE $CREATE_PROJ $CREATE_KCC $DEPLOY_LZ $DEPLOY_HUB $REMOVE_LZ $DELETE_KCC $DELETE_PROJ $KCC_PROJECT_ID
printf "**** Done ****\n"

# changes to kpt
# management-vm/service-account.yaml
# service-account
# project.yaml
# fortigate-ap-primary/secondary

