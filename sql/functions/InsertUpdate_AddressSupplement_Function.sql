
drop function if exists 
   InsertUpdate_AddressSupplement(
	   inaddress_geo_id int, 
	   inproperty_type char(1),
	   innumber_of_buildings int,
	   innumber_of_floors int,
       innumber_of_units int,
       inrestricted boolean,
       incomplex_name character varying,
	   incomplex_contact character varying,
	   incomplex_phone character varying
	   );

CREATE function InsertUpdate_AddressSupplement(
	   inaddress_geo_id int, 
	   inproperty_type char(1),
	   innumber_of_buildings int,
	   innumber_of_floors int,
       innumber_of_units int,
       inrestricted boolean,
       incomplex_name character varying,
	   incomplex_contact character varying,
	   incomplex_phone character varying
)
returns int
LANGUAGE plpgsql
AS $$

declare 
rowcount int default(0);

begin 

insert into address_supplement
(
	   address_geo_id, 
	   property_type,
	   number_of_buildings,
	   number_of_floors,
       number_of_units,
       restricted,
       complex_name,
	   complex_contact,
	   complex_phone,
	   modified_date
)
values
(
	   inaddress_geo_id, 
	   inproperty_type,
	   innumber_of_buildings,
	   innumber_of_floors,
       innumber_of_units,
       inrestricted,
       incomplex_name,
	   incomplex_contact,
	   incomplex_phone,
	   current_timestamp
)
on conflict (address_geo_id)
WHERE ((address_supplement.address_geo_id)::integer = inaddress_geo_id::integer)
do update
set 
   property_type = case when inproperty_type is not null then inproperty_type else address_supplement.property_type end,
   number_of_buildings = case when innumber_of_buildings is not null then innumber_of_buildings else address_supplement.number_of_buildings end,
   number_of_floors = case when innumber_of_floors is not null then innumber_of_floors else address_supplement.number_of_floors end,
   number_of_units = case when innumber_of_units is not null then innumber_of_units else address_supplement.number_of_units end,
   restricted = case when inrestricted is not null then inrestricted else address_supplement.restricted end,
   complex_name = case when incomplex_name is not null then incomplex_name else address_supplement.complex_name end,
   complex_contact = case when incomplex_contact is not null then incomplex_contact else address_supplement.complex_contact end,
   complex_phone = case when incomplex_phone is not null then incomplex_phone else address_supplement.complex_phone end,
   modified_date = current_timestamp
; 

get diagnostics rowcount = row_count;   

return rowcount;
end 
$$ ;
