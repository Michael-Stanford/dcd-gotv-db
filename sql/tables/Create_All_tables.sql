
-- Run from psql command
--
-- psql -d dcd -f Create_All_tables.sql
--
--   -d is the Database to process
--
--   Other parameters which may be needed to identify instance of postgres
--     -h DB host name
--     -U DB user
--

\i address_extract.sql
\i bq_reregistration_targets_extract_splitaddress.sql
\i city_extract.sql
\i direction_extract.sql
\i person_extract.sql
\i precinct_extract.sql
\i reregistration_targets_extract.sql
\i street_extract.sql
\i street_type_extract.sql
\i streets_by_precinct_extract.sql
\i unit_extract.sql
\i unit_type_extract.sql
\i Chairs_Create.sql
\i Passcodes_Create.sql
\i Sessions_Create.sql
\i Users_Create.sql
\i address_supplement_create.sql
\i precinct_chair_mapping.sql
\i precinct_geocode_create.sql
