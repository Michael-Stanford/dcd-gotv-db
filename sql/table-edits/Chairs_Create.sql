drop TABLE IF EXISTS chairs cascade;

CREATE TABLE chairs
(
    key int NOT NULL,
	firstname character varying(64) NOT NULL,
	lastname character varying(64) NOT NULL,
	email character varying(64),
	phone character varying(15),
	address character varying(64),
	city character varying(15),
	zip character varying(10),
    PRIMARY KEY (key)
);
