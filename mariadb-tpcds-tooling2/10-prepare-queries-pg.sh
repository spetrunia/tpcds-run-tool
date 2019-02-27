#!/bin/bash

RNGSEED_QUERIES=10

set -e

if [ -d queries-for-pg ]; then 
  echo "Directory queries-for-pg exists. Move it away"
  exit 1
fi

# Generate the queries
(
  cd v2.8.0rc4-pg

  if [ ! -f query_templates/templates-for-mariadb.lst ]; then
    patch -p1 < ../mariadb-tpcds-tooling2/adapt-queries-for-pg-v4.diff
  fi
 
  cd tools
  mkdir -p ../../queries-for-pg
./dsqgen \
  -scale 1 \
  -dialect netezza \
  -verbose y \
  -qualify y  \
  -rngseed $RNGSEED_QUERIES \
  -streams 10 \
  -directory ../query_templates \
  -input ../query_templates/templates-for-mariadb.lst \
  -output_dir ../../queries-for-pg

  ls -lah ../../queries-for-pg
)

cat > queries-for-pg.txt <<END
RNGSEED_QUERIES=$RNGSEED_QUERIES
END

