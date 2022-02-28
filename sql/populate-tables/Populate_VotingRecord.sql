insert into public."VotingRecord" 
with xx as (
SELECT sos_voterid::bigint,
       UNNEST(ARRAY [1,   2,  3,  4,  5,  6,  7,  8,  9,  10,
					 11,  12, 13, 14, 15, 16, 17, 18, 19, 20,
					 21,  22, 23, 24, 25, 26, 27, 28, 29, 30,
					 31,  32, 33, 34, 35, 36, 37, 38, 39, 40
					]) AS order,
       UNNEST(ARRAY [election_code1,  election_code2,  election_code3,  election_code4,  election_code5,
					 election_code6,  election_code7,  election_code8,  election_code9,  election_code10,
					 election_code11, election_code12, election_code13, election_code14, election_code15,
					 election_code16, election_code17, election_code18, election_code19, election_code10,
					 election_code21, election_code22, election_code23, election_code24, election_code25,
					 election_code26, election_code27, election_code28, election_code29, election_code20,
					 election_code31, election_code32, election_code33, election_code34, election_code35,
					 election_code36, election_code37, election_code38, election_code39, election_code40
					]) AS election_code,
       UNNEST(ARRAY [vote_type1,  vote_type2,  vote_type3,  vote_type4,  vote_type5,
                     vote_type6,  vote_type7,  vote_type8,  vote_type9,  vote_type10,
					 vote_type11, vote_type12, vote_type13, vote_type14, vote_type15,
                     vote_type16, vote_type17, vote_type18, vote_type19, vote_type20,
					 vote_type21, vote_type22, vote_type23, vote_type24, vote_type25,
                     vote_type26, vote_type27, vote_type28, vote_type29, vote_type30,
					 vote_type31, vote_type32, vote_type33, vote_type34, vote_type35,
                     vote_type36, vote_type37, vote_type38, vote_type39, vote_type40
					]) AS vote_type,
       UNNEST(ARRAY [party_code1,  party_code2,  party_code3,  party_code4,  party_code5,
					 party_code6,  party_code7,  party_code8,  party_code9,  party_code10,
					 party_code11, party_code12, party_code13, party_code14, party_code15,
					 party_code16, party_code17, party_code18, party_code19, party_code20,
					 party_code21, party_code22, party_code23, party_code24, party_code25,
					 party_code26, party_code27, party_code28, party_code29, party_code30,
					 party_code31, party_code32, party_code33, party_code34, party_code35,
					 party_code36, party_code37, party_code38, party_code39, party_code40
					]) AS party_code
FROM voter
--fetch first 1000 rows only
)
select * from xx
where election_code is not null and vote_type is not null
;
--delete from "VotingRecord";
--select count(*) from public."VotingRecord"; 
--select * from public."VotingRecord" fetch first 100 rows only;
--select * from "VotingRecord" where party_code is not null;
--select distinct election_code from "VotingRecord";
--with xx as (select distinct election_code from "VotingRecord") 
--select substring(election_code,3,4),substring(election_code,1,2) from xx order by 1,2;