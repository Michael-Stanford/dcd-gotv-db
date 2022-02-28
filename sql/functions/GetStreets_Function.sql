
drop function if exists Get_Streets(inCityOrZip character varying);
drop table if exists Get_Streets_Results;

create table Get_Streets_Results (
   street_key     bigint,
   fullstreetname character varying(45)
);

create function Get_Streets(inCityOrZip character varying DEFAULT NULL::character varying)
returns setof Get_Streets_Results language sql as $$
select street_key, fullstreetname
from "Streets"
where inCityOrZip is null
   or city = upper(inCityOrZip)
   or zip = inCityOrZip
order by fullstreetname
$$;
