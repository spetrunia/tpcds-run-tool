#!/bin/bash

#DATADIR="/home/psergey/tpcds/try2/v2.8.0rc4/tools/tmp/"
DATADIR="$1"

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
  echo "load data infile '${DATADIR}$a.dat' into table $a character set latin1 fields terminated by '|' enclosed by '\"';"
done

