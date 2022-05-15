insert into address_supplement (address_geo_id, precinct_name)
select distinct address_geo_id, precinct_name
from bq_address_extract
where address_geo_id is not null and precinct_name is not null
group by address_geo_id, precinct_name
;

update address_supplement a
   set property_type = 'A'
where exists
  (select distinct address_geo_id
     from bq_unit_extract v
	where v.address_geo_id = a.address_geo_id
      and v.unit_type = 'APT')
;

with xx as (
select distinct address_geo_id, count(*) as count
from bq_unit_extract
group by address_geo_id
)
--select * from xx where count >= 12 and count <= 48;
update address_supplement a
set property_type = 'M' 
where exists 
  (select xx.address_geo_id from xx 
	where xx.address_geo_id = a.address_geo_id 
      and count >= 12 and count <= 48)
;

with xx as (
select distinct address_geo_id, count(*) as count
from bq_unit_extract
group by address_geo_id
)
--select * from xx where count < 12;
update address_supplement a
   set property_type = 'S'
where exists
  (select address_geo_id from xx 
	where xx.address_geo_id = a.address_geo_id 
      and count < 12)
;

--select distinct property_type,count(*) from address_supplement group by property_type;
--select * from address_supplement;