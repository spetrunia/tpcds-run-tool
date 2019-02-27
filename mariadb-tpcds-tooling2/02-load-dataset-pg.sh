#!/bin/bash

set -e

# Load the dataset
postgresql-11.2-inst/bin/createdb tpcds
postgresql-11.2-inst/bin/psql tpcds < mariadb-tpcds-tooling2/ddl-pg/tables.sql 
postgresql-11.2-inst/bin/psql tpcds < mariadb-tpcds-tooling2/ddl-pg/indexes.sql 
postgresql-11.2-inst/bin/psql tpcds < mariadb-tpcds-tooling2/aux-tables-pg.sql

DATA_FILES_DIR="`pwd`/data-for-pg/"

bash mariadb-tpcds-tooling2/ddl-pg/load.sql.sh $DATA_FILES_DIR > load-pg.sql

postgresql-11.2-inst/bin/psql tpcds < load-pg.sql
echo 'analyze;' | postgresql-11.2-inst/bin/psql tpcds
echo 'analyze;' | postgresql-11.2-inst/bin/psql tpcds

