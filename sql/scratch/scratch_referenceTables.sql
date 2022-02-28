
select * from streetnames;
select * from streettypes;
select * from streetdirections;
select * from streetbuildings;
select * from units where unit like 'AP%';
select * from unit_types;

select 'streetnames',count(*) from streetnames union all
select 'streettypes',count(*) from streettypes union all
select 'streetdirections',count(*) from streetdirections union all
select 'strestreetbuildingsetnames',count(*) from streetbuildings union all
select 'units',count(*) from units union all
select 'unit_types',count(*) from unit_types;

select 'streetnames',max(length(streetname)) from streetnames union all
select 'streettypes',max(length(streettype)) from streettypes union all
select 'streetdirections',max(length(streetdirection)) from streetdirections union all
select 'strestreetbuildingsetnames',max(length(streetbuilding)) from streetbuildings union all
select 'units',max(length(unit)) from units union all
select 'unit_types',max(length(unit_type)) from unit_types;

select distinct trim(replace(unit,'#','')) from "voter" where unit is not null order by 1;

select address from "uvoter";