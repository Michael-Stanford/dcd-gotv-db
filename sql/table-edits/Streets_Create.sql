drop index if exists streets_name;
drop table if exists streets;

create table streets (
name varchar(64)
);

create index streets_name on streets(name);

insert into streets
select distinct streetname from voter;
