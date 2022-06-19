
select * from bq_addresses_raw order by address_id limit 100;
select * from bq_streets; limit 100;

select distinct street_pre_dir,count(*) from bq_streets group by 1 order by 2 desc;
select distinct street_post_dir,count(*) from bq_streets group by 1 order by 2 desc;
select distinct street_type,count(*) from bq_streets group by 1 order by 2 desc;
select * from bq_streets where not (street_number ~ '^[0-9]+$');

select trim(trim(trim(trim(trim(coalesce(street_pre_dir,'') || ' ' || coalesce(street_name,'')) || ' ' || coalesce(street_type,'')) || ' ' || coalesce(street_post_dir,''))
         || ' ' || coalesce(city,'')) || ' ' || coalesce(zip,'')) as FullStreetName
from bq_streets limit 100;	

select trim(trim(trim(trim(trim(trim(coalesce(street_number,'') || ' ' || coalesce(street_pre_dir,'')) || ' ' || coalesce(street_name,'')) || ' ' || coalesce(street_type,'')) || ' ' || coalesce(street_post_dir,''))
         || ' ' || coalesce(city,'')) || ' ' || coalesce(zip,'')) as FullStreetName
from bq_streets limit 100;	

insert into bq_streets (street_pre_dir, street_name, street_type, street_post_dir, city, zip, fullstreetname)
with 
xx as (
    select upper(street_pre_dir) as street_pre_dir,
	   upper(street_name) as street_name,
	   upper(street_type) as street_type,
	   upper(street_post_dir) as street_post_dir,
       upper(city) as city,
       upper(zip) as zip
    from bq_addresses_raw
	),
yy as (
	select distinct street_pre_dir,street_name,street_type,street_post_dir,city,zip
    from xx
		group by street_pre_dir,street_name,street_type,street_post_dir,city,zip
		)
select street_pre_dir,street_name,street_type,street_post_dir,city,zip,
	trim(trim(trim(trim(trim(coalesce(street_pre_dir,'') || ' ' || coalesce(street_name,'')) || ' ' || coalesce(street_type,'')) || ' ' || coalesce(street_post_dir,''))
         || ' ' || coalesce(city,'')) || ' ' || coalesce(zip,'')) as fullstreetname
from yy
--limit 100
;
	
insert into bq_addresses (address_id, street_id, street_number, longitude, latitude)
with 
xx as (
	select address_id,street_number, longitude, latitude,
	upper(trim(trim(trim(trim(trim(coalesce(street_pre_dir,'') || ' ' || coalesce(street_name,'')) || ' ' || coalesce(street_type,'')) || ' ' || coalesce(street_post_dir,''))
         || ' ' || coalesce(city,'')) || ' ' || coalesce(zip,''))) as fullstreetname
	from bq_addresses_raw
)
select xx.address_id, s.street_id, xx.street_number, xx.longitude, xx.latitude
from xx
join bq_streets s on s.fullstreetname = xx.fullstreetname
--limit 100
;
