
drop function if exists Get_Precincts();
drop table if exists Get_Precincts_Results;

create table Get_Precincts_Results (
	precinct character varying,
	commissioner character varying,
	justice_of_the_peace character varying,
	us_congress character varying,	
	st_senate character varying,	
	state_board_of_edu character varying,	
	st_rep character varying,
	registered_voters int,
	unregistered_voters int,
	chair_key int,
	firstname character varying,
	lastname character varying,
	email character varying,
	phone character varying,
	address character varying,
	city character varying,
	zip character varying,
	chairname character varying
);
  
create function Get_Precincts()
returns setof Get_Precincts_Results language plpgsql as $$

BEGIN

create temporary table if not exists registered_voter_counts 
       (precinct_name character varying(10), count int, primary key(precinct_name)) 
	   on commit drop;
create temporary table if not exists unregistered_voter_counts 
       (precinct_name character varying(10), count int, primary key(precinct_name)) 
	   on commit drop;

insert into registered_voter_counts
  select distinct a.precinct_name,count(*) as count 
  from bq_person_extract v 
  left join bq_address_extract a on a.address_geo_id = v.address_id
  where a.precinct_name is not null and v.reg_voter_status = true
  group by a.precinct_name
;
insert into unregistered_voter_counts
  select distinct precinct_name,count(*) as count 
  from bq_reregistration_targets_extract 
  where precinct_name is not null
  group by precinct_name
;
return query
select p.precinct_name as precinct,
	   cast('0' as character varying) as commissioner, --coalesce(commissioner, '') as commissioner,
	   cast('0' as character varying) as justice_of_the_peace, --coalesce(justice_of_the_peace, '') as justice_of_the_peace,
	   coalesce(p.us_cong_district, '')as us_congress,	
	   coalesce(p.state_senate_district, '') as st_senate,
	   cast('0' as character varying) as state_board_of_edu, --coalesce(state_board_of_edu, '') as state_board_of_edu,	
	   coalesce(p.state_house_district, '') as st_rep,
	   coalesce((select count from registered_voter_counts rvc where rvc.precinct_name = p.precinct_name), 0) as registered_voters,
	   coalesce((select count from unregistered_voter_counts uvc where uvc.precinct_name = p.precinct_name), 0) as unregistered_voters,
       coalesce(pcm.chair_key, 0) as chair_key,
	   coalesce(c.firstname, '') as firstname,
	   coalesce(c.lastname, '') as lastname,
	   coalesce(c.email, '') as email,
	   coalesce(c.phone, '') as phone,
	   coalesce(c.address, '') as address,
	   coalesce(c.city, '') as city,
	   coalesce(c.zip, '') as zip,
	   cast(case when c.firstname is null 
			     then p.precinct_name||'-Open Seat' 
			     else p.precinct_name||'-'||c.firstname||' '||c.lastname end as character varying) as chairname
from bq_precinct_extract p
left join precinct_chair_mapping pcm on pcm.precinct_name = p.precinct_name
left join chairs c on pcm.chair_key = c.key
order by p.precinct_name
;
END
$$;
