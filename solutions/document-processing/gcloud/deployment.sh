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
example create 2min (notice the -d false)
root_@cloudshell:~/pubsec-declarative-toolkit/solutions/document-processing (pdt-tgz)$ ./deployment.sh  -u pdt2 -c true -l false -d false -e user-email
example delete 20sec (notice the -c false and the previous -p project id)
root_@cloudshell:~/pubsec-declarative-toolkit/solutions/document-processing (pdt-tgz)$ ./deployment.shp -u pdt2 -c false -l false -d true -e user-email -p kcc-lz-9672

no install/no delete 
./deployment.sh -u pdt -c false -l false -d false -p docai-gen-6293

-u [unique] true/false       : unique identifier for your project - take your org/domain 1st letters forward/reverse - ie: landging.gcp.zone lgz
-c [create] true/false       : create deployment
-l [landingzone] true false  : deploy landing zone
-d [delete] true/false       : delete deployment
-3 [user_email]              : target user identity account email - defaults to USER_EMAIL already set to current logged in user
-p [KCC project] string      : target KCC project: ie controller-lgz-1201
EOF
}

# set for michael@cloudshell:~/dev/pdt-oldev/obriensystems/pubsec-declarative-toolkit/solutions/landing-zone (kcc-lz-8597)$ ./deployment.sh -b pdt-oldev -u pdtoldev -c false -l true -d false -p kcc-lz-8597

# for ease of override - key/value pairs for constants - shared by all scripts
source ./vars.sh


getrole()
{
    array=( iam.serviceAccountTokenCreator roles/resourcemanager.folderAdmin roles/resourcemanager.organizationAdmin orgpolicy.policyAdmin resourcemanager.projectCreator billing.projectManager )
    for i in "${array[@]}"
    do
	    echo "$i"
        ROLE=`gcloud organizations get-iam-policy $1 --filter="bindings.members:$2" --flatten="bindings[].members" --format="table(bindings.role)" | grep $i`
        if [ -z "$ROLE" ]
        then
            echo "roles/$i role missing"
            exit 1
        else
            echo "${ROLE} role set OK on super admin account"
        fi  
done
}

## Inventory
# GCS bucket: online_mode
# GCS bucket: json_metadata
# BQ: table: FinalTable
# BQ: table: FinalConfTable
# BQ: table: TransactionBable
# SA: 

create_once_only() {

  ## backup dir
  echo "create backup dir in private/anthos/gcloud dir"
  pwd
  #mkdir backup
  #echo "switching to src internal repo up 2 directories in ${REPO_TREE_DEPTH_FOR_CD_UP}${SRC_REPO}"
}

create_service_accounts() {
  SA_EMAIL=$SERVICE_ACCOUNT_MAIN@$CC_PROJECT_ID.iam.gserviceaccount.com
  echo "Create service account: $SA_EMAIL"  
  gcloud iam service-accounts create $SERVICE_ACCOUNT_MAIN --project=$CC_PROJECT_ID

  #gcloud iam service-accounts create "${$SERVICE_ACCOUNT_MAIN}" --display-name "docproc SA" --project=${CC_PROJECT_ID} --quiet
  SA_EMAIL=`gcloud iam service-accounts list --project="${CC_PROJECT_ID}" --filter=${SERVICE_ACCOUNT_MAIN} --format="value(email)"`
  echo "Email: $SA_EMAIL"
# Service Account permissions - switch from member=user to serviceAccount
# https://gcp.permissions.cloud/predefinedroles
# AutoML Editor
gcloud projects add-iam-policy-binding $CC_PROJECT_ID  --member=serviceAccount:$SA_EMAIL --role=roles/automl.editor --quiet > /dev/null 1>&1

# BigQuery Data Editor
gcloud projects add-iam-policy-binding $CC_PROJECT_ID  --member=serviceAccount:$SA_EMAIL --role=roles/bigquery.dataEditor --quiet > /dev/null 1>&1

# BigQuery Job User
gcloud projects add-iam-policy-binding $CC_PROJECT_ID  --member=serviceAccount:$SA_EMAIL --role=roles/bigquery.dataEditor --quiet > /dev/null 1>&1

# BigQuery User
gcloud projects add-iam-policy-binding $CC_PROJECT_ID  --member=serviceAccount:$SA_EMAIL --role=roles/bigquery.user --quiet > /dev/null 1>&1

# Document AI Administrator
gcloud projects add-iam-policy-binding $CC_PROJECT_ID  --member=serviceAccount:$SA_EMAIL --role=roles/documentai.admin --quiet > /dev/null 1>&1

# Document AI Editor (not required)
gcloud projects add-iam-policy-binding $CC_PROJECT_ID  --member=serviceAccount:$SA_EMAIL --role=roles/documentai.editor --quiet > /dev/null 1>&1

# Storage Admin
gcloud projects add-iam-policy-binding $CC_PROJECT_ID  --member=serviceAccount:$SA_EMAIL --role=roles/storage.admin --quiet > /dev/null 1>&1

# Vertex AI Custom Code Service Agent
gcloud projects add-iam-policy-binding $CC_PROJECT_ID  --member=serviceAccount:$SA_EMAIL --role=roles/aiplatform.customCodeServiceAgent --quiet > /dev/null 1>&1

}

