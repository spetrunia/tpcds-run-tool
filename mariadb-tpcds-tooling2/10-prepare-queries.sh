#!/bin/bash

RNGSEED_QUERIES=10

set -e

if [ -d queries-for-mysql ]; then 
  echo "Directory queries-for-mysql exists. Move it away"
  exit 1
fi

# Generate the queries
(
  cd v2.8.0rc4
  if [ ! -f query_templates/templates-for-mariadb.lst ]; then
    patch -p1 < ../mariadb-tpcds-tooling2/adapt-queries-for-mariadb-v4.diff
  fi

  cd tools
  mkdir -p ../../queries-for-mysql
./dsqgen \
  -scale 1 \
  -dialect netezza \
  -verbose y \
  -qualify y  \
  -rngseed $RNGSEED_QUERIES \
  -streams 10 \
  -directory ../query_templates \
  -input ../query_templates/templates-for-mariadb.lst \
  -output_dir ../../queries-for-mysql

  ls -lah ../../queries-for-mysql
)

cat > queries-for-mysql.txt <<END
RNGSEED_QUERIES=$RNGSEED_QUERIES
END

