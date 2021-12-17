--
-- PostgreSQL database dump
--

-- Dumped from database version 12.7 (Ubuntu 12.7-0ubuntu0.20.10.1)
-- Dumped by pg_dump version 12.7 (Ubuntu 12.7-0ubuntu0.20.10.1)

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
-- Name: migration_versions; Type: TABLE; Schema: public; Owner: imvadmin
--

CREATE TABLE public.migration_versions (
    version character varying(14) NOT NULL,
    executed_at timestamp(0) without time zone NOT NULL
);


ALTER TABLE public.migration_versions OWNER TO imvadmin;

--
-- Name: COLUMN migration_versions.executed_at; Type: COMMENT; Schema: public; Owner: imvadmin
--

COMMENT ON COLUMN public.migration_versions.executed_at IS '(DC2Type:datetime_immutable)';


--
-- Name: participant; Type: TABLE; Schema: public; Owner: imvadmin
--

CREATE TABLE public.participant (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    email character varying(50) NOT NULL,
    mobile character varying(50) NOT NULL,
    companion_1 character varying(50),
    companion_2 character varying(50),
    companion_3 character varying(50),
    companion_4 character varying(50),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    token integer NOT NULL,
    has_been_scanned boolean DEFAULT false NOT NULL,
    has_been_scanned_amount integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.participant OWNER TO imvadmin;

--
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
-- Name: settings; Type: TABLE; Schema: public; Owner: imvadmin
--

CREATE TABLE public.settings (
    id integer NOT NULL,
    eventmaximumamount integer NOT NULL,
    eventdate date NOT NULL,
    eventtime1 time(0) without time zone NOT NULL,
    eventtime2 time(0) without time zone DEFAULT NULL::time without time zone,
    eventtopic character varying(50) NOT NULL,
    eventlocation character varying(100) NOT NULL,
    eventemailsubject character varying(150) NOT NULL,
    eventemailtemplate text NOT NULL,
    created_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


ALTER TABLE public.settings OWNER TO imvadmin;

--
-- Name: settings_id_seq; Type: SEQUENCE; Schema: public; Owner: imvadmin
--

CREATE SEQUENCE public.settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.settings_id_seq OWNER TO imvadmin;

--
-- Name: user; Type: TABLE; Schema: public; Owner: imvadmin
--

CREATE TABLE public."user" (
    id integer NOT NULL,
    sub character varying(255) NOT NULL,
    email character varying(180) NOT NULL
);


ALTER TABLE public."user" OWNER TO imvadmin;

--
-- Name: user_id_seq; Type: SEQUENCE; Schema: public; Owner: imvadmin
--

CREATE SEQUENCE public.user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_id_seq OWNER TO imvadmin;

--
-- Data for Name: migration_versions; Type: TABLE DATA; Schema: public; Owner: imvadmin
--

COPY public.migration_versions (version, executed_at) FROM stdin;
\.


--
-- Data for Name: participant; Type: TABLE DATA; Schema: public; Owner: imvadmin
--

COPY public.participant (id, name, email, mobile, companion_1, companion_2, companion_3, companion_4, created_at, updated_at, token, has_been_scanned, has_been_scanned_amount) FROM stdin;
\.


--
-- Data for Name: settings; Type: TABLE DATA; Schema: public; Owner: imvadmin
--

COPY public.settings (id, eventmaximumamount, eventdate, eventtime1, eventtime2, eventtopic, eventlocation, eventemailsubject, eventemailtemplate, created_at, updated_at) FROM stdin;
1	150	2021-12-17	13:00:00	\N	das Freitagsgebet	Abu Bakr Moschee	QrCode für {{ eventTopic }} um {{ eventTime }} Uhr am {{ eventDate }} in der {{ eventLocation }}	As-salāmu ʿalaikum wa-raḥmatu llāhi wa-barakātuhu {{ name }}!<br /><br />Du hast Dich erfolgreich für {{ eventTopic }} am {{ eventDate }} um {{ eventTime }} Uhr registriert.<br /><br />Veranstaltungsort ist {{ eventLocation }}.<br /><br />Hier ist Dein QR-Code für den Anmeldeprozess am Eingang:<br /><br /><img src="cid:QrCode" /><br /><br />Wir freuen uns schon auf Dich und BarakAllahu Feek(i)<br /><br />Dein IMV-Landau e. V.	2021-12-16 05:01:58	2021-12-17 02:55:54
\.


--
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: imvadmin
--

COPY public."user" (id, sub, email) FROM stdin;
1	auth0|5c6891520739dc356df6ef59	s.aburab@gmail.com
\.


--
-- Name: participant_id_seq; Type: SEQUENCE SET; Schema: public; Owner: imvadmin
--

SELECT pg_catalog.setval('public.participant_id_seq', 1, false);


--
-- Name: settings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: imvadmin
--

SELECT pg_catalog.setval('public.settings_id_seq', 1, true);


--
-- Name: user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: imvadmin
--

SELECT pg_catalog.setval('public.user_id_seq', 1, true);


--
-- Name: migration_versions migration_versions_pkey; Type: CONSTRAINT; Schema: public; Owner: imvadmin
--

ALTER TABLE ONLY public.migration_versions
    ADD CONSTRAINT migration_versions_pkey PRIMARY KEY (version);


--
-- Name: participant participant_pkey; Type: CONSTRAINT; Schema: public; Owner: imvadmin
--

ALTER TABLE ONLY public.participant
    ADD CONSTRAINT participant_pkey PRIMARY KEY (id);


--
-- Name: settings settings_pkey; Type: CONSTRAINT; Schema: public; Owner: imvadmin
--

ALTER TABLE ONLY public.settings
    ADD CONSTRAINT settings_pkey PRIMARY KEY (id);


--
-- Name: user user_pkey; Type: CONSTRAINT; Schema: public; Owner: imvadmin
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);


--
-- Name: uniq_8d93d649580282dc; Type: INDEX; Schema: public; Owner: imvadmin
--

CREATE UNIQUE INDEX uniq_8d93d649580282dc ON public."user" USING btree (sub);


--
-- Name: uniq_8d93d649e7927c74; Type: INDEX; Schema: public; Owner: imvadmin
--

CREATE UNIQUE INDEX uniq_8d93d649e7927c74 ON public."user" USING btree (email);


--
-- Name: uniq_d79f6b115f37a13b; Type: INDEX; Schema: public; Owner: imvadmin
--

CREATE UNIQUE INDEX uniq_d79f6b115f37a13b ON public.participant USING btree (token);


--
-- Name: uniq_d79f6b11e7927c74; Type: INDEX; Schema: public; Owner: imvadmin
--

CREATE UNIQUE INDEX uniq_d79f6b11e7927c74 ON public.participant USING btree (email);


--
-- PostgreSQL database dump complete
--

