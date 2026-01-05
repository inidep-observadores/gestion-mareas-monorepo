--
-- PostgreSQL database dump
--

-- Dumped from database version 15.13 (Debian 15.13-1.pgdg110+1)
-- Dumped by pg_dump version 15.13 (Debian 15.13-1.pgdg110+1)

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
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO postgres;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS '';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: _prisma_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public._prisma_migrations (
    id character varying(36) NOT NULL,
    checksum character varying(64) NOT NULL,
    finished_at timestamp with time zone,
    migration_name character varying(255) NOT NULL,
    logs text,
    rolled_back_at timestamp with time zone,
    started_at timestamp with time zone DEFAULT now() NOT NULL,
    applied_steps_count integer DEFAULT 0 NOT NULL
);


ALTER TABLE public._prisma_migrations OWNER TO postgres;

--
-- Name: artes_pesca; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.artes_pesca (
    id uuid NOT NULL,
    codigo_numerico integer NOT NULL,
    activo boolean DEFAULT true NOT NULL,
    nombre text NOT NULL
);


ALTER TABLE public.artes_pesca OWNER TO postgres;

--
-- Name: buque_trayectoria_puntos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.buque_trayectoria_puntos (
    id uuid NOT NULL,
    trayectoria_id uuid NOT NULL,
    buque_id uuid NOT NULL,
    "timestamp" timestamp with time zone NOT NULL,
    lat double precision NOT NULL,
    lon double precision NOT NULL,
    velocidad double precision,
    rumbo integer
);


ALTER TABLE public.buque_trayectoria_puntos OWNER TO postgres;

--
-- Name: buque_trayectorias; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.buque_trayectorias (
    id uuid NOT NULL,
    buque_id uuid NOT NULL,
    origen text,
    metadata jsonb
);


ALTER TABLE public.buque_trayectorias OWNER TO postgres;

--
-- Name: buques; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.buques (
    id uuid NOT NULL,
    nombre_buque text NOT NULL,
    matricula text NOT NULL,
    codigo_interno integer,
    id_tipo_flota uuid,
    id_arte_habitual uuid,
    id_pesqueria_habitual uuid,
    dias_marea_estimada integer,
    eslora_m numeric(6,2),
    potencia_hp integer,
    id_puerto_base uuid,
    empresa_nombre text,
    empresa_localidad text,
    empresa_telefono text,
    empresa_fax text,
    empresa_correo_principal text,
    empresa_correo_secundario text,
    armador_nombre text,
    armador_telefono text,
    agencia_maritima_nombre text,
    activo boolean DEFAULT true NOT NULL,
    fecha_alta date,
    fecha_baja date,
    observaciones text
);


ALTER TABLE public.buques OWNER TO postgres;

--
-- Name: capturas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.capturas (
    id uuid NOT NULL,
    lance_id uuid NOT NULL,
    especie_id uuid NOT NULL,
    kg_captura double precision NOT NULL,
    kg_descarte double precision NOT NULL,
    observaciones_captura text,
    indice_original integer NOT NULL
);


ALTER TABLE public.capturas OWNER TO postgres;

--
-- Name: error_logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.error_logs (
    id uuid NOT NULL,
    "timestamp" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    level text NOT NULL,
    source text NOT NULL,
    context text,
    "userId" uuid,
    "userEmail" text,
    message text NOT NULL,
    stack text,
    detail jsonb,
    path text,
    method text,
    ip text
);


ALTER TABLE public.error_logs OWNER TO postgres;

--
-- Name: especies; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.especies (
    id uuid NOT NULL,
    codigo text NOT NULL,
    nombre_cientifico text NOT NULL,
    nombre_vulgar text NOT NULL,
    activo boolean DEFAULT true NOT NULL,
    observaciones text
);


ALTER TABLE public.especies OWNER TO postgres;

--
-- Name: estados_marea; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.estados_marea (
    id uuid NOT NULL,
    codigo text NOT NULL,
    nombre text NOT NULL,
    descripcion text,
    categoria text NOT NULL,
    orden integer NOT NULL,
    es_inicial boolean DEFAULT false NOT NULL,
    es_final boolean DEFAULT false NOT NULL,
    permite_carga_archivos boolean DEFAULT false NOT NULL,
    permite_correccion boolean DEFAULT false NOT NULL,
    permite_informe boolean DEFAULT false NOT NULL,
    activo boolean DEFAULT true NOT NULL,
    mostrar_en_panel boolean DEFAULT false NOT NULL
);


ALTER TABLE public.estados_marea OWNER TO postgres;

--
-- Name: lances; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lances (
    id uuid NOT NULL,
    etapa_id uuid NOT NULL,
    numero_lance integer NOT NULL,
    fecha date NOT NULL,
    cod_arte_pesca integer NOT NULL,
    tipo_arte_pesca integer,
    hora_inicio double precision,
    lat_inicio double precision,
    long_inicio double precision,
    prof_inicio integer,
    hora_final double precision,
    lat_final double precision,
    long_final double precision,
    prof_final integer,
    rumbo integer,
    distancia_red double precision,
    velocidad_arrastre double precision,
    tiempo_red integer,
    estacion_gral integer,
    calador text,
    fondo_min integer,
    fondo_max integer,
    tamiz text,
    area_barrida double precision,
    captura_total_kg double precision,
    descarte_total_kg double precision,
    observaciones_lance text,
    mus integer,
    fuente_dato integer
);


ALTER TABLE public.lances OWNER TO postgres;

--
-- Name: mareas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.mareas (
    id uuid NOT NULL,
    anio_marea integer NOT NULL,
    nro_marea integer NOT NULL,
    id_buque uuid NOT NULL,
    id_arte_principal uuid,
    id_estado_actual uuid NOT NULL,
    fecha_zarpada_estimada timestamp with time zone,
    fecha_inicio_observador timestamp with time zone,
    fecha_fin_observador timestamp with time zone,
    dias_zona_austral integer,
    tipo_calculo_zona_austral text DEFAULT 'AUTOMATICO'::text NOT NULL,
    titulo text,
    descripcion text,
    nro_protocolizacion integer,
    anio_protocolizacion integer,
    fecha_protocolizacion timestamp with time zone,
    fecha_creacion timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    fecha_ultima_actualizacion timestamp with time zone NOT NULL,
    activo boolean DEFAULT true NOT NULL,
    observaciones text,
    tipo_marea text DEFAULT 'MC'::text NOT NULL,
    dias_estimados integer
);


ALTER TABLE public.mareas OWNER TO postgres;

--
-- Name: mareas_archivos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.mareas_archivos (
    id uuid NOT NULL,
    id_marea uuid NOT NULL,
    id_movimiento_origen uuid,
    tipo_archivo text NOT NULL,
    formato text,
    version text,
    ruta_archivo text NOT NULL,
    fecha_subida timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    id_usuario_subio uuid,
    descripcion text
);


ALTER TABLE public.mareas_archivos OWNER TO postgres;

--
-- Name: mareas_etapas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.mareas_etapas (
    id uuid NOT NULL,
    id_marea uuid NOT NULL,
    nro_etapa integer NOT NULL,
    id_pesqueria uuid,
    id_puerto_zarpada uuid,
    id_puerto_arribo uuid,
    fecha_zarpada timestamp with time zone,
    fecha_arribo timestamp with time zone,
    tipo_etapa text NOT NULL,
    observaciones text
);


ALTER TABLE public.mareas_etapas OWNER TO postgres;

--
-- Name: mareas_etapas_observadores; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.mareas_etapas_observadores (
    id uuid NOT NULL,
    id_etapa uuid NOT NULL,
    id_observador uuid NOT NULL,
    rol text DEFAULT 'PRINCIPAL'::text NOT NULL,
    es_designado boolean DEFAULT true NOT NULL
);


ALTER TABLE public.mareas_etapas_observadores OWNER TO postgres;

--
-- Name: mareas_movimientos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.mareas_movimientos (
    id uuid NOT NULL,
    id_marea uuid NOT NULL,
    fecha_hora timestamp with time zone NOT NULL,
    id_usuario uuid,
    tipo_evento text NOT NULL,
    id_estado_desde uuid,
    id_estado_hasta uuid,
    cantidad_muestras_otolitos integer,
    detalle text
);


ALTER TABLE public.mareas_movimientos OWNER TO postgres;

--
-- Name: muestras; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.muestras (
    id uuid NOT NULL,
    lance_id uuid NOT NULL,
    especie_id uuid NOT NULL,
    tipo_muestra text NOT NULL,
    peso_muestra_kg double precision,
    fact_ponderacion double precision,
    unidad_largo text NOT NULL,
    primera_talla integer,
    ultima_talla integer,
    intervalo_mm integer,
    total_mediciones integer,
    observaciones text
);


ALTER TABLE public.muestras OWNER TO postgres;

--
-- Name: muestras_detalle_talla; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.muestras_detalle_talla (
    id uuid NOT NULL,
    muestra_id uuid NOT NULL,
    talla_mm integer NOT NULL,
    cantidad_machos integer NOT NULL,
    cantidad_hembras integer NOT NULL,
    cantidad_indet integer NOT NULL,
    cantidad_total integer NOT NULL,
    indice_original integer NOT NULL
);


ALTER TABLE public.muestras_detalle_talla OWNER TO postgres;

--
-- Name: observador_pesquerias; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.observador_pesquerias (
    id uuid NOT NULL,
    id_observador uuid NOT NULL,
    id_pesqueria uuid NOT NULL,
    modo text NOT NULL,
    activo boolean DEFAULT true NOT NULL,
    motivo text,
    fecha_desde timestamp with time zone,
    fecha_hasta timestamp with time zone,
    id_especie uuid NOT NULL
);


ALTER TABLE public.observador_pesquerias OWNER TO postgres;

--
-- Name: observadores; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.observadores (
    id uuid NOT NULL,
    codigo_interno integer NOT NULL,
    nombre text NOT NULL,
    apellido text NOT NULL,
    foto_url text,
    tipo_observador text NOT NULL,
    tipo_contrato text NOT NULL,
    activo boolean DEFAULT true NOT NULL,
    disponible boolean DEFAULT true NOT NULL,
    fecha_proxima_disponibilidad timestamp with time zone,
    observaciones text,
    con_impedimento boolean DEFAULT false NOT NULL,
    email text,
    motivo_impedimento text
);


ALTER TABLE public.observadores OWNER TO postgres;

--
-- Name: password_reset_tokens; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.password_reset_tokens (
    id uuid NOT NULL,
    token text NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    used boolean DEFAULT false NOT NULL,
    requested_ip text,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    user_id uuid NOT NULL
);


ALTER TABLE public.password_reset_tokens OWNER TO postgres;

--
-- Name: pesquerias; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pesquerias (
    id uuid NOT NULL,
    codigo text NOT NULL,
    nombre text NOT NULL,
    descripcion text,
    grupo text,
    orden integer,
    activo boolean DEFAULT true NOT NULL
);


ALTER TABLE public.pesquerias OWNER TO postgres;

--
-- Name: producciones; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.producciones (
    id uuid NOT NULL,
    marea_id uuid NOT NULL,
    especie_id uuid NOT NULL,
    fecha date NOT NULL,
    producto text,
    categoria text,
    factor_conversion double precision,
    kg_produccion double precision NOT NULL,
    operarios integer
);


ALTER TABLE public.producciones OWNER TO postgres;

--
-- Name: product_images; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_images (
    id integer NOT NULL,
    url text NOT NULL,
    "productId" uuid NOT NULL
);


ALTER TABLE public.product_images OWNER TO postgres;

--
-- Name: product_images_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.product_images_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.product_images_id_seq OWNER TO postgres;

--
-- Name: product_images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.product_images_id_seq OWNED BY public.product_images.id;


--
-- Name: products; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.products (
    id uuid NOT NULL,
    title text NOT NULL,
    price double precision DEFAULT 0 NOT NULL,
    description text,
    slug text NOT NULL,
    stock integer DEFAULT 0 NOT NULL,
    sizes text[],
    gender text NOT NULL,
    tags text[] DEFAULT ARRAY[]::text[],
    "userId" uuid NOT NULL
);


ALTER TABLE public.products OWNER TO postgres;

--
-- Name: puertos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.puertos (
    id uuid NOT NULL,
    nombre text NOT NULL,
    provincia text,
    pais text,
    codigo_interno text,
    codigo_externo text,
    es_local boolean DEFAULT false NOT NULL,
    activo boolean DEFAULT true NOT NULL,
    orden integer,
    observaciones text,
    latitud double precision,
    longitud double precision
);


ALTER TABLE public.puertos OWNER TO postgres;

--
-- Name: submuestras; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.submuestras (
    id uuid NOT NULL,
    muestra_id uuid NOT NULL,
    numero_ejemplar integer NOT NULL,
    largo_total integer,
    largo_estandar integer,
    peso_total_g double precision,
    peso_gonadas_g double precision,
    sexo integer,
    estadio_madurez integer,
    replecion integer,
    contenido_estomacal text,
    observaciones_ejemplar text
);


ALTER TABLE public.submuestras OWNER TO postgres;

--
-- Name: tipos_flota; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tipos_flota (
    id uuid NOT NULL,
    codigo text NOT NULL,
    nombre text NOT NULL,
    descripcion text,
    orden integer,
    activo boolean DEFAULT true NOT NULL
);


ALTER TABLE public.tipos_flota OWNER TO postgres;

--
-- Name: transiciones_estados; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.transiciones_estados (
    id uuid NOT NULL,
    id_estado_origen uuid NOT NULL,
    id_estado_destino uuid NOT NULL,
    accion text NOT NULL,
    etiqueta text NOT NULL,
    clase_boton text,
    requiere_observaciones boolean DEFAULT false NOT NULL,
    activo boolean DEFAULT true NOT NULL
);


ALTER TABLE public.transiciones_estados OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id uuid NOT NULL,
    email text NOT NULL,
    password text NOT NULL,
    "fullName" text NOT NULL,
    "isActive" boolean DEFAULT true NOT NULL,
    roles text[] DEFAULT ARRAY['invitado'::text],
    "themePreference" text DEFAULT 'system'::text NOT NULL,
    "avatarUrl" text
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: product_images id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_images ALTER COLUMN id SET DEFAULT nextval('public.product_images_id_seq'::regclass);


--
-- Data for Name: _prisma_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public._prisma_migrations (id, checksum, finished_at, migration_name, logs, rolled_back_at, started_at, applied_steps_count) FROM stdin;
fb89f035-5e22-4a5f-b774-7d5fe2a80cc1	bee2d9194450fade8ac383ea904036fa4501a35691f5ef28ac880cb243e9542c	2026-01-03 17:20:09.014712+00	20251229225926_12_29	\N	\N	2026-01-03 17:20:08.906167+00	1
d41745e2-1324-4a62-8c25-8f74c57dfc52	7c22e6609bd096f6d7685581ed6b0b0c909a2d3104bf8ff3e96db1edf0cd3bb9	2026-01-03 17:20:09.024189+00	20251230150045_add_avatar_url	\N	\N	2026-01-03 17:20:09.017112+00	1
746e71ee-128b-4612-8e6e-7239487d3351	f8d58daf8546149005be90b9ba66a9d52b21c9265cfda82318ed41d088617c90	2026-01-03 17:20:09.271603+00	20251230191649_catalogos	\N	\N	2026-01-03 17:20:09.026458+00	1
52d077fe-0152-44b3-88a4-17eb27595dd6	20782ee2558020848026db9764e810d05ed583e58ef4b90e6f1f57fff37b6d95	2026-01-03 17:20:09.281565+00	20251230204050_add_lat_long_to_puerto	\N	\N	2026-01-03 17:20:09.27476+00	1
bb368101-17b4-4407-aaac-bd6a4ba044a0	3f6a3eeec854410c2fa19cd829635de8cb23d6ffaed54387dd55b6959f2f05c2	2026-01-03 17:20:09.750306+00	20251231125007_add_all_entities_from_docs	\N	\N	2026-01-03 17:20:09.284063+00	1
f3170871-f70a-4615-ae69-d2089133dee4	81be05cceb7597afbb2840c400faecf2b5fd61e65687f7a695be09cba98d455a	2026-01-03 17:20:09.761458+00	20251231132736_rename_arte_pesca_descripcion_to_nombre	\N	\N	2026-01-03 17:20:09.752792+00	1
bbb52cab-e3af-4915-8edf-4624a14330c4	3a21f64efb9cf9508a6ff148ac6b033bc42d41588d8d68135fb54b30c1bb8110	2026-01-03 17:20:09.786585+00	20251231150715_add_error_log	\N	\N	2026-01-03 17:20:09.763544+00	1
d8484a71-53d7-459e-a097-2c9ad2dae0b2	89ed15d6aa634c93d45242c899f5b2aa30f99a773bba53dee8fe8f2db7cb0286	2026-01-03 17:20:09.797049+00	20251231184904_add_tipo_marea_to_marea	\N	\N	2026-01-03 17:20:09.790105+00	1
2219b4d4-3620-4a34-99ee-849044e3dfb9	0c567b6e5e77e88ce15785b78a5c9a847a472fb02c6041fb3c8561467ed2668a	2026-01-03 17:20:09.889653+00	20260101195946_add_transiciones_y_etapa_observadores	\N	\N	2026-01-03 17:20:09.799415+00	1
064fc339-2933-4aaf-a14a-a41c8c80e5b6	9e20adc7e25e0838dc4a5888731d36d34ad52efbe4315a7a1d0e12657d032e45	2026-01-03 17:20:09.90897+00	20260103155245_add_unique_constraints_port_observer	\N	\N	2026-01-03 17:20:09.891848+00	1
525fbebd-5c2e-42c9-a86e-e68eebda412d	a886c52f1483408c8070d0ba8300408c5c7d49722267e0908cb8b5363721733c	2026-01-03 17:20:09.923375+00	20260103165415_update_observadores	\N	\N	2026-01-03 17:20:09.91123+00	1
\.


--
-- Data for Name: artes_pesca; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.artes_pesca (id, codigo_numerico, activo, nombre) FROM stdin;
95280ce6-e001-4c71-9c64-3994bf8beb53	2	t	Red de arrastre de fondo
59ce4b04-035a-49c9-b89e-863262378fe3	6	t	Red de arrastre de media agua
70024854-6d9a-4a96-8543-7ad223b2628a	3	t	Red de lampara
7eee5e36-1fcc-40eb-b9d9-1f95a262ca1c	5	t	Espinel
126519b4-8db6-4d7a-b3d9-9a88f1a2368d	4	t	Red de enmalle
bff78eb2-b028-4dc6-a254-c6ba2eb5269d	18	t	Red agallera de deriva
a5b73621-f1c8-4fb2-b4fd-24af1b776e40	16	t	Palangre de fondo
128cfe90-468d-4919-9789-89396b713852	1	t	Red de cerco
f4d2ea29-96d4-4664-b514-40b8674ab131	19	t	Red Bongo 300
eaa2c778-1c0d-4d6b-99cf-b3bdb9e56e6f	20	t	Red Bongo 500
5351b1ae-2033-4b0c-bd36-c603649c642e	21	t	Red Nakthai
5c54a56c-64db-4cfa-9a48-d435630344b4	22	t	Red Isaac-Kidd
c8dc913f-6916-443f-a493-254c51076669	7	t	Rastra
a456dfb9-6266-4ab6-b710-c5fb06ac08be	8	t	Nasa
19a73395-cab3-49af-8c13-68c99e0ee3f2	9	t	Linea
8f66bf25-a3a3-4706-b089-c6e5d0c99dbb	10	t	Raño
d383ee0b-fc50-4ae0-aec8-7230cfa231f3	11	t	Poteras
3cdd1d28-7723-4d41-b7e6-c175a28eaa3e	12	t	Red de fondeo
4c123cf5-3119-4c6e-97c9-f6f6dfaf79de	13	t	Trampa centollera
7bf053fd-02b7-4f5f-954e-61b3668f9611	14	t	Red de arrastre de fondo con tangones
bc365bc0-50a4-432e-8c29-9a365cce1f88	32	t	Currican
08962478-0cd5-4f79-b49f-e9b10c9007f6	15	t	Red de arrastre de fondo en pareja
8cc5cbed-c0c4-4dc8-94d4-2d7c4cb8fd15	80	t	Otros
c45d03bb-14e4-45ff-829d-0f42df76f85a	0	t	Sin Especificar
9234ff1a-937c-4907-ab56-8bfae0f5fc88	90	t	No Identificado
\.


--
-- Data for Name: buque_trayectoria_puntos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.buque_trayectoria_puntos (id, trayectoria_id, buque_id, "timestamp", lat, lon, velocidad, rumbo) FROM stdin;
\.


--
-- Data for Name: buque_trayectorias; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.buque_trayectorias (id, buque_id, origen, metadata) FROM stdin;
\.


--
-- Data for Name: buques; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.buques (id, nombre_buque, matricula, codigo_interno, id_tipo_flota, id_arte_habitual, id_pesqueria_habitual, dias_marea_estimada, eslora_m, potencia_hp, id_puerto_base, empresa_nombre, empresa_localidad, empresa_telefono, empresa_fax, empresa_correo_principal, empresa_correo_secundario, armador_nombre, armador_telefono, agencia_maritima_nombre, activo, fecha_alta, fecha_baja, observaciones) FROM stdin;
303bf403-b63a-4f71-879e-5cca3d2bde2b	7 de Diciembre	TEMP-0001	1013	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	27.20	521	37a047f1-e311-4664-b056-6f4311757b33		Mar del Plata	4895032		\N	operacionesconsultoramaritima@gmail.com	\N	\N	Consultora Maritima	t	\N	\N	\N
153fae6a-5a15-41fa-a1a0-cda6d8a26857	ACRUX	03086	0	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	28.00	0	37a047f1-e311-4664-b056-6f4311757b33	DE ANGELIS Y LOGGHE S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
6e65891d-dba3-4f12-8511-c5e57205ccc6	ALDEBARAN	01741	1038	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	26.42	426	37a047f1-e311-4664-b056-6f4311757b33	PESQUERA SAN ROQUE	Mar del Plata		480-0573	\N		\N	\N		t	\N	\N	\N
36ad8519-d445-4870-883d-4d1890d6ed3e	ALTALENA	0181	1051	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	55.80	1350	37a047f1-e311-4664-b056-6f4311757b33	MARONTI  S.A.	Mar del Plata	4800005		\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi	t	\N	\N	\N
fa902537-b62a-4864-81de-45fca7082533	ALVAREZ ENTRENA I	02454	1055	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	39.43	988	20e6681d-78b9-4d78-8fff-3549a0c294bd	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
6e67ea91-fe46-435b-96fe-114b2532cb6f	ALVAREZ ENTRENA II	02465	1056	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	39.50	988	20e6681d-78b9-4d78-8fff-3549a0c294bd	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
9563743b-07c5-4487-8110-2bc73f278d84	ALVAREZ ENTRENA III	02379	\N	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	\N	\N	20e6681d-78b9-4d78-8fff-3549a0c294bd	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
9e1132e9-0a68-4d64-a36f-d3855435a104	BAFFETTA	02635	0	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	19.45	295	20e6681d-78b9-4d78-8fff-3549a0c294bd	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
7be2cfae-b6a9-4bbc-82b1-0c1bc15f8e71	ALVAREZ ENTRENA VI	01	2774	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	30.50	1033	20e6681d-78b9-4d78-8fff-3549a0c294bd	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
ba06da97-2aff-4588-abaf-27cba73d39a0	AMBITION	01324	\N	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	\N	\N	37a047f1-e311-4664-b056-6f4311757b33	PESQUERA TRES MARIAS  S.A.	Mar del Plata		480-0336	\N		\N	\N		t	\N	\N	\N
aa820574-0468-4528-b1fb-a6ce85025db5	ANITA	3	\N	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	\N	\N	\N	37a047f1-e311-4664-b056-6f4311757b33	SOLIMENO	Mar del Plata			\N		\N	\N		t	\N	\N	\N
906d9a4b-b647-4f5b-a752-b0c5a941b218	ANA III	278	1069	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	19.95	443	20e6681d-78b9-4d78-8fff-3549a0c294bd	POSEIDON  S.A.	Puerto Madryn		0280-445-7786	\N		\N	\N		t	\N	\N	\N
b83fa5da-699b-4ea8-9e11-44887cf104ed	ANABELLA  M	0175	\N	5f917487-3b4d-4cec-ac8b-6f549a1ce217	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	60	\N	\N	20e6681d-78b9-4d78-8fff-3549a0c294bd	PESCAPUERTA ARGENTINA  S.A.	Puerto Madryn		0280-445-4407	\N		\N	\N		t	\N	\N	\N
c9c59757-d121-4e91-ab01-1969855a023d	ANDRES JORGE	1065	2760	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	50.10	1102	37a047f1-e311-4664-b056-6f4311757b33	MARONTI  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
d135dd5d-1511-414c-9be0-5a22be6614da	ANGELUS	01953	1087	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	52.60	1337	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	PESQUERA CRUZ DEL SUR  S.A.	Ciudad Autónoma de Buenos Aires		011-4784-1760	\N		\N	\N		t	\N	\N	\N
7c18944f-ef69-43e6-b7c0-6e8f2ffea547	ANITA ALVAREZ	02138	\N	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	\N	\N	20e6681d-78b9-4d78-8fff-3549a0c294bd	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
096ec4ed-e51f-4f82-8bfc-667fd17b5701	ANTARTIC  I	0232	\N	5b6e3b32-ed41-492e-a683-cb08f60e5dd9	a5b73621-f1c8-4fb2-b4fd-24af1b776e40	bd11f66e-22de-4ca1-a92a-e76082a2efa8	60	\N	\N	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	ESTREMAR  S.A.	Ciudad Autónoma de Buenos Aires		011-6533-7853 / 4345-1102	\N		\N	\N		t	\N	\N	\N
92b25a9b-d466-4f88-bcc5-532a3ff8d4ea	ANTARTIC II	0263	\N	5b6e3b32-ed41-492e-a683-cb08f60e5dd9	a5b73621-f1c8-4fb2-b4fd-24af1b776e40	bd11f66e-22de-4ca1-a92a-e76082a2efa8	60	\N	\N	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	ESTREMAR  S.A.	Ciudad Autónoma de Buenos Aires		011-6533-7853 / 4345-1102	\N		\N	\N		t	\N	\N	\N
86aad7de-9426-458c-8f71-1f42e59e3f56	ANTARTIC III	0262	\N	5b6e3b32-ed41-492e-a683-cb08f60e5dd9	a5b73621-f1c8-4fb2-b4fd-24af1b776e40	bd11f66e-22de-4ca1-a92a-e76082a2efa8	60	\N	\N	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	ESTREMAR  S.A.	Ciudad Autónoma de Buenos Aires		011-6533-7853 / 4345-1102	\N		\N	\N		t	\N	\N	\N
d61c8fca-566f-4544-95a4-8ee85a06ff69	ANTARTIDA	0678	\N	5f917487-3b4d-4cec-ac8b-6f549a1ce217	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	60	\N	\N	20e6681d-78b9-4d78-8fff-3549a0c294bd	IBERCONSA  DE ARGENTINA  S.A.	Puerto Madryn	4891227	0280-445-4324	\N	serviciosmaritimosmdq@gmail.com	\N	\N	Servicio Maritimo Integral	t	\N	\N	\N
93eae7e3-c426-4254-bbfd-d153cb250bfe	ANTONINO	0877	1099	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	27.60	541	37a047f1-e311-4664-b056-6f4311757b33	AGLIPESCA  S.A.	Mar del Plata		480-2886	\N		\N	\N		t	\N	\N	\N
8c448bf0-e35c-45a1-a12d-9b08d2f4ca00	ANTONIO ALVAREZ	01429	1100	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	36.60	1168	20e6681d-78b9-4d78-8fff-3549a0c294bd	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
091b9e12-66ad-47ba-afd0-7eb61019fcb8	API II	0679	\N	5f917487-3b4d-4cec-ac8b-6f549a1ce217	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	60	\N	\N	20e6681d-78b9-4d78-8fff-3549a0c294bd	IBERCONSA  DE ARGENTINA  S.A.	Puerto Madryn		0280-445-4324	\N		\N	\N		t	\N	\N	\N
5bee8f7e-fa77-4b86-b6f4-623e02cb90c3	API IV	0680	\N	5f917487-3b4d-4cec-ac8b-6f549a1ce217	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	60	\N	\N	20e6681d-78b9-4d78-8fff-3549a0c294bd	IBERCONSA  DE ARGENTINA  S.A.	Puerto Madryn		0280-445-4324	\N		\N	\N		t	\N	\N	\N
611d9ed5-4753-4421-a32a-08ef78d13092	API V	02781	2711	5f917487-3b4d-4cec-ac8b-6f549a1ce217	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	60	77.40	2960	20e6681d-78b9-4d78-8fff-3549a0c294bd	IBERCONSA  DE ARGENTINA  S.A.	Puerto Madryn		0280-445-4324	\N		\N	\N		t	\N	\N	\N
92877cd0-1d4b-48bf-9a2a-5d76eb88c123	API VI	02812	2734	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	40	36.35	1201	20e6681d-78b9-4d78-8fff-3549a0c294bd	IBERCONSA  DE ARGENTINA  S.A.	Puerto Madryn		0280-445-4324	\N		\N	\N		t	\N	\N	\N
327a92dd-b3a2-4159-a7c3-c5e367c8c0d5	API VII	03081	2777	5f917487-3b4d-4cec-ac8b-6f549a1ce217	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	60	72.20	0	20e6681d-78b9-4d78-8fff-3549a0c294bd	IBERCONSA  DE ARGENTINA  S.A.	Puerto Madryn		0280-445-4324	\N		\N	\N		t	\N	\N	\N
c8676996-68b2-44c7-96af-0264e7719e0f	ARBUMASA X	6183	1114	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	35.30	1087	be29702b-a6a9-434d-8eb3-5705e0f7468f	ARBUMASA  S.A.	Puerto Deseado		0297-487-2807 / 444-5338 / 444-1201	\N		\N	\N		t	\N	\N	\N
fd7b6525-aa63-4e5b-af4b-feece0a06683	ARBUMASA XIX	06440	1117	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	36.40	870	be29702b-a6a9-434d-8eb3-5705e0f7468f	ARBUMASA  S.A.	Puerto Deseado		0297-487-2807 / 444-5338 / 444-1201	\N		\N	\N		t	\N	\N	\N
0a5f43f4-e61f-4282-b6d2-3b55a93a3d45	ARBUMASA  XVII	0216	\N	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	\N	\N	be29702b-a6a9-434d-8eb3-5705e0f7468f	ARBUMASA  S.A.	Puerto Deseado		0297-487-2807 / 444-5338 / 444-1201	\N		\N	\N		t	\N	\N	\N
4a7d614a-67ef-4e13-8811-7a200f16eea5	ARBUMASA XIV	0213	1116	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	36.40	1047	be29702b-a6a9-434d-8eb3-5705e0f7468f	ARBUMASA  S.A.	Puerto Deseado		0297-487-2807 / 444-5338 / 444-1201	\N		\N	\N		t	\N	\N	\N
3db326b5-5aaa-4c7a-9e87-e16dc027fe94	ARBUMASA XV	214	1118	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	36.40	870	\N	ARBUMASA  S.A.				\N		\N	\N		t	\N	\N	\N
2a02118c-88a5-4ef6-afa1-d944036c210a	ARBUMASA XVI	0215	1119	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	36.40	1047	be29702b-a6a9-434d-8eb3-5705e0f7468f	ARBUMASA  S.A.	Puerto Deseado		0297-487-2807 / 444-5338 / 444-1201	\N		\N	\N		t	\N	\N	\N
6f17b9aa-e180-4ab9-9616-c1efbab03888	ARBUMASA XVIII	0217	1121	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	36.40	870	be29702b-a6a9-434d-8eb3-5705e0f7468f	ARBUMASA  S.A.	Puerto Deseado	4893758	0297-487-2807 / 444-5338 / 444-1201	\N	miguel-visoso@hotmail.com	\N	\N	Agencia Maritima Solvox	t	\N	\N	\N
72235894-75f3-4857-aa97-0142078f6d84	ARBUMASA XXIX	02561	1126	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	65.60	1776	37a047f1-e311-4664-b056-6f4311757b33	BAL - FISH  S.A.	Mar del Plata		489-6522	\N		\N	\N		t	\N	\N	\N
b73d84b9-f86b-49a9-98b5-1797ec19a155	ARBUMASA XXVI	01958	1127	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	62.80	2403	be29702b-a6a9-434d-8eb3-5705e0f7468f	ARBUMASA  S.A.	Puerto Deseado	4893758	0297-487-2807 / 444-5338 / 444-1201	\N	miguel-visoso@hotmail.com	\N	\N	Agencia Maritima Solvox	t	\N	\N	\N
db953074-b293-4d01-b1eb-f75e9906d4c3	ARBUMASA XXVII	02057	1128	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	64.21	1154	37a047f1-e311-4664-b056-6f4311757b33	BAL - FISH  S.A.	Mar del Plata		489-6522	\N		\N	\N		t	\N	\N	\N
7c106d36-6444-485a-a798-b4b0fbf80df2	ARBUMASA XXVIII	02569	1129	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	64.40	1776	be29702b-a6a9-434d-8eb3-5705e0f7468f	ARBUMASA  S.A.	Puerto Deseado		0297-487-2807 / 444-5338 / 444-1201	\N		\N	\N		t	\N	\N	\N
d389c14e-c4d2-4b7e-9ea2-d3abb9983d6e	ARCANGEL	79	\N	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	\N	\N	37a047f1-e311-4664-b056-6f4311757b33	CALME  S.A.	Mar del Plata		480-3545	\N		\N	\N		t	\N	\N	\N
5e6bfd86-e013-4dc7-89f7-76b5aaf61138	ARESIT	02265	1134	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	36.26	1085	20e6681d-78b9-4d78-8fff-3549a0c294bd	HARENGUS  S.A.	Puerto Madryn	4808331/4808332	0280-445-0822	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
c8f44317-5011-49c4-8322-77fb7bc39417	ARGENOVA I	02180	1137	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	35.00	655	be29702b-a6a9-434d-8eb3-5705e0f7468f	ARGENOVA  S.A.	Puerto Deseado	4808331/4808332	0297- 487-0550  (447-2818  Com. Riv )	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
45a6c7c2-0aa0-4aea-93e4-bf040df7f61b	ARGENOVA IV	02157	1140	\N	\N	\N	0	36.26	675	be29702b-a6a9-434d-8eb3-5705e0f7468f	MAR DE LAS PALMAS  S.A.	Puerto Deseado	4808331/4808332	0297-487-2112	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
c0c59f68-ff8d-44e9-8e1f-f47c9cf7820a	ARGENOVA X	02329	1146	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	32.50	550	be29702b-a6a9-434d-8eb3-5705e0f7468f	ARGENOVA  S.A.	Puerto Deseado	4808331/4808332	0297- 487-0550  (447-2818  Com. Riv )	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
0c46ed96-d5c3-4698-8375-dbd4e9523da2	ARGENOVA XI	02199	\N	5b6e3b32-ed41-492e-a683-cb08f60e5dd9	a5b73621-f1c8-4fb2-b4fd-24af1b776e40	bd11f66e-22de-4ca1-a92a-e76082a2efa8	60	\N	\N	be29702b-a6a9-434d-8eb3-5705e0f7468f	ARGENOVA  S.A.	Puerto Deseado	4808331/4808332	0297- 487-0550  (447-2818  Com. Riv )	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
0d1e807a-8707-4528-b2ea-2ed91f014f83	ARGENOVA XXI	02661	2704	3c4c96c7-1ccb-437d-8cb4-ec87500da20d	95280ce6-e001-4c71-9c64-3994bf8beb53	61617027-3911-4e52-91ac-c8612dac86c9	60	55.80	1826	be29702b-a6a9-434d-8eb3-5705e0f7468f	ARGENOVA  S.A.	Puerto Deseado	4808331/4808332	0297- 487-0550  (447-2818  Com. Riv )	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
c6f2eab0-0c31-4ed2-932b-0f40ed6eeb38	ARGENOVA XXII	02714	2713	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	40	37.70	663	be29702b-a6a9-434d-8eb3-5705e0f7468f	ARGENOVA  S.A.	Puerto Deseado	4808331/4808332	0297- 487-0550  (447-2818  Com. Riv )	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
9781e6d2-cb9c-44b6-bac1-680d4f6fdc95	ARGENOVA XXIII	02713	2707	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	37.19	678	be29702b-a6a9-434d-8eb3-5705e0f7468f	ARGENOVA  S.A.	Puerto Deseado	4808331/4808332	0297- 487-0550  (447-2818  Com. Riv )	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
d36cec96-c9be-4826-950f-4d9bb414b28f	ARGENOVA XXIV	02752	2731	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	38.80	675	be29702b-a6a9-434d-8eb3-5705e0f7468f	ARGENOVA  S.A.	Puerto Deseado	4808331/4808332	0297- 487-0550  (447-2818  Com. Riv )	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
56759ff9-c273-4d65-8b4d-13b65335ebf4	ARGENOVA XXV	028011	2740	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	39.70	859	be29702b-a6a9-434d-8eb3-5705e0f7468f	ARGENOVA  S.A.	Puerto Deseado	4808331/4808332	0297- 487-0550  (447-2818  Com. Riv )	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
8d4b2128-e6cd-4d7b-8d80-e4e54b9910a6	ARGENOVA XXVI	02849	2739	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	37.15	1086	be29702b-a6a9-434d-8eb3-5705e0f7468f	ARGENOVA  S.A.	Puerto Deseado	4808331/4808332	0297- 487-0550  (447-2818  Com. Riv )	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
ce52de1c-8a31-4e0d-bd2e-57ddc58b2b74	ARGENOVA II	02177	1138	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	38.50	1168	be29702b-a6a9-434d-8eb3-5705e0f7468f	ARGENOVA  S.A.	Puerto Deseado	4808331/4808332	0297- 487-0550  (447-2818  Com. Riv )	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
ed71377d-471c-4a83-9b13-2fc64fc70b1c	ARGENOVA III	02156	\N	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	\N	\N	be29702b-a6a9-434d-8eb3-5705e0f7468f	ARGENOVA  S.A.	Puerto Deseado		0297- 487-0550  (447-2818  Com. Riv )	\N		\N	\N		t	\N	\N	\N
a95b7f4b-a7f0-4970-87ba-dfb2b9def4cb	ARGENOVA IX	02328	1141	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	32.50	550	be29702b-a6a9-434d-8eb3-5705e0f7468f	ARGENOVA  S.A.	Puerto Deseado	4808331/4808332	0297- 487-0550  (447-2818  Com. Riv )	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
68f13236-3a39-4896-bb3b-84ff1d62b7c9	ARGENOVA XII	0199	\N	5b6e3b32-ed41-492e-a683-cb08f60e5dd9	a5b73621-f1c8-4fb2-b4fd-24af1b776e40	bd11f66e-22de-4ca1-a92a-e76082a2efa8	60	\N	\N	be29702b-a6a9-434d-8eb3-5705e0f7468f	ARGENOVA  S.A.	Puerto Deseado	4808331/4808332	0297- 487-0550  (447-2818  Com. Riv )	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
a952b543-175f-487f-963a-208ee39c745d	ARGENOVA XIV	0197	1149	5b6e3b32-ed41-492e-a683-cb08f60e5dd9	a5b73621-f1c8-4fb2-b4fd-24af1b776e40	bd11f66e-22de-4ca1-a92a-e76082a2efa8	60	52.30	1352	be29702b-a6a9-434d-8eb3-5705e0f7468f	ARGENOVA  S.A.	Puerto Deseado	4808331/4808332	0297- 487-0550  (447-2818  Com. Riv )	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
861f39cb-9aad-4df2-beab-884468ec7e26	ARGENOVA XV	0198	\N	5b6e3b32-ed41-492e-a683-cb08f60e5dd9	a5b73621-f1c8-4fb2-b4fd-24af1b776e40	bd11f66e-22de-4ca1-a92a-e76082a2efa8	60	\N	\N	be29702b-a6a9-434d-8eb3-5705e0f7468f	ARGENOVA  S.A.	Puerto Deseado	4800274	0297- 487-0550  (447-2818  Com. Riv )	\N	amalfitanoycia@hotmail.com	\N	\N	Agencia Maritima Almafitano	t	\N	\N	\N
e9cb33a5-3749-4278-88a9-6ffa6226f138	ARGENTINO	0142	1157	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	33.77	1001	37a047f1-e311-4664-b056-6f4311757b33	PESQUERA VERAZ  S.A.	Mar del Plata		489-4624 / 489-0314 (astillero)	\N		\N	\N		t	\N	\N	\N
a3a86ec1-ca8f-447b-a208-e0c379299129	ARKOFISH	0236	\N	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	\N	\N	20e6681d-78b9-4d78-8fff-3549a0c294bd	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
de51ca40-60ae-4dc9-85c5-51ce8c6513b0	ARKOFISH I	6004	\N	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	\N	\N	20e6681d-78b9-4d78-8fff-3549a0c294bd	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
62626d63-de78-4cea-bc12-bda98052891e	ARRUFO	0540	1165	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	39.16	1102	37a047f1-e311-4664-b056-6f4311757b33	LUIS SOLIMENO e HIJOS  S.A.	Mar del Plata		489-3030	\N		\N	\N		t	\N	\N	\N
81b553ea-7f43-452e-bf3d-848829d7e3e6	ASUDEPES II	6363	\N	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	\N	\N	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	ASUDEPES  S.A.	Ciudad Autónoma de Buenos Aires		011-4383-9756	\N		\N	\N		t	\N	\N	\N
9145de55-18a5-41d8-8552-3ba10d02b654	ASUDEPES III	6062	\N	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	\N	\N	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	ASUDEPES  S.A.	Ciudad Autónoma de Buenos Aires		011-4383-9756	\N		\N	\N		t	\N	\N	\N
c77c081f-1b19-422d-acc6-6320c3b5e9cd	ATLANTIC EXPRESS	02936	2727	e72ee47d-c05e-422b-b740-59668cc58a73	4c123cf5-3119-4c6e-97c9-f6f6dfaf79de	1f6e6d84-215f-48d5-b131-5fe9f3e631da	30	53.70	3426	37a047f1-e311-4664-b056-6f4311757b33	WANCHESE ARGENTINA  S.A.	Mar del Plata		489-1236	\N		\N	\N		t	\N	\N	\N
e98a0198-ed6b-4da1-bcb5-6eb61cc98bb7	ATLANTIC SURF I	0350	\N	627a88cb-bf97-434f-bfab-4ef3339c44d3	7bf053fd-02b7-4f5f-954e-61b3668f9611	bdb064e1-c2c3-4e77-ac2a-64dc9bd12fbf	40	\N	\N	37a047f1-e311-4664-b056-6f4311757b33	GLACIAR PESQUERA  S.A.	Mar del Plata	4890960	492-2216	\N	agencia@maritimavidal.com.ar	\N	\N	Agencia Maritima Vidal	t	\N	\N	\N
06bdab70-a38c-4e21-8220-dfda3f16c5a5	ATLANTIC SURF III	02030	1176	627a88cb-bf97-434f-bfab-4ef3339c44d3	7bf053fd-02b7-4f5f-954e-61b3668f9611	bdb064e1-c2c3-4e77-ac2a-64dc9bd12fbf	60	49.60	3020	37a047f1-e311-4664-b056-6f4311757b33	GLACIAR PESQUERA  S.A.	Mar del Plata	4800274	492-2216	\N	amalfitanoycia@hotmail.com	\N	\N	Agencia Maritima Almafitano	t	\N	\N	\N
c226f5ed-4f64-4623-bfc2-77d7e32fcec3	ATREVIDO	0145	1180	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	32.50	901	37a047f1-e311-4664-b056-6f4311757b33	PESQUERA VERAZ  S.A.	Mar del Plata	4800005	489-4624 / 489-0314 (astillero)	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
06014117-579d-40e0-9289-e634cf96cccc	AURORA	02581	1183	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	67.55	1776	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	KALEU KALEU  S.A.	Ciudad Autónoma de Buenos Aires		011-3220-2130  / 5093-1215	\N		\N	\N		t	\N	\N	\N
c2a9aa2a-b5be-4341-9650-251e04c58019	BAHIA DESVELOS	0665	1194	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	37.05	791	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	PESQUERA SANTA CRUZ  S.A.	Ciudad Autónoma de Buenos Aires		011-4305-4706	\N		\N	\N		t	\N	\N	\N
021ce2b1-50ca-4337-8442-9c3df168bab8	BEAGLE I	6052	1207	5f917487-3b4d-4cec-ac8b-6f549a1ce217	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	60	59.90	2369	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	YUKEN  S.A.	Ciudad Autónoma de Buenos Aires	4891553-154179360-154179860-154179062	011-5279-1302 / 5236-6069	\N	agenciasmiriglio@speedy.com.ar	\N	\N	Agencia Maritima Smiriglio	t	\N	\N	\N
51e8571f-1aa2-432f-94d0-c82efe68e2a1	BELVEDERE	01398	1210	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	26.50	624	37a047f1-e311-4664-b056-6f4311757b33	PRINMAR  S.A. Buque Motor Belvedere	Mar del Plata		480-0883	\N		\N	\N		t	\N	\N	\N
6e4c1895-5663-4f7d-a1f9-80f7598f87c0	BOGAVANTE SEGUNDO	02994	2743	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	37.45	867	20e6681d-78b9-4d78-8fff-3549a0c294bd	IBERCONSA  DE ARGENTINA  S.A.	Puerto Madryn		0280-445-4324	\N		\N	\N		t	\N	\N	\N
5ec12413-d151-43d4-b20c-39ecce4ebfb0	BONFIGLIO	01234	\N	4bcfaa2a-1a55-4c30-8256-bc499d7d07dc	95280ce6-e001-4c71-9c64-3994bf8beb53	\N	10	\N	\N	37a047f1-e311-4664-b056-6f4311757b33	COSTA BRAVA  S.A.	Mar del Plata		489-7538	\N		\N	\N		t	\N	\N	\N
e80a9832-59ba-4255-8fc0-06da649832c6	BORRASCA	01095	1218	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	39.16	1083	37a047f1-e311-4664-b056-6f4311757b33	LUIS SOLIMENO e HIJOS  S.A.	Mar del Plata		489-3030	\N		\N	\N		t	\N	\N	\N
8e38ebc8-3da4-4fe8-bcd8-09d4adf9737f	BOUCIÑA	01637	1221	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	0.00	0	37a047f1-e311-4664-b056-6f4311757b33	CALME  S.A.	Mar del Plata	4800005	480-3545	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
bc083d20-0f6e-4e2f-9e90-c7f27af7a9f7	BUENA PESCA	01475	2717	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	39.10	1479	37a047f1-e311-4664-b056-6f4311757b33	PEDRO MOSCUZZA e HIJOS  S.A.	Mar del Plata		489-7287	\N		\N	\N		t	\N	\N	\N
447bd158-a378-4a50-9d5b-e264562ff489	CABO BUEN TIEMPO	025	\N	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	\N	\N	20e6681d-78b9-4d78-8fff-3549a0c294bd	ALPESCA  S.A.	Puerto Madryn		0280-447-4958 / 45-1069	\N		\N	\N		t	\N	\N	\N
234d19de-6338-4fa6-8e98-ce32abe7a9b0	CABO BUENA ESPERANZA	02482	\N	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	\N	\N	37a047f1-e311-4664-b056-6f4311757b33	UNIVERSAL PESQUERA  SRL	Mar del Plata		489-0352	\N		\N	\N		t	\N	\N	\N
2e4cf375-c1c3-448b-b208-3900cbd91e8a	CABO DE HORNOS	01537	\N	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	\N	\N	37a047f1-e311-4664-b056-6f4311757b33	MILANI Y PATANE  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
302c9240-234c-41ff-a927-c9c11bfa276f	CABO DOS BAHIAS	02483	\N	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	\N	\N	20e6681d-78b9-4d78-8fff-3549a0c294bd	ALPESCA  S.A.	Puerto Madryn		0280-447-4958 / 45-1069	\N		\N	\N		t	\N	\N	\N
9ed1a19c-431b-4fb3-81ef-375932139f6d	CABO SAN JUAN	023	\N	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	\N	\N	20e6681d-78b9-4d78-8fff-3549a0c294bd	ALPESCA  S.A.	Puerto Madryn		0280-447-4958 / 45-1069	\N		\N	\N		t	\N	\N	\N
110276be-e3ff-405f-8dd0-7eba069b65c5	CABO SAN SEBASTIAN	022	\N	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	\N	\N	20e6681d-78b9-4d78-8fff-3549a0c294bd	ALPESCA  S.A.	Puerto Madryn		0280-447-4958 / 45-1069	\N		\N	\N		t	\N	\N	\N
3decb270-2d04-447f-b283-c61ceb1ea12c	CABO TRES PUNTAS	01483	1242	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	31.43	721	37a047f1-e311-4664-b056-6f4311757b33	OSTRAMAR  S.A.	Mar del Plata		489-1959	\N		\N	\N		t	\N	\N	\N
a52e1856-64d1-4982-96cb-bfd485602bec	CABO VIRGENES	024	\N	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	\N	\N	20e6681d-78b9-4d78-8fff-3549a0c294bd	ALPESCA  S.A.	Puerto Madryn		0280-447-4958 / 45-1069	\N		\N	\N		t	\N	\N	\N
293ae35d-172c-46be-aacb-1cc9ffa37adc	CALABRIA	0567	1245	4bcfaa2a-1a55-4c30-8256-bc499d7d07dc	95280ce6-e001-4c71-9c64-3994bf8beb53	\N	4	19.63	266	20e6681d-78b9-4d78-8fff-3549a0c294bd	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
1bc6e9e0-fc1a-45ba-b577-b251918526bc	CALIZ	02809	0	4bcfaa2a-1a55-4c30-8256-bc499d7d07dc	95280ce6-e001-4c71-9c64-3994bf8beb53	\N	4	20.20	545	a68c150f-2d39-40d2-a693-9d1b15859f5f	FLOTA AMARILLA RAWSON	Rawson			\N		\N	\N		t	\N	\N	\N
35660b89-5938-4e72-b9b4-2611819bde27	CALLEJA	06276	1249	4bcfaa2a-1a55-4c30-8256-bc499d7d07dc	95280ce6-e001-4c71-9c64-3994bf8beb53	\N	10	21.83	503	37a047f1-e311-4664-b056-6f4311757b33	OTESA  S.A.	Mar del Plata		493-5606	\N		\N	\N		t	\N	\N	\N
ece37d6f-e718-483e-83f0-c0203c2f9147	CAMERIGE	01406	1252	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	27.90	652	37a047f1-e311-4664-b056-6f4311757b33	PESQUERA  MARGARITA  S.A.	Mar del Plata	4891553-154179360-154179860-154179062	489-4645   /   489-2946	\N	agenciasmiriglio@speedy.com.ar	\N	\N	Agencia Maritima SMIRIGLIO	t	\N	\N	\N
c8a4dc99-35c6-44ad-842c-6490d5599783	CANAL DE BEAGLE	0407	0	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	23.90	501	37a047f1-e311-4664-b056-6f4311757b33	CANAL DE BEAGLE  S.R.L.	Mar del Plata		480-4447	\N		\N	\N		t	\N	\N	\N
4010465b-d1f8-4d59-8822-ab55611e8453	CAPESANTE	02929	2723	627a88cb-bf97-434f-bfab-4ef3339c44d3	7bf053fd-02b7-4f5f-954e-61b3668f9611	bdb064e1-c2c3-4e77-ac2a-64dc9bd12fbf	40	50.15	2550	37a047f1-e311-4664-b056-6f4311757b33	GLACIAR PESQUERA  S.A.	Mar del Plata		492-2216	\N		\N	\N		t	\N	\N	\N
a896f8af-6daa-4998-8b2b-4d9d727815b2	CAPITAN CANEPA	059F	\N	201b037d-1ab0-4fb9-92aa-c9af3cff2044	\N	\N	28	\N	\N	37a047f1-e311-4664-b056-6f4311757b33	INIDEP	Mar del Plata		451-7442 ó 486-2586 int 162	\N		\N	\N		t	\N	\N	\N
30ad7dcc-4866-4d3d-b711-49a3b65b09a2	CAPITAN GIACHINO	0151	1260	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	38.42	1062	37a047f1-e311-4664-b056-6f4311757b33	KALARI S.A.	Mar del Plata		489-1959	\N		\N	\N		t	\N	\N	\N
8df8dd01-3099-41d9-822f-57159afe7563	CAPITAN OCA BALDA	060F	\N	201b037d-1ab0-4fb9-92aa-c9af3cff2044	\N	\N	21	\N	\N	37a047f1-e311-4664-b056-6f4311757b33	INIDEP	Mar del Plata		451-7442 ó 486-2586 int 162	\N		\N	\N		t	\N	\N	\N
4e794856-6a63-4313-bd64-e06886a818c9	CARMEN A	02045	1269	4bcfaa2a-1a55-4c30-8256-bc499d7d07dc	95280ce6-e001-4c71-9c64-3994bf8beb53	\N	4	15.30	223	a68c150f-2d39-40d2-a693-9d1b15859f5f	FLOTA AMARILLA RAWSON	Rawson			\N		\N	\N		t	\N	\N	\N
cac3efa4-7b4f-410a-b74c-7095ce14a038	CAROLINA P	0176	1272	3c4c96c7-1ccb-437d-8cb4-ec87500da20d	95280ce6-e001-4c71-9c64-3994bf8beb53	61617027-3911-4e52-91ac-c8612dac86c9	60	71.60	1976	20e6681d-78b9-4d78-8fff-3549a0c294bd	ESTRELLA PATAGONICA S.A.	Puerto Madryn		0280-445-4407	\N		\N	\N		t	\N	\N	\N
4109b08f-ad90-4c66-a1a3-3318e80d1cb5	CEIBE DOUS	0336	1276	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	40.70	738	20e6681d-78b9-4d78-8fff-3549a0c294bd	IBERCONSA  DE ARGENTINA  S.A.	Puerto Madryn	4800274	0280-445-4324	\N	amalfitanoycia@hotmail.com	\N	\N	Agencia Maritima Almafitano	t	\N	\N	\N
a300bb3c-6eed-423c-b957-673ecee5e140	CENTAURO 2000	0482	1278	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	35.50	1302	37a047f1-e311-4664-b056-6f4311757b33	PESQUERA VERAZ  S.A.	Mar del Plata		489-4624 / 489-0314 (astillero)	\N		\N	\N		t	\N	\N	\N
e201c4aa-bd1f-4d00-9ce2-9e9478fea318	CENTURION DEL ATLANTICO	0237	1280	3c4c96c7-1ccb-437d-8cb4-ec87500da20d	95280ce6-e001-4c71-9c64-3994bf8beb53	61617027-3911-4e52-91ac-c8612dac86c9	60	112.80	8111	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	ESTREMAR  S.A.	Ciudad Autónoma de Buenos Aires		011-6533-7853 / 4345-1102	\N		\N	\N		t	\N	\N	\N
31cb29fe-cb99-4c7e-a5f8-6049f4defe5d	CERES	01420	1281	5f917487-3b4d-4cec-ac8b-6f549a1ce217	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	60	60.74	1969	37a047f1-e311-4664-b056-6f4311757b33	PESQUERA CERES  S.A.	Mar del Plata		410-0051 / 7	\N		\N	\N		t	\N	\N	\N
26ef32f5-6394-4171-a5ff-2d46b4e237cf	CHANG BO GO I	06190	\N	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	\N	\N	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	ARPEPA  M.C.I.S.A.	Ciudad Autónoma de Buenos Aires		011-4382-1605	\N		\N	\N		t	\N	\N	\N
9fdfd618-3aed-404e-a344-a635a561e516	CHATKA I	02893	0	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	16.73	195	20e6681d-78b9-4d78-8fff-3549a0c294bd	FOOD PARTNERS PATAGONIA S.A.	Puerto Madryn		0280-4458579 / 5225	\N		\N	\N		t	\N	\N	\N
d3566959-4a0a-4060-9666-356ef3d1bc0d	CHIARPESCA 56	01090	\N	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	\N	\N	37a047f1-e311-4664-b056-6f4311757b33	APOLO FISH  S.A.	Mar del Plata		489-4519 / 489-1133	\N		\N	\N		t	\N	\N	\N
27e077b4-78b7-41b0-855b-4ff8380d1a2e	CHIARPESCA 57	01029	\N	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	\N	\N	37a047f1-e311-4664-b056-6f4311757b33	CHIARPESCA  S.A.	Mar del Plata		489-1385	\N		\N	\N		t	\N	\N	\N
2c3fdd34-00f4-44fb-a0e3-c9f05833c2b5	CHIARPESCA 902	02110	\N	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	\N	\N	37a047f1-e311-4664-b056-6f4311757b33	CHIARPESCA  S.A.	Mar del Plata		489-1385	\N		\N	\N		t	\N	\N	\N
a78dda22-3faa-4a73-85cf-8046e174164a	CHIARPESCA 903	02109	\N	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	\N	\N	37a047f1-e311-4664-b056-6f4311757b33	CHIARPESCA  S.A.	Mar del Plata		489-1385	\N		\N	\N		t	\N	\N	\N
2e11dfca-6858-47ef-973f-c98f57b21a78	CHIYO MARU Nº 3	02987	2745	e72ee47d-c05e-422b-b740-59668cc58a73	4c123cf5-3119-4c6e-97c9-f6f6dfaf79de	1f6e6d84-215f-48d5-b131-5fe9f3e631da	30	52.80	937	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	CRUSTACEOS DEL SUR  S.A.	Ciudad Autónoma de Buenos Aires		011-5218-4287	\N		\N	\N		t	\N	\N	\N
158767b4-0868-40e7-9ddf-f328c73a38a6	CHOCO MARU 68	JA13	\N	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	\N	\N	37a047f1-e311-4664-b056-6f4311757b33	PESQUERA COMERCIAL  S.A.	Mar del Plata		489-3030	\N		\N	\N		t	\N	\N	\N
194d64df-70ac-45f3-baff-9f0b4c31bcd8	CHOKYU MARU Nº 18.	2584	1312	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	68.70	1777	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	BAHIA GRANDE  S.A.	Ciudad Autónoma de Buenos Aires		011-5272-0850 / 5254-1133	\N		\N	\N		t	\N	\N	\N
acbf2899-220c-443d-bff4-3180a0d4f65c	CINCOMAR 1	0439	\N	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	\N	\N	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	CINCOMAR  S.A.	Ciudad Autónoma de Buenos Aires		011-4326-4991	\N		\N	\N		t	\N	\N	\N
7597a03a-50d4-4fc0-b637-272f6aa271b3	CINCOMAR 5	02351	\N	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	\N	\N	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	CINCOMAR  S.A.	Ciudad Autónoma de Buenos Aires		011-4326-4991	\N		\N	\N		t	\N	\N	\N
9a83cfd0-5cc0-4135-a34b-a6ee442b7be5	CIUDAD DE HUELVA	01519	1324	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	27.45	426	20e6681d-78b9-4d78-8fff-3549a0c294bd	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
3d1ccda8-5d1f-454c-a94e-fc4a6099e3c5	CIUDAD FELIZ	0910	2721	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	28.56	458	37a047f1-e311-4664-b056-6f4311757b33	CARAVON S.A.	Mar del Plata		489-9404	\N		\N	\N		t	\N	\N	\N
12e4b6ff-3b5f-4374-8b3d-ba10244b76df	CLAUDIA	02183	\N	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	\N	\N	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	LUXMARINO  S.A.	Ciudad Autónoma de Buenos Aires		011-4342-2621	\N		\N	\N		t	\N	\N	\N
a2ab0731-1d6c-4197-a7ee-aed9f6ab3c14	CLAUDINA	02345	1331	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	53.58	937	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	ARMADORA  ACRUX  S.A.	Ciudad Autónoma de Buenos Aires		011-4312-6470	\N		\N	\N		t	\N	\N	\N
ee82a79d-9d3e-4459-9fa6-b8ef352cbc65	COALSA SEGUNDO	0790	1333	5f917487-3b4d-4cec-ac8b-6f549a1ce217	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	60	76.20	2960	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	YUKEN  S.A.	Ciudad Autónoma de Buenos Aires		011-5279-1302 / 5236-6069	\N		\N	\N		t	\N	\N	\N
37b5ca8c-55e7-4c3b-8cdd-fa0037d44894	CODEPECA  I	0497	\N	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	\N	\N	20e6681d-78b9-4d78-8fff-3549a0c294bd	HARENGUS  S.A.	Puerto Madryn		0280-445-0822	\N		\N	\N		t	\N	\N	\N
89f3dbe2-baa3-44d0-aff6-ef52dd653269	CODEPECA  II	0498	\N	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	\N	\N	20e6681d-78b9-4d78-8fff-3549a0c294bd	HARENGUS  S.A.	Puerto Madryn		0280-445-0822	\N		\N	\N		t	\N	\N	\N
7305b457-e0f2-46d0-930b-b30093f09c87	CODEPECA  III	0506	\N	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	\N	\N	20e6681d-78b9-4d78-8fff-3549a0c294bd	HARENGUS  S.A.	Puerto Madryn		0280-445-0822	\N		\N	\N		t	\N	\N	\N
722eba4e-d939-4e64-af13-bff3485fa88c	CODEPECA IV	01012	\N	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	\N	\N	20e6681d-78b9-4d78-8fff-3549a0c294bd	PEREIRA  ARGENTINA  S.A.	Puerto Madryn		0280-445-7377 / 447-2249	\N		\N	\N		t	\N	\N	\N
38a88693-066c-4916-97b3-c2bae7fac599	COMANDANTE LUIS PIEDRABUENA	0767	1340	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	25.00	501	37a047f1-e311-4664-b056-6f4311757b33	COMANDANTE PIEDRABUENA  S.R.L.	Mar del Plata		489-9404	\N		\N	\N		t	\N	\N	\N
07e44f1e-0f3d-4bee-9a86-a63b03feb319	COMETA	0919	\N	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	\N	\N	37a047f1-e311-4664-b056-6f4311757b33	VICARP  S.A.	Mar del Plata		480-4378	\N		\N	\N		t	\N	\N	\N
d7158a8e-6b93-4a30-b004-7409d021bcb2	CONARA I	0201	\N	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	\N	\N	20e6681d-78b9-4d78-8fff-3549a0c294bd	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
30ed84a3-464e-41fd-ad2b-d44afb4b70bd	CONARPESA I	0200	1344	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	52.50	1482	20e6681d-78b9-4d78-8fff-3549a0c294bd	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
303e902d-a9b5-4370-8dc7-f587e23e32b9	CORAJE	0645	1359	\N	\N	\N	0	28.28	426	37a047f1-e311-4664-b056-6f4311757b33	IBERCONSA  DE ARGENTINA  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
6e7d7aa4-e5a7-477f-9ea7-3ecdf97eb963	CORAL  AZUL	06127	\N	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	\N	\N	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	NOVAMAR  S.A.	Ciudad Autónoma de Buenos Aires		011-4345-6688	\N		\N	\N		t	\N	\N	\N
2c662f57-6a58-4982-8a0e-ad7f7b02c068	CORAL BLANCO	06137	\N	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	\N	\N	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	NOVAMAR  S.A.	Ciudad Autónoma de Buenos Aires		011-4345-6688	\N		\N	\N		t	\N	\N	\N
5ce69f01-2f88-4d7d-9f24-68acd25bc07d	CORMORAN	01611	\N	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	\N	\N	37a047f1-e311-4664-b056-6f4311757b33	ANTONIO BARILLARI  S.A.	Mar del Plata		481-1173  / 489-0872	\N		\N	\N		t	\N	\N	\N
ab45acbd-ea29-4f53-a618-b4eeb2c2378b	COSTAMAR	01549	\N	4bcfaa2a-1a55-4c30-8256-bc499d7d07dc	95280ce6-e001-4c71-9c64-3994bf8beb53	\N	4	\N	\N	a68c150f-2d39-40d2-a693-9d1b15859f5f	INDUSTRIA  PESQUERA  PATAGONICA  S.A.	Trelew		0280-444-6577	\N		\N	\N		t	\N	\N	\N
795df3b5-38bc-4b1d-badf-e5b78d167a53	CRISTO REDENTOR	01185	1374	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	31.00	642	be29702b-a6a9-434d-8eb3-5705e0f7468f	PESQUERA DESEADO  S.A.	Puerto Deseado		0297-487-0884 / 0327 / 2407	\N		\N	\N		t	\N	\N	\N
0be36b65-e92d-4e66-92b4-a74f48079248	DASA 508	0499	\N	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	\N	\N	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	PESQUERA  DONGAH  ARGENTINA  S.A.	Ciudad Autónoma de Buenos Aires		011-4815-5525	\N		\N	\N		t	\N	\N	\N
8d21bc9c-b5e8-46a2-96e0-e3ca5062b15f	DASA 757	02200	\N	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	\N	\N	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	PESQUERA  DONGAH  ARGENTINA  S.A.	Ciudad Autónoma de Buenos Aires		011-4815-5525	\N		\N	\N		t	\N	\N	\N
21ed666d-0baa-4cc7-9bfa-92ae380bbe66	DEMOSTENES	0113	\N	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	\N	\N	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	AGUA MARINA  S.A.	Ciudad Autónoma de Buenos Aires		011-4342-0605 / 5656 / 1709	\N		\N	\N		t	\N	\N	\N
efdb0009-e9ae-4acf-b0b9-fb9926ecda6c	DESTINY	3209	\N	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	\N	\N	\N	WANCHESE ARGENTINA  S.A.				\N		\N	\N		t	\N	\N	\N
47349091-52fe-4d58-aa96-7380e65f6e0a	DEPASUR  I	0330	\N	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	\N	\N	20e6681d-78b9-4d78-8fff-3549a0c294bd	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
50f0b959-67cd-41d6-b8e4-95692325ca28	DEPEMAS 51	0239	\N	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	\N	\N	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	DEPEMAS  S.A.	Ciudad Autónoma de Buenos Aires		011-4372-7909  /  4382-5382	\N		\N	\N		t	\N	\N	\N
2af29de8-7084-414d-ace9-cd10a9a40036	DEPEMAS 81	0281	\N	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	\N	\N	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	PESQUERA ORION  S.A.	Ciudad Autónoma de Buenos Aires		011-4343-9327	\N		\N	\N		t	\N	\N	\N
33304861-ba19-4cec-8407-ed773b6c7ec5	DESAFIO	0177	1398	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	29.56	850	37a047f1-e311-4664-b056-6f4311757b33	PESQUERA VERAZ  S.A.	Mar del Plata		489-4624 / 489-0314 (astillero)	\N		\N	\N		t	\N	\N	\N
63f23d35-2de5-4836-88d4-107da846f7f8	DESEADO	01598	1400	4bcfaa2a-1a55-4c30-8256-bc499d7d07dc	95280ce6-e001-4c71-9c64-3994bf8beb53	\N	4	19.00	301	a68c150f-2d39-40d2-a693-9d1b15859f5f	FLOTA AMARILLA RAWSON	Rawson			\N		\N	\N		t	\N	\N	\N
69696019-d0b1-4145-85a7-165cc2845e15	DIEGO PRIMERO	01725	\N	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	\N	\N	37a047f1-e311-4664-b056-6f4311757b33	PESQUERA DIEGO PRIMERO  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
c72b3e15-cb50-4306-83ec-cdd566df47b7	DON JUAN ALVAREZ	3300	\N	718d7348-2d48-40ef-a45a-cb871e408425	95280ce6-e001-4c71-9c64-3994bf8beb53	\N	\N	\N	\N	\N	CONARPESA  S.A.				\N		\N	\N		t	\N	\N	\N
5cf4daad-4f3e-4079-b9cf-e15fac711089	DON  NATALIO	01183	\N	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	\N	\N	37a047f1-e311-4664-b056-6f4311757b33	14 DE JULIO  S.A.	Mar del Plata		480-3545	\N		\N	\N		t	\N	\N	\N
128d8201-ed11-461d-a34d-3b9ba220793c	DON AGUSTIN	0968	\N	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	\N	\N	37a047f1-e311-4664-b056-6f4311757b33	PESQUERA  MARGARITA  S.A.	Mar del Plata		489-4645   /   489-2946	\N		\N	\N		t	\N	\N	\N
dd524919-4eed-4997-afbc-ddc3a206c3cf	DON ANTONIO	0029	1411	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	27.80	549	37a047f1-e311-4664-b056-6f4311757b33	GIORNO  S.A.	Mar del Plata		410-0051 / 0057	\N		\N	\N		t	\N	\N	\N
4f965e88-ddae-464e-9d8a-04d8a9597362	DON CARMELO	01320	1416	4bcfaa2a-1a55-4c30-8256-bc499d7d07dc	95280ce6-e001-4c71-9c64-3994bf8beb53	\N	8	19.04	424	37a047f1-e311-4664-b056-6f4311757b33	MARFE  S.A.	Mar del Plata	4800005	480-0102	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
a62612fe-26c1-412b-9736-4ceb54a9bca5	DON CAYETANO	0579	1417	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	47.10	1503	37a047f1-e311-4664-b056-6f4311757b33	PEDRO MOSCUZZA e HIJOS  S.A.	Mar del Plata	4890960	489-7287	\N	agencia@maritimavidal.com.ar	\N	\N	Agencia Maritima Vidal	t	\N	\N	\N
b6244670-0c01-489d-b59e-7f15c5cfbf52	DON FRANCISCO I	2562	1428	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	66.55	1776	37a047f1-e311-4664-b056-6f4311757b33	EL MARISCO  S.A.	Mar del Plata	480-7779 - HERNAN	489-0384	\N	agenciasenoransmdp@yahoo.com	\N	\N	Agencia Maritima SEÑORANS	t	\N	\N	\N
d1e7c1b9-fce2-41dd-af6b-4a1c1fef1101	DON GAETANO	071	1430	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	32.10	889	37a047f1-e311-4664-b056-6f4311757b33	LINEAERRE  S.A.	Mar del Plata		480-0312	\N		\N	\N		t	\N	\N	\N
ab663d77-f551-4ada-bf2a-9ad7dc802b10	DON GIULIANO	02025	1431	4bcfaa2a-1a55-4c30-8256-bc499d7d07dc	95280ce6-e001-4c71-9c64-3994bf8beb53	\N	4	17.10	220	a68c150f-2d39-40d2-a693-9d1b15859f5f	FLOTA AMARILLA RAWSON	Rawson			\N		\N	\N		t	\N	\N	\N
19b8a23d-cb6f-45e5-a041-076b6949161e	DON JOSE	00892	1434	4bcfaa2a-1a55-4c30-8256-bc499d7d07dc	95280ce6-e001-4c71-9c64-3994bf8beb53	\N	8	16.49	269	37a047f1-e311-4664-b056-6f4311757b33	VENTO DI TERRA  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
6749d076-e786-4a02-a67c-584c163861f6	DON JOSE DI BONA	02241	1435	4bcfaa2a-1a55-4c30-8256-bc499d7d07dc	95280ce6-e001-4c71-9c64-3994bf8beb53	\N	4	19.85	301	a68c150f-2d39-40d2-a693-9d1b15859f5f	PROA  AL SUR  S.R.L.	Rawson			\N		\N	\N		t	\N	\N	\N
8052b039-36a4-493f-8e0d-e2b455fa92f3	DON JUAN	01397	1437	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	27.00	425	\N	PESQUERA DON JUAN  S.A.				\N		\N	\N		t	\N	\N	\N
fc020464-f32d-495a-af94-41150103ea8b	DON JUAN D´AMBRA	5174	\N	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	\N	\N	37a047f1-e311-4664-b056-6f4311757b33	PESCA ANGELA  S.A.	Mar del Plata		626-2236 /37	\N		\N	\N		t	\N	\N	\N
ba107b0d-249f-4fd7-a6f3-9a4d542037ae	DON LUCIANO	069	\N	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	\N	\N	37a047f1-e311-4664-b056-6f4311757b33	TATURIELLO  S.A.	Mar del Plata		489-3833	\N		\N	\N		t	\N	\N	\N
72f182ca-e84f-464e-9bd0-01039544a69f	DON LUIS I	02093	1445	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	67.95	1803	37a047f1-e311-4664-b056-6f4311757b33	PESQUERA CERES  S.A.	Mar del Plata		410-0051 / 7	\N		\N	\N		t	\N	\N	\N
3d77cafa-52dd-48a2-981e-395199497b48	DON MIGUEL 1°	0748	\N	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	\N	\N	37a047f1-e311-4664-b056-6f4311757b33	PESQUERA EL NAZARENO	Mar del Plata	4895032 Emanuel	489-9414 (of. Pers. Emb.)	\N	operacionesconsultoramaritima@gmail.com	\N	\N	Consultora Maritima Merlini	t	\N	\N	\N
b385570f-9c04-4baa-a28d-01e89d676e99	DON NICOLA	0893	1450	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	28.14	856	37a047f1-e311-4664-b056-6f4311757b33	PEZ ESPADA  S.A.	Mar del Plata		480-0846	\N		\N	\N		t	\N	\N	\N
6fca902a-8ccb-4e9f-a61a-e54e387fb261	DON OSCAR	02184	\N	4bcfaa2a-1a55-4c30-8256-bc499d7d07dc	95280ce6-e001-4c71-9c64-3994bf8beb53	\N	4	\N	\N	a68c150f-2d39-40d2-a693-9d1b15859f5f	FLOTA AMARILLA RAWSON	Rawson	4800005		\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
f7a6eabd-57fe-4ea3-a5c8-3076b1d4364a	DON PEDRO	068	\N	5f917487-3b4d-4cec-ac8b-6f549a1ce217	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	60	\N	\N	37a047f1-e311-4664-b056-6f4311757b33	PEDRO MOSCUZZA e HIJOS  S.A.	Mar del Plata		489-7287	\N		\N	\N		t	\N	\N	\N
2a55e2d3-09ad-4cc8-be91-849c456fd5bf	DON RAIMUNDO	01431	1463	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	10	25.60	624	37a047f1-e311-4664-b056-6f4311757b33	DON RAIMUNDO S.R.L.	Mar del Plata		489-3780	\N		\N	\N		t	\N	\N	\N
70ee6a3d-e3ab-4e68-bca2-a7969797ad48	DON ROMEO ERSINI	0972	\N	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	\N	\N	37a047f1-e311-4664-b056-6f4311757b33	PESQUERA  MARGARITA  S.A.	Mar del Plata	4891553-154179360-154179860-154179062	489-4645   /   489-2946	\N	agenciasmiriglio@speedy.com.ar	\N	\N	Agencia Smiriglio	t	\N	\N	\N
19aff04c-20a7-49b0-9a10-931cd3264acf	DON SANTIAGO	01733	1467	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	10	26.55	776	37a047f1-e311-4664-b056-6f4311757b33	SAN JORGE S.A.	Mar del Plata		480-6611	\N		\N	\N		t	\N	\N	\N
7a42b2be-8f92-4807-af72-fcf6600261c2	DON TOMASSO	02310	1468	4bcfaa2a-1a55-4c30-8256-bc499d7d07dc	95280ce6-e001-4c71-9c64-3994bf8beb53	\N	4	17.00	356	a68c150f-2d39-40d2-a693-9d1b15859f5f	FLOTA AMARILLA RAWSON	Rawson			\N		\N	\N		t	\N	\N	\N
ff296925-afdc-43a6-af66-cf2b4d0ca20d	DON TURI	01540	1470	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	28.62	839	37a047f1-e311-4664-b056-6f4311757b33	DON TURI  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
b951d925-0319-48ef-b0dc-1c8fbadb382a	DON VICENTE VUOSO	0539	1474	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	20.69	537	37a047f1-e311-4664-b056-6f4311757b33	VUOSO HNOS. S.R.L.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
61977d7b-a411-41da-86c3-1a41080d8750	DOÑA ALFIA	0512	1483	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	20.70	426	37a047f1-e311-4664-b056-6f4311757b33	ANTONIO BARILLARI  S.A.	Mar del Plata		481-1173  / 489-0872	\N		\N	\N		t	\N	\N	\N
06fe583b-cde4-4b65-b226-903d5be355f8	Dr. EDUARDO L. HOLMBERG	061F	\N	201b037d-1ab0-4fb9-92aa-c9af3cff2044	\N	\N	24	\N	\N	37a047f1-e311-4664-b056-6f4311757b33	INIDEP	Mar del Plata		451-7442 ó 486-2586 int 162	\N		\N	\N		t	\N	\N	\N
b00375b1-e900-443b-9607-700315b6073c	DUKAT	02775	2712	e72ee47d-c05e-422b-b740-59668cc58a73	4c123cf5-3119-4c6e-97c9-f6f6dfaf79de	1f6e6d84-215f-48d5-b131-5fe9f3e631da	30	50.80	1302	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	CRUSTACEOS DEL SUR  S.A.	Ciudad Autónoma de Buenos Aires		011-5218-4287	\N		\N	\N		t	\N	\N	\N
a2be240a-9024-4471-9e79-76a93c9e7a8d	ECHIZEN MARU	0326	1495	3c4c96c7-1ccb-437d-8cb4-ec87500da20d	95280ce6-e001-4c71-9c64-3994bf8beb53	61617027-3911-4e52-91ac-c8612dac86c9	60	89.59	4702	60cc1963-ba0f-4f37-ac75-cd04fdcd2ade	PESANTAR  S.A. ( Empresa Pesq de la Patagonia y Antartida )	Ushuaia		02901-43-3449 / 43-0008 / 43-0708	\N		\N	\N		t	\N	\N	\N
40bce663-fcaf-49aa-b224-ad0275d93d27	EL MALO I	02350	\N	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	4	\N	\N	a68c150f-2d39-40d2-a693-9d1b15859f5f	NOGALES NOGALES  S. De HECHO	Rawson	4890960		\N	agencia@maritimavidal.com.ar	\N	\N	Agencia Maritima Vidal	t	\N	\N	\N
b9ffbfbd-81af-4089-a709-23235d36f522	EL MARISCO I	0912	1516	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	27.22	426	37a047f1-e311-4664-b056-6f4311757b33	EL MARISCO  S.A.	Mar del Plata	4890960	489-0384	\N	agencia@maritimavidal.com.ar	\N	\N	Agencia Maritima Vidal	t	\N	\N	\N
3d9e3adf-3108-4a2d-81ad-6af2aa31328b	EL MARISCO II	0915	1517	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	56.30	1407	37a047f1-e311-4664-b056-6f4311757b33	EL MARISCO  S.A.	Mar del Plata		489-0384	\N		\N	\N		t	\N	\N	\N
456926b9-38a4-43a3-a8fd-a54d78807e9e	EL SANTO	05970	\N	4bcfaa2a-1a55-4c30-8256-bc499d7d07dc	95280ce6-e001-4c71-9c64-3994bf8beb53	\N	0	\N	\N	be29702b-a6a9-434d-8eb3-5705e0f7468f	VUOGAFE  S.A.	Puerto Deseado		0297-155-940853	\N		\N	\N		t	\N	\N	\N
314499b4-8c41-485b-a70f-9742be7ba591	EMILIA MARIA	01390	1543	4bcfaa2a-1a55-4c30-8256-bc499d7d07dc	95280ce6-e001-4c71-9c64-3994bf8beb53	\N	10	22.60	521	37a047f1-e311-4664-b056-6f4311757b33	COSTA BRAVA  S.A.	Mar del Plata		489-7538	\N		\N	\N		t	\N	\N	\N
c542b45c-957e-40ec-8236-b8ac5e199cfb	EMPESUR II	01439	\N	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	\N	\N	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	EMPESUR  S.A.	Ciudad Autónoma de Buenos Aires		011-4312-0123	\N		\N	\N		t	\N	\N	\N
6b0a9581-1d60-4439-b9ec-1c4e1eecf28f	EMPESUR III	01438	\N	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	\N	\N	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	EMPESUR  S.A.	Ciudad Autónoma de Buenos Aires		011-4312-0123	\N		\N	\N		t	\N	\N	\N
3b54cfd3-c902-435c-959e-ca43a8200624	EMPESUR V	02650	2705	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	30.52	1369	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	EMPESUR  S.A.	Ciudad Autónoma de Buenos Aires		011-4312-0123	\N		\N	\N		t	\N	\N	\N
7dc2c1f1-64e5-4a17-9f1f-0ffacddc379f	EMPESUR VI	02983	2749	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	35.03	1289	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	EMPESUR  S.A.	Ciudad Autónoma de Buenos Aires		011-4312-0123	\N		\N	\N		t	\N	\N	\N
47cd0ef1-c8b2-455e-a5e5-a34df79e32f2	EMPESUR VII	03045	2754	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	35.03	1290	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	EMPESUR  S.A.	Ciudad Autónoma de Buenos Aires		011-4312-0123	\N		\N	\N		t	\N	\N	\N
0f4c52e4-ffbf-409e-9042-cea642d47a43	El marisco s.a	02070	\N	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	\N	\N	20e6681d-78b9-4d78-8fff-3549a0c294bd	FISHING WORLD  S.A.	Puerto Madryn	4800005	0280-445-6533	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
d2ab5ace-eca3-4d05-9929-c0297a21591e	ENTRENA UNO	02069	1551	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	33.10	839	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	FOOD ARTS  S.A.	Ciudad Autónoma de Buenos Aires		POR MAILlazuaje@foodarts.com.ar	\N		\N	\N		t	\N	\N	\N
e900dd86-641b-4a2b-af55-dfe9be74ac90	ERIN BRUCE	0537	1553	627a88cb-bf97-434f-bfab-4ef3339c44d3	7bf053fd-02b7-4f5f-954e-61b3668f9611	bdb064e1-c2c3-4e77-ac2a-64dc9bd12fbf	30	53.60	2252	37a047f1-e311-4664-b056-6f4311757b33	WANCHESE ARGENTINA  S.A.	Mar del Plata		489-1236	\N		\N	\N		t	\N	\N	\N
29173488-2c4c-4c8d-9d91-e68cfda67140	ERIN BRUCE II	TEMP-0002	\N	627a88cb-bf97-434f-bfab-4ef3339c44d3	7bf053fd-02b7-4f5f-954e-61b3668f9611	bdb064e1-c2c3-4e77-ac2a-64dc9bd12fbf	\N	\N	\N	\N					\N		\N	\N		t	\N	\N	\N
2a88e6fb-ca00-4f32-bad5-6f1b929fc2a5	ESAMAR N° 4	0467	\N	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	\N	\N	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	ESAMAR  S.A.	Ciudad Autónoma de Buenos Aires		011-4393-8431	\N		\N	\N		t	\N	\N	\N
4f7284cf-d5d4-4fbc-ae1c-9d1007bea23e	ESPADARTE	02048	1558	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	68.20	1529	be29702b-a6a9-434d-8eb3-5705e0f7468f	PESQUERA DESEADO  S.A.	Puerto Deseado		0297-487-0884 / 0327 / 2407	\N		\N	\N		t	\N	\N	\N
df99817b-c82c-4a2b-b4c3-b072e397e0e1	ESPERANZA 909	02577	1559	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	72.34	1678	37a047f1-e311-4664-b056-6f4311757b33	CHIARPESCA  S.A.	Mar del Plata		489-1385	\N		\N	\N		t	\N	\N	\N
8c1aa503-1036-4799-a3f5-6e6980db4b1b	ESPERANZA DEL SUR	02751	\N	3d12af20-a640-4760-a148-43da27100340	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	60	\N	\N	60cc1963-ba0f-4f37-ac75-cd04fdcd2ade	PESANTAR  S.A. ( Empresa Pesq de la Patagonia y Antartida )	Ushuaia		02901-43-3449 / 43-0008 / 43-0708	\N		\N	\N		t	\N	\N	\N
3770ad14-da04-4537-9987-531501e1ec68	ESPERANZA DOS	06264	\N	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	\N	\N	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	ESPERANZA DEL MAR  S.A.	Ciudad Autónoma de Buenos Aires		011-4328-8696	\N		\N	\N		t	\N	\N	\N
25cf4684-c54a-42b7-afc2-47592481c940	ESPERANZA UNO	06113	\N	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	\N	\N	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	ESPERANZA DEL MAR  S.A.	Ciudad Autónoma de Buenos Aires		011-4328-8696	\N		\N	\N		t	\N	\N	\N
fec8cf2e-0e72-4cb4-990c-2a755216cf45	ESTEFANY	001	1565	4bcfaa2a-1a55-4c30-8256-bc499d7d07dc	95280ce6-e001-4c71-9c64-3994bf8beb53	\N	15	23.60	530	37a047f1-e311-4664-b056-6f4311757b33	GIORNO  S.A.	Mar del Plata		410-0051 / 0057	\N		\N	\N		t	\N	\N	\N
fc4eb1fd-8882-4775-8236-8c821d2b7c7a	ESTEIRO	6328	\N	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	\N	\N	37a047f1-e311-4664-b056-6f4311757b33	BALDIMAR  S.A.	Mar del Plata		489-6522	\N		\N	\N		t	\N	\N	\N
8953a714-6302-44e9-924d-5c5e0f84ccf9	ESTHER 153	02058	1568	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	55.10	1252	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	ARPEPA  M.C.I.S.A.	Ciudad Autónoma de Buenos Aires		011-4382-1605	\N		\N	\N		t	\N	\N	\N
cb0e3f20-b6e1-45b4-9395-06b8a46597a2	ESTRELLA N° 5	0246	1575	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	54.20	1601	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	HANSUNG AR  S.A.	Ciudad Autónoma de Buenos Aires		011-4816-2022	\N		\N	\N		t	\N	\N	\N
59e5c784-15c7-4cd1-8c6f-fa208156904c	ESTRELLA N° 6	012	1576	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	55.85	1581	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	HANSUNG AR  S.A.	Ciudad Autónoma de Buenos Aires		011-4816-2022	\N		\N	\N		t	\N	\N	\N
f3b437cc-dc63-471d-93f3-53b85a7204bb	ESTRELLA N° 8	0242	\N	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	\N	\N	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	HANSUNG AR  S.A.	Ciudad Autónoma de Buenos Aires		011-4816-2022	\N		\N	\N		t	\N	\N	\N
16e17b64-c3d5-4a44-8401-b78b5bb04373	FE EN PESCA	0226	\N	\N	\N	\N	0	\N	\N	37a047f1-e311-4664-b056-6f4311757b33	ASARO HNOS.  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
e1b68658-5585-4126-a76e-abb17ba79253	FEDERICO C	3190	2776	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	\N	37.68	1400	\N	PESQUERA VERAZ  S.A.				\N		\N	\N		t	\N	\N	\N
f9c93ebc-108c-4fb7-a6ae-e18780197bde	FEIXA	0529	1592	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	41.50	1101	37a047f1-e311-4664-b056-6f4311757b33	ANTONIO BARILLARI  S.A.	Mar del Plata		481-1173  / 489-0872	\N		\N	\N		t	\N	\N	\N
60b86c97-0269-4f51-af38-8776c97cc98f	FELIX AUGUSTO	0581	1595	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	27.80	601	20e6681d-78b9-4d78-8fff-3549a0c294bd	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
e67f2a0c-6347-4373-b499-0206fffe1793	FERNANDO ALVAREZ	0013	1597	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	36.60	1168	20e6681d-78b9-4d78-8fff-3549a0c294bd	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
7c45f642-1d4e-4a78-b8f3-ef924212a799	FLORIDABLANCA	0969	1606	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	27.67	541	37a047f1-e311-4664-b056-6f4311757b33	DESAFIO  S.A.	Mar del Plata		489-4788 / 3659	\N		\N	\N		t	\N	\N	\N
c6c28b88-2177-462f-8619-b0534a095079	FLORIDABLANCA II	0252	\N	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	\N	\N	20e6681d-78b9-4d78-8fff-3549a0c294bd	PESQUERA SAN ISIDRO S.A.	Puerto Madryn		0280-447-2697	\N		\N	\N		t	\N	\N	\N
8160c3c9-6b8d-4652-aeea-602c3acdf938	FLORIDABLANCA IV	0255	\N	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	\N	\N	b06cb245-db92-471b-a70e-f741a6593708	MARITIMA MONACHESI  S.A.	Bahia Blanca		0291-452-5913	\N		\N	\N		t	\N	\N	\N
0854fb6d-1c4e-4492-b6ff-776ea041ade3	FONSECA	0920	1610	5f917487-3b4d-4cec-ac8b-6f549a1ce217	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	60	62.40	2003	37a047f1-e311-4664-b056-6f4311757b33	FONSECA  S.A.	Mar del Plata	4891553-154179360-154179860-154179062	489-4645	\N	agenciasmiriglio@speedy.com.ar	\N	\N	Agencia Maritima Smiriglio	t	\N	\N	\N
1a9177d4-ebbe-4b53-a6bd-deb8ddf6ef79	FRANCA	0495	1612	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	27.29	493	37a047f1-e311-4664-b056-6f4311757b33	AUGUSTA MEGARA  S.A.	Mar del Plata		480-2260	\N		\N	\N		t	\N	\N	\N
ac409c46-640d-41a2-8b03-e07f1bef54d5	FRANCO	01458	\N	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	\N	\N	37a047f1-e311-4664-b056-6f4311757b33	FRIGORIFICO DON LUIS  S.R.L.	Mar del Plata		489-4645	\N		\N	\N		t	\N	\N	\N
9f297cea-c640-4248-9c31-a70b396cac9f	FU YUAN YU 636	02195	\N	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	\N	\N	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	BAHIA GRANDE  S.A.	Ciudad Autónoma de Buenos Aires		011-5272-0850 / 5254-1133	\N		\N	\N		t	\N	\N	\N
58eeba25-0cad-40d0-a4f6-97d3ba600ca7	FUEGUINO I	0331	\N	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	\N	\N	20e6681d-78b9-4d78-8fff-3549a0c294bd	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
3ab84189-33e7-4b98-a664-d5c94066bb56	GALA	02722	0	4bcfaa2a-1a55-4c30-8256-bc499d7d07dc	95280ce6-e001-4c71-9c64-3994bf8beb53	\N	15	15.20	256	37a047f1-e311-4664-b056-6f4311757b33	DISTRIBUIDORA MARECHIARE S.R.L.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
824abf6f-d317-4739-9ce1-8803bbe620f7	GALEMAR	0904	\N	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	\N	\N	37a047f1-e311-4664-b056-6f4311757b33	ANTONIO BARILLARI  S.A.	Mar del Plata		481-1173  / 489-0872	\N		\N	\N		t	\N	\N	\N
82a6c2f1-2b10-4330-a069-885e59c099c1	GAUCHO GRANDE	0339	1642	\N	\N	\N	30	27.64	0	37a047f1-e311-4664-b056-6f4311757b33	VICARP  S.A.	Mar del Plata	4890960	480-4378	\N	agencia@maritimavidal.com.ar	\N	\N	Agencia Maritima Vidal	t	\N	\N	\N
9fe27daa-eac2-4402-944f-e75aba80cea9	GEMINIS	01421	1643	5f917487-3b4d-4cec-ac8b-6f549a1ce217	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	60	68.90	2141	37a047f1-e311-4664-b056-6f4311757b33	PESQUERA GEMINIS  S.A.	Mar del Plata		410-0051 / 7	\N		\N	\N		t	\N	\N	\N
0eafb186-a67a-438c-8975-719d24f31190	GIANFRANCO	01075	\N	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	\N	\N	37a047f1-e311-4664-b056-6f4311757b33	PIEA  S.A.	Mar del Plata		489-6317 /489-1367	\N		\N	\N		t	\N	\N	\N
6f7b7fbc-1643-460a-b781-97e0cf6df39c	GIULIANA	02633	\N	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	\N	\N	37a047f1-e311-4664-b056-6f4311757b33	PESQUERA  MARGARITA  S.A.	Mar del Plata		489-4645   /   489-2946	\N		\N	\N		t	\N	\N	\N
5eed88fa-418e-4811-9f8c-e83328382661	GLORIA DEL MAR I	01983	1651	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	54.30	1600	37a047f1-e311-4664-b056-6f4311757b33	PESQUERA  DEL  ESTE  S.A.	Mar del Plata	4800005	489-1567	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
ad1fe80e-a5e2-4e22-9d8e-62f322853bc0	GRACIELA	0578	\N	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	\N	\N	37a047f1-e311-4664-b056-6f4311757b33	PEDRO MOSCUZZA e HIJOS  S.A.	Mar del Plata		489-7287	\N		\N	\N		t	\N	\N	\N
8d598b63-a3b5-4909-a279-b4504e70cea4	GRACIELA I	3994	2765	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	39.94	0	37a047f1-e311-4664-b056-6f4311757b33	PEDRO MOSCUZZA e HIJOS  S.A.	Mar del Plata		489-7287	\N		\N	\N		t	\N	\N	\N
95918bbb-439b-4073-96fc-ad266a6838e3	GRAN CAPITAN	01538	1656	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	25.43	541	37a047f1-e311-4664-b056-6f4311757b33	ORTIGIA  S.A.	Mar del Plata		489-2679	\N		\N	\N		t	\N	\N	\N
f14b326a-b8bd-476c-8744-8198599e4b5b	GURISES	01386	1667	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	25.20	546	37a047f1-e311-4664-b056-6f4311757b33	A.B.H. PESQUERA  S.A.	Mar del Plata		489-6522	\N		\N	\N		t	\N	\N	\N
72b3533a-4473-41dc-be78-241f1c29e7d7	GUSTAVO R	0075	\N	5f917487-3b4d-4cec-ac8b-6f549a1ce217	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	60	\N	\N	37a047f1-e311-4664-b056-6f4311757b33	ARGEMER  S.A.	Mar del Plata		451-1247	\N		\N	\N		t	\N	\N	\N
62418e5a-dddf-45fc-b51b-2a95ecab1e66	HAMAZEN MARU N° 68	JA05	\N	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	\N	\N	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	PESQUERA SANTA CRUZ  S.A.	Ciudad Autónoma de Buenos Aires		011-4305-4706	\N		\N	\N		t	\N	\N	\N
04897734-47c9-4057-aec2-3d2a91503133	HAMPON	01410	1673	4bcfaa2a-1a55-4c30-8256-bc499d7d07dc	95280ce6-e001-4c71-9c64-3994bf8beb53	\N	10	18.99	497	37a047f1-e311-4664-b056-6f4311757b33	PESQUERA HAMPON S.R.L	Mar del Plata			\N		\N	\N		t	\N	\N	\N
9c29b8a6-5978-4306-b3d6-928079780599	HARENGUS	0510	\N	5f917487-3b4d-4cec-ac8b-6f549a1ce217	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	60	\N	\N	20e6681d-78b9-4d78-8fff-3549a0c294bd	HARENGUS  S.A.	Puerto Madryn		0280-445-0822	\N		\N	\N		t	\N	\N	\N
51fc1d9c-c58d-4c5d-83be-a47fd1cacb54	HOKO 31	05934	\N	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	\N	\N	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	FARO DEL SUR TRADING  S.A.	Ciudad Autónoma de Buenos Aires		011-4555-4956	\N		\N	\N		t	\N	\N	\N
4f1cc339-522a-4fd7-9e56-c5ca0515c429	HOPE N°7	06130	1690	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	50.60	1235	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	ALUNAMAR  S.A.	Ciudad Autónoma de Buenos Aires	4808331/4808332	011-4382-4194	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
b64c9d9f-cf9e-42e6-9aa0-3bfe45268906	HOYO MARU 37	JA01	\N	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	\N	\N	be29702b-a6a9-434d-8eb3-5705e0f7468f	ARGENOVA  S.A.	Puerto Deseado		0297- 487-0550  (447-2818  Com. Riv )	\N		\N	\N		t	\N	\N	\N
5466f29b-f977-438c-9a17-c1ec149a301f	HSIANG LAI FU	80	\N	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	\N	\N	37a047f1-e311-4664-b056-6f4311757b33	EL MARISCO  S.A.	Mar del Plata		489-0384	\N		\N	\N		t	\N	\N	\N
018d5147-4d20-45ec-a14f-e174d98f45c5	HUYU 961	TEMP-0003	0	\N	\N	\N	\N	65.70	0	\N					\N		\N	\N		t	\N	\N	\N
53e0c2e5-0460-4eff-be7f-267194bf6671	HUYU 962	03056	0	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	65.60	0	20e6681d-78b9-4d78-8fff-3549a0c294bd	ALTAMARE  S.A.	Puerto Madryn		0280-445-7377 / 447-2249	\N		\N	\N		t	\N	\N	\N
ef4fa1e0-7e61-4085-bfd3-e5bddb14b386	HUYU 906	03026	2747	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	65.92	1579	37a047f1-e311-4664-b056-6f4311757b33	CHENG I  S.A.	Mar del Plata		489-1385	\N		\N	\N		t	\N	\N	\N
21894e89-7aa5-4ab9-82d5-fcfc4ef29b75	HUYU 907	03027	2748	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	72.17	1678	37a047f1-e311-4664-b056-6f4311757b33	CHENG I  S.A.	Mar del Plata	4800005	489-1385	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
223d1a95-a02d-4613-94b4-6596eb55f40a	HU YU 910	81	\N	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	\N	\N	37a047f1-e311-4664-b056-6f4311757b33	PEDRO MOSCUZZA e HIJOS  S.A.	Mar del Plata		489-7287	\N		\N	\N		t	\N	\N	\N
0882d50e-c333-465f-8f14-d056d704913f	HUAFENG 801	3013	2741	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	65.04	1973	37a047f1-e311-4664-b056-6f4311757b33	ARDAPEZ  S.A.	Mar del Plata		480-1561 / 480-1568 / 480-1549	\N		\N	\N		t	\N	\N	\N
e6a14af6-f759-4a44-a3fb-2ac9a6521e59	HUAFENG 802	3014	2751	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	65.04	1973	37a047f1-e311-4664-b056-6f4311757b33	ARDAPEZ  S.A.	Mar del Plata		480-1561 / 480-1568 / 480-1549	\N		\N	\N		t	\N	\N	\N
d335e855-6c29-4f57-b03a-c8680d48cdaa	HUA I 616	0392	\N	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	\N	\N	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	ARMADORA  ACRUX  S.A.	Ciudad Autónoma de Buenos Aires		011-4312-6470	\N		\N	\N		t	\N	\N	\N
58f263a2-097a-4a41-8c3d-b223bd938cd2	HUAFENG 815	0554A	0	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	25.28	419	37a047f1-e311-4664-b056-6f4311757b33	PESQUERA CHIARMAR S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
a5daf1e3-4a01-4455-b858-aa75743bf951	HUAFENG 820 (ex INFINITUS PEZ)	01472A	\N	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	\N	\N	37a047f1-e311-4664-b056-6f4311757b33	MELIMAR S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
694b308a-b961-4c14-ba8e-5b14e5c0539c	HUAFENG 821 (ex INITIO PEZ)	01471A	\N	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	\N	\N	37a047f1-e311-4664-b056-6f4311757b33	MELIMAR S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
b9bc0e04-5eda-4a70-96f1-58d1b01dbe1c	IARA	06207	\N	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	\N	\N	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	PESQUERA MADRYN  S.A.	Ciudad Autónoma de Buenos Aires		011-4394-1452	\N		\N	\N		t	\N	\N	\N
072afa82-46ae-4a10-ab4a-0730e728f443	IGLU I	01423	1713	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	32.75	660	37a047f1-e311-4664-b056-6f4311757b33	GIORNO  S.A.	Mar del Plata		410-0051 / 0057	\N		\N	\N		t	\N	\N	\N
c73319ff-36de-4121-a1f1-7454ecf57461	ILLEX I	125	\N	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	\N	\N	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	ILLEX  S.A.	Ciudad Autónoma de Buenos Aires	4808331/4808332	011-4393-6431	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
ef028374-88cb-4e41-afc4-f8a6f1fbd841	INARI MARU N° 25	0261	\N	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	\N	\N	be29702b-a6a9-434d-8eb3-5705e0f7468f	ARGENOVA  S.A.	Puerto Deseado		0297- 487-0550  (447-2818  Com. Riv )	\N		\N	\N		t	\N	\N	\N
3cf162a0-b7a9-487d-9bb1-81ecc4697180	INFINITUS PEZ	01472	\N	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	\N	\N	37a047f1-e311-4664-b056-6f4311757b33	GIORNO  S.A.	Mar del Plata		410-0051 / 0057	\N		\N	\N		t	\N	\N	\N
6cad2a55-e818-4291-9dfb-d0c66be455ee	INITIO PEZ	01471	\N	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	\N	\N	37a047f1-e311-4664-b056-6f4311757b33	GIORNO  S.A.	Mar del Plata	4800005	410-0051 / 0057	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi	t	\N	\N	\N
50b6f8f5-99d3-416f-9fab-2b21f0fa1ee5	ITXAS LUR	0927	1735	5f917487-3b4d-4cec-ac8b-6f549a1ce217	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	60	63.30	1952	37a047f1-e311-4664-b056-6f4311757b33	HISPANO PATAGONICA  S.A.	Mar del Plata		480-1002 / 489-3165 / 489-7144	\N		\N	\N		t	\N	\N	\N
f5a65c9b-b0ea-48a0-8c9f-8d900fa30954	JOLUMA	5403	\N	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	\N	\N	37a047f1-e311-4664-b056-6f4311757b33	ARDAPEZ  S.A.	Mar del Plata	4800005	480-1561 / 480-1568 / 480-1549	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
a54926b3-a19f-4466-9d56-3e207ef63766	JOSÉ AMÉRICO	03071	2756	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	44.21	0	37a047f1-e311-4664-b056-6f4311757b33	PEDRO MOSCUZZA e HIJOS  S.A.	Mar del Plata		489-7287	\N		\N	\N		t	\N	\N	\N
fd0b96f7-78b4-42ae-91a2-65f29bc9018b	JOSE LUIS ALVAREZ	0618	\N	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	\N	\N	20e6681d-78b9-4d78-8fff-3549a0c294bd	PESQUERA SAN ISIDRO S.A.	Puerto Madryn		0280-447-2697	\N		\N	\N		t	\N	\N	\N
03786476-9af3-489a-b701-ed885f7e332b	JOSE MARCELO	3138	2764	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	39.94	0	37a047f1-e311-4664-b056-6f4311757b33	PEDRO MOSCUZZA e HIJOS  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
acd42fac-3a89-4fb0-8dd1-f1ad98c44458	JUAN ALVAREZ	0619	1755	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	36.60	1168	20e6681d-78b9-4d78-8fff-3549a0c294bd	PESQUERA SAN ISIDRO S.A.	Puerto Madryn		0280-447-2697	\N		\N	\N		t	\N	\N	\N
3dac254a-4af6-454c-a557-859ba06bb18d	JUAN PABLO II	02695	0	4bcfaa2a-1a55-4c30-8256-bc499d7d07dc	95280ce6-e001-4c71-9c64-3994bf8beb53	\N	8	22.49	326	\N	ISLA DE LOS ESTADOS  S.A.	Vivoratá			\N		\N	\N		t	\N	\N	\N
9a806daf-e2a6-4660-87e0-48c0b38a7c00	JUDITH I	0908	\N	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	\N	\N	37a047f1-e311-4664-b056-6f4311757b33	ANTONIO BARILLARI  S.A.	Mar del Plata		481-1173  / 489-0872	\N		\N	\N		t	\N	\N	\N
e5fb1a16-194e-4fd1-b579-950cd61871a8	JUEVES SANTO	0667	1762	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	39.50	1244	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	NUVCONSA  S.A.	Ciudad Autónoma de Buenos Aires	4891553-154179360-154179860-154179062	011-4305-4706	\N	agenciasmiriglio@speedy.com.ar	\N	\N	Agencia Maritima Smiriglio	t	\N	\N	\N
2a336728-f06e-4393-9a45-e44ef6d79441	JUPITER II	0406	1769	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	27.90	791	37a047f1-e311-4664-b056-6f4311757b33	VENUS  PESQUERA S.R.L.	Mar del Plata	4800005	489-0186	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
61f82714-7c3b-4e6a-b3c7-ac095ce01bef	KALEU KALEU	01963	\N	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	\N	\N	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	KALEU KALEU  S.A.	Ciudad Autónoma de Buenos Aires	4800005	011-3220-2130  / 5093-1215	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi	t	\N	\N	\N
82ffd6db-6637-42de-b54c-a170af4de790	KANTXOPE	01065	\N	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	\N	\N	37a047f1-e311-4664-b056-6f4311757b33	ANTONIO BARILLARI  S.A.	Mar del Plata		481-1173  / 489-0872	\N		\N	\N		t	\N	\N	\N
82d6310f-21f1-45b1-aea1-a8540ffeb7fb	KARINA	01462	\N	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	\N	\N	37a047f1-e311-4664-b056-6f4311757b33	FRIGORIFICO DON LUIS  S.R.L.	Mar del Plata		489-4645	\N		\N	\N		t	\N	\N	\N
0a361217-6565-4021-aaeb-ba70ea12a3e7	LAIA	06521	0	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	53.00	1185	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	PESQUERA MADRYN  S.A.	Ciudad Autónoma de Buenos Aires		011-4394-1452	\N		\N	\N		t	\N	\N	\N
fc67925e-2810-4f08-89ae-42894d1fe7d5	LANZA SECA	01181	1852	\N	\N	\N	0	24.80	514	37a047f1-e311-4664-b056-6f4311757b33	LANZAMAR  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
b6282231-587b-4315-bd3f-fe3220762f36	LATINA  N° 8	0291	\N	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	\N	\N	be29702b-a6a9-434d-8eb3-5705e0f7468f	ARGENOVA  S.A.	Puerto Deseado		0297- 487-0550  (447-2818  Com. Riv )	\N		\N	\N		t	\N	\N	\N
1f2ebf27-0726-4890-afb8-fc07dcc5b8cf	LEAL	0143	1863	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	27.45	601	37a047f1-e311-4664-b056-6f4311757b33	PESQUERA LEAL  S.A.	Mar del Plata		489-4624 / 489-0314 (astillero )	\N		\N	\N		t	\N	\N	\N
6850e42e-4473-447f-8316-58a1d2e412c0	LEKHAN I	00752	1865	4bcfaa2a-1a55-4c30-8256-bc499d7d07dc	95280ce6-e001-4c71-9c64-3994bf8beb53	\N	8	18.45	530	37a047f1-e311-4664-b056-6f4311757b33	LEKHAN I  S.R.L.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
60bcd875-929e-458d-bde1-cf1ad2d764bf	LETARE	0245	\N	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	\N	\N	37a047f1-e311-4664-b056-6f4311757b33	LUIS SOLIMENO e HIJOS  S.A.	Mar del Plata		489-3030	\N		\N	\N		t	\N	\N	\N
578f930b-7d10-41ef-afb3-f9a703150232	LIBERTAD DEL MAR 1°	02186	\N	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	\N	\N	37a047f1-e311-4664-b056-6f4311757b33	TATURIELLO  S.A.	Mar del Plata		489-3833	\N		\N	\N		t	\N	\N	\N
66a783e2-09b1-4464-880c-d4aaebdc30c6	LING SHUI N° 3	02210	\N	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	\N	\N	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	MUELLE OCHO  S.A.	Ciudad Autónoma de Buenos Aires		011-4381-1337	\N		\N	\N		t	\N	\N	\N
860f9694-63ee-4bba-90db-c57f14bbc48e	LING SHUI N° 5	02211	\N	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	\N	\N	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	MUELLE OCHO  S.A.	Ciudad Autónoma de Buenos Aires		011-4381-1337	\N		\N	\N		t	\N	\N	\N
cb9c062a-5532-4625-97a5-71e4ac895c40	LUIGI	3244	\N	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	\N	\N	37a047f1-e311-4664-b056-6f4311757b33	LUIS SOLIMENO e HIJOS  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
cc9753ee-bc2a-47d5-9270-f249334a4680	LUCA MARIO	0546	2715	5f917487-3b4d-4cec-ac8b-6f549a1ce217	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	60	79.14	3952	37a047f1-e311-4664-b056-6f4311757b33	PESCASOL  S.A.	Mar del Plata	4800274	480-9608 / 481-0464	\N	amalfitanoycia@hotmail.com	\N	\N	Agencia Maritima Almafitano	t	\N	\N	\N
7cce667d-39fb-4100-abb6-6a347277e353	LUCA SANTINO	3121	0	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	26.31	0	\N	CENTOMAR  S.A.				\N		\N	\N		t	\N	\N	\N
28960b70-ca61-45cf-8f27-0a9cc62d0a38	LUCIA LUISA	0623	1897	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	27.90	463	37a047f1-e311-4664-b056-6f4311757b33	PESQUERA VERAZ  S.A.	Mar del Plata		489-4624 / 489-0314 (astillero)	\N		\N	\N		t	\N	\N	\N
297849c5-573c-4dd7-ba69-a6c38007cf5e	LUNES SANTO	01132	\N	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	\N	\N	20e6681d-78b9-4d78-8fff-3549a0c294bd	IBERCONSA  DE ARGENTINA  S.A.	Puerto Madryn		0280-445-4324	\N		\N	\N		t	\N	\N	\N
6d2f0358-d572-410b-876a-01c6265d034f	MADONNINA DEL MARE	01112	1912	4bcfaa2a-1a55-4c30-8256-bc499d7d07dc	95280ce6-e001-4c71-9c64-3994bf8beb53	\N	8	23.78	601	37a047f1-e311-4664-b056-6f4311757b33	FABLED  S.A	Mar del Plata		480-1565	\N		\N	\N		t	\N	\N	\N
49abef46-5e6f-47f9-a208-16df6a08f00b	MADRE DIVINA	01556	1915	4bcfaa2a-1a55-4c30-8256-bc499d7d07dc	95280ce6-e001-4c71-9c64-3994bf8beb53	\N	10	26.12	518	37a047f1-e311-4664-b056-6f4311757b33	VUOSO HNOS. S.R.L.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
1f2d998a-1099-41bf-b4d0-7792dfd0128d	MADRE INMACULADA	2378	1916	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	62.80	1852	37a047f1-e311-4664-b056-6f4311757b33	ANTONIO BALDINO e HIJOS  S.A. (Saladero)	Mar del Plata		489-6522  /489-0423	\N		\N	\N		t	\N	\N	\N
4075ec4f-5df1-42c1-b096-7eca0e2ff0c5	MADRE MARGARITA	02728	0	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	25.60	541	37a047f1-e311-4664-b056-6f4311757b33	PESQUERA  MARGARITA  S.A.	Mar del Plata		489-4645   /   489-2946	\N		\N	\N		t	\N	\N	\N
bd6c65a0-3d86-4d58-a8aa-bd619958d0fe	MAGDALENA MARIA  II	02208	\N	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	\N	\N	37a047f1-e311-4664-b056-6f4311757b33	ANTONIO BARILLARI  S.A.	Mar del Plata	4800005	481-1173  / 489-0872	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
27f5c245-f157-49d3-853e-f185d0f0263f	MALVINAS ARGENTINAS	0577	1931	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	28.40	458	37a047f1-e311-4664-b056-6f4311757b33	PEDRO MOSCUZZA e HIJOS  S.A.	Mar del Plata		489-7287	\N		\N	\N		t	\N	\N	\N
4b32b616-2655-4493-8a08-1510af999c69	MAR  AUSTRAL  I	0208	\N	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	\N	\N	be29702b-a6a9-434d-8eb3-5705e0f7468f	PESQUERA DESEADO  S.A.	Puerto Deseado		0297-487-0884 / 0327 / 2407	\N		\N	\N		t	\N	\N	\N
418fb183-89d5-40f7-839c-1fa102c7bca5	MAR AZUL	0934	\N	\N	\N	\N	\N	\N	\N	\N	CLARAMAR  S.A.		480-7779 - HERNAN		\N	agenciasenoransmdp@yahoo.com	\N	\N	Agencia Maritima SEÑORANS	t	\N	\N	\N
d5942954-8135-47a6-856e-f1e8bce47148	MAR DEL CHUBUT	0487	1944	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	28.20	721	37a047f1-e311-4664-b056-6f4311757b33	ROMFIOC  SRL	Mar del Plata	4800005		\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi	t	\N	\N	\N
b2a29d13-49fc-4675-82be-aa213e01e2df	MAR ESMERALDA	0925	\N	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	\N	\N	37a047f1-e311-4664-b056-6f4311757b33	ANTONIO BARILLARI  S.A.	Mar del Plata		481-1173  / 489-0872	\N		\N	\N		t	\N	\N	\N
1fd391d6-ac13-49b8-86f0-72d8b69b7bd0	MAR MARÍA	02960	2738	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	37.80	1248	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	PESQUERA SANTA CRUZ  S.A.	Ciudad Autónoma de Buenos Aires		011-4305-4706	\N		\N	\N		t	\N	\N	\N
941e60fa-4e5f-479f-89c4-b5fe5602ef3e	MAR NOVIA 1	0115	\N	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	\N	\N	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	CINCOMAR  S.A.	Ciudad Autónoma de Buenos Aires		011-4326-4991	\N		\N	\N		t	\N	\N	\N
1e09ad45-d4e6-445e-9b29-d3563a804d1e	MAR NOVIA 2	0116	\N	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	\N	\N	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	MIREMAR  S.A.	Ciudad Autónoma de Buenos Aires		011-4328-4963 / 4	\N		\N	\N		t	\N	\N	\N
31dc0fcb-f580-4a21-8b39-edc7f9f5becd	MAR SUR	0341	1957	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	36.40	889	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	PESCARGEN  S.A.	Ciudad Autónoma de Buenos Aires		011-5219-0065 ó 5276-9499	\N		\N	\N		t	\N	\N	\N
13597dac-ed17-4324-8b48-5dd987b632bb	MARA I	0210	1960	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	35.31	1209	20e6681d-78b9-4d78-8fff-3549a0c294bd	PESCAPUERTA ARGENTINA  S.A.	Puerto Madryn		0280-445-4407	\N		\N	\N		t	\N	\N	\N
92674726-41de-4045-b2c9-d5c5bb816b4f	MARA II	0209	\N	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	\N	\N	20e6681d-78b9-4d78-8fff-3549a0c294bd	PESCAPUERTA ARGENTINA  S.A.	Puerto Madryn		0280-445-4407	\N		\N	\N		t	\N	\N	\N
b6b9a397-9388-4cab-a529-19308c785b06	MARBELLA	01073	1966	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	27.38	736	37a047f1-e311-4664-b056-6f4311757b33	MAR DE MESSINA  S.A.	Mar del Plata	beagle1	489-3824	\N		\N	\N		t	\N	\N	\N
daeef6b9-9d60-4f33-ba08-527c2d6d5d75	MARCALA I	0532	\N	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	\N	\N	37a047f1-e311-4664-b056-6f4311757b33	PESANFLOR  S.A.	Mar del Plata		489-6522	\N		\N	\N		t	\N	\N	\N
3056417b-6657-4abb-8069-bf7199509f84	MARCALA IV	0351	\N	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	\N	\N	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	MARCALA  S.A.	Ciudad Autónoma de Buenos Aires		011-4342-9601 / 4283	\N		\N	\N		t	\N	\N	\N
d65703d2-1b99-423f-942e-d7c13e26059a	MAREJADA	01107	1974	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	27.98	624	37a047f1-e311-4664-b056-6f4311757b33	VICARP  S.A.	Mar del Plata		480-4378	\N		\N	\N		t	\N	\N	\N
a7f91712-69d9-4265-9ecb-e26a5e1e668d	MARGOT	0360	1976	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	58.75	1481	37a047f1-e311-4664-b056-6f4311757b33	GIORNO  S.A.	Mar del Plata	4800005	410-0051 / 0057	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
b5721d9a-84ff-4820-a9b9-19a4a8f65d63	MARIA  EUGENIA	01173	\N	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	\N	\N	37a047f1-e311-4664-b056-6f4311757b33	PEDRO MOSCUZZA e HIJOS  S.A.	Mar del Plata		489-7287	\N		\N	\N		t	\N	\N	\N
877da091-8b2f-4880-b8de-f6ef9ec339ac	HUAFENG 816	05994	0	4bcfaa2a-1a55-4c30-8256-bc499d7d07dc	95280ce6-e001-4c71-9c64-3994bf8beb53	\N	4	22.60	521	37a047f1-e311-4664-b056-6f4311757b33	COSTA BRAVA  S.A.	Mar del Plata	4800005	489-7538	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
b0c29e4a-ece1-48b4-b0ab-cd780127dc95	MARIA  LILIANA	01174	\N	5f917487-3b4d-4cec-ac8b-6f549a1ce217	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	60	\N	\N	37a047f1-e311-4664-b056-6f4311757b33	PEDRO MOSCUZZA e HIJOS  S.A.	Mar del Plata	4893758	489-7287	\N	miguel-visoso@hotmail.com	\N	\N	Agencia Maritima Solvox	t	\N	\N	\N
5c2d2a10-c83e-48ae-a601-33d1ddefda37	MARIA RITA	0436	2000	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	30.95	541	37a047f1-e311-4664-b056-6f4311757b33	BAL - FISH  S.A.	Mar del Plata		489-6522	\N		\N	\N		t	\N	\N	\N
4b1864ba-a45c-4b23-b665-c9601ef0357d	MARIA ALEJANDRA 1º	03074	2750	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	39.20	0	37a047f1-e311-4664-b056-6f4311757b33	XEITOSIÑO S.A.	Mar del Plata		410-0051 / 7	\N		\N	\N		t	\N	\N	\N
a8a16d69-6f32-4b48-81c4-cffde2f4a1f6	MARIA DEL VALLE	02126	1986	4bcfaa2a-1a55-4c30-8256-bc499d7d07dc	95280ce6-e001-4c71-9c64-3994bf8beb53	\N	4	16.29	196	a68c150f-2d39-40d2-a693-9d1b15859f5f	FARO CHUBUT  S.R.L.	Rawson		0280-449-6311	\N		\N	\N		t	\N	\N	\N
16565ff8-f959-4082-b59d-5e4a877ffd90	MARIA GLORIA	02738	2763	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	28.05	851	37a047f1-e311-4664-b056-6f4311757b33	CAYO LARGO  S.A.	Mar del Plata		480-4378	\N		\N	\N		t	\N	\N	\N
d5d6563f-07b2-4fdc-adf7-b8a9fe0928f7	MARIANELA	01002	2007	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	25.60	541	37a047f1-e311-4664-b056-6f4311757b33	AGLIANO  SRL	Mar del Plata		480-2886	\N		\N	\N		t	\N	\N	\N
e08b5e0d-d360-4796-b890-f3e3bcc2bdda	MARTA S	01001	0	4bcfaa2a-1a55-4c30-8256-bc499d7d07dc	95280ce6-e001-4c71-9c64-3994bf8beb53	\N	8	23.90	503	37a047f1-e311-4664-b056-6f4311757b33	WERZOWA  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
cc478ea5-a466-47d5-bf8a-2ccbb47eb045	MATACO II	02243	\N	5f917487-3b4d-4cec-ac8b-6f549a1ce217	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	60	\N	\N	20e6681d-78b9-4d78-8fff-3549a0c294bd	HAMALTAL  S.A.	Puerto Madryn	4800005	0280-445-0822	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
2f902725-8860-4e05-ad27-eed37ca6f379	MATEO I	02172	2028	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	67.97	1776	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	KALEU KALEU  S.A.	Ciudad Autónoma de Buenos Aires		011-3220-2130  / 5093-1215	\N		\N	\N		t	\N	\N	\N
6712ce78-cbf2-4e4b-8e1f-d1da83ca2e56	MELLINO I	0379	2032	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	47.25	1185	37a047f1-e311-4664-b056-6f4311757b33	GIORNO  S.A.	Mar del Plata		410-0051 / 0057	\N		\N	\N		t	\N	\N	\N
cd546b5d-0527-4fd9-8526-7ee14d80def8	MELLINO II	01424	0	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	38.91	795	37a047f1-e311-4664-b056-6f4311757b33	GIORNO  S.A.	Mar del Plata	AVENIDA DE LOS PESCADORES 195	410-0051 / 0057	\N		\N	\N	Agencia AMALFITANO	t	\N	\N	\N
f7869696-130e-4a0b-82a2-0db8efdda4f5	MELLINO VI	0378	2034	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	64.87	1235	37a047f1-e311-4664-b056-6f4311757b33	GIORNO  S.A.	Mar del Plata		410-0051 / 0057	\N		\N	\N		t	\N	\N	\N
5ff1b9ae-19b7-479e-808e-fe33fa7d1bc0	MERCEA C	0318	2036	\N	\N	\N	0	29.15	866	37a047f1-e311-4664-b056-6f4311757b33	ALLELOCCIC  S.A.	Mar del Plata		495-4467 / 480-8565	\N		\N	\N		t	\N	\N	\N
4c8b28fb-1819-4f8a-8714-2875aea59a4b	MESSINA I	01089	2038	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	27.29	650	37a047f1-e311-4664-b056-6f4311757b33	MAR DE MESSINA  S.A.	Mar del Plata		489-3824	\N		\N	\N		t	\N	\N	\N
4303b5cd-54f0-4359-8b95-e67d110b9611	MEVIMAR	01508A	\N	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	\N	\N	20e6681d-78b9-4d78-8fff-3549a0c294bd	RIMINIMARR  S.A.	Puerto Madryn		0280-445-2248	\N		\N	\N		t	\N	\N	\N
0636e57d-f7b2-4d1e-b5a2-4ea8769b575b	MIERCOLES SANTO	0666	2041	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	38.50	1244	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	NUVCONSA  S.A.	Ciudad Autónoma de Buenos Aires		011-4305-4706	\N		\N	\N		t	\N	\N	\N
48ee57e7-f6f9-429b-ad90-3812708c1ece	MILLENNIUM	0466	2046	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	55.05	1329	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	PESQUERA CRUZ DEL SUR  S.A.	Ciudad Autónoma de Buenos Aires		011-4784-1760	\N		\N	\N		t	\N	\N	\N
4fa7bf1d-c530-4a0c-84a8-75894d92ae76	MINCHOS OCTAVO	03022	2744	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	39.30	579	20e6681d-78b9-4d78-8fff-3549a0c294bd	IBERCONSA  DE ARGENTINA  S.A.	Puerto Madryn		0280-445-4324	\N		\N	\N		t	\N	\N	\N
cef07932-8b97-4d14-bc5c-06cbc4831f05	NINA	3171	2770	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	44.00	1620	\N	PEDRO MOSCUZZA e HIJOS  S.A.				\N		\N	\N		t	\N	\N	\N
8967d5fd-2d02-4edd-ae1b-728d6d50e876	MINTA	02196	2050	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	65.10	1603	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	LIYA  S.A.	Ciudad Autónoma de Buenos Aires		011-4964-2227	\N		\N	\N		t	\N	\N	\N
88e6ed6b-0172-4d32-be68-03a75789f0e4	MIRIAM	0370	2051	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	36.35	1446	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	VIEIRA ARGENTINA  S.A.	Ciudad Autónoma de Buenos Aires	4800005		\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi	t	\N	\N	\N
4d527b3f-caaa-4cae-8d51-3743b642e368	MISHIMA MARU N°8	02175	2054	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	63.43	1579	37a047f1-e311-4664-b056-6f4311757b33	BAL - FISH  S.A.	Mar del Plata	4800274	489-6522	\N	amalfitanoycia@hotmail.com	\N	\N	Agencia Maritima Almafitano	t	\N	\N	\N
8a8fd4a9-d70d-40e4-85de-6fd7236553c5	MISS PATAGONIA	0555	2055	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	28.20	667	37a047f1-e311-4664-b056-6f4311757b33	PESQUERA VERAZ  S.A.	Mar del Plata	4805743	489-4624 / 489-0314 (astillero)	\N	agenciadiyorio@hotmail.com -joseph@hotmail.com	\N	\N	Agencia Di Yorio	t	\N	\N	\N
56b78ea0-13da-476a-bc74-316af4625dbe	MISS TIDE	02439	2056	627a88cb-bf97-434f-bfab-4ef3339c44d3	7bf053fd-02b7-4f5f-954e-61b3668f9611	bdb064e1-c2c3-4e77-ac2a-64dc9bd12fbf	30	52.52	2254	37a047f1-e311-4664-b056-6f4311757b33	WANCHESE ARGENTINA  S.A.	Mar del Plata		489-1236	\N		\N	\N		t	\N	\N	\N
9626239a-a76d-4084-962d-787f870677f3	MISTER BIG	0534	\N	627a88cb-bf97-434f-bfab-4ef3339c44d3	7bf053fd-02b7-4f5f-954e-61b3668f9611	bdb064e1-c2c3-4e77-ac2a-64dc9bd12fbf	30	\N	\N	37a047f1-e311-4664-b056-6f4311757b33	WANCHESE ARGENTINA  S.A.	Mar del Plata		489-1236	\N		\N	\N		t	\N	\N	\N
2cec031a-a926-46f3-af6d-17589c650ad3	MIURA MARU	05996	2058	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	53.20	1482	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	LIYA  S.A.	Ciudad Autónoma de Buenos Aires		011-4964-2227	\N		\N	\N		t	\N	\N	\N
97a022f5-f5d6-4516-a7f7-7274331e47b1	MONTE DE VIOS	0664	\N	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	\N	\N	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	PESQUERA SANTA CRUZ  S.A.	Ciudad Autónoma de Buenos Aires		011-4305-4706	\N		\N	\N		t	\N	\N	\N
e4908a88-26a1-4b16-a2a3-129d476bd611	MYRDOMA F	02771	2735	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	38.55	1430	20e6681d-78b9-4d78-8fff-3549a0c294bd	LANZAR S.A.	Puerto Madryn	4800005	0280-445-6280	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
87b6dea5-fea1-48e5-8033-8cd680a1d3b2	NANINA	02576	2073	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	72.08	1678	37a047f1-e311-4664-b056-6f4311757b33	PEDRO MOSCUZZA e HIJOS  S.A.	Mar del Plata	4800005	489-7287	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
66d2fd09-8c49-4698-aa7d-c1111c7b766e	NATALIA	02066	2075	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	68.45	1779	37a047f1-e311-4664-b056-6f4311757b33	PEDRO MOSCUZZA e HIJOS  S.A.	Mar del Plata		489-7287	\N		\N	\N		t	\N	\N	\N
9ae39687-30a0-4146-9ce6-514d50eac31f	NAVEGANTES	0542	2079	5f917487-3b4d-4cec-ac8b-6f549a1ce217	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	60	58.00	1925	37a047f1-e311-4664-b056-6f4311757b33	PESQUERA COMERCIAL  S.A.	Mar del Plata		489-3030	\N		\N	\N		t	\N	\N	\N
b15e1a6a-0688-47aa-8c3d-d048291202a6	NAVEGANTES II	01451	2080	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	63.70	1603	37a047f1-e311-4664-b056-6f4311757b33	PESQUERA COMERCIAL  S.A.	Mar del Plata		489-3030	\N		\N	\N		t	\N	\N	\N
9be7d81e-ff7c-4c23-a615-c63edcd9dd6d	NAVEGANTES III	02065	2081	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	68.60	2203	37a047f1-e311-4664-b056-6f4311757b33	PESQUERA COMERCIAL  S.A.	Mar del Plata	4800274	489-3030	\N	amalfitanoycia@hotmail.com	\N	\N	Agencia Maritima Almafitano	t	\N	\N	\N
bb3a8706-686a-4a83-8851-1f18d6c11911	NDDANDDU	0141	2082	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	28.20	856	37a047f1-e311-4664-b056-6f4311757b33	PESQUERA VERAZ  S.A.	Mar del Plata		489-4624 / 489-0314 (astillero)	\N		\N	\N		t	\N	\N	\N
c3eb455f-199c-4dc6-a535-61ab24db4794	NEPTUNIA I	02125	\N	4bcfaa2a-1a55-4c30-8256-bc499d7d07dc	95280ce6-e001-4c71-9c64-3994bf8beb53	\N	4	\N	\N	a68c150f-2d39-40d2-a693-9d1b15859f5f	FLOTA AMARILLA RAWSON	Rawson	4891553-154179360-154179860-154179062		\N	agenciasmiriglio@speedy.com.ar	\N	\N	Agencia Maritima SMIRIGLIO	t	\N	\N	\N
ed3f98c6-2e1e-490d-9220-4a40c86199e3	NIÑO JESUS DE PRAGA	3194	2775	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	27.74	1180	37a047f1-e311-4664-b056-6f4311757b33	RITORNO SALLUSTIO Y CICCIOTTI  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
f3a4f082-17bc-4757-8c3e-b63aa684d688	NONO PASCUAL	02854	2729	4bcfaa2a-1a55-4c30-8256-bc499d7d07dc	95280ce6-e001-4c71-9c64-3994bf8beb53	\N	10	24.00	451	37a047f1-e311-4664-b056-6f4311757b33	CANAL DE BEAGLE  S.R.L.	Mar del Plata		480-4447 / 5004265 PASCUAL	\N		\N	\N		t	\N	\N	\N
83377aa4-856c-48dc-b1f0-eea6565f3dd6	NUEVA LUCIA MADRE	01501	2113	4bcfaa2a-1a55-4c30-8256-bc499d7d07dc	95280ce6-e001-4c71-9c64-3994bf8beb53	\N	8	14.37	416	37a047f1-e311-4664-b056-6f4311757b33	NUEVA LUCIA MADRE  S.R.L.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
9d6fb4cb-da8a-4b0a-b425-9d6cb7540135	NUEVA NEPTUNIA I	02634	0	4bcfaa2a-1a55-4c30-8256-bc499d7d07dc	95280ce6-e001-4c71-9c64-3994bf8beb53	\N	4	20.00	403	a68c150f-2d39-40d2-a693-9d1b15859f5f	ORION S.R.L.	Rawson			\N		\N	\N		t	\N	\N	\N
1247d75a-1b28-46c0-8e02-9c54347488b3	NUEVO ANITA	02100	2128	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	30.90	765	20e6681d-78b9-4d78-8fff-3549a0c294bd	IBERCONSA  DE ARGENTINA  S.A.	Puerto Madryn		0280-445-4324	\N		\N	\N		t	\N	\N	\N
1d460420-e169-4fd3-a928-728488fb999b	NUEVO VIENTO	01449	2135	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	22.23	541	37a047f1-e311-4664-b056-6f4311757b33	NUEVO VIENTO  SRL	Mar del Plata		480-8565	\N		\N	\N		t	\N	\N	\N
3d5c4bf0-f2da-4fb7-b48b-7cc1aaf64aba	OMEGA 3	01391	\N	4bcfaa2a-1a55-4c30-8256-bc499d7d07dc	95280ce6-e001-4c71-9c64-3994bf8beb53	\N	10	\N	\N	37a047f1-e311-4664-b056-6f4311757b33	COSTA BRAVA  S.A.	Mar del Plata		489-7538	\N		\N	\N		t	\N	\N	\N
771c470c-ee55-4f5f-9da6-eb5bbb429d12	ORION  2	01492	\N	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	\N	\N	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	PESQUERA SANTA CRUZ  S.A.	Ciudad Autónoma de Buenos Aires		011-4305-4706	\N		\N	\N	norberto.lopez@iberconsa.com	t	\N	\N	\N
3f806401-e173-4e7d-af33-772d8357cb58	ORION 5	02637	2757	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	65.62	1776	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	PESQUERA SANTA CRUZ  S.A.	Ciudad Autónoma de Buenos Aires		011-4305-4706	\N		\N	\N		t	\N	\N	\N
2d8b22cf-d6d5-4d9b-bb49-648978c770af	ORION I	01943A	0	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	20.90	520	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	PESQUERA CRUZ DEL SUR  S.A.	Ciudad Autónoma de Buenos Aires		011-4784-1760	\N		\N	\N		t	\N	\N	\N
2a164227-3547-4f49-91b9-174d3bc6fcb2	ORION 1	01943	\N	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	\N	\N	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	PESQUERA SANTA CRUZ  S.A.	Ciudad Autónoma de Buenos Aires		011-4305-4706	\N		\N	\N		t	\N	\N	\N
ca6c7cb6-3836-4f37-a911-7460660e4e2b	ORION 3	02167	2170	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	63.10	1776	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	PESQUERA SANTA CRUZ  S.A.	Ciudad Autónoma de Buenos Aires		011-4305-4706	\N		\N	\N		t	\N	\N	\N
dbc2fa98-a1d2-40b7-9747-193c6e3a9d9c	ORYONG  756	02092	\N	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	\N	\N	20e6681d-78b9-4d78-8fff-3549a0c294bd	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
eae6dc83-05e6-4ece-bf35-06319425f917	PACHACA	02572	2180	4bcfaa2a-1a55-4c30-8256-bc499d7d07dc	95280ce6-e001-4c71-9c64-3994bf8beb53	\N	4	17.64	320	a68c150f-2d39-40d2-a693-9d1b15859f5f	FLOTA AMARILLA RAWSON	Rawson			\N		\N	\N		t	\N	\N	\N
388fe835-2b1d-4548-bfe5-154a0f0332e2	PADRE PIO	02822	2737	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	24.00	451	37a047f1-e311-4664-b056-6f4311757b33	RITORNO SALLUSTIO Y CICCIOTTI  S.A.	Mar del Plata		480-5508	\N		\N	\N		t	\N	\N	\N
987b513c-c03b-4ea9-950b-85f4ac28f4a5	PAGRUS II	01393	\N	4bcfaa2a-1a55-4c30-8256-bc499d7d07dc	95280ce6-e001-4c71-9c64-3994bf8beb53	\N	4	\N	\N	37a047f1-e311-4664-b056-6f4311757b33	COSTA BRAVA  S.A.	Mar del Plata		489-7538	\N		\N	\N		t	\N	\N	\N
de4d5832-6484-47de-8e17-2856bc501c06	PAKU	0250	2186	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	39.16	1087	37a047f1-e311-4664-b056-6f4311757b33	LUIS SOLIMENO e HIJOS  S.A.	Mar del Plata		489-3030	\N		\N	\N		t	\N	\N	\N
de15d261-07ad-4ddc-b01f-19a10af76ef8	PALOMA V	64	\N	5b6e3b32-ed41-492e-a683-cb08f60e5dd9	a5b73621-f1c8-4fb2-b4fd-24af1b776e40	bd11f66e-22de-4ca1-a92a-e76082a2efa8	60	\N	\N	\N					\N		\N	\N		t	\N	\N	\N
d189de2f-1d9f-4d03-80ab-01d2eb5cdfac	PAOLA  S	0557	\N	\N	\N	\N	30	\N	\N	\N					\N		\N	\N		t	\N	\N	\N
830d96ed-697d-4bf1-900e-0835808d9e6e	PASA  82	0338	\N	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	\N	\N	20e6681d-78b9-4d78-8fff-3549a0c294bd	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
e4b721f4-f2ba-460a-a733-553a2e1985fd	PATAGONIA	0284	2196	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	30.95	660	37a047f1-e311-4664-b056-6f4311757b33	LUIS SOLIMENO e HIJOS  S.A.	Mar del Plata		489-3030	\N		\N	\N		t	\N	\N	\N
0b20a90c-cdb6-467b-8c24-53a21d2935ad	PATAGONIA 1	02163	\N	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	\N	\N	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	PATAGONIA  FISHING  S.A.	Ciudad Autónoma de Buenos Aires		011-4932-2777	\N		\N	\N		t	\N	\N	\N
c93c99c6-a7a7-4060-a21d-5389337aace9	PATAGONIA 2	02164	\N	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	\N	\N	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	PATAGONIA  FISHING  S.A.	Ciudad Autónoma de Buenos Aires		011-4932-2777	\N		\N	\N		t	\N	\N	\N
32af5cd6-11ed-4cd6-80d0-59973df5ebac	PATAGONIA BLUES	02176	2199	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	64.45	1776	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	PESQUERA CRUZ DEL SUR  S.A.	Ciudad Autónoma de Buenos Aires		011-4784-1760	\N		\N	\N		t	\N	\N	\N
cafbae61-7a55-46e5-a4bf-45c3075c86b9	PEDRITO	TEMP-0005	0	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	\N	39.92	1201	\N					\N		\N	\N		t	\N	\N	\N
cbb0ee69-4927-42c6-ae9c-693e8f210345	PELAGOS	83	\N	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	\N	\N	20e6681d-78b9-4d78-8fff-3549a0c294bd	PESQUERA SAN ISIDRO S.A.	Puerto Madryn		0280-447-2697	\N		\N	\N		t	\N	\N	\N
239bf8dc-7a13-4b11-8860-d76aa96d7cdf	PENSACOLA I	0747	2207	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	25.20	380	dad98859-6c8d-4cdf-b76d-5c6da58c2e2b	FRANGELA  S.A.	Comodoro Rivadavia			\N		\N	\N		t	\N	\N	\N
7f7b0f72-58d1-48df-b205-78e6e604005e	PESCAPUERTA CUARTO	0171	\N	5f917487-3b4d-4cec-ac8b-6f549a1ce217	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	60	\N	\N	20e6681d-78b9-4d78-8fff-3549a0c294bd	PESCAPUERTA ARGENTINA  S.A.	Puerto Madryn		0280-445-4407	\N		\N	\N		t	\N	\N	\N
654d30c5-6479-48a7-853a-802e536729ad	PESCAPUERTA QUINTO	0538	\N	3c4c96c7-1ccb-437d-8cb4-ec87500da20d	95280ce6-e001-4c71-9c64-3994bf8beb53	61617027-3911-4e52-91ac-c8612dac86c9	60	\N	\N	20e6681d-78b9-4d78-8fff-3549a0c294bd	PESCAPUERTA ARGENTINA  S.A.	Puerto Madryn		0280-445-4407	\N		\N	\N		t	\N	\N	\N
2c6b1022-c296-41c6-a39a-be0cfbe60630	PESCARGEN  V	078	\N	5f917487-3b4d-4cec-ac8b-6f549a1ce217	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	60	\N	\N	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	PESCARGEN  S.A.	Ciudad Autónoma de Buenos Aires		011-5219-0065 ó 5276-9499	\N		\N	\N		t	\N	\N	\N
44706c23-54ae-4722-a121-b2e39f0b684d	PESCARGEN III	021	\N	5f917487-3b4d-4cec-ac8b-6f549a1ce217	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	60	\N	\N	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	PESCARGEN  S.A.	Ciudad Autónoma de Buenos Aires		011-5219-0065 ó 5276-9499	\N		\N	\N		t	\N	\N	\N
e57ef92e-d7cf-40bc-9e03-3779afc0f30a	PESCARGEN IV	0150	2217	5f917487-3b4d-4cec-ac8b-6f549a1ce217	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	60	63.20	1603	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	PESCARGEN  S.A.	Ciudad Autónoma de Buenos Aires		011-5219-0065 ó 5276-9499	\N		\N	\N		t	\N	\N	\N
9875116f-0e85-4593-9263-d8febe1ded8e	PESPASA  II	0212	\N	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	\N	\N	be29702b-a6a9-434d-8eb3-5705e0f7468f	PESPASA  S.A.	Puerto Deseado		0297-487-2030  int 12	\N		\N	\N		t	\N	\N	\N
16c3816f-9172-4ff3-86f3-b7cb655397e1	PESPASA I	0211	\N	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	\N	\N	be29702b-a6a9-434d-8eb3-5705e0f7468f	PESPASA  S.A.	Puerto Deseado		0297-487-2030  int 12	\N		\N	\N		t	\N	\N	\N
50b3353b-068c-4760-8c47-5becd50075a1	PETREL	01445	2224	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	29.85	776	37a047f1-e311-4664-b056-6f4311757b33	OLAMAR  S.A.	Mar del Plata		480-3573	\N		\N	\N		t	\N	\N	\N
579ce3b8-aa88-490f-b672-aa25a1726efd	PEVEGASA QUINTO	02312	2225	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	38.65	740	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	PUNTA BUSTAMANTE  S.A.	Ciudad Autónoma de Buenos Aires		011-4305-4710 / 4712	\N		\N	\N		t	\N	\N	\N
7d288fe2-8afb-4720-ab36-d83d8a20e36b	PIONEROS	02735	\N	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	\N	\N	37a047f1-e311-4664-b056-6f4311757b33	CALME  S.A.	Mar del Plata		480-3545	\N		\N	\N		t	\N	\N	\N
d3208691-b91b-4ca1-9b6b-5b45bf75b566	POLARBORG I	02122	\N	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	\N	\N	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	GRINFIN  S.A.	Ciudad Autónoma de Buenos Aires		011-4343-5626	\N		\N	\N		t	\N	\N	\N
2d893de4-3a23-4278-83a2-fff131a957a5	POLARBORG II	02117	\N	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	\N	\N	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	GRINFIN  S.A.	Ciudad Autónoma de Buenos Aires	4800005	011-4343-5626	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi	t	\N	\N	\N
1223b71c-d5a1-4f2f-beb7-3c97aa58971b	PONTE CORUXO	0975	2242	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	52.85	1383	37a047f1-e311-4664-b056-6f4311757b33	BAL - FISH  S.A.	Mar del Plata		489-6522	\N		\N	\N		t	\N	\N	\N
41e705e5-62e6-4228-aebe-7eab3a543853	PONTE DE RANDE	0244	2243	5f917487-3b4d-4cec-ac8b-6f549a1ce217	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	60	79.14	2964	37a047f1-e311-4664-b056-6f4311757b33	COSTA MARINA  S.A.	Mar del Plata		480-9608 / 481-0464	\N		\N	\N		t	\N	\N	\N
9008387e-081d-4419-8336-6dee1c7e7d97	PORTO BELO I	02699	2736	4bcfaa2a-1a55-4c30-8256-bc499d7d07dc	95280ce6-e001-4c71-9c64-3994bf8beb53	\N	8	23.98	600	37a047f1-e311-4664-b056-6f4311757b33	FARO RECALADA  S.A	Mar del Plata		480-2442	\N		\N	\N		t	\N	\N	\N
e54c60dc-85eb-4bfc-9215-9847f4c0c846	PORTO BELO II	02790	2728	4bcfaa2a-1a55-4c30-8256-bc499d7d07dc	95280ce6-e001-4c71-9c64-3994bf8beb53	\N	10	23.98	601	37a047f1-e311-4664-b056-6f4311757b33	MARITIMA PORTO BELO  S.A.	Mar del Plata		489-1553	\N		\N	\N		t	\N	\N	\N
387b6cca-9835-4fb7-b2a6-91941eda9cac	PRINCIPE AZUL	TEMP-0006	\N	4bcfaa2a-1a55-4c30-8256-bc499d7d07dc	95280ce6-e001-4c71-9c64-3994bf8beb53	\N	10	\N	\N	37a047f1-e311-4664-b056-6f4311757b33		Mar del Plata			\N		\N	\N		t	\N	\N	\N
b323b688-188f-4993-a3ac-2b0613e628f0	PROMAC	4815	2257	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	33.45	721	37a047f1-e311-4664-b056-6f4311757b33	LUIS SOLIMENO e HIJOS  S.A.	Mar del Plata		489-3030	\N		\N	\N		t	\N	\N	\N
9698150b-c2ca-4be1-9d17-db012bdc6ce7	PROMARSA I	072	\N	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	\N	\N	20e6681d-78b9-4d78-8fff-3549a0c294bd	ALPESCA  S.A.	Puerto Madryn		0280-447-4958 / 45-1069	\N		\N	\N		t	\N	\N	\N
19954c74-721b-44cb-802b-f86fe374eada	PROMARSA II	073	\N	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	\N	\N	20e6681d-78b9-4d78-8fff-3549a0c294bd	ALPESCA  S.A.	Puerto Madryn		0280-447-4958 / 45-1069	\N		\N	\N		t	\N	\N	\N
d6c00a9d-524e-42bb-8d3c-0ac782598bf6	PROMARSA III	02096	0	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	35.84	1062	20e6681d-78b9-4d78-8fff-3549a0c294bd	ALPESCA  S.A.	Puerto Madryn		0280-447-4958 / 45-1069	\N		\N	\N		t	\N	\N	\N
bb008605-e4d6-4cb1-b631-6ce1ef38d969	PUENTE VALDES	02205	2266	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	58.15	1383	20e6681d-78b9-4d78-8fff-3549a0c294bd	PEREIRA  ARGENTINA  S.A.	Puerto Madryn		0280-445-7377 / 447-2249	\N		\N	\N		t	\N	\N	\N
24019c3a-c373-4318-9ed2-f869c53e1799	PUENTE AMERICA	0164	\N	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	\N	\N	20e6681d-78b9-4d78-8fff-3549a0c294bd	PEREIRA  ARGENTINA  S.A.	Puerto Madryn		0280-445-7377 / 447-2249	\N		\N	\N		t	\N	\N	\N
64604294-96f2-4e58-b1bd-3c2017db7170	PUENTE CHICO	0756	2263	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	37.00	1175	20e6681d-78b9-4d78-8fff-3549a0c294bd	PEREIRA  ARGENTINA  S.A.	Puerto Madryn		0280-445-7377 / 447-2249	\N		\N	\N		t	\N	\N	\N
aa3fbbff-cc29-4cf2-a2b2-7258b542efc1	PUENTE MAYOR	02630	2703	5f917487-3b4d-4cec-ac8b-6f549a1ce217	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	60	66.86	2416	20e6681d-78b9-4d78-8fff-3549a0c294bd	PEREIRA  ARGENTINA  S.A.	Puerto Madryn		0280-445-7377 / 447-2249	\N		\N	\N		t	\N	\N	\N
e2a5ce28-cb0e-4484-8ebb-977fd760d7a0	PUENTE SAN JORGE	0207	2265	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	35.30	1001	20e6681d-78b9-4d78-8fff-3549a0c294bd	PEREIRA  ARGENTINA  S.A.	Puerto Madryn		0280-445-7377 / 447-2249	\N		\N	\N		t	\N	\N	\N
c607c194-d044-46e5-ac3e-074725277581	PUERTO WILLIAMS	3178	\N	3c4c96c7-1ccb-437d-8cb4-ec87500da20d	95280ce6-e001-4c71-9c64-3994bf8beb53	61617027-3911-4e52-91ac-c8612dac86c9	60	\N	\N	60cc1963-ba0f-4f37-ac75-cd04fdcd2ade	DERIS  S.A.	Punta Arenas -  Chile		+613 6224-8744	\N		\N	\N		t	\N	\N	\N
6d1e7f1a-b913-45e7-8c83-02c4c029f5ac	PUNTA BALLENA	65	\N	5b6e3b32-ed41-492e-a683-cb08f60e5dd9	a5b73621-f1c8-4fb2-b4fd-24af1b776e40	bd11f66e-22de-4ca1-a92a-e76082a2efa8	60	\N	\N	\N					\N		\N	\N		t	\N	\N	\N
cbbe757d-73ff-4017-8e4a-ade8fd09c2c4	QUEQUEN SALADO	0580	2277	4bcfaa2a-1a55-4c30-8256-bc499d7d07dc	95280ce6-e001-4c71-9c64-3994bf8beb53	\N	4	19.45	271	a68c150f-2d39-40d2-a693-9d1b15859f5f	PISCAL  S.A.	Rawson			\N		\N	\N		t	\N	\N	\N
b6dcf95b-9800-465b-9f8f-1d17ec55e792	RAFFAELA	01401	2280	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	26.50	624	37a047f1-e311-4664-b056-6f4311757b33	PESQUERA RAFFAELA  S.A.	Mar del Plata		489-56574 int 203	\N		\N	\N		t	\N	\N	\N
66c62496-5e0a-4655-bbdb-318d7fe5c11e	RAQUEL	01074	\N	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	\N	\N	37a047f1-e311-4664-b056-6f4311757b33	PIEA  S.A.	Mar del Plata		489-6317 /489-1367	\N		\N	\N		t	\N	\N	\N
347e864b-14e0-4b74-b1e3-558cd52fc2f7	REPUNTE	01120	\N	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	\N	\N	37a047f1-e311-4664-b056-6f4311757b33	OSTRAMAR  S.A.	Mar del Plata		489-1959	\N		\N	\N		t	\N	\N	\N
d5b53b57-61ad-41ff-8f84-e4fbac858553	REYES DEL MAR II	0408	\N	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	\N	\N	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	AGUA MARINA  S.A.	Ciudad Autónoma de Buenos Aires		011-4342-0605 / 5656 / 1709	\N		\N	\N		t	\N	\N	\N
2b4d48fb-5a58-418c-9a64-d6e2432f5aa5	RIBAZON DORINE	0921	\N	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	\N	\N	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	KALEU KALEU  S.A.	Ciudad Autónoma de Buenos Aires		011-3220-2130  / 5093-1215	\N		\N	\N		t	\N	\N	\N
0656b0ca-0648-4ffa-b9ae-ecfbec5bf21e	RIBAZON INES	0751	2306	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	38.50	720	37a047f1-e311-4664-b056-6f4311757b33	SOUTH FISH  S.A.	Mar del Plata		480-5202	\N		\N	\N		t	\N	\N	\N
8fe42dad-3049-4714-989e-37fe50bec4ae	RIGEL	0266	\N	4bcfaa2a-1a55-4c30-8256-bc499d7d07dc	95280ce6-e001-4c71-9c64-3994bf8beb53	\N	10	\N	\N	37a047f1-e311-4664-b056-6f4311757b33	LUIS SOLIMENO e HIJOS  S.A.	Mar del Plata		489-3030	\N		\N	\N		t	\N	\N	\N
b502589c-5613-43f7-bfd7-db73eda65031	ROCIO DEL MAR	01568	2313	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	15	22.60	541	37a047f1-e311-4664-b056-6f4311757b33	ROCIO DEL MAR  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
97a08fb5-454a-4a3b-8c9b-0143146e05cc	ROSARIO  G	0549	\N	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	\N	\N	20e6681d-78b9-4d78-8fff-3549a0c294bd	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
fd7c2bab-3623-45b1-9cce-f3e00d0fff61	RUMBO ESPERANZA	01211	\N	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	\N	\N	dad98859-6c8d-4cdf-b76d-5c6da58c2e2b	CAPAC  SRL	Comodoro Rivadavia		0297-446-1499  /  444-2233	\N		\N	\N		t	\N	\N	\N
351798c9-7d52-46b0-8f45-bb2a801e1c4e	RYOUN MARU N° 17	JA06-03	\N	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	\N	\N	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	BAHIA GRANDE  S.A.	Ciudad Autónoma de Buenos Aires	4891553-154179360-154179860-154179062	011-5272-0850 / 5254-1133	\N	agenciasmiriglio@speedy.com.ar	\N	\N	Agencia Maritima Smiriglio	t	\N	\N	\N
10cd28c5-38a8-461e-855b-2abb79cac6f7	SALVADOR R	02755	2761	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	27.73	420	37a047f1-e311-4664-b056-6f4311757b33	URBIPEZ  S.A.	Mar del Plata		4892793	\N		\N	\N		t	\N	\N	\N
fbc283dc-a8bf-4609-9f09-9bcaa4acb1e3	SAN ANDRES APOSTOL	0569	2340	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	54.56	2269	37a047f1-e311-4664-b056-6f4311757b33	PESANFLOR  S.A.	Mar del Plata		489-6522	\N		\N	\N		t	\N	\N	\N
32d124c1-248d-4493-84ff-da585fe3c670	SAN ANTONINO	0375	\N	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	\N	\N	37a047f1-e311-4664-b056-6f4311757b33	SEA FISH  S.A.	Mar del Plata	51-11-65337853	480-0336	\N		\N	\N	Natalia Cedrato	t	\N	\N	\N
e381544d-176f-4983-9515-3da39f54e189	VALERIA DEL ATLÁNTICO	02098	2346	3c4c96c7-1ccb-437d-8cb4-ec87500da20d	95280ce6-e001-4c71-9c64-3994bf8beb53	61617027-3911-4e52-91ac-c8612dac86c9	60	56.46	4698	37a047f1-e311-4664-b056-6f4311757b33	SAN ARAWA  S.A.	Mar del Plata		492-2216 / 492-0450	\N		\N	\N		t	\N	\N	\N
a15fb8de-0081-4607-8952-49d54feb5742	SAN BENEDETTO	02643	0	4bcfaa2a-1a55-4c30-8256-bc499d7d07dc	95280ce6-e001-4c71-9c64-3994bf8beb53	\N	8	15.38	220	37a047f1-e311-4664-b056-6f4311757b33	PESQUERA SAN BENEDETTO  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
358f1c2b-b041-4e10-8d5e-2354dbdbbed3	SAN GENARO	0763	\N	4bcfaa2a-1a55-4c30-8256-bc499d7d07dc	95280ce6-e001-4c71-9c64-3994bf8beb53	\N	10	\N	\N	37a047f1-e311-4664-b056-6f4311757b33	LESAUMON  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
7afb571b-f697-494e-8dd8-455575849bdf	SAN JUAN B	TEMP-0007	2780	\N	\N	\N	\N	39.94	1204	\N					\N		\N	\N		t	\N	\N	\N
3efbf020-00e1-4bb3-b16d-6e37f2ed01e6	SAN JORGE MARTIR	02152	2367	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	56.10	1408	37a047f1-e311-4664-b056-6f4311757b33	PESANFLOR  S.A.	Mar del Plata		489-6522	\N		\N	\N		t	\N	\N	\N
3abe1a7a-1c94-426b-b093-0d45450f440f	SAN LUCAS  I	06147	\N	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	\N	\N	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	AGUA MARINA  S.A.	Ciudad Autónoma de Buenos Aires		011-4342-0605 / 5656 / 1709	\N		\N	\N		t	\N	\N	\N
799357ec-4f36-4c25-b5b4-59cafebe4bce	SAN MATEO	06306	0	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	54.10	1234	a68c150f-2d39-40d2-a693-9d1b15859f5f	IBERPESCA  S.A.	Rawson		0280-449-8176	\N		\N	\N		t	\N	\N	\N
7c46d61f-ebdf-4f6e-a304-0b3f762ba9ac	SAN MATIAS	0289	\N	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	\N	\N	37a047f1-e311-4664-b056-6f4311757b33	PESCA  ANTIGUA  S.A.	Mar del Plata		489-2340	\N		\N	\N		t	\N	\N	\N
1f5f3777-570b-48af-a45d-2457e22e93e1	SAN PABLO	0759	\N	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	\N	\N	37a047f1-e311-4664-b056-6f4311757b33	PRODUCTORA ARGEN-PESCA  S.A.	Mar del Plata		480-1444	\N		\N	\N		t	\N	\N	\N
c916e056-f0d7-4822-91ee-6b03d9970d4e	SAN PASCUAL	0367	\N	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	\N	\N	37a047f1-e311-4664-b056-6f4311757b33	BUENOS AIRES PESCA  S.A.	Mar del Plata		489-6522	\N		\N	\N		t	\N	\N	\N
342e6689-cf48-4d7c-933c-19be1bd9503d	SAN PEDRO APOSTOL	01975	\N	4bcfaa2a-1a55-4c30-8256-bc499d7d07dc	95280ce6-e001-4c71-9c64-3994bf8beb53	\N	10	\N	\N	37a047f1-e311-4664-b056-6f4311757b33	GAAD GROUP S.A.	Mar del Plata		480-9327	\N		\N	\N		t	\N	\N	\N
e25de18d-a72c-4365-8540-987d8612776f	SANT ANTONIO	0974	\N	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	\N	\N	37a047f1-e311-4664-b056-6f4311757b33	A.B.H. PESQUERA  S.A.	Mar del Plata	4895032	489-6522	\N	operacionesconsultoramaritima@gmail.com.ar	\N	\N	Agencia Merlini	t	\N	\N	\N
1b47a6ee-c535-4ac5-88b1-2380d8a6dfb1	SANTA BARBARA	5857	2409	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	56.96	1679	37a047f1-e311-4664-b056-6f4311757b33	PESCA ANGELA  S.A.	Mar del Plata		626-2236 /37	\N		\N	\N		t	\N	\N	\N
7182b4b7-7168-48c0-af31-f666fd19956b	SANTA ANGELA	009	\N	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	\N	\N	37a047f1-e311-4664-b056-6f4311757b33	OSTRAMAR  S.A.	Mar del Plata		489-1959	\N		\N	\N		t	\N	\N	\N
69c3a978-de21-4721-9759-bb83b3c2de3a	SANTIAGO  I	02280	\N	\N	\N	\N	0	\N	\N	20e6681d-78b9-4d78-8fff-3549a0c294bd	FISHING WORLD  S.A.	Puerto Madryn		0280-445-6533	\N		\N	\N		t	\N	\N	\N
3f7f12c7-d341-4d13-914d-4964ab294e3e	SCIROCCO	2574	2430	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	65.93	1589	37a047f1-e311-4664-b056-6f4311757b33	PESQUERA COMERCIAL  S.A.	Mar del Plata		489-3030	\N		\N	\N		t	\N	\N	\N
fd2fda4d-dca4-4126-afac-a26ac32c4679	SCOMBRUS	0509	\N	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	\N	\N	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	KALEU KALEU  S.A.	Ciudad Autónoma de Buenos Aires		011-3220-2130  / 5093-1215	\N		\N	\N		t	\N	\N	\N
1f02a30e-b624-49ad-8306-46229d4bc54a	SCOMBRUS  II	02245	\N	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	\N	\N	20e6681d-78b9-4d78-8fff-3549a0c294bd	HARENGUS  S.A.	Puerto Madryn		0280-445-0822	\N		\N	\N		t	\N	\N	\N
b18fdf8f-3d12-40ac-ae8b-3f555048f894	SERMILIK	0505	\N	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	\N	\N	20e6681d-78b9-4d78-8fff-3549a0c294bd	HARENGUS  S.A.	Puerto Madryn	4891553-154179360-154179860-154179062	0280-445-0822	\N	agenciasmiriglio@speedy.com.ar	\N	\N	Agencia Smiriglio	t	\N	\N	\N
5d4b6254-5c9e-478a-8cde-9759f18fb2e4	SFIDA	01567	2439	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	26.50	624	37a047f1-e311-4664-b056-6f4311757b33	SAN JORGE S.A.	Mar del Plata		480-6611	\N		\N	\N		t	\N	\N	\N
f01bec51-80ff-4194-b9c3-a32ce597fe73	SHUNYO MARU 178	JA04	\N	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	\N	\N	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	VIEIRA ARGENTINA  S.A.	Ciudad Autónoma de Buenos Aires			\N		\N	\N		t	\N	\N	\N
e6a8d77a-8d7d-46c1-b3bb-e935959938e1	SIEMPRE DON JOSE MOSCUZZA	02257	2460	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	38.00	1128	37a047f1-e311-4664-b056-6f4311757b33	FRESCOMAR ARGENTINA  S.A.	Mar del Plata		489-7287	\N		\N	\N		t	\N	\N	\N
fad7fe56-8fc5-4aa8-a4d6-03d3855f5086	SIEMPRE DON VICENTE	02654	2706	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	18.94	341	37a047f1-e311-4664-b056-6f4311757b33	PESQUERA VIRGEN DE ITATI  S.R.L.	Mar del Plata		480-2921	\N		\N	\N		t	\N	\N	\N
815eefcf-5ed8-4cc8-a078-e4c2a258571f	SIEMPRE SAN SALVADOR	00801	2475	4bcfaa2a-1a55-4c30-8256-bc499d7d07dc	95280ce6-e001-4c71-9c64-3994bf8beb53	\N	8	22.35	600	37a047f1-e311-4664-b056-6f4311757b33	LOURDESMAR  S.R.L.	Mar del Plata		476-2916	\N		\N	\N		t	\N	\N	\N
84276b07-b51c-42d8-b36d-4997cf55145a	SIEMPRE SANTA ROSA	0494	2476	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	27.80	548	37a047f1-e311-4664-b056-6f4311757b33	GIORNO  S.A.	Mar del Plata		410-0051 / 0057	\N		\N	\N		t	\N	\N	\N
9364dfeb-0d2b-4624-b29a-213aae1e5412	SIEMPRE VIEJO PANCHO	2937	2755	4bcfaa2a-1a55-4c30-8256-bc499d7d07dc	95280ce6-e001-4c71-9c64-3994bf8beb53	\N	15	17.98	601	\N					\N		\N	\N		t	\N	\N	\N
7b16f0d4-d498-4f37-b01c-88d43d7120ad	SIMBAD	0754	\N	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	\N	\N	37a047f1-e311-4664-b056-6f4311757b33	SOUTH FISH  S.A.	Mar del Plata		480-5202	\N		\N	\N		t	\N	\N	\N
f1ffe917-fb27-4a2b-b122-37f5b5be7763	SIRIUS	0905	\N	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	\N	\N	37a047f1-e311-4664-b056-6f4311757b33	LOBA PESQUERA  S.A.M.C.I.	Mar del Plata	4890960	489-0494  /  481-1814	\N	agencia@maritimavidal.com.ar	\N	\N	Agencia Maritima Vidal	t	\N	\N	\N
c05a98c2-9f01-4b09-9796-c331f584b9b4	SIRIUS II	0936	2489	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	59.25	1289	37a047f1-e311-4664-b056-6f4311757b33	EL MARISCO  S.A.	Mar del Plata	4890960	489-0384	\N	agencia@maritimavidal.com.ar	\N	\N	Agencia Maritima Vidal	t	\N	\N	\N
8592a793-6228-4330-a161-d1a38dae5c85	SIRIUS III	0937	\N	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	\N	\N	37a047f1-e311-4664-b056-6f4311757b33	EL MARISCO  S.A.	Mar del Plata	4808331/4808332	489-0384	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
0f3a3f1f-10b2-44b7-b3a8-2cffc1f72d8d	SOHO MARU Nº 58	02611	2492	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	65.67	1776	be29702b-a6a9-434d-8eb3-5705e0f7468f	ARGENOVA  S.A.	Puerto Deseado		0297- 487-0550  (447-2818  Com. Riv )	\N		\N	\N		t	\N	\N	\N
59bdd8b6-f631-458a-90bc-c5cff97902a2	SOL MARINO	77	\N	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	\N	\N	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	PESQUERA  20  DE NOVIEMBRE  S.A.	Ciudad Autónoma de Buenos Aires		011-4382-5011 / 4381-1337	\N		\N	\N		t	\N	\N	\N
276efbf8-e587-491a-9891-6dd6971d0483	STELLA MARIS 1°	0926	\N	5f917487-3b4d-4cec-ac8b-6f549a1ce217	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	60	\N	\N	37a047f1-e311-4664-b056-6f4311757b33	ALIMENPEZ  S.A.	Mar del Plata		461-9200	\N		\N	\N		t	\N	\N	\N
a89a76e8-1d5e-49f5-81ec-18c9b4c4ceeb	SUEMAR	6186	2722	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	36.60	1168	20e6681d-78b9-4d78-8fff-3549a0c294bd	CONGELADORES PATAGONICOS  S.A.	Puerto Madryn		0280-445-6280	\N		\N	\N		t	\N	\N	\N
177a767f-e331-4bd6-a13c-81438fa4e035	SUEMAR DOS	01508	\N	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	\N	\N	20e6681d-78b9-4d78-8fff-3549a0c294bd	CONGELADORES PATAGONICOS  S.A.	Puerto Madryn		0280-445-6280	\N		\N	\N		t	\N	\N	\N
423a5089-bd4b-4fb3-b7f5-612730218289	SUMATRA	01105	2512	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	33.15	750	37a047f1-e311-4664-b056-6f4311757b33	CALME  S.A.	Mar del Plata		480-3545	\N		\N	\N		t	\N	\N	\N
9e893fae-d570-4c00-ace4-4537957fcfa6	SUR ESTE 501	01077	\N	f3a8852c-766a-409f-995c-6d9d53dc3f05	95280ce6-e001-4c71-9c64-3994bf8beb53	\N	30	\N	\N	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	SUR ESTE ARGEN  S.A.	Ciudad Autónoma de Buenos Aires		011-4816-7648 / 4372-7605	\N		\N	\N		t	\N	\N	\N
a837a831-2b14-4528-92f8-251b385816e7	SUR ESTE 502	02201	2520	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	54.60	1670	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	SUR ESTE ARGEN  S.A.	Ciudad Autónoma de Buenos Aires		011-4816-7648 / 4372-7605	\N		\N	\N		t	\N	\N	\N
941500ba-2e24-4e6a-81dd-17961705263f	SURIMI I	06143	\N	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	\N	\N	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	FARO DEL SUR TRADING  S.A.	Ciudad Autónoma de Buenos Aires		011-4555-4956	\N		\N	\N		t	\N	\N	\N
76f4c394-8c00-4e04-a4b6-95f51d330aee	TABEIRON	02233	2529	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	40	34.15	889	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	VIEIRA ARGENTINA  S.A.	Ciudad Autónoma de Buenos Aires			\N		\N	\N		t	\N	\N	\N
03a1e8eb-d42a-42b7-88f1-b624371cfb60	TABEIRON DOS	02323	\N	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	\N	\N	be29702b-a6a9-434d-8eb3-5705e0f7468f	PESQUERA DESEADO  S.A.	Puerto Deseado	54-11-65337853	0297-487-0884 / 0327 / 2407	\N		\N	\N	Natalia Cedrato	t	\N	\N	\N
3172f998-a97e-48ae-ac92-83970c0c7f3c	Nº 75 TAE BAEK	02364	2138	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	55.70	1302	20e6681d-78b9-4d78-8fff-3549a0c294bd	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
b89ec25e-dc16-47b7-81d3-3814883d1500	Nº 606 TAE BAEK	02361	2148	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	55.22	1036	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	ESAMAR  S.A.	Ciudad Autónoma de Buenos Aires		011-4393-8431	\N		\N	\N	54 – 9 - 1141714381	t	\N	\N	\N
bb1bd759-4ddb-437f-a8f4-a85cf4b0f164	TAI AN	1530	2533	3d12af20-a640-4760-a148-43da27100340	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	60	100.50	4506	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	PRODESUR S.A	Ciudad Autónoma de Buenos Aires		492-2216 / 492-0450	\N		\N	\N	54 – 9 - 1141714381	t	\N	\N	\N
331d70ec-60a4-49b3-8986-abbb746f9e54	TAI SEI MARU N°8	02207	\N	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	\N	\N	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	CORPORACION DEL ATLANTICO SUR  S.A.	Ciudad Autónoma de Buenos Aires		011-4105-1133 int 30	\N		\N	\N		t	\N	\N	\N
66657779-d0ce-4e0d-bcbb-7ba969689ff2	TALISMAN	02263	2541	e72ee47d-c05e-422b-b740-59668cc58a73	4c123cf5-3119-4c6e-97c9-f6f6dfaf79de	1f6e6d84-215f-48d5-b131-5fe9f3e631da	30	49.95	1302	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	CENTOMAR  S.A.	Ciudad Autónoma de Buenos Aires		011-4816-6245 / 6260  int  * 35	\N		\N	\N		t	\N	\N	\N
c2deed12-01d5-4714-a7ff-67b179c21567	TANGO I	02724	2709	e72ee47d-c05e-422b-b740-59668cc58a73	4c123cf5-3119-4c6e-97c9-f6f6dfaf79de	1f6e6d84-215f-48d5-b131-5fe9f3e631da	30	50.40	1302	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	BENTONICOS DE ARGENTINA  S.A.	Ciudad Autónoma de Buenos Aires		011-5258-2400 / 4407-8240	\N		\N	\N		t	\N	\N	\N
11fa26ad-cb79-435a-a420-cfa967462a17	TANGO II	02791	2714	e72ee47d-c05e-422b-b740-59668cc58a73	4c123cf5-3119-4c6e-97c9-f6f6dfaf79de	1f6e6d84-215f-48d5-b131-5fe9f3e631da	30	50.40	1302	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	BENTONICOS DE ARGENTINA  S.A.	Ciudad Autónoma de Buenos Aires	4891227	011-5258-2400 / 4407-8240	\N	serviciosmaritimosmdq@gmail.com	\N	\N	Servicios maritimos	t	\N	\N	\N
1a79b3c7-b998-41f0-bc42-31379f878950	TESON	01541	2552	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	25.97	765	37a047f1-e311-4664-b056-6f4311757b33	RITORNO SALLUSTIO Y CICCIOTTI  S.A.	Mar del Plata		480-5508	\N		\N	\N		t	\N	\N	\N
c19c1bf7-dcdd-40b6-b174-c27fbcda66c5	TIAN YUAN	02173	\N	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	\N	\N	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	CORPORACION DEL ATLANTICO SUR  S.A.	Ciudad Autónoma de Buenos Aires		011-4105-1133 int 30	\N		\N	\N		t	\N	\N	\N
47bdabda-7612-4640-963b-93a9201a35de	TOBA MARU	0241	\N	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	\N	\N	20e6681d-78b9-4d78-8fff-3549a0c294bd	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
70412437-61a3-42c9-afd9-a5c62d9e5031	TORNYY	240	\N	e72ee47d-c05e-422b-b740-59668cc58a73	4c123cf5-3119-4c6e-97c9-f6f6dfaf79de	1f6e6d84-215f-48d5-b131-5fe9f3e631da	30	\N	\N	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	CRUSTACEOS DEL SUR  S.A.	Ciudad Autónoma de Buenos Aires		011-5218-4287	\N		\N	\N		t	\N	\N	\N
f7f65683-83ba-437b-9c51-79a149d637a5	TOZUDO	01219	2566	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	26.74	624	37a047f1-e311-4664-b056-6f4311757b33	CABO VERDE  S.A.	Mar del Plata		489-4645	\N		\N	\N		t	\N	\N	\N
7f1e005d-532b-432e-acf7-477abbd4e687	TRABAJAMOS	02904	2726	4bcfaa2a-1a55-4c30-8256-bc499d7d07dc	95280ce6-e001-4c71-9c64-3994bf8beb53	\N	4	19.94	592	be29702b-a6a9-434d-8eb3-5705e0f7468f	DESEADO FISH  S.A.	Puerto Deseado			\N		\N	\N		t	\N	\N	\N
16fac167-45d6-4e32-aa1e-75840364f8a1	UCHI	01901	2580	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	54.23	1552	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	PESQUERA SANTA ELENA S.A.I.C.	Ciudad Autónoma de Buenos Aires		011-4328-9909	\N		\N	\N		t	\N	\N	\N
7c1ce520-1a3a-4906-a459-78ebd1f31a44	UNION	01539	\N	4bcfaa2a-1a55-4c30-8256-bc499d7d07dc	95280ce6-e001-4c71-9c64-3994bf8beb53	\N	10	\N	\N	37a047f1-e311-4664-b056-6f4311757b33	RITORNO SALLUSTIO Y CICCIOTTI  S.A.	Mar del Plata		480-5508	\N		\N	\N		t	\N	\N	\N
973f9894-2fdc-45df-a299-2dd6d68b45bf	URABAIN	0612	\N	5f917487-3b4d-4cec-ac8b-6f549a1ce217	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	60	\N	\N	20e6681d-78b9-4d78-8fff-3549a0c294bd	IBERCONSA  DE ARGENTINA  S.A.	Puerto Madryn	mariano@maritimavidal.com.ar	0280-445-4324	\N		\N	\N	raul@maritimavidal.com.ar	t	\N	\N	\N
195e04e1-67d3-43d4-ab90-0116580b8d66	UR ERTZA	0377	2587	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	51.00	1482	37a047f1-e311-4664-b056-6f4311757b33	LUIS SOLIMENO e HIJOS  S.A.	Mar del Plata		489-3030	\N		\N	\N		t	\N	\N	\N
d9b0ed5e-d9f4-4a7a-9d03-80aeedcd0d8e	VALIENTE I	0211A	\N	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	\N	\N	37a047f1-e311-4664-b056-6f4311757b33	EXPLOTACION PESQ. DE LA PATAGONIA  S.A.	Mar del Plata		489-4624  /  489-0314 (astillero)	\N		\N	\N		t	\N	\N	\N
53d50da3-e802-4f5f-b276-0fbdbb05f21a	VALIENTE II	0212A	2718	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	35.30	1001	37a047f1-e311-4664-b056-6f4311757b33	EXPLOTACION PESQ. DE LA PATAGONIA  S.A.	Mar del Plata		489-4624  /  489-0314 (astillero)	\N		\N	\N	agencia@maritimavidal.com.ar	t	\N	\N	\N
c9723c77-4109-4f8f-b9a3-fe2d31997948	VENTARRON 1º	0479	2708	5f917487-3b4d-4cec-ac8b-6f549a1ce217	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	60	63.07	1969	20e6681d-78b9-4d78-8fff-3549a0c294bd	ATUNERA  ARGENTINA  S.A.	Puerto Madryn		0280-445-4324	\N		\N	\N		t	\N	\N	\N
20c4f281-d650-4a4a-baf3-f4fc7a1e88db	VERAZ	0144	2603	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	27.45	604	37a047f1-e311-4664-b056-6f4311757b33	PESQUERA VERAZ  S.A.	Mar del Plata		489-4624 / 489-0314 (astillero)	\N		\N	\N		t	\N	\N	\N
7c15a24b-0170-4674-85ed-d6a97a5e8cb9	VERDEL	0174	2604	5f917487-3b4d-4cec-ac8b-6f549a1ce217	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	60	71.70	1975	b06cb245-db92-471b-a70e-f741a6593708	IBERMAR  S.A.	Bahia Blanca		0291-457-2427	\N		\N	\N		t	\N	\N	\N
56889f10-d889-4246-8b52-e640b40030cb	VERONICA ALEJANDRA N	02292	2606	4bcfaa2a-1a55-4c30-8256-bc499d7d07dc	95280ce6-e001-4c71-9c64-3994bf8beb53	\N	4	15.30	223	a68c150f-2d39-40d2-a693-9d1b15859f5f	FARO CHUBUT  S.R.L.	Rawson		0280-449-6311	\N		\N	\N		t	\N	\N	\N
97981d82-0603-4d4b-80cb-8f2c5368eb48	VICTOR ANGELESCU	9798820	\N	201b037d-1ab0-4fb9-92aa-c9af3cff2044	\N	\N	\N	\N	\N	\N	INIDEP				\N		\N	\N		t	\N	\N	\N
461ba72d-cd2d-42e3-926f-f63806abb577	VICTORIA DEL MAR 1°	0929	\N	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	\N	\N	37a047f1-e311-4664-b056-6f4311757b33	RIPSA  S.A. ( ROSALES INDUSTRIAL PESQ. )	Mar del Plata		489-7881	\N		\N	\N		t	\N	\N	\N
7d93bae5-dd01-4f9a-a3df-ff2413694902	VICTORIA I	0554	\N	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	\N	\N	20e6681d-78b9-4d78-8fff-3549a0c294bd	PEREIRA  ARGENTINA  S.A.	Puerto Madryn		0280-445-7377 / 447-2249	\N		\N	\N		t	\N	\N	\N
f74403f2-e6ff-413f-8c27-d3f399592abb	VICTORIA II	0556	2611	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	27.40	601	37a047f1-e311-4664-b056-6f4311757b33	CRESTAS  S.A.	Mar del Plata		410-5170	\N		\N	\N		t	\N	\N	\N
530ce772-189a-4c25-8462-b5b0c5af6afb	VICTORIA P	02246	\N	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	\N	\N	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	PESQUERA SANTA ELENA S.A.I.C.	Ciudad Autónoma de Buenos Aires		011-4328-9909	\N		\N	\N		t	\N	\N	\N
f7f33e43-90ab-4200-af4f-8f418d4e60bb	VIEIRASA DIECIOCHO	2563	2615	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	67.78	1803	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	VIEIRA ARGENTINA  S.A.	Ciudad Autónoma de Buenos Aires			\N		\N	\N		t	\N	\N	\N
e76dea95-f4b4-46c1-a843-244ec6d4a851	VIEIRASA DIECISEIS	0240	2616	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	36.13	702	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	VIEIRA ARGENTINA  S.A.	Ciudad Autónoma de Buenos Aires			\N		\N	\N		t	\N	\N	\N
e162d17f-2c78-4283-8f2b-850ab28ec51d	VIEIRASA DIECISIETE	2568	2752	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	59.03	1401	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	VIEIRA ARGENTINA  S.A.	Ciudad Autónoma de Buenos Aires			\N		\N	\N		t	\N	\N	\N
af660391-ea00-4fa3-8977-4e0866fcdeb9	VIEIRASA QUINCE	0179	\N	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	\N	\N	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	VIEIRA ARGENTINA  S.A.	Ciudad Autónoma de Buenos Aires			\N		\N	\N		t	\N	\N	\N
76828991-ba38-48a0-856c-096bfeccdf42	VIENTO DEL SUR	01858	\N	3c4c96c7-1ccb-437d-8cb4-ec87500da20d	95280ce6-e001-4c71-9c64-3994bf8beb53	61617027-3911-4e52-91ac-c8612dac86c9	60	\N	\N	be29702b-a6a9-434d-8eb3-5705e0f7468f	PESPASA  S.A.	Puerto Deseado		0297-487-2030  int 12	\N		\N	\N		t	\N	\N	\N
2ddbc500-aa85-4228-a039-f315aa8c3113	VILLARINO	02178	2629	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	64.50	1776	01fc8bfe-1c87-4372-8c81-fde334c2bba5	PESCA AUSTRAL  S.A.	San Antonio Oeste		02934-49-2111	\N		\N	\N		t	\N	\N	\N
d9d59397-4b2e-47a0-a2ca-850ff9321fd2	VIRGEN DEL CARMEN	0550	\N	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	\N	\N	37a047f1-e311-4664-b056-6f4311757b33	MAR PURO  S.A.	Mar del Plata		451-1830	\N		\N	\N		t	\N	\N	\N
32d12e08-e874-48b4-bed1-370185f96fd1	VIRGEN DEL MILAGRO	02767	2725	4bcfaa2a-1a55-4c30-8256-bc499d7d07dc	95280ce6-e001-4c71-9c64-3994bf8beb53	\N	4	19.93	380	be29702b-a6a9-434d-8eb3-5705e0f7468f	UNION PESQUERA PATAGONIA  S.A.	Puerto Deseado			\N		\N	\N		t	\N	\N	\N
83ee08ce-4de7-4a71-83ba-7fdbd047be70	VIRGEN DEL ROCIO	0194	\N	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	\N	\N	20e6681d-78b9-4d78-8fff-3549a0c294bd	ALPESCA  S.A.	Puerto Madryn		0280-447-4958 / 45-1069	\N		\N	\N		t	\N	\N	\N
d776e1a5-3025-4917-8424-382a81052217	VIRGEN MARIA	0541	2645	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	56.65	1803	37a047f1-e311-4664-b056-6f4311757b33	LUIS SOLIMENO e HIJOS  S.A.	Mar del Plata		489-3030	\N		\N	\N		t	\N	\N	\N
dd845780-ad65-4b4c-9ebb-12b241b9dcfa	VIRGEN MARIA INMACULADA	0369	\N	4bcfaa2a-1a55-4c30-8256-bc499d7d07dc	95280ce6-e001-4c71-9c64-3994bf8beb53	\N	10	\N	\N	\N					\N		\N	\N		t	\N	\N	\N
7b2e1d0f-e32b-4966-9ed2-7376147613c2	WIRON  IV	01476	\N	5198f123-1489-4b07-84be-366d439f1d47	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	30	\N	\N	37a047f1-e311-4664-b056-6f4311757b33	TATURIELLO  S.A.	Mar del Plata		489-3833	\N		\N	\N		t	\N	\N	\N
38622752-1351-400f-a54d-4952a1e2b7f2	XEITOSIÑO	0403	2668	5f917487-3b4d-4cec-ac8b-6f549a1ce217	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	60	51.72	1502	37a047f1-e311-4664-b056-6f4311757b33	PESQUERA EL NAZARENO	Mar del Plata		489-9414 (of. Pers. Emb.)	\N		\N	\N		t	\N	\N	\N
ca46bcea-62e6-4160-aee3-422aa641e9c4	XIN SHI DAI N° 28	02165	2669	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	62.40	1579	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	MUELLE OCHO  S.A.	Ciudad Autónoma de Buenos Aires		011-4381-1337	\N		\N	\N		t	\N	\N	\N
e0d73aca-36b6-47be-887d-4749cbeab2de	XIN SHI JI 25	03092	2753	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	70.50	0	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	PESQUERA  20  DE NOVIEMBRE  S.A.	Ciudad Autónoma de Buenos Aires		011-4382-5011 / 4381-1337	\N		\N	\N		t	\N	\N	\N
21f7e1e2-783a-4291-84db-46a798913962	XIN SHI JI N° 88	02182	\N	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	\N	\N	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	FENIX  INTERNATIONAL  S.A.	Ciudad Autónoma de Buenos Aires		011-4381-1337	\N		\N	\N		t	\N	\N	\N
d35bb3fc-8e93-4799-9383-7e0539e11fd7	XIN SHI JI Nº 89	02903	2750	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	68.58	2685	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	FENIX  INTERNATIONAL  S.A.	Ciudad Autónoma de Buenos Aires		011-4381-1337	\N		\N	\N		t	\N	\N	\N
e2c4cf02-628f-492b-8482-665b9812676e	XIN SHI JI Nº 91	02924	2724	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	68.58	2685	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	FENIX  INTERNATIONAL  S.A.	Ciudad Autónoma de Buenos Aires		011-4381-1337	\N		\N	\N		t	\N	\N	\N
5c05d78b-8c75-4b91-83d1-57e8735fa56c	XIN SHI JI Nº 92	02930	2742	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	68.58	2685	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	FENIX  INTERNATIONAL  S.A.	Ciudad Autónoma de Buenos Aires		011-4381-1337	\N		\N	\N		t	\N	\N	\N
e3b9d2ec-8b5c-4f69-83e7-0781cef4ad61	XIN SHI JI Nº 95	02933	2732	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	68.58	2685	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	PESQUERA  20  DE NOVIEMBRE  S.A.	Ciudad Autónoma de Buenos Aires	155-282636 - Facundo	011-4382-5011 / 4381-1337	\N		\N	\N	Agencia Di Yorio	t	\N	\N	\N
a91ec463-0db0-41d7-8201-8d8ee65566f0	XIN SHI JI N° 99	02181	2674	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	65.10	2173	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	FENIX  INTERNATIONAL  S.A.	Ciudad Autónoma de Buenos Aires		011-4381-1337	\N		\N	\N		t	\N	\N	\N
6465ce1f-1ab3-42fc-9053-497afb3ded99	XIN SHI JI Nº 98	02995	\N	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	\N	\N	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	PESQUERA  20  DE NOVIEMBRE  S.A.	Ciudad Autónoma de Buenos Aires		011-4382-5011 / 4381-1337	\N		\N	\N		t	\N	\N	\N
ee11f712-7a26-4432-9df2-d47b2455bf70	YAMATO	077	\N	3d12af20-a640-4760-a148-43da27100340	95280ce6-e001-4c71-9c64-3994bf8beb53	432ad432-4f3a-45db-9952-fb1775b49969	60	\N	\N	60cc1963-ba0f-4f37-ac75-cd04fdcd2ade	PESANTAR  S.A. ( Empresa Pesq de la Patagonia y Antartida )	Ushuaia		02901-43-3449 / 43-0008 / 43-0708	\N		\N	\N		t	\N	\N	\N
d6f03171-1541-4acc-928a-ea5439373e3c	YENU	0498A	\N	f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	7bf053fd-02b7-4f5f-954e-61b3668f9611	517a5800-ded1-4a08-96cf-059e1492674f	30	\N	\N	b06cb245-db92-471b-a70e-f741a6593708	MARITIMA MONACHESI  S.A.	Bahia Blanca		0291-452-5913	\N		\N	\N		t	\N	\N	\N
caca1e4b-b8a9-4e90-a684-8a2f53cf0d44	YOKO MARU	UY252	\N	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	\N	\N	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	EMPESUR  S.A.	Ciudad Autónoma de Buenos Aires		011-4312-0123	\N		\N	\N		t	\N	\N	\N
b76fc4fb-fc9b-4a5d-b653-5e8baff389d5	ZHOU YU YI HAO	CH251	\N	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	\N	\N	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	VIEIRA ARGENTINA  S.A.	Ciudad Autónoma de Buenos Aires			\N		\N	\N		t	\N	\N	\N
5cd4a985-54fb-495d-932a-23ad8792f5a8	HOLMBERG	7918189	\N	201b037d-1ab0-4fb9-92aa-c9af3cff2044	\N	\N	\N	\N	\N	\N	INIDEP				\N		\N	\N		t	\N	\N	\N
417e47a4-b5f7-4683-bd12-de4ceabd5c47	MAR ARGENTINO	9883833	\N	201b037d-1ab0-4fb9-92aa-c9af3cff2044	\N	\N	\N	\N	\N	\N	INIDEP				\N		\N	\N		t	\N	\N	\N
1c3f98ff-d58e-4d75-8373-6fa21bb4bcf9	Hai Xiang 16	LW5157	\N	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	\N	\N	\N	PESQUERA RÍO QUEQUEN				\N		\N	\N		t	\N	\N	\N
5b38ccb7-df04-4198-9d68-2fcfe4279a0e	Hai Xiang 17	LW3286	\N	190f0241-000f-4363-8f07-aa8e2d2b94df	d383ee0b-fc50-4ae0-aec8-7230cfa231f3	c6c01567-eed9-4f78-a59d-f5aec4523577	40	\N	\N	\N	PESQUERA RÍO QUEQUEN				\N		\N	\N		t	\N	\N	\N
\.


--
-- Data for Name: capturas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.capturas (id, lance_id, especie_id, kg_captura, kg_descarte, observaciones_captura, indice_original) FROM stdin;
\.


--
-- Data for Name: error_logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.error_logs (id, "timestamp", level, source, context, "userId", "userEmail", message, stack, detail, path, method, ip) FROM stdin;
8947edfc-41f6-4f09-b2c3-c087c06ec976	2026-01-05 03:01:56.19+00	ERROR	BACKEND	GlobalExceptionFilter	a1fc8666-26de-441c-ac52-908a947e57bd	admin@obs.com	Token not valid	UnauthorizedException: Token not valid\n    at JwtStrategy.validate (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\auth\\strategies\\jwt.strategy.ts:31:19)\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async JwtStrategy.callback [as _verify] (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+passport@11.0.5_@ne_3e2e1635e1fc880657f155ecf43895f0\\node_modules\\@nestjs\\passport\\dist\\passport\\passport.strategy.js:13:44)	{"query": {"year": "2025"}, "params": {}, "exception": {"error": "Unauthorized", "message": "Token not valid", "statusCode": 401}}	/api/mareas/operativo?year=2025	GET	::1
48b92544-2cd9-49d7-a607-29a3de1ba6bd	2026-01-05 03:01:56.192+00	ERROR	BACKEND	GlobalExceptionFilter	a1fc8666-26de-441c-ac52-908a947e57bd	admin@obs.com	Token not valid	UnauthorizedException: Token not valid\n    at JwtStrategy.validate (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\auth\\strategies\\jwt.strategy.ts:31:19)\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async JwtStrategy.callback [as _verify] (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+passport@11.0.5_@ne_3e2e1635e1fc880657f155ecf43895f0\\node_modules\\@nestjs\\passport\\dist\\passport\\passport.strategy.js:13:44)	{"query": {"year": "2025"}, "params": {}, "exception": {"error": "Unauthorized", "message": "Token not valid", "statusCode": 401}}	/api/mareas/flota-por-pesqueria?year=2025	GET	::1
84e5e198-35f3-45af-82e0-ee3c955d74f1	2026-01-05 03:01:56.193+00	ERROR	BACKEND	GlobalExceptionFilter	a1fc8666-26de-441c-ac52-908a947e57bd	admin@obs.com	Token not valid	UnauthorizedException: Token not valid\n    at JwtStrategy.validate (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\auth\\strategies\\jwt.strategy.ts:31:19)\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async JwtStrategy.callback [as _verify] (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+passport@11.0.5_@ne_3e2e1635e1fc880657f155ecf43895f0\\node_modules\\@nestjs\\passport\\dist\\passport\\passport.strategy.js:13:44)	{"query": {"year": "2025"}, "params": {}, "exception": {"error": "Unauthorized", "message": "Token not valid", "statusCode": 401}}	/api/mareas/alertas/personal-fatiga?year=2025	GET	::1
f1e7c557-ff3b-4bfd-b19a-786cc13a357e	2026-01-05 03:01:56.195+00	ERROR	BACKEND	GlobalExceptionFilter	a1fc8666-26de-441c-ac52-908a947e57bd	admin@obs.com	Token not valid	UnauthorizedException: Token not valid\n    at JwtStrategy.validate (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\auth\\strategies\\jwt.strategy.ts:31:19)\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async JwtStrategy.callback [as _verify] (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+passport@11.0.5_@ne_3e2e1635e1fc880657f155ecf43895f0\\node_modules\\@nestjs\\passport\\dist\\passport\\passport.strategy.js:13:44)	{"query": {"year": "2025"}, "params": {}, "exception": {"error": "Unauthorized", "message": "Token not valid", "statusCode": 401}}	/api/mareas/kpis?year=2025	GET	::1
58c4ea45-40d6-4da5-80c2-f54c89623836	2026-01-05 03:01:56.198+00	ERROR	BACKEND	GlobalExceptionFilter	a1fc8666-26de-441c-ac52-908a947e57bd	admin@obs.com	Token not valid	UnauthorizedException: Token not valid\n    at JwtStrategy.validate (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\auth\\strategies\\jwt.strategy.ts:31:19)\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async JwtStrategy.callback [as _verify] (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+passport@11.0.5_@ne_3e2e1635e1fc880657f155ecf43895f0\\node_modules\\@nestjs\\passport\\dist\\passport\\passport.strategy.js:13:44)	{"query": {"year": "2025"}, "params": {}, "exception": {"error": "Unauthorized", "message": "Token not valid", "statusCode": 401}}	/api/mareas/alertas/informes-demorados?year=2025	GET	::1
5b86054a-03b3-4e14-b491-73234e1daeef	2026-01-05 03:01:56.201+00	ERROR	BACKEND	GlobalExceptionFilter	a1fc8666-26de-441c-ac52-908a947e57bd	admin@obs.com	Token not valid	UnauthorizedException: Token not valid\n    at JwtStrategy.validate (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\auth\\strategies\\jwt.strategy.ts:31:19)\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async JwtStrategy.callback [as _verify] (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+passport@11.0.5_@ne_3e2e1635e1fc880657f155ecf43895f0\\node_modules\\@nestjs\\passport\\dist\\passport\\passport.strategy.js:13:44)	{"query": {"year": "2025"}, "params": {}, "exception": {"error": "Unauthorized", "message": "Token not valid", "statusCode": 401}}	/api/mareas/alertas/retrasos-criticos?year=2025	GET	::1
aab07eac-3479-4747-8b00-8884aa465857	2026-01-05 03:01:56.209+00	ERROR	BACKEND	GlobalExceptionFilter	a1fc8666-26de-441c-ac52-908a947e57bd	admin@obs.com	Token not valid	UnauthorizedException: Token not valid\n    at JwtStrategy.validate (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\auth\\strategies\\jwt.strategy.ts:31:19)\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async JwtStrategy.callback [as _verify] (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+passport@11.0.5_@ne_3e2e1635e1fc880657f155ecf43895f0\\node_modules\\@nestjs\\passport\\dist\\passport\\passport.strategy.js:13:44)	{"query": {"year": "2025"}, "params": {}, "exception": {"error": "Unauthorized", "message": "Token not valid", "statusCode": 401}}	/api/mareas/workforce/status?year=2025	GET	::1
19db4ba3-e9ab-49dc-98d1-1ce9fd790aa9	2026-01-05 03:02:08.923+00	ERROR	BACKEND	GlobalExceptionFilter	a1fc8666-26de-441c-ac52-908a947e57bd	admin@obs.com	Token not valid	UnauthorizedException: Token not valid\n    at JwtStrategy.validate (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\auth\\strategies\\jwt.strategy.ts:31:19)\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async JwtStrategy.callback [as _verify] (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+passport@11.0.5_@ne_3e2e1635e1fc880657f155ecf43895f0\\node_modules\\@nestjs\\passport\\dist\\passport\\passport.strategy.js:13:44)	{"query": {}, "params": {}, "exception": {"error": "Unauthorized", "message": "Token not valid", "statusCode": 401}}	/api/admin/backup	GET	::1
8715a108-06db-4f1b-9bd2-7eafdc150e07	2026-01-05 03:01:56.218+00	ERROR	BACKEND	GlobalExceptionFilter	a1fc8666-26de-441c-ac52-908a947e57bd	admin@obs.com	Token de refresco inválido o expirado	UnauthorizedException: Token de refresco inválido o expirado\n    at AuthService.refreshAuth (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\auth\\auth.service.ts:230:13)\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async AuthController.refreshAuth (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\auth\\auth.controller.ts:58:18)\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:46:28\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-proxy.js:9:17	{"query": {}, "params": {}, "exception": {"error": "Unauthorized", "message": "Token de refresco inválido o expirado", "statusCode": 401}}	/api/auth/refresh	GET	::1
d8dddc51-daba-4f2c-85f9-d6103a53db27	2026-01-05 03:02:08.922+00	ERROR	BACKEND	GlobalExceptionFilter	a1fc8666-26de-441c-ac52-908a947e57bd	admin@obs.com	Token not valid	UnauthorizedException: Token not valid\n    at JwtStrategy.validate (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\auth\\strategies\\jwt.strategy.ts:31:19)\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async JwtStrategy.callback [as _verify] (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+passport@11.0.5_@ne_3e2e1635e1fc880657f155ecf43895f0\\node_modules\\@nestjs\\passport\\dist\\passport\\passport.strategy.js:13:44)	{"query": {}, "params": {}, "exception": {"error": "Unauthorized", "message": "Token not valid", "statusCode": 401}}	/api/admin/backup/status	GET	::1
\.


--
-- Data for Name: especies; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.especies (id, codigo, nombre_cientifico, nombre_vulgar, activo, observaciones) FROM stdin;
f1fd2c6f-c12c-472a-8252-f487e1397c9e	0000000001	Genypterus blacodes	Abadejo	t	\N
4ce6c29a-7000-4634-83ba-490afe4c8ef2	0000000002	Engraulis anchoita	Anchoíta	t	\N
a7b8d7ff-8e2e-44f3-9dcf-70537b84de6b	0000000003	Scomber japonicus	Caballa	t	\N
f833aca5-4b97-4334-ae95-9e10e9f8bba2	0000000004	Illex argentinus	Calamar	t	\N
6c0f594a-76ee-4b9d-87e2-5c2702182122	0000000005	Lithodes santolla	Centolla	t	\N
aa1634da-efdc-4415-8f08-8e58a1609b0a	0000000006	-	Especies australes	t	\N
5dc937b3-9f95-4c50-ae59-5bc151355649	0000000007	Pleoticus muelleri	Langostino	t	\N
6f5abe2b-87c9-4a84-b120-24acd96ea673	0000000008	Merluccius hubbsi	Merluza común	t	\N
acc36d5d-c3d2-4e48-97fc-93879b08b4fa	0000000009	Dissostichus eleginoides	Merluza negra	t	\N
a1b31c2f-dd47-49a0-ac47-a2e2f64685f5	0000000010	Zygochlamys patagonica	Vieira	t	\N
\.


--
-- Data for Name: estados_marea; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.estados_marea (id, codigo, nombre, descripcion, categoria, orden, es_inicial, es_final, permite_carga_archivos, permite_correccion, permite_informe, activo, mostrar_en_panel) FROM stdin;
aab079f3-c217-451a-ae9e-b8628d2d6cc7	DESIGNADA	Designada	\N	PENDIENTE	1	t	f	f	f	f	t	t
0b46e998-9ceb-454e-b621-5ae9c2d4e47f	EN_EJECUCION	En ejecución	\N	PENDIENTE	2	f	f	f	f	f	t	t
c8c59e8f-a7af-45d0-8938-6128a74f3d1a	ESPERANDO_ENTREGA	Esperando entrega de datos	\N	PENDIENTE	3	f	f	f	f	f	t	t
869ccd5c-68a7-4bf7-a0ef-6200b1c2c119	ENTREGADA_RECIBIDA	Entregada / Recibida	\N	PENDIENTE	4	f	f	t	f	f	t	t
81096fea-40d1-4988-9a02-588fb19ecd6c	VERIFICACION_INICIAL	Verificación inicial	\N	EN_CURSO	5	f	f	t	f	f	t	t
d162fa52-c9f6-4a58-95c7-7a4f00e8c61d	EN_CORRECCION	En corrección interna	\N	EN_CURSO	6	f	f	t	t	f	t	t
da2e1c81-0b09-436a-bf14-ed2232f3efef	DELEGADA_EXTERNA	Delegada / En espera externa	\N	EN_CURSO	7	f	f	t	f	f	t	f
512e920a-9dc6-400b-bae2-578198852527	PENDIENTE_DE_INFORME	Pendiente de informe	\N	EN_CURSO	8	f	f	f	f	t	t	t
913c4ac6-ce74-40d0-a981-1e718cdfbdbb	ESPERANDO_REVISION	Esperando revisión de informe	\N	EN_CURSO	9	f	f	f	f	t	t	f
148db481-40b1-4ec5-9761-e88f6ac5b415	PARA_PROTOCOLIZAR	Para protocolizar	\N	EN_CURSO	10	f	f	f	f	t	t	f
f3539a8d-995c-4f58-8e4f-83e991c5569d	ESPERANDO_PROTOCOLIZACION	Esperando protocolización	\N	EN_CURSO	11	f	f	f	f	t	t	f
f19efdbe-abe2-46f8-aa4b-69f979ffbea7	PROTOCOLIZADA	Protocolizada / Finalizada	\N	COMPLETADO	12	f	t	f	f	t	t	f
6d165fcf-b452-43c9-9ca9-8d7d0ce9cfad	CANCELADA	Cancelada / Desestimada	\N	CANCELADO	13	f	t	f	f	f	t	f
\.


--
-- Data for Name: lances; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lances (id, etapa_id, numero_lance, fecha, cod_arte_pesca, tipo_arte_pesca, hora_inicio, lat_inicio, long_inicio, prof_inicio, hora_final, lat_final, long_final, prof_final, rumbo, distancia_red, velocidad_arrastre, tiempo_red, estacion_gral, calador, fondo_min, fondo_max, tamiz, area_barrida, captura_total_kg, descarte_total_kg, observaciones_lance, mus, fuente_dato) FROM stdin;
\.


--
-- Data for Name: mareas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mareas (id, anio_marea, nro_marea, id_buque, id_arte_principal, id_estado_actual, fecha_zarpada_estimada, fecha_inicio_observador, fecha_fin_observador, dias_zona_austral, tipo_calculo_zona_austral, titulo, descripcion, nro_protocolizacion, anio_protocolizacion, fecha_protocolizacion, fecha_creacion, fecha_ultima_actualizacion, activo, observaciones, tipo_marea, dias_estimados) FROM stdin;
f4d5d6dd-c1a9-4531-9d6b-a85191dd2f99	2025	1	e381544d-176f-4983-9515-3da39f54e189	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-01-03 03:00:00+00	\N	\N	32	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:39.939+00	2026-01-05 03:01:39.939+00	t	Importada de JSONL. Empresa: ESTREMAR. Especie: MERLUZA AUSTRAL	MC	60
c53a7382-c285-4dfb-a2b6-7508c18f0095	2025	2	0d1e807a-8707-4528-b2ea-2ed91f014f83	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-01-03 03:00:00+00	\N	\N	23	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:39.962+00	2026-01-05 03:01:39.962+00	t	Importada de JSONL. Empresa: ARGENOVA. Especie: MERLUZA AUSTRAL	MC	60
0c2d4e6d-edf5-437e-afcb-0e77acc2d462	2025	3	c77c081f-1b19-422d-acc6-6320c3b5e9cd	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-01-03 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:39.974+00	2026-01-05 03:01:39.974+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: CENTOLLA	MC	30
9ec74ea6-8e30-42ab-878b-8d7656d2d7eb	2025	4	f7a6eabd-57fe-4ea3-a5c8-3076b1d4364a	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-01-12 03:00:00+00	\N	\N	4	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:39.985+00	2026-01-05 03:01:39.985+00	t	Importada de JSONL. Empresa: PEDRO MOSCUZZA E HIJO. Especie: MERLUZA	MC	30
463aafe4-c835-4b72-b746-1fcbc8942bf7	2025	5	9fe27daa-eac2-4402-944f-e75aba80cea9	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-01-08 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:39.994+00	2026-01-05 03:01:39.994+00	t	Importada de JSONL. Empresa: PESQUERA GEMINIS. Especie: MERLUZA	MC	30
cbda1076-4e30-4256-b12f-f21ecf1c6bc6	2025	6	72f182ca-e84f-464e-9bd0-01039544a69f	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-01-09 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.002+00	2026-01-05 03:01:40.002+00	t	Importada de JSONL. Empresa: PESQUERA CERES. Especie: CALAMAR	MC	30
d893ae69-0bf1-455c-a872-f68a70b358e6	2025	7	0f3a3f1f-10b2-44b7-b3a8-2cffc1f72d8d	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-01-07 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.01+00	2026-01-05 03:01:40.01+00	t	Importada de JSONL. Empresa: ARGENOVA. Especie: CALAMAR	MC	30
a5d404c9-624e-4c51-820e-91dee3259135	2025	8	d776e1a5-3025-4917-8424-382a81052217	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-01-09 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.018+00	2026-01-05 03:01:40.018+00	t	Importada de JSONL. Empresa: LUIS SOLIMENO. Especie: MERLUZA	MC	30
ad5c98a1-0ba5-410a-8389-5490ed45c580	2025	9	56b78ea0-13da-476a-bc74-316af4625dbe	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-01-06 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.03+00	2026-01-05 03:01:40.03+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: VIEIRA	MC	30
d548b4fa-ec8f-4e10-bac4-91c223a9cd04	2025	10	06bdab70-a38c-4e21-8220-dfda3f16c5a5	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-01-11 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.039+00	2026-01-05 03:01:40.039+00	t	Importada de JSONL. Empresa: GLACIAR PESQUERA. Especie: VIEIRA	MC	30
b1e68fd3-848a-4ed1-b1c8-1875d0e2837a	2025	11	2f902725-8860-4e05-ad27-eed37ca6f379	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-01-08 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.047+00	2026-01-05 03:01:40.047+00	t	Importada de JSONL. Empresa: FOOD ARTZ S.A.. Especie: CALAMAR	MC	30
ecae7b37-a7a2-4b80-a7d7-068fc2398713	2025	12	29173488-2c4c-4c8d-9d91-e68cfda67140	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-01-09 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.054+00	2026-01-05 03:01:40.054+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: VIEIRA	MC	30
b2c95fb4-a60b-4a5a-b7ae-3baf33a18767	2025	13	7d288fe2-8afb-4720-ab36-d83d8a20e36b	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-01-09 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.062+00	2026-01-05 03:01:40.062+00	t	Importada de JSONL. Empresa: FOOD PARTNERS PATAGONIA. Especie: CENTOLLA	MC	30
e68165c2-46ca-4008-b4e7-ef8b75d157f2	2025	14	66d2fd09-8c49-4698-aa7d-c1111c7b766e	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-01-09 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.069+00	2026-01-05 03:01:40.069+00	t	Importada de JSONL. Empresa: PEDRO MOSCUZZA E HIJO. Especie: CALAMAR	MC	30
7b6b4568-dbc3-48fd-8fb4-2f0aa88cc3bc	2025	15	c226f5ed-4f64-4623-bfc2-77d7e32fcec3	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-01-11 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.076+00	2026-01-05 03:01:40.076+00	t	Importada de JSONL. Empresa: PESQUERA VERAZ. Especie: MERLUZA	MC	30
325b4e0f-b997-4e21-8b27-4d1f1ff7ca87	2025	16	4010465b-d1f8-4d59-8822-ab55611e8453	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-01-16 03:00:00+00	\N	\N	11	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.088+00	2026-01-05 03:01:40.088+00	t	Importada de JSONL. Empresa: GLACIAR PESQUERA. Especie: VIEIRA	MC	30
b89f238c-836c-444f-9c0b-790457faddb3	2025	17	53e0c2e5-0460-4eff-be7f-267194bf6671	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-01-17 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.095+00	2026-01-05 03:01:40.095+00	t	Importada de JSONL. Empresa: ALTAMARE S.AS. Especie: CALAMAR	MC	30
39b6414c-3bb0-4650-bee2-a81857c56d3f	2025	18	018d5147-4d20-45ec-a14f-e174d98f45c5	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-01-17 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.102+00	2026-01-05 03:01:40.102+00	t	Importada de JSONL. Empresa: ALTAMARE S.AS. Especie: CALAMAR	MC	30
5e199f6e-8528-4ca4-b5ac-265352ec2a2e	2025	19	c2deed12-01d5-4714-a7ff-67b179c21567	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-01-28 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.109+00	2026-01-05 03:01:40.109+00	t	Importada de JSONL. Empresa: BENTONICOS DE ARGENTINA. Especie: CENTOLLA	MC	30
89772426-f84f-4ada-8b95-8d6aa7cfa20c	2025	20	72f182ca-e84f-464e-9bd0-01039544a69f	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-01-28 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.116+00	2026-01-05 03:01:40.116+00	t	Importada de JSONL. Empresa: GIORNO. Especie: CALAMAR	MC	30
6f309090-03de-434d-9131-af389005591e	2025	21	b00375b1-e900-443b-9607-700315b6073c	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-02-04 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.124+00	2026-01-05 03:01:40.124+00	t	Importada de JSONL. Empresa: CRUSTACEOS DEL SUR S.A. Especie: CENTOLLA	MC	30
58b2cc59-4ce6-4c3c-9506-efd04f5f9fe6	2025	22	b64c9d9f-cf9e-42e6-9aa0-3bfe45268906	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-02-01 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.131+00	2026-01-05 03:01:40.131+00	t	Importada de JSONL. Empresa: ARGENOVA. Especie: CALAMAR	MC	30
a98df442-7c41-45ea-9930-24f476d56edb	2025	23	7c106d36-6444-485a-a798-b4b0fbf80df2	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-01-28 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.138+00	2026-01-05 03:01:40.138+00	t	Importada de JSONL. Empresa: ARBUMASA S.A. Especie: CALAMAR	MC	30
72a503ff-be44-4903-8ace-f5b85133c725	2025	24	0d1e807a-8707-4528-b2ea-2ed91f014f83	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-01-31 03:00:00+00	\N	\N	22	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.149+00	2026-01-05 03:01:40.149+00	t	Importada de JSONL. Empresa: ARGENOVA. Especie: MERLUZA AUSTRAL	MC	30
8a4355c0-e5d2-4435-a639-941e1dc3aa61	2025	25	11fa26ad-cb79-435a-a420-cfa967462a17	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-02-01 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.155+00	2026-01-05 03:01:40.155+00	t	Importada de JSONL. Empresa: BENTONICOS DE ARGENTINA. Especie: CENTOLLA	MC	30
dd74d6ee-dd23-4c5d-ba00-525c4f9f8fd9	2025	26	c9723c77-4109-4f8f-b9a3-fe2d31997948	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-02-02 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.162+00	2026-01-05 03:01:40.162+00	t	Importada de JSONL. Empresa: GIORNO. Especie: MERLUZA	MC	30
9265e7ad-9de9-442b-aefc-150d54383eff	2025	27	8967d5fd-2d02-4edd-ae1b-728d6d50e876	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-01-31 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.17+00	2026-01-05 03:01:40.17+00	t	Importada de JSONL. Empresa: CHIARPESCA. Especie: CALAMAR	MC	30
29f27275-d380-447a-b747-c02ae504eb21	2025	28	a2be240a-9024-4471-9e79-76a93c9e7a8d	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-02-06 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.179+00	2026-01-05 03:01:40.179+00	t	Importada de JSONL. Empresa: PESANTAR. Especie: CALAMAR	MC	60
69e3d2f2-a9ef-4835-b552-39aad08db439	2025	29	c05a98c2-9f01-4b09-9796-c331f584b9b4	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-02-03 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.186+00	2026-01-05 03:01:40.186+00	t	Importada de JSONL. Empresa: EL MARISCO. Especie: MERLUZA	MC	30
722d324c-0857-4d81-8060-635b4ab9aab4	2025	30	e381544d-176f-4983-9515-3da39f54e189	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-02-12 03:00:00+00	\N	\N	83	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.193+00	2026-01-05 03:01:40.193+00	t	Importada de JSONL. Empresa: ESTREMAR. Especie: MERLUZA AUSTRAL	MC	30
47511b2d-107a-4f1b-bf6f-8e1f38966664	2025	31	56b78ea0-13da-476a-bc74-316af4625dbe	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-02-02 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.2+00	2026-01-05 03:01:40.2+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: VIEIRA	MC	30
0e1565c4-461d-4a6f-870c-4bac59f82d9e	2025	32	bb1bd759-4ddb-437f-a8f4-a85cf4b0f164	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-02-19 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.206+00	2026-01-05 03:01:40.206+00	t	Importada de JSONL. Empresa: PRODESUR. Especie: MERLUZA AUSTRAL	MC	60
61538cfa-6bd1-4fc7-827f-f99cb7fc1788	2025	33	c226f5ed-4f64-4623-bfc2-77d7e32fcec3	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-02-14 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.212+00	2026-01-05 03:01:40.212+00	t	Importada de JSONL. Empresa: PESQUERA VERAZ. Especie: MERLUZA	MC	30
6ccdc741-2631-43c6-88cd-0573ffbc1306	2025	34	06bdab70-a38c-4e21-8220-dfda3f16c5a5	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-02-27 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.22+00	2026-01-05 03:01:40.22+00	t	Importada de JSONL. Empresa: GLACIAR PESQUERA. Especie: VIEIRA	MC	30
3cbbcca9-eb17-4f36-be5e-3a768e4183df	2025	35	0d1e807a-8707-4528-b2ea-2ed91f014f83	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-02-25 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.228+00	2026-01-05 03:01:40.228+00	t	Importada de JSONL. Empresa: ARGENOVA. Especie: MERLUZA AUSTRAL	MC	30
6bd94f84-48de-4f14-80c8-4335a20cbe35	2025	36	29173488-2c4c-4c8d-9d91-e68cfda67140	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-02-20 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.237+00	2026-01-05 03:01:40.237+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: VIEIRA	MC	30
5f071d47-ba33-4ec4-a5f4-57f045f08bec	2025	37	2e11dfca-6858-47ef-973f-c98f57b21a78	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-02-21 03:00:00+00	\N	\N	29	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.246+00	2026-01-05 03:01:40.246+00	t	Importada de JSONL. Empresa: CRUSTACEOS DEL SUR S.A. Especie: CENTOLLA	MC	30
76275716-c459-4453-ac02-198adf1b3be4	2025	38	c77c081f-1b19-422d-acc6-6320c3b5e9cd	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-03-05 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.254+00	2026-01-05 03:01:40.254+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: CENTOLLA	MC	30
cad8958f-53f0-4ae6-89b1-ee0b8fdfc076	2025	39	c2deed12-01d5-4714-a7ff-67b179c21567	\N	6d165fcf-b452-43c9-9ca9-8d7d0ce9cfad	2025-03-06 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.262+00	2026-01-05 03:01:40.262+00	t	Importada de JSONL. Empresa: BENTONICOS DE ARGENTINA. Especie: CENTOLLA	MC	30
ab19ecb3-e73d-4fa1-9d62-e105c7a1ea92	2025	40	4010465b-d1f8-4d59-8822-ab55611e8453	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-03-06 03:00:00+00	\N	\N	6	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.268+00	2026-01-05 03:01:40.268+00	t	Importada de JSONL. Empresa: GLACIAR PESQUERA. Especie: VIEIRA	MC	30
3b297da9-528f-46ab-b118-79aae24c63f6	2025	41	06014117-579d-40e0-9289-e634cf96cccc	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-03-03 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.276+00	2026-01-05 03:01:40.276+00	t	Importada de JSONL. Empresa: FOOD ARTS S.A. Especie: CALAMAR	MC	30
fe7bb24a-e5be-46e8-8498-3080ccb883a1	2025	42	f7f65683-83ba-437b-9c51-79a149d637a5	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-03-07 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.284+00	2026-01-05 03:01:40.284+00	t	Importada de JSONL. Empresa: TOZUDO. Especie: P.ABADEJO	MC	30
815a4e3f-3ed7-411d-9c25-22093e4dcc17	2025	43	d5d6563f-07b2-4fdc-adf7-b8a9fe0928f7	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-03-07 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.295+00	2026-01-05 03:01:40.295+00	t	Importada de JSONL. Empresa: PESQUERA SIEMPRE GAUCHO. Especie: P.ABADEJO	MC	30
85524d4b-ba88-4576-89bb-d7d01e6285cb	2025	44	8a8fd4a9-d70d-40e4-85de-6fd7236553c5	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-03-07 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.305+00	2026-01-05 03:01:40.305+00	t	Importada de JSONL. Empresa: LOBA PESQUERA. Especie: P.ABADEJO	MC	30
e44e4eea-2153-4fc0-be3d-b85bf1cd7703	2025	45	d1e7c1b9-fce2-41dd-af6b-4a1c1fef1101	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-03-07 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.314+00	2026-01-05 03:01:40.314+00	t	Importada de JSONL. Empresa: ROMFIOC S.R.L. Especie: P.ABADEJO	MC	30
2eccb65c-7ba1-445b-ae33-b4f2edda0a1f	2025	46	1a79b3c7-b998-41f0-bc42-31379f878950	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-03-07 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.323+00	2026-01-05 03:01:40.323+00	t	Importada de JSONL. Empresa: MAREA OPTIMA. Especie: P.ABADEJO	MC	30
63b4e615-64a1-4e39-b31c-998b167d1d9d	2025	47	b00375b1-e900-443b-9607-700315b6073c	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-03-12 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.331+00	2026-01-05 03:01:40.331+00	t	Importada de JSONL. Empresa: CRUSTACEOS DEL SUR S.A. Especie: CENTOLLA	MC	30
0c6606f5-9faf-4625-bb98-dd50a576f56a	2025	48	66657779-d0ce-4e0d-bcbb-7ba969689ff2	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-03-12 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.338+00	2026-01-05 03:01:40.338+00	t	Importada de JSONL. Empresa: CENTOMAR S.A. Especie: CENTOLLA	MC	30
c81bf48b-2bc8-4559-abab-ed13dc491b26	2025	49	cac3efa4-7b4f-410a-b74c-7095ce14a038	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-03-18 03:00:00+00	\N	\N	27	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.345+00	2026-01-05 03:01:40.345+00	t	Importada de JSONL. Empresa: ESTRELLA PATAGONICA. Especie: MERLUZA	MC	30
e065843b-d7f0-44b1-9ea4-db81b310857a	2025	50	87b6dea5-fea1-48e5-8033-8cd680a1d3b2	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-03-22 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.352+00	2026-01-05 03:01:40.352+00	t	Importada de JSONL. Empresa: MOSCUZZA. Especie: CALAMAR	MC	30
aa8cde01-3ee1-41f8-bf1d-85d023d4cd9b	2025	51	56b78ea0-13da-476a-bc74-316af4625dbe	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-03-24 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.359+00	2026-01-05 03:01:40.359+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: VIEIRA	MC	30
dac627e7-31b8-4253-be67-cdc80afc4e5d	2025	52	0d1e807a-8707-4528-b2ea-2ed91f014f83	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-03-27 03:00:00+00	\N	\N	25	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.365+00	2026-01-05 03:01:40.365+00	t	Importada de JSONL. Empresa: ARGENOVA. Especie: MERLUZA AUSTRAL	MC	30
7dc6a248-1a3d-4550-b89a-a2cb6d6c668e	2025	53	66d2fd09-8c49-4698-aa7d-c1111c7b766e	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-03-28 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.372+00	2026-01-05 03:01:40.372+00	t	Importada de JSONL. Empresa: PEDRO MOSCUZZA E HIJO. Especie: CALAMAR	MC	30
c451f829-9418-46b9-b588-b75e7a8b7f09	2025	54	29173488-2c4c-4c8d-9d91-e68cfda67140	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-04-09 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.379+00	2026-01-05 03:01:40.379+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: VIEIRA	MC	30
b495ea11-47f7-43c5-90f4-323acb2faf27	2025	55	bb1bd759-4ddb-437f-a8f4-a85cf4b0f164	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-04-17 03:00:00+00	\N	\N	1	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.386+00	2026-01-05 03:01:40.386+00	t	Importada de JSONL. Empresa: PRODESUR. Especie: MERLUZA AUSTRAL	MC	60
eb672390-8555-4690-a534-dca0d189a8d6	2025	56	a2be240a-9024-4471-9e79-76a93c9e7a8d	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-04-10 03:00:00+00	\N	\N	39	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.393+00	2026-01-05 03:01:40.393+00	t	Importada de JSONL. Empresa: PESANTAR. Especie: MERLUZA AUSTRAL	MC	60
9bd5e91b-9157-42ab-9593-f15cc284c35a	2025	57	c2deed12-01d5-4714-a7ff-67b179c21567	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-04-09 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.399+00	2026-01-05 03:01:40.399+00	t	Importada de JSONL. Empresa: BENTONICOS DE ARGENTINA. Especie: CENTOLLA	MC	30
be4d0d19-dbe4-4272-aee9-0a67719c2ab6	2025	58	e162d17f-2c78-4283-8f2b-850ab28ec51d	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-04-22 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.406+00	2026-01-05 03:01:40.406+00	t	Importada de JSONL. Empresa: VIERA ARGENTINA. Especie: CALAMAR	MC	30
9df86d22-596b-42af-9ba9-ff59a635af53	2025	59	06bdab70-a38c-4e21-8220-dfda3f16c5a5	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-04-10 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.415+00	2026-01-05 03:01:40.415+00	t	Importada de JSONL. Empresa: GLACIAR PESQUERA. Especie: VIEIRA	MC	30
8db2e4dd-fd8c-4319-88ce-a7a82303f7a2	2025	60	c77c081f-1b19-422d-acc6-6320c3b5e9cd	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-04-10 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.422+00	2026-01-05 03:01:40.422+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: CENTOLLA	MC	30
db42b137-ba3f-4ffb-9254-cbcb2ea2f27e	2025	61	4010465b-d1f8-4d59-8822-ab55611e8453	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-04-17 03:00:00+00	\N	\N	6	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.428+00	2026-01-05 03:01:40.428+00	t	Importada de JSONL. Empresa: GLACIAR PESQUERA. Especie: VIEIRA	MC	30
6831ad38-08e6-4501-bd81-15169a9ac02e	2025	62	bb008605-e4d6-4cb1-b631-6ce1ef38d969	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-04-15 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.437+00	2026-01-05 03:01:40.437+00	t	Importada de JSONL. Empresa: ALTAMARE S.AS. Especie: CALAMAR	MC	30
6be38161-1215-421d-a805-8626e66fa481	2025	63	31dc0fcb-f580-4a21-8b39-edc7f9f5becd	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-04-11 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.445+00	2026-01-05 03:01:40.445+00	t	Importada de JSONL. Empresa: PESCARGEN. Especie: LANGOSTINO	MC	30
82583380-f465-4e87-a996-745c82d08679	2025	64	c9723c77-4109-4f8f-b9a3-fe2d31997948	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-04-22 03:00:00+00	\N	\N	6	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.456+00	2026-01-05 03:01:40.456+00	t	Importada de JSONL. Empresa: GIORNO. Especie: MERLUZA	MC	30
d8dfb3a7-6584-49fd-b971-7cf781471f80	2025	65	aa820574-0468-4528-b1fb-a6ce85025db5	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-04-15 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.465+00	2026-01-05 03:01:40.465+00	t	Importada de JSONL. Empresa: LUIS SOLIMENO. Especie: MERLUZA	MC	30
4711834a-ece0-4559-9153-caf7ed073090	2025	66	f9c93ebc-108c-4fb7-a6ae-e18780197bde	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-04-21 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.483+00	2026-01-05 03:01:40.483+00	t	Importada de JSONL. Empresa: MARÍTIMA COMERCIAL. Especie: MERLUZA	MC	30
9faddd71-cea4-4ad1-845e-3cff92261ec0	2025	67	ee82a79d-9d3e-4459-9fa6-b8ef352cbc65	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-04-29 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.493+00	2026-01-05 03:01:40.493+00	t	Importada de JSONL. Empresa: NIETOS ANTONIO BALDINO. Especie: MERLUZA	MC	30
2a5a7a70-6c10-4d54-9308-324c2d652400	2025	68	8d598b63-a3b5-4909-a279-b4504e70cea4	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-04-23 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.499+00	2026-01-05 03:01:40.499+00	t	Importada de JSONL. Empresa: MOSCUZZA. Especie: MERLUZA	MC	30
822da010-04f1-4ec8-a940-099f898834d0	2025	69	87b6dea5-fea1-48e5-8033-8cd680a1d3b2	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-04-26 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.512+00	2026-01-05 03:01:40.512+00	t	Importada de JSONL. Empresa: MOSCUZZA. Especie: CALAMAR	MC	30
802b7c64-46ba-4868-a819-490b842338d5	2025	70	c9c59757-d121-4e91-ab01-1969855a023d	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-04-25 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.519+00	2026-01-05 03:01:40.519+00	t	Importada de JSONL. Empresa: MARONTI  S.A.. Especie: MERLUZA	MC	30
6c8fcf21-dcff-4139-9f0e-135cc6d208c6	2025	71	8967d5fd-2d02-4edd-ae1b-728d6d50e876	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-04-24 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.528+00	2026-01-05 03:01:40.528+00	t	Importada de JSONL. Empresa: GRUPO CHIAR PESCA. Especie: CALAMAR	MC	30
ec01d89c-d0f0-45d4-8579-bdd5fb0e38d8	2025	72	0d1e807a-8707-4528-b2ea-2ed91f014f83	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-04-29 03:00:00+00	\N	\N	24	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.536+00	2026-01-05 03:01:40.536+00	t	Importada de JSONL. Empresa: ARGENOVA. Especie: MERLUZA AUSTRAL	MC	30
816c5edd-457a-4c93-a659-17168077a513	2025	73	a300bb3c-6eed-423c-b957-673ecee5e140	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-04-26 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.542+00	2026-01-05 03:01:40.542+00	t	Importada de JSONL. Empresa: BUENA PROA. Especie: MERLUZA	MC	30
669baadc-57e0-44f7-8cc0-f517f6a8336f	2025	74	31cb29fe-cb99-4c7e-a5f8-6049f4defe5d	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-04-30 03:00:00+00	\N	\N	7	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.554+00	2026-01-05 03:01:40.554+00	t	Importada de JSONL. Empresa: GIORNO. Especie: MERLUZA	MC	30
8dd829f7-8da0-427e-9c83-4d55ad83657c	2025	75	e381544d-176f-4983-9515-3da39f54e189	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-05-07 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.561+00	2026-01-05 03:01:40.561+00	t	Importada de JSONL. Empresa: ESTREMAR. Especie: MERLUZA AUSTRAL	MC	30
aa09f3a7-455a-4049-8485-805b533ce378	2025	76	56b78ea0-13da-476a-bc74-316af4625dbe	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-05-07 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.567+00	2026-01-05 03:01:40.567+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: VIEIRA	MC	30
58940af6-143f-47ab-9d27-1fe6b8775fff	2025	77	9fe27daa-eac2-4402-944f-e75aba80cea9	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-05-04 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.574+00	2026-01-05 03:01:40.574+00	t	Importada de JSONL. Empresa: GIORNO. Especie: MERLUZA	MC	30
a4abdee9-4460-41c7-978b-c0456ca12255	2025	78	2f902725-8860-4e05-ad27-eed37ca6f379	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-05-06 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.581+00	2026-01-05 03:01:40.581+00	t	Importada de JSONL. Empresa: FOOD ARTS S.A. Especie: CALAMAR	MC	30
e663b06f-1766-4d56-933f-11f3cce93a6c	2025	79	66d2fd09-8c49-4698-aa7d-c1111c7b766e	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-05-06 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.588+00	2026-01-05 03:01:40.588+00	t	Importada de JSONL. Empresa: MOSCUZZA. Especie: CALAMAR	MC	30
c8a60b46-61ec-4a5b-a60b-73f59b7deba6	2025	80	31dc0fcb-f580-4a21-8b39-edc7f9f5becd	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-05-10 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.596+00	2026-01-05 03:01:40.596+00	t	Importada de JSONL. Empresa: PESCAREN S.A. Especie: LANGOSTINO	MC	30
c20db1f6-5e12-48dc-b54c-0a822b868083	2025	81	c77c081f-1b19-422d-acc6-6320c3b5e9cd	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-05-15 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.602+00	2026-01-05 03:01:40.602+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: CENTOLLA	MC	30
903435c7-495f-4fb7-b02d-1a734cb99f5d	2025	82	a2be240a-9024-4471-9e79-76a93c9e7a8d	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-05-22 03:00:00+00	\N	\N	50	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.608+00	2026-01-05 03:01:40.608+00	t	Importada de JSONL. Empresa: PESANTAR. Especie: MERLUZA AUSTRAL	MC	60
3ffea578-dfbe-43d0-8618-d3c0916e949d	2025	83	f7a6eabd-57fe-4ea3-a5c8-3076b1d4364a	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-05-17 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.614+00	2026-01-05 03:01:40.614+00	t	Importada de JSONL. Empresa: MOSCUZZA. Especie: MERLUZA	MC	30
cd411ab4-b3e8-4fed-baef-7b37af1b86e3	2025	84	cb9c062a-5532-4625-97a5-71e4ac895c40	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-05-20 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.621+00	2026-01-05 03:01:40.621+00	t	Importada de JSONL. Empresa: LUIS SOLIMENO. Especie: MERLUZA	MC	30
29c01403-2c95-450a-8420-6981562f9197	2025	85	31cb29fe-cb99-4c7e-a5f8-6049f4defe5d	\N	6d165fcf-b452-43c9-9ca9-8d7d0ce9cfad	2025-05-20 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.628+00	2026-01-05 03:01:40.628+00	t	Importada de JSONL. Empresa: GIORNO. Especie: MERLUZA	MC	30
c25af8f7-896c-4d9d-ace0-f26ef330327a	2025	86	3f7f12c7-d341-4d13-914d-4964ab294e3e	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-05-20 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.632+00	2026-01-05 03:01:40.632+00	t	Importada de JSONL. Empresa: LUIS SOLIMENO. Especie: CALAMAR	MC	30
cc9c9e19-ef52-4dcb-b11d-b99011d5ab50	2025	87	bb1bd759-4ddb-437f-a8f4-a85cf4b0f164	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-05-20 03:00:00+00	\N	\N	31	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.639+00	2026-01-05 03:01:40.639+00	t	Importada de JSONL. Empresa: PRODESUR. Especie: MERLUZA AUSTRAL	MC	60
fcb39438-a351-4e0c-88e3-9e737a188372	2025	88	29173488-2c4c-4c8d-9d91-e68cfda67140	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-05-26 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.647+00	2026-01-05 03:01:40.647+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: VIEIRA	MC	30
f01a4ca0-d8ef-4931-92ed-4b6bcc69e104	2025	89	4010465b-d1f8-4d59-8822-ab55611e8453	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-05-31 03:00:00+00	\N	\N	6	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.653+00	2026-01-05 03:01:40.653+00	t	Importada de JSONL. Empresa: GLACIAR PESQUERA. Especie: VIEIRA	MC	30
8def266d-017b-41d0-bff7-397c412c4ec7	2025	90	31dc0fcb-f580-4a21-8b39-edc7f9f5becd	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-05-28 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.66+00	2026-01-05 03:01:40.66+00	t	Importada de JSONL. Empresa: PESCARGEN. Especie: LANGOSTINO	MC	30
d4a21ba7-fc7f-44df-8fd5-8a8f5f74e5d0	2025	91	87b6dea5-fea1-48e5-8033-8cd680a1d3b2	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-05-29 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.668+00	2026-01-05 03:01:40.668+00	t	Importada de JSONL. Empresa: MOSCUZZA. Especie: CALAMAR	MC	30
e109a539-dea0-47f1-99b7-dd032223a055	2025	92	30ed84a3-464e-41fd-ad2b-d44afb4b70bd	\N	6d165fcf-b452-43c9-9ca9-8d7d0ce9cfad	2025-05-29 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.674+00	2026-01-05 03:01:40.674+00	t	Importada de JSONL. Empresa: CONARPESA. Especie: LANGOSTINO	MC	30
ab64c1e5-399e-4e4e-9b22-640cc40d73da	2025	93	06bdab70-a38c-4e21-8220-dfda3f16c5a5	\N	6d165fcf-b452-43c9-9ca9-8d7d0ce9cfad	2025-06-11 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.678+00	2026-01-05 03:01:40.678+00	t	Importada de JSONL. Empresa: GLACIAR PESQUERA. Especie: VIERA	MC	30
80b6112c-cafd-4328-9fd7-d18ebf2913e6	2025	94	195e04e1-67d3-43d4-ab90-0116580b8d66	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-06-09 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.682+00	2026-01-05 03:01:40.682+00	t	Importada de JSONL. Empresa: ARPES. Especie: MERLUZA	MC	30
a5d0be4e-80bb-4d33-80bb-7de949e17d6d	2025	95	9fe27daa-eac2-4402-944f-e75aba80cea9	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-06-06 03:00:00+00	\N	\N	1	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.696+00	2026-01-05 03:01:40.696+00	t	Importada de JSONL. Empresa: GIORNO. Especie: MERLUZA	MC	30
296c2512-6c1d-4b3a-81a5-13ad6f3eb24b	2025	96	c9723c77-4109-4f8f-b9a3-fe2d31997948	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-06-06 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.703+00	2026-01-05 03:01:40.703+00	t	Importada de JSONL. Empresa: GIORNO. Especie: MERLUZA	MC	30
86a45977-8e42-41db-8e69-c38e84e4aca3	2025	97	d1e7c1b9-fce2-41dd-af6b-4a1c1fef1101	\N	6d165fcf-b452-43c9-9ca9-8d7d0ce9cfad	2025-06-17 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.71+00	2026-01-05 03:01:40.71+00	t	Importada de JSONL. Empresa: ROMFIOC S.R.L. Especie: MERLUZA	MC	30
1a000973-b9e0-4c27-a4fd-7fd0966d0041	2025	98	e381544d-176f-4983-9515-3da39f54e189	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-06-17 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.714+00	2026-01-05 03:01:40.714+00	t	Importada de JSONL. Empresa: ESTREMAR. Especie: MERLUZA AUSTRAL	MC	30
87bdc4e9-734c-401c-846e-6a653043cc27	2025	99	a300bb3c-6eed-423c-b957-673ecee5e140	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-06-12 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.722+00	2026-01-05 03:01:40.722+00	t	Importada de JSONL. Empresa: BUENA PROA. Especie: MERLUZA	MC	30
59cfa00e-87cd-4168-8d88-2702462948b8	2025	100	56b78ea0-13da-476a-bc74-316af4625dbe	\N	6d165fcf-b452-43c9-9ca9-8d7d0ce9cfad	2025-06-17 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.737+00	2026-01-05 03:01:40.737+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: VIERA	MC	30
34e2623f-0fee-46b1-be85-42225d18fb4d	2025	101	5d4b6254-5c9e-478a-8cde-9759f18fb2e4	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-06-18 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.742+00	2026-01-05 03:01:40.742+00	t	Importada de JSONL. Empresa: BUENA PROA. Especie: P. LANGOSTINO	MC	30
56828306-4e4d-4840-8d17-7503f30fb603	2025	102	31dc0fcb-f580-4a21-8b39-edc7f9f5becd	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-06-17 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.752+00	2026-01-05 03:01:40.752+00	t	Importada de JSONL. Empresa: PESCARGEN. Especie: P. LANGOSTINO	MC	30
5c26974d-0e37-4057-850c-6090d2d77a04	2025	103	ac409c46-640d-41a2-8b03-e07f1bef54d5	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-06-17 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.758+00	2026-01-05 03:01:40.758+00	t	Importada de JSONL. Empresa: FRIGORÍFICO DON LUIS. Especie: P. LANGOSTINO	MC	30
f8464a7e-e18c-4e5f-b448-3b043143adcd	2025	104	10cd28c5-38a8-461e-855b-2abb79cac6f7	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-06-18 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.764+00	2026-01-05 03:01:40.764+00	t	Importada de JSONL. Empresa: URLIPEZ. Especie: P. LANGOSTINO	MC	30
405ce0cf-9df1-4b89-b034-3aa0c9f637c4	2025	105	153fae6a-5a15-41fa-a1a0-cda6d8a26857	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-06-19 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.77+00	2026-01-05 03:01:40.77+00	t	Importada de JSONL. Empresa: DE ANGELIS Y LOGGHE. Especie: P. LANGOSTINO	MC	30
35539d81-0628-46f1-9a21-4f073417fcaf	2025	106	7c46d61f-ebdf-4f6e-a304-0b3f762ba9ac	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-06-17 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.777+00	2026-01-05 03:01:40.777+00	t	Importada de JSONL. Empresa: PESCA ANTIGUA. Especie: P. LANGOSTINO	MC	30
5a7b54ed-1bff-450f-b467-23be688393fe	2025	107	327a92dd-b3a2-4159-a7c3-c5e367c8c0d5	\N	6d165fcf-b452-43c9-9ca9-8d7d0ce9cfad	2025-06-21 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.786+00	2026-01-05 03:01:40.786+00	t	Importada de JSONL. Empresa: IBERCONSA. Especie: MERLUZA	MC	30
1f34093e-0d7c-43a8-9834-51eb1265ad99	2025	108	aa820574-0468-4528-b1fb-a6ce85025db5	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-06-24 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.791+00	2026-01-05 03:01:40.791+00	t	Importada de JSONL. Empresa: SOLIMENO E HIJOS. Especie: MERLUZA	MC	30
a438844a-3dae-41ec-9ebf-e332a99efdf4	2025	109	06bdab70-a38c-4e21-8220-dfda3f16c5a5	\N	6d165fcf-b452-43c9-9ca9-8d7d0ce9cfad	2025-06-23 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.802+00	2026-01-05 03:01:40.802+00	t	Importada de JSONL. Empresa: GLACIAR PESQUERA. Especie: VIERA	MC	30
d6f613ac-58ed-47ae-ae62-39ddf048504d	2025	110	ac409c46-640d-41a2-8b03-e07f1bef54d5	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-06-27 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.806+00	2026-01-05 03:01:40.806+00	t	Importada de JSONL. Empresa: FRIGORÍFICO DON LUIS. Especie: P. LANGOSTINO	MC	30
16a44086-521e-4704-a757-467009e950b3	2025	111	153fae6a-5a15-41fa-a1a0-cda6d8a26857	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-06-27 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.813+00	2026-01-05 03:01:40.813+00	t	Importada de JSONL. Empresa: DE ANGELIS Y LOGGHE. Especie: P. LANGOSTINO	MC	30
09616800-ca0d-442c-916b-be99e59c8eb2	2025	112	f3a4f082-17bc-4757-8c3e-b63aa684d688	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-06-27 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.823+00	2026-01-05 03:01:40.823+00	t	Importada de JSONL. Empresa: CANAL DE BEAGLE. Especie: P. LANGOSTINO	MC	30
3ce13a74-15b7-417b-80b1-d9d5bbd51512	2025	113	c226f5ed-4f64-4623-bfc2-77d7e32fcec3	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-07-01 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.83+00	2026-01-05 03:01:40.83+00	t	Importada de JSONL. Empresa: PESQUERA VERAZ. Especie: MERLUZA	MC	30
5241ae97-f2a5-4b22-abec-562cf23cef24	2025	114	06bdab70-a38c-4e21-8220-dfda3f16c5a5	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-07-10 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.839+00	2026-01-05 03:01:40.839+00	t	Importada de JSONL. Empresa: GLACIAR PESQUERA. Especie: VIERA	MC	30
115079e9-6820-4bb8-89df-3d0ceafc1036	2025	115	56b78ea0-13da-476a-bc74-316af4625dbe	\N	6d165fcf-b452-43c9-9ca9-8d7d0ce9cfad	2025-07-08 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.845+00	2026-01-05 03:01:40.845+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: VIERA	MC	30
dd92916f-323b-4a26-a0bd-238d8ff022da	2025	116	4010465b-d1f8-4d59-8822-ab55611e8453	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-07-15 03:00:00+00	\N	\N	3	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.85+00	2026-01-05 03:01:40.85+00	t	Importada de JSONL. Empresa: GLACIAR PESQUERA. Especie: VIERA	MC	30
caf1a601-4b21-41b1-a2f5-580c1b548b2a	2025	117	31dc0fcb-f580-4a21-8b39-edc7f9f5becd	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-07-11 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.855+00	2026-01-05 03:01:40.855+00	t	Importada de JSONL. Empresa: PESCARGEN. Especie: LANGOSTINO	MC	30
01ec393e-7986-4bc8-9630-c442d4aefeb0	2025	118	19aff04c-20a7-49b0-9a10-931cd3264acf	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-07-11 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.862+00	2026-01-05 03:01:40.862+00	t	Importada de JSONL. Empresa: BUENA PROA. Especie: LANGOSTINO	MC	30
e6c2b1a4-03a0-4db8-8aeb-eac9b8fc28b0	2025	119	7c15a24b-0170-4674-85ed-d6a97a5e8cb9	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-07-12 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.868+00	2026-01-05 03:01:40.868+00	t	Importada de JSONL. Empresa: IBERCONSA. Especie: MERLUZA	MC	30
ea4b8161-6521-4b42-9401-3c71ddf946ec	2025	120	ed3f98c6-2e1e-490d-9220-4a40c86199e3	\N	6d165fcf-b452-43c9-9ca9-8d7d0ce9cfad	2025-07-11 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.875+00	2026-01-05 03:01:40.875+00	t	Importada de JSONL. Empresa: RITONDO SALLUSTIO Y CICCIOTTI. Especie: LANGOSTINO	MC	30
70988259-cd5e-4d00-9af9-0a49e256829e	2025	121	03786476-9af3-489a-b701-ed885f7e332b	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-07-15 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.879+00	2026-01-05 03:01:40.879+00	t	Importada de JSONL. Empresa: MOSCUZZA. Especie: LANGOSTINO	MC	30
0c083497-30ba-4c77-858c-ffa2b2bdeb28	2025	122	29173488-2c4c-4c8d-9d91-e68cfda67140	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-07-16 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.892+00	2026-01-05 03:01:40.892+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: VIEIRA	MC	30
289b1223-0ef5-492f-bcb8-14b02bad96b9	2025	123	c9723c77-4109-4f8f-b9a3-fe2d31997948	\N	6d165fcf-b452-43c9-9ca9-8d7d0ce9cfad	2025-07-19 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.898+00	2026-01-05 03:01:40.898+00	t	Importada de JSONL. Empresa: GIORNO S.A. Especie: MERLUZA	MC	30
96241b47-1094-4eda-a607-b5b0a8b44611	2025	124	9fe27daa-eac2-4402-944f-e75aba80cea9	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-07-19 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.902+00	2026-01-05 03:01:40.902+00	t	Importada de JSONL. Empresa: GIORNO S.A. Especie: MERLUZA	MC	30
f8de1a64-8e6d-4842-ad7d-7881a7723cd1	2025	125	30ed84a3-464e-41fd-ad2b-d44afb4b70bd	\N	6d165fcf-b452-43c9-9ca9-8d7d0ce9cfad	2025-07-18 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.908+00	2026-01-05 03:01:40.908+00	t	Importada de JSONL. Empresa: CONARPESA. Especie: LANGOSTINO	MC	30
35d59fab-f77b-46fa-8626-379175d39606	2025	126	a300bb3c-6eed-423c-b957-673ecee5e140	\N	6d165fcf-b452-43c9-9ca9-8d7d0ce9cfad	2025-07-18 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.912+00	2026-01-05 03:01:40.912+00	t	Importada de JSONL. Empresa: BUENA PROA. Especie: LANGOSTINO	MC	30
e82d6a51-bfce-4b84-b537-ee1db264a73e	2025	127	8c448bf0-e35c-45a1-a12d-9b08d2f4ca00	\N	6d165fcf-b452-43c9-9ca9-8d7d0ce9cfad	2025-07-18 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.917+00	2026-01-05 03:01:40.917+00	t	Importada de JSONL. Empresa: CONARPESA. Especie: LANGOSTINO	MC	30
3fe69381-91ce-4052-bff2-48f90d274546	2025	128	50b6f8f5-99d3-416f-9fab-2b21f0fa1ee5	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-07-18 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.921+00	2026-01-05 03:01:40.921+00	t	Importada de JSONL. Empresa: PEDRO MOSCUZZA E HIJO. Especie: MERLUZA	MC	30
a65976dd-1491-4ee9-b721-3ce06dbb4b87	2025	129	8d598b63-a3b5-4909-a279-b4504e70cea4	\N	0b46e998-9ceb-454e-b621-5ae9c2d4e47f	2025-07-21 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.927+00	2026-01-05 03:01:40.927+00	t	Importada de JSONL. Empresa: PEDRO MOSCUZZA E HIJO. Especie: LANGOSTINO	MC	30
3bb27cfe-8fa7-4a09-810d-f21bd55addba	2025	130	327a92dd-b3a2-4159-a7c3-c5e367c8c0d5	\N	6d165fcf-b452-43c9-9ca9-8d7d0ce9cfad	2025-07-22 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.933+00	2026-01-05 03:01:40.933+00	t	Importada de JSONL. Empresa: IBERCONSA. Especie: LANGOSTINO	MC	30
bf352d58-762a-4c05-a6a1-b28b2ac90a97	2025	131	47cd0ef1-c8b2-455e-a5e5-a34df79e32f2	\N	6d165fcf-b452-43c9-9ca9-8d7d0ce9cfad	2025-07-22 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.938+00	2026-01-05 03:01:40.938+00	t	Importada de JSONL. Empresa: EMPESUR. Especie: LANGOSTINO	MC	30
b0232b93-443b-4fa2-b94d-c038164a6a74	2025	132	cafbae61-7a55-46e5-a4bf-45c3075c86b9	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-07-23 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.942+00	2026-01-05 03:01:40.942+00	t	Importada de JSONL. Empresa: BUENOS AIRES PESCA S.A. Especie: LANGOSTINO	MC	30
6bae02ae-8133-42da-ae56-6a57171931fa	2025	133	7afb571b-f697-494e-8dd8-455575849bdf	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-07-23 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.949+00	2026-01-05 03:01:40.949+00	t	Importada de JSONL. Empresa: BUENOS AIRES PESCA S.A. Especie: LANGOSTINO	MC	30
5a6960d2-64d8-432f-b799-666eb19cf046	2025	134	a300bb3c-6eed-423c-b957-673ecee5e140	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-07-25 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.956+00	2026-01-05 03:01:40.956+00	t	Importada de JSONL. Empresa: BUENA PROA. Especie: LANGOSTINO	MC	30
8cbbaf71-123a-4028-8701-1bbc9d11addb	2025	135	195e04e1-67d3-43d4-ab90-0116580b8d66	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-07-27 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.965+00	2026-01-05 03:01:40.965+00	t	Importada de JSONL. Empresa: ARPES. Especie: MERLUZA	MC	30
3d0ec652-e675-4e54-87e1-e4002c2071ae	2025	136	2e11dfca-6858-47ef-973f-c98f57b21a78	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-07-28 03:00:00+00	\N	\N	42	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.975+00	2026-01-05 03:01:40.975+00	t	Importada de JSONL. Empresa: CRUSTACEOS DEL SUR S.A. Especie: CENTOLLA	MC	60
24f70169-1959-4cab-ae23-82c5aeb0f4db	2025	137	7cce667d-39fb-4100-abb6-6a347277e353	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-07-29 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.982+00	2026-01-05 03:01:40.982+00	t	Importada de JSONL. Empresa: CENTOMAR S.A. Especie: LANGOSTINO	MC	30
05c47332-39cf-463c-a303-9e3690b20c1b	2025	138	efdb0009-e9ae-4acf-b0b9-fb9926ecda6c	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-08-04 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.989+00	2026-01-05 03:01:40.989+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: LANGOSTINO	MC	30
3668dc11-0150-465c-b59d-c095b5880edf	2025	139	19aff04c-20a7-49b0-9a10-931cd3264acf	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-08-02 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:40.997+00	2026-01-05 03:01:40.997+00	t	Importada de JSONL. Empresa: BUENA PROA. Especie: LANGOSTINO	MC	30
72322443-97cf-4b46-b456-b54631f1577a	2025	140	fd7b6525-aa63-4e5b-af4b-feece0a06683	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-08-05 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:41.003+00	2026-01-05 03:01:41.003+00	t	Importada de JSONL. Empresa: ARBUMASA S.A. Especie: LANGOSTINO	MC	30
bded166c-2909-4047-80b9-2523a44d0ffc	2025	141	3db326b5-5aaa-4c7a-9e87-e16dc027fe94	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-08-05 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:41.009+00	2026-01-05 03:01:41.009+00	t	Importada de JSONL. Empresa: ARBUMASA S.A. Especie: LANGOSTINO	MC	30
9c529880-1e35-4565-a4b7-5f8812ddab23	2025	142	d776e1a5-3025-4917-8424-382a81052217	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-08-06 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:41.015+00	2026-01-05 03:01:41.015+00	t	Importada de JSONL. Empresa: SOLIMENO E HIJOS. Especie: MERLUZA	MC	30
8757510f-9cdc-489a-bb9c-f126e2446776	2025	143	cef07932-8b97-4d14-bc5c-06cbc4831f05	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-08-07 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:41.026+00	2026-01-05 03:01:41.026+00	t	Importada de JSONL. Empresa: PEDRO MOSCUZZA E HIJO. Especie: LANGOSTINO	MC	30
263e0515-0653-47cf-aeeb-0d83c20136b7	2025	144	a54926b3-a19f-4466-9d56-3e207ef63766	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-08-07 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:41.032+00	2026-01-05 03:01:41.032+00	t	Importada de JSONL. Empresa: PEDRO MOSCUZZA E HIJO. Especie: LANGOSTINO	MC	30
3a105dee-6c85-413a-b395-c0e497f6427d	2025	145	f7869696-130e-4a0b-82a2-0db8efdda4f5	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-08-12 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:41.038+00	2026-01-05 03:01:41.038+00	t	Importada de JSONL. Empresa: ANTONIO BALDINO E HIJOS. Especie: MERLUZA	MC	30
522ff31e-b483-4499-b463-1646d7bbecf1	2025	146	c9c59757-d121-4e91-ab01-1969855a023d	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-08-14 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:41.049+00	2026-01-05 03:01:41.049+00	t	Importada de JSONL. Empresa: MARONTI  S.A.. Especie: MERLUZA	MC	30
168878f6-2c09-4c2f-96b2-7c565d714ce4	2025	147	9fe27daa-eac2-4402-944f-e75aba80cea9	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-08-19 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:41.057+00	2026-01-05 03:01:41.057+00	t	Importada de JSONL. Empresa: GIORNO S.A. Especie: MERLUZA	MC	30
c8dfc52f-c1bd-4779-b74e-934d0588d40d	2025	148	4b1864ba-a45c-4b23-b665-c9601ef0357d	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-08-18 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:41.064+00	2026-01-05 03:01:41.064+00	t	Importada de JSONL. Empresa: XEITOSIÑO. Especie: LANGOSTINO	MC	30
376dcc57-0da3-4b0b-ab36-077e5c4fa1b8	2025	149	38622752-1351-400f-a54d-4952a1e2b7f2	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-08-19 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:41.07+00	2026-01-05 03:01:41.07+00	t	Importada de JSONL. Empresa: XEITOSIÑO. Especie: LANGOSTINO	MC	30
093f8ad7-80a3-4c59-bb85-bb25945d18ec	2025	150	c72b3e15-cb50-4306-83ec-cdd566df47b7	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-08-25 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:41.076+00	2026-01-05 03:01:41.076+00	t	Importada de JSONL. Empresa: CONARPESA. Especie: LANGOSTINO	MC	30
3949773d-6744-4363-97b3-607d61d22906	2025	151	31cb29fe-cb99-4c7e-a5f8-6049f4defe5d	\N	6d165fcf-b452-43c9-9ca9-8d7d0ce9cfad	2025-08-29 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:41.082+00	2026-01-05 03:01:41.082+00	t	Importada de JSONL. Empresa: GIORNO. Especie: LANGOSTINO	MC	30
21649eab-04d0-4a6b-b2c8-adca960ecb55	2025	152	e1b68658-5585-4126-a76e-abb17ba79253	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-08-29 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:41.086+00	2026-01-05 03:01:41.086+00	t	Importada de JSONL. Empresa: PESQUERA VERAZ SA. Especie: LANGOSTINO	MC	30
540f0be6-4b03-447b-8a77-385d82878cce	2025	153	50b6f8f5-99d3-416f-9fab-2b21f0fa1ee5	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-08-30 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:41.093+00	2026-01-05 03:01:41.093+00	t	Importada de JSONL. Empresa: PEDRO MOSCUZZA E HIJO. Especie: MERLUZA	MC	30
16b0d404-798b-4c26-8e09-9a22747a1beb	2025	154	c6f2eab0-0c31-4ed2-932b-0f40ed6eeb38	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-09-05 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:41.098+00	2026-01-05 03:01:41.098+00	t	Importada de JSONL. Empresa: ARGENOVA S.A. Especie: LANGOSTINO	MC	30
a4312a3b-701d-4dd3-8f4e-366f572506cc	2025	155	29173488-2c4c-4c8d-9d91-e68cfda67140	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-09-08 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:41.105+00	2026-01-05 03:01:41.105+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: VIEIRA	MC	30
3df4eabb-5b4f-41df-8833-0b4dbc680975	2025	156	2e11dfca-6858-47ef-973f-c98f57b21a78	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-09-11 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:41.112+00	2026-01-05 03:01:41.112+00	t	Importada de JSONL. Empresa: CRUSTACEOS DEL SUR S.A. Especie: CENTOLLA	MC	30
1cfdaa5b-bcdf-416b-995e-8b9b216a34f4	2025	157	cc9753ee-bc2a-47d5-9270-f249334a4680	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-09-10 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:41.118+00	2026-01-05 03:01:41.118+00	t	Importada de JSONL. Empresa: PESCASOL S.A. Especie: MERLUZA	MC	30
4b7dd270-6186-42cb-8d04-3b3e569124dd	2025	158	3db326b5-5aaa-4c7a-9e87-e16dc027fe94	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-09-13 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:41.124+00	2026-01-05 03:01:41.124+00	t	Importada de JSONL. Empresa: ARBUMASA S.A. Especie: LANGOSTINO	MC	30
109df6bb-70d5-497b-b552-28a569ff1694	2025	159	c77c081f-1b19-422d-acc6-6320c3b5e9cd	\N	148db481-40b1-4ec5-9761-e88f6ac5b415	2025-09-11 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:41.13+00	2026-01-05 03:01:41.13+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: CENTOLLA	MC	30
d0c9ed52-4a8a-49df-9ddc-d72fce826e3f	2025	160	66657779-d0ce-4e0d-bcbb-7ba969689ff2	\N	148db481-40b1-4ec5-9761-e88f6ac5b415	2025-09-11 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:41.135+00	2026-01-05 03:01:41.135+00	t	Importada de JSONL. Empresa: CENTOMAR S.A. Especie: CENTOLLA	MC	30
00bb753f-6ef4-4752-8436-aa7a5c43373c	2025	161	11fa26ad-cb79-435a-a420-cfa967462a17	\N	c8c59e8f-a7af-45d0-8938-6128a74f3d1a	2025-09-11 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:41.142+00	2026-01-05 03:01:41.142+00	t	Importada de JSONL. Empresa: BENTONICOS DE ARGENTINA. Especie: CENTOLLA	MC	30
f3cf7249-aa35-4dcd-8fb4-2405662bb630	2025	162	c2deed12-01d5-4714-a7ff-67b179c21567	\N	c8c59e8f-a7af-45d0-8938-6128a74f3d1a	2025-09-11 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:41.148+00	2026-01-05 03:01:41.148+00	t	Importada de JSONL. Empresa: BENTONICOS DE ARGENTINA. Especie: CENTOLLA	MC	30
b66d91a0-b721-4eb1-bf2e-33ca5e17bfc1	2025	163	a2be240a-9024-4471-9e79-76a93c9e7a8d	\N	148db481-40b1-4ec5-9761-e88f6ac5b415	2025-09-17 03:00:00+00	\N	\N	61	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:41.157+00	2026-01-05 03:01:41.157+00	t	Importada de JSONL. Empresa: PESANTAR. Especie: MERLUZA AUSTRAL	MC	30
cfe37ca3-621b-4d25-af16-c26ddabc88b6	2025	164	38622752-1351-400f-a54d-4952a1e2b7f2	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-09-19 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:41.164+00	2026-01-05 03:01:41.164+00	t	Importada de JSONL. Empresa: XEITOSIÑO. Especie: LANGOSTINO	MC	30
24042599-75a4-4edc-808e-a45d354a2433	2025	165	e381544d-176f-4983-9515-3da39f54e189	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	2025-09-29 03:00:00+00	\N	\N	31	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:41.17+00	2026-01-05 03:01:41.17+00	t	Importada de JSONL. Empresa: ESTREMAR. Especie: MERLUZA AUSTRAL	MC	30
9a1f1d18-7aba-4b1a-a5c5-23d674f27f02	2025	166	0d1e807a-8707-4528-b2ea-2ed91f014f83	\N	148db481-40b1-4ec5-9761-e88f6ac5b415	2025-09-29 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:41.176+00	2026-01-05 03:01:41.176+00	t	Importada de JSONL. Empresa: ARGENOVA. Especie: MERLUZA AUSTRAL	MC	30
c39c814e-21cf-4280-b2da-0d96ecc122ae	2025	167	c226f5ed-4f64-4623-bfc2-77d7e32fcec3	\N	148db481-40b1-4ec5-9761-e88f6ac5b415	2025-09-26 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:41.182+00	2026-01-05 03:01:41.182+00	t	Importada de JSONL. Empresa: PESQUERA VERAZ S.A. Especie: MERLUZA	MC	30
e68fbab9-7cab-462d-8007-f8a1d7e9028d	2025	168	50b6f8f5-99d3-416f-9fab-2b21f0fa1ee5	\N	148db481-40b1-4ec5-9761-e88f6ac5b415	2025-10-14 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:41.199+00	2026-01-05 03:01:41.199+00	t	Importada de JSONL. Empresa: PEDRO MOSCUZZA E HIJO. Especie: MERLUZA	MC	30
9d972f17-ae4a-47b2-8b30-366a0bb26fe9	2025	169	b00375b1-e900-443b-9607-700315b6073c	\N	c8c59e8f-a7af-45d0-8938-6128a74f3d1a	2025-10-12 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:41.205+00	2026-01-05 03:01:41.205+00	t	Importada de JSONL. Empresa: CRUSTACEOS DEL SUR S.A. Especie: CENTOLLA	MC	60
8fe5e963-1d40-4c41-a20a-ac7ec9bd820b	2025	170	a300bb3c-6eed-423c-b957-673ecee5e140	\N	148db481-40b1-4ec5-9761-e88f6ac5b415	2025-10-18 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:41.211+00	2026-01-05 03:01:41.211+00	t	Importada de JSONL. Empresa: BUENA PROA. Especie: MERLUZA	MC	30
a395bcdb-6342-42b5-a96c-44d9ca052548	2025	171	4010465b-d1f8-4d59-8822-ab55611e8453	\N	c8c59e8f-a7af-45d0-8938-6128a74f3d1a	2025-10-30 03:00:00+00	\N	\N	6	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:41.222+00	2026-01-05 03:01:41.222+00	t	Importada de JSONL. Empresa: GLACIAR PESQUERA. Especie: VIEIRA	MC	60
88ef4a5c-ce79-4651-9fe2-7747985eeb8a	2025	172	2e11dfca-6858-47ef-973f-c98f57b21a78	\N	148db481-40b1-4ec5-9761-e88f6ac5b415	2025-10-23 03:00:00+00	\N	\N	30	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:41.229+00	2026-01-05 03:01:41.229+00	t	Importada de JSONL. Empresa: CRUSTACEOS DEL SUR S.A. Especie: CENTOLLA	MC	30
22208c66-1e34-4f59-90f5-eb97cf2c9c6f	2025	173	e381544d-176f-4983-9515-3da39f54e189	\N	148db481-40b1-4ec5-9761-e88f6ac5b415	2025-09-29 03:00:00+00	\N	\N	22	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:41.236+00	2026-01-05 03:01:41.236+00	t	Importada de JSONL. Empresa: ESTREMAR. Especie: MERLUZA AUSTRAL	MC	30
b77d5c5d-c8bc-4c97-a88c-866691153446	2025	174	29173488-2c4c-4c8d-9d91-e68cfda67140	\N	c8c59e8f-a7af-45d0-8938-6128a74f3d1a	2025-10-27 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:41.241+00	2026-01-05 03:01:41.241+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: VIEIRA	MC	30
083c2730-a3d2-434c-a86d-d5e699ad09c6	2025	175	aa820574-0468-4528-b1fb-a6ce85025db5	\N	c8c59e8f-a7af-45d0-8938-6128a74f3d1a	2025-10-31 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:41.248+00	2026-01-05 03:01:41.248+00	t	Importada de JSONL. Empresa: SOLIMENO e HIJOS S.A. Especie: MERLUZA	MC	30
3dca4d4a-625c-4c35-b422-42765b8887b5	2025	176	f7869696-130e-4a0b-82a2-0db8efdda4f5	\N	148db481-40b1-4ec5-9761-e88f6ac5b415	2025-11-01 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:41.258+00	2026-01-05 03:01:41.258+00	t	Importada de JSONL. Empresa: ROTELLO S.A. Especie: MERLUZA	MC	30
2fc23898-cd14-4418-81e4-9c3b309fa4c7	2025	177	195e04e1-67d3-43d4-ab90-0116580b8d66	\N	c8c59e8f-a7af-45d0-8938-6128a74f3d1a	2025-11-03 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:41.266+00	2026-01-05 03:01:41.266+00	t	Importada de JSONL. Empresa: ARPES S.A. Especie: MERLUZA	MC	30
7fe6021d-1b3d-45e7-a376-5badbba0a3a8	2025	178	66657779-d0ce-4e0d-bcbb-7ba969689ff2	\N	c8c59e8f-a7af-45d0-8938-6128a74f3d1a	2025-11-06 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:41.278+00	2026-01-05 03:01:41.278+00	t	Importada de JSONL. Empresa: CENTOMAR S.A. Especie: CENTOLLA	MC	30
4a5c5e10-ffa3-4422-87a6-c925c6138561	2025	179	b6dcf95b-9800-465b-9f8f-1d17ec55e792	\N	148db481-40b1-4ec5-9761-e88f6ac5b415	2025-11-04 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:41.286+00	2026-01-05 03:01:41.286+00	t	Importada de JSONL. Empresa: AIRE MARINO. Especie: ANCHOÍTA	MC	30
023cb4a6-22c9-4687-8693-62a4318afbe4	2025	180	c77c081f-1b19-422d-acc6-6320c3b5e9cd	\N	c8c59e8f-a7af-45d0-8938-6128a74f3d1a	2025-11-10 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:41.293+00	2026-01-05 03:01:41.293+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: CENTOLLA	MC	30
2d1064a6-728d-4f92-b76b-cf8ee04e4c1b	2025	181	56b78ea0-13da-476a-bc74-316af4625dbe	\N	c8c59e8f-a7af-45d0-8938-6128a74f3d1a	2025-11-10 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:41.298+00	2026-01-05 03:01:41.298+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: VIEIRA	MC	30
d7236007-806b-488e-94f5-756e7d7834b6	2025	182	a2be240a-9024-4471-9e79-76a93c9e7a8d	\N	0b46e998-9ceb-454e-b621-5ae9c2d4e47f	2025-11-20 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:41.304+00	2026-01-05 03:01:41.304+00	t	Importada de JSONL. Empresa: PESANTAR. Especie: MERLUZA AUSTRAL	MC	30
755126aa-1acb-4811-a11c-61fe28666abe	2025	183	2e11dfca-6858-47ef-973f-c98f57b21a78	\N	0b46e998-9ceb-454e-b621-5ae9c2d4e47f	2025-11-20 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:41.31+00	2026-01-05 03:01:41.31+00	t	Importada de JSONL. Empresa: CRUSTACEOS DEL SUR S.A. Especie: CENTOLLA	MC	30
78b3e48f-e4c0-482c-b8f0-8b83a0ab93b6	2025	184	bb1bd759-4ddb-437f-a8f4-a85cf4b0f164	\N	0b46e998-9ceb-454e-b621-5ae9c2d4e47f	2025-11-26 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:41.316+00	2026-01-05 03:01:41.316+00	t	Importada de JSONL. Empresa: PRODESUR. Especie: MERLUZA AUSTRAL	MC	60
c3d4cbee-815e-4c25-83fa-ebc0463f5302	2025	185	c226f5ed-4f64-4623-bfc2-77d7e32fcec3	\N	c8c59e8f-a7af-45d0-8938-6128a74f3d1a	2025-12-01 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:41.322+00	2026-01-05 03:01:41.322+00	t	Importada de JSONL. Empresa: PESQUERA VERAZ S.A. Especie: MERLUZA	MC	30
cbe37b7f-10aa-4e41-b3f9-f588eaf39416	2025	186	4010465b-d1f8-4d59-8822-ab55611e8453	\N	0b46e998-9ceb-454e-b621-5ae9c2d4e47f	2025-12-15 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:41.328+00	2026-01-05 03:01:41.328+00	t	Importada de JSONL. Empresa: GLACIAR PESQUERA. Especie: VIEIRA	MC	30
733db549-6d27-4288-92a0-0d0b8c25a066	2025	187	29173488-2c4c-4c8d-9d91-e68cfda67140	\N	0b46e998-9ceb-454e-b621-5ae9c2d4e47f	2025-12-15 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:41.334+00	2026-01-05 03:01:41.334+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: VIEIRA	MC	30
271c1caf-e5c3-4d61-b129-1799df158cd4	2025	188	e381544d-176f-4983-9515-3da39f54e189	\N	aab079f3-c217-451a-ae9e-b8628d2d6cc7	2025-12-29 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:41.34+00	2026-01-05 03:01:41.34+00	t	Importada de JSONL. Empresa: ESTREMAR S.A. Especie: MERLUZA AUSTRAL	MC	30
9328412a-37ab-400c-858f-e61b75e4f0b4	2025	189	8967d5fd-2d02-4edd-ae1b-728d6d50e876	\N	aab079f3-c217-451a-ae9e-b8628d2d6cc7	2025-12-26 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:41.346+00	2026-01-05 03:01:41.346+00	t	Importada de JSONL. Empresa: CHIARPESCA. Especie: CALAMAR	MC	30
623715c7-a1a0-414b-95c5-638f9da9476f	2025	190	0f3a3f1f-10b2-44b7-b3a8-2cffc1f72d8d	\N	aab079f3-c217-451a-ae9e-b8628d2d6cc7	2025-12-29 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:41.352+00	2026-01-05 03:01:41.352+00	t	Importada de JSONL. Empresa: ARGENOVA. Especie: CALAMAR	MC	30
2b9b049f-0b05-4186-a760-999378fae1d4	2025	191	53e0c2e5-0460-4eff-be7f-267194bf6671	\N	aab079f3-c217-451a-ae9e-b8628d2d6cc7	2025-12-29 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:41.359+00	2026-01-05 03:01:41.359+00	t	Importada de JSONL. Empresa: ALTAMARE S.AS. Especie: CALAMAR	MC	30
3314a148-6f3a-4b68-8210-fbed75f9f6f2	2025	192	1c3f98ff-d58e-4d75-8373-6fa21bb4bcf9	\N	aab079f3-c217-451a-ae9e-b8628d2d6cc7	2025-12-26 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:41.365+00	2026-01-05 03:01:41.365+00	t	Importada de JSONL. Empresa: PESQUERÍA  RÍO QUEQUEN. Especie: CALAMAR	MC	30
3dc30ae3-9ab2-41a1-96e8-a90813e21660	2025	193	5b38ccb7-df04-4198-9d68-2fcfe4279a0e	\N	aab079f3-c217-451a-ae9e-b8628d2d6cc7	2025-12-26 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:41.371+00	2026-01-05 03:01:41.371+00	t	Importada de JSONL. Empresa: PESQUERÍA  RÍO QUEQUEN. Especie: CALAMAR	MC	30
386f1408-c146-4dc3-95d7-1be4a877d8a0	2025	194	66657779-d0ce-4e0d-bcbb-7ba969689ff2	\N	aab079f3-c217-451a-ae9e-b8628d2d6cc7	2025-12-26 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:41.378+00	2026-01-05 03:01:41.378+00	t	Importada de JSONL. Empresa: CENTOMAR S.A. Especie: CENTOLLA	MC	30
e297ded4-a1ea-4889-82fd-7c0a48c6384e	2025	195	b00375b1-e900-443b-9607-700315b6073c	\N	aab079f3-c217-451a-ae9e-b8628d2d6cc7	2025-12-30 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:41.384+00	2026-01-05 03:01:41.384+00	t	Importada de JSONL. Empresa: CRUSTACEOS DEL SUR S.A. Especie: CENTOLLA	MC	30
6b158ecf-f330-40b4-aee6-b21dd16df254	2025	196	11fa26ad-cb79-435a-a420-cfa967462a17	\N	0b46e998-9ceb-454e-b621-5ae9c2d4e47f	2025-12-23 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:41.39+00	2026-01-05 03:01:41.39+00	t	Importada de JSONL. Empresa: BENTONICOS DE ARGENTINA. Especie: CENTOLLA	MC	30
0973b5fb-c2f5-4f33-a5ba-0b4683dbbd43	2025	197	c2deed12-01d5-4714-a7ff-67b179c21567	\N	aab079f3-c217-451a-ae9e-b8628d2d6cc7	2025-12-30 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:41.396+00	2026-01-05 03:01:41.396+00	t	Importada de JSONL. Empresa: BENTONICOS DE ARGENTINA. Especie: CENTOLLA	MC	30
e0ef1cb2-5858-47a7-9e37-a3861a1f973e	2025	198	72f182ca-e84f-464e-9bd0-01039544a69f	\N	aab079f3-c217-451a-ae9e-b8628d2d6cc7	2025-12-29 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:41.401+00	2026-01-05 03:01:41.401+00	t	Importada de JSONL. Empresa: GIORNO. Especie: CALAMAR	MC	30
2b695782-a8d3-41f2-9823-c2179105c9b5	2025	199	06bdab70-a38c-4e21-8220-dfda3f16c5a5	\N	aab079f3-c217-451a-ae9e-b8628d2d6cc7	2025-12-26 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:41.408+00	2026-01-05 03:01:41.408+00	t	Importada de JSONL. Empresa: GLACIAR PESQUERA. Especie: VIEIRA	MC	30
9ad97187-9a07-4de5-a26d-be5bf17d6ccf	2025	200	3f7f12c7-d341-4d13-914d-4964ab294e3e	\N	aab079f3-c217-451a-ae9e-b8628d2d6cc7	2025-12-28 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:41.415+00	2026-01-05 03:01:41.415+00	t	Importada de JSONL. Empresa: LUIS SOLIMENO. Especie: CALAMAR	MC	30
48792e89-3021-4c44-a4b2-f18b5ae3c143	2025	201	9be7d81e-ff7c-4c23-a615-c63edcd9dd6d	\N	aab079f3-c217-451a-ae9e-b8628d2d6cc7	2025-12-28 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-05 03:01:41.423+00	2026-01-05 03:01:41.423+00	t	Importada de JSONL. Empresa: PESQUERA COMERCIAL. Especie: CALAMAR	MC	30
\.


--
-- Data for Name: mareas_archivos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mareas_archivos (id, id_marea, id_movimiento_origen, tipo_archivo, formato, version, ruta_archivo, fecha_subida, id_usuario_subio, descripcion) FROM stdin;
\.


--
-- Data for Name: mareas_etapas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mareas_etapas (id, id_marea, nro_etapa, id_pesqueria, id_puerto_zarpada, id_puerto_arribo, fecha_zarpada, fecha_arribo, tipo_etapa, observaciones) FROM stdin;
e74af73d-0394-4d1c-b695-2bfb360cbddd	f4d5d6dd-c1a9-4531-9d6b-a85191dd2f99	1	61617027-3911-4e52-91ac-c8612dac86c9	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-01-03 03:00:00+00	2025-01-03 03:00:00+00	COMERCIAL	Etapa 1 importada
1bc2f4c6-cdd8-4214-adbd-dd08bde8c9d8	c53a7382-c285-4dfb-a2b6-7508c18f0095	1	61617027-3911-4e52-91ac-c8612dac86c9	be29702b-a6a9-434d-8eb3-5705e0f7468f	be29702b-a6a9-434d-8eb3-5705e0f7468f	2025-01-28 03:00:00+00	2025-01-28 03:00:00+00	COMERCIAL	Etapa 1 importada
b94d3a4e-85d6-45df-b092-a4d33dc31ba9	0c2d4e6d-edf5-437e-afcb-0e77acc2d462	1	1f6e6d84-215f-48d5-b131-5fe9f3e631da	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-01-03 03:00:00+00	2025-03-04 03:00:00+00	COMERCIAL	Etapa 1 importada
0f1f04ce-e3ce-4062-8b71-3fc226123220	9ec74ea6-8e30-42ab-878b-8d7656d2d7eb	1	432ad432-4f3a-45db-9952-fb1775b49969	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-01-11 03:00:00+00	2025-03-07 03:00:00+00	COMERCIAL	Etapa 1 importada
6bb9fadf-688a-44be-9eee-c3a1b3f2dde7	463aafe4-c835-4b72-b746-1fcbc8942bf7	1	432ad432-4f3a-45db-9952-fb1775b49969	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-01-07 03:00:00+00	2025-01-28 03:00:00+00	COMERCIAL	Etapa 1 importada
83eb3c0b-1ed9-4cfa-89b9-d4b42211911a	cbda1076-4e30-4256-b12f-f21ecf1c6bc6	1	c6c01567-eed9-4f78-a59d-f5aec4523577	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-01-08 03:00:00+00	2025-02-02 03:00:00+00	COMERCIAL	Etapa 1 importada
ffbdc9fb-43b2-4ab7-a628-914470e0f1cb	d893ae69-0bf1-455c-a872-f68a70b358e6	1	c6c01567-eed9-4f78-a59d-f5aec4523577	be29702b-a6a9-434d-8eb3-5705e0f7468f	be29702b-a6a9-434d-8eb3-5705e0f7468f	2025-01-07 03:00:00+00	2025-01-30 03:00:00+00	COMERCIAL	Etapa 1 importada
f8830b1f-5a91-42f4-8274-80360745e855	a5d404c9-624e-4c51-820e-91dee3259135	1	432ad432-4f3a-45db-9952-fb1775b49969	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-01-11 03:00:00+00	2025-01-19 03:00:00+00	COMERCIAL	Etapa 1 importada
34d33170-5fe0-4287-8de7-ff25e9272f16	a5d404c9-624e-4c51-820e-91dee3259135	2	432ad432-4f3a-45db-9952-fb1775b49969	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-01-22 03:00:00+00	2025-01-29 03:00:00+00	COMERCIAL	Etapa 2 importada
b5232333-77dd-451d-b1d4-6d1d2e550613	a5d404c9-624e-4c51-820e-91dee3259135	3	432ad432-4f3a-45db-9952-fb1775b49969	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-01-31 03:00:00+00	2025-02-02 03:00:00+00	COMERCIAL	Etapa 3 importada
f4a00854-24d0-41db-af96-135597528692	ad5c98a1-0ba5-410a-8389-5490ed45c580	1	bdb064e1-c2c3-4e77-ac2a-64dc9bd12fbf	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-01-06 03:00:00+00	2025-02-07 03:00:00+00	COMERCIAL	Etapa 1 importada
0abbbd3a-7906-4bee-bd79-b448add9b24d	d548b4fa-ec8f-4e10-bac4-91c223a9cd04	1	bdb064e1-c2c3-4e77-ac2a-64dc9bd12fbf	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-01-13 03:00:00+00	2025-02-24 03:00:00+00	COMERCIAL	Etapa 1 importada
48977018-4681-4080-b00f-26e92139cca1	b1e68fd3-848a-4ed1-b1c8-1875d0e2837a	1	c6c01567-eed9-4f78-a59d-f5aec4523577	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	2025-01-08 03:00:00+00	2025-02-02 03:00:00+00	COMERCIAL	Etapa 1 importada
c51c42a6-cf38-425b-a6c9-7fe29af2db56	ecae7b37-a7a2-4b80-a7d7-068fc2398713	1	bdb064e1-c2c3-4e77-ac2a-64dc9bd12fbf	\N	\N	2025-01-09 03:00:00+00	2025-02-16 03:00:00+00	COMERCIAL	Etapa 1 importada
aa8dfdb0-dbe7-47de-ac6b-3f88cae67d4b	b2c95fb4-a60b-4a5a-b7ae-3baf33a18767	1	1f6e6d84-215f-48d5-b131-5fe9f3e631da	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-01-08 03:00:00+00	2025-02-17 03:00:00+00	COMERCIAL	Etapa 1 importada
0581102e-c139-48b6-9154-1a8bd40eae5a	e68165c2-46ca-4008-b4e7-ef8b75d157f2	1	c6c01567-eed9-4f78-a59d-f5aec4523577	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-01-09 03:00:00+00	2025-02-13 03:00:00+00	COMERCIAL	Etapa 1 importada
292551e6-8e6c-4e20-9f49-8bb382b95101	7b6b4568-dbc3-48fd-8fb4-2f0aa88cc3bc	1	432ad432-4f3a-45db-9952-fb1775b49969	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-01-12 03:00:00+00	2025-01-19 03:00:00+00	COMERCIAL	Etapa 1 importada
dcdcfe2f-9312-4764-be20-8d94aeddc8af	7b6b4568-dbc3-48fd-8fb4-2f0aa88cc3bc	2	432ad432-4f3a-45db-9952-fb1775b49969	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-01-20 03:00:00+00	2025-01-26 03:00:00+00	COMERCIAL	Etapa 2 importada
a932e7b2-5a50-4e6b-8043-a23021698dde	7b6b4568-dbc3-48fd-8fb4-2f0aa88cc3bc	3	432ad432-4f3a-45db-9952-fb1775b49969	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-01-28 03:00:00+00	2025-02-06 03:00:00+00	COMERCIAL	Etapa 3 importada
eef5db0a-a3f0-4e7f-b3f0-8548f7e4a0e7	7b6b4568-dbc3-48fd-8fb4-2f0aa88cc3bc	4	432ad432-4f3a-45db-9952-fb1775b49969	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-02-07 03:00:00+00	2025-02-12 03:00:00+00	COMERCIAL	Etapa 4 importada
1e856d22-280a-4783-a8fd-ee43ecbf5702	325b4e0f-b997-4e21-8b27-4d1f1ff7ca87	1	bdb064e1-c2c3-4e77-ac2a-64dc9bd12fbf	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-01-17 03:00:00+00	2025-03-01 03:00:00+00	COMERCIAL	Etapa 1 importada
3a1a3824-1b2a-444f-8aa5-9d6b1a061909	b89f238c-836c-444f-9c0b-790457faddb3	1	c6c01567-eed9-4f78-a59d-f5aec4523577	20e6681d-78b9-4d78-8fff-3549a0c294bd	20e6681d-78b9-4d78-8fff-3549a0c294bd	2025-01-16 03:00:00+00	2025-01-18 03:00:00+00	COMERCIAL	Etapa 1 importada
984525df-097a-4c34-90df-f836827cebc1	39b6414c-3bb0-4650-bee2-a81857c56d3f	1	c6c01567-eed9-4f78-a59d-f5aec4523577	\N	\N	2025-01-16 03:00:00+00	2025-03-11 03:00:00+00	COMERCIAL	Etapa 1 importada
97f9a7d5-6a19-492f-b4a4-b54643895b56	5e199f6e-8528-4ca4-b5ac-265352ec2a2e	1	1f6e6d84-215f-48d5-b131-5fe9f3e631da	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	2025-01-27 03:00:00+00	2025-02-07 03:00:00+00	COMERCIAL	Etapa 1 importada
102d2389-1809-4339-913e-3ef1ce2d519c	89772426-f84f-4ada-8b95-8d6aa7cfa20c	1	c6c01567-eed9-4f78-a59d-f5aec4523577	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-02-03 03:00:00+00	2025-03-11 03:00:00+00	COMERCIAL	Etapa 1 importada
4ef19abf-7f6e-41b1-97f4-d22a20db73e6	6f309090-03de-434d-9131-af389005591e	1	1f6e6d84-215f-48d5-b131-5fe9f3e631da	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	2025-02-03 03:00:00+00	2025-03-12 03:00:00+00	COMERCIAL	Etapa 1 importada
f08ddf70-6785-4f47-917d-da3a5b544bb3	58b2cc59-4ce6-4c3c-9506-efd04f5f9fe6	1	c6c01567-eed9-4f78-a59d-f5aec4523577	be29702b-a6a9-434d-8eb3-5705e0f7468f	be29702b-a6a9-434d-8eb3-5705e0f7468f	2025-01-31 03:00:00+00	2025-03-24 03:00:00+00	COMERCIAL	Etapa 1 importada
ead5b1b3-91ac-47c6-84cb-d56c082167f0	a98df442-7c41-45ea-9930-24f476d56edb	1	c6c01567-eed9-4f78-a59d-f5aec4523577	be29702b-a6a9-434d-8eb3-5705e0f7468f	be29702b-a6a9-434d-8eb3-5705e0f7468f	2025-01-28 03:00:00+00	2025-02-23 03:00:00+00	COMERCIAL	Etapa 1 importada
6749294c-00dc-4efc-96a9-b84bce028ddd	a98df442-7c41-45ea-9930-24f476d56edb	2	c6c01567-eed9-4f78-a59d-f5aec4523577	be29702b-a6a9-434d-8eb3-5705e0f7468f	be29702b-a6a9-434d-8eb3-5705e0f7468f	2025-02-25 03:00:00+00	2025-04-06 03:00:00+00	COMERCIAL	Etapa 2 importada
cf8620bc-500d-4b40-b5a2-83d60c0513b9	72a503ff-be44-4903-8ace-f5b85133c725	1	61617027-3911-4e52-91ac-c8612dac86c9	be29702b-a6a9-434d-8eb3-5705e0f7468f	be29702b-a6a9-434d-8eb3-5705e0f7468f	2025-01-29 03:00:00+00	2025-02-23 03:00:00+00	COMERCIAL	Etapa 1 importada
126aeef1-ae1d-4a8a-9a57-1da079c50c1c	8a4355c0-e5d2-4435-a639-941e1dc3aa61	1	1f6e6d84-215f-48d5-b131-5fe9f3e631da	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	2025-01-30 03:00:00+00	2025-02-27 03:00:00+00	COMERCIAL	Etapa 1 importada
13354b19-a0c5-42cf-b9c2-334bd4ef29b1	dd74d6ee-dd23-4c5d-ba00-525c4f9f8fd9	1	432ad432-4f3a-45db-9952-fb1775b49969	20e6681d-78b9-4d78-8fff-3549a0c294bd	20e6681d-78b9-4d78-8fff-3549a0c294bd	2025-02-03 03:00:00+00	2025-03-10 03:00:00+00	COMERCIAL	Etapa 1 importada
6b0099e0-e715-460f-aecd-5d7f96f7836f	9265e7ad-9de9-442b-aefc-150d54383eff	1	c6c01567-eed9-4f78-a59d-f5aec4523577	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	2025-01-30 03:00:00+00	2025-03-11 03:00:00+00	COMERCIAL	Etapa 1 importada
7ca4df94-6d97-41a7-9cff-33d28fc219aa	29f27275-d380-447a-b747-c02ae504eb21	1	c6c01567-eed9-4f78-a59d-f5aec4523577	60cc1963-ba0f-4f37-ac75-cd04fdcd2ade	60cc1963-ba0f-4f37-ac75-cd04fdcd2ade	2025-02-05 03:00:00+00	2025-04-09 03:00:00+00	COMERCIAL	Etapa 1 importada
d267ba9b-98ec-4368-a091-0e6fe1fe5560	69e3d2f2-a9ef-4835-b552-39aad08db439	1	432ad432-4f3a-45db-9952-fb1775b49969	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-02-07 03:00:00+00	2025-02-22 03:00:00+00	COMERCIAL	Etapa 1 importada
75dfd5e0-fc09-4c05-89ba-a14b57d18aed	722d324c-0857-4d81-8060-635b4ab9aab4	1	61617027-3911-4e52-91ac-c8612dac86c9	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-02-11 03:00:00+00	2025-05-07 03:00:00+00	COMERCIAL	Etapa 1 importada
4952fc35-e620-4316-bc57-57dd5c595515	47511b2d-107a-4f1b-bf6f-8e1f38966664	1	bdb064e1-c2c3-4e77-ac2a-64dc9bd12fbf	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-02-12 03:00:00+00	2025-03-20 03:00:00+00	COMERCIAL	Etapa 1 importada
f275feab-d4f5-4ad9-85aa-a1b95a388445	0e1565c4-461d-4a6f-870c-4bac59f82d9e	1	61617027-3911-4e52-91ac-c8612dac86c9	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	2025-02-19 03:00:00+00	2025-04-13 03:00:00+00	COMERCIAL	Etapa 1 importada
5205c194-16ad-49d7-9c51-bf733ae250b7	61538cfa-6bd1-4fc7-827f-f99cb7fc1788	1	432ad432-4f3a-45db-9952-fb1775b49969	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-02-18 03:00:00+00	2025-02-25 03:00:00+00	COMERCIAL	Etapa 1 importada
915a2c3c-c7b8-4f06-ba92-10ceb18bd666	6ccdc741-2631-43c6-88cd-0573ffbc1306	1	bdb064e1-c2c3-4e77-ac2a-64dc9bd12fbf	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-02-27 03:00:00+00	2025-04-07 03:00:00+00	COMERCIAL	Etapa 1 importada
f4a525d9-0273-495f-ac4a-9cf29ea3daa1	3cbbcca9-eb17-4f36-be5e-3a768e4183df	1	61617027-3911-4e52-91ac-c8612dac86c9	be29702b-a6a9-434d-8eb3-5705e0f7468f	be29702b-a6a9-434d-8eb3-5705e0f7468f	2025-02-24 03:00:00+00	2025-03-31 03:00:00+00	COMERCIAL	Etapa 1 importada
392146ee-368e-4201-8199-3538fecaface	6bd94f84-48de-4f14-80c8-4335a20cbe35	1	bdb064e1-c2c3-4e77-ac2a-64dc9bd12fbf	\N	\N	2025-02-21 03:00:00+00	2025-04-02 03:00:00+00	COMERCIAL	Etapa 1 importada
69db90b9-e6c0-4a56-91cb-9769f779bf33	5f071d47-ba33-4ec4-a5f4-57f045f08bec	1	1f6e6d84-215f-48d5-b131-5fe9f3e631da	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	2025-02-21 03:00:00+00	2025-03-28 03:00:00+00	COMERCIAL	Etapa 1 importada
313c61ac-8bc2-4cf2-81d3-ad1a86f67a46	76275716-c459-4453-ac02-198adf1b3be4	1	1f6e6d84-215f-48d5-b131-5fe9f3e631da	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-03-06 03:00:00+00	2025-03-26 03:00:00+00	COMERCIAL	Etapa 1 importada
400e2754-7c2d-498e-901c-569fef9d8c9d	ab19ecb3-e73d-4fa1-9d62-e105c7a1ea92	1	bdb064e1-c2c3-4e77-ac2a-64dc9bd12fbf	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-03-06 03:00:00+00	2025-04-13 03:00:00+00	COMERCIAL	Etapa 1 importada
f8780048-280c-4b03-a1b1-7a344c7b59c7	3b297da9-528f-46ab-b118-79aae24c63f6	1	c6c01567-eed9-4f78-a59d-f5aec4523577	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	2025-03-07 03:00:00+00	2025-04-07 03:00:00+00	COMERCIAL	Etapa 1 importada
a8fc09d8-34b6-4731-8068-44320ec729e9	fe7bb24a-e5be-46e8-8498-3080ccb883a1	1	\N	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-03-11 03:00:00+00	2025-03-18 03:00:00+00	COMERCIAL	Etapa 1 importada
e1b88b8a-6200-4bc6-99e7-d2211b482433	fe7bb24a-e5be-46e8-8498-3080ccb883a1	2	\N	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-03-21 03:00:00+00	2025-03-28 03:00:00+00	COMERCIAL	Etapa 2 importada
e66d1555-17cf-449f-8bb3-9d140af29a78	815a4e3f-3ed7-411d-9c25-22093e4dcc17	1	\N	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-03-11 03:00:00+00	2025-03-16 03:00:00+00	COMERCIAL	Etapa 1 importada
24148afd-7bb1-43bd-8a9a-791264dc8680	815a4e3f-3ed7-411d-9c25-22093e4dcc17	2	\N	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-03-17 03:00:00+00	2025-03-28 03:00:00+00	COMERCIAL	Etapa 2 importada
7c21d3a7-5457-419f-9c8a-9c74356b9f06	85524d4b-ba88-4576-89bb-d7d01e6285cb	1	\N	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-03-12 03:00:00+00	2025-03-17 03:00:00+00	COMERCIAL	Etapa 1 importada
c823d0ab-6ea5-45ed-ba27-51c83b3d282b	85524d4b-ba88-4576-89bb-d7d01e6285cb	2	\N	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-03-18 03:00:00+00	2025-03-29 03:00:00+00	COMERCIAL	Etapa 2 importada
2512899e-3619-437d-b081-3b62bc23737b	e44e4eea-2153-4fc0-be3d-b85bf1cd7703	1	\N	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-03-11 03:00:00+00	2025-03-20 03:00:00+00	COMERCIAL	Etapa 1 importada
d16a96bf-6382-405f-8d32-d13b4b4a0c04	e44e4eea-2153-4fc0-be3d-b85bf1cd7703	2	\N	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-03-22 03:00:00+00	2025-03-27 03:00:00+00	COMERCIAL	Etapa 2 importada
c2b7b65c-d6e0-4d03-b0f8-9243a4d7bb97	2eccb65c-7ba1-445b-ae33-b4f2edda0a1f	1	\N	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-03-07 03:00:00+00	2025-03-12 03:00:00+00	COMERCIAL	Etapa 1 importada
9cb41554-5c33-4b02-8d03-3e67870031e1	2eccb65c-7ba1-445b-ae33-b4f2edda0a1f	2	\N	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-03-15 03:00:00+00	2025-03-18 03:00:00+00	COMERCIAL	Etapa 2 importada
c6185503-ac41-4a3c-a066-97d0ebf0ec30	63b4e615-64a1-4e39-b31c-998b167d1d9d	1	1f6e6d84-215f-48d5-b131-5fe9f3e631da	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	2025-03-11 03:00:00+00	2025-04-23 03:00:00+00	COMERCIAL	Etapa 1 importada
37907746-a896-4083-a138-a1cfc7d8bcd4	0c6606f5-9faf-4625-bb98-dd50a576f56a	1	1f6e6d84-215f-48d5-b131-5fe9f3e631da	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	2025-03-12 03:00:00+00	2025-04-30 03:00:00+00	COMERCIAL	Etapa 1 importada
27ae50ac-00d6-40cb-8cbe-e1d4df97c45f	c81bf48b-2bc8-4559-abab-ed13dc491b26	1	432ad432-4f3a-45db-9952-fb1775b49969	20e6681d-78b9-4d78-8fff-3549a0c294bd	20e6681d-78b9-4d78-8fff-3549a0c294bd	2025-03-17 03:00:00+00	2025-04-25 03:00:00+00	COMERCIAL	Etapa 1 importada
846b5474-6d5a-4f17-9726-6f6d24b94e7e	e065843b-d7f0-44b1-9ea4-db81b310857a	1	c6c01567-eed9-4f78-a59d-f5aec4523577	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-03-24 03:00:00+00	2025-04-23 03:00:00+00	COMERCIAL	Etapa 1 importada
9aa2c272-39be-489b-a77d-d189cc27ba0e	aa8cde01-3ee1-41f8-bf1d-85d023d4cd9b	1	bdb064e1-c2c3-4e77-ac2a-64dc9bd12fbf	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-03-28 03:00:00+00	2025-04-30 03:00:00+00	COMERCIAL	Etapa 1 importada
c1c1f61e-1c77-4a1d-8239-848e11844171	dac627e7-31b8-4253-be67-cdc80afc4e5d	1	61617027-3911-4e52-91ac-c8612dac86c9	be29702b-a6a9-434d-8eb3-5705e0f7468f	be29702b-a6a9-434d-8eb3-5705e0f7468f	2025-04-01 03:00:00+00	2025-04-27 03:00:00+00	COMERCIAL	Etapa 1 importada
f474a5bf-ef03-43c6-8fc7-a0f90a9395ac	7dc6a248-1a3d-4550-b89a-a2cb6d6c668e	1	c6c01567-eed9-4f78-a59d-f5aec4523577	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-03-28 03:00:00+00	2025-05-05 03:00:00+00	COMERCIAL	Etapa 1 importada
c8a3556c-63fd-49c1-825b-064db996d4d7	c451f829-9418-46b9-b588-b75e7a8b7f09	1	bdb064e1-c2c3-4e77-ac2a-64dc9bd12fbf	\N	\N	2025-04-11 03:00:00+00	2025-05-17 03:00:00+00	COMERCIAL	Etapa 1 importada
e89c055c-ef3d-4e98-ad5a-c197df3a2a48	b495ea11-47f7-43c5-90f4-323acb2faf27	1	61617027-3911-4e52-91ac-c8612dac86c9	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	2025-04-18 03:00:00+00	2025-05-19 03:00:00+00	COMERCIAL	Etapa 1 importada
44850265-a6bd-437b-a7d5-bb76b2b3986a	eb672390-8555-4690-a534-dca0d189a8d6	1	61617027-3911-4e52-91ac-c8612dac86c9	60cc1963-ba0f-4f37-ac75-cd04fdcd2ade	60cc1963-ba0f-4f37-ac75-cd04fdcd2ade	2025-04-12 03:00:00+00	2025-05-20 03:00:00+00	COMERCIAL	Etapa 1 importada
9475331d-3c35-4a26-ba4c-03b8274cc4df	9bd5e91b-9157-42ab-9593-f15cc284c35a	1	1f6e6d84-215f-48d5-b131-5fe9f3e631da	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	2025-05-08 03:00:00+00	2025-06-06 03:00:00+00	COMERCIAL	Etapa 1 importada
6d73ce53-a5ea-474a-9446-39fc822e7718	be4d0d19-dbe4-4272-aee9-0a67719c2ab6	1	c6c01567-eed9-4f78-a59d-f5aec4523577	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	2025-04-21 03:00:00+00	2025-05-15 03:00:00+00	COMERCIAL	Etapa 1 importada
fe912088-91b8-4d4e-b87c-22a0e0f22341	9df86d22-596b-42af-9ba9-ff59a635af53	1	bdb064e1-c2c3-4e77-ac2a-64dc9bd12fbf	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-04-10 03:00:00+00	2025-06-06 03:00:00+00	COMERCIAL	Etapa 1 importada
45f60a8b-87c0-4d0c-8928-0302ea10d693	8db2e4dd-fd8c-4319-88ce-a7a82303f7a2	1	1f6e6d84-215f-48d5-b131-5fe9f3e631da	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-04-12 03:00:00+00	2025-05-14 03:00:00+00	COMERCIAL	Etapa 1 importada
8f299e27-c7a7-4cff-a52e-d1bb082935af	db42b137-ba3f-4ffb-9254-cbcb2ea2f27e	1	bdb064e1-c2c3-4e77-ac2a-64dc9bd12fbf	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-04-16 03:00:00+00	2025-05-29 03:00:00+00	COMERCIAL	Etapa 1 importada
13b16d4b-8794-44fc-8670-d2503aaf22d0	6831ad38-08e6-4501-bd81-15169a9ac02e	1	c6c01567-eed9-4f78-a59d-f5aec4523577	20e6681d-78b9-4d78-8fff-3549a0c294bd	20e6681d-78b9-4d78-8fff-3549a0c294bd	2025-04-15 03:00:00+00	2025-05-27 03:00:00+00	COMERCIAL	Etapa 1 importada
dce4fae1-6175-422d-9fa3-761fac3bc9dc	6be38161-1215-421d-a805-8626e66fa481	1	517a5800-ded1-4a08-96cf-059e1492674f	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	2025-04-12 03:00:00+00	2025-04-20 03:00:00+00	COMERCIAL	Etapa 1 importada
c40245ce-c278-412d-a59e-c61f1509045a	6be38161-1215-421d-a805-8626e66fa481	2	517a5800-ded1-4a08-96cf-059e1492674f	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	2025-04-21 03:00:00+00	2025-05-01 03:00:00+00	COMERCIAL	Etapa 2 importada
7b9ff9a8-5800-46dc-8ff6-ddea6a593840	6be38161-1215-421d-a805-8626e66fa481	3	517a5800-ded1-4a08-96cf-059e1492674f	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	2025-05-02 03:00:00+00	2025-05-10 03:00:00+00	COMERCIAL	Etapa 3 importada
c64c11db-6662-4fab-8288-e7fc3336f034	82583380-f465-4e87-a996-745c82d08679	1	432ad432-4f3a-45db-9952-fb1775b49969	20e6681d-78b9-4d78-8fff-3549a0c294bd	20e6681d-78b9-4d78-8fff-3549a0c294bd	2025-04-27 03:00:00+00	2025-05-31 03:00:00+00	COMERCIAL	Etapa 1 importada
fced129a-3de2-4366-9662-321e776198a3	d8dfb3a7-6584-49fd-b971-7cf781471f80	1	432ad432-4f3a-45db-9952-fb1775b49969	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	0205-04-21 03:53:48+00	2025-04-29 03:00:00+00	COMERCIAL	Etapa 1 importada
49fec0b7-b779-45e4-9773-c1094eb10dde	d8dfb3a7-6584-49fd-b971-7cf781471f80	2	432ad432-4f3a-45db-9952-fb1775b49969	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-05-02 03:00:00+00	2025-05-10 03:00:00+00	COMERCIAL	Etapa 2 importada
652c258a-5b92-4a41-953e-747405d02de0	d8dfb3a7-6584-49fd-b971-7cf781471f80	3	432ad432-4f3a-45db-9952-fb1775b49969	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-05-12 03:00:00+00	2025-05-26 03:00:00+00	COMERCIAL	Etapa 3 importada
983bf111-2c9b-4823-b385-bac1988a7278	4711834a-ece0-4559-9153-caf7ed073090	1	432ad432-4f3a-45db-9952-fb1775b49969	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-05-02 03:00:00+00	2025-05-09 03:00:00+00	COMERCIAL	Etapa 1 importada
18f8bb97-ca53-4719-8825-e8881382ebd2	4711834a-ece0-4559-9153-caf7ed073090	2	432ad432-4f3a-45db-9952-fb1775b49969	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-05-14 03:00:00+00	2025-05-25 03:00:00+00	COMERCIAL	Etapa 2 importada
2862b777-f0da-4231-b0cc-4f6f3e358d76	9faddd71-cea4-4ad1-845e-3cff92261ec0	1	432ad432-4f3a-45db-9952-fb1775b49969	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	2025-04-30 03:00:00+00	2025-06-16 03:00:00+00	COMERCIAL	Etapa 1 importada
18607cc9-8ffc-4106-a5e2-579e3e12bf13	2a5a7a70-6c10-4d54-9308-324c2d652400	1	432ad432-4f3a-45db-9952-fb1775b49969	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-04-26 03:00:00+00	2025-05-04 03:00:00+00	COMERCIAL	Etapa 1 importada
e81ff8c2-5baa-49db-b103-482ea4b40de8	2a5a7a70-6c10-4d54-9308-324c2d652400	2	432ad432-4f3a-45db-9952-fb1775b49969	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-05-06 03:00:00+00	2025-05-15 03:00:00+00	COMERCIAL	Etapa 2 importada
9a90aa09-f8c3-4380-9288-6665f2f70bb6	2a5a7a70-6c10-4d54-9308-324c2d652400	3	432ad432-4f3a-45db-9952-fb1775b49969	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-05-17 03:00:00+00	2025-05-27 03:00:00+00	COMERCIAL	Etapa 3 importada
a6c6f8db-2365-44b5-8ec3-c331ca9753c6	822da010-04f1-4ec8-a940-099f898834d0	1	c6c01567-eed9-4f78-a59d-f5aec4523577	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-04-26 03:00:00+00	2025-05-28 03:00:00+00	COMERCIAL	Etapa 1 importada
1b3c5148-c1d9-4fbe-b8f2-5295f72668e1	802b7c64-46ba-4868-a819-490b842338d5	1	432ad432-4f3a-45db-9952-fb1775b49969	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-05-02 03:00:00+00	2025-05-10 03:00:00+00	COMERCIAL	Etapa 1 importada
131000b5-5189-4d1a-93b0-69b16c110c8c	802b7c64-46ba-4868-a819-490b842338d5	2	432ad432-4f3a-45db-9952-fb1775b49969	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-05-12 03:00:00+00	2025-05-21 03:00:00+00	COMERCIAL	Etapa 2 importada
1b72b5b3-235f-46b2-b0c6-ec559bd9922f	6c8fcf21-dcff-4139-9f0e-135cc6d208c6	1	c6c01567-eed9-4f78-a59d-f5aec4523577	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	2025-04-30 03:00:00+00	2025-06-05 03:00:00+00	COMERCIAL	Etapa 1 importada
fb1587ef-fccd-4026-b74b-21bda1d7fe0f	ec01d89c-d0f0-45d4-8579-bdd5fb0e38d8	1	61617027-3911-4e52-91ac-c8612dac86c9	be29702b-a6a9-434d-8eb3-5705e0f7468f	be29702b-a6a9-434d-8eb3-5705e0f7468f	2025-04-28 03:00:00+00	2025-06-04 03:00:00+00	COMERCIAL	Etapa 1 importada
c0221f53-f058-4a56-8db3-b2f197b06a5c	816c5edd-457a-4c93-a659-17168077a513	1	432ad432-4f3a-45db-9952-fb1775b49969	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-04-30 03:00:00+00	2025-05-06 03:00:00+00	COMERCIAL	Etapa 1 importada
22ef5208-d984-4502-9215-03e470adbb67	816c5edd-457a-4c93-a659-17168077a513	2	432ad432-4f3a-45db-9952-fb1775b49969	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-05-08 03:00:00+00	2025-05-17 03:00:00+00	COMERCIAL	Etapa 2 importada
4e64cb28-4eff-490f-b502-8cac4cbc98b0	816c5edd-457a-4c93-a659-17168077a513	3	432ad432-4f3a-45db-9952-fb1775b49969	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-05-22 03:00:00+00	2025-05-29 03:00:00+00	COMERCIAL	Etapa 3 importada
cb49074d-3422-4ef8-8478-99a38515f4bc	669baadc-57e0-44f7-8cc0-f517f6a8336f	1	432ad432-4f3a-45db-9952-fb1775b49969	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-04-29 03:00:00+00	2025-05-15 03:00:00+00	COMERCIAL	Etapa 1 importada
c78a5fd6-7aae-425c-91fa-d085fa427432	8dd829f7-8da0-427e-9c83-4d55ad83657c	1	61617027-3911-4e52-91ac-c8612dac86c9	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-05-06 03:00:00+00	2025-06-18 03:00:00+00	COMERCIAL	Etapa 1 importada
d2a8557b-b358-4430-a92e-88608435468f	aa09f3a7-455a-4049-8485-805b533ce378	1	bdb064e1-c2c3-4e77-ac2a-64dc9bd12fbf	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-05-07 03:00:00+00	2025-06-10 03:00:00+00	COMERCIAL	Etapa 1 importada
7529aece-3542-41e4-87c0-0c4aa0d8b711	58940af6-143f-47ab-9d27-1fe6b8775fff	1	432ad432-4f3a-45db-9952-fb1775b49969	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-05-02 03:00:00+00	2025-06-05 03:00:00+00	COMERCIAL	Etapa 1 importada
305e9a61-8626-462c-8abd-587327030166	a4abdee9-4460-41c7-978b-c0456ca12255	1	c6c01567-eed9-4f78-a59d-f5aec4523577	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	2025-05-07 03:00:00+00	2025-06-09 03:00:00+00	COMERCIAL	Etapa 1 importada
4e334c59-79fe-43b9-9a89-208f37214917	e663b06f-1766-4d56-933f-11f3cce93a6c	1	c6c01567-eed9-4f78-a59d-f5aec4523577	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-05-07 03:00:00+00	2025-06-10 03:00:00+00	COMERCIAL	Etapa 1 importada
36995206-2d5d-4996-a258-c2e9b09a95b1	c8a60b46-61ec-4a5b-a60b-73f59b7deba6	1	517a5800-ded1-4a08-96cf-059e1492674f	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	2025-05-09 03:00:00+00	2025-05-19 03:00:00+00	COMERCIAL	Etapa 1 importada
1c2af045-dc69-4fff-ae75-dacffa92d26d	c20db1f6-5e12-48dc-b54c-0a822b868083	1	1f6e6d84-215f-48d5-b131-5fe9f3e631da	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-05-15 03:00:00+00	2025-05-27 03:00:00+00	COMERCIAL	Etapa 1 importada
93e1a386-ac97-44a6-a1f5-c322e10a8b9d	903435c7-495f-4fb7-b02d-1a734cb99f5d	1	61617027-3911-4e52-91ac-c8612dac86c9	60cc1963-ba0f-4f37-ac75-cd04fdcd2ade	60cc1963-ba0f-4f37-ac75-cd04fdcd2ade	2025-05-21 03:00:00+00	2025-07-13 03:00:00+00	COMERCIAL	Etapa 1 importada
5ab1f544-d14b-47dd-b217-092767e27b9c	3ffea578-dfbe-43d0-8618-d3c0916e949d	1	432ad432-4f3a-45db-9952-fb1775b49969	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-05-17 03:00:00+00	2025-07-13 03:00:00+00	COMERCIAL	Etapa 1 importada
3fb55533-eb10-4935-9e84-6d4510127fa7	cd411ab4-b3e8-4fed-baef-7b37af1b86e3	1	432ad432-4f3a-45db-9952-fb1775b49969	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-05-22 03:00:00+00	2025-06-17 03:00:00+00	COMERCIAL	Etapa 1 importada
79837eed-fad9-4943-a04d-c0724f8ec7bf	c25af8f7-896c-4d9d-ace0-f26ef330327a	1	c6c01567-eed9-4f78-a59d-f5aec4523577	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-05-22 03:00:00+00	2025-06-05 03:00:00+00	COMERCIAL	Etapa 1 importada
0be439d7-20dc-4602-880a-680a96d5308b	cc9c9e19-ef52-4dcb-b11d-b99011d5ab50	1	61617027-3911-4e52-91ac-c8612dac86c9	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	2025-05-20 03:00:00+00	2025-06-21 03:00:00+00	COMERCIAL	Etapa 1 importada
f54d653d-3c5b-4a5b-a974-8f68de179540	fcb39438-a351-4e0c-88e3-9e737a188372	1	bdb064e1-c2c3-4e77-ac2a-64dc9bd12fbf	\N	\N	2025-05-27 03:00:00+00	2025-07-12 03:00:00+00	COMERCIAL	Etapa 1 importada
7279c48e-408b-425f-8b93-02494fc6764d	f01a4ca0-d8ef-4931-92ed-4b6bcc69e104	1	bdb064e1-c2c3-4e77-ac2a-64dc9bd12fbf	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-05-31 03:00:00+00	2025-07-11 03:00:00+00	COMERCIAL	Etapa 1 importada
c1d3bb16-5bcc-4adc-a1c7-afbf85e1954e	8def266d-017b-41d0-bff7-397c412c4ec7	1	517a5800-ded1-4a08-96cf-059e1492674f	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	2025-05-26 03:00:00+00	2025-06-03 03:00:00+00	COMERCIAL	Etapa 1 importada
f6a63a7a-5cb1-4d17-9a52-d53fcdbda842	8def266d-017b-41d0-bff7-397c412c4ec7	2	517a5800-ded1-4a08-96cf-059e1492674f	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	2025-06-04 03:00:00+00	2025-06-10 03:00:00+00	COMERCIAL	Etapa 2 importada
53433369-07dc-46b5-81e6-eb4481b94d28	d4a21ba7-fc7f-44df-8fd5-8a8f5f74e5d0	1	c6c01567-eed9-4f78-a59d-f5aec4523577	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-05-31 03:00:00+00	2025-06-07 03:00:00+00	COMERCIAL	Etapa 1 importada
a27d555d-050d-4455-b73b-eeb441154e44	80b6112c-cafd-4328-9fd7-d18ebf2913e6	1	432ad432-4f3a-45db-9952-fb1775b49969	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-06-12 03:00:00+00	2025-06-20 03:00:00+00	COMERCIAL	Etapa 1 importada
5df29941-8863-4dd5-9728-a48020897b76	80b6112c-cafd-4328-9fd7-d18ebf2913e6	2	432ad432-4f3a-45db-9952-fb1775b49969	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-06-24 03:00:00+00	2025-07-05 03:00:00+00	COMERCIAL	Etapa 2 importada
9e6c65cc-7ca3-4f15-9f66-277e4a03dde8	80b6112c-cafd-4328-9fd7-d18ebf2913e6	3	432ad432-4f3a-45db-9952-fb1775b49969	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-07-08 03:00:00+00	2025-07-16 03:00:00+00	COMERCIAL	Etapa 3 importada
c2696277-6b78-4125-a44a-c49e384f0829	80b6112c-cafd-4328-9fd7-d18ebf2913e6	4	432ad432-4f3a-45db-9952-fb1775b49969	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-07-19 03:00:00+00	2025-07-25 03:00:00+00	COMERCIAL	Etapa 4 importada
aad344fb-8eed-4742-a7ed-0c918eaf3fe6	a5d0be4e-80bb-4d33-80bb-7de949e17d6d	1	432ad432-4f3a-45db-9952-fb1775b49969	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-06-05 03:00:00+00	2025-07-06 03:00:00+00	COMERCIAL	Etapa 1 importada
c7ef8b08-626e-468d-ba57-9dd22e9db3c9	296c2512-6c1d-4b3a-81a5-13ad6f3eb24b	1	432ad432-4f3a-45db-9952-fb1775b49969	20e6681d-78b9-4d78-8fff-3549a0c294bd	20e6681d-78b9-4d78-8fff-3549a0c294bd	2025-06-05 03:00:00+00	2025-07-06 03:00:00+00	COMERCIAL	Etapa 1 importada
f495fcfb-b7af-4787-9923-87c78b8e848d	1a000973-b9e0-4c27-a4fd-7fd0966d0041	1	61617027-3911-4e52-91ac-c8612dac86c9	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-06-18 03:00:00+00	2025-07-03 03:00:00+00	COMERCIAL	Etapa 1 importada
2d4b4554-cc3a-4cc3-a810-535ae30b2901	87bdc4e9-734c-401c-846e-6a653043cc27	1	432ad432-4f3a-45db-9952-fb1775b49969	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-06-10 03:00:00+00	2025-06-17 03:00:00+00	COMERCIAL	Etapa 1 importada
3f8fe789-859c-438b-a804-7079ea70d8d8	87bdc4e9-734c-401c-846e-6a653043cc27	2	432ad432-4f3a-45db-9952-fb1775b49969	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-06-19 03:00:00+00	2025-06-22 03:00:00+00	COMERCIAL	Etapa 2 importada
b570072c-c0ab-43ac-a82a-cdaeeb0e2318	87bdc4e9-734c-401c-846e-6a653043cc27	3	432ad432-4f3a-45db-9952-fb1775b49969	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-06-28 03:00:00+00	2025-07-04 03:00:00+00	COMERCIAL	Etapa 3 importada
044f68de-6e72-416f-9d81-1373acc5a451	87bdc4e9-734c-401c-846e-6a653043cc27	4	432ad432-4f3a-45db-9952-fb1775b49969	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-07-06 03:00:00+00	2025-07-10 03:00:00+00	COMERCIAL	Etapa 4 importada
99fcc00b-9bbf-4a88-be31-edca502bed3f	87bdc4e9-734c-401c-846e-6a653043cc27	5	432ad432-4f3a-45db-9952-fb1775b49969	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-07-12 03:00:00+00	2025-07-16 03:00:00+00	COMERCIAL	Etapa 5 importada
d85b7e16-01d5-4240-816f-68117e8539ab	34e2623f-0fee-46b1-be85-42225d18fb4d	1	517a5800-ded1-4a08-96cf-059e1492674f	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-06-18 03:00:00+00	2025-06-25 03:00:00+00	COMERCIAL	Etapa 1 importada
77243f78-6ead-4dab-afba-8cf8ff4dbb97	34e2623f-0fee-46b1-be85-42225d18fb4d	2	517a5800-ded1-4a08-96cf-059e1492674f	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-06-27 03:00:00+00	2025-07-11 03:00:00+00	COMERCIAL	Etapa 2 importada
e2bd651a-609a-4d3c-803a-99a653a88d20	56828306-4e4d-4840-8d17-7503f30fb603	1	517a5800-ded1-4a08-96cf-059e1492674f	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	2025-06-17 03:00:00+00	2025-07-10 03:00:00+00	COMERCIAL	Etapa 1 importada
69bb9d43-1188-44ff-ac99-b93d00f369d0	5c26974d-0e37-4057-850c-6090d2d77a04	1	517a5800-ded1-4a08-96cf-059e1492674f	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-06-18 03:00:00+00	2025-06-25 03:00:00+00	COMERCIAL	Etapa 1 importada
4519de9f-dc52-4cb5-bffe-0917e2bca45f	f8464a7e-e18c-4e5f-b448-3b043143adcd	1	517a5800-ded1-4a08-96cf-059e1492674f	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-06-18 03:00:00+00	2025-06-25 03:00:00+00	COMERCIAL	Etapa 1 importada
a4aea669-bb29-4c99-a239-a572c0aee00a	405ce0cf-9df1-4b89-b034-3aa0c9f637c4	1	517a5800-ded1-4a08-96cf-059e1492674f	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-06-18 03:00:00+00	2025-06-25 03:00:00+00	COMERCIAL	Etapa 1 importada
4c325457-9504-4ee4-ae8c-3409eb28b00b	35539d81-0628-46f1-9a21-4f073417fcaf	1	517a5800-ded1-4a08-96cf-059e1492674f	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-06-18 03:00:00+00	2025-06-25 03:00:00+00	COMERCIAL	Etapa 1 importada
97f54622-a044-4adb-abad-2570f50e89f5	35539d81-0628-46f1-9a21-4f073417fcaf	2	517a5800-ded1-4a08-96cf-059e1492674f	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-06-27 03:00:00+00	2025-07-04 03:00:00+00	COMERCIAL	Etapa 2 importada
851fb9cb-2673-4213-aef2-361836910499	1f34093e-0d7c-43a8-9834-51eb1265ad99	1	432ad432-4f3a-45db-9952-fb1775b49969	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-06-25 03:00:00+00	2025-07-03 03:00:00+00	COMERCIAL	Etapa 1 importada
a2b28b05-775e-4c53-807c-5bfac5dcb05e	1f34093e-0d7c-43a8-9834-51eb1265ad99	2	432ad432-4f3a-45db-9952-fb1775b49969	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-07-05 03:00:00+00	2025-07-11 03:00:00+00	COMERCIAL	Etapa 2 importada
56d11d15-724c-45a1-8ccd-a79e5ec56b4b	1f34093e-0d7c-43a8-9834-51eb1265ad99	3	432ad432-4f3a-45db-9952-fb1775b49969	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-07-20 03:00:00+00	2025-07-26 03:00:00+00	COMERCIAL	Etapa 3 importada
b3dda890-4157-47ea-b6fa-de2a9ed05621	1f34093e-0d7c-43a8-9834-51eb1265ad99	4	432ad432-4f3a-45db-9952-fb1775b49969	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-07-28 03:00:00+00	2025-08-04 03:00:00+00	COMERCIAL	Etapa 4 importada
207bf7c8-7899-41a0-b8a1-09268c7c70b2	d6f613ac-58ed-47ae-ae62-39ddf048504d	1	517a5800-ded1-4a08-96cf-059e1492674f	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-06-27 03:00:00+00	2025-07-21 03:00:00+00	COMERCIAL	Etapa 1 importada
9fb72420-9120-432b-8cbd-577598520f62	16a44086-521e-4704-a757-467009e950b3	1	517a5800-ded1-4a08-96cf-059e1492674f	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-06-27 03:00:00+00	2025-07-03 03:00:00+00	COMERCIAL	Etapa 1 importada
fff8cc61-e7f2-4901-a1d4-114982b4063e	16a44086-521e-4704-a757-467009e950b3	2	517a5800-ded1-4a08-96cf-059e1492674f	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-07-04 03:00:00+00	2025-07-11 03:00:00+00	COMERCIAL	Etapa 2 importada
08247c72-b492-4f7a-bd19-10f528e32518	09616800-ca0d-442c-916b-be99e59c8eb2	1	517a5800-ded1-4a08-96cf-059e1492674f	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-06-27 03:00:00+00	2025-07-17 03:00:00+00	COMERCIAL	Etapa 1 importada
864180fc-9b16-4133-add2-78a8907c9057	3ce13a74-15b7-417b-80b1-d9d5bbd51512	1	432ad432-4f3a-45db-9952-fb1775b49969	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-07-12 03:00:00+00	2025-07-14 03:00:00+00	COMERCIAL	Etapa 1 importada
e89f5548-ba0b-4079-b283-8b25e9cf6ad5	3ce13a74-15b7-417b-80b1-d9d5bbd51512	2	432ad432-4f3a-45db-9952-fb1775b49969	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-07-18 03:00:00+00	2025-07-23 03:00:00+00	COMERCIAL	Etapa 2 importada
778acffd-fa39-4eac-854a-f16886b1c0e4	3ce13a74-15b7-417b-80b1-d9d5bbd51512	3	432ad432-4f3a-45db-9952-fb1775b49969	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-07-27 03:00:00+00	2025-08-01 03:00:00+00	COMERCIAL	Etapa 3 importada
fb98b635-2da8-459e-b3ed-b31ec6bb8c1f	5241ae97-f2a5-4b22-abec-562cf23cef24	1	\N	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-07-10 03:00:00+00	2025-08-29 03:00:00+00	COMERCIAL	Etapa 1 importada
b0a7ff72-21e6-4453-bbcb-78093cd60ccb	dd92916f-323b-4a26-a0bd-238d8ff022da	1	\N	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-07-14 03:00:00+00	2025-08-28 03:00:00+00	COMERCIAL	Etapa 1 importada
fd683d7c-ec89-40f9-9037-ddec9e28bc70	caf1a601-4b21-41b1-a2f5-580c1b548b2a	1	517a5800-ded1-4a08-96cf-059e1492674f	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	2025-07-11 03:00:00+00	2025-08-20 03:00:00+00	COMERCIAL	Etapa 1 importada
dcc8710e-d12c-4213-89cd-a9acbdc33419	01ec393e-7986-4bc8-9630-c442d4aefeb0	1	517a5800-ded1-4a08-96cf-059e1492674f	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-07-13 03:00:00+00	2025-08-05 03:00:00+00	COMERCIAL	Etapa 1 importada
523c6d3d-0611-4a90-9f0d-45edb52e6c87	e6c2b1a4-03a0-4db8-8aeb-eac9b8fc28b0	1	432ad432-4f3a-45db-9952-fb1775b49969	b06cb245-db92-471b-a70e-f741a6593708	b06cb245-db92-471b-a70e-f741a6593708	2025-07-12 03:00:00+00	2025-08-23 03:00:00+00	COMERCIAL	Etapa 1 importada
f871a053-7481-4af1-b07b-4f4fac41263b	70988259-cd5e-4d00-9af9-0a49e256829e	1	517a5800-ded1-4a08-96cf-059e1492674f	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-07-18 03:00:00+00	2025-07-25 03:00:00+00	COMERCIAL	Etapa 1 importada
49de740b-c408-46de-9486-2f7fb875bff4	70988259-cd5e-4d00-9af9-0a49e256829e	2	517a5800-ded1-4a08-96cf-059e1492674f	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-07-26 03:00:00+00	2025-08-03 03:00:00+00	COMERCIAL	Etapa 2 importada
24c6e7fe-eb40-4744-9dd1-5f4a9927db71	70988259-cd5e-4d00-9af9-0a49e256829e	3	517a5800-ded1-4a08-96cf-059e1492674f	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-08-04 03:00:00+00	2025-08-10 03:00:00+00	COMERCIAL	Etapa 3 importada
ce21016e-aa20-4a2b-9a80-1348f940b11d	70988259-cd5e-4d00-9af9-0a49e256829e	4	517a5800-ded1-4a08-96cf-059e1492674f	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-08-11 03:00:00+00	2025-08-17 03:00:00+00	COMERCIAL	Etapa 4 importada
087c5c2d-13fd-4989-b1ca-64286be3a62c	0c083497-30ba-4c77-858c-ffa2b2bdeb28	1	bdb064e1-c2c3-4e77-ac2a-64dc9bd12fbf	\N	\N	2025-07-17 03:00:00+00	2025-09-04 03:00:00+00	COMERCIAL	Etapa 1 importada
325b01c4-06f5-4bbe-b727-d530153a3941	96241b47-1094-4eda-a607-b5b0a8b44611	1	432ad432-4f3a-45db-9952-fb1775b49969	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-07-19 03:00:00+00	2025-08-19 03:00:00+00	COMERCIAL	Etapa 1 importada
9b4f0fd0-4f1a-41ec-8843-88b2231175df	3fe69381-91ce-4052-bff2-48f90d274546	1	432ad432-4f3a-45db-9952-fb1775b49969	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-07-19 03:00:00+00	2025-08-23 03:00:00+00	COMERCIAL	Etapa 1 importada
6c0e86a6-8e57-4173-ad22-d4621e7b26ae	a65976dd-1491-4ee9-b721-3ce06dbb4b87	1	517a5800-ded1-4a08-96cf-059e1492674f	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-07-21 03:00:00+00	\N	COMERCIAL	Etapa generada automáticamente (sin desglose)
e1cec1bc-aeb7-4943-815c-1ca73b40a9cf	b0232b93-443b-4fa2-b94d-c038164a6a74	1	517a5800-ded1-4a08-96cf-059e1492674f	\N	\N	2025-07-23 03:00:00+00	2025-10-07 03:00:00+00	COMERCIAL	Etapa 1 importada
71e52164-cc90-40a6-9538-1910022c569d	6bae02ae-8133-42da-ae56-6a57171931fa	1	517a5800-ded1-4a08-96cf-059e1492674f	\N	\N	2025-07-23 03:00:00+00	2025-09-27 03:00:00+00	COMERCIAL	Etapa 1 importada
253650e0-a625-428b-bf0a-73b6b83da388	5a6960d2-64d8-432f-b799-666eb19cf046	1	517a5800-ded1-4a08-96cf-059e1492674f	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-07-24 03:00:00+00	2025-08-30 03:00:00+00	COMERCIAL	Etapa 1 importada
896a27a7-5b11-4543-8563-7845a421c1eb	8cbbaf71-123a-4028-8701-1bbc9d11addb	1	432ad432-4f3a-45db-9952-fb1775b49969	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-07-29 03:00:00+00	2025-08-03 03:00:00+00	COMERCIAL	Etapa 1 importada
5db87c94-2cbc-4800-80e6-d2fe9e26ab0d	8cbbaf71-123a-4028-8701-1bbc9d11addb	2	432ad432-4f3a-45db-9952-fb1775b49969	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-08-06 03:00:00+00	2025-08-14 03:00:00+00	COMERCIAL	Etapa 2 importada
88f3d08e-8e06-4414-bfad-eaebbbb7135c	8cbbaf71-123a-4028-8701-1bbc9d11addb	3	432ad432-4f3a-45db-9952-fb1775b49969	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-08-16 03:00:00+00	2025-08-23 03:00:00+00	COMERCIAL	Etapa 3 importada
01bd2a2d-ad41-444f-8ce0-e9c06261fe8f	3d0ec652-e675-4e54-87e1-e4002c2071ae	1	1f6e6d84-215f-48d5-b131-5fe9f3e631da	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	2025-07-29 03:00:00+00	2025-09-13 03:00:00+00	COMERCIAL	Etapa 1 importada
d40b2750-f6b0-424b-953b-8a869d51192f	24f70169-1959-4cab-ae23-82c5aeb0f4db	1	517a5800-ded1-4a08-96cf-059e1492674f	\N	\N	2025-07-30 03:00:00+00	2025-08-04 03:00:00+00	COMERCIAL	Etapa 1 importada
dbb9738c-e4c6-4b24-ad67-157a849fe814	05c47332-39cf-463c-a303-9e3690b20c1b	1	517a5800-ded1-4a08-96cf-059e1492674f	\N	\N	2025-08-04 03:00:00+00	2025-08-14 03:00:00+00	COMERCIAL	Etapa 1 importada
312a36a2-c573-4d36-8ede-fab6d9150626	05c47332-39cf-463c-a303-9e3690b20c1b	2	517a5800-ded1-4a08-96cf-059e1492674f	\N	\N	2025-08-15 03:00:00+00	2025-09-07 03:00:00+00	COMERCIAL	Etapa 2 importada
5f1ca2be-33e3-4e21-a443-3cde01ecbaa8	3668dc11-0150-465c-b59d-c095b5880edf	1	517a5800-ded1-4a08-96cf-059e1492674f	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-08-01 03:00:00+00	2025-08-23 03:00:00+00	COMERCIAL	Etapa 1 importada
2334ef04-bd77-47a1-8e60-e4d8ba688cd5	72322443-97cf-4b46-b456-b54631f1577a	1	517a5800-ded1-4a08-96cf-059e1492674f	be29702b-a6a9-434d-8eb3-5705e0f7468f	be29702b-a6a9-434d-8eb3-5705e0f7468f	2025-08-03 03:00:00+00	2025-08-23 03:00:00+00	COMERCIAL	Etapa 1 importada
2fbed45d-3926-4521-bc45-b4f0defbdfdf	bded166c-2909-4047-80b9-2523a44d0ffc	1	517a5800-ded1-4a08-96cf-059e1492674f	\N	\N	2025-08-05 03:00:00+00	2025-08-13 03:00:00+00	COMERCIAL	Etapa 1 importada
191406f6-2a26-416e-9e91-97d4a61773f1	9c529880-1e35-4565-a4b7-5f8812ddab23	1	432ad432-4f3a-45db-9952-fb1775b49969	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-08-07 03:00:00+00	2025-08-14 03:00:00+00	COMERCIAL	Etapa 1 importada
4f9c47bf-71e5-49b5-85ec-ffff975b837a	9c529880-1e35-4565-a4b7-5f8812ddab23	2	432ad432-4f3a-45db-9952-fb1775b49969	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-08-20 03:00:00+00	2025-08-27 03:00:00+00	COMERCIAL	Etapa 2 importada
14ecfaca-7633-4729-b673-194b617e6a3b	9c529880-1e35-4565-a4b7-5f8812ddab23	3	432ad432-4f3a-45db-9952-fb1775b49969	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-08-29 03:00:00+00	2025-09-05 03:00:00+00	COMERCIAL	Etapa 3 importada
4df3e3f7-d872-4e60-a59f-9203ee3d9533	9c529880-1e35-4565-a4b7-5f8812ddab23	4	432ad432-4f3a-45db-9952-fb1775b49969	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-09-08 03:00:00+00	2025-09-16 03:00:00+00	COMERCIAL	Etapa 4 importada
70f8de27-ab1a-40f5-a104-9a50adfec359	8757510f-9cdc-489a-bb9c-f126e2446776	1	517a5800-ded1-4a08-96cf-059e1492674f	\N	\N	2025-08-08 03:00:00+00	2025-09-24 03:00:00+00	COMERCIAL	Etapa 1 importada
63ce92b4-ea23-482c-8d66-78cb995b4c81	263e0515-0653-47cf-aeeb-0d83c20136b7	1	517a5800-ded1-4a08-96cf-059e1492674f	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-08-07 03:00:00+00	2025-09-23 03:00:00+00	COMERCIAL	Etapa 1 importada
b9440a0d-b7af-4576-9f6c-c9c3d8f77be6	3a105dee-6c85-413a-b395-c0e497f6427d	1	432ad432-4f3a-45db-9952-fb1775b49969	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-08-14 03:00:00+00	2025-08-22 03:00:00+00	COMERCIAL	Etapa 1 importada
198bdcd3-0860-4225-a273-1237ec8835f8	3a105dee-6c85-413a-b395-c0e497f6427d	2	432ad432-4f3a-45db-9952-fb1775b49969	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-08-26 03:00:00+00	2025-09-05 03:00:00+00	COMERCIAL	Etapa 2 importada
80de3ac6-1c23-4473-9e50-8c26c248c643	3a105dee-6c85-413a-b395-c0e497f6427d	3	432ad432-4f3a-45db-9952-fb1775b49969	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-09-09 03:00:00+00	2025-09-09 03:00:00+00	COMERCIAL	Etapa 3 importada
493564fa-aa48-44c8-9d7e-42d2022c9c99	3a105dee-6c85-413a-b395-c0e497f6427d	4	432ad432-4f3a-45db-9952-fb1775b49969	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-09-13 03:00:00+00	2025-09-23 03:00:00+00	COMERCIAL	Etapa 4 importada
28ce6dbf-eb4b-4029-ac4c-16c9c28fb820	522ff31e-b483-4499-b463-1646d7bbecf1	1	432ad432-4f3a-45db-9952-fb1775b49969	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-08-16 03:00:00+00	2025-08-25 03:00:00+00	COMERCIAL	Etapa 1 importada
84f6901b-9af1-4772-86d4-e2b20830a6bb	522ff31e-b483-4499-b463-1646d7bbecf1	2	432ad432-4f3a-45db-9952-fb1775b49969	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-08-28 03:00:00+00	2025-09-06 03:00:00+00	COMERCIAL	Etapa 2 importada
f3394952-a88f-4875-969b-557066e77511	522ff31e-b483-4499-b463-1646d7bbecf1	3	432ad432-4f3a-45db-9952-fb1775b49969	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-09-08 03:00:00+00	2025-09-18 03:00:00+00	COMERCIAL	Etapa 3 importada
8a8061eb-af9a-4662-b47d-662c1f052bf8	168878f6-2c09-4c2f-96b2-7c565d714ce4	1	432ad432-4f3a-45db-9952-fb1775b49969	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-08-22 03:00:00+00	2025-09-22 03:00:00+00	COMERCIAL	Etapa 1 importada
01755c81-36e3-4386-b574-6ff2be916a62	c8dfc52f-c1bd-4779-b74e-934d0588d40d	1	517a5800-ded1-4a08-96cf-059e1492674f	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-08-19 03:00:00+00	2025-08-31 03:00:00+00	COMERCIAL	Etapa 1 importada
6d55cd26-237b-42a1-b4f8-b40810080ee3	376dcc57-0da3-4b0b-ab36-077e5c4fa1b8	1	517a5800-ded1-4a08-96cf-059e1492674f	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-08-20 03:00:00+00	2025-09-18 03:00:00+00	COMERCIAL	Etapa 1 importada
742f2e94-c43c-4de7-84ce-68578cb50d22	093f8ad7-80a3-4c59-bb85-bb25945d18ec	1	517a5800-ded1-4a08-96cf-059e1492674f	\N	\N	2025-08-25 03:00:00+00	2025-09-07 03:00:00+00	COMERCIAL	Etapa 1 importada
db94d9b8-a243-47b8-9489-214b12218f1c	21649eab-04d0-4a6b-b2c8-adca960ecb55	1	517a5800-ded1-4a08-96cf-059e1492674f	\N	\N	2025-08-31 03:00:00+00	2025-10-08 03:00:00+00	COMERCIAL	Etapa 1 importada
d530d490-3cb4-49df-abbc-7e5b4f17b9ac	540f0be6-4b03-447b-8a77-385d82878cce	1	432ad432-4f3a-45db-9952-fb1775b49969	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-08-30 03:00:00+00	2025-10-06 03:00:00+00	COMERCIAL	Etapa 1 importada
eea4d7be-22b5-4e97-a81b-958c5c68eb18	16b0d404-798b-4c26-8e09-9a22747a1beb	1	517a5800-ded1-4a08-96cf-059e1492674f	be29702b-a6a9-434d-8eb3-5705e0f7468f	be29702b-a6a9-434d-8eb3-5705e0f7468f	2025-09-04 03:00:00+00	2025-09-16 03:00:00+00	COMERCIAL	Etapa 1 importada
72245c63-c450-4b14-b888-2d7a35f105f7	a4312a3b-701d-4dd3-8f4e-366f572506cc	1	bdb064e1-c2c3-4e77-ac2a-64dc9bd12fbf	\N	\N	2025-09-10 03:00:00+00	2025-10-20 03:00:00+00	COMERCIAL	Etapa 1 importada
26d27467-c410-4a38-847d-f36141095fd2	3df4eabb-5b4f-41df-8833-0b4dbc680975	1	1f6e6d84-215f-48d5-b131-5fe9f3e631da	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	2025-09-11 03:00:00+00	2025-10-01 03:00:00+00	COMERCIAL	Etapa 1 importada
636a35c3-93d4-439b-8c47-b98bc6b3fceb	1cfdaa5b-bcdf-416b-995e-8b9b216a34f4	1	432ad432-4f3a-45db-9952-fb1775b49969	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-09-11 03:00:00+00	2025-10-18 03:00:00+00	COMERCIAL	Etapa 1 importada
867c8ab8-f955-4b11-bab9-858bcf83de54	4b7dd270-6186-42cb-8d04-3b3e569124dd	1	517a5800-ded1-4a08-96cf-059e1492674f	\N	\N	2025-09-13 03:00:00+00	2025-10-13 03:00:00+00	COMERCIAL	Etapa 1 importada
67112e2d-6c6a-4b64-91e6-4fc19dfefffa	109df6bb-70d5-497b-b552-28a569ff1694	1	1f6e6d84-215f-48d5-b131-5fe9f3e631da	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-10-14 03:00:00+00	2025-11-08 03:00:00+00	COMERCIAL	Etapa 1 importada
c62773ec-1ceb-46bb-a0eb-039bcd0955f1	d0c9ed52-4a8a-49df-9ddc-d72fce826e3f	1	1f6e6d84-215f-48d5-b131-5fe9f3e631da	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	2025-10-15 03:00:00+00	2025-11-08 03:00:00+00	COMERCIAL	Etapa 1 importada
9a80bb43-4b49-4180-9316-ff53a01a5677	00bb753f-6ef4-4752-8436-aa7a5c43373c	1	1f6e6d84-215f-48d5-b131-5fe9f3e631da	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	2025-10-11 03:00:00+00	2025-12-21 03:00:00+00	COMERCIAL	Etapa 1 importada
eea41fd8-10ba-4b11-9a67-afd3fcbb02f9	f3cf7249-aa35-4dcd-8fb4-2405662bb630	1	1f6e6d84-215f-48d5-b131-5fe9f3e631da	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	2025-10-11 03:00:00+00	2025-12-07 03:00:00+00	COMERCIAL	Etapa 1 importada
8e22b83b-d97a-49e2-912d-bf327a63efe4	b66d91a0-b721-4eb1-bf2e-33ca5e17bfc1	1	61617027-3911-4e52-91ac-c8612dac86c9	60cc1963-ba0f-4f37-ac75-cd04fdcd2ade	60cc1963-ba0f-4f37-ac75-cd04fdcd2ade	2025-09-16 03:00:00+00	2025-11-19 03:00:00+00	COMERCIAL	Etapa 1 importada
39af0cde-0dea-4a77-aadb-483b2474e213	cfe37ca3-621b-4d25-af16-c26ddabc88b6	1	517a5800-ded1-4a08-96cf-059e1492674f	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-09-19 03:00:00+00	2025-10-07 03:00:00+00	COMERCIAL	Etapa 1 importada
949be273-0b45-404b-b822-a2cb9dba18f3	24042599-75a4-4edc-808e-a45d354a2433	1	61617027-3911-4e52-91ac-c8612dac86c9	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-09-29 03:00:00+00	2025-10-30 03:00:00+00	COMERCIAL	Etapa 1 importada
3b413234-54d0-4ee2-87b7-90334c9bc0e1	9a1f1d18-7aba-4b1a-a5c5-23d674f27f02	1	61617027-3911-4e52-91ac-c8612dac86c9	be29702b-a6a9-434d-8eb3-5705e0f7468f	be29702b-a6a9-434d-8eb3-5705e0f7468f	2025-09-28 03:00:00+00	2025-11-07 03:00:00+00	COMERCIAL	Etapa 1 importada
f4db384e-889a-46c7-a5e1-448d8c54f310	c39c814e-21cf-4280-b2da-0d96ecc122ae	1	432ad432-4f3a-45db-9952-fb1775b49969	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-09-30 03:00:00+00	2025-10-05 03:00:00+00	COMERCIAL	Etapa 1 importada
4057570f-3d9f-4310-aaeb-b37dc2f3f0a5	c39c814e-21cf-4280-b2da-0d96ecc122ae	2	432ad432-4f3a-45db-9952-fb1775b49969	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-10-07 03:00:00+00	2025-10-12 03:00:00+00	COMERCIAL	Etapa 2 importada
d1eb4ead-24be-4ca3-8d17-80e9939e4d5f	c39c814e-21cf-4280-b2da-0d96ecc122ae	3	432ad432-4f3a-45db-9952-fb1775b49969	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-10-14 03:00:00+00	2025-10-18 03:00:00+00	COMERCIAL	Etapa 3 importada
f91fccf8-92ce-4a8c-a890-b598fe7c5640	c39c814e-21cf-4280-b2da-0d96ecc122ae	4	432ad432-4f3a-45db-9952-fb1775b49969	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-10-20 03:00:00+00	2025-10-24 03:00:00+00	COMERCIAL	Etapa 4 importada
6dc2b385-6e98-4a81-ba2e-b9e2bd823cf3	c39c814e-21cf-4280-b2da-0d96ecc122ae	5	432ad432-4f3a-45db-9952-fb1775b49969	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-10-26 03:00:00+00	2025-10-31 03:00:00+00	COMERCIAL	Etapa 5 importada
a6bc235e-ffd8-4ae9-8b25-2fa9cf8e3872	c39c814e-21cf-4280-b2da-0d96ecc122ae	6	432ad432-4f3a-45db-9952-fb1775b49969	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-11-01 03:00:00+00	2025-11-09 03:00:00+00	COMERCIAL	Etapa 6 importada
0c608120-623f-4812-800b-da5f5b5d7ccd	e68fbab9-7cab-462d-8007-f8a1d7e9028d	1	432ad432-4f3a-45db-9952-fb1775b49969	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-10-14 03:00:00+00	2025-11-23 03:00:00+00	COMERCIAL	Etapa 1 importada
85649b12-65fd-4a5b-a069-bb44837dbef4	9d972f17-ae4a-47b2-8b30-366a0bb26fe9	1	1f6e6d84-215f-48d5-b131-5fe9f3e631da	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	2025-10-11 03:00:00+00	2025-12-07 03:00:00+00	COMERCIAL	Etapa 1 importada
da530b09-95cc-4f8a-8cda-944db0cc209e	8fe5e963-1d40-4c41-a20a-ac7ec9bd820b	1	432ad432-4f3a-45db-9952-fb1775b49969	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-10-19 03:00:00+00	2025-10-23 03:00:00+00	COMERCIAL	Etapa 1 importada
0b4d3b2a-884b-424b-8911-d323ade4881e	8fe5e963-1d40-4c41-a20a-ac7ec9bd820b	2	432ad432-4f3a-45db-9952-fb1775b49969	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-10-24 03:00:00+00	2025-10-29 03:00:00+00	COMERCIAL	Etapa 2 importada
290543b2-b884-4c76-995a-9341954d844b	8fe5e963-1d40-4c41-a20a-ac7ec9bd820b	3	432ad432-4f3a-45db-9952-fb1775b49969	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-11-03 03:00:00+00	2025-11-10 03:00:00+00	COMERCIAL	Etapa 3 importada
ef599730-b341-49ff-b94b-5de523f88b1b	a395bcdb-6342-42b5-a96c-44d9ca052548	1	bdb064e1-c2c3-4e77-ac2a-64dc9bd12fbf	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-10-30 03:00:00+00	2025-12-11 03:00:00+00	COMERCIAL	Etapa 1 importada
bbfa24cf-8099-4d21-b5e0-b83a8cda7eeb	88ef4a5c-ce79-4651-9fe2-7747985eeb8a	1	1f6e6d84-215f-48d5-b131-5fe9f3e631da	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	2025-10-23 03:00:00+00	2025-11-26 03:00:00+00	COMERCIAL	Etapa 1 importada
1fe861fc-68a8-445b-ad4d-840b56a4c438	22208c66-1e34-4f59-90f5-eb97cf2c9c6f	1	61617027-3911-4e52-91ac-c8612dac86c9	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-10-29 03:00:00+00	2025-11-20 03:00:00+00	COMERCIAL	Etapa 1 importada
d6183d00-34ff-4948-8be7-c4d93b518187	b77d5c5d-c8bc-4c97-a88c-866691153446	1	bdb064e1-c2c3-4e77-ac2a-64dc9bd12fbf	\N	\N	2025-10-27 03:00:00+00	2025-12-07 03:00:00+00	COMERCIAL	Etapa 1 importada
fc9405b9-e66d-4a42-8395-1486e59b5741	083c2730-a3d2-434c-a86d-d5e699ad09c6	1	432ad432-4f3a-45db-9952-fb1775b49969	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-11-04 03:00:00+00	2025-11-12 03:00:00+00	COMERCIAL	Etapa 1 importada
f3d57969-4a36-42df-a241-ce96464bff4d	083c2730-a3d2-434c-a86d-d5e699ad09c6	2	432ad432-4f3a-45db-9952-fb1775b49969	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-11-14 03:00:00+00	2025-11-18 03:00:00+00	COMERCIAL	Etapa 2 importada
b118fbb7-60cd-4ce6-97ea-0064e99d291c	083c2730-a3d2-434c-a86d-d5e699ad09c6	3	432ad432-4f3a-45db-9952-fb1775b49969	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-11-22 03:00:00+00	2025-11-27 03:00:00+00	COMERCIAL	Etapa 3 importada
6b947e39-9d04-4bd2-ba63-e79584cb9f31	083c2730-a3d2-434c-a86d-d5e699ad09c6	4	432ad432-4f3a-45db-9952-fb1775b49969	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-11-30 03:00:00+00	2025-12-06 03:00:00+00	COMERCIAL	Etapa 4 importada
2c2b1e8a-7dd6-4970-9664-159763900e79	3dca4d4a-625c-4c35-b422-42765b8887b5	1	432ad432-4f3a-45db-9952-fb1775b49969	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-11-01 03:00:00+00	2025-11-12 03:00:00+00	COMERCIAL	Etapa 1 importada
2e84d27b-7aac-4695-9035-61616b7b893e	2fc23898-cd14-4418-81e4-9c3b309fa4c7	1	432ad432-4f3a-45db-9952-fb1775b49969	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-11-03 03:00:00+00	2025-11-12 03:00:00+00	COMERCIAL	Etapa 1 importada
ad55a408-3286-44f2-81ab-85ccd8d9754f	2fc23898-cd14-4418-81e4-9c3b309fa4c7	2	432ad432-4f3a-45db-9952-fb1775b49969	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-11-14 03:00:00+00	2025-11-21 03:00:00+00	COMERCIAL	Etapa 2 importada
1c06cf75-3f20-4388-81b9-f50fd23b0636	2fc23898-cd14-4418-81e4-9c3b309fa4c7	3	432ad432-4f3a-45db-9952-fb1775b49969	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-11-23 03:00:00+00	2025-12-01 03:00:00+00	COMERCIAL	Etapa 3 importada
c42ff990-d46e-4308-b120-7c349747821d	2fc23898-cd14-4418-81e4-9c3b309fa4c7	4	432ad432-4f3a-45db-9952-fb1775b49969	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-12-03 03:00:00+00	2025-12-11 03:00:00+00	COMERCIAL	Etapa 4 importada
99f68d2d-6d22-4b2a-86ce-bdb074691a20	7fe6021d-1b3d-45e7-a376-5badbba0a3a8	1	1f6e6d84-215f-48d5-b131-5fe9f3e631da	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	2025-11-07 03:00:00+00	2025-11-25 03:00:00+00	COMERCIAL	Etapa 1 importada
865e1723-1618-4091-8536-c40e40663d66	7fe6021d-1b3d-45e7-a376-5badbba0a3a8	2	1f6e6d84-215f-48d5-b131-5fe9f3e631da	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	2025-11-28 03:00:00+00	2025-12-21 03:00:00+00	COMERCIAL	Etapa 2 importada
1575bb42-f6b2-4eb5-88f5-185478dd2b97	4a5c5e10-ffa3-4422-87a6-c925c6138561	1	\N	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-11-04 03:00:00+00	2025-11-11 03:00:00+00	COMERCIAL	Etapa 1 importada
f88dee7d-ca89-4d3f-b3ca-7004577e338c	023cb4a6-22c9-4687-8693-62a4318afbe4	1	1f6e6d84-215f-48d5-b131-5fe9f3e631da	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-11-12 03:00:00+00	2025-12-24 03:00:00+00	COMERCIAL	Etapa 1 importada
a32d1c3b-e71a-4c00-a1fa-8ae53f3e3ad2	2d1064a6-728d-4f92-b76b-cf8ee04e4c1b	1	bdb064e1-c2c3-4e77-ac2a-64dc9bd12fbf	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-11-10 03:00:00+00	2025-12-12 03:00:00+00	COMERCIAL	Etapa 1 importada
890b77d3-d984-4b98-8346-baa6a3ca8150	d7236007-806b-488e-94f5-756e7d7834b6	1	61617027-3911-4e52-91ac-c8612dac86c9	60cc1963-ba0f-4f37-ac75-cd04fdcd2ade	60cc1963-ba0f-4f37-ac75-cd04fdcd2ade	2025-11-20 03:00:00+00	\N	COMERCIAL	Etapa generada automáticamente (sin desglose)
2906c541-985f-418e-b6d2-ae59c5809ec3	755126aa-1acb-4811-a11c-61fe28666abe	1	1f6e6d84-215f-48d5-b131-5fe9f3e631da	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	2025-11-20 03:00:00+00	\N	COMERCIAL	Etapa generada automáticamente (sin desglose)
889c7532-e341-4636-94ca-381f516f4ec1	78b3e48f-e4c0-482c-b8f0-8b83a0ab93b6	1	61617027-3911-4e52-91ac-c8612dac86c9	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	2025-11-26 03:00:00+00	\N	COMERCIAL	Etapa generada automáticamente (sin desglose)
c86d94a9-3343-428f-b34a-0cc8007b66b0	c3d4cbee-815e-4c25-83fa-ebc0463f5302	1	432ad432-4f3a-45db-9952-fb1775b49969	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-12-01 03:00:00+00	2025-12-16 03:00:00+00	COMERCIAL	Etapa 1 importada
dcb7bb42-73e1-49ea-ab2b-66d2c178080a	cbe37b7f-10aa-4e41-b3f9-f588eaf39416	1	bdb064e1-c2c3-4e77-ac2a-64dc9bd12fbf	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-12-15 03:00:00+00	\N	COMERCIAL	Etapa generada automáticamente (sin desglose)
65359d3a-c59e-471a-9996-0727eebd6ec6	733db549-6d27-4288-92a0-0d0b8c25a066	1	bdb064e1-c2c3-4e77-ac2a-64dc9bd12fbf	\N	\N	2025-12-15 03:00:00+00	\N	COMERCIAL	Etapa generada automáticamente (sin desglose)
7e1ef5b5-7a83-4be6-b421-bd83bf01b33d	271c1caf-e5c3-4d61-b129-1799df158cd4	1	61617027-3911-4e52-91ac-c8612dac86c9	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-12-29 03:00:00+00	\N	COMERCIAL	Etapa generada automáticamente (sin desglose)
07de40c1-d9c2-49dc-8bca-6b7907f62354	9328412a-37ab-400c-858f-e61b75e4f0b4	1	c6c01567-eed9-4f78-a59d-f5aec4523577	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	2025-12-26 03:00:00+00	\N	COMERCIAL	Etapa generada automáticamente (sin desglose)
0b518ebb-9d7c-4582-a7cd-579fa234d566	623715c7-a1a0-414b-95c5-638f9da9476f	1	c6c01567-eed9-4f78-a59d-f5aec4523577	be29702b-a6a9-434d-8eb3-5705e0f7468f	be29702b-a6a9-434d-8eb3-5705e0f7468f	2025-12-29 03:00:00+00	\N	COMERCIAL	Etapa generada automáticamente (sin desglose)
796eca0f-1544-470c-b73f-48e9c62bb010	2b9b049f-0b05-4186-a760-999378fae1d4	1	c6c01567-eed9-4f78-a59d-f5aec4523577	20e6681d-78b9-4d78-8fff-3549a0c294bd	20e6681d-78b9-4d78-8fff-3549a0c294bd	2025-12-29 03:00:00+00	\N	COMERCIAL	Etapa generada automáticamente (sin desglose)
660fde9a-5aef-4808-9c8c-3f398b4267d9	3314a148-6f3a-4b68-8210-fbed75f9f6f2	1	c6c01567-eed9-4f78-a59d-f5aec4523577	\N	\N	2025-12-26 03:00:00+00	\N	COMERCIAL	Etapa generada automáticamente (sin desglose)
0587cad3-9f4b-4f7e-b8b5-e29ded8b139e	3dc30ae3-9ab2-41a1-96e8-a90813e21660	1	c6c01567-eed9-4f78-a59d-f5aec4523577	\N	\N	2025-12-26 03:00:00+00	\N	COMERCIAL	Etapa generada automáticamente (sin desglose)
c3f4bc46-d43e-473e-9814-395ead701e50	386f1408-c146-4dc3-95d7-1be4a877d8a0	1	1f6e6d84-215f-48d5-b131-5fe9f3e631da	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	2025-12-26 03:00:00+00	\N	COMERCIAL	Etapa generada automáticamente (sin desglose)
21795f64-4594-4faf-ba1e-620eef6790f1	e297ded4-a1ea-4889-82fd-7c0a48c6384e	1	1f6e6d84-215f-48d5-b131-5fe9f3e631da	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	2025-12-30 03:00:00+00	\N	COMERCIAL	Etapa generada automáticamente (sin desglose)
c2dd433b-b69d-4e2c-b91c-1ac4b89bbdd1	6b158ecf-f330-40b4-aee6-b21dd16df254	1	1f6e6d84-215f-48d5-b131-5fe9f3e631da	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	2025-12-23 03:00:00+00	\N	COMERCIAL	Etapa generada automáticamente (sin desglose)
ec3c8953-56c0-4eb8-9e09-8aa15935ef82	0973b5fb-c2f5-4f33-a5ba-0b4683dbbd43	1	1f6e6d84-215f-48d5-b131-5fe9f3e631da	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	2025-12-30 03:00:00+00	\N	COMERCIAL	Etapa generada automáticamente (sin desglose)
a7ce5d32-766b-44aa-9f88-364b02e4a0ea	e0ef1cb2-5858-47a7-9e37-a3861a1f973e	1	c6c01567-eed9-4f78-a59d-f5aec4523577	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-12-29 03:00:00+00	\N	COMERCIAL	Etapa generada automáticamente (sin desglose)
6db63f26-f23c-4a54-9892-389a9a02c6d2	2b695782-a8d3-41f2-9823-c2179105c9b5	1	bdb064e1-c2c3-4e77-ac2a-64dc9bd12fbf	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-12-26 03:00:00+00	\N	COMERCIAL	Etapa generada automáticamente (sin desglose)
975b47d2-2c2b-4c91-9c9f-5a6438b60b83	9ad97187-9a07-4de5-a26d-be5bf17d6ccf	1	c6c01567-eed9-4f78-a59d-f5aec4523577	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-12-28 03:00:00+00	\N	COMERCIAL	Etapa generada automáticamente (sin desglose)
d8c6f631-82bf-4c69-88fc-ac3e2a2af78b	48792e89-3021-4c44-a4b2-f18b5ae3c143	1	c6c01567-eed9-4f78-a59d-f5aec4523577	37a047f1-e311-4664-b056-6f4311757b33	37a047f1-e311-4664-b056-6f4311757b33	2025-12-28 03:00:00+00	\N	COMERCIAL	Etapa generada automáticamente (sin desglose)
\.


--
-- Data for Name: mareas_etapas_observadores; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mareas_etapas_observadores (id, id_etapa, id_observador, rol, es_designado) FROM stdin;
d2ac4964-ca43-4637-9110-2da1d708182d	e74af73d-0394-4d1c-b695-2bfb360cbddd	cf1a1fb4-3215-4a72-b355-854e6ddd3404	PRINCIPAL	t
ce6b5200-3cab-4544-89bd-3890c4e177b2	1bc2f4c6-cdd8-4214-adbd-dd08bde8c9d8	2ee42832-ae90-451a-ae1d-fdc01bdd8ef9	PRINCIPAL	t
00951d3f-1497-4fb5-9286-5d9684b3fe38	b94d3a4e-85d6-45df-b092-a4d33dc31ba9	2d16fe4a-b2f1-4564-afe3-72f1c57b7862	PRINCIPAL	t
7484c9c6-fcc8-4b3b-be46-abf5ab1677ae	0f1f04ce-e3ce-4062-8b71-3fc226123220	b158ed18-7849-4fbe-8438-f28936590335	PRINCIPAL	t
c984796b-46fb-4595-8330-e23af8f0d6e1	6bb9fadf-688a-44be-9eee-c3a1b3f2dde7	c253759a-a3d6-49a8-a726-e1493e2f1931	PRINCIPAL	t
82ac28f2-e11b-4b3f-b93e-112edf0b38ec	83eb3c0b-1ed9-4cfa-89b9-d4b42211911a	8915b3b3-fa15-4321-be4b-1ba07f8e8f38	PRINCIPAL	t
15519f0a-b219-45e2-83c1-7a2cf1e5003f	ffbdc9fb-43b2-4ab7-a628-914470e0f1cb	731fd398-1652-42d0-9804-b77459f11206	PRINCIPAL	t
9a1695a9-d41b-459b-bfc5-d37dd273780e	f8830b1f-5a91-42f4-8274-80360745e855	e3f7879d-410e-46d4-96b3-9d219be9e4d2	PRINCIPAL	t
79d93c04-68b0-4f1c-a1bb-ed10da670d22	34d33170-5fe0-4287-8de7-ff25e9272f16	e3f7879d-410e-46d4-96b3-9d219be9e4d2	PRINCIPAL	t
a7977483-671d-4259-b3ee-b335f1110c55	b5232333-77dd-451d-b1d4-6d1d2e550613	e3f7879d-410e-46d4-96b3-9d219be9e4d2	PRINCIPAL	t
3c49194f-c559-49b6-9b0a-a46943a92a81	f4a00854-24d0-41db-af96-135597528692	3cbc14f6-0180-4fcc-8f04-e21dd972623e	PRINCIPAL	t
71556d6c-5a02-4c96-8471-9f237d82aa27	0abbbd3a-7906-4bee-bd79-b448add9b24d	2bb2a2a1-5a0a-4295-930c-04492e2d0934	PRINCIPAL	t
9fdf4807-e9f5-416c-bc97-9522b4cebf23	48977018-4681-4080-b00f-26e92139cca1	e1a54806-ba2e-4829-9a29-1ff5421bf0bf	PRINCIPAL	t
2f56daaa-c6c8-400e-abcf-620197b93ce0	c51c42a6-cf38-425b-a6c9-7fe29af2db56	e392011c-4a48-45a1-9b22-411aec8ba356	PRINCIPAL	t
2d755458-a175-4baa-912c-c4ffc81ecb80	aa8dfdb0-dbe7-47de-ac6b-3f88cae67d4b	cf271634-bab5-4cdc-8f9d-10e6b1410777	PRINCIPAL	t
2ba61e41-2949-4957-932e-222b1673d411	0581102e-c139-48b6-9154-1a8bd40eae5a	00235e22-7a6a-4fc3-8312-9824b6bd9b1c	PRINCIPAL	t
901e0c07-7d4b-445e-a175-f2b431a373e1	292551e6-8e6c-4e20-9f49-8bb382b95101	2e775ee6-e842-48c9-8a74-73172324071b	PRINCIPAL	t
7348a806-c8e4-4c11-aeee-3b4e9e696fcd	dcdcfe2f-9312-4764-be20-8d94aeddc8af	2e775ee6-e842-48c9-8a74-73172324071b	PRINCIPAL	t
e6a16a01-7c2b-49eb-9ab8-54008d68cce6	a932e7b2-5a50-4e6b-8043-a23021698dde	2e775ee6-e842-48c9-8a74-73172324071b	PRINCIPAL	t
1cb8a7c1-0a2e-4c38-8819-bf5907199b23	eef5db0a-a3f0-4e7f-b3f0-8548f7e4a0e7	2e775ee6-e842-48c9-8a74-73172324071b	PRINCIPAL	t
d84bf57c-7780-45b6-bdaf-20e657465a48	1e856d22-280a-4783-a8fd-ee43ecbf5702	0652f854-58ce-451f-9fe0-72c2ef8937ac	PRINCIPAL	t
19cee73c-369a-4a40-b2f0-bf24720c019a	3a1a3824-1b2a-444f-8aa5-9d6b1a061909	809add91-4b45-4802-8910-46ceb852a8ab	PRINCIPAL	t
1c670ab6-b5a7-43ed-b91d-2b0a5f1017ae	984525df-097a-4c34-90df-f836827cebc1	166f92e6-0063-4ab7-aadf-e65aa3421943	PRINCIPAL	t
9fc1c033-6cc4-44b5-9318-9bc1a9a29f25	97f9a7d5-6a19-492f-b4a4-b54643895b56	c44af00b-9c37-4656-a350-89ef47afcea1	PRINCIPAL	t
cda0e6a9-894a-4a15-a409-d556434f5e25	102d2389-1809-4339-913e-3ef1ce2d519c	8915b3b3-fa15-4321-be4b-1ba07f8e8f38	PRINCIPAL	t
058040ce-e2fc-4cb2-bf22-52fe6298dc2e	4ef19abf-7f6e-41b1-97f4-d22a20db73e6	e7f78d95-1d7c-4e4f-906d-241d9df67db4	PRINCIPAL	t
c8c1a349-aa10-4e76-85e8-11ae6dd851fe	f08ddf70-6785-4f47-917d-da3a5b544bb3	bb8242a7-b45d-42af-9c93-1e7922fb6457	PRINCIPAL	t
00fd119c-e37b-43db-8a51-74fab7b0daa3	ead5b1b3-91ac-47c6-84cb-d56c082167f0	809add91-4b45-4802-8910-46ceb852a8ab	PRINCIPAL	t
e5013aa0-8049-4b19-b47c-a3d41acd156a	6749294c-00dc-4efc-96a9-b84bce028ddd	809add91-4b45-4802-8910-46ceb852a8ab	PRINCIPAL	t
270a6609-0c62-4133-98c3-71c59c926729	cf8620bc-500d-4b40-b5a2-83d60c0513b9	2ee42832-ae90-451a-ae1d-fdc01bdd8ef9	PRINCIPAL	t
0cf9d781-8839-4b2b-bdeb-d17cfb36443b	126aeef1-ae1d-4a8a-9a57-1da079c50c1c	f606418d-2704-434d-ab29-89e900be6357	PRINCIPAL	t
cdcea336-91bb-4a3f-aed7-88decc988118	13354b19-a0c5-42cf-b9c2-334bd4ef29b1	534dd89b-5aad-4b50-9e4c-13ddce20542c	PRINCIPAL	t
b6440e90-084b-47aa-b94d-6341e2048050	6b0099e0-e715-460f-aecd-5d7f96f7836f	7eeef79b-8ba7-42e8-a94e-ec51c4751538	PRINCIPAL	t
d7755312-f07a-4232-978a-795ec15d96f3	7ca4df94-6d97-41a7-9cff-33d28fc219aa	f9b3caae-043b-4e88-8cca-b613dae4e560	PRINCIPAL	t
44a454cd-ec3e-4249-b4ad-bbe6a81899b5	d267ba9b-98ec-4368-a091-0e6fe1fe5560	ee36a2a7-39c9-445f-af0b-7b2b36f31f5b	PRINCIPAL	t
453ab790-50af-4198-a8e0-31bff01c1b97	75dfd5e0-fc09-4c05-89ba-a14b57d18aed	711c10ff-6f1f-433f-89da-903b099f962a	PRINCIPAL	t
56ae62b5-6629-4ab6-bf06-3b12b753772d	4952fc35-e620-4316-bc57-57dd5c595515	d15b3fed-415d-42ff-a463-99004a462acb	PRINCIPAL	t
4ca8c374-7cd4-45ff-b8a1-3be055aabd23	f275feab-d4f5-4ad9-85aa-a1b95a388445	143e60e7-c2f2-488d-856e-aca349916c07	PRINCIPAL	t
06ca0a0f-03be-4649-99e6-3cfd864fb9d7	5205c194-16ad-49d7-9c51-bf733ae250b7	731fd398-1652-42d0-9804-b77459f11206	PRINCIPAL	t
9af3b461-9e36-4a8c-b649-eb1bf4db1845	915a2c3c-c7b8-4f06-ba92-10ceb18bd666	e1a54806-ba2e-4829-9a29-1ff5421bf0bf	PRINCIPAL	t
963f94a1-fe23-4c72-b169-8f25a1ec5aa1	f4a525d9-0273-495f-ac4a-9cf29ea3daa1	e392011c-4a48-45a1-9b22-411aec8ba356	PRINCIPAL	t
eba63b28-9c61-458b-be1e-f0390f68c8ff	392146ee-368e-4201-8199-3538fecaface	6e82a5b4-f118-400d-b68c-f2d0eed01a58	PRINCIPAL	t
db3cf65d-9802-4027-aca5-856343024224	69db90b9-e6c0-4a56-91cb-9769f779bf33	3cbc14f6-0180-4fcc-8f04-e21dd972623e	PRINCIPAL	t
028d56f0-b5f0-4860-b3c0-a4ad59b944ea	313c61ac-8bc2-4cf2-81d3-ad1a86f67a46	b31fe5f0-fffb-4083-b95a-c8800910b922	PRINCIPAL	t
fb93d586-efa4-4138-a4e8-dd1a26be7bfd	400e2754-7c2d-498e-901c-569fef9d8c9d	0652f854-58ce-451f-9fe0-72c2ef8937ac	PRINCIPAL	t
c1a24895-8d92-426e-ba27-394f879cafab	f8780048-280c-4b03-a1b1-7a344c7b59c7	cbd9458a-5f5a-471c-94d1-ae071fcce490	PRINCIPAL	t
42574afa-36f3-4643-9738-2d76b5311468	a8fc09d8-34b6-4731-8068-44320ec729e9	4a0b6270-5d0a-434c-b433-574029a2849a	PRINCIPAL	t
23e697a6-2647-4f54-871b-334b984f131a	e1b88b8a-6200-4bc6-99e7-d2211b482433	4a0b6270-5d0a-434c-b433-574029a2849a	PRINCIPAL	t
3e5fc6b4-e545-429e-a1f6-959c02b9912d	e66d1555-17cf-449f-8bb3-9d140af29a78	40947cb3-4afb-49f8-8dd2-fe40d5a52553	PRINCIPAL	t
2feb75e7-f95b-440d-b88e-b6d2cbb5e6bc	24148afd-7bb1-43bd-8a9a-791264dc8680	40947cb3-4afb-49f8-8dd2-fe40d5a52553	PRINCIPAL	t
4369b606-7574-44db-a614-9ef3ab24ff3f	7c21d3a7-5457-419f-9c8a-9c74356b9f06	cf1a1fb4-3215-4a72-b355-854e6ddd3404	PRINCIPAL	t
5bcde53e-6174-40be-93b4-c68984100448	c823d0ab-6ea5-45ed-ba27-51c83b3d282b	cf1a1fb4-3215-4a72-b355-854e6ddd3404	PRINCIPAL	t
ef367bf4-ddf4-4085-abe1-a0b59b44c4e3	2512899e-3619-437d-b081-3b62bc23737b	731fd398-1652-42d0-9804-b77459f11206	PRINCIPAL	t
cedf58ab-0b30-42b9-830b-2b8b7ea89669	d16a96bf-6382-405f-8d32-d13b4b4a0c04	731fd398-1652-42d0-9804-b77459f11206	PRINCIPAL	t
97c0c94c-be24-49ac-b4a2-fb3092f2154e	c2b7b65c-d6e0-4d03-b0f8-9243a4d7bb97	cf271634-bab5-4cdc-8f9d-10e6b1410777	PRINCIPAL	t
2396c8de-b5e9-4b78-913d-9f97aa407b21	9cb41554-5c33-4b02-8d03-3e67870031e1	cf271634-bab5-4cdc-8f9d-10e6b1410777	PRINCIPAL	t
b59b5ae7-56ef-4942-b083-dfd204ac7c60	c6185503-ac41-4a3c-a066-97d0ebf0ec30	434c265e-3937-4502-90d8-6eb2f627df3a	PRINCIPAL	t
8f34b392-2f1b-4c67-88c4-510b91f1b6aa	37907746-a896-4083-a138-a1cfc7d8bcd4	e0c63dad-5899-4aaf-9610-02f3dc0ed787	PRINCIPAL	t
3d5052c1-92f2-4193-a21e-b26016544e11	27ae50ac-00d6-40cb-8cbe-e1d4df97c45f	b158ed18-7849-4fbe-8438-f28936590335	PRINCIPAL	t
452fb289-26c5-43e3-bfa3-1dfa7955be92	846b5474-6d5a-4f17-9726-6f6d24b94e7e	f606418d-2704-434d-ab29-89e900be6357	PRINCIPAL	t
0d672ec8-5754-47c1-8ea7-99e546caa93e	9aa2c272-39be-489b-a77d-d189cc27ba0e	2bb2a2a1-5a0a-4295-930c-04492e2d0934	PRINCIPAL	t
d3156b21-f048-44e3-8703-f6ca664217ce	c1c1f61e-1c77-4a1d-8239-848e11844171	f38f0451-192f-4ccc-af81-2b1056ff0060	PRINCIPAL	t
d3d5823d-480a-4000-9062-96cb3aeec755	f474a5bf-ef03-43c6-8fc7-a0f90a9395ac	c44af00b-9c37-4656-a350-89ef47afcea1	PRINCIPAL	t
0d3eeb48-a3e8-481b-86b2-b6c9e56ab35f	c8a3556c-63fd-49c1-825b-064db996d4d7	b31fe5f0-fffb-4083-b95a-c8800910b922	PRINCIPAL	t
b275bcd3-9416-474b-9e0a-f89b34d216f6	e89c055c-ef3d-4e98-ad5a-c197df3a2a48	2ee42832-ae90-451a-ae1d-fdc01bdd8ef9	PRINCIPAL	t
2587f733-05f6-4fe7-815e-b0c9a862fb4a	44850265-a6bd-437b-a7d5-bb76b2b3986a	c253759a-a3d6-49a8-a726-e1493e2f1931	PRINCIPAL	t
d02daf5e-d13c-4795-a486-db57f14f394c	9475331d-3c35-4a26-ba4c-03b8274cc4df	cf271634-bab5-4cdc-8f9d-10e6b1410777	PRINCIPAL	t
c2fea3e4-8be5-4ac7-849c-3d1a602ee840	6d73ce53-a5ea-474a-9446-39fc822e7718	cbd9458a-5f5a-471c-94d1-ae071fcce490	PRINCIPAL	t
a0158fd5-f232-43f4-bbd7-fac025923da4	fe912088-91b8-4d4e-b87c-22a0e0f22341	166f92e6-0063-4ab7-aadf-e65aa3421943	PRINCIPAL	t
a217c4b9-439e-44db-a3dc-73c95bff600c	45f60a8b-87c0-4d0c-8928-0302ea10d693	2d16fe4a-b2f1-4564-afe3-72f1c57b7862	PRINCIPAL	t
4394792c-be84-4471-850c-108f2b608647	8f299e27-c7a7-4cff-a52e-d1bb082935af	40947cb3-4afb-49f8-8dd2-fe40d5a52553	PRINCIPAL	t
55630289-e783-43a5-b7e1-e86d11c53ca7	13b16d4b-8794-44fc-8670-d2503aaf22d0	731fd398-1652-42d0-9804-b77459f11206	PRINCIPAL	t
e0e26b22-0555-4a35-80e7-6fa4b4caa0b6	dce4fae1-6175-422d-9fa3-761fac3bc9dc	4a0b6270-5d0a-434c-b433-574029a2849a	PRINCIPAL	t
4993938f-1092-4de5-82f1-4e98b43a634d	c40245ce-c278-412d-a59e-c61f1509045a	4a0b6270-5d0a-434c-b433-574029a2849a	PRINCIPAL	t
959a4641-b892-4de5-95f1-0154288617f0	7b9ff9a8-5800-46dc-8ff6-ddea6a593840	4a0b6270-5d0a-434c-b433-574029a2849a	PRINCIPAL	t
176f441a-1391-45f2-a489-88b55f8eaa5d	c64c11db-6662-4fab-8288-e7fc3336f034	2e775ee6-e842-48c9-8a74-73172324071b	PRINCIPAL	t
a066fd25-4498-42f1-900d-9c16780bba85	fced129a-3de2-4366-9662-321e776198a3	ee36a2a7-39c9-445f-af0b-7b2b36f31f5b	PRINCIPAL	t
d5748deb-ba5b-4a18-b291-b14338940918	49fec0b7-b779-45e4-9773-c1094eb10dde	ee36a2a7-39c9-445f-af0b-7b2b36f31f5b	PRINCIPAL	t
1cc89e6e-eff9-496e-b7b1-e58300c229ba	652c258a-5b92-4a41-953e-747405d02de0	ee36a2a7-39c9-445f-af0b-7b2b36f31f5b	PRINCIPAL	t
abf66681-91aa-4588-98f1-5620a43943ad	983bf111-2c9b-4823-b385-bac1988a7278	cf1a1fb4-3215-4a72-b355-854e6ddd3404	PRINCIPAL	t
74f875b2-cc34-4897-bc78-c2d2ff09e39f	18f8bb97-ca53-4719-8825-e8881382ebd2	cf1a1fb4-3215-4a72-b355-854e6ddd3404	PRINCIPAL	t
123d2fee-3941-453c-a5fe-cdd20e4c9124	2862b777-f0da-4231-b0cc-4f6f3e358d76	f9b3caae-043b-4e88-8cca-b613dae4e560	PRINCIPAL	t
9b890584-ab27-4898-9760-9c40ce2f4b2c	18607cc9-8ffc-4106-a5e2-579e3e12bf13	e3f7879d-410e-46d4-96b3-9d219be9e4d2	PRINCIPAL	t
c8d3d29e-2c03-419d-87b3-542335822ca3	e81ff8c2-5baa-49db-b103-482ea4b40de8	e3f7879d-410e-46d4-96b3-9d219be9e4d2	PRINCIPAL	t
f9fe3c18-1c11-44dc-b654-825151cf077c	9a90aa09-f8c3-4380-9288-6665f2f70bb6	e3f7879d-410e-46d4-96b3-9d219be9e4d2	PRINCIPAL	t
9637d1d8-1352-4d5e-8cda-c2eb5a985416	a6c6f8db-2365-44b5-8ec3-c331ca9753c6	f606418d-2704-434d-ab29-89e900be6357	PRINCIPAL	t
4e48d022-1bca-46b8-a0e8-6a88eed1c88f	1b3c5148-c1d9-4fbe-b8f2-5295f72668e1	e5360c26-72c6-415c-8e57-1d7221482151	PRINCIPAL	t
99bbd576-5f52-424f-93cd-85cbcd6cfa19	131000b5-5189-4d1a-93b0-69b16c110c8c	e5360c26-72c6-415c-8e57-1d7221482151	PRINCIPAL	t
f2d74d2f-a52e-4b61-8a23-a9c9a740b4d4	1b72b5b3-235f-46b2-b0c6-ec559bd9922f	4b3eda38-f5c1-4793-87e9-b2fcf6dea236	PRINCIPAL	t
5fec5303-c852-4579-bd65-0d976262e71f	fb1587ef-fccd-4026-b74b-21bda1d7fe0f	aed52619-5540-4220-bf13-189dbd2a4f39	PRINCIPAL	t
afd50daf-3640-4d1f-b7eb-357e8b01330f	c0221f53-f058-4a56-8db3-b2f197b06a5c	8915b3b3-fa15-4321-be4b-1ba07f8e8f38	PRINCIPAL	t
cfa9ca9c-3342-40d8-87b8-54caaac12144	22ef5208-d984-4502-9215-03e470adbb67	8915b3b3-fa15-4321-be4b-1ba07f8e8f38	PRINCIPAL	t
6b2b1688-4dd9-4746-acf1-ba7195356c48	4e64cb28-4eff-490f-b502-8cac4cbc98b0	8915b3b3-fa15-4321-be4b-1ba07f8e8f38	PRINCIPAL	t
64b8f72e-410f-4bcd-aa1e-916af09d1b15	cb49074d-3422-4ef8-8478-99a38515f4bc	b158ed18-7849-4fbe-8438-f28936590335	PRINCIPAL	t
37d9f880-ea7a-47d1-9306-a0b23accaabb	c78a5fd6-7aae-425c-91fa-d085fa427432	809add91-4b45-4802-8910-46ceb852a8ab	PRINCIPAL	t
63c555e0-e4f8-462e-b560-0a5d3244e805	d2a8557b-b358-4430-a92e-88608435468f	e392011c-4a48-45a1-9b22-411aec8ba356	PRINCIPAL	t
7d3f87b1-3846-4bfe-980a-e9800abbfdef	7529aece-3542-41e4-87c0-0c4aa0d8b711	434c265e-3937-4502-90d8-6eb2f627df3a	PRINCIPAL	t
36ba25c0-0c43-44b9-b013-a4e66ffcf43d	305e9a61-8626-462c-8abd-587327030166	64095940-467c-449a-bf69-877d1a4d4091	PRINCIPAL	t
1863f51f-d7d8-442b-8883-22438c8a122f	4e334c59-79fe-43b9-9a89-208f37214917	393c9098-ed31-4989-b870-7b7a95d4f68f	PRINCIPAL	t
3cbf1bc9-26d2-4b98-89ef-fbdf925d885f	36995206-2d5d-4996-a258-c2e9b09a95b1	143e60e7-c2f2-488d-856e-aca349916c07	PRINCIPAL	t
a44cff37-1ccb-4401-a417-af31eed4fbe9	1c2af045-dc69-4fff-ae75-dacffa92d26d	e0c63dad-5899-4aaf-9610-02f3dc0ed787	PRINCIPAL	t
75e629a5-cd8f-490d-bba0-c76a88c490e7	93e1a386-ac97-44a6-a1f5-c322e10a8b9d	0652f854-58ce-451f-9fe0-72c2ef8937ac	PRINCIPAL	t
d77beebb-40a8-459c-8e38-de657e50e9a5	5ab1f544-d14b-47dd-b217-092767e27b9c	0addb3b9-d4f5-49c7-8719-71b118124e4e	PRINCIPAL	t
d625a7cb-fbaa-4cd7-8235-220bf5c55e2c	3fb55533-eb10-4935-9e84-6d4510127fa7	00235e22-7a6a-4fc3-8312-9824b6bd9b1c	PRINCIPAL	t
2fb79b80-a5c7-4776-aed2-d3f1d43c8f19	79837eed-fad9-4943-a04d-c0724f8ec7bf	6e82a5b4-f118-400d-b68c-f2d0eed01a58	PRINCIPAL	t
b76d3fc9-ba66-499a-8adc-de7eacfe8994	0be439d7-20dc-4602-880a-680a96d5308b	2ee42832-ae90-451a-ae1d-fdc01bdd8ef9	PRINCIPAL	t
1b45ad25-84f8-4faf-ab69-3b58a1e23277	f54d653d-3c5b-4a5b-a974-8f68de179540	3cbc14f6-0180-4fcc-8f04-e21dd972623e	PRINCIPAL	t
2b832a1d-39e4-4ce2-a959-9b125b1cbaac	7279c48e-408b-425f-8b93-02494fc6764d	2bb2a2a1-5a0a-4295-930c-04492e2d0934	PRINCIPAL	t
6f5f18c6-456f-4613-afa0-d0b96dcded3f	c1d3bb16-5bcc-4adc-a1c7-afbf85e1954e	4a0b6270-5d0a-434c-b433-574029a2849a	PRINCIPAL	t
bb2bea32-af52-4120-ba47-8ba6b91e3361	f6a63a7a-5cb1-4d17-9a52-d53fcdbda842	4a0b6270-5d0a-434c-b433-574029a2849a	PRINCIPAL	t
6e4bf804-7870-4d6a-954a-c90f32ee2f8b	53433369-07dc-46b5-81e6-eb4481b94d28	c44af00b-9c37-4656-a350-89ef47afcea1	PRINCIPAL	t
084bd665-1e2d-4b20-8abe-8def13a3b7c5	a27d555d-050d-4455-b73b-eeb441154e44	8915b3b3-fa15-4321-be4b-1ba07f8e8f38	PRINCIPAL	t
6810ac93-be00-486f-bc6b-961b2c37966f	5df29941-8863-4dd5-9728-a48020897b76	8915b3b3-fa15-4321-be4b-1ba07f8e8f38	PRINCIPAL	t
b335c538-c154-4c0c-96dd-b4b52ee73273	9e6c65cc-7ca3-4f15-9f66-277e4a03dde8	8915b3b3-fa15-4321-be4b-1ba07f8e8f38	PRINCIPAL	t
6886d997-f2c0-486b-9cdf-266ce4663940	c2696277-6b78-4125-a44a-c49e384f0829	8915b3b3-fa15-4321-be4b-1ba07f8e8f38	PRINCIPAL	t
e14e2b94-a367-4430-a0c0-fc7df642b015	aad344fb-8eed-4742-a7ed-0c918eaf3fe6	cf1a1fb4-3215-4a72-b355-854e6ddd3404	PRINCIPAL	t
d8c8664a-6a6d-4b52-a481-4d624a8b6e4a	c7ef8b08-626e-468d-ba57-9dd22e9db3c9	2e775ee6-e842-48c9-8a74-73172324071b	PRINCIPAL	t
6b7ceffa-1468-4638-9ad2-5cc1392d67f9	f495fcfb-b7af-4787-9923-87c78b8e848d	f606418d-2704-434d-ab29-89e900be6357	PRINCIPAL	t
ae27696a-b57d-4528-a07e-ae4782e514f9	2d4b4554-cc3a-4cc3-a810-535ae30b2901	711c10ff-6f1f-433f-89da-903b099f962a	PRINCIPAL	t
30186bcd-19c9-4584-9fbd-11b01e075b49	3f8fe789-859c-438b-a804-7079ea70d8d8	711c10ff-6f1f-433f-89da-903b099f962a	PRINCIPAL	t
045c7c08-cfb1-4df6-bcdf-7b5e989d2e15	b570072c-c0ab-43ac-a82a-cdaeeb0e2318	711c10ff-6f1f-433f-89da-903b099f962a	PRINCIPAL	t
629fc835-dc6f-4d2a-a616-4fdf0344cf4b	044f68de-6e72-416f-9d81-1373acc5a451	711c10ff-6f1f-433f-89da-903b099f962a	PRINCIPAL	t
b1301244-3b73-4436-9fe5-db93ffc3ff58	99fcc00b-9bbf-4a88-be31-edca502bed3f	711c10ff-6f1f-433f-89da-903b099f962a	PRINCIPAL	t
68082b4a-e9e4-4210-a173-78269620602b	d85b7e16-01d5-4240-816f-68117e8539ab	0428b122-a089-45a9-bbbe-968f45bdc1d8	PRINCIPAL	t
1f785404-2ab1-4ed2-bfbc-f724869dd861	77243f78-6ead-4dab-afba-8cf8ff4dbb97	0428b122-a089-45a9-bbbe-968f45bdc1d8	PRINCIPAL	t
c23f0ea5-082d-40b4-9411-dafcf6f82812	e2bd651a-609a-4d3c-803a-99a653a88d20	2d16fe4a-b2f1-4564-afe3-72f1c57b7862	PRINCIPAL	t
04a7dc5c-5a4b-454b-93bb-8f9ef936f78f	69bb9d43-1188-44ff-ac99-b93d00f369d0	ee36a2a7-39c9-445f-af0b-7b2b36f31f5b	PRINCIPAL	t
5b884fca-4638-41f2-ad83-85db6a4657a6	4519de9f-dc52-4cb5-bffe-0917e2bca45f	143e60e7-c2f2-488d-856e-aca349916c07	PRINCIPAL	t
67251d1e-ee7e-4b00-8d37-91114bfc0087	a4aea669-bb29-4c99-a239-a572c0aee00a	4a0b6270-5d0a-434c-b433-574029a2849a	PRINCIPAL	t
65bc40eb-28c2-4305-88e3-14a6fc5138a4	4c325457-9504-4ee4-ae8c-3409eb28b00b	731fd398-1652-42d0-9804-b77459f11206	PRINCIPAL	t
8365fc28-d49e-409b-9e63-b4b7b2f5c7a9	97f54622-a044-4adb-abad-2570f50e89f5	731fd398-1652-42d0-9804-b77459f11206	PRINCIPAL	t
e3e6485f-bad3-46a1-a06d-ffb7b816f382	851fb9cb-2673-4213-aef2-361836910499	e0c63dad-5899-4aaf-9610-02f3dc0ed787	PRINCIPAL	t
9b90264d-4f49-47f3-80ea-cee283dd2ab5	a2b28b05-775e-4c53-807c-5bfac5dcb05e	e0c63dad-5899-4aaf-9610-02f3dc0ed787	PRINCIPAL	t
daff25dd-64f4-4184-a5fa-1dac11328ae3	56d11d15-724c-45a1-8ccd-a79e5ec56b4b	e0c63dad-5899-4aaf-9610-02f3dc0ed787	PRINCIPAL	t
88642498-2c72-46ed-b385-8f456cb9218d	b3dda890-4157-47ea-b6fa-de2a9ed05621	e0c63dad-5899-4aaf-9610-02f3dc0ed787	PRINCIPAL	t
70bdbba6-781b-45e2-bd71-923822fd60d5	207bf7c8-7899-41a0-b8a1-09268c7c70b2	143e60e7-c2f2-488d-856e-aca349916c07	PRINCIPAL	t
ce97bc0d-ba98-4b8f-a16c-5862228e75d8	9fb72420-9120-432b-8cbd-577598520f62	ee36a2a7-39c9-445f-af0b-7b2b36f31f5b	PRINCIPAL	t
26a06eee-8889-471a-a0d3-d95c1200cf74	fff8cc61-e7f2-4901-a1d4-114982b4063e	ee36a2a7-39c9-445f-af0b-7b2b36f31f5b	PRINCIPAL	t
db4c12c2-94f5-421d-85bf-2de3a3e3133a	08247c72-b492-4f7a-bd19-10f528e32518	cf271634-bab5-4cdc-8f9d-10e6b1410777	PRINCIPAL	t
829d0735-6179-4f85-88be-4bdfd6a02820	864180fc-9b16-4133-add2-78a8907c9057	4b3eda38-f5c1-4793-87e9-b2fcf6dea236	PRINCIPAL	t
0af1ea01-be41-4319-aac7-ad81061f78b0	e89f5548-ba0b-4079-b283-8b25e9cf6ad5	4b3eda38-f5c1-4793-87e9-b2fcf6dea236	PRINCIPAL	t
2b99d6b8-0c5c-4f5b-bfd4-dfedbbe9d92e	778acffd-fa39-4eac-854a-f16886b1c0e4	4b3eda38-f5c1-4793-87e9-b2fcf6dea236	PRINCIPAL	t
d8763e35-6f2a-4bd6-af64-ef5421022543	fb98b635-2da8-459e-b3ed-b31ec6bb8c1f	e1a54806-ba2e-4829-9a29-1ff5421bf0bf	PRINCIPAL	t
e466b240-cf7e-48b5-bd9c-64bfd5f22c38	b0a7ff72-21e6-4453-bbcb-78093cd60ccb	2ee42832-ae90-451a-ae1d-fdc01bdd8ef9	PRINCIPAL	t
a030801c-72c1-40ef-ad9b-935997e6ff99	fd683d7c-ec89-40f9-9037-ddec9e28bc70	2d16fe4a-b2f1-4564-afe3-72f1c57b7862	PRINCIPAL	t
8a6ffc88-17f3-4121-b829-4add16aaf87e	dcc8710e-d12c-4213-89cd-a9acbdc33419	2232db8a-0cb1-4d57-88b8-fb063012d47e	PRINCIPAL	t
53b5e1df-e667-4b93-90df-b3499f413ed2	523c6d3d-0611-4a90-9f0d-45edb52e6c87	809add91-4b45-4802-8910-46ceb852a8ab	PRINCIPAL	t
8ec50e80-dfe1-4158-a609-959ee0c23bda	f871a053-7481-4af1-b07b-4f4fac41263b	40947cb3-4afb-49f8-8dd2-fe40d5a52553	PRINCIPAL	t
4fccc16d-f979-47e1-afb4-64c2b057c666	49de740b-c408-46de-9486-2f7fb875bff4	40947cb3-4afb-49f8-8dd2-fe40d5a52553	PRINCIPAL	t
34d4cc4d-545b-4357-ae18-801ca535f17b	24c6e7fe-eb40-4744-9dd1-5f4a9927db71	40947cb3-4afb-49f8-8dd2-fe40d5a52553	PRINCIPAL	t
67297b9b-23f2-494d-81e3-16bf279aee61	ce21016e-aa20-4a2b-9a80-1348f940b11d	40947cb3-4afb-49f8-8dd2-fe40d5a52553	PRINCIPAL	t
c7817634-bbe6-4b11-b04c-571a12bb657c	087c5c2d-13fd-4989-b1ca-64286be3a62c	3cbc14f6-0180-4fcc-8f04-e21dd972623e	PRINCIPAL	t
f7b4ad50-63fa-43f3-a7de-d3b6c77eea05	325b01c4-06f5-4bbe-b727-d530153a3941	cf1a1fb4-3215-4a72-b355-854e6ddd3404	PRINCIPAL	t
53609caf-4e3b-4eaa-aa7b-1e18a6d246e0	9b4f0fd0-4f1a-41ec-8843-88b2231175df	b158ed18-7849-4fbe-8438-f28936590335	PRINCIPAL	t
93dc92fe-4288-48d4-9a17-fa8d957a834c	6c0e86a6-8e57-4173-ad22-d4621e7b26ae	cf271634-bab5-4cdc-8f9d-10e6b1410777	PRINCIPAL	t
1b625bd8-705a-429e-b854-a5bc2286d93f	e1cec1bc-aeb7-4943-815c-1ca73b40a9cf	aed52619-5540-4220-bf13-189dbd2a4f39	PRINCIPAL	t
c568b0a9-32b5-486c-a3f7-272d9934b494	71e52164-cc90-40a6-9538-1910022c569d	2e775ee6-e842-48c9-8a74-73172324071b	PRINCIPAL	t
1989788e-a172-4a30-83f8-5bd5870d0c7a	253650e0-a625-428b-bf0a-73b6b83da388	f9b3caae-043b-4e88-8cca-b613dae4e560	PRINCIPAL	t
dda2e0a0-3b22-40a7-b8c4-0fca1189b5dc	896a27a7-5b11-4543-8563-7845a421c1eb	cbd9458a-5f5a-471c-94d1-ae071fcce490	PRINCIPAL	t
96a1853f-17b2-4200-9806-0b92b5ebd2ae	5db87c94-2cbc-4800-80e6-d2fe9e26ab0d	cbd9458a-5f5a-471c-94d1-ae071fcce490	PRINCIPAL	t
f4b6003d-d55f-4642-8ec4-5c6de39464f0	88f3d08e-8e06-4414-bfad-eaebbbb7135c	cbd9458a-5f5a-471c-94d1-ae071fcce490	PRINCIPAL	t
4d0ffe21-f698-4291-8981-765183ddecd7	01bd2a2d-ad41-444f-8ce0-e9c06261fe8f	b31fe5f0-fffb-4083-b95a-c8800910b922	PRINCIPAL	t
1e53be67-2cfa-470f-a506-7a10117421be	d40b2750-f6b0-424b-953b-8a869d51192f	731fd398-1652-42d0-9804-b77459f11206	PRINCIPAL	t
90ca9d23-0c7b-4852-800d-676c499cbbc6	dbb9738c-e4c6-4b24-ad67-157a849fe814	f606418d-2704-434d-ab29-89e900be6357	PRINCIPAL	t
482b0e63-d670-4094-84fa-af88b494d8d7	312a36a2-c573-4d36-8ede-fab6d9150626	f606418d-2704-434d-ab29-89e900be6357	PRINCIPAL	t
708b4303-7bde-4859-8dbd-389cfac5d0b0	5f1ca2be-33e3-4e21-a443-3cde01ecbaa8	711c10ff-6f1f-433f-89da-903b099f962a	PRINCIPAL	t
e54b7a7a-7940-42ad-9cc1-fb8eb435237b	2334ef04-bd77-47a1-8e60-e4d8ba688cd5	143e60e7-c2f2-488d-856e-aca349916c07	PRINCIPAL	t
71de87e1-59eb-4b74-9158-809d17860a8b	2fbed45d-3926-4521-bc45-b4f0defbdfdf	4a0b6270-5d0a-434c-b433-574029a2849a	PRINCIPAL	t
760db856-ccbe-4a13-a9e4-b87ec3f72d30	191406f6-2a26-416e-9e91-97d4a61773f1	d15b3fed-415d-42ff-a463-99004a462acb	PRINCIPAL	t
462c0f8f-852a-4ff3-8610-141c09fd2e5f	4f9c47bf-71e5-49b5-85ec-ffff975b837a	d15b3fed-415d-42ff-a463-99004a462acb	PRINCIPAL	t
9694bdf0-7824-423f-9984-b78d9592f4db	14ecfaca-7633-4729-b673-194b617e6a3b	d15b3fed-415d-42ff-a463-99004a462acb	PRINCIPAL	t
5293a622-0798-4be8-921e-a2664581999d	4df3e3f7-d872-4e60-a59f-9203ee3d9533	d15b3fed-415d-42ff-a463-99004a462acb	PRINCIPAL	t
67af35ec-87ec-412a-8b13-c9386e803e50	70f8de27-ab1a-40f5-a104-9a50adfec359	731fd398-1652-42d0-9804-b77459f11206	PRINCIPAL	t
5a52d75a-194d-47c5-b649-6d67d7c79563	63ce92b4-ea23-482c-8d66-78cb995b4c81	c253759a-a3d6-49a8-a726-e1493e2f1931	PRINCIPAL	t
5c0525c9-c9de-4bdb-960f-719f04caba07	b9440a0d-b7af-4576-9f6c-c9c3d8f77be6	64095940-467c-449a-bf69-877d1a4d4091	PRINCIPAL	t
fa819207-7ee5-4ef7-bd2b-f52c70f03ea1	198bdcd3-0860-4225-a273-1237ec8835f8	64095940-467c-449a-bf69-877d1a4d4091	PRINCIPAL	t
4d8cea7e-488b-4f41-abdb-0dadadc2178b	80de3ac6-1c23-4473-9e50-8c26c248c643	64095940-467c-449a-bf69-877d1a4d4091	PRINCIPAL	t
93746b90-cf3a-4366-8c84-53f92d8bb95b	493564fa-aa48-44c8-9d7e-42d2022c9c99	64095940-467c-449a-bf69-877d1a4d4091	PRINCIPAL	t
a06ead23-8bf3-477f-9c36-7f1c619a3bab	28ce6dbf-eb4b-4029-ac4c-16c9c28fb820	8915b3b3-fa15-4321-be4b-1ba07f8e8f38	PRINCIPAL	t
47c647e9-ef15-4fd6-8133-c6e3a8d6ad1c	84f6901b-9af1-4772-86d4-e2b20830a6bb	8915b3b3-fa15-4321-be4b-1ba07f8e8f38	PRINCIPAL	t
8d18c5c7-f9c7-42b8-bfd6-c5b4923e10d5	f3394952-a88f-4875-969b-557066e77511	8915b3b3-fa15-4321-be4b-1ba07f8e8f38	PRINCIPAL	t
caa60206-4884-452c-9138-f737828a2935	8a8061eb-af9a-4662-b47d-662c1f052bf8	166f92e6-0063-4ab7-aadf-e65aa3421943	PRINCIPAL	t
3c0e889b-ca4f-4fe8-8731-d3ac8340dee0	01755c81-36e3-4386-b574-6ff2be916a62	0428b122-a089-45a9-bbbe-968f45bdc1d8	PRINCIPAL	t
abe2c2fc-d5d8-4c6b-b12b-13517c347527	6d55cd26-237b-42a1-b4f8-b40810080ee3	e392011c-4a48-45a1-9b22-411aec8ba356	PRINCIPAL	t
31f7796b-8d62-41c7-a963-e2fe0a0476da	742f2e94-c43c-4de7-84ce-68578cb50d22	2d16fe4a-b2f1-4564-afe3-72f1c57b7862	PRINCIPAL	t
621a754b-db3e-4b05-a992-67e9b45994f6	db94d9b8-a243-47b8-9489-214b12218f1c	4a0b6270-5d0a-434c-b433-574029a2849a	PRINCIPAL	t
055ad276-4430-4b5d-b523-dcd62f8a4b3e	d530d490-3cb4-49df-abbc-7e5b4f17b9ac	0652f854-58ce-451f-9fe0-72c2ef8937ac	PRINCIPAL	t
a2b77759-672c-4509-b0f2-f29227ad694b	eea4d7be-22b5-4e97-a81b-958c5c68eb18	b158ed18-7849-4fbe-8438-f28936590335	PRINCIPAL	t
502ac6f9-8719-461f-b977-5bc9e1602150	72245c63-c450-4b14-b888-2d7a35f105f7	2bb2a2a1-5a0a-4295-930c-04492e2d0934	PRINCIPAL	t
028e9fd2-12b4-410a-9d4b-a33da88bbaab	26d27467-c410-4a38-847d-f36141095fd2	0c84d2dd-6fcc-4590-be39-8de9980af870	PRINCIPAL	t
3bc887eb-e601-4df4-aad5-7c0c25ab6aec	636a35c3-93d4-439b-8c47-b98bc6b3fceb	cf1a1fb4-3215-4a72-b355-854e6ddd3404	PRINCIPAL	t
3d5e3fcc-57eb-4fad-8b08-34789fba0756	867c8ab8-f955-4b11-bab9-858bcf83de54	4b3eda38-f5c1-4793-87e9-b2fcf6dea236	PRINCIPAL	t
15fd8231-74d3-4a8f-abc3-410ea5177587	67112e2d-6c6a-4b64-91e6-4fc19dfefffa	e7f78d95-1d7c-4e4f-906d-241d9df67db4	PRINCIPAL	t
56050e45-a025-44a8-8bc7-83883149d309	c62773ec-1ceb-46bb-a0eb-039bcd0955f1	cbd9458a-5f5a-471c-94d1-ae071fcce490	PRINCIPAL	t
df844342-1e8e-4da6-8eb1-1864e082ba53	9a80bb43-4b49-4180-9316-ff53a01a5677	e0c63dad-5899-4aaf-9610-02f3dc0ed787	PRINCIPAL	t
030761b3-d324-40d8-93bb-461614a27ad6	eea41fd8-10ba-4b11-9a67-afd3fcbb02f9	6e82a5b4-f118-400d-b68c-f2d0eed01a58	PRINCIPAL	t
46172b26-a374-488c-a079-8adea488e9c7	8e22b83b-d97a-49e2-912d-bf327a63efe4	40947cb3-4afb-49f8-8dd2-fe40d5a52553	PRINCIPAL	t
f1ccd5ff-6d9f-4378-9c12-c16dffeb9ddb	39af0cde-0dea-4a77-aadb-483b2474e213	e392011c-4a48-45a1-9b22-411aec8ba356	PRINCIPAL	t
10fabfcd-4946-4709-ba33-a65fd96192b7	949be273-0b45-404b-b822-a2cb9dba18f3	7c2ba7c9-de56-440f-81cc-f92352a6f2db	PRINCIPAL	t
6769e8c2-bd1f-4ae7-a893-011172b9c3f0	3b413234-54d0-4ee2-87b7-90334c9bc0e1	f606418d-2704-434d-ab29-89e900be6357	PRINCIPAL	t
31461d05-a640-46b3-9f5b-1aa4fca03a04	f4db384e-889a-46c7-a5e1-448d8c54f310	8915b3b3-fa15-4321-be4b-1ba07f8e8f38	PRINCIPAL	t
86e9cece-8b6b-42f6-a5b6-5fd6518b2bf1	4057570f-3d9f-4310-aaeb-b37dc2f3f0a5	8915b3b3-fa15-4321-be4b-1ba07f8e8f38	PRINCIPAL	t
e3578b47-df4b-4a23-98c5-b59659f63f33	d1eb4ead-24be-4ca3-8d17-80e9939e4d5f	8915b3b3-fa15-4321-be4b-1ba07f8e8f38	PRINCIPAL	t
7b5d20c6-6c30-48b7-bfab-13b08f7040b5	f91fccf8-92ce-4a8c-a890-b598fe7c5640	8915b3b3-fa15-4321-be4b-1ba07f8e8f38	PRINCIPAL	t
f738125b-5543-4331-a550-5a98ec14b345	6dc2b385-6e98-4a81-ba2e-b9e2bd823cf3	8915b3b3-fa15-4321-be4b-1ba07f8e8f38	PRINCIPAL	t
1a39c88c-3014-44eb-bf51-c5f9b7cf7672	a6bc235e-ffd8-4ae9-8b25-2fa9cf8e3872	8915b3b3-fa15-4321-be4b-1ba07f8e8f38	PRINCIPAL	t
a8f92f79-e0e5-4ba2-808a-78502245182a	0c608120-623f-4812-800b-da5f5b5d7ccd	731fd398-1652-42d0-9804-b77459f11206	PRINCIPAL	t
657b5860-0b58-45a7-9d48-a25087e569a3	85649b12-65fd-4a5b-a069-bb44837dbef4	809add91-4b45-4802-8910-46ceb852a8ab	PRINCIPAL	t
d3f4b9e5-c936-4c46-b036-c18d14239d84	da530b09-95cc-4f8a-8cda-944db0cc209e	c253759a-a3d6-49a8-a726-e1493e2f1931	PRINCIPAL	t
7b2e5a9d-8409-4e6f-b9b4-f7f7e0fab28f	0b4d3b2a-884b-424b-8911-d323ade4881e	c253759a-a3d6-49a8-a726-e1493e2f1931	PRINCIPAL	t
ecffa26c-0ab6-4872-ab4d-2423f90baea0	290543b2-b884-4c76-995a-9341954d844b	c253759a-a3d6-49a8-a726-e1493e2f1931	PRINCIPAL	t
7b267a64-735e-4ebf-af95-3712e4cc233e	ef599730-b341-49ff-b94b-5de523f88b1b	b31fe5f0-fffb-4083-b95a-c8800910b922	PRINCIPAL	t
307620fc-961a-45fa-a5ee-43ae8c4fc28f	bbfa24cf-8099-4d21-b5e0-b83a8cda7eeb	0c84d2dd-6fcc-4590-be39-8de9980af870	PRINCIPAL	t
a8d6cb5d-db23-4809-bd72-96145b41fbad	1fe861fc-68a8-445b-ad4d-840b56a4c438	f38f0451-192f-4ccc-af81-2b1056ff0060	PRINCIPAL	t
c2078df3-bf12-4b03-af64-24e7c54d0922	d6183d00-34ff-4948-8be7-c4d93b518187	166f92e6-0063-4ab7-aadf-e65aa3421943	PRINCIPAL	t
5ecee5b2-925c-4477-9902-bd87e2414c42	fc9405b9-e66d-4a42-8395-1486e59b5741	e3f7879d-410e-46d4-96b3-9d219be9e4d2	PRINCIPAL	t
031ebc6f-6299-415d-b401-77bceb072dd7	f3d57969-4a36-42df-a241-ce96464bff4d	e3f7879d-410e-46d4-96b3-9d219be9e4d2	PRINCIPAL	t
ed78f3de-95a4-4a13-b7bd-0daa05257431	b118fbb7-60cd-4ce6-97ea-0064e99d291c	e3f7879d-410e-46d4-96b3-9d219be9e4d2	PRINCIPAL	t
abe6f04f-ca4c-485b-a942-d73de9e2557f	6b947e39-9d04-4bd2-ba63-e79584cb9f31	e3f7879d-410e-46d4-96b3-9d219be9e4d2	PRINCIPAL	t
b369d681-0bec-45fc-b37d-faea187334ae	2c2b1e8a-7dd6-4970-9664-159763900e79	e5360c26-72c6-415c-8e57-1d7221482151	PRINCIPAL	t
0b7ad3be-ddb7-441e-849c-a4c7aee1e12c	2e84d27b-7aac-4695-9035-61616b7b893e	b158ed18-7849-4fbe-8438-f28936590335	PRINCIPAL	t
5facffad-fde1-45ea-933f-65dffde436bd	ad55a408-3286-44f2-81ab-85ccd8d9754f	b158ed18-7849-4fbe-8438-f28936590335	PRINCIPAL	t
43348476-e851-4d78-a013-670ab62f2e61	1c06cf75-3f20-4388-81b9-f50fd23b0636	b158ed18-7849-4fbe-8438-f28936590335	PRINCIPAL	t
38aa078a-256d-4fc0-be14-e38af1c98c30	c42ff990-d46e-4308-b120-7c349747821d	b158ed18-7849-4fbe-8438-f28936590335	PRINCIPAL	t
fa806061-8122-4aaf-9217-a43b8388dfbd	99f68d2d-6d22-4b2a-86ce-bdb074691a20	f9b3caae-043b-4e88-8cca-b613dae4e560	PRINCIPAL	t
824960c1-3105-4098-b5c4-e0223c7ff495	865e1723-1618-4091-8536-c40e40663d66	f9b3caae-043b-4e88-8cca-b613dae4e560	PRINCIPAL	t
3162cafb-e0e8-4705-b855-019f46e4bb99	1575bb42-f6b2-4eb5-88f5-185478dd2b97	711c10ff-6f1f-433f-89da-903b099f962a	PRINCIPAL	t
4d822c58-7cbf-4e90-9f6c-1eecb9025a0b	f88dee7d-ca89-4d3f-b3ca-7004577e338c	2d16fe4a-b2f1-4564-afe3-72f1c57b7862	PRINCIPAL	t
d78886cd-77dd-43d4-aea6-428129f239cb	a32d1c3b-e71a-4c00-a1fa-8ae53f3e3ad2	e392011c-4a48-45a1-9b22-411aec8ba356	PRINCIPAL	t
3ba136ea-72b6-435c-8c9b-fda6eb07b0cd	890b77d3-d984-4b98-8346-baa6a3ca8150	711c10ff-6f1f-433f-89da-903b099f962a	PRINCIPAL	t
c5c06ed1-8c88-4475-b4e3-5f950333510a	2906c541-985f-418e-b6d2-ae59c5809ec3	0652f854-58ce-451f-9fe0-72c2ef8937ac	PRINCIPAL	t
574946be-4a1a-4c9c-9aa4-6b18cb9cadb9	889c7532-e341-4636-94ca-381f516f4ec1	aed52619-5540-4220-bf13-189dbd2a4f39	PRINCIPAL	t
e70083d7-e53d-4cae-ad47-8f67ebf4868b	c86d94a9-3343-428f-b34a-0cc8007b66b0	69a1531e-b147-4e07-af7e-6f9b7a67e66b	PRINCIPAL	t
d39e549e-fcc7-4df1-ac6b-5e88b54c169a	dcb7bb42-73e1-49ea-ab2b-66d2c178080a	b31fe5f0-fffb-4083-b95a-c8800910b922	PRINCIPAL	t
467db683-f600-4efb-9348-46cda554f404	65359d3a-c59e-471a-9996-0727eebd6ec6	d15b3fed-415d-42ff-a463-99004a462acb	PRINCIPAL	t
25bcf02b-6cdf-47f9-9fc1-8d0b575b8d61	7e1ef5b5-7a83-4be6-b421-bd83bf01b33d	cf1a1fb4-3215-4a72-b355-854e6ddd3404	PRINCIPAL	t
0cf46e35-24a3-484b-85b1-0931d3f7f11d	07de40c1-d9c2-49dc-8bca-6b7907f62354	aaefa0e6-697e-423b-afb2-6e098492efe0	PRINCIPAL	t
2313aad2-ac8c-40a4-802e-e2a5ed27c254	0b518ebb-9d7c-4582-a7cd-579fa234d566	64095940-467c-449a-bf69-877d1a4d4091	PRINCIPAL	t
93faed66-cdee-4764-bc05-3b7f50779e4b	796eca0f-1544-470c-b73f-48e9c62bb010	73c6e6e5-844d-4cc1-9172-c3c4d8aff8fa	PRINCIPAL	t
0a2188c6-47be-4a80-85a5-d36c82b4416e	660fde9a-5aef-4808-9c8c-3f398b4267d9	4b3eda38-f5c1-4793-87e9-b2fcf6dea236	PRINCIPAL	t
d9128fff-162b-4aae-916c-cddb229fb656	0587cad3-9f4b-4f7e-b8b5-e29ded8b139e	71177543-d409-4705-8f8c-6c2bd628f83e	PRINCIPAL	t
a0aa6d35-a286-4647-96a1-b794cc273ace	c3f4bc46-d43e-473e-9814-395ead701e50	6ba9bc2b-8d23-48f3-b0f5-2e4e673be4b9	PRINCIPAL	t
117093f2-17d4-440d-9fb2-bacc3704b8dd	21795f64-4594-4faf-ba1e-620eef6790f1	ec08051c-dddd-4b13-98ae-ed2bfda0f470	PRINCIPAL	t
bdec96f5-337d-4173-8c6d-b737ba2431e5	c2dd433b-b69d-4e2c-b91c-1ac4b89bbdd1	2b09cd5a-9603-4054-9f74-e2f191cb113e	PRINCIPAL	t
0e281db8-5a5e-4148-b104-c5c6e2e1cba9	ec3c8953-56c0-4eb8-9e09-8aa15935ef82	40947cb3-4afb-49f8-8dd2-fe40d5a52553	PRINCIPAL	t
a2236466-a123-45ad-989d-54309778de13	a7ce5d32-766b-44aa-9f88-364b02e4a0ea	69a1531e-b147-4e07-af7e-6f9b7a67e66b	PRINCIPAL	t
5169c8ff-78f8-4714-94f0-c3ded7de58e0	6db63f26-f23c-4a54-9892-389a9a02c6d2	2bb2a2a1-5a0a-4295-930c-04492e2d0934	PRINCIPAL	t
f27c6f91-260a-468a-a291-aeae31a051ca	975b47d2-2c2b-4c91-9c9f-5a6438b60b83	487a251c-e868-42da-8eb2-3a825a0501fe	PRINCIPAL	t
6f981c05-dc7b-4a93-a90e-43cce87c9a95	d8c6f631-82bf-4c69-88fc-ac3e2a2af78b	2e396807-d844-4e60-87f1-5f6015836600	PRINCIPAL	t
\.


--
-- Data for Name: mareas_movimientos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mareas_movimientos (id, id_marea, fecha_hora, id_usuario, tipo_evento, id_estado_desde, id_estado_hasta, cantidad_muestras_otolitos, detalle) FROM stdin;
6b222b3c-f595-4513-bd23-b97c04afcad3	f4d5d6dd-c1a9-4531-9d6b-a85191dd2f99	2026-01-05 03:01:39.945+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
55602335-f612-4577-a16c-0a994e8b87e1	c53a7382-c285-4dfb-a2b6-7508c18f0095	2026-01-05 03:01:39.965+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
9b8ef0f9-170c-4115-9ebe-ab8e44d8d3f9	0c2d4e6d-edf5-437e-afcb-0e77acc2d462	2026-01-05 03:01:39.975+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
bab56840-3788-4dda-848a-6f29edf2c55b	9ec74ea6-8e30-42ab-878b-8d7656d2d7eb	2026-01-05 03:01:39.986+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
4c2a3861-ed4f-4144-a779-5a34ea5ef5a8	463aafe4-c835-4b72-b746-1fcbc8942bf7	2026-01-05 03:01:39.995+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
6e4bbdd1-db0d-45db-8ddd-b6a98a023ce6	cbda1076-4e30-4256-b12f-f21ecf1c6bc6	2026-01-05 03:01:40.003+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
3cf4a2a7-abb1-497d-8d47-882b1bc30378	d893ae69-0bf1-455c-a872-f68a70b358e6	2026-01-05 03:01:40.011+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
e8177f6c-51f0-46c4-8984-b4c8ee380d9a	a5d404c9-624e-4c51-820e-91dee3259135	2026-01-05 03:01:40.019+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
1e408246-2bfb-4ca5-9b15-2d41a0fd02fe	ad5c98a1-0ba5-410a-8389-5490ed45c580	2026-01-05 03:01:40.031+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
337d2f09-bb8e-433c-851a-4a7a3ecdd0a9	d548b4fa-ec8f-4e10-bac4-91c223a9cd04	2026-01-05 03:01:40.04+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
3c028346-9d03-4c66-bc2f-d3e085350ce5	b1e68fd3-848a-4ed1-b1c8-1875d0e2837a	2026-01-05 03:01:40.048+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
23db8b59-95b2-429a-a734-8f1b45a70ba5	ecae7b37-a7a2-4b80-a7d7-068fc2398713	2026-01-05 03:01:40.055+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
68019fdf-f601-4ad6-98a9-c032bf9688a1	b2c95fb4-a60b-4a5a-b7ae-3baf33a18767	2026-01-05 03:01:40.063+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
5e05ffc7-f0b7-4ad4-a574-153eb061ff06	e68165c2-46ca-4008-b4e7-ef8b75d157f2	2026-01-05 03:01:40.07+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
0c1fd7e3-e783-45fd-bf3b-b12dc3dc069b	7b6b4568-dbc3-48fd-8fb4-2f0aa88cc3bc	2026-01-05 03:01:40.076+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
19d61c7c-4548-4bf1-a1ca-8ecf4559bdf3	325b4e0f-b997-4e21-8b27-4d1f1ff7ca87	2026-01-05 03:01:40.089+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
a67f908c-bf13-4821-97ca-49c19623409b	b89f238c-836c-444f-9c0b-790457faddb3	2026-01-05 03:01:40.096+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
5b9a0398-673b-41ac-b280-f97d3d355511	39b6414c-3bb0-4650-bee2-a81857c56d3f	2026-01-05 03:01:40.103+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
7c399e68-989c-4b5c-8435-4d7e61f3866f	5e199f6e-8528-4ca4-b5ac-265352ec2a2e	2026-01-05 03:01:40.11+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
669fe9f9-f31b-4bcf-ae36-509a85b18d2d	89772426-f84f-4ada-8b95-8d6aa7cfa20c	2026-01-05 03:01:40.117+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
99d52702-47ca-414e-93e7-c5cd38794859	6f309090-03de-434d-9131-af389005591e	2026-01-05 03:01:40.125+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
80640573-3d82-457d-b10a-0f14439cfce7	58b2cc59-4ce6-4c3c-9506-efd04f5f9fe6	2026-01-05 03:01:40.132+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
7466da05-df80-46ff-aa60-b6b8cda711c7	a98df442-7c41-45ea-9930-24f476d56edb	2026-01-05 03:01:40.139+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
0d448626-9bb2-4029-8411-0bd568764c29	72a503ff-be44-4903-8ace-f5b85133c725	2026-01-05 03:01:40.149+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
c13311be-4d00-43cb-89ef-07ebed766e81	8a4355c0-e5d2-4435-a639-941e1dc3aa61	2026-01-05 03:01:40.156+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
4c9f3d15-e456-4d3d-88d6-0f3ff9ee2bf7	dd74d6ee-dd23-4c5d-ba00-525c4f9f8fd9	2026-01-05 03:01:40.163+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
8f30029c-a10c-4c30-9361-0fb22b602aba	9265e7ad-9de9-442b-aefc-150d54383eff	2026-01-05 03:01:40.171+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
f46297a6-dea9-4f2a-877d-07a8eb21b558	29f27275-d380-447a-b747-c02ae504eb21	2026-01-05 03:01:40.18+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
8858ec0f-baa0-441b-88e4-c27e035082ca	69e3d2f2-a9ef-4835-b552-39aad08db439	2026-01-05 03:01:40.187+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
94d18450-36f8-4615-9934-ef5d567663df	722d324c-0857-4d81-8060-635b4ab9aab4	2026-01-05 03:01:40.194+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
faa2e47e-0153-46cc-93b0-3a411f266128	47511b2d-107a-4f1b-bf6f-8e1f38966664	2026-01-05 03:01:40.201+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
5489ccd4-eb34-4190-8f42-918579b22b35	0e1565c4-461d-4a6f-870c-4bac59f82d9e	2026-01-05 03:01:40.207+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
716a7d2b-810a-471b-b679-db35d03d62a3	61538cfa-6bd1-4fc7-827f-f99cb7fc1788	2026-01-05 03:01:40.213+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
5bce2bc0-8c0d-4947-a76f-ab1f81d0abbf	6ccdc741-2631-43c6-88cd-0573ffbc1306	2026-01-05 03:01:40.221+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
e98581a3-a672-4dbb-8a60-4baeddba3f2c	3cbbcca9-eb17-4f36-be5e-3a768e4183df	2026-01-05 03:01:40.23+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
c4b1ff64-b346-472f-a1ce-c8e568432faf	6bd94f84-48de-4f14-80c8-4335a20cbe35	2026-01-05 03:01:40.239+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
7539ea37-d16a-4da6-83a1-cca2b6ec3c18	5f071d47-ba33-4ec4-a5f4-57f045f08bec	2026-01-05 03:01:40.247+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
84021091-d93c-4f18-bfad-bc975e06b2fb	76275716-c459-4453-ac02-198adf1b3be4	2026-01-05 03:01:40.255+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
a9bca76e-1192-4b8e-8b47-8354972e16cb	cad8958f-53f0-4ae6-89b1-ee0b8fdfc076	2026-01-05 03:01:40.263+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	6d165fcf-b452-43c9-9ca9-8d7d0ce9cfad	\N	Marea importada de seguimiento 2025 (JSONL)
e874bcdf-6122-4411-9a44-be0a85c42a80	ab19ecb3-e73d-4fa1-9d62-e105c7a1ea92	2026-01-05 03:01:40.269+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
1cf51abf-5495-4c51-ad2d-53f3299e0b7d	3b297da9-528f-46ab-b118-79aae24c63f6	2026-01-05 03:01:40.277+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
0631f8f1-df9b-4f07-906b-c539cfdc49a5	fe7bb24a-e5be-46e8-8498-3080ccb883a1	2026-01-05 03:01:40.285+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
929b5386-8aef-4992-b13f-2fcef0f92a69	815a4e3f-3ed7-411d-9c25-22093e4dcc17	2026-01-05 03:01:40.296+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
79c50ada-765f-49bf-b948-1d20a0e9d643	85524d4b-ba88-4576-89bb-d7d01e6285cb	2026-01-05 03:01:40.306+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
9ff9f431-25c2-4653-8171-657cf0825af2	e44e4eea-2153-4fc0-be3d-b85bf1cd7703	2026-01-05 03:01:40.315+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
02cfee11-cd1e-4095-b1d4-83e909b8f859	2eccb65c-7ba1-445b-ae33-b4f2edda0a1f	2026-01-05 03:01:40.324+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
5d071050-aee5-4d81-a2db-3873c13b5c6f	63b4e615-64a1-4e39-b31c-998b167d1d9d	2026-01-05 03:01:40.332+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
c41ed1fa-eba3-4184-a4ae-ce27b9338194	0c6606f5-9faf-4625-bb98-dd50a576f56a	2026-01-05 03:01:40.339+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
335a65fb-90a0-4e59-82d4-71ac301dbe30	c81bf48b-2bc8-4559-abab-ed13dc491b26	2026-01-05 03:01:40.346+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
b9232d6b-c561-4f0c-94c4-23cc6ac6ed70	e065843b-d7f0-44b1-9ea4-db81b310857a	2026-01-05 03:01:40.353+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
5fbffd0b-ecd2-4612-abac-1060074997ad	aa8cde01-3ee1-41f8-bf1d-85d023d4cd9b	2026-01-05 03:01:40.36+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
41aab003-b764-433a-9998-0adc49e387d1	dac627e7-31b8-4253-be67-cdc80afc4e5d	2026-01-05 03:01:40.366+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
48594f79-b2ab-4241-990b-d5b9b7f33762	7dc6a248-1a3d-4550-b89a-a2cb6d6c668e	2026-01-05 03:01:40.372+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
451e0bdf-ac39-46cc-bcac-13fcf63cd7c5	c451f829-9418-46b9-b588-b75e7a8b7f09	2026-01-05 03:01:40.38+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
11baa569-e323-4635-a420-c4fa91d847cd	b495ea11-47f7-43c5-90f4-323acb2faf27	2026-01-05 03:01:40.387+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
779c8001-128a-4803-89d7-eb882e691590	eb672390-8555-4690-a534-dca0d189a8d6	2026-01-05 03:01:40.393+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
f856a9a3-0894-436b-8d0e-b939c97b83bb	9bd5e91b-9157-42ab-9593-f15cc284c35a	2026-01-05 03:01:40.4+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
7ba16e17-9d7e-4e81-858d-0ec57576007e	be4d0d19-dbe4-4272-aee9-0a67719c2ab6	2026-01-05 03:01:40.408+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
61c86f0b-0592-4e07-b7e8-a39ca7d6f38f	9df86d22-596b-42af-9ba9-ff59a635af53	2026-01-05 03:01:40.416+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
2af5d845-816a-4101-a46a-77d9aa052735	8db2e4dd-fd8c-4319-88ce-a7a82303f7a2	2026-01-05 03:01:40.423+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
66396116-fe95-4f46-a08b-ba0faaf309a6	db42b137-ba3f-4ffb-9254-cbcb2ea2f27e	2026-01-05 03:01:40.429+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
39669473-767c-4825-87e2-6ad431f2d69e	6831ad38-08e6-4501-bd81-15169a9ac02e	2026-01-05 03:01:40.438+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
4ad6ae56-2e59-4d1e-919b-58b10d118c34	6be38161-1215-421d-a805-8626e66fa481	2026-01-05 03:01:40.445+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
d5cee04f-a8ff-4203-ada6-aa773d11dddd	82583380-f465-4e87-a996-745c82d08679	2026-01-05 03:01:40.457+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
c5968fe4-0064-40bb-85cf-3d8e7918833f	d8dfb3a7-6584-49fd-b971-7cf781471f80	2026-01-05 03:01:40.471+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
dcef3519-a15f-4922-a2cf-7393cc96ec88	4711834a-ece0-4559-9153-caf7ed073090	2026-01-05 03:01:40.484+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
f20f456c-b288-4157-b9fc-03568e44c9c2	9faddd71-cea4-4ad1-845e-3cff92261ec0	2026-01-05 03:01:40.494+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
a3fedb8d-4a2a-48f3-8e04-c84b58e3b12d	2a5a7a70-6c10-4d54-9308-324c2d652400	2026-01-05 03:01:40.5+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
baaac779-952d-405f-80fc-c493a2ef4d44	822da010-04f1-4ec8-a940-099f898834d0	2026-01-05 03:01:40.513+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
0ef2a1c6-bdbe-4c85-a0b1-bfc7cd9f852f	802b7c64-46ba-4868-a819-490b842338d5	2026-01-05 03:01:40.52+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
84ac5a37-9e57-47cc-9a5d-327c422b4e86	6c8fcf21-dcff-4139-9f0e-135cc6d208c6	2026-01-05 03:01:40.529+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
1669a39e-45d5-4f76-b557-067e76aaabdd	ec01d89c-d0f0-45d4-8579-bdd5fb0e38d8	2026-01-05 03:01:40.537+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
31e4de71-0fe7-44f8-94b7-2c843771a93a	816c5edd-457a-4c93-a659-17168077a513	2026-01-05 03:01:40.543+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
a87ef671-5ba9-4252-9780-ea74a4009d53	669baadc-57e0-44f7-8cc0-f517f6a8336f	2026-01-05 03:01:40.555+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
0f505931-11cf-457d-8c18-838c38dc97ba	8dd829f7-8da0-427e-9c83-4d55ad83657c	2026-01-05 03:01:40.562+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
e3033f5d-b09f-4f49-b10c-d38c6dc4da98	aa09f3a7-455a-4049-8485-805b533ce378	2026-01-05 03:01:40.568+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
d3ad1315-9106-4915-ae44-0055f2ca3892	58940af6-143f-47ab-9d27-1fe6b8775fff	2026-01-05 03:01:40.575+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
0b5eb752-0dcb-40e3-895a-9a0cc760f49e	a4abdee9-4460-41c7-978b-c0456ca12255	2026-01-05 03:01:40.582+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
47bc1614-6fdf-40c5-96df-e8cd594d3dd0	e663b06f-1766-4d56-933f-11f3cce93a6c	2026-01-05 03:01:40.589+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
aaed0f5d-7091-48dc-a6bc-72a6f10a93a9	c8a60b46-61ec-4a5b-a60b-73f59b7deba6	2026-01-05 03:01:40.596+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
b02a4091-9a93-4dcb-9720-570239507cd6	c20db1f6-5e12-48dc-b54c-0a822b868083	2026-01-05 03:01:40.602+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
aa0a3d6c-b3f8-4b82-a1f7-bfb9e36dd0d3	903435c7-495f-4fb7-b02d-1a734cb99f5d	2026-01-05 03:01:40.608+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
5ad617e0-9f44-40c8-9e81-177e83f7c3da	3ffea578-dfbe-43d0-8618-d3c0916e949d	2026-01-05 03:01:40.615+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
7ee5acc5-4f70-4406-81c2-df19d006c469	cd411ab4-b3e8-4fed-baef-7b37af1b86e3	2026-01-05 03:01:40.622+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
19364660-2b5e-44f2-9ae9-c8c9aac53096	29c01403-2c95-450a-8420-6981562f9197	2026-01-05 03:01:40.628+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	6d165fcf-b452-43c9-9ca9-8d7d0ce9cfad	\N	Marea importada de seguimiento 2025 (JSONL)
c8dc065f-7b91-4a0f-9722-0ef23b56c792	c25af8f7-896c-4d9d-ace0-f26ef330327a	2026-01-05 03:01:40.633+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
ea7d426f-1759-461a-ac27-272b856802e2	cc9c9e19-ef52-4dcb-b11d-b99011d5ab50	2026-01-05 03:01:40.64+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
5d4fe906-1d07-4d88-8e18-4870e62488a8	fcb39438-a351-4e0c-88e3-9e737a188372	2026-01-05 03:01:40.647+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
ca8c3f1f-7c36-4aef-9cfe-5ec007b1a230	f01a4ca0-d8ef-4931-92ed-4b6bcc69e104	2026-01-05 03:01:40.654+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
f66f2f5b-d1dc-4e86-b972-a0adeb9ac150	8def266d-017b-41d0-bff7-397c412c4ec7	2026-01-05 03:01:40.661+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
2d88ec36-fc1b-4ecb-8133-b6081d8f28c7	d4a21ba7-fc7f-44df-8fd5-8a8f5f74e5d0	2026-01-05 03:01:40.669+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
8de44495-88c6-4a02-8150-7b586ea3a2ee	e109a539-dea0-47f1-99b7-dd032223a055	2026-01-05 03:01:40.675+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	6d165fcf-b452-43c9-9ca9-8d7d0ce9cfad	\N	Marea importada de seguimiento 2025 (JSONL)
8398f0ac-f970-45cd-b912-2effdea0f7f5	ab64c1e5-399e-4e4e-9b22-640cc40d73da	2026-01-05 03:01:40.678+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	6d165fcf-b452-43c9-9ca9-8d7d0ce9cfad	\N	Marea importada de seguimiento 2025 (JSONL)
58ce4ae4-661b-4a5d-8980-633001eefd03	80b6112c-cafd-4328-9fd7-d18ebf2913e6	2026-01-05 03:01:40.683+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
fbda08d7-90e9-474a-b9e3-e91de86216b9	a5d0be4e-80bb-4d33-80bb-7de949e17d6d	2026-01-05 03:01:40.697+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
5c53da43-e7c7-4f2a-85d2-4d3d7c6b1cdd	296c2512-6c1d-4b3a-81a5-13ad6f3eb24b	2026-01-05 03:01:40.704+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
35e10081-5b6f-41b4-ab48-80355a871215	86a45977-8e42-41db-8e69-c38e84e4aca3	2026-01-05 03:01:40.711+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	6d165fcf-b452-43c9-9ca9-8d7d0ce9cfad	\N	Marea importada de seguimiento 2025 (JSONL)
f79cd11b-4aee-4b59-9e7f-aee6f62dd9a3	1a000973-b9e0-4c27-a4fd-7fd0966d0041	2026-01-05 03:01:40.715+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
80a78ccb-d15c-49e9-a1b3-4a38fe627908	87bdc4e9-734c-401c-846e-6a653043cc27	2026-01-05 03:01:40.723+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
65009cbd-8fa2-4bf5-84cb-17d6515877a1	59cfa00e-87cd-4168-8d88-2702462948b8	2026-01-05 03:01:40.738+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	6d165fcf-b452-43c9-9ca9-8d7d0ce9cfad	\N	Marea importada de seguimiento 2025 (JSONL)
c220ff42-610f-4349-9d3b-512c2f9bdeec	34e2623f-0fee-46b1-be85-42225d18fb4d	2026-01-05 03:01:40.742+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
8f817c6c-9dbc-4f24-8d10-d28bbbedffad	56828306-4e4d-4840-8d17-7503f30fb603	2026-01-05 03:01:40.753+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
a95c997d-fdf4-4102-a2b6-a2713dfd03aa	5c26974d-0e37-4057-850c-6090d2d77a04	2026-01-05 03:01:40.759+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
30016583-46d0-4602-8d90-0b78c01455c3	f8464a7e-e18c-4e5f-b448-3b043143adcd	2026-01-05 03:01:40.765+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
3f838cc9-4205-427c-ba46-f9795e7f6ea9	405ce0cf-9df1-4b89-b034-3aa0c9f637c4	2026-01-05 03:01:40.771+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
1e1656b5-b40c-4ecd-be9e-5a4153cca631	35539d81-0628-46f1-9a21-4f073417fcaf	2026-01-05 03:01:40.778+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
3f2791a7-0e98-42e3-8409-d1a121ae2a7e	5a7b54ed-1bff-450f-b467-23be688393fe	2026-01-05 03:01:40.787+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	6d165fcf-b452-43c9-9ca9-8d7d0ce9cfad	\N	Marea importada de seguimiento 2025 (JSONL)
083c592d-e5b5-45b0-bc3e-bf76bced1f40	1f34093e-0d7c-43a8-9834-51eb1265ad99	2026-01-05 03:01:40.792+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
f92296f3-9849-4ba2-b217-2fae74aab8e2	a438844a-3dae-41ec-9ebf-e332a99efdf4	2026-01-05 03:01:40.803+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	6d165fcf-b452-43c9-9ca9-8d7d0ce9cfad	\N	Marea importada de seguimiento 2025 (JSONL)
ccb81675-88e5-465f-8c8f-557e2a1d748d	d6f613ac-58ed-47ae-ae62-39ddf048504d	2026-01-05 03:01:40.807+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
b89eaa56-96ae-4b08-9d57-e52e2f41f102	16a44086-521e-4704-a757-467009e950b3	2026-01-05 03:01:40.814+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
6c6e2d71-b1b8-4711-ae8a-5244c85a2f80	09616800-ca0d-442c-916b-be99e59c8eb2	2026-01-05 03:01:40.824+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
87f1aa97-2da5-4777-8a47-12531692e719	3ce13a74-15b7-417b-80b1-d9d5bbd51512	2026-01-05 03:01:40.83+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
fc7d1e55-88b1-4efe-8e45-b837f50bad26	5241ae97-f2a5-4b22-abec-562cf23cef24	2026-01-05 03:01:40.84+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
87612541-7257-4407-aa56-cf30a55e00b2	115079e9-6820-4bb8-89df-3d0ceafc1036	2026-01-05 03:01:40.846+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	6d165fcf-b452-43c9-9ca9-8d7d0ce9cfad	\N	Marea importada de seguimiento 2025 (JSONL)
a8e34a06-e98d-4846-97d9-0213eb0231f2	dd92916f-323b-4a26-a0bd-238d8ff022da	2026-01-05 03:01:40.85+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
adb1e276-e9b1-4e50-a769-8c55fdcd8fd3	caf1a601-4b21-41b1-a2f5-580c1b548b2a	2026-01-05 03:01:40.856+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
8b3b3425-9852-4f61-b9aa-e256773b5ec5	01ec393e-7986-4bc8-9630-c442d4aefeb0	2026-01-05 03:01:40.863+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
67cc1737-3f64-4a79-bb51-ed0f2000e8a9	e6c2b1a4-03a0-4db8-8aeb-eac9b8fc28b0	2026-01-05 03:01:40.869+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
52b1f3ea-6c4c-4518-ae98-86f4178f2739	ea4b8161-6521-4b42-9401-3c71ddf946ec	2026-01-05 03:01:40.875+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	6d165fcf-b452-43c9-9ca9-8d7d0ce9cfad	\N	Marea importada de seguimiento 2025 (JSONL)
f1c0d69a-14b1-41b3-b485-c0be9908726a	70988259-cd5e-4d00-9af9-0a49e256829e	2026-01-05 03:01:40.88+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
fc393c0c-818d-44c2-a8c3-bd9267b8494c	0c083497-30ba-4c77-858c-ffa2b2bdeb28	2026-01-05 03:01:40.892+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
0e3cf441-77eb-43e3-b9b0-ba188232eec4	289b1223-0ef5-492f-bcb8-14b02bad96b9	2026-01-05 03:01:40.898+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	6d165fcf-b452-43c9-9ca9-8d7d0ce9cfad	\N	Marea importada de seguimiento 2025 (JSONL)
5ecfb879-c588-4266-9d6e-a7b32adff43f	96241b47-1094-4eda-a607-b5b0a8b44611	2026-01-05 03:01:40.903+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
2266fc5e-f012-491d-9456-444a38b94827	f8de1a64-8e6d-4842-ad7d-7881a7723cd1	2026-01-05 03:01:40.909+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	6d165fcf-b452-43c9-9ca9-8d7d0ce9cfad	\N	Marea importada de seguimiento 2025 (JSONL)
978b24ad-808f-4ef5-9441-9b18443553c5	35d59fab-f77b-46fa-8626-379175d39606	2026-01-05 03:01:40.913+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	6d165fcf-b452-43c9-9ca9-8d7d0ce9cfad	\N	Marea importada de seguimiento 2025 (JSONL)
f384fb2f-16df-44cf-8a2e-cecbbbf03e4c	e82d6a51-bfce-4b84-b537-ee1db264a73e	2026-01-05 03:01:40.917+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	6d165fcf-b452-43c9-9ca9-8d7d0ce9cfad	\N	Marea importada de seguimiento 2025 (JSONL)
5b6fbc40-87f8-4b0b-a60e-1aad5729efb7	3fe69381-91ce-4052-bff2-48f90d274546	2026-01-05 03:01:40.921+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
7dacaa44-411a-4ebc-bc51-7e0430367046	a65976dd-1491-4ee9-b721-3ce06dbb4b87	2026-01-05 03:01:40.928+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	0b46e998-9ceb-454e-b621-5ae9c2d4e47f	\N	Marea importada de seguimiento 2025 (JSONL)
d9800a07-e11d-49bc-9cd1-9868b0573b34	3bb27cfe-8fa7-4a09-810d-f21bd55addba	2026-01-05 03:01:40.934+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	6d165fcf-b452-43c9-9ca9-8d7d0ce9cfad	\N	Marea importada de seguimiento 2025 (JSONL)
464521d1-d8f6-42d1-8a5a-45e578fb2294	bf352d58-762a-4c05-a6a1-b28b2ac90a97	2026-01-05 03:01:40.939+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	6d165fcf-b452-43c9-9ca9-8d7d0ce9cfad	\N	Marea importada de seguimiento 2025 (JSONL)
22a06249-96e3-42fb-8e59-698ce0d9030f	b0232b93-443b-4fa2-b94d-c038164a6a74	2026-01-05 03:01:40.943+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
3ec68db9-3265-49eb-9733-d8fff3f7cd71	6bae02ae-8133-42da-ae56-6a57171931fa	2026-01-05 03:01:40.95+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
da9c9e85-9c30-4e74-b2b7-aeea5502b65f	5a6960d2-64d8-432f-b799-666eb19cf046	2026-01-05 03:01:40.957+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
12b80ad4-20e6-44fa-bc54-c990541c3eaa	8cbbaf71-123a-4028-8701-1bbc9d11addb	2026-01-05 03:01:40.966+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
e23ba257-f745-4f0a-af31-452a33e5d779	3d0ec652-e675-4e54-87e1-e4002c2071ae	2026-01-05 03:01:40.976+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
2c38dc52-fb8a-4dcb-920b-443ced325def	24f70169-1959-4cab-ae23-82c5aeb0f4db	2026-01-05 03:01:40.982+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
7c8c8be3-38ed-4b7b-885b-d203ffb0b031	05c47332-39cf-463c-a303-9e3690b20c1b	2026-01-05 03:01:40.989+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
a77d51d5-cc81-4620-b43f-d62c5388ee75	3668dc11-0150-465c-b59d-c095b5880edf	2026-01-05 03:01:40.998+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
9e1a8ec0-3a45-4702-a4aa-7caf24f38cf9	72322443-97cf-4b46-b456-b54631f1577a	2026-01-05 03:01:41.004+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
06b76793-4e28-4a49-b0e7-e027e507beb2	bded166c-2909-4047-80b9-2523a44d0ffc	2026-01-05 03:01:41.01+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
15e17d6b-27d7-4402-913b-04ba3fc093d6	9c529880-1e35-4565-a4b7-5f8812ddab23	2026-01-05 03:01:41.016+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
aec316ed-905b-4180-8d3e-b511e6079da5	8757510f-9cdc-489a-bb9c-f126e2446776	2026-01-05 03:01:41.027+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
1f53540f-fcd3-434f-aa40-3464deabc16c	263e0515-0653-47cf-aeeb-0d83c20136b7	2026-01-05 03:01:41.033+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
be448214-813c-4ab5-90b0-e3626d4fd6c4	3a105dee-6c85-413a-b395-c0e497f6427d	2026-01-05 03:01:41.038+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
c83cfe1d-5903-444b-93e0-aed0d6ec44bd	522ff31e-b483-4499-b463-1646d7bbecf1	2026-01-05 03:01:41.049+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
9f51cd99-827b-4378-bc86-e57043307518	168878f6-2c09-4c2f-96b2-7c565d714ce4	2026-01-05 03:01:41.058+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
48828a0b-4569-4a7b-b20f-9908c6104032	c8dfc52f-c1bd-4779-b74e-934d0588d40d	2026-01-05 03:01:41.064+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
572bd99e-1693-4950-8f42-ede5e09bdc64	376dcc57-0da3-4b0b-ab36-077e5c4fa1b8	2026-01-05 03:01:41.07+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
51d34d2e-26bb-4e97-a6dc-d8953eb2787b	093f8ad7-80a3-4c59-bb85-bb25945d18ec	2026-01-05 03:01:41.077+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
3862e17b-7c84-44a8-bc4a-fb16a40893a5	3949773d-6744-4363-97b3-607d61d22906	2026-01-05 03:01:41.083+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	6d165fcf-b452-43c9-9ca9-8d7d0ce9cfad	\N	Marea importada de seguimiento 2025 (JSONL)
9fac3f13-5ae8-481c-81c5-067305080175	21649eab-04d0-4a6b-b2c8-adca960ecb55	2026-01-05 03:01:41.087+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
0346acc8-880d-4a5d-a778-ce258c8da7a9	540f0be6-4b03-447b-8a77-385d82878cce	2026-01-05 03:01:41.094+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
d6667c73-188f-4d3e-97a0-ad6f56ea75d0	16b0d404-798b-4c26-8e09-9a22747a1beb	2026-01-05 03:01:41.099+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
0bf17dab-c1c6-4f7c-bba0-39654748bc3a	a4312a3b-701d-4dd3-8f4e-366f572506cc	2026-01-05 03:01:41.106+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
f723d751-6661-462f-9c8c-c6060e645461	3df4eabb-5b4f-41df-8833-0b4dbc680975	2026-01-05 03:01:41.113+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
2e351e2e-1e89-44ba-81a4-e7224ce64287	1cfdaa5b-bcdf-416b-995e-8b9b216a34f4	2026-01-05 03:01:41.119+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
dffaf13c-f4d1-4dd9-a5af-3154014f8389	4b7dd270-6186-42cb-8d04-3b3e569124dd	2026-01-05 03:01:41.125+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
78d2dd43-6853-4c91-9836-b93cbcb496dd	109df6bb-70d5-497b-b552-28a569ff1694	2026-01-05 03:01:41.13+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	148db481-40b1-4ec5-9761-e88f6ac5b415	\N	Marea importada de seguimiento 2025 (JSONL)
332b6e59-b244-4a2d-89c5-8f5fbb188abd	d0c9ed52-4a8a-49df-9ddc-d72fce826e3f	2026-01-05 03:01:41.136+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	148db481-40b1-4ec5-9761-e88f6ac5b415	\N	Marea importada de seguimiento 2025 (JSONL)
75c3c1af-670d-4615-891c-e78edef43811	00bb753f-6ef4-4752-8436-aa7a5c43373c	2026-01-05 03:01:41.143+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	c8c59e8f-a7af-45d0-8938-6128a74f3d1a	\N	Marea importada de seguimiento 2025 (JSONL)
2bd2f15c-f76d-4067-ac92-a0a0e51f1b88	f3cf7249-aa35-4dcd-8fb4-2405662bb630	2026-01-05 03:01:41.149+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	c8c59e8f-a7af-45d0-8938-6128a74f3d1a	\N	Marea importada de seguimiento 2025 (JSONL)
9d5a114f-53d4-47a8-b568-81cbd9efe6c2	b66d91a0-b721-4eb1-bf2e-33ca5e17bfc1	2026-01-05 03:01:41.158+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	148db481-40b1-4ec5-9761-e88f6ac5b415	\N	Marea importada de seguimiento 2025 (JSONL)
993b9efc-331d-4be8-a022-ab22c807ce53	cfe37ca3-621b-4d25-af16-c26ddabc88b6	2026-01-05 03:01:41.165+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
80607c6c-41da-4b31-87ea-5f8a22bfd0e9	24042599-75a4-4edc-808e-a45d354a2433	2026-01-05 03:01:41.171+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	\N	Marea importada de seguimiento 2025 (JSONL)
d24796bf-0062-4254-b9b0-59333088e01f	9a1f1d18-7aba-4b1a-a5c5-23d674f27f02	2026-01-05 03:01:41.177+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	148db481-40b1-4ec5-9761-e88f6ac5b415	\N	Marea importada de seguimiento 2025 (JSONL)
ddaef94d-e8b3-4dd4-8ca0-18ddcc7d78ee	c39c814e-21cf-4280-b2da-0d96ecc122ae	2026-01-05 03:01:41.183+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	148db481-40b1-4ec5-9761-e88f6ac5b415	\N	Marea importada de seguimiento 2025 (JSONL)
c3ab2d69-f465-48c1-ba56-adf56fb39116	e68fbab9-7cab-462d-8007-f8a1d7e9028d	2026-01-05 03:01:41.2+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	148db481-40b1-4ec5-9761-e88f6ac5b415	\N	Marea importada de seguimiento 2025 (JSONL)
9ca73034-6bf6-4355-a4a1-3f6570dc62d7	9d972f17-ae4a-47b2-8b30-366a0bb26fe9	2026-01-05 03:01:41.206+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	c8c59e8f-a7af-45d0-8938-6128a74f3d1a	\N	Marea importada de seguimiento 2025 (JSONL)
b030141a-794e-4432-91cb-6e46bbda41dd	8fe5e963-1d40-4c41-a20a-ac7ec9bd820b	2026-01-05 03:01:41.212+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	148db481-40b1-4ec5-9761-e88f6ac5b415	\N	Marea importada de seguimiento 2025 (JSONL)
065fc197-d095-4d4b-a8a7-88b0252222bc	a395bcdb-6342-42b5-a96c-44d9ca052548	2026-01-05 03:01:41.223+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	c8c59e8f-a7af-45d0-8938-6128a74f3d1a	\N	Marea importada de seguimiento 2025 (JSONL)
409a9e2b-917f-4706-91d2-e8fdc3e0d7c7	88ef4a5c-ce79-4651-9fe2-7747985eeb8a	2026-01-05 03:01:41.229+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	148db481-40b1-4ec5-9761-e88f6ac5b415	\N	Marea importada de seguimiento 2025 (JSONL)
be7325b1-76ae-44d1-88ab-5198fc43d526	22208c66-1e34-4f59-90f5-eb97cf2c9c6f	2026-01-05 03:01:41.237+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	148db481-40b1-4ec5-9761-e88f6ac5b415	\N	Marea importada de seguimiento 2025 (JSONL)
499b5e42-6442-489e-b5e0-6d023b5fb055	b77d5c5d-c8bc-4c97-a88c-866691153446	2026-01-05 03:01:41.242+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	c8c59e8f-a7af-45d0-8938-6128a74f3d1a	\N	Marea importada de seguimiento 2025 (JSONL)
dd0c6b87-8b14-4d8c-8ad8-104e22de4651	083c2730-a3d2-434c-a86d-d5e699ad09c6	2026-01-05 03:01:41.248+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	c8c59e8f-a7af-45d0-8938-6128a74f3d1a	\N	Marea importada de seguimiento 2025 (JSONL)
b0de06f3-cb11-4b1a-8af1-a170a1a057ca	3dca4d4a-625c-4c35-b422-42765b8887b5	2026-01-05 03:01:41.259+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	148db481-40b1-4ec5-9761-e88f6ac5b415	\N	Marea importada de seguimiento 2025 (JSONL)
acbf3f75-8b13-4f56-a3e9-d52f6dfb7feb	2fc23898-cd14-4418-81e4-9c3b309fa4c7	2026-01-05 03:01:41.266+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	c8c59e8f-a7af-45d0-8938-6128a74f3d1a	\N	Marea importada de seguimiento 2025 (JSONL)
74f8e4bd-6e28-47e0-a483-d3e9539f8566	7fe6021d-1b3d-45e7-a376-5badbba0a3a8	2026-01-05 03:01:41.278+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	c8c59e8f-a7af-45d0-8938-6128a74f3d1a	\N	Marea importada de seguimiento 2025 (JSONL)
253d3000-14e1-4ee3-80df-fe2d4f29e262	4a5c5e10-ffa3-4422-87a6-c925c6138561	2026-01-05 03:01:41.287+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	148db481-40b1-4ec5-9761-e88f6ac5b415	\N	Marea importada de seguimiento 2025 (JSONL)
89f77f5e-5d9a-48db-acf3-5e36f7e808dd	023cb4a6-22c9-4687-8693-62a4318afbe4	2026-01-05 03:01:41.293+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	c8c59e8f-a7af-45d0-8938-6128a74f3d1a	\N	Marea importada de seguimiento 2025 (JSONL)
a190d105-e046-4055-aa45-34875bc5d867	2d1064a6-728d-4f92-b76b-cf8ee04e4c1b	2026-01-05 03:01:41.299+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	c8c59e8f-a7af-45d0-8938-6128a74f3d1a	\N	Marea importada de seguimiento 2025 (JSONL)
40472640-ac3d-4407-9a53-c48ad61269fb	d7236007-806b-488e-94f5-756e7d7834b6	2026-01-05 03:01:41.305+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	0b46e998-9ceb-454e-b621-5ae9c2d4e47f	\N	Marea importada de seguimiento 2025 (JSONL)
4a535748-d9d2-4804-9941-d04e1e2cc5b7	755126aa-1acb-4811-a11c-61fe28666abe	2026-01-05 03:01:41.311+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	0b46e998-9ceb-454e-b621-5ae9c2d4e47f	\N	Marea importada de seguimiento 2025 (JSONL)
3f95917e-8d0d-4b98-84b3-e6206bab7431	78b3e48f-e4c0-482c-b8f0-8b83a0ab93b6	2026-01-05 03:01:41.317+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	0b46e998-9ceb-454e-b621-5ae9c2d4e47f	\N	Marea importada de seguimiento 2025 (JSONL)
5d926a51-84af-427b-9ff5-91ee968f5d0b	c3d4cbee-815e-4c25-83fa-ebc0463f5302	2026-01-05 03:01:41.323+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	c8c59e8f-a7af-45d0-8938-6128a74f3d1a	\N	Marea importada de seguimiento 2025 (JSONL)
c614b229-1f2a-4c2c-bafa-095e692118fa	cbe37b7f-10aa-4e41-b3f9-f588eaf39416	2026-01-05 03:01:41.329+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	0b46e998-9ceb-454e-b621-5ae9c2d4e47f	\N	Marea importada de seguimiento 2025 (JSONL)
a2157eca-2616-46f6-9265-ea7d8363eab6	733db549-6d27-4288-92a0-0d0b8c25a066	2026-01-05 03:01:41.335+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	0b46e998-9ceb-454e-b621-5ae9c2d4e47f	\N	Marea importada de seguimiento 2025 (JSONL)
0077af79-1a1a-4776-9a2c-74a52f84642d	271c1caf-e5c3-4d61-b129-1799df158cd4	2026-01-05 03:01:41.341+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	aab079f3-c217-451a-ae9e-b8628d2d6cc7	\N	Marea importada de seguimiento 2025 (JSONL)
04663e7f-e61d-4189-bbe7-57066cebe6b6	9328412a-37ab-400c-858f-e61b75e4f0b4	2026-01-05 03:01:41.347+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	aab079f3-c217-451a-ae9e-b8628d2d6cc7	\N	Marea importada de seguimiento 2025 (JSONL)
d31e7fd4-7286-4775-8192-7739a912e295	623715c7-a1a0-414b-95c5-638f9da9476f	2026-01-05 03:01:41.353+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	aab079f3-c217-451a-ae9e-b8628d2d6cc7	\N	Marea importada de seguimiento 2025 (JSONL)
4454f97a-0ceb-4491-a45e-fd8c61b6d480	2b9b049f-0b05-4186-a760-999378fae1d4	2026-01-05 03:01:41.359+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	aab079f3-c217-451a-ae9e-b8628d2d6cc7	\N	Marea importada de seguimiento 2025 (JSONL)
fba29989-b241-4c33-828a-3a930fee04b4	3314a148-6f3a-4b68-8210-fbed75f9f6f2	2026-01-05 03:01:41.366+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	aab079f3-c217-451a-ae9e-b8628d2d6cc7	\N	Marea importada de seguimiento 2025 (JSONL)
91fa0847-4862-416d-9e61-e9fe0e51593c	3dc30ae3-9ab2-41a1-96e8-a90813e21660	2026-01-05 03:01:41.371+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	aab079f3-c217-451a-ae9e-b8628d2d6cc7	\N	Marea importada de seguimiento 2025 (JSONL)
07214e43-e7f5-470e-83cc-94f227180e02	386f1408-c146-4dc3-95d7-1be4a877d8a0	2026-01-05 03:01:41.379+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	aab079f3-c217-451a-ae9e-b8628d2d6cc7	\N	Marea importada de seguimiento 2025 (JSONL)
580a7b9c-bccc-45c8-af30-ed87e69d7c37	e297ded4-a1ea-4889-82fd-7c0a48c6384e	2026-01-05 03:01:41.385+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	aab079f3-c217-451a-ae9e-b8628d2d6cc7	\N	Marea importada de seguimiento 2025 (JSONL)
9d28a8a7-9614-4f23-b9c2-3495dc7b2bcf	6b158ecf-f330-40b4-aee6-b21dd16df254	2026-01-05 03:01:41.391+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	0b46e998-9ceb-454e-b621-5ae9c2d4e47f	\N	Marea importada de seguimiento 2025 (JSONL)
7840ad6b-3f7d-4448-a60b-82d847c1c140	0973b5fb-c2f5-4f33-a5ba-0b4683dbbd43	2026-01-05 03:01:41.397+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	aab079f3-c217-451a-ae9e-b8628d2d6cc7	\N	Marea importada de seguimiento 2025 (JSONL)
c4f054f5-73e1-4ea3-b49a-8ee9f243ad2a	e0ef1cb2-5858-47a7-9e37-a3861a1f973e	2026-01-05 03:01:41.402+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	aab079f3-c217-451a-ae9e-b8628d2d6cc7	\N	Marea importada de seguimiento 2025 (JSONL)
587ac14f-6e3b-4a45-be17-3ae1c4679c79	2b695782-a8d3-41f2-9823-c2179105c9b5	2026-01-05 03:01:41.409+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	aab079f3-c217-451a-ae9e-b8628d2d6cc7	\N	Marea importada de seguimiento 2025 (JSONL)
90234eed-52c9-4cc5-a183-55fe5bcbe9cb	9ad97187-9a07-4de5-a26d-be5bf17d6ccf	2026-01-05 03:01:41.416+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	aab079f3-c217-451a-ae9e-b8628d2d6cc7	\N	Marea importada de seguimiento 2025 (JSONL)
66c665e4-c411-41d1-af49-51b0ebb968d7	48792e89-3021-4c44-a4b2-f18b5ae3c143	2026-01-05 03:01:41.424+00	21d22fd2-bfa5-4cea-b26d-2dff138d5a76	CREACION	\N	aab079f3-c217-451a-ae9e-b8628d2d6cc7	\N	Marea importada de seguimiento 2025 (JSONL)
\.


--
-- Data for Name: muestras; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.muestras (id, lance_id, especie_id, tipo_muestra, peso_muestra_kg, fact_ponderacion, unidad_largo, primera_talla, ultima_talla, intervalo_mm, total_mediciones, observaciones) FROM stdin;
\.


--
-- Data for Name: muestras_detalle_talla; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.muestras_detalle_talla (id, muestra_id, talla_mm, cantidad_machos, cantidad_hembras, cantidad_indet, cantidad_total, indice_original) FROM stdin;
\.


--
-- Data for Name: observador_pesquerias; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.observador_pesquerias (id, id_observador, id_pesqueria, modo, activo, motivo, fecha_desde, fecha_hasta, id_especie) FROM stdin;
\.


--
-- Data for Name: observadores; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.observadores (id, codigo_interno, nombre, apellido, foto_url, tipo_observador, tipo_contrato, activo, disponible, fecha_proxima_disponibilidad, observaciones, con_impedimento, email, motivo_impedimento) FROM stdin;
143e60e7-c2f2-488d-856e-aca349916c07	2021	Claudio	Noale	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	t	claudionoale@hotmail.com	Cambio de trabajo
bb8242a7-b45d-42af-9c93-1e7922fb6457	7149	Gustavo	Cano	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	\N	\N
15d48a97-4e90-4ba7-9762-795c9ec5c435	7562	Lucas	Bentos	\N	TECNICO	LEY MARCO	t	t	\N	\N	f	\N	\N
2bb2a2a1-5a0a-4295-930c-04492e2d0934	7610	Raul Bernardo	Bargas Peña	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	rbbargas@gmail.com	\N
8915b3b3-fa15-4321-be4b-1ba07f8e8f38	7611	Cristian Emmanuel	Cerrina	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	manucerrina2@gmail.com	\N
69a1531e-b147-4e07-af7e-6f9b7a67e66b	7612	Richard Javier	Espinola Gysin	\N	OBSERVADOR	1109	t	t	\N	\N	f	richardjesp@gmail.com	\N
2232db8a-0cb1-4d57-88b8-fb063012d47e	7613	Federico Nicolás	Garcia	\N	OBSERVADOR	1109	t	f	\N	\N	t	fede.gaarciaa@gmail.com	Accidente en motocicleta
0c84d2dd-6fcc-4590-be39-8de9980af870	7616	Jorge Guillermo	Herrera	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	herrerajorgeguillermo@gmail.com	\N
51ead26b-6560-4c0d-8a78-1d871a24bc12	7617	Leonardo Marcos	Kren	\N	OBSERVADOR	MONOTRIBUTISTA	f	t	\N	\N	t	lmlemark@gmail.com	Licencia médica
2e775ee6-e842-48c9-8a74-73172324071b	7620	Diego Sebastian	Marchiori	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	brugmasia@hotmail.com	\N
e1a54806-ba2e-4829-9a29-1ff5421bf0bf	7621	Luis Gabriel	Martinez Tecco	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	lgmt666@hotmail.com	\N
2d16fe4a-b2f1-4564-afe3-72f1c57b7862	7624	Teresa Beatriz	Reinaga	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	tere2361@hotmail.com	\N
b31fe5f0-fffb-4083-b95a-c8800910b922	7625	Eduardo	Silvester	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	eduwolfsilvester@hotmail.com	\N
0428b122-a089-45a9-bbbe-968f45bdc1d8	7627	Jorge Luis	Morales	\N	OBSERVADOR	PLANTA PERMANENTE	t	t	\N	\N	f	didiinidep1980@gmail.com	\N
f38f0451-192f-4ccc-af81-2b1056ff0060	7724	Eduardo Esteban	Aguilar	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	edu81aguilar@gmail.com	\N
0652f854-58ce-451f-9fe0-72c2ef8937ac	7726	Juan José	Coppa	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	juancoppa@hotmail.com	\N
538c1071-c81f-4505-afa0-7ae4e32e0a68	7728	Adrian Pascual	Galluzzo	\N	OBSERVADOR	MONOTRIBUTISTA	f	t	\N	\N	t	apgalluzzo@hotmail.com	Jubilación
cf1a1fb4-3215-4a72-b355-854e6ddd3404	7729	Walter Alejandro	Glavina	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	glavinawalter@hotmail.com	\N
e5360c26-72c6-415c-8e57-1d7221482151	7730	Carlos Daniel	Herrera	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	aquimardel@gmail.com	\N
b956b6d7-7ca0-4b71-934e-1608b3babaa7	7733	Maria Lucila	Maydana	\N	OBSERVADOR	MONOTRIBUTISTA	f	t	\N	\N	f	\N	\N
d6d42a7f-962b-4719-b7bc-429765436de9	7735	Sergio Fabian	Najle	\N	OBSERVADOR	MONOTRIBUTISTA	f	t	\N	\N	t	najlesergio@yahoo.com.ar	Licencia médica
c253759a-a3d6-49a8-a726-e1493e2f1931	7740	Leonardo Luis	Spagnuolo Rey	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	leospagnuolorey@yahoo.com.ar	\N
838c5c6e-090b-4590-a429-40a938ac9770	7742	Héctor Luis	Teves	\N	OBSERVADOR	MONOTRIBUTISTA	f	t	\N	\N	t	hecluteves@hotmail.com	Jubilación
e3f7879d-410e-46d4-96b3-9d219be9e4d2	7767	Claudio Alberto	Nadal	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	nadal-claudio@hotmail.com	\N
7c2ba7c9-de56-440f-81cc-f92352a6f2db	7776	Gonzalo	Troccoli	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	gtroccoli@inidep.edu.ar	\N
4b3eda38-f5c1-4793-87e9-b2fcf6dea236	7796	Fernando Alberto	Schwartz	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	gallococo@hotmail.com	\N
aed52619-5540-4220-bf13-189dbd2a4f39	7798	Marcelo Simón	Freyre	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	freyre.ms@gmail.com	\N
0addb3b9-d4f5-49c7-8719-71b118124e4e	7828	Fabian Eduardo	Desojo	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	t	pachappppp@gmail.com	Cambio de empleo a engrasador
cbd9458a-5f5a-471c-94d1-ae071fcce490	7832	Maximiliano Adrian	Godoy	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	maxigodox@gmail.com	\N
711c10ff-6f1f-433f-89da-903b099f962a	7838	Nicolas Facundo	Staneff Rotela	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	nicolas.staneff@gmail.com	\N
e392011c-4a48-45a1-9b22-411aec8ba356	7840	Durbal	Villalba	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	villalbadurbal@gmail.com	\N
f9b3caae-043b-4e88-8cca-b613dae4e560	7841	Nicolas Agustin	Caballero	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	Nicck934@gmail.com	\N
e0c63dad-5899-4aaf-9610-02f3dc0ed787	7842	Gabriel Osvaldo Catriel	Gimenez Salinas	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	pikyred123@gmail.com	\N
809add91-4b45-4802-8910-46ceb852a8ab	7843	Johnatan	Challier	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	jonhychallier@gmail.com	\N
d15b3fed-415d-42ff-a463-99004a462acb	7844	Sebastían Roque	Garcia	\N	OBSERVADOR	MONOTRIBUTISTA	f	t	\N	\N	f	sebastianroquegarcia4@gmail.com	\N
e7f78d95-1d7c-4e4f-906d-241d9df67db4	7845	Alexia	Aguilar	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	aguilaralexia00@gmail.com	\N
c44af00b-9c37-4656-a350-89ef47afcea1	7846	Oriana	Retamar Mendez	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	t	orianaretamarm@gmail.com	Restricción operativa para embarque de mujeres
cf271634-bab5-4cdc-8f9d-10e6b1410777	7847	Gianfranco	Alvarez	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	gianalvarezobs@gmail.com	\N
f606418d-2704-434d-ab29-89e900be6357	7848	Diego	Gorosito	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	diegojavierg158@gmail.com	\N
534dd89b-5aad-4b50-9e4c-13ddce20542c	7849	Leonardo	Prado Escobar	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	t	estudioprado02@gmail.com	Inactivo según reporte
00235e22-7a6a-4fc3-8312-9824b6bd9b1c	7850	María Laura	Monterisi	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	mlm.vlady@gmail.com	\N
48c396ea-5abd-4bba-8000-bd988d2d0266	7851	Alvaro	Benitez	\N	OBSERVADOR	MONOTRIBUTISTA	f	t	\N	\N	t	alvarobeni89@gmail.com	En otro trabajo
6e82a5b4-f118-400d-b68c-f2d0eed01a58	7852	Camila	Corti	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	camilacorti95@gmail.com	\N
166f92e6-0063-4ab7-aadf-e65aa3421943	7853	Luciano	Matte Casietto	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	lucianomcassietto@hotmail.com.ar	\N
7eeef79b-8ba7-42e8-a94e-ec51c4751538	7854	Gisele	Garcia	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	t	garciagiselealejandra@gmail.com	Desempeño insuficiente reportado
434c265e-3937-4502-90d8-6eb2f627df3a	7855	Nicolas	Pereyra	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	nicolasagustinpereyra777@gmail.com	\N
8f050c17-b629-487c-9647-5b72405b6f8a	7858	Franco	Ibarra	\N	OBSERVADOR	MONOTRIBUTISTA	t	f	\N	\N	t	francoadrianibarra@gmail.com	En otro empleo
393c9098-ed31-4989-b870-7b7a95d4f68f	7859	Melisa	Garcia	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	t	melipg7@gmail.com	Restricción operativa para embarque de mujeres
64095940-467c-449a-bf69-877d1a4d4091	7860	Nahuel	Ramirez	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	nahuelramirezm@gmail.com	\N
2b09cd5a-9603-4054-9f74-e2f191cb113e	7861	Daiana Anabella	Molina Riquelme	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
93cade97-98f3-48be-aae8-894785347a8b	7862	Christian Enderson	Fenco Chavesta	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
52a1afc9-cd66-4884-be32-1c8596e0c9f4	7863	Daniel Enrique	Ramunno	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
d2357ee7-4da8-400a-a683-0256c6265a2f	7864	Manuel Agustín	Palos	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
2d94bb8c-a434-4e9d-89d4-ff5b1dec56cf	7865	Gabriel Alejandro	Dumrauf	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
6ba9bc2b-8d23-48f3-b0f5-2e4e673be4b9	7866	Francisco German	Sette	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
620034c5-bc9e-4730-aca6-5674e20a9527	7867	Cintia Daiana	Magrini Quiroga	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
73c6e6e5-844d-4cc1-9172-c3c4d8aff8fa	7868	Lucas Oscar	Gaona	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
c3c89910-a9b6-4167-a308-21567d801474	7869	Sergio Gastón	Frontera	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
aaefa0e6-697e-423b-afb2-6e098492efe0	7871	Sergio Javier	Gomez Mapiz	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
71177543-d409-4705-8f8c-6c2bd628f83e	7872	Juan Francisco	Rodriguez Fulco	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
2e396807-d844-4e60-87f1-5f6015836600	7873	Lucas David	Carabeta	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
ec08051c-dddd-4b13-98ae-ed2bfda0f470	7874	Morena Aylen	Ledesma	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
0e12b405-0173-495a-824d-b3860e04b6b3	7875	Leonardo Ezequiel	Andrade	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
1142a537-4801-4df3-b9c0-4cf2941a06b6	7876	Walter Alejandro	Leon	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
7adbd940-e36f-4e3a-bb1d-889092fdfb34	7879	Lucía	Martinez Ta	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
487a251c-e868-42da-8eb2-3a825a0501fe	7900	Paola Alejandra	Navarro Grassi	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
0da3a4b7-c66a-4367-9120-e5f28b609c03	8002	Julio Roberto	Sinconegui	\N	OBSERVADOR	MONOTRIBUTISTA	f	t	\N	\N	f	jrsinconegui@inidep.edu.ar	\N
ee992d19-c865-423b-891d-bdec1e4fff9f	9442	Sebastian	Garcia	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
46ddf70f-ac25-479c-a3fb-0d7d25919dfd	9451	Jorge Fernando	Repetto	\N	OBSERVADOR	MONOTRIBUTISTA	f	t	\N	\N	t	cotoperca23@hotmail.com	Jubilación
067816b0-2bf2-4ce3-8f6c-edb585b3787f	9459	Raúl Antonio Ceferino	Puliafito	\N	OBSERVADOR	MONOTRIBUTISTA	f	t	\N	\N	t	raul.puliafito@gmail.com	Traslado a otro programa
36d735e9-1f73-4022-97ef-5480a46dc849	9460	Pablo Alejandro	Ramos	\N	OBSERVADOR	MONOTRIBUTISTA	f	t	\N	\N	t	pabloramos64@yahoo.com.ar	Licencia médica
40947cb3-4afb-49f8-8dd2-fe40d5a52553	9461	Alejandro José	Mazzei	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	alejandromazzei525@gmail.com	\N
3cbc14f6-0180-4fcc-8f04-e21dd972623e	9465	Daniel Alejandro	Di Tullio	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	ddi@inidep.edu.ar	\N
731fd398-1652-42d0-9804-b77459f11206	9467	Pablo Julian	Miranda	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	pablojmiranda65@gmail.com	\N
4a0b6270-5d0a-434c-b433-574029a2849a	9471	Estanislao	Rodriguez Fulco	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	rfestanislao@gmail.com	\N
b158ed18-7849-4fbe-8438-f28936590335	9474	Juan Manuel	Staneff	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	juanmanuel_jotis@hotmail.com	\N
ee36a2a7-39c9-445f-af0b-7b2b36f31f5b	9476	Héctor Eduardo	Vera	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	t	veraeduardo1971@gmail.com	Licencia médica
2ee42832-ae90-451a-ae1d-fdc01bdd8ef9	9480	Cristian Oscar	Piriz	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	t	cristianpiriz36@gmail.com	Licencia médica
\.


--
-- Data for Name: password_reset_tokens; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.password_reset_tokens (id, token, expires_at, used, requested_ip, created_at, user_id) FROM stdin;
\.


--
-- Data for Name: pesquerias; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pesquerias (id, codigo, nombre, descripcion, grupo, orden, activo) FROM stdin;
dd322ad9-2427-4c8a-8c9b-b91728cb6e79	ABADEJO	Abadejo	\N	Peces	\N	t
3eb28887-8530-495e-9269-7cbde3483d8e	ANCHOITA	Anchoíta	\N	Peces	\N	t
54fee2c8-1a7f-4e4f-9446-003299ad81a8	CABALLA	Caballa	\N	Peces	\N	t
c6c01567-eed9-4f78-a59d-f5aec4523577	CALAMAR	Calamar	\N	Moluscos	\N	t
1f6e6d84-215f-48d5-b131-5fe9f3e631da	CENTOLLA	Centolla	\N	Crustáceos	\N	t
61617027-3911-4e52-91ac-c8612dac86c9	AUSTRALES	Especies australes	\N	Peces	\N	t
517a5800-ded1-4a08-96cf-059e1492674f	LANGOSTINO	Langostino	\N	Crustáceos	\N	t
432ad432-4f3a-45db-9952-fb1775b49969	MERLUZA_COMUN	Merluza común	\N	Peces	\N	t
bd11f66e-22de-4ca1-a92a-e76082a2efa8	MERLUZA_NEGRA	Merluza negra	\N	Peces	\N	t
bdb064e1-c2c3-4e77-ac2a-64dc9bd12fbf	VIEIRA	Vieira	\N	Moluscos	\N	t
\.


--
-- Data for Name: producciones; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.producciones (id, marea_id, especie_id, fecha, producto, categoria, factor_conversion, kg_produccion, operarios) FROM stdin;
\.


--
-- Data for Name: product_images; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_images (id, url, "productId") FROM stdin;
\.


--
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.products (id, title, price, description, slug, stock, sizes, gender, tags, "userId") FROM stdin;
\.


--
-- Data for Name: puertos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.puertos (id, nombre, provincia, pais, codigo_interno, codigo_externo, es_local, activo, orden, observaciones, latitud, longitud) FROM stdin;
e0b0f151-ed4a-4e35-bc48-d82f5c70ab83	Buenos Aires	\N	\N	12	\N	f	t	\N	\N	-34.58333	-58.38334
7d12bca4-4fa5-48cd-99c1-46804feb82da	Rio Grande (brasil)	\N	\N	20	\N	f	t	\N	\N	-32.13334	-52.08333
cd4d9d4b-eae0-4818-9352-6855d65f15b7	Montevideo	\N	\N	XX	\N	f	t	\N	\N	-34.9	-56.2
94485e45-926c-41ea-8d05-61de7b0fe71a	Samborombon	\N	\N	21	\N	f	t	\N	\N	-35.73333	-57.31667
dc9c1932-81f6-4034-bf08-dca2bd045819	San Clemente	\N	\N	14	\N	f	t	\N	\N	-36.33333	-56.78333
37a047f1-e311-4664-b056-6f4311757b33	Mar Del Plata	\N	\N	1	\N	t	t	\N	\N	-38.06667	-57.55
d773576d-f3b2-42e0-868e-e7e06e1f6f4e	Quequen	\N	\N	2	\N	f	t	\N	\N	-38.58333	-58.7
b06cb245-db92-471b-a70e-f741a6593708	Bahia Blanca	\N	\N	3	\N	f	t	\N	\N	-38.75	-62.16667
306fc61f-eec8-480a-90d6-a7e0df6e1631	Bahia San Blas	\N	\N	15	\N	f	t	\N	\N	-40.55	-62.23333
01fc8bfe-1c87-4372-8c81-fde334c2bba5	San Antonio Oeste	\N	\N	9	\N	f	t	\N	\N	-40.73333	-64.96667
47c80031-6c0a-43f2-b77b-f1e2f2ebd461	Viedma	\N	\N	22	\N	f	t	\N	\N	-40.9	-62.86666
20e6681d-78b9-4d78-8fff-3549a0c294bd	Puerto Madryn	\N	\N	4	\N	f	t	\N	\N	-42.76667	-65.05
a68c150f-2d39-40d2-a693-9d1b15859f5f	Rawson	\N	\N	7	\N	f	t	\N	\N	-43.33333	-65.06667
105e07d4-f6ad-4e15-beb3-4277af2bf600	Bahia Camarones	\N	\N	11	\N	f	t	\N	\N	-44.8	-65.73333
dad98859-6c8d-4cdf-b76d-5c6da58c2e2b	Comod, Rivad,	\N	\N	6	\N	f	t	\N	\N	-45.88334	-67.5
c8c5146c-97b6-4cd5-828a-61c7a01e3765	Caleta Olivia	\N	\N	16	\N	f	t	\N	\N	-46.43333	-67.53333
be29702b-a6a9-434d-8eb3-5705e0f7468f	Deseado	\N	\N	5	\N	f	t	\N	\N	-47.76667	-65.91666
312d9201-ab88-4789-b1d5-8ad33f9efda1	San Julian	\N	\N	17	\N	f	t	\N	\N	-49.31667	-67.73333
5ea121ae-2b91-463a-9059-36dec5f80316	Punta Quilla	\N	\N	23	\N	f	t	\N	\N	-50.11666	-68.41666
3f5e0bbf-6a0f-4ad5-b168-7d546ae577d4	Rio Gallegos	\N	\N	19	\N	f	t	\N	\N	-51.63334	-69.2
60cc1963-ba0f-4f37-ac75-cd04fdcd2ade	Ushuaia	\N	\N	10	\N	f	t	\N	\N	-54.83333	-68.3
\.


--
-- Data for Name: submuestras; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.submuestras (id, muestra_id, numero_ejemplar, largo_total, largo_estandar, peso_total_g, peso_gonadas_g, sexo, estadio_madurez, replecion, contenido_estomacal, observaciones_ejemplar) FROM stdin;
\.


--
-- Data for Name: tipos_flota; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tipos_flota (id, codigo, nombre, descripcion, orden, activo) FROM stdin;
5198f123-1489-4b07-84be-366d439f1d47	FRESQUERO	Fresquero	\N	\N	t
f1bf8e9b-0fdd-45b9-8ae3-0e37f264b18e	TANGONERO	Tangonero	\N	\N	t
5f917487-3b4d-4cec-ac8b-6f549a1ce217	CONGELADOR_MERLUCERO	Congelador Merlucero	\N	\N	t
190f0241-000f-4363-8f07-aa8e2d2b94df	POTERO	Potero	\N	\N	t
5b6e3b32-ed41-492e-a683-cb08f60e5dd9	PALANGRERO	Palangrero	\N	\N	t
206c18c2-95c5-435f-9635-b6fe04f4dd50	CONGELADOR_ARRASTRERO	Congelador Arrastrero	\N	\N	t
e72ee47d-c05e-422b-b740-59668cc58a73	CENTOLLERO	Centollero	\N	\N	t
627a88cb-bf97-434f-bfab-4ef3339c44d3	VIEIRERO	Vieirero	\N	\N	t
4bcfaa2a-1a55-4c30-8256-bc499d7d07dc	COSTERO	Costero	\N	\N	t
201b037d-1ab0-4fb9-92aa-c9af3cff2044	INVESTIGACION	Investigación	\N	\N	t
3d12af20-a640-4760-a148-43da27100340	SURIMERO	Surimero	\N	\N	t
f3a8852c-766a-409f-995c-6d9d53dc3f05	RAYERO	Rayero	\N	\N	t
3c4c96c7-1ccb-437d-8cb4-ec87500da20d	CONGELADOR_AUSTRAL	Congelador Austral	\N	\N	t
718d7348-2d48-40ef-a45a-cb871e408425	CONGELADOR_GENERICO	Congelador Genérico	\N	\N	t
\.


--
-- Data for Name: transiciones_estados; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.transiciones_estados (id, id_estado_origen, id_estado_destino, accion, etiqueta, clase_boton, requiere_observaciones, activo) FROM stdin;
e28b5fb2-b9a8-4a76-b0fb-6aec282ec38d	aab079f3-c217-451a-ae9e-b8628d2d6cc7	0b46e998-9ceb-454e-b621-5ae9c2d4e47f	REGISTRAR_INICIO	Registrar Inicio	primary	f	t
0a6ea990-6599-4014-b026-5411fdd78323	0b46e998-9ceb-454e-b621-5ae9c2d4e47f	c8c59e8f-a7af-45d0-8938-6128a74f3d1a	REGISTRAR_ARRIBO	Confirmar Arribo	primary	f	t
1b80d86d-7e5b-402e-b1ce-2cf34fcedf7f	c8c59e8f-a7af-45d0-8938-6128a74f3d1a	869ccd5c-68a7-4bf7-a0ef-6200b1c2c119	RECIBIR_DATOS	Recibir Archivos	primary	f	t
44d1c13a-cd59-46fc-9ecf-ffdc548f61e7	869ccd5c-68a7-4bf7-a0ef-6200b1c2c119	81096fea-40d1-4988-9a02-588fb19ecd6c	INICIAR_VERIFICACION	Iniciar Verificación	primary	f	t
291d8e8d-b4be-4209-b94a-d1569834ebd8	81096fea-40d1-4988-9a02-588fb19ecd6c	d162fa52-c9f6-4a58-95c7-7a4f00e8c61d	ABRIR_CORRECCION	Abrir Corrección	secondary	f	t
5cbed488-2bc2-49ec-a7cd-a506664aef50	81096fea-40d1-4988-9a02-588fb19ecd6c	512e920a-9dc6-400b-bae2-578198852527	PASAR_A_INFORME	Pasar a Informe	primary	f	t
1136f1bb-285b-4f2f-b55f-067bf44543a2	d162fa52-c9f6-4a58-95c7-7a4f00e8c61d	512e920a-9dc6-400b-bae2-578198852527	FINALIZAR_CORRECCION	Finalizar Corrección	primary	f	t
d521df9c-fa83-46cd-be33-e0e88c7198c4	d162fa52-c9f6-4a58-95c7-7a4f00e8c61d	da2e1c81-0b09-436a-bf14-ed2232f3efef	DELEGAR_EXTERNA	Derivar a Proyecto	secondary	f	t
1767674f-8183-4f97-8ec8-5c088c09cb0b	da2e1c81-0b09-436a-bf14-ed2232f3efef	d162fa52-c9f6-4a58-95c7-7a4f00e8c61d	RETORNAR_CORRECCION	Devolución Externa	primary	f	t
29a0f68f-305b-4c42-990c-f7aac66d4154	512e920a-9dc6-400b-bae2-578198852527	913c4ac6-ce74-40d0-a981-1e718cdfbdbb	ENVIAR_A_REVISION	Enviar a Revisión	primary	f	t
2eb9416f-195a-4cce-b0db-3a01a1db5b8a	913c4ac6-ce74-40d0-a981-1e718cdfbdbb	148db481-40b1-4ec5-9761-e88f6ac5b415	APROBAR_INFORME	Aprobar Informe	primary	f	t
b9fe5b97-adea-4bf8-8894-9f9336604c22	913c4ac6-ce74-40d0-a981-1e718cdfbdbb	512e920a-9dc6-400b-bae2-578198852527	RECHAZAR_INFORME	Observaciones en Informe	secondary	f	t
0e2db9f0-6640-48ae-a414-017ecf9ceea2	148db481-40b1-4ec5-9761-e88f6ac5b415	f3539a8d-995c-4f58-8e4f-83e991c5569d	INICIAR_TRAMITE	Iniciar Protocolización	primary	f	t
ee9a540a-511d-4356-9a9e-d12d8da75bbf	f3539a8d-995c-4f58-8e4f-83e991c5569d	f19efdbe-abe2-46f8-aa4b-69f979ffbea7	FINALIZAR_PROTOCOLIZACION	Finalizar Protocolización	primary	f	t
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, email, password, "fullName", "isActive", roles, "themePreference", "avatarUrl") FROM stdin;
21d22fd2-bfa5-4cea-b26d-2dff138d5a76	admin@obs.com	$2b$10$D2B3LzvgbeQbTDc5A3wb7.m3r0cVwqYroXcmk9RhbZWQ0723cz.lu	Administrador Sistema	t	{admin}	system	\N
abcfcd87-416f-4202-b58c-0deec39438b3	coordinador@obs.com	$2b$10$D2B3LzvgbeQbTDc5A3wb7.m3r0cVwqYroXcmk9RhbZWQ0723cz.lu	Coordinador Operativo	t	{coordinador}	system	\N
c6371b9a-3cd3-42dd-9bab-c972d763180f	tecnico@obs.com	$2b$10$D2B3LzvgbeQbTDc5A3wb7.m3r0cVwqYroXcmk9RhbZWQ0723cz.lu	Técnico de Datos	t	{tecnico_datos}	system	\N
6a7e1293-1802-49f2-b011-8b8a01bd16c8	asistente@obs.com	$2b$10$D2B3LzvgbeQbTDc5A3wb7.m3r0cVwqYroXcmk9RhbZWQ0723cz.lu	Asistente Administrativo	t	{asistente_administrativo}	system	\N
\.


--
-- Name: product_images_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.product_images_id_seq', 1, false);


--
-- Name: _prisma_migrations _prisma_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._prisma_migrations
    ADD CONSTRAINT _prisma_migrations_pkey PRIMARY KEY (id);


--
-- Name: artes_pesca artes_pesca_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.artes_pesca
    ADD CONSTRAINT artes_pesca_pkey PRIMARY KEY (id);


--
-- Name: buque_trayectoria_puntos buque_trayectoria_puntos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.buque_trayectoria_puntos
    ADD CONSTRAINT buque_trayectoria_puntos_pkey PRIMARY KEY (id);


--
-- Name: buque_trayectorias buque_trayectorias_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.buque_trayectorias
    ADD CONSTRAINT buque_trayectorias_pkey PRIMARY KEY (id);


--
-- Name: buques buques_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.buques
    ADD CONSTRAINT buques_pkey PRIMARY KEY (id);


--
-- Name: capturas capturas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.capturas
    ADD CONSTRAINT capturas_pkey PRIMARY KEY (id);


--
-- Name: error_logs error_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.error_logs
    ADD CONSTRAINT error_logs_pkey PRIMARY KEY (id);


--
-- Name: especies especies_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.especies
    ADD CONSTRAINT especies_pkey PRIMARY KEY (id);


--
-- Name: estados_marea estados_marea_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.estados_marea
    ADD CONSTRAINT estados_marea_pkey PRIMARY KEY (id);


--
-- Name: lances lances_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lances
    ADD CONSTRAINT lances_pkey PRIMARY KEY (id);


--
-- Name: mareas_archivos mareas_archivos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mareas_archivos
    ADD CONSTRAINT mareas_archivos_pkey PRIMARY KEY (id);


--
-- Name: mareas_etapas_observadores mareas_etapas_observadores_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mareas_etapas_observadores
    ADD CONSTRAINT mareas_etapas_observadores_pkey PRIMARY KEY (id);


--
-- Name: mareas_etapas mareas_etapas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mareas_etapas
    ADD CONSTRAINT mareas_etapas_pkey PRIMARY KEY (id);


--
-- Name: mareas_movimientos mareas_movimientos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mareas_movimientos
    ADD CONSTRAINT mareas_movimientos_pkey PRIMARY KEY (id);


--
-- Name: mareas mareas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mareas
    ADD CONSTRAINT mareas_pkey PRIMARY KEY (id);


--
-- Name: muestras_detalle_talla muestras_detalle_talla_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.muestras_detalle_talla
    ADD CONSTRAINT muestras_detalle_talla_pkey PRIMARY KEY (id);


--
-- Name: muestras muestras_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.muestras
    ADD CONSTRAINT muestras_pkey PRIMARY KEY (id);


--
-- Name: observador_pesquerias observador_pesquerias_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.observador_pesquerias
    ADD CONSTRAINT observador_pesquerias_pkey PRIMARY KEY (id);


--
-- Name: observadores observadores_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.observadores
    ADD CONSTRAINT observadores_pkey PRIMARY KEY (id);


--
-- Name: password_reset_tokens password_reset_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.password_reset_tokens
    ADD CONSTRAINT password_reset_tokens_pkey PRIMARY KEY (id);


--
-- Name: pesquerias pesquerias_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pesquerias
    ADD CONSTRAINT pesquerias_pkey PRIMARY KEY (id);


--
-- Name: producciones producciones_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.producciones
    ADD CONSTRAINT producciones_pkey PRIMARY KEY (id);


--
-- Name: product_images product_images_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_images
    ADD CONSTRAINT product_images_pkey PRIMARY KEY (id);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- Name: puertos puertos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.puertos
    ADD CONSTRAINT puertos_pkey PRIMARY KEY (id);


--
-- Name: submuestras submuestras_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.submuestras
    ADD CONSTRAINT submuestras_pkey PRIMARY KEY (id);


--
-- Name: tipos_flota tipos_flota_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tipos_flota
    ADD CONSTRAINT tipos_flota_pkey PRIMARY KEY (id);


--
-- Name: transiciones_estados transiciones_estados_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transiciones_estados
    ADD CONSTRAINT transiciones_estados_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: artes_pesca_codigo_numerico_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX artes_pesca_codigo_numerico_key ON public.artes_pesca USING btree (codigo_numerico);


--
-- Name: buque_trayectoria_puntos_buque_id_timestamp_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX buque_trayectoria_puntos_buque_id_timestamp_idx ON public.buque_trayectoria_puntos USING btree (buque_id, "timestamp");


--
-- Name: buque_trayectoria_puntos_buque_id_timestamp_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX buque_trayectoria_puntos_buque_id_timestamp_key ON public.buque_trayectoria_puntos USING btree (buque_id, "timestamp");


--
-- Name: buque_trayectoria_puntos_trayectoria_id_timestamp_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX buque_trayectoria_puntos_trayectoria_id_timestamp_idx ON public.buque_trayectoria_puntos USING btree (trayectoria_id, "timestamp");


--
-- Name: buque_trayectorias_buque_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX buque_trayectorias_buque_id_idx ON public.buque_trayectorias USING btree (buque_id);


--
-- Name: buque_trayectorias_buque_id_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX buque_trayectorias_buque_id_key ON public.buque_trayectorias USING btree (buque_id);


--
-- Name: buques_matricula_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX buques_matricula_key ON public.buques USING btree (matricula);


--
-- Name: capturas_lance_id_especie_id_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX capturas_lance_id_especie_id_key ON public.capturas USING btree (lance_id, especie_id);


--
-- Name: capturas_lance_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX capturas_lance_id_idx ON public.capturas USING btree (lance_id);


--
-- Name: especies_codigo_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX especies_codigo_key ON public.especies USING btree (codigo);


--
-- Name: estados_marea_codigo_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX estados_marea_codigo_key ON public.estados_marea USING btree (codigo);


--
-- Name: lances_etapa_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX lances_etapa_id_idx ON public.lances USING btree (etapa_id);


--
-- Name: lances_etapa_id_numero_lance_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX lances_etapa_id_numero_lance_key ON public.lances USING btree (etapa_id, numero_lance);


--
-- Name: mareas_anio_marea_nro_marea_id_buque_tipo_marea_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX mareas_anio_marea_nro_marea_id_buque_tipo_marea_key ON public.mareas USING btree (anio_marea, nro_marea, id_buque, tipo_marea);


--
-- Name: mareas_archivos_id_marea_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX mareas_archivos_id_marea_idx ON public.mareas_archivos USING btree (id_marea);


--
-- Name: mareas_etapas_id_marea_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX mareas_etapas_id_marea_idx ON public.mareas_etapas USING btree (id_marea);


--
-- Name: mareas_etapas_id_marea_nro_etapa_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX mareas_etapas_id_marea_nro_etapa_key ON public.mareas_etapas USING btree (id_marea, nro_etapa);


--
-- Name: mareas_etapas_observadores_id_etapa_id_observador_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX mareas_etapas_observadores_id_etapa_id_observador_key ON public.mareas_etapas_observadores USING btree (id_etapa, id_observador);


--
-- Name: mareas_etapas_observadores_id_etapa_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX mareas_etapas_observadores_id_etapa_idx ON public.mareas_etapas_observadores USING btree (id_etapa);


--
-- Name: mareas_etapas_observadores_id_observador_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX mareas_etapas_observadores_id_observador_idx ON public.mareas_etapas_observadores USING btree (id_observador);


--
-- Name: mareas_movimientos_id_marea_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX mareas_movimientos_id_marea_idx ON public.mareas_movimientos USING btree (id_marea);


--
-- Name: muestras_detalle_talla_muestra_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX muestras_detalle_talla_muestra_id_idx ON public.muestras_detalle_talla USING btree (muestra_id);


--
-- Name: muestras_detalle_talla_muestra_id_talla_mm_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX muestras_detalle_talla_muestra_id_talla_mm_key ON public.muestras_detalle_talla USING btree (muestra_id, talla_mm);


--
-- Name: muestras_lance_id_especie_id_tipo_muestra_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX muestras_lance_id_especie_id_tipo_muestra_key ON public.muestras USING btree (lance_id, especie_id, tipo_muestra);


--
-- Name: muestras_lance_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX muestras_lance_id_idx ON public.muestras USING btree (lance_id);


--
-- Name: observador_pesquerias_id_observador_id_pesqueria_modo_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX observador_pesquerias_id_observador_id_pesqueria_modo_key ON public.observador_pesquerias USING btree (id_observador, id_pesqueria, modo);


--
-- Name: observador_pesquerias_id_observador_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX observador_pesquerias_id_observador_idx ON public.observador_pesquerias USING btree (id_observador);


--
-- Name: observador_pesquerias_id_pesqueria_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX observador_pesquerias_id_pesqueria_idx ON public.observador_pesquerias USING btree (id_pesqueria);


--
-- Name: observadores_codigo_interno_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX observadores_codigo_interno_key ON public.observadores USING btree (codigo_interno);


--
-- Name: observadores_email_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX observadores_email_key ON public.observadores USING btree (email);


--
-- Name: pesquerias_codigo_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX pesquerias_codigo_key ON public.pesquerias USING btree (codigo);


--
-- Name: producciones_marea_id_especie_id_fecha_producto_categoria_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX producciones_marea_id_especie_id_fecha_producto_categoria_key ON public.producciones USING btree (marea_id, especie_id, fecha, producto, categoria);


--
-- Name: producciones_marea_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX producciones_marea_id_idx ON public.producciones USING btree (marea_id);


--
-- Name: products_slug_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX products_slug_key ON public.products USING btree (slug);


--
-- Name: products_title_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX products_title_key ON public.products USING btree (title);


--
-- Name: puertos_codigo_interno_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX puertos_codigo_interno_key ON public.puertos USING btree (codigo_interno);


--
-- Name: submuestras_muestra_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX submuestras_muestra_id_idx ON public.submuestras USING btree (muestra_id);


--
-- Name: submuestras_muestra_id_numero_ejemplar_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX submuestras_muestra_id_numero_ejemplar_key ON public.submuestras USING btree (muestra_id, numero_ejemplar);


--
-- Name: tipos_flota_codigo_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX tipos_flota_codigo_key ON public.tipos_flota USING btree (codigo);


--
-- Name: transiciones_estados_id_estado_origen_id_estado_destino_acc_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX transiciones_estados_id_estado_origen_id_estado_destino_acc_key ON public.transiciones_estados USING btree (id_estado_origen, id_estado_destino, accion);


--
-- Name: users_email_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX users_email_key ON public.users USING btree (email);


--
-- Name: buque_trayectoria_puntos buque_trayectoria_puntos_buque_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.buque_trayectoria_puntos
    ADD CONSTRAINT buque_trayectoria_puntos_buque_id_fkey FOREIGN KEY (buque_id) REFERENCES public.buques(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: buque_trayectoria_puntos buque_trayectoria_puntos_trayectoria_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.buque_trayectoria_puntos
    ADD CONSTRAINT buque_trayectoria_puntos_trayectoria_id_fkey FOREIGN KEY (trayectoria_id) REFERENCES public.buque_trayectorias(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: buque_trayectorias buque_trayectorias_buque_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.buque_trayectorias
    ADD CONSTRAINT buque_trayectorias_buque_id_fkey FOREIGN KEY (buque_id) REFERENCES public.buques(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: buques buques_id_arte_habitual_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.buques
    ADD CONSTRAINT buques_id_arte_habitual_fkey FOREIGN KEY (id_arte_habitual) REFERENCES public.artes_pesca(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: buques buques_id_pesqueria_habitual_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.buques
    ADD CONSTRAINT buques_id_pesqueria_habitual_fkey FOREIGN KEY (id_pesqueria_habitual) REFERENCES public.pesquerias(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: buques buques_id_puerto_base_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.buques
    ADD CONSTRAINT buques_id_puerto_base_fkey FOREIGN KEY (id_puerto_base) REFERENCES public.puertos(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: buques buques_id_tipo_flota_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.buques
    ADD CONSTRAINT buques_id_tipo_flota_fkey FOREIGN KEY (id_tipo_flota) REFERENCES public.tipos_flota(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: capturas capturas_especie_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.capturas
    ADD CONSTRAINT capturas_especie_id_fkey FOREIGN KEY (especie_id) REFERENCES public.especies(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: capturas capturas_lance_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.capturas
    ADD CONSTRAINT capturas_lance_id_fkey FOREIGN KEY (lance_id) REFERENCES public.lances(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: lances lances_cod_arte_pesca_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lances
    ADD CONSTRAINT lances_cod_arte_pesca_fkey FOREIGN KEY (cod_arte_pesca) REFERENCES public.artes_pesca(codigo_numerico) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: lances lances_etapa_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lances
    ADD CONSTRAINT lances_etapa_id_fkey FOREIGN KEY (etapa_id) REFERENCES public.mareas_etapas(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: mareas_archivos mareas_archivos_id_marea_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mareas_archivos
    ADD CONSTRAINT mareas_archivos_id_marea_fkey FOREIGN KEY (id_marea) REFERENCES public.mareas(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: mareas_archivos mareas_archivos_id_movimiento_origen_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mareas_archivos
    ADD CONSTRAINT mareas_archivos_id_movimiento_origen_fkey FOREIGN KEY (id_movimiento_origen) REFERENCES public.mareas_movimientos(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: mareas_archivos mareas_archivos_id_usuario_subio_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mareas_archivos
    ADD CONSTRAINT mareas_archivos_id_usuario_subio_fkey FOREIGN KEY (id_usuario_subio) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: mareas_etapas mareas_etapas_id_marea_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mareas_etapas
    ADD CONSTRAINT mareas_etapas_id_marea_fkey FOREIGN KEY (id_marea) REFERENCES public.mareas(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: mareas_etapas mareas_etapas_id_pesqueria_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mareas_etapas
    ADD CONSTRAINT mareas_etapas_id_pesqueria_fkey FOREIGN KEY (id_pesqueria) REFERENCES public.pesquerias(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: mareas_etapas mareas_etapas_id_puerto_arribo_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mareas_etapas
    ADD CONSTRAINT mareas_etapas_id_puerto_arribo_fkey FOREIGN KEY (id_puerto_arribo) REFERENCES public.puertos(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: mareas_etapas mareas_etapas_id_puerto_zarpada_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mareas_etapas
    ADD CONSTRAINT mareas_etapas_id_puerto_zarpada_fkey FOREIGN KEY (id_puerto_zarpada) REFERENCES public.puertos(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: mareas_etapas_observadores mareas_etapas_observadores_id_etapa_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mareas_etapas_observadores
    ADD CONSTRAINT mareas_etapas_observadores_id_etapa_fkey FOREIGN KEY (id_etapa) REFERENCES public.mareas_etapas(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: mareas_etapas_observadores mareas_etapas_observadores_id_observador_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mareas_etapas_observadores
    ADD CONSTRAINT mareas_etapas_observadores_id_observador_fkey FOREIGN KEY (id_observador) REFERENCES public.observadores(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: mareas mareas_id_arte_principal_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mareas
    ADD CONSTRAINT mareas_id_arte_principal_fkey FOREIGN KEY (id_arte_principal) REFERENCES public.artes_pesca(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: mareas mareas_id_buque_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mareas
    ADD CONSTRAINT mareas_id_buque_fkey FOREIGN KEY (id_buque) REFERENCES public.buques(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: mareas mareas_id_estado_actual_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mareas
    ADD CONSTRAINT mareas_id_estado_actual_fkey FOREIGN KEY (id_estado_actual) REFERENCES public.estados_marea(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: mareas_movimientos mareas_movimientos_id_estado_desde_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mareas_movimientos
    ADD CONSTRAINT mareas_movimientos_id_estado_desde_fkey FOREIGN KEY (id_estado_desde) REFERENCES public.estados_marea(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: mareas_movimientos mareas_movimientos_id_estado_hasta_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mareas_movimientos
    ADD CONSTRAINT mareas_movimientos_id_estado_hasta_fkey FOREIGN KEY (id_estado_hasta) REFERENCES public.estados_marea(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: mareas_movimientos mareas_movimientos_id_marea_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mareas_movimientos
    ADD CONSTRAINT mareas_movimientos_id_marea_fkey FOREIGN KEY (id_marea) REFERENCES public.mareas(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: mareas_movimientos mareas_movimientos_id_usuario_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mareas_movimientos
    ADD CONSTRAINT mareas_movimientos_id_usuario_fkey FOREIGN KEY (id_usuario) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: muestras_detalle_talla muestras_detalle_talla_muestra_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.muestras_detalle_talla
    ADD CONSTRAINT muestras_detalle_talla_muestra_id_fkey FOREIGN KEY (muestra_id) REFERENCES public.muestras(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: muestras muestras_especie_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.muestras
    ADD CONSTRAINT muestras_especie_id_fkey FOREIGN KEY (especie_id) REFERENCES public.especies(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: muestras muestras_lance_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.muestras
    ADD CONSTRAINT muestras_lance_id_fkey FOREIGN KEY (lance_id) REFERENCES public.lances(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: observador_pesquerias observador_pesquerias_id_especie_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.observador_pesquerias
    ADD CONSTRAINT observador_pesquerias_id_especie_fkey FOREIGN KEY (id_especie) REFERENCES public.especies(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: observador_pesquerias observador_pesquerias_id_observador_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.observador_pesquerias
    ADD CONSTRAINT observador_pesquerias_id_observador_fkey FOREIGN KEY (id_observador) REFERENCES public.observadores(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: observador_pesquerias observador_pesquerias_id_pesqueria_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.observador_pesquerias
    ADD CONSTRAINT observador_pesquerias_id_pesqueria_fkey FOREIGN KEY (id_pesqueria) REFERENCES public.pesquerias(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: password_reset_tokens password_reset_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.password_reset_tokens
    ADD CONSTRAINT password_reset_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: producciones producciones_especie_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.producciones
    ADD CONSTRAINT producciones_especie_id_fkey FOREIGN KEY (especie_id) REFERENCES public.especies(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: producciones producciones_marea_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.producciones
    ADD CONSTRAINT producciones_marea_id_fkey FOREIGN KEY (marea_id) REFERENCES public.mareas(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: product_images product_images_productId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_images
    ADD CONSTRAINT "product_images_productId_fkey" FOREIGN KEY ("productId") REFERENCES public.products(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: products products_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT "products_userId_fkey" FOREIGN KEY ("userId") REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: submuestras submuestras_muestra_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.submuestras
    ADD CONSTRAINT submuestras_muestra_id_fkey FOREIGN KEY (muestra_id) REFERENCES public.muestras(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: transiciones_estados transiciones_estados_id_estado_destino_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transiciones_estados
    ADD CONSTRAINT transiciones_estados_id_estado_destino_fkey FOREIGN KEY (id_estado_destino) REFERENCES public.estados_marea(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: transiciones_estados transiciones_estados_id_estado_origen_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transiciones_estados
    ADD CONSTRAINT transiciones_estados_id_estado_origen_fkey FOREIGN KEY (id_estado_origen) REFERENCES public.estados_marea(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;


--
-- PostgreSQL database dump complete
--

