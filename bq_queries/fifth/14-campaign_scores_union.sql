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

CREATE OR REPLACE VIEW `{bq_dataset}_bq.campaign_scores_union` AS
WITH 
score_types AS
(
  SELECT 'Video Score' AS score_type UNION ALL
  SELECT 'Image Score' UNION ALL
  SELECT 'Text Score' UNION ALL
  SELECT 'Campaign Best Practice Score'
),

scores_union AS 
(
  SELECT 
    `date`,
    campaign_name,
    video_score,
    image_score,
    text_score,
    campaign_bp_score,
    S.score_type AS score_type
  FROM `{bq_dataset}_bq.campaign_settings`
  CROSS JOIN score_types S
)

SELECT 
  `date`,
  campaign_name,
  score_type,
  CASE score_type
    WHEN "Video Score" THEN video_score
    WHEN "Image Score" THEN image_score
    WHEN "Text Score" THEN text_score
    WHEN "Campaign Best Practice Score" THEN campaign_bp_score
    ELSE NULL
  END AS score
FROM scores_union