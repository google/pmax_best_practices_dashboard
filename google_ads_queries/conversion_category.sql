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
    campaign.status AS campaign_status,
    customer.id AS account_id,
    campaign_conversion_goal.category AS conversion_name,
    campaign.advertising_channel_type AS campaign_type
FROM campaign_conversion_goal
WHERE campaign.advertising_channel_type IN ('PERFORMANCE_MAX', 'SEARCH')
AND campaign_conversion_goal.biddable = TRUE
