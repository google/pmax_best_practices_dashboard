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
    campaign.id AS campaign_id,
    campaign.name AS campaign_name,
    campaign.status AS campaign_status,
    campaign.advertising_channel_type AS campaign_type,
    customer.id AS account_id,
    customer.descriptive_name AS account_name,
    segments.conversion_action_category AS conversion_action_category,
    segments.conversion_action AS conversion_action_id,
    segments.conversion_action_name AS conversion_action_name,
    segments.date AS date,
    metrics.all_conversions AS all_conversions,
    metrics.all_conversions_by_conversion_date AS all_conversions_by_conversion_date,
    metrics.all_conversions_value AS all_conversions_value,
    metrics.all_conversions_value_by_conversion_date AS all_conversions_value_by_conversion_date,
    metrics.conversions AS conversions,
    metrics.conversions_by_conversion_date AS conversions_by_conversion_date,
    metrics.conversions_value AS conversions_value,
    metrics.conversions_value_by_conversion_date AS conversions_value_by_conversion_date,
    metrics.value_per_conversion AS value_per_conversion,
    metrics.value_per_all_conversions AS value_per_all_conversions,
    metrics.view_through_conversions AS view_through_conversions
FROM campaign
WHERE campaign.advertising_channel_type = 'PERFORMANCE_MAX'
AND segments.date >= "{start_date}"
AND segments.date <= "{end_date}"
AND campaign.status IN ('ENABLED', 'PAUSED')
