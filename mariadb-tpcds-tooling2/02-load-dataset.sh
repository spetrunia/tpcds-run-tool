#!/bin/bash

set -e

if [ ! -f mysql-vars.sh ] ; then
  echo "Cannot find mysql-vars.sh - did you setup the db?"
  exit 1;
fi

source mysql-vars.sh
echo "Loading data using $MYSQL $MYSQL_ARGS";

# This should fail if the database already exists, right?
$MYSQL $MYSQL_ARGS -e "create database tpcds"

$MYSQL $MYSQL_ARGS tpcds < mariadb-tpcds-tooling2/ddl/tables.sql
$MYSQL $MYSQL_ARGS tpcds < mariadb-tpcds-tooling2/ddl/indexes.sql
$MYSQL $MYSQL_ARGS tpcds < mariadb-tpcds-tooling2/aux-tables.sql

DATA_FILES_DIR="`pwd`/data-for-mysql/"

bash mariadb-tpcds-tooling2/ddl/load-mysql.sql.sh $DATA_FILES_DIR > load-mysql.sql

$MYSQL $MYSQL_ARGS tpcds < load-mysql.sql

