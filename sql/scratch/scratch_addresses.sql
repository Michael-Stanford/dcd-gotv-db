
--Get_Addresses(inprecinct_name char(4), inproperty_type char(1), instreet_id int);
select * from Get_Addresses('2501', null, null);
select * from Get_Addresses('2501', 'S', null);
select * from Get_Addresses('2501', 'S', 53342129); -- Shady Creek Dr
select * from Get_Addresses('2901', 'A', 79918023); -- VITRUVIAN WAY ADDISON 75001
select * from Get_Addresses('2901', 'M', 79918023); -- VITRUVIAN WAY ADDISON 75001
select * from Get_Addresses('2901', null, 79918023); -- VITRUVIAN WAY ADDISON 75001

--Update_Address(inaddress_geo_id int, inproperty_type char(1), ingated boolean, inestimated_number_of_units int, outnumberofrowsupdated int);
call Update_Address(227841713, 'A', true, 50, 0);

--Update_Address_f(
--	   inaddress_geo_id int, 
--	   inproperty_type char(1), 
--	   ingated boolean, 
--	   inestimated_number_of_units int,
--     insubdivision_name character varying,
--     incomplex_name character varying,
--	   incontact_name character varying,
--	   incontact_phone character varying,
--	   innumber_of_buildings int);
select * from update_address_f(227841713, null, true, 59, 'Vit Sub', 'Vit Complex', 'Mr. Contact', '555-1212', 2);
select * from update_address_f(227841713, null, true, null, null, null, null, null, 3);