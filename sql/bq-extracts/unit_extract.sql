
-- Create Unit Extract Table
drop table if exists bq_unit_extract cascade;

create table bq_unit_extract
(
  address_id  int,
  address_geo_id  int,
  unit_type	character varying(128),
  unit	character varying(128),
  query_date	TIMESTAMP
);
