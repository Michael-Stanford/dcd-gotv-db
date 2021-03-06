--
-- PostgreSQL database dump
--

-- Dumped from database version 14.1
-- Dumped by pg_dump version 14.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: passcodes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.passcodes (
    user_id integer NOT NULL,
    passcode character(6),
    try_count integer DEFAULT 3,
    expires timestamp with time zone NOT NULL
);


ALTER TABLE public.passcodes OWNER TO postgres;

--
-- Data for Name: passcodes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.passcodes (user_id, passcode, try_count, expires) FROM stdin;
\.


--
-- Name: passcodes passcodes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.passcodes
    ADD CONSTRAINT passcodes_pkey PRIMARY KEY (user_id);


--
-- PostgreSQL database dump complete
--

