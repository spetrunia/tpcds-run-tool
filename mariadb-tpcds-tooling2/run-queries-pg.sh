#!/bin/bash

HOMEDIR=`pwd`
export PGDATA=$HOMEDIR/pgdata

ls queries-for-pg/*.sql | while read a ; do
  ./postgresql-11.2-inst/bin/psql tpcds < $a |  tee benchmark-output-raw.txt
done

#grep LOG_END benchmark-output-raw.txt | sort | awk '//{printf ("%s %s\n" , $2, $3) }'

