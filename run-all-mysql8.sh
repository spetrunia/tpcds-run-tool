#!/bin/bash
set -e 
mkdir -p logs
./setup-server/setup-mysql-8.0.sh | tee logs/setup-mysql-8.0

./mariadb-tpcds-tooling2/load-data-mysql8.sh | tee logs/load-data-mysql8
./mariadb-tpcds-tooling2/run-queries-mysql8.sh  | tee logs/run-queries-mysql8
