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

echo "run-docker script triggered"
ads_queries=$1
bq_queries=$2
ads_yaml=$3
gaarf $ads_queries -c=/config.yaml --ads-config=$ads_yaml
gaarf-bq $bq_queries/first/*.sql -c=/config.yaml
gaarf-bq $bq_queries/second/*.sql -c=/config.yaml
gaarf-bq $bq_queries/third/*.sql -c=/config.yaml
gaarf-bq $bq_queries/fourth/*.sql -c=/config.yaml
gaarf-bq $bq_queries/fifth/*.sql -c=/config.yaml