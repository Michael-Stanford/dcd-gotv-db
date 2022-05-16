
drop table if exists bq_direction_extract cascade;
create table bq_direction_extract
(
  street_dir character varying(128),
  primary key(street_dir)
);
