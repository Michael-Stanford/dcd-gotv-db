
drop table if exists bq_city_extract cascade;
create table bq_city_extract
(
  city character varying(128),
  primary key(city)
);
