
drop table if exists bq_streets_by_precinct_extract cascade;
create table  bq_streets_by_precinct_extract
(
    street_id int,
    precincts character varying(128),
	primary key(street_id)
);
