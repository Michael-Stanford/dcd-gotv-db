-- ---------------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE demstxdallascp.gotv_extracts.create_address_extract()
-- ---------------------------------------------------------------------------------------
BEGIN
drop table if exists `demstxdallascp.gotv_extracts.address_extract`;
create table if not exists `demstxdallascp.gotv_extracts.address_extract`
(
  address_geo_id  INT64,
  city	STRING,
  zip	STRING,
  zip4	STRING,
  street_number	STRING,
  street_id INT64,
  street_pre_dir	STRING,
  street_name	STRING,
  street_type	STRING,
  street_post_dir	STRING,
  melissa_data_results	STRING, 
  address_type	STRING,
  us_cong_district	STRING,
  state_house_district	STRING,
  state_senate_district	STRING,
  precinct_name	STRING,
  longitude	NUMERIC,
  latitude	NUMERIC,
  full_street_name	STRING,
  full_address	STRING,
  create_date	TIMESTAMP,
  modified_date	TIMESTAMP,
  query_date	TIMESTAMP
);

-- Get Address for Extract
insert into `demstxdallascp.gotv_extracts.address_extract` 
(address_geo_id, city, zip, zip4, street_number, street_pre_dir, street_name, street_type, street_post_dir, melissa_data_results, address_type, 
 us_cong_district, state_house_district, state_senate_district, precinct_name, longitude, latitude, full_street_name, full_address, create_date, modified_date, query_date)
with xx as (
  select upper(trim(a.city)) as city, upper(trim(a.zip)) as zip, upper(a.zip4) as zip4, upper(trim(a.street_pre_dir)) as street_pre_dir, 
       upper(trim(a.street_name)) as street_name, upper(a.street_type) as street_type, upper(trim(a.street_post_dir)) as street_post_dir, 
       a.melissa_data_results, a.address_type, upper(a.us_cong_district) as us_cong_district, upper(a.state_house_district) as state_house_district, 
       upper(a.state_senate_district) as state_senate_district, a.dnc_precinct_id, a.longitude, a.latitude, a.create_date, a.modified_date,
       cast(address_id as int64) as address_geo_id, regexp_replace(regexp_replace(trim(street_number), r" .*$", ""), r"[A-Z]","") as street_number
  from `demstxsp.tdp_dallasdems.address` a
  where county_fips = '113' -- Dallas County
    and street_number is not null and street_name is not null and city is not null and zip is not null
  --and address_id in ('53891115')
  --and address_id in ('42481695','42312344','4796896', '53891115')
),
yy as (
  select *, row_number() over(partition by street_number, street_pre_dir, street_name, street_type, street_post_dir, city, zip) as rn
  from xx
)
select address_geo_id, a.city, a.zip, a.zip4, a.street_number, a.street_pre_dir, a.street_name, a.street_type, a.street_post_dir, 
       a.melissa_data_results, a.address_type, a.us_cong_district, a.state_house_district, a.state_senate_district, p.precinct_name, a.longitude, a.latitude,
       upper(trim(trim(trim(trim(trim(coalesce(a.street_pre_dir,'') || ' ' || coalesce(a.street_name,'')) || ' ' || coalesce(a.street_type,'')) 
             || ' ' || coalesce(a.street_post_dir,'')) || ' ' || coalesce(a.city,'')) || ' ' || coalesce(a.zip,''))) as full_street_name,
       upper(trim(trim(trim(trim(trim(trim(coalesce(a.street_number,'') || ' ' || coalesce(a.street_pre_dir,'')) || ' ' || coalesce(a.street_name,'')) || ' ' || coalesce(a.street_type,'')) 
             || ' ' || coalesce(a.street_post_dir,'')) || ' ' || coalesce(a.city,'')) || ' ' || coalesce(a.zip,''))) as full_address,
       a.create_date, a.modified_date, current_timestamp() as query_date
from yy a 
left join `demstxsp.tdp_dallasdems.precinct` p on p.dnc_precinct_id = a.dnc_precinct_id
where rn = 1 
order by address_geo_id
;
END
;
-- ---------------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE demstxdallascp.gotv_extracts.create_city_extract()
-- ---------------------------------------------------------------------------------------
BEGIN
-- Create City Extract Table
drop table if exists `demstxdallascp.gotv_extracts.city_extract`;
create table if not exists `demstxdallascp.gotv_extracts.city_extract`
(
  city STRING
);