delete_service_accounts() {
  echo "Delete service accounts - keep generated ones"
  SA_EMAIL=$SERVICE_ACCOUNT_MAIN@$CC_PROJECT_ID.iam.gserviceaccount.com
  echo "Delete SA: $SA_EMAIL"
  gcloud iam service-accounts delete $SA_EMAIL --project=$CC_PROJECT_ID --quiet
}

deploy_gke() {
  start=`date +%s`
  echo "6 min: ${GKE_CLUSTER} cluster create"
  echo "Start: ${start}" 
  echo "Create cluster ${GKE_CLUSTER} prefix: $GKE_prefix release-channel: $GKE_release_channel"
  gcloud beta container clusters create ${GKE_CLUSTER} \
    --machine-type=n1-standard-4 \
    --num-nodes=2 \
    --workload-pool=${WORKLOAD_POOL} \
    --enable-stackdriver-kubernetes \
    --network=$NETWORK \
    --subnetwork=$SUBNET \
    --release-channel=$GKE_release_channel \
    --labels mesh_id=$GKE_prefix${MESH_ID}
  end=`date +%s`
  echo "Finish: ${end}" 
  runtimeb=$((end-start))
  echo "Cluster create time: ${runtimeb} sec"
  echo "Date: $(date)"
}

install_asm() {
  # install asm on GKE
  curl https://storage.googleapis.com/csm-artifacts/asm/asmcli_1.15 > asmcli
  chmod +x asmcli
  echo "validate $GKE_CLUSTER"
  
  # gcloud services enable mesh.googleapis.com
  # gcloud services enable anthos.googleapis.com
  # may need to run and then comment validate
  #./asmcli validate --project_id $CC_PROJECT_ID --cluster_name $GKE_CLUSTER --cluster_location $ZONE --fleet_id $CC_PROJECT_ID --output_dir ./asm_output
  
  echo "install $GKE_CLUSTER"
  ./asmcli install --project_id $CC_PROJECT_ID --cluster_name $GKE_CLUSTER --cluster_location $ZONE --fleet_id $CC_PROJECT_ID --output_dir ./asm_output --enable_all --option legacy-default-ingressgateway --ca mesh_ca --enable_gcp_components
}

install_gateway() {
  # post install_asm
  echo "installing gateway on $GKE_CLUSTER in $GATEWAY_NS"
  gcloud container clusters get-credentials $GKE_CLUSTER --zone $ZONE
  kubectl create namespace $GATEWAY_NS
  ISTIO_NS=istio-system
  kubectl get deploy -n $ISTIO_NS -l app=istiod -o jsonpath={.items[*].metadata.labels.'istio\.io\/rev'}'{"\n"}'
  REVISION=$(kubectl get deploy -n $ISTIO_NS -l app=istiod -o jsonpath={.items[*].metadata.labels.'istio\.io\/rev'}'{"\n"}')
  echo "REVISION: $REVISION"
  # apply to default to pass task 15 and 16b
  kubectl label namespace $GATEWAY_NS istio.io/rev=$REVISION --overwrite
  #kubectl apply -n $GATEWAY_NS -f samples/gateways/istio-ingressgateway
  
  kubectl label namespace default istio-injection- istio.io/rev=$REVISION --overwrite
  kubectl apply -f asm_output/istio-1.15.3-asm.6/samples/bookinfo/platform/kube/bookinfo.yaml
  kubectl apply -f asm_output/istio-1.15.3-asm.6/samples/bookinfo/networking/bookinfo-gateway.yaml
  kubectl get gateway
  # full json
  #kubectl get svc -n $ISTIO_NS istio-ingressgateway -o jsonpath={}
  kubectl get svc -n $ISTIO_NS istio-ingressgateway 
  # extract ip from "type":"LoadBalancer"},"status":{"loadBalancer":{"ingress":[{"ip":"34.133.99.17"} 
  INGRESS_IP=$(kubectl get svc -n $ISTIO_NS istio-ingressgateway -o jsonpath={.status.loadBalancer.ingress[0].ip}'{"\n"}')
  echo "ingress IP: $INGRESS_IP"
  echo "sleep 60s - wait for EXTERNAL-IP"
  sleep 60
  kubectl get svc -n $ISTIO_NS istio-ingressgateway 
  INGRESS_IP=$(kubectl get svc -n $ISTIO_NS istio-ingressgateway -o jsonpath={.status.loadBalancer.ingress[0].ip}'{"\n"}')
  echo "ingress IP: $INGRESS_IP"
  curl -I http://${INGRESS_IP}/productpage
  #sudo apt install siege siege http://${INGRESS_IP}/productpage
  # from lab
  #export GATEWAY_URL=$(kubectl get svc istio-ingressgateway -o=jsonpath='{.status.loadBalancer.ingress[0].ip}' -n $GATEWAY_NS)
  #echo "Istio Gateway Load Balancer: http://$GATEWAY_URL"
}

