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
c682a081-0da5-453f-a40a-2b5c1e1600b4	2	t	Red de arrastre de fondo
43d6ebbf-a4fd-4cf9-9737-1eac7ca4ca29	6	t	Red de arrastre de media agua
351321c7-98cf-4aaf-be4c-8da0110baf56	3	t	Red de lampara
5e2f30f6-892b-42bc-9b4e-f523ea75ff8a	5	t	Espinel
44aa2880-5bdb-4f72-8f2d-b9444097a793	4	t	Red de enmalle
87675914-29c9-4bb7-b734-fc02aa5bb1c4	18	t	Red agallera de deriva
98911c36-01d8-460d-9d96-d7ba44748277	16	t	Palangre de fondo
5eb86417-244b-4e24-bb67-075bc8ce9883	1	t	Red de cerco
471ab4e5-5434-43d9-bd6a-560a192685bb	19	t	Red Bongo 300
b32d28b9-b960-4172-a7ff-aa464357dd35	20	t	Red Bongo 500
c94adc45-7ec9-46f2-b097-9acb4e6b4a38	21	t	Red Nakthai
097a3eba-a2f8-4112-990e-a29a899a8561	22	t	Red Isaac-Kidd
2271d1ac-e407-4cae-8601-b62acad68e1d	7	t	Rastra
e5f58a7b-99ba-41ab-8ac3-77484b61e5cd	8	t	Nasa
bc9cdd49-02e9-4ad7-b64e-74219bd9d910	9	t	Linea
1d9324d4-894c-4cf2-8978-815f7b41647f	10	t	Raño
d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	11	t	Poteras
5f081689-5d99-406c-87c8-2d44417804a6	12	t	Red de fondeo
984dfcf6-1b60-40c7-b703-9616ab048651	13	t	Trampa centollera
e0913412-884d-4103-97b7-3eceac842fcf	14	t	Red de arrastre de fondo con tangones
7ab6820f-0d58-49da-a2de-bf2997492d2e	32	t	Currican
bda76efe-9053-4ebf-9d66-6f822c32841d	15	t	Red de arrastre de fondo en pareja
63b69360-0eb6-4324-b46b-e597b9234ecc	80	t	Otros
1145fd43-1d40-473d-9aca-dad3324106aa	0	t	Sin Especificar
b5607c53-5cec-4642-8595-e7bb023a69db	90	t	No Identificado
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
2512b4c8-5318-446b-b238-fd86ef4849f1	7 de Diciembre	TEMP-0001	1013	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	27.20	521	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a		Mar del Plata	4895032		\N	operacionesconsultoramaritima@gmail.com	\N	\N	Consultora Maritima	t	\N	\N	\N
72b0eda1-7000-416b-8f28-f9fcdc981af5	ACRUX	03086	0	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	28.00	0	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	DE ANGELIS Y LOGGHE S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
24ed6c0e-dcbe-4c01-968b-831b7ed5e11c	ALDEBARAN	01741	1038	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	26.42	426	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	PESQUERA SAN ROQUE	Mar del Plata		480-0573	\N		\N	\N		t	\N	\N	\N
4d319aca-2f49-4ee7-8f57-1b5f064806ff	ALTALENA	0181	1051	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	55.80	1350	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	MARONTI  S.A.	Mar del Plata	4800005		\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi	t	\N	\N	\N
0ae0621e-76ed-4854-a8b1-510fbc431044	ALVAREZ ENTRENA I	02454	1055	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	39.43	988	7f1cac29-7e2c-4b6d-8447-1a5a9108fd12	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
2fde3ad9-8e60-4d67-a99b-e20eeaea122a	ALVAREZ ENTRENA II	02465	1056	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	39.50	988	7f1cac29-7e2c-4b6d-8447-1a5a9108fd12	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
ba2efeeb-8e0e-49f4-b272-3d8005592b40	ALVAREZ ENTRENA III	02379	\N	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	\N	\N	7f1cac29-7e2c-4b6d-8447-1a5a9108fd12	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
6d98e664-5133-4563-aae3-6ae6d43ea1e1	BAFFETTA	02635	0	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	19.45	295	7f1cac29-7e2c-4b6d-8447-1a5a9108fd12	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
92993a1e-325d-4679-9c17-71dfea173f14	ALVAREZ ENTRENA VI	01	2774	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	30.50	1033	7f1cac29-7e2c-4b6d-8447-1a5a9108fd12	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
64c8e2e8-e60a-4911-a82a-5496b8fa2727	AMBITION	01324	\N	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	\N	\N	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	PESQUERA TRES MARIAS  S.A.	Mar del Plata		480-0336	\N		\N	\N		t	\N	\N	\N
3bd01f47-2ca9-447e-a346-fbfe23e039b7	ANITA	3	\N	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	\N	\N	\N	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	SOLIMENO	Mar del Plata			\N		\N	\N		t	\N	\N	\N
1c111f78-01e8-464f-8bde-f55f17664c7f	ANA III	278	1069	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	19.95	443	7f1cac29-7e2c-4b6d-8447-1a5a9108fd12	POSEIDON  S.A.	Puerto Madryn		0280-445-7786	\N		\N	\N		t	\N	\N	\N
f4751805-8e72-4524-a9b0-430b5a3cf2da	ANABELLA  M	0175	\N	fa86a02c-c6bf-4615-ac50-e6a64cb929bb	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	60	\N	\N	7f1cac29-7e2c-4b6d-8447-1a5a9108fd12	PESCAPUERTA ARGENTINA  S.A.	Puerto Madryn		0280-445-4407	\N		\N	\N		t	\N	\N	\N
762dde0b-f9e0-4a8a-934f-0f4e99a49f1f	ANDRES JORGE	1065	2760	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	50.10	1102	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	MARONTI  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
af07a9f3-a2a7-4f2e-b7ab-fb9bfbdb4271	ANGELUS	01953	1087	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	52.60	1337	7a9e4185-6281-4c42-b3c4-1980e6855a31	PESQUERA CRUZ DEL SUR  S.A.	Ciudad Autónoma de Buenos Aires		011-4784-1760	\N		\N	\N		t	\N	\N	\N
563e68d1-351d-43f3-bd19-3724aab22771	ANITA ALVAREZ	02138	\N	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	\N	\N	7f1cac29-7e2c-4b6d-8447-1a5a9108fd12	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
995c7c37-0edb-4794-b84d-7cd6c0ba3c79	ANTARTIC  I	0232	\N	baef63e2-6404-4129-809c-e46df7aaf2de	98911c36-01d8-460d-9d96-d7ba44748277	f87ceb11-df61-4862-b41f-70db2096902b	60	\N	\N	7a9e4185-6281-4c42-b3c4-1980e6855a31	ESTREMAR  S.A.	Ciudad Autónoma de Buenos Aires		011-6533-7853 / 4345-1102	\N		\N	\N		t	\N	\N	\N
cc5fffe1-f7b4-4f57-9c09-c62413a9ee06	ANTARTIC II	0263	\N	baef63e2-6404-4129-809c-e46df7aaf2de	98911c36-01d8-460d-9d96-d7ba44748277	f87ceb11-df61-4862-b41f-70db2096902b	60	\N	\N	7a9e4185-6281-4c42-b3c4-1980e6855a31	ESTREMAR  S.A.	Ciudad Autónoma de Buenos Aires		011-6533-7853 / 4345-1102	\N		\N	\N		t	\N	\N	\N
4d460f84-cb4e-4009-b725-5927a459fe7a	ANTARTIC III	0262	\N	baef63e2-6404-4129-809c-e46df7aaf2de	98911c36-01d8-460d-9d96-d7ba44748277	f87ceb11-df61-4862-b41f-70db2096902b	60	\N	\N	7a9e4185-6281-4c42-b3c4-1980e6855a31	ESTREMAR  S.A.	Ciudad Autónoma de Buenos Aires		011-6533-7853 / 4345-1102	\N		\N	\N		t	\N	\N	\N
45a60bda-cfc1-4016-8e95-0248758b9669	ANTARTIDA	0678	\N	fa86a02c-c6bf-4615-ac50-e6a64cb929bb	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	60	\N	\N	7f1cac29-7e2c-4b6d-8447-1a5a9108fd12	IBERCONSA  DE ARGENTINA  S.A.	Puerto Madryn	4891227	0280-445-4324	\N	serviciosmaritimosmdq@gmail.com	\N	\N	Servicio Maritimo Integral	t	\N	\N	\N
d6778991-a4a8-4ba8-bb68-6595640baa0a	ANTONINO	0877	1099	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	27.60	541	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	AGLIPESCA  S.A.	Mar del Plata		480-2886	\N		\N	\N		t	\N	\N	\N
c89b6338-55ec-4d14-b0f0-09a680fb4504	ANTONIO ALVAREZ	01429	1100	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	36.60	1168	7f1cac29-7e2c-4b6d-8447-1a5a9108fd12	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
9fb1c2b4-99b5-4034-bd90-58ab346b9b19	API II	0679	\N	fa86a02c-c6bf-4615-ac50-e6a64cb929bb	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	60	\N	\N	7f1cac29-7e2c-4b6d-8447-1a5a9108fd12	IBERCONSA  DE ARGENTINA  S.A.	Puerto Madryn		0280-445-4324	\N		\N	\N		t	\N	\N	\N
48faadc5-d159-4d19-bd96-c284545ce7c4	API IV	0680	\N	fa86a02c-c6bf-4615-ac50-e6a64cb929bb	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	60	\N	\N	7f1cac29-7e2c-4b6d-8447-1a5a9108fd12	IBERCONSA  DE ARGENTINA  S.A.	Puerto Madryn		0280-445-4324	\N		\N	\N		t	\N	\N	\N
021d9bcd-a4dc-41ac-bf12-91d3bf59e23a	API V	02781	2711	fa86a02c-c6bf-4615-ac50-e6a64cb929bb	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	60	77.40	2960	7f1cac29-7e2c-4b6d-8447-1a5a9108fd12	IBERCONSA  DE ARGENTINA  S.A.	Puerto Madryn		0280-445-4324	\N		\N	\N		t	\N	\N	\N
35d27b83-9134-4e6b-9207-d6bc516222c9	API VI	02812	2734	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	40	36.35	1201	7f1cac29-7e2c-4b6d-8447-1a5a9108fd12	IBERCONSA  DE ARGENTINA  S.A.	Puerto Madryn		0280-445-4324	\N		\N	\N		t	\N	\N	\N
927c5ab9-3f81-420c-bae3-5c6518f7271f	API VII	03081	2777	fa86a02c-c6bf-4615-ac50-e6a64cb929bb	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	60	72.20	0	7f1cac29-7e2c-4b6d-8447-1a5a9108fd12	IBERCONSA  DE ARGENTINA  S.A.	Puerto Madryn		0280-445-4324	\N		\N	\N		t	\N	\N	\N
47e850a9-31d9-4f63-bf40-31bba82fc7cd	ARBUMASA X	6183	1114	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	35.30	1087	9e97a6b3-cca1-4931-92e9-ab8a5e0b35e1	ARBUMASA  S.A.	Puerto Deseado		0297-487-2807 / 444-5338 / 444-1201	\N		\N	\N		t	\N	\N	\N
3a4a8458-60e4-42de-b56c-b2d08c080e5a	ARBUMASA XIX	06440	1117	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	36.40	870	9e97a6b3-cca1-4931-92e9-ab8a5e0b35e1	ARBUMASA  S.A.	Puerto Deseado		0297-487-2807 / 444-5338 / 444-1201	\N		\N	\N		t	\N	\N	\N
41482218-49ee-40c3-a980-8bb0caabba53	ARBUMASA  XVII	0216	\N	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	\N	\N	9e97a6b3-cca1-4931-92e9-ab8a5e0b35e1	ARBUMASA  S.A.	Puerto Deseado		0297-487-2807 / 444-5338 / 444-1201	\N		\N	\N		t	\N	\N	\N
281cfef2-fef8-4d45-820f-09b63c00363e	ARBUMASA XIV	0213	1116	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	36.40	1047	9e97a6b3-cca1-4931-92e9-ab8a5e0b35e1	ARBUMASA  S.A.	Puerto Deseado		0297-487-2807 / 444-5338 / 444-1201	\N		\N	\N		t	\N	\N	\N
9e678444-485c-42fa-b1a8-0a4bda99677d	ARBUMASA XV	214	1118	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	36.40	870	\N	ARBUMASA  S.A.				\N		\N	\N		t	\N	\N	\N
423aec28-c14b-4d45-a6af-3c3b9b51b923	ARBUMASA XVI	0215	1119	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	36.40	1047	9e97a6b3-cca1-4931-92e9-ab8a5e0b35e1	ARBUMASA  S.A.	Puerto Deseado		0297-487-2807 / 444-5338 / 444-1201	\N		\N	\N		t	\N	\N	\N
0fefc266-c8c0-4c90-9ac1-4a9968e7941c	ARBUMASA XVIII	0217	1121	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	36.40	870	9e97a6b3-cca1-4931-92e9-ab8a5e0b35e1	ARBUMASA  S.A.	Puerto Deseado	4893758	0297-487-2807 / 444-5338 / 444-1201	\N	miguel-visoso@hotmail.com	\N	\N	Agencia Maritima Solvox	t	\N	\N	\N
38827f45-80bb-461c-b457-b1df9c3d8ac5	ARBUMASA XXIX	02561	1126	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	65.60	1776	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	BAL - FISH  S.A.	Mar del Plata		489-6522	\N		\N	\N		t	\N	\N	\N
26fd82f6-d7a2-4a19-8268-cfce3331e6e3	ARBUMASA XXVI	01958	1127	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	62.80	2403	9e97a6b3-cca1-4931-92e9-ab8a5e0b35e1	ARBUMASA  S.A.	Puerto Deseado	4893758	0297-487-2807 / 444-5338 / 444-1201	\N	miguel-visoso@hotmail.com	\N	\N	Agencia Maritima Solvox	t	\N	\N	\N
4c20ce4e-4d96-4658-97cb-cb6f019ad550	ARBUMASA XXVII	02057	1128	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	64.21	1154	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	BAL - FISH  S.A.	Mar del Plata		489-6522	\N		\N	\N		t	\N	\N	\N
d1e2685a-e03f-4dbf-bf31-e20c148964fb	ARBUMASA XXVIII	02569	1129	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	64.40	1776	9e97a6b3-cca1-4931-92e9-ab8a5e0b35e1	ARBUMASA  S.A.	Puerto Deseado		0297-487-2807 / 444-5338 / 444-1201	\N		\N	\N		t	\N	\N	\N
a1b3a169-8bb2-4674-bfec-d82657ed439b	ARCANGEL	79	\N	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	\N	\N	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	CALME  S.A.	Mar del Plata		480-3545	\N		\N	\N		t	\N	\N	\N
26b4ec45-8a75-46d2-8b15-169d00673350	ARESIT	02265	1134	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	36.26	1085	7f1cac29-7e2c-4b6d-8447-1a5a9108fd12	HARENGUS  S.A.	Puerto Madryn	4808331/4808332	0280-445-0822	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
4f238ba3-1947-452c-b242-ef341dcfc720	ARGENOVA I	02180	1137	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	35.00	655	9e97a6b3-cca1-4931-92e9-ab8a5e0b35e1	ARGENOVA  S.A.	Puerto Deseado	4808331/4808332	0297- 487-0550  (447-2818  Com. Riv )	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
c3f4a652-4b34-42e9-9930-e96b32260f0c	ARGENOVA IV	02157	1140	\N	\N	\N	0	36.26	675	9e97a6b3-cca1-4931-92e9-ab8a5e0b35e1	MAR DE LAS PALMAS  S.A.	Puerto Deseado	4808331/4808332	0297-487-2112	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
3e0a9026-3dfc-427d-bbcf-33f3001366dc	ARGENOVA X	02329	1146	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	32.50	550	9e97a6b3-cca1-4931-92e9-ab8a5e0b35e1	ARGENOVA  S.A.	Puerto Deseado	4808331/4808332	0297- 487-0550  (447-2818  Com. Riv )	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
78f3f450-073b-4792-9e6e-2aa07f8c089e	ARGENOVA XI	02199	\N	baef63e2-6404-4129-809c-e46df7aaf2de	98911c36-01d8-460d-9d96-d7ba44748277	f87ceb11-df61-4862-b41f-70db2096902b	60	\N	\N	9e97a6b3-cca1-4931-92e9-ab8a5e0b35e1	ARGENOVA  S.A.	Puerto Deseado	4808331/4808332	0297- 487-0550  (447-2818  Com. Riv )	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
365e6078-51de-4e30-9183-8877176fad16	ARGENOVA XXI	02661	2704	280a7409-6bb5-4e36-bad1-93194d72bb82	c682a081-0da5-453f-a40a-2b5c1e1600b4	089b0ead-176b-4e7a-b99d-5caeea74ea61	60	55.80	1826	9e97a6b3-cca1-4931-92e9-ab8a5e0b35e1	ARGENOVA  S.A.	Puerto Deseado	4808331/4808332	0297- 487-0550  (447-2818  Com. Riv )	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
19434b4b-f8ad-4dfb-a4ab-f28e6fd9f10c	ARGENOVA XXII	02714	2713	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	40	37.70	663	9e97a6b3-cca1-4931-92e9-ab8a5e0b35e1	ARGENOVA  S.A.	Puerto Deseado	4808331/4808332	0297- 487-0550  (447-2818  Com. Riv )	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
f4302b36-6efd-44f9-988f-38e5602e465a	ARGENOVA XXIII	02713	2707	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	37.19	678	9e97a6b3-cca1-4931-92e9-ab8a5e0b35e1	ARGENOVA  S.A.	Puerto Deseado	4808331/4808332	0297- 487-0550  (447-2818  Com. Riv )	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
02b01be9-afcc-4bb5-8f10-4e93403867c6	ARGENOVA XXIV	02752	2731	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	38.80	675	9e97a6b3-cca1-4931-92e9-ab8a5e0b35e1	ARGENOVA  S.A.	Puerto Deseado	4808331/4808332	0297- 487-0550  (447-2818  Com. Riv )	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
6579264e-c2dc-4b8e-94eb-52e6c7036639	ARGENOVA XXV	028011	2740	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	39.70	859	9e97a6b3-cca1-4931-92e9-ab8a5e0b35e1	ARGENOVA  S.A.	Puerto Deseado	4808331/4808332	0297- 487-0550  (447-2818  Com. Riv )	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
f46fedbf-0bab-48ee-ba51-23036b14d54f	ARGENOVA XXVI	02849	2739	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	37.15	1086	9e97a6b3-cca1-4931-92e9-ab8a5e0b35e1	ARGENOVA  S.A.	Puerto Deseado	4808331/4808332	0297- 487-0550  (447-2818  Com. Riv )	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
f3b5b774-c396-4c36-b4e9-9f1ff9e47020	ARGENOVA II	02177	1138	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	38.50	1168	9e97a6b3-cca1-4931-92e9-ab8a5e0b35e1	ARGENOVA  S.A.	Puerto Deseado	4808331/4808332	0297- 487-0550  (447-2818  Com. Riv )	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
3f88b110-0587-4ded-89b3-76fb2f3fca25	ARGENOVA III	02156	\N	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	\N	\N	9e97a6b3-cca1-4931-92e9-ab8a5e0b35e1	ARGENOVA  S.A.	Puerto Deseado		0297- 487-0550  (447-2818  Com. Riv )	\N		\N	\N		t	\N	\N	\N
768e05a9-4b22-4f54-9cdf-ee53ea77f6f0	ARGENOVA IX	02328	1141	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	32.50	550	9e97a6b3-cca1-4931-92e9-ab8a5e0b35e1	ARGENOVA  S.A.	Puerto Deseado	4808331/4808332	0297- 487-0550  (447-2818  Com. Riv )	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
00376707-b94f-4f18-a52e-6fe1b8773e2e	ARGENOVA XII	0199	\N	baef63e2-6404-4129-809c-e46df7aaf2de	98911c36-01d8-460d-9d96-d7ba44748277	f87ceb11-df61-4862-b41f-70db2096902b	60	\N	\N	9e97a6b3-cca1-4931-92e9-ab8a5e0b35e1	ARGENOVA  S.A.	Puerto Deseado	4808331/4808332	0297- 487-0550  (447-2818  Com. Riv )	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
2cdfcf01-1c3b-4403-a760-921e1221b840	ARGENOVA XIV	0197	1149	baef63e2-6404-4129-809c-e46df7aaf2de	98911c36-01d8-460d-9d96-d7ba44748277	f87ceb11-df61-4862-b41f-70db2096902b	60	52.30	1352	9e97a6b3-cca1-4931-92e9-ab8a5e0b35e1	ARGENOVA  S.A.	Puerto Deseado	4808331/4808332	0297- 487-0550  (447-2818  Com. Riv )	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
e9c72efc-1bd1-48c1-a722-880ca6facc74	ARGENOVA XV	0198	\N	baef63e2-6404-4129-809c-e46df7aaf2de	98911c36-01d8-460d-9d96-d7ba44748277	f87ceb11-df61-4862-b41f-70db2096902b	60	\N	\N	9e97a6b3-cca1-4931-92e9-ab8a5e0b35e1	ARGENOVA  S.A.	Puerto Deseado	4800274	0297- 487-0550  (447-2818  Com. Riv )	\N	amalfitanoycia@hotmail.com	\N	\N	Agencia Maritima Almafitano	t	\N	\N	\N
9f3b39cd-f4c3-4592-9440-41d742b4ed88	ARGENTINO	0142	1157	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	33.77	1001	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	PESQUERA VERAZ  S.A.	Mar del Plata		489-4624 / 489-0314 (astillero)	\N		\N	\N		t	\N	\N	\N
50a50744-de06-4167-bad6-a61cf2c99dce	ARKOFISH	0236	\N	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	\N	\N	7f1cac29-7e2c-4b6d-8447-1a5a9108fd12	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
00cbd6cd-801c-460d-9b47-2485ed16b52f	ARKOFISH I	6004	\N	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	\N	\N	7f1cac29-7e2c-4b6d-8447-1a5a9108fd12	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
7f9f73dc-e260-44e4-b84b-872d6c0d7beb	ARRUFO	0540	1165	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	39.16	1102	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	LUIS SOLIMENO e HIJOS  S.A.	Mar del Plata		489-3030	\N		\N	\N		t	\N	\N	\N
cf3ec121-9078-42dc-a51e-72d8792fa02d	ASUDEPES II	6363	\N	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	\N	\N	7a9e4185-6281-4c42-b3c4-1980e6855a31	ASUDEPES  S.A.	Ciudad Autónoma de Buenos Aires		011-4383-9756	\N		\N	\N		t	\N	\N	\N
60438d76-98dd-481e-92e8-19532bda5d27	ASUDEPES III	6062	\N	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	\N	\N	7a9e4185-6281-4c42-b3c4-1980e6855a31	ASUDEPES  S.A.	Ciudad Autónoma de Buenos Aires		011-4383-9756	\N		\N	\N		t	\N	\N	\N
a8750dc5-73de-4af6-8256-02c3d4f0e31b	ATLANTIC EXPRESS	02936	2727	c7afdae7-d068-45a9-a855-1011df4d2f92	984dfcf6-1b60-40c7-b703-9616ab048651	c2c3c456-5f2c-47a2-a8af-d41dc148a19f	30	53.70	3426	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	WANCHESE ARGENTINA  S.A.	Mar del Plata		489-1236	\N		\N	\N		t	\N	\N	\N
a8f01245-1987-4d4a-b283-5576013424c9	ATLANTIC SURF I	0350	\N	fc8c8ee3-01dd-40b0-96f2-6b99a6643f7b	e0913412-884d-4103-97b7-3eceac842fcf	7bfb912c-3ee4-426e-a976-68bbbf6bc1d4	40	\N	\N	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	GLACIAR PESQUERA  S.A.	Mar del Plata	4890960	492-2216	\N	agencia@maritimavidal.com.ar	\N	\N	Agencia Maritima Vidal	t	\N	\N	\N
467088f6-e25d-4770-8b96-502514b918cb	ATLANTIC SURF III	02030	1176	fc8c8ee3-01dd-40b0-96f2-6b99a6643f7b	e0913412-884d-4103-97b7-3eceac842fcf	7bfb912c-3ee4-426e-a976-68bbbf6bc1d4	60	49.60	3020	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	GLACIAR PESQUERA  S.A.	Mar del Plata	4800274	492-2216	\N	amalfitanoycia@hotmail.com	\N	\N	Agencia Maritima Almafitano	t	\N	\N	\N
7cf6a359-27ac-42d4-9ebd-e2ce3ebc8d3b	ATREVIDO	0145	1180	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	32.50	901	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	PESQUERA VERAZ  S.A.	Mar del Plata	4800005	489-4624 / 489-0314 (astillero)	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
e3e50e91-7a17-4479-a230-330cc160931f	AURORA	02581	1183	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	67.55	1776	7a9e4185-6281-4c42-b3c4-1980e6855a31	KALEU KALEU  S.A.	Ciudad Autónoma de Buenos Aires		011-3220-2130  / 5093-1215	\N		\N	\N		t	\N	\N	\N
c1d28cbf-113e-4cbd-b7c4-a7dd697957c0	BAHIA DESVELOS	0665	1194	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	37.05	791	7a9e4185-6281-4c42-b3c4-1980e6855a31	PESQUERA SANTA CRUZ  S.A.	Ciudad Autónoma de Buenos Aires		011-4305-4706	\N		\N	\N		t	\N	\N	\N
96629179-6af1-4135-9e36-1f738589d079	BEAGLE I	6052	1207	fa86a02c-c6bf-4615-ac50-e6a64cb929bb	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	60	59.90	2369	7a9e4185-6281-4c42-b3c4-1980e6855a31	YUKEN  S.A.	Ciudad Autónoma de Buenos Aires	4891553-154179360-154179860-154179062	011-5279-1302 / 5236-6069	\N	agenciasmiriglio@speedy.com.ar	\N	\N	Agencia Maritima Smiriglio	t	\N	\N	\N
98ce5dca-a977-4ad8-9ec6-b93127c47182	BELVEDERE	01398	1210	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	26.50	624	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	PRINMAR  S.A. Buque Motor Belvedere	Mar del Plata		480-0883	\N		\N	\N		t	\N	\N	\N
0498ea59-679f-4035-ad97-04ba8cd3f214	BOGAVANTE SEGUNDO	02994	2743	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	37.45	867	7f1cac29-7e2c-4b6d-8447-1a5a9108fd12	IBERCONSA  DE ARGENTINA  S.A.	Puerto Madryn		0280-445-4324	\N		\N	\N		t	\N	\N	\N
1d6da0e2-79f9-41a3-8a5c-9745300cf529	BONFIGLIO	01234	\N	907fd6b2-95a4-42bf-856e-a9b0d99402ea	c682a081-0da5-453f-a40a-2b5c1e1600b4	\N	10	\N	\N	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	COSTA BRAVA  S.A.	Mar del Plata		489-7538	\N		\N	\N		t	\N	\N	\N
94c1e02c-8749-43bb-a070-1f26ca875953	BORRASCA	01095	1218	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	39.16	1083	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	LUIS SOLIMENO e HIJOS  S.A.	Mar del Plata		489-3030	\N		\N	\N		t	\N	\N	\N
adbb76d3-66b9-4676-9de8-6b395cb32284	BOUCIÑA	01637	1221	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	0.00	0	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	CALME  S.A.	Mar del Plata	4800005	480-3545	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
56f7eea5-337e-48aa-a332-0d683dc0ee11	BUENA PESCA	01475	2717	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	39.10	1479	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	PEDRO MOSCUZZA e HIJOS  S.A.	Mar del Plata		489-7287	\N		\N	\N		t	\N	\N	\N
5224519b-cf40-4d76-a250-390c5b16a486	CABO BUEN TIEMPO	025	\N	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	\N	\N	7f1cac29-7e2c-4b6d-8447-1a5a9108fd12	ALPESCA  S.A.	Puerto Madryn		0280-447-4958 / 45-1069	\N		\N	\N		t	\N	\N	\N
c8949911-e404-455e-9bff-5278705ceec4	CABO BUENA ESPERANZA	02482	\N	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	\N	\N	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	UNIVERSAL PESQUERA  SRL	Mar del Plata		489-0352	\N		\N	\N		t	\N	\N	\N
203b9b46-c4a4-48c6-8333-91f2c586ffb2	CABO DE HORNOS	01537	\N	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	\N	\N	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	MILANI Y PATANE  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
b72cd203-3f19-4db9-9b1c-0dcb02b5bd4d	CABO DOS BAHIAS	02483	\N	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	\N	\N	7f1cac29-7e2c-4b6d-8447-1a5a9108fd12	ALPESCA  S.A.	Puerto Madryn		0280-447-4958 / 45-1069	\N		\N	\N		t	\N	\N	\N
84188eff-af37-4d81-bb2d-e4ca0a39c88f	CABO SAN JUAN	023	\N	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	\N	\N	7f1cac29-7e2c-4b6d-8447-1a5a9108fd12	ALPESCA  S.A.	Puerto Madryn		0280-447-4958 / 45-1069	\N		\N	\N		t	\N	\N	\N
dd9cce34-a7ff-4a7f-b050-b5072d4f1339	CABO SAN SEBASTIAN	022	\N	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	\N	\N	7f1cac29-7e2c-4b6d-8447-1a5a9108fd12	ALPESCA  S.A.	Puerto Madryn		0280-447-4958 / 45-1069	\N		\N	\N		t	\N	\N	\N
bbfdbfd6-7842-474f-b0ba-d6ac09e49079	CABO TRES PUNTAS	01483	1242	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	31.43	721	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	OSTRAMAR  S.A.	Mar del Plata		489-1959	\N		\N	\N		t	\N	\N	\N
246a1cfe-8772-47b7-af53-f07f9b0bfb00	CABO VIRGENES	024	\N	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	\N	\N	7f1cac29-7e2c-4b6d-8447-1a5a9108fd12	ALPESCA  S.A.	Puerto Madryn		0280-447-4958 / 45-1069	\N		\N	\N		t	\N	\N	\N
1fc72a69-0c4d-4185-bc58-8f9014a92d6a	CALABRIA	0567	1245	907fd6b2-95a4-42bf-856e-a9b0d99402ea	c682a081-0da5-453f-a40a-2b5c1e1600b4	\N	4	19.63	266	7f1cac29-7e2c-4b6d-8447-1a5a9108fd12	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
77eb653f-6e60-4800-a342-19ce788ca4f7	CALIZ	02809	0	907fd6b2-95a4-42bf-856e-a9b0d99402ea	c682a081-0da5-453f-a40a-2b5c1e1600b4	\N	4	20.20	545	a39428a8-f7d6-4716-9c31-99556bfb37f3	FLOTA AMARILLA RAWSON	Rawson			\N		\N	\N		t	\N	\N	\N
7e5ae46b-326b-48ff-9d33-1def5588e63d	CALLEJA	06276	1249	907fd6b2-95a4-42bf-856e-a9b0d99402ea	c682a081-0da5-453f-a40a-2b5c1e1600b4	\N	10	21.83	503	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	OTESA  S.A.	Mar del Plata		493-5606	\N		\N	\N		t	\N	\N	\N
96ebabee-c62f-4e02-99da-8fe8bc93ebf9	CAMERIGE	01406	1252	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	27.90	652	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	PESQUERA  MARGARITA  S.A.	Mar del Plata	4891553-154179360-154179860-154179062	489-4645   /   489-2946	\N	agenciasmiriglio@speedy.com.ar	\N	\N	Agencia Maritima SMIRIGLIO	t	\N	\N	\N
5353aec1-303d-4880-b418-c3e162621d04	CANAL DE BEAGLE	0407	0	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	23.90	501	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	CANAL DE BEAGLE  S.R.L.	Mar del Plata		480-4447	\N		\N	\N		t	\N	\N	\N
022693f1-d736-45eb-9fcd-7f21eeb8d382	CAPESANTE	02929	2723	fc8c8ee3-01dd-40b0-96f2-6b99a6643f7b	e0913412-884d-4103-97b7-3eceac842fcf	7bfb912c-3ee4-426e-a976-68bbbf6bc1d4	40	50.15	2550	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	GLACIAR PESQUERA  S.A.	Mar del Plata		492-2216	\N		\N	\N		t	\N	\N	\N
48ac0c57-4441-4ae2-97cc-06ab8fc3e066	CAPITAN CANEPA	059F	\N	a5778547-a20e-4929-a1a6-c0aab7f0466c	\N	\N	28	\N	\N	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	INIDEP	Mar del Plata		451-7442 ó 486-2586 int 162	\N		\N	\N		t	\N	\N	\N
5f2b663c-76e1-4303-8741-2f5cd7cbdd17	CAPITAN GIACHINO	0151	1260	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	38.42	1062	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	KALARI S.A.	Mar del Plata		489-1959	\N		\N	\N		t	\N	\N	\N
fe266a9c-27a2-4cee-a987-4d594013ec94	CAPITAN OCA BALDA	060F	\N	a5778547-a20e-4929-a1a6-c0aab7f0466c	\N	\N	21	\N	\N	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	INIDEP	Mar del Plata		451-7442 ó 486-2586 int 162	\N		\N	\N		t	\N	\N	\N
2e522e70-3af5-4c0b-901e-980229f6a8a9	CARMEN A	02045	1269	907fd6b2-95a4-42bf-856e-a9b0d99402ea	c682a081-0da5-453f-a40a-2b5c1e1600b4	\N	4	15.30	223	a39428a8-f7d6-4716-9c31-99556bfb37f3	FLOTA AMARILLA RAWSON	Rawson			\N		\N	\N		t	\N	\N	\N
d8323940-0d32-415f-99a5-b4b0502a35be	CAROLINA P	0176	1272	280a7409-6bb5-4e36-bad1-93194d72bb82	c682a081-0da5-453f-a40a-2b5c1e1600b4	089b0ead-176b-4e7a-b99d-5caeea74ea61	60	71.60	1976	7f1cac29-7e2c-4b6d-8447-1a5a9108fd12	ESTRELLA PATAGONICA S.A.	Puerto Madryn		0280-445-4407	\N		\N	\N		t	\N	\N	\N
90290ea0-d63b-44fc-aee1-56de12831c63	CEIBE DOUS	0336	1276	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	40.70	738	7f1cac29-7e2c-4b6d-8447-1a5a9108fd12	IBERCONSA  DE ARGENTINA  S.A.	Puerto Madryn	4800274	0280-445-4324	\N	amalfitanoycia@hotmail.com	\N	\N	Agencia Maritima Almafitano	t	\N	\N	\N
14275e90-b8b1-433d-98e0-199704dd8dca	CENTAURO 2000	0482	1278	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	35.50	1302	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	PESQUERA VERAZ  S.A.	Mar del Plata		489-4624 / 489-0314 (astillero)	\N		\N	\N		t	\N	\N	\N
7b71e5a8-e128-486e-87c3-2ce7b796c87c	CENTURION DEL ATLANTICO	0237	1280	280a7409-6bb5-4e36-bad1-93194d72bb82	c682a081-0da5-453f-a40a-2b5c1e1600b4	089b0ead-176b-4e7a-b99d-5caeea74ea61	60	112.80	8111	7a9e4185-6281-4c42-b3c4-1980e6855a31	ESTREMAR  S.A.	Ciudad Autónoma de Buenos Aires		011-6533-7853 / 4345-1102	\N		\N	\N		t	\N	\N	\N
8f541238-eba2-44f2-aa54-fc9eac628ccc	CERES	01420	1281	fa86a02c-c6bf-4615-ac50-e6a64cb929bb	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	60	60.74	1969	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	PESQUERA CERES  S.A.	Mar del Plata		410-0051 / 7	\N		\N	\N		t	\N	\N	\N
937a3ca1-4c1a-4651-8c0e-8662f04cc414	CHANG BO GO I	06190	\N	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	\N	\N	7a9e4185-6281-4c42-b3c4-1980e6855a31	ARPEPA  M.C.I.S.A.	Ciudad Autónoma de Buenos Aires		011-4382-1605	\N		\N	\N		t	\N	\N	\N
7e5c7ea4-7796-4b1d-8ec5-17b5ba7bbb85	CHATKA I	02893	0	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	16.73	195	7f1cac29-7e2c-4b6d-8447-1a5a9108fd12	FOOD PARTNERS PATAGONIA S.A.	Puerto Madryn		0280-4458579 / 5225	\N		\N	\N		t	\N	\N	\N
ce5d4fde-77f5-4b4f-b62f-7fd37bb66823	CHIARPESCA 56	01090	\N	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	\N	\N	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	APOLO FISH  S.A.	Mar del Plata		489-4519 / 489-1133	\N		\N	\N		t	\N	\N	\N
ad9310d6-8c28-40e1-beb1-5b15888671c2	CHIARPESCA 57	01029	\N	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	\N	\N	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	CHIARPESCA  S.A.	Mar del Plata		489-1385	\N		\N	\N		t	\N	\N	\N
d750e464-e5d2-497e-9085-280e563cbdb4	CHIARPESCA 902	02110	\N	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	\N	\N	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	CHIARPESCA  S.A.	Mar del Plata		489-1385	\N		\N	\N		t	\N	\N	\N
94ce2ba5-a398-441a-89f9-c5d353741381	CHIARPESCA 903	02109	\N	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	\N	\N	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	CHIARPESCA  S.A.	Mar del Plata		489-1385	\N		\N	\N		t	\N	\N	\N
2336cdf4-d30d-4904-bc30-e0165b221291	CHIYO MARU Nº 3	02987	2745	c7afdae7-d068-45a9-a855-1011df4d2f92	984dfcf6-1b60-40c7-b703-9616ab048651	c2c3c456-5f2c-47a2-a8af-d41dc148a19f	30	52.80	937	7a9e4185-6281-4c42-b3c4-1980e6855a31	CRUSTACEOS DEL SUR  S.A.	Ciudad Autónoma de Buenos Aires		011-5218-4287	\N		\N	\N		t	\N	\N	\N
539a4335-315c-43c7-a50f-4c9146741f4c	CHOCO MARU 68	JA13	\N	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	\N	\N	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	PESQUERA COMERCIAL  S.A.	Mar del Plata		489-3030	\N		\N	\N		t	\N	\N	\N
986a10bd-a765-42a8-81f1-186b41e29adf	CHOKYU MARU Nº 18.	2584	1312	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	68.70	1777	7a9e4185-6281-4c42-b3c4-1980e6855a31	BAHIA GRANDE  S.A.	Ciudad Autónoma de Buenos Aires		011-5272-0850 / 5254-1133	\N		\N	\N		t	\N	\N	\N
75c06740-ab46-4c3b-8039-f5077734a5be	CINCOMAR 1	0439	\N	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	\N	\N	7a9e4185-6281-4c42-b3c4-1980e6855a31	CINCOMAR  S.A.	Ciudad Autónoma de Buenos Aires		011-4326-4991	\N		\N	\N		t	\N	\N	\N
d27d0545-36e4-4eac-abfa-6d06adbc81b7	CINCOMAR 5	02351	\N	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	\N	\N	7a9e4185-6281-4c42-b3c4-1980e6855a31	CINCOMAR  S.A.	Ciudad Autónoma de Buenos Aires		011-4326-4991	\N		\N	\N		t	\N	\N	\N
193187c5-3a8e-45a2-bc6b-f33998538d5a	CIUDAD DE HUELVA	01519	1324	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	27.45	426	7f1cac29-7e2c-4b6d-8447-1a5a9108fd12	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
cdb1e7e2-0a07-4a9d-b616-ebe8b129fd6c	CIUDAD FELIZ	0910	2721	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	28.56	458	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	CARAVON S.A.	Mar del Plata		489-9404	\N		\N	\N		t	\N	\N	\N
f5bc5e4d-948d-49f3-acb2-66b918545fa3	CLAUDIA	02183	\N	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	\N	\N	7a9e4185-6281-4c42-b3c4-1980e6855a31	LUXMARINO  S.A.	Ciudad Autónoma de Buenos Aires		011-4342-2621	\N		\N	\N		t	\N	\N	\N
5fc61514-f3d2-473e-b9ca-f2db55c692b1	CLAUDINA	02345	1331	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	53.58	937	7a9e4185-6281-4c42-b3c4-1980e6855a31	ARMADORA  ACRUX  S.A.	Ciudad Autónoma de Buenos Aires		011-4312-6470	\N		\N	\N		t	\N	\N	\N
59001b96-2509-4062-b02d-ae50570a3df6	COALSA SEGUNDO	0790	1333	fa86a02c-c6bf-4615-ac50-e6a64cb929bb	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	60	76.20	2960	7a9e4185-6281-4c42-b3c4-1980e6855a31	YUKEN  S.A.	Ciudad Autónoma de Buenos Aires		011-5279-1302 / 5236-6069	\N		\N	\N		t	\N	\N	\N
1a158e67-b5a1-4c2a-9e8d-5beb5dea01ed	CODEPECA  I	0497	\N	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	\N	\N	7f1cac29-7e2c-4b6d-8447-1a5a9108fd12	HARENGUS  S.A.	Puerto Madryn		0280-445-0822	\N		\N	\N		t	\N	\N	\N
f8167c77-15a0-45f0-9162-627bb33c697c	CODEPECA  II	0498	\N	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	\N	\N	7f1cac29-7e2c-4b6d-8447-1a5a9108fd12	HARENGUS  S.A.	Puerto Madryn		0280-445-0822	\N		\N	\N		t	\N	\N	\N
679f5e21-f1be-428d-9464-d8d2c7e7c7d5	CODEPECA  III	0506	\N	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	\N	\N	7f1cac29-7e2c-4b6d-8447-1a5a9108fd12	HARENGUS  S.A.	Puerto Madryn		0280-445-0822	\N		\N	\N		t	\N	\N	\N
50846fb4-632a-43d0-96a1-3bff2d58a548	CODEPECA IV	01012	\N	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	\N	\N	7f1cac29-7e2c-4b6d-8447-1a5a9108fd12	PEREIRA  ARGENTINA  S.A.	Puerto Madryn		0280-445-7377 / 447-2249	\N		\N	\N		t	\N	\N	\N
1fbe20ae-5c98-4c26-9e05-41e92f7f6813	COMANDANTE LUIS PIEDRABUENA	0767	1340	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	25.00	501	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	COMANDANTE PIEDRABUENA  S.R.L.	Mar del Plata		489-9404	\N		\N	\N		t	\N	\N	\N
6c28a36d-c0bd-48c5-9375-e9bfdf9ca1a2	COMETA	0919	\N	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	\N	\N	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	VICARP  S.A.	Mar del Plata		480-4378	\N		\N	\N		t	\N	\N	\N
f87d433e-da5f-4b0f-8649-adc99953cd06	CONARA I	0201	\N	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	\N	\N	7f1cac29-7e2c-4b6d-8447-1a5a9108fd12	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
e37370d2-09b3-4af8-bdb0-b2820e53e0f7	CONARPESA I	0200	1344	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	52.50	1482	7f1cac29-7e2c-4b6d-8447-1a5a9108fd12	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
63479c40-76f8-4d3f-a287-acf82c783eec	CORAJE	0645	1359	\N	\N	\N	0	28.28	426	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	IBERCONSA  DE ARGENTINA  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
62e0f197-20e7-41b6-b99d-54236c17de79	CORAL  AZUL	06127	\N	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	\N	\N	7a9e4185-6281-4c42-b3c4-1980e6855a31	NOVAMAR  S.A.	Ciudad Autónoma de Buenos Aires		011-4345-6688	\N		\N	\N		t	\N	\N	\N
37c28f08-dfed-48f6-b265-d4fd4404f298	CORAL BLANCO	06137	\N	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	\N	\N	7a9e4185-6281-4c42-b3c4-1980e6855a31	NOVAMAR  S.A.	Ciudad Autónoma de Buenos Aires		011-4345-6688	\N		\N	\N		t	\N	\N	\N
15619ef4-33f8-42fe-b48a-e133dbaaf59a	CORMORAN	01611	\N	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	\N	\N	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	ANTONIO BARILLARI  S.A.	Mar del Plata		481-1173  / 489-0872	\N		\N	\N		t	\N	\N	\N
7e5d754b-c6a6-41c5-a23f-26b17b289f13	COSTAMAR	01549	\N	907fd6b2-95a4-42bf-856e-a9b0d99402ea	c682a081-0da5-453f-a40a-2b5c1e1600b4	\N	4	\N	\N	a39428a8-f7d6-4716-9c31-99556bfb37f3	INDUSTRIA  PESQUERA  PATAGONICA  S.A.	Trelew		0280-444-6577	\N		\N	\N		t	\N	\N	\N
88d93b71-20f1-49bf-88fa-a4a99f142769	CRISTO REDENTOR	01185	1374	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	31.00	642	9e97a6b3-cca1-4931-92e9-ab8a5e0b35e1	PESQUERA DESEADO  S.A.	Puerto Deseado		0297-487-0884 / 0327 / 2407	\N		\N	\N		t	\N	\N	\N
fd40bb2d-9465-46ff-91e1-7ed0c528c43d	DASA 508	0499	\N	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	\N	\N	7a9e4185-6281-4c42-b3c4-1980e6855a31	PESQUERA  DONGAH  ARGENTINA  S.A.	Ciudad Autónoma de Buenos Aires		011-4815-5525	\N		\N	\N		t	\N	\N	\N
e3275223-133f-4184-83f8-dccdc32381a5	DASA 757	02200	\N	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	\N	\N	7a9e4185-6281-4c42-b3c4-1980e6855a31	PESQUERA  DONGAH  ARGENTINA  S.A.	Ciudad Autónoma de Buenos Aires		011-4815-5525	\N		\N	\N		t	\N	\N	\N
03fd86d8-d69a-4aed-a8e1-f6cb7e678263	DEMOSTENES	0113	\N	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	\N	\N	7a9e4185-6281-4c42-b3c4-1980e6855a31	AGUA MARINA  S.A.	Ciudad Autónoma de Buenos Aires		011-4342-0605 / 5656 / 1709	\N		\N	\N		t	\N	\N	\N
fd9910c1-4b10-4fcc-a988-b0796c8905e2	DESTINY	3209	\N	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	\N	\N	\N	WANCHESE ARGENTINA  S.A.				\N		\N	\N		t	\N	\N	\N
456001df-3a4f-4fa8-aec8-2c17c9e6051e	DEPASUR  I	0330	\N	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	\N	\N	7f1cac29-7e2c-4b6d-8447-1a5a9108fd12	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
77528481-a4be-4d80-b33d-ffb9718aeed2	DEPEMAS 51	0239	\N	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	\N	\N	7a9e4185-6281-4c42-b3c4-1980e6855a31	DEPEMAS  S.A.	Ciudad Autónoma de Buenos Aires		011-4372-7909  /  4382-5382	\N		\N	\N		t	\N	\N	\N
f54335a2-6580-4b4e-91d4-28c31f9a2b6c	DEPEMAS 81	0281	\N	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	\N	\N	7a9e4185-6281-4c42-b3c4-1980e6855a31	PESQUERA ORION  S.A.	Ciudad Autónoma de Buenos Aires		011-4343-9327	\N		\N	\N		t	\N	\N	\N
ae43f195-47a8-4c22-8e9c-209b3cc84f94	DESAFIO	0177	1398	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	29.56	850	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	PESQUERA VERAZ  S.A.	Mar del Plata		489-4624 / 489-0314 (astillero)	\N		\N	\N		t	\N	\N	\N
7b2fdcdf-e572-469b-a82d-59bf0eaffded	DESEADO	01598	1400	907fd6b2-95a4-42bf-856e-a9b0d99402ea	c682a081-0da5-453f-a40a-2b5c1e1600b4	\N	4	19.00	301	a39428a8-f7d6-4716-9c31-99556bfb37f3	FLOTA AMARILLA RAWSON	Rawson			\N		\N	\N		t	\N	\N	\N
a75c09c4-fb68-4b51-960e-fc155b4a5111	DIEGO PRIMERO	01725	\N	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	\N	\N	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	PESQUERA DIEGO PRIMERO  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
244e66f9-5800-48f1-92a5-12093f5cb1bd	DON JUAN ALVAREZ	3300	\N	4f3ed669-a05f-4bd4-a8be-bfb4f88b54d9	c682a081-0da5-453f-a40a-2b5c1e1600b4	\N	\N	\N	\N	\N	CONARPESA  S.A.				\N		\N	\N		t	\N	\N	\N
b25198dd-c867-47d4-867e-2a675e3c993d	DON  NATALIO	01183	\N	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	\N	\N	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	14 DE JULIO  S.A.	Mar del Plata		480-3545	\N		\N	\N		t	\N	\N	\N
6ba4685e-8ef4-49de-be02-e084102c8d03	DON AGUSTIN	0968	\N	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	\N	\N	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	PESQUERA  MARGARITA  S.A.	Mar del Plata		489-4645   /   489-2946	\N		\N	\N		t	\N	\N	\N
37822c48-471e-4471-ab0d-d9c71486f023	DON ANTONIO	0029	1411	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	27.80	549	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	GIORNO  S.A.	Mar del Plata		410-0051 / 0057	\N		\N	\N		t	\N	\N	\N
1d60bf80-a79a-49d3-80c1-20a6fbc06467	DON CARMELO	01320	1416	907fd6b2-95a4-42bf-856e-a9b0d99402ea	c682a081-0da5-453f-a40a-2b5c1e1600b4	\N	8	19.04	424	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	MARFE  S.A.	Mar del Plata	4800005	480-0102	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
589ffb1b-a535-45e8-be79-4a17face2de8	DON CAYETANO	0579	1417	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	47.10	1503	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	PEDRO MOSCUZZA e HIJOS  S.A.	Mar del Plata	4890960	489-7287	\N	agencia@maritimavidal.com.ar	\N	\N	Agencia Maritima Vidal	t	\N	\N	\N
117d9278-5d1d-42db-a2cd-f93c245e53c7	DON FRANCISCO I	2562	1428	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	66.55	1776	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	EL MARISCO  S.A.	Mar del Plata	480-7779 - HERNAN	489-0384	\N	agenciasenoransmdp@yahoo.com	\N	\N	Agencia Maritima SEÑORANS	t	\N	\N	\N
636329bd-79bb-4470-bcc9-cb7a6c39be83	DON GAETANO	071	1430	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	32.10	889	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	LINEAERRE  S.A.	Mar del Plata		480-0312	\N		\N	\N		t	\N	\N	\N
1775ecb2-544d-4847-8427-fc21db9707a4	DON GIULIANO	02025	1431	907fd6b2-95a4-42bf-856e-a9b0d99402ea	c682a081-0da5-453f-a40a-2b5c1e1600b4	\N	4	17.10	220	a39428a8-f7d6-4716-9c31-99556bfb37f3	FLOTA AMARILLA RAWSON	Rawson			\N		\N	\N		t	\N	\N	\N
d9d54a94-e4bf-4c40-b1e4-11339acb9c56	DON JOSE	00892	1434	907fd6b2-95a4-42bf-856e-a9b0d99402ea	c682a081-0da5-453f-a40a-2b5c1e1600b4	\N	8	16.49	269	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	VENTO DI TERRA  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
041e26dd-ebb2-4990-a53a-45eeee8c6b24	DON JOSE DI BONA	02241	1435	907fd6b2-95a4-42bf-856e-a9b0d99402ea	c682a081-0da5-453f-a40a-2b5c1e1600b4	\N	4	19.85	301	a39428a8-f7d6-4716-9c31-99556bfb37f3	PROA  AL SUR  S.R.L.	Rawson			\N		\N	\N		t	\N	\N	\N
dfd47c23-77d0-42cc-9cad-4d947c4471d1	DON JUAN	01397	1437	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	27.00	425	\N	PESQUERA DON JUAN  S.A.				\N		\N	\N		t	\N	\N	\N
b556bb28-444c-4326-bbbe-20a96f192543	DON JUAN D´AMBRA	5174	\N	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	\N	\N	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	PESCA ANGELA  S.A.	Mar del Plata		626-2236 /37	\N		\N	\N		t	\N	\N	\N
5de5ec16-4035-4f70-b008-7fc980e22fec	DON LUCIANO	069	\N	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	\N	\N	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	TATURIELLO  S.A.	Mar del Plata		489-3833	\N		\N	\N		t	\N	\N	\N
faa23ec7-3f06-44ab-beaa-f730e9f5f4b1	DON LUIS I	02093	1445	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	67.95	1803	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	PESQUERA CERES  S.A.	Mar del Plata		410-0051 / 7	\N		\N	\N		t	\N	\N	\N
d4e1f51a-ae76-47c9-8fd0-bd0ec6e4fdb4	DON MIGUEL 1°	0748	\N	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	\N	\N	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	PESQUERA EL NAZARENO	Mar del Plata	4895032 Emanuel	489-9414 (of. Pers. Emb.)	\N	operacionesconsultoramaritima@gmail.com	\N	\N	Consultora Maritima Merlini	t	\N	\N	\N
0fd36e05-9989-4391-abfe-8d56e6a35f26	DON NICOLA	0893	1450	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	28.14	856	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	PEZ ESPADA  S.A.	Mar del Plata		480-0846	\N		\N	\N		t	\N	\N	\N
21ca6d2c-0139-4b6b-83ed-65106155787e	DON OSCAR	02184	\N	907fd6b2-95a4-42bf-856e-a9b0d99402ea	c682a081-0da5-453f-a40a-2b5c1e1600b4	\N	4	\N	\N	a39428a8-f7d6-4716-9c31-99556bfb37f3	FLOTA AMARILLA RAWSON	Rawson	4800005		\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
e651d472-1996-4202-9306-3798541fe779	DON PEDRO	068	\N	fa86a02c-c6bf-4615-ac50-e6a64cb929bb	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	60	\N	\N	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	PEDRO MOSCUZZA e HIJOS  S.A.	Mar del Plata		489-7287	\N		\N	\N		t	\N	\N	\N
39c579f4-2feb-4888-b135-47f97bd53492	DON RAIMUNDO	01431	1463	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	10	25.60	624	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	DON RAIMUNDO S.R.L.	Mar del Plata		489-3780	\N		\N	\N		t	\N	\N	\N
8dae5ce8-8d22-4993-ad4b-6d150777b183	DON ROMEO ERSINI	0972	\N	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	\N	\N	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	PESQUERA  MARGARITA  S.A.	Mar del Plata	4891553-154179360-154179860-154179062	489-4645   /   489-2946	\N	agenciasmiriglio@speedy.com.ar	\N	\N	Agencia Smiriglio	t	\N	\N	\N
0ac8253a-9566-40dc-ab44-e1ae7e2ba043	DON SANTIAGO	01733	1467	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	10	26.55	776	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	SAN JORGE S.A.	Mar del Plata		480-6611	\N		\N	\N		t	\N	\N	\N
f706e5d3-0a5b-4a47-a019-8ccc5ba57c3b	DON TOMASSO	02310	1468	907fd6b2-95a4-42bf-856e-a9b0d99402ea	c682a081-0da5-453f-a40a-2b5c1e1600b4	\N	4	17.00	356	a39428a8-f7d6-4716-9c31-99556bfb37f3	FLOTA AMARILLA RAWSON	Rawson			\N		\N	\N		t	\N	\N	\N
edc87a09-da44-4c68-a2ac-8737a3625456	DON TURI	01540	1470	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	28.62	839	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	DON TURI  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
de97eb2f-0a9b-41e0-8d3a-1a6e565bf5f7	DON VICENTE VUOSO	0539	1474	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	20.69	537	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	VUOSO HNOS. S.R.L.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
cdff3f13-e36f-4f18-9bb8-04da65b9b250	DOÑA ALFIA	0512	1483	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	20.70	426	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	ANTONIO BARILLARI  S.A.	Mar del Plata		481-1173  / 489-0872	\N		\N	\N		t	\N	\N	\N
9e877cfc-1700-4d04-823e-fd45934bc610	Dr. EDUARDO L. HOLMBERG	061F	\N	a5778547-a20e-4929-a1a6-c0aab7f0466c	\N	\N	24	\N	\N	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	INIDEP	Mar del Plata		451-7442 ó 486-2586 int 162	\N		\N	\N		t	\N	\N	\N
7a4a43c8-4078-4f8e-b0a5-90f8de5d9acd	DUKAT	02775	2712	c7afdae7-d068-45a9-a855-1011df4d2f92	984dfcf6-1b60-40c7-b703-9616ab048651	c2c3c456-5f2c-47a2-a8af-d41dc148a19f	30	50.80	1302	7a9e4185-6281-4c42-b3c4-1980e6855a31	CRUSTACEOS DEL SUR  S.A.	Ciudad Autónoma de Buenos Aires		011-5218-4287	\N		\N	\N		t	\N	\N	\N
a627c1b9-5116-41fc-b360-0c73f5d18184	ECHIZEN MARU	0326	1495	280a7409-6bb5-4e36-bad1-93194d72bb82	c682a081-0da5-453f-a40a-2b5c1e1600b4	089b0ead-176b-4e7a-b99d-5caeea74ea61	60	89.59	4702	a269cdaa-b6a8-4b05-b44a-042cd68106e4	PESANTAR  S.A. ( Empresa Pesq de la Patagonia y Antartida )	Ushuaia		02901-43-3449 / 43-0008 / 43-0708	\N		\N	\N		t	\N	\N	\N
16b8aed4-fa04-4f8b-b6d8-5284c84e0ca5	EL MALO I	02350	\N	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	4	\N	\N	a39428a8-f7d6-4716-9c31-99556bfb37f3	NOGALES NOGALES  S. De HECHO	Rawson	4890960		\N	agencia@maritimavidal.com.ar	\N	\N	Agencia Maritima Vidal	t	\N	\N	\N
529fb8dd-7d6f-4458-885f-100636d1ca0c	EL MARISCO I	0912	1516	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	27.22	426	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	EL MARISCO  S.A.	Mar del Plata	4890960	489-0384	\N	agencia@maritimavidal.com.ar	\N	\N	Agencia Maritima Vidal	t	\N	\N	\N
f6ab2a3d-cc76-4007-84b5-59eca92bc039	EL MARISCO II	0915	1517	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	56.30	1407	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	EL MARISCO  S.A.	Mar del Plata		489-0384	\N		\N	\N		t	\N	\N	\N
406d2b45-b71a-4c63-af57-3a19cdca9ef8	EL SANTO	05970	\N	907fd6b2-95a4-42bf-856e-a9b0d99402ea	c682a081-0da5-453f-a40a-2b5c1e1600b4	\N	0	\N	\N	9e97a6b3-cca1-4931-92e9-ab8a5e0b35e1	VUOGAFE  S.A.	Puerto Deseado		0297-155-940853	\N		\N	\N		t	\N	\N	\N
c402a9fa-e4c9-4f32-9d94-b42c67cbc04d	EMILIA MARIA	01390	1543	907fd6b2-95a4-42bf-856e-a9b0d99402ea	c682a081-0da5-453f-a40a-2b5c1e1600b4	\N	10	22.60	521	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	COSTA BRAVA  S.A.	Mar del Plata		489-7538	\N		\N	\N		t	\N	\N	\N
d6a95b33-17ab-40cc-a5f7-0f334ce3031e	EMPESUR II	01439	\N	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	\N	\N	7a9e4185-6281-4c42-b3c4-1980e6855a31	EMPESUR  S.A.	Ciudad Autónoma de Buenos Aires		011-4312-0123	\N		\N	\N		t	\N	\N	\N
9baed9dc-4ee0-431c-84ff-68c8be0a647d	EMPESUR III	01438	\N	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	\N	\N	7a9e4185-6281-4c42-b3c4-1980e6855a31	EMPESUR  S.A.	Ciudad Autónoma de Buenos Aires		011-4312-0123	\N		\N	\N		t	\N	\N	\N
3ba16634-23ea-4140-920a-83b702b70c1d	EMPESUR V	02650	2705	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	30.52	1369	7a9e4185-6281-4c42-b3c4-1980e6855a31	EMPESUR  S.A.	Ciudad Autónoma de Buenos Aires		011-4312-0123	\N		\N	\N		t	\N	\N	\N
c71a0516-8965-4c80-8b66-ee77f14aa93c	EMPESUR VI	02983	2749	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	35.03	1289	7a9e4185-6281-4c42-b3c4-1980e6855a31	EMPESUR  S.A.	Ciudad Autónoma de Buenos Aires		011-4312-0123	\N		\N	\N		t	\N	\N	\N
a7d709fd-509a-4807-ba09-7ac5371e16c7	EMPESUR VII	03045	2754	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	35.03	1290	7a9e4185-6281-4c42-b3c4-1980e6855a31	EMPESUR  S.A.	Ciudad Autónoma de Buenos Aires		011-4312-0123	\N		\N	\N		t	\N	\N	\N
57b4704b-edf3-41de-8417-892ba98c647d	El marisco s.a	02070	\N	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	\N	\N	7f1cac29-7e2c-4b6d-8447-1a5a9108fd12	FISHING WORLD  S.A.	Puerto Madryn	4800005	0280-445-6533	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
5c866b92-ca59-4e94-a0fb-99acd7af414f	ENTRENA UNO	02069	1551	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	33.10	839	7a9e4185-6281-4c42-b3c4-1980e6855a31	FOOD ARTS  S.A.	Ciudad Autónoma de Buenos Aires		POR MAILlazuaje@foodarts.com.ar	\N		\N	\N		t	\N	\N	\N
5e59c060-006b-46fa-bd3b-6a97a9a0c038	ERIN BRUCE	0537	1553	fc8c8ee3-01dd-40b0-96f2-6b99a6643f7b	e0913412-884d-4103-97b7-3eceac842fcf	7bfb912c-3ee4-426e-a976-68bbbf6bc1d4	30	53.60	2252	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	WANCHESE ARGENTINA  S.A.	Mar del Plata		489-1236	\N		\N	\N		t	\N	\N	\N
dff0c01d-8ae6-4b3c-a2a1-84be475e6107	ERIN BRUCE II	TEMP-0002	\N	fc8c8ee3-01dd-40b0-96f2-6b99a6643f7b	e0913412-884d-4103-97b7-3eceac842fcf	7bfb912c-3ee4-426e-a976-68bbbf6bc1d4	\N	\N	\N	\N					\N		\N	\N		t	\N	\N	\N
300bccb8-3199-4cf1-b2a2-7e6cc5dbb571	ESAMAR N° 4	0467	\N	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	\N	\N	7a9e4185-6281-4c42-b3c4-1980e6855a31	ESAMAR  S.A.	Ciudad Autónoma de Buenos Aires		011-4393-8431	\N		\N	\N		t	\N	\N	\N
e39c9622-9a2b-4dd6-9447-722d549018cd	ESPADARTE	02048	1558	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	68.20	1529	9e97a6b3-cca1-4931-92e9-ab8a5e0b35e1	PESQUERA DESEADO  S.A.	Puerto Deseado		0297-487-0884 / 0327 / 2407	\N		\N	\N		t	\N	\N	\N
534716d9-818f-4b0b-a39d-c97b28056ee9	ESPERANZA 909	02577	1559	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	72.34	1678	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	CHIARPESCA  S.A.	Mar del Plata		489-1385	\N		\N	\N		t	\N	\N	\N
fb8c7656-59a5-45e8-8edf-a3efe672def6	ESPERANZA DEL SUR	02751	\N	84e1586f-ab60-4e9c-93e6-bc73183f8b27	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	60	\N	\N	a269cdaa-b6a8-4b05-b44a-042cd68106e4	PESANTAR  S.A. ( Empresa Pesq de la Patagonia y Antartida )	Ushuaia		02901-43-3449 / 43-0008 / 43-0708	\N		\N	\N		t	\N	\N	\N
a50d09c7-b62a-4b75-9f75-58a63370d074	ESPERANZA DOS	06264	\N	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	\N	\N	7a9e4185-6281-4c42-b3c4-1980e6855a31	ESPERANZA DEL MAR  S.A.	Ciudad Autónoma de Buenos Aires		011-4328-8696	\N		\N	\N		t	\N	\N	\N
e7070d7a-fc25-4964-9a5f-13425d093cbe	ESPERANZA UNO	06113	\N	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	\N	\N	7a9e4185-6281-4c42-b3c4-1980e6855a31	ESPERANZA DEL MAR  S.A.	Ciudad Autónoma de Buenos Aires		011-4328-8696	\N		\N	\N		t	\N	\N	\N
2362a20d-d8d1-455d-ba57-f85565f8c11e	ESTEFANY	001	1565	907fd6b2-95a4-42bf-856e-a9b0d99402ea	c682a081-0da5-453f-a40a-2b5c1e1600b4	\N	15	23.60	530	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	GIORNO  S.A.	Mar del Plata		410-0051 / 0057	\N		\N	\N		t	\N	\N	\N
4f6afbf0-d5ac-4452-b1f1-994969906f33	ESTEIRO	6328	\N	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	\N	\N	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	BALDIMAR  S.A.	Mar del Plata		489-6522	\N		\N	\N		t	\N	\N	\N
7503c9bc-628b-41a4-992d-6c9b53de5d23	ESTHER 153	02058	1568	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	55.10	1252	7a9e4185-6281-4c42-b3c4-1980e6855a31	ARPEPA  M.C.I.S.A.	Ciudad Autónoma de Buenos Aires		011-4382-1605	\N		\N	\N		t	\N	\N	\N
22bb8a97-6e69-45b9-8d84-775456ad5c5f	ESTRELLA N° 5	0246	1575	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	54.20	1601	7a9e4185-6281-4c42-b3c4-1980e6855a31	HANSUNG AR  S.A.	Ciudad Autónoma de Buenos Aires		011-4816-2022	\N		\N	\N		t	\N	\N	\N
8de6b43c-c2f7-42dd-b91a-ddb68a3e6846	ESTRELLA N° 6	012	1576	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	55.85	1581	7a9e4185-6281-4c42-b3c4-1980e6855a31	HANSUNG AR  S.A.	Ciudad Autónoma de Buenos Aires		011-4816-2022	\N		\N	\N		t	\N	\N	\N
ef1217c6-f081-4444-9a64-838524c4af29	ESTRELLA N° 8	0242	\N	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	\N	\N	7a9e4185-6281-4c42-b3c4-1980e6855a31	HANSUNG AR  S.A.	Ciudad Autónoma de Buenos Aires		011-4816-2022	\N		\N	\N		t	\N	\N	\N
5958d5c6-0f89-463c-93d0-a20c674c72fd	FE EN PESCA	0226	\N	\N	\N	\N	0	\N	\N	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	ASARO HNOS.  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
0bfe5c2a-0884-47cd-b502-516696b94cd4	FEDERICO C	3190	2776	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	\N	37.68	1400	\N	PESQUERA VERAZ  S.A.				\N		\N	\N		t	\N	\N	\N
85b081e9-ca84-439a-a7c6-85f482796972	FEIXA	0529	1592	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	41.50	1101	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	ANTONIO BARILLARI  S.A.	Mar del Plata		481-1173  / 489-0872	\N		\N	\N		t	\N	\N	\N
ba7ccf06-d5a2-4fc4-b02a-19a463fa8a37	FELIX AUGUSTO	0581	1595	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	27.80	601	7f1cac29-7e2c-4b6d-8447-1a5a9108fd12	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
618fc8f2-33ca-4a58-8731-7efdd4a43243	FERNANDO ALVAREZ	0013	1597	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	36.60	1168	7f1cac29-7e2c-4b6d-8447-1a5a9108fd12	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
329f4edd-2ce9-4924-9f1b-5663e9c2dff7	FLORIDABLANCA	0969	1606	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	27.67	541	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	DESAFIO  S.A.	Mar del Plata		489-4788 / 3659	\N		\N	\N		t	\N	\N	\N
7a1baa82-68f2-4b7c-b601-708d67eb51ba	FLORIDABLANCA II	0252	\N	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	\N	\N	7f1cac29-7e2c-4b6d-8447-1a5a9108fd12	PESQUERA SAN ISIDRO S.A.	Puerto Madryn		0280-447-2697	\N		\N	\N		t	\N	\N	\N
25e0aeb9-b32d-402e-9ae5-6f131d622bf5	FLORIDABLANCA IV	0255	\N	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	\N	\N	260e778c-d7a5-4509-938b-9bd69004656f	MARITIMA MONACHESI  S.A.	Bahia Blanca		0291-452-5913	\N		\N	\N		t	\N	\N	\N
4f873d85-6724-481a-bcc3-de4778b19051	FONSECA	0920	1610	fa86a02c-c6bf-4615-ac50-e6a64cb929bb	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	60	62.40	2003	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	FONSECA  S.A.	Mar del Plata	4891553-154179360-154179860-154179062	489-4645	\N	agenciasmiriglio@speedy.com.ar	\N	\N	Agencia Maritima Smiriglio	t	\N	\N	\N
d65f544b-de1d-4bee-a470-45f1e8bd77d7	FRANCA	0495	1612	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	27.29	493	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	AUGUSTA MEGARA  S.A.	Mar del Plata		480-2260	\N		\N	\N		t	\N	\N	\N
fac9a47a-46a6-4c5d-86d3-6ffe0f1e6a6a	FRANCO	01458	\N	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	\N	\N	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	FRIGORIFICO DON LUIS  S.R.L.	Mar del Plata		489-4645	\N		\N	\N		t	\N	\N	\N
f86ac80f-75c6-48d1-9486-7e35427997bf	FU YUAN YU 636	02195	\N	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	\N	\N	7a9e4185-6281-4c42-b3c4-1980e6855a31	BAHIA GRANDE  S.A.	Ciudad Autónoma de Buenos Aires		011-5272-0850 / 5254-1133	\N		\N	\N		t	\N	\N	\N
f8b5fbc3-3ecd-44c2-9002-b89c983939d2	FUEGUINO I	0331	\N	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	\N	\N	7f1cac29-7e2c-4b6d-8447-1a5a9108fd12	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
19124c62-50f6-4908-a5c5-f7cb6f43accd	GALA	02722	0	907fd6b2-95a4-42bf-856e-a9b0d99402ea	c682a081-0da5-453f-a40a-2b5c1e1600b4	\N	15	15.20	256	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	DISTRIBUIDORA MARECHIARE S.R.L.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
2b763c2a-f2b0-4a38-8e36-86a637a69a1f	GALEMAR	0904	\N	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	\N	\N	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	ANTONIO BARILLARI  S.A.	Mar del Plata		481-1173  / 489-0872	\N		\N	\N		t	\N	\N	\N
19dafb33-1db0-4d64-9175-b294d92ffd7f	GAUCHO GRANDE	0339	1642	\N	\N	\N	30	27.64	0	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	VICARP  S.A.	Mar del Plata	4890960	480-4378	\N	agencia@maritimavidal.com.ar	\N	\N	Agencia Maritima Vidal	t	\N	\N	\N
f9b08767-3d42-493b-9603-364ffc399a34	GEMINIS	01421	1643	fa86a02c-c6bf-4615-ac50-e6a64cb929bb	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	60	68.90	2141	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	PESQUERA GEMINIS  S.A.	Mar del Plata		410-0051 / 7	\N		\N	\N		t	\N	\N	\N
2f9cdbb5-17b9-4ee4-8431-c5260cade2f0	GIANFRANCO	01075	\N	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	\N	\N	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	PIEA  S.A.	Mar del Plata		489-6317 /489-1367	\N		\N	\N		t	\N	\N	\N
0ac4da9e-893b-4941-b544-4b811d3a5090	GIULIANA	02633	\N	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	\N	\N	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	PESQUERA  MARGARITA  S.A.	Mar del Plata		489-4645   /   489-2946	\N		\N	\N		t	\N	\N	\N
2759313c-e28d-42b3-b4f5-232222fb51e7	GLORIA DEL MAR I	01983	1651	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	54.30	1600	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	PESQUERA  DEL  ESTE  S.A.	Mar del Plata	4800005	489-1567	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
03e57d9c-50a2-4bcb-b782-b4cd497eacf5	GRACIELA	0578	\N	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	\N	\N	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	PEDRO MOSCUZZA e HIJOS  S.A.	Mar del Plata		489-7287	\N		\N	\N		t	\N	\N	\N
4b4f7296-55c4-47b4-8cd4-c77af9a1ef45	GRACIELA I	3994	2765	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	39.94	0	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	PEDRO MOSCUZZA e HIJOS  S.A.	Mar del Plata		489-7287	\N		\N	\N		t	\N	\N	\N
d67f3fbc-d48d-4ce6-aea6-e045775ab736	GRAN CAPITAN	01538	1656	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	25.43	541	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	ORTIGIA  S.A.	Mar del Plata		489-2679	\N		\N	\N		t	\N	\N	\N
876dccba-5c2e-43cb-b733-c6211926f660	GURISES	01386	1667	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	25.20	546	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	A.B.H. PESQUERA  S.A.	Mar del Plata		489-6522	\N		\N	\N		t	\N	\N	\N
dc883e49-ff66-4430-9753-c4621536ea1e	GUSTAVO R	0075	\N	fa86a02c-c6bf-4615-ac50-e6a64cb929bb	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	60	\N	\N	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	ARGEMER  S.A.	Mar del Plata		451-1247	\N		\N	\N		t	\N	\N	\N
8e31bf5a-c3f8-47b5-89a7-513389bf7d69	HAMAZEN MARU N° 68	JA05	\N	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	\N	\N	7a9e4185-6281-4c42-b3c4-1980e6855a31	PESQUERA SANTA CRUZ  S.A.	Ciudad Autónoma de Buenos Aires		011-4305-4706	\N		\N	\N		t	\N	\N	\N
54be47ba-ad1e-4958-9c58-223d71a574da	HAMPON	01410	1673	907fd6b2-95a4-42bf-856e-a9b0d99402ea	c682a081-0da5-453f-a40a-2b5c1e1600b4	\N	10	18.99	497	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	PESQUERA HAMPON S.R.L	Mar del Plata			\N		\N	\N		t	\N	\N	\N
88d4d03c-84b1-4170-8db8-ce5d69725f57	HARENGUS	0510	\N	fa86a02c-c6bf-4615-ac50-e6a64cb929bb	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	60	\N	\N	7f1cac29-7e2c-4b6d-8447-1a5a9108fd12	HARENGUS  S.A.	Puerto Madryn		0280-445-0822	\N		\N	\N		t	\N	\N	\N
287a2eb7-4907-4368-9bc0-79e8303e6a2b	HOKO 31	05934	\N	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	\N	\N	7a9e4185-6281-4c42-b3c4-1980e6855a31	FARO DEL SUR TRADING  S.A.	Ciudad Autónoma de Buenos Aires		011-4555-4956	\N		\N	\N		t	\N	\N	\N
07fe9702-4930-406d-b193-0cae4659fca2	HOPE N°7	06130	1690	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	50.60	1235	7a9e4185-6281-4c42-b3c4-1980e6855a31	ALUNAMAR  S.A.	Ciudad Autónoma de Buenos Aires	4808331/4808332	011-4382-4194	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
9ae66c80-611f-428f-a218-759124429f23	HOYO MARU 37	JA01	\N	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	\N	\N	9e97a6b3-cca1-4931-92e9-ab8a5e0b35e1	ARGENOVA  S.A.	Puerto Deseado		0297- 487-0550  (447-2818  Com. Riv )	\N		\N	\N		t	\N	\N	\N
093c3466-dac7-4e30-b8bd-713e8cd8b807	HSIANG LAI FU	80	\N	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	\N	\N	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	EL MARISCO  S.A.	Mar del Plata		489-0384	\N		\N	\N		t	\N	\N	\N
6d430cc1-8ec0-4e4a-b68b-facb3798d18d	HUYU 961	TEMP-0003	0	\N	\N	\N	\N	65.70	0	\N					\N		\N	\N		t	\N	\N	\N
b9cc9ddf-c507-4bdf-97d8-96eb080f205b	HUYU 962	03056	0	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	65.60	0	7f1cac29-7e2c-4b6d-8447-1a5a9108fd12	ALTAMARE  S.A.	Puerto Madryn		0280-445-7377 / 447-2249	\N		\N	\N		t	\N	\N	\N
483187a2-1dba-4dc8-aafe-b339a5512e3a	HUYU 906	03026	2747	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	65.92	1579	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	CHENG I  S.A.	Mar del Plata		489-1385	\N		\N	\N		t	\N	\N	\N
c8865984-3c97-40ca-8fd6-2b61d1b70aa2	HUYU 907	03027	2748	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	72.17	1678	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	CHENG I  S.A.	Mar del Plata	4800005	489-1385	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
e11e197f-fa96-496f-89f7-3a3be33e66ed	HU YU 910	81	\N	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	\N	\N	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	PEDRO MOSCUZZA e HIJOS  S.A.	Mar del Plata		489-7287	\N		\N	\N		t	\N	\N	\N
f4829a7e-b8e4-485a-9079-9e3560c31114	HUAFENG 801	3013	2741	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	65.04	1973	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	ARDAPEZ  S.A.	Mar del Plata		480-1561 / 480-1568 / 480-1549	\N		\N	\N		t	\N	\N	\N
16c031ac-315c-43ee-8481-0570dcddedd5	HUAFENG 802	3014	2751	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	65.04	1973	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	ARDAPEZ  S.A.	Mar del Plata		480-1561 / 480-1568 / 480-1549	\N		\N	\N		t	\N	\N	\N
f4e8e310-2bbb-42a8-b3be-65521a05f4f3	HUA I 616	0392	\N	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	\N	\N	7a9e4185-6281-4c42-b3c4-1980e6855a31	ARMADORA  ACRUX  S.A.	Ciudad Autónoma de Buenos Aires		011-4312-6470	\N		\N	\N		t	\N	\N	\N
8c025ec8-007d-4f69-9c6a-c72c502da36e	HUAFENG 815	0554A	0	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	25.28	419	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	PESQUERA CHIARMAR S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
bdf1eaab-a59e-4633-94cd-c715355754e2	HUAFENG 820 (ex INFINITUS PEZ)	01472A	\N	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	\N	\N	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	MELIMAR S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
f5584843-0c82-40e6-af61-279007e332f2	HUAFENG 821 (ex INITIO PEZ)	01471A	\N	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	\N	\N	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	MELIMAR S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
6f01388c-dde8-4240-8c96-16bb3521397d	IARA	06207	\N	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	\N	\N	7a9e4185-6281-4c42-b3c4-1980e6855a31	PESQUERA MADRYN  S.A.	Ciudad Autónoma de Buenos Aires		011-4394-1452	\N		\N	\N		t	\N	\N	\N
92e384f1-b6bd-4007-bdc3-8856d097b05f	IGLU I	01423	1713	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	32.75	660	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	GIORNO  S.A.	Mar del Plata		410-0051 / 0057	\N		\N	\N		t	\N	\N	\N
820e6759-46cf-4971-9229-9f25da477dea	ILLEX I	125	\N	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	\N	\N	7a9e4185-6281-4c42-b3c4-1980e6855a31	ILLEX  S.A.	Ciudad Autónoma de Buenos Aires	4808331/4808332	011-4393-6431	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
c19a5b7f-5182-40ba-8ca9-c2ccb64f87a2	INARI MARU N° 25	0261	\N	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	\N	\N	9e97a6b3-cca1-4931-92e9-ab8a5e0b35e1	ARGENOVA  S.A.	Puerto Deseado		0297- 487-0550  (447-2818  Com. Riv )	\N		\N	\N		t	\N	\N	\N
19194df2-6c1b-4def-abed-adff585700f1	INFINITUS PEZ	01472	\N	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	\N	\N	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	GIORNO  S.A.	Mar del Plata		410-0051 / 0057	\N		\N	\N		t	\N	\N	\N
40e9767c-8cf6-4e4d-8b98-59bc67fd0f1f	INITIO PEZ	01471	\N	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	\N	\N	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	GIORNO  S.A.	Mar del Plata	4800005	410-0051 / 0057	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi	t	\N	\N	\N
de5883d2-e98c-4e44-b04d-9bc95403762d	ITXAS LUR	0927	1735	fa86a02c-c6bf-4615-ac50-e6a64cb929bb	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	60	63.30	1952	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	HISPANO PATAGONICA  S.A.	Mar del Plata		480-1002 / 489-3165 / 489-7144	\N		\N	\N		t	\N	\N	\N
b1a49ef0-f210-4d30-96cb-d848b1131171	JOLUMA	5403	\N	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	\N	\N	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	ARDAPEZ  S.A.	Mar del Plata	4800005	480-1561 / 480-1568 / 480-1549	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
4d2fa66a-2930-4d45-912c-819daf41efc4	JOSÉ AMÉRICO	03071	2756	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	44.21	0	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	PEDRO MOSCUZZA e HIJOS  S.A.	Mar del Plata		489-7287	\N		\N	\N		t	\N	\N	\N
592b10fa-3452-491c-9c03-c835c34ae30f	JOSE LUIS ALVAREZ	0618	\N	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	\N	\N	7f1cac29-7e2c-4b6d-8447-1a5a9108fd12	PESQUERA SAN ISIDRO S.A.	Puerto Madryn		0280-447-2697	\N		\N	\N		t	\N	\N	\N
aec29330-5e93-44ad-be65-9391f79b9a5c	JOSE MARCELO	3138	2764	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	39.94	0	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	PEDRO MOSCUZZA e HIJOS  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
c8ad30b0-039c-4ce1-81c9-b684ec35217b	JUAN ALVAREZ	0619	1755	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	36.60	1168	7f1cac29-7e2c-4b6d-8447-1a5a9108fd12	PESQUERA SAN ISIDRO S.A.	Puerto Madryn		0280-447-2697	\N		\N	\N		t	\N	\N	\N
570a6ff1-ded6-4ae2-bb80-79bd84a7f04e	JUAN PABLO II	02695	0	907fd6b2-95a4-42bf-856e-a9b0d99402ea	c682a081-0da5-453f-a40a-2b5c1e1600b4	\N	8	22.49	326	\N	ISLA DE LOS ESTADOS  S.A.	Vivoratá			\N		\N	\N		t	\N	\N	\N
7e8aca9d-ecd4-4111-930e-a521c51d3513	JUDITH I	0908	\N	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	\N	\N	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	ANTONIO BARILLARI  S.A.	Mar del Plata		481-1173  / 489-0872	\N		\N	\N		t	\N	\N	\N
8a43118f-f77f-4baf-b716-d503550f5f7e	JUEVES SANTO	0667	1762	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	39.50	1244	7a9e4185-6281-4c42-b3c4-1980e6855a31	NUVCONSA  S.A.	Ciudad Autónoma de Buenos Aires	4891553-154179360-154179860-154179062	011-4305-4706	\N	agenciasmiriglio@speedy.com.ar	\N	\N	Agencia Maritima Smiriglio	t	\N	\N	\N
c5f207c9-8f09-43e7-a0c7-9725318e8d16	JUPITER II	0406	1769	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	27.90	791	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	VENUS  PESQUERA S.R.L.	Mar del Plata	4800005	489-0186	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
80c961a8-e398-43e8-8c43-53d65a8b196a	KALEU KALEU	01963	\N	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	\N	\N	7a9e4185-6281-4c42-b3c4-1980e6855a31	KALEU KALEU  S.A.	Ciudad Autónoma de Buenos Aires	4800005	011-3220-2130  / 5093-1215	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi	t	\N	\N	\N
2c998ab5-b2cb-46fe-a11c-07bc8c50ac0c	KANTXOPE	01065	\N	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	\N	\N	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	ANTONIO BARILLARI  S.A.	Mar del Plata		481-1173  / 489-0872	\N		\N	\N		t	\N	\N	\N
8a4e44ac-8374-46f4-b30a-1a3dfc26f2e0	KARINA	01462	\N	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	\N	\N	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	FRIGORIFICO DON LUIS  S.R.L.	Mar del Plata		489-4645	\N		\N	\N		t	\N	\N	\N
305eee9c-ce1e-4616-82a9-85d62a8981fe	LAIA	06521	0	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	53.00	1185	7a9e4185-6281-4c42-b3c4-1980e6855a31	PESQUERA MADRYN  S.A.	Ciudad Autónoma de Buenos Aires		011-4394-1452	\N		\N	\N		t	\N	\N	\N
7f6c7f3d-12c6-4d21-9724-48fc5dd5fbe3	LANZA SECA	01181	1852	\N	\N	\N	0	24.80	514	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	LANZAMAR  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
35b8a125-22bf-492f-bca9-079b6e6df7a6	LATINA  N° 8	0291	\N	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	\N	\N	9e97a6b3-cca1-4931-92e9-ab8a5e0b35e1	ARGENOVA  S.A.	Puerto Deseado		0297- 487-0550  (447-2818  Com. Riv )	\N		\N	\N		t	\N	\N	\N
93919bf9-fed9-4c77-9f35-650fe4bd1c45	LEAL	0143	1863	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	27.45	601	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	PESQUERA LEAL  S.A.	Mar del Plata		489-4624 / 489-0314 (astillero )	\N		\N	\N		t	\N	\N	\N
51b40c93-9980-4465-aa28-00529f3d7554	LEKHAN I	00752	1865	907fd6b2-95a4-42bf-856e-a9b0d99402ea	c682a081-0da5-453f-a40a-2b5c1e1600b4	\N	8	18.45	530	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	LEKHAN I  S.R.L.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
aca7283b-c240-4538-ad9e-f70981f81846	LETARE	0245	\N	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	\N	\N	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	LUIS SOLIMENO e HIJOS  S.A.	Mar del Plata		489-3030	\N		\N	\N		t	\N	\N	\N
1e3c5abc-8714-474e-8da0-e5855fa25f1f	LIBERTAD DEL MAR 1°	02186	\N	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	\N	\N	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	TATURIELLO  S.A.	Mar del Plata		489-3833	\N		\N	\N		t	\N	\N	\N
7f704886-73a9-4047-a7f8-f2b6fbb56f7e	LING SHUI N° 3	02210	\N	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	\N	\N	7a9e4185-6281-4c42-b3c4-1980e6855a31	MUELLE OCHO  S.A.	Ciudad Autónoma de Buenos Aires		011-4381-1337	\N		\N	\N		t	\N	\N	\N
6676ce29-e092-4c23-9f2b-a628bc8b92ac	LING SHUI N° 5	02211	\N	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	\N	\N	7a9e4185-6281-4c42-b3c4-1980e6855a31	MUELLE OCHO  S.A.	Ciudad Autónoma de Buenos Aires		011-4381-1337	\N		\N	\N		t	\N	\N	\N
41a2dfd2-cc96-440c-87e6-8ab941a1d53b	LUIGI	3244	\N	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	\N	\N	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	LUIS SOLIMENO e HIJOS  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
e58e416e-1125-4d7a-bd84-974f867f5016	LUCA MARIO	0546	2715	fa86a02c-c6bf-4615-ac50-e6a64cb929bb	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	60	79.14	3952	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	PESCASOL  S.A.	Mar del Plata	4800274	480-9608 / 481-0464	\N	amalfitanoycia@hotmail.com	\N	\N	Agencia Maritima Almafitano	t	\N	\N	\N
9a11d629-e76e-4ffc-bdfc-2d0e2a013d3a	LUCA SANTINO	3121	0	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	26.31	0	\N	CENTOMAR  S.A.				\N		\N	\N		t	\N	\N	\N
fe42ee8e-e1e4-4aa4-9425-9a7d4647b5c3	LUCIA LUISA	0623	1897	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	27.90	463	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	PESQUERA VERAZ  S.A.	Mar del Plata		489-4624 / 489-0314 (astillero)	\N		\N	\N		t	\N	\N	\N
02147c99-046e-46df-8365-6b7a0cd9423a	LUNES SANTO	01132	\N	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	\N	\N	7f1cac29-7e2c-4b6d-8447-1a5a9108fd12	IBERCONSA  DE ARGENTINA  S.A.	Puerto Madryn		0280-445-4324	\N		\N	\N		t	\N	\N	\N
db4a8025-073b-4312-b76b-11959dec3860	MADONNINA DEL MARE	01112	1912	907fd6b2-95a4-42bf-856e-a9b0d99402ea	c682a081-0da5-453f-a40a-2b5c1e1600b4	\N	8	23.78	601	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	FABLED  S.A	Mar del Plata		480-1565	\N		\N	\N		t	\N	\N	\N
e0deb7c7-1e13-4765-9692-2dc499dfe48b	MADRE DIVINA	01556	1915	907fd6b2-95a4-42bf-856e-a9b0d99402ea	c682a081-0da5-453f-a40a-2b5c1e1600b4	\N	10	26.12	518	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	VUOSO HNOS. S.R.L.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
d363f5e4-ba00-496e-89aa-1b4c5e6ca7c6	MADRE INMACULADA	2378	1916	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	62.80	1852	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	ANTONIO BALDINO e HIJOS  S.A. (Saladero)	Mar del Plata		489-6522  /489-0423	\N		\N	\N		t	\N	\N	\N
8d5a862d-1c47-4d72-b9f2-f8cbbef82680	MADRE MARGARITA	02728	0	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	25.60	541	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	PESQUERA  MARGARITA  S.A.	Mar del Plata		489-4645   /   489-2946	\N		\N	\N		t	\N	\N	\N
fd82ca73-c2d4-4247-bd89-2bf46a1ddb43	MAGDALENA MARIA  II	02208	\N	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	\N	\N	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	ANTONIO BARILLARI  S.A.	Mar del Plata	4800005	481-1173  / 489-0872	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
bd9ac6f2-f2cd-4c50-9dd6-2e6c46bc3e3d	MALVINAS ARGENTINAS	0577	1931	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	28.40	458	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	PEDRO MOSCUZZA e HIJOS  S.A.	Mar del Plata		489-7287	\N		\N	\N		t	\N	\N	\N
78301723-a1a3-49df-a7ff-5003b8657852	MAR  AUSTRAL  I	0208	\N	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	\N	\N	9e97a6b3-cca1-4931-92e9-ab8a5e0b35e1	PESQUERA DESEADO  S.A.	Puerto Deseado		0297-487-0884 / 0327 / 2407	\N		\N	\N		t	\N	\N	\N
639a6def-6b30-4ba3-a592-0b1cc0e20b3f	MAR AZUL	0934	\N	\N	\N	\N	\N	\N	\N	\N	CLARAMAR  S.A.		480-7779 - HERNAN		\N	agenciasenoransmdp@yahoo.com	\N	\N	Agencia Maritima SEÑORANS	t	\N	\N	\N
5c584828-9ace-4cf8-9934-d6bfa8844032	MAR DEL CHUBUT	0487	1944	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	28.20	721	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	ROMFIOC  SRL	Mar del Plata	4800005		\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi	t	\N	\N	\N
2bc79fca-2fcd-4f40-baab-9d554a5719f7	MAR ESMERALDA	0925	\N	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	\N	\N	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	ANTONIO BARILLARI  S.A.	Mar del Plata		481-1173  / 489-0872	\N		\N	\N		t	\N	\N	\N
d156325d-20f4-4040-94c0-60433df478ba	MAR MARÍA	02960	2738	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	37.80	1248	7a9e4185-6281-4c42-b3c4-1980e6855a31	PESQUERA SANTA CRUZ  S.A.	Ciudad Autónoma de Buenos Aires		011-4305-4706	\N		\N	\N		t	\N	\N	\N
4f8593af-4c7b-47f4-8fe2-6d2a25db223e	MAR NOVIA 1	0115	\N	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	\N	\N	7a9e4185-6281-4c42-b3c4-1980e6855a31	CINCOMAR  S.A.	Ciudad Autónoma de Buenos Aires		011-4326-4991	\N		\N	\N		t	\N	\N	\N
8df55bc4-c0a5-4b66-b0d9-3e6ff18e215a	MAR NOVIA 2	0116	\N	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	\N	\N	7a9e4185-6281-4c42-b3c4-1980e6855a31	MIREMAR  S.A.	Ciudad Autónoma de Buenos Aires		011-4328-4963 / 4	\N		\N	\N		t	\N	\N	\N
c934a991-153a-40c5-ba49-77e4f5bcbe81	MAR SUR	0341	1957	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	36.40	889	7a9e4185-6281-4c42-b3c4-1980e6855a31	PESCARGEN  S.A.	Ciudad Autónoma de Buenos Aires		011-5219-0065 ó 5276-9499	\N		\N	\N		t	\N	\N	\N
3b0ce513-89a4-4dbf-a56b-f1c3974672a9	MARA I	0210	1960	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	35.31	1209	7f1cac29-7e2c-4b6d-8447-1a5a9108fd12	PESCAPUERTA ARGENTINA  S.A.	Puerto Madryn		0280-445-4407	\N		\N	\N		t	\N	\N	\N
747ba2c4-fe5a-47a0-b244-ce5c6966c22d	MARA II	0209	\N	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	\N	\N	7f1cac29-7e2c-4b6d-8447-1a5a9108fd12	PESCAPUERTA ARGENTINA  S.A.	Puerto Madryn		0280-445-4407	\N		\N	\N		t	\N	\N	\N
657a5b64-48a0-4b51-b6b8-1d320cac7d5c	MARBELLA	01073	1966	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	27.38	736	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	MAR DE MESSINA  S.A.	Mar del Plata	beagle1	489-3824	\N		\N	\N		t	\N	\N	\N
d061f90a-dba6-4302-8f11-dc96cd94ffee	MARCALA I	0532	\N	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	\N	\N	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	PESANFLOR  S.A.	Mar del Plata		489-6522	\N		\N	\N		t	\N	\N	\N
6e0f4186-9c38-41a0-b9b8-6feb1c58fc4f	MARCALA IV	0351	\N	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	\N	\N	7a9e4185-6281-4c42-b3c4-1980e6855a31	MARCALA  S.A.	Ciudad Autónoma de Buenos Aires		011-4342-9601 / 4283	\N		\N	\N		t	\N	\N	\N
56739ada-ce28-43b7-908e-271e1c00aaa6	MAREJADA	01107	1974	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	27.98	624	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	VICARP  S.A.	Mar del Plata		480-4378	\N		\N	\N		t	\N	\N	\N
64413a65-81e1-492f-aafd-5e50797c8b07	MARGOT	0360	1976	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	58.75	1481	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	GIORNO  S.A.	Mar del Plata	4800005	410-0051 / 0057	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
8c6c52b3-e57a-4afb-b694-584b5f5b7435	MARIA  EUGENIA	01173	\N	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	\N	\N	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	PEDRO MOSCUZZA e HIJOS  S.A.	Mar del Plata		489-7287	\N		\N	\N		t	\N	\N	\N
a3de1b13-f8e1-4554-8433-4fdffd15e10f	HUAFENG 816	05994	0	907fd6b2-95a4-42bf-856e-a9b0d99402ea	c682a081-0da5-453f-a40a-2b5c1e1600b4	\N	4	22.60	521	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	COSTA BRAVA  S.A.	Mar del Plata	4800005	489-7538	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
91eec5b3-519e-4b9e-9c54-398b19aeea97	MARIA  LILIANA	01174	\N	fa86a02c-c6bf-4615-ac50-e6a64cb929bb	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	60	\N	\N	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	PEDRO MOSCUZZA e HIJOS  S.A.	Mar del Plata	4893758	489-7287	\N	miguel-visoso@hotmail.com	\N	\N	Agencia Maritima Solvox	t	\N	\N	\N
6752788d-f8d6-4783-bb46-38311736cf78	MARIA RITA	0436	2000	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	30.95	541	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	BAL - FISH  S.A.	Mar del Plata		489-6522	\N		\N	\N		t	\N	\N	\N
c73aa159-1a07-4578-a0fd-fa467c64379b	MARIA ALEJANDRA 1º	03074	2750	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	39.20	0	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	XEITOSIÑO S.A.	Mar del Plata		410-0051 / 7	\N		\N	\N		t	\N	\N	\N
1aaf3661-fa26-41b1-833e-0d14a44304f4	MARIA DEL VALLE	02126	1986	907fd6b2-95a4-42bf-856e-a9b0d99402ea	c682a081-0da5-453f-a40a-2b5c1e1600b4	\N	4	16.29	196	a39428a8-f7d6-4716-9c31-99556bfb37f3	FARO CHUBUT  S.R.L.	Rawson		0280-449-6311	\N		\N	\N		t	\N	\N	\N
62f6aad1-5377-4dd4-af3a-2ce16eba2bd6	MARIA GLORIA	02738	2763	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	28.05	851	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	CAYO LARGO  S.A.	Mar del Plata		480-4378	\N		\N	\N		t	\N	\N	\N
0d5efca4-a7b0-4f0f-9c87-64b55b2e2de3	MARIANELA	01002	2007	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	25.60	541	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	AGLIANO  SRL	Mar del Plata		480-2886	\N		\N	\N		t	\N	\N	\N
ca7cf3ac-07b4-4e3e-a2c3-1fca5047d078	MARTA S	01001	0	907fd6b2-95a4-42bf-856e-a9b0d99402ea	c682a081-0da5-453f-a40a-2b5c1e1600b4	\N	8	23.90	503	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	WERZOWA  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
6f4339f9-02d9-46a5-b9fc-13cb1b4a7929	MATACO II	02243	\N	fa86a02c-c6bf-4615-ac50-e6a64cb929bb	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	60	\N	\N	7f1cac29-7e2c-4b6d-8447-1a5a9108fd12	HAMALTAL  S.A.	Puerto Madryn	4800005	0280-445-0822	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
87f926dd-849a-445d-a8ef-30097f382ded	MATEO I	02172	2028	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	67.97	1776	7a9e4185-6281-4c42-b3c4-1980e6855a31	KALEU KALEU  S.A.	Ciudad Autónoma de Buenos Aires		011-3220-2130  / 5093-1215	\N		\N	\N		t	\N	\N	\N
3ad7055b-31c5-4ddc-9da8-69916eee3a8d	MELLINO I	0379	2032	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	47.25	1185	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	GIORNO  S.A.	Mar del Plata		410-0051 / 0057	\N		\N	\N		t	\N	\N	\N
55c9c760-dcd9-44d2-a342-faa9990c2c3f	MELLINO II	01424	0	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	38.91	795	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	GIORNO  S.A.	Mar del Plata	AVENIDA DE LOS PESCADORES 195	410-0051 / 0057	\N		\N	\N	Agencia AMALFITANO	t	\N	\N	\N
b5b3193e-dc6f-4132-a473-640f8610465c	MELLINO VI	0378	2034	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	64.87	1235	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	GIORNO  S.A.	Mar del Plata		410-0051 / 0057	\N		\N	\N		t	\N	\N	\N
76d897c4-125b-4f3e-82b4-ef540c3af05d	MERCEA C	0318	2036	\N	\N	\N	0	29.15	866	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	ALLELOCCIC  S.A.	Mar del Plata		495-4467 / 480-8565	\N		\N	\N		t	\N	\N	\N
ce97fead-b6c9-4571-bbc9-a9e88868791e	MESSINA I	01089	2038	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	27.29	650	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	MAR DE MESSINA  S.A.	Mar del Plata		489-3824	\N		\N	\N		t	\N	\N	\N
228a0db0-c110-4e78-b842-98211b6da3ad	MEVIMAR	01508A	\N	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	\N	\N	7f1cac29-7e2c-4b6d-8447-1a5a9108fd12	RIMINIMARR  S.A.	Puerto Madryn		0280-445-2248	\N		\N	\N		t	\N	\N	\N
e5330234-c4c7-4883-9e5b-9f41c0214ce8	MIERCOLES SANTO	0666	2041	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	38.50	1244	7a9e4185-6281-4c42-b3c4-1980e6855a31	NUVCONSA  S.A.	Ciudad Autónoma de Buenos Aires		011-4305-4706	\N		\N	\N		t	\N	\N	\N
3ffbe7bd-f3d2-4188-b3fe-fc610391596f	MILLENNIUM	0466	2046	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	55.05	1329	7a9e4185-6281-4c42-b3c4-1980e6855a31	PESQUERA CRUZ DEL SUR  S.A.	Ciudad Autónoma de Buenos Aires		011-4784-1760	\N		\N	\N		t	\N	\N	\N
ce645847-4fb1-4a4b-bb4c-7be7a54058c7	MINCHOS OCTAVO	03022	2744	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	39.30	579	7f1cac29-7e2c-4b6d-8447-1a5a9108fd12	IBERCONSA  DE ARGENTINA  S.A.	Puerto Madryn		0280-445-4324	\N		\N	\N		t	\N	\N	\N
6fa1e08b-94a9-462f-949f-11a92f4e30b8	NINA	3171	2770	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	44.00	1620	\N	PEDRO MOSCUZZA e HIJOS  S.A.				\N		\N	\N		t	\N	\N	\N
0224e437-1522-42cc-bc8c-d6ac701df5b6	MINTA	02196	2050	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	65.10	1603	7a9e4185-6281-4c42-b3c4-1980e6855a31	LIYA  S.A.	Ciudad Autónoma de Buenos Aires		011-4964-2227	\N		\N	\N		t	\N	\N	\N
7359d105-7b39-4de3-abf9-9eaebd16e958	MIRIAM	0370	2051	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	36.35	1446	7a9e4185-6281-4c42-b3c4-1980e6855a31	VIEIRA ARGENTINA  S.A.	Ciudad Autónoma de Buenos Aires	4800005		\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi	t	\N	\N	\N
1f844f5d-2ab1-4b30-a195-152ba06b959b	MISHIMA MARU N°8	02175	2054	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	63.43	1579	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	BAL - FISH  S.A.	Mar del Plata	4800274	489-6522	\N	amalfitanoycia@hotmail.com	\N	\N	Agencia Maritima Almafitano	t	\N	\N	\N
f3460ae8-4d0b-48cf-8f05-b208acd9d669	MISS PATAGONIA	0555	2055	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	28.20	667	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	PESQUERA VERAZ  S.A.	Mar del Plata	4805743	489-4624 / 489-0314 (astillero)	\N	agenciadiyorio@hotmail.com -joseph@hotmail.com	\N	\N	Agencia Di Yorio	t	\N	\N	\N
1ce502d2-13cb-49f0-9d02-ef4d85866967	MISS TIDE	02439	2056	fc8c8ee3-01dd-40b0-96f2-6b99a6643f7b	e0913412-884d-4103-97b7-3eceac842fcf	7bfb912c-3ee4-426e-a976-68bbbf6bc1d4	30	52.52	2254	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	WANCHESE ARGENTINA  S.A.	Mar del Plata		489-1236	\N		\N	\N		t	\N	\N	\N
77c9b83d-973b-47ce-ae25-b7587fdd5037	MISTER BIG	0534	\N	fc8c8ee3-01dd-40b0-96f2-6b99a6643f7b	e0913412-884d-4103-97b7-3eceac842fcf	7bfb912c-3ee4-426e-a976-68bbbf6bc1d4	30	\N	\N	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	WANCHESE ARGENTINA  S.A.	Mar del Plata		489-1236	\N		\N	\N		t	\N	\N	\N
d6a618c6-62b1-4e9c-94c8-095e8ce3b464	MIURA MARU	05996	2058	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	53.20	1482	7a9e4185-6281-4c42-b3c4-1980e6855a31	LIYA  S.A.	Ciudad Autónoma de Buenos Aires		011-4964-2227	\N		\N	\N		t	\N	\N	\N
6669e237-5731-4bd6-acc0-bef4c8509d21	MONTE DE VIOS	0664	\N	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	\N	\N	7a9e4185-6281-4c42-b3c4-1980e6855a31	PESQUERA SANTA CRUZ  S.A.	Ciudad Autónoma de Buenos Aires		011-4305-4706	\N		\N	\N		t	\N	\N	\N
7872e3b6-5c68-49b0-aec6-d79bd4c284ba	MYRDOMA F	02771	2735	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	38.55	1430	7f1cac29-7e2c-4b6d-8447-1a5a9108fd12	LANZAR S.A.	Puerto Madryn	4800005	0280-445-6280	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
3a5c8c97-f021-44b0-942b-41ddb4cbb879	NANINA	02576	2073	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	72.08	1678	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	PEDRO MOSCUZZA e HIJOS  S.A.	Mar del Plata	4800005	489-7287	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
5a662438-6668-40c2-956e-d514528c0109	NATALIA	02066	2075	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	68.45	1779	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	PEDRO MOSCUZZA e HIJOS  S.A.	Mar del Plata		489-7287	\N		\N	\N		t	\N	\N	\N
16da3b63-48f0-4f65-8fb5-fe677fb75cc9	NAVEGANTES	0542	2079	fa86a02c-c6bf-4615-ac50-e6a64cb929bb	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	60	58.00	1925	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	PESQUERA COMERCIAL  S.A.	Mar del Plata		489-3030	\N		\N	\N		t	\N	\N	\N
d24694b5-3a46-45b0-95d7-b75f0456aefc	NAVEGANTES II	01451	2080	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	63.70	1603	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	PESQUERA COMERCIAL  S.A.	Mar del Plata		489-3030	\N		\N	\N		t	\N	\N	\N
619e44ee-2ab2-4550-b783-f129c96e2ff5	NAVEGANTES III	02065	2081	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	68.60	2203	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	PESQUERA COMERCIAL  S.A.	Mar del Plata	4800274	489-3030	\N	amalfitanoycia@hotmail.com	\N	\N	Agencia Maritima Almafitano	t	\N	\N	\N
2e633f9c-1b10-4515-9863-34083bab32b6	NDDANDDU	0141	2082	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	28.20	856	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	PESQUERA VERAZ  S.A.	Mar del Plata		489-4624 / 489-0314 (astillero)	\N		\N	\N		t	\N	\N	\N
3ede0482-9e10-4e5c-a578-f6589ffbc509	NEPTUNIA I	02125	\N	907fd6b2-95a4-42bf-856e-a9b0d99402ea	c682a081-0da5-453f-a40a-2b5c1e1600b4	\N	4	\N	\N	a39428a8-f7d6-4716-9c31-99556bfb37f3	FLOTA AMARILLA RAWSON	Rawson	4891553-154179360-154179860-154179062		\N	agenciasmiriglio@speedy.com.ar	\N	\N	Agencia Maritima SMIRIGLIO	t	\N	\N	\N
68bee4d7-b639-4972-8274-f21ebd78ea97	NIÑO JESUS DE PRAGA	3194	2775	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	27.74	1180	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	RITORNO SALLUSTIO Y CICCIOTTI  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
340037f3-81ce-4612-9894-b82c5422b440	NONO PASCUAL	02854	2729	907fd6b2-95a4-42bf-856e-a9b0d99402ea	c682a081-0da5-453f-a40a-2b5c1e1600b4	\N	10	24.00	451	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	CANAL DE BEAGLE  S.R.L.	Mar del Plata		480-4447 / 5004265 PASCUAL	\N		\N	\N		t	\N	\N	\N
218ec4e0-d9e9-4963-84d9-5d58f04d0a82	NUEVA LUCIA MADRE	01501	2113	907fd6b2-95a4-42bf-856e-a9b0d99402ea	c682a081-0da5-453f-a40a-2b5c1e1600b4	\N	8	14.37	416	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	NUEVA LUCIA MADRE  S.R.L.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
4c8f953c-0097-4374-8033-493d86c90795	NUEVA NEPTUNIA I	02634	0	907fd6b2-95a4-42bf-856e-a9b0d99402ea	c682a081-0da5-453f-a40a-2b5c1e1600b4	\N	4	20.00	403	a39428a8-f7d6-4716-9c31-99556bfb37f3	ORION S.R.L.	Rawson			\N		\N	\N		t	\N	\N	\N
62ef061c-3fec-45b6-966a-000646ae81c5	NUEVO ANITA	02100	2128	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	30.90	765	7f1cac29-7e2c-4b6d-8447-1a5a9108fd12	IBERCONSA  DE ARGENTINA  S.A.	Puerto Madryn		0280-445-4324	\N		\N	\N		t	\N	\N	\N
829fc3f9-1f28-4102-b4fa-26dea6c4ba29	NUEVO VIENTO	01449	2135	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	22.23	541	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	NUEVO VIENTO  SRL	Mar del Plata		480-8565	\N		\N	\N		t	\N	\N	\N
a7642835-2f12-4fa0-a05d-4b67c9e2e8a5	OMEGA 3	01391	\N	907fd6b2-95a4-42bf-856e-a9b0d99402ea	c682a081-0da5-453f-a40a-2b5c1e1600b4	\N	10	\N	\N	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	COSTA BRAVA  S.A.	Mar del Plata		489-7538	\N		\N	\N		t	\N	\N	\N
e0930ac7-9751-407e-a012-b0f305a94706	ORION  2	01492	\N	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	\N	\N	7a9e4185-6281-4c42-b3c4-1980e6855a31	PESQUERA SANTA CRUZ  S.A.	Ciudad Autónoma de Buenos Aires		011-4305-4706	\N		\N	\N	norberto.lopez@iberconsa.com	t	\N	\N	\N
a5cd351a-13da-41d1-8695-48e1b5876870	ORION 5	02637	2757	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	65.62	1776	7a9e4185-6281-4c42-b3c4-1980e6855a31	PESQUERA SANTA CRUZ  S.A.	Ciudad Autónoma de Buenos Aires		011-4305-4706	\N		\N	\N		t	\N	\N	\N
2e8752bf-9c5e-45a2-b684-d0eb07ba45ea	ORION I	01943A	0	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	20.90	520	7a9e4185-6281-4c42-b3c4-1980e6855a31	PESQUERA CRUZ DEL SUR  S.A.	Ciudad Autónoma de Buenos Aires		011-4784-1760	\N		\N	\N		t	\N	\N	\N
9343f030-da94-4351-b885-c001850fba7e	ORION 1	01943	\N	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	\N	\N	7a9e4185-6281-4c42-b3c4-1980e6855a31	PESQUERA SANTA CRUZ  S.A.	Ciudad Autónoma de Buenos Aires		011-4305-4706	\N		\N	\N		t	\N	\N	\N
8dee3f0e-179e-48b5-889c-92f11c33bf0f	ORION 3	02167	2170	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	63.10	1776	7a9e4185-6281-4c42-b3c4-1980e6855a31	PESQUERA SANTA CRUZ  S.A.	Ciudad Autónoma de Buenos Aires		011-4305-4706	\N		\N	\N		t	\N	\N	\N
a868ad6e-228d-460e-b80e-b8834ccbc271	ORYONG  756	02092	\N	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	\N	\N	7f1cac29-7e2c-4b6d-8447-1a5a9108fd12	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
01d05bd7-bbd4-4348-946b-c20c7869be36	PACHACA	02572	2180	907fd6b2-95a4-42bf-856e-a9b0d99402ea	c682a081-0da5-453f-a40a-2b5c1e1600b4	\N	4	17.64	320	a39428a8-f7d6-4716-9c31-99556bfb37f3	FLOTA AMARILLA RAWSON	Rawson			\N		\N	\N		t	\N	\N	\N
39753c48-603a-43e5-929e-912b22c0b179	PADRE PIO	02822	2737	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	24.00	451	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	RITORNO SALLUSTIO Y CICCIOTTI  S.A.	Mar del Plata		480-5508	\N		\N	\N		t	\N	\N	\N
ade7adeb-6731-4c7a-a6ea-d9f736e89ff5	PAGRUS II	01393	\N	907fd6b2-95a4-42bf-856e-a9b0d99402ea	c682a081-0da5-453f-a40a-2b5c1e1600b4	\N	4	\N	\N	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	COSTA BRAVA  S.A.	Mar del Plata		489-7538	\N		\N	\N		t	\N	\N	\N
e3450c66-1f99-4a6b-ba59-de2b9c4fe12d	PAKU	0250	2186	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	39.16	1087	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	LUIS SOLIMENO e HIJOS  S.A.	Mar del Plata		489-3030	\N		\N	\N		t	\N	\N	\N
c14a190e-e07c-4368-81a7-886a9661894c	PALOMA V	64	\N	baef63e2-6404-4129-809c-e46df7aaf2de	98911c36-01d8-460d-9d96-d7ba44748277	f87ceb11-df61-4862-b41f-70db2096902b	60	\N	\N	\N					\N		\N	\N		t	\N	\N	\N
499e39b0-824f-4434-8a95-2bf710e10ee9	PAOLA  S	0557	\N	\N	\N	\N	30	\N	\N	\N					\N		\N	\N		t	\N	\N	\N
8f260c1c-d121-44f1-b26b-aaeec57e525a	PASA  82	0338	\N	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	\N	\N	7f1cac29-7e2c-4b6d-8447-1a5a9108fd12	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
7803f160-1de0-44c7-85c1-07dd281e6ed6	PATAGONIA	0284	2196	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	30.95	660	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	LUIS SOLIMENO e HIJOS  S.A.	Mar del Plata		489-3030	\N		\N	\N		t	\N	\N	\N
1688e040-af66-4f28-ba8d-e8779ed4efb9	PATAGONIA 1	02163	\N	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	\N	\N	7a9e4185-6281-4c42-b3c4-1980e6855a31	PATAGONIA  FISHING  S.A.	Ciudad Autónoma de Buenos Aires		011-4932-2777	\N		\N	\N		t	\N	\N	\N
1eee01fe-77a1-425d-a95e-69244bdcced4	PATAGONIA 2	02164	\N	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	\N	\N	7a9e4185-6281-4c42-b3c4-1980e6855a31	PATAGONIA  FISHING  S.A.	Ciudad Autónoma de Buenos Aires		011-4932-2777	\N		\N	\N		t	\N	\N	\N
b1ab34aa-0863-4785-984c-5270c47566dc	PATAGONIA BLUES	02176	2199	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	64.45	1776	7a9e4185-6281-4c42-b3c4-1980e6855a31	PESQUERA CRUZ DEL SUR  S.A.	Ciudad Autónoma de Buenos Aires		011-4784-1760	\N		\N	\N		t	\N	\N	\N
4f26b3a1-e3a1-43e7-ad43-341043dacad4	PEDRITO	TEMP-0005	0	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	\N	39.92	1201	\N					\N		\N	\N		t	\N	\N	\N
0333fbd6-80ed-49f5-9702-bc4c947350a1	PELAGOS	83	\N	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	\N	\N	7f1cac29-7e2c-4b6d-8447-1a5a9108fd12	PESQUERA SAN ISIDRO S.A.	Puerto Madryn		0280-447-2697	\N		\N	\N		t	\N	\N	\N
1a4f20b8-d868-4880-aada-461df3859158	PENSACOLA I	0747	2207	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	25.20	380	65f921a3-7ad7-4608-b954-4ef0568d04c0	FRANGELA  S.A.	Comodoro Rivadavia			\N		\N	\N		t	\N	\N	\N
47946933-f7d7-408f-9da0-2fd7f2096e6d	PESCAPUERTA CUARTO	0171	\N	fa86a02c-c6bf-4615-ac50-e6a64cb929bb	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	60	\N	\N	7f1cac29-7e2c-4b6d-8447-1a5a9108fd12	PESCAPUERTA ARGENTINA  S.A.	Puerto Madryn		0280-445-4407	\N		\N	\N		t	\N	\N	\N
2891a67e-df64-4c37-951f-47daae65b930	PESCAPUERTA QUINTO	0538	\N	280a7409-6bb5-4e36-bad1-93194d72bb82	c682a081-0da5-453f-a40a-2b5c1e1600b4	089b0ead-176b-4e7a-b99d-5caeea74ea61	60	\N	\N	7f1cac29-7e2c-4b6d-8447-1a5a9108fd12	PESCAPUERTA ARGENTINA  S.A.	Puerto Madryn		0280-445-4407	\N		\N	\N		t	\N	\N	\N
67bc6b28-511e-4608-aaac-ae12b40d2337	PESCARGEN  V	078	\N	fa86a02c-c6bf-4615-ac50-e6a64cb929bb	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	60	\N	\N	7a9e4185-6281-4c42-b3c4-1980e6855a31	PESCARGEN  S.A.	Ciudad Autónoma de Buenos Aires		011-5219-0065 ó 5276-9499	\N		\N	\N		t	\N	\N	\N
044ac4ff-f9d9-492d-bbf3-f72949e77016	PESCARGEN III	021	\N	fa86a02c-c6bf-4615-ac50-e6a64cb929bb	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	60	\N	\N	7a9e4185-6281-4c42-b3c4-1980e6855a31	PESCARGEN  S.A.	Ciudad Autónoma de Buenos Aires		011-5219-0065 ó 5276-9499	\N		\N	\N		t	\N	\N	\N
cb71938d-eb95-45f3-abac-24d1b6aa1f5a	PESCARGEN IV	0150	2217	fa86a02c-c6bf-4615-ac50-e6a64cb929bb	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	60	63.20	1603	7a9e4185-6281-4c42-b3c4-1980e6855a31	PESCARGEN  S.A.	Ciudad Autónoma de Buenos Aires		011-5219-0065 ó 5276-9499	\N		\N	\N		t	\N	\N	\N
d40ef961-8b07-47fd-a85b-0ee6926747da	PESPASA  II	0212	\N	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	\N	\N	9e97a6b3-cca1-4931-92e9-ab8a5e0b35e1	PESPASA  S.A.	Puerto Deseado		0297-487-2030  int 12	\N		\N	\N		t	\N	\N	\N
f9f37173-db48-4d94-b016-c197079d1f1c	PESPASA I	0211	\N	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	\N	\N	9e97a6b3-cca1-4931-92e9-ab8a5e0b35e1	PESPASA  S.A.	Puerto Deseado		0297-487-2030  int 12	\N		\N	\N		t	\N	\N	\N
08647393-4be5-4d9e-8641-8fa62d43f589	PETREL	01445	2224	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	29.85	776	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	OLAMAR  S.A.	Mar del Plata		480-3573	\N		\N	\N		t	\N	\N	\N
52888742-226d-496f-b5c9-50638ffc3f18	PEVEGASA QUINTO	02312	2225	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	38.65	740	7a9e4185-6281-4c42-b3c4-1980e6855a31	PUNTA BUSTAMANTE  S.A.	Ciudad Autónoma de Buenos Aires		011-4305-4710 / 4712	\N		\N	\N		t	\N	\N	\N
ab56f62f-e6a5-49b3-a21c-f6ca96d78770	PIONEROS	02735	\N	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	\N	\N	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	CALME  S.A.	Mar del Plata		480-3545	\N		\N	\N		t	\N	\N	\N
ae24958d-b239-4d34-935e-f857ba1b828e	POLARBORG I	02122	\N	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	\N	\N	7a9e4185-6281-4c42-b3c4-1980e6855a31	GRINFIN  S.A.	Ciudad Autónoma de Buenos Aires		011-4343-5626	\N		\N	\N		t	\N	\N	\N
293da483-aef3-442d-9c52-d79eb0c4f1fb	POLARBORG II	02117	\N	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	\N	\N	7a9e4185-6281-4c42-b3c4-1980e6855a31	GRINFIN  S.A.	Ciudad Autónoma de Buenos Aires	4800005	011-4343-5626	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi	t	\N	\N	\N
ade13efc-9927-4ab3-988e-71914e70f0fd	PONTE CORUXO	0975	2242	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	52.85	1383	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	BAL - FISH  S.A.	Mar del Plata		489-6522	\N		\N	\N		t	\N	\N	\N
1e910c8f-e549-4d75-924a-b5a9b5f3390b	PONTE DE RANDE	0244	2243	fa86a02c-c6bf-4615-ac50-e6a64cb929bb	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	60	79.14	2964	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	COSTA MARINA  S.A.	Mar del Plata		480-9608 / 481-0464	\N		\N	\N		t	\N	\N	\N
74b839d1-1302-4860-950a-b1c105ab7089	PORTO BELO I	02699	2736	907fd6b2-95a4-42bf-856e-a9b0d99402ea	c682a081-0da5-453f-a40a-2b5c1e1600b4	\N	8	23.98	600	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	FARO RECALADA  S.A	Mar del Plata		480-2442	\N		\N	\N		t	\N	\N	\N
a31662e9-5abe-4938-96e5-89c2341abbdb	PORTO BELO II	02790	2728	907fd6b2-95a4-42bf-856e-a9b0d99402ea	c682a081-0da5-453f-a40a-2b5c1e1600b4	\N	10	23.98	601	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	MARITIMA PORTO BELO  S.A.	Mar del Plata		489-1553	\N		\N	\N		t	\N	\N	\N
15169bff-3507-4564-b22d-7d40a229b0c8	PRINCIPE AZUL	TEMP-0006	\N	907fd6b2-95a4-42bf-856e-a9b0d99402ea	c682a081-0da5-453f-a40a-2b5c1e1600b4	\N	10	\N	\N	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a		Mar del Plata			\N		\N	\N		t	\N	\N	\N
620fa806-9083-4eff-bf41-f75a70377abc	PROMAC	4815	2257	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	33.45	721	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	LUIS SOLIMENO e HIJOS  S.A.	Mar del Plata		489-3030	\N		\N	\N		t	\N	\N	\N
b2ab233e-6e39-4540-b9ff-a59a2020d52c	PROMARSA I	072	\N	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	\N	\N	7f1cac29-7e2c-4b6d-8447-1a5a9108fd12	ALPESCA  S.A.	Puerto Madryn		0280-447-4958 / 45-1069	\N		\N	\N		t	\N	\N	\N
afcc364d-3a5c-4737-87fe-6462886a821b	PROMARSA II	073	\N	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	\N	\N	7f1cac29-7e2c-4b6d-8447-1a5a9108fd12	ALPESCA  S.A.	Puerto Madryn		0280-447-4958 / 45-1069	\N		\N	\N		t	\N	\N	\N
9eefa99b-ee63-45ba-8694-6116265520b0	PROMARSA III	02096	0	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	35.84	1062	7f1cac29-7e2c-4b6d-8447-1a5a9108fd12	ALPESCA  S.A.	Puerto Madryn		0280-447-4958 / 45-1069	\N		\N	\N		t	\N	\N	\N
782cb866-8c6d-4cf2-bfc8-49269cebbd80	PUENTE VALDES	02205	2266	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	58.15	1383	7f1cac29-7e2c-4b6d-8447-1a5a9108fd12	PEREIRA  ARGENTINA  S.A.	Puerto Madryn		0280-445-7377 / 447-2249	\N		\N	\N		t	\N	\N	\N
51339653-60af-40eb-9f12-f93c5512ca91	PUENTE AMERICA	0164	\N	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	\N	\N	7f1cac29-7e2c-4b6d-8447-1a5a9108fd12	PEREIRA  ARGENTINA  S.A.	Puerto Madryn		0280-445-7377 / 447-2249	\N		\N	\N		t	\N	\N	\N
4809074a-6222-4023-abc1-a38c6da6d456	PUENTE CHICO	0756	2263	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	37.00	1175	7f1cac29-7e2c-4b6d-8447-1a5a9108fd12	PEREIRA  ARGENTINA  S.A.	Puerto Madryn		0280-445-7377 / 447-2249	\N		\N	\N		t	\N	\N	\N
01c9832e-dde1-473c-9811-cc043544cd1d	PUENTE MAYOR	02630	2703	fa86a02c-c6bf-4615-ac50-e6a64cb929bb	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	60	66.86	2416	7f1cac29-7e2c-4b6d-8447-1a5a9108fd12	PEREIRA  ARGENTINA  S.A.	Puerto Madryn		0280-445-7377 / 447-2249	\N		\N	\N		t	\N	\N	\N
208eebeb-ece5-4520-92e5-63ca88f00ebe	PUENTE SAN JORGE	0207	2265	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	35.30	1001	7f1cac29-7e2c-4b6d-8447-1a5a9108fd12	PEREIRA  ARGENTINA  S.A.	Puerto Madryn		0280-445-7377 / 447-2249	\N		\N	\N		t	\N	\N	\N
bef4a67a-b9b7-4d83-b0f7-650715fb8a9b	PUERTO WILLIAMS	3178	\N	280a7409-6bb5-4e36-bad1-93194d72bb82	c682a081-0da5-453f-a40a-2b5c1e1600b4	089b0ead-176b-4e7a-b99d-5caeea74ea61	60	\N	\N	a269cdaa-b6a8-4b05-b44a-042cd68106e4	DERIS  S.A.	Punta Arenas -  Chile		+613 6224-8744	\N		\N	\N		t	\N	\N	\N
2ffad98d-e7b3-457b-aa1b-125b4015e102	PUNTA BALLENA	65	\N	baef63e2-6404-4129-809c-e46df7aaf2de	98911c36-01d8-460d-9d96-d7ba44748277	f87ceb11-df61-4862-b41f-70db2096902b	60	\N	\N	\N					\N		\N	\N		t	\N	\N	\N
ad06bd0e-3d8c-4943-8d6d-e3ff270309dd	QUEQUEN SALADO	0580	2277	907fd6b2-95a4-42bf-856e-a9b0d99402ea	c682a081-0da5-453f-a40a-2b5c1e1600b4	\N	4	19.45	271	a39428a8-f7d6-4716-9c31-99556bfb37f3	PISCAL  S.A.	Rawson			\N		\N	\N		t	\N	\N	\N
a4cb82f1-e3b2-49f7-9abd-fa8cf96843f3	RAFFAELA	01401	2280	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	26.50	624	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	PESQUERA RAFFAELA  S.A.	Mar del Plata		489-56574 int 203	\N		\N	\N		t	\N	\N	\N
91b97952-b910-4126-94c3-b3b95c99a740	RAQUEL	01074	\N	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	\N	\N	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	PIEA  S.A.	Mar del Plata		489-6317 /489-1367	\N		\N	\N		t	\N	\N	\N
cce565fe-3eda-4062-98f8-cf1ea9603412	REPUNTE	01120	\N	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	\N	\N	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	OSTRAMAR  S.A.	Mar del Plata		489-1959	\N		\N	\N		t	\N	\N	\N
f74e67d2-70d4-4849-ab6f-ccbfda936428	REYES DEL MAR II	0408	\N	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	\N	\N	7a9e4185-6281-4c42-b3c4-1980e6855a31	AGUA MARINA  S.A.	Ciudad Autónoma de Buenos Aires		011-4342-0605 / 5656 / 1709	\N		\N	\N		t	\N	\N	\N
1612873e-a7ff-49fb-97f0-d3c9703e5f23	RIBAZON DORINE	0921	\N	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	\N	\N	7a9e4185-6281-4c42-b3c4-1980e6855a31	KALEU KALEU  S.A.	Ciudad Autónoma de Buenos Aires		011-3220-2130  / 5093-1215	\N		\N	\N		t	\N	\N	\N
fed3b3cd-6f04-4d6f-890d-5462636260fd	RIBAZON INES	0751	2306	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	38.50	720	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	SOUTH FISH  S.A.	Mar del Plata		480-5202	\N		\N	\N		t	\N	\N	\N
d7c01235-a8bb-463b-90f3-17d1ce28c8cd	RIGEL	0266	\N	907fd6b2-95a4-42bf-856e-a9b0d99402ea	c682a081-0da5-453f-a40a-2b5c1e1600b4	\N	10	\N	\N	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	LUIS SOLIMENO e HIJOS  S.A.	Mar del Plata		489-3030	\N		\N	\N		t	\N	\N	\N
628b20dd-9aa4-4d83-a072-ef577b915db8	ROCIO DEL MAR	01568	2313	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	15	22.60	541	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	ROCIO DEL MAR  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
664416ea-8cd9-4b05-b17a-7d0e7e531b07	ROSARIO  G	0549	\N	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	\N	\N	7f1cac29-7e2c-4b6d-8447-1a5a9108fd12	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
cb03025a-fcde-420d-9c36-ab22c4e243d0	RUMBO ESPERANZA	01211	\N	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	\N	\N	65f921a3-7ad7-4608-b954-4ef0568d04c0	CAPAC  SRL	Comodoro Rivadavia		0297-446-1499  /  444-2233	\N		\N	\N		t	\N	\N	\N
c75f716c-5dc6-42dd-831c-2952e7562b8c	RYOUN MARU N° 17	JA06-03	\N	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	\N	\N	7a9e4185-6281-4c42-b3c4-1980e6855a31	BAHIA GRANDE  S.A.	Ciudad Autónoma de Buenos Aires	4891553-154179360-154179860-154179062	011-5272-0850 / 5254-1133	\N	agenciasmiriglio@speedy.com.ar	\N	\N	Agencia Maritima Smiriglio	t	\N	\N	\N
b5cc963e-ebe4-4fe3-92fd-de054786dca1	SALVADOR R	02755	2761	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	27.73	420	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	URBIPEZ  S.A.	Mar del Plata		4892793	\N		\N	\N		t	\N	\N	\N
8228b0d6-9d32-43d2-9466-4f3d07e833b6	SAN ANDRES APOSTOL	0569	2340	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	54.56	2269	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	PESANFLOR  S.A.	Mar del Plata		489-6522	\N		\N	\N		t	\N	\N	\N
7584fa84-384e-402c-b500-209816572de5	SAN ANTONINO	0375	\N	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	\N	\N	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	SEA FISH  S.A.	Mar del Plata	51-11-65337853	480-0336	\N		\N	\N	Natalia Cedrato	t	\N	\N	\N
1b2b11d3-0322-49b4-a9c7-0eb48734747a	VALERIA DEL ATLÁNTICO	02098	2346	280a7409-6bb5-4e36-bad1-93194d72bb82	c682a081-0da5-453f-a40a-2b5c1e1600b4	089b0ead-176b-4e7a-b99d-5caeea74ea61	60	56.46	4698	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	SAN ARAWA  S.A.	Mar del Plata		492-2216 / 492-0450	\N		\N	\N		t	\N	\N	\N
0cf3d0aa-b067-4dbb-b3c7-2e6d43913431	SAN BENEDETTO	02643	0	907fd6b2-95a4-42bf-856e-a9b0d99402ea	c682a081-0da5-453f-a40a-2b5c1e1600b4	\N	8	15.38	220	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	PESQUERA SAN BENEDETTO  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
305a93bc-feab-43d9-b318-2b29094b431b	SAN GENARO	0763	\N	907fd6b2-95a4-42bf-856e-a9b0d99402ea	c682a081-0da5-453f-a40a-2b5c1e1600b4	\N	10	\N	\N	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	LESAUMON  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
667d831b-2e60-456f-833f-d3c070017f12	SAN JUAN B	TEMP-0007	2780	\N	\N	\N	\N	39.94	1204	\N					\N		\N	\N		t	\N	\N	\N
3d4a60f7-6212-4793-983a-545a41ebdf54	SAN JORGE MARTIR	02152	2367	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	56.10	1408	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	PESANFLOR  S.A.	Mar del Plata		489-6522	\N		\N	\N		t	\N	\N	\N
41715a5d-f410-4d09-a198-72bacbe2d8aa	SAN LUCAS  I	06147	\N	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	\N	\N	7a9e4185-6281-4c42-b3c4-1980e6855a31	AGUA MARINA  S.A.	Ciudad Autónoma de Buenos Aires		011-4342-0605 / 5656 / 1709	\N		\N	\N		t	\N	\N	\N
9e841f71-bcdb-46f9-b41d-92ce9e22993a	SAN MATEO	06306	0	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	54.10	1234	a39428a8-f7d6-4716-9c31-99556bfb37f3	IBERPESCA  S.A.	Rawson		0280-449-8176	\N		\N	\N		t	\N	\N	\N
e87dbb1c-fdce-49b2-b48c-ce32d0b84fe7	SAN MATIAS	0289	\N	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	\N	\N	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	PESCA  ANTIGUA  S.A.	Mar del Plata		489-2340	\N		\N	\N		t	\N	\N	\N
2eaad819-6261-4cf1-bcc4-ae875e9803a9	SAN PABLO	0759	\N	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	\N	\N	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	PRODUCTORA ARGEN-PESCA  S.A.	Mar del Plata		480-1444	\N		\N	\N		t	\N	\N	\N
dcaedf09-128f-44ae-b635-4e46831a92e1	SAN PASCUAL	0367	\N	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	\N	\N	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	BUENOS AIRES PESCA  S.A.	Mar del Plata		489-6522	\N		\N	\N		t	\N	\N	\N
b0b89756-9090-4b25-a98b-c594f55c818a	SAN PEDRO APOSTOL	01975	\N	907fd6b2-95a4-42bf-856e-a9b0d99402ea	c682a081-0da5-453f-a40a-2b5c1e1600b4	\N	10	\N	\N	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	GAAD GROUP S.A.	Mar del Plata		480-9327	\N		\N	\N		t	\N	\N	\N
a4f07df7-3710-4b58-b57f-f51b735372d1	SANT ANTONIO	0974	\N	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	\N	\N	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	A.B.H. PESQUERA  S.A.	Mar del Plata	4895032	489-6522	\N	operacionesconsultoramaritima@gmail.com.ar	\N	\N	Agencia Merlini	t	\N	\N	\N
d93ead19-928b-4ac9-92bc-d133ba9a8adb	SANTA BARBARA	5857	2409	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	56.96	1679	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	PESCA ANGELA  S.A.	Mar del Plata		626-2236 /37	\N		\N	\N		t	\N	\N	\N
fb32e3a2-bc0d-44d2-9280-085909bd97d1	SANTA ANGELA	009	\N	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	\N	\N	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	OSTRAMAR  S.A.	Mar del Plata		489-1959	\N		\N	\N		t	\N	\N	\N
a857eac5-3042-4003-87ac-adad2bd693fa	SANTIAGO  I	02280	\N	\N	\N	\N	0	\N	\N	7f1cac29-7e2c-4b6d-8447-1a5a9108fd12	FISHING WORLD  S.A.	Puerto Madryn		0280-445-6533	\N		\N	\N		t	\N	\N	\N
bcef50ab-5f36-4420-b1b0-0854bdfb38d2	SCIROCCO	2574	2430	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	65.93	1589	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	PESQUERA COMERCIAL  S.A.	Mar del Plata		489-3030	\N		\N	\N		t	\N	\N	\N
7c2956ba-e3cc-4fe3-928c-75e69a0cc95c	SCOMBRUS	0509	\N	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	\N	\N	7a9e4185-6281-4c42-b3c4-1980e6855a31	KALEU KALEU  S.A.	Ciudad Autónoma de Buenos Aires		011-3220-2130  / 5093-1215	\N		\N	\N		t	\N	\N	\N
c7255289-b0b1-489e-bfc0-49487297f965	SCOMBRUS  II	02245	\N	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	\N	\N	7f1cac29-7e2c-4b6d-8447-1a5a9108fd12	HARENGUS  S.A.	Puerto Madryn		0280-445-0822	\N		\N	\N		t	\N	\N	\N
0fbe9cea-ba6e-42c7-b476-f31fbc8cb291	SERMILIK	0505	\N	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	\N	\N	7f1cac29-7e2c-4b6d-8447-1a5a9108fd12	HARENGUS  S.A.	Puerto Madryn	4891553-154179360-154179860-154179062	0280-445-0822	\N	agenciasmiriglio@speedy.com.ar	\N	\N	Agencia Smiriglio	t	\N	\N	\N
d4ee3d90-724b-48fd-b3e7-4e92ecd16406	SFIDA	01567	2439	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	26.50	624	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	SAN JORGE S.A.	Mar del Plata		480-6611	\N		\N	\N		t	\N	\N	\N
89c223a5-c981-48a3-87c0-c04789904759	SHUNYO MARU 178	JA04	\N	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	\N	\N	7a9e4185-6281-4c42-b3c4-1980e6855a31	VIEIRA ARGENTINA  S.A.	Ciudad Autónoma de Buenos Aires			\N		\N	\N		t	\N	\N	\N
223e56a9-6027-45bf-a394-6d12ecd1e595	SIEMPRE DON JOSE MOSCUZZA	02257	2460	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	38.00	1128	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	FRESCOMAR ARGENTINA  S.A.	Mar del Plata		489-7287	\N		\N	\N		t	\N	\N	\N
06052685-2683-4053-945d-36acc93038af	SIEMPRE DON VICENTE	02654	2706	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	18.94	341	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	PESQUERA VIRGEN DE ITATI  S.R.L.	Mar del Plata		480-2921	\N		\N	\N		t	\N	\N	\N
ff33c8d5-1b78-4a5e-9e98-aab3038efa85	SIEMPRE SAN SALVADOR	00801	2475	907fd6b2-95a4-42bf-856e-a9b0d99402ea	c682a081-0da5-453f-a40a-2b5c1e1600b4	\N	8	22.35	600	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	LOURDESMAR  S.R.L.	Mar del Plata		476-2916	\N		\N	\N		t	\N	\N	\N
c55045d0-c2fd-421b-ba31-1c6f8f9c3cef	SIEMPRE SANTA ROSA	0494	2476	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	27.80	548	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	GIORNO  S.A.	Mar del Plata		410-0051 / 0057	\N		\N	\N		t	\N	\N	\N
9332b7d1-ef5f-479e-9fbc-0e624288359b	SIEMPRE VIEJO PANCHO	2937	2755	907fd6b2-95a4-42bf-856e-a9b0d99402ea	c682a081-0da5-453f-a40a-2b5c1e1600b4	\N	15	17.98	601	\N					\N		\N	\N		t	\N	\N	\N
e9c432db-71d5-4775-9d87-69821c9bb868	SIMBAD	0754	\N	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	\N	\N	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	SOUTH FISH  S.A.	Mar del Plata		480-5202	\N		\N	\N		t	\N	\N	\N
c2c9cafb-06ad-40dd-889a-91f383a2ad3d	SIRIUS	0905	\N	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	\N	\N	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	LOBA PESQUERA  S.A.M.C.I.	Mar del Plata	4890960	489-0494  /  481-1814	\N	agencia@maritimavidal.com.ar	\N	\N	Agencia Maritima Vidal	t	\N	\N	\N
aca65ab2-e5e7-4657-9d5a-f665087cbc01	SIRIUS II	0936	2489	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	59.25	1289	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	EL MARISCO  S.A.	Mar del Plata	4890960	489-0384	\N	agencia@maritimavidal.com.ar	\N	\N	Agencia Maritima Vidal	t	\N	\N	\N
50cc0f5a-18e9-4d5a-bba6-b36039a479dc	SIRIUS III	0937	\N	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	\N	\N	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	EL MARISCO  S.A.	Mar del Plata	4808331/4808332	489-0384	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
1595a238-fefd-4f9c-bb52-2c6c23127233	SOHO MARU Nº 58	02611	2492	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	65.67	1776	9e97a6b3-cca1-4931-92e9-ab8a5e0b35e1	ARGENOVA  S.A.	Puerto Deseado		0297- 487-0550  (447-2818  Com. Riv )	\N		\N	\N		t	\N	\N	\N
6d30683b-d726-4555-b8d6-725c26c8ad68	SOL MARINO	77	\N	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	\N	\N	7a9e4185-6281-4c42-b3c4-1980e6855a31	PESQUERA  20  DE NOVIEMBRE  S.A.	Ciudad Autónoma de Buenos Aires		011-4382-5011 / 4381-1337	\N		\N	\N		t	\N	\N	\N
aba1432a-2636-4971-8694-03e570875255	STELLA MARIS 1°	0926	\N	fa86a02c-c6bf-4615-ac50-e6a64cb929bb	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	60	\N	\N	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	ALIMENPEZ  S.A.	Mar del Plata		461-9200	\N		\N	\N		t	\N	\N	\N
ea9deb40-ee7d-44e6-9c74-8ac59f761b1c	SUEMAR	6186	2722	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	36.60	1168	7f1cac29-7e2c-4b6d-8447-1a5a9108fd12	CONGELADORES PATAGONICOS  S.A.	Puerto Madryn		0280-445-6280	\N		\N	\N		t	\N	\N	\N
ebf8622b-27a5-4924-a451-8ce5925eb8d2	SUEMAR DOS	01508	\N	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	\N	\N	7f1cac29-7e2c-4b6d-8447-1a5a9108fd12	CONGELADORES PATAGONICOS  S.A.	Puerto Madryn		0280-445-6280	\N		\N	\N		t	\N	\N	\N
7a62f66f-460a-4bcf-805a-de93ffd43e49	SUMATRA	01105	2512	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	33.15	750	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	CALME  S.A.	Mar del Plata		480-3545	\N		\N	\N		t	\N	\N	\N
fb16361c-0954-4d96-a40c-92fb34c82926	SUR ESTE 501	01077	\N	698adf82-00c5-45bf-b669-69edf3bcfa43	c682a081-0da5-453f-a40a-2b5c1e1600b4	\N	30	\N	\N	7a9e4185-6281-4c42-b3c4-1980e6855a31	SUR ESTE ARGEN  S.A.	Ciudad Autónoma de Buenos Aires		011-4816-7648 / 4372-7605	\N		\N	\N		t	\N	\N	\N
3c3d3faf-a2f4-40a1-991c-b89f27388887	SUR ESTE 502	02201	2520	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	54.60	1670	7a9e4185-6281-4c42-b3c4-1980e6855a31	SUR ESTE ARGEN  S.A.	Ciudad Autónoma de Buenos Aires		011-4816-7648 / 4372-7605	\N		\N	\N		t	\N	\N	\N
3b309435-245a-41b1-b314-09f195a7464b	SURIMI I	06143	\N	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	\N	\N	7a9e4185-6281-4c42-b3c4-1980e6855a31	FARO DEL SUR TRADING  S.A.	Ciudad Autónoma de Buenos Aires		011-4555-4956	\N		\N	\N		t	\N	\N	\N
93a61e1d-b320-4ecc-8cd8-bd1a00e59419	TABEIRON	02233	2529	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	40	34.15	889	7a9e4185-6281-4c42-b3c4-1980e6855a31	VIEIRA ARGENTINA  S.A.	Ciudad Autónoma de Buenos Aires			\N		\N	\N		t	\N	\N	\N
bb8e6640-e56e-409e-985c-89533bd20fa7	TABEIRON DOS	02323	\N	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	\N	\N	9e97a6b3-cca1-4931-92e9-ab8a5e0b35e1	PESQUERA DESEADO  S.A.	Puerto Deseado	54-11-65337853	0297-487-0884 / 0327 / 2407	\N		\N	\N	Natalia Cedrato	t	\N	\N	\N
e3a095f0-9da1-41fe-aeda-0b8e55679435	Nº 75 TAE BAEK	02364	2138	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	55.70	1302	7f1cac29-7e2c-4b6d-8447-1a5a9108fd12	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
3fa4b7a9-2eae-4b13-999d-7c89f72a828f	Nº 606 TAE BAEK	02361	2148	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	55.22	1036	7a9e4185-6281-4c42-b3c4-1980e6855a31	ESAMAR  S.A.	Ciudad Autónoma de Buenos Aires		011-4393-8431	\N		\N	\N	54 – 9 - 1141714381	t	\N	\N	\N
7b475623-c048-4393-9665-161c9abc19bb	TAI AN	1530	2533	84e1586f-ab60-4e9c-93e6-bc73183f8b27	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	60	100.50	4506	7a9e4185-6281-4c42-b3c4-1980e6855a31	PRODESUR S.A	Ciudad Autónoma de Buenos Aires		492-2216 / 492-0450	\N		\N	\N	54 – 9 - 1141714381	t	\N	\N	\N
7e596bdc-2515-4080-87b6-9b07884fd0de	TAI SEI MARU N°8	02207	\N	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	\N	\N	7a9e4185-6281-4c42-b3c4-1980e6855a31	CORPORACION DEL ATLANTICO SUR  S.A.	Ciudad Autónoma de Buenos Aires		011-4105-1133 int 30	\N		\N	\N		t	\N	\N	\N
e66a062b-3a45-45d5-b793-6512dcfede67	TALISMAN	02263	2541	c7afdae7-d068-45a9-a855-1011df4d2f92	984dfcf6-1b60-40c7-b703-9616ab048651	c2c3c456-5f2c-47a2-a8af-d41dc148a19f	30	49.95	1302	7a9e4185-6281-4c42-b3c4-1980e6855a31	CENTOMAR  S.A.	Ciudad Autónoma de Buenos Aires		011-4816-6245 / 6260  int  * 35	\N		\N	\N		t	\N	\N	\N
1b8366ae-3011-41d8-a507-785e851a07d7	TANGO I	02724	2709	c7afdae7-d068-45a9-a855-1011df4d2f92	984dfcf6-1b60-40c7-b703-9616ab048651	c2c3c456-5f2c-47a2-a8af-d41dc148a19f	30	50.40	1302	7a9e4185-6281-4c42-b3c4-1980e6855a31	BENTONICOS DE ARGENTINA  S.A.	Ciudad Autónoma de Buenos Aires		011-5258-2400 / 4407-8240	\N		\N	\N		t	\N	\N	\N
162625cb-67c1-47b0-a0f8-fe3863335702	TANGO II	02791	2714	c7afdae7-d068-45a9-a855-1011df4d2f92	984dfcf6-1b60-40c7-b703-9616ab048651	c2c3c456-5f2c-47a2-a8af-d41dc148a19f	30	50.40	1302	7a9e4185-6281-4c42-b3c4-1980e6855a31	BENTONICOS DE ARGENTINA  S.A.	Ciudad Autónoma de Buenos Aires	4891227	011-5258-2400 / 4407-8240	\N	serviciosmaritimosmdq@gmail.com	\N	\N	Servicios maritimos	t	\N	\N	\N
992f86e6-0d45-48b5-b2a0-917a7bb91e72	TESON	01541	2552	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	25.97	765	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	RITORNO SALLUSTIO Y CICCIOTTI  S.A.	Mar del Plata		480-5508	\N		\N	\N		t	\N	\N	\N
e892c340-d0bd-48e4-bfa4-f38a19fc2704	TIAN YUAN	02173	\N	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	\N	\N	7a9e4185-6281-4c42-b3c4-1980e6855a31	CORPORACION DEL ATLANTICO SUR  S.A.	Ciudad Autónoma de Buenos Aires		011-4105-1133 int 30	\N		\N	\N		t	\N	\N	\N
42f2e859-cc28-4412-81e1-c815e5b3c4d8	TOBA MARU	0241	\N	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	\N	\N	7f1cac29-7e2c-4b6d-8447-1a5a9108fd12	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
4b1e49ad-f106-46cd-be0c-3084e36737a3	TORNYY	240	\N	c7afdae7-d068-45a9-a855-1011df4d2f92	984dfcf6-1b60-40c7-b703-9616ab048651	c2c3c456-5f2c-47a2-a8af-d41dc148a19f	30	\N	\N	7a9e4185-6281-4c42-b3c4-1980e6855a31	CRUSTACEOS DEL SUR  S.A.	Ciudad Autónoma de Buenos Aires		011-5218-4287	\N		\N	\N		t	\N	\N	\N
f6a1aa39-9940-46e0-9b81-1a2949a9a361	TOZUDO	01219	2566	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	26.74	624	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	CABO VERDE  S.A.	Mar del Plata		489-4645	\N		\N	\N		t	\N	\N	\N
1de596a4-863b-4b5f-9220-a61386f21312	TRABAJAMOS	02904	2726	907fd6b2-95a4-42bf-856e-a9b0d99402ea	c682a081-0da5-453f-a40a-2b5c1e1600b4	\N	4	19.94	592	9e97a6b3-cca1-4931-92e9-ab8a5e0b35e1	DESEADO FISH  S.A.	Puerto Deseado			\N		\N	\N		t	\N	\N	\N
99975f80-6ddc-4ea8-8348-14aa1726f996	UCHI	01901	2580	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	54.23	1552	7a9e4185-6281-4c42-b3c4-1980e6855a31	PESQUERA SANTA ELENA S.A.I.C.	Ciudad Autónoma de Buenos Aires		011-4328-9909	\N		\N	\N		t	\N	\N	\N
e60de42f-a17a-4c49-b409-457f5d599aef	UNION	01539	\N	907fd6b2-95a4-42bf-856e-a9b0d99402ea	c682a081-0da5-453f-a40a-2b5c1e1600b4	\N	10	\N	\N	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	RITORNO SALLUSTIO Y CICCIOTTI  S.A.	Mar del Plata		480-5508	\N		\N	\N		t	\N	\N	\N
5d174e20-1663-4cd3-aa25-c02083b9e7d7	URABAIN	0612	\N	fa86a02c-c6bf-4615-ac50-e6a64cb929bb	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	60	\N	\N	7f1cac29-7e2c-4b6d-8447-1a5a9108fd12	IBERCONSA  DE ARGENTINA  S.A.	Puerto Madryn	mariano@maritimavidal.com.ar	0280-445-4324	\N		\N	\N	raul@maritimavidal.com.ar	t	\N	\N	\N
f06eb6fd-515b-4baa-a34d-f9a5457f5a49	UR ERTZA	0377	2587	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	51.00	1482	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	LUIS SOLIMENO e HIJOS  S.A.	Mar del Plata		489-3030	\N		\N	\N		t	\N	\N	\N
a4b9f103-11d4-4db6-b534-fa192278eac8	VALIENTE I	0211A	\N	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	\N	\N	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	EXPLOTACION PESQ. DE LA PATAGONIA  S.A.	Mar del Plata		489-4624  /  489-0314 (astillero)	\N		\N	\N		t	\N	\N	\N
812b2bc1-1a8b-46a4-9d8a-70ae2f7c7e92	VALIENTE II	0212A	2718	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	35.30	1001	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	EXPLOTACION PESQ. DE LA PATAGONIA  S.A.	Mar del Plata		489-4624  /  489-0314 (astillero)	\N		\N	\N	agencia@maritimavidal.com.ar	t	\N	\N	\N
9c59f952-3a5c-4e28-9b53-0abce704c1ad	VENTARRON 1º	0479	2708	fa86a02c-c6bf-4615-ac50-e6a64cb929bb	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	60	63.07	1969	7f1cac29-7e2c-4b6d-8447-1a5a9108fd12	ATUNERA  ARGENTINA  S.A.	Puerto Madryn		0280-445-4324	\N		\N	\N		t	\N	\N	\N
460893cd-8b88-4947-8724-63148f844677	VERAZ	0144	2603	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	27.45	604	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	PESQUERA VERAZ  S.A.	Mar del Plata		489-4624 / 489-0314 (astillero)	\N		\N	\N		t	\N	\N	\N
c6a12cdc-cf76-4220-98fc-6e2e8efd1bf9	VERDEL	0174	2604	fa86a02c-c6bf-4615-ac50-e6a64cb929bb	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	60	71.70	1975	260e778c-d7a5-4509-938b-9bd69004656f	IBERMAR  S.A.	Bahia Blanca		0291-457-2427	\N		\N	\N		t	\N	\N	\N
e5faf6ac-0116-4806-87b1-4048406df4bf	VERONICA ALEJANDRA N	02292	2606	907fd6b2-95a4-42bf-856e-a9b0d99402ea	c682a081-0da5-453f-a40a-2b5c1e1600b4	\N	4	15.30	223	a39428a8-f7d6-4716-9c31-99556bfb37f3	FARO CHUBUT  S.R.L.	Rawson		0280-449-6311	\N		\N	\N		t	\N	\N	\N
7d3d8836-5ee2-4567-b7cc-e84e875d60e1	VICTOR ANGELESCU	9798820	\N	a5778547-a20e-4929-a1a6-c0aab7f0466c	\N	\N	\N	\N	\N	\N	INIDEP				\N		\N	\N		t	\N	\N	\N
6ebd0882-611f-4573-af02-ea11389b2de3	VICTORIA DEL MAR 1°	0929	\N	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	\N	\N	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	RIPSA  S.A. ( ROSALES INDUSTRIAL PESQ. )	Mar del Plata		489-7881	\N		\N	\N		t	\N	\N	\N
a781f236-4016-4f95-bbad-3231c0903df3	VICTORIA I	0554	\N	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	\N	\N	7f1cac29-7e2c-4b6d-8447-1a5a9108fd12	PEREIRA  ARGENTINA  S.A.	Puerto Madryn		0280-445-7377 / 447-2249	\N		\N	\N		t	\N	\N	\N
2bf0bbad-350e-4cb0-9bd7-97191d01c56b	VICTORIA II	0556	2611	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	27.40	601	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	CRESTAS  S.A.	Mar del Plata		410-5170	\N		\N	\N		t	\N	\N	\N
e2e506af-42f5-4899-b209-5722801cdc76	VICTORIA P	02246	\N	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	\N	\N	7a9e4185-6281-4c42-b3c4-1980e6855a31	PESQUERA SANTA ELENA S.A.I.C.	Ciudad Autónoma de Buenos Aires		011-4328-9909	\N		\N	\N		t	\N	\N	\N
f7214232-2f54-4eb4-bd67-e9060cd0773a	VIEIRASA DIECIOCHO	2563	2615	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	67.78	1803	7a9e4185-6281-4c42-b3c4-1980e6855a31	VIEIRA ARGENTINA  S.A.	Ciudad Autónoma de Buenos Aires			\N		\N	\N		t	\N	\N	\N
29b31b1e-3e42-4267-b85e-39df3579ebb3	VIEIRASA DIECISEIS	0240	2616	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	36.13	702	7a9e4185-6281-4c42-b3c4-1980e6855a31	VIEIRA ARGENTINA  S.A.	Ciudad Autónoma de Buenos Aires			\N		\N	\N		t	\N	\N	\N
01e67326-813d-4e77-94cf-f5ebc1f91074	VIEIRASA DIECISIETE	2568	2752	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	59.03	1401	7a9e4185-6281-4c42-b3c4-1980e6855a31	VIEIRA ARGENTINA  S.A.	Ciudad Autónoma de Buenos Aires			\N		\N	\N		t	\N	\N	\N
9a2e11d0-cd2e-4bbc-959e-09552da52af0	VIEIRASA QUINCE	0179	\N	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	\N	\N	7a9e4185-6281-4c42-b3c4-1980e6855a31	VIEIRA ARGENTINA  S.A.	Ciudad Autónoma de Buenos Aires			\N		\N	\N		t	\N	\N	\N
32d87892-8784-416b-8738-0aecae8cb9b5	VIENTO DEL SUR	01858	\N	280a7409-6bb5-4e36-bad1-93194d72bb82	c682a081-0da5-453f-a40a-2b5c1e1600b4	089b0ead-176b-4e7a-b99d-5caeea74ea61	60	\N	\N	9e97a6b3-cca1-4931-92e9-ab8a5e0b35e1	PESPASA  S.A.	Puerto Deseado		0297-487-2030  int 12	\N		\N	\N		t	\N	\N	\N
c76f1740-750c-49ec-a555-25756c7516f8	VILLARINO	02178	2629	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	64.50	1776	bf2cad5e-9886-4737-bb0e-cb3a0376a5d9	PESCA AUSTRAL  S.A.	San Antonio Oeste		02934-49-2111	\N		\N	\N		t	\N	\N	\N
48e1f805-1cdb-48b8-b3c8-5ee57a94b669	VIRGEN DEL CARMEN	0550	\N	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	\N	\N	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	MAR PURO  S.A.	Mar del Plata		451-1830	\N		\N	\N		t	\N	\N	\N
59c7a1d9-e42a-4a82-b96a-49e1b571859e	VIRGEN DEL MILAGRO	02767	2725	907fd6b2-95a4-42bf-856e-a9b0d99402ea	c682a081-0da5-453f-a40a-2b5c1e1600b4	\N	4	19.93	380	9e97a6b3-cca1-4931-92e9-ab8a5e0b35e1	UNION PESQUERA PATAGONIA  S.A.	Puerto Deseado			\N		\N	\N		t	\N	\N	\N
ceca0764-0b14-4c6d-b04a-fff52ecbaa4f	VIRGEN DEL ROCIO	0194	\N	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	\N	\N	7f1cac29-7e2c-4b6d-8447-1a5a9108fd12	ALPESCA  S.A.	Puerto Madryn		0280-447-4958 / 45-1069	\N		\N	\N		t	\N	\N	\N
a461832c-2de1-482e-9856-9c0e8ec1971a	VIRGEN MARIA	0541	2645	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	56.65	1803	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	LUIS SOLIMENO e HIJOS  S.A.	Mar del Plata		489-3030	\N		\N	\N		t	\N	\N	\N
717cbca4-8c8a-4a0d-8a1e-0371887dbc11	VIRGEN MARIA INMACULADA	0369	\N	907fd6b2-95a4-42bf-856e-a9b0d99402ea	c682a081-0da5-453f-a40a-2b5c1e1600b4	\N	10	\N	\N	\N					\N		\N	\N		t	\N	\N	\N
18f69c53-de1c-45a7-8a84-e4181f4f002f	WIRON  IV	01476	\N	a9be216d-5261-4420-88d9-bf7dc1661bd7	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	30	\N	\N	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	TATURIELLO  S.A.	Mar del Plata		489-3833	\N		\N	\N		t	\N	\N	\N
80d44be2-cea8-40ac-ae69-b2cfba186948	XEITOSIÑO	0403	2668	fa86a02c-c6bf-4615-ac50-e6a64cb929bb	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	60	51.72	1502	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	PESQUERA EL NAZARENO	Mar del Plata		489-9414 (of. Pers. Emb.)	\N		\N	\N		t	\N	\N	\N
2e4b6b62-ba54-46f3-af03-cb7713673a14	XIN SHI DAI N° 28	02165	2669	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	62.40	1579	7a9e4185-6281-4c42-b3c4-1980e6855a31	MUELLE OCHO  S.A.	Ciudad Autónoma de Buenos Aires		011-4381-1337	\N		\N	\N		t	\N	\N	\N
200073b0-ab75-49fa-9478-54905fe75baf	XIN SHI JI 25	03092	2753	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	70.50	0	7a9e4185-6281-4c42-b3c4-1980e6855a31	PESQUERA  20  DE NOVIEMBRE  S.A.	Ciudad Autónoma de Buenos Aires		011-4382-5011 / 4381-1337	\N		\N	\N		t	\N	\N	\N
75874cf4-feaa-41a9-80f6-9051f03e8603	XIN SHI JI N° 88	02182	\N	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	\N	\N	7a9e4185-6281-4c42-b3c4-1980e6855a31	FENIX  INTERNATIONAL  S.A.	Ciudad Autónoma de Buenos Aires		011-4381-1337	\N		\N	\N		t	\N	\N	\N
ce653dbb-b4df-420f-b2d3-8fa234248170	XIN SHI JI Nº 89	02903	2750	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	68.58	2685	7a9e4185-6281-4c42-b3c4-1980e6855a31	FENIX  INTERNATIONAL  S.A.	Ciudad Autónoma de Buenos Aires		011-4381-1337	\N		\N	\N		t	\N	\N	\N
351c9dd0-3101-498b-b4c8-3051321a7d91	XIN SHI JI Nº 91	02924	2724	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	68.58	2685	7a9e4185-6281-4c42-b3c4-1980e6855a31	FENIX  INTERNATIONAL  S.A.	Ciudad Autónoma de Buenos Aires		011-4381-1337	\N		\N	\N		t	\N	\N	\N
4a9c9d5c-346c-42b0-8409-518f2854ea80	XIN SHI JI Nº 92	02930	2742	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	68.58	2685	7a9e4185-6281-4c42-b3c4-1980e6855a31	FENIX  INTERNATIONAL  S.A.	Ciudad Autónoma de Buenos Aires		011-4381-1337	\N		\N	\N		t	\N	\N	\N
bae08a79-5f21-4e12-9cee-3f537e8cad7f	XIN SHI JI Nº 95	02933	2732	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	68.58	2685	7a9e4185-6281-4c42-b3c4-1980e6855a31	PESQUERA  20  DE NOVIEMBRE  S.A.	Ciudad Autónoma de Buenos Aires	155-282636 - Facundo	011-4382-5011 / 4381-1337	\N		\N	\N	Agencia Di Yorio	t	\N	\N	\N
35bfb746-2385-4bf1-9323-1b919ed94700	XIN SHI JI N° 99	02181	2674	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	65.10	2173	7a9e4185-6281-4c42-b3c4-1980e6855a31	FENIX  INTERNATIONAL  S.A.	Ciudad Autónoma de Buenos Aires		011-4381-1337	\N		\N	\N		t	\N	\N	\N
95296cfd-e12f-4ff7-aa0a-09208dd3d190	XIN SHI JI Nº 98	02995	\N	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	\N	\N	7a9e4185-6281-4c42-b3c4-1980e6855a31	PESQUERA  20  DE NOVIEMBRE  S.A.	Ciudad Autónoma de Buenos Aires		011-4382-5011 / 4381-1337	\N		\N	\N		t	\N	\N	\N
d992cfe8-17ce-4bf3-b024-8bc48b6b9283	YAMATO	077	\N	84e1586f-ab60-4e9c-93e6-bc73183f8b27	c682a081-0da5-453f-a40a-2b5c1e1600b4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	60	\N	\N	a269cdaa-b6a8-4b05-b44a-042cd68106e4	PESANTAR  S.A. ( Empresa Pesq de la Patagonia y Antartida )	Ushuaia		02901-43-3449 / 43-0008 / 43-0708	\N		\N	\N		t	\N	\N	\N
dfdfa892-555e-4f53-83c3-4d1bb6eb9a0c	YENU	0498A	\N	76e36cfe-e917-4625-889b-96d633961480	e0913412-884d-4103-97b7-3eceac842fcf	daccfce7-5e1e-4429-8f97-600fe78a1855	30	\N	\N	260e778c-d7a5-4509-938b-9bd69004656f	MARITIMA MONACHESI  S.A.	Bahia Blanca		0291-452-5913	\N		\N	\N		t	\N	\N	\N
855093dc-d744-48d4-a40b-5a190f3239a2	YOKO MARU	UY252	\N	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	\N	\N	7a9e4185-6281-4c42-b3c4-1980e6855a31	EMPESUR  S.A.	Ciudad Autónoma de Buenos Aires		011-4312-0123	\N		\N	\N		t	\N	\N	\N
3aa93a0a-3f33-4897-86ff-70514f6170a2	ZHOU YU YI HAO	CH251	\N	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	\N	\N	7a9e4185-6281-4c42-b3c4-1980e6855a31	VIEIRA ARGENTINA  S.A.	Ciudad Autónoma de Buenos Aires			\N		\N	\N		t	\N	\N	\N
eda21e0e-e9e5-4526-8be8-8505e8d7d6de	HOLMBERG	7918189	\N	a5778547-a20e-4929-a1a6-c0aab7f0466c	\N	\N	\N	\N	\N	\N	INIDEP				\N		\N	\N		t	\N	\N	\N
11578da1-9f4e-422d-adac-217138f236d0	MAR ARGENTINO	9883833	\N	a5778547-a20e-4929-a1a6-c0aab7f0466c	\N	\N	\N	\N	\N	\N	INIDEP				\N		\N	\N		t	\N	\N	\N
616414ba-12f1-4f6d-b63f-911478c934c7	Hai Xiang 16	LW5157	\N	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	\N	\N	\N	PESQUERA RÍO QUEQUEN				\N		\N	\N		t	\N	\N	\N
46a7a07a-8cb8-4e8a-8573-61804a3a63d3	Hai Xiang 17	LW3286	\N	ae0629e2-d22a-4557-8687-b3ffa6b2556e	d6ab9970-b7e3-4d51-b1ce-de5c11c77e16	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	40	\N	\N	\N	PESQUERA RÍO QUEQUEN				\N		\N	\N		t	\N	\N	\N
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
9c983fdd-8ec1-4853-8ab6-2b5239942c83	2026-01-03 20:03:01.764+00	ERROR	BACKEND	GlobalExceptionFilter	7755cefe-79f3-468f-941a-90385b74f373	admin@obs.com	Token not valid	UnauthorizedException: Token not valid\n    at JwtStrategy.validate (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\auth\\strategies\\jwt.strategy.ts:31:19)\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async JwtStrategy.callback [as _verify] (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+passport@11.0.5_@ne_3e2e1635e1fc880657f155ecf43895f0\\node_modules\\@nestjs\\passport\\dist\\passport\\passport.strategy.js:13:44)	{"query": {"year": "2025"}, "params": {}, "exception": {"error": "Unauthorized", "message": "Token not valid", "statusCode": 401}}	/api/mareas/operativo?year=2025	GET	::1
3d0ecc01-de15-45e5-b24c-c4ba712b1178	2026-01-03 20:03:01.794+00	ERROR	BACKEND	GlobalExceptionFilter	7755cefe-79f3-468f-941a-90385b74f373	admin@obs.com	Token de refresco inválido o expirado	UnauthorizedException: Token de refresco inválido o expirado\n    at AuthService.refreshAuth (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\auth\\auth.service.ts:230:13)\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async AuthController.refreshAuth (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\auth\\auth.controller.ts:58:18)\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:46:28\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-proxy.js:9:17	{"query": {}, "params": {}, "exception": {"error": "Unauthorized", "message": "Token de refresco inválido o expirado", "statusCode": 401}}	/api/auth/refresh	GET	::1
837b09c9-d72c-40d4-8b73-2f51ee666860	2026-01-03 20:12:25.039+00	ERROR	BACKEND	GlobalExceptionFilter	\N	\N	No valid Refresh Token found	UnauthorizedException: No valid Refresh Token found\n    at AuthController.refreshAuth (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\auth\\auth.controller.ts:56:30)\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:38:29\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:46:28\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-proxy.js:9:17	{"query": {}, "params": {}, "exception": {"error": "Unauthorized", "message": "No valid Refresh Token found", "statusCode": 401}}	/api/auth/refresh	GET	::1
a764fc53-5283-4e95-8ae9-15d1f183c881	2026-01-03 21:53:56.265+00	ERROR	BACKEND	GlobalExceptionFilter	c200b0d0-2928-464a-8644-de6b36f6b7f5	admin@obs.com	Unauthorized	UnauthorizedException: Unauthorized\n    at MixinAuthGuard.handleRequest (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+passport@11.0.5_@ne_3e2e1635e1fc880657f155ecf43895f0\\node_modules\\@nestjs\\passport\\dist\\auth.guard.js:60:30)\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+passport@11.0.5_@ne_3e2e1635e1fc880657f155ecf43895f0\\node_modules\\@nestjs\\passport\\dist\\auth.guard.js:44:124\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+passport@11.0.5_@ne_3e2e1635e1fc880657f155ecf43895f0\\node_modules\\@nestjs\\passport\\dist\\auth.guard.js:83:24\n    at allFailed (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\passport@0.7.0\\node_modules\\passport\\lib\\middleware\\authenticate.js:110:18)\n    at attempt (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\passport@0.7.0\\node_modules\\passport\\lib\\middleware\\authenticate.js:183:28)\n    at strategy.fail (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\passport@0.7.0\\node_modules\\passport\\lib\\middleware\\authenticate.js:314:9)\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\passport-jwt@4.0.1\\node_modules\\passport-jwt\\lib\\strategy.js:106:33\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\jsonwebtoken@9.0.3\\node_modules\\jsonwebtoken\\verify.js:190:16\n    at getSecret (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\jsonwebtoken@9.0.3\\node_modules\\jsonwebtoken\\verify.js:97:14)\n    at module.exports [as verify] (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\jsonwebtoken@9.0.3\\node_modules\\jsonwebtoken\\verify.js:101:10)	{"query": {}, "params": {}, "exception": {"message": "Unauthorized", "statusCode": 401}}	/api/catalogos/observadores	GET	::1
c792d620-00fe-46c6-b239-72da7584e983	2026-01-03 23:01:21.083+00	ERROR	BACKEND	GlobalExceptionFilter	\N	\N	Credenciales inválidas	UnauthorizedException: Credenciales inválidas\n    at AuthService.login (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\auth\\auth.service.ts:56:22)\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async AuthController.loginUser (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\auth\\auth.controller.ts:41:18)\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:46:28\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-proxy.js:9:17	{"body": {"email": "danieldt2000@hotmail.com", "password": "Daniel2808", "remember": false}, "query": {}, "params": {}, "exception": {"error": "Unauthorized", "message": "Credenciales inválidas", "statusCode": 401}}	/api/auth/login	POST	::1
c0d2a8a3-a81b-4af0-8b8b-d36c5a371344	2026-01-03 23:02:10.335+00	ERROR	BACKEND	GlobalExceptionFilter	\N	\N	No valid Refresh Token found	UnauthorizedException: No valid Refresh Token found\n    at AuthController.refreshAuth (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\auth\\auth.controller.ts:56:30)\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:38:29\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:46:28\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-proxy.js:9:17	{"query": {}, "params": {}, "exception": {"error": "Unauthorized", "message": "No valid Refresh Token found", "statusCode": 401}}	/api/auth/refresh	GET	::ffff:127.0.0.1
775d40ad-18d8-441b-8c97-31f0348e57bb	2026-01-03 23:07:12.392+00	ERROR	BACKEND	GlobalExceptionFilter	\N	\N	No valid Refresh Token found	UnauthorizedException: No valid Refresh Token found\n    at AuthController.refreshAuth (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\auth\\auth.controller.ts:56:30)\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:38:29\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:46:28\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-proxy.js:9:17	{"query": {}, "params": {}, "exception": {"error": "Unauthorized", "message": "No valid Refresh Token found", "statusCode": 401}}	/api/auth/refresh	GET	::ffff:127.0.0.1
\.


--
-- Data for Name: especies; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.especies (id, codigo, nombre_cientifico, nombre_vulgar, activo, observaciones) FROM stdin;
012eed40-77dc-42f0-aba8-5aec9e830ef8	0000000001	Genypterus blacodes	Abadejo	t	\N
8eb2857f-7058-45d2-9e2e-45869e5c1cff	0000000002	Engraulis anchoita	Anchoíta	t	\N
5f3219d6-2505-4507-b165-3f0727f00f59	0000000003	Scomber japonicus	Caballa	t	\N
1ded06f2-0f22-4c2c-a354-e47e866396ce	0000000004	Illex argentinus	Calamar	t	\N
c90de399-9d19-47c6-ace6-c3eb4d188289	0000000005	Lithodes santolla	Centolla	t	\N
d05b7b30-fa91-4afb-9f55-bb0c0d25639b	0000000006	-	Especies australes	t	\N
343bf9e1-e4a8-4994-acce-8aed4f0cc687	0000000007	Pleoticus muelleri	Langostino	t	\N
38d3d9de-9d9c-45a9-8d8b-aa2fdae2446a	0000000008	Merluccius hubbsi	Merluza común	t	\N
62492ca6-3b42-417f-b3aa-a5659c1cc5c4	0000000009	Dissostichus eleginoides	Merluza negra	t	\N
b7fe8026-df02-459a-8291-3d9d86104ab1	0000000010	Zygochlamys patagonica	Vieira	t	\N
\.


--
-- Data for Name: estados_marea; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.estados_marea (id, codigo, nombre, descripcion, categoria, orden, es_inicial, es_final, permite_carga_archivos, permite_correccion, permite_informe, activo, mostrar_en_panel) FROM stdin;
ea2252eb-8229-4d52-9648-479058ec4334	DESIGNADA	Designada	\N	PENDIENTE	1	t	f	f	f	f	t	t
0b21451e-e14c-421e-8387-5478e7a4ad88	EN_EJECUCION	En ejecución	\N	PENDIENTE	2	f	f	f	f	f	t	t
e9c85d8e-268f-4598-bc6b-f9f2917be914	ESPERANDO_ENTREGA	Esperando entrega de datos	\N	PENDIENTE	3	f	f	f	f	f	t	t
b5debf35-2531-4f42-8a6a-cd295ec1fb33	ENTREGADA_RECIBIDA	Entregada / Recibida	\N	PENDIENTE	4	f	f	t	f	f	t	t
11810d0f-0cd0-4d6d-b4eb-82d8141000e5	VERIFICACION_INICIAL	Verificación inicial	\N	EN_CURSO	5	f	f	t	f	f	t	t
1a92188f-0134-49f5-a204-b1941caca842	EN_CORRECCION	En corrección interna	\N	EN_CURSO	6	f	f	t	t	f	t	t
16f52513-8de7-44e2-bc87-2c8fff885585	DELEGADA_EXTERNA	Delegada / En espera externa	\N	EN_CURSO	7	f	f	t	f	f	t	f
ba3abe89-7ba1-4cd4-bd2c-8d37512dfcac	PENDIENTE_DE_INFORME	Pendiente de informe	\N	EN_CURSO	8	f	f	f	f	t	t	t
2ec4b69f-5760-473c-84eb-5e3d72b868f8	ESPERANDO_REVISION	Esperando revisión de informe	\N	EN_CURSO	9	f	f	f	f	t	t	f
6df7c4fd-8134-4cd6-8867-b928bb0c0ef0	PARA_PROTOCOLIZAR	Para protocolizar	\N	EN_CURSO	10	f	f	f	f	t	t	f
aa64a6e6-dfd3-4af9-9c1b-31309f0ed844	ESPERANDO_PROTOCOLIZACION	Esperando protocolización	\N	EN_CURSO	11	f	f	f	f	t	t	f
1617c3f4-2ae6-482a-9710-067e2d0c6e50	PROTOCOLIZADA	Protocolizada / Finalizada	\N	COMPLETADO	12	f	t	f	f	t	t	f
eb8ce446-7d4b-4eb8-a953-8a8fbcc7a912	CANCELADA	Cancelada / Desestimada	\N	CANCELADO	13	f	t	f	f	f	t	f
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
cac9ff30-b7a2-430e-920d-ec89a5224332	2025	183	2336cdf4-d30d-4904-bc30-e0165b221291	\N	0b21451e-e14c-421e-8387-5478e7a4ad88	2025-11-20 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.775+00	2026-01-03 20:11:19.775+00	t	Importada de JSONL. Empresa: CRUSTACEOS DEL SUR S.A. Especie: CENTOLLA	MC	50
79d71507-6e64-4d6f-a48d-af5da075f9a2	2025	1	1b2b11d3-0322-49b4-a9c7-0eb48734747a	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-01-03 03:00:00+00	\N	\N	32	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:18.355+00	2026-01-03 20:11:18.355+00	t	Importada de JSONL. Empresa: ESTREMAR. Especie: MERLUZA AUSTRAL	MC	60
b19e3191-7c87-44eb-beb9-e5e33634a4b6	2025	2	365e6078-51de-4e30-9183-8877176fad16	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-01-03 03:00:00+00	\N	\N	23	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:18.381+00	2026-01-03 20:11:18.381+00	t	Importada de JSONL. Empresa: ARGENOVA. Especie: MERLUZA AUSTRAL	MC	60
a96b66ee-3be2-41fb-bc15-258979642704	2025	3	a8750dc5-73de-4af6-8256-02c3d4f0e31b	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-01-03 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:18.393+00	2026-01-03 20:11:18.393+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: CENTOLLA	MC	30
7da900d7-acb6-478b-a2ff-6a301155e127	2025	4	e651d472-1996-4202-9306-3798541fe779	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-01-12 03:00:00+00	\N	\N	4	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:18.405+00	2026-01-03 20:11:18.405+00	t	Importada de JSONL. Empresa: PEDRO MOSCUZZA E HIJO. Especie: MERLUZA	MC	30
6e4427b7-30e3-4677-9078-24dfc13e451f	2025	5	f9b08767-3d42-493b-9603-364ffc399a34	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-01-08 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:18.418+00	2026-01-03 20:11:18.418+00	t	Importada de JSONL. Empresa: PESQUERA GEMINIS. Especie: MERLUZA	MC	30
31862f6a-a5ff-4768-9caf-9277b82860b3	2025	6	faa23ec7-3f06-44ab-beaa-f730e9f5f4b1	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-01-09 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:18.429+00	2026-01-03 20:11:18.429+00	t	Importada de JSONL. Empresa: PESQUERA CERES. Especie: CALAMAR	MC	30
19657885-b7e0-4426-99fe-d8e94ee120df	2025	7	1595a238-fefd-4f9c-bb52-2c6c23127233	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-01-07 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:18.438+00	2026-01-03 20:11:18.438+00	t	Importada de JSONL. Empresa: ARGENOVA. Especie: CALAMAR	MC	30
637f2025-7f23-4b6e-9c11-1692fb5a2192	2025	8	a461832c-2de1-482e-9856-9c0e8ec1971a	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-01-09 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:18.447+00	2026-01-03 20:11:18.447+00	t	Importada de JSONL. Empresa: LUIS SOLIMENO. Especie: MERLUZA	MC	30
4c9381f2-8774-4df2-8a50-6a57229b1041	2025	9	1ce502d2-13cb-49f0-9d02-ef4d85866967	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-01-06 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:18.459+00	2026-01-03 20:11:18.459+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: VIEIRA	MC	30
37cd6141-84d3-46b1-9af3-7e856284a14f	2025	10	467088f6-e25d-4770-8b96-502514b918cb	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-01-11 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:18.468+00	2026-01-03 20:11:18.468+00	t	Importada de JSONL. Empresa: GLACIAR PESQUERA. Especie: VIEIRA	MC	30
04759b5e-6bde-4e81-b6d7-1501cc192aae	2025	11	87f926dd-849a-445d-a8ef-30097f382ded	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-01-08 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:18.475+00	2026-01-03 20:11:18.475+00	t	Importada de JSONL. Empresa: FOOD ARTZ S.A.. Especie: CALAMAR	MC	30
b51443fd-d991-40ad-825e-3930af96862e	2025	12	dff0c01d-8ae6-4b3c-a2a1-84be475e6107	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-01-09 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:18.483+00	2026-01-03 20:11:18.483+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: VIEIRA	MC	30
7bb3e592-e81e-48cf-ae66-85e6e4dd3595	2025	13	ab56f62f-e6a5-49b3-a21c-f6ca96d78770	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-01-09 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:18.49+00	2026-01-03 20:11:18.49+00	t	Importada de JSONL. Empresa: FOOD PARTNERS PATAGONIA. Especie: CENTOLLA	MC	30
b3ebd708-536a-4447-9770-ff47a412ad09	2025	14	5a662438-6668-40c2-956e-d514528c0109	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-01-09 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:18.498+00	2026-01-03 20:11:18.498+00	t	Importada de JSONL. Empresa: PEDRO MOSCUZZA E HIJO. Especie: CALAMAR	MC	30
8f535c0d-5e9d-4653-9ab5-fb318e8d1acd	2025	15	7cf6a359-27ac-42d4-9ebd-e2ce3ebc8d3b	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-01-11 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:18.504+00	2026-01-03 20:11:18.504+00	t	Importada de JSONL. Empresa: PESQUERA VERAZ. Especie: MERLUZA	MC	30
1bdd5d86-c5e7-43c1-8dd9-121854f820df	2025	16	022693f1-d736-45eb-9fcd-7f21eeb8d382	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-01-16 03:00:00+00	\N	\N	11	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:18.518+00	2026-01-03 20:11:18.518+00	t	Importada de JSONL. Empresa: GLACIAR PESQUERA. Especie: VIEIRA	MC	30
cfef1c13-486c-4215-89a3-227b00dcce5f	2025	17	b9cc9ddf-c507-4bdf-97d8-96eb080f205b	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-01-17 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:18.525+00	2026-01-03 20:11:18.525+00	t	Importada de JSONL. Empresa: ALTAMARE S.AS. Especie: CALAMAR	MC	30
ec5d55b0-f3f0-43ca-a17a-6ef8e501566e	2025	18	6d430cc1-8ec0-4e4a-b68b-facb3798d18d	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-01-17 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:18.533+00	2026-01-03 20:11:18.533+00	t	Importada de JSONL. Empresa: ALTAMARE S.AS. Especie: CALAMAR	MC	30
6b062594-8807-4232-9d01-711e34cee3b5	2025	19	1b8366ae-3011-41d8-a507-785e851a07d7	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-01-28 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:18.54+00	2026-01-03 20:11:18.54+00	t	Importada de JSONL. Empresa: BENTONICOS DE ARGENTINA. Especie: CENTOLLA	MC	30
ade9f2b1-ba03-4d4a-b2c8-fd2597bddd04	2025	20	faa23ec7-3f06-44ab-beaa-f730e9f5f4b1	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-01-28 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:18.547+00	2026-01-03 20:11:18.547+00	t	Importada de JSONL. Empresa: GIORNO. Especie: CALAMAR	MC	30
d7e4e28b-0bcd-4fde-8c7f-3ca450f56f5b	2025	21	7a4a43c8-4078-4f8e-b0a5-90f8de5d9acd	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-02-04 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:18.555+00	2026-01-03 20:11:18.555+00	t	Importada de JSONL. Empresa: CRUSTACEOS DEL SUR S.A. Especie: CENTOLLA	MC	30
4b5441ed-a56e-44c4-bcf5-c16ee4b16272	2025	22	9ae66c80-611f-428f-a218-759124429f23	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-02-01 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:18.563+00	2026-01-03 20:11:18.563+00	t	Importada de JSONL. Empresa: ARGENOVA. Especie: CALAMAR	MC	30
6f7fe6d1-b49b-4b86-9362-572ae33459b9	2025	23	d1e2685a-e03f-4dbf-bf31-e20c148964fb	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-01-28 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:18.57+00	2026-01-03 20:11:18.57+00	t	Importada de JSONL. Empresa: ARBUMASA S.A. Especie: CALAMAR	MC	30
97c101e4-5641-4aef-ba6b-2a13cb3097a0	2025	24	365e6078-51de-4e30-9183-8877176fad16	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-01-31 03:00:00+00	\N	\N	22	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:18.579+00	2026-01-03 20:11:18.579+00	t	Importada de JSONL. Empresa: ARGENOVA. Especie: MERLUZA AUSTRAL	MC	30
4e451adc-44a1-4478-b3c1-f31dbf02f7c8	2025	25	162625cb-67c1-47b0-a0f8-fe3863335702	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-02-01 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:18.586+00	2026-01-03 20:11:18.586+00	t	Importada de JSONL. Empresa: BENTONICOS DE ARGENTINA. Especie: CENTOLLA	MC	30
fe79cfff-3bc3-4f1d-b124-4bd340f56a41	2025	26	9c59f952-3a5c-4e28-9b53-0abce704c1ad	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-02-02 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:18.593+00	2026-01-03 20:11:18.593+00	t	Importada de JSONL. Empresa: GIORNO. Especie: MERLUZA	MC	30
af648e74-daba-4d96-9bcf-46df9b3fe177	2025	27	0224e437-1522-42cc-bc8c-d6ac701df5b6	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-01-31 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:18.601+00	2026-01-03 20:11:18.601+00	t	Importada de JSONL. Empresa: CHIARPESCA. Especie: CALAMAR	MC	30
28d7c818-dce7-4629-87b5-558cdc792aff	2025	28	a627c1b9-5116-41fc-b360-0c73f5d18184	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-02-06 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:18.608+00	2026-01-03 20:11:18.608+00	t	Importada de JSONL. Empresa: PESANTAR. Especie: CALAMAR	MC	60
d9864297-9fb4-44f0-8661-025d97c938cd	2025	29	aca65ab2-e5e7-4657-9d5a-f665087cbc01	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-02-03 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:18.616+00	2026-01-03 20:11:18.616+00	t	Importada de JSONL. Empresa: EL MARISCO. Especie: MERLUZA	MC	30
56d53745-dced-4972-9cb5-0692084fcc4f	2025	30	1b2b11d3-0322-49b4-a9c7-0eb48734747a	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-02-12 03:00:00+00	\N	\N	83	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:18.623+00	2026-01-03 20:11:18.623+00	t	Importada de JSONL. Empresa: ESTREMAR. Especie: MERLUZA AUSTRAL	MC	30
e24b6fa9-99c3-45d8-b3d3-6a3925adca9a	2025	31	1ce502d2-13cb-49f0-9d02-ef4d85866967	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-02-02 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:18.63+00	2026-01-03 20:11:18.63+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: VIEIRA	MC	30
46b9320f-ddcb-49d4-abce-2428e90e7384	2025	32	7b475623-c048-4393-9665-161c9abc19bb	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-02-19 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:18.637+00	2026-01-03 20:11:18.637+00	t	Importada de JSONL. Empresa: PRODESUR. Especie: MERLUZA AUSTRAL	MC	60
53944760-6b2b-47c5-8d73-f7b76c8db53f	2025	33	7cf6a359-27ac-42d4-9ebd-e2ce3ebc8d3b	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-02-14 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:18.644+00	2026-01-03 20:11:18.644+00	t	Importada de JSONL. Empresa: PESQUERA VERAZ. Especie: MERLUZA	MC	30
70365df4-8a27-4b4d-a618-5d12d8abec48	2025	34	467088f6-e25d-4770-8b96-502514b918cb	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-02-27 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:18.651+00	2026-01-03 20:11:18.651+00	t	Importada de JSONL. Empresa: GLACIAR PESQUERA. Especie: VIEIRA	MC	30
b97893c3-73f7-4baf-b937-07f16bbcf1d3	2025	35	365e6078-51de-4e30-9183-8877176fad16	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-02-25 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:18.659+00	2026-01-03 20:11:18.659+00	t	Importada de JSONL. Empresa: ARGENOVA. Especie: MERLUZA AUSTRAL	MC	30
b6784dbe-0462-4fa0-92fd-b72a1b91e5fa	2025	36	dff0c01d-8ae6-4b3c-a2a1-84be475e6107	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-02-20 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:18.667+00	2026-01-03 20:11:18.667+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: VIEIRA	MC	30
67b854ff-f571-49fe-a941-4fb979b69bcf	2025	37	2336cdf4-d30d-4904-bc30-e0165b221291	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-02-21 03:00:00+00	\N	\N	29	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:18.674+00	2026-01-03 20:11:18.674+00	t	Importada de JSONL. Empresa: CRUSTACEOS DEL SUR S.A. Especie: CENTOLLA	MC	30
1a751029-d9eb-40b6-9d05-abf787da21ab	2025	38	a8750dc5-73de-4af6-8256-02c3d4f0e31b	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-03-05 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:18.681+00	2026-01-03 20:11:18.681+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: CENTOLLA	MC	30
03488945-c9ba-49d5-a405-a1d82bd9d592	2025	39	1b8366ae-3011-41d8-a507-785e851a07d7	\N	eb8ce446-7d4b-4eb8-a953-8a8fbcc7a912	2025-03-06 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:18.688+00	2026-01-03 20:11:18.688+00	t	Importada de JSONL. Empresa: BENTONICOS DE ARGENTINA. Especie: CENTOLLA	MC	30
082e7798-f15f-4da5-b8cf-91fb20ab6fa4	2025	40	022693f1-d736-45eb-9fcd-7f21eeb8d382	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-03-06 03:00:00+00	\N	\N	6	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:18.695+00	2026-01-03 20:11:18.695+00	t	Importada de JSONL. Empresa: GLACIAR PESQUERA. Especie: VIEIRA	MC	30
53aae717-6efb-4d45-b0be-f1e1bf25f090	2025	41	e3e50e91-7a17-4479-a230-330cc160931f	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-03-03 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:18.701+00	2026-01-03 20:11:18.701+00	t	Importada de JSONL. Empresa: FOOD ARTS S.A. Especie: CALAMAR	MC	30
cf63af20-1e4c-436a-adcc-01454b062a7f	2025	42	f6a1aa39-9940-46e0-9b81-1a2949a9a361	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-03-07 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:18.708+00	2026-01-03 20:11:18.708+00	t	Importada de JSONL. Empresa: TOZUDO. Especie: P.ABADEJO	MC	30
450b073f-d003-4421-a730-c0dd2ecd3dff	2025	43	0d5efca4-a7b0-4f0f-9c87-64b55b2e2de3	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-03-07 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:18.718+00	2026-01-03 20:11:18.718+00	t	Importada de JSONL. Empresa: PESQUERA SIEMPRE GAUCHO. Especie: P.ABADEJO	MC	30
2b0e1997-3859-4b47-b27b-b29c2ffc8225	2025	44	f3460ae8-4d0b-48cf-8f05-b208acd9d669	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-03-07 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:18.727+00	2026-01-03 20:11:18.727+00	t	Importada de JSONL. Empresa: LOBA PESQUERA. Especie: P.ABADEJO	MC	30
52c4df2d-b038-4e4a-9e2d-bda18426d809	2025	45	636329bd-79bb-4470-bcc9-cb7a6c39be83	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-03-07 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:18.737+00	2026-01-03 20:11:18.737+00	t	Importada de JSONL. Empresa: ROMFIOC S.R.L. Especie: P.ABADEJO	MC	30
ec9a55c3-c2cf-4710-af3f-aec9621a82c1	2025	46	992f86e6-0d45-48b5-b2a0-917a7bb91e72	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-03-07 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:18.747+00	2026-01-03 20:11:18.747+00	t	Importada de JSONL. Empresa: MAREA OPTIMA. Especie: P.ABADEJO	MC	30
8f3245a5-9a2b-4c00-8f0f-4c0880fa7462	2025	47	7a4a43c8-4078-4f8e-b0a5-90f8de5d9acd	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-03-12 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:18.756+00	2026-01-03 20:11:18.756+00	t	Importada de JSONL. Empresa: CRUSTACEOS DEL SUR S.A. Especie: CENTOLLA	MC	30
10b9945a-e0f2-4bc9-b36c-a283cbf7015f	2025	48	e66a062b-3a45-45d5-b793-6512dcfede67	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-03-12 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:18.763+00	2026-01-03 20:11:18.763+00	t	Importada de JSONL. Empresa: CENTOMAR S.A. Especie: CENTOLLA	MC	30
b6b54237-5bbf-469d-aa42-948dbda6eb6b	2025	49	d8323940-0d32-415f-99a5-b4b0502a35be	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-03-18 03:00:00+00	\N	\N	27	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:18.77+00	2026-01-03 20:11:18.77+00	t	Importada de JSONL. Empresa: ESTRELLA PATAGONICA. Especie: MERLUZA	MC	30
7f28b5b4-525d-4a45-8433-2c5fd816c50f	2025	50	3a5c8c97-f021-44b0-942b-41ddb4cbb879	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-03-22 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:18.777+00	2026-01-03 20:11:18.777+00	t	Importada de JSONL. Empresa: MOSCUZZA. Especie: CALAMAR	MC	30
f34e2c2b-80e2-487f-a17f-1cdc6bf4bb7c	2025	51	1ce502d2-13cb-49f0-9d02-ef4d85866967	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-03-24 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:18.784+00	2026-01-03 20:11:18.784+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: VIEIRA	MC	30
ac6950da-7071-48ee-b7f4-8376398c0604	2025	52	365e6078-51de-4e30-9183-8877176fad16	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-03-27 03:00:00+00	\N	\N	25	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:18.79+00	2026-01-03 20:11:18.79+00	t	Importada de JSONL. Empresa: ARGENOVA. Especie: MERLUZA AUSTRAL	MC	30
a0911603-7b39-49d9-bbaf-83955aa2e5b5	2025	53	5a662438-6668-40c2-956e-d514528c0109	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-03-28 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:18.796+00	2026-01-03 20:11:18.796+00	t	Importada de JSONL. Empresa: PEDRO MOSCUZZA E HIJO. Especie: CALAMAR	MC	30
982d5b22-db50-4a84-af4e-a9d8fdd9aa38	2025	54	dff0c01d-8ae6-4b3c-a2a1-84be475e6107	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-04-09 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:18.804+00	2026-01-03 20:11:18.804+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: VIEIRA	MC	30
b6317a3e-0305-4fc1-b51c-7e7ceb644530	2025	55	7b475623-c048-4393-9665-161c9abc19bb	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-04-17 03:00:00+00	\N	\N	1	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:18.81+00	2026-01-03 20:11:18.81+00	t	Importada de JSONL. Empresa: PRODESUR. Especie: MERLUZA AUSTRAL	MC	60
538f4c05-60f4-4621-bf67-4e8717cea2d2	2025	56	a627c1b9-5116-41fc-b360-0c73f5d18184	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-04-10 03:00:00+00	\N	\N	39	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:18.819+00	2026-01-03 20:11:18.819+00	t	Importada de JSONL. Empresa: PESANTAR. Especie: MERLUZA AUSTRAL	MC	60
9e5a11f5-eed3-4c22-868c-b8427e4e68ee	2025	57	1b8366ae-3011-41d8-a507-785e851a07d7	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-04-09 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:18.825+00	2026-01-03 20:11:18.825+00	t	Importada de JSONL. Empresa: BENTONICOS DE ARGENTINA. Especie: CENTOLLA	MC	30
aa652fdd-04f9-42fe-904d-face93041676	2025	58	01e67326-813d-4e77-94cf-f5ebc1f91074	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-04-22 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:18.832+00	2026-01-03 20:11:18.832+00	t	Importada de JSONL. Empresa: VIERA ARGENTINA. Especie: CALAMAR	MC	30
ab07ab6d-1913-4ed4-9223-8b5acd787726	2025	59	467088f6-e25d-4770-8b96-502514b918cb	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-04-10 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:18.839+00	2026-01-03 20:11:18.839+00	t	Importada de JSONL. Empresa: GLACIAR PESQUERA. Especie: VIEIRA	MC	30
ffedaa30-08df-4a10-980d-32076a3be5e9	2025	60	a8750dc5-73de-4af6-8256-02c3d4f0e31b	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-04-10 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:18.845+00	2026-01-03 20:11:18.845+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: CENTOLLA	MC	30
ed15ccd1-bfad-41f6-8f99-c2d597b85d57	2025	61	022693f1-d736-45eb-9fcd-7f21eeb8d382	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-04-17 03:00:00+00	\N	\N	6	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:18.852+00	2026-01-03 20:11:18.852+00	t	Importada de JSONL. Empresa: GLACIAR PESQUERA. Especie: VIEIRA	MC	30
f2e78ff7-025b-44e1-a086-8490522c6a8a	2025	62	782cb866-8c6d-4cf2-bfc8-49269cebbd80	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-04-15 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:18.858+00	2026-01-03 20:11:18.858+00	t	Importada de JSONL. Empresa: ALTAMARE S.AS. Especie: CALAMAR	MC	30
64ee9147-5917-41f4-8a45-cac6d75ce56f	2025	63	c934a991-153a-40c5-ba49-77e4f5bcbe81	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-04-11 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:18.866+00	2026-01-03 20:11:18.866+00	t	Importada de JSONL. Empresa: PESCARGEN. Especie: LANGOSTINO	MC	30
6c4b461b-2c21-459a-8aef-b22a2f24247b	2025	64	9c59f952-3a5c-4e28-9b53-0abce704c1ad	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-04-22 03:00:00+00	\N	\N	6	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:18.878+00	2026-01-03 20:11:18.878+00	t	Importada de JSONL. Empresa: GIORNO. Especie: MERLUZA	MC	30
7030697f-f606-431a-907d-fb34fe7bb756	2025	65	3bd01f47-2ca9-447e-a346-fbfe23e039b7	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-04-15 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:18.886+00	2026-01-03 20:11:18.886+00	t	Importada de JSONL. Empresa: LUIS SOLIMENO. Especie: MERLUZA	MC	30
62c182f3-0e39-4b62-aab0-1ea9c27c5e43	2025	66	85b081e9-ca84-439a-a7c6-85f482796972	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-04-21 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:18.904+00	2026-01-03 20:11:18.904+00	t	Importada de JSONL. Empresa: MARÍTIMA COMERCIAL. Especie: MERLUZA	MC	30
9a24be82-d932-4cc6-8f42-ec5ba9246cfb	2025	67	59001b96-2509-4062-b02d-ae50570a3df6	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-04-29 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:18.914+00	2026-01-03 20:11:18.914+00	t	Importada de JSONL. Empresa: NIETOS ANTONIO BALDINO. Especie: MERLUZA	MC	30
380918f6-7d78-45c6-84b4-aae70857d65a	2025	68	4b4f7296-55c4-47b4-8cd4-c77af9a1ef45	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-04-23 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:18.921+00	2026-01-03 20:11:18.921+00	t	Importada de JSONL. Empresa: MOSCUZZA. Especie: MERLUZA	MC	30
b4fad7d7-c555-4a9b-9935-74df16e06222	2025	69	3a5c8c97-f021-44b0-942b-41ddb4cbb879	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-04-26 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:18.933+00	2026-01-03 20:11:18.933+00	t	Importada de JSONL. Empresa: MOSCUZZA. Especie: CALAMAR	MC	30
02d3acb8-c754-4cca-8ba5-e376c45b7d7d	2025	70	762dde0b-f9e0-4a8a-934f-0f4e99a49f1f	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-04-25 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:18.94+00	2026-01-03 20:11:18.94+00	t	Importada de JSONL. Empresa: MARONTI  S.A.. Especie: MERLUZA	MC	30
7193ebb7-16fd-43f0-bd27-d3a362cca3d0	2025	71	0224e437-1522-42cc-bc8c-d6ac701df5b6	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-04-24 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:18.95+00	2026-01-03 20:11:18.95+00	t	Importada de JSONL. Empresa: GRUPO CHIAR PESCA. Especie: CALAMAR	MC	30
a7630b0f-fb5e-445a-806b-bd8512b72782	2025	72	365e6078-51de-4e30-9183-8877176fad16	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-04-29 03:00:00+00	\N	\N	24	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:18.957+00	2026-01-03 20:11:18.957+00	t	Importada de JSONL. Empresa: ARGENOVA. Especie: MERLUZA AUSTRAL	MC	30
199a7e71-bc83-4f38-a9a9-33dad197c5e9	2025	73	14275e90-b8b1-433d-98e0-199704dd8dca	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-04-26 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:18.964+00	2026-01-03 20:11:18.964+00	t	Importada de JSONL. Empresa: BUENA PROA. Especie: MERLUZA	MC	30
6ed02559-0d7d-4ac7-b54d-1f255a416d05	2025	74	8f541238-eba2-44f2-aa54-fc9eac628ccc	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-04-30 03:00:00+00	\N	\N	7	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:18.975+00	2026-01-03 20:11:18.975+00	t	Importada de JSONL. Empresa: GIORNO. Especie: MERLUZA	MC	30
0a94d961-2516-4487-9438-5e0d26e3b7bd	2025	75	1b2b11d3-0322-49b4-a9c7-0eb48734747a	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-05-07 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:18.982+00	2026-01-03 20:11:18.982+00	t	Importada de JSONL. Empresa: ESTREMAR. Especie: MERLUZA AUSTRAL	MC	30
f4a9d31f-9163-4cbe-8b14-1bc8c7671a3b	2025	76	1ce502d2-13cb-49f0-9d02-ef4d85866967	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-05-07 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:18.989+00	2026-01-03 20:11:18.989+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: VIEIRA	MC	30
0def0199-df9b-4fd6-9df5-87d58b14019f	2025	77	f9b08767-3d42-493b-9603-364ffc399a34	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-05-04 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:18.996+00	2026-01-03 20:11:18.996+00	t	Importada de JSONL. Empresa: GIORNO. Especie: MERLUZA	MC	30
6cd03b64-6890-4c6d-967f-121e1741dd10	2025	78	87f926dd-849a-445d-a8ef-30097f382ded	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-05-06 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.004+00	2026-01-03 20:11:19.004+00	t	Importada de JSONL. Empresa: FOOD ARTS S.A. Especie: CALAMAR	MC	30
c889d2d6-b997-4ee1-820d-a0ece47ae17b	2025	79	5a662438-6668-40c2-956e-d514528c0109	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-05-06 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.011+00	2026-01-03 20:11:19.011+00	t	Importada de JSONL. Empresa: MOSCUZZA. Especie: CALAMAR	MC	30
ad40ea2f-34b2-48b5-9890-cb9e96154d87	2025	80	c934a991-153a-40c5-ba49-77e4f5bcbe81	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-05-10 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.018+00	2026-01-03 20:11:19.018+00	t	Importada de JSONL. Empresa: PESCAREN S.A. Especie: LANGOSTINO	MC	30
7fb87527-817b-43f1-bea7-e3e564cedd08	2025	81	a8750dc5-73de-4af6-8256-02c3d4f0e31b	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-05-15 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.024+00	2026-01-03 20:11:19.024+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: CENTOLLA	MC	30
2d937399-4aff-454a-8199-17b4d81a6160	2025	82	a627c1b9-5116-41fc-b360-0c73f5d18184	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-05-22 03:00:00+00	\N	\N	50	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.031+00	2026-01-03 20:11:19.031+00	t	Importada de JSONL. Empresa: PESANTAR. Especie: MERLUZA AUSTRAL	MC	60
02fac296-4a30-4537-b9ab-da3448f698fc	2025	83	e651d472-1996-4202-9306-3798541fe779	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-05-17 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.037+00	2026-01-03 20:11:19.037+00	t	Importada de JSONL. Empresa: MOSCUZZA. Especie: MERLUZA	MC	30
8f75b9ef-5c2a-4153-a385-2aad0dc51c0f	2025	84	41a2dfd2-cc96-440c-87e6-8ab941a1d53b	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-05-20 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.044+00	2026-01-03 20:11:19.044+00	t	Importada de JSONL. Empresa: LUIS SOLIMENO. Especie: MERLUZA	MC	30
d96f4bd5-4df8-4301-aab4-ddb349f1a330	2025	85	8f541238-eba2-44f2-aa54-fc9eac628ccc	\N	eb8ce446-7d4b-4eb8-a953-8a8fbcc7a912	2025-05-20 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.051+00	2026-01-03 20:11:19.051+00	t	Importada de JSONL. Empresa: GIORNO. Especie: MERLUZA	MC	30
a22200aa-163c-49e2-937e-b0a8c5f19157	2025	86	bcef50ab-5f36-4420-b1b0-0854bdfb38d2	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-05-20 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.056+00	2026-01-03 20:11:19.056+00	t	Importada de JSONL. Empresa: LUIS SOLIMENO. Especie: CALAMAR	MC	30
00e11fc6-81c3-4969-b8b4-beecf8ae8174	2025	87	7b475623-c048-4393-9665-161c9abc19bb	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-05-20 03:00:00+00	\N	\N	31	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.062+00	2026-01-03 20:11:19.062+00	t	Importada de JSONL. Empresa: PRODESUR. Especie: MERLUZA AUSTRAL	MC	60
98879b7b-b863-4d88-8711-2f5c5cfeeaa5	2025	88	dff0c01d-8ae6-4b3c-a2a1-84be475e6107	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-05-26 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.068+00	2026-01-03 20:11:19.068+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: VIEIRA	MC	30
b1a638a5-b5de-43d3-9988-249b46d677e0	2025	89	022693f1-d736-45eb-9fcd-7f21eeb8d382	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-05-31 03:00:00+00	\N	\N	6	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.074+00	2026-01-03 20:11:19.074+00	t	Importada de JSONL. Empresa: GLACIAR PESQUERA. Especie: VIEIRA	MC	30
b293b413-8b61-4584-a548-b4e96728af0e	2025	90	c934a991-153a-40c5-ba49-77e4f5bcbe81	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-05-28 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.081+00	2026-01-03 20:11:19.081+00	t	Importada de JSONL. Empresa: PESCARGEN. Especie: LANGOSTINO	MC	30
71cb28d3-0f4e-4ba8-8696-ca682bea44fe	2025	91	3a5c8c97-f021-44b0-942b-41ddb4cbb879	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-05-29 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.09+00	2026-01-03 20:11:19.09+00	t	Importada de JSONL. Empresa: MOSCUZZA. Especie: CALAMAR	MC	30
475da7f7-726a-47f5-abd4-da5ac55ce768	2025	92	e37370d2-09b3-4af8-bdb0-b2820e53e0f7	\N	eb8ce446-7d4b-4eb8-a953-8a8fbcc7a912	2025-05-29 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.097+00	2026-01-03 20:11:19.097+00	t	Importada de JSONL. Empresa: CONARPESA. Especie: LANGOSTINO	MC	30
3f06d1bf-ccaf-45a4-9c67-dbe20e8bfb07	2025	93	467088f6-e25d-4770-8b96-502514b918cb	\N	eb8ce446-7d4b-4eb8-a953-8a8fbcc7a912	2025-06-11 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.102+00	2026-01-03 20:11:19.102+00	t	Importada de JSONL. Empresa: GLACIAR PESQUERA. Especie: VIERA	MC	30
f145588b-3628-4e38-bfa3-266dec6a1ceb	2025	94	f06eb6fd-515b-4baa-a34d-f9a5457f5a49	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-06-09 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.106+00	2026-01-03 20:11:19.106+00	t	Importada de JSONL. Empresa: ARPES. Especie: MERLUZA	MC	30
e2ca8345-f8a8-471e-819d-91c7a325eb48	2025	95	f9b08767-3d42-493b-9603-364ffc399a34	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-06-06 03:00:00+00	\N	\N	1	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.119+00	2026-01-03 20:11:19.119+00	t	Importada de JSONL. Empresa: GIORNO. Especie: MERLUZA	MC	30
b46086cd-5e9d-4f2a-8725-bc515f2cf543	2025	96	9c59f952-3a5c-4e28-9b53-0abce704c1ad	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-06-06 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.125+00	2026-01-03 20:11:19.125+00	t	Importada de JSONL. Empresa: GIORNO. Especie: MERLUZA	MC	30
4104ff3f-1513-439f-b665-02d5b3003cbf	2025	97	636329bd-79bb-4470-bcc9-cb7a6c39be83	\N	eb8ce446-7d4b-4eb8-a953-8a8fbcc7a912	2025-06-17 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.133+00	2026-01-03 20:11:19.133+00	t	Importada de JSONL. Empresa: ROMFIOC S.R.L. Especie: MERLUZA	MC	30
8771bc92-95e8-43b4-9a22-234bf00ea287	2025	98	1b2b11d3-0322-49b4-a9c7-0eb48734747a	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-06-17 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.138+00	2026-01-03 20:11:19.138+00	t	Importada de JSONL. Empresa: ESTREMAR. Especie: MERLUZA AUSTRAL	MC	30
0f475caa-0780-46ba-90a2-61c893aade36	2025	99	14275e90-b8b1-433d-98e0-199704dd8dca	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-06-12 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.145+00	2026-01-03 20:11:19.145+00	t	Importada de JSONL. Empresa: BUENA PROA. Especie: MERLUZA	MC	30
1ad010e1-1057-4a0e-982e-55e9473530b5	2025	100	1ce502d2-13cb-49f0-9d02-ef4d85866967	\N	eb8ce446-7d4b-4eb8-a953-8a8fbcc7a912	2025-06-17 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.163+00	2026-01-03 20:11:19.163+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: VIERA	MC	30
8239a760-f987-4940-86f7-05d00f4de3fc	2025	101	d4ee3d90-724b-48fd-b3e7-4e92ecd16406	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-06-18 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.169+00	2026-01-03 20:11:19.169+00	t	Importada de JSONL. Empresa: BUENA PROA. Especie: P. LANGOSTINO	MC	30
4d21d19d-4b03-47db-9c0b-5152a757fbf4	2025	102	c934a991-153a-40c5-ba49-77e4f5bcbe81	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-06-17 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.18+00	2026-01-03 20:11:19.18+00	t	Importada de JSONL. Empresa: PESCARGEN. Especie: P. LANGOSTINO	MC	30
981fab8c-6832-4733-83ef-46eac045c3dd	2025	103	fac9a47a-46a6-4c5d-86d3-6ffe0f1e6a6a	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-06-17 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.188+00	2026-01-03 20:11:19.188+00	t	Importada de JSONL. Empresa: FRIGORÍFICO DON LUIS. Especie: P. LANGOSTINO	MC	30
4af76975-cdf5-477d-b0c8-b4dadce8d599	2025	104	b5cc963e-ebe4-4fe3-92fd-de054786dca1	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-06-18 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.197+00	2026-01-03 20:11:19.197+00	t	Importada de JSONL. Empresa: URLIPEZ. Especie: P. LANGOSTINO	MC	30
5d2000dd-6b2d-4950-a747-60789a7f620e	2025	105	72b0eda1-7000-416b-8f28-f9fcdc981af5	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-06-19 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.205+00	2026-01-03 20:11:19.205+00	t	Importada de JSONL. Empresa: DE ANGELIS Y LOGGHE. Especie: P. LANGOSTINO	MC	30
e8041510-9b74-4285-ba12-ce5cafe76d87	2025	106	e87dbb1c-fdce-49b2-b48c-ce32d0b84fe7	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-06-17 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.214+00	2026-01-03 20:11:19.214+00	t	Importada de JSONL. Empresa: PESCA ANTIGUA. Especie: P. LANGOSTINO	MC	30
3240ec69-fb6b-4b02-b2e7-1ec0d54e826f	2025	107	927c5ab9-3f81-420c-bae3-5c6518f7271f	\N	eb8ce446-7d4b-4eb8-a953-8a8fbcc7a912	2025-06-21 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.224+00	2026-01-03 20:11:19.224+00	t	Importada de JSONL. Empresa: IBERCONSA. Especie: MERLUZA	MC	30
0a20e0d2-0590-4512-8886-90bdd19ad006	2025	108	3bd01f47-2ca9-447e-a346-fbfe23e039b7	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-06-24 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.229+00	2026-01-03 20:11:19.229+00	t	Importada de JSONL. Empresa: SOLIMENO E HIJOS. Especie: MERLUZA	MC	30
a2824c28-8b00-44f3-a566-db1b2717e8ab	2025	109	467088f6-e25d-4770-8b96-502514b918cb	\N	eb8ce446-7d4b-4eb8-a953-8a8fbcc7a912	2025-06-23 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.243+00	2026-01-03 20:11:19.243+00	t	Importada de JSONL. Empresa: GLACIAR PESQUERA. Especie: VIERA	MC	30
36f8b629-8513-44f9-be1d-149a07cbd0b7	2025	110	fac9a47a-46a6-4c5d-86d3-6ffe0f1e6a6a	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-06-27 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.248+00	2026-01-03 20:11:19.248+00	t	Importada de JSONL. Empresa: FRIGORÍFICO DON LUIS. Especie: P. LANGOSTINO	MC	30
91d66e1a-bcf6-44f0-92e4-6337e4a3e09d	2025	111	72b0eda1-7000-416b-8f28-f9fcdc981af5	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-06-27 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.256+00	2026-01-03 20:11:19.256+00	t	Importada de JSONL. Empresa: DE ANGELIS Y LOGGHE. Especie: P. LANGOSTINO	MC	30
215eee76-2107-47a3-a401-664d82ad41a4	2025	112	340037f3-81ce-4612-9894-b82c5422b440	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-06-27 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.266+00	2026-01-03 20:11:19.266+00	t	Importada de JSONL. Empresa: CANAL DE BEAGLE. Especie: P. LANGOSTINO	MC	30
8da8e5c1-5731-4ccd-971d-87930c320963	2025	113	7cf6a359-27ac-42d4-9ebd-e2ce3ebc8d3b	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-07-01 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.273+00	2026-01-03 20:11:19.273+00	t	Importada de JSONL. Empresa: PESQUERA VERAZ. Especie: MERLUZA	MC	30
8e385152-b072-49fa-ac7b-f3799b0aff6a	2025	114	467088f6-e25d-4770-8b96-502514b918cb	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-07-10 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.285+00	2026-01-03 20:11:19.285+00	t	Importada de JSONL. Empresa: GLACIAR PESQUERA. Especie: VIERA	MC	30
d89f9b02-27be-4322-9f8b-7316bc4efc00	2025	115	1ce502d2-13cb-49f0-9d02-ef4d85866967	\N	eb8ce446-7d4b-4eb8-a953-8a8fbcc7a912	2025-07-08 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.292+00	2026-01-03 20:11:19.292+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: VIERA	MC	30
c459611a-073a-48f0-a3c6-bf568dd5ab07	2025	116	022693f1-d736-45eb-9fcd-7f21eeb8d382	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-07-15 03:00:00+00	\N	\N	3	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.296+00	2026-01-03 20:11:19.296+00	t	Importada de JSONL. Empresa: GLACIAR PESQUERA. Especie: VIERA	MC	30
c231775c-9b78-4262-9c75-6bb4022698b6	2025	117	c934a991-153a-40c5-ba49-77e4f5bcbe81	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-07-11 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.302+00	2026-01-03 20:11:19.302+00	t	Importada de JSONL. Empresa: PESCARGEN. Especie: LANGOSTINO	MC	30
da1083d0-6d3c-414a-8462-85d5c0b4bed1	2025	118	0ac8253a-9566-40dc-ab44-e1ae7e2ba043	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-07-11 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.308+00	2026-01-03 20:11:19.308+00	t	Importada de JSONL. Empresa: BUENA PROA. Especie: LANGOSTINO	MC	30
1a43f6af-10a9-428c-96af-7a28bc7c5b34	2025	119	c6a12cdc-cf76-4220-98fc-6e2e8efd1bf9	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-07-12 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.316+00	2026-01-03 20:11:19.316+00	t	Importada de JSONL. Empresa: IBERCONSA. Especie: MERLUZA	MC	30
8b04c362-c4fd-4f3d-9431-d33e4c9ee2cf	2025	120	68bee4d7-b639-4972-8274-f21ebd78ea97	\N	eb8ce446-7d4b-4eb8-a953-8a8fbcc7a912	2025-07-11 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.322+00	2026-01-03 20:11:19.322+00	t	Importada de JSONL. Empresa: RITONDO SALLUSTIO Y CICCIOTTI. Especie: LANGOSTINO	MC	30
fdfc020a-5ea8-4a38-a696-b10160cfbf23	2025	121	aec29330-5e93-44ad-be65-9391f79b9a5c	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-07-15 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.327+00	2026-01-03 20:11:19.327+00	t	Importada de JSONL. Empresa: MOSCUZZA. Especie: LANGOSTINO	MC	30
4061951a-e2f3-4588-8a81-1ad5e3d5cf70	2025	122	dff0c01d-8ae6-4b3c-a2a1-84be475e6107	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-07-16 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.34+00	2026-01-03 20:11:19.34+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: VIEIRA	MC	30
5b895e1a-ce4f-4ce6-8fa6-f1a412a4ac9f	2025	123	9c59f952-3a5c-4e28-9b53-0abce704c1ad	\N	eb8ce446-7d4b-4eb8-a953-8a8fbcc7a912	2025-07-19 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.346+00	2026-01-03 20:11:19.346+00	t	Importada de JSONL. Empresa: GIORNO S.A. Especie: MERLUZA	MC	30
12adcd78-0f99-4786-88e9-7f1b53d364c3	2025	124	f9b08767-3d42-493b-9603-364ffc399a34	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-07-19 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.351+00	2026-01-03 20:11:19.351+00	t	Importada de JSONL. Empresa: GIORNO S.A. Especie: MERLUZA	MC	30
825fc30a-31ff-4351-baa5-73ee82070276	2025	125	e37370d2-09b3-4af8-bdb0-b2820e53e0f7	\N	eb8ce446-7d4b-4eb8-a953-8a8fbcc7a912	2025-07-18 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.358+00	2026-01-03 20:11:19.358+00	t	Importada de JSONL. Empresa: CONARPESA. Especie: LANGOSTINO	MC	30
c46145b3-1fd8-4005-a4cf-1676d0e6aea1	2025	126	14275e90-b8b1-433d-98e0-199704dd8dca	\N	eb8ce446-7d4b-4eb8-a953-8a8fbcc7a912	2025-07-18 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.363+00	2026-01-03 20:11:19.363+00	t	Importada de JSONL. Empresa: BUENA PROA. Especie: LANGOSTINO	MC	30
8fcdb22d-69a6-4e77-8006-46e6476614d5	2025	127	c89b6338-55ec-4d14-b0f0-09a680fb4504	\N	eb8ce446-7d4b-4eb8-a953-8a8fbcc7a912	2025-07-18 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.367+00	2026-01-03 20:11:19.367+00	t	Importada de JSONL. Empresa: CONARPESA. Especie: LANGOSTINO	MC	30
d66d005e-e7f6-4a80-888f-742e380b15d0	2025	128	de5883d2-e98c-4e44-b04d-9bc95403762d	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-07-18 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.372+00	2026-01-03 20:11:19.372+00	t	Importada de JSONL. Empresa: PEDRO MOSCUZZA E HIJO. Especie: MERLUZA	MC	30
db80ca37-beaa-4e3f-a9e9-75abcbcaa066	2025	129	4b4f7296-55c4-47b4-8cd4-c77af9a1ef45	\N	0b21451e-e14c-421e-8387-5478e7a4ad88	2025-07-21 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.379+00	2026-01-03 20:11:19.379+00	t	Importada de JSONL. Empresa: PEDRO MOSCUZZA E HIJO. Especie: LANGOSTINO	MC	30
70ca3caa-810a-44cd-9c01-43e86ea917f5	2025	130	927c5ab9-3f81-420c-bae3-5c6518f7271f	\N	eb8ce446-7d4b-4eb8-a953-8a8fbcc7a912	2025-07-22 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.385+00	2026-01-03 20:11:19.385+00	t	Importada de JSONL. Empresa: IBERCONSA. Especie: LANGOSTINO	MC	30
bd96ab83-2467-49a8-bc3e-8b4700a9e4a7	2025	131	a7d709fd-509a-4807-ba09-7ac5371e16c7	\N	eb8ce446-7d4b-4eb8-a953-8a8fbcc7a912	2025-07-22 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.39+00	2026-01-03 20:11:19.39+00	t	Importada de JSONL. Empresa: EMPESUR. Especie: LANGOSTINO	MC	30
e7d698f5-fc82-48c2-acb7-620a8dd00000	2025	132	4f26b3a1-e3a1-43e7-ad43-341043dacad4	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-07-23 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.394+00	2026-01-03 20:11:19.394+00	t	Importada de JSONL. Empresa: BUENOS AIRES PESCA S.A. Especie: LANGOSTINO	MC	30
aaba4967-5646-497b-af4a-d91159b24152	2025	133	667d831b-2e60-456f-833f-d3c070017f12	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-07-23 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.4+00	2026-01-03 20:11:19.4+00	t	Importada de JSONL. Empresa: BUENOS AIRES PESCA S.A. Especie: LANGOSTINO	MC	30
9f1c446c-c3d7-41a0-b578-fc7ad021a15b	2025	134	14275e90-b8b1-433d-98e0-199704dd8dca	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-07-25 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.406+00	2026-01-03 20:11:19.406+00	t	Importada de JSONL. Empresa: BUENA PROA. Especie: LANGOSTINO	MC	30
a8dea641-66e3-4f4e-b528-299fd17ad983	2025	135	f06eb6fd-515b-4baa-a34d-f9a5457f5a49	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-07-27 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.417+00	2026-01-03 20:11:19.417+00	t	Importada de JSONL. Empresa: ARPES. Especie: MERLUZA	MC	30
c87874c5-2bbd-4158-8334-5a6c9867a589	2025	136	2336cdf4-d30d-4904-bc30-e0165b221291	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-07-28 03:00:00+00	\N	\N	42	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.427+00	2026-01-03 20:11:19.427+00	t	Importada de JSONL. Empresa: CRUSTACEOS DEL SUR S.A. Especie: CENTOLLA	MC	60
fcbeade7-fd24-4771-90d8-d194a5e9db8b	2025	137	9a11d629-e76e-4ffc-bdfc-2d0e2a013d3a	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-07-29 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.433+00	2026-01-03 20:11:19.433+00	t	Importada de JSONL. Empresa: CENTOMAR S.A. Especie: LANGOSTINO	MC	30
29455e29-1cb5-4408-9d5a-b5d60b72a0d0	2025	138	fd9910c1-4b10-4fcc-a988-b0796c8905e2	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-08-04 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.44+00	2026-01-03 20:11:19.44+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: LANGOSTINO	MC	30
f20dc72a-c272-44aa-bb99-13934679e7c6	2025	139	0ac8253a-9566-40dc-ab44-e1ae7e2ba043	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-08-02 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.448+00	2026-01-03 20:11:19.448+00	t	Importada de JSONL. Empresa: BUENA PROA. Especie: LANGOSTINO	MC	30
b4cbac19-0032-48f3-86df-eeb97376a53b	2025	140	3a4a8458-60e4-42de-b56c-b2d08c080e5a	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-08-05 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.455+00	2026-01-03 20:11:19.455+00	t	Importada de JSONL. Empresa: ARBUMASA S.A. Especie: LANGOSTINO	MC	30
52664ce3-d49e-4862-ae60-1d3c91d273d4	2025	141	9e678444-485c-42fa-b1a8-0a4bda99677d	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-08-05 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.461+00	2026-01-03 20:11:19.461+00	t	Importada de JSONL. Empresa: ARBUMASA S.A. Especie: LANGOSTINO	MC	30
a06af4fd-cd7c-49b3-abb2-8d63015e25fe	2025	142	a461832c-2de1-482e-9856-9c0e8ec1971a	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-08-06 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.468+00	2026-01-03 20:11:19.468+00	t	Importada de JSONL. Empresa: SOLIMENO E HIJOS. Especie: MERLUZA	MC	30
186acbd5-ca5d-4ce7-a7b8-e109d62d625e	2025	143	6fa1e08b-94a9-462f-949f-11a92f4e30b8	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-08-07 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.479+00	2026-01-03 20:11:19.479+00	t	Importada de JSONL. Empresa: PEDRO MOSCUZZA E HIJO. Especie: LANGOSTINO	MC	30
2a7407a5-8754-4434-ba31-fecface06bf7	2025	144	4d2fa66a-2930-4d45-912c-819daf41efc4	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-08-07 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.486+00	2026-01-03 20:11:19.486+00	t	Importada de JSONL. Empresa: PEDRO MOSCUZZA E HIJO. Especie: LANGOSTINO	MC	30
9f386967-b338-415b-99f4-136badedd2a1	2025	145	b5b3193e-dc6f-4132-a473-640f8610465c	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-08-12 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.492+00	2026-01-03 20:11:19.492+00	t	Importada de JSONL. Empresa: ANTONIO BALDINO E HIJOS. Especie: MERLUZA	MC	30
895456d9-265c-4303-b35e-7de43c967339	2025	146	762dde0b-f9e0-4a8a-934f-0f4e99a49f1f	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-08-14 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.504+00	2026-01-03 20:11:19.504+00	t	Importada de JSONL. Empresa: MARONTI  S.A.. Especie: MERLUZA	MC	30
631f6ad1-e76e-4d1f-9204-fea4f4c547d8	2025	147	f9b08767-3d42-493b-9603-364ffc399a34	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-08-19 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.514+00	2026-01-03 20:11:19.514+00	t	Importada de JSONL. Empresa: GIORNO S.A. Especie: MERLUZA	MC	30
75279f40-4d1d-480a-b9f0-9cc45ab4dd8d	2025	148	c73aa159-1a07-4578-a0fd-fa467c64379b	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-08-18 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.521+00	2026-01-03 20:11:19.521+00	t	Importada de JSONL. Empresa: XEITOSIÑO. Especie: LANGOSTINO	MC	30
b3a88fa9-d7ae-4004-9f12-766e8b90dba3	2025	149	80d44be2-cea8-40ac-ae69-b2cfba186948	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-08-19 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.527+00	2026-01-03 20:11:19.527+00	t	Importada de JSONL. Empresa: XEITOSIÑO. Especie: LANGOSTINO	MC	30
cad981bd-a054-42fc-ab60-6ec82aee7366	2025	150	244e66f9-5800-48f1-92a5-12093f5cb1bd	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-08-25 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.533+00	2026-01-03 20:11:19.533+00	t	Importada de JSONL. Empresa: CONARPESA. Especie: LANGOSTINO	MC	30
e9a1826c-fad1-494d-9f86-c08e0ad99adf	2025	151	8f541238-eba2-44f2-aa54-fc9eac628ccc	\N	eb8ce446-7d4b-4eb8-a953-8a8fbcc7a912	2025-08-29 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.54+00	2026-01-03 20:11:19.54+00	t	Importada de JSONL. Empresa: GIORNO. Especie: LANGOSTINO	MC	30
09d2efb7-4ffe-4e9d-869b-ba14a3f91534	2025	152	0bfe5c2a-0884-47cd-b502-516696b94cd4	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-08-29 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.544+00	2026-01-03 20:11:19.544+00	t	Importada de JSONL. Empresa: PESQUERA VERAZ SA. Especie: LANGOSTINO	MC	30
6817994e-7dc2-4a00-9bd9-cde763cc2ad1	2025	153	de5883d2-e98c-4e44-b04d-9bc95403762d	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-08-30 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.551+00	2026-01-03 20:11:19.551+00	t	Importada de JSONL. Empresa: PEDRO MOSCUZZA E HIJO. Especie: MERLUZA	MC	30
848ab357-d77a-4bc2-a4d9-414b4766e65f	2025	154	19434b4b-f8ad-4dfb-a4ab-f28e6fd9f10c	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-09-05 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.557+00	2026-01-03 20:11:19.557+00	t	Importada de JSONL. Empresa: ARGENOVA S.A. Especie: LANGOSTINO	MC	30
42016b47-6334-4c4c-91dd-1bf03acbff52	2025	155	dff0c01d-8ae6-4b3c-a2a1-84be475e6107	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-09-08 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.563+00	2026-01-03 20:11:19.563+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: VIEIRA	MC	30
86082db1-9f3f-494a-8a52-95eede79efce	2025	156	2336cdf4-d30d-4904-bc30-e0165b221291	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-09-11 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.57+00	2026-01-03 20:11:19.57+00	t	Importada de JSONL. Empresa: CRUSTACEOS DEL SUR S.A. Especie: CENTOLLA	MC	30
d4bc315b-7693-45e7-bf6c-04e14fbb20b4	2025	157	e58e416e-1125-4d7a-bd84-974f867f5016	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-09-10 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.575+00	2026-01-03 20:11:19.575+00	t	Importada de JSONL. Empresa: PESCASOL S.A. Especie: MERLUZA	MC	30
e62a6272-41c3-42ee-a529-10f41b975517	2025	158	9e678444-485c-42fa-b1a8-0a4bda99677d	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-09-13 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.582+00	2026-01-03 20:11:19.582+00	t	Importada de JSONL. Empresa: ARBUMASA S.A. Especie: LANGOSTINO	MC	30
72d0ba61-74b5-4324-9772-11837b6b263c	2025	159	a8750dc5-73de-4af6-8256-02c3d4f0e31b	\N	6df7c4fd-8134-4cd6-8867-b928bb0c0ef0	2025-09-11 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.588+00	2026-01-03 20:11:19.588+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: CENTOLLA	MC	30
374223da-ae98-4fa2-aafe-a6862f235a39	2025	160	e66a062b-3a45-45d5-b793-6512dcfede67	\N	6df7c4fd-8134-4cd6-8867-b928bb0c0ef0	2025-09-11 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.595+00	2026-01-03 20:11:19.595+00	t	Importada de JSONL. Empresa: CENTOMAR S.A. Especie: CENTOLLA	MC	30
d0c896ca-f982-452a-92b0-491df1cc9a60	2025	161	162625cb-67c1-47b0-a0f8-fe3863335702	\N	e9c85d8e-268f-4598-bc6b-f9f2917be914	2025-09-11 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.601+00	2026-01-03 20:11:19.601+00	t	Importada de JSONL. Empresa: BENTONICOS DE ARGENTINA. Especie: CENTOLLA	MC	30
bce66084-90a4-439b-937c-d25f4ba1c75a	2025	162	1b8366ae-3011-41d8-a507-785e851a07d7	\N	e9c85d8e-268f-4598-bc6b-f9f2917be914	2025-09-11 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.608+00	2026-01-03 20:11:19.608+00	t	Importada de JSONL. Empresa: BENTONICOS DE ARGENTINA. Especie: CENTOLLA	MC	30
2b2cf340-d8c1-494f-9f65-4c9cabc9fd5d	2025	163	a627c1b9-5116-41fc-b360-0c73f5d18184	\N	6df7c4fd-8134-4cd6-8867-b928bb0c0ef0	2025-09-17 03:00:00+00	\N	\N	61	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.614+00	2026-01-03 20:11:19.614+00	t	Importada de JSONL. Empresa: PESANTAR. Especie: MERLUZA AUSTRAL	MC	30
f0a855c4-87b7-4cfb-a212-0bba29612878	2025	164	80d44be2-cea8-40ac-ae69-b2cfba186948	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-09-19 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.621+00	2026-01-03 20:11:19.621+00	t	Importada de JSONL. Empresa: XEITOSIÑO. Especie: LANGOSTINO	MC	30
51f280b0-c38b-4a78-817d-49010fb8dca8	2025	165	1b2b11d3-0322-49b4-a9c7-0eb48734747a	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	2025-09-29 03:00:00+00	\N	\N	31	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.628+00	2026-01-03 20:11:19.628+00	t	Importada de JSONL. Empresa: ESTREMAR. Especie: MERLUZA AUSTRAL	MC	30
622eb238-54ed-4053-8a31-c7418fc5a655	2025	166	365e6078-51de-4e30-9183-8877176fad16	\N	6df7c4fd-8134-4cd6-8867-b928bb0c0ef0	2025-09-29 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.634+00	2026-01-03 20:11:19.634+00	t	Importada de JSONL. Empresa: ARGENOVA. Especie: MERLUZA AUSTRAL	MC	30
16f4924f-db37-4ae9-a0c1-8c6d78700ed9	2025	167	7cf6a359-27ac-42d4-9ebd-e2ce3ebc8d3b	\N	6df7c4fd-8134-4cd6-8867-b928bb0c0ef0	2025-09-26 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.64+00	2026-01-03 20:11:19.64+00	t	Importada de JSONL. Empresa: PESQUERA VERAZ S.A. Especie: MERLUZA	MC	30
c02d7370-1d59-4961-9f81-b07619d2695c	2025	168	de5883d2-e98c-4e44-b04d-9bc95403762d	\N	6df7c4fd-8134-4cd6-8867-b928bb0c0ef0	2025-10-14 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.657+00	2026-01-03 20:11:19.657+00	t	Importada de JSONL. Empresa: PEDRO MOSCUZZA E HIJO. Especie: MERLUZA	MC	30
ccd384cf-d047-436d-8aef-987b9c1c04f6	2025	169	7a4a43c8-4078-4f8e-b0a5-90f8de5d9acd	\N	e9c85d8e-268f-4598-bc6b-f9f2917be914	2025-10-12 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.663+00	2026-01-03 20:11:19.663+00	t	Importada de JSONL. Empresa: CRUSTACEOS DEL SUR S.A. Especie: CENTOLLA	MC	60
3f626d50-76fd-4934-b50b-7f4d38f92353	2025	170	14275e90-b8b1-433d-98e0-199704dd8dca	\N	6df7c4fd-8134-4cd6-8867-b928bb0c0ef0	2025-10-18 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.669+00	2026-01-03 20:11:19.669+00	t	Importada de JSONL. Empresa: BUENA PROA. Especie: MERLUZA	MC	30
ae40317b-c514-4f2c-b12c-5b63269321d2	2025	171	022693f1-d736-45eb-9fcd-7f21eeb8d382	\N	e9c85d8e-268f-4598-bc6b-f9f2917be914	2025-10-30 03:00:00+00	\N	\N	6	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.68+00	2026-01-03 20:11:19.68+00	t	Importada de JSONL. Empresa: GLACIAR PESQUERA. Especie: VIEIRA	MC	60
64df8d4b-89ff-4533-a3d2-e98ee10b731f	2025	172	2336cdf4-d30d-4904-bc30-e0165b221291	\N	6df7c4fd-8134-4cd6-8867-b928bb0c0ef0	2025-10-23 03:00:00+00	\N	\N	30	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.687+00	2026-01-03 20:11:19.687+00	t	Importada de JSONL. Empresa: CRUSTACEOS DEL SUR S.A. Especie: CENTOLLA	MC	30
115f3be2-67c1-4e63-8766-3488ec401619	2025	173	1b2b11d3-0322-49b4-a9c7-0eb48734747a	\N	6df7c4fd-8134-4cd6-8867-b928bb0c0ef0	2025-09-29 03:00:00+00	\N	\N	22	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.695+00	2026-01-03 20:11:19.695+00	t	Importada de JSONL. Empresa: ESTREMAR. Especie: MERLUZA AUSTRAL	MC	30
1caed02b-996b-477f-9c67-e1e10f0874fc	2025	174	dff0c01d-8ae6-4b3c-a2a1-84be475e6107	\N	e9c85d8e-268f-4598-bc6b-f9f2917be914	2025-10-27 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.701+00	2026-01-03 20:11:19.701+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: VIEIRA	MC	30
f551dae9-57cd-430c-b0b8-d04574a1617b	2025	175	3bd01f47-2ca9-447e-a346-fbfe23e039b7	\N	e9c85d8e-268f-4598-bc6b-f9f2917be914	2025-10-31 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.706+00	2026-01-03 20:11:19.706+00	t	Importada de JSONL. Empresa: SOLIMENO e HIJOS S.A. Especie: MERLUZA	MC	30
fb4ef943-5409-47fd-8a45-2a57fab3f295	2025	176	b5b3193e-dc6f-4132-a473-640f8610465c	\N	6df7c4fd-8134-4cd6-8867-b928bb0c0ef0	2025-11-01 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.718+00	2026-01-03 20:11:19.718+00	t	Importada de JSONL. Empresa: ROTELLO S.A. Especie: MERLUZA	MC	30
f3bfe1c9-fb42-4d5f-9a1f-869490891cbf	2025	177	f06eb6fd-515b-4baa-a34d-f9a5457f5a49	\N	e9c85d8e-268f-4598-bc6b-f9f2917be914	2025-11-03 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.725+00	2026-01-03 20:11:19.725+00	t	Importada de JSONL. Empresa: ARPES S.A. Especie: MERLUZA	MC	30
7d2941cd-d0cb-4ff5-9143-f05867ecd280	2025	178	e66a062b-3a45-45d5-b793-6512dcfede67	\N	e9c85d8e-268f-4598-bc6b-f9f2917be914	2025-11-06 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.737+00	2026-01-03 20:11:19.737+00	t	Importada de JSONL. Empresa: CENTOMAR S.A. Especie: CENTOLLA	MC	30
6a56d4a0-7320-4cd0-a2ec-9ac51440eb30	2025	179	a4cb82f1-e3b2-49f7-9abd-fa8cf96843f3	\N	6df7c4fd-8134-4cd6-8867-b928bb0c0ef0	2025-11-04 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.747+00	2026-01-03 20:11:19.747+00	t	Importada de JSONL. Empresa: AIRE MARINO. Especie: ANCHOÍTA	MC	30
ebf2c8b6-5120-4aca-91bf-8e6d5511f331	2025	180	a8750dc5-73de-4af6-8256-02c3d4f0e31b	\N	e9c85d8e-268f-4598-bc6b-f9f2917be914	2025-11-10 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.755+00	2026-01-03 20:11:19.755+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: CENTOLLA	MC	30
3d2a6806-79c8-4149-8878-a1209e55ba5d	2025	181	1ce502d2-13cb-49f0-9d02-ef4d85866967	\N	e9c85d8e-268f-4598-bc6b-f9f2917be914	2025-11-10 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.761+00	2026-01-03 20:11:19.761+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: VIEIRA	MC	30
d352f139-4b5a-4965-8137-a2f7654ba08a	2025	182	a627c1b9-5116-41fc-b360-0c73f5d18184	\N	0b21451e-e14c-421e-8387-5478e7a4ad88	2025-11-20 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.768+00	2026-01-03 20:11:19.768+00	t	Importada de JSONL. Empresa: PESANTAR. Especie: MERLUZA AUSTRAL	MC	30
390d7a7d-0060-4f05-b8d7-b0b513959a9b	2025	185	7cf6a359-27ac-42d4-9ebd-e2ce3ebc8d3b	\N	e9c85d8e-268f-4598-bc6b-f9f2917be914	2025-12-01 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.788+00	2026-01-03 20:11:19.788+00	t	Importada de JSONL. Empresa: PESQUERA VERAZ S.A. Especie: MERLUZA	MC	30
5749bfda-11a6-484c-b828-146f127de998	2025	186	022693f1-d736-45eb-9fcd-7f21eeb8d382	\N	0b21451e-e14c-421e-8387-5478e7a4ad88	2025-12-15 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.794+00	2026-01-03 20:11:19.794+00	t	Importada de JSONL. Empresa: GLACIAR PESQUERA. Especie: VIEIRA	MC	30
a3294f34-3bf1-495e-bd53-66f550391ba9	2025	187	dff0c01d-8ae6-4b3c-a2a1-84be475e6107	\N	0b21451e-e14c-421e-8387-5478e7a4ad88	2025-12-15 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.801+00	2026-01-03 20:11:19.801+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: VIEIRA	MC	30
75075f81-3e8e-4a08-acf2-dfe365951c72	2025	188	1b2b11d3-0322-49b4-a9c7-0eb48734747a	\N	ea2252eb-8229-4d52-9648-479058ec4334	2025-12-29 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.808+00	2026-01-03 20:11:19.808+00	t	Importada de JSONL. Empresa: ESTREMAR S.A. Especie: MERLUZA AUSTRAL	MC	30
f3282fc2-0cbd-45b4-add8-485d7ac19f39	2025	189	0224e437-1522-42cc-bc8c-d6ac701df5b6	\N	ea2252eb-8229-4d52-9648-479058ec4334	2025-12-26 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.815+00	2026-01-03 20:11:19.815+00	t	Importada de JSONL. Empresa: CHIARPESCA. Especie: CALAMAR	MC	30
5eb39723-136d-441b-9a24-a3ceb8df63e3	2025	190	1595a238-fefd-4f9c-bb52-2c6c23127233	\N	ea2252eb-8229-4d52-9648-479058ec4334	2025-12-29 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.822+00	2026-01-03 20:11:19.822+00	t	Importada de JSONL. Empresa: ARGENOVA. Especie: CALAMAR	MC	30
a9b479f9-eb41-4f3e-b710-346a4f7a5765	2025	191	b9cc9ddf-c507-4bdf-97d8-96eb080f205b	\N	ea2252eb-8229-4d52-9648-479058ec4334	2025-12-29 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.828+00	2026-01-03 20:11:19.828+00	t	Importada de JSONL. Empresa: ALTAMARE S.AS. Especie: CALAMAR	MC	30
927e3ed0-dafe-4c98-a281-078c64cf354f	2025	192	616414ba-12f1-4f6d-b63f-911478c934c7	\N	ea2252eb-8229-4d52-9648-479058ec4334	2025-12-26 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.836+00	2026-01-03 20:11:19.836+00	t	Importada de JSONL. Empresa: PESQUERÍA  RÍO QUEQUEN. Especie: CALAMAR	MC	30
aca2574c-b75a-40c6-8e11-f6ea8ebeb1c2	2025	193	46a7a07a-8cb8-4e8a-8573-61804a3a63d3	\N	ea2252eb-8229-4d52-9648-479058ec4334	2025-12-26 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.844+00	2026-01-03 20:11:19.844+00	t	Importada de JSONL. Empresa: PESQUERÍA  RÍO QUEQUEN. Especie: CALAMAR	MC	30
33e149c6-2857-4cd6-8045-19407c2cfc9e	2025	194	e66a062b-3a45-45d5-b793-6512dcfede67	\N	ea2252eb-8229-4d52-9648-479058ec4334	2025-12-26 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.852+00	2026-01-03 20:11:19.852+00	t	Importada de JSONL. Empresa: CENTOMAR S.A. Especie: CENTOLLA	MC	30
806ade78-064c-45c9-a36d-1fb7a2194be6	2025	195	7a4a43c8-4078-4f8e-b0a5-90f8de5d9acd	\N	ea2252eb-8229-4d52-9648-479058ec4334	2025-12-30 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.859+00	2026-01-03 20:11:19.859+00	t	Importada de JSONL. Empresa: CRUSTACEOS DEL SUR S.A. Especie: CENTOLLA	MC	30
611c2056-ab40-4db1-9db2-58a81eb57607	2025	184	7b475623-c048-4393-9665-161c9abc19bb	\N	0b21451e-e14c-421e-8387-5478e7a4ad88	2025-11-26 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.781+00	2026-01-03 20:11:19.781+00	t	Importada de JSONL. Empresa: PRODESUR. Especie: MERLUZA AUSTRAL	MC	30
cddf9dcb-1e5e-4dfa-9643-566eed1461ca	2025	197	1b8366ae-3011-41d8-a507-785e851a07d7	\N	ea2252eb-8229-4d52-9648-479058ec4334	2025-12-30 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.873+00	2026-01-03 20:11:19.873+00	t	Importada de JSONL. Empresa: BENTONICOS DE ARGENTINA. Especie: CENTOLLA	MC	30
789f57de-f4c3-4398-ace8-880584ab5ae9	2025	198	faa23ec7-3f06-44ab-beaa-f730e9f5f4b1	\N	ea2252eb-8229-4d52-9648-479058ec4334	2025-12-29 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.88+00	2026-01-03 20:11:19.88+00	t	Importada de JSONL. Empresa: GIORNO. Especie: CALAMAR	MC	30
46a335f6-9487-4ecd-831d-85ba568d7b63	2025	199	467088f6-e25d-4770-8b96-502514b918cb	\N	ea2252eb-8229-4d52-9648-479058ec4334	2025-12-26 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.886+00	2026-01-03 20:11:19.886+00	t	Importada de JSONL. Empresa: GLACIAR PESQUERA. Especie: VIEIRA	MC	30
8e5d0022-2392-405c-a7ca-326d41aaded5	2025	200	bcef50ab-5f36-4420-b1b0-0854bdfb38d2	\N	ea2252eb-8229-4d52-9648-479058ec4334	2025-12-28 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.894+00	2026-01-03 20:11:19.894+00	t	Importada de JSONL. Empresa: LUIS SOLIMENO. Especie: CALAMAR	MC	30
9f68feda-51d8-4dcf-aa49-dba8e8a347f2	2025	201	619e44ee-2ab2-4550-b783-f129c96e2ff5	\N	ea2252eb-8229-4d52-9648-479058ec4334	2025-12-28 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.904+00	2026-01-03 20:11:19.904+00	t	Importada de JSONL. Empresa: PESQUERA COMERCIAL. Especie: CALAMAR	MC	30
e7844417-503b-4eb4-9225-af494816ebd8	2025	196	162625cb-67c1-47b0-a0f8-fe3863335702	\N	e9c85d8e-268f-4598-bc6b-f9f2917be914	2025-12-23 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 20:11:19.865+00	2026-01-03 20:18:41.627+00	t	Importada de JSONL. Empresa: BENTONICOS DE ARGENTINA. Especie: CENTOLLA	MC	30
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
0919c4d4-1128-42aa-981d-49f50691ba17	79d71507-6e64-4d6f-a48d-af5da075f9a2	1	089b0ead-176b-4e7a-b99d-5caeea74ea61	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-01-03 03:00:00+00	2025-01-03 03:00:00+00	COMERCIAL	Etapa 1 importada
e3ab0887-8521-4fd3-90ca-217f7ad83d41	b19e3191-7c87-44eb-beb9-e5e33634a4b6	1	089b0ead-176b-4e7a-b99d-5caeea74ea61	9e97a6b3-cca1-4931-92e9-ab8a5e0b35e1	9e97a6b3-cca1-4931-92e9-ab8a5e0b35e1	2025-01-28 03:00:00+00	2025-01-28 03:00:00+00	COMERCIAL	Etapa 1 importada
7aaf5222-a70b-476a-84af-bcc8c727a8f7	a96b66ee-3be2-41fb-bc15-258979642704	1	c2c3c456-5f2c-47a2-a8af-d41dc148a19f	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-01-03 03:00:00+00	2025-03-04 03:00:00+00	COMERCIAL	Etapa 1 importada
7b48a96b-c439-4549-8040-dde04b01664e	7da900d7-acb6-478b-a2ff-6a301155e127	1	7c95d6f8-338a-4bf6-8863-1756cd9f598f	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-01-11 03:00:00+00	2025-03-07 03:00:00+00	COMERCIAL	Etapa 1 importada
5f9eb14f-4ebd-4c36-b1e3-4aaa2e42880a	6e4427b7-30e3-4677-9078-24dfc13e451f	1	7c95d6f8-338a-4bf6-8863-1756cd9f598f	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-01-07 03:00:00+00	2025-01-28 03:00:00+00	COMERCIAL	Etapa 1 importada
8c287134-9b10-4b98-8682-c52c32782190	31862f6a-a5ff-4768-9caf-9277b82860b3	1	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-01-08 03:00:00+00	2025-02-02 03:00:00+00	COMERCIAL	Etapa 1 importada
5b97b52f-b223-4a6f-ab5a-1ab126b78aa0	19657885-b7e0-4426-99fe-d8e94ee120df	1	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	9e97a6b3-cca1-4931-92e9-ab8a5e0b35e1	9e97a6b3-cca1-4931-92e9-ab8a5e0b35e1	2025-01-07 03:00:00+00	2025-01-30 03:00:00+00	COMERCIAL	Etapa 1 importada
6ab45019-f98e-437b-aff3-9c0de5892492	637f2025-7f23-4b6e-9c11-1692fb5a2192	1	7c95d6f8-338a-4bf6-8863-1756cd9f598f	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-01-11 03:00:00+00	2025-01-19 03:00:00+00	COMERCIAL	Etapa 1 importada
add7bc3b-570f-46ec-a83c-d793993a75a7	637f2025-7f23-4b6e-9c11-1692fb5a2192	2	7c95d6f8-338a-4bf6-8863-1756cd9f598f	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-01-22 03:00:00+00	2025-01-29 03:00:00+00	COMERCIAL	Etapa 2 importada
565da438-fc8e-4444-abd3-147ce31d0562	637f2025-7f23-4b6e-9c11-1692fb5a2192	3	7c95d6f8-338a-4bf6-8863-1756cd9f598f	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-01-31 03:00:00+00	2025-02-02 03:00:00+00	COMERCIAL	Etapa 3 importada
76f495bc-fe8d-47ba-827d-45ac0da70256	4c9381f2-8774-4df2-8a50-6a57229b1041	1	7bfb912c-3ee4-426e-a976-68bbbf6bc1d4	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-01-06 03:00:00+00	2025-02-07 03:00:00+00	COMERCIAL	Etapa 1 importada
e5b49754-47ff-4434-8e02-c446a8692ff5	37cd6141-84d3-46b1-9af3-7e856284a14f	1	7bfb912c-3ee4-426e-a976-68bbbf6bc1d4	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-01-13 03:00:00+00	2025-02-24 03:00:00+00	COMERCIAL	Etapa 1 importada
a6e2cc78-2d37-4870-abf7-d45f27fe65ae	04759b5e-6bde-4e81-b6d7-1501cc192aae	1	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	7a9e4185-6281-4c42-b3c4-1980e6855a31	7a9e4185-6281-4c42-b3c4-1980e6855a31	2025-01-08 03:00:00+00	2025-02-02 03:00:00+00	COMERCIAL	Etapa 1 importada
e5cc78bb-b799-4f3d-83d0-b1f8b4d35d06	b51443fd-d991-40ad-825e-3930af96862e	1	7bfb912c-3ee4-426e-a976-68bbbf6bc1d4	\N	\N	2025-01-09 03:00:00+00	2025-02-16 03:00:00+00	COMERCIAL	Etapa 1 importada
031a464e-77ba-449b-9a82-35b62be21387	7bb3e592-e81e-48cf-ae66-85e6e4dd3595	1	c2c3c456-5f2c-47a2-a8af-d41dc148a19f	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-01-08 03:00:00+00	2025-02-17 03:00:00+00	COMERCIAL	Etapa 1 importada
acc5cd5a-accd-43da-99ba-8470db67e503	b3ebd708-536a-4447-9770-ff47a412ad09	1	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-01-09 03:00:00+00	2025-02-13 03:00:00+00	COMERCIAL	Etapa 1 importada
6e31fbf3-6567-4fbc-bb7a-f64f4d75acf7	8f535c0d-5e9d-4653-9ab5-fb318e8d1acd	1	7c95d6f8-338a-4bf6-8863-1756cd9f598f	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-01-12 03:00:00+00	2025-01-19 03:00:00+00	COMERCIAL	Etapa 1 importada
7f1df0c4-4af0-4a9a-bafa-edf515a41d60	8f535c0d-5e9d-4653-9ab5-fb318e8d1acd	2	7c95d6f8-338a-4bf6-8863-1756cd9f598f	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-01-20 03:00:00+00	2025-01-26 03:00:00+00	COMERCIAL	Etapa 2 importada
21ec813d-4b6f-4acf-983e-44490a3b3073	8f535c0d-5e9d-4653-9ab5-fb318e8d1acd	3	7c95d6f8-338a-4bf6-8863-1756cd9f598f	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-01-28 03:00:00+00	2025-02-06 03:00:00+00	COMERCIAL	Etapa 3 importada
39628959-2c59-4a16-900a-76250f52675a	8f535c0d-5e9d-4653-9ab5-fb318e8d1acd	4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-02-07 03:00:00+00	2025-02-12 03:00:00+00	COMERCIAL	Etapa 4 importada
b7f12ae3-d55f-4402-8388-c670eca3a473	1bdd5d86-c5e7-43c1-8dd9-121854f820df	1	7bfb912c-3ee4-426e-a976-68bbbf6bc1d4	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-01-17 03:00:00+00	2025-03-01 03:00:00+00	COMERCIAL	Etapa 1 importada
4e3f168a-96f0-4d5e-afab-f466b907d968	cfef1c13-486c-4215-89a3-227b00dcce5f	1	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	7f1cac29-7e2c-4b6d-8447-1a5a9108fd12	7f1cac29-7e2c-4b6d-8447-1a5a9108fd12	2025-01-16 03:00:00+00	2025-01-18 03:00:00+00	COMERCIAL	Etapa 1 importada
0c742927-8e2f-4bbe-a6b0-39a874007816	ec5d55b0-f3f0-43ca-a17a-6ef8e501566e	1	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	\N	\N	2025-01-16 03:00:00+00	2025-03-11 03:00:00+00	COMERCIAL	Etapa 1 importada
b28a51df-989a-463f-b6cd-6a29a6e4ac59	6b062594-8807-4232-9d01-711e34cee3b5	1	c2c3c456-5f2c-47a2-a8af-d41dc148a19f	7a9e4185-6281-4c42-b3c4-1980e6855a31	7a9e4185-6281-4c42-b3c4-1980e6855a31	2025-01-27 03:00:00+00	2025-02-07 03:00:00+00	COMERCIAL	Etapa 1 importada
ac4d1f49-6760-4cc5-8f62-e96e08a3de97	ade9f2b1-ba03-4d4a-b2c8-fd2597bddd04	1	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-02-03 03:00:00+00	2025-03-11 03:00:00+00	COMERCIAL	Etapa 1 importada
30bc8ca6-b4fd-4c5a-bbc3-26437a569649	d7e4e28b-0bcd-4fde-8c7f-3ca450f56f5b	1	c2c3c456-5f2c-47a2-a8af-d41dc148a19f	7a9e4185-6281-4c42-b3c4-1980e6855a31	7a9e4185-6281-4c42-b3c4-1980e6855a31	2025-02-03 03:00:00+00	2025-03-12 03:00:00+00	COMERCIAL	Etapa 1 importada
c28cc417-4da3-4abc-9d71-5ff0edbc2401	4b5441ed-a56e-44c4-bcf5-c16ee4b16272	1	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	9e97a6b3-cca1-4931-92e9-ab8a5e0b35e1	9e97a6b3-cca1-4931-92e9-ab8a5e0b35e1	2025-01-31 03:00:00+00	2025-03-24 03:00:00+00	COMERCIAL	Etapa 1 importada
87821259-c70c-4bf9-8437-eeae76758dd9	6f7fe6d1-b49b-4b86-9362-572ae33459b9	1	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	9e97a6b3-cca1-4931-92e9-ab8a5e0b35e1	9e97a6b3-cca1-4931-92e9-ab8a5e0b35e1	2025-01-28 03:00:00+00	2025-02-23 03:00:00+00	COMERCIAL	Etapa 1 importada
8f4ca4c3-163a-4f9e-9542-6851242a8e48	6f7fe6d1-b49b-4b86-9362-572ae33459b9	2	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	9e97a6b3-cca1-4931-92e9-ab8a5e0b35e1	9e97a6b3-cca1-4931-92e9-ab8a5e0b35e1	2025-02-25 03:00:00+00	2025-04-06 03:00:00+00	COMERCIAL	Etapa 2 importada
e3c979e9-b373-4d20-8387-a9aaee43b92c	97c101e4-5641-4aef-ba6b-2a13cb3097a0	1	089b0ead-176b-4e7a-b99d-5caeea74ea61	9e97a6b3-cca1-4931-92e9-ab8a5e0b35e1	9e97a6b3-cca1-4931-92e9-ab8a5e0b35e1	2025-01-29 03:00:00+00	2025-02-23 03:00:00+00	COMERCIAL	Etapa 1 importada
8ba962bc-5e70-4a7b-a9f6-fe41baeb02b5	4e451adc-44a1-4478-b3c1-f31dbf02f7c8	1	c2c3c456-5f2c-47a2-a8af-d41dc148a19f	7a9e4185-6281-4c42-b3c4-1980e6855a31	7a9e4185-6281-4c42-b3c4-1980e6855a31	2025-01-30 03:00:00+00	2025-02-27 03:00:00+00	COMERCIAL	Etapa 1 importada
9c82df6b-2c46-4b65-9dec-5e572d4e5795	fe79cfff-3bc3-4f1d-b124-4bd340f56a41	1	7c95d6f8-338a-4bf6-8863-1756cd9f598f	7f1cac29-7e2c-4b6d-8447-1a5a9108fd12	7f1cac29-7e2c-4b6d-8447-1a5a9108fd12	2025-02-03 03:00:00+00	2025-03-10 03:00:00+00	COMERCIAL	Etapa 1 importada
d244934b-2772-45f7-b221-b71b4199a4c3	af648e74-daba-4d96-9bcf-46df9b3fe177	1	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	7a9e4185-6281-4c42-b3c4-1980e6855a31	7a9e4185-6281-4c42-b3c4-1980e6855a31	2025-01-30 03:00:00+00	2025-03-11 03:00:00+00	COMERCIAL	Etapa 1 importada
14968346-1104-4b72-a20a-7adf8e0fa9a8	28d7c818-dce7-4629-87b5-558cdc792aff	1	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	a269cdaa-b6a8-4b05-b44a-042cd68106e4	a269cdaa-b6a8-4b05-b44a-042cd68106e4	2025-02-05 03:00:00+00	2025-04-09 03:00:00+00	COMERCIAL	Etapa 1 importada
2d9d1e23-8fef-476a-86a4-ab6afd7deae7	d9864297-9fb4-44f0-8661-025d97c938cd	1	7c95d6f8-338a-4bf6-8863-1756cd9f598f	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-02-07 03:00:00+00	2025-02-22 03:00:00+00	COMERCIAL	Etapa 1 importada
57cbc87b-e205-46fd-a523-3dd8f49371aa	56d53745-dced-4972-9cb5-0692084fcc4f	1	089b0ead-176b-4e7a-b99d-5caeea74ea61	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-02-11 03:00:00+00	2025-05-07 03:00:00+00	COMERCIAL	Etapa 1 importada
7bac72f2-83c9-4261-ac17-6fcbecc9a911	e24b6fa9-99c3-45d8-b3d3-6a3925adca9a	1	7bfb912c-3ee4-426e-a976-68bbbf6bc1d4	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-02-12 03:00:00+00	2025-03-20 03:00:00+00	COMERCIAL	Etapa 1 importada
804b63d9-892a-4a0c-a7dd-991b6e60d369	46b9320f-ddcb-49d4-abce-2428e90e7384	1	089b0ead-176b-4e7a-b99d-5caeea74ea61	7a9e4185-6281-4c42-b3c4-1980e6855a31	7a9e4185-6281-4c42-b3c4-1980e6855a31	2025-02-19 03:00:00+00	2025-04-13 03:00:00+00	COMERCIAL	Etapa 1 importada
2351560e-cb18-42a1-bd39-adc0c2d5bb19	53944760-6b2b-47c5-8d73-f7b76c8db53f	1	7c95d6f8-338a-4bf6-8863-1756cd9f598f	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-02-18 03:00:00+00	2025-02-25 03:00:00+00	COMERCIAL	Etapa 1 importada
8e5c6c80-9637-415a-9dc0-05a22a3d904d	70365df4-8a27-4b4d-a618-5d12d8abec48	1	7bfb912c-3ee4-426e-a976-68bbbf6bc1d4	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-02-27 03:00:00+00	2025-04-07 03:00:00+00	COMERCIAL	Etapa 1 importada
c0dcbaeb-af5b-47f4-811f-c1e0ea3495b8	b97893c3-73f7-4baf-b937-07f16bbcf1d3	1	089b0ead-176b-4e7a-b99d-5caeea74ea61	9e97a6b3-cca1-4931-92e9-ab8a5e0b35e1	9e97a6b3-cca1-4931-92e9-ab8a5e0b35e1	2025-02-24 03:00:00+00	2025-03-31 03:00:00+00	COMERCIAL	Etapa 1 importada
874478c3-e924-417a-aa5a-2b08ab78c648	b6784dbe-0462-4fa0-92fd-b72a1b91e5fa	1	7bfb912c-3ee4-426e-a976-68bbbf6bc1d4	\N	\N	2025-02-21 03:00:00+00	2025-04-02 03:00:00+00	COMERCIAL	Etapa 1 importada
f384ed3b-fa14-4cf2-8be8-62e3c8208d29	67b854ff-f571-49fe-a941-4fb979b69bcf	1	c2c3c456-5f2c-47a2-a8af-d41dc148a19f	7a9e4185-6281-4c42-b3c4-1980e6855a31	7a9e4185-6281-4c42-b3c4-1980e6855a31	2025-02-21 03:00:00+00	2025-03-28 03:00:00+00	COMERCIAL	Etapa 1 importada
94e41b86-9990-45a6-9a65-83982d7a9df2	1a751029-d9eb-40b6-9d05-abf787da21ab	1	c2c3c456-5f2c-47a2-a8af-d41dc148a19f	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-03-06 03:00:00+00	2025-03-26 03:00:00+00	COMERCIAL	Etapa 1 importada
414223a4-d896-47d3-bff2-d610afae5e29	082e7798-f15f-4da5-b8cf-91fb20ab6fa4	1	7bfb912c-3ee4-426e-a976-68bbbf6bc1d4	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-03-06 03:00:00+00	2025-04-13 03:00:00+00	COMERCIAL	Etapa 1 importada
47d78fbd-753b-478b-a3f0-cdde3e349366	53aae717-6efb-4d45-b0be-f1e1bf25f090	1	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	7a9e4185-6281-4c42-b3c4-1980e6855a31	7a9e4185-6281-4c42-b3c4-1980e6855a31	2025-03-07 03:00:00+00	2025-04-07 03:00:00+00	COMERCIAL	Etapa 1 importada
fe5e5e26-63b6-473e-b39d-2dbc07c990a3	cf63af20-1e4c-436a-adcc-01454b062a7f	1	\N	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-03-11 03:00:00+00	2025-03-18 03:00:00+00	COMERCIAL	Etapa 1 importada
4d2776cc-7c0f-4da4-aa0c-6c0883ae6e46	cf63af20-1e4c-436a-adcc-01454b062a7f	2	\N	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-03-21 03:00:00+00	2025-03-28 03:00:00+00	COMERCIAL	Etapa 2 importada
5a651a69-a18b-48e9-88bb-099e7cb26de7	450b073f-d003-4421-a730-c0dd2ecd3dff	1	\N	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-03-11 03:00:00+00	2025-03-16 03:00:00+00	COMERCIAL	Etapa 1 importada
e1c93573-1cf7-48c1-a66a-f6f6a1bdc115	450b073f-d003-4421-a730-c0dd2ecd3dff	2	\N	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-03-17 03:00:00+00	2025-03-28 03:00:00+00	COMERCIAL	Etapa 2 importada
95a13216-9d9b-43e1-8d99-815fe43f5d53	2b0e1997-3859-4b47-b27b-b29c2ffc8225	1	\N	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-03-12 03:00:00+00	2025-03-17 03:00:00+00	COMERCIAL	Etapa 1 importada
bfc40ff8-0983-47af-9704-c518e2c83152	2b0e1997-3859-4b47-b27b-b29c2ffc8225	2	\N	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-03-18 03:00:00+00	2025-03-29 03:00:00+00	COMERCIAL	Etapa 2 importada
a61357fe-4647-4bd3-a75b-7875f4727478	52c4df2d-b038-4e4a-9e2d-bda18426d809	1	\N	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-03-11 03:00:00+00	2025-03-20 03:00:00+00	COMERCIAL	Etapa 1 importada
07db8815-112d-43f4-9e5d-a1bf3e51156e	52c4df2d-b038-4e4a-9e2d-bda18426d809	2	\N	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-03-22 03:00:00+00	2025-03-27 03:00:00+00	COMERCIAL	Etapa 2 importada
53c558bd-018d-42e8-8ce9-4ac206d3917f	ec9a55c3-c2cf-4710-af3f-aec9621a82c1	1	\N	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-03-07 03:00:00+00	2025-03-12 03:00:00+00	COMERCIAL	Etapa 1 importada
a864560f-1a53-44d8-9730-76b135c2ff7f	ec9a55c3-c2cf-4710-af3f-aec9621a82c1	2	\N	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-03-15 03:00:00+00	2025-03-18 03:00:00+00	COMERCIAL	Etapa 2 importada
2d9567c4-7206-4cc6-b8d6-9e4ce052301c	8f3245a5-9a2b-4c00-8f0f-4c0880fa7462	1	c2c3c456-5f2c-47a2-a8af-d41dc148a19f	7a9e4185-6281-4c42-b3c4-1980e6855a31	7a9e4185-6281-4c42-b3c4-1980e6855a31	2025-03-11 03:00:00+00	2025-04-23 03:00:00+00	COMERCIAL	Etapa 1 importada
56803a64-9817-4631-8123-5cc6918c3c32	10b9945a-e0f2-4bc9-b36c-a283cbf7015f	1	c2c3c456-5f2c-47a2-a8af-d41dc148a19f	7a9e4185-6281-4c42-b3c4-1980e6855a31	7a9e4185-6281-4c42-b3c4-1980e6855a31	2025-03-12 03:00:00+00	2025-04-30 03:00:00+00	COMERCIAL	Etapa 1 importada
ab6b2659-ecca-4309-ad7a-af40e66f64b7	b6b54237-5bbf-469d-aa42-948dbda6eb6b	1	7c95d6f8-338a-4bf6-8863-1756cd9f598f	7f1cac29-7e2c-4b6d-8447-1a5a9108fd12	7f1cac29-7e2c-4b6d-8447-1a5a9108fd12	2025-03-17 03:00:00+00	2025-04-25 03:00:00+00	COMERCIAL	Etapa 1 importada
2372f408-40a3-4760-aa42-e35732ae7a84	7f28b5b4-525d-4a45-8433-2c5fd816c50f	1	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-03-24 03:00:00+00	2025-04-23 03:00:00+00	COMERCIAL	Etapa 1 importada
0080978e-0063-457f-bcfc-f780beeb2976	f34e2c2b-80e2-487f-a17f-1cdc6bf4bb7c	1	7bfb912c-3ee4-426e-a976-68bbbf6bc1d4	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-03-28 03:00:00+00	2025-04-30 03:00:00+00	COMERCIAL	Etapa 1 importada
1a2e9f51-be29-4cbc-a270-7c94f3c93124	ac6950da-7071-48ee-b7f4-8376398c0604	1	089b0ead-176b-4e7a-b99d-5caeea74ea61	9e97a6b3-cca1-4931-92e9-ab8a5e0b35e1	9e97a6b3-cca1-4931-92e9-ab8a5e0b35e1	2025-04-01 03:00:00+00	2025-04-27 03:00:00+00	COMERCIAL	Etapa 1 importada
a0176753-9611-4077-9d39-cd6164d6e869	a0911603-7b39-49d9-bbaf-83955aa2e5b5	1	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-03-28 03:00:00+00	2025-05-05 03:00:00+00	COMERCIAL	Etapa 1 importada
56d98806-c2c8-47bc-a7be-aaf838ea7483	982d5b22-db50-4a84-af4e-a9d8fdd9aa38	1	7bfb912c-3ee4-426e-a976-68bbbf6bc1d4	\N	\N	2025-04-11 03:00:00+00	2025-05-17 03:00:00+00	COMERCIAL	Etapa 1 importada
04853bc7-399d-4a3a-a132-b9f5bfe67a3c	b6317a3e-0305-4fc1-b51c-7e7ceb644530	1	089b0ead-176b-4e7a-b99d-5caeea74ea61	7a9e4185-6281-4c42-b3c4-1980e6855a31	7a9e4185-6281-4c42-b3c4-1980e6855a31	2025-04-18 03:00:00+00	2025-05-19 03:00:00+00	COMERCIAL	Etapa 1 importada
34583dc0-35ba-449b-94b7-530e51eecd5d	538f4c05-60f4-4621-bf67-4e8717cea2d2	1	089b0ead-176b-4e7a-b99d-5caeea74ea61	a269cdaa-b6a8-4b05-b44a-042cd68106e4	a269cdaa-b6a8-4b05-b44a-042cd68106e4	2025-04-12 03:00:00+00	2025-05-20 03:00:00+00	COMERCIAL	Etapa 1 importada
6631c6c1-4d2f-4779-8e34-811432f78d7d	9e5a11f5-eed3-4c22-868c-b8427e4e68ee	1	c2c3c456-5f2c-47a2-a8af-d41dc148a19f	7a9e4185-6281-4c42-b3c4-1980e6855a31	7a9e4185-6281-4c42-b3c4-1980e6855a31	2025-05-08 03:00:00+00	2025-06-06 03:00:00+00	COMERCIAL	Etapa 1 importada
5b9efd61-0688-4093-b700-aa1574e9ca13	aa652fdd-04f9-42fe-904d-face93041676	1	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	7a9e4185-6281-4c42-b3c4-1980e6855a31	7a9e4185-6281-4c42-b3c4-1980e6855a31	2025-04-21 03:00:00+00	2025-05-15 03:00:00+00	COMERCIAL	Etapa 1 importada
39676b2b-b566-46bf-ab76-395f42e5edc9	ab07ab6d-1913-4ed4-9223-8b5acd787726	1	7bfb912c-3ee4-426e-a976-68bbbf6bc1d4	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-04-10 03:00:00+00	2025-06-06 03:00:00+00	COMERCIAL	Etapa 1 importada
e86cb73a-f53c-47dd-9823-602cb1539d32	ffedaa30-08df-4a10-980d-32076a3be5e9	1	c2c3c456-5f2c-47a2-a8af-d41dc148a19f	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-04-12 03:00:00+00	2025-05-14 03:00:00+00	COMERCIAL	Etapa 1 importada
1812319c-8198-4cdc-9761-4ce489da7e22	ed15ccd1-bfad-41f6-8f99-c2d597b85d57	1	7bfb912c-3ee4-426e-a976-68bbbf6bc1d4	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-04-16 03:00:00+00	2025-05-29 03:00:00+00	COMERCIAL	Etapa 1 importada
b60233ab-359b-4f40-8b1d-b312f70162c4	f2e78ff7-025b-44e1-a086-8490522c6a8a	1	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	7f1cac29-7e2c-4b6d-8447-1a5a9108fd12	7f1cac29-7e2c-4b6d-8447-1a5a9108fd12	2025-04-15 03:00:00+00	2025-05-27 03:00:00+00	COMERCIAL	Etapa 1 importada
6c8af3dd-2f5d-4e6d-a2b0-8e98fdffdfe6	64ee9147-5917-41f4-8a45-cac6d75ce56f	1	daccfce7-5e1e-4429-8f97-600fe78a1855	7a9e4185-6281-4c42-b3c4-1980e6855a31	7a9e4185-6281-4c42-b3c4-1980e6855a31	2025-04-12 03:00:00+00	2025-04-20 03:00:00+00	COMERCIAL	Etapa 1 importada
1a32f8eb-454d-4202-a98d-e0d5c4e01e7e	64ee9147-5917-41f4-8a45-cac6d75ce56f	2	daccfce7-5e1e-4429-8f97-600fe78a1855	7a9e4185-6281-4c42-b3c4-1980e6855a31	7a9e4185-6281-4c42-b3c4-1980e6855a31	2025-04-21 03:00:00+00	2025-05-01 03:00:00+00	COMERCIAL	Etapa 2 importada
5bc9fd04-251f-4cd4-adfb-fca3c9cc88eb	64ee9147-5917-41f4-8a45-cac6d75ce56f	3	daccfce7-5e1e-4429-8f97-600fe78a1855	7a9e4185-6281-4c42-b3c4-1980e6855a31	7a9e4185-6281-4c42-b3c4-1980e6855a31	2025-05-02 03:00:00+00	2025-05-10 03:00:00+00	COMERCIAL	Etapa 3 importada
c91a58f8-4d15-48f5-a3a3-98e98494c581	6c4b461b-2c21-459a-8aef-b22a2f24247b	1	7c95d6f8-338a-4bf6-8863-1756cd9f598f	7f1cac29-7e2c-4b6d-8447-1a5a9108fd12	7f1cac29-7e2c-4b6d-8447-1a5a9108fd12	2025-04-27 03:00:00+00	2025-05-31 03:00:00+00	COMERCIAL	Etapa 1 importada
86873f5b-cdfa-4da4-854b-09a7213fed97	7030697f-f606-431a-907d-fb34fe7bb756	1	7c95d6f8-338a-4bf6-8863-1756cd9f598f	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	0205-04-21 03:53:48+00	2025-04-29 03:00:00+00	COMERCIAL	Etapa 1 importada
75e47008-8032-49fb-a015-05294da53a25	7030697f-f606-431a-907d-fb34fe7bb756	2	7c95d6f8-338a-4bf6-8863-1756cd9f598f	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-05-02 03:00:00+00	2025-05-10 03:00:00+00	COMERCIAL	Etapa 2 importada
aa54549a-e1c4-4420-a112-0b6d4de03196	7030697f-f606-431a-907d-fb34fe7bb756	3	7c95d6f8-338a-4bf6-8863-1756cd9f598f	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-05-12 03:00:00+00	2025-05-26 03:00:00+00	COMERCIAL	Etapa 3 importada
f282b1bc-f010-4e27-afdc-aeadf318e97b	62c182f3-0e39-4b62-aab0-1ea9c27c5e43	1	7c95d6f8-338a-4bf6-8863-1756cd9f598f	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-05-02 03:00:00+00	2025-05-09 03:00:00+00	COMERCIAL	Etapa 1 importada
0e07774b-9ffc-4445-9cfd-4f0eb738e364	62c182f3-0e39-4b62-aab0-1ea9c27c5e43	2	7c95d6f8-338a-4bf6-8863-1756cd9f598f	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-05-14 03:00:00+00	2025-05-25 03:00:00+00	COMERCIAL	Etapa 2 importada
f869757e-22f9-46d4-b140-930d54695c04	9a24be82-d932-4cc6-8f42-ec5ba9246cfb	1	7c95d6f8-338a-4bf6-8863-1756cd9f598f	7a9e4185-6281-4c42-b3c4-1980e6855a31	7a9e4185-6281-4c42-b3c4-1980e6855a31	2025-04-30 03:00:00+00	2025-06-16 03:00:00+00	COMERCIAL	Etapa 1 importada
c687a8e4-ce98-4997-b348-ef65e6cddddb	380918f6-7d78-45c6-84b4-aae70857d65a	1	7c95d6f8-338a-4bf6-8863-1756cd9f598f	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-04-26 03:00:00+00	2025-05-04 03:00:00+00	COMERCIAL	Etapa 1 importada
e5706f4e-46b3-4310-b0b3-8923253ae043	380918f6-7d78-45c6-84b4-aae70857d65a	2	7c95d6f8-338a-4bf6-8863-1756cd9f598f	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-05-06 03:00:00+00	2025-05-15 03:00:00+00	COMERCIAL	Etapa 2 importada
9cb9439d-d449-4dab-be99-adad92a4241d	380918f6-7d78-45c6-84b4-aae70857d65a	3	7c95d6f8-338a-4bf6-8863-1756cd9f598f	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-05-17 03:00:00+00	2025-05-27 03:00:00+00	COMERCIAL	Etapa 3 importada
a3e2d370-7705-4757-97b8-ad170e600a59	b4fad7d7-c555-4a9b-9935-74df16e06222	1	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-04-26 03:00:00+00	2025-05-28 03:00:00+00	COMERCIAL	Etapa 1 importada
643cb759-8140-46e3-9415-74c831fb227d	02d3acb8-c754-4cca-8ba5-e376c45b7d7d	1	7c95d6f8-338a-4bf6-8863-1756cd9f598f	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-05-02 03:00:00+00	2025-05-10 03:00:00+00	COMERCIAL	Etapa 1 importada
bebd69bc-1a5b-4693-9fb8-6862bbd8e8ee	02d3acb8-c754-4cca-8ba5-e376c45b7d7d	2	7c95d6f8-338a-4bf6-8863-1756cd9f598f	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-05-12 03:00:00+00	2025-05-21 03:00:00+00	COMERCIAL	Etapa 2 importada
d38acd1d-27e7-4806-9d47-4bab1f73e1a5	7193ebb7-16fd-43f0-bd27-d3a362cca3d0	1	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	7a9e4185-6281-4c42-b3c4-1980e6855a31	7a9e4185-6281-4c42-b3c4-1980e6855a31	2025-04-30 03:00:00+00	2025-06-05 03:00:00+00	COMERCIAL	Etapa 1 importada
fe528940-cb88-483f-87b5-a393c10f70ff	a7630b0f-fb5e-445a-806b-bd8512b72782	1	089b0ead-176b-4e7a-b99d-5caeea74ea61	9e97a6b3-cca1-4931-92e9-ab8a5e0b35e1	9e97a6b3-cca1-4931-92e9-ab8a5e0b35e1	2025-04-28 03:00:00+00	2025-06-04 03:00:00+00	COMERCIAL	Etapa 1 importada
dada2d32-11e8-45bd-a37e-6ef9bea1f0bb	199a7e71-bc83-4f38-a9a9-33dad197c5e9	1	7c95d6f8-338a-4bf6-8863-1756cd9f598f	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-04-30 03:00:00+00	2025-05-06 03:00:00+00	COMERCIAL	Etapa 1 importada
b9f31e44-69ab-4b9e-922d-1ed96a765eb6	199a7e71-bc83-4f38-a9a9-33dad197c5e9	2	7c95d6f8-338a-4bf6-8863-1756cd9f598f	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-05-08 03:00:00+00	2025-05-17 03:00:00+00	COMERCIAL	Etapa 2 importada
c237254b-2c3c-41af-84b8-0d89b9fbf2b4	199a7e71-bc83-4f38-a9a9-33dad197c5e9	3	7c95d6f8-338a-4bf6-8863-1756cd9f598f	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-05-22 03:00:00+00	2025-05-29 03:00:00+00	COMERCIAL	Etapa 3 importada
41258667-63af-4b27-95f3-c014125d1fee	6ed02559-0d7d-4ac7-b54d-1f255a416d05	1	7c95d6f8-338a-4bf6-8863-1756cd9f598f	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-04-29 03:00:00+00	2025-05-15 03:00:00+00	COMERCIAL	Etapa 1 importada
1f2000c3-25b4-4d54-9bf6-ad1e2b0a238a	0a94d961-2516-4487-9438-5e0d26e3b7bd	1	089b0ead-176b-4e7a-b99d-5caeea74ea61	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-05-06 03:00:00+00	2025-06-18 03:00:00+00	COMERCIAL	Etapa 1 importada
28458003-2af8-4e84-a317-830f6016ecba	f4a9d31f-9163-4cbe-8b14-1bc8c7671a3b	1	7bfb912c-3ee4-426e-a976-68bbbf6bc1d4	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-05-07 03:00:00+00	2025-06-10 03:00:00+00	COMERCIAL	Etapa 1 importada
8cc96a92-610a-4a7c-ab42-9cad2ae55b1d	0def0199-df9b-4fd6-9df5-87d58b14019f	1	7c95d6f8-338a-4bf6-8863-1756cd9f598f	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-05-02 03:00:00+00	2025-06-05 03:00:00+00	COMERCIAL	Etapa 1 importada
34c6b6be-58a9-4dda-ab5f-34a048dd4ba2	6cd03b64-6890-4c6d-967f-121e1741dd10	1	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	7a9e4185-6281-4c42-b3c4-1980e6855a31	7a9e4185-6281-4c42-b3c4-1980e6855a31	2025-05-07 03:00:00+00	2025-06-09 03:00:00+00	COMERCIAL	Etapa 1 importada
a2038e53-1508-460c-82b3-07322169a534	c889d2d6-b997-4ee1-820d-a0ece47ae17b	1	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-05-07 03:00:00+00	2025-06-10 03:00:00+00	COMERCIAL	Etapa 1 importada
4746019f-919d-46d8-a20a-a22e19fb2920	ad40ea2f-34b2-48b5-9890-cb9e96154d87	1	daccfce7-5e1e-4429-8f97-600fe78a1855	7a9e4185-6281-4c42-b3c4-1980e6855a31	7a9e4185-6281-4c42-b3c4-1980e6855a31	2025-05-09 03:00:00+00	2025-05-19 03:00:00+00	COMERCIAL	Etapa 1 importada
c548929a-ac47-4814-9daf-fd5e56222d18	7fb87527-817b-43f1-bea7-e3e564cedd08	1	c2c3c456-5f2c-47a2-a8af-d41dc148a19f	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-05-15 03:00:00+00	2025-05-27 03:00:00+00	COMERCIAL	Etapa 1 importada
43992822-4437-47aa-8873-5b5f33fcaf99	2d937399-4aff-454a-8199-17b4d81a6160	1	089b0ead-176b-4e7a-b99d-5caeea74ea61	a269cdaa-b6a8-4b05-b44a-042cd68106e4	a269cdaa-b6a8-4b05-b44a-042cd68106e4	2025-05-21 03:00:00+00	2025-07-13 03:00:00+00	COMERCIAL	Etapa 1 importada
f44f5a6c-25be-46ae-bb9e-e774af3e5968	02fac296-4a30-4537-b9ab-da3448f698fc	1	7c95d6f8-338a-4bf6-8863-1756cd9f598f	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-05-17 03:00:00+00	2025-07-13 03:00:00+00	COMERCIAL	Etapa 1 importada
e07589e7-be9f-41a5-88f4-1708e5802487	8f75b9ef-5c2a-4153-a385-2aad0dc51c0f	1	7c95d6f8-338a-4bf6-8863-1756cd9f598f	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-05-22 03:00:00+00	2025-06-17 03:00:00+00	COMERCIAL	Etapa 1 importada
fe69b7cf-6890-445a-aae9-303a3952b23c	a22200aa-163c-49e2-937e-b0a8c5f19157	1	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-05-22 03:00:00+00	2025-06-05 03:00:00+00	COMERCIAL	Etapa 1 importada
1e739fad-b95e-48b2-b690-01e47ecdf21e	00e11fc6-81c3-4969-b8b4-beecf8ae8174	1	089b0ead-176b-4e7a-b99d-5caeea74ea61	7a9e4185-6281-4c42-b3c4-1980e6855a31	7a9e4185-6281-4c42-b3c4-1980e6855a31	2025-05-20 03:00:00+00	2025-06-21 03:00:00+00	COMERCIAL	Etapa 1 importada
2f5e4fc2-ec65-48c7-8084-58dd5718e809	98879b7b-b863-4d88-8711-2f5c5cfeeaa5	1	7bfb912c-3ee4-426e-a976-68bbbf6bc1d4	\N	\N	2025-05-27 03:00:00+00	2025-07-12 03:00:00+00	COMERCIAL	Etapa 1 importada
642e3d13-6b5d-46f6-9ae2-f5e033195641	b1a638a5-b5de-43d3-9988-249b46d677e0	1	7bfb912c-3ee4-426e-a976-68bbbf6bc1d4	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-05-31 03:00:00+00	2025-07-11 03:00:00+00	COMERCIAL	Etapa 1 importada
3e0ce636-fe12-42df-8411-40f1a04c9bb9	b293b413-8b61-4584-a548-b4e96728af0e	1	daccfce7-5e1e-4429-8f97-600fe78a1855	7a9e4185-6281-4c42-b3c4-1980e6855a31	7a9e4185-6281-4c42-b3c4-1980e6855a31	2025-05-26 03:00:00+00	2025-06-03 03:00:00+00	COMERCIAL	Etapa 1 importada
cafc7681-9908-4a18-81b9-bb50430f487c	b293b413-8b61-4584-a548-b4e96728af0e	2	daccfce7-5e1e-4429-8f97-600fe78a1855	7a9e4185-6281-4c42-b3c4-1980e6855a31	7a9e4185-6281-4c42-b3c4-1980e6855a31	2025-06-04 03:00:00+00	2025-06-10 03:00:00+00	COMERCIAL	Etapa 2 importada
2d5c619e-029b-4b6b-9780-6ca10364dead	71cb28d3-0f4e-4ba8-8696-ca682bea44fe	1	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-05-31 03:00:00+00	2025-06-07 03:00:00+00	COMERCIAL	Etapa 1 importada
d65c36d2-7769-4381-b790-67327d237edc	f145588b-3628-4e38-bfa3-266dec6a1ceb	1	7c95d6f8-338a-4bf6-8863-1756cd9f598f	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-06-12 03:00:00+00	2025-06-20 03:00:00+00	COMERCIAL	Etapa 1 importada
c9cde33e-05fe-404e-95f4-e9739d609da1	f145588b-3628-4e38-bfa3-266dec6a1ceb	2	7c95d6f8-338a-4bf6-8863-1756cd9f598f	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-06-24 03:00:00+00	2025-07-05 03:00:00+00	COMERCIAL	Etapa 2 importada
7f4feac7-57c2-4d32-9e34-b02f90eae590	f145588b-3628-4e38-bfa3-266dec6a1ceb	3	7c95d6f8-338a-4bf6-8863-1756cd9f598f	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-07-08 03:00:00+00	2025-07-16 03:00:00+00	COMERCIAL	Etapa 3 importada
98f9c81a-9390-47a8-b49d-b64a917b3bc8	f145588b-3628-4e38-bfa3-266dec6a1ceb	4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-07-19 03:00:00+00	2025-07-25 03:00:00+00	COMERCIAL	Etapa 4 importada
6fc964a5-d600-47b8-abaa-86c42d00de06	e2ca8345-f8a8-471e-819d-91c7a325eb48	1	7c95d6f8-338a-4bf6-8863-1756cd9f598f	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-06-05 03:00:00+00	2025-07-06 03:00:00+00	COMERCIAL	Etapa 1 importada
d738b067-4c6c-40b8-965c-ebd1be64e842	b46086cd-5e9d-4f2a-8725-bc515f2cf543	1	7c95d6f8-338a-4bf6-8863-1756cd9f598f	7f1cac29-7e2c-4b6d-8447-1a5a9108fd12	7f1cac29-7e2c-4b6d-8447-1a5a9108fd12	2025-06-05 03:00:00+00	2025-07-06 03:00:00+00	COMERCIAL	Etapa 1 importada
76dbe0f5-e6b3-4994-8f71-2596863e40be	8771bc92-95e8-43b4-9a22-234bf00ea287	1	089b0ead-176b-4e7a-b99d-5caeea74ea61	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-06-18 03:00:00+00	2025-07-03 03:00:00+00	COMERCIAL	Etapa 1 importada
506fa917-57c6-49e8-a4f6-7da87b7ce30e	0f475caa-0780-46ba-90a2-61c893aade36	1	7c95d6f8-338a-4bf6-8863-1756cd9f598f	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-06-10 03:00:00+00	2025-06-17 03:00:00+00	COMERCIAL	Etapa 1 importada
ec8ad24c-e829-4671-9611-5d8524960d24	0f475caa-0780-46ba-90a2-61c893aade36	2	7c95d6f8-338a-4bf6-8863-1756cd9f598f	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-06-19 03:00:00+00	2025-06-22 03:00:00+00	COMERCIAL	Etapa 2 importada
60fa0458-a77e-4774-a2ee-90a5c4d56c96	0f475caa-0780-46ba-90a2-61c893aade36	3	7c95d6f8-338a-4bf6-8863-1756cd9f598f	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-06-28 03:00:00+00	2025-07-04 03:00:00+00	COMERCIAL	Etapa 3 importada
1d424bb6-e1fd-4dfa-b065-6f911dd85e5a	0f475caa-0780-46ba-90a2-61c893aade36	4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-07-06 03:00:00+00	2025-07-10 03:00:00+00	COMERCIAL	Etapa 4 importada
d46cd810-eb89-4e43-9769-f1d8d6c85336	0f475caa-0780-46ba-90a2-61c893aade36	5	7c95d6f8-338a-4bf6-8863-1756cd9f598f	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-07-12 03:00:00+00	2025-07-16 03:00:00+00	COMERCIAL	Etapa 5 importada
4cec80f6-2b05-4a44-9710-6d234206394d	8239a760-f987-4940-86f7-05d00f4de3fc	1	daccfce7-5e1e-4429-8f97-600fe78a1855	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-06-18 03:00:00+00	2025-06-25 03:00:00+00	COMERCIAL	Etapa 1 importada
e9a8d27a-fe64-47c6-9dbe-ca28448fff4f	8239a760-f987-4940-86f7-05d00f4de3fc	2	daccfce7-5e1e-4429-8f97-600fe78a1855	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-06-27 03:00:00+00	2025-07-11 03:00:00+00	COMERCIAL	Etapa 2 importada
e489234b-a4e0-44e8-ba55-94ac2f1ab1a9	4d21d19d-4b03-47db-9c0b-5152a757fbf4	1	daccfce7-5e1e-4429-8f97-600fe78a1855	7a9e4185-6281-4c42-b3c4-1980e6855a31	7a9e4185-6281-4c42-b3c4-1980e6855a31	2025-06-17 03:00:00+00	2025-07-10 03:00:00+00	COMERCIAL	Etapa 1 importada
083fe5b1-49a4-4385-8a39-ca37916d8f05	981fab8c-6832-4733-83ef-46eac045c3dd	1	daccfce7-5e1e-4429-8f97-600fe78a1855	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-06-18 03:00:00+00	2025-06-25 03:00:00+00	COMERCIAL	Etapa 1 importada
cd6fc2ec-24c7-43d1-8dcc-a16e119dd888	4af76975-cdf5-477d-b0c8-b4dadce8d599	1	daccfce7-5e1e-4429-8f97-600fe78a1855	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-06-18 03:00:00+00	2025-06-25 03:00:00+00	COMERCIAL	Etapa 1 importada
3ea24f5e-dcd6-400b-8cfc-2f94137435fb	5d2000dd-6b2d-4950-a747-60789a7f620e	1	daccfce7-5e1e-4429-8f97-600fe78a1855	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-06-18 03:00:00+00	2025-06-25 03:00:00+00	COMERCIAL	Etapa 1 importada
e2e532b6-e54d-406c-b6cf-3d2dc7ad6d21	e8041510-9b74-4285-ba12-ce5cafe76d87	1	daccfce7-5e1e-4429-8f97-600fe78a1855	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-06-18 03:00:00+00	2025-06-25 03:00:00+00	COMERCIAL	Etapa 1 importada
eb37e6e0-f59e-4b53-8c90-f47d445399ac	e8041510-9b74-4285-ba12-ce5cafe76d87	2	daccfce7-5e1e-4429-8f97-600fe78a1855	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-06-27 03:00:00+00	2025-07-04 03:00:00+00	COMERCIAL	Etapa 2 importada
87a311b0-67c1-41ab-9cad-f6c165cf1bb2	0a20e0d2-0590-4512-8886-90bdd19ad006	1	7c95d6f8-338a-4bf6-8863-1756cd9f598f	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-06-25 03:00:00+00	2025-07-03 03:00:00+00	COMERCIAL	Etapa 1 importada
dad7211a-d23c-4454-be2c-1917d45fb20d	0a20e0d2-0590-4512-8886-90bdd19ad006	2	7c95d6f8-338a-4bf6-8863-1756cd9f598f	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-07-05 03:00:00+00	2025-07-11 03:00:00+00	COMERCIAL	Etapa 2 importada
7eaa2650-86e1-4918-b744-876e529cf7cc	0a20e0d2-0590-4512-8886-90bdd19ad006	3	7c95d6f8-338a-4bf6-8863-1756cd9f598f	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-07-20 03:00:00+00	2025-07-26 03:00:00+00	COMERCIAL	Etapa 3 importada
a389001c-bcd2-49f9-8b26-679becf7eb7d	0a20e0d2-0590-4512-8886-90bdd19ad006	4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-07-28 03:00:00+00	2025-08-04 03:00:00+00	COMERCIAL	Etapa 4 importada
39e4c9e9-84ff-4f0f-a930-75a5ae67468e	36f8b629-8513-44f9-be1d-149a07cbd0b7	1	daccfce7-5e1e-4429-8f97-600fe78a1855	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-06-27 03:00:00+00	2025-07-21 03:00:00+00	COMERCIAL	Etapa 1 importada
38725e7a-3fc2-46e4-9a3b-a6604e2b3b01	91d66e1a-bcf6-44f0-92e4-6337e4a3e09d	1	daccfce7-5e1e-4429-8f97-600fe78a1855	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-06-27 03:00:00+00	2025-07-03 03:00:00+00	COMERCIAL	Etapa 1 importada
7a8b26bf-c930-4bd8-97e3-6a13bf079d0a	91d66e1a-bcf6-44f0-92e4-6337e4a3e09d	2	daccfce7-5e1e-4429-8f97-600fe78a1855	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-07-04 03:00:00+00	2025-07-11 03:00:00+00	COMERCIAL	Etapa 2 importada
6bf6895d-1f67-499b-962b-3f2114f04028	215eee76-2107-47a3-a401-664d82ad41a4	1	daccfce7-5e1e-4429-8f97-600fe78a1855	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-06-27 03:00:00+00	2025-07-17 03:00:00+00	COMERCIAL	Etapa 1 importada
fb08d7c8-0917-464c-8693-2b8ad6dc88d2	8da8e5c1-5731-4ccd-971d-87930c320963	1	7c95d6f8-338a-4bf6-8863-1756cd9f598f	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-07-12 03:00:00+00	2025-07-14 03:00:00+00	COMERCIAL	Etapa 1 importada
4a7e3893-6281-4a49-99f8-3c07e2013afe	8da8e5c1-5731-4ccd-971d-87930c320963	2	7c95d6f8-338a-4bf6-8863-1756cd9f598f	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-07-18 03:00:00+00	2025-07-23 03:00:00+00	COMERCIAL	Etapa 2 importada
91493ab0-766f-4214-9be4-41fd169a5ce7	8da8e5c1-5731-4ccd-971d-87930c320963	3	7c95d6f8-338a-4bf6-8863-1756cd9f598f	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-07-27 03:00:00+00	2025-08-01 03:00:00+00	COMERCIAL	Etapa 3 importada
f64f8c1b-934e-4cd6-858f-b4ff67cced79	8e385152-b072-49fa-ac7b-f3799b0aff6a	1	\N	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-07-10 03:00:00+00	2025-08-29 03:00:00+00	COMERCIAL	Etapa 1 importada
869d9435-49fd-47fb-b58f-fbc502bf142e	c459611a-073a-48f0-a3c6-bf568dd5ab07	1	\N	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-07-14 03:00:00+00	2025-08-28 03:00:00+00	COMERCIAL	Etapa 1 importada
c1954a4f-1469-4bb2-b3f3-8c62cfc66fb8	c231775c-9b78-4262-9c75-6bb4022698b6	1	daccfce7-5e1e-4429-8f97-600fe78a1855	7a9e4185-6281-4c42-b3c4-1980e6855a31	7a9e4185-6281-4c42-b3c4-1980e6855a31	2025-07-11 03:00:00+00	2025-08-20 03:00:00+00	COMERCIAL	Etapa 1 importada
dd76aa4b-eb55-4041-a000-bc2af4d24b33	da1083d0-6d3c-414a-8462-85d5c0b4bed1	1	daccfce7-5e1e-4429-8f97-600fe78a1855	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-07-13 03:00:00+00	2025-08-05 03:00:00+00	COMERCIAL	Etapa 1 importada
fca6d43f-56fc-4cd9-9412-8eab0117f7ee	1a43f6af-10a9-428c-96af-7a28bc7c5b34	1	7c95d6f8-338a-4bf6-8863-1756cd9f598f	260e778c-d7a5-4509-938b-9bd69004656f	260e778c-d7a5-4509-938b-9bd69004656f	2025-07-12 03:00:00+00	2025-08-23 03:00:00+00	COMERCIAL	Etapa 1 importada
18e31c93-1fec-41ab-a182-29f51f560fcf	fdfc020a-5ea8-4a38-a696-b10160cfbf23	1	daccfce7-5e1e-4429-8f97-600fe78a1855	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-07-18 03:00:00+00	2025-07-25 03:00:00+00	COMERCIAL	Etapa 1 importada
c138571e-e535-4b0c-b353-cd725a557a8f	fdfc020a-5ea8-4a38-a696-b10160cfbf23	2	daccfce7-5e1e-4429-8f97-600fe78a1855	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-07-26 03:00:00+00	2025-08-03 03:00:00+00	COMERCIAL	Etapa 2 importada
19a10342-221b-471f-a97f-484c41948377	fdfc020a-5ea8-4a38-a696-b10160cfbf23	3	daccfce7-5e1e-4429-8f97-600fe78a1855	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-08-04 03:00:00+00	2025-08-10 03:00:00+00	COMERCIAL	Etapa 3 importada
9f92356c-ba65-4941-8fc5-3b636af92e57	fdfc020a-5ea8-4a38-a696-b10160cfbf23	4	daccfce7-5e1e-4429-8f97-600fe78a1855	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-08-11 03:00:00+00	2025-08-17 03:00:00+00	COMERCIAL	Etapa 4 importada
a69a9745-e3aa-46e0-a2e7-24b51c2c535b	4061951a-e2f3-4588-8a81-1ad5e3d5cf70	1	7bfb912c-3ee4-426e-a976-68bbbf6bc1d4	\N	\N	2025-07-17 03:00:00+00	2025-09-04 03:00:00+00	COMERCIAL	Etapa 1 importada
22c44535-9849-4b40-be6d-14c53542526e	12adcd78-0f99-4786-88e9-7f1b53d364c3	1	7c95d6f8-338a-4bf6-8863-1756cd9f598f	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-07-19 03:00:00+00	2025-08-19 03:00:00+00	COMERCIAL	Etapa 1 importada
9004cf15-9e60-464e-9a6d-d81dfd54b7c0	d66d005e-e7f6-4a80-888f-742e380b15d0	1	7c95d6f8-338a-4bf6-8863-1756cd9f598f	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-07-19 03:00:00+00	2025-08-23 03:00:00+00	COMERCIAL	Etapa 1 importada
c3d2f153-0b6f-4134-b3aa-9ca65428bf18	db80ca37-beaa-4e3f-a9e9-75abcbcaa066	1	daccfce7-5e1e-4429-8f97-600fe78a1855	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-07-21 03:00:00+00	\N	COMERCIAL	Etapa generada automáticamente (sin desglose)
5b59ba6d-d65c-4210-961a-f4539fb5f2d4	e7d698f5-fc82-48c2-acb7-620a8dd00000	1	daccfce7-5e1e-4429-8f97-600fe78a1855	\N	\N	2025-07-23 03:00:00+00	2025-10-07 03:00:00+00	COMERCIAL	Etapa 1 importada
0fa3321a-b873-4299-9b97-900a2c262cfd	aaba4967-5646-497b-af4a-d91159b24152	1	daccfce7-5e1e-4429-8f97-600fe78a1855	\N	\N	2025-07-23 03:00:00+00	2025-09-27 03:00:00+00	COMERCIAL	Etapa 1 importada
6fb6bd5d-0207-4bdf-83ff-4563762aec16	9f1c446c-c3d7-41a0-b578-fc7ad021a15b	1	daccfce7-5e1e-4429-8f97-600fe78a1855	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-07-24 03:00:00+00	2025-08-30 03:00:00+00	COMERCIAL	Etapa 1 importada
dd9fc673-7944-4c06-90e4-c13b2bfed120	a8dea641-66e3-4f4e-b528-299fd17ad983	1	7c95d6f8-338a-4bf6-8863-1756cd9f598f	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-07-29 03:00:00+00	2025-08-03 03:00:00+00	COMERCIAL	Etapa 1 importada
6b333c97-9f2b-4259-a80d-c49b748a4a17	a8dea641-66e3-4f4e-b528-299fd17ad983	2	7c95d6f8-338a-4bf6-8863-1756cd9f598f	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-08-06 03:00:00+00	2025-08-14 03:00:00+00	COMERCIAL	Etapa 2 importada
84bd717f-e229-4eae-abb1-f23fcc49f514	a8dea641-66e3-4f4e-b528-299fd17ad983	3	7c95d6f8-338a-4bf6-8863-1756cd9f598f	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-08-16 03:00:00+00	2025-08-23 03:00:00+00	COMERCIAL	Etapa 3 importada
1677e8d8-533d-4853-9318-52c2d3899ad0	c87874c5-2bbd-4158-8334-5a6c9867a589	1	c2c3c456-5f2c-47a2-a8af-d41dc148a19f	7a9e4185-6281-4c42-b3c4-1980e6855a31	7a9e4185-6281-4c42-b3c4-1980e6855a31	2025-07-29 03:00:00+00	2025-09-13 03:00:00+00	COMERCIAL	Etapa 1 importada
21a814d1-e3cf-4939-8b49-6661c1cb67fe	fcbeade7-fd24-4771-90d8-d194a5e9db8b	1	daccfce7-5e1e-4429-8f97-600fe78a1855	\N	\N	2025-07-30 03:00:00+00	2025-08-04 03:00:00+00	COMERCIAL	Etapa 1 importada
7775703a-c911-4833-8848-13bdf10d9941	29455e29-1cb5-4408-9d5a-b5d60b72a0d0	1	daccfce7-5e1e-4429-8f97-600fe78a1855	\N	\N	2025-08-04 03:00:00+00	2025-08-14 03:00:00+00	COMERCIAL	Etapa 1 importada
ec944c04-e366-45ce-8c8b-91d88d3c0ee5	29455e29-1cb5-4408-9d5a-b5d60b72a0d0	2	daccfce7-5e1e-4429-8f97-600fe78a1855	\N	\N	2025-08-15 03:00:00+00	2025-09-07 03:00:00+00	COMERCIAL	Etapa 2 importada
db34f9bc-eb50-4f17-a2d1-27d370325228	f20dc72a-c272-44aa-bb99-13934679e7c6	1	daccfce7-5e1e-4429-8f97-600fe78a1855	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-08-01 03:00:00+00	2025-08-23 03:00:00+00	COMERCIAL	Etapa 1 importada
57b0e819-ac24-40ff-8eac-878dafa05164	b4cbac19-0032-48f3-86df-eeb97376a53b	1	daccfce7-5e1e-4429-8f97-600fe78a1855	9e97a6b3-cca1-4931-92e9-ab8a5e0b35e1	9e97a6b3-cca1-4931-92e9-ab8a5e0b35e1	2025-08-03 03:00:00+00	2025-08-23 03:00:00+00	COMERCIAL	Etapa 1 importada
a8919441-c03b-4b94-aa80-6671acb2c9e7	52664ce3-d49e-4862-ae60-1d3c91d273d4	1	daccfce7-5e1e-4429-8f97-600fe78a1855	\N	\N	2025-08-05 03:00:00+00	2025-08-13 03:00:00+00	COMERCIAL	Etapa 1 importada
914b1a9b-07db-490e-b74e-eb71dc129e54	a06af4fd-cd7c-49b3-abb2-8d63015e25fe	1	7c95d6f8-338a-4bf6-8863-1756cd9f598f	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-08-07 03:00:00+00	2025-08-14 03:00:00+00	COMERCIAL	Etapa 1 importada
405c7db6-0461-4f37-8d5c-4f4b3acea32a	a06af4fd-cd7c-49b3-abb2-8d63015e25fe	2	7c95d6f8-338a-4bf6-8863-1756cd9f598f	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-08-20 03:00:00+00	2025-08-27 03:00:00+00	COMERCIAL	Etapa 2 importada
7e81291d-69d0-45b5-9b5f-8f062d9c0e81	a06af4fd-cd7c-49b3-abb2-8d63015e25fe	3	7c95d6f8-338a-4bf6-8863-1756cd9f598f	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-08-29 03:00:00+00	2025-09-05 03:00:00+00	COMERCIAL	Etapa 3 importada
ad17eebd-82e3-4532-84ff-db86b6dd75dd	a06af4fd-cd7c-49b3-abb2-8d63015e25fe	4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-09-08 03:00:00+00	2025-09-16 03:00:00+00	COMERCIAL	Etapa 4 importada
adad67c5-54f1-4ffa-ad0a-64da5fd85f5d	186acbd5-ca5d-4ce7-a7b8-e109d62d625e	1	daccfce7-5e1e-4429-8f97-600fe78a1855	\N	\N	2025-08-08 03:00:00+00	2025-09-24 03:00:00+00	COMERCIAL	Etapa 1 importada
b7b07b11-c946-490d-a14d-57ca30bcb30b	2a7407a5-8754-4434-ba31-fecface06bf7	1	daccfce7-5e1e-4429-8f97-600fe78a1855	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-08-07 03:00:00+00	2025-09-23 03:00:00+00	COMERCIAL	Etapa 1 importada
c719e4ef-9c39-48bf-8650-f9eabda9fc7a	9f386967-b338-415b-99f4-136badedd2a1	1	7c95d6f8-338a-4bf6-8863-1756cd9f598f	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-08-14 03:00:00+00	2025-08-22 03:00:00+00	COMERCIAL	Etapa 1 importada
29291c18-2a22-4ad7-b585-23ab28b1b249	9f386967-b338-415b-99f4-136badedd2a1	2	7c95d6f8-338a-4bf6-8863-1756cd9f598f	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-08-26 03:00:00+00	2025-09-05 03:00:00+00	COMERCIAL	Etapa 2 importada
994dcb71-8a85-4697-a04e-26b483f151eb	9f386967-b338-415b-99f4-136badedd2a1	3	7c95d6f8-338a-4bf6-8863-1756cd9f598f	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-09-09 03:00:00+00	2025-09-09 03:00:00+00	COMERCIAL	Etapa 3 importada
ca8edbc6-2bae-4393-bb77-9216ca39aa87	9f386967-b338-415b-99f4-136badedd2a1	4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-09-13 03:00:00+00	2025-09-23 03:00:00+00	COMERCIAL	Etapa 4 importada
364b5cef-d267-4084-8e88-74d87d0f84b4	895456d9-265c-4303-b35e-7de43c967339	1	7c95d6f8-338a-4bf6-8863-1756cd9f598f	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-08-16 03:00:00+00	2025-08-25 03:00:00+00	COMERCIAL	Etapa 1 importada
c930bdda-e8f1-415e-94d4-06930b082c74	895456d9-265c-4303-b35e-7de43c967339	2	7c95d6f8-338a-4bf6-8863-1756cd9f598f	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-08-28 03:00:00+00	2025-09-06 03:00:00+00	COMERCIAL	Etapa 2 importada
8606b35e-eed8-49b7-a9d2-957731ec465d	895456d9-265c-4303-b35e-7de43c967339	3	7c95d6f8-338a-4bf6-8863-1756cd9f598f	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-09-08 03:00:00+00	2025-09-18 03:00:00+00	COMERCIAL	Etapa 3 importada
ecaca1ce-10f8-4814-9c96-89bb691c6495	631f6ad1-e76e-4d1f-9204-fea4f4c547d8	1	7c95d6f8-338a-4bf6-8863-1756cd9f598f	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-08-22 03:00:00+00	2025-09-22 03:00:00+00	COMERCIAL	Etapa 1 importada
5c4b2173-a38f-4f71-b264-47fb5acfab81	75279f40-4d1d-480a-b9f0-9cc45ab4dd8d	1	daccfce7-5e1e-4429-8f97-600fe78a1855	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-08-19 03:00:00+00	2025-08-31 03:00:00+00	COMERCIAL	Etapa 1 importada
914593b0-6d43-4514-8aaa-bdcbdea044fe	b3a88fa9-d7ae-4004-9f12-766e8b90dba3	1	daccfce7-5e1e-4429-8f97-600fe78a1855	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-08-20 03:00:00+00	2025-09-18 03:00:00+00	COMERCIAL	Etapa 1 importada
6dc99f82-923b-4d83-a494-18dc62dc9e76	cad981bd-a054-42fc-ab60-6ec82aee7366	1	daccfce7-5e1e-4429-8f97-600fe78a1855	\N	\N	2025-08-25 03:00:00+00	2025-09-07 03:00:00+00	COMERCIAL	Etapa 1 importada
fdfab242-9f9f-4a09-ab6e-db7feeafbae2	09d2efb7-4ffe-4e9d-869b-ba14a3f91534	1	daccfce7-5e1e-4429-8f97-600fe78a1855	\N	\N	2025-08-31 03:00:00+00	2025-10-08 03:00:00+00	COMERCIAL	Etapa 1 importada
2a0ba2ba-09d0-4bce-9def-335b36e11418	6817994e-7dc2-4a00-9bd9-cde763cc2ad1	1	7c95d6f8-338a-4bf6-8863-1756cd9f598f	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-08-30 03:00:00+00	2025-10-06 03:00:00+00	COMERCIAL	Etapa 1 importada
473ec6f3-f199-420c-8055-c9fbdca70c7a	848ab357-d77a-4bc2-a4d9-414b4766e65f	1	daccfce7-5e1e-4429-8f97-600fe78a1855	9e97a6b3-cca1-4931-92e9-ab8a5e0b35e1	9e97a6b3-cca1-4931-92e9-ab8a5e0b35e1	2025-09-04 03:00:00+00	2025-09-16 03:00:00+00	COMERCIAL	Etapa 1 importada
0cafd781-797f-47f5-bd1a-e6a1619684df	42016b47-6334-4c4c-91dd-1bf03acbff52	1	7bfb912c-3ee4-426e-a976-68bbbf6bc1d4	\N	\N	2025-09-10 03:00:00+00	2025-10-20 03:00:00+00	COMERCIAL	Etapa 1 importada
100a5c0a-d0e6-4674-af50-b90082348bf7	86082db1-9f3f-494a-8a52-95eede79efce	1	c2c3c456-5f2c-47a2-a8af-d41dc148a19f	7a9e4185-6281-4c42-b3c4-1980e6855a31	7a9e4185-6281-4c42-b3c4-1980e6855a31	2025-09-11 03:00:00+00	2025-10-01 03:00:00+00	COMERCIAL	Etapa 1 importada
50b28ea9-6ff8-417b-965b-5e2bc8c171bc	d4bc315b-7693-45e7-bf6c-04e14fbb20b4	1	7c95d6f8-338a-4bf6-8863-1756cd9f598f	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-09-11 03:00:00+00	2025-10-18 03:00:00+00	COMERCIAL	Etapa 1 importada
efa38b77-71a0-4c37-a60d-917c5e4dd6d7	e62a6272-41c3-42ee-a529-10f41b975517	1	daccfce7-5e1e-4429-8f97-600fe78a1855	\N	\N	2025-09-13 03:00:00+00	2025-10-13 03:00:00+00	COMERCIAL	Etapa 1 importada
6d1c43dd-3133-414c-bdc9-023776ffd366	72d0ba61-74b5-4324-9772-11837b6b263c	1	c2c3c456-5f2c-47a2-a8af-d41dc148a19f	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-10-14 03:00:00+00	2025-11-08 03:00:00+00	COMERCIAL	Etapa 1 importada
82dbccab-649f-4a0d-a305-62f940452ebf	374223da-ae98-4fa2-aafe-a6862f235a39	1	c2c3c456-5f2c-47a2-a8af-d41dc148a19f	7a9e4185-6281-4c42-b3c4-1980e6855a31	7a9e4185-6281-4c42-b3c4-1980e6855a31	2025-10-15 03:00:00+00	2025-11-08 03:00:00+00	COMERCIAL	Etapa 1 importada
da95a3d6-e8ea-44d5-82d9-3c7b354ac8d1	d0c896ca-f982-452a-92b0-491df1cc9a60	1	c2c3c456-5f2c-47a2-a8af-d41dc148a19f	7a9e4185-6281-4c42-b3c4-1980e6855a31	7a9e4185-6281-4c42-b3c4-1980e6855a31	2025-10-11 03:00:00+00	2025-12-21 03:00:00+00	COMERCIAL	Etapa 1 importada
a1709ea8-a5b3-48f9-bae4-462191d65325	bce66084-90a4-439b-937c-d25f4ba1c75a	1	c2c3c456-5f2c-47a2-a8af-d41dc148a19f	7a9e4185-6281-4c42-b3c4-1980e6855a31	7a9e4185-6281-4c42-b3c4-1980e6855a31	2025-10-11 03:00:00+00	2025-12-07 03:00:00+00	COMERCIAL	Etapa 1 importada
d72362ed-186d-42b3-90e4-f1db70f68599	2b2cf340-d8c1-494f-9f65-4c9cabc9fd5d	1	089b0ead-176b-4e7a-b99d-5caeea74ea61	a269cdaa-b6a8-4b05-b44a-042cd68106e4	a269cdaa-b6a8-4b05-b44a-042cd68106e4	2025-09-16 03:00:00+00	2025-11-19 03:00:00+00	COMERCIAL	Etapa 1 importada
cee6d3b7-484b-43d8-9559-76e5514f92b5	f0a855c4-87b7-4cfb-a212-0bba29612878	1	daccfce7-5e1e-4429-8f97-600fe78a1855	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-09-19 03:00:00+00	2025-10-07 03:00:00+00	COMERCIAL	Etapa 1 importada
fe42c5a1-024a-46c3-b79f-992a54aa3dcf	51f280b0-c38b-4a78-817d-49010fb8dca8	1	089b0ead-176b-4e7a-b99d-5caeea74ea61	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-09-29 03:00:00+00	2025-10-30 03:00:00+00	COMERCIAL	Etapa 1 importada
c3516ff5-a94a-4dab-976c-62105746bd75	622eb238-54ed-4053-8a31-c7418fc5a655	1	089b0ead-176b-4e7a-b99d-5caeea74ea61	9e97a6b3-cca1-4931-92e9-ab8a5e0b35e1	9e97a6b3-cca1-4931-92e9-ab8a5e0b35e1	2025-09-28 03:00:00+00	2025-11-07 03:00:00+00	COMERCIAL	Etapa 1 importada
b3945772-5840-427f-840a-ffd375cc300c	16f4924f-db37-4ae9-a0c1-8c6d78700ed9	1	7c95d6f8-338a-4bf6-8863-1756cd9f598f	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-09-30 03:00:00+00	2025-10-05 03:00:00+00	COMERCIAL	Etapa 1 importada
a82506b2-5f82-4360-9829-ed977ebdd63c	16f4924f-db37-4ae9-a0c1-8c6d78700ed9	2	7c95d6f8-338a-4bf6-8863-1756cd9f598f	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-10-07 03:00:00+00	2025-10-12 03:00:00+00	COMERCIAL	Etapa 2 importada
200eeadf-acb4-4597-bc35-18d424d7e29b	16f4924f-db37-4ae9-a0c1-8c6d78700ed9	3	7c95d6f8-338a-4bf6-8863-1756cd9f598f	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-10-14 03:00:00+00	2025-10-18 03:00:00+00	COMERCIAL	Etapa 3 importada
498b99ff-3248-4a23-82ba-218dc88227b7	16f4924f-db37-4ae9-a0c1-8c6d78700ed9	4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-10-20 03:00:00+00	2025-10-24 03:00:00+00	COMERCIAL	Etapa 4 importada
9405eb73-6baf-46ca-8c8c-8af3fa9c42c9	16f4924f-db37-4ae9-a0c1-8c6d78700ed9	5	7c95d6f8-338a-4bf6-8863-1756cd9f598f	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-10-26 03:00:00+00	2025-10-31 03:00:00+00	COMERCIAL	Etapa 5 importada
cf517edb-64eb-42fb-8105-4fab615e65af	16f4924f-db37-4ae9-a0c1-8c6d78700ed9	6	7c95d6f8-338a-4bf6-8863-1756cd9f598f	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-11-01 03:00:00+00	2025-11-09 03:00:00+00	COMERCIAL	Etapa 6 importada
32e45520-cda3-4581-892c-f79d3b0a7987	c02d7370-1d59-4961-9f81-b07619d2695c	1	7c95d6f8-338a-4bf6-8863-1756cd9f598f	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-10-14 03:00:00+00	2025-11-23 03:00:00+00	COMERCIAL	Etapa 1 importada
309c57a7-a55d-413e-aa03-e91df47e9fc7	ccd384cf-d047-436d-8aef-987b9c1c04f6	1	c2c3c456-5f2c-47a2-a8af-d41dc148a19f	7a9e4185-6281-4c42-b3c4-1980e6855a31	7a9e4185-6281-4c42-b3c4-1980e6855a31	2025-10-11 03:00:00+00	2025-12-07 03:00:00+00	COMERCIAL	Etapa 1 importada
8d2ba390-583e-4fa7-83b7-d69cb227b8bd	3f626d50-76fd-4934-b50b-7f4d38f92353	1	7c95d6f8-338a-4bf6-8863-1756cd9f598f	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-10-19 03:00:00+00	2025-10-23 03:00:00+00	COMERCIAL	Etapa 1 importada
9c8a6372-3464-4075-b187-a3ab21564156	3f626d50-76fd-4934-b50b-7f4d38f92353	2	7c95d6f8-338a-4bf6-8863-1756cd9f598f	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-10-24 03:00:00+00	2025-10-29 03:00:00+00	COMERCIAL	Etapa 2 importada
3753ba3d-fada-4c25-b135-d1411c0969e0	3f626d50-76fd-4934-b50b-7f4d38f92353	3	7c95d6f8-338a-4bf6-8863-1756cd9f598f	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-11-03 03:00:00+00	2025-11-10 03:00:00+00	COMERCIAL	Etapa 3 importada
b5806207-dfc0-487c-a898-f50ee34388ea	ae40317b-c514-4f2c-b12c-5b63269321d2	1	7bfb912c-3ee4-426e-a976-68bbbf6bc1d4	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-10-30 03:00:00+00	2025-12-11 03:00:00+00	COMERCIAL	Etapa 1 importada
5c9bb8c2-172c-4e24-915d-7f9e8e016a2f	64df8d4b-89ff-4533-a3d2-e98ee10b731f	1	c2c3c456-5f2c-47a2-a8af-d41dc148a19f	7a9e4185-6281-4c42-b3c4-1980e6855a31	7a9e4185-6281-4c42-b3c4-1980e6855a31	2025-10-23 03:00:00+00	2025-11-26 03:00:00+00	COMERCIAL	Etapa 1 importada
277aa484-1c06-4b8f-ba1b-0062f727a3a2	115f3be2-67c1-4e63-8766-3488ec401619	1	089b0ead-176b-4e7a-b99d-5caeea74ea61	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-10-29 03:00:00+00	2025-11-20 03:00:00+00	COMERCIAL	Etapa 1 importada
1b0b6774-3cf1-4f6e-ba3e-481fcd47ce22	1caed02b-996b-477f-9c67-e1e10f0874fc	1	7bfb912c-3ee4-426e-a976-68bbbf6bc1d4	\N	\N	2025-10-27 03:00:00+00	2025-12-07 03:00:00+00	COMERCIAL	Etapa 1 importada
db0b7567-5e6d-4c3c-94e9-d4affb11ac88	f551dae9-57cd-430c-b0b8-d04574a1617b	1	7c95d6f8-338a-4bf6-8863-1756cd9f598f	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-11-04 03:00:00+00	2025-11-12 03:00:00+00	COMERCIAL	Etapa 1 importada
40d9b84b-4a44-45ba-b999-d8adfb99f596	f551dae9-57cd-430c-b0b8-d04574a1617b	2	7c95d6f8-338a-4bf6-8863-1756cd9f598f	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-11-14 03:00:00+00	2025-11-18 03:00:00+00	COMERCIAL	Etapa 2 importada
27407792-bdc9-4959-ace0-03c4eecc07e1	f551dae9-57cd-430c-b0b8-d04574a1617b	3	7c95d6f8-338a-4bf6-8863-1756cd9f598f	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-11-22 03:00:00+00	2025-11-27 03:00:00+00	COMERCIAL	Etapa 3 importada
9681cead-3cd8-4565-ae5d-a5f07cc59735	f551dae9-57cd-430c-b0b8-d04574a1617b	4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-11-30 03:00:00+00	2025-12-06 03:00:00+00	COMERCIAL	Etapa 4 importada
41df81ba-2e4f-4576-a550-e4573a610d97	fb4ef943-5409-47fd-8a45-2a57fab3f295	1	7c95d6f8-338a-4bf6-8863-1756cd9f598f	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-11-01 03:00:00+00	2025-11-12 03:00:00+00	COMERCIAL	Etapa 1 importada
4b4573e2-6f91-410c-83cd-5f44102e5ae7	f3bfe1c9-fb42-4d5f-9a1f-869490891cbf	1	7c95d6f8-338a-4bf6-8863-1756cd9f598f	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-11-03 03:00:00+00	2025-11-12 03:00:00+00	COMERCIAL	Etapa 1 importada
5bd84c4a-62e4-44b4-ae81-2f62cf6d661b	f3bfe1c9-fb42-4d5f-9a1f-869490891cbf	2	7c95d6f8-338a-4bf6-8863-1756cd9f598f	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-11-14 03:00:00+00	2025-11-21 03:00:00+00	COMERCIAL	Etapa 2 importada
d23f95a1-63b9-4c61-8297-f2a92ff46b70	f3bfe1c9-fb42-4d5f-9a1f-869490891cbf	3	7c95d6f8-338a-4bf6-8863-1756cd9f598f	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-11-23 03:00:00+00	2025-12-01 03:00:00+00	COMERCIAL	Etapa 3 importada
c6d11913-a450-4927-a008-5f9ad92f2d9b	f3bfe1c9-fb42-4d5f-9a1f-869490891cbf	4	7c95d6f8-338a-4bf6-8863-1756cd9f598f	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-12-03 03:00:00+00	2025-12-11 03:00:00+00	COMERCIAL	Etapa 4 importada
bd1f7bea-e1b8-4fe8-9e9e-ab7253e14e92	7d2941cd-d0cb-4ff5-9143-f05867ecd280	1	c2c3c456-5f2c-47a2-a8af-d41dc148a19f	7a9e4185-6281-4c42-b3c4-1980e6855a31	7a9e4185-6281-4c42-b3c4-1980e6855a31	2025-11-07 03:00:00+00	2025-11-25 03:00:00+00	COMERCIAL	Etapa 1 importada
3df9bd86-8f56-4361-9bd2-6f9c664b006b	7d2941cd-d0cb-4ff5-9143-f05867ecd280	2	c2c3c456-5f2c-47a2-a8af-d41dc148a19f	7a9e4185-6281-4c42-b3c4-1980e6855a31	7a9e4185-6281-4c42-b3c4-1980e6855a31	2025-11-28 03:00:00+00	2025-12-21 03:00:00+00	COMERCIAL	Etapa 2 importada
cea78c90-e6dd-491c-aa0e-364e9fb8c228	6a56d4a0-7320-4cd0-a2ec-9ac51440eb30	1	\N	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-11-04 03:00:00+00	2025-11-11 03:00:00+00	COMERCIAL	Etapa 1 importada
9225a1d3-211b-4e14-bb6b-b9665aeed911	ebf2c8b6-5120-4aca-91bf-8e6d5511f331	1	c2c3c456-5f2c-47a2-a8af-d41dc148a19f	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-11-12 03:00:00+00	2025-12-24 03:00:00+00	COMERCIAL	Etapa 1 importada
8679175f-5553-4813-aca7-cff8a5e8ff16	3d2a6806-79c8-4149-8878-a1209e55ba5d	1	7bfb912c-3ee4-426e-a976-68bbbf6bc1d4	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-11-10 03:00:00+00	2025-12-12 03:00:00+00	COMERCIAL	Etapa 1 importada
3e2b1593-6b37-4f3b-bc9b-f22de8d0027c	d352f139-4b5a-4965-8137-a2f7654ba08a	1	089b0ead-176b-4e7a-b99d-5caeea74ea61	a269cdaa-b6a8-4b05-b44a-042cd68106e4	a269cdaa-b6a8-4b05-b44a-042cd68106e4	2025-11-20 03:00:00+00	\N	COMERCIAL	Etapa generada automáticamente (sin desglose)
e9f229ca-0ad4-44a4-98bc-8e3ee48bbc99	cac9ff30-b7a2-430e-920d-ec89a5224332	1	c2c3c456-5f2c-47a2-a8af-d41dc148a19f	7a9e4185-6281-4c42-b3c4-1980e6855a31	7a9e4185-6281-4c42-b3c4-1980e6855a31	2025-11-20 03:00:00+00	\N	COMERCIAL	Etapa generada automáticamente (sin desglose)
38673f83-1164-4cfb-b635-66b6420e3d1d	611c2056-ab40-4db1-9db2-58a81eb57607	1	089b0ead-176b-4e7a-b99d-5caeea74ea61	7a9e4185-6281-4c42-b3c4-1980e6855a31	7a9e4185-6281-4c42-b3c4-1980e6855a31	2025-11-26 03:00:00+00	\N	COMERCIAL	Etapa generada automáticamente (sin desglose)
9642d843-f82c-4fad-9bc7-a604d5a037b5	390d7a7d-0060-4f05-b8d7-b0b513959a9b	1	7c95d6f8-338a-4bf6-8863-1756cd9f598f	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-12-01 03:00:00+00	2025-12-16 03:00:00+00	COMERCIAL	Etapa 1 importada
7677b9ca-73ab-4951-a4a8-fc636cc3a7f5	5749bfda-11a6-484c-b828-146f127de998	1	7bfb912c-3ee4-426e-a976-68bbbf6bc1d4	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-12-15 03:00:00+00	\N	COMERCIAL	Etapa generada automáticamente (sin desglose)
7237d5ac-1c45-49a0-a259-7cf749fae74f	a3294f34-3bf1-495e-bd53-66f550391ba9	1	7bfb912c-3ee4-426e-a976-68bbbf6bc1d4	\N	\N	2025-12-15 03:00:00+00	\N	COMERCIAL	Etapa generada automáticamente (sin desglose)
51dcdded-f829-4657-8d58-ed9924752a57	75075f81-3e8e-4a08-acf2-dfe365951c72	1	089b0ead-176b-4e7a-b99d-5caeea74ea61	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-12-29 03:00:00+00	\N	COMERCIAL	Etapa generada automáticamente (sin desglose)
5d5ceba8-dde7-4725-9902-c888baf5da52	f3282fc2-0cbd-45b4-add8-485d7ac19f39	1	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	7a9e4185-6281-4c42-b3c4-1980e6855a31	7a9e4185-6281-4c42-b3c4-1980e6855a31	2025-12-26 03:00:00+00	\N	COMERCIAL	Etapa generada automáticamente (sin desglose)
50560649-e2f0-4aa6-be75-e5649da21e53	5eb39723-136d-441b-9a24-a3ceb8df63e3	1	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	9e97a6b3-cca1-4931-92e9-ab8a5e0b35e1	9e97a6b3-cca1-4931-92e9-ab8a5e0b35e1	2025-12-29 03:00:00+00	\N	COMERCIAL	Etapa generada automáticamente (sin desglose)
112fd3e1-d305-41ca-aaa7-fff875543082	a9b479f9-eb41-4f3e-b710-346a4f7a5765	1	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	7f1cac29-7e2c-4b6d-8447-1a5a9108fd12	7f1cac29-7e2c-4b6d-8447-1a5a9108fd12	2025-12-29 03:00:00+00	\N	COMERCIAL	Etapa generada automáticamente (sin desglose)
61621452-d7fb-498a-aaf3-245eedbc5b58	927e3ed0-dafe-4c98-a281-078c64cf354f	1	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	\N	\N	2025-12-26 03:00:00+00	\N	COMERCIAL	Etapa generada automáticamente (sin desglose)
aa9f4b02-d571-4cd6-a1d3-b1c9b94e60d3	aca2574c-b75a-40c6-8e11-f6ea8ebeb1c2	1	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	\N	\N	2025-12-26 03:00:00+00	\N	COMERCIAL	Etapa generada automáticamente (sin desglose)
36f3e7a5-f604-4928-98ae-5851e305a366	33e149c6-2857-4cd6-8045-19407c2cfc9e	1	c2c3c456-5f2c-47a2-a8af-d41dc148a19f	7a9e4185-6281-4c42-b3c4-1980e6855a31	7a9e4185-6281-4c42-b3c4-1980e6855a31	2025-12-26 03:00:00+00	\N	COMERCIAL	Etapa generada automáticamente (sin desglose)
73e36249-016b-43aa-93ac-870e378a40eb	806ade78-064c-45c9-a36d-1fb7a2194be6	1	c2c3c456-5f2c-47a2-a8af-d41dc148a19f	7a9e4185-6281-4c42-b3c4-1980e6855a31	7a9e4185-6281-4c42-b3c4-1980e6855a31	2025-12-30 03:00:00+00	\N	COMERCIAL	Etapa generada automáticamente (sin desglose)
4e7acf7c-16ce-49e1-b842-78b359c3d4b7	e7844417-503b-4eb4-9225-af494816ebd8	1	c2c3c456-5f2c-47a2-a8af-d41dc148a19f	7a9e4185-6281-4c42-b3c4-1980e6855a31	7a9e4185-6281-4c42-b3c4-1980e6855a31	2025-12-23 03:00:00+00	\N	COMERCIAL	Etapa generada automáticamente (sin desglose)
7aafb0b0-5382-431e-81fc-d6ba3cc36bd6	cddf9dcb-1e5e-4dfa-9643-566eed1461ca	1	c2c3c456-5f2c-47a2-a8af-d41dc148a19f	7a9e4185-6281-4c42-b3c4-1980e6855a31	7a9e4185-6281-4c42-b3c4-1980e6855a31	2025-12-30 03:00:00+00	\N	COMERCIAL	Etapa generada automáticamente (sin desglose)
2d5708e6-e1c5-4efd-98cf-d8e2d50ecc7e	789f57de-f4c3-4398-ace8-880584ab5ae9	1	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-12-29 03:00:00+00	\N	COMERCIAL	Etapa generada automáticamente (sin desglose)
35cda01c-a62a-4ee4-8787-e3734f535e6d	46a335f6-9487-4ecd-831d-85ba568d7b63	1	7bfb912c-3ee4-426e-a976-68bbbf6bc1d4	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-12-26 03:00:00+00	\N	COMERCIAL	Etapa generada automáticamente (sin desglose)
edc87ceb-0752-4a63-b6ec-641c82e652ba	8e5d0022-2392-405c-a7ca-326d41aaded5	1	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-12-28 03:00:00+00	\N	COMERCIAL	Etapa generada automáticamente (sin desglose)
370422ea-2cc7-468a-9f69-63c9c408a011	9f68feda-51d8-4dcf-aa49-dba8e8a347f2	1	2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	2025-12-28 03:00:00+00	\N	COMERCIAL	Etapa generada automáticamente (sin desglose)
\.


--
-- Data for Name: mareas_etapas_observadores; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mareas_etapas_observadores (id, id_etapa, id_observador, rol, es_designado) FROM stdin;
ac815134-2798-46ff-99ef-f9136ddb5013	0919c4d4-1128-42aa-981d-49f50691ba17	11b3358c-7d76-47dd-bb76-bc68090950f9	PRINCIPAL	t
f74696b9-1f33-4c0b-ab93-181eec28c518	e3ab0887-8521-4fd3-90ca-217f7ad83d41	fe7f31a1-80d9-45ed-9632-feaddc01f0ed	PRINCIPAL	t
0b16f98b-f430-4db2-aa96-b5192b6469ad	7aaf5222-a70b-476a-84af-bcc8c727a8f7	cd62e541-8699-4e78-a979-37ab0a48feb5	PRINCIPAL	t
efb0c280-c42c-4c8d-be84-c2ea6aa88527	7b48a96b-c439-4549-8040-dde04b01664e	8c0214ed-61c1-43aa-a479-baad51350fae	PRINCIPAL	t
21fa8f8e-49d3-4f06-acb4-0b68844ee459	5f9eb14f-4ebd-4c36-b1e3-4aaa2e42880a	04f48fc6-b8c1-475b-9120-ab09092881c9	PRINCIPAL	t
7d1070f7-e730-4b07-bc7b-44cbb1264688	8c287134-9b10-4b98-8682-c52c32782190	748ead96-07d8-4cac-8940-8cfad8ffd8dd	PRINCIPAL	t
c73bc996-e285-4dd4-814d-0af6f6aa1e4c	5b97b52f-b223-4a6f-ab5a-1ab126b78aa0	f65ba413-ee61-4f43-a51c-822ae344a8eb	PRINCIPAL	t
1afbcd14-87b7-4b70-9e51-dd0bcdf80ac3	6ab45019-f98e-437b-aff3-9c0de5892492	59d25cc8-403e-4409-9b5c-bb6564772f4b	PRINCIPAL	t
4864e279-62eb-45bf-9a90-4568c0620c5a	add7bc3b-570f-46ec-a83c-d793993a75a7	59d25cc8-403e-4409-9b5c-bb6564772f4b	PRINCIPAL	t
0486af83-0a6c-4b38-810e-bad93b41bbbb	565da438-fc8e-4444-abd3-147ce31d0562	59d25cc8-403e-4409-9b5c-bb6564772f4b	PRINCIPAL	t
4b8b3b08-7673-4c59-bf58-4d113e9111ea	76f495bc-fe8d-47ba-827d-45ac0da70256	7da9b5fa-dd75-49b8-82b2-f16fc7b6ba02	PRINCIPAL	t
7f19613e-70de-4ba0-9243-5b6fb9c6f24c	e5b49754-47ff-4434-8e02-c446a8692ff5	87c4cd3c-0d8a-4ca4-8376-0bfc4b1c8a43	PRINCIPAL	t
890e5138-5ced-4312-8260-e0b8338bdb4a	a6e2cc78-2d37-4870-abf7-d45f27fe65ae	10fce44b-0302-45be-bd51-dede19bf90f5	PRINCIPAL	t
bbbae862-e86c-4e19-8f2b-96d9d2d0c0f3	e5cc78bb-b799-4f3d-83d0-b1f8b4d35d06	bf43a85b-0ac9-4f00-a7e8-cd5fea6c4cbd	PRINCIPAL	t
b5b5b095-7bd3-434b-b040-f2b4bbc89619	031a464e-77ba-449b-9a82-35b62be21387	fd7bdec3-345f-4231-94c3-5d7d1412c0b3	PRINCIPAL	t
bf19fa61-b490-4b3f-a05e-efdff60632ae	acc5cd5a-accd-43da-99ba-8470db67e503	9233b7e4-ec02-4683-8caa-58a631897a9b	PRINCIPAL	t
f254008f-6034-44ad-b87d-e638dcda8894	6e31fbf3-6567-4fbc-bb7a-f64f4d75acf7	0b7989c3-4c19-4b2f-a868-ea0507dd6558	PRINCIPAL	t
09417982-5736-46eb-8ccc-0dc682ebe068	7f1df0c4-4af0-4a9a-bafa-edf515a41d60	0b7989c3-4c19-4b2f-a868-ea0507dd6558	PRINCIPAL	t
e76a6e44-4088-4c5a-aab0-c3d2786dea03	21ec813d-4b6f-4acf-983e-44490a3b3073	0b7989c3-4c19-4b2f-a868-ea0507dd6558	PRINCIPAL	t
1a93b016-bf09-4ad5-86b7-1e335ed1a91e	39628959-2c59-4a16-900a-76250f52675a	0b7989c3-4c19-4b2f-a868-ea0507dd6558	PRINCIPAL	t
1d87f2c6-4daf-4e17-96d3-92552ad24b36	b7f12ae3-d55f-4402-8388-c670eca3a473	7456cd76-9949-4c82-ac10-6d0a29009d71	PRINCIPAL	t
d25830f5-90ba-4ce9-af05-8478500bda45	4e3f168a-96f0-4d5e-afab-f466b907d968	50801ce5-defb-41aa-b43d-851ee3e0613f	PRINCIPAL	t
a341e08f-a4b1-4370-aed4-83d60cc094d9	0c742927-8e2f-4bbe-a6b0-39a874007816	3aa4fd7e-82d6-4986-9a8e-6dbcb26fe28c	PRINCIPAL	t
407f7ad2-162a-4b96-8c45-16d8a3576c9e	b28a51df-989a-463f-b6cd-6a29a6e4ac59	713e508e-be28-4e12-a256-2f209dfd6e0c	PRINCIPAL	t
b61727be-7b10-403c-9bd8-ef42cf13cef3	ac4d1f49-6760-4cc5-8f62-e96e08a3de97	748ead96-07d8-4cac-8940-8cfad8ffd8dd	PRINCIPAL	t
6b457326-966d-4b62-94ea-236eba8cbc9c	30bc8ca6-b4fd-4c5a-bbc3-26437a569649	65d614cd-8022-40bb-8765-3faa591c9cda	PRINCIPAL	t
a95c8d07-65f9-40db-a145-a354fd660e07	c28cc417-4da3-4abc-9d71-5ff0edbc2401	a64fd42f-7261-48b0-ae7c-af1352d8bde1	PRINCIPAL	t
ca21f2bb-284b-4b40-be45-d6821568d128	87821259-c70c-4bf9-8437-eeae76758dd9	50801ce5-defb-41aa-b43d-851ee3e0613f	PRINCIPAL	t
5455f7e3-e04d-432d-af1f-96655566a774	8f4ca4c3-163a-4f9e-9542-6851242a8e48	50801ce5-defb-41aa-b43d-851ee3e0613f	PRINCIPAL	t
36d74ade-e89c-46d8-86cd-0cf676c06413	e3c979e9-b373-4d20-8387-a9aaee43b92c	fe7f31a1-80d9-45ed-9632-feaddc01f0ed	PRINCIPAL	t
7db93fef-b602-4edb-b319-6724e39a20b6	8ba962bc-5e70-4a7b-a9f6-fe41baeb02b5	31c01d59-fa0f-43c6-8ca9-54703e3556dc	PRINCIPAL	t
ee3cf388-a109-4a5e-9892-7073c66c28be	9c82df6b-2c46-4b65-9dec-5e572d4e5795	3fe97e20-e070-44ad-afbd-da565632e68e	PRINCIPAL	t
1e40f761-9d74-4442-b3eb-5efcbbc71424	d244934b-2772-45f7-b221-b71b4199a4c3	80325084-a25e-41e9-a01b-f3b2d70a3fc3	PRINCIPAL	t
da1973c4-b09d-485b-a005-9e1f469f945c	14968346-1104-4b72-a20a-7adf8e0fa9a8	f6ff71dc-2f5d-4fa5-9639-766717c3965f	PRINCIPAL	t
909cb419-99b7-4802-bb03-7f95aadf3153	2d9d1e23-8fef-476a-86a4-ab6afd7deae7	acc9f6d8-4a13-4f5a-82e1-31f7ad362951	PRINCIPAL	t
51f7316f-232b-4893-ae60-9aa74b053d17	57cbc87b-e205-46fd-a523-3dd8f49371aa	458e13a5-ad84-4a37-9baa-028fc5e9d7bd	PRINCIPAL	t
4c99c8bf-4f46-47d3-ae83-e7b694758241	7bac72f2-83c9-4261-ac17-6fcbecc9a911	b4aa76be-d343-454b-bb9c-c78f4150f181	PRINCIPAL	t
e045de4a-9b8c-40c5-9d59-6e0fc2e5fec1	804b63d9-892a-4a0c-a7dd-991b6e60d369	9d5b6f89-49d0-4c40-849a-a9114a8881dd	PRINCIPAL	t
a44d0b05-97c0-4dc5-9ea5-6638ab484b0b	2351560e-cb18-42a1-bd39-adc0c2d5bb19	f65ba413-ee61-4f43-a51c-822ae344a8eb	PRINCIPAL	t
f56fa83d-5066-4147-bd65-a54c23a77645	8e5c6c80-9637-415a-9dc0-05a22a3d904d	10fce44b-0302-45be-bd51-dede19bf90f5	PRINCIPAL	t
c47ac07a-3a10-4ddc-ba8a-5617731d03e7	c0dcbaeb-af5b-47f4-811f-c1e0ea3495b8	bf43a85b-0ac9-4f00-a7e8-cd5fea6c4cbd	PRINCIPAL	t
9b3f4e84-a8ad-48fb-9eba-ff3c76987b56	874478c3-e924-417a-aa5a-2b08ab78c648	5794bb9d-2616-421d-a32e-299814440e16	PRINCIPAL	t
03aa982d-dc5e-4f82-9f8c-31685722d589	f384ed3b-fa14-4cf2-8be8-62e3c8208d29	7da9b5fa-dd75-49b8-82b2-f16fc7b6ba02	PRINCIPAL	t
c9a5b1ef-59e8-463d-ab9d-cd39435823bb	94e41b86-9990-45a6-9a65-83982d7a9df2	2319d7d2-75f2-400f-998b-13b32a0b564c	PRINCIPAL	t
71ad676d-6611-4488-9873-787216aa2fdb	414223a4-d896-47d3-bff2-d610afae5e29	7456cd76-9949-4c82-ac10-6d0a29009d71	PRINCIPAL	t
c64737db-894c-4604-b33f-d8c9614232bc	47d78fbd-753b-478b-a3f0-cdde3e349366	4f89bb65-2a31-4993-9084-8c25fad01ac7	PRINCIPAL	t
54ad6f2a-0c3c-470b-bc85-000ef0349534	fe5e5e26-63b6-473e-b39d-2dbc07c990a3	19c411b7-0221-4533-90dd-ec1fd54e684d	PRINCIPAL	t
7cc3caff-1e48-4cd2-bf52-eb44b659b177	4d2776cc-7c0f-4da4-aa0c-6c0883ae6e46	19c411b7-0221-4533-90dd-ec1fd54e684d	PRINCIPAL	t
473e3b7b-806d-48b4-ae6f-894b31ec63e2	5a651a69-a18b-48e9-88bb-099e7cb26de7	7e2a574f-655f-49c6-b7cb-5db09e53df1e	PRINCIPAL	t
506d19c7-e66a-4f20-b255-707ab68189bc	e1c93573-1cf7-48c1-a66a-f6f6a1bdc115	7e2a574f-655f-49c6-b7cb-5db09e53df1e	PRINCIPAL	t
5a1acd5a-0a7b-437a-99ff-907dc0cff0f5	95a13216-9d9b-43e1-8d99-815fe43f5d53	11b3358c-7d76-47dd-bb76-bc68090950f9	PRINCIPAL	t
b453dd5e-b5eb-49d7-b874-c0ba2d7e991f	bfc40ff8-0983-47af-9704-c518e2c83152	11b3358c-7d76-47dd-bb76-bc68090950f9	PRINCIPAL	t
815ff9e9-9410-4991-bbc5-e2f103f7b812	a61357fe-4647-4bd3-a75b-7875f4727478	f65ba413-ee61-4f43-a51c-822ae344a8eb	PRINCIPAL	t
79e3d219-670b-413e-97f5-d55103f34017	07db8815-112d-43f4-9e5d-a1bf3e51156e	f65ba413-ee61-4f43-a51c-822ae344a8eb	PRINCIPAL	t
58d82329-763b-427b-a0ab-2fcd5803a012	53c558bd-018d-42e8-8ce9-4ac206d3917f	fd7bdec3-345f-4231-94c3-5d7d1412c0b3	PRINCIPAL	t
afbb7406-590d-43a7-a494-41b280360053	a864560f-1a53-44d8-9730-76b135c2ff7f	fd7bdec3-345f-4231-94c3-5d7d1412c0b3	PRINCIPAL	t
16b0e9dd-64b3-4445-8073-79fcdbb5a9ae	2d9567c4-7206-4cc6-b8d6-9e4ce052301c	196bbbc0-3afa-425a-bb90-a085cd9b4385	PRINCIPAL	t
e49a520d-8fcc-4f09-b82b-d12f2b1bfa84	56803a64-9817-4631-8123-5cc6918c3c32	fc5d8f25-2db5-4689-8b58-dbffaa6b26ed	PRINCIPAL	t
1edfb77b-ef38-4993-8b72-4513beac1ec6	ab6b2659-ecca-4309-ad7a-af40e66f64b7	8c0214ed-61c1-43aa-a479-baad51350fae	PRINCIPAL	t
bb328516-acb6-4d77-ad86-e2c6915d2b24	2372f408-40a3-4760-aa42-e35732ae7a84	31c01d59-fa0f-43c6-8ca9-54703e3556dc	PRINCIPAL	t
f38fefc2-d024-45b8-98e6-514ebda35e75	0080978e-0063-457f-bcfc-f780beeb2976	87c4cd3c-0d8a-4ca4-8376-0bfc4b1c8a43	PRINCIPAL	t
c5cc6127-1f27-4bec-88a5-6a2a0702ea41	1a2e9f51-be29-4cbc-a270-7c94f3c93124	cabd4895-4f89-41e4-a6e5-367731c55e0a	PRINCIPAL	t
c16fd5a2-1b04-4af0-9506-33dbb0775e55	a0176753-9611-4077-9d39-cd6164d6e869	713e508e-be28-4e12-a256-2f209dfd6e0c	PRINCIPAL	t
50fd2d6d-46bd-4c5c-88b6-4c55d646ea5b	56d98806-c2c8-47bc-a7be-aaf838ea7483	2319d7d2-75f2-400f-998b-13b32a0b564c	PRINCIPAL	t
48767f6d-1663-4ffc-bcf5-1c8377352262	04853bc7-399d-4a3a-a132-b9f5bfe67a3c	fe7f31a1-80d9-45ed-9632-feaddc01f0ed	PRINCIPAL	t
0a6b8b2b-dbe2-4337-aae1-5e7e0041a624	34583dc0-35ba-449b-94b7-530e51eecd5d	04f48fc6-b8c1-475b-9120-ab09092881c9	PRINCIPAL	t
fbe49b6e-7080-4078-aa2c-bd862dbf20c7	6631c6c1-4d2f-4779-8e34-811432f78d7d	fd7bdec3-345f-4231-94c3-5d7d1412c0b3	PRINCIPAL	t
dfb0b251-a448-4b4d-a91c-7594d6106eba	5b9efd61-0688-4093-b700-aa1574e9ca13	4f89bb65-2a31-4993-9084-8c25fad01ac7	PRINCIPAL	t
bda13505-ae62-4816-8a45-8a24353292b2	39676b2b-b566-46bf-ab76-395f42e5edc9	3aa4fd7e-82d6-4986-9a8e-6dbcb26fe28c	PRINCIPAL	t
2a7fd46a-63f3-4f57-985c-65358d94c813	e86cb73a-f53c-47dd-9823-602cb1539d32	cd62e541-8699-4e78-a979-37ab0a48feb5	PRINCIPAL	t
fd5f1421-5f1a-478a-a56a-6c03a0820362	1812319c-8198-4cdc-9761-4ce489da7e22	7e2a574f-655f-49c6-b7cb-5db09e53df1e	PRINCIPAL	t
3cd04117-7b39-4ece-919f-6dac1219ba7a	b60233ab-359b-4f40-8b1d-b312f70162c4	f65ba413-ee61-4f43-a51c-822ae344a8eb	PRINCIPAL	t
13b4ded1-f339-4bfd-acc0-4c6491311dba	6c8af3dd-2f5d-4e6d-a2b0-8e98fdffdfe6	19c411b7-0221-4533-90dd-ec1fd54e684d	PRINCIPAL	t
8dfae426-2ecb-4848-84e0-24def1a94ac7	1a32f8eb-454d-4202-a98d-e0d5c4e01e7e	19c411b7-0221-4533-90dd-ec1fd54e684d	PRINCIPAL	t
5b7b0bda-e2e6-4869-9fe3-dbd4f9e41cba	5bc9fd04-251f-4cd4-adfb-fca3c9cc88eb	19c411b7-0221-4533-90dd-ec1fd54e684d	PRINCIPAL	t
8e38c583-7946-490e-9469-4fd761f1080e	c91a58f8-4d15-48f5-a3a3-98e98494c581	0b7989c3-4c19-4b2f-a868-ea0507dd6558	PRINCIPAL	t
b76f7edb-f3c2-42df-8a87-0de82eae28ad	86873f5b-cdfa-4da4-854b-09a7213fed97	acc9f6d8-4a13-4f5a-82e1-31f7ad362951	PRINCIPAL	t
3a9b2905-b552-45ce-8da4-e85e58d13299	75e47008-8032-49fb-a015-05294da53a25	acc9f6d8-4a13-4f5a-82e1-31f7ad362951	PRINCIPAL	t
471b806e-66d9-4ec2-946d-82c5a934552c	aa54549a-e1c4-4420-a112-0b6d4de03196	acc9f6d8-4a13-4f5a-82e1-31f7ad362951	PRINCIPAL	t
7ed8ee95-46e5-4d8b-8359-4cb44d82ca02	f282b1bc-f010-4e27-afdc-aeadf318e97b	11b3358c-7d76-47dd-bb76-bc68090950f9	PRINCIPAL	t
8064793e-7ad5-42a9-9e96-c523d38eade6	0e07774b-9ffc-4445-9cfd-4f0eb738e364	11b3358c-7d76-47dd-bb76-bc68090950f9	PRINCIPAL	t
74643373-ccc5-455d-a93b-f1d765494561	f869757e-22f9-46d4-b140-930d54695c04	f6ff71dc-2f5d-4fa5-9639-766717c3965f	PRINCIPAL	t
c7c253a9-a8cc-4e15-b736-e80d0674c3ce	c687a8e4-ce98-4997-b348-ef65e6cddddb	59d25cc8-403e-4409-9b5c-bb6564772f4b	PRINCIPAL	t
fe36e2dc-c219-416c-9f0e-d581bf357812	e5706f4e-46b3-4310-b0b3-8923253ae043	59d25cc8-403e-4409-9b5c-bb6564772f4b	PRINCIPAL	t
51c412eb-c648-43af-b0cb-151937d76926	9cb9439d-d449-4dab-be99-adad92a4241d	59d25cc8-403e-4409-9b5c-bb6564772f4b	PRINCIPAL	t
0db919fc-9131-482f-a861-d5d1d4a66dd4	a3e2d370-7705-4757-97b8-ad170e600a59	31c01d59-fa0f-43c6-8ca9-54703e3556dc	PRINCIPAL	t
e4bbd9c2-ce37-4f95-bead-40c7a39d39d2	643cb759-8140-46e3-9415-74c831fb227d	8fbdb915-807d-4450-a514-daf051d5710a	PRINCIPAL	t
ad56bd56-e26e-48bd-9d28-13c347895a47	bebd69bc-1a5b-4693-9fb8-6862bbd8e8ee	8fbdb915-807d-4450-a514-daf051d5710a	PRINCIPAL	t
e97ac114-f009-49f0-b6d6-29cddd3725a5	d38acd1d-27e7-4806-9d47-4bab1f73e1a5	0bdfe245-991d-4455-89cc-a3f12d61a20e	PRINCIPAL	t
1eb94ca3-6520-490d-932e-ce35885ead70	fe528940-cb88-483f-87b5-a393c10f70ff	6ecf47d3-28a5-44b7-a008-9273d0cbe48e	PRINCIPAL	t
d20f5bf6-99cd-4f1a-b017-5077a6d118df	dada2d32-11e8-45bd-a37e-6ef9bea1f0bb	748ead96-07d8-4cac-8940-8cfad8ffd8dd	PRINCIPAL	t
4a6be812-4d39-4e25-ac2d-f97781967e22	b9f31e44-69ab-4b9e-922d-1ed96a765eb6	748ead96-07d8-4cac-8940-8cfad8ffd8dd	PRINCIPAL	t
758c2016-29c4-4fc3-91d1-b911b5061eb9	c237254b-2c3c-41af-84b8-0d89b9fbf2b4	748ead96-07d8-4cac-8940-8cfad8ffd8dd	PRINCIPAL	t
026bb798-8ec3-423a-821b-11a78b566797	41258667-63af-4b27-95f3-c014125d1fee	8c0214ed-61c1-43aa-a479-baad51350fae	PRINCIPAL	t
9211d65d-33ca-440f-806c-40bcbabb8ffb	1f2000c3-25b4-4d54-9bf6-ad1e2b0a238a	50801ce5-defb-41aa-b43d-851ee3e0613f	PRINCIPAL	t
b1dc3fed-1cb5-4e37-9100-bdb8a77f8fab	28458003-2af8-4e84-a317-830f6016ecba	bf43a85b-0ac9-4f00-a7e8-cd5fea6c4cbd	PRINCIPAL	t
1fa03cc7-b59e-4f13-aade-6cc7c0d1dcc2	8cc96a92-610a-4a7c-ab42-9cad2ae55b1d	196bbbc0-3afa-425a-bb90-a085cd9b4385	PRINCIPAL	t
f569677c-453e-4834-a533-54cd3d01a93c	34c6b6be-58a9-4dda-ab5f-34a048dd4ba2	a9a94140-276f-41c7-9486-f9c6621ad843	PRINCIPAL	t
3aadd38a-67f1-4570-9860-9d9c2b1c9695	a2038e53-1508-460c-82b3-07322169a534	dbadc20e-43a9-49e4-bebc-5ab9ab812a17	PRINCIPAL	t
fd0612f9-aff6-4f27-89e1-8c544ba5260b	4746019f-919d-46d8-a20a-a22e19fb2920	9d5b6f89-49d0-4c40-849a-a9114a8881dd	PRINCIPAL	t
00464031-d746-45fe-8a04-cb8a00e84856	c548929a-ac47-4814-9daf-fd5e56222d18	fc5d8f25-2db5-4689-8b58-dbffaa6b26ed	PRINCIPAL	t
4d6d5502-681d-4bc7-a723-6b5c2b4b9707	43992822-4437-47aa-8873-5b5f33fcaf99	7456cd76-9949-4c82-ac10-6d0a29009d71	PRINCIPAL	t
e566c8f3-5de6-45ee-8432-bbc3bcb63fc4	f44f5a6c-25be-46ae-bb9e-e774af3e5968	edfdb433-94bd-4b10-b860-5b833eee185e	PRINCIPAL	t
4239ca8a-3e2f-46dc-ab0e-75e5faf57a6d	e07589e7-be9f-41a5-88f4-1708e5802487	9233b7e4-ec02-4683-8caa-58a631897a9b	PRINCIPAL	t
44add9a9-9250-4d6a-b451-867938dc3821	fe69b7cf-6890-445a-aae9-303a3952b23c	5794bb9d-2616-421d-a32e-299814440e16	PRINCIPAL	t
223e9ab0-432b-4ed7-a964-8e1c47f7ddfd	1e739fad-b95e-48b2-b690-01e47ecdf21e	fe7f31a1-80d9-45ed-9632-feaddc01f0ed	PRINCIPAL	t
955e1195-1c11-423e-9688-ce0b27c1aa24	2f5e4fc2-ec65-48c7-8084-58dd5718e809	7da9b5fa-dd75-49b8-82b2-f16fc7b6ba02	PRINCIPAL	t
9751808d-fb64-4ebc-9ce1-0f1fb7b0de5f	642e3d13-6b5d-46f6-9ae2-f5e033195641	87c4cd3c-0d8a-4ca4-8376-0bfc4b1c8a43	PRINCIPAL	t
4908caa8-500c-4175-85c0-770fb32ff850	3e0ce636-fe12-42df-8411-40f1a04c9bb9	19c411b7-0221-4533-90dd-ec1fd54e684d	PRINCIPAL	t
c3ebc16b-0f2a-461b-af00-7d517888172c	cafc7681-9908-4a18-81b9-bb50430f487c	19c411b7-0221-4533-90dd-ec1fd54e684d	PRINCIPAL	t
94c44441-f440-463e-831a-71f4cc83fdba	2d5c619e-029b-4b6b-9780-6ca10364dead	713e508e-be28-4e12-a256-2f209dfd6e0c	PRINCIPAL	t
f6350019-14ed-4e6a-9149-7b8d8f13513a	d65c36d2-7769-4381-b790-67327d237edc	748ead96-07d8-4cac-8940-8cfad8ffd8dd	PRINCIPAL	t
7d4b2bc5-8ea7-4c31-b715-0890e30e9b42	c9cde33e-05fe-404e-95f4-e9739d609da1	748ead96-07d8-4cac-8940-8cfad8ffd8dd	PRINCIPAL	t
aff776f8-04e7-422e-8c1a-2b5572f04985	7f4feac7-57c2-4d32-9e34-b02f90eae590	748ead96-07d8-4cac-8940-8cfad8ffd8dd	PRINCIPAL	t
d5b1edda-aca9-48b9-94c1-256117d5f938	98f9c81a-9390-47a8-b49d-b64a917b3bc8	748ead96-07d8-4cac-8940-8cfad8ffd8dd	PRINCIPAL	t
b21812c0-6884-46c9-a3e2-817c89d43cc2	6fc964a5-d600-47b8-abaa-86c42d00de06	11b3358c-7d76-47dd-bb76-bc68090950f9	PRINCIPAL	t
7b2f0e7a-5f93-49af-9fea-f3e9f719081e	d738b067-4c6c-40b8-965c-ebd1be64e842	0b7989c3-4c19-4b2f-a868-ea0507dd6558	PRINCIPAL	t
516d9dda-4a10-451c-895a-a1c91ae6e732	76dbe0f5-e6b3-4994-8f71-2596863e40be	31c01d59-fa0f-43c6-8ca9-54703e3556dc	PRINCIPAL	t
021fa91b-18e6-4739-b793-938803ffeaa7	506fa917-57c6-49e8-a4f6-7da87b7ce30e	458e13a5-ad84-4a37-9baa-028fc5e9d7bd	PRINCIPAL	t
4ef92633-244c-40f5-9712-0aa5fe9f7430	ec8ad24c-e829-4671-9611-5d8524960d24	458e13a5-ad84-4a37-9baa-028fc5e9d7bd	PRINCIPAL	t
e7a428ad-7c21-4957-b630-1ea5f378af3a	60fa0458-a77e-4774-a2ee-90a5c4d56c96	458e13a5-ad84-4a37-9baa-028fc5e9d7bd	PRINCIPAL	t
6f750d7e-0bda-4f3a-aefa-e1569eb67b23	1d424bb6-e1fd-4dfa-b065-6f911dd85e5a	458e13a5-ad84-4a37-9baa-028fc5e9d7bd	PRINCIPAL	t
57c3eeaa-938c-484a-bf34-cc7f69250bee	d46cd810-eb89-4e43-9769-f1d8d6c85336	458e13a5-ad84-4a37-9baa-028fc5e9d7bd	PRINCIPAL	t
57aa40ed-367f-4eb3-9406-2cc4e6a7c37a	4cec80f6-2b05-4a44-9710-6d234206394d	99b520f1-a0b2-4151-bbc3-b91ff15104fd	PRINCIPAL	t
5022b8d6-82c2-4190-b4ea-74d9d9de7dde	e9a8d27a-fe64-47c6-9dbe-ca28448fff4f	99b520f1-a0b2-4151-bbc3-b91ff15104fd	PRINCIPAL	t
b63da096-fcb7-409d-af86-29917ceda982	e489234b-a4e0-44e8-ba55-94ac2f1ab1a9	cd62e541-8699-4e78-a979-37ab0a48feb5	PRINCIPAL	t
1444d12f-66ef-4fd7-9b9d-6c34f3495db7	083fe5b1-49a4-4385-8a39-ca37916d8f05	acc9f6d8-4a13-4f5a-82e1-31f7ad362951	PRINCIPAL	t
feb5688f-edc8-441b-bc0e-7b1cb6fb9083	cd6fc2ec-24c7-43d1-8dcc-a16e119dd888	9d5b6f89-49d0-4c40-849a-a9114a8881dd	PRINCIPAL	t
ea2f8cc2-04d1-4021-9fc1-d176586b5ef2	3ea24f5e-dcd6-400b-8cfc-2f94137435fb	19c411b7-0221-4533-90dd-ec1fd54e684d	PRINCIPAL	t
14d92272-92ee-4d8d-904f-39e61268e913	e2e532b6-e54d-406c-b6cf-3d2dc7ad6d21	f65ba413-ee61-4f43-a51c-822ae344a8eb	PRINCIPAL	t
d4dffd38-3566-4905-a2ff-efa942d2990e	eb37e6e0-f59e-4b53-8c90-f47d445399ac	f65ba413-ee61-4f43-a51c-822ae344a8eb	PRINCIPAL	t
3b9e15e3-f82c-4575-ac76-308561265e4c	87a311b0-67c1-41ab-9cad-f6c165cf1bb2	fc5d8f25-2db5-4689-8b58-dbffaa6b26ed	PRINCIPAL	t
f3ed13a1-4221-4571-956a-21071332a37b	dad7211a-d23c-4454-be2c-1917d45fb20d	fc5d8f25-2db5-4689-8b58-dbffaa6b26ed	PRINCIPAL	t
4029da27-7549-462c-9322-b0a11f918d2b	7eaa2650-86e1-4918-b744-876e529cf7cc	fc5d8f25-2db5-4689-8b58-dbffaa6b26ed	PRINCIPAL	t
6eab2cc4-6803-4c0b-ac17-fffb5663a2f4	a389001c-bcd2-49f9-8b26-679becf7eb7d	fc5d8f25-2db5-4689-8b58-dbffaa6b26ed	PRINCIPAL	t
2f86b702-501d-4f4a-a745-11e11f32ba7d	39e4c9e9-84ff-4f0f-a930-75a5ae67468e	9d5b6f89-49d0-4c40-849a-a9114a8881dd	PRINCIPAL	t
689c5305-8382-41ce-ac15-309f37173953	38725e7a-3fc2-46e4-9a3b-a6604e2b3b01	acc9f6d8-4a13-4f5a-82e1-31f7ad362951	PRINCIPAL	t
da6cd539-c8aa-49da-8b5b-4b462c3ab559	7a8b26bf-c930-4bd8-97e3-6a13bf079d0a	acc9f6d8-4a13-4f5a-82e1-31f7ad362951	PRINCIPAL	t
7e99d2f2-dea5-4e0b-a683-115d09a62dd5	6bf6895d-1f67-499b-962b-3f2114f04028	fd7bdec3-345f-4231-94c3-5d7d1412c0b3	PRINCIPAL	t
e263a4fc-41ef-424a-babf-6578c7461dde	fb08d7c8-0917-464c-8693-2b8ad6dc88d2	0bdfe245-991d-4455-89cc-a3f12d61a20e	PRINCIPAL	t
cda5e18c-343a-43e7-85b6-6431fdb903af	4a7e3893-6281-4a49-99f8-3c07e2013afe	0bdfe245-991d-4455-89cc-a3f12d61a20e	PRINCIPAL	t
4de5dedb-b9f0-41d0-9042-3bf8d139882d	91493ab0-766f-4214-9be4-41fd169a5ce7	0bdfe245-991d-4455-89cc-a3f12d61a20e	PRINCIPAL	t
4c2aa81f-3498-4d5b-8f0f-50951b0a4340	f64f8c1b-934e-4cd6-858f-b4ff67cced79	10fce44b-0302-45be-bd51-dede19bf90f5	PRINCIPAL	t
ab6b7f4e-36f1-4c42-b1a9-b09ef0fb3fd7	869d9435-49fd-47fb-b58f-fbc502bf142e	fe7f31a1-80d9-45ed-9632-feaddc01f0ed	PRINCIPAL	t
bc54cb26-fe37-4db5-ac86-5ee2c409b2ba	c1954a4f-1469-4bb2-b3f3-8c62cfc66fb8	cd62e541-8699-4e78-a979-37ab0a48feb5	PRINCIPAL	t
9f9fd7b4-138c-4a35-90ed-a7c2b866813b	dd76aa4b-eb55-4041-a000-bc2af4d24b33	88e889d4-c502-4686-9ea2-d14b9de39b15	PRINCIPAL	t
0b144717-9852-4432-94ea-6caa48f7f248	fca6d43f-56fc-4cd9-9412-8eab0117f7ee	50801ce5-defb-41aa-b43d-851ee3e0613f	PRINCIPAL	t
f2bdadfb-7b1e-4972-899f-ddbb101cf04e	18e31c93-1fec-41ab-a182-29f51f560fcf	7e2a574f-655f-49c6-b7cb-5db09e53df1e	PRINCIPAL	t
74a556ac-69b4-4e46-bb7f-81787a3e7087	c138571e-e535-4b0c-b353-cd725a557a8f	7e2a574f-655f-49c6-b7cb-5db09e53df1e	PRINCIPAL	t
4488ed39-b95f-4865-a799-5a4b0a6d4497	19a10342-221b-471f-a97f-484c41948377	7e2a574f-655f-49c6-b7cb-5db09e53df1e	PRINCIPAL	t
a0a4b61c-ed5e-4fb6-86a3-928f80c6e353	9f92356c-ba65-4941-8fc5-3b636af92e57	7e2a574f-655f-49c6-b7cb-5db09e53df1e	PRINCIPAL	t
20bd65d3-cfb6-4578-aff2-3844bcf401a5	a69a9745-e3aa-46e0-a2e7-24b51c2c535b	7da9b5fa-dd75-49b8-82b2-f16fc7b6ba02	PRINCIPAL	t
54d622de-2ab2-4e0a-90b7-aa52a0e2bb23	22c44535-9849-4b40-be6d-14c53542526e	11b3358c-7d76-47dd-bb76-bc68090950f9	PRINCIPAL	t
16e97f20-e84c-4027-b10c-77b40e745ce2	9004cf15-9e60-464e-9a6d-d81dfd54b7c0	8c0214ed-61c1-43aa-a479-baad51350fae	PRINCIPAL	t
a1110c87-76e5-4a33-8664-7aa666445089	c3d2f153-0b6f-4134-b3aa-9ca65428bf18	fd7bdec3-345f-4231-94c3-5d7d1412c0b3	PRINCIPAL	t
e7dbf553-1434-4d57-b92e-10469577eb0a	5b59ba6d-d65c-4210-961a-f4539fb5f2d4	6ecf47d3-28a5-44b7-a008-9273d0cbe48e	PRINCIPAL	t
f4a90a53-c92a-4a53-a4dd-05acdc86c26b	0fa3321a-b873-4299-9b97-900a2c262cfd	0b7989c3-4c19-4b2f-a868-ea0507dd6558	PRINCIPAL	t
d2c92301-0e3f-457b-93d1-3784efb8d4ce	6fb6bd5d-0207-4bdf-83ff-4563762aec16	f6ff71dc-2f5d-4fa5-9639-766717c3965f	PRINCIPAL	t
b31686b7-5a62-4381-bf0d-ea90bffd48a3	dd9fc673-7944-4c06-90e4-c13b2bfed120	4f89bb65-2a31-4993-9084-8c25fad01ac7	PRINCIPAL	t
bcaec6c8-b0e1-475a-8f46-bd4d72ac5f1a	6b333c97-9f2b-4259-a80d-c49b748a4a17	4f89bb65-2a31-4993-9084-8c25fad01ac7	PRINCIPAL	t
94b7f3c3-e150-4099-8902-64fbc7556827	84bd717f-e229-4eae-abb1-f23fcc49f514	4f89bb65-2a31-4993-9084-8c25fad01ac7	PRINCIPAL	t
1cc73479-b47c-4b9d-b30f-66e72c0f3c7f	1677e8d8-533d-4853-9318-52c2d3899ad0	2319d7d2-75f2-400f-998b-13b32a0b564c	PRINCIPAL	t
65900cec-50f2-4179-bf82-c77c4c0ed97e	21a814d1-e3cf-4939-8b49-6661c1cb67fe	f65ba413-ee61-4f43-a51c-822ae344a8eb	PRINCIPAL	t
52a28179-ccfc-4e3a-8155-72334e535117	7775703a-c911-4833-8848-13bdf10d9941	31c01d59-fa0f-43c6-8ca9-54703e3556dc	PRINCIPAL	t
528902c1-9242-4aab-875b-b1b26c835984	ec944c04-e366-45ce-8c8b-91d88d3c0ee5	31c01d59-fa0f-43c6-8ca9-54703e3556dc	PRINCIPAL	t
02f8b1a1-769c-4d67-a8d3-455ab508add9	db34f9bc-eb50-4f17-a2d1-27d370325228	458e13a5-ad84-4a37-9baa-028fc5e9d7bd	PRINCIPAL	t
516cb90f-fbbb-4d55-9e32-16ebc3a45ee0	57b0e819-ac24-40ff-8eac-878dafa05164	9d5b6f89-49d0-4c40-849a-a9114a8881dd	PRINCIPAL	t
b4fc96d1-85dc-45db-867e-30f7154b0183	a8919441-c03b-4b94-aa80-6671acb2c9e7	19c411b7-0221-4533-90dd-ec1fd54e684d	PRINCIPAL	t
bddc1411-b8c5-4871-a07a-e633006bd66f	914b1a9b-07db-490e-b74e-eb71dc129e54	b4aa76be-d343-454b-bb9c-c78f4150f181	PRINCIPAL	t
d164b0c5-3bfd-4040-9569-8a3fc991d716	405c7db6-0461-4f37-8d5c-4f4b3acea32a	b4aa76be-d343-454b-bb9c-c78f4150f181	PRINCIPAL	t
052bdfc2-b830-4e92-9b74-1de2dea52ddb	7e81291d-69d0-45b5-9b5f-8f062d9c0e81	b4aa76be-d343-454b-bb9c-c78f4150f181	PRINCIPAL	t
d8780c6c-deea-4b32-8599-a788222a2141	ad17eebd-82e3-4532-84ff-db86b6dd75dd	b4aa76be-d343-454b-bb9c-c78f4150f181	PRINCIPAL	t
d70fa967-6877-4177-95b4-32769c30bc3c	adad67c5-54f1-4ffa-ad0a-64da5fd85f5d	f65ba413-ee61-4f43-a51c-822ae344a8eb	PRINCIPAL	t
d9707a69-4cc0-4a66-8bae-2256c8d55970	b7b07b11-c946-490d-a14d-57ca30bcb30b	04f48fc6-b8c1-475b-9120-ab09092881c9	PRINCIPAL	t
f4d20d51-d23d-422a-8435-ab5561251099	c719e4ef-9c39-48bf-8650-f9eabda9fc7a	a9a94140-276f-41c7-9486-f9c6621ad843	PRINCIPAL	t
595ff1d7-bf49-4458-a315-6759587fa98b	29291c18-2a22-4ad7-b585-23ab28b1b249	a9a94140-276f-41c7-9486-f9c6621ad843	PRINCIPAL	t
52640ff3-8814-45b2-997d-a0b2c5c8d11a	994dcb71-8a85-4697-a04e-26b483f151eb	a9a94140-276f-41c7-9486-f9c6621ad843	PRINCIPAL	t
29647c30-3ed2-426a-93be-e33d7cd45499	ca8edbc6-2bae-4393-bb77-9216ca39aa87	a9a94140-276f-41c7-9486-f9c6621ad843	PRINCIPAL	t
834f1331-de03-45cc-bcd2-86fe1482634c	364b5cef-d267-4084-8e88-74d87d0f84b4	748ead96-07d8-4cac-8940-8cfad8ffd8dd	PRINCIPAL	t
cd421c95-ea64-4b62-b79a-5fe189ba7160	c930bdda-e8f1-415e-94d4-06930b082c74	748ead96-07d8-4cac-8940-8cfad8ffd8dd	PRINCIPAL	t
4099981d-79af-4b23-8feb-e73c393f8190	8606b35e-eed8-49b7-a9d2-957731ec465d	748ead96-07d8-4cac-8940-8cfad8ffd8dd	PRINCIPAL	t
5fe133d6-54b9-4e34-ba9a-4ed48eb344c6	ecaca1ce-10f8-4814-9c96-89bb691c6495	3aa4fd7e-82d6-4986-9a8e-6dbcb26fe28c	PRINCIPAL	t
f46d37fb-0dd0-45c6-8e38-c5582f1ce8b6	5c4b2173-a38f-4f71-b264-47fb5acfab81	99b520f1-a0b2-4151-bbc3-b91ff15104fd	PRINCIPAL	t
6d936ac5-060d-42b9-95a4-4256ce201992	914593b0-6d43-4514-8aaa-bdcbdea044fe	bf43a85b-0ac9-4f00-a7e8-cd5fea6c4cbd	PRINCIPAL	t
58c2c4ae-b2d5-406d-b763-0d3fb22f0bc1	6dc99f82-923b-4d83-a494-18dc62dc9e76	cd62e541-8699-4e78-a979-37ab0a48feb5	PRINCIPAL	t
4e389513-a953-41ce-b37e-17d117409fbc	fdfab242-9f9f-4a09-ab6e-db7feeafbae2	19c411b7-0221-4533-90dd-ec1fd54e684d	PRINCIPAL	t
2e3fe374-741e-4c3b-96eb-1d9298ccbd16	2a0ba2ba-09d0-4bce-9def-335b36e11418	7456cd76-9949-4c82-ac10-6d0a29009d71	PRINCIPAL	t
eda77dba-ad01-476a-805f-af2a68aebac6	473ec6f3-f199-420c-8055-c9fbdca70c7a	8c0214ed-61c1-43aa-a479-baad51350fae	PRINCIPAL	t
be2c0a35-a991-42c0-9b39-53c607346fc7	0cafd781-797f-47f5-bd1a-e6a1619684df	87c4cd3c-0d8a-4ca4-8376-0bfc4b1c8a43	PRINCIPAL	t
061f2274-7b84-4f13-bf20-6f9e142a8dde	100a5c0a-d0e6-4674-af50-b90082348bf7	c5280d55-a024-4eef-a494-9dc410c48017	PRINCIPAL	t
c30b67ec-de4d-4b8e-93a5-b2e32cd22e86	50b28ea9-6ff8-417b-965b-5e2bc8c171bc	11b3358c-7d76-47dd-bb76-bc68090950f9	PRINCIPAL	t
0bb167d0-f5c4-4cf9-a52c-4579d5c3d7af	efa38b77-71a0-4c37-a60d-917c5e4dd6d7	0bdfe245-991d-4455-89cc-a3f12d61a20e	PRINCIPAL	t
e56db59f-ef9f-4542-bb12-62b24354594e	6d1c43dd-3133-414c-bdc9-023776ffd366	65d614cd-8022-40bb-8765-3faa591c9cda	PRINCIPAL	t
a71dee5f-ba06-4ae2-8616-b7bfce6957a1	82dbccab-649f-4a0d-a305-62f940452ebf	4f89bb65-2a31-4993-9084-8c25fad01ac7	PRINCIPAL	t
b9872dd0-4086-4c44-9a11-d8ba87dd86c2	da95a3d6-e8ea-44d5-82d9-3c7b354ac8d1	fc5d8f25-2db5-4689-8b58-dbffaa6b26ed	PRINCIPAL	t
9d16fa96-4070-48ab-9b2d-6d7abb68ef2b	a1709ea8-a5b3-48f9-bae4-462191d65325	5794bb9d-2616-421d-a32e-299814440e16	PRINCIPAL	t
15234c9f-d5b3-400b-813d-106da4641be6	d72362ed-186d-42b3-90e4-f1db70f68599	7e2a574f-655f-49c6-b7cb-5db09e53df1e	PRINCIPAL	t
6aef9e3a-e9d0-4c39-858d-f2f93f80d65c	cee6d3b7-484b-43d8-9559-76e5514f92b5	bf43a85b-0ac9-4f00-a7e8-cd5fea6c4cbd	PRINCIPAL	t
a124d205-04ac-4a6b-a43b-dd10f0dad717	fe42c5a1-024a-46c3-b79f-992a54aa3dcf	cdec0aa6-a7a4-4626-a6a8-b4a6b5611742	PRINCIPAL	t
3505d2c5-c12f-4e59-81ef-e84a98b0f8f7	c3516ff5-a94a-4dab-976c-62105746bd75	31c01d59-fa0f-43c6-8ca9-54703e3556dc	PRINCIPAL	t
38e7a4b3-4419-4b50-b782-66eb3e4aaf72	b3945772-5840-427f-840a-ffd375cc300c	748ead96-07d8-4cac-8940-8cfad8ffd8dd	PRINCIPAL	t
bfb68aab-ad6b-47de-b93a-6ba366bb339e	a82506b2-5f82-4360-9829-ed977ebdd63c	748ead96-07d8-4cac-8940-8cfad8ffd8dd	PRINCIPAL	t
28faca18-ee3f-4792-bf8a-e55315eb3b9f	200eeadf-acb4-4597-bc35-18d424d7e29b	748ead96-07d8-4cac-8940-8cfad8ffd8dd	PRINCIPAL	t
2f6a5885-371b-48dc-872c-fc65b9a7dac2	498b99ff-3248-4a23-82ba-218dc88227b7	748ead96-07d8-4cac-8940-8cfad8ffd8dd	PRINCIPAL	t
65ae7faf-11ea-47d2-bc9f-1ddc53e7ca58	9405eb73-6baf-46ca-8c8c-8af3fa9c42c9	748ead96-07d8-4cac-8940-8cfad8ffd8dd	PRINCIPAL	t
61f7571a-a95e-4411-aea3-3bae188fcdfa	cf517edb-64eb-42fb-8105-4fab615e65af	748ead96-07d8-4cac-8940-8cfad8ffd8dd	PRINCIPAL	t
e65b2edf-e0af-48c7-81ee-6d3c828e58c1	32e45520-cda3-4581-892c-f79d3b0a7987	f65ba413-ee61-4f43-a51c-822ae344a8eb	PRINCIPAL	t
94681ffc-74fc-44e4-87b6-d7b48e4cd7d1	309c57a7-a55d-413e-aa03-e91df47e9fc7	50801ce5-defb-41aa-b43d-851ee3e0613f	PRINCIPAL	t
e2656120-5e95-4883-8cfc-7c625c794381	8d2ba390-583e-4fa7-83b7-d69cb227b8bd	04f48fc6-b8c1-475b-9120-ab09092881c9	PRINCIPAL	t
9a5667c8-24a5-4ce5-b357-dce939189259	9c8a6372-3464-4075-b187-a3ab21564156	04f48fc6-b8c1-475b-9120-ab09092881c9	PRINCIPAL	t
8b633df9-0e32-4538-9049-c51a0f5e5926	3753ba3d-fada-4c25-b135-d1411c0969e0	04f48fc6-b8c1-475b-9120-ab09092881c9	PRINCIPAL	t
624ef829-466e-4629-9a6e-bffed5d9c79b	b5806207-dfc0-487c-a898-f50ee34388ea	2319d7d2-75f2-400f-998b-13b32a0b564c	PRINCIPAL	t
15c0d4ff-ecc6-482b-878a-dbf613a4b420	5c9bb8c2-172c-4e24-915d-7f9e8e016a2f	c5280d55-a024-4eef-a494-9dc410c48017	PRINCIPAL	t
47dfaddb-fe10-4a9e-b753-e50ceb4e4bd3	277aa484-1c06-4b8f-ba1b-0062f727a3a2	cabd4895-4f89-41e4-a6e5-367731c55e0a	PRINCIPAL	t
bc967dfb-97b0-4c34-956c-154104b5dbf6	1b0b6774-3cf1-4f6e-ba3e-481fcd47ce22	3aa4fd7e-82d6-4986-9a8e-6dbcb26fe28c	PRINCIPAL	t
6148e131-0a2f-4195-895a-c2175aedc0ce	db0b7567-5e6d-4c3c-94e9-d4affb11ac88	59d25cc8-403e-4409-9b5c-bb6564772f4b	PRINCIPAL	t
26db44ec-1469-44fa-b43c-74832886b32a	40d9b84b-4a44-45ba-b999-d8adfb99f596	59d25cc8-403e-4409-9b5c-bb6564772f4b	PRINCIPAL	t
1b132c95-6009-4b87-a1db-58785bcb0fd0	27407792-bdc9-4959-ace0-03c4eecc07e1	59d25cc8-403e-4409-9b5c-bb6564772f4b	PRINCIPAL	t
4b694eb0-a65f-41d0-9ea5-72a306be97ff	9681cead-3cd8-4565-ae5d-a5f07cc59735	59d25cc8-403e-4409-9b5c-bb6564772f4b	PRINCIPAL	t
d0835ac7-55eb-4b76-8ad3-14e5383e630a	41df81ba-2e4f-4576-a550-e4573a610d97	8fbdb915-807d-4450-a514-daf051d5710a	PRINCIPAL	t
dc55f88d-6672-405e-8c86-e45fedaa9c60	4b4573e2-6f91-410c-83cd-5f44102e5ae7	8c0214ed-61c1-43aa-a479-baad51350fae	PRINCIPAL	t
0c33a276-3667-4e99-a4bd-e01d2bc60827	5bd84c4a-62e4-44b4-ae81-2f62cf6d661b	8c0214ed-61c1-43aa-a479-baad51350fae	PRINCIPAL	t
da6c1b68-f2b1-4315-a71e-3a47765846e5	d23f95a1-63b9-4c61-8297-f2a92ff46b70	8c0214ed-61c1-43aa-a479-baad51350fae	PRINCIPAL	t
da900f9a-b39b-4ab2-bc9f-c3d2f2c6ffeb	c6d11913-a450-4927-a008-5f9ad92f2d9b	8c0214ed-61c1-43aa-a479-baad51350fae	PRINCIPAL	t
951d779e-833f-430f-9277-6305dea97200	bd1f7bea-e1b8-4fe8-9e9e-ab7253e14e92	f6ff71dc-2f5d-4fa5-9639-766717c3965f	PRINCIPAL	t
6268d418-e882-4f5c-b028-48910316724e	3df9bd86-8f56-4361-9bd2-6f9c664b006b	f6ff71dc-2f5d-4fa5-9639-766717c3965f	PRINCIPAL	t
ba5c807a-e396-42ac-bef1-b924fa266fa4	cea78c90-e6dd-491c-aa0e-364e9fb8c228	458e13a5-ad84-4a37-9baa-028fc5e9d7bd	PRINCIPAL	t
f7cca7b7-4369-4ca5-92ae-451df575359d	9225a1d3-211b-4e14-bb6b-b9665aeed911	cd62e541-8699-4e78-a979-37ab0a48feb5	PRINCIPAL	t
8766e40d-219f-4761-9f7b-0ddb4eb52440	8679175f-5553-4813-aca7-cff8a5e8ff16	bf43a85b-0ac9-4f00-a7e8-cd5fea6c4cbd	PRINCIPAL	t
9aa059c4-3dc9-4ae6-9a13-4fdc17c35c6c	3e2b1593-6b37-4f3b-bc9b-f22de8d0027c	458e13a5-ad84-4a37-9baa-028fc5e9d7bd	PRINCIPAL	t
2729425e-4be2-4613-8eda-782c49b64862	e9f229ca-0ad4-44a4-98bc-8e3ee48bbc99	7456cd76-9949-4c82-ac10-6d0a29009d71	PRINCIPAL	t
9fbe8c65-8384-4806-ac1e-6c116f33c2b8	38673f83-1164-4cfb-b635-66b6420e3d1d	6ecf47d3-28a5-44b7-a008-9273d0cbe48e	PRINCIPAL	t
51f8b37a-240b-463b-992d-4f5ce64a5c3b	9642d843-f82c-4fad-9bc7-a604d5a037b5	6ff66801-9832-4329-8deb-16a15f17b3b0	PRINCIPAL	t
cad70a5d-44c4-4d57-9479-5d64664e59b1	7677b9ca-73ab-4951-a4a8-fc636cc3a7f5	2319d7d2-75f2-400f-998b-13b32a0b564c	PRINCIPAL	t
07a83249-3ac1-4898-a294-44db78694ad0	7237d5ac-1c45-49a0-a259-7cf749fae74f	b4aa76be-d343-454b-bb9c-c78f4150f181	PRINCIPAL	t
11a1145c-460f-49ef-b4e9-57abc2f27876	51dcdded-f829-4657-8d58-ed9924752a57	11b3358c-7d76-47dd-bb76-bc68090950f9	PRINCIPAL	t
7d659be1-2f32-425d-930a-7641e15df7de	5d5ceba8-dde7-4725-9902-c888baf5da52	fc13f6c2-e808-4ee8-b0f1-8eaacc3add9f	PRINCIPAL	t
58de8177-f98e-476c-ac81-ed26d40bf31d	50560649-e2f0-4aa6-be75-e5649da21e53	a9a94140-276f-41c7-9486-f9c6621ad843	PRINCIPAL	t
8c547b18-8f12-4a9b-af76-8f29469debe9	112fd3e1-d305-41ca-aaa7-fff875543082	c5a0a3c5-3069-4d5b-9f1c-979e3a20339b	PRINCIPAL	t
df20ed0a-f656-4ae4-8fce-e91f7d57aa85	61621452-d7fb-498a-aaf3-245eedbc5b58	0bdfe245-991d-4455-89cc-a3f12d61a20e	PRINCIPAL	t
17144fac-d15a-4b72-8e82-d6f01bcbf4c3	aa9f4b02-d571-4cd6-a1d3-b1c9b94e60d3	a3f2f8cf-9733-46a4-8a2c-9a4f8c443c82	PRINCIPAL	t
3b351d1f-63db-41b3-ae2a-ea391be73843	36f3e7a5-f604-4928-98ae-5851e305a366	8b780913-0405-42bf-b009-901f767149d7	PRINCIPAL	t
2dccc8ea-f55b-4cc6-a61a-d7791875e69c	73e36249-016b-43aa-93ac-870e378a40eb	ae35ab61-34a4-4d3a-b77f-1c3f1e754879	PRINCIPAL	t
27eab79d-f278-44e9-aa55-aca70935e14a	4e7acf7c-16ce-49e1-b842-78b359c3d4b7	97a5011b-ca79-4332-8b7b-464d7b185c72	PRINCIPAL	t
e8e69a6c-e1e7-467d-8488-fe6cc93a0d16	7aafb0b0-5382-431e-81fc-d6ba3cc36bd6	7e2a574f-655f-49c6-b7cb-5db09e53df1e	PRINCIPAL	t
91dd0c63-1c3a-426b-9183-527ca2179e11	2d5708e6-e1c5-4efd-98cf-d8e2d50ecc7e	6ff66801-9832-4329-8deb-16a15f17b3b0	PRINCIPAL	t
bd1f8d81-4d5c-4279-8ef7-679ec8b126cb	35cda01c-a62a-4ee4-8787-e3734f535e6d	87c4cd3c-0d8a-4ca4-8376-0bfc4b1c8a43	PRINCIPAL	t
d4769345-65d2-47ec-984f-59c2ad76150f	edc87ceb-0752-4a63-b6ec-641c82e652ba	e62ae162-a603-4d44-bd04-cb704abd951c	PRINCIPAL	t
c0a538af-3e4e-4020-bf08-35a30820fce8	370422ea-2cc7-468a-9f69-63c9c408a011	9ab70dad-1121-4e00-a67b-3c8ed999af01	PRINCIPAL	t
\.


--
-- Data for Name: mareas_movimientos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mareas_movimientos (id, id_marea, fecha_hora, id_usuario, tipo_evento, id_estado_desde, id_estado_hasta, cantidad_muestras_otolitos, detalle) FROM stdin;
73508df0-263d-489f-964b-e4ac3011e1dc	e7844417-503b-4eb4-9225-af494816ebd8	2026-01-03 20:18:41.636+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CAMBIO_ESTADO	0b21451e-e14c-421e-8387-5478e7a4ad88	e9c85d8e-268f-4598-bc6b-f9f2917be914	\N	Acción: Confirmar Arribo
b7c8ec86-aff5-4dcf-aaf1-f8b82c3c8c8b	f551dae9-57cd-430c-b0b8-d04574a1617b	2026-01-03 23:11:25.988+00	2066f934-5012-41dc-b88a-e18b242c5afd	RECLAMO_ENVIADO	\N	\N	\N	Reclamo de documentación enviado a nadal-claudio@hotmail.com
d6fcfedc-d440-4000-b643-0215d34f5dfb	79d71507-6e64-4d6f-a48d-af5da075f9a2	2026-01-03 20:11:18.364+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
fd6e621c-cfc4-4aae-9904-e02017b76e23	b19e3191-7c87-44eb-beb9-e5e33634a4b6	2026-01-03 20:11:18.383+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
99dee25f-8bd1-42fe-a71a-4e1c69fe5773	a96b66ee-3be2-41fb-bc15-258979642704	2026-01-03 20:11:18.394+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
87bf4a86-f688-4766-a552-e5464157ac56	7da900d7-acb6-478b-a2ff-6a301155e127	2026-01-03 20:11:18.407+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
06a26c9a-bac7-4b14-8e94-017e038dc799	6e4427b7-30e3-4677-9078-24dfc13e451f	2026-01-03 20:11:18.42+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
024eafe2-5c0b-4c43-8771-f0b6255ad1e5	31862f6a-a5ff-4768-9caf-9277b82860b3	2026-01-03 20:11:18.431+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
35996936-b3c4-4285-b9a5-3f3dc9ce520b	19657885-b7e0-4426-99fe-d8e94ee120df	2026-01-03 20:11:18.439+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
0de21b7f-28f1-4072-bab3-2f868ac4a3ae	637f2025-7f23-4b6e-9c11-1692fb5a2192	2026-01-03 20:11:18.448+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
be8f66ee-0fee-419f-8e57-a5535bcd358f	4c9381f2-8774-4df2-8a50-6a57229b1041	2026-01-03 20:11:18.461+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
6c05f343-0239-40f1-8fe5-70fc71b4711d	37cd6141-84d3-46b1-9af3-7e856284a14f	2026-01-03 20:11:18.469+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
ed9f169c-181d-4822-b91e-0e1f4ec9f4e9	04759b5e-6bde-4e81-b6d7-1501cc192aae	2026-01-03 20:11:18.476+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
718c5017-88b9-46e2-a01b-010efe0fb11e	b51443fd-d991-40ad-825e-3930af96862e	2026-01-03 20:11:18.484+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
c84d550c-dcb5-4f55-b2a2-7654997d0fc7	7bb3e592-e81e-48cf-ae66-85e6e4dd3595	2026-01-03 20:11:18.491+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
dd482a25-89ff-4f3e-9657-bac94034076a	b3ebd708-536a-4447-9770-ff47a412ad09	2026-01-03 20:11:18.499+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
2117f450-81cc-4ec6-9f38-ecfaa092480f	8f535c0d-5e9d-4653-9ab5-fb318e8d1acd	2026-01-03 20:11:18.505+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
86f63af6-0ba4-45b4-a2b0-13a1b0adf3a7	1bdd5d86-c5e7-43c1-8dd9-121854f820df	2026-01-03 20:11:18.519+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
da62c13b-7e48-498d-b47a-fdcb04a5cd69	cfef1c13-486c-4215-89a3-227b00dcce5f	2026-01-03 20:11:18.526+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
904fe308-9d50-4ee3-a528-b4f53a172883	ec5d55b0-f3f0-43ca-a17a-6ef8e501566e	2026-01-03 20:11:18.534+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
3b6f35e5-3893-4825-80ca-fcc0bdabf7b8	6b062594-8807-4232-9d01-711e34cee3b5	2026-01-03 20:11:18.541+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
e5a52828-e7c5-4a10-9c69-077aef2e011a	ade9f2b1-ba03-4d4a-b2c8-fd2597bddd04	2026-01-03 20:11:18.548+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
f8f6b060-8410-46c9-8e6f-9694aa7455a9	d7e4e28b-0bcd-4fde-8c7f-3ca450f56f5b	2026-01-03 20:11:18.556+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
11bf49ef-6ae1-4501-803e-7423e9e88ca4	4b5441ed-a56e-44c4-bcf5-c16ee4b16272	2026-01-03 20:11:18.563+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
96c984da-7560-40af-8e37-cf1073713de5	6f7fe6d1-b49b-4b86-9362-572ae33459b9	2026-01-03 20:11:18.571+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
fc699ac0-cc98-43d1-8d85-36afead5480f	97c101e4-5641-4aef-ba6b-2a13cb3097a0	2026-01-03 20:11:18.58+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
9487fc7b-d779-45ba-992a-a53df6e878d7	4e451adc-44a1-4478-b3c1-f31dbf02f7c8	2026-01-03 20:11:18.587+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
79651626-096c-4278-ae40-1602259aa11c	fe79cfff-3bc3-4f1d-b124-4bd340f56a41	2026-01-03 20:11:18.594+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
30bd4f8d-c991-4e20-a6b2-b7e7cb1d2765	af648e74-daba-4d96-9bcf-46df9b3fe177	2026-01-03 20:11:18.602+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
92fcd707-0845-47b4-ab83-c65a12604e35	28d7c818-dce7-4629-87b5-558cdc792aff	2026-01-03 20:11:18.609+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
2a99e142-4ead-4e0a-a8e6-907862cd1cc4	d9864297-9fb4-44f0-8661-025d97c938cd	2026-01-03 20:11:18.617+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
69e735f5-6deb-466b-abfd-850f8282e3ea	56d53745-dced-4972-9cb5-0692084fcc4f	2026-01-03 20:11:18.624+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
97ae7f8d-2c9b-473b-96f3-19e7642d5c09	e24b6fa9-99c3-45d8-b3d3-6a3925adca9a	2026-01-03 20:11:18.631+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
3265b95d-e6ad-42f1-858f-d166f6eae17c	46b9320f-ddcb-49d4-abce-2428e90e7384	2026-01-03 20:11:18.638+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
2edb498e-4072-46b2-9b73-48de4a7ee2d5	53944760-6b2b-47c5-8d73-f7b76c8db53f	2026-01-03 20:11:18.645+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
c67696ad-8a30-4b4b-85d7-5db506a5670c	70365df4-8a27-4b4d-a618-5d12d8abec48	2026-01-03 20:11:18.653+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
eff724e4-e6b7-47e5-9fb8-39f7479cc364	b97893c3-73f7-4baf-b937-07f16bbcf1d3	2026-01-03 20:11:18.66+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
0f794bba-ec7a-4a6c-b221-2c6764a1432c	b6784dbe-0462-4fa0-92fd-b72a1b91e5fa	2026-01-03 20:11:18.667+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
81bbc0c0-cfe0-4a14-be9b-1de08d4828fe	67b854ff-f571-49fe-a941-4fb979b69bcf	2026-01-03 20:11:18.675+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
5e4ebfb7-926e-4347-8d49-84cd3beb149c	1a751029-d9eb-40b6-9d05-abf787da21ab	2026-01-03 20:11:18.682+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
7ef3709c-272a-4dd9-aa70-06cfcaf996eb	03488945-c9ba-49d5-a405-a1d82bd9d592	2026-01-03 20:11:18.69+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	eb8ce446-7d4b-4eb8-a953-8a8fbcc7a912	\N	Marea importada de seguimiento 2025 (JSONL)
e7a088df-8ef6-4ea8-982f-506e49769802	082e7798-f15f-4da5-b8cf-91fb20ab6fa4	2026-01-03 20:11:18.696+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
57773928-c78a-4e74-a200-8aba450315b1	53aae717-6efb-4d45-b0be-f1e1bf25f090	2026-01-03 20:11:18.702+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
42f33cce-b4cf-4327-9916-aaf007aaf2a2	cf63af20-1e4c-436a-adcc-01454b062a7f	2026-01-03 20:11:18.709+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
6dc11111-ce8f-4010-8418-3bd4f98e9d36	450b073f-d003-4421-a730-c0dd2ecd3dff	2026-01-03 20:11:18.718+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
45b8dcbf-a436-4c81-aa89-b1d37813fc03	2b0e1997-3859-4b47-b27b-b29c2ffc8225	2026-01-03 20:11:18.728+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
01e91282-2d9c-4c6b-9030-3b640c73b0ae	52c4df2d-b038-4e4a-9e2d-bda18426d809	2026-01-03 20:11:18.738+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
82725c47-0ec1-4ae3-b5e8-b941e7baf8dd	ec9a55c3-c2cf-4710-af3f-aec9621a82c1	2026-01-03 20:11:18.748+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
c1dbda42-4a67-4061-864d-7071b3d3271e	8f3245a5-9a2b-4c00-8f0f-4c0880fa7462	2026-01-03 20:11:18.757+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
f706d629-8ca0-42c8-853d-46881d3b3bcd	10b9945a-e0f2-4bc9-b36c-a283cbf7015f	2026-01-03 20:11:18.764+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
873691f8-3e0b-4311-aca6-71fc38c15b47	b6b54237-5bbf-469d-aa42-948dbda6eb6b	2026-01-03 20:11:18.771+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
77d1b0a8-4032-4ab6-802c-853eb3f51fa9	7f28b5b4-525d-4a45-8433-2c5fd816c50f	2026-01-03 20:11:18.778+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
8a374009-8718-46c4-a0b2-4b6a00c2e0e4	f34e2c2b-80e2-487f-a17f-1cdc6bf4bb7c	2026-01-03 20:11:18.784+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
cc9633ce-481d-4f91-bac5-15175d611fff	ac6950da-7071-48ee-b7f4-8376398c0604	2026-01-03 20:11:18.791+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
fbad3383-aa20-4a74-98aa-1f5593dade2e	a0911603-7b39-49d9-bbaf-83955aa2e5b5	2026-01-03 20:11:18.797+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
99a8f460-7d15-4ebd-aec4-30e10086e9c2	982d5b22-db50-4a84-af4e-a9d8fdd9aa38	2026-01-03 20:11:18.805+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
488bce56-a815-4bcb-9358-34c3fcf4bfcc	b6317a3e-0305-4fc1-b51c-7e7ceb644530	2026-01-03 20:11:18.811+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
0e29bb63-e1e1-49ab-8722-00b0961c2ff2	538f4c05-60f4-4621-bf67-4e8717cea2d2	2026-01-03 20:11:18.819+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
9c41a0ee-7946-4706-bf6e-a949a73312f7	9e5a11f5-eed3-4c22-868c-b8427e4e68ee	2026-01-03 20:11:18.826+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
034e95f5-e40e-4476-a23d-1e65495744d6	aa652fdd-04f9-42fe-904d-face93041676	2026-01-03 20:11:18.833+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
eace24ef-3b0a-48ae-bd09-110f45cae537	ab07ab6d-1913-4ed4-9223-8b5acd787726	2026-01-03 20:11:18.839+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
c443867c-ed17-4a4e-84e8-76310f39c8d5	ffedaa30-08df-4a10-980d-32076a3be5e9	2026-01-03 20:11:18.846+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
33b746ac-0d3f-490e-aa93-3822783bf7fb	ed15ccd1-bfad-41f6-8f99-c2d597b85d57	2026-01-03 20:11:18.853+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
df16ce17-f48a-485e-ba07-4ebad56a8bc8	f2e78ff7-025b-44e1-a086-8490522c6a8a	2026-01-03 20:11:18.859+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
5b80f49e-dcef-4d01-b05b-033a9357676b	64ee9147-5917-41f4-8a45-cac6d75ce56f	2026-01-03 20:11:18.867+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
bc5ab42c-a166-4d73-82c0-681511a9b87b	6c4b461b-2c21-459a-8aef-b22a2f24247b	2026-01-03 20:11:18.879+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
54fac745-7fdd-431f-a446-ae51e2a68dfb	7030697f-f606-431a-907d-fb34fe7bb756	2026-01-03 20:11:18.889+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
504403ce-4788-455f-9eae-7e1f2c2eb1bc	62c182f3-0e39-4b62-aab0-1ea9c27c5e43	2026-01-03 20:11:18.905+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
3ea598f6-ec70-4338-9a7f-11d5704a152d	9a24be82-d932-4cc6-8f42-ec5ba9246cfb	2026-01-03 20:11:18.915+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
cdd08eae-3092-4a23-b89b-6406689e3d7d	380918f6-7d78-45c6-84b4-aae70857d65a	2026-01-03 20:11:18.922+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
b4d895cd-63b3-428a-b748-19c64aa8fa3e	b4fad7d7-c555-4a9b-9935-74df16e06222	2026-01-03 20:11:18.934+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
9ec427eb-92bd-481a-b02a-a44fa2ab88aa	02d3acb8-c754-4cca-8ba5-e376c45b7d7d	2026-01-03 20:11:18.941+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
6c11f33c-3733-4a79-8e90-24aee312790c	7193ebb7-16fd-43f0-bd27-d3a362cca3d0	2026-01-03 20:11:18.951+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
76bdf72f-b108-4ca8-8d8f-70464c6e3269	a7630b0f-fb5e-445a-806b-bd8512b72782	2026-01-03 20:11:18.958+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
54d317bb-4554-4294-82f1-1af377990f61	199a7e71-bc83-4f38-a9a9-33dad197c5e9	2026-01-03 20:11:18.965+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
b0019f33-5ce5-4c59-97db-7183c96839cb	6ed02559-0d7d-4ac7-b54d-1f255a416d05	2026-01-03 20:11:18.976+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
1e1cc908-ffaf-4225-be0d-394a3856e6db	0a94d961-2516-4487-9438-5e0d26e3b7bd	2026-01-03 20:11:18.983+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
340f7692-7514-46e2-be11-24ac43f2132e	f4a9d31f-9163-4cbe-8b14-1bc8c7671a3b	2026-01-03 20:11:18.99+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
b7d72ad8-72f9-4ef1-96b6-322f5532a64d	0def0199-df9b-4fd6-9df5-87d58b14019f	2026-01-03 20:11:18.997+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
3e8c1d29-e300-4c30-a7c5-a1787bac05e9	6cd03b64-6890-4c6d-967f-121e1741dd10	2026-01-03 20:11:19.005+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
d20f0488-c7b9-415b-9aee-67d6886d52a7	c889d2d6-b997-4ee1-820d-a0ece47ae17b	2026-01-03 20:11:19.012+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
ff7e6a39-1fc4-466e-9148-7e6f36773874	ad40ea2f-34b2-48b5-9890-cb9e96154d87	2026-01-03 20:11:19.019+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
1b8dc918-f35b-40f6-8c06-54f73992f8b3	7fb87527-817b-43f1-bea7-e3e564cedd08	2026-01-03 20:11:19.025+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
0652b49a-c797-4e2b-a4f0-76f118df4527	2d937399-4aff-454a-8199-17b4d81a6160	2026-01-03 20:11:19.031+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
51ac7a4a-b71d-4490-ae2d-673d4dfe558d	02fac296-4a30-4537-b9ab-da3448f698fc	2026-01-03 20:11:19.038+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
c9478b62-b054-4611-a3e3-734117f0d76f	8f75b9ef-5c2a-4153-a385-2aad0dc51c0f	2026-01-03 20:11:19.045+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
3af74ca3-de9d-4fdb-a67f-28ee72e4ba67	d96f4bd5-4df8-4301-aab4-ddb349f1a330	2026-01-03 20:11:19.052+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	eb8ce446-7d4b-4eb8-a953-8a8fbcc7a912	\N	Marea importada de seguimiento 2025 (JSONL)
325ccd74-f1fc-492f-a8b6-8b99d098c9bf	a22200aa-163c-49e2-937e-b0a8c5f19157	2026-01-03 20:11:19.057+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
94193a34-1288-405a-995a-377b30154e77	00e11fc6-81c3-4969-b8b4-beecf8ae8174	2026-01-03 20:11:19.063+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
d8691403-334f-4a37-823c-cc2f5f2ba746	98879b7b-b863-4d88-8711-2f5c5cfeeaa5	2026-01-03 20:11:19.069+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
dbf389f4-2777-4d2e-ba61-98e00e64a608	b1a638a5-b5de-43d3-9988-249b46d677e0	2026-01-03 20:11:19.075+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
db9d1efb-5faf-46d4-8c91-7f32a8f3007b	b293b413-8b61-4584-a548-b4e96728af0e	2026-01-03 20:11:19.082+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
fbf9a67f-0cd1-4c83-8d47-4edc625e1d87	71cb28d3-0f4e-4ba8-8696-ca682bea44fe	2026-01-03 20:11:19.091+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
dae361f5-3ce8-4025-a180-1b30b5989e3f	475da7f7-726a-47f5-abd4-da5ac55ce768	2026-01-03 20:11:19.098+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	eb8ce446-7d4b-4eb8-a953-8a8fbcc7a912	\N	Marea importada de seguimiento 2025 (JSONL)
b6833b39-e702-43f6-919b-e2a871316668	3f06d1bf-ccaf-45a4-9c67-dbe20e8bfb07	2026-01-03 20:11:19.102+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	eb8ce446-7d4b-4eb8-a953-8a8fbcc7a912	\N	Marea importada de seguimiento 2025 (JSONL)
31509634-b83e-40de-a7c4-8d2e033d5acd	f145588b-3628-4e38-bfa3-266dec6a1ceb	2026-01-03 20:11:19.106+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
4741e801-55bd-4e75-b821-dbe938ca3ef2	e2ca8345-f8a8-471e-819d-91c7a325eb48	2026-01-03 20:11:19.119+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
401a096d-0302-4629-9194-19dc8c2025c4	b46086cd-5e9d-4f2a-8725-bc515f2cf543	2026-01-03 20:11:19.126+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
a7582b92-48bf-49ba-a94b-6dcc919c1d10	4104ff3f-1513-439f-b665-02d5b3003cbf	2026-01-03 20:11:19.134+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	eb8ce446-7d4b-4eb8-a953-8a8fbcc7a912	\N	Marea importada de seguimiento 2025 (JSONL)
2410205f-f200-4d56-9539-5112ef5ddb6a	8771bc92-95e8-43b4-9a22-234bf00ea287	2026-01-03 20:11:19.139+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
ed3ce310-5325-4599-abfc-f2bcdfcc5adb	0f475caa-0780-46ba-90a2-61c893aade36	2026-01-03 20:11:19.146+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
ba0843f4-42c2-4003-b309-4d131fa83fc1	1ad010e1-1057-4a0e-982e-55e9473530b5	2026-01-03 20:11:19.164+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	eb8ce446-7d4b-4eb8-a953-8a8fbcc7a912	\N	Marea importada de seguimiento 2025 (JSONL)
fdbab8af-f755-4872-881b-8997c71ea065	8239a760-f987-4940-86f7-05d00f4de3fc	2026-01-03 20:11:19.17+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
067f0a7d-b5b4-40e3-a98d-90e1118bb3b3	4d21d19d-4b03-47db-9c0b-5152a757fbf4	2026-01-03 20:11:19.181+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
6556abad-0b46-477a-8510-0b33af33098d	981fab8c-6832-4733-83ef-46eac045c3dd	2026-01-03 20:11:19.189+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
def4f6ff-7dd2-4fe7-8655-94428e59b86a	4af76975-cdf5-477d-b0c8-b4dadce8d599	2026-01-03 20:11:19.198+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
7d91eb79-92c4-439e-adad-a4f22089772c	5d2000dd-6b2d-4950-a747-60789a7f620e	2026-01-03 20:11:19.206+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
13842771-62ee-4350-b960-7411076d7f92	e8041510-9b74-4285-ba12-ce5cafe76d87	2026-01-03 20:11:19.215+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
a4db0957-cd92-411d-82d6-86e5a5fb96cf	3240ec69-fb6b-4b02-b2e7-1ec0d54e826f	2026-01-03 20:11:19.225+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	eb8ce446-7d4b-4eb8-a953-8a8fbcc7a912	\N	Marea importada de seguimiento 2025 (JSONL)
bf8cd1d5-5ed4-4884-bcfe-cd51cd218b2e	0a20e0d2-0590-4512-8886-90bdd19ad006	2026-01-03 20:11:19.23+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
f1ff655f-00ab-4126-ac9e-f8d4488de469	a2824c28-8b00-44f3-a566-db1b2717e8ab	2026-01-03 20:11:19.244+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	eb8ce446-7d4b-4eb8-a953-8a8fbcc7a912	\N	Marea importada de seguimiento 2025 (JSONL)
572452f8-8918-4241-8ae3-b1ad905b8bd0	36f8b629-8513-44f9-be1d-149a07cbd0b7	2026-01-03 20:11:19.249+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
b731301c-c61a-4c3a-a34d-7c54d977dfa2	91d66e1a-bcf6-44f0-92e4-6337e4a3e09d	2026-01-03 20:11:19.257+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
e709f5c1-ba52-4523-8a5d-33642b760372	215eee76-2107-47a3-a401-664d82ad41a4	2026-01-03 20:11:19.267+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
44060795-d7a4-4eb1-b0be-4ebb290fba88	8da8e5c1-5731-4ccd-971d-87930c320963	2026-01-03 20:11:19.273+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
8abcb364-734a-40db-ad58-6b8bb8816f98	8e385152-b072-49fa-ac7b-f3799b0aff6a	2026-01-03 20:11:19.286+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
685fd6d0-cc38-4a1f-9702-a41967a8c307	d89f9b02-27be-4322-9f8b-7316bc4efc00	2026-01-03 20:11:19.292+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	eb8ce446-7d4b-4eb8-a953-8a8fbcc7a912	\N	Marea importada de seguimiento 2025 (JSONL)
38984562-8919-4508-8b75-98cd252737da	c459611a-073a-48f0-a3c6-bf568dd5ab07	2026-01-03 20:11:19.297+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
494e1c43-c0b0-4ee9-9ec9-ba574493f90a	c231775c-9b78-4262-9c75-6bb4022698b6	2026-01-03 20:11:19.303+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
740b6251-569d-4560-b97d-d11cdf029266	da1083d0-6d3c-414a-8462-85d5c0b4bed1	2026-01-03 20:11:19.309+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
8c940c1d-db0b-46fe-9d17-d7d4c23f4f75	1a43f6af-10a9-428c-96af-7a28bc7c5b34	2026-01-03 20:11:19.317+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
5428ac9d-07a3-4183-8d92-c60ca226cd68	8b04c362-c4fd-4f3d-9431-d33e4c9ee2cf	2026-01-03 20:11:19.323+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	eb8ce446-7d4b-4eb8-a953-8a8fbcc7a912	\N	Marea importada de seguimiento 2025 (JSONL)
b0940e01-662d-4110-be71-2706b3005a0a	fdfc020a-5ea8-4a38-a696-b10160cfbf23	2026-01-03 20:11:19.328+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
b03b7a4d-8524-4070-95ee-b59bb69bd554	4061951a-e2f3-4588-8a81-1ad5e3d5cf70	2026-01-03 20:11:19.34+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
c13657d7-a69a-46b0-a149-c5eb5093cfcb	5b895e1a-ce4f-4ce6-8fa6-f1a412a4ac9f	2026-01-03 20:11:19.347+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	eb8ce446-7d4b-4eb8-a953-8a8fbcc7a912	\N	Marea importada de seguimiento 2025 (JSONL)
85899410-2751-4ae7-9e36-0e732aaa3713	12adcd78-0f99-4786-88e9-7f1b53d364c3	2026-01-03 20:11:19.351+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
5a8e2acd-4a4d-4e51-8b3d-1cfef1ed0a49	825fc30a-31ff-4351-baa5-73ee82070276	2026-01-03 20:11:19.359+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	eb8ce446-7d4b-4eb8-a953-8a8fbcc7a912	\N	Marea importada de seguimiento 2025 (JSONL)
b85f2a7b-d777-4b7a-8499-4874fa216eaa	c46145b3-1fd8-4005-a4cf-1676d0e6aea1	2026-01-03 20:11:19.364+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	eb8ce446-7d4b-4eb8-a953-8a8fbcc7a912	\N	Marea importada de seguimiento 2025 (JSONL)
edde3d67-174a-43aa-8f11-01a8aaf86cb1	8fcdb22d-69a6-4e77-8006-46e6476614d5	2026-01-03 20:11:19.368+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	eb8ce446-7d4b-4eb8-a953-8a8fbcc7a912	\N	Marea importada de seguimiento 2025 (JSONL)
a889bcb4-0ad6-4f4b-969a-31344d0063dd	d66d005e-e7f6-4a80-888f-742e380b15d0	2026-01-03 20:11:19.373+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
2cf23136-2efa-46aa-8695-ac7a89c4205b	db80ca37-beaa-4e3f-a9e9-75abcbcaa066	2026-01-03 20:11:19.379+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	0b21451e-e14c-421e-8387-5478e7a4ad88	\N	Marea importada de seguimiento 2025 (JSONL)
f83f4c0a-fa6c-43ac-b437-58e0aced1c67	70ca3caa-810a-44cd-9c01-43e86ea917f5	2026-01-03 20:11:19.386+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	eb8ce446-7d4b-4eb8-a953-8a8fbcc7a912	\N	Marea importada de seguimiento 2025 (JSONL)
3b08f2a0-3f37-4214-b403-aef8c46aa2a7	bd96ab83-2467-49a8-bc3e-8b4700a9e4a7	2026-01-03 20:11:19.39+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	eb8ce446-7d4b-4eb8-a953-8a8fbcc7a912	\N	Marea importada de seguimiento 2025 (JSONL)
8d8c89b0-c29d-4f58-b38a-4b8b32e3453d	e7d698f5-fc82-48c2-acb7-620a8dd00000	2026-01-03 20:11:19.395+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
8db18a32-2447-47df-9da3-141563ddbb4b	aaba4967-5646-497b-af4a-d91159b24152	2026-01-03 20:11:19.401+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
3827fa31-4b28-4610-9ce0-f016b081200f	9f1c446c-c3d7-41a0-b578-fc7ad021a15b	2026-01-03 20:11:19.407+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
038a6ede-5db8-4c93-b263-881fbe7770af	a8dea641-66e3-4f4e-b528-299fd17ad983	2026-01-03 20:11:19.418+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
ff0ff540-3697-4893-b0bc-15bf0925d2e9	c87874c5-2bbd-4158-8334-5a6c9867a589	2026-01-03 20:11:19.428+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
e70cda00-eaae-4e1e-bcf5-d9ed10f275cf	fcbeade7-fd24-4771-90d8-d194a5e9db8b	2026-01-03 20:11:19.434+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
4e0650c0-efad-4bd5-b685-d7da091a1670	29455e29-1cb5-4408-9d5a-b5d60b72a0d0	2026-01-03 20:11:19.441+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
fa9e359e-b322-4bc1-bacd-f5596442b34f	f20dc72a-c272-44aa-bb99-13934679e7c6	2026-01-03 20:11:19.449+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
bb070eff-0d9f-4599-9ec9-749afa455b19	b4cbac19-0032-48f3-86df-eeb97376a53b	2026-01-03 20:11:19.455+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
bf66a27e-021d-4d8b-950d-35ce8eb67956	52664ce3-d49e-4862-ae60-1d3c91d273d4	2026-01-03 20:11:19.462+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
16e9dae7-191f-4183-9443-e6700c9630d6	a06af4fd-cd7c-49b3-abb2-8d63015e25fe	2026-01-03 20:11:19.468+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
3053179b-d8ee-47e2-a815-435b1e12bbd3	186acbd5-ca5d-4ce7-a7b8-e109d62d625e	2026-01-03 20:11:19.48+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
f419730e-5b5f-4b8e-adc8-560fd78f0adf	2a7407a5-8754-4434-ba31-fecface06bf7	2026-01-03 20:11:19.486+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
6addf0f5-6882-4a52-bca9-35093fe57b29	9f386967-b338-415b-99f4-136badedd2a1	2026-01-03 20:11:19.493+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
4318a09f-18b5-4d44-a3b3-9deb4089ec91	895456d9-265c-4303-b35e-7de43c967339	2026-01-03 20:11:19.505+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
ffa9e6b6-c0df-4fee-a6fe-d9e198bc4cec	631f6ad1-e76e-4d1f-9204-fea4f4c547d8	2026-01-03 20:11:19.515+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
2635581c-a620-429c-9814-4e87d9788c5a	75279f40-4d1d-480a-b9f0-9cc45ab4dd8d	2026-01-03 20:11:19.521+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
bd7f6c44-579b-46cc-a11f-dbb95162b322	b3a88fa9-d7ae-4004-9f12-766e8b90dba3	2026-01-03 20:11:19.528+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
fac904cf-390a-42bd-9ec5-ed910dfd85dc	cad981bd-a054-42fc-ab60-6ec82aee7366	2026-01-03 20:11:19.534+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
573f44d1-edfb-4b47-9d34-77642aedd461	e9a1826c-fad1-494d-9f86-c08e0ad99adf	2026-01-03 20:11:19.54+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	eb8ce446-7d4b-4eb8-a953-8a8fbcc7a912	\N	Marea importada de seguimiento 2025 (JSONL)
07fab886-fb81-4707-9c7d-88dd43611750	09d2efb7-4ffe-4e9d-869b-ba14a3f91534	2026-01-03 20:11:19.545+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
c3a93d4b-9657-454f-a404-50411dcd9d46	6817994e-7dc2-4a00-9bd9-cde763cc2ad1	2026-01-03 20:11:19.552+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
b2276f52-ea33-41de-b6e1-acc5716e5e43	848ab357-d77a-4bc2-a4d9-414b4766e65f	2026-01-03 20:11:19.558+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
95145cdf-0e2c-400f-a089-e35784cba238	42016b47-6334-4c4c-91dd-1bf03acbff52	2026-01-03 20:11:19.564+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
423d7e29-ea72-46cb-96f6-73371f574137	86082db1-9f3f-494a-8a52-95eede79efce	2026-01-03 20:11:19.57+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
e91f3624-b4d0-4df4-96ac-16416321851b	d4bc315b-7693-45e7-bf6c-04e14fbb20b4	2026-01-03 20:11:19.576+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
14a5115e-b711-4ef0-9fee-f77230bd354d	e62a6272-41c3-42ee-a529-10f41b975517	2026-01-03 20:11:19.582+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
62ac22a3-9dd4-4a8c-b152-346af04381d1	72d0ba61-74b5-4324-9772-11837b6b263c	2026-01-03 20:11:19.589+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	6df7c4fd-8134-4cd6-8867-b928bb0c0ef0	\N	Marea importada de seguimiento 2025 (JSONL)
1959e94d-b378-46ae-8ed8-0d6760b05ca2	374223da-ae98-4fa2-aafe-a6862f235a39	2026-01-03 20:11:19.596+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	6df7c4fd-8134-4cd6-8867-b928bb0c0ef0	\N	Marea importada de seguimiento 2025 (JSONL)
f3506e83-1967-4986-b784-d6691af5c006	d0c896ca-f982-452a-92b0-491df1cc9a60	2026-01-03 20:11:19.602+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	e9c85d8e-268f-4598-bc6b-f9f2917be914	\N	Marea importada de seguimiento 2025 (JSONL)
0d2299d6-4b39-4905-9b73-ef9cadf91f6e	bce66084-90a4-439b-937c-d25f4ba1c75a	2026-01-03 20:11:19.608+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	e9c85d8e-268f-4598-bc6b-f9f2917be914	\N	Marea importada de seguimiento 2025 (JSONL)
6820a37d-3f13-4ff5-9e94-d2ce14012f28	2b2cf340-d8c1-494f-9f65-4c9cabc9fd5d	2026-01-03 20:11:19.615+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	6df7c4fd-8134-4cd6-8867-b928bb0c0ef0	\N	Marea importada de seguimiento 2025 (JSONL)
4bf16378-63c7-4e7a-a1d8-b336abffcf1f	f0a855c4-87b7-4cfb-a212-0bba29612878	2026-01-03 20:11:19.622+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
f17523f5-6f1e-4696-aec0-69fe6b6ea42f	51f280b0-c38b-4a78-817d-49010fb8dca8	2026-01-03 20:11:19.629+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	1617c3f4-2ae6-482a-9710-067e2d0c6e50	\N	Marea importada de seguimiento 2025 (JSONL)
be507d34-dcba-42b8-aa94-82b33bc69fed	622eb238-54ed-4053-8a31-c7418fc5a655	2026-01-03 20:11:19.635+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	6df7c4fd-8134-4cd6-8867-b928bb0c0ef0	\N	Marea importada de seguimiento 2025 (JSONL)
74fb27a3-3d8c-4063-8247-051120b3a110	16f4924f-db37-4ae9-a0c1-8c6d78700ed9	2026-01-03 20:11:19.641+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	6df7c4fd-8134-4cd6-8867-b928bb0c0ef0	\N	Marea importada de seguimiento 2025 (JSONL)
5640f138-77fd-486e-bb0d-4753b0a5d2fa	c02d7370-1d59-4961-9f81-b07619d2695c	2026-01-03 20:11:19.658+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	6df7c4fd-8134-4cd6-8867-b928bb0c0ef0	\N	Marea importada de seguimiento 2025 (JSONL)
f8dfa555-3f8b-478c-ae1d-7918b8532b16	ccd384cf-d047-436d-8aef-987b9c1c04f6	2026-01-03 20:11:19.664+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	e9c85d8e-268f-4598-bc6b-f9f2917be914	\N	Marea importada de seguimiento 2025 (JSONL)
bf3ccd06-097c-4aec-85f7-cd9086258348	3f626d50-76fd-4934-b50b-7f4d38f92353	2026-01-03 20:11:19.67+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	6df7c4fd-8134-4cd6-8867-b928bb0c0ef0	\N	Marea importada de seguimiento 2025 (JSONL)
8bdf30b7-e9bb-41e2-8870-0c90a8567be0	ae40317b-c514-4f2c-b12c-5b63269321d2	2026-01-03 20:11:19.681+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	e9c85d8e-268f-4598-bc6b-f9f2917be914	\N	Marea importada de seguimiento 2025 (JSONL)
a1a7e1d7-d456-4b9f-b1c6-9efa5a435001	64df8d4b-89ff-4533-a3d2-e98ee10b731f	2026-01-03 20:11:19.688+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	6df7c4fd-8134-4cd6-8867-b928bb0c0ef0	\N	Marea importada de seguimiento 2025 (JSONL)
9be5e7b0-c662-4d9c-9c24-b4969661521d	115f3be2-67c1-4e63-8766-3488ec401619	2026-01-03 20:11:19.696+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	6df7c4fd-8134-4cd6-8867-b928bb0c0ef0	\N	Marea importada de seguimiento 2025 (JSONL)
22cd2dec-aa62-453c-936b-ff464e7cbb72	1caed02b-996b-477f-9c67-e1e10f0874fc	2026-01-03 20:11:19.701+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	e9c85d8e-268f-4598-bc6b-f9f2917be914	\N	Marea importada de seguimiento 2025 (JSONL)
a4db9060-a52e-41d4-9258-1c873de37e1a	f551dae9-57cd-430c-b0b8-d04574a1617b	2026-01-03 20:11:19.707+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	e9c85d8e-268f-4598-bc6b-f9f2917be914	\N	Marea importada de seguimiento 2025 (JSONL)
ff55faf0-5c9e-46cd-952a-eb8a305d3823	fb4ef943-5409-47fd-8a45-2a57fab3f295	2026-01-03 20:11:19.719+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	6df7c4fd-8134-4cd6-8867-b928bb0c0ef0	\N	Marea importada de seguimiento 2025 (JSONL)
63d8399d-1084-4700-a0e0-53c15919ed5e	f3bfe1c9-fb42-4d5f-9a1f-869490891cbf	2026-01-03 20:11:19.725+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	e9c85d8e-268f-4598-bc6b-f9f2917be914	\N	Marea importada de seguimiento 2025 (JSONL)
f3158f43-4e92-4e42-a084-dacf2ef5442a	7d2941cd-d0cb-4ff5-9143-f05867ecd280	2026-01-03 20:11:19.738+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	e9c85d8e-268f-4598-bc6b-f9f2917be914	\N	Marea importada de seguimiento 2025 (JSONL)
ee340191-8821-4d2d-ab5c-cdd124e6e298	6a56d4a0-7320-4cd0-a2ec-9ac51440eb30	2026-01-03 20:11:19.748+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	6df7c4fd-8134-4cd6-8867-b928bb0c0ef0	\N	Marea importada de seguimiento 2025 (JSONL)
1627cbb6-d169-443e-9f85-a77361a2bcd6	ebf2c8b6-5120-4aca-91bf-8e6d5511f331	2026-01-03 20:11:19.756+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	e9c85d8e-268f-4598-bc6b-f9f2917be914	\N	Marea importada de seguimiento 2025 (JSONL)
0781e78e-7e48-40db-8136-2faa29d06376	3d2a6806-79c8-4149-8878-a1209e55ba5d	2026-01-03 20:11:19.762+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	e9c85d8e-268f-4598-bc6b-f9f2917be914	\N	Marea importada de seguimiento 2025 (JSONL)
dde8979b-a76b-493d-a33a-2409a049bb16	d352f139-4b5a-4965-8137-a2f7654ba08a	2026-01-03 20:11:19.769+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	0b21451e-e14c-421e-8387-5478e7a4ad88	\N	Marea importada de seguimiento 2025 (JSONL)
954a64eb-4201-4e4e-a97d-a9c190f9109c	cac9ff30-b7a2-430e-920d-ec89a5224332	2026-01-03 20:11:19.776+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	0b21451e-e14c-421e-8387-5478e7a4ad88	\N	Marea importada de seguimiento 2025 (JSONL)
22b4419d-f55a-41d7-aa2c-f827c7e8c3e1	611c2056-ab40-4db1-9db2-58a81eb57607	2026-01-03 20:11:19.782+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	0b21451e-e14c-421e-8387-5478e7a4ad88	\N	Marea importada de seguimiento 2025 (JSONL)
ae32c3b1-5800-4083-819a-e857233813ca	390d7a7d-0060-4f05-b8d7-b0b513959a9b	2026-01-03 20:11:19.789+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	e9c85d8e-268f-4598-bc6b-f9f2917be914	\N	Marea importada de seguimiento 2025 (JSONL)
a7dcd83d-b819-4582-9664-cb0b7321c1c7	5749bfda-11a6-484c-b828-146f127de998	2026-01-03 20:11:19.795+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	0b21451e-e14c-421e-8387-5478e7a4ad88	\N	Marea importada de seguimiento 2025 (JSONL)
ae1f8ebc-22bb-4308-b73d-408d8ddba0b6	a3294f34-3bf1-495e-bd53-66f550391ba9	2026-01-03 20:11:19.802+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	0b21451e-e14c-421e-8387-5478e7a4ad88	\N	Marea importada de seguimiento 2025 (JSONL)
e3858dc7-3b0a-4dc0-9e9a-6da525797724	75075f81-3e8e-4a08-acf2-dfe365951c72	2026-01-03 20:11:19.809+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	ea2252eb-8229-4d52-9648-479058ec4334	\N	Marea importada de seguimiento 2025 (JSONL)
104c491c-ead4-4846-b521-b2290e8be98b	f3282fc2-0cbd-45b4-add8-485d7ac19f39	2026-01-03 20:11:19.816+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	ea2252eb-8229-4d52-9648-479058ec4334	\N	Marea importada de seguimiento 2025 (JSONL)
ca1b3a84-3d6e-43c3-95d8-8e7dca7ed7bb	5eb39723-136d-441b-9a24-a3ceb8df63e3	2026-01-03 20:11:19.822+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	ea2252eb-8229-4d52-9648-479058ec4334	\N	Marea importada de seguimiento 2025 (JSONL)
b2c34b6e-e5da-44d3-be87-3228f517de70	a9b479f9-eb41-4f3e-b710-346a4f7a5765	2026-01-03 20:11:19.829+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	ea2252eb-8229-4d52-9648-479058ec4334	\N	Marea importada de seguimiento 2025 (JSONL)
9f842b1e-2de9-4dde-9066-c4827c562087	927e3ed0-dafe-4c98-a281-078c64cf354f	2026-01-03 20:11:19.837+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	ea2252eb-8229-4d52-9648-479058ec4334	\N	Marea importada de seguimiento 2025 (JSONL)
ce5ae6e7-3fd0-4d3f-946d-0fce2cd7425c	aca2574c-b75a-40c6-8e11-f6ea8ebeb1c2	2026-01-03 20:11:19.845+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	ea2252eb-8229-4d52-9648-479058ec4334	\N	Marea importada de seguimiento 2025 (JSONL)
e5686970-114a-4444-881c-c9b960d7b6b8	33e149c6-2857-4cd6-8045-19407c2cfc9e	2026-01-03 20:11:19.853+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	ea2252eb-8229-4d52-9648-479058ec4334	\N	Marea importada de seguimiento 2025 (JSONL)
7c65cfb7-795d-4729-a6b1-8680e28fb66c	806ade78-064c-45c9-a36d-1fb7a2194be6	2026-01-03 20:11:19.859+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	ea2252eb-8229-4d52-9648-479058ec4334	\N	Marea importada de seguimiento 2025 (JSONL)
03ed7e23-6e18-4f8a-8fc9-860c331cf74c	e7844417-503b-4eb4-9225-af494816ebd8	2026-01-03 20:11:19.866+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	0b21451e-e14c-421e-8387-5478e7a4ad88	\N	Marea importada de seguimiento 2025 (JSONL)
7d077caf-1a43-4236-9b5f-13e913dbc76b	cddf9dcb-1e5e-4dfa-9643-566eed1461ca	2026-01-03 20:11:19.874+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	ea2252eb-8229-4d52-9648-479058ec4334	\N	Marea importada de seguimiento 2025 (JSONL)
b532270a-6e68-4057-8257-f20d133dbe16	789f57de-f4c3-4398-ace8-880584ab5ae9	2026-01-03 20:11:19.88+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	ea2252eb-8229-4d52-9648-479058ec4334	\N	Marea importada de seguimiento 2025 (JSONL)
df07d416-b242-4a22-83c2-c986a1140d47	46a335f6-9487-4ecd-831d-85ba568d7b63	2026-01-03 20:11:19.887+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	ea2252eb-8229-4d52-9648-479058ec4334	\N	Marea importada de seguimiento 2025 (JSONL)
160b9869-77e4-4da3-9e44-4d6860b89693	8e5d0022-2392-405c-a7ca-326d41aaded5	2026-01-03 20:11:19.895+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	ea2252eb-8229-4d52-9648-479058ec4334	\N	Marea importada de seguimiento 2025 (JSONL)
657b4d12-1e46-4871-aad2-dab52bd31043	9f68feda-51d8-4dcf-aa49-dba8e8a347f2	2026-01-03 20:11:19.905+00	e9809b3e-6e37-4a11-8515-43d0ae585990	CREACION	\N	ea2252eb-8229-4d52-9648-479058ec4334	\N	Marea importada de seguimiento 2025 (JSONL)
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
9d5b6f89-49d0-4c40-849a-a9114a8881dd	2021	Claudio	Noale	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	t	claudionoale@hotmail.com	Cambio de trabajo
a64fd42f-7261-48b0-ae7c-af1352d8bde1	7149	Gustavo	Cano	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	\N	\N
93e9793f-9c9d-4819-ad4e-4663a83cbae4	7562	Lucas	Bentos	\N	TECNICO	LEY MARCO	t	t	\N	\N	f	\N	\N
87c4cd3c-0d8a-4ca4-8376-0bfc4b1c8a43	7610	Raul Bernardo	Bargas Peña	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	rbbargas@gmail.com	\N
748ead96-07d8-4cac-8940-8cfad8ffd8dd	7611	Cristian Emmanuel	Cerrina	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	manucerrina2@gmail.com	\N
6ff66801-9832-4329-8deb-16a15f17b3b0	7612	Richard Javier	Espinola Gysin	\N	OBSERVADOR	1109	t	t	\N	\N	f	richardjesp@gmail.com	\N
88e889d4-c502-4686-9ea2-d14b9de39b15	7613	Federico Nicolás	Garcia	\N	OBSERVADOR	1109	t	f	\N	\N	t	fede.gaarciaa@gmail.com	Accidente en motocicleta
c5280d55-a024-4eef-a494-9dc410c48017	7616	Jorge Guillermo	Herrera	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	herrerajorgeguillermo@gmail.com	\N
ee2b64d2-fe52-4a2d-aa6d-a39bf5d10bd0	7617	Leonardo Marcos	Kren	\N	OBSERVADOR	MONOTRIBUTISTA	f	t	\N	\N	t	lmlemark@gmail.com	Licencia médica
0b7989c3-4c19-4b2f-a868-ea0507dd6558	7620	Diego Sebastian	Marchiori	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	brugmasia@hotmail.com	\N
10fce44b-0302-45be-bd51-dede19bf90f5	7621	Luis Gabriel	Martinez Tecco	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	lgmt666@hotmail.com	\N
cd62e541-8699-4e78-a979-37ab0a48feb5	7624	Teresa Beatriz	Reinaga	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	tere2361@hotmail.com	\N
2319d7d2-75f2-400f-998b-13b32a0b564c	7625	Eduardo	Silvester	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	eduwolfsilvester@hotmail.com	\N
99b520f1-a0b2-4151-bbc3-b91ff15104fd	7627	Jorge Luis	Morales	\N	OBSERVADOR	PLANTA PERMANENTE	t	t	\N	\N	f	didiinidep1980@gmail.com	\N
cabd4895-4f89-41e4-a6e5-367731c55e0a	7724	Eduardo Esteban	Aguilar	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	edu81aguilar@gmail.com	\N
7456cd76-9949-4c82-ac10-6d0a29009d71	7726	Juan José	Coppa	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	juancoppa@hotmail.com	\N
9c7fb7fc-684a-49aa-828b-87ead04ac852	7728	Adrian Pascual	Galluzzo	\N	OBSERVADOR	MONOTRIBUTISTA	f	t	\N	\N	t	apgalluzzo@hotmail.com	Jubilación
11b3358c-7d76-47dd-bb76-bc68090950f9	7729	Walter Alejandro	Glavina	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	glavinawalter@hotmail.com	\N
8fbdb915-807d-4450-a514-daf051d5710a	7730	Carlos Daniel	Herrera	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	aquimardel@gmail.com	\N
bd661490-913a-4dcb-9b42-8569b94ccdc4	7733	Maria Lucila	Maydana	\N	OBSERVADOR	MONOTRIBUTISTA	f	t	\N	\N	f	\N	\N
cee9e550-6eba-4e24-a7a5-17c8d4ff0c6b	7735	Sergio Fabian	Najle	\N	OBSERVADOR	MONOTRIBUTISTA	f	t	\N	\N	t	najlesergio@yahoo.com.ar	Licencia médica
04f48fc6-b8c1-475b-9120-ab09092881c9	7740	Leonardo Luis	Spagnuolo Rey	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	leospagnuolorey@yahoo.com.ar	\N
d2c2210c-7ed0-4ca6-a4a7-297500846c5d	7742	Héctor Luis	Teves	\N	OBSERVADOR	MONOTRIBUTISTA	f	t	\N	\N	t	hecluteves@hotmail.com	Jubilación
59d25cc8-403e-4409-9b5c-bb6564772f4b	7767	Claudio Alberto	Nadal	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	nadal-claudio@hotmail.com	\N
cdec0aa6-a7a4-4626-a6a8-b4a6b5611742	7776	Gonzalo	Troccoli	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	gtroccoli@inidep.edu.ar	\N
0bdfe245-991d-4455-89cc-a3f12d61a20e	7796	Fernando Alberto	Schwartz	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	gallococo@hotmail.com	\N
6ecf47d3-28a5-44b7-a008-9273d0cbe48e	7798	Marcelo Simón	Freyre	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	freyre.ms@gmail.com	\N
edfdb433-94bd-4b10-b860-5b833eee185e	7828	Fabian Eduardo	Desojo	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	t	pachappppp@gmail.com	Cambio de empleo a engrasador
4f89bb65-2a31-4993-9084-8c25fad01ac7	7832	Maximiliano Adrian	Godoy	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	maxigodox@gmail.com	\N
458e13a5-ad84-4a37-9baa-028fc5e9d7bd	7838	Nicolas Facundo	Staneff Rotela	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	nicolas.staneff@gmail.com	\N
bf43a85b-0ac9-4f00-a7e8-cd5fea6c4cbd	7840	Durbal	Villalba	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	villalbadurbal@gmail.com	\N
f6ff71dc-2f5d-4fa5-9639-766717c3965f	7841	Nicolas Agustin	Caballero	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	Nicck934@gmail.com	\N
fc5d8f25-2db5-4689-8b58-dbffaa6b26ed	7842	Gabriel Osvaldo Catriel	Gimenez Salinas	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	pikyred123@gmail.com	\N
50801ce5-defb-41aa-b43d-851ee3e0613f	7843	Johnatan	Challier	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	jonhychallier@gmail.com	\N
b4aa76be-d343-454b-bb9c-c78f4150f181	7844	Sebastían Roque	Garcia	\N	OBSERVADOR	MONOTRIBUTISTA	f	t	\N	\N	f	sebastianroquegarcia4@gmail.com	\N
65d614cd-8022-40bb-8765-3faa591c9cda	7845	Alexia	Aguilar	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	aguilaralexia00@gmail.com	\N
713e508e-be28-4e12-a256-2f209dfd6e0c	7846	Oriana	Retamar Mendez	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	t	orianaretamarm@gmail.com	Restricción operativa para embarque de mujeres
fd7bdec3-345f-4231-94c3-5d7d1412c0b3	7847	Gianfranco	Alvarez	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	gianalvarezobs@gmail.com	\N
31c01d59-fa0f-43c6-8ca9-54703e3556dc	7848	Diego	Gorosito	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	diegojavierg158@gmail.com	\N
3fe97e20-e070-44ad-afbd-da565632e68e	7849	Leonardo	Prado Escobar	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	t	estudioprado02@gmail.com	Inactivo según reporte
9233b7e4-ec02-4683-8caa-58a631897a9b	7850	María Laura	Monterisi	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	mlm.vlady@gmail.com	\N
42332b76-e008-4ce4-ab60-5667f208f082	7851	Alvaro	Benitez	\N	OBSERVADOR	MONOTRIBUTISTA	f	t	\N	\N	t	alvarobeni89@gmail.com	En otro trabajo
5794bb9d-2616-421d-a32e-299814440e16	7852	Camila	Corti	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f		\N
3aa4fd7e-82d6-4986-9a8e-6dbcb26fe28c	7853	Luciano	Matte Casietto	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	lucianomcassietto@hotmail.com.ar	\N
80325084-a25e-41e9-a01b-f3b2d70a3fc3	7854	Gisele	Garcia	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	t	garciagiselealejandra@gmail.com	Desempeño insuficiente reportado
196bbbc0-3afa-425a-bb90-a085cd9b4385	7855	Nicolas	Pereyra	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	nicolasagustinpereyra777@gmail.com	\N
8c3c327a-86a0-433c-8225-fe9e99eaa24e	7858	Franco	Ibarra	\N	OBSERVADOR	MONOTRIBUTISTA	t	f	\N	\N	t	francoadrianibarra@gmail.com	En otro empleo
dbadc20e-43a9-49e4-bebc-5ab9ab812a17	7859	Melisa	Garcia	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	t	melipg7@gmail.com	Restricción operativa para embarque de mujeres
a9a94140-276f-41c7-9486-f9c6621ad843	7860	Nahuel	Ramirez	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	nahuelramirezm@gmail.com	\N
97a5011b-ca79-4332-8b7b-464d7b185c72	7861	Daiana Anabella	Molina Riquelme	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
effd5fd7-7fd5-40ac-aa17-d257aed50d3e	7862	Christian Enderson	Fenco Chavesta	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
3a6134c8-2c3c-41a1-abad-741ac93b727a	7863	Daniel Enrique	Ramunno	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
6eebf5b9-ebc9-43fc-a852-f694b51606dd	7864	Manuel Agustín	Palos	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
7d123bcc-b690-4735-8faa-11f46dab670b	7865	Gabriel Alejandro	Dumrauf	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
8b780913-0405-42bf-b009-901f767149d7	7866	Francisco German	Sette	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
d06c7423-3742-4f90-a9b9-9a3006e435fd	7867	Cintia Daiana	Magrini Quiroga	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
c5a0a3c5-3069-4d5b-9f1c-979e3a20339b	7868	Lucas Oscar	Gaona	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
7a5cd199-29f3-4ad3-a24b-deec060eee5e	7869	Sergio Gastón	Frontera	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
fc13f6c2-e808-4ee8-b0f1-8eaacc3add9f	7871	Sergio Javier	Gomez Mapiz	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
a3f2f8cf-9733-46a4-8a2c-9a4f8c443c82	7872	Juan Francisco	Rodriguez Fulco	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
9ab70dad-1121-4e00-a67b-3c8ed999af01	7873	Lucas David	Carabeta	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
ae35ab61-34a4-4d3a-b77f-1c3f1e754879	7874	Morena Aylen	Ledesma	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
f9485ef5-df4e-44ff-8f54-1558aee4400a	7875	Leonardo Ezequiel	Andrade	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
a72d0d55-0586-4f11-a7ce-293fe4bd3d1b	7876	Walter Alejandro	Leon	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
278fd560-9c3a-4396-8769-c910ae407a9a	7879	Lucía	Martinez Ta	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
e62ae162-a603-4d44-bd04-cb704abd951c	7900	Paola Alejandra	Navarro Grassi	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
67c90d16-eac3-44d0-a24f-b8ac95bb1c87	8002	Julio Roberto	Sinconegui	\N	OBSERVADOR	MONOTRIBUTISTA	f	t	\N	\N	f	jrsinconegui@inidep.edu.ar	\N
ce354dd4-4a2e-4f5a-a2e1-f61ac4203c88	9442	Sebastian	Garcia	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
1fdfa01d-24c0-43b7-b0c4-955e5bdb7676	9451	Jorge Fernando	Repetto	\N	OBSERVADOR	MONOTRIBUTISTA	f	t	\N	\N	t	cotoperca23@hotmail.com	Jubilación
03bcd673-4d6e-4b2b-a4e0-30844c1fc797	9459	Raúl Antonio Ceferino	Puliafito	\N	OBSERVADOR	MONOTRIBUTISTA	f	t	\N	\N	t	raul.puliafito@gmail.com	Traslado a otro programa
2a41019f-7206-4e46-bf97-75958da33fe4	9460	Pablo Alejandro	Ramos	\N	OBSERVADOR	MONOTRIBUTISTA	f	t	\N	\N	t	pabloramos64@yahoo.com.ar	Licencia médica
7e2a574f-655f-49c6-b7cb-5db09e53df1e	9461	Alejandro José	Mazzei	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	alejandromazzei525@gmail.com	\N
7da9b5fa-dd75-49b8-82b2-f16fc7b6ba02	9465	Daniel Alejandro	Di Tullio	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	ddi@inidep.edu.ar	\N
f65ba413-ee61-4f43-a51c-822ae344a8eb	9467	Pablo Julian	Miranda	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	pablojmiranda65@gmail.com	\N
19c411b7-0221-4533-90dd-ec1fd54e684d	9471	Estanislao	Rodriguez Fulco	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	rfestanislao@gmail.com	\N
8c0214ed-61c1-43aa-a479-baad51350fae	9474	Juan Manuel	Staneff	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	juanmanuel_jotis@hotmail.com	\N
acc9f6d8-4a13-4f5a-82e1-31f7ad362951	9476	Héctor Eduardo	Vera	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	t	veraeduardo1971@gmail.com	Licencia médica
fe7f31a1-80d9-45ed-9632-feaddc01f0ed	9480	Cristian Oscar	Piriz	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	t	cristianpiriz36@gmail.com	Licencia médica
\.


--
-- Data for Name: password_reset_tokens; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.password_reset_tokens (id, token, expires_at, used, requested_ip, created_at, user_id) FROM stdin;
98ecc732-a306-4b19-863d-7767587d6ba8	e83428d379188862be1ec7d26c36d0e92ad71af14c6831c2ee9fc465fb929dbf	2026-01-03 23:32:37.019+00	f	\N	2026-01-03 23:02:37.021+00	1d334499-ea4c-43dc-9146-7e86b6833a7d
\.


--
-- Data for Name: pesquerias; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pesquerias (id, codigo, nombre, descripcion, grupo, orden, activo) FROM stdin;
32032036-1939-4612-bbbd-d7b60b7bf535	ABADEJO	Abadejo	\N	Peces	\N	t
a1a97627-e18c-42b3-b434-f22cea7119e6	ANCHOITA	Anchoíta	\N	Peces	\N	t
885b2d5d-c999-402f-85a9-f3536fd4c22b	CABALLA	Caballa	\N	Peces	\N	t
2799b5fe-a6d9-4077-a9a4-f93c49ff22a5	CALAMAR	Calamar	\N	Moluscos	\N	t
c2c3c456-5f2c-47a2-a8af-d41dc148a19f	CENTOLLA	Centolla	\N	Crustáceos	\N	t
089b0ead-176b-4e7a-b99d-5caeea74ea61	AUSTRALES	Especies australes	\N	Peces	\N	t
daccfce7-5e1e-4429-8f97-600fe78a1855	LANGOSTINO	Langostino	\N	Crustáceos	\N	t
7c95d6f8-338a-4bf6-8863-1756cd9f598f	MERLUZA_COMUN	Merluza común	\N	Peces	\N	t
f87ceb11-df61-4862-b41f-70db2096902b	MERLUZA_NEGRA	Merluza negra	\N	Peces	\N	t
7bfb912c-3ee4-426e-a976-68bbbf6bc1d4	VIEIRA	Vieira	\N	Moluscos	\N	t
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
7a9e4185-6281-4c42-b3c4-1980e6855a31	Buenos Aires	\N	\N	12	\N	f	t	\N	\N	-34.58333	-58.38334
63f569cb-fc8e-409c-be70-64fb48dd2911	Rio Grande (brasil)	\N	\N	20	\N	f	t	\N	\N	-32.13334	-52.08333
9a05fb06-0c61-494c-b1c4-a34ee61a819e	Montevideo	\N	\N	XX	\N	f	t	\N	\N	-34.9	-56.2
e3b6f937-2809-4a3e-943d-e9b576c6e0fd	Samborombon	\N	\N	21	\N	f	t	\N	\N	-35.73333	-57.31667
7ee75a76-5fa9-4063-b664-efc748076152	San Clemente	\N	\N	14	\N	f	t	\N	\N	-36.33333	-56.78333
00f40d6d-3e0f-4ae8-adac-a6cbc7ff012a	Mar Del Plata	\N	\N	1	\N	t	t	\N	\N	-38.06667	-57.55
65f3ecdb-dace-4389-b9d2-c5658532a56a	Quequen	\N	\N	2	\N	f	t	\N	\N	-38.58333	-58.7
260e778c-d7a5-4509-938b-9bd69004656f	Bahia Blanca	\N	\N	3	\N	f	t	\N	\N	-38.75	-62.16667
5c758d08-2859-44fa-b984-43e60fea506a	Bahia San Blas	\N	\N	15	\N	f	t	\N	\N	-40.55	-62.23333
bf2cad5e-9886-4737-bb0e-cb3a0376a5d9	San Antonio Oeste	\N	\N	9	\N	f	t	\N	\N	-40.73333	-64.96667
445fff6f-d830-4297-8bff-7475f1384e16	Viedma	\N	\N	22	\N	f	t	\N	\N	-40.9	-62.86666
7f1cac29-7e2c-4b6d-8447-1a5a9108fd12	Puerto Madryn	\N	\N	4	\N	f	t	\N	\N	-42.76667	-65.05
a39428a8-f7d6-4716-9c31-99556bfb37f3	Rawson	\N	\N	7	\N	f	t	\N	\N	-43.33333	-65.06667
600d861e-649d-4883-8d35-32e53ad759d3	Bahia Camarones	\N	\N	11	\N	f	t	\N	\N	-44.8	-65.73333
65f921a3-7ad7-4608-b954-4ef0568d04c0	Comod, Rivad,	\N	\N	6	\N	f	t	\N	\N	-45.88334	-67.5
a6e5c287-b920-443c-8370-19801b187334	Caleta Olivia	\N	\N	16	\N	f	t	\N	\N	-46.43333	-67.53333
9e97a6b3-cca1-4931-92e9-ab8a5e0b35e1	Deseado	\N	\N	5	\N	f	t	\N	\N	-47.76667	-65.91666
f14a58d2-8c31-400b-8396-689857422d76	San Julian	\N	\N	17	\N	f	t	\N	\N	-49.31667	-67.73333
942e847d-e8ad-41a5-824e-f74a4a2bc241	Punta Quilla	\N	\N	23	\N	f	t	\N	\N	-50.11666	-68.41666
7a725a2a-c2a9-419e-80ef-9431830f51c1	Rio Gallegos	\N	\N	19	\N	f	t	\N	\N	-51.63334	-69.2
a269cdaa-b6a8-4b05-b44a-042cd68106e4	Ushuaia	\N	\N	10	\N	f	t	\N	\N	-54.83333	-68.3
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
a9be216d-5261-4420-88d9-bf7dc1661bd7	FRESQUERO	Fresquero	\N	\N	t
76e36cfe-e917-4625-889b-96d633961480	TANGONERO	Tangonero	\N	\N	t
fa86a02c-c6bf-4615-ac50-e6a64cb929bb	CONGELADOR_MERLUCERO	Congelador Merlucero	\N	\N	t
ae0629e2-d22a-4557-8687-b3ffa6b2556e	POTERO	Potero	\N	\N	t
baef63e2-6404-4129-809c-e46df7aaf2de	PALANGRERO	Palangrero	\N	\N	t
9340c3e1-4386-4a4b-bb00-4dcf039916dd	CONGELADOR_ARRASTRERO	Congelador Arrastrero	\N	\N	t
c7afdae7-d068-45a9-a855-1011df4d2f92	CENTOLLERO	Centollero	\N	\N	t
fc8c8ee3-01dd-40b0-96f2-6b99a6643f7b	VIEIRERO	Vieirero	\N	\N	t
907fd6b2-95a4-42bf-856e-a9b0d99402ea	COSTERO	Costero	\N	\N	t
a5778547-a20e-4929-a1a6-c0aab7f0466c	INVESTIGACION	Investigación	\N	\N	t
84e1586f-ab60-4e9c-93e6-bc73183f8b27	SURIMERO	Surimero	\N	\N	t
698adf82-00c5-45bf-b669-69edf3bcfa43	RAYERO	Rayero	\N	\N	t
280a7409-6bb5-4e36-bad1-93194d72bb82	CONGELADOR_AUSTRAL	Congelador Austral	\N	\N	t
4f3ed669-a05f-4bd4-a8be-bfb4f88b54d9	CONGELADOR_GENERICO	Congelador Genérico	\N	\N	t
\.


--
-- Data for Name: transiciones_estados; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.transiciones_estados (id, id_estado_origen, id_estado_destino, accion, etiqueta, clase_boton, requiere_observaciones, activo) FROM stdin;
b93b4e3b-45ba-4e36-a1aa-f1679e78ebbc	ea2252eb-8229-4d52-9648-479058ec4334	0b21451e-e14c-421e-8387-5478e7a4ad88	REGISTRAR_INICIO	Registrar Inicio	primary	f	t
b2d0f8d2-5e28-43ee-94f1-fe0b0dba4bb0	0b21451e-e14c-421e-8387-5478e7a4ad88	e9c85d8e-268f-4598-bc6b-f9f2917be914	REGISTRAR_ARRIBO	Confirmar Arribo	primary	f	t
980b3882-b0b0-4cd7-a74e-610b1702036d	e9c85d8e-268f-4598-bc6b-f9f2917be914	b5debf35-2531-4f42-8a6a-cd295ec1fb33	RECIBIR_DATOS	Recibir Archivos	primary	f	t
0239dcd3-7b0a-4f87-b174-28b1e1796d6b	b5debf35-2531-4f42-8a6a-cd295ec1fb33	11810d0f-0cd0-4d6d-b4eb-82d8141000e5	INICIAR_VERIFICACION	Iniciar Verificación	primary	f	t
22de3e60-1d26-4a7f-8bc5-3c454579721c	11810d0f-0cd0-4d6d-b4eb-82d8141000e5	1a92188f-0134-49f5-a204-b1941caca842	ABRIR_CORRECCION	Abrir Corrección	secondary	f	t
4b91221e-a9e0-41a7-9543-9917a85f5e85	11810d0f-0cd0-4d6d-b4eb-82d8141000e5	ba3abe89-7ba1-4cd4-bd2c-8d37512dfcac	PASAR_A_INFORME	Pasar a Informe	primary	f	t
e99b2b72-5489-44b9-8e58-ee2bc796cd5e	1a92188f-0134-49f5-a204-b1941caca842	ba3abe89-7ba1-4cd4-bd2c-8d37512dfcac	FINALIZAR_CORRECCION	Finalizar Corrección	primary	f	t
0449171e-5ff6-4fb6-8a6a-359e14ea23bd	1a92188f-0134-49f5-a204-b1941caca842	16f52513-8de7-44e2-bc87-2c8fff885585	DELEGAR_EXTERNA	Derivar a Proyecto	secondary	f	t
c49af78c-6eaf-418e-a1b4-3a9323977cf6	16f52513-8de7-44e2-bc87-2c8fff885585	1a92188f-0134-49f5-a204-b1941caca842	RETORNAR_CORRECCION	Devolución Externa	primary	f	t
73be26e5-082d-41a4-8a12-602a0c4c208b	ba3abe89-7ba1-4cd4-bd2c-8d37512dfcac	2ec4b69f-5760-473c-84eb-5e3d72b868f8	ENVIAR_A_REVISION	Enviar a Revisión	primary	f	t
354d5bd3-8091-46fd-ba14-a2d04c8feb08	2ec4b69f-5760-473c-84eb-5e3d72b868f8	6df7c4fd-8134-4cd6-8867-b928bb0c0ef0	APROBAR_INFORME	Aprobar Informe	primary	f	t
c6f62be6-677f-49d5-b82a-7d08b39c6f5c	2ec4b69f-5760-473c-84eb-5e3d72b868f8	ba3abe89-7ba1-4cd4-bd2c-8d37512dfcac	RECHAZAR_INFORME	Observaciones en Informe	secondary	f	t
09d2e60b-0d18-4d88-8b4a-2d1e1fb4a4bb	6df7c4fd-8134-4cd6-8867-b928bb0c0ef0	aa64a6e6-dfd3-4af9-9c1b-31309f0ed844	INICIAR_TRAMITE	Iniciar Protocolización	primary	f	t
48bb4ffe-20ca-4328-97a7-7099c36674de	aa64a6e6-dfd3-4af9-9c1b-31309f0ed844	1617c3f4-2ae6-482a-9710-067e2d0c6e50	FINALIZAR_PROTOCOLIZACION	Finalizar Protocolización	primary	f	t
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, email, password, "fullName", "isActive", roles, "themePreference", "avatarUrl") FROM stdin;
e9809b3e-6e37-4a11-8515-43d0ae585990	admin@obs.com	$2b$10$zW81x9yNaCTKRkGJ0KwZme3sJXezj0Qwnvlz5y4d8UcOvwYNe9lXK	Administrador Sistema	t	{admin}	system	\N
1d334499-ea4c-43dc-9146-7e86b6833a7d	coordinador@obs.com	$2b$10$zW81x9yNaCTKRkGJ0KwZme3sJXezj0Qwnvlz5y4d8UcOvwYNe9lXK	Coordinador Operativo	t	{coordinador}	system	\N
1b697cb6-f5e6-4971-9b62-d04b75c138b7	tecnico@obs.com	$2b$10$zW81x9yNaCTKRkGJ0KwZme3sJXezj0Qwnvlz5y4d8UcOvwYNe9lXK	Técnico de Datos	t	{tecnico_datos}	system	\N
18f01a65-ed35-4f1c-aeed-68a1b8e1c573	asistente@obs.com	$2b$10$zW81x9yNaCTKRkGJ0KwZme3sJXezj0Qwnvlz5y4d8UcOvwYNe9lXK	Asistente Administrativo	t	{asistente_administrativo}	system	\N
2066f934-5012-41dc-b88a-e18b242c5afd	danieldt2000@hotmail.com	$2b$10$2z/Uy0X8H8IHIfMpIW921Oox.zYvY.1a44Kb59s7230/isgMUKITy	Daniel Di Tullio	t	{tecnico_datos}	system	\N
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

