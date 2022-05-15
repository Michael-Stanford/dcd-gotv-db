drop table if exists address_supplement, property_codes cascade;

create table property_codes (
	code char(1),
	description character varying(64),
	primary key (code)
);

create table address_supplement (
	address_geo_id int,
	precinct_name char(5),
	property_type char(1) default 'U',
    gated boolean DEFAULT false,
    estimated_number_of_units integer DEFAULT 1,
    propertyname character varying(64),
    PRIMARY KEY (address_geo_id, precinct_name)
);

insert into property_codes (code, description)
values
('S', 'Single Family'),
('M', 'Multi-Family'),
('A', 'Apartment'),
('U', 'Unknown')
;


