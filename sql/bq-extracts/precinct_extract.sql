
drop table if exists bq_precinct_extract cascade;

create table bq_precinct_extract
(
  precinct_name	character varying(128),
  us_cong_district	character varying(128),
  state_house_district	character varying(128),
  state_senate_district	character varying(128),
  query_date	TIMESTAMP,
  primary key(precinct_name)
);