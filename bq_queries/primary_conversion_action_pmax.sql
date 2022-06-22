CREATE OR REPLACE VIEW {bq_project}.{bq_dataset}.primary_conversion_action_pmax
AS (
  WITH convActionFreq AS (
     SELECT
        account_id,
        conversion_action,
        ROW_NUMBER() OVER (PARTITION BY account_id ORDER BY SUM(conversions) DESC ) as row_num
     FROM {bq_project}.{bq_dataset}.conversion_split
     WHERE campaign_type == "PERFORMANCE_MAX"
     GROUP BY account_id, conversion_action
  )
  SELECT
      account_id,
      conversion_action
  FROM convActionFreq
  WHERE row_num = 1
);