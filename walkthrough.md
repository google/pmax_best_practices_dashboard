# Deploying the pMaximizer

<walkthrough-metadata>
  <meta name="title" content="Deploying the pMaximizer" />
  <meta name="description" content="A step by step guide on configuring cloud and deploying the dashboard." />
</walkthrough-metadata>

## Introduction

In this walkthrough, you'll generate OAuth credentials in preparation for the deployment of pMaximizer.

<walkthrough-tutorial-difficulty difficulty="2"></walkthrough-tutorial-difficulty>
<walkthrough-tutorial-duration duration="20"></walkthrough-tutorial-duration>


## Google Cloud Project Setup

GCP organizes resources into projects. This allows you to
collect all of the related resources for a single application in one place.

Begin by creating a new project or selecting an existing project for this
dashboard.

<walkthrough-project-setup billing></walkthrough-project-setup>

For details, see
[Creating a project](https://cloud.google.com/resource-manager/docs/creating-managing-projects#creating_a_project).

### Enable Google Cloud APIs

Enable the Google Ads API and the BigQuery API so that they're incorporated in the credentials you will generate in the next step.

<walkthrough-enable-apis apis="bigquery.googleapis.com,googleads.googleapis.com">
</walkthrough-enable-apis>


## Switch Off Ephemeral Mode

First, let's switch off your shell's ephemeral mode.

Click <walkthrough-spotlight-pointer spotlightId="cloud-shell-more-button" target="cloudshell" title="Show me where">**More**</walkthrough-spotlight-pointer> and look for the `Ephemeral Mode` option. If it is turned on turn it off. This allows the dashboard code to persist across sessions.

## Authorize shell scripts commands

Copy the following command into the shell, press enter and follow the instructions:
```bash
cd
git clone https://github.com/google/pmax_best_practices_dashboard.git
cd pmax_best_practices_dashboard
gcloud auth login
```



## Configure OAuth Consent Screen

An authorization token is needed for the dashboard to communicate with Google Ads.

1.  Go to: 
<walkthrough-path-nav path="/auth/overview">**APIs & Services > OAuth Overview**</walkthrough-path-nav>

1.  Click on "Get started".

1. Under *App information*, enter the **Application name** you want to display.
   You can copy the name below and enter it as the application name.

   ```
   pMaximizer
   ```

1. For the **Support email** dropdown menu, select any email address that you have access to.

1.  In the Next section (Audience):

    *   If you have an organization for your application, select **Internal**.
    *   If you don't have an organization configured for your application,
        select **External**.

1. Under **Developer contact information**, enter a valid email address and continue to accept the Terms.

1. Click
   <walkthrough-spotlight-pointer cssSelector="button[type='submit']">**Create**</walkthrough-spotlight-pointer>
    to continue.

Click<walkthrough-spotlight-pointer cssSelector=".cfc-message-actions > a.cm-button[href^='/auth/clients/create']">**Create OAuth client**</walkthrough-spotlight-pointer>

## Creating OAuth Credentials

1. You should land in the following section:
<walkthrough-path-nav path="/auth/clients/create">**Clients**</walkthrough-path-nav>

1. Under
   <walkthrough-spotlight-pointer cssSelector="[formcontrolname='typeControl']">**Application
   type**</walkthrough-spotlight-pointer>, select **Web application**.

1. Add a
   <walkthrough-spotlight-pointer cssSelector="[formcontrolname='displayName']">**Name**</walkthrough-spotlight-pointer>
   for your OAuth client ID.

1. Click <walkthrough-spotlight-pointer locator="semantic({group 'Authorized redirect URIs'} {button 'Add URI'})">Authorized redirect URI</walkthrough-spotlight-pointer>
and copy the following:
   ```
   https://developers.google.com/oauthplayground
   ```

1. Click **Create**. Your OAuth client ID and client secret are generated and
   displayed on the OAuth client window.

1. Copy the **client_id** and **client_secret** as you will need those in a moment. (if you only see client_id, press OK and then find both id and secret after pressing the "edit" icon)

## Add Sensitive Scopes to Consent Screen

1. Go to: 
<walkthrough-path-nav path="auth/scopes">**Data Access**</walkthrough-path-nav>

1. Click <walkthrough-spotlight-pointer locator="semantic({button 'Add or remove scopes'})">Add or remove scopes</walkthrough-spotlight-pointer>
1. Now in <walkthrough-spotlight-pointer locator="semantic({combobox 'Filter'})">Enter property name or value</walkthrough-spotlight-pointer> search for the BigQuery API, check the box for the first option to choose it.
1. Do the same for Google Ads API.
1. Click <walkthrough-spotlight-pointer locator="text('Update')">Update</walkthrough-spotlight-pointer>


## Generate Refresh Token

1. Go to the [OAuth2 Playground](https://developers.google.com/oauthplayground/#step1&scopes=https%3A//www.googleapis.com/auth/adwords&url=https%3A//&content_type=application/json&http_method=GET&useDefaultOauthCred=checked&oauthEndpointSelect=Google&oauthAuthEndpointValue=https%3A//accounts.google.com/o/oauth2/v2/auth&oauthTokenEndpointValue=https%3A//oauth2.googleapis.com/token&includeCredentials=unchecked&accessTokenType=bearer&autoRefreshToken=unchecked&accessType=offline&forceAprovalPrompt=checked&response_type=code) (opens in a new window)
2. On the right-hand pane, paste the client_id and client_secret in the appropriate fields ![paste credentials](https://services.google.com/fh/files/misc/pplayground_fields.png)
3. Then on the left hand side of the screen, click the blue **Authorize APIs** button ![Authorize APIs](https://services.google.com/fh/files/misc/authorize_apis.png)

   If you are prompted to authorize access, please choose your Google account that has access to Google Ads and approve.
   
5. Now, click the new blue button **Exchange authorization code for tokens** ![Exchange authorization code for tokens](https://services.google.com/fh/files/misc/exchange_authorization_code_for_token.png)
6. Finally, in the middle of the screen you'll see your refresh token on the last line.  Copy it and save it for future reference.  ![refresh_token](https://services.google.com/fh/files/misc/refresh_token.png) *Do not copy the quotation marks*

## Join Google Group to access dashboard template

Use [this link](https://groups.google.com/g/pmax-dashboard-template-readers/) to access the group URL and click on "Join Group"

![join_group](https://services.google.com/fh/files/misc/join_group.png)

## Deploy Solution 

Run the following command and follow the steps:

Make sure to have your developer token, your MCC ID and Merchant Center Id(*) on hand, in addition to the rest of the credentials generated in the previous steps.

(*) if you would like to enhance your analysis for retail use cases.

When prompted, choose N to enter credentials one by one.

```bash
sh setup-wfs.sh
```


## Conclusion

Congratulations. You've set up the pMaximizer!

<walkthrough-conclusion-trophy></walkthrough-conclusion-trophy>

<walkthrough-inline-feedback></walkthrough-inline-feedback>
