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