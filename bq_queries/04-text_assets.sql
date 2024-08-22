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

CREATE OR REPLACE TABLE `{bq_dataset}_bq.text_assets`
AS
WITH count_headlines AS (
  SELECT
    campaign_id,
    asset_group_id,
    COUNT(*) AS count_headlines
  FROM `{bq_dataset}.assetgroupasset`
  WHERE asset_sub_type IN ('HEADLINE', 'LONG_HEADLINE')
  GROUP BY 1, 2
),
count_short_headlines AS (
  SELECT
    AGA.campaign_id,
    AGA.asset_group_id,
    COUNT(*) AS count_short_headlines
  FROM `{bq_dataset}.assetgroupasset` AS AGA
  WHERE AGA.asset_sub_type = 'HEADLINE'
  GROUP BY 1, 2
),
count_long_headlines AS (
  SELECT
    AGA.campaign_id,
    AGA.asset_group_id,
    COUNT(*) AS count_long_headlines
  FROM `{bq_dataset}.assetgroupasset` AS AGA
  WHERE AGA.asset_sub_type = 'LONG_HEADLINE'
  GROUP BY 1, 2
),
count_descriptions AS (
  SELECT
    AGA.campaign_id,
    AGA.asset_group_id,
    COUNT(*) AS count_descriptions
  FROM `{bq_dataset}.assetgroupasset` AS AGA
  WHERE AGA.asset_sub_type = 'DESCRIPTION'
  GROUP BY 1, 2
),
count_short_descriptions AS (
  SELECT
    AGA.campaign_id,
    AGA.asset_group_id,
    COUNT(*) AS count_short_descriptions
  FROM `{bq_dataset}.assetgroupasset` AS AGA
  WHERE AGA.asset_sub_type = 'DESCRIPTION'
    AND LENGTH(AGA.text_asset_text) <= 60
  GROUP BY 1, 2
)
SELECT DISTINCT
  AGS.account_id,
  AGS.account_name,
  AGS.campaign_id,
  AGS.campaign_name,
  AGS.asset_group_id,
  AGS.asset_group_name,
  COALESCE(CH.count_headlines,0) AS count_headlines,
  COALESCE(CSH.count_short_headlines,0) AS count_short_headlines,
  COALESCE(CD.count_descriptions,0) AS count_descriptions,
  COALESCE(CSD.count_short_descriptions,0) AS count_short_descriptions,
  COALESCE(CLH.count_long_headlines,0) AS count_long_headlines
FROM `{bq_dataset}.assetgroupsummary` AS AGS
LEFT JOIN count_headlines AS CH
  ON CH.campaign_id = AGS.campaign_id
  AND CH.asset_group_id = AGS.asset_group_id
LEFT JOIN count_short_headlines AS CSH
  ON CSH.campaign_id = AGS.campaign_id
  AND CSH.asset_group_id = AGS.asset_group_id
LEFT JOIN count_descriptions AS CD
  ON CD.campaign_id = AGS.campaign_id
  AND CD.asset_group_id = AGS.asset_group_id
LEFT JOIN count_short_descriptions AS CSD
  ON CSD.campaign_id = AGS.campaign_id
  AND CSD.asset_group_id = AGS.asset_group_id
LEFT JOIN count_long_headlines AS CLH
  ON CLH.campaign_id = AGS.campaign_id
  AND CLH.asset_group_id = AGS.asset_group_id
GROUP BY 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11
