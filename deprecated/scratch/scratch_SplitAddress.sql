
select address,address_2,position(upper(address_2) in upper(address)) from uvoter where address_2 is   null;


	select person_id,address,address_2,
	      case when coalesce(position(upper(address_2) in upper(address)),0) > 0
		  then upper(address)
		  else upper(address|| ' ' ||coalesce(address_2,' ')) 
		  end as newaddress,
	      case when coalesce(position(upper(address_2) in upper(address)),0) > 0
		  then string_to_array(upper(address),' ')
		  else string_to_array(upper(address|| ' ' ||coalesce(address_2,' ')),' ')
		  end as items 
	from uvoter 
	where address_2 is not null;

select count(*) from uvoter_splitaddress;

select uvsa.extra,uv.person_id,uv.address,uv.address_2,uvsa.*
from uvoter uv, uvoter_splitaddress uvsa
where uv.person_id = uvsa.person_id
  --and extra is not null
  and uv.address_2 is not null
 ;

delete from uvoter_splitaddress;

--select '1241212' ~ '^[0-9]+$';

select uvoter_raw.* from uvoter_raw;

select distinct person_id,count(*) from uvoter_raw group by person_id order by 2 desc;

select * from uvoter where person_id = '185295020';

select count(*) from uvoter_raw;

select count(*),
       count(distinct person_id) ,
	   count(*) - count(distinct person_id)
from uvoter;

select count(*) from uvoter_raw where person_id ~ '^[0-9]+$' = true;


DELETE FROM
    uvoter_raw a
        USING uvoter_raw b
WHERE
    a.id < b.id
    AND a.person_id = b.person_id;
insert into uvoter 
select 
	myv_van_id, person_id, first_name, last_name, address, address_2, city, state, zip, zip4,
	county, van_precinct_name, state_house_district, target_type, phone_1, phone_2, phone_3, phone_4
from uvoter_raw;

select person_id,address,city,state,zip
from uvoter_raw
where id >=20001 and id <=30000
;

update uvoter_splitaddress x
set street_key = 
(
select s.street_key --v.person_id,u.streetnumber,u.streetname, v.city,v.zip,u.streettype,s.*
from uvoter v
inner join uvoter_splitaddress u
  on v.person_id = u.person_id
inner join "Streets" s
on u.streetname = s.streetname
and coalesce(u.streettype,'') = coalesce(s.streettype,'')
and coalesce(u.streetdirection,'') = coalesce(s.streetdirection,'')
and upper(v.city) = s.city
and v.zip = s.zip
where v.person_id = x.person_id
)
;
select 'NULL',count(*) from uvoter_splitaddress where street_key is null
union
select 'NOT NULL',count(*) from uvoter_splitaddress where street_key is not null;

select * from "Streets" where streetname='ABBOTT' and streettype = 'AVE';