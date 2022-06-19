
drop table if exists geocodes cascade;

CREATE TABLE geocodes (
    streetnumber int NOT NULL,
	street_key int NOT NULL,
	address character varying(100) NOT NULL,
    match1 character varying(10) NOT NULL,
    match2 character varying(10) NOT NULL,
    lat double precision NOT NULL,
    lng double precision NOT NULL,
	streetside char(1) NOT NULL,
	primary key (streetnumber, street_key)
);

CREATE INDEX geocodes_location_idx ON geocodes USING gist (ll_to_earth(lat, lng));
