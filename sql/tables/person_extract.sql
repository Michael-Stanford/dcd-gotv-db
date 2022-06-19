
drop table if exists bq_person_extract cascade;

create table bq_person_extract
(
  person_id  int,
  address_id int,
  full_name	character varying(128),
  date_of_birth	DATE,
  gender character varying(128),
  sos_id character varying(128),
  reg_voter_status	boolean,
  first_name	character varying(128),
  middle_name	character varying(128),
  last_name	character varying(128),
  suffix	character varying(128),
  last_primary_party char(1),
  primary_parties character varying(128),
  create_date	TIMESTAMP,
  modified_date	TIMESTAMP,
  query_date	TIMESTAMP,
  primary key(person_id)
);
  
create index bq_person_index_address_id on bq_person_extract(address_id);