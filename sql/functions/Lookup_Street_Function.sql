
drop function if exists Lookup_Street(in_street_pre_dir character varying, in_street_name character varying, 
									  in_street_post_dir character varying, in_street_type character varying, 
									  in_city character varying, in_zip character varying);
drop table if exists Lookup_Street_Results;

create table Lookup_Street_Results (
   street_id integer,
   full_street_name character varying
);

create function Lookup_Street(in_street_pre_dir character varying, in_street_name character varying, 
							  in_street_post_dir character varying, in_street_type character varying, 
							  in_city character varying, in_zip character varying)
returns setof Lookup_Street_Results language sql as $$
select street_id, full_street_name 
from bq_street_extract
where ((in_street_pre_dir is null and street_pre_dir is null) or (in_street_pre_dir is not null and street_pre_dir = in_street_pre_dir)) 
  and street_name = in_street_name
  and ((in_street_post_dir is null and street_post_dir is null) or (in_street_post_dir is not null and street_post_dir = in_street_post_dir))
  and ((in_street_type is null and street_type is null) or (in_street_type is not null and street_type = in_street_type)) 
  and city = in_city
  and zip = in_zip
$$;
