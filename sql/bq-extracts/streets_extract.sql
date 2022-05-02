
drop table if exists dq_street_extract cascade;

create table bq_street_extract
(
  street_id int,
  street_pre_dir character varying(128),
  street_name character varying(128),
  street_type character varying(128),
  street_post_dir character varying(128),
  city character varying(128),
  zip character varying(128),
  full_street_name character varying(128),
  query_date TIMESTAMP,
  primary key(street_id)
);
