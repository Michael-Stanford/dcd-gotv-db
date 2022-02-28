
drop function if exists Voters_On_Block(instreetnumber int, instreetname varchar, instreettype varchar, incity varchar);
drop function if exists Voters_On_Block(instreetnumber int, instreetkey int);
drop table if exists Voters_On_Block_Results;

CREATE TABLE voters_on_block_results (
    name character varying(128),
    age integer,
    voterid integer,
    voterstatus character(1),
    address character varying(128),
    partycode character(1),
    partycodes character varying(40),
    votetypes character varying(40),
    electioncodes character varying(160),
    lastname character varying(64),
    firstname character varying(64),
    middlename character varying(64),
    namesuffix character varying(64),
    streetnumber integer,
    streetbuilding character varying(64),
    streetpredir character varying(64),
    streetname character varying(64),
    streettype character varying(64),
    streetpostdir character varying(64),
    unit_type character varying(64),
    unit character varying(64),
    city character varying(64),
    zip character varying(64),
    zip4 character varying(64)
);

CREATE FUNCTION voters_on_block(
  instreetnumber integer,
  instreetname character varying,
  instreettype character varying DEFAULT NULL::character varying,
  incity character varying DEFAULT NULL::character varying
)
  RETURNS SETOF voters_on_block_results
AS $$

  select
    coalesce(firstname, ' ')    ||' '||
      coalesce(middlename, ' ') ||' '||
      coalesce(lastname, ' ')   ||' '||
      coalesce(namesuffix, ' ')
    as name,

    extract(year from current_date) - cast(birthdate as int) as age,
    cast(sos_voterid as int) as voterid,
    coalesce(voter_status, '-') as voterstatus,

    coalesce(streetnumber, 0)||' '||coalesce(streetbuilding, ' ')||' '||
      coalesce(streetpredir, ' ')||' '||
      coalesce(streetname, ' ')||' '||coalesce(streettype, ' ')||' '||
      coalesce(streetpostdir, ' ')||' '||
      coalesce(unit_type, ' ')||' '||coalesce(unit, ' ')||' '||
      coalesce(city, ' ')||' '||
      coalesce(zip, ' ')||' '||coalesce(zip4, ' ')
    as Address,

    coalesce(party_code, '-') as partycode,

    coalesce(party_code1,'-')   ||coalesce(party_code2,'-') ||coalesce(party_code3,'-') ||
      coalesce(party_code4,'-') ||coalesce(party_code5,'-') ||coalesce(party_code6,'-') ||
      coalesce(party_code7,'-') ||coalesce(party_code8,'-') ||coalesce(party_code9,'-') ||
      coalesce(party_code10,'-')||
      coalesce(party_code11,'-')||coalesce(party_code12,'-')||coalesce(party_code13,'-')||
      coalesce(party_code14,'-')||coalesce(party_code15,'-')||coalesce(party_code16,'-')||
      coalesce(party_code17,'-')||coalesce(party_code18,'-')||coalesce(party_code19,'-')||
      coalesce(party_code20,'-')||
      coalesce(party_code21,'-')||coalesce(party_code22,'-')||coalesce(party_code23,'-')||
      coalesce(party_code24,'-')||coalesce(party_code25,'-')||coalesce(party_code26,'-')||
      coalesce(party_code27,'-')||coalesce(party_code28,'-')||coalesce(party_code29,'-')||
      coalesce(party_code30,'-')||
      coalesce(party_code31,'-')||coalesce(party_code32,'-')||coalesce(party_code33,'-')||
      coalesce(party_code34,'-')||coalesce(party_code35,'-')||coalesce(party_code36,'-')||
      coalesce(party_code37,'-')||coalesce(party_code38,'-')||coalesce(party_code39,'-')||
      coalesce(party_code40,'-')
    as partycodes,

    coalesce(vote_type1,'-')    ||coalesce(vote_type2,'-')  ||coalesce(vote_type3,'-') ||
      coalesce(vote_type4,'-')  ||coalesce(vote_type5,'-')  ||coalesce(vote_type6,'-') ||
      coalesce(vote_type7,'-')  ||coalesce(vote_type8,'-')  ||coalesce(vote_type9,'-') ||
      coalesce(vote_type10,'-')||
      coalesce(vote_type11,'-') ||coalesce(vote_type12,'-') ||coalesce(vote_type13,'-')||
      coalesce(vote_type14,'-') ||coalesce(vote_type15,'-') ||coalesce(vote_type16,'-')||
      coalesce(vote_type17,'-') ||coalesce(vote_type18,'-') ||coalesce(vote_type19,'-')||
      coalesce(vote_type20,'-')||
      coalesce(vote_type21,'-') ||coalesce(vote_type22,'-') ||coalesce(vote_type23,'-')||
      coalesce(vote_type24,'-') ||coalesce(vote_type25,'-') ||coalesce(vote_type26,'-')||
      coalesce(vote_type27,'-') ||coalesce(vote_type28,'-') ||coalesce(vote_type29,'-')||
      coalesce(vote_type30,'-')||
      coalesce(vote_type31,'-') ||coalesce(vote_type32,'-') ||coalesce(vote_type33,'-')||
      coalesce(vote_type34,'-') ||coalesce(vote_type35,'-') ||coalesce(vote_type36,'-')||
      coalesce(vote_type37,'-') ||coalesce(vote_type38,'-') ||coalesce(vote_type39,'-')||
      coalesce(vote_type40,'-')
    as votetypes,

    coalesce(election_code1,'-')    ||coalesce(election_code2,'-')||coalesce(election_code3,'-')||
      coalesce(election_code4,'-')  ||coalesce(election_code5,'-')||coalesce(election_code6,'-')||
      coalesce(election_code7,'-')  ||coalesce(election_code8,'-')||coalesce(election_code9,'-')||
      coalesce(election_code10,'-')||
      coalesce(election_code11,'-')||coalesce(election_code12,'-')||coalesce(election_code13,'-')||
      coalesce(election_code14,'-')||coalesce(election_code15,'-')||coalesce(election_code16,'-')||
      coalesce(election_code17,'-')||coalesce(election_code18,'-')||coalesce(election_code19,'-')||
      coalesce(election_code20,'-')||
      coalesce(election_code21,'-')||coalesce(election_code22,'-')||coalesce(election_code23,'-')||
      coalesce(election_code24,'-')||coalesce(election_code25,'-')||coalesce(election_code26,'-')||
      coalesce(election_code27,'-')||coalesce(election_code28,'-')||coalesce(election_code29,'-')||
      coalesce(election_code30,'-')||
      coalesce(election_code31,'-')||coalesce(election_code32,'-')||coalesce(election_code33,'-')||
      coalesce(election_code34,'-')||coalesce(election_code35,'-')||coalesce(election_code36,'-')||
      coalesce(election_code37,'-')||coalesce(election_code38,'-')||coalesce(election_code39,'-')||
      coalesce(election_code40,'-')
    as electioncodes,

    coalesce(lastname,''),
    coalesce(firstname,''),
    coalesce(middlename,''),
    coalesce(namesuffix,''),
    coalesce(streetnumber,0) as streetnumber,
    coalesce(streetbuilding,''),
    coalesce(streetpredir,''),
    coalesce(streetname,'') as streetname,
    coalesce(streettype,'') as streettype,
    coalesce(streetpostdir,''),
    coalesce(unit_type,''),
    coalesce(unit,''),
    coalesce(city,'') as city,
    coalesce(zip,''),
    coalesce(zip4,'')

  from voter

  where streetnumber >= ((instreetnumber/100)*100)
    and streetnumber < ((instreetnumber/100)*100)+100
    and streetname = (select name from streets where name like upper(instreetname))
    and (instreettype is null or (streettype like upper(instreettype)))
    and (incity is null or (city like upper(incity)))

  order by streetnumber, streetname, streettype, city, name;

