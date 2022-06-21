CREATE OR REPLACE TABLE {bq_project}.{bq_dataset}.account_campaign_metrics
AS (
SELECT
    C.day,
    C.account_id,
    C.campaign_id,
    C.campaign_name,
    AGA.asset_group_id,
    C.url_expansion_opt_out,
    C.bidding_strategy,
    C.budget_type,
    C.total_budget,
    C.budget_period,
    C.target_cpa,
    C.target_roas,
    C.rel_high_budget,
    C.high_budget,
    C.conversion_action,
    C.conversion_type,
    C.num_assets
    
FROM segy-adsapi.pmax_draft2.campaign_report AS C
INNER JOIN segy-adsapi.pmax_draft2.asset_group_asset AS AGA
  ON C.campaign_id = AGA.campaign_id

GROUP BY 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 12, 13, 14, 15, 16);