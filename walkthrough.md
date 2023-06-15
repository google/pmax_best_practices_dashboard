# Deploying The Dashboard

## Introduction

In this walkthrough, you'll deploy and configure the pMAx Dashboard.

<walkthrough-tutorial-difficulty difficulty="3"></walkthrough-tutorial-difficulty>
<walkthrough-tutorial-duration duration="10"></walkthrough-tutorial-duration>

## Project setup

GCP organizes resources into projects. This allows you to
collect all of the related resources for a single application in one place.

Begin by creating a new project or selecting an existing project for this
dashboard.

<walkthrough-project-setup billing></walkthrough-project-setup>

For details, see
[Creating a project](https://cloud.google.com/resource-manager/docs/creating-managing-projects#creating_a_project).

## Configure OAuth consent screen

1.  Go to the **APIs & Services > OAuth consent screen** page in the Cloud
    Console. You can use the button below to find the section.

    <walkthrough-menu-navigation sectionId="API_SECTION;metropolis_api_consent"></walkthrough-menu-navigation>

1.  Choose **External** as the user type for your application.

    *   If you have an organization for your application, select **Internal**.
    *   If you don't have an organization configured for your application,
        select **External**.

1.  Click
    <walkthrough-spotlight-pointer cssSelector="button[type='submit']">**Create**</walkthrough-spotlight-pointer>
    to continue.

1.  Under *App information*, enter the **Application name** you want to display.
    You can copy the name below and enter it as the application name.

    ```
    gke_identity_aware_proxy
    ```

1.  For the **Support email** dropdown menu, select the email address you want
    to display as a public contact. This email address must be your email
    address, or a Google Group you own.
2.  Under **Developer contact information**, enter a valid email address.

Click
    <walkthrough-spotlight-pointer cssSelector=".cfc-stepper-step-continue-button">**Save
    and continue**</walkthrough-spotlight-pointer>.
    
## Creating OAuth credentials

1.  On the APIs & Services page, click the
    <walkthrough-spotlight-pointer cssSelector="#cfctest-section-nav-item-metropolis_api_credentials">**Credentials**</walkthrough-spotlight-pointer>
    tab.

1.  On the
    <walkthrough-spotlight-pointer cssSelector="[id$=action-bar-create-button]" validationPath="/apis/credentials">**Create
    credentials**</walkthrough-spotlight-pointer> drop-down list, select **OAuth
    client ID**.
1.  Under
    <walkthrough-spotlight-pointer cssSelector="[formcontrolname='typeControl']">**Application
    type**</walkthrough-spotlight-pointer>, select **Web application**.

1.  Add a
    <walkthrough-spotlight-pointer cssSelector="[formcontrolname='typeControl']">**Name**</walkthrough-spotlight-pointer>
    for your OAuth client ID.

1.  Click **Create**. Your OAuth client ID and client secret are generated and
    displayed on the OAuth client window. Do not close the screen yet.    

## Turn on Google Cloud APIs

Dataflow processes data in many GCP data stores and messaging services,
including BigQuery, Google Cloud Storage, and Cloud Pub/Sub. Enable the APIs for
these services to take advantage of Dataflow's data processing capabilities.

<walkthrough-enable-apis apis="networkmanagement.googleapis.com,bigquery">
</walkthrough-enable-apis>

## Change directory

```bash
cd pmax_dashboard --isn't needed
```

Edit yaml?
<walkthrough-editor-select-line filePath="google-ads.yaml"
                                startLine="11" startCharacterOffset="54"
                                endLine="12" endCharacterOffset="15">
google-ads.yaml
</walkthrough-editor-select-line>


```bash
rm -rf \~/.npm/
```

```bash
npm init gaarf-wf -- --answers=answers.json
```


## Conclusion

<walkthrough-conclusion-trophy></walkthrough-conclusion-trophy>

<walkthrough-inline-feedback></walkthrough-inline-feedback>
