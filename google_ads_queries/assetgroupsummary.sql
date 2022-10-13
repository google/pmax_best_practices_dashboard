SELECT
  asset_group.id AS asset_group_id,
  asset_group.name AS asset_group_name,
  asset_group.status AS asset_group_status,
  campaign.id AS campaign_id,
  campaign.name AS campaign_name,
  customer.id AS account_id,
  customer.descriptive_name AS account_name,
  asset_group.ad_strength as ad_strength
FROM asset_group
WHERE campaign.advertising_channel_type = 'PERFORMANCE_MAX'
AND asset_group.status = 'ENABLED'
