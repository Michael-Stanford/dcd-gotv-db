
drop function if exists Zips_By_City(incity varchar);
drop table if exists Zips_By_City_Results;

create table Zips_By_City_Results (
   city varchar(14),
   zip char(5) 
);

create function Zips_By_City(incity varchar)
returns setof Zips_By_City_Results language sql as $$
select distinct city,zip
from voter
where city like upper(incity)
group by city,zip
order by city,zip;
$$;
