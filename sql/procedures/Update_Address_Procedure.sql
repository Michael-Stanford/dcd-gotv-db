
drop procedure if exists Update_Address(inaddress_geo_id int, inproperty_type char(1), ingated boolean, inestimated_number_of_units int, outnumberofrowsupdated int);

CREATE procedure Update_Address(
    in inaddress_geo_id int,
	in inproperty_type char(1),
	in ingated boolean,
	in inestimated_number_of_units int,
	inout outnumberofrowsupdated int
)

LANGUAGE plpgsql
AS $$

declare 
rowcount int default(0);

begin 

update address_supplement
set property_type = inproperty_type, gated = ingated, estimated_number_of_units = inestimated_number_of_units
where address_geo_id = inaddress_geo_id
;  

get diagnostics rowcount = row_count;

if (rowcount = 1) then
   commit;
else
   rollback;
end if;   

outnumberofrowsupdated = rowcount;
end 
$$ ;
