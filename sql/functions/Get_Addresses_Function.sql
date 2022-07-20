
drop function if exists Get_Addresses(inprecinct_name char(4), inproperty_type char(1), instreet_id int);
drop table if exists Addresses_Results cascade;

CREATE TABLE Addresses_results (
    address_geo_id int,
	full_address character varying,
	precinct_name char(4),
	property_type char(1),
	gated character varying,
	estimated_number_of_units int,
    subdivision_name character varying(64),
    complex_name character varying(64),
	contact_name character varying(64),
	contact_phone character varying(32),
	number_of_buildings int DEFAULT 1,
	number_of_registered_voters int,
	number_of_unregistered_voters int
);

CREATE FUNCTION Get_Addresses(
    inprecinct_name char(5) DEFAULT NULL::char(5), 
	inproperty_type char(1) DEFAULT NULL::char(1), 
    instreet_id int DEFAULT NULL::int
)
  RETURNS SETOF Addresses_results
AS $$

select a.address_geo_id,
    bea.full_address,
	a.precinct_name,
	coalesce(a.property_type,'') as property_type,
	case when a.gated is NULL then '' 
	     when a.gated = true then 'true'
		 else 'false' end as gated,
	coalesce(a.estimated_number_of_units,0) as estimated_number_of_units,
    coalesce(a.subdivision_name,'') as subdivision_name,
    coalesce(a.complex_name,'') as complex_name,
	coalesce(a.contact_name,'') as contact_name,
	coalesce(a.contact_phone,'') as contact_phone,
	coalesce(a.number_of_buildings,0) as number_of_buildings,
    (select count(*) from bq_person_extract zp 
     left join bq_unit_extract zu on zu.address_id = zp.address_id
     where zu.address_geo_id = a.address_geo_id) as number_of_registered_voters,
	(select count(*) from bq_reregistration_targets_extract_splitaddress sa 
     where sa.address_geo_id = a.address_geo_id) as number_of_unregistered_voters
from address_supplement a	 
left join bq_address_extract bea on bea.address_geo_id = a.address_geo_id
left join bq_street_extract s on s.street_id = bea.street_id
where (inprecinct_name is NULL or a.precinct_name = inprecinct_name) 
  and (instreet_id is NULL or instreet_id = s.street_id)
  and (inproperty_type is NULL or inproperty_type = a.property_type)
order by bea.full_address
; 

$$ LANGUAGE sql;
