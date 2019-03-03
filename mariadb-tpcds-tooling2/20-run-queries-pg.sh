#!/bin/bash

HOMEDIR=`pwd`
export PGDATA=$HOMEDIR/pgdata

ls queries-for-pg/*.sql | while read a ; do
  ./postgresql-11.2-inst/bin/psql tpcds < $a |  tee benchmark-output-raw.txt
done

(./postgresql-11.2-inst/bin/psql tpcds  | tee pg-result.txt) << END
select 
  query_stream, 
  count(*) as n_queries, 
  sum(query_time_ms) / (60*1000) as total_time_sec
from
  my_tpcds_result
group by
  query_stream;
END

