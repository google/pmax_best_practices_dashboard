CREATE OR REPLACE VIEW `{bq_dataset}_bq.poor_assets_summary` AS
    SELECT
        account_id,
        COUNT(distinct campaign_id) AS num_campaigns,
        COUNT(distinct asset_group_id) AS num_asset_groups,
        COUNT(distinct asset_id) AS num_poor_assets
    FROM `{bq_dataset}_bq.assetgroupbestpractices` ABP
    WHERE ad_strength = 'POOR'
    GROUP BY 1