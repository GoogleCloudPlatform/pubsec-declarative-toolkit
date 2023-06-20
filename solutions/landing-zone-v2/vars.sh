
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
export PREFIX=pdt
export KCC_PROJECT_NAME=kcc-lz
export CLUSTER=$PREFIX-${MIDFIX}
