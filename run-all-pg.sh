#!/bin/bash
set -e 
mkdir -p logs
./setup-server/setup-postgresql-11.sh |  tee logs/setup-postgresql

./mariadb-tpcds-tooling2/01-generate-dataset-pg.sh  | tee logs/generate-dataset-pg
./mariadb-tpcds-tooling2/10-prepare-queries-pg.sh   | tee logs/prepare-queries-pg
./mariadb-tpcds-tooling2/02-load-dataset-pg.sh      | tee logs/load-dataset-pg
./mariadb-tpcds-tooling2/20-run-queries-pg.sh       | tee logs/run-queries-pg


