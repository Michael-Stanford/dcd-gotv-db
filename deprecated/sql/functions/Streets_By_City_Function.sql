
drop function if exists Streets_By_City(incity varchar);
drop table if exists Streets_By_City_Results;

create table Streets_By_City_Results (
   streetname    varchar(25),
   streettype    char(4),
   streetpredir  char(2),
   streetpostdir char(1)
);

create function Streets_By_City(incity varchar)
returns setof Streets_By_City_Results language sql as $$
select distinct streetname, streettype, streetpredir, streetpostdir
from voter
where city = upper(incity)
group by streetname, streettype, streetpredir, streetpostdir
order by streetname, streettype, streetpredir, streetpostdir
$$;
