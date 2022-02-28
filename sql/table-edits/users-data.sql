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

--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, created_at, updated_at, deleted_at, email, name) FROM stdin;
1	2022-02-14 12:54:01.214172-06	2022-02-14 12:54:01.214172-06	\N	test.user@dcd-gotv.org	Test User
2	2022-02-13 15:47:12.331526-06	2022-02-13 15:47:12.331526-06	\N	valid.session@dcd-gotv.org	Valid Session ID
3	2022-02-13 15:47:12.331526-06	2022-02-13 15:47:12.331526-06	\N	michael@stanford.cc	Michael Stanford
4	2022-02-13 15:47:12.331526-06	2022-02-13 15:47:12.331526-06	\N	bafarrar@yahoo.com	Brian Farrar
\.


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 1, true);


--
-- PostgreSQL database dump complete
--

