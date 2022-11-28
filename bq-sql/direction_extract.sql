
-- Create Direction Extract Table
drop table if exists `demstxdallascp.gotv_extracts.direction_extract`;
create table if not exists `demstxdallascp.gotv_extracts.direction_extract`
(
  street_dir STRING
);

-- Get City for Extract
insert into `demstxdallascp.gotv_extracts.direction_extract` (street_dir)
with xx as (
  select distinct street_pre_dir as street_dir from `demstxdallascp.gotv_extracts.address_extract` 
  union all 
  select distinct street_post_dir as street_dir from `demstxdallascp.gotv_extracts.address_extract`
)
select distinct xx.street_dir 
from xx
where xx.street_dir is not null
order by street_dir
;

-- select * from `demstxdallascp.gotv_extracts.direction_extract`;