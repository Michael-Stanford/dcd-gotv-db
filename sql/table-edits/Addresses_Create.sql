drop table if exists addresses, property_codes cascade;

create table property_codes (
	code char(1),
	description character varying(64),
	primary key (code)
);

create table addresses (
	street_key int,
	streetnumber int,
	property_code char(1) default 'U',
	primary key (street_key, streetnumber)
);

insert into property_codes (code, description)
values
('S', 'Single Family'),
('M', 'Multi-Family'),
('A', 'Apartment'),
('U', 'Unknown')
;

insert into addresses (street_key, streetnumber)
select distinct street_key, streetnumber 
from "Voters"
where street_key is not null and streetnumber is not null
group by street_key, streetnumber 
order by street_key, streetnumber 
;

update addresses a
   set property_code = 'A'
where exists
  (select distinct streetnumber, street_key
     from "Voters" v
	where v.streetnumber is not null and v.street_key is not null
      and v.streetnumber = a.streetnumber
      and v.street_key = a.street_key
      and v.unit_type = 'APT')
;

with xx as (
select distinct streetnumber, street_key, count(*) as count
from "Voters"
where streetnumber is not null and street_key is not null
group by streetnumber, street_key
)
--select * from xx where count >= 12 and count <= 48;
update addresses a
set property_code = 'M' 
where exists 
  (select xx.streetnumber,xx.street_key from xx 
	where xx.streetnumber = a.streetnumber
      and xx.street_key = a.street_key 
      and count >= 12 and count <= 48)
;

with xx as (
select distinct streetnumber, street_key, count(*) as count
from "Voters"
where streetnumber is not null and street_key is not null
group by streetnumber, street_key
)
--select * from xx where count < 12;
update addresses a
   set property_code = 'S'
where exists
  (select xx.streetnumber,xx.street_key from xx 
	where xx.streetnumber = a.streetnumber
      and xx.street_key = a.street_key 
      and count < 12)
  and exists
  (select distinct streetnumber, street_key
     from "Voters" v
	where v.streetnumber is not null and v.street_key is not null
      and v.streetnumber = a.streetnumber
      and v.street_key = a.street_key
      and v.unit_type is null
      and v.unit is null
      and v.streetbuilding is null)
;

--select property_code,count(*) from addresses group by property_code;
