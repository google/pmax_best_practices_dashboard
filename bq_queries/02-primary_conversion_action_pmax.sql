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

CREATE OR REPLACE TABLE `{bq_dataset}_bq.primary_conversion_action_pmax`
AS (
  WITH convActionFreq AS (
     SELECT
        account_id,
        campaign_id,
        conversion_name,
        ROW_NUMBER() OVER (PARTITION BY account_id, campaign_id ORDER BY SUM(conversions) DESC ) AS row_num
     FROM `{bq_dataset}.conversion_split`
     WHERE campaign_type = "PERFORMANCE_MAX"
     GROUP BY account_id, campaign_id, conversion_name
  )
  SELECT
    account_id,
    campaign_id, 
    conversion_name
  FROM convActionFreq
  WHERE row_num = 1
)
