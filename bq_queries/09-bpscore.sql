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

CREATE OR REPLACE TABLE `{bq_dataset}_bq.campaignbpscore_${format(today(),'yyyyMMdd')}` AS
SELECT
  date,
  account_id,
  account_name,
  campaign_id,
  campaign_name,
  round((if(url_expansion_opt_out=true,1,0)+if(audience_signals="Yes",1,0))/2,2) AS campaign_bp_score
    --+if(daily_budget_3target="Yes",1,0)+if(is_same_conversion="Yes",1,0)+if(is_same_target="Yes",1,0)+if(is_daily_budget_140usd="Yes",1,0))/6,2) AS campaign_bp_score,
FROM `{bq_dataset}_bq.campaign_data`
GROUP BY 1,2,3,4,5,6