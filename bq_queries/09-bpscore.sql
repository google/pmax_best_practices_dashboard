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
( 
  SELECT
    date,
    CD.account_id,
    CD.account_name,
    CD.campaign_id,
    CD.campaign_name,
    round(
      (
        IF(CD.url_expansion_opt_out=true,1,0) +
        CD.audience_signals_score +
        IF(CD.missing_sitelinks=0,1,missing_sitelinks/4) + 
        CASE 
          WHEN positive_geo_target_type_configured_good='X' AND negative_geo_target_type_configured_good='X' THEN 0
          WHEN positive_geo_target_type_configured_good='Yes' AND negative_geo_target_type_configured_good='X' THEN 0.5
          WHEN positive_geo_target_type_configured_good='X' AND negative_geo_target_type_configured_good='Yes' THEN 0.5
          WHEN positive_geo_target_type_configured_good='Yes' AND negative_geo_target_type_configured_good='Yes' THEN 1
        END
      )/4,2
    ) AS campaign_bp_score
  FROM `{bq_dataset}_bq.campaign_data`AS CD 
  GROUP BY 1,2,3,4,5,6
)