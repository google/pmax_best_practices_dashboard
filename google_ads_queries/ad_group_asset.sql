SELECT
  asset.id AS asset_id,
  ad_group_asset.ad_group~0 AS ad_group_id,
  customer.id AS account_id,
  ad_group_asset.field_type AS asset_type
FROM
  ad_group_asset