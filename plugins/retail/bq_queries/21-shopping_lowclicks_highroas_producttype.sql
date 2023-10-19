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

CREATE OR  REPLACE TABLE `{bq_dataset}_bq.shopping_lowclicks_highroas_producttype`
AS (

WITH AverageClicks AS (
    SELECT
        SUM(clicks) / COUNT(*) AS average_clicks
    FROM
        `{bq_dataset}_bq.shopping_campaignproducttype`
)
SELECT
    campaign_name,
    product_type,
    CONCAT(product_type, ' ||| ', campaign_name) AS product_type_plus_campaign,
    clicks,
    impressions,
    sum_cost,
    sum_conversions_value,
    CASE 
        WHEN sum_cost = 0 THEN 0 
        ELSE sum_conversions_value/sum_cost 
    END AS roas
FROM 
    `{bq_dataset}_bq.shopping_campaignproducttype`,
    AverageClicks
WHERE
    clicks BETWEEN 0.10 * average_clicks AND 0.50 * average_clicks 
ORDER BY roas DESC
LIMIT 15)