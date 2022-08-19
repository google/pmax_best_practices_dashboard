CREATE OR REPLACE VIEW `{bq_project}.{bq_dataset}.video_assets` AS (
  SELECT
    account_id,
    campaign_id,
    account_name,
    campaign_name,
    asset_group_id,
    ad_strength,
    asset_id
  FROM `{bq_project}.{bq_dataset}.assetgroupasset` AS AGA
  WHERE AGA.asset_type = 'YOUTUBE_VIDEO'
)