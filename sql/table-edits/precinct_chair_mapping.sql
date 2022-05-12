
drop table if exists precinct_chair_mapping cascade;

create table precinct_chair_mapping
(
  precinct_name	character varying(128),
  chair_key	int,
  primary key(precinct_name)
);

create index precinct_chair_mapping_index_chair_key
    ON precinct_chair_mapping USING btree
    (chair_key ASC NULLS LAST);