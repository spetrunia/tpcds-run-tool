#!/bin/bash


# TODO: factor out the config soemwhere
MYSQL="./mariadb-10.2/client/mysql"
SOCKET="--socket=/tmp/mysql20.sock"
MYSQL_USER="-uroot"
MYSQL_ARGS="$MYSQL_USER $SOCKET"

ls queries-for-mysql/*.sql | while read a ; do
  $MYSQL $MYSQL_ARGS tpcds < $a |  tee benchmark-output-raw.txt
done

#grep LOG_END benchmark-output-raw.txt | sort | awk '//{printf ("%s %s\n" , $2, $3) }'