$$ LANGUAGE sql;

CREATE FUNCTION voters_on_block(
  instreetnumber integer,
  instreetkey integer
)
  RETURNS SETOF voters_on_block_results
AS $$

  select
    coalesce(firstname, ' ')    ||' '||
      coalesce(middlename, ' ') ||' '||
      coalesce(lastname, ' ')   ||' '||
      coalesce(namesuffix, ' ')
    as name,

    extract(year from current_date) - cast(birthdate as int) as age,
    cast(sos_voterid as int) as voterid,
    coalesce(voter_status, '-') as voterstatus,

    coalesce(streetnumber, 0)||' '||fullstreetname
    as Address,

    coalesce(party_code, '-') as partycode,

    'xxx'
    as partycodes,

    'xxx'
    as votetypes,

    'xxx'
    as electioncodes,

    coalesce(lastname,''),
    coalesce(firstname,''),
    coalesce(middlename,''),
    coalesce(namesuffix,''),
    coalesce(streetnumber,0) as streetnumber,
    coalesce(streetbuilding,''),
    '' as streetpredir,
    coalesce(streetname,'') as streetname,
    coalesce(streettype,'') as streettype,
    coalesce(streetdirection,'') as streetpostdir,
    coalesce(unit_type,''),
    coalesce(unit,''),
    coalesce(city,'') as city,
    coalesce(zip,''),
    '' as zip4

  from "Streets" s
  inner join "Voters" v
     on s.street_key = v.street_key

  where s.street_key = instreetkey
    and streetnumber >= ((instreetnumber/100)*100)
    and streetnumber < ((instreetnumber/100)*100)+100

  order by streetnumber, s.street_key; -- Streets keys are assinged in sorted order on name

$$ LANGUAGE sql;
