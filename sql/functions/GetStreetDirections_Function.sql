
drop function if exists Get_StreetDirections();
drop table if exists Get_StreetDirections_Results;

create table Get_StreetDirections_Results (
   dir character varying
);

create function Get_StreetDirections()
returns setof Get_StreetDirections_Results language sql as $$
with xx as
(
select distinct street_pre_dir as dir
from bq_street_extract
union
select distinct street_post_dir as dir
from bq_street_extract
)
select 	dir from xx order by 1
$$;
