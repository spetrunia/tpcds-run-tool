#!/bin/bash

RNGSEED_DATASET=10

set -e

if [ -d data-for-mysql ] ; then
  echo "Dataset is already there? Remove data-for-mysql directory "
  exit 1
fi

set -e 
if [ ! -f tpc-ds-tool.zip ] ; then
  wget http://s.petrunia.net/scratch/tpc-ds-tool.zip
fi

if [ ! -d v2.8.0rc4 ] ; then 

  unzip tpc-ds-tool.zip
  
# Modify the toolkit to produce MySQL dialect and compile it
  (
    cd v2.8.0rc4/tools
    mv makefile makefile.original
    sed  's/^\(CFLAGS.*\)$/\1 -D_MYSQL/' < makefile.original > makefile
    make
  )
fi

# Generate the dataset
(
  cd v2.8.0rc4/tools
  mkdir -p ../../data-for-mysql
  ./dsdgen -scale 1 -rngseed $RNGSEED_DATASET -dir ../../data-for-mysql
  du -sh ../../data-for-mysql
)

cat > data-for-mysql.txt <<END
RNGSEED_DATASET=$RNGSEED_DATASET
END

