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

CREATE OR REPLACE TABLE `{bq_dataset}_bq.summaryassets` AS (
  SELECT
    AGA.account_id,
    AGA.account_name,
    AGA.asset_group_id,
    AGA.asset_group_name,
    AGA.campaign_name,
    AGA.campaign_id,
    AGA.campaign_status,
    AGA.asset_id,
    AGA.asset_sub_type,
    AGA.asset_performance,
    AGA.text_asset_text,
    AGS.asset_group_status,
    COALESCE(AGA.image_url,CONCAT('https://www.youtube.com/watch?v=',AGA.video_id)) AS image_video,
    COALESCE(AGA.image_url,CONCAT('https://i.ytimg.com/vi/', CONCAT(AGA.video_id, '/hqdefault.jpg'))) AS image_video_url,
    OCID.ocid,
    CS.last_30_day_campaign_cost
  FROM `{bq_dataset}.assetgroupasset` AS AGA
  JOIN `{bq_dataset}.assetgroupsummary` AS AGS
    USING(asset_group_id)
  LEFT JOIN `{bq_dataset}.ocid_mapping` AS OCID
    ON OCID.customer_id = AGA.account_id
  LEFT JOIN (
    SELECT
      campaign_id,
      SUM(cost) AS last_30_day_campaign_cost
    FROM `{bq_dataset}.campaign_settings`
    WHERE PARSE_DATE('%Y-%m-%d', date) >= DATE_SUB(CURRENT_DATE(),  INTERVAL 30 DAY)
    GROUP BY campaign_id
      ) AS CS ON AGA.campaign_id = CS.campaign_id
  WHERE AGA.asset_performance NOT IN ('PENDING','UNKNOWN')
    AND AGA.campaign_id
      IN (SELECT campaign_id FROM `{bq_dataset}.campaign_settings`)
  GROUP BY ALL
);
