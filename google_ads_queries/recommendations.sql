SELECT 
	customer.id as account_id,
	campaign.id as campaign_id,
	recommendation.type as rec_type
FROM
	recommendation
WHERE
	campaign.advertising_channel_type = 'PERFORMANCE_MAX'
	AND recommendation.type in ('CAMPAIGN_BUDGET', 'FORECASTING_CAMPAIGN_BUDGET')
