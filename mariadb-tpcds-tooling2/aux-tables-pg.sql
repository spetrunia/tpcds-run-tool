
drop table if exists my_tpcds_cur_query;

create table my_tpcds_cur_query (
  query_name varchar(64),
  query_stream varchar(64),
  query_start_time timestamp
);

drop table if exists my_tpcds_result;

create table my_tpcds_result (
  query_name varchar(64),
  query_stream varchar(64),
  query_start timestamp,
  query_time_ms bigint
);

