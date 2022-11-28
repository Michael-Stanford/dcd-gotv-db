-- Create Street Extract Table
drop table if exists `demstxdallascp.gotv_extracts.streets_by_precinct_extract`;
create table if not exists `demstxdallascp.gotv_extracts.streets_by_precinct_extract`
(
    street_id INT64,
    precincts STRING
);

-- Get Street for Extract
insert into `demstxdallascp.gotv_extracts.streets_by_precinct_extract` (street_id, precincts)
with xx as (
	select distinct street_id, precinct_name
	from `demstxdallascp.gotv_extracts.address_extract`
	group by street_id, precinct_name
	order by street_id, precinct_name
),
yy as (
SELECT street_id, string_agg(precinct_name, ', ') AS precincts
FROM   xx
GROUP  BY 1
)
select distinct street_id, precincts 
from yy
;

select * from `demstxdallascp.gotv_extracts.streets_by_precinct_extract`;

select ae.street_id,ae.full_street_name,sbpe.precincts
	from `demstxdallascp.gotv_extracts.address_extract` ae
left join `demstxdallascp.gotv_extracts.streets_by_precinct_extract` sbpe
  on sbpe.street_id = ae.street_id
where ae.full_street_name like '%SHADY CREEK%'
;


