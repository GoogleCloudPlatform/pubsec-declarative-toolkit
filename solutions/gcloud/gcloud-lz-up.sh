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
./gcloud-lz-up -b boot-lz-cdd 

-b [boot proj id] string     : boot/source project (separate from project for KCC cluster)

EOF
}

# for eash of override - key/value pairs for constants - shared by all scripts
source ./vars.sh

echo "Landing Zone orchestration start"