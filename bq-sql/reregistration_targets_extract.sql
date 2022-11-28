
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