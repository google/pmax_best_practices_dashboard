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

CREATE OR REPLACE TABLE `{bq_dataset}_bq.campaign_data` AS
WITH
  TARGETS_RAW AS (
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
  TARGETS AS (
    SELECT
      account_id,
      campaign_id,
      ANY_VALUE(troas) AS troas,
      ANY_VALUE(tcpa) AS tcpa
    FROM TARGETS_RAW
    GROUP BY 1, 2
  ),
  ASSET_GROUPS_COUNT AS (
    SELECT
      COUNT(DISTINCT ASA.asset_group_id) AS number_of_asset_groups,
      ASA.campaign_id AS campaign_id
    FROM `{bq_dataset}.assetgroupasset` AS ASA
    GROUP BY campaign_id
  ),
  AUDIENCE_SIGNALS_COUNT AS (
    SELECT
      COUNT(DISTINCT AGS.asset_group_id) AS number_of_audience_signals,
      AGS.campaign_id AS campaign_id
    FROM `{bq_dataset}.assetgroupsignal` AS AGS
    GROUP BY
      campaign_id
  ),
  CAMPIAGN_SITELINKS_DATA AS (
    SELECT
      account_id,
      account_name,
      campaign_id,
      campaign_name,
      COUNT(*) AS campaign_sitelinks,
    FROM `{bq_dataset}.campaignasset`
    WHERE asset_type = 'SITELINK'
    GROUP BY 1, 2, 3, 4
  ),
  ACCOUNT_SITELINKS_DATA AS (
    SELECT
      account_id,
      account_name,
      COUNT(*) AS account_sitelinks,
    FROM `{bq_dataset}.customerasset`
    WHERE asset_type = 'SITELINK'
    GROUP BY 1, 2
  ),
  CAMPAIGN_CALLOUTS_DATA AS (
    SELECT
      campaign_id,
      COUNT(*) AS campaign_callouts
    FROM `{bq_dataset}.campaignasset`
    WHERE asset_type = 'CALLOUT'
    GROUP BY 1
  ),
  ACCOUNT_CALLOUTS_DATA AS (
    SELECT
      account_id,
      COUNT(*) AS account_callouts
    FROM `{bq_dataset}.customerasset`
    WHERE asset_type='CALLOUT'
    GROUP BY 1
  ),
  CAMPAIGN_STRUCTURED_SNIPPETS_DATA AS (
    SELECT
      campaign_id,
      COUNT(*) AS campaign_structsnippets
    FROM `{bq_dataset}.campaignasset`
    WHERE asset_type = 'STRUCTURED_SNIPPET'
    GROUP BY 1
  ),
  ACCOUNT_STRUCTURED_SNIPPETS_DATA AS (
    SELECT
      account_id,
      COUNT(*) AS account_structsnippets
    FROM `{bq_dataset}.customerasset`
    WHERE asset_type = 'STRUCTURED_SNIPPET'
    GROUP BY 1
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
  C.cost/1e6 AS cost,
  C.conversions,
  C.conversions_value,
  PCA.conversion_name AS pmax_conversion,
  PCAS.conversion_name AS primary_conversion_search,
  REGEXP_CONTAINS(ARRAY_TO_STRING(C.asset_automation_settings, ','), r'"asset_automation_type"\s*\:\s*"TEXT_ASSET_AUTOMATION"\s*,\s*"asset_automation_status"\s*\:\s*"OPTED_IN"') AS has_automatic_text_asset_automation,
  COUNT(IF(NC.type = 'KEYWORD' AND NC.negative, 1, null)) > 0 AS has_keyword_exclusions,
  COUNT(IF(NC.type = 'USER_LIST' AND NC.negative, 1, null)) > 0 AS has_users_exclusions,
  CLG.customer_acquisition_goal_settings_optimization_mode AS customer_acquisition_optimization_mode,
  C.negative_geo_target_type as negative_geo_target_type,
  C.positive_geo_target_type as positive_geo_target_type,
  IF (ASCC.number_of_audience_signals IS NOT NULL, ASCC.number_of_audience_signals, 0) AS number_of_audience_signals,
  AGC.number_of_asset_groups AS number_of_asset_groups,
  IF (C.negative_geo_target_type != 'PRESENCE_OR_INTEREST', "X", "Yes") as negative_geo_target_type_configured_good,
  IF (C.positive_geo_target_type != 'PRESENCE_OR_INTEREST', "X", "Yes") as positive_geo_target_type_configured_good,
  CASE
    WHEN (IF(SD.campaign_sitelinks IS NULL, 0, SD.campaign_sitelinks)
    + IF(ASD.account_sitelinks IS NULL, 0, ASD.account_sitelinks)) >= 4
      THEN 0
    ELSE 4 - (IF(SD.campaign_sitelinks IS NULL, 0, SD.campaign_sitelinks)
    + IF(ASD.account_sitelinks IS NULL, 0, ASD.account_sitelinks))
  END AS missing_sitelinks,
  CASE
     WHEN (IF(CD.campaign_callouts IS NULL, 0, CD.campaign_callouts)
     + IF(ACD.account_callouts IS NULL, 0, ACD.account_callouts)) >= 1
      THEN 0
    ELSE 1
  END AS missing_callouts,
  CASE
     WHEN (IF(SSD.campaign_structsnippets IS NULL, 0, SSD.campaign_structsnippets)
     + IF(ASSD.account_structsnippets IS NULL, 0, ASSD.account_structsnippets)) >= 1
      THEN 0
    ELSE 1
  END AS missing_structured_snippets,
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
  OCID.ocid
FROM `{bq_dataset}.campaign_settings` C
  LEFT JOIN TARGETS AS T
    ON C.account_id = T.account_id
    AND C.campaign_id = T.campaign_id
  LEFT JOIN `{bq_dataset}_bq.primary_conversion_action_search` AS PCAS
    ON C.account_id = PCAS.account_id
  LEFT JOIN `{bq_dataset}_bq.primary_conversion_action_pmax` AS PCA
    ON PCA.account_id = C.account_id
    AND PCA.campaign_id = C.campaign_id
    LEFT JOIN `{bq_dataset}.campaign_lifecycle_goals` AS CLG
    ON CLG.campaign = C.campaign_resource_name
  LEFT JOIN `{bq_dataset}.negative_criteria` AS NC
    ON NC.campaign_resource_name = C.campaign_resource_name
LEFT JOIN ASSET_GROUPS_COUNT AS AGC
    ON C.campaign_id = AGC.campaign_id
  LEFT JOIN AUDIENCE_SIGNALS_COUNT AS ASCC
    ON C.campaign_id = ASCC.campaign_id
  LEFT JOIN CAMPIAGN_SITELINKS_DATA AS SD
    ON C.campaign_id = SD.campaign_id
  LEFT JOIN ACCOUNT_SITELINKS_DATA AS ASD
    ON C.account_id = ASD.account_id
  LEFT JOIN CAMPAIGN_CALLOUTS_DATA AS CD
    ON C.campaign_id = CD.campaign_id
  LEFT JOIN ACCOUNT_CALLOUTS_DATA AS ACD
    ON C.account_id = ACD.account_id
  LEFT JOIN CAMPAIGN_STRUCTURED_SNIPPETS_DATA AS SSD
    ON C.campaign_id = SSD.campaign_id
  LEFT JOIN ACCOUNT_STRUCTURED_SNIPPETS_DATA AS ASSD
    ON C.account_id = ASSD.account_id
  LEFT JOIN `{bq_dataset}.ocid_mapping` AS OCID
    ON OCID.customer_id = C.account_id
GROUP BY ALL;
