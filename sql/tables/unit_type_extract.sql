
drop table if exists bq_unit_type_extract cascade;
create table bq_unit_type_extract
(
  unit_type character varying(128),
  primary key(unit_type)
);
