#!/bin/bash

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
