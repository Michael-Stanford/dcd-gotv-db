
-- Create Street Type Extract Table
drop table if exists `demstxdallascp.gotv_extracts.street_type_extract`;
create table if not exists `demstxdallascp.gotv_extracts.street_type_extract`
(
  street_type STRING
);

-- Get Street Type for Extract
insert into `demstxdallascp.gotv_extracts.street_type_extract` (street_type)
select distinct street_type
from `demstxdallascp.gotv_extracts.address_extract` 
where street_type is not null 
order by street_type
;

-- select * from `demstxdallascp.gotv_extracts.street_type_extract` order by street_type;