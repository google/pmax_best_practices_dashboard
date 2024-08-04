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
set -e


until [[ "$yn" == [YyNn] ]]; do
    msg='Do you operate a retail business and wish to gain product insights with our retail-focused pMaximizer?'
    msg+=' Please respond with 'y' for yes or 'n' for no: '
    read -p "$msg" yn
done

if [[ "$yn" == "y"  || "$yn" == "Y" ]]; then
    source ./build-retail.sh
else
    echo "skipping Retail setup..."
fi

echo "initializing Google Ads data ETL Workflow..."
npm init gaarf-wf@latest -- --answers=answers.json
