
drop function if exists Close_Unregistered_Voters(instreetnumber int, instreetkey int);
drop function if exists Close_Unregistered_Voters(inprecinct varchar);
drop table if exists Close_Unregistered_Voters_Results;

CREATE TABLE Close_Unregistered_Voters_results (
    person_id character varying(64),
	street_key int,
	firstname character varying(64),
    lastname character varying(64),
    precinct character varying(64),
    streetnumber character varying(64),
    streetdirection character varying(64),
    streetname character varying(64),
    streettype character varying(64),
    unit_type character varying(64),
    unit character varying(64),
    streetbuilding character varying(64),
    city character varying(64),
    zip character varying(64),
	distance double precision,
	lat double precision,
	lng double precision,
	side char(1)
);

CREATE FUNCTION Close_Unregistered_Voters(
  instreetnumber integer,
  instreetkey integer
) RETURNS SETOF Close_Unregistered_Voters_results AS $$
DECLARE    
   _lat double precision;
   _lng double precision;
   _emptyVC64 character varying(64) default '';

BEGIN
select lat,lng 
into _lat,_lng
from geocodes 
where street_key = instreetkey and streetnumber = instreetnumber
fetch first 1 rows only;

if _lat is null then
   select lat,lng 
   into _lat,_lng
   from geocodes 
   where street_key = instreetkey
       and streetnumber >= ((instreetnumber/100)*100) and streetnumber < ((instreetnumber/100)*100)+100
   fetch first 1 rows only;
end if;

return query
select 
   v.person_id,
   u.street_key,
   v.first_name,
   v.last_name,
   v.van_precinct_name,
   u.streetnumber, 
   coalesce(u.streetdirection, _emptyVC64),
   u.streetname,
   u.streettype,
   coalesce(u.unit_type, _emptyVC64),
   coalesce(u.unit, _emptyVC64),
   coalesce(u.streetbuilding, _emptyVC64),
   v.city,
   v.zip,
   (point(g.lng, g.lat) <@> point(_lng, _lat))  as distance,
   g.lat,
   g.lng,	
   g.streetside
from uvoter v
inner join uvoter_splitaddress u
  on v.person_id = u.person_id
inner join "Streets" s
  on u.streetname = s.streetname
 and coalesce(u.streettype,'') = coalesce(s.streettype,'')
 and coalesce(u.streetdirection,'') = coalesce(s.streetdirection,'')
 and upper(v.city) = s.city
 and v.zip = s.zip
inner join geocodes g
  on cast(u.streetnumber as int) = g.streetnumber
 and u.street_key = g.street_key
where (point(g.lng, g.lat) <@> point(_lng, _lat)) < 100
order by (point(g.lng, g.lat) <@> point(_lng, _lat)) 
fetch first 20 rows only
;
END
$$ LANGUAGE plpgsql;

CREATE FUNCTION Close_Unregistered_Voters(
  inprecinct varchar
) RETURNS SETOF Close_Unregistered_Voters_results AS $$
DECLARE    
   _lat double precision;
   _lng double precision;
   _emptyVC64 character varying(64) default '';

BEGIN
select lat,lng 
into _lat,_lng
from precinct_geocode 
where precinct = inprecinct
fetch first 1 rows only;

if _lat is null then
   _lat := 32.776665;
   _lng := -96.796989;
end if;

return query
select 
   v.person_id,
   u.street_key,
   v.first_name,
   v.last_name,
   v.van_precinct_name,
   u.streetnumber, 
   coalesce(u.streetdirection, _emptyVC64),
   u.streetname,
   u.streettype,
   coalesce(u.unit_type, _emptyVC64),
   coalesce(u.unit, _emptyVC64),
   coalesce(u.streetbuilding, _emptyVC64),
   v.city,
   v.zip,
   (point(g.lng, g.lat) <@> point(_lng, _lat))  as distance,
   g.lat,
   g.lng,	
   g.streetside
from uvoter v
inner join uvoter_splitaddress u
  on v.person_id = u.person_id
inner join "Streets" s
  on u.streetname = s.streetname
 and coalesce(u.streettype,'') = coalesce(s.streettype,'')
 and coalesce(u.streetdirection,'') = coalesce(s.streetdirection,'')
 and upper(v.city) = s.city
 and v.zip = s.zip
inner join geocodes g
  on cast(u.streetnumber as int) = g.streetnumber
 and u.street_key = g.street_key
where v.van_precinct_name = inprecinct
fetch first 50 rows only
;
END
$$ LANGUAGE plpgsql;
