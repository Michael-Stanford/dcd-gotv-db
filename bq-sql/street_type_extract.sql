
-- Create Street Type Extract Table
drop table if exists `demstxdallascp.sbx_farrarb.street_type_extract`;
create table if not exists `demstxdallascp.sbx_farrarb.street_type_extract`
(
  street_type STRING
);

-- Get Street Type for Extract
insert into `demstxdallascp.sbx_farrarb.street_type_extract` (street_type)
select distinct street_type
from `demstxdallascp.sbx_farrarb.address_extract` 
where street_type is not null 
order by street_type
;

-- select * from `demstxdallascp.sbx_farrarb.street_type_extract` order by street_type;