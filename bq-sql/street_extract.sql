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

-- Review Address Extract -----------------------------------------
-- Street Numbers that are not copacetic
select * from `demstxdallascp.gotv_extracts.address_extract` where not regexp_contains(trim(street_number), r"^[0-9]+$") ;
-- check for duplicates
select distinct full_address, count(*) from `demstxdallascp.gotv_extracts.address_extract`  group by 1 order by 2 desc;
-- Congress 
select coalesce(us_cong_district,'missing') as us_cong_district,count(*) as count from `demstxdallascp.gotv_extracts.address_extract` group by 1 order by 2 desc;

select * from `demstxdallascp.gotv_extracts.address_extract` where us_cong_district is null;

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
select coalesce(state_house_district,'missing') as us_cong_district,count(*) as count from `demstxdallascp.gotv_extracts.address_extract` group by 1 order by 2 desc;
-- State Senator 
select coalesce(state_senate_district,'missing') as us_cong_district,count(*) as count from `demstxdallascp.gotv_extracts.address_extract` group by 1 order by 2 desc;
-- Precinct 
select coalesce(precinct_name,'missing') as us_cong_district,count(*) as count from `demstxdallascp.gotv_extracts.address_extract` group by 1 order by 2 desc;

