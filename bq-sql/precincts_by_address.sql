
-- Create Precincts by Address Table
drop table if exists `demstxdallascp.sbx_farrarb.precincts_by_address`;
create table if not exists `demstxdallascp.sbx_farrarb.precincts_by_address`
(
  full_address	STRING,
  precinct_name	STRING,
  count  INT64
);

-- Extract Precincts by Address
insert into `demstxdallascp.sbx_farrarb.precincts_by_address` (full_address, precinct_name, count)
with xx as (
  select 
       regexp_replace(regexp_replace(trim(street_number), r" .*$", ""), r"[A-Z]","") as street_number,
       street_pre_dir, street_name, street_type, street_post_dir, city, zip, dnc_precinct_id
  from `demstxsp.tdp_dallasdems.address`
  --where address_id in ('42481695','42312344','4796896', '53891115')
),
yy as (
  select a.*,
       upper(trim(trim(trim(trim(trim(trim(coalesce(a.street_number,'') || ' ' || coalesce(a.street_pre_dir,'')) || ' ' || coalesce(a.street_name,'')) || ' ' || coalesce(a.street_type,'')) 
             || ' ' || coalesce(a.street_post_dir,'')) || ' ' || coalesce(a.city,'')) || ' ' || coalesce(a.zip,''))) as full_address
  from xx a
)
select distinct a.full_address, pr.precinct_name, count(*) as count
from yy a
inner join `demstxsp.tdp_dallasdems.precinct` pr on pr.dnc_precinct_id = a.dnc_precinct_id
group by 1,2 
order by 1,2
;

-- Validate Precincts by Address Table
select full_address, count(*) from `demstxdallascp.sbx_farrarb.precincts_by_address` group by 1 order by 2 desc;
select * from `demstxdallascp.sbx_farrarb.precincts_by_address` where full_address = '2111 BENNETT AVE DALLAS 75206';


select dnc_precinct_id,* from `demstxsp.tdp_dallasdems.address`
where upper(address) like '3824 CEDAR SPRINGS RD%'
; 