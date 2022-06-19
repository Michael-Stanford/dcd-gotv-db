insert into public."MailAddress" 
select 
    sos_voterid::bigint, mail1, mail2, mail3, mailcity, mailstate, mailzip mailzip4
from voter
where mail1 is not null
--fetch first 100 rows only
;
--select count(*) from public."MailAddress"; 
--select * from public."MailAddress" fetch first 100 rows only;