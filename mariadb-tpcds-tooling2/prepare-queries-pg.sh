#!/bin/bash


#$MYSQL $MYSQL_ARGS tpcds < mariadb-tpcds-tooling2/aux-tables.sql

# Generate the queries
(
  cd v2.8.0rc4-pg
  patch -p1 < ../mariadb-tpcds-tooling2/adapt-queries-for-pg-v4.diff
  cd tools
  mkdir -p ../../queries-for-pg
./dsqgen \
  -scale 1 \
  -dialect netezza \
  -verbose y \
  -qualify y  \
  -rngseed 1234 \
  -streams 20 \
  -directory ../query_templates \
  -input ../query_templates/templates-for-mariadb.lst \
  -output_dir ../../queries-for-pg

  ls -lah ../../queries-for-pg
)


