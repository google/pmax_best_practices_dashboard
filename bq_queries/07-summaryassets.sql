CREATE OR REPLACE VIEW `{bq_project}.{bq_dataset}.summaryassets` AS
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
  A.image_url,
  A.video_id
FROM `pmaxdashapi.pmax.assetgroupasset` AGA
JOIN `pmaxdashapi.pmax.asset` A USING(account_id,asset_id)
WHERE ad_strength not in ('PENDING','UNKNOWN')
GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12
