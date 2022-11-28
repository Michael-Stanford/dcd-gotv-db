with xx as
(
select distinct street_pre_dir as dir
from bq_street_extract
union
select distinct street_post_dir as dir
from bq_street_extract
	)
select 	dir from xx order by 1
;

select distinct street_type
from bq_street_extract
order by 1
;

select * from Get_StreetTypes();
select * from Get_StreetDirections();

select table_schema,
       table_name,
       ordinal_position as position,
       column_name,
       data_type,
       case when character_maximum_length is not null
            then character_maximum_length
            else numeric_precision end as max_length,
       is_nullable,
       column_default as default_value
from information_schema.columns
where table_name = 'bq_street_extract'
order by table_schema, 
         table_name,
         ordinal_position
limit 100;

select column_name, data_type
from information_schema.columns
where table_name = 'address_supplement'
;

select * from bq_street_extract
where street_pre_dir is not null  
  and street_post_dir is not null 
  --and street_type is not null 
;

select * from bq_street_extract
where (street_pre_dir is null or street_pre_dir = 'S') 
  and street_name = 'COUNTRY CLUB'
  and (street_post_dir is null or street_post_dir = 'E') 
  and street_type = 'RD'
  and city = 'GARLAND'
  and zip = '75040'
;


select * from bq_street_extract
where street_name = 'CUSTER'
;

select * from bq_address_extract where street_id = 218130805;
select * from bq_address_extract where address_geo_id = 227841713;

select * from lookup_street(null, 'COUNTRY CLUB', 'E', 'RD', 'GARLAND', '75040');
select * from lookup_street('S', 'COUNTRY CLUB', 'E', 'RD', 'GARLAND', '75040');
select * from lookup_street('S', 'STATE HIGHWAY 121', 'N', null, 'COPPELL', '75019');

select * from lookup_street(null, 'CUSTER', null, 'RD', 'RICHARDSON', '75080');


select * from lookup_geo_address(227841713, '800');

select * from Get_StreetTypes();
select * from Get_StreetDirections();

select * from bq_address_extract where address_geo_id = 227841713;

select * from insertupdate_addresssupplement(227841713,'A',null,3,115,false,'A-GRADE POINT','Chuck CHICHLER','555-777-1212');
select * from Get_Address_Supplement(101229588);
select * from address_supplement where address_geo_id = 227841713;
select count(*) from address_supplement;
delete from address_supplement;

select * from Get_Address_Supplements('2901',null,null);
select * from Get_Address_Supplements(null,'A',null);

select * from bq_address_extract where street_pre_dir is not null and street_post_dir is not null  and street_type is not null limit 10;
