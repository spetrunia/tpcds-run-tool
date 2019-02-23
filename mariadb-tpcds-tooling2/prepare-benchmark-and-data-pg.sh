#!/bin/bash

mkdir tmp
(cd tmp; unzip ../tpc-ds-tool.zip)
mv tmp/v2.8.0rc4 v2.8.0rc4-pg
rm -rf tmp


# Compile the toolkit, unmodified
(
  cd v2.8.0rc4-pg/tools
  make
)

# Generate the dataset
(
  cd v2.8.0rc4-pg/tools
  mkdir -p ../../data-for-pg
  ./dsdgen -terminate n -scale 1 -dir ../../data-for-pg
  du -sh ../../data-for-pg
)


# Load the dataset
postgresql-11.2-inst/bin/createdb tpcds
postgresql-11.2-inst/bin/psql tpcds < mariadb-tpcds-tooling2/ddl-pg/tables.sql 
postgresql-11.2-inst/bin/psql tpcds < mariadb-tpcds-tooling2/ddl-pg/indexes.sql 
postgresql-11.2-inst/bin/psql tpcds < mariadb-tpcds-tooling2/aux-tables-pg.sql

DATA_FILES_DIR="`pwd`/data-for-pg/"

bash mariadb-tpcds-tooling2/ddl-pg/load.sql.sh $DATA_FILES_DIR > load-pg.sql

postgresql-11.2-inst/bin/psql tpcds < load-pg.sql


