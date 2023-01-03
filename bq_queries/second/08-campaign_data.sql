CREATE OR REPLACE VIEW `{bq_dataset}_bq.campaign_data`
AS (
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

    FROM `{bq_project}.{bq_dataset}.campaign_settings` C
  ),
  search_targets AS (
    SELECT
      TS.date,
      TS.account_id,
      TS.campaign_id,
      CASE 
        WHEN TS.campaign_mcv_troas IS NOT NULL THEN TS.campaign_mcv_troas
        WHEN TS.campaign_troas IS NOT NULL THEN TS.campaign_troas
        WHEN TS.bidding_strategy_mcv_troas IS NOT NULL THEN TS.bidding_strategy_mcv_troas
        WHEN TS.bidding_strategy_troas IS NOT NULL THEN TS.bidding_strategy_troas
      END AS troas,
    CASE
      WHEN TS.campaign_mc_tcpa IS NOT NULL THEN TS.campaign_mc_tcpa
      WHEN TS.campaign_tcpa IS NOT NULL THEN TS.campaign_tcpa
      WHEN TS.bidding_strategy_mc_tcpa IS NOT NULL THEN TS.bidding_strategy_mc_tcpa
      WHEN TS.bidding_strategy_tcpa IS NOT NULL THEN TS.bidding_strategy_tcpa
    END AS tcpa
    FROM `{bq_project}.{bq_dataset}.tcpa_search` TS
  ),
  
  search_campaigns_freq AS (
    SELECT 
      account_id,
      APPROX_TOP_COUNT(conversion_name, 1)[SAFE_OFFSET(0)].value AS conversion_name
    FROM `{bq_project}.{bq_dataset}.tcpa_search`
    GROUP BY 1
  ),
  /*search_campaigns_most_freq AS (
    SELECT
      account_id,
      (SELECT value FROM SCF.most_freq) AS conversion_name
    FROM search_campaigns_freq AS SCF
    GROUP BY 1
  ),*/
  search_campaigns_avg_cpa AS (
    SELECT 
      account_id,
      AVG(tcpa) AS average_search_tcpa,
      AVG(troas) AS average_search_troas
    FROM
      search_targets
    GROUP BY 1
  ),
  search_campaign_data AS (
    SELECT
      S.account_id,
      F.conversion_name AS most_used_conversion_value,
      CPA.average_search_tcpa AS average_search_tcpa,
      CPA.average_search_troas AS average_search_troas
    FROM `{bq_project}.{bq_dataset}.tcpa_search` S
    JOIN search_campaigns_freq F
        ON S.account_id = F.account_id
        AND S.conversion_name = F.conversion_name
    JOIN search_campaigns_avg_cpa AS CPA
        ON S.account_id = CPA.account_id
   ) --,
  -- budget_constrained as (
  --   SELECT 
  --     account_id,
  --     campaign_id,
  --     "Yes", as budget_constrained
  --   FROM recommendations
  --  )
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
    IF(C.audience_signals=true,"Yes","X") AS audience_signals,
    C.cost/1e6 AS cost,
    C.conversions,
    C.conversions_value,
    --coalesce(BC.budget_constrained,"No") AS budget_constrained,
    CASE
      WHEN T.tcpa IS NOT NULL AND T.tcpa > 0
        THEN IF(C.budget_amount/1e6 > 3*T.tcpa,"Yes","X") 
      ELSE IF(C.budget_amount/1e6 > 3*T.troas,"Yes","X")
    END AS daily_budget_3target,
    IF(PCA.conversion_name = SCD.most_used_conversion_value,"Yes","X") AS is_same_conversion,
    CASE
      WHEN T.tcpa IS NOT NULL AND T.tcpa > 0
        THEN IF(T.tcpa = SCD.average_search_tcpa,"Yes","X") 
      ELSE IF (troas = SCD.average_search_troas, "Yes", "X")
    END AS is_same_target,
    CASE
      WHEN C.budget_amount/1e6 > 140 THEN "Yes"
      ELSE "X"
    END AS is_daily_budget_140usd
  FROM
    `{bq_project}.{bq_dataset}.campaign_settings` C
  LEFT JOIN targets AS T
    ON C.account_id = T.account_id
    AND C.campaign_id = T.campaign_id
  --LEFT JOIN budget_constrained BC
  --  ON C.account_id = BC.account_id
  --  AND C.campaign_id = BC.campaign_id
  LEFT JOIN search_campaign_data AS SCD
    ON C.account_id = SCD.account_id
  LEFT JOIN `{bq_project}.{bq_dataset}_bq.primary_conversion_action_pmax` AS PCA
    ON PCA.account_id = C.account_id
    AND PCA.campaign_id = C.campaign_id
)