
drop table if exists bq_street_type_extract cascade;
create table bq_street_type_extract
(
  street_type character varying(128),
  primary key(street_type)
);