istio_injection() {
    # post install_gateway
    # switch kubectl context
    gcloud container clusters get-credentials $GKE_CLUSTER --zone $ZONE
    # display istio status
    kubectl get ns
    # no 2/2 pods running istio sidecars yet
    kubectl get pods
    # no istio labeling on namespaces yet
    kubectl get namespace -L istio-injection
    # label namespace default
    kubectl label namespace default istio-injection=enabled --overwrite
    # check namespace labeling
    kubectl get namespace -L istio-injection
    # bounce pods - to get them istio injected with sidecars
    # TODO expand to all pods
    kubectl delete pod -l app=productpage
    # display 2/2 sidecars
    echo "sleep 20s before checking for 2/2 injected sidecars"
    sleep 20
    kubectl get pods | grep 2/2
}

create_roles_services() {
# check expiry https://cloud.google.com/sdk/gcloud/reference/projects/add-iam-policy-binding

echo "Adding roles to project for user: ${USER_EMAIL}"
# owner for now
gcloud projects add-iam-policy-binding $CC_PROJECT_ID  --member=user:$USER_EMAIL --role=roles/owner --quiet > /dev/null 1>&1

#gcloud projects add-iam-policy-binding $CC_PROJECT_ID  --member=user:$USER_EMAIL --role=roles/ml.admin --quiet > /dev/null 1>&1
#gcloud projects add-iam-policy-binding $CC_PROJECT_ID  --member=user:$USER_EMAIL --role=roles/aiplatform.admin --quiet > /dev/null 1>&1
#gcloud projects add-iam-policy-binding $CC_PROJECT_ID  --member=user:$USER_EMAIL --role=roles/billing.projectManager --quiet > /dev/null 1>&1
# for SA impersonation
gcloud projects add-iam-policy-binding $CC_PROJECT_ID  --member=user:$USER_EMAIL --role=roles/iam.serviceAccountTokenCreator --quiet > /dev/null 1>&1

   # enable apis
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
  # cloud storage ok
  gcloud services enable notebooks.googleapis.com
  gcloud services enable dataflow.googleapis.com

  # CSR (up from AR) (for cloud run) ok
  gcloud services enable sourcerepo.googleapis.com
  gcloud services enable artifactregistry.googleapis.com


  # cr
  gcloud services enable containerregistry.googleapis.com

  # app engine ok

  # compute
  gcloud services enable compute.googleapis.com

  # run
  gcloud services enable run.googleapis.com
  gcloud services enable cloudapis.googleapis.com 
  gcloud services enable cloudbuild.googleapis.com 
  gcloud services enable storage-component.googleapis.com 
  gcloud services enable cloudkms.googleapis.com 
  gcloud services enable logging.googleapis.com 
  gcloud services enable cloudfunctions.googleapis.com

  # BigQuery ok
  #gcloud services enable bigquerymigration.googleapis.com
  #gcloud services enable bigquery.googleapis.com
  #gcloud services enable bigquerystorage.googleapis.com
  #gcloud services enable krmapihosting.googleapis.com 
  gcloud services enable container.googleapis.com
  #compute.googleapis.com
  #gcloud services enable cloudresourcemanager.googleapis.com 
  gcloud services enable cloudbilling.googleapis.com

   # CSR (up from AR) (for cloud run) ok
   #gcloud services enable accesscontextmanager.googleapis.com 
   gcloud services enable anthos.googleapis.com
  # gcloud services enable artifactregistry.googleapis.com
  # gcloud services enable cloudapis.googleapis.com 
  # gcloud services enable cloudbilling.googleapis.com
   # will auto create the service account - get it and save to vars.sh
  # gcloud services enable cloudbuild.googleapis.com 
  # gcloud services enable cloudfunctions.googleapis.com
  # gcloud services enable cloudkms.googleapis.com
   gcloud services enable cloudresourcemanager.googleapis.com 
  # gcloud services enable compute.googleapis.com
  # gcloud services enable container.googleapis.com 
   gcloud services enable containeranalysis.googleapis.com
  # gcloud services enable containerregistry.googleapis.com
   gcloud services enable krmapihosting.googleapis.com 
  # gcloud services enable logging.googleapis.com 
   gcloud services enable mesh.googleapis.com
   #gcloud services enable monitoring.googleapis.com
  # gcloud services enable run.googleapis.com
  # gcloud services enable sourcerepo.googleapis.com
  # gcloud services enable storage-component.googleapis.com 

   # add Kubernetes Cluster Admin to Cloud Build Service Agent

  # sas
  #Add	Artifact Registry Service Agent	 service-374013806670@gcp-sa-artifactregistry.iam.gserviceaccount.com		
  #Add	Cloud Run Service Agent	 service-374013806670@serverless-robot-prod.iam.gserviceaccount.com	
  #Kubernetes Engine Developer
}

