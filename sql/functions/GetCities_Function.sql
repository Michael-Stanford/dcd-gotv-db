
drop function if exists Get_Cities();
drop table if exists Get_Cities_Results;

create table Get_Cities_Results (
   city character varying(15)
);

create function Get_Cities()
returns setof Get_Cities_Results language sql as $$
select city
from bq_city_extract
order by city
$$;
