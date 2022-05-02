
BEGIN;

drop TABLE IF EXISTS bq_addresses_raw, bq_streets, bq_addresses cascade;

CREATE TABLE bq_addresses_raw
(
	address_id int,
	street_number character varying(20),
	street_pre_dir character varying(4),
	street_name character varying(64),
	street_type character varying(10),
	street_post_dir character varying(4),
    city character varying(15),
    zip character (5),
	longitude double precision,
	latitude double precision
);

CREATE TABLE bq_streets
(
	street_id serial,
	street_pre_dir character varying(4),
	street_name character varying(64),
	street_type character varying(10),
	street_post_dir character varying(4),
    city character varying(15),
    zip character (5),
	fullstreetname character varying(60),
	primary key(street_id)
);

CREATE TABLE bq_addresses
(
	address_id int,
	street_id int,
    street_number character varying(20),
	longitude double precision,
	latitude double precision,
	primary key(address_id)
);

create index bq_addresses_index_street_number_street_id on bq_addresses(street_number, street_id);

END;