#!/bin/bash
#
# Copyright 2022 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#This is a script to update code from git and re-run all queries for retail-pmax users. 
set -e

WORK_RETAIL="work_retail"

git pull

#Check if the user deployed the retail version of pMaximizer. If so, work from there.
if [ -d "$WORK_RETAIL" ]; then
    ./build-retail.sh
    cd "$WORK_RETAIL"
fi

# This will trigger an update of gaarf, our underlying ETL library
./deploy-wf.sh

if [ -f "./deploy-queries.sh" ]; then
    # If deploy-queries.sh exists, run it
    ./deploy-queries.sh
else
    # If deploy-queries.sh does not exist, run deploy-scripts.sh
    ./deploy-scripts.sh
fi
./run-wf.sh

echo "generating a new up-to-date copy of our main template..."
# This will use our answers.json to generate a new template
npm install
npx lsd-cloner --answers=answers.json