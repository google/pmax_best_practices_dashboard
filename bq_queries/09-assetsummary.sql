CREATE OR REPLACE VIEW `{bq_project}.{bq_dataset}_bq.summaryassets` AS
SELECT
  AGA.account_id,
  AGA.account_name,
  AGA.asset_group_id,
  AGA.asset_group_name,
  AGA.campaign_name,
  AGA.campaign_id,
  AGA.asset_id,
  AGA.asset_sub_type,
  AGA.ad_strength,
  A.text_asset_text,
  COALESCE(A.image_url,CONCAT('https://www.youtube.com/watch?v=',A.video_id)) AS image_video,
  COALESCE(A.image_url,CONCAT('https://i.ytimg.com/vi/', CONCAT(A.video_id, '/hqdefault.jpg'))) AS image_video_url
FROM `{bq_project}.{bq_dataset}.assetgroupasset` AGA
JOIN `{bq_project}.{bq_dataset}.asset` A USING(account_id,asset_id)
WHERE ad_strength NOT IN ('PENDING','UNKNOWN')
GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12
ORDER BY ad_strength DESC