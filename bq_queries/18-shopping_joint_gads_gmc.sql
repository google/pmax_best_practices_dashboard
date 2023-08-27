# Copyright 2022 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

CREATE OR REPLACE TABLE `{bq_dataset}_bq.shopping_joint_gads_gmc` AS (
    SELECT
      ADS.campaign_id,
      ADS.campaign_name,
      ADS.item_id,
      ADS.brand, 
      ADS.clicks,
      ADS.conversions,
      ADS.impressions,
      ADS.conversions_value,
      ADS.cost,
      ADS.ctr,
      MC.product_id,
      MC.item_group_id,
      MC.google_product_category,
      MC.google_product_category_path,
      MC.product_type
    FROM 
      `{bq_dataset}_bq.shopping_gads` ADS
    JOIN `{bq_dataset}_bq.shopping_gmc` AS MC
      ON LOWER(ADS.item_id) = LOWER(MC.product_id)
)
