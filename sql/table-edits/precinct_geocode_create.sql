
drop table if exists precinct_geocode;

create table precinct_geocode
(
	precinct character varying(4),
	street_key int,
	lat double precision,
	lng double precision,
	primary key(precinct)
);

insert into precinct_geocode
with xx as (
select distinct u.van_precinct_name,a.street_key
from uvoter u
inner join uvoter_splitaddress a
  on u.person_id = a.person_id 
group by u.van_precinct_name,a.street_key
), yy as (
select * from xx where street_key = (select max(street_key) from xx xy where xx.van_precinct_name = xy.van_precinct_name)
), zz as (
select yy.*,g.lat,g.lng from yy
inner join geocodes g 
  on yy.street_key = g.street_key 
)
select * from zz where lat = (select min(lat) from zz xy where zz.van_precinct_name = xy.van_precinct_name and zz.street_key = xy.street_key)
                   and lng = (select min(lng) from zz xy where zz.van_precinct_name = xy.van_precinct_name and zz.street_key = xy.street_key)
order by  1,2 
;

--select * from precinct_geocode;