insert into public."Streets" (streetname,streettype,streetdirection,city,zip,fullstreetname)
with xx as
(select 
    streetname,
    streettype,
    coalesce(streetpredir,'') || coalesce(streetpostdir,'') as streetdirection,
    city,
    zip
from voter
where streetname is not null and city is not null and zip is not null
--fetch first 100 rows only
), yy as (
select distinct streetname,streettype,streetdirection,city,zip
from xx
group by streetname,streettype,streetdirection,city,zip
order by streetname,streettype,streetdirection,city,zip
), zz as (
select streetname,streettype,streetdirection,city,zip,
     trim(trim(trim(trim(coalesce(streetname,'') || ' ' || coalesce(streettype,'')) || ' ' || coalesce(streetdirection,'')) 
	 || ' ' || coalesce(city,'')) || ' ' || coalesce(zip,'')) as FullStreetName
from yy	
)
select * from zz	
;
--delete from public."Streets";
--select count(*) from public."Streets"; 
--select max(length(fullstreetname)) from "Streets";
--select * from public."Streets" fetch first 100 rows only;
--select * from "Streets" where fullstreetname is null;
--select count(*) from voter where streetname is null;
