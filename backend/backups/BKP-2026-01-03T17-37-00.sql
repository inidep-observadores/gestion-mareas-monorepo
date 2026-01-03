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
9bda293b-e1b2-4bd2-9b2c-d34743032f06	2	t	Red de arrastre de fondo
ebfb9c1f-7388-44b9-8ae2-3ddca21af45d	6	t	Red de arrastre de media agua
3af1aef2-5a21-4d46-a899-6e83ad38ed00	3	t	Red de lampara
621d82f7-4a4d-46f0-9364-0d119a461c7f	5	t	Espinel
0c49928c-8266-4484-bcd5-eaf614046219	4	t	Red de enmalle
7376cc8d-da08-4a9b-b16e-a44e1486c260	18	t	Red agallera de deriva
3a970316-23f2-4026-8bcc-dcc696e4f1f6	16	t	Palangre de fondo
4844aa45-ee41-4779-a357-025bf20671a9	1	t	Red de cerco
bc9f30f9-12e7-42d8-a0aa-0183e1eda629	19	t	Red Bongo 300
4f611f32-a785-4cac-b74a-0ea8362fbe71	20	t	Red Bongo 500
54bd9629-c4f0-4bcd-a7bc-4c5e341fb2ce	21	t	Red Nakthai
042605d1-408c-47f6-8d81-4d703986ee88	22	t	Red Isaac-Kidd
a8030ac9-bb9f-4e5d-90e0-7bf96384c024	7	t	Rastra
1bff17a8-51e6-498a-a572-80cd992295de	8	t	Nasa
34cd73c4-c737-4650-abb9-1ed187e549a0	9	t	Linea
81781c22-03e7-44ce-82be-83196bcb9ee5	10	t	Raño
53e0c737-35f9-4667-bf7a-8f1da22391e0	11	t	Poteras
d63fbb9c-d0fb-40d3-8fc1-cb1d606a1ad6	12	t	Red de fondeo
3d4b058b-d293-49cb-9018-8e8e99675548	13	t	Trampa centollera
8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	14	t	Red de arrastre de fondo con tangones
8d0dd87a-119f-4ec2-a49c-5eabba122c2f	32	t	Currican
668a5dda-5bc2-414d-826d-0ba96fda1a75	15	t	Red de arrastre de fondo en pareja
061f0f11-210d-4b53-b207-015cd22db819	80	t	Otros
39ff1464-1560-4f44-9cfc-65d40b55e16d	0	t	Sin Especificar
80271cf0-e686-4e1b-83ab-5bb6651065b9	90	t	No Identificado
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
69579cb8-694d-4def-a89f-688e6690b24b	ANITA	3	\N	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	\N	\N	\N	24918e15-e968-484f-b31e-dc786b5f9ec2	SOLIMENO	Mar del Plata			\N		\N	\N		t	\N	\N	\N
f019182d-9d90-48a0-94e0-ed403c00ed03	ANGELUS	01953	1087	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	52.60	1337	26cb8962-0318-4dfe-a961-1b84a6ce6302	PESQUERA CRUZ DEL SUR  S.A.	Ciudad Autónoma de Buenos Aires		011-4784-1760	\N		\N	\N		t	\N	\N	\N
268edf53-c4b7-4753-a1a3-554f1fddca8f	ARGENOVA XXII	02714	2713	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	40	37.70	663	f05d47aa-ffad-4c48-99f2-39015dc0159a	ARGENOVA  S.A.	Puerto Deseado	4808331/4808332	0297- 487-0550  (447-2818  Com. Riv )	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
53958a06-ae54-4965-be5b-05933b5145a2	DON GAETANO	071	1430	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	32.10	889	24918e15-e968-484f-b31e-dc786b5f9ec2	LINEAERRE  S.A.	Mar del Plata		480-0312	\N		\N	\N		t	\N	\N	\N
ccc3eb26-c866-4f4c-aa75-f204665a6be4	BEAGLE I	6052	1207	6a95076f-aec1-4941-b231-92dfbc802cb7	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	60	59.90	2369	26cb8962-0318-4dfe-a961-1b84a6ce6302	YUKEN  S.A.	Ciudad Autónoma de Buenos Aires	4891553-154179360-154179860-154179062	011-5279-1302 / 5236-6069	\N	agenciasmiriglio@speedy.com.ar	\N	\N	Agencia Maritima Smiriglio	t	\N	\N	\N
9beaad91-e7e9-424b-b2db-6ea45f60a3e3	CABO SAN JUAN	023	\N	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	\N	\N	a48e3d60-bea0-4828-8099-3debb447f631	ALPESCA  S.A.	Puerto Madryn		0280-447-4958 / 45-1069	\N		\N	\N		t	\N	\N	\N
e21d2a77-7073-4f45-a302-d4efcd0e4f10	CAMERIGE	01406	1252	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	27.90	652	24918e15-e968-484f-b31e-dc786b5f9ec2	PESQUERA  MARGARITA  S.A.	Mar del Plata	4891553-154179360-154179860-154179062	489-4645   /   489-2946	\N	agenciasmiriglio@speedy.com.ar	\N	\N	Agencia Maritima SMIRIGLIO	t	\N	\N	\N
ec46db26-bf55-45c8-a429-c8a515a0e474	CRISTO REDENTOR	01185	1374	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	31.00	642	f05d47aa-ffad-4c48-99f2-39015dc0159a	PESQUERA DESEADO  S.A.	Puerto Deseado		0297-487-0884 / 0327 / 2407	\N		\N	\N		t	\N	\N	\N
9686c4a0-b260-4887-815d-93084c7ec6a7	DON RAIMUNDO	01431	1463	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	10	25.60	624	24918e15-e968-484f-b31e-dc786b5f9ec2	DON RAIMUNDO S.R.L.	Mar del Plata		489-3780	\N		\N	\N		t	\N	\N	\N
cc667a86-567a-4c2d-9d57-d6ec5554d839	El marisco s.a	02070	\N	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	\N	\N	a48e3d60-bea0-4828-8099-3debb447f631	FISHING WORLD  S.A.	Puerto Madryn	4800005	0280-445-6533	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
16325e14-390b-45ef-9e96-efdf445fe843	FEIXA	0529	1592	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	41.50	1101	24918e15-e968-484f-b31e-dc786b5f9ec2	ANTONIO BARILLARI  S.A.	Mar del Plata		481-1173  / 489-0872	\N		\N	\N		t	\N	\N	\N
0964131d-ec79-411c-b9a9-4e367524790d	FELIX AUGUSTO	0581	1595	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	27.80	601	a48e3d60-bea0-4828-8099-3debb447f631	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
4300715a-da7c-4341-a92e-68a52ca9f4a8	LETARE	0245	\N	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	\N	\N	24918e15-e968-484f-b31e-dc786b5f9ec2	LUIS SOLIMENO e HIJOS  S.A.	Mar del Plata		489-3030	\N		\N	\N		t	\N	\N	\N
4537ab7d-441d-4b28-9381-13a853e4f255	ILLEX I	125	\N	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	\N	\N	26cb8962-0318-4dfe-a961-1b84a6ce6302	ILLEX  S.A.	Ciudad Autónoma de Buenos Aires	4808331/4808332	011-4393-6431	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
42b824d8-5a67-4f4f-87bb-7f8717328062	MADRE INMACULADA	2378	1916	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	62.80	1852	24918e15-e968-484f-b31e-dc786b5f9ec2	ANTONIO BALDINO e HIJOS  S.A. (Saladero)	Mar del Plata		489-6522  /489-0423	\N		\N	\N		t	\N	\N	\N
8e2529f7-cb8e-4379-ab4a-ecae6366d931	MARGOT	0360	1976	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	58.75	1481	24918e15-e968-484f-b31e-dc786b5f9ec2	GIORNO  S.A.	Mar del Plata	4800005	410-0051 / 0057	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
3e0b8dec-6531-48a0-9347-b687e13e6fa1	MILLENNIUM	0466	2046	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	55.05	1329	26cb8962-0318-4dfe-a961-1b84a6ce6302	PESQUERA CRUZ DEL SUR  S.A.	Ciudad Autónoma de Buenos Aires		011-4784-1760	\N		\N	\N		t	\N	\N	\N
f6a5dd08-2559-4ef3-99ef-2ec5f9cd2b98	MISS PATAGONIA	0555	2055	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	28.20	667	24918e15-e968-484f-b31e-dc786b5f9ec2	PESQUERA VERAZ  S.A.	Mar del Plata	4805743	489-4624 / 489-0314 (astillero)	\N	agenciadiyorio@hotmail.com -joseph@hotmail.com	\N	\N	Agencia Di Yorio	t	\N	\N	\N
c8ba810e-6290-44fe-a200-a3565214934c	PATAGONIA	0284	2196	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	30.95	660	24918e15-e968-484f-b31e-dc786b5f9ec2	LUIS SOLIMENO e HIJOS  S.A.	Mar del Plata		489-3030	\N		\N	\N		t	\N	\N	\N
f69e8d4e-f7d9-4853-88b1-574529716fdd	REYES DEL MAR II	0408	\N	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	\N	\N	26cb8962-0318-4dfe-a961-1b84a6ce6302	AGUA MARINA  S.A.	Ciudad Autónoma de Buenos Aires		011-4342-0605 / 5656 / 1709	\N		\N	\N		t	\N	\N	\N
978a06ff-7da9-42b8-aa6a-8de120b96f68	SIRIUS II	0936	2489	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	59.25	1289	24918e15-e968-484f-b31e-dc786b5f9ec2	EL MARISCO  S.A.	Mar del Plata	4890960	489-0384	\N	agencia@maritimavidal.com.ar	\N	\N	Agencia Maritima Vidal	t	\N	\N	\N
2247077e-f63e-4e21-83be-e104a5a68405	Nº 606 TAE BAEK	02361	2148	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	55.22	1036	26cb8962-0318-4dfe-a961-1b84a6ce6302	ESAMAR  S.A.	Ciudad Autónoma de Buenos Aires		011-4393-8431	\N		\N	\N	54 – 9 - 1141714381	t	\N	\N	\N
561fc0ef-e528-40cb-944b-99edf1812eb1	FONSECA	0920	1610	6a95076f-aec1-4941-b231-92dfbc802cb7	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	60	62.40	2003	24918e15-e968-484f-b31e-dc786b5f9ec2	FONSECA  S.A.	Mar del Plata	4891553-154179360-154179860-154179062	489-4645	\N	agenciasmiriglio@speedy.com.ar	\N	\N	Agencia Maritima Smiriglio	t	\N	\N	\N
5030e999-5fef-4a22-8b30-e47d252fee12	PATAGONIA BLUES	02176	2199	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	64.45	1776	26cb8962-0318-4dfe-a961-1b84a6ce6302	PESQUERA CRUZ DEL SUR  S.A.	Ciudad Autónoma de Buenos Aires		011-4784-1760	\N		\N	\N		t	\N	\N	\N
f06b5042-8a32-4e93-ae93-4bc56e984afa	RYOUN MARU N° 17	JA06-03	\N	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	\N	\N	26cb8962-0318-4dfe-a961-1b84a6ce6302	BAHIA GRANDE  S.A.	Ciudad Autónoma de Buenos Aires	4891553-154179360-154179860-154179062	011-5272-0850 / 5254-1133	\N	agenciasmiriglio@speedy.com.ar	\N	\N	Agencia Maritima Smiriglio	t	\N	\N	\N
cc66dd7e-d3fe-4e19-b353-21bf24d6a535	7 de Diciembre	TEMP-0001	1013	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	27.20	521	24918e15-e968-484f-b31e-dc786b5f9ec2		Mar del Plata	4895032		\N	operacionesconsultoramaritima@gmail.com	\N	\N	Consultora Maritima	t	\N	\N	\N
ac52fda9-c96e-4ec6-8bff-418fec142293	ACRUX	03086	0	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	28.00	0	24918e15-e968-484f-b31e-dc786b5f9ec2	DE ANGELIS Y LOGGHE S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
31ef94c9-f851-49f4-8650-c1077a529e13	ALDEBARAN	01741	1038	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	26.42	426	24918e15-e968-484f-b31e-dc786b5f9ec2	PESQUERA SAN ROQUE	Mar del Plata		480-0573	\N		\N	\N		t	\N	\N	\N
ed5091ad-47c2-435e-9e6a-ab06638012bd	ALTALENA	0181	1051	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	55.80	1350	24918e15-e968-484f-b31e-dc786b5f9ec2	MARONTI  S.A.	Mar del Plata	4800005		\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi	t	\N	\N	\N
1e005d18-4640-4f4c-90aa-92fc86cd802f	ALVAREZ ENTRENA I	02454	1055	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	39.43	988	a48e3d60-bea0-4828-8099-3debb447f631	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
541bbe2a-82dd-4d70-8c0a-7bd01f93c472	ALVAREZ ENTRENA II	02465	1056	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	39.50	988	a48e3d60-bea0-4828-8099-3debb447f631	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
ed178c99-75b3-409b-b788-62858c896076	ALVAREZ ENTRENA III	02379	\N	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	\N	\N	a48e3d60-bea0-4828-8099-3debb447f631	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
7c5aeaea-8c83-48fd-9f66-ade9dc729031	BAFFETTA	02635	0	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	19.45	295	a48e3d60-bea0-4828-8099-3debb447f631	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
e109166e-70c4-4c0e-b5f7-809a68e45139	ALVAREZ ENTRENA VI	01	2774	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	30.50	1033	a48e3d60-bea0-4828-8099-3debb447f631	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
c6e5420c-4bb2-4425-bf1c-c91bc1902eb3	AMBITION	01324	\N	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	\N	\N	24918e15-e968-484f-b31e-dc786b5f9ec2	PESQUERA TRES MARIAS  S.A.	Mar del Plata		480-0336	\N		\N	\N		t	\N	\N	\N
f4666b0c-bbaa-476f-8031-8560e42aa240	ANABELLA  M	0175	\N	6a95076f-aec1-4941-b231-92dfbc802cb7	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	60	\N	\N	a48e3d60-bea0-4828-8099-3debb447f631	PESCAPUERTA ARGENTINA  S.A.	Puerto Madryn		0280-445-4407	\N		\N	\N		t	\N	\N	\N
5268e0ed-a3df-4e0d-9507-1ceb2814a9c3	ANDRES JORGE	1065	2760	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	50.10	1102	24918e15-e968-484f-b31e-dc786b5f9ec2	MARONTI  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
242a50e7-56d1-4da0-af7c-b918384c6799	ANITA ALVAREZ	02138	\N	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	\N	\N	a48e3d60-bea0-4828-8099-3debb447f631	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
f31753e3-028e-48c3-84f7-e613b8206325	ANTARTIC  I	0232	\N	d2217eec-a161-4143-9a47-007bc8afc75e	3a970316-23f2-4026-8bcc-dcc696e4f1f6	573af89c-fbee-4643-b922-7b69926c208d	60	\N	\N	26cb8962-0318-4dfe-a961-1b84a6ce6302	ESTREMAR  S.A.	Ciudad Autónoma de Buenos Aires		011-6533-7853 / 4345-1102	\N		\N	\N		t	\N	\N	\N
8377a370-b741-42db-a2cf-08883509c286	ANTARTIC II	0263	\N	d2217eec-a161-4143-9a47-007bc8afc75e	3a970316-23f2-4026-8bcc-dcc696e4f1f6	573af89c-fbee-4643-b922-7b69926c208d	60	\N	\N	26cb8962-0318-4dfe-a961-1b84a6ce6302	ESTREMAR  S.A.	Ciudad Autónoma de Buenos Aires		011-6533-7853 / 4345-1102	\N		\N	\N		t	\N	\N	\N
8ec0e3eb-d414-4b81-98d2-4b9d0ead02d3	ANTARTIC III	0262	\N	d2217eec-a161-4143-9a47-007bc8afc75e	3a970316-23f2-4026-8bcc-dcc696e4f1f6	573af89c-fbee-4643-b922-7b69926c208d	60	\N	\N	26cb8962-0318-4dfe-a961-1b84a6ce6302	ESTREMAR  S.A.	Ciudad Autónoma de Buenos Aires		011-6533-7853 / 4345-1102	\N		\N	\N		t	\N	\N	\N
166ad797-e12a-4240-8cc4-c46b3625f943	ANTARTIDA	0678	\N	6a95076f-aec1-4941-b231-92dfbc802cb7	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	60	\N	\N	a48e3d60-bea0-4828-8099-3debb447f631	IBERCONSA  DE ARGENTINA  S.A.	Puerto Madryn	4891227	0280-445-4324	\N	serviciosmaritimosmdq@gmail.com	\N	\N	Servicio Maritimo Integral	t	\N	\N	\N
8f3c5531-b5cb-49ce-be04-68b051c7f95a	ANTONINO	0877	1099	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	27.60	541	24918e15-e968-484f-b31e-dc786b5f9ec2	AGLIPESCA  S.A.	Mar del Plata		480-2886	\N		\N	\N		t	\N	\N	\N
1393a41f-760d-43fc-8f8d-4e6d19863911	ANTONIO ALVAREZ	01429	1100	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	36.60	1168	a48e3d60-bea0-4828-8099-3debb447f631	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
c6f1e498-48ed-4977-9760-7537172fac84	API II	0679	\N	6a95076f-aec1-4941-b231-92dfbc802cb7	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	60	\N	\N	a48e3d60-bea0-4828-8099-3debb447f631	IBERCONSA  DE ARGENTINA  S.A.	Puerto Madryn		0280-445-4324	\N		\N	\N		t	\N	\N	\N
97abb628-e5e5-4387-8114-4e03c3133277	API IV	0680	\N	6a95076f-aec1-4941-b231-92dfbc802cb7	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	60	\N	\N	a48e3d60-bea0-4828-8099-3debb447f631	IBERCONSA  DE ARGENTINA  S.A.	Puerto Madryn		0280-445-4324	\N		\N	\N		t	\N	\N	\N
ab89157d-b0fa-4d0f-945e-e67cc5ce7955	API V	02781	2711	6a95076f-aec1-4941-b231-92dfbc802cb7	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	60	77.40	2960	a48e3d60-bea0-4828-8099-3debb447f631	IBERCONSA  DE ARGENTINA  S.A.	Puerto Madryn		0280-445-4324	\N		\N	\N		t	\N	\N	\N
20155084-67fe-4b08-9e57-a7c8599b2f40	API VI	02812	2734	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	40	36.35	1201	a48e3d60-bea0-4828-8099-3debb447f631	IBERCONSA  DE ARGENTINA  S.A.	Puerto Madryn		0280-445-4324	\N		\N	\N		t	\N	\N	\N
285883e4-219f-4ad5-bcae-71ea8ab7d5c5	API VII	03081	2777	6a95076f-aec1-4941-b231-92dfbc802cb7	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	60	72.20	0	a48e3d60-bea0-4828-8099-3debb447f631	IBERCONSA  DE ARGENTINA  S.A.	Puerto Madryn		0280-445-4324	\N		\N	\N		t	\N	\N	\N
0edec4c3-de59-407b-aea2-9c410283ef5e	ARBUMASA X	6183	1114	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	35.30	1087	f05d47aa-ffad-4c48-99f2-39015dc0159a	ARBUMASA  S.A.	Puerto Deseado		0297-487-2807 / 444-5338 / 444-1201	\N		\N	\N		t	\N	\N	\N
e20881d1-0845-433f-87b8-42a97a63c732	ARBUMASA XIX	06440	1117	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	36.40	870	f05d47aa-ffad-4c48-99f2-39015dc0159a	ARBUMASA  S.A.	Puerto Deseado		0297-487-2807 / 444-5338 / 444-1201	\N		\N	\N		t	\N	\N	\N
4fb45bd9-85ac-4965-8319-e723e91572fb	ARBUMASA  XVII	0216	\N	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	\N	\N	f05d47aa-ffad-4c48-99f2-39015dc0159a	ARBUMASA  S.A.	Puerto Deseado		0297-487-2807 / 444-5338 / 444-1201	\N		\N	\N		t	\N	\N	\N
4b82194a-5761-49e7-bff0-215e11eabced	ARBUMASA XIV	0213	1116	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	36.40	1047	f05d47aa-ffad-4c48-99f2-39015dc0159a	ARBUMASA  S.A.	Puerto Deseado		0297-487-2807 / 444-5338 / 444-1201	\N		\N	\N		t	\N	\N	\N
21891799-0013-4119-b39d-4ce7652ab8a4	ARBUMASA XV	214	1118	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	36.40	870	\N	ARBUMASA  S.A.				\N		\N	\N		t	\N	\N	\N
157a43d0-3ff1-4ca2-9017-1bfc357d57d4	ARBUMASA XVI	0215	1119	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	36.40	1047	f05d47aa-ffad-4c48-99f2-39015dc0159a	ARBUMASA  S.A.	Puerto Deseado		0297-487-2807 / 444-5338 / 444-1201	\N		\N	\N		t	\N	\N	\N
de390f1c-a412-4668-9ca1-229ed68e94c1	ARBUMASA XVIII	0217	1121	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	36.40	870	f05d47aa-ffad-4c48-99f2-39015dc0159a	ARBUMASA  S.A.	Puerto Deseado	4893758	0297-487-2807 / 444-5338 / 444-1201	\N	miguel-visoso@hotmail.com	\N	\N	Agencia Maritima Solvox	t	\N	\N	\N
e25c1332-ddf2-4679-aa48-9dae631802f2	ARBUMASA XXIX	02561	1126	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	65.60	1776	24918e15-e968-484f-b31e-dc786b5f9ec2	BAL - FISH  S.A.	Mar del Plata		489-6522	\N		\N	\N		t	\N	\N	\N
5d8740bf-61c0-410f-b17f-62f394ead793	ARBUMASA XXVI	01958	1127	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	62.80	2403	f05d47aa-ffad-4c48-99f2-39015dc0159a	ARBUMASA  S.A.	Puerto Deseado	4893758	0297-487-2807 / 444-5338 / 444-1201	\N	miguel-visoso@hotmail.com	\N	\N	Agencia Maritima Solvox	t	\N	\N	\N
97745923-decb-4d3f-a2fa-7627baddf7bd	ARBUMASA XXVII	02057	1128	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	64.21	1154	24918e15-e968-484f-b31e-dc786b5f9ec2	BAL - FISH  S.A.	Mar del Plata		489-6522	\N		\N	\N		t	\N	\N	\N
fb8399c6-65e2-4b91-b66f-ebdb6fa5173c	ARBUMASA XXVIII	02569	1129	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	64.40	1776	f05d47aa-ffad-4c48-99f2-39015dc0159a	ARBUMASA  S.A.	Puerto Deseado		0297-487-2807 / 444-5338 / 444-1201	\N		\N	\N		t	\N	\N	\N
0c4be028-f1c0-4598-89d1-3ae0de3994bb	ARCANGEL	79	\N	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	\N	\N	24918e15-e968-484f-b31e-dc786b5f9ec2	CALME  S.A.	Mar del Plata		480-3545	\N		\N	\N		t	\N	\N	\N
74c198ca-5a8a-4eee-85eb-856d260ec42b	ARESIT	02265	1134	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	36.26	1085	a48e3d60-bea0-4828-8099-3debb447f631	HARENGUS  S.A.	Puerto Madryn	4808331/4808332	0280-445-0822	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
d40db78a-e15f-4706-a040-14dcc547838a	ARGENOVA I	02180	1137	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	35.00	655	f05d47aa-ffad-4c48-99f2-39015dc0159a	ARGENOVA  S.A.	Puerto Deseado	4808331/4808332	0297- 487-0550  (447-2818  Com. Riv )	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
8018a66f-49f8-42a0-9324-074a801c3635	ARGENOVA IV	02157	1140	\N	\N	\N	0	36.26	675	f05d47aa-ffad-4c48-99f2-39015dc0159a	MAR DE LAS PALMAS  S.A.	Puerto Deseado	4808331/4808332	0297-487-2112	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
741c59ed-8911-471b-88a1-31c1596b5ccd	ARGENOVA X	02329	1146	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	32.50	550	f05d47aa-ffad-4c48-99f2-39015dc0159a	ARGENOVA  S.A.	Puerto Deseado	4808331/4808332	0297- 487-0550  (447-2818  Com. Riv )	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
6f6b0636-d40a-4e48-bac3-2d50514cfae3	ARGENOVA XI	02199	\N	d2217eec-a161-4143-9a47-007bc8afc75e	3a970316-23f2-4026-8bcc-dcc696e4f1f6	573af89c-fbee-4643-b922-7b69926c208d	60	\N	\N	f05d47aa-ffad-4c48-99f2-39015dc0159a	ARGENOVA  S.A.	Puerto Deseado	4808331/4808332	0297- 487-0550  (447-2818  Com. Riv )	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
c2f6e135-2553-4a11-9bd1-df7416465dbd	ARGENOVA XXI	02661	2704	975bf25c-1d6d-4101-9c5d-abe95e0a6978	9bda293b-e1b2-4bd2-9b2c-d34743032f06	a05ae304-2d0e-4e29-a6f3-fa7372a41c97	60	55.80	1826	f05d47aa-ffad-4c48-99f2-39015dc0159a	ARGENOVA  S.A.	Puerto Deseado	4808331/4808332	0297- 487-0550  (447-2818  Com. Riv )	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
f92199a7-6c9d-4a0f-8f2c-bd0aeda4d0e3	CABO DOS BAHIAS	02483	\N	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	\N	\N	a48e3d60-bea0-4828-8099-3debb447f631	ALPESCA  S.A.	Puerto Madryn		0280-447-4958 / 45-1069	\N		\N	\N		t	\N	\N	\N
184de845-e331-4aee-9860-410d3495cd90	ANA III	278	1069	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	19.95	443	a48e3d60-bea0-4828-8099-3debb447f631	POSEIDON  S.A.	Puerto Madryn		0280-445-7786	\N		\N	\N		t	\N	\N	\N
ef9cc61c-ec4b-484c-b0be-31d8c49f0572	ARGENOVA XXIV	02752	2731	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	38.80	675	f05d47aa-ffad-4c48-99f2-39015dc0159a	ARGENOVA  S.A.	Puerto Deseado	4808331/4808332	0297- 487-0550  (447-2818  Com. Riv )	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
7f1ddf72-8af8-45c0-a9d0-c85b7df118a8	ARGENOVA XXV	028011	2740	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	39.70	859	f05d47aa-ffad-4c48-99f2-39015dc0159a	ARGENOVA  S.A.	Puerto Deseado	4808331/4808332	0297- 487-0550  (447-2818  Com. Riv )	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
98f83cf3-38d6-4cec-8fe3-8f042a97353d	ARGENOVA XXVI	02849	2739	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	37.15	1086	f05d47aa-ffad-4c48-99f2-39015dc0159a	ARGENOVA  S.A.	Puerto Deseado	4808331/4808332	0297- 487-0550  (447-2818  Com. Riv )	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
c0618cef-3541-422a-94d8-ec203c06b047	ARGENOVA II	02177	1138	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	38.50	1168	f05d47aa-ffad-4c48-99f2-39015dc0159a	ARGENOVA  S.A.	Puerto Deseado	4808331/4808332	0297- 487-0550  (447-2818  Com. Riv )	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
895e96da-cce8-46b3-9585-962509c8d305	ARGENOVA III	02156	\N	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	\N	\N	f05d47aa-ffad-4c48-99f2-39015dc0159a	ARGENOVA  S.A.	Puerto Deseado		0297- 487-0550  (447-2818  Com. Riv )	\N		\N	\N		t	\N	\N	\N
07819e69-9bef-4f18-b75e-915af2a4c818	ARGENOVA IX	02328	1141	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	32.50	550	f05d47aa-ffad-4c48-99f2-39015dc0159a	ARGENOVA  S.A.	Puerto Deseado	4808331/4808332	0297- 487-0550  (447-2818  Com. Riv )	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
976e0d64-6188-4cdc-a318-499719c2ef64	ARGENOVA XII	0199	\N	d2217eec-a161-4143-9a47-007bc8afc75e	3a970316-23f2-4026-8bcc-dcc696e4f1f6	573af89c-fbee-4643-b922-7b69926c208d	60	\N	\N	f05d47aa-ffad-4c48-99f2-39015dc0159a	ARGENOVA  S.A.	Puerto Deseado	4808331/4808332	0297- 487-0550  (447-2818  Com. Riv )	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
c8566083-19f6-447e-a154-450c44a0cb8f	ARGENOVA XIV	0197	1149	d2217eec-a161-4143-9a47-007bc8afc75e	3a970316-23f2-4026-8bcc-dcc696e4f1f6	573af89c-fbee-4643-b922-7b69926c208d	60	52.30	1352	f05d47aa-ffad-4c48-99f2-39015dc0159a	ARGENOVA  S.A.	Puerto Deseado	4808331/4808332	0297- 487-0550  (447-2818  Com. Riv )	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
2a63c8e9-581b-483a-879f-0d45d4f8473b	ARGENOVA XV	0198	\N	d2217eec-a161-4143-9a47-007bc8afc75e	3a970316-23f2-4026-8bcc-dcc696e4f1f6	573af89c-fbee-4643-b922-7b69926c208d	60	\N	\N	f05d47aa-ffad-4c48-99f2-39015dc0159a	ARGENOVA  S.A.	Puerto Deseado	4800274	0297- 487-0550  (447-2818  Com. Riv )	\N	amalfitanoycia@hotmail.com	\N	\N	Agencia Maritima Almafitano	t	\N	\N	\N
3e4e84f0-f6c6-4d19-8e67-57df361f912a	ARGENTINO	0142	1157	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	33.77	1001	24918e15-e968-484f-b31e-dc786b5f9ec2	PESQUERA VERAZ  S.A.	Mar del Plata		489-4624 / 489-0314 (astillero)	\N		\N	\N		t	\N	\N	\N
2e0a68ab-83b8-44f8-80fb-7e5ea613bbea	ARKOFISH	0236	\N	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	\N	\N	a48e3d60-bea0-4828-8099-3debb447f631	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
cd7921fb-755f-40d7-8195-d11f623bcce8	ARKOFISH I	6004	\N	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	\N	\N	a48e3d60-bea0-4828-8099-3debb447f631	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
8ca5e62c-ca34-4317-a408-58ffa20061f5	ARRUFO	0540	1165	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	39.16	1102	24918e15-e968-484f-b31e-dc786b5f9ec2	LUIS SOLIMENO e HIJOS  S.A.	Mar del Plata		489-3030	\N		\N	\N		t	\N	\N	\N
6f54d4d3-437c-46a4-8721-600a588728d5	ASUDEPES II	6363	\N	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	\N	\N	26cb8962-0318-4dfe-a961-1b84a6ce6302	ASUDEPES  S.A.	Ciudad Autónoma de Buenos Aires		011-4383-9756	\N		\N	\N		t	\N	\N	\N
d4dbff0a-6eaf-4fcc-a7be-c88763ff74e1	ASUDEPES III	6062	\N	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	\N	\N	26cb8962-0318-4dfe-a961-1b84a6ce6302	ASUDEPES  S.A.	Ciudad Autónoma de Buenos Aires		011-4383-9756	\N		\N	\N		t	\N	\N	\N
1e28bd98-19b3-4e8b-9ff6-31d95dbd2712	ATLANTIC EXPRESS	02936	2727	fec3d722-78a4-4209-a6d3-e247c197885a	3d4b058b-d293-49cb-9018-8e8e99675548	b5066e3d-aff4-484a-b1ad-a45a57700aeb	30	53.70	3426	24918e15-e968-484f-b31e-dc786b5f9ec2	WANCHESE ARGENTINA  S.A.	Mar del Plata		489-1236	\N		\N	\N		t	\N	\N	\N
c7464144-ed02-46ec-888d-a50bfd4ccf8c	ATLANTIC SURF I	0350	\N	2966881e-e368-4b60-958d-683c71ed8609	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	9d02d029-f003-41b6-89de-0eea18b2d4e4	40	\N	\N	24918e15-e968-484f-b31e-dc786b5f9ec2	GLACIAR PESQUERA  S.A.	Mar del Plata	4890960	492-2216	\N	agencia@maritimavidal.com.ar	\N	\N	Agencia Maritima Vidal	t	\N	\N	\N
21f78c2d-2475-4c14-a29a-690be6abc768	ATLANTIC SURF III	02030	1176	2966881e-e368-4b60-958d-683c71ed8609	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	9d02d029-f003-41b6-89de-0eea18b2d4e4	60	49.60	3020	24918e15-e968-484f-b31e-dc786b5f9ec2	GLACIAR PESQUERA  S.A.	Mar del Plata	4800274	492-2216	\N	amalfitanoycia@hotmail.com	\N	\N	Agencia Maritima Almafitano	t	\N	\N	\N
81723a1f-7293-4231-ab06-519cdfcfad2e	ATREVIDO	0145	1180	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	32.50	901	24918e15-e968-484f-b31e-dc786b5f9ec2	PESQUERA VERAZ  S.A.	Mar del Plata	4800005	489-4624 / 489-0314 (astillero)	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
8fbc0800-2efd-465d-bf3f-48909f0b0e04	AURORA	02581	1183	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	67.55	1776	26cb8962-0318-4dfe-a961-1b84a6ce6302	KALEU KALEU  S.A.	Ciudad Autónoma de Buenos Aires		011-3220-2130  / 5093-1215	\N		\N	\N		t	\N	\N	\N
168193eb-ae46-4627-9978-68fa1d4b78ae	BAHIA DESVELOS	0665	1194	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	37.05	791	26cb8962-0318-4dfe-a961-1b84a6ce6302	PESQUERA SANTA CRUZ  S.A.	Ciudad Autónoma de Buenos Aires		011-4305-4706	\N		\N	\N		t	\N	\N	\N
e208d92a-fe48-4478-af65-5e56274f6273	BELVEDERE	01398	1210	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	26.50	624	24918e15-e968-484f-b31e-dc786b5f9ec2	PRINMAR  S.A. Buque Motor Belvedere	Mar del Plata		480-0883	\N		\N	\N		t	\N	\N	\N
1aecadd3-9b57-49b1-a307-af344b630706	BOGAVANTE SEGUNDO	02994	2743	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	37.45	867	a48e3d60-bea0-4828-8099-3debb447f631	IBERCONSA  DE ARGENTINA  S.A.	Puerto Madryn		0280-445-4324	\N		\N	\N		t	\N	\N	\N
10d65e48-7a8b-47ea-98fa-f42678e27019	BONFIGLIO	01234	\N	15652b63-0efc-4059-ad8a-36de68d64a35	9bda293b-e1b2-4bd2-9b2c-d34743032f06	\N	10	\N	\N	24918e15-e968-484f-b31e-dc786b5f9ec2	COSTA BRAVA  S.A.	Mar del Plata		489-7538	\N		\N	\N		t	\N	\N	\N
a5f8485a-584c-4615-93ca-753b65fffaba	BORRASCA	01095	1218	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	39.16	1083	24918e15-e968-484f-b31e-dc786b5f9ec2	LUIS SOLIMENO e HIJOS  S.A.	Mar del Plata		489-3030	\N		\N	\N		t	\N	\N	\N
b628ee54-a231-44b2-bda8-a527161c74bb	BOUCIÑA	01637	1221	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	0.00	0	24918e15-e968-484f-b31e-dc786b5f9ec2	CALME  S.A.	Mar del Plata	4800005	480-3545	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
77b93d28-467a-4c9f-9f09-e156e0281b48	BUENA PESCA	01475	2717	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	39.10	1479	24918e15-e968-484f-b31e-dc786b5f9ec2	PEDRO MOSCUZZA e HIJOS  S.A.	Mar del Plata		489-7287	\N		\N	\N		t	\N	\N	\N
a6aab869-476e-431b-b563-76e7dae249b3	CABO BUEN TIEMPO	025	\N	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	\N	\N	a48e3d60-bea0-4828-8099-3debb447f631	ALPESCA  S.A.	Puerto Madryn		0280-447-4958 / 45-1069	\N		\N	\N		t	\N	\N	\N
f1cc07d5-77c9-4ae3-84fa-b834ef6c6612	CABO BUENA ESPERANZA	02482	\N	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	\N	\N	24918e15-e968-484f-b31e-dc786b5f9ec2	UNIVERSAL PESQUERA  SRL	Mar del Plata		489-0352	\N		\N	\N		t	\N	\N	\N
4764761d-70fd-41a2-bdce-d758591a7754	CABO DE HORNOS	01537	\N	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	\N	\N	24918e15-e968-484f-b31e-dc786b5f9ec2	MILANI Y PATANE  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
74343aa0-2254-4047-8acc-7a73f9c59548	ARGENOVA XXIII	02713	2707	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	37.19	678	f05d47aa-ffad-4c48-99f2-39015dc0159a	ARGENOVA  S.A.	Puerto Deseado	4808331/4808332	0297- 487-0550  (447-2818  Com. Riv )	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
b76903d6-16c8-4ab2-8191-d48b84891f96	CABO TRES PUNTAS	01483	1242	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	31.43	721	24918e15-e968-484f-b31e-dc786b5f9ec2	OSTRAMAR  S.A.	Mar del Plata		489-1959	\N		\N	\N		t	\N	\N	\N
585912d8-9a12-43ab-b0f0-b34631959c23	CABO VIRGENES	024	\N	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	\N	\N	a48e3d60-bea0-4828-8099-3debb447f631	ALPESCA  S.A.	Puerto Madryn		0280-447-4958 / 45-1069	\N		\N	\N		t	\N	\N	\N
5a66dcea-8bf3-42ec-ae86-67f0cfa09419	CALABRIA	0567	1245	15652b63-0efc-4059-ad8a-36de68d64a35	9bda293b-e1b2-4bd2-9b2c-d34743032f06	\N	4	19.63	266	a48e3d60-bea0-4828-8099-3debb447f631	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
df99871a-1838-499d-9c86-e11e8c729ad6	CALIZ	02809	0	15652b63-0efc-4059-ad8a-36de68d64a35	9bda293b-e1b2-4bd2-9b2c-d34743032f06	\N	4	20.20	545	18318dd2-cbb1-42cb-8aa0-f6f2c1f945bd	FLOTA AMARILLA RAWSON	Rawson			\N		\N	\N		t	\N	\N	\N
db829f42-2c1a-48fe-bf13-b161dea0e8e6	CALLEJA	06276	1249	15652b63-0efc-4059-ad8a-36de68d64a35	9bda293b-e1b2-4bd2-9b2c-d34743032f06	\N	10	21.83	503	24918e15-e968-484f-b31e-dc786b5f9ec2	OTESA  S.A.	Mar del Plata		493-5606	\N		\N	\N		t	\N	\N	\N
916b2ce7-b264-44e5-947e-24a3c72729ba	CANAL DE BEAGLE	0407	0	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	23.90	501	24918e15-e968-484f-b31e-dc786b5f9ec2	CANAL DE BEAGLE  S.R.L.	Mar del Plata		480-4447	\N		\N	\N		t	\N	\N	\N
6bc28d4e-02a0-4377-ba30-4911d6869264	CAPESANTE	02929	2723	2966881e-e368-4b60-958d-683c71ed8609	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	9d02d029-f003-41b6-89de-0eea18b2d4e4	40	50.15	2550	24918e15-e968-484f-b31e-dc786b5f9ec2	GLACIAR PESQUERA  S.A.	Mar del Plata		492-2216	\N		\N	\N		t	\N	\N	\N
4216626c-e709-4c9d-bd9a-0a4ee16408cc	CAPITAN CANEPA	059F	\N	65029fa6-99f0-445f-9613-176773c55dca	\N	\N	28	\N	\N	24918e15-e968-484f-b31e-dc786b5f9ec2	INIDEP	Mar del Plata		451-7442 ó 486-2586 int 162	\N		\N	\N		t	\N	\N	\N
083309e9-c184-4504-b786-7c64ae8956a5	CAPITAN GIACHINO	0151	1260	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	38.42	1062	24918e15-e968-484f-b31e-dc786b5f9ec2	KALARI S.A.	Mar del Plata		489-1959	\N		\N	\N		t	\N	\N	\N
63ef7d19-4bd4-4b24-a530-45b5d244d03e	CAPITAN OCA BALDA	060F	\N	65029fa6-99f0-445f-9613-176773c55dca	\N	\N	21	\N	\N	24918e15-e968-484f-b31e-dc786b5f9ec2	INIDEP	Mar del Plata		451-7442 ó 486-2586 int 162	\N		\N	\N		t	\N	\N	\N
8ba4b7d2-3158-4f0b-87da-32facb2f8896	CARMEN A	02045	1269	15652b63-0efc-4059-ad8a-36de68d64a35	9bda293b-e1b2-4bd2-9b2c-d34743032f06	\N	4	15.30	223	18318dd2-cbb1-42cb-8aa0-f6f2c1f945bd	FLOTA AMARILLA RAWSON	Rawson			\N		\N	\N		t	\N	\N	\N
c9f2edf2-e621-47b6-9bce-7b976ef976f3	CAROLINA P	0176	1272	975bf25c-1d6d-4101-9c5d-abe95e0a6978	9bda293b-e1b2-4bd2-9b2c-d34743032f06	a05ae304-2d0e-4e29-a6f3-fa7372a41c97	60	71.60	1976	a48e3d60-bea0-4828-8099-3debb447f631	ESTRELLA PATAGONICA S.A.	Puerto Madryn		0280-445-4407	\N		\N	\N		t	\N	\N	\N
62630ca5-f5d2-4953-8e23-774eb07da4e4	CEIBE DOUS	0336	1276	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	40.70	738	a48e3d60-bea0-4828-8099-3debb447f631	IBERCONSA  DE ARGENTINA  S.A.	Puerto Madryn	4800274	0280-445-4324	\N	amalfitanoycia@hotmail.com	\N	\N	Agencia Maritima Almafitano	t	\N	\N	\N
801fd0f5-cb21-497a-829a-dc32b5af28f2	CENTAURO 2000	0482	1278	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	35.50	1302	24918e15-e968-484f-b31e-dc786b5f9ec2	PESQUERA VERAZ  S.A.	Mar del Plata		489-4624 / 489-0314 (astillero)	\N		\N	\N		t	\N	\N	\N
336cc50d-cf30-4be6-84ad-02dd696b2c6b	CENTURION DEL ATLANTICO	0237	1280	975bf25c-1d6d-4101-9c5d-abe95e0a6978	9bda293b-e1b2-4bd2-9b2c-d34743032f06	a05ae304-2d0e-4e29-a6f3-fa7372a41c97	60	112.80	8111	26cb8962-0318-4dfe-a961-1b84a6ce6302	ESTREMAR  S.A.	Ciudad Autónoma de Buenos Aires		011-6533-7853 / 4345-1102	\N		\N	\N		t	\N	\N	\N
2bb6448e-c8d5-4af1-9988-19bae2d54042	CERES	01420	1281	6a95076f-aec1-4941-b231-92dfbc802cb7	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	60	60.74	1969	24918e15-e968-484f-b31e-dc786b5f9ec2	PESQUERA CERES  S.A.	Mar del Plata		410-0051 / 7	\N		\N	\N		t	\N	\N	\N
8eacd46e-e6f0-46d4-bebe-75e423156e0f	CHANG BO GO I	06190	\N	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	\N	\N	26cb8962-0318-4dfe-a961-1b84a6ce6302	ARPEPA  M.C.I.S.A.	Ciudad Autónoma de Buenos Aires		011-4382-1605	\N		\N	\N		t	\N	\N	\N
c7e7975d-8298-41ca-8c0f-e232b7609400	CHATKA I	02893	0	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	16.73	195	a48e3d60-bea0-4828-8099-3debb447f631	FOOD PARTNERS PATAGONIA S.A.	Puerto Madryn		0280-4458579 / 5225	\N		\N	\N		t	\N	\N	\N
6b08da0d-33bf-48c7-ba7d-9d596e436eea	CHIARPESCA 56	01090	\N	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	\N	\N	24918e15-e968-484f-b31e-dc786b5f9ec2	APOLO FISH  S.A.	Mar del Plata		489-4519 / 489-1133	\N		\N	\N		t	\N	\N	\N
a7747300-0ddf-42cb-954d-62c5cb1dff87	CHIARPESCA 57	01029	\N	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	\N	\N	24918e15-e968-484f-b31e-dc786b5f9ec2	CHIARPESCA  S.A.	Mar del Plata		489-1385	\N		\N	\N		t	\N	\N	\N
64579e56-40b0-43b3-97be-b729c1ec4246	CHIARPESCA 902	02110	\N	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	\N	\N	24918e15-e968-484f-b31e-dc786b5f9ec2	CHIARPESCA  S.A.	Mar del Plata		489-1385	\N		\N	\N		t	\N	\N	\N
d596aa98-c828-46d6-a1f5-1126839d0acc	CHIARPESCA 903	02109	\N	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	\N	\N	24918e15-e968-484f-b31e-dc786b5f9ec2	CHIARPESCA  S.A.	Mar del Plata		489-1385	\N		\N	\N		t	\N	\N	\N
e02b50ee-f135-4657-9b14-6b00c7318fbe	CHIYO MARU Nº 3	02987	2745	fec3d722-78a4-4209-a6d3-e247c197885a	3d4b058b-d293-49cb-9018-8e8e99675548	b5066e3d-aff4-484a-b1ad-a45a57700aeb	30	52.80	937	26cb8962-0318-4dfe-a961-1b84a6ce6302	CRUSTACEOS DEL SUR  S.A.	Ciudad Autónoma de Buenos Aires		011-5218-4287	\N		\N	\N		t	\N	\N	\N
93c98ecf-8dc5-4327-a6c3-66d8806bb760	CHOCO MARU 68	JA13	\N	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	\N	\N	24918e15-e968-484f-b31e-dc786b5f9ec2	PESQUERA COMERCIAL  S.A.	Mar del Plata		489-3030	\N		\N	\N		t	\N	\N	\N
6035c441-9648-4f1e-8c4f-3bfe737da3ea	CHOKYU MARU Nº 18.	2584	1312	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	68.70	1777	26cb8962-0318-4dfe-a961-1b84a6ce6302	BAHIA GRANDE  S.A.	Ciudad Autónoma de Buenos Aires		011-5272-0850 / 5254-1133	\N		\N	\N		t	\N	\N	\N
3ad9b4d7-5c52-454c-9ae5-caedd88ff50a	CINCOMAR 1	0439	\N	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	\N	\N	26cb8962-0318-4dfe-a961-1b84a6ce6302	CINCOMAR  S.A.	Ciudad Autónoma de Buenos Aires		011-4326-4991	\N		\N	\N		t	\N	\N	\N
fd6a431c-10eb-49db-8650-73db39d660b4	CINCOMAR 5	02351	\N	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	\N	\N	26cb8962-0318-4dfe-a961-1b84a6ce6302	CINCOMAR  S.A.	Ciudad Autónoma de Buenos Aires		011-4326-4991	\N		\N	\N		t	\N	\N	\N
7a92396d-37d2-4b41-b500-2ee2984c4796	CIUDAD DE HUELVA	01519	1324	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	27.45	426	a48e3d60-bea0-4828-8099-3debb447f631	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
51186493-d18d-44d3-a90c-70776a67d4e7	CIUDAD FELIZ	0910	2721	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	28.56	458	24918e15-e968-484f-b31e-dc786b5f9ec2	CARAVON S.A.	Mar del Plata		489-9404	\N		\N	\N		t	\N	\N	\N
eea9d0c7-abe2-4236-a9dd-4d3b6fa3f70d	CLAUDIA	02183	\N	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	\N	\N	26cb8962-0318-4dfe-a961-1b84a6ce6302	LUXMARINO  S.A.	Ciudad Autónoma de Buenos Aires		011-4342-2621	\N		\N	\N		t	\N	\N	\N
39f1edbd-f9d5-4b86-8d28-6afde2fb9631	CLAUDINA	02345	1331	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	53.58	937	26cb8962-0318-4dfe-a961-1b84a6ce6302	ARMADORA  ACRUX  S.A.	Ciudad Autónoma de Buenos Aires		011-4312-6470	\N		\N	\N		t	\N	\N	\N
ba1feacb-a508-4dc0-bcda-2263288171b3	COALSA SEGUNDO	0790	1333	6a95076f-aec1-4941-b231-92dfbc802cb7	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	60	76.20	2960	26cb8962-0318-4dfe-a961-1b84a6ce6302	YUKEN  S.A.	Ciudad Autónoma de Buenos Aires		011-5279-1302 / 5236-6069	\N		\N	\N		t	\N	\N	\N
11193a03-07bb-43b5-a878-f34e3a634115	CODEPECA  I	0497	\N	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	\N	\N	a48e3d60-bea0-4828-8099-3debb447f631	HARENGUS  S.A.	Puerto Madryn		0280-445-0822	\N		\N	\N		t	\N	\N	\N
3bb88340-8df7-4241-8231-77af570aaa09	CODEPECA  II	0498	\N	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	\N	\N	a48e3d60-bea0-4828-8099-3debb447f631	HARENGUS  S.A.	Puerto Madryn		0280-445-0822	\N		\N	\N		t	\N	\N	\N
3e28fad8-d35c-42ad-a6e0-52e62b823fab	CODEPECA  III	0506	\N	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	\N	\N	a48e3d60-bea0-4828-8099-3debb447f631	HARENGUS  S.A.	Puerto Madryn		0280-445-0822	\N		\N	\N		t	\N	\N	\N
b9b16bea-c66f-4c33-b457-5c6f1971a239	CODEPECA IV	01012	\N	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	\N	\N	a48e3d60-bea0-4828-8099-3debb447f631	PEREIRA  ARGENTINA  S.A.	Puerto Madryn		0280-445-7377 / 447-2249	\N		\N	\N		t	\N	\N	\N
fbbbecc4-e343-4f8e-8ba4-fd9220df72e6	CABO SAN SEBASTIAN	022	\N	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	\N	\N	a48e3d60-bea0-4828-8099-3debb447f631	ALPESCA  S.A.	Puerto Madryn		0280-447-4958 / 45-1069	\N		\N	\N		t	\N	\N	\N
5cc24994-096d-458c-94d1-1fe6336ee4fd	COMETA	0919	\N	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	\N	\N	24918e15-e968-484f-b31e-dc786b5f9ec2	VICARP  S.A.	Mar del Plata		480-4378	\N		\N	\N		t	\N	\N	\N
ee3df945-0aea-44d4-ae2a-6637bbdea3fe	CONARA I	0201	\N	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	\N	\N	a48e3d60-bea0-4828-8099-3debb447f631	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
f6faf395-8bfa-4c3b-943b-b13f065bf0aa	CONARPESA I	0200	1344	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	52.50	1482	a48e3d60-bea0-4828-8099-3debb447f631	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
c8126bf0-e249-4868-94a7-616fb34c096e	CORAJE	0645	1359	\N	\N	\N	0	28.28	426	24918e15-e968-484f-b31e-dc786b5f9ec2	IBERCONSA  DE ARGENTINA  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
17e31176-8763-4fef-b211-80ca59c3cc94	CORAL  AZUL	06127	\N	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	\N	\N	26cb8962-0318-4dfe-a961-1b84a6ce6302	NOVAMAR  S.A.	Ciudad Autónoma de Buenos Aires		011-4345-6688	\N		\N	\N		t	\N	\N	\N
f592a83e-1462-4bcd-920a-7a209f190896	CORAL BLANCO	06137	\N	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	\N	\N	26cb8962-0318-4dfe-a961-1b84a6ce6302	NOVAMAR  S.A.	Ciudad Autónoma de Buenos Aires		011-4345-6688	\N		\N	\N		t	\N	\N	\N
301cd513-7aad-455d-9654-6e67f58a166a	CORMORAN	01611	\N	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	\N	\N	24918e15-e968-484f-b31e-dc786b5f9ec2	ANTONIO BARILLARI  S.A.	Mar del Plata		481-1173  / 489-0872	\N		\N	\N		t	\N	\N	\N
6e4f074c-3067-401b-b224-3b07c263d98d	COSTAMAR	01549	\N	15652b63-0efc-4059-ad8a-36de68d64a35	9bda293b-e1b2-4bd2-9b2c-d34743032f06	\N	4	\N	\N	18318dd2-cbb1-42cb-8aa0-f6f2c1f945bd	INDUSTRIA  PESQUERA  PATAGONICA  S.A.	Trelew		0280-444-6577	\N		\N	\N		t	\N	\N	\N
8d817f6a-e766-470f-94f2-7d51cdcb224d	DASA 508	0499	\N	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	\N	\N	26cb8962-0318-4dfe-a961-1b84a6ce6302	PESQUERA  DONGAH  ARGENTINA  S.A.	Ciudad Autónoma de Buenos Aires		011-4815-5525	\N		\N	\N		t	\N	\N	\N
f59f4837-6ab1-4645-bd9b-780e76499b01	DASA 757	02200	\N	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	\N	\N	26cb8962-0318-4dfe-a961-1b84a6ce6302	PESQUERA  DONGAH  ARGENTINA  S.A.	Ciudad Autónoma de Buenos Aires		011-4815-5525	\N		\N	\N		t	\N	\N	\N
20918910-bba7-4ec1-994c-f951fcece140	DEMOSTENES	0113	\N	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	\N	\N	26cb8962-0318-4dfe-a961-1b84a6ce6302	AGUA MARINA  S.A.	Ciudad Autónoma de Buenos Aires		011-4342-0605 / 5656 / 1709	\N		\N	\N		t	\N	\N	\N
db105913-3875-49fd-bb46-eaf8e5c042b4	DESTINY	3209	\N	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	\N	\N	\N	WANCHESE ARGENTINA  S.A.				\N		\N	\N		t	\N	\N	\N
6bf9905e-23ee-4cb8-a7fe-5a32a639b83c	DEPASUR  I	0330	\N	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	\N	\N	a48e3d60-bea0-4828-8099-3debb447f631	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
a61ef8b8-9047-4fe1-a63a-57bdaab073ac	DEPEMAS 51	0239	\N	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	\N	\N	26cb8962-0318-4dfe-a961-1b84a6ce6302	DEPEMAS  S.A.	Ciudad Autónoma de Buenos Aires		011-4372-7909  /  4382-5382	\N		\N	\N		t	\N	\N	\N
603c344e-91fa-4576-a266-7e949e76741f	DEPEMAS 81	0281	\N	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	\N	\N	26cb8962-0318-4dfe-a961-1b84a6ce6302	PESQUERA ORION  S.A.	Ciudad Autónoma de Buenos Aires		011-4343-9327	\N		\N	\N		t	\N	\N	\N
16936387-6dec-4b31-b697-dd4084c6eed2	DESAFIO	0177	1398	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	29.56	850	24918e15-e968-484f-b31e-dc786b5f9ec2	PESQUERA VERAZ  S.A.	Mar del Plata		489-4624 / 489-0314 (astillero)	\N		\N	\N		t	\N	\N	\N
faf32a7c-23de-4e98-bbb1-f3173e4f1d2a	DESEADO	01598	1400	15652b63-0efc-4059-ad8a-36de68d64a35	9bda293b-e1b2-4bd2-9b2c-d34743032f06	\N	4	19.00	301	18318dd2-cbb1-42cb-8aa0-f6f2c1f945bd	FLOTA AMARILLA RAWSON	Rawson			\N		\N	\N		t	\N	\N	\N
9b59638e-58e5-4ccc-9954-170010042d52	DIEGO PRIMERO	01725	\N	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	\N	\N	24918e15-e968-484f-b31e-dc786b5f9ec2	PESQUERA DIEGO PRIMERO  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
89dd615d-0156-4486-9201-39f8c694e534	DON JUAN ALVAREZ	3300	\N	db248d8c-5979-4de7-9201-d8dabe9baac1	9bda293b-e1b2-4bd2-9b2c-d34743032f06	\N	\N	\N	\N	\N	CONARPESA  S.A.				\N		\N	\N		t	\N	\N	\N
5477a67f-88d3-45f0-8926-f6f19f99266c	DON  NATALIO	01183	\N	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	\N	\N	24918e15-e968-484f-b31e-dc786b5f9ec2	14 DE JULIO  S.A.	Mar del Plata		480-3545	\N		\N	\N		t	\N	\N	\N
0572b900-ce9a-4aeb-a675-496bc539b64f	DON AGUSTIN	0968	\N	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	\N	\N	24918e15-e968-484f-b31e-dc786b5f9ec2	PESQUERA  MARGARITA  S.A.	Mar del Plata		489-4645   /   489-2946	\N		\N	\N		t	\N	\N	\N
94e3220a-142c-401c-bc26-e66de4a561ba	DON ANTONIO	0029	1411	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	27.80	549	24918e15-e968-484f-b31e-dc786b5f9ec2	GIORNO  S.A.	Mar del Plata		410-0051 / 0057	\N		\N	\N		t	\N	\N	\N
888e46a4-8591-4c82-90c4-a44728eee7d7	DON CARMELO	01320	1416	15652b63-0efc-4059-ad8a-36de68d64a35	9bda293b-e1b2-4bd2-9b2c-d34743032f06	\N	8	19.04	424	24918e15-e968-484f-b31e-dc786b5f9ec2	MARFE  S.A.	Mar del Plata	4800005	480-0102	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
03d61294-c76c-49f0-94ff-f91aa9c96f12	DON CAYETANO	0579	1417	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	47.10	1503	24918e15-e968-484f-b31e-dc786b5f9ec2	PEDRO MOSCUZZA e HIJOS  S.A.	Mar del Plata	4890960	489-7287	\N	agencia@maritimavidal.com.ar	\N	\N	Agencia Maritima Vidal	t	\N	\N	\N
0e5b39fd-36f4-4937-93f4-62e6eaecba98	DON FRANCISCO I	2562	1428	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	66.55	1776	24918e15-e968-484f-b31e-dc786b5f9ec2	EL MARISCO  S.A.	Mar del Plata	480-7779 - HERNAN	489-0384	\N	agenciasenoransmdp@yahoo.com	\N	\N	Agencia Maritima SEÑORANS	t	\N	\N	\N
c387e8ab-1df7-4fb3-ba88-d97e04368e0b	DON GIULIANO	02025	1431	15652b63-0efc-4059-ad8a-36de68d64a35	9bda293b-e1b2-4bd2-9b2c-d34743032f06	\N	4	17.10	220	18318dd2-cbb1-42cb-8aa0-f6f2c1f945bd	FLOTA AMARILLA RAWSON	Rawson			\N		\N	\N		t	\N	\N	\N
c0f85cfc-749c-4efc-bb88-ab56c1e00b61	DON JOSE	00892	1434	15652b63-0efc-4059-ad8a-36de68d64a35	9bda293b-e1b2-4bd2-9b2c-d34743032f06	\N	8	16.49	269	24918e15-e968-484f-b31e-dc786b5f9ec2	VENTO DI TERRA  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
a3962901-5330-4bff-b7a9-71958d5c335e	DON JOSE DI BONA	02241	1435	15652b63-0efc-4059-ad8a-36de68d64a35	9bda293b-e1b2-4bd2-9b2c-d34743032f06	\N	4	19.85	301	18318dd2-cbb1-42cb-8aa0-f6f2c1f945bd	PROA  AL SUR  S.R.L.	Rawson			\N		\N	\N		t	\N	\N	\N
10d309f9-c760-4f25-9e63-90769be04d16	DON JUAN	01397	1437	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	27.00	425	\N	PESQUERA DON JUAN  S.A.				\N		\N	\N		t	\N	\N	\N
742f28ac-68f4-430f-8cc9-c95fe78d64f2	DON JUAN D´AMBRA	5174	\N	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	\N	\N	24918e15-e968-484f-b31e-dc786b5f9ec2	PESCA ANGELA  S.A.	Mar del Plata		626-2236 /37	\N		\N	\N		t	\N	\N	\N
db88e095-7fe4-46c2-8a50-d7033231cc2d	DON LUCIANO	069	\N	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	\N	\N	24918e15-e968-484f-b31e-dc786b5f9ec2	TATURIELLO  S.A.	Mar del Plata		489-3833	\N		\N	\N		t	\N	\N	\N
8d950e58-7292-4096-8513-16166ea032e8	DON LUIS I	02093	1445	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	67.95	1803	24918e15-e968-484f-b31e-dc786b5f9ec2	PESQUERA CERES  S.A.	Mar del Plata		410-0051 / 7	\N		\N	\N		t	\N	\N	\N
36ced743-d5c9-4fb5-bd15-796ce20205af	DON MIGUEL 1°	0748	\N	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	\N	\N	24918e15-e968-484f-b31e-dc786b5f9ec2	PESQUERA EL NAZARENO	Mar del Plata	4895032 Emanuel	489-9414 (of. Pers. Emb.)	\N	operacionesconsultoramaritima@gmail.com	\N	\N	Consultora Maritima Merlini	t	\N	\N	\N
2e1e0727-6880-498c-8b3a-6b187d7fd0ab	DON NICOLA	0893	1450	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	28.14	856	24918e15-e968-484f-b31e-dc786b5f9ec2	PEZ ESPADA  S.A.	Mar del Plata		480-0846	\N		\N	\N		t	\N	\N	\N
41860047-fb2d-4b32-ba6f-62a92cf249ea	DON OSCAR	02184	\N	15652b63-0efc-4059-ad8a-36de68d64a35	9bda293b-e1b2-4bd2-9b2c-d34743032f06	\N	4	\N	\N	18318dd2-cbb1-42cb-8aa0-f6f2c1f945bd	FLOTA AMARILLA RAWSON	Rawson	4800005		\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
6c8d7809-be24-4d31-a90e-84cd31823b7e	DON PEDRO	068	\N	6a95076f-aec1-4941-b231-92dfbc802cb7	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	60	\N	\N	24918e15-e968-484f-b31e-dc786b5f9ec2	PEDRO MOSCUZZA e HIJOS  S.A.	Mar del Plata		489-7287	\N		\N	\N		t	\N	\N	\N
d97a9e59-5e72-4def-b198-bad2409329d0	PAOLA  S	0557	\N	\N	\N	\N	30	\N	\N	\N					\N		\N	\N		t	\N	\N	\N
6baa3a49-d5bb-4a3a-9f0c-8fab09da9d86	COMANDANTE LUIS PIEDRABUENA	0767	1340	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	25.00	501	24918e15-e968-484f-b31e-dc786b5f9ec2	COMANDANTE PIEDRABUENA  S.R.L.	Mar del Plata		489-9404	\N		\N	\N		t	\N	\N	\N
ab232060-ee9d-409c-baeb-d5899b9f7419	DON SANTIAGO	01733	1467	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	10	26.55	776	24918e15-e968-484f-b31e-dc786b5f9ec2	SAN JORGE S.A.	Mar del Plata		480-6611	\N		\N	\N		t	\N	\N	\N
b25eaf9b-6383-4b2b-bbc7-cd4110c7c318	DON TOMASSO	02310	1468	15652b63-0efc-4059-ad8a-36de68d64a35	9bda293b-e1b2-4bd2-9b2c-d34743032f06	\N	4	17.00	356	18318dd2-cbb1-42cb-8aa0-f6f2c1f945bd	FLOTA AMARILLA RAWSON	Rawson			\N		\N	\N		t	\N	\N	\N
fe20a5ee-0dbc-4f0d-b355-f112fe36d7b7	DON TURI	01540	1470	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	28.62	839	24918e15-e968-484f-b31e-dc786b5f9ec2	DON TURI  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
b2f4bdd1-ed88-4381-8496-d8c5835272c2	DON VICENTE VUOSO	0539	1474	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	20.69	537	24918e15-e968-484f-b31e-dc786b5f9ec2	VUOSO HNOS. S.R.L.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
f862a220-c3e6-4c7d-bcc8-388c59c92b2f	DOÑA ALFIA	0512	1483	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	20.70	426	24918e15-e968-484f-b31e-dc786b5f9ec2	ANTONIO BARILLARI  S.A.	Mar del Plata		481-1173  / 489-0872	\N		\N	\N		t	\N	\N	\N
f3969c7d-fa54-47d3-a373-3302f2826596	Dr. EDUARDO L. HOLMBERG	061F	\N	65029fa6-99f0-445f-9613-176773c55dca	\N	\N	24	\N	\N	24918e15-e968-484f-b31e-dc786b5f9ec2	INIDEP	Mar del Plata		451-7442 ó 486-2586 int 162	\N		\N	\N		t	\N	\N	\N
04154ef1-029a-4d21-a588-abdf7aefb604	DUKAT	02775	2712	fec3d722-78a4-4209-a6d3-e247c197885a	3d4b058b-d293-49cb-9018-8e8e99675548	b5066e3d-aff4-484a-b1ad-a45a57700aeb	30	50.80	1302	26cb8962-0318-4dfe-a961-1b84a6ce6302	CRUSTACEOS DEL SUR  S.A.	Ciudad Autónoma de Buenos Aires		011-5218-4287	\N		\N	\N		t	\N	\N	\N
dc5524f0-9cf6-4d6d-890f-a5f1568cd976	ECHIZEN MARU	0326	1495	975bf25c-1d6d-4101-9c5d-abe95e0a6978	9bda293b-e1b2-4bd2-9b2c-d34743032f06	a05ae304-2d0e-4e29-a6f3-fa7372a41c97	60	89.59	4702	3c423d63-b431-4bf2-b375-b4de59037821	PESANTAR  S.A. ( Empresa Pesq de la Patagonia y Antartida )	Ushuaia		02901-43-3449 / 43-0008 / 43-0708	\N		\N	\N		t	\N	\N	\N
785ee7b8-ba1a-41a9-8397-649edb796905	EL MALO I	02350	\N	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	4	\N	\N	18318dd2-cbb1-42cb-8aa0-f6f2c1f945bd	NOGALES NOGALES  S. De HECHO	Rawson	4890960		\N	agencia@maritimavidal.com.ar	\N	\N	Agencia Maritima Vidal	t	\N	\N	\N
9099f0b0-0c00-4c8c-8825-4d491b3ed84f	EL MARISCO I	0912	1516	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	27.22	426	24918e15-e968-484f-b31e-dc786b5f9ec2	EL MARISCO  S.A.	Mar del Plata	4890960	489-0384	\N	agencia@maritimavidal.com.ar	\N	\N	Agencia Maritima Vidal	t	\N	\N	\N
95775b06-2836-4d16-b333-3471ec1442c3	EL MARISCO II	0915	1517	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	56.30	1407	24918e15-e968-484f-b31e-dc786b5f9ec2	EL MARISCO  S.A.	Mar del Plata		489-0384	\N		\N	\N		t	\N	\N	\N
d3906328-1427-41b0-babe-e9ff68fc30d7	EL SANTO	05970	\N	15652b63-0efc-4059-ad8a-36de68d64a35	9bda293b-e1b2-4bd2-9b2c-d34743032f06	\N	0	\N	\N	f05d47aa-ffad-4c48-99f2-39015dc0159a	VUOGAFE  S.A.	Puerto Deseado		0297-155-940853	\N		\N	\N		t	\N	\N	\N
39e875f8-71d6-4017-be3e-311bc46791aa	EMILIA MARIA	01390	1543	15652b63-0efc-4059-ad8a-36de68d64a35	9bda293b-e1b2-4bd2-9b2c-d34743032f06	\N	10	22.60	521	24918e15-e968-484f-b31e-dc786b5f9ec2	COSTA BRAVA  S.A.	Mar del Plata		489-7538	\N		\N	\N		t	\N	\N	\N
9771cf4b-e77d-46f4-85b0-a20c4d45df83	EMPESUR II	01439	\N	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	\N	\N	26cb8962-0318-4dfe-a961-1b84a6ce6302	EMPESUR  S.A.	Ciudad Autónoma de Buenos Aires		011-4312-0123	\N		\N	\N		t	\N	\N	\N
4210ae8a-cf99-4623-8583-3d27a61d62ea	EMPESUR III	01438	\N	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	\N	\N	26cb8962-0318-4dfe-a961-1b84a6ce6302	EMPESUR  S.A.	Ciudad Autónoma de Buenos Aires		011-4312-0123	\N		\N	\N		t	\N	\N	\N
bec1a1ef-7b89-4d12-bad0-3befd113ecb9	EMPESUR V	02650	2705	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	30.52	1369	26cb8962-0318-4dfe-a961-1b84a6ce6302	EMPESUR  S.A.	Ciudad Autónoma de Buenos Aires		011-4312-0123	\N		\N	\N		t	\N	\N	\N
4107e5b9-eea4-4ab0-9bfb-936834f404d6	EMPESUR VI	02983	2749	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	35.03	1289	26cb8962-0318-4dfe-a961-1b84a6ce6302	EMPESUR  S.A.	Ciudad Autónoma de Buenos Aires		011-4312-0123	\N		\N	\N		t	\N	\N	\N
27e39eaf-262a-4d6d-9797-0c64bac0cc6c	EMPESUR VII	03045	2754	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	35.03	1290	26cb8962-0318-4dfe-a961-1b84a6ce6302	EMPESUR  S.A.	Ciudad Autónoma de Buenos Aires		011-4312-0123	\N		\N	\N		t	\N	\N	\N
bb6b262a-19ae-4c93-948e-c27b3d88c2f6	ENTRENA UNO	02069	1551	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	33.10	839	26cb8962-0318-4dfe-a961-1b84a6ce6302	FOOD ARTS  S.A.	Ciudad Autónoma de Buenos Aires		POR MAILlazuaje@foodarts.com.ar	\N		\N	\N		t	\N	\N	\N
d4b3b9a3-6c0d-413f-86c0-6ceae097c3af	ERIN BRUCE	0537	1553	2966881e-e368-4b60-958d-683c71ed8609	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	9d02d029-f003-41b6-89de-0eea18b2d4e4	30	53.60	2252	24918e15-e968-484f-b31e-dc786b5f9ec2	WANCHESE ARGENTINA  S.A.	Mar del Plata		489-1236	\N		\N	\N		t	\N	\N	\N
6c4b9846-561e-42c3-b685-ad9a6df761e2	ERIN BRUCE II	TEMP-0002	\N	2966881e-e368-4b60-958d-683c71ed8609	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	9d02d029-f003-41b6-89de-0eea18b2d4e4	\N	\N	\N	\N					\N		\N	\N		t	\N	\N	\N
f4d87770-6364-466a-9865-939b5d601768	ESAMAR N° 4	0467	\N	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	\N	\N	26cb8962-0318-4dfe-a961-1b84a6ce6302	ESAMAR  S.A.	Ciudad Autónoma de Buenos Aires		011-4393-8431	\N		\N	\N		t	\N	\N	\N
1f74eb4a-6b75-4b6b-a853-4fde93e63eb7	ESPADARTE	02048	1558	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	68.20	1529	f05d47aa-ffad-4c48-99f2-39015dc0159a	PESQUERA DESEADO  S.A.	Puerto Deseado		0297-487-0884 / 0327 / 2407	\N		\N	\N		t	\N	\N	\N
3e18c035-9301-4393-bdc5-6826462dfdf3	ESPERANZA 909	02577	1559	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	72.34	1678	24918e15-e968-484f-b31e-dc786b5f9ec2	CHIARPESCA  S.A.	Mar del Plata		489-1385	\N		\N	\N		t	\N	\N	\N
a51eafa1-9478-4a2a-8bcd-55658ee18b89	ESPERANZA DEL SUR	02751	\N	3271a122-ccb0-42ec-a69b-87d56de04fa8	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	60	\N	\N	3c423d63-b431-4bf2-b375-b4de59037821	PESANTAR  S.A. ( Empresa Pesq de la Patagonia y Antartida )	Ushuaia		02901-43-3449 / 43-0008 / 43-0708	\N		\N	\N		t	\N	\N	\N
c0eba749-7b8d-47da-8d2a-8a714c8c0040	ESPERANZA DOS	06264	\N	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	\N	\N	26cb8962-0318-4dfe-a961-1b84a6ce6302	ESPERANZA DEL MAR  S.A.	Ciudad Autónoma de Buenos Aires		011-4328-8696	\N		\N	\N		t	\N	\N	\N
00a32721-8106-4f0d-a57d-708d2d4fa731	ESPERANZA UNO	06113	\N	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	\N	\N	26cb8962-0318-4dfe-a961-1b84a6ce6302	ESPERANZA DEL MAR  S.A.	Ciudad Autónoma de Buenos Aires		011-4328-8696	\N		\N	\N		t	\N	\N	\N
9dfc57bf-bee7-4c66-a51a-e6b2c25f6070	ESTEFANY	001	1565	15652b63-0efc-4059-ad8a-36de68d64a35	9bda293b-e1b2-4bd2-9b2c-d34743032f06	\N	15	23.60	530	24918e15-e968-484f-b31e-dc786b5f9ec2	GIORNO  S.A.	Mar del Plata		410-0051 / 0057	\N		\N	\N		t	\N	\N	\N
9fd56c1d-89aa-422d-9a99-040cb2addb35	ESTEIRO	6328	\N	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	\N	\N	24918e15-e968-484f-b31e-dc786b5f9ec2	BALDIMAR  S.A.	Mar del Plata		489-6522	\N		\N	\N		t	\N	\N	\N
f5a2a076-1975-4525-854d-29532a84b93c	ESTHER 153	02058	1568	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	55.10	1252	26cb8962-0318-4dfe-a961-1b84a6ce6302	ARPEPA  M.C.I.S.A.	Ciudad Autónoma de Buenos Aires		011-4382-1605	\N		\N	\N		t	\N	\N	\N
01851b98-03bf-4a88-a045-0c2be7f30b24	ESTRELLA N° 5	0246	1575	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	54.20	1601	26cb8962-0318-4dfe-a961-1b84a6ce6302	HANSUNG AR  S.A.	Ciudad Autónoma de Buenos Aires		011-4816-2022	\N		\N	\N		t	\N	\N	\N
e817885e-33e9-40d9-b4c0-6563010e6d2d	ESTRELLA N° 6	012	1576	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	55.85	1581	26cb8962-0318-4dfe-a961-1b84a6ce6302	HANSUNG AR  S.A.	Ciudad Autónoma de Buenos Aires		011-4816-2022	\N		\N	\N		t	\N	\N	\N
3a081822-ab5c-4f2c-9d09-c7d650005a58	ESTRELLA N° 8	0242	\N	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	\N	\N	26cb8962-0318-4dfe-a961-1b84a6ce6302	HANSUNG AR  S.A.	Ciudad Autónoma de Buenos Aires		011-4816-2022	\N		\N	\N		t	\N	\N	\N
e35bee01-f4a9-4c8e-98aa-52553617bc09	FE EN PESCA	0226	\N	\N	\N	\N	0	\N	\N	24918e15-e968-484f-b31e-dc786b5f9ec2	ASARO HNOS.  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
0b30d45d-9c05-4cb8-9160-374849649e16	FEDERICO C	3190	2776	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	\N	37.68	1400	\N	PESQUERA VERAZ  S.A.				\N		\N	\N		t	\N	\N	\N
03013506-1694-4b77-95fc-fb58706c3ed6	DON ROMEO ERSINI	0972	\N	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	\N	\N	24918e15-e968-484f-b31e-dc786b5f9ec2	PESQUERA  MARGARITA  S.A.	Mar del Plata	4891553-154179360-154179860-154179062	489-4645   /   489-2946	\N	agenciasmiriglio@speedy.com.ar	\N	\N	Agencia Smiriglio	t	\N	\N	\N
191a6c99-46b2-4480-bb5b-7476853bbfce	FLORIDABLANCA	0969	1606	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	27.67	541	24918e15-e968-484f-b31e-dc786b5f9ec2	DESAFIO  S.A.	Mar del Plata		489-4788 / 3659	\N		\N	\N		t	\N	\N	\N
802ad179-34d6-4dad-ba52-df0e7f237d22	FLORIDABLANCA II	0252	\N	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	\N	\N	a48e3d60-bea0-4828-8099-3debb447f631	PESQUERA SAN ISIDRO S.A.	Puerto Madryn		0280-447-2697	\N		\N	\N		t	\N	\N	\N
82d3de36-c255-4ee6-b92d-52461acb2b2d	FLORIDABLANCA IV	0255	\N	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	\N	\N	49e7b97e-f997-4fd6-8de0-06ec2254bbf5	MARITIMA MONACHESI  S.A.	Bahia Blanca		0291-452-5913	\N		\N	\N		t	\N	\N	\N
54d7a8c2-4548-4f9d-99cd-467dd6d95cdf	FRANCA	0495	1612	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	27.29	493	24918e15-e968-484f-b31e-dc786b5f9ec2	AUGUSTA MEGARA  S.A.	Mar del Plata		480-2260	\N		\N	\N		t	\N	\N	\N
d9a0182a-a933-4dbb-9c9b-73a4935c8277	FRANCO	01458	\N	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	\N	\N	24918e15-e968-484f-b31e-dc786b5f9ec2	FRIGORIFICO DON LUIS  S.R.L.	Mar del Plata		489-4645	\N		\N	\N		t	\N	\N	\N
1990f562-70da-4c0b-af3a-c451417a3156	FU YUAN YU 636	02195	\N	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	\N	\N	26cb8962-0318-4dfe-a961-1b84a6ce6302	BAHIA GRANDE  S.A.	Ciudad Autónoma de Buenos Aires		011-5272-0850 / 5254-1133	\N		\N	\N		t	\N	\N	\N
461f2e89-0bce-469c-8a8c-ead4ac96bbcf	FUEGUINO I	0331	\N	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	\N	\N	a48e3d60-bea0-4828-8099-3debb447f631	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
0b3d50bc-4b60-4f8a-a61f-fb970503600d	GALA	02722	0	15652b63-0efc-4059-ad8a-36de68d64a35	9bda293b-e1b2-4bd2-9b2c-d34743032f06	\N	15	15.20	256	24918e15-e968-484f-b31e-dc786b5f9ec2	DISTRIBUIDORA MARECHIARE S.R.L.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
1b696a6a-8d69-46b2-b410-f87523c08e82	GALEMAR	0904	\N	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	\N	\N	24918e15-e968-484f-b31e-dc786b5f9ec2	ANTONIO BARILLARI  S.A.	Mar del Plata		481-1173  / 489-0872	\N		\N	\N		t	\N	\N	\N
2ab85f7c-77c1-4855-8626-b40ff371c8bb	GAUCHO GRANDE	0339	1642	\N	\N	\N	30	27.64	0	24918e15-e968-484f-b31e-dc786b5f9ec2	VICARP  S.A.	Mar del Plata	4890960	480-4378	\N	agencia@maritimavidal.com.ar	\N	\N	Agencia Maritima Vidal	t	\N	\N	\N
c66f1349-8b7b-44dc-8140-0f896fed0fe9	GEMINIS	01421	1643	6a95076f-aec1-4941-b231-92dfbc802cb7	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	60	68.90	2141	24918e15-e968-484f-b31e-dc786b5f9ec2	PESQUERA GEMINIS  S.A.	Mar del Plata		410-0051 / 7	\N		\N	\N		t	\N	\N	\N
acca2e5d-f938-4e59-bfc6-e55e5611ec4a	GIANFRANCO	01075	\N	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	\N	\N	24918e15-e968-484f-b31e-dc786b5f9ec2	PIEA  S.A.	Mar del Plata		489-6317 /489-1367	\N		\N	\N		t	\N	\N	\N
31fbca23-352e-44a4-9084-2aec8d374334	GIULIANA	02633	\N	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	\N	\N	24918e15-e968-484f-b31e-dc786b5f9ec2	PESQUERA  MARGARITA  S.A.	Mar del Plata		489-4645   /   489-2946	\N		\N	\N		t	\N	\N	\N
7c5afe39-42ad-475a-905e-a5a186a548b8	GLORIA DEL MAR I	01983	1651	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	54.30	1600	24918e15-e968-484f-b31e-dc786b5f9ec2	PESQUERA  DEL  ESTE  S.A.	Mar del Plata	4800005	489-1567	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
2ce8491f-c38d-4831-ab51-9ea45603ef5c	GRACIELA	0578	\N	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	\N	\N	24918e15-e968-484f-b31e-dc786b5f9ec2	PEDRO MOSCUZZA e HIJOS  S.A.	Mar del Plata		489-7287	\N		\N	\N		t	\N	\N	\N
04218708-5626-4ad0-9d18-9f02d896b639	GRACIELA I	3994	2765	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	39.94	0	24918e15-e968-484f-b31e-dc786b5f9ec2	PEDRO MOSCUZZA e HIJOS  S.A.	Mar del Plata		489-7287	\N		\N	\N		t	\N	\N	\N
b98163a9-f17a-4e7b-89e1-176bea1984de	GRAN CAPITAN	01538	1656	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	25.43	541	24918e15-e968-484f-b31e-dc786b5f9ec2	ORTIGIA  S.A.	Mar del Plata		489-2679	\N		\N	\N		t	\N	\N	\N
5d7ce2c0-5c01-4b8b-96d0-1be3d9ac3355	GURISES	01386	1667	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	25.20	546	24918e15-e968-484f-b31e-dc786b5f9ec2	A.B.H. PESQUERA  S.A.	Mar del Plata		489-6522	\N		\N	\N		t	\N	\N	\N
7bb16f3e-da24-43a3-b9c9-bdaf28bc45fb	GUSTAVO R	0075	\N	6a95076f-aec1-4941-b231-92dfbc802cb7	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	60	\N	\N	24918e15-e968-484f-b31e-dc786b5f9ec2	ARGEMER  S.A.	Mar del Plata		451-1247	\N		\N	\N		t	\N	\N	\N
ecdd5ca7-5f55-4732-a169-e5d32a96f3c2	HAMAZEN MARU N° 68	JA05	\N	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	\N	\N	26cb8962-0318-4dfe-a961-1b84a6ce6302	PESQUERA SANTA CRUZ  S.A.	Ciudad Autónoma de Buenos Aires		011-4305-4706	\N		\N	\N		t	\N	\N	\N
a785c2f2-e83c-4c58-afee-d1945dae407c	HAMPON	01410	1673	15652b63-0efc-4059-ad8a-36de68d64a35	9bda293b-e1b2-4bd2-9b2c-d34743032f06	\N	10	18.99	497	24918e15-e968-484f-b31e-dc786b5f9ec2	PESQUERA HAMPON S.R.L	Mar del Plata			\N		\N	\N		t	\N	\N	\N
7b12f8a6-705a-435a-a392-2c538c9ad61f	HARENGUS	0510	\N	6a95076f-aec1-4941-b231-92dfbc802cb7	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	60	\N	\N	a48e3d60-bea0-4828-8099-3debb447f631	HARENGUS  S.A.	Puerto Madryn		0280-445-0822	\N		\N	\N		t	\N	\N	\N
6a88ae9d-d158-4732-b013-e3b47ffa4292	HOKO 31	05934	\N	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	\N	\N	26cb8962-0318-4dfe-a961-1b84a6ce6302	FARO DEL SUR TRADING  S.A.	Ciudad Autónoma de Buenos Aires		011-4555-4956	\N		\N	\N		t	\N	\N	\N
6befc550-8616-4ae6-a02d-7c49424b335f	HOPE N°7	06130	1690	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	50.60	1235	26cb8962-0318-4dfe-a961-1b84a6ce6302	ALUNAMAR  S.A.	Ciudad Autónoma de Buenos Aires	4808331/4808332	011-4382-4194	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
e67c9a1b-e098-4a2f-ac37-96533c396959	HOYO MARU 37	JA01	\N	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	\N	\N	f05d47aa-ffad-4c48-99f2-39015dc0159a	ARGENOVA  S.A.	Puerto Deseado		0297- 487-0550  (447-2818  Com. Riv )	\N		\N	\N		t	\N	\N	\N
b384c225-8477-43c3-8eab-186c09bcf1dd	HSIANG LAI FU	80	\N	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	\N	\N	24918e15-e968-484f-b31e-dc786b5f9ec2	EL MARISCO  S.A.	Mar del Plata		489-0384	\N		\N	\N		t	\N	\N	\N
cb661fd5-47f9-45e7-b815-642399c04b0d	HUYU 961	TEMP-0003	0	\N	\N	\N	\N	65.70	0	\N					\N		\N	\N		t	\N	\N	\N
8ebc1a6e-0e89-4a93-adfe-898ff7ff6722	HUYU 962	03056	0	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	65.60	0	a48e3d60-bea0-4828-8099-3debb447f631	ALTAMARE  S.A.	Puerto Madryn		0280-445-7377 / 447-2249	\N		\N	\N		t	\N	\N	\N
c1e23268-deeb-4a1b-af78-8b380d2efeb1	HUYU 906	03026	2747	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	65.92	1579	24918e15-e968-484f-b31e-dc786b5f9ec2	CHENG I  S.A.	Mar del Plata		489-1385	\N		\N	\N		t	\N	\N	\N
460861d5-2550-4cd4-8aff-61e6f3f6c93a	HUYU 907	03027	2748	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	72.17	1678	24918e15-e968-484f-b31e-dc786b5f9ec2	CHENG I  S.A.	Mar del Plata	4800005	489-1385	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
f7f4712c-6927-4885-8868-a115efa26506	HU YU 910	81	\N	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	\N	\N	24918e15-e968-484f-b31e-dc786b5f9ec2	PEDRO MOSCUZZA e HIJOS  S.A.	Mar del Plata		489-7287	\N		\N	\N		t	\N	\N	\N
4fce7071-ed28-48d5-ba7f-7900353cf51f	HUAFENG 801	3013	2741	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	65.04	1973	24918e15-e968-484f-b31e-dc786b5f9ec2	ARDAPEZ  S.A.	Mar del Plata		480-1561 / 480-1568 / 480-1549	\N		\N	\N		t	\N	\N	\N
cc0467bb-dd93-432f-963b-1f3f335cc809	HUAFENG 802	3014	2751	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	65.04	1973	24918e15-e968-484f-b31e-dc786b5f9ec2	ARDAPEZ  S.A.	Mar del Plata		480-1561 / 480-1568 / 480-1549	\N		\N	\N		t	\N	\N	\N
de9d53d4-0bf9-4846-83d2-ad81c25aa32a	HUA I 616	0392	\N	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	\N	\N	26cb8962-0318-4dfe-a961-1b84a6ce6302	ARMADORA  ACRUX  S.A.	Ciudad Autónoma de Buenos Aires		011-4312-6470	\N		\N	\N		t	\N	\N	\N
23327371-7f34-463b-b01c-71fc39ef750f	PASA  82	0338	\N	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	\N	\N	a48e3d60-bea0-4828-8099-3debb447f631	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
be43c4a0-d487-450e-a5f1-cf729322fe05	FERNANDO ALVAREZ	0013	1597	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	36.60	1168	a48e3d60-bea0-4828-8099-3debb447f631	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
c362deb5-c03b-41ce-a72b-f71ff4654dca	HUAFENG 820 (ex INFINITUS PEZ)	01472A	\N	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	\N	\N	24918e15-e968-484f-b31e-dc786b5f9ec2	MELIMAR S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
9e01560f-4c15-4f92-b818-ffb0c73da9ca	HUAFENG 821 (ex INITIO PEZ)	01471A	\N	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	\N	\N	24918e15-e968-484f-b31e-dc786b5f9ec2	MELIMAR S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
d4cd55be-25c5-43b9-ba5b-d2b0f7dfbf07	IARA	06207	\N	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	\N	\N	26cb8962-0318-4dfe-a961-1b84a6ce6302	PESQUERA MADRYN  S.A.	Ciudad Autónoma de Buenos Aires		011-4394-1452	\N		\N	\N		t	\N	\N	\N
c550c5a3-5870-4e42-8022-88a1bbc3b5fb	IGLU I	01423	1713	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	32.75	660	24918e15-e968-484f-b31e-dc786b5f9ec2	GIORNO  S.A.	Mar del Plata		410-0051 / 0057	\N		\N	\N		t	\N	\N	\N
19c8d2e5-6b8c-41aa-8542-613f2d7376d2	INARI MARU N° 25	0261	\N	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	\N	\N	f05d47aa-ffad-4c48-99f2-39015dc0159a	ARGENOVA  S.A.	Puerto Deseado		0297- 487-0550  (447-2818  Com. Riv )	\N		\N	\N		t	\N	\N	\N
f0ee83f6-4b2e-4222-bece-dac5ac4cbf5d	INFINITUS PEZ	01472	\N	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	\N	\N	24918e15-e968-484f-b31e-dc786b5f9ec2	GIORNO  S.A.	Mar del Plata		410-0051 / 0057	\N		\N	\N		t	\N	\N	\N
5211c510-fa64-4c08-9644-d512c3669335	INITIO PEZ	01471	\N	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	\N	\N	24918e15-e968-484f-b31e-dc786b5f9ec2	GIORNO  S.A.	Mar del Plata	4800005	410-0051 / 0057	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi	t	\N	\N	\N
498aef6e-12e4-4207-9259-6a97ac789237	ITXAS LUR	0927	1735	6a95076f-aec1-4941-b231-92dfbc802cb7	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	60	63.30	1952	24918e15-e968-484f-b31e-dc786b5f9ec2	HISPANO PATAGONICA  S.A.	Mar del Plata		480-1002 / 489-3165 / 489-7144	\N		\N	\N		t	\N	\N	\N
e738eec3-c924-42f1-be27-2ade988905be	JOLUMA	5403	\N	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	\N	\N	24918e15-e968-484f-b31e-dc786b5f9ec2	ARDAPEZ  S.A.	Mar del Plata	4800005	480-1561 / 480-1568 / 480-1549	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
376affbd-91af-4476-98e5-f8a577904a8b	JOSÉ AMÉRICO	03071	2756	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	44.21	0	24918e15-e968-484f-b31e-dc786b5f9ec2	PEDRO MOSCUZZA e HIJOS  S.A.	Mar del Plata		489-7287	\N		\N	\N		t	\N	\N	\N
8807bb9d-2263-471d-8701-f124291ba548	JOSE LUIS ALVAREZ	0618	\N	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	\N	\N	a48e3d60-bea0-4828-8099-3debb447f631	PESQUERA SAN ISIDRO S.A.	Puerto Madryn		0280-447-2697	\N		\N	\N		t	\N	\N	\N
228d87cf-d7e9-4c8b-8d11-ec933731f98e	JOSE MARCELO	3138	2764	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	39.94	0	24918e15-e968-484f-b31e-dc786b5f9ec2	PEDRO MOSCUZZA e HIJOS  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
fc9371a3-ea11-4343-ba1d-08bee0b4cfd2	JUAN ALVAREZ	0619	1755	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	36.60	1168	a48e3d60-bea0-4828-8099-3debb447f631	PESQUERA SAN ISIDRO S.A.	Puerto Madryn		0280-447-2697	\N		\N	\N		t	\N	\N	\N
982d7df4-5b3b-4cea-bd69-82f0432bfb4a	JUAN PABLO II	02695	0	15652b63-0efc-4059-ad8a-36de68d64a35	9bda293b-e1b2-4bd2-9b2c-d34743032f06	\N	8	22.49	326	\N	ISLA DE LOS ESTADOS  S.A.	Vivoratá			\N		\N	\N		t	\N	\N	\N
8ef96161-1a07-4b59-b925-5d2d521bd80f	JUDITH I	0908	\N	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	\N	\N	24918e15-e968-484f-b31e-dc786b5f9ec2	ANTONIO BARILLARI  S.A.	Mar del Plata		481-1173  / 489-0872	\N		\N	\N		t	\N	\N	\N
04eca0a2-fc6e-4186-825e-0de4fda81bb2	JUEVES SANTO	0667	1762	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	39.50	1244	26cb8962-0318-4dfe-a961-1b84a6ce6302	NUVCONSA  S.A.	Ciudad Autónoma de Buenos Aires	4891553-154179360-154179860-154179062	011-4305-4706	\N	agenciasmiriglio@speedy.com.ar	\N	\N	Agencia Maritima Smiriglio	t	\N	\N	\N
4ab57439-b374-4c8b-a741-e21915db8b46	JUPITER II	0406	1769	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	27.90	791	24918e15-e968-484f-b31e-dc786b5f9ec2	VENUS  PESQUERA S.R.L.	Mar del Plata	4800005	489-0186	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
d68de017-6fa9-41a8-ba84-fcbc2d0df5cc	KALEU KALEU	01963	\N	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	\N	\N	26cb8962-0318-4dfe-a961-1b84a6ce6302	KALEU KALEU  S.A.	Ciudad Autónoma de Buenos Aires	4800005	011-3220-2130  / 5093-1215	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi	t	\N	\N	\N
e7fe5cac-c3b1-45ad-b0f2-479a0106092c	KANTXOPE	01065	\N	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	\N	\N	24918e15-e968-484f-b31e-dc786b5f9ec2	ANTONIO BARILLARI  S.A.	Mar del Plata		481-1173  / 489-0872	\N		\N	\N		t	\N	\N	\N
07ce17f6-a6b3-4637-a0b3-74aa2af87346	KARINA	01462	\N	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	\N	\N	24918e15-e968-484f-b31e-dc786b5f9ec2	FRIGORIFICO DON LUIS  S.R.L.	Mar del Plata		489-4645	\N		\N	\N		t	\N	\N	\N
da7fa1d1-4603-4298-bc62-8069c57563bf	LAIA	06521	0	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	53.00	1185	26cb8962-0318-4dfe-a961-1b84a6ce6302	PESQUERA MADRYN  S.A.	Ciudad Autónoma de Buenos Aires		011-4394-1452	\N		\N	\N		t	\N	\N	\N
d6a5c293-c028-46e3-85fd-dc94f3045288	LANZA SECA	01181	1852	\N	\N	\N	0	24.80	514	24918e15-e968-484f-b31e-dc786b5f9ec2	LANZAMAR  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
0f0ba484-1bbd-4c2e-a270-fc9389eabcf5	LATINA  N° 8	0291	\N	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	\N	\N	f05d47aa-ffad-4c48-99f2-39015dc0159a	ARGENOVA  S.A.	Puerto Deseado		0297- 487-0550  (447-2818  Com. Riv )	\N		\N	\N		t	\N	\N	\N
ec327286-0175-49fe-98b4-b5f54b7a146e	LEAL	0143	1863	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	27.45	601	24918e15-e968-484f-b31e-dc786b5f9ec2	PESQUERA LEAL  S.A.	Mar del Plata		489-4624 / 489-0314 (astillero )	\N		\N	\N		t	\N	\N	\N
1c4ad8e2-2d20-4eb6-ab87-80495425ba31	LEKHAN I	00752	1865	15652b63-0efc-4059-ad8a-36de68d64a35	9bda293b-e1b2-4bd2-9b2c-d34743032f06	\N	8	18.45	530	24918e15-e968-484f-b31e-dc786b5f9ec2	LEKHAN I  S.R.L.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
492b03d8-125d-4fea-88b2-d1b986d074a0	LIBERTAD DEL MAR 1°	02186	\N	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	\N	\N	24918e15-e968-484f-b31e-dc786b5f9ec2	TATURIELLO  S.A.	Mar del Plata		489-3833	\N		\N	\N		t	\N	\N	\N
6457cc4f-5e2a-44f7-80e3-ec68d1f9e378	LING SHUI N° 3	02210	\N	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	\N	\N	26cb8962-0318-4dfe-a961-1b84a6ce6302	MUELLE OCHO  S.A.	Ciudad Autónoma de Buenos Aires		011-4381-1337	\N		\N	\N		t	\N	\N	\N
58fd0dfb-c7f5-4c38-9462-05e609614f9b	LING SHUI N° 5	02211	\N	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	\N	\N	26cb8962-0318-4dfe-a961-1b84a6ce6302	MUELLE OCHO  S.A.	Ciudad Autónoma de Buenos Aires		011-4381-1337	\N		\N	\N		t	\N	\N	\N
2efdc2cd-8105-4bde-956d-37ec4d99b7be	LUIGI	3244	\N	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	\N	\N	24918e15-e968-484f-b31e-dc786b5f9ec2	LUIS SOLIMENO e HIJOS  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
04bfdbb4-a7bc-49a6-9786-648b581a3c47	LUCA MARIO	0546	2715	6a95076f-aec1-4941-b231-92dfbc802cb7	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	60	79.14	3952	24918e15-e968-484f-b31e-dc786b5f9ec2	PESCASOL  S.A.	Mar del Plata	4800274	480-9608 / 481-0464	\N	amalfitanoycia@hotmail.com	\N	\N	Agencia Maritima Almafitano	t	\N	\N	\N
48c5340f-a868-454d-9557-db46091f8c02	LUCA SANTINO	3121	0	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	26.31	0	\N	CENTOMAR  S.A.				\N		\N	\N		t	\N	\N	\N
d96fde8a-86c3-4ede-8cab-dff943cea79c	LUCIA LUISA	0623	1897	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	27.90	463	24918e15-e968-484f-b31e-dc786b5f9ec2	PESQUERA VERAZ  S.A.	Mar del Plata		489-4624 / 489-0314 (astillero)	\N		\N	\N		t	\N	\N	\N
e4afd9df-9b28-40a7-b30c-8226b728af43	LUNES SANTO	01132	\N	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	\N	\N	a48e3d60-bea0-4828-8099-3debb447f631	IBERCONSA  DE ARGENTINA  S.A.	Puerto Madryn		0280-445-4324	\N		\N	\N		t	\N	\N	\N
b510a80d-b7fa-4a58-b146-463f5a02ad2f	MADONNINA DEL MARE	01112	1912	15652b63-0efc-4059-ad8a-36de68d64a35	9bda293b-e1b2-4bd2-9b2c-d34743032f06	\N	8	23.78	601	24918e15-e968-484f-b31e-dc786b5f9ec2	FABLED  S.A	Mar del Plata		480-1565	\N		\N	\N		t	\N	\N	\N
6034b7fb-a459-4f78-bdca-37e0b40c67e9	MADRE DIVINA	01556	1915	15652b63-0efc-4059-ad8a-36de68d64a35	9bda293b-e1b2-4bd2-9b2c-d34743032f06	\N	10	26.12	518	24918e15-e968-484f-b31e-dc786b5f9ec2	VUOSO HNOS. S.R.L.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
1119e9cd-7360-407f-a010-7cb1b975a063	HUAFENG 815	0554A	0	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	25.28	419	24918e15-e968-484f-b31e-dc786b5f9ec2	PESQUERA CHIARMAR S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
590cd413-5776-464a-af77-0e617afc6d86	MAGDALENA MARIA  II	02208	\N	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	\N	\N	24918e15-e968-484f-b31e-dc786b5f9ec2	ANTONIO BARILLARI  S.A.	Mar del Plata	4800005	481-1173  / 489-0872	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
98fae343-56e6-456e-a107-db453a717883	MALVINAS ARGENTINAS	0577	1931	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	28.40	458	24918e15-e968-484f-b31e-dc786b5f9ec2	PEDRO MOSCUZZA e HIJOS  S.A.	Mar del Plata		489-7287	\N		\N	\N		t	\N	\N	\N
ade0d4db-b8e6-4d98-aecd-b04eb3109cf8	MAR  AUSTRAL  I	0208	\N	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	\N	\N	f05d47aa-ffad-4c48-99f2-39015dc0159a	PESQUERA DESEADO  S.A.	Puerto Deseado		0297-487-0884 / 0327 / 2407	\N		\N	\N		t	\N	\N	\N
9331ed55-f020-4f2f-8300-2ec818634fc1	MAR AZUL	0934	\N	\N	\N	\N	\N	\N	\N	\N	CLARAMAR  S.A.		480-7779 - HERNAN		\N	agenciasenoransmdp@yahoo.com	\N	\N	Agencia Maritima SEÑORANS	t	\N	\N	\N
2d039831-ef8b-4178-a63d-a515909b156e	MAR DEL CHUBUT	0487	1944	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	28.20	721	24918e15-e968-484f-b31e-dc786b5f9ec2	ROMFIOC  SRL	Mar del Plata	4800005		\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi	t	\N	\N	\N
cf4bdc65-68fb-4bbf-a014-dc9f385e85ac	MAR ESMERALDA	0925	\N	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	\N	\N	24918e15-e968-484f-b31e-dc786b5f9ec2	ANTONIO BARILLARI  S.A.	Mar del Plata		481-1173  / 489-0872	\N		\N	\N		t	\N	\N	\N
2f4cdd55-d7de-4eb5-974b-37462c277493	MAR MARÍA	02960	2738	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	37.80	1248	26cb8962-0318-4dfe-a961-1b84a6ce6302	PESQUERA SANTA CRUZ  S.A.	Ciudad Autónoma de Buenos Aires		011-4305-4706	\N		\N	\N		t	\N	\N	\N
d57af27e-3217-49cc-ba64-5d55414673e2	MAR NOVIA 1	0115	\N	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	\N	\N	26cb8962-0318-4dfe-a961-1b84a6ce6302	CINCOMAR  S.A.	Ciudad Autónoma de Buenos Aires		011-4326-4991	\N		\N	\N		t	\N	\N	\N
26577d89-2256-40c7-bcad-3dee54528813	MAR NOVIA 2	0116	\N	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	\N	\N	26cb8962-0318-4dfe-a961-1b84a6ce6302	MIREMAR  S.A.	Ciudad Autónoma de Buenos Aires		011-4328-4963 / 4	\N		\N	\N		t	\N	\N	\N
34173232-2f69-4ab7-8108-0b3269c089e3	MAR SUR	0341	1957	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	36.40	889	26cb8962-0318-4dfe-a961-1b84a6ce6302	PESCARGEN  S.A.	Ciudad Autónoma de Buenos Aires		011-5219-0065 ó 5276-9499	\N		\N	\N		t	\N	\N	\N
c2993d3e-c97e-4260-819f-9dde303be036	MARA I	0210	1960	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	35.31	1209	a48e3d60-bea0-4828-8099-3debb447f631	PESCAPUERTA ARGENTINA  S.A.	Puerto Madryn		0280-445-4407	\N		\N	\N		t	\N	\N	\N
78f3fdd9-4f6c-4812-b048-2d6b0331e14b	MARA II	0209	\N	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	\N	\N	a48e3d60-bea0-4828-8099-3debb447f631	PESCAPUERTA ARGENTINA  S.A.	Puerto Madryn		0280-445-4407	\N		\N	\N		t	\N	\N	\N
a00987df-da55-4ca7-a6ca-28e117943fe6	MARBELLA	01073	1966	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	27.38	736	24918e15-e968-484f-b31e-dc786b5f9ec2	MAR DE MESSINA  S.A.	Mar del Plata	beagle1	489-3824	\N		\N	\N		t	\N	\N	\N
20681abb-03e5-47d9-a9ad-258205c3c3d0	MARCALA I	0532	\N	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	\N	\N	24918e15-e968-484f-b31e-dc786b5f9ec2	PESANFLOR  S.A.	Mar del Plata		489-6522	\N		\N	\N		t	\N	\N	\N
68e6a13e-037b-4560-beab-74588d80c42d	MARCALA IV	0351	\N	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	\N	\N	26cb8962-0318-4dfe-a961-1b84a6ce6302	MARCALA  S.A.	Ciudad Autónoma de Buenos Aires		011-4342-9601 / 4283	\N		\N	\N		t	\N	\N	\N
f8710abb-6ccc-4d21-917a-fce11903a216	MAREJADA	01107	1974	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	27.98	624	24918e15-e968-484f-b31e-dc786b5f9ec2	VICARP  S.A.	Mar del Plata		480-4378	\N		\N	\N		t	\N	\N	\N
6a458f7f-fb8a-490f-b3dd-1b9bee58506b	MARIA  EUGENIA	01173	\N	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	\N	\N	24918e15-e968-484f-b31e-dc786b5f9ec2	PEDRO MOSCUZZA e HIJOS  S.A.	Mar del Plata		489-7287	\N		\N	\N		t	\N	\N	\N
a8b79c20-2e95-4c3b-a9f4-746144ada4ee	HUAFENG 816	05994	0	15652b63-0efc-4059-ad8a-36de68d64a35	9bda293b-e1b2-4bd2-9b2c-d34743032f06	\N	4	22.60	521	24918e15-e968-484f-b31e-dc786b5f9ec2	COSTA BRAVA  S.A.	Mar del Plata	4800005	489-7538	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
0ccf2985-328e-4338-9b38-09938c60dafa	MARIA  LILIANA	01174	\N	6a95076f-aec1-4941-b231-92dfbc802cb7	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	60	\N	\N	24918e15-e968-484f-b31e-dc786b5f9ec2	PEDRO MOSCUZZA e HIJOS  S.A.	Mar del Plata	4893758	489-7287	\N	miguel-visoso@hotmail.com	\N	\N	Agencia Maritima Solvox	t	\N	\N	\N
9db69f7e-6de3-429b-b876-c2d1058bc55f	MARIA RITA	0436	2000	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	30.95	541	24918e15-e968-484f-b31e-dc786b5f9ec2	BAL - FISH  S.A.	Mar del Plata		489-6522	\N		\N	\N		t	\N	\N	\N
b3915f6d-38c3-4006-a165-311b366842f5	MARIA ALEJANDRA 1º	03074	2750	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	39.20	0	24918e15-e968-484f-b31e-dc786b5f9ec2	XEITOSIÑO S.A.	Mar del Plata		410-0051 / 7	\N		\N	\N		t	\N	\N	\N
18189b1e-f5e2-40e8-a54e-c070ed080540	MARIA DEL VALLE	02126	1986	15652b63-0efc-4059-ad8a-36de68d64a35	9bda293b-e1b2-4bd2-9b2c-d34743032f06	\N	4	16.29	196	18318dd2-cbb1-42cb-8aa0-f6f2c1f945bd	FARO CHUBUT  S.R.L.	Rawson		0280-449-6311	\N		\N	\N		t	\N	\N	\N
5f1ad02c-f61e-45a2-86ba-fb11b28276a8	MARIA GLORIA	02738	2763	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	28.05	851	24918e15-e968-484f-b31e-dc786b5f9ec2	CAYO LARGO  S.A.	Mar del Plata		480-4378	\N		\N	\N		t	\N	\N	\N
fccacfe7-f6ce-476d-ae25-60f6ac13f726	MARIANELA	01002	2007	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	25.60	541	24918e15-e968-484f-b31e-dc786b5f9ec2	AGLIANO  SRL	Mar del Plata		480-2886	\N		\N	\N		t	\N	\N	\N
fa880b0c-fbbd-43ea-902d-2dda1c136376	MARTA S	01001	0	15652b63-0efc-4059-ad8a-36de68d64a35	9bda293b-e1b2-4bd2-9b2c-d34743032f06	\N	8	23.90	503	24918e15-e968-484f-b31e-dc786b5f9ec2	WERZOWA  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
b55dae3f-a4d7-4d7e-8883-eccabc2f8c2c	MATACO II	02243	\N	6a95076f-aec1-4941-b231-92dfbc802cb7	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	60	\N	\N	a48e3d60-bea0-4828-8099-3debb447f631	HAMALTAL  S.A.	Puerto Madryn	4800005	0280-445-0822	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
42cd5d3b-d0e1-408a-942f-c042e13bab48	MATEO I	02172	2028	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	67.97	1776	26cb8962-0318-4dfe-a961-1b84a6ce6302	KALEU KALEU  S.A.	Ciudad Autónoma de Buenos Aires		011-3220-2130  / 5093-1215	\N		\N	\N		t	\N	\N	\N
774fc9e3-1faf-4a9f-a025-5b6e45a9cbbc	MELLINO I	0379	2032	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	47.25	1185	24918e15-e968-484f-b31e-dc786b5f9ec2	GIORNO  S.A.	Mar del Plata		410-0051 / 0057	\N		\N	\N		t	\N	\N	\N
a4e89262-427d-492f-9e5d-038aee161079	MELLINO II	01424	0	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	38.91	795	24918e15-e968-484f-b31e-dc786b5f9ec2	GIORNO  S.A.	Mar del Plata	AVENIDA DE LOS PESCADORES 195	410-0051 / 0057	\N		\N	\N	Agencia AMALFITANO	t	\N	\N	\N
add85a6e-a9de-4092-88ca-f46f65036bd9	MELLINO VI	0378	2034	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	64.87	1235	24918e15-e968-484f-b31e-dc786b5f9ec2	GIORNO  S.A.	Mar del Plata		410-0051 / 0057	\N		\N	\N		t	\N	\N	\N
f3006f0d-7ffc-4a48-94e9-02972752499d	MERCEA C	0318	2036	\N	\N	\N	0	29.15	866	24918e15-e968-484f-b31e-dc786b5f9ec2	ALLELOCCIC  S.A.	Mar del Plata		495-4467 / 480-8565	\N		\N	\N		t	\N	\N	\N
0d1ec41a-e8a4-4dc8-9ad7-7d0cf45c0f30	MESSINA I	01089	2038	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	27.29	650	24918e15-e968-484f-b31e-dc786b5f9ec2	MAR DE MESSINA  S.A.	Mar del Plata		489-3824	\N		\N	\N		t	\N	\N	\N
2a369a1b-a593-49eb-a023-5973e64d97ba	MEVIMAR	01508A	\N	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	\N	\N	a48e3d60-bea0-4828-8099-3debb447f631	RIMINIMARR  S.A.	Puerto Madryn		0280-445-2248	\N		\N	\N		t	\N	\N	\N
67f3ff37-709c-4bfb-b5f2-e13a9045184a	MIERCOLES SANTO	0666	2041	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	38.50	1244	26cb8962-0318-4dfe-a961-1b84a6ce6302	NUVCONSA  S.A.	Ciudad Autónoma de Buenos Aires		011-4305-4706	\N		\N	\N		t	\N	\N	\N
04cc80ec-a303-4872-8c7a-7b62dbaec2cd	VICTOR ANGELESCU	9798820	\N	65029fa6-99f0-445f-9613-176773c55dca	\N	\N	\N	\N	\N	\N	INIDEP				\N		\N	\N		t	\N	\N	\N
a7b4b686-b768-47ee-94c7-1c7a08794d2b	MADRE MARGARITA	02728	0	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	25.60	541	24918e15-e968-484f-b31e-dc786b5f9ec2	PESQUERA  MARGARITA  S.A.	Mar del Plata		489-4645   /   489-2946	\N		\N	\N		t	\N	\N	\N
c7a080f5-a400-47aa-addc-c4c4b9fb231f	NINA	3171	2770	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	44.00	1620	\N	PEDRO MOSCUZZA e HIJOS  S.A.				\N		\N	\N		t	\N	\N	\N
154ac509-9b6b-455f-881c-a59d0cbf2e7a	MINTA	02196	2050	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	65.10	1603	26cb8962-0318-4dfe-a961-1b84a6ce6302	LIYA  S.A.	Ciudad Autónoma de Buenos Aires		011-4964-2227	\N		\N	\N		t	\N	\N	\N
e55145bc-267d-425e-a42b-688f46b24876	MIRIAM	0370	2051	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	36.35	1446	26cb8962-0318-4dfe-a961-1b84a6ce6302	VIEIRA ARGENTINA  S.A.	Ciudad Autónoma de Buenos Aires	4800005		\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi	t	\N	\N	\N
33f4592a-ad4c-4963-8b92-078ed8b60f11	MISHIMA MARU N°8	02175	2054	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	63.43	1579	24918e15-e968-484f-b31e-dc786b5f9ec2	BAL - FISH  S.A.	Mar del Plata	4800274	489-6522	\N	amalfitanoycia@hotmail.com	\N	\N	Agencia Maritima Almafitano	t	\N	\N	\N
3059e444-2a0b-4ef8-9c39-0e135c0c8755	MISS TIDE	02439	2056	2966881e-e368-4b60-958d-683c71ed8609	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	9d02d029-f003-41b6-89de-0eea18b2d4e4	30	52.52	2254	24918e15-e968-484f-b31e-dc786b5f9ec2	WANCHESE ARGENTINA  S.A.	Mar del Plata		489-1236	\N		\N	\N		t	\N	\N	\N
73104b6b-bd08-4489-9b08-9776d887b645	MISTER BIG	0534	\N	2966881e-e368-4b60-958d-683c71ed8609	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	9d02d029-f003-41b6-89de-0eea18b2d4e4	30	\N	\N	24918e15-e968-484f-b31e-dc786b5f9ec2	WANCHESE ARGENTINA  S.A.	Mar del Plata		489-1236	\N		\N	\N		t	\N	\N	\N
5a3895b8-ff39-470b-8814-5ed1046ba2e7	MIURA MARU	05996	2058	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	53.20	1482	26cb8962-0318-4dfe-a961-1b84a6ce6302	LIYA  S.A.	Ciudad Autónoma de Buenos Aires		011-4964-2227	\N		\N	\N		t	\N	\N	\N
9857322c-3987-43a8-a722-b19f8dc56812	MONTE DE VIOS	0664	\N	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	\N	\N	26cb8962-0318-4dfe-a961-1b84a6ce6302	PESQUERA SANTA CRUZ  S.A.	Ciudad Autónoma de Buenos Aires		011-4305-4706	\N		\N	\N		t	\N	\N	\N
347cfcc4-0ea6-448c-8041-f8d5035ccd0b	MYRDOMA F	02771	2735	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	38.55	1430	a48e3d60-bea0-4828-8099-3debb447f631	LANZAR S.A.	Puerto Madryn	4800005	0280-445-6280	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
970bca10-24df-4db6-b63f-de24f2f15d4d	NANINA	02576	2073	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	72.08	1678	24918e15-e968-484f-b31e-dc786b5f9ec2	PEDRO MOSCUZZA e HIJOS  S.A.	Mar del Plata	4800005	489-7287	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
9a6204b6-657f-4a1c-a75c-bd5358e5b6b7	NATALIA	02066	2075	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	68.45	1779	24918e15-e968-484f-b31e-dc786b5f9ec2	PEDRO MOSCUZZA e HIJOS  S.A.	Mar del Plata		489-7287	\N		\N	\N		t	\N	\N	\N
b37c76a2-6802-4fd9-a24e-1ec404d60aa3	NAVEGANTES	0542	2079	6a95076f-aec1-4941-b231-92dfbc802cb7	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	60	58.00	1925	24918e15-e968-484f-b31e-dc786b5f9ec2	PESQUERA COMERCIAL  S.A.	Mar del Plata		489-3030	\N		\N	\N		t	\N	\N	\N
cd6c61cc-5732-4738-ba07-aa23efa93631	NAVEGANTES II	01451	2080	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	63.70	1603	24918e15-e968-484f-b31e-dc786b5f9ec2	PESQUERA COMERCIAL  S.A.	Mar del Plata		489-3030	\N		\N	\N		t	\N	\N	\N
28314d73-74c9-4176-93ce-074507566cc3	NAVEGANTES III	02065	2081	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	68.60	2203	24918e15-e968-484f-b31e-dc786b5f9ec2	PESQUERA COMERCIAL  S.A.	Mar del Plata	4800274	489-3030	\N	amalfitanoycia@hotmail.com	\N	\N	Agencia Maritima Almafitano	t	\N	\N	\N
8578900e-12d4-4b9a-8de8-58d5f80bbef5	NDDANDDU	0141	2082	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	28.20	856	24918e15-e968-484f-b31e-dc786b5f9ec2	PESQUERA VERAZ  S.A.	Mar del Plata		489-4624 / 489-0314 (astillero)	\N		\N	\N		t	\N	\N	\N
d4b5eea1-a5b8-4c95-9fbc-653ed429bf61	NEPTUNIA I	02125	\N	15652b63-0efc-4059-ad8a-36de68d64a35	9bda293b-e1b2-4bd2-9b2c-d34743032f06	\N	4	\N	\N	18318dd2-cbb1-42cb-8aa0-f6f2c1f945bd	FLOTA AMARILLA RAWSON	Rawson	4891553-154179360-154179860-154179062		\N	agenciasmiriglio@speedy.com.ar	\N	\N	Agencia Maritima SMIRIGLIO	t	\N	\N	\N
de509aac-4e69-4093-b416-0409d5cad35c	NIÑO JESUS DE PRAGA	3194	2775	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	27.74	1180	24918e15-e968-484f-b31e-dc786b5f9ec2	RITORNO SALLUSTIO Y CICCIOTTI  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
718be8c9-0022-4f00-b382-2e9c30d751e6	NONO PASCUAL	02854	2729	15652b63-0efc-4059-ad8a-36de68d64a35	9bda293b-e1b2-4bd2-9b2c-d34743032f06	\N	10	24.00	451	24918e15-e968-484f-b31e-dc786b5f9ec2	CANAL DE BEAGLE  S.R.L.	Mar del Plata		480-4447 / 5004265 PASCUAL	\N		\N	\N		t	\N	\N	\N
81b93cb0-a725-49d7-b7f5-476229a6873f	NUEVA LUCIA MADRE	01501	2113	15652b63-0efc-4059-ad8a-36de68d64a35	9bda293b-e1b2-4bd2-9b2c-d34743032f06	\N	8	14.37	416	24918e15-e968-484f-b31e-dc786b5f9ec2	NUEVA LUCIA MADRE  S.R.L.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
9904be42-175c-459e-ae19-c7493b6faa05	NUEVA NEPTUNIA I	02634	0	15652b63-0efc-4059-ad8a-36de68d64a35	9bda293b-e1b2-4bd2-9b2c-d34743032f06	\N	4	20.00	403	18318dd2-cbb1-42cb-8aa0-f6f2c1f945bd	ORION S.R.L.	Rawson			\N		\N	\N		t	\N	\N	\N
4fc45b14-6fc0-4d2d-8eb3-2c8a965ee5f4	NUEVO ANITA	02100	2128	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	30.90	765	a48e3d60-bea0-4828-8099-3debb447f631	IBERCONSA  DE ARGENTINA  S.A.	Puerto Madryn		0280-445-4324	\N		\N	\N		t	\N	\N	\N
44fcdbb0-ba81-4e89-bb59-e4c2de512d4e	NUEVO VIENTO	01449	2135	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	22.23	541	24918e15-e968-484f-b31e-dc786b5f9ec2	NUEVO VIENTO  SRL	Mar del Plata		480-8565	\N		\N	\N		t	\N	\N	\N
c6515e63-bdd8-46b6-bde9-5fca5888b489	OMEGA 3	01391	\N	15652b63-0efc-4059-ad8a-36de68d64a35	9bda293b-e1b2-4bd2-9b2c-d34743032f06	\N	10	\N	\N	24918e15-e968-484f-b31e-dc786b5f9ec2	COSTA BRAVA  S.A.	Mar del Plata		489-7538	\N		\N	\N		t	\N	\N	\N
e221542b-6e94-4ffa-a619-92a62ff19366	ORION  2	01492	\N	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	\N	\N	26cb8962-0318-4dfe-a961-1b84a6ce6302	PESQUERA SANTA CRUZ  S.A.	Ciudad Autónoma de Buenos Aires		011-4305-4706	\N		\N	\N	norberto.lopez@iberconsa.com	t	\N	\N	\N
02bf5d77-3784-4433-bd1d-b32c07886900	ORION 5	02637	2757	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	65.62	1776	26cb8962-0318-4dfe-a961-1b84a6ce6302	PESQUERA SANTA CRUZ  S.A.	Ciudad Autónoma de Buenos Aires		011-4305-4706	\N		\N	\N		t	\N	\N	\N
4b3473be-16d5-4beb-bebc-14ed577d21c8	ORION I	01943A	0	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	20.90	520	26cb8962-0318-4dfe-a961-1b84a6ce6302	PESQUERA CRUZ DEL SUR  S.A.	Ciudad Autónoma de Buenos Aires		011-4784-1760	\N		\N	\N		t	\N	\N	\N
391fc3fb-5ae9-49c7-ac36-19eb90db27d3	ORION 1	01943	\N	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	\N	\N	26cb8962-0318-4dfe-a961-1b84a6ce6302	PESQUERA SANTA CRUZ  S.A.	Ciudad Autónoma de Buenos Aires		011-4305-4706	\N		\N	\N		t	\N	\N	\N
e6bd3b48-f277-47c8-8ba3-df38cf698bc0	ORION 3	02167	2170	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	63.10	1776	26cb8962-0318-4dfe-a961-1b84a6ce6302	PESQUERA SANTA CRUZ  S.A.	Ciudad Autónoma de Buenos Aires		011-4305-4706	\N		\N	\N		t	\N	\N	\N
efe49654-f944-4ee0-a484-96fcc74b0905	ORYONG  756	02092	\N	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	\N	\N	a48e3d60-bea0-4828-8099-3debb447f631	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
685cc809-39f9-4e09-88a2-ef96728bbd89	PACHACA	02572	2180	15652b63-0efc-4059-ad8a-36de68d64a35	9bda293b-e1b2-4bd2-9b2c-d34743032f06	\N	4	17.64	320	18318dd2-cbb1-42cb-8aa0-f6f2c1f945bd	FLOTA AMARILLA RAWSON	Rawson			\N		\N	\N		t	\N	\N	\N
698b1d35-8e1c-4bbf-b5c9-7162c189cfef	PADRE PIO	02822	2737	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	24.00	451	24918e15-e968-484f-b31e-dc786b5f9ec2	RITORNO SALLUSTIO Y CICCIOTTI  S.A.	Mar del Plata		480-5508	\N		\N	\N		t	\N	\N	\N
bcf1eb1f-1aec-4291-8a96-86f8712bc7af	PAGRUS II	01393	\N	15652b63-0efc-4059-ad8a-36de68d64a35	9bda293b-e1b2-4bd2-9b2c-d34743032f06	\N	4	\N	\N	24918e15-e968-484f-b31e-dc786b5f9ec2	COSTA BRAVA  S.A.	Mar del Plata		489-7538	\N		\N	\N		t	\N	\N	\N
3541b053-2ad6-4c3f-9b7f-a151f688d7cc	PAKU	0250	2186	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	39.16	1087	24918e15-e968-484f-b31e-dc786b5f9ec2	LUIS SOLIMENO e HIJOS  S.A.	Mar del Plata		489-3030	\N		\N	\N		t	\N	\N	\N
873216e6-ebc7-4597-92e5-e7de059d8a9a	PALOMA V	64	\N	d2217eec-a161-4143-9a47-007bc8afc75e	3a970316-23f2-4026-8bcc-dcc696e4f1f6	573af89c-fbee-4643-b922-7b69926c208d	60	\N	\N	\N					\N		\N	\N		t	\N	\N	\N
360953a9-ec36-4415-9a56-0a786a6bf537	MINCHOS OCTAVO	03022	2744	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	39.30	579	a48e3d60-bea0-4828-8099-3debb447f631	IBERCONSA  DE ARGENTINA  S.A.	Puerto Madryn		0280-445-4324	\N		\N	\N		t	\N	\N	\N
fae7a73e-b46a-4704-9278-af871699e6eb	PATAGONIA 2	02164	\N	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	\N	\N	26cb8962-0318-4dfe-a961-1b84a6ce6302	PATAGONIA  FISHING  S.A.	Ciudad Autónoma de Buenos Aires		011-4932-2777	\N		\N	\N		t	\N	\N	\N
aa60f8bb-4209-49bd-bfef-7010789a7400	PEDRITO	TEMP-0005	0	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	\N	39.92	1201	\N					\N		\N	\N		t	\N	\N	\N
361a58b8-7730-4f11-acd1-df76267e48d8	PELAGOS	83	\N	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	\N	\N	a48e3d60-bea0-4828-8099-3debb447f631	PESQUERA SAN ISIDRO S.A.	Puerto Madryn		0280-447-2697	\N		\N	\N		t	\N	\N	\N
95430c61-a9f3-484d-8c9b-d2b2c0b4abba	PENSACOLA I	0747	2207	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	25.20	380	747eb90c-4eaf-451e-999f-759163bc918c	FRANGELA  S.A.	Comodoro Rivadavia			\N		\N	\N		t	\N	\N	\N
cb69f571-efec-4a51-b046-d3c5f87e4a80	PESCAPUERTA CUARTO	0171	\N	6a95076f-aec1-4941-b231-92dfbc802cb7	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	60	\N	\N	a48e3d60-bea0-4828-8099-3debb447f631	PESCAPUERTA ARGENTINA  S.A.	Puerto Madryn		0280-445-4407	\N		\N	\N		t	\N	\N	\N
0eea3d9f-d2da-4ea8-b6ec-03e26998ceb6	PESCAPUERTA QUINTO	0538	\N	975bf25c-1d6d-4101-9c5d-abe95e0a6978	9bda293b-e1b2-4bd2-9b2c-d34743032f06	a05ae304-2d0e-4e29-a6f3-fa7372a41c97	60	\N	\N	a48e3d60-bea0-4828-8099-3debb447f631	PESCAPUERTA ARGENTINA  S.A.	Puerto Madryn		0280-445-4407	\N		\N	\N		t	\N	\N	\N
d19d4957-59ff-420c-b022-034fa001ac1a	PESCARGEN  V	078	\N	6a95076f-aec1-4941-b231-92dfbc802cb7	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	60	\N	\N	26cb8962-0318-4dfe-a961-1b84a6ce6302	PESCARGEN  S.A.	Ciudad Autónoma de Buenos Aires		011-5219-0065 ó 5276-9499	\N		\N	\N		t	\N	\N	\N
a528b339-e243-4982-9cad-4686da7aba2b	PESCARGEN III	021	\N	6a95076f-aec1-4941-b231-92dfbc802cb7	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	60	\N	\N	26cb8962-0318-4dfe-a961-1b84a6ce6302	PESCARGEN  S.A.	Ciudad Autónoma de Buenos Aires		011-5219-0065 ó 5276-9499	\N		\N	\N		t	\N	\N	\N
ce1d8eb0-50ff-4fb1-b1e1-16fc00e7d96c	PESCARGEN IV	0150	2217	6a95076f-aec1-4941-b231-92dfbc802cb7	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	60	63.20	1603	26cb8962-0318-4dfe-a961-1b84a6ce6302	PESCARGEN  S.A.	Ciudad Autónoma de Buenos Aires		011-5219-0065 ó 5276-9499	\N		\N	\N		t	\N	\N	\N
24a2631e-a68c-453b-a189-36461ebcc6b9	PESPASA  II	0212	\N	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	\N	\N	f05d47aa-ffad-4c48-99f2-39015dc0159a	PESPASA  S.A.	Puerto Deseado		0297-487-2030  int 12	\N		\N	\N		t	\N	\N	\N
1df85405-6cb0-4be2-9813-463881dba483	PESPASA I	0211	\N	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	\N	\N	f05d47aa-ffad-4c48-99f2-39015dc0159a	PESPASA  S.A.	Puerto Deseado		0297-487-2030  int 12	\N		\N	\N		t	\N	\N	\N
9d02ba3e-4105-4c2a-a6c7-176c5fa4aeda	PETREL	01445	2224	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	29.85	776	24918e15-e968-484f-b31e-dc786b5f9ec2	OLAMAR  S.A.	Mar del Plata		480-3573	\N		\N	\N		t	\N	\N	\N
c298cccd-01a2-401a-9859-5d3c832d7790	PEVEGASA QUINTO	02312	2225	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	38.65	740	26cb8962-0318-4dfe-a961-1b84a6ce6302	PUNTA BUSTAMANTE  S.A.	Ciudad Autónoma de Buenos Aires		011-4305-4710 / 4712	\N		\N	\N		t	\N	\N	\N
6b31f97f-8059-4932-8de7-b0a4356386ae	PIONEROS	02735	\N	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	\N	\N	24918e15-e968-484f-b31e-dc786b5f9ec2	CALME  S.A.	Mar del Plata		480-3545	\N		\N	\N		t	\N	\N	\N
fbbb5a7d-6d83-4d87-995d-ac89d690db9f	POLARBORG I	02122	\N	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	\N	\N	26cb8962-0318-4dfe-a961-1b84a6ce6302	GRINFIN  S.A.	Ciudad Autónoma de Buenos Aires		011-4343-5626	\N		\N	\N		t	\N	\N	\N
a533e494-11c0-4d58-a0ee-5f793ae756b2	POLARBORG II	02117	\N	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	\N	\N	26cb8962-0318-4dfe-a961-1b84a6ce6302	GRINFIN  S.A.	Ciudad Autónoma de Buenos Aires	4800005	011-4343-5626	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi	t	\N	\N	\N
94631cdf-591c-4e0e-acb2-c2a28967ab82	PONTE CORUXO	0975	2242	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	52.85	1383	24918e15-e968-484f-b31e-dc786b5f9ec2	BAL - FISH  S.A.	Mar del Plata		489-6522	\N		\N	\N		t	\N	\N	\N
37e698c7-669a-482c-9a07-6b5b5a0b4dcc	PONTE DE RANDE	0244	2243	6a95076f-aec1-4941-b231-92dfbc802cb7	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	60	79.14	2964	24918e15-e968-484f-b31e-dc786b5f9ec2	COSTA MARINA  S.A.	Mar del Plata		480-9608 / 481-0464	\N		\N	\N		t	\N	\N	\N
04b2d755-cec1-4a70-93fc-e5a646d7ef7d	PORTO BELO I	02699	2736	15652b63-0efc-4059-ad8a-36de68d64a35	9bda293b-e1b2-4bd2-9b2c-d34743032f06	\N	8	23.98	600	24918e15-e968-484f-b31e-dc786b5f9ec2	FARO RECALADA  S.A	Mar del Plata		480-2442	\N		\N	\N		t	\N	\N	\N
5e9cef3e-8e8f-44cb-817c-9ca6e7e3b9a4	PORTO BELO II	02790	2728	15652b63-0efc-4059-ad8a-36de68d64a35	9bda293b-e1b2-4bd2-9b2c-d34743032f06	\N	10	23.98	601	24918e15-e968-484f-b31e-dc786b5f9ec2	MARITIMA PORTO BELO  S.A.	Mar del Plata		489-1553	\N		\N	\N		t	\N	\N	\N
6588b8c1-17e4-471a-82fa-f81b6044e0e5	PRINCIPE AZUL	TEMP-0006	\N	15652b63-0efc-4059-ad8a-36de68d64a35	9bda293b-e1b2-4bd2-9b2c-d34743032f06	\N	10	\N	\N	24918e15-e968-484f-b31e-dc786b5f9ec2		Mar del Plata			\N		\N	\N		t	\N	\N	\N
1570029d-6356-4071-8fff-09d9dcc69250	PROMAC	4815	2257	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	33.45	721	24918e15-e968-484f-b31e-dc786b5f9ec2	LUIS SOLIMENO e HIJOS  S.A.	Mar del Plata		489-3030	\N		\N	\N		t	\N	\N	\N
9d642819-b748-4ac5-81fe-71dfeff75a73	PROMARSA I	072	\N	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	\N	\N	a48e3d60-bea0-4828-8099-3debb447f631	ALPESCA  S.A.	Puerto Madryn		0280-447-4958 / 45-1069	\N		\N	\N		t	\N	\N	\N
f8b0b473-cac2-4447-b8ad-b3363a9f9efa	PROMARSA II	073	\N	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	\N	\N	a48e3d60-bea0-4828-8099-3debb447f631	ALPESCA  S.A.	Puerto Madryn		0280-447-4958 / 45-1069	\N		\N	\N		t	\N	\N	\N
146f1ece-bc53-48ae-a98b-3daa0ff4e273	PROMARSA III	02096	0	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	35.84	1062	a48e3d60-bea0-4828-8099-3debb447f631	ALPESCA  S.A.	Puerto Madryn		0280-447-4958 / 45-1069	\N		\N	\N		t	\N	\N	\N
c0ef5db9-8050-4de3-9a97-6ae52b3ae807	PUENTE VALDES	02205	2266	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	58.15	1383	a48e3d60-bea0-4828-8099-3debb447f631	PEREIRA  ARGENTINA  S.A.	Puerto Madryn		0280-445-7377 / 447-2249	\N		\N	\N		t	\N	\N	\N
1b1876bc-fb45-4a89-a738-d2f8f460df73	PUENTE AMERICA	0164	\N	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	\N	\N	a48e3d60-bea0-4828-8099-3debb447f631	PEREIRA  ARGENTINA  S.A.	Puerto Madryn		0280-445-7377 / 447-2249	\N		\N	\N		t	\N	\N	\N
0674c7cb-0885-452f-a18e-09c327b4e8d4	PUENTE CHICO	0756	2263	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	37.00	1175	a48e3d60-bea0-4828-8099-3debb447f631	PEREIRA  ARGENTINA  S.A.	Puerto Madryn		0280-445-7377 / 447-2249	\N		\N	\N		t	\N	\N	\N
351938a1-a896-4c69-b8e3-84662f28438e	PUENTE MAYOR	02630	2703	6a95076f-aec1-4941-b231-92dfbc802cb7	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	60	66.86	2416	a48e3d60-bea0-4828-8099-3debb447f631	PEREIRA  ARGENTINA  S.A.	Puerto Madryn		0280-445-7377 / 447-2249	\N		\N	\N		t	\N	\N	\N
dd8c10df-e96c-45ce-9175-6b768f1e1560	PUENTE SAN JORGE	0207	2265	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	35.30	1001	a48e3d60-bea0-4828-8099-3debb447f631	PEREIRA  ARGENTINA  S.A.	Puerto Madryn		0280-445-7377 / 447-2249	\N		\N	\N		t	\N	\N	\N
83f98aec-2437-4f71-9e96-53076af055da	PUERTO WILLIAMS	3178	\N	975bf25c-1d6d-4101-9c5d-abe95e0a6978	9bda293b-e1b2-4bd2-9b2c-d34743032f06	a05ae304-2d0e-4e29-a6f3-fa7372a41c97	60	\N	\N	3c423d63-b431-4bf2-b375-b4de59037821	DERIS  S.A.	Punta Arenas -  Chile		+613 6224-8744	\N		\N	\N		t	\N	\N	\N
883fad0c-5ffb-4b18-a2eb-6d9c6bd36aee	PUNTA BALLENA	65	\N	d2217eec-a161-4143-9a47-007bc8afc75e	3a970316-23f2-4026-8bcc-dcc696e4f1f6	573af89c-fbee-4643-b922-7b69926c208d	60	\N	\N	\N					\N		\N	\N		t	\N	\N	\N
bc46579c-2097-4d96-9e53-febe520712da	QUEQUEN SALADO	0580	2277	15652b63-0efc-4059-ad8a-36de68d64a35	9bda293b-e1b2-4bd2-9b2c-d34743032f06	\N	4	19.45	271	18318dd2-cbb1-42cb-8aa0-f6f2c1f945bd	PISCAL  S.A.	Rawson			\N		\N	\N		t	\N	\N	\N
b29ee12a-14f6-4a6b-bae5-4602075ed561	RAFFAELA	01401	2280	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	26.50	624	24918e15-e968-484f-b31e-dc786b5f9ec2	PESQUERA RAFFAELA  S.A.	Mar del Plata		489-56574 int 203	\N		\N	\N		t	\N	\N	\N
28540032-1784-4969-b01e-9facc8394158	RAQUEL	01074	\N	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	\N	\N	24918e15-e968-484f-b31e-dc786b5f9ec2	PIEA  S.A.	Mar del Plata		489-6317 /489-1367	\N		\N	\N		t	\N	\N	\N
1e98c354-5dcf-4217-aaf5-c2561f51578d	REPUNTE	01120	\N	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	\N	\N	24918e15-e968-484f-b31e-dc786b5f9ec2	OSTRAMAR  S.A.	Mar del Plata		489-1959	\N		\N	\N		t	\N	\N	\N
9cad8c1d-3479-4485-8a9c-7cd0428923c9	PATAGONIA 1	02163	\N	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	\N	\N	26cb8962-0318-4dfe-a961-1b84a6ce6302	PATAGONIA  FISHING  S.A.	Ciudad Autónoma de Buenos Aires		011-4932-2777	\N		\N	\N		t	\N	\N	\N
cd53b0d4-5bc7-4d40-b57b-4a53a4087b8f	RIBAZON INES	0751	2306	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	38.50	720	24918e15-e968-484f-b31e-dc786b5f9ec2	SOUTH FISH  S.A.	Mar del Plata		480-5202	\N		\N	\N		t	\N	\N	\N
17c63b7d-824a-48ee-b8f9-16b43e483454	RIGEL	0266	\N	15652b63-0efc-4059-ad8a-36de68d64a35	9bda293b-e1b2-4bd2-9b2c-d34743032f06	\N	10	\N	\N	24918e15-e968-484f-b31e-dc786b5f9ec2	LUIS SOLIMENO e HIJOS  S.A.	Mar del Plata		489-3030	\N		\N	\N		t	\N	\N	\N
c92e91bc-3244-478f-a326-1ab6a2e22cf8	ROCIO DEL MAR	01568	2313	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	15	22.60	541	24918e15-e968-484f-b31e-dc786b5f9ec2	ROCIO DEL MAR  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
3f8a2047-6059-4cbc-a5a8-7810644e3a05	ROSARIO  G	0549	\N	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	\N	\N	a48e3d60-bea0-4828-8099-3debb447f631	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
9c4ca7ad-ebb0-4c78-a85c-cee8ccb0ed2d	RUMBO ESPERANZA	01211	\N	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	\N	\N	747eb90c-4eaf-451e-999f-759163bc918c	CAPAC  SRL	Comodoro Rivadavia		0297-446-1499  /  444-2233	\N		\N	\N		t	\N	\N	\N
86449f5a-ad5e-4c85-bb01-620b9df96b29	SALVADOR R	02755	2761	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	27.73	420	24918e15-e968-484f-b31e-dc786b5f9ec2	URBIPEZ  S.A.	Mar del Plata		4892793	\N		\N	\N		t	\N	\N	\N
af575127-3e3b-424d-a053-c63039f3b035	SAN ANDRES APOSTOL	0569	2340	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	54.56	2269	24918e15-e968-484f-b31e-dc786b5f9ec2	PESANFLOR  S.A.	Mar del Plata		489-6522	\N		\N	\N		t	\N	\N	\N
0b9c3bee-2f97-434b-bf0f-e79aaa456d79	SAN ANTONINO	0375	\N	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	\N	\N	24918e15-e968-484f-b31e-dc786b5f9ec2	SEA FISH  S.A.	Mar del Plata	51-11-65337853	480-0336	\N		\N	\N	Natalia Cedrato	t	\N	\N	\N
0dd4491b-7b6b-4a7d-af09-3bee8e759097	VALERIA DEL ATLÁNTICO	02098	2346	975bf25c-1d6d-4101-9c5d-abe95e0a6978	9bda293b-e1b2-4bd2-9b2c-d34743032f06	a05ae304-2d0e-4e29-a6f3-fa7372a41c97	60	56.46	4698	24918e15-e968-484f-b31e-dc786b5f9ec2	SAN ARAWA  S.A.	Mar del Plata		492-2216 / 492-0450	\N		\N	\N		t	\N	\N	\N
0be287e9-0af0-4d5f-8de4-9346f35bb52b	SAN BENEDETTO	02643	0	15652b63-0efc-4059-ad8a-36de68d64a35	9bda293b-e1b2-4bd2-9b2c-d34743032f06	\N	8	15.38	220	24918e15-e968-484f-b31e-dc786b5f9ec2	PESQUERA SAN BENEDETTO  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
cb8bcf91-5892-4a68-aa69-3a2ed383abd0	SAN GENARO	0763	\N	15652b63-0efc-4059-ad8a-36de68d64a35	9bda293b-e1b2-4bd2-9b2c-d34743032f06	\N	10	\N	\N	24918e15-e968-484f-b31e-dc786b5f9ec2	LESAUMON  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
eff8c471-72e1-4f74-bdaa-f3219dcc1154	SAN JUAN B	TEMP-0007	2780	\N	\N	\N	\N	39.94	1204	\N					\N		\N	\N		t	\N	\N	\N
a3a6059f-a0dd-49b6-aad0-7b67d5e2cf8d	SAN JORGE MARTIR	02152	2367	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	56.10	1408	24918e15-e968-484f-b31e-dc786b5f9ec2	PESANFLOR  S.A.	Mar del Plata		489-6522	\N		\N	\N		t	\N	\N	\N
e2e91430-9abf-466d-931b-dbf3449ef5a4	SAN LUCAS  I	06147	\N	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	\N	\N	26cb8962-0318-4dfe-a961-1b84a6ce6302	AGUA MARINA  S.A.	Ciudad Autónoma de Buenos Aires		011-4342-0605 / 5656 / 1709	\N		\N	\N		t	\N	\N	\N
a5a23502-6126-42f6-9b16-0d66738451c1	SAN MATEO	06306	0	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	54.10	1234	18318dd2-cbb1-42cb-8aa0-f6f2c1f945bd	IBERPESCA  S.A.	Rawson		0280-449-8176	\N		\N	\N		t	\N	\N	\N
d5e70762-b9dd-4e65-aea3-2c45e45577c6	SAN MATIAS	0289	\N	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	\N	\N	24918e15-e968-484f-b31e-dc786b5f9ec2	PESCA  ANTIGUA  S.A.	Mar del Plata		489-2340	\N		\N	\N		t	\N	\N	\N
8e016670-1a64-4807-a9c3-a6cd7e8f46ce	SAN PABLO	0759	\N	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	\N	\N	24918e15-e968-484f-b31e-dc786b5f9ec2	PRODUCTORA ARGEN-PESCA  S.A.	Mar del Plata		480-1444	\N		\N	\N		t	\N	\N	\N
920568ce-fd09-46bd-9326-1f17f514460a	SAN PASCUAL	0367	\N	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	\N	\N	24918e15-e968-484f-b31e-dc786b5f9ec2	BUENOS AIRES PESCA  S.A.	Mar del Plata		489-6522	\N		\N	\N		t	\N	\N	\N
7eabe48a-464c-442c-afbd-4bd308cd9bd0	SAN PEDRO APOSTOL	01975	\N	15652b63-0efc-4059-ad8a-36de68d64a35	9bda293b-e1b2-4bd2-9b2c-d34743032f06	\N	10	\N	\N	24918e15-e968-484f-b31e-dc786b5f9ec2	GAAD GROUP S.A.	Mar del Plata		480-9327	\N		\N	\N		t	\N	\N	\N
dcdfe814-b004-4be3-9b9b-7fba009c40f5	SANT ANTONIO	0974	\N	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	\N	\N	24918e15-e968-484f-b31e-dc786b5f9ec2	A.B.H. PESQUERA  S.A.	Mar del Plata	4895032	489-6522	\N	operacionesconsultoramaritima@gmail.com.ar	\N	\N	Agencia Merlini	t	\N	\N	\N
2fdcb010-d34a-40a2-88fc-19cfa892c787	SANTA BARBARA	5857	2409	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	56.96	1679	24918e15-e968-484f-b31e-dc786b5f9ec2	PESCA ANGELA  S.A.	Mar del Plata		626-2236 /37	\N		\N	\N		t	\N	\N	\N
c99f9709-9cac-43a3-a3a8-378a617fe44c	SANTA ANGELA	009	\N	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	\N	\N	24918e15-e968-484f-b31e-dc786b5f9ec2	OSTRAMAR  S.A.	Mar del Plata		489-1959	\N		\N	\N		t	\N	\N	\N
43ac36b7-188f-4c84-a2ad-a0adfddd23f2	SANTIAGO  I	02280	\N	\N	\N	\N	0	\N	\N	a48e3d60-bea0-4828-8099-3debb447f631	FISHING WORLD  S.A.	Puerto Madryn		0280-445-6533	\N		\N	\N		t	\N	\N	\N
b3137323-101b-461c-b0fd-843f49b4ecd2	SCIROCCO	2574	2430	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	65.93	1589	24918e15-e968-484f-b31e-dc786b5f9ec2	PESQUERA COMERCIAL  S.A.	Mar del Plata		489-3030	\N		\N	\N		t	\N	\N	\N
510627c8-f174-4659-b875-afb9ae1624af	SCOMBRUS	0509	\N	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	\N	\N	26cb8962-0318-4dfe-a961-1b84a6ce6302	KALEU KALEU  S.A.	Ciudad Autónoma de Buenos Aires		011-3220-2130  / 5093-1215	\N		\N	\N		t	\N	\N	\N
8d2106f8-7905-434d-ad6f-24de82b3f530	SCOMBRUS  II	02245	\N	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	\N	\N	a48e3d60-bea0-4828-8099-3debb447f631	HARENGUS  S.A.	Puerto Madryn		0280-445-0822	\N		\N	\N		t	\N	\N	\N
43a5043b-27e9-42f7-b358-596d66e5ac31	SERMILIK	0505	\N	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	\N	\N	a48e3d60-bea0-4828-8099-3debb447f631	HARENGUS  S.A.	Puerto Madryn	4891553-154179360-154179860-154179062	0280-445-0822	\N	agenciasmiriglio@speedy.com.ar	\N	\N	Agencia Smiriglio	t	\N	\N	\N
f24414d5-d81c-4561-94b1-666d8292df8b	SFIDA	01567	2439	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	26.50	624	24918e15-e968-484f-b31e-dc786b5f9ec2	SAN JORGE S.A.	Mar del Plata		480-6611	\N		\N	\N		t	\N	\N	\N
2d04700e-586c-4d28-a4f0-2174c63385b3	SHUNYO MARU 178	JA04	\N	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	\N	\N	26cb8962-0318-4dfe-a961-1b84a6ce6302	VIEIRA ARGENTINA  S.A.	Ciudad Autónoma de Buenos Aires			\N		\N	\N		t	\N	\N	\N
b16f9e98-def3-4e24-8303-3f3648a0cba9	SIEMPRE DON JOSE MOSCUZZA	02257	2460	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	38.00	1128	24918e15-e968-484f-b31e-dc786b5f9ec2	FRESCOMAR ARGENTINA  S.A.	Mar del Plata		489-7287	\N		\N	\N		t	\N	\N	\N
2a694f6a-4aed-4fae-bba4-41a1947f6391	SIEMPRE DON VICENTE	02654	2706	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	18.94	341	24918e15-e968-484f-b31e-dc786b5f9ec2	PESQUERA VIRGEN DE ITATI  S.R.L.	Mar del Plata		480-2921	\N		\N	\N		t	\N	\N	\N
7429659f-3eac-446a-af88-9e765688469a	SIEMPRE SAN SALVADOR	00801	2475	15652b63-0efc-4059-ad8a-36de68d64a35	9bda293b-e1b2-4bd2-9b2c-d34743032f06	\N	8	22.35	600	24918e15-e968-484f-b31e-dc786b5f9ec2	LOURDESMAR  S.R.L.	Mar del Plata		476-2916	\N		\N	\N		t	\N	\N	\N
33e484c5-dcf2-4cc0-8455-0ffdc87e14ab	SIEMPRE SANTA ROSA	0494	2476	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	27.80	548	24918e15-e968-484f-b31e-dc786b5f9ec2	GIORNO  S.A.	Mar del Plata		410-0051 / 0057	\N		\N	\N		t	\N	\N	\N
83066ade-9248-4be4-bf4d-0e9def12ce06	SIEMPRE VIEJO PANCHO	2937	2755	15652b63-0efc-4059-ad8a-36de68d64a35	9bda293b-e1b2-4bd2-9b2c-d34743032f06	\N	15	17.98	601	\N					\N		\N	\N		t	\N	\N	\N
97058b5f-f387-4b48-9a6d-548cf1708733	SIMBAD	0754	\N	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	\N	\N	24918e15-e968-484f-b31e-dc786b5f9ec2	SOUTH FISH  S.A.	Mar del Plata		480-5202	\N		\N	\N		t	\N	\N	\N
a8b340a9-8bd1-4da6-ad3d-0eea96bc8769	SIRIUS	0905	\N	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	\N	\N	24918e15-e968-484f-b31e-dc786b5f9ec2	LOBA PESQUERA  S.A.M.C.I.	Mar del Plata	4890960	489-0494  /  481-1814	\N	agencia@maritimavidal.com.ar	\N	\N	Agencia Maritima Vidal	t	\N	\N	\N
c1548464-fd59-4926-b385-29aee3f0d99d	RIBAZON DORINE	0921	\N	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	\N	\N	26cb8962-0318-4dfe-a961-1b84a6ce6302	KALEU KALEU  S.A.	Ciudad Autónoma de Buenos Aires		011-3220-2130  / 5093-1215	\N		\N	\N		t	\N	\N	\N
7fbacd2a-6e20-4549-b3b2-cc9818cd686d	SOHO MARU Nº 58	02611	2492	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	65.67	1776	f05d47aa-ffad-4c48-99f2-39015dc0159a	ARGENOVA  S.A.	Puerto Deseado		0297- 487-0550  (447-2818  Com. Riv )	\N		\N	\N		t	\N	\N	\N
542f8666-cd84-4c49-a01e-4aa223ff99cf	SOL MARINO	77	\N	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	\N	\N	26cb8962-0318-4dfe-a961-1b84a6ce6302	PESQUERA  20  DE NOVIEMBRE  S.A.	Ciudad Autónoma de Buenos Aires		011-4382-5011 / 4381-1337	\N		\N	\N		t	\N	\N	\N
43253daf-9880-479a-9abc-1e4f446a06dc	STELLA MARIS 1°	0926	\N	6a95076f-aec1-4941-b231-92dfbc802cb7	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	60	\N	\N	24918e15-e968-484f-b31e-dc786b5f9ec2	ALIMENPEZ  S.A.	Mar del Plata		461-9200	\N		\N	\N		t	\N	\N	\N
a1e84688-1df1-447f-a7ba-a32e91e65d28	SUEMAR	6186	2722	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	36.60	1168	a48e3d60-bea0-4828-8099-3debb447f631	CONGELADORES PATAGONICOS  S.A.	Puerto Madryn		0280-445-6280	\N		\N	\N		t	\N	\N	\N
4ff2c45f-f36e-42c8-97f4-83c9feec6fa2	SUEMAR DOS	01508	\N	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	\N	\N	a48e3d60-bea0-4828-8099-3debb447f631	CONGELADORES PATAGONICOS  S.A.	Puerto Madryn		0280-445-6280	\N		\N	\N		t	\N	\N	\N
39c2809f-d142-480c-91f6-2edd1ed58a65	SUMATRA	01105	2512	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	33.15	750	24918e15-e968-484f-b31e-dc786b5f9ec2	CALME  S.A.	Mar del Plata		480-3545	\N		\N	\N		t	\N	\N	\N
433cde99-6e95-4d5c-85ac-341643532ea7	SUR ESTE 501	01077	\N	ba886b54-f6f9-46d3-b89c-af6f53473323	9bda293b-e1b2-4bd2-9b2c-d34743032f06	\N	30	\N	\N	26cb8962-0318-4dfe-a961-1b84a6ce6302	SUR ESTE ARGEN  S.A.	Ciudad Autónoma de Buenos Aires		011-4816-7648 / 4372-7605	\N		\N	\N		t	\N	\N	\N
c62af90d-9552-4cc4-8345-479adae2ce69	SUR ESTE 502	02201	2520	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	54.60	1670	26cb8962-0318-4dfe-a961-1b84a6ce6302	SUR ESTE ARGEN  S.A.	Ciudad Autónoma de Buenos Aires		011-4816-7648 / 4372-7605	\N		\N	\N		t	\N	\N	\N
69b5ecb4-8985-416b-8970-bcf27397553b	SURIMI I	06143	\N	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	\N	\N	26cb8962-0318-4dfe-a961-1b84a6ce6302	FARO DEL SUR TRADING  S.A.	Ciudad Autónoma de Buenos Aires		011-4555-4956	\N		\N	\N		t	\N	\N	\N
34af426e-13a4-40e3-a3cd-10740106dd87	TABEIRON	02233	2529	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	40	34.15	889	26cb8962-0318-4dfe-a961-1b84a6ce6302	VIEIRA ARGENTINA  S.A.	Ciudad Autónoma de Buenos Aires			\N		\N	\N		t	\N	\N	\N
8308abf9-87e0-48bc-b5c0-8a2e0d041020	TABEIRON DOS	02323	\N	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	\N	\N	f05d47aa-ffad-4c48-99f2-39015dc0159a	PESQUERA DESEADO  S.A.	Puerto Deseado	54-11-65337853	0297-487-0884 / 0327 / 2407	\N		\N	\N	Natalia Cedrato	t	\N	\N	\N
a877a989-df17-4c93-82f1-03b6fbb9b6ff	Nº 75 TAE BAEK	02364	2138	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	55.70	1302	a48e3d60-bea0-4828-8099-3debb447f631	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
44ab546f-33ad-4d09-a025-5b67d3c995c4	TAI AN	1530	2533	3271a122-ccb0-42ec-a69b-87d56de04fa8	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	60	100.50	4506	26cb8962-0318-4dfe-a961-1b84a6ce6302	PRODESUR S.A	Ciudad Autónoma de Buenos Aires		492-2216 / 492-0450	\N		\N	\N	54 – 9 - 1141714381	t	\N	\N	\N
7946fc90-39c2-4e2b-a2f4-cc5be8c6d657	TAI SEI MARU N°8	02207	\N	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	\N	\N	26cb8962-0318-4dfe-a961-1b84a6ce6302	CORPORACION DEL ATLANTICO SUR  S.A.	Ciudad Autónoma de Buenos Aires		011-4105-1133 int 30	\N		\N	\N		t	\N	\N	\N
1ed56e47-4ae5-439e-9dc4-c3aecf7480aa	TALISMAN	02263	2541	fec3d722-78a4-4209-a6d3-e247c197885a	3d4b058b-d293-49cb-9018-8e8e99675548	b5066e3d-aff4-484a-b1ad-a45a57700aeb	30	49.95	1302	26cb8962-0318-4dfe-a961-1b84a6ce6302	CENTOMAR  S.A.	Ciudad Autónoma de Buenos Aires		011-4816-6245 / 6260  int  * 35	\N		\N	\N		t	\N	\N	\N
0bd1e6fd-2907-4df7-95b3-102db086ed62	TANGO I	02724	2709	fec3d722-78a4-4209-a6d3-e247c197885a	3d4b058b-d293-49cb-9018-8e8e99675548	b5066e3d-aff4-484a-b1ad-a45a57700aeb	30	50.40	1302	26cb8962-0318-4dfe-a961-1b84a6ce6302	BENTONICOS DE ARGENTINA  S.A.	Ciudad Autónoma de Buenos Aires		011-5258-2400 / 4407-8240	\N		\N	\N		t	\N	\N	\N
38fabe2c-223f-4dd9-aa1d-e42ca6eff7d6	TANGO II	02791	2714	fec3d722-78a4-4209-a6d3-e247c197885a	3d4b058b-d293-49cb-9018-8e8e99675548	b5066e3d-aff4-484a-b1ad-a45a57700aeb	30	50.40	1302	26cb8962-0318-4dfe-a961-1b84a6ce6302	BENTONICOS DE ARGENTINA  S.A.	Ciudad Autónoma de Buenos Aires	4891227	011-5258-2400 / 4407-8240	\N	serviciosmaritimosmdq@gmail.com	\N	\N	Servicios maritimos	t	\N	\N	\N
7ac345e5-7c81-4e2c-a068-78606ad51c30	TESON	01541	2552	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	25.97	765	24918e15-e968-484f-b31e-dc786b5f9ec2	RITORNO SALLUSTIO Y CICCIOTTI  S.A.	Mar del Plata		480-5508	\N		\N	\N		t	\N	\N	\N
8d3d7de1-0141-4a34-bd92-6331c965ef95	TIAN YUAN	02173	\N	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	\N	\N	26cb8962-0318-4dfe-a961-1b84a6ce6302	CORPORACION DEL ATLANTICO SUR  S.A.	Ciudad Autónoma de Buenos Aires		011-4105-1133 int 30	\N		\N	\N		t	\N	\N	\N
39e44870-3d1c-4324-8732-6a7da7ae5d0b	TOBA MARU	0241	\N	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	\N	\N	a48e3d60-bea0-4828-8099-3debb447f631	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
d6af7eb0-15b4-456d-830a-d4b2cc3a36d0	TORNYY	240	\N	fec3d722-78a4-4209-a6d3-e247c197885a	3d4b058b-d293-49cb-9018-8e8e99675548	b5066e3d-aff4-484a-b1ad-a45a57700aeb	30	\N	\N	26cb8962-0318-4dfe-a961-1b84a6ce6302	CRUSTACEOS DEL SUR  S.A.	Ciudad Autónoma de Buenos Aires		011-5218-4287	\N		\N	\N		t	\N	\N	\N
ba586794-9245-4f24-82f8-2cd9baf218e7	TOZUDO	01219	2566	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	26.74	624	24918e15-e968-484f-b31e-dc786b5f9ec2	CABO VERDE  S.A.	Mar del Plata		489-4645	\N		\N	\N		t	\N	\N	\N
66cfdc89-2a63-4d5d-afca-4c7bbf8ac072	TRABAJAMOS	02904	2726	15652b63-0efc-4059-ad8a-36de68d64a35	9bda293b-e1b2-4bd2-9b2c-d34743032f06	\N	4	19.94	592	f05d47aa-ffad-4c48-99f2-39015dc0159a	DESEADO FISH  S.A.	Puerto Deseado			\N		\N	\N		t	\N	\N	\N
d7b7cc3b-6451-46d5-9e96-f49205d53828	UCHI	01901	2580	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	54.23	1552	26cb8962-0318-4dfe-a961-1b84a6ce6302	PESQUERA SANTA ELENA S.A.I.C.	Ciudad Autónoma de Buenos Aires		011-4328-9909	\N		\N	\N		t	\N	\N	\N
902dacf4-841c-42db-987f-d9e17922c73d	UNION	01539	\N	15652b63-0efc-4059-ad8a-36de68d64a35	9bda293b-e1b2-4bd2-9b2c-d34743032f06	\N	10	\N	\N	24918e15-e968-484f-b31e-dc786b5f9ec2	RITORNO SALLUSTIO Y CICCIOTTI  S.A.	Mar del Plata		480-5508	\N		\N	\N		t	\N	\N	\N
23a79fd7-d42c-499d-ae63-b138087aeb14	URABAIN	0612	\N	6a95076f-aec1-4941-b231-92dfbc802cb7	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	60	\N	\N	a48e3d60-bea0-4828-8099-3debb447f631	IBERCONSA  DE ARGENTINA  S.A.	Puerto Madryn	mariano@maritimavidal.com.ar	0280-445-4324	\N		\N	\N	raul@maritimavidal.com.ar	t	\N	\N	\N
44b20244-5d7f-4270-b436-c486062fd7ac	UR ERTZA	0377	2587	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	51.00	1482	24918e15-e968-484f-b31e-dc786b5f9ec2	LUIS SOLIMENO e HIJOS  S.A.	Mar del Plata		489-3030	\N		\N	\N		t	\N	\N	\N
3b9ec326-1909-4722-962b-882da9cfe3f4	VALIENTE I	0211A	\N	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	\N	\N	24918e15-e968-484f-b31e-dc786b5f9ec2	EXPLOTACION PESQ. DE LA PATAGONIA  S.A.	Mar del Plata		489-4624  /  489-0314 (astillero)	\N		\N	\N		t	\N	\N	\N
fdf04a6f-0d33-43ec-a3d2-0612cf1ce2db	VALIENTE II	0212A	2718	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	35.30	1001	24918e15-e968-484f-b31e-dc786b5f9ec2	EXPLOTACION PESQ. DE LA PATAGONIA  S.A.	Mar del Plata		489-4624  /  489-0314 (astillero)	\N		\N	\N	agencia@maritimavidal.com.ar	t	\N	\N	\N
b0acbcad-f1af-4b9d-804a-cb17bbc5b324	VENTARRON 1º	0479	2708	6a95076f-aec1-4941-b231-92dfbc802cb7	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	60	63.07	1969	a48e3d60-bea0-4828-8099-3debb447f631	ATUNERA  ARGENTINA  S.A.	Puerto Madryn		0280-445-4324	\N		\N	\N		t	\N	\N	\N
cc4686cb-5ff7-401a-9568-4dbda77af1ce	VERAZ	0144	2603	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	27.45	604	24918e15-e968-484f-b31e-dc786b5f9ec2	PESQUERA VERAZ  S.A.	Mar del Plata		489-4624 / 489-0314 (astillero)	\N		\N	\N		t	\N	\N	\N
20e20ee7-053c-4c4b-9ff0-c4da7977fc1f	VERDEL	0174	2604	6a95076f-aec1-4941-b231-92dfbc802cb7	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	60	71.70	1975	49e7b97e-f997-4fd6-8de0-06ec2254bbf5	IBERMAR  S.A.	Bahia Blanca		0291-457-2427	\N		\N	\N		t	\N	\N	\N
38e74e01-3229-4148-ae4d-f36039efc971	VERONICA ALEJANDRA N	02292	2606	15652b63-0efc-4059-ad8a-36de68d64a35	9bda293b-e1b2-4bd2-9b2c-d34743032f06	\N	4	15.30	223	18318dd2-cbb1-42cb-8aa0-f6f2c1f945bd	FARO CHUBUT  S.R.L.	Rawson		0280-449-6311	\N		\N	\N		t	\N	\N	\N
f17fc44b-c4be-46ea-a187-a7c3ac420a5c	SIRIUS III	0937	\N	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	\N	\N	24918e15-e968-484f-b31e-dc786b5f9ec2	EL MARISCO  S.A.	Mar del Plata	4808331/4808332	489-0384	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
aa7d1041-478f-4f0a-9b4f-220f2e57f467	VICTORIA I	0554	\N	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	\N	\N	a48e3d60-bea0-4828-8099-3debb447f631	PEREIRA  ARGENTINA  S.A.	Puerto Madryn		0280-445-7377 / 447-2249	\N		\N	\N		t	\N	\N	\N
670466d7-850a-4f9c-b369-85b83e5e163a	VICTORIA II	0556	2611	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	27.40	601	24918e15-e968-484f-b31e-dc786b5f9ec2	CRESTAS  S.A.	Mar del Plata		410-5170	\N		\N	\N		t	\N	\N	\N
34f665b0-9775-4add-923d-6bf7dc568f19	VICTORIA P	02246	\N	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	\N	\N	26cb8962-0318-4dfe-a961-1b84a6ce6302	PESQUERA SANTA ELENA S.A.I.C.	Ciudad Autónoma de Buenos Aires		011-4328-9909	\N		\N	\N		t	\N	\N	\N
82f74ad8-5e6f-40b6-a1e2-255faab3d9d1	VIEIRASA DIECIOCHO	2563	2615	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	67.78	1803	26cb8962-0318-4dfe-a961-1b84a6ce6302	VIEIRA ARGENTINA  S.A.	Ciudad Autónoma de Buenos Aires			\N		\N	\N		t	\N	\N	\N
8022c1ad-bad1-42ff-be09-6424fa6d5f58	VIEIRASA DIECISEIS	0240	2616	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	36.13	702	26cb8962-0318-4dfe-a961-1b84a6ce6302	VIEIRA ARGENTINA  S.A.	Ciudad Autónoma de Buenos Aires			\N		\N	\N		t	\N	\N	\N
54908ddf-3ef2-419d-b99a-c8e3e862441f	VIEIRASA DIECISIETE	2568	2752	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	59.03	1401	26cb8962-0318-4dfe-a961-1b84a6ce6302	VIEIRA ARGENTINA  S.A.	Ciudad Autónoma de Buenos Aires			\N		\N	\N		t	\N	\N	\N
8864f177-f62a-4476-a215-66251305eb01	VIEIRASA QUINCE	0179	\N	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	\N	\N	26cb8962-0318-4dfe-a961-1b84a6ce6302	VIEIRA ARGENTINA  S.A.	Ciudad Autónoma de Buenos Aires			\N		\N	\N		t	\N	\N	\N
2f6af4f3-d52c-413f-8bb2-eab3725bcc4e	VIENTO DEL SUR	01858	\N	975bf25c-1d6d-4101-9c5d-abe95e0a6978	9bda293b-e1b2-4bd2-9b2c-d34743032f06	a05ae304-2d0e-4e29-a6f3-fa7372a41c97	60	\N	\N	f05d47aa-ffad-4c48-99f2-39015dc0159a	PESPASA  S.A.	Puerto Deseado		0297-487-2030  int 12	\N		\N	\N		t	\N	\N	\N
dbd10890-f676-4a6a-af1e-6b2bbc7681d4	VILLARINO	02178	2629	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	64.50	1776	f58cf3b9-22a7-4d22-b1d0-deecabf0640a	PESCA AUSTRAL  S.A.	San Antonio Oeste		02934-49-2111	\N		\N	\N		t	\N	\N	\N
d212eb24-5591-4f6a-803b-f386249ebe04	VIRGEN DEL CARMEN	0550	\N	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	\N	\N	24918e15-e968-484f-b31e-dc786b5f9ec2	MAR PURO  S.A.	Mar del Plata		451-1830	\N		\N	\N		t	\N	\N	\N
96a64d6e-aad2-46de-b016-3e94e1e5a024	VIRGEN DEL MILAGRO	02767	2725	15652b63-0efc-4059-ad8a-36de68d64a35	9bda293b-e1b2-4bd2-9b2c-d34743032f06	\N	4	19.93	380	f05d47aa-ffad-4c48-99f2-39015dc0159a	UNION PESQUERA PATAGONIA  S.A.	Puerto Deseado			\N		\N	\N		t	\N	\N	\N
93179470-6f83-4ae0-bec3-e9f301181c2e	VIRGEN DEL ROCIO	0194	\N	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	\N	\N	a48e3d60-bea0-4828-8099-3debb447f631	ALPESCA  S.A.	Puerto Madryn		0280-447-4958 / 45-1069	\N		\N	\N		t	\N	\N	\N
769fa5de-b970-40f8-88b3-937a08baba8b	VIRGEN MARIA	0541	2645	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	56.65	1803	24918e15-e968-484f-b31e-dc786b5f9ec2	LUIS SOLIMENO e HIJOS  S.A.	Mar del Plata		489-3030	\N		\N	\N		t	\N	\N	\N
b557d98e-1063-4514-9058-25016592da9c	VIRGEN MARIA INMACULADA	0369	\N	15652b63-0efc-4059-ad8a-36de68d64a35	9bda293b-e1b2-4bd2-9b2c-d34743032f06	\N	10	\N	\N	\N					\N		\N	\N		t	\N	\N	\N
8bddbc16-03e2-485b-a143-aef1a8dfe57f	WIRON  IV	01476	\N	ce0804e6-6594-415e-8a46-cc4d8a237910	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	30	\N	\N	24918e15-e968-484f-b31e-dc786b5f9ec2	TATURIELLO  S.A.	Mar del Plata		489-3833	\N		\N	\N		t	\N	\N	\N
404bec57-91c5-4a8f-b802-7c9ec062ee8e	XEITOSIÑO	0403	2668	6a95076f-aec1-4941-b231-92dfbc802cb7	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	60	51.72	1502	24918e15-e968-484f-b31e-dc786b5f9ec2	PESQUERA EL NAZARENO	Mar del Plata		489-9414 (of. Pers. Emb.)	\N		\N	\N		t	\N	\N	\N
099de7e8-82e2-4266-a60b-05c796751564	XIN SHI DAI N° 28	02165	2669	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	62.40	1579	26cb8962-0318-4dfe-a961-1b84a6ce6302	MUELLE OCHO  S.A.	Ciudad Autónoma de Buenos Aires		011-4381-1337	\N		\N	\N		t	\N	\N	\N
f7f3a105-24e6-4640-b2e8-15104f342186	XIN SHI JI 25	03092	2753	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	70.50	0	26cb8962-0318-4dfe-a961-1b84a6ce6302	PESQUERA  20  DE NOVIEMBRE  S.A.	Ciudad Autónoma de Buenos Aires		011-4382-5011 / 4381-1337	\N		\N	\N		t	\N	\N	\N
eb347320-f44c-4cd2-a7a4-89ff2cc22bdd	XIN SHI JI N° 88	02182	\N	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	\N	\N	26cb8962-0318-4dfe-a961-1b84a6ce6302	FENIX  INTERNATIONAL  S.A.	Ciudad Autónoma de Buenos Aires		011-4381-1337	\N		\N	\N		t	\N	\N	\N
79f3ab3e-00c3-438f-8ca8-b2ab5ede6d78	XIN SHI JI Nº 89	02903	2750	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	68.58	2685	26cb8962-0318-4dfe-a961-1b84a6ce6302	FENIX  INTERNATIONAL  S.A.	Ciudad Autónoma de Buenos Aires		011-4381-1337	\N		\N	\N		t	\N	\N	\N
4d041bd0-2ac8-4b27-8c63-dd72ede16d20	XIN SHI JI Nº 91	02924	2724	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	68.58	2685	26cb8962-0318-4dfe-a961-1b84a6ce6302	FENIX  INTERNATIONAL  S.A.	Ciudad Autónoma de Buenos Aires		011-4381-1337	\N		\N	\N		t	\N	\N	\N
8378ca6c-680c-4031-8b33-2d6c08ec715e	XIN SHI JI Nº 92	02930	2742	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	68.58	2685	26cb8962-0318-4dfe-a961-1b84a6ce6302	FENIX  INTERNATIONAL  S.A.	Ciudad Autónoma de Buenos Aires		011-4381-1337	\N		\N	\N		t	\N	\N	\N
1d9f273f-b15c-4b47-9870-19f71f1e01fe	XIN SHI JI Nº 95	02933	2732	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	68.58	2685	26cb8962-0318-4dfe-a961-1b84a6ce6302	PESQUERA  20  DE NOVIEMBRE  S.A.	Ciudad Autónoma de Buenos Aires	155-282636 - Facundo	011-4382-5011 / 4381-1337	\N		\N	\N	Agencia Di Yorio	t	\N	\N	\N
69b106d7-87d9-4d24-9378-6fa1c531b7ef	XIN SHI JI N° 99	02181	2674	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	65.10	2173	26cb8962-0318-4dfe-a961-1b84a6ce6302	FENIX  INTERNATIONAL  S.A.	Ciudad Autónoma de Buenos Aires		011-4381-1337	\N		\N	\N		t	\N	\N	\N
265d6576-bd58-4ef5-895f-aa15f107d975	XIN SHI JI Nº 98	02995	\N	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	\N	\N	26cb8962-0318-4dfe-a961-1b84a6ce6302	PESQUERA  20  DE NOVIEMBRE  S.A.	Ciudad Autónoma de Buenos Aires		011-4382-5011 / 4381-1337	\N		\N	\N		t	\N	\N	\N
f5aeeb47-a92f-444f-aa09-2559a3213f92	YAMATO	077	\N	3271a122-ccb0-42ec-a69b-87d56de04fa8	9bda293b-e1b2-4bd2-9b2c-d34743032f06	2734dc66-d31b-4d97-aeda-645ce3eb6885	60	\N	\N	3c423d63-b431-4bf2-b375-b4de59037821	PESANTAR  S.A. ( Empresa Pesq de la Patagonia y Antartida )	Ushuaia		02901-43-3449 / 43-0008 / 43-0708	\N		\N	\N		t	\N	\N	\N
dba09b28-7096-47d7-baf1-21a567bf69f2	YENU	0498A	\N	b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	8f5cf1c6-c544-45d3-b9d1-bf1c0166c04b	372697a7-b884-4ed6-9bb6-1420610ba86f	30	\N	\N	49e7b97e-f997-4fd6-8de0-06ec2254bbf5	MARITIMA MONACHESI  S.A.	Bahia Blanca		0291-452-5913	\N		\N	\N		t	\N	\N	\N
2d8228e3-006c-4a2e-8670-2218e76b72c8	YOKO MARU	UY252	\N	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	\N	\N	26cb8962-0318-4dfe-a961-1b84a6ce6302	EMPESUR  S.A.	Ciudad Autónoma de Buenos Aires		011-4312-0123	\N		\N	\N		t	\N	\N	\N
d7c90233-4bf8-4bde-a96f-2e48933752bf	ZHOU YU YI HAO	CH251	\N	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	\N	\N	26cb8962-0318-4dfe-a961-1b84a6ce6302	VIEIRA ARGENTINA  S.A.	Ciudad Autónoma de Buenos Aires			\N		\N	\N		t	\N	\N	\N
089a0647-0a8b-403f-a692-4f7435defac8	HOLMBERG	7918189	\N	65029fa6-99f0-445f-9613-176773c55dca	\N	\N	\N	\N	\N	\N	INIDEP				\N		\N	\N		t	\N	\N	\N
bf604e08-daf5-4550-9556-6db5662b820e	Hai Xiang 16	LW5157	\N	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	\N	\N	\N	PESQUERA RÍO QUEQUEN				\N		\N	\N		t	\N	\N	\N
20cddc4a-bded-4b90-a30c-6c3c33163d44	Hai Xiang 17	LW3286	\N	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	\N	\N	\N	PESQUERA RÍO QUEQUEN				\N		\N	\N		t	\N	\N	\N
46c9b7ca-d2a4-407f-8240-86d6a928b813	VICTORIA DEL MAR 1°	0929	\N	95e71d6e-c6cc-4060-a537-bd036203317d	53e0c737-35f9-4667-bf7a-8f1da22391e0	68a3cc43-2e5f-4423-8302-3e11af1ff872	40	\N	\N	24918e15-e968-484f-b31e-dc786b5f9ec2	RIPSA  S.A. ( ROSALES INDUSTRIAL PESQ. )	Mar del Plata		489-7881	\N		\N	\N		t	\N	\N	\N
053877a4-0a19-4282-9ff8-5be84150d5ee	MAR ARGENTINO	9883833	\N	65029fa6-99f0-445f-9613-176773c55dca	\N	\N	\N	\N	\N	\N	INIDEP				\N		\N	\N		t	\N	\N	\N
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
952cd42a-41ac-4c87-ba5d-8662338ca554	2026-01-03 17:36:03.648+00	ERROR	BACKEND	GlobalExceptionFilter	6a42d48b-4872-494c-b2d1-47703ae5385a	admin@obs.com	Token not valid	UnauthorizedException: Token not valid\n    at JwtStrategy.validate (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\auth\\strategies\\jwt.strategy.ts:31:19)\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async JwtStrategy.callback [as _verify] (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+passport@11.0.5_@ne_3e2e1635e1fc880657f155ecf43895f0\\node_modules\\@nestjs\\passport\\dist\\passport\\passport.strategy.js:13:44)	{"query": {"year": "2025"}, "params": {}, "exception": {"error": "Unauthorized", "message": "Token not valid", "statusCode": 401}}	/api/mareas/kpis?year=2025	GET	::1
c3e781af-4f51-4be7-8160-f23f2eb2af83	2026-01-03 17:36:03.65+00	ERROR	BACKEND	GlobalExceptionFilter	6a42d48b-4872-494c-b2d1-47703ae5385a	admin@obs.com	Token not valid	UnauthorizedException: Token not valid\n    at JwtStrategy.validate (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\auth\\strategies\\jwt.strategy.ts:31:19)\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async JwtStrategy.callback [as _verify] (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+passport@11.0.5_@ne_3e2e1635e1fc880657f155ecf43895f0\\node_modules\\@nestjs\\passport\\dist\\passport\\passport.strategy.js:13:44)	{"query": {"year": "2025"}, "params": {}, "exception": {"error": "Unauthorized", "message": "Token not valid", "statusCode": 401}}	/api/mareas/operativo?year=2025	GET	::1
4c72d5cb-9b40-43ae-bb11-8e4cf9e74746	2026-01-03 17:36:03.686+00	ERROR	BACKEND	GlobalExceptionFilter	6a42d48b-4872-494c-b2d1-47703ae5385a	admin@obs.com	Token not valid	UnauthorizedException: Token not valid\n    at JwtStrategy.validate (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\auth\\strategies\\jwt.strategy.ts:31:19)\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async JwtStrategy.callback [as _verify] (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+passport@11.0.5_@ne_3e2e1635e1fc880657f155ecf43895f0\\node_modules\\@nestjs\\passport\\dist\\passport\\passport.strategy.js:13:44)	{"query": {"year": "2025"}, "params": {}, "exception": {"error": "Unauthorized", "message": "Token not valid", "statusCode": 401}}	/api/mareas/flota-por-pesqueria?year=2025	GET	::1
9d005402-0d0a-47d0-acb6-ea2dc3aa03de	2026-01-03 17:36:03.688+00	ERROR	BACKEND	GlobalExceptionFilter	6a42d48b-4872-494c-b2d1-47703ae5385a	admin@obs.com	Token not valid	UnauthorizedException: Token not valid\n    at JwtStrategy.validate (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\auth\\strategies\\jwt.strategy.ts:31:19)\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async JwtStrategy.callback [as _verify] (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+passport@11.0.5_@ne_3e2e1635e1fc880657f155ecf43895f0\\node_modules\\@nestjs\\passport\\dist\\passport\\passport.strategy.js:13:44)	{"query": {"year": "2025"}, "params": {}, "exception": {"error": "Unauthorized", "message": "Token not valid", "statusCode": 401}}	/api/mareas/workforce/status?year=2025	GET	::1
\.


--
-- Data for Name: especies; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.especies (id, codigo, nombre_cientifico, nombre_vulgar, activo, observaciones) FROM stdin;
44d7f3de-e8ef-496a-a7be-6671a63ed37e	0000000001	Genypterus blacodes	Abadejo	t	\N
074b97df-cfe3-4a35-9b2b-e401ac1e520d	0000000002	Engraulis anchoita	Anchoíta	t	\N
8594b6dc-717e-42aa-82da-78b4b1bba426	0000000003	Scomber japonicus	Caballa	t	\N
311a3be1-6dde-4e36-9044-d8f61d770f63	0000000004	Illex argentinus	Calamar	t	\N
899a905d-b06a-4d36-b7c2-9755f7aae8b1	0000000005	Lithodes santolla	Centolla	t	\N
adb84b46-5e89-4505-827e-183e42f3358b	0000000006	-	Especies australes	t	\N
9883a9a1-f57d-46b3-97cb-9585fa0bb374	0000000007	Pleoticus muelleri	Langostino	t	\N
2e88ad13-4cc6-4e49-9fc8-da04d4b3ab62	0000000008	Merluccius hubbsi	Merluza común	t	\N
f96010ae-46ab-454e-99f9-1da1c55eba02	0000000009	Dissostichus eleginoides	Merluza negra	t	\N
d1c842fa-b19a-4258-ac16-ed133fe9bd4c	0000000010	Zygochlamys patagonica	Vieira	t	\N
\.


--
-- Data for Name: estados_marea; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.estados_marea (id, codigo, nombre, descripcion, categoria, orden, es_inicial, es_final, permite_carga_archivos, permite_correccion, permite_informe, activo, mostrar_en_panel) FROM stdin;
9f069ef3-106c-4d1d-8043-6f71ee9edf4c	DESIGNADA	Designada	\N	PENDIENTE	1	t	f	f	f	f	t	t
7686e133-c020-4217-b227-43529e1a6d06	EN_EJECUCION	En ejecución	\N	PENDIENTE	2	f	f	f	f	f	t	t
91ed6780-31e7-43c7-999d-397109228a90	ESPERANDO_ENTREGA	Esperando entrega de datos	\N	PENDIENTE	3	f	f	f	f	f	t	t
db613d46-5efb-44f3-82cc-7b6d8bb7cab1	ENTREGADA_RECIBIDA	Entregada / Recibida	\N	PENDIENTE	4	f	f	t	f	f	t	t
dc80d04a-0562-447a-82d4-034abc3b7de1	VERIFICACION_INICIAL	Verificación inicial	\N	EN_CURSO	5	f	f	t	f	f	t	t
3b25becb-425a-4103-aee1-47d04ae7a7ad	EN_CORRECCION	En corrección interna	\N	EN_CURSO	6	f	f	t	t	f	t	t
1e713d9c-808a-4800-9920-abbb60da59c2	DELEGADA_EXTERNA	Delegada / En espera externa	\N	EN_CURSO	7	f	f	t	f	f	t	f
04e442d2-a6e0-4c7c-a3f1-7358d332ca10	PENDIENTE_DE_INFORME	Pendiente de informe	\N	EN_CURSO	8	f	f	f	f	t	t	t
59f13e6d-1afb-4eac-8389-5bbe335b1bc9	ESPERANDO_REVISION	Esperando revisión de informe	\N	EN_CURSO	9	f	f	f	f	t	t	f
7c1e102c-040c-41e2-a5a9-84d3c1c6948e	PARA_PROTOCOLIZAR	Para protocolizar	\N	EN_CURSO	10	f	f	f	f	t	t	f
38be0651-cf2d-4893-b2fc-40bb5acda3d5	ESPERANDO_PROTOCOLIZACION	Esperando protocolización	\N	EN_CURSO	11	f	f	f	f	t	t	f
dd9a867c-d1a6-45a1-987f-f0d227dfd508	PROTOCOLIZADA	Protocolizada / Finalizada	\N	COMPLETADO	12	f	t	f	f	t	t	f
081d416b-af3c-4c1d-a2db-3525f5db5c36	CANCELADA	Cancelada / Desestimada	\N	CANCELADO	13	f	t	f	f	f	t	f
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
1b96ca55-5d25-4d4f-b195-e1e303416e71	2025	1	0dd4491b-7b6b-4a7d-af09-3bee8e759097	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-01-03 03:00:00+00	\N	\N	32	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:34.276+00	2026-01-03 17:21:34.276+00	t	Importada de JSONL. Empresa: ESTREMAR. Especie: MERLUZA AUSTRAL	MC	60
b22d23b3-b507-4d09-9b5f-bc97f8729557	2025	2	c2f6e135-2553-4a11-9bd1-df7416465dbd	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-01-03 03:00:00+00	\N	\N	23	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:34.297+00	2026-01-03 17:21:34.297+00	t	Importada de JSONL. Empresa: ARGENOVA. Especie: MERLUZA AUSTRAL	MC	60
9143ae67-1fdd-4056-b8cc-da9ae96521d8	2025	3	1e28bd98-19b3-4e8b-9ff6-31d95dbd2712	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-01-03 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:34.306+00	2026-01-03 17:21:34.306+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: CENTOLLA	MC	30
e8856ef7-43e1-4173-913f-431da83c7ab2	2025	4	6c8d7809-be24-4d31-a90e-84cd31823b7e	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-01-12 03:00:00+00	\N	\N	4	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:34.317+00	2026-01-03 17:21:34.317+00	t	Importada de JSONL. Empresa: PEDRO MOSCUZZA E HIJO. Especie: MERLUZA	MC	30
e87e2e44-9503-4f57-9293-250d3fef1b2f	2025	5	c66f1349-8b7b-44dc-8140-0f896fed0fe9	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-01-08 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:34.328+00	2026-01-03 17:21:34.328+00	t	Importada de JSONL. Empresa: PESQUERA GEMINIS. Especie: MERLUZA	MC	30
d4242dce-a30d-49ba-bd05-202e5381aa45	2025	6	8d950e58-7292-4096-8513-16166ea032e8	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-01-09 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:34.337+00	2026-01-03 17:21:34.337+00	t	Importada de JSONL. Empresa: PESQUERA CERES. Especie: CALAMAR	MC	30
8ed765a1-5a4d-4ecc-ac3c-1110020f1e67	2025	7	7fbacd2a-6e20-4549-b3b2-cc9818cd686d	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-01-07 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:34.348+00	2026-01-03 17:21:34.348+00	t	Importada de JSONL. Empresa: ARGENOVA. Especie: CALAMAR	MC	30
74aa850b-8f32-461d-90a1-40667e073e81	2025	8	769fa5de-b970-40f8-88b3-937a08baba8b	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-01-09 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:34.357+00	2026-01-03 17:21:34.357+00	t	Importada de JSONL. Empresa: LUIS SOLIMENO. Especie: MERLUZA	MC	30
a06d3da0-1d1e-4719-a52b-08c7e4a19c7c	2025	9	3059e444-2a0b-4ef8-9c39-0e135c0c8755	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-01-06 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:34.371+00	2026-01-03 17:21:34.371+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: VIEIRA	MC	30
19e60f5b-b31c-49f7-809d-5735ad940ce3	2025	10	21f78c2d-2475-4c14-a29a-690be6abc768	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-01-11 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:34.381+00	2026-01-03 17:21:34.381+00	t	Importada de JSONL. Empresa: GLACIAR PESQUERA. Especie: VIEIRA	MC	30
0f138d55-65fd-4c97-b087-430dbaa82da1	2025	11	42cd5d3b-d0e1-408a-942f-c042e13bab48	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-01-08 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:34.39+00	2026-01-03 17:21:34.39+00	t	Importada de JSONL. Empresa: FOOD ARTZ S.A.. Especie: CALAMAR	MC	30
bfaea882-ab97-4e3d-af71-8fd699abf4b4	2025	12	6c4b9846-561e-42c3-b685-ad9a6df761e2	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-01-09 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:34.399+00	2026-01-03 17:21:34.399+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: VIEIRA	MC	30
85adba53-6a2c-496f-9af7-b254a993e62e	2025	13	6b31f97f-8059-4932-8de7-b0a4356386ae	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-01-09 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:34.408+00	2026-01-03 17:21:34.408+00	t	Importada de JSONL. Empresa: FOOD PARTNERS PATAGONIA. Especie: CENTOLLA	MC	30
0c9d7f1e-c9a1-4dcf-be69-b75695b73028	2025	14	9a6204b6-657f-4a1c-a75c-bd5358e5b6b7	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-01-09 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:34.417+00	2026-01-03 17:21:34.417+00	t	Importada de JSONL. Empresa: PEDRO MOSCUZZA E HIJO. Especie: CALAMAR	MC	30
c9e228eb-04a5-4323-807c-10552768c1aa	2025	15	81723a1f-7293-4231-ab06-519cdfcfad2e	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-01-11 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:34.426+00	2026-01-03 17:21:34.426+00	t	Importada de JSONL. Empresa: PESQUERA VERAZ. Especie: MERLUZA	MC	30
307a8442-afe6-40f6-a83a-9913e40e06f8	2025	16	6bc28d4e-02a0-4377-ba30-4911d6869264	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-01-16 03:00:00+00	\N	\N	11	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:34.446+00	2026-01-03 17:21:34.446+00	t	Importada de JSONL. Empresa: GLACIAR PESQUERA. Especie: VIEIRA	MC	30
df130265-b15f-41b8-af75-f059f3d1c67b	2025	17	8ebc1a6e-0e89-4a93-adfe-898ff7ff6722	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-01-17 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:34.455+00	2026-01-03 17:21:34.455+00	t	Importada de JSONL. Empresa: ALTAMARE S.AS. Especie: CALAMAR	MC	30
dc7d7414-7b99-4594-8c9f-0c4e2acdf934	2025	18	cb661fd5-47f9-45e7-b815-642399c04b0d	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-01-17 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:34.465+00	2026-01-03 17:21:34.465+00	t	Importada de JSONL. Empresa: ALTAMARE S.AS. Especie: CALAMAR	MC	30
3d07eaaa-4f2d-4943-8b49-6b68c98acf6e	2025	19	0bd1e6fd-2907-4df7-95b3-102db086ed62	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-01-28 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:34.475+00	2026-01-03 17:21:34.475+00	t	Importada de JSONL. Empresa: BENTONICOS DE ARGENTINA. Especie: CENTOLLA	MC	30
2f88c725-e51c-4fa7-a41c-181de9d2c31b	2025	20	8d950e58-7292-4096-8513-16166ea032e8	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-01-28 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:34.485+00	2026-01-03 17:21:34.485+00	t	Importada de JSONL. Empresa: GIORNO. Especie: CALAMAR	MC	30
fc76dc57-7d86-4bf3-8975-86cb0745896e	2025	21	04154ef1-029a-4d21-a588-abdf7aefb604	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-02-04 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:34.495+00	2026-01-03 17:21:34.495+00	t	Importada de JSONL. Empresa: CRUSTACEOS DEL SUR S.A. Especie: CENTOLLA	MC	30
637b72e8-7cd2-469a-bc09-6436c4036fc6	2025	22	e67c9a1b-e098-4a2f-ac37-96533c396959	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-02-01 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:34.504+00	2026-01-03 17:21:34.504+00	t	Importada de JSONL. Empresa: ARGENOVA. Especie: CALAMAR	MC	30
45e7b82a-95cc-4504-885a-0ba429ebd302	2025	23	fb8399c6-65e2-4b91-b66f-ebdb6fa5173c	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-01-28 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:34.512+00	2026-01-03 17:21:34.512+00	t	Importada de JSONL. Empresa: ARBUMASA S.A. Especie: CALAMAR	MC	30
d4770b46-93e5-450e-a14a-045e3c55921a	2025	24	c2f6e135-2553-4a11-9bd1-df7416465dbd	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-01-31 03:00:00+00	\N	\N	22	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:34.524+00	2026-01-03 17:21:34.524+00	t	Importada de JSONL. Empresa: ARGENOVA. Especie: MERLUZA AUSTRAL	MC	30
dba672d1-635d-4764-9419-236dbca7597e	2025	25	38fabe2c-223f-4dd9-aa1d-e42ca6eff7d6	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-02-01 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:34.533+00	2026-01-03 17:21:34.533+00	t	Importada de JSONL. Empresa: BENTONICOS DE ARGENTINA. Especie: CENTOLLA	MC	30
81a14f82-6b0c-4a54-abc5-96193b76b47e	2025	26	b0acbcad-f1af-4b9d-804a-cb17bbc5b324	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-02-02 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:34.542+00	2026-01-03 17:21:34.542+00	t	Importada de JSONL. Empresa: GIORNO. Especie: MERLUZA	MC	30
2fc9e671-484e-44e7-8813-bb49719b6810	2025	27	154ac509-9b6b-455f-881c-a59d0cbf2e7a	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-01-31 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:34.551+00	2026-01-03 17:21:34.551+00	t	Importada de JSONL. Empresa: CHIARPESCA. Especie: CALAMAR	MC	30
d3b9174c-5b99-44fa-93c8-9963972a4d85	2025	28	dc5524f0-9cf6-4d6d-890f-a5f1568cd976	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-02-06 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:34.56+00	2026-01-03 17:21:34.56+00	t	Importada de JSONL. Empresa: PESANTAR. Especie: CALAMAR	MC	60
59e31b81-9861-4563-9a9a-0f49b531654c	2025	29	978a06ff-7da9-42b8-aa6a-8de120b96f68	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-02-03 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:34.569+00	2026-01-03 17:21:34.569+00	t	Importada de JSONL. Empresa: EL MARISCO. Especie: MERLUZA	MC	30
87e3d15b-9ea9-4d71-8bf7-d1e61505b3bd	2025	30	0dd4491b-7b6b-4a7d-af09-3bee8e759097	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-02-12 03:00:00+00	\N	\N	83	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:34.579+00	2026-01-03 17:21:34.579+00	t	Importada de JSONL. Empresa: ESTREMAR. Especie: MERLUZA AUSTRAL	MC	30
ebd84e62-d379-43a1-85c0-2d8657bf0ee4	2025	31	3059e444-2a0b-4ef8-9c39-0e135c0c8755	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-02-02 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:34.588+00	2026-01-03 17:21:34.588+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: VIEIRA	MC	30
fcdec828-7006-4999-9c51-6c86ee7f27e8	2025	32	44ab546f-33ad-4d09-a025-5b67d3c995c4	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-02-19 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:34.597+00	2026-01-03 17:21:34.597+00	t	Importada de JSONL. Empresa: PRODESUR. Especie: MERLUZA AUSTRAL	MC	60
d3c77501-42da-427a-bba8-4900e1ded32a	2025	33	81723a1f-7293-4231-ab06-519cdfcfad2e	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-02-14 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:34.605+00	2026-01-03 17:21:34.605+00	t	Importada de JSONL. Empresa: PESQUERA VERAZ. Especie: MERLUZA	MC	30
5293a45e-c905-4705-a9d1-b35b2b90ab6e	2025	34	21f78c2d-2475-4c14-a29a-690be6abc768	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-02-27 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:34.615+00	2026-01-03 17:21:34.615+00	t	Importada de JSONL. Empresa: GLACIAR PESQUERA. Especie: VIEIRA	MC	30
87494f91-8145-46d8-bb6d-a138d3212bda	2025	35	c2f6e135-2553-4a11-9bd1-df7416465dbd	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-02-25 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:34.623+00	2026-01-03 17:21:34.623+00	t	Importada de JSONL. Empresa: ARGENOVA. Especie: MERLUZA AUSTRAL	MC	30
2fd183a7-a9c2-4424-abc7-87f31dde60d4	2025	36	6c4b9846-561e-42c3-b685-ad9a6df761e2	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-02-20 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:34.633+00	2026-01-03 17:21:34.633+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: VIEIRA	MC	30
c1e2b8ec-4cf9-4588-b1a6-f98fcd8205cb	2025	37	e02b50ee-f135-4657-9b14-6b00c7318fbe	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-02-21 03:00:00+00	\N	\N	29	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:34.641+00	2026-01-03 17:21:34.641+00	t	Importada de JSONL. Empresa: CRUSTACEOS DEL SUR S.A. Especie: CENTOLLA	MC	30
e170ff4a-5d24-4e6e-8eff-379c2233e544	2025	38	1e28bd98-19b3-4e8b-9ff6-31d95dbd2712	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-03-05 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:34.65+00	2026-01-03 17:21:34.65+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: CENTOLLA	MC	30
645d9c0d-6287-4893-907b-cdec6037c93e	2025	39	0bd1e6fd-2907-4df7-95b3-102db086ed62	\N	081d416b-af3c-4c1d-a2db-3525f5db5c36	2025-03-06 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:34.659+00	2026-01-03 17:21:34.659+00	t	Importada de JSONL. Empresa: BENTONICOS DE ARGENTINA. Especie: CENTOLLA	MC	30
8131a5ea-08f0-43db-92e2-6199a41f8fa1	2025	40	6bc28d4e-02a0-4377-ba30-4911d6869264	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-03-06 03:00:00+00	\N	\N	6	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:34.664+00	2026-01-03 17:21:34.664+00	t	Importada de JSONL. Empresa: GLACIAR PESQUERA. Especie: VIEIRA	MC	30
a64c5389-8b8b-4799-b34e-7a2c179ae9d1	2025	41	8fbc0800-2efd-465d-bf3f-48909f0b0e04	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-03-03 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:34.674+00	2026-01-03 17:21:34.674+00	t	Importada de JSONL. Empresa: FOOD ARTS S.A. Especie: CALAMAR	MC	30
ab8a5193-0b12-4733-9e00-c7030ca1d065	2025	42	ba586794-9245-4f24-82f8-2cd9baf218e7	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-03-07 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:34.683+00	2026-01-03 17:21:34.683+00	t	Importada de JSONL. Empresa: TOZUDO. Especie: P.ABADEJO	MC	30
1800d269-7400-4661-b9ee-9bb1b1d5a5cf	2025	43	fccacfe7-f6ce-476d-ae25-60f6ac13f726	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-03-07 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:34.694+00	2026-01-03 17:21:34.694+00	t	Importada de JSONL. Empresa: PESQUERA SIEMPRE GAUCHO. Especie: P.ABADEJO	MC	30
d87a8412-71c4-45f4-9483-177e6772bff3	2025	44	f6a5dd08-2559-4ef3-99ef-2ec5f9cd2b98	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-03-07 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:34.705+00	2026-01-03 17:21:34.705+00	t	Importada de JSONL. Empresa: LOBA PESQUERA. Especie: P.ABADEJO	MC	30
60163f5c-4b4c-458f-b707-c6e58a21d86c	2025	45	53958a06-ae54-4965-be5b-05933b5145a2	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-03-07 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:34.715+00	2026-01-03 17:21:34.715+00	t	Importada de JSONL. Empresa: ROMFIOC S.R.L. Especie: P.ABADEJO	MC	30
6c571f5a-ef1c-4f4d-b570-975cc846e825	2025	46	7ac345e5-7c81-4e2c-a068-78606ad51c30	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-03-07 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:34.726+00	2026-01-03 17:21:34.726+00	t	Importada de JSONL. Empresa: MAREA OPTIMA. Especie: P.ABADEJO	MC	30
c7d13c76-8742-4204-b0a1-ad17e98110ee	2025	47	04154ef1-029a-4d21-a588-abdf7aefb604	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-03-12 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:34.736+00	2026-01-03 17:21:34.736+00	t	Importada de JSONL. Empresa: CRUSTACEOS DEL SUR S.A. Especie: CENTOLLA	MC	30
aa253bbe-f038-4f47-bfb9-b8aa6ec8c959	2025	48	1ed56e47-4ae5-439e-9dc4-c3aecf7480aa	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-03-12 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:34.744+00	2026-01-03 17:21:34.744+00	t	Importada de JSONL. Empresa: CENTOMAR S.A. Especie: CENTOLLA	MC	30
9563ce8a-6958-48a9-9a5d-0ec2d7eb9bf5	2025	49	c9f2edf2-e621-47b6-9bce-7b976ef976f3	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-03-18 03:00:00+00	\N	\N	27	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:34.754+00	2026-01-03 17:21:34.754+00	t	Importada de JSONL. Empresa: ESTRELLA PATAGONICA. Especie: MERLUZA	MC	30
2572f21d-491b-4ed0-9f1f-f72627e617f8	2025	50	970bca10-24df-4db6-b63f-de24f2f15d4d	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-03-22 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:34.762+00	2026-01-03 17:21:34.762+00	t	Importada de JSONL. Empresa: MOSCUZZA. Especie: CALAMAR	MC	30
4aff51a8-fdb7-4e96-821f-b4e1617a72f2	2025	51	3059e444-2a0b-4ef8-9c39-0e135c0c8755	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-03-24 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:34.772+00	2026-01-03 17:21:34.772+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: VIEIRA	MC	30
619264db-438e-4bdd-9544-8a4595d9cbae	2025	52	c2f6e135-2553-4a11-9bd1-df7416465dbd	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-03-27 03:00:00+00	\N	\N	25	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:34.78+00	2026-01-03 17:21:34.78+00	t	Importada de JSONL. Empresa: ARGENOVA. Especie: MERLUZA AUSTRAL	MC	30
68f9a3a6-61ba-417d-aec6-745e942d6f9c	2025	53	9a6204b6-657f-4a1c-a75c-bd5358e5b6b7	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-03-28 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:34.793+00	2026-01-03 17:21:34.793+00	t	Importada de JSONL. Empresa: PEDRO MOSCUZZA E HIJO. Especie: CALAMAR	MC	30
ad035c1d-4b90-43bd-abed-6eed873f2bb9	2025	54	6c4b9846-561e-42c3-b685-ad9a6df761e2	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-04-09 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:34.801+00	2026-01-03 17:21:34.801+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: VIEIRA	MC	30
cc5eb69e-6e1e-4297-9b13-7848bb38f572	2025	55	44ab546f-33ad-4d09-a025-5b67d3c995c4	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-04-17 03:00:00+00	\N	\N	1	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:34.809+00	2026-01-03 17:21:34.809+00	t	Importada de JSONL. Empresa: PRODESUR. Especie: MERLUZA AUSTRAL	MC	60
1780fcd8-c848-4a22-86a2-6b6e2e809a9d	2025	56	dc5524f0-9cf6-4d6d-890f-a5f1568cd976	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-04-10 03:00:00+00	\N	\N	39	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:34.817+00	2026-01-03 17:21:34.817+00	t	Importada de JSONL. Empresa: PESANTAR. Especie: MERLUZA AUSTRAL	MC	60
b5d4e4f9-2839-4f34-a2b4-6ee91efde858	2025	57	0bd1e6fd-2907-4df7-95b3-102db086ed62	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-04-09 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:34.824+00	2026-01-03 17:21:34.824+00	t	Importada de JSONL. Empresa: BENTONICOS DE ARGENTINA. Especie: CENTOLLA	MC	30
12ba51db-a35a-4849-8a2e-98978b0115b4	2025	58	54908ddf-3ef2-419d-b99a-c8e3e862441f	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-04-22 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:34.832+00	2026-01-03 17:21:34.832+00	t	Importada de JSONL. Empresa: VIERA ARGENTINA. Especie: CALAMAR	MC	30
9d2c0639-31ca-43fa-927e-a5dfb270cea1	2025	59	21f78c2d-2475-4c14-a29a-690be6abc768	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-04-10 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:34.839+00	2026-01-03 17:21:34.839+00	t	Importada de JSONL. Empresa: GLACIAR PESQUERA. Especie: VIEIRA	MC	30
ec689725-c1b6-4a8f-a879-ae61a9c189dd	2025	60	1e28bd98-19b3-4e8b-9ff6-31d95dbd2712	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-04-10 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:34.846+00	2026-01-03 17:21:34.846+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: CENTOLLA	MC	30
84faeb38-ffff-4311-b37a-5e6386304f30	2025	61	6bc28d4e-02a0-4377-ba30-4911d6869264	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-04-17 03:00:00+00	\N	\N	6	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:34.853+00	2026-01-03 17:21:34.853+00	t	Importada de JSONL. Empresa: GLACIAR PESQUERA. Especie: VIEIRA	MC	30
a930beef-a27d-47cb-a3f3-3aa11a6110df	2025	62	c0ef5db9-8050-4de3-9a97-6ae52b3ae807	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-04-15 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:34.86+00	2026-01-03 17:21:34.86+00	t	Importada de JSONL. Empresa: ALTAMARE S.AS. Especie: CALAMAR	MC	30
422c60b2-75be-4b6e-980a-4f76c36016a2	2025	63	34173232-2f69-4ab7-8108-0b3269c089e3	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-04-11 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:34.867+00	2026-01-03 17:21:34.867+00	t	Importada de JSONL. Empresa: PESCARGEN. Especie: LANGOSTINO	MC	30
3ffaa44e-b3c8-4121-a457-1173121dd3f7	2025	64	b0acbcad-f1af-4b9d-804a-cb17bbc5b324	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-04-22 03:00:00+00	\N	\N	6	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:34.878+00	2026-01-03 17:21:34.878+00	t	Importada de JSONL. Empresa: GIORNO. Especie: MERLUZA	MC	30
e7b08c67-748f-4a22-898d-2a890e5a35ab	2025	65	69579cb8-694d-4def-a89f-688e6690b24b	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-04-15 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:34.885+00	2026-01-03 17:21:34.885+00	t	Importada de JSONL. Empresa: LUIS SOLIMENO. Especie: MERLUZA	MC	30
856b8a70-51e9-4718-b68f-b687e83d0425	2025	66	16325e14-390b-45ef-9e96-efdf445fe843	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-04-21 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:34.9+00	2026-01-03 17:21:34.9+00	t	Importada de JSONL. Empresa: MARÍTIMA COMERCIAL. Especie: MERLUZA	MC	30
3684f797-79a9-4cb2-b326-696b7c0ef365	2025	67	ba1feacb-a508-4dc0-bcda-2263288171b3	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-04-29 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:34.909+00	2026-01-03 17:21:34.909+00	t	Importada de JSONL. Empresa: NIETOS ANTONIO BALDINO. Especie: MERLUZA	MC	30
3002074e-8d09-4956-ba16-1b65f7eb2ce7	2025	68	04218708-5626-4ad0-9d18-9f02d896b639	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-04-23 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:34.916+00	2026-01-03 17:21:34.916+00	t	Importada de JSONL. Empresa: MOSCUZZA. Especie: MERLUZA	MC	30
09118173-ca86-43a2-81c5-62ff82a8db78	2025	69	970bca10-24df-4db6-b63f-de24f2f15d4d	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-04-26 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:34.927+00	2026-01-03 17:21:34.927+00	t	Importada de JSONL. Empresa: MOSCUZZA. Especie: CALAMAR	MC	30
3e309bb1-041d-4a61-bd36-bba980ca60f7	2025	70	5268e0ed-a3df-4e0d-9507-1ceb2814a9c3	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-04-25 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:34.934+00	2026-01-03 17:21:34.934+00	t	Importada de JSONL. Empresa: MARONTI  S.A.. Especie: MERLUZA	MC	30
7ea29288-647f-42b3-a218-3dde8200bfa7	2025	71	154ac509-9b6b-455f-881c-a59d0cbf2e7a	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-04-24 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:34.945+00	2026-01-03 17:21:34.945+00	t	Importada de JSONL. Empresa: GRUPO CHIAR PESCA. Especie: CALAMAR	MC	30
35544167-6977-40f7-ba1a-07b135e64236	2025	72	c2f6e135-2553-4a11-9bd1-df7416465dbd	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-04-29 03:00:00+00	\N	\N	24	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:34.951+00	2026-01-03 17:21:34.951+00	t	Importada de JSONL. Empresa: ARGENOVA. Especie: MERLUZA AUSTRAL	MC	30
fab442d9-b253-4f60-8e1a-459dcd40e213	2025	73	801fd0f5-cb21-497a-829a-dc32b5af28f2	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-04-26 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:34.959+00	2026-01-03 17:21:34.959+00	t	Importada de JSONL. Empresa: BUENA PROA. Especie: MERLUZA	MC	30
de28daf8-b209-4635-8035-5864d2d63219	2025	74	2bb6448e-c8d5-4af1-9988-19bae2d54042	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-04-30 03:00:00+00	\N	\N	7	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:34.972+00	2026-01-03 17:21:34.972+00	t	Importada de JSONL. Empresa: GIORNO. Especie: MERLUZA	MC	30
200a2332-e2bd-4da7-890e-9a55e128449e	2025	75	0dd4491b-7b6b-4a7d-af09-3bee8e759097	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-05-07 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:34.979+00	2026-01-03 17:21:34.979+00	t	Importada de JSONL. Empresa: ESTREMAR. Especie: MERLUZA AUSTRAL	MC	30
aaa6a72d-ffa9-4176-851c-a595c5010ae8	2025	76	3059e444-2a0b-4ef8-9c39-0e135c0c8755	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-05-07 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:34.985+00	2026-01-03 17:21:34.985+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: VIEIRA	MC	30
f41dc2ec-d08f-4571-9878-8f3c8eb53dbe	2025	77	c66f1349-8b7b-44dc-8140-0f896fed0fe9	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-05-04 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:34.992+00	2026-01-03 17:21:34.992+00	t	Importada de JSONL. Empresa: GIORNO. Especie: MERLUZA	MC	30
b2dd8dce-929b-4342-ae86-bc34b4af1ad8	2025	78	42cd5d3b-d0e1-408a-942f-c042e13bab48	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-05-06 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:34.999+00	2026-01-03 17:21:34.999+00	t	Importada de JSONL. Empresa: FOOD ARTS S.A. Especie: CALAMAR	MC	30
63fccc66-9abf-403c-9599-b82a48710d67	2025	79	9a6204b6-657f-4a1c-a75c-bd5358e5b6b7	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-05-06 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.006+00	2026-01-03 17:21:35.006+00	t	Importada de JSONL. Empresa: MOSCUZZA. Especie: CALAMAR	MC	30
6d865537-c61a-410c-915b-2ac8e24ba9ad	2025	80	34173232-2f69-4ab7-8108-0b3269c089e3	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-05-10 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.012+00	2026-01-03 17:21:35.012+00	t	Importada de JSONL. Empresa: PESCAREN S.A. Especie: LANGOSTINO	MC	30
9b984f08-2fd5-4554-81f0-6ac693c7220e	2025	81	1e28bd98-19b3-4e8b-9ff6-31d95dbd2712	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-05-15 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.018+00	2026-01-03 17:21:35.018+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: CENTOLLA	MC	30
667ef67d-79c0-4a0c-b825-53f32a0cfba7	2025	82	dc5524f0-9cf6-4d6d-890f-a5f1568cd976	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-05-22 03:00:00+00	\N	\N	50	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.026+00	2026-01-03 17:21:35.026+00	t	Importada de JSONL. Empresa: PESANTAR. Especie: MERLUZA AUSTRAL	MC	60
ee516229-0f07-492d-92ce-ad48ec42dbe2	2025	83	6c8d7809-be24-4d31-a90e-84cd31823b7e	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-05-17 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.033+00	2026-01-03 17:21:35.033+00	t	Importada de JSONL. Empresa: MOSCUZZA. Especie: MERLUZA	MC	30
87cc6c0e-7bf7-472b-98b3-cfc46043114e	2025	84	2efdc2cd-8105-4bde-956d-37ec4d99b7be	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-05-20 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.04+00	2026-01-03 17:21:35.04+00	t	Importada de JSONL. Empresa: LUIS SOLIMENO. Especie: MERLUZA	MC	30
ff6c9466-43d8-42ac-a3aa-e6d4f8ea68ad	2025	85	2bb6448e-c8d5-4af1-9988-19bae2d54042	\N	081d416b-af3c-4c1d-a2db-3525f5db5c36	2025-05-20 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.048+00	2026-01-03 17:21:35.048+00	t	Importada de JSONL. Empresa: GIORNO. Especie: MERLUZA	MC	30
b45e3b51-67dd-4fa9-9a2a-c3260f55bf30	2025	86	b3137323-101b-461c-b0fd-843f49b4ecd2	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-05-20 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.053+00	2026-01-03 17:21:35.053+00	t	Importada de JSONL. Empresa: LUIS SOLIMENO. Especie: CALAMAR	MC	30
f923d047-ecd0-4deb-a466-e693d90084e5	2025	87	44ab546f-33ad-4d09-a025-5b67d3c995c4	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-05-20 03:00:00+00	\N	\N	31	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.061+00	2026-01-03 17:21:35.061+00	t	Importada de JSONL. Empresa: PRODESUR. Especie: MERLUZA AUSTRAL	MC	60
403aeda4-fd23-458e-83d1-cc092754265e	2025	88	6c4b9846-561e-42c3-b685-ad9a6df761e2	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-05-26 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.068+00	2026-01-03 17:21:35.068+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: VIEIRA	MC	30
8dc26729-00b4-4da1-ba63-ab0dd4baf5bf	2025	89	6bc28d4e-02a0-4377-ba30-4911d6869264	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-05-31 03:00:00+00	\N	\N	6	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.075+00	2026-01-03 17:21:35.075+00	t	Importada de JSONL. Empresa: GLACIAR PESQUERA. Especie: VIEIRA	MC	30
685172ce-7671-441d-959e-79f01bf727ca	2025	90	34173232-2f69-4ab7-8108-0b3269c089e3	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-05-28 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.081+00	2026-01-03 17:21:35.081+00	t	Importada de JSONL. Empresa: PESCARGEN. Especie: LANGOSTINO	MC	30
10e8da42-a01e-4169-bbf6-ec4548bcc2f7	2025	91	970bca10-24df-4db6-b63f-de24f2f15d4d	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-05-29 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.091+00	2026-01-03 17:21:35.091+00	t	Importada de JSONL. Empresa: MOSCUZZA. Especie: CALAMAR	MC	30
5f7d74b6-4d31-4ca7-afae-74d30f5c600a	2025	92	f6faf395-8bfa-4c3b-943b-b13f065bf0aa	\N	081d416b-af3c-4c1d-a2db-3525f5db5c36	2025-05-29 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.102+00	2026-01-03 17:21:35.102+00	t	Importada de JSONL. Empresa: CONARPESA. Especie: LANGOSTINO	MC	30
0492626d-b4c5-4fe2-9bdd-1fd02b3c8a32	2025	93	21f78c2d-2475-4c14-a29a-690be6abc768	\N	081d416b-af3c-4c1d-a2db-3525f5db5c36	2025-06-11 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.106+00	2026-01-03 17:21:35.106+00	t	Importada de JSONL. Empresa: GLACIAR PESQUERA. Especie: VIERA	MC	30
1b74e2a7-70bd-4549-ba41-87bc5f724575	2025	94	44b20244-5d7f-4270-b436-c486062fd7ac	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-06-09 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.111+00	2026-01-03 17:21:35.111+00	t	Importada de JSONL. Empresa: ARPES. Especie: MERLUZA	MC	30
15cb7ab1-9781-4847-9a53-d334f89db880	2025	95	c66f1349-8b7b-44dc-8140-0f896fed0fe9	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-06-06 03:00:00+00	\N	\N	1	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.125+00	2026-01-03 17:21:35.125+00	t	Importada de JSONL. Empresa: GIORNO. Especie: MERLUZA	MC	30
dc46d9af-3591-4a9a-8b3c-45e0f7ea68a8	2025	96	b0acbcad-f1af-4b9d-804a-cb17bbc5b324	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-06-06 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.132+00	2026-01-03 17:21:35.132+00	t	Importada de JSONL. Empresa: GIORNO. Especie: MERLUZA	MC	30
103dd1d9-6b45-4da0-9574-b8cd63b457ec	2025	97	53958a06-ae54-4965-be5b-05933b5145a2	\N	081d416b-af3c-4c1d-a2db-3525f5db5c36	2025-06-17 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.138+00	2026-01-03 17:21:35.138+00	t	Importada de JSONL. Empresa: ROMFIOC S.R.L. Especie: MERLUZA	MC	30
cc3f6247-b010-4188-a325-1bc32f5761d5	2025	98	0dd4491b-7b6b-4a7d-af09-3bee8e759097	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-06-17 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.143+00	2026-01-03 17:21:35.143+00	t	Importada de JSONL. Empresa: ESTREMAR. Especie: MERLUZA AUSTRAL	MC	30
e59df295-88ed-4f1d-8562-7d08031e59a3	2025	99	801fd0f5-cb21-497a-829a-dc32b5af28f2	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-06-12 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.149+00	2026-01-03 17:21:35.149+00	t	Importada de JSONL. Empresa: BUENA PROA. Especie: MERLUZA	MC	30
d5b3d85f-f833-4928-8308-9b690bc69705	2025	100	3059e444-2a0b-4ef8-9c39-0e135c0c8755	\N	081d416b-af3c-4c1d-a2db-3525f5db5c36	2025-06-17 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.165+00	2026-01-03 17:21:35.165+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: VIERA	MC	30
839e302c-a597-4df4-a058-d14d8dbcc63e	2025	101	f24414d5-d81c-4561-94b1-666d8292df8b	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-06-18 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.17+00	2026-01-03 17:21:35.17+00	t	Importada de JSONL. Empresa: BUENA PROA. Especie: P. LANGOSTINO	MC	30
adf22815-c33d-41c2-99a1-df4f4fcdf964	2025	102	34173232-2f69-4ab7-8108-0b3269c089e3	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-06-17 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.179+00	2026-01-03 17:21:35.179+00	t	Importada de JSONL. Empresa: PESCARGEN. Especie: P. LANGOSTINO	MC	30
54dbd5e2-12b2-49ff-a252-d608e6de12be	2025	103	d9a0182a-a933-4dbb-9c9b-73a4935c8277	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-06-17 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.186+00	2026-01-03 17:21:35.186+00	t	Importada de JSONL. Empresa: FRIGORÍFICO DON LUIS. Especie: P. LANGOSTINO	MC	30
222beb76-8251-43c2-96b1-040eb3d62d2c	2025	104	86449f5a-ad5e-4c85-bb01-620b9df96b29	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-06-18 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.193+00	2026-01-03 17:21:35.193+00	t	Importada de JSONL. Empresa: URLIPEZ. Especie: P. LANGOSTINO	MC	30
ae1e0de9-959d-40d0-a4e7-fe297d4278cf	2025	105	ac52fda9-c96e-4ec6-8bff-418fec142293	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-06-19 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.2+00	2026-01-03 17:21:35.2+00	t	Importada de JSONL. Empresa: DE ANGELIS Y LOGGHE. Especie: P. LANGOSTINO	MC	30
24318725-7a21-4a9f-ac39-7ad93ef21a9e	2025	106	d5e70762-b9dd-4e65-aea3-2c45e45577c6	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-06-17 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.207+00	2026-01-03 17:21:35.207+00	t	Importada de JSONL. Empresa: PESCA ANTIGUA. Especie: P. LANGOSTINO	MC	30
d95e430e-2b2f-4b2d-97ce-f08c148a0980	2025	107	285883e4-219f-4ad5-bcae-71ea8ab7d5c5	\N	081d416b-af3c-4c1d-a2db-3525f5db5c36	2025-06-21 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.215+00	2026-01-03 17:21:35.215+00	t	Importada de JSONL. Empresa: IBERCONSA. Especie: MERLUZA	MC	30
5aa25b11-e231-4a6e-a3a1-116334ab0772	2025	108	69579cb8-694d-4def-a89f-688e6690b24b	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-06-24 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.22+00	2026-01-03 17:21:35.22+00	t	Importada de JSONL. Empresa: SOLIMENO E HIJOS. Especie: MERLUZA	MC	30
9079c6c5-3005-42e7-8679-c458d95c9d11	2025	109	21f78c2d-2475-4c14-a29a-690be6abc768	\N	081d416b-af3c-4c1d-a2db-3525f5db5c36	2025-06-23 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.232+00	2026-01-03 17:21:35.232+00	t	Importada de JSONL. Empresa: GLACIAR PESQUERA. Especie: VIERA	MC	30
cc3cce6e-9657-4dd4-b786-ed0c33ee23f0	2025	110	d9a0182a-a933-4dbb-9c9b-73a4935c8277	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-06-27 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.237+00	2026-01-03 17:21:35.237+00	t	Importada de JSONL. Empresa: FRIGORÍFICO DON LUIS. Especie: P. LANGOSTINO	MC	30
bc42f4c4-c5ef-4959-a179-73c5ef65f857	2025	111	ac52fda9-c96e-4ec6-8bff-418fec142293	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-06-27 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.244+00	2026-01-03 17:21:35.244+00	t	Importada de JSONL. Empresa: DE ANGELIS Y LOGGHE. Especie: P. LANGOSTINO	MC	30
a45428ce-a312-4138-991d-0143bd917616	2025	112	718be8c9-0022-4f00-b382-2e9c30d751e6	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-06-27 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.254+00	2026-01-03 17:21:35.254+00	t	Importada de JSONL. Empresa: CANAL DE BEAGLE. Especie: P. LANGOSTINO	MC	30
c55d9b8f-3391-4f0d-8d29-988bb5e78eef	2025	113	81723a1f-7293-4231-ab06-519cdfcfad2e	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-07-01 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.261+00	2026-01-03 17:21:35.261+00	t	Importada de JSONL. Empresa: PESQUERA VERAZ. Especie: MERLUZA	MC	30
271db235-d1d1-46f6-b276-09a8c5bb58a1	2025	114	21f78c2d-2475-4c14-a29a-690be6abc768	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-07-10 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.272+00	2026-01-03 17:21:35.272+00	t	Importada de JSONL. Empresa: GLACIAR PESQUERA. Especie: VIERA	MC	30
0b421289-58d3-4fec-a4cf-a1a6acfdbfb0	2025	115	3059e444-2a0b-4ef8-9c39-0e135c0c8755	\N	081d416b-af3c-4c1d-a2db-3525f5db5c36	2025-07-08 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.279+00	2026-01-03 17:21:35.279+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: VIERA	MC	30
9bb5bcd9-ea49-445d-b1b3-bfb793d8e819	2025	116	6bc28d4e-02a0-4377-ba30-4911d6869264	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-07-15 03:00:00+00	\N	\N	3	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.283+00	2026-01-03 17:21:35.283+00	t	Importada de JSONL. Empresa: GLACIAR PESQUERA. Especie: VIERA	MC	30
df531ff6-671c-4e34-bace-c43036c4dd83	2025	117	34173232-2f69-4ab7-8108-0b3269c089e3	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-07-11 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.29+00	2026-01-03 17:21:35.29+00	t	Importada de JSONL. Empresa: PESCARGEN. Especie: LANGOSTINO	MC	30
575b01a8-9475-4f8a-8ddc-f6977e3e6a60	2025	118	ab232060-ee9d-409c-baeb-d5899b9f7419	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-07-11 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.296+00	2026-01-03 17:21:35.296+00	t	Importada de JSONL. Empresa: BUENA PROA. Especie: LANGOSTINO	MC	30
9f2d46f2-19ff-49de-a8da-40d8fdda0063	2025	119	20e20ee7-053c-4c4b-9ff0-c4da7977fc1f	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-07-12 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.303+00	2026-01-03 17:21:35.303+00	t	Importada de JSONL. Empresa: IBERCONSA. Especie: MERLUZA	MC	30
1cc6ddfd-ab7a-45d9-9518-83bc016b844f	2025	120	de509aac-4e69-4093-b416-0409d5cad35c	\N	081d416b-af3c-4c1d-a2db-3525f5db5c36	2025-07-11 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.309+00	2026-01-03 17:21:35.309+00	t	Importada de JSONL. Empresa: RITONDO SALLUSTIO Y CICCIOTTI. Especie: LANGOSTINO	MC	30
e45f4d38-3c4d-4e1f-a27a-81d86d06be29	2025	121	228d87cf-d7e9-4c8b-8d11-ec933731f98e	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-07-15 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.313+00	2026-01-03 17:21:35.313+00	t	Importada de JSONL. Empresa: MOSCUZZA. Especie: LANGOSTINO	MC	30
ae273e3f-ec3d-4efd-98e9-0288a3c73e54	2025	122	6c4b9846-561e-42c3-b685-ad9a6df761e2	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-07-16 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.328+00	2026-01-03 17:21:35.328+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: VIEIRA	MC	30
32851f3b-ac62-449a-b6ec-ff7aa7e686fe	2025	123	b0acbcad-f1af-4b9d-804a-cb17bbc5b324	\N	081d416b-af3c-4c1d-a2db-3525f5db5c36	2025-07-19 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.336+00	2026-01-03 17:21:35.336+00	t	Importada de JSONL. Empresa: GIORNO S.A. Especie: MERLUZA	MC	30
1b8bfd91-7564-40a3-a292-1294175086c9	2025	124	c66f1349-8b7b-44dc-8140-0f896fed0fe9	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-07-19 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.341+00	2026-01-03 17:21:35.341+00	t	Importada de JSONL. Empresa: GIORNO S.A. Especie: MERLUZA	MC	30
877056b7-630e-4fba-a378-1e4f2d9ae78d	2025	125	f6faf395-8bfa-4c3b-943b-b13f065bf0aa	\N	081d416b-af3c-4c1d-a2db-3525f5db5c36	2025-07-18 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.347+00	2026-01-03 17:21:35.347+00	t	Importada de JSONL. Empresa: CONARPESA. Especie: LANGOSTINO	MC	30
984f35e8-99c6-4782-8641-04aadf0e5e01	2025	126	801fd0f5-cb21-497a-829a-dc32b5af28f2	\N	081d416b-af3c-4c1d-a2db-3525f5db5c36	2025-07-18 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.352+00	2026-01-03 17:21:35.352+00	t	Importada de JSONL. Empresa: BUENA PROA. Especie: LANGOSTINO	MC	30
db83da74-e00b-48a6-933a-c084d1b9e1f8	2025	127	1393a41f-760d-43fc-8f8d-4e6d19863911	\N	081d416b-af3c-4c1d-a2db-3525f5db5c36	2025-07-18 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.356+00	2026-01-03 17:21:35.356+00	t	Importada de JSONL. Empresa: CONARPESA. Especie: LANGOSTINO	MC	30
92efeca5-7164-454c-b684-aeb9b1efb613	2025	128	498aef6e-12e4-4207-9259-6a97ac789237	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-07-18 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.361+00	2026-01-03 17:21:35.361+00	t	Importada de JSONL. Empresa: PEDRO MOSCUZZA E HIJO. Especie: MERLUZA	MC	30
5ecf438b-b6dd-4f77-94db-9af206c161f9	2025	129	04218708-5626-4ad0-9d18-9f02d896b639	\N	7686e133-c020-4217-b227-43529e1a6d06	2025-07-21 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.366+00	2026-01-03 17:21:35.366+00	t	Importada de JSONL. Empresa: PEDRO MOSCUZZA E HIJO. Especie: LANGOSTINO	MC	30
4da89d1e-1a25-4096-9ecb-dddd570862ea	2025	130	285883e4-219f-4ad5-bcae-71ea8ab7d5c5	\N	081d416b-af3c-4c1d-a2db-3525f5db5c36	2025-07-22 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.373+00	2026-01-03 17:21:35.373+00	t	Importada de JSONL. Empresa: IBERCONSA. Especie: LANGOSTINO	MC	30
79fc2a77-8d70-4eb0-94db-3264792097fa	2025	131	27e39eaf-262a-4d6d-9797-0c64bac0cc6c	\N	081d416b-af3c-4c1d-a2db-3525f5db5c36	2025-07-22 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.377+00	2026-01-03 17:21:35.377+00	t	Importada de JSONL. Empresa: EMPESUR. Especie: LANGOSTINO	MC	30
38ff5eff-3550-4cf8-b8dd-202a09ed77ed	2025	132	aa60f8bb-4209-49bd-bfef-7010789a7400	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-07-23 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.382+00	2026-01-03 17:21:35.382+00	t	Importada de JSONL. Empresa: BUENOS AIRES PESCA S.A. Especie: LANGOSTINO	MC	30
1d268299-d910-480d-ae58-7fa550b4d388	2025	133	eff8c471-72e1-4f74-bdaa-f3219dcc1154	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-07-23 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.389+00	2026-01-03 17:21:35.389+00	t	Importada de JSONL. Empresa: BUENOS AIRES PESCA S.A. Especie: LANGOSTINO	MC	30
6a7326b6-9ba0-4978-94be-7a711d673ab8	2025	134	801fd0f5-cb21-497a-829a-dc32b5af28f2	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-07-25 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.396+00	2026-01-03 17:21:35.396+00	t	Importada de JSONL. Empresa: BUENA PROA. Especie: LANGOSTINO	MC	30
bb30f796-0e80-42e3-9b01-5af52531be46	2025	135	44b20244-5d7f-4270-b436-c486062fd7ac	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-07-27 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.403+00	2026-01-03 17:21:35.403+00	t	Importada de JSONL. Empresa: ARPES. Especie: MERLUZA	MC	30
e02a256a-0717-4e29-85c5-98f63ef4c36e	2025	136	e02b50ee-f135-4657-9b14-6b00c7318fbe	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-07-28 03:00:00+00	\N	\N	42	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.416+00	2026-01-03 17:21:35.416+00	t	Importada de JSONL. Empresa: CRUSTACEOS DEL SUR S.A. Especie: CENTOLLA	MC	60
0bbf48d0-b7a3-4844-8d21-4d1022f0407e	2025	137	48c5340f-a868-454d-9557-db46091f8c02	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-07-29 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.423+00	2026-01-03 17:21:35.423+00	t	Importada de JSONL. Empresa: CENTOMAR S.A. Especie: LANGOSTINO	MC	30
c0925a32-18a7-4c54-bab7-40c9500222a8	2025	138	db105913-3875-49fd-bb46-eaf8e5c042b4	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-08-04 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.43+00	2026-01-03 17:21:35.43+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: LANGOSTINO	MC	30
929932c1-baea-4ff5-bf11-6f3b378140ea	2025	139	ab232060-ee9d-409c-baeb-d5899b9f7419	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-08-02 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.438+00	2026-01-03 17:21:35.438+00	t	Importada de JSONL. Empresa: BUENA PROA. Especie: LANGOSTINO	MC	30
3ceabac2-76bd-49d8-a5d4-a673f68f3b54	2025	140	e20881d1-0845-433f-87b8-42a97a63c732	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-08-05 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.446+00	2026-01-03 17:21:35.446+00	t	Importada de JSONL. Empresa: ARBUMASA S.A. Especie: LANGOSTINO	MC	30
72b618ec-e398-49ab-9eda-c1f9d779c15f	2025	141	21891799-0013-4119-b39d-4ce7652ab8a4	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-08-05 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.452+00	2026-01-03 17:21:35.452+00	t	Importada de JSONL. Empresa: ARBUMASA S.A. Especie: LANGOSTINO	MC	30
ed42bb8a-ba14-47a7-a3a6-7970a1aa511c	2025	142	769fa5de-b970-40f8-88b3-937a08baba8b	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-08-06 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.458+00	2026-01-03 17:21:35.458+00	t	Importada de JSONL. Empresa: SOLIMENO E HIJOS. Especie: MERLUZA	MC	30
72b5eaac-da40-4351-ab39-e47678e15d1d	2025	143	c7a080f5-a400-47aa-addc-c4c4b9fb231f	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-08-07 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.471+00	2026-01-03 17:21:35.471+00	t	Importada de JSONL. Empresa: PEDRO MOSCUZZA E HIJO. Especie: LANGOSTINO	MC	30
9209f5df-7f3b-4d73-a28c-3171c4beac1f	2025	144	376affbd-91af-4476-98e5-f8a577904a8b	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-08-07 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.478+00	2026-01-03 17:21:35.478+00	t	Importada de JSONL. Empresa: PEDRO MOSCUZZA E HIJO. Especie: LANGOSTINO	MC	30
a91c333a-3cf5-460c-9b90-5942862c6d45	2025	145	add85a6e-a9de-4092-88ca-f46f65036bd9	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-08-12 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.486+00	2026-01-03 17:21:35.486+00	t	Importada de JSONL. Empresa: ANTONIO BALDINO E HIJOS. Especie: MERLUZA	MC	30
33633745-09fa-41cf-8999-73c50524bf14	2025	146	5268e0ed-a3df-4e0d-9507-1ceb2814a9c3	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-08-14 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.499+00	2026-01-03 17:21:35.499+00	t	Importada de JSONL. Empresa: MARONTI  S.A.. Especie: MERLUZA	MC	30
bd122fa5-fe08-41b3-a9e7-e22a6afdc559	2025	147	c66f1349-8b7b-44dc-8140-0f896fed0fe9	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-08-19 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.51+00	2026-01-03 17:21:35.51+00	t	Importada de JSONL. Empresa: GIORNO S.A. Especie: MERLUZA	MC	30
39617ada-2006-4438-98de-c648708bfd67	2025	148	b3915f6d-38c3-4006-a165-311b366842f5	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-08-18 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.517+00	2026-01-03 17:21:35.517+00	t	Importada de JSONL. Empresa: XEITOSIÑO. Especie: LANGOSTINO	MC	30
3e75a594-3c83-4bbb-a935-41c7f7b97e18	2025	149	404bec57-91c5-4a8f-b802-7c9ec062ee8e	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-08-19 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.524+00	2026-01-03 17:21:35.524+00	t	Importada de JSONL. Empresa: XEITOSIÑO. Especie: LANGOSTINO	MC	30
2f8b097e-c905-4113-9c24-91c7e1bc6fdb	2025	150	89dd615d-0156-4486-9201-39f8c694e534	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-08-25 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.531+00	2026-01-03 17:21:35.531+00	t	Importada de JSONL. Empresa: CONARPESA. Especie: LANGOSTINO	MC	30
e65e5a79-2f64-4f31-801e-8120797acc86	2025	151	2bb6448e-c8d5-4af1-9988-19bae2d54042	\N	081d416b-af3c-4c1d-a2db-3525f5db5c36	2025-08-29 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.536+00	2026-01-03 17:21:35.536+00	t	Importada de JSONL. Empresa: GIORNO. Especie: LANGOSTINO	MC	30
22c7640e-1c82-478c-ba99-c7aad500533c	2025	152	0b30d45d-9c05-4cb8-9160-374849649e16	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-08-29 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.541+00	2026-01-03 17:21:35.541+00	t	Importada de JSONL. Empresa: PESQUERA VERAZ SA. Especie: LANGOSTINO	MC	30
1146b6ca-433f-46c6-828e-20505d95a0e7	2025	153	498aef6e-12e4-4207-9259-6a97ac789237	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-08-30 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.548+00	2026-01-03 17:21:35.548+00	t	Importada de JSONL. Empresa: PEDRO MOSCUZZA E HIJO. Especie: MERLUZA	MC	30
99be84a2-c566-4889-8658-94d78a307c5e	2025	154	268edf53-c4b7-4753-a1a3-554f1fddca8f	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-09-05 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.554+00	2026-01-03 17:21:35.554+00	t	Importada de JSONL. Empresa: ARGENOVA S.A. Especie: LANGOSTINO	MC	30
f4c7effb-17ff-40d5-96f4-4f3c4b55a753	2025	155	6c4b9846-561e-42c3-b685-ad9a6df761e2	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-09-08 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.561+00	2026-01-03 17:21:35.561+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: VIEIRA	MC	30
49cb76e2-6c5c-41c8-844f-b6e822fe4a5d	2025	156	e02b50ee-f135-4657-9b14-6b00c7318fbe	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-09-11 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.568+00	2026-01-03 17:21:35.568+00	t	Importada de JSONL. Empresa: CRUSTACEOS DEL SUR S.A. Especie: CENTOLLA	MC	30
7e2b4aaa-aa80-4b25-8420-f362ff42341a	2025	157	04bfdbb4-a7bc-49a6-9786-648b581a3c47	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-09-10 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.574+00	2026-01-03 17:21:35.574+00	t	Importada de JSONL. Empresa: PESCASOL S.A. Especie: MERLUZA	MC	30
08aa1c5a-14d7-4dfb-baff-feecda733570	2025	158	21891799-0013-4119-b39d-4ce7652ab8a4	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-09-13 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.581+00	2026-01-03 17:21:35.581+00	t	Importada de JSONL. Empresa: ARBUMASA S.A. Especie: LANGOSTINO	MC	30
c9f0fdd5-39a3-4cdd-8f3c-9ea3cf16d665	2025	159	1e28bd98-19b3-4e8b-9ff6-31d95dbd2712	\N	7c1e102c-040c-41e2-a5a9-84d3c1c6948e	2025-09-11 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.587+00	2026-01-03 17:21:35.587+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: CENTOLLA	MC	30
40d73575-8ad6-4e4e-97be-efa35740cbc4	2025	160	1ed56e47-4ae5-439e-9dc4-c3aecf7480aa	\N	7c1e102c-040c-41e2-a5a9-84d3c1c6948e	2025-09-11 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.594+00	2026-01-03 17:21:35.594+00	t	Importada de JSONL. Empresa: CENTOMAR S.A. Especie: CENTOLLA	MC	30
c88c0b40-6dde-4958-ae24-0cb74e70ac0b	2025	161	38fabe2c-223f-4dd9-aa1d-e42ca6eff7d6	\N	91ed6780-31e7-43c7-999d-397109228a90	2025-09-11 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.6+00	2026-01-03 17:21:35.6+00	t	Importada de JSONL. Empresa: BENTONICOS DE ARGENTINA. Especie: CENTOLLA	MC	30
04c8b29b-d8a3-43dc-8970-1cc25eb9a5e6	2025	162	0bd1e6fd-2907-4df7-95b3-102db086ed62	\N	91ed6780-31e7-43c7-999d-397109228a90	2025-09-11 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.606+00	2026-01-03 17:21:35.606+00	t	Importada de JSONL. Empresa: BENTONICOS DE ARGENTINA. Especie: CENTOLLA	MC	30
b9cdc61d-04ab-43a8-8042-0ecd9802756c	2025	163	dc5524f0-9cf6-4d6d-890f-a5f1568cd976	\N	7c1e102c-040c-41e2-a5a9-84d3c1c6948e	2025-09-17 03:00:00+00	\N	\N	61	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.613+00	2026-01-03 17:21:35.613+00	t	Importada de JSONL. Empresa: PESANTAR. Especie: MERLUZA AUSTRAL	MC	30
df1ba756-d001-43d8-a9e6-daf83a275113	2025	164	404bec57-91c5-4a8f-b802-7c9ec062ee8e	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-09-19 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.62+00	2026-01-03 17:21:35.62+00	t	Importada de JSONL. Empresa: XEITOSIÑO. Especie: LANGOSTINO	MC	30
4d568a25-d459-47e3-b304-51cc271329e9	2025	165	0dd4491b-7b6b-4a7d-af09-3bee8e759097	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	2025-09-29 03:00:00+00	\N	\N	31	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.627+00	2026-01-03 17:21:35.627+00	t	Importada de JSONL. Empresa: ESTREMAR. Especie: MERLUZA AUSTRAL	MC	30
8c72194b-9889-4483-987c-9e35da7f3975	2025	166	c2f6e135-2553-4a11-9bd1-df7416465dbd	\N	7c1e102c-040c-41e2-a5a9-84d3c1c6948e	2025-09-29 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.634+00	2026-01-03 17:21:35.634+00	t	Importada de JSONL. Empresa: ARGENOVA. Especie: MERLUZA AUSTRAL	MC	30
7b29487c-a17f-4a2d-aecc-37099df405c3	2025	167	81723a1f-7293-4231-ab06-519cdfcfad2e	\N	7c1e102c-040c-41e2-a5a9-84d3c1c6948e	2025-09-26 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.64+00	2026-01-03 17:21:35.64+00	t	Importada de JSONL. Empresa: PESQUERA VERAZ S.A. Especie: MERLUZA	MC	30
e4232ca1-ac45-4b98-82c2-04f4ddfd3b9a	2025	168	498aef6e-12e4-4207-9259-6a97ac789237	\N	7c1e102c-040c-41e2-a5a9-84d3c1c6948e	2025-10-14 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.656+00	2026-01-03 17:21:35.656+00	t	Importada de JSONL. Empresa: PEDRO MOSCUZZA E HIJO. Especie: MERLUZA	MC	30
1ed14f37-2218-40e5-b02f-bf29559ed482	2025	169	04154ef1-029a-4d21-a588-abdf7aefb604	\N	91ed6780-31e7-43c7-999d-397109228a90	2025-10-12 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.663+00	2026-01-03 17:21:35.663+00	t	Importada de JSONL. Empresa: CRUSTACEOS DEL SUR S.A. Especie: CENTOLLA	MC	60
6222783f-ee4a-4a6a-becd-64c774e07957	2025	170	801fd0f5-cb21-497a-829a-dc32b5af28f2	\N	7c1e102c-040c-41e2-a5a9-84d3c1c6948e	2025-10-18 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.669+00	2026-01-03 17:21:35.669+00	t	Importada de JSONL. Empresa: BUENA PROA. Especie: MERLUZA	MC	30
17afdb79-821b-4363-9f08-8a0a7b6721e2	2025	171	6bc28d4e-02a0-4377-ba30-4911d6869264	\N	91ed6780-31e7-43c7-999d-397109228a90	2025-10-30 03:00:00+00	\N	\N	6	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.68+00	2026-01-03 17:21:35.68+00	t	Importada de JSONL. Empresa: GLACIAR PESQUERA. Especie: VIEIRA	MC	60
d5432363-f925-48e2-9b5a-6fd67f073416	2025	172	e02b50ee-f135-4657-9b14-6b00c7318fbe	\N	7c1e102c-040c-41e2-a5a9-84d3c1c6948e	2025-10-23 03:00:00+00	\N	\N	30	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.687+00	2026-01-03 17:21:35.687+00	t	Importada de JSONL. Empresa: CRUSTACEOS DEL SUR S.A. Especie: CENTOLLA	MC	30
1658b6c3-62a3-435e-a705-bdfbb8f0b5e0	2025	173	0dd4491b-7b6b-4a7d-af09-3bee8e759097	\N	7c1e102c-040c-41e2-a5a9-84d3c1c6948e	2025-09-29 03:00:00+00	\N	\N	22	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.695+00	2026-01-03 17:21:35.695+00	t	Importada de JSONL. Empresa: ESTREMAR. Especie: MERLUZA AUSTRAL	MC	30
9170f973-5cf8-474a-b0c1-d67c5c212e8c	2025	174	6c4b9846-561e-42c3-b685-ad9a6df761e2	\N	91ed6780-31e7-43c7-999d-397109228a90	2025-10-27 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.702+00	2026-01-03 17:21:35.702+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: VIEIRA	MC	30
6ca427b8-af4a-4805-8ee8-56b5b37f0f4b	2025	175	69579cb8-694d-4def-a89f-688e6690b24b	\N	91ed6780-31e7-43c7-999d-397109228a90	2025-10-31 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.709+00	2026-01-03 17:21:35.709+00	t	Importada de JSONL. Empresa: SOLIMENO e HIJOS S.A. Especie: MERLUZA	MC	30
2a684568-11b1-432a-9787-41ee84d82675	2025	176	add85a6e-a9de-4092-88ca-f46f65036bd9	\N	7c1e102c-040c-41e2-a5a9-84d3c1c6948e	2025-11-01 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.721+00	2026-01-03 17:21:35.721+00	t	Importada de JSONL. Empresa: ROTELLO S.A. Especie: MERLUZA	MC	30
03493cc8-4b8e-46f6-a5de-6ef2a78bf0da	2025	177	44b20244-5d7f-4270-b436-c486062fd7ac	\N	91ed6780-31e7-43c7-999d-397109228a90	2025-11-03 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.727+00	2026-01-03 17:21:35.727+00	t	Importada de JSONL. Empresa: ARPES S.A. Especie: MERLUZA	MC	30
69d83f9a-47b8-4756-bea7-3e69bb020de5	2025	178	1ed56e47-4ae5-439e-9dc4-c3aecf7480aa	\N	91ed6780-31e7-43c7-999d-397109228a90	2025-11-06 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.739+00	2026-01-03 17:21:35.739+00	t	Importada de JSONL. Empresa: CENTOMAR S.A. Especie: CENTOLLA	MC	30
6394e50a-10c5-4917-ba6f-589afccecb3c	2025	179	b29ee12a-14f6-4a6b-bae5-4602075ed561	\N	7c1e102c-040c-41e2-a5a9-84d3c1c6948e	2025-11-04 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.747+00	2026-01-03 17:21:35.747+00	t	Importada de JSONL. Empresa: AIRE MARINO. Especie: ANCHOÍTA	MC	30
ace3208f-5afa-4694-991d-5ed1d7aa6610	2025	180	1e28bd98-19b3-4e8b-9ff6-31d95dbd2712	\N	91ed6780-31e7-43c7-999d-397109228a90	2025-11-10 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.754+00	2026-01-03 17:21:35.754+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: CENTOLLA	MC	30
a2f89dfd-1da1-40bf-8455-c95c6e194389	2025	181	3059e444-2a0b-4ef8-9c39-0e135c0c8755	\N	91ed6780-31e7-43c7-999d-397109228a90	2025-11-10 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.76+00	2026-01-03 17:21:35.76+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: VIEIRA	MC	30
4694beed-eb69-4746-be8f-805e2b0d0664	2025	182	dc5524f0-9cf6-4d6d-890f-a5f1568cd976	\N	7686e133-c020-4217-b227-43529e1a6d06	2025-11-20 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.767+00	2026-01-03 17:21:35.767+00	t	Importada de JSONL. Empresa: PESANTAR. Especie: MERLUZA AUSTRAL	MC	30
2b4edcfb-05d0-4cc2-8f31-a242812ac9b8	2025	183	e02b50ee-f135-4657-9b14-6b00c7318fbe	\N	7686e133-c020-4217-b227-43529e1a6d06	2025-11-20 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.773+00	2026-01-03 17:21:35.773+00	t	Importada de JSONL. Empresa: CRUSTACEOS DEL SUR S.A. Especie: CENTOLLA	MC	30
bc255866-6f19-4c1d-ba0f-1d8337f9f7f6	2025	184	44ab546f-33ad-4d09-a025-5b67d3c995c4	\N	7686e133-c020-4217-b227-43529e1a6d06	2025-11-26 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.779+00	2026-01-03 17:21:35.779+00	t	Importada de JSONL. Empresa: PRODESUR. Especie: MERLUZA AUSTRAL	MC	60
6be0da64-8dc4-41ed-a981-a24b0d821de6	2025	185	81723a1f-7293-4231-ab06-519cdfcfad2e	\N	91ed6780-31e7-43c7-999d-397109228a90	2025-12-01 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.786+00	2026-01-03 17:21:35.786+00	t	Importada de JSONL. Empresa: PESQUERA VERAZ S.A. Especie: MERLUZA	MC	30
8cf38b26-ddc3-4723-911c-89feb780ea54	2025	186	6bc28d4e-02a0-4377-ba30-4911d6869264	\N	7686e133-c020-4217-b227-43529e1a6d06	2025-12-15 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.792+00	2026-01-03 17:21:35.792+00	t	Importada de JSONL. Empresa: GLACIAR PESQUERA. Especie: VIEIRA	MC	30
e04ec6dd-6f56-4950-af6e-6bec6d42ff79	2025	187	6c4b9846-561e-42c3-b685-ad9a6df761e2	\N	7686e133-c020-4217-b227-43529e1a6d06	2025-12-15 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.8+00	2026-01-03 17:21:35.8+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: VIEIRA	MC	30
9ee1d24f-51a1-4f27-8db6-8ce6b6fd6228	2025	188	0dd4491b-7b6b-4a7d-af09-3bee8e759097	\N	9f069ef3-106c-4d1d-8043-6f71ee9edf4c	2025-12-29 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.807+00	2026-01-03 17:21:35.807+00	t	Importada de JSONL. Empresa: ESTREMAR S.A. Especie: MERLUZA AUSTRAL	MC	30
80738274-20f0-4ede-bae2-df728f9e3ebc	2025	189	154ac509-9b6b-455f-881c-a59d0cbf2e7a	\N	9f069ef3-106c-4d1d-8043-6f71ee9edf4c	2025-12-26 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.815+00	2026-01-03 17:21:35.815+00	t	Importada de JSONL. Empresa: CHIARPESCA. Especie: CALAMAR	MC	30
6b6cc0ed-b50f-42c2-8444-1d339170a9c7	2025	190	7fbacd2a-6e20-4549-b3b2-cc9818cd686d	\N	9f069ef3-106c-4d1d-8043-6f71ee9edf4c	2025-12-29 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.822+00	2026-01-03 17:21:35.822+00	t	Importada de JSONL. Empresa: ARGENOVA. Especie: CALAMAR	MC	30
0ebbed04-db06-4513-8459-0bf5c664cd4f	2025	191	8ebc1a6e-0e89-4a93-adfe-898ff7ff6722	\N	9f069ef3-106c-4d1d-8043-6f71ee9edf4c	2025-12-29 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.828+00	2026-01-03 17:21:35.828+00	t	Importada de JSONL. Empresa: ALTAMARE S.AS. Especie: CALAMAR	MC	30
f2ed706d-85e3-4755-8943-c1d67b6affda	2025	192	bf604e08-daf5-4550-9556-6db5662b820e	\N	9f069ef3-106c-4d1d-8043-6f71ee9edf4c	2025-12-26 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.835+00	2026-01-03 17:21:35.835+00	t	Importada de JSONL. Empresa: PESQUERÍA  RÍO QUEQUEN. Especie: CALAMAR	MC	30
931d221a-92df-4547-b9ba-1ef2a41186ec	2025	193	20cddc4a-bded-4b90-a30c-6c3c33163d44	\N	9f069ef3-106c-4d1d-8043-6f71ee9edf4c	2025-12-26 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.842+00	2026-01-03 17:21:35.842+00	t	Importada de JSONL. Empresa: PESQUERÍA  RÍO QUEQUEN. Especie: CALAMAR	MC	30
4eb1860c-0400-44c2-8374-6ffab53e27e6	2025	194	1ed56e47-4ae5-439e-9dc4-c3aecf7480aa	\N	9f069ef3-106c-4d1d-8043-6f71ee9edf4c	2025-12-26 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.848+00	2026-01-03 17:21:35.848+00	t	Importada de JSONL. Empresa: CENTOMAR S.A. Especie: CENTOLLA	MC	30
c4233c18-189c-4e02-842b-1e4c3d8da3df	2025	195	04154ef1-029a-4d21-a588-abdf7aefb604	\N	9f069ef3-106c-4d1d-8043-6f71ee9edf4c	2025-12-30 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.854+00	2026-01-03 17:21:35.854+00	t	Importada de JSONL. Empresa: CRUSTACEOS DEL SUR S.A. Especie: CENTOLLA	MC	30
4e3172e4-dd55-44ee-9bf3-9fc29339a34f	2025	196	38fabe2c-223f-4dd9-aa1d-e42ca6eff7d6	\N	7686e133-c020-4217-b227-43529e1a6d06	2025-12-23 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.861+00	2026-01-03 17:21:35.861+00	t	Importada de JSONL. Empresa: BENTONICOS DE ARGENTINA. Especie: CENTOLLA	MC	30
7a37c7ee-76a9-4afc-8388-29e59052dc9f	2025	197	0bd1e6fd-2907-4df7-95b3-102db086ed62	\N	9f069ef3-106c-4d1d-8043-6f71ee9edf4c	2025-12-30 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.868+00	2026-01-03 17:21:35.868+00	t	Importada de JSONL. Empresa: BENTONICOS DE ARGENTINA. Especie: CENTOLLA	MC	30
6df19c4a-79d1-4af4-ad36-56a0ccd20f4a	2025	198	8d950e58-7292-4096-8513-16166ea032e8	\N	9f069ef3-106c-4d1d-8043-6f71ee9edf4c	2025-12-29 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.874+00	2026-01-03 17:21:35.874+00	t	Importada de JSONL. Empresa: GIORNO. Especie: CALAMAR	MC	30
fbc3dc42-a0af-4383-b41b-45012e156918	2025	199	21f78c2d-2475-4c14-a29a-690be6abc768	\N	9f069ef3-106c-4d1d-8043-6f71ee9edf4c	2025-12-26 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.88+00	2026-01-03 17:21:35.88+00	t	Importada de JSONL. Empresa: GLACIAR PESQUERA. Especie: VIEIRA	MC	30
71cb7c2c-aa87-40aa-9647-5688b9941b84	2025	200	b3137323-101b-461c-b0fd-843f49b4ecd2	\N	9f069ef3-106c-4d1d-8043-6f71ee9edf4c	2025-12-28 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.886+00	2026-01-03 17:21:35.886+00	t	Importada de JSONL. Empresa: LUIS SOLIMENO. Especie: CALAMAR	MC	30
7eb337eb-c578-4ad9-a7d1-b320d5687249	2025	201	28314d73-74c9-4176-93ce-074507566cc3	\N	9f069ef3-106c-4d1d-8043-6f71ee9edf4c	2025-12-28 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-03 17:21:35.892+00	2026-01-03 17:21:35.892+00	t	Importada de JSONL. Empresa: PESQUERA COMERCIAL. Especie: CALAMAR	MC	30
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
0f84bfd9-bdec-46fc-a6dc-24e008440587	1b96ca55-5d25-4d4f-b195-e1e303416e71	1	a05ae304-2d0e-4e29-a6f3-fa7372a41c97	\N	\N	2025-01-03 03:00:00+00	2025-01-03 03:00:00+00	COMERCIAL	Etapa 1 importada
21fb433a-befa-4cf9-a084-14b37b31c4c2	b22d23b3-b507-4d09-9b5f-bc97f8729557	1	a05ae304-2d0e-4e29-a6f3-fa7372a41c97	\N	\N	2025-01-28 03:00:00+00	2025-01-28 03:00:00+00	COMERCIAL	Etapa 1 importada
560221b0-9c9b-45d5-8bef-246a37a05662	9143ae67-1fdd-4056-b8cc-da9ae96521d8	1	b5066e3d-aff4-484a-b1ad-a45a57700aeb	\N	\N	2025-01-03 03:00:00+00	2025-03-04 03:00:00+00	COMERCIAL	Etapa 1 importada
39551550-669f-4d59-a31d-657ef0e4c86d	e8856ef7-43e1-4173-913f-431da83c7ab2	1	2734dc66-d31b-4d97-aeda-645ce3eb6885	\N	\N	2025-01-11 03:00:00+00	2025-03-07 03:00:00+00	COMERCIAL	Etapa 1 importada
30e573cf-62ac-49a4-8390-d104fb35606f	e87e2e44-9503-4f57-9293-250d3fef1b2f	1	2734dc66-d31b-4d97-aeda-645ce3eb6885	\N	\N	2025-01-07 03:00:00+00	2025-01-28 03:00:00+00	COMERCIAL	Etapa 1 importada
bb179327-ceea-4801-8a57-2c410b0ff789	d4242dce-a30d-49ba-bd05-202e5381aa45	1	68a3cc43-2e5f-4423-8302-3e11af1ff872	\N	\N	2025-01-08 03:00:00+00	2025-02-02 03:00:00+00	COMERCIAL	Etapa 1 importada
fe1e7b97-32ba-452c-92f8-b8549f4c3a39	8ed765a1-5a4d-4ecc-ac3c-1110020f1e67	1	68a3cc43-2e5f-4423-8302-3e11af1ff872	\N	\N	2025-01-07 03:00:00+00	2025-01-30 03:00:00+00	COMERCIAL	Etapa 1 importada
5bad594d-df1b-40c1-8b5b-13f6f41d2339	74aa850b-8f32-461d-90a1-40667e073e81	1	2734dc66-d31b-4d97-aeda-645ce3eb6885	\N	\N	2025-01-11 03:00:00+00	2025-01-19 03:00:00+00	COMERCIAL	Etapa 1 importada
8eb25d6c-f240-4119-8631-c5f8a452f64c	74aa850b-8f32-461d-90a1-40667e073e81	2	2734dc66-d31b-4d97-aeda-645ce3eb6885	\N	\N	2025-01-22 03:00:00+00	2025-01-29 03:00:00+00	COMERCIAL	Etapa 2 importada
e5e78676-aa48-44c9-b16f-0970b42309b6	74aa850b-8f32-461d-90a1-40667e073e81	3	2734dc66-d31b-4d97-aeda-645ce3eb6885	\N	\N	2025-01-31 03:00:00+00	2025-02-02 03:00:00+00	COMERCIAL	Etapa 3 importada
6c3179ca-ee5b-42fa-b7f2-6bf3023e3e02	a06d3da0-1d1e-4719-a52b-08c7e4a19c7c	1	9d02d029-f003-41b6-89de-0eea18b2d4e4	\N	\N	2025-01-06 03:00:00+00	2025-02-07 03:00:00+00	COMERCIAL	Etapa 1 importada
0f7586f3-20a9-44fd-83ca-d6abdcce4673	19e60f5b-b31c-49f7-809d-5735ad940ce3	1	9d02d029-f003-41b6-89de-0eea18b2d4e4	\N	\N	2025-01-13 03:00:00+00	2025-02-24 03:00:00+00	COMERCIAL	Etapa 1 importada
84f2c1b2-d477-40ab-9ffe-b7f01f014e86	0f138d55-65fd-4c97-b087-430dbaa82da1	1	68a3cc43-2e5f-4423-8302-3e11af1ff872	\N	\N	2025-01-08 03:00:00+00	2025-02-02 03:00:00+00	COMERCIAL	Etapa 1 importada
b25d2622-802e-4c3b-abde-c35353f4cecd	bfaea882-ab97-4e3d-af71-8fd699abf4b4	1	9d02d029-f003-41b6-89de-0eea18b2d4e4	\N	\N	2025-01-09 03:00:00+00	2025-02-16 03:00:00+00	COMERCIAL	Etapa 1 importada
aac11fe7-0710-4c00-a34a-8a75cd4739aa	85adba53-6a2c-496f-9af7-b254a993e62e	1	b5066e3d-aff4-484a-b1ad-a45a57700aeb	\N	\N	2025-01-08 03:00:00+00	2025-02-17 03:00:00+00	COMERCIAL	Etapa 1 importada
c7ad031a-c4e1-44d2-b512-59ce91e2bd58	0c9d7f1e-c9a1-4dcf-be69-b75695b73028	1	68a3cc43-2e5f-4423-8302-3e11af1ff872	\N	\N	2025-01-09 03:00:00+00	2025-02-13 03:00:00+00	COMERCIAL	Etapa 1 importada
30f78c59-6a02-4b1d-a9db-cad3cd9c3643	c9e228eb-04a5-4323-807c-10552768c1aa	1	2734dc66-d31b-4d97-aeda-645ce3eb6885	\N	\N	2025-01-12 03:00:00+00	2025-01-19 03:00:00+00	COMERCIAL	Etapa 1 importada
cc8a2d34-ffbe-4b08-9216-de392019b9f8	c9e228eb-04a5-4323-807c-10552768c1aa	2	2734dc66-d31b-4d97-aeda-645ce3eb6885	\N	\N	2025-01-20 03:00:00+00	2025-01-26 03:00:00+00	COMERCIAL	Etapa 2 importada
27eaa704-5c9d-4875-8121-f5872ed7cae0	c9e228eb-04a5-4323-807c-10552768c1aa	3	2734dc66-d31b-4d97-aeda-645ce3eb6885	\N	\N	2025-01-28 03:00:00+00	2025-02-06 03:00:00+00	COMERCIAL	Etapa 3 importada
089aff80-5210-4fdb-869a-8bf9bf3184ee	c9e228eb-04a5-4323-807c-10552768c1aa	4	2734dc66-d31b-4d97-aeda-645ce3eb6885	\N	\N	2025-02-07 03:00:00+00	2025-02-12 03:00:00+00	COMERCIAL	Etapa 4 importada
9353fc40-2d8f-4235-8a3f-9127fbb42065	307a8442-afe6-40f6-a83a-9913e40e06f8	1	9d02d029-f003-41b6-89de-0eea18b2d4e4	\N	\N	2025-01-17 03:00:00+00	2025-03-01 03:00:00+00	COMERCIAL	Etapa 1 importada
f6f520ac-b1bf-4056-b4ca-c2d528df4114	df130265-b15f-41b8-af75-f059f3d1c67b	1	68a3cc43-2e5f-4423-8302-3e11af1ff872	\N	\N	2025-01-16 03:00:00+00	2025-01-18 03:00:00+00	COMERCIAL	Etapa 1 importada
e98f8358-d3da-4396-980b-c2aafc11bace	dc7d7414-7b99-4594-8c9f-0c4e2acdf934	1	68a3cc43-2e5f-4423-8302-3e11af1ff872	\N	\N	2025-01-16 03:00:00+00	2025-03-11 03:00:00+00	COMERCIAL	Etapa 1 importada
cc5861e0-26e7-47d9-9239-c4a726f8d244	3d07eaaa-4f2d-4943-8b49-6b68c98acf6e	1	b5066e3d-aff4-484a-b1ad-a45a57700aeb	\N	\N	2025-01-27 03:00:00+00	2025-02-07 03:00:00+00	COMERCIAL	Etapa 1 importada
0db79420-f4b0-4595-b0d3-eafd5ad1cd16	2f88c725-e51c-4fa7-a41c-181de9d2c31b	1	68a3cc43-2e5f-4423-8302-3e11af1ff872	\N	\N	2025-02-03 03:00:00+00	2025-03-11 03:00:00+00	COMERCIAL	Etapa 1 importada
1e817eae-333d-429d-9261-ccb9ea1c3078	fc76dc57-7d86-4bf3-8975-86cb0745896e	1	b5066e3d-aff4-484a-b1ad-a45a57700aeb	\N	\N	2025-02-03 03:00:00+00	2025-03-12 03:00:00+00	COMERCIAL	Etapa 1 importada
f28601a3-b6cf-4bef-83f9-664f56dd8200	637b72e8-7cd2-469a-bc09-6436c4036fc6	1	68a3cc43-2e5f-4423-8302-3e11af1ff872	\N	\N	2025-01-31 03:00:00+00	2025-03-24 03:00:00+00	COMERCIAL	Etapa 1 importada
6c9f9e36-9a78-4bc8-a0a2-fcca8a851964	45e7b82a-95cc-4504-885a-0ba429ebd302	1	68a3cc43-2e5f-4423-8302-3e11af1ff872	\N	\N	2025-01-28 03:00:00+00	2025-02-23 03:00:00+00	COMERCIAL	Etapa 1 importada
fc1e84b5-350a-4871-8274-ad63f7f12f81	45e7b82a-95cc-4504-885a-0ba429ebd302	2	68a3cc43-2e5f-4423-8302-3e11af1ff872	\N	\N	2025-02-25 03:00:00+00	2025-04-06 03:00:00+00	COMERCIAL	Etapa 2 importada
6980c18c-bc34-4dce-83d5-e0e815462edf	d4770b46-93e5-450e-a14a-045e3c55921a	1	a05ae304-2d0e-4e29-a6f3-fa7372a41c97	\N	\N	2025-01-29 03:00:00+00	2025-02-23 03:00:00+00	COMERCIAL	Etapa 1 importada
f68072b9-cd27-4931-ab00-5cfef4db693f	dba672d1-635d-4764-9419-236dbca7597e	1	b5066e3d-aff4-484a-b1ad-a45a57700aeb	\N	\N	2025-01-30 03:00:00+00	2025-02-27 03:00:00+00	COMERCIAL	Etapa 1 importada
6ff90088-465f-4e56-8258-cf138d667b89	81a14f82-6b0c-4a54-abc5-96193b76b47e	1	2734dc66-d31b-4d97-aeda-645ce3eb6885	\N	\N	2025-02-03 03:00:00+00	2025-03-10 03:00:00+00	COMERCIAL	Etapa 1 importada
caa34109-4d26-4eca-a9ec-be0265ca5ac4	2fc9e671-484e-44e7-8813-bb49719b6810	1	68a3cc43-2e5f-4423-8302-3e11af1ff872	\N	\N	2025-01-30 03:00:00+00	2025-03-11 03:00:00+00	COMERCIAL	Etapa 1 importada
34d1f115-5a6f-4332-8678-5ff0914ff313	d3b9174c-5b99-44fa-93c8-9963972a4d85	1	68a3cc43-2e5f-4423-8302-3e11af1ff872	\N	\N	2025-02-05 03:00:00+00	2025-04-09 03:00:00+00	COMERCIAL	Etapa 1 importada
ae6b90b4-69c1-41c5-9f0c-594edaa0d716	59e31b81-9861-4563-9a9a-0f49b531654c	1	2734dc66-d31b-4d97-aeda-645ce3eb6885	\N	\N	2025-02-07 03:00:00+00	2025-02-22 03:00:00+00	COMERCIAL	Etapa 1 importada
bb0a1682-57a4-46cd-9dd2-a76891e8ab8a	87e3d15b-9ea9-4d71-8bf7-d1e61505b3bd	1	a05ae304-2d0e-4e29-a6f3-fa7372a41c97	\N	\N	2025-02-11 03:00:00+00	2025-05-07 03:00:00+00	COMERCIAL	Etapa 1 importada
195b64ef-ea50-440c-873e-dc0df0a7d927	ebd84e62-d379-43a1-85c0-2d8657bf0ee4	1	9d02d029-f003-41b6-89de-0eea18b2d4e4	\N	\N	2025-02-12 03:00:00+00	2025-03-20 03:00:00+00	COMERCIAL	Etapa 1 importada
efa436ca-b879-471c-b1bb-208e12515c5b	fcdec828-7006-4999-9c51-6c86ee7f27e8	1	a05ae304-2d0e-4e29-a6f3-fa7372a41c97	\N	\N	2025-02-19 03:00:00+00	2025-04-13 03:00:00+00	COMERCIAL	Etapa 1 importada
7b277fa0-7c32-448d-b86e-0fd2a361d0dd	d3c77501-42da-427a-bba8-4900e1ded32a	1	2734dc66-d31b-4d97-aeda-645ce3eb6885	\N	\N	2025-02-18 03:00:00+00	2025-02-25 03:00:00+00	COMERCIAL	Etapa 1 importada
2f50ce02-6357-489e-81ec-b2b96c94d10f	5293a45e-c905-4705-a9d1-b35b2b90ab6e	1	9d02d029-f003-41b6-89de-0eea18b2d4e4	\N	\N	2025-02-27 03:00:00+00	2025-04-07 03:00:00+00	COMERCIAL	Etapa 1 importada
47ee8cce-484c-44bd-bb62-ede3b0cf0cc0	87494f91-8145-46d8-bb6d-a138d3212bda	1	a05ae304-2d0e-4e29-a6f3-fa7372a41c97	\N	\N	2025-02-24 03:00:00+00	2025-03-31 03:00:00+00	COMERCIAL	Etapa 1 importada
6b43ce46-b98c-49c4-a0a0-d9d75986f839	2fd183a7-a9c2-4424-abc7-87f31dde60d4	1	9d02d029-f003-41b6-89de-0eea18b2d4e4	\N	\N	2025-02-21 03:00:00+00	2025-04-02 03:00:00+00	COMERCIAL	Etapa 1 importada
f1627463-0850-4b99-bb70-c0fd22c4f74e	c1e2b8ec-4cf9-4588-b1a6-f98fcd8205cb	1	b5066e3d-aff4-484a-b1ad-a45a57700aeb	\N	\N	2025-02-21 03:00:00+00	2025-03-28 03:00:00+00	COMERCIAL	Etapa 1 importada
2ad36685-cac2-45c4-ae9f-7a999144b7f1	e170ff4a-5d24-4e6e-8eff-379c2233e544	1	b5066e3d-aff4-484a-b1ad-a45a57700aeb	\N	\N	2025-03-06 03:00:00+00	2025-03-26 03:00:00+00	COMERCIAL	Etapa 1 importada
9c7a9094-8008-4d30-af54-b6cbf071a3c0	8131a5ea-08f0-43db-92e2-6199a41f8fa1	1	9d02d029-f003-41b6-89de-0eea18b2d4e4	\N	\N	2025-03-06 03:00:00+00	2025-04-13 03:00:00+00	COMERCIAL	Etapa 1 importada
b24898bd-aa00-47fa-b18a-f9cde9f60b8a	a64c5389-8b8b-4799-b34e-7a2c179ae9d1	1	68a3cc43-2e5f-4423-8302-3e11af1ff872	\N	\N	2025-03-07 03:00:00+00	2025-04-07 03:00:00+00	COMERCIAL	Etapa 1 importada
314f1f50-d544-40a0-9a3c-b07186fa2c83	ab8a5193-0b12-4733-9e00-c7030ca1d065	1	\N	\N	\N	2025-03-11 03:00:00+00	2025-03-18 03:00:00+00	COMERCIAL	Etapa 1 importada
3c75211c-c8ff-48f2-a5c6-00500fcc9455	ab8a5193-0b12-4733-9e00-c7030ca1d065	2	\N	\N	\N	2025-03-21 03:00:00+00	2025-03-28 03:00:00+00	COMERCIAL	Etapa 2 importada
cb7e5393-b692-420c-a213-8b8cc88fd08c	1800d269-7400-4661-b9ee-9bb1b1d5a5cf	1	\N	\N	\N	2025-03-11 03:00:00+00	2025-03-16 03:00:00+00	COMERCIAL	Etapa 1 importada
71fa94c0-9d09-4d81-919f-46d403f72e1a	1800d269-7400-4661-b9ee-9bb1b1d5a5cf	2	\N	\N	\N	2025-03-17 03:00:00+00	2025-03-28 03:00:00+00	COMERCIAL	Etapa 2 importada
91a3962f-eeaf-4a4f-8f04-eff9af53c4db	d87a8412-71c4-45f4-9483-177e6772bff3	1	\N	\N	\N	2025-03-12 03:00:00+00	2025-03-17 03:00:00+00	COMERCIAL	Etapa 1 importada
4cd72921-92c2-463c-a0f1-179f265ed4cd	d87a8412-71c4-45f4-9483-177e6772bff3	2	\N	\N	\N	2025-03-18 03:00:00+00	2025-03-29 03:00:00+00	COMERCIAL	Etapa 2 importada
d7654c36-5dc5-43fc-ad68-81440816216c	60163f5c-4b4c-458f-b707-c6e58a21d86c	1	\N	\N	\N	2025-03-11 03:00:00+00	2025-03-20 03:00:00+00	COMERCIAL	Etapa 1 importada
942bbaa9-69a4-4ed6-9d8d-1105904fc89f	60163f5c-4b4c-458f-b707-c6e58a21d86c	2	\N	\N	\N	2025-03-22 03:00:00+00	2025-03-27 03:00:00+00	COMERCIAL	Etapa 2 importada
c2bdd9a9-fa7e-4b8a-b11a-34be4d788075	6c571f5a-ef1c-4f4d-b570-975cc846e825	1	\N	\N	\N	2025-03-07 03:00:00+00	2025-03-12 03:00:00+00	COMERCIAL	Etapa 1 importada
5e77ec19-6180-42cb-bc0d-3ef94f87ccf2	6c571f5a-ef1c-4f4d-b570-975cc846e825	2	\N	\N	\N	2025-03-15 03:00:00+00	2025-03-18 03:00:00+00	COMERCIAL	Etapa 2 importada
0fa83324-d481-4a9e-92c8-c5685f7f512c	c7d13c76-8742-4204-b0a1-ad17e98110ee	1	b5066e3d-aff4-484a-b1ad-a45a57700aeb	\N	\N	2025-03-11 03:00:00+00	2025-04-23 03:00:00+00	COMERCIAL	Etapa 1 importada
38d08292-3778-4f69-8a82-2db460966790	aa253bbe-f038-4f47-bfb9-b8aa6ec8c959	1	b5066e3d-aff4-484a-b1ad-a45a57700aeb	\N	\N	2025-03-12 03:00:00+00	2025-04-30 03:00:00+00	COMERCIAL	Etapa 1 importada
591ae55c-d814-4f3f-945c-c276bd09c823	9563ce8a-6958-48a9-9a5d-0ec2d7eb9bf5	1	2734dc66-d31b-4d97-aeda-645ce3eb6885	\N	\N	2025-03-17 03:00:00+00	2025-04-25 03:00:00+00	COMERCIAL	Etapa 1 importada
6f6d3e9d-ef6a-4648-ad2e-6aecb5400a52	2572f21d-491b-4ed0-9f1f-f72627e617f8	1	68a3cc43-2e5f-4423-8302-3e11af1ff872	\N	\N	2025-03-24 03:00:00+00	2025-04-23 03:00:00+00	COMERCIAL	Etapa 1 importada
36cb2d35-289f-4359-a402-4dac4834db63	4aff51a8-fdb7-4e96-821f-b4e1617a72f2	1	9d02d029-f003-41b6-89de-0eea18b2d4e4	\N	\N	2025-03-28 03:00:00+00	2025-04-30 03:00:00+00	COMERCIAL	Etapa 1 importada
877fb241-0d1c-4d46-b368-79016322202a	619264db-438e-4bdd-9544-8a4595d9cbae	1	a05ae304-2d0e-4e29-a6f3-fa7372a41c97	\N	\N	2025-04-01 03:00:00+00	2025-04-27 03:00:00+00	COMERCIAL	Etapa 1 importada
70765594-f4a7-4f62-a002-9d3cd2829c45	68f9a3a6-61ba-417d-aec6-745e942d6f9c	1	68a3cc43-2e5f-4423-8302-3e11af1ff872	\N	\N	2025-03-28 03:00:00+00	2025-05-05 03:00:00+00	COMERCIAL	Etapa 1 importada
d45ec5f6-efb7-4869-b58c-633a1dd74547	ad035c1d-4b90-43bd-abed-6eed873f2bb9	1	9d02d029-f003-41b6-89de-0eea18b2d4e4	\N	\N	2025-04-11 03:00:00+00	2025-05-17 03:00:00+00	COMERCIAL	Etapa 1 importada
6afc768e-79f3-446a-9402-76a3970f8298	cc5eb69e-6e1e-4297-9b13-7848bb38f572	1	a05ae304-2d0e-4e29-a6f3-fa7372a41c97	\N	\N	2025-04-18 03:00:00+00	2025-05-19 03:00:00+00	COMERCIAL	Etapa 1 importada
d37193be-0cbb-472f-9c33-c469cf6b0725	1780fcd8-c848-4a22-86a2-6b6e2e809a9d	1	a05ae304-2d0e-4e29-a6f3-fa7372a41c97	\N	\N	2025-04-12 03:00:00+00	2025-05-20 03:00:00+00	COMERCIAL	Etapa 1 importada
a7f7be50-73ef-47c2-b2f0-f761fad42ae6	b5d4e4f9-2839-4f34-a2b4-6ee91efde858	1	b5066e3d-aff4-484a-b1ad-a45a57700aeb	\N	\N	2025-05-08 03:00:00+00	2025-06-06 03:00:00+00	COMERCIAL	Etapa 1 importada
34eb965a-fcc3-4eb3-8e20-fe36a096a7d1	12ba51db-a35a-4849-8a2e-98978b0115b4	1	68a3cc43-2e5f-4423-8302-3e11af1ff872	\N	\N	2025-04-21 03:00:00+00	2025-05-15 03:00:00+00	COMERCIAL	Etapa 1 importada
4a14dbd6-9ff2-47d5-bb02-81c484964b07	9d2c0639-31ca-43fa-927e-a5dfb270cea1	1	9d02d029-f003-41b6-89de-0eea18b2d4e4	\N	\N	2025-04-10 03:00:00+00	2025-06-06 03:00:00+00	COMERCIAL	Etapa 1 importada
3a562759-e5e5-43b4-b581-6f67f2b1e3c9	ec689725-c1b6-4a8f-a879-ae61a9c189dd	1	b5066e3d-aff4-484a-b1ad-a45a57700aeb	\N	\N	2025-04-12 03:00:00+00	2025-05-14 03:00:00+00	COMERCIAL	Etapa 1 importada
0cd3ad5c-1806-42ed-9b10-1970e4709785	84faeb38-ffff-4311-b37a-5e6386304f30	1	9d02d029-f003-41b6-89de-0eea18b2d4e4	\N	\N	2025-04-16 03:00:00+00	2025-05-29 03:00:00+00	COMERCIAL	Etapa 1 importada
02733616-9586-46e8-a667-5512f776168d	a930beef-a27d-47cb-a3f3-3aa11a6110df	1	68a3cc43-2e5f-4423-8302-3e11af1ff872	\N	\N	2025-04-15 03:00:00+00	2025-05-27 03:00:00+00	COMERCIAL	Etapa 1 importada
36098fe5-e852-420e-bfdc-ea7d03345276	422c60b2-75be-4b6e-980a-4f76c36016a2	1	372697a7-b884-4ed6-9bb6-1420610ba86f	\N	\N	2025-04-12 03:00:00+00	2025-04-20 03:00:00+00	COMERCIAL	Etapa 1 importada
a3c0ad2c-21fb-4025-8694-2c8fb6f18efa	422c60b2-75be-4b6e-980a-4f76c36016a2	2	372697a7-b884-4ed6-9bb6-1420610ba86f	\N	\N	2025-04-21 03:00:00+00	2025-05-01 03:00:00+00	COMERCIAL	Etapa 2 importada
b67defcb-7fc2-4366-9342-1e8ae011d209	422c60b2-75be-4b6e-980a-4f76c36016a2	3	372697a7-b884-4ed6-9bb6-1420610ba86f	\N	\N	2025-05-02 03:00:00+00	2025-05-10 03:00:00+00	COMERCIAL	Etapa 3 importada
cb548f7f-24fa-43e8-a1db-9af06491d051	3ffaa44e-b3c8-4121-a457-1173121dd3f7	1	2734dc66-d31b-4d97-aeda-645ce3eb6885	\N	\N	2025-04-27 03:00:00+00	2025-05-31 03:00:00+00	COMERCIAL	Etapa 1 importada
6fab3e78-1c6b-4e00-ab43-a0e2d588d823	e7b08c67-748f-4a22-898d-2a890e5a35ab	1	2734dc66-d31b-4d97-aeda-645ce3eb6885	\N	\N	0205-04-21 03:53:48+00	2025-04-29 03:00:00+00	COMERCIAL	Etapa 1 importada
46379366-6424-47d3-8e8a-5961609945c2	e7b08c67-748f-4a22-898d-2a890e5a35ab	2	2734dc66-d31b-4d97-aeda-645ce3eb6885	\N	\N	2025-05-02 03:00:00+00	2025-05-10 03:00:00+00	COMERCIAL	Etapa 2 importada
25a0b133-bdfe-4c9b-81aa-1998feb341dc	e7b08c67-748f-4a22-898d-2a890e5a35ab	3	2734dc66-d31b-4d97-aeda-645ce3eb6885	\N	\N	2025-05-12 03:00:00+00	2025-05-26 03:00:00+00	COMERCIAL	Etapa 3 importada
4608e8df-a59a-4fae-bd9d-71935fb98116	856b8a70-51e9-4718-b68f-b687e83d0425	1	2734dc66-d31b-4d97-aeda-645ce3eb6885	\N	\N	2025-05-02 03:00:00+00	2025-05-09 03:00:00+00	COMERCIAL	Etapa 1 importada
c719b21c-dab8-4feb-aba6-ea628a44efff	856b8a70-51e9-4718-b68f-b687e83d0425	2	2734dc66-d31b-4d97-aeda-645ce3eb6885	\N	\N	2025-05-14 03:00:00+00	2025-05-25 03:00:00+00	COMERCIAL	Etapa 2 importada
dc45853e-aaf7-46f0-9dfa-bbe5f10764ed	3684f797-79a9-4cb2-b326-696b7c0ef365	1	2734dc66-d31b-4d97-aeda-645ce3eb6885	\N	\N	2025-04-30 03:00:00+00	2025-06-16 03:00:00+00	COMERCIAL	Etapa 1 importada
1b716849-7a8b-4fe2-9c37-525ded87e691	3002074e-8d09-4956-ba16-1b65f7eb2ce7	1	2734dc66-d31b-4d97-aeda-645ce3eb6885	\N	\N	2025-04-26 03:00:00+00	2025-05-04 03:00:00+00	COMERCIAL	Etapa 1 importada
fa63bce6-fd52-42c2-95dd-a798f755da94	3002074e-8d09-4956-ba16-1b65f7eb2ce7	2	2734dc66-d31b-4d97-aeda-645ce3eb6885	\N	\N	2025-05-06 03:00:00+00	2025-05-15 03:00:00+00	COMERCIAL	Etapa 2 importada
24c7980b-14e0-4997-8e07-83717a7e9847	3002074e-8d09-4956-ba16-1b65f7eb2ce7	3	2734dc66-d31b-4d97-aeda-645ce3eb6885	\N	\N	2025-05-17 03:00:00+00	2025-05-27 03:00:00+00	COMERCIAL	Etapa 3 importada
c4640235-80cb-415f-8e61-75ee919bfe54	09118173-ca86-43a2-81c5-62ff82a8db78	1	68a3cc43-2e5f-4423-8302-3e11af1ff872	\N	\N	2025-04-26 03:00:00+00	2025-05-28 03:00:00+00	COMERCIAL	Etapa 1 importada
91e52316-fceb-4be9-93fd-648a3454e8cd	3e309bb1-041d-4a61-bd36-bba980ca60f7	1	2734dc66-d31b-4d97-aeda-645ce3eb6885	\N	\N	2025-05-02 03:00:00+00	2025-05-10 03:00:00+00	COMERCIAL	Etapa 1 importada
10e46e81-bf20-42fd-ae4a-815c5b34754f	3e309bb1-041d-4a61-bd36-bba980ca60f7	2	2734dc66-d31b-4d97-aeda-645ce3eb6885	\N	\N	2025-05-12 03:00:00+00	2025-05-21 03:00:00+00	COMERCIAL	Etapa 2 importada
9c4fc815-d4d6-438c-ab64-d3d65a1b79bb	7ea29288-647f-42b3-a218-3dde8200bfa7	1	68a3cc43-2e5f-4423-8302-3e11af1ff872	\N	\N	2025-04-30 03:00:00+00	2025-06-05 03:00:00+00	COMERCIAL	Etapa 1 importada
0d03112a-2574-4546-9ad7-aeaa1c29e73d	35544167-6977-40f7-ba1a-07b135e64236	1	a05ae304-2d0e-4e29-a6f3-fa7372a41c97	\N	\N	2025-04-28 03:00:00+00	2025-06-04 03:00:00+00	COMERCIAL	Etapa 1 importada
3353fe2c-de03-4824-8df4-67a7ef04cee6	fab442d9-b253-4f60-8e1a-459dcd40e213	1	2734dc66-d31b-4d97-aeda-645ce3eb6885	\N	\N	2025-04-30 03:00:00+00	2025-05-06 03:00:00+00	COMERCIAL	Etapa 1 importada
75e395c9-be7e-4a26-9b9e-f87c5544fffa	fab442d9-b253-4f60-8e1a-459dcd40e213	2	2734dc66-d31b-4d97-aeda-645ce3eb6885	\N	\N	2025-05-08 03:00:00+00	2025-05-17 03:00:00+00	COMERCIAL	Etapa 2 importada
dce39215-beec-4e5d-925a-a3e270062a52	fab442d9-b253-4f60-8e1a-459dcd40e213	3	2734dc66-d31b-4d97-aeda-645ce3eb6885	\N	\N	2025-05-22 03:00:00+00	2025-05-29 03:00:00+00	COMERCIAL	Etapa 3 importada
f408dbf5-2a11-4e57-96fb-2232550e92d2	de28daf8-b209-4635-8035-5864d2d63219	1	2734dc66-d31b-4d97-aeda-645ce3eb6885	\N	\N	2025-04-29 03:00:00+00	2025-05-15 03:00:00+00	COMERCIAL	Etapa 1 importada
74c6d95a-4ca9-4114-82f2-d5cf1c355385	200a2332-e2bd-4da7-890e-9a55e128449e	1	a05ae304-2d0e-4e29-a6f3-fa7372a41c97	\N	\N	2025-05-06 03:00:00+00	2025-06-18 03:00:00+00	COMERCIAL	Etapa 1 importada
4a7ed296-9254-4793-a1ab-5077c05009d1	aaa6a72d-ffa9-4176-851c-a595c5010ae8	1	9d02d029-f003-41b6-89de-0eea18b2d4e4	\N	\N	2025-05-07 03:00:00+00	2025-06-10 03:00:00+00	COMERCIAL	Etapa 1 importada
b6a19003-4ccf-4f13-a3f0-4b0391f3a9f9	f41dc2ec-d08f-4571-9878-8f3c8eb53dbe	1	2734dc66-d31b-4d97-aeda-645ce3eb6885	\N	\N	2025-05-02 03:00:00+00	2025-06-05 03:00:00+00	COMERCIAL	Etapa 1 importada
7c129f67-874a-4cba-876c-1b67198b5782	b2dd8dce-929b-4342-ae86-bc34b4af1ad8	1	68a3cc43-2e5f-4423-8302-3e11af1ff872	\N	\N	2025-05-07 03:00:00+00	2025-06-09 03:00:00+00	COMERCIAL	Etapa 1 importada
54991a85-e24f-42bd-9f13-11fd1adc646c	63fccc66-9abf-403c-9599-b82a48710d67	1	68a3cc43-2e5f-4423-8302-3e11af1ff872	\N	\N	2025-05-07 03:00:00+00	2025-06-10 03:00:00+00	COMERCIAL	Etapa 1 importada
936f70fc-850c-45bd-a3f4-8ba43b72d969	6d865537-c61a-410c-915b-2ac8e24ba9ad	1	372697a7-b884-4ed6-9bb6-1420610ba86f	\N	\N	2025-05-09 03:00:00+00	2025-05-19 03:00:00+00	COMERCIAL	Etapa 1 importada
defd5ae8-1da4-4cc8-a6fd-ef894f35599e	9b984f08-2fd5-4554-81f0-6ac693c7220e	1	b5066e3d-aff4-484a-b1ad-a45a57700aeb	\N	\N	2025-05-15 03:00:00+00	2025-05-27 03:00:00+00	COMERCIAL	Etapa 1 importada
760b050c-f09f-4324-9566-fd47fd901b22	667ef67d-79c0-4a0c-b825-53f32a0cfba7	1	a05ae304-2d0e-4e29-a6f3-fa7372a41c97	\N	\N	2025-05-21 03:00:00+00	2025-07-13 03:00:00+00	COMERCIAL	Etapa 1 importada
69399898-b840-4cc1-bd56-3a4fd9adb989	ee516229-0f07-492d-92ce-ad48ec42dbe2	1	2734dc66-d31b-4d97-aeda-645ce3eb6885	\N	\N	2025-05-17 03:00:00+00	2025-07-13 03:00:00+00	COMERCIAL	Etapa 1 importada
f0f75735-2ab6-486b-b26a-f1afafd9abd4	87cc6c0e-7bf7-472b-98b3-cfc46043114e	1	2734dc66-d31b-4d97-aeda-645ce3eb6885	\N	\N	2025-05-22 03:00:00+00	2025-06-17 03:00:00+00	COMERCIAL	Etapa 1 importada
cde8e4fe-ae79-4cc9-a9d5-8d41fcd6590a	b45e3b51-67dd-4fa9-9a2a-c3260f55bf30	1	68a3cc43-2e5f-4423-8302-3e11af1ff872	\N	\N	2025-05-22 03:00:00+00	2025-06-05 03:00:00+00	COMERCIAL	Etapa 1 importada
aa58c987-35a0-4245-a52b-51898ad4bba2	f923d047-ecd0-4deb-a466-e693d90084e5	1	a05ae304-2d0e-4e29-a6f3-fa7372a41c97	\N	\N	2025-05-20 03:00:00+00	2025-06-21 03:00:00+00	COMERCIAL	Etapa 1 importada
759a6080-c8d2-4115-9def-de5d7ed898a2	403aeda4-fd23-458e-83d1-cc092754265e	1	9d02d029-f003-41b6-89de-0eea18b2d4e4	\N	\N	2025-05-27 03:00:00+00	2025-07-12 03:00:00+00	COMERCIAL	Etapa 1 importada
9f405122-9ab0-47db-99c3-7691f73b0b85	8dc26729-00b4-4da1-ba63-ab0dd4baf5bf	1	9d02d029-f003-41b6-89de-0eea18b2d4e4	\N	\N	2025-05-31 03:00:00+00	2025-07-11 03:00:00+00	COMERCIAL	Etapa 1 importada
0d386c0d-1d58-47d2-b0a3-39c47d2d8ebc	685172ce-7671-441d-959e-79f01bf727ca	1	372697a7-b884-4ed6-9bb6-1420610ba86f	\N	\N	2025-05-26 03:00:00+00	2025-06-03 03:00:00+00	COMERCIAL	Etapa 1 importada
1163db14-7d00-4b5b-9c37-50b0b2f39a0a	685172ce-7671-441d-959e-79f01bf727ca	2	372697a7-b884-4ed6-9bb6-1420610ba86f	\N	\N	2025-06-04 03:00:00+00	2025-06-10 03:00:00+00	COMERCIAL	Etapa 2 importada
1325c85d-b790-4d1f-a1e2-0d5dbf105e6b	10e8da42-a01e-4169-bbf6-ec4548bcc2f7	1	68a3cc43-2e5f-4423-8302-3e11af1ff872	\N	\N	2025-05-31 03:00:00+00	2025-06-07 03:00:00+00	COMERCIAL	Etapa 1 importada
1d99aa93-7f8f-4723-a008-e93d22b539ed	1b74e2a7-70bd-4549-ba41-87bc5f724575	1	2734dc66-d31b-4d97-aeda-645ce3eb6885	\N	\N	2025-06-12 03:00:00+00	2025-06-20 03:00:00+00	COMERCIAL	Etapa 1 importada
39fdd8bc-b688-4f3f-b84b-2a22fbce7d36	1b74e2a7-70bd-4549-ba41-87bc5f724575	2	2734dc66-d31b-4d97-aeda-645ce3eb6885	\N	\N	2025-06-24 03:00:00+00	2025-07-05 03:00:00+00	COMERCIAL	Etapa 2 importada
d2c94f1d-fc73-4870-9bc8-421fefd0c29a	1b74e2a7-70bd-4549-ba41-87bc5f724575	3	2734dc66-d31b-4d97-aeda-645ce3eb6885	\N	\N	2025-07-08 03:00:00+00	2025-07-16 03:00:00+00	COMERCIAL	Etapa 3 importada
6bac9646-09a1-4477-b46a-abb85877aa26	1b74e2a7-70bd-4549-ba41-87bc5f724575	4	2734dc66-d31b-4d97-aeda-645ce3eb6885	\N	\N	2025-07-19 03:00:00+00	2025-07-25 03:00:00+00	COMERCIAL	Etapa 4 importada
12e3721f-537c-4bd8-80e7-548e2ead5d70	15cb7ab1-9781-4847-9a53-d334f89db880	1	2734dc66-d31b-4d97-aeda-645ce3eb6885	\N	\N	2025-06-05 03:00:00+00	2025-07-06 03:00:00+00	COMERCIAL	Etapa 1 importada
a2153d81-846b-4fc8-89e5-b8d6f50e4fef	dc46d9af-3591-4a9a-8b3c-45e0f7ea68a8	1	2734dc66-d31b-4d97-aeda-645ce3eb6885	\N	\N	2025-06-05 03:00:00+00	2025-07-06 03:00:00+00	COMERCIAL	Etapa 1 importada
3ad6ff2c-9047-4755-93a8-803b35346beb	cc3f6247-b010-4188-a325-1bc32f5761d5	1	a05ae304-2d0e-4e29-a6f3-fa7372a41c97	\N	\N	2025-06-18 03:00:00+00	2025-07-03 03:00:00+00	COMERCIAL	Etapa 1 importada
570bf90a-db92-42ed-b324-692cb3a97968	e59df295-88ed-4f1d-8562-7d08031e59a3	1	2734dc66-d31b-4d97-aeda-645ce3eb6885	\N	\N	2025-06-10 03:00:00+00	2025-06-17 03:00:00+00	COMERCIAL	Etapa 1 importada
6b11bd96-0e1a-44c8-b1fe-52bb90ea0e1b	e59df295-88ed-4f1d-8562-7d08031e59a3	2	2734dc66-d31b-4d97-aeda-645ce3eb6885	\N	\N	2025-06-19 03:00:00+00	2025-06-22 03:00:00+00	COMERCIAL	Etapa 2 importada
cc4a87fd-9d4b-482e-9da1-9070dbf45c78	e59df295-88ed-4f1d-8562-7d08031e59a3	3	2734dc66-d31b-4d97-aeda-645ce3eb6885	\N	\N	2025-06-28 03:00:00+00	2025-07-04 03:00:00+00	COMERCIAL	Etapa 3 importada
eb2e3f86-385e-4a23-9062-ba0001691726	e59df295-88ed-4f1d-8562-7d08031e59a3	4	2734dc66-d31b-4d97-aeda-645ce3eb6885	\N	\N	2025-07-06 03:00:00+00	2025-07-10 03:00:00+00	COMERCIAL	Etapa 4 importada
061e4666-078b-4fc8-8432-391350c191c7	e59df295-88ed-4f1d-8562-7d08031e59a3	5	2734dc66-d31b-4d97-aeda-645ce3eb6885	\N	\N	2025-07-12 03:00:00+00	2025-07-16 03:00:00+00	COMERCIAL	Etapa 5 importada
49686042-4fa6-4045-a396-bbe175451ad1	839e302c-a597-4df4-a058-d14d8dbcc63e	1	372697a7-b884-4ed6-9bb6-1420610ba86f	\N	\N	2025-06-18 03:00:00+00	2025-06-25 03:00:00+00	COMERCIAL	Etapa 1 importada
645ab54b-79d3-4e2a-8f4f-0163225bbc99	839e302c-a597-4df4-a058-d14d8dbcc63e	2	372697a7-b884-4ed6-9bb6-1420610ba86f	\N	\N	2025-06-27 03:00:00+00	2025-07-11 03:00:00+00	COMERCIAL	Etapa 2 importada
b3346eac-150f-49f0-9c21-12014caa3c06	adf22815-c33d-41c2-99a1-df4f4fcdf964	1	372697a7-b884-4ed6-9bb6-1420610ba86f	\N	\N	2025-06-17 03:00:00+00	2025-07-10 03:00:00+00	COMERCIAL	Etapa 1 importada
205d23bb-8424-4869-ae60-ece3e07aa39c	54dbd5e2-12b2-49ff-a252-d608e6de12be	1	372697a7-b884-4ed6-9bb6-1420610ba86f	\N	\N	2025-06-18 03:00:00+00	2025-06-25 03:00:00+00	COMERCIAL	Etapa 1 importada
75a3c8d0-0197-485b-a518-53735f19016d	222beb76-8251-43c2-96b1-040eb3d62d2c	1	372697a7-b884-4ed6-9bb6-1420610ba86f	\N	\N	2025-06-18 03:00:00+00	2025-06-25 03:00:00+00	COMERCIAL	Etapa 1 importada
0070012b-1eae-478e-9bc3-3357834701db	ae1e0de9-959d-40d0-a4e7-fe297d4278cf	1	372697a7-b884-4ed6-9bb6-1420610ba86f	\N	\N	2025-06-18 03:00:00+00	2025-06-25 03:00:00+00	COMERCIAL	Etapa 1 importada
6fdea6dd-e9fa-46a5-9200-a76ba2752a62	24318725-7a21-4a9f-ac39-7ad93ef21a9e	1	372697a7-b884-4ed6-9bb6-1420610ba86f	\N	\N	2025-06-18 03:00:00+00	2025-06-25 03:00:00+00	COMERCIAL	Etapa 1 importada
b1261ea0-939a-4e7e-94e4-86edb987efae	24318725-7a21-4a9f-ac39-7ad93ef21a9e	2	372697a7-b884-4ed6-9bb6-1420610ba86f	\N	\N	2025-06-27 03:00:00+00	2025-07-04 03:00:00+00	COMERCIAL	Etapa 2 importada
d6eda3b3-6995-4ff0-affe-bb891e996f51	5aa25b11-e231-4a6e-a3a1-116334ab0772	1	2734dc66-d31b-4d97-aeda-645ce3eb6885	\N	\N	2025-06-25 03:00:00+00	2025-07-03 03:00:00+00	COMERCIAL	Etapa 1 importada
5f677bad-51f1-493c-a85e-b311e119c22a	5aa25b11-e231-4a6e-a3a1-116334ab0772	2	2734dc66-d31b-4d97-aeda-645ce3eb6885	\N	\N	2025-07-05 03:00:00+00	2025-07-11 03:00:00+00	COMERCIAL	Etapa 2 importada
a901ed6a-ffe1-49c0-9412-6139791af564	5aa25b11-e231-4a6e-a3a1-116334ab0772	3	2734dc66-d31b-4d97-aeda-645ce3eb6885	\N	\N	2025-07-20 03:00:00+00	2025-07-26 03:00:00+00	COMERCIAL	Etapa 3 importada
68564bfa-1b85-4ac6-8832-c540ad72c615	5aa25b11-e231-4a6e-a3a1-116334ab0772	4	2734dc66-d31b-4d97-aeda-645ce3eb6885	\N	\N	2025-07-28 03:00:00+00	2025-08-04 03:00:00+00	COMERCIAL	Etapa 4 importada
cb0941c4-7d37-4bec-be5d-7c1c5e93ec9d	cc3cce6e-9657-4dd4-b786-ed0c33ee23f0	1	372697a7-b884-4ed6-9bb6-1420610ba86f	\N	\N	2025-06-27 03:00:00+00	2025-07-21 03:00:00+00	COMERCIAL	Etapa 1 importada
3182d1ca-5ce1-4850-ac24-dd315919177d	bc42f4c4-c5ef-4959-a179-73c5ef65f857	1	372697a7-b884-4ed6-9bb6-1420610ba86f	\N	\N	2025-06-27 03:00:00+00	2025-07-03 03:00:00+00	COMERCIAL	Etapa 1 importada
7cb73a06-cac9-43c9-87b6-310958f868ce	bc42f4c4-c5ef-4959-a179-73c5ef65f857	2	372697a7-b884-4ed6-9bb6-1420610ba86f	\N	\N	2025-07-04 03:00:00+00	2025-07-11 03:00:00+00	COMERCIAL	Etapa 2 importada
0e442218-381c-40ec-9b8b-a8d67cbdbdc7	a45428ce-a312-4138-991d-0143bd917616	1	372697a7-b884-4ed6-9bb6-1420610ba86f	\N	\N	2025-06-27 03:00:00+00	2025-07-17 03:00:00+00	COMERCIAL	Etapa 1 importada
b0883fc2-9cac-4730-b22d-ef2f9489f43f	c55d9b8f-3391-4f0d-8d29-988bb5e78eef	1	2734dc66-d31b-4d97-aeda-645ce3eb6885	\N	\N	2025-07-12 03:00:00+00	2025-07-14 03:00:00+00	COMERCIAL	Etapa 1 importada
2e55e90d-de96-4399-ba47-ef3c81800fd6	c55d9b8f-3391-4f0d-8d29-988bb5e78eef	2	2734dc66-d31b-4d97-aeda-645ce3eb6885	\N	\N	2025-07-18 03:00:00+00	2025-07-23 03:00:00+00	COMERCIAL	Etapa 2 importada
180babed-15a2-47f1-a2f6-164de1934d72	c55d9b8f-3391-4f0d-8d29-988bb5e78eef	3	2734dc66-d31b-4d97-aeda-645ce3eb6885	\N	\N	2025-07-27 03:00:00+00	2025-08-01 03:00:00+00	COMERCIAL	Etapa 3 importada
210b2354-f27b-4c52-b592-b66620ade1f4	271db235-d1d1-46f6-b276-09a8c5bb58a1	1	\N	\N	\N	2025-07-10 03:00:00+00	2025-08-29 03:00:00+00	COMERCIAL	Etapa 1 importada
ccb25bd1-8641-4c57-b7e6-a503f04c3f73	9bb5bcd9-ea49-445d-b1b3-bfb793d8e819	1	\N	\N	\N	2025-07-14 03:00:00+00	2025-08-28 03:00:00+00	COMERCIAL	Etapa 1 importada
5de08c0d-8e3c-4224-802e-c3d18821f757	df531ff6-671c-4e34-bace-c43036c4dd83	1	372697a7-b884-4ed6-9bb6-1420610ba86f	\N	\N	2025-07-11 03:00:00+00	2025-08-20 03:00:00+00	COMERCIAL	Etapa 1 importada
d3a7e106-43b7-47d9-8ff4-c230061fec28	575b01a8-9475-4f8a-8ddc-f6977e3e6a60	1	372697a7-b884-4ed6-9bb6-1420610ba86f	\N	\N	2025-07-13 03:00:00+00	2025-08-05 03:00:00+00	COMERCIAL	Etapa 1 importada
80f5ef93-0752-482f-b86c-9dd8b580da1f	9f2d46f2-19ff-49de-a8da-40d8fdda0063	1	2734dc66-d31b-4d97-aeda-645ce3eb6885	\N	\N	2025-07-12 03:00:00+00	2025-08-23 03:00:00+00	COMERCIAL	Etapa 1 importada
d4d492f3-2144-43d5-8e39-377256b7d2ee	e45f4d38-3c4d-4e1f-a27a-81d86d06be29	1	372697a7-b884-4ed6-9bb6-1420610ba86f	\N	\N	2025-07-18 03:00:00+00	2025-07-25 03:00:00+00	COMERCIAL	Etapa 1 importada
56d447ee-7527-4eb9-b390-f4bc4ddb5174	e45f4d38-3c4d-4e1f-a27a-81d86d06be29	2	372697a7-b884-4ed6-9bb6-1420610ba86f	\N	\N	2025-07-26 03:00:00+00	2025-08-03 03:00:00+00	COMERCIAL	Etapa 2 importada
5d750f7e-2cf2-48e4-b49f-b9bf17b37b23	e45f4d38-3c4d-4e1f-a27a-81d86d06be29	3	372697a7-b884-4ed6-9bb6-1420610ba86f	\N	\N	2025-08-04 03:00:00+00	2025-08-10 03:00:00+00	COMERCIAL	Etapa 3 importada
1ddec261-ab42-4f57-bf19-ae2cf4e29c5a	e45f4d38-3c4d-4e1f-a27a-81d86d06be29	4	372697a7-b884-4ed6-9bb6-1420610ba86f	\N	\N	2025-08-11 03:00:00+00	2025-08-17 03:00:00+00	COMERCIAL	Etapa 4 importada
78f92f8d-deb3-47b0-9c56-c058b9834d79	ae273e3f-ec3d-4efd-98e9-0288a3c73e54	1	9d02d029-f003-41b6-89de-0eea18b2d4e4	\N	\N	2025-07-17 03:00:00+00	2025-09-04 03:00:00+00	COMERCIAL	Etapa 1 importada
6472a075-e374-4aeb-a166-c675531705e9	1b8bfd91-7564-40a3-a292-1294175086c9	1	2734dc66-d31b-4d97-aeda-645ce3eb6885	\N	\N	2025-07-19 03:00:00+00	2025-08-19 03:00:00+00	COMERCIAL	Etapa 1 importada
e4f14f03-c5da-4c59-a5c4-d663882727ea	92efeca5-7164-454c-b684-aeb9b1efb613	1	2734dc66-d31b-4d97-aeda-645ce3eb6885	\N	\N	2025-07-19 03:00:00+00	2025-08-23 03:00:00+00	COMERCIAL	Etapa 1 importada
23ba3552-30f1-4867-85a5-1d363c4ef39d	5ecf438b-b6dd-4f77-94db-9af206c161f9	1	372697a7-b884-4ed6-9bb6-1420610ba86f	\N	\N	2025-07-21 03:00:00+00	\N	COMERCIAL	Etapa generada automáticamente (sin desglose)
ae54d62b-7cf6-4d5d-8785-101eda7e1369	38ff5eff-3550-4cf8-b8dd-202a09ed77ed	1	372697a7-b884-4ed6-9bb6-1420610ba86f	\N	\N	2025-07-23 03:00:00+00	2025-10-07 03:00:00+00	COMERCIAL	Etapa 1 importada
55d3b21a-e645-489b-b079-30a93163fead	1d268299-d910-480d-ae58-7fa550b4d388	1	372697a7-b884-4ed6-9bb6-1420610ba86f	\N	\N	2025-07-23 03:00:00+00	2025-09-27 03:00:00+00	COMERCIAL	Etapa 1 importada
0483fa0b-7af4-4701-bfc7-83bd89318764	6a7326b6-9ba0-4978-94be-7a711d673ab8	1	372697a7-b884-4ed6-9bb6-1420610ba86f	\N	\N	2025-07-24 03:00:00+00	2025-08-30 03:00:00+00	COMERCIAL	Etapa 1 importada
94b2d7d3-100c-4bab-9931-187c8a3d4af8	bb30f796-0e80-42e3-9b01-5af52531be46	1	2734dc66-d31b-4d97-aeda-645ce3eb6885	\N	\N	2025-07-29 03:00:00+00	2025-08-03 03:00:00+00	COMERCIAL	Etapa 1 importada
d61b41bd-62c6-45aa-b2ca-d63929368c57	bb30f796-0e80-42e3-9b01-5af52531be46	2	2734dc66-d31b-4d97-aeda-645ce3eb6885	\N	\N	2025-08-06 03:00:00+00	2025-08-14 03:00:00+00	COMERCIAL	Etapa 2 importada
f185e9c8-6280-416d-bf5d-e06f3d169ec3	bb30f796-0e80-42e3-9b01-5af52531be46	3	2734dc66-d31b-4d97-aeda-645ce3eb6885	\N	\N	2025-08-16 03:00:00+00	2025-08-23 03:00:00+00	COMERCIAL	Etapa 3 importada
40fb80d6-a022-4415-a954-8d75b31f6557	e02a256a-0717-4e29-85c5-98f63ef4c36e	1	b5066e3d-aff4-484a-b1ad-a45a57700aeb	\N	\N	2025-07-29 03:00:00+00	2025-09-13 03:00:00+00	COMERCIAL	Etapa 1 importada
5c9395ab-097e-46ca-8e02-daaed1d76c4f	0bbf48d0-b7a3-4844-8d21-4d1022f0407e	1	372697a7-b884-4ed6-9bb6-1420610ba86f	\N	\N	2025-07-30 03:00:00+00	2025-08-04 03:00:00+00	COMERCIAL	Etapa 1 importada
4426c449-2f2f-4740-a9da-6ef0738fd828	c0925a32-18a7-4c54-bab7-40c9500222a8	1	372697a7-b884-4ed6-9bb6-1420610ba86f	\N	\N	2025-08-04 03:00:00+00	2025-08-14 03:00:00+00	COMERCIAL	Etapa 1 importada
2ab8035b-bf93-4b18-aa96-e784db2ca1c8	c0925a32-18a7-4c54-bab7-40c9500222a8	2	372697a7-b884-4ed6-9bb6-1420610ba86f	\N	\N	2025-08-15 03:00:00+00	2025-09-07 03:00:00+00	COMERCIAL	Etapa 2 importada
d17a051c-e36a-41f4-a473-1e10d5775e08	929932c1-baea-4ff5-bf11-6f3b378140ea	1	372697a7-b884-4ed6-9bb6-1420610ba86f	\N	\N	2025-08-01 03:00:00+00	2025-08-23 03:00:00+00	COMERCIAL	Etapa 1 importada
48d15c8b-b828-4c67-8207-b9b75d0e55dd	3ceabac2-76bd-49d8-a5d4-a673f68f3b54	1	372697a7-b884-4ed6-9bb6-1420610ba86f	\N	\N	2025-08-03 03:00:00+00	2025-08-23 03:00:00+00	COMERCIAL	Etapa 1 importada
aba6a1e1-ac76-4bd6-aab8-c6cc314cc305	72b618ec-e398-49ab-9eda-c1f9d779c15f	1	372697a7-b884-4ed6-9bb6-1420610ba86f	\N	\N	2025-08-05 03:00:00+00	2025-08-13 03:00:00+00	COMERCIAL	Etapa 1 importada
6056aee0-dafb-4cbd-9dae-aa7ae4bc72fb	ed42bb8a-ba14-47a7-a3a6-7970a1aa511c	1	2734dc66-d31b-4d97-aeda-645ce3eb6885	\N	\N	2025-08-07 03:00:00+00	2025-08-14 03:00:00+00	COMERCIAL	Etapa 1 importada
f44cbcc2-1c43-4f6c-9c38-57c7798486a3	ed42bb8a-ba14-47a7-a3a6-7970a1aa511c	2	2734dc66-d31b-4d97-aeda-645ce3eb6885	\N	\N	2025-08-20 03:00:00+00	2025-08-27 03:00:00+00	COMERCIAL	Etapa 2 importada
959dec93-e66a-4e53-8cb6-7cd28ae95cc1	ed42bb8a-ba14-47a7-a3a6-7970a1aa511c	3	2734dc66-d31b-4d97-aeda-645ce3eb6885	\N	\N	2025-08-29 03:00:00+00	2025-09-05 03:00:00+00	COMERCIAL	Etapa 3 importada
c7fd4243-db15-4b14-87a0-94ae8b658cc7	ed42bb8a-ba14-47a7-a3a6-7970a1aa511c	4	2734dc66-d31b-4d97-aeda-645ce3eb6885	\N	\N	2025-09-08 03:00:00+00	2025-09-16 03:00:00+00	COMERCIAL	Etapa 4 importada
145c1418-485f-4d15-b5dc-fdeea50bc2c6	72b5eaac-da40-4351-ab39-e47678e15d1d	1	372697a7-b884-4ed6-9bb6-1420610ba86f	\N	\N	2025-08-08 03:00:00+00	2025-09-24 03:00:00+00	COMERCIAL	Etapa 1 importada
93511c14-b921-4235-b978-bd034e1d52a5	9209f5df-7f3b-4d73-a28c-3171c4beac1f	1	372697a7-b884-4ed6-9bb6-1420610ba86f	\N	\N	2025-08-07 03:00:00+00	2025-09-23 03:00:00+00	COMERCIAL	Etapa 1 importada
978f461d-b3b9-49ac-9676-6d781c9300a3	a91c333a-3cf5-460c-9b90-5942862c6d45	1	2734dc66-d31b-4d97-aeda-645ce3eb6885	\N	\N	2025-08-14 03:00:00+00	2025-08-22 03:00:00+00	COMERCIAL	Etapa 1 importada
d8b62d2e-747c-4221-a3b9-c196a3a9e0e0	a91c333a-3cf5-460c-9b90-5942862c6d45	2	2734dc66-d31b-4d97-aeda-645ce3eb6885	\N	\N	2025-08-26 03:00:00+00	2025-09-05 03:00:00+00	COMERCIAL	Etapa 2 importada
c4e72518-54b3-4eda-bc8c-bb7b00cbe52d	a91c333a-3cf5-460c-9b90-5942862c6d45	3	2734dc66-d31b-4d97-aeda-645ce3eb6885	\N	\N	2025-09-09 03:00:00+00	2025-09-09 03:00:00+00	COMERCIAL	Etapa 3 importada
c3ede18b-6b02-4c43-816d-599c37591b5b	a91c333a-3cf5-460c-9b90-5942862c6d45	4	2734dc66-d31b-4d97-aeda-645ce3eb6885	\N	\N	2025-09-13 03:00:00+00	2025-09-23 03:00:00+00	COMERCIAL	Etapa 4 importada
e1cd8cb5-6032-4c29-b17c-cd82832e853e	33633745-09fa-41cf-8999-73c50524bf14	1	2734dc66-d31b-4d97-aeda-645ce3eb6885	\N	\N	2025-08-16 03:00:00+00	2025-08-25 03:00:00+00	COMERCIAL	Etapa 1 importada
6e043d2b-0539-4991-9f48-732f3518b71e	33633745-09fa-41cf-8999-73c50524bf14	2	2734dc66-d31b-4d97-aeda-645ce3eb6885	\N	\N	2025-08-28 03:00:00+00	2025-09-06 03:00:00+00	COMERCIAL	Etapa 2 importada
ea3c1323-6960-4c99-949b-efec8e5bfe12	33633745-09fa-41cf-8999-73c50524bf14	3	2734dc66-d31b-4d97-aeda-645ce3eb6885	\N	\N	2025-09-08 03:00:00+00	2025-09-18 03:00:00+00	COMERCIAL	Etapa 3 importada
a6633bff-84e2-4d08-a538-28fa5d9f1d4b	bd122fa5-fe08-41b3-a9e7-e22a6afdc559	1	2734dc66-d31b-4d97-aeda-645ce3eb6885	\N	\N	2025-08-22 03:00:00+00	2025-09-22 03:00:00+00	COMERCIAL	Etapa 1 importada
4bc7e07d-1222-4aa8-9928-25fad21b4fed	39617ada-2006-4438-98de-c648708bfd67	1	372697a7-b884-4ed6-9bb6-1420610ba86f	\N	\N	2025-08-19 03:00:00+00	2025-08-31 03:00:00+00	COMERCIAL	Etapa 1 importada
7a3ee81f-b742-4bf1-84f7-ada6275d0cd9	3e75a594-3c83-4bbb-a935-41c7f7b97e18	1	372697a7-b884-4ed6-9bb6-1420610ba86f	\N	\N	2025-08-20 03:00:00+00	2025-09-18 03:00:00+00	COMERCIAL	Etapa 1 importada
d9aeb74c-489f-4800-b305-c29a6c7ae098	2f8b097e-c905-4113-9c24-91c7e1bc6fdb	1	372697a7-b884-4ed6-9bb6-1420610ba86f	\N	\N	2025-08-25 03:00:00+00	2025-09-07 03:00:00+00	COMERCIAL	Etapa 1 importada
ade02139-6bc4-4eaf-a3a5-d41fd4282a21	22c7640e-1c82-478c-ba99-c7aad500533c	1	372697a7-b884-4ed6-9bb6-1420610ba86f	\N	\N	2025-08-31 03:00:00+00	2025-10-08 03:00:00+00	COMERCIAL	Etapa 1 importada
9667af8c-d16b-4f5e-b33f-7efc6fead0ab	1146b6ca-433f-46c6-828e-20505d95a0e7	1	2734dc66-d31b-4d97-aeda-645ce3eb6885	\N	\N	2025-08-30 03:00:00+00	2025-10-06 03:00:00+00	COMERCIAL	Etapa 1 importada
b0efe096-bf71-469a-9c3f-fab6891c6b50	99be84a2-c566-4889-8658-94d78a307c5e	1	372697a7-b884-4ed6-9bb6-1420610ba86f	\N	\N	2025-09-04 03:00:00+00	2025-09-16 03:00:00+00	COMERCIAL	Etapa 1 importada
675c799f-0d57-4e06-9001-a1b750bf23af	f4c7effb-17ff-40d5-96f4-4f3c4b55a753	1	9d02d029-f003-41b6-89de-0eea18b2d4e4	\N	\N	2025-09-10 03:00:00+00	2025-10-20 03:00:00+00	COMERCIAL	Etapa 1 importada
c61e7345-0b04-4a71-b35f-ce014b0b7f75	49cb76e2-6c5c-41c8-844f-b6e822fe4a5d	1	b5066e3d-aff4-484a-b1ad-a45a57700aeb	\N	\N	2025-09-11 03:00:00+00	2025-10-01 03:00:00+00	COMERCIAL	Etapa 1 importada
ec2b1072-bb96-45d7-83a2-98b5786f1857	7e2b4aaa-aa80-4b25-8420-f362ff42341a	1	2734dc66-d31b-4d97-aeda-645ce3eb6885	\N	\N	2025-09-11 03:00:00+00	2025-10-18 03:00:00+00	COMERCIAL	Etapa 1 importada
89a6b527-adae-44fa-865d-eee9ca874439	08aa1c5a-14d7-4dfb-baff-feecda733570	1	372697a7-b884-4ed6-9bb6-1420610ba86f	\N	\N	2025-09-13 03:00:00+00	2025-10-13 03:00:00+00	COMERCIAL	Etapa 1 importada
8c4c5f9c-09dd-447f-81c0-d87e34e4de71	c9f0fdd5-39a3-4cdd-8f3c-9ea3cf16d665	1	b5066e3d-aff4-484a-b1ad-a45a57700aeb	\N	\N	2025-10-14 03:00:00+00	2025-11-08 03:00:00+00	COMERCIAL	Etapa 1 importada
dd274630-da31-495f-b583-8acd8fe03a20	40d73575-8ad6-4e4e-97be-efa35740cbc4	1	b5066e3d-aff4-484a-b1ad-a45a57700aeb	\N	\N	2025-10-15 03:00:00+00	2025-11-08 03:00:00+00	COMERCIAL	Etapa 1 importada
09de1b1f-10c8-45be-a37e-0d5e27ece77a	c88c0b40-6dde-4958-ae24-0cb74e70ac0b	1	b5066e3d-aff4-484a-b1ad-a45a57700aeb	\N	\N	2025-10-11 03:00:00+00	2025-12-21 03:00:00+00	COMERCIAL	Etapa 1 importada
ee45d198-f6fd-407e-9f0b-d97df5c49b38	04c8b29b-d8a3-43dc-8970-1cc25eb9a5e6	1	b5066e3d-aff4-484a-b1ad-a45a57700aeb	\N	\N	2025-10-11 03:00:00+00	2025-12-07 03:00:00+00	COMERCIAL	Etapa 1 importada
c270e232-abcc-4ca7-af86-c36fd49c5839	b9cdc61d-04ab-43a8-8042-0ecd9802756c	1	a05ae304-2d0e-4e29-a6f3-fa7372a41c97	\N	\N	2025-09-16 03:00:00+00	2025-11-19 03:00:00+00	COMERCIAL	Etapa 1 importada
ac994c7e-e0b9-4b59-9e69-48d7f5f6f5f4	df1ba756-d001-43d8-a9e6-daf83a275113	1	372697a7-b884-4ed6-9bb6-1420610ba86f	\N	\N	2025-09-19 03:00:00+00	2025-10-07 03:00:00+00	COMERCIAL	Etapa 1 importada
f51a948b-dbcc-4e27-8862-7766aad024bb	4d568a25-d459-47e3-b304-51cc271329e9	1	a05ae304-2d0e-4e29-a6f3-fa7372a41c97	\N	\N	2025-09-29 03:00:00+00	2025-10-30 03:00:00+00	COMERCIAL	Etapa 1 importada
ae9c90e9-5f32-4f68-89bb-0f2c3569b6ff	8c72194b-9889-4483-987c-9e35da7f3975	1	a05ae304-2d0e-4e29-a6f3-fa7372a41c97	\N	\N	2025-09-28 03:00:00+00	2025-11-07 03:00:00+00	COMERCIAL	Etapa 1 importada
7cb5b334-98b6-4ebc-93e9-82a8ab5785a8	7b29487c-a17f-4a2d-aecc-37099df405c3	1	2734dc66-d31b-4d97-aeda-645ce3eb6885	\N	\N	2025-09-30 03:00:00+00	2025-10-05 03:00:00+00	COMERCIAL	Etapa 1 importada
ba378bcc-89fa-4dee-936b-0d087ef960d9	7b29487c-a17f-4a2d-aecc-37099df405c3	2	2734dc66-d31b-4d97-aeda-645ce3eb6885	\N	\N	2025-10-07 03:00:00+00	2025-10-12 03:00:00+00	COMERCIAL	Etapa 2 importada
cddba05c-a2f8-4934-8fc0-691c7a7d9279	7b29487c-a17f-4a2d-aecc-37099df405c3	3	2734dc66-d31b-4d97-aeda-645ce3eb6885	\N	\N	2025-10-14 03:00:00+00	2025-10-18 03:00:00+00	COMERCIAL	Etapa 3 importada
8d8b614f-0e62-4a62-94ea-b241bde6cd01	7b29487c-a17f-4a2d-aecc-37099df405c3	4	2734dc66-d31b-4d97-aeda-645ce3eb6885	\N	\N	2025-10-20 03:00:00+00	2025-10-24 03:00:00+00	COMERCIAL	Etapa 4 importada
c87af309-f5a3-4592-ba93-db3716f95da2	7b29487c-a17f-4a2d-aecc-37099df405c3	5	2734dc66-d31b-4d97-aeda-645ce3eb6885	\N	\N	2025-10-26 03:00:00+00	2025-10-31 03:00:00+00	COMERCIAL	Etapa 5 importada
6fea2b51-9826-4a8f-8541-81d2515d6f5a	7b29487c-a17f-4a2d-aecc-37099df405c3	6	2734dc66-d31b-4d97-aeda-645ce3eb6885	\N	\N	2025-11-01 03:00:00+00	2025-11-09 03:00:00+00	COMERCIAL	Etapa 6 importada
287799c7-ac1a-4f79-9c55-f7442b22d160	e4232ca1-ac45-4b98-82c2-04f4ddfd3b9a	1	2734dc66-d31b-4d97-aeda-645ce3eb6885	\N	\N	2025-10-14 03:00:00+00	2025-11-23 03:00:00+00	COMERCIAL	Etapa 1 importada
524ee95f-70aa-4e05-9a65-4c5a33be761c	1ed14f37-2218-40e5-b02f-bf29559ed482	1	b5066e3d-aff4-484a-b1ad-a45a57700aeb	\N	\N	2025-10-11 03:00:00+00	2025-12-07 03:00:00+00	COMERCIAL	Etapa 1 importada
53971757-50cf-41bb-8245-d82028991d76	6222783f-ee4a-4a6a-becd-64c774e07957	1	2734dc66-d31b-4d97-aeda-645ce3eb6885	\N	\N	2025-10-19 03:00:00+00	2025-10-23 03:00:00+00	COMERCIAL	Etapa 1 importada
768c69f8-581e-496d-ab38-54f178ad8d05	6222783f-ee4a-4a6a-becd-64c774e07957	2	2734dc66-d31b-4d97-aeda-645ce3eb6885	\N	\N	2025-10-24 03:00:00+00	2025-10-29 03:00:00+00	COMERCIAL	Etapa 2 importada
284d8d30-745e-4744-8b04-c79e294e9141	6222783f-ee4a-4a6a-becd-64c774e07957	3	2734dc66-d31b-4d97-aeda-645ce3eb6885	\N	\N	2025-11-03 03:00:00+00	2025-11-10 03:00:00+00	COMERCIAL	Etapa 3 importada
7b72ce56-5557-4be3-b7ea-11907c6b0735	17afdb79-821b-4363-9f08-8a0a7b6721e2	1	9d02d029-f003-41b6-89de-0eea18b2d4e4	\N	\N	2025-10-30 03:00:00+00	2025-12-11 03:00:00+00	COMERCIAL	Etapa 1 importada
0859097c-6fca-4af0-8695-dfe83efcd264	d5432363-f925-48e2-9b5a-6fd67f073416	1	b5066e3d-aff4-484a-b1ad-a45a57700aeb	\N	\N	2025-10-23 03:00:00+00	2025-11-26 03:00:00+00	COMERCIAL	Etapa 1 importada
ce1b86fb-7580-4419-a866-342257b7a6a9	1658b6c3-62a3-435e-a705-bdfbb8f0b5e0	1	a05ae304-2d0e-4e29-a6f3-fa7372a41c97	\N	\N	2025-10-29 03:00:00+00	2025-11-20 03:00:00+00	COMERCIAL	Etapa 1 importada
a24dffb2-b723-49ee-90db-e1e52aa013d6	9170f973-5cf8-474a-b0c1-d67c5c212e8c	1	9d02d029-f003-41b6-89de-0eea18b2d4e4	\N	\N	2025-10-27 03:00:00+00	2025-12-07 03:00:00+00	COMERCIAL	Etapa 1 importada
0c0eb192-55c9-4b38-86fd-b41dc2e56a88	6ca427b8-af4a-4805-8ee8-56b5b37f0f4b	1	2734dc66-d31b-4d97-aeda-645ce3eb6885	\N	\N	2025-11-04 03:00:00+00	2025-11-12 03:00:00+00	COMERCIAL	Etapa 1 importada
dca291cb-952b-4998-85c2-d54db32b4040	6ca427b8-af4a-4805-8ee8-56b5b37f0f4b	2	2734dc66-d31b-4d97-aeda-645ce3eb6885	\N	\N	2025-11-14 03:00:00+00	2025-11-18 03:00:00+00	COMERCIAL	Etapa 2 importada
56734563-2a3c-47f7-9e39-5e532ca2eb9f	6ca427b8-af4a-4805-8ee8-56b5b37f0f4b	3	2734dc66-d31b-4d97-aeda-645ce3eb6885	\N	\N	2025-11-22 03:00:00+00	2025-11-27 03:00:00+00	COMERCIAL	Etapa 3 importada
7aa0b74f-8c92-4c74-a9e8-7e005904040d	6ca427b8-af4a-4805-8ee8-56b5b37f0f4b	4	2734dc66-d31b-4d97-aeda-645ce3eb6885	\N	\N	2025-11-30 03:00:00+00	2025-12-06 03:00:00+00	COMERCIAL	Etapa 4 importada
06436cc7-fcf5-4f72-8024-7440f7078a8f	2a684568-11b1-432a-9787-41ee84d82675	1	2734dc66-d31b-4d97-aeda-645ce3eb6885	\N	\N	2025-11-01 03:00:00+00	2025-11-12 03:00:00+00	COMERCIAL	Etapa 1 importada
6b8cedd6-4db5-4979-b80b-5990e4ee3018	03493cc8-4b8e-46f6-a5de-6ef2a78bf0da	1	2734dc66-d31b-4d97-aeda-645ce3eb6885	\N	\N	2025-11-03 03:00:00+00	2025-11-12 03:00:00+00	COMERCIAL	Etapa 1 importada
a6e0205e-2f22-4947-88b4-9cd3c8420aa0	03493cc8-4b8e-46f6-a5de-6ef2a78bf0da	2	2734dc66-d31b-4d97-aeda-645ce3eb6885	\N	\N	2025-11-14 03:00:00+00	2025-11-21 03:00:00+00	COMERCIAL	Etapa 2 importada
fd325b18-9079-47dc-936b-75fce41725c4	03493cc8-4b8e-46f6-a5de-6ef2a78bf0da	3	2734dc66-d31b-4d97-aeda-645ce3eb6885	\N	\N	2025-11-23 03:00:00+00	2025-12-01 03:00:00+00	COMERCIAL	Etapa 3 importada
8a6536cd-2e16-42bc-a6b2-d7f87c48ef84	03493cc8-4b8e-46f6-a5de-6ef2a78bf0da	4	2734dc66-d31b-4d97-aeda-645ce3eb6885	\N	\N	2025-12-03 03:00:00+00	2025-12-11 03:00:00+00	COMERCIAL	Etapa 4 importada
4d2dc578-7661-4e1e-81b8-81b8f3808b1a	69d83f9a-47b8-4756-bea7-3e69bb020de5	1	b5066e3d-aff4-484a-b1ad-a45a57700aeb	\N	\N	2025-11-07 03:00:00+00	2025-11-25 03:00:00+00	COMERCIAL	Etapa 1 importada
d39211b4-2d1b-4699-b129-ce6051725fbf	69d83f9a-47b8-4756-bea7-3e69bb020de5	2	b5066e3d-aff4-484a-b1ad-a45a57700aeb	\N	\N	2025-11-28 03:00:00+00	2025-12-21 03:00:00+00	COMERCIAL	Etapa 2 importada
3d123be1-cc20-4af8-9751-f7e1a8a0c4ab	6394e50a-10c5-4917-ba6f-589afccecb3c	1	\N	\N	\N	2025-11-04 03:00:00+00	2025-11-11 03:00:00+00	COMERCIAL	Etapa 1 importada
ca75f68a-4e2a-4703-bd5b-f8714360762d	ace3208f-5afa-4694-991d-5ed1d7aa6610	1	b5066e3d-aff4-484a-b1ad-a45a57700aeb	\N	\N	2025-11-12 03:00:00+00	2025-12-24 03:00:00+00	COMERCIAL	Etapa 1 importada
cf89eb6e-0b6e-4d44-a842-17d2a26bfa08	a2f89dfd-1da1-40bf-8455-c95c6e194389	1	9d02d029-f003-41b6-89de-0eea18b2d4e4	\N	\N	2025-11-10 03:00:00+00	2025-12-12 03:00:00+00	COMERCIAL	Etapa 1 importada
572d9679-d95c-4b76-bf8e-659081288fab	4694beed-eb69-4746-be8f-805e2b0d0664	1	a05ae304-2d0e-4e29-a6f3-fa7372a41c97	\N	\N	2025-11-20 03:00:00+00	\N	COMERCIAL	Etapa generada automáticamente (sin desglose)
ed705977-bd99-4f91-9027-a48c3ec47c3e	2b4edcfb-05d0-4cc2-8f31-a242812ac9b8	1	b5066e3d-aff4-484a-b1ad-a45a57700aeb	\N	\N	2025-11-20 03:00:00+00	\N	COMERCIAL	Etapa generada automáticamente (sin desglose)
cc43423f-43fc-4218-bd0b-b443bdf91f25	bc255866-6f19-4c1d-ba0f-1d8337f9f7f6	1	a05ae304-2d0e-4e29-a6f3-fa7372a41c97	\N	\N	2025-11-26 03:00:00+00	\N	COMERCIAL	Etapa generada automáticamente (sin desglose)
80142014-4296-4872-a880-416f8f88da28	6be0da64-8dc4-41ed-a981-a24b0d821de6	1	2734dc66-d31b-4d97-aeda-645ce3eb6885	\N	\N	2025-12-01 03:00:00+00	2025-12-16 03:00:00+00	COMERCIAL	Etapa 1 importada
65bbe3eb-6f48-4e0f-b674-6f035639305d	8cf38b26-ddc3-4723-911c-89feb780ea54	1	9d02d029-f003-41b6-89de-0eea18b2d4e4	\N	\N	2025-12-15 03:00:00+00	\N	COMERCIAL	Etapa generada automáticamente (sin desglose)
7f764a0e-0087-4758-bdaa-d2197d3e8082	e04ec6dd-6f56-4950-af6e-6bec6d42ff79	1	9d02d029-f003-41b6-89de-0eea18b2d4e4	\N	\N	2025-12-15 03:00:00+00	\N	COMERCIAL	Etapa generada automáticamente (sin desglose)
801aafe0-0047-44a3-a1e4-366afafb475a	9ee1d24f-51a1-4f27-8db6-8ce6b6fd6228	1	a05ae304-2d0e-4e29-a6f3-fa7372a41c97	\N	\N	2025-12-29 03:00:00+00	\N	COMERCIAL	Etapa generada automáticamente (sin desglose)
e02cafd6-648e-46f4-9189-97d334c33e89	80738274-20f0-4ede-bae2-df728f9e3ebc	1	68a3cc43-2e5f-4423-8302-3e11af1ff872	\N	\N	2025-12-26 03:00:00+00	\N	COMERCIAL	Etapa generada automáticamente (sin desglose)
65222668-28b8-4f88-932c-134abf1d37d3	6b6cc0ed-b50f-42c2-8444-1d339170a9c7	1	68a3cc43-2e5f-4423-8302-3e11af1ff872	\N	\N	2025-12-29 03:00:00+00	\N	COMERCIAL	Etapa generada automáticamente (sin desglose)
aaf151a5-f2d0-4e41-8a7e-463bdb12da12	0ebbed04-db06-4513-8459-0bf5c664cd4f	1	68a3cc43-2e5f-4423-8302-3e11af1ff872	\N	\N	2025-12-29 03:00:00+00	\N	COMERCIAL	Etapa generada automáticamente (sin desglose)
3270da83-ed9b-4eea-ac3e-3468a09b5113	f2ed706d-85e3-4755-8943-c1d67b6affda	1	68a3cc43-2e5f-4423-8302-3e11af1ff872	\N	\N	2025-12-26 03:00:00+00	\N	COMERCIAL	Etapa generada automáticamente (sin desglose)
c3443582-e8d7-40c4-989a-108e4839ac33	931d221a-92df-4547-b9ba-1ef2a41186ec	1	68a3cc43-2e5f-4423-8302-3e11af1ff872	\N	\N	2025-12-26 03:00:00+00	\N	COMERCIAL	Etapa generada automáticamente (sin desglose)
0b769e8f-7ceb-4821-80c5-1e68e642d51b	4eb1860c-0400-44c2-8374-6ffab53e27e6	1	b5066e3d-aff4-484a-b1ad-a45a57700aeb	\N	\N	2025-12-26 03:00:00+00	\N	COMERCIAL	Etapa generada automáticamente (sin desglose)
ddd87fef-d4d9-4b34-b84d-44cc48c68831	c4233c18-189c-4e02-842b-1e4c3d8da3df	1	b5066e3d-aff4-484a-b1ad-a45a57700aeb	\N	\N	2025-12-30 03:00:00+00	\N	COMERCIAL	Etapa generada automáticamente (sin desglose)
a1b76c22-d065-4d53-a524-452eb19d4b68	4e3172e4-dd55-44ee-9bf3-9fc29339a34f	1	b5066e3d-aff4-484a-b1ad-a45a57700aeb	\N	\N	2025-12-23 03:00:00+00	\N	COMERCIAL	Etapa generada automáticamente (sin desglose)
06ac21a0-17e3-4811-b9dc-e2b3b39d31e8	7a37c7ee-76a9-4afc-8388-29e59052dc9f	1	b5066e3d-aff4-484a-b1ad-a45a57700aeb	\N	\N	2025-12-30 03:00:00+00	\N	COMERCIAL	Etapa generada automáticamente (sin desglose)
eb9cf714-6818-4bc6-92fa-33963092ead5	6df19c4a-79d1-4af4-ad36-56a0ccd20f4a	1	68a3cc43-2e5f-4423-8302-3e11af1ff872	\N	\N	2025-12-29 03:00:00+00	\N	COMERCIAL	Etapa generada automáticamente (sin desglose)
353824c3-0e21-44e0-9090-6cb6969369b0	fbc3dc42-a0af-4383-b41b-45012e156918	1	9d02d029-f003-41b6-89de-0eea18b2d4e4	\N	\N	2025-12-26 03:00:00+00	\N	COMERCIAL	Etapa generada automáticamente (sin desglose)
c77f34ef-7a6c-4e60-9139-db97d6d4199f	71cb7c2c-aa87-40aa-9647-5688b9941b84	1	68a3cc43-2e5f-4423-8302-3e11af1ff872	\N	\N	2025-12-28 03:00:00+00	\N	COMERCIAL	Etapa generada automáticamente (sin desglose)
442378c1-1fa6-4845-8c19-25553ac4fc2b	7eb337eb-c578-4ad9-a7d1-b320d5687249	1	68a3cc43-2e5f-4423-8302-3e11af1ff872	\N	\N	2025-12-28 03:00:00+00	\N	COMERCIAL	Etapa generada automáticamente (sin desglose)
\.


--
-- Data for Name: mareas_etapas_observadores; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mareas_etapas_observadores (id, id_etapa, id_observador, rol, es_designado) FROM stdin;
f4116c18-e3c4-427d-89be-698673d97742	0f84bfd9-bdec-46fc-a6dc-24e008440587	67398676-bcc1-4d56-b18a-27f4599c6dc1	PRINCIPAL	t
07bc790a-2bfe-44a4-a49a-3b358f10dfb7	21fb433a-befa-4cf9-a084-14b37b31c4c2	82bc71af-a98d-47e4-8f0a-f7fc73f5b76a	PRINCIPAL	t
8629bba9-3010-4859-a167-23bf38ac4aaa	560221b0-9c9b-45d5-8bef-246a37a05662	331665d3-483f-4651-bfbd-2d6ee49c633a	PRINCIPAL	t
647a55f4-4fd0-4dba-9e4f-3486f3500646	39551550-669f-4d59-a31d-657ef0e4c86d	35fd7b9c-7e76-46ca-97de-72a2dacec5fe	PRINCIPAL	t
5d0e0d0d-acca-474f-903b-e3048ef13e8d	30e573cf-62ac-49a4-8390-d104fb35606f	bb9859bb-8ac2-4068-88f4-a742d7d79f44	PRINCIPAL	t
203c363d-d254-40c0-a526-03baa387fb4c	bb179327-ceea-4801-8a57-2c410b0ff789	8944792a-e053-42a2-a5b1-d52f47d4ad14	PRINCIPAL	t
33e6895b-9ee4-4ffc-ae27-d8a04356d3ad	fe1e7b97-32ba-452c-92f8-b8549f4c3a39	4656f2f8-9b64-464a-ba5e-4ba98c4d241a	PRINCIPAL	t
5c82f01c-e517-4d91-9b45-ceba74c78541	5bad594d-df1b-40c1-8b5b-13f6f41d2339	62b28318-fb31-4213-afd9-be57f0dad135	PRINCIPAL	t
80e4fda4-2ec2-49af-ab9d-66b341c404c1	8eb25d6c-f240-4119-8631-c5f8a452f64c	62b28318-fb31-4213-afd9-be57f0dad135	PRINCIPAL	t
d3831216-2ca1-416a-9559-f92884ea2cd1	e5e78676-aa48-44c9-b16f-0970b42309b6	62b28318-fb31-4213-afd9-be57f0dad135	PRINCIPAL	t
260883f6-0eab-4427-8303-abaf48c64bf9	6c3179ca-ee5b-42fa-b7f2-6bf3023e3e02	1583f826-957d-4907-976b-eceea82324be	PRINCIPAL	t
9b47aea5-b3a8-4616-82fb-7fcb89b97f64	0f7586f3-20a9-44fd-83ca-d6abdcce4673	1d4f6a90-26a1-40ff-a022-454d87df35d5	PRINCIPAL	t
6977e5ea-b547-47fc-96fb-d622a4121ff6	84f2c1b2-d477-40ab-9ffe-b7f01f014e86	9de01389-d90b-44b4-8289-cd7fcd8e9167	PRINCIPAL	t
d2f099d0-08b3-4f27-8c15-3abba04e0edb	b25d2622-802e-4c3b-abde-c35353f4cecd	5ba8b4e9-0443-4b42-941e-c22331c326bf	PRINCIPAL	t
0208090a-107b-4a6f-8a8d-8e972cd3b0d4	aac11fe7-0710-4c00-a34a-8a75cd4739aa	d24a7b81-a2f2-4dd2-8bfb-d413d5082488	PRINCIPAL	t
8a1b61ca-07ce-4823-97ad-745113b4db24	c7ad031a-c4e1-44d2-b512-59ce91e2bd58	cd84bae0-3c5b-447c-be9c-76a10d060399	PRINCIPAL	t
8e7156c0-0d46-4a06-85bd-f5610fd2e98c	30f78c59-6a02-4b1d-a9db-cad3cd9c3643	9cfb387b-6e60-4457-9dea-162d527398a5	PRINCIPAL	t
b4abc0d0-2df4-4d61-92e1-79c3dd271db4	cc8a2d34-ffbe-4b08-9216-de392019b9f8	9cfb387b-6e60-4457-9dea-162d527398a5	PRINCIPAL	t
4201c2c0-6013-42a1-8958-7e27accb099f	27eaa704-5c9d-4875-8121-f5872ed7cae0	9cfb387b-6e60-4457-9dea-162d527398a5	PRINCIPAL	t
ac6a40a3-ec2b-48c4-8578-7f30e451776c	089aff80-5210-4fdb-869a-8bf9bf3184ee	9cfb387b-6e60-4457-9dea-162d527398a5	PRINCIPAL	t
97ab975a-18b5-4500-a4da-41bff4d8a07b	9353fc40-2d8f-4235-8a3f-9127fbb42065	068fb09e-8b5e-4ed8-a4ec-2e953c1128bb	PRINCIPAL	t
28041e4a-c62e-4bf3-a1f4-690720f4619a	f6f520ac-b1bf-4056-b4ca-c2d528df4114	6e4d646f-d0ca-4032-9f61-e5c744881332	PRINCIPAL	t
03f76241-6bec-4a60-adaf-adaf65792b13	e98f8358-d3da-4396-980b-c2aafc11bace	39fe34fd-531b-4cea-a5f7-266132181fbc	PRINCIPAL	t
5f317ff3-a6e3-438a-8b32-607d2c20bf67	cc5861e0-26e7-47d9-9239-c4a726f8d244	b376ef19-8b73-4bd0-bf0b-4cecf76eba6e	PRINCIPAL	t
055c0491-79a2-43ac-91bd-99dba77afd9d	0db79420-f4b0-4595-b0d3-eafd5ad1cd16	8944792a-e053-42a2-a5b1-d52f47d4ad14	PRINCIPAL	t
2d43736a-75d4-4cd2-9558-7a30fd6c5065	1e817eae-333d-429d-9261-ccb9ea1c3078	3a4ad215-8ed5-4caf-a506-ccd72b30b966	PRINCIPAL	t
71eda3ea-c16b-47c5-aaf5-85e5f83b9501	f28601a3-b6cf-4bef-83f9-664f56dd8200	fe6f0d3b-7aa6-40e8-8ca7-b9b3c060fa04	PRINCIPAL	t
6f4a1eae-8bb5-4670-b5bb-185dc562f051	6c9f9e36-9a78-4bc8-a0a2-fcca8a851964	6e4d646f-d0ca-4032-9f61-e5c744881332	PRINCIPAL	t
6c8c015f-a8f2-4d4f-9a6c-df5d59c415b6	fc1e84b5-350a-4871-8274-ad63f7f12f81	6e4d646f-d0ca-4032-9f61-e5c744881332	PRINCIPAL	t
b0997005-4c21-4c93-8605-c346e6f17832	6980c18c-bc34-4dce-83d5-e0e815462edf	82bc71af-a98d-47e4-8f0a-f7fc73f5b76a	PRINCIPAL	t
113d1f69-8ef8-470e-b230-d5c981209504	f68072b9-cd27-4931-ab00-5cfef4db693f	fd1e6b19-e418-443f-b399-53eac06e72df	PRINCIPAL	t
6aab9baa-4128-4ff0-81c8-e150ef07316a	6ff90088-465f-4e56-8258-cf138d667b89	2866137d-8abc-4ec3-83cc-68db9e1cedf7	PRINCIPAL	t
a8e80201-0df9-4329-a8fc-63bf596f4cca	caa34109-4d26-4eca-a9ec-be0265ca5ac4	d18717f7-8f9f-4218-9992-67c91148ec6b	PRINCIPAL	t
00abc0a9-98a9-469f-af3e-8ccbc063e8b0	34d1f115-5a6f-4332-8678-5ff0914ff313	3e439fbc-273c-4c12-8a9f-bea34cd03fd5	PRINCIPAL	t
3510d8a6-f632-467c-b578-52d23880c379	ae6b90b4-69c1-41c5-9f0c-594edaa0d716	2efbccf5-90b1-4fa5-9600-714f2ac0f4ca	PRINCIPAL	t
52df983a-e89b-40f6-b635-454109f5fdcd	bb0a1682-57a4-46cd-9dd2-a76891e8ab8a	2508aad7-5219-4d58-b200-1750f1d0e414	PRINCIPAL	t
edf94628-7ba7-4cb7-8068-72f1bc709adb	195b64ef-ea50-440c-873e-dc0df0a7d927	de391ff2-5dae-49e2-82c0-8369ed785e77	PRINCIPAL	t
dcef891d-43c1-41f0-bc80-73afe534058f	efa436ca-b879-471c-b1bb-208e12515c5b	99fa9f30-6c48-4576-98a3-938f6d86157d	PRINCIPAL	t
ce2cd3ea-c87b-493b-90b5-46614caa2bbb	7b277fa0-7c32-448d-b86e-0fd2a361d0dd	4656f2f8-9b64-464a-ba5e-4ba98c4d241a	PRINCIPAL	t
6abc1262-6cc8-43ca-898b-7382c500c710	2f50ce02-6357-489e-81ec-b2b96c94d10f	9de01389-d90b-44b4-8289-cd7fcd8e9167	PRINCIPAL	t
bd2882ce-0520-49a8-9935-dbe5788825b7	47ee8cce-484c-44bd-bb62-ede3b0cf0cc0	5ba8b4e9-0443-4b42-941e-c22331c326bf	PRINCIPAL	t
349c085a-1db6-4d11-a564-37a484ad7140	6b43ce46-b98c-49c4-a0a0-d9d75986f839	7a0c914b-ac5e-45b6-b586-fb2ad2efd969	PRINCIPAL	t
2c8aa8b2-839b-4560-8ac2-39b0cf890106	f1627463-0850-4b99-bb70-c0fd22c4f74e	1583f826-957d-4907-976b-eceea82324be	PRINCIPAL	t
a89e86f2-621c-4966-9490-274d70024117	2ad36685-cac2-45c4-ae9f-7a999144b7f1	9dbd39c5-5ddf-457a-9253-f701147ee915	PRINCIPAL	t
aa08fcc1-5e54-499d-a8e1-8f51d80d3941	9c7a9094-8008-4d30-af54-b6cbf071a3c0	068fb09e-8b5e-4ed8-a4ec-2e953c1128bb	PRINCIPAL	t
63b401c2-54a4-438b-a533-23ebf95bcd06	b24898bd-aa00-47fa-b18a-f9cde9f60b8a	5fadeb17-1d8f-4006-9aa4-6a8a0d332d90	PRINCIPAL	t
29fb6178-c957-4324-abfd-391d281321c5	314f1f50-d544-40a0-9a3c-b07186fa2c83	b987eba0-d18c-46a1-aeb5-a0e202f3c4f0	PRINCIPAL	t
4c3b3c0e-2c35-48ad-bb89-556f82487af5	3c75211c-c8ff-48f2-a5c6-00500fcc9455	b987eba0-d18c-46a1-aeb5-a0e202f3c4f0	PRINCIPAL	t
ec4c6d71-9c67-4730-9dcf-f1edcc54c14e	cb7e5393-b692-420c-a213-8b8cc88fd08c	fd4b5bba-2006-4fad-8183-09848a55afe5	PRINCIPAL	t
396ad6d7-ee75-47f6-a847-29c514db5398	71fa94c0-9d09-4d81-919f-46d403f72e1a	fd4b5bba-2006-4fad-8183-09848a55afe5	PRINCIPAL	t
617551c1-838d-458b-a7bc-e68b0d6563cd	91a3962f-eeaf-4a4f-8f04-eff9af53c4db	67398676-bcc1-4d56-b18a-27f4599c6dc1	PRINCIPAL	t
2c0bce80-4403-4831-ba6c-b481db309d9f	4cd72921-92c2-463c-a0f1-179f265ed4cd	67398676-bcc1-4d56-b18a-27f4599c6dc1	PRINCIPAL	t
2076e21a-b270-48da-8558-c1be578177a3	d7654c36-5dc5-43fc-ad68-81440816216c	4656f2f8-9b64-464a-ba5e-4ba98c4d241a	PRINCIPAL	t
d2c0937b-8aaa-424d-a686-3c8fe53f70a0	942bbaa9-69a4-4ed6-9d8d-1105904fc89f	4656f2f8-9b64-464a-ba5e-4ba98c4d241a	PRINCIPAL	t
4ca5ecae-3d7b-4a62-938f-9083ccec36da	c2bdd9a9-fa7e-4b8a-b11a-34be4d788075	d24a7b81-a2f2-4dd2-8bfb-d413d5082488	PRINCIPAL	t
8e4f5dd9-586b-4969-8faa-fd343d0ed071	5e77ec19-6180-42cb-bc0d-3ef94f87ccf2	d24a7b81-a2f2-4dd2-8bfb-d413d5082488	PRINCIPAL	t
f783f8d1-7f80-4b9b-9dae-8d160fbbbf71	0fa83324-d481-4a9e-92c8-c5685f7f512c	3a595519-7015-4f2d-a30c-21a8c7411569	PRINCIPAL	t
274faf81-feba-4478-9f13-09855f3ef68f	38d08292-3778-4f69-8a82-2db460966790	aa3c098f-6e98-48c7-bce3-25fdccf6b343	PRINCIPAL	t
a1333339-a4f3-4e93-a7bd-4d811846c982	591ae55c-d814-4f3f-945c-c276bd09c823	35fd7b9c-7e76-46ca-97de-72a2dacec5fe	PRINCIPAL	t
a3ab3045-2720-401f-b3f3-15129a2c5b8a	6f6d3e9d-ef6a-4648-ad2e-6aecb5400a52	fd1e6b19-e418-443f-b399-53eac06e72df	PRINCIPAL	t
aafd4bc9-93d4-4e0e-8c8f-cdf3c13e8c69	36cb2d35-289f-4359-a402-4dac4834db63	1d4f6a90-26a1-40ff-a022-454d87df35d5	PRINCIPAL	t
f83a8854-aee4-4dc0-b1bd-a0745bc39d89	877fb241-0d1c-4d46-b368-79016322202a	78e01ded-85a2-4ba6-8359-c23cfc30653f	PRINCIPAL	t
e1a2c2c6-ca6a-489a-ad65-45dee5334148	70765594-f4a7-4f62-a002-9d3cd2829c45	b376ef19-8b73-4bd0-bf0b-4cecf76eba6e	PRINCIPAL	t
68ae6af8-09b1-4bb2-86f4-239e4ca7353c	d45ec5f6-efb7-4869-b58c-633a1dd74547	9dbd39c5-5ddf-457a-9253-f701147ee915	PRINCIPAL	t
8a7037a5-dce4-4646-b35a-d250ccb64842	6afc768e-79f3-446a-9402-76a3970f8298	82bc71af-a98d-47e4-8f0a-f7fc73f5b76a	PRINCIPAL	t
1cf7bf0a-4043-4441-9520-105c7c7f9035	d37193be-0cbb-472f-9c33-c469cf6b0725	bb9859bb-8ac2-4068-88f4-a742d7d79f44	PRINCIPAL	t
fd75fd7c-1dde-48eb-ae2e-95ed518c3e85	a7f7be50-73ef-47c2-b2f0-f761fad42ae6	d24a7b81-a2f2-4dd2-8bfb-d413d5082488	PRINCIPAL	t
f116288c-db42-4caf-8360-50c2199d6715	34eb965a-fcc3-4eb3-8e20-fe36a096a7d1	5fadeb17-1d8f-4006-9aa4-6a8a0d332d90	PRINCIPAL	t
f45da1cf-b075-40b5-9a86-dbe33f5993d3	4a14dbd6-9ff2-47d5-bb02-81c484964b07	39fe34fd-531b-4cea-a5f7-266132181fbc	PRINCIPAL	t
d135d3e4-57cc-4730-bb3c-45ff7e43c372	3a562759-e5e5-43b4-b581-6f67f2b1e3c9	331665d3-483f-4651-bfbd-2d6ee49c633a	PRINCIPAL	t
5871c5b5-ba60-4fc3-8392-d04a8c72ea31	0cd3ad5c-1806-42ed-9b10-1970e4709785	fd4b5bba-2006-4fad-8183-09848a55afe5	PRINCIPAL	t
1cd36cff-7b44-4a96-976d-00779f815832	02733616-9586-46e8-a667-5512f776168d	4656f2f8-9b64-464a-ba5e-4ba98c4d241a	PRINCIPAL	t
ee4849c6-f45e-4252-86c4-c0d1914963ab	36098fe5-e852-420e-bfdc-ea7d03345276	b987eba0-d18c-46a1-aeb5-a0e202f3c4f0	PRINCIPAL	t
382783c0-92f0-49b5-8699-668a5448eb48	a3c0ad2c-21fb-4025-8694-2c8fb6f18efa	b987eba0-d18c-46a1-aeb5-a0e202f3c4f0	PRINCIPAL	t
9c96ef22-f087-44ac-af71-e5b4a3f07deb	b67defcb-7fc2-4366-9342-1e8ae011d209	b987eba0-d18c-46a1-aeb5-a0e202f3c4f0	PRINCIPAL	t
f95f11cd-335b-4153-82b8-3247b739127e	cb548f7f-24fa-43e8-a1db-9af06491d051	9cfb387b-6e60-4457-9dea-162d527398a5	PRINCIPAL	t
ccd242a7-97da-4310-aa39-9e92a54e6fc3	6fab3e78-1c6b-4e00-ab43-a0e2d588d823	2efbccf5-90b1-4fa5-9600-714f2ac0f4ca	PRINCIPAL	t
00d030ae-9402-418e-85da-6892ddd36d3d	46379366-6424-47d3-8e8a-5961609945c2	2efbccf5-90b1-4fa5-9600-714f2ac0f4ca	PRINCIPAL	t
e84d2875-8a47-497f-aa6d-3baa54de8f32	25a0b133-bdfe-4c9b-81aa-1998feb341dc	2efbccf5-90b1-4fa5-9600-714f2ac0f4ca	PRINCIPAL	t
c9b0d655-f9e8-4d31-9e5d-f60db3a1cd26	4608e8df-a59a-4fae-bd9d-71935fb98116	67398676-bcc1-4d56-b18a-27f4599c6dc1	PRINCIPAL	t
e6e6b769-a994-48fe-b5d3-90147a0ea518	c719b21c-dab8-4feb-aba6-ea628a44efff	67398676-bcc1-4d56-b18a-27f4599c6dc1	PRINCIPAL	t
a5807919-29c4-400c-be6f-aacc32f0f05e	dc45853e-aaf7-46f0-9dfa-bbe5f10764ed	3e439fbc-273c-4c12-8a9f-bea34cd03fd5	PRINCIPAL	t
cfeaab44-4979-4b67-8366-75ae7c1f6646	1b716849-7a8b-4fe2-9c37-525ded87e691	62b28318-fb31-4213-afd9-be57f0dad135	PRINCIPAL	t
98e99180-1ed5-49c1-834e-6a29ee8ce01b	fa63bce6-fd52-42c2-95dd-a798f755da94	62b28318-fb31-4213-afd9-be57f0dad135	PRINCIPAL	t
91c949e9-ac53-4d95-9b9a-5972c617c5af	24c7980b-14e0-4997-8e07-83717a7e9847	62b28318-fb31-4213-afd9-be57f0dad135	PRINCIPAL	t
33096ec9-2621-4e0b-adbe-9bf1e1bbded9	c4640235-80cb-415f-8e61-75ee919bfe54	fd1e6b19-e418-443f-b399-53eac06e72df	PRINCIPAL	t
9d4079d7-4149-41e3-8ed6-531f1b4bcddf	91e52316-fceb-4be9-93fd-648a3454e8cd	3cc25630-1294-4ac7-bdea-9a0b0e63f608	PRINCIPAL	t
9c58500b-da53-451d-8af3-c440d3c4e7d6	10e46e81-bf20-42fd-ae4a-815c5b34754f	3cc25630-1294-4ac7-bdea-9a0b0e63f608	PRINCIPAL	t
78243fb4-2095-4cf8-a055-e205bf4a18be	9c4fc815-d4d6-438c-ab64-d3d65a1b79bb	43586eab-9ed2-4505-a7b0-dd71637450d4	PRINCIPAL	t
9c4713e1-ada3-4bf0-8843-58fb34de8cab	0d03112a-2574-4546-9ad7-aeaa1c29e73d	e9ecccbe-4f88-46e7-bb58-1fc6e64ba9d9	PRINCIPAL	t
3b8f2a67-439d-4d9a-b55f-a60f7d8237c2	3353fe2c-de03-4824-8df4-67a7ef04cee6	8944792a-e053-42a2-a5b1-d52f47d4ad14	PRINCIPAL	t
1035be24-882a-42c3-b1ba-d3c8adcc31fc	75e395c9-be7e-4a26-9b9e-f87c5544fffa	8944792a-e053-42a2-a5b1-d52f47d4ad14	PRINCIPAL	t
9e7ca4f5-1078-4ac9-8d57-9302e3545b43	dce39215-beec-4e5d-925a-a3e270062a52	8944792a-e053-42a2-a5b1-d52f47d4ad14	PRINCIPAL	t
62407a3f-fb03-49a9-975c-7759d87c7078	f408dbf5-2a11-4e57-96fb-2232550e92d2	35fd7b9c-7e76-46ca-97de-72a2dacec5fe	PRINCIPAL	t
19824086-96bf-43a7-860d-f5c8da53c7b3	74c6d95a-4ca9-4114-82f2-d5cf1c355385	6e4d646f-d0ca-4032-9f61-e5c744881332	PRINCIPAL	t
5f17718b-69a7-476c-aaac-0197e6cfd8a4	4a7ed296-9254-4793-a1ab-5077c05009d1	5ba8b4e9-0443-4b42-941e-c22331c326bf	PRINCIPAL	t
f1fe6ae7-1948-41f2-aead-578161501d3b	b6a19003-4ccf-4f13-a3f0-4b0391f3a9f9	3a595519-7015-4f2d-a30c-21a8c7411569	PRINCIPAL	t
54bb9a0b-7bfd-41f5-8f4b-163fa27b5156	7c129f67-874a-4cba-876c-1b67198b5782	c253e74a-9b43-495f-97b3-a90aad69da92	PRINCIPAL	t
db84e761-6d22-4a90-9a73-83da4eae4608	54991a85-e24f-42bd-9f13-11fd1adc646c	5e0a00a1-c616-4774-8c82-7e046229f9a1	PRINCIPAL	t
89ca722e-bf3a-43ee-ad4d-ba3ff4911790	936f70fc-850c-45bd-a3f4-8ba43b72d969	99fa9f30-6c48-4576-98a3-938f6d86157d	PRINCIPAL	t
73c9741e-d971-4d12-81c3-dbf6993f2679	defd5ae8-1da4-4cc8-a6fd-ef894f35599e	aa3c098f-6e98-48c7-bce3-25fdccf6b343	PRINCIPAL	t
b2660be0-0347-45ca-87ec-4a1f4f231c8f	760b050c-f09f-4324-9566-fd47fd901b22	068fb09e-8b5e-4ed8-a4ec-2e953c1128bb	PRINCIPAL	t
b8413db3-e1b6-4b21-b84f-3bd0ae522411	69399898-b840-4cc1-bd56-3a4fd9adb989	f12990f3-4652-43ff-8baa-c8062c61bf09	PRINCIPAL	t
bf03a6f8-23fb-4163-888c-0fa9b2aa3441	f0f75735-2ab6-486b-b26a-f1afafd9abd4	cd84bae0-3c5b-447c-be9c-76a10d060399	PRINCIPAL	t
40bb7c97-aff6-47f3-8ca7-2ae539767e65	cde8e4fe-ae79-4cc9-a9d5-8d41fcd6590a	7a0c914b-ac5e-45b6-b586-fb2ad2efd969	PRINCIPAL	t
53d5e30b-c6b6-4a2b-af28-f8ebd10ab538	aa58c987-35a0-4245-a52b-51898ad4bba2	82bc71af-a98d-47e4-8f0a-f7fc73f5b76a	PRINCIPAL	t
de4f5bfb-efe1-44b8-a085-d4f006765684	759a6080-c8d2-4115-9def-de5d7ed898a2	1583f826-957d-4907-976b-eceea82324be	PRINCIPAL	t
00e169fd-7bfe-495d-8108-3b7221ce1cc9	9f405122-9ab0-47db-99c3-7691f73b0b85	1d4f6a90-26a1-40ff-a022-454d87df35d5	PRINCIPAL	t
5424b884-c7e6-425e-9030-1f01521fac56	0d386c0d-1d58-47d2-b0a3-39c47d2d8ebc	b987eba0-d18c-46a1-aeb5-a0e202f3c4f0	PRINCIPAL	t
954c333c-d395-4158-9849-03e9a94791c3	1163db14-7d00-4b5b-9c37-50b0b2f39a0a	b987eba0-d18c-46a1-aeb5-a0e202f3c4f0	PRINCIPAL	t
19c67611-c4bd-486f-b51c-b9088a0c0d3d	1325c85d-b790-4d1f-a1e2-0d5dbf105e6b	b376ef19-8b73-4bd0-bf0b-4cecf76eba6e	PRINCIPAL	t
7cb92d2e-fee6-4704-afe7-f1c8689012a1	1d99aa93-7f8f-4723-a008-e93d22b539ed	8944792a-e053-42a2-a5b1-d52f47d4ad14	PRINCIPAL	t
9c412d92-d9c8-4e16-bb34-8e9ccc9b5ca1	39fdd8bc-b688-4f3f-b84b-2a22fbce7d36	8944792a-e053-42a2-a5b1-d52f47d4ad14	PRINCIPAL	t
2f2782b1-6827-4ef6-aa08-6bab8257c321	d2c94f1d-fc73-4870-9bc8-421fefd0c29a	8944792a-e053-42a2-a5b1-d52f47d4ad14	PRINCIPAL	t
195e6d88-03d7-48a9-9247-29848a2c0f2a	6bac9646-09a1-4477-b46a-abb85877aa26	8944792a-e053-42a2-a5b1-d52f47d4ad14	PRINCIPAL	t
3cf46b9e-4788-43df-babb-9f99bc203894	12e3721f-537c-4bd8-80e7-548e2ead5d70	67398676-bcc1-4d56-b18a-27f4599c6dc1	PRINCIPAL	t
78924d6b-18a6-4bdd-8f89-ed553ca9624e	a2153d81-846b-4fc8-89e5-b8d6f50e4fef	9cfb387b-6e60-4457-9dea-162d527398a5	PRINCIPAL	t
08a17379-414e-4378-a0b9-cc3f1d533f5a	3ad6ff2c-9047-4755-93a8-803b35346beb	fd1e6b19-e418-443f-b399-53eac06e72df	PRINCIPAL	t
ef3145c4-4210-4c7a-8686-afd7f79f98c9	570bf90a-db92-42ed-b324-692cb3a97968	2508aad7-5219-4d58-b200-1750f1d0e414	PRINCIPAL	t
fdcbd8ae-37ad-47f3-b208-c017fce51288	6b11bd96-0e1a-44c8-b1fe-52bb90ea0e1b	2508aad7-5219-4d58-b200-1750f1d0e414	PRINCIPAL	t
5b27ab24-dc3c-466e-a046-9cc570bf532e	cc4a87fd-9d4b-482e-9da1-9070dbf45c78	2508aad7-5219-4d58-b200-1750f1d0e414	PRINCIPAL	t
a0de85c9-cb14-487b-a9c0-60d70b563390	eb2e3f86-385e-4a23-9062-ba0001691726	2508aad7-5219-4d58-b200-1750f1d0e414	PRINCIPAL	t
7b799dc5-c54e-46ec-87b4-70888504cfe9	061e4666-078b-4fc8-8432-391350c191c7	2508aad7-5219-4d58-b200-1750f1d0e414	PRINCIPAL	t
d117f40a-bf33-4b75-88f0-f88d1d86106a	49686042-4fa6-4045-a396-bbe175451ad1	6e35ae78-39ea-4a6a-a0b7-9787969f7b3f	PRINCIPAL	t
b359fa35-dfa3-432b-aaa2-1debe1c0cd40	645ab54b-79d3-4e2a-8f4f-0163225bbc99	6e35ae78-39ea-4a6a-a0b7-9787969f7b3f	PRINCIPAL	t
8c7b1fd7-84ea-4eec-923c-cad7fb35a064	b3346eac-150f-49f0-9c21-12014caa3c06	331665d3-483f-4651-bfbd-2d6ee49c633a	PRINCIPAL	t
ddd0de17-d61c-4bb8-ba78-176e91b81877	205d23bb-8424-4869-ae60-ece3e07aa39c	2efbccf5-90b1-4fa5-9600-714f2ac0f4ca	PRINCIPAL	t
f2a6afb9-ccea-4fff-8aca-4bd70140ee48	75a3c8d0-0197-485b-a518-53735f19016d	99fa9f30-6c48-4576-98a3-938f6d86157d	PRINCIPAL	t
3dbdf7d6-f523-49e3-8b25-0602a5bbe64e	0070012b-1eae-478e-9bc3-3357834701db	b987eba0-d18c-46a1-aeb5-a0e202f3c4f0	PRINCIPAL	t
0dfecd0e-e1e8-4efd-a0c2-4fe08d11a8dd	6fdea6dd-e9fa-46a5-9200-a76ba2752a62	4656f2f8-9b64-464a-ba5e-4ba98c4d241a	PRINCIPAL	t
108e72c9-fb29-4427-af99-2202f790a905	b1261ea0-939a-4e7e-94e4-86edb987efae	4656f2f8-9b64-464a-ba5e-4ba98c4d241a	PRINCIPAL	t
4e3412d5-afda-4ae9-92ac-305f15dba986	d6eda3b3-6995-4ff0-affe-bb891e996f51	aa3c098f-6e98-48c7-bce3-25fdccf6b343	PRINCIPAL	t
3340f5d5-cde5-4275-83e3-564b634bc5ba	5f677bad-51f1-493c-a85e-b311e119c22a	aa3c098f-6e98-48c7-bce3-25fdccf6b343	PRINCIPAL	t
d3415dcc-4221-4f13-81ae-435c25756374	a901ed6a-ffe1-49c0-9412-6139791af564	aa3c098f-6e98-48c7-bce3-25fdccf6b343	PRINCIPAL	t
246f3f4a-c516-4bfb-b89c-0fd080d1be73	68564bfa-1b85-4ac6-8832-c540ad72c615	aa3c098f-6e98-48c7-bce3-25fdccf6b343	PRINCIPAL	t
f89b93ea-67a6-4aba-aa7c-624f3a08b741	cb0941c4-7d37-4bec-be5d-7c1c5e93ec9d	99fa9f30-6c48-4576-98a3-938f6d86157d	PRINCIPAL	t
461192bd-4446-48ad-a7d9-0dbc84427579	3182d1ca-5ce1-4850-ac24-dd315919177d	2efbccf5-90b1-4fa5-9600-714f2ac0f4ca	PRINCIPAL	t
09db6900-552f-425d-acb9-0ef4955fbf37	7cb73a06-cac9-43c9-87b6-310958f868ce	2efbccf5-90b1-4fa5-9600-714f2ac0f4ca	PRINCIPAL	t
36615498-65dd-4b6a-bd2a-dae61231ab71	0e442218-381c-40ec-9b8b-a8d67cbdbdc7	d24a7b81-a2f2-4dd2-8bfb-d413d5082488	PRINCIPAL	t
272f40d1-f60c-46b7-b855-fc33833a53b1	b0883fc2-9cac-4730-b22d-ef2f9489f43f	43586eab-9ed2-4505-a7b0-dd71637450d4	PRINCIPAL	t
2d4e3e73-35db-4e4b-b111-22e12bbc59db	2e55e90d-de96-4399-ba47-ef3c81800fd6	43586eab-9ed2-4505-a7b0-dd71637450d4	PRINCIPAL	t
e28aa290-740e-4930-b3ff-ecdd590e7d16	180babed-15a2-47f1-a2f6-164de1934d72	43586eab-9ed2-4505-a7b0-dd71637450d4	PRINCIPAL	t
e869c378-b4d9-4c86-a022-f302bff6bb60	210b2354-f27b-4c52-b592-b66620ade1f4	9de01389-d90b-44b4-8289-cd7fcd8e9167	PRINCIPAL	t
ebd958f0-eee2-400e-b427-68af1c9ed051	ccb25bd1-8641-4c57-b7e6-a503f04c3f73	82bc71af-a98d-47e4-8f0a-f7fc73f5b76a	PRINCIPAL	t
9dc0b289-86ef-472b-bebb-e3c07bcd3117	5de08c0d-8e3c-4224-802e-c3d18821f757	331665d3-483f-4651-bfbd-2d6ee49c633a	PRINCIPAL	t
8f2ef9c3-97a9-4bdd-a455-11d4d6f69c4c	d3a7e106-43b7-47d9-8ff4-c230061fec28	821fdf27-3a22-4dd5-83a3-4c0d31cb9f18	PRINCIPAL	t
857db35a-2126-4cc0-a67d-0b2ea086ef94	80f5ef93-0752-482f-b86c-9dd8b580da1f	6e4d646f-d0ca-4032-9f61-e5c744881332	PRINCIPAL	t
a1992dc3-f983-4edd-9959-ff92410c99d0	d4d492f3-2144-43d5-8e39-377256b7d2ee	fd4b5bba-2006-4fad-8183-09848a55afe5	PRINCIPAL	t
190c6572-93cf-4fac-8bf0-d7f8e10bf6f2	56d447ee-7527-4eb9-b390-f4bc4ddb5174	fd4b5bba-2006-4fad-8183-09848a55afe5	PRINCIPAL	t
8c683c66-521a-4f7e-bae8-a197cb765c1e	5d750f7e-2cf2-48e4-b49f-b9bf17b37b23	fd4b5bba-2006-4fad-8183-09848a55afe5	PRINCIPAL	t
9eed3678-52d8-4706-9926-b46e77239ac7	1ddec261-ab42-4f57-bf19-ae2cf4e29c5a	fd4b5bba-2006-4fad-8183-09848a55afe5	PRINCIPAL	t
ba8b2a48-db5a-4993-9688-48364c38e725	78f92f8d-deb3-47b0-9c56-c058b9834d79	1583f826-957d-4907-976b-eceea82324be	PRINCIPAL	t
3ba0bd27-9ca3-4b4d-94af-9c7c1530bec9	6472a075-e374-4aeb-a166-c675531705e9	67398676-bcc1-4d56-b18a-27f4599c6dc1	PRINCIPAL	t
7ec0a6b0-a76e-49c8-af7d-3aaeefdf3fb1	e4f14f03-c5da-4c59-a5c4-d663882727ea	35fd7b9c-7e76-46ca-97de-72a2dacec5fe	PRINCIPAL	t
a70d836c-9920-40bb-aec0-0669031823fe	23ba3552-30f1-4867-85a5-1d363c4ef39d	d24a7b81-a2f2-4dd2-8bfb-d413d5082488	PRINCIPAL	t
6158106a-76c4-4ad1-b4d1-8d92211454b5	ae54d62b-7cf6-4d5d-8785-101eda7e1369	e9ecccbe-4f88-46e7-bb58-1fc6e64ba9d9	PRINCIPAL	t
27760644-e1ce-4762-9b9e-77db30ad930b	55d3b21a-e645-489b-b079-30a93163fead	9cfb387b-6e60-4457-9dea-162d527398a5	PRINCIPAL	t
0c48bb8b-a96e-406b-9f3d-290ee0d3abaf	0483fa0b-7af4-4701-bfc7-83bd89318764	3e439fbc-273c-4c12-8a9f-bea34cd03fd5	PRINCIPAL	t
bd0e1ab0-9a03-465e-b2b6-cb7c74a96890	94b2d7d3-100c-4bab-9931-187c8a3d4af8	5fadeb17-1d8f-4006-9aa4-6a8a0d332d90	PRINCIPAL	t
8b00697a-6ce8-4572-bc63-f692db7e8fd1	d61b41bd-62c6-45aa-b2ca-d63929368c57	5fadeb17-1d8f-4006-9aa4-6a8a0d332d90	PRINCIPAL	t
0c28770b-0beb-4e94-afc3-98d3f1acd227	f185e9c8-6280-416d-bf5d-e06f3d169ec3	5fadeb17-1d8f-4006-9aa4-6a8a0d332d90	PRINCIPAL	t
a6f6012b-d6a3-4fa4-90c4-7c954b14f1c2	40fb80d6-a022-4415-a954-8d75b31f6557	9dbd39c5-5ddf-457a-9253-f701147ee915	PRINCIPAL	t
26c35733-5664-4439-8b67-e6268b44c120	5c9395ab-097e-46ca-8e02-daaed1d76c4f	4656f2f8-9b64-464a-ba5e-4ba98c4d241a	PRINCIPAL	t
3faff0ca-716b-42ea-907a-2c26b5933b83	4426c449-2f2f-4740-a9da-6ef0738fd828	fd1e6b19-e418-443f-b399-53eac06e72df	PRINCIPAL	t
f07d5d98-7da5-4cfc-a580-9c496ca3baca	2ab8035b-bf93-4b18-aa96-e784db2ca1c8	fd1e6b19-e418-443f-b399-53eac06e72df	PRINCIPAL	t
1abf6538-b649-4978-a301-14a7036fe157	d17a051c-e36a-41f4-a473-1e10d5775e08	2508aad7-5219-4d58-b200-1750f1d0e414	PRINCIPAL	t
60996256-0221-4a3f-8065-f7a45bf5cdc2	48d15c8b-b828-4c67-8207-b9b75d0e55dd	99fa9f30-6c48-4576-98a3-938f6d86157d	PRINCIPAL	t
d0fcb5c0-b23a-48b4-8cbf-5734d5189ae1	aba6a1e1-ac76-4bd6-aab8-c6cc314cc305	b987eba0-d18c-46a1-aeb5-a0e202f3c4f0	PRINCIPAL	t
a316d0dd-2729-4cdb-8e3a-c3ced9dca096	6056aee0-dafb-4cbd-9dae-aa7ae4bc72fb	5a9b9ff5-6bae-443e-af1f-c281a161e786	PRINCIPAL	t
2eaa85a7-b2c7-4ea8-8b08-77253b917f3c	f44cbcc2-1c43-4f6c-9c38-57c7798486a3	5a9b9ff5-6bae-443e-af1f-c281a161e786	PRINCIPAL	t
17b17f0a-a0a4-4b3a-ab5a-ecd3784d1b60	959dec93-e66a-4e53-8cb6-7cd28ae95cc1	5a9b9ff5-6bae-443e-af1f-c281a161e786	PRINCIPAL	t
114cef9b-a183-4b58-a973-8914988df3a3	c7fd4243-db15-4b14-87a0-94ae8b658cc7	5a9b9ff5-6bae-443e-af1f-c281a161e786	PRINCIPAL	t
956503bb-286e-4609-92e8-2850d5af571c	145c1418-485f-4d15-b5dc-fdeea50bc2c6	4656f2f8-9b64-464a-ba5e-4ba98c4d241a	PRINCIPAL	t
57bb963b-2e0c-477b-b0f5-5273efdbab90	93511c14-b921-4235-b978-bd034e1d52a5	bb9859bb-8ac2-4068-88f4-a742d7d79f44	PRINCIPAL	t
c1b768d4-ab3d-498a-b033-0791ca93bff2	978f461d-b3b9-49ac-9676-6d781c9300a3	c253e74a-9b43-495f-97b3-a90aad69da92	PRINCIPAL	t
c9dcaf92-5f19-4ddb-a3e2-cb1b663e429d	d8b62d2e-747c-4221-a3b9-c196a3a9e0e0	c253e74a-9b43-495f-97b3-a90aad69da92	PRINCIPAL	t
a7a629a3-e7df-49de-ade0-bcea134c3b0f	c4e72518-54b3-4eda-bc8c-bb7b00cbe52d	c253e74a-9b43-495f-97b3-a90aad69da92	PRINCIPAL	t
e8170c10-dfb1-4c2a-af74-09e4bf026501	c3ede18b-6b02-4c43-816d-599c37591b5b	c253e74a-9b43-495f-97b3-a90aad69da92	PRINCIPAL	t
45d676cc-bae7-4175-ac29-4b4604340514	e1cd8cb5-6032-4c29-b17c-cd82832e853e	8944792a-e053-42a2-a5b1-d52f47d4ad14	PRINCIPAL	t
387872fa-f095-4a75-9d8c-836105899924	6e043d2b-0539-4991-9f48-732f3518b71e	8944792a-e053-42a2-a5b1-d52f47d4ad14	PRINCIPAL	t
8ab57d32-1135-4841-849c-67221daa2b49	ea3c1323-6960-4c99-949b-efec8e5bfe12	8944792a-e053-42a2-a5b1-d52f47d4ad14	PRINCIPAL	t
1f47c20b-6456-4160-bde5-0c533cd2bfca	a6633bff-84e2-4d08-a538-28fa5d9f1d4b	39fe34fd-531b-4cea-a5f7-266132181fbc	PRINCIPAL	t
bde750b9-221c-4715-bfe1-1fee6ab23bfd	4bc7e07d-1222-4aa8-9928-25fad21b4fed	6e35ae78-39ea-4a6a-a0b7-9787969f7b3f	PRINCIPAL	t
ff026806-23de-4085-892f-59d838b4e187	7a3ee81f-b742-4bf1-84f7-ada6275d0cd9	5ba8b4e9-0443-4b42-941e-c22331c326bf	PRINCIPAL	t
a6027359-4766-4181-8b92-41b30e177e33	d9aeb74c-489f-4800-b305-c29a6c7ae098	331665d3-483f-4651-bfbd-2d6ee49c633a	PRINCIPAL	t
1d6c4362-2652-4c5c-9263-bfe6cab1d581	ade02139-6bc4-4eaf-a3a5-d41fd4282a21	b987eba0-d18c-46a1-aeb5-a0e202f3c4f0	PRINCIPAL	t
6feb1499-0c01-4d68-8d62-f42e3cb43727	9667af8c-d16b-4f5e-b33f-7efc6fead0ab	068fb09e-8b5e-4ed8-a4ec-2e953c1128bb	PRINCIPAL	t
26a3d1eb-4a87-49fd-a778-854c04bd0199	b0efe096-bf71-469a-9c3f-fab6891c6b50	35fd7b9c-7e76-46ca-97de-72a2dacec5fe	PRINCIPAL	t
03b57235-de9f-4771-b4e3-476ef9401410	675c799f-0d57-4e06-9001-a1b750bf23af	1d4f6a90-26a1-40ff-a022-454d87df35d5	PRINCIPAL	t
36759845-44fc-408b-8d2e-8d11970e179f	c61e7345-0b04-4a71-b35f-ce014b0b7f75	cd31391e-689d-445b-a811-1121c43cdde0	PRINCIPAL	t
bdc817ea-85f9-421f-bfd8-359713b5a9f8	ec2b1072-bb96-45d7-83a2-98b5786f1857	67398676-bcc1-4d56-b18a-27f4599c6dc1	PRINCIPAL	t
8c98e843-8858-408f-a823-d855418d71ad	89a6b527-adae-44fa-865d-eee9ca874439	43586eab-9ed2-4505-a7b0-dd71637450d4	PRINCIPAL	t
1ec647b9-2681-41f6-a2d5-bc270c5d9e6c	8c4c5f9c-09dd-447f-81c0-d87e34e4de71	3a4ad215-8ed5-4caf-a506-ccd72b30b966	PRINCIPAL	t
037d961f-8dcf-499f-9ff4-3b7f838d0003	dd274630-da31-495f-b583-8acd8fe03a20	5fadeb17-1d8f-4006-9aa4-6a8a0d332d90	PRINCIPAL	t
3cbf7b33-ee61-4068-b8de-4e973066b90a	09de1b1f-10c8-45be-a37e-0d5e27ece77a	aa3c098f-6e98-48c7-bce3-25fdccf6b343	PRINCIPAL	t
ac2489ad-8bdd-4151-b856-3834d6b37db7	ee45d198-f6fd-407e-9f0b-d97df5c49b38	7a0c914b-ac5e-45b6-b586-fb2ad2efd969	PRINCIPAL	t
bc150077-f1fc-4a46-acae-4b97fe849772	c270e232-abcc-4ca7-af86-c36fd49c5839	fd4b5bba-2006-4fad-8183-09848a55afe5	PRINCIPAL	t
4e9d9fd0-2ccf-4a14-945a-63d13a3ad3d7	ac994c7e-e0b9-4b59-9e69-48d7f5f6f5f4	5ba8b4e9-0443-4b42-941e-c22331c326bf	PRINCIPAL	t
37710703-1b25-4755-825e-0cbd0b287cdd	f51a948b-dbcc-4e27-8862-7766aad024bb	3e4522fe-7956-42b1-b92b-d227ed3946c8	PRINCIPAL	t
641ee220-06e9-4ec2-911a-32af01bf52ed	ae9c90e9-5f32-4f68-89bb-0f2c3569b6ff	fd1e6b19-e418-443f-b399-53eac06e72df	PRINCIPAL	t
174c15d6-dd29-4a37-8b1b-563f5c875366	7cb5b334-98b6-4ebc-93e9-82a8ab5785a8	8944792a-e053-42a2-a5b1-d52f47d4ad14	PRINCIPAL	t
da9cc074-261f-42d9-8497-d1b484f548a2	ba378bcc-89fa-4dee-936b-0d087ef960d9	8944792a-e053-42a2-a5b1-d52f47d4ad14	PRINCIPAL	t
3507c28a-b002-44cb-984d-f9277d0f1c79	cddba05c-a2f8-4934-8fc0-691c7a7d9279	8944792a-e053-42a2-a5b1-d52f47d4ad14	PRINCIPAL	t
af9d17eb-6d5e-4a61-94bb-e4aa1d9eba7c	8d8b614f-0e62-4a62-94ea-b241bde6cd01	8944792a-e053-42a2-a5b1-d52f47d4ad14	PRINCIPAL	t
9d50110d-3b06-4333-850d-7f6b81297c2f	c87af309-f5a3-4592-ba93-db3716f95da2	8944792a-e053-42a2-a5b1-d52f47d4ad14	PRINCIPAL	t
d0808a2f-9530-496f-98b4-be7db0cd43ae	6fea2b51-9826-4a8f-8541-81d2515d6f5a	8944792a-e053-42a2-a5b1-d52f47d4ad14	PRINCIPAL	t
81fe5b06-2215-4c77-9b41-fad84b669035	287799c7-ac1a-4f79-9c55-f7442b22d160	4656f2f8-9b64-464a-ba5e-4ba98c4d241a	PRINCIPAL	t
f704994f-30b0-4c71-839a-b39a39bc2a0f	524ee95f-70aa-4e05-9a65-4c5a33be761c	6e4d646f-d0ca-4032-9f61-e5c744881332	PRINCIPAL	t
f4f5d97d-d246-4adb-a6eb-6644057e508e	53971757-50cf-41bb-8245-d82028991d76	bb9859bb-8ac2-4068-88f4-a742d7d79f44	PRINCIPAL	t
9c876212-80ac-4795-8cf9-5584af7a73fa	768c69f8-581e-496d-ab38-54f178ad8d05	bb9859bb-8ac2-4068-88f4-a742d7d79f44	PRINCIPAL	t
3d4e2169-5599-4696-b3fd-7308dc454f7b	284d8d30-745e-4744-8b04-c79e294e9141	bb9859bb-8ac2-4068-88f4-a742d7d79f44	PRINCIPAL	t
92bcec17-48fc-42e0-bce1-5411d7044e4f	7b72ce56-5557-4be3-b7ea-11907c6b0735	9dbd39c5-5ddf-457a-9253-f701147ee915	PRINCIPAL	t
96aedd15-d9c2-44e3-88c0-694f127dcb15	0859097c-6fca-4af0-8695-dfe83efcd264	cd31391e-689d-445b-a811-1121c43cdde0	PRINCIPAL	t
d6d2c16f-31e9-4521-aa33-4b225a5cd508	ce1b86fb-7580-4419-a866-342257b7a6a9	78e01ded-85a2-4ba6-8359-c23cfc30653f	PRINCIPAL	t
89c7089a-7d28-4fbe-b89e-8045f2258aac	a24dffb2-b723-49ee-90db-e1e52aa013d6	39fe34fd-531b-4cea-a5f7-266132181fbc	PRINCIPAL	t
75173b00-3e30-4405-8345-3eb76f41beae	0c0eb192-55c9-4b38-86fd-b41dc2e56a88	62b28318-fb31-4213-afd9-be57f0dad135	PRINCIPAL	t
a2f8384f-699c-452e-8470-632cbca864b4	dca291cb-952b-4998-85c2-d54db32b4040	62b28318-fb31-4213-afd9-be57f0dad135	PRINCIPAL	t
badae2b2-da3e-4000-b6b5-118912ff8dde	56734563-2a3c-47f7-9e39-5e532ca2eb9f	62b28318-fb31-4213-afd9-be57f0dad135	PRINCIPAL	t
db43bb89-75e0-418e-9084-117589617b77	7aa0b74f-8c92-4c74-a9e8-7e005904040d	62b28318-fb31-4213-afd9-be57f0dad135	PRINCIPAL	t
4dd0f6c4-3c84-43d0-b24e-5eb2f79782f6	06436cc7-fcf5-4f72-8024-7440f7078a8f	3cc25630-1294-4ac7-bdea-9a0b0e63f608	PRINCIPAL	t
9fbe9398-95f2-4d38-9d5b-3e8c4b581a79	6b8cedd6-4db5-4979-b80b-5990e4ee3018	35fd7b9c-7e76-46ca-97de-72a2dacec5fe	PRINCIPAL	t
a4152b8d-790a-4748-82de-b0811d3fcc8e	a6e0205e-2f22-4947-88b4-9cd3c8420aa0	35fd7b9c-7e76-46ca-97de-72a2dacec5fe	PRINCIPAL	t
062cfe37-924f-47df-807a-4dce0e0b452e	fd325b18-9079-47dc-936b-75fce41725c4	35fd7b9c-7e76-46ca-97de-72a2dacec5fe	PRINCIPAL	t
7b6682a6-7229-4261-95f0-96a99796a982	8a6536cd-2e16-42bc-a6b2-d7f87c48ef84	35fd7b9c-7e76-46ca-97de-72a2dacec5fe	PRINCIPAL	t
b4d99587-04a8-4b79-8583-ebc3be0ebb11	4d2dc578-7661-4e1e-81b8-81b8f3808b1a	3e439fbc-273c-4c12-8a9f-bea34cd03fd5	PRINCIPAL	t
6c1d729b-5fbb-4c1b-81b7-afaa0f4a0320	d39211b4-2d1b-4699-b129-ce6051725fbf	3e439fbc-273c-4c12-8a9f-bea34cd03fd5	PRINCIPAL	t
f3c8dd83-f506-4a2a-a4a3-e94d3851a692	3d123be1-cc20-4af8-9751-f7e1a8a0c4ab	2508aad7-5219-4d58-b200-1750f1d0e414	PRINCIPAL	t
3ac8e441-43a5-450c-8947-8a6860f5be37	ca75f68a-4e2a-4703-bd5b-f8714360762d	331665d3-483f-4651-bfbd-2d6ee49c633a	PRINCIPAL	t
dc34b7f8-ce53-49b2-afc2-94c4bae9b715	cf89eb6e-0b6e-4d44-a842-17d2a26bfa08	5ba8b4e9-0443-4b42-941e-c22331c326bf	PRINCIPAL	t
9a8dd8c0-7ce8-4bcc-8eb2-b16ed12cef66	572d9679-d95c-4b76-bf8e-659081288fab	2508aad7-5219-4d58-b200-1750f1d0e414	PRINCIPAL	t
3d3640b1-d0c4-4bc6-8bfe-286c49d5dae8	ed705977-bd99-4f91-9027-a48c3ec47c3e	068fb09e-8b5e-4ed8-a4ec-2e953c1128bb	PRINCIPAL	t
4f7bcf62-ec00-4055-aa3b-94fa66d017df	cc43423f-43fc-4218-bd0b-b443bdf91f25	e9ecccbe-4f88-46e7-bb58-1fc6e64ba9d9	PRINCIPAL	t
96a7f176-8348-4910-9934-2fac1d4ed73a	80142014-4296-4872-a880-416f8f88da28	65245a74-c651-43e7-a452-834c8eac5286	PRINCIPAL	t
6cdffee4-3b8d-47df-9fe7-2fe51eb26178	65bbe3eb-6f48-4e0f-b674-6f035639305d	9dbd39c5-5ddf-457a-9253-f701147ee915	PRINCIPAL	t
bbe118c7-1a01-4e0b-b5a3-da5edfbaf3c3	7f764a0e-0087-4758-bdaa-d2197d3e8082	5a9b9ff5-6bae-443e-af1f-c281a161e786	PRINCIPAL	t
f6c77085-8bed-49ea-a430-9a7a212b9b2e	801aafe0-0047-44a3-a1e4-366afafb475a	67398676-bcc1-4d56-b18a-27f4599c6dc1	PRINCIPAL	t
e448e58e-96b2-4873-a030-4a5b54e8f2d2	e02cafd6-648e-46f4-9189-97d334c33e89	a999ce6c-c29b-432d-b84b-9941cac7c2e4	PRINCIPAL	t
3d1347f0-8e25-447c-b27b-9d68ff2ab6fb	65222668-28b8-4f88-932c-134abf1d37d3	c253e74a-9b43-495f-97b3-a90aad69da92	PRINCIPAL	t
ca5cb3a4-c9dc-4031-bf9d-e67896c9264f	aaf151a5-f2d0-4e41-8a7e-463bdb12da12	89ab21a3-3a48-4966-b171-8139fc8deb99	PRINCIPAL	t
406496cc-5dd6-4ca0-ac3d-3556f4307844	3270da83-ed9b-4eea-ac3e-3468a09b5113	43586eab-9ed2-4505-a7b0-dd71637450d4	PRINCIPAL	t
8356f32a-9cfe-4b34-a68e-b4dcd694255f	c3443582-e8d7-40c4-989a-108e4839ac33	d87a24c3-5eaf-4c46-8714-e37a5c25a4d2	PRINCIPAL	t
3831fc57-d2f8-4dfb-9ddc-eb4d7a3acac9	0b769e8f-7ceb-4821-80c5-1e68e642d51b	d4a1248b-9a2b-4366-9968-1ebfd115ac13	PRINCIPAL	t
7a73cdab-f202-444e-bdbc-2c120f90544b	ddd87fef-d4d9-4b34-b84d-44cc48c68831	43d485ce-503d-4c51-a1bb-a7fb53cac3c3	PRINCIPAL	t
b206aafe-546c-426c-8686-819f865ad16b	a1b76c22-d065-4d53-a524-452eb19d4b68	922346c8-0235-4b56-bb66-105f66d43e8d	PRINCIPAL	t
3b8c5513-3253-4c38-9f3f-b33d9af5e4d7	06ac21a0-17e3-4811-b9dc-e2b3b39d31e8	fd4b5bba-2006-4fad-8183-09848a55afe5	PRINCIPAL	t
24035938-a8b6-4a78-82da-1fcd5dc4bdda	eb9cf714-6818-4bc6-92fa-33963092ead5	65245a74-c651-43e7-a452-834c8eac5286	PRINCIPAL	t
8a24bb5a-e3c7-4e89-9e41-cc5c0e4541e1	353824c3-0e21-44e0-9090-6cb6969369b0	1d4f6a90-26a1-40ff-a022-454d87df35d5	PRINCIPAL	t
76ce695c-e5dc-49c9-bf09-012db0e4dbbc	c77f34ef-7a6c-4e60-9139-db97d6d4199f	0a77beb1-b7de-4cb6-97b2-6b60cefd4a2b	PRINCIPAL	t
585239f5-5e0a-4ed8-8091-84b71e8de9a8	442378c1-1fa6-4845-8c19-25553ac4fc2b	1ad358c9-3973-4e03-9a19-89d00b66b1e9	PRINCIPAL	t
\.


--
-- Data for Name: mareas_movimientos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mareas_movimientos (id, id_marea, fecha_hora, id_usuario, tipo_evento, id_estado_desde, id_estado_hasta, cantidad_muestras_otolitos, detalle) FROM stdin;
c58c2c0d-8a95-4df1-b98e-0ee3c6834e3e	1b96ca55-5d25-4d4f-b195-e1e303416e71	2026-01-03 17:21:34.281+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
86d810e3-36e1-4798-ac5d-f0d6a22277e6	b22d23b3-b507-4d09-9b5f-bc97f8729557	2026-01-03 17:21:34.298+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
b0f74ad2-75f3-4997-9aaf-cb59fb9aaac6	9143ae67-1fdd-4056-b8cc-da9ae96521d8	2026-01-03 17:21:34.308+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
d8eaf1ba-68c8-4b0b-87e2-9cd5d7a2a6cd	e8856ef7-43e1-4173-913f-431da83c7ab2	2026-01-03 17:21:34.318+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
c84ed145-c1a2-42b4-ab9f-72773d3de1ee	e87e2e44-9503-4f57-9293-250d3fef1b2f	2026-01-03 17:21:34.329+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
da5c5388-5e29-446e-b609-d7583ed27f3d	d4242dce-a30d-49ba-bd05-202e5381aa45	2026-01-03 17:21:34.339+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
9006552f-0c00-4b5e-92a0-2d85d5d3d0bc	8ed765a1-5a4d-4ecc-ac3c-1110020f1e67	2026-01-03 17:21:34.349+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
0d2f4bf3-6566-4eef-a537-b0d974d851b1	74aa850b-8f32-461d-90a1-40667e073e81	2026-01-03 17:21:34.358+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
8468cfbc-56e7-4f11-8281-08dab9bdc01c	a06d3da0-1d1e-4719-a52b-08c7e4a19c7c	2026-01-03 17:21:34.373+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
0209688a-df1c-4981-9b26-97d851db9dd5	19e60f5b-b31c-49f7-809d-5735ad940ce3	2026-01-03 17:21:34.382+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
96d985b2-c2cd-4019-a0a0-b2f6446235f7	0f138d55-65fd-4c97-b087-430dbaa82da1	2026-01-03 17:21:34.391+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
2adaa123-5eab-4037-92d9-1810818b3ca0	bfaea882-ab97-4e3d-af71-8fd699abf4b4	2026-01-03 17:21:34.4+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
bb3123ac-3ca3-4e5e-b7cc-b63d44bb0ef2	85adba53-6a2c-496f-9af7-b254a993e62e	2026-01-03 17:21:34.41+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
dc66a1ab-29fb-47fe-9b6d-78cab3430eda	0c9d7f1e-c9a1-4dcf-be69-b75695b73028	2026-01-03 17:21:34.418+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
3204beb1-ff25-4293-b427-2a0e59188871	c9e228eb-04a5-4323-807c-10552768c1aa	2026-01-03 17:21:34.427+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
cb5a9888-9d11-44b4-b0ec-5bb30be5de6c	307a8442-afe6-40f6-a83a-9913e40e06f8	2026-01-03 17:21:34.447+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
80172d2f-041e-4c32-92bc-faa0bb57ecce	df130265-b15f-41b8-af75-f059f3d1c67b	2026-01-03 17:21:34.457+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
64b144a7-7060-40fb-82e4-aa770cd9d9d0	dc7d7414-7b99-4594-8c9f-0c4e2acdf934	2026-01-03 17:21:34.466+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
fedddf5c-eee0-4a4c-820c-da5acc003040	3d07eaaa-4f2d-4943-8b49-6b68c98acf6e	2026-01-03 17:21:34.477+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
103f67c7-57bf-4334-9f3d-ec4db2af81e0	2f88c725-e51c-4fa7-a41c-181de9d2c31b	2026-01-03 17:21:34.486+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
475fbcb3-e75c-45d1-a93f-ab35892732c8	fc76dc57-7d86-4bf3-8975-86cb0745896e	2026-01-03 17:21:34.496+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
7c2413cc-fe59-4159-b05c-d80163826359	637b72e8-7cd2-469a-bc09-6436c4036fc6	2026-01-03 17:21:34.505+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
11908401-c8f8-4f0d-b482-e7766ea41157	45e7b82a-95cc-4504-885a-0ba429ebd302	2026-01-03 17:21:34.513+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
c6354f68-3888-4611-a08b-77925c684627	d4770b46-93e5-450e-a14a-045e3c55921a	2026-01-03 17:21:34.525+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
ed535a53-e00d-45cb-974c-8b80d2ccb868	dba672d1-635d-4764-9419-236dbca7597e	2026-01-03 17:21:34.535+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
dd5d571b-4772-4734-b401-1a8b5f8aa993	81a14f82-6b0c-4a54-abc5-96193b76b47e	2026-01-03 17:21:34.543+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
113a0b61-4fac-4871-be7c-276ce7f04e68	2fc9e671-484e-44e7-8813-bb49719b6810	2026-01-03 17:21:34.552+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
31cab2aa-311a-48bc-9d82-5bc25c3cc004	d3b9174c-5b99-44fa-93c8-9963972a4d85	2026-01-03 17:21:34.561+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
ab534522-7812-4194-adc4-96902d36606f	59e31b81-9861-4563-9a9a-0f49b531654c	2026-01-03 17:21:34.571+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
e2424658-8859-4ec6-8f6e-611b35485e92	87e3d15b-9ea9-4d71-8bf7-d1e61505b3bd	2026-01-03 17:21:34.58+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
d6df3bed-a4cd-48ed-954b-331326bcaefc	ebd84e62-d379-43a1-85c0-2d8657bf0ee4	2026-01-03 17:21:34.589+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
de430bce-5f87-4671-b374-60245ba34fdc	fcdec828-7006-4999-9c51-6c86ee7f27e8	2026-01-03 17:21:34.598+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
ce6b2f2d-7457-4dd3-b7e6-ea32959dbe0d	d3c77501-42da-427a-bba8-4900e1ded32a	2026-01-03 17:21:34.607+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
f830dcd1-0dd8-4416-924a-122572f5db13	5293a45e-c905-4705-a9d1-b35b2b90ab6e	2026-01-03 17:21:34.616+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
39414c73-48fc-41ae-8c5c-e9860c24b01e	87494f91-8145-46d8-bb6d-a138d3212bda	2026-01-03 17:21:34.624+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
ba3fffd0-34dc-4dfb-849e-e09ee27d421d	2fd183a7-a9c2-4424-abc7-87f31dde60d4	2026-01-03 17:21:34.634+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
3ea9fd3f-805d-42ee-86da-ea606a205e17	c1e2b8ec-4cf9-4588-b1a6-f98fcd8205cb	2026-01-03 17:21:34.643+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
6c208f04-e69d-4a74-8669-cfd2b3ad15bb	e170ff4a-5d24-4e6e-8eff-379c2233e544	2026-01-03 17:21:34.651+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
765de380-f291-4ba8-8d2d-3b763a945e56	645d9c0d-6287-4893-907b-cdec6037c93e	2026-01-03 17:21:34.66+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	081d416b-af3c-4c1d-a2db-3525f5db5c36	\N	Marea importada de seguimiento 2025 (JSONL)
ccd648ce-7295-4ed0-85a8-985b38dcb3b7	8131a5ea-08f0-43db-92e2-6199a41f8fa1	2026-01-03 17:21:34.666+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
7529f71f-be1b-4b6a-8b28-b6b18c8142e5	a64c5389-8b8b-4799-b34e-7a2c179ae9d1	2026-01-03 17:21:34.675+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
b7c0651c-a287-4c33-aa49-a419f4a4dcce	ab8a5193-0b12-4733-9e00-c7030ca1d065	2026-01-03 17:21:34.684+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
639c45ff-0ab7-4a76-9ec5-d36a41e1c57a	1800d269-7400-4661-b9ee-9bb1b1d5a5cf	2026-01-03 17:21:34.695+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
bd49e541-dfd8-453c-9ff5-efae050c8e9d	d87a8412-71c4-45f4-9483-177e6772bff3	2026-01-03 17:21:34.706+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
39f399bb-2d01-4c3c-a11f-b5b219a9e472	60163f5c-4b4c-458f-b707-c6e58a21d86c	2026-01-03 17:21:34.716+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
7acad6f2-52a4-4ca3-ad2b-faf568bf20e0	6c571f5a-ef1c-4f4d-b570-975cc846e825	2026-01-03 17:21:34.727+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
2dc29b18-6178-4ae6-9ea8-dd397dbbc788	c7d13c76-8742-4204-b0a1-ad17e98110ee	2026-01-03 17:21:34.737+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
0af8e850-1f01-4526-a23f-30894ca61e52	aa253bbe-f038-4f47-bfb9-b8aa6ec8c959	2026-01-03 17:21:34.746+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
4f54ea6f-6298-48de-b3fe-401e34be12e0	9563ce8a-6958-48a9-9a5d-0ec2d7eb9bf5	2026-01-03 17:21:34.755+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
f30fbb15-ee83-44bc-ac27-59274b4061a7	2572f21d-491b-4ed0-9f1f-f72627e617f8	2026-01-03 17:21:34.763+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
35f5b7a4-7ce2-4002-afc7-32bc8844776f	4aff51a8-fdb7-4e96-821f-b4e1617a72f2	2026-01-03 17:21:34.773+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
dc0c988f-a1b9-4067-9bd4-7b432372dd98	619264db-438e-4bdd-9544-8a4595d9cbae	2026-01-03 17:21:34.782+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
85e04020-5088-41e2-bc42-d0625c4ba296	68f9a3a6-61ba-417d-aec6-745e942d6f9c	2026-01-03 17:21:34.794+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
a75e4e29-f96f-48b6-a3f7-d18712d8896a	ad035c1d-4b90-43bd-abed-6eed873f2bb9	2026-01-03 17:21:34.802+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
cc37fe18-3037-484a-8f8f-ff2ba005cae1	cc5eb69e-6e1e-4297-9b13-7848bb38f572	2026-01-03 17:21:34.81+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
638e2dfd-ec72-4faa-bf85-38326b34a3a5	1780fcd8-c848-4a22-86a2-6b6e2e809a9d	2026-01-03 17:21:34.818+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
8da85779-cf64-48ca-805c-e1ed09556c5f	b5d4e4f9-2839-4f34-a2b4-6ee91efde858	2026-01-03 17:21:34.825+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
0ec7f292-ea3b-4364-bf61-a5efae1bd488	12ba51db-a35a-4849-8a2e-98978b0115b4	2026-01-03 17:21:34.833+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
96a4f670-e91d-4be5-bf90-7ae1d57e8140	9d2c0639-31ca-43fa-927e-a5dfb270cea1	2026-01-03 17:21:34.84+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
64c9b6db-ca85-4d5b-a299-9222df9f05fa	ec689725-c1b6-4a8f-a879-ae61a9c189dd	2026-01-03 17:21:34.847+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
fd226510-59d4-442f-ba7d-462cb95d2434	84faeb38-ffff-4311-b37a-5e6386304f30	2026-01-03 17:21:34.853+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
9a00d60a-f00b-4d9d-87a5-cb9c55c0ae57	a930beef-a27d-47cb-a3f3-3aa11a6110df	2026-01-03 17:21:34.861+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
1e8d71a1-018c-4536-bf84-d6ee7a581aaf	422c60b2-75be-4b6e-980a-4f76c36016a2	2026-01-03 17:21:34.868+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
80e94295-4931-46bc-a2ea-1667c1ff1160	3ffaa44e-b3c8-4121-a457-1173121dd3f7	2026-01-03 17:21:34.879+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
77fb2548-f5b5-4793-916c-449af0d1aac9	e7b08c67-748f-4a22-898d-2a890e5a35ab	2026-01-03 17:21:34.886+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
efa63c50-9a88-4641-b68c-b962f902e452	856b8a70-51e9-4718-b68f-b687e83d0425	2026-01-03 17:21:34.901+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
c6c27af9-1c3a-4e3d-a383-7a95af100416	3684f797-79a9-4cb2-b326-696b7c0ef365	2026-01-03 17:21:34.91+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
3dcc6939-3cad-4c66-b657-0b7495cf4e5d	3002074e-8d09-4956-ba16-1b65f7eb2ce7	2026-01-03 17:21:34.917+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
fa6396a7-c3f3-4d42-bd8c-fe2f02224133	09118173-ca86-43a2-81c5-62ff82a8db78	2026-01-03 17:21:34.928+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
13e0d84c-048d-419b-828f-71526cc95c0d	3e309bb1-041d-4a61-bd36-bba980ca60f7	2026-01-03 17:21:34.935+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
92a1272e-07e3-4eb0-bd41-f9b1ac762c87	7ea29288-647f-42b3-a218-3dde8200bfa7	2026-01-03 17:21:34.945+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
a47f4bec-6a75-43ae-978d-d2d5fefc6559	35544167-6977-40f7-ba1a-07b135e64236	2026-01-03 17:21:34.952+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
2b4ddac2-509b-433b-b85a-bf97d27ab9bb	fab442d9-b253-4f60-8e1a-459dcd40e213	2026-01-03 17:21:34.96+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
8d5cf40b-2ed1-44ea-9ed3-c1855a0d6cea	de28daf8-b209-4635-8035-5864d2d63219	2026-01-03 17:21:34.973+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
8a9b2fc8-33c3-4c31-a710-fa56da0073de	200a2332-e2bd-4da7-890e-9a55e128449e	2026-01-03 17:21:34.98+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
f1666e2d-f042-4a40-95ae-2c8d24aea0c9	aaa6a72d-ffa9-4176-851c-a595c5010ae8	2026-01-03 17:21:34.986+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
47c857f9-e6fb-43ca-9d65-9581a7db8f6d	f41dc2ec-d08f-4571-9878-8f3c8eb53dbe	2026-01-03 17:21:34.993+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
ab1904b3-9f2e-4244-bafc-d22e9cfe9adb	b2dd8dce-929b-4342-ae86-bc34b4af1ad8	2026-01-03 17:21:35+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
60ac837f-e2d7-449a-b2f8-28a987ebc4c9	63fccc66-9abf-403c-9599-b82a48710d67	2026-01-03 17:21:35.007+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
c1ce9baf-2160-42da-9bd4-5cc7bf274b5c	6d865537-c61a-410c-915b-2ac8e24ba9ad	2026-01-03 17:21:35.013+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
0db5e26f-5b21-4788-bd4f-aa3dd24d6b28	9b984f08-2fd5-4554-81f0-6ac693c7220e	2026-01-03 17:21:35.019+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
1114c4a1-4f6d-4014-a2c5-131d34d72c15	667ef67d-79c0-4a0c-b825-53f32a0cfba7	2026-01-03 17:21:35.027+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
0e546b7f-537c-4b98-95c4-5c72d54097b4	ee516229-0f07-492d-92ce-ad48ec42dbe2	2026-01-03 17:21:35.034+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
d0b4c8a4-629b-4d64-9836-7f1ef0445023	87cc6c0e-7bf7-472b-98b3-cfc46043114e	2026-01-03 17:21:35.041+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
ad556f83-5d2a-4e5d-b5cf-8c1d83d18758	ff6c9466-43d8-42ac-a3aa-e6d4f8ea68ad	2026-01-03 17:21:35.049+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	081d416b-af3c-4c1d-a2db-3525f5db5c36	\N	Marea importada de seguimiento 2025 (JSONL)
f7fc87e4-ad60-4d5e-a356-07f4e1818743	b45e3b51-67dd-4fa9-9a2a-c3260f55bf30	2026-01-03 17:21:35.054+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
5779d0ba-a0af-422a-b4ab-792fed45bc11	f923d047-ecd0-4deb-a466-e693d90084e5	2026-01-03 17:21:35.062+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
4a667048-01f1-4452-bb9b-f0880143f983	403aeda4-fd23-458e-83d1-cc092754265e	2026-01-03 17:21:35.069+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
e196fc80-eef1-4bc4-ad56-9c1607b98db1	8dc26729-00b4-4da1-ba63-ab0dd4baf5bf	2026-01-03 17:21:35.075+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
de86717f-aa07-4102-ab69-0051a157f1b1	685172ce-7671-441d-959e-79f01bf727ca	2026-01-03 17:21:35.082+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
b53e7dd4-c954-4eaa-97f7-dd5ce141b51f	10e8da42-a01e-4169-bbf6-ec4548bcc2f7	2026-01-03 17:21:35.093+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
7b187662-a7fc-4723-a5bd-99fb85d527a1	5f7d74b6-4d31-4ca7-afae-74d30f5c600a	2026-01-03 17:21:35.103+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	081d416b-af3c-4c1d-a2db-3525f5db5c36	\N	Marea importada de seguimiento 2025 (JSONL)
2f66d46d-4024-44d3-88ee-96cdb8bdd8ff	0492626d-b4c5-4fe2-9bdd-1fd02b3c8a32	2026-01-03 17:21:35.107+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	081d416b-af3c-4c1d-a2db-3525f5db5c36	\N	Marea importada de seguimiento 2025 (JSONL)
acaa8be7-1593-4b2a-8fe4-4ed8135f3326	1b74e2a7-70bd-4549-ba41-87bc5f724575	2026-01-03 17:21:35.112+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
4f6d32cf-d7bd-49e5-8b9e-71d29c61fbc3	15cb7ab1-9781-4847-9a53-d334f89db880	2026-01-03 17:21:35.126+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
e46e8214-86af-4edc-929a-46b4ea00753a	dc46d9af-3591-4a9a-8b3c-45e0f7ea68a8	2026-01-03 17:21:35.132+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
3f79a9e3-2960-42c6-a24f-0bf98cb69872	103dd1d9-6b45-4da0-9574-b8cd63b457ec	2026-01-03 17:21:35.139+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	081d416b-af3c-4c1d-a2db-3525f5db5c36	\N	Marea importada de seguimiento 2025 (JSONL)
b74a875a-50b2-49a0-80e2-ba7d83b40b69	cc3f6247-b010-4188-a325-1bc32f5761d5	2026-01-03 17:21:35.144+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
991c5bf7-cd9e-4d61-b360-d152aa282b14	e59df295-88ed-4f1d-8562-7d08031e59a3	2026-01-03 17:21:35.15+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
73cad6e8-6d0c-44b8-9965-31988f47ca8c	d5b3d85f-f833-4928-8308-9b690bc69705	2026-01-03 17:21:35.166+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	081d416b-af3c-4c1d-a2db-3525f5db5c36	\N	Marea importada de seguimiento 2025 (JSONL)
f2adc64b-d204-4509-8775-456ee769864c	839e302c-a597-4df4-a058-d14d8dbcc63e	2026-01-03 17:21:35.171+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
337db316-ca35-4f5d-8f8f-e5ef3371e7a8	adf22815-c33d-41c2-99a1-df4f4fcdf964	2026-01-03 17:21:35.18+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
c38b8f7f-3f3a-4776-a899-e54c0b4f2db6	54dbd5e2-12b2-49ff-a252-d608e6de12be	2026-01-03 17:21:35.187+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
7ca8cd72-415e-418b-a4ef-19b0444662f2	222beb76-8251-43c2-96b1-040eb3d62d2c	2026-01-03 17:21:35.194+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
1945be4e-08bc-435d-8d0a-f86c814c02a6	ae1e0de9-959d-40d0-a4e7-fe297d4278cf	2026-01-03 17:21:35.201+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
cecbc541-88e4-4cda-b827-4182db6c0f17	24318725-7a21-4a9f-ac39-7ad93ef21a9e	2026-01-03 17:21:35.208+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
ec9c7d8f-6a29-4e1c-b0f8-f9073838bc3f	d95e430e-2b2f-4b2d-97ce-f08c148a0980	2026-01-03 17:21:35.216+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	081d416b-af3c-4c1d-a2db-3525f5db5c36	\N	Marea importada de seguimiento 2025 (JSONL)
d1713cea-5fd6-450b-b7cc-c46d61c18d01	5aa25b11-e231-4a6e-a3a1-116334ab0772	2026-01-03 17:21:35.221+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
8f8fe30a-201c-4e75-8095-74787c8693e3	9079c6c5-3005-42e7-8679-c458d95c9d11	2026-01-03 17:21:35.233+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	081d416b-af3c-4c1d-a2db-3525f5db5c36	\N	Marea importada de seguimiento 2025 (JSONL)
727cef05-23a3-445e-8c52-b91a2a5770dd	cc3cce6e-9657-4dd4-b786-ed0c33ee23f0	2026-01-03 17:21:35.238+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
e226a60f-5825-4bbe-9b08-6b029ce18574	bc42f4c4-c5ef-4959-a179-73c5ef65f857	2026-01-03 17:21:35.244+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
36398220-40f1-41b4-b7c1-a5b5988e89f3	a45428ce-a312-4138-991d-0143bd917616	2026-01-03 17:21:35.255+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
a725e472-9a71-42b0-9cab-b1ca17e6bb0b	c55d9b8f-3391-4f0d-8d29-988bb5e78eef	2026-01-03 17:21:35.262+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
45b9503f-5547-40a9-b2f9-6f38d503f992	271db235-d1d1-46f6-b276-09a8c5bb58a1	2026-01-03 17:21:35.273+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
a9aaa4e6-4e72-4ca2-8c78-b44e0fa4835c	0b421289-58d3-4fec-a4cf-a1a6acfdbfb0	2026-01-03 17:21:35.28+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	081d416b-af3c-4c1d-a2db-3525f5db5c36	\N	Marea importada de seguimiento 2025 (JSONL)
5c6a6527-6434-4982-b119-ab4c7ee150dd	9bb5bcd9-ea49-445d-b1b3-bfb793d8e819	2026-01-03 17:21:35.284+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
0f2c8722-c642-4e4e-ab0c-3deefacd25d1	df531ff6-671c-4e34-bace-c43036c4dd83	2026-01-03 17:21:35.291+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
a1cbff75-0390-44cf-8a4a-544b3e9b4d7d	575b01a8-9475-4f8a-8ddc-f6977e3e6a60	2026-01-03 17:21:35.297+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
591af17b-c22d-44b5-a6ad-569659911b5a	9f2d46f2-19ff-49de-a8da-40d8fdda0063	2026-01-03 17:21:35.304+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
0c114cbb-ba03-4132-ada9-26de33b2ac3b	1cc6ddfd-ab7a-45d9-9518-83bc016b844f	2026-01-03 17:21:35.31+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	081d416b-af3c-4c1d-a2db-3525f5db5c36	\N	Marea importada de seguimiento 2025 (JSONL)
dced4441-d0de-4754-8e0f-260a077ab430	e45f4d38-3c4d-4e1f-a27a-81d86d06be29	2026-01-03 17:21:35.314+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
f636a3dd-4240-4fcf-ba3f-52b5f768e3bb	ae273e3f-ec3d-4efd-98e9-0288a3c73e54	2026-01-03 17:21:35.329+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
b83061fd-d56e-48d7-87a7-0f29966dab8d	32851f3b-ac62-449a-b6ec-ff7aa7e686fe	2026-01-03 17:21:35.337+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	081d416b-af3c-4c1d-a2db-3525f5db5c36	\N	Marea importada de seguimiento 2025 (JSONL)
a4574f37-01f3-4c58-a974-3cd86e2af716	1b8bfd91-7564-40a3-a292-1294175086c9	2026-01-03 17:21:35.342+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
ce6d3637-6445-4327-9d94-fe50ffea4486	877056b7-630e-4fba-a378-1e4f2d9ae78d	2026-01-03 17:21:35.348+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	081d416b-af3c-4c1d-a2db-3525f5db5c36	\N	Marea importada de seguimiento 2025 (JSONL)
f7f58eb1-bc2a-4f72-bf24-a9705bbcf42f	984f35e8-99c6-4782-8641-04aadf0e5e01	2026-01-03 17:21:35.353+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	081d416b-af3c-4c1d-a2db-3525f5db5c36	\N	Marea importada de seguimiento 2025 (JSONL)
c3ff5a7d-373f-47a6-8a67-ab6d889ad726	db83da74-e00b-48a6-933a-c084d1b9e1f8	2026-01-03 17:21:35.357+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	081d416b-af3c-4c1d-a2db-3525f5db5c36	\N	Marea importada de seguimiento 2025 (JSONL)
59a9ae57-d310-4327-b4c0-df69f4cb4efc	92efeca5-7164-454c-b684-aeb9b1efb613	2026-01-03 17:21:35.361+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
afd25773-311a-47a3-a00f-ea137daf96d2	5ecf438b-b6dd-4f77-94db-9af206c161f9	2026-01-03 17:21:35.367+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	7686e133-c020-4217-b227-43529e1a6d06	\N	Marea importada de seguimiento 2025 (JSONL)
2ac5bd78-fee7-46bf-9b5a-00b5adc81e52	4da89d1e-1a25-4096-9ecb-dddd570862ea	2026-01-03 17:21:35.373+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	081d416b-af3c-4c1d-a2db-3525f5db5c36	\N	Marea importada de seguimiento 2025 (JSONL)
cab3afed-bec6-42c7-8f86-218dddae2851	79fc2a77-8d70-4eb0-94db-3264792097fa	2026-01-03 17:21:35.378+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	081d416b-af3c-4c1d-a2db-3525f5db5c36	\N	Marea importada de seguimiento 2025 (JSONL)
f170f4f6-4f91-49ec-8bda-a43ed5557970	38ff5eff-3550-4cf8-b8dd-202a09ed77ed	2026-01-03 17:21:35.383+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
114e75fb-48fa-42da-a016-9a077e2f10ed	1d268299-d910-480d-ae58-7fa550b4d388	2026-01-03 17:21:35.39+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
7027b996-32b0-407f-9bfb-648a06b66ebe	6a7326b6-9ba0-4978-94be-7a711d673ab8	2026-01-03 17:21:35.397+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
743cf945-33d1-4027-a2c3-e65979b4a1bb	bb30f796-0e80-42e3-9b01-5af52531be46	2026-01-03 17:21:35.404+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
fd4136ca-c867-4d87-b76b-a7c72aa96e21	e02a256a-0717-4e29-85c5-98f63ef4c36e	2026-01-03 17:21:35.417+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
13dcac98-c44b-4244-b5e3-6610dc225927	0bbf48d0-b7a3-4844-8d21-4d1022f0407e	2026-01-03 17:21:35.424+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
e7ffa2c2-69ab-4a8f-8e89-981fe1c8bc35	c0925a32-18a7-4c54-bab7-40c9500222a8	2026-01-03 17:21:35.43+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
b3ddeb43-a584-4f94-8e4a-eb412e40cf59	929932c1-baea-4ff5-bf11-6f3b378140ea	2026-01-03 17:21:35.439+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
8539a388-c784-44f5-b991-e46a45dfa7d6	3ceabac2-76bd-49d8-a5d4-a673f68f3b54	2026-01-03 17:21:35.447+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
e5f37d8f-6b43-410f-b2d2-dac57973041b	72b618ec-e398-49ab-9eda-c1f9d779c15f	2026-01-03 17:21:35.453+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
07e65300-9fd1-44ff-8849-c746de8ec423	ed42bb8a-ba14-47a7-a3a6-7970a1aa511c	2026-01-03 17:21:35.459+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
05173468-f216-41a3-9ea2-9ae2f1360451	72b5eaac-da40-4351-ab39-e47678e15d1d	2026-01-03 17:21:35.472+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
4e27f6a1-15f7-4a67-a3bb-ab0b9f857b1f	9209f5df-7f3b-4d73-a28c-3171c4beac1f	2026-01-03 17:21:35.479+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
885cfd08-0e3c-4ff8-9ae5-4f49a33914e1	a91c333a-3cf5-460c-9b90-5942862c6d45	2026-01-03 17:21:35.487+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
f4a18bdb-dc67-4a63-a0bc-3e20599029df	33633745-09fa-41cf-8999-73c50524bf14	2026-01-03 17:21:35.5+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
c4223a93-e960-4a30-b555-60e4e1902753	bd122fa5-fe08-41b3-a9e7-e22a6afdc559	2026-01-03 17:21:35.511+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
539ec3f4-820b-4875-b964-6290d34737f7	39617ada-2006-4438-98de-c648708bfd67	2026-01-03 17:21:35.518+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
3e27c790-a4d6-4710-8512-1ef5c2ea4224	3e75a594-3c83-4bbb-a935-41c7f7b97e18	2026-01-03 17:21:35.524+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
65403f14-0778-46be-83b1-f0e6757c4785	2f8b097e-c905-4113-9c24-91c7e1bc6fdb	2026-01-03 17:21:35.531+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
030b712d-38ec-48b6-be08-8bba638eccc1	e65e5a79-2f64-4f31-801e-8120797acc86	2026-01-03 17:21:35.537+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	081d416b-af3c-4c1d-a2db-3525f5db5c36	\N	Marea importada de seguimiento 2025 (JSONL)
5a0d8615-2572-4fd0-a419-0db76c3791cb	22c7640e-1c82-478c-ba99-c7aad500533c	2026-01-03 17:21:35.541+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
2446b790-cf9c-4353-803b-7b82fdf5257f	1146b6ca-433f-46c6-828e-20505d95a0e7	2026-01-03 17:21:35.549+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
36ed70d1-b563-49b4-bec3-c6651f6c6537	99be84a2-c566-4889-8658-94d78a307c5e	2026-01-03 17:21:35.555+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
10bf1ec9-b91f-4ca9-8a73-dc4491e42d47	f4c7effb-17ff-40d5-96f4-4f3c4b55a753	2026-01-03 17:21:35.562+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
5bf61403-8baa-4fc6-b78d-3a64c0ba9031	49cb76e2-6c5c-41c8-844f-b6e822fe4a5d	2026-01-03 17:21:35.568+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
76a99f30-8417-40a7-9d8f-e9234f95b9c2	7e2b4aaa-aa80-4b25-8420-f362ff42341a	2026-01-03 17:21:35.575+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
4c516c5b-5da0-4df9-8762-ef6f4b08b0d7	08aa1c5a-14d7-4dfb-baff-feecda733570	2026-01-03 17:21:35.581+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
eb134a01-e2e4-4075-b499-360f62b59964	c9f0fdd5-39a3-4cdd-8f3c-9ea3cf16d665	2026-01-03 17:21:35.588+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	7c1e102c-040c-41e2-a5a9-84d3c1c6948e	\N	Marea importada de seguimiento 2025 (JSONL)
5b17f8bf-98d8-44eb-8a2e-7ed279efc05b	40d73575-8ad6-4e4e-97be-efa35740cbc4	2026-01-03 17:21:35.594+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	7c1e102c-040c-41e2-a5a9-84d3c1c6948e	\N	Marea importada de seguimiento 2025 (JSONL)
6f9f52f9-001f-4776-b2a2-6aa0112f6e86	c88c0b40-6dde-4958-ae24-0cb74e70ac0b	2026-01-03 17:21:35.601+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	91ed6780-31e7-43c7-999d-397109228a90	\N	Marea importada de seguimiento 2025 (JSONL)
21928896-b5f2-4d14-8f64-c57607a79a07	04c8b29b-d8a3-43dc-8970-1cc25eb9a5e6	2026-01-03 17:21:35.607+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	91ed6780-31e7-43c7-999d-397109228a90	\N	Marea importada de seguimiento 2025 (JSONL)
76d29bce-e92c-4996-bbe6-d19d85418c7b	b9cdc61d-04ab-43a8-8042-0ecd9802756c	2026-01-03 17:21:35.614+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	7c1e102c-040c-41e2-a5a9-84d3c1c6948e	\N	Marea importada de seguimiento 2025 (JSONL)
a6856976-ece3-4c19-b54e-4ceb85cf25c1	df1ba756-d001-43d8-a9e6-daf83a275113	2026-01-03 17:21:35.621+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
13ea95db-e50e-4787-80c0-289eb6fbddb1	4d568a25-d459-47e3-b304-51cc271329e9	2026-01-03 17:21:35.628+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	dd9a867c-d1a6-45a1-987f-f0d227dfd508	\N	Marea importada de seguimiento 2025 (JSONL)
ea8e5121-5dc4-4818-bf80-c3c0f4140401	8c72194b-9889-4483-987c-9e35da7f3975	2026-01-03 17:21:35.635+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	7c1e102c-040c-41e2-a5a9-84d3c1c6948e	\N	Marea importada de seguimiento 2025 (JSONL)
de15fca0-9ced-44f1-8f04-adc17209daa0	7b29487c-a17f-4a2d-aecc-37099df405c3	2026-01-03 17:21:35.641+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	7c1e102c-040c-41e2-a5a9-84d3c1c6948e	\N	Marea importada de seguimiento 2025 (JSONL)
8ad247f2-90ff-442d-8374-bbddc230c3c2	e4232ca1-ac45-4b98-82c2-04f4ddfd3b9a	2026-01-03 17:21:35.657+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	7c1e102c-040c-41e2-a5a9-84d3c1c6948e	\N	Marea importada de seguimiento 2025 (JSONL)
10d6605d-67ba-47a0-ae67-2fe586e29f81	1ed14f37-2218-40e5-b02f-bf29559ed482	2026-01-03 17:21:35.663+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	91ed6780-31e7-43c7-999d-397109228a90	\N	Marea importada de seguimiento 2025 (JSONL)
23ad44ea-41ba-446a-8bb3-7cad0a638bd6	6222783f-ee4a-4a6a-becd-64c774e07957	2026-01-03 17:21:35.67+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	7c1e102c-040c-41e2-a5a9-84d3c1c6948e	\N	Marea importada de seguimiento 2025 (JSONL)
0fb07296-62be-4dd4-99a7-8da1367ae751	17afdb79-821b-4363-9f08-8a0a7b6721e2	2026-01-03 17:21:35.681+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	91ed6780-31e7-43c7-999d-397109228a90	\N	Marea importada de seguimiento 2025 (JSONL)
18a58214-d091-4184-83ce-7b765225a9b2	d5432363-f925-48e2-9b5a-6fd67f073416	2026-01-03 17:21:35.688+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	7c1e102c-040c-41e2-a5a9-84d3c1c6948e	\N	Marea importada de seguimiento 2025 (JSONL)
b5362be8-0799-417c-9d25-291a6b66159e	1658b6c3-62a3-435e-a705-bdfbb8f0b5e0	2026-01-03 17:21:35.696+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	7c1e102c-040c-41e2-a5a9-84d3c1c6948e	\N	Marea importada de seguimiento 2025 (JSONL)
0bac8ac6-37ee-47d3-a069-bb332daee593	9170f973-5cf8-474a-b0c1-d67c5c212e8c	2026-01-03 17:21:35.703+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	91ed6780-31e7-43c7-999d-397109228a90	\N	Marea importada de seguimiento 2025 (JSONL)
19df56a4-7613-451b-abd7-f048a17b63fa	6ca427b8-af4a-4805-8ee8-56b5b37f0f4b	2026-01-03 17:21:35.71+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	91ed6780-31e7-43c7-999d-397109228a90	\N	Marea importada de seguimiento 2025 (JSONL)
c7a01b35-0b2b-45c1-8009-904477cb837b	2a684568-11b1-432a-9787-41ee84d82675	2026-01-03 17:21:35.722+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	7c1e102c-040c-41e2-a5a9-84d3c1c6948e	\N	Marea importada de seguimiento 2025 (JSONL)
0ca80202-4a25-41da-bce7-f26484403977	03493cc8-4b8e-46f6-a5de-6ef2a78bf0da	2026-01-03 17:21:35.728+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	91ed6780-31e7-43c7-999d-397109228a90	\N	Marea importada de seguimiento 2025 (JSONL)
bde6cc37-1f6a-495c-a51b-dbedded8a19d	69d83f9a-47b8-4756-bea7-3e69bb020de5	2026-01-03 17:21:35.74+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	91ed6780-31e7-43c7-999d-397109228a90	\N	Marea importada de seguimiento 2025 (JSONL)
81737bb0-49a1-4d39-8dca-4949630355d3	6394e50a-10c5-4917-ba6f-589afccecb3c	2026-01-03 17:21:35.748+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	7c1e102c-040c-41e2-a5a9-84d3c1c6948e	\N	Marea importada de seguimiento 2025 (JSONL)
49e3ae63-b377-40d8-829e-283d19abe5a8	ace3208f-5afa-4694-991d-5ed1d7aa6610	2026-01-03 17:21:35.755+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	91ed6780-31e7-43c7-999d-397109228a90	\N	Marea importada de seguimiento 2025 (JSONL)
462e04fd-5cc4-4c0c-9f88-60f17a5ad1d0	a2f89dfd-1da1-40bf-8455-c95c6e194389	2026-01-03 17:21:35.761+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	91ed6780-31e7-43c7-999d-397109228a90	\N	Marea importada de seguimiento 2025 (JSONL)
7ae121cc-98d8-42b2-9677-ea7504bd10dd	4694beed-eb69-4746-be8f-805e2b0d0664	2026-01-03 17:21:35.767+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	7686e133-c020-4217-b227-43529e1a6d06	\N	Marea importada de seguimiento 2025 (JSONL)
42c8ba1c-ee02-43a5-9e3d-146fe957bbb7	2b4edcfb-05d0-4cc2-8f31-a242812ac9b8	2026-01-03 17:21:35.774+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	7686e133-c020-4217-b227-43529e1a6d06	\N	Marea importada de seguimiento 2025 (JSONL)
6eab91ee-b56f-409c-a098-a66d4a5dfeb4	bc255866-6f19-4c1d-ba0f-1d8337f9f7f6	2026-01-03 17:21:35.78+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	7686e133-c020-4217-b227-43529e1a6d06	\N	Marea importada de seguimiento 2025 (JSONL)
aed39a9c-2b2c-4377-8d33-e76d12bcea5d	6be0da64-8dc4-41ed-a981-a24b0d821de6	2026-01-03 17:21:35.787+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	91ed6780-31e7-43c7-999d-397109228a90	\N	Marea importada de seguimiento 2025 (JSONL)
6cefdce3-1f0b-45e4-b9eb-e62d29f95a24	8cf38b26-ddc3-4723-911c-89feb780ea54	2026-01-03 17:21:35.793+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	7686e133-c020-4217-b227-43529e1a6d06	\N	Marea importada de seguimiento 2025 (JSONL)
d9d32117-5b82-4443-bf92-a91a783494e2	e04ec6dd-6f56-4950-af6e-6bec6d42ff79	2026-01-03 17:21:35.801+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	7686e133-c020-4217-b227-43529e1a6d06	\N	Marea importada de seguimiento 2025 (JSONL)
b82d0c0e-eae6-491b-88cc-ebf1241f42ae	9ee1d24f-51a1-4f27-8db6-8ce6b6fd6228	2026-01-03 17:21:35.808+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	9f069ef3-106c-4d1d-8043-6f71ee9edf4c	\N	Marea importada de seguimiento 2025 (JSONL)
991392ab-43a0-4a50-8dce-622118078961	80738274-20f0-4ede-bae2-df728f9e3ebc	2026-01-03 17:21:35.816+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	9f069ef3-106c-4d1d-8043-6f71ee9edf4c	\N	Marea importada de seguimiento 2025 (JSONL)
ef65ed75-ae46-465a-a075-ac710904af5d	6b6cc0ed-b50f-42c2-8444-1d339170a9c7	2026-01-03 17:21:35.823+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	9f069ef3-106c-4d1d-8043-6f71ee9edf4c	\N	Marea importada de seguimiento 2025 (JSONL)
f6ecb1ce-c0b5-4e06-bc52-36d4410a9ada	0ebbed04-db06-4513-8459-0bf5c664cd4f	2026-01-03 17:21:35.829+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	9f069ef3-106c-4d1d-8043-6f71ee9edf4c	\N	Marea importada de seguimiento 2025 (JSONL)
e37fb50d-cbb9-49f0-b8ef-0bcceb54b727	f2ed706d-85e3-4755-8943-c1d67b6affda	2026-01-03 17:21:35.836+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	9f069ef3-106c-4d1d-8043-6f71ee9edf4c	\N	Marea importada de seguimiento 2025 (JSONL)
0480c171-e50d-444a-81c8-8221d8b1bc32	931d221a-92df-4547-b9ba-1ef2a41186ec	2026-01-03 17:21:35.843+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	9f069ef3-106c-4d1d-8043-6f71ee9edf4c	\N	Marea importada de seguimiento 2025 (JSONL)
60bfeccb-4ddb-4bc3-98d1-30e56b165529	4eb1860c-0400-44c2-8374-6ffab53e27e6	2026-01-03 17:21:35.849+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	9f069ef3-106c-4d1d-8043-6f71ee9edf4c	\N	Marea importada de seguimiento 2025 (JSONL)
1386ad94-b99a-4b1e-9b2e-a54e63a5b29a	c4233c18-189c-4e02-842b-1e4c3d8da3df	2026-01-03 17:21:35.855+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	9f069ef3-106c-4d1d-8043-6f71ee9edf4c	\N	Marea importada de seguimiento 2025 (JSONL)
eb7a078c-f2b3-49ca-a1d9-d16f808bb988	4e3172e4-dd55-44ee-9bf3-9fc29339a34f	2026-01-03 17:21:35.862+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	7686e133-c020-4217-b227-43529e1a6d06	\N	Marea importada de seguimiento 2025 (JSONL)
73f2153e-388a-4212-8dab-38eb1b21fd2c	7a37c7ee-76a9-4afc-8388-29e59052dc9f	2026-01-03 17:21:35.868+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	9f069ef3-106c-4d1d-8043-6f71ee9edf4c	\N	Marea importada de seguimiento 2025 (JSONL)
5c95a4b8-25f2-45a3-80e5-389a4b532528	6df19c4a-79d1-4af4-ad36-56a0ccd20f4a	2026-01-03 17:21:35.875+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	9f069ef3-106c-4d1d-8043-6f71ee9edf4c	\N	Marea importada de seguimiento 2025 (JSONL)
5fffc8a6-838e-4994-88ad-1587d4872217	fbc3dc42-a0af-4383-b41b-45012e156918	2026-01-03 17:21:35.881+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	9f069ef3-106c-4d1d-8043-6f71ee9edf4c	\N	Marea importada de seguimiento 2025 (JSONL)
b4b5cd2c-1b32-4c75-8e0c-bf1543838520	71cb7c2c-aa87-40aa-9647-5688b9941b84	2026-01-03 17:21:35.887+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	9f069ef3-106c-4d1d-8043-6f71ee9edf4c	\N	Marea importada de seguimiento 2025 (JSONL)
14609b1f-3f72-4e28-8f03-0ea2f01f2d37	7eb337eb-c578-4ad9-a7d1-b320d5687249	2026-01-03 17:21:35.893+00	c200b0d0-2928-464a-8644-de6b36f6b7f5	CREACION	\N	9f069ef3-106c-4d1d-8043-6f71ee9edf4c	\N	Marea importada de seguimiento 2025 (JSONL)
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
8072276d-4061-425e-b1e3-ca8589da5ce5	7562	Lucas	Bentos	\N	TECNICO	LEY MARCO	t	t	\N	\N	f	\N	\N
65245a74-c651-43e7-a452-834c8eac5286	7612	Richard Javier	Espinola Gysin	\N	OBSERVADOR	1109	t	t	\N	\N	f	richardjesp@gmail.com	\N
c277db29-2b17-4c36-b29c-a42304667da0	7617	Leonardo Marcos	Kren	\N	OBSERVADOR	MONOTRIBUTISTA	f	t	\N	\N	t	lmlemark@gmail.com	Licencia mÃ©dica
9de01389-d90b-44b4-8289-cd7fcd8e9167	7621	Luis Gabriel	Martinez Tecco	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	lgmt666@hotmail.com	\N
6e35ae78-39ea-4a6a-a0b7-9787969f7b3f	7627	Jorge Luis	Morales	\N	OBSERVADOR	PLANTA PERMANENTE	t	t	\N	\N	f	didiinidep1980@gmail.com	\N
78e01ded-85a2-4ba6-8359-c23cfc30653f	7724	Eduardo Esteban	Aguilar	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	edu81aguilar@gmail.com	\N
068fb09e-8b5e-4ed8-a4ec-2e953c1128bb	7726	Juan JosÃƒÂ©	Coppa	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	juancoppa@hotmail.com	\N
aa0d418b-76b6-4598-9240-91268dd3fba7	7728	Adrian Pascual	Galluzzo	\N	OBSERVADOR	MONOTRIBUTISTA	f	t	\N	\N	t	apgalluzzo@hotmail.com	JubilaciÃ³n
67398676-bcc1-4d56-b18a-27f4599c6dc1	7729	Walter Alejandro	Glavina	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	glavinawalter@hotmail.com	\N
3cc25630-1294-4ac7-bdea-9a0b0e63f608	7730	Carlos Daniel	Herrera	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	aquimardel@gmail.com	\N
88ccf33b-5ac6-42cf-9955-3d9067772012	7733	Maria Lucila	Maydana	\N	OBSERVADOR	MONOTRIBUTISTA	f	t	\N	\N	f	\N	\N
e3a13479-a0bc-4fd7-9d70-0912b4bce884	7735	Sergio Fabian	Najle	\N	OBSERVADOR	MONOTRIBUTISTA	f	t	\N	\N	t	najlesergio@yahoo.com.ar	Licencia mÃ©dica
3dcb800d-c0fa-4578-9a55-3a754e28638d	7742	HÃƒÂ©ctor Luis	Teves	\N	OBSERVADOR	MONOTRIBUTISTA	f	t	\N	\N	t	hecluteves@hotmail.com	JubilaciÃ³n
62b28318-fb31-4213-afd9-be57f0dad135	7767	Claudio Alberto	Nadal	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	nadal-claudio@hotmail.com	\N
3e4522fe-7956-42b1-b92b-d227ed3946c8	7776	Gonzalo	Troccoli	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	gtroccoli@inidep.edu.ar	\N
43586eab-9ed2-4505-a7b0-dd71637450d4	7796	Fernando Alberto	Schwartz	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	gallococo@hotmail.com	\N
e9ecccbe-4f88-46e7-bb58-1fc6e64ba9d9	7798	Marcelo Simon	Freyre	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	freyre.ms@gmail.com	\N
f12990f3-4652-43ff-8baa-c8062c61bf09	7828	Fabian Eduardo	Desojo	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	t	pachappppp@gmail.com	Cambio de empleo a engrasador
5fadeb17-1d8f-4006-9aa4-6a8a0d332d90	7832	Maximiliano Adrian	Godoy	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	maxigodox@gmail.com	\N
2508aad7-5219-4d58-b200-1750f1d0e414	7838	Nicolas Facundo	Staneff Rotela	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	nicolas.staneff@gmail.com	\N
3e439fbc-273c-4c12-8a9f-bea34cd03fd5	7841	Nicolas Agustin	Caballero	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	Nicck934@gmail.com	\N
aa3c098f-6e98-48c7-bce3-25fdccf6b343	7842	Gabriel Osvaldo Catriel	Gimenez Salinas	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	pikyred123@gmail.com	\N
6e4d646f-d0ca-4032-9f61-e5c744881332	7843	Johnatan	Challier	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	jonhychallier@gmail.com	\N
5a9b9ff5-6bae-443e-af1f-c281a161e786	7844	SebastÃƒÂ­an Roque	Garcia	\N	OBSERVADOR	MONOTRIBUTISTA	f	t	\N	\N	f	sebastianroquegarcia4@gmail.com	\N
3a4ad215-8ed5-4caf-a506-ccd72b30b966	7845	Alexia	Aguilar	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	aguilaralexia00@gmail.com	\N
b376ef19-8b73-4bd0-bf0b-4cecf76eba6e	7846	Oriana	Retamar Mendez	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	t	orianaretamarm@gmail.com	RestricciÃ³n operativa para embarque de mujeres
d24a7b81-a2f2-4dd2-8bfb-d413d5082488	7847	Gianfranco	Alvarez	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	gianalvarezobs@gmail.com	\N
fd1e6b19-e418-443f-b399-53eac06e72df	7848	Diego	Gorosito	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	diegojavierg158@gmail.com	\N
2866137d-8abc-4ec3-83cc-68db9e1cedf7	7849	Leonardo	Prado Escobar	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	t	estudioprado02@gmail.com	Inactivo segÃºn reporte
cd84bae0-3c5b-447c-be9c-76a10d060399	7850	MarÃƒÂ­a Laura	Monterisi	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	mlm.vlady@gmail.com	\N
42f310a2-36c8-4719-8e65-0412189d8141	7851	Alvaro	Benitez	\N	OBSERVADOR	MONOTRIBUTISTA	f	t	\N	\N	t	alvarobeni89@gmail.com	En otro trabajo
7a0c914b-ac5e-45b6-b586-fb2ad2efd969	7852	Camila	Corti	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	camilacorti95@gmail.com	\N
39fe34fd-531b-4cea-a5f7-266132181fbc	7853	Luciano	Matte Casietto	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	lucianomcassietto@hotmail.com.ar	\N
bb9859bb-8ac2-4068-88f4-a742d7d79f44	73	Leonardo	Spagnuolo	\N	OBSERVADOR	1109	t	t	\N	\N	f	leospagnuolorey@yahoo.com.ar	\N
1d4f6a90-26a1-40ff-a022-454d87df35d5	166	Raul	Bargas	\N	OBSERVADOR	1109	t	t	\N	\N	f	rbbargas@gmail.com	\N
821fdf27-3a22-4dd5-83a3-4c0d31cb9f18	172	Federico	Garcia	\N	OBSERVADOR	1109	t	f	\N	\N	t	fede.gaarciaa@gmail.com	Accidente en motocicleta
9cfb387b-6e60-4457-9dea-162d527398a5	174	Diego	Marchiori	\N	OBSERVADOR	1109	t	t	\N	\N	f	brugmasia@hotmail.com	\N
331665d3-483f-4651-bfbd-2d6ee49c633a	179	Tere	Reinaga	\N	OBSERVADOR	1109	t	t	\N	\N	f	tere2361@hotmail.com	\N
cd31391e-689d-445b-a811-1121c43cdde0	183	Jorge	Herrera	\N	OBSERVADOR	1109	t	t	\N	\N	f	herrerajorgeguillermo@gmail.com	\N
8944792a-e053-42a2-a5b1-d52f47d4ad14	186	Cristian	Cerrina	\N	OBSERVADOR	1109	t	t	\N	\N	f	manucerrina2@gmail.com	\N
9dbd39c5-5ddf-457a-9253-f701147ee915	190	Eduardo	Silvester	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	eduwolfsilvester@hotmail.com	\N
99fa9f30-6c48-4576-98a3-938f6d86157d	2021	Claudio	Noale	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	t	claudionoale@hotmail.com	Cambio de trabajo
5ba8b4e9-0443-4b42-941e-c22331c326bf	4840	Durbal	Villalba	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	villalbadurbal@gmail.com	\N
fe6f0d3b-7aa6-40e8-8ca7-b9b3c060fa04	7149	Gustavo	Cano	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	\N	\N
37435076-ac11-4c11-af68-d4cab1b56f92	7867	Cintia Daiana	Magrini Quiroga	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
89ab21a3-3a48-4966-b171-8139fc8deb99	7868	Lucas Oscar	Gaona	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
073cc51e-e7d7-45e4-b5ae-51fbf05785ad	7869	Sergio GastÃƒÂ³n	Frontera	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
a999ce6c-c29b-432d-b84b-9941cac7c2e4	7871	Sergio Javier	Gomez Mapiz	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
d87a24c3-5eaf-4c46-8714-e37a5c25a4d2	7872	Juan Francisco	Rodriguez Fulco	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
1ad358c9-3973-4e03-9a19-89d00b66b1e9	7873	Lucas David	Carabeta	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
43d485ce-503d-4c51-a1bb-a7fb53cac3c3	7874	Morena Aylen	Ledesma	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
df25caca-f7d2-46e7-928e-1be249c29bb5	7875	Leonardo Ezequiel	Andrade	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
25e2b56f-6449-471f-b2eb-727cbd3912b1	7876	Walter Alejandro	Leon	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
27ac3786-90d2-401f-9d24-d3ec095a1ae0	7879	LucÃƒÂ­a	Martinez Ta	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
0a77beb1-b7de-4cb6-97b2-6b60cefd4a2b	7900	Paola Alejandra	Navarro Grassi	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
d18717f7-8f9f-4218-9992-67c91148ec6b	7854	Gisele	Garcia	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	t	garciagiselealejandra@gmail.com	DesempeÃ±o insuficiente reportado
3a595519-7015-4f2d-a30c-21a8c7411569	7855	Nicolas	Pereyra	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	nicolasagustinpereyra777@gmail.com	\N
60a1b476-f69e-40b6-9133-943c9306b3b1	7858	Franco	Ibarra	\N	OBSERVADOR	MONOTRIBUTISTA	t	f	\N	\N	t	francoadrianibarra@gmail.com	En otro empleo
5e0a00a1-c616-4774-8c82-7e046229f9a1	7859	Melisa	Garcia	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	t	melipg7@gmail.com	RestricciÃ³n operativa para embarque de mujeres
c253e74a-9b43-495f-97b3-a90aad69da92	7860	Nahuel	Ramirez	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	nahuelramirezm@gmail.com	\N
922346c8-0235-4b56-bb66-105f66d43e8d	7861	Daiana Anabella	Molina Riquelme	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
f3817c10-9482-481f-b16b-5e45481a25e6	7862	Christian Enderson	Fenco Chavesta	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
03e404bc-6f3d-4176-a366-55d2fc3af192	7863	Daniel Enrique	Ramunno	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
c91a9158-62f5-4b48-8373-62908df6a3b6	7864	Manuel AgustÃƒÂ­n	Palos	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
360dc970-d0ef-41ce-88ed-73141ef209e8	7865	Gabriel Alejandro	Dumrauf	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
d4a1248b-9a2b-4366-9968-1ebfd115ac13	7866	Francisco German	Sette	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
3aba30f7-9058-4a01-9ea4-1a2788387ee4	8002	Julio Roberto	Sinconegui	\N	OBSERVADOR	MONOTRIBUTISTA	f	t	\N	\N	f	jrsinconegui@inidep.edu.ar	\N
de391ff2-5dae-49e2-82c0-8369ed785e77	9442	Sebastian	Garcia	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
1de6ff54-e82d-473b-852d-5ec6721be97d	9451	Jorge Fernando	Repetto	\N	OBSERVADOR	MONOTRIBUTISTA	f	t	\N	\N	t	cotoperca23@hotmail.com	JubilaciÃ³n
5a28d4d7-effd-4c1a-8976-8ad3fb333d24	9459	RaÃƒÂºl Antonio Ceferino	Puliafito	\N	OBSERVADOR	MONOTRIBUTISTA	f	t	\N	\N	t	raul.puliafito@gmail.com	Traslado a otro programa
18ec5884-b9a9-451b-8fc4-2bd767235714	9460	Pablo Alejandro	Ramos	\N	OBSERVADOR	MONOTRIBUTISTA	f	t	\N	\N	t	pabloramos64@yahoo.com.ar	Licencia mÃ©dica
fd4b5bba-2006-4fad-8183-09848a55afe5	9461	Alejandro JosÃƒÂ©	Mazzei	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	alejandromazzei525@gmail.com	\N
1583f826-957d-4907-976b-eceea82324be	9465	Daniel Alejandro	Di Tullio	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	ddi@inidep.edu.ar	\N
4656f2f8-9b64-464a-ba5e-4ba98c4d241a	9467	Pablo Julian	Miranda	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	pablojmiranda65@gmail.com	\N
b987eba0-d18c-46a1-aeb5-a0e202f3c4f0	9471	Estanislao	Rodriguez Fulco	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	rfestanislao@gmail.com	\N
35fd7b9c-7e76-46ca-97de-72a2dacec5fe	9474	Juan Manuel	Staneff	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	juanmanuel_jotis@hotmail.com	\N
2efbccf5-90b1-4fa5-9600-714f2ac0f4ca	9476	HÃƒÂ©ctor Eduardo	Vera	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	t	veraeduardo1971@gmail.com	Licencia mÃ©dica
82bc71af-a98d-47e4-8f0a-f7fc73f5b76a	9480	Cristian Oscar	Piriz	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	t	cristianpiriz36@gmail.com	Licencia mÃ©dica
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
1134dda5-1ff7-4d85-a794-861df41db922	ABADEJO	Abadejo	\N	Peces	\N	t
df07a4cf-11da-44b1-9cf5-4cf973bbd62a	ANCHOITA	Anchoíta	\N	Peces	\N	t
a925b105-a0d0-4b78-855d-de6a1b41604f	CABALLA	Caballa	\N	Peces	\N	t
68a3cc43-2e5f-4423-8302-3e11af1ff872	CALAMAR	Calamar	\N	Moluscos	\N	t
b5066e3d-aff4-484a-b1ad-a45a57700aeb	CENTOLLA	Centolla	\N	Crustáceos	\N	t
a05ae304-2d0e-4e29-a6f3-fa7372a41c97	AUSTRALES	Especies australes	\N	Peces	\N	t
372697a7-b884-4ed6-9bb6-1420610ba86f	LANGOSTINO	Langostino	\N	Crustáceos	\N	t
2734dc66-d31b-4d97-aeda-645ce3eb6885	MERLUZA_COMUN	Merluza común	\N	Peces	\N	t
573af89c-fbee-4643-b922-7b69926c208d	MERLUZA_NEGRA	Merluza negra	\N	Peces	\N	t
9d02d029-f003-41b6-89de-0eea18b2d4e4	VIEIRA	Vieira	\N	Moluscos	\N	t
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
69f7ae79-f037-4bda-9ed6-2eb49c900fa8	Rio Gallegos	\N	\N	19	\N	f	t	\N	\N	-51.63334	-69.2
3c423d63-b431-4bf2-b375-b4de59037821	Ushuaia	\N	\N	10	\N	f	t	\N	\N	-54.83333	-68.3
26cb8962-0318-4dfe-a961-1b84a6ce6302	Buenos Aires	\N	\N	12	\N	f	t	\N	\N	-34.58333	-58.38334
392a610b-5ff5-4497-9793-9f18ef1b8f8a	Rio Grande (brasil)	\N	\N	20	\N	f	t	\N	\N	-32.13334	-52.08333
4bcd9465-436d-4e6d-8a90-3cda46f996c1	Montevideo	\N	\N	XX	\N	f	t	\N	\N	-34.9	-56.2
a01659dc-4daa-4a72-b2f4-e6d9e40c733a	Samborombon	\N	\N	21	\N	f	t	\N	\N	-35.73333	-57.31667
9db5a563-1841-4464-bb88-15e6d034adcc	San Clemente	\N	\N	14	\N	f	t	\N	\N	-36.33333	-56.78333
24918e15-e968-484f-b31e-dc786b5f9ec2	Mar Del Plata	\N	\N	1	\N	t	t	\N	\N	-38.06667	-57.55
44d1a93e-274c-4b2b-baea-4bbad71c1808	Quequen	\N	\N	2	\N	f	t	\N	\N	-38.58333	-58.7
49e7b97e-f997-4fd6-8de0-06ec2254bbf5	Bahia Blanca	\N	\N	3	\N	f	t	\N	\N	-38.75	-62.16667
a2cd9df6-29ea-4515-961b-4c01f804e934	Bahia San Blas	\N	\N	15	\N	f	t	\N	\N	-40.55	-62.23333
f58cf3b9-22a7-4d22-b1d0-deecabf0640a	San Antonio Oeste	\N	\N	9	\N	f	t	\N	\N	-40.73333	-64.96667
5c469f19-673e-4f8d-842b-57259f66fef0	Viedma	\N	\N	22	\N	f	t	\N	\N	-40.9	-62.86666
a48e3d60-bea0-4828-8099-3debb447f631	Puerto Madryn	\N	\N	4	\N	f	t	\N	\N	-42.76667	-65.05
18318dd2-cbb1-42cb-8aa0-f6f2c1f945bd	Rawson	\N	\N	7	\N	f	t	\N	\N	-43.33333	-65.06667
94a88e20-40f9-4ab3-b59d-992fb4a60e1a	Bahia Camarones	\N	\N	11	\N	f	t	\N	\N	-44.8	-65.73333
747eb90c-4eaf-451e-999f-759163bc918c	Comod, Rivad,	\N	\N	6	\N	f	t	\N	\N	-45.88334	-67.5
c817e318-e58c-47cc-996d-28e1b73d8c9f	Caleta Olivia	\N	\N	16	\N	f	t	\N	\N	-46.43333	-67.53333
f05d47aa-ffad-4c48-99f2-39015dc0159a	Deseado	\N	\N	5	\N	f	t	\N	\N	-47.76667	-65.91666
1ee348c3-a618-4875-a490-9c1ec8c3b06a	San Julian	\N	\N	17	\N	f	t	\N	\N	-49.31667	-67.73333
7f8501d3-7d7d-488d-b45b-6f4bbd9e302d	Punta Quilla	\N	\N	23	\N	f	t	\N	\N	-50.11666	-68.41666
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
ce0804e6-6594-415e-8a46-cc4d8a237910	FRESQUERO	Fresquero	\N	\N	t
b5fdd90b-d80b-4166-a62d-ad7a43b7cc7f	TANGONERO	Tangonero	\N	\N	t
6a95076f-aec1-4941-b231-92dfbc802cb7	CONGELADOR_MERLUCERO	Congelador Merlucero	\N	\N	t
95e71d6e-c6cc-4060-a537-bd036203317d	POTERO	Potero	\N	\N	t
d2217eec-a161-4143-9a47-007bc8afc75e	PALANGRERO	Palangrero	\N	\N	t
2fd5a564-7035-4cb2-836b-8e5f806b3db2	CONGELADOR_ARRASTRERO	Congelador Arrastrero	\N	\N	t
fec3d722-78a4-4209-a6d3-e247c197885a	CENTOLLERO	Centollero	\N	\N	t
2966881e-e368-4b60-958d-683c71ed8609	VIEIRERO	Vieirero	\N	\N	t
15652b63-0efc-4059-ad8a-36de68d64a35	COSTERO	Costero	\N	\N	t
65029fa6-99f0-445f-9613-176773c55dca	INVESTIGACION	Investigación	\N	\N	t
3271a122-ccb0-42ec-a69b-87d56de04fa8	SURIMERO	Surimero	\N	\N	t
ba886b54-f6f9-46d3-b89c-af6f53473323	RAYERO	Rayero	\N	\N	t
975bf25c-1d6d-4101-9c5d-abe95e0a6978	CONGELADOR_AUSTRAL	Congelador Austral	\N	\N	t
db248d8c-5979-4de7-9201-d8dabe9baac1	CONGELADOR_GENERICO	Congelador Genérico	\N	\N	t
\.


--
-- Data for Name: transiciones_estados; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.transiciones_estados (id, id_estado_origen, id_estado_destino, accion, etiqueta, clase_boton, requiere_observaciones, activo) FROM stdin;
2cd2c19b-793e-4933-b58d-fc367a29d7b9	9f069ef3-106c-4d1d-8043-6f71ee9edf4c	7686e133-c020-4217-b227-43529e1a6d06	REGISTRAR_INICIO	Registrar Inicio	primary	f	t
5173ebf6-9e68-439c-a2f6-a4532ecd8377	7686e133-c020-4217-b227-43529e1a6d06	91ed6780-31e7-43c7-999d-397109228a90	REGISTRAR_ARRIBO	Confirmar Arribo	primary	f	t
a12b866b-b57b-4e32-a270-f599696250da	91ed6780-31e7-43c7-999d-397109228a90	db613d46-5efb-44f3-82cc-7b6d8bb7cab1	RECIBIR_DATOS	Recibir Archivos	primary	f	t
5eaaf2f8-1d75-44ab-935e-4be08a67fbc7	db613d46-5efb-44f3-82cc-7b6d8bb7cab1	dc80d04a-0562-447a-82d4-034abc3b7de1	INICIAR_VERIFICACION	Iniciar Verificación	primary	f	t
e356e505-bdcc-4150-990c-074ab001baa6	dc80d04a-0562-447a-82d4-034abc3b7de1	3b25becb-425a-4103-aee1-47d04ae7a7ad	ABRIR_CORRECCION	Abrir Corrección	secondary	f	t
84efbce0-989f-4d5d-baa2-5c35e69558ce	dc80d04a-0562-447a-82d4-034abc3b7de1	04e442d2-a6e0-4c7c-a3f1-7358d332ca10	PASAR_A_INFORME	Pasar a Informe	primary	f	t
b3ce2447-5c6a-42a8-9a63-8422248dce76	3b25becb-425a-4103-aee1-47d04ae7a7ad	04e442d2-a6e0-4c7c-a3f1-7358d332ca10	FINALIZAR_CORRECCION	Finalizar Corrección	primary	f	t
fdece31c-df0c-4aa8-a505-431e365665b4	3b25becb-425a-4103-aee1-47d04ae7a7ad	1e713d9c-808a-4800-9920-abbb60da59c2	DELEGAR_EXTERNA	Derivar a Proyecto	secondary	f	t
dd64dc11-b602-453b-bb90-72cdaa0509cf	1e713d9c-808a-4800-9920-abbb60da59c2	3b25becb-425a-4103-aee1-47d04ae7a7ad	RETORNAR_CORRECCION	Devolución Externa	primary	f	t
48bd1892-c85d-4c9f-9973-3c582093c0d0	04e442d2-a6e0-4c7c-a3f1-7358d332ca10	59f13e6d-1afb-4eac-8389-5bbe335b1bc9	ENVIAR_A_REVISION	Enviar a Revisión	primary	f	t
2ddb9928-45cd-4ab3-a8de-9d2ab6ba4465	59f13e6d-1afb-4eac-8389-5bbe335b1bc9	7c1e102c-040c-41e2-a5a9-84d3c1c6948e	APROBAR_INFORME	Aprobar Informe	primary	f	t
2d8b5843-da3f-45f5-b0f8-a2ad9f2150d3	59f13e6d-1afb-4eac-8389-5bbe335b1bc9	04e442d2-a6e0-4c7c-a3f1-7358d332ca10	RECHAZAR_INFORME	Observaciones en Informe	secondary	f	t
1af386a9-5be7-450e-8753-cba85eea10fb	7c1e102c-040c-41e2-a5a9-84d3c1c6948e	38be0651-cf2d-4893-b2fc-40bb5acda3d5	INICIAR_TRAMITE	Iniciar Protocolización	primary	f	t
5dded029-ec4f-4d12-85da-35416a6fa605	38be0651-cf2d-4893-b2fc-40bb5acda3d5	dd9a867c-d1a6-45a1-987f-f0d227dfd508	FINALIZAR_PROTOCOLIZACION	Finalizar Protocolización	primary	f	t
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, email, password, "fullName", "isActive", roles, "themePreference", "avatarUrl") FROM stdin;
c200b0d0-2928-464a-8644-de6b36f6b7f5	admin@obs.com	$2b$10$8T.a6hm/3yiYmzsvAnttaesoC50oWaOiMFD0U2ZNValDbrGGP1odC	Administrador Sistema	t	{admin}	system	\N
d03f2606-6eb5-4a4d-8e39-8f394580e0cc	coordinador@obs.com	$2b$10$8T.a6hm/3yiYmzsvAnttaesoC50oWaOiMFD0U2ZNValDbrGGP1odC	Coordinador Operativo	t	{coordinador}	system	\N
1c0d1c11-f363-4936-8839-e57418566645	tecnico@obs.com	$2b$10$8T.a6hm/3yiYmzsvAnttaesoC50oWaOiMFD0U2ZNValDbrGGP1odC	Técnico de Datos	t	{tecnico_datos}	system	\N
2a011eec-428c-4586-8210-729d5996cc56	asistente@obs.com	$2b$10$8T.a6hm/3yiYmzsvAnttaesoC50oWaOiMFD0U2ZNValDbrGGP1odC	Asistente Administrativo	t	{asistente_administrativo}	system	\N
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

