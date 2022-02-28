update geocodes set address = trim(replace(address, ' TX ', ' '));

select * from "Streets" where fullstreetname like 'ABRAMS%';

select s.street_key,s.fullstreetname,geocodes.*
from geocodes
left join "Streets" s on geocodes.address = s.fullstreetname;

update geocodes set street_key = (select distinct x.street_key from "Streets" x where address = x.fullstreetname)
where (select distinct x.street_key from "Streets" x where address = x.fullstreetname) is not null;

select distinct address from geocodes
where street_key in (select street_key from "Streets");

select distinct fullstreetname,count(*) from "Streets" group by fullstreetname order by 2 desc;

select * from "Streets" where fullstreetname in ('GRAN VIA IRVING 75039','US HIGHWAY 80 E MESQUITE 75150');

select * from "Voters" where street_key in (9919978,19980);
update "Voters" set street_key = 19978 where street_key=19980;
delete from "Streets" where street_key = 19980;

select * from geocodes where streetnumber = 6235;
select * from "Streets" where street_key = 11537;
select * from "Streets" where streetname = 'LLANO' and streettype = 'AVE' and city = 'DALLAS';

select distinct streetnumber,address,count(*) from geocodes group by streetnumber,address order by 3 desc;

select * from voter where sos_voterid in ('1162870496','2132584627','2126550217');

select * from uvoter where person_id in ('393304030','169044881');
delete from geocodes where street_key in ('393304030');

select * from voter where lastname = 'STANFORD' and firstname = 'MICHAEL';

select * --lat,lng 
from geocodes 
where street_key = 17545
    and (streetnumber = 6241 or (streetnumber >= ((6241/100)*100)     and streetnumber < ((6241/100)*100)+100))
fetch first 1 rows only;
