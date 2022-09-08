CREATE OR REPLACE VIEW `{bq_project}.{bq_dataset}_bq.primary_conversion_action_pmax`
AS (
  WITH convActionFreq AS (
     SELECT
        account_id,
        campaign_id,
        conversion_name,
        ROW_NUMBER() OVER (PARTITION BY account_id, campaign_id ORDER BY SUM(conversions) DESC ) AS row_num
     FROM `{bq_project}.{bq_dataset}.conversion_split`
     WHERE campaign_type = "PERFORMANCE_MAX"
     GROUP BY account_id, campaign_id, conversion_name
  )
  SELECT
    account_id,
    campaign_id, 
    conversion_name
  FROM convActionFreq
  WHERE row_num = 1
);
