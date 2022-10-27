
drop function if exists Get_GeoID(instreetnumber varchar, 
						  instreetpredir varchar, instreetname varchar, instreettype varchar, instreetpostdir varchar,  
						  incity varchar, inzip varchar);
drop table if exists Get_GeoID_Results;

create table Get_GeoID_Results (
   address_geo_id integer
);

create function Get_GeoID(instreetnumber varchar, 
						  instreetpredir varchar, instreetname varchar, instreettype varchar, instreetpostdir varchar,  
						  incity varchar, inzip varchar)
returns setof Get_GeoID_Results language sql as $$
select address_geo_id 
from bq_address_extract
where street_id = 
  (select street_id from bq_street_extract
    where (instreetpredir is null or (street_pre_dir = upper(instreetpredir)))
      and street_name = upper(instreetname)
      and street_type = upper(instreettype)
      and (instreetpostdir is null or (street_post_dir = upper(instreetpostdir)))
      and city = upper(incity)
      and zip = inzip
  )
  and street_number = instreetnumber
limit 10;
$$;
