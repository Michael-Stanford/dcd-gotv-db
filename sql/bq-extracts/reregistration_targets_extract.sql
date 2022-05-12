
-- Create reregistration Extract Table
drop table if exists bq_reregistration_targets_extract cascade;

create table bq_reregistration_targets_extract
(
  person_id	int,
  first_name	character varying(128),
  last_name	character varying(128),
  address	character varying(128),
  address_2	character varying(128),
  city	character varying(128),
  state	character varying(128),
  zip	character varying(128),
  zip4	character varying(128),
  county_name	character varying(128),
  precinct_name	character varying(128),
  state_house_district	character varying(128),
  target_type	character varying(128),
  phone_1	character varying(128),
  phone_2	character varying(128),
  phone_3	character varying(128),
  phone_4	character varying(128),
  query_date	TIMESTAMP
);