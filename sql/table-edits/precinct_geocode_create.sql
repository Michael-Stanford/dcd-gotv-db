
drop table if exists precinct_geocode cascade;

create table precinct_geocode
(
	precinct_name character varying(5),
	longitude double precision,
	latitude double precision,
	primary key(precinct_name)
);

insert into precinct_geocode (precinct_name, longitude, latitude)
select precinct_name, avg(longitude), avg(latitude)
from bq_address_extract
where precinct_name is not null
group by precinct_name
order by precinct_name
;

--select * from precinct_geocode;