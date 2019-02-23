#!/bin/bash

set -e
# This expects to find the generated data in data-for-mysql

# Load the dataset
MYSQL="./mysql-8.0/runtime_output_directory/mysql"
SOCKET="--socket=/tmp/mysql20.sock"
MYSQL_USER="-uroot"
MYSQL_ARGS="$MYSQL_USER $SOCKET"

$MYSQL $MYSQL_ARGS -e "create database tpcds"
$MYSQL $MYSQL_ARGS tpcds < mariadb-tpcds-tooling2/ddl/tables.sql
$MYSQL $MYSQL_ARGS tpcds < mariadb-tpcds-tooling2/ddl/indexes.sql
$MYSQL $MYSQL_ARGS tpcds < mariadb-tpcds-tooling2/aux-tables.sql

DATA_FILES_DIR="`pwd`/data-for-mysql/"

bash mariadb-tpcds-tooling2/ddl/load-mysql.sql.sh $DATA_FILES_DIR > load-mysql.sql

$MYSQL $MYSQL_ARGS tpcds < load-mysql.sql


