
-- standardSQL 
SELECT dataset_id, table_id, 
# Convert size in bytes to GB 
ROUND(size_bytes/POW(10,9),2) AS size_gb, 
# Convert creation_time and last_modified_time from UNIX EPOCH format to a timestamp 
TIMESTAMP_MILLIS(creation_time) AS creation_time, TIMESTAMP_MILLIS(last_modified_time) AS last_modified_time,
row_count, 
# Convert table type from numerical value to description 
CASE 
WHEN type = 1 THEN 'table' 
WHEN type = 2 THEN 'view' 
ELSE NULL 
END AS type 
FROM `demstxsp.tdp_dallasdems.__TABLES__` 
ORDER BY size_gb DESC;

SELECT * FROM `demstxsp.tdp_dallasdems.INFORMATION_SCHEMA.TABLES`
where table_name = 'person'
;


SELECT * FROM `demstxsp.tdp_dallasdems.INFORMATION_SCHEMA.COLUMNS`
;

SELECT * FROM `demstxsp.tdp_dallasdems.INFORMATION_SCHEMA.COLUMNS`
--where table_name = 'person' and column_name like '%address_id%'
where table_name = 'person' and column_name like '%precinct%'
--where table_name = 'address' and column_name like '%precinct%'
;

SELECT * FROM `demstxsp.tdp_dallasdems.__TABLES__`
where table_id = 'person'
;