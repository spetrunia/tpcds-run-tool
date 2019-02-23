#!/bin/bash

set -e

# TODO: factor out the config soemwhere
MYSQL="./mariadb-10.2/client/mysql"
SOCKET="--socket=/tmp/mysql20.sock"
MYSQL_USER="-uroot"
MYSQL_ARGS="$MYSQL_USER $SOCKET"

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

#$MYSQL $MYSQL_ARGS tpcds < mariadb-tpcds-tooling/v2.8.0rc4/tools/tmp-queries/query_0.sql | tee benchmark-output-raw.txt
#grep LOG_END benchmark-output-raw.txt | sort | awk '//{printf ("%s %s\n" , $2, $3) }'

