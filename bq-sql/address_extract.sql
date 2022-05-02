-- Create Address Extract Table
drop table if exists `demstxdallascp.sbx_farrarb.address_extract`;
create table if not exists `demstxdallascp.sbx_farrarb.address_extract`
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
insert into `demstxdallascp.sbx_farrarb.address_extract` 
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

-- Review Address Extract -----------------------------------------
-- Street Numbers that are not copacetic
select * from `demstxdallascp.sbx_farrarb.address_extract` where not regexp_contains(trim(street_number), r"^[0-9]+$") ;
-- check for duplicates
select distinct full_address, count(*) from `demstxdallascp.sbx_farrarb.address_extract`  group by 1 order by 2 desc;
-- Congress 
select coalesce(us_cong_district,'missing') as us_cong_district,count(*) as count from `demstxdallascp.sbx_farrarb.address_extract` group by 1 order by 2 desc;

select * from `demstxdallascp.sbx_farrarb.address_extract` where us_cong_district is null;

select a.address_id, a.address, a.us_cong_district, a.state_house_district, a.state_senate_district, pr.precinct_name ,
       p.us_cong_district, p.state_house_district, p.state_senate_district, p.van_precinct_name    
from `demstxsp.tdp_dallasdems.address` a
left join `demstxsp.tdp_dallasdems.person` p on p.address_id = a.address_id
left join `demstxsp.tdp_dallasdems.precinct` pr on pr.dnc_precinct_id = a.dnc_precinct_id
where a.street_number =  '8004' and
      upper(a.street_name) = 'CHANCELLOR' and 
      upper(a.street_type) = 'ROW' and 
      upper(a.city) = 'DALLAS' and 
      upper(a.zip) = '75247'
;
select * from  `demstxsp.tdp_dallasdems.person`    where address_id = '152927480';


-- State House Representive 
select coalesce(state_house_district,'missing') as us_cong_district,count(*) as count from `demstxdallascp.sbx_farrarb.address_extract` group by 1 order by 2 desc;
-- State Senator 
select coalesce(state_senate_district,'missing') as us_cong_district,count(*) as count from `demstxdallascp.sbx_farrarb.address_extract` group by 1 order by 2 desc;
-- Precinct 
select coalesce(precinct_name,'missing') as us_cong_district,count(*) as count from `demstxdallascp.sbx_farrarb.address_extract` group by 1 order by 2 desc;

