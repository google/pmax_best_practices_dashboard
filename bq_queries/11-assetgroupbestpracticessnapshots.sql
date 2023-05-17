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
    count_landscape_logos,
    count_square,
    count_square_logos,
    (IF(count_images >= 20,1,0)+IF(count_logos >= 5,1,0)+IF(count_landscape >= 1,1,0)+IF(count_landscape_logos >= 1,1,0)+IF(count_square >= 1,1,0)+IF(count_square_logos >= 1,1,0))/6 AS image_score
  FROM `{bq_dataset}_bq.image_assets`
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
    IF(T.count_descriptions >= 5,"Yes","X") AS count_descriptions,
    IF(T.count_headlines >= 5,"Yes","X") AS count_headlines,
    IF(T.count_long_headlines >= 1,"Yes","X") AS count_long_headlines,
    IF(T.count_short_descriptions >= 1,"Yes","X") AS count_short_descriptions,
    IF(T.count_short_headlines >= 1,"Yes","X") AS count_short_headlines,
    IF(I.count_images >= 15,"Yes","X") AS count_images,
    IF(I.count_logos >= 5,"Yes","X") AS count_logos,
    IF(I.count_landscape >= 1,"Yes","X") AS count_landscape,
    IF(I.count_landscape_logos >= 1,"Yes","X") AS count_landscape_logos,
    IF(I.count_square >= 1,"Yes","X") AS count_square,
    IF(I.count_square_logos >= 1,"Yes","X") AS count_square_logos,
    V.video_score,
    T.text_score,
    I.image_score
FROM `{bq_dataset}.assetgroupsummary` AGS
JOIN video_data V USING (account_id,campaign_id,asset_group_id)
JOIN text_data T USING (account_id,campaign_id,asset_group_id)
JOIN image_data I USING (account_id,campaign_id,asset_group_id)