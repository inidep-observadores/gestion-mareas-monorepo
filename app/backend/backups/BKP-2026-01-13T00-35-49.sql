--
-- PostgreSQL database dump
--

\restrict AoCplFftqznf6deE34oECPJPsVrkyjTMMGqk0i2Yrqe3bmHdn3QYaKVQupk0uv7

-- Dumped from database version 15.15
-- Dumped by pg_dump version 15.15

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
-- Name: alertas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.alertas (
    id uuid NOT NULL,
    codigo_unico text NOT NULL,
    referencia_id text,
    tipo text NOT NULL,
    titulo text NOT NULL,
    descripcion text NOT NULL,
    estado text NOT NULL,
    prioridad text NOT NULL,
    fecha_detectada timestamp(6) with time zone NOT NULL,
    fecha_vencimiento timestamp(6) with time zone,
    fecha_cierre timestamp(6) with time zone,
    asignado_id uuid,
    creado_por_id uuid,
    ultima_actualizacion timestamp(6) with time zone NOT NULL,
    metadata jsonb,
    referencia_tipo text
);


ALTER TABLE public.alertas OWNER TO postgres;

--
-- Name: alertas_eventos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.alertas_eventos (
    id uuid NOT NULL,
    alerta_id uuid NOT NULL,
    fecha_hora timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    usuario_id uuid,
    tipo_evento text NOT NULL,
    detalle text
);


ALTER TABLE public.alertas_eventos OWNER TO postgres;

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
    activo boolean DEFAULT true NOT NULL,
    codigo_numerico integer NOT NULL
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
-- Name: vw_mareas_completas; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.vw_mareas_completas AS
 WITH etapas_formateadas AS (
         SELECT me.id_marea,
            me.nro_etapa,
            to_char((me.fecha_zarpada AT TIME ZONE 'America/Argentina/Buenos_Aires'::text), 'DD/MM/YYYY'::text) AS zarpada,
            pz.nombre AS puerto_zarpada,
            to_char((me.fecha_arribo AT TIME ZONE 'America/Argentina/Buenos_Aires'::text), 'DD/MM/YYYY'::text) AS arribo,
            pa.nombre AS puerto_arribo
           FROM ((public.mareas_etapas me
             LEFT JOIN public.puertos pz ON ((me.id_puerto_zarpada = pz.id)))
             LEFT JOIN public.puertos pa ON ((me.id_puerto_arribo = pa.id)))
        )
 SELECT m.id,
    m.anio_marea,
    m.nro_marea,
    m.tipo_marea,
    concat(m.anio_marea, '-', lpad((m.nro_marea)::text, 3, '0'::text), '-', m.tipo_marea) AS codigo_marea,
    b.nombre_buque AS buque,
    em.nombre AS estado,
    e1.zarpada AS zarpada_1,
    e1.puerto_zarpada AS pto_zarp_1,
    e1.arribo AS arribo_1,
    e1.puerto_arribo AS pto_arrib_1,
    e2.zarpada AS zarpada_2,
    e2.puerto_zarpada AS pto_zarp_2,
    e2.arribo AS arribo_2,
    e2.puerto_arribo AS pto_arrib_2,
    e3.zarpada AS zarpada_3,
    e3.puerto_zarpada AS pto_zarp_3,
    e3.arribo AS arribo_3,
    e3.puerto_arribo AS pto_arrib_3,
    e4.zarpada AS zarpada_4,
    e4.puerto_zarpada AS pto_zarp_4,
    e4.arribo AS arribo_4,
    e4.puerto_arribo AS pto_arrib_4,
    e5.zarpada AS zarpada_5,
    e5.puerto_zarpada AS pto_zarp_5,
    e5.arribo AS arribo_5,
    e5.puerto_arribo AS pto_arrib_5,
    e6.zarpada AS zarpada_6,
    e6.puerto_zarpada AS pto_zarp_6,
    e6.arribo AS arribo_6,
    e6.puerto_arribo AS pto_arrib_6,
    e7.zarpada AS zarpada_7,
    e7.puerto_zarpada AS pto_zarp_7,
    e7.arribo AS arribo_7,
    e7.puerto_arribo AS pto_arrib_7,
    e8.zarpada AS zarpada_8,
    e8.puerto_zarpada AS pto_zarp_8,
    e8.arribo AS arribo_8,
    e8.puerto_arribo AS pto_arrib_8,
    e9.zarpada AS zarpada_9,
    e9.puerto_zarpada AS pto_zarp_9,
    e9.arribo AS arribo_9,
    e9.puerto_arribo AS pto_arrib_9,
    e10.zarpada AS zarpada_10,
    e10.puerto_zarpada AS pto_zarp_10,
    e10.arribo AS arribo_10,
    e10.puerto_arribo AS pto_arrib_10,
    to_char((m.fecha_creacion AT TIME ZONE 'America/Argentina/Buenos_Aires'::text), 'DD/MM/YYYY'::text) AS fecha_registro
   FROM ((((((((((((public.mareas m
     LEFT JOIN public.buques b ON ((m.id_buque = b.id)))
     LEFT JOIN public.estados_marea em ON ((m.id_estado_actual = em.id)))
     LEFT JOIN etapas_formateadas e1 ON (((m.id = e1.id_marea) AND (e1.nro_etapa = 1))))
     LEFT JOIN etapas_formateadas e2 ON (((m.id = e2.id_marea) AND (e2.nro_etapa = 2))))
     LEFT JOIN etapas_formateadas e3 ON (((m.id = e3.id_marea) AND (e3.nro_etapa = 3))))
     LEFT JOIN etapas_formateadas e4 ON (((m.id = e4.id_marea) AND (e4.nro_etapa = 4))))
     LEFT JOIN etapas_formateadas e5 ON (((m.id = e5.id_marea) AND (e5.nro_etapa = 5))))
     LEFT JOIN etapas_formateadas e6 ON (((m.id = e6.id_marea) AND (e6.nro_etapa = 6))))
     LEFT JOIN etapas_formateadas e7 ON (((m.id = e7.id_marea) AND (e7.nro_etapa = 7))))
     LEFT JOIN etapas_formateadas e8 ON (((m.id = e8.id_marea) AND (e8.nro_etapa = 8))))
     LEFT JOIN etapas_formateadas e9 ON (((m.id = e9.id_marea) AND (e9.nro_etapa = 9))))
     LEFT JOIN etapas_formateadas e10 ON (((m.id = e10.id_marea) AND (e10.nro_etapa = 10))));


ALTER TABLE public.vw_mareas_completas OWNER TO postgres;

--
-- Name: product_images id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_images ALTER COLUMN id SET DEFAULT nextval('public.product_images_id_seq'::regclass);


--
-- Data for Name: _prisma_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public._prisma_migrations (id, checksum, finished_at, migration_name, logs, rolled_back_at, started_at, applied_steps_count) FROM stdin;
e8a8a362-549f-45a4-ba3d-9c10e31f0983	bee2d9194450fade8ac383ea904036fa4501a35691f5ef28ac880cb243e9542c	2026-01-05 21:08:20.087583+00	20251229225926_12_29	\N	\N	2026-01-05 21:08:19.953261+00	1
d05e48ab-15fa-43d2-99b4-f109dc81b211	7c22e6609bd096f6d7685581ed6b0b0c909a2d3104bf8ff3e96db1edf0cd3bb9	2026-01-05 21:08:20.097899+00	20251230150045_add_avatar_url	\N	\N	2026-01-05 21:08:20.089841+00	1
4c603350-8c3f-4d50-bd64-f99252c081a8	b9df2356f4381c60b052a3d5c737ea565277ea9c44679c10655975920ba8bed9	2026-01-08 22:16:31.571505+00	20260108221631_add_alerts_system	\N	\N	2026-01-08 22:16:31.320141+00	1
6f303351-a12f-4dd0-aec3-0ddcd8823e15	f8d58daf8546149005be90b9ba66a9d52b21c9265cfda82318ed41d088617c90	2026-01-05 21:08:20.335273+00	20251230191649_catalogos	\N	\N	2026-01-05 21:08:20.100018+00	1
eae1b50f-64f8-4501-b168-1564f8c292b0	20782ee2558020848026db9764e810d05ed583e58ef4b90e6f1f57fff37b6d95	2026-01-05 21:08:20.345629+00	20251230204050_add_lat_long_to_puerto	\N	\N	2026-01-05 21:08:20.337348+00	1
3e4b7b20-147e-4b83-b6a0-3283c4faf71c	3f6a3eeec854410c2fa19cd829635de8cb23d6ffaed54387dd55b6959f2f05c2	2026-01-05 21:08:20.783189+00	20251231125007_add_all_entities_from_docs	\N	\N	2026-01-05 21:08:20.348134+00	1
1c0d9458-41b3-4ca7-b6ac-eb0fe4905b06	c3fb092bd7a64c95f235a205dba47d468afedc94c067cd5bd086923ebf4caf95	2026-01-09 02:47:00.140737+00	20260109024700_add_alert_origin_fields	\N	\N	2026-01-09 02:47:00.115788+00	1
4654f794-b2be-4313-8969-80184e59f939	81be05cceb7597afbb2840c400faecf2b5fd61e65687f7a695be09cba98d455a	2026-01-05 21:08:20.795372+00	20251231132736_rename_arte_pesca_descripcion_to_nombre	\N	\N	2026-01-05 21:08:20.785261+00	1
61fb0f9b-5cfb-4bb0-a7af-95b66d139200	3a21f64efb9cf9508a6ff148ac6b033bc42d41588d8d68135fb54b30c1bb8110	2026-01-05 21:08:20.819029+00	20251231150715_add_error_log	\N	\N	2026-01-05 21:08:20.797527+00	1
696d4880-48ac-45c0-bbce-a0ff23f75615	89ed15d6aa634c93d45242c899f5b2aa30f99a773bba53dee8fe8f2db7cb0286	2026-01-05 21:08:20.830389+00	20251231184904_add_tipo_marea_to_marea	\N	\N	2026-01-05 21:08:20.821319+00	1
37fade3e-ecea-43d4-b773-bc422451a79b	d1edc3031b9b430b7238f437901f78a353b8393e584e3c1caf16a5e1cd8ae2bc	2026-01-10 00:59:31.557019+00	20260210120000_remove_marea_title_description	\N	\N	2026-01-10 00:59:31.536908+00	1
1c1a743d-7fa9-48d9-b858-283c6c496830	0c567b6e5e77e88ce15785b78a5c9a847a472fb02c6041fb3c8561467ed2668a	2026-01-05 21:08:20.92767+00	20260101195946_add_transiciones_y_etapa_observadores	\N	\N	2026-01-05 21:08:20.833202+00	1
33b09aec-ab58-47df-81e7-70d68eadf959	9e20adc7e25e0838dc4a5888731d36d34ad52efbe4315a7a1d0e12657d032e45	2026-01-05 21:08:20.950162+00	20260103155245_add_unique_constraints_port_observer	\N	\N	2026-01-05 21:08:20.930169+00	1
ee25a298-e887-4b7d-b28a-028923a98dea	a886c52f1483408c8070d0ba8300408c5c7d49722267e0908cb8b5363721733c	2026-01-05 21:08:20.965945+00	20260103165415_update_observadores	\N	\N	2026-01-05 21:08:20.952472+00	1
c39ec1c1-a4c0-4ba7-84cc-15e410abe472	db0abb03f097cbd63f5e267b520478efae9b1a3c837432baaf8544e4eb3e23f6	2026-01-05 21:08:20.996208+00	20260105153905_create_view_mareas_completas	\N	\N	2026-01-05 21:08:20.96836+00	1
e6e9ec0e-eee7-4b66-b6d6-a42045ad714a	1ffcbfaeb847cf650c645a3f3eb73febf9856279abc1d72ca4e7a95b0836d31b	2026-01-05 21:09:12.904644+00	20260105210912_add_tipo_flota	\N	\N	2026-01-05 21:09:12.882956+00	1
\.


--
-- Data for Name: alertas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.alertas (id, codigo_unico, referencia_id, tipo, titulo, descripcion, estado, prioridad, fecha_detectada, fecha_vencimiento, fecha_cierre, asignado_id, creado_por_id, ultima_actualizacion, metadata, referencia_tipo) FROM stdin;
\.


--
-- Data for Name: alertas_eventos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.alertas_eventos (id, alerta_id, fecha_hora, usuario_id, tipo_evento, detalle) FROM stdin;
\.


