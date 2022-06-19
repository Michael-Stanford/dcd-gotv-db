
-- Most recent modification to address table
select max(modified_date) from `demstxsp.tdp_dallasdems.address`;
select count(*),TIMESTAMP(DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY)) from `demstxsp.tdp_dallasdems.address` 
WHERE modified_date > TIMESTAMP(DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY));
select * from `demstxsp.tdp_dallasdems.address` where modified_date > TIMESTAMP(DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY));

-- Address Verification
select melissa_data_results from `demstxsp.tdp_dallasdems.address` where melissa_data_results is not null limit 100;
select distinct melissa_data_results,count(*) from `demstxsp.tdp_dallasdems.address` group by 1 order by 2 desc;
select melissa_data_results, address,street_number, street_pre_dir, street_name, street_type, street_post_dir, unit_type, unit
 from `demstxsp.tdp_dallasdems.address` where melissa_data_results <> 'S01' limit 100;

-- Address Types
select address_type from `demstxsp.tdp_dallasdems.address` where address_type is not null limit 100;
select distinct address_type,count(*) from `demstxsp.tdp_dallasdems.address` group by 1 order by 2 desc;

-- County ID
select * from `demstxsp.tdp_dallasdems.address` where county_fips <> '113' limit 100;
select distinct county_fips,count(*) from `demstxsp.tdp_dallasdems.address` group by 1 order by 2 desc;

-- Congress 
select distinct coalesce(cd_source, "missing") as cd_source, coalesce(us_cong_district,'missing') as us_cong_district,count(*) as count 
from `demstxsp.tdp_dallasdems.address` group by 1,2 order by 1,2 desc;

-- State House Representive 
select distinct coalesce(hd_source, "missing") as hd_source, coalesce(state_house_district,'not defined') as state_house_district,count(*) as count 
from `demstxsp.tdp_dallasdems.address` group by 1,2 order by 1,2 desc;

-- State Senator 
select distinct coalesce(sd_source, "missing") as sd_source, coalesce(state_senate_district,'not defined') as state_senate_district,count(*) as count 
from `demstxsp.tdp_dallasdems.address` group by 1,2 order by 1,2 desc;

-- Precinct 
select distinct coalesce(precinct_source, "missing") as precinct_source, coalesce(p.precinct_name,'not defined') as precinct_name,count(*) as count 
from `demstxsp.tdp_dallasdems.address` a
left join `demstxsp.tdp_dallasdems.precinct` p on p.dnc_precinct_id = a.dnc_precinct_id
group by 1,2 order by 1,2 desc;

-- Soures
select distinct cd_source,count(*) from `demstxsp.tdp_dallasdems.address` group by 1 order by 2 desc;
select distinct hd_source,count(*) from `demstxsp.tdp_dallasdems.address` group by 1 order by 2 desc;
select distinct sd_source,count(*) from `demstxsp.tdp_dallasdems.address` group by 1 order by 2 desc;
select distinct precinct_source,count(*) from `demstxsp.tdp_dallasdems.address` group by 1 order by 2 desc;
select distinct geocode_external_source_id,count(*) from `demstxsp.tdp_dallasdems.address` group by 1 order by 2 desc;
select distinct geocode_level,count(*) from `demstxsp.tdp_dallasdems.address` group by 1 order by 2 desc;

-- Address Columns
SELECT 
  column_name, data_type
  --column_name
FROM `demstxsp.tdp_dallasdems.INFORMATION_SCHEMA.COLUMNS`
where table_name = 'address' 
order by ordinal_position
;

-- Street Numbers that are not copacetic
with xx as (
select address_id, street_number, regexp_replace(regexp_replace(street_number, r" .*$", ""), r"[A-Z]","") as clean_street_number, 
   street_pre_dir, street_name, street_type, street_post_dir, unit_type, unit, address, melissa_data_results
from `demstxsp.tdp_dallasdems.address` 
where not regexp_contains(trim(street_number), r"^[0-9]+$") 
--limit 100
)
select * from xx
--where street_number = clean_street_number
;

-----------------------------------------------------------------------------------------------------------------------------
-- Not sure this is useful (skipping for now)
-- Get units at each address
with xx as (
select *, row_number() over(partition by address_id) as rn
from `demstxsp.tdp_dallasdems.address` a
where county_fips = '113' -- Dallas County
  --and address_id in ('53891115')
  --and address_id in ('42481695','42312344','4796896', '53891115')
)
select address_id, address, city, zip, unit_type, unit
from xx a
where rn = 1 
  and (unit_type is not null or unit is not null) 
--and address like '6200 Hill Crst%'
limit 100
;