
drop function if exists Get_Addresses(inprecinct char(4), inproperty_code char(1), instreet_key int);
drop table if exists Addresses_Results;

CREATE TABLE Addresses_results (
    street_key int,
	streetnumber int,
	fullstreetname character varying,
	precinct char(4),
	property_code char(1),
	gated character varying,
	estimated_number_of_units int,
	propetyname character varying,
	number_of_registered_voters int,
	number_of_unregistered_voters int
);

CREATE FUNCTION Get_Addresses(
    inprecinct char(4) DEFAULT NULL::char(4), 
	inproperty_code char(1) DEFAULT NULL::char(1), 
    instreet_key int DEFAULT NULL::int
)
  RETURNS SETOF Addresses_results
AS $$

select a.street_key,
    a.streetnumber,
    s.fullstreetname,
	a.precinct,
	coalesce(a.property_code,'') as property_code,
	case when a.gated is NULL then '' 
	     when a.gated = true then 'true'
		 else 'false' end as gated,
	coalesce(a.estimated_number_of_units,0) as estimated_number_of_units,
	coalesce(a.propertyname,'') as propertyname,
    (select count(*) from "Voters" v where a.streetnumber = v.streetnumber and a.street_key = v.street_key) as number_of_registered_voters,
	(select count(*) from uvoter u 
	 join uvoter_splitaddress sa on sa.person_id = u.person_id
	 where a.streetnumber = cast(sa.streetnumber as int) and a.street_key = sa.street_key)  as number_of_unregistered_voters
from addresses a
join "Streets" s on a.street_key = s.street_key
where (inprecinct is NULL or a.precinct = inprecinct) 
  and (instreet_key is NULL or instreet_key = a.street_key)
  and (inproperty_code is NULL or inproperty_code = a.property_code)
order by s.fullstreetname,a.streetnumber
; 

$$ LANGUAGE sql;
