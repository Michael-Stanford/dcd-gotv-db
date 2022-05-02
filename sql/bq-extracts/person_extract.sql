
drop table if exists bq_person_extract cascade;

create table bq_person_extract
(
  person_id  int,
  address_id int,
  full_name	character varying(128),
  age	int,
  gender character varying(128),
  sos_id character varying(128),
  reg_voter_status	boolean,
  first_name	character varying(128),
  middle_name	character varying(128),
  last_name	character varying(128),
  suffix	character varying(128),
  create_date	TIMESTAMP,
  modified_date	TIMESTAMP,
  query_date	TIMESTAMP,
  primary key(person_id)
);
  
