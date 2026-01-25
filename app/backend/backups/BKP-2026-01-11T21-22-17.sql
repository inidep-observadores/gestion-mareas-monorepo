--
-- PostgreSQL database dump
--

\restrict Lts46UDL7R4fSRWwxTGBDCF702jgC2nBZT7QKBeBjOtJbMME5dRDA4uJVjrhz4g

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
6986c8b6-7089-444c-bc14-56cdd20d265e	RETRASO_DATOS-424cd44c-1238-4a44-8b91-f642c33169e4	424cd44c-1238-4a44-8b91-f642c33169e4	RETRASO_DATOS	Retraso en Entrega de Datos	Marea MC-175-25 (ANITA) - 33 días de demora.	PENDIENTE	ALTA	2026-01-09 02:51:56.327+00	\N	\N	\N	\N	2026-01-09 02:51:56.328+00	{"vessel": "ANITA", "busDays": 33, "mareaCode": "MC-175-25"}	MAREA
9b364b62-391f-4f1c-ad90-e0326d85c617	FATIGA-99f20cc1-6646-47a5-a8ab-db8e1d1b5a4c-2025	99f20cc1-6646-47a5-a8ab-db8e1d1b5a4c	FATIGA	Fatiga Crítica Detectada	El observador Juan José Coppa ha navegado 202 días en el año.	PENDIENTE	ALTA	2026-01-09 02:51:56.068+00	\N	\N	\N	\N	2026-01-09 02:51:56.076+00	{"days": 202, "observerName": "Juan José Coppa"}	OBSERVADOR
984dcc6f-3fcf-4d2c-b0e5-2353b883c99a	FATIGA-fc382ff6-1ed2-49e5-988a-90c09b49dadb-2025	fc382ff6-1ed2-49e5-988a-90c09b49dadb	FATIGA	Fatiga Crítica Detectada	El observador Teresa Beatriz Reinaga ha navegado 216 días en el año.	PENDIENTE	ALTA	2026-01-09 02:51:56.117+00	\N	\N	\N	\N	2026-01-09 02:51:56.119+00	{"days": 216, "observerName": "Teresa Beatriz Reinaga"}	OBSERVADOR
237a0376-7d3a-48d4-bac6-79c76a78ce65	FATIGA-015409b2-59f2-404e-858b-1af9c9c1f5ba-2025	015409b2-59f2-404e-858b-1af9c9c1f5ba	FATIGA	Fatiga Crítica Detectada	El observador Juan Manuel Staneff ha navegado 198 días en el año.	PENDIENTE	ALTA	2026-01-09 02:51:56.131+00	\N	\N	\N	\N	2026-01-09 02:51:56.132+00	{"days": 198, "observerName": "Juan Manuel Staneff"}	OBSERVADOR
4ca74589-cc83-475e-8884-3fc833a77c59	FATIGA-c7824abb-e0e6-4c6e-b448-066c30d550ff-2025	c7824abb-e0e6-4c6e-b448-066c30d550ff	FATIGA	Fatiga Crítica Detectada	El observador Cristian Emmanuel Cerrina ha navegado 193 días en el año.	PENDIENTE	ALTA	2026-01-09 02:51:56.142+00	\N	\N	\N	\N	2026-01-09 02:51:56.143+00	{"days": 193, "observerName": "Cristian Emmanuel Cerrina"}	OBSERVADOR
37a5f437-d6c7-46d9-bbac-7697ac3f34f5	FATIGA-501379b1-853c-401d-8409-bc4b31b95b4d-2025	501379b1-853c-401d-8409-bc4b31b95b4d	FATIGA	Fatiga Crítica Detectada	El observador Pablo Julian Miranda ha navegado 202 días en el año.	PENDIENTE	ALTA	2026-01-09 02:51:56.153+00	\N	\N	\N	\N	2026-01-09 02:51:56.154+00	{"days": 202, "observerName": "Pablo Julian Miranda"}	OBSERVADOR
5e651c78-3da9-40ee-a580-10b5e90ed98f	FATIGA-1197662f-ec99-4fcf-a002-e0c80670302b-2025	1197662f-ec99-4fcf-a002-e0c80670302b	FATIGA	Fatiga Crítica Detectada	El observador Daniel Alejandro Di Tullio ha navegado 166 días en el año.	PENDIENTE	ALTA	2026-01-09 02:51:56.165+00	\N	\N	\N	\N	2026-01-09 02:51:56.166+00	{"days": 166, "observerName": "Daniel Alejandro Di Tullio"}	OBSERVADOR
20d82466-1976-4005-a517-6a7feefce8fa	FATIGA-05943df7-12f7-4f5b-b4bd-8362394e6fd5-2025	05943df7-12f7-4f5b-b4bd-8362394e6fd5	FATIGA	Fatiga Crítica Detectada	El observador Raul Bernardo Bargas Peña ha navegado 174 días en el año.	PENDIENTE	ALTA	2026-01-09 02:51:56.177+00	\N	\N	\N	\N	2026-01-09 02:51:56.178+00	{"days": 174, "observerName": "Raul Bernardo Bargas Peña"}	OBSERVADOR
8824cd34-f102-416c-9da7-6505459ab848	FATIGA-82eec08c-333b-4fd0-86ad-b2bee3277fc4-2025	82eec08c-333b-4fd0-86ad-b2bee3277fc4	FATIGA	Fatiga Crítica Detectada	El observador Durbal Villalba ha navegado 192 días en el año.	PENDIENTE	ALTA	2026-01-09 02:51:56.189+00	\N	\N	\N	\N	2026-01-09 02:51:56.19+00	{"days": 192, "observerName": "Durbal Villalba"}	OBSERVADOR
310d14ba-d15d-491a-9488-5eb501fd4064	FATIGA-d10d1d34-7d04-48bc-8ed5-8702aaec6da0-2025	d10d1d34-7d04-48bc-8ed5-8702aaec6da0	FATIGA	Fatiga Crítica Detectada	El observador Gianfranco Alvarez ha navegado 274 días en el año.	PENDIENTE	ALTA	2026-01-09 02:51:56.2+00	\N	\N	\N	\N	2026-01-09 02:51:56.201+00	{"days": 274, "observerName": "Gianfranco Alvarez"}	OBSERVADOR
29ddc178-e734-4f2b-88b1-dd40a1934d1c	FATIGA-55af1bd2-74bc-4ae5-970c-d916a9e78ef3-2025	55af1bd2-74bc-4ae5-970c-d916a9e78ef3	FATIGA	Fatiga Crítica Detectada	El observador Diego Sebastian Marchiori ha navegado 165 días en el año.	PENDIENTE	ALTA	2026-01-09 02:51:56.211+00	\N	\N	\N	\N	2026-01-09 02:51:56.212+00	{"days": 165, "observerName": "Diego Sebastian Marchiori"}	OBSERVADOR
c4f4c15e-a8dd-4498-9973-af6e5813c02a	FATIGA-bb98934e-9e10-4baf-b1da-102b64cd898c-2025	bb98934e-9e10-4baf-b1da-102b64cd898c	FATIGA	Fatiga Crítica Detectada	El observador Johnatan Challier ha navegado 216 días en el año.	PENDIENTE	ALTA	2026-01-09 02:51:56.222+00	\N	\N	\N	\N	2026-01-09 02:51:56.223+00	{"days": 216, "observerName": "Johnatan Challier"}	OBSERVADOR
9e808c98-0471-436c-9e54-9c30f5799bc0	FATIGA-bfb93ee4-854e-446e-bea9-ef9512671d4a-2025	bfb93ee4-854e-446e-bea9-ef9512671d4a	FATIGA	Fatiga Crítica Detectada	El observador Luciano Matte Casietto ha navegado 187 días en el año.	PENDIENTE	ALTA	2026-01-09 02:51:56.233+00	\N	\N	\N	\N	2026-01-09 02:51:56.234+00	{"days": 187, "observerName": "Luciano Matte Casietto"}	OBSERVADOR
fdf2c212-6ed8-4c33-b71b-17c332e6344c	FATIGA-2317749a-d197-4873-a9fc-ac7e1ac81feb-2025	2317749a-d197-4873-a9fc-ac7e1ac81feb	FATIGA	Fatiga Crítica Detectada	El observador Diego Gorosito ha navegado 185 días en el año.	PENDIENTE	ALTA	2026-01-09 02:51:56.244+00	\N	\N	\N	\N	2026-01-09 02:51:56.246+00	{"days": 185, "observerName": "Diego Gorosito"}	OBSERVADOR
3e9e8b6d-28cf-4ff3-8a5b-ed2b5351d85b	FATIGA-62c16919-f33c-49d1-b3ad-24fe015c7264-2025	62c16919-f33c-49d1-b3ad-24fe015c7264	FATIGA	Fatiga Crítica Detectada	El observador Nicolas Agustin Caballero ha navegado 193 días en el año.	PENDIENTE	ALTA	2026-01-09 02:51:56.256+00	\N	\N	\N	\N	2026-01-09 02:51:56.257+00	{"days": 193, "observerName": "Nicolas Agustin Caballero"}	OBSERVADOR
0173beb3-6800-41ed-a011-d64a1ceaad67	FATIGA-63a38f88-b458-4702-898d-2e601a72f46e-2025	63a38f88-b458-4702-898d-2e601a72f46e	FATIGA	Fatiga Crítica Detectada	El observador Héctor Eduardo Vera ha navegado 166 días en el año.	PENDIENTE	ALTA	2026-01-09 02:51:56.267+00	\N	\N	\N	\N	2026-01-09 02:51:56.268+00	{"days": 166, "observerName": "Héctor Eduardo Vera"}	OBSERVADOR
b99901e3-8d16-47b7-a99a-4b4b10646c1a	FATIGA-67dd05bf-c7d9-46c9-8ecb-4acd56e08b2c-2025	67dd05bf-c7d9-46c9-8ecb-4acd56e08b2c	FATIGA	Fatiga Crítica Detectada	El observador Nicolas Facundo Staneff Rotela ha navegado 196 días en el año.	PENDIENTE	ALTA	2026-01-09 02:51:56.279+00	\N	\N	\N	\N	2026-01-09 02:51:56.28+00	{"days": 196, "observerName": "Nicolas Facundo Staneff Rotela"}	OBSERVADOR
c8330bb3-838f-4880-ada4-c077fff1d7ac	FATIGA-b288e78b-597d-4077-8eed-4a751481a764-2025	b288e78b-597d-4077-8eed-4a751481a764	FATIGA	Fatiga Crítica Detectada	El observador Eduardo Silvester ha navegado 173 días en el año.	PENDIENTE	ALTA	2026-01-09 02:51:56.29+00	\N	\N	\N	\N	2026-01-09 02:51:56.291+00	{"days": 173, "observerName": "Eduardo Silvester"}	OBSERVADOR
42dc3018-c11b-401b-8178-42e213b6411a	RETRASO_DATOS-20c472b3-fabb-4fb4-aff1-52bf1e7824e2	20c472b3-fabb-4fb4-aff1-52bf1e7824e2	RETRASO_DATOS	Retraso en Entrega de Datos	Marea MC-162-25 (TANGO I) - 32 días de demora.	PENDIENTE	ALTA	2026-01-09 02:51:56.337+00	\N	\N	\N	\N	2026-01-09 02:51:56.338+00	{"vessel": "TANGO I", "busDays": 32, "mareaCode": "MC-162-25"}	MAREA
c1e5dbb6-f887-461f-9d7f-03d09293e572	RETRASO_DATOS-5a6bbfa4-a098-4b19-99aa-cc3ffdfbaafb	5a6bbfa4-a098-4b19-99aa-cc3ffdfbaafb	RETRASO_DATOS	Retraso en Entrega de Datos	Marea MC-169-25 (DUKAT) - 32 días de demora.	PENDIENTE	ALTA	2026-01-09 02:51:56.347+00	\N	\N	\N	\N	2026-01-09 02:51:56.348+00	{"vessel": "DUKAT", "busDays": 32, "mareaCode": "MC-169-25"}	MAREA
efd8dfbd-a539-463b-8592-d25d05af3274	FATIGA-366c1b74-afac-4cb3-99bc-4b7114bff512-2025	366c1b74-afac-4cb3-99bc-4b7114bff512	FATIGA	Fatiga Crítica Detectada	El observador Alejandro José Mazzei ha navegado 168 días en el año.	DESCARTADA	ALTA	2026-01-09 02:51:56.301+00	\N	2026-01-09 03:25:49.511+00	\N	\N	2026-01-09 03:25:49.513+00	{"days": 168, "observerName": "Alejandro José Mazzei"}	OBSERVADOR
e57713b2-e86f-45dd-9773-795a9162185b	RETRASO_DATOS-aec58204-f489-4d6f-a981-3b42ca4a341b	aec58204-f489-4d6f-a981-3b42ca4a341b	RETRASO_DATOS	Retraso en Entrega de Datos	Marea MC-174-25 (ERIN BRUCE II) - 32 días de demora.	PENDIENTE	ALTA	2026-01-09 02:51:56.358+00	\N	\N	\N	\N	2026-01-09 02:51:56.359+00	{"vessel": "ERIN BRUCE II", "busDays": 32, "mareaCode": "MC-174-25"}	MAREA
08b93fd3-5732-4cbe-981b-c85f2f9ccab7	RETRASO_DATOS-bb26bbcb-ee6d-4370-9c16-84f03d8d362b	bb26bbcb-ee6d-4370-9c16-84f03d8d362b	RETRASO_DATOS	Retraso en Entrega de Datos	Marea MC-183-25 (CHIYO MARU Nº 3) - 23 días de demora.	SEGUIMIENTO	ALTA	2026-01-09 02:51:56.397+00	2026-01-17 00:00:00+00	\N	\N	\N	2026-01-10 01:34:32.234+00	{"vessel": "CHIYO MARU Nº 3", "busDays": 23, "mareaCode": "MC-183-25"}	MAREA
9d782478-26b2-43f3-a6ae-54e5188fe351	RETRASO_DATOS-8e16409e-972b-48dd-9ed5-e9c74a66d9f5	8e16409e-972b-48dd-9ed5-e9c74a66d9f5	RETRASO_DATOS	Retraso en Entrega de Datos	Marea MC-181-25 (MISS TIDE) - 27 días de demora.	PENDIENTE	ALTA	2026-01-09 02:51:56.388+00	\N	\N	\N	\N	2026-01-09 02:51:56.389+00	{"vessel": "MISS TIDE", "busDays": 27, "mareaCode": "MC-181-25"}	MAREA
321fd7b3-b54f-44e2-b8ea-006eb60eeabe	RETRASO_DATOS-d5596483-4141-4dbe-b48b-89012e691760	d5596483-4141-4dbe-b48b-89012e691760	RETRASO_DATOS	Retraso en Entrega de Datos	Marea MC-178-25 (TALISMAN) - 18 días de demora.	PENDIENTE	ALTA	2026-01-09 02:51:56.408+00	\N	\N	\N	\N	2026-01-09 02:51:56.408+00	{"vessel": "TALISMAN", "busDays": 18, "mareaCode": "MC-178-25"}	MAREA
7bb781c2-caec-4c3d-bff6-43a7e9564484	RETRASO_INFORME-04a1cdbe-7149-4e8d-977c-44f6d2f4a7e8	04a1cdbe-7149-4e8d-977c-44f6d2f4a7e8	RETRASO_INFORME	Informe Demorado	Marea MC-185-25 (ATREVIDO) - 23 días desde recepción.	PENDIENTE	MEDIA	2026-01-09 02:51:56.417+00	\N	\N	\N	\N	2026-01-09 02:51:56.418+00	{"vessel": "ATREVIDO", "busDays": 23, "mareaCode": "MC-185-25"}	MAREA
d31a1444-b753-4b4f-9aa0-3495be72dff6	RETRASO_INFORME-75a873cf-209e-4153-9151-bf4bb2d1458a	75a873cf-209e-4153-9151-bf4bb2d1458a	RETRASO_INFORME	Informe Demorado	Marea MC-161-25 (TANGO II) - 18 días desde recepción.	PENDIENTE	MEDIA	2026-01-09 02:51:56.426+00	\N	\N	\N	\N	2026-01-09 02:51:56.427+00	{"vessel": "TANGO II", "busDays": 18, "mareaCode": "MC-161-25"}	MAREA
43684dbf-7bea-4adf-b747-a111182a9099	RETRASO_DATOS-361d3933-1f72-4b73-9a61-b6e0f59c8765	361d3933-1f72-4b73-9a61-b6e0f59c8765	RETRASO_DATOS	Retraso en Entrega de Datos	Marea MC-180-25 (ATLANTIC EXPRESS) - 16 días de demora.	PENDIENTE	ALTA	2026-01-09 03:07:26.743+00	\N	\N	\N	\N	2026-01-09 03:07:26.747+00	{"vessel": "ATLANTIC EXPRESS", "busDays": 16, "mareaCode": "MC-180-25"}	MAREA
c120f37a-68bf-47c0-8b75-90ecb9ec3f76	FATIGA-bf21c0ee-9b33-4fac-83f0-694133cfd351-2025	bf21c0ee-9b33-4fac-83f0-694133cfd351	FATIGA	Fatiga Crítica Detectada	El observador Gabriel Osvaldo Catriel Gimenez Salinas ha navegado 166 días en el año.	RESUELTA	ALTA	2026-01-09 02:51:56.312+00	\N	2026-01-09 03:20:10.735+00	\N	\N	2026-01-09 03:20:10.74+00	{"days": 166, "observerName": "Gabriel Osvaldo Catriel Gimenez Salinas"}	OBSERVADOR
b4e1b87f-5abb-4c25-821f-d18e28e125c5	RETRASO_DATOS-29b952e7-e297-4266-9291-8620c4ac7f07	29b952e7-e297-4266-9291-8620c4ac7f07	RETRASO_DATOS	Retraso en Entrega de Datos	Marea MC-171-25 (CAPESANTE) - 28 días de demora.	RESUELTA	ALTA	2026-01-09 02:51:56.368+00	2026-01-16 00:00:00+00	2026-01-09 03:39:24.511+00	\N	\N	2026-01-09 03:39:24.512+00	{"vessel": "CAPESANTE", "busDays": 28, "mareaCode": "MC-171-25"}	MAREA
4848871a-143e-4e91-890f-f27af4a75130	RETRASO_DATOS-16769449-70e9-4830-91df-fdb05cfda24f	16769449-70e9-4830-91df-fdb05cfda24f	RETRASO_DATOS	Retraso en Entrega de Datos	Marea MC-177-25 (UR ERTZA) - 28 días de demora.	SEGUIMIENTO	ALTA	2026-01-09 02:51:56.378+00	2026-01-12 00:00:00+00	\N	\N	\N	2026-01-09 03:40:04.032+00	{"vessel": "UR ERTZA", "busDays": 28, "mareaCode": "MC-177-25"}	MAREA
\.


--
-- Data for Name: alertas_eventos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.alertas_eventos (id, alerta_id, fecha_hora, usuario_id, tipo_evento, detalle) FROM stdin;
1f1e5633-d875-44be-9158-24c876388d74	9b364b62-391f-4f1c-ad90-e0326d85c617	2026-01-09 02:51:56.11+00	\N	CREACION	Alerta detectada/creada
d1313004-7e80-4525-96c7-18c1530b2864	984dcc6f-3fcf-4d2c-b0e5-2353b883c99a	2026-01-09 02:51:56.125+00	\N	CREACION	Alerta detectada/creada
21dab08a-d1cc-4133-b8e7-1ba1b45723a7	237a0376-7d3a-48d4-bac6-79c76a78ce65	2026-01-09 02:51:56.136+00	\N	CREACION	Alerta detectada/creada
27851850-e179-450a-817f-ed9f052c57c1	4ca74589-cc83-475e-8884-3fc833a77c59	2026-01-09 02:51:56.147+00	\N	CREACION	Alerta detectada/creada
c79404f2-7f9b-4264-b218-42aaa4397478	37a5f437-d6c7-46d9-bbac-7697ac3f34f5	2026-01-09 02:51:56.158+00	\N	CREACION	Alerta detectada/creada
aca41aeb-84e7-40e1-a33d-0fbf17f4b0f7	5e651c78-3da9-40ee-a580-10b5e90ed98f	2026-01-09 02:51:56.17+00	\N	CREACION	Alerta detectada/creada
d617cbb0-1146-4fd3-a4d9-4de15a05183f	20d82466-1976-4005-a517-6a7feefce8fa	2026-01-09 02:51:56.182+00	\N	CREACION	Alerta detectada/creada
564edf6f-ac07-45fb-ae93-18cd1321ea38	8824cd34-f102-416c-9da7-6505459ab848	2026-01-09 02:51:56.194+00	\N	CREACION	Alerta detectada/creada
d8ee188b-5272-4a21-89c1-0fabf6dcfedf	310d14ba-d15d-491a-9488-5eb501fd4064	2026-01-09 02:51:56.205+00	\N	CREACION	Alerta detectada/creada
390b5ad0-4b81-4541-be59-14b5de18755b	29ddc178-e734-4f2b-88b1-dd40a1934d1c	2026-01-09 02:51:56.216+00	\N	CREACION	Alerta detectada/creada
58912e4d-7b25-4cf9-97eb-9c893fc8e8e1	c4f4c15e-a8dd-4498-9973-af6e5813c02a	2026-01-09 02:51:56.227+00	\N	CREACION	Alerta detectada/creada
03c69b78-6cda-4a02-9597-ea639cea1275	9e808c98-0471-436c-9e54-9c30f5799bc0	2026-01-09 02:51:56.238+00	\N	CREACION	Alerta detectada/creada
00b096f0-e6f5-455d-8d19-f2614e7e04db	fdf2c212-6ed8-4c33-b71b-17c332e6344c	2026-01-09 02:51:56.25+00	\N	CREACION	Alerta detectada/creada
3876e5ed-98b2-4745-b952-98a3598b6e3b	3e9e8b6d-28cf-4ff3-8a5b-ed2b5351d85b	2026-01-09 02:51:56.262+00	\N	CREACION	Alerta detectada/creada
a5440d18-0615-445f-b9a7-4a624d7d48bb	0173beb3-6800-41ed-a011-d64a1ceaad67	2026-01-09 02:51:56.273+00	\N	CREACION	Alerta detectada/creada
4ca08ebf-6fe3-4d8d-8e15-c9615d2dea8b	b99901e3-8d16-47b7-a99a-4b4b10646c1a	2026-01-09 02:51:56.284+00	\N	CREACION	Alerta detectada/creada
ad58c137-fb80-4c24-9d21-1fa626888f81	c8330bb3-838f-4880-ada4-c077fff1d7ac	2026-01-09 02:51:56.295+00	\N	CREACION	Alerta detectada/creada
c2078259-8e52-4c8a-bd29-c55aabd14bc4	efd8dfbd-a539-463b-8592-d25d05af3274	2026-01-09 02:51:56.306+00	\N	CREACION	Alerta detectada/creada
196d7ef7-cde4-487e-9bce-2683df02c524	c120f37a-68bf-47c0-8b75-90ecb9ec3f76	2026-01-09 02:51:56.317+00	\N	CREACION	Alerta detectada/creada
c7079e20-63ba-4d72-8393-e330dac342f5	6986c8b6-7089-444c-bc14-56cdd20d265e	2026-01-09 02:51:56.332+00	\N	CREACION	Alerta detectada/creada
f517d87f-e0a0-45de-af88-0845a97f2bc8	42dc3018-c11b-401b-8178-42e213b6411a	2026-01-09 02:51:56.342+00	\N	CREACION	Alerta detectada/creada
20aa7009-72a3-41be-b749-21d7c0c7d7e4	c1e5dbb6-f887-461f-9d7f-03d09293e572	2026-01-09 02:51:56.352+00	\N	CREACION	Alerta detectada/creada
edf07015-be76-425a-86bd-b16178a3b0f3	e57713b2-e86f-45dd-9773-795a9162185b	2026-01-09 02:51:56.363+00	\N	CREACION	Alerta detectada/creada
ea3dcf19-d18f-449c-a75c-d1299d8c3e7b	b4e1b87f-5abb-4c25-821f-d18e28e125c5	2026-01-09 02:51:56.373+00	\N	CREACION	Alerta detectada/creada
ddf40b01-a0e1-49a9-8a32-5f713b9711f3	4848871a-143e-4e91-890f-f27af4a75130	2026-01-09 02:51:56.382+00	\N	CREACION	Alerta detectada/creada
e8c43796-9a38-4c62-bf98-cd3dcb7cfbab	9d782478-26b2-43f3-a6ae-54e5188fe351	2026-01-09 02:51:56.392+00	\N	CREACION	Alerta detectada/creada
d5bf08f4-2554-4d0a-8604-ebf4a9f18585	08b93fd3-5732-4cbe-981b-c85f2f9ccab7	2026-01-09 02:51:56.402+00	\N	CREACION	Alerta detectada/creada
5c97510c-e945-4095-a193-96c29cb407a9	321fd7b3-b54f-44e2-b8ea-006eb60eeabe	2026-01-09 02:51:56.412+00	\N	CREACION	Alerta detectada/creada
4a00b5ae-e52c-4570-93ec-688082fd73c9	7bb781c2-caec-4c3d-bff6-43a7e9564484	2026-01-09 02:51:56.421+00	\N	CREACION	Alerta detectada/creada
5f8e3a71-1093-4f49-824f-d69b3e9b03f2	d31a1444-b753-4b4f-9aa0-3495be72dff6	2026-01-09 02:51:56.431+00	\N	CREACION	Alerta detectada/creada
8d05f33c-5b3a-4de2-81ae-4dd8dfff3e14	43684dbf-7bea-4adf-b747-a111182a9099	2026-01-09 03:07:26.769+00	\N	CREACION	Alerta detectada/creada
9b0f9535-d841-4c21-99d0-b82dead55089	c120f37a-68bf-47c0-8b75-90ecb9ec3f76	2026-01-09 03:20:10.768+00	8951226f-00a0-4e79-8772-9c915882cd52	CAMBIO_ESTADO	Estado: PENDIENTE -> RESUELTA. Notas: Llamar
f604bc00-b695-44b5-a817-8ed5b550034b	efd8dfbd-a539-463b-8592-d25d05af3274	2026-01-09 03:25:49.537+00	8951226f-00a0-4e79-8772-9c915882cd52	CAMBIO_ESTADO	Estado: PENDIENTE -> DESCARTADA. Notas: Va a seguir navegando
9aff6b9c-89a1-464c-86cb-2b8836d444cf	b4e1b87f-5abb-4c25-821f-d18e28e125c5	2026-01-09 03:33:27.427+00	8951226f-00a0-4e79-8772-9c915882cd52	CAMBIO_ESTADO	Estado: PENDIENTE -> SEGUIMIENTO. Notas: Se llamó para preguntar
86a90bb2-73f5-432d-bc36-f40deba45005	b4e1b87f-5abb-4c25-821f-d18e28e125c5	2026-01-09 03:38:54.156+00	8951226f-00a0-4e79-8772-9c915882cd52	COMENTARIO	Se llamó para reclamar
71dbbe69-9b84-4c99-84c3-0f5b8cb5c0f5	b4e1b87f-5abb-4c25-821f-d18e28e125c5	2026-01-09 03:39:24.519+00	8951226f-00a0-4e79-8772-9c915882cd52	CAMBIO_ESTADO	Estado: SEGUIMIENTO -> RESUELTA. Notas: Se llamó para reclamar
6e274db6-5d26-42c7-8756-b162ea036de1	4848871a-143e-4e91-890f-f27af4a75130	2026-01-09 03:39:43.923+00	8951226f-00a0-4e79-8772-9c915882cd52	CAMBIO_ESTADO	Estado: PENDIENTE -> SEGUIMIENTO. Notas: Llamada de reclamo
1b85fca4-c982-4736-afc6-528d55879c28	4848871a-143e-4e91-890f-f27af4a75130	2026-01-09 03:40:04.04+00	8951226f-00a0-4e79-8772-9c915882cd52	COMENTARIO	Se llamó otra vez
09d546ca-bf8e-4097-bf51-f44a3b729595	08b93fd3-5732-4cbe-981b-c85f2f9ccab7	2026-01-10 01:34:12.938+00	8951226f-00a0-4e79-8772-9c915882cd52	COMENTARIO	Se envió un reclamo de documentación por correo electrónico el 09/01/2026.
4e92e67f-6884-4acb-912b-0202be938833	08b93fd3-5732-4cbe-981b-c85f2f9ccab7	2026-01-10 01:34:32.252+00	8951226f-00a0-4e79-8772-9c915882cd52	CAMBIO_ESTADO	Estado: PENDIENTE -> SEGUIMIENTO. Notas: Se envió nota de reclamo
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
eced58f3-443f-4435-b706-b3e5bb40e16c	7 de Diciembre	TEMP-0001	1013	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	27.20	521	1fcba1f2-fbf3-4489-b379-286b21f99fd8		Mar del Plata	4895032		\N	operacionesconsultoramaritima@gmail.com	\N	\N	Consultora Maritima	t	\N	\N	\N
0d0ad567-f9b6-45eb-b3f1-2ef0f9f89f2c	ACRUX	03086	0	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	28.00	0	1fcba1f2-fbf3-4489-b379-286b21f99fd8	DE ANGELIS Y LOGGHE S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
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
a84b8ed5-6b9b-4aad-91dc-e51347049605	ARBUMASA XVIII	0217	1121	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	36.40	870	caf4d1b5-7a3c-445b-98f9-42d842f1d347	ARBUMASA  S.A.	Puerto Deseado	4893758	0297-487-2807 / 444-5338 / 444-1201	\N	miguel-visoso@hotmail.com	\N	\N	Agencia Maritima Solvox	t	\N	\N	\N
1f605b27-29a9-48e6-8055-da7a0512949a	ARBUMASA XXIX	02561	1126	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	65.60	1776	1fcba1f2-fbf3-4489-b379-286b21f99fd8	BAL - FISH  S.A.	Mar del Plata		489-6522	\N		\N	\N		t	\N	\N	\N
d2fa5b8e-6edb-4679-a21f-f3250e6d71fc	ARBUMASA XXVI	01958	1127	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	62.80	2403	caf4d1b5-7a3c-445b-98f9-42d842f1d347	ARBUMASA  S.A.	Puerto Deseado	4893758	0297-487-2807 / 444-5338 / 444-1201	\N	miguel-visoso@hotmail.com	\N	\N	Agencia Maritima Solvox	t	\N	\N	\N
f796bbda-66f5-4fcb-bea4-dafdb086a6d5	ARBUMASA XXVII	02057	1128	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	64.21	1154	1fcba1f2-fbf3-4489-b379-286b21f99fd8	BAL - FISH  S.A.	Mar del Plata		489-6522	\N		\N	\N		t	\N	\N	\N
c5c3c325-4a69-4a8d-9f57-5c65006da37a	ARBUMASA XXVIII	02569	1129	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	64.40	1776	caf4d1b5-7a3c-445b-98f9-42d842f1d347	ARBUMASA  S.A.	Puerto Deseado		0297-487-2807 / 444-5338 / 444-1201	\N		\N	\N		t	\N	\N	\N
7889535c-0d03-4848-a510-62c9e2ec7a58	ARCANGEL	79	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	CALME  S.A.	Mar del Plata		480-3545	\N		\N	\N		t	\N	\N	\N
21209053-16fa-445e-9abf-1d0399197970	ARESIT	02265	1134	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	36.26	1085	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	HARENGUS  S.A.	Puerto Madryn	4808331/4808332	0280-445-0822	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
d989be58-efa0-432e-acff-e2da0c407a1c	ARGENOVA I	02180	1137	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	35.00	655	caf4d1b5-7a3c-445b-98f9-42d842f1d347	ARGENOVA  S.A.	Puerto Deseado	4808331/4808332	0297- 487-0550  (447-2818  Com. Riv )	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
c0bdd4cf-04dd-4e72-bcca-94702bc07659	ARGENOVA IV	02157	1140	49f1a6b1-610e-4aab-98e6-45dbe753fe22	\N	\N	0	36.26	675	caf4d1b5-7a3c-445b-98f9-42d842f1d347	MAR DE LAS PALMAS  S.A.	Puerto Deseado	4808331/4808332	0297-487-2112	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
2b322642-6036-4618-a0a5-d051ae81575b	ARGENOVA X	02329	1146	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	32.50	550	caf4d1b5-7a3c-445b-98f9-42d842f1d347	ARGENOVA  S.A.	Puerto Deseado	4808331/4808332	0297- 487-0550  (447-2818  Com. Riv )	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
fa96fa93-c2e4-4b2a-b3ef-b57af70149ff	ARGENOVA XI	02199	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	300e8934-6a93-46e3-a1b9-1e48cf0b8d91	\N	60	\N	\N	caf4d1b5-7a3c-445b-98f9-42d842f1d347	ARGENOVA  S.A.	Puerto Deseado	4808331/4808332	0297- 487-0550  (447-2818  Com. Riv )	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
81d1eda7-b157-4fee-a647-8bce8e62efbc	ARGENOVA XXI	02661	2704	49f1a6b1-610e-4aab-98e6-45dbe753fe22	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	60	55.80	1826	caf4d1b5-7a3c-445b-98f9-42d842f1d347	ARGENOVA  S.A.	Puerto Deseado	4808331/4808332	0297- 487-0550  (447-2818  Com. Riv )	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
0908ae91-387f-4e20-b9ba-dfa7f9ad09cc	ARGENOVA XXII	02714	2713	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	40	37.70	663	caf4d1b5-7a3c-445b-98f9-42d842f1d347	ARGENOVA  S.A.	Puerto Deseado	4808331/4808332	0297- 487-0550  (447-2818  Com. Riv )	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
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
426cfd83-e5ac-4d02-a611-f1b4d445321f	ATLANTIC SURF III	02030	1176	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	60	49.60	3020	1fcba1f2-fbf3-4489-b379-286b21f99fd8	GLACIAR PESQUERA  S.A.	Mar del Plata	4800274	492-2216	\N	amalfitanoycia@hotmail.com	\N	\N	Agencia Maritima Almafitano	t	\N	\N	\N
969e6d80-f91a-422a-b8c8-949b3b8a2834	ATREVIDO	0145	1180	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	32.50	901	1fcba1f2-fbf3-4489-b379-286b21f99fd8	PESQUERA VERAZ  S.A.	Mar del Plata	4800005	489-4624 / 489-0314 (astillero)	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
10a7186d-32e2-40df-9932-bc8537990e82	AURORA	02581	1183	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	67.55	1776	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	KALEU KALEU  S.A.	Ciudad Autónoma de Buenos Aires		011-3220-2130  / 5093-1215	\N		\N	\N		t	\N	\N	\N
4e4d1f9d-b0bb-4c65-bdbf-1ed65d088ef7	BAHIA DESVELOS	0665	1194	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	37.05	791	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	PESQUERA SANTA CRUZ  S.A.	Ciudad Autónoma de Buenos Aires		011-4305-4706	\N		\N	\N		t	\N	\N	\N
c60bbd03-6503-4701-8443-484730125747	BEAGLE I	6052	1207	49f1a6b1-610e-4aab-98e6-45dbe753fe22	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	60	59.90	2369	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	YUKEN  S.A.	Ciudad Autónoma de Buenos Aires	4891553-154179360-154179860-154179062	011-5279-1302 / 5236-6069	\N	agenciasmiriglio@speedy.com.ar	\N	\N	Agencia Maritima Smiriglio	t	\N	\N	\N
93ea79b9-2283-45f0-9bee-21845a075b8c	BELVEDERE	01398	1210	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	26.50	624	1fcba1f2-fbf3-4489-b379-286b21f99fd8	PRINMAR  S.A. Buque Motor Belvedere	Mar del Plata		480-0883	\N		\N	\N		t	\N	\N	\N
0e5a84f9-45f0-4d7c-b7bd-81fdbb7de7b5	BOGAVANTE SEGUNDO	02994	2743	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	37.45	867	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	IBERCONSA  DE ARGENTINA  S.A.	Puerto Madryn		0280-445-4324	\N		\N	\N		t	\N	\N	\N
f530b4d0-c72b-4996-96ce-8ecc023ab449	BONFIGLIO	01234	\N	f66f75bd-9f71-42a6-a319-b9aecc608960	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	10	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	COSTA BRAVA  S.A.	Mar del Plata		489-7538	\N		\N	\N		t	\N	\N	\N
085e7f6e-76d0-4d5f-832d-effe37c5d917	BORRASCA	01095	1218	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	39.16	1083	1fcba1f2-fbf3-4489-b379-286b21f99fd8	LUIS SOLIMENO e HIJOS  S.A.	Mar del Plata		489-3030	\N		\N	\N		t	\N	\N	\N
6fca97ec-0390-4cbd-8bea-5a5eb55d4f68	BOUCIÑA	01637	1221	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	0.00	0	1fcba1f2-fbf3-4489-b379-286b21f99fd8	CALME  S.A.	Mar del Plata	4800005	480-3545	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
1a0f8d33-c677-48ca-bf94-491becf8a784	BUENA PESCA	01475	2717	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	39.10	1479	1fcba1f2-fbf3-4489-b379-286b21f99fd8	PEDRO MOSCUZZA e HIJOS  S.A.	Mar del Plata		489-7287	\N		\N	\N		t	\N	\N	\N
265e4a7c-c48c-43d2-b61b-c22b3d9c5cf1	CABO BUEN TIEMPO	025	\N	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	\N	\N	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	ALPESCA  S.A.	Puerto Madryn		0280-447-4958 / 45-1069	\N		\N	\N		t	\N	\N	\N
23d92d9c-14bd-41ef-a80d-bd7e2f5bee89	CABO BUENA ESPERANZA	02482	\N	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	UNIVERSAL PESQUERA  SRL	Mar del Plata		489-0352	\N		\N	\N		t	\N	\N	\N
b45a9d14-7cfd-4a5a-b26d-205cd7156bd4	CABO DE HORNOS	01537	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	MILANI Y PATANE  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
fc349989-a6ac-457f-ab01-039ab2c125a4	CABO DOS BAHIAS	02483	\N	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	\N	\N	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	ALPESCA  S.A.	Puerto Madryn		0280-447-4958 / 45-1069	\N		\N	\N		t	\N	\N	\N
dcc7d145-13ad-4767-aea6-e155c05d28e6	CABO SAN JUAN	023	\N	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	\N	\N	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	ALPESCA  S.A.	Puerto Madryn		0280-447-4958 / 45-1069	\N		\N	\N		t	\N	\N	\N
6599cc72-c443-4661-b458-e92c44d74d80	CABO SAN SEBASTIAN	022	\N	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	\N	\N	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	ALPESCA  S.A.	Puerto Madryn		0280-447-4958 / 45-1069	\N		\N	\N		t	\N	\N	\N
1b129670-e1bc-4f2f-8234-13642269cc2f	CABO TRES PUNTAS	01483	1242	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	31.43	721	1fcba1f2-fbf3-4489-b379-286b21f99fd8	OSTRAMAR  S.A.	Mar del Plata		489-1959	\N		\N	\N		t	\N	\N	\N
23c739e6-2bfd-489a-8cb7-e945122618b6	CABO VIRGENES	024	\N	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	\N	\N	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	ALPESCA  S.A.	Puerto Madryn		0280-447-4958 / 45-1069	\N		\N	\N		t	\N	\N	\N
4469c68f-354e-477e-a214-e48a125856ad	CALABRIA	0567	1245	f66f75bd-9f71-42a6-a319-b9aecc608960	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	4	19.63	266	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
57a95a06-a15c-4077-b1e9-9d72d1a2eedf	CALIZ	02809	0	f66f75bd-9f71-42a6-a319-b9aecc608960	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	4	20.20	545	cd0af388-5ae6-4ed0-9de5-f8f5a375bf43	FLOTA AMARILLA RAWSON	Rawson			\N		\N	\N		t	\N	\N	\N
c98a4fc8-55be-4d6f-a480-ed8d568e411a	CALLEJA	06276	1249	f66f75bd-9f71-42a6-a319-b9aecc608960	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	10	21.83	503	1fcba1f2-fbf3-4489-b379-286b21f99fd8	OTESA  S.A.	Mar del Plata		493-5606	\N		\N	\N		t	\N	\N	\N
4dbb105c-5692-489f-a72f-f0663bfbc636	CAMERIGE	01406	1252	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	27.90	652	1fcba1f2-fbf3-4489-b379-286b21f99fd8	PESQUERA  MARGARITA  S.A.	Mar del Plata	4891553-154179360-154179860-154179062	489-4645   /   489-2946	\N	agenciasmiriglio@speedy.com.ar	\N	\N	Agencia Maritima SMIRIGLIO	t	\N	\N	\N
04ef6c17-430b-458f-af48-8535a75b9cef	CANAL DE BEAGLE	0407	0	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	23.90	501	1fcba1f2-fbf3-4489-b379-286b21f99fd8	CANAL DE BEAGLE  S.R.L.	Mar del Plata		480-4447	\N		\N	\N		t	\N	\N	\N
6ddb602a-7854-408e-8674-0e787933e02e	CAPESANTE	02929	2723	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	40	50.15	2550	1fcba1f2-fbf3-4489-b379-286b21f99fd8	GLACIAR PESQUERA  S.A.	Mar del Plata		492-2216	\N		\N	\N		t	\N	\N	\N
1ba7d424-8eb5-441c-9378-7228459c0bd6	CAPITAN CANEPA	059F	\N	3396a7a4-5c2b-473e-93a2-d66105f78818	\N	\N	28	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	INIDEP	Mar del Plata		451-7442 ó 486-2586 int 162	\N		\N	\N		t	\N	\N	\N
2cf99b92-4312-42b1-a198-38bdad313ab9	CAPITAN GIACHINO	0151	1260	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	38.42	1062	1fcba1f2-fbf3-4489-b379-286b21f99fd8	KALARI S.A.	Mar del Plata		489-1959	\N		\N	\N		t	\N	\N	\N
1f19a85a-f85f-4e9f-98c5-4d4fc63fbb1a	CAPITAN OCA BALDA	060F	\N	3396a7a4-5c2b-473e-93a2-d66105f78818	\N	\N	21	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	INIDEP	Mar del Plata		451-7442 ó 486-2586 int 162	\N		\N	\N		t	\N	\N	\N
65a6ccda-583d-4964-86d4-eba8bc1b0a96	CARMEN A	02045	1269	f66f75bd-9f71-42a6-a319-b9aecc608960	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	4	15.30	223	cd0af388-5ae6-4ed0-9de5-f8f5a375bf43	FLOTA AMARILLA RAWSON	Rawson			\N		\N	\N		t	\N	\N	\N
49403073-bf7a-4a08-a982-83cadd8199e4	CAROLINA P	0176	1272	49f1a6b1-610e-4aab-98e6-45dbe753fe22	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	60	71.60	1976	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	ESTRELLA PATAGONICA S.A.	Puerto Madryn		0280-445-4407	\N		\N	\N		t	\N	\N	\N
0d61bf64-5c2a-4bde-b6be-7eb21322c18c	CEIBE DOUS	0336	1276	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	40.70	738	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	IBERCONSA  DE ARGENTINA  S.A.	Puerto Madryn	4800274	0280-445-4324	\N	amalfitanoycia@hotmail.com	\N	\N	Agencia Maritima Almafitano	t	\N	\N	\N
b6c82a60-965d-4e57-bf7e-9d1a4a9347bc	CENTAURO 2000	0482	1278	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	35.50	1302	1fcba1f2-fbf3-4489-b379-286b21f99fd8	PESQUERA VERAZ  S.A.	Mar del Plata		489-4624 / 489-0314 (astillero)	\N		\N	\N		t	\N	\N	\N
c050a1a6-e49a-4c1f-ac75-900a7e53e028	CENTURION DEL ATLANTICO	0237	1280	49f1a6b1-610e-4aab-98e6-45dbe753fe22	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	60	112.80	8111	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	ESTREMAR  S.A.	Ciudad Autónoma de Buenos Aires		011-6533-7853 / 4345-1102	\N		\N	\N		t	\N	\N	\N
423261e8-4005-4600-a12e-852c05665a73	CERES	01420	1281	49f1a6b1-610e-4aab-98e6-45dbe753fe22	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	60	60.74	1969	1fcba1f2-fbf3-4489-b379-286b21f99fd8	PESQUERA CERES  S.A.	Mar del Plata		410-0051 / 7	\N		\N	\N		t	\N	\N	\N
25827820-4252-4853-a503-16daf2fd754c	CHANG BO GO I	06190	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	\N	\N	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	ARPEPA  M.C.I.S.A.	Ciudad Autónoma de Buenos Aires		011-4382-1605	\N		\N	\N		t	\N	\N	\N
b20c00dd-0fb6-4ab3-911a-9bd509927f2e	CHATKA I	02893	0	f66f75bd-9f71-42a6-a319-b9aecc608960	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	16.73	195	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	FOOD PARTNERS PATAGONIA S.A.	Puerto Madryn		0280-4458579 / 5225	\N		\N	\N		t	\N	\N	\N
aeeb2a4a-d802-404e-9d41-b35db13931c1	CHIARPESCA 56	01090	\N	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	APOLO FISH  S.A.	Mar del Plata		489-4519 / 489-1133	\N		\N	\N		t	\N	\N	\N
67d778f8-96db-4ec6-aa48-b979b0bc4958	CHIARPESCA 57	01029	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	CHIARPESCA  S.A.	Mar del Plata		489-1385	\N		\N	\N		t	\N	\N	\N
ede6e3ad-9b2a-49a3-a480-b1cd9631fca7	CHIARPESCA 902	02110	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	CHIARPESCA  S.A.	Mar del Plata		489-1385	\N		\N	\N		t	\N	\N	\N
a01f0bab-1dd6-43ff-9906-f8edc3d106af	CHIARPESCA 903	02109	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	CHIARPESCA  S.A.	Mar del Plata		489-1385	\N		\N	\N		t	\N	\N	\N
e113b2d7-af93-44fe-a26e-805429efdd48	CHIYO MARU Nº 3	02987	2745	49f1a6b1-610e-4aab-98e6-45dbe753fe22	d08faf9b-60a9-4081-b8ea-ca931995905b	\N	30	52.80	937	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	CRUSTACEOS DEL SUR  S.A.	Ciudad Autónoma de Buenos Aires		011-5218-4287	\N		\N	\N		t	\N	\N	\N
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
5fd4a0cb-baa8-4564-8b6a-99ae7889fc84	CODEPECA  III	0506	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	\N	\N	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	HARENGUS  S.A.	Puerto Madryn		0280-445-0822	\N		\N	\N		t	\N	\N	\N
9fd799e3-d024-47e6-b4f0-29f37450382b	CODEPECA IV	01012	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	\N	\N	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	PEREIRA  ARGENTINA  S.A.	Puerto Madryn		0280-445-7377 / 447-2249	\N		\N	\N		t	\N	\N	\N
7087bf7d-c1ff-4526-9f02-9bf33eb71f27	COMANDANTE LUIS PIEDRABUENA	0767	1340	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	25.00	501	1fcba1f2-fbf3-4489-b379-286b21f99fd8	COMANDANTE PIEDRABUENA  S.R.L.	Mar del Plata		489-9404	\N		\N	\N		t	\N	\N	\N
6881aef2-f5ff-4b37-b44b-5b39c1a8be6b	COMETA	0919	\N	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	VICARP  S.A.	Mar del Plata		480-4378	\N		\N	\N		t	\N	\N	\N
3de792e0-7de2-4577-a0b1-3469e32c40eb	CONARA I	0201	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	\N	\N	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
c573e0fc-6f82-4795-bfcc-b49b981977d8	CONARPESA I	0200	1344	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	52.50	1482	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
e5719398-f949-41c9-9268-b67b742b59d1	CORAJE	0645	1359	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	\N	\N	0	28.28	426	1fcba1f2-fbf3-4489-b379-286b21f99fd8	IBERCONSA  DE ARGENTINA  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
015c5c41-8347-4827-a4ef-fe73818bd8b6	CORAL  AZUL	06127	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	\N	\N	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	NOVAMAR  S.A.	Ciudad Autónoma de Buenos Aires		011-4345-6688	\N		\N	\N		t	\N	\N	\N
9fdf6a75-862b-470b-8caf-f5d33d2b2ac3	CORAL BLANCO	06137	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	\N	\N	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	NOVAMAR  S.A.	Ciudad Autónoma de Buenos Aires		011-4345-6688	\N		\N	\N		t	\N	\N	\N
f60d04e0-755a-419c-8126-7e875b80ea31	CORMORAN	01611	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	ANTONIO BARILLARI  S.A.	Mar del Plata		481-1173  / 489-0872	\N		\N	\N		t	\N	\N	\N
1cde0ee8-8ca2-461c-adf9-d68b7479e48c	COSTAMAR	01549	\N	f66f75bd-9f71-42a6-a319-b9aecc608960	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	4	\N	\N	cd0af388-5ae6-4ed0-9de5-f8f5a375bf43	INDUSTRIA  PESQUERA  PATAGONICA  S.A.	Trelew		0280-444-6577	\N		\N	\N		t	\N	\N	\N
457bc788-29fa-4d6b-8c53-5b636bf873bb	CRISTO REDENTOR	01185	1374	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	31.00	642	caf4d1b5-7a3c-445b-98f9-42d842f1d347	PESQUERA DESEADO  S.A.	Puerto Deseado		0297-487-0884 / 0327 / 2407	\N		\N	\N		t	\N	\N	\N
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
95444611-ad7f-4532-a8cb-4e71b9dff4de	DON LUIS I	02093	1445	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	67.95	1803	1fcba1f2-fbf3-4489-b379-286b21f99fd8	PESQUERA CERES  S.A.	Mar del Plata		410-0051 / 7	\N		\N	\N		t	\N	\N	\N
ba81638e-3490-4417-9ae3-a5bbe69d5380	DON MIGUEL 1°	0748	\N	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	PESQUERA EL NAZARENO	Mar del Plata	4895032 Emanuel	489-9414 (of. Pers. Emb.)	\N	operacionesconsultoramaritima@gmail.com	\N	\N	Consultora Maritima Merlini	t	\N	\N	\N
7d826978-f5e8-4e9e-921e-9bbbd0018f4e	DON NICOLA	0893	1450	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	28.14	856	1fcba1f2-fbf3-4489-b379-286b21f99fd8	PEZ ESPADA  S.A.	Mar del Plata		480-0846	\N		\N	\N		t	\N	\N	\N
db2a744f-1cfb-49ca-82d9-11ba6d4d9f72	DON OSCAR	02184	\N	f66f75bd-9f71-42a6-a319-b9aecc608960	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	4	\N	\N	cd0af388-5ae6-4ed0-9de5-f8f5a375bf43	FLOTA AMARILLA RAWSON	Rawson	4800005		\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
ce349711-474f-4bad-b14e-0be248aaa348	DON PEDRO	068	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	60	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	PEDRO MOSCUZZA e HIJOS  S.A.	Mar del Plata		489-7287	\N		\N	\N		t	\N	\N	\N
b70f3781-843e-4cf8-b58b-6783a97bb095	DON RAIMUNDO	01431	1463	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	10	25.60	624	1fcba1f2-fbf3-4489-b379-286b21f99fd8	DON RAIMUNDO S.R.L.	Mar del Plata		489-3780	\N		\N	\N		t	\N	\N	\N
165bcdc5-8cf1-46b9-9cac-7772d63617fa	DON ROMEO ERSINI	0972	\N	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	PESQUERA  MARGARITA  S.A.	Mar del Plata	4891553-154179360-154179860-154179062	489-4645   /   489-2946	\N	agenciasmiriglio@speedy.com.ar	\N	\N	Agencia Smiriglio	t	\N	\N	\N
9a2759e2-5da5-4b77-9464-0dc62ce3ca3a	DON SANTIAGO	01733	1467	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	10	26.55	776	1fcba1f2-fbf3-4489-b379-286b21f99fd8	SAN JORGE S.A.	Mar del Plata		480-6611	\N		\N	\N		t	\N	\N	\N
3f581973-0ceb-43a2-b0bf-8e927c92da15	DON TOMASSO	02310	1468	f66f75bd-9f71-42a6-a319-b9aecc608960	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	4	17.00	356	cd0af388-5ae6-4ed0-9de5-f8f5a375bf43	FLOTA AMARILLA RAWSON	Rawson			\N		\N	\N		t	\N	\N	\N
156c0556-bfbd-430a-9af4-2ff028fd3ff7	DON TURI	01540	1470	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	28.62	839	1fcba1f2-fbf3-4489-b379-286b21f99fd8	DON TURI  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
3b42c010-7873-44e5-a59f-6b9e765f8858	DON VICENTE VUOSO	0539	1474	f66f75bd-9f71-42a6-a319-b9aecc608960	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	20.69	537	1fcba1f2-fbf3-4489-b379-286b21f99fd8	VUOSO HNOS. S.R.L.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
da9a5317-3e17-4448-b336-2f895abdbb57	DOÑA ALFIA	0512	1483	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	20.70	426	1fcba1f2-fbf3-4489-b379-286b21f99fd8	ANTONIO BARILLARI  S.A.	Mar del Plata		481-1173  / 489-0872	\N		\N	\N		t	\N	\N	\N
86cb60b4-8b15-43cb-906c-4fe6aa848536	Dr. EDUARDO L. HOLMBERG	061F	\N	3396a7a4-5c2b-473e-93a2-d66105f78818	\N	\N	24	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	INIDEP	Mar del Plata		451-7442 ó 486-2586 int 162	\N		\N	\N		t	\N	\N	\N
395ed19d-038a-42c9-95cc-db61a21fdb8b	DUKAT	02775	2712	49f1a6b1-610e-4aab-98e6-45dbe753fe22	d08faf9b-60a9-4081-b8ea-ca931995905b	\N	30	50.80	1302	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	CRUSTACEOS DEL SUR  S.A.	Ciudad Autónoma de Buenos Aires		011-5218-4287	\N		\N	\N		t	\N	\N	\N
5d2e398a-7f96-4c2b-a455-58da21ceb1ff	ECHIZEN MARU	0326	1495	49f1a6b1-610e-4aab-98e6-45dbe753fe22	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	60	89.59	4702	86f70064-a55b-4d55-b7e9-dc3f320c4cc1	PESANTAR  S.A. ( Empresa Pesq de la Patagonia y Antartida )	Ushuaia		02901-43-3449 / 43-0008 / 43-0708	\N		\N	\N		t	\N	\N	\N
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
06f76a6f-dd4e-490c-b6a2-ee9a8ebcff3d	ERIN BRUCE II	TEMP-0002	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	\N	\N	\N	\N					\N		\N	\N		t	\N	\N	\N
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
b5419915-4b1e-4211-b893-83ef2be10f94	FLORIDABLANCA	0969	1606	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	27.67	541	1fcba1f2-fbf3-4489-b379-286b21f99fd8	DESAFIO  S.A.	Mar del Plata		489-4788 / 3659	\N		\N	\N		t	\N	\N	\N
f1b96873-e1bc-4b6f-ac98-3469f80c11b9	FLORIDABLANCA II	0252	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	\N	\N	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	PESQUERA SAN ISIDRO S.A.	Puerto Madryn		0280-447-2697	\N		\N	\N		t	\N	\N	\N
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
87afbf66-fc82-4da0-b100-c684b3c2a26c	HOPE N°7	06130	1690	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	50.60	1235	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	ALUNAMAR  S.A.	Ciudad Autónoma de Buenos Aires	4808331/4808332	011-4382-4194	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
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
31c276f1-b1c1-4d4e-a759-c8f3fc0c524e	INARI MARU N° 25	0261	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	\N	\N	caf4d1b5-7a3c-445b-98f9-42d842f1d347	ARGENOVA  S.A.	Puerto Deseado		0297- 487-0550  (447-2818  Com. Riv )	\N		\N	\N		t	\N	\N	\N
245967fa-767b-4b92-b2c1-a918ecd2c6de	INFINITUS PEZ	01472	\N	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	GIORNO  S.A.	Mar del Plata		410-0051 / 0057	\N		\N	\N		t	\N	\N	\N
6f610ae6-493c-4727-9a40-bd9960b3847d	INITIO PEZ	01471	\N	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	GIORNO  S.A.	Mar del Plata	4800005	410-0051 / 0057	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi	t	\N	\N	\N
c2a51fd6-0460-44a8-a592-31d65e1f29da	ITXAS LUR	0927	1735	49f1a6b1-610e-4aab-98e6-45dbe753fe22	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	60	63.30	1952	1fcba1f2-fbf3-4489-b379-286b21f99fd8	HISPANO PATAGONICA  S.A.	Mar del Plata		480-1002 / 489-3165 / 489-7144	\N		\N	\N		t	\N	\N	\N
3967f385-ee48-4f56-b494-57fc38f13c95	JOLUMA	5403	\N	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	ARDAPEZ  S.A.	Mar del Plata	4800005	480-1561 / 480-1568 / 480-1549	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
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
7e6c1aa0-8f0f-46e8-bdba-ca457b1a412b	MAR MARÍA	02960	2738	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	37.80	1248	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	PESQUERA SANTA CRUZ  S.A.	Ciudad Autónoma de Buenos Aires		011-4305-4706	\N		\N	\N		t	\N	\N	\N
b46fa8fa-76ee-4d66-84cf-8281ae74a0ac	MAR NOVIA 1	0115	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	\N	\N	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	CINCOMAR  S.A.	Ciudad Autónoma de Buenos Aires		011-4326-4991	\N		\N	\N		t	\N	\N	\N
3b031577-2980-480a-9c2d-bdbe641bab05	MAR NOVIA 2	0116	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	\N	\N	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	MIREMAR  S.A.	Ciudad Autónoma de Buenos Aires		011-4328-4963 / 4	\N		\N	\N		t	\N	\N	\N
a238d7c1-4298-4edc-8b8c-7e27d840596f	MAR SUR	0341	1957	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	36.40	889	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	PESCARGEN  S.A.	Ciudad Autónoma de Buenos Aires		011-5219-0065 ó 5276-9499	\N		\N	\N		t	\N	\N	\N
f55fd163-11e1-40a9-b274-4c80aff18783	MARA I	0210	1960	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	35.31	1209	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	PESCAPUERTA ARGENTINA  S.A.	Puerto Madryn		0280-445-4407	\N		\N	\N		t	\N	\N	\N
d5defbe0-a4e6-4689-9fb4-8860c0afe3ef	MARA II	0209	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	\N	\N	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	PESCAPUERTA ARGENTINA  S.A.	Puerto Madryn		0280-445-4407	\N		\N	\N		t	\N	\N	\N
181e7503-d6e5-4060-922b-239b8dca9336	MARBELLA	01073	1966	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	27.38	736	1fcba1f2-fbf3-4489-b379-286b21f99fd8	MAR DE MESSINA  S.A.	Mar del Plata	beagle1	489-3824	\N		\N	\N		t	\N	\N	\N
fcca0d71-abbd-43b5-a422-d10b7bafcf41	MARCALA I	0532	\N	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	PESANFLOR  S.A.	Mar del Plata		489-6522	\N		\N	\N		t	\N	\N	\N
890e1f52-2fa9-48b9-a234-01ff702b60fa	MARCALA IV	0351	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	\N	\N	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	MARCALA  S.A.	Ciudad Autónoma de Buenos Aires		011-4342-9601 / 4283	\N		\N	\N		t	\N	\N	\N
6d3124ba-8ec1-44a3-a454-4447fa10485f	MAREJADA	01107	1974	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	27.98	624	1fcba1f2-fbf3-4489-b379-286b21f99fd8	VICARP  S.A.	Mar del Plata		480-4378	\N		\N	\N		t	\N	\N	\N
870dedfd-77b2-4f0a-a0ab-238b23c8a0b6	MARGOT	0360	1976	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	58.75	1481	1fcba1f2-fbf3-4489-b379-286b21f99fd8	GIORNO  S.A.	Mar del Plata	4800005	410-0051 / 0057	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
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
fc67a193-73d3-42e6-9aa7-7811e559cbfb	MINTA	02196	2050	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	65.10	1603	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	LIYA  S.A.	Ciudad Autónoma de Buenos Aires		011-4964-2227	\N		\N	\N		t	\N	\N	\N
d3650f8f-6435-4739-a710-f32bc1b71cce	MIRIAM	0370	2051	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	36.35	1446	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	VIEIRA ARGENTINA  S.A.	Ciudad Autónoma de Buenos Aires	4800005		\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi	t	\N	\N	\N
1cbcf1ac-fad5-4221-bb01-d5f5e155eb0d	MISHIMA MARU N°8	02175	2054	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	63.43	1579	1fcba1f2-fbf3-4489-b379-286b21f99fd8	BAL - FISH  S.A.	Mar del Plata	4800274	489-6522	\N	amalfitanoycia@hotmail.com	\N	\N	Agencia Maritima Almafitano	t	\N	\N	\N
c991a706-a3dd-4ca3-8bbe-e5cf884dea37	MISS PATAGONIA	0555	2055	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	28.20	667	1fcba1f2-fbf3-4489-b379-286b21f99fd8	PESQUERA VERAZ  S.A.	Mar del Plata	4805743	489-4624 / 489-0314 (astillero)	\N	agenciadiyorio@hotmail.com -joseph@hotmail.com	\N	\N	Agencia Di Yorio	t	\N	\N	\N
f494b1f2-975d-458d-8b0e-21f1e7540a83	MISS TIDE	02439	2056	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	52.52	2254	1fcba1f2-fbf3-4489-b379-286b21f99fd8	WANCHESE ARGENTINA  S.A.	Mar del Plata		489-1236	\N		\N	\N		t	\N	\N	\N
f6667e6a-9e1a-4363-85fb-0085fc9cbe6d	MISTER BIG	0534	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	WANCHESE ARGENTINA  S.A.	Mar del Plata		489-1236	\N		\N	\N		t	\N	\N	\N
9daac8a4-b456-4ae3-beb9-e0f1798c2a9f	MIURA MARU	05996	2058	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	53.20	1482	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	LIYA  S.A.	Ciudad Autónoma de Buenos Aires		011-4964-2227	\N		\N	\N		t	\N	\N	\N
b890a64d-53e1-475c-a242-257a29f1e941	MONTE DE VIOS	0664	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	\N	\N	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	PESQUERA SANTA CRUZ  S.A.	Ciudad Autónoma de Buenos Aires		011-4305-4706	\N		\N	\N		t	\N	\N	\N
7f9a5d2b-27ed-454f-b220-1d59dd6b3805	MYRDOMA F	02771	2735	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	38.55	1430	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	LANZAR S.A.	Puerto Madryn	4800005	0280-445-6280	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
f1e3eb78-7a87-4045-91ab-034c7e866639	NANINA	02576	2073	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	72.08	1678	1fcba1f2-fbf3-4489-b379-286b21f99fd8	PEDRO MOSCUZZA e HIJOS  S.A.	Mar del Plata	4800005	489-7287	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
1c20a49a-26af-427b-bb3e-14962058c07d	NATALIA	02066	2075	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	68.45	1779	1fcba1f2-fbf3-4489-b379-286b21f99fd8	PEDRO MOSCUZZA e HIJOS  S.A.	Mar del Plata		489-7287	\N		\N	\N		t	\N	\N	\N
dea66f59-f910-4e72-a9c5-fb138412be0c	NAVEGANTES	0542	2079	49f1a6b1-610e-4aab-98e6-45dbe753fe22	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	60	58.00	1925	1fcba1f2-fbf3-4489-b379-286b21f99fd8	PESQUERA COMERCIAL  S.A.	Mar del Plata		489-3030	\N		\N	\N		t	\N	\N	\N
babbdc2b-f878-45cc-a161-615a14d43817	NAVEGANTES II	01451	2080	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	63.70	1603	1fcba1f2-fbf3-4489-b379-286b21f99fd8	PESQUERA COMERCIAL  S.A.	Mar del Plata		489-3030	\N		\N	\N		t	\N	\N	\N
794029cb-c7d3-4d57-9d44-625a11b6da5d	NAVEGANTES III	02065	2081	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	68.60	2203	1fcba1f2-fbf3-4489-b379-286b21f99fd8	PESQUERA COMERCIAL  S.A.	Mar del Plata	4800274	489-3030	\N	amalfitanoycia@hotmail.com	\N	\N	Agencia Maritima Almafitano	t	\N	\N	\N
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
dfb82b3d-f29c-4383-b9ad-d5b5b97fbd9c	PATAGONIA BLUES	02176	2199	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	64.45	1776	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	PESQUERA CRUZ DEL SUR  S.A.	Ciudad Autónoma de Buenos Aires		011-4784-1760	\N		\N	\N		t	\N	\N	\N
43b2abc2-ba48-41e1-8c89-a7d200779999	PEDRITO	TEMP-0005	0	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	\N	39.92	1201	\N					\N		\N	\N		t	\N	\N	\N
9f8b92e7-325c-434b-9a65-63dcb9b688f2	PELAGOS	83	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	\N	\N	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	PESQUERA SAN ISIDRO S.A.	Puerto Madryn		0280-447-2697	\N		\N	\N		t	\N	\N	\N
4e513b95-7afc-4d99-bcf6-a10303612582	PENSACOLA I	0747	2207	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	25.20	380	9b892e55-acb6-4574-802b-8058aaecd464	FRANGELA  S.A.	Comodoro Rivadavia			\N		\N	\N		t	\N	\N	\N
683feb34-b7a4-41b9-982f-bacbe9a47d1c	PESCAPUERTA CUARTO	0171	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	60	\N	\N	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	PESCAPUERTA ARGENTINA  S.A.	Puerto Madryn		0280-445-4407	\N		\N	\N		t	\N	\N	\N
e53c41ef-bf9f-4b16-8f2c-9fec0d57fa08	PESCAPUERTA QUINTO	0538	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	60	\N	\N	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	PESCAPUERTA ARGENTINA  S.A.	Puerto Madryn		0280-445-4407	\N		\N	\N		t	\N	\N	\N
04138de3-b5dc-4f04-9cc3-c8be2dfac6f5	PESCARGEN  V	078	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	60	\N	\N	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	PESCARGEN  S.A.	Ciudad Autónoma de Buenos Aires		011-5219-0065 ó 5276-9499	\N		\N	\N		t	\N	\N	\N
f89d1892-cda1-4784-9dd0-53a36d256388	PESCARGEN III	021	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	60	\N	\N	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	PESCARGEN  S.A.	Ciudad Autónoma de Buenos Aires		011-5219-0065 ó 5276-9499	\N		\N	\N		t	\N	\N	\N
7a967f63-fd3b-4de7-b42f-8f3e7b6ecdfa	PESCARGEN IV	0150	2217	49f1a6b1-610e-4aab-98e6-45dbe753fe22	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	60	63.20	1603	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	PESCARGEN  S.A.	Ciudad Autónoma de Buenos Aires		011-5219-0065 ó 5276-9499	\N		\N	\N		t	\N	\N	\N
be04b4aa-4adb-414c-a9db-caa03ab783e1	PESPASA  II	0212	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	\N	\N	caf4d1b5-7a3c-445b-98f9-42d842f1d347	PESPASA  S.A.	Puerto Deseado		0297-487-2030  int 12	\N		\N	\N		t	\N	\N	\N
2607d89b-3aeb-4d25-909b-533e141567f4	PESPASA I	0211	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	\N	\N	caf4d1b5-7a3c-445b-98f9-42d842f1d347	PESPASA  S.A.	Puerto Deseado		0297-487-2030  int 12	\N		\N	\N		t	\N	\N	\N
286e184f-f348-4192-9451-8b90b240a5eb	PETREL	01445	2224	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	29.85	776	1fcba1f2-fbf3-4489-b379-286b21f99fd8	OLAMAR  S.A.	Mar del Plata		480-3573	\N		\N	\N		t	\N	\N	\N
0ebd24e9-16e9-4719-91ef-9126af868667	PEVEGASA QUINTO	02312	2225	49f1a6b1-610e-4aab-98e6-45dbe753fe22	08c82cf9-7632-48ff-bc68-de0f882f16bb	\N	30	38.65	740	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	PUNTA BUSTAMANTE  S.A.	Ciudad Autónoma de Buenos Aires		011-4305-4710 / 4712	\N		\N	\N		t	\N	\N	\N
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
75d3b3de-18bc-4b24-ad47-27c52b1d6964	RYOUN MARU N° 17	JA06-03	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	\N	\N	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	BAHIA GRANDE  S.A.	Ciudad Autónoma de Buenos Aires	4891553-154179360-154179860-154179062	011-5272-0850 / 5254-1133	\N	agenciasmiriglio@speedy.com.ar	\N	\N	Agencia Maritima Smiriglio	t	\N	\N	\N
d196c4c4-f01d-4915-8318-764e7e9f41cb	SALVADOR R	02755	2761	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	27.73	420	1fcba1f2-fbf3-4489-b379-286b21f99fd8	URBIPEZ  S.A.	Mar del Plata		4892793	\N		\N	\N		t	\N	\N	\N
df895f92-b1d9-4214-a045-b4983208793c	SAN ANDRES APOSTOL	0569	2340	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	54.56	2269	1fcba1f2-fbf3-4489-b379-286b21f99fd8	PESANFLOR  S.A.	Mar del Plata		489-6522	\N		\N	\N		t	\N	\N	\N
7aa26773-24b0-4b2e-8a47-cc889fe6b2e4	SAN ANTONINO	0375	\N	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	SEA FISH  S.A.	Mar del Plata	51-11-65337853	480-0336	\N		\N	\N	Natalia Cedrato	t	\N	\N	\N
9b521dd3-43c9-4aa5-b948-7d6356cf1930	VALERIA DEL ATLÁNTICO	02098	2346	49f1a6b1-610e-4aab-98e6-45dbe753fe22	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	60	56.46	4698	1fcba1f2-fbf3-4489-b379-286b21f99fd8	SAN ARAWA  S.A.	Mar del Plata		492-2216 / 492-0450	\N		\N	\N		t	\N	\N	\N
cd42dafe-91fe-4ae2-9155-54de3fbe405b	SAN BENEDETTO	02643	0	f66f75bd-9f71-42a6-a319-b9aecc608960	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	8	15.38	220	1fcba1f2-fbf3-4489-b379-286b21f99fd8	PESQUERA SAN BENEDETTO  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
f1d98157-0e52-4af2-aeae-9ff6480f6f60	SAN GENARO	0763	\N	f66f75bd-9f71-42a6-a319-b9aecc608960	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	10	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	LESAUMON  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
4a0d4c08-b929-4075-a17c-0a0d479f4cc4	SAN JUAN B	TEMP-0007	2780	49f1a6b1-610e-4aab-98e6-45dbe753fe22	\N	\N	\N	39.94	1204	\N					\N		\N	\N		t	\N	\N	\N
c6da883f-378e-473f-ab46-597ab6d5773a	SAN JORGE MARTIR	02152	2367	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	56.10	1408	1fcba1f2-fbf3-4489-b379-286b21f99fd8	PESANFLOR  S.A.	Mar del Plata		489-6522	\N		\N	\N		t	\N	\N	\N
97138bee-8f63-480e-af13-49235d5049c5	SAN LUCAS  I	06147	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	\N	\N	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	AGUA MARINA  S.A.	Ciudad Autónoma de Buenos Aires		011-4342-0605 / 5656 / 1709	\N		\N	\N		t	\N	\N	\N
5de9cbc1-43c3-46cb-8657-1dfa307a71f3	SAN MATEO	06306	0	f66f75bd-9f71-42a6-a319-b9aecc608960	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	54.10	1234	cd0af388-5ae6-4ed0-9de5-f8f5a375bf43	IBERPESCA  S.A.	Rawson		0280-449-8176	\N		\N	\N		t	\N	\N	\N
c237adcf-f4c0-4601-a110-f0cddcaff8b6	SAN MATIAS	0289	\N	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	PESCA  ANTIGUA  S.A.	Mar del Plata		489-2340	\N		\N	\N		t	\N	\N	\N
9415a9ed-f9cd-42cf-872f-40a40acefeb2	SAN PABLO	0759	\N	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	PRODUCTORA ARGEN-PESCA  S.A.	Mar del Plata		480-1444	\N		\N	\N		t	\N	\N	\N
907f78a8-930a-4c68-8a7b-7b029003d56f	SAN PASCUAL	0367	\N	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	BUENOS AIRES PESCA  S.A.	Mar del Plata		489-6522	\N		\N	\N		t	\N	\N	\N
df4b2b60-09d8-4dba-8b57-4053b41d0015	SAN PEDRO APOSTOL	01975	\N	f66f75bd-9f71-42a6-a319-b9aecc608960	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	10	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	GAAD GROUP S.A.	Mar del Plata		480-9327	\N		\N	\N		t	\N	\N	\N
a3bd5d75-837b-4be8-8612-05a43c2cc28a	SANT ANTONIO	0974	\N	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	A.B.H. PESQUERA  S.A.	Mar del Plata	4895032	489-6522	\N	operacionesconsultoramaritima@gmail.com.ar	\N	\N	Agencia Merlini	t	\N	\N	\N
fd1a9330-68f4-45ec-930b-2de226074742	SANTA BARBARA	5857	2409	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	56.96	1679	1fcba1f2-fbf3-4489-b379-286b21f99fd8	PESCA ANGELA  S.A.	Mar del Plata		626-2236 /37	\N		\N	\N		t	\N	\N	\N
563e1699-68ab-4423-8fab-ff0607af3558	SANTA ANGELA	009	\N	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	\N	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	OSTRAMAR  S.A.	Mar del Plata		489-1959	\N		\N	\N		t	\N	\N	\N
74116457-8192-4af0-bd4b-94c177c09c78	SANTIAGO  I	02280	\N	07f4f8be-5285-4459-9248-90da8b4f1729	\N	\N	0	\N	\N	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	FISHING WORLD  S.A.	Puerto Madryn		0280-445-6533	\N		\N	\N		t	\N	\N	\N
78a9b02e-953a-4fc7-b955-2169483d1537	SCIROCCO	2574	2430	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	65.93	1589	1fcba1f2-fbf3-4489-b379-286b21f99fd8	PESQUERA COMERCIAL  S.A.	Mar del Plata		489-3030	\N		\N	\N		t	\N	\N	\N
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
fa28ac74-fd00-4a3d-81a0-5fe3a44172c9	SIRIUS II	0936	2489	1eb2717f-2feb-4b54-9edd-2f52c095ce9f	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	30	59.25	1289	1fcba1f2-fbf3-4489-b379-286b21f99fd8	EL MARISCO  S.A.	Mar del Plata	4890960	489-0384	\N	agencia@maritimavidal.com.ar	\N	\N	Agencia Maritima Vidal	t	\N	\N	\N
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
01250855-bee5-42b0-afbf-a342b210ca79	TALISMAN	02263	2541	49f1a6b1-610e-4aab-98e6-45dbe753fe22	d08faf9b-60a9-4081-b8ea-ca931995905b	\N	30	49.95	1302	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	CENTOMAR  S.A.	Ciudad Autónoma de Buenos Aires		011-4816-6245 / 6260  int  * 35	\N		\N	\N		t	\N	\N	\N
e85d97cf-ab2e-4639-8168-2c1783e4273a	TANGO I	02724	2709	49f1a6b1-610e-4aab-98e6-45dbe753fe22	d08faf9b-60a9-4081-b8ea-ca931995905b	\N	30	50.40	1302	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	BENTONICOS DE ARGENTINA  S.A.	Ciudad Autónoma de Buenos Aires		011-5258-2400 / 4407-8240	\N		\N	\N		t	\N	\N	\N
963558b2-f1a1-462a-bb0c-e1c47eebb71b	TANGO II	02791	2714	49f1a6b1-610e-4aab-98e6-45dbe753fe22	d08faf9b-60a9-4081-b8ea-ca931995905b	\N	30	50.40	1302	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	BENTONICOS DE ARGENTINA  S.A.	Ciudad Autónoma de Buenos Aires	4891227	011-5258-2400 / 4407-8240	\N	serviciosmaritimosmdq@gmail.com	\N	\N	Servicios maritimos	t	\N	\N	\N
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
96658434-ad2a-473b-a532-d2afe15cb4d2	VENTARRON 1º	0479	2708	49f1a6b1-610e-4aab-98e6-45dbe753fe22	989ce1c1-31ae-4374-abc8-cd39ccc23254	\N	60	63.07	1969	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	ATUNERA  ARGENTINA  S.A.	Puerto Madryn		0280-445-4324	\N		\N	\N		t	\N	\N	\N
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
b98ed8e0-50c5-4592-a86b-ec730295bde3	XIN SHI DAI N° 28	02165	2669	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	62.40	1579	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	MUELLE OCHO  S.A.	Ciudad Autónoma de Buenos Aires		011-4381-1337	\N		\N	\N		t	\N	\N	\N
6d74418d-621d-469c-9722-f7907e474c01	XIN SHI JI 25	03092	2753	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	70.50	0	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	PESQUERA  20  DE NOVIEMBRE  S.A.	Ciudad Autónoma de Buenos Aires		011-4382-5011 / 4381-1337	\N		\N	\N		t	\N	\N	\N
bc2b4d9e-9dab-415f-8b35-86faa126c674	XIN SHI JI N° 88	02182	\N	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	\N	\N	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	FENIX  INTERNATIONAL  S.A.	Ciudad Autónoma de Buenos Aires		011-4381-1337	\N		\N	\N		t	\N	\N	\N
c5eddc80-28ca-4b56-b167-8dec45ee3846	XIN SHI JI Nº 89	02903	2750	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	68.58	2685	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	FENIX  INTERNATIONAL  S.A.	Ciudad Autónoma de Buenos Aires		011-4381-1337	\N		\N	\N		t	\N	\N	\N
601565b3-1cc0-4625-9b69-1dd9be926286	XIN SHI JI Nº 91	02924	2724	49f1a6b1-610e-4aab-98e6-45dbe753fe22	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	\N	40	68.58	2685	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	FENIX  INTERNATIONAL  S.A.	Ciudad Autónoma de Buenos Aires		011-4381-1337	\N		\N	\N		t	\N	\N	\N
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
bb26bbcb-ee6d-4370-9c16-84f03d8d362b	2025	183	e113b2d7-af93-44fe-a26e-805429efdd48	d08faf9b-60a9-4081-b8ea-ca931995905b	6aa3e1af-c033-4aab-a945-e1d1736f9348	2025-11-20 03:00:00+00	\N	2025-01-18 20:01:00+00	\N	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:53.423+00	2026-01-10 01:32:40.769+00	t	Importada de JSONL. Empresa: CRUSTACEOS DEL SUR S.A. Especie: CENTOLLA	MC	30
9076d345-9540-4afd-adb6-23d9fb452797	2025	1	9b521dd3-43c9-4aa5-b948-7d6356cf1930	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-01-03 03:00:00+00	\N	\N	32	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:51.975+00	2026-01-05 21:09:51.975+00	t	Importada de JSONL. Empresa: ESTREMAR. Especie: MERLUZA AUSTRAL	MC	60
b27d3a0e-7338-439e-9acc-3cdec348b830	2025	2	81d1eda7-b157-4fee-a647-8bce8e62efbc	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-01-03 03:00:00+00	\N	\N	23	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.001+00	2026-01-05 21:09:52.001+00	t	Importada de JSONL. Empresa: ARGENOVA. Especie: MERLUZA AUSTRAL	MC	60
f9d47889-b2a5-45d9-b918-3e8ca33ae8de	2025	3	ce9995e9-716c-4ef7-b6f1-63b2bd5f54e8	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-01-03 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.013+00	2026-01-05 21:09:52.013+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: CENTOLLA	MC	30
0e1101d5-a8a5-4fc6-bd6c-8e6d5bf5a187	2025	4	ce349711-474f-4bad-b14e-0be248aaa348	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-01-12 03:00:00+00	\N	\N	4	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.024+00	2026-01-05 21:09:52.024+00	t	Importada de JSONL. Empresa: PEDRO MOSCUZZA E HIJO. Especie: MERLUZA	MC	30
90479d64-7113-423c-89f4-13a0bfbf9975	2025	5	5b5f41c3-a95b-4043-8ac1-3c0fda0d92b4	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-01-08 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.033+00	2026-01-05 21:09:52.033+00	t	Importada de JSONL. Empresa: PESQUERA GEMINIS. Especie: MERLUZA	MC	30
a686b746-2f99-45f9-9b48-9e858b4863f2	2025	6	95444611-ad7f-4532-a8cb-4e71b9dff4de	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-01-09 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.041+00	2026-01-05 21:09:52.041+00	t	Importada de JSONL. Empresa: PESQUERA CERES. Especie: CALAMAR	MC	30
2dfe6d99-7c81-4b76-a87d-5a23757b0349	2025	7	206d0307-0af3-419a-99d5-165c7b85f486	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-01-07 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.049+00	2026-01-05 21:09:52.049+00	t	Importada de JSONL. Empresa: ARGENOVA. Especie: CALAMAR	MC	30
4f0eaeb5-1488-43fc-8e7b-6f7bad09c614	2025	8	8f31ff24-aea0-4f47-b713-6f9a6a68c51c	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-01-09 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.057+00	2026-01-05 21:09:52.057+00	t	Importada de JSONL. Empresa: LUIS SOLIMENO. Especie: MERLUZA	MC	30
efce3e7d-3fc3-46fb-a508-be8cc580ad53	2025	9	f494b1f2-975d-458d-8b0e-21f1e7540a83	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-01-06 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.07+00	2026-01-05 21:09:52.07+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: VIEIRA	MC	30
694ed401-8843-4363-9266-8d1011a20a59	2025	10	426cfd83-e5ac-4d02-a611-f1b4d445321f	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-01-11 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.077+00	2026-01-05 21:09:52.077+00	t	Importada de JSONL. Empresa: GLACIAR PESQUERA. Especie: VIEIRA	MC	30
66c81c16-f6c2-4d97-bcf7-42ce652ccdb9	2025	11	c26786f0-a9dd-4f2f-b86a-87bdc65ad05e	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-01-08 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.087+00	2026-01-05 21:09:52.087+00	t	Importada de JSONL. Empresa: FOOD ARTZ S.A.. Especie: CALAMAR	MC	30
200384e0-1776-4b38-be51-fee06de25c14	2025	12	06f76a6f-dd4e-490c-b6a2-ee9a8ebcff3d	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-01-09 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.094+00	2026-01-05 21:09:52.094+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: VIEIRA	MC	30
07ce19a1-da51-4871-8185-c1e809a5efcb	2025	13	3029416d-e79f-479f-b77e-6c0c94c68435	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-01-09 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.102+00	2026-01-05 21:09:52.102+00	t	Importada de JSONL. Empresa: FOOD PARTNERS PATAGONIA. Especie: CENTOLLA	MC	30
5b1347dd-d6f2-4250-94b2-726ef6000f4d	2025	14	1c20a49a-26af-427b-bb3e-14962058c07d	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-01-09 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.111+00	2026-01-05 21:09:52.111+00	t	Importada de JSONL. Empresa: PEDRO MOSCUZZA E HIJO. Especie: CALAMAR	MC	30
f1d03daf-0f1d-478e-ba2f-58bcd4251ec1	2025	15	969e6d80-f91a-422a-b8c8-949b3b8a2834	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-01-11 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.119+00	2026-01-05 21:09:52.119+00	t	Importada de JSONL. Empresa: PESQUERA VERAZ. Especie: MERLUZA	MC	30
d2639d24-4795-4baa-b356-7fa928ecf78b	2025	16	6ddb602a-7854-408e-8674-0e787933e02e	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-01-16 03:00:00+00	\N	\N	11	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.133+00	2026-01-05 21:09:52.133+00	t	Importada de JSONL. Empresa: GLACIAR PESQUERA. Especie: VIEIRA	MC	30
482360a2-d80f-4f65-a829-c3c9dee01c6d	2025	17	7db9cb20-afb3-4813-8204-a04743b23b3f	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-01-17 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.141+00	2026-01-05 21:09:52.141+00	t	Importada de JSONL. Empresa: ALTAMARE S.AS. Especie: CALAMAR	MC	30
2ab0f251-d267-40eb-9f3c-b02f62a1cd45	2025	18	0c5144b3-0db4-4c82-8d9b-e5db22222f41	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-01-17 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.15+00	2026-01-05 21:09:52.15+00	t	Importada de JSONL. Empresa: ALTAMARE S.AS. Especie: CALAMAR	MC	30
0fbd898d-e869-4369-9692-98d41b56b242	2025	19	e85d97cf-ab2e-4639-8168-2c1783e4273a	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-01-28 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.158+00	2026-01-05 21:09:52.158+00	t	Importada de JSONL. Empresa: BENTONICOS DE ARGENTINA. Especie: CENTOLLA	MC	30
9fadd20b-03d6-458b-9b34-96e3f19b3c18	2025	20	95444611-ad7f-4532-a8cb-4e71b9dff4de	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-01-28 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.166+00	2026-01-05 21:09:52.166+00	t	Importada de JSONL. Empresa: GIORNO. Especie: CALAMAR	MC	30
cda9eb74-e671-48d8-8c0b-3370d4b54256	2025	21	395ed19d-038a-42c9-95cc-db61a21fdb8b	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-02-04 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.175+00	2026-01-05 21:09:52.175+00	t	Importada de JSONL. Empresa: CRUSTACEOS DEL SUR S.A. Especie: CENTOLLA	MC	30
51896655-508e-4ea2-b53c-9d6c60f3f122	2025	22	6e19e972-b13d-4b00-9970-c33b453254d3	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-02-01 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.184+00	2026-01-05 21:09:52.184+00	t	Importada de JSONL. Empresa: ARGENOVA. Especie: CALAMAR	MC	30
621c1b94-90a8-4a2c-881a-7c21284b67be	2025	23	c5c3c325-4a69-4a8d-9f57-5c65006da37a	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-01-28 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.191+00	2026-01-05 21:09:52.191+00	t	Importada de JSONL. Empresa: ARBUMASA S.A. Especie: CALAMAR	MC	30
68a13a46-9ce3-453a-a776-3436ebee98c2	2025	24	81d1eda7-b157-4fee-a647-8bce8e62efbc	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-01-31 03:00:00+00	\N	\N	22	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.201+00	2026-01-05 21:09:52.201+00	t	Importada de JSONL. Empresa: ARGENOVA. Especie: MERLUZA AUSTRAL	MC	30
8a562259-5c22-4bef-9d62-27e407cbc1a8	2025	25	963558b2-f1a1-462a-bb0c-e1c47eebb71b	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-02-01 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.207+00	2026-01-05 21:09:52.207+00	t	Importada de JSONL. Empresa: BENTONICOS DE ARGENTINA. Especie: CENTOLLA	MC	30
a95eb4f4-2c21-4d2e-a29c-7fbddbca7378	2025	26	96658434-ad2a-473b-a532-d2afe15cb4d2	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-02-02 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.215+00	2026-01-05 21:09:52.215+00	t	Importada de JSONL. Empresa: GIORNO. Especie: MERLUZA	MC	30
f66f54eb-303b-4ad5-95bd-9ef55e4e16dd	2025	27	fc67a193-73d3-42e6-9aa7-7811e559cbfb	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-01-31 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.222+00	2026-01-05 21:09:52.222+00	t	Importada de JSONL. Empresa: CHIARPESCA. Especie: CALAMAR	MC	30
48fe5394-4b5c-49c1-9d44-0f9d2b21b53a	2025	28	5d2e398a-7f96-4c2b-a455-58da21ceb1ff	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-02-06 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.23+00	2026-01-05 21:09:52.23+00	t	Importada de JSONL. Empresa: PESANTAR. Especie: CALAMAR	MC	60
2256c2ba-7ef9-45a0-a5c7-9afa6cef49ac	2025	29	fa28ac74-fd00-4a3d-81a0-5fe3a44172c9	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-02-03 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.237+00	2026-01-05 21:09:52.237+00	t	Importada de JSONL. Empresa: EL MARISCO. Especie: MERLUZA	MC	30
69cbcc71-43c4-4429-90bd-e675a46e9872	2025	30	9b521dd3-43c9-4aa5-b948-7d6356cf1930	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-02-12 03:00:00+00	\N	\N	83	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.244+00	2026-01-05 21:09:52.244+00	t	Importada de JSONL. Empresa: ESTREMAR. Especie: MERLUZA AUSTRAL	MC	30
592db42c-4135-40d1-b7a3-2a0dc4299636	2025	31	f494b1f2-975d-458d-8b0e-21f1e7540a83	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-02-02 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.251+00	2026-01-05 21:09:52.251+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: VIEIRA	MC	30
a12d12d9-f4f7-4e74-9fab-bc1dc17d0688	2025	32	2c28cc5a-890c-4152-b972-78aeb3ad281c	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-02-19 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.258+00	2026-01-05 21:09:52.258+00	t	Importada de JSONL. Empresa: PRODESUR. Especie: MERLUZA AUSTRAL	MC	60
1fdfc3d9-544b-48cf-a621-dd68244f9369	2025	33	969e6d80-f91a-422a-b8c8-949b3b8a2834	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-02-14 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.265+00	2026-01-05 21:09:52.265+00	t	Importada de JSONL. Empresa: PESQUERA VERAZ. Especie: MERLUZA	MC	30
47f761ef-c91e-45fb-93d5-1f98eb26cd38	2025	34	426cfd83-e5ac-4d02-a611-f1b4d445321f	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-02-27 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.274+00	2026-01-05 21:09:52.274+00	t	Importada de JSONL. Empresa: GLACIAR PESQUERA. Especie: VIEIRA	MC	30
f9765ab5-8ee7-416c-b7c1-d0d1846a4327	2025	35	81d1eda7-b157-4fee-a647-8bce8e62efbc	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-02-25 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.281+00	2026-01-05 21:09:52.281+00	t	Importada de JSONL. Empresa: ARGENOVA. Especie: MERLUZA AUSTRAL	MC	30
dea85480-9c24-454f-b6fa-4c78332dcce3	2025	36	06f76a6f-dd4e-490c-b6a2-ee9a8ebcff3d	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-02-20 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.288+00	2026-01-05 21:09:52.288+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: VIEIRA	MC	30
02435e7d-a5b8-4b8e-809b-dfd97b7df3d1	2025	37	e113b2d7-af93-44fe-a26e-805429efdd48	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-02-21 03:00:00+00	\N	\N	29	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.296+00	2026-01-05 21:09:52.296+00	t	Importada de JSONL. Empresa: CRUSTACEOS DEL SUR S.A. Especie: CENTOLLA	MC	30
0e0d382a-b7eb-4d4f-8eae-fecf123e836e	2025	38	ce9995e9-716c-4ef7-b6f1-63b2bd5f54e8	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-03-05 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.302+00	2026-01-05 21:09:52.302+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: CENTOLLA	MC	30
5cb83b2e-d1d3-4e14-bdb4-1031857eaecd	2025	39	e85d97cf-ab2e-4639-8168-2c1783e4273a	\N	e1466c46-8d9b-4f0d-8903-c543a05b8510	2025-03-06 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.309+00	2026-01-05 21:09:52.309+00	t	Importada de JSONL. Empresa: BENTONICOS DE ARGENTINA. Especie: CENTOLLA	MC	30
a7bdea43-545d-4d0a-96ce-62cbc6f3567c	2025	40	6ddb602a-7854-408e-8674-0e787933e02e	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-03-06 03:00:00+00	\N	\N	6	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.314+00	2026-01-05 21:09:52.314+00	t	Importada de JSONL. Empresa: GLACIAR PESQUERA. Especie: VIEIRA	MC	30
f4f7a0f7-87a0-426a-8a6a-e621a6dfb4e8	2025	41	10a7186d-32e2-40df-9932-bc8537990e82	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-03-03 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.322+00	2026-01-05 21:09:52.322+00	t	Importada de JSONL. Empresa: FOOD ARTS S.A. Especie: CALAMAR	MC	30
9abc8a68-2563-4aae-9ead-77e56a59de1f	2025	42	f1f72d4e-c755-4ee4-91a8-b2e2b63472e7	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-03-07 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.329+00	2026-01-05 21:09:52.329+00	t	Importada de JSONL. Empresa: TOZUDO. Especie: P.ABADEJO	MC	30
11d340ae-2948-4d28-ae9d-12a32a5c90a9	2025	43	39cafebc-e125-4d3a-b860-1cc4f314a4b4	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-03-07 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.338+00	2026-01-05 21:09:52.338+00	t	Importada de JSONL. Empresa: PESQUERA SIEMPRE GAUCHO. Especie: P.ABADEJO	MC	30
0b53fe15-746b-4833-89ec-01eb6cd2f234	2025	44	c991a706-a3dd-4ca3-8bbe-e5cf884dea37	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-03-07 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.347+00	2026-01-05 21:09:52.347+00	t	Importada de JSONL. Empresa: LOBA PESQUERA. Especie: P.ABADEJO	MC	30
311d40b1-64bc-4e65-bd15-7aeb87b45bc4	2025	45	7befa686-b129-469e-a9f7-192d74f71dae	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-03-07 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.356+00	2026-01-05 21:09:52.356+00	t	Importada de JSONL. Empresa: ROMFIOC S.R.L. Especie: P.ABADEJO	MC	30
b6c44045-e74b-4c6d-aadb-8e351e3f5272	2025	46	e53ca05c-f5cf-4712-88ed-4f35ccbbf17b	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-03-07 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.366+00	2026-01-05 21:09:52.366+00	t	Importada de JSONL. Empresa: MAREA OPTIMA. Especie: P.ABADEJO	MC	30
881b3e5f-1e70-442e-a979-2227a0af91f8	2025	47	395ed19d-038a-42c9-95cc-db61a21fdb8b	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-03-12 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.377+00	2026-01-05 21:09:52.377+00	t	Importada de JSONL. Empresa: CRUSTACEOS DEL SUR S.A. Especie: CENTOLLA	MC	30
c426739a-2bbd-4bd7-8b15-4cd170e58f50	2025	48	01250855-bee5-42b0-afbf-a342b210ca79	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-03-12 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.384+00	2026-01-05 21:09:52.384+00	t	Importada de JSONL. Empresa: CENTOMAR S.A. Especie: CENTOLLA	MC	30
9846b525-caeb-423f-ba64-c9e24e8ec6f4	2025	49	49403073-bf7a-4a08-a982-83cadd8199e4	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-03-18 03:00:00+00	\N	\N	27	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.391+00	2026-01-05 21:09:52.391+00	t	Importada de JSONL. Empresa: ESTRELLA PATAGONICA. Especie: MERLUZA	MC	30
ed3251db-d14e-4c8b-8416-25094bb4b2ca	2025	50	f1e3eb78-7a87-4045-91ab-034c7e866639	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-03-22 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.398+00	2026-01-05 21:09:52.398+00	t	Importada de JSONL. Empresa: MOSCUZZA. Especie: CALAMAR	MC	30
8278705c-0edf-401c-b780-b91d0d623f7d	2025	51	f494b1f2-975d-458d-8b0e-21f1e7540a83	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-03-24 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.404+00	2026-01-05 21:09:52.404+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: VIEIRA	MC	30
4095549b-0d2a-46c9-98e7-c1bba0941de0	2025	52	81d1eda7-b157-4fee-a647-8bce8e62efbc	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-03-27 03:00:00+00	\N	\N	25	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.41+00	2026-01-05 21:09:52.41+00	t	Importada de JSONL. Empresa: ARGENOVA. Especie: MERLUZA AUSTRAL	MC	30
9995c117-f9ec-4a2d-9175-ba610601fcb0	2025	53	1c20a49a-26af-427b-bb3e-14962058c07d	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-03-28 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.422+00	2026-01-05 21:09:52.422+00	t	Importada de JSONL. Empresa: PEDRO MOSCUZZA E HIJO. Especie: CALAMAR	MC	30
9ca69fde-117e-4717-818a-546b49669e42	2025	54	06f76a6f-dd4e-490c-b6a2-ee9a8ebcff3d	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-04-09 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.429+00	2026-01-05 21:09:52.429+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: VIEIRA	MC	30
1da59a5f-db27-4cdc-838d-77ee8b345ff7	2025	55	2c28cc5a-890c-4152-b972-78aeb3ad281c	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-04-17 03:00:00+00	\N	\N	1	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.439+00	2026-01-05 21:09:52.439+00	t	Importada de JSONL. Empresa: PRODESUR. Especie: MERLUZA AUSTRAL	MC	60
338f1e94-bca1-47ce-b9be-daa77185cf2e	2025	56	5d2e398a-7f96-4c2b-a455-58da21ceb1ff	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-04-10 03:00:00+00	\N	\N	39	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.449+00	2026-01-05 21:09:52.449+00	t	Importada de JSONL. Empresa: PESANTAR. Especie: MERLUZA AUSTRAL	MC	60
abdbef76-9b46-4e8f-92ee-6b9020caaa8d	2025	57	e85d97cf-ab2e-4639-8168-2c1783e4273a	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-04-09 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.457+00	2026-01-05 21:09:52.457+00	t	Importada de JSONL. Empresa: BENTONICOS DE ARGENTINA. Especie: CENTOLLA	MC	30
f0468bbd-b484-41df-b78c-88aaab94250a	2025	58	b45f21ed-e01a-47b1-b39a-a4566510dfe6	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-04-22 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.464+00	2026-01-05 21:09:52.464+00	t	Importada de JSONL. Empresa: VIERA ARGENTINA. Especie: CALAMAR	MC	30
32617a9e-1648-4056-afb8-bfc5030276e5	2025	59	426cfd83-e5ac-4d02-a611-f1b4d445321f	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-04-10 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.471+00	2026-01-05 21:09:52.471+00	t	Importada de JSONL. Empresa: GLACIAR PESQUERA. Especie: VIEIRA	MC	30
ca6ad44a-8156-4059-81a0-0226336aa2df	2025	60	ce9995e9-716c-4ef7-b6f1-63b2bd5f54e8	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-04-10 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.478+00	2026-01-05 21:09:52.478+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: CENTOLLA	MC	30
7c602a8d-a15d-4840-bca0-53fb57a13d81	2025	61	6ddb602a-7854-408e-8674-0e787933e02e	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-04-17 03:00:00+00	\N	\N	6	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.487+00	2026-01-05 21:09:52.487+00	t	Importada de JSONL. Empresa: GLACIAR PESQUERA. Especie: VIEIRA	MC	30
f8aad6fc-bca6-4048-96ae-02a913dfba6d	2025	62	2cdca49a-8246-4a32-8fdf-6866325de54c	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-04-15 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.495+00	2026-01-05 21:09:52.495+00	t	Importada de JSONL. Empresa: ALTAMARE S.AS. Especie: CALAMAR	MC	30
de0e9cf6-f31f-48a1-ac4c-e765f1dd10df	2025	63	a238d7c1-4298-4edc-8b8c-7e27d840596f	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-04-11 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.502+00	2026-01-05 21:09:52.502+00	t	Importada de JSONL. Empresa: PESCARGEN. Especie: LANGOSTINO	MC	30
6820501e-2199-40d1-9f42-321c4f0b11db	2025	64	96658434-ad2a-473b-a532-d2afe15cb4d2	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-04-22 03:00:00+00	\N	\N	6	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.52+00	2026-01-05 21:09:52.52+00	t	Importada de JSONL. Empresa: GIORNO. Especie: MERLUZA	MC	30
31532d29-63f4-4dab-82f3-06cd195379b7	2025	65	8adaf55b-8d2e-4403-90ca-0db212a2eaad	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-04-15 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.529+00	2026-01-05 21:09:52.529+00	t	Importada de JSONL. Empresa: LUIS SOLIMENO. Especie: MERLUZA	MC	30
0e52329d-2d4e-497e-8fa5-f53dbe6a6a58	2025	66	8d9b5cf1-64d1-4313-9fb0-4a382549e0b6	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-04-21 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.54+00	2026-01-05 21:09:52.54+00	t	Importada de JSONL. Empresa: MARÍTIMA COMERCIAL. Especie: MERLUZA	MC	30
0e7d01e2-b826-4db7-be3b-71ac7fb56c7d	2025	67	55783ffd-405f-4d11-a26c-740b1843e1d3	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-04-29 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.55+00	2026-01-05 21:09:52.55+00	t	Importada de JSONL. Empresa: NIETOS ANTONIO BALDINO. Especie: MERLUZA	MC	30
f8f01a70-128b-41d6-a8c4-7114b79dfd24	2025	68	709d205f-9448-48c3-b891-6ce1a72ba370	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-04-23 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.557+00	2026-01-05 21:09:52.557+00	t	Importada de JSONL. Empresa: MOSCUZZA. Especie: MERLUZA	MC	30
36efc308-b34e-4c6c-853d-9bf75f7b6da6	2025	69	f1e3eb78-7a87-4045-91ab-034c7e866639	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-04-26 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.568+00	2026-01-05 21:09:52.568+00	t	Importada de JSONL. Empresa: MOSCUZZA. Especie: CALAMAR	MC	30
877af272-2260-4f9a-bdb8-553ea0b056ed	2025	70	2eb261d6-3a02-44b5-9330-0ca6d5fc4b45	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-04-25 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.575+00	2026-01-05 21:09:52.575+00	t	Importada de JSONL. Empresa: MARONTI  S.A.. Especie: MERLUZA	MC	30
0268cb0f-3f5d-42c4-9404-8a96f016b381	2025	71	fc67a193-73d3-42e6-9aa7-7811e559cbfb	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-04-24 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.585+00	2026-01-05 21:09:52.585+00	t	Importada de JSONL. Empresa: GRUPO CHIAR PESCA. Especie: CALAMAR	MC	30
ff5b01b1-e5f0-4f85-b962-2e486b741944	2025	72	81d1eda7-b157-4fee-a647-8bce8e62efbc	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-04-29 03:00:00+00	\N	\N	24	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.593+00	2026-01-05 21:09:52.593+00	t	Importada de JSONL. Empresa: ARGENOVA. Especie: MERLUZA AUSTRAL	MC	30
4d6b0412-6cbf-40d4-a103-a9a2b7e9ceb9	2025	73	b6c82a60-965d-4e57-bf7e-9d1a4a9347bc	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-04-26 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.6+00	2026-01-05 21:09:52.6+00	t	Importada de JSONL. Empresa: BUENA PROA. Especie: MERLUZA	MC	30
4e1ca30c-b9ad-4e70-ac7b-373d4e469cce	2025	74	423261e8-4005-4600-a12e-852c05665a73	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-04-30 03:00:00+00	\N	\N	7	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.611+00	2026-01-05 21:09:52.611+00	t	Importada de JSONL. Empresa: GIORNO. Especie: MERLUZA	MC	30
b256d88d-3846-49be-a520-d2714953f2b9	2025	75	9b521dd3-43c9-4aa5-b948-7d6356cf1930	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-05-07 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.619+00	2026-01-05 21:09:52.619+00	t	Importada de JSONL. Empresa: ESTREMAR. Especie: MERLUZA AUSTRAL	MC	30
8ac92a84-1849-4a60-976b-d1b84e421031	2025	76	f494b1f2-975d-458d-8b0e-21f1e7540a83	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-05-07 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.628+00	2026-01-05 21:09:52.628+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: VIEIRA	MC	30
7f9d1709-bef6-4c9d-a884-0dea2639d1a9	2025	77	5b5f41c3-a95b-4043-8ac1-3c0fda0d92b4	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-05-04 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.635+00	2026-01-05 21:09:52.635+00	t	Importada de JSONL. Empresa: GIORNO. Especie: MERLUZA	MC	30
f161f9ea-d8a7-4ac6-8071-5a9c2ebca5e6	2025	78	c26786f0-a9dd-4f2f-b86a-87bdc65ad05e	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-05-06 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.642+00	2026-01-05 21:09:52.642+00	t	Importada de JSONL. Empresa: FOOD ARTS S.A. Especie: CALAMAR	MC	30
3d155205-90bb-4e22-9208-bf9917a5c0bf	2025	79	1c20a49a-26af-427b-bb3e-14962058c07d	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-05-06 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.649+00	2026-01-05 21:09:52.649+00	t	Importada de JSONL. Empresa: MOSCUZZA. Especie: CALAMAR	MC	30
055f85ae-4413-43bd-a039-5e997c351649	2025	80	a238d7c1-4298-4edc-8b8c-7e27d840596f	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-05-10 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.655+00	2026-01-05 21:09:52.655+00	t	Importada de JSONL. Empresa: PESCAREN S.A. Especie: LANGOSTINO	MC	30
49534099-b63a-4a6b-ac69-c0471f345506	2025	81	ce9995e9-716c-4ef7-b6f1-63b2bd5f54e8	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-05-15 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.663+00	2026-01-05 21:09:52.663+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: CENTOLLA	MC	30
2433bfa1-7760-4361-8977-933f577f865a	2025	82	5d2e398a-7f96-4c2b-a455-58da21ceb1ff	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-05-22 03:00:00+00	\N	\N	50	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.669+00	2026-01-05 21:09:52.669+00	t	Importada de JSONL. Empresa: PESANTAR. Especie: MERLUZA AUSTRAL	MC	60
ea92f9f1-c762-40ce-8a2c-33f521b51714	2025	83	ce349711-474f-4bad-b14e-0be248aaa348	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-05-17 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.675+00	2026-01-05 21:09:52.675+00	t	Importada de JSONL. Empresa: MOSCUZZA. Especie: MERLUZA	MC	30
c7b47701-b71e-4ee7-8217-09cbe435abd1	2025	84	b21d8138-eed7-422c-94b6-51a7dadaf6b5	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-05-20 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.682+00	2026-01-05 21:09:52.682+00	t	Importada de JSONL. Empresa: LUIS SOLIMENO. Especie: MERLUZA	MC	30
ba7b47a6-4cf1-4f87-b0e0-aeff75dea890	2025	85	423261e8-4005-4600-a12e-852c05665a73	\N	e1466c46-8d9b-4f0d-8903-c543a05b8510	2025-05-20 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.69+00	2026-01-05 21:09:52.69+00	t	Importada de JSONL. Empresa: GIORNO. Especie: MERLUZA	MC	30
8091e240-4b3e-4ddb-bb28-85a58ba46bf6	2025	86	78a9b02e-953a-4fc7-b955-2169483d1537	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-05-20 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.695+00	2026-01-05 21:09:52.695+00	t	Importada de JSONL. Empresa: LUIS SOLIMENO. Especie: CALAMAR	MC	30
beae9edc-38b7-48cb-8301-22fbe202aab3	2025	87	2c28cc5a-890c-4152-b972-78aeb3ad281c	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-05-20 03:00:00+00	\N	\N	31	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.701+00	2026-01-05 21:09:52.701+00	t	Importada de JSONL. Empresa: PRODESUR. Especie: MERLUZA AUSTRAL	MC	60
032dfc0b-0119-4cf8-9a01-a152af6ed805	2025	88	06f76a6f-dd4e-490c-b6a2-ee9a8ebcff3d	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-05-26 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.708+00	2026-01-05 21:09:52.708+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: VIEIRA	MC	30
8cbe3d37-ac3d-4be6-b478-9a73af9ac20c	2025	89	6ddb602a-7854-408e-8674-0e787933e02e	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-05-31 03:00:00+00	\N	\N	6	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.715+00	2026-01-05 21:09:52.715+00	t	Importada de JSONL. Empresa: GLACIAR PESQUERA. Especie: VIEIRA	MC	30
d60cf987-bbe4-4f03-ba2f-2579d6dba2cc	2025	90	a238d7c1-4298-4edc-8b8c-7e27d840596f	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-05-28 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.722+00	2026-01-05 21:09:52.722+00	t	Importada de JSONL. Empresa: PESCARGEN. Especie: LANGOSTINO	MC	30
790db629-d119-4f12-80cf-2d922a82c2e2	2025	91	f1e3eb78-7a87-4045-91ab-034c7e866639	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-05-29 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.73+00	2026-01-05 21:09:52.73+00	t	Importada de JSONL. Empresa: MOSCUZZA. Especie: CALAMAR	MC	30
596845b7-68fe-47c3-aeb8-98261c99c0d9	2025	92	c573e0fc-6f82-4795-bfcc-b49b981977d8	\N	e1466c46-8d9b-4f0d-8903-c543a05b8510	2025-05-29 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.74+00	2026-01-05 21:09:52.74+00	t	Importada de JSONL. Empresa: CONARPESA. Especie: LANGOSTINO	MC	30
675faed9-0007-4ac7-bd8b-3780cc11b128	2025	93	426cfd83-e5ac-4d02-a611-f1b4d445321f	\N	e1466c46-8d9b-4f0d-8903-c543a05b8510	2025-06-11 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.745+00	2026-01-05 21:09:52.745+00	t	Importada de JSONL. Empresa: GLACIAR PESQUERA. Especie: VIERA	MC	30
1ef63927-72f2-4b8f-812f-d2945330473d	2025	94	a345ae7d-ecba-4f38-b94f-8010e22d3615	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-06-09 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.75+00	2026-01-05 21:09:52.75+00	t	Importada de JSONL. Empresa: ARPES. Especie: MERLUZA	MC	30
fd9da546-bf42-4c98-9cc4-c8b6d317cd6b	2025	95	5b5f41c3-a95b-4043-8ac1-3c0fda0d92b4	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-06-06 03:00:00+00	\N	\N	1	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.765+00	2026-01-05 21:09:52.765+00	t	Importada de JSONL. Empresa: GIORNO. Especie: MERLUZA	MC	30
284a1f0e-a7fb-472a-9131-7aa367ac0610	2025	96	96658434-ad2a-473b-a532-d2afe15cb4d2	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-06-06 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.771+00	2026-01-05 21:09:52.771+00	t	Importada de JSONL. Empresa: GIORNO. Especie: MERLUZA	MC	30
1ab6c8b1-0c90-4240-9328-92b2c3f0cc2a	2025	97	7befa686-b129-469e-a9f7-192d74f71dae	\N	e1466c46-8d9b-4f0d-8903-c543a05b8510	2025-06-17 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.778+00	2026-01-05 21:09:52.778+00	t	Importada de JSONL. Empresa: ROMFIOC S.R.L. Especie: MERLUZA	MC	30
4226bf56-57c0-4560-a178-98ab4df1d172	2025	98	9b521dd3-43c9-4aa5-b948-7d6356cf1930	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-06-17 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.782+00	2026-01-05 21:09:52.782+00	t	Importada de JSONL. Empresa: ESTREMAR. Especie: MERLUZA AUSTRAL	MC	30
93a313f8-ad3c-462a-95b9-c4c19624dac6	2025	99	b6c82a60-965d-4e57-bf7e-9d1a4a9347bc	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-06-12 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.788+00	2026-01-05 21:09:52.788+00	t	Importada de JSONL. Empresa: BUENA PROA. Especie: MERLUZA	MC	30
e8ea7d21-16fb-4dc1-b2fd-a932449a6e49	2025	100	f494b1f2-975d-458d-8b0e-21f1e7540a83	\N	e1466c46-8d9b-4f0d-8903-c543a05b8510	2025-06-17 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.803+00	2026-01-05 21:09:52.803+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: VIERA	MC	30
5a97e8e8-40e6-4195-a00a-bf522a3775dc	2025	101	bcf44a42-a593-48e9-9a37-dbf6ea8f36db	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-06-18 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.808+00	2026-01-05 21:09:52.808+00	t	Importada de JSONL. Empresa: BUENA PROA. Especie: P. LANGOSTINO	MC	30
924abc07-845d-44d4-9587-a9c4ad38078a	2025	102	a238d7c1-4298-4edc-8b8c-7e27d840596f	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-06-17 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.817+00	2026-01-05 21:09:52.817+00	t	Importada de JSONL. Empresa: PESCARGEN. Especie: P. LANGOSTINO	MC	30
4f2112d6-a93d-4546-b2cd-9debae9f7d00	2025	103	243937dd-fbf9-448f-8989-076c27ad2cb4	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-06-17 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.824+00	2026-01-05 21:09:52.824+00	t	Importada de JSONL. Empresa: FRIGORÍFICO DON LUIS. Especie: P. LANGOSTINO	MC	30
5769899c-b858-47af-bd34-da72856242d3	2025	104	d196c4c4-f01d-4915-8318-764e7e9f41cb	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-06-18 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.832+00	2026-01-05 21:09:52.832+00	t	Importada de JSONL. Empresa: URLIPEZ. Especie: P. LANGOSTINO	MC	30
c3598bb8-fbea-4261-9ee1-a8a88a21b7e6	2025	105	0d0ad567-f9b6-45eb-b3f1-2ef0f9f89f2c	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-06-19 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.838+00	2026-01-05 21:09:52.838+00	t	Importada de JSONL. Empresa: DE ANGELIS Y LOGGHE. Especie: P. LANGOSTINO	MC	30
77fe6524-661b-45b3-9f20-6f1fc7c96be3	2025	106	c237adcf-f4c0-4601-a110-f0cddcaff8b6	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-06-17 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.845+00	2026-01-05 21:09:52.845+00	t	Importada de JSONL. Empresa: PESCA ANTIGUA. Especie: P. LANGOSTINO	MC	30
c093282b-2731-449c-85ed-5473d49b37d7	2025	107	88efd36d-e7a9-4a1d-b0c2-14c6e6ae1759	\N	e1466c46-8d9b-4f0d-8903-c543a05b8510	2025-06-21 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.854+00	2026-01-05 21:09:52.854+00	t	Importada de JSONL. Empresa: IBERCONSA. Especie: MERLUZA	MC	30
d5579c39-d747-44a9-9f3b-244ada52f539	2025	108	8adaf55b-8d2e-4403-90ca-0db212a2eaad	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-06-24 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.858+00	2026-01-05 21:09:52.858+00	t	Importada de JSONL. Empresa: SOLIMENO E HIJOS. Especie: MERLUZA	MC	30
6f431794-9db0-4b41-9afe-13134f7e4ef0	2025	109	426cfd83-e5ac-4d02-a611-f1b4d445321f	\N	e1466c46-8d9b-4f0d-8903-c543a05b8510	2025-06-23 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.87+00	2026-01-05 21:09:52.87+00	t	Importada de JSONL. Empresa: GLACIAR PESQUERA. Especie: VIERA	MC	30
b665acfb-d2f6-4910-b47a-cc7765fb017d	2025	110	243937dd-fbf9-448f-8989-076c27ad2cb4	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-06-27 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.875+00	2026-01-05 21:09:52.875+00	t	Importada de JSONL. Empresa: FRIGORÍFICO DON LUIS. Especie: P. LANGOSTINO	MC	30
98266e72-77a5-4d91-ba08-2a4c66658cdc	2025	111	0d0ad567-f9b6-45eb-b3f1-2ef0f9f89f2c	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-06-27 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.882+00	2026-01-05 21:09:52.882+00	t	Importada de JSONL. Empresa: DE ANGELIS Y LOGGHE. Especie: P. LANGOSTINO	MC	30
92a3b9e4-161f-47b4-af64-286393ecb159	2025	112	7e651893-1a83-4f84-8bc1-086a0436faf9	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-06-27 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.893+00	2026-01-05 21:09:52.893+00	t	Importada de JSONL. Empresa: CANAL DE BEAGLE. Especie: P. LANGOSTINO	MC	30
26718815-8684-4b30-9258-9bb6a63e5379	2025	113	969e6d80-f91a-422a-b8c8-949b3b8a2834	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-07-01 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.9+00	2026-01-05 21:09:52.9+00	t	Importada de JSONL. Empresa: PESQUERA VERAZ. Especie: MERLUZA	MC	30
40d45581-09a2-44a6-a87b-647ab77b5bac	2025	114	426cfd83-e5ac-4d02-a611-f1b4d445321f	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-07-10 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.91+00	2026-01-05 21:09:52.91+00	t	Importada de JSONL. Empresa: GLACIAR PESQUERA. Especie: VIERA	MC	30
975000e6-8d50-41e9-b66b-33e8e5dfa0f5	2025	115	f494b1f2-975d-458d-8b0e-21f1e7540a83	\N	e1466c46-8d9b-4f0d-8903-c543a05b8510	2025-07-08 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.917+00	2026-01-05 21:09:52.917+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: VIERA	MC	30
898f861d-cab2-4b8b-8bef-64a768ebada9	2025	116	6ddb602a-7854-408e-8674-0e787933e02e	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-07-15 03:00:00+00	\N	\N	3	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.922+00	2026-01-05 21:09:52.922+00	t	Importada de JSONL. Empresa: GLACIAR PESQUERA. Especie: VIERA	MC	30
63d6cfba-6a7e-4666-8ee3-bff7bb0eb867	2025	117	a238d7c1-4298-4edc-8b8c-7e27d840596f	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-07-11 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.928+00	2026-01-05 21:09:52.928+00	t	Importada de JSONL. Empresa: PESCARGEN. Especie: LANGOSTINO	MC	30
5db1a29b-1723-4853-ab5b-68e119dfbfb5	2025	118	9a2759e2-5da5-4b77-9464-0dc62ce3ca3a	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-07-11 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.935+00	2026-01-05 21:09:52.935+00	t	Importada de JSONL. Empresa: BUENA PROA. Especie: LANGOSTINO	MC	30
0646f2e6-9ddf-43d1-9348-a4da267a3df6	2025	119	74289586-e9b9-4183-80ec-0e69d90e262c	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-07-12 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.942+00	2026-01-05 21:09:52.942+00	t	Importada de JSONL. Empresa: IBERCONSA. Especie: MERLUZA	MC	30
b6b354c8-7bd6-4146-8aa4-6432bc38c35f	2025	120	d1fc8554-8bd8-4753-8d25-1961ac6fff9b	\N	e1466c46-8d9b-4f0d-8903-c543a05b8510	2025-07-11 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.948+00	2026-01-05 21:09:52.948+00	t	Importada de JSONL. Empresa: RITONDO SALLUSTIO Y CICCIOTTI. Especie: LANGOSTINO	MC	30
f0d7ac68-cb3b-42f8-a568-2044b0748289	2025	121	fe7f99ba-a0b2-4abe-82bb-f6d88a662b4f	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-07-15 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.954+00	2026-01-05 21:09:52.954+00	t	Importada de JSONL. Empresa: MOSCUZZA. Especie: LANGOSTINO	MC	30
17dda418-ca0d-4d52-9a1c-d7cc167ff0b0	2025	122	06f76a6f-dd4e-490c-b6a2-ee9a8ebcff3d	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-07-16 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.969+00	2026-01-05 21:09:52.969+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: VIEIRA	MC	30
70af6aa7-6448-4204-8804-38f86f0f9b1d	2025	123	96658434-ad2a-473b-a532-d2afe15cb4d2	\N	e1466c46-8d9b-4f0d-8903-c543a05b8510	2025-07-19 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.978+00	2026-01-05 21:09:52.978+00	t	Importada de JSONL. Empresa: GIORNO S.A. Especie: MERLUZA	MC	30
c6b21f6b-bafd-4d8d-b71f-ece9166b9236	2025	124	5b5f41c3-a95b-4043-8ac1-3c0fda0d92b4	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-07-19 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.985+00	2026-01-05 21:09:52.985+00	t	Importada de JSONL. Empresa: GIORNO S.A. Especie: MERLUZA	MC	30
1aa026c9-1ee7-488e-9c75-da424e229acc	2025	125	c573e0fc-6f82-4795-bfcc-b49b981977d8	\N	e1466c46-8d9b-4f0d-8903-c543a05b8510	2025-07-18 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.992+00	2026-01-05 21:09:52.992+00	t	Importada de JSONL. Empresa: CONARPESA. Especie: LANGOSTINO	MC	30
6d766260-570a-4646-a7ef-4d797b1bd6ae	2025	126	b6c82a60-965d-4e57-bf7e-9d1a4a9347bc	\N	e1466c46-8d9b-4f0d-8903-c543a05b8510	2025-07-18 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:52.998+00	2026-01-05 21:09:52.998+00	t	Importada de JSONL. Empresa: BUENA PROA. Especie: LANGOSTINO	MC	30
a11c1875-5405-4357-a37a-4551bd404017	2025	127	ce547e0d-f287-43c9-8fb6-81511555fd97	\N	e1466c46-8d9b-4f0d-8903-c543a05b8510	2025-07-18 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:53.003+00	2026-01-05 21:09:53.003+00	t	Importada de JSONL. Empresa: CONARPESA. Especie: LANGOSTINO	MC	30
514dbd2f-cb9b-4407-baa8-12bcd209a7a7	2025	128	c2a51fd6-0460-44a8-a592-31d65e1f29da	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-07-18 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:53.008+00	2026-01-05 21:09:53.008+00	t	Importada de JSONL. Empresa: PEDRO MOSCUZZA E HIJO. Especie: MERLUZA	MC	30
4f9e1e6d-827c-4cb4-9d82-069772c24520	2025	129	709d205f-9448-48c3-b891-6ce1a72ba370	\N	69b9484e-11e9-459f-9f5a-dcdbeba2111b	2025-07-21 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:53.014+00	2026-01-05 21:09:53.014+00	t	Importada de JSONL. Empresa: PEDRO MOSCUZZA E HIJO. Especie: LANGOSTINO	MC	30
17b41229-7629-4b9f-b81f-1f1d27e9d741	2025	130	88efd36d-e7a9-4a1d-b0c2-14c6e6ae1759	\N	e1466c46-8d9b-4f0d-8903-c543a05b8510	2025-07-22 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:53.022+00	2026-01-05 21:09:53.022+00	t	Importada de JSONL. Empresa: IBERCONSA. Especie: LANGOSTINO	MC	30
2de4ee7b-f5b3-4cf2-8b9a-2e49ed7da9e1	2025	131	caf540e1-2de2-417b-8013-a71bfca2e092	\N	e1466c46-8d9b-4f0d-8903-c543a05b8510	2025-07-22 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:53.026+00	2026-01-05 21:09:53.026+00	t	Importada de JSONL. Empresa: EMPESUR. Especie: LANGOSTINO	MC	30
ef1a04e9-e54f-49d6-8702-d06678d085ef	2025	132	43b2abc2-ba48-41e1-8c89-a7d200779999	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-07-23 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:53.031+00	2026-01-05 21:09:53.031+00	t	Importada de JSONL. Empresa: BUENOS AIRES PESCA S.A. Especie: LANGOSTINO	MC	30
926aed79-e3b5-49e5-9b89-33e53b405d74	2025	133	4a0d4c08-b929-4075-a17c-0a0d479f4cc4	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-07-23 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:53.041+00	2026-01-05 21:09:53.041+00	t	Importada de JSONL. Empresa: BUENOS AIRES PESCA S.A. Especie: LANGOSTINO	MC	30
3cb66381-ef63-4747-8c8a-a2b417319718	2025	134	b6c82a60-965d-4e57-bf7e-9d1a4a9347bc	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-07-25 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:53.047+00	2026-01-05 21:09:53.047+00	t	Importada de JSONL. Empresa: BUENA PROA. Especie: LANGOSTINO	MC	30
2a8c6c87-02df-480a-8ba4-fd620b2bdc5f	2025	135	a345ae7d-ecba-4f38-b94f-8010e22d3615	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-07-27 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:53.054+00	2026-01-05 21:09:53.054+00	t	Importada de JSONL. Empresa: ARPES. Especie: MERLUZA	MC	30
033e9eb9-741b-4231-91e3-648566fccfa2	2025	136	e113b2d7-af93-44fe-a26e-805429efdd48	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-07-28 03:00:00+00	\N	\N	42	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:53.065+00	2026-01-05 21:09:53.065+00	t	Importada de JSONL. Empresa: CRUSTACEOS DEL SUR S.A. Especie: CENTOLLA	MC	60
bd6dda78-8b56-4512-8655-bd8854d29cc4	2025	137	018c208f-da6a-4ac0-abb6-5bf2c331bc79	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-07-29 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:53.071+00	2026-01-05 21:09:53.071+00	t	Importada de JSONL. Empresa: CENTOMAR S.A. Especie: LANGOSTINO	MC	30
2080b341-36db-4ddf-ba40-3ed8b23725ab	2025	138	cd75ece7-2b18-4241-b2b4-d8d799734efe	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-08-04 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:53.078+00	2026-01-05 21:09:53.078+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: LANGOSTINO	MC	30
cc4d7e35-a911-4291-831f-c8558971c222	2025	139	9a2759e2-5da5-4b77-9464-0dc62ce3ca3a	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-08-02 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:53.088+00	2026-01-05 21:09:53.088+00	t	Importada de JSONL. Empresa: BUENA PROA. Especie: LANGOSTINO	MC	30
0ea2f5b7-a551-4c6f-819f-cd7261fb412f	2025	140	707e7433-8d6d-4a14-9bf9-3285f3528459	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-08-05 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:53.094+00	2026-01-05 21:09:53.094+00	t	Importada de JSONL. Empresa: ARBUMASA S.A. Especie: LANGOSTINO	MC	30
54d70074-cda9-4622-81a9-f492bf4449e4	2025	141	f18f5aef-2646-47ad-8b3f-ac91a2251139	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-08-05 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:53.101+00	2026-01-05 21:09:53.101+00	t	Importada de JSONL. Empresa: ARBUMASA S.A. Especie: LANGOSTINO	MC	30
e48d6233-bd59-4203-9656-2b04e946e1d1	2025	142	8f31ff24-aea0-4f47-b713-6f9a6a68c51c	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-08-06 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:53.107+00	2026-01-05 21:09:53.107+00	t	Importada de JSONL. Empresa: SOLIMENO E HIJOS. Especie: MERLUZA	MC	30
96f6965f-87d7-45ae-9db4-ac79baed652a	2025	143	6a728901-f71b-477d-93e9-d7375a764fc7	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-08-07 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:53.119+00	2026-01-05 21:09:53.119+00	t	Importada de JSONL. Empresa: PEDRO MOSCUZZA E HIJO. Especie: LANGOSTINO	MC	30
cccc809f-2a70-47c1-b8cb-210be07c8546	2025	144	6de2f9cb-240f-448a-9903-5d304a1bc430	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-08-07 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:53.126+00	2026-01-05 21:09:53.126+00	t	Importada de JSONL. Empresa: PEDRO MOSCUZZA E HIJO. Especie: LANGOSTINO	MC	30
751b5025-8cc3-4fe5-b137-521974ed17f2	2025	145	0f881509-65a1-4ec3-9294-30122065d1fc	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-08-12 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:53.132+00	2026-01-05 21:09:53.132+00	t	Importada de JSONL. Empresa: ANTONIO BALDINO E HIJOS. Especie: MERLUZA	MC	30
9c7eac54-3810-43a9-8c1f-683babcc51d6	2025	146	2eb261d6-3a02-44b5-9330-0ca6d5fc4b45	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-08-14 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:53.145+00	2026-01-05 21:09:53.145+00	t	Importada de JSONL. Empresa: MARONTI  S.A.. Especie: MERLUZA	MC	30
b9d25ef7-f29a-46a7-9541-8d0a8c4f8854	2025	147	5b5f41c3-a95b-4043-8ac1-3c0fda0d92b4	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-08-19 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:53.156+00	2026-01-05 21:09:53.156+00	t	Importada de JSONL. Empresa: GIORNO S.A. Especie: MERLUZA	MC	30
b32debc4-4a13-41cd-83ef-c9862b6a6e60	2025	148	baa51d9d-0d53-46ec-a79f-975ae69bdca5	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-08-18 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:53.162+00	2026-01-05 21:09:53.162+00	t	Importada de JSONL. Empresa: XEITOSIÑO. Especie: LANGOSTINO	MC	30
7a76f317-78b7-40ef-8041-9eb2bb27af58	2025	149	e16204c0-cffc-456a-99bf-457493c02b05	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-08-19 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:53.17+00	2026-01-05 21:09:53.17+00	t	Importada de JSONL. Empresa: XEITOSIÑO. Especie: LANGOSTINO	MC	30
d4f7dee3-0df8-493f-86bb-2e5e4fb85d6f	2025	150	bdf59426-0960-4694-af45-e384c786545e	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-08-25 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:53.177+00	2026-01-05 21:09:53.177+00	t	Importada de JSONL. Empresa: CONARPESA. Especie: LANGOSTINO	MC	30
f1acff9b-9e6f-4337-8b2c-7384cbbaf18c	2025	151	423261e8-4005-4600-a12e-852c05665a73	\N	e1466c46-8d9b-4f0d-8903-c543a05b8510	2025-08-29 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:53.184+00	2026-01-05 21:09:53.184+00	t	Importada de JSONL. Empresa: GIORNO. Especie: LANGOSTINO	MC	30
e7ec54ee-b5c6-422d-b83e-497aab03235a	2025	152	bbfb5f3e-a564-4da0-80b8-83ed51aa438f	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-08-29 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:53.188+00	2026-01-05 21:09:53.188+00	t	Importada de JSONL. Empresa: PESQUERA VERAZ SA. Especie: LANGOSTINO	MC	30
19e8a2e0-fe06-4eab-b069-836d9cc7e095	2025	153	c2a51fd6-0460-44a8-a592-31d65e1f29da	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-08-30 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:53.195+00	2026-01-05 21:09:53.195+00	t	Importada de JSONL. Empresa: PEDRO MOSCUZZA E HIJO. Especie: MERLUZA	MC	30
e23a9208-60d1-4ead-92ad-c66c38e025ba	2025	154	0908ae91-387f-4e20-b9ba-dfa7f9ad09cc	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-09-05 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:53.202+00	2026-01-05 21:09:53.202+00	t	Importada de JSONL. Empresa: ARGENOVA S.A. Especie: LANGOSTINO	MC	30
30896d26-473f-4151-95e3-c4a2870a0ab7	2025	155	06f76a6f-dd4e-490c-b6a2-ee9a8ebcff3d	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-09-08 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:53.208+00	2026-01-05 21:09:53.208+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: VIEIRA	MC	30
54238aaf-a916-4d8c-8169-a6cd101b4551	2025	156	e113b2d7-af93-44fe-a26e-805429efdd48	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-09-11 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:53.215+00	2026-01-05 21:09:53.215+00	t	Importada de JSONL. Empresa: CRUSTACEOS DEL SUR S.A. Especie: CENTOLLA	MC	30
9288691f-28a2-476d-8aeb-2c9404b2e17f	2025	157	23ac29de-0af1-4f8e-868b-eb86171fa067	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-09-10 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:53.221+00	2026-01-05 21:09:53.221+00	t	Importada de JSONL. Empresa: PESCASOL S.A. Especie: MERLUZA	MC	30
cb32aa68-18cc-4877-8d21-7679c676d815	2025	158	f18f5aef-2646-47ad-8b3f-ac91a2251139	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-09-13 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:53.229+00	2026-01-05 21:09:53.229+00	t	Importada de JSONL. Empresa: ARBUMASA S.A. Especie: LANGOSTINO	MC	30
d3fc2e88-ce02-49b7-ad3c-6cb771fd241e	2025	159	ce9995e9-716c-4ef7-b6f1-63b2bd5f54e8	\N	e715ca3a-b1a3-46f9-93dd-bc46231d00b5	2025-09-11 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:53.235+00	2026-01-05 21:09:53.235+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: CENTOLLA	MC	30
7f0fdc9f-35d9-4f56-be07-34a265d44c65	2025	160	01250855-bee5-42b0-afbf-a342b210ca79	\N	e715ca3a-b1a3-46f9-93dd-bc46231d00b5	2025-09-11 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:53.242+00	2026-01-05 21:09:53.242+00	t	Importada de JSONL. Empresa: CENTOMAR S.A. Especie: CENTOLLA	MC	30
20c472b3-fabb-4fb4-aff1-52bf1e7824e2	2025	162	e85d97cf-ab2e-4639-8168-2c1783e4273a	\N	6aa3e1af-c033-4aab-a945-e1d1736f9348	2025-09-11 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:53.255+00	2026-01-05 21:09:53.255+00	t	Importada de JSONL. Empresa: BENTONICOS DE ARGENTINA. Especie: CENTOLLA	MC	30
c472d04a-981c-440b-9d39-1fe5179a970a	2025	163	5d2e398a-7f96-4c2b-a455-58da21ceb1ff	\N	e715ca3a-b1a3-46f9-93dd-bc46231d00b5	2025-09-17 03:00:00+00	\N	\N	61	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:53.262+00	2026-01-05 21:09:53.262+00	t	Importada de JSONL. Empresa: PESANTAR. Especie: MERLUZA AUSTRAL	MC	30
f135f85b-f314-4211-898d-90a9053374a7	2025	164	e16204c0-cffc-456a-99bf-457493c02b05	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-09-19 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:53.27+00	2026-01-05 21:09:53.27+00	t	Importada de JSONL. Empresa: XEITOSIÑO. Especie: LANGOSTINO	MC	30
a91fc07b-d392-4fa2-b919-d1c99ffb94fc	2025	165	9b521dd3-43c9-4aa5-b948-7d6356cf1930	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	2025-09-29 03:00:00+00	\N	\N	31	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:53.277+00	2026-01-05 21:09:53.277+00	t	Importada de JSONL. Empresa: ESTREMAR. Especie: MERLUZA AUSTRAL	MC	30
35084f5f-291a-4396-8c74-0c9106761c72	2025	166	81d1eda7-b157-4fee-a647-8bce8e62efbc	\N	e715ca3a-b1a3-46f9-93dd-bc46231d00b5	2025-09-29 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:53.284+00	2026-01-05 21:09:53.284+00	t	Importada de JSONL. Empresa: ARGENOVA. Especie: MERLUZA AUSTRAL	MC	30
e5047731-c818-48ff-a2a0-8ea5fba090e3	2025	167	969e6d80-f91a-422a-b8c8-949b3b8a2834	\N	e715ca3a-b1a3-46f9-93dd-bc46231d00b5	2025-09-26 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:53.29+00	2026-01-05 21:09:53.29+00	t	Importada de JSONL. Empresa: PESQUERA VERAZ S.A. Especie: MERLUZA	MC	30
3d877597-8d10-4ba1-bde2-25c8e8818454	2025	168	c2a51fd6-0460-44a8-a592-31d65e1f29da	\N	e715ca3a-b1a3-46f9-93dd-bc46231d00b5	2025-10-14 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:53.306+00	2026-01-05 21:09:53.306+00	t	Importada de JSONL. Empresa: PEDRO MOSCUZZA E HIJO. Especie: MERLUZA	MC	30
5a6bbfa4-a098-4b19-99aa-cc3ffdfbaafb	2025	169	395ed19d-038a-42c9-95cc-db61a21fdb8b	\N	6aa3e1af-c033-4aab-a945-e1d1736f9348	2025-10-12 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:53.313+00	2026-01-05 21:09:53.313+00	t	Importada de JSONL. Empresa: CRUSTACEOS DEL SUR S.A. Especie: CENTOLLA	MC	60
93693fac-b9cf-4581-a11b-0a40d643de14	2025	170	b6c82a60-965d-4e57-bf7e-9d1a4a9347bc	\N	e715ca3a-b1a3-46f9-93dd-bc46231d00b5	2025-10-18 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:53.318+00	2026-01-05 21:09:53.318+00	t	Importada de JSONL. Empresa: BUENA PROA. Especie: MERLUZA	MC	30
29b952e7-e297-4266-9291-8620c4ac7f07	2025	171	6ddb602a-7854-408e-8674-0e787933e02e	\N	6aa3e1af-c033-4aab-a945-e1d1736f9348	2025-10-30 03:00:00+00	\N	\N	6	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:53.328+00	2026-01-05 21:09:53.328+00	t	Importada de JSONL. Empresa: GLACIAR PESQUERA. Especie: VIEIRA	MC	60
132a2d01-f41a-4723-9e46-50e97f71f404	2025	172	e113b2d7-af93-44fe-a26e-805429efdd48	\N	e715ca3a-b1a3-46f9-93dd-bc46231d00b5	2025-10-23 03:00:00+00	\N	\N	30	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:53.335+00	2026-01-05 21:09:53.335+00	t	Importada de JSONL. Empresa: CRUSTACEOS DEL SUR S.A. Especie: CENTOLLA	MC	30
3ff96bdc-e6e2-4e15-9a5f-400a00142602	2025	173	9b521dd3-43c9-4aa5-b948-7d6356cf1930	\N	e715ca3a-b1a3-46f9-93dd-bc46231d00b5	2025-09-29 03:00:00+00	\N	\N	22	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:53.341+00	2026-01-05 21:09:53.341+00	t	Importada de JSONL. Empresa: ESTREMAR. Especie: MERLUZA AUSTRAL	MC	30
aec58204-f489-4d6f-a981-3b42ca4a341b	2025	174	06f76a6f-dd4e-490c-b6a2-ee9a8ebcff3d	\N	6aa3e1af-c033-4aab-a945-e1d1736f9348	2025-10-27 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:53.347+00	2026-01-05 21:09:53.347+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: VIEIRA	MC	30
424cd44c-1238-4a44-8b91-f642c33169e4	2025	175	8adaf55b-8d2e-4403-90ca-0db212a2eaad	\N	6aa3e1af-c033-4aab-a945-e1d1736f9348	2025-10-31 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:53.353+00	2026-01-05 21:09:53.353+00	t	Importada de JSONL. Empresa: SOLIMENO e HIJOS S.A. Especie: MERLUZA	MC	30
03f39242-83f3-4606-9af8-bb52b2e5691a	2025	176	0f881509-65a1-4ec3-9294-30122065d1fc	\N	e715ca3a-b1a3-46f9-93dd-bc46231d00b5	2025-11-01 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:53.365+00	2026-01-05 21:09:53.365+00	t	Importada de JSONL. Empresa: ROTELLO S.A. Especie: MERLUZA	MC	30
16769449-70e9-4830-91df-fdb05cfda24f	2025	177	a345ae7d-ecba-4f38-b94f-8010e22d3615	\N	6aa3e1af-c033-4aab-a945-e1d1736f9348	2025-11-03 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:53.372+00	2026-01-05 21:09:53.372+00	t	Importada de JSONL. Empresa: ARPES S.A. Especie: MERLUZA	MC	30
d5596483-4141-4dbe-b48b-89012e691760	2025	178	01250855-bee5-42b0-afbf-a342b210ca79	\N	6aa3e1af-c033-4aab-a945-e1d1736f9348	2025-11-06 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:53.385+00	2026-01-05 21:09:53.385+00	t	Importada de JSONL. Empresa: CENTOMAR S.A. Especie: CENTOLLA	MC	30
fd8f8843-0481-47d7-825a-1a8f99650ab0	2025	179	466c8660-d50c-4d0e-bba9-727034f6bb2a	\N	e715ca3a-b1a3-46f9-93dd-bc46231d00b5	2025-11-04 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:53.394+00	2026-01-05 21:09:53.394+00	t	Importada de JSONL. Empresa: AIRE MARINO. Especie: ANCHOÍTA	MC	30
361d3933-1f72-4b73-9a61-b6e0f59c8765	2025	180	ce9995e9-716c-4ef7-b6f1-63b2bd5f54e8	\N	6aa3e1af-c033-4aab-a945-e1d1736f9348	2025-11-10 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:53.401+00	2026-01-05 21:09:53.401+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: CENTOLLA	MC	30
8e16409e-972b-48dd-9ed5-e9c74a66d9f5	2025	181	f494b1f2-975d-458d-8b0e-21f1e7540a83	\N	6aa3e1af-c033-4aab-a945-e1d1736f9348	2025-11-10 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:53.409+00	2026-01-05 21:09:53.409+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: VIEIRA	MC	30
443ec94f-0465-46b4-a4ec-4d9a1c012736	2025	182	5d2e398a-7f96-4c2b-a455-58da21ceb1ff	\N	69b9484e-11e9-459f-9f5a-dcdbeba2111b	2025-11-20 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:53.416+00	2026-01-05 21:09:53.416+00	t	Importada de JSONL. Empresa: PESANTAR. Especie: MERLUZA AUSTRAL	MC	30
eae8128f-4c82-49d7-a943-fa363d23a025	2025	184	2c28cc5a-890c-4152-b972-78aeb3ad281c	\N	69b9484e-11e9-459f-9f5a-dcdbeba2111b	2025-11-26 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:53.429+00	2026-01-05 21:09:53.429+00	t	Importada de JSONL. Empresa: PRODESUR. Especie: MERLUZA AUSTRAL	MC	60
b19c9c30-bb96-40bf-a49b-775465d36c79	2025	186	6ddb602a-7854-408e-8674-0e787933e02e	\N	69b9484e-11e9-459f-9f5a-dcdbeba2111b	2025-12-15 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:53.442+00	2026-01-05 21:09:53.442+00	t	Importada de JSONL. Empresa: GLACIAR PESQUERA. Especie: VIEIRA	MC	30
7c44efd9-7014-4dd0-b9c7-79ba62ddc27e	2025	187	06f76a6f-dd4e-490c-b6a2-ee9a8ebcff3d	\N	69b9484e-11e9-459f-9f5a-dcdbeba2111b	2025-12-15 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:53.448+00	2026-01-05 21:09:53.448+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: VIEIRA	MC	30
303c427b-cdff-4309-bd0b-3f4caf98bab5	2025	188	9b521dd3-43c9-4aa5-b948-7d6356cf1930	\N	596d396b-a7db-46f6-a9ba-a525b7cc75a5	2025-12-29 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:53.455+00	2026-01-05 21:09:53.455+00	t	Importada de JSONL. Empresa: ESTREMAR S.A. Especie: MERLUZA AUSTRAL	MC	30
34db321f-b286-48f6-b61f-f44509898775	2025	189	fc67a193-73d3-42e6-9aa7-7811e559cbfb	\N	596d396b-a7db-46f6-a9ba-a525b7cc75a5	2025-12-26 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:53.461+00	2026-01-05 21:09:53.461+00	t	Importada de JSONL. Empresa: CHIARPESCA. Especie: CALAMAR	MC	30
1026ef4f-3fcc-4a84-81b6-6d4348392a32	2025	190	206d0307-0af3-419a-99d5-165c7b85f486	\N	596d396b-a7db-46f6-a9ba-a525b7cc75a5	2025-12-29 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:53.467+00	2026-01-05 21:09:53.467+00	t	Importada de JSONL. Empresa: ARGENOVA. Especie: CALAMAR	MC	30
703f8ca5-aa24-459b-b097-8bb19c76e642	2025	191	7db9cb20-afb3-4813-8204-a04743b23b3f	\N	596d396b-a7db-46f6-a9ba-a525b7cc75a5	2025-12-29 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:53.474+00	2026-01-05 21:09:53.474+00	t	Importada de JSONL. Empresa: ALTAMARE S.AS. Especie: CALAMAR	MC	30
07aea281-00d0-4126-89e2-ca221df02dcd	2025	192	68f3ea0a-6f01-4699-af7d-6f6b57816794	\N	596d396b-a7db-46f6-a9ba-a525b7cc75a5	2025-12-26 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:53.48+00	2026-01-05 21:09:53.48+00	t	Importada de JSONL. Empresa: PESQUERÍA  RÍO QUEQUEN. Especie: CALAMAR	MC	30
fb8d7763-2397-4b93-82a4-3e6ba9aeb86b	2025	193	6f09eaac-4d86-4a68-ac5e-1331d2c14911	\N	596d396b-a7db-46f6-a9ba-a525b7cc75a5	2025-12-26 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:53.487+00	2026-01-05 21:09:53.487+00	t	Importada de JSONL. Empresa: PESQUERÍA  RÍO QUEQUEN. Especie: CALAMAR	MC	30
93354546-0f09-4f3f-95a0-00763ff755d9	2025	194	01250855-bee5-42b0-afbf-a342b210ca79	\N	596d396b-a7db-46f6-a9ba-a525b7cc75a5	2025-12-26 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:53.493+00	2026-01-05 21:09:53.493+00	t	Importada de JSONL. Empresa: CENTOMAR S.A. Especie: CENTOLLA	MC	30
c701df10-fd15-4d68-bb12-b8f3dee68a93	2025	195	395ed19d-038a-42c9-95cc-db61a21fdb8b	\N	596d396b-a7db-46f6-a9ba-a525b7cc75a5	2025-12-30 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:53.5+00	2026-01-05 21:09:53.5+00	t	Importada de JSONL. Empresa: CRUSTACEOS DEL SUR S.A. Especie: CENTOLLA	MC	30
04a1cdbe-7149-4e8d-977c-44f6d2f4a7e8	2025	185	969e6d80-f91a-422a-b8c8-949b3b8a2834	\N	1e03e6f5-cb29-44d9-a0f6-2972094864a5	2025-12-01 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:53.436+00	2026-01-08 20:02:42.962+00	t	Importada de JSONL. Empresa: PESQUERA VERAZ S.A. Especie: MERLUZA	MC	30
75a873cf-209e-4153-9151-bf4bb2d1458a	2025	161	963558b2-f1a1-462a-bb0c-e1c47eebb71b	\N	1e03e6f5-cb29-44d9-a0f6-2972094864a5	2025-09-11 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:53.249+00	2026-01-08 22:30:19.032+00	t	Importada de JSONL. Empresa: BENTONICOS DE ARGENTINA. Especie: CENTOLLA	MC	30
fbcbbf37-d9f9-40de-8cfb-064542565b7d	2025	196	963558b2-f1a1-462a-bb0c-e1c47eebb71b	\N	69b9484e-11e9-459f-9f5a-dcdbeba2111b	2025-12-23 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:53.507+00	2026-01-05 21:09:53.507+00	t	Importada de JSONL. Empresa: BENTONICOS DE ARGENTINA. Especie: CENTOLLA	MC	30
45b99544-0bf2-47b8-a879-d768d53e9d23	2025	197	e85d97cf-ab2e-4639-8168-2c1783e4273a	\N	596d396b-a7db-46f6-a9ba-a525b7cc75a5	2025-12-30 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:53.516+00	2026-01-05 21:09:53.516+00	t	Importada de JSONL. Empresa: BENTONICOS DE ARGENTINA. Especie: CENTOLLA	MC	30
e75b68eb-8771-4c46-969d-b740711a69e1	2025	198	95444611-ad7f-4532-a8cb-4e71b9dff4de	\N	596d396b-a7db-46f6-a9ba-a525b7cc75a5	2025-12-29 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:53.523+00	2026-01-05 21:09:53.523+00	t	Importada de JSONL. Empresa: GIORNO. Especie: CALAMAR	MC	30
b7b1cba7-1a9f-4f81-bf9e-91fd85368074	2025	199	426cfd83-e5ac-4d02-a611-f1b4d445321f	\N	596d396b-a7db-46f6-a9ba-a525b7cc75a5	2025-12-26 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:53.53+00	2026-01-05 21:09:53.53+00	t	Importada de JSONL. Empresa: GLACIAR PESQUERA. Especie: VIEIRA	MC	30
7bed6c63-432e-4372-94ed-08c541cebdcb	2025	200	78a9b02e-953a-4fc7-b955-2169483d1537	\N	596d396b-a7db-46f6-a9ba-a525b7cc75a5	2025-12-28 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:53.542+00	2026-01-05 21:09:53.542+00	t	Importada de JSONL. Empresa: LUIS SOLIMENO. Especie: CALAMAR	MC	30
323b4701-fc99-470f-a91b-d37621df5fd0	2025	201	794029cb-c7d3-4d57-9d44-625a11b6da5d	7779dd38-9a6a-4ef8-b589-6eaf89b03dbe	596d396b-a7db-46f6-a9ba-a525b7cc75a5	2025-12-28 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-05 21:09:53.548+00	2026-01-09 20:30:09.755+00	t	Importada de JSONL. Empresa: PESQUERA COMERCIAL. Especie: CALAMAR	MC	30
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
9196c09e-6103-46b6-b45e-4e679f634162	bb26bbcb-ee6d-4370-9c16-84f03d8d362b	1	ffd18c57-fb77-4959-9191-1a7cf0a17664	caf4d1b5-7a3c-445b-98f9-42d842f1d347	86f70064-a55b-4d55-b7e9-dc3f320c4cc1	2025-11-20 03:00:00+00	2025-12-16 03:00:00+00	COMERCIAL	Etapa generada automáticamente (sin desglose)
dd92e43b-10fe-45a8-bac1-763e3161f51d	9076d345-9540-4afd-adb6-23d9fb452797	1	c85b8285-3bc6-43bc-b664-4b675ee2876d	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-01-03 03:00:00+00	2025-01-03 03:00:00+00	COMERCIAL	Etapa 1 importada
cd54530b-2eb9-42ec-b04f-15dc7aef3709	b27d3a0e-7338-439e-9acc-3cdec348b830	1	c85b8285-3bc6-43bc-b664-4b675ee2876d	caf4d1b5-7a3c-445b-98f9-42d842f1d347	caf4d1b5-7a3c-445b-98f9-42d842f1d347	2025-01-28 03:00:00+00	2025-01-28 03:00:00+00	COMERCIAL	Etapa 1 importada
fa195896-5843-4352-a04a-419b3706bda6	f9d47889-b2a5-45d9-b918-3e8ca33ae8de	1	ffd18c57-fb77-4959-9191-1a7cf0a17664	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-01-03 03:00:00+00	2025-03-04 03:00:00+00	COMERCIAL	Etapa 1 importada
4fc05038-94e4-4720-a036-c52f2c217748	0e1101d5-a8a5-4fc6-bd6c-8e6d5bf5a187	1	bec74e80-f32e-4e58-9588-35bd863f8715	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-01-11 03:00:00+00	2025-03-07 03:00:00+00	COMERCIAL	Etapa 1 importada
f98a2218-abde-482d-b730-2e1ebe9355ef	90479d64-7113-423c-89f4-13a0bfbf9975	1	bec74e80-f32e-4e58-9588-35bd863f8715	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-01-07 03:00:00+00	2025-01-28 03:00:00+00	COMERCIAL	Etapa 1 importada
1afa671a-a689-44d6-be5c-adf196d31b4a	a686b746-2f99-45f9-9b48-9e858b4863f2	1	551b3773-09f9-4eb6-a9ce-88abf50b63a1	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-01-08 03:00:00+00	2025-02-02 03:00:00+00	COMERCIAL	Etapa 1 importada
aadb0816-53eb-4cee-8f76-a06cf4bcd070	2dfe6d99-7c81-4b76-a87d-5a23757b0349	1	551b3773-09f9-4eb6-a9ce-88abf50b63a1	caf4d1b5-7a3c-445b-98f9-42d842f1d347	caf4d1b5-7a3c-445b-98f9-42d842f1d347	2025-01-07 03:00:00+00	2025-01-30 03:00:00+00	COMERCIAL	Etapa 1 importada
755fa33b-4e6f-4186-92cc-8ffc6ee2b018	4f0eaeb5-1488-43fc-8e7b-6f7bad09c614	1	bec74e80-f32e-4e58-9588-35bd863f8715	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-01-11 03:00:00+00	2025-01-19 03:00:00+00	COMERCIAL	Etapa 1 importada
2dc69255-ca6a-4228-911b-717383cecdba	4f0eaeb5-1488-43fc-8e7b-6f7bad09c614	2	bec74e80-f32e-4e58-9588-35bd863f8715	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-01-22 03:00:00+00	2025-01-29 03:00:00+00	COMERCIAL	Etapa 2 importada
f79d8ded-61a3-40e5-bce7-68f83297ad41	4f0eaeb5-1488-43fc-8e7b-6f7bad09c614	3	bec74e80-f32e-4e58-9588-35bd863f8715	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-01-31 03:00:00+00	2025-02-02 03:00:00+00	COMERCIAL	Etapa 3 importada
64d79403-d8ec-4ba7-93ca-e77c835ed50e	efce3e7d-3fc3-46fb-a508-be8cc580ad53	1	79d74266-23c8-4096-b660-cda06d12272c	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-01-06 03:00:00+00	2025-02-07 03:00:00+00	COMERCIAL	Etapa 1 importada
66cf951a-f6b7-449b-a3bf-69301900d254	694ed401-8843-4363-9266-8d1011a20a59	1	79d74266-23c8-4096-b660-cda06d12272c	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-01-13 03:00:00+00	2025-02-24 03:00:00+00	COMERCIAL	Etapa 1 importada
6da011c9-a0f6-4e41-b26d-2b8966b5a648	66c81c16-f6c2-4d97-bcf7-42ce652ccdb9	1	551b3773-09f9-4eb6-a9ce-88abf50b63a1	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	2025-01-08 03:00:00+00	2025-02-02 03:00:00+00	COMERCIAL	Etapa 1 importada
d7e865d7-077d-470d-ac79-295145f0d225	200384e0-1776-4b38-be51-fee06de25c14	1	79d74266-23c8-4096-b660-cda06d12272c	\N	\N	2025-01-09 03:00:00+00	2025-02-16 03:00:00+00	COMERCIAL	Etapa 1 importada
284cbd61-cf83-44b6-90bf-f0dcdef6e18a	07ce19a1-da51-4871-8185-c1e809a5efcb	1	ffd18c57-fb77-4959-9191-1a7cf0a17664	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-01-08 03:00:00+00	2025-02-17 03:00:00+00	COMERCIAL	Etapa 1 importada
4e0718e3-01d4-45ad-b8f5-48693e7d3507	5b1347dd-d6f2-4250-94b2-726ef6000f4d	1	551b3773-09f9-4eb6-a9ce-88abf50b63a1	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-01-09 03:00:00+00	2025-02-13 03:00:00+00	COMERCIAL	Etapa 1 importada
ce0361fc-82ce-4896-8c1a-87f8212a0062	f1d03daf-0f1d-478e-ba2f-58bcd4251ec1	1	bec74e80-f32e-4e58-9588-35bd863f8715	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-01-12 03:00:00+00	2025-01-19 03:00:00+00	COMERCIAL	Etapa 1 importada
bb27ff74-f42b-44d6-b5ec-984812fb7a90	f1d03daf-0f1d-478e-ba2f-58bcd4251ec1	2	bec74e80-f32e-4e58-9588-35bd863f8715	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-01-20 03:00:00+00	2025-01-26 03:00:00+00	COMERCIAL	Etapa 2 importada
11de3b20-45a4-4b83-a319-80dbd3060da9	f1d03daf-0f1d-478e-ba2f-58bcd4251ec1	3	bec74e80-f32e-4e58-9588-35bd863f8715	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-01-28 03:00:00+00	2025-02-06 03:00:00+00	COMERCIAL	Etapa 3 importada
17a03ec0-c822-4420-a866-2a9e83ee866e	f1d03daf-0f1d-478e-ba2f-58bcd4251ec1	4	bec74e80-f32e-4e58-9588-35bd863f8715	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-02-07 03:00:00+00	2025-02-12 03:00:00+00	COMERCIAL	Etapa 4 importada
e6787391-c5d2-47b0-8d88-5bc3ab3ef903	d2639d24-4795-4baa-b356-7fa928ecf78b	1	79d74266-23c8-4096-b660-cda06d12272c	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-01-17 03:00:00+00	2025-03-01 03:00:00+00	COMERCIAL	Etapa 1 importada
b7376a50-6cbc-4ece-abb3-237e7a3d521c	482360a2-d80f-4f65-a829-c3c9dee01c6d	1	551b3773-09f9-4eb6-a9ce-88abf50b63a1	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	2025-01-16 03:00:00+00	2025-01-18 03:00:00+00	COMERCIAL	Etapa 1 importada
f85f17e7-482f-43ac-9965-2081f146cc01	2ab0f251-d267-40eb-9f3c-b02f62a1cd45	1	551b3773-09f9-4eb6-a9ce-88abf50b63a1	\N	\N	2025-01-16 03:00:00+00	2025-03-11 03:00:00+00	COMERCIAL	Etapa 1 importada
fd5c6074-99b8-46cc-91d6-6fb8e1f7002b	0fbd898d-e869-4369-9692-98d41b56b242	1	ffd18c57-fb77-4959-9191-1a7cf0a17664	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	2025-01-27 03:00:00+00	2025-02-07 03:00:00+00	COMERCIAL	Etapa 1 importada
5062c285-de73-4aeb-81ae-7f468b777e12	9fadd20b-03d6-458b-9b34-96e3f19b3c18	1	551b3773-09f9-4eb6-a9ce-88abf50b63a1	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-02-03 03:00:00+00	2025-03-11 03:00:00+00	COMERCIAL	Etapa 1 importada
a7e853ac-50ee-41e0-adbf-9f041860095d	cda9eb74-e671-48d8-8c0b-3370d4b54256	1	ffd18c57-fb77-4959-9191-1a7cf0a17664	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	2025-02-03 03:00:00+00	2025-03-12 03:00:00+00	COMERCIAL	Etapa 1 importada
8eb43544-8ba1-48ba-81af-5630b5fe3e6c	51896655-508e-4ea2-b53c-9d6c60f3f122	1	551b3773-09f9-4eb6-a9ce-88abf50b63a1	caf4d1b5-7a3c-445b-98f9-42d842f1d347	caf4d1b5-7a3c-445b-98f9-42d842f1d347	2025-01-31 03:00:00+00	2025-03-24 03:00:00+00	COMERCIAL	Etapa 1 importada
d213ae78-5e6a-44ce-85a5-1a58b0bc4082	621c1b94-90a8-4a2c-881a-7c21284b67be	1	551b3773-09f9-4eb6-a9ce-88abf50b63a1	caf4d1b5-7a3c-445b-98f9-42d842f1d347	caf4d1b5-7a3c-445b-98f9-42d842f1d347	2025-01-28 03:00:00+00	2025-02-23 03:00:00+00	COMERCIAL	Etapa 1 importada
62d00051-ae68-4851-94b8-343deecbb029	621c1b94-90a8-4a2c-881a-7c21284b67be	2	551b3773-09f9-4eb6-a9ce-88abf50b63a1	caf4d1b5-7a3c-445b-98f9-42d842f1d347	caf4d1b5-7a3c-445b-98f9-42d842f1d347	2025-02-25 03:00:00+00	2025-04-06 03:00:00+00	COMERCIAL	Etapa 2 importada
f2c1e857-685b-412a-8e0e-533ddc55157f	68a13a46-9ce3-453a-a776-3436ebee98c2	1	c85b8285-3bc6-43bc-b664-4b675ee2876d	caf4d1b5-7a3c-445b-98f9-42d842f1d347	caf4d1b5-7a3c-445b-98f9-42d842f1d347	2025-01-29 03:00:00+00	2025-02-23 03:00:00+00	COMERCIAL	Etapa 1 importada
d74179eb-6635-4a48-acfb-18a610588502	8a562259-5c22-4bef-9d62-27e407cbc1a8	1	ffd18c57-fb77-4959-9191-1a7cf0a17664	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	2025-01-30 03:00:00+00	2025-02-27 03:00:00+00	COMERCIAL	Etapa 1 importada
d313005e-6404-4577-a9db-6188cd951424	a95eb4f4-2c21-4d2e-a29c-7fbddbca7378	1	bec74e80-f32e-4e58-9588-35bd863f8715	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	2025-02-03 03:00:00+00	2025-03-10 03:00:00+00	COMERCIAL	Etapa 1 importada
7591404e-8e4d-4bb0-ac58-8acf116f66a8	f66f54eb-303b-4ad5-95bd-9ef55e4e16dd	1	551b3773-09f9-4eb6-a9ce-88abf50b63a1	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	2025-01-30 03:00:00+00	2025-03-11 03:00:00+00	COMERCIAL	Etapa 1 importada
c764f091-def5-4d8f-84f1-683491847d7d	48fe5394-4b5c-49c1-9d44-0f9d2b21b53a	1	551b3773-09f9-4eb6-a9ce-88abf50b63a1	86f70064-a55b-4d55-b7e9-dc3f320c4cc1	86f70064-a55b-4d55-b7e9-dc3f320c4cc1	2025-02-05 03:00:00+00	2025-04-09 03:00:00+00	COMERCIAL	Etapa 1 importada
4f57f549-eba8-4338-a832-da49c3c5572f	2256c2ba-7ef9-45a0-a5c7-9afa6cef49ac	1	bec74e80-f32e-4e58-9588-35bd863f8715	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-02-07 03:00:00+00	2025-02-22 03:00:00+00	COMERCIAL	Etapa 1 importada
fe082ba1-f776-4224-a497-44ecc9096834	69cbcc71-43c4-4429-90bd-e675a46e9872	1	c85b8285-3bc6-43bc-b664-4b675ee2876d	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-02-11 03:00:00+00	2025-05-07 03:00:00+00	COMERCIAL	Etapa 1 importada
0bce172f-f383-4db1-b9e2-b8ce7da0c59f	592db42c-4135-40d1-b7a3-2a0dc4299636	1	79d74266-23c8-4096-b660-cda06d12272c	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-02-12 03:00:00+00	2025-03-20 03:00:00+00	COMERCIAL	Etapa 1 importada
3a2cdb83-e85f-4861-a36c-c00003a56957	a12d12d9-f4f7-4e74-9fab-bc1dc17d0688	1	c85b8285-3bc6-43bc-b664-4b675ee2876d	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	2025-02-19 03:00:00+00	2025-04-13 03:00:00+00	COMERCIAL	Etapa 1 importada
52e6bda3-8a3f-4049-84ad-149cf72083cb	1fdfc3d9-544b-48cf-a621-dd68244f9369	1	bec74e80-f32e-4e58-9588-35bd863f8715	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-02-18 03:00:00+00	2025-02-25 03:00:00+00	COMERCIAL	Etapa 1 importada
52cd26b7-dddc-45b0-ada7-4342fe890af7	47f761ef-c91e-45fb-93d5-1f98eb26cd38	1	79d74266-23c8-4096-b660-cda06d12272c	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-02-27 03:00:00+00	2025-04-07 03:00:00+00	COMERCIAL	Etapa 1 importada
8ee91dee-6938-41f1-9f4c-0a9864efccdc	f9765ab5-8ee7-416c-b7c1-d0d1846a4327	1	c85b8285-3bc6-43bc-b664-4b675ee2876d	caf4d1b5-7a3c-445b-98f9-42d842f1d347	caf4d1b5-7a3c-445b-98f9-42d842f1d347	2025-02-24 03:00:00+00	2025-03-31 03:00:00+00	COMERCIAL	Etapa 1 importada
c566af59-f763-47f0-8e84-40f85224a725	dea85480-9c24-454f-b6fa-4c78332dcce3	1	79d74266-23c8-4096-b660-cda06d12272c	\N	\N	2025-02-21 03:00:00+00	2025-04-02 03:00:00+00	COMERCIAL	Etapa 1 importada
13330c47-efb2-4ebb-b782-e345652064ec	02435e7d-a5b8-4b8e-809b-dfd97b7df3d1	1	ffd18c57-fb77-4959-9191-1a7cf0a17664	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	2025-02-21 03:00:00+00	2025-03-28 03:00:00+00	COMERCIAL	Etapa 1 importada
65285f8e-18e1-4f34-bcbf-4ed118b5c0e9	0e0d382a-b7eb-4d4f-8eae-fecf123e836e	1	ffd18c57-fb77-4959-9191-1a7cf0a17664	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-03-06 03:00:00+00	2025-03-26 03:00:00+00	COMERCIAL	Etapa 1 importada
8ba7a755-4a88-4c6c-a772-58024e7ece04	a7bdea43-545d-4d0a-96ce-62cbc6f3567c	1	79d74266-23c8-4096-b660-cda06d12272c	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-03-06 03:00:00+00	2025-04-13 03:00:00+00	COMERCIAL	Etapa 1 importada
f90cd14d-1086-48fe-a154-1e928630fa84	f4f7a0f7-87a0-426a-8a6a-e621a6dfb4e8	1	551b3773-09f9-4eb6-a9ce-88abf50b63a1	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	2025-03-07 03:00:00+00	2025-04-07 03:00:00+00	COMERCIAL	Etapa 1 importada
82a44246-0381-4332-9860-908c904f02df	9abc8a68-2563-4aae-9ead-77e56a59de1f	1	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-03-11 03:00:00+00	2025-03-18 03:00:00+00	COMERCIAL	Etapa 1 importada
3fcb899c-18ba-47eb-8e15-631cbce57d39	9abc8a68-2563-4aae-9ead-77e56a59de1f	2	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-03-21 03:00:00+00	2025-03-28 03:00:00+00	COMERCIAL	Etapa 2 importada
601ee92a-ee9e-42d4-a6f7-7074f4341a1a	11d340ae-2948-4d28-ae9d-12a32a5c90a9	1	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-03-11 03:00:00+00	2025-03-16 03:00:00+00	COMERCIAL	Etapa 1 importada
d6657385-2496-4c77-9eca-25f8bd74a97b	11d340ae-2948-4d28-ae9d-12a32a5c90a9	2	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-03-17 03:00:00+00	2025-03-28 03:00:00+00	COMERCIAL	Etapa 2 importada
b8f24815-0f35-4d95-86a0-2c71124566b7	0b53fe15-746b-4833-89ec-01eb6cd2f234	1	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-03-12 03:00:00+00	2025-03-17 03:00:00+00	COMERCIAL	Etapa 1 importada
bec594cc-34db-4a3a-92e0-77f1a338c315	0b53fe15-746b-4833-89ec-01eb6cd2f234	2	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-03-18 03:00:00+00	2025-03-29 03:00:00+00	COMERCIAL	Etapa 2 importada
e4548b41-9cb0-4062-99b7-dd378e6f5a6d	311d40b1-64bc-4e65-bd15-7aeb87b45bc4	1	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-03-11 03:00:00+00	2025-03-20 03:00:00+00	COMERCIAL	Etapa 1 importada
ac490d6c-c4a2-4276-88b6-7589f40a644d	311d40b1-64bc-4e65-bd15-7aeb87b45bc4	2	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-03-22 03:00:00+00	2025-03-27 03:00:00+00	COMERCIAL	Etapa 2 importada
2cd59c05-5e62-4716-b007-f53b33c70dcc	b6c44045-e74b-4c6d-aadb-8e351e3f5272	1	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-03-07 03:00:00+00	2025-03-12 03:00:00+00	COMERCIAL	Etapa 1 importada
c765c065-57d4-4347-a10d-27ff24a14f90	b6c44045-e74b-4c6d-aadb-8e351e3f5272	2	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-03-15 03:00:00+00	2025-03-18 03:00:00+00	COMERCIAL	Etapa 2 importada
6b00c1f1-e1db-477b-9384-63a73f51193d	881b3e5f-1e70-442e-a979-2227a0af91f8	1	ffd18c57-fb77-4959-9191-1a7cf0a17664	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	2025-03-11 03:00:00+00	2025-04-23 03:00:00+00	COMERCIAL	Etapa 1 importada
e27d30e5-ad4f-47a0-ba91-750b0d879b74	c426739a-2bbd-4bd7-8b15-4cd170e58f50	1	ffd18c57-fb77-4959-9191-1a7cf0a17664	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	2025-03-12 03:00:00+00	2025-04-30 03:00:00+00	COMERCIAL	Etapa 1 importada
1d4c99af-537f-46af-aaad-aa085ebbddf4	9846b525-caeb-423f-ba64-c9e24e8ec6f4	1	bec74e80-f32e-4e58-9588-35bd863f8715	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	2025-03-17 03:00:00+00	2025-04-25 03:00:00+00	COMERCIAL	Etapa 1 importada
bedbe085-d4b3-4191-9e1e-b417a43322c4	ed3251db-d14e-4c8b-8416-25094bb4b2ca	1	551b3773-09f9-4eb6-a9ce-88abf50b63a1	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-03-24 03:00:00+00	2025-04-23 03:00:00+00	COMERCIAL	Etapa 1 importada
520d32c5-3806-43c2-8818-28f9735425be	8278705c-0edf-401c-b780-b91d0d623f7d	1	79d74266-23c8-4096-b660-cda06d12272c	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-03-28 03:00:00+00	2025-04-30 03:00:00+00	COMERCIAL	Etapa 1 importada
f7c0e96c-741d-455a-897c-97b03cab947b	4095549b-0d2a-46c9-98e7-c1bba0941de0	1	c85b8285-3bc6-43bc-b664-4b675ee2876d	caf4d1b5-7a3c-445b-98f9-42d842f1d347	caf4d1b5-7a3c-445b-98f9-42d842f1d347	2025-04-01 03:00:00+00	2025-04-27 03:00:00+00	COMERCIAL	Etapa 1 importada
bc9e5fbf-f5ce-4984-b170-6644f9a5028c	9995c117-f9ec-4a2d-9175-ba610601fcb0	1	551b3773-09f9-4eb6-a9ce-88abf50b63a1	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-03-28 03:00:00+00	2025-05-05 03:00:00+00	COMERCIAL	Etapa 1 importada
36834950-7ee3-4892-b120-a458a08b461f	9ca69fde-117e-4717-818a-546b49669e42	1	79d74266-23c8-4096-b660-cda06d12272c	\N	\N	2025-04-11 03:00:00+00	2025-05-17 03:00:00+00	COMERCIAL	Etapa 1 importada
df1c49d3-8cc2-469b-9f12-815d889e357c	1da59a5f-db27-4cdc-838d-77ee8b345ff7	1	c85b8285-3bc6-43bc-b664-4b675ee2876d	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	2025-04-18 03:00:00+00	2025-05-19 03:00:00+00	COMERCIAL	Etapa 1 importada
1d8a3667-dac5-49f5-a348-2cedf0e56c2c	338f1e94-bca1-47ce-b9be-daa77185cf2e	1	c85b8285-3bc6-43bc-b664-4b675ee2876d	86f70064-a55b-4d55-b7e9-dc3f320c4cc1	86f70064-a55b-4d55-b7e9-dc3f320c4cc1	2025-04-12 03:00:00+00	2025-05-20 03:00:00+00	COMERCIAL	Etapa 1 importada
771d15cb-5878-4ff8-bebf-50c50b5561fe	abdbef76-9b46-4e8f-92ee-6b9020caaa8d	1	ffd18c57-fb77-4959-9191-1a7cf0a17664	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	2025-05-08 03:00:00+00	2025-06-06 03:00:00+00	COMERCIAL	Etapa 1 importada
5e25c802-25a6-4e81-8235-a44c9b48e301	f0468bbd-b484-41df-b78c-88aaab94250a	1	551b3773-09f9-4eb6-a9ce-88abf50b63a1	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	2025-04-21 03:00:00+00	2025-05-15 03:00:00+00	COMERCIAL	Etapa 1 importada
1e568464-47a9-4a1f-a92f-d59e1e26dfb4	32617a9e-1648-4056-afb8-bfc5030276e5	1	79d74266-23c8-4096-b660-cda06d12272c	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-04-10 03:00:00+00	2025-06-06 03:00:00+00	COMERCIAL	Etapa 1 importada
fdee6a26-2694-487f-9bcf-5d414fc5106c	ca6ad44a-8156-4059-81a0-0226336aa2df	1	ffd18c57-fb77-4959-9191-1a7cf0a17664	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-04-12 03:00:00+00	2025-05-14 03:00:00+00	COMERCIAL	Etapa 1 importada
98cea98d-7650-4afc-a84b-c4613afbc013	7c602a8d-a15d-4840-bca0-53fb57a13d81	1	79d74266-23c8-4096-b660-cda06d12272c	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-04-16 03:00:00+00	2025-05-29 03:00:00+00	COMERCIAL	Etapa 1 importada
8a96f45a-4840-4af4-a3f1-0aba108e81a7	f8aad6fc-bca6-4048-96ae-02a913dfba6d	1	551b3773-09f9-4eb6-a9ce-88abf50b63a1	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	2025-04-15 03:00:00+00	2025-05-27 03:00:00+00	COMERCIAL	Etapa 1 importada
23a3da47-5489-4ca2-a345-ca854bc7622e	de0e9cf6-f31f-48a1-ac4c-e765f1dd10df	1	5507dd96-8c9a-4f7c-823a-2f87e36ef9e9	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	2025-04-12 03:00:00+00	2025-04-20 03:00:00+00	COMERCIAL	Etapa 1 importada
63f9641b-a6f8-4d12-86ac-9a80886c0ecd	de0e9cf6-f31f-48a1-ac4c-e765f1dd10df	2	5507dd96-8c9a-4f7c-823a-2f87e36ef9e9	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	2025-04-21 03:00:00+00	2025-05-01 03:00:00+00	COMERCIAL	Etapa 2 importada
d3aa3903-13f1-45d7-9359-bbc78406ef53	de0e9cf6-f31f-48a1-ac4c-e765f1dd10df	3	5507dd96-8c9a-4f7c-823a-2f87e36ef9e9	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	2025-05-02 03:00:00+00	2025-05-10 03:00:00+00	COMERCIAL	Etapa 3 importada
d7a7b81c-0883-41b4-955b-bfbd9027ed8b	6820501e-2199-40d1-9f42-321c4f0b11db	1	bec74e80-f32e-4e58-9588-35bd863f8715	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	2025-04-27 03:00:00+00	2025-05-31 03:00:00+00	COMERCIAL	Etapa 1 importada
e8728e52-e993-4898-a5c4-939c705f0671	31532d29-63f4-4dab-82f3-06cd195379b7	1	bec74e80-f32e-4e58-9588-35bd863f8715	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	0205-04-21 03:53:48+00	2025-04-29 03:00:00+00	COMERCIAL	Etapa 1 importada
71572985-8aa5-4ab7-8c85-c1419e105199	31532d29-63f4-4dab-82f3-06cd195379b7	2	bec74e80-f32e-4e58-9588-35bd863f8715	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-05-02 03:00:00+00	2025-05-10 03:00:00+00	COMERCIAL	Etapa 2 importada
01ab97da-4b15-461f-ba74-0b32bbc6aa55	31532d29-63f4-4dab-82f3-06cd195379b7	3	bec74e80-f32e-4e58-9588-35bd863f8715	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-05-12 03:00:00+00	2025-05-26 03:00:00+00	COMERCIAL	Etapa 3 importada
e8a086c0-8b75-40fc-863b-d076ae597e9a	0e52329d-2d4e-497e-8fa5-f53dbe6a6a58	1	bec74e80-f32e-4e58-9588-35bd863f8715	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-05-02 03:00:00+00	2025-05-09 03:00:00+00	COMERCIAL	Etapa 1 importada
84790237-7482-4462-ac05-7cc5c6468531	0e52329d-2d4e-497e-8fa5-f53dbe6a6a58	2	bec74e80-f32e-4e58-9588-35bd863f8715	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-05-14 03:00:00+00	2025-05-25 03:00:00+00	COMERCIAL	Etapa 2 importada
e355c463-6579-47b5-80ba-296645254a46	0e7d01e2-b826-4db7-be3b-71ac7fb56c7d	1	bec74e80-f32e-4e58-9588-35bd863f8715	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	2025-04-30 03:00:00+00	2025-06-16 03:00:00+00	COMERCIAL	Etapa 1 importada
cfa72d9c-9fbd-4cc6-a794-9e28ce66644d	f8f01a70-128b-41d6-a8c4-7114b79dfd24	1	bec74e80-f32e-4e58-9588-35bd863f8715	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-04-26 03:00:00+00	2025-05-04 03:00:00+00	COMERCIAL	Etapa 1 importada
dbefe786-66ab-40c3-8576-468d5b643ae3	f8f01a70-128b-41d6-a8c4-7114b79dfd24	2	bec74e80-f32e-4e58-9588-35bd863f8715	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-05-06 03:00:00+00	2025-05-15 03:00:00+00	COMERCIAL	Etapa 2 importada
aaa1c60a-dbb7-443b-8ff8-392c4cde39b3	f8f01a70-128b-41d6-a8c4-7114b79dfd24	3	bec74e80-f32e-4e58-9588-35bd863f8715	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-05-17 03:00:00+00	2025-05-27 03:00:00+00	COMERCIAL	Etapa 3 importada
7e630dba-389d-4cdd-a4be-07b994e3daed	36efc308-b34e-4c6c-853d-9bf75f7b6da6	1	551b3773-09f9-4eb6-a9ce-88abf50b63a1	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-04-26 03:00:00+00	2025-05-28 03:00:00+00	COMERCIAL	Etapa 1 importada
2de6d7a2-a9e3-4e60-9561-aaf35b203a75	877af272-2260-4f9a-bdb8-553ea0b056ed	1	bec74e80-f32e-4e58-9588-35bd863f8715	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-05-02 03:00:00+00	2025-05-10 03:00:00+00	COMERCIAL	Etapa 1 importada
46c9efba-6da6-4415-a6d7-93297fa16797	877af272-2260-4f9a-bdb8-553ea0b056ed	2	bec74e80-f32e-4e58-9588-35bd863f8715	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-05-12 03:00:00+00	2025-05-21 03:00:00+00	COMERCIAL	Etapa 2 importada
08a9bec1-d245-4926-a6eb-176ddbe8eee4	0268cb0f-3f5d-42c4-9404-8a96f016b381	1	551b3773-09f9-4eb6-a9ce-88abf50b63a1	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	2025-04-30 03:00:00+00	2025-06-05 03:00:00+00	COMERCIAL	Etapa 1 importada
958ab634-d457-43d1-9369-0ca99d08c2cf	ff5b01b1-e5f0-4f85-b962-2e486b741944	1	c85b8285-3bc6-43bc-b664-4b675ee2876d	caf4d1b5-7a3c-445b-98f9-42d842f1d347	caf4d1b5-7a3c-445b-98f9-42d842f1d347	2025-04-28 03:00:00+00	2025-06-04 03:00:00+00	COMERCIAL	Etapa 1 importada
a98b32d9-bcdb-436a-a3d2-f239bb0240bb	4d6b0412-6cbf-40d4-a103-a9a2b7e9ceb9	1	bec74e80-f32e-4e58-9588-35bd863f8715	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-04-30 03:00:00+00	2025-05-06 03:00:00+00	COMERCIAL	Etapa 1 importada
72be29cc-3439-45fc-8292-6c34fedd7c23	4d6b0412-6cbf-40d4-a103-a9a2b7e9ceb9	2	bec74e80-f32e-4e58-9588-35bd863f8715	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-05-08 03:00:00+00	2025-05-17 03:00:00+00	COMERCIAL	Etapa 2 importada
e4d8534c-c758-429a-8949-72f070976589	4d6b0412-6cbf-40d4-a103-a9a2b7e9ceb9	3	bec74e80-f32e-4e58-9588-35bd863f8715	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-05-22 03:00:00+00	2025-05-29 03:00:00+00	COMERCIAL	Etapa 3 importada
d6ef3439-7830-4ee5-a9b7-093c1afd573c	4e1ca30c-b9ad-4e70-ac7b-373d4e469cce	1	bec74e80-f32e-4e58-9588-35bd863f8715	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-04-29 03:00:00+00	2025-05-15 03:00:00+00	COMERCIAL	Etapa 1 importada
af61aaae-27a4-4143-9f7a-73ba529463d7	b256d88d-3846-49be-a520-d2714953f2b9	1	c85b8285-3bc6-43bc-b664-4b675ee2876d	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-05-06 03:00:00+00	2025-06-18 03:00:00+00	COMERCIAL	Etapa 1 importada
d5a71295-11ea-4159-8237-45b88ded59c7	8ac92a84-1849-4a60-976b-d1b84e421031	1	79d74266-23c8-4096-b660-cda06d12272c	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-05-07 03:00:00+00	2025-06-10 03:00:00+00	COMERCIAL	Etapa 1 importada
37e14ba9-88e8-46f0-a1da-904b35ce6035	7f9d1709-bef6-4c9d-a884-0dea2639d1a9	1	bec74e80-f32e-4e58-9588-35bd863f8715	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-05-02 03:00:00+00	2025-06-05 03:00:00+00	COMERCIAL	Etapa 1 importada
fef5d825-5d6a-4018-91a6-4663da054efc	f161f9ea-d8a7-4ac6-8071-5a9c2ebca5e6	1	551b3773-09f9-4eb6-a9ce-88abf50b63a1	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	2025-05-07 03:00:00+00	2025-06-09 03:00:00+00	COMERCIAL	Etapa 1 importada
bffd5d67-4386-40c6-a526-0ba44d2b734c	3d155205-90bb-4e22-9208-bf9917a5c0bf	1	551b3773-09f9-4eb6-a9ce-88abf50b63a1	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-05-07 03:00:00+00	2025-06-10 03:00:00+00	COMERCIAL	Etapa 1 importada
3b551758-14bd-4c8b-8370-2891745c3ed3	055f85ae-4413-43bd-a039-5e997c351649	1	5507dd96-8c9a-4f7c-823a-2f87e36ef9e9	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	2025-05-09 03:00:00+00	2025-05-19 03:00:00+00	COMERCIAL	Etapa 1 importada
b897be66-6368-45a3-8653-1148b5783508	49534099-b63a-4a6b-ac69-c0471f345506	1	ffd18c57-fb77-4959-9191-1a7cf0a17664	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-05-15 03:00:00+00	2025-05-27 03:00:00+00	COMERCIAL	Etapa 1 importada
f42d80c9-d615-43fd-9561-90ec0daf4e8e	2433bfa1-7760-4361-8977-933f577f865a	1	c85b8285-3bc6-43bc-b664-4b675ee2876d	86f70064-a55b-4d55-b7e9-dc3f320c4cc1	86f70064-a55b-4d55-b7e9-dc3f320c4cc1	2025-05-21 03:00:00+00	2025-07-13 03:00:00+00	COMERCIAL	Etapa 1 importada
5506ec42-e36d-43a3-9250-a3ed580fcf58	ea92f9f1-c762-40ce-8a2c-33f521b51714	1	bec74e80-f32e-4e58-9588-35bd863f8715	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-05-17 03:00:00+00	2025-07-13 03:00:00+00	COMERCIAL	Etapa 1 importada
2ab14e06-b282-4b17-9813-95a166dde3ef	c7b47701-b71e-4ee7-8217-09cbe435abd1	1	bec74e80-f32e-4e58-9588-35bd863f8715	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-05-22 03:00:00+00	2025-06-17 03:00:00+00	COMERCIAL	Etapa 1 importada
e8929365-3212-4f65-ac1c-0a761f91e210	8091e240-4b3e-4ddb-bb28-85a58ba46bf6	1	551b3773-09f9-4eb6-a9ce-88abf50b63a1	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-05-22 03:00:00+00	2025-06-05 03:00:00+00	COMERCIAL	Etapa 1 importada
5ba3e9d5-b6fa-42a0-a876-e34fed7e2db0	beae9edc-38b7-48cb-8301-22fbe202aab3	1	c85b8285-3bc6-43bc-b664-4b675ee2876d	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	2025-05-20 03:00:00+00	2025-06-21 03:00:00+00	COMERCIAL	Etapa 1 importada
4a4e8987-b94c-4b9f-b9df-5e4288b08102	032dfc0b-0119-4cf8-9a01-a152af6ed805	1	79d74266-23c8-4096-b660-cda06d12272c	\N	\N	2025-05-27 03:00:00+00	2025-07-12 03:00:00+00	COMERCIAL	Etapa 1 importada
c6cc3ed1-40ef-42e6-a275-d08875d1d6aa	8cbe3d37-ac3d-4be6-b478-9a73af9ac20c	1	79d74266-23c8-4096-b660-cda06d12272c	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-05-31 03:00:00+00	2025-07-11 03:00:00+00	COMERCIAL	Etapa 1 importada
181d94fb-22e0-4776-bb74-e7a08be77f97	d60cf987-bbe4-4f03-ba2f-2579d6dba2cc	1	5507dd96-8c9a-4f7c-823a-2f87e36ef9e9	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	2025-05-26 03:00:00+00	2025-06-03 03:00:00+00	COMERCIAL	Etapa 1 importada
8608bc23-f8f5-4b30-84a9-39e7e952a2cd	d60cf987-bbe4-4f03-ba2f-2579d6dba2cc	2	5507dd96-8c9a-4f7c-823a-2f87e36ef9e9	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	2025-06-04 03:00:00+00	2025-06-10 03:00:00+00	COMERCIAL	Etapa 2 importada
e357e2d2-90ad-4095-af51-43ce527e800a	790db629-d119-4f12-80cf-2d922a82c2e2	1	551b3773-09f9-4eb6-a9ce-88abf50b63a1	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-05-31 03:00:00+00	2025-06-07 03:00:00+00	COMERCIAL	Etapa 1 importada
01120c48-4df0-47a9-b085-400b23d8a262	1ef63927-72f2-4b8f-812f-d2945330473d	1	bec74e80-f32e-4e58-9588-35bd863f8715	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-06-12 03:00:00+00	2025-06-20 03:00:00+00	COMERCIAL	Etapa 1 importada
28ba68ce-515b-4106-95af-69278763d581	1ef63927-72f2-4b8f-812f-d2945330473d	2	bec74e80-f32e-4e58-9588-35bd863f8715	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-06-24 03:00:00+00	2025-07-05 03:00:00+00	COMERCIAL	Etapa 2 importada
1fc6a70c-a804-433a-9ec1-66aba61b1598	1ef63927-72f2-4b8f-812f-d2945330473d	3	bec74e80-f32e-4e58-9588-35bd863f8715	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-07-08 03:00:00+00	2025-07-16 03:00:00+00	COMERCIAL	Etapa 3 importada
f8b18909-7179-409f-9ce2-2f27a15e13a0	1ef63927-72f2-4b8f-812f-d2945330473d	4	bec74e80-f32e-4e58-9588-35bd863f8715	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-07-19 03:00:00+00	2025-07-25 03:00:00+00	COMERCIAL	Etapa 4 importada
fb845d7a-e7e4-4911-b2c7-20d1159629bb	fd9da546-bf42-4c98-9cc4-c8b6d317cd6b	1	bec74e80-f32e-4e58-9588-35bd863f8715	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-06-05 03:00:00+00	2025-07-06 03:00:00+00	COMERCIAL	Etapa 1 importada
84fee8c6-2503-4276-b8b9-3111941bc248	284a1f0e-a7fb-472a-9131-7aa367ac0610	1	bec74e80-f32e-4e58-9588-35bd863f8715	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	2025-06-05 03:00:00+00	2025-07-06 03:00:00+00	COMERCIAL	Etapa 1 importada
5e3e94ef-d5a6-42fa-bd9e-7205fe693a7a	4226bf56-57c0-4560-a178-98ab4df1d172	1	c85b8285-3bc6-43bc-b664-4b675ee2876d	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-06-18 03:00:00+00	2025-07-03 03:00:00+00	COMERCIAL	Etapa 1 importada
c22184ad-555a-4936-9c3d-fbf156a8a6b1	93a313f8-ad3c-462a-95b9-c4c19624dac6	1	bec74e80-f32e-4e58-9588-35bd863f8715	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-06-10 03:00:00+00	2025-06-17 03:00:00+00	COMERCIAL	Etapa 1 importada
f6826303-11d8-4915-b24d-24bfff99dc4e	93a313f8-ad3c-462a-95b9-c4c19624dac6	2	bec74e80-f32e-4e58-9588-35bd863f8715	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-06-19 03:00:00+00	2025-06-22 03:00:00+00	COMERCIAL	Etapa 2 importada
920ace43-a869-44e5-8a23-896134d68c49	93a313f8-ad3c-462a-95b9-c4c19624dac6	3	bec74e80-f32e-4e58-9588-35bd863f8715	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-06-28 03:00:00+00	2025-07-04 03:00:00+00	COMERCIAL	Etapa 3 importada
0d7bfa2c-25b7-4366-a26a-83f4ed626fa5	93a313f8-ad3c-462a-95b9-c4c19624dac6	4	bec74e80-f32e-4e58-9588-35bd863f8715	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-07-06 03:00:00+00	2025-07-10 03:00:00+00	COMERCIAL	Etapa 4 importada
53dfe99c-81d4-492f-9756-2d781903f603	93a313f8-ad3c-462a-95b9-c4c19624dac6	5	bec74e80-f32e-4e58-9588-35bd863f8715	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-07-12 03:00:00+00	2025-07-16 03:00:00+00	COMERCIAL	Etapa 5 importada
cb38d0bb-782f-461c-97e6-63a86bde9e24	5a97e8e8-40e6-4195-a00a-bf522a3775dc	1	5507dd96-8c9a-4f7c-823a-2f87e36ef9e9	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-06-18 03:00:00+00	2025-06-25 03:00:00+00	COMERCIAL	Etapa 1 importada
1c867910-a33f-449e-83e7-17f0cfa63a0c	5a97e8e8-40e6-4195-a00a-bf522a3775dc	2	5507dd96-8c9a-4f7c-823a-2f87e36ef9e9	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-06-27 03:00:00+00	2025-07-11 03:00:00+00	COMERCIAL	Etapa 2 importada
906f1770-3f4a-48e0-ac5f-1686555ba9a0	924abc07-845d-44d4-9587-a9c4ad38078a	1	5507dd96-8c9a-4f7c-823a-2f87e36ef9e9	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	2025-06-17 03:00:00+00	2025-07-10 03:00:00+00	COMERCIAL	Etapa 1 importada
242e3563-0c7c-4daa-97f5-4782efa5f77e	4f2112d6-a93d-4546-b2cd-9debae9f7d00	1	5507dd96-8c9a-4f7c-823a-2f87e36ef9e9	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-06-18 03:00:00+00	2025-06-25 03:00:00+00	COMERCIAL	Etapa 1 importada
2e1e4704-2fa5-4d4e-8555-1d7237d55215	5769899c-b858-47af-bd34-da72856242d3	1	5507dd96-8c9a-4f7c-823a-2f87e36ef9e9	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-06-18 03:00:00+00	2025-06-25 03:00:00+00	COMERCIAL	Etapa 1 importada
ac1f3bbe-113f-4f65-bb14-c0284d633003	c3598bb8-fbea-4261-9ee1-a8a88a21b7e6	1	5507dd96-8c9a-4f7c-823a-2f87e36ef9e9	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-06-18 03:00:00+00	2025-06-25 03:00:00+00	COMERCIAL	Etapa 1 importada
c3591dfb-c60d-466f-ba3b-7d010ee588d1	77fe6524-661b-45b3-9f20-6f1fc7c96be3	1	5507dd96-8c9a-4f7c-823a-2f87e36ef9e9	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-06-18 03:00:00+00	2025-06-25 03:00:00+00	COMERCIAL	Etapa 1 importada
d92465bb-98af-4421-8c08-70c7fc542ef8	77fe6524-661b-45b3-9f20-6f1fc7c96be3	2	5507dd96-8c9a-4f7c-823a-2f87e36ef9e9	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-06-27 03:00:00+00	2025-07-04 03:00:00+00	COMERCIAL	Etapa 2 importada
3a829cef-3bc9-4851-801b-8c6e75ffbde5	d5579c39-d747-44a9-9f3b-244ada52f539	1	bec74e80-f32e-4e58-9588-35bd863f8715	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-06-25 03:00:00+00	2025-07-03 03:00:00+00	COMERCIAL	Etapa 1 importada
d86ff530-0f2b-4ed2-b3cb-1ef729192ccd	d5579c39-d747-44a9-9f3b-244ada52f539	2	bec74e80-f32e-4e58-9588-35bd863f8715	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-07-05 03:00:00+00	2025-07-11 03:00:00+00	COMERCIAL	Etapa 2 importada
541b5d18-4ae5-4da2-99ca-c55cd5ff3e3a	d5579c39-d747-44a9-9f3b-244ada52f539	3	bec74e80-f32e-4e58-9588-35bd863f8715	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-07-20 03:00:00+00	2025-07-26 03:00:00+00	COMERCIAL	Etapa 3 importada
4dda0588-bd89-4fe7-96da-ad08dbc29f6a	d5579c39-d747-44a9-9f3b-244ada52f539	4	bec74e80-f32e-4e58-9588-35bd863f8715	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-07-28 03:00:00+00	2025-08-04 03:00:00+00	COMERCIAL	Etapa 4 importada
4d78740f-2f49-4357-8b35-5d084c4c2a67	b665acfb-d2f6-4910-b47a-cc7765fb017d	1	5507dd96-8c9a-4f7c-823a-2f87e36ef9e9	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-06-27 03:00:00+00	2025-07-21 03:00:00+00	COMERCIAL	Etapa 1 importada
2095d470-3d2a-46eb-8d41-8f644c577d06	98266e72-77a5-4d91-ba08-2a4c66658cdc	1	5507dd96-8c9a-4f7c-823a-2f87e36ef9e9	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-06-27 03:00:00+00	2025-07-03 03:00:00+00	COMERCIAL	Etapa 1 importada
8a897c15-1bec-40ce-8430-c09e5d9712f9	98266e72-77a5-4d91-ba08-2a4c66658cdc	2	5507dd96-8c9a-4f7c-823a-2f87e36ef9e9	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-07-04 03:00:00+00	2025-07-11 03:00:00+00	COMERCIAL	Etapa 2 importada
964fdb1d-60bf-4b01-97b5-40e700227bd1	92a3b9e4-161f-47b4-af64-286393ecb159	1	5507dd96-8c9a-4f7c-823a-2f87e36ef9e9	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-06-27 03:00:00+00	2025-07-17 03:00:00+00	COMERCIAL	Etapa 1 importada
863e7e79-708a-4730-ab9e-9d2419ee83a2	26718815-8684-4b30-9258-9bb6a63e5379	1	bec74e80-f32e-4e58-9588-35bd863f8715	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-07-12 03:00:00+00	2025-07-14 03:00:00+00	COMERCIAL	Etapa 1 importada
bd64df5d-6ff0-46c1-acda-65952526ede9	26718815-8684-4b30-9258-9bb6a63e5379	2	bec74e80-f32e-4e58-9588-35bd863f8715	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-07-18 03:00:00+00	2025-07-23 03:00:00+00	COMERCIAL	Etapa 2 importada
dded4d32-cfd7-4b1b-9c62-67fa8e7ba289	26718815-8684-4b30-9258-9bb6a63e5379	3	bec74e80-f32e-4e58-9588-35bd863f8715	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-07-27 03:00:00+00	2025-08-01 03:00:00+00	COMERCIAL	Etapa 3 importada
5b6fe20e-a9b4-4026-ba1a-830cce822422	40d45581-09a2-44a6-a87b-647ab77b5bac	1	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-07-10 03:00:00+00	2025-08-29 03:00:00+00	COMERCIAL	Etapa 1 importada
fe25a896-bcb6-4a2a-ac30-3460d09224d6	898f861d-cab2-4b8b-8bef-64a768ebada9	1	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-07-14 03:00:00+00	2025-08-28 03:00:00+00	COMERCIAL	Etapa 1 importada
b4b51511-5c7c-4a31-9286-8413ee63b6b3	63d6cfba-6a7e-4666-8ee3-bff7bb0eb867	1	5507dd96-8c9a-4f7c-823a-2f87e36ef9e9	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	2025-07-11 03:00:00+00	2025-08-20 03:00:00+00	COMERCIAL	Etapa 1 importada
ec38fb40-3c79-4e09-a881-3752d4021eb1	5db1a29b-1723-4853-ab5b-68e119dfbfb5	1	5507dd96-8c9a-4f7c-823a-2f87e36ef9e9	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-07-13 03:00:00+00	2025-08-05 03:00:00+00	COMERCIAL	Etapa 1 importada
b8c8f73f-1309-480f-ad23-a98edbcdb014	0646f2e6-9ddf-43d1-9348-a4da267a3df6	1	bec74e80-f32e-4e58-9588-35bd863f8715	f20aba40-3236-4ae4-b2aa-9c236e7217fa	f20aba40-3236-4ae4-b2aa-9c236e7217fa	2025-07-12 03:00:00+00	2025-08-23 03:00:00+00	COMERCIAL	Etapa 1 importada
dd8f52dc-d025-4789-9b0f-949b126a8801	f0d7ac68-cb3b-42f8-a568-2044b0748289	1	5507dd96-8c9a-4f7c-823a-2f87e36ef9e9	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-07-18 03:00:00+00	2025-07-25 03:00:00+00	COMERCIAL	Etapa 1 importada
69464121-1347-4a79-b240-de22fce9a317	f0d7ac68-cb3b-42f8-a568-2044b0748289	2	5507dd96-8c9a-4f7c-823a-2f87e36ef9e9	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-07-26 03:00:00+00	2025-08-03 03:00:00+00	COMERCIAL	Etapa 2 importada
6560a087-9d47-4492-8107-f872c6557cc4	f0d7ac68-cb3b-42f8-a568-2044b0748289	3	5507dd96-8c9a-4f7c-823a-2f87e36ef9e9	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-08-04 03:00:00+00	2025-08-10 03:00:00+00	COMERCIAL	Etapa 3 importada
6b0eca56-0c6d-4dad-a940-d11f34b96e22	f0d7ac68-cb3b-42f8-a568-2044b0748289	4	5507dd96-8c9a-4f7c-823a-2f87e36ef9e9	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-08-11 03:00:00+00	2025-08-17 03:00:00+00	COMERCIAL	Etapa 4 importada
3b6ad954-92b8-483a-ab00-55cd71388a3e	17dda418-ca0d-4d52-9a1c-d7cc167ff0b0	1	79d74266-23c8-4096-b660-cda06d12272c	\N	\N	2025-07-17 03:00:00+00	2025-09-04 03:00:00+00	COMERCIAL	Etapa 1 importada
1ce66bf3-0f48-4c47-8c52-ff3e83ac7903	c6b21f6b-bafd-4d8d-b71f-ece9166b9236	1	bec74e80-f32e-4e58-9588-35bd863f8715	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-07-19 03:00:00+00	2025-08-19 03:00:00+00	COMERCIAL	Etapa 1 importada
7c0bdfd0-f6d1-43d7-a3f5-bb8e556c9bcb	514dbd2f-cb9b-4407-baa8-12bcd209a7a7	1	bec74e80-f32e-4e58-9588-35bd863f8715	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-07-19 03:00:00+00	2025-08-23 03:00:00+00	COMERCIAL	Etapa 1 importada
8b9de8ac-a88d-4663-b5ab-a7ace182c4ab	4f9e1e6d-827c-4cb4-9d82-069772c24520	1	5507dd96-8c9a-4f7c-823a-2f87e36ef9e9	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-07-21 03:00:00+00	\N	COMERCIAL	Etapa generada automáticamente (sin desglose)
615e6058-a967-463d-922d-6a07e3c7bfdd	ef1a04e9-e54f-49d6-8702-d06678d085ef	1	5507dd96-8c9a-4f7c-823a-2f87e36ef9e9	\N	\N	2025-07-23 03:00:00+00	2025-10-07 03:00:00+00	COMERCIAL	Etapa 1 importada
f3eded6a-968b-4ef5-9848-5ec375a7a25a	926aed79-e3b5-49e5-9b89-33e53b405d74	1	5507dd96-8c9a-4f7c-823a-2f87e36ef9e9	\N	\N	2025-07-23 03:00:00+00	2025-09-27 03:00:00+00	COMERCIAL	Etapa 1 importada
7e342b48-223d-46ae-8ee7-4582af1bda1a	3cb66381-ef63-4747-8c8a-a2b417319718	1	5507dd96-8c9a-4f7c-823a-2f87e36ef9e9	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-07-24 03:00:00+00	2025-08-30 03:00:00+00	COMERCIAL	Etapa 1 importada
9ee437d1-998b-4be1-97b8-e93c7babed1b	2a8c6c87-02df-480a-8ba4-fd620b2bdc5f	1	bec74e80-f32e-4e58-9588-35bd863f8715	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-07-29 03:00:00+00	2025-08-03 03:00:00+00	COMERCIAL	Etapa 1 importada
241d4b1e-f6d9-43d5-9439-de9b310dc5c3	2a8c6c87-02df-480a-8ba4-fd620b2bdc5f	2	bec74e80-f32e-4e58-9588-35bd863f8715	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-08-06 03:00:00+00	2025-08-14 03:00:00+00	COMERCIAL	Etapa 2 importada
14f44c9b-a1ad-4e40-b28e-9ebc238a191d	2a8c6c87-02df-480a-8ba4-fd620b2bdc5f	3	bec74e80-f32e-4e58-9588-35bd863f8715	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-08-16 03:00:00+00	2025-08-23 03:00:00+00	COMERCIAL	Etapa 3 importada
477bfd5a-6a74-4a47-9049-20a72be4b7e7	033e9eb9-741b-4231-91e3-648566fccfa2	1	ffd18c57-fb77-4959-9191-1a7cf0a17664	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	2025-07-29 03:00:00+00	2025-09-13 03:00:00+00	COMERCIAL	Etapa 1 importada
3fffb4b0-408d-4d02-9fc2-b6db1d044d7d	bd6dda78-8b56-4512-8655-bd8854d29cc4	1	5507dd96-8c9a-4f7c-823a-2f87e36ef9e9	\N	\N	2025-07-30 03:00:00+00	2025-08-04 03:00:00+00	COMERCIAL	Etapa 1 importada
4cf72889-7d9b-453c-80e8-387fc627dae6	2080b341-36db-4ddf-ba40-3ed8b23725ab	1	5507dd96-8c9a-4f7c-823a-2f87e36ef9e9	\N	\N	2025-08-04 03:00:00+00	2025-08-14 03:00:00+00	COMERCIAL	Etapa 1 importada
e006835d-c622-4ce4-b35f-00bd372f47a0	2080b341-36db-4ddf-ba40-3ed8b23725ab	2	5507dd96-8c9a-4f7c-823a-2f87e36ef9e9	\N	\N	2025-08-15 03:00:00+00	2025-09-07 03:00:00+00	COMERCIAL	Etapa 2 importada
56e60cca-8fcd-4302-b492-41c945a92740	cc4d7e35-a911-4291-831f-c8558971c222	1	5507dd96-8c9a-4f7c-823a-2f87e36ef9e9	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-08-01 03:00:00+00	2025-08-23 03:00:00+00	COMERCIAL	Etapa 1 importada
d4600e4a-c2e1-4c84-9639-cdef8aa76847	0ea2f5b7-a551-4c6f-819f-cd7261fb412f	1	5507dd96-8c9a-4f7c-823a-2f87e36ef9e9	caf4d1b5-7a3c-445b-98f9-42d842f1d347	caf4d1b5-7a3c-445b-98f9-42d842f1d347	2025-08-03 03:00:00+00	2025-08-23 03:00:00+00	COMERCIAL	Etapa 1 importada
5b9412ab-5796-4034-a6ab-9f8d5a35141c	54d70074-cda9-4622-81a9-f492bf4449e4	1	5507dd96-8c9a-4f7c-823a-2f87e36ef9e9	\N	\N	2025-08-05 03:00:00+00	2025-08-13 03:00:00+00	COMERCIAL	Etapa 1 importada
a46fde5f-18d5-44e8-98cc-2f9be2f5ed10	e48d6233-bd59-4203-9656-2b04e946e1d1	1	bec74e80-f32e-4e58-9588-35bd863f8715	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-08-07 03:00:00+00	2025-08-14 03:00:00+00	COMERCIAL	Etapa 1 importada
179f5629-d852-4ea4-9d24-c3e6d9094b6f	e48d6233-bd59-4203-9656-2b04e946e1d1	2	bec74e80-f32e-4e58-9588-35bd863f8715	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-08-20 03:00:00+00	2025-08-27 03:00:00+00	COMERCIAL	Etapa 2 importada
a284851d-1013-43bc-bdf1-3f4e6c02e63d	e48d6233-bd59-4203-9656-2b04e946e1d1	3	bec74e80-f32e-4e58-9588-35bd863f8715	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-08-29 03:00:00+00	2025-09-05 03:00:00+00	COMERCIAL	Etapa 3 importada
b104e82b-3925-4121-bb17-da09b72686b3	e48d6233-bd59-4203-9656-2b04e946e1d1	4	bec74e80-f32e-4e58-9588-35bd863f8715	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-09-08 03:00:00+00	2025-09-16 03:00:00+00	COMERCIAL	Etapa 4 importada
c3b6c0af-7771-4674-a71f-eddc8dbe6737	96f6965f-87d7-45ae-9db4-ac79baed652a	1	5507dd96-8c9a-4f7c-823a-2f87e36ef9e9	\N	\N	2025-08-08 03:00:00+00	2025-09-24 03:00:00+00	COMERCIAL	Etapa 1 importada
bab47043-601e-4774-b16f-2ab197bc2b94	cccc809f-2a70-47c1-b8cb-210be07c8546	1	5507dd96-8c9a-4f7c-823a-2f87e36ef9e9	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-08-07 03:00:00+00	2025-09-23 03:00:00+00	COMERCIAL	Etapa 1 importada
69ab7a2f-09af-45a1-ab74-05d8f5568147	751b5025-8cc3-4fe5-b137-521974ed17f2	1	bec74e80-f32e-4e58-9588-35bd863f8715	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-08-14 03:00:00+00	2025-08-22 03:00:00+00	COMERCIAL	Etapa 1 importada
8ac71403-7486-4395-9738-77e16e4c2d69	751b5025-8cc3-4fe5-b137-521974ed17f2	2	bec74e80-f32e-4e58-9588-35bd863f8715	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-08-26 03:00:00+00	2025-09-05 03:00:00+00	COMERCIAL	Etapa 2 importada
c6646091-0038-448f-9c53-a5c7c2515f3c	751b5025-8cc3-4fe5-b137-521974ed17f2	3	bec74e80-f32e-4e58-9588-35bd863f8715	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-09-09 03:00:00+00	2025-09-09 03:00:00+00	COMERCIAL	Etapa 3 importada
d6364bc5-066e-4efc-8226-2f49c1f097e1	751b5025-8cc3-4fe5-b137-521974ed17f2	4	bec74e80-f32e-4e58-9588-35bd863f8715	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-09-13 03:00:00+00	2025-09-23 03:00:00+00	COMERCIAL	Etapa 4 importada
c1cb574a-76a3-40ac-ab30-d240e3b63eb4	9c7eac54-3810-43a9-8c1f-683babcc51d6	1	bec74e80-f32e-4e58-9588-35bd863f8715	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-08-16 03:00:00+00	2025-08-25 03:00:00+00	COMERCIAL	Etapa 1 importada
6fede855-fe75-483c-a12d-c80b0a5ee591	9c7eac54-3810-43a9-8c1f-683babcc51d6	2	bec74e80-f32e-4e58-9588-35bd863f8715	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-08-28 03:00:00+00	2025-09-06 03:00:00+00	COMERCIAL	Etapa 2 importada
e4f3584a-74c9-4ab1-8395-7b3b94a7e3c4	9c7eac54-3810-43a9-8c1f-683babcc51d6	3	bec74e80-f32e-4e58-9588-35bd863f8715	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-09-08 03:00:00+00	2025-09-18 03:00:00+00	COMERCIAL	Etapa 3 importada
7fe2b55b-5a8f-4043-a8bf-f7056d0ee711	b9d25ef7-f29a-46a7-9541-8d0a8c4f8854	1	bec74e80-f32e-4e58-9588-35bd863f8715	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-08-22 03:00:00+00	2025-09-22 03:00:00+00	COMERCIAL	Etapa 1 importada
80e68f08-7cf0-42f4-a2ed-ccb63ea7390a	b32debc4-4a13-41cd-83ef-c9862b6a6e60	1	5507dd96-8c9a-4f7c-823a-2f87e36ef9e9	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-08-19 03:00:00+00	2025-08-31 03:00:00+00	COMERCIAL	Etapa 1 importada
946a3275-86c3-4cbd-8ef6-f932ca4fd5cd	7a76f317-78b7-40ef-8041-9eb2bb27af58	1	5507dd96-8c9a-4f7c-823a-2f87e36ef9e9	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-08-20 03:00:00+00	2025-09-18 03:00:00+00	COMERCIAL	Etapa 1 importada
36818afa-02b9-4d2c-be12-6f4c95ed6354	d4f7dee3-0df8-493f-86bb-2e5e4fb85d6f	1	5507dd96-8c9a-4f7c-823a-2f87e36ef9e9	\N	\N	2025-08-25 03:00:00+00	2025-09-07 03:00:00+00	COMERCIAL	Etapa 1 importada
c2bf97f3-2c15-454a-b997-2d935c4dba40	e7ec54ee-b5c6-422d-b83e-497aab03235a	1	5507dd96-8c9a-4f7c-823a-2f87e36ef9e9	\N	\N	2025-08-31 03:00:00+00	2025-10-08 03:00:00+00	COMERCIAL	Etapa 1 importada
a93fad9b-eeca-47ce-acd3-ff4ee356604b	19e8a2e0-fe06-4eab-b069-836d9cc7e095	1	bec74e80-f32e-4e58-9588-35bd863f8715	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-08-30 03:00:00+00	2025-10-06 03:00:00+00	COMERCIAL	Etapa 1 importada
932d07d4-556c-47c3-8a02-3c8df16b29ab	e23a9208-60d1-4ead-92ad-c66c38e025ba	1	5507dd96-8c9a-4f7c-823a-2f87e36ef9e9	caf4d1b5-7a3c-445b-98f9-42d842f1d347	caf4d1b5-7a3c-445b-98f9-42d842f1d347	2025-09-04 03:00:00+00	2025-09-16 03:00:00+00	COMERCIAL	Etapa 1 importada
0a9e657e-8e9c-4a59-99cd-45d3c5295712	30896d26-473f-4151-95e3-c4a2870a0ab7	1	79d74266-23c8-4096-b660-cda06d12272c	\N	\N	2025-09-10 03:00:00+00	2025-10-20 03:00:00+00	COMERCIAL	Etapa 1 importada
8e57b32a-c36b-4b1b-84cb-82fbfb27f63d	54238aaf-a916-4d8c-8169-a6cd101b4551	1	ffd18c57-fb77-4959-9191-1a7cf0a17664	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	2025-09-11 03:00:00+00	2025-10-01 03:00:00+00	COMERCIAL	Etapa 1 importada
215ffac3-c064-4a4b-900a-7902020ea961	9288691f-28a2-476d-8aeb-2c9404b2e17f	1	bec74e80-f32e-4e58-9588-35bd863f8715	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-09-11 03:00:00+00	2025-10-18 03:00:00+00	COMERCIAL	Etapa 1 importada
7526e0fe-e1f5-4294-8ede-512edd43cb6c	cb32aa68-18cc-4877-8d21-7679c676d815	1	5507dd96-8c9a-4f7c-823a-2f87e36ef9e9	\N	\N	2025-09-13 03:00:00+00	2025-10-13 03:00:00+00	COMERCIAL	Etapa 1 importada
bfc8cbed-742a-4de4-89e7-fa64dc4a5423	d3fc2e88-ce02-49b7-ad3c-6cb771fd241e	1	ffd18c57-fb77-4959-9191-1a7cf0a17664	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-10-14 03:00:00+00	2025-11-08 03:00:00+00	COMERCIAL	Etapa 1 importada
8a99b682-803d-411f-9fbf-091a37645009	7f0fdc9f-35d9-4f56-be07-34a265d44c65	1	ffd18c57-fb77-4959-9191-1a7cf0a17664	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	2025-10-15 03:00:00+00	2025-11-08 03:00:00+00	COMERCIAL	Etapa 1 importada
f1acbc39-e5da-423a-bcbd-ff85e7d759c0	75a873cf-209e-4153-9151-bf4bb2d1458a	1	ffd18c57-fb77-4959-9191-1a7cf0a17664	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	2025-10-11 03:00:00+00	2025-12-21 03:00:00+00	COMERCIAL	Etapa 1 importada
5d2ba9a1-9a50-4e01-9cc9-1d00568fbdcb	20c472b3-fabb-4fb4-aff1-52bf1e7824e2	1	ffd18c57-fb77-4959-9191-1a7cf0a17664	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	2025-10-11 03:00:00+00	2025-12-07 03:00:00+00	COMERCIAL	Etapa 1 importada
5bc313fc-4694-4129-a80c-5677e1e4c9da	c472d04a-981c-440b-9d39-1fe5179a970a	1	c85b8285-3bc6-43bc-b664-4b675ee2876d	86f70064-a55b-4d55-b7e9-dc3f320c4cc1	86f70064-a55b-4d55-b7e9-dc3f320c4cc1	2025-09-16 03:00:00+00	2025-11-19 03:00:00+00	COMERCIAL	Etapa 1 importada
1f7b3db7-0201-4a5f-8022-e2aecc2c6c7e	f135f85b-f314-4211-898d-90a9053374a7	1	5507dd96-8c9a-4f7c-823a-2f87e36ef9e9	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-09-19 03:00:00+00	2025-10-07 03:00:00+00	COMERCIAL	Etapa 1 importada
9ee56e33-4f8d-4311-b928-f68efa7d725e	a91fc07b-d392-4fa2-b919-d1c99ffb94fc	1	c85b8285-3bc6-43bc-b664-4b675ee2876d	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-09-29 03:00:00+00	2025-10-30 03:00:00+00	COMERCIAL	Etapa 1 importada
60e0da40-c89c-4988-83d7-9c8fa15e6149	35084f5f-291a-4396-8c74-0c9106761c72	1	c85b8285-3bc6-43bc-b664-4b675ee2876d	caf4d1b5-7a3c-445b-98f9-42d842f1d347	caf4d1b5-7a3c-445b-98f9-42d842f1d347	2025-09-28 03:00:00+00	2025-11-07 03:00:00+00	COMERCIAL	Etapa 1 importada
8d5493a7-d8d0-4e96-80c2-2d0f8366c639	e5047731-c818-48ff-a2a0-8ea5fba090e3	1	bec74e80-f32e-4e58-9588-35bd863f8715	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-09-30 03:00:00+00	2025-10-05 03:00:00+00	COMERCIAL	Etapa 1 importada
ec9f89bc-ce38-45cd-9a29-1c1dc78874a2	e5047731-c818-48ff-a2a0-8ea5fba090e3	2	bec74e80-f32e-4e58-9588-35bd863f8715	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-10-07 03:00:00+00	2025-10-12 03:00:00+00	COMERCIAL	Etapa 2 importada
0e4e8d7e-8072-4ec0-8811-a7a525b4aef3	e5047731-c818-48ff-a2a0-8ea5fba090e3	3	bec74e80-f32e-4e58-9588-35bd863f8715	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-10-14 03:00:00+00	2025-10-18 03:00:00+00	COMERCIAL	Etapa 3 importada
724ce821-a902-4c09-ab66-47b6642c9ae9	e5047731-c818-48ff-a2a0-8ea5fba090e3	4	bec74e80-f32e-4e58-9588-35bd863f8715	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-10-20 03:00:00+00	2025-10-24 03:00:00+00	COMERCIAL	Etapa 4 importada
1bc02515-5ce3-4898-a4fe-93212f395fdc	e5047731-c818-48ff-a2a0-8ea5fba090e3	5	bec74e80-f32e-4e58-9588-35bd863f8715	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-10-26 03:00:00+00	2025-10-31 03:00:00+00	COMERCIAL	Etapa 5 importada
247e110e-30a4-4d89-9f41-03038cb508e2	e5047731-c818-48ff-a2a0-8ea5fba090e3	6	bec74e80-f32e-4e58-9588-35bd863f8715	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-11-01 03:00:00+00	2025-11-09 03:00:00+00	COMERCIAL	Etapa 6 importada
1843f4ac-d448-4e22-97fb-bbf6d783a45e	3d877597-8d10-4ba1-bde2-25c8e8818454	1	bec74e80-f32e-4e58-9588-35bd863f8715	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-10-14 03:00:00+00	2025-11-23 03:00:00+00	COMERCIAL	Etapa 1 importada
07e247fc-647c-48e3-829c-30794ff48acb	5a6bbfa4-a098-4b19-99aa-cc3ffdfbaafb	1	ffd18c57-fb77-4959-9191-1a7cf0a17664	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	2025-10-11 03:00:00+00	2025-12-07 03:00:00+00	COMERCIAL	Etapa 1 importada
b681bb0f-f5ea-47e4-851e-afeb25f6a532	93693fac-b9cf-4581-a11b-0a40d643de14	1	bec74e80-f32e-4e58-9588-35bd863f8715	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-10-19 03:00:00+00	2025-10-23 03:00:00+00	COMERCIAL	Etapa 1 importada
49b329a4-12c2-41f2-bbd1-1cdcecd752ac	93693fac-b9cf-4581-a11b-0a40d643de14	2	bec74e80-f32e-4e58-9588-35bd863f8715	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-10-24 03:00:00+00	2025-10-29 03:00:00+00	COMERCIAL	Etapa 2 importada
4a97f7df-9148-4ab3-86e2-2e73ff369abf	93693fac-b9cf-4581-a11b-0a40d643de14	3	bec74e80-f32e-4e58-9588-35bd863f8715	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-11-03 03:00:00+00	2025-11-10 03:00:00+00	COMERCIAL	Etapa 3 importada
f49bb02c-2313-4f6d-a99e-63d145e48fbe	29b952e7-e297-4266-9291-8620c4ac7f07	1	79d74266-23c8-4096-b660-cda06d12272c	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-10-30 03:00:00+00	2025-12-11 03:00:00+00	COMERCIAL	Etapa 1 importada
5c3d9b14-4172-42f4-8ead-6393d4e6f442	132a2d01-f41a-4723-9e46-50e97f71f404	1	ffd18c57-fb77-4959-9191-1a7cf0a17664	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	2025-10-23 03:00:00+00	2025-11-26 03:00:00+00	COMERCIAL	Etapa 1 importada
28903d17-6828-482c-8e65-e83cb39c2db6	3ff96bdc-e6e2-4e15-9a5f-400a00142602	1	c85b8285-3bc6-43bc-b664-4b675ee2876d	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-10-29 03:00:00+00	2025-11-20 03:00:00+00	COMERCIAL	Etapa 1 importada
fe3ce1a0-4ff5-4d83-8300-b37e7e30f459	aec58204-f489-4d6f-a981-3b42ca4a341b	1	79d74266-23c8-4096-b660-cda06d12272c	\N	\N	2025-10-27 03:00:00+00	2025-12-07 03:00:00+00	COMERCIAL	Etapa 1 importada
d58fe0ba-40a0-4f7b-809f-f74046adf49f	424cd44c-1238-4a44-8b91-f642c33169e4	1	bec74e80-f32e-4e58-9588-35bd863f8715	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-11-04 03:00:00+00	2025-11-12 03:00:00+00	COMERCIAL	Etapa 1 importada
8765f393-dd01-43d0-9f1c-0e6da47317e3	424cd44c-1238-4a44-8b91-f642c33169e4	2	bec74e80-f32e-4e58-9588-35bd863f8715	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-11-14 03:00:00+00	2025-11-18 03:00:00+00	COMERCIAL	Etapa 2 importada
761a3b85-3a0c-49bf-9cc7-8f582edca42b	424cd44c-1238-4a44-8b91-f642c33169e4	3	bec74e80-f32e-4e58-9588-35bd863f8715	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-11-22 03:00:00+00	2025-11-27 03:00:00+00	COMERCIAL	Etapa 3 importada
6e84f9f4-59b7-4dc0-bd4e-021d9b8063f1	424cd44c-1238-4a44-8b91-f642c33169e4	4	bec74e80-f32e-4e58-9588-35bd863f8715	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-11-30 03:00:00+00	2025-12-06 03:00:00+00	COMERCIAL	Etapa 4 importada
d0dc7ca9-93b2-4ef1-b759-b4966fd78d5c	03f39242-83f3-4606-9af8-bb52b2e5691a	1	bec74e80-f32e-4e58-9588-35bd863f8715	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-11-01 03:00:00+00	2025-11-12 03:00:00+00	COMERCIAL	Etapa 1 importada
68d16300-c6aa-4d02-84de-108f26540adf	16769449-70e9-4830-91df-fdb05cfda24f	1	bec74e80-f32e-4e58-9588-35bd863f8715	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-11-03 03:00:00+00	2025-11-12 03:00:00+00	COMERCIAL	Etapa 1 importada
2f758927-26a5-4a96-a8cc-3cb90ccafad9	16769449-70e9-4830-91df-fdb05cfda24f	2	bec74e80-f32e-4e58-9588-35bd863f8715	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-11-14 03:00:00+00	2025-11-21 03:00:00+00	COMERCIAL	Etapa 2 importada
b7f1ab3c-3def-4a82-872b-f898ad6dd121	16769449-70e9-4830-91df-fdb05cfda24f	3	bec74e80-f32e-4e58-9588-35bd863f8715	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-11-23 03:00:00+00	2025-12-01 03:00:00+00	COMERCIAL	Etapa 3 importada
1329e3ab-ecc2-4066-8063-c9be23022f58	16769449-70e9-4830-91df-fdb05cfda24f	4	bec74e80-f32e-4e58-9588-35bd863f8715	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-12-03 03:00:00+00	2025-12-11 03:00:00+00	COMERCIAL	Etapa 4 importada
3ff7f386-67f4-458a-9196-efb3ca6a9ad1	d5596483-4141-4dbe-b48b-89012e691760	1	ffd18c57-fb77-4959-9191-1a7cf0a17664	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	2025-11-07 03:00:00+00	2025-11-25 03:00:00+00	COMERCIAL	Etapa 1 importada
7bc7d598-b722-45cd-b0fa-c98529f65230	d5596483-4141-4dbe-b48b-89012e691760	2	ffd18c57-fb77-4959-9191-1a7cf0a17664	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	2025-11-28 03:00:00+00	2025-12-21 03:00:00+00	COMERCIAL	Etapa 2 importada
d2426890-99ab-4750-afbf-cf0e9ae2b1b0	fd8f8843-0481-47d7-825a-1a8f99650ab0	1	\N	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-11-04 03:00:00+00	2025-11-11 03:00:00+00	COMERCIAL	Etapa 1 importada
637d7472-22f1-45c1-9e54-0f774b794200	361d3933-1f72-4b73-9a61-b6e0f59c8765	1	ffd18c57-fb77-4959-9191-1a7cf0a17664	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-11-12 03:00:00+00	2025-12-24 03:00:00+00	COMERCIAL	Etapa 1 importada
87baa544-d81c-4886-9f1b-efed680e9f9c	8e16409e-972b-48dd-9ed5-e9c74a66d9f5	1	79d74266-23c8-4096-b660-cda06d12272c	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-11-10 03:00:00+00	2025-12-12 03:00:00+00	COMERCIAL	Etapa 1 importada
7deec07a-3cc3-460e-93a2-595edd67b49e	443ec94f-0465-46b4-a4ec-4d9a1c012736	1	c85b8285-3bc6-43bc-b664-4b675ee2876d	86f70064-a55b-4d55-b7e9-dc3f320c4cc1	86f70064-a55b-4d55-b7e9-dc3f320c4cc1	2025-11-20 03:00:00+00	\N	COMERCIAL	Etapa generada automáticamente (sin desglose)
ce68d951-3ae8-42a3-884e-6c82c4d63f61	eae8128f-4c82-49d7-a943-fa363d23a025	1	c85b8285-3bc6-43bc-b664-4b675ee2876d	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	2025-11-26 03:00:00+00	\N	COMERCIAL	Etapa generada automáticamente (sin desglose)
ddc62804-8db7-46ff-a03e-214e90f23b7e	04a1cdbe-7149-4e8d-977c-44f6d2f4a7e8	1	bec74e80-f32e-4e58-9588-35bd863f8715	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-12-01 03:00:00+00	2025-12-16 03:00:00+00	COMERCIAL	Etapa 1 importada
fede7ce3-0f86-4fa9-97ba-623c24da8746	b19c9c30-bb96-40bf-a49b-775465d36c79	1	79d74266-23c8-4096-b660-cda06d12272c	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-12-15 03:00:00+00	\N	COMERCIAL	Etapa generada automáticamente (sin desglose)
8d7ade9c-723e-4613-bbb8-7ddbb280506d	7c44efd9-7014-4dd0-b9c7-79ba62ddc27e	1	79d74266-23c8-4096-b660-cda06d12272c	\N	\N	2025-12-15 03:00:00+00	\N	COMERCIAL	Etapa generada automáticamente (sin desglose)
dd2010eb-1a21-4fd1-8c6d-d87a721aeb34	303c427b-cdff-4309-bd0b-3f4caf98bab5	1	c85b8285-3bc6-43bc-b664-4b675ee2876d	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-12-29 03:00:00+00	\N	COMERCIAL	Etapa generada automáticamente (sin desglose)
24c1f9d4-e59f-4a4b-921b-286f93c72a81	34db321f-b286-48f6-b61f-f44509898775	1	551b3773-09f9-4eb6-a9ce-88abf50b63a1	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	2025-12-26 03:00:00+00	\N	COMERCIAL	Etapa generada automáticamente (sin desglose)
f83d6075-c947-4d0f-8596-c1c30f963616	1026ef4f-3fcc-4a84-81b6-6d4348392a32	1	551b3773-09f9-4eb6-a9ce-88abf50b63a1	caf4d1b5-7a3c-445b-98f9-42d842f1d347	caf4d1b5-7a3c-445b-98f9-42d842f1d347	2025-12-29 03:00:00+00	\N	COMERCIAL	Etapa generada automáticamente (sin desglose)
0f0dc4ea-5a5e-4dce-8aa0-fb3887849e97	703f8ca5-aa24-459b-b097-8bb19c76e642	1	551b3773-09f9-4eb6-a9ce-88abf50b63a1	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	6771adbe-0387-41ba-a8d0-3a49e63fa8e9	2025-12-29 03:00:00+00	\N	COMERCIAL	Etapa generada automáticamente (sin desglose)
677e13c3-1256-465e-b3b6-3a6b5c2e7322	07aea281-00d0-4126-89e2-ca221df02dcd	1	551b3773-09f9-4eb6-a9ce-88abf50b63a1	\N	\N	2025-12-26 03:00:00+00	\N	COMERCIAL	Etapa generada automáticamente (sin desglose)
28d74b4a-03e3-47b4-9fa3-6a88605f3004	fb8d7763-2397-4b93-82a4-3e6ba9aeb86b	1	551b3773-09f9-4eb6-a9ce-88abf50b63a1	\N	\N	2025-12-26 03:00:00+00	\N	COMERCIAL	Etapa generada automáticamente (sin desglose)
024b54b1-01f6-4078-92e4-9ebafa5923d4	93354546-0f09-4f3f-95a0-00763ff755d9	1	ffd18c57-fb77-4959-9191-1a7cf0a17664	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	2025-12-26 03:00:00+00	\N	COMERCIAL	Etapa generada automáticamente (sin desglose)
640198be-3c48-4260-9c31-3c8bc72000e9	c701df10-fd15-4d68-bb12-b8f3dee68a93	1	ffd18c57-fb77-4959-9191-1a7cf0a17664	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	2025-12-30 03:00:00+00	\N	COMERCIAL	Etapa generada automáticamente (sin desglose)
7ad597c1-093b-467e-a9c8-de9b3ee941c7	fbcbbf37-d9f9-40de-8cfb-064542565b7d	1	ffd18c57-fb77-4959-9191-1a7cf0a17664	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	2025-12-23 03:00:00+00	\N	COMERCIAL	Etapa generada automáticamente (sin desglose)
06beeea6-5625-4ac1-93f9-3734a871f6d2	45b99544-0bf2-47b8-a879-d768d53e9d23	1	ffd18c57-fb77-4959-9191-1a7cf0a17664	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	89cdbc49-84ec-4812-ba12-fdd3cd9c99ba	2025-12-30 03:00:00+00	\N	COMERCIAL	Etapa generada automáticamente (sin desglose)
56026e02-fb1c-4a8f-af36-614a94627bb5	e75b68eb-8771-4c46-969d-b740711a69e1	1	551b3773-09f9-4eb6-a9ce-88abf50b63a1	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-12-29 03:00:00+00	\N	COMERCIAL	Etapa generada automáticamente (sin desglose)
0c23ceac-81e3-41ba-9c1c-c9a56fa4588b	b7b1cba7-1a9f-4f81-bf9e-91fd85368074	1	79d74266-23c8-4096-b660-cda06d12272c	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-12-26 03:00:00+00	\N	COMERCIAL	Etapa generada automáticamente (sin desglose)
d4c2662f-fa22-40e7-9500-a25132168dd2	7bed6c63-432e-4372-94ed-08c541cebdcb	1	551b3773-09f9-4eb6-a9ce-88abf50b63a1	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-12-28 03:00:00+00	\N	COMERCIAL	Etapa generada automáticamente (sin desglose)
2bcd4dea-a0a8-456c-97b1-3518d7711c6c	323b4701-fc99-470f-a91b-d37621df5fd0	1	551b3773-09f9-4eb6-a9ce-88abf50b63a1	1fcba1f2-fbf3-4489-b379-286b21f99fd8	1fcba1f2-fbf3-4489-b379-286b21f99fd8	2025-12-28 03:00:00+00	\N	COMERCIAL	Etapa generada automáticamente (sin desglose)
\.


--
-- Data for Name: mareas_etapas_observadores; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mareas_etapas_observadores (id, id_etapa, id_observador, rol, es_designado) FROM stdin;
23c6d035-3153-483c-b4ef-b40b572718cd	2bcd4dea-a0a8-456c-97b1-3518d7711c6c	c805581a-6aaf-49f2-9845-52f0976659e1	PRINCIPAL	t
021ec7f4-3a65-474a-a24b-1f4defbbb280	9196c09e-6103-46b6-b45e-4e679f634162	99f20cc1-6646-47a5-a8ab-db8e1d1b5a4c	PRINCIPAL	t
b9205bc6-2b1a-49bb-90e0-77851dad9e2c	dd92e43b-10fe-45a8-bac1-763e3161f51d	66e0eede-1fbd-4831-85f0-a7bea79c34d3	PRINCIPAL	t
921b1acb-46b6-4be6-b95b-fb8296796cae	cd54530b-2eb9-42ec-b04f-15dc7aef3709	277251b3-cac9-49e5-a46c-91681fc081d6	PRINCIPAL	t
3b85af9e-37d1-414a-8e3b-1b406e427da9	fa195896-5843-4352-a04a-419b3706bda6	fc382ff6-1ed2-49e5-988a-90c09b49dadb	PRINCIPAL	t
3da0fa1f-a8ab-4970-a5d3-ad9dbd0e8815	4fc05038-94e4-4720-a036-c52f2c217748	015409b2-59f2-404e-858b-1af9c9c1f5ba	PRINCIPAL	t
4b557409-91ec-4da0-8667-4182a4770e3f	f98a2218-abde-482d-b730-2e1ebe9355ef	f5ee5150-4ca5-4268-ba0c-8fb04fd70162	PRINCIPAL	t
afa17d9c-f499-4b8a-989d-23943763a060	1afa671a-a689-44d6-be5c-adf196d31b4a	c7824abb-e0e6-4c6e-b448-066c30d550ff	PRINCIPAL	t
c71241af-888e-492c-932f-331e099d7412	aadb0816-53eb-4cee-8f76-a06cf4bcd070	501379b1-853c-401d-8409-bc4b31b95b4d	PRINCIPAL	t
9b2891c5-65bf-473b-92f8-e46165741b05	755fa33b-4e6f-4186-92cc-8ffc6ee2b018	c281fbc5-de0a-4b8c-b5f9-20c2564c9ef1	PRINCIPAL	t
3a3f4dae-33d2-425f-b933-8adac1c93df1	2dc69255-ca6a-4228-911b-717383cecdba	c281fbc5-de0a-4b8c-b5f9-20c2564c9ef1	PRINCIPAL	t
d6ae431e-4b91-4bc4-b8e4-d4a85bee8800	f79d8ded-61a3-40e5-bce7-68f83297ad41	c281fbc5-de0a-4b8c-b5f9-20c2564c9ef1	PRINCIPAL	t
54e1df44-5d2f-4dc4-a270-6026cadd219c	64d79403-d8ec-4ba7-93ca-e77c835ed50e	1197662f-ec99-4fcf-a002-e0c80670302b	PRINCIPAL	t
9806c333-b578-4bb1-84ab-6118e3dd3c58	66cf951a-f6b7-449b-a3bf-69301900d254	05943df7-12f7-4f5b-b4bd-8362394e6fd5	PRINCIPAL	t
a23478ba-3db0-4874-a741-89c48dc9cb66	6da011c9-a0f6-4e41-b26d-2b8966b5a648	bae7f1a0-bf6b-48d1-9c44-2a55cd6af939	PRINCIPAL	t
edd5aa54-3afe-4219-9743-0574f54f275f	d7e865d7-077d-470d-ac79-295145f0d225	82eec08c-333b-4fd0-86ad-b2bee3277fc4	PRINCIPAL	t
231e5e02-4146-4c7c-bb8d-41aa10c8ce72	284cbd61-cf83-44b6-90bf-f0dcdef6e18a	d10d1d34-7d04-48bc-8ed5-8702aaec6da0	PRINCIPAL	t
f8a8bcf6-5c52-4cfa-b394-76a29db16b97	4e0718e3-01d4-45ad-b8f5-48693e7d3507	c6bde025-138c-4468-8700-54aef611902a	PRINCIPAL	t
08774ccd-43bc-430e-9941-7c4a83514e4d	ce0361fc-82ce-4896-8c1a-87f8212a0062	55af1bd2-74bc-4ae5-970c-d916a9e78ef3	PRINCIPAL	t
c54dae48-22c5-43d9-91b9-8f375701bdaf	bb27ff74-f42b-44d6-b5ec-984812fb7a90	55af1bd2-74bc-4ae5-970c-d916a9e78ef3	PRINCIPAL	t
3e2d4cf9-91bf-4ed2-aaf0-a07d101d958b	11de3b20-45a4-4b83-a319-80dbd3060da9	55af1bd2-74bc-4ae5-970c-d916a9e78ef3	PRINCIPAL	t
2df6d204-4619-4d21-aff9-b34ed4f943d2	17a03ec0-c822-4420-a866-2a9e83ee866e	55af1bd2-74bc-4ae5-970c-d916a9e78ef3	PRINCIPAL	t
cb1924bb-ee9d-44d1-a56e-3465268e9dec	e6787391-c5d2-47b0-8d88-5bc3ab3ef903	99f20cc1-6646-47a5-a8ab-db8e1d1b5a4c	PRINCIPAL	t
785bfc56-f865-4683-9efb-0bf3d670e40c	b7376a50-6cbc-4ece-abb3-237e7a3d521c	bb98934e-9e10-4baf-b1da-102b64cd898c	PRINCIPAL	t
9ee545ba-bab6-4208-b2d8-71c586728fe0	f85f17e7-482f-43ac-9965-2081f146cc01	bfb93ee4-854e-446e-bea9-ef9512671d4a	PRINCIPAL	t
d551a32a-977b-43e8-ae8c-4e5dd9b82a95	fd5c6074-99b8-46cc-91d6-6fb8e1f7002b	681170d0-e33a-4864-a5ed-b340efad9eab	PRINCIPAL	t
17a5b0b1-d355-4fdb-9ac3-13cdd960cd87	5062c285-de73-4aeb-81ae-7f468b777e12	c7824abb-e0e6-4c6e-b448-066c30d550ff	PRINCIPAL	t
6e28f326-17a2-4a75-b10f-c31b92b776db	a7e853ac-50ee-41e0-adbf-9f041860095d	23ea449a-5717-4c85-a0c7-0af76c1d342f	PRINCIPAL	t
5b231c1f-342e-4d8a-ba3c-b92b9fe3c3d4	8eb43544-8ba1-48ba-81af-5630b5fe3e6c	de89af79-db6f-4f3f-b3f4-92515a098490	PRINCIPAL	t
3c9a68d6-dcbf-4c64-90b3-0cbcf9ddac80	d213ae78-5e6a-44ce-85a5-1a58b0bc4082	bb98934e-9e10-4baf-b1da-102b64cd898c	PRINCIPAL	t
a61e0834-d22c-4311-820a-d80eaec71268	62d00051-ae68-4851-94b8-343deecbb029	bb98934e-9e10-4baf-b1da-102b64cd898c	PRINCIPAL	t
13c0cbac-14b7-4f76-ad9c-69a378191b4d	f2c1e857-685b-412a-8e0e-533ddc55157f	277251b3-cac9-49e5-a46c-91681fc081d6	PRINCIPAL	t
023e2abd-5012-4ab7-8234-d0b6173b19b6	d74179eb-6635-4a48-acfb-18a610588502	2317749a-d197-4873-a9fc-ac7e1ac81feb	PRINCIPAL	t
8d92d7b2-7c08-4ad6-a4f5-bcbd19575c8e	d313005e-6404-4577-a9db-6188cd951424	fdfbf185-599e-401f-8f65-24f1174f1e04	PRINCIPAL	t
71e87302-1fd3-4cc9-877c-844b66528a35	7591404e-8e4d-4bb0-ac58-8acf116f66a8	886af39c-fefe-4d8a-84ed-cb6d102f23a1	PRINCIPAL	t
ca164b86-bddd-44f8-a9bb-66c4ca37ca32	c764f091-def5-4d8f-84f1-683491847d7d	62c16919-f33c-49d1-b3ad-24fe015c7264	PRINCIPAL	t
5255699e-fa89-4955-9e83-5721e499ec91	4f57f549-eba8-4338-a832-da49c3c5572f	63a38f88-b458-4702-898d-2e601a72f46e	PRINCIPAL	t
0353808c-3a14-4831-a93c-46f82568cd50	fe082ba1-f776-4224-a497-44ecc9096834	67dd05bf-c7d9-46c9-8ecb-4acd56e08b2c	PRINCIPAL	t
65bd86b9-c52a-4c54-bf0a-d97fa12248ce	0bce172f-f383-4db1-b9e2-b8ce7da0c59f	09a06c54-6c63-45ea-8713-05c23ea758a3	PRINCIPAL	t
ab1f4c51-a992-4186-aff9-6efa3ea736ef	3a2cdb83-e85f-4861-a36c-c00003a56957	b2ef0bc6-9476-4d7c-9b4f-a41fb2bf27db	PRINCIPAL	t
216ed66a-c252-41a4-bfd1-3749e77e06ca	52e6bda3-8a3f-4049-84ad-149cf72083cb	501379b1-853c-401d-8409-bc4b31b95b4d	PRINCIPAL	t
c7da4933-6b4e-429c-a26f-a9a9ac696a59	52cd26b7-dddc-45b0-ada7-4342fe890af7	bae7f1a0-bf6b-48d1-9c44-2a55cd6af939	PRINCIPAL	t
b0ac5187-ef05-4a44-88c6-c03ee413a667	8ee91dee-6938-41f1-9f4c-0a9864efccdc	82eec08c-333b-4fd0-86ad-b2bee3277fc4	PRINCIPAL	t
cb817956-b7f3-44f5-b13c-13fea8ebfa04	c566af59-f763-47f0-8e84-40f85224a725	ea3e3865-272a-4512-b0fa-028a4ef708dd	PRINCIPAL	t
4ab2d515-7073-4696-ab67-ca5707b25aeb	13330c47-efb2-4ebb-b782-e345652064ec	1197662f-ec99-4fcf-a002-e0c80670302b	PRINCIPAL	t
01c9d1e8-27ae-45e0-9d75-d622f45abbf5	65285f8e-18e1-4f34-bcbf-4ed118b5c0e9	b288e78b-597d-4077-8eed-4a751481a764	PRINCIPAL	t
0a04e28e-2721-47e0-8406-30fa9d8612ce	8ba7a755-4a88-4c6c-a772-58024e7ece04	99f20cc1-6646-47a5-a8ab-db8e1d1b5a4c	PRINCIPAL	t
c2770d01-a19d-44b7-b7ae-36f104998174	f90cd14d-1086-48fe-a154-1e928630fa84	1cfdc183-5136-4923-ac14-01dda4d47a51	PRINCIPAL	t
97b0fe6e-8efb-478e-ad08-7f772d68c316	82a44246-0381-4332-9860-908c904f02df	dec6f04a-0a75-43a8-89c9-dde5780e0384	PRINCIPAL	t
2c923d48-3eac-4d60-856a-338fd0bfec14	3fcb899c-18ba-47eb-8e15-631cbce57d39	dec6f04a-0a75-43a8-89c9-dde5780e0384	PRINCIPAL	t
ae11b5fc-a9d1-4740-87a2-901fd4004e56	601ee92a-ee9e-42d4-a6f7-7074f4341a1a	366c1b74-afac-4cb3-99bc-4b7114bff512	PRINCIPAL	t
9550d908-5b49-4363-b80b-232e909fee02	d6657385-2496-4c77-9eca-25f8bd74a97b	366c1b74-afac-4cb3-99bc-4b7114bff512	PRINCIPAL	t
49149ce1-eda0-415d-8e13-cbfaf3442638	b8f24815-0f35-4d95-86a0-2c71124566b7	66e0eede-1fbd-4831-85f0-a7bea79c34d3	PRINCIPAL	t
588806b7-5bad-4706-9bc4-09f7b8baf648	bec594cc-34db-4a3a-92e0-77f1a338c315	66e0eede-1fbd-4831-85f0-a7bea79c34d3	PRINCIPAL	t
bdb08eb1-39dc-4572-b26f-334748c020ca	e4548b41-9cb0-4062-99b7-dd378e6f5a6d	501379b1-853c-401d-8409-bc4b31b95b4d	PRINCIPAL	t
81e6bfd0-2949-4e25-b07d-ea03585bd0f4	ac490d6c-c4a2-4276-88b6-7589f40a644d	501379b1-853c-401d-8409-bc4b31b95b4d	PRINCIPAL	t
b1fe9ac6-3397-47e5-8453-64c0d3fa55ef	2cd59c05-5e62-4716-b007-f53b33c70dcc	d10d1d34-7d04-48bc-8ed5-8702aaec6da0	PRINCIPAL	t
9aef2032-6e53-4a91-9df8-78644e90245e	c765c065-57d4-4347-a10d-27ff24a14f90	d10d1d34-7d04-48bc-8ed5-8702aaec6da0	PRINCIPAL	t
c19c0681-ee03-42b5-a165-89faa1b347bc	6b00c1f1-e1db-477b-9384-63a73f51193d	e2c757c5-ba91-4d0d-81b8-792d549909f7	PRINCIPAL	t
1033ad77-1689-4509-9c9d-76074fa974d3	e27d30e5-ad4f-47a0-ba91-750b0d879b74	bf21c0ee-9b33-4fac-83f0-694133cfd351	PRINCIPAL	t
b596ea00-77eb-40df-be3b-d8524f5c0e1d	1d4c99af-537f-46af-aaad-aa085ebbddf4	015409b2-59f2-404e-858b-1af9c9c1f5ba	PRINCIPAL	t
84efc58d-2770-4c83-8b02-d924084ecee2	bedbe085-d4b3-4191-9e1e-b417a43322c4	2317749a-d197-4873-a9fc-ac7e1ac81feb	PRINCIPAL	t
d5aa491c-0cdb-4e7c-be01-aa2c49c6d7fa	520d32c5-3806-43c2-8818-28f9735425be	05943df7-12f7-4f5b-b4bd-8362394e6fd5	PRINCIPAL	t
b6dadca3-161e-4b51-8bb4-87992aa79355	f7c0e96c-741d-455a-897c-97b03cab947b	2e5ec06b-e15b-4696-b541-5ae0c626b2c7	PRINCIPAL	t
14b345d8-eace-4235-876a-e1745092ec77	bc9e5fbf-f5ce-4984-b170-6644f9a5028c	681170d0-e33a-4864-a5ed-b340efad9eab	PRINCIPAL	t
2fb0e445-266b-4406-a91f-ce7ca148bba7	36834950-7ee3-4892-b120-a458a08b461f	b288e78b-597d-4077-8eed-4a751481a764	PRINCIPAL	t
0ffc3122-4c17-4195-8d4e-ecd67629d705	df1c49d3-8cc2-469b-9f12-815d889e357c	277251b3-cac9-49e5-a46c-91681fc081d6	PRINCIPAL	t
1b3a60a6-d7c6-4de1-9c21-629b3398d85b	1d8a3667-dac5-49f5-a348-2cedf0e56c2c	f5ee5150-4ca5-4268-ba0c-8fb04fd70162	PRINCIPAL	t
a4d02a30-666d-4ae8-983c-720df1a7c907	771d15cb-5878-4ff8-bebf-50c50b5561fe	d10d1d34-7d04-48bc-8ed5-8702aaec6da0	PRINCIPAL	t
3fc07c4c-6bb7-41db-bec4-b6309b9c7b74	5e25c802-25a6-4e81-8235-a44c9b48e301	1cfdc183-5136-4923-ac14-01dda4d47a51	PRINCIPAL	t
96b844b2-cd30-49e1-85e4-5a56478f4c52	1e568464-47a9-4a1f-a92f-d59e1e26dfb4	bfb93ee4-854e-446e-bea9-ef9512671d4a	PRINCIPAL	t
22c4af33-913b-419e-b8b9-bcd6af43018e	fdee6a26-2694-487f-9bcf-5d414fc5106c	fc382ff6-1ed2-49e5-988a-90c09b49dadb	PRINCIPAL	t
52d26715-db83-47fc-b749-ba08efc3d88c	98cea98d-7650-4afc-a84b-c4613afbc013	366c1b74-afac-4cb3-99bc-4b7114bff512	PRINCIPAL	t
f87f4a20-a11a-458e-9d10-7ad24a2082ca	8a96f45a-4840-4af4-a3f1-0aba108e81a7	501379b1-853c-401d-8409-bc4b31b95b4d	PRINCIPAL	t
28f3faf1-b444-43fb-b7b5-9f3bdbdec85e	23a3da47-5489-4ca2-a345-ca854bc7622e	dec6f04a-0a75-43a8-89c9-dde5780e0384	PRINCIPAL	t
6eb18451-943e-46d6-900f-f65980cde26f	63f9641b-a6f8-4d12-86ac-9a80886c0ecd	dec6f04a-0a75-43a8-89c9-dde5780e0384	PRINCIPAL	t
fe39230b-aba6-4d2a-99a7-a83f21923ece	d3aa3903-13f1-45d7-9359-bbc78406ef53	dec6f04a-0a75-43a8-89c9-dde5780e0384	PRINCIPAL	t
46c35486-6f79-41be-9377-6498fa704f7c	d7a7b81c-0883-41b4-955b-bfbd9027ed8b	55af1bd2-74bc-4ae5-970c-d916a9e78ef3	PRINCIPAL	t
e8566549-3c42-42b1-b4e1-4c90ef3c385e	e8728e52-e993-4898-a5c4-939c705f0671	63a38f88-b458-4702-898d-2e601a72f46e	PRINCIPAL	t
f8f968be-4385-4089-91fc-075efb0946a0	71572985-8aa5-4ab7-8c85-c1419e105199	63a38f88-b458-4702-898d-2e601a72f46e	PRINCIPAL	t
7846c910-0274-46f9-ae2e-f7d239c303c3	01ab97da-4b15-461f-ba74-0b32bbc6aa55	63a38f88-b458-4702-898d-2e601a72f46e	PRINCIPAL	t
009dd10b-b712-45cd-8ac1-cdc3f8ecf1b8	e8a086c0-8b75-40fc-863b-d076ae597e9a	66e0eede-1fbd-4831-85f0-a7bea79c34d3	PRINCIPAL	t
13b527c7-ea7b-48e8-bb68-0867dc9d80bf	84790237-7482-4462-ac05-7cc5c6468531	66e0eede-1fbd-4831-85f0-a7bea79c34d3	PRINCIPAL	t
3efa8350-528d-4c62-9af4-238216411925	e355c463-6579-47b5-80ba-296645254a46	62c16919-f33c-49d1-b3ad-24fe015c7264	PRINCIPAL	t
ad5d349d-33d2-4fe8-aec3-6b34bd89a487	cfa72d9c-9fbd-4cc6-a794-9e28ce66644d	c281fbc5-de0a-4b8c-b5f9-20c2564c9ef1	PRINCIPAL	t
87ac21ed-b5bd-408d-b7dd-69596c92df2f	dbefe786-66ab-40c3-8576-468d5b643ae3	c281fbc5-de0a-4b8c-b5f9-20c2564c9ef1	PRINCIPAL	t
479cde4f-ea35-4d90-a58a-2265a79624c0	aaa1c60a-dbb7-443b-8ff8-392c4cde39b3	c281fbc5-de0a-4b8c-b5f9-20c2564c9ef1	PRINCIPAL	t
02494e37-29ca-4510-8dc4-1cadb71d9fa0	7e630dba-389d-4cdd-a4be-07b994e3daed	2317749a-d197-4873-a9fc-ac7e1ac81feb	PRINCIPAL	t
4616b964-14b4-4f6c-8832-9b581294600a	2de6d7a2-a9e3-4e60-9561-aaf35b203a75	565abd74-0cfb-42ea-81bd-ae487fed298c	PRINCIPAL	t
20729f5d-43e9-4a66-9670-a1e47c7b6629	46c9efba-6da6-4415-a6d7-93297fa16797	565abd74-0cfb-42ea-81bd-ae487fed298c	PRINCIPAL	t
f7bc2c16-afd9-475c-88f1-023c87f8ba56	08a9bec1-d245-4926-a6eb-176ddbe8eee4	c0961ab2-ceae-4c27-a9d5-4f54ac510076	PRINCIPAL	t
db0ccb9e-c152-4d99-8280-70da07bf1c76	958ab634-d457-43d1-9369-0ca99d08c2cf	7095db62-e46b-4622-831e-828b9da3a996	PRINCIPAL	t
5be2324e-4d37-4387-a203-e1c45d5aa55f	a98b32d9-bcdb-436a-a3d2-f239bb0240bb	c7824abb-e0e6-4c6e-b448-066c30d550ff	PRINCIPAL	t
a0eb2379-3484-4654-a0d6-697e3cb7048f	72be29cc-3439-45fc-8292-6c34fedd7c23	c7824abb-e0e6-4c6e-b448-066c30d550ff	PRINCIPAL	t
8fe4262e-49d4-42c8-9888-028950158fca	e4d8534c-c758-429a-8949-72f070976589	c7824abb-e0e6-4c6e-b448-066c30d550ff	PRINCIPAL	t
c6dbd8ad-722e-4343-a858-2a8fd29dbdb8	d6ef3439-7830-4ee5-a9b7-093c1afd573c	015409b2-59f2-404e-858b-1af9c9c1f5ba	PRINCIPAL	t
0dbb0472-7ca5-4af0-8bdc-e80bee5bb829	af61aaae-27a4-4143-9f7a-73ba529463d7	bb98934e-9e10-4baf-b1da-102b64cd898c	PRINCIPAL	t
7c495e4b-7d6c-4df6-9849-2201d4e47a18	d5a71295-11ea-4159-8237-45b88ded59c7	82eec08c-333b-4fd0-86ad-b2bee3277fc4	PRINCIPAL	t
d0f7af90-d088-45bb-b9f1-6cdac67f2260	37e14ba9-88e8-46f0-a1da-904b35ce6035	e2c757c5-ba91-4d0d-81b8-792d549909f7	PRINCIPAL	t
7e483b8a-3317-49ec-a63b-b11117a64f8d	fef5d825-5d6a-4018-91a6-4663da054efc	1ca0dd36-2589-459a-8fd3-e0632edae4b1	PRINCIPAL	t
c210b0f5-279a-420a-b0bf-2329c7a182c4	bffd5d67-4386-40c6-a526-0ba44d2b734c	9610e6d9-7ae3-4f8d-acb1-567d47e71063	PRINCIPAL	t
ab840d45-02cc-4dd0-a3ec-256c2d9ff970	3b551758-14bd-4c8b-8370-2891745c3ed3	b2ef0bc6-9476-4d7c-9b4f-a41fb2bf27db	PRINCIPAL	t
05e1f20e-ace9-4954-8840-1390316321b6	b897be66-6368-45a3-8653-1148b5783508	bf21c0ee-9b33-4fac-83f0-694133cfd351	PRINCIPAL	t
13c1308c-10f3-425b-b85b-b8efb894b1e9	f42d80c9-d615-43fd-9561-90ec0daf4e8e	99f20cc1-6646-47a5-a8ab-db8e1d1b5a4c	PRINCIPAL	t
dc8369d5-da22-47dc-b643-fd30528bbfe8	5506ec42-e36d-43a3-9250-a3ed580fcf58	d92a6cc5-7810-4d12-84fb-95cc9965ca85	PRINCIPAL	t
8a7dc1ae-913a-4a2b-aca8-4162e5f0bb04	2ab14e06-b282-4b17-9813-95a166dde3ef	c6bde025-138c-4468-8700-54aef611902a	PRINCIPAL	t
cd393260-62f5-41e3-aa66-195ac01ce7de	e8929365-3212-4f65-ac1c-0a761f91e210	ea3e3865-272a-4512-b0fa-028a4ef708dd	PRINCIPAL	t
30d81b50-3ba9-4119-a06a-3fa7da62b1f1	5ba3e9d5-b6fa-42a0-a876-e34fed7e2db0	277251b3-cac9-49e5-a46c-91681fc081d6	PRINCIPAL	t
b11dfee3-a682-4323-8db0-220e625e15a9	4a4e8987-b94c-4b9f-b9df-5e4288b08102	1197662f-ec99-4fcf-a002-e0c80670302b	PRINCIPAL	t
e3491a15-1422-42c7-9ea4-143fceb526e2	c6cc3ed1-40ef-42e6-a275-d08875d1d6aa	05943df7-12f7-4f5b-b4bd-8362394e6fd5	PRINCIPAL	t
bc3e67e4-7c9a-40d2-b72b-aecca9310d80	181d94fb-22e0-4776-bb74-e7a08be77f97	dec6f04a-0a75-43a8-89c9-dde5780e0384	PRINCIPAL	t
0d292bf7-3cd8-43a8-8dfd-d31e52a788e9	8608bc23-f8f5-4b30-84a9-39e7e952a2cd	dec6f04a-0a75-43a8-89c9-dde5780e0384	PRINCIPAL	t
92edd074-3300-4547-a869-602bed333f88	e357e2d2-90ad-4095-af51-43ce527e800a	681170d0-e33a-4864-a5ed-b340efad9eab	PRINCIPAL	t
198aa90c-ff59-4ef1-8bcc-81231128f840	01120c48-4df0-47a9-b085-400b23d8a262	c7824abb-e0e6-4c6e-b448-066c30d550ff	PRINCIPAL	t
0f8166f7-6ab3-43bb-8183-44770bc0b9b6	28ba68ce-515b-4106-95af-69278763d581	c7824abb-e0e6-4c6e-b448-066c30d550ff	PRINCIPAL	t
7cecbce8-1bfb-4bd7-81ff-d48124154953	1fc6a70c-a804-433a-9ec1-66aba61b1598	c7824abb-e0e6-4c6e-b448-066c30d550ff	PRINCIPAL	t
9fc425c1-eb8e-4a25-9c23-33bb6e8301d9	f8b18909-7179-409f-9ce2-2f27a15e13a0	c7824abb-e0e6-4c6e-b448-066c30d550ff	PRINCIPAL	t
85fa0c18-0534-4bef-896f-404a66a135a6	fb845d7a-e7e4-4911-b2c7-20d1159629bb	66e0eede-1fbd-4831-85f0-a7bea79c34d3	PRINCIPAL	t
ab8a51d7-fc1f-4487-8163-c336bb539507	84fee8c6-2503-4276-b8b9-3111941bc248	55af1bd2-74bc-4ae5-970c-d916a9e78ef3	PRINCIPAL	t
2cc3dbaf-8f50-411b-aeda-507c11b5920c	5e3e94ef-d5a6-42fa-bd9e-7205fe693a7a	2317749a-d197-4873-a9fc-ac7e1ac81feb	PRINCIPAL	t
88a93db4-097f-4b69-b6e0-beae1e50e9f2	c22184ad-555a-4936-9c3d-fbf156a8a6b1	67dd05bf-c7d9-46c9-8ecb-4acd56e08b2c	PRINCIPAL	t
4f5dd3a7-b980-4553-819b-fc142f32bb26	f6826303-11d8-4915-b24d-24bfff99dc4e	67dd05bf-c7d9-46c9-8ecb-4acd56e08b2c	PRINCIPAL	t
3a282a3c-791f-47c3-a80d-067f3830c0d1	920ace43-a869-44e5-8a23-896134d68c49	67dd05bf-c7d9-46c9-8ecb-4acd56e08b2c	PRINCIPAL	t
e87808ed-2232-4704-a99f-4859a9a3fa02	0d7bfa2c-25b7-4366-a26a-83f4ed626fa5	67dd05bf-c7d9-46c9-8ecb-4acd56e08b2c	PRINCIPAL	t
ae53941e-0eb3-4db5-976f-afd904f27aef	53dfe99c-81d4-492f-9756-2d781903f603	67dd05bf-c7d9-46c9-8ecb-4acd56e08b2c	PRINCIPAL	t
c1be9c94-373c-466c-9b3d-120e537f7315	cb38d0bb-782f-461c-97e6-63a86bde9e24	a2e57f9b-0a17-4bef-89bf-703b5505dc4d	PRINCIPAL	t
65157021-e11a-481c-bb26-76310cfe4b90	1c867910-a33f-449e-83e7-17f0cfa63a0c	a2e57f9b-0a17-4bef-89bf-703b5505dc4d	PRINCIPAL	t
89f47cfc-1116-436d-96c2-6bb1484fcc5c	906f1770-3f4a-48e0-ac5f-1686555ba9a0	fc382ff6-1ed2-49e5-988a-90c09b49dadb	PRINCIPAL	t
fd23681e-7aca-43f9-9e28-b77248aecb07	242e3563-0c7c-4daa-97f5-4782efa5f77e	63a38f88-b458-4702-898d-2e601a72f46e	PRINCIPAL	t
58f25f92-2a0d-4045-844b-bd2806e3372d	2e1e4704-2fa5-4d4e-8555-1d7237d55215	b2ef0bc6-9476-4d7c-9b4f-a41fb2bf27db	PRINCIPAL	t
c0870dfa-2450-477e-aa8a-b54d1650afe5	ac1f3bbe-113f-4f65-bb14-c0284d633003	dec6f04a-0a75-43a8-89c9-dde5780e0384	PRINCIPAL	t
c820d278-3f3a-44e0-9783-69de9c0f3c9b	c3591dfb-c60d-466f-ba3b-7d010ee588d1	501379b1-853c-401d-8409-bc4b31b95b4d	PRINCIPAL	t
ec5ab27c-a5a2-4a64-80b7-cf909ce4aa2a	d92465bb-98af-4421-8c08-70c7fc542ef8	501379b1-853c-401d-8409-bc4b31b95b4d	PRINCIPAL	t
2b1c58d0-51b8-4311-8429-b3e5c07c114f	3a829cef-3bc9-4851-801b-8c6e75ffbde5	bf21c0ee-9b33-4fac-83f0-694133cfd351	PRINCIPAL	t
66f51645-d5a8-443c-ac99-71fa85dbc893	d86ff530-0f2b-4ed2-b3cb-1ef729192ccd	bf21c0ee-9b33-4fac-83f0-694133cfd351	PRINCIPAL	t
9f75fe9a-da69-4201-99ed-4cbac9dcc5bb	541b5d18-4ae5-4da2-99ca-c55cd5ff3e3a	bf21c0ee-9b33-4fac-83f0-694133cfd351	PRINCIPAL	t
df922f5d-7174-4041-af4e-2af2378f1029	4dda0588-bd89-4fe7-96da-ad08dbc29f6a	bf21c0ee-9b33-4fac-83f0-694133cfd351	PRINCIPAL	t
dc8165df-c322-4bfd-a8bc-cac0fa083e0f	4d78740f-2f49-4357-8b35-5d084c4c2a67	b2ef0bc6-9476-4d7c-9b4f-a41fb2bf27db	PRINCIPAL	t
4fccdf08-110f-49ef-9c24-d1f5dd5b8753	2095d470-3d2a-46eb-8d41-8f644c577d06	63a38f88-b458-4702-898d-2e601a72f46e	PRINCIPAL	t
ce35ecdc-654d-4b61-a76b-770fef1aaf0d	8a897c15-1bec-40ce-8430-c09e5d9712f9	63a38f88-b458-4702-898d-2e601a72f46e	PRINCIPAL	t
a741cffc-031c-46cb-a32a-8858410ec14d	964fdb1d-60bf-4b01-97b5-40e700227bd1	d10d1d34-7d04-48bc-8ed5-8702aaec6da0	PRINCIPAL	t
2fc50cbf-562c-4f96-8a87-363a6ac26dd4	863e7e79-708a-4730-ab9e-9d2419ee83a2	c0961ab2-ceae-4c27-a9d5-4f54ac510076	PRINCIPAL	t
d562315b-1e3a-482c-8e0c-6c77d6a9ad30	bd64df5d-6ff0-46c1-acda-65952526ede9	c0961ab2-ceae-4c27-a9d5-4f54ac510076	PRINCIPAL	t
9b2d7dfe-b709-4ca5-b6c8-f504ca38ddab	dded4d32-cfd7-4b1b-9c62-67fa8e7ba289	c0961ab2-ceae-4c27-a9d5-4f54ac510076	PRINCIPAL	t
df4c3ad6-d634-4edc-817a-35391df0268e	5b6fe20e-a9b4-4026-ba1a-830cce822422	bae7f1a0-bf6b-48d1-9c44-2a55cd6af939	PRINCIPAL	t
aaea4abb-fe4e-46d4-aaf9-6239adbfa2a2	fe25a896-bcb6-4a2a-ac30-3460d09224d6	277251b3-cac9-49e5-a46c-91681fc081d6	PRINCIPAL	t
185fc283-8b7c-459f-93a6-ecff9e16207e	b4b51511-5c7c-4a31-9286-8413ee63b6b3	fc382ff6-1ed2-49e5-988a-90c09b49dadb	PRINCIPAL	t
286b8455-163a-48f0-8f16-51ee2c66a406	ec38fb40-3c79-4e09-a881-3752d4021eb1	42e6aca7-f73f-407f-98cd-bcb775487186	PRINCIPAL	t
9d38247c-792b-4bb8-979e-6f46254db059	b8c8f73f-1309-480f-ad23-a98edbcdb014	bb98934e-9e10-4baf-b1da-102b64cd898c	PRINCIPAL	t
10502c4a-effd-4b55-acc9-046076795054	dd8f52dc-d025-4789-9b0f-949b126a8801	366c1b74-afac-4cb3-99bc-4b7114bff512	PRINCIPAL	t
94caaf73-1b8b-4e61-93b1-e96a353b7ffb	69464121-1347-4a79-b240-de22fce9a317	366c1b74-afac-4cb3-99bc-4b7114bff512	PRINCIPAL	t
58f7c0bc-f1d5-42a5-86a4-3ada41e18e70	6560a087-9d47-4492-8107-f872c6557cc4	366c1b74-afac-4cb3-99bc-4b7114bff512	PRINCIPAL	t
a404ad8b-c46d-4b80-b4f9-13cc0ff97031	6b0eca56-0c6d-4dad-a940-d11f34b96e22	366c1b74-afac-4cb3-99bc-4b7114bff512	PRINCIPAL	t
020406c8-731c-4a4b-83f5-5e53d0b6eab3	3b6ad954-92b8-483a-ab00-55cd71388a3e	1197662f-ec99-4fcf-a002-e0c80670302b	PRINCIPAL	t
3198cdd4-b5e5-4570-99d0-14d591231964	1ce66bf3-0f48-4c47-8c52-ff3e83ac7903	66e0eede-1fbd-4831-85f0-a7bea79c34d3	PRINCIPAL	t
2a9c0eec-166c-4a9b-a815-73e1fec4d0c4	7c0bdfd0-f6d1-43d7-a3f5-bb8e556c9bcb	015409b2-59f2-404e-858b-1af9c9c1f5ba	PRINCIPAL	t
eb6cbb3d-d224-4ebc-8b95-40b97b3e830f	8b9de8ac-a88d-4663-b5ab-a7ace182c4ab	d10d1d34-7d04-48bc-8ed5-8702aaec6da0	PRINCIPAL	t
28ff2d8a-0050-4100-b91c-eaf4a30bde8d	615e6058-a967-463d-922d-6a07e3c7bfdd	7095db62-e46b-4622-831e-828b9da3a996	PRINCIPAL	t
632f08d8-8f4a-4b57-b699-594faa186dd4	f3eded6a-968b-4ef5-9848-5ec375a7a25a	55af1bd2-74bc-4ae5-970c-d916a9e78ef3	PRINCIPAL	t
10e09e79-a8ec-40d0-942b-38a0cd03a8b8	7e342b48-223d-46ae-8ee7-4582af1bda1a	62c16919-f33c-49d1-b3ad-24fe015c7264	PRINCIPAL	t
c9fdcc40-e01c-44bc-8270-825f841f1f0c	9ee437d1-998b-4be1-97b8-e93c7babed1b	1cfdc183-5136-4923-ac14-01dda4d47a51	PRINCIPAL	t
a5f3253c-c1f7-4ccb-bb7c-e020a81c1113	241d4b1e-f6d9-43d5-9439-de9b310dc5c3	1cfdc183-5136-4923-ac14-01dda4d47a51	PRINCIPAL	t
b3466866-dd00-463a-9a5c-2fba0b5d401b	14f44c9b-a1ad-4e40-b28e-9ebc238a191d	1cfdc183-5136-4923-ac14-01dda4d47a51	PRINCIPAL	t
bb3e656d-302a-4d38-8241-bc34c81e33e2	477bfd5a-6a74-4a47-9049-20a72be4b7e7	b288e78b-597d-4077-8eed-4a751481a764	PRINCIPAL	t
ae8cdf79-a7a1-48a1-99e1-626b0ea31333	3fffb4b0-408d-4d02-9fc2-b6db1d044d7d	501379b1-853c-401d-8409-bc4b31b95b4d	PRINCIPAL	t
a6d830b2-4f94-4f9b-b9de-f2b1e1336a00	4cf72889-7d9b-453c-80e8-387fc627dae6	2317749a-d197-4873-a9fc-ac7e1ac81feb	PRINCIPAL	t
bd392b45-e0b6-4d26-8d49-7a5a698dc814	e006835d-c622-4ce4-b35f-00bd372f47a0	2317749a-d197-4873-a9fc-ac7e1ac81feb	PRINCIPAL	t
a7d5f58b-0573-4cbb-a25a-4bbd577c207b	56e60cca-8fcd-4302-b492-41c945a92740	67dd05bf-c7d9-46c9-8ecb-4acd56e08b2c	PRINCIPAL	t
532c0ea2-f4b5-41d0-8af0-6007cfc92ebc	d4600e4a-c2e1-4c84-9639-cdef8aa76847	b2ef0bc6-9476-4d7c-9b4f-a41fb2bf27db	PRINCIPAL	t
1d8af1af-cfc3-4104-a717-5cc4811080ac	5b9412ab-5796-4034-a6ab-9f8d5a35141c	dec6f04a-0a75-43a8-89c9-dde5780e0384	PRINCIPAL	t
262fc6ab-7255-4722-a3cf-d24ed8d151b0	a46fde5f-18d5-44e8-98cc-2f9be2f5ed10	09a06c54-6c63-45ea-8713-05c23ea758a3	PRINCIPAL	t
89510d81-cabf-4cb2-be96-496adf3a8ee1	179f5629-d852-4ea4-9d24-c3e6d9094b6f	09a06c54-6c63-45ea-8713-05c23ea758a3	PRINCIPAL	t
6b86595d-8f07-4ed6-b2ba-e3afaa89ded8	a284851d-1013-43bc-bdf1-3f4e6c02e63d	09a06c54-6c63-45ea-8713-05c23ea758a3	PRINCIPAL	t
9f731ee8-164a-44ca-9ba6-bb3d7757731f	b104e82b-3925-4121-bb17-da09b72686b3	09a06c54-6c63-45ea-8713-05c23ea758a3	PRINCIPAL	t
52690878-9570-4044-a6e9-baa618191d15	c3b6c0af-7771-4674-a71f-eddc8dbe6737	501379b1-853c-401d-8409-bc4b31b95b4d	PRINCIPAL	t
15b7046e-8cc0-4459-88cd-9e9a02e20584	bab47043-601e-4774-b16f-2ab197bc2b94	f5ee5150-4ca5-4268-ba0c-8fb04fd70162	PRINCIPAL	t
10788fa8-f0ca-4e77-a9a7-50433c001876	69ab7a2f-09af-45a1-ab74-05d8f5568147	1ca0dd36-2589-459a-8fd3-e0632edae4b1	PRINCIPAL	t
cce4ab18-a128-454a-8a15-f232344eb04d	8ac71403-7486-4395-9738-77e16e4c2d69	1ca0dd36-2589-459a-8fd3-e0632edae4b1	PRINCIPAL	t
9c0c6739-9699-49fc-bad1-41733bddf692	c6646091-0038-448f-9c53-a5c7c2515f3c	1ca0dd36-2589-459a-8fd3-e0632edae4b1	PRINCIPAL	t
445cfa86-5873-4e31-af90-2a6f04f05621	d6364bc5-066e-4efc-8226-2f49c1f097e1	1ca0dd36-2589-459a-8fd3-e0632edae4b1	PRINCIPAL	t
ddb396f2-dcc7-4bb0-95e5-c5282c046999	c1cb574a-76a3-40ac-ab30-d240e3b63eb4	c7824abb-e0e6-4c6e-b448-066c30d550ff	PRINCIPAL	t
410c47a3-b114-432e-a256-f8161db4ae27	6fede855-fe75-483c-a12d-c80b0a5ee591	c7824abb-e0e6-4c6e-b448-066c30d550ff	PRINCIPAL	t
ffd3c3cd-03d7-45ed-afa6-35bd62d54c09	e4f3584a-74c9-4ab1-8395-7b3b94a7e3c4	c7824abb-e0e6-4c6e-b448-066c30d550ff	PRINCIPAL	t
17367adc-e40b-480f-83f6-e01b4c374f95	7fe2b55b-5a8f-4043-a8bf-f7056d0ee711	bfb93ee4-854e-446e-bea9-ef9512671d4a	PRINCIPAL	t
66feb749-7b9d-4bd2-b031-2526f8a9e9db	80e68f08-7cf0-42f4-a2ed-ccb63ea7390a	a2e57f9b-0a17-4bef-89bf-703b5505dc4d	PRINCIPAL	t
2861fc6f-9755-4d5c-aa81-7454e317b4bd	946a3275-86c3-4cbd-8ef6-f932ca4fd5cd	82eec08c-333b-4fd0-86ad-b2bee3277fc4	PRINCIPAL	t
b6ec01e1-1e34-49e6-8248-986058de6567	36818afa-02b9-4d2c-be12-6f4c95ed6354	fc382ff6-1ed2-49e5-988a-90c09b49dadb	PRINCIPAL	t
205cae0b-885a-42b4-931b-bd1c2be174a9	c2bf97f3-2c15-454a-b997-2d935c4dba40	dec6f04a-0a75-43a8-89c9-dde5780e0384	PRINCIPAL	t
9ec525dc-4b5b-4032-b62d-5dcbb95f65da	a93fad9b-eeca-47ce-acd3-ff4ee356604b	99f20cc1-6646-47a5-a8ab-db8e1d1b5a4c	PRINCIPAL	t
e3eaa4f7-ba19-490a-8b76-f8e249ca87f1	932d07d4-556c-47c3-8a02-3c8df16b29ab	015409b2-59f2-404e-858b-1af9c9c1f5ba	PRINCIPAL	t
6c88dc0a-507e-46f5-abf7-1ad1f73decc1	0a9e657e-8e9c-4a59-99cd-45d3c5295712	05943df7-12f7-4f5b-b4bd-8362394e6fd5	PRINCIPAL	t
59ce2764-a327-431c-8426-13cdccd10411	8e57b32a-c36b-4b1b-84cb-82fbfb27f63d	1ba0799f-4e1a-424f-b667-5decbc9699d8	PRINCIPAL	t
5d2ff3cf-bef8-4570-a446-a3d5759d9272	215ffac3-c064-4a4b-900a-7902020ea961	66e0eede-1fbd-4831-85f0-a7bea79c34d3	PRINCIPAL	t
a23acdfc-f60c-430c-972d-13f124aa6a0d	7526e0fe-e1f5-4294-8ede-512edd43cb6c	c0961ab2-ceae-4c27-a9d5-4f54ac510076	PRINCIPAL	t
380ea881-4a09-4bfb-9d4f-c18ee1a0e916	bfc8cbed-742a-4de4-89e7-fa64dc4a5423	23ea449a-5717-4c85-a0c7-0af76c1d342f	PRINCIPAL	t
0d1180b5-c300-403a-aed2-567aecc84c8e	8a99b682-803d-411f-9fbf-091a37645009	1cfdc183-5136-4923-ac14-01dda4d47a51	PRINCIPAL	t
e21a31f7-3780-4d52-9024-e5047db64086	f1acbc39-e5da-423a-bcbd-ff85e7d759c0	bf21c0ee-9b33-4fac-83f0-694133cfd351	PRINCIPAL	t
4f0bafc9-1e32-4838-b398-47744e8374c3	5d2ba9a1-9a50-4e01-9cc9-1d00568fbdcb	ea3e3865-272a-4512-b0fa-028a4ef708dd	PRINCIPAL	t
21255bcd-e0ec-4675-8535-d90f1d6e7c34	5bc313fc-4694-4129-a80c-5677e1e4c9da	366c1b74-afac-4cb3-99bc-4b7114bff512	PRINCIPAL	t
666e07e1-eeea-4c02-a448-a5d125c11a94	1f7b3db7-0201-4a5f-8022-e2aecc2c6c7e	82eec08c-333b-4fd0-86ad-b2bee3277fc4	PRINCIPAL	t
a8232301-c14b-4455-96f9-6e8a64e68c16	9ee56e33-4f8d-4311-b928-f68efa7d725e	fb0a5517-f4fc-4afa-bf8c-dc939430b6a2	PRINCIPAL	t
e7cdd46c-9736-42eb-bf70-95ed487508e3	60e0da40-c89c-4988-83d7-9c8fa15e6149	2317749a-d197-4873-a9fc-ac7e1ac81feb	PRINCIPAL	t
11e4ee17-0799-488f-b73d-95668404d80b	8d5493a7-d8d0-4e96-80c2-2d0f8366c639	c7824abb-e0e6-4c6e-b448-066c30d550ff	PRINCIPAL	t
6cd39d15-884e-4d16-b1be-750b582cd36e	ec9f89bc-ce38-45cd-9a29-1c1dc78874a2	c7824abb-e0e6-4c6e-b448-066c30d550ff	PRINCIPAL	t
013edf02-ad2f-4afb-83c0-1a051f53439f	0e4e8d7e-8072-4ec0-8811-a7a525b4aef3	c7824abb-e0e6-4c6e-b448-066c30d550ff	PRINCIPAL	t
ff986f80-a07f-48dc-95e8-87f2169da835	724ce821-a902-4c09-ab66-47b6642c9ae9	c7824abb-e0e6-4c6e-b448-066c30d550ff	PRINCIPAL	t
d7b35984-fdfd-4cc3-90cb-492b5fed49ec	1bc02515-5ce3-4898-a4fe-93212f395fdc	c7824abb-e0e6-4c6e-b448-066c30d550ff	PRINCIPAL	t
854b3dc8-3cf8-4c2a-9542-7e1f6ccf0784	247e110e-30a4-4d89-9f41-03038cb508e2	c7824abb-e0e6-4c6e-b448-066c30d550ff	PRINCIPAL	t
28086da9-f387-4634-871e-ae0c914f73d2	1843f4ac-d448-4e22-97fb-bbf6d783a45e	501379b1-853c-401d-8409-bc4b31b95b4d	PRINCIPAL	t
84664f70-1fd6-44f7-a2a3-0bf1458953e3	07e247fc-647c-48e3-829c-30794ff48acb	bb98934e-9e10-4baf-b1da-102b64cd898c	PRINCIPAL	t
ed0b28e4-0a2e-4b90-8480-dda5fd8ca3af	b681bb0f-f5ea-47e4-851e-afeb25f6a532	f5ee5150-4ca5-4268-ba0c-8fb04fd70162	PRINCIPAL	t
c0f4ee8c-32b2-4caf-843b-d052473ce2fe	49b329a4-12c2-41f2-bbd1-1cdcecd752ac	f5ee5150-4ca5-4268-ba0c-8fb04fd70162	PRINCIPAL	t
570a0f70-0667-407f-88c8-85eb8f77270a	4a97f7df-9148-4ab3-86e2-2e73ff369abf	f5ee5150-4ca5-4268-ba0c-8fb04fd70162	PRINCIPAL	t
5c18ab30-810b-41df-b814-c703116616ea	f49bb02c-2313-4f6d-a99e-63d145e48fbe	b288e78b-597d-4077-8eed-4a751481a764	PRINCIPAL	t
f5ebba6a-cff1-40aa-a674-631696088a76	5c3d9b14-4172-42f4-8ead-6393d4e6f442	1ba0799f-4e1a-424f-b667-5decbc9699d8	PRINCIPAL	t
c940564b-f8af-487d-9586-8eb73a6563df	28903d17-6828-482c-8e65-e83cb39c2db6	2e5ec06b-e15b-4696-b541-5ae0c626b2c7	PRINCIPAL	t
f21b3392-e1e7-40db-ba34-b845f409c4f1	fe3ce1a0-4ff5-4d83-8300-b37e7e30f459	bfb93ee4-854e-446e-bea9-ef9512671d4a	PRINCIPAL	t
82ea66ea-06cf-49d7-b0e0-5e004976d85a	d58fe0ba-40a0-4f7b-809f-f74046adf49f	c281fbc5-de0a-4b8c-b5f9-20c2564c9ef1	PRINCIPAL	t
d05a6b13-1511-4388-9d68-c86c75c3a1e7	8765f393-dd01-43d0-9f1c-0e6da47317e3	c281fbc5-de0a-4b8c-b5f9-20c2564c9ef1	PRINCIPAL	t
353026b5-fb1f-4352-b2c1-67e722b93f32	761a3b85-3a0c-49bf-9cc7-8f582edca42b	c281fbc5-de0a-4b8c-b5f9-20c2564c9ef1	PRINCIPAL	t
ba37d014-ced0-4027-a63f-f7a2040cab3e	6e84f9f4-59b7-4dc0-bd4e-021d9b8063f1	c281fbc5-de0a-4b8c-b5f9-20c2564c9ef1	PRINCIPAL	t
2fa996db-2ac6-4d7d-81b3-ab0df3422b7c	d0dc7ca9-93b2-4ef1-b759-b4966fd78d5c	565abd74-0cfb-42ea-81bd-ae487fed298c	PRINCIPAL	t
7117ad54-c5bb-4528-a099-0461963f61e3	68d16300-c6aa-4d02-84de-108f26540adf	015409b2-59f2-404e-858b-1af9c9c1f5ba	PRINCIPAL	t
dfc76efc-63fa-4fb6-b912-c86c266be8f7	2f758927-26a5-4a96-a8cc-3cb90ccafad9	015409b2-59f2-404e-858b-1af9c9c1f5ba	PRINCIPAL	t
67c278a1-afb4-4b18-89a5-674df13732f1	b7f1ab3c-3def-4a82-872b-f898ad6dd121	015409b2-59f2-404e-858b-1af9c9c1f5ba	PRINCIPAL	t
96bb7ff4-071f-4866-8093-19e5912a520a	1329e3ab-ecc2-4066-8063-c9be23022f58	015409b2-59f2-404e-858b-1af9c9c1f5ba	PRINCIPAL	t
c650d6af-77f0-4334-b022-f89fbdb0af7b	3ff7f386-67f4-458a-9196-efb3ca6a9ad1	62c16919-f33c-49d1-b3ad-24fe015c7264	PRINCIPAL	t
e196e855-83e5-4484-ac08-41b441005331	7bc7d598-b722-45cd-b0fa-c98529f65230	62c16919-f33c-49d1-b3ad-24fe015c7264	PRINCIPAL	t
1ee42935-7539-4092-a1ed-c1dded8da9d6	d2426890-99ab-4750-afbf-cf0e9ae2b1b0	67dd05bf-c7d9-46c9-8ecb-4acd56e08b2c	PRINCIPAL	t
cfdd98f3-803b-4d41-ac34-0c9aecd6cb44	637d7472-22f1-45c1-9e54-0f774b794200	fc382ff6-1ed2-49e5-988a-90c09b49dadb	PRINCIPAL	t
05538677-504a-45ee-9483-46a10438b569	87baa544-d81c-4886-9f1b-efed680e9f9c	82eec08c-333b-4fd0-86ad-b2bee3277fc4	PRINCIPAL	t
2c25aa96-777a-4c72-a3e1-f492aeb5816a	7deec07a-3cc3-460e-93a2-595edd67b49e	67dd05bf-c7d9-46c9-8ecb-4acd56e08b2c	PRINCIPAL	t
6b8d1706-48ac-4f2d-9c5c-3b1fc271243a	ce68d951-3ae8-42a3-884e-6c82c4d63f61	7095db62-e46b-4622-831e-828b9da3a996	PRINCIPAL	t
32570bf0-eb34-4aa2-b7a2-c97a94847967	ddc62804-8db7-46ff-a03e-214e90f23b7e	1f99bf1c-77dc-444e-aec0-400a44b876c9	PRINCIPAL	t
f70b006b-e234-4ab4-b6ec-a3a010a6ab0a	fede7ce3-0f86-4fa9-97ba-623c24da8746	b288e78b-597d-4077-8eed-4a751481a764	PRINCIPAL	t
68aae711-1f77-41e8-8995-395877d0f183	8d7ade9c-723e-4613-bbb8-7ddbb280506d	09a06c54-6c63-45ea-8713-05c23ea758a3	PRINCIPAL	t
61b8068a-e321-411b-aaa8-842d66dfdabc	dd2010eb-1a21-4fd1-8c6d-d87a721aeb34	66e0eede-1fbd-4831-85f0-a7bea79c34d3	PRINCIPAL	t
961bb65d-5347-456e-a987-563aefc10bb3	24c1f9d4-e59f-4a4b-921b-286f93c72a81	d09f06f0-ca9f-4e1e-ac28-492759e65ca8	PRINCIPAL	t
4f920354-a05c-40f4-b915-d5f80a3c4779	f83d6075-c947-4d0f-8596-c1c30f963616	1ca0dd36-2589-459a-8fd3-e0632edae4b1	PRINCIPAL	t
ee4c48d5-fb40-468d-b06f-20ea9a0ab121	0f0dc4ea-5a5e-4dce-8aa0-fb3887849e97	c0e52411-4b93-4d3e-a297-acb8a956a0b4	PRINCIPAL	t
b9b791d9-0d5c-487e-8102-ccaac6f50ebe	677e13c3-1256-465e-b3b6-3a6b5c2e7322	c0961ab2-ceae-4c27-a9d5-4f54ac510076	PRINCIPAL	t
af88b21a-65ee-4f99-b95c-1df6f206d951	28d74b4a-03e3-47b4-9fa3-6a88605f3004	5ac39e92-b193-4205-ba9a-46a7a1a9006f	PRINCIPAL	t
cc751aec-8860-450e-b736-8256254d4abe	024b54b1-01f6-4078-92e4-9ebafa5923d4	8a55a477-86d9-44bd-92c7-2bab0e53430c	PRINCIPAL	t
6ee2e5a4-0845-41a5-989d-39d508779b3a	640198be-3c48-4260-9c31-3c8bc72000e9	4bcff687-53d5-4cf3-9c49-1950efcad1ed	PRINCIPAL	t
9e96d90c-c512-441e-bea8-b7e8ccaa14dc	7ad597c1-093b-467e-a9c8-de9b3ee941c7	a5f98d6a-7b96-47bf-8f14-6659507e408c	PRINCIPAL	t
95a46ef3-1361-44e6-af11-b585817a5f1e	06beeea6-5625-4ac1-93f9-3734a871f6d2	366c1b74-afac-4cb3-99bc-4b7114bff512	PRINCIPAL	t
a9d0728b-e750-435b-9ba4-d6db7594b79f	56026e02-fb1c-4a8f-af36-614a94627bb5	1f99bf1c-77dc-444e-aec0-400a44b876c9	PRINCIPAL	t
a1f35e56-4809-4a5a-ab9b-56b60f3c8fb6	0c23ceac-81e3-41ba-9c1c-c9a56fa4588b	05943df7-12f7-4f5b-b4bd-8362394e6fd5	PRINCIPAL	t
3576d2ae-c110-4c53-b313-f045948a7401	d4c2662f-fa22-40e7-9500-a25132168dd2	adaba0e9-98b1-45fb-a831-ca41d5a9a6da	PRINCIPAL	t
\.


--
-- Data for Name: mareas_movimientos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mareas_movimientos (id, id_marea, fecha_hora, id_usuario, tipo_evento, id_estado_desde, id_estado_hasta, cantidad_muestras_otolitos, detalle) FROM stdin;
824efb14-fe3a-4239-8554-66c09cc0e469	bb26bbcb-ee6d-4370-9c16-84f03d8d362b	2026-01-08 20:01:57.629+00	8951226f-00a0-4e79-8772-9c915882cd52	CAMBIO_ESTADO	69b9484e-11e9-459f-9f5a-dcdbeba2111b	6aa3e1af-c033-4aab-a945-e1d1736f9348	\N	Fin Marea. Obs: 18/1/2025. Etapas: 1
ecdf0a70-be28-43f4-a276-8f507b367960	bb26bbcb-ee6d-4370-9c16-84f03d8d362b	2026-01-10 01:34:12.823+00	8951226f-00a0-4e79-8772-9c915882cd52	RECLAMO_ENVIADO	\N	\N	\N	Reclamo de documentación enviado a juancoppa@hotmail.com
637aa89e-5590-43bf-a791-db58fdfbfa86	04a1cdbe-7149-4e8d-977c-44f6d2f4a7e8	2026-01-08 20:02:42.972+00	8951226f-00a0-4e79-8772-9c915882cd52	CAMBIO_ESTADO	6aa3e1af-c033-4aab-a945-e1d1736f9348	1e03e6f5-cb29-44d9-a0f6-2972094864a5	\N	Acción: Recibir Archivos
971a1500-8c77-4dcd-8dc6-abb749657336	75a873cf-209e-4153-9151-bf4bb2d1458a	2026-01-08 22:30:19.052+00	8951226f-00a0-4e79-8772-9c915882cd52	CAMBIO_ESTADO	6aa3e1af-c033-4aab-a945-e1d1736f9348	1e03e6f5-cb29-44d9-a0f6-2972094864a5	\N	Acción: Recibir Archivos
18316a66-212d-45a7-b06c-0fe6f76ec4b0	9076d345-9540-4afd-adb6-23d9fb452797	2026-01-05 21:09:51.983+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
bc9e9cd1-6785-43dd-b27c-f631670543a8	b27d3a0e-7338-439e-9acc-3cdec348b830	2026-01-05 21:09:52.003+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
4f0dbe2b-c224-4ab6-8f44-110276562bed	f9d47889-b2a5-45d9-b918-3e8ca33ae8de	2026-01-05 21:09:52.015+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
54f53c46-00a9-4ddf-b7df-69f73ba300bf	0e1101d5-a8a5-4fc6-bd6c-8e6d5bf5a187	2026-01-05 21:09:52.025+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
5f3587b5-3859-47b0-9a08-5b73ecb8a2cb	90479d64-7113-423c-89f4-13a0bfbf9975	2026-01-05 21:09:52.034+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
3d249311-e1ac-440e-8b1e-3f263f9d440c	a686b746-2f99-45f9-9b48-9e858b4863f2	2026-01-05 21:09:52.043+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
d65f06ed-8cef-475e-8489-628b7dff49be	2dfe6d99-7c81-4b76-a87d-5a23757b0349	2026-01-05 21:09:52.05+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
803dd29d-e96c-47a6-8a1e-c062af2d1c93	4f0eaeb5-1488-43fc-8e7b-6f7bad09c614	2026-01-05 21:09:52.058+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
41294f67-9a3c-46b5-adaa-79214c6305b9	efce3e7d-3fc3-46fb-a508-be8cc580ad53	2026-01-05 21:09:52.071+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
85d7663a-32fc-441e-8060-cf9252244393	694ed401-8843-4363-9266-8d1011a20a59	2026-01-05 21:09:52.079+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
7d339a97-f394-4447-8ea1-470fca802428	66c81c16-f6c2-4d97-bcf7-42ce652ccdb9	2026-01-05 21:09:52.088+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
1fcd01d8-ced7-45bc-99b5-1c5ef9d24286	200384e0-1776-4b38-be51-fee06de25c14	2026-01-05 21:09:52.095+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
f74744d8-f70f-4809-9a3d-9221d8843e94	07ce19a1-da51-4871-8185-c1e809a5efcb	2026-01-05 21:09:52.103+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
6ff1a5ce-b870-4dee-a424-72e1b517ca64	5b1347dd-d6f2-4250-94b2-726ef6000f4d	2026-01-05 21:09:52.113+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
0ef83834-8093-4c89-8dc1-51846672e054	f1d03daf-0f1d-478e-ba2f-58bcd4251ec1	2026-01-05 21:09:52.12+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
3e025767-fee0-4001-ad61-257bd2a57974	d2639d24-4795-4baa-b356-7fa928ecf78b	2026-01-05 21:09:52.134+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
2dc872ba-aafb-445b-b4d5-c3c86a2998be	482360a2-d80f-4f65-a829-c3c9dee01c6d	2026-01-05 21:09:52.142+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
923626ab-c29e-40a7-b19f-b6125d5d1358	2ab0f251-d267-40eb-9f3c-b02f62a1cd45	2026-01-05 21:09:52.151+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
50519357-92cb-4de0-bfe5-86f8de52f96c	0fbd898d-e869-4369-9692-98d41b56b242	2026-01-05 21:09:52.159+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
1a07c442-27e6-4a5c-9d11-4cb03d90dc50	9fadd20b-03d6-458b-9b34-96e3f19b3c18	2026-01-05 21:09:52.168+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
12dc6f65-dfcc-415d-ad0a-3c5aa5179b32	cda9eb74-e671-48d8-8c0b-3370d4b54256	2026-01-05 21:09:52.176+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
3ac01ebd-5fb3-4b78-880e-b3a3b42ac3df	51896655-508e-4ea2-b53c-9d6c60f3f122	2026-01-05 21:09:52.185+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
c62a15dd-ca35-4db8-8155-f266c43e1e06	621c1b94-90a8-4a2c-881a-7c21284b67be	2026-01-05 21:09:52.192+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
25db4034-7f3e-43ca-a405-f083bfe1caca	68a13a46-9ce3-453a-a776-3436ebee98c2	2026-01-05 21:09:52.202+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
90bbe1d9-d1d0-417f-bf4a-7f0d8d496ad5	8a562259-5c22-4bef-9d62-27e407cbc1a8	2026-01-05 21:09:52.208+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
07a95709-78a7-4b23-9569-99feeea5d03f	a95eb4f4-2c21-4d2e-a29c-7fbddbca7378	2026-01-05 21:09:52.216+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
db0b65be-c357-4ab0-9ca1-a5d4b20d7037	f66f54eb-303b-4ad5-95bd-9ef55e4e16dd	2026-01-05 21:09:52.223+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
a0b8bd28-38d7-48a3-a1b9-e4fbc3a885f7	48fe5394-4b5c-49c1-9d44-0f9d2b21b53a	2026-01-05 21:09:52.231+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
6691edaa-6d00-449d-b4ca-ae327739e06c	2256c2ba-7ef9-45a0-a5c7-9afa6cef49ac	2026-01-05 21:09:52.238+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
d64ff191-a24f-4baa-92b8-89aec789056d	69cbcc71-43c4-4429-90bd-e675a46e9872	2026-01-05 21:09:52.245+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
53fda507-23e8-4066-98de-6d0c2c92025e	592db42c-4135-40d1-b7a3-2a0dc4299636	2026-01-05 21:09:52.252+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
535d4ea7-f831-46cc-93a3-7c69320ea827	a12d12d9-f4f7-4e74-9fab-bc1dc17d0688	2026-01-05 21:09:52.259+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
82bebd86-de28-47c6-8025-e7dbaae78688	1fdfc3d9-544b-48cf-a621-dd68244f9369	2026-01-05 21:09:52.266+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
fcdb8fce-4c34-4e90-80b0-ff19018c1b13	47f761ef-c91e-45fb-93d5-1f98eb26cd38	2026-01-05 21:09:52.275+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
cfee80dd-3930-4c32-86ea-3e9e1f97be30	f9765ab5-8ee7-416c-b7c1-d0d1846a4327	2026-01-05 21:09:52.282+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
a66395ce-c0cd-4de4-9eb9-7c896de93d08	dea85480-9c24-454f-b6fa-4c78332dcce3	2026-01-05 21:09:52.289+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
70a7dc1d-0841-438d-ab72-001e70bba834	02435e7d-a5b8-4b8e-809b-dfd97b7df3d1	2026-01-05 21:09:52.297+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
b9cb88ad-3205-4d68-b1dc-2a543fc683cd	0e0d382a-b7eb-4d4f-8eae-fecf123e836e	2026-01-05 21:09:52.303+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
b23a0aa9-3a5d-4aa1-953a-f80a77f17bdf	5cb83b2e-d1d3-4e14-bdb4-1031857eaecd	2026-01-05 21:09:52.31+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	e1466c46-8d9b-4f0d-8903-c543a05b8510	\N	Marea importada de seguimiento 2025 (JSONL)
6566d5ea-b205-4ab2-8a14-69b814bf55db	a7bdea43-545d-4d0a-96ce-62cbc6f3567c	2026-01-05 21:09:52.316+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
05280791-987d-4375-b744-43c40135bf89	f4f7a0f7-87a0-426a-8a6a-e621a6dfb4e8	2026-01-05 21:09:52.323+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
cf000a8a-3edb-4941-941c-cfe15ed609fe	9abc8a68-2563-4aae-9ead-77e56a59de1f	2026-01-05 21:09:52.33+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
31e91eb0-aef2-48ab-ac9d-f3a576e8c357	11d340ae-2948-4d28-ae9d-12a32a5c90a9	2026-01-05 21:09:52.339+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
11a0fea7-50ea-4379-9d08-b72a3998acdc	0b53fe15-746b-4833-89ec-01eb6cd2f234	2026-01-05 21:09:52.348+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
b7664025-93b9-40f9-a091-bbda0d961e16	311d40b1-64bc-4e65-bd15-7aeb87b45bc4	2026-01-05 21:09:52.357+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
37b49828-6d1b-45ed-adfb-0393f3b60646	b6c44045-e74b-4c6d-aadb-8e351e3f5272	2026-01-05 21:09:52.367+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
e8bbd574-02eb-4ebe-b8e7-6798921298d1	881b3e5f-1e70-442e-a979-2227a0af91f8	2026-01-05 21:09:52.377+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
94166158-db56-48e1-8b61-f5565be02f48	c426739a-2bbd-4bd7-8b15-4cd170e58f50	2026-01-05 21:09:52.385+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
db2f3e51-24c7-4ad9-95c7-dfcbe199f1e0	9846b525-caeb-423f-ba64-c9e24e8ec6f4	2026-01-05 21:09:52.392+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
e350c15f-dff3-41c5-929f-853abeaa798d	ed3251db-d14e-4c8b-8416-25094bb4b2ca	2026-01-05 21:09:52.399+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
2903f192-ad86-4485-9333-ebe232eee4b5	8278705c-0edf-401c-b780-b91d0d623f7d	2026-01-05 21:09:52.405+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
2b053485-8902-4b00-9653-cababe166b66	4095549b-0d2a-46c9-98e7-c1bba0941de0	2026-01-05 21:09:52.411+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
43f5da7d-1214-4c48-91d2-10baf1dbe726	9995c117-f9ec-4a2d-9175-ba610601fcb0	2026-01-05 21:09:52.423+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
d6d85801-e47b-46c1-b059-fa35ad6f5f52	9ca69fde-117e-4717-818a-546b49669e42	2026-01-05 21:09:52.431+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
6afbf098-5d3f-444f-b905-e4ed1b9f12fb	1da59a5f-db27-4cdc-838d-77ee8b345ff7	2026-01-05 21:09:52.441+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
e6492da3-cb98-484f-b410-02a013b0c7e8	338f1e94-bca1-47ce-b9be-daa77185cf2e	2026-01-05 21:09:52.45+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
3f56165d-76af-4983-a906-d7453368818a	abdbef76-9b46-4e8f-92ee-6b9020caaa8d	2026-01-05 21:09:52.458+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
6a2be5a3-1561-4181-9e23-c3c01f7d66d2	f0468bbd-b484-41df-b78c-88aaab94250a	2026-01-05 21:09:52.465+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
1157556f-afb0-4bc7-961e-56d8d80b453a	32617a9e-1648-4056-afb8-bfc5030276e5	2026-01-05 21:09:52.472+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
35dda534-29fe-40da-bc1b-01108f352e03	ca6ad44a-8156-4059-81a0-0226336aa2df	2026-01-05 21:09:52.479+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
39701203-6844-4437-81e3-341f081a0f57	7c602a8d-a15d-4840-bca0-53fb57a13d81	2026-01-05 21:09:52.488+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
7491cc5c-5dbb-4ea9-ada0-5f9a667727df	f8aad6fc-bca6-4048-96ae-02a913dfba6d	2026-01-05 21:09:52.496+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
34311955-4ce7-411d-bbc6-6edebd180f4f	de0e9cf6-f31f-48a1-ac4c-e765f1dd10df	2026-01-05 21:09:52.503+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
8a4b6b74-3d75-402a-8af7-3f6bb2436d9f	6820501e-2199-40d1-9f42-321c4f0b11db	2026-01-05 21:09:52.522+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
a77e983b-4b69-4dc6-a786-06787d81b290	31532d29-63f4-4dab-82f3-06cd195379b7	2026-01-05 21:09:52.53+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
65c6e88f-e4a9-42df-95e8-31d3baafd3a9	0e52329d-2d4e-497e-8fa5-f53dbe6a6a58	2026-01-05 21:09:52.541+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
3a6ea5f9-a022-4181-86d4-13bf82aa44b1	0e7d01e2-b826-4db7-be3b-71ac7fb56c7d	2026-01-05 21:09:52.551+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
dcf044a9-b582-4371-b45b-d40eb43ec01e	f8f01a70-128b-41d6-a8c4-7114b79dfd24	2026-01-05 21:09:52.558+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
bd740f0a-8381-4d13-8854-60d32073b188	36efc308-b34e-4c6c-853d-9bf75f7b6da6	2026-01-05 21:09:52.569+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
6b042045-c08c-4c47-976f-7e25f1db8784	877af272-2260-4f9a-bdb8-553ea0b056ed	2026-01-05 21:09:52.576+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
35665383-a0ab-4e4c-9084-1b36b6dbfa2a	0268cb0f-3f5d-42c4-9404-8a96f016b381	2026-01-05 21:09:52.586+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
efd889a3-f2d5-48c2-8dac-4115c7681d20	ff5b01b1-e5f0-4f85-b962-2e486b741944	2026-01-05 21:09:52.594+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
56a1c047-0219-499d-b330-60125faf4349	4d6b0412-6cbf-40d4-a103-a9a2b7e9ceb9	2026-01-05 21:09:52.601+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
8f2df568-8175-48a2-821a-05b2d85803e5	4e1ca30c-b9ad-4e70-ac7b-373d4e469cce	2026-01-05 21:09:52.612+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
1981cfa0-b64c-4497-916c-d6f4a57e1ee6	b256d88d-3846-49be-a520-d2714953f2b9	2026-01-05 21:09:52.62+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
465e4a97-2a20-4dcf-a82f-4679ffb7cf74	8ac92a84-1849-4a60-976b-d1b84e421031	2026-01-05 21:09:52.629+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
a5e61494-3465-4990-badf-e68829ca7849	7f9d1709-bef6-4c9d-a884-0dea2639d1a9	2026-01-05 21:09:52.635+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
2c7d9fce-76b6-4971-90be-dbce50133e77	f161f9ea-d8a7-4ac6-8071-5a9c2ebca5e6	2026-01-05 21:09:52.643+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
2c7c5979-bc8b-4e50-8bb3-2d61704f670d	3d155205-90bb-4e22-9208-bf9917a5c0bf	2026-01-05 21:09:52.65+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
dcff2a57-25be-45a9-8d97-4f13479ac1ed	055f85ae-4413-43bd-a039-5e997c351649	2026-01-05 21:09:52.656+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
f1913049-43b6-43a3-94ad-623ca6b8d26f	49534099-b63a-4a6b-ac69-c0471f345506	2026-01-05 21:09:52.664+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
4c3ecaf9-b229-4fd5-bbd6-8b856fb0f71b	2433bfa1-7760-4361-8977-933f577f865a	2026-01-05 21:09:52.67+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
720ef145-81a6-4556-8ecc-02bd987fccc3	ea92f9f1-c762-40ce-8a2c-33f521b51714	2026-01-05 21:09:52.676+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
67ef7011-88bc-46b3-a879-2930a62b760a	c7b47701-b71e-4ee7-8217-09cbe435abd1	2026-01-05 21:09:52.683+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
9e5a581a-0a43-491c-afbb-0a4868695b54	ba7b47a6-4cf1-4f87-b0e0-aeff75dea890	2026-01-05 21:09:52.691+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	e1466c46-8d9b-4f0d-8903-c543a05b8510	\N	Marea importada de seguimiento 2025 (JSONL)
f1eebd17-206a-469c-a2c2-ac3360c10eff	8091e240-4b3e-4ddb-bb28-85a58ba46bf6	2026-01-05 21:09:52.696+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
98529cf2-e765-43db-bf85-c4ae2cdf5a25	beae9edc-38b7-48cb-8301-22fbe202aab3	2026-01-05 21:09:52.702+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
1b843f56-113d-49e0-9e7b-31430b7e07ca	032dfc0b-0119-4cf8-9a01-a152af6ed805	2026-01-05 21:09:52.709+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
69a655d1-ba60-4dc6-86f8-3b224e4b758b	8cbe3d37-ac3d-4be6-b478-9a73af9ac20c	2026-01-05 21:09:52.716+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
d4062fda-4725-4392-9527-3f7113afe100	d60cf987-bbe4-4f03-ba2f-2579d6dba2cc	2026-01-05 21:09:52.723+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
0c847a54-525e-48f2-9f3f-ceb0d2031c45	790db629-d119-4f12-80cf-2d922a82c2e2	2026-01-05 21:09:52.732+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
d2fc0510-2957-4b74-94a5-b2222351e38e	596845b7-68fe-47c3-aeb8-98261c99c0d9	2026-01-05 21:09:52.741+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	e1466c46-8d9b-4f0d-8903-c543a05b8510	\N	Marea importada de seguimiento 2025 (JSONL)
96a6af69-c420-4993-a26b-3db06524cbc3	675faed9-0007-4ac7-bd8b-3780cc11b128	2026-01-05 21:09:52.746+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	e1466c46-8d9b-4f0d-8903-c543a05b8510	\N	Marea importada de seguimiento 2025 (JSONL)
40b0eb5f-9830-441d-aadb-221ab1717a2a	1ef63927-72f2-4b8f-812f-d2945330473d	2026-01-05 21:09:52.751+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
668cd395-eb54-4016-af9b-a37d0a540d45	fd9da546-bf42-4c98-9cc4-c8b6d317cd6b	2026-01-05 21:09:52.766+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
bac5cc62-a6a0-4a0c-93b5-9c851f95b978	284a1f0e-a7fb-472a-9131-7aa367ac0610	2026-01-05 21:09:52.772+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
46b6166a-d4bd-4e38-9da2-a777fd6dbb32	1ab6c8b1-0c90-4240-9328-92b2c3f0cc2a	2026-01-05 21:09:52.778+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	e1466c46-8d9b-4f0d-8903-c543a05b8510	\N	Marea importada de seguimiento 2025 (JSONL)
24e199d1-2e18-4e21-8a4f-b8771d1d3026	4226bf56-57c0-4560-a178-98ab4df1d172	2026-01-05 21:09:52.782+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
10a7429d-03c1-486f-940d-b37bb1b8859d	93a313f8-ad3c-462a-95b9-c4c19624dac6	2026-01-05 21:09:52.788+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
1399619c-5ad9-420f-911f-07f861026f61	e8ea7d21-16fb-4dc1-b2fd-a932449a6e49	2026-01-05 21:09:52.804+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	e1466c46-8d9b-4f0d-8903-c543a05b8510	\N	Marea importada de seguimiento 2025 (JSONL)
88ff8943-a196-46d2-9907-3cb576ba8d5a	5a97e8e8-40e6-4195-a00a-bf522a3775dc	2026-01-05 21:09:52.809+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
f252e8f7-21a2-40f2-a47e-9251456ef073	924abc07-845d-44d4-9587-a9c4ad38078a	2026-01-05 21:09:52.818+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
871e17fb-1cc4-4e29-a193-889a8c7b9cfb	4f2112d6-a93d-4546-b2cd-9debae9f7d00	2026-01-05 21:09:52.825+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
767e4f24-8977-4fa3-abd4-c2df3acc552f	5769899c-b858-47af-bd34-da72856242d3	2026-01-05 21:09:52.832+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
082f8223-9963-41a1-a9f8-f4844abdc8e7	c3598bb8-fbea-4261-9ee1-a8a88a21b7e6	2026-01-05 21:09:52.839+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
4052b56a-c0ba-462d-87b9-0d5bd4f7c468	77fe6524-661b-45b3-9f20-6f1fc7c96be3	2026-01-05 21:09:52.846+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
b6d5a8c4-3b57-411f-bbcc-dbe337f90cb8	c093282b-2731-449c-85ed-5473d49b37d7	2026-01-05 21:09:52.855+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	e1466c46-8d9b-4f0d-8903-c543a05b8510	\N	Marea importada de seguimiento 2025 (JSONL)
df2df719-7767-45c2-9673-f4b45ae053b9	d5579c39-d747-44a9-9f3b-244ada52f539	2026-01-05 21:09:52.859+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
c53ea868-baa3-494e-a512-bb9efe5640b3	6f431794-9db0-4b41-9afe-13134f7e4ef0	2026-01-05 21:09:52.871+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	e1466c46-8d9b-4f0d-8903-c543a05b8510	\N	Marea importada de seguimiento 2025 (JSONL)
f9f5db2f-e8b0-4f46-b6aa-838727bfcef3	b665acfb-d2f6-4910-b47a-cc7765fb017d	2026-01-05 21:09:52.876+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
2cf86f37-9753-423b-bdc3-27e64fd2ae06	98266e72-77a5-4d91-ba08-2a4c66658cdc	2026-01-05 21:09:52.883+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
3fbe8154-8ab1-43ba-8eae-d99332c6d893	92a3b9e4-161f-47b4-af64-286393ecb159	2026-01-05 21:09:52.894+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
424f7e02-b4d0-4d97-a2b3-a9e75e9ea19a	26718815-8684-4b30-9258-9bb6a63e5379	2026-01-05 21:09:52.901+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
4e9a7cb1-1369-4e7c-95c7-a3d9f8f7fad8	40d45581-09a2-44a6-a87b-647ab77b5bac	2026-01-05 21:09:52.911+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
f7566a1c-7399-49c9-a035-545d1713d95a	975000e6-8d50-41e9-b66b-33e8e5dfa0f5	2026-01-05 21:09:52.918+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	e1466c46-8d9b-4f0d-8903-c543a05b8510	\N	Marea importada de seguimiento 2025 (JSONL)
a4767189-7161-46ca-9efc-61ee390e3161	898f861d-cab2-4b8b-8bef-64a768ebada9	2026-01-05 21:09:52.923+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
2323d3c3-9413-4b1a-bcb4-1b79b96d2b41	63d6cfba-6a7e-4666-8ee3-bff7bb0eb867	2026-01-05 21:09:52.929+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
f329d4ca-6195-4fd8-9534-832b9fa0053a	5db1a29b-1723-4853-ab5b-68e119dfbfb5	2026-01-05 21:09:52.937+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
876b21ab-3462-4003-bb54-f3b20c424b0e	0646f2e6-9ddf-43d1-9348-a4da267a3df6	2026-01-05 21:09:52.943+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
3de62389-abb0-4e0f-9136-c4fe7815c39a	b6b354c8-7bd6-4146-8aa4-6432bc38c35f	2026-01-05 21:09:52.949+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	e1466c46-8d9b-4f0d-8903-c543a05b8510	\N	Marea importada de seguimiento 2025 (JSONL)
a1088fe4-3aaa-4b0e-a24f-f99776c048eb	f0d7ac68-cb3b-42f8-a568-2044b0748289	2026-01-05 21:09:52.954+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
0ed5f64b-a057-42ee-9a75-169eb49ded3d	17dda418-ca0d-4d52-9a1c-d7cc167ff0b0	2026-01-05 21:09:52.97+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
4c4e8308-1452-45c5-8fa4-4fd21c63bdbe	70af6aa7-6448-4204-8804-38f86f0f9b1d	2026-01-05 21:09:52.98+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	e1466c46-8d9b-4f0d-8903-c543a05b8510	\N	Marea importada de seguimiento 2025 (JSONL)
89324f06-0ec9-4c24-bca1-08d94a4e79a4	c6b21f6b-bafd-4d8d-b71f-ece9166b9236	2026-01-05 21:09:52.986+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
d53613bc-827b-4d7b-a20f-c09b1965e47e	1aa026c9-1ee7-488e-9c75-da424e229acc	2026-01-05 21:09:52.993+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	e1466c46-8d9b-4f0d-8903-c543a05b8510	\N	Marea importada de seguimiento 2025 (JSONL)
84b5ea06-5341-4243-a475-1e0a9f5a874f	6d766260-570a-4646-a7ef-4d797b1bd6ae	2026-01-05 21:09:53+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	e1466c46-8d9b-4f0d-8903-c543a05b8510	\N	Marea importada de seguimiento 2025 (JSONL)
e419c13a-f88a-49b2-aa98-88e1be712044	a11c1875-5405-4357-a37a-4551bd404017	2026-01-05 21:09:53.004+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	e1466c46-8d9b-4f0d-8903-c543a05b8510	\N	Marea importada de seguimiento 2025 (JSONL)
2d424287-b0b3-41e4-afe6-b8bce662ede7	514dbd2f-cb9b-4407-baa8-12bcd209a7a7	2026-01-05 21:09:53.008+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
bb5b785d-2392-4309-a5d6-1f45375d5d46	4f9e1e6d-827c-4cb4-9d82-069772c24520	2026-01-05 21:09:53.015+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	69b9484e-11e9-459f-9f5a-dcdbeba2111b	\N	Marea importada de seguimiento 2025 (JSONL)
0377cbf1-ee12-460d-a1bf-325ff9c38816	17b41229-7629-4b9f-b81f-1f1d27e9d741	2026-01-05 21:09:53.023+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	e1466c46-8d9b-4f0d-8903-c543a05b8510	\N	Marea importada de seguimiento 2025 (JSONL)
fb4bd6ac-ba0d-4bd1-8a91-0aadcda10bff	2de4ee7b-f5b3-4cf2-8b9a-2e49ed7da9e1	2026-01-05 21:09:53.027+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	e1466c46-8d9b-4f0d-8903-c543a05b8510	\N	Marea importada de seguimiento 2025 (JSONL)
18c29f8e-72e1-4596-932e-8e45ae4e018b	ef1a04e9-e54f-49d6-8702-d06678d085ef	2026-01-05 21:09:53.032+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
da986daf-11e6-4876-b2aa-2b3734d9ef20	926aed79-e3b5-49e5-9b89-33e53b405d74	2026-01-05 21:09:53.042+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
b5caeae0-e04d-4930-8db2-831261d515a8	3cb66381-ef63-4747-8c8a-a2b417319718	2026-01-05 21:09:53.048+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
8cc38229-451f-423f-a426-7a2914fa49dd	2a8c6c87-02df-480a-8ba4-fd620b2bdc5f	2026-01-05 21:09:53.055+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
3bd2e79d-1a4d-4fff-bdf9-2b0e758adaef	033e9eb9-741b-4231-91e3-648566fccfa2	2026-01-05 21:09:53.066+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
f1a77fb2-8204-4e82-ba6e-23a7ad5957ed	bd6dda78-8b56-4512-8655-bd8854d29cc4	2026-01-05 21:09:53.072+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
d3d06db7-ab2f-4251-b8d2-0c2e25f73f0f	2080b341-36db-4ddf-ba40-3ed8b23725ab	2026-01-05 21:09:53.079+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
cf9c99af-c61a-42c9-87c5-aac498399b61	cc4d7e35-a911-4291-831f-c8558971c222	2026-01-05 21:09:53.089+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
e670b5a0-5c79-4a74-8f29-90c2553e0288	0ea2f5b7-a551-4c6f-819f-cd7261fb412f	2026-01-05 21:09:53.095+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
dc616f21-9701-4a88-aaf2-8bb136a8db30	54d70074-cda9-4622-81a9-f492bf4449e4	2026-01-05 21:09:53.102+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
7404b824-0451-4e1f-94df-014379ae6673	e48d6233-bd59-4203-9656-2b04e946e1d1	2026-01-05 21:09:53.108+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
e7f2c09f-9103-4165-aee9-b58ed689c7d3	96f6965f-87d7-45ae-9db4-ac79baed652a	2026-01-05 21:09:53.12+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
0144d735-9f24-45b2-8799-785a7279e096	cccc809f-2a70-47c1-b8cb-210be07c8546	2026-01-05 21:09:53.127+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
06b601bd-26f2-4b18-9195-e6840cf53524	751b5025-8cc3-4fe5-b137-521974ed17f2	2026-01-05 21:09:53.133+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
56c192cc-fc14-4703-93b7-bc9cc3feb22a	9c7eac54-3810-43a9-8c1f-683babcc51d6	2026-01-05 21:09:53.146+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
afb4a2c1-3310-4d3b-859a-e58aed7bf55e	b9d25ef7-f29a-46a7-9541-8d0a8c4f8854	2026-01-05 21:09:53.156+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
acf0887f-94e0-4f83-873c-2206fbde554a	b32debc4-4a13-41cd-83ef-c9862b6a6e60	2026-01-05 21:09:53.162+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
6285ca2e-68b0-46b5-8553-7ebd12f7dacf	7a76f317-78b7-40ef-8041-9eb2bb27af58	2026-01-05 21:09:53.171+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
252e0e38-fd8c-4d15-9dae-fb26f0ec5397	d4f7dee3-0df8-493f-86bb-2e5e4fb85d6f	2026-01-05 21:09:53.178+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
72ed27cb-0cc3-4de7-88d3-a1fe94d78df1	f1acff9b-9e6f-4337-8b2c-7384cbbaf18c	2026-01-05 21:09:53.185+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	e1466c46-8d9b-4f0d-8903-c543a05b8510	\N	Marea importada de seguimiento 2025 (JSONL)
7a25d25b-d54c-4024-9648-188cf1b229aa	e7ec54ee-b5c6-422d-b83e-497aab03235a	2026-01-05 21:09:53.189+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
e1b9b741-dc30-4b09-828e-80b1fcfd11ce	19e8a2e0-fe06-4eab-b069-836d9cc7e095	2026-01-05 21:09:53.195+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
efb1e195-9e11-439b-9cdb-41cbe666b130	e23a9208-60d1-4ead-92ad-c66c38e025ba	2026-01-05 21:09:53.203+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
44dbfcef-8901-49b7-9b68-5e5c40076dbc	30896d26-473f-4151-95e3-c4a2870a0ab7	2026-01-05 21:09:53.209+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
c6088455-158b-4d14-8908-f23c9317af1a	54238aaf-a916-4d8c-8169-a6cd101b4551	2026-01-05 21:09:53.216+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
bc131a23-c573-4938-90e3-82c2d8b0ecd7	9288691f-28a2-476d-8aeb-2c9404b2e17f	2026-01-05 21:09:53.223+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
5c8289e8-24f5-4dfb-b72f-772b37b7d37c	cb32aa68-18cc-4877-8d21-7679c676d815	2026-01-05 21:09:53.23+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
012672b4-5ed6-472d-8901-d6aa90fd3b58	d3fc2e88-ce02-49b7-ad3c-6cb771fd241e	2026-01-05 21:09:53.236+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	e715ca3a-b1a3-46f9-93dd-bc46231d00b5	\N	Marea importada de seguimiento 2025 (JSONL)
fc7b919e-6bc1-4e11-8966-91cc335d4249	7f0fdc9f-35d9-4f56-be07-34a265d44c65	2026-01-05 21:09:53.243+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	e715ca3a-b1a3-46f9-93dd-bc46231d00b5	\N	Marea importada de seguimiento 2025 (JSONL)
c1006981-0ccb-4f78-8673-5d2dfb92c8cd	75a873cf-209e-4153-9151-bf4bb2d1458a	2026-01-05 21:09:53.249+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	6aa3e1af-c033-4aab-a945-e1d1736f9348	\N	Marea importada de seguimiento 2025 (JSONL)
9dde32fa-21f7-4dfd-899b-ad7503c207c8	20c472b3-fabb-4fb4-aff1-52bf1e7824e2	2026-01-05 21:09:53.256+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	6aa3e1af-c033-4aab-a945-e1d1736f9348	\N	Marea importada de seguimiento 2025 (JSONL)
67dfd420-5bb6-493f-aebd-f4ecfbf4a0f6	c472d04a-981c-440b-9d39-1fe5179a970a	2026-01-05 21:09:53.263+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	e715ca3a-b1a3-46f9-93dd-bc46231d00b5	\N	Marea importada de seguimiento 2025 (JSONL)
68d712ad-6eb6-4bee-83e8-3a009e598953	f135f85b-f314-4211-898d-90a9053374a7	2026-01-05 21:09:53.271+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
3574173e-540f-40bb-bbf6-0e1de7bf6912	a91fc07b-d392-4fa2-b919-d1c99ffb94fc	2026-01-05 21:09:53.279+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	32e710ca-57b4-40e3-b97b-c2c97e3f9a05	\N	Marea importada de seguimiento 2025 (JSONL)
dd762173-5a77-4022-a95b-40db3db0e7d3	35084f5f-291a-4396-8c74-0c9106761c72	2026-01-05 21:09:53.285+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	e715ca3a-b1a3-46f9-93dd-bc46231d00b5	\N	Marea importada de seguimiento 2025 (JSONL)
4f85f4ef-f3ce-4c19-9dd1-08c81522e1e5	e5047731-c818-48ff-a2a0-8ea5fba090e3	2026-01-05 21:09:53.291+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	e715ca3a-b1a3-46f9-93dd-bc46231d00b5	\N	Marea importada de seguimiento 2025 (JSONL)
463f8b5f-54fa-4aa1-86fb-f3fadabe0bad	3d877597-8d10-4ba1-bde2-25c8e8818454	2026-01-05 21:09:53.307+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	e715ca3a-b1a3-46f9-93dd-bc46231d00b5	\N	Marea importada de seguimiento 2025 (JSONL)
b773f761-38fc-4419-9b54-ba5620451a10	5a6bbfa4-a098-4b19-99aa-cc3ffdfbaafb	2026-01-05 21:09:53.313+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	6aa3e1af-c033-4aab-a945-e1d1736f9348	\N	Marea importada de seguimiento 2025 (JSONL)
39141b1a-ad31-4bdc-928d-070d7510f311	93693fac-b9cf-4581-a11b-0a40d643de14	2026-01-05 21:09:53.319+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	e715ca3a-b1a3-46f9-93dd-bc46231d00b5	\N	Marea importada de seguimiento 2025 (JSONL)
2d4c601e-a16a-400b-909a-c205a7a12a46	29b952e7-e297-4266-9291-8620c4ac7f07	2026-01-05 21:09:53.329+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	6aa3e1af-c033-4aab-a945-e1d1736f9348	\N	Marea importada de seguimiento 2025 (JSONL)
8f345cdf-bd6a-4d8d-a867-5ebaec865322	132a2d01-f41a-4723-9e46-50e97f71f404	2026-01-05 21:09:53.336+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	e715ca3a-b1a3-46f9-93dd-bc46231d00b5	\N	Marea importada de seguimiento 2025 (JSONL)
2824eee7-b972-4bc8-900e-f6d2ff5933ff	3ff96bdc-e6e2-4e15-9a5f-400a00142602	2026-01-05 21:09:53.342+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	e715ca3a-b1a3-46f9-93dd-bc46231d00b5	\N	Marea importada de seguimiento 2025 (JSONL)
badf8689-4185-4ff6-bba5-efceb9be2084	aec58204-f489-4d6f-a981-3b42ca4a341b	2026-01-05 21:09:53.348+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	6aa3e1af-c033-4aab-a945-e1d1736f9348	\N	Marea importada de seguimiento 2025 (JSONL)
e32c9cd9-1423-4887-8903-f41a9526d256	424cd44c-1238-4a44-8b91-f642c33169e4	2026-01-05 21:09:53.354+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	6aa3e1af-c033-4aab-a945-e1d1736f9348	\N	Marea importada de seguimiento 2025 (JSONL)
a141fb6d-874e-4bfe-8ccc-e0ba661d737a	03f39242-83f3-4606-9af8-bb52b2e5691a	2026-01-05 21:09:53.366+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	e715ca3a-b1a3-46f9-93dd-bc46231d00b5	\N	Marea importada de seguimiento 2025 (JSONL)
47460ca7-6ceb-40b4-88f8-001db6cfc98e	16769449-70e9-4830-91df-fdb05cfda24f	2026-01-05 21:09:53.373+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	6aa3e1af-c033-4aab-a945-e1d1736f9348	\N	Marea importada de seguimiento 2025 (JSONL)
41170adb-81d5-466a-8def-bf20c0ff1ab0	d5596483-4141-4dbe-b48b-89012e691760	2026-01-05 21:09:53.386+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	6aa3e1af-c033-4aab-a945-e1d1736f9348	\N	Marea importada de seguimiento 2025 (JSONL)
892ed4ef-db1d-4464-b454-04a88ac517df	fd8f8843-0481-47d7-825a-1a8f99650ab0	2026-01-05 21:09:53.395+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	e715ca3a-b1a3-46f9-93dd-bc46231d00b5	\N	Marea importada de seguimiento 2025 (JSONL)
d2dc4877-bf68-4587-9922-e8e938ae0374	361d3933-1f72-4b73-9a61-b6e0f59c8765	2026-01-05 21:09:53.402+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	6aa3e1af-c033-4aab-a945-e1d1736f9348	\N	Marea importada de seguimiento 2025 (JSONL)
d0a70a81-6d3c-4a15-b9f8-dd66c89eb40d	8e16409e-972b-48dd-9ed5-e9c74a66d9f5	2026-01-05 21:09:53.41+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	6aa3e1af-c033-4aab-a945-e1d1736f9348	\N	Marea importada de seguimiento 2025 (JSONL)
bbc32282-f7e9-40f7-bd36-ded489b35ce6	443ec94f-0465-46b4-a4ec-4d9a1c012736	2026-01-05 21:09:53.417+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	69b9484e-11e9-459f-9f5a-dcdbeba2111b	\N	Marea importada de seguimiento 2025 (JSONL)
e08fbdc1-41bd-48b5-bdd7-fb0e505015d0	bb26bbcb-ee6d-4370-9c16-84f03d8d362b	2026-01-05 21:09:53.424+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	69b9484e-11e9-459f-9f5a-dcdbeba2111b	\N	Marea importada de seguimiento 2025 (JSONL)
5adea134-099f-4796-9d7a-14fe23e81117	eae8128f-4c82-49d7-a943-fa363d23a025	2026-01-05 21:09:53.43+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	69b9484e-11e9-459f-9f5a-dcdbeba2111b	\N	Marea importada de seguimiento 2025 (JSONL)
a46c2cbe-26c9-4c74-9a40-e3e9b61b2277	04a1cdbe-7149-4e8d-977c-44f6d2f4a7e8	2026-01-05 21:09:53.437+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	6aa3e1af-c033-4aab-a945-e1d1736f9348	\N	Marea importada de seguimiento 2025 (JSONL)
da63eb28-165b-488b-b218-31255a93dddf	b19c9c30-bb96-40bf-a49b-775465d36c79	2026-01-05 21:09:53.443+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	69b9484e-11e9-459f-9f5a-dcdbeba2111b	\N	Marea importada de seguimiento 2025 (JSONL)
88cf0517-2d91-4467-ac3a-286d7e93c0f2	7c44efd9-7014-4dd0-b9c7-79ba62ddc27e	2026-01-05 21:09:53.449+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	69b9484e-11e9-459f-9f5a-dcdbeba2111b	\N	Marea importada de seguimiento 2025 (JSONL)
07153263-21d7-40b0-973a-fe195487273d	303c427b-cdff-4309-bd0b-3f4caf98bab5	2026-01-05 21:09:53.456+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	596d396b-a7db-46f6-a9ba-a525b7cc75a5	\N	Marea importada de seguimiento 2025 (JSONL)
875379ab-34cc-445b-a39d-1f7eec81ec2a	34db321f-b286-48f6-b61f-f44509898775	2026-01-05 21:09:53.462+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	596d396b-a7db-46f6-a9ba-a525b7cc75a5	\N	Marea importada de seguimiento 2025 (JSONL)
535c6e5c-b318-4f51-bb24-7ec94620eb11	1026ef4f-3fcc-4a84-81b6-6d4348392a32	2026-01-05 21:09:53.468+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	596d396b-a7db-46f6-a9ba-a525b7cc75a5	\N	Marea importada de seguimiento 2025 (JSONL)
29a49614-7bc8-41de-ab8b-def57deae61e	703f8ca5-aa24-459b-b097-8bb19c76e642	2026-01-05 21:09:53.475+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	596d396b-a7db-46f6-a9ba-a525b7cc75a5	\N	Marea importada de seguimiento 2025 (JSONL)
d44ee532-40d2-4953-9471-ba0e88fa63ad	07aea281-00d0-4126-89e2-ca221df02dcd	2026-01-05 21:09:53.481+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	596d396b-a7db-46f6-a9ba-a525b7cc75a5	\N	Marea importada de seguimiento 2025 (JSONL)
72914bc6-6fee-4044-b8f8-81f0663cebd1	fb8d7763-2397-4b93-82a4-3e6ba9aeb86b	2026-01-05 21:09:53.488+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	596d396b-a7db-46f6-a9ba-a525b7cc75a5	\N	Marea importada de seguimiento 2025 (JSONL)
97d8feee-407b-45b0-b0bb-7fef513f784f	93354546-0f09-4f3f-95a0-00763ff755d9	2026-01-05 21:09:53.494+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	596d396b-a7db-46f6-a9ba-a525b7cc75a5	\N	Marea importada de seguimiento 2025 (JSONL)
78d1412a-6e8e-4f26-ba8a-97509e8880d9	c701df10-fd15-4d68-bb12-b8f3dee68a93	2026-01-05 21:09:53.501+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	596d396b-a7db-46f6-a9ba-a525b7cc75a5	\N	Marea importada de seguimiento 2025 (JSONL)
d74d84fa-f531-4570-85b4-0a555f87f6d7	fbcbbf37-d9f9-40de-8cfb-064542565b7d	2026-01-05 21:09:53.509+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	69b9484e-11e9-459f-9f5a-dcdbeba2111b	\N	Marea importada de seguimiento 2025 (JSONL)
733b2a04-b2c1-4a33-b7c1-6e1faa1f96b5	45b99544-0bf2-47b8-a879-d768d53e9d23	2026-01-05 21:09:53.517+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	596d396b-a7db-46f6-a9ba-a525b7cc75a5	\N	Marea importada de seguimiento 2025 (JSONL)
a3c6bd36-f198-414a-863b-c9e49241656a	e75b68eb-8771-4c46-969d-b740711a69e1	2026-01-05 21:09:53.524+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	596d396b-a7db-46f6-a9ba-a525b7cc75a5	\N	Marea importada de seguimiento 2025 (JSONL)
2ad86a1b-a969-4c95-9487-6ce28641b29a	b7b1cba7-1a9f-4f81-bf9e-91fd85368074	2026-01-05 21:09:53.531+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	596d396b-a7db-46f6-a9ba-a525b7cc75a5	\N	Marea importada de seguimiento 2025 (JSONL)
3aa62652-7a6d-4b4e-89e8-a92f9d27be41	7bed6c63-432e-4372-94ed-08c541cebdcb	2026-01-05 21:09:53.543+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	596d396b-a7db-46f6-a9ba-a525b7cc75a5	\N	Marea importada de seguimiento 2025 (JSONL)
2c55a9b6-99f0-4f84-b48a-754d5b8cfe33	323b4701-fc99-470f-a91b-d37621df5fd0	2026-01-05 21:09:53.549+00	8951226f-00a0-4e79-8772-9c915882cd52	CREACION	\N	596d396b-a7db-46f6-a9ba-a525b7cc75a5	\N	Marea importada de seguimiento 2025 (JSONL)
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
b2ef0bc6-9476-4d7c-9b4f-a41fb2bf27db	2021	Claudio	Noale	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	t	claudionoale@hotmail.com	Cambio de trabajo
de89af79-db6f-4f3f-b3f4-92515a098490	7149	Gustavo	Cano	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	\N	\N
9c28f134-87b7-415c-ac40-98b6110e971c	7562	Lucas	Bentos	\N	TECNICO	LEY MARCO	t	t	\N	\N	f	\N	\N
05943df7-12f7-4f5b-b4bd-8362394e6fd5	7610	Raul Bernardo	Bargas Peña	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	rbbargas@gmail.com	\N
c7824abb-e0e6-4c6e-b448-066c30d550ff	7611	Cristian Emmanuel	Cerrina	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	manucerrina2@gmail.com	\N
1f99bf1c-77dc-444e-aec0-400a44b876c9	7612	Richard Javier	Espinola Gysin	\N	OBSERVADOR	1109	t	t	\N	\N	f	richardjesp@gmail.com	\N
42e6aca7-f73f-407f-98cd-bcb775487186	7613	Federico Nicolás	Garcia	\N	OBSERVADOR	1109	t	f	\N	\N	t	fede.gaarciaa@gmail.com	Accidente en motocicleta
1ba0799f-4e1a-424f-b667-5decbc9699d8	7616	Jorge Guillermo	Herrera	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	herrerajorgeguillermo@gmail.com	\N
2e831852-846f-40cd-923a-56d8b5d880b8	7617	Leonardo Marcos	Kren	\N	OBSERVADOR	MONOTRIBUTISTA	f	t	\N	\N	t	lmlemark@gmail.com	Licencia médica
55af1bd2-74bc-4ae5-970c-d916a9e78ef3	7620	Diego Sebastian	Marchiori	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	brugmasia@hotmail.com	\N
bae7f1a0-bf6b-48d1-9c44-2a55cd6af939	7621	Luis Gabriel	Martinez Tecco	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	lgmt666@hotmail.com	\N
fc382ff6-1ed2-49e5-988a-90c09b49dadb	7624	Teresa Beatriz	Reinaga	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	tere2361@hotmail.com	\N
b288e78b-597d-4077-8eed-4a751481a764	7625	Eduardo	Silvester	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	eduwolfsilvester@hotmail.com	\N
a2e57f9b-0a17-4bef-89bf-703b5505dc4d	7627	Jorge Luis	Morales	\N	OBSERVADOR	PLANTA PERMANENTE	t	t	\N	\N	f	didiinidep1980@gmail.com	\N
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
bfb93ee4-854e-446e-bea9-ef9512671d4a	7853	Luciano	Matte Casietto	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	lucianomcassietto@hotmail.com.ar	\N
886af39c-fefe-4d8a-84ed-cb6d102f23a1	7854	Gisele	Garcia	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	t	garciagiselealejandra@gmail.com	Desempeño insuficiente reportado
e2c757c5-ba91-4d0d-81b8-792d549909f7	7855	Nicolas	Pereyra	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	nicolasagustinpereyra777@gmail.com	\N
f549f76a-884d-465a-b5fb-db83fb0c563f	7858	Franco	Ibarra	\N	OBSERVADOR	MONOTRIBUTISTA	t	f	\N	\N	t	francoadrianibarra@gmail.com	En otro empleo
9610e6d9-7ae3-4f8d-acb1-567d47e71063	7859	Melisa	Garcia	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	t	melipg7@gmail.com	Restricción operativa para embarque de mujeres
1ca0dd36-2589-459a-8fd3-e0632edae4b1	7860	Nahuel	Ramirez	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	nahuelramirezm@gmail.com	\N
a5f98d6a-7b96-47bf-8f14-6659507e408c	7861	Daiana Anabella	Molina Riquelme	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
56b5c75e-bf1e-40db-9436-f2b83af18631	7862	Christian Enderson	Fenco Chavesta	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
032a87c5-cffa-46ff-8ccd-373d37a64bc2	7863	Daniel Enrique	Ramunno	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
0689b379-899d-42af-b5f6-56ae253657d9	7864	Manuel Agustín	Palos	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
d5b8e040-9af6-4475-9a18-cc524b6c6450	7865	Gabriel Alejandro	Dumrauf	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
8a55a477-86d9-44bd-92c7-2bab0e53430c	7866	Francisco German	Sette	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
0a3ed076-8b9e-4fbc-be38-12bc398dea5b	7867	Cintia Daiana	Magrini Quiroga	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
c0e52411-4b93-4d3e-a297-acb8a956a0b4	7868	Lucas Oscar	Gaona	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
44f7f0ff-921a-487c-aae5-14ec5f653bf1	7869	Sergio Gastón	Frontera	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
d09f06f0-ca9f-4e1e-ac28-492759e65ca8	7871	Sergio Javier	Gomez Mapiz	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
5ac39e92-b193-4205-ba9a-46a7a1a9006f	7872	Juan Francisco	Rodriguez Fulco	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
c805581a-6aaf-49f2-9845-52f0976659e1	7873	Lucas David	Carabeta	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
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
1197662f-ec99-4fcf-a002-e0c80670302b	9465	Daniel Alejandro	Di Tullio	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	ddi@inidep.edu.ar	\N
501379b1-853c-401d-8409-bc4b31b95b4d	9467	Pablo Julian	Miranda	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	pablojmiranda65@gmail.com	\N
dec6f04a-0a75-43a8-89c9-dde5780e0384	9471	Estanislao	Rodriguez Fulco	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	rfestanislao@gmail.com	\N
015409b2-59f2-404e-858b-1af9c9c1f5ba	9474	Juan Manuel	Staneff	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	juanmanuel_jotis@hotmail.com	\N
63a38f88-b458-4702-898d-2e601a72f46e	9476	Héctor Eduardo	Vera	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	t	veraeduardo1971@gmail.com	Licencia médica
277251b3-cac9-49e5-a46c-91681fc081d6	9480	Cristian Oscar	Piriz	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	cristianpiriz36@gmail.com	
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

\unrestrict Lts46UDL7R4fSRWwxTGBDCF702jgC2nBZT7QKBeBjOtJbMME5dRDA4uJVjrhz4g

