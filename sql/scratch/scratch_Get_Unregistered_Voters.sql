
select * from Get_Unregistered_Voters('2501');
select * from Get_Unregistered_Voters(2600, 562);

select * from geocodes;


select * from bq_reregistration_targets_extract
limit 100;

inner join bq_reregistration_targets_extract_splitaddress u on v.person_id = u.person_id
inner join bq_address_extract a on a.address_geo_id = u.address_geo_id
inner join bq_street_extract s on s.street_id = a.street_id

select * from bq_address_extract limit 100;
select * from bq_address_extract where address_geo_id = 9439806;
select * from bq_person_extract where last_name = 'ABUNAMOUS';
select * from bq_person_extract where first_name = 'ALAA';

select a.first_name,a.last_name, b.full_name, a.address, a.city,b.address_id, d.full_address, c.unit_type, c.unit, b.primary_parties,a.target_type
from bq_reregistration_targets_extract a
inner join bq_person_extract b on a.person_id = b.person_id
left join bq_unit_extract c on c.address_id = a.to_address_id
left join bq_address_extract d on d.address_geo_id = c.address_geo_id
;

select count(*) from bq_reregistration_targets_extract ;

select concat(a.first_name,' ',a.last_name), a.address, a.city, d.full_address, c.unit_type, c.unit,a.target_type
from bq_reregistration_targets_extract a
left join bq_unit_extract c on c.address_id = a.to_address_id
left join bq_address_extract d on d.address_geo_id = c.address_geo_id
where c.address_id is null
;