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

CREATE OR REPLACE TABLE `{bq_dataset}_bq.assetgroupbestpractices` AS
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
    CAST(1 as FLOAT64) AS video_score
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
    (IF(count_descriptions >= 5,1,0)+IF(count_headlines >= 5,1,0)+IF(count_long_headlines >= 1,1,0)+IF(count_short_descriptions >= 1,1,0)+IF(count_short_headlines >= 1,1,0))/5 AS text_score
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
    (IF(count_images >= 15,1,0)+IF(count_logos >= 5,1,0)+IF(count_landscape >= 1,1,0)+IF(count_landscape_logos >= 1,1,0)+IF(count_square >= 1,1,0)+IF(count_square_logos >= 1,1,0))/6 AS image_score
  FROM `{bq_dataset}_bq.image_assets`
),
audience_signals_count AS (
    SELECT 
      COUNT(DISTINCT AGS.asset_group_id) AS number_of_audience_signals, 
      AGS.campaign_id AS campaign_id,
      AGS.asset_group_id
    FROM `{bq_dataset}.assetgroupsignal` AGS
    GROUP BY 
      campaign_id,
      asset_group_id
  )
SELECT
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
    --(IF(count_descriptions<5,5-count_descriptions,0) + IF(count_headlines<5,5-count_headlines,0) + IF(count_long_headlines<5,5 - count_long_headlines,0) + IF(count_short_descriptions<1,1,0) + IF(count_short_headlines<1,1,0) + IF(count_images<15,15-count_images,0) + IF(count_logos<5,5-count_logos,0) + IF(count_landscape<1,1,0) + IF(count_square<1,1,0) + IF(count_square_logos<1,1,0)) AS num_missing_assets,
    IF(count_descriptions < 4, 4 - count_descriptions, 0) AS missing_descriptions,
    IF(count_headlines < 5, 5 - count_headlines, 0) AS missing_headlines,
    IF(count_long_headlines < 5, 5 - count_long_headlines, 0) AS missing_long_headlines,
    IF((count_landscape + count_square + count_portrait) < 20, 20 - (count_landscape + count_square), 0) AS missing_images,
    IF(count_landscape < 3, 1, 0) AS missing_landscape,
    IF(count_square < 3, 1, 0) AS missing_square,
    IF(count_portrait = 0, 1, 0) AS missing_portrait,
    IF(count_logos < 5, 5 - count_logos, 0) AS missing_logos,
    IF(count_square_logos = 0, 1, 0) AS missing_square_logos,
    IF(count_landscape_logos = 0, 1, 0) AS missing_landscape_logos,
    IF(video_score = 0, 1, 0) AS missing_video,
    IF(ASA.number_of_audience_signals IS NOT NULL,"Yes","X") AS audience_signals
FROM `{bq_dataset}.assetgroupsummary` AGS
JOIN video_data V USING (account_id, campaign_id, asset_group_id)
JOIN text_data T USING (account_id,campaign_id, asset_group_id)
JOIN image_data I USING (account_id,campaign_id, asset_group_id)
LEFT JOIN audience_signals_count AS ASA
 ON AGS.campaign_id = ASA.campaign_id
 AND AGS.asset_group_id = ASA.asset_group_id
WHERE AGS.campaign_id IN (SELECT campaign_id FROM `{bq_dataset}.campaign_settings`)