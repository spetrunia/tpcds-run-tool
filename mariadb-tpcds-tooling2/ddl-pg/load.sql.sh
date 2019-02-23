#!/bin/bash

DATADIR="$1"

# Produce stuff like:
#copy call_center from '/mnt/data/tpcds/data/call_center.dat' with delimiter '|' csv;
#copy catalog_page from '/mnt/data/tpcds/data/catalog_page.dat' with delimiter '|' csv;

echo "call_center
catalog_page 
catalog_returns 
catalog_sales 
customer_address 
customer 
customer_demographics 
date_dim 
dbgen_version 
household_demographics 
income_band 
inventory 
item 
promotion 
reason 
ship_mode 
store 
store_returns 
store_sales 
time_dim 
warehouse 
web_page 
web_returns 
web_sales 
web_site" | while read a; do
  echo "copy $a from '${DATADIR}/$a.dat' with delimiter '|' csv encoding 'latin1';"
done

