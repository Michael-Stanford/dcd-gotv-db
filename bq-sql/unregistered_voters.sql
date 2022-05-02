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
    t.* except (to_address_id, dnc_2020_dem_party_support,clarity_2020_turnout),
    phone_1.phone_number phone_1,
    phone_2.phone_number phone_2,
    phone_3.phone_number phone_3,
    phone_4.phone_number phone_4
from `demstxsp.tdp_dallasdems.complete_reregistration_targets` t
left join phone_1 on t.person_id = phone_1.person_id
left join phone_2 on t.person_id = phone_2.person_id
left join phone_3 on t.person_id = phone_3.person_id
left join phone_4 on t.person_id = phone_4.person_id
where
    lower(t.county_name) in ('dallas')