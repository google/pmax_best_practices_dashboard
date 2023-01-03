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

FROM python:3.10
ADD requirements.txt .
RUN pip install --require-hashes -r requirements.txt
RUN pip install -e git+https://github.com/google/ads-api-report-fetcher.git#egg=google-ads-api-report-fetcher\&subdirectory=py
ADD google_ads_queries/ google_ads_queries/
ADD bq_queries/ bq_queries/
ADD scripts/ .
ADD google-ads.yaml .
ADD config.yaml .
ADD main.py .
RUN chmod a+x run-docker.sh
CMD exec gunicorn --bind :$PORT --workers 1 --threads 8 --timeout 0 main:app