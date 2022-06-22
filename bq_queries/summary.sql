CREATE OR REPLACE VIEW {bq_project}.{bq_dataset}.summary
AS
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
    PC.conversion_action
FROM segy-adsapi.pmax_draft2.campaign AS CM
INNER JOIN segy-adsapi.pmax_draft2.primary_conversion_action as PC
  ON CM.account_id = PC.account_id;