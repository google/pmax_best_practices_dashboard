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

CREATE OR REPLACE TABLE `{bq_dataset}_bq.assetgroupbpscore_${format(today(),'yyyyMMdd')}` AS
WITH video_data AS (
  SELECT
    account_id,
    account_name,
    campaign_id,
    campaign_name,
    asset_group_id,
    asset_group_name,
    ad_strength,
    is_video_uploaded,
    count_videos,
    IF(count_videos < 3, CAST(0 AS FLOAT64), CAST(1 as FLOAT64)) AS video_score
  FROM `{bq_dataset}_bq.video_assets`
),
text_data AS (
  SELECT
    account_id,
    account_name,
    campaign_id,
    campaign_name,
    asset_group_id,
    count_descriptions,
    count_headlines,
    count_long_headlines,
    count_short_descriptions,
    count_short_headlines,
    (IF(count_descriptions >= 4, 1, 0) + 
     IF(count_headlines >= 11, 1, 0) + 
     IF(count_long_headlines >= 2, 1, 0)) / 3 AS text_score
  FROM `{bq_dataset}_bq.text_assets`
),
image_data AS (
  SELECT
    account_id,
    account_name,
    campaign_id,
    campaign_name,
    asset_group_id,
    count_images,
    count_logos,
    count_landscape,
    count_portrait,
    count_landscape_logos,
    count_square,
    count_square_logos,
    (IF(count_landscape >= 4, 1, 0) + 
     IF(count_square >= 4, 1, 0) + 
     IF(count_portrait >= 4, 1, 0) + 
     IF(count_landscape_logos >= 1, 1, 0) + 
     IF(count_square_logos >= 1, 1, 0)) / 5 AS image_score
  FROM `{bq_dataset}_bq.image_assets`
),
audience_signals_count AS (
    SELECT 
      AGS.campaign_id AS campaign_id,
      AGS.asset_group_id,
      COUNT(DISTINCT AGS.asset_group_id) AS number_of_audience_signals, 
    FROM `{bq_dataset}.assetgroupsignal` AGS
    GROUP BY 
      campaign_id,
      asset_group_id
  )
SELECT
    CURRENT_DATE() AS date,
    AGS.account_id,
    AGS.account_name,
    AGS.campaign_id,
    AGS.campaign_name,  
    AGS.asset_group_id,
    AGS.asset_group_name,
    AGS.ad_strength,
    V.is_video_uploaded,
    V.video_score,
    T.text_score,
    I.image_score,
    IF(T.count_descriptions < 4, 4 - T.count_descriptions, 0) AS missing_descriptions,
    IF(T.count_descriptions < 5, 5 - T.count_descriptions, 0) AS missing_descriptions_max,
    IF(T.count_headlines < 11, 11 - T.count_headlines, 0) AS missing_headlines,
    IF(T.count_headlines < 15, 15 - T.count_headlines, 0) AS missing_headlines_max,
    IF(T.count_long_headlines < 2, 2 - T.count_long_headlines, 0) AS missing_long_headlines,
    IF(T.count_long_headlines < 5, 5 - T.count_long_headlines, 0) AS missing_long_headlines_max,
    IF((I.count_landscape + I.count_square + I.count_portrait) < 12, 12 - (I.count_landscape + I.count_square + I.count_portrait), 0) AS missing_images,
    IF((I.count_landscape + I.count_square + I.count_portrait) < 20, 20 - (I.count_landscape + I.count_square + I.count_portrait), 0) AS missing_images_max,
    IF(I.count_landscape < 4, 4 - I.count_landscape, 0) AS missing_landscape,
    IF(I.count_square < 4, 4 - I.count_square, 0) AS missing_square,
    IF(I.count_portrait < 2, 2 - I.count_portrait, 0) AS missing_portrait,
    IF(I.count_logos < 2, 2 - I.count_logos, 0) AS missing_logos,
    IF(I.count_square_logos = 0, 1, 0) AS missing_square_logos,
    IF(I.count_landscape_logos = 0, 1, 0) AS missing_landscape_logos,
    IF(V.count_videos < 3, 3 - V.count_videos, 0) AS missing_video,
    IF(V.count_videos < 5, 5 - V.count_videos, 0) AS missing_video_max,
    IF(ASA.number_of_audience_signals IS NOT NULL,"Yes","X") AS audience_signals
FROM `{bq_dataset}.assetgroupsummary` AGS
INNER JOIN video_data AS V
 ON AGS.account_id = V.account_id
 AND AGS.campaign_id = V.campaign_id
 AND AGS.asset_group_id = V.asset_group_id
INNER JOIN text_data AS T
 ON AGS.account_id = T.account_id
 AND AGS.campaign_id = T.campaign_id
 AND AGS.asset_group_id = T.asset_group_id
INNER JOIN image_data AS I
 ON AGS.account_id = I.account_id
 AND AGS.campaign_id = I.campaign_id
 AND AGS.asset_group_id = I.asset_group_id
LEFT JOIN audience_signals_count AS ASA
 ON AGS.campaign_id = ASA.campaign_id
 AND AGS.asset_group_id = ASA.asset_group_id
WHERE AGS.campaign_id IN (SELECT campaign_id FROM `{bq_dataset}.campaign_settings`)