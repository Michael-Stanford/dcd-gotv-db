
drop function if exists Close_Unregistered_Voters(instreetnumber varchar, instreetid int);
drop function if exists Close_Unregistered_Voters(inprecinct varchar);
drop table if exists Close_Unregistered_Voters_Results cascade;

CREATE TABLE Close_Unregistered_Voters_results (
    person_id int,
	address_geo_id int,
	first_name character varying(128),
    last_name character varying(128),
    precinct_name character varying(128),
    street_number character varying(128),
    street_pre_dir character varying(128),
    street_name character varying(128),
    street_type character varying(128),
    street_post_dir character varying(128),
    unit_type character varying(64),
    unit character varying(64),
    city character varying(128),
    zip character varying(128),
	distance double precision,
	lat double precision,
	lng double precision
);

-- ---------------------------------------------------------------------
CREATE FUNCTION Close_Unregistered_Voters(
  instreetnumber varchar,
  instreetid int
) RETURNS SETOF Close_Unregistered_Voters_results AS $$
DECLARE    
   _lat double precision;
   _lng double precision;
   _emptyVC64 character varying(64) default '';
   _emptyVC128 character varying(128) default '';
   _instreetnumberAsInt int;

BEGIN

select longitude, latitude 
into _lng, _lat
from bq_address_extract
where street_id = instreetid and street_number = instreetnumber
fetch first 1 rows only;

if _lng is null then
   _instreetnumberAsInt = cast(instreetnumber as int);
   with xx as (
	   select longitude, latitude 
       from bq_address_extract 
       where street_id = instreetid
           and cast(street_number as int) >= ((_instreetnumberAsInt/100)*100) 
	       and cast(street_number as int) < ((_instreetnumberAsInt/100)*100)+100
   )
   select avg(longitude), avg(latitude) 
   into _lng, _lat
   from xx;   
end if;

return query
select 
    v.person_id,
	u.address_geo_id,
	v.first_name,
    v.last_name,
    a.precinct_name,
    a.street_number,
    coalesce(a.street_pre_dir, _emptyVC128),
    a.street_name,
    a.street_type,
    coalesce(a.street_post_dir, _emptyVC128),
    coalesce(u.unit_type, _emptyVC64),
    coalesce(u.unit, _emptyVC64),
    v.city,
    v.zip,
    (point(a.longitude, a.latitude) <@> point(_lng, _lat))  as distance,
    a.longitude,
    a.longitude 
from bq_reregistration_targets_extract v
inner join bq_reregistration_targets_extract_splitaddress u on v.person_id = u.person_id
inner join bq_address_extract a on a.address_geo_id = u.address_geo_id
inner join bq_street_extract s on s.street_id = a.street_id
where (point(a.longitude, a.latitude) <@> point(_lng, _lat)) < 2.0
order by (point(a.longitude, a.latitude) <@> point(_lng, _lat)) 
fetch first 20 rows only
;
END
$$ LANGUAGE plpgsql;

-- ---------------------------------------------------------------------
CREATE FUNCTION Close_Unregistered_Voters(
  inprecinct varchar
) RETURNS SETOF Close_Unregistered_Voters_results AS $$
DECLARE    
   _lat double precision;
   _lng double precision;
   _emptyVC64 character varying(64) default '';
   _emptyVC128 character varying(128) default '';

BEGIN
select lng,lat 
into _lng,_lat
from precinct_geocode 
where precinct = inprecinct
fetch first 1 rows only;

if _lng is null then
   _lat := 32.776665;
   _lng := -96.796989;
end if;

return query
select 
    v.person_id,
	u.address_geo_id,
	v.first_name,
    v.last_name,
    a.precinct_name,
    a.street_number,
    coalesce(a.street_pre_dir, _emptyVC128),
    a.street_name,
    a.street_type,
    coalesce(a.street_post_dir, _emptyVC128),
    coalesce(u.unit_type, _emptyVC64),
    coalesce(u.unit, _emptyVC64),
    v.city,
    v.zip,
    (point(a.longitude, a.latitude) <@> point(_lng, _lat))  as distance,
    a.longitude,
    a.longitude 
from bq_reregistration_targets_extract v
inner join bq_reregistration_targets_extract_splitaddress u on v.person_id = u.person_id
inner join bq_address_extract a on a.address_geo_id = u.address_geo_id
inner join bq_street_extract s on s.street_id = a.street_id
where a.precinct_name = inprecinct
fetch first 50 rows only
;

END
$$ LANGUAGE plpgsql;
