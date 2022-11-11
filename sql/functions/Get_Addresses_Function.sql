
drop function if exists Get_Addresses(inprecinct_name char(4), inproperty_type char(1), instreet_id int);
drop table if exists Addresses_Results cascade;

-- Replaced by Get_Address_Supplements