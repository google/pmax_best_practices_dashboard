CREATE OR REPLACE VIEW `{bq_dataset}_bq.assetgroupbestpractices` AS
WITH video_data AS (
  SELECT
    account_id,
    account_name,
    campaign_id,
    campaign_name,
    asset_group_id,
    asset_group_name,
    ad_strength,
    is_video_uploaded,
    CAST(1 as FLOAT64) AS video_score
  FROM `{bq_dataset}_bq.video_assets`
),
text_data AS (
  SELECT
    account_id,
    account_name,
    campaign_id,
    campaign_name,
    asset_group_id,
    count_descriptions,
    count_headlines,
    count_long_headlines,
    count_short_descriptions,
    count_short_headlines,
    (IF(count_descriptions >= 5,1,0)+IF(count_headlines >= 5,1,0)+IF(count_long_headlines >= 1,1,0)+IF(count_short_descriptions >= 1,1,0)+IF(count_short_headlines >= 1,1,0))/5 AS text_score
  FROM `{bq_dataset}_bq.text_assets`
),
image_data AS (
  SELECT
    account_id,
    account_name,
    campaign_id,
    campaign_name,
    asset_group_id,
    count_images,
    count_logos,
    count_rectangular,
    count_rectangular_logos,
    count_square,
    count_square_logos,
    (IF(count_images >= 15,1,0)+IF(count_logos >= 5,1,0)+IF(count_rectangular >= 1,1,0)+IF(count_rectangular_logos >= 1,1,0)+IF(count_square >= 1,1,0)+IF(count_square_logos >= 1,1,0))/6 AS image_score
  FROM `{bq_dataset}_bq.image_assets`
)
SELECT
    V.account_id,
    V.account_name,
    V.campaign_id,
    V.campaign_name,
    V.asset_group_id,
    V.asset_group_name,
    V.ad_strength,
    is_video_uploaded,
    IF(count_descriptions >= 5,"Yes","X") AS count_descriptions,
    IF(count_headlines >= 5,"Yes","X") AS count_headlines,
    IF(count_long_headlines >= 1,"Yes","X") AS count_long_headlines,
    IF(count_short_descriptions >= 1,"Yes","X") AS count_short_descriptions,
    IF(count_short_headlines >= 1,"Yes","X") AS count_short_headlines,
    IF(count_images >= 15,"Yes","X") AS count_images,
    IF(count_logos >= 5,"Yes","X") AS count_logos,
    IF(count_rectangular >= 1,"Yes","X") AS count_rectangular,
    IF(count_rectangular_logos >= 1,"Yes","X") AS count_rectangular_logos,
    IF(count_square >= 1,"Yes","X") AS count_square,
    IF(count_square_logos >= 1,"Yes","X") AS count_square_logos,
    video_score,
    text_score,
    image_score
FROM video_data V
JOIN text_data T USING (account_id,campaign_id,asset_group_id)
JOIN image_data I USING (account_id,campaign_id,asset_group_id)
