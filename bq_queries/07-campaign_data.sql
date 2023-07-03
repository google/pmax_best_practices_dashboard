# Copyright 2022 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

CREATE OR REPLACE TABLE `{bq_dataset}_bq.campaign_data`
AS (
  WITH targets_raw AS (
    SELECT
      account_id,
      campaign_id,
      CASE 
        WHEN campaign_mcv_troas IS NOT NULL THEN campaign_mcv_troas
        WHEN campaign_troas IS NOT NULL THEN campaign_troas
        WHEN bidding_strategy_mcv_troas IS NOT NULL THEN bidding_strategy_mcv_troas
        WHEN bidding_strategy_troas IS NOT NULL THEN bidding_strategy_troas
      END AS troas,
    CASE
      WHEN campaign_mc_tcpa IS NOT NULL THEN campaign_mc_tcpa
      WHEN campaign_tcpa IS NOT NULL THEN campaign_tcpa
      WHEN bidding_strategy_mc_tcpa IS NOT NULL THEN bidding_strategy_mc_tcpa
      WHEN bidding_strategy_tcpa IS NOT NULL THEN bidding_strategy_tcpa
    END AS tcpa

    FROM `{bq_dataset}.campaign_settings` 
  ),
  targets AS (
    SELECT 
      account_id,
      campaign_id,
      ANY_VALUE(troas) AS troas,
      ANY_VALUE(tcpa) AS tcpa
    FROM targets_raw
    GROUP BY 1, 2
  ),
  search_targets AS (
    SELECT
      account_id,
      campaign_id,
      CASE 
        WHEN campaign_mcv_troas IS NOT NULL THEN campaign_mcv_troas
        WHEN campaign_troas IS NOT NULL THEN campaign_troas
        WHEN bidding_strategy_mcv_troas IS NOT NULL THEN bidding_strategy_mcv_troas
        WHEN bidding_strategy_troas IS NOT NULL THEN bidding_strategy_troas
        ELSE NULL
      END AS troas,
    CASE
      WHEN campaign_mc_tcpa IS NOT NULL THEN campaign_mc_tcpa
      WHEN campaign_tcpa IS NOT NULL THEN campaign_tcpa
      WHEN bidding_strategy_mc_tcpa IS NOT NULL THEN bidding_strategy_mc_tcpa
      WHEN bidding_strategy_tcpa IS NOT NULL THEN bidding_strategy_tcpa
      ELSE NULL
    END AS tcpa
    FROM `{bq_dataset}.tcpa_search`
  ),
  search_campaigns_freq AS (
    SELECT 
      account_id,
      APPROX_TOP_COUNT(conversion_name, 1)[SAFE_OFFSET(0)].value AS conversion_name
    FROM `{bq_dataset}.tcpa_search`
    GROUP BY 1
  ),
  search_campaigns_avg_cpa AS (
    SELECT 
      account_id,
      AVG(tcpa) AS average_search_tcpa,
      AVG(troas) AS average_search_troas
    FROM
      search_targets
    GROUP BY 1
  ),
  asset_groups_count AS (
    SELECT 
      COUNT(DISTINCT ASA.asset_group_id) AS number_of_asset_groups,
      ASA.campaign_id AS campaign_id
    FROM `{bq_dataset}.assetgroupasset` ASA
    GROUP BY campaign_id
  ),
  audience_signals_count AS (
    SELECT 
      COUNT(DISTINCT AGS.asset_group_id) AS number_of_audience_signals, 
      AGS.campaign_id AS campaign_id
    FROM `{bq_dataset}.assetgroupsignal` AGS
    GROUP BY 
      campaign_id,
      asset_group_id
  ),
  search_campaign_data AS (
    SELECT
      F.account_id,
      F.conversion_name AS primary_conversion_search,
      CPA.average_search_tcpa AS average_search_tcpa,
      CPA.average_search_troas AS average_search_troas
    FROM search_campaigns_freq F
    JOIN search_campaigns_avg_cpa AS CPA
        ON F.account_id = CPA.account_id
   ),
   sitelinks_data AS (
    SELECT
      CA.account_id,
      CA.account_name,
      CA.campaign_id,
      CA.campaign_name,
      COUNT(*) AS count_sitelinks
    FROM `{bq_dataset}.campaignasset` AS CA
    WHERE CA.asset_type='SITELINK'
    GROUP BY 1, 2, 3, 4
   )
    --,
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
    --IF(C.audience_signals=true,"Yes","X") AS audience_signals,
    C.cost/1e6 AS cost,
    C.conversions,
    C.conversions_value,
    --coalesce(BC.budget_constrained,"No") AS budget_constrained,
    PCA.conversion_name AS pmax_conversion,
    SCD.primary_conversion_search,
    CASE
      WHEN SD.count_sitelinks IS NOT NULL
        THEN IF (SD.count_sitelinks > 4, 0, 4 - SD.count_sitelinks) 
      ELSE 4
    END AS missing_sitelinks,
    CASE
      WHEN T.tcpa IS NOT NULL AND T.tcpa > 0
        THEN 'tCPA'
      WHEN T.troas IS NOT NULL AND T.troas > 0
        THEN 'tROAS'
      ELSE 'null'
    END AS target_type,
    CASE
      WHEN T.tcpa IS NOT NULL AND T.tcpa > 0
        THEN T.tcpa
      WHEN T.troas IS NOT NULL AND T.troas > 0
        THEN T.troas
      ELSE NULL
    END AS target_value,
    CASE
      WHEN ASCC.number_of_audience_signals IS NULL
        THEN 0
      ELSE (ASCC.number_of_audience_signals) / AGC.number_of_asset_groups
    END AS audience_signals_score,
    --CASE
    --  WHEN T.tcpa IS NOT NULL AND T.tcpa > 0
    --    THEN IF(T.tcpa = SCD.average_search_tcpa,"Yes","X") 
    --    ELSE IF(T.troas IS NOT NULL AND T.troas > 0, IF(troas = SCD.average_search_troas, "Yes", "X"),'null')
    --END AS is_same_target
  FROM
    `{bq_dataset}.campaign_settings` C
  LEFT JOIN targets AS T
    ON C.account_id = T.account_id
    AND C.campaign_id = T.campaign_id
  --LEFT JOIN budget_constrained BC
  --  ON C.account_id = BC.account_id
  --  AND C.campaign_id = BC.campaign_id
  LEFT JOIN search_campaign_data AS SCD
    ON C.account_id = SCD.account_id
  LEFT JOIN `{bq_dataset}_bq.primary_conversion_action_pmax` AS PCA
    ON PCA.account_id = C.account_id
    AND PCA.campaign_id = C.campaign_id
  LEFT JOIN asset_groups_count AS AGC
    ON C.campaign_id = AGC.campaign_id
  LEFT JOIN audience_signals_count AS ASCC
    ON C.campaign_id = ASCC.campaign_id
  LEFT JOIN sitelinks_data AS SD
    ON C.campaign_id = SD.campaign_id
)
