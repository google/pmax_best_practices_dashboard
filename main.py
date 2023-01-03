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

import os
import subprocess
import yaml
import urllib.parse
from flask import Flask, request, redirect

_DATASOURCES_DICT = {
    "poor_assets": ("poor_assets_summary", "pMax Poor Assets Summary"),
    "asset_group_bp": ("assetgroupbestpractices", "pMax Asset Group Best Practices"),
    "campaign_setup": ("campaign_data", "pMax Campaign Setup"),
    "campaign_settings": ("campaign_settings", "pMax Campaign Settings and Scores"),
    "assets_performance": ("summaryassets", "pMax Assets Performance"),
    "asset_performance_snapshots": ("assetssnapshots_YYYYMMDD", "pMax Asset Performance Snapshots"),
    "scores": ("campaign_scores_union", "pMax Campaign Scores")
}

_REPORT_ID = "6e773f65-7612-45af-af37-e3cab6a9828b"
_REPORT_NAME = "pMax Best Practices Dashboard"
_DATASET_ID = "pmax_ads_test_bq"
_BASE_URL = "https://datastudio.google.com/reporting/create?"
_CONFIG_FILE_PATH = "./config.yaml"


app = Flask(__name__)

@app.route("/", methods=["GET"])
def home():
    """Create a Looker dashboard creation link with the Linking API, and return a button
    that redirects to it."""

    with open(_CONFIG_FILE_PATH, 'r') as f:
        config_data = yaml.load(f, Loader=yaml.FullLoader)
        gaarf_data = config_data.get('gaarf')
        bq_data = gaarf_data.get('bq')

    project_id = bq_data.get('project')

    dashboard_url = create_url(_REPORT_NAME, _REPORT_ID, project_id, _DATASET_ID, _DATASOURCES_DICT)
    return f"""<!DOCTYPE html>
                <html>
                    <head>
                        <title>pMax Best Practices Dashboard</title>
                    </head>
                    <p>Click on "Run Queries" to manually trigger the queries. </br>Click on "Create Dashboard" to create your private copy of pMax Best Practices dashboard.<p>
                    <body>
                        <button onclick="window.location.href='run-queries';alert('Running Queries')">
                            Run Queries
                        </button>
                    </body>
                    <body>
                        <button onclick="window.location.href='{dashboard_url}';">
                            Create Dashboard
                        </button>
                    </body>
                </html>"""


@app.route("/run-queries", methods=["POST", "GET"])
def run_queries():
    """Run the pMax Best Practices Dash queries and save results to BQ."""
    print("Request recieved. Running queries")
    try:
        subprocess.check_call(["./run-docker.sh", "google_ads_queries/*.sql", "bq_queries", "/google-ads.yaml"])
        return ("", 204)
    except Exception as e:
        print("Failed running queries", str(e))
        return ("Failed running queries", 400)



def create_url(report_name, report_id, project_id, dataset_id, _DATASOURCES_DICT):
    url = _BASE_URL
    url_safe_report_name = urllib.parse.quote(report_name)

    url += f"c.mode=edit&c.reportId={report_id}&r.reportName={url_safe_report_name}&ds.*.refreshFields=false&"

    for ds_num, ds_data in _DATASOURCES_DICT.items():
        url += create_datasource(project_id, dataset_id, ds_num, ds_data[0], ds_data[1])

    return url[:-1]  # remove last ""&""


def create_datasource(project_id, dataset_id, ds_num, table_id, datasource_name):
    url_safe_name = urllib.parse.quote(datasource_name)

    return (f'ds.{ds_num}.connector=bigQuery'
          f'&ds.{ds_num}.datasourceName={url_safe_name}'
          f'&ds.{ds_num}.projectId={project_id}'
          f'&ds.{ds_num}.type=TABLE'
          f'&ds.{ds_num}.datasetId={dataset_id}'
          f'&ds.{ds_num}.tableId={table_id}&')


if __name__ == "__main__":
    app.run(debug=True, host="127.0.0.1", port=int(os.environ.get("PORT", 8080)))
