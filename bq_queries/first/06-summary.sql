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

CREATE OR REPLACE TABLE `{bq_dataset}_bq.summary` AS
SELECT
  PARSE_DATE("%Y-%m-%d", CM.date) AS day,
  CM.account_id AS account_id,
  CM.campaign_id,
  CM.campaign_name,
  CM.campaign_status,
  CM.bidding_strategy,
  ROUND(CM.cost/1000000) AS cost,
  CM.conversions,
  CS.conversion_action_id
FROM `{bq_dataset}.campaign_settings` AS CM
INNER JOIN `{bq_dataset}.conversion_split` AS CS
  USING(account_id, campaign_id)
