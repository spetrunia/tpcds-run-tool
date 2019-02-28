#!/bin/bash

echo "THis script is out of date"
exit 1

# TODO: factor out the config soemwhere, and then this is the same as with MariaDB
MYSQL="./mysql-8.0/runtime_output_directory/mysql"
SOCKET="--socket=/tmp/mysql20.sock"
MYSQL_USER="-uroot"
MYSQL_ARGS="$MYSQL_USER $SOCKET"

ls queries-for-mysql/*.sql | while read a ; do
  $MYSQL $MYSQL_ARGS tpcds < $a |  tee benchmark-output-raw.txt
done

#grep LOG_END benchmark-output-raw.txt | sort | awk '//{printf ("%s %s\n" , $2, $3) }'

