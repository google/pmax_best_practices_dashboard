CREATE OR REPLACE VIEW {bq_project}.{bq_dataset}.image_assets
AS

WITH count_image_assets AS (
  SELECT
    account_id,
    campaign_id,
    asset_group_id,
    COUNT(*) AS count_images
  FROM
    {bq_project}.{bq_dataset}.asset_group_asset
  WHERE asset_type = 'IMAGE'
  GROUP BY 1, 2, 3
),
count_logos AS (
  SELECT 
    account_id,
    campaign_id,
    COUNT(*) AS count_logos
  FROM
    {bq_project}.{bq_dataset}.asset_group_asset
  WHERE asset_sub_type = 'LOGO'
  GROUP BY account_id, campaign_id
),
map_assets_account_campaign AS (
  SELECT
    AGA.account_id,
    AGA.campaign_id,
    AGA.asset_id,
    AGA.asset_group_id,
    A.image_width,
    A.image_height
  FROM {bq_project}.{bq_dataset}.asset_group_asset as AGA
  LEFT JOIN {bq_project}.{bq_dataset}.asset as A
      ON AGA.account_id = A.account_id
      AND AGA.asset_id = A.asset_id
),
count_rectangular_assets AS (
  SELECT
    account_id,
    campaign_id,
    asset_group_id,
    COUNT(*) AS count_rectangular
  FROM
    map_assets_account_campaign
  WHERE image_width = 600
    AND image_height = 300
  GROUP BY account_id, campaign_id, asset_group_id
),
count_square_300 AS (
  SELECT
    account_id,
    campaign_id,
    COUNT(*) AS count_square
  FROM map_assets_account_campaign
    WHERE image_width = image_height
      AND image_width = 300
  GROUP BY account_id, campaign_id
),
count_square_logos AS (
  SELECT
    AGA.account_id,
    AGA.campaign_id,
    COUNT(*) AS count_square_logos
  FROM {bq_project}.{bq_dataset}.asset AS A
  INNER JOIN {bq_project}.{bq_dataset}.asset_group_asset AS AGA
          ON AGA.asset_id = A.asset_id
    WHERE A.image_width = A.image_height
      AND A.image_width = 128
  GROUP BY account_id, campaign_id
),
count_rectangular_logos AS (
  SELECT
    account_id,
    campaign_id,
    COUNT(*) AS count_rectangular_logos
  FROM map_assets_account_campaign
    WHERE image_width = 1200
      AND image_height = 628
  GROUP BY account_id, campaign_id
)
SELECT 
  AGA.account_id,
  AGA.campaign_id,
  AGA.asset_group_id,
  AGA.ad_strength,
  CIA.count_images,
  CL.count_logos,
  CRA.count_rectangular,
  CSN.count_square,
  CSL.count_square_logos,
  CRL.count_rectangular_logos
FROM {bq_project}.{bq_dataset}.asset_group_asset AS AGA
LEFT JOIN count_image_assets AS CIA
          ON CIA.asset_group_id = AGA.asset_group_id
          AND CIA.campaign_id = AGA.campaign_id
LEFT JOIN count_logos AS CL
          ON CL.campaign_id = AGA.campaign_id
LEFT JOIN count_rectangular_assets AS CRA
          ON CRA.campaign_id = AGA.campaign_id
LEFT JOIN count_square_300 AS CSN
          ON CSN.campaign_id = AGA.campaign_id
LEFT JOIN count_square_logos AS CSL
          ON CSL.campaign_id = AGA.campaign_id
LEFT JOIN count_rectangular_logos AS CRL
          ON CRL.campaign_id = AGA.campaign_id
GROUP BY 1, 2, 3, 4, 5, 6, 7, 8, 9, 10