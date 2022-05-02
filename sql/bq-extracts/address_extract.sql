-- Create Address Extract Table
drop table if exists bq_address_extract cascade;

create table bq_address_extract
(
  address_geo_id  int,
  city	character varying(128),
  zip	character varying(128),
  zip4	character varying(128),
  street_number	character varying(128),
  street_id int,
  street_pre_dir	character varying(128),
  street_name	character varying(128),
  street_type	character varying(128),
  street_post_dir	character varying(128),
  melissa_data_results	character varying(128), 
  address_type	character varying(128),
  us_cong_district	character varying(128),
  state_house_district	character varying(128),
  state_senate_district	character varying(128),
  precinct_name	character varying(128),
  longitude	double precision,
  latitude	double precision,
  full_street_name	character varying(128),
  full_address	character varying(128),
  create_date	TIMESTAMP,
  modified_date	TIMESTAMP,
  query_date	TIMESTAMP,
  primary key(address_geo_id)
);

