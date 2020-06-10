--
-- PostgreSQL database dump
--

-- Dumped from database version 12.3 (Debian 12.3-1.pgdg100+1)
-- Dumped by pg_dump version 12.3 (Debian 12.3-1.pgdg100+1)

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
-- Name: run_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.run_status AS ENUM (
    'unstarted',
    'in_progress',
    'pending_incoming_confirmations',
    'pending_outgoing_confirmations',
    'pending_connection',
    'pending_bridge',
    'pending_sleep',
    'errored',
    'completed',
    'cancelled'
);


ALTER TYPE public.run_status OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: bridge_types; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bridge_types (
    name text NOT NULL,
    url text NOT NULL,
    confirmations bigint DEFAULT 0 NOT NULL,
    incoming_token_hash text NOT NULL,
    salt text NOT NULL,
    outgoing_token text NOT NULL,
    minimum_contract_payment character varying(255),
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


ALTER TABLE public.bridge_types OWNER TO postgres;

--
-- Name: configurations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.configurations (
    id bigint NOT NULL,
    name text NOT NULL,
    value text NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.configurations OWNER TO postgres;

--
-- Name: configurations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.configurations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.configurations_id_seq OWNER TO postgres;

--
-- Name: configurations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.configurations_id_seq OWNED BY public.configurations.id;


--
-- Name: encrypted_secret_keys; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.encrypted_secret_keys (
    public_key character varying(68) NOT NULL,
    vrf_key text NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


ALTER TABLE public.encrypted_secret_keys OWNER TO postgres;

--
-- Name: encumbrances; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.encumbrances (
    id bigint NOT NULL,
    payment numeric(78,0),
    expiration bigint,
    end_at timestamp with time zone,
    oracles text,
    aggregator bytea NOT NULL,
    agg_initiate_job_selector bytea NOT NULL,
    agg_fulfill_selector bytea NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


ALTER TABLE public.encumbrances OWNER TO postgres;

--
-- Name: encumbrances_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.encumbrances_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.encumbrances_id_seq OWNER TO postgres;

--
-- Name: encumbrances_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.encumbrances_id_seq OWNED BY public.encumbrances.id;


--
-- Name: external_initiators; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.external_initiators (
    id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    deleted_at timestamp with time zone,
    name text NOT NULL,
    url text,
    access_key text NOT NULL,
    salt text NOT NULL,
    hashed_secret text NOT NULL,
    outgoing_secret text NOT NULL,
    outgoing_token text NOT NULL
);


ALTER TABLE public.external_initiators OWNER TO postgres;

--
-- Name: external_initiators_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.external_initiators_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.external_initiators_id_seq OWNER TO postgres;

--
-- Name: external_initiators_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.external_initiators_id_seq OWNED BY public.external_initiators.id;


--
-- Name: heads; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.heads (
    id bigint NOT NULL,
    hash bytea NOT NULL,
    number bigint NOT NULL,
    parent_hash bytea NOT NULL,
    created_at timestamp with time zone NOT NULL,
    "timestamp" timestamp with time zone NOT NULL,
    CONSTRAINT chk_hash_size CHECK ((octet_length(hash) = 32)),
    CONSTRAINT chk_parent_hash_size CHECK ((octet_length(parent_hash) = 32))
);


ALTER TABLE public.heads OWNER TO postgres;

--
-- Name: heads_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.heads_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.heads_id_seq OWNER TO postgres;

--
-- Name: heads_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.heads_id_seq OWNED BY public.heads.id;


--
-- Name: initiators; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.initiators (
    id bigint NOT NULL,
    job_spec_id uuid NOT NULL,
    type text NOT NULL,
    created_at timestamp with time zone NOT NULL,
    deleted_at timestamp with time zone,
    schedule text,
    "time" timestamp with time zone,
    ran boolean,
    address bytea,
    requesters text,
    name character varying(255),
    params jsonb,
    from_block numeric(78,0),
    to_block numeric(78,0),
    topics jsonb,
    request_data text,
    feeds text,
    threshold double precision,
    "precision" smallint,
    polling_interval bigint,
    absolute_threshold double precision,
    updated_at timestamp with time zone NOT NULL,
    poll_timer jsonb,
    idle_timer jsonb
);


ALTER TABLE public.initiators OWNER TO postgres;

--
-- Name: initiators_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.initiators_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.initiators_id_seq OWNER TO postgres;

--
-- Name: initiators_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.initiators_id_seq OWNED BY public.initiators.id;


--
-- Name: job_runs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.job_runs (
    result_id bigint,
    run_request_id bigint,
    status public.run_status DEFAULT 'unstarted'::public.run_status NOT NULL,
    created_at timestamp with time zone NOT NULL,
    finished_at timestamp with time zone,
    updated_at timestamp with time zone NOT NULL,
    initiator_id bigint NOT NULL,
    deleted_at timestamp with time zone,
    creation_height numeric(78,0),
    observed_height numeric(78,0),
    payment numeric(78,0),
    job_spec_id uuid NOT NULL,
    id uuid NOT NULL
);


ALTER TABLE public.job_runs OWNER TO postgres;

--
-- Name: job_specs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.job_specs (
    created_at timestamp with time zone NOT NULL,
    start_at timestamp with time zone,
    end_at timestamp with time zone,
    deleted_at timestamp with time zone,
    min_payment character varying(255),
    id uuid NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


ALTER TABLE public.job_specs OWNER TO postgres;

--
-- Name: keys; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.keys (
    address bytea NOT NULL,
    json jsonb NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


ALTER TABLE public.keys OWNER TO postgres;

--
-- Name: log_consumptions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.log_consumptions (
    id bigint NOT NULL,
    block_hash bytea NOT NULL,
    log_index bigint NOT NULL,
    job_id uuid NOT NULL,
    created_at timestamp without time zone NOT NULL
);


ALTER TABLE public.log_consumptions OWNER TO postgres;

--
-- Name: log_consumptions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.log_consumptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.log_consumptions_id_seq OWNER TO postgres;

--
-- Name: log_consumptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.log_consumptions_id_seq OWNED BY public.log_consumptions.id;


--
-- Name: migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.migrations (
    id character varying(255) NOT NULL
);


ALTER TABLE public.migrations OWNER TO postgres;

--
-- Name: run_requests; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.run_requests (
    id bigint NOT NULL,
    request_id bytea,
    tx_hash bytea,
    requester bytea,
    created_at timestamp with time zone NOT NULL,
    block_hash bytea,
    payment numeric(78,0),
    request_params jsonb DEFAULT '{}'::jsonb NOT NULL
);


ALTER TABLE public.run_requests OWNER TO postgres;

--
-- Name: run_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.run_requests_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.run_requests_id_seq OWNER TO postgres;

--
-- Name: run_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.run_requests_id_seq OWNED BY public.run_requests.id;


--
-- Name: run_results; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.run_results (
    id bigint NOT NULL,
    data jsonb,
    error_message text,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


ALTER TABLE public.run_results OWNER TO postgres;

--
-- Name: run_results_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.run_results_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.run_results_id_seq OWNER TO postgres;

--
-- Name: run_results_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.run_results_id_seq OWNED BY public.run_results.id;


--
-- Name: service_agreements; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.service_agreements (
    id text NOT NULL,
    created_at timestamp with time zone NOT NULL,
    encumbrance_id bigint,
    request_body text,
    signature character varying(255),
    job_spec_id uuid,
    updated_at timestamp with time zone NOT NULL
);


ALTER TABLE public.service_agreements OWNER TO postgres;

--
-- Name: sessions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sessions (
    id text NOT NULL,
    last_used timestamp with time zone,
    created_at timestamp with time zone NOT NULL
);


ALTER TABLE public.sessions OWNER TO postgres;

--
-- Name: sync_events; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sync_events (
    id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    body text NOT NULL
);


ALTER TABLE public.sync_events OWNER TO postgres;

--
-- Name: sync_events_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sync_events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sync_events_id_seq OWNER TO postgres;

--
-- Name: sync_events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.sync_events_id_seq OWNED BY public.sync_events.id;


--
-- Name: task_runs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.task_runs (
    result_id bigint,
    status public.run_status DEFAULT 'unstarted'::public.run_status NOT NULL,
    task_spec_id bigint NOT NULL,
    minimum_confirmations bigint,
    created_at timestamp with time zone NOT NULL,
    confirmations bigint,
    job_run_id uuid NOT NULL,
    id uuid NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


ALTER TABLE public.task_runs OWNER TO postgres;

--
-- Name: task_specs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.task_specs (
    id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    deleted_at timestamp with time zone,
    type text NOT NULL,
    confirmations bigint,
    params jsonb,
    job_spec_id uuid NOT NULL
);


ALTER TABLE public.task_specs OWNER TO postgres;

--
-- Name: task_specs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.task_specs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.task_specs_id_seq OWNER TO postgres;

--
-- Name: task_specs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.task_specs_id_seq OWNED BY public.task_specs.id;


--
-- Name: tx_attempts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tx_attempts (
    id bigint NOT NULL,
    tx_id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    hash bytea NOT NULL,
    gas_price numeric(78,0) NOT NULL,
    confirmed boolean NOT NULL,
    sent_at bigint NOT NULL,
    signed_raw_tx bytea NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


ALTER TABLE public.tx_attempts OWNER TO postgres;

--
-- Name: tx_attempts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tx_attempts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tx_attempts_id_seq OWNER TO postgres;

--
-- Name: tx_attempts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tx_attempts_id_seq OWNED BY public.tx_attempts.id;


--
-- Name: txes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.txes (
    id bigint NOT NULL,
    surrogate_id text,
    "from" bytea NOT NULL,
    "to" bytea NOT NULL,
    data bytea NOT NULL,
    nonce bigint NOT NULL,
    value numeric(78,0) NOT NULL,
    gas_limit bigint NOT NULL,
    hash bytea NOT NULL,
    gas_price numeric(78,0) NOT NULL,
    confirmed boolean NOT NULL,
    sent_at bigint NOT NULL,
    signed_raw_tx bytea NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


ALTER TABLE public.txes OWNER TO postgres;

--
-- Name: txes_id_seq1; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.txes_id_seq1
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.txes_id_seq1 OWNER TO postgres;

--
-- Name: txes_id_seq1; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.txes_id_seq1 OWNED BY public.txes.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    email text NOT NULL,
    hashed_password text,
    created_at timestamp with time zone NOT NULL,
    token_key text,
    token_salt text,
    token_hashed_secret text,
    updated_at timestamp with time zone NOT NULL,
    token_secret text
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: configurations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.configurations ALTER COLUMN id SET DEFAULT nextval('public.configurations_id_seq'::regclass);


--
-- Name: encumbrances id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.encumbrances ALTER COLUMN id SET DEFAULT nextval('public.encumbrances_id_seq'::regclass);


--
-- Name: external_initiators id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.external_initiators ALTER COLUMN id SET DEFAULT nextval('public.external_initiators_id_seq'::regclass);


--
-- Name: heads id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.heads ALTER COLUMN id SET DEFAULT nextval('public.heads_id_seq'::regclass);


--
-- Name: initiators id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.initiators ALTER COLUMN id SET DEFAULT nextval('public.initiators_id_seq'::regclass);


--
-- Name: log_consumptions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.log_consumptions ALTER COLUMN id SET DEFAULT nextval('public.log_consumptions_id_seq'::regclass);


--
-- Name: run_requests id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.run_requests ALTER COLUMN id SET DEFAULT nextval('public.run_requests_id_seq'::regclass);


--
-- Name: run_results id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.run_results ALTER COLUMN id SET DEFAULT nextval('public.run_results_id_seq'::regclass);


--
-- Name: sync_events id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sync_events ALTER COLUMN id SET DEFAULT nextval('public.sync_events_id_seq'::regclass);


--
-- Name: task_specs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.task_specs ALTER COLUMN id SET DEFAULT nextval('public.task_specs_id_seq'::regclass);


--
-- Name: tx_attempts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tx_attempts ALTER COLUMN id SET DEFAULT nextval('public.tx_attempts_id_seq'::regclass);


--
-- Name: txes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.txes ALTER COLUMN id SET DEFAULT nextval('public.txes_id_seq1'::regclass);


--
-- Data for Name: bridge_types; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bridge_types (name, url, confirmations, incoming_token_hash, salt, outgoing_token, minimum_contract_payment, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: configurations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.configurations (id, name, value, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: encrypted_secret_keys; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.encrypted_secret_keys (public_key, vrf_key, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: encumbrances; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.encumbrances (id, payment, expiration, end_at, oracles, aggregator, agg_initiate_job_selector, agg_fulfill_selector, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: external_initiators; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.external_initiators (id, created_at, updated_at, deleted_at, name, url, access_key, salt, hashed_secret, outgoing_secret, outgoing_token) FROM stdin;
\.


--
-- Data for Name: heads; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.heads (id, hash, number, parent_hash, created_at, "timestamp") FROM stdin;
62	\\x2563649e914782ca63c45c86b4c0d6e4bd1e6c0db663fa8ebf164d2865f9ffb1	8066620	\\xd3208f82478781865d3e3169c346272141f02c0e7bfe853e65cc83f53b05e205	2020-06-10 19:48:51.48979+00	2020-06-10 19:48:45+00
63	\\x225047797623464e040623b267fb782e7f1a1f36569643b1ca98225d259e4fef	8066621	\\x2563649e914782ca63c45c86b4c0d6e4bd1e6c0db663fa8ebf164d2865f9ffb1	2020-06-10 19:48:51.492841+00	2020-06-10 19:48:49+00
64	\\x166ebf3167c57bf910adc698cdd416848d33d3621407ce43bec70b05dfbcfc69	8066622	\\x225047797623464e040623b267fb782e7f1a1f36569643b1ca98225d259e4fef	2020-06-10 19:48:57.103307+00	2020-06-10 19:48:51+00
65	\\x821dca51ec681851982bae655364a7833b7523d59f07c9318c1e8fd0070cde7e	8066623	\\x166ebf3167c57bf910adc698cdd416848d33d3621407ce43bec70b05dfbcfc69	2020-06-10 19:48:57.106297+00	2020-06-10 19:48:55+00
66	\\xa4094598c10640e7b161d4ff2bea27617c76cf9bf086a6009ad69fe031bb31a6	8066624	\\x821dca51ec681851982bae655364a7833b7523d59f07c9318c1e8fd0070cde7e	2020-06-10 19:49:02.355251+00	2020-06-10 19:48:57+00
67	\\x05591b70f3c28235e30f0988f451f16fe648ddfc2da8d5372f3498a57518636d	8066625	\\xa4094598c10640e7b161d4ff2bea27617c76cf9bf086a6009ad69fe031bb31a6	2020-06-10 19:49:04.695022+00	2020-06-10 19:49:00+00
68	\\xe54466937e6714ab98a66dd31d5df963ebe09e75ced49fc4d036b70827584931	8066626	\\x05591b70f3c28235e30f0988f451f16fe648ddfc2da8d5372f3498a57518636d	2020-06-10 19:49:08.12272+00	2020-06-10 19:49:04+00
69	\\xc6acebe7ad2632308afe5a9490a4172b171ae382534523c918fd209f09b124e0	8066627	\\xe54466937e6714ab98a66dd31d5df963ebe09e75ced49fc4d036b70827584931	2020-06-10 19:49:09.880626+00	2020-06-10 19:49:08+00
70	\\xafa06ee35f83575cb48cf299f62c12e5e48936e809e0d8de6c155c25403baa4d	8066628	\\xc6acebe7ad2632308afe5a9490a4172b171ae382534523c918fd209f09b124e0	2020-06-10 19:49:12.893735+00	2020-06-10 19:49:09+00
71	\\xaa721485bfbc219f2c49dc048859cdb7204892a4b5b999645b9ec76a2f8dbe7a	8066629	\\xafa06ee35f83575cb48cf299f62c12e5e48936e809e0d8de6c155c25403baa4d	2020-06-10 19:49:17.453168+00	2020-06-10 19:49:11+00
72	\\x5fa3551c3f6e2f1225ee7416ecdd1adceaac7613a89af0d3c235b9125ce1c243	8066630	\\xaa721485bfbc219f2c49dc048859cdb7204892a4b5b999645b9ec76a2f8dbe7a	2020-06-10 19:49:24.40303+00	2020-06-10 19:49:17+00
73	\\xb8dea60a57138944bfb1138174d82c658e77f64afc46ea29753d68780501212e	8066631	\\x5fa3551c3f6e2f1225ee7416ecdd1adceaac7613a89af0d3c235b9125ce1c243	2020-06-10 19:49:24.406076+00	2020-06-10 19:49:19+00
74	\\x970c24be5eadf8adbc8e7fee57c365562bb39df79d7f6660c2a23e3331ba5830	8066632	\\xb8dea60a57138944bfb1138174d82c658e77f64afc46ea29753d68780501212e	2020-06-10 19:49:34.714508+00	2020-06-10 19:49:24+00
75	\\xef548c1195700e9daad54d81c271fe52f1c07f24f0fd6a9d642d113f6e720f95	8066633	\\x970c24be5eadf8adbc8e7fee57c365562bb39df79d7f6660c2a23e3331ba5830	2020-06-10 19:49:34.717932+00	2020-06-10 19:49:26+00
76	\\xe16614f30862f9b4ce1b73583e92670bfbdc73d6bc6989b1e33a32defdef77bc	8066634	\\xef548c1195700e9daad54d81c271fe52f1c07f24f0fd6a9d642d113f6e720f95	2020-06-10 19:49:53.406992+00	2020-06-10 19:49:34+00
77	\\x5abfc958b01e681881c34de3c8bf19fc98b98dd77c3b57080a05c3fe4cdafdb4	8066635	\\xe16614f30862f9b4ce1b73583e92670bfbdc73d6bc6989b1e33a32defdef77bc	2020-06-10 19:49:56.857128+00	2020-06-10 19:49:53+00
78	\\xa83fe977aac7365f24c772eb41eae8eeb10521f36fd775919075ce9c4c502568	8066636	\\x5abfc958b01e681881c34de3c8bf19fc98b98dd77c3b57080a05c3fe4cdafdb4	2020-06-10 19:49:58.999794+00	2020-06-10 19:49:55+00
79	\\x655fb07602ae57de304fa19f42c4e189b74019a63a98899a4f2bfec7da48ef2f	8066637	\\xa83fe977aac7365f24c772eb41eae8eeb10521f36fd775919075ce9c4c502568	2020-06-10 19:50:04.788106+00	2020-06-10 19:49:57+00
80	\\x25f9fd8c5d2b5261caccc6fd8af27059b08e53dac2ad4c1aaf4d8a821f164f73	8066638	\\x655fb07602ae57de304fa19f42c4e189b74019a63a98899a4f2bfec7da48ef2f	2020-06-10 19:50:10.303311+00	2020-06-10 19:50:04+00
81	\\xd6068c6c2b9529ae221929925f7d4024691216c5082e9f826c1ce474b9148a4c	8066639	\\x25f9fd8c5d2b5261caccc6fd8af27059b08e53dac2ad4c1aaf4d8a821f164f73	2020-06-10 19:50:15.380238+00	2020-06-10 19:50:10+00
82	\\xe8a3139174e655a2c27e1caedc28e18e5b2226f994218e835428b1541b33ca7f	8066640	\\xd6068c6c2b9529ae221929925f7d4024691216c5082e9f826c1ce474b9148a4c	2020-06-10 19:50:15.386141+00	2020-06-10 19:50:12+00
83	\\x228e807f039e5d99d5bec245aa78c3276b6ace2b78fd4dc993dbe6e07e7d15d5	8066641	\\xe8a3139174e655a2c27e1caedc28e18e5b2226f994218e835428b1541b33ca7f	2020-06-10 19:50:18.547451+00	2020-06-10 19:50:14+00
84	\\x578bdf20ba6c686a866ef98420cf5b6f901e6db198fb99e2c344aca887b1284c	8066642	\\x228e807f039e5d99d5bec245aa78c3276b6ace2b78fd4dc993dbe6e07e7d15d5	2020-06-10 19:50:24.210171+00	2020-06-10 19:50:18+00
85	\\x374f16def85649c13d54950d89b2eb70ea52a6aff38ea62a37d5d5bed7ef8dc9	8066643	\\x578bdf20ba6c686a866ef98420cf5b6f901e6db198fb99e2c344aca887b1284c	2020-06-10 19:50:27.722164+00	2020-06-10 19:50:24+00
86	\\x8d2bb9efe247f92e43d6f82c54d405106de39d6bcd609af09953621011dbab2c	8066644	\\x374f16def85649c13d54950d89b2eb70ea52a6aff38ea62a37d5d5bed7ef8dc9	2020-06-10 19:50:39.139431+00	2020-06-10 19:50:27+00
87	\\x0d2fadedde675987308db77bbd04d7c9071df9edb2acf4dcc78e57c2f283e23b	8066645	\\x8d2bb9efe247f92e43d6f82c54d405106de39d6bcd609af09953621011dbab2c	2020-06-10 19:50:44.291827+00	2020-06-10 19:50:39+00
88	\\x50268f9ae9f429ee591fef7d00ff5954ba30e7da3332ac5c6abeeb83156fbf3b	8066646	\\x0d2fadedde675987308db77bbd04d7c9071df9edb2acf4dcc78e57c2f283e23b	2020-06-10 19:50:44.295629+00	2020-06-10 19:50:41+00
89	\\x78225d3ade6131412bb8700e7f68d535bc1921090e030f09862155a1a4a1b38d	8066647	\\x50268f9ae9f429ee591fef7d00ff5954ba30e7da3332ac5c6abeeb83156fbf3b	2020-06-10 19:50:44.298701+00	2020-06-10 19:50:42+00
90	\\xc839ab02b0a822812bf50745f286829bdf584a8581587073b96ae360308be80a	8066648	\\x78225d3ade6131412bb8700e7f68d535bc1921090e030f09862155a1a4a1b38d	2020-06-10 19:50:49.23092+00	2020-06-10 19:50:44+00
91	\\xcd9a54127b80eb9ad57ad7bd8faefa08467f03248ebf039d996cb76bfb98e390	8066649	\\xc839ab02b0a822812bf50745f286829bdf584a8581587073b96ae360308be80a	2020-06-10 19:51:00.946194+00	2020-06-10 19:50:49+00
92	\\x6b34d6944b3399108ec50e4b821496c8c1025fe585e5031b7a45373a2f728e82	8066650	\\xcd9a54127b80eb9ad57ad7bd8faefa08467f03248ebf039d996cb76bfb98e390	2020-06-10 19:51:17.393788+00	2020-06-10 19:51:01+00
93	\\x7f4b5046d65749af5bff9269cab6c7387d47a0e9c7501167a8fc1c20333dde0a	8066651	\\x6b34d6944b3399108ec50e4b821496c8c1025fe585e5031b7a45373a2f728e82	2020-06-10 19:51:17.397067+00	2020-06-10 19:51:02+00
94	\\x0d599bcd81bb0814b3112e0351035794f9f469c2a60db46250adc7ae30afef02	8066652	\\x7f4b5046d65749af5bff9269cab6c7387d47a0e9c7501167a8fc1c20333dde0a	2020-06-10 19:51:22.326258+00	2020-06-10 19:51:18+00
95	\\xcfd6763e82e157f6a5be53866183e93e9a1bfdeffba883eee4a46fd92bb329d8	8066653	\\x0d599bcd81bb0814b3112e0351035794f9f469c2a60db46250adc7ae30afef02	2020-06-10 19:51:24.414973+00	2020-06-10 19:51:22+00
96	\\x9691f7ea72a8bd5406fc9cf53690e1cc5a3f58ebc69d43f2b11ed47ce7a785b3	8066654	\\xcfd6763e82e157f6a5be53866183e93e9a1bfdeffba883eee4a46fd92bb329d8	2020-06-10 19:51:31.653738+00	2020-06-10 19:51:23+00
97	\\x1300c1381f49c9ddcf70768e959cb708bce14ad54fc6382b62b60111e920f14a	8066655	\\x9691f7ea72a8bd5406fc9cf53690e1cc5a3f58ebc69d43f2b11ed47ce7a785b3	2020-06-10 19:51:39.406759+00	2020-06-10 19:51:31+00
98	\\xe282a8a2ece489e5175431bf602728a9b8b3cada685f2172474f0687ca7a7581	8066656	\\x1300c1381f49c9ddcf70768e959cb708bce14ad54fc6382b62b60111e920f14a	2020-06-10 19:51:44.656123+00	2020-06-10 19:51:39+00
99	\\xb5141fa72b1220606e1a65c6c3563a72aa7388d6dee0a38ef6b3792e5e9a8717	8066657	\\xe282a8a2ece489e5175431bf602728a9b8b3cada685f2172474f0687ca7a7581	2020-06-10 19:51:51.239898+00	2020-06-10 19:51:44+00
100	\\xbf7233d38b79c726119f487d9565126da07c471886b780caa5fcadbfb3d1bc25	8066658	\\xb5141fa72b1220606e1a65c6c3563a72aa7388d6dee0a38ef6b3792e5e9a8717	2020-06-10 19:51:59.673231+00	2020-06-10 19:51:51+00
101	\\x1f112c1414026492929dfb10bea15277bdb35d93653737d873aac102f4d1d4af	8066659	\\xbf7233d38b79c726119f487d9565126da07c471886b780caa5fcadbfb3d1bc25	2020-06-10 19:51:59.676612+00	2020-06-10 19:51:55+00
102	\\xf5f1ca8316424aeb121a96b0c6799818319fdb6c744f1cd073fed353e978b836	8066660	\\x1f112c1414026492929dfb10bea15277bdb35d93653737d873aac102f4d1d4af	2020-06-10 19:52:11.79466+00	2020-06-10 19:51:59+00
103	\\x396e3e00f12f99a6fac8307631676d1184fa0f24069050bb6b5e174ebf4de0d2	8066661	\\xf5f1ca8316424aeb121a96b0c6799818319fdb6c744f1cd073fed353e978b836	2020-06-10 19:52:17.388893+00	2020-06-10 19:52:11+00
104	\\x5686ad083a085fe1b0530feb44448a8e6c0b491d0eea27827475cd01d1f1df78	8066662	\\x396e3e00f12f99a6fac8307631676d1184fa0f24069050bb6b5e174ebf4de0d2	2020-06-10 19:52:33.005841+00	2020-06-10 19:52:17+00
105	\\x9ffa4d9798ca3e8ca1248e42e259a8d48b5252c7feb39019eab471e982ffb851	8066663	\\x5686ad083a085fe1b0530feb44448a8e6c0b491d0eea27827475cd01d1f1df78	2020-06-10 19:52:44.54671+00	2020-06-10 19:52:32+00
106	\\xa7478b64b51a957e6612fa3c12277c87a7561c97bf2c35f33f052a4b8945c3b4	8066664	\\x9ffa4d9798ca3e8ca1248e42e259a8d48b5252c7feb39019eab471e982ffb851	2020-06-10 19:52:44.550703+00	2020-06-10 19:52:33+00
107	\\xc48cc246ff692b26baad579bda3075b2a8bdb4da2a20adcaa1eef5b7318bc0ec	8066665	\\xa7478b64b51a957e6612fa3c12277c87a7561c97bf2c35f33f052a4b8945c3b4	2020-06-10 19:52:49.94846+00	2020-06-10 19:52:44+00
108	\\x31e637ac08d7ea65f4594ba61b76d9094f5a234237581c7f39559692bf80cf82	8066666	\\xc48cc246ff692b26baad579bda3075b2a8bdb4da2a20adcaa1eef5b7318bc0ec	2020-06-10 19:52:56.397551+00	2020-06-10 19:52:49+00
109	\\xe3f14b6a47411625099ef7a03f0b46b99de91f24cd3a6682ca44d14fa2b4b430	8066667	\\x31e637ac08d7ea65f4594ba61b76d9094f5a234237581c7f39559692bf80cf82	2020-06-10 19:52:59.725917+00	2020-06-10 19:52:53+00
110	\\xc3010627d8bc3380abcc74959038b17f2e9233e528536c88b6a63f812328727b	8066668	\\xe3f14b6a47411625099ef7a03f0b46b99de91f24cd3a6682ca44d14fa2b4b430	2020-06-10 19:53:02.678456+00	2020-06-10 19:52:59+00
111	\\x9fb3d6c22ff38c6e679259caf9fafb6a2fddc47ac9abc4e1fa4d4bec8f104d9d	8066669	\\xc3010627d8bc3380abcc74959038b17f2e9233e528536c88b6a63f812328727b	2020-06-10 19:53:07.340581+00	2020-06-10 19:53:01+00
112	\\xb2b637225ed4ecf79416929d1c8034df57e314bd9a969eac801275ac318f9504	8066670	\\x9fb3d6c22ff38c6e679259caf9fafb6a2fddc47ac9abc4e1fa4d4bec8f104d9d	2020-06-10 19:53:10.497352+00	2020-06-10 19:53:07+00
113	\\x766b0380c8e9a1edf2d01b5196ce5143be39e56e56d41397ce7634e3af499b88	8066671	\\xb2b637225ed4ecf79416929d1c8034df57e314bd9a969eac801275ac318f9504	2020-06-10 19:53:20.344646+00	2020-06-10 19:53:09+00
114	\\xf7143ea69c2cdc48d81b400e63d620cad419ccffd0782e34759d071d091b1a8c	8066672	\\x766b0380c8e9a1edf2d01b5196ce5143be39e56e56d41397ce7634e3af499b88	2020-06-10 19:53:20.348602+00	2020-06-10 19:53:11+00
115	\\x76340a28b6012d5d74feb33d1f1a631d0262586ad5f51beb260f519d81f3df97	8066673	\\xf7143ea69c2cdc48d81b400e63d620cad419ccffd0782e34759d071d091b1a8c	2020-06-10 19:53:22.781494+00	2020-06-10 19:53:20+00
116	\\x7d4eb26c09cb209f88b65b898d09f84868826da9d426a6d8d6162a6e0ad9e23a	8066674	\\x76340a28b6012d5d74feb33d1f1a631d0262586ad5f51beb260f519d81f3df97	2020-06-10 19:53:26.622172+00	2020-06-10 19:53:21+00
117	\\x8067e9fffd41ee3f74c62d595369a528a993f2256cda015309ad1d80dfd2d65e	8066675	\\x7d4eb26c09cb209f88b65b898d09f84868826da9d426a6d8d6162a6e0ad9e23a	2020-06-10 19:53:31.683691+00	2020-06-10 19:53:26+00
118	\\xf8739ed4147df8aca20c11f18e9761ee827a258831ee7fbde1dede63a3bd4450	8066675	\\x7d4eb26c09cb209f88b65b898d09f84868826da9d426a6d8d6162a6e0ad9e23a	2020-06-10 19:53:32.053928+00	2020-06-10 19:53:26+00
119	\\x4778e90f78a5205bdb0e335d7b63e132f1d770775dd402b5979d7bffae652134	8066676	\\xf8739ed4147df8aca20c11f18e9761ee827a258831ee7fbde1dede63a3bd4450	2020-06-10 19:53:32.056921+00	2020-06-10 19:53:31+00
120	\\xb6a92d98780d6e35f76ddb176cd57d58fa1023d191fb12f3ed9251347c132985	8066677	\\x4778e90f78a5205bdb0e335d7b63e132f1d770775dd402b5979d7bffae652134	2020-06-10 19:53:38.591555+00	2020-06-10 19:53:32+00
121	\\xc1dccda030472785676fb912511119ccf9d86f1dde4073394ac72c8a1af06c62	8066678	\\xb6a92d98780d6e35f76ddb176cd57d58fa1023d191fb12f3ed9251347c132985	2020-06-10 19:53:41.382233+00	2020-06-10 19:53:36+00
122	\\xde3e428f850faf087c95751916055c5d351531a61d403f09abc4c134255455b4	8066679	\\xc1dccda030472785676fb912511119ccf9d86f1dde4073394ac72c8a1af06c62	2020-06-10 19:53:48.217856+00	2020-06-10 19:53:41+00
123	\\xf3934a000a690ecee0dfb7b6ca1f0998dc2545260f709c6f97acf03eae67323d	8066680	\\xde3e428f850faf087c95751916055c5d351531a61d403f09abc4c134255455b4	2020-06-10 19:53:54.808281+00	2020-06-10 19:53:48+00
124	\\x13ac86ce4b163c1f9c140fb60d02b583374e66dfc3707e3078b610c68fa862fb	8066681	\\xf3934a000a690ecee0dfb7b6ca1f0998dc2545260f709c6f97acf03eae67323d	2020-06-10 19:53:54.812301+00	2020-06-10 19:53:51+00
125	\\xec81caf5ff399cff8457d6d5cda6d777cb9ee2451f6e62cb93c5ebda80a19f6c	8066682	\\x13ac86ce4b163c1f9c140fb60d02b583374e66dfc3707e3078b610c68fa862fb	2020-06-10 19:54:02.722157+00	2020-06-10 19:53:54+00
126	\\x155942c5b4d8fa9e3adb232e091710ad29d0fc2d4f31c520d553b196697127dc	8066683	\\xec81caf5ff399cff8457d6d5cda6d777cb9ee2451f6e62cb93c5ebda80a19f6c	2020-06-10 19:54:14.215783+00	2020-06-10 19:54:02+00
127	\\x4150fd811e40e539b22633809ec64a576a0e16fe1b13db4e48b9cfc850a5094c	8066684	\\x155942c5b4d8fa9e3adb232e091710ad29d0fc2d4f31c520d553b196697127dc	2020-06-10 19:54:20.024938+00	2020-06-10 19:54:14+00
128	\\x1d18e76100591bc63d8d5fe0863842c98113f3007829cd516c64801e462d15dc	8066685	\\x4150fd811e40e539b22633809ec64a576a0e16fe1b13db4e48b9cfc850a5094c	2020-06-10 19:54:20.950148+00	2020-06-10 19:54:17+00
129	\\x17b14ff4e1283dcddfc55e5d085a753a8885959dbc34c53b076cad037174f639	8066686	\\x1d18e76100591bc63d8d5fe0863842c98113f3007829cd516c64801e462d15dc	2020-06-10 19:54:26.359615+00	2020-06-10 19:54:20+00
130	\\xca61a7d59839eafb0904a54ce8c98c7dd6dc86b83b36ee4222b8091d56c3f761	8066687	\\x17b14ff4e1283dcddfc55e5d085a753a8885959dbc34c53b076cad037174f639	2020-06-10 19:54:41.111681+00	2020-06-10 19:54:24+00
131	\\xa0080f3f209f06487b496bf94c84e543a35a6b24be1e9a9b2e596ef33f182931	8066688	\\xca61a7d59839eafb0904a54ce8c98c7dd6dc86b83b36ee4222b8091d56c3f761	2020-06-10 19:54:50.296242+00	2020-06-10 19:54:41+00
132	\\x12409035b404edc4516df121272331c51153aceeb57a5d0b90f5e848b91972cc	8066689	\\xa0080f3f209f06487b496bf94c84e543a35a6b24be1e9a9b2e596ef33f182931	2020-06-10 19:54:50.30053+00	2020-06-10 19:54:42+00
133	\\xcc84aa49bb66e80c15519fde4afd9f9fe9dff6a09044801ac70fddf499259057	8066690	\\x12409035b404edc4516df121272331c51153aceeb57a5d0b90f5e848b91972cc	2020-06-10 19:54:50.304174+00	2020-06-10 19:54:45+00
134	\\x46768cf0ca1329883a52122375cf71ff4573eeedc89e2ef874158ba504936063	8066691	\\xcc84aa49bb66e80c15519fde4afd9f9fe9dff6a09044801ac70fddf499259057	2020-06-10 19:54:55.660666+00	2020-06-10 19:54:50+00
135	\\xae8aa6ded3083d37a0a5af2541dd0bc88209db889464acad45a6d6383cdeb47a	8066692	\\x46768cf0ca1329883a52122375cf71ff4573eeedc89e2ef874158ba504936063	2020-06-10 19:54:55.666044+00	2020-06-10 19:54:53+00
136	\\x78807b79ae690a6281c4d95d5638e282219ecbd2130bdb44860c65fcb8681f73	8066693	\\xae8aa6ded3083d37a0a5af2541dd0bc88209db889464acad45a6d6383cdeb47a	2020-06-10 19:54:58.641053+00	2020-06-10 19:54:55+00
137	\\x0019520f69166a78811d106d53d088a29f5f72febd685afbaa5302cf1d55458e	8066694	\\x78807b79ae690a6281c4d95d5638e282219ecbd2130bdb44860c65fcb8681f73	2020-06-10 19:55:05.272292+00	2020-06-10 19:54:57+00
138	\\xe5dd9b8eb417f47fbfc5ac928fd833a62520f0834dbc3f29a5372f17991e8dc3	8066695	\\x0019520f69166a78811d106d53d088a29f5f72febd685afbaa5302cf1d55458e	2020-06-10 19:55:10.747263+00	2020-06-10 19:55:05+00
139	\\xa78fcb982d62133d87d5c807cbdfb1dd9a2b60cf33e01cc78a4a79a4e33f6b35	8066696	\\xe5dd9b8eb417f47fbfc5ac928fd833a62520f0834dbc3f29a5372f17991e8dc3	2020-06-10 19:55:10.752209+00	2020-06-10 19:55:07+00
140	\\xeb059ed32f6c14e19f1e461a4a2ea8824296206e8c0cf571853ad45b400c4cfd	8066697	\\xa78fcb982d62133d87d5c807cbdfb1dd9a2b60cf33e01cc78a4a79a4e33f6b35	2020-06-10 19:55:17.256259+00	2020-06-10 19:55:10+00
141	\\xa1d2e6736c8c3f731716c764472b3953416311df3b065d12d82464417c97c283	8066698	\\xeb059ed32f6c14e19f1e461a4a2ea8824296206e8c0cf571853ad45b400c4cfd	2020-06-10 19:55:17.261088+00	2020-06-10 19:55:12+00
142	\\x7f2f6cbcf04a8224bbcaa25eb89f645eabad0d6c5b6eea99231e81fe3774e260	8066699	\\xa1d2e6736c8c3f731716c764472b3953416311df3b065d12d82464417c97c283	2020-06-10 19:55:23.138291+00	2020-06-10 19:55:17+00
143	\\xcda2d6a61813fb21e266ef9ae28f539d69b8dd11b7a8eef2c392e648cb1af7db	8066700	\\x7f2f6cbcf04a8224bbcaa25eb89f645eabad0d6c5b6eea99231e81fe3774e260	2020-06-10 19:55:23.142366+00	2020-06-10 19:55:20+00
144	\\x0dc5bb06eedf491d65545b60629b3623fdcb71ee14b39d9530fee14036f35ef4	8066701	\\xcda2d6a61813fb21e266ef9ae28f539d69b8dd11b7a8eef2c392e648cb1af7db	2020-06-10 19:55:26.004067+00	2020-06-10 19:55:23+00
145	\\x060975344949321b6a9d690a6f18e18e9ff17761880f22b9180a2844ce30395b	8066702	\\x0dc5bb06eedf491d65545b60629b3623fdcb71ee14b39d9530fee14036f35ef4	2020-06-10 19:55:36.013917+00	2020-06-10 19:55:25+00
146	\\x569893f3306a47567d2a1e50dff6030962bf3dbc8939c882bddf3c88d7699414	8066703	\\x060975344949321b6a9d690a6f18e18e9ff17761880f22b9180a2844ce30395b	2020-06-10 19:55:43.816087+00	2020-06-10 19:55:35+00
147	\\x58d160d1a0531f64126368dbf9c702067316ed34caf6f7ab0b3b70faf708e0a4	8066704	\\x569893f3306a47567d2a1e50dff6030962bf3dbc8939c882bddf3c88d7699414	2020-06-10 19:55:47.799178+00	2020-06-10 19:55:43+00
148	\\x43e096fb5d4f8722bf9637283004f4b00bec7bf0cd62ec7c0151c24dbc584a17	8066705	\\x58d160d1a0531f64126368dbf9c702067316ed34caf6f7ab0b3b70faf708e0a4	2020-06-10 19:55:53.830361+00	2020-06-10 19:55:46+00
149	\\x6b1133202e53cab33f844ecb6c152de8c184ff67dd5aec3d36aa927172cb4f68	8066706	\\x43e096fb5d4f8722bf9637283004f4b00bec7bf0cd62ec7c0151c24dbc584a17	2020-06-10 19:55:57.114151+00	2020-06-10 19:55:53+00
150	\\xc1e83ebe18f1f66ffb824957a07062d4d5058928b58fac971279584939d70a71	8066707	\\x6b1133202e53cab33f844ecb6c152de8c184ff67dd5aec3d36aa927172cb4f68	2020-06-10 19:55:58.87334+00	2020-06-10 19:55:56+00
151	\\xea761a920bddfee0de3ee2877d03b5f09a1667bc14ee314b52b235d0586b3f42	8066708	\\xc1e83ebe18f1f66ffb824957a07062d4d5058928b58fac971279584939d70a71	2020-06-10 19:56:02.207044+00	2020-06-10 19:55:58+00
152	\\xe306aa40ec0a2e8ad57b802d358c5be8a4965672b70f5b14b3ddb92dd9f05240	8066709	\\xea761a920bddfee0de3ee2877d03b5f09a1667bc14ee314b52b235d0586b3f42	2020-06-10 19:56:06.368593+00	2020-06-10 19:56:01+00
153	\\x6f6c84c7adcd1bd9e5de5ea72e34903e431e60aeace722d3fb39a0745540278c	8066710	\\xe306aa40ec0a2e8ad57b802d358c5be8a4965672b70f5b14b3ddb92dd9f05240	2020-06-10 19:56:10.482625+00	2020-06-10 19:56:06+00
154	\\x06c401e96c0d33a2f646fca7d11c6864b349ef16db91c43ee559eee945cddd73	8066711	\\x6f6c84c7adcd1bd9e5de5ea72e34903e431e60aeace722d3fb39a0745540278c	2020-06-10 19:56:20.904888+00	2020-06-10 19:56:09+00
155	\\x094a889c631ec682cb301c5c994c6fa145e2a168d08f91b59be686a7a58cb491	8066712	\\x06c401e96c0d33a2f646fca7d11c6864b349ef16db91c43ee559eee945cddd73	2020-06-10 19:56:27.164652+00	2020-06-10 19:56:20+00
156	\\xcb5b7c4ad8cada8b08cb7b93dd411c4530dc53d79e949cf4cdd6c535b83f2ed2	8066713	\\x094a889c631ec682cb301c5c994c6fa145e2a168d08f91b59be686a7a58cb491	2020-06-10 19:56:32.32913+00	2020-06-10 19:56:27+00
157	\\x17452b067ec73cb9ffe01ae527386f2a5072df55fb543a7922c8d8356e20d2b9	8066714	\\xcb5b7c4ad8cada8b08cb7b93dd411c4530dc53d79e949cf4cdd6c535b83f2ed2	2020-06-10 19:56:32.333073+00	2020-06-10 19:56:29+00
158	\\x18501a9e978059591e76c7c8dc15b845eab0d9db8c8de6eb3c87b8df8e69418c	8066715	\\x17452b067ec73cb9ffe01ae527386f2a5072df55fb543a7922c8d8356e20d2b9	2020-06-10 19:56:35.955491+00	2020-06-10 19:56:32+00
159	\\x1b4813b48f77908eef1a2c2871ed0d0120991830cfc69f2ef7a0b3b2bb039dc9	8066716	\\x18501a9e978059591e76c7c8dc15b845eab0d9db8c8de6eb3c87b8df8e69418c	2020-06-10 19:56:38.258081+00	2020-06-10 19:56:35+00
160	\\x1da597139b9bfb6b12d00aa79e0962b851c0513fdc59e1689a718d8112e6790a	8066717	\\x1b4813b48f77908eef1a2c2871ed0d0120991830cfc69f2ef7a0b3b2bb039dc9	2020-06-10 19:56:44.129241+00	2020-06-10 19:56:38+00
161	\\x62bc12037b8def5c0e7d989c95ddb066d1f0ece3e05c439ab2a0dfc4854163ec	8066718	\\x1da597139b9bfb6b12d00aa79e0962b851c0513fdc59e1689a718d8112e6790a	2020-06-10 19:56:49.442379+00	2020-06-10 19:56:44+00
\.


--
-- Data for Name: initiators; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.initiators (id, job_spec_id, type, created_at, deleted_at, schedule, "time", ran, address, requesters, name, params, from_block, to_block, topics, request_data, feeds, threshold, "precision", polling_interval, absolute_threshold, updated_at, poll_timer, idle_timer) FROM stdin;
\.


--
-- Data for Name: job_runs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.job_runs (result_id, run_request_id, status, created_at, finished_at, updated_at, initiator_id, deleted_at, creation_height, observed_height, payment, job_spec_id, id) FROM stdin;
\.


--
-- Data for Name: job_specs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.job_specs (created_at, start_at, end_at, deleted_at, min_payment, id, updated_at) FROM stdin;
\.


--
-- Data for Name: keys; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.keys (address, json, created_at, updated_at) FROM stdin;
\\xa00ce64f7b63a8107795b76571ac172957ed6eb8	{"id": "9c70bf05-58be-4041-9169-9598d235395c", "crypto": {"kdf": "scrypt", "mac": "a9addae9d9a5c2e87a211a5d53305b9d6e1b33c44db563101a9b3996741238d0", "cipher": "aes-128-ctr", "kdfparams": {"n": 262144, "p": 1, "r": 8, "salt": "3f68239b4df172e57bb7ae31dbb71614d3f8de316aa0fef524a828e26cab2c08", "dklen": 32}, "ciphertext": "dc6e71de5bdd7a8f5b517fca6d44da5f6edf79d200cf94c3f52eabe4be3cfbb3", "cipherparams": {"iv": "052c23de44a945a345227182e7f8b045"}}, "address": "a00ce64f7b63a8107795b76571ac172957ed6eb8", "version": 3}	2020-06-10 19:44:11.419562+00	2020-06-10 19:44:11.419562+00
\.


--
-- Data for Name: log_consumptions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.log_consumptions (id, block_hash, log_index, job_id, created_at) FROM stdin;
\.


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.migrations (id) FROM stdin;
0
1559081901
1559767166
1560433987
1560791143
1560881846
1560886530
1560924400
1560881855
1565139192
1564007745
1565210496
1566498796
1565877314
1566915476
1567029116
1568280052
1565291711
1568390387
1568833756
1570087128
1570675883
1573667511
1573812490
1575036327
1574659987
1576022702
1579700934
1580904019
1581240419
1584377646
1585908150
1585918589
1586163842
1586342453
1586369235
1586939705
1587027516
1587580235
1587591248
1587975059
1586956053
1588293486
1586949323
1588088353
1588757164
1588853064
1589470036
1586871710
1590226486
\.


--
-- Data for Name: run_requests; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.run_requests (id, request_id, tx_hash, requester, created_at, block_hash, payment, request_params) FROM stdin;
\.


--
-- Data for Name: run_results; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.run_results (id, data, error_message, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: service_agreements; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.service_agreements (id, created_at, encumbrance_id, request_body, signature, job_spec_id, updated_at) FROM stdin;
\.


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sessions (id, last_used, created_at) FROM stdin;
\.


--
-- Data for Name: sync_events; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sync_events (id, created_at, updated_at, body) FROM stdin;
\.


--
-- Data for Name: task_runs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.task_runs (result_id, status, task_spec_id, minimum_confirmations, created_at, confirmations, job_run_id, id, updated_at) FROM stdin;
\.


--
-- Data for Name: task_specs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.task_specs (id, created_at, updated_at, deleted_at, type, confirmations, params, job_spec_id) FROM stdin;
\.


--
-- Data for Name: tx_attempts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tx_attempts (id, tx_id, created_at, hash, gas_price, confirmed, sent_at, signed_raw_tx, updated_at) FROM stdin;
\.


--
-- Data for Name: txes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.txes (id, surrogate_id, "from", "to", data, nonce, value, gas_limit, hash, gas_price, confirmed, sent_at, signed_raw_tx, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (email, hashed_password, created_at, token_key, token_salt, token_hashed_secret, updated_at, token_secret) FROM stdin;
sravya@node.com	$2a$10$Fu9uxXP14SxcgE2un1yYnOaSbDna6KLZpNwGwZYVHbnMOk8u1IcPu	2020-06-10 19:44:11.416254+00				2020-06-10 19:44:11.414988+00	\N
\.


--
-- Name: configurations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.configurations_id_seq', 1, false);


--
-- Name: encumbrances_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.encumbrances_id_seq', 1, false);


--
-- Name: external_initiators_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.external_initiators_id_seq', 1, false);


--
-- Name: heads_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.heads_id_seq', 161, true);


--
-- Name: initiators_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.initiators_id_seq', 1, false);


--
-- Name: log_consumptions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.log_consumptions_id_seq', 1, false);


--
-- Name: run_requests_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.run_requests_id_seq', 1, false);


--
-- Name: run_results_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.run_results_id_seq', 1, false);


--
-- Name: sync_events_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sync_events_id_seq', 1, false);


--
-- Name: task_specs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.task_specs_id_seq', 1, false);


--
-- Name: tx_attempts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tx_attempts_id_seq', 1, false);


--
-- Name: txes_id_seq1; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.txes_id_seq1', 1, false);


--
-- Name: bridge_types bridge_types_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bridge_types
    ADD CONSTRAINT bridge_types_pkey PRIMARY KEY (name);


--
-- Name: configurations configurations_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.configurations
    ADD CONSTRAINT configurations_name_key UNIQUE (name);


--
-- Name: configurations configurations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.configurations
    ADD CONSTRAINT configurations_pkey PRIMARY KEY (id);


--
-- Name: encrypted_secret_keys encrypted_secret_keys_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.encrypted_secret_keys
    ADD CONSTRAINT encrypted_secret_keys_pkey PRIMARY KEY (public_key);


--
-- Name: encumbrances encumbrances_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.encumbrances
    ADD CONSTRAINT encumbrances_pkey PRIMARY KEY (id);


--
-- Name: external_initiators external_initiators_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.external_initiators
    ADD CONSTRAINT external_initiators_name_key UNIQUE (name);


--
-- Name: external_initiators external_initiators_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.external_initiators
    ADD CONSTRAINT external_initiators_pkey PRIMARY KEY (id);


--
-- Name: heads heads_pkey1; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.heads
    ADD CONSTRAINT heads_pkey1 PRIMARY KEY (id);


--
-- Name: initiators initiators_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.initiators
    ADD CONSTRAINT initiators_pkey PRIMARY KEY (id);


--
-- Name: job_runs job_run_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.job_runs
    ADD CONSTRAINT job_run_pkey PRIMARY KEY (id);


--
-- Name: job_specs job_spec_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.job_specs
    ADD CONSTRAINT job_spec_pkey PRIMARY KEY (id);


--
-- Name: keys keys_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.keys
    ADD CONSTRAINT keys_pkey PRIMARY KEY (address);


--
-- Name: log_consumptions log_consumptions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.log_consumptions
    ADD CONSTRAINT log_consumptions_pkey PRIMARY KEY (id);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- Name: run_requests run_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.run_requests
    ADD CONSTRAINT run_requests_pkey PRIMARY KEY (id);


--
-- Name: run_results run_results_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.run_results
    ADD CONSTRAINT run_results_pkey PRIMARY KEY (id);


--
-- Name: service_agreements service_agreements_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.service_agreements
    ADD CONSTRAINT service_agreements_pkey PRIMARY KEY (id);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: sync_events sync_events_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sync_events
    ADD CONSTRAINT sync_events_pkey PRIMARY KEY (id);


--
-- Name: task_runs task_run_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.task_runs
    ADD CONSTRAINT task_run_pkey PRIMARY KEY (id);


--
-- Name: task_specs task_specs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.task_specs
    ADD CONSTRAINT task_specs_pkey PRIMARY KEY (id);


--
-- Name: tx_attempts tx_attempts_pkey1; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tx_attempts
    ADD CONSTRAINT tx_attempts_pkey1 PRIMARY KEY (id);


--
-- Name: txes txes_pkey1; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.txes
    ADD CONSTRAINT txes_pkey1 PRIMARY KEY (id);


--
-- Name: txes txes_surrogate_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.txes
    ADD CONSTRAINT txes_surrogate_id_key UNIQUE (surrogate_id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (email);


--
-- Name: idx_bridge_types_created_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_bridge_types_created_at ON public.bridge_types USING brin (created_at);


--
-- Name: idx_bridge_types_updated_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_bridge_types_updated_at ON public.bridge_types USING brin (updated_at);


--
-- Name: idx_configurations_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_configurations_name ON public.configurations USING btree (name);


--
-- Name: idx_encumbrances_created_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_encumbrances_created_at ON public.encumbrances USING brin (created_at);


--
-- Name: idx_encumbrances_updated_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_encumbrances_updated_at ON public.encumbrances USING brin (updated_at);


--
-- Name: idx_external_initiators_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_external_initiators_deleted_at ON public.external_initiators USING btree (deleted_at);


--
-- Name: idx_heads_hash; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_heads_hash ON public.heads USING btree (hash);


--
-- Name: idx_heads_number; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_heads_number ON public.heads USING btree (number);


--
-- Name: idx_initiators_address; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_initiators_address ON public.initiators USING btree (address);


--
-- Name: idx_initiators_created_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_initiators_created_at ON public.initiators USING btree (created_at);


--
-- Name: idx_initiators_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_initiators_deleted_at ON public.initiators USING btree (deleted_at);


--
-- Name: idx_initiators_job_spec_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_initiators_job_spec_id ON public.initiators USING btree (job_spec_id);


--
-- Name: idx_initiators_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_initiators_type ON public.initiators USING btree (type);


--
-- Name: idx_initiators_updated_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_initiators_updated_at ON public.initiators USING brin (updated_at);


--
-- Name: idx_job_runs_created_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_job_runs_created_at ON public.job_runs USING brin (created_at);


--
-- Name: idx_job_runs_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_job_runs_deleted_at ON public.job_runs USING btree (deleted_at);


--
-- Name: idx_job_runs_finished_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_job_runs_finished_at ON public.job_runs USING brin (finished_at);


--
-- Name: idx_job_runs_initiator_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_job_runs_initiator_id ON public.job_runs USING btree (initiator_id);


--
-- Name: idx_job_runs_job_spec_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_job_runs_job_spec_id ON public.job_runs USING btree (job_spec_id);


--
-- Name: idx_job_runs_result_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_job_runs_result_id ON public.job_runs USING btree (result_id);


--
-- Name: idx_job_runs_run_request_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_job_runs_run_request_id ON public.job_runs USING btree (run_request_id);


--
-- Name: idx_job_runs_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_job_runs_status ON public.job_runs USING btree (status) WHERE (status <> 'completed'::public.run_status);


--
-- Name: idx_job_runs_updated_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_job_runs_updated_at ON public.job_runs USING brin (updated_at);


--
-- Name: idx_job_specs_created_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_job_specs_created_at ON public.job_specs USING btree (created_at);


--
-- Name: idx_job_specs_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_job_specs_deleted_at ON public.job_specs USING btree (deleted_at);


--
-- Name: idx_job_specs_end_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_job_specs_end_at ON public.job_specs USING btree (end_at);


--
-- Name: idx_job_specs_start_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_job_specs_start_at ON public.job_specs USING btree (start_at);


--
-- Name: idx_job_specs_updated_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_job_specs_updated_at ON public.job_specs USING brin (updated_at);


--
-- Name: idx_run_requests_created_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_run_requests_created_at ON public.run_requests USING brin (created_at);


--
-- Name: idx_run_results_created_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_run_results_created_at ON public.run_results USING brin (created_at);


--
-- Name: idx_run_results_updated_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_run_results_updated_at ON public.run_results USING brin (updated_at);


--
-- Name: idx_service_agreements_created_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_service_agreements_created_at ON public.service_agreements USING btree (created_at);


--
-- Name: idx_service_agreements_updated_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_service_agreements_updated_at ON public.service_agreements USING brin (updated_at);


--
-- Name: idx_sessions_created_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_sessions_created_at ON public.sessions USING brin (created_at);


--
-- Name: idx_sessions_last_used; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_sessions_last_used ON public.sessions USING brin (last_used);


--
-- Name: idx_task_runs_created_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_task_runs_created_at ON public.task_runs USING brin (created_at);


--
-- Name: idx_task_runs_job_run_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_task_runs_job_run_id ON public.task_runs USING btree (job_run_id);


--
-- Name: idx_task_runs_result_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_task_runs_result_id ON public.task_runs USING btree (result_id);


--
-- Name: idx_task_runs_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_task_runs_status ON public.task_runs USING btree (status) WHERE (status <> 'completed'::public.run_status);


--
-- Name: idx_task_runs_task_spec_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_task_runs_task_spec_id ON public.task_runs USING btree (task_spec_id);


--
-- Name: idx_task_runs_updated_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_task_runs_updated_at ON public.task_runs USING brin (updated_at);


--
-- Name: idx_task_specs_created_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_task_specs_created_at ON public.task_specs USING brin (created_at);


--
-- Name: idx_task_specs_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_task_specs_deleted_at ON public.task_specs USING btree (deleted_at);


--
-- Name: idx_task_specs_job_spec_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_task_specs_job_spec_id ON public.task_specs USING btree (job_spec_id);


--
-- Name: idx_task_specs_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_task_specs_type ON public.task_specs USING btree (type);


--
-- Name: idx_task_specs_updated_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_task_specs_updated_at ON public.task_specs USING brin (updated_at);


--
-- Name: idx_tx_attempts_created_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_tx_attempts_created_at ON public.tx_attempts USING brin (created_at);


--
-- Name: idx_tx_attempts_hash; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_tx_attempts_hash ON public.tx_attempts USING btree (hash);


--
-- Name: idx_tx_attempts_tx_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_tx_attempts_tx_id ON public.tx_attempts USING btree (tx_id);


--
-- Name: idx_tx_attempts_updated_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_tx_attempts_updated_at ON public.tx_attempts USING brin (updated_at);


--
-- Name: idx_txes_created_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_txes_created_at ON public.txes USING brin (created_at);


--
-- Name: idx_txes_from; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_txes_from ON public.txes USING btree ("from");


--
-- Name: idx_txes_hash; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_txes_hash ON public.txes USING btree (hash);


--
-- Name: idx_txes_surrogate_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_txes_surrogate_id ON public.txes USING btree (surrogate_id);


--
-- Name: idx_txes_unique_nonces_per_account; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_txes_unique_nonces_per_account ON public.txes USING btree (nonce, "from");


--
-- Name: idx_txes_updated_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_txes_updated_at ON public.txes USING brin (updated_at);


--
-- Name: idx_users_created_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_users_created_at ON public.users USING btree (created_at);


--
-- Name: idx_users_updated_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_users_updated_at ON public.users USING brin (updated_at);


--
-- Name: log_consumptions_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX log_consumptions_created_at_idx ON public.log_consumptions USING brin (created_at);


--
-- Name: log_consumptions_unique_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX log_consumptions_unique_idx ON public.log_consumptions USING btree (job_id, block_hash, log_index);


--
-- Name: sync_events_id_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX sync_events_id_created_at_idx ON public.sync_events USING btree (id, created_at);


--
-- Name: initiators fk_initiators_job_spec_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.initiators
    ADD CONSTRAINT fk_initiators_job_spec_id FOREIGN KEY (job_spec_id) REFERENCES public.job_specs(id) ON DELETE RESTRICT;


--
-- Name: job_runs fk_job_runs_initiator_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.job_runs
    ADD CONSTRAINT fk_job_runs_initiator_id FOREIGN KEY (initiator_id) REFERENCES public.initiators(id) ON DELETE CASCADE;


--
-- Name: job_runs fk_job_runs_result_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.job_runs
    ADD CONSTRAINT fk_job_runs_result_id FOREIGN KEY (result_id) REFERENCES public.run_results(id) ON DELETE CASCADE;


--
-- Name: job_runs fk_job_runs_run_request_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.job_runs
    ADD CONSTRAINT fk_job_runs_run_request_id FOREIGN KEY (run_request_id) REFERENCES public.run_requests(id) ON DELETE CASCADE;


--
-- Name: service_agreements fk_service_agreements_encumbrance_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.service_agreements
    ADD CONSTRAINT fk_service_agreements_encumbrance_id FOREIGN KEY (encumbrance_id) REFERENCES public.encumbrances(id) ON DELETE RESTRICT;


--
-- Name: task_runs fk_task_runs_result_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.task_runs
    ADD CONSTRAINT fk_task_runs_result_id FOREIGN KEY (result_id) REFERENCES public.run_results(id) ON DELETE CASCADE;


--
-- Name: task_runs fk_task_runs_task_spec_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.task_runs
    ADD CONSTRAINT fk_task_runs_task_spec_id FOREIGN KEY (task_spec_id) REFERENCES public.task_specs(id) ON DELETE CASCADE;


--
-- Name: job_runs job_runs_job_spec_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.job_runs
    ADD CONSTRAINT job_runs_job_spec_id_fkey FOREIGN KEY (job_spec_id) REFERENCES public.job_specs(id) ON DELETE CASCADE;


--
-- Name: log_consumptions log_consumptions_job_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.log_consumptions
    ADD CONSTRAINT log_consumptions_job_id_fkey FOREIGN KEY (job_id) REFERENCES public.job_specs(id) ON DELETE CASCADE;


--
-- Name: service_agreements service_agreements_job_spec_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.service_agreements
    ADD CONSTRAINT service_agreements_job_spec_id_fkey FOREIGN KEY (job_spec_id) REFERENCES public.job_specs(id) ON DELETE CASCADE;


--
-- Name: task_runs task_runs_job_run_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.task_runs
    ADD CONSTRAINT task_runs_job_run_id_fkey FOREIGN KEY (job_run_id) REFERENCES public.job_runs(id) ON DELETE CASCADE;


--
-- Name: task_specs task_specs_job_spec_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.task_specs
    ADD CONSTRAINT task_specs_job_spec_id_fkey FOREIGN KEY (job_spec_id) REFERENCES public.job_specs(id) ON DELETE CASCADE;


--
-- Name: tx_attempts tx_attempts_tx_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tx_attempts
    ADD CONSTRAINT tx_attempts_tx_id_fkey FOREIGN KEY (tx_id) REFERENCES public.txes(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

