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
  customer.descriptive_name AS account_name,
  campaign.id AS campaign_id,
  customer.id AS account_id,
  customer_asset.asset AS asset,
  customer_asset.field_type AS asset_type,
  customer_asset.primary_status AS asset_primary_status,
  customer_asset.status AS asset_status,
FROM customer_asset
WHERE segments.date >= "{start_date}"
AND segments.date <= "{end_date}"