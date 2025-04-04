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
    campaign.resource_name AS campaign_resource_name,
    campaign_criterion.negative,
    campaign_criterion.type,
FROM campaign_criterion
WHERE campaign.advertising_channel_type = 'PERFORMANCE_MAX'
    AND campaign.status IN ('ENABLED', 'PAUSED')
    AND campaign_criterion.negative = TRUE
