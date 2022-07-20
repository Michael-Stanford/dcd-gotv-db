
drop function if exists 
   Update_Address_f(
	   inaddress_geo_id int, 
	   inproperty_type char(1), 
	   ingated boolean, 
	   inestimated_number_of_units int,
       insubdivision_name character varying,
       incomplex_name character varying,
	   incontact_name character varying,
	   incontact_phone character varying,
	   innumber_of_buildings int);

CREATE function Update_Address_f(
    in inaddress_geo_id int,
	in inproperty_type char(1),
	in ingated boolean,
	in inestimated_number_of_units int,
    in insubdivision_name character varying,
    in incomplex_name character varying,
	in incontact_name character varying,
	in incontact_phone character varying,
	in innumber_of_buildings int
)
returns int
LANGUAGE plpgsql
AS $$

declare 
rowcount int default(0);

begin 

update address_supplement
set 
   property_type = case when inproperty_type is not null then inproperty_type else property_type end, 
   gated = case when ingated is not null then ingated else ingated end, 
   estimated_number_of_units = case when inestimated_number_of_units is not null then inestimated_number_of_units else estimated_number_of_units end,
   subdivision_name = case when insubdivision_name is not null then insubdivision_name else subdivision_name end,
   complex_name = case when incomplex_name is not null then incomplex_name else complex_name end,
   contact_name = case when incontact_name is not null then incontact_name else contact_name end,
   contact_phone = case when incontact_phone is not null then incontact_phone else contact_phone end,
   number_of_buildings = case when innumber_of_buildings is not null then innumber_of_buildings else number_of_buildings end
where address_geo_id = inaddress_geo_id
; 

get diagnostics rowcount = row_count;   

return rowcount;
end 
$$ ;
