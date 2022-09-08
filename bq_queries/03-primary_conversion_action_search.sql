CREATE OR REPLACE VIEW `{bq_project}.{bq_dataset}_bq.primary_conversion_action_search`
AS (
  WITH convActionFreq AS (
     SELECT
        account_id,
        conversion_action_id,
        ROW_NUMBER() OVER (PARTITION BY account_id ORDER BY SUM(conversions) DESC ) AS row_num
     FROM `{bq_project}.{bq_dataset}.conversion_split`
     WHERE campaign_type = "SEARCH"
     GROUP BY account_id, conversion_action_id
  )
  SELECT
    account_id,
    conversion_action_id
  FROM convActionFreq
  WHERE row_num = 1
);
