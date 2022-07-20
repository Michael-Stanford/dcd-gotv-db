--
-- Run this script from psql
--
-- Examples:
--
-- psql -d dcd -f copy_tables_from_csv.sql
--
-- psql -h database-1.cy4bk11o7qap.us-east-2.rds.amazonaws.com -U postgres -d dcd -f copy_tables_from_csv.sql
--
-- Note:
--
--   -d is the Database to process
--
--   Other parameters which may be needed to identify instance of postgres
--     -h DB host name
--     -U DB user

delete from address_supplement; 
delete from address_supplement_notes; 
delete from bq_address_extract;
delete from bq_city_extract;
delete from bq_direction_extract;
delete from bq_person_extract;
delete from bq_precinct_extract;
delete from bq_reregistration_targets_extract;
delete from bq_reregistration_targets_extract_splitaddress;
delete from bq_street_extract;
delete from bq_street_type_extract;
delete from bq_streets_by_precinct_extract;
delete from bq_unit_extract;
delete from bq_unit_type_extract;
delete from chairs;
delete from passcodes;
delete from precinct_chair_mapping;
delete from precinct_geocode;
delete from property_codes;
delete from sessions;
delete from users;

copy address_supplement from '/tmp/address_supplement.csv' DELIMITER ',' CSV HEADER;
copy address_supplement_notes from '/tmp/address_supplement_notes.csv' DELIMITER ',' CSV HEADER;
copy bq_address_extract from '/tmp/bq_address_extract.csv' DELIMITER ',' CSV HEADER;
copy bq_city_extract from '/tmp/bq_city_extract.csv' DELIMITER ',' CSV HEADER;
copy bq_direction_extract from '/tmp/bq_direction_extract.csv' DELIMITER ',' CSV HEADER;
copy bq_person_extract from '/tmp/bq_person_extract.csv' DELIMITER ',' CSV HEADER;
copy bq_precinct_extract from '/tmp/bq_precinct_extract.csv' DELIMITER ',' CSV HEADER;
copy bq_reregistration_targets_extract from '/tmp/bq_reregistration_targets_extract.csv' DELIMITER ',' CSV HEADER;
copy bq_reregistration_targets_extract_splitaddress from '/tmp/bq_reregistration_targets_extract_splitaddress.csv' DELIMITER ',' CSV HEADER;
copy bq_street_extract from '/tmp/bq_street_extract.csv' DELIMITER ',' CSV HEADER;
copy bq_street_type_extract from '/tmp/bq_street_type_extract.csv' DELIMITER ',' CSV HEADER;
copy bq_streets_by_precinct_extract from '/tmp/bq_streets_by_precinct_extract.csv' DELIMITER ',' CSV HEADER;
copy bq_unit_extract from '/tmp/bq_unit_extract.csv' DELIMITER ',' CSV HEADER;
copy bq_unit_type_extract from '/tmp/bq_unit_type_extract.csv' DELIMITER ',' CSV HEADER;
copy chairs from '/tmp/chairs.csv' DELIMITER ',' CSV HEADER;
copy passcodes from '/tmp/passcodes.csv' DELIMITER ',' CSV HEADER;
copy precinct_chair_mapping from '/tmp/precinct_chair_mapping.csv' DELIMITER ',' CSV HEADER;
copy precinct_geocode from '/tmp/precinct_geocode.csv' DELIMITER ',' CSV HEADER;
copy property_codes from '/tmp/property_codes.csv' DELIMITER ',' CSV HEADER;
copy sessions from '/tmp/sessions.csv' DELIMITER ',' CSV HEADER;
copy users from '/tmp/users.csv' DELIMITER ',' CSV HEADER;

select count(*),'address_supplement' as tablename from address_supplement 
union select count(*),'address_supplement_notes' as tablename from address_supplement_notes 
union select count(*),'bq_address_extract' as tablename from bq_address_extract
union select count(*),'bq_city_extract' as tablename from bq_city_extract
union select count(*),'bq_direction_extract' as tablename from bq_direction_extract
union select count(*),'bq_person_extract' as tablename from bq_person_extract
union select count(*),'bq_precinct_extract' as tablename from bq_precinct_extract
union select count(*),'bq_reregistration_targets_extract' as tablename from bq_reregistration_targets_extract
union select count(*),'bq_reregistration_targets_extract_splitaddress' as tablename from bq_reregistration_targets_extract_splitaddress
union select count(*),'bq_street_extract' as tablename from bq_street_extract
union select count(*),'bq_street_type_extract' as tablename from bq_street_type_extract
union select count(*),'bq_streets_by_precinct_extract' as tablename from bq_streets_by_precinct_extract
union select count(*),'bq_unit_extract' as tablename from bq_unit_extract
union select count(*),'bq_unit_type_extract' as tablename from bq_unit_type_extract
union select count(*),'chairs' as tablename from chairs
union select count(*),'passcodes' as tablename from passcodes
union select count(*),'precinct_chair_mapping' as tablename from precinct_chair_mapping
union select count(*),'precinct_geocode' as tablename from precinct_geocode
union select count(*),'property_codes' as tablename from property_codes
union select count(*),'sessions' as tablename from sessions
union select count(*),'users' as tablename from users
order by tablename
;