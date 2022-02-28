
DROP TABLE IF EXISTS sessions cascade;

CREATE TABLE IF NOT EXISTS sessions
(
    user_id integer NOT NULL,
    session_id character(36) NOT NULL,
    expires timestamp with time zone,
    PRIMARY KEY (session_id)
);

CREATE UNIQUE INDEX IF NOT EXISTS session_id_idx
    ON sessions USING btree
    (session_id bpchar_pattern_ops ASC NULLS LAST);
