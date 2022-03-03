-- This script was generated by a beta version of the ERD tool in pgAdmin 4.
-- Please log an issue at https://redmine.postgresql.org/projects/pgadmin4/issues/new if you find any bugs, including reproduction steps.
BEGIN;

drop TABLE IF EXISTS "Streets","MailAddress","Voters","VotingRecord","Cities", precincts, streets_by_precinct cascade;

CREATE TABLE "Voters"
(
    sos_voterid bigint,
    party_code character(1),
    voter_status character(1),
    lastname character varying(30),
    firstname character varying(30),
    middlename character varying(30),
    namesuffix character varying(3),
    streetnumber bigint,
    streetbuilding character varying(4),
    unit_type character varying(5),
    unit character varying(16),
    sex character(1),
    birthdate bigint,
    eligible_date date,
    effective_date date,
    precinct character(4),
    precsub character(2),
    county character(2),
    us_congress character(2),
    st_senate character(2),
    st_rep character(3),
    commissioner character(1),
    city_code character(3),
    city_single_member character(3),
    school character(3),
    school_single_member character(3),
    water character(3),
    college_district character(3),
    flood_control character(3),
    justice_of_the_peace character(1),
    state_board_of_edu character(2),
    precinct_chair character(3),
    registration_date date,
    party_affiliation_date date,
    last_activity_date date,
    id_compliant character(1),
    absentee_category character(3),
    absentee_category_date date,
    street_key bigint,
    PRIMARY KEY (sos_voterid)
);
create index Voters_streetnumber on "Voters"(streetnumber);
create index Voters_precinct on "Voters"(precinct);

CREATE TABLE "Streets"
(
    street_key serial,
    streetname character varying(25),
    streettype character varying(4),
    streetdirection character varying(2),
    city character varying(15),
    zip character (5),
    fullstreetname character varying(45),
    PRIMARY KEY (street_key)
);

CREATE TABLE "MailAddress"
(
    sos_voterid bigint,
    mail1 character varying(32),
    mail2 character varying(32),
    mail3 character varying(32),
    mailcity character varying(32),
    mailstate character (2),
    mailzip character (5),
    mailzip4 character (4),
    PRIMARY KEY (sos_voterid)
);

CREATE TABLE "VotingRecord"
(
    sos_voterid bigint,
    "order" bigint,
    election_code character(4),
    vote_type character(1),
    party_code character(2),
    PRIMARY KEY (sos_voterid, "order")
);

CREATE TABLE "Cities"
(
    city character varying(15),
    PRIMARY KEY (city)
);

CREATE TABLE precincts
(
    precinct char(4) NOT NULL,
	chair_key int,
	commissioner character(1),
	justice_of_the_peace character(1),
	us_congress character(2),	
	st_senate character(2),	
	state_board_of_edu character(2),	
	st_rep character(3),
    PRIMARY KEY (precinct)
);

CREATE TABLE streets_by_precinct
(
    street_key int NOT NULL,
    precincts character varying(128) NOT NULL,
    PRIMARY KEY (street_key)
);

ALTER TABLE "Voters"
    ADD FOREIGN KEY (street_key)
    REFERENCES "Streets" (street_key)
    NOT VALID;

ALTER TABLE "VotingRecord"
    ADD FOREIGN KEY (sos_voterid)
    REFERENCES "Voters" (sos_voterid)
    NOT VALID;

ALTER TABLE "MailAddress"
    ADD FOREIGN KEY (sos_voterid)
    REFERENCES "Voters" (sos_voterid)
    NOT VALID;

END;