-- Get City for Extract
insert into `demstxdallascp.gotv_extracts.city_extract`
select distinct city from `demstxdallascp.gotv_extracts.address_extract` 
order by city;
END
;
-- ---------------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE demstxdallascp.gotv_extracts.create_direction_extract()
-- ---------------------------------------------------------------------------------------
BEGIN
-- Create Direction Extract Table
drop table if exists `demstxdallascp.gotv_extracts.direction_extract`;
create table if not exists `demstxdallascp.gotv_extracts.direction_extract`
(
  street_dir STRING
);

-- Get City for Extract
insert into `demstxdallascp.gotv_extracts.direction_extract` (street_dir)
with xx as (
  select distinct street_pre_dir as street_dir from `demstxdallascp.gotv_extracts.address_extract` 
  union all 
  select distinct street_post_dir as street_dir from `demstxdallascp.gotv_extracts.address_extract`
)
select distinct xx.street_dir 
from xx
where xx.street_dir is not null
order by street_dir
;
END
;
-- ---------------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE demstxdallascp.gotv_extracts.create_person_extract()
-- ---------------------------------------------------------------------------------------
BEGIN
-- Create Person Extract Table
drop table if exists `demstxdallascp.gotv_extracts.person_extract`;
create table if not exists `demstxdallascp.gotv_extracts.person_extract`
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
insert into `demstxdallascp.gotv_extracts.person_extract`
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
; 
END
;
-- ---------------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE demstxdallascp.gotv_extracts.create_precinct_extract()
-- ---------------------------------------------------------------------------------------
BEGIN
-- Create Precinct Table
drop table if exists `demstxdallascp.gotv_extracts.precinct_extract`;
create table if not exists `demstxdallascp.gotv_extracts.precinct_extract`
(
  precinct_name	STRING,
  us_cong_district	STRING,
  state_house_district	STRING,
  state_senate_district	STRING,
  query_date	TIMESTAMP
);

-- Extract Precinct Table
insert into `demstxdallascp.gotv_extracts.precinct_extract` 
  (precinct_name, us_cong_district, state_house_district, state_senate_district, query_date)
with us_cong_district_rn as (
  select distinct precinct_name, us_cong_district, count(*) as count 
  from `demstxdallascp.gotv_extracts.address_extract`
  where precinct_name is not null and us_cong_district is not null
  group by 1,2
), 
us_cong_district_count as (
  select precinct_name, us_cong_district, count,
  row_number() over(partition by precinct_name order by count desc) as rn 
  from us_cong_district_rn
),
state_house_district_rn as (
  select distinct precinct_name, state_house_district, count(*) as count 
  from `demstxdallascp.gotv_extracts.address_extract`
  where precinct_name is not null and state_house_district is not null
  group by 1,2
),
state_house_district_count as (
  select precinct_name, state_house_district, count,
  row_number() over(partition by precinct_name order by count desc) as rn 
  from state_house_district_rn
),
state_senate_district_rn as (
  select distinct precinct_name, state_senate_district, count(*) as count 
  from `demstxdallascp.gotv_extracts.address_extract`
  where precinct_name is not null and state_senate_district is not null
  group by 1,2
),
state_senate_district_count as (
  select precinct_name, state_senate_district, count,
  row_number() over(partition by precinct_name order by count desc) as rn 
  from state_senate_district_rn
),
precincts as (
  select distinct precinct_name 
  from `demstxdallascp.gotv_extracts.address_extract`
  where precinct_name is not null
)
select p.precinct_name, uc.us_cong_district, sh.state_house_district, ss.state_senate_district, 
       current_timestamp() as query_date
from precincts p
left join us_cong_district_count uc on uc.precinct_name = p.precinct_name and uc.rn = 1
left join state_house_district_count sh on sh.precinct_name = p.precinct_name and sh.rn = 1
left join state_senate_district_count ss on ss.precinct_name = p.precinct_name and ss.rn = 1
order by 1,2,3,4
;
END
;
-- ---------------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE demstxdallascp.gotv_extracts.create_reregistration_targets_extract()
-- ---------------------------------------------------------------------------------------
BEGIN
-- Create Re-registration Targets Extract Table
drop table if exists `demstxdallascp.gotv_extracts.reregistration_targets_extract`;
create table if not exists `demstxdallascp.gotv_extracts.reregistration_targets_extract`
(
  person_id	STRING,
  to_address_id STRING,
  first_name	STRING,
  last_name	STRING,
  address	STRING,
  address_2	STRING,
  city	STRING,
  state	STRING,
  zip	STRING,
  zip4	STRING,
  county_name	STRING,
  van_precinct_name	STRING,
  state_house_district	STRING,
  target_type	STRING,
  phone_1	STRING,
  phone_2	STRING,
  phone_3	STRING,
  phone_4	STRING,
  query_date	TIMESTAMP
);

