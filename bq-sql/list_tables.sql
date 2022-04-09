select * from demstxdallascp.vansync.__TABLES__
union all select * from demstxdallascp.vansync_derived.__TABLES__
union all select * from democrats.census.__TABLES__
union all select * from democrats.census_2020.__TABLES__
union all select * from democrats.dimensions.__TABLES__
union all select * from democrats.election_results.__TABLES__
union all select * from democrats.election_results_sources.__TABLES__
union all select * from democrats.functions.__TABLES__
union all select * from democrats.reference.__TABLES__
union all select * from democrats.reference_geo.__TABLES__
union all select * from democrats.vansync_ref.__TABLES__
--order by table_id
order by row_count desc
;

select project_id,
dataset_id,	
table_id,	
TIMESTAMP_MILLIS(creation_time),	
TIMESTAMP_MILLIS(last_modified_time),	
row_count,	
size_bytes,	
type 
from `demstxdallascp.sbx_farrarb.TableList`;
