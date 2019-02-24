#!/bin/bash

HOMEDIR=`pwd`
export PGDATA=$HOMEDIR/pgdata

# Relative paths not allowed in COPY
echo " COPY my_tpcds_result TO '$HOMEDIR/result_pg2_seed5678.csv' DELIMITER ',' CSV HEADER;" | ./postgresql-11.2-inst/bin/psql tpcds 

# TODO: PG client also has a command: \copy (Select * From foo) To '/tmp/test.csv' With CSV

