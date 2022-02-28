
create index streetTempIndex on "Streets"(streetname,streettype,streetdirection,city,zip);
insert into public."Voters"
select 
    sos_voterid::bigint ,    party_code ,    voter_status ,    lastname ,    firstname ,    middlename ,
    namesuffix ,    streetnumber ,    streetbuilding ,    unit_type ,    unit ,    sex ,    birthdate::bigint ,
    eligible_date ,    effective_date ,    precinct ,    precsub ,    county ,    us_congress ,
    st_senate ,    st_rep ,    commissioner ,    city_code ,    city_single_member ,    school ,
    school_single_member ,    water ,    college_district ,    flood_control ,    justice_of_the_peace,
    state_board_of_edu ,    precinct_chair ,    registration_date ,    party_affiliation_date ,
    last_activity_date ,    id_compliant ,    absentee_category ,    absentee_category_date::date,
	(select street_key from "Streets" s
	 where s.streetname = v.streetname and
	       coalesce(s.streettype,'') = coalesce(v.streettype,'') and
	       s.streetdirection = (coalesce(v.streetpredir,'') || coalesce(v.streetpostdir,'')) and
	       s.city = v.city and
	       s.zip = v.zip)
from voter v
--fetch first 100 rows only
;
drop index streetTempIndex;

--select count(*) from "Voters";
--select * from "Voters" fetch first 100 rows only;
--delete from "Voters";
