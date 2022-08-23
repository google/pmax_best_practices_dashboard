CREATE OR REPLACE VIEW `{bq_project}.{bq_dataset}.video_assets` AS (
  WITH video_data AS(
    SELECT
      account_id,
      account_name
      campaign_id,
      campaign_name,
      asset_group_id,
      "Yes" as video_uploaded
    FROM `{bq_project}.{bq_dataset}.assetgroupasset` AS AGA
    WHERE AGA.asset_type = 'YOUTUBE_VIDEO'
  )
  SELECT
    AGS.account_id,
    AGS.account_name
    AGS.campaign_id,
    AGS.campaign_name,
    AGS.asset_group_id,
    AGS.ad_strength,
    COALESCE(VD.video_uploaded,"No") as is_video_uploaded
  FROM `{bq_project}.{bq_dataset}.assetgroupsummary` AS AGS
  LEFT JOIN video_data AS VD using (account_id,campaign_id,asset_group_id)
)

