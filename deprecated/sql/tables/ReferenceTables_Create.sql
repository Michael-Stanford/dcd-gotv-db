drop table if exists streetnames,streettypes,streetdirections,streetbuildings,units,unit_types;

create table streetnames (
	streetname character varying(25),
	primary key (streetname)
);
create table streettypes (
	streettype character varying(4),
	primary key (streettype)
);	
create table streetdirections (
	streetdirection character varying(2),
	primary key (streetdirection)
);	
create table streetbuildings (
	streetbuilding character varying(4),
	primary key (streetbuilding)
);
create table units (
	unit character varying(15),
	primary key (unit)
);
create table unit_types (
	unit_type character varying(5),
	primary key (unit_type)
);
insert into streetnames select distinct streetname from "Streets" where streetname is not null order by 1;
insert into streettypes select distinct streettype from "Streets" where streettype is not null order by 1;
insert into streetdirections select distinct streetdirection from "Streets" where streetdirection is not null and streetdirection <> '' order by 1;
insert into streetbuildings select distinct streetbuilding from "voter" where streetbuilding is not null order by 1;
insert into units select distinct trim(replace(unit,'#','')) from "voter" where unit is not null order by 1;
insert into unit_types select distinct unit_type from "voter" where unit_type is not null order by 1;