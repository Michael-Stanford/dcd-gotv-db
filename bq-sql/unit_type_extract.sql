 
-- Create Unit Type Extract Table
drop table if exists `demstxdallascp.sbx_farrarb.unit_type_extract`;
create table if not exists `demstxdallascp.sbx_farrarb.unit_type_extract`
(
  unit_type STRING
);

-- Get Unit Type for Extract
insert into `demstxdallascp.sbx_farrarb.unit_type_extract` (unit_type)
select distinct unit_type
from `demstxdallascp.sbx_farrarb.unit_extract` 
where unit_type is not null 
order by unit_type
;

delete from `demstxdallascp.sbx_farrarb.unit_type_extract`
where safe_cast(unit_type as int64) is not null;

delete from `demstxdallascp.sbx_farrarb.unit_type_extract`
where unit_type in (select city as unit_type from `demstxdallascp.sbx_farrarb.city_extract`);

delete from `demstxdallascp.sbx_farrarb.unit_type_extract`
where unit_type in ('1112 PHASE','KINGSBURY','XXXX');

-- select * from `demstxdallascp.sbx_farrarb.unit_type_extract` order by unit_type;