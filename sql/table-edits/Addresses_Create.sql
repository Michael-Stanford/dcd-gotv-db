drop table if exists addresses, property_codes cascade;

create table property_codes (
	code char(1),
	description character varying(64),
	primary key (code)
);

create table addresses (
	street_key int,
	streetnumber int,
    precinct character(4) NOT NULL,
	property_code char(1) default 'U',
    gated boolean DEFAULT false,
    estimated_number_of_units integer DEFAULT 1,
    propertyname character varying(64),
    PRIMARY KEY (street_key, streetnumber, precinct)
);

insert into property_codes (code, description)
values
('S', 'Single Family'),
('M', 'Multi-Family'),
('A', 'Apartment'),
('U', 'Unknown')
;


