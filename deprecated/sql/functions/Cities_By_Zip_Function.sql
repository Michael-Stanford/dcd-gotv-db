
drop function if exists Cities_By_Zip(zipcode5 varchar);
drop table if exists Cities_By_Zip_Results;

create table Cities_By_Zip_Results (
   city varchar(64)  
);

create function Cities_By_Zip(zipcode5 varchar)
returns setof Cities_By_Zip_Results language sql as $$
select distinct city
from voter
where zip = zipcode5
order by city;
$$;
