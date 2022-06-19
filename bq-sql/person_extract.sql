
-- Create Person Extract Table
drop table if exists `demstxdallascp.sbx_farrarb.person_extract`;
create table if not exists `demstxdallascp.sbx_farrarb.person_extract`
(
  person_id  INT64,
  address_id INT64,
  full_name	STRING,
  date_of_birth	DATE,
  gender STRING,
  sos_id STRING,
  reg_voter_status	BOOL,
  first_name	STRING,
  middle_name	STRING,
  last_name	STRING,
  suffix	STRING,
  last_primary_party STRING,
  primary_parties STRING,
  create_date	TIMESTAMP,
  modified_date	TIMESTAMP,
  query_date	TIMESTAMP
);

-- Get Person for Extract
insert into `demstxdallascp.sbx_farrarb.person_extract`
(person_id, address_id, full_name, date_of_birth, gender, sos_id, reg_voter_status, first_name, middle_name, last_name,  suffix,
 last_primary_party, primary_parties,
  create_date, modified_date, query_date)
select cast(p.person_id as INT64) as person_id, cast(p.address_id as INT64) as address_id,
       upper(trim(trim(trim(coalesce(p.first_name,'') || ' ' || coalesce(p.middle_name,'')) || ' ' || coalesce(p.last_name,'')) 
            || ' ' || coalesce(p.suffix,''))) as full_name,
       coalesce(p.date_of_birth_combined,p.date_of_birth_vf) as date_of_birth,
       coalesce(p.gender_consumer,p.gender_combined) as gender,
       p.sos_id,p.reg_voter_flag,p.first_name,p.middle_name,p.last_name,p.suffix,
       pv.last_primary_party,
       coalesce(pev.p_2022_party, '-') ||
       coalesce(pev.p_2021_party, '-') ||
       coalesce(pev.p_2020_party, '-') ||
       coalesce(pev.p_2019_party, '-') ||
       coalesce(pev.p_2018_party, '-') ||
       coalesce(pev.p_2017_party, '-') ||
       coalesce(pev.p_2016_party, '-') ||
       coalesce(pev.p_2015_party, '-') ||
       coalesce(pev.p_2014_party, '-') ||
       coalesce(pev.p_2013_party, '-') ||
       coalesce(pev.p_2012_party, '-') ||

       coalesce(pev.p_2011_party, '-') ||
       coalesce(pev.p_2010_party, '-') ||
       coalesce(pev.p_2009_party, '-') ||
       coalesce(pev.p_2008_party, '-') ||
       coalesce(pev.p_2007_party, '-') ||
       coalesce(pev.p_2006_party, '-') ||
       coalesce(pev.p_2005_party, '-') ||
       coalesce(pev.p_2004_party, '-') ||
       coalesce(pev.p_2003_party, '-') ||
       coalesce(pev.p_2002_party, '-') ||
       coalesce(pev.p_2001_party, '-') ||
       coalesce(pev.p_2000_party, '-')
       as primary_parties,
       p.create_date,p.modified_date, current_timestamp() as extract_date
from `demstxsp.tdp_dallasdems.person` p
left join `demstxsp.tdp_dallasdems.person_votes` pv on pv.person_id = p.person_id
left join `demstxsp.tdp_dallasdems.person_election_voted` pev on pev.person_id = p.person_id
where p.is_deceased = false
  and p.reg_voter_flag = true
  and p.county_fips = '113'
  --and p.person_id = '178184457'
;   

-- select * from `demstxdallascp.sbx_farrarb.person_extract`;
