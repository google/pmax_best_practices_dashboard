CREATE OR REPLACE TABLE `{bq_project}.{bq_dataset}_bq.campaignbpscore_${format(today(),'yyyyMMdd')}` AS
SELECT
  date,
  account_id,
  account_name,
  campaign_id,
  campaign_name,
  round((if(url_expansion_opt_out=true,1,0)+if(audience_signals="Yes",1,0)+if(daily_budget_3target="Yes",1,0)+if(is_same_conversion="Yes",1,0)+if(is_same_target="Yes",1,0)+if(is_daily_budget_140usd="Yes",1,0))/6,2) AS campaign_bp_score,
FROM `{bq_project}.{bq_dataset}_bq.campaign_data`
GROUP BY 1,2,3,4,5,6