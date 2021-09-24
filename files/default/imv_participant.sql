--
-- PostgreSQL database dump
--

-- Dumped from database version 11.6 (Ubuntu 11.6-1.pgdg18.04+1)
-- Dumped by pg_dump version 11.2

-- Started on 2019-11-20 18:21:43

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 3 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO postgres;

--
-- TOC entry 2930 (class 0 OID 0)
-- Dependencies: 3
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS 'standard public schema';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 197 (class 1259 OID 16388)
-- Name: participant; Type: TABLE; Schema: public; Owner: imvadmin
--

CREATE TABLE public.participant (
	id int4 NOT NULL,
	"name" varchar(50) NOT NULL,
	email varchar(50) NOT NULL,
	mobile varchar(50) NOT NULL,
	companion_1 varchar(50) NULL,
	companion_2 varchar(50) NULL,
	companion_3 varchar(50) NULL,
	companion_4 varchar(50) NULL,
	created_at timestamp NOT NULL,
	updated_at timestamp NOT NULL,
	"token" int4 NOT NULL,
	has_been_scanned bool NOT NULL DEFAULT false,
	has_been_scanned_amount int4 NOT NULL DEFAULT 0,
	CONSTRAINT participant_pkey PRIMARY KEY (id)
);
CREATE UNIQUE INDEX uniq_c8c96b255f37a13b ON public.participant USING btree (token);
CREATE UNIQUE INDEX uniq_c8c96b25e7927c74 ON public.participant USING btree (email);


ALTER TABLE public.participant OWNER TO imvadmin;

--
-- TOC entry 196 (class 1259 OID 16386)
-- Name: participant_id_seq; Type: SEQUENCE; Schema: public; Owner: imvadmin
--

CREATE SEQUENCE public.participant_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.participant_id_seq OWNER TO imvadmin;

--
-- TOC entry 2924 (class 0 OID 16388)
-- Dependencies: 197
-- Data for Name: participant; Type: TABLE DATA; Schema: public; Owner: imvadmin
--

INSERT INTO public.participant VALUES (1, 'Sufian Abu-Rab', 's.aburab@gmail.com', '12345', '017645866729', 'Achmed Abu-Rab', 'Mohammed Abu-Rab', 'Amir Abu-Rab', 'Karim Abu-Rab', '2021-06-01 15:00:29', '2021-06-01 15:00:29');


--
-- TOC entry 2931 (class 0 OID 0)
-- Dependencies: 196
-- Name: participant_id_seq; Type: SEQUENCE SET; Schema: public; Owner: imvadmin
--

SELECT pg_catalog.setval('public.participant_id_seq', 1, false);


--
-- TOC entry 2801 (class 2606 OID 16393)
-- Name: participant participant_pkey; Type: CONSTRAINT; Schema: public; Owner: imvadmin
--

ALTER TABLE ONLY public.participant
    ADD CONSTRAINT participant_pkey PRIMARY KEY (id);


-- Completed on 2019-11-20 18:21:45

--
-- PostgreSQL database dump complete
--
