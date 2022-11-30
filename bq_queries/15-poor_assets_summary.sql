CREATE OR REPLACE VIEW `{bq_dataset}_bq.poor_assets_summary` AS
    SELECT
        ABP.account_id,
        COUNT(distinct ABP.campaign_id) AS num_campaigns,
        COUNT(distinct ABP.asset_group_id) AS num_asset_groups
    FROM `{bq_dataset}_bq.assetgroupbestpractices` ABP
    WHERE ad_strength = 'POOR'
    GROUP BY 1