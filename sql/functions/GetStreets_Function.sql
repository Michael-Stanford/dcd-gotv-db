
drop function if exists Get_Streets(inCityOrZip character varying);
drop table if exists Get_Streets_Results;

create table Get_Streets_Results (
   street_key     bigint,
   fullstreetname character varying,
   city character varying,
   precincts character varying
);

create function Get_Streets(inCityOrZip character varying DEFAULT NULL::character varying)
returns setof Get_Streets_Results language sql as $$
select s.street_key, s.fullstreetname, s.city, sbp.precincts
from "Streets" s
left join addresses a on a.street_key = s.street_key
left join streets_by_precinct sbp on sbp.street_key = s.street_key
where inCityOrZip is null
   or s.city = upper(inCityOrZip)
   or s.zip = inCityOrZip
order by s.fullstreetname
$$;
