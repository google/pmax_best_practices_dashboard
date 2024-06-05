# pMaximizer (Formally pMax Best Practices Dashboard)

In this README, you'll find:

- [Problem Statement](#problem-statement)
- [Solution](#solution)
- [Installation](#installation)
- [Prerequisites](#prerequisites)
- [Deliverable (Implementation)](#deliverable-implementation)
- [Architecture](#architecture)
- [Troubleshooting / Q&A](#troubleshooting)
- [Disclaimer](#disclaimer)

## Problem Statement

Reporting for pMax campaigns is cumbersome and advertisers need a simple way to see an overview of their accounts and get a clear picture of their assets's performance in their pmax campaigns.

## Solution

pMaximizer is a best practice dashboard that provides a centralized monitoring of the pMax campaigns' performance and the assets uploaded. Built in Looker Studio, It helps clearly identify if the campaigns and assets comply with the best practice guidelines and gives actionable insights to enhance asset groups' and feed quality.

Moreover, assets' performance is displayed and conveniently presented so advertisers can refresh poorly performing assets.

## Deliverable (Implementation)

A Looker Studio dashboard based on your Google Ads data. After joining the group below, [click here](https://lookerstudio.google.com/c/reporting/755d5896-5c56-4f5a-9075-79249137c9ea/page/i5YsC) to see it in action.

[![pMaximizer](https://services.google.com/fh/files/misc/pmaximizer-screenshots.png)](https://lookerstudio.google.com/c/reporting/755d5896-5c56-4f5a-9075-79249137c9ea/page/i5YsC)

- LookerStudio dashboard based on your Google Ads data.

## Prerequisites

1. Join [this group](https://groups.google.com/g/pmax-dashboard-template-readers/)

1. Obtain a Developer token

   a. This can be found in [Google Ads](ads.google.com) on the MCC level

   b. Go to Tools & Settings > Setup > API Center. If you do not see a developer token there, please complete the details and request one.

   c. By default, your access level is 'Test Account'; please apply for 'Basic access' if you don't have it. Follow [these instructions](https://developers.google.com/google-ads/api/docs/access-levels)

1. Create a new Google Cloud Project on the [Google Cloud Console](https://console.cloud.google.com/), **make sure it is connected to a billing account**

### Installation

Click [this link](https://console.cloud.google.com/?cloudshell=true&cloudshell_git_repo=https://github.com/google/pmax_best_practices_dashboard&cloudshell_tutorial=walkthrough.md) to be redirected to a step-by-step Google Cloud tutorial on deploying pMaximizer.

### Update to the newest version

To update the code and produce a new updated dashboard link, follow these steps. (If you wish to keep the same dashboard as you previously produced, you can, but in that case, only backend updates will be implemented.)

1. Enter the [Google Cloud Platform (GCP)](https://console.cloud.google.com/).
2. Make sure you’re in the project where you deployed the pMaximizer.
3. Activate the Cloud Shell by clicking on the "Activate Cloud Shell" icon on the upper right side of the screen: ![Activate Cloud Shell”](https://services.google.com/fh/files/misc/pmaximizer-impl-img5.png)
4. Execute (copy to the Cloud Shell and press Enter) the following commands in your Cloud Shell:

```
cd pmax_best_practices_dashboard
```

```
git pull
```

```
sh upgrade_pmaximizer.sh
```

Follow the link at the end of the deployment process to see access the upgraded dashboard, or use your previous link if you wish to only update the backend of the dashboard.

## Architecture

### What happens during installation

![What happens during installation](https://services.google.com/fh/files/misc/pmaximizer-arch-1.png)

### What Google Cloud components are deployed automatically

![What Google Cloud components are deployed automatically](https://services.google.com/fh/files/misc/pmaximizer-arch-2.png)

### In depth: Gaarf → Storage

![In depth: Gaarf → Storage](https://services.google.com/fh/files/misc/pmaximizer-arch-3.png)

### In depth: Gaarf → Scheduler + Workflow

![In depth: Gaarf → Scheduler + Workflow](https://services.google.com/fh/files/misc/pmaximizer-arch-4.png)

### In depth: Gaarf → Run

![In depth: Gaarf → Run](https://services.google.com/fh/files/misc/pmaximizer-arch-5.png)

### In depth: Gaarf → BigQuery

![In depth: Gaarf → BigQuery](https://services.google.com/fh/files/misc/pmaximizer-arch-6.png)

### What happens daily post installation

![What happens daily post installation](https://services.google.com/fh/files/misc/pmaximizer-arch-7.png)

## Troubleshooting

### What technical skills do I need to deploy the dashboard?

You do not need any technical skills to deploy the dashboard as it’s fully driven by clicks and “copy and paste” commands. However, you do need the Owner level permission in the Google Cloud project you’re deploying it to.

### What Google Cloud components will be added to my project?

- Storage
- Scheduler
- Workflows
- Run
- BigQuery (Datasets and Data Transfer)

### The deployment was not successful, what do I do?

If the deployment was unsuccessful please follow these steps to try and troubleshoot:

1. Check that all credentials in the google-ads.yaml are correct:
   - In The Google Cloud Platform, under the project you deployed the pMax Dashboard too, Click the “Activate Cloud Shell” icon: ![“Activate Cloud Shell](https://services.google.com/fh/files/misc/pmaximizer-impl-img1.png)
   - Click the “Open Editor” icon: ![Open Editor](https://services.google.com/fh/files/misc/pmaximizer-impl-img2.png)
   - In the File System, find the pmax_best_practices directory.
   - In the pmax_best_practices directory, find the google-ads.yaml file and click on it.
   - Review the credentials in the google-ads.yaml file. Make sure that they are correct, and that there are no quotation marks before any credential.
   - Check that the login_customer_id is all digits, with no dashes (i.e: 123456789 and not 123-456-789)
   - If you find a mistake, edit it in place and be sure to save, and follow the next steps. If not, please refer to “How do I see logs from my deployment?” in the next section.
   - Click the “Open Terminal” icon: ![Open Terminal](https://services.google.com/fh/files/misc/pmaximizer-impl-img3.png)
   - In the Cloud shell, copy and paste the green code, and press the Enter key when specified:
     - `cd pmax_best_practices_dashboard` Press Enter
     - `sh upgrade_pmaximizer.sh` Press Enter
   - After the run finishes (may take 15-30 minutes) Check the dashboard URL to see if the deployment succeeded. (you can see instructions on how to find the dashboard URL in this document).

### How do I see the logs from my deployment?

- In the Google Cloud Platform, under the project you deployed the pMax Dashboard too, click on the “Search” bar in the central upper part of the screen
- Type “Logs Explorer” in the search bar and click on the following:
  ![Logs Explorer](https://services.google.com/fh/files/misc/pmaximizer-impl-img4.png)

### I lost the dashboard URL in the process, how can I access or find it?

You can find the dashboard_url.txt file in the folder of the cloned repository or in your GCS bucket. Please see these instructions on how to access the URL through the cloud shell:

- In The Google Cloud Platform, under the project you deployed too, Click the “Activate Cloud Shell” icon: ![Activate Cloud Shell”](https://services.google.com/fh/files/misc/pmaximizer-impl-img5.png)
- In the Cloud shell, copy and paste the green code, and press the Enter key when specified:
  - Non-Retailers:
    - `cd pmax_best_practices_dashboard` Press Enter
    - `cat dashboard_url.txt` Press Enter
  - Retailers:
    - `cd pmax_best_practices_dashboard/work_retail` Press Enter
    - `cat dashboard_url.txt` Press Enter

The dashboard URL should then appear in the Shell.

### What access level does my access token must have?

Your Access Token has to have "Basic Access" or "Standard". Level "Test Account" will not work:

![Access Token Level](https://services.google.com/fh/files/misc/pmaximizer-impl-img6.png)

### How Do I save and share the Finished Dashboard with teammates?

After clicking the dashboard URL for the first time, you will see the LookerStudio dashboard. In order to save and share it you need to follow these steps:

- On the upper right side of the screen, click "Save and Share"
- Review the Credentials permissions of the different data sources. If you would like to give other colleagues permission to view all parts of the dashboard, even if they don’t have permissions to the Google Cloud Project it was created in, you need to change the credentials to Owner’s.
- To change the credentials to Owner’s, you need to click Edit on the very most right column:

![Edit Views / Owner Credentials](https://services.google.com/fh/files/misc/pmaximizer-impl-img7.png)

- Click on Data Credentials:

![Owner Credentials](https://services.google.com/fh/files/misc/pmaximizer-impl-img8.png)

- Choose Owner’s credentials, and then Update:

![Owner Credentials](https://services.google.com/fh/files/misc/pmaximizer-impl-img9.png)

- Click Done on the upper right.
- Do this for all data sources in the Dashboard.
- Click “Save and Share” again, and “Acknowledge and save”
- Click “Add to Report”.
- On the upper right, Click Share: ![Share Dashboard](https://services.google.com/fh/files/misc/pmaximizer-impl-img10.png) to share with teammates.

### How much does it cost?
It heavily depends on how much data you have and how often it's used. If you check the Architecture of Components section, there are 5 cloud components: Run, Scheduler, Workflows, Storage and BigQuery. For a large amount of data (e.g. thousands of accounts, campaigns and products), we do not expect more than 10-15 USD/month in Google Cloud, mainly driven by Big Query.

### How do I edit the dashboard?

Please find this Looker Studio [tutorial](https://support.google.com/looker-studio/answer/9171315?hl=en).

### What Oauth credential user type should I choose? Internal or external?

If you’re a google workspace user: Internal
If you’re not a google-workspace user: External. You should be ok to use it in "Test mode" instead of requesting your app to be approved by Google.

### How do I modify the results I get the dates of the data being pulled / how do I modify the hour the data is getting pulled?

You can modify the answers.json file. In the GCP, open the cloud shell.

### Can I create a dashboard on paused pMax campaigns that we ran in the past?

Yes! You can just change the ads_macro.start_date in answers.json file (shown above) while deploying to a value that covers the dates where the campaigns were active. By default it sets start_date to 90 days ago.

### Can I deploy it in an existing Cloud Project or do I need to create a new one just for this dashboard?

You can use an existing Project if you want to. However, please remember that the best practice for clients is to create a new project dedicated to this solution (or any new solution).

### Which GAQL queries are executed?

Please refer to the folder google_ads_queries.

### Can I create a dashboard on paused pMax campaigns that we ran in the past?

Yes! You can just change the ads_macro.start_date in answers.json file while deploying
to a value that covers the dates where the campaigns were active. By default it sets start_date to 90 days ago.

### Can I deploy it in an existing Cloud Project or do I need to create a new one just for this dashboard?

You can use an existing Project if you want to. However, please remember that the best practice for clients is to create a new project dedicated to this solution (or any new solution).

### How can I modify the dashboard from a non-retail version to a retail version?

1. Enter the [Google Cloud Platform (GCP)](https://console.cloud.google.com/).
2. Make sure you’re in the project you deployed the pMaximizer to.
3. Activate the Cloud Shell by clicking on the "Activate Cloud Shell" icon on the upper right side of the screen: ![Activate Cloud Shell”](https://services.google.com/fh/files/misc/pmaximizer-impl-img5.png)
4. Execute (copy to the cloud shell and press enter) the following commands in your Cloud Shell:

```
cd pmax_best_practices_dashboard
```

```
git pull
```

```
sh non_retail_to_retail_upgrade.sh
```

Follow the link at the end of the deployment process to access your new retail pMaximizer.

### After finishing an upgrade, some tables are missing, and when looking at the table properties I see an "Invalid dimension" error for two or three of the top columns (see screenshot):

![column link error](https://services.google.com/fh/files/misc/ocid_bug.png)

This could be caused by newly introduced columns that allow deep linking into the respective accounts, campaigns, or asset groups. If you do not want deep linking, you can simply replace the broken (red) columns of your tables with account_name, campaign_name, and asset_group_name respectively.

## If you do want the deep linking feature, see full instructions on how to fix the issue in [this document](https://docs.google.com/document/d/1bXSV6Et0xMD6XfS3y10qpdsbivrM_Y5-o71LMK8sbTI/edit?resourcekey=0-9MSOa9d1tYpWMnh2Zmr4Tg&tab=t.0) (you need to be part of the [Google group](https://groups.google.com/g/pmax-dashboard-template-readers/) to access the document).

**If you can’t find an answer for your question/a solution to your problem here, please reach out to pmax_bpdash@google.com.**

## Disclaimer

** This is not an officially supported Google product.**

Copyright 2021 Google LLC. This solution, including any related sample code or data, is made available on an “as is,” “as available,” and “with all faults” basis, solely for illustrative purposes, and without warranty or representation of any kind. This solution is experimental, unsupported and provided solely for your convenience. Your use of it is subject to your agreements with Google, as applicable, and may constitute a beta feature as defined under those agreements. To the extent that you make any data available to Google in connection with your use of the solution, you represent and warrant that you have all necessary and appropriate rights, consents and permissions to permit Google to use and process that data. By using any portion of this solution, you acknowledge, assume and accept all risks, known and unknown, associated with its usage, including with respect to your deployment of any portion of this solution in your systems, or usage in connection with your business, if at all.
