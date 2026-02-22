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
  campaign_lifecycle_goal.campaign,
  campaign_lifecycle_goal.customer_acquisition_goal_settings.optimization_mode,
  campaign_lifecycle_goal.customer_acquisition_goal_settings.value_settings.value,
  campaign_lifecycle_goal.customer_acquisition_goal_settings.value_settings.high_lifetime_value
FROM campaign_lifecycle_goal
