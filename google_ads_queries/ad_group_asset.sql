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
  asset.id AS asset_id,
  ad_group_asset.ad_group~0 AS ad_group_id,
  customer.id AS account_id,
  ad_group_asset.field_type AS asset_type,
  segments.date AS date,
  metrics.impressions AS impressions,
  metrics.clicks AS clicks,
  metrics.conversions AS conversions,
  metrics.conversions_value AS conversions_value,
  metrics.cost_micros AS cost_micros
FROM
  ad_group_asset