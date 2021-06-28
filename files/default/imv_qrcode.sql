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
-- Name: qrcode; Type: TABLE; Schema: public; Owner: imvadmin
--

CREATE TABLE public.qrcode (
    id integer NOT NULL,
    shortid character varying(32) NOT NULL,
    title character varying(255) NOT NULL,
    version integer DEFAULT 0,
    created_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


ALTER TABLE public.qrcode OWNER TO imvadmin;

--
-- TOC entry 196 (class 1259 OID 16386)
-- Name: qrcode_id_seq; Type: SEQUENCE; Schema: public; Owner: imvadmin
--

CREATE SEQUENCE public.qrcode_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.qrcode_id_seq OWNER TO imvadmin;

--
-- TOC entry 2924 (class 0 OID 16388)
-- Dependencies: 197
-- Data for Name: qrcode; Type: TABLE DATA; Schema: public; Owner: imvadmin
--

INSERT INTO public.qrcode VALUES (1, 'create-react-qrcode', 'create-react-qrcode', 0, '2019-11-01 15:00:29', '2019-11-01 15:00:18');


--
-- TOC entry 2931 (class 0 OID 0)
-- Dependencies: 196
-- Name: qrcode_id_seq; Type: SEQUENCE SET; Schema: public; Owner: imvadmin
--

SELECT pg_catalog.setval('public.qrcode_id_seq', 1, false);


--
-- TOC entry 2801 (class 2606 OID 16393)
-- Name: qrcode qrcode_pkey; Type: CONSTRAINT; Schema: public; Owner: imvadmin
--

ALTER TABLE ONLY public.qrcode
    ADD CONSTRAINT qrcode_pkey PRIMARY KEY (id);


-- Completed on 2019-11-20 18:21:45

--
-- PostgreSQL database dump complete
--
