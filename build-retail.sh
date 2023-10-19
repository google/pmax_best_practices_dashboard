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


#This script copies all queries from bq_queries and google_ads_queries and adds retail related queries. 
#Then copies all other neccessery files and edits the answers.json file to create the dashboard on the retail template with all datasources. 
set -e

CLASSIC_DASHBOARD_ID="6e773f65-7612-45af-af37-e3cab6a9828b"
RETAIL_DASHBOARD_ID="755d5896-5c56-4f5a-9075-79249137c9ea"
GOOGLE_ADS_QUERIES="google_ads_queries"
BQ_QUERIES_DIRECTORY="bq_queries"
RETAIL_QUERIES_DIRECTORY="plugins/retail"
ANSWERS="answers.json"
CONVERSION_ACTION_TABLE="campaign_conversion_action_name"
PRODUCTGROUP_TABLE_NAME="shopping_productgroupsummary"
CAMPAIGN_PRODUCTGROUP_TABLE="shopping_campaignproducttype"
LOWCLICKS_HIGHROAS_TABLE="shopping_lowclicks_highroas_producttype"
WORK_RETAIL="work_retail"

regions=(
  'asia-east1'
  'asia-east2'
  'asia-northeast1'
  'asia-northeast2'
  'asia-south1'
  'asia-southeast1'
  'australia-southeast1'
  'europe-central2'
  'europe-west1'
  'europe-west2'
  'europe-west3'
  'europe-west6'
  'northamerica-northeast1'
  'southamerica-east1'
  'us-central1'
  'us-east1'
  'us-east4'
  'us-west1'
  'us-west2'
  'us-west3'
  'us-west4'
)

# Asking the user to select a region that will be used for the gaarf workflow and the MC datatransfer bigquery dataset.
echo "Please select a region for Cloud services (workflows, functions, scheduler, bigquery):"

select region in "${regions[@]}"; do
  if [[ -n $region ]]; then
    echo "You selected region: $region"
    break
  else
    echo "Invalid selection. Please try again."
  fi
done

raw_location=$(echo $region | cut -d'-' -f1)

case $raw_location in
    europe*) location="EU";;
    *) location="US";;
esac
mkdir -p "$WORK_RETAIL"
cp -r bq_queries "$WORK_RETAIL"
cp -r google_ads_queries "$WORK_RETAIL"
cp -r "$RETAIL_QUERIES_DIRECTORY"/"$GOOGLE_ADS_QUERIES"/* "$WORK_RETAIL"/"$GOOGLE_ADS_QUERIES"/    
cp -r "$RETAIL_QUERIES_DIRECTORY"/"$BQ_QUERIES_DIRECTORY"/* "$WORK_RETAIL"/"$BQ_QUERIES_DIRECTORY"/
cp "$ANSWERS" "$WORK_RETAIL"
cp get-accounts.sql "$WORK_RETAIL"
if [ -f google-ads.yaml ]; then
cp google-ads.yaml "$WORK_RETAIL"
fi
cd "$WORK_RETAIL"
echo "Created the work_retail directory and copied all queries from '$GOOGLE_ADS_QUERIES','$BQ_QUERIES_DIRECTORY' and "$RETAIL_QUERIES_DIRECTORY". Now working from the work_retail directory."

node - <<EOF
        
        try {
            const fs = require('fs');
            const ANSWERS_FILE_PATH = '${ANSWERS}';
            const data = JSON.parse(fs.readFileSync(ANSWERS_FILE_PATH, 'utf8'));

           if (data.dashboard_id === '${CLASSIC_DASHBOARD_ID}') {
             // Change non-retail dashboard template to retail template 
             data.dashboard_id = '${RETAIL_DASHBOARD_ID}';

             // Add retail-related datasets to dashboard_datasources
             data.dashboard_datasources.conversion_actions = '${CONVERSION_ACTION_TABLE}';
             data.dashboard_datasources.product_group_summary = '${PRODUCTGROUP_TABLE_NAME}';
             data.dashboard_datasources.campaign_product_group= '${CAMPAIGN_PRODUCTGROUP_TABLE}';
             data.dashboard_datasources.lowclicks_highroas_producttype = '${LOWCLICKS_HIGHROAS_TABLE}';

             //Update Selected region to region chosen in the setup
             data.gcp_region = '${region}'
            }

            fs.writeFileSync(ANSWERS_FILE_PATH, JSON.stringify(data, null, 4));
            console.log('Updated retail attributes in "' + ANSWERS_FILE_PATH + '"');
            } 
        catch (error) {
            console.error('Error:', error.message);
        }

EOF
