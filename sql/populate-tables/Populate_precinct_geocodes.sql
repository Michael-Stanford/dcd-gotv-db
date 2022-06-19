
insert into precinct_geocode (precinct_name, longitude, latitude)
select precinct_name, avg(longitude), avg(latitude)
from bq_address_extract
where precinct_name is not null
group by precinct_name
order by precinct_name
;

--select * from precinct_geocode;