#!/bin/bash

RNGSEED_DATASET=10

set -e

if [ -d data-for-pg ] ; then
  echo "Dataset is already there? Remove data-for-pg directory "
  exit 1
fi

if [ ! -f tpc-ds-tool.zip ] ; then
  wget http://s.petrunia.net/scratch/tpc-ds-tool.zip
fi

if [ ! -d v2.8.0rc4-pg ] ; then 
# Compile the toolkit, unmodified
(
  rm -rf tmp
  mkdir  tmp
  (cd tmp; unzip ../tpc-ds-tool.zip)
  mv tmp/v2.8.0rc4 v2.8.0rc4-pg
  rm -rf tmp

  cd v2.8.0rc4-pg/tools
  make
)
fi

# Generate the dataset
(
  cd v2.8.0rc4-pg/tools
  mkdir -p ../../data-for-pg
  ./dsdgen -terminate n -scale 1 -rngseed $RNGSEED_DATASET -dir ../../data-for-pg
  du -sh ../../data-for-pg
)

cat > data-for-pg.txt <<END
RNGSEED_DATASET=$RNGSEED_DATASET
END

