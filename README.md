![logo](https://vldbsolutions.com/img/VLDB-logo.png)

### Introduction

**VLDB Solutions** are an independent data consultancy based in the UK. We provide expert [Professional Services](https://vldbsolutions.com/services/services.php) to clients and companies across all sectors of business, from finance and leisure, to retail and telecommunications. Our hard-earned, industry-recognised knowledge, accrued over decades of working on data projects, enables us to provide the solution to any [Big Data](https://vldbsolutions.com/glossary.php#bigdata) problem.

Our main area of expertise is high-end, [Massively Parallel Processing (MPP)](https://vldbsolutions.com/glossary.php#mpp) database platforms, especially [Teradata](https://vldbsolutions.com/technology/teradata.php), [Pivotal Greenplum](https://vldbsolutions.com/technology/greenplum.php), [Amazon Redshift](https://vldbsolutions.com/technology/amazon-redshift.php) and Netezza.

![logo](https://vldbsolutions.com/img/VLDB-DBSee.png)

The team at VLDB have been developing Teradata best practice beliefs since 1989.

DBSee represents the Teradata best practice beliefs that can be checked for programmatically. DBSee consists of a set of SQL scripts developed by VLDB that run against the Teradata data dictionary. Each script can be used to inform a user of the current state of their Teradata system.

### What Does DBSee Check?

DBSee rules cover the following areas:

* permanent space
* data distribution
* indexes
* partitions
* statistics
* compression
* table properties

In all cases, DBSee rules look for opportunities to improve how Teradata is used to align with best practices.

### DBSee Benefits

The key DBSee deliverable is a set of results displayed within your native database client tool, or output as a csv file and imported into Tableau for easy-to-understand visualisations.

There are two possible outcomes from DBSee:

* no best practice violations detected
* evidence-based best practice violations detected

We have yet to find a Teradata system that doesn't fail nearly **all** of the DBSee best practice checks.

The great news is that all best practice violations can be fixed relatively easily. The first step is to uncover them with DBSee.

Fixing best practice violations typically delivers some or all of the following benefits:

* reduced CPU demand
* reduced IO demand
* increase in free space
* reduced query elapse times
* improved best practice knowledge
* smaller ETL batch window

When taken together, best practice improvements can often extend the life of your Teradata system.

![logo](https://vldbsolutions.com/img/VLDB-DBSee-Tables.png)

### Running DBSee

There are a couple of ways in which DBSee can be run against a Teradata system:

* run code via an sql client 
* run as bteq via the command line 

DBSee does **not** access any data held in Teradata outside of the data dictionary (DBC). DBSee does not require any privileges apart from select access to DBC.

The DBSee scripts take between a few seconds to a few minutes each to execute, even against a busy system. 

[**dbsee_permspace.sql ▸**](https://github.com/VLDB-Solutions/DBSEE/blob/master/dbsee_permspace.sql) available space within each database

A general rule is to keep the overall percent used below 70-75%; typically this ensures that there is enough free space. This also shows the overall space and where it's allocated within the system. 

[**dbsee_tablefallback.sql ▸**](https://github.com/VLDB-Solutions/DBSEE/blob/master/dbsee_tablefallback.sql) tables with fallback enabled

This is a check to find any fallback enabled tables; these tables can potentially delay updates. The backup of data is preferred over a fallback, as fallback enabled tables take up extra database space and can cause issues with failed inserts and updates.

[**dbsee_tableindexstats.sql ▸**](https://github.com/VLDB-Solutions/DBSEE/blob/master/dbsee_tableindexstats.sql) tables with missing or old index statistics

Statistics should always be relevant and collected frequently, especially when the table has volatile data. The query optimiser depends on statistics to ensure the most efficient join plans are generated. 

[**dbsee_tablemaxpi.sql ▸**](https://github.com/VLDB-Solutions/DBSEE/blob/master/dbsee_tablemaxpi.sql) tables with 5 or more primary index (PI) columns

Generally, the smallest number of indexes should be used to get a well distributed table. Also, when there is a large number of primary index (PI) columns in a table, the table may not be counted if these columns aren't all used in a join.

[**dbsee_tablemultiset.sql ▸**](https://github.com/VLDB-Solutions/DBSEE/blob/master/dbsee_tablemultiset.sql) multiset tables

Multiset tables allow duplicate rows. These tables are acceptable to use, but only if duplicates are either allowed (which is rare), or guaranteed not to exist. In this case, the faster insert times are preferred over set tables.

[**dbsee_tablenopi.sql ▸**](https://github.com/VLDB-Solutions/DBSEE/blob/master/dbsee_tablenopi.sql) NOPI tables

If these tables are not there by design, then there is a good chance that joins will be inefficient since the data is not distributed by a primary index (PI). 

[**dbsee_tablenullablepi.sql ▸**](https://github.com/VLDB-Solutions/DBSEE/blob/master/dbsee_tablenullablepi.sql) tables with nullable primary index (PI) columns

Tables with nullable primary index (PI) columns are never a good idea, and would indicate a poor choice of PI. This can also cause the generation of incorrect query results. 

[**dbsee_tablepartitions.sql ▸**](https://github.com/VLDB-Solutions/DBSEE/blob/master/dbsee_tablepartitions.sql) statistics for partitioned tables

As with table index statistics, these are required for efficient use of partitions and partition elimination.

[**dbsee_tablepidatatype.sql ▸**](https://github.com/VLDB-Solutions/DBSEE/blob/master/dbsee_tablepidatatype.sql) primary index (PI) datatypes

Primary index (PI) columns across different tables should always have the same column description and data type for the same data. This rule should extend to all columns: one name and one datatype for the same data across all tables.

[**dbsee_tableskew.sql ▸**](https://github.com/VLDB-Solutions/DBSEE/blob/master/dbsee_tableskew.sql) skewed tables

This shows incorrect primary index (PI) columns, or extremely common data values within the PI column(s). This leads to skewed results; one amp is doing far more work than the others, effectively causing a bottleneck. 

[**dbsee_tablestats.sql ▸**](https://github.com/VLDB-Solutions/DBSEE/blob/master/dbsee_tablestats.sql) tables with missing or old statistics

As mentioned for table index statistics and table partition statistics, having statistics collected frequently improves system efficiency. 

[**dbsee_tablewidth.sql ▸**](https://github.com/VLDB-Solutions/DBSEE/blob/master/dbsee_tablewidth.sql) number of columns per table

Having a large number of columns can result in slower query execution times; this is due to the large amount of blocks being read for a given number of rows.

[**dbsee_unused.sql ▸**](https://github.com/VLDB-Solutions/DBSEE/blob/master/dbsee_unused.sql) unused database objects

These objects are using up system resources and not yielding any positive return.

### Contact VLDB

For questions or support, we can be contacted through the following channels:

* Homepage: [vldbsolutions.com](https://vldbsolutions.com/)  
* Email: contact@vldbsolutions.com
* Twitter: [@vldbsolutions](https://twitter.com/vldbsolutions)

