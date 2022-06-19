SELECT * FROM `demstxsp.tdp_dallasdems.person` 
where last_name = 'FARRAR' and first_name in ('BRIAN', 'KIMBERLY')
order by first_name
LIMIT 1000;

select * from `demstxsp.tdp_dallasdems.person` where van_suffix is not null limit 100;
select * from `demstxsp.tdp_dallasdems.person_phones` where person_id in ('178184457', '169179386');


select count(*) from `demstxsp.tdp_dallasdems.person`;
select distinct county_name,count(*) from `demstxsp.tdp_dallasdems.person` group by county_name;

select pv.*
from `demstxsp.tdp_dallasdems.person` p
left join `demstxsp.tdp_dallasdems.person_votes` pv on pv.person_id = p.person_id
where p.person_id = '178184457'
;

select p.person_id, p.first_name, p.address_id 
,'ADDRESS',a.street_number, a.street_pre_dir, a.street_name, a.street_type, a.street_post_dir, a.unit_type, a.unit, a.city, a.zip, a.address_type, a.latitude, a.longitude
,'APARTMENT',aa.aprt_addr, aa.city, aa.state, aa.zip, aa.street_addr_full, aa.county_name, aa.unit_type, aa.unit
from `demstxsp.tdp_dallasdems.person` p
left join `demstxsp.tdp_dallasdems.address` a on a.address_id = p.address_id
left join `demstxsp.tdp_dallasdems.dallas_apartment_complex_units` aa on aa.address_id = p.address_id
where p.person_id in ('178184457','169179386')
--where aa.address_id is not null
--where a.street_number = '4777' and upper(a.street_name) like '%CEDAR SPRINGS%'
--where a.address = '1822 Young St'
--limit 100
;

-- me
select * from `demstxsp.tdp_dallasdems.person` where person_id = '178184457';

-- my precinct
--select * from `demstxsp.tdp_dallasdems.precinct` where person_id = '950836';

-- my address
select dnc_precinct_id, precinct_source, precinct_last_verified_date, van_precinct_id, * 
from `demstxsp.tdp_dallasdems.address`
where address_id = '53891115'
;

select 'ADDRESS',a.* ,'APARTMENT',aa.*
from `demstxsp.tdp_dallasdems.address` a 
join `demstxsp.tdp_dallasdems.dallas_apartment_complex_units` aa on aa.address_id = a.address_id
where a.unit is null
limit 100
;

select address_type,count(*) as count from `demstxsp.tdp_dallasdems.address` group by address_type order by 2 desc;

select count(*) from `demstxsp.tdp_dallasdems.address` where address_id = '53891115';
select * from `demstxsp.tdp_dallasdems.address` where address_id = '53891115';

select distinct address_id,count(*) from `demstxsp.tdp_dallasdems.address` group by address_id order by 2 desc;

select * from `demstxsp.tdp_dallasdems.address` where address_id = '42481695';

select count(*) from `demstxsp.tdp_dallasdems.dallas_apartment_complex_units` ;
select * from `demstxsp.tdp_dallasdems.dallas_apartment_complex_units` ;



select voting_address_id,address_id from `demstxsp.tdp_dallasdems.person` 
where voting_address_id <> address_id limit 100;

