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

until [[ "$yn" == [YyNn] ]]; do
    msg='Would you like to connect your Merchant Center accounts '
    msg+='for product performance insights? (y/n): '
    read -p "$msg" yn
done

if [[ "$yn" == "y"  || "$yn" == "Y" ]]; then
    until [[ "$mcid" == "skip" ]] || [[ "$mcid" =~ ^[0-9]+$ ]]; do
        msg='Please provide your Merchant Center or MCA ID '
        msg+='(e.g. 123456 or type 'skip' to skip this step): '
        read -p "$msg" mcid
    done

    if [[ "$mcid" =~ ^[0-9]+$ ]]; then
        
        echo -e "\nis_retail: true" >> config.yaml
        
        echo "creating a dataset in BigQuery named merchant_center_transfer..."
        # TODO: Make data_location dynamic:
        bq mk -d --data_location=EU merchant_center_transfer

        echo "creating a Data Transfer for Merchant Center in BigQuery..."
        bq_mk_params='{"merchant_id":"'$mcid'",'
        bq_mk_params+='"export_products":"true",'
        bq_mk_params+='"export_regional_inventories":"true",'
        bq_mk_params+='"export_local_inventories":"true",'
        bq_mk_params+='"export_best_sellers":"true"}'
        bq mk --transfer_config \
            --project_id="$DEVSHELL_PROJECT_ID" \
            --data_source=merchant_center \
            --display_name=merchant_center_transfer \
            --target_dataset=merchant_center_transfer \
            --params=$bq_mk_params
    else
        echo "skipping GMC setup..."
    fi

else
    echo "skipping GMC setup..."
fi

echo "initializing Google Ads data ETL Workflow..."
npm init gaarf-wf@latest -- --answers=answers.json