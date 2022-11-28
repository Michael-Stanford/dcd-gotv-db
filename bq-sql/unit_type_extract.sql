 
-- Create Unit Type Extract Table
drop table if exists `demstxdallascp.gotv_extracts.unit_type_extract`;
create table if not exists `demstxdallascp.gotv_extracts.unit_type_extract`
(
  unit_type STRING
);

-- Get Unit Type for Extract
insert into `demstxdallascp.gotv_extracts.unit_type_extract` (unit_type)
select distinct unit_type
from `demstxdallascp.gotv_extracts.unit_extract` 
where unit_type is not null 
order by unit_type
;

delete from `demstxdallascp.gotv_extracts.unit_type_extract`
where safe_cast(unit_type as int64) is not null;

delete from `demstxdallascp.gotv_extracts.unit_type_extract`
where unit_type in (select city as unit_type from `demstxdallascp.gotv_extracts.city_extract`);

delete from `demstxdallascp.gotv_extracts.unit_type_extract`
where unit_type in ('1112 PHASE','KINGSBURY','XXXX');

-- select * from `demstxdallascp.gotv_extracts.unit_type_extract` order by unit_type;