CREATE OR REPLACE VIEW `{bq_project}.{bq_dataset}_bq.summary` AS
SELECT
  PARSE_DATE("%Y-%m-%d", CM.date) AS day,
  CM.account_id AS account_id,
  CM.campaign_id,
  CM.campaign_name,
  CM.campaign_status,
  CM.bidding_strategy,
  ROUND(CM.cost/1000000) AS cost,
  CM.impressions,
  CM.clicks,
  CM.conversions,
  CS.conversion_action_id
FROM `{bq_project}.{bq_dataset}.campaign_settings` AS CM
INNER JOIN {bq_project}.{bq_dataset}.conversion_split AS CS
  ON CM.account_id = CS.account_id;