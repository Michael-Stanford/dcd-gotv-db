
drop function if exists Get_StreetTypes();
drop table if exists Get_StreetTypes;

create table Get_StreetTypes_Results (
   type character varying
);

create function Get_StreetTypes()
returns setof Get_StreetTypes_Results language sql as $$
select distinct street_type
from bq_street_extract
order by 1
$$;
