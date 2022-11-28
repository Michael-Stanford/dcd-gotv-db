
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


with x as (
select distinct upper(city) as city
from `demstxsp.tdp_dallasdems.address`  
)
select x.city, y.city
from x
left join  `demstxdallascp.gotv_extracts.city_extract` y on x.city = y.city
order by x.city;