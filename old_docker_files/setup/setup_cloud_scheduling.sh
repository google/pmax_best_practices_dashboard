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

COLOR='\033[0;36m'
service_account_name="pmaxdash-ext-service"
service_account_email="$service_account_name@${GOOGLE_CLOUD_PROJECT}.iam.gserviceaccount.com"
topic_name="pmaxdash-schedules"
subscription="pmaxdash-trigger-sub"

echo -n -e "${COLOR}Creating Service Account..."

gcloud iam service-accounts create $service_account_name --display-name $service_account_name 
gcloud run services add-iam-policy-binding pmaxdash \
   --member=serviceAccount:$service_account_email \
   --role=roles/run.invoker \
   --region=${GOOGLE_CLOUD_REGION}
gcloud projects add-iam-policy-binding ${GOOGLE_CLOUD_PROJECT} \
     --member=serviceAccount:$service_account_email\
     --role=roles/iam.serviceAccountTokenCreator

echo -n -e "${COLOR}Creating PubSub scheduler..."

gcloud pubsub topics create $topic_name
gcloud scheduler jobs create pubsub daily-data-refresh --location=${GOOGLE_CLOUD_REGION} --schedule="0 4 * * *" --topic=$topic_name --attributes="TRIGGER=TRUE" --message-body="Triggering queries run" --time-zone="Israel"
# Configure the push subscription
gcloud pubsub subscriptions create $subscription \
 --topic=$topic_name \
 --ack-deadline=600 \
 --push-endpoint=${SERVICE_URL}/run-queries \
 --push-auth-service-account=$service_account_email \


echo -n -e "${COLOR}Extending service timeout limit..."
gcloud run services update pmaxdash --timeout=3600 --region=${GOOGLE_CLOUD_REGION}