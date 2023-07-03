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
    metrics.cost_micros AS cost,
    metrics.conversions AS conversions,
    metrics.conversions_value AS conversions_value,
    metrics.all_conversions_value AS all_conversions_value
FROM campaign
WHERE campaign.advertising_channel_type = "PERFORMANCE_MAX"
    AND segments.date >= "{start_date}"
    AND segments.date <= "{end_date}"