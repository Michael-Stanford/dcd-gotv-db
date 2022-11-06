
drop function if exists Get_Address_Supplement(inaddress_geo_id integer);
drop table if exists Get_Address_Supplement_Results;

create table Get_Address_Supplement_Results (
	address_geo_id int,
	property_type char(1),
	number_of_buildings int,
	number_of_floors int,
    number_of_units int,
    restricted boolean,
    complex_name character varying,
	complex_contact character varying,
	complex_phone character varying
);

create function Get_Address_Supplement(inaddress_geo_id integer)
returns setof Get_Address_Supplement_Results language sql as $$
select 
	   address_geo_id, 
	   property_type,
	   number_of_buildings,
	   number_of_floors,
       number_of_units,
       restricted,
       complex_name,
	   complex_contact,
	   complex_phone
from address_supplement
where address_geo_id = inaddress_geo_id
limit 10;
$$;
