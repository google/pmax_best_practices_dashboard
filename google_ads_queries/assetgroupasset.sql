SELECT
  asset_group.id AS asset_group_id,
  asset_group.name AS asset_group_name,
  asset_group.status AS asset_group_status,
  campaign.id AS campaign_id,
  campaign.name AS campaign_name,
  asset.id AS asset_id,
  customer.id AS account_id,
  customer.descriptive_name AS account_name,
  asset.type AS asset_type,
  asset_group_asset.field_type AS asset_sub_type,
  asset_group_asset.performance_label as ad_strength
FROM asset_group_asset
WHERE campaign.advertising_channel_type = 'PERFORMANCE_MAX'
AND asset_group_asset.status = 'ENABLED'