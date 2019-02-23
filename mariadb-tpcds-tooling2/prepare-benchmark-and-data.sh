#!/bin/bash

set -e 
wget http://s.petrunia.net/scratch/tpc-ds-tool.zip
unzip tpc-ds-tool.zip

# Modify the toolkit to produce MySQL dialect and compile it
(
  cd v2.8.0rc4/tools
  mv makefile makefile.original
  sed  's/^\(CFLAGS.*\)$/\1 -D_MYSQL/' < makefile.original > makefile
  make
)

# Generate the dataset
(
  cd v2.8.0rc4/tools
  mkdir -p ../../data-for-mysql
  ./dsdgen -scale 1 -rngseed 1234 -dir ../../data-for-mysql
  du -sh ../../data-for-mysql
)


# Load the dataset
MYSQL="./mariadb-10.2/client/mysql"
SOCKET="--socket=/tmp/mysql20.sock"
MYSQL_USER="-uroot"
MYSQL_ARGS="$MYSQL_USER $SOCKET"

#$MYSQL $MYSQL_ARGS -e "drop database tpcds"
$MYSQL $MYSQL_ARGS -e "create database tpcds"
$MYSQL $MYSQL_ARGS tpcds < mariadb-tpcds-tooling2/ddl/tables.sql
$MYSQL $MYSQL_ARGS tpcds < mariadb-tpcds-tooling2/ddl/indexes.sql

DATA_FILES_DIR="`pwd`/data-for-mysql/"

bash mariadb-tpcds-tooling2/ddl/load-mysql.sql.sh $DATA_FILES_DIR > load-mysql.sql

$MYSQL $MYSQL_ARGS tpcds < load-mysql.sql


