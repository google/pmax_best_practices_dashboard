# Creating pMax Best Practices Dashboard in DataStudio

Once data for pMax dashboard is generated and stored in BigQuery you can
proceed with replication which consists of two steps:

* Replication of datasources
* Replication of dashboard

## Replicate datasources

Before replicating the dashboard you need to make copies of datasources that power up the dashboard.
Replication of the datasources is important since they contains multiple calculated metrics which could be problematic to create from scratch.

Make a copy of each of the following 8 datasources used in the template dashboard.

* [Asset Group Best Practices](https://datastudio.google.com/c/u/0/datasources/8290179f-68d2-4972-b685-2c7251c6b165)
* [Assets Performance Snaphots](https://datastudio.google.com/c/u/0/datasources/10a9e9e6-c6a4-4246-b364-1c49ade8218c)
* [Campaign Data](https://datastudio.google.com/c/u/0/datasources/42405f6f-1630-4a3e-96b4-0e7672de5962)
* [Assets Data](https://datastudio.google.com/c/u/0/datasources/f72b4d31-2eae-4e05-87e9-bbe2d26c61fa)
* [Campaign Settings and Score Snapshots](https://datastudio.google.com/c/u/0/datasources/eba7624d-4900-464f-a7c1-7966f598caf2)


In order to replicate a datasource, please do the following:
* Click on the datasource link above.
* Click on *Make a copy of this datasource*

	![make_copy_datasource](src/make_copy_datasource.png)

* Confirm copying by clicking *Copy Data Source*

	![confirm](src/copy_confirm.png)

* Select *MY PROJECTS* and either pick a project or enter project id manually (this should be the project where PMax Dashboard tables are located)
* In Dataset select a BQ dataset where dActionBoard tables are located

	![setup project](src/setup_project.png)
* Select a table from the dataset which the name similar to Data Source name (i.e., if Data Source is called Campaign Settings And Scores look for the table which is called campaign_settings)

	![select table](src/select_table.png)

* Confirm copying by clicking *RECONNECT* button.

	![reconnect](src/reconnect.png)


> Don’t forget to rename the datasource so you can find it easily. I.e. such name as *Copy of Template PMax Dashboard Campaign Settings and Scores* is a bit mouthful, you can name it simply *PMax Campaign Settings or *YOUR-COMPANY-NAME PMax Campaign Settings*.

* Repeat the steps above for all the datasources.

Now that you’ve copied each of the datasources, make a copy of the dashboard and replace each of the template’s datasources with the corresponding datasource you copied.

## Replication of the dashboard

> Please ensure that ALL datasources are created before proceeding to replication of the dashboard.

You can access the template version of the dashboard [here](https://datastudio.google.com/c/u/0/reporting/8ce3b94b-2dfe-48a0-b022-a22287bf00ff/page/i5YsC/).

In order to replicate dashboard please do the following:

* make a [copy of the dashboard](https://support.google.com/datastudio/answer/7175478?hl=en#zippy=%2Cin-this-article) by clicking on *More options - Make a copy*.

	![copy dashboard](src/copy_dashboard.png)

* In *Copy this report* window map original datasources to the ones you created in the previous step.

	![datasource association](src/datasource_association.png)

Once all template datasources are replaced with new ones, click *Copy Report* and enjoy your new shiny PMax Dashboard!