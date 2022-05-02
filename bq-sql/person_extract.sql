
-- Create Person Extract Table
drop table if exists `demstxdallascp.sbx_farrarb.person_extract`;
create table if not exists `demstxdallascp.sbx_farrarb.person_extract`
(
  person_id  INT64,
  address_id INT64,
  full_name	STRING,
  age	INT64,
  gender STRING,
  sos_id STRING,
  reg_voter_status	BOOL,
  first_name	STRING,
  middle_name	STRING,
  last_name	STRING,
  suffix	STRING,
  create_date	TIMESTAMP,
  modified_date	TIMESTAMP,
  query_date	TIMESTAMP
);

-- Get Person for Extract
insert into `demstxdallascp.sbx_farrarb.person_extract`
(person_id, address_id, full_name, age, gender, sos_id, reg_voter_status, first_name, middle_name, last_name,  suffix,
  create_date, modified_date, query_date)
select cast(p.person_id as INT64) as person_id, cast(p.address_id as INT64) as address_id,
       upper(trim(trim(trim(coalesce(p.first_name,'') || ' ' || coalesce(p.middle_name,'')) || ' ' || coalesce(p.last_name,'')) 
            || ' ' || coalesce(p.suffix,''))) as full_name,
       coalesce(p.age_consumer,p.age_combined) as age,coalesce(p.gender_consumer,p.gender_combined) as gender,
       p.sos_id,p.reg_voter_flag,p.last_name,p.first_name,p.middle_name,p.suffix,
       p.create_date,p.modified_date, current_timestamp() as extract_date
from `demstxsp.tdp_dallasdems.person` p
where p.is_deceased = false
  and p.reg_voter_flag = true
  and p.county_fips = '113'
--limit 100  
;   
