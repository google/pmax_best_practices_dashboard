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
AS (
  WITH convActionFreq AS (
     SELECT
        account_id,
        conversion_action_id,
        ROW_NUMBER() OVER (PARTITION BY account_id ORDER BY SUM(conversions) DESC ) AS row_num
     FROM `{bq_dataset}.conversion_split`
     WHERE campaign_type = "SEARCH"
     GROUP BY account_id, conversion_action_id
  )
  SELECT
    caf.account_id,
    caf.conversion_action_id,
    ANY_VALUE(cs.conversion_name)
  FROM convActionFreq caf
  JOIN `{bq_dataset}.conversion_split` cs
  USING (conversion_action_id)
  WHERE row_num = 1
  GROUP BY 1, 2
)