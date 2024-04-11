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


CREATE OR REPLACE TABLE `{bq_dataset}_bq.assetgroup_performance` AS (
    WITH
    LOW_ASSETS AS (
      SELECT
        asset_group_id,
        COUNT(*) AS sum_of_low_perf_assets
      FROM `{bq_dataset}_bq.summaryassets`
      WHERE asset_performance = 'LOW'
      GROUP BY asset_group_id
    )
    SELECT
      AGS.date,
      AGS.account_id,
      AGS.account_name,
      AGS.campaign_id,
      AGS.campaign_name,
      AGS.asset_group_id,
      AGS.asset_group_name,
      AGS.asset_group_status,
      AGS.ad_strength,
      AGS.clicks,
      AGS.impressions,
      AGS.ctr,
      AGS.cost / 1e6 AS cost,
      AGS.conversions,
      AGS.all_conversions,
      AGS.conversions_value,
      AGS.all_conversions_value,
      AGS.value_per_all_conversions,
      AGS.value_per_conversion,
      IFNULL(LA.sum_of_low_perf_assets, 0) AS sum_of_low_performing_assets
    FROM `{bq_dataset}.assetgroupsummary` AS AGS
    LEFT JOIN LOW_ASSETS AS LA
      ON AGS.asset_group_id = LA.asset_group_id
)