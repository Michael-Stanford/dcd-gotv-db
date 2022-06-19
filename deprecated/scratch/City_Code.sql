select distinct city,city_code,count(*) from voter
group by city, city_code
order by city, city_code
;

select distinct city,city_code,count(*) from voter
group by city, city_code
order by city_code, city
;
