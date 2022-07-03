SELECT
    segments.date AS date,
    campaign.id AS campaign_id,
    segments.conversion_action~0 AS conversion_action_id,
    segments.conversion_action_name AS conversion_name,
    metrics.conversions AS conversions,
    customer.id as account_id,
    campaign.advertising_channel_type AS campaign_type
FROM ad_group_ad
WHERE
    segments.date >= "{start_date}"
    AND segments.date <= "{end_date}"
    AND campaign.advertising_channel_type IN ("PERFORMANCE_MAX", "SEARCH")