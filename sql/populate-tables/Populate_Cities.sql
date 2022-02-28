insert into public."Cities"
select distinct city from voter where streetname is not null and city is not null and zip is not null
order by city
;
--delete from "Cities";
--select count(*) from "Cities";
--select * from "Cities";
