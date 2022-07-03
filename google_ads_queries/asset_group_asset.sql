SELECT
  asset_group.id AS asset_group_id,
  asset_group.name AS asset_group_name,
  asset_group.status AS asset_group_status,
  campaign.id AS campaign_id,
  asset.id AS asset_id,
  customer.id AS account_id,
  asset.type AS asset_type,
  asset_group_asset.field_type AS asset_sub_type
FROM asset_group_asset
WHERE campaign.advertising_channel_type = 'PERFORMANCE_MAX'