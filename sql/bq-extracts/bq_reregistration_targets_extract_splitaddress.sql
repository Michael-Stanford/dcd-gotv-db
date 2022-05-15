
drop table if exists bq_reregistration_targets_extract_splitaddress cascade;

create table bq_reregistration_targets_extract_splitaddress (
	person_id int,
	address_geo_id int,
	street_number character varying(64),
    street_pre_dir character varying(64),
    street_name character varying(64),
    street_type character varying(64),
    street_post_dir character varying(64),
    unit_type character varying(64),
    unit character varying(64),
	extra character varying(150),
	city character varying(64),
	zip char(5),
	primary key (person_id)
);

create index bq_reregistration_targets_extract_splitaddress_i_address_geo_id on bq_reregistration_targets_extract_splitaddress(address_geo_id);