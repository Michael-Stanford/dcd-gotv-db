
insert into precincts (precinct)
select distinct precinct 
from voter
where precinct is not null
order by 1;

-- select * from precincts;