istio_injection_prod() {
  echo "istio_injection_prod"
  gcloud config set compute/zone ${ZONE}
  #export GKE_release_channel=regular
  export GKE_release_channel=stable
  export GKE_CLUSTER=$GKE_PROD
  export GKE_prefix=p
  istio_injection
}

asm_cluster_prod() {
  echo "asm_cluster_prod"
  gcloud config set compute/zone ${ZONE}
  #export GKE_release_channel=regular
  export GKE_release_channel=stable
  export GKE_CLUSTER=$GKE_PROD
  export GKE_prefix=p
  install_asm 
}

install_gateway_prod() {
  echo "install_gateway_prod"
  gcloud config set compute/zone ${ZONE}
  #export GKE_release_channel=regular
  export GKE_release_channel=stable
  export GKE_CLUSTER=$GKE_PROD
  export GKE_prefix=p
  install_gateway
}

create_cluster_prod() {
  echo "6 min total: 6 min: prod cluster:"
  gcloud config set compute/zone ${ZONE}
  #export GKE_release_channel=regular
  export GKE_release_channel=stable
  export GKE_CLUSTER=$GKE_PROD
  export GKE_prefix=p
  deploy_gke
}

delete_clusters() {
  gcloud config set compute/zone ${ZONE}
  echo "Date: $(date)"
  echo "4 min"
  echo "Delete $GKE_PROD cluster"
  gcloud beta container clusters delete $GKE_PROD --quiet
}

create_vpc() {
# create VPC
  echo "Create VPC: ${NETWORK}"
  gcloud compute networks create $NETWORK --subnet-mode=custom
  echo "Create subnet ${SUBNET} off VPC: ${NETWORK}"
  gcloud compute networks subnets create $SUBNET --network $NETWORK --range $CIDR_VPC --region $REGION
}

delete_vpc() {
  # delete VPC (routes and firewalls will be deleted as well)
  echo "deleting subnet ${SUBNET}"
  gcloud compute networks subnets delete ${SUBNET} --region=$REGION -q
  echo "deleting vpc ${NETWORK}"
  gcloud compute networks delete ${NETWORK} -q
}

create_cloudbuild_prod() {
    # task 11
     # requires kubernetes engine admin on the cb sa
  echo "Create Cloud Build - prod"
  # Kubernetes Engine Developer
  #https://cloud.google.com/kubernetes-engine/docs/how-to/iam
#  gcloud projects add-iam-policy-binding $PROJECT_ID --member="serviceAccount:$CLOUD_BUILD_SA" --role="roles/container.developer" --quiet > /dev/null 1>&1
  # https://cloud.google.com/build/docs/deploying-builds/deploy-gke
  # working so far without a service account set
  # PROD MAIN create cloud build trigger (simultaneous dev/prod gke cluster builds - should do dev first)
  gcloud beta builds triggers create cloud-source-repositories --repo=$CSR_NAME --branch-pattern=main --name="${CLOUDBUILD_TRIGGER_PROD_MAIN}" --build-config=cloudbuild-prod-main.yaml
  
  #gcloud builds submit --region=$REGION --project=$PROJECT_ID --config build-config
  #gcloud alpha builds trigger create cloud-source-repositories --trigger-config=cloudbuild.yaml --project=$PROJECT_ID
}

