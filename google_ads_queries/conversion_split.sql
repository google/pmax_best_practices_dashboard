SELECT
    segments.date AS date,
    campaign.id AS campaign_id,
    segments.conversion_action AS conversion_action,
    segments.conversion_action_name AS conversion_name,
    metrics.conversions AS conversions
    customer.id as account_id
    campaign.id AS campaign_id,
    segments.conversion_action AS conversion_action,
    segments.conversion_action_name AS conversion_name,
    metrics.conversions AS conversions,
    campaign.advertising_channel_type AS campaign_type
FROM ad_group_ad
WHERE
    segments.date >= "{start_date}"
    AND segments.date <= "{end_date}"
    AND campaign.advertising_channel_type IN ("PERFORMANCE_MAX", "SEARCH")