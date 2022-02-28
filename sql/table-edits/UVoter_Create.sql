
drop table if exists uvoter_raw, uvoter, uvoter_splitaddress cascade;

create table uvoter_raw (
	myv_van_id character varying(64),
	person_id character varying(64),
	first_name character varying(64),
	last_name character varying(64),
	address character varying(64),
	address_2 character varying(64),
	city character varying(64),
	state character varying(64),
	zip character varying(64),
	zip4 character varying(64),
	county character varying(64),
	van_precinct_name character varying(64),
	state_house_district character varying(64),
	target_type character varying(64),
	phone_1 character varying(64),
	phone_2 character varying(64),
	phone_3 character varying(64),
	phone_4  character varying(64),
	id serial primary key
);

create table uvoter (
	myv_van_id character varying(64),
	person_id character varying(64),
	first_name character varying(64),
	last_name character varying(64),
	address character varying(64),
	address_2 character varying(64),
	city character varying(64),
	state character varying(64),
	zip character varying(64),
	zip4 character varying(64),
	county character varying(64),
	van_precinct_name character varying(64),
	state_house_district character varying(64),
	target_type character varying(64),
	phone_1 character varying(64),
	phone_2 character varying(64),
	phone_3 character varying(64),
	phone_4  character varying(64),
	primary key (person_id)
);
create index uvoter_van_precinct_name on uvoter(van_precinct_name);

create table uvoter_splitaddress (
	person_id character varying(64),
	street_key int,
	streetnumber character varying(64),
    streetdirection varchar(64),
    streetname varchar(64),
    streettype varchar(64),
    streetbuilding varchar(64),
    unit_type varchar(64),
    unit varchar(64),
	extra varchar(150),
	primary key (person_id)
);
