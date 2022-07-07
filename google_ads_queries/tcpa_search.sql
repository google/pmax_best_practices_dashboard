SELECT
	customer.id as account_id,
	campaign.id as campaign_id,
	segments.conversion_action~0 AS conversion_action_id,
  segments.conversion_action_name AS conversion_name,
  campaign.target_cpa.target_cpa_micros as target_cpa,
  campaign.maximize_conversions.target_cpa as max_conv_target_cpa
FROM
	campaign
WHERE
	campaign.advertising_channel_type = 'SEARCH'