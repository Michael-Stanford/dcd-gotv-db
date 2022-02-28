
DROP TABLE IF EXISTS passcodes cascade;

CREATE TABLE IF NOT EXISTS passcodes
(
    user_id integer NOT NULL,
    passcode character(6),
    try_count integer DEFAULT 3,
    expires timestamp with time zone NOT NULL,
    PRIMARY KEY (user_id)
);
