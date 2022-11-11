
drop function if exists Get_Address_Supplements(inprecinct character varying, inproperty_type char(1), instreet_id int);
drop table if exists Get_Address_Supplements_Results;

create table Get_Address_Supplements_Results (
	address_geo_id int,
	precinct character varying,
	full_address character varying,
	street_number character varying,
	street_pre_dir character varying,
	street_name character varying,
	street_type character varying,
	street_post_dir character varying, 
	property_type char(1),
	number_of_buildings int,
	number_of_floors int,
    number_of_units int,
    restricted character varying,
    complex_name character varying,
	complex_contact character varying,
	complex_phone character varying,
	number_of_registered_voters int,
	number_of_unregistered_voters int
);

create function Get_Address_Supplements(inprecinct character varying, inproperty_type char(1), instreet_id int)
returns setof Get_Address_Supplements_Results language sql as $$
select 
	   asup.address_geo_id, 
	   ae.precinct_name,
	   ae.full_address,
	   coalesce(ae.street_number,''),
	   coalesce(ae.street_pre_dir,''),
	   coalesce(ae.street_name,''),
	   coalesce(ae.street_type,''),
	   coalesce(ae.street_post_dir,''),
	   coalesce(asup.property_type,''),
	   coalesce(asup.number_of_buildings,0),
	   coalesce(asup.number_of_floors,0),
       coalesce(asup.number_of_units,0),
	   case when asup.restricted is NULL then '' 
	     when asup.restricted = true then 'true'
		 else 'false' end,
       coalesce(asup.complex_name,''),
	   coalesce(asup.complex_contact,''),
	   coalesce(asup.complex_phone,''),
    (select count(*) from bq_person_extract zp 
     left join bq_unit_extract zu on zu.address_id = zp.address_id
     where zu.address_geo_id = asup.address_geo_id) as number_of_registered_voters,
	(select count(*) from bq_reregistration_targets_extract_splitaddress sa 
     where sa.address_geo_id = asup.address_geo_id) as number_of_unregistered_voters
from address_supplement asup
inner join bq_address_extract ae
   on asup.address_geo_id = ae.address_geo_id
left join bq_street_extract s on s.street_id = ae.street_id
where (inprecinct is NULL or ae.precinct_name = inprecinct) 
  and (instreet_id is NULL or instreet_id = s.street_id)
  and (inproperty_type is NULL or inproperty_type = asup.property_type)
order by s.full_street_name,ae.street_number
$$;
