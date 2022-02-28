drop function  voters_on_block;(int,varchar);
select * from precincts;
SELECT * FROM pg_proc WHERE proname like '%_on_block';

select * from voters_on_block(2217, '%main%', 'ST', 'DALLAS');

select * from voters_on_block(1000, 'MAIN');
select * from voters_on_block(2217, 'BELT LINE', 'RD','DALLAS');

select * from voters_on_block(3204, 'caruth');
select * from voters_on_block(2217, '%shady%');
select * from voters_on_block(2217, '%shady%', 'DR', 'Rich%');
select * from voters_on_block(2217, 17549);

select * from get_streets();
select * from get_precincts();


select * from cities_by_zip('75225');

select * from Zips_By_City('Richardson');

select * from Streets_By_City('Richardson');

select distinct city from voter;
select * from voter where firstname = 'MICHAEL' and lastname like 'STANFORD%';
select distinct city, city_code,count(*) from voter group by city, city_code  order by city, city_code ;
select distinct city_code, city,count(*) from voter group by city_code, city  order by city_code, city ;
select distinct city_code, city,count(*) from voter group by city_code, city  order by city_code, city ;
select distinct city_code, zip,count(*) from voter group by city_code, zip  order by city_code, zip ;
select distinct zip, city_code,count(*) from voter group by zip, city_code  order by zip, city_code ;

delete from "Voters"; 
delete from "MailAddress";
delete from "VotingRecord";
delete from "Streets";
select * from "Streets" where streetname = 'SHADY CREEK'; 
select count(*) from "Voters";
select count(*) from "voter" where streetname is not null;
select count(*) from "Voters" where street_key is null;
select * from "Voters" where street_key is null;
select * from "Streets" where streetname = 'FORK' and streettype is null; 
select * from "Streets" where streettype is null; 
select distinct streetname,streettype from voter
where streetname like 'ABRAMS%'
group by streetname,streettype
order by streetname, streettype
;
select min(street_key) from "Streets";
select count(*) from "Streets";
select count(*) from "MailAddress";
select count(*) from "VotingRecord";
select count(*) from "Voters";

select * from Get_Streets();
select * from Get_Streets('75080');
select * from Get_Streets('Garland');

select distinct city from voter order by city;
select distinct zip from voter order by zip;
select * from Get_Cities();

select * from "Streets" where streetname = 'BELT LINE' and streettype like 'RD%';
select sos_voterid,firstname,lastname,streetname, streettype, streetbuilding, city, zip, mail1, mailcity, mailstate from voter
where 
--streetname is null or 
city is null 
--or zip is null;
;