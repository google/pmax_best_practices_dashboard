CREATE OR REPLACE VIEW {bq_project}.{bq_dataset}.text_assets
AS
WITH count_headlines AS (
  SELECT
    account_id,
    campaign_id,
    asset_group_id,
    COUNT(*) AS count_headlines
  FROM {bq_project}.{bq_dataset}.asset_group_asset
  WHERE asset_sub_type IN ('HEADLINE', 'LONG_HEADLINE')
  GROUP BY 1, 2, 3
),
count_short_headlines AS (
  SELECT
    AGA.account_id,
    AGA.campaign_id,
    AGA.asset_group_id,
    COUNT(*) AS count_short_headlines
  FROM {bq_project}.{bq_dataset}.asset_group_asset AS AGA
  INNER JOIN {bq_project}.{bq_dataset}.asset AS A
          ON A.asset_id = AGA.asset_id
  WHERE AGA.asset_sub_type = 'HEADLINE'
      --AND LENGTH(A.text_asset_text) = 15
  GROUP BY 1, 2, 3
),
count_long_headlines AS (
  SELECT
    AGA.account_id,
    AGA.campaign_id,
    AGA.asset_group_id,
    COUNT(*) AS count_long_headlines
  FROM {bq_project}.{bq_dataset}.asset_group_asset AS AGA
  INNER JOIN {bq_project}.{bq_dataset}.asset AS A
          ON A.asset_id = AGA.asset_id
  WHERE AGA.asset_sub_type = 'LONG_HEADLINE'
      --AND LENGTH(A.text_asset_text) = 90
  GROUP BY 1, 2, 3
),
count_descriptions AS (
  SELECT
    AGA.account_id,
    AGA.campaign_id,
    AGA.asset_group_id,
    COUNT(*) AS count_descriptions
  FROM {bq_project}.{bq_dataset}.asset_group_asset AS AGA
  INNER JOIN {bq_project}.{bq_dataset}.asset AS A
          ON A.asset_id = AGA.asset_id
  WHERE AGA.asset_sub_type = 'DESCRIPTION'
  GROUP BY 1, 2, 3
),
count_short_descriptions AS (
  SELECT
    AGA.account_id,
    AGA.campaign_id,
    AGA.asset_group_id,
    COUNT(*) AS count_short_descriptions
  FROM {bq_project}.{bq_dataset}.asset_group_asset AS AGA
  INNER JOIN {bq_project}.{bq_dataset}.asset AS A
          ON A.asset_id = AGA.asset_id
  WHERE AGA.asset_sub_type = 'DESCRIPTION'
      AND LENGTH(A.text_asset_text) <= 60
  GROUP BY 1, 2, 3
)
SELECT
  AGA.account_id,
  AGA.campaign_id,
  AGA.asset_group_id,
  AGA.ad_strength,
  CH.count_headlines,
  CSH.count_short_headlines,
  CD.count_descriptions,
  CSD.count_short_descriptions,
  CLH.count_long_headlines
FROM {bq_project}.{bq_dataset}.asset_group_asset AS AGA
LEFT JOIN count_headlines AS CH
        ON CH.campaign_id = AGA.campaign_id
        AND CH.asset_group_id = AGA.asset_group_id
LEFT JOIN count_short_headlines AS CSH
        ON CSH.campaign_id = AGA.campaign_id
        AND CSH.asset_group_id = AGA.asset_group_id
LEFT JOIN count_descriptions AS CD
        ON CD.campaign_id = AGA.campaign_id
        AND CD.asset_group_id = AGA.asset_group_id
LEFT JOIN count_short_descriptions AS CSD
        ON CSD.campaign_id = AGA.campaign_id
        AND CSD.asset_group_id = AGA.asset_group_id
LEFT JOIN count_long_headlines AS CLH
        ON CLH.campaign_id = AGA.campaign_id
        AND CLH.asset_group_id = AGA.asset_group_id
GROUP BY 1, 2, 3, 4, 5, 6, 7, 8, 9