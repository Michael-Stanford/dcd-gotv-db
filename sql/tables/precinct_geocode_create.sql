
drop table if exists precinct_geocode cascade;

create table precinct_geocode
(
	precinct_name character varying(5),
	longitude double precision,
	latitude double precision,
	primary key(precinct_name)
);
