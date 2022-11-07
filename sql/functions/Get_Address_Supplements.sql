
drop function if exists Get_Address_Supplements(inprecinct character varying);
drop table if exists Get_Address_Supplements_Results;

create table Get_Address_Supplements_Results (
	address_geo_id int,
	precinct character varying,
	street_number character varying,
	street_pre_dir character varying,
	street_name character varying,
	street_type character varying,
	street_post_dir character varying, 
	property_type char(1),
	number_of_buildings int,
	number_of_floors int,
    number_of_units int,
    restricted boolean,
    complex_name character varying,
	complex_contact character varying,
	complex_phone character varying
);

create function Get_Address_Supplements(inprecinct character varying)
returns setof Get_Address_Supplements_Results language sql as $$
select 
	   asup.address_geo_id, 
	   ae.precinct_name,
	   ae.street_number,
	   ae.street_pre_dir,
	   ae.street_name,
	   ae.street_type,
	   ae.street_post_dir,
	   asup.property_type,
	   asup.number_of_buildings,
	   asup.number_of_floors,
       asup.number_of_units,
       asup.restricted,
       asup.complex_name,
	   asup.complex_contact,
	   asup.complex_phone
from address_supplement asup
inner join bq_address_extract ae
   on asup.address_geo_id = ae.address_geo_id
where ae.precinct_name = inprecinct;
$$;
