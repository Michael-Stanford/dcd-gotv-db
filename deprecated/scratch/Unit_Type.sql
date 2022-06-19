select distinct unit_type,count(*) from voter
group by unit_type
order by unit_type
;

with xx as (
select distinct streetnumber,streetname,streettype,city,count(*) as count
from voter
group by streetnumber,streetname,streettype,city
)
select * from xx
where count > 10
order by count desc,streetnumber,streetname,streettype,city
;

select distinct streetnumber,streetname,unit_type,count(*)
from voter
where unit_type is not null
group by streetnumber,streetname,unit_type
order by 4 desc,streetnumber,streetname,unit_type
;

select streetnumber,streetname,unit_type,unit,firstname, lastname
from voter 
where streetnumber = 3225 and streetname = 'TURTLE CREEK'
order by unit
;
select * from voter where lastname = 'FARRAR';
select lastname,count(*) from voter group by lastname order by 2 desc;

