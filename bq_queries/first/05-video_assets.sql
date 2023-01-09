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

CREATE OR REPLACE TABLE `{bq_dataset}_bq.video_assets` AS (
  WITH video_data AS(
    SELECT
      account_id,
      account_name,
      campaign_id,
      campaign_name,
      asset_group_id,
      asset_group_name,
      "Yes" AS video_uploaded
    FROM `{bq_dataset}.assetgroupasset` AS AGA
    WHERE AGA.asset_type = 'YOUTUBE_VIDEO'
    GROUP BY 1,2,3,4,5,6,7
  )
  SELECT
    AGS.account_id,
    AGS.account_name,
    AGS.campaign_id,
    AGS.campaign_name,
    AGS.asset_group_id,
    AGS.asset_group_name,
    AGS.ad_strength,
    COALESCE(VD.video_uploaded,"X") AS is_video_uploaded
  FROM `{bq_dataset}.assetgroupsummary` AS AGS
  LEFT JOIN video_data AS VD USING (account_id,campaign_id,asset_group_id)
)
