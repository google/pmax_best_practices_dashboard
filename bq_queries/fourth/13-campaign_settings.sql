CREATE OR REPLACE VIEW `{bq_dataset}_bq.campaign_settings` AS
WITH targets AS (
    SELECT
      C.date,
      C.account_id,
      C.campaign_id,
      CASE 
        WHEN C.campaign_mcv_troas IS NOT NULL THEN C.campaign_mcv_troas
        WHEN C.campaign_troas IS NOT NULL THEN C.campaign_troas
        WHEN C.bidding_strategy_mcv_troas IS NOT NULL THEN C.bidding_strategy_mcv_troas
        WHEN C.bidding_strategy_troas IS NOT NULL THEN C.bidding_strategy_troas
      END AS troas,
    CASE
      WHEN C.campaign_mc_tcpa IS NOT NULL THEN C.campaign_mc_tcpa
      WHEN C.campaign_tcpa IS NOT NULL THEN C.campaign_tcpa
      WHEN C.bidding_strategy_mc_tcpa IS NOT NULL THEN C.bidding_strategy_mc_tcpa
      WHEN C.bidding_strategy_tcpa IS NOT NULL THEN C.bidding_strategy_tcpa
    END AS tcpa
    FROM `{bq_dataset}.campaign_settings` C
  ),
  assetgroupbestpractices AS (
    SELECT
        CAST(DATE(TIMESTAMP(CONCAT(SUBSTR(_TABLE_SUFFIX,0,4),'-',SUBSTR(_TABLE_SUFFIX,5,2),'-',SUBSTR(_TABLE_SUFFIX,7))))-1 AS STRING) AS date_,
        account_id,
        campaign_id,
        AVG(video_score) AS video_score,
        AVG(text_score) AS text_score,
        AVG(image_score) AS image_score,
    FROM `{bq_dataset}_bq.assetgroupbpscore_*`
    GROUP BY 1,2,3
),
campaignbestpractices AS (
    SELECT
        CAST(DATE(TIMESTAMP(CONCAT(SUBSTR(_TABLE_SUFFIX,0,4),'-',SUBSTR(_TABLE_SUFFIX,5,2),'-',SUBSTR(_TABLE_SUFFIX,7))))-1 AS STRING) AS date_,
        account_id,
        campaign_id,
        campaign_bp_score
    FROM `{bq_dataset}_bq.campaignbpscore_*`
    GROUP BY 1,2,3,4
)
SELECT
    C.date,
    C.account_id,
    C.account_name,
    C.campaign_id,
    C.campaign_name,
    C.campaign_status,
    C.url_expansion_opt_out,
    C.bidding_strategy,
    C.budget_amount,
    C.total_budget,
    C.budget_type,
    C.is_shared_budget,
    C.budget_period,
    T.troas,
    T.tcpa,
    C.gmc_id,
    C.optiscore,
    C.audience_signals,
    C.cost/1e6 AS cost,
    C.conversions,
    C.conversions_value,
    ABP.video_score,
    ABP.text_score,
    ABP.image_score,
    CBP.campaign_bp_score
FROM `{bq_dataset}.campaign_settings` C
LEFT JOIN targets T USING(account_id, campaign_id)
LEFT JOIN assetgroupbestpractices ABP 
  ON C.date = ABP.date_
  AND C.account_id = ABP.account_id
  AND C.campaign_id = ABP.campaign_id
LEFT JOIN campaignbestpractices CBP 
  ON C.date = CBP.date_
  AND C.account_id = CBP.account_id
  AND C.campaign_id = CBP.campaign_id