
drop function if exists Voters_On_Block(instreetnumber int, instreetid int);
drop table if exists Voters_On_Block_Results cascade;


CREATE TABLE voters_on_block_results (
    name character varying(128),
    age integer,
    voterid bigint,
    voterstatus boolean,
    address character varying(128),
    partycode character(1),
    partycodes character varying(40),
	democratic_percentage int,
    lastname character varying(64),
    firstname character varying(64),
    middlename character varying(64),
    namesuffix character varying(64),
    streetnumber character varying(64),
    streetpredir character varying(64),
    streetname character varying(64),
    streettype character varying(64),
    streetpostdir character varying(64),
    unit_type character varying(64),
    unit character varying(64),
    city character varying(64),
    zip character varying(64),
    zip4 character varying(64)
);

CREATE FUNCTION voters_on_block(
  instreetnumber integer,
  instreetid integer
)
  RETURNS SETOF voters_on_block_results
AS $$

  select
    coalesce(v.first_name, ' ')    ||' '||
      coalesce(v.middle_name, ' ') ||' '||
      coalesce(v.last_name, ' ')   ||' '||
      coalesce(v.suffix, ' ')
    as name,
    extract(year from current_date) - extract(year from v.date_of_birth) as age,
    cast(v.sos_id as bigint) as voterid,
    coalesce(v.reg_voter_status, false) as voterstatus,
	a.full_address as Address,
    coalesce(v.last_primary_party,'') as partycode, 
    v.primary_parties as partycodes,
	case when v.last_primary_party is not null 
	then cast((cast((array_length(string_to_array(v.primary_parties, 'D'), 1) - 1) as numeric) / 
	(cast((array_length(string_to_array(v.primary_parties, 'D'), 1) - 1) as numeric) + 
	 cast((array_length(string_to_array(v.primary_parties, 'R'), 1) - 1) as numeric))) * 100 as int)
	else '-1'
	end as democratic_percentage,
    coalesce(v.last_name,'') as lastname,
    coalesce(v.first_name,'') as firstname,
    coalesce(v.middle_name,'') as middlename,
    coalesce(v.suffix,'') as namesuffix,
    coalesce(a.street_number,'0') as streetnumber,
    coalesce(s.street_pre_dir,'') as streetpredir,
    coalesce(s.street_name,'') as streetname,
    coalesce(s.street_type,'') as streettype,
    coalesce(s.street_post_dir,'') as streetpostdir,
    coalesce(u.unit_type,'') as unit_type,
    coalesce(u.unit,'') as unit,
    coalesce(s.city,'') as city,
    coalesce(s.zip,'') as zip,
    '' as zip4
  from bq_person_extract v
  left join bq_unit_extract u    on u.address_id = v.address_id
  left join bq_address_extract a on a.address_geo_id = u.address_geo_id
  left join bq_street_extract s  on s.street_id = a.street_id
  where s.street_id = instreetid
    and cast(a.street_number as bigint) >= ((instreetnumber/100)*100)
    and cast(a.street_number as bigint) < ((instreetnumber/100)*100)+100
  order by a.full_address;

$$ LANGUAGE sql;
