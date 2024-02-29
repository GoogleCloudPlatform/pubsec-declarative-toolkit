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

# Common (core-landing-zone - hub-env)
#CIDR_KCC_VPC=192.168.0.0/16
# used for vpc, subnet, KCC cluster 
# MAKE SURE the prefix is unique in combination with another string - use your domain backwards
# for example kcc.landing.systems is kls or slk
# if it is not unique then your project creation will fail right away anyway due to global gcp collision
# these postfixes are separate in the case we selectively delete/redeploy one or more packages
# for example a failed client-setup will require postfix2 where the core-landing-zone still has postfix1
export PREFIX_CORE_LANDING_ZONE=cso2
# for client-setup
export PREFIX_CLIENT_SETUP=cso3
# for client-landing-zone
export PREFIX_CLIENT_LANDING_ZONE=cso3
# if different than core billing id
#export CLIENT_BILLING_ID=
# for client-project-setup
export PREFIX_CLIENT_PROJECT_SETUP=cso3
# one of 2 enums - match to project-parent-folder
export CLIENT_PROJECT_PARENT_FOLDER=nonp
#export CLIENT_CLASSIFICATION=pbmm
export CLIENT_CLASSIFICATION=nonp

# client-setup and client-project-setup
export CLIENT_NAME_1=client1
# if different than core billing id
#export PROJECT_BILLING_ID=
# for projects/hub-env
# rotate during delete/create cycle
export PREFIX_HUB_ENV=cso2

# for core-landing-zone

# for all packages
# must be config-control due to hardcoding
export MANAGEMENT_NAMESPACE=config-control
# pass in for select runs where cluster already up - this is your bootstrap project you run from - not the project that will contain your kcc/gke/kubernetes cluster
export KCC_PROJECT_NAME=kcc-cso
export REGION=northamerica-northeast1
# parent folder id (not name and not number)
export ROOT_FOLDER_ID=276061734969
# this is the HD name on your user/dev/client pc/shell - keep the same - this can be generated
export KPT_FOLDER_NAME=kpt
# match this to the folder just above where you cloned the pdt repo
export REPO_ROOT=github

# core-landing-zone only
export CONTACT_DOMAIN=cloud-setup.org
#public_endpoint_opt=true
export SUPER_ADMIN_EMAIL=michael@cloud-setup.org

# for projects/hub-env package
# M.o.s
# change before deploying
export HUB_PROJECT_BILLING_ID=01...54

export HUB_PROJECT_PARENT_FOLDER=services-infrastructure
export HUB_PROJECT_ID_PREFIX=xxdmu-admin1-hub
export HUB_ADMIN_GROUP_EMAIL=user:michael@cloud-setup.org
#export HUB_ADMIN_GROUP_EMAIL=group:sas@obrien.industries
# see https://docs.fortinet.com/document/fortigate-public-cloud/7.4.0/gcp-administration-guide/471595/using-image-family
export FORTIGATE_PRIMARY_IMAGE=projects/fortigcp-project-001/global/images/fortinet-fgtondemand-724-20230201-001-w-license
export FORTIGATE_SECONDARY_IMAGE=projects/fortigcp-project-001/global/images/fortinet-fgtondemand-724-20230201-001-w-license
#  not a valid identifier
#export FGT-PRIMARY-LICENSE=QAAAAL9N4x..
#export FGT-SECONDARY-LICENSE=QAAAAGSl..
