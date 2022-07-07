CREATE OR REPLACE VIEW {bq_project}.{bq_dataset}.video_assets AS (
  SELECT
    account_id,
    campaign_id,
    asset_group_id,
    ad_strength,
    asset_id
  FROM {bq_project}.{bq_dataset}.asset_group_asset AS AGA
  WHERE AGA.asset_type = 'YOUTUBE_VIDEO'
)