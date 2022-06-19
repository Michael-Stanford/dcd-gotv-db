SELECT column_name FROM `demstxsp.tdp_dallasdems.INFORMATION_SCHEMA.COLUMNS`
--where table_name = 'person' and column_name like '%precinct%'
--where table_name = 'address' and column_name like '%precinct%'
where table_name = 'precinct' and column_name not like '%precinct%'
;
 
-- my precinct info from person table
select dnc_precinct_id, van_precinct_id, van_precinct_name, precinct_ward, precinct_town, *
from `demstxsp.tdp_dallasdems.person` where person_id = '178184457'
;

-- my precinct info from address table
select dnc_precinct_id, precinct_source, precinct_last_verified_date, van_precinct_id, * 
from `demstxsp.tdp_dallasdems.address`
where address_id = '53891115'
;
select * from `demstxsp.tdp_dallasdems.address` 
where dnc_precinct_id not in (select dnc_precinct_id from `demstxsp.tdp_dallasdems.precinct`)
;

-- my precinct by code
select dnc_precinct_id, national_precinct_code, precinct_code, precinct_name, van_precinct_id, van_precinct_name, nz_precinct_id, 
       create_date, modified_date, is_active, state_code, county, town, ward, other 
from `demstxsp.tdp_dallasdems.precinct`
where precinct_name = '2501'
;

-- active vs inactive precincts
select distinct is_active,count(*)
from `demstxsp.tdp_dallasdems.precinct`
group by is_active
;

-- look for inconsistent codes/names
select dnc_precinct_id, van_precinct_name, precinct_code, precinct_name, is_active
from `demstxsp.tdp_dallasdems.precinct`
where upper(van_precinct_name) <> upper(precinct_code) 
   or upper(van_precinct_name) <> upper(precinct_name)
   or upper(precinct_code) <> upper(precinct_name)
;