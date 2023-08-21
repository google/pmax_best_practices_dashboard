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

CREATE OR  REPLACE TABLE `{bq_dataset}_bq.shopping_gmc` 
AS (
    SELECT
      _PARTITIONDATE AS date,
      REGEXP_REPLACE(string(_PARTITIONDATE), '([0-9]{4})-([0-9]{2})-([0-9]{2})', '\\2/\\3/\\1') AS converted_date,
      ARRAY_REVERSE(SPLIT(product_id,':'))[SAFE_OFFSET(0)] AS product_id,
      REGEXP_REPLACE(link,r'\?.*','') AS product_url,
      title,
      image_link,
      item_group_id,
      google_product_category,
      google_product_category_path,
      product_type,
      custom_labels.label_0,
      custom_labels.label_1,
      custom_labels.label_2,
      custom_labels.label_3,
      custom_labels.label_4,
    FROM 
      `merchant_center_transfer.Products_*`
    GROUP BY 1,2,3,4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15
)
