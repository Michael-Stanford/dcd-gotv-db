
-- CREATE EXTENSION postgis;  -- May not be needed for only distnace calculations
CREATE EXTENSION earthdistance CASCADE;

show role;

alter role postgres superuser;

SELECT current_user,
       user,
       session_user,
       current_database(),
       current_catalog,
       version();

create sequence "GIStestSchema".cities_seq;
CREATE TABLE "GIStestSchema".cities (
    id integer DEFAULT nextval('"GIStestSchema".cities_seq'::regclass) NOT NULL,
    name character varying NOT NULL,
    region character varying NOT NULL,
    lat double precision NOT NULL,
    lng double precision NOT NULL
);

ALTER TABLE ONLY "GIStestSchema".cities
    ADD CONSTRAINT cities_pkey PRIMARY KEY (id);

CREATE INDEX cities_name_low_idx ON "GIStestSchema".cities USING btree
(lower((name)::text));

CREATE INDEX cities_location_idx ON "GIStestSchema".cities USING gist (ll_to_earth(lat, lng));

SELECT COUNT(*), pg_size_pretty(pg_relation_size('"GIStestSchema".cities')) AS data, pg_size_pretty(pg_indexes_size('"GIStestSchema".cities')) AS idxs 
FROM "GIStestSchema".cities;

select count(*) from "GIStestSchema".cities;
select * from "GIStestSchema".cities fetch first 100 rows only;


SELECT *, (point(lng, lat) <@> point(-96.737885, 32.983276)) AS distance -- 2217 Shady Creek Dr
FROM  "GIStest"."GIStestSchema".cities
WHERE     (point(lng, lat) <@> point(-96.737885, 32.983276)) < 1
ORDER BY  distance;

SELECT *, (point(lng, lat) <@> point(-96.783356, 32.85926)) AS distance -- 2217 Shady Creek Dr
FROM  "GIStestSchema".cities
WHERE     (point(lng, lat) <@> point(-96.783356, 32.85926)) < 1
ORDER BY  distance;