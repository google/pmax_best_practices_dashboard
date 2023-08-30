#!/bin/bash
#
# Copyright 2022 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# This is step 2 in the setup of the pMax Best Practices Dashboard (step 1 is client configuring OAuth Consent screen and generating OAuth credentials).
# Setup includes enabling necessary APIs and configuring a basic OAuth Consent Screen
COLOR='\033[0;36m' # Cyan
NC='\033[0m' # No Color

# PROJECT_ID=$(gcloud config get-value project 2> /dev/null)
# PROJECT_TITLE='pMax Best Practices Dashboard'
# PROJECT_NUMBER=$(gcloud projects describe $PROJECT_ID | grep projectNumber | sed "s/.* '//;s/'//g")

echo -e "${COLOR} Enter your Google Ads Developer Token"
read -r developer_token
#DEVELOPER_TOKEN = $developer_token

echo -e "${COLOR} Enter your OAuth 2.0 Client ID"
read -r client_id
# export OAUTH_CLIENT_ID=client_id

echo -e "${COLOR} Enter your OAuth 2.0 Client Secret"
read -r client_secret
# export OAUTH_CLIENT_SECRET=client_secret

echo -e "${COLOR} Enter the Refresh token created for this project"
read -r refresh_token
# export REFRESH_TOKEN=refresh_token

echo -e "${COLOR} Enter your Google Ads MCC account ID"
read -r mcc_id
# export MCC_ID=mcc_id

echo "${NC}Creating google-ads.yaml file..."

echo "
developer_token: $developer_token
client_id: $client_id
client_secret: $client_secret
refresh_token: $refresh_token
login_customer_id: $mcc_id
client_customer_id: $mcc_id
use_proto_plus: True
" >> google-ads.yaml

echo "Setting up infrastructure for pMax Best Practices Dashboard"

npm init gaarf-wf@latest -- --answers=answers.json