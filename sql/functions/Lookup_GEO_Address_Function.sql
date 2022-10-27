
drop function if exists Lookup_GEO_Address(in_street_id integer, in_street_number character varying);
drop table if exists Lookup_GEO_Address_Results;

create table Lookup_GEO_Address_Results (
   address_geo_id integer,
   full_address character varying,
   precinct_name character varying
);

create function Lookup_GEO_Address(in_street_id integer, in_street_number character varying)
returns setof Lookup_GEO_Address_Results language sql as $$
select address_geo_id, full_address, precinct_name 
from bq_address_extract
where street_id = in_street_id
  and street_number = in_street_number
$$;