insert into `demstxdallascp.gotv_extracts.reregistration_targets_extract`
with phone_1 as (
    select 
        person_id,
        phone_number,
        person_phone_quality_rank
    from `demstxsp.tdp_dallasdems.person_phone_derived`
    where 
        person_phone_quality_rank = 1
        and dnc_2020_phone_quality_score > 40
), phone_2 as (
    select 
        person_id,
        phone_number,
        person_phone_quality_rank
    from `demstxsp.tdp_dallasdems.person_phone_derived`
    where 
        person_phone_quality_rank = 2  
        and dnc_2020_phone_quality_score > 40  
), phone_3 as (
    select 
        person_id,
        phone_number,
        person_phone_quality_rank
    from `demstxsp.tdp_dallasdems.person_phone_derived`
    where 
        person_phone_quality_rank = 3
        and dnc_2020_phone_quality_score > 40
), phone_4 as (
    select 
        person_id,
        phone_number,
        person_phone_quality_rank
    from `demstxsp.tdp_dallasdems.person_phone_derived`
    where 
        person_phone_quality_rank = 4
        and dnc_2020_phone_quality_score > 40
)

select
    t.* except (dnc_2020_dem_party_support,clarity_2020_turnout),
    phone_1.phone_number as phone_1, phone_2.phone_number as phone_2, 
    phone_3.phone_number as phone_3, phone_4.phone_number as phone_4, 
    current_timestamp() as query_date
from `demstxsp.tdp_dallasdems.complete_reregistration_targets` t
left join phone_1 on t.person_id = phone_1.person_id
left join phone_2 on t.person_id = phone_2.person_id
left join phone_3 on t.person_id = phone_3.person_id
left join phone_4 on t.person_id = phone_4.person_id
where
    lower(t.county_name) in ('dallas')
    and  target_type != 'suspense_voters'
;
END
;
-- ---------------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE demstxdallascp.gotv_extracts.create_street_extract()
-- ---------------------------------------------------------------------------------------
BEGIN
-- Create Street Extract Table
drop table if exists `demstxdallascp.gotv_extracts.street_extract`;
create table if not exists `demstxdallascp.gotv_extracts.street_extract`
(
  street_id INT64,
  street_pre_dir STRING,
  street_name STRING,
  street_type STRING,
  street_post_dir STRING,
  city STRING,
  zip STRING,
  full_street_name STRING,
  query_date TIMESTAMP
);

-- Get Street for Extract
insert into `demstxdallascp.gotv_extracts.street_extract` 
(street_pre_dir, street_name, street_type, street_post_dir, city, zip, full_street_name, query_date)
with xx as (
    select distinct street_pre_dir, street_name, street_type, street_post_dir, city, zip 
    from `demstxdallascp.gotv_extracts.address_extract`
    where street_name is not null
    group by street_pre_dir, street_name, street_type, street_post_dir, city, zip
    order by street_pre_dir, street_name, street_type, street_post_dir, city, zip
)
select street_pre_dir, street_name, street_type, street_post_dir, city, zip, 
   trim(trim(trim(trim(trim(coalesce(a.street_pre_dir,'') || ' ' || coalesce(a.street_name,'')) || ' ' || coalesce(a.street_type,'')) 
             || ' ' || coalesce(a.street_post_dir,'')) || ' ' || coalesce(a.city,'')) || ' ' || coalesce(a.zip,'')) as full_street_name,
   (select max(query_date) from `demstxdallascp.gotv_extracts.address_extract`) as query_date
from xx a
--limit 100
;

-- Set Street ID
update `demstxdallascp.gotv_extracts.street_extract` s
set s.street_id = 
   (select min(address_geo_id) from `demstxdallascp.gotv_extracts.address_extract` a where a.full_street_name = s.full_street_name)
where s.full_street_name is not null
;

-- Update Address Extract with Street ID
update `demstxdallascp.gotv_extracts.address_extract` a
set street_id = 
   (select distinct street_id from `demstxdallascp.gotv_extracts.street_extract` s where a.full_street_name = s.full_street_name)
where a.full_address is not null
;
END
;
-- ---------------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE demstxdallascp.gotv_extracts.create_street_type_extract()
-- ---------------------------------------------------------------------------------------
BEGIN
-- Create Street Type Extract Table
drop table if exists `demstxdallascp.gotv_extracts.street_type_extract`;
create table if not exists `demstxdallascp.gotv_extracts.street_type_extract`
(
  street_type STRING
);

