CREATE OR REPLACE VIEW `{bq_project}.{bq_dataset}_bq.campaign_settings` AS
WITH assetgroupbestpractices AS (
    SELECT
        CAST(DATE(TIMESTAMP(CONCAT(SUBSTR(_TABLE_SUFFIX,0,4),'-',SUBSTR(_TABLE_SUFFIX,5,2),'-',SUBSTR(_TABLE_SUFFIX,7))))-1 AS STRING) AS date,
        account_id,
        campaign_id,
        AVG(video_score) AS video_score,
        AVG(text_score) AS text_score,
        AVG(image_score) AS image_score,
    FROM `{bq_project}.{bq_dataset}_bq.assetgroupbpscore_*`
    GROUP BY 1,2,3
),
campaignbestpractices AS (
    SELECT
        CAST(DATE(TIMESTAMP(CONCAT(SUBSTR(_TABLE_SUFFIX,0,4),'-',SUBSTR(_TABLE_SUFFIX,5,2),'-',SUBSTR(_TABLE_SUFFIX,7))))-1 AS STRING) AS date,
        account_id,
        campaign_id,
        campaign_bp_score
    FROM `{bq_project}.{bq_dataset}_bq.campaignbpscore_*`
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
    C.target_cpa,
    C.target_roas,
    C.gmc_id,
    C.optiscore,
    C.audience_signals,
    C.max_conv_target_cpa,
    C.max_conv_value_target_roas,
    C.currency,
    C.cost/1e6 AS cost,
    C.impressions,
    C.conversions,
    C.clicks,
    C.conversions_value,
    video_score,
    text_score,
    image_score,
    campaign_bp_score
FROM `{bq_project}.{bq_dataset}.campaign_settings` C
LEFT JOIN assetgroupbestpractices ABP USING (date,account_id,campaign_id)
LEFT JOIN campaignbestpractices CBP USING (date,account_id,campaign_id)