trigger_prod_main_build() {
  echo "trigger_prod_main_build"
  # commit to main branch
  cd $REPO_TREE_DEPTH_FOR_CD_UP
  cd $SRC_REPO
  git checkout main
  cp ../$GITHUB_GCLOUD_REPO_DIR/assets/empty_stub.sh empty1_stub.sh
  git add empty1_stub.sh
  git commit -m "trigger prod"
  git push google main
  git checkout main   
  cd ../$../$GITHUB_GCLOUD_REPO_DIR
}

delete_cloudbuild() {
  echo "delete Cloud Build triggers"
  gcloud beta builds triggers delete $CLOUDBUILD_TRIGGER_PROD_MAIN
}

create_csr() {
   echo "Creating CSR"
   cd $REPO_TREE_DEPTH_FOR_CD_UP
   mkdir $CSR_ROOT
   cd $CSR_ROOT
   # create csr, ar
   # https://cloud.google.com/source-repositories/docs/adding-repositories-as-remotes
   # validated
   git config --global credential.'https://source.developers.google.com'.helper gcloud.sh
   gcloud source repos create $CSR_NAME
   # unvalidated

   echo "cloning for CSR repo https://github.com/GoogleCloudPlatform/$SRC_REPO"
   git clone https://github.com/GoogleCloudPlatform/$SRC_REPO.git
   cd $SRC_REPO

   git remote add google https://source.developers.google.com/p/$CC_PROJECT_ID/r/$CSR_NAME
   #git push google master
   #git push google main   
   git push --all google
   # note - will stop on user/email credentials - the first time through here

   # Create branch dev
   #git branch $BRANCH_DEV
   #git push -u google $BRANCH_DEV

   git checkout $CSR_BRANCH_OTHER_THAN_MAIN
   # copy artifacts (will be in both branches)
   cp ../$GITHUB_GCLOUD_REPO_DIR/assets/main/cloudbuild-prod-main.yaml .
   git add .
   git commit -m "triple cloud build main"
   git push google $CSR_BRANCH_OTHER_THAN_MAIN
   # enable csr role
   #gcloud source repos set-iam-policy $CSR_NAME POLICY_FILE
   cd ../../$GITHUB_GCLOUD_REPO_DIR
}

delete_csr() {
  # delete CSR - cannot reuse name for 7d
  echo "Delete CSR dir $CSR_NAME"
  gcloud source repos delete $CSR_NAME --quiet
  # delete repo
  echo "Delete temp repo $SRC_REPO"
  cd $REPO_TREE_DEPTH_FOR_CD_UP
  cd $CSR_ROOT
  rm -rf $SRC_REPO
  cd ..
  rm -rf $CSR_ROOT
  #rm -rf ../../../$TEMP_REPO_DIR
  # delete triggers done in delete_cloudbuild before
  # get back
  cd $GITHUB_GCLOUD_REPO_DIR  
}

create_ar() {
   echo "create ar"
   # enable csr role
   #gcloud source repos set-iam-policy REPOSITORY_NAME POLICY_FILE
   # ar
   #gcloud artifacts repositories create reference-code --location=northamerica-northeast1 --repository-format=docker
}

delete_ar() {
    echo "delete ar"
}