-- Get Street Type for Extract
insert into `demstxdallascp.gotv_extracts.street_type_extract` (street_type)
select distinct street_type
from `demstxdallascp.gotv_extracts.address_extract` 
where street_type is not null 
order by street_type
;
END
;
-- ---------------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE demstxdallascp.gotv_extracts.create_streets_by_precinct_extract()
-- ---------------------------------------------------------------------------------------
BEGIN
-- Create Street Extract Table
drop table if exists `demstxdallascp.gotv_extracts.streets_by_precinct_extract`;
create table if not exists `demstxdallascp.gotv_extracts.streets_by_precinct_extract`
(
    street_id INT64,
    precincts STRING
);

-- Get Street for Extract
insert into `demstxdallascp.gotv_extracts.streets_by_precinct_extract` (street_id, precincts)
with xx as (
	select distinct street_id, precinct_name
	from `demstxdallascp.gotv_extracts.address_extract`
	group by street_id, precinct_name
	order by street_id, precinct_name
),
yy as (
SELECT street_id, string_agg(precinct_name, ', ') AS precincts
FROM   xx
GROUP  BY 1
)
select distinct street_id, precincts 
from yy
;
END
;
-- ---------------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE demstxdallascp.gotv_extracts.create_unit_extract()
-- ---------------------------------------------------------------------------------------
BEGIN
-- Create Unit Extract Table
drop table if exists `demstxdallascp.gotv_extracts.unit_extract`;
create table if not exists `demstxdallascp.gotv_extracts.unit_extract`
(
  address_id  INT64,
  address_geo_id  INT64,
  unit_type	STRING,
  unit	STRING,
  query_date	TIMESTAMP
);

-- Get Unit for Extract
insert into `demstxdallascp.gotv_extracts.unit_extract` (address_id, address_geo_id, unit_type, unit, query_date)
with xx as (
 select cast(a.address_id as INT64) as address_id, upper(a.unit_type) as unit_type, upper(a.unit) as unit, upper(a.street_number) as street_number, 
       upper(a.street_pre_dir) as street_pre_dir, upper(a.street_name) as street_name, 
       upper(a.street_type) as street_type, upper(a.street_post_dir) as street_post_dir, upper(a.city) as city, upper(a.zip) as zip,
 from `demstxsp.tdp_dallasdems.address` a
  where a.county_fips = '113' -- Dallas County
    and a.street_number is not null and a.street_name is not null and a.city is not null and a.zip is not null
    --and upper(a.address) like '3824 CEDAR SPRINGS RD%'
    --and a.address_id = '53891115'
), yy as (
 select a.address_id, ae.address_geo_id, a.unit_type, a.unit
  from xx a
  left join `demstxdallascp.gotv_extracts.address_extract` ae 
    on  coalesce(ae.street_number,'') = coalesce(a.street_number,'')
    and coalesce(ae.street_pre_dir,'') = coalesce(a.street_pre_dir,'')
    and coalesce(ae.street_name,'') = coalesce(a.street_name,'')
    and coalesce(ae.street_type,'') = coalesce(a.street_type,'')
    and coalesce(ae.street_post_dir,'') = coalesce(a.street_post_dir,'')
    and coalesce(ae.city,'') = coalesce(a.city,'')
    and coalesce(ae.zip,'') = coalesce(a.zip,'')
    order by a.address_id, ae.address_geo_id
), zz as (
select distinct address_id, address_geo_id, unit_type, unit 
from yy a  
group by 1,2,3,4
)
select address_id, address_geo_id, unit_type, unit, current_timestamp() as query_date
from zz
;
END
;
-- ---------------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE demstxdallascp.gotv_extracts.create_unit_type_extract()
-- ---------------------------------------------------------------------------------------
BEGIN
-- Create Unit Type Extract Table
drop table if exists `demstxdallascp.gotv_extracts.unit_type_extract`;
create table if not exists `demstxdallascp.gotv_extracts.unit_type_extract`
(
  unit_type STRING
);

-- Get Unit Type for Extract
insert into `demstxdallascp.gotv_extracts.unit_type_extract` (unit_type)
select distinct unit_type
from `demstxdallascp.gotv_extracts.unit_extract` 
where unit_type is not null 
order by unit_type
;

delete from `demstxdallascp.gotv_extracts.unit_type_extract`
where safe_cast(unit_type as int64) is not null;

delete from `demstxdallascp.gotv_extracts.unit_type_extract`
where unit_type in (select city as unit_type from `demstxdallascp.gotv_extracts.city_extract`);

delete from `demstxdallascp.gotv_extracts.unit_type_extract`
where unit_type in ('1112 PHASE','KINGSBURY','XXXX');
END
;
