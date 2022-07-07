CREATE OR REPLACE VIEW {bq_project}.{bq_dataset}.campaign_data
AS (
  WITH search_campaigns_freq AS (
    SELECT 
      account_id,
      approx_top_count(conversion_name, 1) AS most_freq
    FROM {bq_project}.{bq_dataset}.tcpa_search	
    GROUP BY 1
  ),
  search_campaigns_most_freq AS (
    SELECT
      account_id,
      (SELECT value FROM SCF.most_freq) AS conversion_name
    FROM search_campaigns_freq AS SCF
  ),
  search_campaigns_avg_cpa AS (
    SELECT 
      account_id,
      AVG(target_cpa) + AVG(max_conv_target_cpa) AS average_search_tcpa
    FROM
      {bq_project}.{bq_dataset}.tcpa_search
    GROUP BY 1
  ),
  search_campaign_data AS (
    SELECT
      S.account_id,
      F.conversion_name AS most_used_conversion_value,
      CPA.average_search_tcpa AS average_search_tcpa
    FROM {bq_project}.{bq_dataset}.tcpa_search S
    JOIN search_campaigns_most_freq F
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
  -- )
  SELECT
    C.date,
    C.account_id,
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
    C.target_cpa,
    C.target_roas,
    C.max_conv_target_cpa,
    C.currency,
    C.cost,
    C.impressions,
    C.conversions,
    C.clicks,
    --coalesce(BC.budget_constrained,"No") AS budget_constrained,
    if(C.budget_amount/1000000 > 3*c.target_cpa,"Yes","No") AS daily_budget_3tcpa,
    if(C.budget_amount/1000000 > 3*c.target_roas,"Yes","No") AS daily_budget_3troas,
    if(PCA.conversion_name = SCD.most_used_conversion_value,"Yes","No") AS is_same_conversion,
    if(C.target_cpa = SCD.average_search_tcpa,"Yes","No") AS is_same_tcpa
  FROM
    {bq_project}.{bq_dataset}.campaign C
  --LEFT JOIN budget_constrained BC
  --  ON C.account_id = BC.account_id
  --  AND C.campaign_id = BC.campaign_id
  LEFT JOIN search_campaign_data AS SCD
    ON C.account_id = SCD.account_id
  LEFT JOIN {bq_project}.{bq_dataset}.primary_conversion_action_pmax AS PCA
    ON PCA.account_id = C.account_id
    AND PCA.campaign_id = C.campaign_id
)