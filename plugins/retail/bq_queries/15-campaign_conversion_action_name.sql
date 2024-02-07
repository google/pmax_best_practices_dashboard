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



CREATE OR REPLACE TABLE `{bq_dataset}_bq.campaign_conversion_action_name` AS (
SELECT
date, 
account_id,
account_name,
campaign_id,
campaign_name,
conversion_action_name, 
conversion_action_category,
sum(all_conversions) AS all_conversions,
sum(all_conversions_value) AS all_conversions_value,
sum(conversions) AS conversions,
sum(view_through_conversions) AS view_thrupgh_conversions,
sum(value_per_conversion) AS value_per_conversion
FROM `{bq_dataset}.campaignconversionaction`
GROUP BY 1, 2, 3, 4, 5, 6, 7
)