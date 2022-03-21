select streetnumber, street_key, streetbuilding, unit_type, unit
from "Voters"
where streetnumber is not null and street_key is not null
  --and (
	  --unit_type is not null 
	  --or 
	  --unit is not null 
	  --or 
	  --streetbuilding is not null
	  --)
	  and streetnumber = 306 and street_key = 9237
--fetch first 100 rows only
;
select * from streetbuildings;
select * from unit_types;
select * from streetbuildings;
	  
select a.streetnumber, s.fullstreetname, v.unit_type, v.unit
from addresses a
inner join "Voters" v
  on a.streetnumber = v.streetnumber and a.street_key = v.street_key
inner join "Streets" s
  on a.street_key = s.street_key
where a.property_code = 'A'
order by fullstreetname, streetnumber
fetch first 100 rows only
;

select distinct a.streetnumber, a.street_key, s.fullstreetname,count(*)
from addresses a
inner join "Streets" s on a.street_key = s.street_key
inner join "Voters" v on a.street_key = v.street_key and a.streetnumber = v.streetnumber 
where a.property_code = 'M' --and a.streetnumber = '3225'
group by a.streetnumber, a.street_key, s.fullstreetname
order by 4 
--order by a.streetnumber, a.street_key, s.fullstreetname
;

select distinct streetnumber,street_key,count(*)
from "Voters"
group by streetnumber,street_key
order by 3 desc
;
select * from "Streets" where street_key = 19865;
select * from "Voters" where streetnumber = 3225 and street_key = 19865;
select * from "addresses" where streetnumber = 3225 and street_key = 19865;
select property_code,count(*) from addresses group by property_code;

select v.streetnumber, v.street_key, s.fullstreetname, v.precinct, v.firstname, v.lastname, v.unit_type, v.unit, v.streetbuilding
from "Voters" v
left join addresses a on v.streetnumber = a.streetnumber and v.street_key = a.street_key
left join "Streets" s on v.street_key = s.street_key
where a.property_code = 'U'
  --and precinct = '2501'
order by precinct, fullstreetname, streetnumber
;

select distinct v.streetnumber, s.fullstreetname, v.street_key, v.precinct, v.unit_type, v.unit, v.streetbuilding,count(*) as count
from "Voters" v
left join addresses a on v.streetnumber = a.streetnumber and v.street_key = a.street_key
left join "Streets" s on v.street_key = s.street_key
where a.property_code = 'U'
  --and precinct = '2501'
group by v.streetnumber, s.fullstreetname, v.street_key, v.precinct, v.unit_type, v.unit, v.streetbuilding
order by precinct, fullstreetname, streetnumber
;

select distinct v.streetnumber, s.fullstreetname, v.street_key, v.precinct,count(*) as count
from "Voters" v
left join addresses a on v.streetnumber = a.streetnumber and v.street_key = a.street_key
left join "Streets" s on v.street_key = s.street_key
where a.property_code = 'U'
  --and precinct = '2222'
group by v.streetnumber, s.fullstreetname, v.street_key, v.precinct
order by precinct, fullstreetname, streetnumber
;

-- ------------------------------------------------------------------------------
-- Identify Unknown Property Types
-- ------------------------------------------------------------------------------
with xx as (
select distinct streetnumber, street_key, count(*) as count
from "Voters"
where streetnumber is not null and street_key is not null
group by streetnumber, street_key
)
select xx.streetnumber, s.fullstreetname, xx.street_key, xx.count, a.property_code
from xx
left join addresses a on xx.streetnumber = a.streetnumber and xx.street_key = a.street_key
left join "Streets" s on xx.street_key = s.street_key
where property_code = 'U'
order by count desc
;

-- ------------------------------------------------------------------------------
-- View Voter details at Unknown Property Types
-- ------------------------------------------------------------------------------
with xx as (
select distinct streetnumber, street_key, count(*) as count
from "Voters"
where streetnumber is not null and street_key is not null
group by streetnumber, street_key
)
select xx.streetnumber, s.fullstreetname, xx.street_key, xx.count, a.property_code ,v.unit_type, v.unit, v.streetbuilding
from xx
left join addresses a on xx.streetnumber = a.streetnumber and xx.street_key = a.street_key
left join "Voters" v on v.streetnumber = a.streetnumber and v.street_key = a.street_key
left join "Streets" s on xx.street_key = s.street_key
where property_code = 'U'
order by count desc
;

-- ------------------------------------------------------------------------------
-- View Properties in Precinct
-- ------------------------------------------------------------------------------
select a.*,s.fullstreetname,
      (select count(*) from "Voters" v where a.streetnumber = v.streetnumber and a.street_key = v.street_key) as voters_at_address
from addresses a
join "Streets" s on a.street_key = s.street_key
where a.precinct = '2048' and property_code <> 'S'    -- precinct 2048 has apartments
--where property_code = 'A'
order by s.fullstreetname,a.streetnumber
;

select * from Get_Addresses('2048', 'S', 712);
select * from Get_Addresses(null, 'S', 712);
select * from Get_Addresses('2048', 'S');
select * from Get_Addresses('2048', 'U');
select * from Get_Addresses('2048', null, 712);
select * from Get_Addresses('2048');

select * from get_addresses('2048','A',712);

select * from addresses where street_key = 718 and streetnumber = 5565;
call update_address(5565, 718, 'A', true, 500, 0);
select * from addresses where street_key = 718 and streetnumber = 5565;
call Update_Address(5565, 718, 'U', false, 1, 0);

select * from "Voters" where streetnumber = 3142 and street_key = 20607;