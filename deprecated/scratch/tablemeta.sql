
-- select schemas
select distinct schemaname from pg_catalog.pg_tables;

-- select tables
SELECT tablename
FROM pg_catalog.pg_tables
WHERE schemaname not in ('pg_catalog', 'information_schema')
order by 1 
;

-- COPY address_supplement TO '/tmp/address_supplement.csv' DELIMITER ',' CSV HEADER;
select 'copy ' || tablename || ' to ''/tmp/' || tablename || '.csv'' DELIMITER '','' CSV HEADER;'
FROM pg_catalog.pg_tables
WHERE schemaname not in ('pg_catalog', 'information_schema')
order by 1 
;

--  Select columns
select table_schema,
       table_name,
       ordinal_position as position,
       column_name,
       data_type,
       case when character_maximum_length is not null
            then character_maximum_length
            else numeric_precision end as max_length,
       is_nullable,
       column_default as default_value
from information_schema.columns
where table_schema not in ('information_schema', 'pg_catalog')
  --and table_name = 'voter'
order by table_schema, 
         table_name,
         ordinal_position;