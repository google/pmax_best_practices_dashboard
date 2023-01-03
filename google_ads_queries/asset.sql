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