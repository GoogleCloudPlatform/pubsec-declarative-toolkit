
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


export CIDR_KCC_VPC=192.168.0.0/16
export REGION=northamerica-northeast1
# used for vpc, subnet, KCC cluster
export MIDFIX=pdtoldev
export PREFIX=lks
export KCC_PROJECT_NAME=interconnect-kls
export CLUSTER=$PREFIX-${MIDFIX}
export VPC=perimeter
export SUBNET=perimeter-sn

vpc() {
  gcloud services enable container.googleapis.com

  #gcloud services enable cloudresourcemanager.googleapis.com 
  #gcloud services enable accesscontextmanager.googleapis.com
  gcloud compute networks create perimeter --project=interconnect-kls --subnet-mode=custom --mtu=1460 --bgp-routing-mode=regional
  gcloud compute networks subnets create perimeter-sn --project=interconnect-kls --range=10.0.10.0/29 --stack-type=IPV4_ONLY --network=perimeter --region=$REGION --enable-private-ip-google-access
  gcloud compute firewall-rules create perimeter-allow-custom --project=interconnect-kls --network=projects/interconnect-kls/global/networks/perimeter --description=Allows\ connection\ from\ any\ source\ to\ any\ instance\ on\ the\ network\ using\ custom\ protocols. --direction=INGRESS --priority=65534 --source-ranges=10.0.10.0/29 --action=ALLOW --rules=all
  gcloud compute firewall-rules create perimeter-allow-icmp --project=interconnect-kls --network=projects/interconnect-kls/global/networks/perimeter --description=Allows\ ICMP\ connections\ from\ any\ source\ to\ any\ instance\ on\ the\ network. --direction=INGRESS --priority=65534 --source-ranges=0.0.0.0/0 --action=ALLOW --rules=icmp
  gcloud compute firewall-rules create perimeter-allow-rdp --project=interconnect-kls --network=projects/interconnect-kls/global/networks/perimeter --description=Allows\ RDP\ connections\ from\ any\ source\ to\ any\ instance\ on\ the\ network\ using\ port\ 3389. --direction=INGRESS --priority=65534 --source-ranges=0.0.0.0/0 --action=ALLOW --rules=tcp:3389
  gcloud compute firewall-rules create perimeter-allow-ssh --project=interconnect-kls --network=projects/interconnect-kls/global/networks/perimeter --description=Allows\ TCP\ connections\ from\ any\ source\ to\ any\ instance\ on\ the\ network\ using\ port\ 22. --direction=INGRESS --priority=65534 --source-ranges=0.0.0.0/0 --action=ALLOW --rules=tcp:22
  
}

deploy() {
    gcloud compute instances create nat-test-1 --image-family debian-9 --image-project debian-cloud --network custom-network1 --subnet subnet-us-east-192 \
    --zone us-east4-c \
    --no-address
}

# https://cloud.google.com/nat/docs/gce-example#gcloud_1


#Notes
# private VM (no nat or EIP)
vm() {
        #--service-account=389959590573-compute@developer.gserviceaccount.com \
  # --create-disk=auto-delete=yes,boot=yes,device-name=perim-private,image=projects/debian-cloud/global/images/debian-11-bullseye-v20230306,mode=rw,size=10,type=projects/$KCC_PROJECT_NAME/zones/$REGION/diskTypes/pd-balanced \
 
gcloud compute instances create perim-private \
    --project=$KCC_PROJECT_NAME \
    --zone=northamerica-northeast1-a \
    --machine-type=e2-small \
    --network-interface=network-tier=PREMIUM,subnet=perimeter-sn \
    --maintenance-policy=MIGRATE \
    --provisioning-model=STANDARD \
    --scopes=https://www.googleapis.com/auth/cloud-platform \
    --image-project debian-cloud \
    --image-family debian-9 \
    --no-shielded-secure-boot \
    --shielded-vtpm \
    --shielded-integrity-monitoring \
    --labels=ec-src=vm_add-gcloud \
    --reservation-affinity=any \
    --no-address
}


#deploy 
vm