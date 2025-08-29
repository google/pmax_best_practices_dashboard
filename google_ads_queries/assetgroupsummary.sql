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

SELECT
  segments.date AS date,
  asset_group.id AS asset_group_id,
  asset_group.name AS asset_group_name,
  asset_group.status AS asset_group_status,
  campaign.id AS campaign_id,
  campaign.name AS campaign_name,
  campaign.status AS campaign_status,
  customer.id AS account_id,
  customer.descriptive_name AS account_name,
  asset_group.ad_strength AS ad_strength,
  metrics.clicks AS clicks,
  metrics.conversions AS conversions,
  metrics.all_conversions AS all_conversions,
  metrics.cost_micros AS cost,
  metrics.conversions_value AS conversions_value,
  metrics.impressions AS impressions,
  metrics.ctr AS ctr,
  metrics.value_per_all_conversions AS value_per_all_conversions,
  metrics.value_per_conversion AS value_per_conversion,
  metrics.all_conversions_value AS all_conversions_value,
FROM
  asset_group
WHERE
  campaign.advertising_channel_type = 'PERFORMANCE_MAX'
  AND asset_group.status IN ('ENABLED', 'PAUSED')
  AND campaign.status IN ('ENABLED', 'PAUSED')
  AND segments.date >= '{start_date}'
  AND segments.date <= '{end_date}'
