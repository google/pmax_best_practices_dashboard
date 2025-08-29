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

CREATE OR REPLACE TABLE `{bq_dataset}_bq.campaign_settings` AS
WITH
  TARGETS AS (
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
  ASSET_GROUP_BEST_PRACTICES AS (
    SELECT
      CAST(DATE(TIMESTAMP(CONCAT(SUBSTR(_TABLE_SUFFIX,0,4),'-',SUBSTR(_TABLE_SUFFIX,5,2),'-',SUBSTR(_TABLE_SUFFIX,7))))-1 AS STRING) AS date_,
      account_id,
      campaign_id,
      ROUND(AVG(video_score), 2) AS video_score,
      ROUND(AVG(text_score), 2) AS text_score,
      ROUND(AVG(image_score), 2) AS image_score
    FROM `{bq_dataset}_bq.assetgroupbpscore_*`
    GROUP BY 1, 2, 3
  ),
  CAMPAIGN_BEST_PRACTICES AS (
    SELECT
      CAST(DATE(TIMESTAMP(CONCAT(SUBSTR(_TABLE_SUFFIX,0,4),'-',SUBSTR(_TABLE_SUFFIX,5,2),'-',SUBSTR(_TABLE_SUFFIX,7))))-1 AS STRING) AS date_,
      account_id,
      campaign_id,
      campaign_bp_score
    FROM `{bq_dataset}_bq.campaignbpscore_*`
    GROUP BY 1, 2, 3, 4
  )
SELECT
    C.date,
    C.account_id,
    C.account_name,
    C.campaign_id,
    C.campaign_name,
    C.campaign_status,
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
    C.all_conversions_value,
    ABP.video_score,
    ABP.text_score,
    ABP.image_score,
    CBP.campaign_bp_score,
    OCID.ocid
FROM `{bq_dataset}.campaign_settings` AS C
LEFT JOIN TARGETS AS T
  USING(account_id, campaign_id, date)
LEFT JOIN ASSET_GROUP_BEST_PRACTICES AS ABP
  ON C.date = ABP.date_
  AND C.account_id = ABP.account_id
  AND C.campaign_id = ABP.campaign_id
LEFT JOIN CAMPAIGN_BEST_PRACTICES AS CBP
  ON C.date = CBP.date_
  AND C.account_id = CBP.account_id
  AND C.campaign_id = CBP.campaign_id
LEFT JOIN `{bq_dataset}.ocid_mapping` AS OCID
  ON OCID.customer_id = C.account_id;
