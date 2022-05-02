
-- Create Unit Extract Table
drop table if exists `demstxdallascp.sbx_farrarb.unit_extract`;
create table if not exists `demstxdallascp.sbx_farrarb.unit_extract`
(
  address_id  INT64,
  address_geo_id  INT64,
  unit_type	STRING,
  unit	STRING,
  query_date	TIMESTAMP
);

-- Get Unit for Extract
insert into `demstxdallascp.sbx_farrarb.unit_extract` (address_id, address_geo_id, unit_type, unit)
with xx as (
 select cast(a.address_id as INT64) as address_id, upper(a.unit_type) as unit_type, upper(a.unit) as unit, upper(a.street_number) as street_number, 
       upper(a.street_pre_dir) as street_pre_dir, upper(a.street_name) as street_name, 
       upper(a.street_type) as street_type, upper(a.street_post_dir) as street_post_dir, upper(a.city) as city, upper(a.zip) as zip,
 from`demstxsp.tdp_dallasdems.address` a
  where a.county_fips = '113' -- Dallas County
    and a.street_number is not null and a.street_name is not null and a.city is not null and a.zip is not null
    --and upper(a.address) like '3824 CEDAR SPRINGS RD%'
)
 select a.address_id, ae.address_geo_id, a.unit_type, a.unit
  from xx a
  left join `demstxdallascp.sbx_farrarb.address_extract` ae 
    on  coalesce(ae.street_number,'') = coalesce(a.street_number,'')
    and coalesce(ae.street_pre_dir,'') = coalesce(a.street_pre_dir,'')
    and coalesce(ae.street_name,'') = coalesce(a.street_name,'')
    and coalesce(ae.street_type,'') = coalesce(a.street_type,'')
    and coalesce(ae.street_post_dir,'') = coalesce(a.street_post_dir,'')
    and coalesce(ae.city,'') = coalesce(a.city,'')
    and coalesce(ae.zip,'') = coalesce(a.zip,'')
    order by a.address_id, ae.address_geo_id
    ;
 