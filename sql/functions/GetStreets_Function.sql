
drop function if exists Get_Streets(inCityOrZip character varying);
drop table if exists Get_Streets_Results;

create table Get_Streets_Results (
   street_id int,
   full_street_name character varying,
   city character varying,
   precincts character varying
);

create function Get_Streets(inCityOrZip character varying DEFAULT NULL::character varying)
returns setof Get_Streets_Results language sql as $$
select s.street_id, s.full_street_name, s.city, coalesce(sbp.precincts,'')
from bq_street_extract s
left join bq_streets_by_precinct_extract sbp on sbp.street_id = s.street_id
where inCityOrZip is null
   or s.city = upper(inCityOrZip)
   or s.zip = inCityOrZip
order by s.full_street_name;
$$;
