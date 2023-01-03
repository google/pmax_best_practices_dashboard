#!/bin/bash

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

echo "Setting Project ID: ${GOOGLE_CLOUD_PROJECT}"
gcloud config set project ${GOOGLE_CLOUD_PROJECT}

echo "Creating google-ads.yaml file..."
echo "
developer_token: ${DEVELOPER_TOKEN}
client_id: ${OAUTH_CLIENT_ID}
client_secret: ${OAUTH_CLIENT_SECRET}
refresh_token: ${REFRESH_TOKEN}
login_customer_id: ${MCC_ID}
client_customer_id: ${MCC_ID}
use_proto_plus: True
" >> google-ads.yaml

echo "Editing config.yaml file..."
sed -i 's/YOUR-BQ-PROJECT/'${GOOGLE_CLOUD_PROJECT}'/g' config.yaml
sed -i 's/MCC-ID/'${MCC_ID}'/g' config.yaml
sed -i 's/YOUR-REGION/'${GOOGLE_CLOUD_REGION}'/g' config.yaml
