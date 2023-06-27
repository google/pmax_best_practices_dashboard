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

CREATE OR REPLACE TABLE `{bq_dataset}_bq.primary_conversion_action_search`
AS
  WITH conversion_account_level AS (
    SELECT
      account_id,
      campaign_id,
      campaign_type,
      conversion_name
    FROM `{bq_dataset}.conversion_category`
    GROUP BY 1,2,3,4
),
conversion_split AS (
    SELECT
      account_id,
      campaign_id,
      campaign_type,
      ARRAY_TO_STRING(ARRAY_AGG(conversion_name),",") AS conversion_name
    FROM conversion_account_level
    GROUP BY 1,2,3
    UNION ALL
    SELECT
      account_id,
      campaign_id,
      campaign_type,
      custom_conversion_goal_name AS conversion_name
    FROM `{bq_dataset}.conversion_custom`
    JOIN `{bq_dataset}.custom_goal_names` USING (account_id,custom_conversion_goal_id)
),
conversion_split_grouped_w_custom AS (
  SELECT
      account_id,
      campaign_id,
      campaign_type,
      ARRAY_TO_STRING(ARRAY_AGG(conversion_name),",") AS conversion_name
  FROM conversion_split
  GROUP BY 1,2,3
),
convActionFreq AS (
    SELECT
      account_id,
      campaign_type,
      conversion_name,
      RANK() OVER (PARTITION BY account_id, campaign_type ORDER BY COUNT(DISTINCT campaign_id) DESC) AS row_num
    FROM conversion_split_grouped_w_custom
    WHERE campaign_type = "SEARCH"
    GROUP BY account_id, conversion_name, campaign_type
),
convActionFreq_grouped AS (
  SELECT
      account_id,
      campaign_type,
      row_num,
      conversion_name
      --ARRAY_TO_STRING(ARRAY_AGG(conversion_name),",") AS conversion_name
  FROM convActionFreq
  GROUP BY 1,2,3
),
most_used_conversions AS (
  SELECT
    cs.account_id,
    cs.campaign_id,
    cf.conversion_name
    --ARRAY_TO_STRING(ARRAY_AGG(cf.conversion_name),",") AS conversion_name
  FROM conversion_split_grouped_w_custom cs
  JOIN convActionFreq_grouped cf USING (account_id)
  WHERE row_num = 1
  AND cs.campaign_type = "SEARCH"
  GROUP BY 1,2,3
)
SELECT
  account_id,
  conversion_name
FROM most_used_conversions
GROUP BY 1,2