select v.streetnumber,s.fullstreetname,v.firstname,v.middlename,v.lastname
from "Streets" s
inner join "Voters" v on s.street_key = v.street_key
where v.streetnumber > 100
  and v.streetnumber=101 and s.fullstreetname = 'AVENUE E W GARLAND 75040'
order by v.streetnumber,s.fullstreetname
fetch first 100 rows only
;

with xx as (
select distinct v.streetnumber,s.fullstreetname,s.street_key,count(*) as HouseholdCount
from "Streets" s
inner join "Voters" v on s.street_key = v.street_key
--where v.streetnumber > 100 and v.streetnumber=101 and s.fullstreetname = 'AVENUE E W GARLAND 75040'
group by v.streetnumber,s.fullstreetname,s.street_key
)
select * from xx order by HouseholdCount desc, streetnumber,street_key
--select count(*) from xx
--select count(*) from xx where HouseholdCount > 10
;
--486,062 unique households (number and street, zip)
--4,635 gt 10 voters
--bafarrar@yahoo.com
select sos_voterid,firstname,lastname,streetnumber,streetbuilding,unit_type,unit
from "Voters"
where street_key = 21925 and streetnumber = 1822
;

select vr.*,v.firstname,v.lastname,v.street_key,v.streetnumber,s.fullStreetName
from "VotingRecord" vr
inner join "Voters" v on vr.sos_voterid = v.sos_voterid
inner join "Streets" s on v.street_key = s.street_key
where vr.party_code is not null
  and vr.order = (select min(a.order) from "VotingRecord" a where a.sos_voterid = vr.sos_voterid and vr.party_code is not null)
order by streetnumber,street_key
fetch first 100 rows only
;
select sos_voterid,vr.order,party_code
from "VotingRecord" vr
where party_code is not null
order by sos_voterid
fetch first 100 rows only
;
with xx as (
select sos_voterid, 
    coalesce(party_code1,'')   ||coalesce(party_code2,'') ||coalesce(party_code3,'') ||      coalesce(party_code4,'') ||coalesce(party_code5,'') ||coalesce(party_code6,'') ||
      coalesce(party_code7,'') ||coalesce(party_code8,'') ||coalesce(party_code9,'') ||      coalesce(party_code10,'')||
      coalesce(party_code11,'')||coalesce(party_code12,'')||coalesce(party_code13,'')||      coalesce(party_code14,'')||coalesce(party_code15,'')||coalesce(party_code16,'')||
      coalesce(party_code17,'')||coalesce(party_code18,'')||coalesce(party_code19,'')||      coalesce(party_code20,'')||
      coalesce(party_code21,'')||coalesce(party_code22,'')||coalesce(party_code23,'')||      coalesce(party_code24,'')||coalesce(party_code25,'')||coalesce(party_code26,'')||
      coalesce(party_code27,'')||coalesce(party_code28,'')||coalesce(party_code29,'')||      coalesce(party_code30,'')||
      coalesce(party_code31,'')||coalesce(party_code32,'')||coalesce(party_code33,'')||      coalesce(party_code34,'')||coalesce(party_code35,'')||coalesce(party_code36,'')||
      coalesce(party_code37,'')||coalesce(party_code38,'')||coalesce(party_code39,'')||      coalesce(party_code40,'')
    as partycodes
from voter
--fetch first 100 rows only
), yy as (
select sos_voterid,partycodes,
       length(partycodes) - length(replace(partycodes,'D','')) as DemCount,
       length(partycodes) - length(replace(partycodes,'R','')) as RepCount,
	   substring(partycodes,1,1) as lastpartycode
from xx
)
select * from yy where DemCount <> 0 and RepCount <> 0 order by DemCount + RepCount desc;
select count(*)
from yy
where repcount > demcount
;
