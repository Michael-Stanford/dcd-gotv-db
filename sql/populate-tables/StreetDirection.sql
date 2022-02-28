select streetpredir,streetpostdir from voter
where streetpredir is not null and streetpostdir is not null
;

alter table voter add column streetdirection char(2);

update voter set streetdirection = null;
update voter set streetdirection = trim(streetpredir)
where streetpredir is not null and (streetpostdir is null || streetpredir = streetpostdir);
update voter set streetdirection = trim(streetpostdir)
where streetpredir is null and streetpostdir is not null;
update voter set streetdirection = trim(streetpredir)||trim(streetpostdir)
where streetpredir is not null and streetpostdir is not null and streetpredir != streetpostdir;

select streetdirection,streetpredir,streetpostdir from voter where streetdirection is not null;

select distinct(streetdirection),count(*) from voter group by streetdirection order by streetdirection;
