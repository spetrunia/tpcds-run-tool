#!/bin/bash

HOMEDIR=`pwd`
export PGDATA=$HOMEDIR/pgdata

ls queries-for-pg/*.sql | while read a ; do
  ./postgresql-11.2-inst/bin/psql tpcds < $a |  tee benchmark-output-raw.txt
done

cat << END
select 
  query_stream, count(*), sum(query_time_ms) 
from
  my_tpcds_result
group by
  query_stream;
END | ./postgresql-11.2-inst/bin/psql tpcds  | tee pg-result.txt

