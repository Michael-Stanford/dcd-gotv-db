
select * from get_registered_voters('1000', 8718560);

select * from get_registered_voters('2508');

select * from get_unregistered_voters('1000', 8718560);

select * from get_unregistered_voters('2508');

select * from get_unregistered_voters('2217', 53342129);

select * from get_unregistered_voters('2501');

select * from bq_street_extract
where street_name like 'SHADY CREEK%'
;

select * from get_registered_voters('2217', 53342129);