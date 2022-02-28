
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
returns setof Get_Precincts_Results language sql as $$
select precinct,
	   coalesce(commissioner, '') as commissioner,
	   coalesce(justice_of_the_peace, '') as justice_of_the_peace,
	   coalesce(us_congress, '')as us_congress,	
	   coalesce(st_senate, '') as st_senate,
	   coalesce(state_board_of_edu, '') as state_board_of_edu,	
	   coalesce(st_rep, '') as st_rep,
	   (select count(*) from "Voters" v where v.precinct = p.precinct) as registered_voters,
	   (select count(*) from uvoter v where v.van_precinct_name = p.precinct) as unregistered_voters,
       coalesce(chair_key, 0) as chair_key,
	   coalesce(firstname, '') as firstname,
	   coalesce(lastname, '') as lastname,
	   coalesce(email, '') as email,
	   coalesce(phone, '') as phone,
	   coalesce(address, '') as address,
	   coalesce(city, '') as city,
	   coalesce(zip, '') as zip,
	   case when firstname is null then precinct||'-Open Seat' else precinct||'-'||firstname||' '||lastname end as chairname
from precincts p
left join chairs c on p.chair_key = c.key
--where firstname is not null 
order by precinct --fetch first 2 rows only
;
$$;
