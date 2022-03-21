
drop procedure if exists Update_Address(int, int, char(1), boolean, int, int);

CREATE PROCEDURE Update_Address(
    in instreetnumber int, 
    in instreet_key int,
	in inproperty_code char(1),
	in ingated boolean,
	in inestimated_number_of_units int,
	inout outnumberofrowsupdated int
)
LANGUAGE plpgsql
AS $$

declare 
rowcount int default(0);
begin 
update addresses
set property_code = inproperty_code, gated = ingated, estimated_number_of_units = inestimated_number_of_units
where streetnumber = instreetnumber and street_key = instreet_key
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
