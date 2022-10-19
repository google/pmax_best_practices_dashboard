# pMax Dashboard

## Problem Statement

Reporting for pMax campaigns is cumbersome and advertisers need a simple way to see an overview of their accounts and get a clear picture of the assets available for their pmax campaigns.

## Solution

The pMax Dashboard is a DataStudio dashboard providing an overview of your accounts' pmax campaigns' performance and the assets uploaded.  Feedback is provided as to whether the campaigns comply with the best practice guidelines for the number and type of assets uploaded.

## Deliverable (Implementation)

* DataStudio dashboard based on your Google Ads data.

## Deployment

### Prerequisites

* OAuth2 credentials for _desktop application_ (refer to [Generate OAuth2 credentials] (https://developers.google.com/google-ads/api/docs/client-libs/python/oauth-desktop))
* [Enable Google Ads API (https://developers.google.com/google-ads/api/docs/first-call/oauth-cloud-project#enable_the_in_your_project)]
* Developer token
* New GCP with Big Query

Access to the repository configured. In order to clone this repository you need to do the following:

* Visit https://professional-services.googlesource.com/new-password and login with your account
* Once authenticated please copy all lines in the box and paste them in the terminal.


### Installation

* Enter GCP Cloud Shell command-line
* Clone solution repository by entering the command:
git clone https://professional-services.googlesource.com/solutions/pmax_dashboard --depth=1
* Go to the directory of the solution : cd pmax_dashboard
* TODO: put google-ads.yaml into the same directory
* Launch the command: rm -rf \~/.npm/
* Launch the command : npm init gaarf-wf
* Follow the instructions

### Usage

Clone the Dashboard Template & DataSources as mentioned at https://professional-services.googlesource.com/solutions/pmax_dashboard/+/refs/heads/main/how-to-replicate-dashboard.md

## Disclaimer

** This is not an officially supported Google product.**

Copyright 2021 Google LLC. This solution, including any related sample code or data, is made available on an “as is,” “as available,” and “with all faults” basis, solely for illustrative purposes, and without warranty or representation of any kind. This solution is experimental, unsupported and provided solely for your convenience. Your use of it is subject to your agreements with Google, as applicable, and may constitute a beta feature as defined under those agreements. To the extent that you make any data available to Google in connection with your use of the solution, you represent and warrant that you have all necessary and appropriate rights, consents and permissions to permit Google to use and process that data. By using any portion of this solution, you acknowledge, assume and accept all risks, known and unknown, associated with its usage, including with respect to your deployment of any portion of this solution in your systems, or usage in connection with your business, if at all.

Contact: sareet@google.com, imosin@google.com
