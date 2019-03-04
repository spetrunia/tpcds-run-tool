# tpcds-run-tool

This is a very basic set of scripts to automate the tasks of

* Downloading/compiling the server (MariaDB, MySQL and PostgreSQL are supported)
* Generation of TPC-DS dataset and its read queries (that is, this is not the whole benchmark)
* Loading the dataset and running the queries.

MySQL/MariaDB cannot run all of the TPC-DS queries (See
https://jira.mariadb.org/browse/MDEV-17802 for details). The scripts here patch 
tpc-ds-tool:
* Some queries are modified to run. The modification is trivial
* Queries that could not be executed are excluded from the comparison.

See 
* mariadb-tpcds-tooling2/adapt-queries-for-mariadb-v4.diff
* mariadb-tpcds-tooling2/adapt-queries-for-pg-v4.diff
for details.

In order for SUM(query_time) value to be comparable, PostgreSQL also only runs the queries that
I could get to work with MariaDB.

# Preparing the host

Look at (or run)  `setup_server/setup-os-ubuntu.sh` to see what packages need to be installed.

# Running 

Just run `run-all-mariadb-10.4.sh` to do all the steps with MariaDB 10.4.

Run `run-all-pg.sh` to do all the steps with PostgreSQL 11 (compiled from source)

# Benchmark results

The results are saved in `my_tpcds_result` table in tpcds database. The table is defined as follows:

```
create table my_tpcds_result(
  query_name varchar(64),
  query_stream varchar(64),
  query_start datetime,
  query_time_ms bigint
);
```

Here:
- query_stream is number of query streams. TPC-DS generates N (we use 10) streams, each stream has instances of all 100 queries.
- query_name is the name of the query template (queryNNN.tpl)
- query_start - datetime when query started running. This is only for diagnostic.
- query_time_ms - how much the query took, in milliseconds.

This way, the total time it took to run the query stream can be computed as follows:

```
select 
  query_stream, count(*), sum(query_time_ms) 
from
  my_tpcds_result
group by
  query_stream;
```

and one can also get details about individual query run times.

# Other notes

Random query generator seed for the dataset seems to affect execution time A LOT.

It is currently hard-coded in `mariadb-tpcds-tooling2/01-generate-dataset-pg.sh` and `"mariadb-tpcds-tooling2/01-generate-dataset-pg.sh`.
