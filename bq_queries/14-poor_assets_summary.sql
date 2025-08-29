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

CREATE OR REPLACE TABLE `{bq_dataset}_bq.poor_assets_summary` AS
    SELECT
        ABP.campaign_status,
        COUNT(distinct ABP.campaign_id) AS num_campaigns,
        COUNT(distinct ABP.asset_group_id) AS num_asset_groups
    FROM `{bq_dataset}_bq.assetgroupbestpractices` ABP
    WHERE ad_strength = 'POOR'
    GROUP BY ALL
  -- Adding dummy rows to avoid errors when filtering on campaign status
  UNION ALL
    SELECT
      'ENABLED' AS campaign_status,
      0 AS num_campaigns,
      0 AS num_asset_groups
  UNION ALL
    SELECT
      'PAUSED' AS campaign_status,
      0 AS num_campaigns,
      0 AS num_asset_groups

