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

# Common (core-landing-zone - hub-env)
#CIDR_KCC_VPC=192.168.0.0/16
# used for vpc, subnet, KCC cluster 
# MAKE SURE the prefix is unique in combination with another string - use your domain backwards
# for example kcc.landing.systems is kls or slk
# if it is not unique then your project creation will fail right away anyway due to global gcp collision
export PREFIX=cdd1
export UNIQUE=cdd
export AUDIT_PROJECT_ID=audit-lz-cdd-03
export REGION=northamerica-northeast1
export CIDR_VPC=192.168.0.0/16
#LZ_FOLDER_NAME_PREFIX=landing-zone-1
export NETWORK=cdd-vpc
export SUBNET=cdd-sn
export ROOT_FOLDER_ID=592711306009

