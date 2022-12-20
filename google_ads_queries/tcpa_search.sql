SELECT
	segments.date AS date,
  customer.id as account_id,
	campaign.id as campaign_id,
	segments.conversion_action~0 AS conversion_action_id,
  segments.conversion_action_name AS conversion_name,
 	bidding_strategy.maximize_conversion_value.target_roas AS bidding_strategy_mcv_troas,
  bidding_strategy.target_roas.target_roas AS bidding_strategy_troas,
  bidding_strategy.maximize_conversions.target_cpa_micros AS bidding_strategy_mc_tcpa,
  bidding_strategy.target_cpa.target_cpa_micros AS bidding_strategy_tcpa,
  campaign.maximize_conversions.target_cpa_micros AS campaign_mc_tcpa,
  campaign.target_cpa.target_cpa_micros AS campaign_tcpa,
  campaign.maximize_conversion_value.target_roas AS campaign_mcv_troas,
  campaign.target_roas.target_roas AS campaign_troas
FROM
	campaign
WHERE
	campaign.advertising_channel_type = 'SEARCH'
  AND segments.date >= "{start_date}"
  AND segments.date <= "{end_date}"