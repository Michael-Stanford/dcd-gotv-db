
DROP TABLE IF EXISTS users cascade;

CREATE TABLE IF NOT EXISTS users
(
    id serial,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    deleted_at timestamp with time zone,
    email character varying(128),
    name character varying(128),
    phone character varying(128),
    role integer,
    PRIMARY KEY (id)
);

CREATE INDEX IF NOT EXISTS idx_users_deleted_at
    ON users USING btree
    (deleted_at ASC NULLS LAST);
	