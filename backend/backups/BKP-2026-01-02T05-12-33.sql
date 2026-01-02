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
    observaciones text
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
ee625999-945e-413c-88ab-29abc5779aa7	bee2d9194450fade8ac383ea904036fa4501a35691f5ef28ac880cb243e9542c	2026-01-02 03:15:32.81924+00	20251229225926_12_29	\N	\N	2026-01-02 03:15:32.695034+00	1
63c557e8-adb0-4357-861a-2bb66043904b	7c22e6609bd096f6d7685581ed6b0b0c909a2d3104bf8ff3e96db1edf0cd3bb9	2026-01-02 03:15:32.829039+00	20251230150045_add_avatar_url	\N	\N	2026-01-02 03:15:32.821544+00	1
20fa9160-9204-4b1b-979f-48b97ad9199a	f8d58daf8546149005be90b9ba66a9d52b21c9265cfda82318ed41d088617c90	2026-01-02 03:15:33.077505+00	20251230191649_catalogos	\N	\N	2026-01-02 03:15:32.831474+00	1
56f52e30-4adc-4a9f-b0e3-ae82f8c568f4	20782ee2558020848026db9764e810d05ed583e58ef4b90e6f1f57fff37b6d95	2026-01-02 03:15:33.086638+00	20251230204050_add_lat_long_to_puerto	\N	\N	2026-01-02 03:15:33.080012+00	1
e4bfabac-8aaa-4bf9-8136-2fad0c503068	3f6a3eeec854410c2fa19cd829635de8cb23d6ffaed54387dd55b6959f2f05c2	2026-01-02 03:15:33.536321+00	20251231125007_add_all_entities_from_docs	\N	\N	2026-01-02 03:15:33.088721+00	1
ed22fb5b-bf96-4224-91ea-fd1497b1416a	81be05cceb7597afbb2840c400faecf2b5fd61e65687f7a695be09cba98d455a	2026-01-02 03:15:33.546834+00	20251231132736_rename_arte_pesca_descripcion_to_nombre	\N	\N	2026-01-02 03:15:33.538612+00	1
c13a977e-e2d2-4fb7-8629-a118e04ebc93	3a21f64efb9cf9508a6ff148ac6b033bc42d41588d8d68135fb54b30c1bb8110	2026-01-02 03:15:33.575754+00	20251231150715_add_error_log	\N	\N	2026-01-02 03:15:33.548902+00	1
fea97ac0-b426-4abd-bfd9-f4d0ba42851d	89ed15d6aa634c93d45242c899f5b2aa30f99a773bba53dee8fe8f2db7cb0286	2026-01-02 03:15:33.586305+00	20251231184904_add_tipo_marea_to_marea	\N	\N	2026-01-02 03:15:33.578503+00	1
ae13a656-39df-45f9-8c52-d7868571c27c	0c567b6e5e77e88ce15785b78a5c9a847a472fb02c6041fb3c8561467ed2668a	2026-01-02 03:15:33.685236+00	20260101195946_add_transiciones_y_etapa_observadores	\N	\N	2026-01-02 03:15:33.588751+00	1
\.


--
-- Data for Name: artes_pesca; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.artes_pesca (id, codigo_numerico, activo, nombre) FROM stdin;
eadd543b-54c9-4c06-a5b7-f10df7cb91ae	2	t	Red de arrastre de fondo
f5969b1d-7d5f-4ee3-aef3-2f45be4d0481	6	t	Red de arrastre de media agua
5f31658c-2f47-424a-95fd-4eafbe4a7362	3	t	Red de lampara
ad7a4b3e-8b6f-4e2a-a13c-0df77e556030	5	t	Espinel
f3d12186-8e14-4fb4-ab2e-cc46e5872207	4	t	Red de enmalle
9c5013d8-1225-4615-93a1-db8a1c018fb4	18	t	Red agallera de deriva
facaf1bb-b284-4017-ae4d-e423bf92bf7f	16	t	Palangre de fondo
46007bc9-6c49-4b64-897b-a88692701a77	1	t	Red de cerco
6131d6b5-f9f3-4837-a086-93c91330fa56	19	t	Red Bongo 300
f5dfff2c-a343-4be1-9700-6e4c8f16d379	20	t	Red Bongo 500
1ad2ff34-ef83-44cc-920d-73e89a8e4e33	21	t	Red Nakthai
6093369b-a4c1-43af-8a76-20c546c8ec92	22	t	Red Isaac-Kidd
92f8adb6-6c19-467c-89da-1247bdd0b3a5	7	t	Rastra
fecc2c75-b8ea-40cb-849d-2b8041b5ed56	8	t	Nasa
f035d898-c339-4310-8f93-03a9f2c64056	9	t	Linea
e5f3a71e-0ce1-46bc-9808-5c7fd27d78e9	10	t	Raño
983c24a2-a641-4585-a374-6e21ed383ac1	11	t	Poteras
65ba9d4c-51dd-4ae6-a41a-f6731d2e3705	12	t	Red de fondeo
8ef217f2-61c5-439a-a902-0d110b010653	13	t	Trampa centollera
814946a3-1e99-4d4c-8c23-59f6b7421e5a	14	t	Red de arrastre de fondo con tangones
bb92adca-b55d-48ce-8de0-78613dec9300	32	t	Currican
87f6e3ee-e353-47dc-9800-ab8903be642e	15	t	Red de arrastre de fondo en pareja
77f2f542-dc7b-43b1-8d1b-81293de8482f	80	t	Otros
a776b76b-2b7e-494d-8e9f-2243c3bf2cd2	0	t	Sin Especificar
d54934c1-0e97-45c0-852c-8e43ca65b9e4	90	t	No Identificado
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
da1be59c-5ec9-4dd6-abc8-dc68c49e5c4a	7 de Diciembre	TEMP-0001	1013	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	27.20	521	5d12df00-152b-43e6-8ba0-20067e3bac8c		Mar del Plata	4895032		\N	operacionesconsultoramaritima@gmail.com	\N	\N	Consultora Maritima	t	\N	\N	\N
630ea927-689e-4778-a417-fddfe83a8002	ACRUX	03086	0	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	28.00	0	5d12df00-152b-43e6-8ba0-20067e3bac8c	DE ANGELIS Y LOGGHE S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
c5e7abb5-f385-46eb-83e1-a240d99e5f33	ALDEBARAN	01741	1038	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	26.42	426	5d12df00-152b-43e6-8ba0-20067e3bac8c	PESQUERA SAN ROQUE	Mar del Plata		480-0573	\N		\N	\N		t	\N	\N	\N
66fff14a-54a3-420b-8449-21fe6832ebc0	ALTALENA	0181	1051	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	55.80	1350	5d12df00-152b-43e6-8ba0-20067e3bac8c	MARONTI  S.A.	Mar del Plata	4800005		\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi	t	\N	\N	\N
aa7ea455-2ec5-46ed-a3b6-b5028693e0f0	ALVAREZ ENTRENA I	02454	1055	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	39.43	988	9e675114-d5e6-449e-a20c-9688499c3c00	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
df097bbb-5e41-42bd-9673-9499c8fd2809	ALVAREZ ENTRENA II	02465	1056	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	39.50	988	9e675114-d5e6-449e-a20c-9688499c3c00	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
17b8c0dd-04fb-4a2a-9116-18aed983394e	ALVAREZ ENTRENA III	02379	\N	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	\N	\N	9e675114-d5e6-449e-a20c-9688499c3c00	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
13c10b9f-0ca0-44f0-8c5f-4ce75b0fadd3	BAFFETTA	02635	0	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	19.45	295	9e675114-d5e6-449e-a20c-9688499c3c00	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
b7120ef0-7144-4a78-9a0a-fd620cd5b9c3	ALVAREZ ENTRENA VI	01	2774	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	30.50	1033	9e675114-d5e6-449e-a20c-9688499c3c00	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
fa15087e-616f-4de7-8552-286d850a513e	AMBITION	01324	\N	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	\N	\N	5d12df00-152b-43e6-8ba0-20067e3bac8c	PESQUERA TRES MARIAS  S.A.	Mar del Plata		480-0336	\N		\N	\N		t	\N	\N	\N
2e95d154-8dcc-4f37-8a74-317fcc17f52e	ANITA	3	\N	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	\N	\N	\N	5d12df00-152b-43e6-8ba0-20067e3bac8c	SOLIMENO	Mar del Plata			\N		\N	\N		t	\N	\N	\N
dd40ba16-7a8a-4a6d-ad62-1f98776b0deb	ANA III	278	1069	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	19.95	443	9e675114-d5e6-449e-a20c-9688499c3c00	POSEIDON  S.A.	Puerto Madryn		0280-445-7786	\N		\N	\N		t	\N	\N	\N
5d557b93-71c8-4864-983f-544d69261103	ANABELLA  M	0175	\N	b509832f-10d9-4f7d-b71e-5bd4ecf88b38	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	60	\N	\N	9e675114-d5e6-449e-a20c-9688499c3c00	PESCAPUERTA ARGENTINA  S.A.	Puerto Madryn		0280-445-4407	\N		\N	\N		t	\N	\N	\N
92dc3cde-d61c-450a-92a6-8d29cc0e9cdd	ANDRES JORGE	1065	2760	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	50.10	1102	5d12df00-152b-43e6-8ba0-20067e3bac8c	MARONTI  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
b529b0c6-5739-4187-b486-047f981c877e	ANGELUS	01953	1087	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	52.60	1337	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	PESQUERA CRUZ DEL SUR  S.A.	Ciudad Autónoma de Buenos Aires		011-4784-1760	\N		\N	\N		t	\N	\N	\N
23337de0-db79-45a7-91a6-ce6b218fee4a	ANITA ALVAREZ	02138	\N	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	\N	\N	9e675114-d5e6-449e-a20c-9688499c3c00	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
454cda26-ce58-46b1-a8e6-ef523d1d1b59	ANTARTIC  I	0232	\N	6cee615f-2f06-4187-ae28-3c9e9d5584cf	facaf1bb-b284-4017-ae4d-e423bf92bf7f	a3d52a88-3e07-46f5-b2f4-4c885f36886b	60	\N	\N	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	ESTREMAR  S.A.	Ciudad Autónoma de Buenos Aires		011-6533-7853 / 4345-1102	\N		\N	\N		t	\N	\N	\N
0f5d4e9a-deef-43de-a1e2-d83fa54a3954	ANTARTIC II	0263	\N	6cee615f-2f06-4187-ae28-3c9e9d5584cf	facaf1bb-b284-4017-ae4d-e423bf92bf7f	a3d52a88-3e07-46f5-b2f4-4c885f36886b	60	\N	\N	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	ESTREMAR  S.A.	Ciudad Autónoma de Buenos Aires		011-6533-7853 / 4345-1102	\N		\N	\N		t	\N	\N	\N
5470cbb8-a928-4ab2-903e-453429736a33	ANTARTIC III	0262	\N	6cee615f-2f06-4187-ae28-3c9e9d5584cf	facaf1bb-b284-4017-ae4d-e423bf92bf7f	a3d52a88-3e07-46f5-b2f4-4c885f36886b	60	\N	\N	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	ESTREMAR  S.A.	Ciudad Autónoma de Buenos Aires		011-6533-7853 / 4345-1102	\N		\N	\N		t	\N	\N	\N
9c230a43-f171-4e48-b2ec-a134159c7d63	ANTARTIDA	0678	\N	b509832f-10d9-4f7d-b71e-5bd4ecf88b38	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	60	\N	\N	9e675114-d5e6-449e-a20c-9688499c3c00	IBERCONSA  DE ARGENTINA  S.A.	Puerto Madryn	4891227	0280-445-4324	\N	serviciosmaritimosmdq@gmail.com	\N	\N	Servicio Maritimo Integral	t	\N	\N	\N
a860e4ac-9fa4-4493-8baa-38b1bee959a0	ANTONINO	0877	1099	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	27.60	541	5d12df00-152b-43e6-8ba0-20067e3bac8c	AGLIPESCA  S.A.	Mar del Plata		480-2886	\N		\N	\N		t	\N	\N	\N
df0b9291-259d-4a4b-9b33-24699dfaacec	ANTONIO ALVAREZ	01429	1100	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	36.60	1168	9e675114-d5e6-449e-a20c-9688499c3c00	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
3ab2b8f1-0795-4360-9cab-f42c055ade96	API II	0679	\N	b509832f-10d9-4f7d-b71e-5bd4ecf88b38	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	60	\N	\N	9e675114-d5e6-449e-a20c-9688499c3c00	IBERCONSA  DE ARGENTINA  S.A.	Puerto Madryn		0280-445-4324	\N		\N	\N		t	\N	\N	\N
4f0889f1-d009-42fa-8ee8-853a5a0d6848	API IV	0680	\N	b509832f-10d9-4f7d-b71e-5bd4ecf88b38	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	60	\N	\N	9e675114-d5e6-449e-a20c-9688499c3c00	IBERCONSA  DE ARGENTINA  S.A.	Puerto Madryn		0280-445-4324	\N		\N	\N		t	\N	\N	\N
f64c6ba7-d50b-499c-b291-5317e8beee33	API V	02781	2711	b509832f-10d9-4f7d-b71e-5bd4ecf88b38	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	60	77.40	2960	9e675114-d5e6-449e-a20c-9688499c3c00	IBERCONSA  DE ARGENTINA  S.A.	Puerto Madryn		0280-445-4324	\N		\N	\N		t	\N	\N	\N
17a8f6b4-54a5-4672-acde-7154dd219e71	API VI	02812	2734	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	40	36.35	1201	9e675114-d5e6-449e-a20c-9688499c3c00	IBERCONSA  DE ARGENTINA  S.A.	Puerto Madryn		0280-445-4324	\N		\N	\N		t	\N	\N	\N
4b13fc14-16bb-4612-af34-ac4b9e101be3	API VII	03081	2777	b509832f-10d9-4f7d-b71e-5bd4ecf88b38	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	60	72.20	0	9e675114-d5e6-449e-a20c-9688499c3c00	IBERCONSA  DE ARGENTINA  S.A.	Puerto Madryn		0280-445-4324	\N		\N	\N		t	\N	\N	\N
c6f30b8a-8b03-4481-b5c8-9ae4645db9ef	ARBUMASA X	6183	1114	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	35.30	1087	c0480dd3-e309-4e6d-8620-661c4fdfe0c7	ARBUMASA  S.A.	Puerto Deseado		0297-487-2807 / 444-5338 / 444-1201	\N		\N	\N		t	\N	\N	\N
4001ee8d-40e9-475f-993a-12f85112d0c2	ARBUMASA XIX	06440	1117	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	36.40	870	c0480dd3-e309-4e6d-8620-661c4fdfe0c7	ARBUMASA  S.A.	Puerto Deseado		0297-487-2807 / 444-5338 / 444-1201	\N		\N	\N		t	\N	\N	\N
3f02863b-f014-4cfa-a7dd-da7c4fb943f1	ARBUMASA  XVII	0216	\N	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	\N	\N	c0480dd3-e309-4e6d-8620-661c4fdfe0c7	ARBUMASA  S.A.	Puerto Deseado		0297-487-2807 / 444-5338 / 444-1201	\N		\N	\N		t	\N	\N	\N
b6aeda10-9c02-4caf-b99f-2d51fe9c8bee	ARBUMASA XIV	0213	1116	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	36.40	1047	c0480dd3-e309-4e6d-8620-661c4fdfe0c7	ARBUMASA  S.A.	Puerto Deseado		0297-487-2807 / 444-5338 / 444-1201	\N		\N	\N		t	\N	\N	\N
a426456e-015c-44bb-8680-8e66ad23685c	ARBUMASA XV	214	1118	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	36.40	870	\N	ARBUMASA  S.A.				\N		\N	\N		t	\N	\N	\N
62bf6250-4203-4529-af1c-1174c7ad9a34	ARBUMASA XVI	0215	1119	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	36.40	1047	c0480dd3-e309-4e6d-8620-661c4fdfe0c7	ARBUMASA  S.A.	Puerto Deseado		0297-487-2807 / 444-5338 / 444-1201	\N		\N	\N		t	\N	\N	\N
6adb41cf-36d9-452a-a6b8-5c3eee1195ed	ARBUMASA XVIII	0217	1121	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	36.40	870	c0480dd3-e309-4e6d-8620-661c4fdfe0c7	ARBUMASA  S.A.	Puerto Deseado	4893758	0297-487-2807 / 444-5338 / 444-1201	\N	miguel-visoso@hotmail.com	\N	\N	Agencia Maritima Solvox	t	\N	\N	\N
967e6459-38ea-49e6-89d2-74e5f769cb02	ARBUMASA XXIX	02561	1126	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	65.60	1776	5d12df00-152b-43e6-8ba0-20067e3bac8c	BAL - FISH  S.A.	Mar del Plata		489-6522	\N		\N	\N		t	\N	\N	\N
b58ee391-8bb6-4908-9c66-4d34983bf0e7	ARBUMASA XXVI	01958	1127	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	62.80	2403	c0480dd3-e309-4e6d-8620-661c4fdfe0c7	ARBUMASA  S.A.	Puerto Deseado	4893758	0297-487-2807 / 444-5338 / 444-1201	\N	miguel-visoso@hotmail.com	\N	\N	Agencia Maritima Solvox	t	\N	\N	\N
aa20c626-a8d1-4f80-8871-3d0eb0a854bf	ARBUMASA XXVII	02057	1128	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	64.21	1154	5d12df00-152b-43e6-8ba0-20067e3bac8c	BAL - FISH  S.A.	Mar del Plata		489-6522	\N		\N	\N		t	\N	\N	\N
f4efb7e4-4461-497c-a9e9-b60b52732660	ARBUMASA XXVIII	02569	1129	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	64.40	1776	c0480dd3-e309-4e6d-8620-661c4fdfe0c7	ARBUMASA  S.A.	Puerto Deseado		0297-487-2807 / 444-5338 / 444-1201	\N		\N	\N		t	\N	\N	\N
02ed6e9f-d7af-4643-b190-75ae55185639	ARCANGEL	79	\N	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	\N	\N	5d12df00-152b-43e6-8ba0-20067e3bac8c	CALME  S.A.	Mar del Plata		480-3545	\N		\N	\N		t	\N	\N	\N
fd256085-a387-4182-aa57-7edd645f9756	ARESIT	02265	1134	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	36.26	1085	9e675114-d5e6-449e-a20c-9688499c3c00	HARENGUS  S.A.	Puerto Madryn	4808331/4808332	0280-445-0822	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
a1e66338-7086-44c5-ade8-422e1a32a6da	ARGENOVA I	02180	1137	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	35.00	655	c0480dd3-e309-4e6d-8620-661c4fdfe0c7	ARGENOVA  S.A.	Puerto Deseado	4808331/4808332	0297- 487-0550  (447-2818  Com. Riv )	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
1c5fd1c2-5ca5-4f6e-ad11-970984a4106c	ARGENOVA IV	02157	1140	\N	\N	\N	0	36.26	675	c0480dd3-e309-4e6d-8620-661c4fdfe0c7	MAR DE LAS PALMAS  S.A.	Puerto Deseado	4808331/4808332	0297-487-2112	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
a959485e-0a31-47d1-a281-900700d54692	ARGENOVA X	02329	1146	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	32.50	550	c0480dd3-e309-4e6d-8620-661c4fdfe0c7	ARGENOVA  S.A.	Puerto Deseado	4808331/4808332	0297- 487-0550  (447-2818  Com. Riv )	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
4325432f-0601-4221-8901-847903046c33	ARGENOVA XI	02199	\N	6cee615f-2f06-4187-ae28-3c9e9d5584cf	facaf1bb-b284-4017-ae4d-e423bf92bf7f	a3d52a88-3e07-46f5-b2f4-4c885f36886b	60	\N	\N	c0480dd3-e309-4e6d-8620-661c4fdfe0c7	ARGENOVA  S.A.	Puerto Deseado	4808331/4808332	0297- 487-0550  (447-2818  Com. Riv )	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
e9603c58-cdf7-47dd-a343-2a3b5cf2fc8e	ARGENOVA XXI	02661	2704	d3857412-6a2e-47ef-82e8-ecd2ded34e55	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	1c1f245c-1079-42a0-a6a8-1db4ac5845d4	60	55.80	1826	c0480dd3-e309-4e6d-8620-661c4fdfe0c7	ARGENOVA  S.A.	Puerto Deseado	4808331/4808332	0297- 487-0550  (447-2818  Com. Riv )	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
28968574-9915-41c4-ae46-a0f647d634c2	ARGENOVA XXII	02714	2713	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	40	37.70	663	c0480dd3-e309-4e6d-8620-661c4fdfe0c7	ARGENOVA  S.A.	Puerto Deseado	4808331/4808332	0297- 487-0550  (447-2818  Com. Riv )	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
55c4a50e-3851-407d-a26f-61f7fa6666c3	ARGENOVA XXIII	02713	2707	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	37.19	678	c0480dd3-e309-4e6d-8620-661c4fdfe0c7	ARGENOVA  S.A.	Puerto Deseado	4808331/4808332	0297- 487-0550  (447-2818  Com. Riv )	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
07be4090-5755-4748-b5e7-1f06e079a94e	ARGENOVA XXIV	02752	2731	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	38.80	675	c0480dd3-e309-4e6d-8620-661c4fdfe0c7	ARGENOVA  S.A.	Puerto Deseado	4808331/4808332	0297- 487-0550  (447-2818  Com. Riv )	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
50d03e7a-13c4-449c-8ca9-70b2edba0e86	ARGENOVA XXV	028011	2740	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	39.70	859	c0480dd3-e309-4e6d-8620-661c4fdfe0c7	ARGENOVA  S.A.	Puerto Deseado	4808331/4808332	0297- 487-0550  (447-2818  Com. Riv )	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
7641caf7-39af-40fd-8bf6-f753ec5a13ad	ARGENOVA XXVI	02849	2739	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	37.15	1086	c0480dd3-e309-4e6d-8620-661c4fdfe0c7	ARGENOVA  S.A.	Puerto Deseado	4808331/4808332	0297- 487-0550  (447-2818  Com. Riv )	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
53864b31-1918-45cd-89c0-55f38d25ce3f	ARGENOVA II	02177	1138	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	38.50	1168	c0480dd3-e309-4e6d-8620-661c4fdfe0c7	ARGENOVA  S.A.	Puerto Deseado	4808331/4808332	0297- 487-0550  (447-2818  Com. Riv )	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
1f70d6fb-aba3-4209-9e1a-a5ac2cb0a892	ARGENOVA III	02156	\N	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	\N	\N	c0480dd3-e309-4e6d-8620-661c4fdfe0c7	ARGENOVA  S.A.	Puerto Deseado		0297- 487-0550  (447-2818  Com. Riv )	\N		\N	\N		t	\N	\N	\N
fafae14a-4a68-4b09-bdad-3306ad768dbd	ARGENOVA IX	02328	1141	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	32.50	550	c0480dd3-e309-4e6d-8620-661c4fdfe0c7	ARGENOVA  S.A.	Puerto Deseado	4808331/4808332	0297- 487-0550  (447-2818  Com. Riv )	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
4667e554-9c07-4b6a-a48f-e01e35795297	ARGENOVA XII	0199	\N	6cee615f-2f06-4187-ae28-3c9e9d5584cf	facaf1bb-b284-4017-ae4d-e423bf92bf7f	a3d52a88-3e07-46f5-b2f4-4c885f36886b	60	\N	\N	c0480dd3-e309-4e6d-8620-661c4fdfe0c7	ARGENOVA  S.A.	Puerto Deseado	4808331/4808332	0297- 487-0550  (447-2818  Com. Riv )	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
3c7f336b-bb2c-4c36-867b-ead07fd3d886	ARGENOVA XIV	0197	1149	6cee615f-2f06-4187-ae28-3c9e9d5584cf	facaf1bb-b284-4017-ae4d-e423bf92bf7f	a3d52a88-3e07-46f5-b2f4-4c885f36886b	60	52.30	1352	c0480dd3-e309-4e6d-8620-661c4fdfe0c7	ARGENOVA  S.A.	Puerto Deseado	4808331/4808332	0297- 487-0550  (447-2818  Com. Riv )	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
b2ad1006-6fba-4dc8-8c73-f560a41d830f	ARGENOVA XV	0198	\N	6cee615f-2f06-4187-ae28-3c9e9d5584cf	facaf1bb-b284-4017-ae4d-e423bf92bf7f	a3d52a88-3e07-46f5-b2f4-4c885f36886b	60	\N	\N	c0480dd3-e309-4e6d-8620-661c4fdfe0c7	ARGENOVA  S.A.	Puerto Deseado	4800274	0297- 487-0550  (447-2818  Com. Riv )	\N	amalfitanoycia@hotmail.com	\N	\N	Agencia Maritima Almafitano	t	\N	\N	\N
c6ff5883-aae3-4eb4-b3a8-7cef64a6a0fa	ARGENTINO	0142	1157	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	33.77	1001	5d12df00-152b-43e6-8ba0-20067e3bac8c	PESQUERA VERAZ  S.A.	Mar del Plata		489-4624 / 489-0314 (astillero)	\N		\N	\N		t	\N	\N	\N
383d326f-2367-4a9b-ac4c-e02975269305	ARKOFISH	0236	\N	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	\N	\N	9e675114-d5e6-449e-a20c-9688499c3c00	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
247a7875-7b5e-4416-af35-14249cf812ca	ARKOFISH I	6004	\N	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	\N	\N	9e675114-d5e6-449e-a20c-9688499c3c00	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
821d45ab-0c90-4615-a7d8-436ec4f4aba3	ARRUFO	0540	1165	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	39.16	1102	5d12df00-152b-43e6-8ba0-20067e3bac8c	LUIS SOLIMENO e HIJOS  S.A.	Mar del Plata		489-3030	\N		\N	\N		t	\N	\N	\N
17137b61-015a-4514-86ef-dfa129874b3b	ASUDEPES II	6363	\N	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	\N	\N	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	ASUDEPES  S.A.	Ciudad Autónoma de Buenos Aires		011-4383-9756	\N		\N	\N		t	\N	\N	\N
b8d52f1f-350b-4db3-97a4-c169c79ff6d2	ASUDEPES III	6062	\N	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	\N	\N	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	ASUDEPES  S.A.	Ciudad Autónoma de Buenos Aires		011-4383-9756	\N		\N	\N		t	\N	\N	\N
c3786112-eea9-46fd-ad67-918e6e0f15e3	ATLANTIC EXPRESS	02936	2727	401c7d42-1de7-41b7-820a-948b432b72eb	8ef217f2-61c5-439a-a902-0d110b010653	f4dfbae3-8a9b-4e7a-acba-439207f86b95	30	53.70	3426	5d12df00-152b-43e6-8ba0-20067e3bac8c	WANCHESE ARGENTINA  S.A.	Mar del Plata		489-1236	\N		\N	\N		t	\N	\N	\N
22f33278-5317-48a6-9edb-9cf074ec3275	ATLANTIC SURF I	0350	\N	c9ef52ca-9e27-4d02-aed4-e2e6f8f31b7f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	5524fead-8510-4189-91a2-ac7d39675ece	40	\N	\N	5d12df00-152b-43e6-8ba0-20067e3bac8c	GLACIAR PESQUERA  S.A.	Mar del Plata	4890960	492-2216	\N	agencia@maritimavidal.com.ar	\N	\N	Agencia Maritima Vidal	t	\N	\N	\N
5733a2fe-ec8a-4665-bc9a-a2e09b944857	ATLANTIC SURF III	02030	1176	c9ef52ca-9e27-4d02-aed4-e2e6f8f31b7f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	5524fead-8510-4189-91a2-ac7d39675ece	60	49.60	3020	5d12df00-152b-43e6-8ba0-20067e3bac8c	GLACIAR PESQUERA  S.A.	Mar del Plata	4800274	492-2216	\N	amalfitanoycia@hotmail.com	\N	\N	Agencia Maritima Almafitano	t	\N	\N	\N
a1d19025-1d1e-4a18-8c08-3aac431d1066	ATREVIDO	0145	1180	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	32.50	901	5d12df00-152b-43e6-8ba0-20067e3bac8c	PESQUERA VERAZ  S.A.	Mar del Plata	4800005	489-4624 / 489-0314 (astillero)	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
ef9f791c-b83d-496f-9d0f-2410e03f4657	AURORA	02581	1183	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	67.55	1776	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	KALEU KALEU  S.A.	Ciudad Autónoma de Buenos Aires		011-3220-2130  / 5093-1215	\N		\N	\N		t	\N	\N	\N
7a46a012-d48c-4ab6-8589-e7e908ce382e	BAHIA DESVELOS	0665	1194	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	37.05	791	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	PESQUERA SANTA CRUZ  S.A.	Ciudad Autónoma de Buenos Aires		011-4305-4706	\N		\N	\N		t	\N	\N	\N
d3d6aa68-fe2a-4d10-a21d-6b2dabe885ec	BEAGLE I	6052	1207	b509832f-10d9-4f7d-b71e-5bd4ecf88b38	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	60	59.90	2369	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	YUKEN  S.A.	Ciudad Autónoma de Buenos Aires	4891553-154179360-154179860-154179062	011-5279-1302 / 5236-6069	\N	agenciasmiriglio@speedy.com.ar	\N	\N	Agencia Maritima Smiriglio	t	\N	\N	\N
35f2daeb-f25c-4481-a44a-5dea85195fd1	BELVEDERE	01398	1210	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	26.50	624	5d12df00-152b-43e6-8ba0-20067e3bac8c	PRINMAR  S.A. Buque Motor Belvedere	Mar del Plata		480-0883	\N		\N	\N		t	\N	\N	\N
aa1749af-cc95-49ff-a24e-7cacea7e3c43	BOGAVANTE SEGUNDO	02994	2743	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	37.45	867	9e675114-d5e6-449e-a20c-9688499c3c00	IBERCONSA  DE ARGENTINA  S.A.	Puerto Madryn		0280-445-4324	\N		\N	\N		t	\N	\N	\N
a3185b37-aa7a-497a-bf50-64db212ffecc	BONFIGLIO	01234	\N	6fdf97a3-2f73-4a74-956b-414b0ca85b33	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	\N	10	\N	\N	5d12df00-152b-43e6-8ba0-20067e3bac8c	COSTA BRAVA  S.A.	Mar del Plata		489-7538	\N		\N	\N		t	\N	\N	\N
0aacfbc7-e087-432a-8189-00d9f83c744b	BORRASCA	01095	1218	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	39.16	1083	5d12df00-152b-43e6-8ba0-20067e3bac8c	LUIS SOLIMENO e HIJOS  S.A.	Mar del Plata		489-3030	\N		\N	\N		t	\N	\N	\N
8bbb1e8f-8a1d-41b4-8a4a-d4bd19b0c5a7	BOUCIÑA	01637	1221	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	0.00	0	5d12df00-152b-43e6-8ba0-20067e3bac8c	CALME  S.A.	Mar del Plata	4800005	480-3545	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
d7718b8d-2a6b-485c-b3bc-677020147470	BUENA PESCA	01475	2717	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	39.10	1479	5d12df00-152b-43e6-8ba0-20067e3bac8c	PEDRO MOSCUZZA e HIJOS  S.A.	Mar del Plata		489-7287	\N		\N	\N		t	\N	\N	\N
f4da8aee-0366-4576-83b4-77cae17e9aea	CABO BUEN TIEMPO	025	\N	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	\N	\N	9e675114-d5e6-449e-a20c-9688499c3c00	ALPESCA  S.A.	Puerto Madryn		0280-447-4958 / 45-1069	\N		\N	\N		t	\N	\N	\N
370c560a-9340-405f-8eef-2cbf507fc284	CABO BUENA ESPERANZA	02482	\N	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	\N	\N	5d12df00-152b-43e6-8ba0-20067e3bac8c	UNIVERSAL PESQUERA  SRL	Mar del Plata		489-0352	\N		\N	\N		t	\N	\N	\N
88b09db8-ee99-4524-8177-3b94c0639ade	CABO DE HORNOS	01537	\N	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	\N	\N	5d12df00-152b-43e6-8ba0-20067e3bac8c	MILANI Y PATANE  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
75212f9c-391c-4e6a-a4e0-d2df1cae27cb	CABO DOS BAHIAS	02483	\N	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	\N	\N	9e675114-d5e6-449e-a20c-9688499c3c00	ALPESCA  S.A.	Puerto Madryn		0280-447-4958 / 45-1069	\N		\N	\N		t	\N	\N	\N
32451b18-ae92-4244-9f5c-15a07545d89e	CABO SAN JUAN	023	\N	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	\N	\N	9e675114-d5e6-449e-a20c-9688499c3c00	ALPESCA  S.A.	Puerto Madryn		0280-447-4958 / 45-1069	\N		\N	\N		t	\N	\N	\N
87e04e75-e9c4-41d6-9cd0-e9a7214c2a2f	CABO SAN SEBASTIAN	022	\N	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	\N	\N	9e675114-d5e6-449e-a20c-9688499c3c00	ALPESCA  S.A.	Puerto Madryn		0280-447-4958 / 45-1069	\N		\N	\N		t	\N	\N	\N
0431cd48-f0d3-47b9-b2c6-d9f1597a8b12	CABO TRES PUNTAS	01483	1242	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	31.43	721	5d12df00-152b-43e6-8ba0-20067e3bac8c	OSTRAMAR  S.A.	Mar del Plata		489-1959	\N		\N	\N		t	\N	\N	\N
c66e4d66-a0fb-4653-ad76-f8e4f005062b	CABO VIRGENES	024	\N	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	\N	\N	9e675114-d5e6-449e-a20c-9688499c3c00	ALPESCA  S.A.	Puerto Madryn		0280-447-4958 / 45-1069	\N		\N	\N		t	\N	\N	\N
58dfa90d-b8a3-403f-b43d-b641d6e986e2	CALABRIA	0567	1245	6fdf97a3-2f73-4a74-956b-414b0ca85b33	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	\N	4	19.63	266	9e675114-d5e6-449e-a20c-9688499c3c00	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
b14ffa4d-1945-4846-be34-c4b64bea3adc	CALIZ	02809	0	6fdf97a3-2f73-4a74-956b-414b0ca85b33	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	\N	4	20.20	545	b0b3126f-6cd0-4ab9-91db-f70b14747ee8	FLOTA AMARILLA RAWSON	Rawson			\N		\N	\N		t	\N	\N	\N
10037fb8-1d5b-4d56-8fb9-bcf209e7dc84	CALLEJA	06276	1249	6fdf97a3-2f73-4a74-956b-414b0ca85b33	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	\N	10	21.83	503	5d12df00-152b-43e6-8ba0-20067e3bac8c	OTESA  S.A.	Mar del Plata		493-5606	\N		\N	\N		t	\N	\N	\N
9087e277-8a46-4878-a1b9-c3e6432476d4	CAMERIGE	01406	1252	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	27.90	652	5d12df00-152b-43e6-8ba0-20067e3bac8c	PESQUERA  MARGARITA  S.A.	Mar del Plata	4891553-154179360-154179860-154179062	489-4645   /   489-2946	\N	agenciasmiriglio@speedy.com.ar	\N	\N	Agencia Maritima SMIRIGLIO	t	\N	\N	\N
87a67ce2-48b3-4df7-a0af-388ca348e22f	CANAL DE BEAGLE	0407	0	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	23.90	501	5d12df00-152b-43e6-8ba0-20067e3bac8c	CANAL DE BEAGLE  S.R.L.	Mar del Plata		480-4447	\N		\N	\N		t	\N	\N	\N
9c05f19b-cb5b-4597-8498-ced13f6dfa1c	CAPESANTE	02929	2723	c9ef52ca-9e27-4d02-aed4-e2e6f8f31b7f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	5524fead-8510-4189-91a2-ac7d39675ece	40	50.15	2550	5d12df00-152b-43e6-8ba0-20067e3bac8c	GLACIAR PESQUERA  S.A.	Mar del Plata		492-2216	\N		\N	\N		t	\N	\N	\N
5b6c3c41-0bde-4bb0-8d9f-e9c518883d8a	CAPITAN CANEPA	059F	\N	ec991fe3-facd-4b3a-9721-af02673136d1	\N	\N	28	\N	\N	5d12df00-152b-43e6-8ba0-20067e3bac8c	INIDEP	Mar del Plata		451-7442 ó 486-2586 int 162	\N		\N	\N		t	\N	\N	\N
f7c92832-36e4-411c-b5fc-0cc95f8d282d	CAPITAN GIACHINO	0151	1260	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	38.42	1062	5d12df00-152b-43e6-8ba0-20067e3bac8c	KALARI S.A.	Mar del Plata		489-1959	\N		\N	\N		t	\N	\N	\N
a5871e26-8111-4583-abf1-0b6d2a5b3b11	CAPITAN OCA BALDA	060F	\N	ec991fe3-facd-4b3a-9721-af02673136d1	\N	\N	21	\N	\N	5d12df00-152b-43e6-8ba0-20067e3bac8c	INIDEP	Mar del Plata		451-7442 ó 486-2586 int 162	\N		\N	\N		t	\N	\N	\N
874676b2-dde5-4683-8f31-53dc70c5ea5a	CARMEN A	02045	1269	6fdf97a3-2f73-4a74-956b-414b0ca85b33	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	\N	4	15.30	223	b0b3126f-6cd0-4ab9-91db-f70b14747ee8	FLOTA AMARILLA RAWSON	Rawson			\N		\N	\N		t	\N	\N	\N
c8520d57-6f26-4ad0-8220-dd5206243120	CAROLINA P	0176	1272	d3857412-6a2e-47ef-82e8-ecd2ded34e55	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	1c1f245c-1079-42a0-a6a8-1db4ac5845d4	60	71.60	1976	9e675114-d5e6-449e-a20c-9688499c3c00	ESTRELLA PATAGONICA S.A.	Puerto Madryn		0280-445-4407	\N		\N	\N		t	\N	\N	\N
a484de1f-c99a-425d-a09e-0dfa17e48276	CEIBE DOUS	0336	1276	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	40.70	738	9e675114-d5e6-449e-a20c-9688499c3c00	IBERCONSA  DE ARGENTINA  S.A.	Puerto Madryn	4800274	0280-445-4324	\N	amalfitanoycia@hotmail.com	\N	\N	Agencia Maritima Almafitano	t	\N	\N	\N
a3561d1d-6da1-4e4b-bebf-ff55987e1477	CENTAURO 2000	0482	1278	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	35.50	1302	5d12df00-152b-43e6-8ba0-20067e3bac8c	PESQUERA VERAZ  S.A.	Mar del Plata		489-4624 / 489-0314 (astillero)	\N		\N	\N		t	\N	\N	\N
e8cc008c-3c59-4231-987a-38e7d76c4607	CENTURION DEL ATLANTICO	0237	1280	d3857412-6a2e-47ef-82e8-ecd2ded34e55	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	1c1f245c-1079-42a0-a6a8-1db4ac5845d4	60	112.80	8111	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	ESTREMAR  S.A.	Ciudad Autónoma de Buenos Aires		011-6533-7853 / 4345-1102	\N		\N	\N		t	\N	\N	\N
956a4382-a67a-45ed-a8a4-cc67cfa8bc12	CERES	01420	1281	b509832f-10d9-4f7d-b71e-5bd4ecf88b38	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	60	60.74	1969	5d12df00-152b-43e6-8ba0-20067e3bac8c	PESQUERA CERES  S.A.	Mar del Plata		410-0051 / 7	\N		\N	\N		t	\N	\N	\N
31281f6d-77e5-432b-9b18-540f9c6a4d47	CHANG BO GO I	06190	\N	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	\N	\N	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	ARPEPA  M.C.I.S.A.	Ciudad Autónoma de Buenos Aires		011-4382-1605	\N		\N	\N		t	\N	\N	\N
38ed0167-8f80-4e2c-8fc4-bd5f002ea979	CHATKA I	02893	0	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	16.73	195	9e675114-d5e6-449e-a20c-9688499c3c00	FOOD PARTNERS PATAGONIA S.A.	Puerto Madryn		0280-4458579 / 5225	\N		\N	\N		t	\N	\N	\N
950aa2fe-c76b-4af8-a2a6-dd3aa60d5d4a	CHIARPESCA 56	01090	\N	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	\N	\N	5d12df00-152b-43e6-8ba0-20067e3bac8c	APOLO FISH  S.A.	Mar del Plata		489-4519 / 489-1133	\N		\N	\N		t	\N	\N	\N
1ca47e42-180b-423f-a87b-4c0050e77677	CHIARPESCA 57	01029	\N	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	\N	\N	5d12df00-152b-43e6-8ba0-20067e3bac8c	CHIARPESCA  S.A.	Mar del Plata		489-1385	\N		\N	\N		t	\N	\N	\N
01a2f1e0-7fcb-4366-8088-52c8a25b2280	CHIARPESCA 902	02110	\N	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	\N	\N	5d12df00-152b-43e6-8ba0-20067e3bac8c	CHIARPESCA  S.A.	Mar del Plata		489-1385	\N		\N	\N		t	\N	\N	\N
ba18e8e1-1847-4b67-8c07-660d1f90953b	CHIARPESCA 903	02109	\N	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	\N	\N	5d12df00-152b-43e6-8ba0-20067e3bac8c	CHIARPESCA  S.A.	Mar del Plata		489-1385	\N		\N	\N		t	\N	\N	\N
f1a9f401-eb5c-429e-aeee-c4428a78e346	CHIYO MARU Nº 3	02987	2745	401c7d42-1de7-41b7-820a-948b432b72eb	8ef217f2-61c5-439a-a902-0d110b010653	f4dfbae3-8a9b-4e7a-acba-439207f86b95	30	52.80	937	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	CRUSTACEOS DEL SUR  S.A.	Ciudad Autónoma de Buenos Aires		011-5218-4287	\N		\N	\N		t	\N	\N	\N
bcc6f442-e765-4587-ab32-91aa96ea463c	CHOCO MARU 68	JA13	\N	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	\N	\N	5d12df00-152b-43e6-8ba0-20067e3bac8c	PESQUERA COMERCIAL  S.A.	Mar del Plata		489-3030	\N		\N	\N		t	\N	\N	\N
9e883963-2d7d-42d3-8e6b-6623951fe2e0	CHOKYU MARU Nº 18.	2584	1312	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	68.70	1777	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	BAHIA GRANDE  S.A.	Ciudad Autónoma de Buenos Aires		011-5272-0850 / 5254-1133	\N		\N	\N		t	\N	\N	\N
53c83741-1ed1-4098-a665-751d389afb02	CINCOMAR 1	0439	\N	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	\N	\N	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	CINCOMAR  S.A.	Ciudad Autónoma de Buenos Aires		011-4326-4991	\N		\N	\N		t	\N	\N	\N
277a3a3b-799c-4e33-9e03-71155a83505d	CINCOMAR 5	02351	\N	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	\N	\N	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	CINCOMAR  S.A.	Ciudad Autónoma de Buenos Aires		011-4326-4991	\N		\N	\N		t	\N	\N	\N
17c9c958-3bf1-4e11-af75-06ef0a46cc1f	CIUDAD DE HUELVA	01519	1324	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	27.45	426	9e675114-d5e6-449e-a20c-9688499c3c00	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
d2fcf829-5cd6-42ed-9291-9914c07c566e	CIUDAD FELIZ	0910	2721	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	28.56	458	5d12df00-152b-43e6-8ba0-20067e3bac8c	CARAVON S.A.	Mar del Plata		489-9404	\N		\N	\N		t	\N	\N	\N
e9741ecc-27c4-46c8-aeab-7053baacb7f6	CLAUDIA	02183	\N	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	\N	\N	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	LUXMARINO  S.A.	Ciudad Autónoma de Buenos Aires		011-4342-2621	\N		\N	\N		t	\N	\N	\N
e5b5fa88-b389-437d-afac-bd8b52e48189	CLAUDINA	02345	1331	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	53.58	937	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	ARMADORA  ACRUX  S.A.	Ciudad Autónoma de Buenos Aires		011-4312-6470	\N		\N	\N		t	\N	\N	\N
b8a97139-5298-48e8-93e0-0f3f9a12b207	COALSA SEGUNDO	0790	1333	b509832f-10d9-4f7d-b71e-5bd4ecf88b38	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	60	76.20	2960	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	YUKEN  S.A.	Ciudad Autónoma de Buenos Aires		011-5279-1302 / 5236-6069	\N		\N	\N		t	\N	\N	\N
739bfcae-579a-480b-9a09-750957325ef3	CODEPECA  I	0497	\N	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	\N	\N	9e675114-d5e6-449e-a20c-9688499c3c00	HARENGUS  S.A.	Puerto Madryn		0280-445-0822	\N		\N	\N		t	\N	\N	\N
36c14dbe-465f-4fa6-a78d-a8fa1f4db817	CODEPECA  II	0498	\N	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	\N	\N	9e675114-d5e6-449e-a20c-9688499c3c00	HARENGUS  S.A.	Puerto Madryn		0280-445-0822	\N		\N	\N		t	\N	\N	\N
36f1a460-a9aa-4207-8af8-ba09bef541dd	CODEPECA  III	0506	\N	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	\N	\N	9e675114-d5e6-449e-a20c-9688499c3c00	HARENGUS  S.A.	Puerto Madryn		0280-445-0822	\N		\N	\N		t	\N	\N	\N
690930ac-da2e-4ebc-9603-e2e5b92e89c6	CODEPECA IV	01012	\N	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	\N	\N	9e675114-d5e6-449e-a20c-9688499c3c00	PEREIRA  ARGENTINA  S.A.	Puerto Madryn		0280-445-7377 / 447-2249	\N		\N	\N		t	\N	\N	\N
11f41119-3430-4452-a36e-b5de3428e7f9	COMANDANTE LUIS PIEDRABUENA	0767	1340	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	25.00	501	5d12df00-152b-43e6-8ba0-20067e3bac8c	COMANDANTE PIEDRABUENA  S.R.L.	Mar del Plata		489-9404	\N		\N	\N		t	\N	\N	\N
99cced41-464e-4ceb-8b9b-0a09ceed887a	COMETA	0919	\N	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	\N	\N	5d12df00-152b-43e6-8ba0-20067e3bac8c	VICARP  S.A.	Mar del Plata		480-4378	\N		\N	\N		t	\N	\N	\N
1c0f6c67-c720-4c2a-b467-34e7abe42fcf	CONARA I	0201	\N	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	\N	\N	9e675114-d5e6-449e-a20c-9688499c3c00	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
f419f2c3-9879-4d6d-bb45-30c45e655caa	CONARPESA I	0200	1344	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	52.50	1482	9e675114-d5e6-449e-a20c-9688499c3c00	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
932f54b6-b272-48e1-bc09-dedea00b748b	CORAJE	0645	1359	\N	\N	\N	0	28.28	426	5d12df00-152b-43e6-8ba0-20067e3bac8c	IBERCONSA  DE ARGENTINA  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
a5649353-4259-4849-86f6-d0a8f5068f60	CORAL  AZUL	06127	\N	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	\N	\N	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	NOVAMAR  S.A.	Ciudad Autónoma de Buenos Aires		011-4345-6688	\N		\N	\N		t	\N	\N	\N
bd511786-848b-4158-9e73-5f9792b17087	CORAL BLANCO	06137	\N	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	\N	\N	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	NOVAMAR  S.A.	Ciudad Autónoma de Buenos Aires		011-4345-6688	\N		\N	\N		t	\N	\N	\N
49f4b919-2ee1-46e5-b202-71638b760639	CORMORAN	01611	\N	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	\N	\N	5d12df00-152b-43e6-8ba0-20067e3bac8c	ANTONIO BARILLARI  S.A.	Mar del Plata		481-1173  / 489-0872	\N		\N	\N		t	\N	\N	\N
f6294f89-3d50-418d-b078-b676a113b884	COSTAMAR	01549	\N	6fdf97a3-2f73-4a74-956b-414b0ca85b33	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	\N	4	\N	\N	b0b3126f-6cd0-4ab9-91db-f70b14747ee8	INDUSTRIA  PESQUERA  PATAGONICA  S.A.	Trelew		0280-444-6577	\N		\N	\N		t	\N	\N	\N
83524b34-f52a-458b-9314-f08f1a7710ce	CRISTO REDENTOR	01185	1374	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	31.00	642	c0480dd3-e309-4e6d-8620-661c4fdfe0c7	PESQUERA DESEADO  S.A.	Puerto Deseado		0297-487-0884 / 0327 / 2407	\N		\N	\N		t	\N	\N	\N
1c6a33e8-88c5-4e37-bb6d-7b26ae979121	DASA 508	0499	\N	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	\N	\N	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	PESQUERA  DONGAH  ARGENTINA  S.A.	Ciudad Autónoma de Buenos Aires		011-4815-5525	\N		\N	\N		t	\N	\N	\N
65ff51e3-ed4b-4fd2-9919-bfd58b71ddb9	DASA 757	02200	\N	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	\N	\N	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	PESQUERA  DONGAH  ARGENTINA  S.A.	Ciudad Autónoma de Buenos Aires		011-4815-5525	\N		\N	\N		t	\N	\N	\N
06c2c54b-dff6-4be2-a9d9-1f5a3894cd3f	DEMOSTENES	0113	\N	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	\N	\N	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	AGUA MARINA  S.A.	Ciudad Autónoma de Buenos Aires		011-4342-0605 / 5656 / 1709	\N		\N	\N		t	\N	\N	\N
3dca0422-bea8-4ce8-96d4-07a9e967175f	DESTINY	3209	\N	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	\N	\N	\N	WANCHESE ARGENTINA  S.A.				\N		\N	\N		t	\N	\N	\N
12a5b07c-1c44-4ddc-8bd4-87a26634a11d	DEPASUR  I	0330	\N	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	\N	\N	9e675114-d5e6-449e-a20c-9688499c3c00	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
44bc8c0c-22df-48c1-9978-57ff6383c672	DEPEMAS 51	0239	\N	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	\N	\N	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	DEPEMAS  S.A.	Ciudad Autónoma de Buenos Aires		011-4372-7909  /  4382-5382	\N		\N	\N		t	\N	\N	\N
d3b7fe59-0f1e-4bb3-a801-3c3186fd3197	DEPEMAS 81	0281	\N	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	\N	\N	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	PESQUERA ORION  S.A.	Ciudad Autónoma de Buenos Aires		011-4343-9327	\N		\N	\N		t	\N	\N	\N
9c55faf1-7609-4f2c-9e05-7bb56b55238d	DESAFIO	0177	1398	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	29.56	850	5d12df00-152b-43e6-8ba0-20067e3bac8c	PESQUERA VERAZ  S.A.	Mar del Plata		489-4624 / 489-0314 (astillero)	\N		\N	\N		t	\N	\N	\N
b29e5020-9717-41d7-8053-918e5ec8d637	DESEADO	01598	1400	6fdf97a3-2f73-4a74-956b-414b0ca85b33	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	\N	4	19.00	301	b0b3126f-6cd0-4ab9-91db-f70b14747ee8	FLOTA AMARILLA RAWSON	Rawson			\N		\N	\N		t	\N	\N	\N
7382feeb-867f-4cfe-ae67-9d4695b8840d	DIEGO PRIMERO	01725	\N	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	\N	\N	5d12df00-152b-43e6-8ba0-20067e3bac8c	PESQUERA DIEGO PRIMERO  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
9ce93a19-ae53-4efd-9413-4e5c4a5571da	DON JUAN ALVAREZ	3300	\N	ec3c9169-b5ef-475f-bcbe-9f0b08dce26e	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	\N	\N	\N	\N	\N	CONARPESA  S.A.				\N		\N	\N		t	\N	\N	\N
7b1b58ed-7e26-46da-8e00-78f0f2706381	DON  NATALIO	01183	\N	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	\N	\N	5d12df00-152b-43e6-8ba0-20067e3bac8c	14 DE JULIO  S.A.	Mar del Plata		480-3545	\N		\N	\N		t	\N	\N	\N
eb694e4d-f948-45a0-a5fe-6106c7f5268f	DON AGUSTIN	0968	\N	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	\N	\N	5d12df00-152b-43e6-8ba0-20067e3bac8c	PESQUERA  MARGARITA  S.A.	Mar del Plata		489-4645   /   489-2946	\N		\N	\N		t	\N	\N	\N
6e173086-7f77-43a0-afaf-4331a8b01cf9	DON ANTONIO	0029	1411	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	27.80	549	5d12df00-152b-43e6-8ba0-20067e3bac8c	GIORNO  S.A.	Mar del Plata		410-0051 / 0057	\N		\N	\N		t	\N	\N	\N
d5d74558-12d5-46e0-a15f-a6f9de29d0c4	DON CARMELO	01320	1416	6fdf97a3-2f73-4a74-956b-414b0ca85b33	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	\N	8	19.04	424	5d12df00-152b-43e6-8ba0-20067e3bac8c	MARFE  S.A.	Mar del Plata	4800005	480-0102	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
140130e0-75b2-42f3-be66-98634ce359d9	DON CAYETANO	0579	1417	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	47.10	1503	5d12df00-152b-43e6-8ba0-20067e3bac8c	PEDRO MOSCUZZA e HIJOS  S.A.	Mar del Plata	4890960	489-7287	\N	agencia@maritimavidal.com.ar	\N	\N	Agencia Maritima Vidal	t	\N	\N	\N
91fa3aab-dc6b-4576-bfd2-6668213edf43	DON FRANCISCO I	2562	1428	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	66.55	1776	5d12df00-152b-43e6-8ba0-20067e3bac8c	EL MARISCO  S.A.	Mar del Plata	480-7779 - HERNAN	489-0384	\N	agenciasenoransmdp@yahoo.com	\N	\N	Agencia Maritima SEÑORANS	t	\N	\N	\N
55c2763a-a929-49c1-9517-9aa290e204ad	DON GAETANO	071	1430	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	32.10	889	5d12df00-152b-43e6-8ba0-20067e3bac8c	LINEAERRE  S.A.	Mar del Plata		480-0312	\N		\N	\N		t	\N	\N	\N
7058e3cf-178f-4fd6-9516-59d7c973d70c	DON GIULIANO	02025	1431	6fdf97a3-2f73-4a74-956b-414b0ca85b33	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	\N	4	17.10	220	b0b3126f-6cd0-4ab9-91db-f70b14747ee8	FLOTA AMARILLA RAWSON	Rawson			\N		\N	\N		t	\N	\N	\N
cb869b0b-d493-43b1-a935-53946b7c0aa3	DON JOSE	00892	1434	6fdf97a3-2f73-4a74-956b-414b0ca85b33	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	\N	8	16.49	269	5d12df00-152b-43e6-8ba0-20067e3bac8c	VENTO DI TERRA  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
77fae0ec-ae21-4384-99b4-27fccddf6a44	DON JOSE DI BONA	02241	1435	6fdf97a3-2f73-4a74-956b-414b0ca85b33	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	\N	4	19.85	301	b0b3126f-6cd0-4ab9-91db-f70b14747ee8	PROA  AL SUR  S.R.L.	Rawson			\N		\N	\N		t	\N	\N	\N
9e13caf2-43f2-4026-b0c7-efd8db3fe864	DON JUAN	01397	1437	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	27.00	425	\N	PESQUERA DON JUAN  S.A.				\N		\N	\N		t	\N	\N	\N
1a54bcfb-9c38-4ea3-ad2e-bea55f60e16b	DON JUAN D´AMBRA	5174	\N	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	\N	\N	5d12df00-152b-43e6-8ba0-20067e3bac8c	PESCA ANGELA  S.A.	Mar del Plata		626-2236 /37	\N		\N	\N		t	\N	\N	\N
b75469d8-ff45-4f6d-90b3-9850fc28d204	DON LUCIANO	069	\N	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	\N	\N	5d12df00-152b-43e6-8ba0-20067e3bac8c	TATURIELLO  S.A.	Mar del Plata		489-3833	\N		\N	\N		t	\N	\N	\N
0ec9005b-6b77-4893-8ea8-601e0890d630	DON LUIS I	02093	1445	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	67.95	1803	5d12df00-152b-43e6-8ba0-20067e3bac8c	PESQUERA CERES  S.A.	Mar del Plata		410-0051 / 7	\N		\N	\N		t	\N	\N	\N
c3ae2432-26da-40bc-9f2a-05c47714c768	DON MIGUEL 1°	0748	\N	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	\N	\N	5d12df00-152b-43e6-8ba0-20067e3bac8c	PESQUERA EL NAZARENO	Mar del Plata	4895032 Emanuel	489-9414 (of. Pers. Emb.)	\N	operacionesconsultoramaritima@gmail.com	\N	\N	Consultora Maritima Merlini	t	\N	\N	\N
272f8c89-fd2f-4b23-940b-9f7af02a4b88	DON NICOLA	0893	1450	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	28.14	856	5d12df00-152b-43e6-8ba0-20067e3bac8c	PEZ ESPADA  S.A.	Mar del Plata		480-0846	\N		\N	\N		t	\N	\N	\N
2f8a69e7-fb7b-4b68-a463-ae0ecba8636f	DON OSCAR	02184	\N	6fdf97a3-2f73-4a74-956b-414b0ca85b33	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	\N	4	\N	\N	b0b3126f-6cd0-4ab9-91db-f70b14747ee8	FLOTA AMARILLA RAWSON	Rawson	4800005		\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
8b8211c8-11c3-45cf-89f1-e0a702e9e450	DON PEDRO	068	\N	b509832f-10d9-4f7d-b71e-5bd4ecf88b38	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	60	\N	\N	5d12df00-152b-43e6-8ba0-20067e3bac8c	PEDRO MOSCUZZA e HIJOS  S.A.	Mar del Plata		489-7287	\N		\N	\N		t	\N	\N	\N
594b81fd-859c-4d1d-8ea0-c06851d0b734	DON RAIMUNDO	01431	1463	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	10	25.60	624	5d12df00-152b-43e6-8ba0-20067e3bac8c	DON RAIMUNDO S.R.L.	Mar del Plata		489-3780	\N		\N	\N		t	\N	\N	\N
772c79cb-625f-4d18-b0e8-2f0bca36974c	DON ROMEO ERSINI	0972	\N	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	\N	\N	5d12df00-152b-43e6-8ba0-20067e3bac8c	PESQUERA  MARGARITA  S.A.	Mar del Plata	4891553-154179360-154179860-154179062	489-4645   /   489-2946	\N	agenciasmiriglio@speedy.com.ar	\N	\N	Agencia Smiriglio	t	\N	\N	\N
3efbb230-c38f-4f74-836e-e053a4c30602	DON SANTIAGO	01733	1467	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	10	26.55	776	5d12df00-152b-43e6-8ba0-20067e3bac8c	SAN JORGE S.A.	Mar del Plata		480-6611	\N		\N	\N		t	\N	\N	\N
099e4ea5-431c-400c-b0df-a295d90154cb	DON TOMASSO	02310	1468	6fdf97a3-2f73-4a74-956b-414b0ca85b33	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	\N	4	17.00	356	b0b3126f-6cd0-4ab9-91db-f70b14747ee8	FLOTA AMARILLA RAWSON	Rawson			\N		\N	\N		t	\N	\N	\N
e14e5585-7b59-4f78-8ce3-e215dcfbdba5	DON TURI	01540	1470	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	28.62	839	5d12df00-152b-43e6-8ba0-20067e3bac8c	DON TURI  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
5a395fda-0c4c-41d4-8a6f-5535c797c6cf	DON VICENTE VUOSO	0539	1474	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	20.69	537	5d12df00-152b-43e6-8ba0-20067e3bac8c	VUOSO HNOS. S.R.L.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
33155c11-ba1e-4e33-9d2e-f54220078ac0	DOÑA ALFIA	0512	1483	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	20.70	426	5d12df00-152b-43e6-8ba0-20067e3bac8c	ANTONIO BARILLARI  S.A.	Mar del Plata		481-1173  / 489-0872	\N		\N	\N		t	\N	\N	\N
e3dcb60f-5c4f-4d0c-b1ad-7d5c12d9d6e4	Dr. EDUARDO L. HOLMBERG	061F	\N	ec991fe3-facd-4b3a-9721-af02673136d1	\N	\N	24	\N	\N	5d12df00-152b-43e6-8ba0-20067e3bac8c	INIDEP	Mar del Plata		451-7442 ó 486-2586 int 162	\N		\N	\N		t	\N	\N	\N
8d3baa92-31d9-43d1-bd6c-bfde522ca762	DUKAT	02775	2712	401c7d42-1de7-41b7-820a-948b432b72eb	8ef217f2-61c5-439a-a902-0d110b010653	f4dfbae3-8a9b-4e7a-acba-439207f86b95	30	50.80	1302	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	CRUSTACEOS DEL SUR  S.A.	Ciudad Autónoma de Buenos Aires		011-5218-4287	\N		\N	\N		t	\N	\N	\N
c15ee044-9471-45a9-b364-592713e66ad9	ECHIZEN MARU	0326	1495	d3857412-6a2e-47ef-82e8-ecd2ded34e55	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	1c1f245c-1079-42a0-a6a8-1db4ac5845d4	60	89.59	4702	c86100f2-ae86-47fd-999d-36b482dc11fc	PESANTAR  S.A. ( Empresa Pesq de la Patagonia y Antartida )	Ushuaia		02901-43-3449 / 43-0008 / 43-0708	\N		\N	\N		t	\N	\N	\N
9cb207e3-85d5-4e82-9f64-c514217ebb97	EL MALO I	02350	\N	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	4	\N	\N	b0b3126f-6cd0-4ab9-91db-f70b14747ee8	NOGALES NOGALES  S. De HECHO	Rawson	4890960		\N	agencia@maritimavidal.com.ar	\N	\N	Agencia Maritima Vidal	t	\N	\N	\N
39e238ca-4f71-4dfe-b90b-c042d7189a1a	EL MARISCO I	0912	1516	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	27.22	426	5d12df00-152b-43e6-8ba0-20067e3bac8c	EL MARISCO  S.A.	Mar del Plata	4890960	489-0384	\N	agencia@maritimavidal.com.ar	\N	\N	Agencia Maritima Vidal	t	\N	\N	\N
f4c4ff22-5c87-416c-86d8-3c33f7e5ce69	EL MARISCO II	0915	1517	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	56.30	1407	5d12df00-152b-43e6-8ba0-20067e3bac8c	EL MARISCO  S.A.	Mar del Plata		489-0384	\N		\N	\N		t	\N	\N	\N
6a457420-7e58-40e0-9828-a5180560db7b	EL SANTO	05970	\N	6fdf97a3-2f73-4a74-956b-414b0ca85b33	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	\N	0	\N	\N	c0480dd3-e309-4e6d-8620-661c4fdfe0c7	VUOGAFE  S.A.	Puerto Deseado		0297-155-940853	\N		\N	\N		t	\N	\N	\N
50a961b1-e26f-4abb-bf12-5fd6d4f0c26c	EMILIA MARIA	01390	1543	6fdf97a3-2f73-4a74-956b-414b0ca85b33	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	\N	10	22.60	521	5d12df00-152b-43e6-8ba0-20067e3bac8c	COSTA BRAVA  S.A.	Mar del Plata		489-7538	\N		\N	\N		t	\N	\N	\N
3e87c5e5-88ce-4bf7-a4df-02b55e557f41	EMPESUR II	01439	\N	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	\N	\N	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	EMPESUR  S.A.	Ciudad Autónoma de Buenos Aires		011-4312-0123	\N		\N	\N		t	\N	\N	\N
dc2f2ea6-3eba-4b79-815c-cb011e2e1128	EMPESUR III	01438	\N	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	\N	\N	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	EMPESUR  S.A.	Ciudad Autónoma de Buenos Aires		011-4312-0123	\N		\N	\N		t	\N	\N	\N
30d7df4f-aa4f-4f5a-bb29-dd48ccd79740	EMPESUR V	02650	2705	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	30.52	1369	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	EMPESUR  S.A.	Ciudad Autónoma de Buenos Aires		011-4312-0123	\N		\N	\N		t	\N	\N	\N
6da6769b-003b-43bd-9cb7-a6d1dbdca0fe	EMPESUR VI	02983	2749	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	35.03	1289	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	EMPESUR  S.A.	Ciudad Autónoma de Buenos Aires		011-4312-0123	\N		\N	\N		t	\N	\N	\N
118d9fa3-ef91-4da8-85d9-4831cc3d9896	EMPESUR VII	03045	2754	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	35.03	1290	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	EMPESUR  S.A.	Ciudad Autónoma de Buenos Aires		011-4312-0123	\N		\N	\N		t	\N	\N	\N
d192bc60-615a-46e3-b33f-1a0b29dc6af1	El marisco s.a	02070	\N	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	\N	\N	9e675114-d5e6-449e-a20c-9688499c3c00	FISHING WORLD  S.A.	Puerto Madryn	4800005	0280-445-6533	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
8d80bf77-312b-4cad-9aad-7811c81edc94	ENTRENA UNO	02069	1551	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	33.10	839	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	FOOD ARTS  S.A.	Ciudad Autónoma de Buenos Aires		POR MAILlazuaje@foodarts.com.ar	\N		\N	\N		t	\N	\N	\N
95427e4e-19ee-45ac-a07d-2d969dca0ac3	ERIN BRUCE	0537	1553	c9ef52ca-9e27-4d02-aed4-e2e6f8f31b7f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	5524fead-8510-4189-91a2-ac7d39675ece	30	53.60	2252	5d12df00-152b-43e6-8ba0-20067e3bac8c	WANCHESE ARGENTINA  S.A.	Mar del Plata		489-1236	\N		\N	\N		t	\N	\N	\N
50830bce-68a4-4ec9-a8df-9b44be25f87c	ERIN BRUCE II	TEMP-0002	\N	c9ef52ca-9e27-4d02-aed4-e2e6f8f31b7f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	5524fead-8510-4189-91a2-ac7d39675ece	\N	\N	\N	\N					\N		\N	\N		t	\N	\N	\N
5bdc3660-9270-4859-bd9d-6d77abab74a4	ESAMAR N° 4	0467	\N	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	\N	\N	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	ESAMAR  S.A.	Ciudad Autónoma de Buenos Aires		011-4393-8431	\N		\N	\N		t	\N	\N	\N
5fd302a8-d330-4c11-984b-f6ff8989e63d	ESPADARTE	02048	1558	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	68.20	1529	c0480dd3-e309-4e6d-8620-661c4fdfe0c7	PESQUERA DESEADO  S.A.	Puerto Deseado		0297-487-0884 / 0327 / 2407	\N		\N	\N		t	\N	\N	\N
52c3c745-1b45-4087-959e-1d50e88462f2	ESPERANZA 909	02577	1559	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	72.34	1678	5d12df00-152b-43e6-8ba0-20067e3bac8c	CHIARPESCA  S.A.	Mar del Plata		489-1385	\N		\N	\N		t	\N	\N	\N
7b0c6d15-549d-48e3-b7cb-1d976df53320	ESPERANZA DEL SUR	02751	\N	ec55ad96-050b-4968-a508-4d438deab9f6	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	60	\N	\N	c86100f2-ae86-47fd-999d-36b482dc11fc	PESANTAR  S.A. ( Empresa Pesq de la Patagonia y Antartida )	Ushuaia		02901-43-3449 / 43-0008 / 43-0708	\N		\N	\N		t	\N	\N	\N
853050de-5b3b-4bc1-8929-cd95fd4467e3	ESPERANZA DOS	06264	\N	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	\N	\N	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	ESPERANZA DEL MAR  S.A.	Ciudad Autónoma de Buenos Aires		011-4328-8696	\N		\N	\N		t	\N	\N	\N
3f3214f0-23a0-43e1-b28e-ed52ce17c56f	ESPERANZA UNO	06113	\N	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	\N	\N	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	ESPERANZA DEL MAR  S.A.	Ciudad Autónoma de Buenos Aires		011-4328-8696	\N		\N	\N		t	\N	\N	\N
a795d0f8-d140-49a4-986d-d38f72eb6a3d	ESTEFANY	001	1565	6fdf97a3-2f73-4a74-956b-414b0ca85b33	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	\N	15	23.60	530	5d12df00-152b-43e6-8ba0-20067e3bac8c	GIORNO  S.A.	Mar del Plata		410-0051 / 0057	\N		\N	\N		t	\N	\N	\N
15fffcb8-ba0f-4d72-b8e3-2508b7425e87	ESTEIRO	6328	\N	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	\N	\N	5d12df00-152b-43e6-8ba0-20067e3bac8c	BALDIMAR  S.A.	Mar del Plata		489-6522	\N		\N	\N		t	\N	\N	\N
f4f6f1c5-d035-4c57-ba51-8d0d62ec0ddf	ESTHER 153	02058	1568	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	55.10	1252	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	ARPEPA  M.C.I.S.A.	Ciudad Autónoma de Buenos Aires		011-4382-1605	\N		\N	\N		t	\N	\N	\N
9594d276-4721-4940-98ba-b7f806680d4c	ESTRELLA N° 5	0246	1575	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	54.20	1601	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	HANSUNG AR  S.A.	Ciudad Autónoma de Buenos Aires		011-4816-2022	\N		\N	\N		t	\N	\N	\N
c24238e5-5be1-4e1c-a65b-6589e55ceeaf	ESTRELLA N° 6	012	1576	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	55.85	1581	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	HANSUNG AR  S.A.	Ciudad Autónoma de Buenos Aires		011-4816-2022	\N		\N	\N		t	\N	\N	\N
e4056a12-f209-439f-b09e-57fe154794ed	ESTRELLA N° 8	0242	\N	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	\N	\N	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	HANSUNG AR  S.A.	Ciudad Autónoma de Buenos Aires		011-4816-2022	\N		\N	\N		t	\N	\N	\N
f1b17c5c-2715-4f41-b20b-bfe12ad2d423	FE EN PESCA	0226	\N	\N	\N	\N	0	\N	\N	5d12df00-152b-43e6-8ba0-20067e3bac8c	ASARO HNOS.  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
48a9c10b-41c8-4986-8f54-b844583b2439	FEDERICO C	3190	2776	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	\N	37.68	1400	\N	PESQUERA VERAZ  S.A.				\N		\N	\N		t	\N	\N	\N
5f255305-bbf3-48e7-a285-3b17e7b2a3c3	FEIXA	0529	1592	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	41.50	1101	5d12df00-152b-43e6-8ba0-20067e3bac8c	ANTONIO BARILLARI  S.A.	Mar del Plata		481-1173  / 489-0872	\N		\N	\N		t	\N	\N	\N
b3c6d49e-6697-4927-b3c2-857a8275b130	FELIX AUGUSTO	0581	1595	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	27.80	601	9e675114-d5e6-449e-a20c-9688499c3c00	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
de3e75bc-9714-43e0-b684-3dd0dc0206c7	FERNANDO ALVAREZ	0013	1597	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	36.60	1168	9e675114-d5e6-449e-a20c-9688499c3c00	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
358481b9-dd0e-4aa1-a1c1-1f777f08f424	FLORIDABLANCA	0969	1606	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	27.67	541	5d12df00-152b-43e6-8ba0-20067e3bac8c	DESAFIO  S.A.	Mar del Plata		489-4788 / 3659	\N		\N	\N		t	\N	\N	\N
b9f2f1a6-b20e-4173-b6f8-01934f2d8755	FLORIDABLANCA II	0252	\N	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	\N	\N	9e675114-d5e6-449e-a20c-9688499c3c00	PESQUERA SAN ISIDRO S.A.	Puerto Madryn		0280-447-2697	\N		\N	\N		t	\N	\N	\N
a8c6a783-2189-46c2-8c79-4104b6ca311a	FLORIDABLANCA IV	0255	\N	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	\N	\N	700d1050-2d8c-4c23-a7ea-d73eecb7ec63	MARITIMA MONACHESI  S.A.	Bahia Blanca		0291-452-5913	\N		\N	\N		t	\N	\N	\N
0cee4b34-6b03-4d4e-a7f5-0569c7e99d6a	FONSECA	0920	1610	b509832f-10d9-4f7d-b71e-5bd4ecf88b38	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	60	62.40	2003	5d12df00-152b-43e6-8ba0-20067e3bac8c	FONSECA  S.A.	Mar del Plata	4891553-154179360-154179860-154179062	489-4645	\N	agenciasmiriglio@speedy.com.ar	\N	\N	Agencia Maritima Smiriglio	t	\N	\N	\N
4c540a8f-ad8d-43fe-884a-942513965d00	FRANCA	0495	1612	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	27.29	493	5d12df00-152b-43e6-8ba0-20067e3bac8c	AUGUSTA MEGARA  S.A.	Mar del Plata		480-2260	\N		\N	\N		t	\N	\N	\N
95761f1f-5eda-4c2f-a881-f0ae573ced1e	FRANCO	01458	\N	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	\N	\N	5d12df00-152b-43e6-8ba0-20067e3bac8c	FRIGORIFICO DON LUIS  S.R.L.	Mar del Plata		489-4645	\N		\N	\N		t	\N	\N	\N
a6bded68-7c58-4707-989d-986828b3995e	FU YUAN YU 636	02195	\N	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	\N	\N	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	BAHIA GRANDE  S.A.	Ciudad Autónoma de Buenos Aires		011-5272-0850 / 5254-1133	\N		\N	\N		t	\N	\N	\N
75be9c2d-6935-40d1-901e-86b5052a5320	FUEGUINO I	0331	\N	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	\N	\N	9e675114-d5e6-449e-a20c-9688499c3c00	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
fb8acaad-e933-4082-8821-16035853049a	GALA	02722	0	6fdf97a3-2f73-4a74-956b-414b0ca85b33	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	\N	15	15.20	256	5d12df00-152b-43e6-8ba0-20067e3bac8c	DISTRIBUIDORA MARECHIARE S.R.L.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
4ef6432e-6235-4f6b-8bef-92667a2b4b1f	GALEMAR	0904	\N	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	\N	\N	5d12df00-152b-43e6-8ba0-20067e3bac8c	ANTONIO BARILLARI  S.A.	Mar del Plata		481-1173  / 489-0872	\N		\N	\N		t	\N	\N	\N
c1a93c26-c4a5-4c4a-b2e8-819b835cf19c	GAUCHO GRANDE	0339	1642	\N	\N	\N	30	27.64	0	5d12df00-152b-43e6-8ba0-20067e3bac8c	VICARP  S.A.	Mar del Plata	4890960	480-4378	\N	agencia@maritimavidal.com.ar	\N	\N	Agencia Maritima Vidal	t	\N	\N	\N
6cfb81b7-0d13-40ce-84fa-a616070bbb37	GEMINIS	01421	1643	b509832f-10d9-4f7d-b71e-5bd4ecf88b38	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	60	68.90	2141	5d12df00-152b-43e6-8ba0-20067e3bac8c	PESQUERA GEMINIS  S.A.	Mar del Plata		410-0051 / 7	\N		\N	\N		t	\N	\N	\N
c73580fc-d679-44df-b48f-ca66ae646c87	GIANFRANCO	01075	\N	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	\N	\N	5d12df00-152b-43e6-8ba0-20067e3bac8c	PIEA  S.A.	Mar del Plata		489-6317 /489-1367	\N		\N	\N		t	\N	\N	\N
e058e01c-435f-45d1-8acc-53b06c39514b	GIULIANA	02633	\N	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	\N	\N	5d12df00-152b-43e6-8ba0-20067e3bac8c	PESQUERA  MARGARITA  S.A.	Mar del Plata		489-4645   /   489-2946	\N		\N	\N		t	\N	\N	\N
46eb5859-55db-45f4-9054-ae3bfa2ed222	GLORIA DEL MAR I	01983	1651	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	54.30	1600	5d12df00-152b-43e6-8ba0-20067e3bac8c	PESQUERA  DEL  ESTE  S.A.	Mar del Plata	4800005	489-1567	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
4dadbb83-474d-4f75-9e93-8d221eeefdbb	GRACIELA	0578	\N	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	\N	\N	5d12df00-152b-43e6-8ba0-20067e3bac8c	PEDRO MOSCUZZA e HIJOS  S.A.	Mar del Plata		489-7287	\N		\N	\N		t	\N	\N	\N
2f2c6e1f-3969-4575-aa14-cde78663cec6	GRACIELA I	3994	2765	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	39.94	0	5d12df00-152b-43e6-8ba0-20067e3bac8c	PEDRO MOSCUZZA e HIJOS  S.A.	Mar del Plata		489-7287	\N		\N	\N		t	\N	\N	\N
656c1c5b-35a0-4557-bec3-e9ede23531d0	GRAN CAPITAN	01538	1656	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	25.43	541	5d12df00-152b-43e6-8ba0-20067e3bac8c	ORTIGIA  S.A.	Mar del Plata		489-2679	\N		\N	\N		t	\N	\N	\N
83781bbe-4a28-414a-80e9-458eef38efdd	GURISES	01386	1667	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	25.20	546	5d12df00-152b-43e6-8ba0-20067e3bac8c	A.B.H. PESQUERA  S.A.	Mar del Plata		489-6522	\N		\N	\N		t	\N	\N	\N
bb255b19-1bf3-417d-9e45-30b6ea8e471c	GUSTAVO R	0075	\N	b509832f-10d9-4f7d-b71e-5bd4ecf88b38	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	60	\N	\N	5d12df00-152b-43e6-8ba0-20067e3bac8c	ARGEMER  S.A.	Mar del Plata		451-1247	\N		\N	\N		t	\N	\N	\N
aa8ad1c5-5c01-4a02-be20-b2b68b9d010c	HAMAZEN MARU N° 68	JA05	\N	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	\N	\N	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	PESQUERA SANTA CRUZ  S.A.	Ciudad Autónoma de Buenos Aires		011-4305-4706	\N		\N	\N		t	\N	\N	\N
048ae429-c094-415f-a71b-37bbc7f648d2	HAMPON	01410	1673	6fdf97a3-2f73-4a74-956b-414b0ca85b33	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	\N	10	18.99	497	5d12df00-152b-43e6-8ba0-20067e3bac8c	PESQUERA HAMPON S.R.L	Mar del Plata			\N		\N	\N		t	\N	\N	\N
2ac32276-991c-4de7-8e50-5c9f30ccc268	HARENGUS	0510	\N	b509832f-10d9-4f7d-b71e-5bd4ecf88b38	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	60	\N	\N	9e675114-d5e6-449e-a20c-9688499c3c00	HARENGUS  S.A.	Puerto Madryn		0280-445-0822	\N		\N	\N		t	\N	\N	\N
2aafaf33-6bd5-4ebe-a22f-fd95997387c6	HOKO 31	05934	\N	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	\N	\N	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	FARO DEL SUR TRADING  S.A.	Ciudad Autónoma de Buenos Aires		011-4555-4956	\N		\N	\N		t	\N	\N	\N
5e46188f-ae8a-4dc7-8346-9878e64e5212	HOPE N°7	06130	1690	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	50.60	1235	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	ALUNAMAR  S.A.	Ciudad Autónoma de Buenos Aires	4808331/4808332	011-4382-4194	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
028d04dc-9ebe-4e80-b423-fcaa6aefa3ce	HOYO MARU 37	JA01	\N	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	\N	\N	c0480dd3-e309-4e6d-8620-661c4fdfe0c7	ARGENOVA  S.A.	Puerto Deseado		0297- 487-0550  (447-2818  Com. Riv )	\N		\N	\N		t	\N	\N	\N
1c844552-bb49-4ae8-9c69-61eaae975034	HSIANG LAI FU	80	\N	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	\N	\N	5d12df00-152b-43e6-8ba0-20067e3bac8c	EL MARISCO  S.A.	Mar del Plata		489-0384	\N		\N	\N		t	\N	\N	\N
8d35f62b-d812-44b8-a136-baa4b6a8f5d5	HUYU 961	TEMP-0003	0	\N	\N	\N	\N	65.70	0	\N					\N		\N	\N		t	\N	\N	\N
c39a8309-bb16-4f99-ad5f-6033c8c9476b	HUYU 962	03056	0	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	65.60	0	9e675114-d5e6-449e-a20c-9688499c3c00	ALTAMARE  S.A.	Puerto Madryn		0280-445-7377 / 447-2249	\N		\N	\N		t	\N	\N	\N
388316b4-97c7-4c1c-aebc-d048949a14da	HUYU 906	03026	2747	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	65.92	1579	5d12df00-152b-43e6-8ba0-20067e3bac8c	CHENG I  S.A.	Mar del Plata		489-1385	\N		\N	\N		t	\N	\N	\N
bf4e45d5-9fd8-40c8-a164-f66ead1e3357	HUYU 907	03027	2748	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	72.17	1678	5d12df00-152b-43e6-8ba0-20067e3bac8c	CHENG I  S.A.	Mar del Plata	4800005	489-1385	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
e4fada4b-8434-4fa0-9262-21ff031d196e	HU YU 910	81	\N	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	\N	\N	5d12df00-152b-43e6-8ba0-20067e3bac8c	PEDRO MOSCUZZA e HIJOS  S.A.	Mar del Plata		489-7287	\N		\N	\N		t	\N	\N	\N
5ef57ae4-23b5-40cb-a509-97db67cf08b2	HUAFENG 801	3013	2741	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	65.04	1973	5d12df00-152b-43e6-8ba0-20067e3bac8c	ARDAPEZ  S.A.	Mar del Plata		480-1561 / 480-1568 / 480-1549	\N		\N	\N		t	\N	\N	\N
8bbc3210-3b25-45ea-a5c7-62c5415a827a	HUAFENG 802	3014	2751	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	65.04	1973	5d12df00-152b-43e6-8ba0-20067e3bac8c	ARDAPEZ  S.A.	Mar del Plata		480-1561 / 480-1568 / 480-1549	\N		\N	\N		t	\N	\N	\N
c09d6ba7-36ed-41f8-bf11-d8084b5d79f0	HUA I 616	0392	\N	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	\N	\N	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	ARMADORA  ACRUX  S.A.	Ciudad Autónoma de Buenos Aires		011-4312-6470	\N		\N	\N		t	\N	\N	\N
15993c2a-3401-4548-9c47-1d2b03c354f3	HUAFENG 815	0554A	0	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	25.28	419	5d12df00-152b-43e6-8ba0-20067e3bac8c	PESQUERA CHIARMAR S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
356cfbfb-d65e-4b55-897b-9fad3218131e	HUAFENG 820 (ex INFINITUS PEZ)	01472A	\N	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	\N	\N	5d12df00-152b-43e6-8ba0-20067e3bac8c	MELIMAR S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
aa6ea447-fc2a-4976-b699-7253669170e6	HUAFENG 821 (ex INITIO PEZ)	01471A	\N	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	\N	\N	5d12df00-152b-43e6-8ba0-20067e3bac8c	MELIMAR S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
7c64deb5-53a9-485d-b1c7-b399fb96c806	IARA	06207	\N	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	\N	\N	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	PESQUERA MADRYN  S.A.	Ciudad Autónoma de Buenos Aires		011-4394-1452	\N		\N	\N		t	\N	\N	\N
86dfbbf7-4840-4a0d-9f76-f2d0a39652f6	IGLU I	01423	1713	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	32.75	660	5d12df00-152b-43e6-8ba0-20067e3bac8c	GIORNO  S.A.	Mar del Plata		410-0051 / 0057	\N		\N	\N		t	\N	\N	\N
15dddeab-61b8-44df-b6f4-0c2de5ef3e2b	ILLEX I	125	\N	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	\N	\N	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	ILLEX  S.A.	Ciudad Autónoma de Buenos Aires	4808331/4808332	011-4393-6431	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
0d23283f-59f6-4086-ae86-2fbc0a901788	INARI MARU N° 25	0261	\N	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	\N	\N	c0480dd3-e309-4e6d-8620-661c4fdfe0c7	ARGENOVA  S.A.	Puerto Deseado		0297- 487-0550  (447-2818  Com. Riv )	\N		\N	\N		t	\N	\N	\N
5bdb82d5-08c1-4d7e-8c67-30b77ad0e7cf	INFINITUS PEZ	01472	\N	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	\N	\N	5d12df00-152b-43e6-8ba0-20067e3bac8c	GIORNO  S.A.	Mar del Plata		410-0051 / 0057	\N		\N	\N		t	\N	\N	\N
70629144-b3fc-47f2-858f-08f13d249883	INITIO PEZ	01471	\N	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	\N	\N	5d12df00-152b-43e6-8ba0-20067e3bac8c	GIORNO  S.A.	Mar del Plata	4800005	410-0051 / 0057	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi	t	\N	\N	\N
a1a4671b-7bd8-4d11-bdc7-b5fdaee913f7	ITXAS LUR	0927	1735	b509832f-10d9-4f7d-b71e-5bd4ecf88b38	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	60	63.30	1952	5d12df00-152b-43e6-8ba0-20067e3bac8c	HISPANO PATAGONICA  S.A.	Mar del Plata		480-1002 / 489-3165 / 489-7144	\N		\N	\N		t	\N	\N	\N
92859cc6-e900-45a3-84c9-ff2e7656381a	JOLUMA	5403	\N	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	\N	\N	5d12df00-152b-43e6-8ba0-20067e3bac8c	ARDAPEZ  S.A.	Mar del Plata	4800005	480-1561 / 480-1568 / 480-1549	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
58588658-bf41-4bb4-9ff4-ceec9eb689fa	JOSÉ AMÉRICO	03071	2756	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	44.21	0	5d12df00-152b-43e6-8ba0-20067e3bac8c	PEDRO MOSCUZZA e HIJOS  S.A.	Mar del Plata		489-7287	\N		\N	\N		t	\N	\N	\N
279eb87d-e30b-499b-a01b-1c5efc97944f	JOSE LUIS ALVAREZ	0618	\N	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	\N	\N	9e675114-d5e6-449e-a20c-9688499c3c00	PESQUERA SAN ISIDRO S.A.	Puerto Madryn		0280-447-2697	\N		\N	\N		t	\N	\N	\N
152c8ba6-4793-4e02-a4f1-4e422d74d54a	JOSE MARCELO	3138	2764	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	39.94	0	5d12df00-152b-43e6-8ba0-20067e3bac8c	PEDRO MOSCUZZA e HIJOS  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
8bc770b4-0cb2-48a7-9176-bcce8e83598c	JUAN ALVAREZ	0619	1755	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	36.60	1168	9e675114-d5e6-449e-a20c-9688499c3c00	PESQUERA SAN ISIDRO S.A.	Puerto Madryn		0280-447-2697	\N		\N	\N		t	\N	\N	\N
a769fcb6-1d72-420f-a333-bcf11e086e8c	JUAN PABLO II	02695	0	6fdf97a3-2f73-4a74-956b-414b0ca85b33	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	\N	8	22.49	326	\N	ISLA DE LOS ESTADOS  S.A.	Vivoratá			\N		\N	\N		t	\N	\N	\N
6c94b211-c2ac-4fa3-bd3f-0c2a3d705c7c	JUDITH I	0908	\N	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	\N	\N	5d12df00-152b-43e6-8ba0-20067e3bac8c	ANTONIO BARILLARI  S.A.	Mar del Plata		481-1173  / 489-0872	\N		\N	\N		t	\N	\N	\N
ff1d997d-2ba7-4ef7-aeef-2844fbaada70	JUEVES SANTO	0667	1762	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	39.50	1244	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	NUVCONSA  S.A.	Ciudad Autónoma de Buenos Aires	4891553-154179360-154179860-154179062	011-4305-4706	\N	agenciasmiriglio@speedy.com.ar	\N	\N	Agencia Maritima Smiriglio	t	\N	\N	\N
ed3b7381-017d-4c38-ac8a-ccef0d20de2e	JUPITER II	0406	1769	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	27.90	791	5d12df00-152b-43e6-8ba0-20067e3bac8c	VENUS  PESQUERA S.R.L.	Mar del Plata	4800005	489-0186	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
80b8d6e3-6883-4e0b-8a34-8085ff3c92ed	KALEU KALEU	01963	\N	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	\N	\N	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	KALEU KALEU  S.A.	Ciudad Autónoma de Buenos Aires	4800005	011-3220-2130  / 5093-1215	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi	t	\N	\N	\N
907f0566-7199-4c6e-b264-0005035abff1	KANTXOPE	01065	\N	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	\N	\N	5d12df00-152b-43e6-8ba0-20067e3bac8c	ANTONIO BARILLARI  S.A.	Mar del Plata		481-1173  / 489-0872	\N		\N	\N		t	\N	\N	\N
de0cfca4-c80b-402d-a4d7-549375371937	KARINA	01462	\N	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	\N	\N	5d12df00-152b-43e6-8ba0-20067e3bac8c	FRIGORIFICO DON LUIS  S.R.L.	Mar del Plata		489-4645	\N		\N	\N		t	\N	\N	\N
0c808d87-8de9-49f6-b1ad-5427435338ef	LAIA	06521	0	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	53.00	1185	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	PESQUERA MADRYN  S.A.	Ciudad Autónoma de Buenos Aires		011-4394-1452	\N		\N	\N		t	\N	\N	\N
3d0539b6-1474-4c88-9e30-3f721d3e82f3	LANZA SECA	01181	1852	\N	\N	\N	0	24.80	514	5d12df00-152b-43e6-8ba0-20067e3bac8c	LANZAMAR  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
263df9b1-0a37-4c1c-851b-30b303deaba0	LATINA  N° 8	0291	\N	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	\N	\N	c0480dd3-e309-4e6d-8620-661c4fdfe0c7	ARGENOVA  S.A.	Puerto Deseado		0297- 487-0550  (447-2818  Com. Riv )	\N		\N	\N		t	\N	\N	\N
d4a1bc29-cc04-4d28-ade8-d330771bd4c6	LEAL	0143	1863	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	27.45	601	5d12df00-152b-43e6-8ba0-20067e3bac8c	PESQUERA LEAL  S.A.	Mar del Plata		489-4624 / 489-0314 (astillero )	\N		\N	\N		t	\N	\N	\N
3262762d-5f4d-4a58-9a4b-829a929bdac8	LEKHAN I	00752	1865	6fdf97a3-2f73-4a74-956b-414b0ca85b33	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	\N	8	18.45	530	5d12df00-152b-43e6-8ba0-20067e3bac8c	LEKHAN I  S.R.L.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
404c4a12-967a-4428-9b7f-8bb9d6a62944	LETARE	0245	\N	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	\N	\N	5d12df00-152b-43e6-8ba0-20067e3bac8c	LUIS SOLIMENO e HIJOS  S.A.	Mar del Plata		489-3030	\N		\N	\N		t	\N	\N	\N
c6dde6a3-28a2-4d78-a244-84a73fa17b92	LIBERTAD DEL MAR 1°	02186	\N	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	\N	\N	5d12df00-152b-43e6-8ba0-20067e3bac8c	TATURIELLO  S.A.	Mar del Plata		489-3833	\N		\N	\N		t	\N	\N	\N
217a7412-ccd9-464c-ac5b-1e910cb5a213	LING SHUI N° 3	02210	\N	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	\N	\N	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	MUELLE OCHO  S.A.	Ciudad Autónoma de Buenos Aires		011-4381-1337	\N		\N	\N		t	\N	\N	\N
f4e2ab9f-94e8-4dcf-872a-5a5bbd83a961	LING SHUI N° 5	02211	\N	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	\N	\N	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	MUELLE OCHO  S.A.	Ciudad Autónoma de Buenos Aires		011-4381-1337	\N		\N	\N		t	\N	\N	\N
d192cbe9-b88a-4a77-a7c3-291a553990c8	LUIGI	3244	\N	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	\N	\N	5d12df00-152b-43e6-8ba0-20067e3bac8c	LUIS SOLIMENO e HIJOS  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
45c53662-7c57-4411-895b-7b35236800fc	LUCA MARIO	0546	2715	b509832f-10d9-4f7d-b71e-5bd4ecf88b38	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	60	79.14	3952	5d12df00-152b-43e6-8ba0-20067e3bac8c	PESCASOL  S.A.	Mar del Plata	4800274	480-9608 / 481-0464	\N	amalfitanoycia@hotmail.com	\N	\N	Agencia Maritima Almafitano	t	\N	\N	\N
f69ff5f2-4aa6-4613-95f5-04704da57202	LUCA SANTINO	3121	0	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	26.31	0	\N	CENTOMAR  S.A.				\N		\N	\N		t	\N	\N	\N
f3283ed9-4f46-4fc4-890b-5d3c6587ea57	LUCIA LUISA	0623	1897	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	27.90	463	5d12df00-152b-43e6-8ba0-20067e3bac8c	PESQUERA VERAZ  S.A.	Mar del Plata		489-4624 / 489-0314 (astillero)	\N		\N	\N		t	\N	\N	\N
f4124683-a1fe-40f6-8bbf-cf0c24888939	LUNES SANTO	01132	\N	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	\N	\N	9e675114-d5e6-449e-a20c-9688499c3c00	IBERCONSA  DE ARGENTINA  S.A.	Puerto Madryn		0280-445-4324	\N		\N	\N		t	\N	\N	\N
651bef92-1ce6-4af9-a65e-de172cf1c60b	MADONNINA DEL MARE	01112	1912	6fdf97a3-2f73-4a74-956b-414b0ca85b33	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	\N	8	23.78	601	5d12df00-152b-43e6-8ba0-20067e3bac8c	FABLED  S.A	Mar del Plata		480-1565	\N		\N	\N		t	\N	\N	\N
3c1b65e7-83ca-4b85-9757-1873b1b42d18	MADRE DIVINA	01556	1915	6fdf97a3-2f73-4a74-956b-414b0ca85b33	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	\N	10	26.12	518	5d12df00-152b-43e6-8ba0-20067e3bac8c	VUOSO HNOS. S.R.L.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
6a9323e7-9b5a-4e7c-ac9a-1e9bd3909c05	MADRE INMACULADA	2378	1916	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	62.80	1852	5d12df00-152b-43e6-8ba0-20067e3bac8c	ANTONIO BALDINO e HIJOS  S.A. (Saladero)	Mar del Plata		489-6522  /489-0423	\N		\N	\N		t	\N	\N	\N
f14fd64d-56d0-438b-92a9-ca9f5b48648b	MADRE MARGARITA	02728	0	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	25.60	541	5d12df00-152b-43e6-8ba0-20067e3bac8c	PESQUERA  MARGARITA  S.A.	Mar del Plata		489-4645   /   489-2946	\N		\N	\N		t	\N	\N	\N
614472e1-5927-4913-acf9-5b0078bac092	MAGDALENA MARIA  II	02208	\N	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	\N	\N	5d12df00-152b-43e6-8ba0-20067e3bac8c	ANTONIO BARILLARI  S.A.	Mar del Plata	4800005	481-1173  / 489-0872	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
04c45dbc-918b-45ec-9d95-7ae8ddab336e	MALVINAS ARGENTINAS	0577	1931	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	28.40	458	5d12df00-152b-43e6-8ba0-20067e3bac8c	PEDRO MOSCUZZA e HIJOS  S.A.	Mar del Plata		489-7287	\N		\N	\N		t	\N	\N	\N
693afd8c-3d9d-480a-96a5-c18d3ed53168	MAR  AUSTRAL  I	0208	\N	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	\N	\N	c0480dd3-e309-4e6d-8620-661c4fdfe0c7	PESQUERA DESEADO  S.A.	Puerto Deseado		0297-487-0884 / 0327 / 2407	\N		\N	\N		t	\N	\N	\N
06f300b7-e833-4504-a492-c96c85bbe387	MAR AZUL	0934	\N	\N	\N	\N	\N	\N	\N	\N	CLARAMAR  S.A.		480-7779 - HERNAN		\N	agenciasenoransmdp@yahoo.com	\N	\N	Agencia Maritima SEÑORANS	t	\N	\N	\N
94af0e11-cf04-4cc5-accc-8b258832f3f1	MAR DEL CHUBUT	0487	1944	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	28.20	721	5d12df00-152b-43e6-8ba0-20067e3bac8c	ROMFIOC  SRL	Mar del Plata	4800005		\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi	t	\N	\N	\N
3e96ed54-1d17-406c-9b8f-4868d33178be	MAR ESMERALDA	0925	\N	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	\N	\N	5d12df00-152b-43e6-8ba0-20067e3bac8c	ANTONIO BARILLARI  S.A.	Mar del Plata		481-1173  / 489-0872	\N		\N	\N		t	\N	\N	\N
8e7f0c2f-afdb-4357-b158-3709101ae8f1	MAR MARÍA	02960	2738	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	37.80	1248	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	PESQUERA SANTA CRUZ  S.A.	Ciudad Autónoma de Buenos Aires		011-4305-4706	\N		\N	\N		t	\N	\N	\N
15638504-d519-497c-ba75-f3a40c287229	MAR NOVIA 1	0115	\N	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	\N	\N	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	CINCOMAR  S.A.	Ciudad Autónoma de Buenos Aires		011-4326-4991	\N		\N	\N		t	\N	\N	\N
0d307bec-3bcd-41f2-91d1-4db9de7221ef	MAR NOVIA 2	0116	\N	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	\N	\N	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	MIREMAR  S.A.	Ciudad Autónoma de Buenos Aires		011-4328-4963 / 4	\N		\N	\N		t	\N	\N	\N
84781555-5afd-41ba-9144-1ed3dda597a1	MAR SUR	0341	1957	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	36.40	889	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	PESCARGEN  S.A.	Ciudad Autónoma de Buenos Aires		011-5219-0065 ó 5276-9499	\N		\N	\N		t	\N	\N	\N
0855bfb6-482d-4276-8462-4afba02b8be5	MARA I	0210	1960	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	35.31	1209	9e675114-d5e6-449e-a20c-9688499c3c00	PESCAPUERTA ARGENTINA  S.A.	Puerto Madryn		0280-445-4407	\N		\N	\N		t	\N	\N	\N
466e3d41-2b0c-4b91-8457-dcbf92944665	MARA II	0209	\N	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	\N	\N	9e675114-d5e6-449e-a20c-9688499c3c00	PESCAPUERTA ARGENTINA  S.A.	Puerto Madryn		0280-445-4407	\N		\N	\N		t	\N	\N	\N
41c49437-6a22-4e4f-9c7e-773fbda177c8	MARBELLA	01073	1966	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	27.38	736	5d12df00-152b-43e6-8ba0-20067e3bac8c	MAR DE MESSINA  S.A.	Mar del Plata	beagle1	489-3824	\N		\N	\N		t	\N	\N	\N
bf6bb04d-a7d6-4ff7-93e7-a34676b4c9d2	MARCALA I	0532	\N	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	\N	\N	5d12df00-152b-43e6-8ba0-20067e3bac8c	PESANFLOR  S.A.	Mar del Plata		489-6522	\N		\N	\N		t	\N	\N	\N
edfef434-b574-4324-9260-4aa9dbb24a1d	MARCALA IV	0351	\N	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	\N	\N	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	MARCALA  S.A.	Ciudad Autónoma de Buenos Aires		011-4342-9601 / 4283	\N		\N	\N		t	\N	\N	\N
34cb32ad-9867-4f03-a819-b7c3342b8bb7	MAREJADA	01107	1974	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	27.98	624	5d12df00-152b-43e6-8ba0-20067e3bac8c	VICARP  S.A.	Mar del Plata		480-4378	\N		\N	\N		t	\N	\N	\N
c4339fda-c7e0-47dd-a3be-ed561026a162	MARGOT	0360	1976	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	58.75	1481	5d12df00-152b-43e6-8ba0-20067e3bac8c	GIORNO  S.A.	Mar del Plata	4800005	410-0051 / 0057	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
3b9b4e9f-3ec5-44a1-bc38-1351c42af827	MARIA  EUGENIA	01173	\N	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	\N	\N	5d12df00-152b-43e6-8ba0-20067e3bac8c	PEDRO MOSCUZZA e HIJOS  S.A.	Mar del Plata		489-7287	\N		\N	\N		t	\N	\N	\N
e530fd26-0a37-4ab2-bfc6-5616e0477ca5	HUAFENG 816	05994	0	6fdf97a3-2f73-4a74-956b-414b0ca85b33	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	\N	4	22.60	521	5d12df00-152b-43e6-8ba0-20067e3bac8c	COSTA BRAVA  S.A.	Mar del Plata	4800005	489-7538	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
e8e2c81f-46c7-4100-b77c-495470d565c7	MARIA  LILIANA	01174	\N	b509832f-10d9-4f7d-b71e-5bd4ecf88b38	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	60	\N	\N	5d12df00-152b-43e6-8ba0-20067e3bac8c	PEDRO MOSCUZZA e HIJOS  S.A.	Mar del Plata	4893758	489-7287	\N	miguel-visoso@hotmail.com	\N	\N	Agencia Maritima Solvox	t	\N	\N	\N
aab82b2c-da83-4a91-a798-6976de1846f0	MARIA RITA	0436	2000	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	30.95	541	5d12df00-152b-43e6-8ba0-20067e3bac8c	BAL - FISH  S.A.	Mar del Plata		489-6522	\N		\N	\N		t	\N	\N	\N
65f8f9f2-eeea-4ada-879a-4b383858fbdd	MARIA ALEJANDRA 1º	03074	2750	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	39.20	0	5d12df00-152b-43e6-8ba0-20067e3bac8c	XEITOSIÑO S.A.	Mar del Plata		410-0051 / 7	\N		\N	\N		t	\N	\N	\N
4874c788-c0e2-466d-ac80-117f69b5ea5b	MARIA DEL VALLE	02126	1986	6fdf97a3-2f73-4a74-956b-414b0ca85b33	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	\N	4	16.29	196	b0b3126f-6cd0-4ab9-91db-f70b14747ee8	FARO CHUBUT  S.R.L.	Rawson		0280-449-6311	\N		\N	\N		t	\N	\N	\N
81095d59-435e-44fb-942d-90dd5f65fa74	MARIA GLORIA	02738	2763	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	28.05	851	5d12df00-152b-43e6-8ba0-20067e3bac8c	CAYO LARGO  S.A.	Mar del Plata		480-4378	\N		\N	\N		t	\N	\N	\N
39f59880-1071-425c-818d-2120607006de	MARIANELA	01002	2007	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	25.60	541	5d12df00-152b-43e6-8ba0-20067e3bac8c	AGLIANO  SRL	Mar del Plata		480-2886	\N		\N	\N		t	\N	\N	\N
dfacee16-1341-467c-ae37-ff53274d8342	MARTA S	01001	0	6fdf97a3-2f73-4a74-956b-414b0ca85b33	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	\N	8	23.90	503	5d12df00-152b-43e6-8ba0-20067e3bac8c	WERZOWA  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
74a528bb-c39c-462c-934e-cd9a35e10f17	MATACO II	02243	\N	b509832f-10d9-4f7d-b71e-5bd4ecf88b38	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	60	\N	\N	9e675114-d5e6-449e-a20c-9688499c3c00	HAMALTAL  S.A.	Puerto Madryn	4800005	0280-445-0822	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
0374aa6f-0d1b-49c2-8f73-9bc8818d48d1	MATEO I	02172	2028	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	67.97	1776	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	KALEU KALEU  S.A.	Ciudad Autónoma de Buenos Aires		011-3220-2130  / 5093-1215	\N		\N	\N		t	\N	\N	\N
3bef805c-997e-4e3c-9779-5f4500dbb01f	MELLINO I	0379	2032	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	47.25	1185	5d12df00-152b-43e6-8ba0-20067e3bac8c	GIORNO  S.A.	Mar del Plata		410-0051 / 0057	\N		\N	\N		t	\N	\N	\N
ef662bb7-b9d9-4ef5-93a5-15790d343afa	MELLINO II	01424	0	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	38.91	795	5d12df00-152b-43e6-8ba0-20067e3bac8c	GIORNO  S.A.	Mar del Plata	AVENIDA DE LOS PESCADORES 195	410-0051 / 0057	\N		\N	\N	Agencia AMALFITANO	t	\N	\N	\N
947d5aaf-de3e-4a75-9839-e36db2a74995	MELLINO VI	0378	2034	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	64.87	1235	5d12df00-152b-43e6-8ba0-20067e3bac8c	GIORNO  S.A.	Mar del Plata		410-0051 / 0057	\N		\N	\N		t	\N	\N	\N
1af7ae4c-02f0-4090-b373-da4eab6e12c5	MERCEA C	0318	2036	\N	\N	\N	0	29.15	866	5d12df00-152b-43e6-8ba0-20067e3bac8c	ALLELOCCIC  S.A.	Mar del Plata		495-4467 / 480-8565	\N		\N	\N		t	\N	\N	\N
330fc9ad-9d27-41c4-8df0-c225328623a9	MESSINA I	01089	2038	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	27.29	650	5d12df00-152b-43e6-8ba0-20067e3bac8c	MAR DE MESSINA  S.A.	Mar del Plata		489-3824	\N		\N	\N		t	\N	\N	\N
6e45dc8d-a19b-4e69-a6a7-e97fd4a76b02	MEVIMAR	01508A	\N	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	\N	\N	9e675114-d5e6-449e-a20c-9688499c3c00	RIMINIMARR  S.A.	Puerto Madryn		0280-445-2248	\N		\N	\N		t	\N	\N	\N
e19a5073-bf17-4c75-9116-f559c2e495bd	MIERCOLES SANTO	0666	2041	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	38.50	1244	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	NUVCONSA  S.A.	Ciudad Autónoma de Buenos Aires		011-4305-4706	\N		\N	\N		t	\N	\N	\N
a4e48c01-34b3-46e8-885e-29d11136d184	MILLENNIUM	0466	2046	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	55.05	1329	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	PESQUERA CRUZ DEL SUR  S.A.	Ciudad Autónoma de Buenos Aires		011-4784-1760	\N		\N	\N		t	\N	\N	\N
c62aac7d-a1ee-4806-8bfd-e0815784c6c4	MINCHOS OCTAVO	03022	2744	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	39.30	579	9e675114-d5e6-449e-a20c-9688499c3c00	IBERCONSA  DE ARGENTINA  S.A.	Puerto Madryn		0280-445-4324	\N		\N	\N		t	\N	\N	\N
d78eb359-66fa-4867-819d-4599b8aa06b5	NINA	3171	2770	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	44.00	1620	\N	PEDRO MOSCUZZA e HIJOS  S.A.				\N		\N	\N		t	\N	\N	\N
0d63dd59-ac7e-49ae-b324-349fff46355d	MINTA	02196	2050	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	65.10	1603	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	LIYA  S.A.	Ciudad Autónoma de Buenos Aires		011-4964-2227	\N		\N	\N		t	\N	\N	\N
78783f97-0d60-424e-a880-3c06aa01024b	MIRIAM	0370	2051	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	36.35	1446	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	VIEIRA ARGENTINA  S.A.	Ciudad Autónoma de Buenos Aires	4800005		\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi	t	\N	\N	\N
d37f4910-781d-445f-ae4c-1e115befcedf	MISHIMA MARU N°8	02175	2054	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	63.43	1579	5d12df00-152b-43e6-8ba0-20067e3bac8c	BAL - FISH  S.A.	Mar del Plata	4800274	489-6522	\N	amalfitanoycia@hotmail.com	\N	\N	Agencia Maritima Almafitano	t	\N	\N	\N
255f22d6-ce7d-44af-9a0a-db1f5cf92ff5	MISS PATAGONIA	0555	2055	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	28.20	667	5d12df00-152b-43e6-8ba0-20067e3bac8c	PESQUERA VERAZ  S.A.	Mar del Plata	4805743	489-4624 / 489-0314 (astillero)	\N	agenciadiyorio@hotmail.com -joseph@hotmail.com	\N	\N	Agencia Di Yorio	t	\N	\N	\N
a07bd243-6580-4a69-afcb-ef60c1d6c789	MISS TIDE	02439	2056	c9ef52ca-9e27-4d02-aed4-e2e6f8f31b7f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	5524fead-8510-4189-91a2-ac7d39675ece	30	52.52	2254	5d12df00-152b-43e6-8ba0-20067e3bac8c	WANCHESE ARGENTINA  S.A.	Mar del Plata		489-1236	\N		\N	\N		t	\N	\N	\N
65e7bc2d-f843-49f3-b138-0ff63fdf1d04	MISTER BIG	0534	\N	c9ef52ca-9e27-4d02-aed4-e2e6f8f31b7f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	5524fead-8510-4189-91a2-ac7d39675ece	30	\N	\N	5d12df00-152b-43e6-8ba0-20067e3bac8c	WANCHESE ARGENTINA  S.A.	Mar del Plata		489-1236	\N		\N	\N		t	\N	\N	\N
b4ea5274-d879-4f77-b09f-2e002a62f829	MIURA MARU	05996	2058	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	53.20	1482	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	LIYA  S.A.	Ciudad Autónoma de Buenos Aires		011-4964-2227	\N		\N	\N		t	\N	\N	\N
3d78a7f6-f389-4493-8394-5bbd0a7b3253	MONTE DE VIOS	0664	\N	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	\N	\N	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	PESQUERA SANTA CRUZ  S.A.	Ciudad Autónoma de Buenos Aires		011-4305-4706	\N		\N	\N		t	\N	\N	\N
6f6d3ed7-6df3-40c4-9393-96fba965a89c	MYRDOMA F	02771	2735	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	38.55	1430	9e675114-d5e6-449e-a20c-9688499c3c00	LANZAR S.A.	Puerto Madryn	4800005	0280-445-6280	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
df2a0381-937d-46b8-bbf7-a199bce6d7d0	NANINA	02576	2073	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	72.08	1678	5d12df00-152b-43e6-8ba0-20067e3bac8c	PEDRO MOSCUZZA e HIJOS  S.A.	Mar del Plata	4800005	489-7287	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
1eb91ed7-699a-44d2-b684-792bdce19070	NATALIA	02066	2075	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	68.45	1779	5d12df00-152b-43e6-8ba0-20067e3bac8c	PEDRO MOSCUZZA e HIJOS  S.A.	Mar del Plata		489-7287	\N		\N	\N		t	\N	\N	\N
a78521d1-ad15-4950-b52c-16ea8edd47a4	NAVEGANTES	0542	2079	b509832f-10d9-4f7d-b71e-5bd4ecf88b38	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	60	58.00	1925	5d12df00-152b-43e6-8ba0-20067e3bac8c	PESQUERA COMERCIAL  S.A.	Mar del Plata		489-3030	\N		\N	\N		t	\N	\N	\N
66b0af87-baed-475d-aeec-d92910b4b3f9	NAVEGANTES II	01451	2080	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	63.70	1603	5d12df00-152b-43e6-8ba0-20067e3bac8c	PESQUERA COMERCIAL  S.A.	Mar del Plata		489-3030	\N		\N	\N		t	\N	\N	\N
f04762bd-b81a-4386-a030-3c0baaba0a2b	NAVEGANTES III	02065	2081	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	68.60	2203	5d12df00-152b-43e6-8ba0-20067e3bac8c	PESQUERA COMERCIAL  S.A.	Mar del Plata	4800274	489-3030	\N	amalfitanoycia@hotmail.com	\N	\N	Agencia Maritima Almafitano	t	\N	\N	\N
f45815bc-cfa0-40f0-87c3-e1855fc8e743	NDDANDDU	0141	2082	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	28.20	856	5d12df00-152b-43e6-8ba0-20067e3bac8c	PESQUERA VERAZ  S.A.	Mar del Plata		489-4624 / 489-0314 (astillero)	\N		\N	\N		t	\N	\N	\N
ba702ed2-63e2-4784-8149-ba0c6568b636	NEPTUNIA I	02125	\N	6fdf97a3-2f73-4a74-956b-414b0ca85b33	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	\N	4	\N	\N	b0b3126f-6cd0-4ab9-91db-f70b14747ee8	FLOTA AMARILLA RAWSON	Rawson	4891553-154179360-154179860-154179062		\N	agenciasmiriglio@speedy.com.ar	\N	\N	Agencia Maritima SMIRIGLIO	t	\N	\N	\N
443a11d0-4123-4c54-a2b9-d1b62ec5a305	NIÑO JESUS DE PRAGA	3194	2775	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	27.74	1180	5d12df00-152b-43e6-8ba0-20067e3bac8c	RITORNO SALLUSTIO Y CICCIOTTI  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
f91cacb1-1db8-4442-ac4e-46da3675440b	NONO PASCUAL	02854	2729	6fdf97a3-2f73-4a74-956b-414b0ca85b33	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	\N	10	24.00	451	5d12df00-152b-43e6-8ba0-20067e3bac8c	CANAL DE BEAGLE  S.R.L.	Mar del Plata		480-4447 / 5004265 PASCUAL	\N		\N	\N		t	\N	\N	\N
dd5862e0-f1cd-4e95-81e0-beaa7a7f3fcd	NUEVA LUCIA MADRE	01501	2113	6fdf97a3-2f73-4a74-956b-414b0ca85b33	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	\N	8	14.37	416	5d12df00-152b-43e6-8ba0-20067e3bac8c	NUEVA LUCIA MADRE  S.R.L.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
3d0335ad-4c4b-4a45-8a8e-842d4be0c599	NUEVA NEPTUNIA I	02634	0	6fdf97a3-2f73-4a74-956b-414b0ca85b33	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	\N	4	20.00	403	b0b3126f-6cd0-4ab9-91db-f70b14747ee8	ORION S.R.L.	Rawson			\N		\N	\N		t	\N	\N	\N
71d80a74-95ff-46bb-bb04-67dd35d95c23	NUEVO ANITA	02100	2128	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	30.90	765	9e675114-d5e6-449e-a20c-9688499c3c00	IBERCONSA  DE ARGENTINA  S.A.	Puerto Madryn		0280-445-4324	\N		\N	\N		t	\N	\N	\N
8de47734-e535-42f4-9f1b-d32c6b6513e9	NUEVO VIENTO	01449	2135	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	22.23	541	5d12df00-152b-43e6-8ba0-20067e3bac8c	NUEVO VIENTO  SRL	Mar del Plata		480-8565	\N		\N	\N		t	\N	\N	\N
4585a8b1-4d16-4a14-b61b-41589d8c9e4c	OMEGA 3	01391	\N	6fdf97a3-2f73-4a74-956b-414b0ca85b33	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	\N	10	\N	\N	5d12df00-152b-43e6-8ba0-20067e3bac8c	COSTA BRAVA  S.A.	Mar del Plata		489-7538	\N		\N	\N		t	\N	\N	\N
159bf167-054f-4de9-b4b6-9f474c9f0ce0	ORION  2	01492	\N	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	\N	\N	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	PESQUERA SANTA CRUZ  S.A.	Ciudad Autónoma de Buenos Aires		011-4305-4706	\N		\N	\N	norberto.lopez@iberconsa.com	t	\N	\N	\N
a51cbbad-c281-4c41-84c2-1a42056e2516	ORION 5	02637	2757	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	65.62	1776	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	PESQUERA SANTA CRUZ  S.A.	Ciudad Autónoma de Buenos Aires		011-4305-4706	\N		\N	\N		t	\N	\N	\N
8bcf0f6e-42c6-41a4-b80d-440f71cc4f8c	ORION I	01943A	0	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	20.90	520	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	PESQUERA CRUZ DEL SUR  S.A.	Ciudad Autónoma de Buenos Aires		011-4784-1760	\N		\N	\N		t	\N	\N	\N
05a3c987-b073-4d25-b9c7-78d00993e03d	ORION 1	01943	\N	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	\N	\N	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	PESQUERA SANTA CRUZ  S.A.	Ciudad Autónoma de Buenos Aires		011-4305-4706	\N		\N	\N		t	\N	\N	\N
5e040861-22fb-4dfb-b081-eb17c8d9e0e8	ORION 3	02167	2170	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	63.10	1776	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	PESQUERA SANTA CRUZ  S.A.	Ciudad Autónoma de Buenos Aires		011-4305-4706	\N		\N	\N		t	\N	\N	\N
ee201bba-34a6-4230-ac57-fc1230e40286	ORYONG  756	02092	\N	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	\N	\N	9e675114-d5e6-449e-a20c-9688499c3c00	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
949b9a28-0ea8-4b75-97f5-f9662bd20d90	PACHACA	02572	2180	6fdf97a3-2f73-4a74-956b-414b0ca85b33	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	\N	4	17.64	320	b0b3126f-6cd0-4ab9-91db-f70b14747ee8	FLOTA AMARILLA RAWSON	Rawson			\N		\N	\N		t	\N	\N	\N
e3eaf214-5dbc-4b36-bf88-70e36c139fe1	PADRE PIO	02822	2737	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	24.00	451	5d12df00-152b-43e6-8ba0-20067e3bac8c	RITORNO SALLUSTIO Y CICCIOTTI  S.A.	Mar del Plata		480-5508	\N		\N	\N		t	\N	\N	\N
1e9eb065-512c-4874-a169-d90f56ffb0fc	PAGRUS II	01393	\N	6fdf97a3-2f73-4a74-956b-414b0ca85b33	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	\N	4	\N	\N	5d12df00-152b-43e6-8ba0-20067e3bac8c	COSTA BRAVA  S.A.	Mar del Plata		489-7538	\N		\N	\N		t	\N	\N	\N
9b0d0290-13d1-43ef-a61c-90d5daad442e	PAKU	0250	2186	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	39.16	1087	5d12df00-152b-43e6-8ba0-20067e3bac8c	LUIS SOLIMENO e HIJOS  S.A.	Mar del Plata		489-3030	\N		\N	\N		t	\N	\N	\N
1373b22b-66a4-4e1c-8358-8865301902c5	PALOMA V	64	\N	6cee615f-2f06-4187-ae28-3c9e9d5584cf	facaf1bb-b284-4017-ae4d-e423bf92bf7f	a3d52a88-3e07-46f5-b2f4-4c885f36886b	60	\N	\N	\N					\N		\N	\N		t	\N	\N	\N
ba57d775-2614-498e-9856-d5a220d8c034	PAOLA  S	0557	\N	\N	\N	\N	30	\N	\N	\N					\N		\N	\N		t	\N	\N	\N
4602d905-0edb-45b9-8c0e-6e07a725c3e3	PASA  82	0338	\N	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	\N	\N	9e675114-d5e6-449e-a20c-9688499c3c00	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
e96a1de6-1493-424c-9fbc-49352e162b62	PATAGONIA	0284	2196	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	30.95	660	5d12df00-152b-43e6-8ba0-20067e3bac8c	LUIS SOLIMENO e HIJOS  S.A.	Mar del Plata		489-3030	\N		\N	\N		t	\N	\N	\N
a857772e-7072-431d-8a25-40efaeca8cfb	PATAGONIA 1	02163	\N	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	\N	\N	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	PATAGONIA  FISHING  S.A.	Ciudad Autónoma de Buenos Aires		011-4932-2777	\N		\N	\N		t	\N	\N	\N
8b3096dd-48ae-4250-9a27-15d9dd8d8950	PATAGONIA 2	02164	\N	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	\N	\N	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	PATAGONIA  FISHING  S.A.	Ciudad Autónoma de Buenos Aires		011-4932-2777	\N		\N	\N		t	\N	\N	\N
007cc96d-b33e-4cca-9f13-2c53221454b8	PATAGONIA BLUES	02176	2199	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	64.45	1776	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	PESQUERA CRUZ DEL SUR  S.A.	Ciudad Autónoma de Buenos Aires		011-4784-1760	\N		\N	\N		t	\N	\N	\N
313017cd-7e96-4d97-8a53-66bd3ba0a5e4	PEDRITO	TEMP-0005	0	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	\N	39.92	1201	\N					\N		\N	\N		t	\N	\N	\N
e5642c63-80c4-43d6-a08d-ba25414c24e1	PELAGOS	83	\N	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	\N	\N	9e675114-d5e6-449e-a20c-9688499c3c00	PESQUERA SAN ISIDRO S.A.	Puerto Madryn		0280-447-2697	\N		\N	\N		t	\N	\N	\N
1c8fa93d-5afa-4b19-be40-16e6854cd067	PENSACOLA I	0747	2207	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	25.20	380	a5ac3578-1196-4340-92cd-02a78d856d6f	FRANGELA  S.A.	Comodoro Rivadavia			\N		\N	\N		t	\N	\N	\N
231c5017-9412-4806-9d08-d31ebcdb5383	PESCAPUERTA CUARTO	0171	\N	b509832f-10d9-4f7d-b71e-5bd4ecf88b38	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	60	\N	\N	9e675114-d5e6-449e-a20c-9688499c3c00	PESCAPUERTA ARGENTINA  S.A.	Puerto Madryn		0280-445-4407	\N		\N	\N		t	\N	\N	\N
c1a846c0-6b4b-49cf-96a0-930d0568ccaf	PESCAPUERTA QUINTO	0538	\N	d3857412-6a2e-47ef-82e8-ecd2ded34e55	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	1c1f245c-1079-42a0-a6a8-1db4ac5845d4	60	\N	\N	9e675114-d5e6-449e-a20c-9688499c3c00	PESCAPUERTA ARGENTINA  S.A.	Puerto Madryn		0280-445-4407	\N		\N	\N		t	\N	\N	\N
a54c2719-f1b2-4990-b7bc-1874ea6d2bfa	PESCARGEN  V	078	\N	b509832f-10d9-4f7d-b71e-5bd4ecf88b38	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	60	\N	\N	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	PESCARGEN  S.A.	Ciudad Autónoma de Buenos Aires		011-5219-0065 ó 5276-9499	\N		\N	\N		t	\N	\N	\N
6dc737d5-7437-49bd-b901-4fcf736bf3e4	PESCARGEN III	021	\N	b509832f-10d9-4f7d-b71e-5bd4ecf88b38	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	60	\N	\N	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	PESCARGEN  S.A.	Ciudad Autónoma de Buenos Aires		011-5219-0065 ó 5276-9499	\N		\N	\N		t	\N	\N	\N
b3fb60d6-d66c-43fe-8519-472b51d827a4	PESCARGEN IV	0150	2217	b509832f-10d9-4f7d-b71e-5bd4ecf88b38	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	60	63.20	1603	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	PESCARGEN  S.A.	Ciudad Autónoma de Buenos Aires		011-5219-0065 ó 5276-9499	\N		\N	\N		t	\N	\N	\N
5065589f-a7d6-4883-8951-dcf062cb3964	PESPASA  II	0212	\N	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	\N	\N	c0480dd3-e309-4e6d-8620-661c4fdfe0c7	PESPASA  S.A.	Puerto Deseado		0297-487-2030  int 12	\N		\N	\N		t	\N	\N	\N
f9b472ab-a17d-412a-894b-5f639262f05f	PESPASA I	0211	\N	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	\N	\N	c0480dd3-e309-4e6d-8620-661c4fdfe0c7	PESPASA  S.A.	Puerto Deseado		0297-487-2030  int 12	\N		\N	\N		t	\N	\N	\N
d228c811-ce0c-41f2-9cb2-c2872bd7ebc5	PETREL	01445	2224	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	29.85	776	5d12df00-152b-43e6-8ba0-20067e3bac8c	OLAMAR  S.A.	Mar del Plata		480-3573	\N		\N	\N		t	\N	\N	\N
308f4a25-5649-4678-952e-06c49d30886f	PEVEGASA QUINTO	02312	2225	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	38.65	740	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	PUNTA BUSTAMANTE  S.A.	Ciudad Autónoma de Buenos Aires		011-4305-4710 / 4712	\N		\N	\N		t	\N	\N	\N
b36b2ede-a2e3-47ce-a3ad-1fa26a3b0883	PIONEROS	02735	\N	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	\N	\N	5d12df00-152b-43e6-8ba0-20067e3bac8c	CALME  S.A.	Mar del Plata		480-3545	\N		\N	\N		t	\N	\N	\N
8d50d756-33dc-429b-b596-751f2d7c8504	POLARBORG I	02122	\N	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	\N	\N	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	GRINFIN  S.A.	Ciudad Autónoma de Buenos Aires		011-4343-5626	\N		\N	\N		t	\N	\N	\N
ca2ed8f7-8e3b-4088-93df-48cba0f32803	POLARBORG II	02117	\N	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	\N	\N	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	GRINFIN  S.A.	Ciudad Autónoma de Buenos Aires	4800005	011-4343-5626	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi	t	\N	\N	\N
bd7a8a7e-e0a4-400a-9e0d-44de47ba5c4c	PONTE CORUXO	0975	2242	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	52.85	1383	5d12df00-152b-43e6-8ba0-20067e3bac8c	BAL - FISH  S.A.	Mar del Plata		489-6522	\N		\N	\N		t	\N	\N	\N
af623ec0-cb51-4efa-b1ea-223cf23d8071	PONTE DE RANDE	0244	2243	b509832f-10d9-4f7d-b71e-5bd4ecf88b38	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	60	79.14	2964	5d12df00-152b-43e6-8ba0-20067e3bac8c	COSTA MARINA  S.A.	Mar del Plata		480-9608 / 481-0464	\N		\N	\N		t	\N	\N	\N
f19d15b8-20d1-4f37-809e-5b672f2db487	PORTO BELO I	02699	2736	6fdf97a3-2f73-4a74-956b-414b0ca85b33	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	\N	8	23.98	600	5d12df00-152b-43e6-8ba0-20067e3bac8c	FARO RECALADA  S.A	Mar del Plata		480-2442	\N		\N	\N		t	\N	\N	\N
cf4e6eca-ab53-4cab-93ca-004b426a7c65	PORTO BELO II	02790	2728	6fdf97a3-2f73-4a74-956b-414b0ca85b33	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	\N	10	23.98	601	5d12df00-152b-43e6-8ba0-20067e3bac8c	MARITIMA PORTO BELO  S.A.	Mar del Plata		489-1553	\N		\N	\N		t	\N	\N	\N
fccc6403-af2f-463c-966c-a30d7a59c1ad	PRINCIPE AZUL	TEMP-0006	\N	6fdf97a3-2f73-4a74-956b-414b0ca85b33	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	\N	10	\N	\N	5d12df00-152b-43e6-8ba0-20067e3bac8c		Mar del Plata			\N		\N	\N		t	\N	\N	\N
2fa71c08-ce31-4071-84f4-0f5ab634e86d	PROMAC	4815	2257	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	33.45	721	5d12df00-152b-43e6-8ba0-20067e3bac8c	LUIS SOLIMENO e HIJOS  S.A.	Mar del Plata		489-3030	\N		\N	\N		t	\N	\N	\N
f3222f01-a5e1-40c6-b49a-b1ff47f88a25	PROMARSA I	072	\N	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	\N	\N	9e675114-d5e6-449e-a20c-9688499c3c00	ALPESCA  S.A.	Puerto Madryn		0280-447-4958 / 45-1069	\N		\N	\N		t	\N	\N	\N
66f1ac7b-ac46-44a9-959b-2aeb4a0cce38	PROMARSA II	073	\N	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	\N	\N	9e675114-d5e6-449e-a20c-9688499c3c00	ALPESCA  S.A.	Puerto Madryn		0280-447-4958 / 45-1069	\N		\N	\N		t	\N	\N	\N
1a19cc18-bd6c-478f-a5be-753036c6bb74	PROMARSA III	02096	0	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	35.84	1062	9e675114-d5e6-449e-a20c-9688499c3c00	ALPESCA  S.A.	Puerto Madryn		0280-447-4958 / 45-1069	\N		\N	\N		t	\N	\N	\N
efa71c95-6258-4adc-ae09-8b23b8e2bde9	PUENTE VALDES	02205	2266	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	58.15	1383	9e675114-d5e6-449e-a20c-9688499c3c00	PEREIRA  ARGENTINA  S.A.	Puerto Madryn		0280-445-7377 / 447-2249	\N		\N	\N		t	\N	\N	\N
9fbdc295-1abe-4750-869c-5b591d8c3a3c	PUENTE AMERICA	0164	\N	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	\N	\N	9e675114-d5e6-449e-a20c-9688499c3c00	PEREIRA  ARGENTINA  S.A.	Puerto Madryn		0280-445-7377 / 447-2249	\N		\N	\N		t	\N	\N	\N
389787d5-55dc-4394-a9a8-30eb6ced1a7d	PUENTE CHICO	0756	2263	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	37.00	1175	9e675114-d5e6-449e-a20c-9688499c3c00	PEREIRA  ARGENTINA  S.A.	Puerto Madryn		0280-445-7377 / 447-2249	\N		\N	\N		t	\N	\N	\N
d536bec5-25a6-4a13-8364-da18ec14fb2a	PUENTE MAYOR	02630	2703	b509832f-10d9-4f7d-b71e-5bd4ecf88b38	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	60	66.86	2416	9e675114-d5e6-449e-a20c-9688499c3c00	PEREIRA  ARGENTINA  S.A.	Puerto Madryn		0280-445-7377 / 447-2249	\N		\N	\N		t	\N	\N	\N
33256b5a-c005-47d6-b1fd-16f08ed04fa8	PUENTE SAN JORGE	0207	2265	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	35.30	1001	9e675114-d5e6-449e-a20c-9688499c3c00	PEREIRA  ARGENTINA  S.A.	Puerto Madryn		0280-445-7377 / 447-2249	\N		\N	\N		t	\N	\N	\N
939e4b64-8856-48c2-97fc-06eb35e85107	PUERTO WILLIAMS	3178	\N	d3857412-6a2e-47ef-82e8-ecd2ded34e55	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	1c1f245c-1079-42a0-a6a8-1db4ac5845d4	60	\N	\N	c86100f2-ae86-47fd-999d-36b482dc11fc	DERIS  S.A.	Punta Arenas -  Chile		+613 6224-8744	\N		\N	\N		t	\N	\N	\N
1296d68c-35e1-4efa-a545-34c038862203	PUNTA BALLENA	65	\N	6cee615f-2f06-4187-ae28-3c9e9d5584cf	facaf1bb-b284-4017-ae4d-e423bf92bf7f	a3d52a88-3e07-46f5-b2f4-4c885f36886b	60	\N	\N	\N					\N		\N	\N		t	\N	\N	\N
4562cea1-e716-46a6-9a02-93b7b30c8d8b	QUEQUEN SALADO	0580	2277	6fdf97a3-2f73-4a74-956b-414b0ca85b33	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	\N	4	19.45	271	b0b3126f-6cd0-4ab9-91db-f70b14747ee8	PISCAL  S.A.	Rawson			\N		\N	\N		t	\N	\N	\N
ac5b3f8b-9376-47ec-b4aa-45dbbbd20f85	RAFFAELA	01401	2280	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	26.50	624	5d12df00-152b-43e6-8ba0-20067e3bac8c	PESQUERA RAFFAELA  S.A.	Mar del Plata		489-56574 int 203	\N		\N	\N		t	\N	\N	\N
a614d227-6493-4f47-ad7b-41ec45b732e6	RAQUEL	01074	\N	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	\N	\N	5d12df00-152b-43e6-8ba0-20067e3bac8c	PIEA  S.A.	Mar del Plata		489-6317 /489-1367	\N		\N	\N		t	\N	\N	\N
c87e2dcf-e8cd-4699-937b-c38a314517e6	REPUNTE	01120	\N	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	\N	\N	5d12df00-152b-43e6-8ba0-20067e3bac8c	OSTRAMAR  S.A.	Mar del Plata		489-1959	\N		\N	\N		t	\N	\N	\N
95f10822-14e7-45c3-8af3-6603af07b015	REYES DEL MAR II	0408	\N	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	\N	\N	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	AGUA MARINA  S.A.	Ciudad Autónoma de Buenos Aires		011-4342-0605 / 5656 / 1709	\N		\N	\N		t	\N	\N	\N
55d52593-c8ab-49bb-8a0b-985436dbead7	RIBAZON DORINE	0921	\N	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	\N	\N	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	KALEU KALEU  S.A.	Ciudad Autónoma de Buenos Aires		011-3220-2130  / 5093-1215	\N		\N	\N		t	\N	\N	\N
f8f88aa2-6c11-43dc-ae69-1fdfff05c596	RIBAZON INES	0751	2306	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	38.50	720	5d12df00-152b-43e6-8ba0-20067e3bac8c	SOUTH FISH  S.A.	Mar del Plata		480-5202	\N		\N	\N		t	\N	\N	\N
ff6469d6-cdea-4237-b3ac-d916a95b1f6a	RIGEL	0266	\N	6fdf97a3-2f73-4a74-956b-414b0ca85b33	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	\N	10	\N	\N	5d12df00-152b-43e6-8ba0-20067e3bac8c	LUIS SOLIMENO e HIJOS  S.A.	Mar del Plata		489-3030	\N		\N	\N		t	\N	\N	\N
7dc52372-885b-4d0d-b261-c6ffb020f775	ROCIO DEL MAR	01568	2313	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	15	22.60	541	5d12df00-152b-43e6-8ba0-20067e3bac8c	ROCIO DEL MAR  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
75e2145c-74ea-4063-ae72-074a9d477601	ROSARIO  G	0549	\N	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	\N	\N	9e675114-d5e6-449e-a20c-9688499c3c00	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
79930a7b-776e-49af-9f43-7c39708663f6	RUMBO ESPERANZA	01211	\N	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	\N	\N	a5ac3578-1196-4340-92cd-02a78d856d6f	CAPAC  SRL	Comodoro Rivadavia		0297-446-1499  /  444-2233	\N		\N	\N		t	\N	\N	\N
e206592e-b43e-41fc-b044-e685df4bb2fa	RYOUN MARU N° 17	JA06-03	\N	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	\N	\N	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	BAHIA GRANDE  S.A.	Ciudad Autónoma de Buenos Aires	4891553-154179360-154179860-154179062	011-5272-0850 / 5254-1133	\N	agenciasmiriglio@speedy.com.ar	\N	\N	Agencia Maritima Smiriglio	t	\N	\N	\N
115ea9d8-6731-4689-ba00-e50990aa99fc	SALVADOR R	02755	2761	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	27.73	420	5d12df00-152b-43e6-8ba0-20067e3bac8c	URBIPEZ  S.A.	Mar del Plata		4892793	\N		\N	\N		t	\N	\N	\N
720190ed-564d-4ad9-b28d-aea6ab574cf6	SAN ANDRES APOSTOL	0569	2340	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	54.56	2269	5d12df00-152b-43e6-8ba0-20067e3bac8c	PESANFLOR  S.A.	Mar del Plata		489-6522	\N		\N	\N		t	\N	\N	\N
09e4af37-699b-44f7-a5ee-9660da9e7d00	SAN ANTONINO	0375	\N	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	\N	\N	5d12df00-152b-43e6-8ba0-20067e3bac8c	SEA FISH  S.A.	Mar del Plata	51-11-65337853	480-0336	\N		\N	\N	Natalia Cedrato	t	\N	\N	\N
96bd0a31-93a4-447f-8be0-6bff3b5ecf41	VALERIA DEL ATLÁNTICO	02098	2346	d3857412-6a2e-47ef-82e8-ecd2ded34e55	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	1c1f245c-1079-42a0-a6a8-1db4ac5845d4	60	56.46	4698	5d12df00-152b-43e6-8ba0-20067e3bac8c	SAN ARAWA  S.A.	Mar del Plata		492-2216 / 492-0450	\N		\N	\N		t	\N	\N	\N
d4a03379-87bc-4e67-9962-c208db3d5780	SAN BENEDETTO	02643	0	6fdf97a3-2f73-4a74-956b-414b0ca85b33	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	\N	8	15.38	220	5d12df00-152b-43e6-8ba0-20067e3bac8c	PESQUERA SAN BENEDETTO  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
f61c6cb4-7a63-4fd9-a87f-e2f596b70f1a	SAN GENARO	0763	\N	6fdf97a3-2f73-4a74-956b-414b0ca85b33	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	\N	10	\N	\N	5d12df00-152b-43e6-8ba0-20067e3bac8c	LESAUMON  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
e80ea858-cb36-4e41-9b6d-8a993c36e724	SAN JUAN B	TEMP-0007	2780	\N	\N	\N	\N	39.94	1204	\N					\N		\N	\N		t	\N	\N	\N
cd5f589c-d2dc-420d-bf01-45e0980cd056	SAN JORGE MARTIR	02152	2367	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	56.10	1408	5d12df00-152b-43e6-8ba0-20067e3bac8c	PESANFLOR  S.A.	Mar del Plata		489-6522	\N		\N	\N		t	\N	\N	\N
a8088d9f-df9e-480e-9fc1-7b45ba2bbc0d	SAN LUCAS  I	06147	\N	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	\N	\N	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	AGUA MARINA  S.A.	Ciudad Autónoma de Buenos Aires		011-4342-0605 / 5656 / 1709	\N		\N	\N		t	\N	\N	\N
914be22d-1ab1-4483-96a1-f5458b92c017	SAN MATEO	06306	0	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	54.10	1234	b0b3126f-6cd0-4ab9-91db-f70b14747ee8	IBERPESCA  S.A.	Rawson		0280-449-8176	\N		\N	\N		t	\N	\N	\N
d5904aeb-6a6a-4659-923f-e7b78667f0f6	SAN MATIAS	0289	\N	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	\N	\N	5d12df00-152b-43e6-8ba0-20067e3bac8c	PESCA  ANTIGUA  S.A.	Mar del Plata		489-2340	\N		\N	\N		t	\N	\N	\N
25e98354-7fab-4134-91ea-257f9c83f75a	SAN PABLO	0759	\N	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	\N	\N	5d12df00-152b-43e6-8ba0-20067e3bac8c	PRODUCTORA ARGEN-PESCA  S.A.	Mar del Plata		480-1444	\N		\N	\N		t	\N	\N	\N
1e1bec46-1594-4289-8a76-bb3f0357ecec	SAN PASCUAL	0367	\N	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	\N	\N	5d12df00-152b-43e6-8ba0-20067e3bac8c	BUENOS AIRES PESCA  S.A.	Mar del Plata		489-6522	\N		\N	\N		t	\N	\N	\N
8166bccd-2297-458c-8bb8-f3e40f9ff14c	SAN PEDRO APOSTOL	01975	\N	6fdf97a3-2f73-4a74-956b-414b0ca85b33	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	\N	10	\N	\N	5d12df00-152b-43e6-8ba0-20067e3bac8c	GAAD GROUP S.A.	Mar del Plata		480-9327	\N		\N	\N		t	\N	\N	\N
779772d1-8ef6-4e03-bb24-39ae8c7b4664	SANT ANTONIO	0974	\N	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	\N	\N	5d12df00-152b-43e6-8ba0-20067e3bac8c	A.B.H. PESQUERA  S.A.	Mar del Plata	4895032	489-6522	\N	operacionesconsultoramaritima@gmail.com.ar	\N	\N	Agencia Merlini	t	\N	\N	\N
66162aa3-79df-4894-a4f4-e5354d231c17	SANTA BARBARA	5857	2409	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	56.96	1679	5d12df00-152b-43e6-8ba0-20067e3bac8c	PESCA ANGELA  S.A.	Mar del Plata		626-2236 /37	\N		\N	\N		t	\N	\N	\N
2be9b942-24f4-40d3-911e-25f73b2c90f4	SANTA ANGELA	009	\N	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	\N	\N	5d12df00-152b-43e6-8ba0-20067e3bac8c	OSTRAMAR  S.A.	Mar del Plata		489-1959	\N		\N	\N		t	\N	\N	\N
85367aab-5929-45cb-9442-12ad834242bb	SANTIAGO  I	02280	\N	\N	\N	\N	0	\N	\N	9e675114-d5e6-449e-a20c-9688499c3c00	FISHING WORLD  S.A.	Puerto Madryn		0280-445-6533	\N		\N	\N		t	\N	\N	\N
921868fd-ad81-4d46-b3a5-8d59564fb909	SCIROCCO	2574	2430	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	65.93	1589	5d12df00-152b-43e6-8ba0-20067e3bac8c	PESQUERA COMERCIAL  S.A.	Mar del Plata		489-3030	\N		\N	\N		t	\N	\N	\N
c68d07c6-a15a-41ee-b2d5-cc018789e175	SCOMBRUS	0509	\N	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	\N	\N	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	KALEU KALEU  S.A.	Ciudad Autónoma de Buenos Aires		011-3220-2130  / 5093-1215	\N		\N	\N		t	\N	\N	\N
a7136cea-f96c-43da-aa08-c925ae56b551	SCOMBRUS  II	02245	\N	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	\N	\N	9e675114-d5e6-449e-a20c-9688499c3c00	HARENGUS  S.A.	Puerto Madryn		0280-445-0822	\N		\N	\N		t	\N	\N	\N
1bbb0c4f-1123-45c9-9168-9fbd6a0a6e5c	SERMILIK	0505	\N	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	\N	\N	9e675114-d5e6-449e-a20c-9688499c3c00	HARENGUS  S.A.	Puerto Madryn	4891553-154179360-154179860-154179062	0280-445-0822	\N	agenciasmiriglio@speedy.com.ar	\N	\N	Agencia Smiriglio	t	\N	\N	\N
90517596-f31b-4c36-830b-106eac58fe1e	SFIDA	01567	2439	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	26.50	624	5d12df00-152b-43e6-8ba0-20067e3bac8c	SAN JORGE S.A.	Mar del Plata		480-6611	\N		\N	\N		t	\N	\N	\N
a87f5ace-baed-481a-b91a-5c5a3ead605c	SHUNYO MARU 178	JA04	\N	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	\N	\N	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	VIEIRA ARGENTINA  S.A.	Ciudad Autónoma de Buenos Aires			\N		\N	\N		t	\N	\N	\N
2795d3c6-f14d-4c4c-9519-fa08234c4f1e	SIEMPRE DON JOSE MOSCUZZA	02257	2460	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	38.00	1128	5d12df00-152b-43e6-8ba0-20067e3bac8c	FRESCOMAR ARGENTINA  S.A.	Mar del Plata		489-7287	\N		\N	\N		t	\N	\N	\N
b7979978-5417-4d7e-8f3c-b2c9cd4e7bd5	SIEMPRE DON VICENTE	02654	2706	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	18.94	341	5d12df00-152b-43e6-8ba0-20067e3bac8c	PESQUERA VIRGEN DE ITATI  S.R.L.	Mar del Plata		480-2921	\N		\N	\N		t	\N	\N	\N
61c08b67-bb72-4f64-8613-ddbab60f28d2	SIEMPRE SAN SALVADOR	00801	2475	6fdf97a3-2f73-4a74-956b-414b0ca85b33	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	\N	8	22.35	600	5d12df00-152b-43e6-8ba0-20067e3bac8c	LOURDESMAR  S.R.L.	Mar del Plata		476-2916	\N		\N	\N		t	\N	\N	\N
91dabaa0-af98-4864-9923-be86c4a50745	SIEMPRE SANTA ROSA	0494	2476	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	27.80	548	5d12df00-152b-43e6-8ba0-20067e3bac8c	GIORNO  S.A.	Mar del Plata		410-0051 / 0057	\N		\N	\N		t	\N	\N	\N
f6d7eba5-c615-4450-9187-c0890ad0a7e1	SIEMPRE VIEJO PANCHO	2937	2755	6fdf97a3-2f73-4a74-956b-414b0ca85b33	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	\N	15	17.98	601	\N					\N		\N	\N		t	\N	\N	\N
f16450c1-96a3-4f20-855b-9678f98283bf	SIMBAD	0754	\N	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	\N	\N	5d12df00-152b-43e6-8ba0-20067e3bac8c	SOUTH FISH  S.A.	Mar del Plata		480-5202	\N		\N	\N		t	\N	\N	\N
3d498418-516b-43ae-b71f-4879bce5c4f6	SIRIUS	0905	\N	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	\N	\N	5d12df00-152b-43e6-8ba0-20067e3bac8c	LOBA PESQUERA  S.A.M.C.I.	Mar del Plata	4890960	489-0494  /  481-1814	\N	agencia@maritimavidal.com.ar	\N	\N	Agencia Maritima Vidal	t	\N	\N	\N
0bed525b-2356-41f5-b4b2-bc08f9970ce3	SIRIUS II	0936	2489	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	59.25	1289	5d12df00-152b-43e6-8ba0-20067e3bac8c	EL MARISCO  S.A.	Mar del Plata	4890960	489-0384	\N	agencia@maritimavidal.com.ar	\N	\N	Agencia Maritima Vidal	t	\N	\N	\N
cc88c038-eed9-4ee6-b50a-00ab7127f44a	SIRIUS III	0937	\N	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	\N	\N	5d12df00-152b-43e6-8ba0-20067e3bac8c	EL MARISCO  S.A.	Mar del Plata	4808331/4808332	489-0384	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
15a63476-e520-4a78-a3be-1f59ba28426a	SOHO MARU Nº 58	02611	2492	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	65.67	1776	c0480dd3-e309-4e6d-8620-661c4fdfe0c7	ARGENOVA  S.A.	Puerto Deseado		0297- 487-0550  (447-2818  Com. Riv )	\N		\N	\N		t	\N	\N	\N
d6cfe2b9-a234-41c9-a352-959c7c46e064	SOL MARINO	77	\N	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	\N	\N	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	PESQUERA  20  DE NOVIEMBRE  S.A.	Ciudad Autónoma de Buenos Aires		011-4382-5011 / 4381-1337	\N		\N	\N		t	\N	\N	\N
1b62a88b-89cb-46cc-994f-c5e758f62ee8	STELLA MARIS 1°	0926	\N	b509832f-10d9-4f7d-b71e-5bd4ecf88b38	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	60	\N	\N	5d12df00-152b-43e6-8ba0-20067e3bac8c	ALIMENPEZ  S.A.	Mar del Plata		461-9200	\N		\N	\N		t	\N	\N	\N
2d1b1d44-615c-4236-a478-025267bc722b	SUEMAR	6186	2722	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	36.60	1168	9e675114-d5e6-449e-a20c-9688499c3c00	CONGELADORES PATAGONICOS  S.A.	Puerto Madryn		0280-445-6280	\N		\N	\N		t	\N	\N	\N
1e42a467-608e-4c5a-bcf7-2cc76f9eb1af	SUEMAR DOS	01508	\N	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	\N	\N	9e675114-d5e6-449e-a20c-9688499c3c00	CONGELADORES PATAGONICOS  S.A.	Puerto Madryn		0280-445-6280	\N		\N	\N		t	\N	\N	\N
ccbd9582-04ee-49b4-87b1-c54264562356	SUMATRA	01105	2512	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	33.15	750	5d12df00-152b-43e6-8ba0-20067e3bac8c	CALME  S.A.	Mar del Plata		480-3545	\N		\N	\N		t	\N	\N	\N
5707d7ce-1cd6-4a81-a73b-a06983539f2d	SUR ESTE 501	01077	\N	ffd6bec1-d077-453b-859b-c422e7e00e62	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	\N	30	\N	\N	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	SUR ESTE ARGEN  S.A.	Ciudad Autónoma de Buenos Aires		011-4816-7648 / 4372-7605	\N		\N	\N		t	\N	\N	\N
3cd9695e-c4ea-4927-ba72-f4c010bc757d	SUR ESTE 502	02201	2520	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	54.60	1670	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	SUR ESTE ARGEN  S.A.	Ciudad Autónoma de Buenos Aires		011-4816-7648 / 4372-7605	\N		\N	\N		t	\N	\N	\N
4c91475a-8829-4920-87bd-0bf74e16733b	SURIMI I	06143	\N	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	\N	\N	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	FARO DEL SUR TRADING  S.A.	Ciudad Autónoma de Buenos Aires		011-4555-4956	\N		\N	\N		t	\N	\N	\N
572d00f6-0c38-4862-8b8f-0add39ec5f7e	TABEIRON	02233	2529	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	40	34.15	889	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	VIEIRA ARGENTINA  S.A.	Ciudad Autónoma de Buenos Aires			\N		\N	\N		t	\N	\N	\N
f66e692c-2a2e-4276-b566-f0bf308ef755	TABEIRON DOS	02323	\N	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	\N	\N	c0480dd3-e309-4e6d-8620-661c4fdfe0c7	PESQUERA DESEADO  S.A.	Puerto Deseado	54-11-65337853	0297-487-0884 / 0327 / 2407	\N		\N	\N	Natalia Cedrato	t	\N	\N	\N
ac21bbd5-9f0e-4b09-841e-df56f420586c	Nº 75 TAE BAEK	02364	2138	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	55.70	1302	9e675114-d5e6-449e-a20c-9688499c3c00	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
0f888981-a598-4668-9973-634c25211f59	Nº 606 TAE BAEK	02361	2148	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	55.22	1036	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	ESAMAR  S.A.	Ciudad Autónoma de Buenos Aires		011-4393-8431	\N		\N	\N	54 – 9 - 1141714381	t	\N	\N	\N
8eb864be-6c72-482d-85ed-747bc6e2f376	TAI AN	1530	2533	ec55ad96-050b-4968-a508-4d438deab9f6	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	60	100.50	4506	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	PRODESUR S.A	Ciudad Autónoma de Buenos Aires		492-2216 / 492-0450	\N		\N	\N	54 – 9 - 1141714381	t	\N	\N	\N
fc378352-fd38-436f-bbba-482965d36c4d	TAI SEI MARU N°8	02207	\N	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	\N	\N	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	CORPORACION DEL ATLANTICO SUR  S.A.	Ciudad Autónoma de Buenos Aires		011-4105-1133 int 30	\N		\N	\N		t	\N	\N	\N
53df37fa-4876-4db9-8044-82c60dca71e7	TALISMAN	02263	2541	401c7d42-1de7-41b7-820a-948b432b72eb	8ef217f2-61c5-439a-a902-0d110b010653	f4dfbae3-8a9b-4e7a-acba-439207f86b95	30	49.95	1302	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	CENTOMAR  S.A.	Ciudad Autónoma de Buenos Aires		011-4816-6245 / 6260  int  * 35	\N		\N	\N		t	\N	\N	\N
47279cdd-c76c-4f3d-a415-a7a608071774	TANGO I	02724	2709	401c7d42-1de7-41b7-820a-948b432b72eb	8ef217f2-61c5-439a-a902-0d110b010653	f4dfbae3-8a9b-4e7a-acba-439207f86b95	30	50.40	1302	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	BENTONICOS DE ARGENTINA  S.A.	Ciudad Autónoma de Buenos Aires		011-5258-2400 / 4407-8240	\N		\N	\N		t	\N	\N	\N
6c8c18f7-5a09-4d3c-87d1-d237f3d91347	TANGO II	02791	2714	401c7d42-1de7-41b7-820a-948b432b72eb	8ef217f2-61c5-439a-a902-0d110b010653	f4dfbae3-8a9b-4e7a-acba-439207f86b95	30	50.40	1302	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	BENTONICOS DE ARGENTINA  S.A.	Ciudad Autónoma de Buenos Aires	4891227	011-5258-2400 / 4407-8240	\N	serviciosmaritimosmdq@gmail.com	\N	\N	Servicios maritimos	t	\N	\N	\N
5f888a8d-5b14-4e4e-9446-40e3274994ea	TESON	01541	2552	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	25.97	765	5d12df00-152b-43e6-8ba0-20067e3bac8c	RITORNO SALLUSTIO Y CICCIOTTI  S.A.	Mar del Plata		480-5508	\N		\N	\N		t	\N	\N	\N
19bc0d6d-9f13-4b54-a3ac-73495dedfb76	TIAN YUAN	02173	\N	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	\N	\N	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	CORPORACION DEL ATLANTICO SUR  S.A.	Ciudad Autónoma de Buenos Aires		011-4105-1133 int 30	\N		\N	\N		t	\N	\N	\N
d0908e08-c6ab-4844-9525-d0ca52a3e487	TOBA MARU	0241	\N	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	\N	\N	9e675114-d5e6-449e-a20c-9688499c3c00	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
f3672ed7-3825-4da3-bc22-b961506a46f1	TORNYY	240	\N	401c7d42-1de7-41b7-820a-948b432b72eb	8ef217f2-61c5-439a-a902-0d110b010653	f4dfbae3-8a9b-4e7a-acba-439207f86b95	30	\N	\N	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	CRUSTACEOS DEL SUR  S.A.	Ciudad Autónoma de Buenos Aires		011-5218-4287	\N		\N	\N		t	\N	\N	\N
ab13c851-9fec-463a-93b8-da24b3bc67d3	TOZUDO	01219	2566	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	26.74	624	5d12df00-152b-43e6-8ba0-20067e3bac8c	CABO VERDE  S.A.	Mar del Plata		489-4645	\N		\N	\N		t	\N	\N	\N
d6d122fd-a858-41f7-b184-152a83af6c5e	TRABAJAMOS	02904	2726	6fdf97a3-2f73-4a74-956b-414b0ca85b33	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	\N	4	19.94	592	c0480dd3-e309-4e6d-8620-661c4fdfe0c7	DESEADO FISH  S.A.	Puerto Deseado			\N		\N	\N		t	\N	\N	\N
e5305ab2-850a-4e7e-941d-dab90aa7da91	UCHI	01901	2580	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	54.23	1552	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	PESQUERA SANTA ELENA S.A.I.C.	Ciudad Autónoma de Buenos Aires		011-4328-9909	\N		\N	\N		t	\N	\N	\N
2f35f832-fba8-459a-b2b8-9d79faeaa844	UNION	01539	\N	6fdf97a3-2f73-4a74-956b-414b0ca85b33	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	\N	10	\N	\N	5d12df00-152b-43e6-8ba0-20067e3bac8c	RITORNO SALLUSTIO Y CICCIOTTI  S.A.	Mar del Plata		480-5508	\N		\N	\N		t	\N	\N	\N
09804c27-1061-4806-95a6-064d84518dfc	URABAIN	0612	\N	b509832f-10d9-4f7d-b71e-5bd4ecf88b38	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	60	\N	\N	9e675114-d5e6-449e-a20c-9688499c3c00	IBERCONSA  DE ARGENTINA  S.A.	Puerto Madryn	mariano@maritimavidal.com.ar	0280-445-4324	\N		\N	\N	raul@maritimavidal.com.ar	t	\N	\N	\N
1fc9c088-da05-4d5c-b833-e3a9be7bc1e3	UR ERTZA	0377	2587	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	51.00	1482	5d12df00-152b-43e6-8ba0-20067e3bac8c	LUIS SOLIMENO e HIJOS  S.A.	Mar del Plata		489-3030	\N		\N	\N		t	\N	\N	\N
e16da459-2289-48cf-9538-608abc623c04	VALIENTE I	0211A	\N	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	\N	\N	5d12df00-152b-43e6-8ba0-20067e3bac8c	EXPLOTACION PESQ. DE LA PATAGONIA  S.A.	Mar del Plata		489-4624  /  489-0314 (astillero)	\N		\N	\N		t	\N	\N	\N
53b1819f-3dd5-4bb5-a444-51bc15378668	VALIENTE II	0212A	2718	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	35.30	1001	5d12df00-152b-43e6-8ba0-20067e3bac8c	EXPLOTACION PESQ. DE LA PATAGONIA  S.A.	Mar del Plata		489-4624  /  489-0314 (astillero)	\N		\N	\N	agencia@maritimavidal.com.ar	t	\N	\N	\N
0db25c55-347d-41e4-bc64-bec1179455da	VENTARRON 1º	0479	2708	b509832f-10d9-4f7d-b71e-5bd4ecf88b38	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	60	63.07	1969	9e675114-d5e6-449e-a20c-9688499c3c00	ATUNERA  ARGENTINA  S.A.	Puerto Madryn		0280-445-4324	\N		\N	\N		t	\N	\N	\N
d429cf90-1239-4e85-9693-d042a6bf97ea	VERAZ	0144	2603	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	27.45	604	5d12df00-152b-43e6-8ba0-20067e3bac8c	PESQUERA VERAZ  S.A.	Mar del Plata		489-4624 / 489-0314 (astillero)	\N		\N	\N		t	\N	\N	\N
f8fb838e-1c8d-437e-aa7e-8ef0a5e2080a	VERDEL	0174	2604	b509832f-10d9-4f7d-b71e-5bd4ecf88b38	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	60	71.70	1975	700d1050-2d8c-4c23-a7ea-d73eecb7ec63	IBERMAR  S.A.	Bahia Blanca		0291-457-2427	\N		\N	\N		t	\N	\N	\N
f3300160-5cd6-459b-a08b-34043f37cc20	VERONICA ALEJANDRA N	02292	2606	6fdf97a3-2f73-4a74-956b-414b0ca85b33	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	\N	4	15.30	223	b0b3126f-6cd0-4ab9-91db-f70b14747ee8	FARO CHUBUT  S.R.L.	Rawson		0280-449-6311	\N		\N	\N		t	\N	\N	\N
d895f778-12cc-4998-84d8-d8245ec560ca	VICTOR ANGELESCU	9798820	\N	ec991fe3-facd-4b3a-9721-af02673136d1	\N	\N	\N	\N	\N	\N	INIDEP				\N		\N	\N		t	\N	\N	\N
e2cd735a-b1f1-4ba1-8470-63c96a90da33	VICTORIA DEL MAR 1°	0929	\N	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	\N	\N	5d12df00-152b-43e6-8ba0-20067e3bac8c	RIPSA  S.A. ( ROSALES INDUSTRIAL PESQ. )	Mar del Plata		489-7881	\N		\N	\N		t	\N	\N	\N
3b7f8fb7-dcc3-4869-a8f7-335477c3bc16	VICTORIA I	0554	\N	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	\N	\N	9e675114-d5e6-449e-a20c-9688499c3c00	PEREIRA  ARGENTINA  S.A.	Puerto Madryn		0280-445-7377 / 447-2249	\N		\N	\N		t	\N	\N	\N
4af543ff-ae68-4c97-a0cb-4b8dae4cc03a	VICTORIA II	0556	2611	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	27.40	601	5d12df00-152b-43e6-8ba0-20067e3bac8c	CRESTAS  S.A.	Mar del Plata		410-5170	\N		\N	\N		t	\N	\N	\N
5dcf34ef-24b8-41a7-bd74-2887f2cf00a7	VICTORIA P	02246	\N	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	\N	\N	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	PESQUERA SANTA ELENA S.A.I.C.	Ciudad Autónoma de Buenos Aires		011-4328-9909	\N		\N	\N		t	\N	\N	\N
8dd295e9-3e3c-4b6e-b1a4-761424b19411	VIEIRASA DIECIOCHO	2563	2615	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	67.78	1803	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	VIEIRA ARGENTINA  S.A.	Ciudad Autónoma de Buenos Aires			\N		\N	\N		t	\N	\N	\N
bd6e7643-5cda-4331-88ed-b68c45021e17	VIEIRASA DIECISEIS	0240	2616	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	36.13	702	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	VIEIRA ARGENTINA  S.A.	Ciudad Autónoma de Buenos Aires			\N		\N	\N		t	\N	\N	\N
d1fa7ae4-d610-42da-8de0-76abce7b7e6c	VIEIRASA DIECISIETE	2568	2752	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	59.03	1401	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	VIEIRA ARGENTINA  S.A.	Ciudad Autónoma de Buenos Aires			\N		\N	\N		t	\N	\N	\N
60d64c50-1031-42b4-9bb3-a6c29429930c	VIEIRASA QUINCE	0179	\N	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	\N	\N	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	VIEIRA ARGENTINA  S.A.	Ciudad Autónoma de Buenos Aires			\N		\N	\N		t	\N	\N	\N
63cc54d5-1757-402b-a2fd-4f04475213b6	VIENTO DEL SUR	01858	\N	d3857412-6a2e-47ef-82e8-ecd2ded34e55	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	1c1f245c-1079-42a0-a6a8-1db4ac5845d4	60	\N	\N	c0480dd3-e309-4e6d-8620-661c4fdfe0c7	PESPASA  S.A.	Puerto Deseado		0297-487-2030  int 12	\N		\N	\N		t	\N	\N	\N
c9e1f7b6-275b-4973-80ae-1f79d69adbac	VILLARINO	02178	2629	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	64.50	1776	6db9804f-a2e7-4f42-bdb9-9b3e17c3449f	PESCA AUSTRAL  S.A.	San Antonio Oeste		02934-49-2111	\N		\N	\N		t	\N	\N	\N
9a682af9-7e77-437b-9400-ca501e2df620	VIRGEN DEL CARMEN	0550	\N	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	\N	\N	5d12df00-152b-43e6-8ba0-20067e3bac8c	MAR PURO  S.A.	Mar del Plata		451-1830	\N		\N	\N		t	\N	\N	\N
3f9cf6ff-6378-4633-b945-1a4f9b75ebb0	VIRGEN DEL MILAGRO	02767	2725	6fdf97a3-2f73-4a74-956b-414b0ca85b33	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	\N	4	19.93	380	c0480dd3-e309-4e6d-8620-661c4fdfe0c7	UNION PESQUERA PATAGONIA  S.A.	Puerto Deseado			\N		\N	\N		t	\N	\N	\N
c1396ade-e133-49f5-be3c-30d855df0372	VIRGEN DEL ROCIO	0194	\N	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	\N	\N	9e675114-d5e6-449e-a20c-9688499c3c00	ALPESCA  S.A.	Puerto Madryn		0280-447-4958 / 45-1069	\N		\N	\N		t	\N	\N	\N
508f31e8-ed6a-484f-9e08-420288064198	VIRGEN MARIA	0541	2645	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	56.65	1803	5d12df00-152b-43e6-8ba0-20067e3bac8c	LUIS SOLIMENO e HIJOS  S.A.	Mar del Plata		489-3030	\N		\N	\N		t	\N	\N	\N
1bdd5e6c-f8ec-4073-b7e3-f04416899330	VIRGEN MARIA INMACULADA	0369	\N	6fdf97a3-2f73-4a74-956b-414b0ca85b33	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	\N	10	\N	\N	\N					\N		\N	\N		t	\N	\N	\N
b5d71d2f-3dec-4f70-9aef-24b434a3a7b0	WIRON  IV	01476	\N	6cadfcb1-5dd7-4563-9fae-04561513659c	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	30	\N	\N	5d12df00-152b-43e6-8ba0-20067e3bac8c	TATURIELLO  S.A.	Mar del Plata		489-3833	\N		\N	\N		t	\N	\N	\N
86cb6687-b67d-4ea6-9eda-41d661113304	XEITOSIÑO	0403	2668	b509832f-10d9-4f7d-b71e-5bd4ecf88b38	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	60	51.72	1502	5d12df00-152b-43e6-8ba0-20067e3bac8c	PESQUERA EL NAZARENO	Mar del Plata		489-9414 (of. Pers. Emb.)	\N		\N	\N		t	\N	\N	\N
ab829d1d-bb6f-4c1a-8ca6-a618fd361b96	XIN SHI DAI N° 28	02165	2669	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	62.40	1579	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	MUELLE OCHO  S.A.	Ciudad Autónoma de Buenos Aires		011-4381-1337	\N		\N	\N		t	\N	\N	\N
fea5606d-06bf-4909-becf-fec8289dac9f	XIN SHI JI 25	03092	2753	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	70.50	0	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	PESQUERA  20  DE NOVIEMBRE  S.A.	Ciudad Autónoma de Buenos Aires		011-4382-5011 / 4381-1337	\N		\N	\N		t	\N	\N	\N
fab382b7-3323-425f-85f3-55a26567765b	XIN SHI JI N° 88	02182	\N	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	\N	\N	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	FENIX  INTERNATIONAL  S.A.	Ciudad Autónoma de Buenos Aires		011-4381-1337	\N		\N	\N		t	\N	\N	\N
e0e77b01-c5fa-450f-a801-d49ebc588904	XIN SHI JI Nº 89	02903	2750	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	68.58	2685	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	FENIX  INTERNATIONAL  S.A.	Ciudad Autónoma de Buenos Aires		011-4381-1337	\N		\N	\N		t	\N	\N	\N
c14620e2-0615-491f-8ba4-2f721979e330	XIN SHI JI Nº 91	02924	2724	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	68.58	2685	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	FENIX  INTERNATIONAL  S.A.	Ciudad Autónoma de Buenos Aires		011-4381-1337	\N		\N	\N		t	\N	\N	\N
a13fffd1-cc43-4018-b37a-4f84550885e0	XIN SHI JI Nº 92	02930	2742	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	68.58	2685	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	FENIX  INTERNATIONAL  S.A.	Ciudad Autónoma de Buenos Aires		011-4381-1337	\N		\N	\N		t	\N	\N	\N
e872c136-9f65-4324-8c9e-80e47d41d232	XIN SHI JI Nº 95	02933	2732	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	68.58	2685	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	PESQUERA  20  DE NOVIEMBRE  S.A.	Ciudad Autónoma de Buenos Aires	155-282636 - Facundo	011-4382-5011 / 4381-1337	\N		\N	\N	Agencia Di Yorio	t	\N	\N	\N
1883fe74-ce11-40e7-95a1-e14a8d033809	XIN SHI JI N° 99	02181	2674	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	65.10	2173	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	FENIX  INTERNATIONAL  S.A.	Ciudad Autónoma de Buenos Aires		011-4381-1337	\N		\N	\N		t	\N	\N	\N
54611305-3ddf-4a75-8c60-1f2f12a7b5ac	XIN SHI JI Nº 98	02995	\N	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	\N	\N	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	PESQUERA  20  DE NOVIEMBRE  S.A.	Ciudad Autónoma de Buenos Aires		011-4382-5011 / 4381-1337	\N		\N	\N		t	\N	\N	\N
b9c70290-1b5e-427e-a5ad-c5c1e440d249	YAMATO	077	\N	ec55ad96-050b-4968-a508-4d438deab9f6	eadd543b-54c9-4c06-a5b7-f10df7cb91ae	bc86d2a9-3de5-494d-91aa-207e2eadbe81	60	\N	\N	c86100f2-ae86-47fd-999d-36b482dc11fc	PESANTAR  S.A. ( Empresa Pesq de la Patagonia y Antartida )	Ushuaia		02901-43-3449 / 43-0008 / 43-0708	\N		\N	\N		t	\N	\N	\N
9abdb878-fb3a-4b7c-b906-89d35a981900	YENU	0498A	\N	d9041427-00b4-42b8-8306-9d6e7b9bc16f	814946a3-1e99-4d4c-8c23-59f6b7421e5a	b0113ae4-988a-4010-a1cf-f72572ea68fb	30	\N	\N	700d1050-2d8c-4c23-a7ea-d73eecb7ec63	MARITIMA MONACHESI  S.A.	Bahia Blanca		0291-452-5913	\N		\N	\N		t	\N	\N	\N
b9edcf49-d3f7-4b1b-9be1-4585e7421be7	YOKO MARU	UY252	\N	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	\N	\N	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	EMPESUR  S.A.	Ciudad Autónoma de Buenos Aires		011-4312-0123	\N		\N	\N		t	\N	\N	\N
3b90ba42-72ff-4f7f-87df-d68b32105ffb	ZHOU YU YI HAO	CH251	\N	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	\N	\N	8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	VIEIRA ARGENTINA  S.A.	Ciudad Autónoma de Buenos Aires			\N		\N	\N		t	\N	\N	\N
83e4b06f-66ec-4a7b-aa7d-92cbb4e7d626	HOLMBERG	7918189	\N	ec991fe3-facd-4b3a-9721-af02673136d1	\N	\N	\N	\N	\N	\N	INIDEP				\N		\N	\N		t	\N	\N	\N
1629347a-3ae3-4b08-8895-ad9713f53b45	MAR ARGENTINO	9883833	\N	ec991fe3-facd-4b3a-9721-af02673136d1	\N	\N	\N	\N	\N	\N	INIDEP				\N		\N	\N		t	\N	\N	\N
876b619b-415f-46fc-97d6-9b2426352d5e	Hai Xiang 16	LW5157	\N	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	\N	\N	\N	PESQUERA RÍO QUEQUEN				\N		\N	\N		t	\N	\N	\N
bc7a5a8c-77d8-471c-b6cb-d2fc5a68e09d	Hai Xiang 17	LW3286	\N	5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	983c24a2-a641-4585-a374-6e21ed383ac1	3b938974-38a9-4b5b-ac50-a88465f7a025	40	\N	\N	\N	PESQUERA RÍO QUEQUEN				\N		\N	\N		t	\N	\N	\N
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
b43d7a7f-6462-4146-abb0-93f7ccaac9b6	2026-01-02 04:31:54.01+00	ERROR	BACKEND	GlobalExceptionFilter	\N	\N	Token de refresco inválido o expirado	UnauthorizedException: Token de refresco inválido o expirado\n    at AuthService.refreshAuth (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\auth\\auth.service.ts:230:13)\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async AuthController.refreshAuth (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\auth\\auth.controller.ts:58:18)\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:46:28\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-proxy.js:9:17	{"query": {}, "params": {}, "exception": {"error": "Unauthorized", "message": "Token de refresco inválido o expirado", "statusCode": 401}}	/api/auth/refresh	GET	::1
521960c2-f8ca-4db8-9326-e58862105182	2026-01-02 04:58:32.292+00	ERROR	BACKEND	GlobalExceptionFilter	c048e295-762b-4d27-9c9c-e652e47ca1bd	admin@obs.com	Confirmation phrase is incorrect	ConflictException: Confirmation phrase is incorrect\n    at BackupService.restoreBackup (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\admin\\backup\\backup.service.ts:79:19)\n    at BackupController.restoreBackup (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\admin\\backup\\backup.controller.ts:31:35)\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:38:29\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:46:28\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-proxy.js:9:17	{"body": {"confirmationPhrase": "restyaurar base de datos"}, "query": {}, "params": {"filename": "BKP-2026-01-02T04-57-41.sql"}, "exception": {"error": "Conflict", "message": "Confirmation phrase is incorrect", "statusCode": 409}}	/api/admin/backup/restore/BKP-2026-01-02T04-57-41.sql	POST	::1
b3eb6664-6885-4a06-b833-ce297fe07fc0	2026-01-02 04:58:50.257+00	ERROR	BACKEND	GlobalExceptionFilter	c048e295-762b-4d27-9c9c-e652e47ca1bd	admin@obs.com	Confirmation phrase is incorrect	ConflictException: Confirmation phrase is incorrect\n    at BackupService.restoreBackup (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\admin\\backup\\backup.service.ts:79:19)\n    at BackupController.restoreBackup (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\admin\\backup\\backup.controller.ts:31:35)\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:38:29\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:46:28\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-proxy.js:9:17	{"body": {"confirmationPhrase": "restaurar base de datos"}, "query": {}, "params": {"filename": "BKP-2026-01-02T04-57-41.sql"}, "exception": {"error": "Conflict", "message": "Confirmation phrase is incorrect", "statusCode": 409}}	/api/admin/backup/restore/BKP-2026-01-02T04-57-41.sql	POST	::1
\.


--
-- Data for Name: especies; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.especies (id, codigo, nombre_cientifico, nombre_vulgar, activo, observaciones) FROM stdin;
7b69e017-32a1-46b6-882c-937ca8525f50	0000000001	Genypterus blacodes	Abadejo	t	\N
5e4f8e4f-17c9-44f3-8828-b7049cd227cd	0000000002	Engraulis anchoita	Anchoíta	t	\N
7266d214-b1ed-422a-8cf3-92641eebffd6	0000000003	Scomber japonicus	Caballa	t	\N
f407d27e-4fb5-4d8f-b24c-d170e6c3c35d	0000000004	Illex argentinus	Calamar	t	\N
606898cd-021e-4409-9791-869fa24f93b1	0000000005	Lithodes santolla	Centolla	t	\N
105f4d84-5baa-4ca5-b29e-ef2d93543d17	0000000006	-	Especies australes	t	\N
3a4a779f-7418-47b1-a348-08a4a7c6d1fe	0000000007	Pleoticus muelleri	Langostino	t	\N
124343f1-e660-4f2a-9a91-42207540e539	0000000008	Merluccius hubbsi	Merluza común	t	\N
d541bcba-8126-45c3-883f-96d255d08ab0	0000000009	Dissostichus eleginoides	Merluza negra	t	\N
fdba7736-6936-4557-8db8-952faaea28e5	0000000010	Zygochlamys patagonica	Vieira	t	\N
\.


--
-- Data for Name: estados_marea; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.estados_marea (id, codigo, nombre, descripcion, categoria, orden, es_inicial, es_final, permite_carga_archivos, permite_correccion, permite_informe, activo, mostrar_en_panel) FROM stdin;
4a3cf5f6-2ec8-4f78-b2eb-5c9b17db9806	DESIGNADA	Designada	\N	PENDIENTE	1	t	f	f	f	f	t	t
0110f7f6-ebaf-4012-b288-d4e3a34d7c58	EN_EJECUCION	En ejecución	\N	PENDIENTE	2	f	f	f	f	f	t	t
0affe6e4-4fca-4011-8606-6eb0643e9cdf	ESPERANDO_ENTREGA	Esperando entrega de datos	\N	PENDIENTE	3	f	f	f	f	f	t	t
5af97c65-4364-4085-a6e5-3807312aec25	ENTREGADA_RECIBIDA	Entregada / Recibida	\N	PENDIENTE	4	f	f	t	f	f	t	t
9c1c031c-56fd-4583-a104-4b0d37f4941b	VERIFICACION_INICIAL	Verificación inicial	\N	EN_CURSO	5	f	f	t	f	f	t	t
120e521e-7df3-4130-a9c8-eee8406b6aba	EN_CORRECCION	En corrección interna	\N	EN_CURSO	6	f	f	t	t	f	t	t
eaee25a3-07dc-4706-90e7-24f4eebb044c	DELEGADA_EXTERNA	Delegada / En espera externa	\N	EN_CURSO	7	f	f	t	f	f	t	f
f060d79c-f2d3-46b5-9018-6587ae0f0623	PENDIENTE_DE_INFORME	Pendiente de informe	\N	EN_CURSO	8	f	f	f	f	t	t	t
f96f365a-fc17-46eb-a9c8-78d50ecc26b8	ESPERANDO_REVISION	Esperando revisión de informe	\N	EN_CURSO	9	f	f	f	f	t	t	f
f819f491-2e55-477a-8be2-7603bf1a812c	PARA_PROTOCOLIZAR	Para protocolizar	\N	EN_CURSO	10	f	f	f	f	t	t	f
cc08b7fa-33f2-4205-9c71-8cb080b8c531	ESPERANDO_PROTOCOLIZACION	Esperando protocolización	\N	EN_CURSO	11	f	f	f	f	t	t	f
8cb0d0cc-d503-4208-a4da-0f37841c9e86	PROTOCOLIZADA	Protocolizada / Finalizada	\N	COMPLETADO	12	f	t	f	f	t	t	f
9e842bbc-3f8a-4bf7-a513-52b407158ec8	CANCELADA	Cancelada / Desestimada	\N	CANCELADO	13	f	t	f	f	f	t	f
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
04919a8e-1d89-49a8-a98c-c7e4c864c82c	2025	1	96bd0a31-93a4-447f-8be0-6bff3b5ecf41	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	2025-03-01 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:24.154+00	2026-01-02 04:19:24.154+00	t	Importada de JSONL. Empresa: ESTREMAR. Especie: MERLUZA AUSTRAL	MC	60
c3a1effd-b5dc-4dc6-82bd-bf565dbb9fa2	2025	2	e9603c58-cdf7-47dd-a343-2a3b5cf2fc8e	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	2025-03-01 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:24.215+00	2026-01-02 04:19:24.215+00	t	Importada de JSONL. Empresa: ARGENOVA. Especie: MERLUZA AUSTRAL	MC	60
6b27610e-53c5-4d23-a5c3-2d54da315aec	2025	3	c3786112-eea9-46fd-ad67-918e6e0f15e3	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	2025-03-01 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:24.226+00	2026-01-02 04:19:24.226+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: CENTOLLA	MC	30
874d961e-4f10-44d8-8a26-704dfe59baf8	2025	4	8b8211c8-11c3-45cf-89f1-e0a702e9e450	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	2025-12-01 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:24.236+00	2026-01-02 04:19:24.236+00	t	Importada de JSONL. Empresa: PEDRO MOSCUZZA E HIJO. Especie: MERLUZA	MC	30
07879508-cbb4-4b79-a7ac-df50a730ae89	2025	5	6cfb81b7-0d13-40ce-84fa-a616070bbb37	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	2025-08-01 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:24.246+00	2026-01-02 04:19:24.246+00	t	Importada de JSONL. Empresa: PESQUERA GEMINIS. Especie: MERLUZA	MC	30
f0651e46-2efb-4b53-aada-e5674bf3b42c	2025	6	0ec9005b-6b77-4893-8ea8-601e0890d630	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	2025-09-01 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:24.256+00	2026-01-02 04:19:24.256+00	t	Importada de JSONL. Empresa: PESQUERA CERES. Especie: CALAMAR	MC	30
e8ca1cdc-4a63-4c22-ad41-9f5735a63771	2025	7	15a63476-e520-4a78-a3be-1f59ba28426a	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	2025-07-01 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:24.267+00	2026-01-02 04:19:24.267+00	t	Importada de JSONL. Empresa: ARGENOVA. Especie: CALAMAR	MC	30
d0571ab3-52eb-46ee-8c7c-35c742e70e57	2025	8	508f31e8-ed6a-484f-9e08-420288064198	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	2025-09-01 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:24.277+00	2026-01-02 04:19:24.277+00	t	Importada de JSONL. Empresa: LUIS SOLIMENO. Especie: MERLUZA	MC	30
f404c632-fac3-4128-9cd5-114a21d0531d	2025	9	a07bd243-6580-4a69-afcb-ef60c1d6c789	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	2025-06-01 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:24.297+00	2026-01-02 04:19:24.297+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: VIEIRA	MC	30
acc394fb-c63f-4afe-8cfa-c766d39201bb	2025	10	5733a2fe-ec8a-4665-bc9a-a2e09b944857	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	2025-11-01 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:24.309+00	2026-01-02 04:19:24.309+00	t	Importada de JSONL. Empresa: GLACIAR PESQUERA. Especie: VIEIRA	MC	30
79891cde-4f19-4d5c-bf01-d1f5b7a48536	2025	11	0374aa6f-0d1b-49c2-8f73-9bc8818d48d1	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	2025-08-01 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:24.321+00	2026-01-02 04:19:24.321+00	t	Importada de JSONL. Empresa: FOOD ARTZ S.A.. Especie: CALAMAR	MC	30
19a2c92e-bc67-47be-942c-dac4ff8bd026	2025	12	50830bce-68a4-4ec9-a8df-9b44be25f87c	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	2025-09-01 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:24.333+00	2026-01-02 04:19:24.333+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: VIEIRA	MC	30
c4feca97-3387-47cc-b0e1-81970ddc9dc1	2025	13	b36b2ede-a2e3-47ce-a3ad-1fa26a3b0883	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	2025-09-01 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:24.344+00	2026-01-02 04:19:24.344+00	t	Importada de JSONL. Empresa: FOOD PARTNERS PATAGONIA. Especie: CENTOLLA	MC	30
fc29f36b-38b2-42e3-ada5-922e621fd69e	2025	14	1eb91ed7-699a-44d2-b684-792bdce19070	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	2025-09-01 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:24.353+00	2026-01-02 04:19:24.353+00	t	Importada de JSONL. Empresa: PEDRO MOSCUZZA E HIJO. Especie: CALAMAR	MC	30
fcb741cf-4c60-4996-b34a-ddb7d675c782	2025	15	a1d19025-1d1e-4a18-8c08-3aac431d1066	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	2025-11-01 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:24.37+00	2026-01-02 04:19:24.37+00	t	Importada de JSONL. Empresa: PESQUERA VERAZ. Especie: MERLUZA	MC	30
33798d54-773b-44d7-9824-2ee0a9ad68e5	2025	16	9c05f19b-cb5b-4597-8498-ced13f6dfa1c	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:24.391+00	2026-01-02 04:19:24.391+00	t	Importada de JSONL. Empresa: GLACIAR PESQUERA. Especie: VIEIRA	MC	30
6de667b9-de1b-45b0-92a1-6a810df139a4	2025	17	c39a8309-bb16-4f99-ad5f-6033c8c9476b	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:24.4+00	2026-01-02 04:19:24.4+00	t	Importada de JSONL. Empresa: ALTAMARE S.AS. Especie: CALAMAR	MC	30
93fdbfcc-2f30-47cb-811d-ea5b5fa2d1ab	2025	18	8d35f62b-d812-44b8-a136-baa4b6a8f5d5	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:24.408+00	2026-01-02 04:19:24.408+00	t	Importada de JSONL. Empresa: ALTAMARE S.AS. Especie: CALAMAR	MC	30
2a7c3bd8-bb58-40b6-b423-52c2b8a7c48f	2025	19	47279cdd-c76c-4f3d-a415-a7a608071774	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:24.417+00	2026-01-02 04:19:24.417+00	t	Importada de JSONL. Empresa: BENTONICOS DE ARGENTINA. Especie: CENTOLLA	MC	30
360e781e-8403-417d-a78c-ac278ca025e2	2025	20	0ec9005b-6b77-4893-8ea8-601e0890d630	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:24.425+00	2026-01-02 04:19:24.425+00	t	Importada de JSONL. Empresa: GIORNO. Especie: CALAMAR	MC	30
562aa66d-c729-4132-bb7d-27ad7e32e3d1	2025	21	8d3baa92-31d9-43d1-bd6c-bfde522ca762	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	2025-04-02 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:24.433+00	2026-01-02 04:19:24.433+00	t	Importada de JSONL. Empresa: CRUSTACEOS DEL SUR S.A. Especie: CENTOLLA	MC	30
aa6b4552-3765-4da4-99aa-54e9cdd87ef7	2025	22	028d04dc-9ebe-4e80-b423-fcaa6aefa3ce	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	2025-01-02 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:24.441+00	2026-01-02 04:19:24.441+00	t	Importada de JSONL. Empresa: ARGENOVA. Especie: CALAMAR	MC	30
346eb434-1937-4e63-800c-bee29cca4325	2025	23	f4efb7e4-4461-497c-a9e9-b60b52732660	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:24.449+00	2026-01-02 04:19:24.449+00	t	Importada de JSONL. Empresa: ARBUMASA S.A. Especie: CALAMAR	MC	30
4dd4f175-b2ec-4675-917f-1f33c34d275e	2025	24	e9603c58-cdf7-47dd-a343-2a3b5cf2fc8e	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:24.458+00	2026-01-02 04:19:24.458+00	t	Importada de JSONL. Empresa: ARGENOVA. Especie: MERLUZA AUSTRAL	MC	30
4d1f7c39-65a9-4eef-aa62-5c082d8c4522	2025	25	6c8c18f7-5a09-4d3c-87d1-d237f3d91347	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	2025-01-02 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:24.466+00	2026-01-02 04:19:24.466+00	t	Importada de JSONL. Empresa: BENTONICOS DE ARGENTINA. Especie: CENTOLLA	MC	30
03b80d20-6553-4257-82a2-58965ee924a9	2025	26	0db25c55-347d-41e4-bc64-bec1179455da	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	2025-02-02 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:24.474+00	2026-01-02 04:19:24.474+00	t	Importada de JSONL. Empresa: GIORNO. Especie: MERLUZA	MC	30
9a73cb1d-5a35-44ee-b4a6-b9b371b599d5	2025	27	0d63dd59-ac7e-49ae-b324-349fff46355d	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:24.482+00	2026-01-02 04:19:24.482+00	t	Importada de JSONL. Empresa: CHIARPESCA. Especie: CALAMAR	MC	30
a23ab54e-f24c-4b0c-bce7-8d5441ea2309	2025	28	c15ee044-9471-45a9-b364-592713e66ad9	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	2025-06-02 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:24.489+00	2026-01-02 04:19:24.489+00	t	Importada de JSONL. Empresa: PESANTAR. Especie: CALAMAR	MC	60
bc698db6-d2c9-472d-a461-25ca56770f94	2025	29	0bed525b-2356-41f5-b4b2-bc08f9970ce3	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	2025-03-02 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:24.497+00	2026-01-02 04:19:24.497+00	t	Importada de JSONL. Empresa: EL MARISCO. Especie: MERLUZA	MC	30
c7c980d8-5207-48a7-9d1c-d2f291f7368f	2025	30	96bd0a31-93a4-447f-8be0-6bff3b5ecf41	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	2025-12-02 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:24.504+00	2026-01-02 04:19:24.504+00	t	Importada de JSONL. Empresa: ESTREMAR. Especie: MERLUZA AUSTRAL	MC	30
b46e9497-edac-42dc-a8bf-db062b822264	2025	31	a07bd243-6580-4a69-afcb-ef60c1d6c789	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	2025-02-02 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:24.511+00	2026-01-02 04:19:24.511+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: VIEIRA	MC	30
a9ded57b-c564-42d6-ac89-5ab0dcde7a92	2025	32	8eb864be-6c72-482d-85ed-747bc6e2f376	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:24.518+00	2026-01-02 04:19:24.518+00	t	Importada de JSONL. Empresa: PRODESUR. Especie: MERLUZA AUSTRAL	MC	60
1a2d90b1-a6cb-4b58-bdad-ccd602c60fba	2025	33	a1d19025-1d1e-4a18-8c08-3aac431d1066	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:24.526+00	2026-01-02 04:19:24.526+00	t	Importada de JSONL. Empresa: PESQUERA VERAZ. Especie: MERLUZA	MC	30
9711d801-642d-400a-b9ee-6e7e0a543a06	2025	34	5733a2fe-ec8a-4665-bc9a-a2e09b944857	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:24.534+00	2026-01-02 04:19:24.534+00	t	Importada de JSONL. Empresa: GLACIAR PESQUERA. Especie: VIEIRA	MC	30
5f0abe34-ea90-43a2-9adc-b6fbd7ebbcea	2025	35	e9603c58-cdf7-47dd-a343-2a3b5cf2fc8e	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:24.542+00	2026-01-02 04:19:24.542+00	t	Importada de JSONL. Empresa: ARGENOVA. Especie: MERLUZA AUSTRAL	MC	30
60ed4b3f-84f8-432d-af24-d0fe1d8a6f5c	2025	36	50830bce-68a4-4ec9-a8df-9b44be25f87c	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:24.55+00	2026-01-02 04:19:24.55+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: VIEIRA	MC	30
b8188c44-bfce-4fc9-993e-86c6212f9e62	2025	37	f1a9f401-eb5c-429e-aeee-c4428a78e346	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:24.556+00	2026-01-02 04:19:24.556+00	t	Importada de JSONL. Empresa: CRUSTACEOS DEL SUR S.A. Especie: CENTOLLA	MC	30
d7477631-230c-43cc-9ad2-9a458540e95d	2025	38	c3786112-eea9-46fd-ad67-918e6e0f15e3	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	2025-05-03 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:24.564+00	2026-01-02 04:19:24.564+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: CENTOLLA	MC	30
9b3f94f3-819e-4ff3-9174-d77be597961f	2025	39	47279cdd-c76c-4f3d-a415-a7a608071774	\N	9e842bbc-3f8a-4bf7-a513-52b407158ec8	2025-06-03 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:24.576+00	2026-01-02 04:19:24.576+00	t	Importada de JSONL. Empresa: BENTONICOS DE ARGENTINA. Especie: CENTOLLA	MC	30
14943dfc-1f7d-4bc5-808c-51d6c4e1d2ab	2025	40	9c05f19b-cb5b-4597-8498-ced13f6dfa1c	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	2025-06-03 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:24.583+00	2026-01-02 04:19:24.583+00	t	Importada de JSONL. Empresa: GLACIAR PESQUERA. Especie: VIEIRA	MC	30
8c71e1d6-747e-4f67-b74f-5fa24fb8b1e1	2025	41	ef9f791c-b83d-496f-9d0f-2410e03f4657	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	2025-03-03 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:24.591+00	2026-01-02 04:19:24.591+00	t	Importada de JSONL. Empresa: FOOD ARTS S.A. Especie: CALAMAR	MC	30
3e3cf12e-d182-4e0f-ba3f-e39a3880cecc	2025	42	ab13c851-9fec-463a-93b8-da24b3bc67d3	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	2025-07-03 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:24.598+00	2026-01-02 04:19:24.598+00	t	Importada de JSONL. Empresa: TOZUDO. Especie: P.ABADEJO	MC	30
cfb18177-e9ea-4c31-9bb0-f50de16b33b4	2025	43	39f59880-1071-425c-818d-2120607006de	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	2025-07-03 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:24.607+00	2026-01-02 04:19:24.607+00	t	Importada de JSONL. Empresa: PESQUERA SIEMPRE GAUCHO. Especie: P.ABADEJO	MC	30
c72cddb5-13a0-4308-8592-90c485b9223a	2025	44	255f22d6-ce7d-44af-9a0a-db1f5cf92ff5	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	2025-07-03 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:24.617+00	2026-01-02 04:19:24.617+00	t	Importada de JSONL. Empresa: LOBA PESQUERA. Especie: P.ABADEJO	MC	30
8eadcafe-2174-429c-b3a7-cffec0d8e62a	2025	45	55c2763a-a929-49c1-9517-9aa290e204ad	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	2025-07-03 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:24.626+00	2026-01-02 04:19:24.626+00	t	Importada de JSONL. Empresa: ROMFIOC S.R.L. Especie: P.ABADEJO	MC	30
4e37279f-2272-4096-92e0-40b32bb3b655	2025	46	5f888a8d-5b14-4e4e-9446-40e3274994ea	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	2025-07-03 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:24.635+00	2026-01-02 04:19:24.635+00	t	Importada de JSONL. Empresa: MAREA OPTIMA. Especie: P.ABADEJO	MC	30
f59534d7-f262-4dd8-8f64-fa3d3091571e	2025	47	8d3baa92-31d9-43d1-bd6c-bfde522ca762	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	2025-12-03 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:24.644+00	2026-01-02 04:19:24.644+00	t	Importada de JSONL. Empresa: CRUSTACEOS DEL SUR S.A. Especie: CENTOLLA	MC	30
2f6ee5d6-2d49-4c5a-91ff-a006e893a74c	2025	48	53df37fa-4876-4db9-8044-82c60dca71e7	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	2025-12-03 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:24.65+00	2026-01-02 04:19:24.65+00	t	Importada de JSONL. Empresa: CENTOMAR S.A. Especie: CENTOLLA	MC	30
f20a8859-90c1-4396-ab58-e3190eeb2991	2025	49	c8520d57-6f26-4ad0-8220-dd5206243120	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:24.657+00	2026-01-02 04:19:24.657+00	t	Importada de JSONL. Empresa: ESTRELLA PATAGONICA. Especie: MERLUZA	MC	30
05d56476-ae1b-4c68-917c-a7bacb26fdde	2025	50	df2a0381-937d-46b8-bbf7-a199bce6d7d0	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:24.665+00	2026-01-02 04:19:24.665+00	t	Importada de JSONL. Empresa: MOSCUZZA. Especie: CALAMAR	MC	30
8a897cec-9409-440e-ab29-f7be994ca100	2025	51	a07bd243-6580-4a69-afcb-ef60c1d6c789	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:24.673+00	2026-01-02 04:19:24.673+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: VIEIRA	MC	30
6bc7c5a7-f9e0-4b66-87c7-afb6431a3361	2025	52	e9603c58-cdf7-47dd-a343-2a3b5cf2fc8e	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:24.68+00	2026-01-02 04:19:24.68+00	t	Importada de JSONL. Empresa: ARGENOVA. Especie: MERLUZA AUSTRAL	MC	30
b41abed5-fc68-4678-bfba-f38defa54ff6	2025	53	1eb91ed7-699a-44d2-b684-792bdce19070	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:24.688+00	2026-01-02 04:19:24.688+00	t	Importada de JSONL. Empresa: PEDRO MOSCUZZA E HIJO. Especie: CALAMAR	MC	30
349de9dd-0da8-421f-a240-e329d057d367	2025	54	50830bce-68a4-4ec9-a8df-9b44be25f87c	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	2025-09-04 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:24.695+00	2026-01-02 04:19:24.695+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: VIEIRA	MC	30
0efc2eee-dfc0-4093-b2b4-d231e2e4d555	2025	55	8eb864be-6c72-482d-85ed-747bc6e2f376	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:24.702+00	2026-01-02 04:19:24.702+00	t	Importada de JSONL. Empresa: PRODESUR. Especie: MERLUZA AUSTRAL	MC	60
19506384-a971-4c7f-812a-333c4c523d50	2025	56	c15ee044-9471-45a9-b364-592713e66ad9	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	2025-10-04 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:24.708+00	2026-01-02 04:19:24.708+00	t	Importada de JSONL. Empresa: PESANTAR. Especie: MERLUZA AUSTRAL	MC	60
cb5e0b51-9a46-4c91-94ae-cb019458fcd9	2025	57	47279cdd-c76c-4f3d-a415-a7a608071774	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	2025-09-04 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:24.715+00	2026-01-02 04:19:24.715+00	t	Importada de JSONL. Empresa: BENTONICOS DE ARGENTINA. Especie: CENTOLLA	MC	30
4d4a0a97-9c4c-452b-9234-922947c4255e	2025	58	d1fa7ae4-d610-42da-8de0-76abce7b7e6c	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:24.723+00	2026-01-02 04:19:24.723+00	t	Importada de JSONL. Empresa: VIERA ARGENTINA. Especie: CALAMAR	MC	30
35dda77d-99d2-41e9-8118-3f6e3dc9ba2d	2025	59	5733a2fe-ec8a-4665-bc9a-a2e09b944857	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	2025-10-04 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:24.729+00	2026-01-02 04:19:24.729+00	t	Importada de JSONL. Empresa: GLACIAR PESQUERA. Especie: VIEIRA	MC	30
cb556c38-7986-4a55-ba9d-208e6e60b75d	2025	60	c3786112-eea9-46fd-ad67-918e6e0f15e3	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	2025-10-04 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:24.736+00	2026-01-02 04:19:24.736+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: CENTOLLA	MC	30
4f243ff3-95be-4da8-af26-83c044b89ffc	2025	61	9c05f19b-cb5b-4597-8498-ced13f6dfa1c	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:24.743+00	2026-01-02 04:19:24.743+00	t	Importada de JSONL. Empresa: GLACIAR PESQUERA. Especie: VIEIRA	MC	30
6bcd1042-c72b-4a90-a3d2-f60957e833a0	2025	62	efa71c95-6258-4adc-ae09-8b23b8e2bde9	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:24.751+00	2026-01-02 04:19:24.751+00	t	Importada de JSONL. Empresa: ALTAMARE S.AS. Especie: CALAMAR	MC	30
bf5b9c59-103c-4165-9443-b16ab79763ba	2025	63	84781555-5afd-41ba-9144-1ed3dda597a1	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	2025-11-04 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:24.758+00	2026-01-02 04:19:24.758+00	t	Importada de JSONL. Empresa: PESCARGEN. Especie: LANGOSTINO	MC	30
1d9c2349-cd16-4dc3-a3b3-03c9cfc52939	2025	64	0db25c55-347d-41e4-bc64-bec1179455da	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:24.769+00	2026-01-02 04:19:24.769+00	t	Importada de JSONL. Empresa: GIORNO. Especie: MERLUZA	MC	30
de6be5aa-e1f3-4e48-be2d-ad6ab4329899	2025	65	2e95d154-8dcc-4f37-8a74-317fcc17f52e	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:24.776+00	2026-01-02 04:19:24.776+00	t	Importada de JSONL. Empresa: LUIS SOLIMENO. Especie: MERLUZA	MC	30
8f7129bd-295f-4671-b1c8-2ca93d2b881e	2025	66	5f255305-bbf3-48e7-a285-3b17e7b2a3c3	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:24.785+00	2026-01-02 04:19:24.785+00	t	Importada de JSONL. Empresa: MARÍTIMA COMERCIAL. Especie: MERLUZA	MC	30
06c23584-5894-441a-a353-4477b9922edc	2025	67	b8a97139-5298-48e8-93e0-0f3f9a12b207	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:24.793+00	2026-01-02 04:19:24.793+00	t	Importada de JSONL. Empresa: NIETOS ANTONIO BALDINO. Especie: MERLUZA	MC	30
4f77e130-30f0-4325-9568-454e639c323c	2025	68	2f2c6e1f-3969-4575-aa14-cde78663cec6	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:24.8+00	2026-01-02 04:19:24.8+00	t	Importada de JSONL. Empresa: MOSCUZZA. Especie: MERLUZA	MC	30
49d2cd67-e474-4452-9b24-19ac5f78c47a	2025	69	df2a0381-937d-46b8-bbf7-a199bce6d7d0	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:24.811+00	2026-01-02 04:19:24.811+00	t	Importada de JSONL. Empresa: MOSCUZZA. Especie: CALAMAR	MC	30
5884959a-814b-476d-9115-33b8933e7a60	2025	70	92dc3cde-d61c-450a-92a6-8d29cc0e9cdd	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:24.817+00	2026-01-02 04:19:24.817+00	t	Importada de JSONL. Empresa: MARONTI  S.A.. Especie: MERLUZA	MC	30
b2934e06-51b0-4316-b962-e4c7053df833	2025	71	0d63dd59-ac7e-49ae-b324-349fff46355d	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:24.828+00	2026-01-02 04:19:24.828+00	t	Importada de JSONL. Empresa: GRUPO CHIAR PESCA. Especie: CALAMAR	MC	30
0409eab0-c608-40e5-ae39-86bc117311b0	2025	72	e9603c58-cdf7-47dd-a343-2a3b5cf2fc8e	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:24.836+00	2026-01-02 04:19:24.836+00	t	Importada de JSONL. Empresa: ARGENOVA. Especie: MERLUZA AUSTRAL	MC	30
d5464931-b47d-46f0-aa9b-4e80b3dd2dde	2025	73	a3561d1d-6da1-4e4b-bebf-ff55987e1477	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:24.846+00	2026-01-02 04:19:24.846+00	t	Importada de JSONL. Empresa: BUENA PROA. Especie: MERLUZA	MC	30
1cfa1f0f-f9b2-42ee-8d42-5bac2892191f	2025	74	956a4382-a67a-45ed-a8a4-cc67cfa8bc12	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:24.864+00	2026-01-02 04:19:24.864+00	t	Importada de JSONL. Empresa: GIORNO. Especie: MERLUZA	MC	30
cee1a4b3-5735-4c40-9c55-50adc608d891	2025	75	96bd0a31-93a4-447f-8be0-6bff3b5ecf41	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	2025-07-05 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:24.876+00	2026-01-02 04:19:24.876+00	t	Importada de JSONL. Empresa: ESTREMAR. Especie: MERLUZA AUSTRAL	MC	30
44f73667-e99a-4d86-a7c9-340b3529bdc9	2025	76	a07bd243-6580-4a69-afcb-ef60c1d6c789	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	2025-07-05 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:24.887+00	2026-01-02 04:19:24.887+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: VIEIRA	MC	30
7734461b-f8e3-49c1-ba99-37f094756bbc	2025	77	6cfb81b7-0d13-40ce-84fa-a616070bbb37	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	2025-04-05 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:24.902+00	2026-01-02 04:19:24.902+00	t	Importada de JSONL. Empresa: GIORNO. Especie: MERLUZA	MC	30
fbffea19-f8bf-487e-a809-4bb307a6806d	2025	78	0374aa6f-0d1b-49c2-8f73-9bc8818d48d1	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	2025-06-05 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:24.916+00	2026-01-02 04:19:24.916+00	t	Importada de JSONL. Empresa: FOOD ARTS S.A. Especie: CALAMAR	MC	30
81390c34-45d6-4c2b-a48c-a065065bb3df	2025	79	1eb91ed7-699a-44d2-b684-792bdce19070	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	2025-06-05 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:24.931+00	2026-01-02 04:19:24.931+00	t	Importada de JSONL. Empresa: MOSCUZZA. Especie: CALAMAR	MC	30
dc473bf3-beba-47e1-a1d5-237083bd1428	2025	80	84781555-5afd-41ba-9144-1ed3dda597a1	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	2025-10-05 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:24.943+00	2026-01-02 04:19:24.943+00	t	Importada de JSONL. Empresa: PESCAREN S.A. Especie: LANGOSTINO	MC	30
c11a111c-c96c-424a-afd3-529c724eee5e	2025	81	c3786112-eea9-46fd-ad67-918e6e0f15e3	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:24.954+00	2026-01-02 04:19:24.954+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: CENTOLLA	MC	30
5894c1f3-0fc4-4eb8-a491-1869a60d2dea	2025	82	c15ee044-9471-45a9-b364-592713e66ad9	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:24.966+00	2026-01-02 04:19:24.966+00	t	Importada de JSONL. Empresa: PESANTAR. Especie: MERLUZA AUSTRAL	MC	60
83628072-328b-47e0-8ba2-f056d4f2ed16	2025	83	8b8211c8-11c3-45cf-89f1-e0a702e9e450	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:24.979+00	2026-01-02 04:19:24.979+00	t	Importada de JSONL. Empresa: MOSCUZZA. Especie: MERLUZA	MC	30
25aee2f6-a2a3-4287-b842-a185b82a8541	2025	84	d192cbe9-b88a-4a77-a7c3-291a553990c8	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:24.989+00	2026-01-02 04:19:24.989+00	t	Importada de JSONL. Empresa: LUIS SOLIMENO. Especie: MERLUZA	MC	30
2587e56b-160d-40ce-b21d-2ba90e84d241	2025	85	956a4382-a67a-45ed-a8a4-cc67cfa8bc12	\N	9e842bbc-3f8a-4bf7-a513-52b407158ec8	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.001+00	2026-01-02 04:19:25.001+00	t	Importada de JSONL. Empresa: GIORNO. Especie: MERLUZA	MC	30
1f3e8257-874b-4932-8792-9c454fa422a3	2025	86	921868fd-ad81-4d46-b3a5-8d59564fb909	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.008+00	2026-01-02 04:19:25.008+00	t	Importada de JSONL. Empresa: LUIS SOLIMENO. Especie: CALAMAR	MC	30
83dd63f4-c066-458b-a6da-9edc38a9fe26	2025	87	8eb864be-6c72-482d-85ed-747bc6e2f376	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.018+00	2026-01-02 04:19:25.018+00	t	Importada de JSONL. Empresa: PRODESUR. Especie: MERLUZA AUSTRAL	MC	60
72e6712e-ddab-42e8-ae4d-be6ecfb5ee72	2025	88	50830bce-68a4-4ec9-a8df-9b44be25f87c	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.028+00	2026-01-02 04:19:25.028+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: VIEIRA	MC	30
3bbc5d6b-70f5-4218-bc38-de20f1cf4b73	2025	89	9c05f19b-cb5b-4597-8498-ced13f6dfa1c	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.036+00	2026-01-02 04:19:25.036+00	t	Importada de JSONL. Empresa: GLACIAR PESQUERA. Especie: VIEIRA	MC	30
49e5655b-f23e-4c54-ad63-9cfe43c4fa1a	2025	90	84781555-5afd-41ba-9144-1ed3dda597a1	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.046+00	2026-01-02 04:19:25.046+00	t	Importada de JSONL. Empresa: PESCARGEN. Especie: LANGOSTINO	MC	30
015d8a13-b003-4ddd-aa8b-ceb86c9ef01f	2025	91	df2a0381-937d-46b8-bbf7-a199bce6d7d0	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.059+00	2026-01-02 04:19:25.059+00	t	Importada de JSONL. Empresa: MOSCUZZA. Especie: CALAMAR	MC	30
d04acea6-bb81-4df7-987b-2a7fea86daeb	2025	92	f419f2c3-9879-4d6d-bb45-30c45e655caa	\N	9e842bbc-3f8a-4bf7-a513-52b407158ec8	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.068+00	2026-01-02 04:19:25.068+00	t	Importada de JSONL. Empresa: CONARPESA. Especie: LANGOSTINO	MC	30
22f4427e-459a-49d0-8920-f69da80e74a2	2025	93	5733a2fe-ec8a-4665-bc9a-a2e09b944857	\N	9e842bbc-3f8a-4bf7-a513-52b407158ec8	2025-11-06 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.073+00	2026-01-02 04:19:25.073+00	t	Importada de JSONL. Empresa: GLACIAR PESQUERA. Especie: VIERA	MC	30
3c3b3d46-5b45-4bcb-9e54-9d7030cb9ab6	2025	94	1fc9c088-da05-4d5c-b833-e3a9be7bc1e3	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	2025-09-06 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.08+00	2026-01-02 04:19:25.08+00	t	Importada de JSONL. Empresa: ARPES. Especie: MERLUZA	MC	30
69829eb3-6e89-4777-96c1-27ca6ceb3102	2025	95	6cfb81b7-0d13-40ce-84fa-a616070bbb37	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	2025-06-06 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.097+00	2026-01-02 04:19:25.097+00	t	Importada de JSONL. Empresa: GIORNO. Especie: MERLUZA	MC	30
948e77d9-9fc1-4856-8d1f-b6ddd2a05a87	2025	96	0db25c55-347d-41e4-bc64-bec1179455da	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	2025-06-06 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.105+00	2026-01-02 04:19:25.105+00	t	Importada de JSONL. Empresa: GIORNO. Especie: MERLUZA	MC	30
bd233eae-2e8c-4e90-b7b2-013dff740a5b	2025	97	55c2763a-a929-49c1-9517-9aa290e204ad	\N	9e842bbc-3f8a-4bf7-a513-52b407158ec8	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.116+00	2026-01-02 04:19:25.116+00	t	Importada de JSONL. Empresa: ROMFIOC S.R.L. Especie: MERLUZA	MC	30
3876b93f-8552-4cc8-8e71-c15d64a4f323	2025	98	96bd0a31-93a4-447f-8be0-6bff3b5ecf41	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.122+00	2026-01-02 04:19:25.122+00	t	Importada de JSONL. Empresa: ESTREMAR. Especie: MERLUZA AUSTRAL	MC	30
266a7a5b-f577-4564-8b75-310122576126	2025	99	a3561d1d-6da1-4e4b-bebf-ff55987e1477	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	2025-12-06 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.132+00	2026-01-02 04:19:25.132+00	t	Importada de JSONL. Empresa: BUENA PROA. Especie: MERLUZA	MC	30
9d0dc0d9-7db9-4bf7-8fda-1285aabc6b87	2025	100	a07bd243-6580-4a69-afcb-ef60c1d6c789	\N	9e842bbc-3f8a-4bf7-a513-52b407158ec8	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.154+00	2026-01-02 04:19:25.154+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: VIERA	MC	30
2162635d-b565-4fcb-b404-61d5de99d95d	2025	101	90517596-f31b-4c36-830b-106eac58fe1e	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.161+00	2026-01-02 04:19:25.161+00	t	Importada de JSONL. Empresa: BUENA PROA. Especie: P. LANGOSTINO	MC	30
0919bfa7-0558-4b7d-8122-f2caafb08588	2025	102	84781555-5afd-41ba-9144-1ed3dda597a1	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.172+00	2026-01-02 04:19:25.172+00	t	Importada de JSONL. Empresa: PESCARGEN. Especie: P. LANGOSTINO	MC	30
d84fd437-5160-492a-b8a8-103b5caae44b	2025	103	95761f1f-5eda-4c2f-a881-f0ae573ced1e	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.182+00	2026-01-02 04:19:25.182+00	t	Importada de JSONL. Empresa: FRIGORÍFICO DON LUIS. Especie: P. LANGOSTINO	MC	30
00d11d10-4274-470a-b9f5-6315c05d93e8	2025	104	115ea9d8-6731-4689-ba00-e50990aa99fc	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.19+00	2026-01-02 04:19:25.19+00	t	Importada de JSONL. Empresa: URLIPEZ. Especie: P. LANGOSTINO	MC	30
8808f7c4-a7b2-475c-b85b-b68f7efb61b3	2025	105	630ea927-689e-4778-a417-fddfe83a8002	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.2+00	2026-01-02 04:19:25.2+00	t	Importada de JSONL. Empresa: DE ANGELIS Y LOGGHE. Especie: P. LANGOSTINO	MC	30
3e8c5a71-a3ab-4c15-a46d-afdd3c3e7d3c	2025	106	d5904aeb-6a6a-4659-923f-e7b78667f0f6	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.207+00	2026-01-02 04:19:25.207+00	t	Importada de JSONL. Empresa: PESCA ANTIGUA. Especie: P. LANGOSTINO	MC	30
6e85361f-4afc-49c7-b8e5-3d74bf205cea	2025	107	4b13fc14-16bb-4612-af34-ac4b9e101be3	\N	9e842bbc-3f8a-4bf7-a513-52b407158ec8	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.22+00	2026-01-02 04:19:25.22+00	t	Importada de JSONL. Empresa: IBERCONSA. Especie: MERLUZA	MC	30
038c26ab-f15d-47c8-b407-bb6826b94d95	2025	108	2e95d154-8dcc-4f37-8a74-317fcc17f52e	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.226+00	2026-01-02 04:19:25.226+00	t	Importada de JSONL. Empresa: SOLIMENO E HIJOS. Especie: MERLUZA	MC	30
b08c6e26-6286-4705-9a28-f14390445a3c	2025	109	5733a2fe-ec8a-4665-bc9a-a2e09b944857	\N	9e842bbc-3f8a-4bf7-a513-52b407158ec8	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.244+00	2026-01-02 04:19:25.244+00	t	Importada de JSONL. Empresa: GLACIAR PESQUERA. Especie: VIERA	MC	30
a188071c-1585-4114-870b-1d736d93c06c	2025	110	95761f1f-5eda-4c2f-a881-f0ae573ced1e	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.251+00	2026-01-02 04:19:25.251+00	t	Importada de JSONL. Empresa: FRIGORÍFICO DON LUIS. Especie: P. LANGOSTINO	MC	30
1b59329b-f1fa-4d25-bf45-0eda5c5231bb	2025	111	630ea927-689e-4778-a417-fddfe83a8002	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.261+00	2026-01-02 04:19:25.261+00	t	Importada de JSONL. Empresa: DE ANGELIS Y LOGGHE. Especie: P. LANGOSTINO	MC	30
1b5f5dd1-4d44-4a96-b9c8-be6d997701cb	2025	112	f91cacb1-1db8-4442-ac4e-46da3675440b	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.272+00	2026-01-02 04:19:25.272+00	t	Importada de JSONL. Empresa: CANAL DE BEAGLE. Especie: P. LANGOSTINO	MC	30
d1328495-407b-4571-9af1-9196a99fd36f	2025	113	a1d19025-1d1e-4a18-8c08-3aac431d1066	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	2025-01-07 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.281+00	2026-01-02 04:19:25.281+00	t	Importada de JSONL. Empresa: PESQUERA VERAZ. Especie: MERLUZA	MC	30
0d729d64-4ca8-45da-91dc-db6dcf50f256	2025	114	5733a2fe-ec8a-4665-bc9a-a2e09b944857	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	2025-10-07 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.296+00	2026-01-02 04:19:25.296+00	t	Importada de JSONL. Empresa: GLACIAR PESQUERA. Especie: VIERA	MC	30
b27ec34e-69b4-41fd-8567-a790079d4237	2025	115	a07bd243-6580-4a69-afcb-ef60c1d6c789	\N	9e842bbc-3f8a-4bf7-a513-52b407158ec8	2025-08-07 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.305+00	2026-01-02 04:19:25.305+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: VIERA	MC	30
680df353-e954-4fb7-8456-34b4079b4c0b	2025	116	9c05f19b-cb5b-4597-8498-ced13f6dfa1c	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.31+00	2026-01-02 04:19:25.31+00	t	Importada de JSONL. Empresa: GLACIAR PESQUERA. Especie: VIERA	MC	30
44db0a64-7cda-45d9-a591-d6cbb4043178	2025	117	84781555-5afd-41ba-9144-1ed3dda597a1	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	2025-11-07 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.32+00	2026-01-02 04:19:25.32+00	t	Importada de JSONL. Empresa: PESCARGEN. Especie: LANGOSTINO	MC	30
2945cc7f-2aca-4f7c-b266-eb7122fb1444	2025	118	3efbb230-c38f-4f74-836e-e053a4c30602	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	2025-11-07 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.329+00	2026-01-02 04:19:25.329+00	t	Importada de JSONL. Empresa: BUENA PROA. Especie: LANGOSTINO	MC	30
1cf8819c-e930-40e2-9342-2e0c2c48405c	2025	119	f8fb838e-1c8d-437e-aa7e-8ef0a5e2080a	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	2025-12-07 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.338+00	2026-01-02 04:19:25.338+00	t	Importada de JSONL. Empresa: IBERCONSA. Especie: MERLUZA	MC	30
80be0449-30ed-4e47-b8fa-ad0848454784	2025	120	443a11d0-4123-4c54-a2b9-d1b62ec5a305	\N	9e842bbc-3f8a-4bf7-a513-52b407158ec8	2025-11-07 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.347+00	2026-01-02 04:19:25.347+00	t	Importada de JSONL. Empresa: RITONDO SALLUSTIO Y CICCIOTTI. Especie: LANGOSTINO	MC	30
fd608d4a-9691-480c-a66b-7fe2d502004d	2025	121	152c8ba6-4793-4e02-a4f1-4e422d74d54a	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.354+00	2026-01-02 04:19:25.354+00	t	Importada de JSONL. Empresa: MOSCUZZA. Especie: LANGOSTINO	MC	30
de491046-dccf-453f-bbc0-c89860e7764a	2025	122	50830bce-68a4-4ec9-a8df-9b44be25f87c	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.372+00	2026-01-02 04:19:25.372+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: VIEIRA	MC	30
36ba1f84-2c6a-4b31-aadf-c47a9904f06c	2025	123	0db25c55-347d-41e4-bc64-bec1179455da	\N	9e842bbc-3f8a-4bf7-a513-52b407158ec8	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.381+00	2026-01-02 04:19:25.381+00	t	Importada de JSONL. Empresa: GIORNO S.A. Especie: MERLUZA	MC	30
5e442efa-4476-47ab-a7a2-1f81504113a7	2025	124	6cfb81b7-0d13-40ce-84fa-a616070bbb37	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.386+00	2026-01-02 04:19:25.386+00	t	Importada de JSONL. Empresa: GIORNO S.A. Especie: MERLUZA	MC	30
c16688d8-83d6-42c3-ae8f-b75bfa2a28a6	2025	125	f419f2c3-9879-4d6d-bb45-30c45e655caa	\N	4a3cf5f6-2ec8-4f78-b2eb-5c9b17db9806	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.394+00	2026-01-02 04:19:25.394+00	t	Importada de JSONL. Empresa: CONARPESA. Especie: LANGOSTINO	MC	30
2f9745f0-eaef-44bd-aef5-72ea10ce8be7	2025	126	a3561d1d-6da1-4e4b-bebf-ff55987e1477	\N	9e842bbc-3f8a-4bf7-a513-52b407158ec8	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.402+00	2026-01-02 04:19:25.402+00	t	Importada de JSONL. Empresa: BUENA PROA. Especie: LANGOSTINO	MC	30
8496aae7-2b41-439f-9ed5-186c6e114119	2025	127	df0b9291-259d-4a4b-9b33-24699dfaacec	\N	4a3cf5f6-2ec8-4f78-b2eb-5c9b17db9806	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.408+00	2026-01-02 04:19:25.408+00	t	Importada de JSONL. Empresa: CONARPESA. Especie: LANGOSTINO	MC	30
1bd372d2-f873-495b-b66a-941067841d1f	2025	128	a1a4671b-7bd8-4d11-bdc7-b5fdaee913f7	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.416+00	2026-01-02 04:19:25.416+00	t	Importada de JSONL. Empresa: PEDRO MOSCUZZA E HIJO. Especie: MERLUZA	MC	30
bb456c1a-e2fe-4e03-ae57-3adfb8681203	2025	129	2f2c6e1f-3969-4575-aa14-cde78663cec6	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.424+00	2026-01-02 04:19:25.424+00	t	Importada de JSONL. Empresa: PEDRO MOSCUZZA E HIJO. Especie: LANGOSTINO	MC	30
7fb67a35-4676-46f3-b698-954d9bea9cee	2025	130	4b13fc14-16bb-4612-af34-ac4b9e101be3	\N	9e842bbc-3f8a-4bf7-a513-52b407158ec8	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.431+00	2026-01-02 04:19:25.431+00	t	Importada de JSONL. Empresa: IBERCONSA. Especie: LANGOSTINO	MC	30
8281216e-fdfe-4368-af6d-b48fa9609ada	2025	131	118d9fa3-ef91-4da8-85d9-4831cc3d9896	\N	9e842bbc-3f8a-4bf7-a513-52b407158ec8	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.438+00	2026-01-02 04:19:25.438+00	t	Importada de JSONL. Empresa: EMPESUR. Especie: LANGOSTINO	MC	30
d368c857-e5ea-4cc6-933b-64ba617c4ac0	2025	132	313017cd-7e96-4d97-8a53-66bd3ba0a5e4	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.444+00	2026-01-02 04:19:25.444+00	t	Importada de JSONL. Empresa: BUENOS AIRES PESCA S.A. Especie: LANGOSTINO	MC	30
e5d71da1-4001-4ba6-b121-936a651da2f9	2025	133	e80ea858-cb36-4e41-9b6d-8a993c36e724	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.452+00	2026-01-02 04:19:25.452+00	t	Importada de JSONL. Empresa: BUENOS AIRES PESCA S.A. Especie: LANGOSTINO	MC	30
61fe27ee-4898-40f8-98a4-d32e4a2a8536	2025	134	a3561d1d-6da1-4e4b-bebf-ff55987e1477	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.46+00	2026-01-02 04:19:25.46+00	t	Importada de JSONL. Empresa: BUENA PROA. Especie: LANGOSTINO	MC	30
b7426674-3f2c-4a4c-9a4f-e7146d60e410	2025	135	1fc9c088-da05-4d5c-b833-e3a9be7bc1e3	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.469+00	2026-01-02 04:19:25.469+00	t	Importada de JSONL. Empresa: ARPES. Especie: MERLUZA	MC	30
481e3865-eace-4520-a915-f584e9355de8	2025	136	f1a9f401-eb5c-429e-aeee-c4428a78e346	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.484+00	2026-01-02 04:19:25.484+00	t	Importada de JSONL. Empresa: CRUSTACEOS DEL SUR S.A. Especie: CENTOLLA	MC	60
1198157e-c560-48f8-91b5-88c39657263d	2025	137	f69ff5f2-4aa6-4613-95f5-04704da57202	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.493+00	2026-01-02 04:19:25.493+00	t	Importada de JSONL. Empresa: CENTOMAR S.A. Especie: LANGOSTINO	MC	30
85982da0-6c28-4603-9a5e-a74e37cca9a7	2025	138	3dca0422-bea8-4ce8-96d4-07a9e967175f	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	2025-04-08 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.503+00	2026-01-02 04:19:25.503+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: LANGOSTINO	MC	30
3d5d53e3-d77c-40de-9508-ca70065f8325	2025	139	3efbb230-c38f-4f74-836e-e053a4c30602	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	2025-02-08 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.514+00	2026-01-02 04:19:25.514+00	t	Importada de JSONL. Empresa: BUENA PROA. Especie: LANGOSTINO	MC	30
cd084c95-8409-4338-b00e-99ed8ba0c350	2025	140	4001ee8d-40e9-475f-993a-12f85112d0c2	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	2025-05-08 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.523+00	2026-01-02 04:19:25.523+00	t	Importada de JSONL. Empresa: ARBUMASA S.A. Especie: LANGOSTINO	MC	30
5d3763ef-61c7-4470-87b8-be5021a584b7	2025	141	a426456e-015c-44bb-8680-8e66ad23685c	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	2025-05-08 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.532+00	2026-01-02 04:19:25.532+00	t	Importada de JSONL. Empresa: ARBUMASA S.A. Especie: LANGOSTINO	MC	30
d79f80b8-d3b9-42f5-a574-c840d12cea8c	2025	142	508f31e8-ed6a-484f-9e08-420288064198	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	2025-06-08 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.543+00	2026-01-02 04:19:25.543+00	t	Importada de JSONL. Empresa: SOLIMENO E HIJOS. Especie: MERLUZA	MC	30
95bc983e-3238-4a9b-9e19-dc53b73b7f7a	2025	143	d78eb359-66fa-4867-819d-4599b8aa06b5	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	2025-07-08 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.56+00	2026-01-02 04:19:25.56+00	t	Importada de JSONL. Empresa: PEDRO MOSCUZZA E HIJO. Especie: LANGOSTINO	MC	30
5735520b-7d2d-4e43-b7b2-acdfe1c69e11	2025	144	58588658-bf41-4bb4-9ff4-ceec9eb689fa	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	2025-07-08 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.571+00	2026-01-02 04:19:25.571+00	t	Importada de JSONL. Empresa: PEDRO MOSCUZZA E HIJO. Especie: LANGOSTINO	MC	30
ba84396b-5e22-4bcb-929c-387b034b8a06	2025	145	947d5aaf-de3e-4a75-9839-e36db2a74995	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	2025-12-08 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.581+00	2026-01-02 04:19:25.581+00	t	Importada de JSONL. Empresa: ANTONIO BALDINO E HIJOS. Especie: MERLUZA	MC	30
d43dbd70-39e1-430c-987b-5dcf959e86f5	2025	146	92dc3cde-d61c-450a-92a6-8d29cc0e9cdd	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.596+00	2026-01-02 04:19:25.596+00	t	Importada de JSONL. Empresa: MARONTI  S.A.. Especie: MERLUZA	MC	30
9995bba3-cbe4-44cd-b6d5-e22223274d62	2025	147	6cfb81b7-0d13-40ce-84fa-a616070bbb37	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.609+00	2026-01-02 04:19:25.609+00	t	Importada de JSONL. Empresa: GIORNO S.A. Especie: MERLUZA	MC	30
57385038-9502-41b5-86dd-7ac2eae7a5d1	2025	148	65f8f9f2-eeea-4ada-879a-4b383858fbdd	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.618+00	2026-01-02 04:19:25.618+00	t	Importada de JSONL. Empresa: XEITOSIÑO. Especie: LANGOSTINO	MC	30
b62ecaa0-fd79-48c8-8569-570fa30e818f	2025	149	86cb6687-b67d-4ea6-9eda-41d661113304	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.625+00	2026-01-02 04:19:25.625+00	t	Importada de JSONL. Empresa: XEITOSIÑO. Especie: LANGOSTINO	MC	30
a6f84194-71dc-466c-b59c-eab1cbce865d	2025	150	9ce93a19-ae53-4efd-9413-4e5c4a5571da	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.634+00	2026-01-02 04:19:25.634+00	t	Importada de JSONL. Empresa: CONARPESA. Especie: LANGOSTINO	MC	30
e88de7bb-0465-4ac8-90d7-bc391de87668	2025	151	956a4382-a67a-45ed-a8a4-cc67cfa8bc12	\N	4a3cf5f6-2ec8-4f78-b2eb-5c9b17db9806	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.642+00	2026-01-02 04:19:25.642+00	t	Importada de JSONL. Empresa: GIORNO. Especie: LANGOSTINO	MC	30
62cc7d5e-a399-40e8-8833-ba833a2d20e4	2025	152	48a9c10b-41c8-4986-8f54-b844583b2439	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.65+00	2026-01-02 04:19:25.65+00	t	Importada de JSONL. Empresa: PESQUERA VERAZ SA. Especie: LANGOSTINO	MC	30
2425ece4-d097-489e-bbaa-a8a823f55a21	2025	153	a1a4671b-7bd8-4d11-bdc7-b5fdaee913f7	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.663+00	2026-01-02 04:19:25.663+00	t	Importada de JSONL. Empresa: PEDRO MOSCUZZA E HIJO. Especie: MERLUZA	MC	30
85c313a1-678c-4a4d-bf67-abe2e1de5228	2025	154	28968574-9915-41c4-ae46-a0f647d634c2	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	2025-05-09 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.673+00	2026-01-02 04:19:25.673+00	t	Importada de JSONL. Empresa: ARGENOVA S.A. Especie: LANGOSTINO	MC	30
b91c643f-517a-4829-9c38-a2a29b3bca53	2025	155	50830bce-68a4-4ec9-a8df-9b44be25f87c	\N	4a3cf5f6-2ec8-4f78-b2eb-5c9b17db9806	2025-08-09 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.682+00	2026-01-02 04:19:25.682+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: VIEIRA	MC	30
1c553365-664b-4fcd-9300-a310c35fc7ad	2025	156	f1a9f401-eb5c-429e-aeee-c4428a78e346	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	2025-11-09 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.69+00	2026-01-02 04:19:25.69+00	t	Importada de JSONL. Empresa: CRUSTACEOS DEL SUR S.A. Especie: CENTOLLA	MC	30
ef4ae89d-c2dc-459c-86a9-cdff84f35abe	2025	157	45c53662-7c57-4411-895b-7b35236800fc	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	2025-10-09 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.7+00	2026-01-02 04:19:25.7+00	t	Importada de JSONL. Empresa: PESCASOL S.A. Especie: MERLUZA	MC	30
dfaa58d2-5af4-4f37-b45c-a32b1dfaa7a3	2025	158	a426456e-015c-44bb-8680-8e66ad23685c	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.707+00	2026-01-02 04:19:25.707+00	t	Importada de JSONL. Empresa: ARBUMASA S.A. Especie: LANGOSTINO	MC	30
463b364f-33e2-4d87-83ee-b81450c72c57	2025	159	c3786112-eea9-46fd-ad67-918e6e0f15e3	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	2025-11-09 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.717+00	2026-01-02 04:19:25.717+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: CENTOLLA	MC	30
62b60e1e-af54-47c2-90eb-c6a1da894a67	2025	160	53df37fa-4876-4db9-8044-82c60dca71e7	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	2025-11-09 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.725+00	2026-01-02 04:19:25.725+00	t	Importada de JSONL. Empresa: CENTOMAR S.A. Especie: CENTOLLA	MC	30
4b8a9636-1f50-4937-9173-336dff78d13d	2025	161	6c8c18f7-5a09-4d3c-87d1-d237f3d91347	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	2025-11-09 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.733+00	2026-01-02 04:19:25.733+00	t	Importada de JSONL. Empresa: BENTONICOS DE ARGENTINA. Especie: CENTOLLA	MC	30
2450ccd1-2512-40e9-8c62-f2b4db5236be	2025	162	47279cdd-c76c-4f3d-a415-a7a608071774	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	2025-11-09 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.741+00	2026-01-02 04:19:25.741+00	t	Importada de JSONL. Empresa: BENTONICOS DE ARGENTINA. Especie: CENTOLLA	MC	30
01e2eed6-b176-4e5e-a9f6-6b150a7c4f91	2025	163	c15ee044-9471-45a9-b364-592713e66ad9	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.75+00	2026-01-02 04:19:25.75+00	t	Importada de JSONL. Empresa: PESANTAR. Especie: MERLUZA AUSTRAL	MC	30
522e84d3-cfd8-4209-b2e9-b7d7813d69d6	2025	164	86cb6687-b67d-4ea6-9eda-41d661113304	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.759+00	2026-01-02 04:19:25.759+00	t	Importada de JSONL. Empresa: XEITOSIÑO. Especie: LANGOSTINO	MC	30
0832ca2f-72dd-46ec-bf85-58ad0aeb5ee2	2025	165	96bd0a31-93a4-447f-8be0-6bff3b5ecf41	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.768+00	2026-01-02 04:19:25.768+00	t	Importada de JSONL. Empresa: ESTREMAR. Especie: MERLUZA AUSTRAL	MC	30
99ce6f70-8be7-4592-871d-a313f8a1def8	2025	166	e9603c58-cdf7-47dd-a343-2a3b5cf2fc8e	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.775+00	2026-01-02 04:19:25.775+00	t	Importada de JSONL. Empresa: ARGENOVA. Especie: MERLUZA AUSTRAL	MC	30
9fabf937-de6c-4586-bbe1-d68fa3fd1046	2025	167	a1d19025-1d1e-4a18-8c08-3aac431d1066	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.785+00	2026-01-02 04:19:25.785+00	t	Importada de JSONL. Empresa: PESQUERA VERAZ S.A. Especie: MERLUZA	MC	30
f061bef3-492a-453e-b4ac-bda56b649be0	2025	168	a1a4671b-7bd8-4d11-bdc7-b5fdaee913f7	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.806+00	2026-01-02 04:19:25.806+00	t	Importada de JSONL. Empresa: PEDRO MOSCUZZA E HIJO. Especie: MERLUZA	MC	30
c73e2490-d4b3-4782-b40d-cfea53c2fbe0	2025	169	8d3baa92-31d9-43d1-bd6c-bfde522ca762	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	2025-12-10 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.815+00	2026-01-02 04:19:25.815+00	t	Importada de JSONL. Empresa: CRUSTACEOS DEL SUR S.A. Especie: CENTOLLA	MC	60
a8130766-0d49-41e8-aae2-04c262cdefc1	2025	170	a3561d1d-6da1-4e4b-bebf-ff55987e1477	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.824+00	2026-01-02 04:19:25.824+00	t	Importada de JSONL. Empresa: BUENA PROA. Especie: MERLUZA	MC	30
146597b1-3b39-4d7b-b3b0-724bb85ed86d	2025	171	9c05f19b-cb5b-4597-8498-ced13f6dfa1c	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.837+00	2026-01-02 04:19:25.837+00	t	Importada de JSONL. Empresa: GLACIAR PESQUERA. Especie: VIEIRA	MC	60
1cb8f85f-72e1-4126-a81f-605eab9ad6c6	2025	172	f1a9f401-eb5c-429e-aeee-c4428a78e346	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.845+00	2026-01-02 04:19:25.845+00	t	Importada de JSONL. Empresa: CRUSTACEOS DEL SUR S.A. Especie: CENTOLLA	MC	30
84b85110-8a86-4ab5-b80c-5134f0830829	2025	173	96bd0a31-93a4-447f-8be0-6bff3b5ecf41	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.853+00	2026-01-02 04:19:25.853+00	t	Importada de JSONL. Empresa: ESTREMAR. Especie: MERLUZA AUSTRAL	MC	30
e84d19de-5da7-4519-9cf5-910dd890b329	2025	174	50830bce-68a4-4ec9-a8df-9b44be25f87c	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.862+00	2026-01-02 04:19:25.862+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: VIEIRA	MC	30
e5e47077-b892-4a42-bb7e-f45048793af0	2025	175	2e95d154-8dcc-4f37-8a74-317fcc17f52e	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.87+00	2026-01-02 04:19:25.87+00	t	Importada de JSONL. Empresa: SOLIMENO e HIJOS S.A. Especie: MERLUZA	MC	30
69405fcc-9a8e-42d2-8574-6404373393a6	2025	176	947d5aaf-de3e-4a75-9839-e36db2a74995	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	2025-01-11 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.886+00	2026-01-02 04:19:25.886+00	t	Importada de JSONL. Empresa: ROTELLO S.A. Especie: MERLUZA	MC	30
35e9cc11-ace6-4638-b0e1-eb36f0d896fe	2025	177	1fc9c088-da05-4d5c-b833-e3a9be7bc1e3	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	2025-03-11 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.895+00	2026-01-02 04:19:25.895+00	t	Importada de JSONL. Empresa: ARPES S.A. Especie: MERLUZA	MC	30
78bdc139-080d-4e4d-9e2a-02851296e818	2025	178	53df37fa-4876-4db9-8044-82c60dca71e7	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	2025-06-11 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.91+00	2026-01-02 04:19:25.91+00	t	Importada de JSONL. Empresa: CENTOMAR S.A. Especie: CENTOLLA	MC	30
5601b2a1-cd89-442d-8254-98fea8c1824f	2025	179	ac5b3f8b-9376-47ec-b4aa-45dbbbd20f85	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	2025-04-11 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.917+00	2026-01-02 04:19:25.917+00	t	Importada de JSONL. Empresa: AIRE MARINO. Especie: ANCHOÍTA	MC	30
626a325b-8661-42b5-93c0-3bf7c90281b0	2025	180	c3786112-eea9-46fd-ad67-918e6e0f15e3	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	2025-10-11 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.925+00	2026-01-02 04:19:25.925+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: CENTOLLA	MC	30
5769495e-7955-4b1a-ad82-62ea28c617eb	2025	181	a07bd243-6580-4a69-afcb-ef60c1d6c789	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	2025-10-11 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.93+00	2026-01-02 04:19:25.93+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: VIEIRA	MC	30
3387128a-2001-4de4-ad54-2f427c84a439	2025	182	c15ee044-9471-45a9-b364-592713e66ad9	\N	0110f7f6-ebaf-4012-b288-d4e3a34d7c58	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.94+00	2026-01-02 04:19:25.94+00	t	Importada de JSONL. Empresa: PESANTAR. Especie: MERLUZA AUSTRAL	MC	30
f99a005f-da47-4c0f-bef8-d0fcce618569	2025	183	f1a9f401-eb5c-429e-aeee-c4428a78e346	\N	0110f7f6-ebaf-4012-b288-d4e3a34d7c58	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.946+00	2026-01-02 04:19:25.946+00	t	Importada de JSONL. Empresa: CRUSTACEOS DEL SUR S.A. Especie: CENTOLLA	MC	30
e53a943d-a94b-4d32-94f5-211c7eb2ba7e	2025	184	8eb864be-6c72-482d-85ed-747bc6e2f376	\N	0110f7f6-ebaf-4012-b288-d4e3a34d7c58	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.952+00	2026-01-02 04:19:25.952+00	t	Importada de JSONL. Empresa: PRODESUR. Especie: MERLUZA AUSTRAL	MC	60
282918f1-73ef-4b02-b0ec-1762bb379527	2025	185	a1d19025-1d1e-4a18-8c08-3aac431d1066	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	2025-01-12 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.957+00	2026-01-02 04:19:25.957+00	t	Importada de JSONL. Empresa: PESQUERA VERAZ S.A. Especie: MERLUZA	MC	30
d0b2d1e1-0726-4270-bf2d-29252c7f4a3c	2025	186	9c05f19b-cb5b-4597-8498-ced13f6dfa1c	\N	0110f7f6-ebaf-4012-b288-d4e3a34d7c58	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.967+00	2026-01-02 04:19:25.967+00	t	Importada de JSONL. Empresa: GLACIAR PESQUERA. Especie: VIEIRA	MC	30
9f5a6248-f6e5-4af4-807a-0f8ecb6081a3	2025	187	50830bce-68a4-4ec9-a8df-9b44be25f87c	\N	0110f7f6-ebaf-4012-b288-d4e3a34d7c58	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.972+00	2026-01-02 04:19:25.972+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: VIEIRA	MC	30
b835a7fc-ba5d-4204-b081-ffc0c6062835	2025	188	96bd0a31-93a4-447f-8be0-6bff3b5ecf41	\N	4a3cf5f6-2ec8-4f78-b2eb-5c9b17db9806	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.98+00	2026-01-02 04:19:25.98+00	t	Importada de JSONL. Empresa: ESTREMAR S.A. Especie: MERLUZA AUSTRAL	MC	30
313f9e8d-b3ff-44e8-a18d-cafba58c8633	2025	189	0d63dd59-ac7e-49ae-b324-349fff46355d	\N	4a3cf5f6-2ec8-4f78-b2eb-5c9b17db9806	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.988+00	2026-01-02 04:19:25.988+00	t	Importada de JSONL. Empresa: CHIARPESCA. Especie: CALAMAR	MC	30
7f169611-4c23-4493-a6c4-d7b801ea22d0	2025	190	15a63476-e520-4a78-a3be-1f59ba28426a	\N	4a3cf5f6-2ec8-4f78-b2eb-5c9b17db9806	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:25.995+00	2026-01-02 04:19:25.995+00	t	Importada de JSONL. Empresa: ARGENOVA. Especie: CALAMAR	MC	30
4685550e-bc39-4ce7-8e3c-bfe78c0eb550	2025	191	c39a8309-bb16-4f99-ad5f-6033c8c9476b	\N	4a3cf5f6-2ec8-4f78-b2eb-5c9b17db9806	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:26.002+00	2026-01-02 04:19:26.002+00	t	Importada de JSONL. Empresa: ALTAMARE S.AS. Especie: CALAMAR	MC	30
64f6fef2-2ad6-4b87-b123-ce957413327e	2025	192	876b619b-415f-46fc-97d6-9b2426352d5e	\N	4a3cf5f6-2ec8-4f78-b2eb-5c9b17db9806	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:26.008+00	2026-01-02 04:19:26.008+00	t	Importada de JSONL. Empresa: PESQUERÍA  RÍO QUEQUEN. Especie: CALAMAR	MC	30
3acd6cd1-c16b-4aff-b0e8-4ece4b6242b6	2025	193	bc7a5a8c-77d8-471c-b6cb-d2fc5a68e09d	\N	4a3cf5f6-2ec8-4f78-b2eb-5c9b17db9806	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:26.013+00	2026-01-02 04:19:26.013+00	t	Importada de JSONL. Empresa: PESQUERÍA  RÍO QUEQUEN. Especie: CALAMAR	MC	30
b29e16b0-d3ed-4bc9-8d9b-fd120936a2cf	2025	194	53df37fa-4876-4db9-8044-82c60dca71e7	\N	4a3cf5f6-2ec8-4f78-b2eb-5c9b17db9806	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:26.021+00	2026-01-02 04:19:26.021+00	t	Importada de JSONL. Empresa: CENTOMAR S.A. Especie: CENTOLLA	MC	30
21248cd4-d199-4c9e-b66d-486560b78ad7	2025	195	8d3baa92-31d9-43d1-bd6c-bfde522ca762	\N	4a3cf5f6-2ec8-4f78-b2eb-5c9b17db9806	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:26.027+00	2026-01-02 04:19:26.027+00	t	Importada de JSONL. Empresa: CRUSTACEOS DEL SUR S.A. Especie: CENTOLLA	MC	30
8ce9abef-0766-4392-b743-2f89ed3d5605	2025	196	6c8c18f7-5a09-4d3c-87d1-d237f3d91347	\N	0110f7f6-ebaf-4012-b288-d4e3a34d7c58	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:26.034+00	2026-01-02 04:19:26.034+00	t	Importada de JSONL. Empresa: BENTONICOS DE ARGENTINA. Especie: CENTOLLA	MC	30
b4e0080e-8ffc-424b-852d-999c63e0e44d	2025	197	47279cdd-c76c-4f3d-a415-a7a608071774	\N	4a3cf5f6-2ec8-4f78-b2eb-5c9b17db9806	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:26.041+00	2026-01-02 04:19:26.041+00	t	Importada de JSONL. Empresa: BENTONICOS DE ARGENTINA. Especie: CENTOLLA	MC	30
d0061bcf-3c71-4b48-9a89-339295ea8a8f	2025	198	0ec9005b-6b77-4893-8ea8-601e0890d630	\N	4a3cf5f6-2ec8-4f78-b2eb-5c9b17db9806	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:26.046+00	2026-01-02 04:19:26.046+00	t	Importada de JSONL. Empresa: GIORNO. Especie: CALAMAR	MC	30
5a962b38-3431-4b27-acb7-1b151637772d	2025	199	5733a2fe-ec8a-4665-bc9a-a2e09b944857	\N	4a3cf5f6-2ec8-4f78-b2eb-5c9b17db9806	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:26.053+00	2026-01-02 04:19:26.053+00	t	Importada de JSONL. Empresa: GLACIAR PESQUERA. Especie: VIEIRA	MC	30
d83a8713-78fd-4a3b-ba65-3b81fae4e3cd	2025	200	921868fd-ad81-4d46-b3a5-8d59564fb909	\N	4a3cf5f6-2ec8-4f78-b2eb-5c9b17db9806	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:26.059+00	2026-01-02 04:19:26.059+00	t	Importada de JSONL. Empresa: LUIS SOLIMENO. Especie: CALAMAR	MC	30
f79b70da-a1cc-478e-b274-9f90c832d055	2025	201	f04762bd-b81a-4386-a030-3c0baaba0a2b	\N	4a3cf5f6-2ec8-4f78-b2eb-5c9b17db9806	\N	\N	\N	\N	AUTOMATICO	\N	\N	\N	\N	\N	2026-01-02 04:19:26.066+00	2026-01-02 04:19:26.066+00	t	Importada de JSONL. Empresa: PESQUERA COMERCIAL. Especie: CALAMAR	MC	30
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
117cc1e8-ff33-45be-9706-9d50ef00e0dc	04919a8e-1d89-49a8-a98c-c7e4c864c82c	1	1c1f245c-1079-42a0-a6a8-1db4ac5845d4	\N	\N	2025-01-03 03:00:00+00	2025-01-03 03:00:00+00	COMERCIAL	Etapa 1 importada
1eeeef47-bf5b-4cd4-8948-90c24cdfa77b	c3a1effd-b5dc-4dc6-82bd-bf565dbb9fa2	1	1c1f245c-1079-42a0-a6a8-1db4ac5845d4	\N	\N	2025-01-28 03:00:00+00	2025-01-28 03:00:00+00	COMERCIAL	Etapa 1 importada
f719cffe-893c-4d3c-9259-2677be8f50ab	6b27610e-53c5-4d23-a5c3-2d54da315aec	1	f4dfbae3-8a9b-4e7a-acba-439207f86b95	\N	\N	2025-01-03 03:00:00+00	2025-03-04 03:00:00+00	COMERCIAL	Etapa 1 importada
c8f5f44f-89e2-4b2b-b3b9-307e2e8e40ce	874d961e-4f10-44d8-8a26-704dfe59baf8	1	bc86d2a9-3de5-494d-91aa-207e2eadbe81	\N	\N	2025-01-11 03:00:00+00	2025-03-07 03:00:00+00	COMERCIAL	Etapa 1 importada
4e8c2299-63ba-4d01-8aab-a7131c877d72	07879508-cbb4-4b79-a7ac-df50a730ae89	1	bc86d2a9-3de5-494d-91aa-207e2eadbe81	\N	\N	2025-01-07 03:00:00+00	2025-01-28 03:00:00+00	COMERCIAL	Etapa 1 importada
6a22a015-ed79-4508-a2bc-3133bb932abf	f0651e46-2efb-4b53-aada-e5674bf3b42c	1	3b938974-38a9-4b5b-ac50-a88465f7a025	\N	\N	2025-01-08 03:00:00+00	2025-02-02 03:00:00+00	COMERCIAL	Etapa 1 importada
bea54021-4fad-4afe-b8d2-39cc8810ff16	e8ca1cdc-4a63-4c22-ad41-9f5735a63771	1	3b938974-38a9-4b5b-ac50-a88465f7a025	\N	\N	2025-01-07 03:00:00+00	2025-01-30 03:00:00+00	COMERCIAL	Etapa 1 importada
c69194e3-67f7-4e3b-8b91-d87f5be41496	d0571ab3-52eb-46ee-8c7c-35c742e70e57	1	bc86d2a9-3de5-494d-91aa-207e2eadbe81	\N	\N	2025-01-11 03:00:00+00	2025-01-19 03:00:00+00	COMERCIAL	Etapa 1 importada
9c069fcf-c8d4-48cd-849f-226154f9c3f6	d0571ab3-52eb-46ee-8c7c-35c742e70e57	2	bc86d2a9-3de5-494d-91aa-207e2eadbe81	\N	\N	2025-01-22 03:00:00+00	2025-01-29 03:00:00+00	COMERCIAL	Etapa 2 importada
c18daad2-6379-497b-8d02-e0888c93f03c	d0571ab3-52eb-46ee-8c7c-35c742e70e57	3	bc86d2a9-3de5-494d-91aa-207e2eadbe81	\N	\N	2025-01-31 03:00:00+00	2025-02-02 03:00:00+00	COMERCIAL	Etapa 3 importada
7ea9c8fc-71b9-4e0a-b748-e7b18379f996	f404c632-fac3-4128-9cd5-114a21d0531d	1	5524fead-8510-4189-91a2-ac7d39675ece	\N	\N	2025-01-06 03:00:00+00	2025-02-07 03:00:00+00	COMERCIAL	Etapa 1 importada
27792e74-b3f8-4fd5-99cc-c03cd9a7f14c	acc394fb-c63f-4afe-8cfa-c766d39201bb	1	5524fead-8510-4189-91a2-ac7d39675ece	\N	\N	2025-01-13 03:00:00+00	2025-02-24 03:00:00+00	COMERCIAL	Etapa 1 importada
9f088ac8-2311-4e9e-93c6-a0eed5619df5	79891cde-4f19-4d5c-bf01-d1f5b7a48536	1	3b938974-38a9-4b5b-ac50-a88465f7a025	\N	\N	2025-01-08 03:00:00+00	2025-02-02 03:00:00+00	COMERCIAL	Etapa 1 importada
a2d95f19-effd-4363-a89e-1198ef9f9b70	19a2c92e-bc67-47be-942c-dac4ff8bd026	1	5524fead-8510-4189-91a2-ac7d39675ece	\N	\N	2025-01-09 03:00:00+00	2025-02-16 03:00:00+00	COMERCIAL	Etapa 1 importada
2013bda4-bb31-48f0-94c2-1d9bab84e5c4	c4feca97-3387-47cc-b0e1-81970ddc9dc1	1	f4dfbae3-8a9b-4e7a-acba-439207f86b95	\N	\N	2025-01-08 03:00:00+00	2025-02-17 03:00:00+00	COMERCIAL	Etapa 1 importada
fd26a162-14a8-41aa-880c-a770b9b30726	fc29f36b-38b2-42e3-ada5-922e621fd69e	1	3b938974-38a9-4b5b-ac50-a88465f7a025	\N	\N	2025-01-09 03:00:00+00	2025-02-13 03:00:00+00	COMERCIAL	Etapa 1 importada
f68e82ba-fb77-4c97-b310-b44ef0a48baa	fcb741cf-4c60-4996-b34a-ddb7d675c782	1	bc86d2a9-3de5-494d-91aa-207e2eadbe81	\N	\N	2025-01-12 03:00:00+00	2025-01-19 03:00:00+00	COMERCIAL	Etapa 1 importada
7695be61-3096-4c9e-be8c-444dcf90aaf7	fcb741cf-4c60-4996-b34a-ddb7d675c782	2	bc86d2a9-3de5-494d-91aa-207e2eadbe81	\N	\N	2025-01-20 03:00:00+00	2025-01-26 03:00:00+00	COMERCIAL	Etapa 2 importada
01e575af-e0e6-4d15-9fe9-e79d6074f720	fcb741cf-4c60-4996-b34a-ddb7d675c782	3	bc86d2a9-3de5-494d-91aa-207e2eadbe81	\N	\N	2025-01-28 03:00:00+00	2025-02-06 03:00:00+00	COMERCIAL	Etapa 3 importada
29041fe0-2163-4f0f-a998-ebc15d263dae	fcb741cf-4c60-4996-b34a-ddb7d675c782	4	bc86d2a9-3de5-494d-91aa-207e2eadbe81	\N	\N	2025-02-07 03:00:00+00	2025-02-12 03:00:00+00	COMERCIAL	Etapa 4 importada
d33d7156-5141-46f3-a75c-3308b2c4ead3	33798d54-773b-44d7-9824-2ee0a9ad68e5	1	5524fead-8510-4189-91a2-ac7d39675ece	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
24ae52c7-3523-4d09-bf4f-a0708acce3ab	6de667b9-de1b-45b0-92a1-6a810df139a4	1	3b938974-38a9-4b5b-ac50-a88465f7a025	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
5bfcdbbb-102d-4bd7-93d1-dd94e19779f6	93fdbfcc-2f30-47cb-811d-ea5b5fa2d1ab	1	3b938974-38a9-4b5b-ac50-a88465f7a025	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
bd3a43c3-9dcc-4066-9de7-e23b9ee04ad5	2a7c3bd8-bb58-40b6-b423-52c2b8a7c48f	1	f4dfbae3-8a9b-4e7a-acba-439207f86b95	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
04ddf0be-af7c-43f4-ac0d-5569ae0f6773	360e781e-8403-417d-a78c-ac278ca025e2	1	3b938974-38a9-4b5b-ac50-a88465f7a025	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
51bae0a9-9b6c-49db-a734-291d6feb6e5b	562aa66d-c729-4132-bb7d-27ad7e32e3d1	1	f4dfbae3-8a9b-4e7a-acba-439207f86b95	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
7323d925-1f18-45a5-9a72-d70fc49cca83	aa6b4552-3765-4da4-99aa-54e9cdd87ef7	1	3b938974-38a9-4b5b-ac50-a88465f7a025	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
5fccadc5-ef11-4663-a417-54ed3443f69b	346eb434-1937-4e63-800c-bee29cca4325	1	3b938974-38a9-4b5b-ac50-a88465f7a025	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
17da7e83-3ba2-4da6-856a-b1987c4f588a	346eb434-1937-4e63-800c-bee29cca4325	2	3b938974-38a9-4b5b-ac50-a88465f7a025	\N	\N	\N	\N	COMERCIAL	Etapa 2 importada
f586b64b-28cd-4030-8d32-f62cfb388851	4dd4f175-b2ec-4675-917f-1f33c34d275e	1	1c1f245c-1079-42a0-a6a8-1db4ac5845d4	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
140694e7-1a20-4903-8eb0-4d24a3bd3bda	4d1f7c39-65a9-4eef-aa62-5c082d8c4522	1	f4dfbae3-8a9b-4e7a-acba-439207f86b95	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
79fe7f72-01aa-472f-9cc8-65e0ce5769f3	03b80d20-6553-4257-82a2-58965ee924a9	1	bc86d2a9-3de5-494d-91aa-207e2eadbe81	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
2b23a09e-003d-411c-abec-dc5db9d16dfd	9a73cb1d-5a35-44ee-b4a6-b9b371b599d5	1	3b938974-38a9-4b5b-ac50-a88465f7a025	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
44e1a05b-5edd-4985-89b1-9cda629143fd	a23ab54e-f24c-4b0c-bce7-8d5441ea2309	1	3b938974-38a9-4b5b-ac50-a88465f7a025	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
d8442fe7-4223-4cd6-9487-490a07c14221	bc698db6-d2c9-472d-a461-25ca56770f94	1	bc86d2a9-3de5-494d-91aa-207e2eadbe81	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
2f1b3a7d-2a5c-496c-965e-5b2b2c185939	c7c980d8-5207-48a7-9d1c-d2f291f7368f	1	1c1f245c-1079-42a0-a6a8-1db4ac5845d4	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
37e3ba4b-de68-4d0d-8ec0-abecbe77a274	b46e9497-edac-42dc-a8bf-db062b822264	1	5524fead-8510-4189-91a2-ac7d39675ece	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
267fa383-42a7-450b-8e59-d338aae99fae	a9ded57b-c564-42d6-ac89-5ab0dcde7a92	1	1c1f245c-1079-42a0-a6a8-1db4ac5845d4	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
ad36ce69-b636-4a47-9a64-5f041608f898	1a2d90b1-a6cb-4b58-bdad-ccd602c60fba	1	bc86d2a9-3de5-494d-91aa-207e2eadbe81	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
064ed822-3654-4095-8a26-2560a8653ee7	9711d801-642d-400a-b9ee-6e7e0a543a06	1	5524fead-8510-4189-91a2-ac7d39675ece	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
b674b883-328f-4245-99e3-c47ea0c4767a	5f0abe34-ea90-43a2-9adc-b6fbd7ebbcea	1	1c1f245c-1079-42a0-a6a8-1db4ac5845d4	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
946005ac-7400-432e-8170-c3d51b3ec430	60ed4b3f-84f8-432d-af24-d0fe1d8a6f5c	1	5524fead-8510-4189-91a2-ac7d39675ece	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
ed92cf56-46cc-48fe-92a5-c7a5f88f1de0	b8188c44-bfce-4fc9-993e-86c6212f9e62	1	f4dfbae3-8a9b-4e7a-acba-439207f86b95	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
c19f4fb6-f537-4558-876e-73cde4bce3b7	d7477631-230c-43cc-9ad2-9a458540e95d	1	f4dfbae3-8a9b-4e7a-acba-439207f86b95	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
c4644045-3bb6-406a-8b21-45a4bddbc876	14943dfc-1f7d-4bc5-808c-51d6c4e1d2ab	1	5524fead-8510-4189-91a2-ac7d39675ece	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
0f634f43-ba95-4d11-a304-e40a7aab443e	8c71e1d6-747e-4f67-b74f-5fa24fb8b1e1	1	3b938974-38a9-4b5b-ac50-a88465f7a025	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
66cefd50-b92e-4eac-938a-ddda9eb26aed	3e3cf12e-d182-4e0f-ba3f-e39a3880cecc	1	\N	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
15f45bf0-8024-4eb3-9deb-ec369f3dedeb	3e3cf12e-d182-4e0f-ba3f-e39a3880cecc	2	\N	\N	\N	\N	\N	COMERCIAL	Etapa 2 importada
2ea51b2c-1443-452b-ae25-a6bcb9348af1	cfb18177-e9ea-4c31-9bb0-f50de16b33b4	1	\N	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
10548904-af82-4fc9-993b-4295ac240d1c	cfb18177-e9ea-4c31-9bb0-f50de16b33b4	2	\N	\N	\N	\N	\N	COMERCIAL	Etapa 2 importada
28479828-d0cc-44e0-b087-dc8297db96b0	c72cddb5-13a0-4308-8592-90c485b9223a	1	\N	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
0b79b9d0-5e42-4ab6-998e-f96901064cec	c72cddb5-13a0-4308-8592-90c485b9223a	2	\N	\N	\N	\N	\N	COMERCIAL	Etapa 2 importada
3398c176-a4f3-4f5b-8861-ec5ce26756bf	8eadcafe-2174-429c-b3a7-cffec0d8e62a	1	\N	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
8ffc4857-3d7d-4bd8-8d20-4323acc328f2	8eadcafe-2174-429c-b3a7-cffec0d8e62a	2	\N	\N	\N	\N	\N	COMERCIAL	Etapa 2 importada
2fa18909-aef0-46d5-9445-0982a376cfae	4e37279f-2272-4096-92e0-40b32bb3b655	1	\N	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
ec9120b5-43a9-4439-9db2-0198c2a39ae2	4e37279f-2272-4096-92e0-40b32bb3b655	2	\N	\N	\N	\N	\N	COMERCIAL	Etapa 2 importada
b84a17d4-18af-411c-bffd-f4d49a9c4b1d	f59534d7-f262-4dd8-8f64-fa3d3091571e	1	f4dfbae3-8a9b-4e7a-acba-439207f86b95	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
8c15fc13-a42e-4a15-a882-42f3b6635214	2f6ee5d6-2d49-4c5a-91ff-a006e893a74c	1	f4dfbae3-8a9b-4e7a-acba-439207f86b95	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
7d331713-bec1-4554-a1d6-c60dd9cde967	f20a8859-90c1-4396-ab58-e3190eeb2991	1	bc86d2a9-3de5-494d-91aa-207e2eadbe81	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
727daf77-7bd6-4ff1-af64-fa41bfb1f33a	05d56476-ae1b-4c68-917c-a7bacb26fdde	1	3b938974-38a9-4b5b-ac50-a88465f7a025	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
d8414b25-77df-40ce-808a-dd451af3886a	8a897cec-9409-440e-ab29-f7be994ca100	1	5524fead-8510-4189-91a2-ac7d39675ece	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
58e4ebe5-cc2f-40b9-baaa-8b0b5ab41892	6bc7c5a7-f9e0-4b66-87c7-afb6431a3361	1	1c1f245c-1079-42a0-a6a8-1db4ac5845d4	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
8eca5f87-ded1-4478-8e6a-95ba5d70bc24	b41abed5-fc68-4678-bfba-f38defa54ff6	1	3b938974-38a9-4b5b-ac50-a88465f7a025	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
4a1f979d-8128-4cbd-9be0-24202cabf210	349de9dd-0da8-421f-a240-e329d057d367	1	5524fead-8510-4189-91a2-ac7d39675ece	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
cc527d87-8fa5-414d-a61e-7d1d96fc5ff0	0efc2eee-dfc0-4093-b2b4-d231e2e4d555	1	1c1f245c-1079-42a0-a6a8-1db4ac5845d4	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
55010ed7-84f2-4b2d-b6b1-efff45395f10	19506384-a971-4c7f-812a-333c4c523d50	1	1c1f245c-1079-42a0-a6a8-1db4ac5845d4	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
d2f0256c-c844-4a94-a7c4-554828e74dc9	cb5e0b51-9a46-4c91-94ae-cb019458fcd9	1	f4dfbae3-8a9b-4e7a-acba-439207f86b95	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
a1fb1174-3a80-49dd-a8c5-1f17bb7ec273	4d4a0a97-9c4c-452b-9234-922947c4255e	1	3b938974-38a9-4b5b-ac50-a88465f7a025	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
77807950-d031-45cd-838e-30285517c23b	35dda77d-99d2-41e9-8118-3f6e3dc9ba2d	1	5524fead-8510-4189-91a2-ac7d39675ece	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
d816dfa0-e286-420d-97d0-b0dc981a6f7c	cb556c38-7986-4a55-ba9d-208e6e60b75d	1	f4dfbae3-8a9b-4e7a-acba-439207f86b95	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
7676cdc2-37d9-424f-a5fa-f5f6a41d6bd6	4f243ff3-95be-4da8-af26-83c044b89ffc	1	5524fead-8510-4189-91a2-ac7d39675ece	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
3f0a8db3-9bbf-410c-bd97-02d15871c93e	6bcd1042-c72b-4a90-a3d2-f60957e833a0	1	3b938974-38a9-4b5b-ac50-a88465f7a025	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
ba312134-bb0f-42f6-86ff-8a6686544427	bf5b9c59-103c-4165-9443-b16ab79763ba	1	b0113ae4-988a-4010-a1cf-f72572ea68fb	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
26f6c105-69fc-419b-b853-4a35b045a67f	bf5b9c59-103c-4165-9443-b16ab79763ba	2	b0113ae4-988a-4010-a1cf-f72572ea68fb	\N	\N	\N	\N	COMERCIAL	Etapa 2 importada
8b092b82-161b-403a-8fac-b000b357e07d	bf5b9c59-103c-4165-9443-b16ab79763ba	3	b0113ae4-988a-4010-a1cf-f72572ea68fb	\N	\N	\N	\N	COMERCIAL	Etapa 3 importada
3f62d2a7-9426-487f-9f3d-a9e416898201	1d9c2349-cd16-4dc3-a3b3-03c9cfc52939	1	bc86d2a9-3de5-494d-91aa-207e2eadbe81	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
73e5f1ba-8e88-4250-88f0-6d144d5e5183	de6be5aa-e1f3-4e48-be2d-ad6ab4329899	1	bc86d2a9-3de5-494d-91aa-207e2eadbe81	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
a66f0b73-eac3-4d6c-80fa-c0a0cc1188e3	de6be5aa-e1f3-4e48-be2d-ad6ab4329899	2	bc86d2a9-3de5-494d-91aa-207e2eadbe81	\N	\N	\N	\N	COMERCIAL	Etapa 2 importada
36284a6e-b12f-4b02-aafa-28d93df8f0db	de6be5aa-e1f3-4e48-be2d-ad6ab4329899	3	bc86d2a9-3de5-494d-91aa-207e2eadbe81	\N	\N	\N	\N	COMERCIAL	Etapa 3 importada
bf54e092-2acf-41ba-987a-e7508c91c798	8f7129bd-295f-4671-b1c8-2ca93d2b881e	1	bc86d2a9-3de5-494d-91aa-207e2eadbe81	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
9cec5c70-abb0-409a-bcde-0662de916964	8f7129bd-295f-4671-b1c8-2ca93d2b881e	2	bc86d2a9-3de5-494d-91aa-207e2eadbe81	\N	\N	\N	\N	COMERCIAL	Etapa 2 importada
8ef0e680-7312-43f7-be3f-0697d59ee5d7	06c23584-5894-441a-a353-4477b9922edc	1	bc86d2a9-3de5-494d-91aa-207e2eadbe81	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
f77cb7f2-f319-4177-b412-259d10a38cf9	4f77e130-30f0-4325-9568-454e639c323c	1	bc86d2a9-3de5-494d-91aa-207e2eadbe81	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
ea4e6e4f-9b34-46a1-9307-8cb5a6007b20	4f77e130-30f0-4325-9568-454e639c323c	2	bc86d2a9-3de5-494d-91aa-207e2eadbe81	\N	\N	\N	\N	COMERCIAL	Etapa 2 importada
f628cd6c-f402-4a72-9b3e-2a943427d22c	4f77e130-30f0-4325-9568-454e639c323c	3	bc86d2a9-3de5-494d-91aa-207e2eadbe81	\N	\N	\N	\N	COMERCIAL	Etapa 3 importada
82a3940e-016d-4e3d-8ebc-6a68be4731ad	49d2cd67-e474-4452-9b24-19ac5f78c47a	1	3b938974-38a9-4b5b-ac50-a88465f7a025	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
ef9984d5-6fe4-41b2-b867-d254569381aa	5884959a-814b-476d-9115-33b8933e7a60	1	bc86d2a9-3de5-494d-91aa-207e2eadbe81	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
6fc0e506-7a06-4798-ade9-e6e928e16095	5884959a-814b-476d-9115-33b8933e7a60	2	bc86d2a9-3de5-494d-91aa-207e2eadbe81	\N	\N	\N	\N	COMERCIAL	Etapa 2 importada
e84d632f-5fc8-4504-b4d2-a45f6ae0faaa	b2934e06-51b0-4316-b962-e4c7053df833	1	3b938974-38a9-4b5b-ac50-a88465f7a025	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
344f2822-8054-45cd-b390-28d8dc4a734e	0409eab0-c608-40e5-ae39-86bc117311b0	1	1c1f245c-1079-42a0-a6a8-1db4ac5845d4	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
b35c5d5e-3748-4461-b479-db79638cbc3b	d5464931-b47d-46f0-aa9b-4e80b3dd2dde	1	bc86d2a9-3de5-494d-91aa-207e2eadbe81	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
3670fca4-2b56-45f5-9d45-7c1befc7bfb8	d5464931-b47d-46f0-aa9b-4e80b3dd2dde	2	bc86d2a9-3de5-494d-91aa-207e2eadbe81	\N	\N	\N	\N	COMERCIAL	Etapa 2 importada
7e76fb92-e799-4442-af70-d92ce972ca25	d5464931-b47d-46f0-aa9b-4e80b3dd2dde	3	bc86d2a9-3de5-494d-91aa-207e2eadbe81	\N	\N	\N	\N	COMERCIAL	Etapa 3 importada
0b314bc7-0ba5-4099-841d-02bde61362a5	1cfa1f0f-f9b2-42ee-8d42-5bac2892191f	1	bc86d2a9-3de5-494d-91aa-207e2eadbe81	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
81210f7c-a16a-4dcf-bf11-4c2bd0e4d558	cee1a4b3-5735-4c40-9c55-50adc608d891	1	1c1f245c-1079-42a0-a6a8-1db4ac5845d4	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
930d61b4-10f8-49b3-aedb-ff97d91c72a4	44f73667-e99a-4d86-a7c9-340b3529bdc9	1	5524fead-8510-4189-91a2-ac7d39675ece	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
c1229a95-0984-4460-8b2d-4220fdfb0de1	7734461b-f8e3-49c1-ba99-37f094756bbc	1	bc86d2a9-3de5-494d-91aa-207e2eadbe81	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
1f81322e-8c0d-4c6f-8028-f93fa0a49834	fbffea19-f8bf-487e-a809-4bb307a6806d	1	3b938974-38a9-4b5b-ac50-a88465f7a025	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
e6c82153-cc7b-4c0e-8df3-75c757fcb84e	81390c34-45d6-4c2b-a48c-a065065bb3df	1	3b938974-38a9-4b5b-ac50-a88465f7a025	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
91218403-03b4-4f41-9e66-e32afb59f936	dc473bf3-beba-47e1-a1d5-237083bd1428	1	b0113ae4-988a-4010-a1cf-f72572ea68fb	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
3560884f-acfd-441f-9e91-7e6f51c36d79	c11a111c-c96c-424a-afd3-529c724eee5e	1	f4dfbae3-8a9b-4e7a-acba-439207f86b95	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
e79d65f7-deef-4043-a539-24007398ff88	5894c1f3-0fc4-4eb8-a491-1869a60d2dea	1	1c1f245c-1079-42a0-a6a8-1db4ac5845d4	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
20d43522-89c6-4047-b52f-7bc3826d9043	83628072-328b-47e0-8ba2-f056d4f2ed16	1	bc86d2a9-3de5-494d-91aa-207e2eadbe81	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
c6d34f31-f8dc-4461-aa0d-30c3ccc09530	25aee2f6-a2a3-4287-b842-a185b82a8541	1	bc86d2a9-3de5-494d-91aa-207e2eadbe81	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
6f4cc54c-7062-4c9c-871f-213933daa495	1f3e8257-874b-4932-8792-9c454fa422a3	1	3b938974-38a9-4b5b-ac50-a88465f7a025	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
4a568ae0-98f6-4250-940b-a0298f1396d1	83dd63f4-c066-458b-a6da-9edc38a9fe26	1	1c1f245c-1079-42a0-a6a8-1db4ac5845d4	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
5b19633f-e446-4478-afd0-cf722c352832	72e6712e-ddab-42e8-ae4d-be6ecfb5ee72	1	5524fead-8510-4189-91a2-ac7d39675ece	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
e3ce1cec-8555-4231-a53e-68c86629c2a3	3bbc5d6b-70f5-4218-bc38-de20f1cf4b73	1	5524fead-8510-4189-91a2-ac7d39675ece	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
5febd46f-8a41-413a-b7fc-33ca6194fea9	49e5655b-f23e-4c54-ad63-9cfe43c4fa1a	1	b0113ae4-988a-4010-a1cf-f72572ea68fb	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
4b8f1d21-14e4-4b20-9073-00b6347735ce	49e5655b-f23e-4c54-ad63-9cfe43c4fa1a	2	b0113ae4-988a-4010-a1cf-f72572ea68fb	\N	\N	\N	\N	COMERCIAL	Etapa 2 importada
ec7e60b6-edf4-4c5d-aa63-0af51356d16a	015d8a13-b003-4ddd-aa8b-ceb86c9ef01f	1	3b938974-38a9-4b5b-ac50-a88465f7a025	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
ace8496e-a8bc-49e6-96c7-cc247b443abe	3c3b3d46-5b45-4bcb-9e54-9d7030cb9ab6	1	bc86d2a9-3de5-494d-91aa-207e2eadbe81	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
09c8bc5e-e340-47a1-ba5b-06ed50ffde2a	3c3b3d46-5b45-4bcb-9e54-9d7030cb9ab6	2	bc86d2a9-3de5-494d-91aa-207e2eadbe81	\N	\N	\N	\N	COMERCIAL	Etapa 2 importada
2b178606-870d-466f-a063-da3b11172a93	3c3b3d46-5b45-4bcb-9e54-9d7030cb9ab6	3	bc86d2a9-3de5-494d-91aa-207e2eadbe81	\N	\N	\N	\N	COMERCIAL	Etapa 3 importada
8acd530a-7206-4e80-b98c-286ff3558a54	3c3b3d46-5b45-4bcb-9e54-9d7030cb9ab6	4	bc86d2a9-3de5-494d-91aa-207e2eadbe81	\N	\N	\N	\N	COMERCIAL	Etapa 4 importada
a7dea16a-4f31-48fd-adf7-ab5d2756293b	69829eb3-6e89-4777-96c1-27ca6ceb3102	1	bc86d2a9-3de5-494d-91aa-207e2eadbe81	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
712394d2-6557-442d-b64d-aa35d0d826ff	948e77d9-9fc1-4856-8d1f-b6ddd2a05a87	1	bc86d2a9-3de5-494d-91aa-207e2eadbe81	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
f63eda88-c98c-41e1-879b-432605f87f1c	3876b93f-8552-4cc8-8e71-c15d64a4f323	1	1c1f245c-1079-42a0-a6a8-1db4ac5845d4	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
92293102-1899-4032-9391-ec6a3ee2181e	266a7a5b-f577-4564-8b75-310122576126	1	bc86d2a9-3de5-494d-91aa-207e2eadbe81	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
d606cc06-75a3-48b8-b9d0-8d4a2d0c494b	266a7a5b-f577-4564-8b75-310122576126	2	bc86d2a9-3de5-494d-91aa-207e2eadbe81	\N	\N	\N	\N	COMERCIAL	Etapa 2 importada
7e5b3a69-2b30-4e5c-8538-5001b862aa62	266a7a5b-f577-4564-8b75-310122576126	3	bc86d2a9-3de5-494d-91aa-207e2eadbe81	\N	\N	\N	\N	COMERCIAL	Etapa 3 importada
806519d9-8bf7-444d-9f36-5c79cfedfdb1	266a7a5b-f577-4564-8b75-310122576126	4	bc86d2a9-3de5-494d-91aa-207e2eadbe81	\N	\N	\N	\N	COMERCIAL	Etapa 4 importada
3845defb-88ab-4d8f-98b6-dc8e65068ce9	266a7a5b-f577-4564-8b75-310122576126	5	bc86d2a9-3de5-494d-91aa-207e2eadbe81	\N	\N	\N	\N	COMERCIAL	Etapa 5 importada
0a4deba9-130a-4f19-b564-ca66339d2280	2162635d-b565-4fcb-b404-61d5de99d95d	1	b0113ae4-988a-4010-a1cf-f72572ea68fb	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
43d91c90-ae45-4679-a1c1-3f059be488f9	2162635d-b565-4fcb-b404-61d5de99d95d	2	b0113ae4-988a-4010-a1cf-f72572ea68fb	\N	\N	\N	\N	COMERCIAL	Etapa 2 importada
b181221a-9aaa-4540-a571-14218a70690e	0919bfa7-0558-4b7d-8122-f2caafb08588	1	b0113ae4-988a-4010-a1cf-f72572ea68fb	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
51265918-6ccf-49f9-ae8d-a0a70d7da29b	d84fd437-5160-492a-b8a8-103b5caae44b	1	b0113ae4-988a-4010-a1cf-f72572ea68fb	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
2de88e08-618d-4ae1-ae8d-5a16f9def0f1	00d11d10-4274-470a-b9f5-6315c05d93e8	1	b0113ae4-988a-4010-a1cf-f72572ea68fb	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
2a3adeb8-d8ff-4142-9adf-9a536b9d4ac3	8808f7c4-a7b2-475c-b85b-b68f7efb61b3	1	b0113ae4-988a-4010-a1cf-f72572ea68fb	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
342ab491-7d7f-46ce-ab5b-e0b1ba3fbf42	3e8c5a71-a3ab-4c15-a46d-afdd3c3e7d3c	1	b0113ae4-988a-4010-a1cf-f72572ea68fb	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
0d34986c-f5ce-4831-85c3-fe53b16edba1	3e8c5a71-a3ab-4c15-a46d-afdd3c3e7d3c	2	b0113ae4-988a-4010-a1cf-f72572ea68fb	\N	\N	\N	\N	COMERCIAL	Etapa 2 importada
9f5284d7-6fad-408a-bb42-6c9805f7c0cd	038c26ab-f15d-47c8-b407-bb6826b94d95	1	bc86d2a9-3de5-494d-91aa-207e2eadbe81	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
e290f592-a81e-4cdf-ac29-4577bf1ad95a	038c26ab-f15d-47c8-b407-bb6826b94d95	2	bc86d2a9-3de5-494d-91aa-207e2eadbe81	\N	\N	\N	\N	COMERCIAL	Etapa 2 importada
3b4a3231-badc-4295-bd33-06ace1993929	038c26ab-f15d-47c8-b407-bb6826b94d95	3	bc86d2a9-3de5-494d-91aa-207e2eadbe81	\N	\N	\N	\N	COMERCIAL	Etapa 3 importada
a285b4db-9b29-4209-a91f-eeb9b766ef8f	038c26ab-f15d-47c8-b407-bb6826b94d95	4	bc86d2a9-3de5-494d-91aa-207e2eadbe81	\N	\N	\N	\N	COMERCIAL	Etapa 4 importada
2f9b6ca5-23f1-48bb-80d8-3899e3f4defc	a188071c-1585-4114-870b-1d736d93c06c	1	b0113ae4-988a-4010-a1cf-f72572ea68fb	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
0cac60ef-f76e-4e99-bc3c-92761b492e55	1b59329b-f1fa-4d25-bf45-0eda5c5231bb	1	b0113ae4-988a-4010-a1cf-f72572ea68fb	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
2004a28b-46aa-4eb6-8f64-2f933458ec35	1b59329b-f1fa-4d25-bf45-0eda5c5231bb	2	b0113ae4-988a-4010-a1cf-f72572ea68fb	\N	\N	\N	\N	COMERCIAL	Etapa 2 importada
1cfb3201-e513-4b4a-a7de-5490218b3ce7	1b5f5dd1-4d44-4a96-b9c8-be6d997701cb	1	b0113ae4-988a-4010-a1cf-f72572ea68fb	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
12418022-9b63-4a7c-aeb1-5f11a92890a1	d1328495-407b-4571-9af1-9196a99fd36f	1	bc86d2a9-3de5-494d-91aa-207e2eadbe81	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
8bef971d-cd31-4d49-8149-df067a6970d0	d1328495-407b-4571-9af1-9196a99fd36f	2	bc86d2a9-3de5-494d-91aa-207e2eadbe81	\N	\N	\N	\N	COMERCIAL	Etapa 2 importada
175b6df9-add1-4f10-879f-9cc0bdc334f8	d1328495-407b-4571-9af1-9196a99fd36f	3	bc86d2a9-3de5-494d-91aa-207e2eadbe81	\N	\N	\N	\N	COMERCIAL	Etapa 3 importada
a216dcc2-5300-4806-a4c0-e25ba24f9ed3	0d729d64-4ca8-45da-91dc-db6dcf50f256	1	\N	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
dcb59d8b-810e-4496-bca4-6adb4f7183c6	680df353-e954-4fb7-8456-34b4079b4c0b	1	\N	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
cc5ba4b0-d549-4610-bb0e-aab17b0b73ed	44db0a64-7cda-45d9-a591-d6cbb4043178	1	b0113ae4-988a-4010-a1cf-f72572ea68fb	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
38cd806c-94c9-4c93-b278-6a4bf0b57162	2945cc7f-2aca-4f7c-b266-eb7122fb1444	1	b0113ae4-988a-4010-a1cf-f72572ea68fb	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
343fc41f-b24f-4c2f-92be-7749f718d139	1cf8819c-e930-40e2-9342-2e0c2c48405c	1	bc86d2a9-3de5-494d-91aa-207e2eadbe81	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
e4ecff21-9bf9-43ac-9a6c-f6657b2df2c1	fd608d4a-9691-480c-a66b-7fe2d502004d	1	b0113ae4-988a-4010-a1cf-f72572ea68fb	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
e03818c1-751e-429e-b27e-d1369740d4c6	fd608d4a-9691-480c-a66b-7fe2d502004d	2	b0113ae4-988a-4010-a1cf-f72572ea68fb	\N	\N	\N	\N	COMERCIAL	Etapa 2 importada
df65e538-7de0-4b2e-9b8b-4d82196e676f	fd608d4a-9691-480c-a66b-7fe2d502004d	3	b0113ae4-988a-4010-a1cf-f72572ea68fb	\N	\N	\N	\N	COMERCIAL	Etapa 3 importada
57997455-4699-435b-8e78-69ee4b93b166	fd608d4a-9691-480c-a66b-7fe2d502004d	4	b0113ae4-988a-4010-a1cf-f72572ea68fb	\N	\N	\N	\N	COMERCIAL	Etapa 4 importada
d837ce57-8854-47a9-94eb-183002e6dc2b	de491046-dccf-453f-bbc0-c89860e7764a	1	5524fead-8510-4189-91a2-ac7d39675ece	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
3cbd6018-7b8c-44c4-a9ed-9045ec4263a7	5e442efa-4476-47ab-a7a2-1f81504113a7	1	bc86d2a9-3de5-494d-91aa-207e2eadbe81	\N	\N	2025-07-19 03:00:00+00	2025-08-19 03:00:00+00	COMERCIAL	Etapa 1 importada
979074c7-2798-4b32-866f-79f2c7326e97	1bd372d2-f873-495b-b66a-941067841d1f	1	bc86d2a9-3de5-494d-91aa-207e2eadbe81	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
6f66ad62-7f82-4e0f-9ebf-37eb6fee5066	d368c857-e5ea-4cc6-933b-64ba617c4ac0	1	b0113ae4-988a-4010-a1cf-f72572ea68fb	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
e9176bf0-861a-4ed1-b313-42316f803c61	e5d71da1-4001-4ba6-b121-936a651da2f9	1	b0113ae4-988a-4010-a1cf-f72572ea68fb	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
fc0a021a-913d-46eb-a1e0-506f732128b1	61fe27ee-4898-40f8-98a4-d32e4a2a8536	1	b0113ae4-988a-4010-a1cf-f72572ea68fb	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
f8a55ff8-1f83-4e6e-b289-55d709fa0169	b7426674-3f2c-4a4c-9a4f-e7146d60e410	1	bc86d2a9-3de5-494d-91aa-207e2eadbe81	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
ec0351d8-2c27-4b57-83d8-4a73609736be	b7426674-3f2c-4a4c-9a4f-e7146d60e410	2	bc86d2a9-3de5-494d-91aa-207e2eadbe81	\N	\N	\N	\N	COMERCIAL	Etapa 2 importada
76a71f57-ef0c-40f1-8628-fc378cc2f4b0	b7426674-3f2c-4a4c-9a4f-e7146d60e410	3	bc86d2a9-3de5-494d-91aa-207e2eadbe81	\N	\N	\N	\N	COMERCIAL	Etapa 3 importada
30ced7c0-b36a-4ec6-ac92-6a1030523cb0	481e3865-eace-4520-a915-f584e9355de8	1	f4dfbae3-8a9b-4e7a-acba-439207f86b95	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
868048fd-a4c4-4d09-8d53-172b14a2e714	1198157e-c560-48f8-91b5-88c39657263d	1	b0113ae4-988a-4010-a1cf-f72572ea68fb	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
6d66f65b-563d-4871-8686-af1376dd665c	85982da0-6c28-4603-9a5e-a74e37cca9a7	1	b0113ae4-988a-4010-a1cf-f72572ea68fb	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
84f869f6-9e8b-4ad9-b3fb-e0896f627799	85982da0-6c28-4603-9a5e-a74e37cca9a7	2	b0113ae4-988a-4010-a1cf-f72572ea68fb	\N	\N	\N	\N	COMERCIAL	Etapa 2 importada
ee2fd666-e069-4d35-9fb6-39eb125ee76f	3d5d53e3-d77c-40de-9508-ca70065f8325	1	b0113ae4-988a-4010-a1cf-f72572ea68fb	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
23514a85-4042-4717-b345-afd063801b0b	cd084c95-8409-4338-b00e-99ed8ba0c350	1	b0113ae4-988a-4010-a1cf-f72572ea68fb	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
60f10b65-3cc3-43d4-a319-6e26b6532d1c	5d3763ef-61c7-4470-87b8-be5021a584b7	1	b0113ae4-988a-4010-a1cf-f72572ea68fb	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
568488ec-4135-4036-be87-79921cdd467f	d79f80b8-d3b9-42f5-a574-c840d12cea8c	1	bc86d2a9-3de5-494d-91aa-207e2eadbe81	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
9444a891-96bd-4f54-bdc7-015b90bec453	d79f80b8-d3b9-42f5-a574-c840d12cea8c	2	bc86d2a9-3de5-494d-91aa-207e2eadbe81	\N	\N	\N	\N	COMERCIAL	Etapa 2 importada
b94a984b-9b86-4a62-8fed-adc51b744b01	d79f80b8-d3b9-42f5-a574-c840d12cea8c	3	bc86d2a9-3de5-494d-91aa-207e2eadbe81	\N	\N	\N	\N	COMERCIAL	Etapa 3 importada
e77a9a6f-7dd4-4827-8bde-210d2af8e1ff	d79f80b8-d3b9-42f5-a574-c840d12cea8c	4	bc86d2a9-3de5-494d-91aa-207e2eadbe81	\N	\N	\N	\N	COMERCIAL	Etapa 4 importada
eca2f1e8-2b3d-4ca5-b523-15728f892f23	95bc983e-3238-4a9b-9e19-dc53b73b7f7a	1	b0113ae4-988a-4010-a1cf-f72572ea68fb	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
6b3ebf06-3c00-4093-9762-b867fb1ad205	5735520b-7d2d-4e43-b7b2-acdfe1c69e11	1	b0113ae4-988a-4010-a1cf-f72572ea68fb	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
e9eba53c-9dd0-4077-9cb2-afd7626b57d2	ba84396b-5e22-4bcb-929c-387b034b8a06	1	bc86d2a9-3de5-494d-91aa-207e2eadbe81	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
b3ed9fe5-1104-42e8-977a-b2ef10e4a92e	ba84396b-5e22-4bcb-929c-387b034b8a06	2	bc86d2a9-3de5-494d-91aa-207e2eadbe81	\N	\N	\N	\N	COMERCIAL	Etapa 2 importada
89ec70f4-fcde-45f7-92cb-a468a5bea501	ba84396b-5e22-4bcb-929c-387b034b8a06	3	bc86d2a9-3de5-494d-91aa-207e2eadbe81	\N	\N	\N	\N	COMERCIAL	Etapa 3 importada
c97c3b26-9919-4694-9694-596d07d7779d	ba84396b-5e22-4bcb-929c-387b034b8a06	4	bc86d2a9-3de5-494d-91aa-207e2eadbe81	\N	\N	\N	\N	COMERCIAL	Etapa 4 importada
72a9fa20-cfe7-46b6-83f4-6d3ff92f87d7	d43dbd70-39e1-430c-987b-5dcf959e86f5	1	bc86d2a9-3de5-494d-91aa-207e2eadbe81	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
8fbd2bc1-9e76-4bba-8664-02c53d1c7d44	d43dbd70-39e1-430c-987b-5dcf959e86f5	2	bc86d2a9-3de5-494d-91aa-207e2eadbe81	\N	\N	\N	\N	COMERCIAL	Etapa 2 importada
71ba7eb0-efad-4b05-b16c-e6c4319c3aeb	d43dbd70-39e1-430c-987b-5dcf959e86f5	3	bc86d2a9-3de5-494d-91aa-207e2eadbe81	\N	\N	\N	\N	COMERCIAL	Etapa 3 importada
d5fe4e6e-8dc6-4b77-8754-002480a96396	9995bba3-cbe4-44cd-b6d5-e22223274d62	1	bc86d2a9-3de5-494d-91aa-207e2eadbe81	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
91f13c60-0e2b-4e79-8daf-d2d84793fa12	57385038-9502-41b5-86dd-7ac2eae7a5d1	1	b0113ae4-988a-4010-a1cf-f72572ea68fb	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
74b093ab-708a-4486-ab87-0bb4ffb1c33a	b62ecaa0-fd79-48c8-8569-570fa30e818f	1	b0113ae4-988a-4010-a1cf-f72572ea68fb	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
692ee3d5-7424-4b5b-95bf-2f1b0647682b	a6f84194-71dc-466c-b59c-eab1cbce865d	1	b0113ae4-988a-4010-a1cf-f72572ea68fb	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
411bd93e-ff46-462e-9695-1803c54bcfa2	e88de7bb-0465-4ac8-90d7-bc391de87668	1	b0113ae4-988a-4010-a1cf-f72572ea68fb	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
69b5be3d-8393-4835-9419-ef2a066e86b5	62cc7d5e-a399-40e8-8833-ba833a2d20e4	1	b0113ae4-988a-4010-a1cf-f72572ea68fb	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
2c6b860c-2350-4c12-9479-16b32823b181	2425ece4-d097-489e-bbaa-a8a823f55a21	1	bc86d2a9-3de5-494d-91aa-207e2eadbe81	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
615bb897-aeee-4645-900c-a4dfb62b0155	85c313a1-678c-4a4d-bf67-abe2e1de5228	1	b0113ae4-988a-4010-a1cf-f72572ea68fb	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
dde9902b-1367-4fc7-971e-2f6396559a04	b91c643f-517a-4829-9c38-a2a29b3bca53	1	5524fead-8510-4189-91a2-ac7d39675ece	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
bae53874-b869-4764-b79a-b28e6c2519fb	1c553365-664b-4fcd-9300-a310c35fc7ad	1	f4dfbae3-8a9b-4e7a-acba-439207f86b95	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
6d2a3b4b-d29d-4071-876c-38324be54068	ef4ae89d-c2dc-459c-86a9-cdff84f35abe	1	bc86d2a9-3de5-494d-91aa-207e2eadbe81	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
09a1cb01-2b1b-404d-952b-e8a78978d711	dfaa58d2-5af4-4f37-b45c-a32b1dfaa7a3	1	b0113ae4-988a-4010-a1cf-f72572ea68fb	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
2da10c7d-4fff-4a17-a203-ffff747d834b	463b364f-33e2-4d87-83ee-b81450c72c57	1	f4dfbae3-8a9b-4e7a-acba-439207f86b95	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
487292bd-3796-4f95-86ac-728bf34f7d57	62b60e1e-af54-47c2-90eb-c6a1da894a67	1	f4dfbae3-8a9b-4e7a-acba-439207f86b95	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
3c2c9225-f99b-42ee-b7a6-880750153f54	4b8a9636-1f50-4937-9173-336dff78d13d	1	f4dfbae3-8a9b-4e7a-acba-439207f86b95	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
8ec99d2c-3e35-435b-87b6-d93767ddbd28	2450ccd1-2512-40e9-8c62-f2b4db5236be	1	f4dfbae3-8a9b-4e7a-acba-439207f86b95	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
54a0cd21-f671-44e7-b98b-1f1e3c64efd0	01e2eed6-b176-4e5e-a9f6-6b150a7c4f91	1	1c1f245c-1079-42a0-a6a8-1db4ac5845d4	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
36e814a7-42de-4c67-a37f-366923ce7afa	522e84d3-cfd8-4209-b2e9-b7d7813d69d6	1	b0113ae4-988a-4010-a1cf-f72572ea68fb	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
57516fda-833e-47c7-b54e-82c0d82ba7ba	0832ca2f-72dd-46ec-bf85-58ad0aeb5ee2	1	1c1f245c-1079-42a0-a6a8-1db4ac5845d4	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
5c2e28c5-168b-42b4-b6d5-7ca77da15615	99ce6f70-8be7-4592-871d-a313f8a1def8	1	1c1f245c-1079-42a0-a6a8-1db4ac5845d4	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
3a573dd3-c97f-43cc-82c9-70b79e4a0f1c	9fabf937-de6c-4586-bbe1-d68fa3fd1046	1	bc86d2a9-3de5-494d-91aa-207e2eadbe81	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
78796cee-9ad3-4956-b780-36d1bedeae55	9fabf937-de6c-4586-bbe1-d68fa3fd1046	2	bc86d2a9-3de5-494d-91aa-207e2eadbe81	\N	\N	\N	\N	COMERCIAL	Etapa 2 importada
047629dd-2ad2-4594-a306-ae7b6186efaa	9fabf937-de6c-4586-bbe1-d68fa3fd1046	3	bc86d2a9-3de5-494d-91aa-207e2eadbe81	\N	\N	\N	\N	COMERCIAL	Etapa 3 importada
b7787f43-7bfc-47b7-a9ab-33cf3fd9d5af	9fabf937-de6c-4586-bbe1-d68fa3fd1046	4	bc86d2a9-3de5-494d-91aa-207e2eadbe81	\N	\N	\N	\N	COMERCIAL	Etapa 4 importada
754fd613-4afb-406b-99ae-3f338839e6dd	9fabf937-de6c-4586-bbe1-d68fa3fd1046	5	bc86d2a9-3de5-494d-91aa-207e2eadbe81	\N	\N	\N	\N	COMERCIAL	Etapa 5 importada
91902f3a-9c1a-4e61-a912-4fa44e62c2ef	9fabf937-de6c-4586-bbe1-d68fa3fd1046	6	bc86d2a9-3de5-494d-91aa-207e2eadbe81	\N	\N	\N	\N	COMERCIAL	Etapa 6 importada
9e461da8-7476-4448-83dd-90c94afd0963	f061bef3-492a-453e-b4ac-bda56b649be0	1	bc86d2a9-3de5-494d-91aa-207e2eadbe81	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
bfd762f1-382c-499d-a3c9-553d50dd8845	c73e2490-d4b3-4782-b40d-cfea53c2fbe0	1	f4dfbae3-8a9b-4e7a-acba-439207f86b95	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
5319c01b-11e7-41bd-bc60-1efa37489742	a8130766-0d49-41e8-aae2-04c262cdefc1	1	bc86d2a9-3de5-494d-91aa-207e2eadbe81	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
b0e053eb-29bd-47df-9cd7-5f143d72bdf4	a8130766-0d49-41e8-aae2-04c262cdefc1	2	bc86d2a9-3de5-494d-91aa-207e2eadbe81	\N	\N	\N	\N	COMERCIAL	Etapa 2 importada
f085cceb-4f74-4c19-9bd4-9f188272b814	a8130766-0d49-41e8-aae2-04c262cdefc1	3	bc86d2a9-3de5-494d-91aa-207e2eadbe81	\N	\N	\N	\N	COMERCIAL	Etapa 3 importada
463f000f-a220-4f17-a69e-f141aee91fc5	146597b1-3b39-4d7b-b3b0-724bb85ed86d	1	5524fead-8510-4189-91a2-ac7d39675ece	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
d4961ac6-36db-40c6-92fb-82ffa0fcdb95	1cb8f85f-72e1-4126-a81f-605eab9ad6c6	1	f4dfbae3-8a9b-4e7a-acba-439207f86b95	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
d8664715-5307-4b4e-9fd5-eb4d9e27384a	84b85110-8a86-4ab5-b80c-5134f0830829	1	1c1f245c-1079-42a0-a6a8-1db4ac5845d4	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
4122fe2e-5a94-4ed9-8761-aa564996e518	e84d19de-5da7-4519-9cf5-910dd890b329	1	5524fead-8510-4189-91a2-ac7d39675ece	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
349c03e4-a01f-4aa9-8bde-71f2c6534780	e5e47077-b892-4a42-bb7e-f45048793af0	1	bc86d2a9-3de5-494d-91aa-207e2eadbe81	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
1e3d7199-65ca-41ec-a1df-a01644ded410	e5e47077-b892-4a42-bb7e-f45048793af0	2	bc86d2a9-3de5-494d-91aa-207e2eadbe81	\N	\N	\N	\N	COMERCIAL	Etapa 2 importada
19f8f34d-5ab8-44ca-a536-46a210333a38	e5e47077-b892-4a42-bb7e-f45048793af0	3	bc86d2a9-3de5-494d-91aa-207e2eadbe81	\N	\N	\N	\N	COMERCIAL	Etapa 3 importada
5e76f1f8-fc8e-4f7a-ae1d-da561810f038	e5e47077-b892-4a42-bb7e-f45048793af0	4	bc86d2a9-3de5-494d-91aa-207e2eadbe81	\N	\N	\N	\N	COMERCIAL	Etapa 4 importada
0abcbb39-c336-4127-bf31-8b2d32af53ab	69405fcc-9a8e-42d2-8574-6404373393a6	1	bc86d2a9-3de5-494d-91aa-207e2eadbe81	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
837e5338-c908-4b07-8562-f2b7653f158d	35e9cc11-ace6-4638-b0e1-eb36f0d896fe	1	bc86d2a9-3de5-494d-91aa-207e2eadbe81	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
999e61df-8857-4990-8870-3556bbc2bd4a	35e9cc11-ace6-4638-b0e1-eb36f0d896fe	2	bc86d2a9-3de5-494d-91aa-207e2eadbe81	\N	\N	\N	\N	COMERCIAL	Etapa 2 importada
de9adf82-823c-4a9c-bb46-fd894c1fa63c	35e9cc11-ace6-4638-b0e1-eb36f0d896fe	3	bc86d2a9-3de5-494d-91aa-207e2eadbe81	\N	\N	\N	\N	COMERCIAL	Etapa 3 importada
2ad99bfa-3f42-4289-9ef2-e03ac84dbb86	35e9cc11-ace6-4638-b0e1-eb36f0d896fe	4	bc86d2a9-3de5-494d-91aa-207e2eadbe81	\N	\N	\N	\N	COMERCIAL	Etapa 4 importada
cd61a02d-1465-4106-ba28-e65f48463746	5601b2a1-cd89-442d-8254-98fea8c1824f	1	\N	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
d1fdd43a-ef0d-4e3f-80a2-a48303fc2685	5769495e-7955-4b1a-ad82-62ea28c617eb	1	5524fead-8510-4189-91a2-ac7d39675ece	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
2c7280f2-6bbb-4adc-972f-f539bd409c63	282918f1-73ef-4b02-b0ec-1762bb379527	1	bc86d2a9-3de5-494d-91aa-207e2eadbe81	\N	\N	\N	\N	COMERCIAL	Etapa 1 importada
\.


--
-- Data for Name: mareas_etapas_observadores; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mareas_etapas_observadores (id, id_etapa, id_observador, rol, es_designado) FROM stdin;
a0538e97-e727-4401-97a1-7a7681b5a70e	117cc1e8-ff33-45be-9706-9d50ef00e0dc	8f04654d-a7bf-4a09-bf80-b5961dcc8399	PRINCIPAL	t
19b0bcc3-4ee4-4aa1-ac05-1ae80046d11a	1eeeef47-bf5b-4cd4-8948-90c24cdfa77b	0b9a4a10-a144-4387-84ce-e5ededfd4100	PRINCIPAL	t
15dbba08-4926-4c7c-9733-3e31e503035a	f719cffe-893c-4d3c-9259-2677be8f50ab	ec4efd97-0b3e-4bfd-9519-3c4048625df9	PRINCIPAL	t
92320df6-5d32-4580-817a-63e445a67e7f	c8f5f44f-89e2-4b2b-b3b9-307e2e8e40ce	5cd79891-c469-4b7c-8cae-df0ccc5587b6	PRINCIPAL	t
64b525ac-93c6-4abc-ab36-622d6a9996ff	4e8c2299-63ba-4d01-8aab-a7131c877d72	94c71dc6-0ae5-4e57-ba53-84d292db1856	PRINCIPAL	t
263d648d-f235-4d53-bb09-5bc80d73e11f	6a22a015-ed79-4508-a2bc-3133bb932abf	e504b07e-916b-4670-a17c-0a6ce13daf4e	PRINCIPAL	t
5c8b190b-7844-4d99-bb80-a018f0be475e	bea54021-4fad-4afe-b8d2-39cc8810ff16	ba45cd4d-cf7b-4948-b24c-e56aea99b66e	PRINCIPAL	t
83556880-d731-4e90-a726-5f37846014d5	c69194e3-67f7-4e3b-8b91-d87f5be41496	67b3e5c2-687f-4a90-a8cf-e3bf89e25f00	PRINCIPAL	t
fc6e3fb7-e585-4766-9bec-11393069e651	9c069fcf-c8d4-48cd-849f-226154f9c3f6	67b3e5c2-687f-4a90-a8cf-e3bf89e25f00	PRINCIPAL	t
d02525d9-9132-41fe-81e2-4e03ef0f9c6c	c18daad2-6379-497b-8d02-e0888c93f03c	67b3e5c2-687f-4a90-a8cf-e3bf89e25f00	PRINCIPAL	t
9fb5da6e-0411-40ce-9590-78a76bacd955	7ea9c8fc-71b9-4e0a-b748-e7b18379f996	226de0d1-ea56-4c31-9937-d65b2401300f	PRINCIPAL	t
2fded002-96df-4cac-ba1f-c2e65a70a6ea	27792e74-b3f8-4fd5-99cc-c03cd9a7f14c	d947086c-8d9e-4dbc-862c-83012ebf47d9	PRINCIPAL	t
45b32586-c90e-459d-b3f6-60576993d78b	9f088ac8-2311-4e9e-93c6-a0eed5619df5	e483342f-b74f-420a-84b4-9cfa31dbacec	PRINCIPAL	t
d00556f7-f433-4af2-b479-7b2790409b20	a2d95f19-effd-4363-a89e-1198ef9f9b70	aecbca5b-79e1-4bd7-b4bd-fa0f165b6fde	PRINCIPAL	t
4eeeffeb-678a-42fe-ada5-f4dcff4699c1	2013bda4-bb31-48f0-94c2-1d9bab84e5c4	9a453f6d-1fee-4a05-8aec-bc93fab5ec47	PRINCIPAL	t
33820c27-45ee-4730-9639-0520bd06b0c2	fd26a162-14a8-41aa-880c-a770b9b30726	81d7c1bc-4350-429a-8d54-95a2bcddfde4	PRINCIPAL	t
573881f9-6ed7-42c4-a264-9315ac0ae423	f68e82ba-fb77-4c97-b310-b44ef0a48baa	386e87a1-3845-4435-9c10-68a84ffb0f32	PRINCIPAL	t
3083a2de-8305-4e37-916e-72812827eff6	7695be61-3096-4c9e-be8c-444dcf90aaf7	386e87a1-3845-4435-9c10-68a84ffb0f32	PRINCIPAL	t
796e39f3-fd0b-4757-afbe-01d73a7951a7	01e575af-e0e6-4d15-9fe9-e79d6074f720	386e87a1-3845-4435-9c10-68a84ffb0f32	PRINCIPAL	t
04360881-032a-4a63-8c9e-5e04acb0397d	29041fe0-2163-4f0f-a998-ebc15d263dae	386e87a1-3845-4435-9c10-68a84ffb0f32	PRINCIPAL	t
7862f04a-36f7-4e01-87dc-45d934b3164b	d33d7156-5141-46f3-a75c-3308b2c4ead3	f69c66a3-934b-4e74-8f9d-af12a1feb18a	PRINCIPAL	t
7e8add13-f2fe-4042-a60d-1c8774a80e9d	24ae52c7-3523-4d09-bf4f-a0708acce3ab	eeac2bca-a24c-4458-b820-9c5a9b49cdcb	PRINCIPAL	t
24fa2283-993d-4bfe-bc74-b65883abca0f	5bfcdbbb-102d-4bd7-93d1-dd94e19779f6	6e358b63-2675-42b3-83ba-8cbb14031224	PRINCIPAL	t
93639f88-c714-4835-bf2b-7f2702fdcb42	bd3a43c3-9dcc-4066-9de7-e23b9ee04ad5	dec0ebe8-ed58-41e3-882b-56317c66194e	PRINCIPAL	t
63557290-1da9-4e63-9930-6db9b033f0bb	04ddf0be-af7c-43f4-ac0d-5569ae0f6773	e504b07e-916b-4670-a17c-0a6ce13daf4e	PRINCIPAL	t
e50a04d3-92e5-47b3-8f15-5adb8359b474	51bae0a9-9b6c-49db-a734-291d6feb6e5b	01f4a0f8-05f3-4e74-a235-a302423a3971	PRINCIPAL	t
494c0465-2a07-4ad1-82d8-912865318239	7323d925-1f18-45a5-9a72-d70fc49cca83	45a41838-d70a-4bc7-809c-1b576c77b64a	PRINCIPAL	t
e20e4fee-632f-4f3e-9eef-327cf0388c66	5fccadc5-ef11-4663-a417-54ed3443f69b	eeac2bca-a24c-4458-b820-9c5a9b49cdcb	PRINCIPAL	t
5e31de45-c2ba-4d3b-92d3-91de113cc1b7	17da7e83-3ba2-4da6-856a-b1987c4f588a	eeac2bca-a24c-4458-b820-9c5a9b49cdcb	PRINCIPAL	t
01f573ee-d49c-44ac-8653-9e4f665babcf	f586b64b-28cd-4030-8d32-f62cfb388851	0b9a4a10-a144-4387-84ce-e5ededfd4100	PRINCIPAL	t
4a4f3f03-8b00-4e0e-9429-41e8ac8e34a7	140694e7-1a20-4903-8eb0-4d24a3bd3bda	35917453-f41b-4e8d-8e75-6a889c9aea81	PRINCIPAL	t
8de40c34-cccd-4003-83b8-1ebefce7a120	79fe7f72-01aa-472f-9cc8-65e0ce5769f3	e1145258-fcce-4b3c-8f2a-50d94400b405	PRINCIPAL	t
3682c0cd-4f9c-4591-8048-02052c00c264	2b23a09e-003d-411c-abec-dc5db9d16dfd	c408015c-e534-43ef-9b05-3073f5e79b90	PRINCIPAL	t
c8ef6186-fd2e-4058-8f65-05ebe2b7a2d1	44e1a05b-5edd-4985-89b1-9cda629143fd	bbae4d55-b474-4190-8482-b3f41534a682	PRINCIPAL	t
37e89b91-d4c8-4142-8255-e000c5a2b4aa	d8442fe7-4223-4cd6-9487-490a07c14221	7a8621e4-12e7-4828-9e96-0a39cf136820	PRINCIPAL	t
7a8a7acc-2c7b-4522-8054-e1a73ff410fb	2f1b3a7d-2a5c-496c-965e-5b2b2c185939	daa8ef1e-481e-4b97-a071-56141bac9d06	PRINCIPAL	t
d0cc5b43-7a31-412b-a8a2-967ef97b95cf	37e3ba4b-de68-4d0d-8ec0-abecbe77a274	1d803758-7f28-415d-9b20-dca5fa459f1c	PRINCIPAL	t
7a2991df-f81b-467e-9509-cfb9b1e1b9e0	267fa383-42a7-450b-8e59-d338aae99fae	414b0c66-0031-4403-9e75-bbf02e820c58	PRINCIPAL	t
b4e277c8-c17d-4317-893a-6880c8e5497a	ad36ce69-b636-4a47-9a64-5f041608f898	ba45cd4d-cf7b-4948-b24c-e56aea99b66e	PRINCIPAL	t
f1197cb6-39d9-4d3d-bbb5-0f6f8e3e7b80	064ed822-3654-4095-8a26-2560a8653ee7	e483342f-b74f-420a-84b4-9cfa31dbacec	PRINCIPAL	t
ade7ce1e-bfb3-4d33-b524-32d1317e2ab3	b674b883-328f-4245-99e3-c47ea0c4767a	aecbca5b-79e1-4bd7-b4bd-fa0f165b6fde	PRINCIPAL	t
e4e58316-f334-4b27-9c1d-ffadf0fdef6d	946005ac-7400-432e-8170-c3d51b3ec430	fe96642e-1c00-452f-917f-ca212b976e2d	PRINCIPAL	t
71f03a7f-dd8f-4a40-b078-c759e0b372a8	ed92cf56-46cc-48fe-92a5-c7a5f88f1de0	226de0d1-ea56-4c31-9937-d65b2401300f	PRINCIPAL	t
db602f68-07e3-43c1-a421-060249f5953a	c19f4fb6-f537-4558-876e-73cde4bce3b7	e881013d-b3f0-498a-88a1-ee9621e34f87	PRINCIPAL	t
3ec32ece-291b-4509-ade8-8ed6288b1022	c4644045-3bb6-406a-8b21-45a4bddbc876	f69c66a3-934b-4e74-8f9d-af12a1feb18a	PRINCIPAL	t
2f502e87-68da-4fb6-bdfe-e186d92c7e8d	0f634f43-ba95-4d11-a304-e40a7aab443e	42b9e9a1-ae10-48dc-a782-ca47465644fe	PRINCIPAL	t
6218a7b7-007a-4689-9841-8fb289585ef8	66cefd50-b92e-4eac-938a-ddda9eb26aed	cbb02cfb-559e-4348-a494-7b3ee41f76b2	PRINCIPAL	t
2c805fd3-ec07-46ed-a0f1-d467b7d90600	15f45bf0-8024-4eb3-9deb-ec369f3dedeb	cbb02cfb-559e-4348-a494-7b3ee41f76b2	PRINCIPAL	t
5a17af42-7c56-4426-8544-8b844fa3f590	2ea51b2c-1443-452b-ae25-a6bcb9348af1	192a2eee-9ee7-4ccc-97fd-71c00fdbb3a9	PRINCIPAL	t
837a5048-2dc5-4a23-aeb1-9e4146cd2682	10548904-af82-4fc9-993b-4295ac240d1c	192a2eee-9ee7-4ccc-97fd-71c00fdbb3a9	PRINCIPAL	t
0e57f821-8fe5-4a6a-8da0-816ee681e5f7	28479828-d0cc-44e0-b087-dc8297db96b0	8f04654d-a7bf-4a09-bf80-b5961dcc8399	PRINCIPAL	t
4a759c57-472a-4e55-acda-e2d620499093	0b79b9d0-5e42-4ab6-998e-f96901064cec	8f04654d-a7bf-4a09-bf80-b5961dcc8399	PRINCIPAL	t
612701bc-24d3-4359-901d-2c4fec885d9a	3398c176-a4f3-4f5b-8861-ec5ce26756bf	ba45cd4d-cf7b-4948-b24c-e56aea99b66e	PRINCIPAL	t
80c06019-268b-4304-8765-070f21105cf7	8ffc4857-3d7d-4bd8-8d20-4323acc328f2	ba45cd4d-cf7b-4948-b24c-e56aea99b66e	PRINCIPAL	t
62caa354-c700-4454-8de6-e23bc434e4be	2fa18909-aef0-46d5-9445-0982a376cfae	9a453f6d-1fee-4a05-8aec-bc93fab5ec47	PRINCIPAL	t
9d569f08-b808-486b-b49d-383044cb76d2	ec9120b5-43a9-4439-9db2-0198c2a39ae2	9a453f6d-1fee-4a05-8aec-bc93fab5ec47	PRINCIPAL	t
48804edd-ec96-4d94-959b-7ac7dd3a7521	b84a17d4-18af-411c-bffd-f4d49a9c4b1d	e6005312-85de-4319-8ca1-dbceaa15915c	PRINCIPAL	t
cdd784f2-7770-481d-85a1-4420587f1dc0	8c15fc13-a42e-4a15-a882-42f3b6635214	c94e6db1-32bf-47da-969b-7e4289aba5ea	PRINCIPAL	t
a0576184-ee1e-4e1e-8dad-cd2e3a128896	7d331713-bec1-4554-a1d6-c60dd9cde967	5cd79891-c469-4b7c-8cae-df0ccc5587b6	PRINCIPAL	t
56f0e426-f85a-47a2-8890-494c31212a73	727daf77-7bd6-4ff1-af64-fa41bfb1f33a	35917453-f41b-4e8d-8e75-6a889c9aea81	PRINCIPAL	t
6b56f7d2-b61e-443c-abae-abafca62f34e	d8414b25-77df-40ce-808a-dd451af3886a	d947086c-8d9e-4dbc-862c-83012ebf47d9	PRINCIPAL	t
989bbf0f-d5ad-418a-aba8-4a64754244eb	58e4ebe5-cc2f-40b9-baaa-8b0b5ab41892	f9f703d5-ea13-4725-8d1b-24343e9a735a	PRINCIPAL	t
925dbf82-df9e-48ee-adbb-325bf580682c	8eca5f87-ded1-4478-8e6a-95ba5d70bc24	dec0ebe8-ed58-41e3-882b-56317c66194e	PRINCIPAL	t
0e6dea58-ecb1-42f7-8d7c-e2adac291fc0	4a1f979d-8128-4cbd-9be0-24202cabf210	e881013d-b3f0-498a-88a1-ee9621e34f87	PRINCIPAL	t
c5550ec6-e0c6-4a4d-a56d-447dc4be82ed	cc527d87-8fa5-414d-a61e-7d1d96fc5ff0	0b9a4a10-a144-4387-84ce-e5ededfd4100	PRINCIPAL	t
213d84d5-2786-41d0-a54d-cc7962df9a39	55010ed7-84f2-4b2d-b6b1-efff45395f10	94c71dc6-0ae5-4e57-ba53-84d292db1856	PRINCIPAL	t
ea32f371-16d2-410c-9557-5468f01831f7	d2f0256c-c844-4a94-a7c4-554828e74dc9	9a453f6d-1fee-4a05-8aec-bc93fab5ec47	PRINCIPAL	t
70b6e769-1a35-4c60-a826-e1fad1352681	a1fb1174-3a80-49dd-a8c5-1f17bb7ec273	42b9e9a1-ae10-48dc-a782-ca47465644fe	PRINCIPAL	t
19dfad45-b21d-497b-accd-e8b711abd37a	77807950-d031-45cd-838e-30285517c23b	6e358b63-2675-42b3-83ba-8cbb14031224	PRINCIPAL	t
da0aa199-181d-4b7f-9586-bef70207dc54	d816dfa0-e286-420d-97d0-b0dc981a6f7c	ec4efd97-0b3e-4bfd-9519-3c4048625df9	PRINCIPAL	t
f8cf12d7-88df-49a8-8f81-71061f2c0ba5	7676cdc2-37d9-424f-a5fa-f5f6a41d6bd6	192a2eee-9ee7-4ccc-97fd-71c00fdbb3a9	PRINCIPAL	t
b438fd3c-be89-4533-8040-f117d2559b8f	3f0a8db3-9bbf-410c-bd97-02d15871c93e	ba45cd4d-cf7b-4948-b24c-e56aea99b66e	PRINCIPAL	t
1177ded4-fa08-47b8-9fdd-9c4ac20ec3e1	ba312134-bb0f-42f6-86ff-8a6686544427	cbb02cfb-559e-4348-a494-7b3ee41f76b2	PRINCIPAL	t
e273af43-9ec1-4a9a-9d9f-1198845b7cf1	26f6c105-69fc-419b-b853-4a35b045a67f	cbb02cfb-559e-4348-a494-7b3ee41f76b2	PRINCIPAL	t
c71631c0-83e1-4620-a5a8-040e3cb51ed7	8b092b82-161b-403a-8fac-b000b357e07d	cbb02cfb-559e-4348-a494-7b3ee41f76b2	PRINCIPAL	t
6ccce202-5ce0-48a9-b2a0-70c79803ea1d	3f62d2a7-9426-487f-9f3d-a9e416898201	386e87a1-3845-4435-9c10-68a84ffb0f32	PRINCIPAL	t
05b6bb1f-4d45-4ac1-8467-03a9b931a91c	73e5f1ba-8e88-4250-88f0-6d144d5e5183	7a8621e4-12e7-4828-9e96-0a39cf136820	PRINCIPAL	t
fd9ea1fe-5c1d-4e1d-8cd9-046bd28fc325	a66f0b73-eac3-4d6c-80fa-c0a0cc1188e3	7a8621e4-12e7-4828-9e96-0a39cf136820	PRINCIPAL	t
1a8678be-072a-479a-80c3-72119b3513bb	36284a6e-b12f-4b02-aafa-28d93df8f0db	7a8621e4-12e7-4828-9e96-0a39cf136820	PRINCIPAL	t
73faa04c-d5ea-4e98-981f-2775a94437d6	bf54e092-2acf-41ba-987a-e7508c91c798	8f04654d-a7bf-4a09-bf80-b5961dcc8399	PRINCIPAL	t
dc37d012-59de-470a-8605-b546a614d8d5	9cec5c70-abb0-409a-bcde-0662de916964	8f04654d-a7bf-4a09-bf80-b5961dcc8399	PRINCIPAL	t
7d49cbe9-817c-4a2b-a959-fbe894e3f980	8ef0e680-7312-43f7-be3f-0697d59ee5d7	bbae4d55-b474-4190-8482-b3f41534a682	PRINCIPAL	t
8745336c-cfa5-4e05-9a56-a757b719d781	f77cb7f2-f319-4177-b412-259d10a38cf9	67b3e5c2-687f-4a90-a8cf-e3bf89e25f00	PRINCIPAL	t
2125b291-9fc6-439b-8f39-07ccd4d70933	ea4e6e4f-9b34-46a1-9307-8cb5a6007b20	67b3e5c2-687f-4a90-a8cf-e3bf89e25f00	PRINCIPAL	t
077c2007-7b20-40af-a829-7df5bafcf280	f628cd6c-f402-4a72-9b3e-2a943427d22c	67b3e5c2-687f-4a90-a8cf-e3bf89e25f00	PRINCIPAL	t
997279c7-aa86-4dba-b2aa-42a777edc849	82a3940e-016d-4e3d-8ebc-6a68be4731ad	35917453-f41b-4e8d-8e75-6a889c9aea81	PRINCIPAL	t
f4e0d0a6-ea72-4f76-8d53-0b7c83b3400c	ef9984d5-6fe4-41b2-b867-d254569381aa	3d3ea7ed-0af4-4e46-8b18-d95970f9a95a	PRINCIPAL	t
3d89e6b3-1db9-4a98-b268-5464e8074dd8	6fc0e506-7a06-4798-ade9-e6e928e16095	3d3ea7ed-0af4-4e46-8b18-d95970f9a95a	PRINCIPAL	t
48252f2f-ab26-4723-a93b-df1b0d15d310	e84d632f-5fc8-4504-b4d2-a45f6ae0faaa	b58c3f79-5f47-40dd-a3db-4fbd5b020e4e	PRINCIPAL	t
28f7b9e4-af76-4709-a48f-ca3b7f91adcf	344f2822-8054-45cd-b390-28d8dc4a734e	0e7cee67-f8cd-4035-be66-240e6d411fb3	PRINCIPAL	t
939643c0-73d7-4ee1-9960-264a19d09aab	b35c5d5e-3748-4461-b479-db79638cbc3b	e504b07e-916b-4670-a17c-0a6ce13daf4e	PRINCIPAL	t
67d6f455-3899-4ff1-badd-3d8a2fb8eeff	3670fca4-2b56-45f5-9d45-7c1befc7bfb8	e504b07e-916b-4670-a17c-0a6ce13daf4e	PRINCIPAL	t
4ac72e00-d0e6-417f-96d1-3bdf1b2013f6	7e76fb92-e799-4442-af70-d92ce972ca25	e504b07e-916b-4670-a17c-0a6ce13daf4e	PRINCIPAL	t
0b17c8fb-b3f5-4dd7-9cd8-b77539157fd7	0b314bc7-0ba5-4099-841d-02bde61362a5	5cd79891-c469-4b7c-8cae-df0ccc5587b6	PRINCIPAL	t
b398138e-b57d-47d1-9e83-ea80f23a1d03	81210f7c-a16a-4dcf-bf11-4c2bd0e4d558	eeac2bca-a24c-4458-b820-9c5a9b49cdcb	PRINCIPAL	t
c9f13452-8951-462c-bc35-a3362c964b56	930d61b4-10f8-49b3-aedb-ff97d91c72a4	aecbca5b-79e1-4bd7-b4bd-fa0f165b6fde	PRINCIPAL	t
306611ec-0681-4011-a1db-72dc009c343f	c1229a95-0984-4460-8b2d-4220fdfb0de1	e6005312-85de-4319-8ca1-dbceaa15915c	PRINCIPAL	t
54db3d25-e92e-4b60-bc26-7b2d36f615a0	1f81322e-8c0d-4c6f-8028-f93fa0a49834	4f04d022-95d2-42c6-aeb2-2b236c45780f	PRINCIPAL	t
0cb607e6-8da9-4bf3-b4df-3b7810253848	e6c82153-cc7b-4c0e-8df3-75c757fcb84e	ae9b52fe-650a-4573-a465-8674bbd10dbb	PRINCIPAL	t
f723c288-b49c-4ec1-923e-794e725b64ea	91218403-03b4-4f41-9e66-e32afb59f936	414b0c66-0031-4403-9e75-bbf02e820c58	PRINCIPAL	t
f154e8b9-eb87-4a5a-8d57-72dee54712c3	3560884f-acfd-441f-9e91-7e6f51c36d79	c94e6db1-32bf-47da-969b-7e4289aba5ea	PRINCIPAL	t
c4442a3d-6af8-4b92-bb3a-58b7178833aa	e79d65f7-deef-4043-a539-24007398ff88	f69c66a3-934b-4e74-8f9d-af12a1feb18a	PRINCIPAL	t
dfa24d74-c788-4e35-a296-75cbeb887d93	20d43522-89c6-4047-b52f-7bc3826d9043	0a3e2f51-fa56-40e8-a9d7-b08bebb8f381	PRINCIPAL	t
c021d5a3-72e4-43f1-b90b-4955cd46e927	c6d34f31-f8dc-4461-aa0d-30c3ccc09530	81d7c1bc-4350-429a-8d54-95a2bcddfde4	PRINCIPAL	t
d2bb8d57-7ae2-4bb4-83b4-64a185e8b12d	6f4cc54c-7062-4c9c-871f-213933daa495	fe96642e-1c00-452f-917f-ca212b976e2d	PRINCIPAL	t
200b9f1f-3de8-45fe-9404-d7611a0cb6f6	4a568ae0-98f6-4250-940b-a0298f1396d1	0b9a4a10-a144-4387-84ce-e5ededfd4100	PRINCIPAL	t
2027b86d-5a9f-440f-a825-a6020fa495d5	5b19633f-e446-4478-afd0-cf722c352832	226de0d1-ea56-4c31-9937-d65b2401300f	PRINCIPAL	t
4ab315d9-2f08-4673-9aa4-98d2f295631d	e3ce1cec-8555-4231-a53e-68c86629c2a3	d947086c-8d9e-4dbc-862c-83012ebf47d9	PRINCIPAL	t
193913df-ac28-468b-87f9-6bb9ee4439df	5febd46f-8a41-413a-b7fc-33ca6194fea9	cbb02cfb-559e-4348-a494-7b3ee41f76b2	PRINCIPAL	t
d69582f5-c6aa-4b8a-b65a-6c10954a22c6	4b8f1d21-14e4-4b20-9073-00b6347735ce	cbb02cfb-559e-4348-a494-7b3ee41f76b2	PRINCIPAL	t
4e28afb5-8461-40a5-82c6-0ba0a712f1f4	ec7e60b6-edf4-4c5d-aa63-0af51356d16a	dec0ebe8-ed58-41e3-882b-56317c66194e	PRINCIPAL	t
35ec67bb-8fcf-44a7-a036-25792e922c2e	ace8496e-a8bc-49e6-96c7-cc247b443abe	e504b07e-916b-4670-a17c-0a6ce13daf4e	PRINCIPAL	t
322c7cd1-564e-4323-b9cf-f58f06bb9e75	09c8bc5e-e340-47a1-ba5b-06ed50ffde2a	e504b07e-916b-4670-a17c-0a6ce13daf4e	PRINCIPAL	t
61bb8252-8e5a-4a91-8d00-c5b3f89cbdc3	2b178606-870d-466f-a063-da3b11172a93	e504b07e-916b-4670-a17c-0a6ce13daf4e	PRINCIPAL	t
212af296-627b-4c3f-a846-c62ff6d99fda	8acd530a-7206-4e80-b98c-286ff3558a54	e504b07e-916b-4670-a17c-0a6ce13daf4e	PRINCIPAL	t
57665db1-0309-4a68-9760-ef2a24e51c61	a7dea16a-4f31-48fd-adf7-ab5d2756293b	8f04654d-a7bf-4a09-bf80-b5961dcc8399	PRINCIPAL	t
13b7e5ee-9b46-49fa-be8e-3f35aaee25ae	712394d2-6557-442d-b64d-aa35d0d826ff	386e87a1-3845-4435-9c10-68a84ffb0f32	PRINCIPAL	t
7fd46d35-9dc2-4ff1-ac3a-d5cf58c9f94e	f63eda88-c98c-41e1-879b-432605f87f1c	35917453-f41b-4e8d-8e75-6a889c9aea81	PRINCIPAL	t
8ae12031-b444-491c-8269-e0e861d50a35	92293102-1899-4032-9391-ec6a3ee2181e	daa8ef1e-481e-4b97-a071-56141bac9d06	PRINCIPAL	t
6b8f483e-7441-4497-8edf-f0feb4fd4821	d606cc06-75a3-48b8-b9d0-8d4a2d0c494b	daa8ef1e-481e-4b97-a071-56141bac9d06	PRINCIPAL	t
82fa9377-b5b1-445d-9281-b84e150849e8	7e5b3a69-2b30-4e5c-8538-5001b862aa62	daa8ef1e-481e-4b97-a071-56141bac9d06	PRINCIPAL	t
2740e63b-5a29-47f0-aac8-9b734be30aa6	806519d9-8bf7-444d-9f36-5c79cfedfdb1	daa8ef1e-481e-4b97-a071-56141bac9d06	PRINCIPAL	t
20668e48-c753-443b-bcb3-c8c1752bac0a	3845defb-88ab-4d8f-98b6-dc8e65068ce9	daa8ef1e-481e-4b97-a071-56141bac9d06	PRINCIPAL	t
b32a0d57-7dfa-4516-b9f6-fd2036cfac88	0a4deba9-130a-4f19-b564-ca66339d2280	aa490ee5-30e3-4181-b413-03fd665a8448	PRINCIPAL	t
b6bac250-4ddf-431a-b931-6abba7b87fe4	43d91c90-ae45-4679-a1c1-3f059be488f9	aa490ee5-30e3-4181-b413-03fd665a8448	PRINCIPAL	t
db1d32f5-3c46-4417-9bc2-f22fc980758c	b181221a-9aaa-4540-a571-14218a70690e	ec4efd97-0b3e-4bfd-9519-3c4048625df9	PRINCIPAL	t
5123bdf0-0dcc-42d8-9223-70cb9c200b6c	51265918-6ccf-49f9-ae8d-a0a70d7da29b	7a8621e4-12e7-4828-9e96-0a39cf136820	PRINCIPAL	t
2a1e8e93-4783-4f8f-a852-5ac6161521c4	2de88e08-618d-4ae1-ae8d-5a16f9def0f1	414b0c66-0031-4403-9e75-bbf02e820c58	PRINCIPAL	t
ddfdf821-4a26-450a-a054-2ff708c2271a	2a3adeb8-d8ff-4142-9adf-9a536b9d4ac3	cbb02cfb-559e-4348-a494-7b3ee41f76b2	PRINCIPAL	t
0472ed03-2632-43f0-9ee6-05074f064cb5	342ab491-7d7f-46ce-ab5b-e0b1ba3fbf42	ba45cd4d-cf7b-4948-b24c-e56aea99b66e	PRINCIPAL	t
4ebf24fa-8e53-4e4e-a463-333590cdef23	0d34986c-f5ce-4831-85c3-fe53b16edba1	ba45cd4d-cf7b-4948-b24c-e56aea99b66e	PRINCIPAL	t
eea85ba4-62ba-457b-83b8-993fcdd3388d	9f5284d7-6fad-408a-bb42-6c9805f7c0cd	c94e6db1-32bf-47da-969b-7e4289aba5ea	PRINCIPAL	t
be357bb0-8973-46e7-9c36-459cfb6442e5	e290f592-a81e-4cdf-ac29-4577bf1ad95a	c94e6db1-32bf-47da-969b-7e4289aba5ea	PRINCIPAL	t
48e326d5-2523-4d21-8a49-5f0f7f93513d	3b4a3231-badc-4295-bd33-06ace1993929	c94e6db1-32bf-47da-969b-7e4289aba5ea	PRINCIPAL	t
b93793d8-de9b-48c2-b5ad-9a1821cdd8a0	a285b4db-9b29-4209-a91f-eeb9b766ef8f	c94e6db1-32bf-47da-969b-7e4289aba5ea	PRINCIPAL	t
aa18ef42-f265-4bb0-a336-2c07f6dba50b	2f9b6ca5-23f1-48bb-80d8-3899e3f4defc	414b0c66-0031-4403-9e75-bbf02e820c58	PRINCIPAL	t
d3da12ba-8ca7-4eb9-934a-20b85d7f4f0c	0cac60ef-f76e-4e99-bc3c-92761b492e55	7a8621e4-12e7-4828-9e96-0a39cf136820	PRINCIPAL	t
a769a87b-c15a-4d2e-8fe6-0381c70fdc48	2004a28b-46aa-4eb6-8f64-2f933458ec35	7a8621e4-12e7-4828-9e96-0a39cf136820	PRINCIPAL	t
301059b3-87c8-4329-bef8-135609e6f935	1cfb3201-e513-4b4a-a7de-5490218b3ce7	9a453f6d-1fee-4a05-8aec-bc93fab5ec47	PRINCIPAL	t
3c12cb31-a0c5-4a43-b877-b20b3876a6b3	12418022-9b63-4a7c-aeb1-5f11a92890a1	b58c3f79-5f47-40dd-a3db-4fbd5b020e4e	PRINCIPAL	t
160e39e1-788f-43a6-82db-86681235d6ce	8bef971d-cd31-4d49-8149-df067a6970d0	b58c3f79-5f47-40dd-a3db-4fbd5b020e4e	PRINCIPAL	t
2e831270-eb26-4ead-8e61-ab1dbe5e2673	175b6df9-add1-4f10-879f-9cc0bdc334f8	b58c3f79-5f47-40dd-a3db-4fbd5b020e4e	PRINCIPAL	t
cd931289-707e-4ad7-8478-1c7f2ce502ab	a216dcc2-5300-4806-a4c0-e25ba24f9ed3	e483342f-b74f-420a-84b4-9cfa31dbacec	PRINCIPAL	t
1d03ec89-20ba-4814-82f7-406af9a1df62	dcb59d8b-810e-4496-bca4-6adb4f7183c6	0b9a4a10-a144-4387-84ce-e5ededfd4100	PRINCIPAL	t
32df18ce-469a-4180-a0dd-d2b50fff6fdd	cc5ba4b0-d549-4610-bb0e-aab17b0b73ed	ec4efd97-0b3e-4bfd-9519-3c4048625df9	PRINCIPAL	t
4fd919ef-ee84-4e92-b678-0253363229c4	38cd806c-94c9-4c93-b278-6a4bf0b57162	14e21a14-17ce-4794-bfb1-c651ed022818	PRINCIPAL	t
9103f242-dee3-432e-a23c-5ed313816192	343fc41f-b24f-4c2f-92be-7749f718d139	eeac2bca-a24c-4458-b820-9c5a9b49cdcb	PRINCIPAL	t
563f46c6-7140-4736-8bb5-708ed451adba	e4ecff21-9bf9-43ac-9a6c-f6657b2df2c1	192a2eee-9ee7-4ccc-97fd-71c00fdbb3a9	PRINCIPAL	t
efa48e36-218a-461c-bd53-c86dedd5b416	e03818c1-751e-429e-b27e-d1369740d4c6	192a2eee-9ee7-4ccc-97fd-71c00fdbb3a9	PRINCIPAL	t
d4c186ca-562b-411a-9928-17276afc24c6	df65e538-7de0-4b2e-9b8b-4d82196e676f	192a2eee-9ee7-4ccc-97fd-71c00fdbb3a9	PRINCIPAL	t
3cbc64f5-b99a-46ed-8855-f2a28dfbfeb9	57997455-4699-435b-8e78-69ee4b93b166	192a2eee-9ee7-4ccc-97fd-71c00fdbb3a9	PRINCIPAL	t
5be43e15-9b82-415f-835e-5945aff81bfe	d837ce57-8854-47a9-94eb-183002e6dc2b	226de0d1-ea56-4c31-9937-d65b2401300f	PRINCIPAL	t
a020b5fb-5760-4c25-a873-6cf51cb44602	3cbd6018-7b8c-44c4-a9ed-9045ec4263a7	8f04654d-a7bf-4a09-bf80-b5961dcc8399	PRINCIPAL	t
d7cf1520-f1ee-434d-a378-ba4adf42a4d9	979074c7-2798-4b32-866f-79f2c7326e97	5cd79891-c469-4b7c-8cae-df0ccc5587b6	PRINCIPAL	t
020a6852-4d47-4b49-953c-358338b96090	6f66ad62-7f82-4e0f-9ebf-37eb6fee5066	0e7cee67-f8cd-4035-be66-240e6d411fb3	PRINCIPAL	t
264b5318-4385-42af-8f2c-9335def0fe66	e9176bf0-861a-4ed1-b313-42316f803c61	386e87a1-3845-4435-9c10-68a84ffb0f32	PRINCIPAL	t
5b288b3a-96a5-4e50-99a8-eba38512f050	fc0a021a-913d-46eb-a1e0-506f732128b1	bbae4d55-b474-4190-8482-b3f41534a682	PRINCIPAL	t
e9198bc6-d175-46c1-962f-d7bc3b6cdcec	f8a55ff8-1f83-4e6e-b289-55d709fa0169	42b9e9a1-ae10-48dc-a782-ca47465644fe	PRINCIPAL	t
647d4a2e-6e50-46ed-970d-80725cc6cc9f	ec0351d8-2c27-4b57-83d8-4a73609736be	42b9e9a1-ae10-48dc-a782-ca47465644fe	PRINCIPAL	t
d8e25106-76be-45a1-bd77-2537882a15e9	76a71f57-ef0c-40f1-8628-fc378cc2f4b0	42b9e9a1-ae10-48dc-a782-ca47465644fe	PRINCIPAL	t
f137a3c0-d88e-45b0-801d-3f9949cb2266	30ced7c0-b36a-4ec6-ac92-6a1030523cb0	e881013d-b3f0-498a-88a1-ee9621e34f87	PRINCIPAL	t
4144de22-e475-4e4e-b652-8ee70a44bb6a	868048fd-a4c4-4d09-8d53-172b14a2e714	ba45cd4d-cf7b-4948-b24c-e56aea99b66e	PRINCIPAL	t
e974579f-b820-48b2-8fdb-eeb2e43102f5	6d66f65b-563d-4871-8686-af1376dd665c	35917453-f41b-4e8d-8e75-6a889c9aea81	PRINCIPAL	t
e571d62b-ed78-4491-833e-4d5ca74ba489	84f869f6-9e8b-4ad9-b3fb-e0896f627799	35917453-f41b-4e8d-8e75-6a889c9aea81	PRINCIPAL	t
339e1220-b910-4781-8580-04c7060dfe02	ee2fd666-e069-4d35-9fb6-39eb125ee76f	daa8ef1e-481e-4b97-a071-56141bac9d06	PRINCIPAL	t
1f3598c0-c901-4639-aa3c-50f1c6fe7f28	23514a85-4042-4717-b345-afd063801b0b	414b0c66-0031-4403-9e75-bbf02e820c58	PRINCIPAL	t
c367d386-4b03-480d-ae05-8ac6bec510b3	60f10b65-3cc3-43d4-a319-6e26b6532d1c	cbb02cfb-559e-4348-a494-7b3ee41f76b2	PRINCIPAL	t
fff2508f-4f89-497c-8e98-e8d580a1f0d0	568488ec-4135-4036-be87-79921cdd467f	1d803758-7f28-415d-9b20-dca5fa459f1c	PRINCIPAL	t
70df7ec4-0f9d-4737-8ec6-aba0c752365c	9444a891-96bd-4f54-bdc7-015b90bec453	1d803758-7f28-415d-9b20-dca5fa459f1c	PRINCIPAL	t
3763ba83-a62d-4002-ac3c-98a4c5ab1bbb	b94a984b-9b86-4a62-8fed-adc51b744b01	1d803758-7f28-415d-9b20-dca5fa459f1c	PRINCIPAL	t
cf21d082-9749-4e0d-900c-d1f0dfa64140	e77a9a6f-7dd4-4827-8bde-210d2af8e1ff	1d803758-7f28-415d-9b20-dca5fa459f1c	PRINCIPAL	t
31d7bf10-723a-4d1a-b3a8-484d76fc9a66	eca2f1e8-2b3d-4ca5-b523-15728f892f23	ba45cd4d-cf7b-4948-b24c-e56aea99b66e	PRINCIPAL	t
abec0176-85f6-4485-b922-68bc8f11d1dd	6b3ebf06-3c00-4093-9762-b867fb1ad205	94c71dc6-0ae5-4e57-ba53-84d292db1856	PRINCIPAL	t
64b656a1-eb4f-4019-8218-fd6174531765	e9eba53c-9dd0-4077-9cb2-afd7626b57d2	4f04d022-95d2-42c6-aeb2-2b236c45780f	PRINCIPAL	t
71cc6945-6bef-4551-bf60-015985cce79d	b3ed9fe5-1104-42e8-977a-b2ef10e4a92e	4f04d022-95d2-42c6-aeb2-2b236c45780f	PRINCIPAL	t
5ffd3f9b-34c4-4643-acfd-146ac4b88f5e	89ec70f4-fcde-45f7-92cb-a468a5bea501	4f04d022-95d2-42c6-aeb2-2b236c45780f	PRINCIPAL	t
0b1b0a31-b5a0-490d-b267-648217d68798	c97c3b26-9919-4694-9694-596d07d7779d	4f04d022-95d2-42c6-aeb2-2b236c45780f	PRINCIPAL	t
bbb08046-53ad-425e-bc3e-1cb4c2b462c9	72a9fa20-cfe7-46b6-83f4-6d3ff92f87d7	e504b07e-916b-4670-a17c-0a6ce13daf4e	PRINCIPAL	t
d11e9e90-18b6-4753-a341-75c65b102295	8fbd2bc1-9e76-4bba-8664-02c53d1c7d44	e504b07e-916b-4670-a17c-0a6ce13daf4e	PRINCIPAL	t
957cb3f9-273d-420e-b54f-59ba4ec22a0d	71ba7eb0-efad-4b05-b16c-e6c4319c3aeb	e504b07e-916b-4670-a17c-0a6ce13daf4e	PRINCIPAL	t
7fda4b61-7ae8-48c8-8abd-f2af4729ae85	d5fe4e6e-8dc6-4b77-8754-002480a96396	6e358b63-2675-42b3-83ba-8cbb14031224	PRINCIPAL	t
b8520df2-d921-40bf-b15f-d9da922cf7ca	91f13c60-0e2b-4e79-8daf-d2d84793fa12	aa490ee5-30e3-4181-b413-03fd665a8448	PRINCIPAL	t
81c19950-d8fe-4e1b-9870-ff6269d42fcc	74b093ab-708a-4486-ab87-0bb4ffb1c33a	aecbca5b-79e1-4bd7-b4bd-fa0f165b6fde	PRINCIPAL	t
8a8b5550-dc2f-4246-b833-f050e3466ad3	692ee3d5-7424-4b5b-95bf-2f1b0647682b	ec4efd97-0b3e-4bfd-9519-3c4048625df9	PRINCIPAL	t
154770df-00a6-49d5-aeab-c5b2e10e94a4	411bd93e-ff46-462e-9695-1803c54bcfa2	b58c3f79-5f47-40dd-a3db-4fbd5b020e4e	PRINCIPAL	t
1c74046b-7ede-41a1-b396-7c0f85015cc8	69b5be3d-8393-4835-9419-ef2a066e86b5	cbb02cfb-559e-4348-a494-7b3ee41f76b2	PRINCIPAL	t
7c9ac232-1696-47df-a89d-896eb2cb8591	2c6b860c-2350-4c12-9479-16b32823b181	f69c66a3-934b-4e74-8f9d-af12a1feb18a	PRINCIPAL	t
94e67ffc-9825-44ca-add6-875ed3242a80	615bb897-aeee-4645-900c-a4dfb62b0155	5cd79891-c469-4b7c-8cae-df0ccc5587b6	PRINCIPAL	t
2e91a3ec-5d7d-46c8-8830-f49928343ee9	dde9902b-1367-4fc7-971e-2f6396559a04	d947086c-8d9e-4dbc-862c-83012ebf47d9	PRINCIPAL	t
8df011e8-8370-4f6e-b7c3-678238b90d4e	bae53874-b869-4764-b79a-b28e6c2519fb	72775eb6-a79b-42d0-95fd-6e117ed0cf5b	PRINCIPAL	t
ca7ea7a1-58c9-4cff-b56e-c797bfe22464	6d2a3b4b-d29d-4071-876c-38324be54068	8f04654d-a7bf-4a09-bf80-b5961dcc8399	PRINCIPAL	t
64cf914d-80c2-497f-b397-45877e0bd7e9	09a1cb01-2b1b-404d-952b-e8a78978d711	b58c3f79-5f47-40dd-a3db-4fbd5b020e4e	PRINCIPAL	t
320c87aa-01a7-4ca2-8a1f-c6d908ab5c84	2da10c7d-4fff-4a17-a203-ffff747d834b	01f4a0f8-05f3-4e74-a235-a302423a3971	PRINCIPAL	t
5f722bf5-7c50-499e-8a69-3e9063003aac	487292bd-3796-4f95-86ac-728bf34f7d57	42b9e9a1-ae10-48dc-a782-ca47465644fe	PRINCIPAL	t
d4cef680-62d2-4e37-b048-259be43c7d4f	3c2c9225-f99b-42ee-b7a6-880750153f54	c94e6db1-32bf-47da-969b-7e4289aba5ea	PRINCIPAL	t
df2965f7-0b44-494f-909c-6c3246f9cde1	8ec99d2c-3e35-435b-87b6-d93767ddbd28	fe96642e-1c00-452f-917f-ca212b976e2d	PRINCIPAL	t
11d53107-2bf3-40a0-b740-8dd6bec2bdbd	54a0cd21-f671-44e7-b98b-1f1e3c64efd0	192a2eee-9ee7-4ccc-97fd-71c00fdbb3a9	PRINCIPAL	t
986abf99-a840-44f9-a388-6e371a56b647	36e814a7-42de-4c67-a37f-366923ce7afa	aecbca5b-79e1-4bd7-b4bd-fa0f165b6fde	PRINCIPAL	t
5a5ae9c1-1bf1-4579-9809-275beca37136	57516fda-833e-47c7-b54e-82c0d82ba7ba	1a8f9fff-06b6-45a0-8989-693614307d68	PRINCIPAL	t
b033f08b-626e-46c8-8db1-8e0c6547c38f	5c2e28c5-168b-42b4-b6d5-7ca77da15615	35917453-f41b-4e8d-8e75-6a889c9aea81	PRINCIPAL	t
135a7a4c-065d-420d-ba55-23e85e2d99d1	3a573dd3-c97f-43cc-82c9-70b79e4a0f1c	e504b07e-916b-4670-a17c-0a6ce13daf4e	PRINCIPAL	t
5dd6fda9-6d1c-425b-a368-ac86f047eebf	78796cee-9ad3-4956-b780-36d1bedeae55	e504b07e-916b-4670-a17c-0a6ce13daf4e	PRINCIPAL	t
d800f2d6-19b1-4542-b1f1-a96da5d79a0e	047629dd-2ad2-4594-a306-ae7b6186efaa	e504b07e-916b-4670-a17c-0a6ce13daf4e	PRINCIPAL	t
f75ded47-ebed-465c-9ddf-3a1357af11d9	b7787f43-7bfc-47b7-a9ab-33cf3fd9d5af	e504b07e-916b-4670-a17c-0a6ce13daf4e	PRINCIPAL	t
d8de6202-7e4a-413e-8289-1d2f47ee19b6	754fd613-4afb-406b-99ae-3f338839e6dd	e504b07e-916b-4670-a17c-0a6ce13daf4e	PRINCIPAL	t
6feebe2e-2412-41a4-94ef-48c88967cfdd	91902f3a-9c1a-4e61-a912-4fa44e62c2ef	e504b07e-916b-4670-a17c-0a6ce13daf4e	PRINCIPAL	t
d42145ed-e95b-46e5-96a0-0bb64175ff9f	9e461da8-7476-4448-83dd-90c94afd0963	ba45cd4d-cf7b-4948-b24c-e56aea99b66e	PRINCIPAL	t
cafc17e3-475f-4f24-aa63-217083ceff27	bfd762f1-382c-499d-a3c9-553d50dd8845	eeac2bca-a24c-4458-b820-9c5a9b49cdcb	PRINCIPAL	t
d3356110-d2e3-4fe7-b44d-f50dbfa00091	5319c01b-11e7-41bd-bc60-1efa37489742	94c71dc6-0ae5-4e57-ba53-84d292db1856	PRINCIPAL	t
2d543bde-93fc-49dd-8daf-7a9338731bfe	b0e053eb-29bd-47df-9cd7-5f143d72bdf4	94c71dc6-0ae5-4e57-ba53-84d292db1856	PRINCIPAL	t
84c3e462-bbe5-41ff-a370-360cd2bce556	f085cceb-4f74-4c19-9bd4-9f188272b814	94c71dc6-0ae5-4e57-ba53-84d292db1856	PRINCIPAL	t
06c9b47a-5458-4ffc-87cf-48126b306210	463f000f-a220-4f17-a69e-f141aee91fc5	e881013d-b3f0-498a-88a1-ee9621e34f87	PRINCIPAL	t
73d48580-da9f-4dbc-9119-0fb23ea2c5c5	d4961ac6-36db-40c6-92fb-82ffa0fcdb95	72775eb6-a79b-42d0-95fd-6e117ed0cf5b	PRINCIPAL	t
3e69d507-d641-4b86-bfc3-9a696b5b0f76	d8664715-5307-4b4e-9fd5-eb4d9e27384a	f9f703d5-ea13-4725-8d1b-24343e9a735a	PRINCIPAL	t
55bbadbe-5730-4577-9a46-489ef59674bc	4122fe2e-5a94-4ed9-8761-aa564996e518	6e358b63-2675-42b3-83ba-8cbb14031224	PRINCIPAL	t
6de9b1da-7dc5-4c9a-85f9-68d976e3d158	349c03e4-a01f-4aa9-8bde-71f2c6534780	67b3e5c2-687f-4a90-a8cf-e3bf89e25f00	PRINCIPAL	t
a242220a-ff11-4c01-9364-92d7238d0589	1e3d7199-65ca-41ec-a1df-a01644ded410	67b3e5c2-687f-4a90-a8cf-e3bf89e25f00	PRINCIPAL	t
3372cfd5-5c60-4460-aa37-8b24a64fd86d	19f8f34d-5ab8-44ca-a536-46a210333a38	67b3e5c2-687f-4a90-a8cf-e3bf89e25f00	PRINCIPAL	t
c2a30897-acdc-4f6d-9764-0fcc3568b6e6	5e76f1f8-fc8e-4f7a-ae1d-da561810f038	67b3e5c2-687f-4a90-a8cf-e3bf89e25f00	PRINCIPAL	t
59b599b0-1234-49f9-a625-43b9743e63bc	0abcbb39-c336-4127-bf31-8b2d32af53ab	3d3ea7ed-0af4-4e46-8b18-d95970f9a95a	PRINCIPAL	t
c78541a9-886c-4e4a-b56f-02361042883e	837e5338-c908-4b07-8562-f2b7653f158d	5cd79891-c469-4b7c-8cae-df0ccc5587b6	PRINCIPAL	t
6bd276a0-8f9f-4958-9881-f6f291e51d8e	999e61df-8857-4990-8870-3556bbc2bd4a	5cd79891-c469-4b7c-8cae-df0ccc5587b6	PRINCIPAL	t
aa2f561b-ec3d-4f55-b774-e199d3f6e00b	de9adf82-823c-4a9c-bb46-fd894c1fa63c	5cd79891-c469-4b7c-8cae-df0ccc5587b6	PRINCIPAL	t
8caa98ea-cddd-43cc-b119-45d794e60283	2ad99bfa-3f42-4289-9ef2-e03ac84dbb86	5cd79891-c469-4b7c-8cae-df0ccc5587b6	PRINCIPAL	t
6f0e3e3b-5caf-4f04-9f14-104e98cd60d5	cd61a02d-1465-4106-ba28-e65f48463746	daa8ef1e-481e-4b97-a071-56141bac9d06	PRINCIPAL	t
b748d0dd-3e9a-4e95-9a6d-caf45a05cda1	d1fdd43a-ef0d-4e3f-80a2-a48303fc2685	aecbca5b-79e1-4bd7-b4bd-fa0f165b6fde	PRINCIPAL	t
c76ff96d-561b-436b-8931-18c7f2645aee	2c7280f2-6bbb-4adc-972f-f539bd409c63	07da7dc2-e85f-450c-82bc-160a9efe5c8d	PRINCIPAL	t
\.


--
-- Data for Name: mareas_movimientos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mareas_movimientos (id, id_marea, fecha_hora, id_usuario, tipo_evento, id_estado_desde, id_estado_hasta, cantidad_muestras_otolitos, detalle) FROM stdin;
a3c112d9-980f-4beb-8011-6ac8e1079449	04919a8e-1d89-49a8-a98c-c7e4c864c82c	2026-01-02 04:19:24.182+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
d2f81dd8-4691-4a8d-b3a3-5d8808fea102	c3a1effd-b5dc-4dc6-82bd-bf565dbb9fa2	2026-01-02 04:19:24.216+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
a52748fc-2cda-4cfe-8b64-b391525bae10	6b27610e-53c5-4d23-a5c3-2d54da315aec	2026-01-02 04:19:24.227+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
0e93d360-9a40-4214-8051-b39a9dc99eec	874d961e-4f10-44d8-8a26-704dfe59baf8	2026-01-02 04:19:24.237+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
eed58bb2-15e8-4fb3-95ca-d9e2dcafe32d	07879508-cbb4-4b79-a7ac-df50a730ae89	2026-01-02 04:19:24.248+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
5f1e3881-26ab-446e-976b-a582a13692f2	f0651e46-2efb-4b53-aada-e5674bf3b42c	2026-01-02 04:19:24.258+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
e4ac5ab1-de8d-49ca-99ed-b4b3ec2ee0dd	e8ca1cdc-4a63-4c22-ad41-9f5735a63771	2026-01-02 04:19:24.268+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
5af30320-7195-457a-8d7e-a83b701a852b	d0571ab3-52eb-46ee-8c7c-35c742e70e57	2026-01-02 04:19:24.278+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
1dce02fa-ec9b-4fd7-866e-d130c39e0f2d	f404c632-fac3-4128-9cd5-114a21d0531d	2026-01-02 04:19:24.299+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
951b7875-6a49-43ee-b696-14ac52999466	acc394fb-c63f-4afe-8cfa-c766d39201bb	2026-01-02 04:19:24.311+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
4d345693-b060-4dab-81f5-938289828a17	79891cde-4f19-4d5c-bf01-d1f5b7a48536	2026-01-02 04:19:24.323+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
8285c895-23cb-4056-a3c2-17e75de71819	19a2c92e-bc67-47be-942c-dac4ff8bd026	2026-01-02 04:19:24.335+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
8fd47740-063c-4a7a-8852-a9acf48bb74b	c4feca97-3387-47cc-b0e1-81970ddc9dc1	2026-01-02 04:19:24.345+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
329efc6d-1d0c-4950-8a0f-054e26e95c6d	fc29f36b-38b2-42e3-ada5-922e621fd69e	2026-01-02 04:19:24.355+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
f684cdfb-a023-4fbb-a289-ff5e106c0f39	fcb741cf-4c60-4996-b34a-ddb7d675c782	2026-01-02 04:19:24.373+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
69470c7c-a998-45a2-83a2-747e8a8af28b	33798d54-773b-44d7-9824-2ee0a9ad68e5	2026-01-02 04:19:24.392+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
1146a2da-65fa-4940-a4c0-5fe471dabc47	6de667b9-de1b-45b0-92a1-6a810df139a4	2026-01-02 04:19:24.402+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
f7c98e3e-4b38-436a-ad1f-7fec1787ec49	93fdbfcc-2f30-47cb-811d-ea5b5fa2d1ab	2026-01-02 04:19:24.409+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
bb301cb3-5acc-4138-adae-6525f5fb3b42	2a7c3bd8-bb58-40b6-b423-52c2b8a7c48f	2026-01-02 04:19:24.418+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
3e659ad0-2a56-4091-8171-2d1f21191ceb	360e781e-8403-417d-a78c-ac278ca025e2	2026-01-02 04:19:24.426+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
dac15f14-41e7-479e-8d79-81d548cd8a84	562aa66d-c729-4132-bb7d-27ad7e32e3d1	2026-01-02 04:19:24.434+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
64c21c1b-0b8f-47a8-93ee-1c4fa380b280	aa6b4552-3765-4da4-99aa-54e9cdd87ef7	2026-01-02 04:19:24.442+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
9aca720c-3f55-4268-9a80-e98566a6e177	346eb434-1937-4e63-800c-bee29cca4325	2026-01-02 04:19:24.45+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
145dbd30-e6ca-4d64-b774-8c20d3ccb6e3	4dd4f175-b2ec-4675-917f-1f33c34d275e	2026-01-02 04:19:24.459+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
393b13ea-00c6-49ba-81c8-5b383f284d28	4d1f7c39-65a9-4eef-aa62-5c082d8c4522	2026-01-02 04:19:24.468+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
8fa4b6d8-ded4-4c11-9d13-5d882857fc89	03b80d20-6553-4257-82a2-58965ee924a9	2026-01-02 04:19:24.476+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
f6a42e49-60ec-4447-bd11-e7ffd0568f18	9a73cb1d-5a35-44ee-b4a6-b9b371b599d5	2026-01-02 04:19:24.483+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
c724c7ad-42cd-4a81-bed3-1d1b0bf7bf77	a23ab54e-f24c-4b0c-bce7-8d5441ea2309	2026-01-02 04:19:24.49+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
83cf800c-5a6f-4b6e-9551-697d4f3dd3db	bc698db6-d2c9-472d-a461-25ca56770f94	2026-01-02 04:19:24.498+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
6718928a-000d-4ab4-8bfb-25e008ab496f	c7c980d8-5207-48a7-9d1c-d2f291f7368f	2026-01-02 04:19:24.505+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
1a3bcbb6-fcd7-4c6f-b01f-510ea3e69f2d	b46e9497-edac-42dc-a8bf-db062b822264	2026-01-02 04:19:24.512+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
eef74dfd-92e8-4f7b-861e-7f15796001cc	a9ded57b-c564-42d6-ac89-5ab0dcde7a92	2026-01-02 04:19:24.519+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
9d5eedfa-5724-4469-b40d-b6b473fb6dd5	1a2d90b1-a6cb-4b58-bdad-ccd602c60fba	2026-01-02 04:19:24.527+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
c6f902b9-dba2-4d5d-86e0-8a4bd0236088	9711d801-642d-400a-b9ee-6e7e0a543a06	2026-01-02 04:19:24.536+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
8a1730e1-b124-4be4-8ec7-74e200364abb	5f0abe34-ea90-43a2-9adc-b6fbd7ebbcea	2026-01-02 04:19:24.543+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
9387c01c-02c3-4145-82b2-d3a724d8f5ef	60ed4b3f-84f8-432d-af24-d0fe1d8a6f5c	2026-01-02 04:19:24.551+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
b20878c5-678c-4d08-9b55-04e35d1ef34a	b8188c44-bfce-4fc9-993e-86c6212f9e62	2026-01-02 04:19:24.557+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
c098510a-c73d-43f7-9f33-6a466cbf4797	d7477631-230c-43cc-9ad2-9a458540e95d	2026-01-02 04:19:24.567+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
2a4b10ae-a9d4-46bf-a8d4-579ead918006	9b3f94f3-819e-4ff3-9174-d77be597961f	2026-01-02 04:19:24.577+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	9e842bbc-3f8a-4bf7-a513-52b407158ec8	\N	Marea importada de seguimiento 2025 (JSONL)
74d1c35f-70a5-4572-a0d7-0a2eec9023de	14943dfc-1f7d-4bc5-808c-51d6c4e1d2ab	2026-01-02 04:19:24.584+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
fcba9bab-8500-4274-bed0-87c6eecfc30e	8c71e1d6-747e-4f67-b74f-5fa24fb8b1e1	2026-01-02 04:19:24.591+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
3c929111-685e-46b7-9f68-7f287b6b19dc	3e3cf12e-d182-4e0f-ba3f-e39a3880cecc	2026-01-02 04:19:24.599+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
8dc260af-b0b2-46a8-96e0-28f0dcc9f013	cfb18177-e9ea-4c31-9bb0-f50de16b33b4	2026-01-02 04:19:24.607+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
587101b7-79e0-4f7f-915d-6a3d6b9e98ef	c72cddb5-13a0-4308-8592-90c485b9223a	2026-01-02 04:19:24.618+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
11c82794-8515-4492-92df-5652622b779c	8eadcafe-2174-429c-b3a7-cffec0d8e62a	2026-01-02 04:19:24.627+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
b1ec8dd5-09c9-4a08-ac67-df20cc6d3115	4e37279f-2272-4096-92e0-40b32bb3b655	2026-01-02 04:19:24.636+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
96f4b17f-b983-4589-9432-15e35dd60439	f59534d7-f262-4dd8-8f64-fa3d3091571e	2026-01-02 04:19:24.645+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
3e8a037d-6fd0-4630-902a-c9a90ebf8b9e	2f6ee5d6-2d49-4c5a-91ff-a006e893a74c	2026-01-02 04:19:24.651+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
15ce4648-0104-468f-a04d-4bfcedb41031	f20a8859-90c1-4396-ab58-e3190eeb2991	2026-01-02 04:19:24.657+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
a241c4b9-449d-45db-8a4e-cebc10fb4a35	05d56476-ae1b-4c68-917c-a7bacb26fdde	2026-01-02 04:19:24.666+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
6821da5a-f332-4ff2-9d36-02ae595b3c58	8a897cec-9409-440e-ab29-f7be994ca100	2026-01-02 04:19:24.674+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
8081ffca-405e-4baa-bb73-a7cf4f1a652d	6bc7c5a7-f9e0-4b66-87c7-afb6431a3361	2026-01-02 04:19:24.681+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
bf6280b6-b97d-4352-b9b7-3a801020af20	b41abed5-fc68-4678-bfba-f38defa54ff6	2026-01-02 04:19:24.689+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
15d13bd3-674b-4a30-b049-473337e8b351	349de9dd-0da8-421f-a240-e329d057d367	2026-01-02 04:19:24.696+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
4ec3a3e6-fcff-4758-94b7-781c47279dc8	0efc2eee-dfc0-4093-b2b4-d231e2e4d555	2026-01-02 04:19:24.703+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
9f3801b3-61d0-42fc-a5b9-d138abac3ac2	19506384-a971-4c7f-812a-333c4c523d50	2026-01-02 04:19:24.709+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
6d10b303-f1bd-4e18-a66e-25b9eef2f03c	cb5e0b51-9a46-4c91-94ae-cb019458fcd9	2026-01-02 04:19:24.716+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
1fd8f085-ac6e-4071-bd5b-6fa92efa17b0	4d4a0a97-9c4c-452b-9234-922947c4255e	2026-01-02 04:19:24.723+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
06563fda-07ff-4e14-addb-3503ef8de4ac	35dda77d-99d2-41e9-8118-3f6e3dc9ba2d	2026-01-02 04:19:24.73+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
0aed61c2-fe7b-4917-91de-61a48fb763e1	cb556c38-7986-4a55-ba9d-208e6e60b75d	2026-01-02 04:19:24.737+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
9e9374ed-51a1-4c9b-af76-3c272393901f	4f243ff3-95be-4da8-af26-83c044b89ffc	2026-01-02 04:19:24.744+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
bfe586ef-9a86-4a3c-9763-50339a06bd21	6bcd1042-c72b-4a90-a3d2-f60957e833a0	2026-01-02 04:19:24.752+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
3c93ba74-ef11-4749-af90-5b52a4b85c70	bf5b9c59-103c-4165-9443-b16ab79763ba	2026-01-02 04:19:24.758+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
b6c9748f-dd70-4941-9db3-a008efb17831	1d9c2349-cd16-4dc3-a3b3-03c9cfc52939	2026-01-02 04:19:24.77+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
d867f6ac-0663-4b9a-bb89-966dbad9939e	de6be5aa-e1f3-4e48-be2d-ad6ab4329899	2026-01-02 04:19:24.776+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
60c4f947-1e23-4d59-965a-fa5430ad0652	8f7129bd-295f-4671-b1c8-2ca93d2b881e	2026-01-02 04:19:24.786+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
07cc562f-e01f-4cdb-8341-0da07bb05d39	06c23584-5894-441a-a353-4477b9922edc	2026-01-02 04:19:24.794+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
22cd4185-c440-4670-8783-6c920c116d29	4f77e130-30f0-4325-9568-454e639c323c	2026-01-02 04:19:24.8+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
d3af673e-86fb-401b-8d61-29550154f89d	49d2cd67-e474-4452-9b24-19ac5f78c47a	2026-01-02 04:19:24.811+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
2049f043-58d5-46be-8549-0d6d317c9a87	5884959a-814b-476d-9115-33b8933e7a60	2026-01-02 04:19:24.817+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
601d1e8d-f77e-4150-ac66-4e1666f589a5	b2934e06-51b0-4316-b962-e4c7053df833	2026-01-02 04:19:24.829+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
603b449c-2c17-4023-a3b2-ee41307cd0de	0409eab0-c608-40e5-ae39-86bc117311b0	2026-01-02 04:19:24.838+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
72d0a63b-c551-45d5-80eb-b35a4a18dc29	d5464931-b47d-46f0-aa9b-4e80b3dd2dde	2026-01-02 04:19:24.847+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
c9d89521-f406-4970-b0f1-3fd2aec32a72	1cfa1f0f-f9b2-42ee-8d42-5bac2892191f	2026-01-02 04:19:24.865+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
86bf8e7b-8916-4475-8316-59a9374020e9	cee1a4b3-5735-4c40-9c55-50adc608d891	2026-01-02 04:19:24.878+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
ff79b91a-f166-4d81-87b4-11d099ada979	44f73667-e99a-4d86-a7c9-340b3529bdc9	2026-01-02 04:19:24.889+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
6f981eb4-8dc1-4957-8da1-b771fbe8593f	7734461b-f8e3-49c1-ba99-37f094756bbc	2026-01-02 04:19:24.904+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
4c9d7af1-cf9b-4a8a-a1e6-a11750983fb8	fbffea19-f8bf-487e-a809-4bb307a6806d	2026-01-02 04:19:24.918+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
4521f249-f707-4e94-92a6-f8ee745b1689	81390c34-45d6-4c2b-a48c-a065065bb3df	2026-01-02 04:19:24.932+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
de5d69f0-ab05-42df-9bb0-6807b8c4cc56	dc473bf3-beba-47e1-a1d5-237083bd1428	2026-01-02 04:19:24.945+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
9512ab54-2820-4e99-a972-ece67b75ddda	c11a111c-c96c-424a-afd3-529c724eee5e	2026-01-02 04:19:24.956+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
f3f9cb22-8994-405a-83dc-66147c3e3d4a	5894c1f3-0fc4-4eb8-a491-1869a60d2dea	2026-01-02 04:19:24.968+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
53a2488a-e521-4298-ad54-74664b6683c2	83628072-328b-47e0-8ba2-f056d4f2ed16	2026-01-02 04:19:24.98+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
f46b31bf-96f7-40b4-a1d1-4f7301a2a2df	25aee2f6-a2a3-4287-b842-a185b82a8541	2026-01-02 04:19:24.991+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
98cc4a3f-01c4-4a42-a345-7b943b189686	2587e56b-160d-40ce-b21d-2ba90e84d241	2026-01-02 04:19:25.003+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	9e842bbc-3f8a-4bf7-a513-52b407158ec8	\N	Marea importada de seguimiento 2025 (JSONL)
173968e2-d91c-4800-953c-e751d7cfdcba	1f3e8257-874b-4932-8792-9c454fa422a3	2026-01-02 04:19:25.009+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
b97c75e3-1057-4574-898d-acf55306498d	83dd63f4-c066-458b-a6da-9edc38a9fe26	2026-01-02 04:19:25.019+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
b053ed0c-49a1-4a68-a882-1b631260b529	72e6712e-ddab-42e8-ae4d-be6ecfb5ee72	2026-01-02 04:19:25.029+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
62c6efc8-9a94-4cc2-bf1c-fbb21041d0f4	3bbc5d6b-70f5-4218-bc38-de20f1cf4b73	2026-01-02 04:19:25.037+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
fdefc450-c60e-4a0e-b266-93ba896df7ab	49e5655b-f23e-4c54-ad63-9cfe43c4fa1a	2026-01-02 04:19:25.047+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
e7d4563f-cc11-4e7f-a400-1ca75c1fe443	015d8a13-b003-4ddd-aa8b-ceb86c9ef01f	2026-01-02 04:19:25.061+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
343ec96d-4033-48e4-b5f8-ba5d2479d851	d04acea6-bb81-4df7-987b-2a7fea86daeb	2026-01-02 04:19:25.069+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	9e842bbc-3f8a-4bf7-a513-52b407158ec8	\N	Marea importada de seguimiento 2025 (JSONL)
dcad5c57-9fc9-42f2-a596-a5cebdbd2cd5	22f4427e-459a-49d0-8920-f69da80e74a2	2026-01-02 04:19:25.074+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	9e842bbc-3f8a-4bf7-a513-52b407158ec8	\N	Marea importada de seguimiento 2025 (JSONL)
426ea2f1-9497-41b9-833d-ccd9f81d79c6	3c3b3d46-5b45-4bcb-9e54-9d7030cb9ab6	2026-01-02 04:19:25.081+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
19fb2f27-321f-48bf-929d-b6fcedd60581	69829eb3-6e89-4777-96c1-27ca6ceb3102	2026-01-02 04:19:25.098+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
d61a5740-f445-409b-bd40-3785eb60cff9	948e77d9-9fc1-4856-8d1f-b6ddd2a05a87	2026-01-02 04:19:25.107+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
34c29a27-27cf-4183-b00f-5b04549ab98e	bd233eae-2e8c-4e90-b7b2-013dff740a5b	2026-01-02 04:19:25.118+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	9e842bbc-3f8a-4bf7-a513-52b407158ec8	\N	Marea importada de seguimiento 2025 (JSONL)
9277bbe2-5ad6-44ff-ac79-e16e8ef3a0cd	3876b93f-8552-4cc8-8e71-c15d64a4f323	2026-01-02 04:19:25.123+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
a0884f07-bcbc-485c-a74b-73a160042760	266a7a5b-f577-4564-8b75-310122576126	2026-01-02 04:19:25.133+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
a68839c8-789c-4006-89c3-4b387288b89e	9d0dc0d9-7db9-4bf7-8fda-1285aabc6b87	2026-01-02 04:19:25.155+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	9e842bbc-3f8a-4bf7-a513-52b407158ec8	\N	Marea importada de seguimiento 2025 (JSONL)
49a55825-0f7c-45f3-ac9f-58cff6793419	2162635d-b565-4fcb-b404-61d5de99d95d	2026-01-02 04:19:25.162+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
30ec632e-6360-4e4f-8c91-4011c7fc2c8b	0919bfa7-0558-4b7d-8122-f2caafb08588	2026-01-02 04:19:25.173+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
11453166-2fd6-41fc-9354-eaf3d036ba09	d84fd437-5160-492a-b8a8-103b5caae44b	2026-01-02 04:19:25.183+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
bf803bf7-aae3-4137-85e8-57fd1d42a51f	00d11d10-4274-470a-b9f5-6315c05d93e8	2026-01-02 04:19:25.191+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
4c70620b-6816-4f0e-ae15-2177f5ea483f	8808f7c4-a7b2-475c-b85b-b68f7efb61b3	2026-01-02 04:19:25.201+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
dafb5fcf-37c8-44b7-877c-3cf4d774a778	3e8c5a71-a3ab-4c15-a46d-afdd3c3e7d3c	2026-01-02 04:19:25.208+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
c8451e43-fca8-4a98-a402-c6f5302c2225	6e85361f-4afc-49c7-b8e5-3d74bf205cea	2026-01-02 04:19:25.221+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	9e842bbc-3f8a-4bf7-a513-52b407158ec8	\N	Marea importada de seguimiento 2025 (JSONL)
6956f770-bf69-4474-8c80-8870aaabcd96	038c26ab-f15d-47c8-b407-bb6826b94d95	2026-01-02 04:19:25.228+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
1dfce682-f4dd-4f24-aa1f-437699795dcb	b08c6e26-6286-4705-9a28-f14390445a3c	2026-01-02 04:19:25.245+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	9e842bbc-3f8a-4bf7-a513-52b407158ec8	\N	Marea importada de seguimiento 2025 (JSONL)
a809b2fd-9724-42f7-8fe9-85686a4466fb	a188071c-1585-4114-870b-1d736d93c06c	2026-01-02 04:19:25.252+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
0e78c977-7d3d-4083-8a42-e874fa02b73b	1b59329b-f1fa-4d25-bf45-0eda5c5231bb	2026-01-02 04:19:25.262+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
082a5d44-f949-45a8-9505-5856399ff5bb	1b5f5dd1-4d44-4a96-b9c8-be6d997701cb	2026-01-02 04:19:25.273+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
961dfb8c-eeba-4cf6-98a4-932b8c1737da	d1328495-407b-4571-9af1-9196a99fd36f	2026-01-02 04:19:25.282+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
7d4b3b79-a428-49f9-afbe-93b860fe7045	0d729d64-4ca8-45da-91dc-db6dcf50f256	2026-01-02 04:19:25.297+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
ad2f8081-8e09-4d17-b5fd-9c7a3eb935fa	b27ec34e-69b4-41fd-8567-a790079d4237	2026-01-02 04:19:25.306+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	9e842bbc-3f8a-4bf7-a513-52b407158ec8	\N	Marea importada de seguimiento 2025 (JSONL)
6cfd5de3-3462-441f-8725-9b673fb46a08	680df353-e954-4fb7-8456-34b4079b4c0b	2026-01-02 04:19:25.312+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
8338e7e5-fa08-49cd-aaee-6fd31c1d950d	44db0a64-7cda-45d9-a591-d6cbb4043178	2026-01-02 04:19:25.321+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
dadf23d9-f387-497a-b6d7-3be976fff59e	2945cc7f-2aca-4f7c-b266-eb7122fb1444	2026-01-02 04:19:25.33+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
188c2d6b-bb94-402b-aad8-ed57e3a3a608	1cf8819c-e930-40e2-9342-2e0c2c48405c	2026-01-02 04:19:25.339+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
f38e6514-2be6-4f8d-b258-973c2cfa22ee	80be0449-30ed-4e47-b8fa-ad0848454784	2026-01-02 04:19:25.349+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	9e842bbc-3f8a-4bf7-a513-52b407158ec8	\N	Marea importada de seguimiento 2025 (JSONL)
98026bed-9143-4f2d-837b-6228a8a10546	fd608d4a-9691-480c-a66b-7fe2d502004d	2026-01-02 04:19:25.355+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
217e6a88-ebe8-4ba8-b328-aae8f40d9e52	de491046-dccf-453f-bbc0-c89860e7764a	2026-01-02 04:19:25.373+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
5de31b2d-de80-4437-9811-d8dfe139f77b	36ba1f84-2c6a-4b31-aadf-c47a9904f06c	2026-01-02 04:19:25.382+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	9e842bbc-3f8a-4bf7-a513-52b407158ec8	\N	Marea importada de seguimiento 2025 (JSONL)
9d81ddcd-5110-473b-9a0b-9c7a2336363c	5e442efa-4476-47ab-a7a2-1f81504113a7	2026-01-02 04:19:25.387+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
09020418-2db4-4cfe-99e2-eb843222729f	c16688d8-83d6-42c3-ae8f-b75bfa2a28a6	2026-01-02 04:19:25.396+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	4a3cf5f6-2ec8-4f78-b2eb-5c9b17db9806	\N	Marea importada de seguimiento 2025 (JSONL)
ed2c9131-bdd0-4620-8885-57a8388304f2	2f9745f0-eaef-44bd-aef5-72ea10ce8be7	2026-01-02 04:19:25.403+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	9e842bbc-3f8a-4bf7-a513-52b407158ec8	\N	Marea importada de seguimiento 2025 (JSONL)
ca8be874-cb19-424f-8073-2c5029f6c919	8496aae7-2b41-439f-9ed5-186c6e114119	2026-01-02 04:19:25.41+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	4a3cf5f6-2ec8-4f78-b2eb-5c9b17db9806	\N	Marea importada de seguimiento 2025 (JSONL)
53c1b0e8-5ad7-4462-bce6-e680a5996fc0	1bd372d2-f873-495b-b66a-941067841d1f	2026-01-02 04:19:25.417+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
4c644552-9cb7-4e2e-abb7-9af6de6c5e86	bb456c1a-e2fe-4e03-ae57-3adfb8681203	2026-01-02 04:19:25.425+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
fff1c9d4-08d2-4cf3-afa6-6f18f3d37aa2	7fb67a35-4676-46f3-b698-954d9bea9cee	2026-01-02 04:19:25.432+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	9e842bbc-3f8a-4bf7-a513-52b407158ec8	\N	Marea importada de seguimiento 2025 (JSONL)
938974be-5029-432b-a67a-0e1134bb0959	8281216e-fdfe-4368-af6d-b48fa9609ada	2026-01-02 04:19:25.439+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	9e842bbc-3f8a-4bf7-a513-52b407158ec8	\N	Marea importada de seguimiento 2025 (JSONL)
f42d4ad2-606d-4861-9acc-f64565ad5b1e	d368c857-e5ea-4cc6-933b-64ba617c4ac0	2026-01-02 04:19:25.445+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
1e6e5aa2-694c-409f-ae87-96f76bb77a69	e5d71da1-4001-4ba6-b121-936a651da2f9	2026-01-02 04:19:25.453+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
a4361ba6-3d9d-4bec-9638-2732ee6d1cdd	61fe27ee-4898-40f8-98a4-d32e4a2a8536	2026-01-02 04:19:25.461+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
341b5aa5-77ac-4bb1-9e29-6820c7de78f1	b7426674-3f2c-4a4c-9a4f-e7146d60e410	2026-01-02 04:19:25.47+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
9598ed6d-72e1-4b93-8ccb-4041b5007fe9	481e3865-eace-4520-a915-f584e9355de8	2026-01-02 04:19:25.485+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
221cb6bd-691d-40ee-8907-57271f36f843	1198157e-c560-48f8-91b5-88c39657263d	2026-01-02 04:19:25.494+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
03412046-7422-4a63-957c-b171d2e67370	85982da0-6c28-4603-9a5e-a74e37cca9a7	2026-01-02 04:19:25.504+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
be1c0a92-2fd4-4ba8-a53a-d4faf2a7d417	3d5d53e3-d77c-40de-9508-ca70065f8325	2026-01-02 04:19:25.515+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
b893408c-23ff-4f9c-92ed-4fa7585251eb	cd084c95-8409-4338-b00e-99ed8ba0c350	2026-01-02 04:19:25.524+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
362e8907-790d-4704-9ed6-8d93250dbbcb	5d3763ef-61c7-4470-87b8-be5021a584b7	2026-01-02 04:19:25.534+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
a29fb5ee-e745-4c1b-b091-a81efd405a65	d79f80b8-d3b9-42f5-a574-c840d12cea8c	2026-01-02 04:19:25.544+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
899d1b47-6122-4b9b-a459-06f9e10b332d	95bc983e-3238-4a9b-9e19-dc53b73b7f7a	2026-01-02 04:19:25.561+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
131a2f98-27ae-46b2-917d-10e5b7994b12	5735520b-7d2d-4e43-b7b2-acdfe1c69e11	2026-01-02 04:19:25.573+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
21c0b1a4-c2f2-4c8d-a057-67e8b62ec4e1	ba84396b-5e22-4bcb-929c-387b034b8a06	2026-01-02 04:19:25.582+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
f074ae18-a7be-476d-96ed-6710a90db7c4	d43dbd70-39e1-430c-987b-5dcf959e86f5	2026-01-02 04:19:25.598+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
95184014-4364-46c2-84fb-1edeaea98651	9995bba3-cbe4-44cd-b6d5-e22223274d62	2026-01-02 04:19:25.61+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
a2197d4c-9c01-4ca5-a738-dadb42639e43	57385038-9502-41b5-86dd-7ac2eae7a5d1	2026-01-02 04:19:25.619+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
8815d16e-0866-4521-a9a7-e4883e5a97fe	b62ecaa0-fd79-48c8-8569-570fa30e818f	2026-01-02 04:19:25.626+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
ca6981aa-eaf7-40ca-8a57-282639de93d2	a6f84194-71dc-466c-b59c-eab1cbce865d	2026-01-02 04:19:25.635+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
0f3641c2-32a0-47bb-8fc1-876dc4e49c12	e88de7bb-0465-4ac8-90d7-bc391de87668	2026-01-02 04:19:25.643+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	4a3cf5f6-2ec8-4f78-b2eb-5c9b17db9806	\N	Marea importada de seguimiento 2025 (JSONL)
ea24ae4f-f983-4f98-8b83-1c25eb352aba	62cc7d5e-a399-40e8-8833-ba833a2d20e4	2026-01-02 04:19:25.652+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
6a06d66d-b0d3-4654-ad59-2a6b6b54fc10	2425ece4-d097-489e-bbaa-a8a823f55a21	2026-01-02 04:19:25.665+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
321c8edb-55e6-4404-8c13-49ccce3f3d92	85c313a1-678c-4a4d-bf67-abe2e1de5228	2026-01-02 04:19:25.674+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
de46c2eb-3626-4acf-967b-b4dad4bbc059	b91c643f-517a-4829-9c38-a2a29b3bca53	2026-01-02 04:19:25.683+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	4a3cf5f6-2ec8-4f78-b2eb-5c9b17db9806	\N	Marea importada de seguimiento 2025 (JSONL)
4553fb38-7bff-45c3-8c6f-c606983a5d11	1c553365-664b-4fcd-9300-a310c35fc7ad	2026-01-02 04:19:25.691+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
198b80f5-842a-4a06-bf3f-e7570462d29e	ef4ae89d-c2dc-459c-86a9-cdff84f35abe	2026-01-02 04:19:25.701+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
7c58bd51-fa13-4251-ad5b-4a879646b44b	dfaa58d2-5af4-4f37-b45c-a32b1dfaa7a3	2026-01-02 04:19:25.708+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
084a914d-6be4-4473-a33c-1e51c1c5a409	463b364f-33e2-4d87-83ee-b81450c72c57	2026-01-02 04:19:25.718+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
061b600e-6081-4226-822e-7a3d7d616c4f	62b60e1e-af54-47c2-90eb-c6a1da894a67	2026-01-02 04:19:25.726+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
62359b8d-0279-4aa2-9ef0-7cdce01331ac	4b8a9636-1f50-4937-9173-336dff78d13d	2026-01-02 04:19:25.734+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
25411110-5bf7-4d3e-8a4e-56c6b4a83458	2450ccd1-2512-40e9-8c62-f2b4db5236be	2026-01-02 04:19:25.742+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
17ff2be1-5b2e-4489-bc8d-748968168704	01e2eed6-b176-4e5e-a9f6-6b150a7c4f91	2026-01-02 04:19:25.751+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
ab7092ae-4693-4a69-b98c-0e3b6e280d62	522e84d3-cfd8-4209-b2e9-b7d7813d69d6	2026-01-02 04:19:25.76+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
928d649e-993e-4955-9c6a-12b6ab1a7844	0832ca2f-72dd-46ec-bf85-58ad0aeb5ee2	2026-01-02 04:19:25.769+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
8cccd630-d38c-426f-a42e-12e8f5e899e0	99ce6f70-8be7-4592-871d-a313f8a1def8	2026-01-02 04:19:25.776+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
050cc9d4-71d7-49bb-bc70-1ec07e92b26f	9fabf937-de6c-4586-bbe1-d68fa3fd1046	2026-01-02 04:19:25.786+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
f50a90ce-86a3-4f7a-a31d-50b78a37e32b	f061bef3-492a-453e-b4ac-bda56b649be0	2026-01-02 04:19:25.807+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
77390410-0eec-4ade-920a-8fe06c6ccf76	c73e2490-d4b3-4782-b40d-cfea53c2fbe0	2026-01-02 04:19:25.816+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
71b54cc4-b5ff-4627-a7a7-85829ad8139f	a8130766-0d49-41e8-aae2-04c262cdefc1	2026-01-02 04:19:25.825+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
a482fddd-4384-4b47-9c28-2ede95974dd9	146597b1-3b39-4d7b-b3b0-724bb85ed86d	2026-01-02 04:19:25.839+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
8fd9f8fd-c35e-4357-9312-d3398cfd9b1f	1cb8f85f-72e1-4126-a81f-605eab9ad6c6	2026-01-02 04:19:25.846+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
22e88c86-059e-4900-9c1f-0adf8d0fc53f	84b85110-8a86-4ab5-b80c-5134f0830829	2026-01-02 04:19:25.854+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
8dc37549-19c8-4d3b-9cec-a13f90d606b6	e84d19de-5da7-4519-9cf5-910dd890b329	2026-01-02 04:19:25.863+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
9a40069f-e2a4-4283-b8cb-4b55ea4984a1	e5e47077-b892-4a42-bb7e-f45048793af0	2026-01-02 04:19:25.871+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
ee816697-9768-484b-abb6-4634200bf4f7	69405fcc-9a8e-42d2-8574-6404373393a6	2026-01-02 04:19:25.887+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
515b5b23-90f7-4f16-bfe1-aa279659beed	35e9cc11-ace6-4638-b0e1-eb36f0d896fe	2026-01-02 04:19:25.896+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
e26d78f9-4153-4113-9553-7df1870ccdb4	78bdc139-080d-4e4d-9e2a-02851296e818	2026-01-02 04:19:25.911+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
59df274d-0517-4c0f-97d2-6942179ade56	5601b2a1-cd89-442d-8254-98fea8c1824f	2026-01-02 04:19:25.918+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
8a122df7-a34c-414e-9edb-537b15006972	626a325b-8661-42b5-93c0-3bf7c90281b0	2026-01-02 04:19:25.926+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
e95c3ebf-7fb6-4e7a-9631-e568f04113b6	5769495e-7955-4b1a-ad82-62ea28c617eb	2026-01-02 04:19:25.931+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
a07a3176-e78e-45e3-ab5c-3f25062b0be3	3387128a-2001-4de4-ad54-2f427c84a439	2026-01-02 04:19:25.941+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	0110f7f6-ebaf-4012-b288-d4e3a34d7c58	\N	Marea importada de seguimiento 2025 (JSONL)
0b5b8cad-7ad6-40d7-b654-3588ffa2b067	f99a005f-da47-4c0f-bef8-d0fcce618569	2026-01-02 04:19:25.947+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	0110f7f6-ebaf-4012-b288-d4e3a34d7c58	\N	Marea importada de seguimiento 2025 (JSONL)
17cfd185-b0eb-4924-ab93-c631ff080416	e53a943d-a94b-4d32-94f5-211c7eb2ba7e	2026-01-02 04:19:25.953+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	0110f7f6-ebaf-4012-b288-d4e3a34d7c58	\N	Marea importada de seguimiento 2025 (JSONL)
fbb382b0-70b5-4ef2-b367-e118f75706e7	282918f1-73ef-4b02-b0ec-1762bb379527	2026-01-02 04:19:25.958+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	8cb0d0cc-d503-4208-a4da-0f37841c9e86	\N	Marea importada de seguimiento 2025 (JSONL)
67100f4a-ab32-43e8-909a-246a97d9e826	d0b2d1e1-0726-4270-bf2d-29252c7f4a3c	2026-01-02 04:19:25.968+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	0110f7f6-ebaf-4012-b288-d4e3a34d7c58	\N	Marea importada de seguimiento 2025 (JSONL)
e257b848-8e6a-4b40-9746-9d817477314e	9f5a6248-f6e5-4af4-807a-0f8ecb6081a3	2026-01-02 04:19:25.974+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	0110f7f6-ebaf-4012-b288-d4e3a34d7c58	\N	Marea importada de seguimiento 2025 (JSONL)
63967c44-c226-4d36-a342-7bb9fe26d774	b835a7fc-ba5d-4204-b081-ffc0c6062835	2026-01-02 04:19:25.982+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	4a3cf5f6-2ec8-4f78-b2eb-5c9b17db9806	\N	Marea importada de seguimiento 2025 (JSONL)
2ff187d9-10c7-449c-9512-eab5cee9f29f	313f9e8d-b3ff-44e8-a18d-cafba58c8633	2026-01-02 04:19:25.989+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	4a3cf5f6-2ec8-4f78-b2eb-5c9b17db9806	\N	Marea importada de seguimiento 2025 (JSONL)
08fe4a5b-bda3-429c-a45b-b97a571956c2	7f169611-4c23-4493-a6c4-d7b801ea22d0	2026-01-02 04:19:25.996+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	4a3cf5f6-2ec8-4f78-b2eb-5c9b17db9806	\N	Marea importada de seguimiento 2025 (JSONL)
d9a1d382-9ce5-4bdb-a41d-1d1b62a3404e	4685550e-bc39-4ce7-8e3c-bfe78c0eb550	2026-01-02 04:19:26.003+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	4a3cf5f6-2ec8-4f78-b2eb-5c9b17db9806	\N	Marea importada de seguimiento 2025 (JSONL)
d0c3d9f9-9f0a-41a9-b28b-3d5ff5c66102	64f6fef2-2ad6-4b87-b123-ce957413327e	2026-01-02 04:19:26.008+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	4a3cf5f6-2ec8-4f78-b2eb-5c9b17db9806	\N	Marea importada de seguimiento 2025 (JSONL)
dd36462a-312f-4811-a88f-102924578228	3acd6cd1-c16b-4aff-b0e8-4ece4b6242b6	2026-01-02 04:19:26.015+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	4a3cf5f6-2ec8-4f78-b2eb-5c9b17db9806	\N	Marea importada de seguimiento 2025 (JSONL)
08efebd0-1972-478a-85cc-a80af0c159d2	b29e16b0-d3ed-4bc9-8d9b-fd120936a2cf	2026-01-02 04:19:26.022+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	4a3cf5f6-2ec8-4f78-b2eb-5c9b17db9806	\N	Marea importada de seguimiento 2025 (JSONL)
4ebab62b-e1c6-4632-aa32-32659b9dcc60	21248cd4-d199-4c9e-b66d-486560b78ad7	2026-01-02 04:19:26.028+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	4a3cf5f6-2ec8-4f78-b2eb-5c9b17db9806	\N	Marea importada de seguimiento 2025 (JSONL)
c283e976-8da2-4158-984e-cbb0b500c1a1	8ce9abef-0766-4392-b743-2f89ed3d5605	2026-01-02 04:19:26.035+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	0110f7f6-ebaf-4012-b288-d4e3a34d7c58	\N	Marea importada de seguimiento 2025 (JSONL)
c7ae6963-c769-458c-9753-3219ca83a9c3	b4e0080e-8ffc-424b-852d-999c63e0e44d	2026-01-02 04:19:26.042+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	4a3cf5f6-2ec8-4f78-b2eb-5c9b17db9806	\N	Marea importada de seguimiento 2025 (JSONL)
4afc7c04-cad6-4a52-9c05-a70c448d6db6	d0061bcf-3c71-4b48-9a89-339295ea8a8f	2026-01-02 04:19:26.047+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	4a3cf5f6-2ec8-4f78-b2eb-5c9b17db9806	\N	Marea importada de seguimiento 2025 (JSONL)
25efd700-862b-411f-8f4c-c1692c91aeb5	5a962b38-3431-4b27-acb7-1b151637772d	2026-01-02 04:19:26.054+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	4a3cf5f6-2ec8-4f78-b2eb-5c9b17db9806	\N	Marea importada de seguimiento 2025 (JSONL)
165eb8af-c8f0-41a4-89ce-487a8eef1346	d83a8713-78fd-4a3b-ba65-3b81fae4e3cd	2026-01-02 04:19:26.061+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	4a3cf5f6-2ec8-4f78-b2eb-5c9b17db9806	\N	Marea importada de seguimiento 2025 (JSONL)
ddc1e03a-16b5-419f-8425-657d6c83b023	f79b70da-a1cc-478e-b274-9f90c832d055	2026-01-02 04:19:26.067+00	c048e295-762b-4d27-9c9c-e652e47ca1bd	CREACION	\N	4a3cf5f6-2ec8-4f78-b2eb-5c9b17db9806	\N	Marea importada de seguimiento 2025 (JSONL)
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

COPY public.observadores (id, codigo_interno, nombre, apellido, foto_url, tipo_observador, tipo_contrato, activo, disponible, fecha_proxima_disponibilidad, observaciones) FROM stdin;
01f4a0f8-05f3-4e74-a235-a302423a3971	7845	Alexia	Aguilar	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
f9f703d5-ea13-4725-8d1b-24343e9a735a	7724	Eduardo Esteban	Aguilar	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N
41a00bb5-0597-49e2-93b5-e12900dd330b	5501	Gustavo Luis	Alvarez Colombo	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
9a453f6d-1fee-4a05-8aec-bc93fab5ec47	7847	Gianfranco	Alvarez	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
21cc61cc-50fd-41b8-bbb8-c9994f12242b	7655	Claudio Daniel	Arroyo	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
d947086c-8d9e-4dbc-862c-83012ebf47d9	7610	Raul Bernardo	Bargas Peña	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N
37f44c94-ad13-45ba-8027-3680034e9afa	7761	Julian	Bastida	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
ffbc3f24-d4a2-4f54-b112-781ccbfc219e	7851	Alvaro	Benitez	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
5ca4557f-1813-4e29-a254-1d4a2ca862c6	7799	Matias	Biondini	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
f73aafc7-cc70-4ffd-bbf2-71bccd08cdf5	5513	Hugo Daniel	Brachetta	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
e375f5fd-349c-4631-be16-7230d4e8387c	7709	Ignacio Matías	Bruno	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
bbae4d55-b474-4190-8482-b3f41534a682	7841	Nicolas Agustin	Caballero	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
2a0e1127-b45f-46ab-ad71-061fbecfedb0	5516	Ariel Gustavo	Cabreira	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
8cba376d-aa9e-4774-8f32-8f8f31a0ea34	5517	Gustavo Andrés	Cadaveira	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
33c55788-e56c-4085-93a7-0d286852c2a8	5520	Maria Silvana	Campodonico	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
45a41838-d70a-4bc7-809c-1b576c77b64a	7149	Gustavo	Cano	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N
3cc98a61-236d-49c7-9ddc-d7c61f17db5f	7830	Agustin	Carrizo	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
9fdf8243-cc28-4d74-9e2a-ec0608e15f33	4206	Federico José	Castro Machado	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
03990088-afd6-4c5e-997d-4aae1dcb30b2	7725	José María	Catuogno	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
32e1cb60-223c-4031-b866-5281236c236e	9464	Omar Ernesto	Cauteruccio	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
e504b07e-916b-4670-a17c-0a6ce13daf4e	7611	Cristian Emmanuel	Cerrina	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N
eeac2bca-a24c-4458-b820-9c5a9b49cdcb	7843	Johnatan	Challier	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
8a2029cc-9578-4147-a948-6e79349cebe1	9448	Lia Soledad	Chavarria	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
61b72305-0437-4d6b-a073-940e8cda4abf	9457	Alejandro Diego	Clemente	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
f69c66a3-934b-4e74-8f9d-af12a1feb18a	7726	Juan José	Coppa	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N
fe96642e-1c00-452f-917f-ca212b976e2d	7852	Camila	Corti	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
fcac0722-3bbd-4d27-8fdd-c8f57cd0f05b	8022	Juan	De La Garza Gonzalez	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
4bcd5cbc-813c-4bb2-a30a-28fd4c4a9e28	7833	Santiago	Delage	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
0a3e2f51-fa56-40e8-a9d7-b08bebb8f381	7828	Fabian Eduardo	Desojo	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
ef4833b0-6801-4546-81c1-7003bc6008f8	7150	Angel Salvador	Di Leva	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
226de0d1-ea56-4c31-9937-d65b2401300f	9465	Daniel Alejandro	Di Tullio	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N
3b3183c0-39ad-4a56-b844-4a1d0c740a2e	9430	Ronaldo Jordán	Diaz	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
e3be9b74-1515-4085-8a68-91c88e078f27	7743	Carlos Ireneo	Escalante	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
ba2c688c-5956-4fd4-bc2e-3d556964bbe1	9450	Mariana	Escolar	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
07da7dc2-e85f-450c-82bc-160a9efe5c8d	7612	Richard Javier	Espinola Gysin	\N	OBSERVADOR	1109	t	t	\N	\N
f241cf8e-0770-40a5-956d-7e0bb25fb955	171	Mateo Andrés	Fernandez	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
95362000-ccd4-4707-bc92-15ef550017ed	7836	Marcos Nicolas	Ferrero	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
cbf2c0da-2e38-4ff9-9614-5b693d1e5e69	5534	Carla Alejandrina	Firpo	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
6e888aec-8e0e-4324-a572-bddedaf115aa	7727	Nicolás Alberto	Flores	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
0e7cee67-f8cd-4035-be66-240e6d411fb3	7798	Marcelo Simon	Freyre	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N
6c9ad5d4-0ab5-445b-8faa-9779bbf19bf2	7798	Marcelo Simón	Freyre	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N
1759b867-5407-4820-96e6-9a7c3f7c8c99	7377	Esteban Nicolás	Gaitan	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
64fa30e1-339e-4d84-952f-99af6a5d27f8	7728	Adrian Pascual	Galluzzo	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
8f347d0d-4813-4100-bf95-187da9c22ed2	7314	Lautaro	Garcia Salvi	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
14e21a14-17ce-4794-bfb1-c651ed022818	7613	Federico Nicolás	Garcia	\N	OBSERVADOR	1109	t	t	\N	\N
c408015c-e534-43ef-9b05-3073f5e79b90	7854	Gisele	Garcia	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
2a94b9ce-4654-4b97-a43d-43d29ba25247	4195	Julio Cesar	Garcia	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
ae9b52fe-650a-4573-a465-8674bbd10dbb	7859	Melisa	Garcia	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
1d803758-7f28-415d-9b20-dca5fa459f1c	9442	Sebastian	Garcia	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
0e7e4e53-a522-43fa-a6a7-4ae80303f9ab	7844	Sebastían Roque	Garcia	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
4486accd-625c-4c7f-aac7-72f231f7a756	5537	David Alejandro	Garciarena	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
c94e6db1-32bf-47da-969b-7e4289aba5ea	7842	Gabriel Osvaldo Catriel	Gimenez Salinas	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
ad0c03ae-c279-416b-81a2-d02593ad9d76	7831	Leandro Federico	Giumelli	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
8f04654d-a7bf-4a09-bf80-b5961dcc8399	7729	Walter Alejandro	Glavina	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N
42b9e9a1-ae10-48dc-a782-ca47465644fe	7832	Maximiliano Adrian	Godoy	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
35917453-f41b-4e8d-8e75-6a889c9aea81	7848	Diego	Gorosito	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
3f200fba-1ae2-4fb9-9d34-1420aa476930	7615	Mauricio Romualdo	Guevara	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
3d3ea7ed-0af4-4e46-8b18-d95970f9a95a	7730	Carlos Daniel	Herrera	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N
72775eb6-a79b-42d0-95fd-6e117ed0cf5b	7616	Jorge Guillermo	Herrera	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N
05f4d1f9-6d12-4b47-8bab-b67d85f13994	5543	Susana Noem¡	Herrera	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
934ce400-4bd2-4183-b881-1b873c6942cf	7731	Daniel Domingo	Incaurgarat	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
96f4fcac-9f27-439b-83af-f04fee85ec2a	5549	Pablo Salvador	Izzo	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
c451b0e3-5e03-439d-b903-5e2304e92989	7617	Leonardo Marcos	Kren	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
63205447-f698-42f9-9c0e-0bf5e0b40238	9462	Hugo Pablo	Lertora	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
35fb80ba-6a00-4c92-9ae1-e5f14104330b	7834	Vanesa Karina	Llancafield	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
86d87d1a-b565-437c-b106-353f56e324a4	187	Juan Pablo	Luna	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
c74cf10b-e4bd-411d-921d-83a2252f066a	7732	Valeria Gertrudis	Mango	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
cc4c97d8-0cb1-4140-a011-b3b72c0afc62	7839	Vanesa Cintia	Manlla	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
6db7d727-1630-4720-a222-9db87569b7e5	7829	Marcelo Javier	Marcell Prado	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
386e87a1-3845-4435-9c10-68a84ffb0f32	7620	Diego Sebastian	Marchiori	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N
e483342f-b74f-420a-84b4-9cfa31dbacec	7621	Luis Gabriel	Martinez Tecco	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N
6e358b63-2675-42b3-83ba-8cbb14031224	7853	Luciano	Matte Casietto	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
24ea6f16-329c-42ec-a185-d38490e7c24b	7393	Andrea Cecilia	Mauna	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
cae02a92-ce6c-44ee-8236-c158789157e9	7733	Maria Lucila	Maydana	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
192a2eee-9ee7-4ccc-97fd-71c00fdbb3a9	9461	Alejandro José	Mazzei	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N
82dffde9-0a6b-44f5-8ff0-976eacffec92	7753	Leonardo Marcos	Merlo	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
57617318-b420-47d5-b7e0-f822deeb645d	7807	Juan Maximiliano	Migliaccio	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
2bc232b7-f16c-4411-b932-70396216f5a1	188	Juan Manuel	Minaglia	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
ba45cd4d-cf7b-4948-b24c-e56aea99b66e	9467	Pablo Julian	Miranda	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N
5b7fd0f9-c939-4560-a671-e8a4fe552a12	9468	Guillermo Pablo	Monjeau	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
d478255b-bd2e-43c4-b6fe-174035912849	7734	Nicolás	Montanelli	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
81d7c1bc-4350-429a-8d54-95a2bcddfde4	7850	María Laura	Monterisi	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
aa490ee5-30e3-4181-b413-03fd665a8448	7627	Jorge Luis	Morales	\N	OBSERVADOR	PLANTA PERMANENTE	t	t	\N	\N
7ec5adb8-1245-415b-9df3-d890fc9a9833	9469	Pablo Martin	Moreno	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
67b3e5c2-687f-4a90-a8cf-e3bf89e25f00	7767	Claudio Alberto	Nadal	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N
761c3eb9-c5f7-46ac-8f50-240ee4eb7298	7735	Sergio Fabian	Najle	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
414b0c66-0031-4403-9e75-bbf02e820c58	2021	Claudio	Noale	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N
532f29c5-e90e-4121-85c1-05ac6c505281	7737	Alejandro Andrés	Pappi	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
e6005312-85de-4319-8ca1-dbceaa15915c	7855	Nicolas	Pereyra	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
db94ebf2-648d-4390-a8ba-d8b2087750a8	9470	Germán Eduardo	Pi Dote	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
ff52ec85-ffce-4023-abaf-042c9bacc97c	42	Roberto Martin Eusebio	Piñero	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
a48c09de-7229-477d-a993-0f8175d3f165	4234	Rubén Alcides	Piñero	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
0b9a4a10-a144-4387-84ce-e5ededfd4100	9480	Cristian Oscar	Piriz	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N
0b596cc9-198c-43c7-b522-08925ce451be	7711	Sebastian	Pisano	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
e1145258-fcce-4b3c-8f2a-50d94400b405	7849	Leonardo	Prado Escobar	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
5afb95a1-5838-406a-b0c4-26f786068df5	9459	Raúl Antonio Ceferino	Puliafito	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
f9544d76-1527-44fc-a8ca-e19e971fab2d	9452	Cesar Andrés	Ramirez Mitchell	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
4f04d022-95d2-42c6-aeb2-2b236c45780f	7860	Nahuel	Ramirez	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
4bbb4d5f-0f3a-4963-abb1-4d10fd371fbe	9460	Pablo Alejandro	Ramos	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
ec4efd97-0b3e-4bfd-9519-3c4048625df9	7624	Teresa Beatriz	Reinaga	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N
e75c8a00-0570-46ec-a267-aa18e6e9c2bd	4196	Amilcar Claudio	Remaggi	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
0b1b33fb-f68d-4871-a0a8-1d5214086531	9451	Jorge Fernando	Repetto	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
dec0ebe8-ed58-41e3-882b-56317c66194e	7846	Oriana	Retamar Mendez	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
cfbfae0b-1540-4c9f-bc2e-4d28b2c70780	9436	Cecilia Micaela	Riestra	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
cbb02cfb-559e-4348-a494-7b3ee41f76b2	9471	Estanislao	Rodriguez Fulco	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N
78868333-1c99-4178-9fab-135c35825fb7	7835	Francisco Tomas	Rodriguez	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
290c6cec-6563-4e53-b911-08673e597209	4177	Ricardo Roberto	Roth	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
6ccc32a8-fe12-48fb-8422-62546ea0751c	5574	Norberto Alfonso	Scarlato	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
b58c3f79-5f47-40dd-a3db-4fbd5b020e4e	7796	Fernando Alberto	Schwartz	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
19e492bd-fe01-4202-a938-4d03074e7309	9437	Juan Matias	Schwartz	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
81b9256e-a360-462c-b68b-f53ead8702ee	7762	Andrés Martín	Shoobridge	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
e881013d-b3f0-498a-88a1-ee9621e34f87	7625	Eduardo	Silvester	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N
bc2edae5-079b-493a-8316-bf6ef0617449	7364	Juan Pablo	Simonazzi	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
028b70bc-01ea-4fe0-b443-ae93351e6329	8002	Julio Roberto	Sinconegui	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
bd62e84e-50f9-4fe2-b968-810b2ebc2241	9473	Norma Beatriz	Sorache	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
94c71dc6-0ae5-4e57-ba53-84d292db1856	7740	Leonardo Luis	Spagnuolo Rey	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N
daa8ef1e-481e-4b97-a071-56141bac9d06	7838	Nicolas Facundo	Staneff Rotela	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
5cd79891-c469-4b7c-8cae-df0ccc5587b6	9474	Juan Manuel	Staneff	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N
6dea1154-5c8e-43d0-af2d-54eadffae9c7	9475	Darío Nicolás	Terren	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
36f0c903-b264-4795-90e6-a6ec91f2ddce	7742	Héctor Luis	Teves	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
1a8f9fff-06b6-45a0-8989-693614307d68	7776	Gonzalo	Troccoli	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N
a3111e90-a565-442d-bbbd-ef70d6e1c9c4	4236	Federico Mauro	Vazquez	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
37a3512b-aa82-4d54-936e-2f44f68ad030	4202	Adrian	Vega	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
20bf77d1-c2c7-403e-a6f9-c8ed57310ee9	4208	Pedro Pablo	Ventura	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
7a8621e4-12e7-4828-9e96-0a39cf136820	9476	Héctor Eduardo	Vera	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N
852c90ac-50be-4689-8354-64a13a1af123	7837	Axel Uriel	Villabona Del Valle	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
1e45f5a8-379e-4d1c-b437-2604a8c67386	181	Rubén Dario	Villabona	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
b3984836-6993-401f-852b-a1901917e09e	9453	Juan Martin	Villafañe	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
aecbca5b-79e1-4bd7-b4bd-fa0f165b6fde	7840	Durbal	Villalba	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
5cc47ebb-ba9f-425d-82b2-05708cf300dd	7744	Javier	Villalba	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
504759f5-6f2e-414b-ba69-c95352e9d644	193	Julian	Webb	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
5009dd41-be2a-4f3f-bfe7-7070822975e7	9477	Veronica Fabiana	Zanti	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
12a20a57-4334-4e4a-b2f8-5fa8939e5d91	7875	Leonardo Ezequiel	Andrade	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
6a25c197-b738-4b40-bfe7-a11477e6bed0	7873	Lucas David	Carabeta	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
34f724cf-787b-4b12-9d98-e10a24b9a3c7	7865	Gabriel Alejandro	Dumrauf	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
0a809aae-c790-4049-bb75-9e58f359e0c7	7862	Christian Enderson	Fenco Chavesta	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
b2eb6727-bbec-469c-88a2-aca7541e4d91	7869	Sergio Gastón	Frontera	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
bdd34d2a-d86d-45d4-8004-6afdf4846cd4	7868	Lucas Oscar	Gaona	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
4b5bbb67-11b7-4425-b1c0-1ab2c6669385	7871	Sergio Javier	Gomez Mapiz	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
37e40d65-a40a-4a4b-b0b8-1b7cb77b979e	7874	Morena Aylen	Ledesma	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
6c3f65a7-14be-41cf-9e7f-317f930e3cf9	7876	Walter Alejandro	Leon	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
3bf15f32-0fe0-4fff-801c-85b6ca0473db	7867	Cintia Daiana	Magrini Quiroga	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
c2114d04-d45c-45c7-8b57-893e6e417aea	7877	Catalina	Mariño Turdera	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
7290ead2-a96c-4209-b52c-7b976ad4cb04	7879	Lucía	Martinez Ta	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
2f51e43e-88aa-4d9c-91b8-8a0851bcc05d	7861	Daiana Anabella	Molina Riquelme	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
b4c99e4e-aa73-4a0d-9d22-3970f321eaca	7900	Paola Alejandra	Navarro Grassi	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
8a1fc8b9-53f2-4e18-b284-7043ba6a825a	7870	Joaquín Jorge Hernán	Ojeda	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
2a14fb72-0773-4975-b56c-4099552162a2	7864	Manuel Agustín	Palos	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
c5633268-9d01-400c-806b-6ad37968f44f	7863	Daniel Enrique	Ramunno	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
9a7bd7a5-07d5-4a3e-bd95-01cfdbebe328	7872	Juan Francisco	Rodriguez Fulco	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
531d760e-72f2-4fcf-8821-96b6a50d2d50	7866	Francisco German	Sette	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N
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
133f1846-588a-43cc-a5e3-a103d7be5e6d	ABADEJO	Abadejo	\N	Peces	\N	t
6125e3c4-2ec9-4919-9b57-05c54ca2864b	ANCHOITA	Anchoíta	\N	Peces	\N	t
146e1cbf-393c-462b-9cca-74b0c78f439d	CABALLA	Caballa	\N	Peces	\N	t
3b938974-38a9-4b5b-ac50-a88465f7a025	CALAMAR	Calamar	\N	Moluscos	\N	t
f4dfbae3-8a9b-4e7a-acba-439207f86b95	CENTOLLA	Centolla	\N	Crustáceos	\N	t
1c1f245c-1079-42a0-a6a8-1db4ac5845d4	AUSTRALES	Especies australes	\N	Peces	\N	t
b0113ae4-988a-4010-a1cf-f72572ea68fb	LANGOSTINO	Langostino	\N	Crustáceos	\N	t
bc86d2a9-3de5-494d-91aa-207e2eadbe81	MERLUZA_COMUN	Merluza común	\N	Peces	\N	t
a3d52a88-3e07-46f5-b2f4-4c885f36886b	MERLUZA_NEGRA	Merluza negra	\N	Peces	\N	t
5524fead-8510-4189-91a2-ac7d39675ece	VIEIRA	Vieira	\N	Moluscos	\N	t
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
8f7c8fb0-0fcf-4f7f-9059-7e8697a33e55	Buenos Aires	\N	\N	12	\N	f	t	\N	\N	-34.58333	-58.38334
eabf0a0f-2651-44c9-acf6-455211f14711	Rio Grande (brasil)	\N	\N	20	\N	f	t	\N	\N	-32.13334	-52.08333
65f069e9-6a63-4449-a122-0d9d1690bf90	Montevideo	\N	\N	XX	\N	f	t	\N	\N	-34.9	-56.2
0ff2c880-8556-4411-90d8-fc37fcc0aa5a	Samborombon	\N	\N	21	\N	f	t	\N	\N	-35.73333	-57.31667
5125814e-d1d8-4080-b61e-b925b98daed2	San Clemente	\N	\N	14	\N	f	t	\N	\N	-36.33333	-56.78333
5d12df00-152b-43e6-8ba0-20067e3bac8c	Mar Del Plata	\N	\N	1	\N	t	t	\N	\N	-38.06667	-57.55
13ed8383-6409-4a7b-ac3f-3977786457bc	Quequen	\N	\N	2	\N	f	t	\N	\N	-38.58333	-58.7
700d1050-2d8c-4c23-a7ea-d73eecb7ec63	Bahia Blanca	\N	\N	3	\N	f	t	\N	\N	-38.75	-62.16667
32f4d427-8deb-47c5-ab65-5f038dfd61d6	Bahia San Blas	\N	\N	15	\N	f	t	\N	\N	-40.55	-62.23333
6db9804f-a2e7-4f42-bdb9-9b3e17c3449f	San Antonio Oeste	\N	\N	9	\N	f	t	\N	\N	-40.73333	-64.96667
597dcf62-8939-4357-8a60-467698161f74	Viedma	\N	\N	22	\N	f	t	\N	\N	-40.9	-62.86666
9e675114-d5e6-449e-a20c-9688499c3c00	Puerto Madryn	\N	\N	4	\N	f	t	\N	\N	-42.76667	-65.05
b0b3126f-6cd0-4ab9-91db-f70b14747ee8	Rawson	\N	\N	7	\N	f	t	\N	\N	-43.33333	-65.06667
24e034f3-b46f-4741-b261-712c7cd6cf23	Bahia Camarones	\N	\N	11	\N	f	t	\N	\N	-44.8	-65.73333
a5ac3578-1196-4340-92cd-02a78d856d6f	Comod, Rivad,	\N	\N	6	\N	f	t	\N	\N	-45.88334	-67.5
7ff00861-3590-483a-af07-403ab85afd72	Caleta Olivia	\N	\N	16	\N	f	t	\N	\N	-46.43333	-67.53333
c0480dd3-e309-4e6d-8620-661c4fdfe0c7	Deseado	\N	\N	5	\N	f	t	\N	\N	-47.76667	-65.91666
9d5fb57e-3468-45a9-a6c2-fd4274acbb4b	San Julian	\N	\N	17	\N	f	t	\N	\N	-49.31667	-67.73333
3653f6ef-adac-4f2e-be36-4a5d904641bd	Punta Quilla	\N	\N	23	\N	f	t	\N	\N	-50.11666	-68.41666
45dc90fd-9596-4f37-ab30-13fef34a6c65	Rio Gallegos	\N	\N	19	\N	f	t	\N	\N	-51.63334	-69.2
c86100f2-ae86-47fd-999d-36b482dc11fc	Ushuaia	\N	\N	10	\N	f	t	\N	\N	-54.83333	-68.3
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
6cadfcb1-5dd7-4563-9fae-04561513659c	FRESQUERO	Fresquero	\N	\N	t
d9041427-00b4-42b8-8306-9d6e7b9bc16f	TANGONERO	Tangonero	\N	\N	t
b509832f-10d9-4f7d-b71e-5bd4ecf88b38	CONGELADOR_MERLUCERO	Congelador Merlucero	\N	\N	t
5d1dd7c7-56f5-4cb6-aed9-2a48de316c1b	POTERO	Potero	\N	\N	t
6cee615f-2f06-4187-ae28-3c9e9d5584cf	PALANGRERO	Palangrero	\N	\N	t
f0d24fb4-83ea-4789-9472-c0e2371654bb	CONGELADOR_ARRASTRERO	Congelador Arrastrero	\N	\N	t
401c7d42-1de7-41b7-820a-948b432b72eb	CENTOLLERO	Centollero	\N	\N	t
c9ef52ca-9e27-4d02-aed4-e2e6f8f31b7f	VIEIRERO	Vieirero	\N	\N	t
6fdf97a3-2f73-4a74-956b-414b0ca85b33	COSTERO	Costero	\N	\N	t
ec991fe3-facd-4b3a-9721-af02673136d1	INVESTIGACION	Investigación	\N	\N	t
ec55ad96-050b-4968-a508-4d438deab9f6	SURIMERO	Surimero	\N	\N	t
ffd6bec1-d077-453b-859b-c422e7e00e62	RAYERO	Rayero	\N	\N	t
d3857412-6a2e-47ef-82e8-ecd2ded34e55	CONGELADOR_AUSTRAL	Congelador Austral	\N	\N	t
ec3c9169-b5ef-475f-bcbe-9f0b08dce26e	CONGELADOR_GENERICO	Congelador Genérico	\N	\N	t
\.


--
-- Data for Name: transiciones_estados; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.transiciones_estados (id, id_estado_origen, id_estado_destino, accion, etiqueta, clase_boton, requiere_observaciones, activo) FROM stdin;
a1d30620-5850-4acc-badd-92c187cbb04c	4a3cf5f6-2ec8-4f78-b2eb-5c9b17db9806	0110f7f6-ebaf-4012-b288-d4e3a34d7c58	REGISTRAR_INICIO	Registrar Inicio	primary	f	t
62ee2b1e-3455-4e57-a419-dd536db229bd	0110f7f6-ebaf-4012-b288-d4e3a34d7c58	0affe6e4-4fca-4011-8606-6eb0643e9cdf	REGISTRAR_ARRIBO	Confirmar Arribo	primary	f	t
f22335b8-597b-41dc-99bc-626f69ff1880	0affe6e4-4fca-4011-8606-6eb0643e9cdf	5af97c65-4364-4085-a6e5-3807312aec25	RECIBIR_DATOS	Recibir Archivos	primary	f	t
f34c3d21-6d6f-428b-8413-f8cdd9bdb66d	5af97c65-4364-4085-a6e5-3807312aec25	9c1c031c-56fd-4583-a104-4b0d37f4941b	INICIAR_VERIFICACION	Iniciar Verificación	primary	f	t
34c6a266-befa-48d1-8c6c-8bec5bc8ecf3	9c1c031c-56fd-4583-a104-4b0d37f4941b	120e521e-7df3-4130-a9c8-eee8406b6aba	ABRIR_CORRECCION	Abrir Corrección	secondary	f	t
dbf7ad66-53f3-4e83-ac5f-f2d57ca2f22c	9c1c031c-56fd-4583-a104-4b0d37f4941b	f060d79c-f2d3-46b5-9018-6587ae0f0623	PASAR_A_INFORME	Pasar a Informe	primary	f	t
53d789c7-a650-443e-aabf-36acd9315a37	120e521e-7df3-4130-a9c8-eee8406b6aba	f060d79c-f2d3-46b5-9018-6587ae0f0623	FINALIZAR_CORRECCION	Finalizar Corrección	primary	f	t
744a11cf-02c0-4f1e-b780-bbf9ea83722b	120e521e-7df3-4130-a9c8-eee8406b6aba	eaee25a3-07dc-4706-90e7-24f4eebb044c	DELEGAR_EXTERNA	Derivar a Proyecto	secondary	f	t
3ce8b221-7b7b-40de-ac5d-507c2459f49f	eaee25a3-07dc-4706-90e7-24f4eebb044c	120e521e-7df3-4130-a9c8-eee8406b6aba	RETORNAR_CORRECCION	Devolución Externa	primary	f	t
40522445-e0e7-4c2a-b286-17cb482bcbfd	f060d79c-f2d3-46b5-9018-6587ae0f0623	f96f365a-fc17-46eb-a9c8-78d50ecc26b8	ENVIAR_A_REVISION	Enviar a Revisión	primary	f	t
08f22389-db8f-4271-a8df-71b2285071c3	f96f365a-fc17-46eb-a9c8-78d50ecc26b8	f819f491-2e55-477a-8be2-7603bf1a812c	APROBAR_INFORME	Aprobar Informe	primary	f	t
22064b53-2b69-45d1-b414-d6643f81d2ef	f96f365a-fc17-46eb-a9c8-78d50ecc26b8	f060d79c-f2d3-46b5-9018-6587ae0f0623	RECHAZAR_INFORME	Observaciones en Informe	secondary	f	t
0752c838-dd14-4f5b-a24e-76e80a1e0819	f819f491-2e55-477a-8be2-7603bf1a812c	cc08b7fa-33f2-4205-9c71-8cb080b8c531	INICIAR_TRAMITE	Iniciar Protocolización	primary	f	t
57fc1b0f-31bb-44ab-9361-cc7105409203	cc08b7fa-33f2-4205-9c71-8cb080b8c531	8cb0d0cc-d503-4208-a4da-0f37841c9e86	FINALIZAR_PROTOCOLIZACION	Finalizar Protocolización	primary	f	t
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, email, password, "fullName", "isActive", roles, "themePreference", "avatarUrl") FROM stdin;
c048e295-762b-4d27-9c9c-e652e47ca1bd	admin@obs.com	$2b$10$9K73O5/HHkZ1a.OirWF.q.p.ySp1nKu7mHrFvRTdpRhm7uqjWe7TS	Administrador Sistema	t	{admin}	system	\N
9a70e920-8232-4e71-8ffd-90af8bef84c8	coordinador@obs.com	$2b$10$9K73O5/HHkZ1a.OirWF.q.p.ySp1nKu7mHrFvRTdpRhm7uqjWe7TS	Coordinador Operativo	t	{coordinador}	system	\N
a48766ab-2bb1-4b71-8c59-6174c679d4ac	tecnico@obs.com	$2b$10$9K73O5/HHkZ1a.OirWF.q.p.ySp1nKu7mHrFvRTdpRhm7uqjWe7TS	Técnico de Datos	t	{tecnico_datos}	system	\N
6f694651-9cd8-40df-ab2b-07eca77598da	asistente@obs.com	$2b$10$9K73O5/HHkZ1a.OirWF.q.p.ySp1nKu7mHrFvRTdpRhm7uqjWe7TS	Asistente Administrativo	t	{asistente_administrativo}	system	\N
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

