
drop function if exists Get_Unregistered_Voters(instreetnumber varchar, instreetid int);
drop function if exists Get_Unregistered_Voters(inprecinct varchar);
drop table if exists Get_Unregistered_Voters_Results cascade;

CREATE TABLE Get_Unregistered_Voters_results (
person_id int,
address_geo_id int,
name character varying,
age integer,
voterid bigint,
voterstatus boolean,
address character varying,
partycode character,
partycodes character varying,
democratic_percentage int,
first_name character varying,
middle_name character varying,
last_name character varying,
suffix character varying,
street_number character varying,
street_pre_dir character varying,
street_name character varying,
street_type character varying,
street_post_dir character varying,
unit_type character varying,
unit character varying,
city character varying,
zip character varying,
precinct_name character varying,
longitude double precision,
latitude double precision,
distance double precision,
property_type character
);

-- ---------------------------------------------------------------------
-- ---------------------------------------------------------------------
-- ---------------------------------------------------------------------

CREATE FUNCTION Get_Unregistered_Voters(
  instreetnumber varchar,
  instreetid int
) RETURNS SETOF Get_Unregistered_Voters_results AS $$
DECLARE    
   _lat double precision;
   _lng double precision;
   _instreetnumberAsInt int;
   _U character default 'U';
   _emptyC character default '';
   _emptyVC character varying default '';

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
    cast(coalesce(v.first_name, ' ')    ||' '||
      coalesce(v.last_name, ' ') as character varying) as name,
	cast(0 as integer) as age,  
	cast(0 as bigint) as voterid,  
	false as voterstatus,
	address,
	cast('' as character(1)) as partycode,
	cast('-' as character varying) as partycodes,
	cast(-1 as integer) as democratic_percentage,  
	v.first_name,
	_emptyVC as middle_name,
    v.last_name,
	_emptyVC as suffix,
    a.street_number,
    coalesce(s.street_pre_dir, _emptyVC),
    coalesce(s.street_name, _emptyVC),
    coalesce(s.street_type, _emptyVC),
    coalesce(s.street_post_dir, _emptyVC),
    coalesce(u.unit_type, _emptyVC),
    coalesce(u.unit, _emptyVC),
    coalesce(v.city, _emptyVC),
    coalesce(v.zip, _emptyVC),
    a.precinct_name,
    a.longitude,
    a.latitude,
    (point(a.longitude, a.latitude) <@> point(_lng, _lat))  as distance ,
	coalesce(asup.property_type, _U) as property_type
from bq_reregistration_targets_extract v
inner join bq_reregistration_targets_extract_splitaddress u on v.person_id = u.person_id
inner join bq_address_extract a on a.address_geo_id = u.address_geo_id
inner join bq_street_extract s on s.street_id = a.street_id
left join address_supplement asup on asup.address_geo_id = u.address_geo_id
where (point(a.longitude, a.latitude) <@> point(_lng, _lat)) < 2.0
order by (point(a.longitude, a.latitude) <@> point(_lng, _lat)) 
fetch first 20 rows only
;
END
$$ LANGUAGE plpgsql;

-- ---------------------------------------------------------------------
-- ---------------------------------------------------------------------
-- ---------------------------------------------------------------------

CREATE FUNCTION Get_Unregistered_Voters(
  inprecinct varchar
) RETURNS SETOF Get_Unregistered_Voters_results AS $$
DECLARE    
   _lat double precision;
   _lng double precision;
   _U character default 'U';
   _emptyC character default '';
   _emptyVC character varying default '';

BEGIN
select longitude,latitude 
into _lng,_lat
from precinct_geocode 
where precinct_name = inprecinct
fetch first 1 rows only;

if _lng is null then
   _lat := 32.776665;
   _lng := -96.796989;
end if;

return query
select 
    v.person_id,
	u.address_geo_id,
    cast(coalesce(v.first_name, ' ')    ||' '||
      coalesce(v.last_name, ' ') as character varying) as name,
	cast(0 as integer) as age,  
	cast(0 as bigint) as voterid,  
	false as voterstatus,
	address,
	cast('' as character(1)) as partycode,
	cast('-' as character varying) as partycodes,
	cast(-1 as integer) as democratic_percentage,  
	v.first_name,
	_emptyVC as middle_name,
    v.last_name,
	_emptyVC as suffix,
    a.street_number,
    coalesce(s.street_pre_dir, _emptyVC),
    coalesce(s.street_name, _emptyVC),
    coalesce(s.street_type, _emptyVC),
    coalesce(s.street_post_dir, _emptyVC),
    coalesce(u.unit_type, _emptyVC),
    coalesce(u.unit, _emptyVC),
    coalesce(v.city, _emptyVC),
    coalesce(v.zip, _emptyVC),
    a.precinct_name,
    a.longitude,
    a.latitude,
    (point(a.longitude, a.latitude) <@> point(_lng, _lat))  as distance ,
	coalesce(asup.property_type, _U) as property_type
from bq_reregistration_targets_extract v
inner join bq_reregistration_targets_extract_splitaddress u on v.person_id = u.person_id
inner join bq_address_extract a on a.address_geo_id = u.address_geo_id
inner join bq_street_extract s on s.street_id = a.street_id
left join address_supplement asup on asup.address_geo_id = u.address_geo_id
where a.precinct_name = inprecinct
fetch first 50 rows only
;

END
$$ LANGUAGE plpgsql;
