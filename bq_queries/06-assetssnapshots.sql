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

CREATE OR REPLACE TABLE `{bq_dataset}_bq.assetssnapshots_${format(yesterday(),'yyyyMMdd')}` AS (
SELECT
  CURRENT_DATE()-1 as day,
  AGA.account_id,
  AGA.account_name,
  AGA.asset_group_id,
  AGA.asset_group_name,
  AGA.campaign_name,
  AGA.campaign_id,
  AGA.asset_id,
  AGA.asset_sub_type,
  AGA.asset_performance,
  AGA.text_asset_text,
  COALESCE(AGA.image_url,CONCAT('https://www.youtube.com/watch?v=',AGA.video_id)) AS image_video,
  COALESCE(AGA.image_url,CONCAT('https://i.ytimg.com/vi/', CONCAT(AGA.video_id, '/hqdefault.jpg'))) AS image_video_url
FROM {bq_dataset}.assetgroupasset AGA
WHERE asset_performance NOT IN ('PENDING','UNKNOWN')
GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,13)
