
drop function if exists Get_Registered_Voters(instreetnumber varchar, instreetid int);
drop function if exists Get_Registered_Voters(inprecinct varchar);
drop table if exists Get_Registered_Voters_Results cascade;

CREATE TABLE Get_Registered_Voters_Results (
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
distance double precision
);

-- ----------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------

CREATE FUNCTION Get_Registered_Voters(
  instreetnumber varchar,
  instreetid integer
)
  RETURNS SETOF Get_Registered_Voters_Results
AS $$
DECLARE    
   _lat double precision;
   _lng double precision;
   _instreetnumberAsInt int;
   _emptyC character default '';
   _emptyVC character varying default '';

BEGIN

  _instreetnumberAsInt = cast(instreetnumber as int);
   
  return query 
  select
    v.person_id, 
	u.address_geo_id,
    cast(coalesce(v.first_name, ' ')    ||' '||
      coalesce(v.middle_name, ' ') ||' '||
      coalesce(v.last_name, ' ')   ||' '||
      coalesce(v.suffix, ' ') as character varying) as name,
    cast(extract(year from current_date) - extract(year from v.date_of_birth) as integer) as age,
    cast(v.sos_id as bigint) as voterid,
    coalesce(v.reg_voter_status, false) as voterstatus,
	a.full_address as address,
    coalesce(v.last_primary_party,_emptyC) as partycode, 
    v.primary_parties as partycodes,
	case when v.last_primary_party is not null 
	then cast((cast((array_length(string_to_array(v.primary_parties, 'D'), 1) - 1) as numeric) / 
	(cast((array_length(string_to_array(v.primary_parties, 'D'), 1) - 1) as numeric) + 
	 cast((array_length(string_to_array(v.primary_parties, 'R'), 1) - 1) as numeric))) * 100 as int)
	else '-1'
	end as democratic_percentage,
    coalesce(v.first_name,_emptyVC) as first_name,
    coalesce(v.middle_name,_emptyVC) as middle_name,
    coalesce(v.last_name,_emptyVC) as last_name,
    coalesce(v.suffix,_emptyVC) as suffix,
    coalesce(a.street_number,'0') as street_number,
    coalesce(s.street_pre_dir,_emptyVC) as street_pre_dir,
    coalesce(s.street_name,_emptyVC) as street_name,
    coalesce(s.street_type,_emptyVC) as street_type,
    coalesce(s.street_post_dir,_emptyVC) as street_post_dir,
    coalesce(u.unit_type,_emptyVC) as unit_type,
    coalesce(u.unit,_emptyVC) as unit,
    coalesce(s.city,_emptyVC) as city,
    coalesce(s.zip,_emptyVC) as zip,
    coalesce(a.precinct_name,_emptyVC) as precinct_name,
    coalesce(a.longitude,0.0) as longitude,
    coalesce(a.latitude,0.0) as latitude,
	cast(0.0 as double precision) as distance
  from bq_person_extract v
  left join bq_unit_extract u    on u.address_id = v.address_id
  left join bq_address_extract a on a.address_geo_id = u.address_geo_id
  left join bq_street_extract s  on s.street_id = a.street_id
  where s.street_id = instreetid
    and cast(a.street_number as bigint) >= ((_instreetnumberAsInt/100)*100)
    and cast(a.street_number as bigint) < ((_instreetnumberAsInt/100)*100)+100
  order by a.full_address;
END  

$$ LANGUAGE plpgsql;

-- ----------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------

CREATE FUNCTION Get_Registered_Voters(
  inprecinct varchar
)
  RETURNS SETOF Get_Registered_Voters_Results
AS $$
DECLARE    
   _emptyC character default '';
   _emptyVC character varying default '';

BEGIN
   
  return query 
  select
    v.person_id, 
	u.address_geo_id,
    cast(coalesce(v.first_name, ' ')    ||' '||
      coalesce(v.middle_name, ' ') ||' '||
      coalesce(v.last_name, ' ')   ||' '||
      coalesce(v.suffix, ' ') as character varying) as name,
    cast(extract(year from current_date) - extract(year from v.date_of_birth) as integer) as age,
    cast(v.sos_id as bigint) as voterid,
    coalesce(v.reg_voter_status, false) as voterstatus,
	a.full_address as address,
    coalesce(v.last_primary_party,_emptyC) as partycode, 
    v.primary_parties as partycodes,
	case when v.last_primary_party is not null 
	then cast((cast((array_length(string_to_array(v.primary_parties, 'D'), 1) - 1) as numeric) / 
	(cast((array_length(string_to_array(v.primary_parties, 'D'), 1) - 1) as numeric) + 
	 cast((array_length(string_to_array(v.primary_parties, 'R'), 1) - 1) as numeric))) * 100 as int)
	else '-1'
	end as democratic_percentage,
    coalesce(v.first_name,_emptyVC) as first_name,
    coalesce(v.middle_name,_emptyVC) as middle_name,
    coalesce(v.last_name,_emptyVC) as last_name,
    coalesce(v.suffix,_emptyVC) as suffix,
    coalesce(a.street_number,'0') as street_number,
    coalesce(s.street_pre_dir,_emptyVC) as street_pre_dir,
    coalesce(s.street_name,_emptyVC) as street_name,
    coalesce(s.street_type,_emptyVC) as street_type,
    coalesce(s.street_post_dir,_emptyVC) as street_post_dir,
    coalesce(u.unit_type,_emptyVC) as unit_type,
    coalesce(u.unit,_emptyVC) as unit,
    coalesce(s.city,_emptyVC) as city,
    coalesce(s.zip,_emptyVC) as zip,
    coalesce(a.precinct_name,_emptyVC) as precinct_name,
    coalesce(a.longitude,0.0) as longitude,
    coalesce(a.latitude,0.0) as latitude,
	cast(0.0 as double precision) as distance
  from bq_person_extract v
  left join bq_unit_extract u    on u.address_id = v.address_id
  left join bq_address_extract a on a.address_geo_id = u.address_geo_id
  left join bq_street_extract s  on s.street_id = a.street_id
  where a.precinct_name = inprecinct
  order by a.full_address;
END  

$$ LANGUAGE plpgsql;
