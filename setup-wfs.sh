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
    read -p "Would you like to connect your Merchant Center accounts for product performance insights? (y/n): " yn
done

if [ "$yn" == "y" ]; then
    until [[ "$mcid" == "skip" ]] || [[ "$mcid" =~ ^[0-9]+$ ]]; do
        read -p "Please provide your Merchant Center ID (e.g. 123456 or type 'skip' to skip this step): " mcid
    done

    if [[ "$mcid" =~ ^[0-9]+$ ]]; then
        
        echo "creating new merchant_center_transfer dataset in BigQuery..."
        # TODO: Make data_location dynamic:
        bq mk -d --data_location=EU merchant_center_transfer

        echo "creating new data transfer for merchant_center in BigQuery..."
        bq mk --transfer_config \
            --project_id="$DEVSHELL_PROJECT_ID" \
            --data_source=merchant_center \
            --display_name=merchant_center_transfer \
            --target_dataset=merchant_center_transfer \
            --params='{"merchant_id":"'$mcid'","export_products":"true","export_regional_inventories":"true","export_local_inventories":"true","export_price_benchmarks":"true","export_best_sellers":"true"}'
    else
        echo "skipping GMC setup..."
    fi

else
    echo "skipping GMC setup..."
fi

echo "installing Google Ads data ETL Workflow..."
npm init gaarf-wf@latest -- --answers=answers.json