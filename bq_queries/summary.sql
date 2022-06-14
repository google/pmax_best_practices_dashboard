CREATE OR REPLACE VIEW {bq_project}.{bq_dataset}.summary
AS
SELECT
    PARSE_DATE("%Y-%m-%d", CM.date) AS day,
    CM.customer_id AS account_id,
    CM.campaign_id,
    CM.campaign_name,
    CM.status,
    CM.bidding_strategy,
    ROUND(CM.cost/1000000) AS cost,
    CM.impressions,
    CM.clicks,
    CM.conversions,
    CV.conversion_action,
    CV.conversion_type,
FROM segy-adsapi.pmax_draft2.campaign AS CM
INNER JOIN segy-adsapi.pmax_draft2.conversions as CV
  ON CM.customer_id = CV.account_id;