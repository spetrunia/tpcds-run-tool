#!/bin/bash

if [ ! -f mysql-vars.sh ] ; then
  echo "Cannot find mysql-vars.sh - did you setup the db?"
  exit 1;
fi

source mysql-vars.sh
echo "Running data using $MYSQL $MYSQL_ARGS";

ls queries-for-mysql/*.sql | while read a ; do
  $MYSQL $MYSQL_ARGS tpcds < $a |  tee benchmark-output-raw.txt
done

($MYSQL $MYSQL_ARGS tpcds | tee mysql-result.txt) << END
select 
  query_stream, count(*), sum(query_time_ms) 
from
  my_tpcds_result
group by
  query_stream;
END




#grep LOG_END benchmark-output-raw.txt | sort | awk '//{printf ("%s %s\n" , $2, $3) }'

