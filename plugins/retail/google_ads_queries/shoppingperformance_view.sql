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
    campaign.advertising_channel_type,
    campaign.id AS campaign_id,
    campaign.name AS campaign_name,
    campaign.status AS campaign_status,
    segments.date AS date,
    segments.product_brand AS product_brand,
    segments.product_channel AS product_channel,
    segments.product_item_id AS product_item_id,
    segments.product_merchant_id AS merchant_id,
    metrics.ctr AS ctr,
    metrics.clicks AS clicks,
    metrics.conversions AS conversions,
    metrics.impressions AS impressions,
    metrics.conversions_value AS conversions_value,
    metrics.cost_micros AS cost
FROM shopping_performance_view 
WHERE campaign.advertising_channel_type = "PERFORMANCE_MAX"
    AND segments.date >= "{start_date}"
    AND segments.date <= "{end_date}"
    AND campaign.status = 'ENABLED'