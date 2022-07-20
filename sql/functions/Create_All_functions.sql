--
-- Run this script from psql
--
-- Examples:
--
-- psql -d dcd -f Create_All_functions.sql
--
-- psql -h database-1.cy4bk11o7qap.us-east-2.rds.amazonaws.com -U postgres -d dcd -f Create_All_functions.sql
--
-- Note:
--
--   -d is the Database to process
--
--   Other parameters which may be needed to identify instance of postgres
--     -h DB host name
--     -U DB user

CREATE EXTENSION earthdistance CASCADE;

\i GetCities_Function.sql
\i GetStreets_Function.sql
\i Get_Addresses_Function.sql
\i Get_Precincts_Function.sql
\i Get_Registered_Voters.sql
\i Get_Unregistered_Voters.sql
\i Update_Address_Function.sql

