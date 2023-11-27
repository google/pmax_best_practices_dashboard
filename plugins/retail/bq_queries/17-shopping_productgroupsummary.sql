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

CREATE OR  REPLACE TABLE `{bq_dataset}_bq.shopping_productgroupsummary`
AS (
    SELECT
      date,
      product_type,
      SUM(clicks) AS clicks,
      SUM(impressions) AS impressions,
      # ctr = clicks/impressions*100
      SUM(sum_cost) AS sum_cost,
      SUM(sum_conversions_value) AS sum_conversions_value 
      # roas = conversions_value/cost
    FROM 
      `{bq_dataset}_bq.shopping_campaignproducttype` 
    GROUP BY 1, 2
)
