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

CIDR_KCC_VPC=192.168.0.0/16
#REGION=northamerica-northeast1
# used for vpc, subnet, KCC cluster
PREFIX=oi3
#CLUSTER=kcc-oi2
KCC_PROJECT_NAME=kcc-oi
public_endpoint_opt=true

# from gcp-tools kcc.env
CLUSTER=kcc-oi3
REGION=northamerica-northeast1
#PROJECT_ID=kcc-oi2-cluster
LZ_FOLDER_NAME=kcc-lz-20231020c
NETWORK=kcc-oi3-vpc
SUBNET=kcc-oi3-sn
#ROOT_FOLDER_ID=96269513997
#BILLING_ID=014479-806359-2F5F85
