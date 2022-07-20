--
-- Run this script from psql
--
-- Examples:
--
-- psql -d dcd -f copy_tables_to_csv.sql
--
-- psql -h database-1.cy4bk11o7qap.us-east-2.rds.amazonaws.com -U postgres -d dcd -f copy_tables_to_csv.sql
--
-- Note:
--
--   -d is the Database to process
--
--   Other parameters which may be needed to identify instance of postgres
--     -h DB host name
--     -U DB user

\copy address_supplement to '/tmp/address_supplement.csv' DELIMITER ',' CSV HEADER;
\copy address_supplement_notes to '/tmp/address_supplement_notes.csv' DELIMITER ',' CSV HEADER;
\copy bq_address_extract to '/tmp/bq_address_extract.csv' DELIMITER ',' CSV HEADER;
\copy bq_city_extract to '/tmp/bq_city_extract.csv' DELIMITER ',' CSV HEADER;
\copy bq_direction_extract to '/tmp/bq_direction_extract.csv' DELIMITER ',' CSV HEADER;
\copy bq_person_extract to '/tmp/bq_person_extract.csv' DELIMITER ',' CSV HEADER;
\copy bq_precinct_extract to '/tmp/bq_precinct_extract.csv' DELIMITER ',' CSV HEADER;
\copy bq_reregistration_targets_extract to '/tmp/bq_reregistration_targets_extract.csv' DELIMITER ',' CSV HEADER;
\copy bq_reregistration_targets_extract_splitaddress to '/tmp/bq_reregistration_targets_extract_splitaddress.csv' DELIMITER ',' CSV HEADER;
\copy bq_street_extract to '/tmp/bq_street_extract.csv' DELIMITER ',' CSV HEADER;
\copy bq_street_type_extract to '/tmp/bq_street_type_extract.csv' DELIMITER ',' CSV HEADER;
\copy bq_streets_by_precinct_extract to '/tmp/bq_streets_by_precinct_extract.csv' DELIMITER ',' CSV HEADER;
\copy bq_unit_extract to '/tmp/bq_unit_extract.csv' DELIMITER ',' CSV HEADER;
\copy bq_unit_type_extract to '/tmp/bq_unit_type_extract.csv' DELIMITER ',' CSV HEADER;
\copy chairs to '/tmp/chairs.csv' DELIMITER ',' CSV HEADER;
\copy passcodes to '/tmp/passcodes.csv' DELIMITER ',' CSV HEADER;
\copy precinct_chair_mapping to '/tmp/precinct_chair_mapping.csv' DELIMITER ',' CSV HEADER;
\copy precinct_geocode to '/tmp/precinct_geocode.csv' DELIMITER ',' CSV HEADER;
\copy property_codes to '/tmp/property_codes.csv' DELIMITER ',' CSV HEADER;
\copy sessions to '/tmp/sessions.csv' DELIMITER ',' CSV HEADER;
\copy users to '/tmp/users.csv' DELIMITER ',' CSV HEADER;