--
-- Data for Name: artes_pesca; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.artes_pesca (id, codigo_numerico, activo, nombre) FROM stdin;
989ce1c1-31ae-4374-abc8-cd39ccc23254	2	t	Red de arrastre de fondo
6c705ba8-cb55-4249-814d-f9d03dbf2a5c	6	t	Red de arrastre de media agua
f1a7ed0c-3094-423b-bd9e-5d97a5435888	3	t	Red de lampara
1e01b18b-61dc-4dae-b9c0-4a4d7e9cd9bd	5	t	Espinel
64da4a89-d80c-42f4-82bc-794b08d05837	4	t	Red de enmalle
a1d8e5c7-ae8e-4d4a-9c44-c815753d4fe6	18	t	Red agallera de deriva
300e8934-6a93-46e3-a1b9-1e48cf0b8d91	16	t	Palangre de fondo
cdfd4e76-c9fa-46bf-8db5-8a5382670295	1	t	Red de cerco
98fe3b71-b32c-43b0-af0d-c661dcf70f03	19	t	Red Bongo 300
5855dc88-bba1-431d-8357-d64c3e258e4a	20	t	Red Bongo 500
56306d33-522f-4b43-b9e1-b4750cc12564	21	t	Red Nakthai
fbfc5d32-d2ae-43f9-8e51-f7e2b5373129	22	t	Red Isaac-Kidd
115e0c4a-b8a6-427b-88f0-57831cbd74a6	7	t	Rastra
0b70bd03-5c83-4f70-8194-1242c9686c6b	8	t	Nasa
dafb47d1-ec73-4522-92ab-db6f7d136d13	9	t	Linea
bf936278-3e0e-43dd-9621-a41fc432dc12	10	t	Raño
7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	11	t	Poteras
07f92e0d-24d0-408a-a8ed-ccc9f2b0a7d5	12	t	Red de fondeo
d08faf9b-60a9-4081-b8ea-ca931995905b	13	t	Trampa centollera
08c82cf9-7632-48ff-bc68-de0f882f16bb	14	t	Red de arrastre de fondo con tangones
fb0c9511-96a6-4a70-ad7a-d42506723559	32	t	Currican
582a2779-15d8-4cd2-a008-50a23c100caa	15	t	Red de arrastre de fondo en pareja
0fd42cc3-d377-4e00-aac7-f5d229233528	80	t	Otros
95c612d2-29b4-469f-81d9-194c87344ae4	0	t	Sin Especificar
6f3f8d5f-f639-4516-8dd1-667b2bfe831a	90	t	No Identificado
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
ef099e2f-049e-4d72-bffc-a6163bf241a1	ALDEBARAN	01741	1038	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	26.42	426	1fcba1f2-fbf3-4489-b379-286b21f99fd8	PESQUERA SAN ROQUE	Mar del Plata		480-0573	\N		\N	\N		t	\N	\N	\N
7a6a88e8-ae3f-41b7-9d39-28378b5c5d62	ALTALENA	0181	1051	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	55.80	1350	1fcba1f2-fbf3-4489-b379-286b21f99fd8	MARONTI  S.A.	Mar del Plata	4800005		\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi	t	\N	\N	\N
b3514f69-cb6b-460d-ba7e-af630dcb65da	ALVAREZ ENTRENA I	02454	1055	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	39.43	988	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
ef438bb4-763e-4203-8448-42ea9d91ebf5	ALVAREZ ENTRENA II	02465	1056	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	39.50	988	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
dd6bc0f4-871f-4cdf-9717-79abedd359ee	ALVAREZ ENTRENA III	02379	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	\N	\N	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
ba0e587e-32a8-43b4-87f5-1d63a05d5e2d	BAFFETTA	02635	0	f66f75bd-9f71-42a6-a319-b9aecc608960	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	19.45	295	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
96ea4c08-9bf1-461a-8786-e75a6294bf55	ALVAREZ ENTRENA VI	01	2774	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	30.50	1033	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
f4522506-af2d-4ec0-a117-2888050915aa	AMBITION	01324	\N	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	PESQUERA TRES MARIAS  S.A.	Mar del Plata		480-0336	\N		\N	\N		t	\N	\N	\N
8adaf55b-8d2e-4403-90ca-0db212a2eaad	ANITA	3	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	\N	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	SOLIMENO	Mar del Plata			\N		\N	\N		t	\N	\N	\N
957adeb7-4e5d-4a50-bcb9-26b3115b1b39	ANA III	278	1069	f66f75bd-9f71-42a6-a319-b9aecc608960	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	19.95	443	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	POSEIDON  S.A.	Puerto Madryn		0280-445-7786	\N		\N	\N		t	\N	\N	\N
92cc69f1-56bc-4164-b27e-839b4cb092b5	ANABELLA  M	0175	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	60	\N	\N	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	PESCAPUERTA ARGENTINA  S.A.	Puerto Madryn		0280-445-4407	\N		\N	\N		t	\N	\N	\N
2eb261d6-3a02-44b5-9330-0ca6d5fc4b45	ANDRES JORGE	1065	2760	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	50.10	1102	1fcba1f2-fbf3-4489-b379-286b21f99fd8	MARONTI  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
57a620a8-bc51-4cae-8b59-fe74b0091bb2	ANGELUS	01953	1087	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	52.60	1337	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	PESQUERA CRUZ DEL SUR  S.A.	Ciudad Autónoma de Buenos Aires		011-4784-1760	\N		\N	\N		t	\N	\N	\N
d389a8de-1624-44b7-bb7f-1be51670ff51	ANITA ALVAREZ	02138	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	\N	\N	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
80afef5c-3ce5-4d7c-a4e4-d14c6079005a	ANTARTIC  I	0232	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	300e8934-6a93-46e3-a1b9-1e48cf0b8d91	\N	60	\N	\N	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	ESTREMAR  S.A.	Ciudad Autónoma de Buenos Aires		011-6533-7853 / 4345-1102	\N		\N	\N		t	\N	\N	\N
02161a23-a56f-4494-a86f-ad44c83230ff	ANTARTIC II	0263	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	300e8934-6a93-46e3-a1b9-1e48cf0b8d91	\N	60	\N	\N	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	ESTREMAR  S.A.	Ciudad Autónoma de Buenos Aires		011-6533-7853 / 4345-1102	\N		\N	\N		t	\N	\N	\N
78dad9a4-75b8-46c8-a20f-4df02c776c1b	ANTARTIC III	0262	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	300e8934-6a93-46e3-a1b9-1e48cf0b8d91	\N	60	\N	\N	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	ESTREMAR  S.A.	Ciudad Autónoma de Buenos Aires		011-6533-7853 / 4345-1102	\N		\N	\N		t	\N	\N	\N
edd52169-c0b0-43e8-b0d4-71d096c1828f	ANTARTIDA	0678	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	60	\N	\N	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	IBERCONSA  DE ARGENTINA  S.A.	Puerto Madryn	4891227	0280-445-4324	\N	serviciosmaritimosmdq@gmail.com	\N	\N	Servicio Maritimo Integral	t	\N	\N	\N
41a61294-f728-4578-977d-86c31e90ef62	ANTONINO	0877	1099	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	27.60	541	1fcba1f2-fbf3-4489-b379-286b21f99fd8	AGLIPESCA  S.A.	Mar del Plata		480-2886	\N		\N	\N		t	\N	\N	\N
ce547e0d-f287-43c9-8fb6-81511555fd97	ANTONIO ALVAREZ	01429	1100	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	36.60	1168	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
5da2ffd8-3c85-433f-948e-f4517844a29b	API II	0679	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	60	\N	\N	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	IBERCONSA  DE ARGENTINA  S.A.	Puerto Madryn		0280-445-4324	\N		\N	\N		t	\N	\N	\N
f04100f9-54e7-4f7c-89c6-206f35a711af	API IV	0680	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	60	\N	\N	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	IBERCONSA  DE ARGENTINA  S.A.	Puerto Madryn		0280-445-4324	\N		\N	\N		t	\N	\N	\N
5b88aa92-993e-4e67-af07-fed31d8f4f5c	API V	02781	2711	49f1a6b1-610e-4aab-98e6-45dbe753fe22	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	60	77.40	2960	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	IBERCONSA  DE ARGENTINA  S.A.	Puerto Madryn		0280-445-4324	\N		\N	\N		t	\N	\N	\N
52ffe641-5390-4882-9884-47227907e8bc	API VI	02812	2734	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	40	36.35	1201	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	IBERCONSA  DE ARGENTINA  S.A.	Puerto Madryn		0280-445-4324	\N		\N	\N		t	\N	\N	\N
88efd36d-e7a9-4a1d-b0c2-14c6e6ae1759	API VII	03081	2777	49f1a6b1-610e-4aab-98e6-45dbe753fe22	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	60	72.20	0	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	IBERCONSA  DE ARGENTINA  S.A.	Puerto Madryn		0280-445-4324	\N		\N	\N		t	\N	\N	\N
009921f3-0fa0-4af4-854b-ac3a88f3fad4	ARBUMASA X	6183	1114	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	35.30	1087	caf4d1b5-7a3c-445b-98f9-42d842f1d347	ARBUMASA  S.A.	Puerto Deseado		0297-487-2807 / 444-5338 / 444-1201	\N		\N	\N		t	\N	\N	\N
707e7433-8d6d-4a14-9bf9-3285f3528459	ARBUMASA XIX	06440	1117	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	36.40	870	caf4d1b5-7a3c-445b-98f9-42d842f1d347	ARBUMASA  S.A.	Puerto Deseado		0297-487-2807 / 444-5338 / 444-1201	\N		\N	\N		t	\N	\N	\N
1f01b00c-f838-413f-bcc3-1fc1d76a6c32	ARBUMASA  XVII	0216	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	\N	\N	caf4d1b5-7a3c-445b-98f9-42d842f1d347	ARBUMASA  S.A.	Puerto Deseado		0297-487-2807 / 444-5338 / 444-1201	\N		\N	\N		t	\N	\N	\N
4baefab8-1971-4d8d-9d1b-e069f6d5eb69	ARBUMASA XIV	0213	1116	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	36.40	1047	caf4d1b5-7a3c-445b-98f9-42d842f1d347	ARBUMASA  S.A.	Puerto Deseado		0297-487-2807 / 444-5338 / 444-1201	\N		\N	\N		t	\N	\N	\N
f18f5aef-2646-47ad-8b3f-ac91a2251139	ARBUMASA XV	214	1118	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	36.40	870	\N	ARBUMASA  S.A.				\N		\N	\N		t	\N	\N	\N
7e0b8183-60b9-4a1d-a085-91d872076484	ARBUMASA XVI	0215	1119	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	36.40	1047	caf4d1b5-7a3c-445b-98f9-42d842f1d347	ARBUMASA  S.A.	Puerto Deseado		0297-487-2807 / 444-5338 / 444-1201	\N		\N	\N		t	\N	\N	\N
1f605b27-29a9-48e6-8055-da7a0512949a	ARBUMASA XXIX	02561	1126	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	65.60	1776	1fcba1f2-fbf3-4489-b379-286b21f99fd8	BAL - FISH  S.A.	Mar del Plata		489-6522	\N		\N	\N		t	\N	\N	\N
d2fa5b8e-6edb-4679-a21f-f3250e6d71fc	ARBUMASA XXVI	01958	1127	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	62.80	2403	caf4d1b5-7a3c-445b-98f9-42d842f1d347	ARBUMASA  S.A.	Puerto Deseado	4893758	0297-487-2807 / 444-5338 / 444-1201	\N	miguel-visoso@hotmail.com	\N	\N	Agencia Maritima Solvox	t	\N	\N	\N
f796bbda-66f5-4fcb-bea4-dafdb086a6d5	ARBUMASA XXVII	02057	1128	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	64.21	1154	1fcba1f2-fbf3-4489-b379-286b21f99fd8	BAL - FISH  S.A.	Mar del Plata		489-6522	\N		\N	\N		t	\N	\N	\N
c5c3c325-4a69-4a8d-9f57-5c65006da37a	ARBUMASA XXVIII	02569	1129	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	64.40	1776	caf4d1b5-7a3c-445b-98f9-42d842f1d347	ARBUMASA  S.A.	Puerto Deseado		0297-487-2807 / 444-5338 / 444-1201	\N		\N	\N		t	\N	\N	\N
7889535c-0d03-4848-a510-62c9e2ec7a58	ARCANGEL	79	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	CALME  S.A.	Mar del Plata		480-3545	\N		\N	\N		t	\N	\N	\N
21209053-16fa-445e-9abf-1d0399197970	ARESIT	02265	1134	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	36.26	1085	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	HARENGUS  S.A.	Puerto Madryn	4808331/4808332	0280-445-0822	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
0d0ad567-f9b6-45eb-b3f1-2ef0f9f89f2c	ACRUX	03086	0	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	28.00	0	1fcba1f2-fbf3-4489-b379-286b21f99fd8	DE ANGELIS Y LOGGHE S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
2b322642-6036-4618-a0a5-d051ae81575b	ARGENOVA X	02329	1146	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	32.50	550	caf4d1b5-7a3c-445b-98f9-42d842f1d347	ARGENOVA  S.A.	Puerto Deseado	4808331/4808332	0297- 487-0550  (447-2818  Com. Riv )	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
fa96fa93-c2e4-4b2a-b3ef-b57af70149ff	ARGENOVA XI	02199	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	300e8934-6a93-46e3-a1b9-1e48cf0b8d91	\N	60	\N	\N	caf4d1b5-7a3c-445b-98f9-42d842f1d347	ARGENOVA  S.A.	Puerto Deseado	4808331/4808332	0297- 487-0550  (447-2818  Com. Riv )	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
969e6d80-f91a-422a-b8c8-949b3b8a2834	ATREVIDO	0145	1180	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	bec74e80-f32e-4e58-9588-35bd863f8715	30	32.50	901	1fcba1f2-fbf3-4489-b379-286b21f99fd8	PESQUERA VERAZ  S.A.	Mar del Plata	4800005	489-4624 / 489-0314 (astillero)	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
bdb1fba6-a594-45fa-b618-5c5f903c49ed	ARGENOVA XXIII	02713	2707	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	37.19	678	caf4d1b5-7a3c-445b-98f9-42d842f1d347	ARGENOVA  S.A.	Puerto Deseado	4808331/4808332	0297- 487-0550  (447-2818  Com. Riv )	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
0ee1c1f5-3fcf-47d1-a3b6-d46037ae26a5	ARGENOVA XXIV	02752	2731	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	38.80	675	caf4d1b5-7a3c-445b-98f9-42d842f1d347	ARGENOVA  S.A.	Puerto Deseado	4808331/4808332	0297- 487-0550  (447-2818  Com. Riv )	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
02ccb20f-3c14-4a47-bc5b-fd957c5125e8	ARGENOVA XXV	028011	2740	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	39.70	859	caf4d1b5-7a3c-445b-98f9-42d842f1d347	ARGENOVA  S.A.	Puerto Deseado	4808331/4808332	0297- 487-0550  (447-2818  Com. Riv )	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
7316a45d-a520-4434-9f8a-ed5a20629fb3	ARGENOVA XXVI	02849	2739	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	37.15	1086	caf4d1b5-7a3c-445b-98f9-42d842f1d347	ARGENOVA  S.A.	Puerto Deseado	4808331/4808332	0297- 487-0550  (447-2818  Com. Riv )	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
428317e9-6d70-452a-b5db-98f272f5f6ab	ARGENOVA II	02177	1138	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	38.50	1168	caf4d1b5-7a3c-445b-98f9-42d842f1d347	ARGENOVA  S.A.	Puerto Deseado	4808331/4808332	0297- 487-0550  (447-2818  Com. Riv )	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
e288f1a3-0f57-4c45-87ff-2d1d5b045cfc	ARGENOVA III	02156	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	\N	\N	caf4d1b5-7a3c-445b-98f9-42d842f1d347	ARGENOVA  S.A.	Puerto Deseado		0297- 487-0550  (447-2818  Com. Riv )	\N		\N	\N		t	\N	\N	\N
83d76854-6830-4820-9d48-c1c57109a3aa	ARGENOVA IX	02328	1141	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	32.50	550	caf4d1b5-7a3c-445b-98f9-42d842f1d347	ARGENOVA  S.A.	Puerto Deseado	4808331/4808332	0297- 487-0550  (447-2818  Com. Riv )	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
59038a88-9b2b-4bb1-9280-a8d9af54f826	ARGENOVA XII	0199	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	300e8934-6a93-46e3-a1b9-1e48cf0b8d91	\N	60	\N	\N	caf4d1b5-7a3c-445b-98f9-42d842f1d347	ARGENOVA  S.A.	Puerto Deseado	4808331/4808332	0297- 487-0550  (447-2818  Com. Riv )	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
26cb2f14-d9bf-4134-9661-5f4372ee9c08	ARGENOVA XIV	0197	1149	49f1a6b1-610e-4aab-98e6-45dbe753fe22	300e8934-6a93-46e3-a1b9-1e48cf0b8d91	\N	60	52.30	1352	caf4d1b5-7a3c-445b-98f9-42d842f1d347	ARGENOVA  S.A.	Puerto Deseado	4808331/4808332	0297- 487-0550  (447-2818  Com. Riv )	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
727e0bfc-0e2c-4504-9fc1-904850e8306b	ARGENOVA XV	0198	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	300e8934-6a93-46e3-a1b9-1e48cf0b8d91	\N	60	\N	\N	caf4d1b5-7a3c-445b-98f9-42d842f1d347	ARGENOVA  S.A.	Puerto Deseado	4800274	0297- 487-0550  (447-2818  Com. Riv )	\N	amalfitanoycia@hotmail.com	\N	\N	Agencia Maritima Almafitano	t	\N	\N	\N
36babb7c-0e5e-4541-9ed3-22e86c39133a	ARGENTINO	0142	1157	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	33.77	1001	1fcba1f2-fbf3-4489-b379-286b21f99fd8	PESQUERA VERAZ  S.A.	Mar del Plata		489-4624 / 489-0314 (astillero)	\N		\N	\N		t	\N	\N	\N
f8dd0f4d-4ad5-4847-9b9f-49119fedfe45	ARKOFISH	0236	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	\N	\N	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
f72537b8-2db6-4788-b962-93b89b31c0db	ARKOFISH I	6004	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	\N	\N	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
3c5b2953-69de-47e9-9964-bd12483457f7	ARRUFO	0540	1165	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	39.16	1102	1fcba1f2-fbf3-4489-b379-286b21f99fd8	LUIS SOLIMENO e HIJOS  S.A.	Mar del Plata		489-3030	\N		\N	\N		t	\N	\N	\N
b363d093-0b67-4f8d-9ae2-d5a955ae99d2	ASUDEPES II	6363	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	\N	\N	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	ASUDEPES  S.A.	Ciudad Autónoma de Buenos Aires		011-4383-9756	\N		\N	\N		t	\N	\N	\N
cd5a4581-37d9-4a71-9ef4-877512294687	ASUDEPES III	6062	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	\N	\N	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	ASUDEPES  S.A.	Ciudad Autónoma de Buenos Aires		011-4383-9756	\N		\N	\N		t	\N	\N	\N
ce9995e9-716c-4ef7-b6f1-63b2bd5f54e8	ATLANTIC EXPRESS	02936	2727	49f1a6b1-610e-4aab-98e6-45dbe753fe22	d08faf9b-60a9-4081-b8ea-ca931995905b	\N	30	53.70	3426	1fcba1f2-fbf3-4489-b379-286b21f99fd8	WANCHESE ARGENTINA  S.A.	Mar del Plata		489-1236	\N		\N	\N		t	\N	\N	\N
ab41615e-12e5-4996-a1c3-93f9c4b65af3	ATLANTIC SURF I	0350	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	40	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	GLACIAR PESQUERA  S.A.	Mar del Plata	4890960	492-2216	\N	agencia@maritimavidal.com.ar	\N	\N	Agencia Maritima Vidal	t	\N	\N	\N
81d1eda7-b157-4fee-a647-8bce8e62efbc	ARGENOVA XXI	02661	2704	49f1a6b1-610e-4aab-98e6-45dbe753fe22	989ce1c1-31ae-4374-abc8-cd39ccc23254	7594af4a-8070-43b7-99bf-5a891d61cb60	60	55.80	1826	caf4d1b5-7a3c-445b-98f9-42d842f1d347	ARGENOVA  S.A.	Puerto Deseado	4808331/4808332	0297- 487-0550  (447-2818  Com. Riv )	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
426cfd83-e5ac-4d02-a611-f1b4d445321f	ATLANTIC SURF III	02030	1176	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	79d74266-23c8-4096-b660-cda06d12272c	60	49.60	3020	1fcba1f2-fbf3-4489-b379-286b21f99fd8	GLACIAR PESQUERA  S.A.	Mar del Plata	4800274	492-2216	\N	amalfitanoycia@hotmail.com	\N	\N	Agencia Maritima Almafitano	t	\N	\N	\N
10a7186d-32e2-40df-9932-bc8537990e82	AURORA	02581	1183	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	67.55	1776	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	KALEU KALEU  S.A.	Ciudad Autónoma de Buenos Aires		011-3220-2130  / 5093-1215	\N		\N	\N		t	\N	\N	\N
4e4d1f9d-b0bb-4c65-bdbf-1ed65d088ef7	BAHIA DESVELOS	0665	1194	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	37.05	791	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	PESQUERA SANTA CRUZ  S.A.	Ciudad Autónoma de Buenos Aires		011-4305-4706	\N		\N	\N		t	\N	\N	\N
c60bbd03-6503-4701-8443-484730125747	BEAGLE I	6052	1207	49f1a6b1-610e-4aab-98e6-45dbe753fe22	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	60	59.90	2369	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	YUKEN  S.A.	Ciudad Autónoma de Buenos Aires	4891553-154179360-154179860-154179062	011-5279-1302 / 5236-6069	\N	agenciasmiriglio@speedy.com.ar	\N	\N	Agencia Maritima Smiriglio	t	\N	\N	\N
93ea79b9-2283-45f0-9bee-21845a075b8c	BELVEDERE	01398	1210	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	26.50	624	1fcba1f2-fbf3-4489-b379-286b21f99fd8	PRINMAR  S.A. Buque Motor Belvedere	Mar del Plata		480-0883	\N		\N	\N		t	\N	\N	\N
0e5a84f9-45f0-4d7c-b7bd-81fdbb7de7b5	BOGAVANTE SEGUNDO	02994	2743	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	37.45	867	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	IBERCONSA  DE ARGENTINA  S.A.	Puerto Madryn		0280-445-4324	\N		\N	\N		t	\N	\N	\N
f530b4d0-c72b-4996-96ce-8ecc023ab449	BONFIGLIO	01234	\N	f66f75bd-9f71-42a6-a319-b9aecc608960	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	10	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	COSTA BRAVA  S.A.	Mar del Plata		489-7538	\N		\N	\N		t	\N	\N	\N
085e7f6e-76d0-4d5f-832d-effe37c5d917	BORRASCA	01095	1218	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	39.16	1083	1fcba1f2-fbf3-4489-b379-286b21f99fd8	LUIS SOLIMENO e HIJOS  S.A.	Mar del Plata		489-3030	\N		\N	\N		t	\N	\N	\N
6fca97ec-0390-4cbd-8bea-5a5eb55d4f68	BOUCIÑA	01637	1221	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	0.00	0	1fcba1f2-fbf3-4489-b379-286b21f99fd8	CALME  S.A.	Mar del Plata	4800005	480-3545	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
c0bdd4cf-04dd-4e72-bcca-94702bc07659	ARGENOVA IV	02157	1140	49f1a6b1-610e-4aab-98e6-45dbe753fe22	\N	\N	0	36.26	675	caf4d1b5-7a3c-445b-98f9-42d842f1d347	MAR DE LAS PALMAS  S.A.	Puerto Deseado	4808331/4808332	0297-487-2112	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
23d92d9c-14bd-41ef-a80d-bd7e2f5bee89	CABO BUENA ESPERANZA	02482	\N	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	UNIVERSAL PESQUERA  SRL	Mar del Plata		489-0352	\N		\N	\N		t	\N	\N	\N
b45a9d14-7cfd-4a5a-b26d-205cd7156bd4	CABO DE HORNOS	01537	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	MILANI Y PATANE  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
fc349989-a6ac-457f-ab01-039ab2c125a4	CABO DOS BAHIAS	02483	\N	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	\N	\N	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	ALPESCA  S.A.	Puerto Madryn		0280-447-4958 / 45-1069	\N		\N	\N		t	\N	\N	\N
dcc7d145-13ad-4767-aea6-e155c05d28e6	CABO SAN JUAN	023	\N	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	\N	\N	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	ALPESCA  S.A.	Puerto Madryn		0280-447-4958 / 45-1069	\N		\N	\N		t	\N	\N	\N
6599cc72-c443-4661-b458-e92c44d74d80	CABO SAN SEBASTIAN	022	\N	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	\N	\N	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	ALPESCA  S.A.	Puerto Madryn		0280-447-4958 / 45-1069	\N		\N	\N		t	\N	\N	\N
23c739e6-2bfd-489a-8cb7-e945122618b6	CABO VIRGENES	024	\N	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	\N	\N	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	ALPESCA  S.A.	Puerto Madryn		0280-447-4958 / 45-1069	\N		\N	\N		t	\N	\N	\N
4469c68f-354e-477e-a214-e48a125856ad	CALABRIA	0567	1245	f66f75bd-9f71-42a6-a319-b9aecc608960	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	4	19.63	266	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
57a95a06-a15c-4077-b1e9-9d72d1a2eedf	CALIZ	02809	0	f66f75bd-9f71-42a6-a319-b9aecc608960	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	4	20.20	545	cd0af388-5ae6-4ed0-9de5-f8f5a375bf43	FLOTA AMARILLA RAWSON	Rawson			\N		\N	\N		t	\N	\N	\N
c98a4fc8-55be-4d6f-a480-ed8d568e411a	CALLEJA	06276	1249	f66f75bd-9f71-42a6-a319-b9aecc608960	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	10	21.83	503	1fcba1f2-fbf3-4489-b379-286b21f99fd8	OTESA  S.A.	Mar del Plata		493-5606	\N		\N	\N		t	\N	\N	\N
04ef6c17-430b-458f-af48-8535a75b9cef	CANAL DE BEAGLE	0407	0	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	23.90	501	1fcba1f2-fbf3-4489-b379-286b21f99fd8	CANAL DE BEAGLE  S.R.L.	Mar del Plata		480-4447	\N		\N	\N		t	\N	\N	\N
e113b2d7-af93-44fe-a26e-805429efdd48	CHIYO MARU Nº 3	02987	2745	49f1a6b1-610e-4aab-98e6-45dbe753fe22	d08faf9b-60a9-4081-b8ea-ca931995905b	ffd18c57-fb77-4959-9191-1a7cf0a17664	30	52.80	937	86f70064-a55b-4d55-b7e9-dc3f320c4cc1	CRUSTACEOS DEL SUR  S.A.	Ciudad Autónoma de Buenos Aires		011-5218-4287	\N		\N	\N		t	\N	\N	\N
1ba7d424-8eb5-441c-9378-7228459c0bd6	CAPITAN CANEPA	059F	\N	3396a7a4-5c2b-473e-93a2-d66105f78818	\N	\N	28	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	INIDEP	Mar del Plata		451-7442 ó 486-2586 int 162	\N		\N	\N		t	\N	\N	\N
2cf99b92-4312-42b1-a198-38bdad313ab9	CAPITAN GIACHINO	0151	1260	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	38.42	1062	1fcba1f2-fbf3-4489-b379-286b21f99fd8	KALARI S.A.	Mar del Plata		489-1959	\N		\N	\N		t	\N	\N	\N
1f19a85a-f85f-4e9f-98c5-4d4fc63fbb1a	CAPITAN OCA BALDA	060F	\N	3396a7a4-5c2b-473e-93a2-d66105f78818	\N	\N	21	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	INIDEP	Mar del Plata		451-7442 ó 486-2586 int 162	\N		\N	\N		t	\N	\N	\N
65a6ccda-583d-4964-86d4-eba8bc1b0a96	CARMEN A	02045	1269	f66f75bd-9f71-42a6-a319-b9aecc608960	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	4	15.30	223	cd0af388-5ae6-4ed0-9de5-f8f5a375bf43	FLOTA AMARILLA RAWSON	Rawson			\N		\N	\N		t	\N	\N	\N
49403073-bf7a-4a08-a982-83cadd8199e4	CAROLINA P	0176	1272	49f1a6b1-610e-4aab-98e6-45dbe753fe22	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	60	71.60	1976	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	ESTRELLA PATAGONICA S.A.	Puerto Madryn		0280-445-4407	\N		\N	\N		t	\N	\N	\N
0d61bf64-5c2a-4bde-b6be-7eb21322c18c	CEIBE DOUS	0336	1276	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	40.70	738	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	IBERCONSA  DE ARGENTINA  S.A.	Puerto Madryn	4800274	0280-445-4324	\N	amalfitanoycia@hotmail.com	\N	\N	Agencia Maritima Almafitano	t	\N	\N	\N
b6c82a60-965d-4e57-bf7e-9d1a4a9347bc	CENTAURO 2000	0482	1278	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	35.50	1302	1fcba1f2-fbf3-4489-b379-286b21f99fd8	PESQUERA VERAZ  S.A.	Mar del Plata		489-4624 / 489-0314 (astillero)	\N		\N	\N		t	\N	\N	\N
c050a1a6-e49a-4c1f-ac75-900a7e53e028	CENTURION DEL ATLANTICO	0237	1280	49f1a6b1-610e-4aab-98e6-45dbe753fe22	989ce1c1-31ae-4374-abc8-cd39ccc23254	c85b8285-3bc6-43bc-b664-4b675ee2876d	60	112.80	8111	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	ESTREMAR  S.A.	Ciudad Autónoma de Buenos Aires		011-6533-7853 / 4345-1102	\N		\N	\N		t	\N	\N	\N
423261e8-4005-4600-a12e-852c05665a73	CERES	01420	1281	49f1a6b1-610e-4aab-98e6-45dbe753fe22	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	60	60.74	1969	1fcba1f2-fbf3-4489-b379-286b21f99fd8	PESQUERA CERES  S.A.	Mar del Plata		410-0051 / 7	\N		\N	\N		t	\N	\N	\N
25827820-4252-4853-a503-16daf2fd754c	CHANG BO GO I	06190	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	\N	\N	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	ARPEPA  M.C.I.S.A.	Ciudad Autónoma de Buenos Aires		011-4382-1605	\N		\N	\N		t	\N	\N	\N
b20c00dd-0fb6-4ab3-911a-9bd509927f2e	CHATKA I	02893	0	f66f75bd-9f71-42a6-a319-b9aecc608960	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	16.73	195	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	FOOD PARTNERS PATAGONIA S.A.	Puerto Madryn		0280-4458579 / 5225	\N		\N	\N		t	\N	\N	\N
aeeb2a4a-d802-404e-9d41-b35db13931c1	CHIARPESCA 56	01090	\N	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	APOLO FISH  S.A.	Mar del Plata		489-4519 / 489-1133	\N		\N	\N		t	\N	\N	\N
67d778f8-96db-4ec6-aa48-b979b0bc4958	CHIARPESCA 57	01029	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	CHIARPESCA  S.A.	Mar del Plata		489-1385	\N		\N	\N		t	\N	\N	\N
ede6e3ad-9b2a-49a3-a480-b1cd9631fca7	CHIARPESCA 902	02110	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	CHIARPESCA  S.A.	Mar del Plata		489-1385	\N		\N	\N		t	\N	\N	\N
a01f0bab-1dd6-43ff-9906-f8edc3d106af	CHIARPESCA 903	02109	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	CHIARPESCA  S.A.	Mar del Plata		489-1385	\N		\N	\N		t	\N	\N	\N
6ddb602a-7854-408e-8674-0e787933e02e	CAPESANTE	02929	2723	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	79d74266-23c8-4096-b660-cda06d12272c	40	50.15	2550	1fcba1f2-fbf3-4489-b379-286b21f99fd8	GLACIAR PESQUERA  S.A.	Mar del Plata		492-2216	\N		\N	\N		t	\N	\N	\N
4e0a9e8b-a9ec-4e2d-a124-7bedabb4bb1f	CHOCO MARU 68	JA13	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	PESQUERA COMERCIAL  S.A.	Mar del Plata		489-3030	\N		\N	\N		t	\N	\N	\N
2e99269c-067f-48f2-b179-4def75a2a465	CHOKYU MARU Nº 18.	2584	1312	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	68.70	1777	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	BAHIA GRANDE  S.A.	Ciudad Autónoma de Buenos Aires		011-5272-0850 / 5254-1133	\N		\N	\N		t	\N	\N	\N
2709bbe1-87e5-4183-8b39-6871027025c7	CINCOMAR 1	0439	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	\N	\N	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	CINCOMAR  S.A.	Ciudad Autónoma de Buenos Aires		011-4326-4991	\N		\N	\N		t	\N	\N	\N
fa8fe56c-872a-4775-a9d4-475ec8044b6f	CINCOMAR 5	02351	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	\N	\N	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	CINCOMAR  S.A.	Ciudad Autónoma de Buenos Aires		011-4326-4991	\N		\N	\N		t	\N	\N	\N
bbe5e8b3-04f3-420a-8f05-4118b73e5cf3	CIUDAD DE HUELVA	01519	1324	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	27.45	426	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
e1b63528-53ea-4e93-a33b-0ed2541d57dc	CIUDAD FELIZ	0910	2721	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	28.56	458	1fcba1f2-fbf3-4489-b379-286b21f99fd8	CARAVON S.A.	Mar del Plata		489-9404	\N		\N	\N		t	\N	\N	\N
10fd44fb-4b21-436e-b8e0-1008b03f62a3	CLAUDIA	02183	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	\N	\N	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	LUXMARINO  S.A.	Ciudad Autónoma de Buenos Aires		011-4342-2621	\N		\N	\N		t	\N	\N	\N
2f263e73-cd83-4af7-b53a-d59ae49d7cdd	CLAUDINA	02345	1331	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	53.58	937	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	ARMADORA  ACRUX  S.A.	Ciudad Autónoma de Buenos Aires		011-4312-6470	\N		\N	\N		t	\N	\N	\N
55783ffd-405f-4d11-a26c-740b1843e1d3	COALSA SEGUNDO	0790	1333	49f1a6b1-610e-4aab-98e6-45dbe753fe22	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	60	76.20	2960	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	YUKEN  S.A.	Ciudad Autónoma de Buenos Aires		011-5279-1302 / 5236-6069	\N		\N	\N		t	\N	\N	\N
15dd1d12-43c1-42a7-ab8d-6d42be794653	CODEPECA  I	0497	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	\N	\N	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	HARENGUS  S.A.	Puerto Madryn		0280-445-0822	\N		\N	\N		t	\N	\N	\N
4299fa60-6de0-4bb8-afff-bbf8828dd225	CODEPECA  II	0498	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	\N	\N	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	HARENGUS  S.A.	Puerto Madryn		0280-445-0822	\N		\N	\N		t	\N	\N	\N
265e4a7c-c48c-43d2-b61b-c22b3d9c5cf1	CABO BUEN TIEMPO	025	\N	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	\N	\N	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	ALPESCA  S.A.	Puerto Madryn		0280-447-4958 / 45-1069	\N		\N	\N		t	\N	\N	\N
7087bf7d-c1ff-4526-9f02-9bf33eb71f27	COMANDANTE LUIS PIEDRABUENA	0767	1340	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	25.00	501	1fcba1f2-fbf3-4489-b379-286b21f99fd8	COMANDANTE PIEDRABUENA  S.R.L.	Mar del Plata		489-9404	\N		\N	\N		t	\N	\N	\N
6881aef2-f5ff-4b37-b44b-5b39c1a8be6b	COMETA	0919	\N	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	VICARP  S.A.	Mar del Plata		480-4378	\N		\N	\N		t	\N	\N	\N
3de792e0-7de2-4577-a0b1-3469e32c40eb	CONARA I	0201	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	\N	\N	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
c573e0fc-6f82-4795-bfcc-b49b981977d8	CONARPESA I	0200	1344	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	52.50	1482	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
e5719398-f949-41c9-9268-b67b742b59d1	CORAJE	0645	1359	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	\N	\N	0	28.28	426	1fcba1f2-fbf3-4489-b379-286b21f99fd8	IBERCONSA  DE ARGENTINA  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
015c5c41-8347-4827-a4ef-fe73818bd8b6	CORAL  AZUL	06127	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	\N	\N	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	NOVAMAR  S.A.	Ciudad Autónoma de Buenos Aires		011-4345-6688	\N		\N	\N		t	\N	\N	\N
9fdf6a75-862b-470b-8caf-f5d33d2b2ac3	CORAL BLANCO	06137	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	\N	\N	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	NOVAMAR  S.A.	Ciudad Autónoma de Buenos Aires		011-4345-6688	\N		\N	\N		t	\N	\N	\N
f60d04e0-755a-419c-8126-7e875b80ea31	CORMORAN	01611	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	ANTONIO BARILLARI  S.A.	Mar del Plata		481-1173  / 489-0872	\N		\N	\N		t	\N	\N	\N
1cde0ee8-8ca2-461c-adf9-d68b7479e48c	COSTAMAR	01549	\N	f66f75bd-9f71-42a6-a319-b9aecc608960	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	4	\N	\N	cd0af388-5ae6-4ed0-9de5-f8f5a375bf43	INDUSTRIA  PESQUERA  PATAGONICA  S.A.	Trelew		0280-444-6577	\N		\N	\N		t	\N	\N	\N
021eaf24-d70b-44ac-94fe-43a1db78c0ab	DASA 508	0499	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	\N	\N	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	PESQUERA  DONGAH  ARGENTINA  S.A.	Ciudad Autónoma de Buenos Aires		011-4815-5525	\N		\N	\N		t	\N	\N	\N
2dbf1776-61a7-4fc2-b4a9-73763ebbfa43	DASA 757	02200	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	\N	\N	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	PESQUERA  DONGAH  ARGENTINA  S.A.	Ciudad Autónoma de Buenos Aires		011-4815-5525	\N		\N	\N		t	\N	\N	\N
22a821aa-8efa-4e17-8f0c-f9739a6f8785	DEMOSTENES	0113	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	\N	\N	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	AGUA MARINA  S.A.	Ciudad Autónoma de Buenos Aires		011-4342-0605 / 5656 / 1709	\N		\N	\N		t	\N	\N	\N
cd75ece7-2b18-4241-b2b4-d8d799734efe	DESTINY	3209	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	\N	\N	\N	WANCHESE ARGENTINA  S.A.				\N		\N	\N		t	\N	\N	\N
9b4db35c-4401-4c61-b8f6-467f4e6423be	DEPASUR  I	0330	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	\N	\N	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
33031edb-b870-46c3-b0cc-a33abb59fad4	DEPEMAS 51	0239	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	\N	\N	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	DEPEMAS  S.A.	Ciudad Autónoma de Buenos Aires		011-4372-7909  /  4382-5382	\N		\N	\N		t	\N	\N	\N
9ff64a93-9707-4317-a6c3-d2e12978140b	DEPEMAS 81	0281	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	\N	\N	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	PESQUERA ORION  S.A.	Ciudad Autónoma de Buenos Aires		011-4343-9327	\N		\N	\N		t	\N	\N	\N
fed433aa-690c-402d-8310-66e5b51eae7a	DESAFIO	0177	1398	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	29.56	850	1fcba1f2-fbf3-4489-b379-286b21f99fd8	PESQUERA VERAZ  S.A.	Mar del Plata		489-4624 / 489-0314 (astillero)	\N		\N	\N		t	\N	\N	\N
30e6ba78-6317-4388-9961-d330ba78e0db	DESEADO	01598	1400	f66f75bd-9f71-42a6-a319-b9aecc608960	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	4	19.00	301	cd0af388-5ae6-4ed0-9de5-f8f5a375bf43	FLOTA AMARILLA RAWSON	Rawson			\N		\N	\N		t	\N	\N	\N
16cfdeb9-c32d-4b3e-91a5-c53757a8bd13	DIEGO PRIMERO	01725	\N	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	PESQUERA DIEGO PRIMERO  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
bdf59426-0960-4694-af45-e384c786545e	DON JUAN ALVAREZ	3300	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	\N	\N	\N	\N	CONARPESA  S.A.				\N		\N	\N		t	\N	\N	\N
9c7bd64c-35a4-4b4a-9d1d-e6ea0e7abe39	DON  NATALIO	01183	\N	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	14 DE JULIO  S.A.	Mar del Plata		480-3545	\N		\N	\N		t	\N	\N	\N
bb046ab6-b26e-4c7b-a8fd-92ab669c1b60	DON AGUSTIN	0968	\N	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	PESQUERA  MARGARITA  S.A.	Mar del Plata		489-4645   /   489-2946	\N		\N	\N		t	\N	\N	\N
7151dff8-9886-4c87-ba95-5f642e6eaa68	DON ANTONIO	0029	1411	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	27.80	549	1fcba1f2-fbf3-4489-b379-286b21f99fd8	GIORNO  S.A.	Mar del Plata		410-0051 / 0057	\N		\N	\N		t	\N	\N	\N
d074204f-908e-473b-b615-f8a3f2d8617b	DON CARMELO	01320	1416	f66f75bd-9f71-42a6-a319-b9aecc608960	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	8	19.04	424	1fcba1f2-fbf3-4489-b379-286b21f99fd8	MARFE  S.A.	Mar del Plata	4800005	480-0102	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
491d948a-6ddd-45e2-8e63-48c87d3ad4b8	DON CAYETANO	0579	1417	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	47.10	1503	1fcba1f2-fbf3-4489-b379-286b21f99fd8	PEDRO MOSCUZZA e HIJOS  S.A.	Mar del Plata	4890960	489-7287	\N	agencia@maritimavidal.com.ar	\N	\N	Agencia Maritima Vidal	t	\N	\N	\N
4897fed9-fcb7-4491-9660-7bb979be5940	DON FRANCISCO I	2562	1428	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	66.55	1776	1fcba1f2-fbf3-4489-b379-286b21f99fd8	EL MARISCO  S.A.	Mar del Plata	480-7779 - HERNAN	489-0384	\N	agenciasenoransmdp@yahoo.com	\N	\N	Agencia Maritima SEÑORANS	t	\N	\N	\N
7befa686-b129-469e-a9f7-192d74f71dae	DON GAETANO	071	1430	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	32.10	889	1fcba1f2-fbf3-4489-b379-286b21f99fd8	LINEAERRE  S.A.	Mar del Plata		480-0312	\N		\N	\N		t	\N	\N	\N
cf9fd976-47b4-48e6-810f-22b2db012ace	DON GIULIANO	02025	1431	f66f75bd-9f71-42a6-a319-b9aecc608960	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	4	17.10	220	cd0af388-5ae6-4ed0-9de5-f8f5a375bf43	FLOTA AMARILLA RAWSON	Rawson			\N		\N	\N		t	\N	\N	\N
f4e59368-a0ad-40b6-b784-d017473e2605	DON JOSE	00892	1434	f66f75bd-9f71-42a6-a319-b9aecc608960	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	8	16.49	269	1fcba1f2-fbf3-4489-b379-286b21f99fd8	VENTO DI TERRA  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
68ba9690-45c2-4705-8f08-4aefc0e07611	DON JOSE DI BONA	02241	1435	f66f75bd-9f71-42a6-a319-b9aecc608960	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	4	19.85	301	cd0af388-5ae6-4ed0-9de5-f8f5a375bf43	PROA  AL SUR  S.R.L.	Rawson			\N		\N	\N		t	\N	\N	\N
1b5a879c-fdea-445d-8102-9f1c955a0a30	DON JUAN	01397	1437	f66f75bd-9f71-42a6-a319-b9aecc608960	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	27.00	425	\N	PESQUERA DON JUAN  S.A.				\N		\N	\N		t	\N	\N	\N
63b38c9b-cd59-4a18-a739-f14f74fd1e95	DON JUAN D´AMBRA	5174	\N	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	PESCA ANGELA  S.A.	Mar del Plata		626-2236 /37	\N		\N	\N		t	\N	\N	\N
d12013e2-32f9-47cc-ac70-44fcbe90426a	DON LUCIANO	069	\N	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	TATURIELLO  S.A.	Mar del Plata		489-3833	\N		\N	\N		t	\N	\N	\N
ce349711-474f-4bad-b14e-0be248aaa348	DON PEDRO	068	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	989ce1c1-31ae-4374-abc8-cd39ccc23254	bec74e80-f32e-4e58-9588-35bd863f8715	60	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	PEDRO MOSCUZZA e HIJOS  S.A.	Mar del Plata		489-7287	\N		\N	\N		t	\N	\N	\N
ba81638e-3490-4417-9ae3-a5bbe69d5380	DON MIGUEL 1°	0748	\N	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	PESQUERA EL NAZARENO	Mar del Plata	4895032 Emanuel	489-9414 (of. Pers. Emb.)	\N	operacionesconsultoramaritima@gmail.com	\N	\N	Consultora Maritima Merlini	t	\N	\N	\N
7d826978-f5e8-4e9e-921e-9bbbd0018f4e	DON NICOLA	0893	1450	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	28.14	856	1fcba1f2-fbf3-4489-b379-286b21f99fd8	PEZ ESPADA  S.A.	Mar del Plata		480-0846	\N		\N	\N		t	\N	\N	\N
db2a744f-1cfb-49ca-82d9-11ba6d4d9f72	DON OSCAR	02184	\N	f66f75bd-9f71-42a6-a319-b9aecc608960	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	4	\N	\N	cd0af388-5ae6-4ed0-9de5-f8f5a375bf43	FLOTA AMARILLA RAWSON	Rawson	4800005		\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
b70f3781-843e-4cf8-b58b-6783a97bb095	DON RAIMUNDO	01431	1463	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	10	25.60	624	1fcba1f2-fbf3-4489-b379-286b21f99fd8	DON RAIMUNDO S.R.L.	Mar del Plata		489-3780	\N		\N	\N		t	\N	\N	\N
95444611-ad7f-4532-a8cb-4e71b9dff4de	DON LUIS I	02093	1445	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	551b3773-09f9-4eb6-a9ce-88abf50b63a1	40	67.95	1803	1fcba1f2-fbf3-4489-b379-286b21f99fd8	PESQUERA CERES  S.A.	Mar del Plata		410-0051 / 7	\N		\N	\N		t	\N	\N	\N
9fd799e3-d024-47e6-b4f0-29f37450382b	CODEPECA IV	01012	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	\N	\N	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	PEREIRA  ARGENTINA  S.A.	Puerto Madryn		0280-445-7377 / 447-2249	\N		\N	\N		t	\N	\N	\N
3f581973-0ceb-43a2-b0bf-8e927c92da15	DON TOMASSO	02310	1468	f66f75bd-9f71-42a6-a319-b9aecc608960	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	4	17.00	356	cd0af388-5ae6-4ed0-9de5-f8f5a375bf43	FLOTA AMARILLA RAWSON	Rawson			\N		\N	\N		t	\N	\N	\N
156c0556-bfbd-430a-9af4-2ff028fd3ff7	DON TURI	01540	1470	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	28.62	839	1fcba1f2-fbf3-4489-b379-286b21f99fd8	DON TURI  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
3b42c010-7873-44e5-a59f-6b9e765f8858	DON VICENTE VUOSO	0539	1474	f66f75bd-9f71-42a6-a319-b9aecc608960	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	20.69	537	1fcba1f2-fbf3-4489-b379-286b21f99fd8	VUOSO HNOS. S.R.L.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
da9a5317-3e17-4448-b336-2f895abdbb57	DOÑA ALFIA	0512	1483	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	20.70	426	1fcba1f2-fbf3-4489-b379-286b21f99fd8	ANTONIO BARILLARI  S.A.	Mar del Plata		481-1173  / 489-0872	\N		\N	\N		t	\N	\N	\N
86cb60b4-8b15-43cb-906c-4fe6aa848536	Dr. EDUARDO L. HOLMBERG	061F	\N	3396a7a4-5c2b-473e-93a2-d66105f78818	\N	\N	24	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	INIDEP	Mar del Plata		451-7442 ó 486-2586 int 162	\N		\N	\N		t	\N	\N	\N
395ed19d-038a-42c9-95cc-db61a21fdb8b	DUKAT	02775	2712	49f1a6b1-610e-4aab-98e6-45dbe753fe22	d08faf9b-60a9-4081-b8ea-ca931995905b	ffd18c57-fb77-4959-9191-1a7cf0a17664	30	50.80	1302	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	CRUSTACEOS DEL SUR  S.A.	Ciudad Autónoma de Buenos Aires		011-5218-4287	\N		\N	\N		t	\N	\N	\N
519d6379-3ddd-498a-8d60-67be40172795	EL MALO I	02350	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	4	\N	\N	cd0af388-5ae6-4ed0-9de5-f8f5a375bf43	NOGALES NOGALES  S. De HECHO	Rawson	4890960		\N	agencia@maritimavidal.com.ar	\N	\N	Agencia Maritima Vidal	t	\N	\N	\N
06e3883e-1d07-4258-9281-b16f833684c9	EL MARISCO I	0912	1516	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	27.22	426	1fcba1f2-fbf3-4489-b379-286b21f99fd8	EL MARISCO  S.A.	Mar del Plata	4890960	489-0384	\N	agencia@maritimavidal.com.ar	\N	\N	Agencia Maritima Vidal	t	\N	\N	\N
3675f3ab-e4f6-4834-a074-84d33fb23c26	EL MARISCO II	0915	1517	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	56.30	1407	1fcba1f2-fbf3-4489-b379-286b21f99fd8	EL MARISCO  S.A.	Mar del Plata		489-0384	\N		\N	\N		t	\N	\N	\N
73a406d3-407f-4444-a76e-d713016a6e49	EL SANTO	05970	\N	f66f75bd-9f71-42a6-a319-b9aecc608960	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	0	\N	\N	caf4d1b5-7a3c-445b-98f9-42d842f1d347	VUOGAFE  S.A.	Puerto Deseado		0297-155-940853	\N		\N	\N		t	\N	\N	\N
961a4cad-e71f-49dc-87ce-fecef6c0136e	EMILIA MARIA	01390	1543	f66f75bd-9f71-42a6-a319-b9aecc608960	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	10	22.60	521	1fcba1f2-fbf3-4489-b379-286b21f99fd8	COSTA BRAVA  S.A.	Mar del Plata		489-7538	\N		\N	\N		t	\N	\N	\N
a06e5713-e03d-4cc5-97fb-fb1dbd6013d7	EMPESUR II	01439	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	\N	\N	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	EMPESUR  S.A.	Ciudad Autónoma de Buenos Aires		011-4312-0123	\N		\N	\N		t	\N	\N	\N
9d717adf-85bb-4d06-ba75-9da617e34bb9	EMPESUR III	01438	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	\N	\N	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	EMPESUR  S.A.	Ciudad Autónoma de Buenos Aires		011-4312-0123	\N		\N	\N		t	\N	\N	\N
f9e92d22-58f6-482f-b381-f2bc3121be2d	EMPESUR V	02650	2705	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	30.52	1369	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	EMPESUR  S.A.	Ciudad Autónoma de Buenos Aires		011-4312-0123	\N		\N	\N		t	\N	\N	\N
a9815123-9406-4d5a-99f3-9ff1a9ab07ff	EMPESUR VI	02983	2749	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	35.03	1289	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	EMPESUR  S.A.	Ciudad Autónoma de Buenos Aires		011-4312-0123	\N		\N	\N		t	\N	\N	\N
caf540e1-2de2-417b-8013-a71bfca2e092	EMPESUR VII	03045	2754	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	35.03	1290	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	EMPESUR  S.A.	Ciudad Autónoma de Buenos Aires		011-4312-0123	\N		\N	\N		t	\N	\N	\N
85f293eb-ef54-4922-a270-e5c6780d7d3a	El marisco s.a	02070	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	\N	\N	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	FISHING WORLD  S.A.	Puerto Madryn	4800005	0280-445-6533	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
196b34fe-c53c-47f2-b937-8d52d24c1973	ENTRENA UNO	02069	1551	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	33.10	839	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	FOOD ARTS  S.A.	Ciudad Autónoma de Buenos Aires		POR MAILlazuaje@foodarts.com.ar	\N		\N	\N		t	\N	\N	\N
808e5c75-8e4a-46a5-ac1c-d71edcdbd0d2	ERIN BRUCE	0537	1553	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	53.60	2252	1fcba1f2-fbf3-4489-b379-286b21f99fd8	WANCHESE ARGENTINA  S.A.	Mar del Plata		489-1236	\N		\N	\N		t	\N	\N	\N
06f76a6f-dd4e-490c-b6a2-ee9a8ebcff3d	ERIN BRUCE II	TEMP-0002	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	79d74266-23c8-4096-b660-cda06d12272c	\N	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8					\N		\N	\N		t	\N	\N	\N
fb41b7fd-12b1-48f6-908b-998bd4588f8c	ESAMAR N° 4	0467	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	\N	\N	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	ESAMAR  S.A.	Ciudad Autónoma de Buenos Aires		011-4393-8431	\N		\N	\N		t	\N	\N	\N
aa689488-1e54-4302-ae4c-8f2301b1d6bb	ESPADARTE	02048	1558	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	68.20	1529	caf4d1b5-7a3c-445b-98f9-42d842f1d347	PESQUERA DESEADO  S.A.	Puerto Deseado		0297-487-0884 / 0327 / 2407	\N		\N	\N		t	\N	\N	\N
bf33a4e1-c31d-47ec-833a-d09e856cf8e2	ESPERANZA 909	02577	1559	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	72.34	1678	1fcba1f2-fbf3-4489-b379-286b21f99fd8	CHIARPESCA  S.A.	Mar del Plata		489-1385	\N		\N	\N		t	\N	\N	\N
d1494aa9-e058-4539-aa6c-cea7c25f9143	ESPERANZA DEL SUR	02751	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	60	\N	\N	86f70064-a55b-4d55-b7e9-dc3f320c4cc1	PESANTAR  S.A. ( Empresa Pesq de la Patagonia y Antartida )	Ushuaia		02901-43-3449 / 43-0008 / 43-0708	\N		\N	\N		t	\N	\N	\N
44d740f3-8c8e-458c-b1c0-a3fced6ff5c8	ESPERANZA DOS	06264	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	\N	\N	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	ESPERANZA DEL MAR  S.A.	Ciudad Autónoma de Buenos Aires		011-4328-8696	\N		\N	\N		t	\N	\N	\N
0966e0cd-cab2-493c-96d2-2dd1b45c5889	ESPERANZA UNO	06113	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	\N	\N	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	ESPERANZA DEL MAR  S.A.	Ciudad Autónoma de Buenos Aires		011-4328-8696	\N		\N	\N		t	\N	\N	\N
5d48c52f-56e1-4b5e-b8f2-19af8ba1988d	ESTEFANY	001	1565	f66f75bd-9f71-42a6-a319-b9aecc608960	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	15	23.60	530	1fcba1f2-fbf3-4489-b379-286b21f99fd8	GIORNO  S.A.	Mar del Plata		410-0051 / 0057	\N		\N	\N		t	\N	\N	\N
cdd987af-702e-4ad2-8f2c-73685b4027f7	ESTEIRO	6328	\N	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	BALDIMAR  S.A.	Mar del Plata		489-6522	\N		\N	\N		t	\N	\N	\N
f85d215b-218d-4d22-a9a5-ab657703db92	ESTHER 153	02058	1568	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	55.10	1252	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	ARPEPA  M.C.I.S.A.	Ciudad Autónoma de Buenos Aires		011-4382-1605	\N		\N	\N		t	\N	\N	\N
2e7aa804-96eb-4a01-bf88-09c8764ec81f	ESTRELLA N° 5	0246	1575	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	54.20	1601	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	HANSUNG AR  S.A.	Ciudad Autónoma de Buenos Aires		011-4816-2022	\N		\N	\N		t	\N	\N	\N
1c441533-527e-4ac7-8c46-bc4d49d66f5c	ESTRELLA N° 6	012	1576	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	55.85	1581	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	HANSUNG AR  S.A.	Ciudad Autónoma de Buenos Aires		011-4816-2022	\N		\N	\N		t	\N	\N	\N
1be06bf0-e35a-4bf7-9ffd-13cbe5e692af	ESTRELLA N° 8	0242	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	\N	\N	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	HANSUNG AR  S.A.	Ciudad Autónoma de Buenos Aires		011-4816-2022	\N		\N	\N		t	\N	\N	\N
b0de111b-e19b-4276-8481-865067c634c0	FE EN PESCA	0226	\N	07f4f8be-5285-4459-9248-90da8b4f1729	\N	\N	0	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	ASARO HNOS.  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
bbfb5f3e-a564-4da0-80b8-83ed51aa438f	FEDERICO C	3190	2776	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	\N	37.68	1400	\N	PESQUERA VERAZ  S.A.				\N		\N	\N		t	\N	\N	\N
8d9b5cf1-64d1-4313-9fb0-4a382549e0b6	FEIXA	0529	1592	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	41.50	1101	1fcba1f2-fbf3-4489-b379-286b21f99fd8	ANTONIO BARILLARI  S.A.	Mar del Plata		481-1173  / 489-0872	\N		\N	\N		t	\N	\N	\N
1263e64b-284d-4879-b212-5d29e1b3fcda	FELIX AUGUSTO	0581	1595	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	27.80	601	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
5f89c15b-a985-4ba6-a6cd-49adf339d873	FERNANDO ALVAREZ	0013	1597	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	36.60	1168	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
5d2e398a-7f96-4c2b-a455-58da21ceb1ff	ECHIZEN MARU	0326	1495	49f1a6b1-610e-4aab-98e6-45dbe753fe22	989ce1c1-31ae-4374-abc8-cd39ccc23254	c85b8285-3bc6-43bc-b664-4b675ee2876d	60	89.59	4702	86f70064-a55b-4d55-b7e9-dc3f320c4cc1	PESANTAR  S.A. ( Empresa Pesq de la Patagonia y Antartida )	Ushuaia		02901-43-3449 / 43-0008 / 43-0708	\N		\N	\N		t	\N	\N	\N
9a2759e2-5da5-4b77-9464-0dc62ce3ca3a	DON SANTIAGO	01733	1467	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	10	26.55	776	1fcba1f2-fbf3-4489-b379-286b21f99fd8	SAN JORGE S.A.	Mar del Plata		480-6611	\N		\N	\N		t	\N	\N	\N
7d310791-c4a9-4493-b69b-7a3f5e0e94e5	FLORIDABLANCA IV	0255	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	\N	\N	f20aba40-3236-4ae4-b2aa-9c236e7217fa	MARITIMA MONACHESI  S.A.	Bahia Blanca		0291-452-5913	\N		\N	\N		t	\N	\N	\N
77be2ad0-229b-4266-9c9b-239e48791cda	FONSECA	0920	1610	49f1a6b1-610e-4aab-98e6-45dbe753fe22	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	60	62.40	2003	1fcba1f2-fbf3-4489-b379-286b21f99fd8	FONSECA  S.A.	Mar del Plata	4891553-154179360-154179860-154179062	489-4645	\N	agenciasmiriglio@speedy.com.ar	\N	\N	Agencia Maritima Smiriglio	t	\N	\N	\N
e505434b-52dd-4c68-89e3-1ac9dae1c882	FRANCA	0495	1612	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	27.29	493	1fcba1f2-fbf3-4489-b379-286b21f99fd8	AUGUSTA MEGARA  S.A.	Mar del Plata		480-2260	\N		\N	\N		t	\N	\N	\N
243937dd-fbf9-448f-8989-076c27ad2cb4	FRANCO	01458	\N	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	FRIGORIFICO DON LUIS  S.R.L.	Mar del Plata		489-4645	\N		\N	\N		t	\N	\N	\N
104ad328-9c58-4de8-8adb-37ff11344acd	FU YUAN YU 636	02195	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	\N	\N	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	BAHIA GRANDE  S.A.	Ciudad Autónoma de Buenos Aires		011-5272-0850 / 5254-1133	\N		\N	\N		t	\N	\N	\N
211c7518-6dd7-4bfc-ac86-0b203bcf9d27	FUEGUINO I	0331	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	\N	\N	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
c4c4e53f-df6b-406a-83e5-329a26ca074c	GALA	02722	0	f66f75bd-9f71-42a6-a319-b9aecc608960	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	15	15.20	256	1fcba1f2-fbf3-4489-b379-286b21f99fd8	DISTRIBUIDORA MARECHIARE S.R.L.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
9019d71b-6d53-4e81-9ffa-9f4618719768	GALEMAR	0904	\N	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	ANTONIO BARILLARI  S.A.	Mar del Plata		481-1173  / 489-0872	\N		\N	\N		t	\N	\N	\N
e9f65856-1cf9-46d1-a506-cc45e3a5ad32	GAUCHO GRANDE	0339	1642	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	\N	\N	30	27.64	0	1fcba1f2-fbf3-4489-b379-286b21f99fd8	VICARP  S.A.	Mar del Plata	4890960	480-4378	\N	agencia@maritimavidal.com.ar	\N	\N	Agencia Maritima Vidal	t	\N	\N	\N
5b5f41c3-a95b-4043-8ac1-3c0fda0d92b4	GEMINIS	01421	1643	49f1a6b1-610e-4aab-98e6-45dbe753fe22	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	60	68.90	2141	1fcba1f2-fbf3-4489-b379-286b21f99fd8	PESQUERA GEMINIS  S.A.	Mar del Plata		410-0051 / 7	\N		\N	\N		t	\N	\N	\N
e5d9e17b-90b0-4ae5-bc8b-0ae2b02c4ccf	GIANFRANCO	01075	\N	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	PIEA  S.A.	Mar del Plata		489-6317 /489-1367	\N		\N	\N		t	\N	\N	\N
e18e07d2-76a9-4ece-b7a8-5d9a654fdf2d	GIULIANA	02633	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	PESQUERA  MARGARITA  S.A.	Mar del Plata		489-4645   /   489-2946	\N		\N	\N		t	\N	\N	\N
7aa71263-cc88-4196-bb5e-78d1d8f3ac61	GLORIA DEL MAR I	01983	1651	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	54.30	1600	1fcba1f2-fbf3-4489-b379-286b21f99fd8	PESQUERA  DEL  ESTE  S.A.	Mar del Plata	4800005	489-1567	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
96b9ae4d-5891-48e9-b680-f8bc2e7556b0	GRACIELA	0578	\N	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	PEDRO MOSCUZZA e HIJOS  S.A.	Mar del Plata		489-7287	\N		\N	\N		t	\N	\N	\N
709d205f-9448-48c3-b891-6ce1a72ba370	GRACIELA I	3994	2765	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	39.94	0	1fcba1f2-fbf3-4489-b379-286b21f99fd8	PEDRO MOSCUZZA e HIJOS  S.A.	Mar del Plata		489-7287	\N		\N	\N		t	\N	\N	\N
129d79d3-51ce-4eac-9178-ad36f3cecc22	GRAN CAPITAN	01538	1656	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	25.43	541	1fcba1f2-fbf3-4489-b379-286b21f99fd8	ORTIGIA  S.A.	Mar del Plata		489-2679	\N		\N	\N		t	\N	\N	\N
21b16230-b77f-496c-b263-9fe2f0a7b787	GURISES	01386	1667	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	25.20	546	1fcba1f2-fbf3-4489-b379-286b21f99fd8	A.B.H. PESQUERA  S.A.	Mar del Plata		489-6522	\N		\N	\N		t	\N	\N	\N
bbab5229-8a6a-49b3-ae19-b45d67c7b35e	GUSTAVO R	0075	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	60	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	ARGEMER  S.A.	Mar del Plata		451-1247	\N		\N	\N		t	\N	\N	\N
80c832c8-5783-4d9d-81af-b6f920e74698	HAMAZEN MARU N° 68	JA05	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	\N	\N	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	PESQUERA SANTA CRUZ  S.A.	Ciudad Autónoma de Buenos Aires		011-4305-4706	\N		\N	\N		t	\N	\N	\N
24a6b242-38e0-4dc9-abf3-ba79ed2b0711	HAMPON	01410	1673	f66f75bd-9f71-42a6-a319-b9aecc608960	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	10	18.99	497	1fcba1f2-fbf3-4489-b379-286b21f99fd8	PESQUERA HAMPON S.R.L	Mar del Plata			\N		\N	\N		t	\N	\N	\N
2c724906-4815-457e-a276-95cc309448ba	HARENGUS	0510	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	60	\N	\N	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	HARENGUS  S.A.	Puerto Madryn		0280-445-0822	\N		\N	\N		t	\N	\N	\N
5af8c5d9-8082-40f2-9bb1-ff10fa4cfe0d	HOKO 31	05934	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	\N	\N	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	FARO DEL SUR TRADING  S.A.	Ciudad Autónoma de Buenos Aires		011-4555-4956	\N		\N	\N		t	\N	\N	\N
6e19e972-b13d-4b00-9970-c33b453254d3	HOYO MARU 37	JA01	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	\N	\N	caf4d1b5-7a3c-445b-98f9-42d842f1d347	ARGENOVA  S.A.	Puerto Deseado		0297- 487-0550  (447-2818  Com. Riv )	\N		\N	\N		t	\N	\N	\N
ecaca724-3801-4411-bb48-a63621d4bd4f	HSIANG LAI FU	80	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	EL MARISCO  S.A.	Mar del Plata		489-0384	\N		\N	\N		t	\N	\N	\N
0c5144b3-0db4-4c82-8d9b-e5db22222f41	HUYU 961	TEMP-0003	0	49f1a6b1-610e-4aab-98e6-45dbe753fe22	\N	\N	\N	65.70	0	\N					\N		\N	\N		t	\N	\N	\N
7db9cb20-afb3-4813-8204-a04743b23b3f	HUYU 962	03056	0	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	65.60	0	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	ALTAMARE  S.A.	Puerto Madryn		0280-445-7377 / 447-2249	\N		\N	\N		t	\N	\N	\N
fb8e1170-e3b9-4315-bd2a-a71dd5d3eabd	HUYU 906	03026	2747	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	65.92	1579	1fcba1f2-fbf3-4489-b379-286b21f99fd8	CHENG I  S.A.	Mar del Plata		489-1385	\N		\N	\N		t	\N	\N	\N
417dadac-d09c-425f-a95c-54df36b3aeda	HUYU 907	03027	2748	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	72.17	1678	1fcba1f2-fbf3-4489-b379-286b21f99fd8	CHENG I  S.A.	Mar del Plata	4800005	489-1385	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
b2997c23-a243-4254-a482-aee8a1fed1c0	HU YU 910	81	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	PEDRO MOSCUZZA e HIJOS  S.A.	Mar del Plata		489-7287	\N		\N	\N		t	\N	\N	\N
fdff64cc-9ee7-4ba7-bb0c-e9263d30c806	HUAFENG 801	3013	2741	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	65.04	1973	1fcba1f2-fbf3-4489-b379-286b21f99fd8	ARDAPEZ  S.A.	Mar del Plata		480-1561 / 480-1568 / 480-1549	\N		\N	\N		t	\N	\N	\N
342dcc83-82e8-4602-acee-7d7d56d8ff48	HUAFENG 802	3014	2751	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	65.04	1973	1fcba1f2-fbf3-4489-b379-286b21f99fd8	ARDAPEZ  S.A.	Mar del Plata		480-1561 / 480-1568 / 480-1549	\N		\N	\N		t	\N	\N	\N
027d8afc-83c9-4452-9ba9-75f24ecde226	HUA I 616	0392	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	\N	\N	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	ARMADORA  ACRUX  S.A.	Ciudad Autónoma de Buenos Aires		011-4312-6470	\N		\N	\N		t	\N	\N	\N
7737a5fc-bb8d-48e0-8846-0277c9305d23	HUAFENG 815	0554A	0	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	25.28	419	1fcba1f2-fbf3-4489-b379-286b21f99fd8	PESQUERA CHIARMAR S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
845eccf6-72e5-4e7e-8a76-6cfe72be2afe	HUAFENG 820 (ex INFINITUS PEZ)	01472A	\N	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	MELIMAR S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
22ef5c93-5e37-4f1e-b612-20a4b6ddc2e9	HUAFENG 821 (ex INITIO PEZ)	01471A	\N	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	MELIMAR S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
1f299da9-7732-48e9-b696-0ca3f0d9ccb6	IARA	06207	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	\N	\N	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	PESQUERA MADRYN  S.A.	Ciudad Autónoma de Buenos Aires		011-4394-1452	\N		\N	\N		t	\N	\N	\N
1249b442-f64d-4065-bf26-ea794e5d8ff5	IGLU I	01423	1713	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	32.75	660	1fcba1f2-fbf3-4489-b379-286b21f99fd8	GIORNO  S.A.	Mar del Plata		410-0051 / 0057	\N		\N	\N		t	\N	\N	\N
e3e69cb4-7f8d-4ef1-a377-36cbc9e5d414	ILLEX I	125	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	\N	\N	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	ILLEX  S.A.	Ciudad Autónoma de Buenos Aires	4808331/4808332	011-4393-6431	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
f1b96873-e1bc-4b6f-ac98-3469f80c11b9	FLORIDABLANCA II	0252	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	\N	\N	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	PESQUERA SAN ISIDRO S.A.	Puerto Madryn		0280-447-2697	\N		\N	\N		t	\N	\N	\N
6f610ae6-493c-4727-9a40-bd9960b3847d	INITIO PEZ	01471	\N	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	GIORNO  S.A.	Mar del Plata	4800005	410-0051 / 0057	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi	t	\N	\N	\N
c2a51fd6-0460-44a8-a592-31d65e1f29da	ITXAS LUR	0927	1735	49f1a6b1-610e-4aab-98e6-45dbe753fe22	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	60	63.30	1952	1fcba1f2-fbf3-4489-b379-286b21f99fd8	HISPANO PATAGONICA  S.A.	Mar del Plata		480-1002 / 489-3165 / 489-7144	\N		\N	\N		t	\N	\N	\N
6de2f9cb-240f-448a-9903-5d304a1bc430	JOSÉ AMÉRICO	03071	2756	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	44.21	0	1fcba1f2-fbf3-4489-b379-286b21f99fd8	PEDRO MOSCUZZA e HIJOS  S.A.	Mar del Plata		489-7287	\N		\N	\N		t	\N	\N	\N
b1a8ac36-e917-476b-9538-1c774a51fe3d	JOSE LUIS ALVAREZ	0618	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	\N	\N	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	PESQUERA SAN ISIDRO S.A.	Puerto Madryn		0280-447-2697	\N		\N	\N		t	\N	\N	\N
fe7f99ba-a0b2-4abe-82bb-f6d88a662b4f	JOSE MARCELO	3138	2764	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	39.94	0	1fcba1f2-fbf3-4489-b379-286b21f99fd8	PEDRO MOSCUZZA e HIJOS  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
0d01c240-296f-4684-afec-4b4ec790d5b4	JUAN ALVAREZ	0619	1755	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	36.60	1168	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	PESQUERA SAN ISIDRO S.A.	Puerto Madryn		0280-447-2697	\N		\N	\N		t	\N	\N	\N
b9292f03-0c89-443b-80c1-e12ded98ce65	JUAN PABLO II	02695	0	f66f75bd-9f71-42a6-a319-b9aecc608960	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	8	22.49	326	\N	ISLA DE LOS ESTADOS  S.A.	Vivoratá			\N		\N	\N		t	\N	\N	\N
a364eff4-ccf9-4038-8bbd-3e94f0613209	JUDITH I	0908	\N	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	ANTONIO BARILLARI  S.A.	Mar del Plata		481-1173  / 489-0872	\N		\N	\N		t	\N	\N	\N
8029c4f4-7ad2-4f1e-9da5-594e18f1f924	JUEVES SANTO	0667	1762	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	39.50	1244	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	NUVCONSA  S.A.	Ciudad Autónoma de Buenos Aires	4891553-154179360-154179860-154179062	011-4305-4706	\N	agenciasmiriglio@speedy.com.ar	\N	\N	Agencia Maritima Smiriglio	t	\N	\N	\N
8de82e47-3212-4779-8e02-b8481f70e61c	JUPITER II	0406	1769	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	27.90	791	1fcba1f2-fbf3-4489-b379-286b21f99fd8	VENUS  PESQUERA S.R.L.	Mar del Plata	4800005	489-0186	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
d460fd8b-56e4-47ae-950a-18b5556b9546	KALEU KALEU	01963	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	\N	\N	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	KALEU KALEU  S.A.	Ciudad Autónoma de Buenos Aires	4800005	011-3220-2130  / 5093-1215	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi	t	\N	\N	\N
5b0734d6-2b2f-4e93-a09d-ad0d3ce7a31e	KANTXOPE	01065	\N	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	ANTONIO BARILLARI  S.A.	Mar del Plata		481-1173  / 489-0872	\N		\N	\N		t	\N	\N	\N
78b1c26e-ea9a-458f-9346-21a1897b3096	KARINA	01462	\N	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	FRIGORIFICO DON LUIS  S.R.L.	Mar del Plata		489-4645	\N		\N	\N		t	\N	\N	\N
5e108393-3a35-4dde-91e9-788867e8bc4d	LAIA	06521	0	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	53.00	1185	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	PESQUERA MADRYN  S.A.	Ciudad Autónoma de Buenos Aires		011-4394-1452	\N		\N	\N		t	\N	\N	\N
34accdd2-3c11-4737-80df-d13843549a65	LANZA SECA	01181	1852	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	\N	\N	0	24.80	514	1fcba1f2-fbf3-4489-b379-286b21f99fd8	LANZAMAR  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
beba7bd8-bc5f-4edb-a4f5-219971e635c4	LATINA  N° 8	0291	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	\N	\N	caf4d1b5-7a3c-445b-98f9-42d842f1d347	ARGENOVA  S.A.	Puerto Deseado		0297- 487-0550  (447-2818  Com. Riv )	\N		\N	\N		t	\N	\N	\N
aff9ca63-5b6d-468a-b842-09635db0260a	LEAL	0143	1863	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	27.45	601	1fcba1f2-fbf3-4489-b379-286b21f99fd8	PESQUERA LEAL  S.A.	Mar del Plata		489-4624 / 489-0314 (astillero )	\N		\N	\N		t	\N	\N	\N
3552ff83-0a1f-49e9-99bb-eb9270f7fb68	LEKHAN I	00752	1865	f66f75bd-9f71-42a6-a319-b9aecc608960	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	8	18.45	530	1fcba1f2-fbf3-4489-b379-286b21f99fd8	LEKHAN I  S.R.L.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
7256d1e7-80cb-430f-ac87-c8af51b413e8	LETARE	0245	\N	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	LUIS SOLIMENO e HIJOS  S.A.	Mar del Plata		489-3030	\N		\N	\N		t	\N	\N	\N
41638527-f373-43e7-9e14-30d074d11ed1	LIBERTAD DEL MAR 1°	02186	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	TATURIELLO  S.A.	Mar del Plata		489-3833	\N		\N	\N		t	\N	\N	\N
81b4ad51-acff-4062-a1f7-9a06c5ae3a50	LING SHUI N° 3	02210	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	\N	\N	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	MUELLE OCHO  S.A.	Ciudad Autónoma de Buenos Aires		011-4381-1337	\N		\N	\N		t	\N	\N	\N
6e70590f-c356-414b-a9fe-87a50b74d86b	LING SHUI N° 5	02211	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	\N	\N	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	MUELLE OCHO  S.A.	Ciudad Autónoma de Buenos Aires		011-4381-1337	\N		\N	\N		t	\N	\N	\N
b21d8138-eed7-422c-94b6-51a7dadaf6b5	LUIGI	3244	\N	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	LUIS SOLIMENO e HIJOS  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
23ac29de-0af1-4f8e-868b-eb86171fa067	LUCA MARIO	0546	2715	49f1a6b1-610e-4aab-98e6-45dbe753fe22	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	60	79.14	3952	1fcba1f2-fbf3-4489-b379-286b21f99fd8	PESCASOL  S.A.	Mar del Plata	4800274	480-9608 / 481-0464	\N	amalfitanoycia@hotmail.com	\N	\N	Agencia Maritima Almafitano	t	\N	\N	\N
018c208f-da6a-4ac0-abb6-5bf2c331bc79	LUCA SANTINO	3121	0	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	26.31	0	\N	CENTOMAR  S.A.				\N		\N	\N		t	\N	\N	\N
6d6618ce-ef33-4968-9fbf-254fc2440746	LUCIA LUISA	0623	1897	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	27.90	463	1fcba1f2-fbf3-4489-b379-286b21f99fd8	PESQUERA VERAZ  S.A.	Mar del Plata		489-4624 / 489-0314 (astillero)	\N		\N	\N		t	\N	\N	\N
7e9c9a8a-f95b-4d8b-9273-4052cf9bdc84	LUNES SANTO	01132	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	\N	\N	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	IBERCONSA  DE ARGENTINA  S.A.	Puerto Madryn		0280-445-4324	\N		\N	\N		t	\N	\N	\N
f58e07cc-64a9-42d8-8678-4d6810ce79f8	MADONNINA DEL MARE	01112	1912	f66f75bd-9f71-42a6-a319-b9aecc608960	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	8	23.78	601	1fcba1f2-fbf3-4489-b379-286b21f99fd8	FABLED  S.A	Mar del Plata		480-1565	\N		\N	\N		t	\N	\N	\N
df216eae-8544-48e5-b91a-37382952738c	MADRE DIVINA	01556	1915	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	10	26.12	518	1fcba1f2-fbf3-4489-b379-286b21f99fd8	VUOSO HNOS. S.R.L.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
4e8a0292-60d3-4750-9cee-7767d487c06e	MADRE INMACULADA	2378	1916	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	62.80	1852	1fcba1f2-fbf3-4489-b379-286b21f99fd8	ANTONIO BALDINO e HIJOS  S.A. (Saladero)	Mar del Plata		489-6522  /489-0423	\N		\N	\N		t	\N	\N	\N
f985c35b-994c-4226-b2e0-78b2cf8216eb	MADRE MARGARITA	02728	0	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	25.60	541	1fcba1f2-fbf3-4489-b379-286b21f99fd8	PESQUERA  MARGARITA  S.A.	Mar del Plata		489-4645   /   489-2946	\N		\N	\N		t	\N	\N	\N
03466f76-39d6-4f8f-90a2-25692da17a7f	MAGDALENA MARIA  II	02208	\N	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	ANTONIO BARILLARI  S.A.	Mar del Plata	4800005	481-1173  / 489-0872	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
cd43ced5-3bbd-4040-ac2d-fd284e7a9344	MALVINAS ARGENTINAS	0577	1931	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	28.40	458	1fcba1f2-fbf3-4489-b379-286b21f99fd8	PEDRO MOSCUZZA e HIJOS  S.A.	Mar del Plata		489-7287	\N		\N	\N		t	\N	\N	\N
ae4d4bb6-2ff2-4849-bef0-e169658dbd53	MAR  AUSTRAL  I	0208	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	\N	\N	caf4d1b5-7a3c-445b-98f9-42d842f1d347	PESQUERA DESEADO  S.A.	Puerto Deseado		0297-487-0884 / 0327 / 2407	\N		\N	\N		t	\N	\N	\N
f06a9943-b090-440f-9ea4-919ae58fc5ac	MAR AZUL	0934	\N	07f4f8be-5285-4459-9248-90da8b4f1729	\N	\N	\N	\N	\N	\N	CLARAMAR  S.A.		480-7779 - HERNAN		\N	agenciasenoransmdp@yahoo.com	\N	\N	Agencia Maritima SEÑORANS	t	\N	\N	\N
87fb3be7-253a-4eb8-8a93-5668a30e4fcb	MAR DEL CHUBUT	0487	1944	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	28.20	721	1fcba1f2-fbf3-4489-b379-286b21f99fd8	ROMFIOC  SRL	Mar del Plata	4800005		\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi	t	\N	\N	\N
0e6c2946-510d-4e79-a3aa-bddf99e42274	MAR ESMERALDA	0925	\N	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	ANTONIO BARILLARI  S.A.	Mar del Plata		481-1173  / 489-0872	\N		\N	\N		t	\N	\N	\N
245967fa-767b-4b92-b2c1-a918ecd2c6de	INFINITUS PEZ	01472	\N	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	GIORNO  S.A.	Mar del Plata		410-0051 / 0057	\N		\N	\N		t	\N	\N	\N
3b031577-2980-480a-9c2d-bdbe641bab05	MAR NOVIA 2	0116	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	\N	\N	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	MIREMAR  S.A.	Ciudad Autónoma de Buenos Aires		011-4328-4963 / 4	\N		\N	\N		t	\N	\N	\N
a238d7c1-4298-4edc-8b8c-7e27d840596f	MAR SUR	0341	1957	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	36.40	889	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	PESCARGEN  S.A.	Ciudad Autónoma de Buenos Aires		011-5219-0065 ó 5276-9499	\N		\N	\N		t	\N	\N	\N
f55fd163-11e1-40a9-b274-4c80aff18783	MARA I	0210	1960	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	35.31	1209	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	PESCAPUERTA ARGENTINA  S.A.	Puerto Madryn		0280-445-4407	\N		\N	\N		t	\N	\N	\N
d5defbe0-a4e6-4689-9fb4-8860c0afe3ef	MARA II	0209	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	\N	\N	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	PESCAPUERTA ARGENTINA  S.A.	Puerto Madryn		0280-445-4407	\N		\N	\N		t	\N	\N	\N
181e7503-d6e5-4060-922b-239b8dca9336	MARBELLA	01073	1966	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	27.38	736	1fcba1f2-fbf3-4489-b379-286b21f99fd8	MAR DE MESSINA  S.A.	Mar del Plata	beagle1	489-3824	\N		\N	\N		t	\N	\N	\N
fcca0d71-abbd-43b5-a422-d10b7bafcf41	MARCALA I	0532	\N	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	PESANFLOR  S.A.	Mar del Plata		489-6522	\N		\N	\N		t	\N	\N	\N
890e1f52-2fa9-48b9-a234-01ff702b60fa	MARCALA IV	0351	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	\N	\N	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	MARCALA  S.A.	Ciudad Autónoma de Buenos Aires		011-4342-9601 / 4283	\N		\N	\N		t	\N	\N	\N
6d3124ba-8ec1-44a3-a454-4447fa10485f	MAREJADA	01107	1974	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	27.98	624	1fcba1f2-fbf3-4489-b379-286b21f99fd8	VICARP  S.A.	Mar del Plata		480-4378	\N		\N	\N		t	\N	\N	\N
17491828-fbf7-49e3-81ae-7f15df9e6310	MARIA  EUGENIA	01173	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	PEDRO MOSCUZZA e HIJOS  S.A.	Mar del Plata		489-7287	\N		\N	\N		t	\N	\N	\N
59e625c6-ca93-4c74-ba7c-71944a3252ce	HUAFENG 816	05994	0	f66f75bd-9f71-42a6-a319-b9aecc608960	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	4	22.60	521	1fcba1f2-fbf3-4489-b379-286b21f99fd8	COSTA BRAVA  S.A.	Mar del Plata	4800005	489-7538	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
2b0b35c2-7c72-4175-8674-fcfcd27df1c7	MARIA  LILIANA	01174	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	60	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	PEDRO MOSCUZZA e HIJOS  S.A.	Mar del Plata	4893758	489-7287	\N	miguel-visoso@hotmail.com	\N	\N	Agencia Maritima Solvox	t	\N	\N	\N
d17e5c10-ca2e-4e0d-bca0-e7df9f6958ab	MARIA RITA	0436	2000	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	30.95	541	1fcba1f2-fbf3-4489-b379-286b21f99fd8	BAL - FISH  S.A.	Mar del Plata		489-6522	\N		\N	\N		t	\N	\N	\N
baa51d9d-0d53-46ec-a79f-975ae69bdca5	MARIA ALEJANDRA 1º	03074	2750	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	39.20	0	1fcba1f2-fbf3-4489-b379-286b21f99fd8	XEITOSIÑO S.A.	Mar del Plata		410-0051 / 7	\N		\N	\N		t	\N	\N	\N
539f4e0c-0c98-4f47-87e0-89372c469614	MARIA DEL VALLE	02126	1986	f66f75bd-9f71-42a6-a319-b9aecc608960	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	4	16.29	196	cd0af388-5ae6-4ed0-9de5-f8f5a375bf43	FARO CHUBUT  S.R.L.	Rawson		0280-449-6311	\N		\N	\N		t	\N	\N	\N
beb770ca-8403-4204-9902-46cd5a8facf2	MARIA GLORIA	02738	2763	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	28.05	851	1fcba1f2-fbf3-4489-b379-286b21f99fd8	CAYO LARGO  S.A.	Mar del Plata		480-4378	\N		\N	\N		t	\N	\N	\N
39cafebc-e125-4d3a-b860-1cc4f314a4b4	MARIANELA	01002	2007	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	25.60	541	1fcba1f2-fbf3-4489-b379-286b21f99fd8	AGLIANO  SRL	Mar del Plata		480-2886	\N		\N	\N		t	\N	\N	\N
e232bc4d-eb56-4896-b954-caada87e6aca	MARTA S	01001	0	f66f75bd-9f71-42a6-a319-b9aecc608960	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	8	23.90	503	1fcba1f2-fbf3-4489-b379-286b21f99fd8	WERZOWA  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
be80ea1f-20ba-4066-b5e1-43a282771fba	MATACO II	02243	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	60	\N	\N	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	HAMALTAL  S.A.	Puerto Madryn	4800005	0280-445-0822	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
c26786f0-a9dd-4f2f-b86a-87bdc65ad05e	MATEO I	02172	2028	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	67.97	1776	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	KALEU KALEU  S.A.	Ciudad Autónoma de Buenos Aires		011-3220-2130  / 5093-1215	\N		\N	\N		t	\N	\N	\N
88dfab65-f10d-44c5-873a-ed8380291496	MELLINO I	0379	2032	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	47.25	1185	1fcba1f2-fbf3-4489-b379-286b21f99fd8	GIORNO  S.A.	Mar del Plata		410-0051 / 0057	\N		\N	\N		t	\N	\N	\N
003aaa87-f2de-4957-9ef3-b92cb27a2244	MELLINO II	01424	0	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	38.91	795	1fcba1f2-fbf3-4489-b379-286b21f99fd8	GIORNO  S.A.	Mar del Plata	AVENIDA DE LOS PESCADORES 195	410-0051 / 0057	\N		\N	\N	Agencia AMALFITANO	t	\N	\N	\N
0f881509-65a1-4ec3-9294-30122065d1fc	MELLINO VI	0378	2034	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	64.87	1235	1fcba1f2-fbf3-4489-b379-286b21f99fd8	GIORNO  S.A.	Mar del Plata		410-0051 / 0057	\N		\N	\N		t	\N	\N	\N
d511d289-9f9b-4510-8abd-9b572eb8176c	MERCEA C	0318	2036	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	\N	\N	0	29.15	866	1fcba1f2-fbf3-4489-b379-286b21f99fd8	ALLELOCCIC  S.A.	Mar del Plata		495-4467 / 480-8565	\N		\N	\N		t	\N	\N	\N
ca7f54d1-1f85-402d-9c95-adb7e83b4219	MESSINA I	01089	2038	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	27.29	650	1fcba1f2-fbf3-4489-b379-286b21f99fd8	MAR DE MESSINA  S.A.	Mar del Plata		489-3824	\N		\N	\N		t	\N	\N	\N
d91cd55f-4e50-4a9a-98cf-00f01719b130	MEVIMAR	01508A	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	\N	\N	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	RIMINIMARR  S.A.	Puerto Madryn		0280-445-2248	\N		\N	\N		t	\N	\N	\N
332e1070-ccdf-40a3-9754-c72f30725ddd	MIERCOLES SANTO	0666	2041	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	38.50	1244	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	NUVCONSA  S.A.	Ciudad Autónoma de Buenos Aires		011-4305-4706	\N		\N	\N		t	\N	\N	\N
0404c0a5-9159-458a-a8b7-f0bda79b67c0	MILLENNIUM	0466	2046	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	55.05	1329	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	PESQUERA CRUZ DEL SUR  S.A.	Ciudad Autónoma de Buenos Aires		011-4784-1760	\N		\N	\N		t	\N	\N	\N
d071949d-fc5d-4529-8f1b-52589820e465	MINCHOS OCTAVO	03022	2744	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	39.30	579	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	IBERCONSA  DE ARGENTINA  S.A.	Puerto Madryn		0280-445-4324	\N		\N	\N		t	\N	\N	\N
6a728901-f71b-477d-93e9-d7375a764fc7	NINA	3171	2770	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	44.00	1620	\N	PEDRO MOSCUZZA e HIJOS  S.A.				\N		\N	\N		t	\N	\N	\N
d3650f8f-6435-4739-a710-f32bc1b71cce	MIRIAM	0370	2051	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	36.35	1446	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	VIEIRA ARGENTINA  S.A.	Ciudad Autónoma de Buenos Aires	4800005		\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi	t	\N	\N	\N
1cbcf1ac-fad5-4221-bb01-d5f5e155eb0d	MISHIMA MARU N°8	02175	2054	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	63.43	1579	1fcba1f2-fbf3-4489-b379-286b21f99fd8	BAL - FISH  S.A.	Mar del Plata	4800274	489-6522	\N	amalfitanoycia@hotmail.com	\N	\N	Agencia Maritima Almafitano	t	\N	\N	\N
c991a706-a3dd-4ca3-8bbe-e5cf884dea37	MISS PATAGONIA	0555	2055	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	28.20	667	1fcba1f2-fbf3-4489-b379-286b21f99fd8	PESQUERA VERAZ  S.A.	Mar del Plata	4805743	489-4624 / 489-0314 (astillero)	\N	agenciadiyorio@hotmail.com -joseph@hotmail.com	\N	\N	Agencia Di Yorio	t	\N	\N	\N
fc67a193-73d3-42e6-9aa7-7811e559cbfb	MINTA	02196	2050	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	551b3773-09f9-4eb6-a9ce-88abf50b63a1	40	65.10	1603	1fcba1f2-fbf3-4489-b379-286b21f99fd8	LIYA  S.A.	Ciudad Autónoma de Buenos Aires		011-4964-2227	\N		\N	\N		t	\N	\N	\N
f6667e6a-9e1a-4363-85fb-0085fc9cbe6d	MISTER BIG	0534	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	WANCHESE ARGENTINA  S.A.	Mar del Plata		489-1236	\N		\N	\N		t	\N	\N	\N
9daac8a4-b456-4ae3-beb9-e0f1798c2a9f	MIURA MARU	05996	2058	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	53.20	1482	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	LIYA  S.A.	Ciudad Autónoma de Buenos Aires		011-4964-2227	\N		\N	\N		t	\N	\N	\N
b890a64d-53e1-475c-a242-257a29f1e941	MONTE DE VIOS	0664	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	\N	\N	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	PESQUERA SANTA CRUZ  S.A.	Ciudad Autónoma de Buenos Aires		011-4305-4706	\N		\N	\N		t	\N	\N	\N
f494b1f2-975d-458d-8b0e-21f1e7540a83	MISS TIDE	02439	2056	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	79d74266-23c8-4096-b660-cda06d12272c	30	52.52	2254	1fcba1f2-fbf3-4489-b379-286b21f99fd8	WANCHESE ARGENTINA  S.A.	Mar del Plata		489-1236	\N		\N	\N		t	\N	\N	\N
b46fa8fa-76ee-4d66-84cf-8281ae74a0ac	MAR NOVIA 1	0115	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	\N	\N	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	CINCOMAR  S.A.	Ciudad Autónoma de Buenos Aires		011-4326-4991	\N		\N	\N		t	\N	\N	\N
dea66f59-f910-4e72-a9c5-fb138412be0c	NAVEGANTES	0542	2079	49f1a6b1-610e-4aab-98e6-45dbe753fe22	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	60	58.00	1925	1fcba1f2-fbf3-4489-b379-286b21f99fd8	PESQUERA COMERCIAL  S.A.	Mar del Plata		489-3030	\N		\N	\N		t	\N	\N	\N
babbdc2b-f878-45cc-a161-615a14d43817	NAVEGANTES II	01451	2080	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	63.70	1603	1fcba1f2-fbf3-4489-b379-286b21f99fd8	PESQUERA COMERCIAL  S.A.	Mar del Plata		489-3030	\N		\N	\N		t	\N	\N	\N
1c20a49a-26af-427b-bb3e-14962058c07d	NATALIA	02066	2075	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	551b3773-09f9-4eb6-a9ce-88abf50b63a1	40	68.45	1779	1fcba1f2-fbf3-4489-b379-286b21f99fd8	PEDRO MOSCUZZA e HIJOS  S.A.	Mar del Plata		489-7287	\N		\N	\N		t	\N	\N	\N
17cfcf73-4e35-4773-b1a8-b5c377e009ff	NDDANDDU	0141	2082	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	28.20	856	1fcba1f2-fbf3-4489-b379-286b21f99fd8	PESQUERA VERAZ  S.A.	Mar del Plata		489-4624 / 489-0314 (astillero)	\N		\N	\N		t	\N	\N	\N
d4b14f2e-c490-45d3-b168-9e56bd141093	NEPTUNIA I	02125	\N	f66f75bd-9f71-42a6-a319-b9aecc608960	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	4	\N	\N	cd0af388-5ae6-4ed0-9de5-f8f5a375bf43	FLOTA AMARILLA RAWSON	Rawson	4891553-154179360-154179860-154179062		\N	agenciasmiriglio@speedy.com.ar	\N	\N	Agencia Maritima SMIRIGLIO	t	\N	\N	\N
d1fc8554-8bd8-4753-8d25-1961ac6fff9b	NIÑO JESUS DE PRAGA	3194	2775	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	27.74	1180	1fcba1f2-fbf3-4489-b379-286b21f99fd8	RITORNO SALLUSTIO Y CICCIOTTI  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
7e651893-1a83-4f84-8bc1-086a0436faf9	NONO PASCUAL	02854	2729	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	10	24.00	451	1fcba1f2-fbf3-4489-b379-286b21f99fd8	CANAL DE BEAGLE  S.R.L.	Mar del Plata		480-4447 / 5004265 PASCUAL	\N		\N	\N		t	\N	\N	\N
359f6ba5-792d-4d4d-8860-4d2a7367c1a2	NUEVA LUCIA MADRE	01501	2113	d217e8f2-267d-47cb-b9a2-6a22e6366eba	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	8	14.37	416	1fcba1f2-fbf3-4489-b379-286b21f99fd8	NUEVA LUCIA MADRE  S.R.L.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
9e79fdb5-f874-4406-b04b-892e1e1491ce	NUEVA NEPTUNIA I	02634	0	f66f75bd-9f71-42a6-a319-b9aecc608960	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	4	20.00	403	cd0af388-5ae6-4ed0-9de5-f8f5a375bf43	ORION S.R.L.	Rawson			\N		\N	\N		t	\N	\N	\N
0d4e69a4-2111-4682-abcf-01c29e5725d3	NUEVO ANITA	02100	2128	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	30.90	765	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	IBERCONSA  DE ARGENTINA  S.A.	Puerto Madryn		0280-445-4324	\N		\N	\N		t	\N	\N	\N
5f27f5b0-2fab-4b79-9799-295be4e121ec	NUEVO VIENTO	01449	2135	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	22.23	541	1fcba1f2-fbf3-4489-b379-286b21f99fd8	NUEVO VIENTO  SRL	Mar del Plata		480-8565	\N		\N	\N		t	\N	\N	\N
2fc340d4-5499-4bc0-99e9-33a9e3612a10	OMEGA 3	01391	\N	f66f75bd-9f71-42a6-a319-b9aecc608960	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	10	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	COSTA BRAVA  S.A.	Mar del Plata		489-7538	\N		\N	\N		t	\N	\N	\N
192b76f1-3fde-47f2-a22d-982849f2569d	ORION  2	01492	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	\N	\N	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	PESQUERA SANTA CRUZ  S.A.	Ciudad Autónoma de Buenos Aires		011-4305-4706	\N		\N	\N	norberto.lopez@iberconsa.com	t	\N	\N	\N
797ea1c4-7782-4041-98c5-c660cea87fc1	ORION 5	02637	2757	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	65.62	1776	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	PESQUERA SANTA CRUZ  S.A.	Ciudad Autónoma de Buenos Aires		011-4305-4706	\N		\N	\N		t	\N	\N	\N
0ef14917-07f6-49d9-8127-d42e73486520	ORION I	01943A	0	f66f75bd-9f71-42a6-a319-b9aecc608960	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	20.90	520	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	PESQUERA CRUZ DEL SUR  S.A.	Ciudad Autónoma de Buenos Aires		011-4784-1760	\N		\N	\N		t	\N	\N	\N
faa9f119-fb01-48c3-ba09-afe1509cb1a3	ORION 1	01943	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	\N	\N	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	PESQUERA SANTA CRUZ  S.A.	Ciudad Autónoma de Buenos Aires		011-4305-4706	\N		\N	\N		t	\N	\N	\N
0a5813f3-0eef-4ba9-b546-2d0d1cb3f9fa	ORION 3	02167	2170	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	63.10	1776	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	PESQUERA SANTA CRUZ  S.A.	Ciudad Autónoma de Buenos Aires		011-4305-4706	\N		\N	\N		t	\N	\N	\N
27b7bdea-8788-40e6-9bf7-e14d69b3ca4f	ORYONG  756	02092	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	\N	\N	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
b9c94eb6-934a-4681-9cca-31f6f5837178	PACHACA	02572	2180	f66f75bd-9f71-42a6-a319-b9aecc608960	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	4	17.64	320	cd0af388-5ae6-4ed0-9de5-f8f5a375bf43	FLOTA AMARILLA RAWSON	Rawson			\N		\N	\N		t	\N	\N	\N
6c3f596a-27e2-4af8-a26f-876f22c41b04	PADRE PIO	02822	2737	f66f75bd-9f71-42a6-a319-b9aecc608960	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	24.00	451	1fcba1f2-fbf3-4489-b379-286b21f99fd8	RITORNO SALLUSTIO Y CICCIOTTI  S.A.	Mar del Plata		480-5508	\N		\N	\N		t	\N	\N	\N
41bcca94-82b6-4f8f-a8ad-00089297a3f1	PAGRUS II	01393	\N	f66f75bd-9f71-42a6-a319-b9aecc608960	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	4	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	COSTA BRAVA  S.A.	Mar del Plata		489-7538	\N		\N	\N		t	\N	\N	\N
176ddc80-30b0-47d5-9aa5-230f6114d058	PAKU	0250	2186	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	39.16	1087	1fcba1f2-fbf3-4489-b379-286b21f99fd8	LUIS SOLIMENO e HIJOS  S.A.	Mar del Plata		489-3030	\N		\N	\N		t	\N	\N	\N
1502f163-a064-4ca5-a75a-8081ef04cd3b	PALOMA V	64	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	300e8934-6a93-46e3-a1b9-1e48cf0b8d91	\N	60	\N	\N	\N					\N		\N	\N		t	\N	\N	\N
65bf7c2a-c9b2-4ea3-8b67-a7f9eb1c783c	PAOLA  S	0557	\N	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	\N	\N	30	\N	\N	\N					\N		\N	\N		t	\N	\N	\N
a8af050e-40a4-43fc-8028-cb1470d3a271	PASA  82	0338	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	\N	\N	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
920cb2ad-bf53-405e-90d8-7c3634770fa2	PATAGONIA	0284	2196	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	30.95	660	1fcba1f2-fbf3-4489-b379-286b21f99fd8	LUIS SOLIMENO e HIJOS  S.A.	Mar del Plata		489-3030	\N		\N	\N		t	\N	\N	\N
289a5889-0258-4aab-9ae1-b8eb41d586a3	PATAGONIA 1	02163	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	\N	\N	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	PATAGONIA  FISHING  S.A.	Ciudad Autónoma de Buenos Aires		011-4932-2777	\N		\N	\N		t	\N	\N	\N
4b24cae0-dd8f-4461-a316-864191d11dc1	PATAGONIA 2	02164	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	\N	\N	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	PATAGONIA  FISHING  S.A.	Ciudad Autónoma de Buenos Aires		011-4932-2777	\N		\N	\N		t	\N	\N	\N
43b2abc2-ba48-41e1-8c89-a7d200779999	PEDRITO	TEMP-0005	0	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	\N	39.92	1201	\N					\N		\N	\N		t	\N	\N	\N
9f8b92e7-325c-434b-9a65-63dcb9b688f2	PELAGOS	83	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	\N	\N	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	PESQUERA SAN ISIDRO S.A.	Puerto Madryn		0280-447-2697	\N		\N	\N		t	\N	\N	\N
4e513b95-7afc-4d99-bcf6-a10303612582	PENSACOLA I	0747	2207	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	25.20	380	9b892e55-acb6-4574-802b-8058aaecd464	FRANGELA  S.A.	Comodoro Rivadavia			\N		\N	\N		t	\N	\N	\N
683feb34-b7a4-41b9-982f-bacbe9a47d1c	PESCAPUERTA CUARTO	0171	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	60	\N	\N	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	PESCAPUERTA ARGENTINA  S.A.	Puerto Madryn		0280-445-4407	\N		\N	\N		t	\N	\N	\N
e53c41ef-bf9f-4b16-8f2c-9fec0d57fa08	PESCAPUERTA QUINTO	0538	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	60	\N	\N	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	PESCAPUERTA ARGENTINA  S.A.	Puerto Madryn		0280-445-4407	\N		\N	\N		t	\N	\N	\N
04138de3-b5dc-4f04-9cc3-c8be2dfac6f5	PESCARGEN  V	078	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	60	\N	\N	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	PESCARGEN  S.A.	Ciudad Autónoma de Buenos Aires		011-5219-0065 ó 5276-9499	\N		\N	\N		t	\N	\N	\N
f89d1892-cda1-4784-9dd0-53a36d256388	PESCARGEN III	021	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	60	\N	\N	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	PESCARGEN  S.A.	Ciudad Autónoma de Buenos Aires		011-5219-0065 ó 5276-9499	\N		\N	\N		t	\N	\N	\N
7a967f63-fd3b-4de7-b42f-8f3e7b6ecdfa	PESCARGEN IV	0150	2217	49f1a6b1-610e-4aab-98e6-45dbe753fe22	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	60	63.20	1603	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	PESCARGEN  S.A.	Ciudad Autónoma de Buenos Aires		011-5219-0065 ó 5276-9499	\N		\N	\N		t	\N	\N	\N
be04b4aa-4adb-414c-a9db-caa03ab783e1	PESPASA  II	0212	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	\N	\N	caf4d1b5-7a3c-445b-98f9-42d842f1d347	PESPASA  S.A.	Puerto Deseado		0297-487-2030  int 12	\N		\N	\N		t	\N	\N	\N
794029cb-c7d3-4d57-9d44-625a11b6da5d	NAVEGANTES III	02065	2081	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	551b3773-09f9-4eb6-a9ce-88abf50b63a1	40	68.60	2203	1fcba1f2-fbf3-4489-b379-286b21f99fd8	PESQUERA COMERCIAL  S.A.	Mar del Plata	4800274	489-3030	\N	amalfitanoycia@hotmail.com	\N	\N	Agencia Maritima Almafitano	t	\N	\N	\N
f1e3eb78-7a87-4045-91ab-034c7e866639	NANINA	02576	2073	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	72.08	1678	1fcba1f2-fbf3-4489-b379-286b21f99fd8	PEDRO MOSCUZZA e HIJOS  S.A.	Mar del Plata	4800005	489-7287	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
286e184f-f348-4192-9451-8b90b240a5eb	PETREL	01445	2224	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	29.85	776	1fcba1f2-fbf3-4489-b379-286b21f99fd8	OLAMAR  S.A.	Mar del Plata		480-3573	\N		\N	\N		t	\N	\N	\N
3029416d-e79f-479f-b77e-6c0c94c68435	PIONEROS	02735	\N	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	CALME  S.A.	Mar del Plata		480-3545	\N		\N	\N		t	\N	\N	\N
3da60bdb-d9a7-4ad1-ad83-24d1c83b0f34	POLARBORG I	02122	\N	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	\N	\N	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	GRINFIN  S.A.	Ciudad Autónoma de Buenos Aires		011-4343-5626	\N		\N	\N		t	\N	\N	\N
8f3dc290-4b1e-4fa3-a13b-d556a3a4d33c	POLARBORG II	02117	\N	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	\N	\N	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	GRINFIN  S.A.	Ciudad Autónoma de Buenos Aires	4800005	011-4343-5626	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi	t	\N	\N	\N
b05ce232-db01-49e5-937c-e023031e7541	PONTE CORUXO	0975	2242	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	52.85	1383	1fcba1f2-fbf3-4489-b379-286b21f99fd8	BAL - FISH  S.A.	Mar del Plata		489-6522	\N		\N	\N		t	\N	\N	\N
9ec73119-234d-4cb1-9f4e-2e40f9638e03	PONTE DE RANDE	0244	2243	49f1a6b1-610e-4aab-98e6-45dbe753fe22	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	60	79.14	2964	1fcba1f2-fbf3-4489-b379-286b21f99fd8	COSTA MARINA  S.A.	Mar del Plata		480-9608 / 481-0464	\N		\N	\N		t	\N	\N	\N
778e772b-3681-4ad8-befc-f1312a5cd88b	PORTO BELO I	02699	2736	f66f75bd-9f71-42a6-a319-b9aecc608960	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	8	23.98	600	1fcba1f2-fbf3-4489-b379-286b21f99fd8	FARO RECALADA  S.A	Mar del Plata		480-2442	\N		\N	\N		t	\N	\N	\N
6f5b423a-f47b-4059-9ca3-7a4e106cb91f	PORTO BELO II	02790	2728	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	10	23.98	601	1fcba1f2-fbf3-4489-b379-286b21f99fd8	MARITIMA PORTO BELO  S.A.	Mar del Plata		489-1553	\N		\N	\N		t	\N	\N	\N
c536bfb7-0c7d-4a5d-af00-e9e6e53e59b9	PRINCIPE AZUL	TEMP-0006	\N	f66f75bd-9f71-42a6-a319-b9aecc608960	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	10	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8		Mar del Plata			\N		\N	\N		t	\N	\N	\N
bf590639-2ee9-4c15-a372-6e567a4f463e	PROMAC	4815	2257	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	33.45	721	1fcba1f2-fbf3-4489-b379-286b21f99fd8	LUIS SOLIMENO e HIJOS  S.A.	Mar del Plata		489-3030	\N		\N	\N		t	\N	\N	\N
4fd8fb74-6afc-4298-9cf1-3f194e1392ff	PROMARSA I	072	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	\N	\N	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	ALPESCA  S.A.	Puerto Madryn		0280-447-4958 / 45-1069	\N		\N	\N		t	\N	\N	\N
aec413f1-914f-48ea-95f3-fd70c0a1d5ed	PROMARSA II	073	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	\N	\N	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	ALPESCA  S.A.	Puerto Madryn		0280-447-4958 / 45-1069	\N		\N	\N		t	\N	\N	\N
d238cbb3-3c62-440e-ac29-cd60b8bfade0	PROMARSA III	02096	0	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	35.84	1062	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	ALPESCA  S.A.	Puerto Madryn		0280-447-4958 / 45-1069	\N		\N	\N		t	\N	\N	\N
2cdca49a-8246-4a32-8fdf-6866325de54c	PUENTE VALDES	02205	2266	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	58.15	1383	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	PEREIRA  ARGENTINA  S.A.	Puerto Madryn		0280-445-7377 / 447-2249	\N		\N	\N		t	\N	\N	\N
1c522203-d91b-4645-8ded-b78ec8fa3cfb	PUENTE AMERICA	0164	\N	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	\N	\N	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	PEREIRA  ARGENTINA  S.A.	Puerto Madryn		0280-445-7377 / 447-2249	\N		\N	\N		t	\N	\N	\N
73dba615-8b44-475e-8b6d-4063db3264c5	PUENTE CHICO	0756	2263	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	37.00	1175	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	PEREIRA  ARGENTINA  S.A.	Puerto Madryn		0280-445-7377 / 447-2249	\N		\N	\N		t	\N	\N	\N
4bc09749-126b-47be-b75f-4b25cce0801f	PUENTE MAYOR	02630	2703	49f1a6b1-610e-4aab-98e6-45dbe753fe22	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	60	66.86	2416	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	PEREIRA  ARGENTINA  S.A.	Puerto Madryn		0280-445-7377 / 447-2249	\N		\N	\N		t	\N	\N	\N
39a02de4-eaa8-4c87-bfdf-ee999a2d0c55	PUENTE SAN JORGE	0207	2265	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	35.30	1001	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	PEREIRA  ARGENTINA  S.A.	Puerto Madryn		0280-445-7377 / 447-2249	\N		\N	\N		t	\N	\N	\N
77badf4c-2134-47e9-bfac-c3f2f0de5b39	PUERTO WILLIAMS	3178	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	60	\N	\N	86f70064-a55b-4d55-b7e9-dc3f320c4cc1	DERIS  S.A.	Punta Arenas -  Chile		+613 6224-8744	\N		\N	\N		t	\N	\N	\N
340e24c4-5c6c-40da-ae1c-bb140dea7608	PUNTA BALLENA	65	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	300e8934-6a93-46e3-a1b9-1e48cf0b8d91	\N	60	\N	\N	\N					\N		\N	\N		t	\N	\N	\N
4fce229d-bcf0-442c-97c0-a714a087fd9e	QUEQUEN SALADO	0580	2277	f66f75bd-9f71-42a6-a319-b9aecc608960	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	4	19.45	271	cd0af388-5ae6-4ed0-9de5-f8f5a375bf43	PISCAL  S.A.	Rawson			\N		\N	\N		t	\N	\N	\N
466c8660-d50c-4d0e-bba9-727034f6bb2a	RAFFAELA	01401	2280	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	26.50	624	1fcba1f2-fbf3-4489-b379-286b21f99fd8	PESQUERA RAFFAELA  S.A.	Mar del Plata		489-56574 int 203	\N		\N	\N		t	\N	\N	\N
99b97cd2-09e1-41c4-95e9-fc6e5658469c	RAQUEL	01074	\N	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	PIEA  S.A.	Mar del Plata		489-6317 /489-1367	\N		\N	\N		t	\N	\N	\N
098e3bdc-18ce-4c4c-9cc9-4e3be71a7580	REPUNTE	01120	\N	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	OSTRAMAR  S.A.	Mar del Plata		489-1959	\N		\N	\N		t	\N	\N	\N
0e17fdb3-9c1a-4ba5-abcc-f61026bcd6e9	REYES DEL MAR II	0408	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	\N	\N	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	AGUA MARINA  S.A.	Ciudad Autónoma de Buenos Aires		011-4342-0605 / 5656 / 1709	\N		\N	\N		t	\N	\N	\N
c4239664-42cb-4195-837b-5179efc6dd3f	RIBAZON DORINE	0921	\N	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	\N	\N	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	KALEU KALEU  S.A.	Ciudad Autónoma de Buenos Aires		011-3220-2130  / 5093-1215	\N		\N	\N		t	\N	\N	\N
572c5dbd-fd46-4b6a-b3d8-d2c27530137d	RIBAZON INES	0751	2306	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	38.50	720	1fcba1f2-fbf3-4489-b379-286b21f99fd8	SOUTH FISH  S.A.	Mar del Plata		480-5202	\N		\N	\N		t	\N	\N	\N
a30750d4-8271-40cc-8297-ee71fde012a6	RIGEL	0266	\N	f66f75bd-9f71-42a6-a319-b9aecc608960	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	10	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	LUIS SOLIMENO e HIJOS  S.A.	Mar del Plata		489-3030	\N		\N	\N		t	\N	\N	\N
693d5599-d00c-431b-8541-8251a4bdaf2e	ROCIO DEL MAR	01568	2313	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	15	22.60	541	1fcba1f2-fbf3-4489-b379-286b21f99fd8	ROCIO DEL MAR  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
7ddfe3d5-db65-49cb-9f2b-0e1a746677d0	ROSARIO  G	0549	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	\N	\N	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
5edf39b5-994e-485d-bd13-6e36df418d97	RUMBO ESPERANZA	01211	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	\N	\N	9b892e55-acb6-4574-802b-8058aaecd464	CAPAC  SRL	Comodoro Rivadavia		0297-446-1499  /  444-2233	\N		\N	\N		t	\N	\N	\N
d196c4c4-f01d-4915-8318-764e7e9f41cb	SALVADOR R	02755	2761	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	27.73	420	1fcba1f2-fbf3-4489-b379-286b21f99fd8	URBIPEZ  S.A.	Mar del Plata		4892793	\N		\N	\N		t	\N	\N	\N
df895f92-b1d9-4214-a045-b4983208793c	SAN ANDRES APOSTOL	0569	2340	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	54.56	2269	1fcba1f2-fbf3-4489-b379-286b21f99fd8	PESANFLOR  S.A.	Mar del Plata		489-6522	\N		\N	\N		t	\N	\N	\N
7aa26773-24b0-4b2e-8a47-cc889fe6b2e4	SAN ANTONINO	0375	\N	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	SEA FISH  S.A.	Mar del Plata	51-11-65337853	480-0336	\N		\N	\N	Natalia Cedrato	t	\N	\N	\N
cd42dafe-91fe-4ae2-9155-54de3fbe405b	SAN BENEDETTO	02643	0	f66f75bd-9f71-42a6-a319-b9aecc608960	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	8	15.38	220	1fcba1f2-fbf3-4489-b379-286b21f99fd8	PESQUERA SAN BENEDETTO  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
f1d98157-0e52-4af2-aeae-9ff6480f6f60	SAN GENARO	0763	\N	f66f75bd-9f71-42a6-a319-b9aecc608960	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	10	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	LESAUMON  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
4a0d4c08-b929-4075-a17c-0a0d479f4cc4	SAN JUAN B	TEMP-0007	2780	49f1a6b1-610e-4aab-98e6-45dbe753fe22	\N	\N	\N	39.94	1204	\N					\N		\N	\N		t	\N	\N	\N
c6da883f-378e-473f-ab46-597ab6d5773a	SAN JORGE MARTIR	02152	2367	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	56.10	1408	1fcba1f2-fbf3-4489-b379-286b21f99fd8	PESANFLOR  S.A.	Mar del Plata		489-6522	\N		\N	\N		t	\N	\N	\N
9b521dd3-43c9-4aa5-b948-7d6356cf1930	VALERIA DEL ATLÁNTICO	02098	2346	49f1a6b1-610e-4aab-98e6-45dbe753fe22	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	60	56.46	4698	86f70064-a55b-4d55-b7e9-dc3f320c4cc1	SAN ARAWA  S.A.	Mar del Plata		492-2216 / 492-0450	\N		\N	\N		t	\N	\N	\N
2607d89b-3aeb-4d25-909b-533e141567f4	PESPASA I	0211	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	\N	\N	caf4d1b5-7a3c-445b-98f9-42d842f1d347	PESPASA  S.A.	Puerto Deseado		0297-487-2030  int 12	\N		\N	\N		t	\N	\N	\N
c237adcf-f4c0-4601-a110-f0cddcaff8b6	SAN MATIAS	0289	\N	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	PESCA  ANTIGUA  S.A.	Mar del Plata		489-2340	\N		\N	\N		t	\N	\N	\N
9415a9ed-f9cd-42cf-872f-40a40acefeb2	SAN PABLO	0759	\N	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	PRODUCTORA ARGEN-PESCA  S.A.	Mar del Plata		480-1444	\N		\N	\N		t	\N	\N	\N
907f78a8-930a-4c68-8a7b-7b029003d56f	SAN PASCUAL	0367	\N	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	BUENOS AIRES PESCA  S.A.	Mar del Plata		489-6522	\N		\N	\N		t	\N	\N	\N
df4b2b60-09d8-4dba-8b57-4053b41d0015	SAN PEDRO APOSTOL	01975	\N	f66f75bd-9f71-42a6-a319-b9aecc608960	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	10	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	GAAD GROUP S.A.	Mar del Plata		480-9327	\N		\N	\N		t	\N	\N	\N
a3bd5d75-837b-4be8-8612-05a43c2cc28a	SANT ANTONIO	0974	\N	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	A.B.H. PESQUERA  S.A.	Mar del Plata	4895032	489-6522	\N	operacionesconsultoramaritima@gmail.com.ar	\N	\N	Agencia Merlini	t	\N	\N	\N
fd1a9330-68f4-45ec-930b-2de226074742	SANTA BARBARA	5857	2409	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	56.96	1679	1fcba1f2-fbf3-4489-b379-286b21f99fd8	PESCA ANGELA  S.A.	Mar del Plata		626-2236 /37	\N		\N	\N		t	\N	\N	\N
563e1699-68ab-4423-8fab-ff0607af3558	SANTA ANGELA	009	\N	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	OSTRAMAR  S.A.	Mar del Plata		489-1959	\N		\N	\N		t	\N	\N	\N
74116457-8192-4af0-bd4b-94c177c09c78	SANTIAGO  I	02280	\N	07f4f8be-5285-4459-9248-90da8b4f1729	\N	\N	0	\N	\N	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	FISHING WORLD  S.A.	Puerto Madryn		0280-445-6533	\N		\N	\N		t	\N	\N	\N
632c8c57-8e27-4b8b-8c3c-b54bb8b65658	SCOMBRUS	0509	\N	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	\N	\N	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	KALEU KALEU  S.A.	Ciudad Autónoma de Buenos Aires		011-3220-2130  / 5093-1215	\N		\N	\N		t	\N	\N	\N
4196dc75-40c2-4fcb-8131-190492bb79fc	SCOMBRUS  II	02245	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	\N	\N	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	HARENGUS  S.A.	Puerto Madryn		0280-445-0822	\N		\N	\N		t	\N	\N	\N
0e445233-dac9-46c1-b318-0c5fd4ff8db3	SERMILIK	0505	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	\N	\N	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	HARENGUS  S.A.	Puerto Madryn	4891553-154179360-154179860-154179062	0280-445-0822	\N	agenciasmiriglio@speedy.com.ar	\N	\N	Agencia Smiriglio	t	\N	\N	\N
bcf44a42-a593-48e9-9a37-dbf6ea8f36db	SFIDA	01567	2439	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	26.50	624	1fcba1f2-fbf3-4489-b379-286b21f99fd8	SAN JORGE S.A.	Mar del Plata		480-6611	\N		\N	\N		t	\N	\N	\N
ad8eef7e-d890-41cc-95c7-785a13ea4199	SHUNYO MARU 178	JA04	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	\N	\N	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	VIEIRA ARGENTINA  S.A.	Ciudad Autónoma de Buenos Aires			\N		\N	\N		t	\N	\N	\N
db62bd30-7982-4e40-afc8-cbfa65a5f541	SIEMPRE DON JOSE MOSCUZZA	02257	2460	49f1a6b1-610e-4aab-98e6-45dbe753fe22	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	38.00	1128	1fcba1f2-fbf3-4489-b379-286b21f99fd8	FRESCOMAR ARGENTINA  S.A.	Mar del Plata		489-7287	\N		\N	\N		t	\N	\N	\N
22d6d88c-5f35-4a38-9cbd-b3408ddd3380	SIEMPRE DON VICENTE	02654	2706	f66f75bd-9f71-42a6-a319-b9aecc608960	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	18.94	341	1fcba1f2-fbf3-4489-b379-286b21f99fd8	PESQUERA VIRGEN DE ITATI  S.R.L.	Mar del Plata		480-2921	\N		\N	\N		t	\N	\N	\N
6c13fc2a-8123-4f4b-9770-f8c34002329b	SIEMPRE SAN SALVADOR	00801	2475	f66f75bd-9f71-42a6-a319-b9aecc608960	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	8	22.35	600	1fcba1f2-fbf3-4489-b379-286b21f99fd8	LOURDESMAR  S.R.L.	Mar del Plata		476-2916	\N		\N	\N		t	\N	\N	\N
543575f5-1f08-4d56-b44e-13bb658672ca	SIEMPRE SANTA ROSA	0494	2476	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	27.80	548	1fcba1f2-fbf3-4489-b379-286b21f99fd8	GIORNO  S.A.	Mar del Plata		410-0051 / 0057	\N		\N	\N		t	\N	\N	\N
ebb9c218-1942-4595-88a4-5e4a1778dd55	SIEMPRE VIEJO PANCHO	2937	2755	f66f75bd-9f71-42a6-a319-b9aecc608960	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	15	17.98	601	\N					\N		\N	\N		t	\N	\N	\N
17cbd116-39a4-4d68-8a25-0092ca2d7481	SIMBAD	0754	\N	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	SOUTH FISH  S.A.	Mar del Plata		480-5202	\N		\N	\N		t	\N	\N	\N
173880d4-335a-4776-b7b5-00bd257d315b	SIRIUS	0905	\N	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	LOBA PESQUERA  S.A.M.C.I.	Mar del Plata	4890960	489-0494  /  481-1814	\N	agencia@maritimavidal.com.ar	\N	\N	Agencia Maritima Vidal	t	\N	\N	\N
227de2db-c4fd-453f-878b-58d281525665	SIRIUS III	0937	\N	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	EL MARISCO  S.A.	Mar del Plata	4808331/4808332	489-0384	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
206d0307-0af3-419a-99d5-165c7b85f486	SOHO MARU Nº 58	02611	2492	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	65.67	1776	caf4d1b5-7a3c-445b-98f9-42d842f1d347	ARGENOVA  S.A.	Puerto Deseado		0297- 487-0550  (447-2818  Com. Riv )	\N		\N	\N		t	\N	\N	\N
51659d5d-f0d6-431c-ae4d-83eb0875ed5a	SOL MARINO	77	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	\N	\N	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	PESQUERA  20  DE NOVIEMBRE  S.A.	Ciudad Autónoma de Buenos Aires		011-4382-5011 / 4381-1337	\N		\N	\N		t	\N	\N	\N
f9d10c17-12b2-4499-9396-38bdffe8472a	STELLA MARIS 1°	0926	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	60	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	ALIMENPEZ  S.A.	Mar del Plata		461-9200	\N		\N	\N		t	\N	\N	\N
86ed3231-e57f-4219-84af-5983ea1a51c6	SUEMAR	6186	2722	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	36.60	1168	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	CONGELADORES PATAGONICOS  S.A.	Puerto Madryn		0280-445-6280	\N		\N	\N		t	\N	\N	\N
af57996a-55bc-4383-a030-6ba61751f6cf	SUEMAR DOS	01508	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	\N	\N	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	CONGELADORES PATAGONICOS  S.A.	Puerto Madryn		0280-445-6280	\N		\N	\N		t	\N	\N	\N
4137b14f-bdca-4075-933c-a063201adaa9	SUMATRA	01105	2512	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	33.15	750	1fcba1f2-fbf3-4489-b379-286b21f99fd8	CALME  S.A.	Mar del Plata		480-3545	\N		\N	\N		t	\N	\N	\N
9af6154b-ada1-4ccd-8410-2226900566c3	SUR ESTE 501	01077	\N	07f4f8be-5285-4459-9248-90da8b4f1729	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	\N	\N	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	SUR ESTE ARGEN  S.A.	Ciudad Autónoma de Buenos Aires		011-4816-7648 / 4372-7605	\N		\N	\N		t	\N	\N	\N
aa4be35c-164e-4ebc-bf72-9400cdbb8782	SUR ESTE 502	02201	2520	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	54.60	1670	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	SUR ESTE ARGEN  S.A.	Ciudad Autónoma de Buenos Aires		011-4816-7648 / 4372-7605	\N		\N	\N		t	\N	\N	\N
394f31d4-baea-4d9d-8070-8b18b4d86ebf	SURIMI I	06143	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	\N	\N	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	FARO DEL SUR TRADING  S.A.	Ciudad Autónoma de Buenos Aires		011-4555-4956	\N		\N	\N		t	\N	\N	\N
0ee485c7-d6e2-4553-971d-a88b9f384b0e	TABEIRON	02233	2529	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	40	34.15	889	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	VIEIRA ARGENTINA  S.A.	Ciudad Autónoma de Buenos Aires			\N		\N	\N		t	\N	\N	\N
8507cb87-2cc6-4129-b5e7-54f77a5f39f8	TABEIRON DOS	02323	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	\N	\N	caf4d1b5-7a3c-445b-98f9-42d842f1d347	PESQUERA DESEADO  S.A.	Puerto Deseado	54-11-65337853	0297-487-0884 / 0327 / 2407	\N		\N	\N	Natalia Cedrato	t	\N	\N	\N
345a8210-a79a-4ea0-b3ca-2a822b8e1e20	Nº 75 TAE BAEK	02364	2138	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	55.70	1302	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
0fd7259e-655d-43ff-b831-9735b78e91eb	Nº 606 TAE BAEK	02361	2148	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	55.22	1036	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	ESAMAR  S.A.	Ciudad Autónoma de Buenos Aires		011-4393-8431	\N		\N	\N	54 – 9 - 1141714381	t	\N	\N	\N
2c28cc5a-890c-4152-b972-78aeb3ad281c	TAI AN	1530	2533	49f1a6b1-610e-4aab-98e6-45dbe753fe22	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	60	100.50	4506	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	PRODESUR S.A	Ciudad Autónoma de Buenos Aires		492-2216 / 492-0450	\N		\N	\N	54 – 9 - 1141714381	t	\N	\N	\N
726d75a6-44bf-455b-b62c-a4d542ab4a8d	TAI SEI MARU N°8	02207	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	\N	\N	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	CORPORACION DEL ATLANTICO SUR  S.A.	Ciudad Autónoma de Buenos Aires		011-4105-1133 int 30	\N		\N	\N		t	\N	\N	\N
78a9b02e-953a-4fc7-b955-2169483d1537	SCIROCCO	2574	2430	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	551b3773-09f9-4eb6-a9ce-88abf50b63a1	40	65.93	1589	1fcba1f2-fbf3-4489-b379-286b21f99fd8	PESQUERA COMERCIAL  S.A.	Mar del Plata		489-3030	\N		\N	\N		t	\N	\N	\N
5de9cbc1-43c3-46cb-8657-1dfa307a71f3	SAN MATEO	06306	0	f66f75bd-9f71-42a6-a319-b9aecc608960	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	54.10	1234	cd0af388-5ae6-4ed0-9de5-f8f5a375bf43	IBERPESCA  S.A.	Rawson		0280-449-8176	\N		\N	\N		t	\N	\N	\N
e53ca05c-f5cf-4712-88ed-4f35ccbbf17b	TESON	01541	2552	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	25.97	765	1fcba1f2-fbf3-4489-b379-286b21f99fd8	RITORNO SALLUSTIO Y CICCIOTTI  S.A.	Mar del Plata		480-5508	\N		\N	\N		t	\N	\N	\N
0120a2de-7d7a-44dc-9540-fb564f5c0a92	TIAN YUAN	02173	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	\N	\N	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	CORPORACION DEL ATLANTICO SUR  S.A.	Ciudad Autónoma de Buenos Aires		011-4105-1133 int 30	\N		\N	\N		t	\N	\N	\N
de511d42-ebf5-46c7-bf02-b7bb0d96c61a	TOBA MARU	0241	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	\N	\N	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
01f45be1-d449-4acd-8c2c-00fa60990286	TORNYY	240	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	d08faf9b-60a9-4081-b8ea-ca931995905b	\N	30	\N	\N	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	CRUSTACEOS DEL SUR  S.A.	Ciudad Autónoma de Buenos Aires		011-5218-4287	\N		\N	\N		t	\N	\N	\N
f1f72d4e-c755-4ee4-91a8-b2e2b63472e7	TOZUDO	01219	2566	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	26.74	624	1fcba1f2-fbf3-4489-b379-286b21f99fd8	CABO VERDE  S.A.	Mar del Plata		489-4645	\N		\N	\N		t	\N	\N	\N
f0d3be1f-4afb-43a6-b803-72fbd4f2e68e	TRABAJAMOS	02904	2726	f66f75bd-9f71-42a6-a319-b9aecc608960	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	4	19.94	592	caf4d1b5-7a3c-445b-98f9-42d842f1d347	DESEADO FISH  S.A.	Puerto Deseado			\N		\N	\N		t	\N	\N	\N
f0c01bdc-8887-473a-854e-7dea32db606e	UCHI	01901	2580	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	54.23	1552	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	PESQUERA SANTA ELENA S.A.I.C.	Ciudad Autónoma de Buenos Aires		011-4328-9909	\N		\N	\N		t	\N	\N	\N
9ad713d4-432b-4fa6-9764-7ac904fb6ad4	UNION	01539	\N	f66f75bd-9f71-42a6-a319-b9aecc608960	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	10	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	RITORNO SALLUSTIO Y CICCIOTTI  S.A.	Mar del Plata		480-5508	\N		\N	\N		t	\N	\N	\N
c9d02e31-764f-4cfc-950a-d50e9caad7ad	URABAIN	0612	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	60	\N	\N	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	IBERCONSA  DE ARGENTINA  S.A.	Puerto Madryn	mariano@maritimavidal.com.ar	0280-445-4324	\N		\N	\N	raul@maritimavidal.com.ar	t	\N	\N	\N
a345ae7d-ecba-4f38-b94f-8010e22d3615	UR ERTZA	0377	2587	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	51.00	1482	1fcba1f2-fbf3-4489-b379-286b21f99fd8	LUIS SOLIMENO e HIJOS  S.A.	Mar del Plata		489-3030	\N		\N	\N		t	\N	\N	\N
98bd4c43-978c-4df3-8f64-27181acb208a	VALIENTE I	0211A	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	EXPLOTACION PESQ. DE LA PATAGONIA  S.A.	Mar del Plata		489-4624  /  489-0314 (astillero)	\N		\N	\N		t	\N	\N	\N
a64682f9-dda9-4b0f-8cff-2ca582c58949	VALIENTE II	0212A	2718	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	35.30	1001	1fcba1f2-fbf3-4489-b379-286b21f99fd8	EXPLOTACION PESQ. DE LA PATAGONIA  S.A.	Mar del Plata		489-4624  /  489-0314 (astillero)	\N		\N	\N	agencia@maritimavidal.com.ar	t	\N	\N	\N
e85d97cf-ab2e-4639-8168-2c1783e4273a	TANGO I	02724	2709	49f1a6b1-610e-4aab-98e6-45dbe753fe22	d08faf9b-60a9-4081-b8ea-ca931995905b	ffd18c57-fb77-4959-9191-1a7cf0a17664	30	50.40	1302	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	BENTONICOS DE ARGENTINA  S.A.	Ciudad Autónoma de Buenos Aires		011-5258-2400 / 4407-8240	\N		\N	\N		t	\N	\N	\N
48a3bd5a-5690-405f-9ef2-988b6435e87a	VERAZ	0144	2603	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	27.45	604	1fcba1f2-fbf3-4489-b379-286b21f99fd8	PESQUERA VERAZ  S.A.	Mar del Plata		489-4624 / 489-0314 (astillero)	\N		\N	\N		t	\N	\N	\N
74289586-e9b9-4183-80ec-0e69d90e262c	VERDEL	0174	2604	49f1a6b1-610e-4aab-98e6-45dbe753fe22	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	60	71.70	1975	f20aba40-3236-4ae4-b2aa-9c236e7217fa	IBERMAR  S.A.	Bahia Blanca		0291-457-2427	\N		\N	\N		t	\N	\N	\N
d37954f8-e162-4e6b-b663-30bf93e71682	VERONICA ALEJANDRA N	02292	2606	f66f75bd-9f71-42a6-a319-b9aecc608960	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	4	15.30	223	cd0af388-5ae6-4ed0-9de5-f8f5a375bf43	FARO CHUBUT  S.R.L.	Rawson		0280-449-6311	\N		\N	\N		t	\N	\N	\N
8e9a2ef5-5c93-4acf-aa93-507de5201b3a	VICTOR ANGELESCU	9798820	\N	3396a7a4-5c2b-473e-93a2-d66105f78818	\N	\N	\N	\N	\N	\N	INIDEP				\N		\N	\N		t	\N	\N	\N
f4815519-7dd2-47a3-b5f6-4cfd0a1e5111	VICTORIA DEL MAR 1°	0929	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	RIPSA  S.A. ( ROSALES INDUSTRIAL PESQ. )	Mar del Plata		489-7881	\N		\N	\N		t	\N	\N	\N
60cba71b-3276-4f03-bb1a-f6328992f492	VICTORIA I	0554	\N	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	\N	\N	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	PEREIRA  ARGENTINA  S.A.	Puerto Madryn		0280-445-7377 / 447-2249	\N		\N	\N		t	\N	\N	\N
ecf64f5c-5f0c-4ff4-ae56-1301ee6da79f	VICTORIA II	0556	2611	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	27.40	601	1fcba1f2-fbf3-4489-b379-286b21f99fd8	CRESTAS  S.A.	Mar del Plata		410-5170	\N		\N	\N		t	\N	\N	\N
0fcd7bf5-8180-4f2f-891f-be513e32fee5	VICTORIA P	02246	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	\N	\N	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	PESQUERA SANTA ELENA S.A.I.C.	Ciudad Autónoma de Buenos Aires		011-4328-9909	\N		\N	\N		t	\N	\N	\N
6633f0c6-1194-4ac6-a053-9e8a133dad34	VIEIRASA DIECIOCHO	2563	2615	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	67.78	1803	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	VIEIRA ARGENTINA  S.A.	Ciudad Autónoma de Buenos Aires			\N		\N	\N		t	\N	\N	\N
d0c89ac7-abc4-47d8-a25b-c30c7c2e6e09	VIEIRASA DIECISEIS	0240	2616	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	36.13	702	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	VIEIRA ARGENTINA  S.A.	Ciudad Autónoma de Buenos Aires			\N		\N	\N		t	\N	\N	\N
b45f21ed-e01a-47b1-b39a-a4566510dfe6	VIEIRASA DIECISIETE	2568	2752	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	59.03	1401	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	VIEIRA ARGENTINA  S.A.	Ciudad Autónoma de Buenos Aires			\N		\N	\N		t	\N	\N	\N
9cd23434-c77a-40d4-ba34-e160f68f78a5	VIEIRASA QUINCE	0179	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	\N	\N	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	VIEIRA ARGENTINA  S.A.	Ciudad Autónoma de Buenos Aires			\N		\N	\N		t	\N	\N	\N
143f89ad-7596-423c-872b-7d5a44970667	VIENTO DEL SUR	01858	\N	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	60	\N	\N	caf4d1b5-7a3c-445b-98f9-42d842f1d347	PESPASA  S.A.	Puerto Deseado		0297-487-2030  int 12	\N		\N	\N		t	\N	\N	\N
5b22df51-f0cd-4f0e-ae86-fc13e220a582	VILLARINO	02178	2629	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	64.50	1776	7d5ff874-4bcc-46c2-8c86-cea7587cfe39	PESCA AUSTRAL  S.A.	San Antonio Oeste		02934-49-2111	\N		\N	\N		t	\N	\N	\N
968bd12e-e614-450f-a6a8-69323ae2d67b	VIRGEN DEL CARMEN	0550	\N	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	MAR PURO  S.A.	Mar del Plata		451-1830	\N		\N	\N		t	\N	\N	\N
21e6eb1e-f823-4271-9696-2f5c8bb520a6	VIRGEN DEL MILAGRO	02767	2725	f66f75bd-9f71-42a6-a319-b9aecc608960	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	4	19.93	380	caf4d1b5-7a3c-445b-98f9-42d842f1d347	UNION PESQUERA PATAGONIA  S.A.	Puerto Deseado			\N		\N	\N		t	\N	\N	\N
abb62760-ea09-4dfd-acf9-df505340e3e5	VIRGEN DEL ROCIO	0194	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	\N	\N	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	ALPESCA  S.A.	Puerto Madryn		0280-447-4958 / 45-1069	\N		\N	\N		t	\N	\N	\N
8f31ff24-aea0-4f47-b713-6f9a6a68c51c	VIRGEN MARIA	0541	2645	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	56.65	1803	1fcba1f2-fbf3-4489-b379-286b21f99fd8	LUIS SOLIMENO e HIJOS  S.A.	Mar del Plata		489-3030	\N		\N	\N		t	\N	\N	\N
1ec03c4e-9783-4eec-8cad-b8577b6b7362	VIRGEN MARIA INMACULADA	0369	\N	f66f75bd-9f71-42a6-a319-b9aecc608960	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	10	\N	\N	\N					\N		\N	\N		t	\N	\N	\N
dd7ec3e7-b613-4f1c-8c03-2e60f4bbb971	WIRON  IV	01476	\N	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	TATURIELLO  S.A.	Mar del Plata		489-3833	\N		\N	\N		t	\N	\N	\N
e16204c0-cffc-456a-99bf-457493c02b05	XEITOSIÑO	0403	2668	49f1a6b1-610e-4aab-98e6-45dbe753fe22	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	60	51.72	1502	1fcba1f2-fbf3-4489-b379-286b21f99fd8	PESQUERA EL NAZARENO	Mar del Plata		489-9414 (of. Pers. Emb.)	\N		\N	\N		t	\N	\N	\N
6d74418d-621d-469c-9722-f7907e474c01	XIN SHI JI 25	03092	2753	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	70.50	0	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	PESQUERA  20  DE NOVIEMBRE  S.A.	Ciudad Autónoma de Buenos Aires		011-4382-5011 / 4381-1337	\N		\N	\N		t	\N	\N	\N
bc2b4d9e-9dab-415f-8b35-86faa126c674	XIN SHI JI N° 88	02182	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	\N	\N	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	FENIX  INTERNATIONAL  S.A.	Ciudad Autónoma de Buenos Aires		011-4381-1337	\N		\N	\N		t	\N	\N	\N
96658434-ad2a-473b-a532-d2afe15cb4d2	VENTARRON 1º	0479	2708	49f1a6b1-610e-4aab-98e6-45dbe753fe22	989ce1c1-31ae-4374-abc8-cd39ccc23254	bec74e80-f32e-4e58-9588-35bd863f8715	60	63.07	1969	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	ATUNERA  ARGENTINA  S.A.	Puerto Madryn		0280-445-4324	\N		\N	\N		t	\N	\N	\N
963558b2-f1a1-462a-bb0c-e1c47eebb71b	TANGO II	02791	2714	49f1a6b1-610e-4aab-98e6-45dbe753fe22	d08faf9b-60a9-4081-b8ea-ca931995905b	ffd18c57-fb77-4959-9191-1a7cf0a17664	30	50.40	1302	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	BENTONICOS DE ARGENTINA  S.A.	Ciudad Autónoma de Buenos Aires	4891227	011-5258-2400 / 4407-8240	\N	serviciosmaritimosmdq@gmail.com	\N	\N	Servicios maritimos	t	\N	\N	\N
606e5b4f-52a8-4826-a953-a6982f255c66	XIN SHI JI Nº 92	02930	2742	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	68.58	2685	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	FENIX  INTERNATIONAL  S.A.	Ciudad Autónoma de Buenos Aires		011-4381-1337	\N		\N	\N		t	\N	\N	\N
727feb75-3bb0-4bc7-9f58-6890e63cc040	XIN SHI JI Nº 95	02933	2732	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	68.58	2685	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	PESQUERA  20  DE NOVIEMBRE  S.A.	Ciudad Autónoma de Buenos Aires	155-282636 - Facundo	011-4382-5011 / 4381-1337	\N		\N	\N	Agencia Di Yorio	t	\N	\N	\N
c7d10659-95e1-4052-86e5-8ffd2c35c684	XIN SHI JI N° 99	02181	2674	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	65.10	2173	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	FENIX  INTERNATIONAL  S.A.	Ciudad Autónoma de Buenos Aires		011-4381-1337	\N		\N	\N		t	\N	\N	\N
74ffab39-a58e-4048-81b6-b7cfb92b58b8	XIN SHI JI Nº 98	02995	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	\N	\N	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	PESQUERA  20  DE NOVIEMBRE  S.A.	Ciudad Autónoma de Buenos Aires		011-4382-5011 / 4381-1337	\N		\N	\N		t	\N	\N	\N
d1aca7a2-9b61-4bd1-98d4-1e9bfb620300	YAMATO	077	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	60	\N	\N	86f70064-a55b-4d55-b7e9-dc3f320c4cc1	PESANTAR  S.A. ( Empresa Pesq de la Patagonia y Antartida )	Ushuaia		02901-43-3449 / 43-0008 / 43-0708	\N		\N	\N		t	\N	\N	\N
a76c2de2-3367-42c0-a4e2-8a7910fa161b	YENU	0498A	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	\N	\N	f20aba40-3236-4ae4-b2aa-9c236e7217fa	MARITIMA MONACHESI  S.A.	Bahia Blanca		0291-452-5913	\N		\N	\N		t	\N	\N	\N
96ca7ee3-9b1f-4aee-8c29-038a695f3c37	YOKO MARU	UY252	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	\N	\N	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	EMPESUR  S.A.	Ciudad Autónoma de Buenos Aires		011-4312-0123	\N		\N	\N		t	\N	\N	\N
8af2900b-b164-418a-9b71-5e5628f68b79	ZHOU YU YI HAO	CH251	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	\N	\N	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	VIEIRA ARGENTINA  S.A.	Ciudad Autónoma de Buenos Aires			\N		\N	\N		t	\N	\N	\N
84f490c8-1d32-449f-be65-1cdcf5fb6aca	HOLMBERG	7918189	\N	3396a7a4-5c2b-473e-93a2-d66105f78818	\N	\N	\N	\N	\N	\N	INIDEP				\N		\N	\N		t	\N	\N	\N
e0ec45c2-af9f-4aaa-a8d6-d64488b6405c	MAR ARGENTINO	9883833	\N	3396a7a4-5c2b-473e-93a2-d66105f78818	\N	\N	\N	\N	\N	\N	INIDEP				\N		\N	\N		t	\N	\N	\N
68f3ea0a-6f01-4699-af7d-6f6b57816794	Hai Xiang 16	LW5157	\N	07f4f8be-5285-4459-9248-90da8b4f1729	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	\N	\N	\N	PESQUERA RÍO QUEQUEN				\N		\N	\N		t	\N	\N	\N
6f09eaac-4d86-4a68-ac5e-1331d2c14911	Hai Xiang 17	LW3286	\N	07f4f8be-5285-4459-9248-90da8b4f1729	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	\N	\N	\N	PESQUERA RÍO QUEQUEN				\N		\N	\N		t	\N	\N	\N
01250855-bee5-42b0-afbf-a342b210ca79	TALISMAN	02263	2541	49f1a6b1-610e-4aab-98e6-45dbe753fe22	d08faf9b-60a9-4081-b8ea-ca931995905b	ffd18c57-fb77-4959-9191-1a7cf0a17664	30	49.95	1302	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	CENTOMAR  S.A.	Ciudad Autónoma de Buenos Aires		011-4816-6245 / 6260  int  * 35	\N		\N	\N		t	\N	\N	\N
eced58f3-443f-4435-b706-b3e5bb40e16c	7 de Diciembre	TEMP-0001	1013	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	27.20	521	1fcba1f2-fbf3-4489-b379-286b21f99fd8		Mar del Plata	4895032		\N	operacionesconsultoramaritima@gmail.com	\N	\N	Consultora Maritima	t	\N	\N	\N
d989be58-efa0-432e-acff-e2da0c407a1c	ARGENOVA I	02180	1137	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	35.00	655	caf4d1b5-7a3c-445b-98f9-42d842f1d347	ARGENOVA  S.A.	Puerto Deseado	4808331/4808332	0297- 487-0550  (447-2818  Com. Riv )	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
0908ae91-387f-4e20-b9ba-dfa7f9ad09cc	ARGENOVA XXII	02714	2713	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	40	37.70	663	caf4d1b5-7a3c-445b-98f9-42d842f1d347	ARGENOVA  S.A.	Puerto Deseado	4808331/4808332	0297- 487-0550  (447-2818  Com. Riv )	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
1a0f8d33-c677-48ca-bf94-491becf8a784	BUENA PESCA	01475	2717	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	39.10	1479	1fcba1f2-fbf3-4489-b379-286b21f99fd8	PEDRO MOSCUZZA e HIJOS  S.A.	Mar del Plata		489-7287	\N		\N	\N		t	\N	\N	\N
1b129670-e1bc-4f2f-8234-13642269cc2f	CABO TRES PUNTAS	01483	1242	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	31.43	721	1fcba1f2-fbf3-4489-b379-286b21f99fd8	OSTRAMAR  S.A.	Mar del Plata		489-1959	\N		\N	\N		t	\N	\N	\N
5fd4a0cb-baa8-4564-8b6a-99ae7889fc84	CODEPECA  III	0506	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	\N	\N	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	HARENGUS  S.A.	Puerto Madryn		0280-445-0822	\N		\N	\N		t	\N	\N	\N
457bc788-29fa-4d6b-8c53-5b636bf873bb	CRISTO REDENTOR	01185	1374	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	31.00	642	caf4d1b5-7a3c-445b-98f9-42d842f1d347	PESQUERA DESEADO  S.A.	Puerto Deseado		0297-487-0884 / 0327 / 2407	\N		\N	\N		t	\N	\N	\N
165bcdc5-8cf1-46b9-9cac-7772d63617fa	DON ROMEO ERSINI	0972	\N	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	PESQUERA  MARGARITA  S.A.	Mar del Plata	4891553-154179360-154179860-154179062	489-4645   /   489-2946	\N	agenciasmiriglio@speedy.com.ar	\N	\N	Agencia Smiriglio	t	\N	\N	\N
b5419915-4b1e-4211-b893-83ef2be10f94	FLORIDABLANCA	0969	1606	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	27.67	541	1fcba1f2-fbf3-4489-b379-286b21f99fd8	DESAFIO  S.A.	Mar del Plata		489-4788 / 3659	\N		\N	\N		t	\N	\N	\N
87afbf66-fc82-4da0-b100-c684b3c2a26c	HOPE N°7	06130	1690	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	50.60	1235	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	ALUNAMAR  S.A.	Ciudad Autónoma de Buenos Aires	4808331/4808332	011-4382-4194	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
31c276f1-b1c1-4d4e-a759-c8f3fc0c524e	INARI MARU N° 25	0261	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	\N	\N	caf4d1b5-7a3c-445b-98f9-42d842f1d347	ARGENOVA  S.A.	Puerto Deseado		0297- 487-0550  (447-2818  Com. Riv )	\N		\N	\N		t	\N	\N	\N
3967f385-ee48-4f56-b494-57fc38f13c95	JOLUMA	5403	\N	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	ARDAPEZ  S.A.	Mar del Plata	4800005	480-1561 / 480-1568 / 480-1549	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
7e6c1aa0-8f0f-46e8-bdba-ca457b1a412b	MAR MARÍA	02960	2738	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	37.80	1248	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	PESQUERA SANTA CRUZ  S.A.	Ciudad Autónoma de Buenos Aires		011-4305-4706	\N		\N	\N		t	\N	\N	\N
870dedfd-77b2-4f0a-a0ab-238b23c8a0b6	MARGOT	0360	1976	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	58.75	1481	1fcba1f2-fbf3-4489-b379-286b21f99fd8	GIORNO  S.A.	Mar del Plata	4800005	410-0051 / 0057	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
7f9a5d2b-27ed-454f-b220-1d59dd6b3805	MYRDOMA F	02771	2735	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	38.55	1430	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	LANZAR S.A.	Puerto Madryn	4800005	0280-445-6280	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
dfb82b3d-f29c-4383-b9ad-d5b5b97fbd9c	PATAGONIA BLUES	02176	2199	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	64.45	1776	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	PESQUERA CRUZ DEL SUR  S.A.	Ciudad Autónoma de Buenos Aires		011-4784-1760	\N		\N	\N		t	\N	\N	\N
0ebd24e9-16e9-4719-91ef-9126af868667	PEVEGASA QUINTO	02312	2225	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	38.65	740	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	PUNTA BUSTAMANTE  S.A.	Ciudad Autónoma de Buenos Aires		011-4305-4710 / 4712	\N		\N	\N		t	\N	\N	\N
75d3b3de-18bc-4b24-ad47-27c52b1d6964	RYOUN MARU N° 17	JA06-03	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	\N	\N	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	BAHIA GRANDE  S.A.	Ciudad Autónoma de Buenos Aires	4891553-154179360-154179860-154179062	011-5272-0850 / 5254-1133	\N	agenciasmiriglio@speedy.com.ar	\N	\N	Agencia Maritima Smiriglio	t	\N	\N	\N
97138bee-8f63-480e-af13-49235d5049c5	SAN LUCAS  I	06147	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	\N	\N	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	AGUA MARINA  S.A.	Ciudad Autónoma de Buenos Aires		011-4342-0605 / 5656 / 1709	\N		\N	\N		t	\N	\N	\N
fa28ac74-fd00-4a3d-81a0-5fe3a44172c9	SIRIUS II	0936	2489	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	59.25	1289	1fcba1f2-fbf3-4489-b379-286b21f99fd8	EL MARISCO  S.A.	Mar del Plata	4890960	489-0384	\N	agencia@maritimavidal.com.ar	\N	\N	Agencia Maritima Vidal	t	\N	\N	\N
b98ed8e0-50c5-4592-a86b-ec730295bde3	XIN SHI DAI N° 28	02165	2669	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	62.40	1579	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	MUELLE OCHO  S.A.	Ciudad Autónoma de Buenos Aires		011-4381-1337	\N		\N	\N		t	\N	\N	\N
601565b3-1cc0-4625-9b69-1dd9be926286	XIN SHI JI Nº 91	02924	2724	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	68.58	2685	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	FENIX  INTERNATIONAL  S.A.	Ciudad Autónoma de Buenos Aires		011-4381-1337	\N		\N	\N		t	\N	\N	\N
4dbb105c-5692-489f-a72f-f0663bfbc636	CAMERIGE	01406	1252	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	27.90	652	1fcba1f2-fbf3-4489-b379-286b21f99fd8	PESQUERA  MARGARITA  S.A.	Mar del Plata	4891553-154179360-154179860-154179062	489-4645   /   489-2946	\N	agenciasmiriglio@speedy.com.ar	\N	\N	Agencia Maritima SMIRIGLIO	t	\N	\N	\N
a84b8ed5-6b9b-4aad-91dc-e51347049605	ARBUMASA XVIII	0217	1121	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	36.40	870	caf4d1b5-7a3c-445b-98f9-42d842f1d347	ARBUMASA  S.A.	Puerto Deseado	4893758	0297-487-2807 / 444-5338 / 444-1201	\N	miguel-visoso@hotmail.com	\N	\N	Agencia Maritima Solvox	t	\N	\N	\N
c5eddc80-28ca-4b56-b167-8dec45ee3846	XIN SHI JI Nº 89	02903	2750	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	68.58	2685	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	FENIX  INTERNATIONAL  S.A.	Ciudad Autónoma de Buenos Aires		011-4381-1337	\N		\N	\N		t	\N	\N	\N
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
0cf20ec7-fd90-4de0-b9ac-6fec28624b43	2026-01-05 21:27:18.165+00	ERROR	BACKEND	GlobalExceptionFilter	\N	\N	Token de refresco inválido o expirado	UnauthorizedException: Token de refresco inválido o expirado\n    at AuthService.refreshAuth (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\auth\\auth.service.ts:230:13)\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async AuthController.refreshAuth (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\auth\\auth.controller.ts:58:18)\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:46:28\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-proxy.js:9:17	{"query": {}, "params": {}, "exception": {"error": "Unauthorized", "message": "Token de refresco inválido o expirado", "statusCode": 401}}	/api/auth/refresh	GET	::1
b2f396a6-04a6-4710-9c00-abfcd5af69e0	2026-01-08 19:56:11.139+00	ERROR	BACKEND	GlobalExceptionFilter	\N	\N	No valid Refresh Token found	UnauthorizedException: No valid Refresh Token found\n    at AuthController.refreshAuth (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\auth\\auth.controller.ts:56:30)\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:38:29\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:46:28\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-proxy.js:9:17	{"query": {}, "params": {}, "exception": {"error": "Unauthorized", "message": "No valid Refresh Token found", "statusCode": 401}}	/api/auth/refresh	GET	::1
e40feb24-8779-4d77-b634-0debbb65c641	2026-01-08 22:49:05.332+00	CRITICAL	BACKEND	GlobalExceptionFilter	8951226f-00a0-4e79-8772-9c915882cd52	admin@obs.com	\nInvalid `this.prisma.alertaEvento.create()` invocation in\nD:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\alerts\\alerts.service.ts:128:41\n\n  125 }\n  126 \n  127 async logEvent(alertaId: string, tipo: string, detalle: string, userId?: string) {\n→ 128     return this.prisma.alertaEvento.create(\nInvalid input value: invalid input syntax for type uuid: "system"	PrismaClientKnownRequestError: \nInvalid `this.prisma.alertaEvento.create()` invocation in\nD:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\alerts\\alerts.service.ts:128:41\n\n  125 }\n  126 \n  127 async logEvent(alertaId: string, tipo: string, detalle: string, userId?: string) {\n→ 128     return this.prisma.alertaEvento.create(\nInvalid input value: invalid input syntax for type uuid: "system"\n    at qr.handleRequestError (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@prisma+client@7.2.0_prisma_f75d495222e5a9a082c60aa675bb2498\\node_modules\\@prisma\\client\\src\\runtime\\RequestHandler.ts:228:13)\n    at qr.handleAndLogRequestError (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@prisma+client@7.2.0_prisma_f75d495222e5a9a082c60aa675bb2498\\node_modules\\@prisma\\client\\src\\runtime\\RequestHandler.ts:174:12)\n    at qr.request (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@prisma+client@7.2.0_prisma_f75d495222e5a9a082c60aa675bb2498\\node_modules\\@prisma\\client\\src\\runtime\\RequestHandler.ts:143:12)\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async a (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@prisma+client@7.2.0_prisma_f75d495222e5a9a082c60aa675bb2498\\node_modules\\@prisma\\client\\src\\runtime\\getPrismaClient.ts:805:24)\n    at async AlertsService.update (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\alerts\\alerts.service.ts:117:13)\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:46:28\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-proxy.js:9:17	{"body": {"estado": "SEGUIMIENTO", "comment": "", "fechaVencimiento": "2026-01-15T22:49:05.257Z"}, "query": {}, "params": {"id": "769d4252-74f8-4715-95d8-d1f55583ddd6"}, "exception": {"code": "P2007", "meta": {"modelName": "AlertaEvento", "driverAdapterError": {"name": "DriverAdapterError", "cause": {"kind": "InvalidInputValue", "message": "invalid input syntax for type uuid: \\"system\\"", "originalCode": "22P02", "originalMessage": "invalid input syntax for type uuid: \\"system\\""}}}, "name": "PrismaClientKnownRequestError", "clientVersion": "7.2.0"}}	/api/alerts/769d4252-74f8-4715-95d8-d1f55583ddd6	PATCH	::1
dba36696-6ea8-4b69-9e09-3c20479d58b6	2026-01-08 22:49:27.379+00	CRITICAL	BACKEND	GlobalExceptionFilter	8951226f-00a0-4e79-8772-9c915882cd52	admin@obs.com	\nInvalid `this.prisma.alertaEvento.create()` invocation in\nD:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\alerts\\alerts.service.ts:128:41\n\n  125 }\n  126 \n  127 async logEvent(alertaId: string, tipo: string, detalle: string, userId?: string) {\n→ 128     return this.prisma.alertaEvento.create(\nInvalid input value: invalid input syntax for type uuid: "system"	PrismaClientKnownRequestError: \nInvalid `this.prisma.alertaEvento.create()` invocation in\nD:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\alerts\\alerts.service.ts:128:41\n\n  125 }\n  126 \n  127 async logEvent(alertaId: string, tipo: string, detalle: string, userId?: string) {\n→ 128     return this.prisma.alertaEvento.create(\nInvalid input value: invalid input syntax for type uuid: "system"\n    at qr.handleRequestError (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@prisma+client@7.2.0_prisma_f75d495222e5a9a082c60aa675bb2498\\node_modules\\@prisma\\client\\src\\runtime\\RequestHandler.ts:228:13)\n    at qr.handleAndLogRequestError (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@prisma+client@7.2.0_prisma_f75d495222e5a9a082c60aa675bb2498\\node_modules\\@prisma\\client\\src\\runtime\\RequestHandler.ts:174:12)\n    at qr.request (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@prisma+client@7.2.0_prisma_f75d495222e5a9a082c60aa675bb2498\\node_modules\\@prisma\\client\\src\\runtime\\RequestHandler.ts:143:12)\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async a (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@prisma+client@7.2.0_prisma_f75d495222e5a9a082c60aa675bb2498\\node_modules\\@prisma\\client\\src\\runtime\\getPrismaClient.ts:805:24)\n    at async AlertsService.update (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\alerts\\alerts.service.ts:121:13)\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:46:28\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-proxy.js:9:17	{"body": {"estado": "SEGUIMIENTO", "comment": "Preguntar si necesita descanso", "fechaVencimiento": "2026-01-15T22:49:27.282Z"}, "query": {}, "params": {"id": "769d4252-74f8-4715-95d8-d1f55583ddd6"}, "exception": {"code": "P2007", "meta": {"modelName": "AlertaEvento", "driverAdapterError": {"name": "DriverAdapterError", "cause": {"kind": "InvalidInputValue", "message": "invalid input syntax for type uuid: \\"system\\"", "originalCode": "22P02", "originalMessage": "invalid input syntax for type uuid: \\"system\\""}}}, "name": "PrismaClientKnownRequestError", "clientVersion": "7.2.0"}}	/api/alerts/769d4252-74f8-4715-95d8-d1f55583ddd6	PATCH	::1
c74b3424-bf1b-421d-aa49-495f339f1366	2026-01-08 23:37:03.708+00	ERROR	BACKEND	GlobalExceptionFilter	\N	\N	No valid Refresh Token found	UnauthorizedException: No valid Refresh Token found\n    at AuthController.refreshAuth (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\auth\\auth.controller.ts:56:30)\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:38:29\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:46:28\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-proxy.js:9:17	{"query": {}, "params": {}, "exception": {"error": "Unauthorized", "message": "No valid Refresh Token found", "statusCode": 401}}	/api/auth/refresh	GET	::1
5bc4858f-69b7-4842-baa4-b86d1d57f019	2026-01-08 22:49:54.208+00	CRITICAL	BACKEND	GlobalExceptionFilter	8951226f-00a0-4e79-8772-9c915882cd52	admin@obs.com	\nInvalid `this.prisma.alertaEvento.create()` invocation in\nD:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\alerts\\alerts.service.ts:128:41\n\n  125 }\n  126 \n  127 async logEvent(alertaId: string, tipo: string, detalle: string, userId?: string) {\n→ 128     return this.prisma.alertaEvento.create(\nInvalid input value: invalid input syntax for type uuid: "system"	PrismaClientKnownRequestError: \nInvalid `this.prisma.alertaEvento.create()` invocation in\nD:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\alerts\\alerts.service.ts:128:41\n\n  125 }\n  126 \n  127 async logEvent(alertaId: string, tipo: string, detalle: string, userId?: string) {\n→ 128     return this.prisma.alertaEvento.create(\nInvalid input value: invalid input syntax for type uuid: "system"\n    at qr.handleRequestError (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@prisma+client@7.2.0_prisma_f75d495222e5a9a082c60aa675bb2498\\node_modules\\@prisma\\client\\src\\runtime\\RequestHandler.ts:228:13)\n    at qr.handleAndLogRequestError (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@prisma+client@7.2.0_prisma_f75d495222e5a9a082c60aa675bb2498\\node_modules\\@prisma\\client\\src\\runtime\\RequestHandler.ts:174:12)\n    at qr.request (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@prisma+client@7.2.0_prisma_f75d495222e5a9a082c60aa675bb2498\\node_modules\\@prisma\\client\\src\\runtime\\RequestHandler.ts:143:12)\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async a (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@prisma+client@7.2.0_prisma_f75d495222e5a9a082c60aa675bb2498\\node_modules\\@prisma\\client\\src\\runtime\\getPrismaClient.ts:805:24)\n    at async AlertsService.update (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\alerts\\alerts.service.ts:117:13)\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:46:28\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-proxy.js:9:17	{"body": {"estado": "DESCARTADA", "comment": "Tomando nota"}, "query": {}, "params": {"id": "29a57163-567b-40ac-9434-e1c7e2c3d474"}, "exception": {"code": "P2007", "meta": {"modelName": "AlertaEvento", "driverAdapterError": {"name": "DriverAdapterError", "cause": {"kind": "InvalidInputValue", "message": "invalid input syntax for type uuid: \\"system\\"", "originalCode": "22P02", "originalMessage": "invalid input syntax for type uuid: \\"system\\""}}}, "name": "PrismaClientKnownRequestError", "clientVersion": "7.2.0"}}	/api/alerts/29a57163-567b-40ac-9434-e1c7e2c3d474	PATCH	::1
6ff28d4c-cf04-4c78-88cc-eebb52389bec	2026-01-08 22:50:06.768+00	CRITICAL	BACKEND	GlobalExceptionFilter	8951226f-00a0-4e79-8772-9c915882cd52	admin@obs.com	\nInvalid `this.prisma.alertaEvento.create()` invocation in\nD:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\alerts\\alerts.service.ts:128:41\n\n  125 }\n  126 \n  127 async logEvent(alertaId: string, tipo: string, detalle: string, userId?: string) {\n→ 128     return this.prisma.alertaEvento.create(\nInvalid input value: invalid input syntax for type uuid: "system"	PrismaClientKnownRequestError: \nInvalid `this.prisma.alertaEvento.create()` invocation in\nD:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\alerts\\alerts.service.ts:128:41\n\n  125 }\n  126 \n  127 async logEvent(alertaId: string, tipo: string, detalle: string, userId?: string) {\n→ 128     return this.prisma.alertaEvento.create(\nInvalid input value: invalid input syntax for type uuid: "system"\n    at qr.handleRequestError (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@prisma+client@7.2.0_prisma_f75d495222e5a9a082c60aa675bb2498\\node_modules\\@prisma\\client\\src\\runtime\\RequestHandler.ts:228:13)\n    at qr.handleAndLogRequestError (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@prisma+client@7.2.0_prisma_f75d495222e5a9a082c60aa675bb2498\\node_modules\\@prisma\\client\\src\\runtime\\RequestHandler.ts:174:12)\n    at qr.request (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@prisma+client@7.2.0_prisma_f75d495222e5a9a082c60aa675bb2498\\node_modules\\@prisma\\client\\src\\runtime\\RequestHandler.ts:143:12)\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async a (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@prisma+client@7.2.0_prisma_f75d495222e5a9a082c60aa675bb2498\\node_modules\\@prisma\\client\\src\\runtime\\getPrismaClient.ts:805:24)\n    at async AlertsService.update (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\alerts\\alerts.service.ts:117:13)\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:46:28\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-proxy.js:9:17	{"body": {"estado": "RESUELTA", "comment": "Ya se resolvió"}, "query": {}, "params": {"id": "29a57163-567b-40ac-9434-e1c7e2c3d474"}, "exception": {"code": "P2007", "meta": {"modelName": "AlertaEvento", "driverAdapterError": {"name": "DriverAdapterError", "cause": {"kind": "InvalidInputValue", "message": "invalid input syntax for type uuid: \\"system\\"", "originalCode": "22P02", "originalMessage": "invalid input syntax for type uuid: \\"system\\""}}}, "name": "PrismaClientKnownRequestError", "clientVersion": "7.2.0"}}	/api/alerts/29a57163-567b-40ac-9434-e1c7e2c3d474	PATCH	::1
8bbdc470-6436-4e95-ac54-983b7829cafe	2026-01-08 22:54:07.951+00	CRITICAL	BACKEND	GlobalExceptionFilter	8951226f-00a0-4e79-8772-9c915882cd52	admin@obs.com	\nInvalid `this.prisma.alertaEvento.create()` invocation in\nD:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\alerts\\alerts.service.ts:128:41\n\n  125 }\n  126 \n  127 async logEvent(alertaId: string, tipo: string, detalle: string, userId?: string) {\n→ 128     return this.prisma.alertaEvento.create(\nInvalid input value: invalid input syntax for type uuid: "system"	PrismaClientKnownRequestError: \nInvalid `this.prisma.alertaEvento.create()` invocation in\nD:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\alerts\\alerts.service.ts:128:41\n\n  125 }\n  126 \n  127 async logEvent(alertaId: string, tipo: string, detalle: string, userId?: string) {\n→ 128     return this.prisma.alertaEvento.create(\nInvalid input value: invalid input syntax for type uuid: "system"\n    at qr.handleRequestError (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@prisma+client@7.2.0_prisma_f75d495222e5a9a082c60aa675bb2498\\node_modules\\@prisma\\client\\src\\runtime\\RequestHandler.ts:228:13)\n    at qr.handleAndLogRequestError (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@prisma+client@7.2.0_prisma_f75d495222e5a9a082c60aa675bb2498\\node_modules\\@prisma\\client\\src\\runtime\\RequestHandler.ts:174:12)\n    at qr.request (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@prisma+client@7.2.0_prisma_f75d495222e5a9a082c60aa675bb2498\\node_modules\\@prisma\\client\\src\\runtime\\RequestHandler.ts:143:12)\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async a (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@prisma+client@7.2.0_prisma_f75d495222e5a9a082c60aa675bb2498\\node_modules\\@prisma\\client\\src\\runtime\\getPrismaClient.ts:805:24)\n    at async AlertsService.update (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\alerts\\alerts.service.ts:117:13)\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:46:28\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-proxy.js:9:17	{"body": {"estado": "RESUELTA", "comment": "La damos por cerrada"}, "query": {}, "params": {"id": "0eef4bad-7f93-414d-bbdf-1832f8be28ff"}, "exception": {"code": "P2007", "meta": {"modelName": "AlertaEvento", "driverAdapterError": {"name": "DriverAdapterError", "cause": {"kind": "InvalidInputValue", "message": "invalid input syntax for type uuid: \\"system\\"", "originalCode": "22P02", "originalMessage": "invalid input syntax for type uuid: \\"system\\""}}}, "name": "PrismaClientKnownRequestError", "clientVersion": "7.2.0"}}	/api/alerts/0eef4bad-7f93-414d-bbdf-1832f8be28ff	PATCH	::1
e62da886-8a92-46f5-9731-83ba054df5b9	2026-01-08 23:36:57.981+00	ERROR	BACKEND	GlobalExceptionFilter	\N	\N	No valid Refresh Token found	UnauthorizedException: No valid Refresh Token found\n    at AuthController.refreshAuth (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\auth\\auth.controller.ts:56:30)\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:38:29\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:46:28\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-proxy.js:9:17	{"query": {}, "params": {}, "exception": {"error": "Unauthorized", "message": "No valid Refresh Token found", "statusCode": 401}}	/api/auth/refresh	GET	::1
dff5fdc2-cbe0-4a56-b2dc-c35f1951ab06	2026-01-09 00:20:49.192+00	ERROR	BACKEND	GlobalExceptionFilter	\N	\N	No valid Refresh Token found	UnauthorizedException: No valid Refresh Token found\n    at AuthController.refreshAuth (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\auth\\auth.controller.ts:56:30)\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:38:29\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:46:28\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-proxy.js:9:17	{"query": {}, "params": {}, "exception": {"error": "Unauthorized", "message": "No valid Refresh Token found", "statusCode": 401}}	/api/auth/refresh	GET	::ffff:127.0.0.1
95301395-0902-40ef-b229-4e806c7c1fe6	2026-01-09 00:25:35.087+00	ERROR	BACKEND	GlobalExceptionFilter	\N	\N	No valid Refresh Token found	UnauthorizedException: No valid Refresh Token found\n    at AuthController.refreshAuth (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\auth\\auth.controller.ts:56:30)\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:38:29\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:46:28\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-proxy.js:9:17	{"query": {}, "params": {}, "exception": {"error": "Unauthorized", "message": "No valid Refresh Token found", "statusCode": 401}}	/api/auth/refresh	GET	::ffff:127.0.0.1
6a3039b9-5c89-4d33-b6ef-545e854f1f62	2026-01-09 00:27:27.217+00	ERROR	BACKEND	GlobalExceptionFilter	\N	\N	No valid Refresh Token found	UnauthorizedException: No valid Refresh Token found\n    at AuthController.refreshAuth (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\auth\\auth.controller.ts:56:30)\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:38:29\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:46:28\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-proxy.js:9:17	{"query": {}, "params": {}, "exception": {"error": "Unauthorized", "message": "No valid Refresh Token found", "statusCode": 401}}	/api/auth/refresh	GET	::1
e0f95212-f66e-4821-98ff-47ef40c45b36	2026-01-09 00:31:26.045+00	ERROR	BACKEND	GlobalExceptionFilter	\N	\N	No valid Refresh Token found	UnauthorizedException: No valid Refresh Token found\n    at AuthController.refreshAuth (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\auth\\auth.controller.ts:56:30)\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:38:29\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:46:28\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-proxy.js:9:17	{"query": {}, "params": {}, "exception": {"error": "Unauthorized", "message": "No valid Refresh Token found", "statusCode": 401}}	/api/auth/refresh	GET	::1
aa59dcd5-79cd-4c9a-9c7a-f4d0bdc9c5d9	2026-01-09 00:42:02.046+00	ERROR	BACKEND	GlobalExceptionFilter	\N	\N	No valid Refresh Token found	UnauthorizedException: No valid Refresh Token found\n    at AuthController.refreshAuth (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\auth\\auth.controller.ts:56:30)\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:38:29\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:46:28\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-proxy.js:9:17	{"query": {}, "params": {}, "exception": {"error": "Unauthorized", "message": "No valid Refresh Token found", "statusCode": 401}}	/api/auth/refresh	GET	::1
eab36291-8c36-42bb-a6c1-4fd10a3fccb2	2026-01-10 01:01:00.411+00	CRITICAL	BACKEND	GlobalExceptionFilter	8951226f-00a0-4e79-8772-9c915882cd52	admin@obs.com	\nInvalid `this.prisma.marea.findUnique()` invocation in\nD:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\mareas\\mareas.service.ts:36:47\n\n  33 }\n  34 \n  35 async findOne(id: string) {\n→ 36     const marea = await this.prisma.marea.findUnique(\nThe column `(not available)` does not exist in the current database.	PrismaClientKnownRequestError: \nInvalid `this.prisma.marea.findUnique()` invocation in\nD:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\mareas\\mareas.service.ts:36:47\n\n  33 }\n  34 \n  35 async findOne(id: string) {\n→ 36     const marea = await this.prisma.marea.findUnique(\nThe column `(not available)` does not exist in the current database.\n    at qr.handleRequestError (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@prisma+client@7.2.0_prisma_f75d495222e5a9a082c60aa675bb2498\\node_modules\\@prisma\\client\\src\\runtime\\RequestHandler.ts:228:13)\n    at qr.handleAndLogRequestError (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@prisma+client@7.2.0_prisma_f75d495222e5a9a082c60aa675bb2498\\node_modules\\@prisma\\client\\src\\runtime\\RequestHandler.ts:174:12)\n    at qr.request (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@prisma+client@7.2.0_prisma_f75d495222e5a9a082c60aa675bb2498\\node_modules\\@prisma\\client\\src\\runtime\\RequestHandler.ts:143:12)\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async a (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@prisma+client@7.2.0_prisma_f75d495222e5a9a082c60aa675bb2498\\node_modules\\@prisma\\client\\src\\runtime\\getPrismaClient.ts:805:24)\n    at async MareasService.findOne (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\mareas\\mareas.service.ts:36:23)\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:46:28\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-proxy.js:9:17	{"query": {}, "params": {"id": "bb26bbcb-ee6d-4370-9c16-84f03d8d362b"}, "exception": {"code": "P2022", "meta": {"modelName": "Marea", "driverAdapterError": {"name": "DriverAdapterError", "cause": {"kind": "ColumnNotFound", "originalCode": "42703", "originalMessage": "column mareas.titulo does not exist"}}}, "name": "PrismaClientKnownRequestError", "clientVersion": "7.2.0"}}	/api/mareas/bb26bbcb-ee6d-4370-9c16-84f03d8d362b	GET	::1
733c9f9b-9ef4-44ad-812d-ba996324777b	2026-01-10 01:01:34.214+00	CRITICAL	BACKEND	GlobalExceptionFilter	8951226f-00a0-4e79-8772-9c915882cd52	admin@obs.com	\nInvalid `this.prisma.marea.findUnique()` invocation in\nD:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\mareas\\mareas.service.ts:1063:31\n\n  1060 \n  1061 async getMareaContext(id: string) {\n  1062     const [marea, transiciones] = (await Promise.all([\n→ 1063         this.prisma.marea.findUnique(\nThe column `(not available)` does not exist in the current database.	PrismaClientKnownRequestError: \nInvalid `this.prisma.marea.findUnique()` invocation in\nD:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\mareas\\mareas.service.ts:1063:31\n\n  1060 \n  1061 async getMareaContext(id: string) {\n  1062     const [marea, transiciones] = (await Promise.all([\n→ 1063         this.prisma.marea.findUnique(\nThe column `(not available)` does not exist in the current database.\n    at qr.handleRequestError (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@prisma+client@7.2.0_prisma_f75d495222e5a9a082c60aa675bb2498\\node_modules\\@prisma\\client\\src\\runtime\\RequestHandler.ts:228:13)\n    at qr.handleAndLogRequestError (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@prisma+client@7.2.0_prisma_f75d495222e5a9a082c60aa675bb2498\\node_modules\\@prisma\\client\\src\\runtime\\RequestHandler.ts:174:12)\n    at qr.request (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@prisma+client@7.2.0_prisma_f75d495222e5a9a082c60aa675bb2498\\node_modules\\@prisma\\client\\src\\runtime\\RequestHandler.ts:143:12)\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async a (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@prisma+client@7.2.0_prisma_f75d495222e5a9a082c60aa675bb2498\\node_modules\\@prisma\\client\\src\\runtime\\getPrismaClient.ts:805:24)\n    at async Promise.all (index 0)\n    at async MareasService.getMareaContext (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\mareas\\mareas.service.ts:1062:40)\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:46:28\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-proxy.js:9:17	{"query": {}, "params": {"id": "7bed6c63-432e-4372-94ed-08c541cebdcb"}, "exception": {"code": "P2022", "meta": {"modelName": "Marea", "driverAdapterError": {"name": "DriverAdapterError", "cause": {"kind": "ColumnNotFound", "originalCode": "42703", "originalMessage": "column mareas.titulo does not exist"}}}, "name": "PrismaClientKnownRequestError", "clientVersion": "7.2.0"}}	/api/mareas/7bed6c63-432e-4372-94ed-08c541cebdcb/context	GET	::1
1194879c-d8a2-4580-9c2e-573d41fd5fb6	2026-01-10 01:01:45.042+00	CRITICAL	BACKEND	GlobalExceptionFilter	8951226f-00a0-4e79-8772-9c915882cd52	admin@obs.com	\nInvalid `this.prisma.marea.findUnique()` invocation in\nD:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\mareas\\mareas.service.ts:1063:31\n\n  1060 \n  1061 async getMareaContext(id: string) {\n  1062     const [marea, transiciones] = (await Promise.all([\n→ 1063         this.prisma.marea.findUnique(\nThe column `(not available)` does not exist in the current database.	PrismaClientKnownRequestError: \nInvalid `this.prisma.marea.findUnique()` invocation in\nD:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\mareas\\mareas.service.ts:1063:31\n\n  1060 \n  1061 async getMareaContext(id: string) {\n  1062     const [marea, transiciones] = (await Promise.all([\n→ 1063         this.prisma.marea.findUnique(\nThe column `(not available)` does not exist in the current database.\n    at qr.handleRequestError (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@prisma+client@7.2.0_prisma_f75d495222e5a9a082c60aa675bb2498\\node_modules\\@prisma\\client\\src\\runtime\\RequestHandler.ts:228:13)\n    at qr.handleAndLogRequestError (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@prisma+client@7.2.0_prisma_f75d495222e5a9a082c60aa675bb2498\\node_modules\\@prisma\\client\\src\\runtime\\RequestHandler.ts:174:12)\n    at qr.request (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@prisma+client@7.2.0_prisma_f75d495222e5a9a082c60aa675bb2498\\node_modules\\@prisma\\client\\src\\runtime\\RequestHandler.ts:143:12)\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async a (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@prisma+client@7.2.0_prisma_f75d495222e5a9a082c60aa675bb2498\\node_modules\\@prisma\\client\\src\\runtime\\getPrismaClient.ts:805:24)\n    at async Promise.all (index 0)\n    at async MareasService.getMareaContext (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\mareas\\mareas.service.ts:1062:40)\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:46:28\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-proxy.js:9:17	{"query": {}, "params": {"id": "443ec94f-0465-46b4-a4ec-4d9a1c012736"}, "exception": {"code": "P2022", "meta": {"modelName": "Marea", "driverAdapterError": {"name": "DriverAdapterError", "cause": {"kind": "ColumnNotFound", "originalCode": "42703", "originalMessage": "column mareas.titulo does not exist"}}}, "name": "PrismaClientKnownRequestError", "clientVersion": "7.2.0"}}	/api/mareas/443ec94f-0465-46b4-a4ec-4d9a1c012736/context	GET	::1
65266c42-419e-4f3a-8891-5694c2e87eed	2026-01-10 01:06:31.785+00	CRITICAL	BACKEND	GlobalExceptionFilter	8951226f-00a0-4e79-8772-9c915882cd52	admin@obs.com	\nInvalid `this.prisma.marea.findUnique()` invocation in\nD:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\mareas\\mareas.service.ts:1063:31\n\n  1060 \n  1061 async getMareaContext(id: string) {\n  1062     const [marea, transiciones] = (await Promise.all([\n→ 1063         this.prisma.marea.findUnique(\nThe column `(not available)` does not exist in the current database.	PrismaClientKnownRequestError: \nInvalid `this.prisma.marea.findUnique()` invocation in\nD:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\mareas\\mareas.service.ts:1063:31\n\n  1060 \n  1061 async getMareaContext(id: string) {\n  1062     const [marea, transiciones] = (await Promise.all([\n→ 1063         this.prisma.marea.findUnique(\nThe column `(not available)` does not exist in the current database.\n    at qr.handleRequestError (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@prisma+client@7.2.0_prisma_f75d495222e5a9a082c60aa675bb2498\\node_modules\\@prisma\\client\\src\\runtime\\RequestHandler.ts:228:13)\n    at qr.handleAndLogRequestError (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@prisma+client@7.2.0_prisma_f75d495222e5a9a082c60aa675bb2498\\node_modules\\@prisma\\client\\src\\runtime\\RequestHandler.ts:174:12)\n    at qr.request (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@prisma+client@7.2.0_prisma_f75d495222e5a9a082c60aa675bb2498\\node_modules\\@prisma\\client\\src\\runtime\\RequestHandler.ts:143:12)\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async a (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@prisma+client@7.2.0_prisma_f75d495222e5a9a082c60aa675bb2498\\node_modules\\@prisma\\client\\src\\runtime\\getPrismaClient.ts:805:24)\n    at async Promise.all (index 0)\n    at async MareasService.getMareaContext (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\mareas\\mareas.service.ts:1062:40)\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:46:28\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-proxy.js:9:17	{"query": {}, "params": {"id": "bb26bbcb-ee6d-4370-9c16-84f03d8d362b"}, "exception": {"code": "P2022", "meta": {"modelName": "Marea", "driverAdapterError": {"name": "DriverAdapterError", "cause": {"kind": "ColumnNotFound", "originalCode": "42703", "originalMessage": "column mareas.titulo does not exist"}}}, "name": "PrismaClientKnownRequestError", "clientVersion": "7.2.0"}}	/api/mareas/bb26bbcb-ee6d-4370-9c16-84f03d8d362b/context	GET	::1
145fdeef-3632-450e-980b-7ceb42c5ce9a	2026-01-10 22:00:39.142+00	ERROR	BACKEND	GlobalExceptionFilter	\N	\N	Credenciales inválidas	UnauthorizedException: Credenciales inválidas\n    at AuthService.login (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\auth\\auth.service.ts:59:13)\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async AuthController.loginUser (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\auth\\auth.controller.ts:41:18)\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:46:28\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-proxy.js:9:17	{"body": {"email": "danieldt2000@hotmail.com", "password": "Internet&212", "remember": false}, "query": {}, "params": {}, "exception": {"error": "Unauthorized", "message": "Credenciales inválidas", "statusCode": 401}}	/api/auth/login	POST	::1
4be6b92e-fccf-4691-8cdc-1549732da307	2026-01-10 22:00:44.394+00	ERROR	BACKEND	GlobalExceptionFilter	\N	\N	Credenciales inválidas	UnauthorizedException: Credenciales inválidas\n    at AuthService.login (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\auth\\auth.service.ts:59:13)\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async AuthController.loginUser (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\auth\\auth.controller.ts:41:18)\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:46:28\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-proxy.js:9:17	{"body": {"email": "danieldt2000@hotmail.com", "password": "Internet&212", "remember": false}, "query": {}, "params": {}, "exception": {"error": "Unauthorized", "message": "Credenciales inválidas", "statusCode": 401}}	/api/auth/login	POST	::1
1a93fd31-6dff-420a-9757-6f1c5e2d47b0	2026-01-10 22:00:57.633+00	ERROR	BACKEND	GlobalExceptionFilter	\N	\N	Credenciales inválidas	UnauthorizedException: Credenciales inválidas\n    at AuthService.login (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\auth\\auth.service.ts:59:13)\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async AuthController.loginUser (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\auth\\auth.controller.ts:41:18)\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:46:28\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-proxy.js:9:17	{"body": {"email": "danieldt2000@hotmail.com", "password": "Obs1234", "remember": false}, "query": {}, "params": {}, "exception": {"error": "Unauthorized", "message": "Credenciales inválidas", "statusCode": 401}}	/api/auth/login	POST	::1
ebc3a8b6-2200-4418-acdb-ecc3049b876d	2026-01-11 21:06:11.193+00	CRITICAL	BACKEND	GlobalExceptionFilter	8951226f-00a0-4e79-8772-9c915882cd52	admin@obs.com	Backup creation failed	InternalServerErrorException: Backup creation failed\n    at BackupService.createBackup (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\admin\\backup\\backup.service.ts:57:19)\n    at BackupController.createBackup (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\admin\\backup\\backup.controller.ts:13:35)\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:38:29\n    at InterceptorsConsumer.intercept (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\interceptors\\interceptors-consumer.js:12:20)\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:46:60\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-proxy.js:9:17	{"query": {}, "params": {}, "exception": {"error": "Internal Server Error", "message": "Backup creation failed", "statusCode": 500}}	/api/admin/backup	POST	::1
babd7811-0fcd-41d8-a2b5-f30164a0c33f	2026-01-11 21:10:00.854+00	CRITICAL	BACKEND	GlobalExceptionFilter	8951226f-00a0-4e79-8772-9c915882cd52	admin@obs.com	La generación del backup falló. Asegúrate de tener instalado "pg_dump" en el sistema.	InternalServerErrorException: La generación del backup falló. Asegúrate de tener instalado "pg_dump" en el sistema.\n    at BackupService.createBackup (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\admin\\backup\\backup.service.ts:69:19)\n    at BackupController.createBackup (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\admin\\backup\\backup.controller.ts:13:35)\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:38:29\n    at InterceptorsConsumer.intercept (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\interceptors\\interceptors-consumer.js:12:20)\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:46:60\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-proxy.js:9:17	{"query": {}, "params": {}, "exception": {"error": "Internal Server Error", "message": "La generación del backup falló. Asegúrate de tener instalado \\"pg_dump\\" en el sistema.", "statusCode": 500}}	/api/admin/backup	POST	::1
516b7da8-9888-4d8a-a301-547c317cccb1	2026-01-11 21:33:32.095+00	CRITICAL	BACKEND	GlobalExceptionFilter	8951226f-00a0-4e79-8772-9c915882cd52	admin@obs.com	\nInvalid `this.prisma.marea.create()` invocation in\nD:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\admin\\data-export\\data-export.service.ts:760:37\n\n  757 // If we needed to update existing deep structure, it would be much more complex.\n  758 // The existing strategy is: SKIP existing Mareas (duplicates).\n  759 \n→ 760 await this.prisma.marea.create({\n        data: {\n          anioMarea: 2025,\n          nroMarea: 183,\n          tipoMarea: "MC",\n          fechaZarpadaEstimada: new Date("2025-11-20T03:00:00.000Z"),\n          fechaInicioObservador: null,\n          fechaFinObservador: new Date("2025-01-18T20:01:00.000Z"),\n          diasEstimados: 30,\n          diasZonaAustral: null,\n          tipoCalculoZonaAustral: "AUTOMATICO",\n          titulo: undefined,\n          descripcion: undefined,\n          nroProtocolizacion: null,\n          anioProtocolizacion: null,\n          fechaProtocolizacion: null,\n          comentarios: undefined,\n          observaciones: "Importada de JSONL. Empresa: CRUSTACEOS DEL SUR S.A. Especie: CENTOLLA",\n          activo: true,\n          buque: {\n            connect: {\n              id: "e113b2d7-af93-44fe-a26e-805429efdd48"\n            }\n          },\n          estadoActual: {\n            connect: {\n              id: "6aa3e1af-c033-4aab-a945-e1d1736f9348"\n            }\n          },\n          artePrincipal: {\n            connect: {\n              id: "d08faf9b-60a9-4081-b8ea-ca931995905b"\n            }\n          },\n          etapas: {\n            create: [\n              {\n                fechaInicio: undefined,\n                fechaFin: undefined,\n                puertoZarpada: {\n                  connect: {\n                    id: "caf4d1b5-7a3c-445b-98f9-42d842f1d347"\n                  }\n                },\n                puertoArribo: {\n                  connect: {\n                    id: "86f70064-a55b-4d55-b7e9-dc3f320c4cc1"\n                  }\n                },\n                pesqueria: {\n                  connect: {\n                    id: "ffd18c57-fb77-4959-9191-1a7cf0a17664"\n                  }\n                },\n                lances: {\n                  create: []\n                },\n                observadores: {\n                  create: [\n                    {\n                      rol: "PRINCIPAL",\n                      fechaInicio: undefined,\n                      fechaFin: undefined,\n                      observador: {\n                        connect: {\n                          id: "99f20cc1-6646-47a5-a8ab-db8e1d1b5a4c"\n                        }\n                      }\n                    }\n                  ]\n                }\n              }\n            ]\n          },\n          movimientos: {\n            create: [\n              {\n                fecha: new Date("Invalid Date"),\n                       ~~~~~~~~~~~~~~~~~~~~~~~~\n                usuario: {\n                  connect: {\n                    id: "8951226f-00a0-4e79-8772-9c915882cd52"\n                  }\n                },\n                estadoDesde: {\n                  connect: {\n                    id: "69b9484e-11e9-459f-9f5a-dcdbeba2111b"\n                  }\n                },\n                estadoHasta: {\n                  connect: {\n                    id: "6aa3e1af-c033-4aab-a945-e1d1736f9348"\n                  }\n                },\n                comentario: undefined\n              },\n              {\n                fecha: new Date("Invalid Date"),\n                usuario: {\n                  connect: {\n                    id: "8951226f-00a0-4e79-8772-9c915882cd52"\n                  }\n                },\n                estadoDesde: undefined,\n                estadoHasta: undefined,\n                comentario: undefined\n              },\n              {\n                fecha: new Date("Invalid Date"),\n                usuario: {\n                  connect: {\n                    id: "8951226f-00a0-4e79-8772-9c915882cd52"\n                  }\n                },\n                estadoDesde: undefined,\n                estadoHasta: {\n                  connect: {\n                    id: "69b9484e-11e9-459f-9f5a-dcdbeba2111b"\n                  }\n                },\n                comentario: undefined\n              }\n            ]\n          },\n          archivos: {\n            create: []\n          }\n        }\n      })\n\nInvalid value for argument `fecha`: Provided Date object is invalid. Expected Date.	PrismaClientValidationError: \nInvalid `this.prisma.marea.create()` invocation in\nD:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\admin\\data-export\\data-export.service.ts:760:37\n\n  757 // If we needed to update existing deep structure, it would be much more complex.\n  758 // The existing strategy is: SKIP existing Mareas (duplicates).\n  759 \n→ 760 await this.prisma.marea.create({\n        data: {\n          anioMarea: 2025,\n          nroMarea: 183,\n          tipoMarea: "MC",\n          fechaZarpadaEstimada: new Date("2025-11-20T03:00:00.000Z"),\n          fechaInicioObservador: null,\n          fechaFinObservador: new Date("2025-01-18T20:01:00.000Z"),\n          diasEstimados: 30,\n          diasZonaAustral: null,\n          tipoCalculoZonaAustral: "AUTOMATICO",\n          titulo: undefined,\n          descripcion: undefined,\n          nroProtocolizacion: null,\n          anioProtocolizacion: null,\n          fechaProtocolizacion: null,\n          comentarios: undefined,\n          observaciones: "Importada de JSONL. Empresa: CRUSTACEOS DEL SUR S.A. Especie: CENTOLLA",\n          activo: true,\n          buque: {\n            connect: {\n              id: "e113b2d7-af93-44fe-a26e-805429efdd48"\n            }\n          },\n          estadoActual: {\n            connect: {\n              id: "6aa3e1af-c033-4aab-a945-e1d1736f9348"\n            }\n          },\n          artePrincipal: {\n            connect: {\n              id: "d08faf9b-60a9-4081-b8ea-ca931995905b"\n            }\n          },\n          etapas: {\n            create: [\n              {\n                fechaInicio: undefined,\n                fechaFin: undefined,\n                puertoZarpada: {\n                  connect: {\n                    id: "caf4d1b5-7a3c-445b-98f9-42d842f1d347"\n                  }\n                },\n                puertoArribo: {\n                  connect: {\n                    id: "86f70064-a55b-4d55-b7e9-dc3f320c4cc1"\n                  }\n                },\n                pesqueria: {\n                  connect: {\n                    id: "ffd18c57-fb77-4959-9191-1a7cf0a17664"\n                  }\n                },\n                lances: {\n                  create: []\n                },\n                observadores: {\n                  create: [\n                    {\n                      rol: "PRINCIPAL",\n                      fechaInicio: undefined,\n                      fechaFin: undefined,\n                      observador: {\n                        connect: {\n                          id: "99f20cc1-6646-47a5-a8ab-db8e1d1b5a4c"\n                        }\n                      }\n                    }\n                  ]\n                }\n              }\n            ]\n          },\n          movimientos: {\n            create: [\n              {\n                fecha: new Date("Invalid Date"),\n                       ~~~~~~~~~~~~~~~~~~~~~~~~\n                usuario: {\n                  connect: {\n                    id: "8951226f-00a0-4e79-8772-9c915882cd52"\n                  }\n                },\n                estadoDesde: {\n                  connect: {\n                    id: "69b9484e-11e9-459f-9f5a-dcdbeba2111b"\n                  }\n                },\n                estadoHasta: {\n                  connect: {\n                    id: "6aa3e1af-c033-4aab-a945-e1d1736f9348"\n                  }\n                },\n                comentario: undefined\n              },\n              {\n                fecha: new Date("Invalid Date"),\n                usuario: {\n                  connect: {\n                    id: "8951226f-00a0-4e79-8772-9c915882cd52"\n                  }\n                },\n                estadoDesde: undefined,\n                estadoHasta: undefined,\n                comentario: undefined\n              },\n              {\n                fecha: new Date("Invalid Date"),\n                usuario: {\n                  connect: {\n                    id: "8951226f-00a0-4e79-8772-9c915882cd52"\n                  }\n                },\n                estadoDesde: undefined,\n                estadoHasta: {\n                  connect: {\n                    id: "69b9484e-11e9-459f-9f5a-dcdbeba2111b"\n                  }\n                },\n                comentario: undefined\n              }\n            ]\n          },\n          archivos: {\n            create: []\n          }\n        }\n      })\n\nInvalid value for argument `fecha`: Provided Date object is invalid. Expected Date.\n    at throwValidationException (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@prisma+client@7.2.0_prisma_f75d495222e5a9a082c60aa675bb2498\\node_modules\\@prisma\\client\\src\\runtime\\core\\errorRendering\\throwValidationException.ts:46:9)\n    at e.throwValidationError (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@prisma+client@7.2.0_prisma_f75d495222e5a9a082c60aa675bb2498\\node_modules\\@prisma\\client\\src\\runtime\\core\\jsonProtocol\\serializeJsonQuery.ts:450:5)\n    at serializeArgumentsValue (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@prisma+client@7.2.0_prisma_f75d495222e5a9a082c60aa675bb2498\\node_modules\\@prisma\\client\\src\\runtime\\core\\jsonProtocol\\serializeJsonQuery.ts:285:15)\n    at serializeArgumentsObject (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@prisma+client@7.2.0_prisma_f75d495222e5a9a082c60aa675bb2498\\node_modules\\@prisma\\client\\src\\runtime\\core\\jsonProtocol\\serializeJsonQuery.ts:367:21)\n    at serializeArgumentsValue (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@prisma+client@7.2.0_prisma_f75d495222e5a9a082c60aa675bb2498\\node_modules\\@prisma\\client\\src\\runtime\\core\\jsonProtocol\\serializeJsonQuery.ts:335:12)\n    at serializeArgumentsArray (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@prisma+client@7.2.0_prisma_f75d495222e5a9a082c60aa675bb2498\\node_modules\\@prisma\\client\\src\\runtime\\core\\jsonProtocol\\serializeJsonQuery.ts:399:17)\n    at serializeArgumentsValue (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@prisma+client@7.2.0_prisma_f75d495222e5a9a082c60aa675bb2498\\node_modules\\@prisma\\client\\src\\runtime\\core\\jsonProtocol\\serializeJsonQuery.ts:307:12)\n    at serializeArgumentsObject (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@prisma+client@7.2.0_prisma_f75d495222e5a9a082c60aa675bb2498\\node_modules\\@prisma\\client\\src\\runtime\\core\\jsonProtocol\\serializeJsonQuery.ts:367:21)\n    at serializeArgumentsValue (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@prisma+client@7.2.0_prisma_f75d495222e5a9a082c60aa675bb2498\\node_modules\\@prisma\\client\\src\\runtime\\core\\jsonProtocol\\serializeJsonQuery.ts:335:12)\n    at fo (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@prisma+client@7.2.0_prisma_f75d495222e5a9a082c60aa675bb2498\\node_modules\\@prisma\\client\\src\\runtime\\core\\jsonProtocol\\serializeJsonQuery.ts:367:21)	{"body": {}, "query": {}, "params": {}, "exception": {"name": "PrismaClientValidationError", "clientVersion": "7.2.0"}}	/api/admin/data-export/import	POST	::1
b1a5449d-8324-4003-91e4-fdf9e01eba90	2026-01-12 01:48:39.858+00	ERROR	BACKEND	GlobalExceptionFilter	8951226f-00a0-4e79-8772-9c915882cd52	admin@obs.com	Unauthorized	UnauthorizedException: Unauthorized\n    at MixinAuthGuard.handleRequest (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+passport@11.0.5_@ne_3e2e1635e1fc880657f155ecf43895f0\\node_modules\\@nestjs\\passport\\dist\\auth.guard.js:60:30)\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+passport@11.0.5_@ne_3e2e1635e1fc880657f155ecf43895f0\\node_modules\\@nestjs\\passport\\dist\\auth.guard.js:44:124\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+passport@11.0.5_@ne_3e2e1635e1fc880657f155ecf43895f0\\node_modules\\@nestjs\\passport\\dist\\auth.guard.js:83:24\n    at allFailed (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\passport@0.7.0\\node_modules\\passport\\lib\\middleware\\authenticate.js:110:18)\n    at attempt (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\passport@0.7.0\\node_modules\\passport\\lib\\middleware\\authenticate.js:183:28)\n    at strategy.fail (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\passport@0.7.0\\node_modules\\passport\\lib\\middleware\\authenticate.js:314:9)\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\passport-jwt@4.0.1\\node_modules\\passport-jwt\\lib\\strategy.js:106:33\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\jsonwebtoken@9.0.3\\node_modules\\jsonwebtoken\\verify.js:190:16\n    at getSecret (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\jsonwebtoken@9.0.3\\node_modules\\jsonwebtoken\\verify.js:97:14)\n    at module.exports [as verify] (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\jsonwebtoken@9.0.3\\node_modules\\jsonwebtoken\\verify.js:101:10)	{"query": {}, "params": {}, "exception": {"message": "Unauthorized", "statusCode": 401}}	/api/catalogos/observadores	GET	::1
9b0d3de9-99a6-481d-880f-990a5bc53854	2026-01-12 02:09:45.753+00	ERROR	BACKEND	GlobalExceptionFilter	8951226f-00a0-4e79-8772-9c915882cd52	admin@obs.com	Bad Request Exception	BadRequestException: Bad Request Exception\n    at ValidationPipe.exceptionFactory (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+common@11.1.10_clas_ef3082dcd13cc376fcae0bf4ef553349\\node_modules\\@nestjs\\common\\pipes\\validation.pipe.js:107:20)\n    at ValidationPipe.transform (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+common@11.1.10_clas_ef3082dcd13cc376fcae0bf4ef553349\\node_modules\\@nestjs\\common\\pipes\\validation.pipe.js:74:30)\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async resolveParamValue (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:148:23)\n    at async Promise.all (index 0)\n    at async pipesFn (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:151:13)\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:37:30\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:46:28\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-proxy.js:9:17	{"body": {"email": "ddi@inidep.edu.ar", "activo": true, "nombre": "Daniel Alejandro", "fotoUrl": null, "apellido": "Di Tullio", "disponible": true, "tipoContrato": "LEY MARCO", "codigoInterno": 9465, "observaciones": "", "conImpedimento": false, "tipoObservador": "OBSERVADOR", "motivoImpedimento": "", "fechaProximaDisponibilidad": ""}, "query": {}, "params": {"id": "1197662f-ec99-4fcf-a002-e0c80670302b"}, "exception": {"error": "Bad Request", "message": ["property fechaProximaDisponibilidad should not exist"], "statusCode": 400}}	/api/catalogos/observadores/1197662f-ec99-4fcf-a002-e0c80670302b	PATCH	::1
5b46ac41-aea9-4717-af92-7b197c532bbf	2026-01-12 02:12:05.183+00	ERROR	BACKEND	GlobalExceptionFilter	8951226f-00a0-4e79-8772-9c915882cd52	admin@obs.com	Bad Request Exception	BadRequestException: Bad Request Exception\n    at ValidationPipe.exceptionFactory (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+common@11.1.10_clas_ef3082dcd13cc376fcae0bf4ef553349\\node_modules\\@nestjs\\common\\pipes\\validation.pipe.js:107:20)\n    at ValidationPipe.transform (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+common@11.1.10_clas_ef3082dcd13cc376fcae0bf4ef553349\\node_modules\\@nestjs\\common\\pipes\\validation.pipe.js:74:30)\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async resolveParamValue (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:148:23)\n    at async Promise.all (index 0)\n    at async pipesFn (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:151:13)\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:37:30\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:46:28\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-proxy.js:9:17	{"body": {"email": "ddi@inidep.edu.ar", "activo": true, "nombre": "Daniel Alejandro", "fotoUrl": null, "apellido": "Di Tullio", "disponible": true, "tipoContrato": "LEY MARCO", "codigoInterno": 9465, "observaciones": "", "conImpedimento": false, "tipoObservador": "OBSERVADOR", "motivoImpedimento": "", "fechaProximaDisponibilidad": ""}, "query": {}, "params": {"id": "1197662f-ec99-4fcf-a002-e0c80670302b"}, "exception": {"error": "Bad Request", "message": ["La fecha de próxima disponibilidad debe ser una fecha válida"], "statusCode": 400}}	/api/catalogos/observadores/1197662f-ec99-4fcf-a002-e0c80670302b	PATCH	::1
a78a4682-6a3a-471f-bff2-62a884f27a20	2026-01-12 19:26:36.552+00	ERROR	BACKEND	GlobalExceptionFilter	8951226f-00a0-4e79-8772-9c915882cd52	admin@obs.com	Unauthorized	UnauthorizedException: Unauthorized\n    at MixinAuthGuard.handleRequest (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+passport@11.0.5_@ne_3e2e1635e1fc880657f155ecf43895f0\\node_modules\\@nestjs\\passport\\dist\\auth.guard.js:60:30)\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+passport@11.0.5_@ne_3e2e1635e1fc880657f155ecf43895f0\\node_modules\\@nestjs\\passport\\dist\\auth.guard.js:44:124\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+passport@11.0.5_@ne_3e2e1635e1fc880657f155ecf43895f0\\node_modules\\@nestjs\\passport\\dist\\auth.guard.js:83:24\n    at allFailed (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\passport@0.7.0\\node_modules\\passport\\lib\\middleware\\authenticate.js:110:18)\n    at attempt (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\passport@0.7.0\\node_modules\\passport\\lib\\middleware\\authenticate.js:183:28)\n    at strategy.fail (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\passport@0.7.0\\node_modules\\passport\\lib\\middleware\\authenticate.js:314:9)\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\passport-jwt@4.0.1\\node_modules\\passport-jwt\\lib\\strategy.js:106:33\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\jsonwebtoken@9.0.3\\node_modules\\jsonwebtoken\\verify.js:190:16\n    at getSecret (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\jsonwebtoken@9.0.3\\node_modules\\jsonwebtoken\\verify.js:97:14)\n    at module.exports [as verify] (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\jsonwebtoken@9.0.3\\node_modules\\jsonwebtoken\\verify.js:101:10)	{"body": {"activo": true, "esloraM": 65.1, "fechaAlta": null, "fechaBaja": null, "matricula": "02196", "empresaFax": "011-4964-2227", "potenciaHp": 1603, "nombreBuque": "MINTA", "tipoFlotaId": "49f1a6b1-610e-4aab-98e6-45dbe753fe22", "puertoBaseId": "1fcba1f2-fbf3-4489-b379-286b21f99fd8", "armadorNombre": null, "codigoInterno": 2050, "empresaNombre": "LIYA  S.A.", "observaciones": null, "arteHabitualId": "7779dd38-9a6a-4ef8-b589-6eaf89b03dbe", "armadorTelefono": null, "empresaTelefono": "", "empresaLocalidad": "Ciudad Autónoma de Buenos Aires", "diasMareaEstimada": 40, "pesqueriaHabitualId": "551b3773-09f9-4eb6-a9ce-88abf50b63a1", "agenciaMaritimaNombre": "", "empresaCorreoPrincipal": null, "empresaCorreoSecundario": ""}, "query": {}, "params": {"id": "fc67a193-73d3-42e6-9aa7-7811e559cbfb"}, "exception": {"message": "Unauthorized", "statusCode": 401}}	/api/catalogos/buques/fc67a193-73d3-42e6-9aa7-7811e559cbfb	PATCH	::1
a01f3358-308b-49c6-a74f-0b2b7d25f02a	2026-01-12 20:04:50.724+00	CRITICAL	BACKEND	GlobalExceptionFilter	8951226f-00a0-4e79-8772-9c915882cd52	admin@obs.com	\nInvalid `tx.mareaEtapa.create()` invocation in\nD:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\mareas\\mareas.service.ts:1289:54\n\n  1286         data: stageData\n  1287     });\n  1288 } else {\n→ 1289     const newStage = await tx.mareaEtapa.create(\nInvalid input value: invalid input syntax for type uuid: ""	PrismaClientKnownRequestError: \nInvalid `tx.mareaEtapa.create()` invocation in\nD:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\mareas\\mareas.service.ts:1289:54\n\n  1286         data: stageData\n  1287     });\n  1288 } else {\n→ 1289     const newStage = await tx.mareaEtapa.create(\nInvalid input value: invalid input syntax for type uuid: ""\n    at qr.handleRequestError (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@prisma+client@7.2.0_prisma_f75d495222e5a9a082c60aa675bb2498\\node_modules\\@prisma\\client\\src\\runtime\\RequestHandler.ts:228:13)\n    at qr.handleAndLogRequestError (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@prisma+client@7.2.0_prisma_f75d495222e5a9a082c60aa675bb2498\\node_modules\\@prisma\\client\\src\\runtime\\RequestHandler.ts:174:12)\n    at qr.request (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@prisma+client@7.2.0_prisma_f75d495222e5a9a082c60aa675bb2498\\node_modules\\@prisma\\client\\src\\runtime\\RequestHandler.ts:143:12)\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async a (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@prisma+client@7.2.0_prisma_f75d495222e5a9a082c60aa675bb2498\\node_modules\\@prisma\\client\\src\\runtime\\getPrismaClient.ts:805:24)\n    at async MareasService.syncStages (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\mareas\\mareas.service.ts:1289:34)\n    at async <anonymous> (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\mareas\\mareas.service.ts:1384:21)\n    at async Proxy._transactionWithCallback (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@prisma+client@7.2.0_prisma_f75d495222e5a9a082c60aa675bb2498\\node_modules\\@prisma\\client\\src\\runtime\\getPrismaClient.ts:694:18)\n    at async MareasService.executeAction (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\mareas\\mareas.service.ts:1374:16)\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:46:28	{"body": {"etapas": [{"id": "fa09d39c-88b9-4dcc-b077-8d5518063add", "nroEtapa": 1, "tipoEtapa": "COMERCIAL", "fechaArribo": "2026-01-04T03:00:00.000Z", "pesqueriaId": "551b3773-09f9-4eb6-a9ce-88abf50b63a1", "fechaZarpada": "2025-12-29T03:00:00.000Z", "puertoArriboId": "1fcba1f2-fbf3-4489-b379-286b21f99fd8", "puertoZarpadaId": "1fcba1f2-fbf3-4489-b379-286b21f99fd8"}, {"id": null, "nroEtapa": 2, "tipoEtapa": "COMERCIAL", "fechaArribo": "", "pesqueriaId": "551b3773-09f9-4eb6-a9ce-88abf50b63a1", "fechaZarpada": "2026-01-06T03:00:00.000Z", "observaciones": "", "puertoArriboId": "", "puertoZarpadaId": "1fcba1f2-fbf3-4489-b379-286b21f99fd8"}], "fechaFinObservador": "", "fechaInicioObservador": "2025-12-29T03:00:00.000Z"}, "query": {}, "params": {"id": "ded76b97-9174-4da7-a7be-94e29ec59af5", "actionKey": "REGISTRAR_INICIO"}, "exception": {"code": "P2007", "meta": {"modelName": "MareaEtapa", "driverAdapterError": {"name": "DriverAdapterError", "cause": {"kind": "InvalidInputValue", "message": "invalid input syntax for type uuid: \\"\\"", "originalCode": "22P02", "originalMessage": "invalid input syntax for type uuid: \\"\\""}}}, "name": "PrismaClientKnownRequestError", "clientVersion": "7.2.0"}}	/api/mareas/ded76b97-9174-4da7-a7be-94e29ec59af5/actions/REGISTRAR_INICIO	POST	::1
a198c8e8-ca8e-4da9-ba99-31f8b336e8b3	2026-01-12 22:45:41.739+00	ERROR	BACKEND	GlobalExceptionFilter	8951226f-00a0-4e79-8772-9c915882cd52	admin@obs.com	Unauthorized	UnauthorizedException: Unauthorized\n    at MixinAuthGuard.handleRequest (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+passport@11.0.5_@ne_3e2e1635e1fc880657f155ecf43895f0\\node_modules\\@nestjs\\passport\\dist\\auth.guard.js:60:30)\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+passport@11.0.5_@ne_3e2e1635e1fc880657f155ecf43895f0\\node_modules\\@nestjs\\passport\\dist\\auth.guard.js:44:124\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+passport@11.0.5_@ne_3e2e1635e1fc880657f155ecf43895f0\\node_modules\\@nestjs\\passport\\dist\\auth.guard.js:83:24\n    at allFailed (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\passport@0.7.0\\node_modules\\passport\\lib\\middleware\\authenticate.js:110:18)\n    at attempt (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\passport@0.7.0\\node_modules\\passport\\lib\\middleware\\authenticate.js:183:28)\n    at strategy.fail (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\passport@0.7.0\\node_modules\\passport\\lib\\middleware\\authenticate.js:314:9)\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\passport-jwt@4.0.1\\node_modules\\passport-jwt\\lib\\strategy.js:106:33\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\jsonwebtoken@9.0.3\\node_modules\\jsonwebtoken\\verify.js:190:16\n    at getSecret (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\jsonwebtoken@9.0.3\\node_modules\\jsonwebtoken\\verify.js:97:14)\n    at module.exports [as verify] (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\jsonwebtoken@9.0.3\\node_modules\\jsonwebtoken\\verify.js:101:10)	{"query": {}, "params": {"id": "b3778346-44bf-40ef-86c8-0d2de86c9637"}, "exception": {"message": "Unauthorized", "statusCode": 401}}	/api/mareas/b3778346-44bf-40ef-86c8-0d2de86c9637/context	GET	::1
\.


--
-- Data for Name: especies; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.especies (id, codigo, nombre_cientifico, nombre_vulgar, activo, observaciones) FROM stdin;
652746a2-9842-4062-a25c-da35e61a39fe	0000000001	Genypterus blacodes	Abadejo	t	\N
d6b9bc61-374b-4a2b-a083-bd46ec179d33	0000000002	Engraulis anchoita	Anchoíta	t	\N
8281dcf2-411d-4743-89fe-b79149c0a3c7	0000000003	Scomber japonicus	Caballa	t	\N
0318c3b1-3cff-481b-9045-b4a067f2c0be	0000000004	Illex argentinus	Calamar	t	\N
fb0d7ae3-e572-427c-beae-d0e971f332d8	0000000005	Lithodes santolla	Centolla	t	\N
f01f63e2-c6a7-4dd9-be59-9108aed67850	0000000006	-	Especies australes	t	\N
e6685d84-5141-4304-82f3-a41d6c3b7ec4	0000000007	Pleoticus muelleri	Langostino	t	\N
4f4b1566-a82d-4a0c-85f5-e8b810756fc5	0000000008	Merluccius hubbsi	Merluza común	t	\N
ab02718a-0854-4367-bbc3-b9e6feee2af6	0000000009	Dissostichus eleginoides	Merluza negra	t	\N
21a1e91c-885d-4a82-8b72-61ce5940bc0b	0000000010	Zygochlamys patagonica	Vieira	t	\N
\.


--
-- Data for Name: estados_marea; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.estados_marea (id, codigo, nombre, descripcion, categoria, orden, es_inicial, es_final, permite_carga_archivos, permite_correccion, permite_informe, activo, mostrar_en_panel) FROM stdin;
596d396b-a7db-46f6-a9ba-a525b7cc75a5	DESIGNADA	Designada	\N	PENDIENTE	1	t	f	f	f	f	t	t
69b9484e-11e9-459f-9f5a-dcdbeba2111b	EN_EJECUCION	En ejecución	\N	PENDIENTE	2	f	f	f	f	f	t	t
6aa3e1af-c033-4aab-a945-e1d1736f9348	ESPERANDO_ENTREGA	Esperando entrega de datos	\N	PENDIENTE	3	f	f	f	f	f	t	t
1e03e6f5-cb29-44d9-a0f6-2972094864a5	ENTREGADA_RECIBIDA	Entregada / Recibida	\N	PENDIENTE	4	f	f	t	f	f	t	t
d2e07f0c-7f47-4403-b81b-d0044a0ed4a8	VERIFICACION_INICIAL	Verificación inicial	\N	EN_CURSO	5	f	f	t	f	f	t	t
ba1bbb47-0be5-4403-a795-0014edc75886	EN_CORRECCION	En corrección interna	\N	EN_CURSO	6	f	f	t	t	f	t	t
e587e33f-bbe4-4b19-96d0-727afbe832ac	DELEGADA_EXTERNA	Delegada / En espera externa	\N	EN_CURSO	7	f	f	t	f	f	t	f
c165a1bc-7330-4110-acec-b666b75b1542	PENDIENTE_DE_INFORME	Pendiente de informe	\N	EN_CURSO	8	f	f	f	f	t	t	t
cdcdf26e-2681-4ad6-a823-efc65825783f	ESPERANDO_REVISION	Esperando revisión de informe	\N	EN_CURSO	9	f	f	f	f	t	t	f
e715ca3a-b1a3-46f9-93dd-bc46231d00b5	PARA_PROTOCOLIZAR	Para protocolizar	\N	EN_CURSO	10	f	f	f	f	t	t	f
31f2eb5a-2d8c-4266-a6e6-13acf2d4e384	ESPERANDO_PROTOCOLIZACION	Esperando protocolización	\N	EN_CURSO	11	f	f	f	f	t	t	f
32e710ca-57b4-40e3-b97b-c2c97e3f9a05	PROTOCOLIZADA	Protocolizada / Finalizada	\N	COMPLETADO	12	f	t	f	f	t	t	f
e1466c46-8d9b-4f0d-8903-c543a05b8510	CANCELADA	Cancelada / Desestimada	\N	CANCELADO	13	f	t	f	f	f	t	f
\.


--
-- Data for Name: lances; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lances (id, etapa_id, numero_lance, fecha, cod_arte_pesca, tipo_arte_pesca, hora_inicio, lat_inicio, long_inicio, prof_inicio, hora_final, lat_final, long_final, prof_final, rumbo, distancia_red, velocidad_arrastre, tiempo_red, estacion_gral, calador, fondo_min, fondo_max, tamiz, area_barrida, captura_total_kg, descarte_total_kg, observaciones_lance, mus, fuente_dato) FROM stdin;
\.


--
-- Data for Name: mareas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mareas (id, anio_marea, nro_marea, id_buque, id_arte_principal, id_estado_actual, fecha_zarpada_estimada, fecha_inicio_observador, fecha_fin_observador, dias_zona_austral, tipo_calculo_zona_austral, nro_protocolizacion, anio_protocolizacion, fecha_protocolizacion, fecha_creacion, fecha_ultima_actualizacion, activo, observaciones, tipo_marea, dias_estimados) FROM stdin;
ae1c94b3-55c3-4837-bd91-1890ae088de5	2025	182	5d2e398a-7f96-4c2b-a455-58da21ceb1ff	989ce1c1-31ae-4374-abc8-cd39ccc23254	69b9484e-11e9-459f-9f5a-dcdbeba2111b	2025-11-20 03:00:00+00	2025-11-20 16:36:00+00	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-12 16:35:59.039+00	2026-01-12 16:38:17.187+00	t	\N	COMERCIAL	60
4cc719d9-f91e-4988-a59d-3944f146f5c5	2025	183	e113b2d7-af93-44fe-a26e-805429efdd48	d08faf9b-60a9-4081-b8ea-ca931995905b	69b9484e-11e9-459f-9f5a-dcdbeba2111b	2025-11-20 03:00:00+00	2025-11-20 03:00:00+00	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-12 16:40:13.224+00	2026-01-12 17:39:55.281+00	t	\N	COMERCIAL	30
69f920de-6509-492e-afa1-cf04618a97c1	2025	184	2c28cc5a-890c-4152-b972-78aeb3ad281c	989ce1c1-31ae-4374-abc8-cd39ccc23254	69b9484e-11e9-459f-9f5a-dcdbeba2111b	2025-11-26 03:00:00+00	2025-11-26 03:00:00+00	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-12 16:52:16.41+00	2026-01-12 17:53:07.239+00	t	\N	COMERCIAL	60
e54a8b75-e526-40cb-b04f-ebc3ee8c999f	2025	186	6ddb602a-7854-408e-8674-0e787933e02e	08c82cf9-7632-48ff-bc68-de0f882f16bb	69b9484e-11e9-459f-9f5a-dcdbeba2111b	2025-12-15 03:00:00+00	2025-12-15 03:00:00+00	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-12 16:53:07.433+00	2026-01-12 17:53:19.298+00	t	\N	COMERCIAL	40
4bc9095d-4f31-4b2e-b104-29ca8c6751f6	2025	187	06f76a6f-dd4e-490c-b6a2-ee9a8ebcff3d	08c82cf9-7632-48ff-bc68-de0f882f16bb	69b9484e-11e9-459f-9f5a-dcdbeba2111b	2025-12-15 03:00:00+00	2025-12-15 03:00:00+00	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-12 16:54:09.51+00	2026-01-12 17:53:46.565+00	t	\N	COMERCIAL	\N
4beaf51a-e0e5-4188-974c-32ab92a1026a	2025	188	9b521dd3-43c9-4aa5-b948-7d6356cf1930	989ce1c1-31ae-4374-abc8-cd39ccc23254	69b9484e-11e9-459f-9f5a-dcdbeba2111b	2025-12-30 03:00:00+00	2025-12-30 03:00:00+00	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-12 16:55:31.577+00	2026-01-12 17:55:05.868+00	t	\N	COMERCIAL	60
ded76b97-9174-4da7-a7be-94e29ec59af5	2025	189	fc67a193-73d3-42e6-9aa7-7811e559cbfb	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	69b9484e-11e9-459f-9f5a-dcdbeba2111b	2025-12-29 03:00:00+00	2025-12-29 03:00:00+00	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-12 16:56:32.31+00	2026-01-12 20:17:11.58+00	t	\N	COMERCIAL	40
90c44bc2-b8a7-4178-b73a-77469aeaf577	2025	190	206d0307-0af3-419a-99d5-165c7b85f486	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	69b9484e-11e9-459f-9f5a-dcdbeba2111b	2025-12-30 03:00:00+00	2025-12-30 03:00:00+00	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-12 16:57:14.634+00	2026-01-12 20:24:29.392+00	t	\N	COMERCIAL	40
b4f02ca1-b252-469d-be2f-4530d476a066	2025	191	7db9cb20-afb3-4813-8204-a04743b23b3f	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	69b9484e-11e9-459f-9f5a-dcdbeba2111b	2025-12-29 03:00:00+00	2025-12-29 03:00:00+00	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-12 16:57:59.74+00	2026-01-12 20:24:55.973+00	t	\N	COMERCIAL	40
c8c22383-c45f-43c9-8a2b-489a08331611	2025	192	68f3ea0a-6f01-4699-af7d-6f6b57816794	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	69b9484e-11e9-459f-9f5a-dcdbeba2111b	2025-12-29 03:00:00+00	2025-12-29 03:00:00+00	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-12 16:58:48.245+00	2026-01-12 20:25:18.331+00	t	\N	COMERCIAL	40
d581b77c-5f6e-4797-b857-5e26b474506b	2025	193	6f09eaac-4d86-4a68-ac5e-1331d2c14911	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	69b9484e-11e9-459f-9f5a-dcdbeba2111b	2025-12-29 03:00:00+00	2025-12-29 03:00:00+00	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-12 16:59:36.31+00	2026-01-12 20:25:34.884+00	t	\N	COMERCIAL	40
d2cb7e00-43ee-4925-adce-805569631d53	2025	194	01250855-bee5-42b0-afbf-a342b210ca79	d08faf9b-60a9-4081-b8ea-ca931995905b	69b9484e-11e9-459f-9f5a-dcdbeba2111b	2025-12-30 03:00:00+00	2025-12-30 03:00:00+00	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-12 17:01:24.408+00	2026-01-12 20:27:30.972+00	t	\N	COMERCIAL	30
5d9d4470-7611-4cfb-a7e9-092b005a3792	2025	195	395ed19d-038a-42c9-95cc-db61a21fdb8b	d08faf9b-60a9-4081-b8ea-ca931995905b	69b9484e-11e9-459f-9f5a-dcdbeba2111b	2025-12-30 03:00:00+00	2025-12-30 03:00:00+00	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-12 17:02:07.558+00	2026-01-12 20:29:14.033+00	t	\N	COMERCIAL	30
a2b50415-765b-4f10-a8e3-0464430ac492	2025	197	e85d97cf-ab2e-4639-8168-2c1783e4273a	d08faf9b-60a9-4081-b8ea-ca931995905b	69b9484e-11e9-459f-9f5a-dcdbeba2111b	2025-12-30 03:00:00+00	2025-12-30 03:00:00+00	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-12 17:07:14.748+00	2026-01-12 20:32:41.267+00	t	\N	COMERCIAL	30
ad168de2-3be9-431d-a870-2c0b8e413317	2025	196	963558b2-f1a1-462a-bb0c-e1c47eebb71b	d08faf9b-60a9-4081-b8ea-ca931995905b	69b9484e-11e9-459f-9f5a-dcdbeba2111b	2025-12-23 03:00:00+00	2025-12-23 03:00:00+00	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-12 17:03:22.252+00	2026-01-12 20:35:11.906+00	t	\N	COMERCIAL	30
2de414b0-4e2d-414e-acfd-5afb42341e9b	2025	199	426cfd83-e5ac-4d02-a611-f1b4d445321f	08c82cf9-7632-48ff-bc68-de0f882f16bb	69b9484e-11e9-459f-9f5a-dcdbeba2111b	2025-12-26 03:00:00+00	2026-01-09 03:00:00+00	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-12 17:17:21.391+00	2026-01-12 23:12:28.798+00	t	\N	COMERCIAL	60
743be2c7-56ac-4537-bed3-813864c1503c	2025	200	78a9b02e-953a-4fc7-b955-2169483d1537	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	69b9484e-11e9-459f-9f5a-dcdbeba2111b	2025-12-29 03:00:00+00	2025-12-29 03:00:00+00	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-12 17:18:30.061+00	2026-01-12 23:15:18.013+00	t	\N	COMERCIAL	40
d030ccf2-1282-42e4-9558-517df37ba49f	2025	201	794029cb-c7d3-4d57-9d44-625a11b6da5d	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	69b9484e-11e9-459f-9f5a-dcdbeba2111b	2025-12-29 03:00:00+00	2025-12-29 03:00:00+00	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-12 17:20:53.218+00	2026-01-12 23:17:02.539+00	t	\N	COMERCIAL	40
b3778346-44bf-40ef-86c8-0d2de86c9637	2025	198	95444611-ad7f-4532-a8cb-4e71b9dff4de	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	69b9484e-11e9-459f-9f5a-dcdbeba2111b	2025-12-29 03:00:00+00	2025-12-29 03:00:00+00	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-12 17:11:40.151+00	2026-01-12 23:19:25.562+00	t	\N	COMERCIAL	40
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
e701db2c-b5dd-4549-9ea6-ee617171dc2f	ae1c94b3-55c3-4837-bd91-1890ae088de5	1	c85b8285-3bc6-43bc-b664-4b675ee2876d	86f70064-a55b-4d55-b7e9-dc3f320c4cc1	\N	2025-11-22 16:36:00+00	\N	COMERCIAL	\N
ad818735-3101-4cc6-b090-7cf664e2485c	4cc719d9-f91e-4988-a59d-3944f146f5c5	1	ffd18c57-fb77-4959-9191-1a7cf0a17664	86f70064-a55b-4d55-b7e9-dc3f320c4cc1	\N	2025-11-20 03:00:00+00	\N	COMERCIAL	\N
32a56b09-941b-4195-abee-acc3dc52c2e1	69f920de-6509-492e-afa1-cf04618a97c1	1	c85b8285-3bc6-43bc-b664-4b675ee2876d	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	\N	2025-11-26 03:00:00+00	\N	COMERCIAL	\N
a203b21c-daa4-4c4c-b58d-36530fe29296	e54a8b75-e526-40cb-b04f-ebc3ee8c999f	1	79d74266-23c8-4096-b660-cda06d12272c	1fcba1f2-fbf3-4489-b379-286b21f99fd8	\N	2025-12-15 03:00:00+00	\N	COMERCIAL	\N
9d878801-6287-448e-935a-5c2b89ecad92	4bc9095d-4f31-4b2e-b104-29ca8c6751f6	1	79d74266-23c8-4096-b660-cda06d12272c	1fcba1f2-fbf3-4489-b379-286b21f99fd8	\N	2025-12-15 03:00:00+00	\N	COMERCIAL	\N
b8af3863-a88b-4446-b831-c2d04f4ad657	4beaf51a-e0e5-4188-974c-32ab92a1026a	1	c85b8285-3bc6-43bc-b664-4b675ee2876d	86f70064-a55b-4d55-b7e9-dc3f320c4cc1	\N	2025-12-30 03:00:00+00	\N	COMERCIAL	\N
fa09d39c-88b9-4dcc-b077-8d5518063add	ded76b97-9174-4da7-a7be-94e29ec59af5	1	551b3773-09f9-4eb6-a9ce-88abf50b63a1	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-12-29 03:00:00+00	2026-01-04 03:00:00+00	COMERCIAL	
4f8264cf-98f1-4237-9417-f100b38796e9	ded76b97-9174-4da7-a7be-94e29ec59af5	2	551b3773-09f9-4eb6-a9ce-88abf50b63a1	1fcba1f2-fbf3-4489-b379-286b21f99fd8	\N	2026-01-06 03:00:00+00	\N	COMERCIAL	
10b0d22a-ae6e-4eb1-b3ff-fbcfefaed499	90c44bc2-b8a7-4178-b73a-77469aeaf577	1	551b3773-09f9-4eb6-a9ce-88abf50b63a1	1fcba1f2-fbf3-4489-b379-286b21f99fd8	\N	2025-12-30 03:00:00+00	\N	COMERCIAL	
8b150034-fee0-4919-ae65-b6fbf8777bb1	b4f02ca1-b252-469d-be2f-4530d476a066	1	551b3773-09f9-4eb6-a9ce-88abf50b63a1	1fcba1f2-fbf3-4489-b379-286b21f99fd8	\N	2025-12-29 03:00:00+00	\N	COMERCIAL	
04930b94-0358-4d76-9d8f-e441e7ee4ff8	c8c22383-c45f-43c9-8a2b-489a08331611	1	551b3773-09f9-4eb6-a9ce-88abf50b63a1	1fcba1f2-fbf3-4489-b379-286b21f99fd8	\N	2025-12-29 03:00:00+00	\N	COMERCIAL	
da9ca5ee-b60e-4238-a49b-0de6fc608e30	d581b77c-5f6e-4797-b857-5e26b474506b	1	551b3773-09f9-4eb6-a9ce-88abf50b63a1	1fcba1f2-fbf3-4489-b379-286b21f99fd8	\N	2025-12-29 03:00:00+00	\N	COMERCIAL	
088886ce-1707-4c50-b8a5-4c39540d0a4a	d2cb7e00-43ee-4925-adce-805569631d53	1	ffd18c57-fb77-4959-9191-1a7cf0a17664	caf4d1b5-7a3c-445b-98f9-42d842f1d347	\N	2025-12-31 03:00:00+00	\N	COMERCIAL	
46a4c75f-f95e-4ab8-8996-456c2dfbf64b	5d9d4470-7611-4cfb-a7e9-092b005a3792	1	ffd18c57-fb77-4959-9191-1a7cf0a17664	caf4d1b5-7a3c-445b-98f9-42d842f1d347	\N	2025-12-31 03:00:00+00	\N	COMERCIAL	
ef830201-f941-431e-9847-50c2b03a0216	a2b50415-765b-4f10-a8e3-0464430ac492	1	ffd18c57-fb77-4959-9191-1a7cf0a17664	9b892e55-acb6-4574-802b-8058aaecd464	\N	2026-01-01 03:00:00+00	\N	COMERCIAL	
decb430b-6f1c-4077-a845-83f729f58d97	ad168de2-3be9-431d-a870-2c0b8e413317	1	ffd18c57-fb77-4959-9191-1a7cf0a17664	caf4d1b5-7a3c-445b-98f9-42d842f1d347	caf4d1b5-7a3c-445b-98f9-42d842f1d347	2025-12-23 03:00:00+00	2025-12-27 03:00:00+00	COMERCIAL	
c5e7bc2c-d2ff-4351-b619-74b664465c25	ad168de2-3be9-431d-a870-2c0b8e413317	2	ffd18c57-fb77-4959-9191-1a7cf0a17664	caf4d1b5-7a3c-445b-98f9-42d842f1d347	\N	2026-01-01 03:00:00+00	\N	COMERCIAL	
78b48ebb-58a1-47ef-b7c2-bc3f0a1511dc	2de414b0-4e2d-414e-acfd-5afb42341e9b	1	79d74266-23c8-4096-b660-cda06d12272c	1fcba1f2-fbf3-4489-b379-286b21f99fd8	\N	2026-01-09 03:00:00+00	\N	COMERCIAL	
2a57055a-3675-4acf-9af6-36db29117587	743be2c7-56ac-4537-bed3-813864c1503c	1	551b3773-09f9-4eb6-a9ce-88abf50b63a1	1fcba1f2-fbf3-4489-b379-286b21f99fd8	\N	2025-12-29 03:00:00+00	\N	COMERCIAL	
9462ed1f-b79e-45ad-a299-8c3e50315345	d030ccf2-1282-42e4-9558-517df37ba49f	1	551b3773-09f9-4eb6-a9ce-88abf50b63a1	1fcba1f2-fbf3-4489-b379-286b21f99fd8	\N	2025-12-29 03:00:00+00	\N	COMERCIAL	
a7c8fb43-dbb0-47e0-be36-e92a5378661b	b3778346-44bf-40ef-86c8-0d2de86c9637	1	551b3773-09f9-4eb6-a9ce-88abf50b63a1	1fcba1f2-fbf3-4489-b379-286b21f99fd8	caf4d1b5-7a3c-445b-98f9-42d842f1d347	2025-12-29 03:00:00+00	2026-01-05 03:00:00+00	COMERCIAL	
4c17f302-2273-478e-a75a-33add63f405e	b3778346-44bf-40ef-86c8-0d2de86c9637	2	551b3773-09f9-4eb6-a9ce-88abf50b63a1	caf4d1b5-7a3c-445b-98f9-42d842f1d347	\N	2026-01-06 03:00:00+00	\N	COMERCIAL	
\.


--
-- Data for Name: mareas_etapas_observadores; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mareas_etapas_observadores (id, id_etapa, id_observador, rol, es_designado) FROM stdin;
6b5965bc-2b14-4c86-a65d-7e28aab65ad0	e701db2c-b5dd-4549-9ea6-ee617171dc2f	67dd05bf-c7d9-46c9-8ecb-4acd56e08b2c	PRINCIPAL	t
abcbbe80-e5b8-4f79-9e18-72405d584409	ad818735-3101-4cc6-b090-7cf664e2485c	99f20cc1-6646-47a5-a8ab-db8e1d1b5a4c	PRINCIPAL	t
3266be97-5899-4869-9b28-75fe02e12aa4	32a56b09-941b-4195-abee-acc3dc52c2e1	7095db62-e46b-4622-831e-828b9da3a996	PRINCIPAL	t
6f6554b9-a244-4c7c-8222-e3ec5babab02	9d878801-6287-448e-935a-5c2b89ecad92	09a06c54-6c63-45ea-8713-05c23ea758a3	PRINCIPAL	t
1fdd5793-9279-486b-958e-78e4769d7546	a203b21c-daa4-4c4c-b58d-36530fe29296	b288e78b-597d-4077-8eed-4a751481a764	PRINCIPAL	t
ddf8a624-6e45-4f00-8526-adc5b61f29b8	b8af3863-a88b-4446-b831-c2d04f4ad657	66e0eede-1fbd-4831-85f0-a7bea79c34d3	PRINCIPAL	t
38e03cbe-5d17-4309-9732-bfc9fa7a4456	fa09d39c-88b9-4dcc-b077-8d5518063add	d09f06f0-ca9f-4e1e-ac28-492759e65ca8	PRINCIPAL	t
122dde01-c719-4529-960c-32ebc0853ee9	10b0d22a-ae6e-4eb1-b3ff-fbcfefaed499	1ca0dd36-2589-459a-8fd3-e0632edae4b1	PRINCIPAL	t
abedd5b7-c66d-4534-987b-503897639b60	8b150034-fee0-4919-ae65-b6fbf8777bb1	c0e52411-4b93-4d3e-a297-acb8a956a0b4	PRINCIPAL	t
9da4bd55-9ffa-461f-bde5-5023d55608fa	04930b94-0358-4d76-9d8f-e441e7ee4ff8	c0961ab2-ceae-4c27-a9d5-4f54ac510076	PRINCIPAL	t
d67d91ba-d875-419f-a1dd-5d42d10b7060	da9ca5ee-b60e-4238-a49b-0de6fc608e30	5ac39e92-b193-4205-ba9a-46a7a1a9006f	PRINCIPAL	t
d5b09dd7-5d42-4887-b367-914792e6e4b6	088886ce-1707-4c50-b8a5-4c39540d0a4a	8a55a477-86d9-44bd-92c7-2bab0e53430c	PRINCIPAL	t
6971d1da-d6f4-4d80-813c-bd64d52d1dd9	46a4c75f-f95e-4ab8-8996-456c2dfbf64b	4bcff687-53d5-4cf3-9c49-1950efcad1ed	PRINCIPAL	t
af7b3947-e7ef-44e2-86ba-ba40cc63f8e7	decb430b-6f1c-4077-a845-83f729f58d97	a5f98d6a-7b96-47bf-8f14-6659507e408c	PRINCIPAL	t
07e718e1-695c-4d78-af61-0833194427fe	ef830201-f941-431e-9847-50c2b03a0216	366c1b74-afac-4cb3-99bc-4b7114bff512	PRINCIPAL	t
c9b8a43e-6782-4267-9744-a759ef9180d0	a7c8fb43-dbb0-47e0-be36-e92a5378661b	1f99bf1c-77dc-444e-aec0-400a44b876c9	PRINCIPAL	t
73215339-c9c2-42c1-81d3-9f43396dde9f	78b48ebb-58a1-47ef-b7c2-bc3f0a1511dc	05943df7-12f7-4f5b-b4bd-8362394e6fd5	PRINCIPAL	t
0c13f839-be65-4505-bb2e-87eaca25b629	2a57055a-3675-4acf-9af6-36db29117587	adaba0e9-98b1-45fb-a831-ca41d5a9a6da	PRINCIPAL	t
e809c889-c001-4b8d-816e-2ed3538ab785	9462ed1f-b79e-45ad-a299-8c3e50315345	c805581a-6aaf-49f2-9845-52f0976659e1	PRINCIPAL	t
16c0088c-f83a-49bf-bfde-ee28b2e53561	4f8264cf-98f1-4237-9417-f100b38796e9	d09f06f0-ca9f-4e1e-ac28-492759e65ca8	PRINCIPAL	t
e68f4ab1-0e15-4ce5-8a1d-5fb9f79497fd	c5e7bc2c-d2ff-4351-b619-74b664465c25	a5f98d6a-7b96-47bf-8f14-6659507e408c	PRINCIPAL	t
e04387db-66ab-4250-a920-b11815c939b5	4c17f302-2273-478e-a75a-33add63f405e	1f99bf1c-77dc-444e-aec0-400a44b876c9	PRINCIPAL	t
\.


--
-- Data for Name: mareas_movimientos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mareas_movimientos (id, id_marea, fecha_hora, id_usuario, tipo_evento, id_estado_desde, id_estado_hasta, cantidad_muestras_otolitos, detalle) FROM stdin;
53ead404-20c4-4c67-bc26-304f7d65c9cd	ae1c94b3-55c3-4837-bd91-1890ae088de5	2026-01-12 16:35:59.091+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	596d396b-a7db-46f6-a9ba-a525b7cc75a5	\N	Marea creada por Administrador Sistema
468c7d2b-0a94-4ef0-9f9a-3905daa6c98c	ae1c94b3-55c3-4837-bd91-1890ae088de5	2026-01-12 16:38:17.199+00	8951226f-00a0-4e79-8772-9c915882cd52	CAMBIO_ESTADO	596d396b-a7db-46f6-a9ba-a525b7cc75a5	69b9484e-11e9-459f-9f5a-dcdbeba2111b	\N	Inicio Marea. Obs: 20/11/2025 - Zarpada: 22/11/2025
c1078216-20d6-497c-9327-92177e8deb65	4cc719d9-f91e-4988-a59d-3944f146f5c5	2026-01-12 16:40:13.237+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	596d396b-a7db-46f6-a9ba-a525b7cc75a5	\N	Marea creada por Administrador Sistema
e90e77be-f683-45a1-83e7-11a15e4fb647	69f920de-6509-492e-afa1-cf04618a97c1	2026-01-12 16:52:16.421+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	596d396b-a7db-46f6-a9ba-a525b7cc75a5	\N	Marea creada por Administrador Sistema
9fd3486b-b8ea-4bc5-a760-1f151355cd39	e54a8b75-e526-40cb-b04f-ebc3ee8c999f	2026-01-12 16:53:07.443+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	596d396b-a7db-46f6-a9ba-a525b7cc75a5	\N	Marea creada por Administrador Sistema
e6f4e89c-72f2-4627-ac27-e461bfc46cf7	4bc9095d-4f31-4b2e-b104-29ca8c6751f6	2026-01-12 16:54:09.52+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	596d396b-a7db-46f6-a9ba-a525b7cc75a5	\N	Marea creada por Administrador Sistema
dafb3809-c79a-42c2-b7bd-463e1812e011	4beaf51a-e0e5-4188-974c-32ab92a1026a	2026-01-12 16:55:31.587+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	596d396b-a7db-46f6-a9ba-a525b7cc75a5	\N	Marea creada por Administrador Sistema
e78dd351-e388-424b-832e-dae479fc689f	ded76b97-9174-4da7-a7be-94e29ec59af5	2026-01-12 16:56:32.319+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	596d396b-a7db-46f6-a9ba-a525b7cc75a5	\N	Marea creada por Administrador Sistema
0b39a8bf-8a3f-44ac-8ead-051ab0011667	90c44bc2-b8a7-4178-b73a-77469aeaf577	2026-01-12 16:57:14.645+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	596d396b-a7db-46f6-a9ba-a525b7cc75a5	\N	Marea creada por Administrador Sistema
11108d7b-3899-4154-90d1-a29095170fcc	b4f02ca1-b252-469d-be2f-4530d476a066	2026-01-12 16:57:59.749+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	596d396b-a7db-46f6-a9ba-a525b7cc75a5	\N	Marea creada por Administrador Sistema
8f6680a3-1218-4bb4-8718-66c34b5460fc	c8c22383-c45f-43c9-8a2b-489a08331611	2026-01-12 16:58:48.254+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	596d396b-a7db-46f6-a9ba-a525b7cc75a5	\N	Marea creada por Administrador Sistema
d12a8bad-9b58-44a3-b37d-00aadb5d34e6	d581b77c-5f6e-4797-b857-5e26b474506b	2026-01-12 16:59:36.321+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	596d396b-a7db-46f6-a9ba-a525b7cc75a5	\N	Marea creada por Administrador Sistema
948c5283-b1a1-4675-a12f-f66010ecef67	d2cb7e00-43ee-4925-adce-805569631d53	2026-01-12 17:01:24.417+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	596d396b-a7db-46f6-a9ba-a525b7cc75a5	\N	Marea creada por Administrador Sistema
cfc8244c-bd51-4a58-a942-fbf30b086586	5d9d4470-7611-4cfb-a7e9-092b005a3792	2026-01-12 17:02:07.569+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	596d396b-a7db-46f6-a9ba-a525b7cc75a5	\N	Marea creada por Administrador Sistema
99768903-aad6-40ad-a566-df0cdb8e9252	ad168de2-3be9-431d-a870-2c0b8e413317	2026-01-12 17:03:22.263+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	596d396b-a7db-46f6-a9ba-a525b7cc75a5	\N	Marea creada por Administrador Sistema
58dae756-d690-4d3b-8ffe-6ed42d864df3	a2b50415-765b-4f10-a8e3-0464430ac492	2026-01-12 17:07:14.76+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	596d396b-a7db-46f6-a9ba-a525b7cc75a5	\N	Marea creada por Administrador Sistema
9f074ef1-efbf-47fa-af79-6b349c7d057a	b3778346-44bf-40ef-86c8-0d2de86c9637	2026-01-12 17:11:40.161+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	596d396b-a7db-46f6-a9ba-a525b7cc75a5	\N	Marea creada por Administrador Sistema
4577093c-26d5-426e-a056-5fa4c2f4589b	2de414b0-4e2d-414e-acfd-5afb42341e9b	2026-01-12 17:17:21.401+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	596d396b-a7db-46f6-a9ba-a525b7cc75a5	\N	Marea creada por Administrador Sistema
0d1428c3-bb2b-4cf8-b233-31c689448ff8	743be2c7-56ac-4537-bed3-813864c1503c	2026-01-12 17:18:30.07+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	596d396b-a7db-46f6-a9ba-a525b7cc75a5	\N	Marea creada por Administrador Sistema
edb89a74-ba7d-4704-b441-22d30a2e68ca	d030ccf2-1282-42e4-9558-517df37ba49f	2026-01-12 17:20:53.227+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	596d396b-a7db-46f6-a9ba-a525b7cc75a5	\N	Marea creada por Administrador Sistema
095f17fe-ce4e-43d5-97b5-b46d62dfc723	4cc719d9-f91e-4988-a59d-3944f146f5c5	2026-01-12 17:39:55.297+00	8951226f-00a0-4e79-8772-9c915882cd52	CAMBIO_ESTADO	596d396b-a7db-46f6-a9ba-a525b7cc75a5	69b9484e-11e9-459f-9f5a-dcdbeba2111b	\N	Inicio Marea. Obs: 20/11/2025 - Zarpada: 20/11/2025
76a56848-33ab-4a99-853a-99ab26d7edb5	69f920de-6509-492e-afa1-cf04618a97c1	2026-01-12 17:53:07.25+00	8951226f-00a0-4e79-8772-9c915882cd52	CAMBIO_ESTADO	596d396b-a7db-46f6-a9ba-a525b7cc75a5	69b9484e-11e9-459f-9f5a-dcdbeba2111b	\N	Inicio Marea. Obs: 26/11/2025 - Zarpada: 26/11/2025
c5779f3d-35bc-442c-b146-c2d2f085d1eb	e54a8b75-e526-40cb-b04f-ebc3ee8c999f	2026-01-12 17:53:19.305+00	8951226f-00a0-4e79-8772-9c915882cd52	CAMBIO_ESTADO	596d396b-a7db-46f6-a9ba-a525b7cc75a5	69b9484e-11e9-459f-9f5a-dcdbeba2111b	\N	Inicio Marea. Obs: 15/12/2025 - Zarpada: 15/12/2025
3a4b2a88-5af8-4d82-abca-740f71787eb9	4bc9095d-4f31-4b2e-b104-29ca8c6751f6	2026-01-12 17:53:46.577+00	8951226f-00a0-4e79-8772-9c915882cd52	CAMBIO_ESTADO	596d396b-a7db-46f6-a9ba-a525b7cc75a5	69b9484e-11e9-459f-9f5a-dcdbeba2111b	\N	Inicio Marea. Obs: 15/12/2025 - Zarpada: 15/12/2025
40b81104-4544-492a-ae0c-ed1b29f1d4f4	4beaf51a-e0e5-4188-974c-32ab92a1026a	2026-01-12 17:55:05.878+00	8951226f-00a0-4e79-8772-9c915882cd52	CAMBIO_ESTADO	596d396b-a7db-46f6-a9ba-a525b7cc75a5	69b9484e-11e9-459f-9f5a-dcdbeba2111b	\N	Inicio Marea. Obs: 30/12/2025 - Zarpada: 30/12/2025
97fe13f8-b7f5-4253-8ae3-9e9950eca9c1	ded76b97-9174-4da7-a7be-94e29ec59af5	2026-01-12 20:07:39.057+00	8951226f-00a0-4e79-8772-9c915882cd52	CAMBIO_ESTADO	596d396b-a7db-46f6-a9ba-a525b7cc75a5	69b9484e-11e9-459f-9f5a-dcdbeba2111b	\N	Inicio Marea. Obs: 29/12/2025
76e632eb-7cf4-4c59-97e1-270a1c47dea5	ded76b97-9174-4da7-a7be-94e29ec59af5	2026-01-12 20:17:11.603+00	8951226f-00a0-4e79-8772-9c915882cd52	EDICION_ESTRUCTURA	\N	\N	\N	Edición manual de etapas y fechas de observador.
e52899c8-f049-4268-8d9d-66778121c446	90c44bc2-b8a7-4178-b73a-77469aeaf577	2026-01-12 20:24:29.403+00	8951226f-00a0-4e79-8772-9c915882cd52	CAMBIO_ESTADO	596d396b-a7db-46f6-a9ba-a525b7cc75a5	69b9484e-11e9-459f-9f5a-dcdbeba2111b	\N	Inicio Marea. Obs: 30/12/2025
e0a7bc33-7be0-4660-b144-6fb823cdbb4f	b4f02ca1-b252-469d-be2f-4530d476a066	2026-01-12 20:24:55.985+00	8951226f-00a0-4e79-8772-9c915882cd52	CAMBIO_ESTADO	596d396b-a7db-46f6-a9ba-a525b7cc75a5	69b9484e-11e9-459f-9f5a-dcdbeba2111b	\N	Inicio Marea. Obs: 29/12/2025
8578e227-9f8a-41a0-80de-ccffc2ec6c9d	c8c22383-c45f-43c9-8a2b-489a08331611	2026-01-12 20:25:18.344+00	8951226f-00a0-4e79-8772-9c915882cd52	CAMBIO_ESTADO	596d396b-a7db-46f6-a9ba-a525b7cc75a5	69b9484e-11e9-459f-9f5a-dcdbeba2111b	\N	Inicio Marea. Obs: 29/12/2025
ce18221f-7167-4134-9d81-ae6dbd1f9178	d581b77c-5f6e-4797-b857-5e26b474506b	2026-01-12 20:25:34.895+00	8951226f-00a0-4e79-8772-9c915882cd52	CAMBIO_ESTADO	596d396b-a7db-46f6-a9ba-a525b7cc75a5	69b9484e-11e9-459f-9f5a-dcdbeba2111b	\N	Inicio Marea. Obs: 29/12/2025
56622212-4207-4443-87a5-ba6f2509d379	d2cb7e00-43ee-4925-adce-805569631d53	2026-01-12 20:27:30.983+00	8951226f-00a0-4e79-8772-9c915882cd52	CAMBIO_ESTADO	596d396b-a7db-46f6-a9ba-a525b7cc75a5	69b9484e-11e9-459f-9f5a-dcdbeba2111b	\N	Inicio Marea. Obs: 30/12/2025
a6bf7049-fb48-4920-9fcf-f8b03b0df1cf	5d9d4470-7611-4cfb-a7e9-092b005a3792	2026-01-12 20:29:14.045+00	8951226f-00a0-4e79-8772-9c915882cd52	CAMBIO_ESTADO	596d396b-a7db-46f6-a9ba-a525b7cc75a5	69b9484e-11e9-459f-9f5a-dcdbeba2111b	\N	Inicio Marea. Obs: 30/12/2025
e448cdef-51a0-4ca0-bf94-16aee7718a37	a2b50415-765b-4f10-a8e3-0464430ac492	2026-01-12 20:32:41.279+00	8951226f-00a0-4e79-8772-9c915882cd52	CAMBIO_ESTADO	596d396b-a7db-46f6-a9ba-a525b7cc75a5	69b9484e-11e9-459f-9f5a-dcdbeba2111b	\N	Inicio Marea. Obs: 30/12/2025
96513146-671f-4e43-8543-dc12575348fc	ad168de2-3be9-431d-a870-2c0b8e413317	2026-01-12 20:35:11.915+00	8951226f-00a0-4e79-8772-9c915882cd52	CAMBIO_ESTADO	596d396b-a7db-46f6-a9ba-a525b7cc75a5	69b9484e-11e9-459f-9f5a-dcdbeba2111b	\N	Inicio Marea. Obs: 23/12/2025
f69235e8-cdab-495b-8b32-539925841355	b3778346-44bf-40ef-86c8-0d2de86c9637	2026-01-12 22:51:40.643+00	8951226f-00a0-4e79-8772-9c915882cd52	CAMBIO_ESTADO	596d396b-a7db-46f6-a9ba-a525b7cc75a5	69b9484e-11e9-459f-9f5a-dcdbeba2111b	\N	Inicio Marea. Obs: 29/12/2025
5684c1cc-0c58-40ce-b422-61631e39fb22	2de414b0-4e2d-414e-acfd-5afb42341e9b	2026-01-12 23:12:28.811+00	8951226f-00a0-4e79-8772-9c915882cd52	CAMBIO_ESTADO	596d396b-a7db-46f6-a9ba-a525b7cc75a5	69b9484e-11e9-459f-9f5a-dcdbeba2111b	\N	Inicio Marea. Obs: 9/1/2026
0e7bcb83-2a16-4f9e-a183-f918db0cf3c7	743be2c7-56ac-4537-bed3-813864c1503c	2026-01-12 23:15:18.025+00	8951226f-00a0-4e79-8772-9c915882cd52	CAMBIO_ESTADO	596d396b-a7db-46f6-a9ba-a525b7cc75a5	69b9484e-11e9-459f-9f5a-dcdbeba2111b	\N	Inicio Marea. Obs: 29/12/2025
fead4657-8b7a-4b90-be8f-2ddd8d564106	d030ccf2-1282-42e4-9558-517df37ba49f	2026-01-12 23:17:02.552+00	8951226f-00a0-4e79-8772-9c915882cd52	CAMBIO_ESTADO	596d396b-a7db-46f6-a9ba-a525b7cc75a5	69b9484e-11e9-459f-9f5a-dcdbeba2111b	\N	Inicio Marea. Obs: 29/12/2025
a30cdeac-3c03-44ca-b3e2-79fb2e60af02	b3778346-44bf-40ef-86c8-0d2de86c9637	2026-01-12 23:19:25.579+00	8951226f-00a0-4e79-8772-9c915882cd52	EDICION_ESTRUCTURA	\N	\N	\N	Edición manual de etapas y fechas de observador.
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
05943df7-12f7-4f5b-b4bd-8362394e6fd5	7610	Raul Bernardo	Bargas Peña	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	rbbargas@gmail.com	\N
c7824abb-e0e6-4c6e-b448-066c30d550ff	7611	Cristian Emmanuel	Cerrina	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	manucerrina2@gmail.com	\N
1f99bf1c-77dc-444e-aec0-400a44b876c9	7612	Richard Javier	Espinola Gysin	\N	OBSERVADOR	1109	t	t	\N	\N	f	richardjesp@gmail.com	\N
2e5ec06b-e15b-4696-b541-5ae0c626b2c7	7724	Eduardo Esteban	Aguilar	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	edu81aguilar@gmail.com	\N
99f20cc1-6646-47a5-a8ab-db8e1d1b5a4c	7726	Juan José	Coppa	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	juancoppa@hotmail.com	\N
a693db05-1e0c-4638-af21-7ce73fa50509	7728	Adrian Pascual	Galluzzo	\N	OBSERVADOR	MONOTRIBUTISTA	f	t	\N	\N	t	apgalluzzo@hotmail.com	Jubilación
66e0eede-1fbd-4831-85f0-a7bea79c34d3	7729	Walter Alejandro	Glavina	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	glavinawalter@hotmail.com	\N
565abd74-0cfb-42ea-81bd-ae487fed298c	7730	Carlos Daniel	Herrera	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	aquimardel@gmail.com	\N
e052e5ad-08e2-49ef-82b2-aec9508161c0	7733	Maria Lucila	Maydana	\N	OBSERVADOR	MONOTRIBUTISTA	f	t	\N	\N	f	\N	\N
d445b145-df04-4ef9-9ffe-caf81bc291d5	7735	Sergio Fabian	Najle	\N	OBSERVADOR	MONOTRIBUTISTA	f	t	\N	\N	t	najlesergio@yahoo.com.ar	Licencia médica
f5ee5150-4ca5-4268-ba0c-8fb04fd70162	7740	Leonardo Luis	Spagnuolo Rey	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	leospagnuolorey@yahoo.com.ar	\N
11095e2e-c46d-402c-a910-c8677e581cfd	7742	Héctor Luis	Teves	\N	OBSERVADOR	MONOTRIBUTISTA	f	t	\N	\N	t	hecluteves@hotmail.com	Jubilación
c281fbc5-de0a-4b8c-b5f9-20c2564c9ef1	7767	Claudio Alberto	Nadal	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	nadal-claudio@hotmail.com	\N
fb0a5517-f4fc-4afa-bf8c-dc939430b6a2	7776	Gonzalo	Troccoli	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	gtroccoli@inidep.edu.ar	\N
c0961ab2-ceae-4c27-a9d5-4f54ac510076	7796	Fernando Alberto	Schwartz	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	gallococo@hotmail.com	\N
7095db62-e46b-4622-831e-828b9da3a996	7798	Marcelo Simón	Freyre	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	freyre.ms@gmail.com	\N
d92a6cc5-7810-4d12-84fb-95cc9965ca85	7828	Fabian Eduardo	Desojo	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	t	pachappppp@gmail.com	Cambio de empleo a engrasador
1cfdc183-5136-4923-ac14-01dda4d47a51	7832	Maximiliano Adrian	Godoy	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	maxigodox@gmail.com	\N
67dd05bf-c7d9-46c9-8ecb-4acd56e08b2c	7838	Nicolas Facundo	Staneff Rotela	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	nicolas.staneff@gmail.com	\N
82eec08c-333b-4fd0-86ad-b2bee3277fc4	7840	Durbal	Villalba	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	villalbadurbal@gmail.com	\N
62c16919-f33c-49d1-b3ad-24fe015c7264	7841	Nicolas Agustin	Caballero	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	Nicck934@gmail.com	\N
bf21c0ee-9b33-4fac-83f0-694133cfd351	7842	Gabriel Osvaldo Catriel	Gimenez Salinas	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	pikyred123@gmail.com	\N
bb98934e-9e10-4baf-b1da-102b64cd898c	7843	Johnatan	Challier	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	jonhychallier@gmail.com	\N
09a06c54-6c63-45ea-8713-05c23ea758a3	7844	Sebastían Roque	Garcia	\N	OBSERVADOR	MONOTRIBUTISTA	f	t	\N	\N	f	sebastianroquegarcia4@gmail.com	\N
23ea449a-5717-4c85-a0c7-0af76c1d342f	7845	Alexia	Aguilar	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	aguilaralexia00@gmail.com	\N
681170d0-e33a-4864-a5ed-b340efad9eab	7846	Oriana	Retamar Mendez	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	t	orianaretamarm@gmail.com	Restricción operativa para embarque de mujeres
d10d1d34-7d04-48bc-8ed5-8702aaec6da0	7847	Gianfranco	Alvarez	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	gianalvarezobs@gmail.com	\N
2317749a-d197-4873-a9fc-ac7e1ac81feb	7848	Diego	Gorosito	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	diegojavierg158@gmail.com	\N
fdfbf185-599e-401f-8f65-24f1174f1e04	7849	Leonardo	Prado Escobar	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	t	estudioprado02@gmail.com	Inactivo según reporte
c6bde025-138c-4468-8700-54aef611902a	7850	María Laura	Monterisi	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	mlm.vlady@gmail.com	\N
f5329a28-54ed-464c-b80d-eb5088404481	7851	Alvaro	Benitez	\N	OBSERVADOR	MONOTRIBUTISTA	f	t	\N	\N	t	alvarobeni89@gmail.com	En otro trabajo
ea3e3865-272a-4512-b0fa-028a4ef708dd	7852	Camila	Corti	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	camilacorti95@gmail.com	\N
b2ef0bc6-9476-4d7c-9b4f-a41fb2bf27db	2021	Claudio	Noale	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	t	claudionoale@hotmail.com	Cambio de trabajo
de89af79-db6f-4f3f-b3f4-92515a098490	7149	Gustavo	Cano	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	\N	\N
9c28f134-87b7-415c-ac40-98b6110e971c	7562	Lucas	Bentos	\N	TECNICO	LEY MARCO	t	t	\N	\N	f	\N	\N
42e6aca7-f73f-407f-98cd-bcb775487186	7613	Federico Nicolás	Garcia	\N	OBSERVADOR	1109	t	f	\N	\N	t	fede.gaarciaa@gmail.com	Accidente en motocicleta
1ba0799f-4e1a-424f-b667-5decbc9699d8	7616	Jorge Guillermo	Herrera	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	herrerajorgeguillermo@gmail.com	\N
2e831852-846f-40cd-923a-56d8b5d880b8	7617	Leonardo Marcos	Kren	\N	OBSERVADOR	MONOTRIBUTISTA	f	t	\N	\N	t	lmlemark@gmail.com	Licencia médica
55af1bd2-74bc-4ae5-970c-d916a9e78ef3	7620	Diego Sebastian	Marchiori	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	brugmasia@hotmail.com	\N
bae7f1a0-bf6b-48d1-9c44-2a55cd6af939	7621	Luis Gabriel	Martinez Tecco	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	lgmt666@hotmail.com	\N
fc382ff6-1ed2-49e5-988a-90c09b49dadb	7624	Teresa Beatriz	Reinaga	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	tere2361@hotmail.com	\N
b288e78b-597d-4077-8eed-4a751481a764	7625	Eduardo	Silvester	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	eduwolfsilvester@hotmail.com	\N
a2e57f9b-0a17-4bef-89bf-703b5505dc4d	7627	Jorge Luis	Morales	\N	OBSERVADOR	PLANTA PERMANENTE	t	t	\N	\N	f	didiinidep1980@gmail.com	\N
0689b379-899d-42af-b5f6-56ae253657d9	7864	Manuel Agustín	Palos	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
d5b8e040-9af6-4475-9a18-cc524b6c6450	7865	Gabriel Alejandro	Dumrauf	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
8a55a477-86d9-44bd-92c7-2bab0e53430c	7866	Francisco German	Sette	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
0a3ed076-8b9e-4fbc-be38-12bc398dea5b	7867	Cintia Daiana	Magrini Quiroga	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
c0e52411-4b93-4d3e-a297-acb8a956a0b4	7868	Lucas Oscar	Gaona	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
44f7f0ff-921a-487c-aae5-14ec5f653bf1	7869	Sergio Gastón	Frontera	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
d09f06f0-ca9f-4e1e-ac28-492759e65ca8	7871	Sergio Javier	Gomez Mapiz	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
5ac39e92-b193-4205-ba9a-46a7a1a9006f	7872	Juan Francisco	Rodriguez Fulco	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
c805581a-6aaf-49f2-9845-52f0976659e1	7873	Lucas David	Carabeta	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
015409b2-59f2-404e-858b-1af9c9c1f5ba	9474	Juan Manuel	Staneff	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	juanmanuel_jotis@hotmail.com	\N
63a38f88-b458-4702-898d-2e601a72f46e	9476	Héctor Eduardo	Vera	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	t	veraeduardo1971@gmail.com	Licencia médica
277251b3-cac9-49e5-a46c-91681fc081d6	9480	Cristian Oscar	Piriz	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	cristianpiriz36@gmail.com	
1197662f-ec99-4fcf-a002-e0c80670302b	9465	Daniel Alejandro	Di Tullio	\N	OBSERVADOR	LEY MARCO	t	t	\N		f	ddi@inidep.edu.ar	\N
bfb93ee4-854e-446e-bea9-ef9512671d4a	7853	Luciano	Matte Casietto	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	lucianomcassietto@hotmail.com.ar	\N
886af39c-fefe-4d8a-84ed-cb6d102f23a1	7854	Gisele	Garcia	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	t	garciagiselealejandra@gmail.com	Desempeño insuficiente reportado
e2c757c5-ba91-4d0d-81b8-792d549909f7	7855	Nicolas	Pereyra	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	nicolasagustinpereyra777@gmail.com	\N
f549f76a-884d-465a-b5fb-db83fb0c563f	7858	Franco	Ibarra	\N	OBSERVADOR	MONOTRIBUTISTA	t	f	\N	\N	t	francoadrianibarra@gmail.com	En otro empleo
9610e6d9-7ae3-4f8d-acb1-567d47e71063	7859	Melisa	Garcia	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	t	melipg7@gmail.com	Restricción operativa para embarque de mujeres
1ca0dd36-2589-459a-8fd3-e0632edae4b1	7860	Nahuel	Ramirez	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	nahuelramirezm@gmail.com	\N
a5f98d6a-7b96-47bf-8f14-6659507e408c	7861	Daiana Anabella	Molina Riquelme	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
56b5c75e-bf1e-40db-9436-f2b83af18631	7862	Christian Enderson	Fenco Chavesta	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
032a87c5-cffa-46ff-8ccd-373d37a64bc2	7863	Daniel Enrique	Ramunno	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
4bcff687-53d5-4cf3-9c49-1950efcad1ed	7874	Morena Aylen	Ledesma	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
e87e3cec-fe87-4479-aff1-077a8c88b487	7875	Leonardo Ezequiel	Andrade	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
9f528479-00ee-4aef-8440-6749a7f38358	7876	Walter Alejandro	Leon	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
19534b72-3f82-4104-a735-753369802b69	7879	Lucía	Martinez Ta	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
adaba0e9-98b1-45fb-a831-ca41d5a9a6da	7900	Paola Alejandra	Navarro Grassi	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
e4d6e76a-dc73-4a28-8e1c-abb8b1aa599b	8002	Julio Roberto	Sinconegui	\N	OBSERVADOR	MONOTRIBUTISTA	f	t	\N	\N	f	jrsinconegui@inidep.edu.ar	\N
bb9ca799-61b1-4150-9eea-b8ee43895ef0	9442	Sebastian	Garcia	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
fe65513f-febf-47ed-8ab0-a1faf7b0361d	9451	Jorge Fernando	Repetto	\N	OBSERVADOR	MONOTRIBUTISTA	f	t	\N	\N	t	cotoperca23@hotmail.com	Jubilación
76701261-b7ec-40bd-9c6c-f777be5508f0	9459	Raúl Antonio Ceferino	Puliafito	\N	OBSERVADOR	MONOTRIBUTISTA	f	t	\N	\N	t	raul.puliafito@gmail.com	Traslado a otro programa
75be52a1-b570-4cd1-bb66-e3bbe27fad15	9460	Pablo Alejandro	Ramos	\N	OBSERVADOR	MONOTRIBUTISTA	f	t	\N	\N	t	pabloramos64@yahoo.com.ar	Licencia médica
366c1b74-afac-4cb3-99bc-4b7114bff512	9461	Alejandro José	Mazzei	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	alejandromazzei525@gmail.com	\N
501379b1-853c-401d-8409-bc4b31b95b4d	9467	Pablo Julian	Miranda	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	pablojmiranda65@gmail.com	\N
dec6f04a-0a75-43a8-89c9-dde5780e0384	9471	Estanislao	Rodriguez Fulco	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	rfestanislao@gmail.com	\N
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
1ff39402-76a9-4553-83cf-e5c1cc49a7f6	ABADEJO	Abadejo	\N	Peces	\N	t
09d3c9d9-4b8c-485a-a12d-43838cfc2e4a	ANCHOITA	Anchoíta	\N	Peces	\N	t
e871de63-9864-429f-b65e-c375b1547c41	CABALLA	Caballa	\N	Peces	\N	t
551b3773-09f9-4eb6-a9ce-88abf50b63a1	CALAMAR	Calamar	\N	Moluscos	\N	t
ffd18c57-fb77-4959-9191-1a7cf0a17664	CENTOLLA	Centolla	\N	Crustáceos	\N	t
c85b8285-3bc6-43bc-b664-4b675ee2876d	AUSTRALES	Especies australes	\N	Peces	\N	t
5507dd96-8c9a-4f7c-823a-2f87e36ef9e9	LANGOSTINO	Langostino	\N	Crustáceos	\N	t
bec74e80-f32e-4e58-9588-35bd863f8715	MERLUZA_COMUN	Merluza común	\N	Peces	\N	t
7594af4a-8070-43b7-99bf-5a891d61cb60	MERLUZA_NEGRA	Merluza negra	\N	Peces	\N	t
79d74266-23c8-4096-b660-cda06d12272c	VIEIRA	Vieira	\N	Moluscos	\N	t
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
89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	Buenos Aires	\N	\N	12	\N	f	t	\N	\N	-34.58333	-58.38334
09838581-2cb0-410f-bf45-c0ca689618f7	Rio Grande (brasil)	\N	\N	20	\N	f	t	\N	\N	-32.13334	-52.08333
ebc6eada-56f1-4fb1-b07c-7c6ae45e4598	Montevideo	\N	\N	XX	\N	f	t	\N	\N	-34.9	-56.2
5f634f97-1076-40f5-a50d-43953a481206	Samborombon	\N	\N	21	\N	f	t	\N	\N	-35.73333	-57.31667
94b76846-a440-43ca-b6ab-0fc7f5d33cb0	San Clemente	\N	\N	14	\N	f	t	\N	\N	-36.33333	-56.78333
1fcba1f2-fbf3-4489-b379-286b21f99fd8	Mar Del Plata	\N	\N	1	\N	t	t	\N	\N	-38.06667	-57.55
8838d028-9cfe-4fe5-960e-3f45b0d5174f	Quequen	\N	\N	2	\N	f	t	\N	\N	-38.58333	-58.7
f20aba40-3236-4ae4-b2aa-9c236e7217fa	Bahia Blanca	\N	\N	3	\N	f	t	\N	\N	-38.75	-62.16667
aa1bff2a-726b-4a2b-a0c5-dae33c1df8b7	Bahia San Blas	\N	\N	15	\N	f	t	\N	\N	-40.55	-62.23333
7d5ff874-4bcc-46c2-8c86-cea7587cfe39	San Antonio Oeste	\N	\N	9	\N	f	t	\N	\N	-40.73333	-64.96667
83b05ce8-212d-45a6-a77c-0444076e1d78	Viedma	\N	\N	22	\N	f	t	\N	\N	-40.9	-62.86666
6771adbe-0387-41ba-a8d0-3a49e63fa8e9	Puerto Madryn	\N	\N	4	\N	f	t	\N	\N	-42.76667	-65.05
cd0af388-5ae6-4ed0-9de5-f8f5a375bf43	Rawson	\N	\N	7	\N	f	t	\N	\N	-43.33333	-65.06667
2c2bfbfd-ffd7-4498-8111-7923e341e5e1	Bahia Camarones	\N	\N	11	\N	f	t	\N	\N	-44.8	-65.73333
9b892e55-acb6-4574-802b-8058aaecd464	Comod, Rivad,	\N	\N	6	\N	f	t	\N	\N	-45.88334	-67.5
40557abc-469e-46cd-9eed-f16677a12703	Caleta Olivia	\N	\N	16	\N	f	t	\N	\N	-46.43333	-67.53333
caf4d1b5-7a3c-445b-98f9-42d842f1d347	Deseado	\N	\N	5	\N	f	t	\N	\N	-47.76667	-65.91666
33576f47-c67e-44e1-99eb-33963994732b	San Julian	\N	\N	17	\N	f	t	\N	\N	-49.31667	-67.73333
4d382523-3924-4326-865a-cf0901b247a0	Punta Quilla	\N	\N	23	\N	f	t	\N	\N	-50.11666	-68.41666
725a9f64-e224-4aba-b363-4613dbc86b0b	Rio Gallegos	\N	\N	19	\N	f	t	\N	\N	-51.63334	-69.2
86f70064-a55b-4d55-b7e9-dc3f320c4cc1	Ushuaia	\N	\N	10	\N	f	t	\N	\N	-54.83333	-68.3
\.


--
-- Data for Name: submuestras; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.submuestras (id, muestra_id, numero_ejemplar, largo_total, largo_estandar, peso_total_g, peso_gonadas_g, sexo, estadio_madurez, replecion, contenido_estomacal, observaciones_ejemplar) FROM stdin;
\.


--
-- Data for Name: tipos_flota; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tipos_flota (id, codigo, nombre, descripcion, orden, activo, codigo_numerico) FROM stdin;
f66f75bd-9f71-42a6-a319-b9aecc608960	COSTERO	Costero	\N	\N	t	21
d217e8f2-267d-47cb-b9a2-6a22e6366eba	RADA_RIA	Rada o Ría	\N	\N	t	11
1eb2717f-2feb-4b54-9edd-2f52c095ce9f	ALTURA_FRESQUERO	Altura (Fresquero)	\N	\N	t	31
49f1a6b1-610e-4aab-98e6-45dbe753fe22	ALTURA_CONGELADOR	Altura (Congelador)	\N	\N	t	32
3396a7a4-5c2b-473e-93a2-d66105f78818	INVESTIGACION	Investigación	\N	\N	t	90
07f4f8be-5285-4459-9248-90da8b4f1729	INDETERMINADO	Indeterminado	\N	\N	t	99
\.


--
-- Data for Name: transiciones_estados; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.transiciones_estados (id, id_estado_origen, id_estado_destino, accion, etiqueta, clase_boton, requiere_observaciones, activo) FROM stdin;
ba2e900d-b954-41fc-a6f5-81520fa29cf4	596d396b-a7db-46f6-a9ba-a525b7cc75a5	69b9484e-11e9-459f-9f5a-dcdbeba2111b	REGISTRAR_INICIO	Registrar Inicio	primary	f	t
dbccfa54-b2f2-4081-a888-02bd41123bf7	69b9484e-11e9-459f-9f5a-dcdbeba2111b	6aa3e1af-c033-4aab-a945-e1d1736f9348	REGISTRAR_ARRIBO	Confirmar Arribo	primary	f	t
2c20bb40-34d7-4843-a6cf-d49448091340	6aa3e1af-c033-4aab-a945-e1d1736f9348	1e03e6f5-cb29-44d9-a0f6-2972094864a5	RECIBIR_DATOS	Recibir Archivos	primary	f	t
a08e85e2-7cc8-405f-9de7-36fb6358344d	1e03e6f5-cb29-44d9-a0f6-2972094864a5	d2e07f0c-7f47-4403-b81b-d0044a0ed4a8	INICIAR_VERIFICACION	Iniciar Verificación	primary	f	t
e50e1cfd-a5d4-4804-9eb6-80ae3ad42b58	d2e07f0c-7f47-4403-b81b-d0044a0ed4a8	ba1bbb47-0be5-4403-a795-0014edc75886	ABRIR_CORRECCION	Abrir Corrección	secondary	f	t
5230e0d4-3044-4da3-a3d2-05b62da20cd8	d2e07f0c-7f47-4403-b81b-d0044a0ed4a8	c165a1bc-7330-4110-acec-b666b75b1542	PASAR_A_INFORME	Pasar a Informe	primary	f	t
534d1f98-69ce-498b-bd06-9d931dec727c	ba1bbb47-0be5-4403-a795-0014edc75886	c165a1bc-7330-4110-acec-b666b75b1542	FINALIZAR_CORRECCION	Finalizar Corrección	primary	f	t
ec091ad3-a61a-4481-bf42-862476e56870	ba1bbb47-0be5-4403-a795-0014edc75886	e587e33f-bbe4-4b19-96d0-727afbe832ac	DELEGAR_EXTERNA	Derivar a Proyecto	secondary	f	t
ac6dfa18-22c4-4995-8c0c-0f1878a65152	e587e33f-bbe4-4b19-96d0-727afbe832ac	ba1bbb47-0be5-4403-a795-0014edc75886	RETORNAR_CORRECCION	Devolución Externa	primary	f	t
d50ea669-8ab6-4758-8173-ef75ca7089d8	c165a1bc-7330-4110-acec-b666b75b1542	cdcdf26e-2681-4ad6-a823-efc65825783f	ENVIAR_A_REVISION	Enviar a Revisión	primary	f	t
3a92f0f6-8017-4422-81d5-c375132cd376	cdcdf26e-2681-4ad6-a823-efc65825783f	e715ca3a-b1a3-46f9-93dd-bc46231d00b5	APROBAR_INFORME	Aprobar Informe	primary	f	t
f382be77-8104-4bf5-b6ef-c35ad6b9fbc2	cdcdf26e-2681-4ad6-a823-efc65825783f	c165a1bc-7330-4110-acec-b666b75b1542	RECHAZAR_INFORME	Observaciones en Informe	secondary	f	t
3590215a-5ab4-4d3e-9c24-96429d65ad44	e715ca3a-b1a3-46f9-93dd-bc46231d00b5	31f2eb5a-2d8c-4266-a6e6-13acf2d4e384	INICIAR_TRAMITE	Iniciar Protocolización	primary	f	t
514d562a-a9a8-477b-b411-b1ea1fc98dec	31f2eb5a-2d8c-4266-a6e6-13acf2d4e384	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	FINALIZAR_PROTOCOLIZACION	Finalizar Protocolización	primary	f	t
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, email, password, "fullName", "isActive", roles, "themePreference", "avatarUrl") FROM stdin;
8951226f-00a0-4e79-8772-9c915882cd52	admin@obs.com	$2b$10$CWXvv0E2rFmJYAlEv1c32eJOj.B3Vb5QL2lfoiewua9UK2NmRUwnS	Administrador Sistema	t	{admin}	system	\N
88ac5f05-990d-4416-8cde-3767c7f4d060	coordinador@obs.com	$2b$10$CWXvv0E2rFmJYAlEv1c32eJOj.B3Vb5QL2lfoiewua9UK2NmRUwnS	Coordinador Operativo	t	{coordinador}	system	\N
c09d38fc-c25f-49d3-adf9-21dade0cc46d	tecnico@obs.com	$2b$10$CWXvv0E2rFmJYAlEv1c32eJOj.B3Vb5QL2lfoiewua9UK2NmRUwnS	Técnico de Datos	t	{tecnico_datos}	system	\N
5de6657b-ac5c-4fde-9d80-a10da7aa4455	asistente@obs.com	$2b$10$CWXvv0E2rFmJYAlEv1c32eJOj.B3Vb5QL2lfoiewua9UK2NmRUwnS	Asistente Administrativo	t	{asistente_administrativo}	system	\N
764123f0-7ea6-4c60-aeab-31dad2d89a36	danieldt2000@hotmail.com	$2b$10$CWXvv0E2rFmJYAlEv1c32eJOj.B3Vb5QL2lfoiewua9UK2NmRUwnS	Daniel Di Tullio	t	{tecnico_datos}	system	\N
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
-- Name: alertas_eventos alertas_eventos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alertas_eventos
    ADD CONSTRAINT alertas_eventos_pkey PRIMARY KEY (id);


--
-- Name: alertas alertas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alertas
    ADD CONSTRAINT alertas_pkey PRIMARY KEY (id);


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
-- Name: alertas_asignado_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX alertas_asignado_id_idx ON public.alertas USING btree (asignado_id);


--
-- Name: alertas_codigo_unico_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX alertas_codigo_unico_key ON public.alertas USING btree (codigo_unico);


--
-- Name: alertas_estado_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX alertas_estado_idx ON public.alertas USING btree (estado);


--
-- Name: alertas_eventos_alerta_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX alertas_eventos_alerta_id_idx ON public.alertas_eventos USING btree (alerta_id);


--
-- Name: alertas_referencia_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX alertas_referencia_id_idx ON public.alertas USING btree (referencia_id);


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
-- Name: tipos_flota_codigo_numerico_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX tipos_flota_codigo_numerico_key ON public.tipos_flota USING btree (codigo_numerico);


--
-- Name: transiciones_estados_id_estado_origen_id_estado_destino_acc_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX transiciones_estados_id_estado_origen_id_estado_destino_acc_key ON public.transiciones_estados USING btree (id_estado_origen, id_estado_destino, accion);


--
-- Name: users_email_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX users_email_key ON public.users USING btree (email);


--
-- Name: alertas alertas_asignado_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alertas
    ADD CONSTRAINT alertas_asignado_id_fkey FOREIGN KEY (asignado_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: alertas alertas_creado_por_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alertas
    ADD CONSTRAINT alertas_creado_por_id_fkey FOREIGN KEY (creado_por_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: alertas_eventos alertas_eventos_alerta_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alertas_eventos
    ADD CONSTRAINT alertas_eventos_alerta_id_fkey FOREIGN KEY (alerta_id) REFERENCES public.alertas(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: alertas_eventos alertas_eventos_usuario_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alertas_eventos
    ADD CONSTRAINT alertas_eventos_usuario_id_fkey FOREIGN KEY (usuario_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE SET NULL;


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
-- PostgreSQL database dump complete
--

\unrestrict AoCplFftqznf6deE34oECPJPsVrkyjTMMGqk0i2Yrqe3bmHdn3QYaKVQupk0uv7

