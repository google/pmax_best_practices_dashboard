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

#This is a script to update the version of the retail pmax that uses the Merchant Center data to the version hat doesn;t use GMC data, only google Ads.   
set -e

git pull 

ANSWERS="answers.json"
WORK_RETAIL="work_retail"

# Using Node.js to read values from answers.json
READ_SCRIPT="
const fs = require('fs');
const data = JSON.parse(fs.readFileSync('${ANSWERS}', 'utf8'));
console.log(data.name);
console.log(data.gcs_bucket);
console.log(data.path_to_bq_queries);
"

# Read values from answers.json to determine which bucket to delete.
read -r name gcs_bucket path_to_bq_queries <<< $(node -e "$READ_SCRIPT")

# Determine the GCS bucket name
if [ -z "$gcs_bucket" ]; then
    PROJECT_ID=$(gcloud config get-value project)
    BUCKET_NAME=$PROJECT_ID
else
    BUCKET_NAME=$gcs_bucket
fi

# Construct the full path of the folder to delete
FOLDER_PATH="gs://${BUCKET_NAME}/${name}/${path_to_bq_queries}"

# Check if the folder exists
if gcloud storage ls "$FOLDER_PATH" >/dev/null 2>&1; then
    # Deleting the folder in the GCS bucket
    gcloud storage rm --recursive "${FOLDER_PATH}"
    echo "Folder ${path_to_bq_queries} in bucket ${BUCKET_NAME} under ${name} has been deleted."
else
    echo "Folder ${path_to_bq_queries} does not exist in bucket ${BUCKET_NAME} under ${name}."
fi


if [ -d "$WORK_RETAIL" ]; then
    # Check and remove bq_queries if it exists
    if [ -d "$WORK_RETAIL/bq_queries" ]; then
        rm -rf "$WORK_RETAIL/bq_queries"
        echo "Directory '$WORK_RETAIL/bq_queries' has been removed."
    else
        echo "Directory '$WORK_RETAIL/bq_queries' does not exist."
    fi

    # Check and remove google_ads_queries if it exists
    if [ -d "$WORK_RETAIL/google_ads_queries" ]; then
        rm -rf "$WORK_RETAIL/google_ads_queries"
        echo "Directory '$WORK_RETAIL/google_ads_queries' has been removed."
    else
        echo "Directory '$WORK_RETAIL/google_ads_queries' does not exist."
    fi
else
    echo "Directory '$WORK_RETAIL' does not exist."
    #if the directory doesn't exist at all, we will need to deploy from scratch
    ./build-retail.sh
    cd "$WORK_RETAIL"
    npm init gaarf-wf@latest -- --answers=answers.json
    exit
fi
./build-retail.sh
cd "$WORK_RETAIL"
./deploy-queries.sh
./run-wf.sh