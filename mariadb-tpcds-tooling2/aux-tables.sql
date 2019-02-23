
drop table if exists my_tpcds_result;

create table my_tpcds_result(
  query_name varchar(64),
  query_stream varchar(64),
  query_start datetime,
  query_time_ms bigint
);


