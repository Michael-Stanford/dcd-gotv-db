
-- Create Precinct Table
drop table if exists `demstxdallascp.sbx_farrarb.precinct_extract`;
create table if not exists `demstxdallascp.sbx_farrarb.precinct_extract`
(
  precinct_name	STRING,
  us_cong_district	STRING,
  state_house_district	STRING,
  state_senate_district	STRING,
  query_date	TIMESTAMP
);

-- Extract Precinct Table
insert into `demstxdallascp.sbx_farrarb.precinct_extract` 
  (precinct_name, us_cong_district, state_house_district, state_senate_district, query_date)
with us_cong_district_rn as (
  select distinct precinct_name, us_cong_district, count(*) as count 
  from `demstxdallascp.sbx_farrarb.address_extract`
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
  from `demstxdallascp.sbx_farrarb.address_extract`
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
  from `demstxdallascp.sbx_farrarb.address_extract`
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
  from `demstxdallascp.sbx_farrarb.address_extract`
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

select * from `demstxdallascp.sbx_farrarb.precinct_extract`;
