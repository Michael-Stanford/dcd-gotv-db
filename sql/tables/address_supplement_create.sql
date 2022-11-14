drop table if exists address_supplement, property_codes cascade;

create table property_codes (
	code char(1),
	description character varying(64),
	primary key (code)
);

create table address_supplement (
	address_geo_id int, -- comes from Street#, Street (predir, name, postdir, type), City, Zip5
	property_type char(1) default 'U',
	number_of_buildings int DEFAULT 0,
	number_of_floors int DEFAULT 0,
    number_of_units int DEFAULT 0,
    restricted boolean DEFAULT false,
    complex_name character varying(64),
	complex_contact character varying(64),
	complex_phone character varying(64),
    modified_date timestamp DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (address_geo_id)
);

insert into property_codes (code, description)
values
('S', 'Single Family'),
('C', 'Condo'),
('T', 'Townhome'),
('M', 'Multi-Family'),
('A', 'Apartment'),
('U', 'Unknown')
;
