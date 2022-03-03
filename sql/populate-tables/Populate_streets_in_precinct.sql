with xx as (
	select distinct street_key, precinct
	from addresses
	group by street_key, precinct
	order by street_key, precinct
),
yy as (
SELECT street_key, string_agg(precinct, ', ') AS precincts
FROM   xx
GROUP  BY 1
)
insert into streets_by_precinct (street_key, precincts)
select distinct street_key, precincts 
from yy
;
-- select * from streets_by_precinct;