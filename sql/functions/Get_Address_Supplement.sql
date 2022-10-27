
drop function if exists Get_Address_Supplement(inaddress_geo_id integer);
drop table if exists Get_Address_Supplement_Results;

create table Get_Address_Supplement_Results (
   address_geo_id integer,
   gated boolean,
   estimated_number_of_units integer,
   number_of_buildings integer,
   contact_phone character varying,
   subdivision_name character varying,
   complex_name character varying,
   precinct_name character varying,
   property_type character varying,
   contact_name character varying
);

create function Get_Address_Supplement(inaddress_geo_id integer)
returns setof Get_Address_Supplement_Results language sql as $$
select address_geo_id,
   gated,
   estimated_number_of_units,
   number_of_buildings,
   contact_phone,
   subdivision_name,
   complex_name,
   precinct_name,
   property_type,
   contact_name 
from address_supplement
where address_geo_id = inaddress_geo_id
limit 10;
$$;
