
drop table if exists street_ranges;
create table street_ranges
(
street_key int,
minnum int,
maxnum int)
;
insert into street_ranges
select street_key,min(streetnumber),max(streetnumber)
from "Voters"
group by street_key
order by 1,2,3
;
select r.*,s.fullstreetname 
from street_ranges r
left join "Streets" s on r.street_key = s.street_key
where s.fullstreetname is not null
  and r.street_key in (select distinct g.street_key from geocodes g)
;