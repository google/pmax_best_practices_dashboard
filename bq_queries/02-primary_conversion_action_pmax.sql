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

CREATE OR REPLACE TABLE `{bq_dataset}_bq.primary_conversion_action_pmax` AS
WITH
  CONVERSION_ACCOUNT_LEVEL AS (
    SELECT DISTINCT
      account_id,
      campaign_id,
      campaign_type,
      conversion_name
    FROM `{bq_dataset}.conversion_category`
  ),
  CONVERSION_SPLIT AS (
    SELECT
      account_id,
      campaign_id,
      campaign_type,
      ARRAY_TO_STRING(ARRAY_AGG(conversion_name),",") AS conversion_name
    FROM CONVERSION_ACCOUNT_LEVEL
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
  CONVERSION_SPLIT_GROUPED_W_CUSTOM AS (
    SELECT
      account_id,
      campaign_id,
      campaign_type,
      ARRAY_TO_STRING(ARRAY_AGG(conversion_name),",") AS conversion_name
    FROM CONVERSION_SPLIT
    GROUP BY 1,2,3
  ),
  CONVERSION_ACTION_FREQUENCY AS (
    SELECT
      account_id,
      campaign_id,
      campaign_type,
      conversion_name,
      RANK() OVER (PARTITION BY account_id, campaign_type
        ORDER BY COUNT(DISTINCT campaign_id) DESC) AS row_num
    FROM CONVERSION_SPLIT_GROUPED_W_CUSTOM
    WHERE campaign_type = "PERFORMANCE_MAX"
    GROUP BY
      account_id,
      conversion_name,
      campaign_type,
      campaign_id
  ),
  CONVERSION_ACTION_FREQUENCY_GROUPED AS (
    SELECT
      account_id,
      campaign_id,
      campaign_type,
      row_num,
      ARRAY_TO_STRING(ARRAY_AGG(conversion_name),",") AS conversion_name
    FROM CONVERSION_ACTION_FREQUENCY
    GROUP BY
      account_id,
      campaign_id,
      campaign_type,
      row_num
  ),
  MOST_USED_CONVERSIONS AS (
    SELECT
      CS.account_id,
      CS.campaign_id,
      ARRAY_TO_STRING(ARRAY_AGG(CF.conversion_name),",") AS conversion_name
    FROM CONVERSION_SPLIT_GROUPED_W_CUSTOM AS CS
    JOIN CONVERSION_ACTION_FREQUENCY_GROUPED AS CF
      USING (account_id, campaign_id)
    WHERE row_num = 1
      AND CS.campaign_type = "PERFORMANCE_MAX"
    GROUP BY 1,2
  )
SELECT DISTINCT
  account_id,
  campaign_id,
  conversion_name
FROM MOST_USED_CONVERSIONS