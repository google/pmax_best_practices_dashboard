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

CREATE OR  REPLACE TABLE `{bq_dataset}_bq.shopping_campaignproducttype` AS (
  SELECT
    date,
    campaign_name,
    campaign_id,
    CASE 
        WHEN product_type_l1 IS NOT NULL AND product_type_l1 <> '' THEN
            COALESCE(product_type_l1, '') || CASE WHEN product_type_l2 IS NOT NULL AND product_type_l2 <> '' THEN ' > ' ELSE '' END ||
            COALESCE(product_type_l2, '') || CASE WHEN product_type_l3 IS NOT NULL AND product_type_l3 <> '' THEN ' > ' ELSE '' END ||
            COALESCE(product_type_l3, '') || CASE WHEN product_type_l4 IS NOT NULL AND product_type_l4 <> '' THEN ' > ' ELSE '' END ||
            COALESCE(product_type_l4, '') || CASE WHEN product_type_l5 IS NOT NULL AND product_type_l5 <> '' THEN ' > ' ELSE '' END ||
            COALESCE(product_type_l5, '')
        ELSE ''
    END AS product_type,
    SUM(clicks) AS clicks,
    SUM(conversions) AS conversions,
    SUM(impressions) AS impressions,
    SUM(conversions_value) AS sum_conversions_value,
    SUM(cost/1e6) AS sum_cost,
    SUM(ctr) AS ctr
  FROM 
    `{bq_dataset}.shoppingperformance_view`
  GROUP BY 1,2,3,4
)
