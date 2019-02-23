#!/bin/bash

set -e

# Generate the queries
(
  cd v2.8.0rc4
  patch -p1 < ../mariadb-tpcds-tooling2/adapt-queries-for-mariadb-v4.diff
  cd tools
  mkdir -p ../../queries-for-mysql
./dsqgen \
  -scale 1 \
  -dialect netezza \
  -verbose y \
  -qualify y  \
  -rngseed 4321 \
  -streams 20 \
  -directory ../query_templates \
  -input ../query_templates/templates-for-mariadb.lst \
  -output_dir ../../queries-for-mysql

  ls -lah ../../queries-for-mysql
)


