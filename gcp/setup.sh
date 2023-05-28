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

# This is step 1 in the setup of the pMax Best Practices Dashboard.
# Setup includes enabling necessary APIs and configuring a basic OAuth Consent Screen
COLOR='\033[0;36m' # Cyan
RED='\033[0;31m' # Red Color
NC='\033[0m' # No Color
PROJECT_ID=$(gcloud config get-value project 2> /dev/null)
PROJECT_TITLE='pMax Best Practices Dashboard'
USER_EMAIL=$(gcloud config get-value account 2> /dev/null)
PROJECT_NUMBER=$(gcloud projects describe $PROJECT_ID | grep projectNumber | sed "s/.* '//;s/'//g")
SERVICE_ACCOUNT=$PROJECT_ID@appspot.gserviceaccount.com

# check the billing
BILLING_ENABLED=$(gcloud beta billing projects describe $PROJECT_ID --format="csv(billingEnabled)" | tail -n 1)
if [[ "$BILLING_ENABLED" = 'False' ]]
then
  echo -e "${RED}The project $PROJECT_ID does not have a billing account linked. Please activate billing${NC}"
  exit
fi

echo -e "${COLOR}Enabling APIs...${NC}"
gcloud services enable iamcredentials.googleapis.com
gcloud services enable cloudresourcemanager.googleapis.com
gcloud services enable googleads.googleapis.com
gcloud services enable bigquery.googleapis.com
gcloud services enable iap.googleapis.com

# Grant GAE service account with the Service Account Token Creator role so it could create GCS signed urls
gcloud projects add-iam-policy-binding $PROJECT_ID --member=serviceAccount:$SERVICE_ACCOUNT --role=roles/iam.serviceAccountTokenCreator

echo -e "${COLOR}Creating oauth brand (consent screen)...${NC}"
gcloud iap oauth-brands create --application_title="$PROJECT_TITLE" --support_email=$USER_EMAIL