delete_all() {
  # delete service accounts
  #gcloud iam service-accounts delete $SERVICE_ACCOUNT_M4A_CE_SRC@$PROJECT_ID.iam.gserviceaccount.com  --project=$PROJECT_ID --quiet
  #gcloud iam service-accounts delete $SERVICE_ACCOUNT_M4A_INSTALL@$PROJECT_ID.iam.gserviceaccount.com  --project=$PROJECT_ID --quiet
  # cloud build service account was generated on service enablement
 
  # delete generated files in the repo
  rm -rf *.yaml
  rm -rf *.json
  #rm -rf Dockerfile
  rm -rf asm_output
  rm -rf asmcli
  rm -rf backup/*
  rm -rf backup

  echo "Date: $(date)"
}

deployment() {
  echo "Date: $(date)"
  echo "Timestamp: $(date +%s)"
  echo "running with: -b $BOOT_PROJECT_ID -u $UNIQUE -c $CREATE_KCC -l $DEPLOY_LZ -d $DELETE_KCC -e $USER_EMAIL -p $KCC_PROJECT_ID"
  
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

echo "CC_PROJECT_ID: $CC_PROJECT_ID"
echo "passed in KCC_PROJECT_ID: $KCC_PROJECT_ID"
#export BOOT_PROJECT_ID=$(gcloud config list --format 'value(core.project)')
#gcloud config list --format json | jq .core.project | sed 's/"//g'
# We pass in the project id so we can switch back from potentially another transient project
echo "BOOT_PROJECT_ID: $BOOT_PROJECT_ID"
export BILLING_ID=$(gcloud alpha billing projects describe $BOOT_PROJECT_ID '--format=value(billingAccountName)' | sed 's/.*\///')
echo "BILLING_ID: ${BILLING_ID}"
#ORGID=$(gcloud organizations list --format="get(name)" --filter=displayName=$DOMAIN)
ORG_ID=$(gcloud projects get-ancestors $BOOT_PROJECT_ID --format='get(id)' | tail -1)
echo "ORG_ID: ${ORG_ID}"
export EMAIL=$(gcloud config list --format json|jq .core.account | sed 's/"//g')

# switch back to/create kcc project - not in a folder
if [[ "$CREATE_KCC" != false ]]; then
  # switch back to/create kcc project - not in a folder
  echo "Creating KCC project: ${CC_PROJECT_ID}"
  gcloud projects create $CC_PROJECT_ID --name="${CC_PROJECT_ID}" --set-as-default
  gcloud config set project "${CC_PROJECT_ID}"
  #gcloud config set compute/zone ${ZONE}
  # enable billing
  gcloud beta billing projects link ${CC_PROJECT_ID} --billing-account ${BILLING_ID}

# add IAM permissions for restricted dev user
# check expiry https://cloud.google.com/sdk/gcloud/reference/projects/add-iam-policy-binding

  # get GKE/ASM ids
  export PROJECT_NUMBER=$(gcloud projects describe ${CC_PROJECT_ID} --format="value(projectNumber)")
  export WORKLOAD_POOL=${CC_PROJECT_ID}.svc.id.goog
  export MESH_ID="proj-${CC_PROJECT_NUMBER}"

  create_roles_services
  create_vpc
  create_once_only
  create_service_accounts  
  create_csr
  create_ar 
 # create_cluster_prod
  create_cloudbuild_prod
  #trigger_prod_main_build
 # asm_cluster_prod
 # istio_injection_prod
 # install_gateway_prod
 # trigger_prod_main_build

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
  act=`gcloud iam service-accounts list --project="${KCC_PROJECT_ID}" --filter=SA-${KCC_PROJECT_ID} --format="value(email)"`

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
fi


  #create_service_accounts  
  #create_csr
  #create_ar

 # delete
if [[ "$DELETE_KCC" != false ]]; then
  echo "Deleting ${CC_PROJECT_ID}"
 #  delete_clusters
 #  delete_istio_registration
   delete_cloudbuild
   delete_ar
   delete_csr
   delete_vpc
   delete_service_accounts
   delete_all

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

echo "Use the following command to switch to your new project"
echo "gcloud config set project ${CC_PROJECT_ID}"
}

echo "Default USER_EMAIL if set is: $USER_EMAIL"

UNIQUE=
DEPLOY_LZ=false
CREATE_KCC=false
DELETE_KCC=false
#BOOT_PROJECT_ID=

while getopts ":u:c:l:d:e:p:" PARAM; do
  case $PARAM in
#    b)
#      BOOT_PROJECT_ID=${OPTARG}
#      ;;
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
    e)
      USER_EMAIL=${OPTARG} # user email defaults to the current session if not set
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

#  echo "Options are: -c true/false (create kcc), -l true/false (deploy landing zone) -d true/false (delete kcc) -e user-email -p kcc-project-id"
echo "USER_EMAIL reset to $USER_EMAIL"

if [[ -z $UNIQUE ]]; then
  usage
  exit 1
fi

deployment $UNIQUE $CREATE_KCC $DEPLOY_LZ $DELETE_KCC $USER_EMAIL $KCC_PROJECT_ID
printf "**** Done ****\n"
