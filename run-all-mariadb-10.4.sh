#!/bin/bash
set -e 
mkdir -p logs
./setup-server/setup-mariadb-current.sh 10.4 |  tee logs/setup-mariadb

./mariadb-tpcds-tooling2/01-generate-dataset.sh | tee logs/generate-dataset
./mariadb-tpcds-tooling2/10-prepare-queries.sh  | tee logs/prepare-queries
./mariadb-tpcds-tooling2/02-load-dataset.sh | tee logs/load-dataset
./mariadb-tpcds-tooling2/20-run-queries.sh | tee logs/run-queries


