SELECT
    customer.id AS account_id,
    asset.name AS asset_name,
    asset.id AS asset_id,
    asset.image_asset.file_size AS image_file_size,
    asset.image_asset.full_size.url AS image_url,
    asset.text_asset.text AS text_asset_text,
    asset.image_asset.full_size.height_pixels AS image_height,
    asset.image_asset.full_size.width_pixels AS image_width,
    asset.youtube_video_asset.youtube_video_id AS video_id,
    asset.youtube_video_asset.youtube_video_title AS video_title,
    asset.type AS asset_type
FROM
    asset