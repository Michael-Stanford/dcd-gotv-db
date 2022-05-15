
drop function if exists Get_Addresses(inprecinct_name char(4), inproperty_type char(1), instreet_id int);
drop table if exists Addresses_Results cascade;

CREATE TABLE Addresses_results (
    address_geo_id int,
	full_address character varying,
	precinct_name char(4),
	property_type char(1),
	gated character varying,
	estimated_number_of_units int,
	propetyname character varying,
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
	coalesce(a.propertyname,'') as propertyname,
    (select count(*) from bq_person_extract zp 
     left join bq_unit_extract zu on zu.address_id = zp.address_id
     where zu.address_geo_id = a.address_geo_id) as number_of_registered_voters,
	--(select count(*) from uvoter u 
	-- join uvoter_splitaddress sa on sa.person_id = u.person_id
	 --where a.streetnumber = cast(sa.streetnumber as int) and a.street_key = sa.street_key)  as number_of_unregistered_voters
	 0 as number_of_unregistered_voters
from address_supplement a	 
left join bq_address_extract bea on bea.address_geo_id = a.address_geo_id
left join bq_street_extract s on s.street_id = bea.street_id
left join bq_unit_extract u on u.address_geo_id = a.address_geo_id
where (inprecinct_name is NULL or a.precinct_name = inprecinct_name) 
  and (instreet_id is NULL or instreet_id = s.street_id)
  and (inproperty_type is NULL or inproperty_type = a.property_type)
order by bea.full_address
; 

$$ LANGUAGE sql;
