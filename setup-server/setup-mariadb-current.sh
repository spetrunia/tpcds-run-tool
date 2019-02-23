#!/bin/bash

set -e
if [ "x${1}y" == "xy" ] ; then 
  echo "Usage: $0 BRANCH_NAME"
  exit 1
fi

BRANCH="${1}"

git clone --branch $BRANCH --depth 1 https://github.com/MariaDB/server.git mariadb-$BRANCH

(
cd mariadb-$BRANCH
git submodule init
git submodule update
cmake . -DCMAKE_BUILD_TYPE=RelWithDebInfo \
  -DWITHOUT_MROONGA:bool=1 -DWITHOUT_TOKUDB:bool=1
make -j8
cd .. 
)

HOMEDIR=`pwd`
DATADIR="$HOMEDIR/mariadb-$BRANCH-data"
(
  cd mariadb-$BRANCH/mysql-test
  ./mtr alias
  cp -r var/install.db $DATADIR
)

# plugin-load=ha_rocksdb.so
# default-storage-engine=rocksdb
# skip-innodb
# default-tmp-storage-engine=MyISAM
# skip-slave-start
# plugin-dir=$HOMEDIR/mariadb-$BRANCH/storage/rocksdb
# log-bin=pslp
# binlog-format=row

cat > $HOMEDIR/my-mariadb-$BRANCH.cnf << EOF
[mysqld]

bind-address=0.0.0.0
datadir=$DATADIR
plugin-dir=$HOMEDIR/mariadb-$BRANCH/mysql-test/var/plugins

log-error
lc_messages_dir=$HOMEDIR/mariadb-$BRANCH/sql/share

tmpdir=/tmp
port=3306
socket=/tmp/mysql20.sock
gdb
server-id=12

innodb_buffer_pool_size=8G

EOF

cd $HOMEDIR/mariadb-$BRANCH/sql
../sql/mysqld --defaults-file=$HOMEDIR/my-mariadb-$BRANCH.cnf &


