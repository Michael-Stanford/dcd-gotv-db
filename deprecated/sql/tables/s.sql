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
-- Name: sessions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sessions (
    user_id integer NOT NULL,
    session_id character(36) NOT NULL,
    expires timestamp with time zone
);


ALTER TABLE public.sessions OWNER TO postgres;

--
-- Data for Name: sessions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sessions (user_id, session_id, expires) FROM stdin;
2	62ed4175-0bad-4662-9ef8-6ebc733valid	2122-02-14 15:47:12.361648-06
1	9b8eac9d-59a7-482d-b950-dee97db71963	2022-02-15 12:54:01.242921-06
3	2217eddc-bf4e-4315-baf6-c1945b67a61b	2022-02-19 23:23:30.60122-06
3	718f34b0-2944-4031-a983-340e5bf5df03	2022-02-19 23:55:05.816175-06
3	ffcd9274-bc47-4b7f-aa07-8abb2f5ef850	2022-02-20 11:50:34.513719-06
3	cd716f27-2f81-4049-b801-2cd4bcdb64cb	2022-02-20 13:05:27.517277-06
3	7a6418a6-8d54-472a-9f94-9402c96dfd19	2022-02-20 15:00:41.511512-06
3	20c2f83e-1862-4ae3-973a-f0c9d0df2c00	2022-02-20 15:06:35.748562-06
3	389d99f8-7c20-479f-b98b-f8b9b9ea2d23	2022-02-20 15:09:11.100857-06
3	f6ef533a-f34f-4069-8de6-4aaecab471d1	2022-02-20 15:42:32.929579-06
3	9e12062a-5893-49f6-8f51-f8535a313731	2022-02-20 15:44:42.469-06
3	af269d72-7989-4516-906f-75e8d7adb499	2022-02-20 15:48:04.819212-06
3	4472348d-d600-4d4e-aca8-19c121aed681	2022-02-20 15:48:57.157432-06
3	cd92d207-8675-46c2-83d7-eb2bbe840092	2022-02-20 15:51:26.010135-06
3	5d6cbc89-9a80-486a-8fc9-67b923b6540b	2022-02-20 21:49:34.180607-06
3	ec2b1753-ec1d-4532-ab9f-8ce53193b715	2022-02-21 09:36:38.339714-06
3	10f21226-6dca-4b1b-bf53-ecfadcddc3d5	2022-02-21 09:44:40.5585-06
3	1513600f-f641-4d24-b63e-c81d0f517ceb	2022-02-21 10:11:11.769462-06
3	330b5dc3-491e-4986-ad31-e6806ff2f819	2022-02-21 10:18:01.491884-06
3	8f63d010-6c7d-4fe7-8437-b8cf714a22b8	2022-02-21 10:26:11.514751-06
3	0d40fb0e-b94a-4645-9c6a-5ba95b8b3ea2	2022-02-21 11:36:40.016634-06
3	55a726cf-b39c-4184-ae14-9d427ea1047c	2022-02-21 11:40:59.993811-06
3	82a39373-1efa-418a-9db9-bca2af0954bd	2022-02-21 11:54:40.588602-06
3	2962a4ab-d0c0-4e35-96bb-2acfc256eec8	2022-02-21 12:14:39.346558-06
3	98c466de-25a1-423b-acd2-3295d78edf0f	2022-02-21 12:15:37.53573-06
3	43a0de42-79ee-434d-a11e-f0da5e38ec9e	2022-02-21 12:23:19.324907-06
3	34f2192f-c5e0-48c2-a755-e85c75047fa4	2022-02-21 12:24:32.81656-06
3	6b45172b-7e38-4ff3-ad46-3592d52b54b3	2022-02-21 12:34:21.212112-06
3	f8ebc85c-a09a-46b0-895f-0ae06fc07915	2022-02-21 12:36:42.976458-06
3	927c07d1-2623-4f49-b9ce-ebb0da406b7b	2022-02-21 21:26:48.000862-06
3	984874ee-df24-42dc-b39f-2260420691f7	2022-02-21 21:31:10.690365-06
3	86471009-5388-4f00-8ce2-14aca4b50e9b	2022-02-21 23:11:19.177926-06
3	a2f06cad-ce5a-4b25-ab71-2f55e569d61c	2022-02-21 23:16:35.605364-06
3	f54bda09-c364-4435-b768-6acaf688fd68	2022-02-21 23:18:13.72288-06
3	be93dfdb-5afd-485c-9bde-58706ae076c5	2022-02-22 00:00:40.151663-06
3	6bc82dea-ef00-4099-a9e0-d025d9b9e26a	2022-02-22 00:02:08.109124-06
3	24125890-e49b-4e10-bf44-feef5fa0f2ba	2022-02-22 00:08:26.342623-06
3	6c97f27a-637a-475f-afe4-126f02c419cc	2022-02-22 00:10:33.334834-06
3	53f3227d-be2c-421f-80bd-e0125d95d1d8	2022-02-22 00:27:00.61545-06
3	7bf41954-5950-4401-b6d6-9bb54558193d	2022-02-22 00:28:19.267074-06
3	28728a0d-6f9b-40ef-900c-8c8161d2b391	2022-02-22 00:49:21.135824-06
3	f1e054bf-47e5-4184-8f65-3614d7f79d5a	2022-02-22 00:50:45.971431-06
3	9e1bac33-d4f4-401c-a808-68773cc7c58c	2022-02-22 00:52:26.699327-06
3	aea43581-753a-4990-9a09-0f07398a26da	2022-02-22 00:54:12.340973-06
3	e8ec8132-4e15-479e-9fd1-e21cb4f53fc5	2022-02-22 00:58:46.056503-06
3	c81fbbbb-8570-4245-9a91-94da9684a03f	2022-02-22 01:00:05.334081-06
3	83baf965-9ca0-43f7-a249-fad3277a1195	2022-02-22 01:05:31.896875-06
\.


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (session_id);


--
-- Name: session_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX session_id_idx ON public.sessions USING btree (session_id bpchar_pattern_ops);


--
-- PostgreSQL database dump complete
--

