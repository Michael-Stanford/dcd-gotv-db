
drop table if exists dcad_property_raw cascade;

create table dcad_property_raw
(
  address character varying(128),
  owner_name character varying(128),
  street_number character varying(128),
  street_name character varying(128),
  subdivision character varying(128),
  legal_description character varying(256)
);

-- \copy dcad_property_raw from '~/Downloads/24_b.csv' with DELIMITER ',' CSV QUOTE '"' ESCAPE '''' HEADER;