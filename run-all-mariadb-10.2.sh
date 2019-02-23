#!/bin/bash
set -e 
./setup-server/setup-mariadb-current.sh 10.2 |  tee log-build

./mariadb-tpcds-tooling2/prepare-benchmark-and-data.sh | tee log-prepare
./mariadb-tpcds-tooling2/prepare-queries.sh  | tee log-run
./mariadb-tpcds-tooling2/run-queries.sh  | tee log-benchmark
