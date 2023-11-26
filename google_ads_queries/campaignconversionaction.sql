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
    campaign.id as campaign_id, 
    campaign.name as campaign_name, 
    campaign.status as campaign_status, 
    campaign.advertising_channel_type as campaign_type,
    customer.id as account_id,
    customer.descriptive_name as account_name,
    segments.conversion_action_category as conversion_action_category,
    segments.conversion_action as conversion_action_id,
    segments.conversion_action_name as conversion_action_name, 
    segments.date as date,
    metrics.all_conversions as all_conversions, 
    metrics.all_conversions_by_conversion_date as all_conversions_by_conversion_date,
    metrics.all_conversions_value as all_conversions_value,
    metrics.all_conversions_value_by_conversion_date as all_conversions_value_by_conversion_date, 
    metrics.conversions as conversions,
    metrics.conversions_by_conversion_date as conversions_by_conversion_date, 
    metrics.conversions_value as conversions_value, 
    metrics.conversions_value_by_conversion_date as conversions_value_by_conversion_date,
    metrics.value_per_conversion as value_per_conversion, 
    metrics.value_per_all_conversions as value_per_all_conversions,
    metrics.view_through_conversions as view_through_conversions
FROM campaign 
WHERE campaign.advertising_channel_type = "PERFORMANCE_MAX"
AND segments.date >= "{start_date}"
AND segments.date <= "{end_date}"
AND campaign.status = 'ENABLED'