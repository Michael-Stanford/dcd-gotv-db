drop table if exists address_supplement_notes cascade;

create table address_supplement_notes (
	address_geo_id int,
    seq int,
	note character varying(1024),
    PRIMARY KEY (address_geo_id, seq)
);
