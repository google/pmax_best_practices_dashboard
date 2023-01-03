SELECT
    segments.date AS date,
    customer.id AS account_id,
    customer.descriptive_name AS account_name,
    campaign.id AS campaign_id,
    campaign.name AS campaign_name,
    campaign.status AS campaign_status,
    campaign.url_expansion_opt_out AS url_expansion_opt_out,
    campaign.bidding_strategy_type AS bidding_strategy,
    campaign_budget.amount_micros AS budget_amount,
    campaign_budget.total_amount_micros AS total_budget,
    campaign_budget.type AS budget_type,
    campaign_budget.explicitly_shared AS is_shared_budget,
    campaign_budget.period AS budget_period,
    bidding_strategy.maximize_conversion_value.target_roas AS bidding_strategy_mcv_troas,
    bidding_strategy.target_roas.target_roas AS bidding_strategy_troas,
    bidding_strategy.maximize_conversions.target_cpa_micros AS bidding_strategy_mc_tcpa,
    bidding_strategy.target_cpa.target_cpa_micros AS bidding_strategy_tcpa,
    campaign.maximize_conversions.target_cpa_micros AS campaign_mc_tcpa,
    campaign.target_cpa.target_cpa_micros AS campaign_tcpa,
    campaign.maximize_conversion_value.target_roas AS campaign_mcv_troas,
    campaign.target_roas.target_roas AS campaign_troas,
    campaign.selective_optimization.conversion_actions AS selective_optimization_conversion_actions,
    campaign.shopping_setting.merchant_id as gmc_id,
    campaign.optimization_score as optiscore,
    campaign.audience_setting.use_audience_grouped as audience_signals,
    metrics.cost_micros AS cost,
    metrics.conversions AS conversions,
    metrics.conversions_value AS conversions_value
FROM campaign
WHERE campaign.advertising_channel_type = "PERFORMANCE_MAX"
    AND segments.date >= "{start_date}"
    AND segments.date <= "{end_date}"