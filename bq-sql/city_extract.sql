
-- Create City Extract Table
drop table if exists `demstxdallascp.sbx_farrarb.city_extract`;
create table if not exists `demstxdallascp.sbx_farrarb.city_extract`
(
  city STRING
);

-- Get City for Extract
insert into `demstxdallascp.sbx_farrarb.city_extract`
select distinct city from `demstxdallascp.sbx_farrarb.address_extract` 
order by city;


with x as (
select distinct upper(city) as city
from `demstxsp.tdp_dallasdems.address`  
)
select x.city, y.city
from x
left join  `demstxdallascp.sbx_farrarb.city_extract` y on x.city = y.city
order by x.city;