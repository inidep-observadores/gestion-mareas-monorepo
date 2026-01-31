--
-- PostgreSQL database dump
--

\restrict G4hltDSVwUhSG8L5SzlZ3cwg84wOix3giivgN1wjr87drbgngBjhIc8cJnYHAKb

-- Dumped from database version 15.15
-- Dumped by pg_dump version 18.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

ALTER TABLE IF EXISTS ONLY public.transiciones_estados DROP CONSTRAINT IF EXISTS transiciones_estados_id_estado_origen_fkey;
ALTER TABLE IF EXISTS ONLY public.transiciones_estados DROP CONSTRAINT IF EXISTS transiciones_estados_id_estado_destino_fkey;
ALTER TABLE IF EXISTS ONLY public.submuestras DROP CONSTRAINT IF EXISTS submuestras_muestra_id_fkey;
ALTER TABLE IF EXISTS ONLY public.products DROP CONSTRAINT IF EXISTS "products_userId_fkey";
ALTER TABLE IF EXISTS ONLY public.product_images DROP CONSTRAINT IF EXISTS "product_images_productId_fkey";
ALTER TABLE IF EXISTS ONLY public.producciones DROP CONSTRAINT IF EXISTS producciones_marea_id_fkey;
ALTER TABLE IF EXISTS ONLY public.producciones DROP CONSTRAINT IF EXISTS producciones_especie_id_fkey;
ALTER TABLE IF EXISTS ONLY public.password_reset_tokens DROP CONSTRAINT IF EXISTS password_reset_tokens_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.observador_pesquerias DROP CONSTRAINT IF EXISTS observador_pesquerias_id_pesqueria_fkey;
ALTER TABLE IF EXISTS ONLY public.observador_pesquerias DROP CONSTRAINT IF EXISTS observador_pesquerias_id_observador_fkey;
ALTER TABLE IF EXISTS ONLY public.observador_pesquerias DROP CONSTRAINT IF EXISTS observador_pesquerias_id_especie_fkey;
ALTER TABLE IF EXISTS ONLY public.muestras DROP CONSTRAINT IF EXISTS muestras_lance_id_fkey;
ALTER TABLE IF EXISTS ONLY public.muestras DROP CONSTRAINT IF EXISTS muestras_especie_id_fkey;
ALTER TABLE IF EXISTS ONLY public.muestras_detalle_talla DROP CONSTRAINT IF EXISTS muestras_detalle_talla_muestra_id_fkey;
ALTER TABLE IF EXISTS ONLY public.mareas_movimientos DROP CONSTRAINT IF EXISTS mareas_movimientos_id_usuario_fkey;
ALTER TABLE IF EXISTS ONLY public.mareas_movimientos DROP CONSTRAINT IF EXISTS mareas_movimientos_id_marea_fkey;
ALTER TABLE IF EXISTS ONLY public.mareas_movimientos DROP CONSTRAINT IF EXISTS mareas_movimientos_id_estado_hasta_fkey;
ALTER TABLE IF EXISTS ONLY public.mareas_movimientos DROP CONSTRAINT IF EXISTS mareas_movimientos_id_estado_desde_fkey;
ALTER TABLE IF EXISTS ONLY public.mareas DROP CONSTRAINT IF EXISTS mareas_id_observador_principal_fkey;
ALTER TABLE IF EXISTS ONLY public.mareas DROP CONSTRAINT IF EXISTS mareas_id_estado_actual_fkey;
ALTER TABLE IF EXISTS ONLY public.mareas DROP CONSTRAINT IF EXISTS mareas_id_buque_fkey;
ALTER TABLE IF EXISTS ONLY public.mareas DROP CONSTRAINT IF EXISTS mareas_id_arte_principal_fkey;
ALTER TABLE IF EXISTS ONLY public.mareas_etapas_observadores DROP CONSTRAINT IF EXISTS mareas_etapas_observadores_id_observador_fkey;
ALTER TABLE IF EXISTS ONLY public.mareas_etapas_observadores DROP CONSTRAINT IF EXISTS mareas_etapas_observadores_id_etapa_fkey;
ALTER TABLE IF EXISTS ONLY public.mareas_etapas DROP CONSTRAINT IF EXISTS mareas_etapas_id_puerto_zarpada_fkey;
ALTER TABLE IF EXISTS ONLY public.mareas_etapas DROP CONSTRAINT IF EXISTS mareas_etapas_id_puerto_arribo_fkey;
ALTER TABLE IF EXISTS ONLY public.mareas_etapas DROP CONSTRAINT IF EXISTS mareas_etapas_id_pesqueria_fkey;
ALTER TABLE IF EXISTS ONLY public.mareas_etapas DROP CONSTRAINT IF EXISTS mareas_etapas_id_marea_fkey;
ALTER TABLE IF EXISTS ONLY public.mareas_archivos DROP CONSTRAINT IF EXISTS mareas_archivos_id_usuario_subio_fkey;
ALTER TABLE IF EXISTS ONLY public.mareas_archivos DROP CONSTRAINT IF EXISTS mareas_archivos_id_movimiento_origen_fkey;
ALTER TABLE IF EXISTS ONLY public.mareas_archivos DROP CONSTRAINT IF EXISTS mareas_archivos_id_marea_fkey;
ALTER TABLE IF EXISTS ONLY public.lances DROP CONSTRAINT IF EXISTS lances_etapa_id_fkey;
ALTER TABLE IF EXISTS ONLY public.lances DROP CONSTRAINT IF EXISTS lances_cod_arte_pesca_fkey;
ALTER TABLE IF EXISTS ONLY public.capturas DROP CONSTRAINT IF EXISTS capturas_lance_id_fkey;
ALTER TABLE IF EXISTS ONLY public.capturas DROP CONSTRAINT IF EXISTS capturas_especie_id_fkey;
ALTER TABLE IF EXISTS ONLY public.buques DROP CONSTRAINT IF EXISTS buques_id_tipo_flota_fkey;
ALTER TABLE IF EXISTS ONLY public.buques DROP CONSTRAINT IF EXISTS buques_id_puerto_base_fkey;
ALTER TABLE IF EXISTS ONLY public.buques DROP CONSTRAINT IF EXISTS buques_id_pesqueria_habitual_fkey;
ALTER TABLE IF EXISTS ONLY public.buques DROP CONSTRAINT IF EXISTS buques_id_arte_habitual_fkey;
ALTER TABLE IF EXISTS ONLY public.buque_trayectorias DROP CONSTRAINT IF EXISTS buque_trayectorias_buque_id_fkey;
ALTER TABLE IF EXISTS ONLY public.buque_trayectoria_puntos DROP CONSTRAINT IF EXISTS buque_trayectoria_puntos_trayectoria_id_fkey;
ALTER TABLE IF EXISTS ONLY public.buque_trayectoria_puntos DROP CONSTRAINT IF EXISTS buque_trayectoria_puntos_buque_id_fkey;
ALTER TABLE IF EXISTS ONLY public.alertas_eventos DROP CONSTRAINT IF EXISTS alertas_eventos_usuario_id_fkey;
ALTER TABLE IF EXISTS ONLY public.alertas_eventos DROP CONSTRAINT IF EXISTS alertas_eventos_alerta_id_fkey;
ALTER TABLE IF EXISTS ONLY public.alertas DROP CONSTRAINT IF EXISTS alertas_creado_por_id_fkey;
ALTER TABLE IF EXISTS ONLY public.alertas DROP CONSTRAINT IF EXISTS alertas_asignado_id_fkey;
DROP INDEX IF EXISTS public.users_email_key;
DROP INDEX IF EXISTS public.transiciones_estados_id_estado_origen_id_estado_destino_acc_key;
DROP INDEX IF EXISTS public.tipos_flota_codigo_numerico_key;
DROP INDEX IF EXISTS public.tipos_flota_codigo_key;
DROP INDEX IF EXISTS public.submuestras_muestra_id_numero_ejemplar_key;
DROP INDEX IF EXISTS public.submuestras_muestra_id_idx;
DROP INDEX IF EXISTS public.puertos_codigo_interno_key;
DROP INDEX IF EXISTS public.products_title_key;
DROP INDEX IF EXISTS public.products_slug_key;
DROP INDEX IF EXISTS public.producciones_marea_id_idx;
DROP INDEX IF EXISTS public.producciones_marea_id_especie_id_fecha_producto_categoria_key;
DROP INDEX IF EXISTS public.pesquerias_codigo_key;
DROP INDEX IF EXISTS public.observadores_email_key;
DROP INDEX IF EXISTS public.observadores_codigo_interno_key;
DROP INDEX IF EXISTS public.observador_pesquerias_id_pesqueria_idx;
DROP INDEX IF EXISTS public.observador_pesquerias_id_observador_idx;
DROP INDEX IF EXISTS public.observador_pesquerias_id_observador_id_pesqueria_modo_key;
DROP INDEX IF EXISTS public.muestras_lance_id_idx;
DROP INDEX IF EXISTS public.muestras_lance_id_especie_id_tipo_muestra_key;
DROP INDEX IF EXISTS public.muestras_detalle_talla_muestra_id_talla_mm_key;
DROP INDEX IF EXISTS public.muestras_detalle_talla_muestra_id_idx;
DROP INDEX IF EXISTS public.mareas_movimientos_id_marea_idx;
DROP INDEX IF EXISTS public.mareas_etapas_observadores_id_observador_idx;
DROP INDEX IF EXISTS public.mareas_etapas_observadores_id_etapa_idx;
DROP INDEX IF EXISTS public.mareas_etapas_observadores_id_etapa_id_observador_key;
DROP INDEX IF EXISTS public.mareas_etapas_id_marea_nro_etapa_key;
DROP INDEX IF EXISTS public.mareas_etapas_id_marea_idx;
DROP INDEX IF EXISTS public.mareas_archivos_id_marea_idx;
DROP INDEX IF EXISTS public.mareas_anio_marea_nro_marea_id_buque_tipo_marea_key;
DROP INDEX IF EXISTS public.lances_etapa_id_numero_lance_key;
DROP INDEX IF EXISTS public.lances_etapa_id_idx;
DROP INDEX IF EXISTS public.importacion_access_snapshots_nro_marea_anio_marea_tipo_mare_idx;
DROP INDEX IF EXISTS public.importacion_access_snapshots_id_externo_key;
DROP INDEX IF EXISTS public.estados_marea_codigo_key;
DROP INDEX IF EXISTS public.especies_codigo_key;
DROP INDEX IF EXISTS public.capturas_lance_id_idx;
DROP INDEX IF EXISTS public.capturas_lance_id_especie_id_key;
DROP INDEX IF EXISTS public.buques_matricula_key;
DROP INDEX IF EXISTS public.buque_trayectorias_buque_id_key;
DROP INDEX IF EXISTS public.buque_trayectorias_buque_id_idx;
DROP INDEX IF EXISTS public.buque_trayectoria_puntos_trayectoria_id_timestamp_idx;
DROP INDEX IF EXISTS public.buque_trayectoria_puntos_buque_id_timestamp_key;
DROP INDEX IF EXISTS public.buque_trayectoria_puntos_buque_id_timestamp_idx;
DROP INDEX IF EXISTS public.artes_pesca_codigo_numerico_key;
DROP INDEX IF EXISTS public.alertas_referencia_id_idx;
DROP INDEX IF EXISTS public.alertas_eventos_alerta_id_idx;
DROP INDEX IF EXISTS public.alertas_estado_idx;
DROP INDEX IF EXISTS public.alertas_codigo_unico_key;
DROP INDEX IF EXISTS public.alertas_asignado_id_idx;
ALTER TABLE IF EXISTS ONLY public.users DROP CONSTRAINT IF EXISTS users_pkey;
ALTER TABLE IF EXISTS ONLY public.transiciones_estados DROP CONSTRAINT IF EXISTS transiciones_estados_pkey;
ALTER TABLE IF EXISTS ONLY public.tipos_flota DROP CONSTRAINT IF EXISTS tipos_flota_pkey;
ALTER TABLE IF EXISTS ONLY public.submuestras DROP CONSTRAINT IF EXISTS submuestras_pkey;
ALTER TABLE IF EXISTS ONLY public.puertos DROP CONSTRAINT IF EXISTS puertos_pkey;
ALTER TABLE IF EXISTS ONLY public.products DROP CONSTRAINT IF EXISTS products_pkey;
ALTER TABLE IF EXISTS ONLY public.product_images DROP CONSTRAINT IF EXISTS product_images_pkey;
ALTER TABLE IF EXISTS ONLY public.producciones DROP CONSTRAINT IF EXISTS producciones_pkey;
ALTER TABLE IF EXISTS ONLY public.pesquerias DROP CONSTRAINT IF EXISTS pesquerias_pkey;
ALTER TABLE IF EXISTS ONLY public.password_reset_tokens DROP CONSTRAINT IF EXISTS password_reset_tokens_pkey;
ALTER TABLE IF EXISTS ONLY public.observadores DROP CONSTRAINT IF EXISTS observadores_pkey;
ALTER TABLE IF EXISTS ONLY public.observador_pesquerias DROP CONSTRAINT IF EXISTS observador_pesquerias_pkey;
ALTER TABLE IF EXISTS ONLY public.muestras DROP CONSTRAINT IF EXISTS muestras_pkey;
ALTER TABLE IF EXISTS ONLY public.muestras_detalle_talla DROP CONSTRAINT IF EXISTS muestras_detalle_talla_pkey;
ALTER TABLE IF EXISTS ONLY public.mareas DROP CONSTRAINT IF EXISTS mareas_pkey;
ALTER TABLE IF EXISTS ONLY public.mareas_movimientos DROP CONSTRAINT IF EXISTS mareas_movimientos_pkey;
ALTER TABLE IF EXISTS ONLY public.mareas_etapas DROP CONSTRAINT IF EXISTS mareas_etapas_pkey;
ALTER TABLE IF EXISTS ONLY public.mareas_etapas_observadores DROP CONSTRAINT IF EXISTS mareas_etapas_observadores_pkey;
ALTER TABLE IF EXISTS ONLY public.mareas_archivos DROP CONSTRAINT IF EXISTS mareas_archivos_pkey;
ALTER TABLE IF EXISTS ONLY public.lances DROP CONSTRAINT IF EXISTS lances_pkey;
ALTER TABLE IF EXISTS ONLY public.importacion_access_snapshots DROP CONSTRAINT IF EXISTS importacion_access_snapshots_pkey;
ALTER TABLE IF EXISTS ONLY public.estados_marea DROP CONSTRAINT IF EXISTS estados_marea_pkey;
ALTER TABLE IF EXISTS ONLY public.especies DROP CONSTRAINT IF EXISTS especies_pkey;
ALTER TABLE IF EXISTS ONLY public.error_logs DROP CONSTRAINT IF EXISTS error_logs_pkey;
ALTER TABLE IF EXISTS ONLY public.capturas DROP CONSTRAINT IF EXISTS capturas_pkey;
ALTER TABLE IF EXISTS ONLY public.buques DROP CONSTRAINT IF EXISTS buques_pkey;
ALTER TABLE IF EXISTS ONLY public.buque_trayectorias DROP CONSTRAINT IF EXISTS buque_trayectorias_pkey;
ALTER TABLE IF EXISTS ONLY public.buque_trayectoria_puntos DROP CONSTRAINT IF EXISTS buque_trayectoria_puntos_pkey;
ALTER TABLE IF EXISTS ONLY public.artes_pesca DROP CONSTRAINT IF EXISTS artes_pesca_pkey;
ALTER TABLE IF EXISTS ONLY public.alertas DROP CONSTRAINT IF EXISTS alertas_pkey;
ALTER TABLE IF EXISTS ONLY public.alertas_eventos DROP CONSTRAINT IF EXISTS alertas_eventos_pkey;
ALTER TABLE IF EXISTS ONLY public._prisma_migrations DROP CONSTRAINT IF EXISTS _prisma_migrations_pkey;
ALTER TABLE IF EXISTS public.product_images ALTER COLUMN id DROP DEFAULT;
DROP VIEW IF EXISTS public.vw_mareas_completas;
DROP TABLE IF EXISTS public.users;
DROP TABLE IF EXISTS public.transiciones_estados;
DROP TABLE IF EXISTS public.tipos_flota;
DROP TABLE IF EXISTS public.submuestras;
DROP TABLE IF EXISTS public.puertos;
DROP TABLE IF EXISTS public.products;
DROP SEQUENCE IF EXISTS public.product_images_id_seq;
DROP TABLE IF EXISTS public.product_images;
DROP TABLE IF EXISTS public.producciones;
DROP TABLE IF EXISTS public.pesquerias;
DROP TABLE IF EXISTS public.password_reset_tokens;
DROP TABLE IF EXISTS public.observadores;
DROP TABLE IF EXISTS public.observador_pesquerias;
DROP TABLE IF EXISTS public.muestras_detalle_talla;
DROP TABLE IF EXISTS public.muestras;
DROP TABLE IF EXISTS public.mareas_movimientos;
DROP TABLE IF EXISTS public.mareas_etapas_observadores;
DROP TABLE IF EXISTS public.mareas_etapas;
DROP TABLE IF EXISTS public.mareas_archivos;
DROP TABLE IF EXISTS public.mareas;
DROP TABLE IF EXISTS public.lances;
DROP TABLE IF EXISTS public.importacion_access_snapshots;
DROP TABLE IF EXISTS public.estados_marea;
DROP TABLE IF EXISTS public.especies;
DROP TABLE IF EXISTS public.error_logs;
DROP TABLE IF EXISTS public.capturas;
DROP TABLE IF EXISTS public.buques;
DROP TABLE IF EXISTS public.buque_trayectorias;
DROP TABLE IF EXISTS public.buque_trayectoria_puntos;
DROP TABLE IF EXISTS public.artes_pesca;
DROP TABLE IF EXISTS public.alertas_eventos;
DROP TABLE IF EXISTS public.alertas;
DROP TABLE IF EXISTS public._prisma_migrations;
DROP TYPE IF EXISTS public."AlertaPrioridad";
DROP TYPE IF EXISTS public."AlertaEstado";
-- *not* dropping schema, since initdb creates it
--
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

-- *not* creating schema, since initdb creates it


--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA public IS '';


--
-- Name: AlertaEstado; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."AlertaEstado" AS ENUM (
    'PENDIENTE',
    'SEGUIMIENTO',
    'RESUELTA',
    'DESCARTADA',
    'VENCIDA'
);


--
-- Name: AlertaPrioridad; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."AlertaPrioridad" AS ENUM (
    'URGENTE',
    'ALTA',
    'MEDIA',
    'BAJA'
);


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: _prisma_migrations; Type: TABLE; Schema: public; Owner: -
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


--
-- Name: alertas; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.alertas (
    id uuid NOT NULL,
    codigo_unico text NOT NULL,
    referencia_id text,
    tipo text NOT NULL,
    titulo text NOT NULL,
    descripcion text NOT NULL,
    estado public."AlertaEstado" NOT NULL,
    prioridad public."AlertaPrioridad" NOT NULL,
    fecha_detectada timestamp(6) with time zone NOT NULL,
    fecha_vencimiento timestamp(6) with time zone,
    fecha_cierre timestamp(6) with time zone,
    asignado_id uuid,
    creado_por_id uuid,
    ultima_actualizacion timestamp(6) with time zone NOT NULL,
    metadata jsonb,
    referencia_tipo text,
    visible boolean DEFAULT true NOT NULL
);


--
-- Name: alertas_eventos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.alertas_eventos (
    id uuid NOT NULL,
    alerta_id uuid NOT NULL,
    fecha_hora timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    usuario_id uuid,
    tipo_evento text NOT NULL,
    detalle text
);


--
-- Name: artes_pesca; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.artes_pesca (
    id uuid NOT NULL,
    codigo_numerico integer NOT NULL,
    activo boolean DEFAULT true NOT NULL,
    nombre text NOT NULL
);


--
-- Name: buque_trayectoria_puntos; Type: TABLE; Schema: public; Owner: -
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


--
-- Name: buque_trayectorias; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.buque_trayectorias (
    id uuid NOT NULL,
    buque_id uuid NOT NULL,
    origen text,
    metadata jsonb
);


--
-- Name: buques; Type: TABLE; Schema: public; Owner: -
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


--
-- Name: capturas; Type: TABLE; Schema: public; Owner: -
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


--
-- Name: error_logs; Type: TABLE; Schema: public; Owner: -
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


--
-- Name: especies; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.especies (
    id uuid NOT NULL,
    codigo text NOT NULL,
    nombre_cientifico text NOT NULL,
    nombre_vulgar text NOT NULL,
    activo boolean DEFAULT true NOT NULL,
    observaciones text
);


--
-- Name: estados_marea; Type: TABLE; Schema: public; Owner: -
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


--
-- Name: importacion_access_snapshots; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.importacion_access_snapshots (
    id uuid NOT NULL,
    id_externo integer NOT NULL,
    nro_marea integer,
    anio_marea integer NOT NULL,
    tipo_marea text NOT NULL,
    nro_etapa integer NOT NULL,
    fecha_zarpada date,
    fecha_arribo date,
    buque_nombre text,
    observador_codigo integer,
    hash_contenido text NOT NULL,
    fecha_primera_lectura timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    fecha_ultima_lectura timestamp(6) with time zone NOT NULL,
    marea_id uuid,
    etapa_id uuid
);


--
-- Name: lances; Type: TABLE; Schema: public; Owner: -
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


--
-- Name: mareas; Type: TABLE; Schema: public; Owner: -
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
    dias_estimados integer,
    id_observador_principal uuid
);


--
-- Name: mareas_archivos; Type: TABLE; Schema: public; Owner: -
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


--
-- Name: mareas_etapas; Type: TABLE; Schema: public; Owner: -
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


--
-- Name: mareas_etapas_observadores; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.mareas_etapas_observadores (
    id uuid NOT NULL,
    id_etapa uuid NOT NULL,
    id_observador uuid NOT NULL,
    rol text DEFAULT 'PRINCIPAL'::text NOT NULL,
    es_designado boolean DEFAULT true NOT NULL
);


--
-- Name: mareas_movimientos; Type: TABLE; Schema: public; Owner: -
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
    detalle text,
    comentarios text
);


--
-- Name: muestras; Type: TABLE; Schema: public; Owner: -
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


--
-- Name: muestras_detalle_talla; Type: TABLE; Schema: public; Owner: -
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


--
-- Name: observador_pesquerias; Type: TABLE; Schema: public; Owner: -
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


--
-- Name: observadores; Type: TABLE; Schema: public; Owner: -
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


--
-- Name: password_reset_tokens; Type: TABLE; Schema: public; Owner: -
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


--
-- Name: pesquerias; Type: TABLE; Schema: public; Owner: -
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


--
-- Name: producciones; Type: TABLE; Schema: public; Owner: -
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


--
-- Name: product_images; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.product_images (
    id integer NOT NULL,
    url text NOT NULL,
    "productId" uuid NOT NULL
);


--
-- Name: product_images_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.product_images_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: product_images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.product_images_id_seq OWNED BY public.product_images.id;


--
-- Name: products; Type: TABLE; Schema: public; Owner: -
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


--
-- Name: puertos; Type: TABLE; Schema: public; Owner: -
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


--
-- Name: submuestras; Type: TABLE; Schema: public; Owner: -
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


--
-- Name: tipos_flota; Type: TABLE; Schema: public; Owner: -
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


--
-- Name: transiciones_estados; Type: TABLE; Schema: public; Owner: -
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


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
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


--
-- Name: vw_mareas_completas; Type: VIEW; Schema: public; Owner: -
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


--
-- Name: product_images id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_images ALTER COLUMN id SET DEFAULT nextval('public.product_images_id_seq'::regclass);


--
-- Data for Name: _prisma_migrations; Type: TABLE DATA; Schema: public; Owner: -
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
4f96e818-c248-4270-bfc5-d23b128a6b20	30a34eeb529bccb2c35ea7c8a815349fc7ebe17bad9dddf84f1be92e7ed738a1	2026-01-13 01:55:44.2893+00	20260113015544_add_comentarios_to_movimientos	\N	\N	2026-01-13 01:55:44.221448+00	1
c40f852b-4187-4189-8852-d53956b1f84a	e5128378dee79f3e106d9ef2f562491afefc3cf48f9db9fb75dc1c860934c188	2026-01-16 18:47:49.954739+00	20260116174324_add_access_import_snapshots	\N	\N	2026-01-16 18:47:49.878257+00	1
b8f6fa29-b8ed-4a5d-ba5b-7b002cceee16	bd8af5bb0618b330449ac2da66c4956fed0d7c87c28019046135a666b17e0f1e	2026-01-16 19:52:19.163621+00	20260116192925_add_urgent_priority_and_enums	\N	\N	2026-01-16 19:52:18.956665+00	1
b973b2a0-4c68-47fd-8829-8d4f5d2aebd4	9b99995269b62fb54ba23ea60b164050c5bc7e6b962d0ba76d3411cdbc3d3a6c	2026-01-17 00:44:41.539892+00	20260117004441_add_visible_to_alerta	\N	\N	2026-01-17 00:44:41.521039+00	1
e4ea17eb-9917-4f82-8cf2-cb957f28c3d9	96715f87018efb0d634e85d217a537693ddc2aea513ac2b18a6f2304f5e6e802	2026-01-17 20:19:00.819854+00	20260117201900_add_observador_principal_to_marea	\N	\N	2026-01-17 20:19:00.737487+00	1
\.


--
-- Data for Name: alertas; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.alertas (id, codigo_unico, referencia_id, tipo, titulo, descripcion, estado, prioridad, fecha_detectada, fecha_vencimiento, fecha_cierre, asignado_id, creado_por_id, ultima_actualizacion, metadata, referencia_tipo, visible) FROM stdin;
2a57b115-3331-401a-a181-f22ff0b84586	RETRASO_DATOS-a5ee89fd-138a-41bf-b094-dfbae4da6651	a5ee89fd-138a-41bf-b094-dfbae4da6651	RETRASO_DATOS	Retraso en Entrega de Datos	Marea MC-171-25 (CAPESANTE) - 38 días de demora.	PENDIENTE	URGENTE	2026-01-18 04:10:37.954+00	\N	\N	\N	\N	2026-01-18 04:10:37.961+00	{"vessel": "CAPESANTE", "busDays": 38, "mareaCode": "MC-171-25", "observerName": "Eduardo Silvester"}	MAREA	t
0c684505-c7ec-48e9-8cb1-c42913eca732	FATIGA-9ca0a15b-a857-4fab-9747-b620717776dd-2025	9ca0a15b-a857-4fab-9747-b620717776dd	FATIGA	Fatiga Crítica Detectada	El observador Eduardo Silvester ha navegado 163 días en el año.	PENDIENTE	ALTA	2026-01-18 23:39:17.488+00	\N	\N	\N	\N	2026-01-18 23:39:17.49+00	{"days": 163, "observerName": "Eduardo Silvester"}	OBSERVADOR	t
7110af12-8a25-4077-ad1f-761ff49b22c7	FATIGA-20b0118b-9612-4fa8-b90c-5e11e27b07e3-2025	20b0118b-9612-4fa8-b90c-5e11e27b07e3	FATIGA	Fatiga Crítica Detectada	El observador Nicolas Facundo Staneff Rotela ha navegado 180 días en el año.	PENDIENTE	ALTA	2026-01-18 23:39:17.657+00	\N	\N	\N	\N	2026-01-18 23:39:17.659+00	{"days": 180, "observerName": "Nicolas Facundo Staneff Rotela"}	OBSERVADOR	t
9bcfe556-37e5-4209-a8c0-990d8467b250	FATIGA-f0a415e0-9538-4336-b681-9d23e0753e26-2025	f0a415e0-9538-4336-b681-9d23e0753e26	FATIGA	Fatiga Crítica Detectada	El observador Alejandro José Mazzei ha navegado 178 días en el año.	PENDIENTE	ALTA	2026-01-18 23:39:17.666+00	\N	\N	\N	\N	2026-01-18 23:39:17.667+00	{"days": 178, "observerName": "Alejandro José Mazzei"}	OBSERVADOR	t
d9396d02-2e52-42da-9eaf-cc2305d42de7	FATIGA-66d4eb59-5d54-446b-9ee0-88fa9c133899-2025	66d4eb59-5d54-446b-9ee0-88fa9c133899	FATIGA	Fatiga Crítica Detectada	El observador Juan José Coppa ha navegado 207 días en el año.	PENDIENTE	ALTA	2026-01-18 23:39:17.675+00	\N	\N	\N	\N	2026-01-18 23:39:17.676+00	{"days": 207, "observerName": "Juan José Coppa"}	OBSERVADOR	t
83ed1595-bb2d-4f6f-8450-00279b2a4adb	FATIGA-d7785cda-1f2e-4d29-a52d-335b2096bde6-2025	d7785cda-1f2e-4d29-a52d-335b2096bde6	FATIGA	Fatiga Crítica Detectada	El observador Pablo Julian Miranda ha navegado 189 días en el año.	PENDIENTE	ALTA	2026-01-18 23:39:17.684+00	\N	\N	\N	\N	2026-01-18 23:39:17.685+00	{"days": 189, "observerName": "Pablo Julian Miranda"}	OBSERVADOR	t
8e7f61fe-03b4-411f-8299-38f7b8ffb11d	FATIGA-fb61c911-79f8-45ed-8e0e-23bfa3a9ad2b-2025	fb61c911-79f8-45ed-8e0e-23bfa3a9ad2b	FATIGA	Fatiga Crítica Detectada	El observador Juan Manuel Staneff ha navegado 191 días en el año.	PENDIENTE	ALTA	2026-01-18 23:39:17.691+00	\N	\N	\N	\N	2026-01-18 23:39:17.692+00	{"days": 191, "observerName": "Juan Manuel Staneff"}	OBSERVADOR	t
87b84c1f-0701-4890-9b7a-8172c342bdb7	FATIGA-a21b30af-c563-4c43-9d68-bafd0243c5e6-2025	a21b30af-c563-4c43-9d68-bafd0243c5e6	FATIGA	Fatiga Crítica Detectada	El observador Marcelo Simón Freyre ha navegado 190 días en el año.	PENDIENTE	ALTA	2026-01-18 23:39:17.699+00	\N	\N	\N	\N	2026-01-18 23:39:17.7+00	{"days": 190, "observerName": "Marcelo Simón Freyre"}	OBSERVADOR	t
8b57564d-9231-4f6c-9f85-4d629e29bdd3	FATIGA-06979c36-da6e-4fb0-840e-07533a1d41c7-2025	06979c36-da6e-4fb0-840e-07533a1d41c7	FATIGA	Fatiga Crítica Detectada	El observador Diego Gorosito ha navegado 167 días en el año.	PENDIENTE	ALTA	2026-01-18 23:39:17.707+00	\N	\N	\N	\N	2026-01-18 23:39:17.708+00	{"days": 167, "observerName": "Diego Gorosito"}	OBSERVADOR	t
57845f13-680a-40d1-b9a6-81e1801f5509	FATIGA-8ced3542-9444-4153-b141-27ed65a5995b-2025	8ced3542-9444-4153-b141-27ed65a5995b	FATIGA	Fatiga Crítica Detectada	El observador Teresa Beatriz Reinaga ha navegado 200 días en el año.	PENDIENTE	ALTA	2026-01-18 23:39:17.715+00	\N	\N	\N	\N	2026-01-18 23:39:17.716+00	{"days": 200, "observerName": "Teresa Beatriz Reinaga"}	OBSERVADOR	t
f61d2425-3221-4c2c-b86b-06870d730fd1	FATIGA-dfbdeeff-4e60-46c2-9ce0-7becb9a494a2-2025	dfbdeeff-4e60-46c2-9ce0-7becb9a494a2	FATIGA	Fatiga Crítica Detectada	El observador Claudio Noale ha navegado 163 días en el año.	PENDIENTE	ALTA	2026-01-18 23:39:17.723+00	\N	\N	\N	\N	2026-01-18 23:39:17.724+00	{"days": 163, "observerName": "Claudio Noale"}	OBSERVADOR	t
a517c0aa-580d-4ec4-9073-6a8ac951feb9	FATIGA-cded2d3e-5f9e-4de6-9269-a1da3eeeff0a-2025	cded2d3e-5f9e-4de6-9269-a1da3eeeff0a	FATIGA	Fatiga Crítica Detectada	El observador Walter Alejandro Glavina ha navegado 174 días en el año.	PENDIENTE	ALTA	2026-01-18 23:39:17.731+00	\N	\N	\N	\N	2026-01-18 23:39:17.732+00	{"days": 174, "observerName": "Walter Alejandro Glavina"}	OBSERVADOR	t
a25af1ac-e8f2-4707-955e-0094ed060b7d	FATIGA-f644ca0f-bf5f-4449-9c40-7eba742654de-2025	f644ca0f-bf5f-4449-9c40-7eba742654de	FATIGA	Fatiga Crítica Detectada	El observador Luciano Matte Casietto ha navegado 171 días en el año.	PENDIENTE	ALTA	2026-01-18 23:39:17.739+00	\N	\N	\N	\N	2026-01-18 23:39:17.74+00	{"days": 171, "observerName": "Luciano Matte Casietto"}	OBSERVADOR	t
295d5ab3-c53f-464c-a374-362771239a21	FATIGA-e148f60c-2aeb-442f-b302-491f4e0eca2b-2025	e148f60c-2aeb-442f-b302-491f4e0eca2b	FATIGA	Fatiga Crítica Detectada	El observador Nicolas Agustin Caballero ha navegado 180 días en el año.	PENDIENTE	ALTA	2026-01-18 23:39:17.748+00	\N	\N	\N	\N	2026-01-18 23:39:17.749+00	{"days": 180, "observerName": "Nicolas Agustin Caballero"}	OBSERVADOR	t
42b66f15-bd0c-4430-b8a6-643e58f15ede	FATIGA-b500d7bc-3760-4c88-9a21-4294b2395c71-2025	b500d7bc-3760-4c88-9a21-4294b2395c71	FATIGA	Fatiga Crítica Detectada	El observador Durbal Villalba ha navegado 189 días en el año.	PENDIENTE	ALTA	2026-01-18 23:39:17.755+00	\N	\N	\N	\N	2026-01-18 23:39:17.756+00	{"days": 189, "observerName": "Durbal Villalba"}	OBSERVADOR	t
9f740955-a6f5-4a81-85b4-0fbc4706e5db	FATIGA-c8fdee90-2d16-4800-8a4d-e6b470cf152d-2025	c8fdee90-2d16-4800-8a4d-e6b470cf152d	FATIGA	Fatiga Crítica Detectada	El observador Cristian Emmanuel Cerrina ha navegado 186 días en el año.	PENDIENTE	ALTA	2026-01-18 23:39:17.766+00	\N	\N	\N	\N	2026-01-18 23:39:17.767+00	{"days": 186, "observerName": "Cristian Emmanuel Cerrina"}	OBSERVADOR	t
36855aa9-7531-4cf5-865b-58fcfa564849	FATIGA-b33fd685-31a6-4510-a970-09a2d428a1bb-2025	b33fd685-31a6-4510-a970-09a2d428a1bb	FATIGA	Fatiga Crítica Detectada	El observador Johnatan Challier ha navegado 202 días en el año.	PENDIENTE	ALTA	2026-01-18 23:39:17.775+00	\N	\N	\N	\N	2026-01-18 23:39:17.776+00	{"days": 202, "observerName": "Johnatan Challier"}	OBSERVADOR	t
\.


--
-- Data for Name: alertas_eventos; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.alertas_eventos (id, alerta_id, fecha_hora, usuario_id, tipo_evento, detalle) FROM stdin;
17af4729-9db8-4723-a693-75964d9c003b	2a57b115-3331-401a-a181-f22ff0b84586	2026-01-18 04:10:37.996+00	\N	CREACION	Alerta detectada/creada
1a1b033d-7f99-41cb-81c6-86b691e9d529	0c684505-c7ec-48e9-8cb1-c42913eca732	2026-01-18 23:39:17.651+00	\N	CREACION	Alerta detectada/creada
1b2e87fc-6eed-469f-b1e7-4032dc20bda1	7110af12-8a25-4077-ad1f-761ff49b22c7	2026-01-18 23:39:17.662+00	\N	CREACION	Alerta detectada/creada
64109814-d707-4052-8f26-f31c67f82d30	9bcfe556-37e5-4209-a8c0-990d8467b250	2026-01-18 23:39:17.671+00	\N	CREACION	Alerta detectada/creada
13fc0825-8204-4779-a7c4-73dd61de2d57	d9396d02-2e52-42da-9eaf-cc2305d42de7	2026-01-18 23:39:17.68+00	\N	CREACION	Alerta detectada/creada
ecf5ea02-67b6-4c56-8142-1bf6038d916d	83ed1595-bb2d-4f6f-8450-00279b2a4adb	2026-01-18 23:39:17.688+00	\N	CREACION	Alerta detectada/creada
e6ac2c64-8437-472a-ab35-b6f18d7ee0c8	8e7f61fe-03b4-411f-8299-38f7b8ffb11d	2026-01-18 23:39:17.695+00	\N	CREACION	Alerta detectada/creada
fe40cfcd-5482-4f8e-a323-e85ad90fa861	87b84c1f-0701-4890-9b7a-8172c342bdb7	2026-01-18 23:39:17.703+00	\N	CREACION	Alerta detectada/creada
fd5f6489-4273-408d-8855-495cd51a8e3c	8b57564d-9231-4f6c-9f85-4d629e29bdd3	2026-01-18 23:39:17.711+00	\N	CREACION	Alerta detectada/creada
92c7bb69-887c-4522-8c4f-f290f2d5cb64	57845f13-680a-40d1-b9a6-81e1801f5509	2026-01-18 23:39:17.719+00	\N	CREACION	Alerta detectada/creada
756ccaaf-a146-4f36-a2f4-652b3ac2ea56	f61d2425-3221-4c2c-b86b-06870d730fd1	2026-01-18 23:39:17.727+00	\N	CREACION	Alerta detectada/creada
96351d31-cbcf-4ace-a883-40209a8597a9	a517c0aa-580d-4ec4-9073-6a8ac951feb9	2026-01-18 23:39:17.735+00	\N	CREACION	Alerta detectada/creada
fb68e77f-c296-4545-9540-3d79e6008093	a25af1ac-e8f2-4707-955e-0094ed060b7d	2026-01-18 23:39:17.744+00	\N	CREACION	Alerta detectada/creada
d44bc080-e7f4-4098-87fe-9db76eeedaa0	295d5ab3-c53f-464c-a374-362771239a21	2026-01-18 23:39:17.752+00	\N	CREACION	Alerta detectada/creada
cfc7f5ed-a7cb-4c67-9add-66ec43174620	42b66f15-bd0c-4430-b8a6-643e58f15ede	2026-01-18 23:39:17.76+00	\N	CREACION	Alerta detectada/creada
5eda9c5e-42d9-4837-b279-b293c9be22eb	9f740955-a6f5-4a81-85b4-0fbc4706e5db	2026-01-18 23:39:17.771+00	\N	CREACION	Alerta detectada/creada
1a4e2a9f-2cf9-4d13-bf12-7a207ca77b18	36855aa9-7531-4cf5-865b-58fcfa564849	2026-01-18 23:39:17.779+00	\N	CREACION	Alerta detectada/creada
\.


--
-- Data for Name: artes_pesca; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.artes_pesca (id, codigo_numerico, activo, nombre) FROM stdin;
acea052d-e5d1-4ced-b98c-2d01eb79122a	2	t	Red de arrastre de fondo
f26d07e6-ac95-442d-aa7a-3cbfeb6be06a	6	t	Red de arrastre de media agua
805ccf3f-a660-4766-9ecd-3b789621824a	3	t	Red de lampara
72b62486-3f93-4214-8896-c016c45e6489	5	t	Espinel
d4fe2fe8-a7d7-4e20-a4d8-fe90f643a663	4	t	Red de enmalle
bbfaaafb-d361-4f1a-8ebd-336a531d692b	18	t	Red agallera de deriva
3b9fe535-63a2-4982-b7d4-71229ab250dc	16	t	Palangre de fondo
2b371e28-b99a-4d89-a517-2ee7de97f02b	1	t	Red de cerco
a8064009-9670-4d8c-b727-ceb50e0219cb	19	t	Red Bongo 300
dc3b536b-3718-4f2c-825e-6b033cb235c3	20	t	Red Bongo 500
95e6a201-1912-41a4-9448-4181697b13d9	21	t	Red Nakthai
9406c6a2-dc56-4360-984b-99b27a8ed971	22	t	Red Isaac-Kidd
189d32e4-f173-4a3a-adc6-d2544092c035	7	t	Rastra
3c64acd8-aa57-4e22-86ee-32ee8f96d629	8	t	Nasa
715a1b89-3e83-4745-b1b2-fcba7b044a31	9	t	Linea
66c95c2b-6647-4e42-be7e-911cd02e57ab	10	t	Raño
57d68d17-afe4-47b5-baf5-4e4791069319	11	t	Poteras
42237b16-470e-47a2-9a3b-dabe28af1a4f	12	t	Red de fondeo
1f5e5c39-7fd2-4fb1-8697-d5e0e9a4022b	13	t	Trampa centollera
fedc5975-2697-4b57-b26d-492a64ef6cc8	14	t	Red de arrastre de fondo con tangones
409e6fa4-6725-4b26-9346-214dd8d5d6fe	32	t	Currican
705c46ed-eb0c-4c68-80c0-3573c3fe6039	15	t	Red de arrastre de fondo en pareja
d7346683-814b-417b-a041-8ab5777fe5d8	80	t	Otros
eb472248-8d81-47a5-b4ed-082497d6de0d	0	t	Sin Especificar
7fe81801-8767-421e-9156-9cf10887dda6	90	t	No Identificado
\.


--
-- Data for Name: buque_trayectoria_puntos; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.buque_trayectoria_puntos (id, trayectoria_id, buque_id, "timestamp", lat, lon, velocidad, rumbo) FROM stdin;
\.


--
-- Data for Name: buque_trayectorias; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.buque_trayectorias (id, buque_id, origen, metadata) FROM stdin;
\.


--
-- Data for Name: buques; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.buques (id, nombre_buque, matricula, codigo_interno, id_tipo_flota, id_arte_habitual, id_pesqueria_habitual, dias_marea_estimada, eslora_m, potencia_hp, id_puerto_base, empresa_nombre, empresa_localidad, empresa_telefono, empresa_fax, empresa_correo_principal, empresa_correo_secundario, armador_nombre, armador_telefono, agencia_maritima_nombre, activo, fecha_alta, fecha_baja, observaciones) FROM stdin;
66098466-a6dd-4982-8347-335fe023e588	CONARPESA I	0200	1344	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	4167beb8-ce39-4fd3-8314-8b3487879d92	30	52.50	1482	105b0349-a9ed-49bf-9336-aad8d3867f0b	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
34a96d23-cf3a-4eea-b136-56b64fa5239c	API VII	03081	2777	bbebd1ff-edd5-48dd-925c-9735bb61b50d	acea052d-e5d1-4ced-b98c-2d01eb79122a	c1692b3c-2c33-4957-8bcb-208f45e4534b	60	72.20	0	105b0349-a9ed-49bf-9336-aad8d3867f0b	IBERCONSA  DE ARGENTINA  S.A.	Puerto Madryn		0280-445-4324	\N		\N	\N		t	\N	\N	\N
e7789831-81f7-4e16-bef3-fbdf0f6f1bc0	CAPITAN OCA BALDA	060F	\N	1e6f3be0-9af3-40cf-8306-e1358231f214	\N	\N	21	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	INIDEP	Mar del Plata		451-7442 ó 486-2586 int 162	\N		\N	\N		t	\N	\N	\N
a7a8af60-4087-4af9-a56d-4d78984dbcb0	CARMEN A	02045	1269	04d57c5c-390c-4334-bba9-d4635e1cb0c0	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	4	15.30	223	bea22adf-383f-4cc0-8c0b-bd514132fb77	FLOTA AMARILLA RAWSON	Rawson			\N		\N	\N		t	\N	\N	\N
783483ec-abbe-497c-b71b-5fd04ec3bee0	CEIBE DOUS	0336	1276	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	40.70	738	105b0349-a9ed-49bf-9336-aad8d3867f0b	IBERCONSA  DE ARGENTINA  S.A.	Puerto Madryn	4800274	0280-445-4324	\N	amalfitanoycia@hotmail.com	\N	\N	Agencia Maritima Almafitano	t	\N	\N	\N
363330e3-6ebe-44dd-a02f-3c83e2a733d1	CHANG BO GO I	06190	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	ARPEPA  M.C.I.S.A.	Ciudad Autónoma de Buenos Aires		011-4382-1605	\N		\N	\N		t	\N	\N	\N
788ac2e2-ee37-4ed9-907d-c6fcb20890be	CHATKA I	02893	0	04d57c5c-390c-4334-bba9-d4635e1cb0c0	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	16.73	195	105b0349-a9ed-49bf-9336-aad8d3867f0b	FOOD PARTNERS PATAGONIA S.A.	Puerto Madryn		0280-4458579 / 5225	\N		\N	\N		t	\N	\N	\N
6058618d-4253-4e70-934c-249efc0279c1	CHIARPESCA 56	01090	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	APOLO FISH  S.A.	Mar del Plata		489-4519 / 489-1133	\N		\N	\N		t	\N	\N	\N
4bb7ccc5-7326-48f1-a5fb-7bae226cb6df	CHIARPESCA 57	01029	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	CHIARPESCA  S.A.	Mar del Plata		489-1385	\N		\N	\N		t	\N	\N	\N
8ecc80ba-1dab-47a5-8b90-863bd1c60263	CHIARPESCA 902	02110	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	CHIARPESCA  S.A.	Mar del Plata		489-1385	\N		\N	\N		t	\N	\N	\N
56fc94f1-667a-499e-a358-47309d2355e4	CHIARPESCA 903	02109	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	CHIARPESCA  S.A.	Mar del Plata		489-1385	\N		\N	\N		t	\N	\N	\N
53da9d5e-3f42-40e4-8cfc-7c6ed3d2868c	CHOCO MARU 68	JA13	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	PESQUERA COMERCIAL  S.A.	Mar del Plata		489-3030	\N		\N	\N		t	\N	\N	\N
44f0a423-727c-4f76-99da-8dfa56aa3551	CHOKYU MARU Nº 18.	2584	1312	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	68.70	1777	11c64a29-e693-4bef-b734-8162f86cbbcc	BAHIA GRANDE  S.A.	Ciudad Autónoma de Buenos Aires		011-5272-0850 / 5254-1133	\N		\N	\N		t	\N	\N	\N
307fe712-ba5c-4ad3-a709-8bdde1a3b458	CINCOMAR 1	0439	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	CINCOMAR  S.A.	Ciudad Autónoma de Buenos Aires		011-4326-4991	\N		\N	\N		t	\N	\N	\N
01520e11-717f-4197-b851-f24d9fcdf9aa	CINCOMAR 5	02351	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	CINCOMAR  S.A.	Ciudad Autónoma de Buenos Aires		011-4326-4991	\N		\N	\N		t	\N	\N	\N
4feed10c-be1d-4f75-b736-875456bc8d05	CIUDAD DE HUELVA	01519	1324	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	27.45	426	105b0349-a9ed-49bf-9336-aad8d3867f0b	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
4accfb3f-bca2-4335-a38b-d37f383a7ca2	CIUDAD FELIZ	0910	2721	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	28.56	458	34aeab48-9c9b-4c06-8a45-3469f866cf88	CARAVON S.A.	Mar del Plata		489-9404	\N		\N	\N		t	\N	\N	\N
2e162db8-e039-4401-a816-52ba4d9588f3	CLAUDIA	02183	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	LUXMARINO  S.A.	Ciudad Autónoma de Buenos Aires		011-4342-2621	\N		\N	\N		t	\N	\N	\N
f0c98258-3f72-4b3d-8685-db05bc6d847f	CLAUDINA	02345	1331	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	53.58	937	11c64a29-e693-4bef-b734-8162f86cbbcc	ARMADORA  ACRUX  S.A.	Ciudad Autónoma de Buenos Aires		011-4312-6470	\N		\N	\N		t	\N	\N	\N
c8a262d2-bbd0-4620-af04-9ec6709a5a64	CODEPECA  I	0497	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	\N	\N	105b0349-a9ed-49bf-9336-aad8d3867f0b	HARENGUS  S.A.	Puerto Madryn		0280-445-0822	\N		\N	\N		t	\N	\N	\N
a8f3b87a-d0df-4ac5-a9fe-d2e87eb691d9	CODEPECA  II	0498	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	\N	\N	105b0349-a9ed-49bf-9336-aad8d3867f0b	HARENGUS  S.A.	Puerto Madryn		0280-445-0822	\N		\N	\N		t	\N	\N	\N
1552d8ac-53ec-4246-a410-f2c7bf19e516	CAROLINA P	0176	1272	bbebd1ff-edd5-48dd-925c-9735bb61b50d	acea052d-e5d1-4ced-b98c-2d01eb79122a	c1692b3c-2c33-4957-8bcb-208f45e4534b	60	71.60	1976	105b0349-a9ed-49bf-9336-aad8d3867f0b	ESTRELLA PATAGONICA S.A.	Puerto Madryn		0280-445-4407	\N		\N	\N		t	\N	\N	\N
7d23c84f-115a-4318-9e29-aa24a4809280	CHIYO MARU Nº 3	02987	2745	bbebd1ff-edd5-48dd-925c-9735bb61b50d	1f5e5c39-7fd2-4fb1-8697-d5e0e9a4022b	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	30	52.80	937	11c64a29-e693-4bef-b734-8162f86cbbcc	CRUSTACEOS DEL SUR  S.A.	Ciudad Autónoma de Buenos Aires		011-5218-4287	\N		\N	\N		t	\N	\N	\N
1f6cbb5f-d134-4ee3-9315-bf24ae2a7946	CENTAURO 2000	0482	1278	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	c1692b3c-2c33-4957-8bcb-208f45e4534b	30	35.50	1302	34aeab48-9c9b-4c06-8a45-3469f866cf88	PESQUERA VERAZ  S.A.	Mar del Plata		489-4624 / 489-0314 (astillero)	\N		\N	\N		t	\N	\N	\N
8e64df56-3b39-4321-8c31-98bff1ad28b3	CENTURION DEL ATLANTICO	0237	1280	bbebd1ff-edd5-48dd-925c-9735bb61b50d	acea052d-e5d1-4ced-b98c-2d01eb79122a	92d9acc2-3590-474f-a773-73e8af728e83	60	112.80	8111	11c64a29-e693-4bef-b734-8162f86cbbcc	ESTREMAR  S.A.	Ciudad Autónoma de Buenos Aires		011-6533-7853 / 4345-1102	\N		\N	\N		t	\N	\N	\N
c82bf74e-e7d0-45f9-a472-82d0127b3694	COALSA SEGUNDO	0790	1333	bbebd1ff-edd5-48dd-925c-9735bb61b50d	acea052d-e5d1-4ced-b98c-2d01eb79122a	c1692b3c-2c33-4957-8bcb-208f45e4534b	60	76.20	2960	11c64a29-e693-4bef-b734-8162f86cbbcc	YUKEN  S.A.	Ciudad Autónoma de Buenos Aires		011-5279-1302 / 5236-6069	\N		\N	\N		t	\N	\N	\N
e5550fb9-7d59-47d6-83d8-7658ff088523	CODEPECA  III	0506	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	\N	\N	105b0349-a9ed-49bf-9336-aad8d3867f0b	HARENGUS  S.A.	Puerto Madryn		0280-445-0822	\N		\N	\N		t	\N	\N	\N
f60954c7-2f50-4c26-9230-e5a5c47cf1b3	CODEPECA IV	01012	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	\N	\N	105b0349-a9ed-49bf-9336-aad8d3867f0b	PEREIRA  ARGENTINA  S.A.	Puerto Madryn		0280-445-7377 / 447-2249	\N		\N	\N		t	\N	\N	\N
c1102f81-4ae9-4743-9df6-57b197b7f705	COMANDANTE LUIS PIEDRABUENA	0767	1340	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	25.00	501	34aeab48-9c9b-4c06-8a45-3469f866cf88	COMANDANTE PIEDRABUENA  S.R.L.	Mar del Plata		489-9404	\N		\N	\N		t	\N	\N	\N
d35cb7f9-f2b8-4160-9a8e-476c8b6e1f1f	COMETA	0919	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	VICARP  S.A.	Mar del Plata		480-4378	\N		\N	\N		t	\N	\N	\N
d2bf4dea-5b8a-4158-943f-7422b5d19562	CONARA I	0201	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	\N	\N	105b0349-a9ed-49bf-9336-aad8d3867f0b	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
f276f930-15e3-4acd-be59-0c58471745d9	CORAJE	0645	1359	991d17ee-9376-401c-8883-c0409127d0af	\N	\N	0	28.28	426	34aeab48-9c9b-4c06-8a45-3469f866cf88	IBERCONSA  DE ARGENTINA  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
076b009b-8450-4e7e-b7a8-8095b2699572	CORAL  AZUL	06127	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	NOVAMAR  S.A.	Ciudad Autónoma de Buenos Aires		011-4345-6688	\N		\N	\N		t	\N	\N	\N
1daf8877-72ec-4fd8-9753-b728782261da	CORAL BLANCO	06137	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	NOVAMAR  S.A.	Ciudad Autónoma de Buenos Aires		011-4345-6688	\N		\N	\N		t	\N	\N	\N
d5f99cf0-5de6-4445-9d64-5d0e11a127ab	CORMORAN	01611	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	ANTONIO BARILLARI  S.A.	Mar del Plata		481-1173  / 489-0872	\N		\N	\N		t	\N	\N	\N
b10ac37d-e0f8-4d98-b3ff-492ede84f7b4	COSTAMAR	01549	\N	04d57c5c-390c-4334-bba9-d4635e1cb0c0	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	4	\N	\N	bea22adf-383f-4cc0-8c0b-bd514132fb77	INDUSTRIA  PESQUERA  PATAGONICA  S.A.	Trelew		0280-444-6577	\N		\N	\N		t	\N	\N	\N
a08ad5a1-988e-4782-a843-99d87389522a	CRISTO REDENTOR	01185	1374	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	31.00	642	f41ff939-bc00-4bbd-8ce8-c451922ba284	PESQUERA DESEADO  S.A.	Puerto Deseado		0297-487-0884 / 0327 / 2407	\N		\N	\N		t	\N	\N	\N
e8f508b9-2966-40a9-854e-d24a0b91533a	DASA 508	0499	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	PESQUERA  DONGAH  ARGENTINA  S.A.	Ciudad Autónoma de Buenos Aires		011-4815-5525	\N		\N	\N		t	\N	\N	\N
e38079ba-a943-4489-b795-2393d2d82d42	DASA 757	02200	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	PESQUERA  DONGAH  ARGENTINA  S.A.	Ciudad Autónoma de Buenos Aires		011-4815-5525	\N		\N	\N		t	\N	\N	\N
d0100242-f25c-4ae1-9ab1-c4cc9220a0d3	DEMOSTENES	0113	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	AGUA MARINA  S.A.	Ciudad Autónoma de Buenos Aires		011-4342-0605 / 5656 / 1709	\N		\N	\N		t	\N	\N	\N
6c2d041f-c99b-494b-a78f-2ef3ffcf80e1	DEPASUR  I	0330	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	105b0349-a9ed-49bf-9336-aad8d3867f0b	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
a1ac7e18-57ed-4184-9f72-a1018b3b40fe	HAMPON	01410	1673	04d57c5c-390c-4334-bba9-d4635e1cb0c0	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	10	18.99	497	34aeab48-9c9b-4c06-8a45-3469f866cf88	PESQUERA HAMPON S.R.L	Mar del Plata			\N		\N	\N		t	\N	\N	\N
8b2c914b-3d05-42b8-bcba-19acb5e8e174	HARENGUS	0510	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	60	\N	\N	105b0349-a9ed-49bf-9336-aad8d3867f0b	HARENGUS  S.A.	Puerto Madryn		0280-445-0822	\N		\N	\N		t	\N	\N	\N
bb3e36c2-f9f8-4bef-b47f-08a67ec51fa0	HOKO 31	05934	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	FARO DEL SUR TRADING  S.A.	Ciudad Autónoma de Buenos Aires		011-4555-4956	\N		\N	\N		t	\N	\N	\N
eaf01ef3-c6c7-4232-9cc2-df09320b6a99	HOPE N°7	06130	1690	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	50.60	1235	11c64a29-e693-4bef-b734-8162f86cbbcc	ALUNAMAR  S.A.	Ciudad Autónoma de Buenos Aires	4808331/4808332	011-4382-4194	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
d93be244-efd7-40b4-bf2b-795ab164bc4e	HSIANG LAI FU	80	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	EL MARISCO  S.A.	Mar del Plata		489-0384	\N		\N	\N		t	\N	\N	\N
71b6643e-b035-49b7-8ba7-7426a648137b	HUYU 906	03026	2747	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	65.92	1579	34aeab48-9c9b-4c06-8a45-3469f866cf88	CHENG I  S.A.	Mar del Plata		489-1385	\N		\N	\N		t	\N	\N	\N
d6e4303e-17a3-4080-9e26-e0b3241d6c6b	HUYU 907	03027	2748	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	72.17	1678	34aeab48-9c9b-4c06-8a45-3469f866cf88	CHENG I  S.A.	Mar del Plata	4800005	489-1385	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
af42532a-7508-453f-ac0f-bc5415b5e39e	HU YU 910	81	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	PEDRO MOSCUZZA e HIJOS  S.A.	Mar del Plata		489-7287	\N		\N	\N		t	\N	\N	\N
4bbece4b-ca80-4990-ac5b-2c8744afa610	HUAFENG 801	3013	2741	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	65.04	1973	34aeab48-9c9b-4c06-8a45-3469f866cf88	ARDAPEZ  S.A.	Mar del Plata		480-1561 / 480-1568 / 480-1549	\N		\N	\N		t	\N	\N	\N
10c60250-111c-463f-85cd-c3c27124d507	HUAFENG 802	3014	2751	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	65.04	1973	34aeab48-9c9b-4c06-8a45-3469f866cf88	ARDAPEZ  S.A.	Mar del Plata		480-1561 / 480-1568 / 480-1549	\N		\N	\N		t	\N	\N	\N
5947aa2a-f890-4d1e-85aa-839d6f38b293	HUA I 616	0392	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	ARMADORA  ACRUX  S.A.	Ciudad Autónoma de Buenos Aires		011-4312-6470	\N		\N	\N		t	\N	\N	\N
d9c41717-f710-4ee7-bd20-e050da07c446	HUAFENG 815	0554A	0	991d17ee-9376-401c-8883-c0409127d0af	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	25.28	419	34aeab48-9c9b-4c06-8a45-3469f866cf88	PESQUERA CHIARMAR S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
4f936a28-6bf8-4875-866e-318bdbd5cd6f	HUAFENG 820 (ex INFINITUS PEZ)	01472A	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	MELIMAR S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
c3d8ef08-a6a2-4a57-b01e-dcc788e768f8	HUAFENG 821 (ex INITIO PEZ)	01471A	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	MELIMAR S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
57cc20fc-6ecd-48b0-a173-8b7d7e675709	IARA	06207	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	PESQUERA MADRYN  S.A.	Ciudad Autónoma de Buenos Aires		011-4394-1452	\N		\N	\N		t	\N	\N	\N
f04c517d-a1c9-46ab-80eb-f73bf95d054f	IGLU I	01423	1713	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	32.75	660	34aeab48-9c9b-4c06-8a45-3469f866cf88	GIORNO  S.A.	Mar del Plata		410-0051 / 0057	\N		\N	\N		t	\N	\N	\N
9300414b-f340-4609-9833-a57e736c887d	ILLEX I	125	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	ILLEX  S.A.	Ciudad Autónoma de Buenos Aires	4808331/4808332	011-4393-6431	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
28367073-f657-41aa-9604-7adfa455458c	HUYU 961	TEMP-0003	0	bbebd1ff-edd5-48dd-925c-9735bb61b50d	\N	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	\N	65.70	0	\N					\N		\N	\N		t	\N	\N	\N
eebc3d53-9595-43b6-9c09-b24c1202fd35	FRANCO	01458	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	4167beb8-ce39-4fd3-8314-8b3487879d92	30	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	FRIGORIFICO DON LUIS  S.R.L.	Mar del Plata		489-4645	\N		\N	\N		t	\N	\N	\N
face2a5f-184c-41f8-b3a8-9beebc3635ee	GEMINIS	01421	1643	bbebd1ff-edd5-48dd-925c-9735bb61b50d	acea052d-e5d1-4ced-b98c-2d01eb79122a	c1692b3c-2c33-4957-8bcb-208f45e4534b	60	68.90	2141	34aeab48-9c9b-4c06-8a45-3469f866cf88	PESQUERA GEMINIS  S.A.	Mar del Plata		410-0051 / 7	\N		\N	\N		t	\N	\N	\N
a1b563e1-607a-4532-8d14-0ecc7ee1fe20	GRACIELA I	3994	2765	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	c1692b3c-2c33-4957-8bcb-208f45e4534b	30	39.94	0	34aeab48-9c9b-4c06-8a45-3469f866cf88	PEDRO MOSCUZZA e HIJOS  S.A.	Mar del Plata		489-7287	\N		\N	\N		t	\N	\N	\N
ba0b91e3-29d6-4028-acb8-c8256fa2aaf8	HUYU 962	03056	0	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	40	65.60	0	105b0349-a9ed-49bf-9336-aad8d3867f0b	ALTAMARE  S.A.	Puerto Madryn		0280-445-7377 / 447-2249	\N		\N	\N		t	\N	\N	\N
4a69d7f5-53b8-4ebf-820b-27f67de26c7c	INARI MARU N° 25	0261	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	f41ff939-bc00-4bbd-8ce8-c451922ba284	ARGENOVA  S.A.	Puerto Deseado		0297- 487-0550  (447-2818  Com. Riv )	\N		\N	\N		t	\N	\N	\N
08478cc8-a374-46f4-b5e0-b64b5c46ed66	INFINITUS PEZ	01472	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	GIORNO  S.A.	Mar del Plata		410-0051 / 0057	\N		\N	\N		t	\N	\N	\N
fb79753f-ddda-44ba-abe2-b9f22ac9e7d6	INITIO PEZ	01471	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	GIORNO  S.A.	Mar del Plata	4800005	410-0051 / 0057	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi	t	\N	\N	\N
578e85e3-dab1-4ce9-bb14-6f7c798a7317	JOLUMA	5403	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	ARDAPEZ  S.A.	Mar del Plata	4800005	480-1561 / 480-1568 / 480-1549	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
2649a320-9061-4e6d-b907-f7ad1554a472	JOSE LUIS ALVAREZ	0618	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	\N	\N	105b0349-a9ed-49bf-9336-aad8d3867f0b	PESQUERA SAN ISIDRO S.A.	Puerto Madryn		0280-447-2697	\N		\N	\N		t	\N	\N	\N
38aa57ab-e25e-4387-bd8c-b750f65d010f	JUAN ALVAREZ	0619	1755	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	36.60	1168	105b0349-a9ed-49bf-9336-aad8d3867f0b	PESQUERA SAN ISIDRO S.A.	Puerto Madryn		0280-447-2697	\N		\N	\N		t	\N	\N	\N
467ba951-bd03-4854-aac6-3c0727b71a91	JUAN PABLO II	02695	0	04d57c5c-390c-4334-bba9-d4635e1cb0c0	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	8	22.49	326	\N	ISLA DE LOS ESTADOS  S.A.	Vivoratá			\N		\N	\N		t	\N	\N	\N
3ed8104e-d850-4b37-9ac4-581cca785a3f	JUDITH I	0908	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	ANTONIO BARILLARI  S.A.	Mar del Plata		481-1173  / 489-0872	\N		\N	\N		t	\N	\N	\N
04ecd152-99b1-4e4a-8394-616032314ee9	MARIA  EUGENIA	01173	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	PEDRO MOSCUZZA e HIJOS  S.A.	Mar del Plata		489-7287	\N		\N	\N		t	\N	\N	\N
8fab37fc-023e-4fbc-9fa2-2f47f395bc8d	JUEVES SANTO	0667	1762	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	39.50	1244	11c64a29-e693-4bef-b734-8162f86cbbcc	NUVCONSA  S.A.	Ciudad Autónoma de Buenos Aires	4891553-154179360-154179860-154179062	011-4305-4706	\N	agenciasmiriglio@speedy.com.ar	\N	\N	Agencia Maritima Smiriglio	t	\N	\N	\N
21732f76-cac4-4ed8-a4dd-c8a06c1668fb	JUPITER II	0406	1769	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	27.90	791	34aeab48-9c9b-4c06-8a45-3469f866cf88	VENUS  PESQUERA S.R.L.	Mar del Plata	4800005	489-0186	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
b6a3bebe-8dea-45a7-aa1f-73e6c6eb0e42	KALEU KALEU	01963	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	KALEU KALEU  S.A.	Ciudad Autónoma de Buenos Aires	4800005	011-3220-2130  / 5093-1215	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi	t	\N	\N	\N
35b2b309-b992-49a4-844d-9702d0a691a0	KANTXOPE	01065	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	ANTONIO BARILLARI  S.A.	Mar del Plata		481-1173  / 489-0872	\N		\N	\N		t	\N	\N	\N
2eda1624-a1d2-4233-a309-4504ae7d80f3	KARINA	01462	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	FRIGORIFICO DON LUIS  S.R.L.	Mar del Plata		489-4645	\N		\N	\N		t	\N	\N	\N
f8b21dcd-1675-44e5-9f9c-9538907bb0cd	LAIA	06521	0	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	53.00	1185	11c64a29-e693-4bef-b734-8162f86cbbcc	PESQUERA MADRYN  S.A.	Ciudad Autónoma de Buenos Aires		011-4394-1452	\N		\N	\N		t	\N	\N	\N
e87e38bf-8166-4eb6-a23e-04e12cd0ad9a	LANZA SECA	01181	1852	991d17ee-9376-401c-8883-c0409127d0af	\N	\N	0	24.80	514	34aeab48-9c9b-4c06-8a45-3469f866cf88	LANZAMAR  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
3cff8010-86cf-4235-be60-81dfbdf9203a	LATINA  N° 8	0291	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	f41ff939-bc00-4bbd-8ce8-c451922ba284	ARGENOVA  S.A.	Puerto Deseado		0297- 487-0550  (447-2818  Com. Riv )	\N		\N	\N		t	\N	\N	\N
57cbf349-236a-4456-b04f-b3edc0a901f3	ANTARTIC II	0263	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	3b9fe535-63a2-4982-b7d4-71229ab250dc	\N	60	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	ESTREMAR  S.A.	Ciudad Autónoma de Buenos Aires		011-6533-7853 / 4345-1102	\N		\N	\N		t	\N	\N	\N
b06f99bb-c7ab-4fe2-9512-664c85f00f94	ANTARTIC III	0262	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	3b9fe535-63a2-4982-b7d4-71229ab250dc	\N	60	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	ESTREMAR  S.A.	Ciudad Autónoma de Buenos Aires		011-6533-7853 / 4345-1102	\N		\N	\N		t	\N	\N	\N
fcf8ba53-a4f6-4ba2-b0f9-7b8b4b08e04b	ANTARTIDA	0678	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	60	\N	\N	105b0349-a9ed-49bf-9336-aad8d3867f0b	IBERCONSA  DE ARGENTINA  S.A.	Puerto Madryn	4891227	0280-445-4324	\N	serviciosmaritimosmdq@gmail.com	\N	\N	Servicio Maritimo Integral	t	\N	\N	\N
719eb0f1-d0e5-4131-b3e7-dc30f1a7ea9b	ANTONINO	0877	1099	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	27.60	541	34aeab48-9c9b-4c06-8a45-3469f866cf88	AGLIPESCA  S.A.	Mar del Plata		480-2886	\N		\N	\N		t	\N	\N	\N
603c1c20-9b81-44a9-a414-a31724275500	ANTONIO ALVAREZ	01429	1100	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	36.60	1168	105b0349-a9ed-49bf-9336-aad8d3867f0b	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
3b348b9c-3d4e-449c-abf7-4de19cda2339	API II	0679	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	60	\N	\N	105b0349-a9ed-49bf-9336-aad8d3867f0b	IBERCONSA  DE ARGENTINA  S.A.	Puerto Madryn		0280-445-4324	\N		\N	\N		t	\N	\N	\N
5967b416-f988-4c0b-9cf0-d7bef41f7e41	API IV	0680	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	60	\N	\N	105b0349-a9ed-49bf-9336-aad8d3867f0b	IBERCONSA  DE ARGENTINA  S.A.	Puerto Madryn		0280-445-4324	\N		\N	\N		t	\N	\N	\N
f90590d9-8b70-4045-b68e-8e79e9317e2c	API VI	02812	2734	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	40	36.35	1201	105b0349-a9ed-49bf-9336-aad8d3867f0b	IBERCONSA  DE ARGENTINA  S.A.	Puerto Madryn		0280-445-4324	\N		\N	\N		t	\N	\N	\N
dada5ece-cf56-4aab-996b-f8151039567e	ARBUMASA X	6183	1114	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	35.30	1087	f41ff939-bc00-4bbd-8ce8-c451922ba284	ARBUMASA  S.A.	Puerto Deseado		0297-487-2807 / 444-5338 / 444-1201	\N		\N	\N		t	\N	\N	\N
343d01a4-d945-444f-be6f-265324c9413b	ARBUMASA  XVII	0216	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	\N	\N	f41ff939-bc00-4bbd-8ce8-c451922ba284	ARBUMASA  S.A.	Puerto Deseado		0297-487-2807 / 444-5338 / 444-1201	\N		\N	\N		t	\N	\N	\N
ca667a2a-0e37-471c-b798-6448c4841ac8	ARBUMASA XIV	0213	1116	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	36.40	1047	f41ff939-bc00-4bbd-8ce8-c451922ba284	ARBUMASA  S.A.	Puerto Deseado		0297-487-2807 / 444-5338 / 444-1201	\N		\N	\N		t	\N	\N	\N
78f9dfcb-3e2a-401e-b30c-ca0123adf957	ARBUMASA XVIII	0217	1121	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	36.40	870	f41ff939-bc00-4bbd-8ce8-c451922ba284	ARBUMASA  S.A.	Puerto Deseado	4893758	0297-487-2807 / 444-5338 / 444-1201	\N	miguel-visoso@hotmail.com	\N	\N	Agencia Maritima Solvox	t	\N	\N	\N
10d710cd-fd2f-4fd5-9730-d67e11b64329	ARBUMASA XXIX	02561	1126	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	65.60	1776	34aeab48-9c9b-4c06-8a45-3469f866cf88	BAL - FISH  S.A.	Mar del Plata		489-6522	\N		\N	\N		t	\N	\N	\N
47f407c7-9b97-48a2-a5d2-f1654d4067df	ARBUMASA XXVI	01958	1127	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	62.80	2403	f41ff939-bc00-4bbd-8ce8-c451922ba284	ARBUMASA  S.A.	Puerto Deseado	4893758	0297-487-2807 / 444-5338 / 444-1201	\N	miguel-visoso@hotmail.com	\N	\N	Agencia Maritima Solvox	t	\N	\N	\N
78c79d24-52cd-4c2a-b51c-6b3e238d2d72	ARCANGEL	79	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	CALME  S.A.	Mar del Plata		480-3545	\N		\N	\N		t	\N	\N	\N
58a214be-3946-4800-b7ba-fd90134ca406	ARESIT	02265	1134	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	36.26	1085	105b0349-a9ed-49bf-9336-aad8d3867f0b	HARENGUS  S.A.	Puerto Madryn	4808331/4808332	0280-445-0822	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
83fb4a61-ef1b-4b26-acf5-80204da01607	ACRUX	03086	0	991d17ee-9376-401c-8883-c0409127d0af	fedc5975-2697-4b57-b26d-492a64ef6cc8	4167beb8-ce39-4fd3-8314-8b3487879d92	30	28.00	0	34aeab48-9c9b-4c06-8a45-3469f866cf88	DE ANGELIS Y LOGGHE S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
03bf8fc0-df37-48c1-bf28-22df463a42ff	ARBUMASA XV	214	1118	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	4167beb8-ce39-4fd3-8314-8b3487879d92	30	36.40	870	\N	ARBUMASA  S.A.				\N		\N	\N		t	\N	\N	\N
d744066d-a334-4b07-93d0-c5017a925720	ARBUMASA XIX	06440	1117	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	4167beb8-ce39-4fd3-8314-8b3487879d92	30	36.40	870	f41ff939-bc00-4bbd-8ce8-c451922ba284	ARBUMASA  S.A.	Puerto Deseado		0297-487-2807 / 444-5338 / 444-1201	\N		\N	\N		t	\N	\N	\N
56ea7c96-54cb-4759-ba2a-74dd8a4fe0a2	ARGENTINO	0142	1157	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	c1692b3c-2c33-4957-8bcb-208f45e4534b	30	33.77	1001	34aeab48-9c9b-4c06-8a45-3469f866cf88	PESQUERA VERAZ  S.A.	Mar del Plata		489-4624 / 489-0314 (astillero)	\N		\N	\N		t	\N	\N	\N
a16cce31-d12d-458a-b212-6846185933bf	ATLANTIC EXPRESS	02936	2727	bbebd1ff-edd5-48dd-925c-9735bb61b50d	1f5e5c39-7fd2-4fb1-8697-d5e0e9a4022b	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	30	53.70	3426	34aeab48-9c9b-4c06-8a45-3469f866cf88	WANCHESE ARGENTINA  S.A.	Mar del Plata		489-1236	\N		\N	\N		t	\N	\N	\N
1362f018-3a09-4fca-a2fe-bdf2b160e79a	BOGAVANTE SEGUNDO	02994	2743	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	4167beb8-ce39-4fd3-8314-8b3487879d92	30	37.45	867	105b0349-a9ed-49bf-9336-aad8d3867f0b	IBERCONSA  DE ARGENTINA  S.A.	Puerto Madryn		0280-445-4324	\N		\N	\N		t	\N	\N	\N
7424ba5c-6626-44d8-af18-558efca30d71	BUENA PESCA	01475	2717	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	39.10	1479	34aeab48-9c9b-4c06-8a45-3469f866cf88	PEDRO MOSCUZZA e HIJOS  S.A.	Mar del Plata		489-7287	\N		\N	\N		t	\N	\N	\N
51123808-4b22-4ddb-b7e1-d61e7b872cdd	CABO BUEN TIEMPO	025	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	\N	\N	105b0349-a9ed-49bf-9336-aad8d3867f0b	ALPESCA  S.A.	Puerto Madryn		0280-447-4958 / 45-1069	\N		\N	\N		t	\N	\N	\N
fd5849de-36c8-48e3-9d64-f1d458863923	CABO BUENA ESPERANZA	02482	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	UNIVERSAL PESQUERA  SRL	Mar del Plata		489-0352	\N		\N	\N		t	\N	\N	\N
0fb32506-a039-451d-8f0a-ffffc51c17b7	CABO DE HORNOS	01537	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	MILANI Y PATANE  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
3661e054-04ab-44a7-b057-8871e82f7c08	CABO DOS BAHIAS	02483	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	\N	\N	105b0349-a9ed-49bf-9336-aad8d3867f0b	ALPESCA  S.A.	Puerto Madryn		0280-447-4958 / 45-1069	\N		\N	\N		t	\N	\N	\N
bab48bcb-1035-4496-9d03-d437f6bf4367	CABO SAN JUAN	023	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	\N	\N	105b0349-a9ed-49bf-9336-aad8d3867f0b	ALPESCA  S.A.	Puerto Madryn		0280-447-4958 / 45-1069	\N		\N	\N		t	\N	\N	\N
e291c810-7d32-44af-9175-a5641ac87a66	CABO SAN SEBASTIAN	022	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	\N	\N	105b0349-a9ed-49bf-9336-aad8d3867f0b	ALPESCA  S.A.	Puerto Madryn		0280-447-4958 / 45-1069	\N		\N	\N		t	\N	\N	\N
9520e7ad-38fc-40ce-9345-a14746f6e268	CABO TRES PUNTAS	01483	1242	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	31.43	721	34aeab48-9c9b-4c06-8a45-3469f866cf88	OSTRAMAR  S.A.	Mar del Plata		489-1959	\N		\N	\N		t	\N	\N	\N
5aae6bd6-5525-4be8-ad2a-da95f95abb1e	CABO VIRGENES	024	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	\N	\N	105b0349-a9ed-49bf-9336-aad8d3867f0b	ALPESCA  S.A.	Puerto Madryn		0280-447-4958 / 45-1069	\N		\N	\N		t	\N	\N	\N
7d5eaf2b-d459-4b0d-8638-b5038440637e	CALABRIA	0567	1245	04d57c5c-390c-4334-bba9-d4635e1cb0c0	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	4	19.63	266	105b0349-a9ed-49bf-9336-aad8d3867f0b	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
0973bfe6-9c8e-433a-8889-eb20161123ee	CALIZ	02809	0	04d57c5c-390c-4334-bba9-d4635e1cb0c0	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	4	20.20	545	bea22adf-383f-4cc0-8c0b-bd514132fb77	FLOTA AMARILLA RAWSON	Rawson			\N		\N	\N		t	\N	\N	\N
40ff9149-3f7a-4c1d-ae9f-f9f400e159c0	CALLEJA	06276	1249	04d57c5c-390c-4334-bba9-d4635e1cb0c0	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	10	21.83	503	34aeab48-9c9b-4c06-8a45-3469f866cf88	OTESA  S.A.	Mar del Plata		493-5606	\N		\N	\N		t	\N	\N	\N
862f4f75-bd38-41de-8d5d-7f895c8b48b3	CAMERIGE	01406	1252	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	27.90	652	34aeab48-9c9b-4c06-8a45-3469f866cf88	PESQUERA  MARGARITA  S.A.	Mar del Plata	4891553-154179360-154179860-154179062	489-4645   /   489-2946	\N	agenciasmiriglio@speedy.com.ar	\N	\N	Agencia Maritima SMIRIGLIO	t	\N	\N	\N
7af9977a-1553-40e5-ab45-66a54b3b9784	CANAL DE BEAGLE	0407	0	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	23.90	501	34aeab48-9c9b-4c06-8a45-3469f866cf88	CANAL DE BEAGLE  S.R.L.	Mar del Plata		480-4447	\N		\N	\N		t	\N	\N	\N
f22e38f3-53ae-443b-aaeb-42c7e7962bd1	CAPITAN CANEPA	059F	\N	1e6f3be0-9af3-40cf-8306-e1358231f214	\N	\N	28	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	INIDEP	Mar del Plata		451-7442 ó 486-2586 int 162	\N		\N	\N		t	\N	\N	\N
22511ee6-0e7f-4efa-9eb9-738365c224e0	CAPITAN GIACHINO	0151	1260	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	38.42	1062	34aeab48-9c9b-4c06-8a45-3469f866cf88	KALARI S.A.	Mar del Plata		489-1959	\N		\N	\N		t	\N	\N	\N
c720b08b-6e20-469e-b1df-ad18511028d1	PALOMA V	64	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	3b9fe535-63a2-4982-b7d4-71229ab250dc	\N	60	\N	\N	\N					\N		\N	\N		t	\N	\N	\N
cad32064-7964-4a41-9f30-a1998363ab99	ANITA	3	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	acea052d-e5d1-4ced-b98c-2d01eb79122a	c1692b3c-2c33-4957-8bcb-208f45e4534b	\N	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	SOLIMENO	Mar del Plata			\N		\N	\N		t	\N	\N	\N
07acb95b-f5c8-4ed4-b6d7-d69ae4ba57ad	API V	02781	2711	bbebd1ff-edd5-48dd-925c-9735bb61b50d	acea052d-e5d1-4ced-b98c-2d01eb79122a	c1692b3c-2c33-4957-8bcb-208f45e4534b	60	77.40	2960	105b0349-a9ed-49bf-9336-aad8d3867f0b	IBERCONSA  DE ARGENTINA  S.A.	Puerto Madryn		0280-445-4324	\N		\N	\N		t	\N	\N	\N
4da8857e-915b-4cd9-96d6-4148a78d664c	Dr. EDUARDO L. HOLMBERG	061F	\N	1e6f3be0-9af3-40cf-8306-e1358231f214	\N	\N	24	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	INIDEP	Mar del Plata		451-7442 ó 486-2586 int 162	\N		\N	\N		t	\N	\N	\N
3e1e8d2a-eb33-4277-a59f-47d0b61fd8a3	ARBUMASA XVI	0215	1119	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	4167beb8-ce39-4fd3-8314-8b3487879d92	30	36.40	1047	f41ff939-bc00-4bbd-8ce8-c451922ba284	ARBUMASA  S.A.	Puerto Deseado		0297-487-2807 / 444-5338 / 444-1201	\N		\N	\N		t	\N	\N	\N
3f5729dd-4d20-4e27-a7f1-ef46d30e973d	ANDRES JORGE	1065	2760	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	c1692b3c-2c33-4957-8bcb-208f45e4534b	30	50.10	1102	34aeab48-9c9b-4c06-8a45-3469f866cf88	MARONTI  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
15d3efd3-e46e-4a45-9a33-d2623e1b3bf0	ARGENOVA I	02180	1137	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	35.00	655	f41ff939-bc00-4bbd-8ce8-c451922ba284	ARGENOVA  S.A.	Puerto Deseado	4808331/4808332	0297- 487-0550  (447-2818  Com. Riv )	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
3cfb8bb0-4cd7-4870-a38b-257a9d46f9e8	ARGENOVA IV	02157	1140	bbebd1ff-edd5-48dd-925c-9735bb61b50d	\N	\N	0	36.26	675	f41ff939-bc00-4bbd-8ce8-c451922ba284	MAR DE LAS PALMAS  S.A.	Puerto Deseado	4808331/4808332	0297-487-2112	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
37d9084a-1678-4c14-98c6-4e0e95404158	ARGENOVA X	02329	1146	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	32.50	550	f41ff939-bc00-4bbd-8ce8-c451922ba284	ARGENOVA  S.A.	Puerto Deseado	4808331/4808332	0297- 487-0550  (447-2818  Com. Riv )	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
f9937a01-2466-4204-83be-d7e1bd958ef8	ARGENOVA XI	02199	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	3b9fe535-63a2-4982-b7d4-71229ab250dc	\N	60	\N	\N	f41ff939-bc00-4bbd-8ce8-c451922ba284	ARGENOVA  S.A.	Puerto Deseado	4808331/4808332	0297- 487-0550  (447-2818  Com. Riv )	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
f825612e-17ba-46cb-a573-b6951867ade3	ARGENOVA XXIII	02713	2707	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	37.19	678	f41ff939-bc00-4bbd-8ce8-c451922ba284	ARGENOVA  S.A.	Puerto Deseado	4808331/4808332	0297- 487-0550  (447-2818  Com. Riv )	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
73bf08ce-9b6f-49c6-9bc6-1d813ec65612	ARGENOVA XXVI	02849	2739	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	37.15	1086	f41ff939-bc00-4bbd-8ce8-c451922ba284	ARGENOVA  S.A.	Puerto Deseado	4808331/4808332	0297- 487-0550  (447-2818  Com. Riv )	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
f6c23971-fea0-4edb-9f23-f6dc8d1db49f	ARGENOVA III	02156	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	\N	\N	f41ff939-bc00-4bbd-8ce8-c451922ba284	ARGENOVA  S.A.	Puerto Deseado		0297- 487-0550  (447-2818  Com. Riv )	\N		\N	\N		t	\N	\N	\N
8faaea19-772e-4c92-b384-2e316179c3f3	PAOLA  S	0557	\N	991d17ee-9376-401c-8883-c0409127d0af	\N	\N	30	\N	\N	\N					\N		\N	\N		t	\N	\N	\N
1efe2272-764f-43ca-a530-f385cedd031d	ARGENOVA IX	02328	1141	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	32.50	550	f41ff939-bc00-4bbd-8ce8-c451922ba284	ARGENOVA  S.A.	Puerto Deseado	4808331/4808332	0297- 487-0550  (447-2818  Com. Riv )	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
9fab8c3e-616e-4557-a11a-888a9919a2e5	ARGENOVA XII	0199	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	3b9fe535-63a2-4982-b7d4-71229ab250dc	\N	60	\N	\N	f41ff939-bc00-4bbd-8ce8-c451922ba284	ARGENOVA  S.A.	Puerto Deseado	4808331/4808332	0297- 487-0550  (447-2818  Com. Riv )	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
c163d5e5-5d60-4da4-9b33-f0b9e16ceccd	ARGENOVA XIV	0197	1149	bbebd1ff-edd5-48dd-925c-9735bb61b50d	3b9fe535-63a2-4982-b7d4-71229ab250dc	\N	60	52.30	1352	f41ff939-bc00-4bbd-8ce8-c451922ba284	ARGENOVA  S.A.	Puerto Deseado	4808331/4808332	0297- 487-0550  (447-2818  Com. Riv )	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
f85c4fc2-bf5d-4c58-94c4-1b9bdc6649c5	ARGENOVA XV	0198	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	3b9fe535-63a2-4982-b7d4-71229ab250dc	\N	60	\N	\N	f41ff939-bc00-4bbd-8ce8-c451922ba284	ARGENOVA  S.A.	Puerto Deseado	4800274	0297- 487-0550  (447-2818  Com. Riv )	\N	amalfitanoycia@hotmail.com	\N	\N	Agencia Maritima Almafitano	t	\N	\N	\N
6ba941e5-6de0-41c5-b1de-2a45d42e534c	ARKOFISH	0236	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	105b0349-a9ed-49bf-9336-aad8d3867f0b	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
f109f4ad-02e1-4b66-bd7c-61d6c9c8ca5c	ARKOFISH I	6004	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	105b0349-a9ed-49bf-9336-aad8d3867f0b	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
fc45cb2f-6a50-4eb8-a70c-42ed0cae19ae	ASUDEPES II	6363	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	ASUDEPES  S.A.	Ciudad Autónoma de Buenos Aires		011-4383-9756	\N		\N	\N		t	\N	\N	\N
96da2dba-ee2f-404e-a032-9c4bede0fc8c	ASUDEPES III	6062	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	ASUDEPES  S.A.	Ciudad Autónoma de Buenos Aires		011-4383-9756	\N		\N	\N		t	\N	\N	\N
7f9ea3c8-1751-4a92-baa8-99cd0beb6d1e	ATLANTIC SURF I	0350	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	40	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	GLACIAR PESQUERA  S.A.	Mar del Plata	4890960	492-2216	\N	agencia@maritimavidal.com.ar	\N	\N	Agencia Maritima Vidal	t	\N	\N	\N
639bb7e1-7b76-4fbe-aeb5-58e4b0726d2e	BAHIA DESVELOS	0665	1194	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	37.05	791	11c64a29-e693-4bef-b734-8162f86cbbcc	PESQUERA SANTA CRUZ  S.A.	Ciudad Autónoma de Buenos Aires		011-4305-4706	\N		\N	\N		t	\N	\N	\N
47c70ae2-4523-4db5-b475-41c8469eabdc	BEAGLE I	6052	1207	bbebd1ff-edd5-48dd-925c-9735bb61b50d	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	60	59.90	2369	11c64a29-e693-4bef-b734-8162f86cbbcc	YUKEN  S.A.	Ciudad Autónoma de Buenos Aires	4891553-154179360-154179860-154179062	011-5279-1302 / 5236-6069	\N	agenciasmiriglio@speedy.com.ar	\N	\N	Agencia Maritima Smiriglio	t	\N	\N	\N
8229e32a-4aa8-4aaf-bad4-799c00c9f968	BELVEDERE	01398	1210	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	26.50	624	34aeab48-9c9b-4c06-8a45-3469f866cf88	PRINMAR  S.A. Buque Motor Belvedere	Mar del Plata		480-0883	\N		\N	\N		t	\N	\N	\N
718a77d2-3a1a-4d20-9096-eba352617f86	BONFIGLIO	01234	\N	04d57c5c-390c-4334-bba9-d4635e1cb0c0	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	10	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	COSTA BRAVA  S.A.	Mar del Plata		489-7538	\N		\N	\N		t	\N	\N	\N
baec3aa4-13af-4331-823a-f97b94a04deb	BORRASCA	01095	1218	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	39.16	1083	34aeab48-9c9b-4c06-8a45-3469f866cf88	LUIS SOLIMENO e HIJOS  S.A.	Mar del Plata		489-3030	\N		\N	\N		t	\N	\N	\N
08da59fb-fa52-49da-b7ec-6e276d53b841	AURORA	02581	1183	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	40	67.55	1776	11c64a29-e693-4bef-b734-8162f86cbbcc	KALEU KALEU  S.A.	Ciudad Autónoma de Buenos Aires		011-3220-2130  / 5093-1215	\N		\N	\N		t	\N	\N	\N
0b05adc0-bf86-40b7-a0f0-21db3b022436	ARGENOVA XXV	028011	2740	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	4167beb8-ce39-4fd3-8314-8b3487879d92	30	39.70	859	f41ff939-bc00-4bbd-8ce8-c451922ba284	ARGENOVA  S.A.	Puerto Deseado	4808331/4808332	0297- 487-0550  (447-2818  Com. Riv )	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
df12f2d3-a96c-42b0-bb93-dfe21c48e3cf	ARGENOVA XXIV	02752	2731	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	4167beb8-ce39-4fd3-8314-8b3487879d92	30	38.80	675	f41ff939-bc00-4bbd-8ce8-c451922ba284	ARGENOVA  S.A.	Puerto Deseado	4808331/4808332	0297- 487-0550  (447-2818  Com. Riv )	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
0a7aed5b-7fc3-4b95-aeea-754431932603	ARGENOVA II	02177	1138	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	4167beb8-ce39-4fd3-8314-8b3487879d92	30	38.50	1168	f41ff939-bc00-4bbd-8ce8-c451922ba284	ARGENOVA  S.A.	Puerto Deseado	4808331/4808332	0297- 487-0550  (447-2818  Com. Riv )	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
0ef3fcf7-ae31-4330-864c-347c4617e5e8	ARRUFO	0540	1165	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	4167beb8-ce39-4fd3-8314-8b3487879d92	30	39.16	1102	34aeab48-9c9b-4c06-8a45-3469f866cf88	LUIS SOLIMENO e HIJOS  S.A.	Mar del Plata		489-3030	\N		\N	\N		t	\N	\N	\N
7a5c52c3-f87e-4405-a08e-f3b2ae274460	ATREVIDO	0145	1180	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	c1692b3c-2c33-4957-8bcb-208f45e4534b	30	32.50	901	34aeab48-9c9b-4c06-8a45-3469f866cf88	PESQUERA VERAZ  S.A.	Mar del Plata	4800005	489-4624 / 489-0314 (astillero)	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
e5248c3a-7a81-49fa-a6a2-466a1cdc60df	BOUCIÑA	01637	1221	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	4167beb8-ce39-4fd3-8314-8b3487879d92	30	0.00	0	34aeab48-9c9b-4c06-8a45-3469f866cf88	CALME  S.A.	Mar del Plata	4800005	480-3545	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
79b204c7-5ff4-42e9-a7de-de8ea34d8555	ARGENOVA XXII	02714	2713	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	4167beb8-ce39-4fd3-8314-8b3487879d92	40	37.70	663	f41ff939-bc00-4bbd-8ce8-c451922ba284	ARGENOVA  S.A.	Puerto Deseado	4808331/4808332	0297- 487-0550  (447-2818  Com. Riv )	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
6b91cf15-15c5-4548-a9e3-104dceb65a6b	7 de Diciembre	TEMP-0001	1013	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	27.20	521	34aeab48-9c9b-4c06-8a45-3469f866cf88		Mar del Plata	4895032		\N	operacionesconsultoramaritima@gmail.com	\N	\N	Consultora Maritima	t	\N	\N	\N
7d8026d0-9add-4472-a8c5-f57d13c4db0c	ALDEBARAN	01741	1038	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	26.42	426	34aeab48-9c9b-4c06-8a45-3469f866cf88	PESQUERA SAN ROQUE	Mar del Plata		480-0573	\N		\N	\N		t	\N	\N	\N
2f549778-30fe-4489-8358-5102e9188bec	ALTALENA	0181	1051	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	55.80	1350	34aeab48-9c9b-4c06-8a45-3469f866cf88	MARONTI  S.A.	Mar del Plata	4800005		\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi	t	\N	\N	\N
92841747-cb76-4be9-a489-87a264d732ae	ALVAREZ ENTRENA I	02454	1055	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	39.43	988	105b0349-a9ed-49bf-9336-aad8d3867f0b	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
b97c8b73-de15-4a34-a786-8d75cce848e8	ALVAREZ ENTRENA II	02465	1056	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	39.50	988	105b0349-a9ed-49bf-9336-aad8d3867f0b	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
eb2ca33e-a33f-49a4-84e0-7d5b77ddaa2f	ALVAREZ ENTRENA III	02379	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	\N	\N	105b0349-a9ed-49bf-9336-aad8d3867f0b	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
a69891b1-b1e6-434b-a28b-b08d5c9ae148	BAFFETTA	02635	0	04d57c5c-390c-4334-bba9-d4635e1cb0c0	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	19.45	295	105b0349-a9ed-49bf-9336-aad8d3867f0b	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
8a186007-01dd-4b03-9288-09cfa051ee2a	ALVAREZ ENTRENA VI	01	2774	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	30.50	1033	105b0349-a9ed-49bf-9336-aad8d3867f0b	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
b4a25742-4678-4c44-80c1-816286bda5ef	AMBITION	01324	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	PESQUERA TRES MARIAS  S.A.	Mar del Plata		480-0336	\N		\N	\N		t	\N	\N	\N
2be15b59-6090-4cdb-8c35-9949cfce4a7f	ANA III	278	1069	04d57c5c-390c-4334-bba9-d4635e1cb0c0	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	19.95	443	105b0349-a9ed-49bf-9336-aad8d3867f0b	POSEIDON  S.A.	Puerto Madryn		0280-445-7786	\N		\N	\N		t	\N	\N	\N
4e307e7b-e807-416f-9eeb-e45a92cea4c9	ANABELLA  M	0175	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	60	\N	\N	105b0349-a9ed-49bf-9336-aad8d3867f0b	PESCAPUERTA ARGENTINA  S.A.	Puerto Madryn		0280-445-4407	\N		\N	\N		t	\N	\N	\N
54ad51f8-1cb9-4c43-a194-b541f45e442a	ANGELUS	01953	1087	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	52.60	1337	11c64a29-e693-4bef-b734-8162f86cbbcc	PESQUERA CRUZ DEL SUR  S.A.	Ciudad Autónoma de Buenos Aires		011-4784-1760	\N		\N	\N		t	\N	\N	\N
bd1575b6-e2ff-4f4f-8f74-88b7e0f0d789	ANITA ALVAREZ	02138	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	\N	\N	105b0349-a9ed-49bf-9336-aad8d3867f0b	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
c08f87a4-7d05-4410-9742-9f2016366f8b	ANTARTIC  I	0232	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	3b9fe535-63a2-4982-b7d4-71229ab250dc	\N	60	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	ESTREMAR  S.A.	Ciudad Autónoma de Buenos Aires		011-6533-7853 / 4345-1102	\N		\N	\N		t	\N	\N	\N
45a35f87-38a5-4b3f-9bb0-5e148467217a	DEPEMAS 51	0239	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	DEPEMAS  S.A.	Ciudad Autónoma de Buenos Aires		011-4372-7909  /  4382-5382	\N		\N	\N		t	\N	\N	\N
d6e59f74-5c64-40cc-a52e-8e3d458c621b	DEPEMAS 81	0281	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	PESQUERA ORION  S.A.	Ciudad Autónoma de Buenos Aires		011-4343-9327	\N		\N	\N		t	\N	\N	\N
b7878859-bcba-4bc9-bb14-bbf441557755	DESAFIO	0177	1398	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	29.56	850	34aeab48-9c9b-4c06-8a45-3469f866cf88	PESQUERA VERAZ  S.A.	Mar del Plata		489-4624 / 489-0314 (astillero)	\N		\N	\N		t	\N	\N	\N
5d4e5fc5-cf2a-4ab5-96d1-63326350d730	DESEADO	01598	1400	04d57c5c-390c-4334-bba9-d4635e1cb0c0	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	4	19.00	301	bea22adf-383f-4cc0-8c0b-bd514132fb77	FLOTA AMARILLA RAWSON	Rawson			\N		\N	\N		t	\N	\N	\N
27331717-f9bd-4c5c-ab0a-6be7cd40993d	DIEGO PRIMERO	01725	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	PESQUERA DIEGO PRIMERO  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
f6503904-0323-4a3c-9d20-8cf8890d0845	DON  NATALIO	01183	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	14 DE JULIO  S.A.	Mar del Plata		480-3545	\N		\N	\N		t	\N	\N	\N
d2674585-33ae-4905-a22d-42bc8fb6e76e	DON AGUSTIN	0968	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	PESQUERA  MARGARITA  S.A.	Mar del Plata		489-4645   /   489-2946	\N		\N	\N		t	\N	\N	\N
2fabb2fc-b0d2-4fe2-8a36-2030d476b63e	DON ANTONIO	0029	1411	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	27.80	549	34aeab48-9c9b-4c06-8a45-3469f866cf88	GIORNO  S.A.	Mar del Plata		410-0051 / 0057	\N		\N	\N		t	\N	\N	\N
2c81f698-d737-45d3-abf7-d70c5f994499	DON CARMELO	01320	1416	04d57c5c-390c-4334-bba9-d4635e1cb0c0	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	8	19.04	424	34aeab48-9c9b-4c06-8a45-3469f866cf88	MARFE  S.A.	Mar del Plata	4800005	480-0102	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
9043effb-7dea-4502-b49c-0a61d3a31957	DON CAYETANO	0579	1417	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	47.10	1503	34aeab48-9c9b-4c06-8a45-3469f866cf88	PEDRO MOSCUZZA e HIJOS  S.A.	Mar del Plata	4890960	489-7287	\N	agencia@maritimavidal.com.ar	\N	\N	Agencia Maritima Vidal	t	\N	\N	\N
633b6aaa-910d-4c43-8de8-643592fc7f26	DON FRANCISCO I	2562	1428	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	66.55	1776	34aeab48-9c9b-4c06-8a45-3469f866cf88	EL MARISCO  S.A.	Mar del Plata	480-7779 - HERNAN	489-0384	\N	agenciasenoransmdp@yahoo.com	\N	\N	Agencia Maritima SEÑORANS	t	\N	\N	\N
ada0292c-c3cc-4dd6-94bb-98fd98c52928	DON GIULIANO	02025	1431	04d57c5c-390c-4334-bba9-d4635e1cb0c0	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	4	17.10	220	bea22adf-383f-4cc0-8c0b-bd514132fb77	FLOTA AMARILLA RAWSON	Rawson			\N		\N	\N		t	\N	\N	\N
38459045-c273-4711-a592-7e0c8d9bae23	DON JOSE	00892	1434	04d57c5c-390c-4334-bba9-d4635e1cb0c0	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	8	16.49	269	34aeab48-9c9b-4c06-8a45-3469f866cf88	VENTO DI TERRA  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
590c2f26-2a9b-4589-ab55-3b8c356c88c5	DON JOSE DI BONA	02241	1435	04d57c5c-390c-4334-bba9-d4635e1cb0c0	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	4	19.85	301	bea22adf-383f-4cc0-8c0b-bd514132fb77	PROA  AL SUR  S.R.L.	Rawson			\N		\N	\N		t	\N	\N	\N
e3aa489c-84b8-4324-aa08-0f19f35238ed	DON JUAN	01397	1437	04d57c5c-390c-4334-bba9-d4635e1cb0c0	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	27.00	425	\N	PESQUERA DON JUAN  S.A.				\N		\N	\N		t	\N	\N	\N
2821573e-103d-4bbb-926d-ec4f5e71b5a3	DON JUAN D´AMBRA	5174	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	PESCA ANGELA  S.A.	Mar del Plata		626-2236 /37	\N		\N	\N		t	\N	\N	\N
6e004ad2-fc82-4b26-aa81-7a0132ea0159	DON LUCIANO	069	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	TATURIELLO  S.A.	Mar del Plata		489-3833	\N		\N	\N		t	\N	\N	\N
46c27bad-1d14-4b95-990b-d4ec9dad6c78	DON MIGUEL 1°	0748	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	PESQUERA EL NAZARENO	Mar del Plata	4895032 Emanuel	489-9414 (of. Pers. Emb.)	\N	operacionesconsultoramaritima@gmail.com	\N	\N	Consultora Maritima Merlini	t	\N	\N	\N
a7e98086-55d6-49bb-80e8-a75acec98e92	DON NICOLA	0893	1450	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	28.14	856	34aeab48-9c9b-4c06-8a45-3469f866cf88	PEZ ESPADA  S.A.	Mar del Plata		480-0846	\N		\N	\N		t	\N	\N	\N
638e86fa-0885-4363-8ab1-6e7a773dbbdf	DON OSCAR	02184	\N	04d57c5c-390c-4334-bba9-d4635e1cb0c0	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	4	\N	\N	bea22adf-383f-4cc0-8c0b-bd514132fb77	FLOTA AMARILLA RAWSON	Rawson	4800005		\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
23b49a79-006b-4fbb-9555-4aca5585029f	DON RAIMUNDO	01431	1463	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	10	25.60	624	34aeab48-9c9b-4c06-8a45-3469f866cf88	DON RAIMUNDO S.R.L.	Mar del Plata		489-3780	\N		\N	\N		t	\N	\N	\N
7520156b-6cda-40e7-a4c4-69d870022e74	DON JUAN ALVAREZ	3300	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	acea052d-e5d1-4ced-b98c-2d01eb79122a	4167beb8-ce39-4fd3-8314-8b3487879d92	\N	\N	\N	\N	CONARPESA  S.A.				\N		\N	\N		t	\N	\N	\N
dd7184b3-9ccd-4515-a117-02184abda5ff	DESTINY	3209	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	4167beb8-ce39-4fd3-8314-8b3487879d92	30	\N	\N	\N	WANCHESE ARGENTINA  S.A.				\N		\N	\N		t	\N	\N	\N
887ff179-0c25-4956-9165-09125f9152f0	DON GAETANO	071	1430	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	e16a6ea7-08d9-4891-b3ab-3ac866d647c2	30	32.10	889	34aeab48-9c9b-4c06-8a45-3469f866cf88	LINEAERRE  S.A.	Mar del Plata		480-0312	\N		\N	\N		t	\N	\N	\N
0c1d3746-1b32-4d1e-a979-6d69fe31a28e	DON ROMEO ERSINI	0972	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	PESQUERA  MARGARITA  S.A.	Mar del Plata	4891553-154179360-154179860-154179062	489-4645   /   489-2946	\N	agenciasmiriglio@speedy.com.ar	\N	\N	Agencia Smiriglio	t	\N	\N	\N
6cca8e88-74a5-41a5-a160-f90db30eb2df	DON TOMASSO	02310	1468	04d57c5c-390c-4334-bba9-d4635e1cb0c0	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	4	17.00	356	bea22adf-383f-4cc0-8c0b-bd514132fb77	FLOTA AMARILLA RAWSON	Rawson			\N		\N	\N		t	\N	\N	\N
575aa9ae-0910-48fb-9576-dee870b0e50b	DON TURI	01540	1470	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	28.62	839	34aeab48-9c9b-4c06-8a45-3469f866cf88	DON TURI  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
9e80ad53-de6a-45ff-8bc4-5d92cac44639	DON VICENTE VUOSO	0539	1474	04d57c5c-390c-4334-bba9-d4635e1cb0c0	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	20.69	537	34aeab48-9c9b-4c06-8a45-3469f866cf88	VUOSO HNOS. S.R.L.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
3a35e0d6-53a6-4ee1-9e9f-aa5223fe1d3f	DOÑA ALFIA	0512	1483	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	20.70	426	34aeab48-9c9b-4c06-8a45-3469f866cf88	ANTONIO BARILLARI  S.A.	Mar del Plata		481-1173  / 489-0872	\N		\N	\N		t	\N	\N	\N
755be1df-61f5-430f-bb86-0fc017601ca8	EL MALO I	02350	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	4	\N	\N	bea22adf-383f-4cc0-8c0b-bd514132fb77	NOGALES NOGALES  S. De HECHO	Rawson	4890960		\N	agencia@maritimavidal.com.ar	\N	\N	Agencia Maritima Vidal	t	\N	\N	\N
f6fa9b93-7a4e-4bec-b34b-3882cbfc8121	EL MARISCO I	0912	1516	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	27.22	426	34aeab48-9c9b-4c06-8a45-3469f866cf88	EL MARISCO  S.A.	Mar del Plata	4890960	489-0384	\N	agencia@maritimavidal.com.ar	\N	\N	Agencia Maritima Vidal	t	\N	\N	\N
d7a60d43-2d92-49d8-a89c-6213e9fb3e17	EL SANTO	05970	\N	04d57c5c-390c-4334-bba9-d4635e1cb0c0	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	0	\N	\N	f41ff939-bc00-4bbd-8ce8-c451922ba284	VUOGAFE  S.A.	Puerto Deseado		0297-155-940853	\N		\N	\N		t	\N	\N	\N
61cc10ce-31ee-4431-9816-a8f1e5751c92	EMILIA MARIA	01390	1543	04d57c5c-390c-4334-bba9-d4635e1cb0c0	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	10	22.60	521	34aeab48-9c9b-4c06-8a45-3469f866cf88	COSTA BRAVA  S.A.	Mar del Plata		489-7538	\N		\N	\N		t	\N	\N	\N
1b833491-b0b7-4690-91c3-e23791ce24b5	EMPESUR II	01439	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	EMPESUR  S.A.	Ciudad Autónoma de Buenos Aires		011-4312-0123	\N		\N	\N		t	\N	\N	\N
d55ad3ed-893c-46c5-8ab3-b2a0b5b93ef8	EMPESUR III	01438	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	EMPESUR  S.A.	Ciudad Autónoma de Buenos Aires		011-4312-0123	\N		\N	\N		t	\N	\N	\N
856ab8b7-79fd-42b6-b3e3-71f263ffb374	EMPESUR V	02650	2705	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	30.52	1369	11c64a29-e693-4bef-b734-8162f86cbbcc	EMPESUR  S.A.	Ciudad Autónoma de Buenos Aires		011-4312-0123	\N		\N	\N		t	\N	\N	\N
8235c945-f47f-4de2-9a8a-45d6f21ef7bf	EMPESUR VI	02983	2749	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	35.03	1289	11c64a29-e693-4bef-b734-8162f86cbbcc	EMPESUR  S.A.	Ciudad Autónoma de Buenos Aires		011-4312-0123	\N		\N	\N		t	\N	\N	\N
d5d6734f-6104-4cca-acdb-e222f8e0978c	EMPESUR VII	03045	2754	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	35.03	1290	11c64a29-e693-4bef-b734-8162f86cbbcc	EMPESUR  S.A.	Ciudad Autónoma de Buenos Aires		011-4312-0123	\N		\N	\N		t	\N	\N	\N
0cec0156-a152-41af-93f9-f2d9f6fed388	El marisco s.a	02070	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	\N	\N	105b0349-a9ed-49bf-9336-aad8d3867f0b	FISHING WORLD  S.A.	Puerto Madryn	4800005	0280-445-6533	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
afab2909-b6df-43d5-b3aa-98a436e7daca	ENTRENA UNO	02069	1551	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	33.10	839	11c64a29-e693-4bef-b734-8162f86cbbcc	FOOD ARTS  S.A.	Ciudad Autónoma de Buenos Aires		POR MAILlazuaje@foodarts.com.ar	\N		\N	\N		t	\N	\N	\N
92d19249-4a08-48ee-b386-4f01a59cc433	ERIN BRUCE	0537	1553	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	53.60	2252	34aeab48-9c9b-4c06-8a45-3469f866cf88	WANCHESE ARGENTINA  S.A.	Mar del Plata		489-1236	\N		\N	\N		t	\N	\N	\N
d2172afb-0429-4921-9f09-5bf34cf3af52	ESAMAR N° 4	0467	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	ESAMAR  S.A.	Ciudad Autónoma de Buenos Aires		011-4393-8431	\N		\N	\N		t	\N	\N	\N
208443d8-9530-4d4d-a6db-08302d8c9041	ESPADARTE	02048	1558	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	68.20	1529	f41ff939-bc00-4bbd-8ce8-c451922ba284	PESQUERA DESEADO  S.A.	Puerto Deseado		0297-487-0884 / 0327 / 2407	\N		\N	\N		t	\N	\N	\N
95754cf7-1f8a-4257-8dbf-9e915f4348c9	ESPERANZA 909	02577	1559	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	72.34	1678	34aeab48-9c9b-4c06-8a45-3469f866cf88	CHIARPESCA  S.A.	Mar del Plata		489-1385	\N		\N	\N		t	\N	\N	\N
565e4ec6-97d8-4095-889a-c5c1654269fb	ESPERANZA DEL SUR	02751	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	60	\N	\N	b8a55941-9f65-4e90-bea1-3683753d42b5	PESANTAR  S.A. ( Empresa Pesq de la Patagonia y Antartida )	Ushuaia		02901-43-3449 / 43-0008 / 43-0708	\N		\N	\N		t	\N	\N	\N
0d4fe0b5-a3f7-44c6-bd1a-346e4196230f	ESPERANZA DOS	06264	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	ESPERANZA DEL MAR  S.A.	Ciudad Autónoma de Buenos Aires		011-4328-8696	\N		\N	\N		t	\N	\N	\N
7b43df46-d7b7-4066-8990-d183a5a191b2	ESPERANZA UNO	06113	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	ESPERANZA DEL MAR  S.A.	Ciudad Autónoma de Buenos Aires		011-4328-8696	\N		\N	\N		t	\N	\N	\N
cd250bb1-a300-4ff4-bf25-d86dd84b0c1c	ESTEFANY	001	1565	04d57c5c-390c-4334-bba9-d4635e1cb0c0	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	15	23.60	530	34aeab48-9c9b-4c06-8a45-3469f866cf88	GIORNO  S.A.	Mar del Plata		410-0051 / 0057	\N		\N	\N		t	\N	\N	\N
61ac30b0-2e7e-42a4-ba97-e2329539caf4	ESTEIRO	6328	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	BALDIMAR  S.A.	Mar del Plata		489-6522	\N		\N	\N		t	\N	\N	\N
71804555-4d27-407a-9701-451b513026ba	ESTHER 153	02058	1568	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	55.10	1252	11c64a29-e693-4bef-b734-8162f86cbbcc	ARPEPA  M.C.I.S.A.	Ciudad Autónoma de Buenos Aires		011-4382-1605	\N		\N	\N		t	\N	\N	\N
8862dc3d-3e05-4e70-8c4b-9f162cd82dc5	ESTRELLA N° 5	0246	1575	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	54.20	1601	11c64a29-e693-4bef-b734-8162f86cbbcc	HANSUNG AR  S.A.	Ciudad Autónoma de Buenos Aires		011-4816-2022	\N		\N	\N		t	\N	\N	\N
ef92a7a9-372a-4c43-a9cd-589953c0d797	ESTRELLA N° 6	012	1576	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	55.85	1581	11c64a29-e693-4bef-b734-8162f86cbbcc	HANSUNG AR  S.A.	Ciudad Autónoma de Buenos Aires		011-4816-2022	\N		\N	\N		t	\N	\N	\N
b48d59b9-3b1c-4ee3-aa2c-866679561ed5	ESTRELLA N° 8	0242	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	HANSUNG AR  S.A.	Ciudad Autónoma de Buenos Aires		011-4816-2022	\N		\N	\N		t	\N	\N	\N
2612c627-3e16-45c3-8b60-e8105386837a	FE EN PESCA	0226	\N	a4a18385-067c-481b-97e9-56dc132240d8	\N	\N	0	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	ASARO HNOS.  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
2285c55a-7ab8-469f-b7af-ff1a594e9624	FELIX AUGUSTO	0581	1595	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	27.80	601	105b0349-a9ed-49bf-9336-aad8d3867f0b	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
abfe526f-bf85-4dc2-89c7-557bfa93dbc3	FEIXA	0529	1592	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	c1692b3c-2c33-4957-8bcb-208f45e4534b	30	41.50	1101	34aeab48-9c9b-4c06-8a45-3469f866cf88	ANTONIO BARILLARI  S.A.	Mar del Plata		481-1173  / 489-0872	\N		\N	\N		t	\N	\N	\N
cf8cfd8b-6f05-4ea9-af17-0426de2c550f	EL MARISCO II	0915	1517	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	c1692b3c-2c33-4957-8bcb-208f45e4534b	30	56.30	1407	34aeab48-9c9b-4c06-8a45-3469f866cf88	EL MARISCO  S.A.	Mar del Plata		489-0384	\N		\N	\N		t	\N	\N	\N
06f7654a-cc4f-4331-8e87-c998dc86c2ab	API XII	3213	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	acea052d-e5d1-4ced-b98c-2d01eb79122a	4167beb8-ce39-4fd3-8314-8b3487879d92	\N	\N	\N	105b0349-a9ed-49bf-9336-aad8d3867f0b			\N	\N	\N	\N			\N	t	\N	\N	
11b8b3e8-bada-48d2-9696-ec894c5cb1ed	ESPARDEL	3211	\N	991d17ee-9376-401c-8883-c0409127d0af	fedc5975-2697-4b57-b26d-492a64ef6cc8	4167beb8-ce39-4fd3-8314-8b3487879d92	\N	\N	\N	\N			\N	\N	\N	\N			\N	t	\N	\N	
37fb0bff-71cf-474c-ac99-dfe32eb068d3	FEDERICO C	3190	2776	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	4167beb8-ce39-4fd3-8314-8b3487879d92	\N	37.68	1400	\N	PESQUERA VERAZ  S.A.				\N		\N	\N		t	\N	\N	\N
55b9680b-a422-457c-b103-efc7f46c952e	FERNANDO ALVAREZ	0013	1597	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	4167beb8-ce39-4fd3-8314-8b3487879d92	30	36.60	1168	105b0349-a9ed-49bf-9336-aad8d3867f0b	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
8b82f567-6be0-4696-b40d-a587b3ed4e22	DON SANTIAGO	01733	1467	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	4167beb8-ce39-4fd3-8314-8b3487879d92	10	26.55	776	34aeab48-9c9b-4c06-8a45-3469f866cf88	SAN JORGE S.A.	Mar del Plata		480-6611	\N		\N	\N		t	\N	\N	\N
66e7abfd-d9ab-478b-8300-e9be65838297	FLORIDABLANCA	0969	1606	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	27.67	541	34aeab48-9c9b-4c06-8a45-3469f866cf88	DESAFIO  S.A.	Mar del Plata		489-4788 / 3659	\N		\N	\N		t	\N	\N	\N
549d9f8c-46cd-49fe-8138-a2014681b239	FLORIDABLANCA II	0252	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	\N	\N	105b0349-a9ed-49bf-9336-aad8d3867f0b	PESQUERA SAN ISIDRO S.A.	Puerto Madryn		0280-447-2697	\N		\N	\N		t	\N	\N	\N
b0646571-a745-4278-bf46-84a4feac5359	FLORIDABLANCA IV	0255	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	\N	\N	5b1bcc08-58a5-499b-b2cc-d02d0df392fa	MARITIMA MONACHESI  S.A.	Bahia Blanca		0291-452-5913	\N		\N	\N		t	\N	\N	\N
3a28ba59-de98-4803-90b1-3e765708b934	FONSECA	0920	1610	bbebd1ff-edd5-48dd-925c-9735bb61b50d	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	60	62.40	2003	34aeab48-9c9b-4c06-8a45-3469f866cf88	FONSECA  S.A.	Mar del Plata	4891553-154179360-154179860-154179062	489-4645	\N	agenciasmiriglio@speedy.com.ar	\N	\N	Agencia Maritima Smiriglio	t	\N	\N	\N
03df67d1-d008-4b42-90fb-36c611ea16de	FRANCA	0495	1612	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	27.29	493	34aeab48-9c9b-4c06-8a45-3469f866cf88	AUGUSTA MEGARA  S.A.	Mar del Plata		480-2260	\N		\N	\N		t	\N	\N	\N
aeef4aee-ac05-4178-9428-e09ff58cc65f	FU YUAN YU 636	02195	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	BAHIA GRANDE  S.A.	Ciudad Autónoma de Buenos Aires		011-5272-0850 / 5254-1133	\N		\N	\N		t	\N	\N	\N
738dcc04-d768-49d2-8663-ce69b6057d02	FUEGUINO I	0331	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	105b0349-a9ed-49bf-9336-aad8d3867f0b	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
aff5335c-01e5-4bf3-937d-0a769eea266b	GALA	02722	0	04d57c5c-390c-4334-bba9-d4635e1cb0c0	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	15	15.20	256	34aeab48-9c9b-4c06-8a45-3469f866cf88	DISTRIBUIDORA MARECHIARE S.R.L.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
c21dba67-5adc-4cd4-a353-68366c2f194b	GALEMAR	0904	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	ANTONIO BARILLARI  S.A.	Mar del Plata		481-1173  / 489-0872	\N		\N	\N		t	\N	\N	\N
791abbde-36b2-45ab-ad29-164c37c7c1dd	GAUCHO GRANDE	0339	1642	991d17ee-9376-401c-8883-c0409127d0af	\N	\N	30	27.64	0	34aeab48-9c9b-4c06-8a45-3469f866cf88	VICARP  S.A.	Mar del Plata	4890960	480-4378	\N	agencia@maritimavidal.com.ar	\N	\N	Agencia Maritima Vidal	t	\N	\N	\N
7567c718-ded8-46a7-a023-00847d0d8e04	GIANFRANCO	01075	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	PIEA  S.A.	Mar del Plata		489-6317 /489-1367	\N		\N	\N		t	\N	\N	\N
7dbf4dcf-f689-44f9-9f6b-a94d771ad4aa	GIULIANA	02633	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	PESQUERA  MARGARITA  S.A.	Mar del Plata		489-4645   /   489-2946	\N		\N	\N		t	\N	\N	\N
f676b225-78ca-4d2c-b668-faa7e7e3192c	GLORIA DEL MAR I	01983	1651	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	54.30	1600	34aeab48-9c9b-4c06-8a45-3469f866cf88	PESQUERA  DEL  ESTE  S.A.	Mar del Plata	4800005	489-1567	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
353f1ebe-dcef-4570-b76c-9794f634c3cf	GRACIELA	0578	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	PEDRO MOSCUZZA e HIJOS  S.A.	Mar del Plata		489-7287	\N		\N	\N		t	\N	\N	\N
142b2a4b-c2b3-49bd-8a33-4a4f1dded656	GRAN CAPITAN	01538	1656	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	25.43	541	34aeab48-9c9b-4c06-8a45-3469f866cf88	ORTIGIA  S.A.	Mar del Plata		489-2679	\N		\N	\N		t	\N	\N	\N
7218342b-2da4-4deb-925c-45d9d0e8c63c	GURISES	01386	1667	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	25.20	546	34aeab48-9c9b-4c06-8a45-3469f866cf88	A.B.H. PESQUERA  S.A.	Mar del Plata		489-6522	\N		\N	\N		t	\N	\N	\N
2dda3abd-f7a0-4c52-8006-6427dea0484d	GUSTAVO R	0075	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	60	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	ARGEMER  S.A.	Mar del Plata		451-1247	\N		\N	\N		t	\N	\N	\N
722ea305-dfd7-48b0-81f1-a4f90a28a1aa	HAMAZEN MARU N° 68	JA05	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	PESQUERA SANTA CRUZ  S.A.	Ciudad Autónoma de Buenos Aires		011-4305-4706	\N		\N	\N		t	\N	\N	\N
6a14192b-b497-4393-a925-fcd619418ec3	LEAL	0143	1863	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	27.45	601	34aeab48-9c9b-4c06-8a45-3469f866cf88	PESQUERA LEAL  S.A.	Mar del Plata		489-4624 / 489-0314 (astillero )	\N		\N	\N		t	\N	\N	\N
a229783a-b570-4e6c-baff-994cbb7cf094	LEKHAN I	00752	1865	04d57c5c-390c-4334-bba9-d4635e1cb0c0	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	8	18.45	530	34aeab48-9c9b-4c06-8a45-3469f866cf88	LEKHAN I  S.R.L.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
e12f5b2a-dd64-4c98-b5b0-e2de886a5a85	LETARE	0245	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	LUIS SOLIMENO e HIJOS  S.A.	Mar del Plata		489-3030	\N		\N	\N		t	\N	\N	\N
24c98bdd-72cb-4bd5-914a-6945e668aa49	LIBERTAD DEL MAR 1°	02186	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	TATURIELLO  S.A.	Mar del Plata		489-3833	\N		\N	\N		t	\N	\N	\N
8f782df7-ec37-426a-ada4-a2e213b9e762	LING SHUI N° 3	02210	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	MUELLE OCHO  S.A.	Ciudad Autónoma de Buenos Aires		011-4381-1337	\N		\N	\N		t	\N	\N	\N
7ee207e1-80f7-4b2a-8c21-8a79be3d17b5	LING SHUI N° 5	02211	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	MUELLE OCHO  S.A.	Ciudad Autónoma de Buenos Aires		011-4381-1337	\N		\N	\N		t	\N	\N	\N
50550884-16d1-42c1-b7ef-e8f2f5943e43	LUCIA LUISA	0623	1897	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	27.90	463	34aeab48-9c9b-4c06-8a45-3469f866cf88	PESQUERA VERAZ  S.A.	Mar del Plata		489-4624 / 489-0314 (astillero)	\N		\N	\N		t	\N	\N	\N
e91588d0-bbd4-45fd-8e8e-c1334b7b9aed	LUNES SANTO	01132	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	\N	\N	105b0349-a9ed-49bf-9336-aad8d3867f0b	IBERCONSA  DE ARGENTINA  S.A.	Puerto Madryn		0280-445-4324	\N		\N	\N		t	\N	\N	\N
bfeb990b-cc3e-4f21-83d4-40ac3cafde44	MADONNINA DEL MARE	01112	1912	04d57c5c-390c-4334-bba9-d4635e1cb0c0	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	8	23.78	601	34aeab48-9c9b-4c06-8a45-3469f866cf88	FABLED  S.A	Mar del Plata		480-1565	\N		\N	\N		t	\N	\N	\N
91fec94c-df1c-4510-a124-cf935c62bf55	MADRE DIVINA	01556	1915	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	10	26.12	518	34aeab48-9c9b-4c06-8a45-3469f866cf88	VUOSO HNOS. S.R.L.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
f7963cf0-dd17-4f55-aa2e-3c1aea637baa	MADRE INMACULADA	2378	1916	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	62.80	1852	34aeab48-9c9b-4c06-8a45-3469f866cf88	ANTONIO BALDINO e HIJOS  S.A. (Saladero)	Mar del Plata		489-6522  /489-0423	\N		\N	\N		t	\N	\N	\N
13abe1c0-15eb-4458-8bb1-4fcf82cd4a3b	MADRE MARGARITA	02728	0	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	25.60	541	34aeab48-9c9b-4c06-8a45-3469f866cf88	PESQUERA  MARGARITA  S.A.	Mar del Plata		489-4645   /   489-2946	\N		\N	\N		t	\N	\N	\N
baf415ca-3912-4c52-9bd8-fc9dc20849c3	MAGDALENA MARIA  II	02208	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	ANTONIO BARILLARI  S.A.	Mar del Plata	4800005	481-1173  / 489-0872	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
243f37f8-1bcb-47de-bb40-e4eea31a9b2d	MALVINAS ARGENTINAS	0577	1931	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	28.40	458	34aeab48-9c9b-4c06-8a45-3469f866cf88	PEDRO MOSCUZZA e HIJOS  S.A.	Mar del Plata		489-7287	\N		\N	\N		t	\N	\N	\N
598906a6-e635-40e6-ae28-e6451ec921fd	MAR  AUSTRAL  I	0208	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	\N	\N	f41ff939-bc00-4bbd-8ce8-c451922ba284	PESQUERA DESEADO  S.A.	Puerto Deseado		0297-487-0884 / 0327 / 2407	\N		\N	\N		t	\N	\N	\N
749a7305-a597-4b36-a29d-b96b4b94989e	MAR AZUL	0934	\N	a4a18385-067c-481b-97e9-56dc132240d8	\N	\N	\N	\N	\N	\N	CLARAMAR  S.A.		480-7779 - HERNAN		\N	agenciasenoransmdp@yahoo.com	\N	\N	Agencia Maritima SEÑORANS	t	\N	\N	\N
057aaea3-8acd-4683-bee3-e91689c80b9e	MAR DEL CHUBUT	0487	1944	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	28.20	721	34aeab48-9c9b-4c06-8a45-3469f866cf88	ROMFIOC  SRL	Mar del Plata	4800005		\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi	t	\N	\N	\N
7f6f59da-01ca-48fc-a97c-698b2b827943	MAR ESMERALDA	0925	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	ANTONIO BARILLARI  S.A.	Mar del Plata		481-1173  / 489-0872	\N		\N	\N		t	\N	\N	\N
854c142e-a45b-4022-9411-52c786baa572	LUIGI	3244	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	4167beb8-ce39-4fd3-8314-8b3487879d92	30	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	LUIS SOLIMENO e HIJOS  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
71ac58df-bb35-4d50-902c-4b8805d03488	ITXAS LUR	0927	1735	bbebd1ff-edd5-48dd-925c-9735bb61b50d	acea052d-e5d1-4ced-b98c-2d01eb79122a	c1692b3c-2c33-4957-8bcb-208f45e4534b	60	63.30	1952	34aeab48-9c9b-4c06-8a45-3469f866cf88	HISPANO PATAGONICA  S.A.	Mar del Plata		480-1002 / 489-3165 / 489-7144	\N		\N	\N		t	\N	\N	\N
ac67da65-198f-43a9-b853-eea2da891505	LUCA SANTINO	3121	0	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	4167beb8-ce39-4fd3-8314-8b3487879d92	30	26.31	0	\N	CENTOMAR  S.A.				\N		\N	\N		t	\N	\N	\N
bf9011e3-436b-477e-adc9-5fdf755c9b63	JOSE AMERICO	03071	2756	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	4167beb8-ce39-4fd3-8314-8b3487879d92	30	44.21	0	34aeab48-9c9b-4c06-8a45-3469f866cf88	PEDRO MOSCUZZA e HIJOS  S.A.	Mar del Plata		489-7287	\N		\N	\N		t	\N	\N	\N
747dd411-950e-4d05-9c64-7b10f5950133	MAR MARÍA	02960	2738	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	37.80	1248	11c64a29-e693-4bef-b734-8162f86cbbcc	PESQUERA SANTA CRUZ  S.A.	Ciudad Autónoma de Buenos Aires		011-4305-4706	\N		\N	\N		t	\N	\N	\N
0078e584-dd7b-46b8-8edf-c2ac303cf972	MAR NOVIA 1	0115	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	CINCOMAR  S.A.	Ciudad Autónoma de Buenos Aires		011-4326-4991	\N		\N	\N		t	\N	\N	\N
0d29cf61-4ee5-4369-ba7c-24ac3c0b0948	MAR NOVIA 2	0116	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	MIREMAR  S.A.	Ciudad Autónoma de Buenos Aires		011-4328-4963 / 4	\N		\N	\N		t	\N	\N	\N
9f1c8494-2359-4d8f-b918-bc6e999fdc25	SANTIAGO  I	02280	\N	a4a18385-067c-481b-97e9-56dc132240d8	\N	\N	0	\N	\N	105b0349-a9ed-49bf-9336-aad8d3867f0b	FISHING WORLD  S.A.	Puerto Madryn		0280-445-6533	\N		\N	\N		t	\N	\N	\N
25cf13fb-87dc-4506-9150-eafd87561fa5	MARA I	0210	1960	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	35.31	1209	105b0349-a9ed-49bf-9336-aad8d3867f0b	PESCAPUERTA ARGENTINA  S.A.	Puerto Madryn		0280-445-4407	\N		\N	\N		t	\N	\N	\N
bc2916d9-5611-4ebe-9641-ad738eeb200c	MARA II	0209	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	\N	\N	105b0349-a9ed-49bf-9336-aad8d3867f0b	PESCAPUERTA ARGENTINA  S.A.	Puerto Madryn		0280-445-4407	\N		\N	\N		t	\N	\N	\N
b0d844de-b7f8-4f53-afbb-afd29f92db6a	MARBELLA	01073	1966	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	27.38	736	34aeab48-9c9b-4c06-8a45-3469f866cf88	MAR DE MESSINA  S.A.	Mar del Plata	beagle1	489-3824	\N		\N	\N		t	\N	\N	\N
9ec2716e-af9c-4cc4-8abe-cef1737fbb3e	MARCALA I	0532	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	PESANFLOR  S.A.	Mar del Plata		489-6522	\N		\N	\N		t	\N	\N	\N
a0da1df8-98b2-457d-ab9c-3eb0ed30616b	MARCALA IV	0351	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	MARCALA  S.A.	Ciudad Autónoma de Buenos Aires		011-4342-9601 / 4283	\N		\N	\N		t	\N	\N	\N
b2129247-34b9-4f84-932e-9e11a088ffbe	MAREJADA	01107	1974	991d17ee-9376-401c-8883-c0409127d0af	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	27.98	624	34aeab48-9c9b-4c06-8a45-3469f866cf88	VICARP  S.A.	Mar del Plata		480-4378	\N		\N	\N		t	\N	\N	\N
e0b5953e-9992-4daa-b981-44d5ab0f3352	HUAFENG 816	05994	0	04d57c5c-390c-4334-bba9-d4635e1cb0c0	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	4	22.60	521	34aeab48-9c9b-4c06-8a45-3469f866cf88	COSTA BRAVA  S.A.	Mar del Plata	4800005	489-7538	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
82f27fe1-cf7a-437f-87fc-7be940af0176	MARIA  LILIANA	01174	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	60	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	PEDRO MOSCUZZA e HIJOS  S.A.	Mar del Plata	4893758	489-7287	\N	miguel-visoso@hotmail.com	\N	\N	Agencia Maritima Solvox	t	\N	\N	\N
f2a36f97-d363-47d5-9a9d-52cc812a09eb	MARIA RITA	0436	2000	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	30.95	541	34aeab48-9c9b-4c06-8a45-3469f866cf88	BAL - FISH  S.A.	Mar del Plata		489-6522	\N		\N	\N		t	\N	\N	\N
753193ce-0aa1-4a8b-911c-d1bc9548195c	MARIA DEL VALLE	02126	1986	04d57c5c-390c-4334-bba9-d4635e1cb0c0	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	4	16.29	196	bea22adf-383f-4cc0-8c0b-bd514132fb77	FARO CHUBUT  S.R.L.	Rawson		0280-449-6311	\N		\N	\N		t	\N	\N	\N
f3248362-ab06-49bf-95da-8a472ebe8f67	MARIA GLORIA	02738	2763	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	28.05	851	34aeab48-9c9b-4c06-8a45-3469f866cf88	CAYO LARGO  S.A.	Mar del Plata		480-4378	\N		\N	\N		t	\N	\N	\N
edd0b459-9fdd-4da5-9cf1-422188daa525	MARTA S	01001	0	04d57c5c-390c-4334-bba9-d4635e1cb0c0	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	8	23.90	503	34aeab48-9c9b-4c06-8a45-3469f866cf88	WERZOWA  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
e091039b-a9b6-41d3-b440-de5c82087f12	MATACO II	02243	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	60	\N	\N	105b0349-a9ed-49bf-9336-aad8d3867f0b	HAMALTAL  S.A.	Puerto Madryn	4800005	0280-445-0822	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
11843bbd-14ce-4e56-85c8-f72cc6d6ac6e	MELLINO I	0379	2032	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	47.25	1185	34aeab48-9c9b-4c06-8a45-3469f866cf88	GIORNO  S.A.	Mar del Plata		410-0051 / 0057	\N		\N	\N		t	\N	\N	\N
67335a25-9bc6-4b53-a09a-43b6aac3e6ba	PASA  82	0338	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	105b0349-a9ed-49bf-9336-aad8d3867f0b	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
a3a665f8-8586-48fd-a35a-0f55eb05247a	MELLINO II	01424	0	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	38.91	795	34aeab48-9c9b-4c06-8a45-3469f866cf88	GIORNO  S.A.	Mar del Plata	AVENIDA DE LOS PESCADORES 195	410-0051 / 0057	\N		\N	\N	Agencia AMALFITANO	t	\N	\N	\N
d4745593-c290-49d4-a2ff-bf4cbe864b28	MERCEA C	0318	2036	991d17ee-9376-401c-8883-c0409127d0af	\N	\N	0	29.15	866	34aeab48-9c9b-4c06-8a45-3469f866cf88	ALLELOCCIC  S.A.	Mar del Plata		495-4467 / 480-8565	\N		\N	\N		t	\N	\N	\N
73bb4866-5b6c-453e-8dcc-2306b96e26d0	MESSINA I	01089	2038	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	27.29	650	34aeab48-9c9b-4c06-8a45-3469f866cf88	MAR DE MESSINA  S.A.	Mar del Plata		489-3824	\N		\N	\N		t	\N	\N	\N
68a1aaa8-4011-4920-8865-d05c62f145d1	MEVIMAR	01508A	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	\N	\N	105b0349-a9ed-49bf-9336-aad8d3867f0b	RIMINIMARR  S.A.	Puerto Madryn		0280-445-2248	\N		\N	\N		t	\N	\N	\N
382e10eb-865b-4147-9366-5d76d841fb75	MIERCOLES SANTO	0666	2041	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	38.50	1244	11c64a29-e693-4bef-b734-8162f86cbbcc	NUVCONSA  S.A.	Ciudad Autónoma de Buenos Aires		011-4305-4706	\N		\N	\N		t	\N	\N	\N
49ea472e-409e-4547-83fb-3199e5ee8db1	MILLENNIUM	0466	2046	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	55.05	1329	11c64a29-e693-4bef-b734-8162f86cbbcc	PESQUERA CRUZ DEL SUR  S.A.	Ciudad Autónoma de Buenos Aires		011-4784-1760	\N		\N	\N		t	\N	\N	\N
0cebcd19-614f-4e7a-9c89-8f8ec1eeadf2	MINCHOS OCTAVO	03022	2744	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	39.30	579	105b0349-a9ed-49bf-9336-aad8d3867f0b	IBERCONSA  DE ARGENTINA  S.A.	Puerto Madryn		0280-445-4324	\N		\N	\N		t	\N	\N	\N
2c33dae2-6632-468a-abdd-2c35e16fa478	MIRIAM	0370	2051	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	36.35	1446	11c64a29-e693-4bef-b734-8162f86cbbcc	VIEIRA ARGENTINA  S.A.	Ciudad Autónoma de Buenos Aires	4800005		\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi	t	\N	\N	\N
b2ed178e-eb23-49ed-8c17-5e6b422cb186	MISHIMA MARU N°8	02175	2054	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	63.43	1579	34aeab48-9c9b-4c06-8a45-3469f866cf88	BAL - FISH  S.A.	Mar del Plata	4800274	489-6522	\N	amalfitanoycia@hotmail.com	\N	\N	Agencia Maritima Almafitano	t	\N	\N	\N
49087f92-c34f-4ac7-9312-baf546c7fb07	MISTER BIG	0534	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	WANCHESE ARGENTINA  S.A.	Mar del Plata		489-1236	\N		\N	\N		t	\N	\N	\N
113c933d-0413-4909-998e-45614ee4ba7e	MIURA MARU	05996	2058	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	53.20	1482	11c64a29-e693-4bef-b734-8162f86cbbcc	LIYA  S.A.	Ciudad Autónoma de Buenos Aires		011-4964-2227	\N		\N	\N		t	\N	\N	\N
bd400468-dd52-4817-95dd-b124bdb272f7	MONTE DE VIOS	0664	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	PESQUERA SANTA CRUZ  S.A.	Ciudad Autónoma de Buenos Aires		011-4305-4706	\N		\N	\N		t	\N	\N	\N
c1fb290e-10a9-4cef-9075-929f585122f3	MAR SUR	0341	1957	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	4167beb8-ce39-4fd3-8314-8b3487879d92	30	36.40	889	11c64a29-e693-4bef-b734-8162f86cbbcc	PESCARGEN  S.A.	Ciudad Autónoma de Buenos Aires		011-5219-0065 ó 5276-9499	\N		\N	\N		t	\N	\N	\N
c5d2228b-36be-4674-8c03-14f817316ca7	MISS PATAGONIA	0555	2055	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	e16a6ea7-08d9-4891-b3ab-3ac866d647c2	30	28.20	667	34aeab48-9c9b-4c06-8a45-3469f866cf88	PESQUERA VERAZ  S.A.	Mar del Plata	4805743	489-4624 / 489-0314 (astillero)	\N	agenciadiyorio@hotmail.com -joseph@hotmail.com	\N	\N	Agencia Di Yorio	t	\N	\N	\N
844026fe-c6be-4b40-b4f4-4758a4437c2d	NINA	3171	2770	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	4167beb8-ce39-4fd3-8314-8b3487879d92	30	44.00	1620	\N	PEDRO MOSCUZZA e HIJOS  S.A.				\N		\N	\N		t	\N	\N	\N
d7cc59c9-d446-4271-b0cf-9df6242b41fd	MELLINO VI	0378	2034	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	c1692b3c-2c33-4957-8bcb-208f45e4534b	30	64.87	1235	34aeab48-9c9b-4c06-8a45-3469f866cf88	GIORNO  S.A.	Mar del Plata		410-0051 / 0057	\N		\N	\N		t	\N	\N	\N
87fc1c47-b658-4994-beae-d69e1eedead4	MARIA ALEJANDRA 1º	03074	2750	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	4167beb8-ce39-4fd3-8314-8b3487879d92	30	39.20	0	34aeab48-9c9b-4c06-8a45-3469f866cf88	XEITOSIÑO S.A.	Mar del Plata		410-0051 / 7	\N		\N	\N		t	\N	\N	\N
3e0c8867-184b-437a-a2b6-482cf522af0a	MATEO I	02172	2028	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	40	67.97	1776	11c64a29-e693-4bef-b734-8162f86cbbcc	KALEU KALEU  S.A.	Ciudad Autónoma de Buenos Aires		011-3220-2130  / 5093-1215	\N		\N	\N		t	\N	\N	\N
b1fedb55-7446-4027-aa7c-1a5dcfcb4ba5	MARIANELA	01002	2007	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	e16a6ea7-08d9-4891-b3ab-3ac866d647c2	30	25.60	541	34aeab48-9c9b-4c06-8a45-3469f866cf88	AGLIANO  SRL	Mar del Plata		480-2886	\N		\N	\N		t	\N	\N	\N
a568597e-e77e-453b-a7cc-f7bee580616e	NAVEGANTES II	01451	2080	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	63.70	1603	34aeab48-9c9b-4c06-8a45-3469f866cf88	PESQUERA COMERCIAL  S.A.	Mar del Plata		489-3030	\N		\N	\N		t	\N	\N	\N
27337aa3-35fa-4d2b-9696-98255bbf2493	NDDANDDU	0141	2082	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	28.20	856	34aeab48-9c9b-4c06-8a45-3469f866cf88	PESQUERA VERAZ  S.A.	Mar del Plata		489-4624 / 489-0314 (astillero)	\N		\N	\N		t	\N	\N	\N
9b255813-442b-40a9-b3e7-a49072133133	NEPTUNIA I	02125	\N	04d57c5c-390c-4334-bba9-d4635e1cb0c0	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	4	\N	\N	bea22adf-383f-4cc0-8c0b-bd514132fb77	FLOTA AMARILLA RAWSON	Rawson	4891553-154179360-154179860-154179062		\N	agenciasmiriglio@speedy.com.ar	\N	\N	Agencia Maritima SMIRIGLIO	t	\N	\N	\N
af23e539-baa2-4cdd-9c30-b3126af01ce0	NIÑO JESUS DE PRAGA	3194	2775	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	27.74	1180	34aeab48-9c9b-4c06-8a45-3469f866cf88	RITORNO SALLUSTIO Y CICCIOTTI  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
064f64a5-44ec-4050-8174-c63df9c72250	NUEVA LUCIA MADRE	01501	2113	a1373c68-08c7-4c4c-b9a5-b23ccf0abdcc	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	8	14.37	416	34aeab48-9c9b-4c06-8a45-3469f866cf88	NUEVA LUCIA MADRE  S.R.L.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
667810ff-6a43-437d-943a-fda2d7e0a32f	NUEVA NEPTUNIA I	02634	0	04d57c5c-390c-4334-bba9-d4635e1cb0c0	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	4	20.00	403	bea22adf-383f-4cc0-8c0b-bd514132fb77	ORION S.R.L.	Rawson			\N		\N	\N		t	\N	\N	\N
fbf252c4-77e3-44c8-893e-55c0bf2e28b5	NUEVO ANITA	02100	2128	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	30.90	765	105b0349-a9ed-49bf-9336-aad8d3867f0b	IBERCONSA  DE ARGENTINA  S.A.	Puerto Madryn		0280-445-4324	\N		\N	\N		t	\N	\N	\N
52ec724f-b8e2-45c7-98c5-e28a44dc63f3	NUEVO VIENTO	01449	2135	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	22.23	541	34aeab48-9c9b-4c06-8a45-3469f866cf88	NUEVO VIENTO  SRL	Mar del Plata		480-8565	\N		\N	\N		t	\N	\N	\N
4950e2cb-c0cb-48c7-a016-46bae464d4f0	OMEGA 3	01391	\N	04d57c5c-390c-4334-bba9-d4635e1cb0c0	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	10	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	COSTA BRAVA  S.A.	Mar del Plata		489-7538	\N		\N	\N		t	\N	\N	\N
e41a745e-ad41-4a17-85f2-811fc596a249	ORION  2	01492	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	PESQUERA SANTA CRUZ  S.A.	Ciudad Autónoma de Buenos Aires		011-4305-4706	\N		\N	\N	norberto.lopez@iberconsa.com	t	\N	\N	\N
27cc2237-493e-4d8d-9138-30a13c472f90	ORION 5	02637	2757	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	65.62	1776	11c64a29-e693-4bef-b734-8162f86cbbcc	PESQUERA SANTA CRUZ  S.A.	Ciudad Autónoma de Buenos Aires		011-4305-4706	\N		\N	\N		t	\N	\N	\N
7bddf2fc-485f-4cce-9eef-c2c33cfd117b	SIEMPRE SAN SALVADOR	00801	2475	04d57c5c-390c-4334-bba9-d4635e1cb0c0	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	8	22.35	600	34aeab48-9c9b-4c06-8a45-3469f866cf88	LOURDESMAR  S.R.L.	Mar del Plata		476-2916	\N		\N	\N		t	\N	\N	\N
8215a9ae-ebb4-4954-afec-630ec6244731	ORION I	01943A	0	04d57c5c-390c-4334-bba9-d4635e1cb0c0	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	20.90	520	11c64a29-e693-4bef-b734-8162f86cbbcc	PESQUERA CRUZ DEL SUR  S.A.	Ciudad Autónoma de Buenos Aires		011-4784-1760	\N		\N	\N		t	\N	\N	\N
f0d0cff4-7236-4b1a-a9b8-f5f3ffe54af9	ORION 1	01943	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	PESQUERA SANTA CRUZ  S.A.	Ciudad Autónoma de Buenos Aires		011-4305-4706	\N		\N	\N		t	\N	\N	\N
d78c10f2-ab4b-4c03-9e5e-75f68bb6b2ce	ORION 3	02167	2170	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	63.10	1776	11c64a29-e693-4bef-b734-8162f86cbbcc	PESQUERA SANTA CRUZ  S.A.	Ciudad Autónoma de Buenos Aires		011-4305-4706	\N		\N	\N		t	\N	\N	\N
f7ff96b3-746f-4a6f-9175-2d2cf8e30368	ORYONG  756	02092	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	105b0349-a9ed-49bf-9336-aad8d3867f0b	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
a886c32f-4bd8-4790-9638-1a0b86a26712	PACHACA	02572	2180	04d57c5c-390c-4334-bba9-d4635e1cb0c0	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	4	17.64	320	bea22adf-383f-4cc0-8c0b-bd514132fb77	FLOTA AMARILLA RAWSON	Rawson			\N		\N	\N		t	\N	\N	\N
ab0be5b8-6db2-44da-89e6-07ce671f3382	PADRE PIO	02822	2737	04d57c5c-390c-4334-bba9-d4635e1cb0c0	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	24.00	451	34aeab48-9c9b-4c06-8a45-3469f866cf88	RITORNO SALLUSTIO Y CICCIOTTI  S.A.	Mar del Plata		480-5508	\N		\N	\N		t	\N	\N	\N
e45932f8-f9c7-4111-a897-516028a4172d	PAGRUS II	01393	\N	04d57c5c-390c-4334-bba9-d4635e1cb0c0	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	4	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	COSTA BRAVA  S.A.	Mar del Plata		489-7538	\N		\N	\N		t	\N	\N	\N
24426440-6674-4867-981b-44bb1389da7d	PAKU	0250	2186	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	39.16	1087	34aeab48-9c9b-4c06-8a45-3469f866cf88	LUIS SOLIMENO e HIJOS  S.A.	Mar del Plata		489-3030	\N		\N	\N		t	\N	\N	\N
ed85a95e-7cd5-44fd-8f4e-2f33017bd8b1	PATAGONIA	0284	2196	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	30.95	660	34aeab48-9c9b-4c06-8a45-3469f866cf88	LUIS SOLIMENO e HIJOS  S.A.	Mar del Plata		489-3030	\N		\N	\N		t	\N	\N	\N
674051b2-f81d-4369-a039-fe6771c25e3d	PATAGONIA 1	02163	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	PATAGONIA  FISHING  S.A.	Ciudad Autónoma de Buenos Aires		011-4932-2777	\N		\N	\N		t	\N	\N	\N
50b3cfd9-5d94-4626-9ee3-6eb49c74f8df	PATAGONIA 2	02164	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	PATAGONIA  FISHING  S.A.	Ciudad Autónoma de Buenos Aires		011-4932-2777	\N		\N	\N		t	\N	\N	\N
f696cd30-1a04-48d6-b3a2-0813169ef71b	PATAGONIA BLUES	02176	2199	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	64.45	1776	11c64a29-e693-4bef-b734-8162f86cbbcc	PESQUERA CRUZ DEL SUR  S.A.	Ciudad Autónoma de Buenos Aires		011-4784-1760	\N		\N	\N		t	\N	\N	\N
846e2d5c-f17a-4862-ae80-910157d4cdb5	PELAGOS	83	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	105b0349-a9ed-49bf-9336-aad8d3867f0b	PESQUERA SAN ISIDRO S.A.	Puerto Madryn		0280-447-2697	\N		\N	\N		t	\N	\N	\N
c8592fbd-f499-4881-873f-307b5bd00df8	PENSACOLA I	0747	2207	991d17ee-9376-401c-8883-c0409127d0af	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	25.20	380	5f58a58c-0cbb-4d6f-b987-f60d562a279c	FRANGELA  S.A.	Comodoro Rivadavia			\N		\N	\N		t	\N	\N	\N
b044b4ca-8e7a-4bf1-a053-873b7fd2e130	PESCAPUERTA CUARTO	0171	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	60	\N	\N	105b0349-a9ed-49bf-9336-aad8d3867f0b	PESCAPUERTA ARGENTINA  S.A.	Puerto Madryn		0280-445-4407	\N		\N	\N		t	\N	\N	\N
d4d9d60e-8b41-4030-961a-13b72d66deaf	PESCAPUERTA QUINTO	0538	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	60	\N	\N	105b0349-a9ed-49bf-9336-aad8d3867f0b	PESCAPUERTA ARGENTINA  S.A.	Puerto Madryn		0280-445-4407	\N		\N	\N		t	\N	\N	\N
8e4949a7-bacf-4cda-96e9-3d39392f152f	PESCARGEN  V	078	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	60	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	PESCARGEN  S.A.	Ciudad Autónoma de Buenos Aires		011-5219-0065 ó 5276-9499	\N		\N	\N		t	\N	\N	\N
59563532-cad8-48ec-96f6-684de72e78a6	PESCARGEN III	021	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	60	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	PESCARGEN  S.A.	Ciudad Autónoma de Buenos Aires		011-5219-0065 ó 5276-9499	\N		\N	\N		t	\N	\N	\N
9711d47c-8da4-412d-9310-a34876679a3c	PESCARGEN IV	0150	2217	bbebd1ff-edd5-48dd-925c-9735bb61b50d	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	60	63.20	1603	11c64a29-e693-4bef-b734-8162f86cbbcc	PESCARGEN  S.A.	Ciudad Autónoma de Buenos Aires		011-5219-0065 ó 5276-9499	\N		\N	\N		t	\N	\N	\N
3144ab32-e078-4b48-9f32-52846853a9fe	PESPASA  II	0212	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	\N	\N	f41ff939-bc00-4bbd-8ce8-c451922ba284	PESPASA  S.A.	Puerto Deseado		0297-487-2030  int 12	\N		\N	\N		t	\N	\N	\N
b422b4ce-70c9-4b52-aa4f-15ccf351575a	NONO PASCUAL	02854	2729	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	4167beb8-ce39-4fd3-8314-8b3487879d92	10	24.00	451	34aeab48-9c9b-4c06-8a45-3469f866cf88	CANAL DE BEAGLE  S.R.L.	Mar del Plata		480-4447 / 5004265 PASCUAL	\N		\N	\N		t	\N	\N	\N
32e93528-46a4-40d8-8576-89d228fa5dda	PEDRITO	TEMP-0005	0	991d17ee-9376-401c-8883-c0409127d0af	fedc5975-2697-4b57-b26d-492a64ef6cc8	4167beb8-ce39-4fd3-8314-8b3487879d92	\N	39.92	1201	\N					\N		\N	\N		t	\N	\N	\N
c7c5892b-d6ee-4b44-b3a6-24dc9ded90aa	NATALIA	02066	2075	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	40	68.45	1779	34aeab48-9c9b-4c06-8a45-3469f866cf88	PEDRO MOSCUZZA e HIJOS  S.A.	Mar del Plata		489-7287	\N		\N	\N		t	\N	\N	\N
e7ed7f8b-9e82-48db-94f1-c9c63d3391eb	NANINA	02576	2073	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	40	72.08	1678	34aeab48-9c9b-4c06-8a45-3469f866cf88	PEDRO MOSCUZZA e HIJOS  S.A.	Mar del Plata	4800005	489-7287	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
f66cbd4a-6e7c-4e91-a8e8-4c5e5542dae1	NAVEGANTES	0542	2079	bbebd1ff-edd5-48dd-925c-9735bb61b50d	acea052d-e5d1-4ced-b98c-2d01eb79122a	c1692b3c-2c33-4957-8bcb-208f45e4534b	60	58.00	1925	34aeab48-9c9b-4c06-8a45-3469f866cf88	PESQUERA COMERCIAL  S.A.	Mar del Plata		489-3030	\N		\N	\N		t	\N	\N	\N
e929f655-7f4c-4bb0-91e4-79726eebc616	PESPASA I	0211	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	\N	\N	f41ff939-bc00-4bbd-8ce8-c451922ba284	PESPASA  S.A.	Puerto Deseado		0297-487-2030  int 12	\N		\N	\N		t	\N	\N	\N
925d47d0-e997-46fc-8b4f-30c3c9c8b4ac	PETREL	01445	2224	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	29.85	776	34aeab48-9c9b-4c06-8a45-3469f866cf88	OLAMAR  S.A.	Mar del Plata		480-3573	\N		\N	\N		t	\N	\N	\N
849509b7-39c6-47e0-88cb-c8d108d036ad	PEVEGASA QUINTO	02312	2225	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	38.65	740	11c64a29-e693-4bef-b734-8162f86cbbcc	PUNTA BUSTAMANTE  S.A.	Ciudad Autónoma de Buenos Aires		011-4305-4710 / 4712	\N		\N	\N		t	\N	\N	\N
bc30d59b-dbfe-481b-b43d-2502573cbdb0	POLARBORG I	02122	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	GRINFIN  S.A.	Ciudad Autónoma de Buenos Aires		011-4343-5626	\N		\N	\N		t	\N	\N	\N
52386e5a-b83c-4a2f-a0bd-356376f8de2a	POLARBORG II	02117	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	GRINFIN  S.A.	Ciudad Autónoma de Buenos Aires	4800005	011-4343-5626	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi	t	\N	\N	\N
472a56b8-017a-4315-8ca9-4dce9e563d65	PORTO BELO I	02699	2736	04d57c5c-390c-4334-bba9-d4635e1cb0c0	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	8	23.98	600	34aeab48-9c9b-4c06-8a45-3469f866cf88	FARO RECALADA  S.A	Mar del Plata		480-2442	\N		\N	\N		t	\N	\N	\N
d3b94e96-f2a9-423c-b5f1-1d35cb5522f2	PORTO BELO II	02790	2728	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	10	23.98	601	34aeab48-9c9b-4c06-8a45-3469f866cf88	MARITIMA PORTO BELO  S.A.	Mar del Plata		489-1553	\N		\N	\N		t	\N	\N	\N
afe2a164-9b83-49b3-832a-91372f5ff648	PROMAC	4815	2257	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	33.45	721	34aeab48-9c9b-4c06-8a45-3469f866cf88	LUIS SOLIMENO e HIJOS  S.A.	Mar del Plata		489-3030	\N		\N	\N		t	\N	\N	\N
41c637b4-58ab-408d-8d66-99fb98f1cd48	PROMARSA I	072	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	\N	\N	105b0349-a9ed-49bf-9336-aad8d3867f0b	ALPESCA  S.A.	Puerto Madryn		0280-447-4958 / 45-1069	\N		\N	\N		t	\N	\N	\N
4bd14408-6581-4067-97dd-7f9a8a09a6fb	PROMARSA II	073	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	\N	\N	105b0349-a9ed-49bf-9336-aad8d3867f0b	ALPESCA  S.A.	Puerto Madryn		0280-447-4958 / 45-1069	\N		\N	\N		t	\N	\N	\N
01a61000-af30-42f8-b164-cefa8372eaaf	PROMARSA III	02096	0	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	35.84	1062	105b0349-a9ed-49bf-9336-aad8d3867f0b	ALPESCA  S.A.	Puerto Madryn		0280-447-4958 / 45-1069	\N		\N	\N		t	\N	\N	\N
f773f7e8-075c-4899-a2e1-141d10e5e08b	PUENTE AMERICA	0164	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	\N	\N	105b0349-a9ed-49bf-9336-aad8d3867f0b	PEREIRA  ARGENTINA  S.A.	Puerto Madryn		0280-445-7377 / 447-2249	\N		\N	\N		t	\N	\N	\N
7bb107ac-e355-4336-a5dc-2e4b38eb2502	PUENTE CHICO	0756	2263	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	37.00	1175	105b0349-a9ed-49bf-9336-aad8d3867f0b	PEREIRA  ARGENTINA  S.A.	Puerto Madryn		0280-445-7377 / 447-2249	\N		\N	\N		t	\N	\N	\N
ee4ff734-9a8b-4c09-86f2-b11c61925109	PUENTE MAYOR	02630	2703	bbebd1ff-edd5-48dd-925c-9735bb61b50d	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	60	66.86	2416	105b0349-a9ed-49bf-9336-aad8d3867f0b	PEREIRA  ARGENTINA  S.A.	Puerto Madryn		0280-445-7377 / 447-2249	\N		\N	\N		t	\N	\N	\N
cf5b3906-dbe3-46c2-aa50-e10756b4ffae	PUENTE SAN JORGE	0207	2265	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	35.30	1001	105b0349-a9ed-49bf-9336-aad8d3867f0b	PEREIRA  ARGENTINA  S.A.	Puerto Madryn		0280-445-7377 / 447-2249	\N		\N	\N		t	\N	\N	\N
97182de0-ac10-4044-a633-41569ba3fd66	PUERTO WILLIAMS	3178	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	60	\N	\N	b8a55941-9f65-4e90-bea1-3683753d42b5	DERIS  S.A.	Punta Arenas -  Chile		+613 6224-8744	\N		\N	\N		t	\N	\N	\N
91fa52d5-cd1f-4bc1-9a0d-3bebfc7742a9	PUNTA BALLENA	65	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	3b9fe535-63a2-4982-b7d4-71229ab250dc	\N	60	\N	\N	\N					\N		\N	\N		t	\N	\N	\N
7a01f717-05f2-4d87-b3e4-ee8592238fdc	QUEQUEN SALADO	0580	2277	04d57c5c-390c-4334-bba9-d4635e1cb0c0	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	4	19.45	271	bea22adf-383f-4cc0-8c0b-bd514132fb77	PISCAL  S.A.	Rawson			\N		\N	\N		t	\N	\N	\N
690bb690-71e8-4099-a740-ab8d10b464ae	RAQUEL	01074	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	PIEA  S.A.	Mar del Plata		489-6317 /489-1367	\N		\N	\N		t	\N	\N	\N
e6427e55-c856-48d7-979b-5095f244365e	REPUNTE	01120	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	OSTRAMAR  S.A.	Mar del Plata		489-1959	\N		\N	\N		t	\N	\N	\N
56ea9769-5bb5-42c6-b95f-b656c0f1d411	REYES DEL MAR II	0408	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	AGUA MARINA  S.A.	Ciudad Autónoma de Buenos Aires		011-4342-0605 / 5656 / 1709	\N		\N	\N		t	\N	\N	\N
62374dc2-3b23-4108-87a0-167a2098f95e	RIBAZON DORINE	0921	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	KALEU KALEU  S.A.	Ciudad Autónoma de Buenos Aires		011-3220-2130  / 5093-1215	\N		\N	\N		t	\N	\N	\N
23afca1d-a1cf-4031-89af-c9cb1abaf5fd	RIBAZON INES	0751	2306	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	38.50	720	34aeab48-9c9b-4c06-8a45-3469f866cf88	SOUTH FISH  S.A.	Mar del Plata		480-5202	\N		\N	\N		t	\N	\N	\N
8fbf968b-b9aa-4316-ac14-c65ecb2bc56b	Hai Xiang 16	LW5157	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	40	\N	\N	\N	PESQUERA RÍO QUEQUEN				\N		\N	\N		t	\N	\N	\N
cfc3468e-e58e-4a40-8240-867715beca37	RIGEL	0266	\N	04d57c5c-390c-4334-bba9-d4635e1cb0c0	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	10	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	LUIS SOLIMENO e HIJOS  S.A.	Mar del Plata		489-3030	\N		\N	\N		t	\N	\N	\N
e3c438f7-54f1-4646-a1d2-587704ac0f9e	ROCIO DEL MAR	01568	2313	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	15	22.60	541	34aeab48-9c9b-4c06-8a45-3469f866cf88	ROCIO DEL MAR  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
f4172705-eccd-4843-913a-f64293b045ae	ROSARIO  G	0549	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	\N	\N	105b0349-a9ed-49bf-9336-aad8d3867f0b	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
7aa7ce10-657a-4c2a-be88-85fd0aa015e7	RUMBO ESPERANZA	01211	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	\N	\N	5f58a58c-0cbb-4d6f-b987-f60d562a279c	CAPAC  SRL	Comodoro Rivadavia		0297-446-1499  /  444-2233	\N		\N	\N		t	\N	\N	\N
d439d226-c16b-4ed8-b224-51f4e0067c0b	RYOUN MARU N° 17	JA06-03	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	BAHIA GRANDE  S.A.	Ciudad Autónoma de Buenos Aires	4891553-154179360-154179860-154179062	011-5272-0850 / 5254-1133	\N	agenciasmiriglio@speedy.com.ar	\N	\N	Agencia Maritima Smiriglio	t	\N	\N	\N
c5cfd6c0-a38b-4fa2-b001-47f62e495b82	SAN ANDRES APOSTOL	0569	2340	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	54.56	2269	34aeab48-9c9b-4c06-8a45-3469f866cf88	PESANFLOR  S.A.	Mar del Plata		489-6522	\N		\N	\N		t	\N	\N	\N
5a80fa66-051c-46cf-ac41-5a71f597b202	SAN ANTONINO	0375	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	SEA FISH  S.A.	Mar del Plata	51-11-65337853	480-0336	\N		\N	\N	Natalia Cedrato	t	\N	\N	\N
9d787749-f123-436e-b686-da4f3f4786c0	SAN BENEDETTO	02643	0	04d57c5c-390c-4334-bba9-d4635e1cb0c0	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	8	15.38	220	34aeab48-9c9b-4c06-8a45-3469f866cf88	PESQUERA SAN BENEDETTO  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
66f53f6d-f483-4da5-b83e-515756eaec5d	SAN GENARO	0763	\N	04d57c5c-390c-4334-bba9-d4635e1cb0c0	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	10	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	LESAUMON  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
36b6f732-26de-4021-aaa5-2276f16c729a	SAN JORGE MARTIR	02152	2367	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	56.10	1408	34aeab48-9c9b-4c06-8a45-3469f866cf88	PESANFLOR  S.A.	Mar del Plata		489-6522	\N		\N	\N		t	\N	\N	\N
3b35cd9f-9541-41a4-94d2-9e1de955c892	JOSE LUCIANO	3230	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	a67a623b-9bd3-45ae-8512-9c6b22645469	\N	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88			\N	\N	\N	\N			\N	t	\N	\N	
366e3631-c4fe-4001-960d-c816b3a08a1c	RAFFAELA	01401	2280	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	822d18e6-569a-40fc-a58f-429b6bef4613	30	26.50	624	34aeab48-9c9b-4c06-8a45-3469f866cf88	PESQUERA RAFFAELA  S.A.	Mar del Plata		489-56574 int 203	\N		\N	\N		t	\N	\N	\N
50a5014a-b7c0-432c-a620-a5f096fabe15	PIONEROS	02735	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	30	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	CALME  S.A.	Mar del Plata		480-3545	\N		\N	\N		t	\N	\N	\N
04b53087-52e8-4656-be93-714c343c47d6	VALERIA DEL ATLÁNTICO	02098	2346	bbebd1ff-edd5-48dd-925c-9735bb61b50d	acea052d-e5d1-4ced-b98c-2d01eb79122a	92d9acc2-3590-474f-a773-73e8af728e83	60	56.46	4698	34aeab48-9c9b-4c06-8a45-3469f866cf88	SAN ARAWA  S.A.	Mar del Plata		492-2216 / 492-0450	\N		\N	\N		t	\N	\N	\N
542c0a22-02f9-4816-ba4c-be8655ccbedc	PONTE DE RANDE	0244	2243	bbebd1ff-edd5-48dd-925c-9735bb61b50d	acea052d-e5d1-4ced-b98c-2d01eb79122a	c1692b3c-2c33-4957-8bcb-208f45e4534b	60	79.14	2964	34aeab48-9c9b-4c06-8a45-3469f866cf88	COSTA MARINA  S.A.	Mar del Plata		480-9608 / 481-0464	\N		\N	\N		t	\N	\N	\N
64782920-6598-4760-ba21-7ead251ff1e1	SAN JUAN B	TEMP-0007	2780	bbebd1ff-edd5-48dd-925c-9735bb61b50d	\N	4167beb8-ce39-4fd3-8314-8b3487879d92	\N	39.94	1204	\N					\N		\N	\N		t	\N	\N	\N
21c0f3cb-e6e8-43bc-929b-99c24f15bf83	PUENTE VALDES	02205	2266	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	40	58.15	1383	105b0349-a9ed-49bf-9336-aad8d3867f0b	PEREIRA  ARGENTINA  S.A.	Puerto Madryn		0280-445-7377 / 447-2249	\N		\N	\N		t	\N	\N	\N
0e2a5c62-db26-40fc-b1b1-13f426e36388	SALVADOR R	02755	2761	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	4167beb8-ce39-4fd3-8314-8b3487879d92	30	27.73	420	34aeab48-9c9b-4c06-8a45-3469f866cf88	URBIPEZ  S.A.	Mar del Plata		4892793	\N		\N	\N		t	\N	\N	\N
508ba80b-09eb-44f3-a0b8-5a33152949e8	SAN LUCAS  I	06147	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	AGUA MARINA  S.A.	Ciudad Autónoma de Buenos Aires		011-4342-0605 / 5656 / 1709	\N		\N	\N		t	\N	\N	\N
0e3f3e30-87fe-4d95-80dd-2174a3146bde	SAN MATEO	06306	0	04d57c5c-390c-4334-bba9-d4635e1cb0c0	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	54.10	1234	bea22adf-383f-4cc0-8c0b-bd514132fb77	IBERPESCA  S.A.	Rawson		0280-449-8176	\N		\N	\N		t	\N	\N	\N
a0968010-bc04-4b2e-a2d5-15f1db080474	SAN PABLO	0759	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	PRODUCTORA ARGEN-PESCA  S.A.	Mar del Plata		480-1444	\N		\N	\N		t	\N	\N	\N
fba5bf87-0034-443e-a48b-43adb82991aa	SAN PASCUAL	0367	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	BUENOS AIRES PESCA  S.A.	Mar del Plata		489-6522	\N		\N	\N		t	\N	\N	\N
2df433f7-49df-41f3-b516-c0220ec981c8	SAN PEDRO APOSTOL	01975	\N	04d57c5c-390c-4334-bba9-d4635e1cb0c0	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	10	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	GAAD GROUP S.A.	Mar del Plata		480-9327	\N		\N	\N		t	\N	\N	\N
b91c1a55-8f51-4006-9ae1-dcc278d053a3	SANT ANTONIO	0974	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	A.B.H. PESQUERA  S.A.	Mar del Plata	4895032	489-6522	\N	operacionesconsultoramaritima@gmail.com.ar	\N	\N	Agencia Merlini	t	\N	\N	\N
412972d9-80c2-4345-9a3f-aa2d29532c11	SANTA BARBARA	5857	2409	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	56.96	1679	34aeab48-9c9b-4c06-8a45-3469f866cf88	PESCA ANGELA  S.A.	Mar del Plata		626-2236 /37	\N		\N	\N		t	\N	\N	\N
49f81da9-ff18-401a-9f1a-2b6372fbad1d	SANTA ANGELA	009	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	OSTRAMAR  S.A.	Mar del Plata		489-1959	\N		\N	\N		t	\N	\N	\N
09e5dde1-a169-4f8d-b0e3-dc4eb9677e0f	SCOMBRUS	0509	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	KALEU KALEU  S.A.	Ciudad Autónoma de Buenos Aires		011-3220-2130  / 5093-1215	\N		\N	\N		t	\N	\N	\N
f29321e0-4d64-48d1-b575-0e35cb4782bf	SCOMBRUS  II	02245	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	\N	\N	105b0349-a9ed-49bf-9336-aad8d3867f0b	HARENGUS  S.A.	Puerto Madryn		0280-445-0822	\N		\N	\N		t	\N	\N	\N
25ffca34-3c0f-44f2-bc05-4a30e28df4dc	SERMILIK	0505	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	\N	\N	105b0349-a9ed-49bf-9336-aad8d3867f0b	HARENGUS  S.A.	Puerto Madryn	4891553-154179360-154179860-154179062	0280-445-0822	\N	agenciasmiriglio@speedy.com.ar	\N	\N	Agencia Smiriglio	t	\N	\N	\N
61dd0857-0ee1-4469-9c3f-cdd9c82f8ef0	SHUNYO MARU 178	JA04	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	VIEIRA ARGENTINA  S.A.	Ciudad Autónoma de Buenos Aires			\N		\N	\N		t	\N	\N	\N
dc8e38b7-a2aa-4d8e-8cef-1949d0a3ffe5	SIEMPRE DON JOSE MOSCUZZA	02257	2460	bbebd1ff-edd5-48dd-925c-9735bb61b50d	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	38.00	1128	34aeab48-9c9b-4c06-8a45-3469f866cf88	FRESCOMAR ARGENTINA  S.A.	Mar del Plata		489-7287	\N		\N	\N		t	\N	\N	\N
c7acce82-8e2d-47b2-940f-48633fd755ad	SIEMPRE DON VICENTE	02654	2706	04d57c5c-390c-4334-bba9-d4635e1cb0c0	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	18.94	341	34aeab48-9c9b-4c06-8a45-3469f866cf88	PESQUERA VIRGEN DE ITATI  S.R.L.	Mar del Plata		480-2921	\N		\N	\N		t	\N	\N	\N
8b5f68e8-2e5d-47ac-9ffc-3f951ec2770f	SIEMPRE SANTA ROSA	0494	2476	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	27.80	548	34aeab48-9c9b-4c06-8a45-3469f866cf88	GIORNO  S.A.	Mar del Plata		410-0051 / 0057	\N		\N	\N		t	\N	\N	\N
fa2d4e51-8e48-4b80-bb12-27f53c1bbc45	SIEMPRE VIEJO PANCHO	2937	2755	04d57c5c-390c-4334-bba9-d4635e1cb0c0	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	15	17.98	601	\N					\N		\N	\N		t	\N	\N	\N
c89c450a-9ad9-405e-83a1-36bf29c5e3ac	SIMBAD	0754	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	SOUTH FISH  S.A.	Mar del Plata		480-5202	\N		\N	\N		t	\N	\N	\N
7c71c56e-11c0-4c1a-afe2-fea702449d49	SIRIUS	0905	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	LOBA PESQUERA  S.A.M.C.I.	Mar del Plata	4890960	489-0494  /  481-1814	\N	agencia@maritimavidal.com.ar	\N	\N	Agencia Maritima Vidal	t	\N	\N	\N
ddf1b6b7-a4c0-4dc3-92f9-d2dc4f47bdfc	SIRIUS III	0937	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	EL MARISCO  S.A.	Mar del Plata	4808331/4808332	489-0384	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
db33668a-ac43-44cb-9540-52bf9dc5a671	SOL MARINO	77	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	PESQUERA  20  DE NOVIEMBRE  S.A.	Ciudad Autónoma de Buenos Aires		011-4382-5011 / 4381-1337	\N		\N	\N		t	\N	\N	\N
8c841496-a25f-4b5e-8159-f202a48db7e5	STELLA MARIS 1°	0926	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	60	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	ALIMENPEZ  S.A.	Mar del Plata		461-9200	\N		\N	\N		t	\N	\N	\N
48e2ff50-023f-40fd-87a1-bcb523313aeb	SUEMAR	6186	2722	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	36.60	1168	105b0349-a9ed-49bf-9336-aad8d3867f0b	CONGELADORES PATAGONICOS  S.A.	Puerto Madryn		0280-445-6280	\N		\N	\N		t	\N	\N	\N
077a2e41-1ab0-4a19-93fd-41c01bdad428	SUEMAR DOS	01508	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	\N	\N	105b0349-a9ed-49bf-9336-aad8d3867f0b	CONGELADORES PATAGONICOS  S.A.	Puerto Madryn		0280-445-6280	\N		\N	\N		t	\N	\N	\N
1ab09fbb-0155-4a56-8034-16e4837d9c6c	SUMATRA	01105	2512	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	33.15	750	34aeab48-9c9b-4c06-8a45-3469f866cf88	CALME  S.A.	Mar del Plata		480-3545	\N		\N	\N		t	\N	\N	\N
e28b1bb8-dc55-4065-a241-383fc47a508c	SUR ESTE 501	01077	\N	a4a18385-067c-481b-97e9-56dc132240d8	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	SUR ESTE ARGEN  S.A.	Ciudad Autónoma de Buenos Aires		011-4816-7648 / 4372-7605	\N		\N	\N		t	\N	\N	\N
1a7ba8d1-3441-4561-949d-de977337400d	SUR ESTE 502	02201	2520	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	54.60	1670	11c64a29-e693-4bef-b734-8162f86cbbcc	SUR ESTE ARGEN  S.A.	Ciudad Autónoma de Buenos Aires		011-4816-7648 / 4372-7605	\N		\N	\N		t	\N	\N	\N
04f5f65d-e7d2-40c0-9ba0-30fbabec5615	SURIMI I	06143	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	FARO DEL SUR TRADING  S.A.	Ciudad Autónoma de Buenos Aires		011-4555-4956	\N		\N	\N		t	\N	\N	\N
2aa418f2-9de9-495c-8ebb-d4cf417dc21e	TABEIRON	02233	2529	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	40	34.15	889	11c64a29-e693-4bef-b734-8162f86cbbcc	VIEIRA ARGENTINA  S.A.	Ciudad Autónoma de Buenos Aires			\N		\N	\N		t	\N	\N	\N
4e578776-aa61-4041-a5de-7814ffe63035	TABEIRON DOS	02323	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	\N	\N	f41ff939-bc00-4bbd-8ce8-c451922ba284	PESQUERA DESEADO  S.A.	Puerto Deseado	54-11-65337853	0297-487-0884 / 0327 / 2407	\N		\N	\N	Natalia Cedrato	t	\N	\N	\N
610f4ee0-c90e-4857-af27-1e333a8aa1bf	Nº 75 TAE BAEK	02364	2138	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	55.70	1302	105b0349-a9ed-49bf-9336-aad8d3867f0b	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
5a093a48-254d-423f-91bc-7cc8cabc7d10	Nº 606 TAE BAEK	02361	2148	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	55.22	1036	11c64a29-e693-4bef-b734-8162f86cbbcc	ESAMAR  S.A.	Ciudad Autónoma de Buenos Aires		011-4393-8431	\N		\N	\N	54 – 9 - 1141714381	t	\N	\N	\N
692d1013-3f28-4d5f-934c-a013258c46ef	TAI SEI MARU N°8	02207	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	CORPORACION DEL ATLANTICO SUR  S.A.	Ciudad Autónoma de Buenos Aires		011-4105-1133 int 30	\N		\N	\N		t	\N	\N	\N
e23b91fc-22bf-4cbc-8dcd-778a8ca8f574	SAN MATIAS	0289	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	4167beb8-ce39-4fd3-8314-8b3487879d92	30	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	PESCA  ANTIGUA  S.A.	Mar del Plata		489-2340	\N		\N	\N		t	\N	\N	\N
43ed857e-e69f-467e-a977-3590327e0708	SCIROCCO	2574	2430	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	40	65.93	1589	34aeab48-9c9b-4c06-8a45-3469f866cf88	PESQUERA COMERCIAL  S.A.	Mar del Plata		489-3030	\N		\N	\N		t	\N	\N	\N
d90139c7-b316-4228-8bea-b47432cf51e2	SFIDA	01567	2439	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	4167beb8-ce39-4fd3-8314-8b3487879d92	30	26.50	624	34aeab48-9c9b-4c06-8a45-3469f866cf88	SAN JORGE S.A.	Mar del Plata		480-6611	\N		\N	\N		t	\N	\N	\N
3c111b3e-1c42-49b4-b579-168516f1dc1f	SOHO MARU 58	02611	2492	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	40	65.67	1776	f41ff939-bc00-4bbd-8ce8-c451922ba284	ARGENOVA  S.A.	Puerto Deseado		0297- 487-0550  (447-2818  Com. Riv )	\N		\N	\N		t	\N	\N	\N
246d498c-f08a-4cb4-a801-841d2f4d3df5	SIRIUS II	0936	2489	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	c1692b3c-2c33-4957-8bcb-208f45e4534b	30	59.25	1289	34aeab48-9c9b-4c06-8a45-3469f866cf88	EL MARISCO  S.A.	Mar del Plata	4890960	489-0384	\N	agencia@maritimavidal.com.ar	\N	\N	Agencia Maritima Vidal	t	\N	\N	\N
0b4157ee-a026-44f8-a1e6-1116535e2d26	TIAN YUAN	02173	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	CORPORACION DEL ATLANTICO SUR  S.A.	Ciudad Autónoma de Buenos Aires		011-4105-1133 int 30	\N		\N	\N		t	\N	\N	\N
e35f8610-22cd-4e58-89b4-84bfa82f68a3	TOBA MARU	0241	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	105b0349-a9ed-49bf-9336-aad8d3867f0b	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
9e5703f1-2438-4640-a445-9d7a843ac5a3	TORNYY	240	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	1f5e5c39-7fd2-4fb1-8697-d5e0e9a4022b	\N	30	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	CRUSTACEOS DEL SUR  S.A.	Ciudad Autónoma de Buenos Aires		011-5218-4287	\N		\N	\N		t	\N	\N	\N
e40ee692-dd27-4f9b-87ba-dc7b20ad103a	TRABAJAMOS	02904	2726	04d57c5c-390c-4334-bba9-d4635e1cb0c0	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	4	19.94	592	f41ff939-bc00-4bbd-8ce8-c451922ba284	DESEADO FISH  S.A.	Puerto Deseado			\N		\N	\N		t	\N	\N	\N
e22e8e02-9cbe-4d76-b41f-0e8c22ea3e15	UCHI	01901	2580	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	54.23	1552	11c64a29-e693-4bef-b734-8162f86cbbcc	PESQUERA SANTA ELENA S.A.I.C.	Ciudad Autónoma de Buenos Aires		011-4328-9909	\N		\N	\N		t	\N	\N	\N
f1a84c8a-5feb-4aa7-b233-4b31764a149e	UNION	01539	\N	04d57c5c-390c-4334-bba9-d4635e1cb0c0	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	10	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	RITORNO SALLUSTIO Y CICCIOTTI  S.A.	Mar del Plata		480-5508	\N		\N	\N		t	\N	\N	\N
e5699f88-21fe-4939-b71f-ca3b630a5a1a	URABAIN	0612	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	60	\N	\N	105b0349-a9ed-49bf-9336-aad8d3867f0b	IBERCONSA  DE ARGENTINA  S.A.	Puerto Madryn	mariano@maritimavidal.com.ar	0280-445-4324	\N		\N	\N	raul@maritimavidal.com.ar	t	\N	\N	\N
e514c52b-97fa-4ad2-b641-209075d86b82	VALIENTE II	0212A	2718	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	35.30	1001	34aeab48-9c9b-4c06-8a45-3469f866cf88	EXPLOTACION PESQ. DE LA PATAGONIA  S.A.	Mar del Plata		489-4624  /  489-0314 (astillero)	\N		\N	\N	agencia@maritimavidal.com.ar	t	\N	\N	\N
8469be80-7002-421a-ab82-e3f2598ea5d0	VERAZ	0144	2603	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	27.45	604	34aeab48-9c9b-4c06-8a45-3469f866cf88	PESQUERA VERAZ  S.A.	Mar del Plata		489-4624 / 489-0314 (astillero)	\N		\N	\N		t	\N	\N	\N
be2c657b-8113-47da-a3a7-5f5cfebd1dbf	VERONICA ALEJANDRA N	02292	2606	04d57c5c-390c-4334-bba9-d4635e1cb0c0	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	4	15.30	223	bea22adf-383f-4cc0-8c0b-bd514132fb77	FARO CHUBUT  S.R.L.	Rawson		0280-449-6311	\N		\N	\N		t	\N	\N	\N
ddfec106-6e47-411c-b2d4-adf1dd5b8746	VICTOR ANGELESCU	9798820	\N	1e6f3be0-9af3-40cf-8306-e1358231f214	\N	\N	\N	\N	\N	\N	INIDEP				\N		\N	\N		t	\N	\N	\N
629d964d-9ac3-4ee8-9a55-09d56fc7673f	VICTORIA DEL MAR 1°	0929	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	RIPSA  S.A. ( ROSALES INDUSTRIAL PESQ. )	Mar del Plata		489-7881	\N		\N	\N		t	\N	\N	\N
305c8108-ded6-455d-a6a5-1e0a21484f20	VICTORIA I	0554	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	\N	\N	105b0349-a9ed-49bf-9336-aad8d3867f0b	PEREIRA  ARGENTINA  S.A.	Puerto Madryn		0280-445-7377 / 447-2249	\N		\N	\N		t	\N	\N	\N
760287d4-30c2-445a-ad41-cd2dfc6564f5	VICTORIA II	0556	2611	991d17ee-9376-401c-8883-c0409127d0af	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	27.40	601	34aeab48-9c9b-4c06-8a45-3469f866cf88	CRESTAS  S.A.	Mar del Plata		410-5170	\N		\N	\N		t	\N	\N	\N
3f90c51b-044b-4e79-bd54-e12843faea49	VICTORIA P	02246	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	PESQUERA SANTA ELENA S.A.I.C.	Ciudad Autónoma de Buenos Aires		011-4328-9909	\N		\N	\N		t	\N	\N	\N
3bd2ac38-9e26-401a-9e80-80c27a57f9e6	VIEIRASA DIECIOCHO	2563	2615	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	67.78	1803	11c64a29-e693-4bef-b734-8162f86cbbcc	VIEIRA ARGENTINA  S.A.	Ciudad Autónoma de Buenos Aires			\N		\N	\N		t	\N	\N	\N
a85ab5c8-5b56-493d-a825-43ada90f6396	VIEIRASA DIECISEIS	0240	2616	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	36.13	702	11c64a29-e693-4bef-b734-8162f86cbbcc	VIEIRA ARGENTINA  S.A.	Ciudad Autónoma de Buenos Aires			\N		\N	\N		t	\N	\N	\N
419b6840-3a4c-4e03-95dd-ced646525de2	VIEIRASA QUINCE	0179	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	VIEIRA ARGENTINA  S.A.	Ciudad Autónoma de Buenos Aires			\N		\N	\N		t	\N	\N	\N
9962a6a8-0968-45c3-a7a3-12be0107769b	VIENTO DEL SUR	01858	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	60	\N	\N	f41ff939-bc00-4bbd-8ce8-c451922ba284	PESPASA  S.A.	Puerto Deseado		0297-487-2030  int 12	\N		\N	\N		t	\N	\N	\N
d934c9a4-f550-4b90-9dbd-6bf1b56d97ab	VILLARINO	02178	2629	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	64.50	1776	b1ec7a4f-f3e1-4ebc-8814-3951987690d7	PESCA AUSTRAL  S.A.	San Antonio Oeste		02934-49-2111	\N		\N	\N		t	\N	\N	\N
d213091a-9f2b-4b35-ba64-2b57a28e7069	VIRGEN DEL CARMEN	0550	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	MAR PURO  S.A.	Mar del Plata		451-1830	\N		\N	\N		t	\N	\N	\N
b3c5dd0f-33a9-457e-a73e-d4a7feb3ea1d	VIRGEN DEL MILAGRO	02767	2725	04d57c5c-390c-4334-bba9-d4635e1cb0c0	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	4	19.93	380	f41ff939-bc00-4bbd-8ce8-c451922ba284	UNION PESQUERA PATAGONIA  S.A.	Puerto Deseado			\N		\N	\N		t	\N	\N	\N
1bd67057-e996-4987-859b-486fe29cf4e7	VIRGEN DEL ROCIO	0194	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	\N	\N	105b0349-a9ed-49bf-9336-aad8d3867f0b	ALPESCA  S.A.	Puerto Madryn		0280-447-4958 / 45-1069	\N		\N	\N		t	\N	\N	\N
7f600131-a0a9-4257-bc7d-8461f73f8708	VIRGEN MARIA INMACULADA	0369	\N	04d57c5c-390c-4334-bba9-d4635e1cb0c0	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	10	\N	\N	\N					\N		\N	\N		t	\N	\N	\N
85c8d99b-103f-45ca-b786-9031f8664ff5	WIRON  IV	01476	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	TATURIELLO  S.A.	Mar del Plata		489-3833	\N		\N	\N		t	\N	\N	\N
54ba7518-621f-4152-93de-64a68fbe47bf	XIN SHI DAI N° 28	02165	2669	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	62.40	1579	11c64a29-e693-4bef-b734-8162f86cbbcc	MUELLE OCHO  S.A.	Ciudad Autónoma de Buenos Aires		011-4381-1337	\N		\N	\N		t	\N	\N	\N
f66e1f1b-90e1-4735-8859-0f6bc27bcaf2	XIN SHI JI 25	03092	2753	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	70.50	0	11c64a29-e693-4bef-b734-8162f86cbbcc	PESQUERA  20  DE NOVIEMBRE  S.A.	Ciudad Autónoma de Buenos Aires		011-4382-5011 / 4381-1337	\N		\N	\N		t	\N	\N	\N
c961b3c2-ee1e-4168-93e5-8f3e6ce121f0	XIN SHI JI N° 88	02182	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	FENIX  INTERNATIONAL  S.A.	Ciudad Autónoma de Buenos Aires		011-4381-1337	\N		\N	\N		t	\N	\N	\N
28951b47-241f-46bb-9aa3-97f42bd51686	UR ERTZA	0377	2587	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	c1692b3c-2c33-4957-8bcb-208f45e4534b	30	51.00	1482	34aeab48-9c9b-4c06-8a45-3469f866cf88	LUIS SOLIMENO e HIJOS  S.A.	Mar del Plata		489-3030	\N		\N	\N		t	\N	\N	\N
0956ea0a-4aa0-4aa0-a2ac-72e3732ff025	XEITOSIÑO	0403	2668	bbebd1ff-edd5-48dd-925c-9735bb61b50d	acea052d-e5d1-4ced-b98c-2d01eb79122a	4167beb8-ce39-4fd3-8314-8b3487879d92	60	51.72	1502	34aeab48-9c9b-4c06-8a45-3469f866cf88	PESQUERA EL NAZARENO	Mar del Plata		489-9414 (of. Pers. Emb.)	\N		\N	\N		t	\N	\N	\N
c6c6fcdc-e445-4e60-8a3f-a70b8e33aab7	VENTARRON 1º	0479	2708	bbebd1ff-edd5-48dd-925c-9735bb61b50d	acea052d-e5d1-4ced-b98c-2d01eb79122a	c1692b3c-2c33-4957-8bcb-208f45e4534b	60	63.07	1969	105b0349-a9ed-49bf-9336-aad8d3867f0b	ATUNERA  ARGENTINA  S.A.	Puerto Madryn		0280-445-4324	\N		\N	\N		t	\N	\N	\N
d623606d-b5f4-4a44-be99-7f1b7b891651	VALIENTE I	0211A	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	4167beb8-ce39-4fd3-8314-8b3487879d92	30	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	EXPLOTACION PESQ. DE LA PATAGONIA  S.A.	Mar del Plata		489-4624  /  489-0314 (astillero)	\N		\N	\N		t	\N	\N	\N
1abed229-2379-475a-aa42-f5799e65c9c8	TOZUDO	01219	2566	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	e16a6ea7-08d9-4891-b3ab-3ac866d647c2	30	26.74	624	34aeab48-9c9b-4c06-8a45-3469f866cf88	CABO VERDE  S.A.	Mar del Plata		489-4645	\N		\N	\N		t	\N	\N	\N
feea603c-78ed-43b9-85f3-27b6966506bd	VIEIRASA DIECISIETE	2568	2752	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	40	59.03	1401	11c64a29-e693-4bef-b734-8162f86cbbcc	VIEIRA ARGENTINA  S.A.	Ciudad Autónoma de Buenos Aires			\N		\N	\N		t	\N	\N	\N
57eeedea-6643-47ae-9017-be61cf330cb5	TESON	01541	2552	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	e16a6ea7-08d9-4891-b3ab-3ac866d647c2	30	25.97	765	34aeab48-9c9b-4c06-8a45-3469f866cf88	RITORNO SALLUSTIO Y CICCIOTTI  S.A.	Mar del Plata		480-5508	\N		\N	\N		t	\N	\N	\N
129a7390-74a6-453e-896e-309f65fed7c8	VERDEL	0174	2604	bbebd1ff-edd5-48dd-925c-9735bb61b50d	acea052d-e5d1-4ced-b98c-2d01eb79122a	c1692b3c-2c33-4957-8bcb-208f45e4534b	60	71.70	1975	5b1bcc08-58a5-499b-b2cc-d02d0df392fa	IBERMAR  S.A.	Bahia Blanca		0291-457-2427	\N		\N	\N		t	\N	\N	\N
196d90c9-4a16-4fac-98ca-948f955d17d2	TALISMAN	02263	2541	bbebd1ff-edd5-48dd-925c-9735bb61b50d	1f5e5c39-7fd2-4fb1-8697-d5e0e9a4022b	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	30	49.95	1302	11c64a29-e693-4bef-b734-8162f86cbbcc	CENTOMAR  S.A.	Ciudad Autónoma de Buenos Aires		011-4816-6245 / 6260  int  * 35	\N		\N	\N		t	\N	\N	\N
649e5ded-9a48-4bf8-aaa1-2edf147fe587	VIRGEN MARIA	0541	2645	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	c1692b3c-2c33-4957-8bcb-208f45e4534b	30	56.65	1803	34aeab48-9c9b-4c06-8a45-3469f866cf88	LUIS SOLIMENO e HIJOS  S.A.	Mar del Plata		489-3030	\N		\N	\N		t	\N	\N	\N
55ac100d-02dd-4499-b0e4-ca7bdd505c52	XIN SHI JI Nº 89	02903	2750	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	68.58	2685	11c64a29-e693-4bef-b734-8162f86cbbcc	FENIX  INTERNATIONAL  S.A.	Ciudad Autónoma de Buenos Aires		011-4381-1337	\N		\N	\N		t	\N	\N	\N
0c50d634-5765-4f61-9a9b-01a00736152f	XIN SHI JI Nº 91	02924	2724	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	68.58	2685	11c64a29-e693-4bef-b734-8162f86cbbcc	FENIX  INTERNATIONAL  S.A.	Ciudad Autónoma de Buenos Aires		011-4381-1337	\N		\N	\N		t	\N	\N	\N
5f71c718-f10e-4720-9e69-a5f19d3c30cb	XIN SHI JI Nº 92	02930	2742	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	68.58	2685	11c64a29-e693-4bef-b734-8162f86cbbcc	FENIX  INTERNATIONAL  S.A.	Ciudad Autónoma de Buenos Aires		011-4381-1337	\N		\N	\N		t	\N	\N	\N
f20c009f-47ce-4dfa-95ee-0d67138c2874	XIN SHI JI Nº 95	02933	2732	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	68.58	2685	11c64a29-e693-4bef-b734-8162f86cbbcc	PESQUERA  20  DE NOVIEMBRE  S.A.	Ciudad Autónoma de Buenos Aires	155-282636 - Facundo	011-4382-5011 / 4381-1337	\N		\N	\N	Agencia Di Yorio	t	\N	\N	\N
381c3f68-171d-4575-9e54-8373303438f3	XIN SHI JI N° 99	02181	2674	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	65.10	2173	11c64a29-e693-4bef-b734-8162f86cbbcc	FENIX  INTERNATIONAL  S.A.	Ciudad Autónoma de Buenos Aires		011-4381-1337	\N		\N	\N		t	\N	\N	\N
62f028cf-f8a1-4bea-9581-d7102c837e07	XIN SHI JI Nº 98	02995	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	PESQUERA  20  DE NOVIEMBRE  S.A.	Ciudad Autónoma de Buenos Aires		011-4382-5011 / 4381-1337	\N		\N	\N		t	\N	\N	\N
3a58a169-bafc-44cd-9737-e7638a4e8cb2	YAMATO	077	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	60	\N	\N	b8a55941-9f65-4e90-bea1-3683753d42b5	PESANTAR  S.A. ( Empresa Pesq de la Patagonia y Antartida )	Ushuaia		02901-43-3449 / 43-0008 / 43-0708	\N		\N	\N		t	\N	\N	\N
de43cde0-731f-465c-b5d2-aa44336fdd94	YENU	0498A	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	\N	\N	5b1bcc08-58a5-499b-b2cc-d02d0df392fa	MARITIMA MONACHESI  S.A.	Bahia Blanca		0291-452-5913	\N		\N	\N		t	\N	\N	\N
66ec6bbc-73ad-49f5-8c7c-c347d6efa253	YOKO MARU	UY252	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	EMPESUR  S.A.	Ciudad Autónoma de Buenos Aires		011-4312-0123	\N		\N	\N		t	\N	\N	\N
8935f6da-e153-4a25-9426-4b375453d9fe	ZHOU YU YI HAO	CH251	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	VIEIRA ARGENTINA  S.A.	Ciudad Autónoma de Buenos Aires			\N		\N	\N		t	\N	\N	\N
4f75a080-0d2a-4778-98d8-51734f69f160	MAR ARGENTINO	9883833	\N	1e6f3be0-9af3-40cf-8306-e1358231f214	\N	\N	\N	\N	\N	\N	INIDEP				\N		\N	\N		t	\N	\N	\N
f0cfd06a-b006-4dc5-ada1-3a7e9ba760ad	TAI AN	1530	2533	bbebd1ff-edd5-48dd-925c-9735bb61b50d	acea052d-e5d1-4ced-b98c-2d01eb79122a	92d9acc2-3590-474f-a773-73e8af728e83	60	100.50	4506	11c64a29-e693-4bef-b734-8162f86cbbcc	PRODESUR S.A	Ciudad Autónoma de Buenos Aires		492-2216 / 492-0450	\N		\N	\N	54 – 9 - 1141714381	t	\N	\N	\N
0ddb5663-8ab9-4ad5-ab76-fb98b2e5d15d	CAPESANTE	02929	2723	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	6af901f6-bd7d-4bc7-8c9d-f441e526e65c	40	50.15	2550	34aeab48-9c9b-4c06-8a45-3469f866cf88	GLACIAR PESQUERA  S.A.	Mar del Plata		492-2216	\N		\N	\N		t	\N	\N	\N
69ff7a7d-9417-4f5c-9693-8e2835fef39b	ECHIZEN MARU	0326	1495	bbebd1ff-edd5-48dd-925c-9735bb61b50d	acea052d-e5d1-4ced-b98c-2d01eb79122a	92d9acc2-3590-474f-a773-73e8af728e83	60	89.59	4702	b8a55941-9f65-4e90-bea1-3683753d42b5	PESANTAR  S.A. ( Empresa Pesq de la Patagonia y Antartida )	Ushuaia		02901-43-3449 / 43-0008 / 43-0708	\N		\N	\N		t	\N	\N	\N
49144ac0-7330-40cf-8ed7-3dd909542a0e	TANGO II	02791	2714	bbebd1ff-edd5-48dd-925c-9735bb61b50d	1f5e5c39-7fd2-4fb1-8697-d5e0e9a4022b	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	30	50.40	1302	11c64a29-e693-4bef-b734-8162f86cbbcc	BENTONICOS DE ARGENTINA  S.A.	Ciudad Autónoma de Buenos Aires	4891227	011-5258-2400 / 4407-8240	\N	serviciosmaritimosmdq@gmail.com	\N	\N	Servicios maritimos	t	\N	\N	\N
adc23180-9487-47ad-9e3d-62eade83623a	TANGO I	02724	2709	bbebd1ff-edd5-48dd-925c-9735bb61b50d	1f5e5c39-7fd2-4fb1-8697-d5e0e9a4022b	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	30	50.40	1302	11c64a29-e693-4bef-b734-8162f86cbbcc	BENTONICOS DE ARGENTINA  S.A.	Ciudad Autónoma de Buenos Aires		011-5258-2400 / 4407-8240	\N		\N	\N		t	\N	\N	\N
863ff4de-02ab-477a-b726-83d3e9148648	ARGENOVA XXI	02661	2704	bbebd1ff-edd5-48dd-925c-9735bb61b50d	acea052d-e5d1-4ced-b98c-2d01eb79122a	92d9acc2-3590-474f-a773-73e8af728e83	60	55.80	1826	f41ff939-bc00-4bbd-8ce8-c451922ba284	ARGENOVA  S.A.	Puerto Deseado	4808331/4808332	0297- 487-0550  (447-2818  Com. Riv )	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
546c200e-da22-4c78-8c7d-cbdeab4535cd	HOYO MARU 37	JA01	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	40	\N	\N	f41ff939-bc00-4bbd-8ce8-c451922ba284	ARGENOVA  S.A.	Puerto Deseado		0297- 487-0550  (447-2818  Com. Riv )	\N		\N	\N		t	\N	\N	\N
8efda3ce-fc8d-49b0-8e1b-74751bb52960	LU QING YUAN YU 288	3142	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	\N	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	\N	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88			\N	\N	\N	\N			\N	t	\N	\N	
5aea6ce4-ca56-4bb7-83dc-071dd9161524	MYRDOMA F	02771	2735	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	4167beb8-ce39-4fd3-8314-8b3487879d92	30	38.55	1430	105b0349-a9ed-49bf-9336-aad8d3867f0b	LANZAR S.A.	Puerto Madryn	4800005	0280-445-6280	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
e157b89c-77da-4efc-936a-642f986b9147	PONTE CORUXO	0975	2242	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	c1692b3c-2c33-4957-8bcb-208f45e4534b	30	52.85	1383	34aeab48-9c9b-4c06-8a45-3469f866cf88	BAL - FISH  S.A.	Mar del Plata		489-6522	\N		\N	\N		t	\N	\N	\N
82d93396-176a-4d74-a5de-5addaf47520f	MINTA	02196	2050	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	40	65.10	1603	11c64a29-e693-4bef-b734-8162f86cbbcc	LIYA  S.A.	Ciudad Autónoma de Buenos Aires		011-4964-2227	\N		\N	\N		t	\N	\N	\N
83a5f4d8-12bb-48e4-8b31-6fda9cd9eb5f	NAVEGANTES III	02065	2081	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	40	68.60	2203	34aeab48-9c9b-4c06-8a45-3469f866cf88	PESQUERA COMERCIAL  S.A.	Mar del Plata	4800274	489-3030	\N	amalfitanoycia@hotmail.com	\N	\N	Agencia Maritima Almafitano	t	\N	\N	\N
b88d3a8d-a83a-4a6b-a566-85bf97fb3fb7	CERES	01420	1281	bbebd1ff-edd5-48dd-925c-9735bb61b50d	acea052d-e5d1-4ced-b98c-2d01eb79122a	c1692b3c-2c33-4957-8bcb-208f45e4534b	60	60.74	1969	34aeab48-9c9b-4c06-8a45-3469f866cf88	PESQUERA CERES  S.A.	Mar del Plata		410-0051 / 7	\N		\N	\N		t	\N	\N	\N
12964f37-2ef3-4932-9d34-b7ec4410c90b	DON LUIS I	02093	1445	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	40	67.95	1803	34aeab48-9c9b-4c06-8a45-3469f866cf88	PESQUERA CERES  S.A.	Mar del Plata		410-0051 / 7	\N		\N	\N		t	\N	\N	\N
2ea49417-f407-4cad-8214-3f84ef261e65	MARGOT	0360	1976	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	c1692b3c-2c33-4957-8bcb-208f45e4534b	30	58.75	1481	34aeab48-9c9b-4c06-8a45-3469f866cf88	GIORNO  S.A.	Mar del Plata	4800005	410-0051 / 0057	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
9feec5a5-4b57-4bd9-98ed-770ea7509a63	LUCA MARIO	0546	2715	bbebd1ff-edd5-48dd-925c-9735bb61b50d	acea052d-e5d1-4ced-b98c-2d01eb79122a	c1692b3c-2c33-4957-8bcb-208f45e4534b	60	79.14	3952	34aeab48-9c9b-4c06-8a45-3469f866cf88	PESCASOL  S.A.	Mar del Plata	4800274	480-9608 / 481-0464	\N	amalfitanoycia@hotmail.com	\N	\N	Agencia Maritima Almafitano	t	\N	\N	\N
7133431c-daa5-4b41-a710-a3f8fa9bc6f5	ALVAREZ ENTRENA V	2279	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	4167beb8-ce39-4fd3-8314-8b3487879d92	30	\N	\N	\N	CONARPESA S.A.	Puerto Madryn	\N	\N	\N	\N			\N	t	\N	\N	
9a35efaa-cc4c-4fb6-afaa-f48e7709c800	ARBUMASA XXVII	02057	1128	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	40	64.21	1154	34aeab48-9c9b-4c06-8a45-3469f866cf88	BAL - FISH  S.A.	Mar del Plata		489-6522	\N		\N	\N		t	\N	\N	\N
73c502e2-397a-499f-b4f7-cb8dce8260b7	JOSE MARCELO	3138	2764	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	4167beb8-ce39-4fd3-8314-8b3487879d92	30	39.94	0	34aeab48-9c9b-4c06-8a45-3469f866cf88	PEDRO MOSCUZZA e HIJOS  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
a12653df-c0ca-4814-8442-78636dfa6d94	DON PEDRO	068	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	acea052d-e5d1-4ced-b98c-2d01eb79122a	c1692b3c-2c33-4957-8bcb-208f45e4534b	60	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	PEDRO MOSCUZZA e HIJOS  S.A.	Mar del Plata		489-7287	\N		\N	\N		t	\N	\N	\N
a55f3785-99ec-4342-84b4-1920e07cbda0	ARBUMASA XXVIII	02569	1129	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	40	64.40	1776	f41ff939-bc00-4bbd-8ce8-c451922ba284	ARBUMASA  S.A.	Puerto Deseado		0297-487-2807 / 444-5338 / 444-1201	\N		\N	\N		t	\N	\N	\N
6a4b71d5-4789-40b2-b402-f0e266a9fdd7	HOLMBERG	7918189	\N	1e6f3be0-9af3-40cf-8306-e1358231f214	\N	6af901f6-bd7d-4bc7-8c9d-f441e526e65c	\N	\N	\N	\N	INIDEP				\N		\N	\N		t	\N	\N	\N
4a837a56-b513-4568-b2d7-61bc1d66d22b	MISS TIDE	02439	2056	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	6af901f6-bd7d-4bc7-8c9d-f441e526e65c	30	52.52	2254	34aeab48-9c9b-4c06-8a45-3469f866cf88	WANCHESE ARGENTINA  S.A.	Mar del Plata		489-1236	\N		\N	\N		t	\N	\N	\N
2df50464-9916-4b3e-b5c3-3a645623d525	ATLANTIC SURF III	02030	1176	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	6af901f6-bd7d-4bc7-8c9d-f441e526e65c	60	49.60	3020	34aeab48-9c9b-4c06-8a45-3469f866cf88	GLACIAR PESQUERA  S.A.	Mar del Plata	4800274	492-2216	\N	amalfitanoycia@hotmail.com	\N	\N	Agencia Maritima Almafitano	t	\N	\N	\N
728cb01c-9ba3-4d4e-baf1-4c14f3b40e35	PRINCIPE AZUL	TEMP-0006	\N	04d57c5c-390c-4334-bba9-d4635e1cb0c0	acea052d-e5d1-4ced-b98c-2d01eb79122a	822d18e6-569a-40fc-a58f-429b6bef4613	10	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88		Mar del Plata			\N		\N	\N		t	\N	\N	\N
e70330eb-bcaf-472c-9906-1096de4235dd	DUKAT	02775	2712	bbebd1ff-edd5-48dd-925c-9735bb61b50d	1f5e5c39-7fd2-4fb1-8697-d5e0e9a4022b	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	30	50.80	1302	11c64a29-e693-4bef-b734-8162f86cbbcc	CRUSTACEOS DEL SUR  S.A.	Ciudad Autónoma de Buenos Aires		011-5218-4287	\N		\N	\N		t	\N	\N	\N
5fa98bd7-f095-4d3e-8e98-7761568ec108	ERIN BRUCE II	TEMP-0002	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	6af901f6-bd7d-4bc7-8c9d-f441e526e65c	45	\N	\N	\N					\N		\N	\N		t	\N	\N	\N
4c346349-604d-4835-9682-3f7ab65c240d	Hai Xiang 17	LW3286	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	40	\N	\N	\N	PESQUERA RÍO QUEQUEN				\N		\N	\N		t	\N	\N	\N
\.


--
-- Data for Name: capturas; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.capturas (id, lance_id, especie_id, kg_captura, kg_descarte, observaciones_captura, indice_original) FROM stdin;
\.


--
-- Data for Name: error_logs; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.error_logs (id, "timestamp", level, source, context, "userId", "userEmail", message, stack, detail, path, method, ip) FROM stdin;
d1c2d6b9-4aef-4539-a2d0-a1344bb908b0	2026-01-14 01:26:28.979+00	ERROR	BACKEND	GlobalExceptionFilter	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	admin@obs.com	Marea no encontrada	NotFoundException: Marea no encontrada\n    at MareasService.findOne (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\mareas\\mareas.service.ts:72:27)\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:46:28\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-proxy.js:9:17	{"query": {}, "params": {"id": "bb26bbcb-ee6d-4370-9c16-84f03d8d362b"}, "exception": {"error": "Not Found", "message": "Marea no encontrada", "statusCode": 404}}	/api/mareas/bb26bbcb-ee6d-4370-9c16-84f03d8d362b	GET	::1
8da3d867-25fb-4973-9124-90f8f399352d	2026-01-14 01:28:54.114+00	ERROR	BACKEND	GlobalExceptionFilter	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	admin@obs.com	Marea no encontrada	NotFoundException: Marea no encontrada\n    at MareasService.findOne (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\mareas\\mareas.service.ts:72:27)\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:46:28\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-proxy.js:9:17	{"query": {}, "params": {"id": "bb26bbcb-ee6d-4370-9c16-84f03d8d362b"}, "exception": {"error": "Not Found", "message": "Marea no encontrada", "statusCode": 404}}	/api/mareas/bb26bbcb-ee6d-4370-9c16-84f03d8d362b	GET	::1
b5124144-2981-4ec6-9c81-bbe9332de56f	2026-01-14 01:33:12.744+00	ERROR	BACKEND	GlobalExceptionFilter	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	admin@obs.com	Marea no encontrada	NotFoundException: Marea no encontrada\n    at MareasService.findOne (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\mareas\\mareas.service.ts:72:27)\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:46:28\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-proxy.js:9:17	{"query": {}, "params": {"id": "bb26bbcb-ee6d-4370-9c16-84f03d8d362b"}, "exception": {"error": "Not Found", "message": "Marea no encontrada", "statusCode": 404}}	/api/mareas/bb26bbcb-ee6d-4370-9c16-84f03d8d362b	GET	::1
7fe037ae-2ede-41c2-9cda-d589fd882712	2026-01-14 01:33:36.292+00	ERROR	BACKEND	GlobalExceptionFilter	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	admin@obs.com	Marea no encontrada	NotFoundException: Marea no encontrada\n    at MareasService.findOne (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\mareas\\mareas.service.ts:72:27)\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:46:28\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-proxy.js:9:17	{"query": {}, "params": {"id": "bb26bbcb-ee6d-4370-9c16-84f03d8d362b"}, "exception": {"error": "Not Found", "message": "Marea no encontrada", "statusCode": 404}}	/api/mareas/bb26bbcb-ee6d-4370-9c16-84f03d8d362b	GET	::1
c31df7ac-2f2f-4e46-a1fe-cff0fe536f6e	2026-01-14 00:41:38.83+00	ERROR	BACKEND	GlobalExceptionFilter	\N	\N	Token de refresco inválido o expirado	UnauthorizedException: Token de refresco inválido o expirado\n    at AuthService.refreshAuth (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\auth\\auth.service.ts:230:13)\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async AuthController.refreshAuth (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\auth\\auth.controller.ts:58:18)\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:46:28\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-proxy.js:9:17	{"query": {}, "params": {}, "exception": {"error": "Unauthorized", "message": "Token de refresco inválido o expirado", "statusCode": 401}}	/api/auth/refresh	GET	::1
87ac2fea-7df3-48b0-a645-03036d8e36ab	2026-01-14 01:06:49.915+00	ERROR	BACKEND	GlobalExceptionFilter	\N	\N	Token de refresco inválido o expirado	UnauthorizedException: Token de refresco inválido o expirado\n    at AuthService.refreshAuth (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\auth\\auth.service.ts:230:13)\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async AuthController.refreshAuth (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\auth\\auth.controller.ts:58:18)\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:46:28\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-proxy.js:9:17	{"query": {}, "params": {}, "exception": {"error": "Unauthorized", "message": "Token de refresco inválido o expirado", "statusCode": 401}}	/api/auth/refresh	GET	::1
cc8a9479-eb55-41e3-8d39-debe49562bc4	2026-01-14 01:18:51.437+00	ERROR	BACKEND	GlobalExceptionFilter	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	admin@obs.com	Marea no encontrada	NotFoundException: Marea no encontrada\n    at MareasService.findOne (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\mareas\\mareas.service.ts:72:27)\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:46:28\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-proxy.js:9:17	{"query": {}, "params": {"id": "29b952e7-e297-4266-9291-8620c4ac7f07"}, "exception": {"error": "Not Found", "message": "Marea no encontrada", "statusCode": 404}}	/api/mareas/29b952e7-e297-4266-9291-8620c4ac7f07	GET	::1
6a37e548-ed1f-4736-a224-77b38c80e847	2026-01-14 01:19:25.04+00	ERROR	BACKEND	GlobalExceptionFilter	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	admin@obs.com	Marea no encontrada	NotFoundException: Marea no encontrada\n    at MareasService.findOne (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\mareas\\mareas.service.ts:72:27)\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:46:28\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-proxy.js:9:17	{"query": {}, "params": {"id": "29b952e7-e297-4266-9291-8620c4ac7f07"}, "exception": {"error": "Not Found", "message": "Marea no encontrada", "statusCode": 404}}	/api/mareas/29b952e7-e297-4266-9291-8620c4ac7f07	GET	::1
1f52fabd-13e4-4fc7-b2dc-7a813f708213	2026-01-14 01:19:35.549+00	ERROR	BACKEND	GlobalExceptionFilter	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	admin@obs.com	Marea no encontrada	NotFoundException: Marea no encontrada\n    at MareasService.findOne (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\mareas\\mareas.service.ts:72:27)\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:46:28\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-proxy.js:9:17	{"query": {}, "params": {"id": "bb26bbcb-ee6d-4370-9c16-84f03d8d362b"}, "exception": {"error": "Not Found", "message": "Marea no encontrada", "statusCode": 404}}	/api/mareas/bb26bbcb-ee6d-4370-9c16-84f03d8d362b	GET	::1
4820b238-0f38-4870-b78d-4e5ddaf8df44	2026-01-14 01:21:38.643+00	ERROR	BACKEND	GlobalExceptionFilter	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	admin@obs.com	Marea no encontrada	NotFoundException: Marea no encontrada\n    at MareasService.findOne (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\mareas\\mareas.service.ts:72:27)\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:46:28\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-proxy.js:9:17	{"query": {}, "params": {"id": "bb26bbcb-ee6d-4370-9c16-84f03d8d362b"}, "exception": {"error": "Not Found", "message": "Marea no encontrada", "statusCode": 404}}	/api/mareas/bb26bbcb-ee6d-4370-9c16-84f03d8d362b	GET	::1
da4f3aa4-80c8-401f-a737-3e35d85c32e9	2026-01-14 01:22:24.014+00	ERROR	BACKEND	GlobalExceptionFilter	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	admin@obs.com	Marea no encontrada	NotFoundException: Marea no encontrada\n    at MareasService.findOne (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\mareas\\mareas.service.ts:72:27)\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:46:28\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-proxy.js:9:17	{"query": {}, "params": {"id": "424cd44c-1238-4a44-8b91-f642c33169e4"}, "exception": {"error": "Not Found", "message": "Marea no encontrada", "statusCode": 404}}	/api/mareas/424cd44c-1238-4a44-8b91-f642c33169e4	GET	::1
5344fba4-ed28-4d41-af4e-2fd973374dcc	2026-01-14 03:14:34.513+00	ERROR	BACKEND	GlobalExceptionFilter	\N	\N	No valid Refresh Token found	UnauthorizedException: No valid Refresh Token found\n    at AuthController.refreshAuth (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\auth\\auth.controller.ts:56:30)\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:38:29\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:46:28\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-proxy.js:9:17	{"query": {}, "params": {}, "exception": {"error": "Unauthorized", "message": "No valid Refresh Token found", "statusCode": 401}}	/api/auth/refresh	GET	::1
df1130c4-ec59-418b-ac8c-b7520cb69132	2026-01-14 20:31:21.835+00	ERROR	BACKEND	GlobalExceptionFilter	\N	\N	No valid Refresh Token found	UnauthorizedException: No valid Refresh Token found\n    at AuthController.refreshAuth (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\auth\\auth.controller.ts:56:30)\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:38:29\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:46:28\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-proxy.js:9:17	{"query": {}, "params": {}, "exception": {"error": "Unauthorized", "message": "No valid Refresh Token found", "statusCode": 401}}	/api/auth/refresh	GET	::1
6e642606-db1f-4f1b-ba7c-b31158faf053	2026-01-15 18:57:31.12+00	ERROR	BACKEND	GlobalExceptionFilter	20feb9da-69af-4b7e-9f9f-47ec73ae954f	danieldt2000@hotmail.com	Marea no encontrada	NotFoundException: Marea no encontrada\n    at MareasService.findOne (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\mareas\\mareas.service.ts:72:27)\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:46:28\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-proxy.js:9:17	{"query": {}, "params": {"id": "29b952e7-e297-4266-9291-8620c4ac7f07"}, "exception": {"error": "Not Found", "message": "Marea no encontrada", "statusCode": 404}}	/api/mareas/29b952e7-e297-4266-9291-8620c4ac7f07	GET	::1
a65d1ac2-2fae-45b3-8aa7-7120c2849fb2	2026-01-16 21:33:51.829+00	ERROR	BACKEND	GlobalExceptionFilter	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	admin@obs.com	Bad Request Exception	BadRequestException: Bad Request Exception\n    at ValidationPipe.exceptionFactory (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+common@11.1.10_clas_ef3082dcd13cc376fcae0bf4ef553349\\node_modules\\@nestjs\\common\\pipes\\validation.pipe.js:107:20)\n    at ValidationPipe.transform (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+common@11.1.10_clas_ef3082dcd13cc376fcae0bf4ef553349\\node_modules\\@nestjs\\common\\pipes\\validation.pipe.js:74:30)\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async resolveParamValue (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:148:23)\n    at async Promise.all (index 1)\n    at async pipesFn (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:151:13)\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:37:30\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:46:28\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-proxy.js:9:17	{"body": {"arteId": "57d68d17-afe4-47b5-baf5-4e4791069319", "etapas": [{"id": null, "nroEtapa": 1, "tipoEtapa": "COMERCIAL", "fechaArribo": "2024-04-16T15:40:00.000Z", "pesqueriaId": "543aa4a7-f29e-4c08-b04f-62377d3cc0e6", "fechaZarpada": "2024-03-21T10:05:00.000Z", "observaciones": "Importado desde sistema externo", "puertoArriboId": "", "puertoZarpadaId": ""}], "buqueId": "546c200e-da22-4c78-8c7d-cbdeab4535cd", "nroMarea": 45, "anioMarea": 2024, "tipoMarea": "COMERCIAL", "pesqueriaId": "543aa4a7-f29e-4c08-b04f-62377d3cc0e6", "observadorId": "0ba0a4ea-eaa3-4d11-b737-5f80e0651fb5", "diasEstimados": 40, "fechaZarpadaEstimada": "2024-03-21T10:05:00.000Z"}, "query": {}, "params": {}, "exception": {"error": "Bad Request", "message": ["property etapas should not exist"], "statusCode": 400}}	/api/mareas	POST	::1
a0be134a-4d3f-4984-b71d-167b68110074	2026-01-16 21:34:23.295+00	ERROR	BACKEND	GlobalExceptionFilter	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	admin@obs.com	Bad Request Exception	BadRequestException: Bad Request Exception\n    at ValidationPipe.exceptionFactory (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+common@11.1.10_clas_ef3082dcd13cc376fcae0bf4ef553349\\node_modules\\@nestjs\\common\\pipes\\validation.pipe.js:107:20)\n    at ValidationPipe.transform (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+common@11.1.10_clas_ef3082dcd13cc376fcae0bf4ef553349\\node_modules\\@nestjs\\common\\pipes\\validation.pipe.js:74:30)\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async resolveParamValue (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:148:23)\n    at async Promise.all (index 1)\n    at async pipesFn (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:151:13)\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:37:30\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:46:28\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-proxy.js:9:17	{"body": {"arteId": "57d68d17-afe4-47b5-baf5-4e4791069319", "etapas": [{"id": null, "nroEtapa": 1, "tipoEtapa": "COMERCIAL", "fechaArribo": "2024-04-16T15:40:00.000Z", "pesqueriaId": "543aa4a7-f29e-4c08-b04f-62377d3cc0e6", "fechaZarpada": "2024-03-21T10:05:00.000Z", "observaciones": "Importado desde sistema externo", "puertoArriboId": "34aeab48-9c9b-4c06-8a45-3469f866cf88", "puertoZarpadaId": "34aeab48-9c9b-4c06-8a45-3469f866cf88"}], "buqueId": "546c200e-da22-4c78-8c7d-cbdeab4535cd", "nroMarea": 45, "anioMarea": 2024, "tipoMarea": "COMERCIAL", "pesqueriaId": "543aa4a7-f29e-4c08-b04f-62377d3cc0e6", "observadorId": "0ba0a4ea-eaa3-4d11-b737-5f80e0651fb5", "diasEstimados": 40, "fechaZarpadaEstimada": "2024-03-21T10:05:00.000Z"}, "query": {}, "params": {}, "exception": {"error": "Bad Request", "message": ["property etapas should not exist"], "statusCode": 400}}	/api/mareas	POST	::1
f3db8387-7e15-471e-8455-cb244f3f87b8	2026-01-16 21:34:25.926+00	ERROR	BACKEND	GlobalExceptionFilter	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	admin@obs.com	Bad Request Exception	BadRequestException: Bad Request Exception\n    at ValidationPipe.exceptionFactory (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+common@11.1.10_clas_ef3082dcd13cc376fcae0bf4ef553349\\node_modules\\@nestjs\\common\\pipes\\validation.pipe.js:107:20)\n    at ValidationPipe.transform (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+common@11.1.10_clas_ef3082dcd13cc376fcae0bf4ef553349\\node_modules\\@nestjs\\common\\pipes\\validation.pipe.js:74:30)\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async resolveParamValue (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:148:23)\n    at async Promise.all (index 1)\n    at async pipesFn (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:151:13)\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:37:30\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:46:28\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-proxy.js:9:17	{"body": {"arteId": "57d68d17-afe4-47b5-baf5-4e4791069319", "etapas": [{"id": null, "nroEtapa": 1, "tipoEtapa": "COMERCIAL", "fechaArribo": "2024-04-16T15:40:00.000Z", "pesqueriaId": "543aa4a7-f29e-4c08-b04f-62377d3cc0e6", "fechaZarpada": "2024-03-21T10:05:00.000Z", "observaciones": "Importado desde sistema externo", "puertoArriboId": "34aeab48-9c9b-4c06-8a45-3469f866cf88", "puertoZarpadaId": "34aeab48-9c9b-4c06-8a45-3469f866cf88"}], "buqueId": "546c200e-da22-4c78-8c7d-cbdeab4535cd", "nroMarea": 45, "anioMarea": 2024, "tipoMarea": "COMERCIAL", "pesqueriaId": "543aa4a7-f29e-4c08-b04f-62377d3cc0e6", "observadorId": "0ba0a4ea-eaa3-4d11-b737-5f80e0651fb5", "diasEstimados": 40, "fechaZarpadaEstimada": "2024-03-21T10:05:00.000Z"}, "query": {}, "params": {}, "exception": {"error": "Bad Request", "message": ["property etapas should not exist"], "statusCode": 400}}	/api/mareas	POST	::1
a6c67b11-775b-4a8e-b040-7b2a8f5eecb1	2026-01-16 21:34:54.05+00	ERROR	BACKEND	GlobalExceptionFilter	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	admin@obs.com	Bad Request Exception	BadRequestException: Bad Request Exception\n    at ValidationPipe.exceptionFactory (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+common@11.1.10_clas_ef3082dcd13cc376fcae0bf4ef553349\\node_modules\\@nestjs\\common\\pipes\\validation.pipe.js:107:20)\n    at ValidationPipe.transform (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+common@11.1.10_clas_ef3082dcd13cc376fcae0bf4ef553349\\node_modules\\@nestjs\\common\\pipes\\validation.pipe.js:74:30)\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async resolveParamValue (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:148:23)\n    at async Promise.all (index 1)\n    at async pipesFn (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:151:13)\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:37:30\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:46:28\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-proxy.js:9:17	{"body": {"arteId": "57d68d17-afe4-47b5-baf5-4e4791069319", "etapas": [{"id": null, "nroEtapa": 1, "tipoEtapa": "COMERCIAL", "fechaArribo": "2024-04-16T15:40:00.000Z", "pesqueriaId": "543aa4a7-f29e-4c08-b04f-62377d3cc0e6", "fechaZarpada": "2024-03-21T10:05:00.000Z", "observaciones": "Importado desde sistema externo", "puertoArriboId": "34aeab48-9c9b-4c06-8a45-3469f866cf88", "puertoZarpadaId": "34aeab48-9c9b-4c06-8a45-3469f866cf88"}], "buqueId": "546c200e-da22-4c78-8c7d-cbdeab4535cd", "nroMarea": 45, "anioMarea": 2024, "tipoMarea": "COMERCIAL", "pesqueriaId": "543aa4a7-f29e-4c08-b04f-62377d3cc0e6", "observadorId": "0ba0a4ea-eaa3-4d11-b737-5f80e0651fb5", "diasEstimados": 40, "fechaZarpadaEstimada": "2024-03-21T10:05:00.000Z"}, "query": {}, "params": {}, "exception": {"error": "Bad Request", "message": ["property etapas should not exist"], "statusCode": 400}}	/api/mareas	POST	::1
1cb7c310-a553-4ef5-b2a5-62600cdc727d	2026-01-16 21:38:33.652+00	ERROR	BACKEND	GlobalExceptionFilter	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	admin@obs.com	Bad Request Exception	BadRequestException: Bad Request Exception\n    at ValidationPipe.exceptionFactory (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+common@11.1.10_clas_ef3082dcd13cc376fcae0bf4ef553349\\node_modules\\@nestjs\\common\\pipes\\validation.pipe.js:107:20)\n    at ValidationPipe.transform (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+common@11.1.10_clas_ef3082dcd13cc376fcae0bf4ef553349\\node_modules\\@nestjs\\common\\pipes\\validation.pipe.js:74:30)\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async resolveParamValue (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:148:23)\n    at async Promise.all (index 1)\n    at async pipesFn (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:151:13)\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:37:30\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:46:28\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-proxy.js:9:17	{"body": {"arteId": "57d68d17-afe4-47b5-baf5-4e4791069319", "etapas": [{"id": null, "nroEtapa": 1, "tipoEtapa": "COMERCIAL", "fechaArribo": "2024-04-16T15:40:00.000Z", "pesqueriaId": "543aa4a7-f29e-4c08-b04f-62377d3cc0e6", "fechaZarpada": "2024-03-21T10:05:00.000Z", "observaciones": "Importado desde sistema externo", "puertoArriboId": "", "puertoZarpadaId": ""}], "buqueId": "546c200e-da22-4c78-8c7d-cbdeab4535cd", "nroMarea": 45, "anioMarea": 2024, "tipoMarea": "COMERCIAL", "pesqueriaId": "543aa4a7-f29e-4c08-b04f-62377d3cc0e6", "observadorId": "0ba0a4ea-eaa3-4d11-b737-5f80e0651fb5", "diasEstimados": 40, "fechaZarpadaEstimada": "2024-03-21T10:05:00.000Z"}, "query": {}, "params": {}, "exception": {"error": "Bad Request", "message": ["property etapas should not exist"], "statusCode": 400}}	/api/mareas	POST	::1
1ac61b75-0ef3-46d5-b841-58e4ffe8266f	2026-01-16 21:43:05.569+00	ERROR	BACKEND	GlobalExceptionFilter	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	admin@obs.com	Bad Request Exception	BadRequestException: Bad Request Exception\n    at ValidationPipe.exceptionFactory (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+common@11.1.10_clas_ef3082dcd13cc376fcae0bf4ef553349\\node_modules\\@nestjs\\common\\pipes\\validation.pipe.js:107:20)\n    at ValidationPipe.transform (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+common@11.1.10_clas_ef3082dcd13cc376fcae0bf4ef553349\\node_modules\\@nestjs\\common\\pipes\\validation.pipe.js:74:30)\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async resolveParamValue (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:148:23)\n    at async Promise.all (index 1)\n    at async pipesFn (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:151:13)\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:37:30\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:46:28\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-proxy.js:9:17	{"body": {"arteId": "57d68d17-afe4-47b5-baf5-4e4791069319", "etapas": [{"nroEtapa": 1, "tipoEtapa": "COMERCIAL", "fechaArribo": "2024-04-16T15:40:00.000Z", "pesqueriaId": "543aa4a7-f29e-4c08-b04f-62377d3cc0e6", "fechaZarpada": "2024-03-21T10:05:00.000Z", "observaciones": "Importado desde sistema externo", "puertoArriboId": "", "puertoZarpadaId": ""}], "buqueId": "546c200e-da22-4c78-8c7d-cbdeab4535cd", "nroMarea": 45, "anioMarea": 2024, "tipoMarea": "COMERCIAL", "pesqueriaId": "543aa4a7-f29e-4c08-b04f-62377d3cc0e6", "observadorId": "0ba0a4ea-eaa3-4d11-b737-5f80e0651fb5", "diasEstimados": 40, "fechaZarpadaEstimada": "2024-03-21T10:05:00.000Z"}, "query": {}, "params": {}, "exception": {"error": "Bad Request", "message": ["property etapas should not exist"], "statusCode": 400}}	/api/mareas	POST	::1
dbb53b95-a69e-4fdf-b9f0-41de7029ce03	2026-01-16 21:43:18.924+00	ERROR	BACKEND	GlobalExceptionFilter	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	admin@obs.com	Bad Request Exception	BadRequestException: Bad Request Exception\n    at ValidationPipe.exceptionFactory (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+common@11.1.10_clas_ef3082dcd13cc376fcae0bf4ef553349\\node_modules\\@nestjs\\common\\pipes\\validation.pipe.js:107:20)\n    at ValidationPipe.transform (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+common@11.1.10_clas_ef3082dcd13cc376fcae0bf4ef553349\\node_modules\\@nestjs\\common\\pipes\\validation.pipe.js:74:30)\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async resolveParamValue (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:148:23)\n    at async Promise.all (index 1)\n    at async pipesFn (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:151:13)\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:37:30\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:46:28\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-proxy.js:9:17	{"body": {"arteId": "57d68d17-afe4-47b5-baf5-4e4791069319", "etapas": [{"nroEtapa": 1, "tipoEtapa": "COMERCIAL", "fechaArribo": "2024-04-16T15:40:00.000Z", "pesqueriaId": "543aa4a7-f29e-4c08-b04f-62377d3cc0e6", "fechaZarpada": "2024-03-21T10:05:00.000Z", "observaciones": "Importado desde sistema externo", "puertoArriboId": "b8a55941-9f65-4e90-bea1-3683753d42b5", "puertoZarpadaId": "7b621a00-2ec9-43e9-b9bb-211095252cfe"}], "buqueId": "546c200e-da22-4c78-8c7d-cbdeab4535cd", "nroMarea": 45, "anioMarea": 2024, "tipoMarea": "COMERCIAL", "pesqueriaId": "543aa4a7-f29e-4c08-b04f-62377d3cc0e6", "observadorId": "0ba0a4ea-eaa3-4d11-b737-5f80e0651fb5", "diasEstimados": 40, "fechaZarpadaEstimada": "2024-03-21T10:05:00.000Z"}, "query": {}, "params": {}, "exception": {"error": "Bad Request", "message": ["property etapas should not exist"], "statusCode": 400}}	/api/mareas	POST	::1
4711f268-10f3-4b4a-86a0-a788a51a2302	2026-01-16 21:43:19.783+00	ERROR	BACKEND	GlobalExceptionFilter	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	admin@obs.com	Bad Request Exception	BadRequestException: Bad Request Exception\n    at ValidationPipe.exceptionFactory (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+common@11.1.10_clas_ef3082dcd13cc376fcae0bf4ef553349\\node_modules\\@nestjs\\common\\pipes\\validation.pipe.js:107:20)\n    at ValidationPipe.transform (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+common@11.1.10_clas_ef3082dcd13cc376fcae0bf4ef553349\\node_modules\\@nestjs\\common\\pipes\\validation.pipe.js:74:30)\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async resolveParamValue (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:148:23)\n    at async Promise.all (index 1)\n    at async pipesFn (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:151:13)\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:37:30\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:46:28\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-proxy.js:9:17	{"body": {"arteId": "57d68d17-afe4-47b5-baf5-4e4791069319", "etapas": [{"nroEtapa": 1, "tipoEtapa": "COMERCIAL", "fechaArribo": "2024-04-16T15:40:00.000Z", "pesqueriaId": "543aa4a7-f29e-4c08-b04f-62377d3cc0e6", "fechaZarpada": "2024-03-21T10:05:00.000Z", "observaciones": "Importado desde sistema externo", "puertoArriboId": "b8a55941-9f65-4e90-bea1-3683753d42b5", "puertoZarpadaId": "7b621a00-2ec9-43e9-b9bb-211095252cfe"}], "buqueId": "546c200e-da22-4c78-8c7d-cbdeab4535cd", "nroMarea": 45, "anioMarea": 2024, "tipoMarea": "COMERCIAL", "pesqueriaId": "543aa4a7-f29e-4c08-b04f-62377d3cc0e6", "observadorId": "0ba0a4ea-eaa3-4d11-b737-5f80e0651fb5", "diasEstimados": 40, "fechaZarpadaEstimada": "2024-03-21T10:05:00.000Z"}, "query": {}, "params": {}, "exception": {"error": "Bad Request", "message": ["property etapas should not exist"], "statusCode": 400}}	/api/mareas	POST	::1
bd83f8bb-dd5d-4550-a22a-ef2f71fb8b3b	2026-01-16 21:43:29.986+00	ERROR	BACKEND	GlobalExceptionFilter	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	admin@obs.com	Bad Request Exception	BadRequestException: Bad Request Exception\n    at ValidationPipe.exceptionFactory (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+common@11.1.10_clas_ef3082dcd13cc376fcae0bf4ef553349\\node_modules\\@nestjs\\common\\pipes\\validation.pipe.js:107:20)\n    at ValidationPipe.transform (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+common@11.1.10_clas_ef3082dcd13cc376fcae0bf4ef553349\\node_modules\\@nestjs\\common\\pipes\\validation.pipe.js:74:30)\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async resolveParamValue (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:148:23)\n    at async Promise.all (index 1)\n    at async pipesFn (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:151:13)\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:37:30\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:46:28\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-proxy.js:9:17	{"body": {"arteId": "57d68d17-afe4-47b5-baf5-4e4791069319", "etapas": [{"nroEtapa": 1, "tipoEtapa": "COMERCIAL", "fechaArribo": "2024-04-16T15:40:00.000Z", "pesqueriaId": "543aa4a7-f29e-4c08-b04f-62377d3cc0e6", "fechaZarpada": "2024-03-21T10:05:00.000Z", "observaciones": "Importado desde sistema externo", "puertoArriboId": "b8a55941-9f65-4e90-bea1-3683753d42b5", "puertoZarpadaId": "7b621a00-2ec9-43e9-b9bb-211095252cfe"}], "buqueId": "546c200e-da22-4c78-8c7d-cbdeab4535cd", "nroMarea": 45, "anioMarea": 2024, "tipoMarea": "COMERCIAL", "pesqueriaId": "543aa4a7-f29e-4c08-b04f-62377d3cc0e6", "observadorId": "0ba0a4ea-eaa3-4d11-b737-5f80e0651fb5", "diasEstimados": 40, "fechaZarpadaEstimada": "2024-03-21T10:05:00.000Z"}, "query": {}, "params": {}, "exception": {"error": "Bad Request", "message": ["property etapas should not exist"], "statusCode": 400}}	/api/mareas	POST	::1
a4f5e78a-7317-4e7b-b60e-1b25681803b1	2026-01-17 20:07:22.116+00	ERROR	BACKEND	GlobalExceptionFilter	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	admin@obs.com	Unauthorized	UnauthorizedException: Unauthorized\n    at MixinAuthGuard.handleRequest (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+passport@11.0.5_@ne_3e2e1635e1fc880657f155ecf43895f0\\node_modules\\@nestjs\\passport\\dist\\auth.guard.js:60:30)\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+passport@11.0.5_@ne_3e2e1635e1fc880657f155ecf43895f0\\node_modules\\@nestjs\\passport\\dist\\auth.guard.js:44:124\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+passport@11.0.5_@ne_3e2e1635e1fc880657f155ecf43895f0\\node_modules\\@nestjs\\passport\\dist\\auth.guard.js:83:24\n    at allFailed (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\passport@0.7.0\\node_modules\\passport\\lib\\middleware\\authenticate.js:110:18)\n    at attempt (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\passport@0.7.0\\node_modules\\passport\\lib\\middleware\\authenticate.js:183:28)\n    at strategy.fail (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\passport@0.7.0\\node_modules\\passport\\lib\\middleware\\authenticate.js:314:9)\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\passport-jwt@4.0.1\\node_modules\\passport-jwt\\lib\\strategy.js:106:33\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\jsonwebtoken@9.0.3\\node_modules\\jsonwebtoken\\verify.js:190:16\n    at getSecret (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\jsonwebtoken@9.0.3\\node_modules\\jsonwebtoken\\verify.js:97:14)\n    at module.exports [as verify] (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\jsonwebtoken@9.0.3\\node_modules\\jsonwebtoken\\verify.js:101:10)	{"query": {}, "params": {}, "exception": {"message": "Unauthorized", "statusCode": 401}}	/api/catalogos/puertos	GET	::1
e7edb4ac-a97a-4fa5-8760-7d398242c801	2026-01-17 20:07:22.118+00	ERROR	BACKEND	GlobalExceptionFilter	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	admin@obs.com	Unauthorized	UnauthorizedException: Unauthorized\n    at MixinAuthGuard.handleRequest (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+passport@11.0.5_@ne_3e2e1635e1fc880657f155ecf43895f0\\node_modules\\@nestjs\\passport\\dist\\auth.guard.js:60:30)\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+passport@11.0.5_@ne_3e2e1635e1fc880657f155ecf43895f0\\node_modules\\@nestjs\\passport\\dist\\auth.guard.js:44:124\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+passport@11.0.5_@ne_3e2e1635e1fc880657f155ecf43895f0\\node_modules\\@nestjs\\passport\\dist\\auth.guard.js:83:24\n    at allFailed (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\passport@0.7.0\\node_modules\\passport\\lib\\middleware\\authenticate.js:110:18)\n    at attempt (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\passport@0.7.0\\node_modules\\passport\\lib\\middleware\\authenticate.js:183:28)\n    at strategy.fail (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\passport@0.7.0\\node_modules\\passport\\lib\\middleware\\authenticate.js:314:9)\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\passport-jwt@4.0.1\\node_modules\\passport-jwt\\lib\\strategy.js:106:33\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\jsonwebtoken@9.0.3\\node_modules\\jsonwebtoken\\verify.js:190:16\n    at getSecret (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\jsonwebtoken@9.0.3\\node_modules\\jsonwebtoken\\verify.js:97:14)\n    at module.exports [as verify] (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\jsonwebtoken@9.0.3\\node_modules\\jsonwebtoken\\verify.js:101:10)	{"query": {}, "params": {}, "exception": {"message": "Unauthorized", "statusCode": 401}}	/api/catalogos/pesquerias	GET	::1
613efe9c-5ab9-49ef-b9b1-fdde855f700e	2026-01-16 21:47:43.775+00	ERROR	BACKEND	GlobalExceptionFilter	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	admin@obs.com	Bad Request Exception	BadRequestException: Bad Request Exception\n    at ValidationPipe.exceptionFactory (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+common@11.1.10_clas_ef3082dcd13cc376fcae0bf4ef553349\\node_modules\\@nestjs\\common\\pipes\\validation.pipe.js:107:20)\n    at ValidationPipe.transform (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+common@11.1.10_clas_ef3082dcd13cc376fcae0bf4ef553349\\node_modules\\@nestjs\\common\\pipes\\validation.pipe.js:74:30)\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async resolveParamValue (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:148:23)\n    at async Promise.all (index 1)\n    at async pipesFn (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:151:13)\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:37:30\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:46:28\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-proxy.js:9:17	{"body": {"arteId": "57d68d17-afe4-47b5-baf5-4e4791069319", "etapas": [{"nroEtapa": 1, "tipoEtapa": "COMERCIAL", "fechaArribo": "2024-04-16T15:40:00.000Z", "pesqueriaId": "543aa4a7-f29e-4c08-b04f-62377d3cc0e6", "fechaZarpada": "2024-03-21T10:05:00.000Z", "observaciones": "Importado desde sistema externo", "puertoArriboId": "", "puertoZarpadaId": ""}], "buqueId": "546c200e-da22-4c78-8c7d-cbdeab4535cd", "nroMarea": 45, "anioMarea": 2024, "tipoMarea": "COMERCIAL", "pesqueriaId": "543aa4a7-f29e-4c08-b04f-62377d3cc0e6", "observadorId": "0ba0a4ea-eaa3-4d11-b737-5f80e0651fb5", "diasEstimados": 40, "fechaZarpadaEstimada": "2024-03-21T10:05:00.000Z"}, "query": {}, "params": {}, "exception": {"error": "Bad Request", "message": ["etapas.0.puertoZarpadaId must be a UUID", "etapas.0.puertoArriboId must be a UUID"], "statusCode": 400}}	/api/mareas	POST	::1
601a8a61-78d8-4a9c-a3e1-d0d008080a59	2026-01-16 21:56:27.414+00	CRITICAL	BACKEND	GlobalExceptionFilter	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	admin@obs.com	La marea COMERCIAL-45-2024 para este buque ya existe.	Error: La marea COMERCIAL-45-2024 para este buque ya existe.\n    at MareasService.create (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\mareas\\mareas.service.ts:1521:19)\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:46:28\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-proxy.js:9:17	{"body": {"arteId": "57d68d17-afe4-47b5-baf5-4e4791069319", "etapas": [{"nroEtapa": 1, "tipoEtapa": "COMERCIAL", "fechaArribo": "2024-05-16T18:23:00.000Z", "pesqueriaId": "543aa4a7-f29e-4c08-b04f-62377d3cc0e6", "fechaZarpada": "2024-04-18T19:30:00.000Z", "observaciones": "Importado desde sistema externo", "puertoArriboId": "b8a55941-9f65-4e90-bea1-3683753d42b5", "puertoZarpadaId": "b8a55941-9f65-4e90-bea1-3683753d42b5"}], "buqueId": "546c200e-da22-4c78-8c7d-cbdeab4535cd", "nroMarea": 45, "anioMarea": 2024, "tipoMarea": "COMERCIAL", "pesqueriaId": "543aa4a7-f29e-4c08-b04f-62377d3cc0e6", "observadorId": "0ba0a4ea-eaa3-4d11-b737-5f80e0651fb5", "diasEstimados": 40, "fechaZarpadaEstimada": "2024-04-18T19:30:00.000Z"}, "query": {}, "params": {}, "exception": {}}	/api/mareas	POST	::1
ab0f32ae-0eec-460f-8396-e7a167f47d96	2026-01-17 01:38:06.454+00	ERROR	BACKEND	GlobalExceptionFilter	\N	\N	No valid Refresh Token found	UnauthorizedException: No valid Refresh Token found\n    at AuthController.refreshAuth (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\auth\\auth.controller.ts:56:30)\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:38:29\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:46:28\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-proxy.js:9:17	{"query": {}, "params": {}, "exception": {"error": "Unauthorized", "message": "No valid Refresh Token found", "statusCode": 401}}	/api/auth/refresh	GET	::ffff:127.0.0.1
a6d095c7-01f5-4d43-92b1-fd14c1b12246	2026-01-17 01:38:11.051+00	ERROR	BACKEND	GlobalExceptionFilter	\N	\N	No valid Refresh Token found	UnauthorizedException: No valid Refresh Token found\n    at AuthController.refreshAuth (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\auth\\auth.controller.ts:56:30)\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:38:29\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:46:28\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-proxy.js:9:17	{"query": {}, "params": {}, "exception": {"error": "Unauthorized", "message": "No valid Refresh Token found", "statusCode": 401}}	/api/auth/refresh	GET	::ffff:127.0.0.1
d5fd9777-b50d-4bbb-b2f9-ab97556ffdc5	2026-01-17 01:45:19.254+00	ERROR	BACKEND	GlobalExceptionFilter	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	admin@obs.com	Bad Request Exception	BadRequestException: Bad Request Exception\n    at ValidationPipe.exceptionFactory (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+common@11.1.10_clas_ef3082dcd13cc376fcae0bf4ef553349\\node_modules\\@nestjs\\common\\pipes\\validation.pipe.js:107:20)\n    at ValidationPipe.transform (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+common@11.1.10_clas_ef3082dcd13cc376fcae0bf4ef553349\\node_modules\\@nestjs\\common\\pipes\\validation.pipe.js:74:30)\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async resolveParamValue (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:148:23)\n    at async Promise.all (index 0)\n    at async pipesFn (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:151:13)\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:37:30\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:46:28\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-proxy.js:9:17	{"body": {"etapas": [{"id": "f366d627-4a7d-485b-bf15-acf869dcb4cb", "mareaId": "47bc925f-8a76-467f-8a92-30b22cf33c75", "nroEtapa": 1, "pesqueria": {"id": "92d9acc2-3590-474f-a773-73e8af728e83", "grupo": "Peces", "orden": null, "activo": true, "codigo": "AUSTRALES", "nombre": "Especies australes", "descripcion": null}, "tipoEtapa": "COMERCIAL", "fechaArribo": "", "pesqueriaId": "92d9acc2-3590-474f-a773-73e8af728e83", "fechaZarpada": "2025-12-30T03:00:00.000Z", "observadores": [{"id": "43093a44-907a-4da6-a459-cdf264b060f0", "rol": "PRINCIPAL", "etapaId": "f366d627-4a7d-485b-bf15-acf869dcb4cb", "observador": {"id": "cded2d3e-5f9e-4de6-9269-a1da3eeeff0a", "email": "glavinawalter@hotmail.com", "activo": true, "nombre": "Walter Alejandro", "fotoUrl": null, "apellido": "Glavina", "disponible": true, "tipoContrato": "LEY MARCO", "codigoInterno": 7729, "observaciones": null, "conImpedimento": false, "tipoObservador": "OBSERVADOR", "motivoImpedimento": null, "fechaProximaDisponibilidad": null}, "esDesignado": true, "observadorId": "cded2d3e-5f9e-4de6-9269-a1da3eeeff0a"}], "puertoArribo": {"id": "34aeab48-9c9b-4c06-8a45-3469f866cf88", "pais": null, "orden": null, "activo": true, "nombre": "Mar Del Plata", "esLocal": true, "latitud": -38.06667, "longitud": -57.55, "provincia": null, "codigoExterno": null, "codigoInterno": "1", "observaciones": null}, "observaciones": "Etapa generada automáticamente (sin desglose)", "puertoZarpada": {"id": "34aeab48-9c9b-4c06-8a45-3469f866cf88", "pais": null, "orden": null, "activo": true, "nombre": "Mar Del Plata", "esLocal": true, "latitud": -38.06667, "longitud": -57.55, "provincia": null, "codigoExterno": null, "codigoInterno": "1", "observaciones": null}, "puertoArriboId": null, "puertoZarpadaId": "34aeab48-9c9b-4c06-8a45-3469f866cf88"}], "fechaFinObservador": "", "fechaInicioObservador": "2025-12-30T01:40:00.000Z"}, "query": {}, "params": {"id": "47bc925f-8a76-467f-8a92-30b22cf33c75"}, "exception": {"error": "Bad Request", "message": ["fechaFinObservador must be a valid ISO 8601 date string", "etapas.0.property mareaId should not exist", "etapas.0.property puertoZarpada should not exist", "etapas.0.property puertoArribo should not exist", "etapas.0.property pesqueria should not exist", "etapas.0.fechaArribo must be a valid ISO 8601 date string", "etapas.0.observadores.0.property id should not exist", "etapas.0.observadores.0.property etapaId should not exist", "etapas.0.observadores.0.property observador should not exist"], "statusCode": 400}}	/api/mareas/47bc925f-8a76-467f-8a92-30b22cf33c75	PATCH	::1
f44dceee-72d0-455a-a831-bb2cae1e2973	2026-01-17 02:00:06.797+00	ERROR	BACKEND	GlobalExceptionFilter	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	admin@obs.com	Bad Request Exception	BadRequestException: Bad Request Exception\n    at ValidationPipe.exceptionFactory (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+common@11.1.10_clas_ef3082dcd13cc376fcae0bf4ef553349\\node_modules\\@nestjs\\common\\pipes\\validation.pipe.js:107:20)\n    at ValidationPipe.transform (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+common@11.1.10_clas_ef3082dcd13cc376fcae0bf4ef553349\\node_modules\\@nestjs\\common\\pipes\\validation.pipe.js:74:30)\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async resolveParamValue (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:148:23)\n    at async Promise.all (index 0)\n    at async pipesFn (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:151:13)\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:37:30\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:46:28\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-proxy.js:9:17	{"body": {"etapas": [{"id": "96f71fc0-19c3-4a74-ba9c-5fb8d5ebcd94", "mareaId": "d0080183-5a28-4940-8b62-d0916fb6ea45", "nroEtapa": 1, "pesqueria": {"id": "7f47bb40-1035-438a-ba95-a0ac1b2cf3ad", "grupo": "Crustáceos", "orden": null, "activo": true, "codigo": "CENTOLLA", "nombre": "Centolla", "descripcion": null}, "tipoEtapa": "COMERCIAL", "fechaArribo": "2025-12-27T03:00:00.000Z", "pesqueriaId": "7f47bb40-1035-438a-ba95-a0ac1b2cf3ad", "fechaZarpada": "2025-12-23T03:00:00.000Z", "observadores": [{"id": "e55ec487-1f9d-475c-8c9c-6b950c63ad5a", "rol": "PRINCIPAL", "etapaId": "96f71fc0-19c3-4a74-ba9c-5fb8d5ebcd94", "observador": {"id": "42a44075-32a8-4cf3-ac88-e674cec0c736", "email": null, "activo": true, "nombre": "Daiana Anabella", "fotoUrl": null, "apellido": "Molina Riquelme", "disponible": true, "tipoContrato": "MONOTRIBUTISTA", "codigoInterno": 7861, "observaciones": null, "conImpedimento": false, "tipoObservador": "OBSERVADOR", "motivoImpedimento": null, "fechaProximaDisponibilidad": null}, "esDesignado": true, "observadorId": "42a44075-32a8-4cf3-ac88-e674cec0c736"}], "puertoArribo": {"id": "11c64a29-e693-4bef-b734-8162f86cbbcc", "pais": null, "orden": null, "activo": true, "nombre": "Buenos Aires", "esLocal": false, "latitud": -34.58333, "longitud": -58.38334, "provincia": null, "codigoExterno": null, "codigoInterno": "12", "observaciones": null}, "observaciones": "Etapa generada automáticamente (sin desglose)", "puertoZarpada": {"id": "11c64a29-e693-4bef-b734-8162f86cbbcc", "pais": null, "orden": null, "activo": true, "nombre": "Buenos Aires", "esLocal": false, "latitud": -34.58333, "longitud": -58.38334, "provincia": null, "codigoExterno": null, "codigoInterno": "12", "observaciones": null}, "puertoArriboId": "11c64a29-e693-4bef-b734-8162f86cbbcc", "puertoZarpadaId": "11c64a29-e693-4bef-b734-8162f86cbbcc"}], "fechaFinObservador": "", "fechaInicioObservador": "2025-12-24T01:59:00.000Z"}, "query": {}, "params": {"id": "d0080183-5a28-4940-8b62-d0916fb6ea45"}, "exception": {"error": "Bad Request", "message": ["fechaFinObservador must be a valid ISO 8601 date string", "etapas.0.property mareaId should not exist", "etapas.0.property puertoZarpada should not exist", "etapas.0.property puertoArribo should not exist", "etapas.0.property pesqueria should not exist", "etapas.0.observadores.0.property id should not exist", "etapas.0.observadores.0.property etapaId should not exist", "etapas.0.observadores.0.property observador should not exist"], "statusCode": 400}}	/api/mareas/d0080183-5a28-4940-8b62-d0916fb6ea45	PATCH	::1
33f45eda-7adc-45db-951f-545914713378	2026-01-17 02:00:38.507+00	ERROR	BACKEND	GlobalExceptionFilter	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	admin@obs.com	Bad Request Exception	BadRequestException: Bad Request Exception\n    at ValidationPipe.exceptionFactory (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+common@11.1.10_clas_ef3082dcd13cc376fcae0bf4ef553349\\node_modules\\@nestjs\\common\\pipes\\validation.pipe.js:107:20)\n    at ValidationPipe.transform (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+common@11.1.10_clas_ef3082dcd13cc376fcae0bf4ef553349\\node_modules\\@nestjs\\common\\pipes\\validation.pipe.js:74:30)\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async resolveParamValue (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:148:23)\n    at async Promise.all (index 0)\n    at async pipesFn (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:151:13)\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:37:30\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:46:28\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-proxy.js:9:17	{"body": {"etapas": [{"id": "96f71fc0-19c3-4a74-ba9c-5fb8d5ebcd94", "mareaId": "d0080183-5a28-4940-8b62-d0916fb6ea45", "nroEtapa": 1, "pesqueria": {"id": "7f47bb40-1035-438a-ba95-a0ac1b2cf3ad", "grupo": "Crustáceos", "orden": null, "activo": true, "codigo": "CENTOLLA", "nombre": "Centolla", "descripcion": null}, "tipoEtapa": "COMERCIAL", "fechaArribo": "2025-12-27T03:00:00.000Z", "pesqueriaId": "7f47bb40-1035-438a-ba95-a0ac1b2cf3ad", "fechaZarpada": "2025-12-23T03:00:00.000Z", "observadores": [{"id": "e55ec487-1f9d-475c-8c9c-6b950c63ad5a", "rol": "PRINCIPAL", "etapaId": "96f71fc0-19c3-4a74-ba9c-5fb8d5ebcd94", "observador": {"id": "42a44075-32a8-4cf3-ac88-e674cec0c736", "email": null, "activo": true, "nombre": "Daiana Anabella", "fotoUrl": null, "apellido": "Molina Riquelme", "disponible": true, "tipoContrato": "MONOTRIBUTISTA", "codigoInterno": 7861, "observaciones": null, "conImpedimento": false, "tipoObservador": "OBSERVADOR", "motivoImpedimento": null, "fechaProximaDisponibilidad": null}, "esDesignado": true, "observadorId": "42a44075-32a8-4cf3-ac88-e674cec0c736"}], "puertoArribo": {"id": "11c64a29-e693-4bef-b734-8162f86cbbcc", "pais": null, "orden": null, "activo": true, "nombre": "Buenos Aires", "esLocal": false, "latitud": -34.58333, "longitud": -58.38334, "provincia": null, "codigoExterno": null, "codigoInterno": "12", "observaciones": null}, "observaciones": "Etapa generada automáticamente (sin desglose)", "puertoZarpada": {"id": "11c64a29-e693-4bef-b734-8162f86cbbcc", "pais": null, "orden": null, "activo": true, "nombre": "Buenos Aires", "esLocal": false, "latitud": -34.58333, "longitud": -58.38334, "provincia": null, "codigoExterno": null, "codigoInterno": "12", "observaciones": null}, "puertoArriboId": "11c64a29-e693-4bef-b734-8162f86cbbcc", "puertoZarpadaId": "11c64a29-e693-4bef-b734-8162f86cbbcc"}], "fechaFinObservador": "", "fechaInicioObservador": "2025-12-24T02:00:00.000Z"}, "query": {}, "params": {"id": "d0080183-5a28-4940-8b62-d0916fb6ea45"}, "exception": {"error": "Bad Request", "message": ["fechaFinObservador must be a valid ISO 8601 date string", "etapas.0.property mareaId should not exist", "etapas.0.property puertoZarpada should not exist", "etapas.0.property puertoArribo should not exist", "etapas.0.property pesqueria should not exist", "etapas.0.observadores.0.property id should not exist", "etapas.0.observadores.0.property etapaId should not exist", "etapas.0.observadores.0.property observador should not exist"], "statusCode": 400}}	/api/mareas/d0080183-5a28-4940-8b62-d0916fb6ea45	PATCH	::1
4bf48386-aa3a-4c24-b9b1-4558ad0cc1ce	2026-01-17 02:12:33.938+00	ERROR	BACKEND	GlobalExceptionFilter	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	admin@obs.com	Bad Request Exception	BadRequestException: Bad Request Exception\n    at ValidationPipe.exceptionFactory (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+common@11.1.10_clas_ef3082dcd13cc376fcae0bf4ef553349\\node_modules\\@nestjs\\common\\pipes\\validation.pipe.js:107:20)\n    at ValidationPipe.transform (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+common@11.1.10_clas_ef3082dcd13cc376fcae0bf4ef553349\\node_modules\\@nestjs\\common\\pipes\\validation.pipe.js:74:30)\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async resolveParamValue (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:148:23)\n    at async Promise.all (index 0)\n    at async pipesFn (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:151:13)\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:37:30\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:46:28\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-proxy.js:9:17	{"body": {"etapas": [{"id": "96f71fc0-19c3-4a74-ba9c-5fb8d5ebcd94", "nroEtapa": 1, "tipoEtapa": "COMERCIAL", "fechaArribo": "2025-12-27T03:00:00.000Z", "pesqueriaId": "7f47bb40-1035-438a-ba95-a0ac1b2cf3ad", "fechaZarpada": "2025-12-23T03:00:00.000Z", "observadores": [{"rol": "PRINCIPAL", "esDesignado": true, "observadorId": "42a44075-32a8-4cf3-ac88-e674cec0c736"}], "observaciones": "Etapa generada automáticamente (sin desglose)", "puertoArriboId": "11c64a29-e693-4bef-b734-8162f86cbbcc", "puertoZarpadaId": "11c64a29-e693-4bef-b734-8162f86cbbcc"}, {"id": null, "nroEtapa": 2, "tipoEtapa": "COMERCIAL", "fechaArribo": "", "pesqueriaId": "7f47bb40-1035-438a-ba95-a0ac1b2cf3ad", "fechaZarpada": "2026-01-01T18:30:00.000Z", "observadores": [], "observaciones": "Etapa detectada automáticamente desde Access", "puertoArriboId": "", "puertoZarpadaId": "11c64a29-e693-4bef-b734-8162f86cbbcc"}], "fechaFinObservador": null, "fechaInicioObservador": "2025-12-20T03:00:00.000Z"}, "query": {}, "params": {"id": "d0080183-5a28-4940-8b62-d0916fb6ea45"}, "exception": {"error": "Bad Request", "message": ["etapas.1.puertoArriboId must be a UUID", "etapas.1.fechaArribo must be a valid ISO 8601 date string"], "statusCode": 400}}	/api/mareas/d0080183-5a28-4940-8b62-d0916fb6ea45	PATCH	::1
2daed414-a228-4644-9567-1239b0de2b10	2026-01-17 13:42:07.337+00	ERROR	BACKEND	GlobalExceptionFilter	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	admin@obs.com	Marea no encontrada	NotFoundException: Marea no encontrada\n    at MareasService.findOne (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\mareas\\mareas.service.ts:73:27)\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:46:28\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-proxy.js:9:17	{"query": {}, "params": {"id": "d5596483-4141-4dbe-b48b-89012e691760"}, "exception": {"error": "Not Found", "message": "Marea no encontrada", "statusCode": 404}}	/api/mareas/d5596483-4141-4dbe-b48b-89012e691760	GET	::1
28e09f7d-0637-4e1d-8bd5-2be450e52a0a	2026-01-17 20:07:22.001+00	ERROR	BACKEND	GlobalExceptionFilter	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	admin@obs.com	Unauthorized	UnauthorizedException: Unauthorized\n    at MixinAuthGuard.handleRequest (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+passport@11.0.5_@ne_3e2e1635e1fc880657f155ecf43895f0\\node_modules\\@nestjs\\passport\\dist\\auth.guard.js:60:30)\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+passport@11.0.5_@ne_3e2e1635e1fc880657f155ecf43895f0\\node_modules\\@nestjs\\passport\\dist\\auth.guard.js:44:124\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+passport@11.0.5_@ne_3e2e1635e1fc880657f155ecf43895f0\\node_modules\\@nestjs\\passport\\dist\\auth.guard.js:83:24\n    at allFailed (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\passport@0.7.0\\node_modules\\passport\\lib\\middleware\\authenticate.js:110:18)\n    at attempt (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\passport@0.7.0\\node_modules\\passport\\lib\\middleware\\authenticate.js:183:28)\n    at strategy.fail (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\passport@0.7.0\\node_modules\\passport\\lib\\middleware\\authenticate.js:314:9)\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\passport-jwt@4.0.1\\node_modules\\passport-jwt\\lib\\strategy.js:106:33\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\jsonwebtoken@9.0.3\\node_modules\\jsonwebtoken\\verify.js:190:16\n    at getSecret (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\jsonwebtoken@9.0.3\\node_modules\\jsonwebtoken\\verify.js:97:14)\n    at module.exports [as verify] (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\jsonwebtoken@9.0.3\\node_modules\\jsonwebtoken\\verify.js:101:10)	{"query": {"year": "2026"}, "params": {}, "exception": {"message": "Unauthorized", "statusCode": 401}}	/api/mareas/inbox?year=2026	GET	::1
782a707d-a645-41fc-97cb-d27f9fabfc72	2026-01-17 20:07:21.997+00	ERROR	BACKEND	GlobalExceptionFilter	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	admin@obs.com	Unauthorized	UnauthorizedException: Unauthorized\n    at MixinAuthGuard.handleRequest (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+passport@11.0.5_@ne_3e2e1635e1fc880657f155ecf43895f0\\node_modules\\@nestjs\\passport\\dist\\auth.guard.js:60:30)\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+passport@11.0.5_@ne_3e2e1635e1fc880657f155ecf43895f0\\node_modules\\@nestjs\\passport\\dist\\auth.guard.js:44:124\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+passport@11.0.5_@ne_3e2e1635e1fc880657f155ecf43895f0\\node_modules\\@nestjs\\passport\\dist\\auth.guard.js:83:24\n    at allFailed (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\passport@0.7.0\\node_modules\\passport\\lib\\middleware\\authenticate.js:110:18)\n    at attempt (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\passport@0.7.0\\node_modules\\passport\\lib\\middleware\\authenticate.js:183:28)\n    at strategy.fail (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\passport@0.7.0\\node_modules\\passport\\lib\\middleware\\authenticate.js:314:9)\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\passport-jwt@4.0.1\\node_modules\\passport-jwt\\lib\\strategy.js:106:33\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\jsonwebtoken@9.0.3\\node_modules\\jsonwebtoken\\verify.js:190:16\n    at getSecret (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\jsonwebtoken@9.0.3\\node_modules\\jsonwebtoken\\verify.js:97:14)\n    at module.exports [as verify] (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\jsonwebtoken@9.0.3\\node_modules\\jsonwebtoken\\verify.js:101:10)	{"query": {}, "params": {}, "exception": {"message": "Unauthorized", "statusCode": 401}}	/api/catalogos/observadores	GET	::1
f04b991a-8ef5-4bde-9586-971648488db3	2026-01-17 20:07:21.994+00	ERROR	BACKEND	GlobalExceptionFilter	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	admin@obs.com	Unauthorized	UnauthorizedException: Unauthorized\n    at MixinAuthGuard.handleRequest (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+passport@11.0.5_@ne_3e2e1635e1fc880657f155ecf43895f0\\node_modules\\@nestjs\\passport\\dist\\auth.guard.js:60:30)\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+passport@11.0.5_@ne_3e2e1635e1fc880657f155ecf43895f0\\node_modules\\@nestjs\\passport\\dist\\auth.guard.js:44:124\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+passport@11.0.5_@ne_3e2e1635e1fc880657f155ecf43895f0\\node_modules\\@nestjs\\passport\\dist\\auth.guard.js:83:24\n    at allFailed (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\passport@0.7.0\\node_modules\\passport\\lib\\middleware\\authenticate.js:110:18)\n    at attempt (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\passport@0.7.0\\node_modules\\passport\\lib\\middleware\\authenticate.js:183:28)\n    at strategy.fail (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\passport@0.7.0\\node_modules\\passport\\lib\\middleware\\authenticate.js:314:9)\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\passport-jwt@4.0.1\\node_modules\\passport-jwt\\lib\\strategy.js:106:33\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\jsonwebtoken@9.0.3\\node_modules\\jsonwebtoken\\verify.js:190:16\n    at getSecret (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\jsonwebtoken@9.0.3\\node_modules\\jsonwebtoken\\verify.js:97:14)\n    at module.exports [as verify] (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\jsonwebtoken@9.0.3\\node_modules\\jsonwebtoken\\verify.js:101:10)	{"query": {}, "params": {}, "exception": {"message": "Unauthorized", "statusCode": 401}}	/api/catalogos/buques	GET	::1
130907d5-e3a2-4087-9c9f-83bf07245373	2026-01-17 20:07:21.999+00	ERROR	BACKEND	GlobalExceptionFilter	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	admin@obs.com	Unauthorized	UnauthorizedException: Unauthorized\n    at MixinAuthGuard.handleRequest (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+passport@11.0.5_@ne_3e2e1635e1fc880657f155ecf43895f0\\node_modules\\@nestjs\\passport\\dist\\auth.guard.js:60:30)\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+passport@11.0.5_@ne_3e2e1635e1fc880657f155ecf43895f0\\node_modules\\@nestjs\\passport\\dist\\auth.guard.js:44:124\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+passport@11.0.5_@ne_3e2e1635e1fc880657f155ecf43895f0\\node_modules\\@nestjs\\passport\\dist\\auth.guard.js:83:24\n    at allFailed (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\passport@0.7.0\\node_modules\\passport\\lib\\middleware\\authenticate.js:110:18)\n    at attempt (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\passport@0.7.0\\node_modules\\passport\\lib\\middleware\\authenticate.js:183:28)\n    at strategy.fail (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\passport@0.7.0\\node_modules\\passport\\lib\\middleware\\authenticate.js:314:9)\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\passport-jwt@4.0.1\\node_modules\\passport-jwt\\lib\\strategy.js:106:33\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\jsonwebtoken@9.0.3\\node_modules\\jsonwebtoken\\verify.js:190:16\n    at getSecret (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\jsonwebtoken@9.0.3\\node_modules\\jsonwebtoken\\verify.js:97:14)\n    at module.exports [as verify] (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\jsonwebtoken@9.0.3\\node_modules\\jsonwebtoken\\verify.js:101:10)	{"query": {}, "params": {}, "exception": {"message": "Unauthorized", "statusCode": 401}}	/api/catalogos/artes-pesca	GET	::1
d5c23761-6877-42db-aa59-e428df5d8a5d	2026-01-17 20:07:21.991+00	ERROR	BACKEND	GlobalExceptionFilter	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	admin@obs.com	Unauthorized	UnauthorizedException: Unauthorized\n    at MixinAuthGuard.handleRequest (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+passport@11.0.5_@ne_3e2e1635e1fc880657f155ecf43895f0\\node_modules\\@nestjs\\passport\\dist\\auth.guard.js:60:30)\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+passport@11.0.5_@ne_3e2e1635e1fc880657f155ecf43895f0\\node_modules\\@nestjs\\passport\\dist\\auth.guard.js:44:124\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+passport@11.0.5_@ne_3e2e1635e1fc880657f155ecf43895f0\\node_modules\\@nestjs\\passport\\dist\\auth.guard.js:83:24\n    at allFailed (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\passport@0.7.0\\node_modules\\passport\\lib\\middleware\\authenticate.js:110:18)\n    at attempt (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\passport@0.7.0\\node_modules\\passport\\lib\\middleware\\authenticate.js:183:28)\n    at strategy.fail (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\passport@0.7.0\\node_modules\\passport\\lib\\middleware\\authenticate.js:314:9)\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\passport-jwt@4.0.1\\node_modules\\passport-jwt\\lib\\strategy.js:106:33\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\jsonwebtoken@9.0.3\\node_modules\\jsonwebtoken\\verify.js:190:16\n    at getSecret (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\jsonwebtoken@9.0.3\\node_modules\\jsonwebtoken\\verify.js:97:14)\n    at module.exports [as verify] (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\jsonwebtoken@9.0.3\\node_modules\\jsonwebtoken\\verify.js:101:10)	{"query": {}, "params": {}, "exception": {"message": "Unauthorized", "statusCode": 401}}	/api/catalogos/pesquerias	GET	::1
f351914f-8c8e-4e52-8945-c2ec603800cc	2026-01-17 20:07:21.988+00	ERROR	BACKEND	GlobalExceptionFilter	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	admin@obs.com	Unauthorized	UnauthorizedException: Unauthorized\n    at MixinAuthGuard.handleRequest (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+passport@11.0.5_@ne_3e2e1635e1fc880657f155ecf43895f0\\node_modules\\@nestjs\\passport\\dist\\auth.guard.js:60:30)\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+passport@11.0.5_@ne_3e2e1635e1fc880657f155ecf43895f0\\node_modules\\@nestjs\\passport\\dist\\auth.guard.js:44:124\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+passport@11.0.5_@ne_3e2e1635e1fc880657f155ecf43895f0\\node_modules\\@nestjs\\passport\\dist\\auth.guard.js:83:24\n    at allFailed (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\passport@0.7.0\\node_modules\\passport\\lib\\middleware\\authenticate.js:110:18)\n    at attempt (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\passport@0.7.0\\node_modules\\passport\\lib\\middleware\\authenticate.js:183:28)\n    at strategy.fail (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\passport@0.7.0\\node_modules\\passport\\lib\\middleware\\authenticate.js:314:9)\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\passport-jwt@4.0.1\\node_modules\\passport-jwt\\lib\\strategy.js:106:33\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\jsonwebtoken@9.0.3\\node_modules\\jsonwebtoken\\verify.js:190:16\n    at getSecret (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\jsonwebtoken@9.0.3\\node_modules\\jsonwebtoken\\verify.js:97:14)\n    at module.exports [as verify] (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\jsonwebtoken@9.0.3\\node_modules\\jsonwebtoken\\verify.js:101:10)	{"query": {}, "params": {}, "exception": {"message": "Unauthorized", "statusCode": 401}}	/api/catalogos/puertos	GET	::1
8a0a7d4d-6fc6-4f9a-b988-6aaaa0302692	2026-01-17 21:27:47.255+00	ERROR	BACKEND	GlobalExceptionFilter	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	admin@obs.com	Bad Request Exception	BadRequestException: Bad Request Exception\n    at ValidationPipe.exceptionFactory (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+common@11.1.10_clas_ef3082dcd13cc376fcae0bf4ef553349\\node_modules\\@nestjs\\common\\pipes\\validation.pipe.js:107:20)\n    at ValidationPipe.transform (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+common@11.1.10_clas_ef3082dcd13cc376fcae0bf4ef553349\\node_modules\\@nestjs\\common\\pipes\\validation.pipe.js:74:30)\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async resolveParamValue (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:148:23)\n    at async Promise.all (index 0)\n    at async pipesFn (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:151:13)\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:37:30\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:46:28\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-proxy.js:9:17	{"body": {"email": "", "activo": false, "nombre": "No", "apellido": "Identificado", "disponible": false, "tipoContrato": "MONOTRIBUTISTA", "codigoInterno": 9999, "observaciones": "", "conImpedimento": false, "tipoObservador": "OBSERVADOR", "motivoImpedimento": "", "fechaProximaDisponibilidad": null}, "query": {}, "params": {}, "exception": {"error": "Bad Request", "message": ["El formato del email no es válido"], "statusCode": 400}}	/api/catalogos/observadores	POST	::1
b1375816-fa6c-4df6-b9fc-b55895b56337	2026-01-17 22:47:05.86+00	ERROR	BACKEND	GlobalExceptionFilter	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	admin@obs.com	Unauthorized	UnauthorizedException: Unauthorized\n    at MixinAuthGuard.handleRequest (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+passport@11.0.5_@ne_3e2e1635e1fc880657f155ecf43895f0\\node_modules\\@nestjs\\passport\\dist\\auth.guard.js:60:30)\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+passport@11.0.5_@ne_3e2e1635e1fc880657f155ecf43895f0\\node_modules\\@nestjs\\passport\\dist\\auth.guard.js:44:124\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+passport@11.0.5_@ne_3e2e1635e1fc880657f155ecf43895f0\\node_modules\\@nestjs\\passport\\dist\\auth.guard.js:83:24\n    at allFailed (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\passport@0.7.0\\node_modules\\passport\\lib\\middleware\\authenticate.js:110:18)\n    at attempt (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\passport@0.7.0\\node_modules\\passport\\lib\\middleware\\authenticate.js:183:28)\n    at strategy.fail (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\passport@0.7.0\\node_modules\\passport\\lib\\middleware\\authenticate.js:314:9)\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\passport-jwt@4.0.1\\node_modules\\passport-jwt\\lib\\strategy.js:106:33\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\jsonwebtoken@9.0.3\\node_modules\\jsonwebtoken\\verify.js:190:16\n    at getSecret (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\jsonwebtoken@9.0.3\\node_modules\\jsonwebtoken\\verify.js:97:14)\n    at module.exports [as verify] (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\jsonwebtoken@9.0.3\\node_modules\\jsonwebtoken\\verify.js:101:10)	{"query": {}, "params": {"filename": "BKP-2026-01-17T21-56-04.sql"}, "exception": {"message": "Unauthorized", "statusCode": 401}}	/api/admin/backup/BKP-2026-01-17T21-56-04.sql	DELETE	::1
2c4c1273-e4d5-41b9-8ab2-a447e99b159d	2026-01-18 00:17:02.397+00	ERROR	BACKEND	GlobalExceptionFilter	\N	\N	No valid Refresh Token found	UnauthorizedException: No valid Refresh Token found\n    at AuthController.refreshAuth (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\auth\\auth.controller.ts:56:30)\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:38:29\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:46:28\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-proxy.js:9:17	{"query": {}, "params": {}, "exception": {"error": "Unauthorized", "message": "No valid Refresh Token found", "statusCode": 401}}	/api/auth/refresh	GET	::1
f40e5bf5-3c08-4913-aa05-d245221fc550	2026-01-18 00:17:21.623+00	ERROR	BACKEND	GlobalExceptionFilter	\N	\N	No valid Refresh Token found	UnauthorizedException: No valid Refresh Token found\n    at AuthController.refreshAuth (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\auth\\auth.controller.ts:56:30)\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:38:29\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:46:28\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-proxy.js:9:17	{"query": {}, "params": {}, "exception": {"error": "Unauthorized", "message": "No valid Refresh Token found", "statusCode": 401}}	/api/auth/refresh	GET	::1
612309a9-2210-46b7-a68a-7349a40593fc	2026-01-18 00:22:48.469+00	ERROR	BACKEND	GlobalExceptionFilter	\N	\N	No valid Refresh Token found	UnauthorizedException: No valid Refresh Token found\n    at AuthController.refreshAuth (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\auth\\auth.controller.ts:56:30)\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:38:29\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:46:28\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-proxy.js:9:17	{"query": {}, "params": {}, "exception": {"error": "Unauthorized", "message": "No valid Refresh Token found", "statusCode": 401}}	/api/auth/refresh	GET	::1
1d9096a6-5ffe-4283-a6ae-6a165e7145a0	2026-01-18 00:30:29.334+00	ERROR	BACKEND	GlobalExceptionFilter	\N	\N	No valid Refresh Token found	UnauthorizedException: No valid Refresh Token found\n    at AuthController.refreshAuth (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\auth\\auth.controller.ts:56:30)\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:38:29\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:46:28\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-proxy.js:9:17	{"query": {}, "params": {}, "exception": {"error": "Unauthorized", "message": "No valid Refresh Token found", "statusCode": 401}}	/api/auth/refresh	GET	::1
f70e2c55-2250-4830-8842-f1f5bc8467ae	2026-01-18 23:34:55.828+00	ERROR	BACKEND	GlobalExceptionFilter	\N	\N	Token de refresco inválido o expirado	UnauthorizedException: Token de refresco inválido o expirado\n    at AuthService.refreshAuth (/app/dist/src/auth/auth.service.js:188:19)\n    at process.processTicksAndRejections (node:internal/process/task_queues:95:5)\n    at async AuthController.refreshAuth (/app/dist/src/auth/auth.controller.js:45:22)\n    at async /app/node_modules/.pnpm/@nestjs+core@11.1.12_@nestjs+common@11.1.12_class-transformer@0.5.1_class-validator@0.1_cbe7cfc41de5bef826b769e633ad1837/node_modules/@nestjs/core/router/router-execution-context.js:46:28\n    at async /app/node_modules/.pnpm/@nestjs+core@11.1.12_@nestjs+common@11.1.12_class-transformer@0.5.1_class-validator@0.1_cbe7cfc41de5bef826b769e633ad1837/node_modules/@nestjs/core/router/router-proxy.js:9:17	{"query": {}, "params": {}, "exception": {"error": "Unauthorized", "message": "Token de refresco inválido o expirado", "statusCode": 401}}	/api/auth/refresh	GET	181.116.42.73
ae7f1d7a-5ef6-439c-9b9f-57ec504f8272	2026-01-18 00:37:18.264+00	ERROR	BACKEND	GlobalExceptionFilter	\N	\N	No valid Refresh Token found	UnauthorizedException: No valid Refresh Token found\n    at AuthController.refreshAuth (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\auth\\auth.controller.ts:56:30)\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:38:29\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:46:28\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-proxy.js:9:17	{"query": {}, "params": {}, "exception": {"error": "Unauthorized", "message": "No valid Refresh Token found", "statusCode": 401}}	/api/auth/refresh	GET	::1
edeb80b0-6bf5-4218-a28e-f2b608a3d654	2026-01-18 00:40:56.535+00	ERROR	BACKEND	GlobalExceptionFilter	\N	\N	No valid Refresh Token found	UnauthorizedException: No valid Refresh Token found\n    at AuthController.refreshAuth (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\auth\\auth.controller.ts:56:30)\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:38:29\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:46:28\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-proxy.js:9:17	{"query": {}, "params": {}, "exception": {"error": "Unauthorized", "message": "No valid Refresh Token found", "statusCode": 401}}	/api/auth/refresh	GET	::1
244e4951-d71d-467a-a8ad-fe62318e9594	2026-01-18 00:40:56.807+00	ERROR	BACKEND	GlobalExceptionFilter	\N	\N	No valid Refresh Token found	UnauthorizedException: No valid Refresh Token found\n    at AuthController.refreshAuth (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\auth\\auth.controller.ts:56:30)\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:38:29\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:46:28\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-proxy.js:9:17	{"query": {}, "params": {}, "exception": {"error": "Unauthorized", "message": "No valid Refresh Token found", "statusCode": 401}}	/api/auth/refresh	GET	::1
5e8d88ea-9b3d-4b0d-b11f-6a2901578e14	2026-01-18 00:41:36.896+00	ERROR	BACKEND	GlobalExceptionFilter	\N	\N	No valid Refresh Token found	UnauthorizedException: No valid Refresh Token found\n    at AuthController.refreshAuth (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\auth\\auth.controller.ts:56:30)\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:38:29\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:46:28\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-proxy.js:9:17	{"query": {}, "params": {}, "exception": {"error": "Unauthorized", "message": "No valid Refresh Token found", "statusCode": 401}}	/api/auth/refresh	GET	::1
6d28dc3c-d2ce-4fe3-97aa-27bd966531e0	2026-01-18 00:44:26.607+00	ERROR	BACKEND	GlobalExceptionFilter	\N	\N	No valid Refresh Token found	UnauthorizedException: No valid Refresh Token found\n    at AuthController.refreshAuth (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\auth\\auth.controller.ts:56:30)\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:38:29\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:46:28\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-proxy.js:9:17	{"query": {}, "params": {}, "exception": {"error": "Unauthorized", "message": "No valid Refresh Token found", "statusCode": 401}}	/api/auth/refresh	GET	::1
2a372c6e-a0be-4c50-9749-5a33d2372d30	2026-01-18 00:44:46.621+00	ERROR	BACKEND	GlobalExceptionFilter	\N	\N	No valid Refresh Token found	UnauthorizedException: No valid Refresh Token found\n    at AuthController.refreshAuth (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\auth\\auth.controller.ts:56:30)\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:38:29\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:46:28\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-proxy.js:9:17	{"query": {}, "params": {}, "exception": {"error": "Unauthorized", "message": "No valid Refresh Token found", "statusCode": 401}}	/api/auth/refresh	GET	::1
11c1ce30-f02c-4f41-b005-d1af364e173e	2026-01-18 00:45:03.527+00	ERROR	BACKEND	GlobalExceptionFilter	\N	\N	No valid Refresh Token found	UnauthorizedException: No valid Refresh Token found\n    at AuthController.refreshAuth (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\auth\\auth.controller.ts:56:30)\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:38:29\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:46:28\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-proxy.js:9:17	{"query": {}, "params": {}, "exception": {"error": "Unauthorized", "message": "No valid Refresh Token found", "statusCode": 401}}	/api/auth/refresh	GET	::1
a8c752ac-5e6c-4838-bce3-863b9353d831	2026-01-18 00:52:38.829+00	ERROR	BACKEND	GlobalExceptionFilter	\N	\N	No valid Refresh Token found	UnauthorizedException: No valid Refresh Token found\n    at AuthController.refreshAuth (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\auth\\auth.controller.ts:56:30)\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:38:29\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:46:28\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-proxy.js:9:17	{"query": {}, "params": {}, "exception": {"error": "Unauthorized", "message": "No valid Refresh Token found", "statusCode": 401}}	/api/auth/refresh	GET	::1
e7c377f2-7a36-4971-b133-e5d248d1a7bf	2026-01-18 00:52:38.925+00	ERROR	BACKEND	GlobalExceptionFilter	\N	\N	No valid Refresh Token found	UnauthorizedException: No valid Refresh Token found\n    at AuthController.refreshAuth (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\auth\\auth.controller.ts:56:30)\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:38:29\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:46:28\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-proxy.js:9:17	{"query": {}, "params": {}, "exception": {"error": "Unauthorized", "message": "No valid Refresh Token found", "statusCode": 401}}	/api/auth/refresh	GET	::1
0df19ba1-c6f8-46e9-94b0-e38e7a0baf22	2026-01-18 00:53:07.507+00	ERROR	BACKEND	GlobalExceptionFilter	\N	\N	No valid Refresh Token found	UnauthorizedException: No valid Refresh Token found\n    at AuthController.refreshAuth (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\auth\\auth.controller.ts:56:30)\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:38:29\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:46:28\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-proxy.js:9:17	{"query": {}, "params": {}, "exception": {"error": "Unauthorized", "message": "No valid Refresh Token found", "statusCode": 401}}	/api/auth/refresh	GET	::1
192261a4-bda8-4a77-9f3d-c10aa79d09af	2026-01-18 01:02:43.12+00	ERROR	BACKEND	GlobalExceptionFilter	\N	\N	No valid Refresh Token found	UnauthorizedException: No valid Refresh Token found\n    at AuthController.refreshAuth (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\auth\\auth.controller.ts:56:30)\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:38:29\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:46:28\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-proxy.js:9:17	{"query": {}, "params": {}, "exception": {"error": "Unauthorized", "message": "No valid Refresh Token found", "statusCode": 401}}	/api/auth/refresh	GET	::1
df0de882-e98e-40f8-a811-a420da66d311	2026-01-18 01:12:53.88+00	ERROR	BACKEND	GlobalExceptionFilter	\N	\N	No valid Refresh Token found	UnauthorizedException: No valid Refresh Token found\n    at AuthController.refreshAuth (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\auth\\auth.controller.ts:56:30)\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:38:29\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:46:28\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-proxy.js:9:17	{"query": {}, "params": {}, "exception": {"error": "Unauthorized", "message": "No valid Refresh Token found", "statusCode": 401}}	/api/auth/refresh	GET	::1
5a6ded23-d8e7-4949-82c9-2eb72fdeba27	2026-01-18 01:12:53.959+00	ERROR	BACKEND	GlobalExceptionFilter	\N	\N	No valid Refresh Token found	UnauthorizedException: No valid Refresh Token found\n    at AuthController.refreshAuth (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\auth\\auth.controller.ts:56:30)\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:38:29\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:46:28\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-proxy.js:9:17	{"query": {}, "params": {}, "exception": {"error": "Unauthorized", "message": "No valid Refresh Token found", "statusCode": 401}}	/api/auth/refresh	GET	::1
d43a1034-31a4-4156-8474-796b3a93aec5	2026-01-18 01:34:59.489+00	ERROR	BACKEND	GlobalExceptionFilter	\N	\N	No valid Refresh Token found	UnauthorizedException: No valid Refresh Token found\n    at AuthController.refreshAuth (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\auth\\auth.controller.ts:56:30)\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:38:29\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:46:28\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-proxy.js:9:17	{"query": {}, "params": {}, "exception": {"error": "Unauthorized", "message": "No valid Refresh Token found", "statusCode": 401}}	/api/auth/refresh	GET	::1
d072a061-3e13-4fa0-86ed-dd5c3fe45eb2	2026-01-18 02:58:29.175+00	ERROR	BACKEND	GlobalExceptionFilter	\N	\N	No valid Refresh Token found	UnauthorizedException: No valid Refresh Token found\n    at AuthController.refreshAuth (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\auth\\auth.controller.ts:56:30)\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:38:29\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:46:28\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-proxy.js:9:17	{"query": {}, "params": {}, "exception": {"error": "Unauthorized", "message": "No valid Refresh Token found", "statusCode": 401}}	/api/auth/refresh	GET	::1
1d2f118a-64d7-4df3-82e4-3a00c54e5c55	2026-01-18 03:20:34.76+00	ERROR	BACKEND	GlobalExceptionFilter	\N	\N	No valid Refresh Token found	UnauthorizedException: No valid Refresh Token found\n    at AuthController.refreshAuth (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\auth\\auth.controller.ts:56:30)\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:38:29\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:46:28\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-proxy.js:9:17	{"query": {}, "params": {}, "exception": {"error": "Unauthorized", "message": "No valid Refresh Token found", "statusCode": 401}}	/api/auth/refresh	GET	::1
f5b6de5d-1df4-4226-a46e-917b5f20cd63	2026-01-18 18:05:50.903+00	ERROR	BACKEND	GlobalExceptionFilter	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	admin@obs.com	Unauthorized	UnauthorizedException: Unauthorized\n    at MixinAuthGuard.handleRequest (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+passport@11.0.5_@ne_3e2e1635e1fc880657f155ecf43895f0\\node_modules\\@nestjs\\passport\\dist\\auth.guard.js:60:30)\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+passport@11.0.5_@ne_3e2e1635e1fc880657f155ecf43895f0\\node_modules\\@nestjs\\passport\\dist\\auth.guard.js:44:124\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+passport@11.0.5_@ne_3e2e1635e1fc880657f155ecf43895f0\\node_modules\\@nestjs\\passport\\dist\\auth.guard.js:83:24\n    at allFailed (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\passport@0.7.0\\node_modules\\passport\\lib\\middleware\\authenticate.js:110:18)\n    at attempt (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\passport@0.7.0\\node_modules\\passport\\lib\\middleware\\authenticate.js:183:28)\n    at strategy.fail (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\passport@0.7.0\\node_modules\\passport\\lib\\middleware\\authenticate.js:314:9)\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\passport-jwt@4.0.1\\node_modules\\passport-jwt\\lib\\strategy.js:106:33\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\jsonwebtoken@9.0.3\\node_modules\\jsonwebtoken\\verify.js:190:16\n    at getSecret (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\jsonwebtoken@9.0.3\\node_modules\\jsonwebtoken\\verify.js:97:14)\n    at module.exports [as verify] (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\jsonwebtoken@9.0.3\\node_modules\\jsonwebtoken\\verify.js:101:10)	{"query": {}, "params": {}, "exception": {"message": "Unauthorized", "statusCode": 401}}	/api/error-logs	GET	::1
65bae8a8-ee54-4043-87dd-8dbf3ad3ea47	2026-01-18 18:41:56.116+00	CRITICAL	BACKEND	GlobalExceptionFilter	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	admin@obs.com	\nInvalid `this.prisma.marea.findMany()` invocation in\nD:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\stats\\stats.service.ts:243:48\n\n  240     where.observadorPrincipalId = filterValue;\n  241 }\n  242 \n→ 243 const mareas = await this.prisma.marea.findMany(\nInvalid input value: invalid input syntax for type uuid: "Juan José Coppa"	PrismaClientKnownRequestError: \nInvalid `this.prisma.marea.findMany()` invocation in\nD:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\stats\\stats.service.ts:243:48\n\n  240     where.observadorPrincipalId = filterValue;\n  241 }\n  242 \n→ 243 const mareas = await this.prisma.marea.findMany(\nInvalid input value: invalid input syntax for type uuid: "Juan José Coppa"\n    at qr.handleRequestError (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@prisma+client@7.2.0_prisma_f75d495222e5a9a082c60aa675bb2498\\node_modules\\@prisma\\client\\src\\runtime\\RequestHandler.ts:228:13)\n    at qr.handleAndLogRequestError (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@prisma+client@7.2.0_prisma_f75d495222e5a9a082c60aa675bb2498\\node_modules\\@prisma\\client\\src\\runtime\\RequestHandler.ts:174:12)\n    at qr.request (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@prisma+client@7.2.0_prisma_f75d495222e5a9a082c60aa675bb2498\\node_modules\\@prisma\\client\\src\\runtime\\RequestHandler.ts:143:12)\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async a (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@prisma+client@7.2.0_prisma_f75d495222e5a9a082c60aa675bb2498\\node_modules\\@prisma\\client\\src\\runtime\\getPrismaClient.ts:805:24)\n    at async StatsService.getDashboardStatsDetail (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\stats\\stats.service.ts:243:24)\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:46:28\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-proxy.js:9:17	{"query": {"mode": "CALENDAR", "year": "2025", "filterType": "OBSERVER", "filterValue": "Juan José Coppa", "includeNonProtocolized": "true", "includeProtocolizedOutOfPeriod": "false"}, "params": {}, "exception": {"code": "P2007", "meta": {"modelName": "Marea", "driverAdapterError": {"name": "DriverAdapterError", "cause": {"kind": "InvalidInputValue", "message": "invalid input syntax for type uuid: \\"Juan José Coppa\\"", "originalCode": "22P02", "originalMessage": "invalid input syntax for type uuid: \\"Juan José Coppa\\""}}}, "name": "PrismaClientKnownRequestError", "clientVersion": "7.2.0"}}	/api/stats/detail?year=2025&mode=CALENDAR&includeNonProtocolized=true&includeProtocolizedOutOfPeriod=false&filterType=OBSERVER&filterValue=Juan+Jos%C3%A9+Coppa	GET	::1
30024b64-e634-4823-af23-7c960455d740	2026-01-18 23:35:07.475+00	ERROR	BACKEND	GlobalExceptionFilter	\N	\N	Token de refresco inválido o expirado	UnauthorizedException: Token de refresco inválido o expirado\n    at AuthService.refreshAuth (/app/dist/src/auth/auth.service.js:188:19)\n    at process.processTicksAndRejections (node:internal/process/task_queues:95:5)\n    at async AuthController.refreshAuth (/app/dist/src/auth/auth.controller.js:45:22)\n    at async /app/node_modules/.pnpm/@nestjs+core@11.1.12_@nestjs+common@11.1.12_class-transformer@0.5.1_class-validator@0.1_cbe7cfc41de5bef826b769e633ad1837/node_modules/@nestjs/core/router/router-execution-context.js:46:28\n    at async /app/node_modules/.pnpm/@nestjs+core@11.1.12_@nestjs+common@11.1.12_class-transformer@0.5.1_class-validator@0.1_cbe7cfc41de5bef826b769e633ad1837/node_modules/@nestjs/core/router/router-proxy.js:9:17	{"query": {}, "params": {}, "exception": {"error": "Unauthorized", "message": "Token de refresco inválido o expirado", "statusCode": 401}}	/api/auth/refresh	GET	181.116.42.73
882e3826-6361-4eb3-b64c-2964a49f6eb2	2026-01-18 18:44:07.91+00	CRITICAL	BACKEND	GlobalExceptionFilter	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	admin@obs.com	\nInvalid `this.prisma.marea.findMany()` invocation in\nD:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\stats\\stats.service.ts:243:48\n\n  240     where.observadorPrincipalId = filterValue;\n  241 }\n  242 \n→ 243 const mareas = await this.prisma.marea.findMany(\nInvalid input value: invalid input syntax for type uuid: "Juan José Coppa"	PrismaClientKnownRequestError: \nInvalid `this.prisma.marea.findMany()` invocation in\nD:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\stats\\stats.service.ts:243:48\n\n  240     where.observadorPrincipalId = filterValue;\n  241 }\n  242 \n→ 243 const mareas = await this.prisma.marea.findMany(\nInvalid input value: invalid input syntax for type uuid: "Juan José Coppa"\n    at qr.handleRequestError (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@prisma+client@7.2.0_prisma_f75d495222e5a9a082c60aa675bb2498\\node_modules\\@prisma\\client\\src\\runtime\\RequestHandler.ts:228:13)\n    at qr.handleAndLogRequestError (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@prisma+client@7.2.0_prisma_f75d495222e5a9a082c60aa675bb2498\\node_modules\\@prisma\\client\\src\\runtime\\RequestHandler.ts:174:12)\n    at qr.request (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@prisma+client@7.2.0_prisma_f75d495222e5a9a082c60aa675bb2498\\node_modules\\@prisma\\client\\src\\runtime\\RequestHandler.ts:143:12)\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async a (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@prisma+client@7.2.0_prisma_f75d495222e5a9a082c60aa675bb2498\\node_modules\\@prisma\\client\\src\\runtime\\getPrismaClient.ts:805:24)\n    at async StatsService.getDashboardStatsDetail (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\backend\\src\\stats\\stats.service.ts:243:24)\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:46:28\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-proxy.js:9:17	{"query": {"mode": "CALENDAR", "year": "2025", "filterType": "OBSERVER", "filterValue": "Juan José Coppa", "includeNonProtocolized": "true", "includeProtocolizedOutOfPeriod": "false"}, "params": {}, "exception": {"code": "P2007", "meta": {"modelName": "Marea", "driverAdapterError": {"name": "DriverAdapterError", "cause": {"kind": "InvalidInputValue", "message": "invalid input syntax for type uuid: \\"Juan José Coppa\\"", "originalCode": "22P02", "originalMessage": "invalid input syntax for type uuid: \\"Juan José Coppa\\""}}}, "name": "PrismaClientKnownRequestError", "clientVersion": "7.2.0"}}	/api/stats/detail?year=2025&mode=CALENDAR&includeNonProtocolized=true&includeProtocolizedOutOfPeriod=false&filterType=OBSERVER&filterValue=Juan+Jos%C3%A9+Coppa	GET	::1
544b4e3f-a3d0-4532-a211-573bd15fa23d	2026-01-18 19:17:40.967+00	ERROR	BACKEND	GlobalExceptionFilter	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	admin@obs.com	Validation failed (boolean string is expected)	BadRequestException: Validation failed (boolean string is expected)\n    at ParseBoolPipe.exceptionFactory (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+common@11.1.10_clas_ef3082dcd13cc376fcae0bf4ef553349\\node_modules\\@nestjs\\common\\pipes\\parse-bool.pipe.js:24:27)\n    at ParseBoolPipe.transform (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+common@11.1.10_clas_ef3082dcd13cc376fcae0bf4ef553349\\node_modules\\@nestjs\\common\\pipes\\parse-bool.pipe.js:43:20)\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\pipes\\pipes-consumer.js:16:33\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async resolveParamValue (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:148:23)\n    at async Promise.all (index 0)\n    at async pipesFn (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:151:13)\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:37:30\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:46:28\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-proxy.js:9:17	{"query": {"mode": "CALENDAR", "year": "2025", "includeCampaigns": "undefined", "daysCalculationMode": "undefined", "includeNonProtocolized": "true", "includeProtocolizedOutOfPeriod": "false"}, "params": {}, "exception": {"error": "Bad Request", "message": "Validation failed (boolean string is expected)", "statusCode": 400}}	/api/stats/dashboard?year=2025&mode=CALENDAR&includeNonProtocolized=true&includeProtocolizedOutOfPeriod=false&daysCalculationMode=undefined&includeCampaigns=undefined	GET	::1
5645abfb-236c-44bc-9ae5-53722497a323	2026-01-18 19:17:40.995+00	ERROR	BACKEND	GlobalExceptionFilter	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	admin@obs.com	Validation failed (boolean string is expected)	BadRequestException: Validation failed (boolean string is expected)\n    at ParseBoolPipe.exceptionFactory (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+common@11.1.10_clas_ef3082dcd13cc376fcae0bf4ef553349\\node_modules\\@nestjs\\common\\pipes\\parse-bool.pipe.js:24:27)\n    at ParseBoolPipe.transform (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+common@11.1.10_clas_ef3082dcd13cc376fcae0bf4ef553349\\node_modules\\@nestjs\\common\\pipes\\parse-bool.pipe.js:43:20)\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\pipes\\pipes-consumer.js:16:33\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async resolveParamValue (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:148:23)\n    at async Promise.all (index 0)\n    at async pipesFn (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:151:13)\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:37:30\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:46:28\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-proxy.js:9:17	{"query": {"mode": "CALENDAR", "year": "2025", "includeCampaigns": "undefined", "daysCalculationMode": "undefined", "includeNonProtocolized": "true", "includeProtocolizedOutOfPeriod": "false"}, "params": {}, "exception": {"error": "Bad Request", "message": "Validation failed (boolean string is expected)", "statusCode": 400}}	/api/stats/dashboard?year=2025&mode=CALENDAR&includeNonProtocolized=true&includeProtocolizedOutOfPeriod=false&daysCalculationMode=undefined&includeCampaigns=undefined	GET	::1
83cd649c-6614-474e-883a-28859a5f22c8	2026-01-18 20:01:42.018+00	ERROR	BACKEND	GlobalExceptionFilter	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	admin@obs.com	Unauthorized	UnauthorizedException: Unauthorized\n    at MixinAuthGuard.handleRequest (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+passport@11.0.5_@ne_3e2e1635e1fc880657f155ecf43895f0\\node_modules\\@nestjs\\passport\\dist\\auth.guard.js:60:30)\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+passport@11.0.5_@ne_3e2e1635e1fc880657f155ecf43895f0\\node_modules\\@nestjs\\passport\\dist\\auth.guard.js:44:124\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+passport@11.0.5_@ne_3e2e1635e1fc880657f155ecf43895f0\\node_modules\\@nestjs\\passport\\dist\\auth.guard.js:83:24\n    at allFailed (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\passport@0.7.0\\node_modules\\passport\\lib\\middleware\\authenticate.js:110:18)\n    at attempt (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\passport@0.7.0\\node_modules\\passport\\lib\\middleware\\authenticate.js:183:28)\n    at strategy.fail (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\passport@0.7.0\\node_modules\\passport\\lib\\middleware\\authenticate.js:314:9)\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\passport-jwt@4.0.1\\node_modules\\passport-jwt\\lib\\strategy.js:106:33\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\jsonwebtoken@9.0.3\\node_modules\\jsonwebtoken\\verify.js:171:14\n    at getSecret (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\jsonwebtoken@9.0.3\\node_modules\\jsonwebtoken\\verify.js:97:14)\n    at module.exports [as verify] (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\jsonwebtoken@9.0.3\\node_modules\\jsonwebtoken\\verify.js:101:10)\n    at module.exports [as JwtVerifier] (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\passport-jwt@4.0.1\\node_modules\\passport-jwt\\lib\\verify_jwt.js:4:16)\n    at D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\passport-jwt@4.0.1\\node_modules\\passport-jwt\\lib\\strategy.js:104:25\n    at JwtStrategy._secretOrKeyProvider (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\passport-jwt@4.0.1\\node_modules\\passport-jwt\\lib\\strategy.js:40:13)\n    at JwtStrategy.authenticate (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\passport-jwt@4.0.1\\node_modules\\passport-jwt\\lib\\strategy.js:99:10)\n    at attempt (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\passport@0.7.0\\node_modules\\passport\\lib\\middleware\\authenticate.js:378:16)\n    at authenticate (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\passport@0.7.0\\node_modules\\passport\\lib\\middleware\\authenticate.js:379:7)	{"query": {"mode": "CALENDAR", "year": "2026", "includeCampaigns": "true", "protocolizedOnly": "false", "includeOutOfPeriod": "false", "daysCalculationMode": "SHIP"}, "params": {}, "exception": {"message": "Unauthorized", "statusCode": 401}}	/api/stats/dashboard?year=2026&mode=CALENDAR&protocolizedOnly=false&includeOutOfPeriod=false&daysCalculationMode=SHIP&includeCampaigns=true	GET	::1
f3b6f589-2506-47e2-9748-4e83053ea0f9	2026-01-18 20:47:56.252+00	ERROR	BACKEND	GlobalExceptionFilter	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	admin@obs.com	Bad Request Exception	BadRequestException: Bad Request Exception\n    at ValidationPipe.exceptionFactory (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+common@11.1.10_clas_ef3082dcd13cc376fcae0bf4ef553349\\node_modules\\@nestjs\\common\\pipes\\validation.pipe.js:107:20)\n    at ValidationPipe.transform (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+common@11.1.10_clas_ef3082dcd13cc376fcae0bf4ef553349\\node_modules\\@nestjs\\common\\pipes\\validation.pipe.js:74:30)\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async resolveParamValue (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:148:23)\n    at async Promise.all (index 0)\n    at async pipesFn (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:151:13)\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:37:30\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:46:28\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-proxy.js:9:17	{"query": {"mode": "CALENDAR", "year": "2026", "includeCampaigns": "true", "protocolizedOnly": "false", "includeOutOfPeriod": "false", "daysCalculationMode": "SHIP"}, "params": {}, "exception": {"error": "Bad Request", "message": ["property protocolizedOnly should not exist", "property includeOutOfPeriod should not exist"], "statusCode": 400}}	/api/stats/dashboard?year=2026&mode=CALENDAR&protocolizedOnly=false&includeOutOfPeriod=false&daysCalculationMode=SHIP&includeCampaigns=true	GET	::1
43e772e8-1d76-460f-a3e2-763baaab813f	2026-01-18 20:49:15.571+00	ERROR	BACKEND	GlobalExceptionFilter	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	admin@obs.com	Bad Request Exception	BadRequestException: Bad Request Exception\n    at ValidationPipe.exceptionFactory (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+common@11.1.10_clas_ef3082dcd13cc376fcae0bf4ef553349\\node_modules\\@nestjs\\common\\pipes\\validation.pipe.js:107:20)\n    at ValidationPipe.transform (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+common@11.1.10_clas_ef3082dcd13cc376fcae0bf4ef553349\\node_modules\\@nestjs\\common\\pipes\\validation.pipe.js:74:30)\n    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)\n    at async resolveParamValue (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:148:23)\n    at async Promise.all (index 0)\n    at async pipesFn (D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:151:13)\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:37:30\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-execution-context.js:46:28\n    at async D:\\Desarrollo\\_INIDEP\\OBS\\Mareas\\gestion-mareas-monorepo\\node_modules\\.pnpm\\@nestjs+core@11.1.10_@nestj_b5f02ff7785faa9780f5d6ffeeed115b\\node_modules\\@nestjs\\core\\router\\router-proxy.js:9:17	{"query": {"mode": "CALENDAR", "year": "2026", "includeCampaigns": "true", "includeOutOfPeriod": "false", "daysCalculationMode": "SHIP", "includeNonProtocolized": "false"}, "params": {}, "exception": {"error": "Bad Request", "message": ["property includeOutOfPeriod should not exist"], "statusCode": 400}}	/api/stats/dashboard?year=2026&mode=CALENDAR&includeNonProtocolized=false&includeOutOfPeriod=false&daysCalculationMode=SHIP&includeCampaigns=true	GET	::1
77777009-516a-4f76-aece-0c3a53e64f26	2026-01-19 01:02:05.635+00	ERROR	BACKEND	GlobalExceptionFilter	\N	\N	No valid Refresh Token found	UnauthorizedException: No valid Refresh Token found\n    at AuthController.refreshAuth (/app/dist/src/auth/auth.controller.js:44:19)\n    at /app/node_modules/.pnpm/@nestjs+core@11.1.12_@nestjs+common@11.1.12_class-transformer@0.5.1_class-validator@0.1_cbe7cfc41de5bef826b769e633ad1837/node_modules/@nestjs/core/router/router-execution-context.js:38:29\n    at process.processTicksAndRejections (node:internal/process/task_queues:95:5)\n    at async /app/node_modules/.pnpm/@nestjs+core@11.1.12_@nestjs+common@11.1.12_class-transformer@0.5.1_class-validator@0.1_cbe7cfc41de5bef826b769e633ad1837/node_modules/@nestjs/core/router/router-execution-context.js:46:28\n    at async /app/node_modules/.pnpm/@nestjs+core@11.1.12_@nestjs+common@11.1.12_class-transformer@0.5.1_class-validator@0.1_cbe7cfc41de5bef826b769e633ad1837/node_modules/@nestjs/core/router/router-proxy.js:9:17	{"query": {}, "params": {}, "exception": {"error": "Unauthorized", "message": "No valid Refresh Token found", "statusCode": 401}}	/api/auth/refresh	GET	98.84.16.97
ad36add7-4e02-4c57-b546-ce769c44f1eb	2026-01-19 01:23:21.898+00	ERROR	BACKEND	GlobalExceptionFilter	\N	\N	No valid Refresh Token found	UnauthorizedException: No valid Refresh Token found\n    at AuthController.refreshAuth (/app/dist/src/auth/auth.controller.js:44:19)\n    at /app/node_modules/.pnpm/@nestjs+core@11.1.12_@nestjs+common@11.1.12_class-transformer@0.5.1_class-validator@0.1_cbe7cfc41de5bef826b769e633ad1837/node_modules/@nestjs/core/router/router-execution-context.js:38:29\n    at process.processTicksAndRejections (node:internal/process/task_queues:95:5)\n    at async /app/node_modules/.pnpm/@nestjs+core@11.1.12_@nestjs+common@11.1.12_class-transformer@0.5.1_class-validator@0.1_cbe7cfc41de5bef826b769e633ad1837/node_modules/@nestjs/core/router/router-execution-context.js:46:28\n    at async /app/node_modules/.pnpm/@nestjs+core@11.1.12_@nestjs+common@11.1.12_class-transformer@0.5.1_class-validator@0.1_cbe7cfc41de5bef826b769e633ad1837/node_modules/@nestjs/core/router/router-proxy.js:9:17	{"query": {}, "params": {}, "exception": {"error": "Unauthorized", "message": "No valid Refresh Token found", "statusCode": 401}}	/api/auth/refresh	GET	181.116.42.73
\.


--
-- Data for Name: especies; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.especies (id, codigo, nombre_cientifico, nombre_vulgar, activo, observaciones) FROM stdin;
11de983d-d75f-4163-bed4-4567e7000cab	0000000001	Genypterus blacodes	Abadejo	t	\N
d2712692-43ec-4e22-9a14-2752dedce408	0000000002	Engraulis anchoita	Anchoíta	t	\N
a5fa88a0-aa33-4db2-b598-bdb20a85ee94	0000000003	Scomber japonicus	Caballa	t	\N
670f708e-0cb6-466c-8912-c0b73032e226	0000000004	Illex argentinus	Calamar	t	\N
cfc4704f-7bc5-4e7e-99b4-82980b89bd40	0000000005	Lithodes santolla	Centolla	t	\N
bc006fad-2cde-413d-bba9-bbafb64aca81	0000000006	-	Especies australes	t	\N
5d88a2f5-81f5-423e-bbcb-ddb342fa4236	0000000007	Pleoticus muelleri	Langostino	t	\N
c3bd201c-cc3c-45ef-a3f0-d250711e764c	0000000008	Merluccius hubbsi	Merluza común	t	\N
44b26c6a-895d-4a4b-bd13-92c3f43daa43	0000000009	Dissostichus eleginoides	Merluza negra	t	\N
2f5ded98-a3d2-4739-bfc4-48dd824319c2	0000000010	Zygochlamys patagonica	Vieira	t	\N
\.


--
-- Data for Name: estados_marea; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.estados_marea (id, codigo, nombre, descripcion, categoria, orden, es_inicial, es_final, permite_carga_archivos, permite_correccion, permite_informe, activo, mostrar_en_panel) FROM stdin;
3af8b7d1-f41d-4029-83ae-ef5e178ff565	DESIGNADA	Designada	\N	PENDIENTE	1	t	f	f	f	f	t	t
97219917-fdf2-4aca-b415-96de17cc505e	EN_EJECUCION	En ejecución	\N	PENDIENTE	2	f	f	f	f	f	t	t
45672467-a4db-462d-8228-2a21ce82cc37	ESPERANDO_ENTREGA	Esperando entrega de datos	\N	PENDIENTE	3	f	f	f	f	f	t	t
90b003ac-517d-4a4e-8f2e-c4be43110b5a	ENTREGADA_RECIBIDA	Entregada / Recibida	\N	PENDIENTE	4	f	f	t	f	f	t	t
b05afd0d-7633-4e10-acfe-94348fd0594b	VERIFICACION_INICIAL	Verificación inicial	\N	EN_CURSO	5	f	f	t	f	f	t	t
6cc45c99-3bae-4e9a-89b9-111236860b37	EN_CORRECCION	En corrección interna	\N	EN_CURSO	6	f	f	t	t	f	t	t
2c81a996-634d-4153-af0d-d8d9250a6870	DELEGADA_EXTERNA	Delegada / En espera externa	\N	EN_CURSO	7	f	f	t	f	f	t	f
f7efe5ec-56fe-49a0-ad06-780fc4d7d6b9	PENDIENTE_DE_INFORME	Pendiente de informe	\N	EN_CURSO	8	f	f	f	f	t	t	t
62d21e2c-9542-437f-9979-057c4595cdbc	ESPERANDO_REVISION	Esperando revisión de informe	\N	EN_CURSO	9	f	f	f	f	t	t	f
e1582fe4-d48e-46fb-b156-7f7aaf3f9983	PARA_PROTOCOLIZAR	Para protocolizar	\N	EN_CURSO	10	f	f	f	f	t	t	f
d5ccab4b-9a9f-4c2b-97e9-560fafdffbfd	ESPERANDO_PROTOCOLIZACION	Esperando protocolización	\N	EN_CURSO	11	f	f	f	f	t	t	f
76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	PROTOCOLIZADA	Protocolizada / Finalizada	\N	COMPLETADO	12	f	t	f	f	t	t	f
2ea71871-f6e2-480b-bb64-6d2f436ffa6f	CANCELADA	Cancelada / Desestimada	\N	CANCELADO	13	f	t	f	f	f	t	f
\.


--
-- Data for Name: importacion_access_snapshots; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.importacion_access_snapshots (id, id_externo, nro_marea, anio_marea, tipo_marea, nro_etapa, fecha_zarpada, fecha_arribo, buque_nombre, observador_codigo, hash_contenido, fecha_primera_lectura, fecha_ultima_lectura, marea_id, etapa_id) FROM stdin;
59f52734-0650-49b9-a616-7a5b330b20d1	20	153	2024	MC	1	2024-10-04	2024-10-20	MISS TIDE	9465	b981c57f9cc47d50eb4ba656211842c8	2026-01-16 21:31:46.992+00	2026-01-16 21:31:46.992+00	\N	\N
574cc121-cec1-4a11-a202-312fb413d833	22	152	2024	MC	1	2024-10-04	2024-11-13	ATLANTIC SURF III	7610	fe6580173fe57aa5cf1dbb724b756703	2026-01-16 21:31:47.054+00	2026-01-16 21:31:47.054+00	\N	\N
734f8142-c732-4a80-8fba-ace4c9c4a0b2	23	155	2024	MC	1	2024-10-15	2024-11-02	ERIN BRUCE II	186	3cd407d33255c6a9f1e2b4143500ec27	2026-01-16 21:31:47.078+00	2026-01-16 21:31:47.078+00	\N	\N
29ec7d93-fc50-4045-8dce-f13ef076ff1e	24	143	2024	MC	1	2024-09-18	2024-10-30	TAI AN	7729	8044f28bb7f49788fda903651b6aca9c	2026-01-16 21:31:47.116+00	2026-01-16 21:31:47.116+00	\N	\N
c76f6e0a-6d2a-43c4-8671-3fda3cc967f3	26	158	2024	MC	1	2024-10-19	2024-11-25	CAPESANTE	9480	e1a47210b3fb41c1d373579ce9f52fc4	2026-01-16 21:31:47.135+00	2026-01-16 21:31:47.135+00	\N	\N
0c6b8059-17a4-473d-8eb1-4121a0b18e02	27	154	2024	MC	1	2025-01-01	2024-10-13	ARGENTINO	7796	f8aa7288e0dfbcddb832552a2fc3c293	2026-01-16 21:31:47.156+00	2026-01-16 21:31:47.156+00	\N	\N
fd5c7e2b-b7d4-40a6-80c6-035d469f48f0	29	\N	2024	CI	1	2024-10-21	2024-11-29	PRINCIPE AZUL	7627	dcf379b877df11af64ce3479511b8754	2026-01-16 21:31:47.178+00	2026-01-16 21:31:47.178+00	\N	\N
2015a650-0e86-436d-adda-02beb0baeedd	32	151	2024	MC	1	2024-10-10	2024-12-03	ECHIZEN MARU	7838	88dff67b5b21902dad19e343b99f7a96	2026-01-16 21:31:47.197+00	2026-01-16 21:31:47.197+00	\N	\N
41f2f3c6-3361-496b-8c00-0d7f5473a963	33	\N	2024	CI	1	2024-10-04	2024-10-28	ATLANTIC EXPRESS	183	54653444301a96e534d8fa887e349b70	2026-01-16 21:31:47.217+00	2026-01-16 21:31:47.217+00	\N	\N
8cce640c-b9af-439b-8530-6f1862280d5e	34	\N	2024	CI	1	2024-10-08	2024-10-29	TANGO II	9461	be6b040fbb84442d638d1e347da5c5e7	2026-01-16 21:31:47.237+00	2026-01-16 21:31:47.237+00	\N	\N
5c513264-c5e5-4601-a898-ec86975055e2	36	\N	2024	CI	1	2024-08-02	2024-12-15	CHIYO MARU NO.3	190	f4e11d38c86844f9ce80a6fee73a607c	2026-01-16 21:31:47.256+00	2026-01-16 21:31:47.256+00	\N	\N
dd629470-79fb-4524-8998-bc61e0faa786	37	\N	2024	CI	1	2024-10-08	2024-10-29	TANGO II	7828	c3e324ec06423a55a43056ed41a98e3c	2026-01-16 21:31:47.282+00	2026-01-16 21:31:47.282+00	\N	\N
667db91b-36ed-495b-afbf-ad64c33de73a	38	\N	2024	CI	1	2024-10-03	2024-10-26	DUKAT	7841	87a451cda4e906656e7ef635d5c48f51	2026-01-16 21:31:47.302+00	2026-01-16 21:31:47.302+00	\N	\N
f9ee3262-cc92-4faf-9f86-c7e4efb913f5	41	159	2024	MC	1	2024-10-23	2024-11-08	MISS TIDE	9465	0f191c7e1f58816f527e71c99f416b0f	2026-01-16 21:31:47.323+00	2026-01-16 21:31:47.323+00	\N	\N
827313e2-96f2-4489-9432-8bc754bf32f6	43	160	2024	MC	1	2024-11-01	2024-12-12	VALERIA DEL ATLANTICO	7726	370393217e64b924bb58ebbd6a774e16	2026-01-16 21:31:47.343+00	2026-01-16 21:31:47.343+00	\N	\N
61ab72fb-e573-4ab0-b75d-057e3162d606	45	162	2024	MC	1	2024-11-02	2024-11-23	ATLANTIC EXPRESS	183	7c58e119ac706cdeda4d960ad74bf5e1	2026-01-16 21:31:47.361+00	2026-01-16 21:31:47.361+00	\N	\N
65a80f6e-fa5d-4fbd-bd56-18aaaf648f33	46	161	2023	MC	1	2023-12-28	2024-02-01	TAI AN	7617	a27b6367f87b496b2669bdac287122a6	2026-01-16 21:31:47.38+00	2026-01-16 21:31:47.38+00	\N	\N
1c8f7064-7958-4dd6-9983-62c5970200cf	47	146	2024	MC	1	2024-11-04	2024-11-28	TANGO I	2021	64bee041b790329405dc7c03c1d8f0c0	2026-01-16 21:31:47.398+00	2026-01-16 21:31:47.398+00	\N	\N
bf42c994-f8bd-45ab-92fc-ea36f0bcc0a9	48	147	2024	MC	1	2024-10-31	2024-11-26	TANGO II	7828	33f4e1cd1f9842705bbc4eae78d37399	2026-01-16 21:31:47.418+00	2026-01-16 21:31:47.418+00	\N	\N
9cd74e36-9989-4ca3-adfb-1bb4015b45a6	49	156	2024	MC	1	2024-11-01	2024-11-07	ARGENTINO	7796	492a88b97aaf9b5c4e04c2dd79b667e0	2026-01-16 21:31:47.437+00	2026-01-16 21:31:47.437+00	\N	\N
2bbb185e-3b8e-4c2f-93c5-765d37dbdb2a	51	166	2024	MC	1	2024-11-20	2024-12-10	TALISMAN	7624	d7ca0c4e13c35ab77e2e5b97cc06cfc9	2026-01-16 21:31:47.457+00	2026-01-16 21:31:47.457+00	\N	\N
798b5d49-1c47-4525-ac1b-c2eb1aa028bd	74	\N	2024	CI	1	2024-10-03	2024-10-29	TALISMAN	7842	6d35bb6069878b0a2c26a71c62abdb1a	2026-01-16 21:31:47.476+00	2026-01-16 21:31:47.476+00	\N	\N
4702f352-cadc-49f5-b9f5-30ad9b77c806	75	\N	2024	CI	1	2024-10-31	2024-11-02	TALISMAN	7842	4b7d43aeebefacd474478a178ed2f56d	2026-01-16 21:31:47.494+00	2026-01-16 21:31:47.494+00	\N	\N
c5501ec2-f386-4fdb-a6e3-53fbaa3cd270	76	\N	2024	CI	1	2024-11-07	2024-11-18	TALISMAN	7842	33a896d2c4537b2d31e658603220aad7	2026-01-16 21:31:47.511+00	2026-01-16 21:31:47.511+00	\N	\N
214c1245-4a8a-4851-b1eb-51651b317a10	77	145	2024	MC	1	2024-10-28	2024-11-22	DUKAT	7841	fb552c15fd7c2d41bf14ea1b1b378efc	2026-01-16 21:31:47.531+00	2026-01-16 21:31:47.531+00	\N	\N
428898ac-1ddc-4905-9eee-78059e37f1a5	78	145	2024	MC	1	2024-11-28	2024-12-10	DUKAT	7841	671e1674fee0747ea56ae632eac6d7df	2026-01-16 21:31:47.55+00	2026-01-16 21:31:47.55+00	\N	\N
e8b4c1dd-d37e-41f0-ba5b-50b9913faaa7	82	138	2024	MC	1	2024-09-05	2024-09-25	ARGENOVA XXI	73	f359cbe2aa02218224e738ee3d864226	2026-01-16 21:31:47.57+00	2026-01-16 21:31:47.57+00	\N	\N
0105ab72-afb4-4dc5-8a0a-97daf46c1c76	83	138	2024	MC	1	2024-10-02	2024-10-31	ARGENOVA XXI	73	ccc5c0640831576e5fd713304db79017	2026-01-16 21:31:47.589+00	2026-01-16 21:31:47.589+00	\N	\N
3d45defe-5d21-480e-8873-841b2bf8bcc0	92	156	2024	MC	1	2024-10-17	2024-10-23	ARGENTINO	7796	0802c02d215aefc121416d5c9982f368	2026-01-16 21:31:47.609+00	2026-01-16 21:31:47.609+00	\N	\N
8d4576d1-e8fb-4bee-bca0-bdb86911edc6	93	156	2024	MC	1	2024-10-24	2024-10-31	ARGENTINO	7796	1db2f1f23b37cabdb613c38cee4cb198	2026-01-16 21:31:47.628+00	2026-01-16 21:31:47.628+00	\N	\N
336bbf41-4bca-424a-9006-83158340abf4	94	47	2024	MC	1	2024-03-26	2024-05-15	ECHIZEN MARU	7724	21d338c00bc0e3b6e8025f3a3c163086	2026-01-16 21:31:47.647+00	2026-01-16 21:31:47.647+00	\N	\N
8ace989a-e940-4b0d-ac40-d8c398243797	95	78	2024	MC	1	2024-05-17	2024-07-02	ECHIZEN MARU	7724	b61f0b446b45e149b17d802cc479b575	2026-01-16 21:31:47.666+00	2026-01-16 21:31:47.666+00	\N	\N
8b0b417f-1ad1-4fbf-b700-c815ee8f2347	96	7	2024	MC	1	2024-01-03	2024-01-23	MISS TIDE	7610	f7eda97ab1840a2078d96a9b876fdd86	2026-01-16 21:31:47.685+00	2026-01-16 21:31:47.685+00	\N	\N
052b79f3-7b95-4782-afa3-561cfb854aa8	97	26	2024	MC	1	2024-02-16	2024-03-24	CAPESANTE	7610	c3594d602d06151b55aca72ece06b167	2026-01-16 21:31:47.704+00	2026-01-16 21:31:47.704+00	\N	\N
c9a16bbd-64b8-41a2-b592-ea97ed0dbfc4	98	49	2024	MC	1	2024-03-28	2024-05-09	CAPESANTE	7610	7d941bda8b840563fb2b88122c260439	2026-01-16 21:31:47.723+00	2026-01-16 21:31:47.723+00	\N	\N
eec77ffe-6b12-4a81-80a5-0412a9c4424f	99	101	2024	MC	1	2024-06-26	2024-08-07	CAPESANTE	7610	24eb114669449329a116fbef684e6bbc	2026-01-16 21:31:47.745+00	2026-01-16 21:31:47.745+00	\N	\N
daf0f662-7f6a-4736-a4ef-125fb87adde5	101	60	2024	MC	1	2024-04-19	2024-05-13	ERIN BRUCE II	7562	93a83631f25a110760f57b7299b7294c	2026-01-16 21:31:47.764+00	2026-01-16 21:31:47.764+00	\N	\N
7d8ed4e0-ae01-47d9-80a6-82a58befe960	102	79	2024	MC	1	2024-05-16	2024-06-05	ERIN BRUCE II	7562	7e948401a38f98a235ba1b5fc4da72c6	2026-01-16 21:31:47.784+00	2026-01-16 21:31:47.784+00	\N	\N
900328c1-fe85-407e-92ac-87d18e6d678a	103	167	2023	MC	1	2023-12-30	2024-02-01	TANGO I	7841	69ae97b45d63f6d55f659be83194e4f8	2026-01-16 21:31:47.804+00	2026-01-16 21:31:47.804+00	\N	\N
ea981d38-837f-4ba2-8faa-c13d79d6e256	104	167	2023	MC	1	2024-02-04	2024-03-11	TANGO I	7841	95ad24a9e1d3ef4182e83270b1b45935	2026-01-16 21:31:47.824+00	2026-01-16 21:31:47.824+00	\N	\N
bd27eba6-151c-4e67-ac14-9ad3544d608a	105	55	2024	MC	1	2024-03-27	2024-04-14	FEDERICO C	7841	ef711c2f260948badfef7903652f545c	2026-01-16 21:31:47.843+00	2026-01-16 21:31:47.843+00	\N	\N
41a77289-5fd6-47db-aeb7-abd34cc90d5c	106	89	2024	MC	1	2024-05-22	2024-06-02	FEDERICO C	7841	ab9d4c06f9caac2b85fa214942306df1	2026-01-16 21:31:47.862+00	2026-01-16 21:31:47.862+00	\N	\N
8fc4c271-b00d-49d6-9ac5-1efd72b3b64c	107	89	2024	MC	1	2024-06-04	2024-06-18	FEDERICO C	7841	a405d7b14c983d59fdae48bc6b098e00	2026-01-16 21:31:47.88+00	2026-01-16 21:31:47.88+00	\N	\N
29aac3dd-a2fa-4c43-b892-49b0d22ec7e4	108	89	2024	MC	1	2024-06-19	2024-06-28	FEDERICO C	7841	31a04a27d7269f29e871f0349b0275f1	2026-01-16 21:31:47.898+00	2026-01-16 21:31:47.898+00	\N	\N
bfc3e120-cf91-4d2a-a56f-105835531e19	109	89	2024	MC	1	2024-06-30	2024-07-13	FEDERICO C	7841	52f34d2ff9d014a71881be808555784e	2026-01-16 21:31:47.918+00	2026-01-16 21:31:47.918+00	\N	\N
8df8a595-11fd-4dae-8137-3fa777c7c454	110	89	2024	MC	1	2024-07-16	2024-07-26	FEDERICO C	7841	259de71ee22389af24b3b375a021d679	2026-01-16 21:31:47.938+00	2026-01-16 21:31:47.938+00	\N	\N
3206a1f3-c8a7-49be-a220-b776552907e7	113	45	2024	MC	1	2024-03-21	2024-04-16	HOYO MARU 37	7149	070566ec9d0428d44ab991dfeacccd23	2026-01-16 21:31:47.957+00	2026-01-16 21:31:47.957+00	\N	\N
685a8226-1159-46ed-9ad7-2f7019f70bbc	114	45	2024	MC	1	2024-04-18	2024-05-16	HOYO MARU 37	7149	8002b3a70ed97283fc8f9aca508e102b	2026-01-16 21:31:47.978+00	2026-01-16 21:31:47.978+00	\N	\N
66bc0ab0-87f7-427d-ad32-6ec809fe4311	115	165	2023	MC	1	2023-12-29	2024-01-29	LU QING YUAN YU 288            	7611	29ac355186632405ebfe41fb6a349792	2026-01-16 21:31:47.999+00	2026-01-16 21:31:47.999+00	\N	\N
d6fac8d7-a9c4-4e4c-9e9b-dea8f5736a0e	116	29	2024	MC	1	2024-02-19	2024-02-23	ARGENTINO	7611	13efe8cec4b826e6363d663777bec520	2026-01-16 21:31:48.021+00	2026-01-16 21:31:48.021+00	\N	\N
e6e7bf79-558e-4e98-85d7-452f7d5d5ee7	117	41	2024	MC	1	2024-03-06	2024-04-16	ARBUMASA XXVII	7611	e3f99241045c58aa87c73631b95504a2	2026-01-16 21:31:48.04+00	2026-01-16 21:31:48.04+00	\N	\N
baf70e54-65bf-480d-a6c0-37e323b671d5	118	86	2024	MC	1	2024-05-23	2024-06-05	MYRDOMA F	7611	e248c82b75d029c1b9d622602a958a74	2026-01-16 21:31:48.06+00	2026-01-16 21:31:48.06+00	\N	\N
d6eaf798-74ae-4130-bfe4-39753ec0e229	119	86	2024	MC	1	2024-06-06	2024-06-18	MYRDOMA F	7611	b4f15db615ae697e743ca8fb083e6155	2026-01-16 21:31:48.079+00	2026-01-16 21:31:48.079+00	\N	\N
53d1bd96-9a17-4035-987e-eb93f43071e4	120	86	2024	MC	1	2024-06-19	2024-07-03	MYRDOMA F	7611	d4cf5dfd9269e984ce7b2bd1e30f2b61	2026-01-16 21:31:48.097+00	2026-01-16 21:31:48.097+00	\N	\N
19d0a6f7-1795-4308-8f8d-dacd408264a0	121	86	2024	MC	1	2024-07-05	2024-07-15	MYRDOMA F	7611	be966295d79cdc0cd0ef249e05aed241	2026-01-16 21:31:48.116+00	2026-01-16 21:31:48.116+00	\N	\N
43c1885a-2eb5-45e6-bc04-3d738a3fef51	122	86	2024	MC	1	2024-07-16	2024-07-26	MYRDOMA F	7611	f3317dc79ce7eb4117887d94e95bcde8	2026-01-16 21:31:48.137+00	2026-01-16 21:31:48.137+00	\N	\N
f0e64e85-901a-4142-974c-6c92c4e890aa	123	86	2024	MC	1	2024-07-27	2024-08-06	MYRDOMA F	7611	286b8351904e35e845db0cc123d94f49	2026-01-16 21:31:48.157+00	2026-01-16 21:31:48.157+00	\N	\N
fa8bc930-acc1-4a6c-939c-82453f3ddc1a	124	157	2023	MC	1	2023-11-30	2024-02-06	ECHIZEN MARU	7726	20813f831d95e7abe3624ea7f67e3f91	2026-01-16 21:31:48.177+00	2026-01-16 21:31:48.177+00	\N	\N
32ed5d3b-1d09-4bbd-b21c-20f80c2d8788	125	44	2024	MC	1	2024-03-14	2024-04-16	MISS TIDE	7726	aa1cd1b09ec615d6a773aee899d96d4c	2026-01-16 21:31:48.196+00	2026-01-16 21:31:48.196+00	\N	\N
3df7d010-276c-4ac8-9725-16291cfd8a94	126	63	2024	MC	1	2024-04-20	2024-05-22	MISS TIDE	7726	1cd24280b5faba32a9e6114bb10d837a	2026-01-16 21:31:48.214+00	2026-01-16 21:31:48.214+00	\N	\N
488f0214-641a-4141-82f0-c49602cadcd6	127	98	2024	MC	1	2024-06-18	2024-06-29	PONTE CORUXO	7726	3f8dd5ebf312182a56f6d93fd6b848fe	2026-01-16 21:31:48.232+00	2026-01-16 21:31:48.232+00	\N	\N
495cc412-9ccc-4ed4-9fe1-c01982bd1291	128	98	2024	MC	1	2024-07-03	2024-07-15	PONTE CORUXO	7726	297de30682eccb43fde1bd06bc741280	2026-01-16 21:31:48.249+00	2026-01-16 21:31:48.249+00	\N	\N
83c32e2c-6d36-4a48-94f4-c4855b2fddaa	129	98	2024	MC	1	2024-07-19	2024-07-28	PONTE CORUXO	7726	4f5879d6b41787d76af21b7fe48d4b87	2026-01-16 21:31:48.267+00	2026-01-16 21:31:48.267+00	\N	\N
7a30b130-0f1f-45b5-8922-547f0fe152b8	130	129	2024	MC	1	2024-08-14	2024-09-03	ERIN BRUCE II	7726	2dd0d1a1532cc2bfd77458ead29762b9	2026-01-16 21:31:48.286+00	2026-01-16 21:31:48.286+00	\N	\N
266a0a17-8aa7-42a1-acb5-7f16b83e4ff5	131	139	2024	MC	1	2024-09-05	2024-10-10	ERIN BRUCE II	7726	84e1ed9ed7a71621d4634239ded709c9	2026-01-16 21:31:48.305+00	2026-01-16 21:31:48.305+00	\N	\N
d182bd57-6709-475c-93df-e0ccbb3f3292	133	163	2023	MC	1	2023-12-30	2024-02-03	TALISMAN	7828	d84582167f1d1feaf452e339106e4971	2026-01-16 21:31:48.323+00	2026-01-16 21:31:48.323+00	\N	\N
e429c437-c940-458d-9384-e82ac3ea5ce6	134	32	2024	MC	1	2024-02-23	2024-03-21	ATLANTIC EXPRESS	7828	e36a01e4ecbd5cb2c3ed6593fbb5afac	2026-01-16 21:31:48.34+00	2026-01-16 21:31:48.34+00	\N	\N
166d0bbb-8fbb-4f6e-b203-a9dc5e6e97db	135	67	2024	MC	1	2024-04-29	2024-05-12	ARGENTINO	7828	9b6678c50ab69192aedc0a1bf565a764	2026-01-16 21:31:48.358+00	2026-01-16 21:31:48.358+00	\N	\N
9c590a1a-41e1-4d29-8efa-9e3c658f8248	136	67	2024	MC	1	2024-05-13	2024-05-17	ARGENTINO	7828	a7c73eeb60c5c338c04a50c0a769fc07	2026-01-16 21:31:48.377+00	2026-01-16 21:31:48.377+00	\N	\N
cd7c1735-cf5d-4693-8ee9-338bf77dddd5	137	118	2024	MC	1	2024-07-28	2024-08-07	JOSE AMERICO	7828	696bcf1169691b99c26cf7e1d138572d	2026-01-16 21:31:48.396+00	2026-01-16 21:31:48.396+00	\N	\N
5226fed5-ca28-41f2-b6a9-798ee065d1a7	138	118	2024	MC	1	2024-08-09	2024-09-04	JOSE AMERICO	7828	783e131fe95228b71c3f081eadf9238a	2026-01-16 21:31:48.416+00	2026-01-16 21:31:48.416+00	\N	\N
b22779a2-3dee-4383-827d-2b0b62bc5c5f	140	15	2024	MC	1	2024-01-10	2024-02-18	ATLANTIC SURF III	9465	087c04ff87562dc76e69df454948ffa8	2026-01-16 21:31:48.434+00	2026-01-16 21:31:48.434+00	\N	\N
629e817e-90a3-4ec8-81ac-5d05bcb2f861	141	36	2024	MC	1	2024-02-22	2024-04-04	ATLANTIC SURF III	9465	0e5674f820e23aaf063d4ece23cd3177	2026-01-16 21:31:48.451+00	2026-01-16 21:31:48.451+00	\N	\N
78c556a6-85f3-4048-8ea4-a36e0730734b	142	57	2024	MC	1	2024-04-08	2024-05-30	ATLANTIC SURF III	9465	528e5c0d9a9b597ed21085ff732fb622	2026-01-16 21:31:48.469+00	2026-01-16 21:31:48.469+00	\N	\N
6ec33171-d1d4-4caa-b08c-442e8f9888a4	143	115	2024	MC	1	2024-07-26	2024-09-11	ATLANTIC SURF III	9465	756c5096d2a0264738e96d81e4ff894d	2026-01-16 21:31:48.487+00	2026-01-16 21:31:48.487+00	\N	\N
715e1207-38a7-4276-8362-6fc99541dd85	144	153	2024	MC	1	2024-10-04	2024-10-20	MISS TIDE	9465	2284e7b8e360a7df2597aa8aefdb5966	2026-01-16 21:31:48.506+00	2026-01-16 21:31:48.506+00	\N	\N
beffa89f-7b57-4ab2-bb0d-6d47b52801d8	145	159	2024	MC	1	2024-10-23	2024-11-08	MISS TIDE	9465	7d43fd15b78ed5adfb0bfe500955dd63	2026-01-16 21:31:48.523+00	2026-01-16 21:31:48.523+00	\N	\N
2ab95c9b-1560-49b7-8253-87f9f055c3d6	146	4	2024	MC	1	2024-01-08	2024-02-01	MINTA	7612	b67c1de91cddf116d9b2f52c7270c9c0	2026-01-16 21:31:48.541+00	2026-01-16 21:31:48.541+00	\N	\N
c73420b1-82e7-418e-8a73-11a6868bfcf2	147	4	2024	MC	1	2024-02-02	2024-02-20	MINTA	7612	7fc010c88e1164f5f014fa7942ae350a	2026-01-16 21:31:48.561+00	2026-01-16 21:31:48.561+00	\N	\N
6991ceea-b294-4ba1-8d90-ce5ffc3fb9d2	148	100	2024	MC	1	2024-07-06	2024-07-14	VIRGEN MARIA	7612	d392b9efdd7ad26bb6f09d6bde8ff56c	2026-01-16 21:31:48.578+00	2026-01-16 21:31:48.578+00	\N	\N
965f74cf-f155-4224-89d1-8342ac659be6	149	100	2024	MC	1	2024-07-16	2024-07-25	VIRGEN MARIA	7612	76973c7a8ff16723040f87add0ad537e	2026-01-16 21:31:48.595+00	2026-01-16 21:31:48.595+00	\N	\N
3958f260-2ecd-41d2-b75f-107f0a52d0eb	150	100	2024	MC	1	2024-07-27	2024-08-04	VIRGEN MARIA	7612	e723fcc729ba6aa467291d438f78c709	2026-01-16 21:31:48.613+00	2026-01-16 21:31:48.613+00	\N	\N
5c7d0a85-1e27-459d-be22-1e32e953bb3b	151	100	2024	MC	1	2024-08-07	2024-08-14	VIRGEN MARIA	7612	041465f2dc7f232bc3a5d0a35700d3f2	2026-01-16 21:31:48.631+00	2026-01-16 21:31:48.631+00	\N	\N
1b5021bb-8d7c-42df-bb25-044fc290d330	152	2	2024	MC	1	2024-01-06	2024-01-08	ATLANTIC SURF III	7836	f30de9d509d6ac4001ad8061a780ab01	2026-01-16 21:31:48.648+00	2026-01-16 21:31:48.648+00	\N	\N
b617c2c4-59d7-43f4-a976-661b6c0fc744	153	42	2024	MC	1	2024-03-14	2024-04-22	NATALIA	7836	8464123ce9d992187cd16d9aa6c00cfb	2026-01-16 21:31:48.665+00	2026-01-16 21:31:48.665+00	\N	\N
f06fdb07-36ee-479c-99c8-1fc5908b4978	154	154	2023	MC	1	2023-12-07	2024-01-14	CHIYO MARU NO.3	7798	1aba8959ed0570b4b3bb7ce4da8a0e9c	2026-01-16 21:31:48.682+00	2026-01-16 21:31:48.682+00	\N	\N
a97e26d0-5d1f-4f70-8d71-acae596679dc	156	37	2024	MC	1	2024-02-29	2024-04-09	VALERIA DEL ATLANTICO	7798	dfdd8afe71654c8fb9c9ed617623112a	2026-01-16 21:31:48.7+00	2026-01-16 21:31:48.7+00	\N	\N
7fa64897-72a2-472e-92bb-81506c2ce01b	157	82	2024	MC	1	2024-05-22	2024-06-11	SAN JUAN B	7798	fdfadd6cc49d4819861b18606ecf1d54	2026-01-16 21:31:48.719+00	2026-01-16 21:31:48.719+00	\N	\N
8991e3e7-c8a0-492f-bd71-b6d7263e054e	158	82	2024	MC	1	2024-06-12	2024-06-23	SAN JUAN B	7798	5b38579716f6aa043b2202510c9650bc	2026-01-16 21:31:48.737+00	2026-01-16 21:31:48.737+00	\N	\N
f78608d1-4528-4b18-9a48-33445ab92a54	159	82	2024	MC	1	2024-06-26	2024-07-13	SAN JUAN B	7798	a171a7ef0818413627f23766c026ff05	2026-01-16 21:31:48.755+00	2026-01-16 21:31:48.755+00	\N	\N
ae37cbf0-8e80-4b44-81a9-7f5b1c03c3c0	162	10	2024	MC	1	2024-01-09	2024-02-11	NAVEGANTES III	7728	7d5c7c56d6594a7d81f4556e1f2483e0	2026-01-16 21:31:48.772+00	2026-01-16 21:31:48.772+00	\N	\N
b2704aa2-0699-4197-8982-ed9a3c228ee8	163	30	2024	MC	1	2024-02-14	2024-03-17	NAVEGANTES III	7728	fb6ec00a8705696ab89fd9d7363c8aaa	2026-01-16 21:31:48.789+00	2026-01-16 21:31:48.789+00	\N	\N
300251e0-1210-42a2-847d-23f809400af0	164	18	2024	MC	1	2024-02-03	2024-03-06	TANGO II	9442	9bb399002ee7a97b3dcdd8bfe0a9573c	2026-01-16 21:31:48.807+00	2026-01-16 21:31:48.807+00	\N	\N
87d2d364-a0e6-4673-a371-6982b8694760	165	111	2024	MC	1	2024-07-13	2024-08-20	API V	9442	8f4673f29a24be50567ed1473d3b6560	2026-01-16 21:31:48.824+00	2026-01-16 21:31:48.824+00	\N	\N
5410447b-b368-4d00-a7ca-880180be0c3a	166	8	2024	MC	1	2024-01-09	2024-02-05	NATALIA	7842	49e789d0bcd76c548f4be8c62833ce79	2026-01-16 21:31:48.841+00	2026-01-16 21:31:48.841+00	\N	\N
f53c9ca3-8490-46b7-ba96-7ee7ff26af69	167	68	2024	MC	1	2024-04-30	2024-05-16	NANINA	7842	e0ca8a23239920794bd6b0405ae100a8	2026-01-16 21:31:48.858+00	2026-01-16 21:31:48.858+00	\N	\N
b303e531-f355-4e0d-9676-9df56abad80b	168	92	2024	MC	1	2024-05-29	2024-06-29	GEMINIS	7842	8d88ff4a8e4f99873582f8b0f5d8ddf0	2026-01-16 21:31:48.877+00	2026-01-16 21:31:48.877+00	\N	\N
20d651dc-8fb9-4f21-83a6-266d6c0ad4ce	169	148	2024	MC	1	2024-10-27	2024-10-29	TALISMAN	7842	769411a2955ef1e90f0b5b901f125bf0	2026-01-16 21:31:48.895+00	2026-01-16 21:31:48.895+00	\N	\N
71cd9a9f-cee6-4b95-8956-5de8af62a273	170	148	2024	MC	1	2024-10-31	2024-11-02	TALISMAN	7842	51e643ee0735ea2f1e46158df8156449	2026-01-16 21:31:48.914+00	2026-01-16 21:31:48.914+00	\N	\N
f492198a-e6ff-4a9f-bd4d-3feb6bc2b46a	171	148	2024	MC	1	2024-11-07	2024-11-18	TALISMAN	7842	671ed99fe7b81a60a17d80748c9f5ed9	2026-01-16 21:31:48.931+00	2026-01-16 21:31:48.931+00	\N	\N
434f5f95-2dcb-4e26-84a8-b9d57db072b3	172	162	2023	MC	1	2023-12-30	2024-02-03	DUKAT	7831	b351df957a83590ac2813d046b5e97f5	2026-01-16 21:31:48.948+00	2026-01-16 21:31:48.948+00	\N	\N
50ec605c-eb96-486c-9ad0-ffa4ba53ed20	175	74	2024	MC	1	2024-05-10	2024-06-14	NAVEGANTES	7729	99142d5625fdd3f87b8de31208ebaab5	2026-01-16 21:31:48.966+00	2026-01-16 21:31:48.966+00	\N	\N
969b3bd0-af39-4027-abfe-fa8b5c924c38	176	108	2024	MC	1	2024-07-10	2024-08-09	CERES	7729	69ea8ffe5a21716e5cbe74af8ad9f563	2026-01-16 21:31:48.984+00	2026-01-16 21:31:48.984+00	\N	\N
4fb3c9f0-d1f7-4835-a4af-3ab6d9628cb2	178	76	2024	MC	1	2024-05-11	2024-05-20	JOSE MARCELO	7832	009d0f72fd5374da983701423dbebe70	2026-01-16 21:31:49.003+00	2026-01-16 21:31:49.003+00	\N	\N
410d6e52-9eea-459d-8a59-9fc8d14c4e76	179	76	2024	MC	1	2024-05-22	2024-06-01	JOSE MARCELO	7832	d66bf23599815e5b28fa75df679d4265	2026-01-16 21:31:49.023+00	2026-01-16 21:31:49.023+00	\N	\N
c0331c3a-1cdb-4d88-a071-72ee356cc2cf	180	126	2024	MC	1	2024-08-07	2024-08-15	UR ERTZA	7832	351845d8dd975ed21f3959da60f6b34c	2026-01-16 21:31:49.041+00	2026-01-16 21:31:49.041+00	\N	\N
d6b2ffd8-dfe9-4bda-b3aa-79e9ec053472	181	126	2024	MC	1	2024-08-17	2024-08-25	UR ERTZA	7832	2db38b3c55c93979cbfed0743c03ad45	2026-01-16 21:31:49.06+00	2026-01-16 21:31:49.06+00	\N	\N
da4487a4-322a-4b20-9c4d-4e58997f64b3	182	126	2024	MC	1	2024-08-30	2024-09-04	UR ERTZA	7832	782ba089d06d372d267d240e4d264d8f	2026-01-16 21:31:49.077+00	2026-01-16 21:31:49.077+00	\N	\N
f0e9ba18-11aa-40fc-b754-5e67126a72dc	183	150	2024	MC	1	2024-09-30	2024-10-29	VALERIA DEL ATLANTICO	7832	07d47930bd2d4b75e863a45f6d28017c	2026-01-16 21:31:49.094+00	2026-01-16 21:31:49.094+00	\N	\N
2b1b184d-7486-431f-8513-07e889771ba8	184	16	2024	MC	1	2024-01-17	2024-01-25	FEIXA	7730	4efa94346d2cb3a1f698cb440ae1e35c	2026-01-16 21:31:49.111+00	2026-01-16 21:31:49.111+00	\N	\N
cfd1da5b-df73-45f0-9e3e-a16b906ba5be	185	16	2024	MC	1	2024-01-28	2024-02-04	FEIXA	7730	8ce937c27c865613544b22d8f52b88f6	2026-01-16 21:31:49.129+00	2026-01-16 21:31:49.129+00	\N	\N
46bfb0e4-80d8-4f1f-800d-e238f26557fa	186	16	2024	MC	1	2024-02-08	2024-02-15	FEIXA	7730	09d309bca07fc247506afa0ac440568b	2026-01-16 21:31:49.146+00	2026-01-16 21:31:49.146+00	\N	\N
ec4d4c9b-a008-45ed-b4aa-e32bab5e38f4	187	16	2024	MC	1	2024-03-05	2024-03-12	FEIXA	7730	0be50a759f3163aeb88f0841c126a293	2026-01-16 21:31:49.163+00	2026-01-16 21:31:49.163+00	\N	\N
f872465f-3c5c-48d4-ace0-c2ac53210f99	188	64	2024	MC	1	2024-04-24	2024-05-04	EL MARISCO II	7730	08e191ffd4a965191c42636145b048a2	2026-01-16 21:31:49.179+00	2026-01-16 21:31:49.179+00	\N	\N
48f9d3c7-e24d-482a-afbc-3c44868286eb	189	64	2024	MC	1	2024-05-10	2024-05-21	EL MARISCO II	7730	1b6c37de684b10b62689b3b2fd9fd574	2026-01-16 21:31:49.196+00	2026-01-16 21:31:49.196+00	\N	\N
f4a34e06-4557-46d4-a043-13e55bfb7e9b	190	64	2024	MC	1	2024-05-23	2024-06-01	EL MARISCO II	7730	1e8279cc31f7db82a0e69246d8a35cf5	2026-01-16 21:31:49.212+00	2026-01-16 21:31:49.212+00	\N	\N
1bf7aa9f-33fa-48f8-9225-6eed04cc13da	191	142	2024	MC	1	2024-09-06	2024-09-13	SIRIUS II	7730	19836f8354152af8b3aca1b802a6e86e	2026-01-16 21:31:49.229+00	2026-01-16 21:31:49.229+00	\N	\N
6f1dfd41-6720-4c14-b2c8-85ccedf5e563	192	142	2024	MC	1	2024-09-17	2024-09-27	SIRIUS II	7730	28a21f2de061fca14b3def506079f3c0	2026-01-16 21:31:49.247+00	2026-01-16 21:31:49.247+00	\N	\N
4d81cca4-792c-4a1e-b144-f2266f969bc0	193	142	2024	MC	1	2024-10-02	2024-10-07	SIRIUS II	7730	0dbd8ec1c3b907e9eacc692293015aef	2026-01-16 21:31:49.264+00	2026-01-16 21:31:49.264+00	\N	\N
bd9d0b60-5f28-4771-8b9c-001658c8c5d7	194	167	2024	MC	1	2024-12-03	2024-12-11	VIRGEN MARIA	7730	352b7d5abd9f343116bf4bb7729fbe7d	2026-01-16 21:31:49.281+00	2026-01-16 21:31:49.281+00	\N	\N
f36dac6e-28cb-4449-9350-8def9cc4a395	195	17	2024	MC	1	2024-02-06	2024-02-23	TALISMAN	7616	2c1707d96c05f2a4ff4a88af79116db7	2026-01-16 21:31:49.298+00	2026-01-16 21:31:49.298+00	\N	\N
329e1546-ca40-46bc-ad62-01185cba98f0	196	59	2024	MC	1	2024-04-10	2024-04-13	VALERIA DEL ATLANTICO	7616	653b2af04e8aa2db8616c61293ffc078	2026-01-16 21:31:49.316+00	2026-01-16 21:31:49.316+00	\N	\N
e020e1c9-eb49-4e64-8d21-b8622573d3e9	197	59	2024	MC	1	2024-04-21	2024-05-24	VALERIA DEL ATLANTICO	7616	63e2fc490464bc5af527dcb24bf35d4c	2026-01-16 21:31:49.333+00	2026-01-16 21:31:49.333+00	\N	\N
37fcd82a-b27f-4cd8-a871-8f440b4d624a	198	102	2024	MC	1	2024-06-26	2024-07-12	JOSE AMERICO	7616	3e2bf0e382da1799b9c139570bd5784a	2026-01-16 21:31:49.35+00	2026-01-16 21:31:49.35+00	\N	\N
bf6b1343-49ed-4254-b8c6-11e523a4e8f2	199	102	2024	MC	1	2024-07-14	2024-07-27	JOSE AMERICO	7616	913ca253fa24827272592390a7eaac83	2026-01-16 21:31:49.368+00	2026-01-16 21:31:49.368+00	\N	\N
46fafa1a-8963-4660-b653-74deeb20b4b6	203	5	2024	MC	1	2024-01-06	2024-01-31	DON LUIS I	7829	08c3e00d1a9e452d021525ad794ca2dd	2026-01-16 21:31:49.384+00	2026-01-16 21:31:49.384+00	\N	\N
d0af68f9-2e17-46ab-8ba8-a2984c07c9b2	204	117	2024	MC	1	2024-07-28	2024-08-04	GRACIELA I	7829	dd70eb0dcca4b1fab6ad1f819492a369	2026-01-16 21:31:49.407+00	2026-01-16 21:31:49.407+00	\N	\N
9e86f77f-4765-498e-a275-697a18202dee	205	117	2024	MC	1	2024-08-05	2024-08-11	GRACIELA I	7829	74c3a10c9065a7c7ac88d7e4a8d3e38c	2026-01-16 21:31:49.423+00	2026-01-16 21:31:49.423+00	\N	\N
755b7c73-53d4-43ee-aec6-65f0b054ad1c	206	117	2024	MC	1	2024-08-11	2024-08-19	GRACIELA I	7829	28a961e8334541f6f0b3cd4baf395f01	2026-01-16 21:31:49.441+00	2026-01-16 21:31:49.441+00	\N	\N
b8d77abb-b197-4448-bacf-5c35fc73e65c	207	117	2024	MC	1	2024-08-21	2024-08-27	GRACIELA I	7829	d7e76c059a4081522da9c4fc4f3eb0c5	2026-01-16 21:31:49.458+00	2026-01-16 21:31:49.458+00	\N	\N
4ec8d310-016e-4a53-ac37-25e69e0c03e4	208	117	2024	MC	1	2024-08-27	2024-09-02	GRACIELA I	7829	e3f27de0cbfc4cfd7c150fe4459727ca	2026-01-16 21:31:49.475+00	2026-01-16 21:31:49.475+00	\N	\N
3e9194d7-15f0-48b4-8f9d-a9d957338bdb	209	140	2024	MC	1	2024-09-06	2024-09-13	GRACIELA I	7829	9a23d2f56b970a39c154862703dbb884	2026-01-16 21:31:49.493+00	2026-01-16 21:31:49.493+00	\N	\N
43c0046b-747b-4c9f-9fb0-90118cd64024	210	140	2024	MC	1	2024-09-15	2024-09-22	GRACIELA I	7829	f7a77dff67de46c8af684a6619b3e40c	2026-01-16 21:31:49.509+00	2026-01-16 21:31:49.509+00	\N	\N
d3c1d2e0-71d9-44d7-b990-28a24f8a61aa	211	140	2024	MC	1	2024-09-25	2024-10-04	GRACIELA I	7829	2d1ff737f4d3f6831e290f8548fbf4f1	2026-01-16 21:31:49.525+00	2026-01-16 21:31:49.525+00	\N	\N
78fe1bc1-40a4-4b55-935b-d2e937c8fb85	212	159	2023	MC	1	2023-12-30	2024-01-30	TANGO II	7621	fcb3b3a2d68ef0604b19c3754255519b	2026-01-16 21:31:49.542+00	2026-01-16 21:31:49.542+00	\N	\N
5d00aa88-83b8-4f4d-b83e-8d862bd5ae2e	213	31	2024	MC	1	2024-02-26	2024-03-12	CHIYO MARU NO.3	7621	dd20bb7bb104a6cf0b6ce5b86941446d	2026-01-16 21:31:49.558+00	2026-01-16 21:31:49.558+00	\N	\N
41103833-6f3e-4315-94bd-22f36b1dcd32	214	65	2024	MC	1	2024-04-25	2024-05-24	NATALIA	7621	0a9e043c636fc910f4ab6c6b8a43d8d1	2026-01-16 21:31:49.578+00	2026-01-16 21:31:49.578+00	\N	\N
8e6c0abe-4d73-4cd1-8109-000d13c09a91	215	132	2024	MC	1	2024-08-24	2024-09-27	MISS TIDE	7621	4b30684885ada8a79beb21fdbc0738e4	2026-01-16 21:31:49.598+00	2026-01-16 21:31:49.598+00	\N	\N
430dc136-4036-4750-8ffa-4e2a5e7b7d11	216	165	2024	MC	1	2024-11-15	2024-12-16	MISS TIDE	7621	9b3fbdc23d93662bdfc48c08f3d5c33a	2026-01-16 21:31:49.616+00	2026-01-16 21:31:49.616+00	\N	\N
5805cbd0-1a32-45e4-b928-2df66d0ed6ba	217	6	2024	MC	1	2024-01-06	2024-01-11	ATLANTIC EXPRESS	7733	3c24ef14213d71f290bfd941a25b3182	2026-01-16 21:31:49.634+00	2026-01-16 21:31:49.634+00	\N	\N
39ba03ed-4398-4734-a493-b9d3adcc9b9a	218	6	2024	MC	1	2024-01-12	2024-01-23	ATLANTIC EXPRESS	7733	f84f81a8b1b275c0f9558b8fb3bba78f	2026-01-16 21:31:49.651+00	2026-01-16 21:31:49.651+00	\N	\N
728b9a3c-78ab-4913-b57c-08111eba9164	219	6	2024	MC	1	2024-01-26	2024-02-20	ATLANTIC EXPRESS	7733	03f934ac4cb6a6d3c4bcfcd04d9151a3	2026-01-16 21:31:49.669+00	2026-01-16 21:31:49.669+00	\N	\N
2b111253-9077-4aab-8e4d-2ede38755acf	220	77	2024	MC	1	2024-05-15	2024-06-23	CAPESANTE	9461	c2365735aba15b7f0d6cd511574331cc	2026-01-16 21:31:49.687+00	2026-01-16 21:31:49.687+00	\N	\N
b14d09f7-2dee-4929-a329-b7ca88b0e222	221	168	2024	MC	1	2024-12-06	2025-02-04	ECHIZEN MARU	9461	876dfc7e535279642f3c285f2e423acf	2026-01-16 21:31:49.705+00	2026-01-16 21:31:49.705+00	\N	\N
50cee316-db27-4e78-9302-eeb9926bd834	222	12	2024	MC	1	2024-01-13	2024-02-25	COALSA SEGUNDO	9467	75c0b0b4b755a42bec36441d0b8f27f7	2026-01-16 21:31:49.722+00	2026-01-16 21:31:49.722+00	\N	\N
cee75127-069f-4c4c-b218-c5e967c07aba	223	52	2024	MC	1	2024-03-27	2024-04-13	BOGAVANTE SEGUNDO	9467	2527357058d16e1a9628efadb7742f25	2026-01-16 21:31:49.74+00	2026-01-16 21:31:49.74+00	\N	\N
7dce86ad-c555-496b-8590-f43742918ae0	224	72	2024	MC	1	2024-05-11	2024-05-22	GRACIELA I	9467	6d6d65dd561b0c7f2bf3233c8bb86877	2026-01-16 21:31:49.758+00	2026-01-16 21:31:49.758+00	\N	\N
ed759d6d-278e-4a74-862a-9a7f2f1ee74b	225	72	2024	MC	1	2024-05-25	2024-06-03	GRACIELA I	9467	5a3b93652ba0a43ddd74b3dd953e3366	2026-01-16 21:31:49.776+00	2026-01-16 21:31:49.776+00	\N	\N
32aaa098-56a7-4484-a709-870af69b7e5d	233	128	2024	MC	1	2024-08-15	2024-09-14	GEMINIS	9467	2a27bf378d85114a47dc80c9a26dc368	2026-01-16 21:31:49.795+00	2026-01-16 21:31:49.795+00	\N	\N
2ff8744c-efe4-42eb-9e65-b858fbc37abe	237	25	2024	MC	1	2024-02-09	2024-03-18	ECHIZEN MARU	7627	2af4b511e02eb39f805dd67eb83f06b8	2026-01-16 21:31:49.813+00	2026-01-16 21:31:49.813+00	\N	\N
89e40d13-303c-469e-8c27-36a1bca2063d	238	54	2024	MC	1	2024-03-27	2024-04-27	XEITOSIÑO	7627	f68f493b1037e2aea5fde87fc88ebce1	2026-01-16 21:31:49.83+00	2026-01-16 21:31:49.83+00	\N	\N
a5ae00e2-20b1-4321-b26e-b4b6db046890	239	85	2024	MC	1	2024-05-24	2024-05-29	SFIDA	7627	67ea4b27e1a66ca67aa163a9cb537b59	2026-01-16 21:31:49.848+00	2026-01-16 21:31:49.848+00	\N	\N
f4633630-731e-41bb-a1ba-533abff7fc2d	241	96	2024	MC	1	2024-06-11	2024-06-21	MARIA ALEJANDRA 1º	7627	93c9d0835c8c679f6c6ca8ab5bc7a82b	2026-01-16 21:31:49.866+00	2026-01-16 21:31:49.866+00	\N	\N
d03e2888-e757-4634-b59b-f9b47e1e11e9	242	96	2024	MC	1	2024-06-22	2024-07-03	MARIA ALEJANDRA 1º	7627	e32293eed65ff2e3129fb0852df3d6e9	2026-01-16 21:31:49.884+00	2026-01-16 21:31:49.884+00	\N	\N
6a455175-a627-4030-986a-dce3aa679f88	243	96	2024	MC	1	2024-07-05	2024-07-15	MARIA ALEJANDRA 1º	7627	3961e05fbf96baca1c86266d9745825b	2026-01-16 21:31:49.901+00	2026-01-16 21:31:49.901+00	\N	\N
12bcd9ab-798e-4496-ab04-0e9b4fa6696d	244	113	2024	MC	1	2024-07-16	2024-07-28	MARIA ALEJANDRA 1º	7627	1d5c760505a7aff1267bedf1927347cc	2026-01-16 21:31:49.919+00	2026-01-16 21:31:49.919+00	\N	\N
f30bf2f6-5b81-4161-a998-9d6bd480b325	245	113	2024	MC	1	2024-07-29	2024-08-09	MARIA ALEJANDRA 1º	7627	473166bb04005cb177275bcedd5a6ba0	2026-01-16 21:31:49.938+00	2026-01-16 21:31:49.938+00	\N	\N
52432c02-3e64-4853-9f25-bc471827bce0	246	113	2024	MC	1	2024-08-10	2024-08-27	MARIA ALEJANDRA 1º	7627	07d3f7d6e7c4fba45f4efefda52ffa08	2026-01-16 21:31:49.955+00	2026-01-16 21:31:49.955+00	\N	\N
a778d4c3-7805-44cf-a331-97a364511c86	247	113	2024	MC	1	2024-08-28	2024-09-21	MARIA ALEJANDRA 1º	7627	90ce1750d4c6e735a6dd7f1f7fa68215	2026-01-16 21:31:49.974+00	2026-01-16 21:31:49.974+00	\N	\N
1106f539-00aa-4fae-861f-215a172bb655	248	13	2024	MC	1	2024-01-22	2024-02-03	JOSE MARCELO	7767	bd7118fb803d7d39c02b4047c5053645	2026-01-16 21:31:49.993+00	2026-01-16 21:31:49.993+00	\N	\N
3a7f1663-1ba8-4fc2-82c3-165723a17207	249	13	2024	MC	1	2024-02-05	2024-02-14	JOSE MARCELO	7767	54120d3cafdfaab01534f7501a7ce11a	2026-01-16 21:31:50.012+00	2026-01-16 21:31:50.012+00	\N	\N
dd4619d9-b160-4809-8db4-2592f39bc9a4	250	13	2024	MC	1	2024-02-16	2024-02-24	JOSE MARCELO	7767	1cbeacd3aa5c13d2d9c5cedbcd25b1d6	2026-01-16 21:31:50.029+00	2026-01-16 21:31:50.029+00	\N	\N
e5ba4496-664b-488f-843b-beb7b4ad1e56	251	50	2024	MC	1	2024-03-28	2024-04-09	JOSE MARCELO	7767	49166be5096424989b1b88cd9b6cbeb2	2026-01-16 21:31:50.047+00	2026-01-16 21:31:50.047+00	\N	\N
b721d183-d854-4aa6-b452-955fda905e1e	252	80	2024	MC	1	2024-05-18	2024-05-22	ARGENTINO	7767	d4fb63f37179e3fa111f860bd5786bf9	2026-01-16 21:31:50.066+00	2026-01-16 21:31:50.066+00	\N	\N
14028dfe-4bea-4a8f-9400-4fce738437c4	253	80	2024	MC	1	2024-05-23	2024-05-27	ARGENTINO	7767	79dd3e1901d06ce1b00597dee1736818	2026-01-16 21:31:50.085+00	2026-01-16 21:31:50.085+00	\N	\N
3e0ce9dc-ca83-4074-99f1-59ca5af7c129	254	80	2024	MC	1	2024-05-29	2024-06-07	ARGENTINO	7767	755359d364cf42eee7a97258419d6e0b	2026-01-16 21:31:50.104+00	2026-01-16 21:31:50.104+00	\N	\N
d4e6c2fb-d4be-45d2-bd3a-00817eef323b	255	80	2024	MC	1	2024-06-13	2024-06-19	ARGENTINO	7767	4a9ad648d8e46efc2420b24a661ea4a8	2026-01-16 21:31:50.123+00	2026-01-16 21:31:50.123+00	\N	\N
24083bc2-ebfe-42cc-8aac-91b29eae6be4	256	104	2024	MC	1	2024-06-20	2024-06-24	ARGENTINO	7767	38cd54c12d47cd01310e536306c68e51	2026-01-16 21:31:50.142+00	2026-01-16 21:31:50.142+00	\N	\N
a672bfd7-c2f5-4212-889b-57668cde73d0	257	104	2024	MC	1	2024-06-26	2024-07-01	ARGENTINO	7767	8adb0b5a421ad806baddf8e20a446acb	2026-01-16 21:31:50.16+00	2026-01-16 21:31:50.16+00	\N	\N
d652846d-a8d9-40e7-a2af-93d62375fa49	258	104	2024	MC	1	2024-07-05	2024-07-10	ARGENTINO	7767	a069423eae8d8c28e927e14dbbab4b41	2026-01-16 21:31:50.18+00	2026-01-16 21:31:50.18+00	\N	\N
fb4a7453-2af6-4385-a952-8acc4cce9dbe	259	131	2024	MC	1	2024-08-20	2024-08-28	MARGOT	7767	634e1028016df1d5c028e0abd331bc88	2026-01-16 21:31:50.197+00	2026-01-16 21:31:50.197+00	\N	\N
a4e3e74b-ab15-4144-9861-e1acf51c5c99	260	131	2024	MC	1	2024-08-31	2024-09-05	MARGOT	7767	faa794966ee8da081d9312b3d7f8ae4b	2026-01-16 21:31:50.215+00	2026-01-16 21:31:50.215+00	\N	\N
1ebb439c-081a-4f4b-b540-8db5e65b3a5d	261	131	2024	MC	1	2024-09-07	2024-09-13	MARGOT	7767	f3a270ceb095d0cdd99e7ed74f9c6994	2026-01-16 21:31:50.234+00	2026-01-16 21:31:50.234+00	\N	\N
902f61ac-5f2a-43a2-ad86-291c67ef0542	262	131	2024	MC	1	2024-09-23	2024-10-03	MARGOT	7767	6edbc8368c76b74d0d9cbbbf370e7460	2026-01-16 21:31:50.252+00	2026-01-16 21:31:50.252+00	\N	\N
627fc122-86ae-4e1b-bb5f-8c5ee1a1992e	263	131	2024	MC	1	2024-10-04	2024-10-12	MARGOT	7767	967e165417e39194fc64720905b98add	2026-01-16 21:31:50.27+00	2026-01-16 21:31:50.27+00	\N	\N
593260f8-3b30-41ac-a3f0-70b6295c4edf	264	9	2024	MC	1	2024-01-19	2024-02-14	AURORA	2021	0a9f9ae59b0701f91362d7d85dafb5cc	2026-01-16 21:31:50.286+00	2026-01-16 21:31:50.286+00	\N	\N
3f31a3e4-3d7e-466d-86db-64416f0f744d	265	39	2024	MC	1	2024-03-02	2024-04-04	TALISMAN	2021	f7ee6a5a5547a101a80f7fdfe99f22db	2026-01-16 21:31:50.305+00	2026-01-16 21:31:50.305+00	\N	\N
7768ee4a-93de-4f7a-a9c9-70c9468d72b0	266	71	2024	MC	1	2024-04-29	2024-05-20	ARGENOVA XXV	2021	cff62af1e2d15d87faf7f8dfe4e421b5	2026-01-16 21:31:50.323+00	2026-01-16 21:31:50.323+00	\N	\N
9e699735-d2d2-4f7b-8a81-d6702cf27407	267	83	2024	MC	1	2024-05-23	2024-06-09	ARGENOVA XXIV	2021	3062e0d53d9ae54fedd3614efae646b9	2026-01-16 21:31:50.339+00	2026-01-16 21:31:50.339+00	\N	\N
2650c9c8-7d2c-49bc-b5f3-380d2607475c	268	116	2024	MC	1	2024-07-21	2024-07-27	ARGENOVA II	2021	30eeb977a75fc710ab081caa0a6b91ab	2026-01-16 21:31:50.358+00	2026-01-16 21:31:50.358+00	\N	\N
32f5e641-be23-4db9-9e14-fdeb268fceaa	269	116	2024	MC	1	2024-07-28	2024-08-05	ARGENOVA II	2021	f624c76a861e2279464bbf2c71ecf93e	2026-01-16 21:31:50.376+00	2026-01-16 21:31:50.376+00	\N	\N
871eff46-5e53-47a7-b243-9cf56fe449d3	270	116	2024	MC	1	2024-08-06	2024-08-17	ARGENOVA II	2021	2383ac163232b91a48f77a0eff0fa583	2026-01-16 21:31:50.395+00	2026-01-16 21:31:50.395+00	\N	\N
4cf7fbdd-c99e-4d1b-b2ab-02f96e56cd20	271	116	2024	MC	1	2024-08-18	2024-08-29	ARGENOVA II	2021	4a385de166229fbd58a4bdf2f42925fa	2026-01-16 21:31:50.412+00	2026-01-16 21:31:50.412+00	\N	\N
7e26cd80-5628-483a-a577-9f26a292ef5b	272	3	2024	MC	1	2024-01-05	2024-01-25	ARGENOVA XXI	9480	8b266799eb841c1872e4771170c02545	2026-01-16 21:31:50.43+00	2026-01-16 21:31:50.43+00	\N	\N
f4eff017-4ce4-4b0f-adac-ffb956021d31	273	22	2024	MC	1	2024-01-27	2024-02-24	ARGENOVA XXI	9480	aa40395cebd702e8d3e3b1c694814f1b	2026-01-16 21:31:50.447+00	2026-01-16 21:31:50.447+00	\N	\N
5caa84e0-09ee-49e1-b25c-c587e49356d6	274	34	2024	MC	1	2024-02-27	2024-03-23	ARGENOVA XXI	9480	4310a9e5504223df553065be9a7e3203	2026-01-16 21:31:50.464+00	2026-01-16 21:31:50.464+00	\N	\N
69809dc3-a476-4198-a68e-45994b317dd7	275	75	2024	MC	1	2024-05-06	2024-06-26	TAI AN	9480	727ee5d2eceafdf8b931f675378c0cc1	2026-01-16 21:31:50.481+00	2026-01-16 21:31:50.481+00	\N	\N
c4b1fa45-5f46-4f20-b399-489d6e758125	276	105	2024	MC	1	2024-07-04	2024-09-05	TAI AN	9480	4680ae0bb79b923b25eaa15810475963	2026-01-16 21:31:50.499+00	2026-01-16 21:31:50.499+00	\N	\N
af2b1350-6c95-4b6e-b6e3-0479169e9ed3	277	158	2024	MC	1	2024-10-19	2024-11-25	CAPESANTE	9480	86f01ec980aed9150aa3adcf731d3ae9	2026-01-16 21:31:50.517+00	2026-01-16 21:31:50.517+00	\N	\N
732f8639-79db-4f18-a6fb-4d3369edf51c	278	58	2024	MC	1	2024-04-04	2024-05-15	LUCA MARIO	9459	e94b76100c5b9f6209bcd84e583a144c	2026-01-16 21:31:50.534+00	2026-01-16 21:31:50.534+00	\N	\N
052a979f-c22a-495f-a488-1061b08b9107	279	94	2024	MC	1	2024-06-06	2024-07-05	VENTARRON 1º	9459	5a335933b541ed015de55b4449444133	2026-01-16 21:31:50.552+00	2026-01-16 21:31:50.552+00	\N	\N
8f111b54-9396-4639-b5ab-ec8b5c4b3c90	280	127	2024	MC	1	2024-08-16	2024-10-05	DON PEDRO	9459	ca53bf2d581d6558c9bab06bba74fce2	2026-01-16 21:31:50.568+00	2026-01-16 21:31:50.568+00	\N	\N
f15dfda0-c6c5-41c7-a329-15c26ebb72c8	281	164	2023	MC	1	2023-12-31	2024-01-23	HUYU 962	9452	e93ea78ca19eba4284a2e05cc75f3274	2026-01-16 21:31:50.585+00	2026-01-16 21:31:50.585+00	\N	\N
38c2adac-6bb8-4f6d-808b-1a54507a2a4e	282	38	2024	MC	1	2024-03-06	2024-03-13	VIRGEN MARIA	9452	fa631231d23307f954893c02debf18d3	2026-01-16 21:31:50.603+00	2026-01-16 21:31:50.603+00	\N	\N
57dc1d51-1b17-415e-b00c-39e49c27e3b7	283	38	2024	MC	1	2024-03-15	2024-03-26	VIRGEN MARIA	9452	fba9c23a65fa484372a4293321df40b3	2026-01-16 21:31:50.621+00	2026-01-16 21:31:50.621+00	\N	\N
e0df5740-96c1-4315-b723-ae9225712ea5	284	38	2024	MC	1	2024-03-28	2024-04-08	VIRGEN MARIA	9452	c75c888bbcae9de5a491433049ec2c52	2026-01-16 21:31:50.639+00	2026-01-16 21:31:50.639+00	\N	\N
e9861d50-b767-44f8-83ac-c4405a95c33f	285	38	2024	MC	1	2024-04-11	2024-04-20	VIRGEN MARIA	9452	553d59930beed499173d55ac4f6b6556	2026-01-16 21:31:50.657+00	2026-01-16 21:31:50.657+00	\N	\N
0aacb2fc-9751-42dd-a629-c7ebaff62088	286	93	2024	MC	1	2024-06-07	2024-07-21	ATLANTIC SURF III	9452	f8beb86ecf93e5a201dc29ebb9e4663e	2026-01-16 21:31:50.674+00	2026-01-16 21:31:50.674+00	\N	\N
93595759-a736-4c49-b801-0395653bf00a	287	135	2024	MC	1	2024-09-05	2024-10-15	PONTE DE RANDE	9452	4703afc81ead30931c0ee41151279905	2026-01-16 21:31:50.691+00	2026-01-16 21:31:50.691+00	\N	\N
774d702b-d855-4d10-b5ae-ff8a95ce07be	288	19	2024	MC	1	2024-01-24	2024-02-12	HUYU 962	7624	0078f2119623399ab91fc982e3b66b0d	2026-01-16 21:31:50.709+00	2026-01-16 21:31:50.709+00	\N	\N
1236515b-2eb1-4501-88f8-d3352f9c5132	289	28	2024	MC	1	2024-02-13	2024-03-03	HUYU 962	7624	96a86d2296e8bcb209b5d4fe082005d0	2026-01-16 21:31:50.727+00	2026-01-16 21:31:50.727+00	\N	\N
ee00515a-de90-4de9-9af5-b3b948c64c2c	290	40	2024	MC	1	2024-03-05	2024-04-03	HUYU 962	7624	02097a522fb73ea3d4e72260b55efa58	2026-01-16 21:31:50.745+00	2026-01-16 21:31:50.745+00	\N	\N
c7940f34-a27a-42a5-9a3a-1c52948775dc	291	87	2024	MC	1	2024-05-24	2024-06-01	ALVAREZ ENTRENA V	7624	8bd28aa8134e974ead4607b667aab022	2026-01-16 21:31:50.762+00	2026-01-16 21:31:50.762+00	\N	\N
ff2d6410-a5b5-4a0f-824a-cc1d8e05bf17	292	97	2024	MC	1	2024-06-18	2024-06-27	ARBUMASA XVI	7624	b67a746be9a4337d96b7c62dc631b826	2026-01-16 21:31:50.781+00	2026-01-16 21:31:50.781+00	\N	\N
1ceef973-0047-4fc9-99fa-54ec3fbadd76	293	97	2024	MC	1	2024-06-28	2024-07-12	ARBUMASA XVI	7624	1bf2d7dc380107a0adbd0a20c703a9c6	2026-01-16 21:31:50.798+00	2026-01-16 21:31:50.798+00	\N	\N
ac595ad5-c9d5-4c93-a9ad-99cc0428d4a7	294	97	2024	MC	1	2024-07-13	2024-07-23	ARBUMASA XVI	7624	f6eebc0069cfe11ab2d42b45352b6cf8	2026-01-16 21:31:50.816+00	2026-01-16 21:31:50.816+00	\N	\N
5d8cd5e2-c61a-4586-9b5a-b7a245b12524	295	97	2024	MC	1	2024-07-24	2024-08-03	ARBUMASA XVI	7624	a20ee7be0318dac138e2a18249ca0081	2026-01-16 21:31:50.833+00	2026-01-16 21:31:50.833+00	\N	\N
b01d9391-7ad1-4871-b1b3-98ff09cc545e	296	97	2024	MC	1	2024-08-04	2024-08-16	ARBUMASA XVI	7624	6c1a955fa6456f3564edf3922182381f	2026-01-16 21:31:50.849+00	2026-01-16 21:31:50.849+00	\N	\N
a20bd6a8-9349-4205-99fb-bcef9c6f35f1	297	97	2024	MC	1	2024-08-17	2024-08-30	ARBUMASA XVI	7624	86939b3cdfdd1d25301db8fee8ad49cd	2026-01-16 21:31:50.865+00	2026-01-16 21:31:50.865+00	\N	\N
3d13de82-b742-4cfb-ae45-ae20eae6fce0	298	97	2024	MC	1	2024-08-31	2024-09-19	ARBUMASA XVI	7624	d3d0bda47be0487cc1eb473e9fab7ae4	2026-01-16 21:31:50.882+00	2026-01-16 21:31:50.882+00	\N	\N
15ac86a8-3a27-494b-a1d7-b8c147dae1e1	299	166	2024	MC	1	2024-11-20	2024-12-10	TALISMAN	7624	445ec58f356111769974b9a8985f2017	2026-01-16 21:31:50.898+00	2026-01-16 21:31:50.898+00	\N	\N
46fa57ff-562a-4051-a388-5c452f5749cb	300	1	2024	MC	1	2024-01-06	2024-02-13	CAPESANTE	9451	a014e9debfd769d531ae29da6a70d205	2026-01-16 21:31:50.916+00	2026-01-16 21:31:50.916+00	\N	\N
a38faf56-3a1d-40b0-b492-27070d75d50b	301	148	2023	MC	1	2023-11-24	2024-01-03	CAPESANTE	9471	2d42a44094df92b303afc8fcc72976cf	2026-01-16 21:31:50.933+00	2026-01-16 21:31:50.933+00	\N	\N
d62340a2-5d15-441e-ba92-729e640964fe	302	11	2024	MC	1	2024-01-16	2024-01-27	GRACIELA I	9471	87e42c0e0539e90ce6c6b017f4d1924b	2026-01-16 21:31:50.95+00	2026-01-16 21:31:50.95+00	\N	\N
2dd205e2-3f4e-4e3e-9178-ee0727d3b0dd	303	11	2024	MC	1	2024-01-30	2024-02-08	GRACIELA I	9471	d8469c2813bc1d9cb5c43b85004d3a05	2026-01-16 21:31:50.968+00	2026-01-16 21:31:50.968+00	\N	\N
501a8751-f8aa-4c4e-8b71-6fdeaf585b26	304	11	2024	MC	1	2024-02-10	2024-02-18	GRACIELA I	9471	eb1eaefc3cd6d10354e6838795d5b42d	2026-01-16 21:31:50.984+00	2026-01-16 21:31:50.984+00	\N	\N
93efae9a-fc43-49d0-9f24-9bed2ea7e7db	305	43	2024	MC	1	2024-03-17	2024-03-26	FEIXA	9471	f44aea8cc74213481ebfa69cb78fdf73	2026-01-16 21:31:51+00	2026-01-16 21:31:51+00	\N	\N
70f8fc16-edd6-4e4a-8882-32df88b2b551	306	43	2024	MC	1	2024-03-30	2024-04-08	FEIXA	9471	c6fdcf8db8f8291d6334da4b37d61548	2026-01-16 21:31:51.016+00	2026-01-16 21:31:51.016+00	\N	\N
001d9f26-4940-4f74-a3fb-bc0b88fd89af	307	43	2024	MC	1	2024-04-12	2024-04-21	FEIXA	9471	ed9d26a167781ec361cd00e38c52dfd5	2026-01-16 21:31:51.032+00	2026-01-16 21:31:51.032+00	\N	\N
17a9cbda-41de-47dc-9f55-859375a142d8	308	88	2024	MC	1	2024-05-23	2024-06-05	ARRUFO	9471	7e9f79c4b1b0fbaaa9be26939eba6f88	2026-01-16 21:31:51.052+00	2026-01-16 21:31:51.052+00	\N	\N
4fa96b89-7a16-474a-9b0d-fafd478ede2a	309	88	2024	MC	1	2024-06-07	2024-06-19	ARRUFO	9471	3aa6f350cb5084edab73311357e2e55b	2026-01-16 21:31:51.07+00	2026-01-16 21:31:51.07+00	\N	\N
eecdda7b-9e9b-4557-8d71-a8b2bbb366d2	310	88	2024	MC	1	2024-06-21	2024-07-03	ARRUFO	9471	ae12689172e15c59f5c91dd24b6d5d49	2026-01-16 21:31:51.088+00	2026-01-16 21:31:51.088+00	\N	\N
ffe863ba-b35e-4aa5-9d77-41af11d34578	311	123	2024	MC	1	2024-08-06	2024-08-20	 API XII                        	9471	dcab4c39dd308139f50c39aee344fde9	2026-01-16 21:31:51.106+00	2026-01-16 21:31:51.106+00	\N	\N
91b04a31-4284-4c91-ace8-f502d41dbeab	312	123	2024	MC	1	2024-08-21	2024-09-03	 API XII                        	9471	ddb75d08723433829b3268aba14abf53	2026-01-16 21:31:51.126+00	2026-01-16 21:31:51.126+00	\N	\N
d0bf2f05-6b25-42af-8c02-219a488ba858	313	157	2024	MC	1	2024-10-13	2024-10-20	JOSE LUCIANO	9471	9be1be5fe166aae97e887901a0c9b7fc	2026-01-16 21:31:51.143+00	2026-01-16 21:31:51.143+00	\N	\N
a2a23eea-b9ad-40a5-b51f-43cdd55455f8	314	164	2024	MC	1	2024-11-16	2024-11-24	GRACIELA I	9471	56e599711b1d75c29bd1cd882073dd24	2026-01-16 21:31:51.16+00	2026-01-16 21:31:51.16+00	\N	\N
bac677a7-38b9-458e-812e-f4293b33624e	315	46	2024	MC	1	2024-03-19	2024-03-30	EL MARISCO II	9437	c6d8d558ac509cb1e1178a8fc781c9e0	2026-01-16 21:31:51.178+00	2026-01-16 21:31:51.178+00	\N	\N
6956547f-e3d6-4a20-be4d-c9f06cef901e	316	46	2024	MC	1	2024-04-03	2024-04-09	EL MARISCO II	9437	39d88f7f21282f6e7ca58d0d9b6791b4	2026-01-16 21:31:51.196+00	2026-01-16 21:31:51.196+00	\N	\N
d5986e91-0c1a-46df-87b7-2197ca1e0abd	317	46	2024	MC	1	2024-04-12	2024-04-22	EL MARISCO II	9437	563e665f721836c0e1affcff3ac5fed2	2026-01-16 21:31:51.216+00	2026-01-16 21:31:51.216+00	\N	\N
d26163f8-86a2-4892-9608-11edea92b5ea	318	110	2024	MC	1	2024-07-05	2024-07-09	CENTAURO 2000	9437	11d82b3df05303c6c5854b17dd89e47d	2026-01-16 21:31:51.233+00	2026-01-16 21:31:51.233+00	\N	\N
b531b0de-3acf-4434-933a-5294f73647c0	319	110	2024	MC	1	2024-07-10	2024-07-15	CENTAURO 2000	9437	799fe7de11d0c78bc8c6d8f7e81a9e4b	2026-01-16 21:31:51.25+00	2026-01-16 21:31:51.25+00	\N	\N
01a8c287-0a2d-420f-9d17-6b5825287cf7	320	110	2024	MC	1	2024-07-15	2024-07-24	CENTAURO 2000	9437	a8bbad6bca90b2a0475d3ae3cecbf4f1	2026-01-16 21:31:51.269+00	2026-01-16 21:31:51.269+00	\N	\N
bf2853ee-52f9-4799-812c-a1bc58630b10	321	124	2024	MC	1	2024-08-06	2024-08-19	FERNANDO ALVAREZ	9437	352598a0ba5f517e1e5e68014ee06f44	2026-01-16 21:31:51.286+00	2026-01-16 21:31:51.286+00	\N	\N
9fd4cced-4216-4c7d-ba69-a921e8252325	322	124	2024	MC	1	2024-08-20	2024-08-31	FERNANDO ALVAREZ	9437	d86bcada743b60816d99082b1c0655e3	2026-01-16 21:31:51.302+00	2026-01-16 21:31:51.302+00	\N	\N
4a691e9f-01a8-4926-8beb-b3f4fc829226	323	154	2024	MC	1	2024-10-08	2024-10-13	ARGENTINO	9437	9be31fc010d96b1c8e490e488ea16f1d	2026-01-16 21:31:51.321+00	2026-01-16 21:31:51.321+00	\N	\N
2df7a9c1-11dd-4a82-9a27-20c331fc4462	324	156	2024	MC	1	2024-10-17	2024-10-23	ARGENTINO	9437	91455d9abbf5a710fd301bf223f6d86f	2026-01-16 21:31:51.337+00	2026-01-16 21:31:51.337+00	\N	\N
7a94b4c6-125b-4e3c-bc01-a6ee91d232da	325	156	2024	MC	1	2024-10-24	2024-10-31	ARGENTINO	9437	15c913e8ac387da0086a4a1adbbf7007	2026-01-16 21:31:51.355+00	2026-01-16 21:31:51.355+00	\N	\N
6c2303f2-9d01-46a0-ac78-f3b6417c7b46	326	156	2024	MC	1	2024-11-01	2024-11-07	ARGENTINO	9437	bf4a7e4f42d663c9b7ce1dbe8dd5101a	2026-01-16 21:31:51.371+00	2026-01-16 21:31:51.371+00	\N	\N
5ed84c6a-33d5-4a6d-850a-4477b506a7ae	327	169	2024	MC	1	2024-12-12	2025-01-02	CENTURION DEL ATLANTICO	7796	0502d360336ec3a7f8964fe6ff3a7f70	2026-01-16 21:31:51.389+00	2026-01-16 21:31:51.389+00	\N	\N
65093351-45ba-48d0-830c-4378ecb1c966	328	14	2024	MC	1	2024-01-16	2024-02-02	CHIYO MARU NO.3	7625	b41016c7b66e3fbda7b49d44d670d54f	2026-01-16 21:31:51.406+00	2026-01-16 21:31:51.406+00	\N	\N
e372f75a-fa59-4da9-a9ea-b60a979135ee	329	81	2024	MC	1	2024-05-24	2024-06-09	VALERIA DEL ATLANTICO	7625	99cc032fc1e6d6a3b75121c2a8cbbd5c	2026-01-16 21:31:51.423+00	2026-01-16 21:31:51.423+00	\N	\N
619bdcb2-8168-4ab0-afc9-9a58b5acb4e7	330	122	2024	MC	1	2024-08-02	2024-09-11	CHIYO MARU NO.3	7625	6ae6500027f2ca54e910067467604fb7	2026-01-16 21:31:51.44+00	2026-01-16 21:31:51.44+00	\N	\N
41f7825f-7647-4151-998f-1a776e6e1a7b	331	163	2024	MC	1	2024-10-31	2024-11-11	CHIYO MARU NO.3	7625	830ca8d59dd03483f1777fc9c06c0b03	2026-01-16 21:31:51.458+00	2026-01-16 21:31:51.458+00	\N	\N
ede06b84-757b-474c-8b5d-159b51def167	332	163	2024	MC	1	2024-11-13	2024-12-15	CHIYO MARU NO.3	7625	6e3d733f9f033accadef680859abebce	2026-01-16 21:31:51.474+00	2026-01-16 21:31:51.474+00	\N	\N
18bdaeb4-de21-46e1-889e-e4ea9fc6fa7f	333	53	2024	MC	1	2024-03-28	2024-04-26	JOSE AMERICO	8002	5cde9cd39d3e2bddd65f5e62f7f74d71	2026-01-16 21:31:51.493+00	2026-01-16 21:31:51.493+00	\N	\N
b098e2bd-8dc3-47b8-84d7-c157bc7fe73a	334	69	2024	MC	1	2024-04-30	2024-05-19	DESTINY	8002	34d0152963df1afaace1e900ae093dcd	2026-01-16 21:31:51.511+00	2026-01-16 21:31:51.511+00	\N	\N
63a20cc7-7052-4fe5-93ea-fcabd8bacb9f	335	90	2024	MC	1	2024-05-23	2024-06-13	LUIGI	8002	b85d2527857ba2b58e18c650912315d0	2026-01-16 21:31:51.532+00	2026-01-16 21:31:51.532+00	\N	\N
8b6c695a-9aab-4981-9ef8-25b73d52d517	336	99	2024	MC	1	2024-06-19	2024-08-02	DESTINY	8002	f9a629c80d5e79015dace06164ba05d8	2026-01-16 21:31:51.548+00	2026-01-16 21:31:51.548+00	\N	\N
c8a41afc-dd63-440a-a735-5a0892e0b4f4	337	121	2024	MC	1	2024-08-03	2024-08-13	DESTINY	8002	122bc93ec6b31ad029da53ae473c6d17	2026-01-16 21:31:51.564+00	2026-01-16 21:31:51.564+00	\N	\N
ba988cc9-6caf-49f1-b9e6-5ec2816ddf4c	338	121	2024	MC	1	2024-08-14	2024-08-26	DESTINY	8002	49c46fba85c0ac42c983a75a47c0c93f	2026-01-16 21:31:51.581+00	2026-01-16 21:31:51.581+00	\N	\N
221c5e51-b22e-4e97-9fcc-0d6b857d8070	339	21	2024	MC	1	2024-02-03	2024-03-20	TAI AN	7740	ad2cb03d497244842d296dc9f9b362f6	2026-01-16 21:31:51.598+00	2026-01-16 21:31:51.598+00	\N	\N
3693f179-b619-4ab2-bf93-34e4a48e6529	340	61	2024	MC	1	2024-04-20	2024-05-25	ARGENOVA XXI	7740	894d52378acc4d9444346686663ea5eb	2026-01-16 21:31:51.615+00	2026-01-16 21:31:51.615+00	\N	\N
69d3b9c3-2c08-43b1-86e9-5d990e93a326	341	103	2024	MC	1	2024-07-02	2024-07-31	GEMINIS	7740	5502db5ff0504c076dd0d938f39ea496	2026-01-16 21:31:51.633+00	2026-01-16 21:31:51.633+00	\N	\N
adec7391-16d6-476d-ae31-ea61ce86b445	344	27	2024	MC	1	2024-02-07	2024-03-13	GEMINIS	9474	ce54a2cf4aadd645c66826262a06990d	2026-01-16 21:31:51.65+00	2026-01-16 21:31:51.65+00	\N	\N
014beee3-5a6c-4bdb-aa75-be600960deae	345	66	2024	MC	1	2024-04-26	2024-05-26	CERES	9474	741f849b91e0a060454ed221c70e9284	2026-01-16 21:31:51.667+00	2026-01-16 21:31:51.667+00	\N	\N
cbf6646f-f5dd-4847-ac08-33a7766ea13b	346	91	2024	MC	1	2024-05-29	2024-06-30	CERES	9474	d2a256c5929ede7b76aa8979ff0301ee	2026-01-16 21:31:51.685+00	2026-01-16 21:31:51.685+00	\N	\N
909c53a6-c7d2-41fa-a749-45ecfe7f0ee2	347	114	2024	MC	1	2024-07-17	2024-08-20	LUCA MARIO	9474	920964b5c521e19ad547155d3d9e8271	2026-01-16 21:31:51.702+00	2026-01-16 21:31:51.702+00	\N	\N
9185dc77-3b27-4e41-b9d3-e96e286cac0c	348	134	2024	MC	1	2024-09-02	2024-10-09	LUCA MARIO	9474	b2e828ef6a5affc1e3df84ac18a8e5eb	2026-01-16 21:31:51.721+00	2026-01-16 21:31:51.721+00	\N	\N
d3767387-1d56-4eda-a5f1-db6bbf44ef5d	349	20	2024	MC	1	2024-01-22	2024-01-29	ATREVIDO	7838	fd61d39834c96c3a37f5f9734de41465	2026-01-16 21:31:51.738+00	2026-01-16 21:31:51.738+00	\N	\N
95439402-701b-42b7-b408-e1383745c299	350	20	2024	MC	1	2024-01-31	2024-02-07	ATREVIDO	7838	e3be1774e9bdeb84c58e04126e05300d	2026-01-16 21:31:51.755+00	2026-01-16 21:31:51.755+00	\N	\N
f607d636-4ec1-4590-97e9-db4f6b3ad51d	351	20	2024	MC	1	2024-02-10	2024-02-17	ATREVIDO	7838	72c44e6d94cf08349d07837b8d166802	2026-01-16 21:31:51.772+00	2026-01-16 21:31:51.772+00	\N	\N
92fc76cd-790a-420f-bfde-9e8de752ab75	352	20	2024	MC	1	2024-02-20	2024-03-01	ATREVIDO	7838	76911ea65a5c38ad97ed30b5e4be38e5	2026-01-16 21:31:51.79+00	2026-01-16 21:31:51.79+00	\N	\N
3efe9631-be01-43ab-be68-37833b36cc47	353	56	2024	MC	1	2024-03-28	2024-04-15	VALIENTE I	7838	6577c0bf94290370d09c9479dd8bdd88	2026-01-16 21:31:51.807+00	2026-01-16 21:31:51.807+00	\N	\N
c087fd43-057c-408c-b8ee-36d4145dcb5a	354	84	2024	MC	1	2024-05-22	2024-06-09	BOUCIÑA	7838	d96dfe13305045c636a5e66984009f94	2026-01-16 21:31:51.825+00	2026-01-16 21:31:51.825+00	\N	\N
7cf9e6ab-434d-404f-928c-613b92fc6bfc	355	84	2024	MC	1	2024-06-11	2024-06-21	BOUCIÑA	7838	04290d176861357c7ebcd6dd8cd12ca6	2026-01-16 21:31:51.843+00	2026-01-16 21:31:51.843+00	\N	\N
30606708-2d03-4306-9457-04528398c6a4	356	84	2024	MC	1	2024-06-24	2024-07-14	BOUCIÑA	7838	37bd6adefa2926983a542fd4922f425f	2026-01-16 21:31:51.86+00	2026-01-16 21:31:51.86+00	\N	\N
7252b627-cb57-4ff3-a7be-1de083e1e436	357	125	2024	MC	1	2024-08-08	2024-08-22	FEDERICO C	7838	48d0380ade3816bda5071ec71b18c8fa	2026-01-16 21:31:51.877+00	2026-01-16 21:31:51.877+00	\N	\N
ea9c4dcf-e954-47a7-bd3a-c606a4c52009	358	125	2024	MC	1	2024-08-23	2024-09-14	FEDERICO C	7838	a620f44c92257aa2c109c75b3a15dedf	2026-01-16 21:31:51.894+00	2026-01-16 21:31:51.894+00	\N	\N
af040bd9-5c4f-495b-8f7f-e1ac68f319c9	359	151	2024	MC	1	2024-10-10	2024-12-03	ECHIZEN MARU	7838	890201f5d93106ad2e89f8a2a7c5735d	2026-01-16 21:31:51.91+00	2026-01-16 21:31:51.91+00	\N	\N
41f96a04-ea2a-49b7-86f4-e2aba35932c3	360	62	2024	MC	1	2024-04-20	2024-05-15	ARBUMASA XXVII	7742	544fd31983aa3141fbeced85ab7c38f4	2026-01-16 21:31:51.926+00	2026-01-16 21:31:51.926+00	\N	\N
1d46a455-8f03-4dd7-96a7-29f7ceb12d27	361	95	2024	MC	1	2024-06-12	2024-06-18	JOSE MARCELO	7742	bcca88db4502a0462c08b88a4374ec25	2026-01-16 21:31:51.943+00	2026-01-16 21:31:51.943+00	\N	\N
f2277574-2563-4318-92b9-63a2ca03c673	362	95	2024	MC	1	2024-06-20	2024-06-26	JOSE MARCELO	7742	3d92a46490852b049f950faf33109b95	2026-01-16 21:31:51.961+00	2026-01-16 21:31:51.961+00	\N	\N
54a22003-711e-4d5f-976d-91f9bea83f4e	363	95	2024	MC	1	2024-07-06	2024-07-11	JOSE MARCELO	7742	73cd84c03ab51ddbab048a8105a4047e	2026-01-16 21:31:51.978+00	2026-01-16 21:31:51.978+00	\N	\N
5e8d2963-40d0-427a-8730-62c04d297a81	364	95	2024	MC	1	2024-07-12	2024-07-19	JOSE MARCELO	7742	f199aa85b87d2a948b38997050c7ae2b	2026-01-16 21:31:51.996+00	2026-01-16 21:31:51.996+00	\N	\N
20a2a0be-b9ba-48be-b96a-345803f6e366	365	95	2024	MC	1	2024-07-20	2024-07-27	JOSE MARCELO	7742	f184865a29a7364864d1fef0de777da8	2026-01-16 21:31:52.014+00	2026-01-16 21:31:52.014+00	\N	\N
9e19cb1a-9600-4f18-ae3a-54b3e1bb9361	366	136	2024	MC	1	2024-09-02	2024-09-24	CENTURION DEL ATLANTICO	7742	89b25e6cf3377b22e5ab579925c95a79	2026-01-16 21:31:52.032+00	2026-01-16 21:31:52.032+00	\N	\N
24b4ff54-2caf-48f6-86d0-620f807249de	367	136	2024	MC	1	2024-09-26	2024-10-28	CENTURION DEL ATLANTICO	7742	d6a37429e18b7f02551b2dc7b6accb7d	2026-01-16 21:31:52.049+00	2026-01-16 21:31:52.049+00	\N	\N
2a0d1930-1556-4e00-8d56-2b0e5e6614d5	368	35	2024	MC	1	2024-02-22	2024-03-03	ANDRES JORGE	9476	eea0a3d33a937090e283519dcdde3235	2026-01-16 21:31:52.066+00	2026-01-16 21:31:52.066+00	\N	\N
dbfeb6e4-091c-47d5-aa89-423ffeddbefd	369	35	2024	MC	1	2024-03-05	2024-03-13	ANDRES JORGE	9476	285a01bba8cf4a85f2c533047e6b8aba	2026-01-16 21:31:52.084+00	2026-01-16 21:31:52.084+00	\N	\N
69d916af-6789-47df-b137-2a7b4e04d7c5	370	35	2024	MC	1	2024-03-15	2024-03-26	ANDRES JORGE	9476	d2bdb456b6318910e8e62f42905c26f9	2026-01-16 21:31:52.102+00	2026-01-16 21:31:52.102+00	\N	\N
bd1c0ccb-aa13-44ac-b189-a2574ff98134	371	119	2024	MC	1	2024-08-02	2024-08-09	FEIXA	9476	49035f779c7bbf62ed1c21c6624d6d0a	2026-01-16 21:31:52.119+00	2026-01-16 21:31:52.119+00	\N	\N
5d33b3e0-0935-4216-b82b-5772bebd7a48	372	119	2024	MC	1	2024-08-09	2024-08-17	FEIXA	9476	0c93e6d7bc712649719013cf7a0f13bd	2026-01-16 21:31:52.137+00	2026-01-16 21:31:52.137+00	\N	\N
4c83ec1e-e0fb-4f5b-af2b-d9dadee8b8c7	373	119	2024	MC	1	2024-08-18	2024-08-22	FEIXA	9476	7713ae499f975212f0af099782209ad2	2026-01-16 21:31:52.154+00	2026-01-16 21:31:52.154+00	\N	\N
43bdc3d3-8bd0-44e7-bb68-40a4eb87d549	374	119	2024	MC	1	2024-08-23	2024-08-28	FEIXA	9476	adb7ed6bdf75445920a999eefa81ee59	2026-01-16 21:31:52.171+00	2026-01-16 21:31:52.171+00	\N	\N
faba22b2-8edd-4c59-be9b-c0b60367bb49	375	119	2024	MC	1	2024-08-28	2024-09-02	FEIXA	9476	70c756fecc00ab9576038f50d4bf7379	2026-01-16 21:31:52.19+00	2026-01-16 21:31:52.19+00	\N	\N
8a6afa75-c32b-472f-851c-306eb82cec78	376	141	2024	MC	1	2024-09-06	2024-09-13	UR ERTZA	9476	2bc91774d8cb0a274f196e7d625e652b	2026-01-16 21:31:52.208+00	2026-01-16 21:31:52.208+00	\N	\N
02023f5c-bd91-4a21-b558-3d2fa5f3014a	377	33	2024	MC	1	2024-02-23	2024-03-25	MATEO I	7837	764479f1982cfd695a65056ee4279c4e	2026-01-16 21:31:52.226+00	2026-01-16 21:31:52.226+00	\N	\N
00a79b3e-8c5a-47c7-8bf5-d9c637c2fece	378	73	2024	MC	1	2024-05-02	2024-05-20	ARGENOVA II	7837	b290310642fb52b53f59393416827b82	2026-01-16 21:31:52.244+00	2026-01-16 21:31:52.244+00	\N	\N
af02421f-0265-4a78-a807-c064672b3182	379	24	2024	MC	1	2024-02-06	2024-03-03	DUKAT	7840	4e16d0431a5384e2d00ab0d9505e746d	2026-01-16 21:31:52.261+00	2026-01-16 21:31:52.261+00	\N	\N
672da6ce-e0d1-4036-86ea-ba1c7a64b7b5	380	24	2024	MC	1	2024-03-06	2024-04-09	DUKAT	7840	4801eb1bde2ebff2a6c84ebd0b13ecb4	2026-01-16 21:31:52.279+00	2026-01-16 21:31:52.279+00	\N	\N
7f5081d1-b9f6-4098-8e9e-13a80206ef4c	381	24	2024	MC	1	2024-04-10	2024-04-23	DUKAT	7840	d9fd9005b3ce33c0e4c993eedd42d5a2	2026-01-16 21:31:52.297+00	2026-01-16 21:31:52.297+00	\N	\N
831cab0b-2cc0-4ad0-b87d-3083d63014b2	382	112	2024	MC	1	2024-07-11	2024-08-07	ERIN BRUCE II	7840	64f800e08c5a42d34714928176ad1994	2026-01-16 21:31:52.314+00	2026-01-16 21:31:52.314+00	\N	\N
17ed1cdd-91e3-438c-8e02-263de840add2	383	130	2024	MC	1	2024-08-16	2024-08-24	VIRGEN MARIA	7840	02eafa80e2062ed7ebb1e1d87af5d509	2026-01-16 21:31:52.332+00	2026-01-16 21:31:52.332+00	\N	\N
e132eca8-2a08-40c2-85d2-979d1dbecb3e	384	133	2024	MC	1	2024-08-29	2024-10-15	CAPESANTE	7840	c3a1e7fdddf005b4370b9e7d7bbb77f4	2026-01-16 21:31:52.349+00	2026-01-16 21:31:52.349+00	\N	\N
a6f9d9c6-7af0-4878-b4f2-ad78f85ef3c9	385	155	2024	MC	1	2024-10-15	2024-11-02	ERIN BRUCE II	7840	bb40dd5c3ad162f18e282c5bf1fb1fb3	2026-01-16 21:31:52.366+00	2026-01-16 21:31:52.366+00	\N	\N
8c23cd40-b629-49fc-8f4d-345613f3afb8	388	173	2024	MC	1	2024-12-28	2025-01-16	HUYU 962	7612	c6ae8862624bf5dde79c6e4f9411ee6f	2026-01-16 21:31:52.383+00	2026-01-16 21:31:52.383+00	\N	\N
3e6f09f4-4731-494e-b4f7-5f056fc379c0	390	161	2024	MC	1	2024-11-03	2024-12-19	TAI AN	7798	5fc95158c9c5dc081c91a70fda287227	2026-01-16 21:31:52.399+00	2026-01-16 21:31:52.399+00	\N	\N
1f3c16e1-7de0-4199-8cd1-a88d814ad6ce	392	\N	2024	CI	1	2024-10-03	2024-10-29	TALISMAN	7842	cfd206fe82118d39214c0b047992c9e7	2026-01-16 21:31:52.416+00	2026-01-16 21:31:52.416+00	\N	\N
e7d41872-707b-433f-9af7-d022e0189b4e	393	\N	2024	CI	1	2024-10-06	2024-10-31	TANGO I	2021	5058f8858e0a5eb7ed45f3c800b08d5f	2026-01-16 21:31:52.433+00	2026-01-16 21:31:52.433+00	\N	\N
96d88c52-dd1e-432f-9a01-6c55e5f1b841	398	176	2024	MC	1	2024-12-30	2025-01-27	TANGO I	2021	6f57f124036696633c0140a62fc29f77	2026-01-16 21:31:52.451+00	2026-01-16 21:31:52.451+00	\N	\N
334c1a00-f26c-45d1-a7cc-fddc6ffd507a	399	175	2024	MC	1	2024-12-31	2025-02-04	DUKAT	7842	21a18aa43c602b69a3e87f7bbbcc7b6e	2026-01-16 21:31:52.468+00	2026-01-16 21:31:52.468+00	\N	\N
a593caca-5b9d-4029-b9ed-ff41f40aaa60	400	1	2025	MC	1	2025-01-03	2025-02-03	VALERIA DEL ATLANTICO	7729	8e59be959f7ce66263a1e113dab31eff	2026-01-16 21:31:52.486+00	2026-01-16 21:31:52.486+00	2ffe1eb4-87db-49fc-bba7-f89f742be443	243ddbe2-4dfe-447c-b79f-39bdadfc840e
9778778d-2729-41da-91f5-9155b8aee874	406	5	2025	MC	1	2025-01-07	2025-01-28	GEMINIS	73	bdc865a883c64f8471cc65c0e85d493d	2026-01-16 21:31:52.502+00	2026-01-16 21:31:52.502+00	891568fd-cfd2-4c4c-bfd0-4d9c57f82198	ce9a362d-bb0e-4e94-85ed-de69994ead91
1fbde72e-24ca-4a6e-be80-2c7f188faa71	407	149	2024	MC	1	2024-10-04	2024-10-07	GEMINIS	9467	bb157104ea3a54bf58770084b8500c8c	2026-01-16 21:31:52.519+00	2026-01-16 21:31:52.519+00	\N	\N
388186f1-1a42-41df-be5a-81bd98e96a06	408	149	2024	MC	1	2024-10-04	2024-10-07	GEMINIS	9467	7505bee2457ca2e85f38aefeb6676478	2026-01-16 21:31:52.536+00	2026-01-16 21:31:52.536+00	\N	\N
700ad151-159c-4644-b59f-5584d056b33f	409	149	2024	MC	1	2024-10-12	2024-11-07	GEMINIS	9467	22fd0ae518d97e8ec2545e0b11f61ec5	2026-01-16 21:31:52.552+00	2026-01-16 21:31:52.552+00	\N	\N
ddc2d03f-e1a8-42fd-a9c8-57b56f4ebced	411	7	2025	MC	1	2025-01-07	2025-01-30	SOHO MARU N 58	9467	464152ed179c02bcc34f0dbdced12c63	2026-01-16 21:31:52.571+00	2026-01-16 21:31:52.571+00	30770969-bb3b-49c0-b015-1420bf2d18ee	e161c3a6-63b0-449d-97a3-857bfb55d218
23361727-ea24-4eec-a999-38c4c97c9a92	412	9	2025	MC	1	2025-01-06	2025-02-07	MISS TIDE	9465	fcb49bff7483bcc808a04e9b4e7c4c46	2026-01-16 21:31:52.588+00	2026-01-16 21:31:52.588+00	61f3c95e-a80a-4bd0-8498-9eab710811ec	ad6f7971-625c-4c82-be7d-87350c567fd9
f764d105-0459-40f4-adff-84a564469df8	414	24	2024	MC	1	2024-04-23	2024-04-26	DUKAT	7840	8bdb84120d14cf033f4a51633ed356a4	2026-01-16 21:31:52.606+00	2026-01-16 21:31:52.606+00	\N	\N
45d79f19-43e0-4df1-8d96-ed2ef4e9bacb	416	6	2025	MC	1	2025-01-09	2025-02-02	DON LUIS I	186	2fd1da1a4c7ef74ec603a6ddc885d25e	2026-01-16 21:31:52.623+00	2026-01-16 21:31:52.623+00	d7097607-d295-4981-a72f-090793ba8c33	37998e8c-e6e6-4a93-9c88-613f9180ae65
98a48124-c47c-450f-a490-4f7ee4749159	417	12	2025	MC	1	2025-01-09	2025-02-16	ERIN BRUCE II	4840	e569d1182ef3ae978015da732c548f84	2026-01-16 21:31:52.642+00	2026-01-16 21:31:52.642+00	e492153b-241c-4895-a772-67ad78b6be33	1dff4349-b566-41d1-b70e-9348a0576aed
dd50118b-6ba4-4de8-81d8-84c0767b5b7e	418	14	2025	MC	1	2025-01-09	2025-02-08	NATALIA	7850	28a961f5889997c0bd54ec38a1380044	2026-01-16 21:31:52.659+00	2026-01-16 21:31:52.659+00	e6b7d05c-171a-4ecb-90fb-fb31337da507	71413536-ea05-4ef2-b73d-050be1411c67
bb0652ea-3225-4b0b-bd2e-3602a7637209	419	11	2025	MC	1	2025-01-09	2025-02-02	MATEO I	7621	bf546502b33c173935a9336e4afcab40	2026-01-16 21:31:52.677+00	2026-01-16 21:31:52.677+00	cce1ecad-81c4-4625-b825-48009137d8c3	1f339cd7-94ca-41f2-9fb9-6ef03f968fbd
2fa9a1bd-5140-452c-b3f5-3228dfc4c5b1	423	4	2025	MC	1	2025-01-11	2025-03-07	DON PEDRO	9474	f16082d807d8240185ae3a803dcf45da	2026-01-16 21:31:52.693+00	2026-01-16 21:31:52.693+00	1009a963-f453-4721-8488-ee5f5e7d710b	9d1653fc-8774-4198-8a13-6d7ccda90032
6b74364c-bd70-4312-b855-f83d9dc1e023	424	16	2025	MC	1	2025-01-17	2025-03-01	CAPESANTE	7726	6854e547c72e59f81d14f7b389914a6e	2026-01-16 21:31:52.711+00	2026-01-16 21:31:52.711+00	38c30a58-515e-4bb0-b785-783a38baab82	e65c26a3-52aa-41fb-a88f-7f2f737abde1
e7c56600-f8e3-490f-ad3f-94a9c66a1183	425	10	2025	MC	1	2025-01-13	2025-02-24	ATLANTIC SURF III	166	698908e64cef56ca62dc4ac43a15bc9a	2026-01-16 21:31:52.727+00	2026-01-16 21:31:52.727+00	8997039d-e6d9-4bca-8463-838ac5f6b1fb	860d11e5-310c-4c4c-a7b0-cf31163d04d7
fb56cee5-540d-46d6-b84b-762558779bb5	427	28	2025	MC	1	2025-02-05	2025-04-07	ECHIZEN MARU	7841	a8dad0de60e79d64a37809250a25f107	2026-01-16 21:31:52.744+00	2026-01-16 21:31:52.744+00	e30b483b-ea05-4b41-93f0-c89e7c97b7a6	d6b39e9e-7b11-4e02-a282-635a600c64b0
de7c7178-28e2-4e82-9d60-288f5fe06408	428	33	2025	MC	1	2025-02-18	2025-02-25	ATREVIDO	9467	6e169bf1378aeefb1f79e10ded3e5f75	2026-01-16 21:31:52.761+00	2026-01-16 21:31:52.761+00	4fd2c3f7-68a3-458e-bd8b-5e2c62ec60ed	d7d2bb40-f676-4899-906a-7dde7ea3bd0c
eff6140e-dd13-4951-9c41-44aad619e284	429	32	2025	MC	1	2025-02-19	2025-04-11	TAI AN	2021	667443a8987db9f563c4eb11ef0202e4	2026-01-16 21:31:52.779+00	2026-01-16 21:31:52.779+00	0ac9a3b7-fead-4b51-b1c3-51c7333154ef	9af08888-e32c-4062-a997-5290e7b4dec4
702c4db4-398c-4c0f-a1fe-19cf3c476f24	430	37	2025	MC	1	2025-02-22	2025-03-26	CHIYO MARU NO.3	9465	a4b42bfbdb730955d6cea4f176c9e7d9	2026-01-16 21:31:52.795+00	2026-01-16 21:31:52.795+00	e21b90dc-df99-4eba-8a8a-1624de4dc936	2a7b5234-e133-4150-bd79-7cb8337da1c6
ca9c099b-9724-45b1-bf26-dd0a80e112e9	431	35	2025	MC	1	2025-02-25	2025-03-30	ARGENOVA XXI	4840	691d207a4e9b562dd4e2b6158bb84d19	2026-01-16 21:31:52.813+00	2026-01-16 21:31:52.813+00	6da5576d-2280-48a7-8d72-be325aafe103	1418505d-4efc-4f00-9498-09c7197a7f33
4e125dfb-39a6-44e5-a657-76a4c52c7879	434	34	2025	MC	1	2025-03-01	2025-04-07	ATLANTIC SURF III	7621	f7d66cb5c414c83d0f07de49641282d1	2026-01-16 21:31:52.832+00	2026-01-16 21:31:52.832+00	1a54b40d-84c1-4c94-a3d6-a2b52391b780	58a24d0b-fdd3-4046-8ced-257f2e367924
3184a158-f8bd-4bd9-ab1d-02d34ebcd6d8	435	38	2025	MC	1	2025-03-06	2025-03-26	ATLANTIC EXPRESS	190	a9e1b023eb341d5d7a3eee30cb229b0b	2026-01-16 21:31:52.849+00	2026-01-16 21:31:52.849+00	da24bf7d-9642-4503-81d1-58fd1fbe8ffe	29d58fb0-f7bf-42b7-b475-2034e40266de
e30facbc-2008-4fb0-b811-d95ddb8bf273	436	171	2024	MC	1	2024-12-30	2025-02-03	CHIYO MARU NO.3	172	d5720e7aab70b94f45d3ea60fe466f46	2026-01-16 21:31:52.866+00	2026-01-16 21:31:52.866+00	\N	\N
6d060ce2-cd54-4fe1-bfaf-9f8a041f1bd9	437	171	2024	MC	2	2025-02-04	2025-02-19	CHIYO MARU NO.3	172	bb401728f29dc044432cbed8eb686783	2026-01-16 21:31:52.881+00	2026-01-16 21:31:52.881+00	\N	\N
af015697-1046-495e-a6e0-788e74ae0554	439	41	2025	MC	1	2025-03-07	2025-04-07	AURORA	7832	fd493b59fbed13d23de724d101e1b5a3	2026-01-16 21:31:52.899+00	2026-01-16 21:31:52.899+00	90bf9a4a-3233-43e0-bceb-4843a6424ff1	1b19284e-c88e-4710-a914-83b06e5e7bbb
42e437a8-52f1-4481-b994-db941f1a0581	441	20	2025	MC	1	2025-02-04	2025-03-11	DON LUIS I	186	1acbc16867c399b299a130ebea6038b2	2026-01-16 21:31:52.916+00	2026-01-16 21:31:52.916+00	6f309917-3dfe-408c-bb64-c2f226f2316c	a4ac087b-9be4-41eb-9eea-0374230d5289
449742a1-85df-43f9-92f7-523cb209207a	442	40	2025	MC	1	2025-03-06	2025-04-13	CAPESANTE	7726	153c5c0893dd011bbba6dff7766fa62a	2026-01-16 21:31:52.934+00	2026-01-16 21:31:52.934+00	e4dfb9b7-1dc7-4838-bd5b-65bda33b7062	edad3627-6e29-4620-aa6e-de7ccb7c85e4
c07d048f-d3ca-46de-b7a3-83c5a1836654	447	18	2025	MC	1	2025-01-17	2025-03-09	HUYU 961	7853	49ea6f825f06aca14aa92153364ad44f	2026-01-16 21:31:52.951+00	2026-01-16 21:31:52.951+00	640d4643-f206-4c34-a756-ef14e6c99a79	ba0b8574-30a9-46a9-a3a9-65a2231052c5
941f473a-63a4-4a55-88e9-ae069b2dbb56	449	21	2025	MC	1	2025-02-06	2025-03-11	DUKAT	7845	49574af0d21679ac9075ce286db4151e	2026-01-16 21:31:52.969+00	2026-01-16 21:31:52.969+00	71b5feb8-c564-4834-845c-a91318c6492e	466227be-bca2-420c-9724-d417540e7f2a
bc5c51d8-6e7a-4f65-80c0-5780c466e1c4	450	22	2025	MC	1	2025-01-31	2025-03-24	HOYO MARU 37	7149	890a22fc7351c3e6055c6a4ba5cd9a88	2026-01-16 21:31:52.987+00	2026-01-16 21:31:52.987+00	98d6da59-bc8f-49ff-a776-aff6e36ccb0a	2d73d1e4-eded-4548-af91-fa306895854c
333bf98b-ae1f-4e32-a594-1bfbaee5b2d2	453	25	2025	MC	1	2025-02-01	2025-02-26	TANGO II	7848	8c88459d2b8cec74c76040fea0d3c5de	2026-01-16 21:31:53.005+00	2026-01-16 21:31:53.005+00	e6f7ebb4-26d6-4bc1-b14e-db07fdf479f5	2a817b6f-286d-4906-8161-42cc90b912a0
862c9ac8-32d4-4ec0-9475-c68d51f94cb0	455	27	2025	MC	1	2025-02-01	2025-03-08	MINTA	7854	f4472b82e6bf5328cf653e6b04b3c3b9	2026-01-16 21:31:53.022+00	2026-01-16 21:31:53.022+00	b8d25e78-d9c7-4416-977b-ebf6e60ca6cc	b2aa34fb-6551-45eb-9999-79aacdcf1c9d
5959f91c-a87f-45aa-b5cb-6d50cb5d29b8	456	29	2025	MC	1	2025-02-08	2025-02-22	SIRIUS II	9476	0962c144a14d262319543ca87a083334	2026-01-16 21:31:53.041+00	2026-01-16 21:31:53.041+00	e5d2e37b-a388-47fd-b3a7-a09b73fa0158	e2c55b2f-dd63-4ffb-adc5-2d8120e7bfd5
815a2a96-cbd7-481e-8fbe-8233c68f1810	458	30	2025	MC	1	2025-02-13	2025-03-24	VALERIA DEL ATLANTICO	7838	28aabf2ca7fd4ecb37d1d6bb9b5680f6	2026-01-16 21:31:53.057+00	2026-01-16 21:31:53.057+00	7701800b-8c67-4f60-80ea-c72a68a80f7d	0e7ed4fe-5f1f-4fdb-8773-4dda588cda6b
374a781e-759f-4e87-8c03-c13c2aba7f85	459	31	2025	MC	1	2025-02-12	2025-03-20	MISS TIDE	7844	ba15b68ff5480e09f3ecf9a19b99c6ba	2026-01-16 21:31:53.076+00	2026-01-16 21:31:53.076+00	3d1e676b-21d2-45cd-8f2d-d93f4727b01c	3e870e30-a3ae-4401-b8c1-f377021129ee
099d2c46-7b30-4ce5-8cf6-ad2e39c9eb83	472	50	2025	MC	1	2025-03-24	2025-04-23	NANINA	7848	896c4d3d4ebcc81ddf8bf8931366cbae	2026-01-16 21:31:53.093+00	2026-01-16 21:31:53.093+00	134e771f-508a-40df-a6ac-76f532bdaeb6	2298767a-e9dd-484c-86f8-c0c21ba485be
94c8a27c-4cf2-4139-a50e-88e1003c07e3	474	\N	2024	CI	1	2024-10-03	2024-10-21	CHIYO MARU NO.3	7625	49efede27225b49b226d660862e8397f	2026-01-16 21:31:53.11+00	2026-01-16 21:31:53.11+00	\N	\N
e89d5d13-d702-40f4-8c1f-2c707d352d8e	475	\N	2024	CI	1	2024-10-21	2024-10-30	CHIYO MARU NO.3	7625	40d4ca8702f68053a7ec7b133c918caa	2026-01-16 21:31:53.127+00	2026-01-16 21:31:53.127+00	\N	\N
5b1f8f6e-a4e4-480c-9231-493a9a89295e	478	53	2025	MC	1	2025-03-28	2025-05-05	NATALIA	7846	3f9d31a5839c91ec7afea4476343618c	2026-01-16 21:31:53.144+00	2026-01-16 21:31:53.144+00	8ca1a435-51b3-4cdb-8323-d12132f30070	dddfddcd-6808-49fe-93a1-b525e266e339
92254ced-2397-49b8-92f8-35da576e6c58	480	43	2025	MC	1	2025-03-11	2025-03-16	MARIANELA	9461	b10d5b04f76633c0f845146e6e559fe1	2026-01-16 21:31:53.162+00	2026-01-16 21:31:53.162+00	e06c2441-b7b0-4922-9aad-dbc981bbc1d3	bcddb3e9-5a97-44c1-989a-35cb627c0f9a
30606dcc-d752-40f7-b5ae-a2ba7536dcbc	481	43	2025	MC	2	2025-03-19	2025-03-28	MARIANELA	9461	19bb67481638469c1b91dfa0f73c1183	2026-01-16 21:31:53.18+00	2026-01-16 21:31:53.18+00	e06c2441-b7b0-4922-9aad-dbc981bbc1d3	c0972778-9663-497f-99de-6ed0e8a32b05
d67be46c-b922-4eb2-bfe6-d1435394eaaf	486	42	2025	MC	1	2025-03-11	2025-03-18	TOZUDO	9471	d165829ba4032c772234a8d1248913b9	2026-01-16 21:31:53.198+00	2026-01-16 21:31:53.198+00	c29d8cf7-bdde-4596-8fda-d1911fbe68ec	01c6479f-a8e8-4ada-a0eb-5efa6a684a5d
7a7108fe-0fc2-4eee-8c35-2cc58d7f96be	487	42	2025	MC	2	2025-03-21	2025-03-28	TOZUDO	9471	54dde13d8a8086c144f87933852b8973	2026-01-16 21:31:53.216+00	2026-01-16 21:31:53.216+00	c29d8cf7-bdde-4596-8fda-d1911fbe68ec	e266f665-24dc-468c-ac5f-20bada3eb06e
1cde488a-0feb-4440-afb2-f66351fb9d1f	493	54	2025	MC	1	2025-04-08	2025-05-17	ERIN BRUCE II	190	d6cdb35a3f5ce570c06f9cd96d34ef1b	2026-01-16 21:31:53.236+00	2026-01-16 21:31:53.236+00	f4602bf8-6141-4e7c-9a9b-9d3d1e63761f	500ac431-1c89-4bad-a558-a9a8ad38ff23
9eed1f4a-fd3a-46be-bf47-26cf78d6227e	495	36	2025	MC	1	2025-02-21	2025-04-02	ERIN BRUCE II	7852	95e4f0e956044f83f98043b0834c8b90	2026-01-16 21:31:53.253+00	2026-01-16 21:31:53.253+00	9f71d41a-5a5b-4ee1-8076-f8ef65eb3583	1bb1b2c6-fbb9-41e8-bd47-224fc90ebc66
7f6e17c1-69aa-4b85-bfa0-ab1d6b014b83	502	56	2025	MC	1	2025-04-09	2025-05-20	ECHIZEN MARU	73	8917f49f25aa91abb372adade15572bf	2026-01-16 21:31:53.271+00	2026-01-16 21:31:53.271+00	ab688bbc-76e4-4967-9d8b-79141f666795	157b4484-7417-4b78-99f4-b387d84bd271
5211477c-1720-4157-b454-bdefea7efc1e	507	\N	2025	CI	1	2025-04-16	2025-05-16	HOLMBERG	7627	cfb4fbe6d116923c6dfb4effb7a29317	2026-01-16 21:31:53.288+00	2026-01-16 21:31:53.288+00	\N	\N
ad558c50-52d4-47ed-8b62-433278f7c6f3	520	61	2025	MC	1	2025-04-17	2025-05-27	CAPESANTE	9461	39b4ced0fe71a655f25ac7c44cdce839	2026-01-16 21:31:53.305+00	2026-01-16 21:31:53.305+00	bc9edd1c-bfb7-4fc2-a452-e6cf557ca733	c62465fa-1330-4c44-87d2-d6250ea4e2d0
3a6ea8a9-6d4b-4596-9b98-e6e057b971ca	524	51	2025	MC	1	2025-03-28	2025-04-30	MISS TIDE	166	6de02fae2b4744385a48f04921b6d6ba	2026-01-16 21:31:53.32+00	2026-01-16 21:31:53.32+00	a82d5e41-b695-4a9d-aea9-0f3194d52b67	749d60a0-d908-4523-9474-b7cfecb5b597
e78156f0-625b-4e3d-a787-ab7eabeaccef	525	52	2025	MC	1	2025-04-01	2025-04-27	ARGENOVA XXI	7724	6d46299c366f3dabf91a10ec8712c4d6	2026-01-16 21:31:53.338+00	2026-01-16 21:31:53.338+00	36d0f8b0-0c70-4822-9a1f-17486328b822	4fd45a64-46ee-45cd-a09b-09eb77f07011
b2f9eb94-ea60-4f9a-bf4d-fb9cb5e18972	534	26	2025	MC	1	2025-02-04	2025-03-10	VENTARRON 1º	7849	a0a1da05dd31b50d24cf75682bec5ba2	2026-01-16 21:31:53.354+00	2026-01-16 21:31:53.354+00	55f52d76-0c76-490c-81d3-5a03b292c9c3	ce2fad78-fc03-43b8-a20b-1f5fea8be357
939983de-e41e-4057-afda-472a2d8dd45c	591	58	2025	MC	1	2025-04-23	2025-05-14	VIEIRASA DIECISIETE	7832	0f862227332f94b6fe5abada48fef09e	2026-01-16 21:31:53.372+00	2026-01-16 21:31:53.372+00	83254676-7d69-46bb-839c-fcb352334c92	dedcc07e-2050-4653-bc46-11d26579a2dd
0bab61a7-cc56-4681-b41f-b20dca8a8311	599	55	2025	MC	1	2025-04-18	2025-05-19	TAI AN	9480	0a3ecefcfe3898ef42de65046c4d99ae	2026-01-16 21:31:53.389+00	2026-01-16 21:31:53.389+00	4f5e867f-2277-4990-89a0-8e621d229020	9c454da8-a2ce-47ce-b75b-d887753651af
4e4d47e0-2b1d-436d-9bb9-d569fda095f1	601	64	2025	MC	1	2025-04-27	2025-05-31	VENTARRON 1º	174	ac477dd5e4e91d41d76f39774b66dec2	2026-01-16 21:31:53.407+00	2026-01-16 21:31:53.407+00	2e03db0e-0f5a-4bee-a9ce-62275877178f	486d631a-9717-43cf-8b51-096d77904347
c4bdfcca-9688-4b56-aab0-f0f20c1a7fae	602	72	2025	MC	1	2025-04-29	2025-06-02	ARGENOVA XXI	7798	f384027e10d945a29a596e37db49c1d9	2026-01-16 21:31:53.424+00	2026-01-16 21:31:53.424+00	61639206-bb3b-4e02-a43b-571ffe935af8	22b25059-a61a-4e74-9dcd-59cf9e8efc38
c343224d-4cb8-4f37-83d3-053077bd5823	603	74	2025	MC	1	2025-04-29	2025-05-15	CERES	9474	7645093ef1f6cf6454cb2e5a079b4e23	2026-01-16 21:31:53.439+00	2026-01-16 21:31:53.439+00	23bec926-2e1e-48ac-a34e-b021931e5c4a	10405f4f-6608-49fc-a0f5-bc59d82b6f8a
1e0e40de-dc20-48cf-9b0b-7b1a0cbeddf6	605	73	2025	MC	1	2025-04-30	2025-04-30	CENTAURO 2000	186	8d084facb9f2a5b8a5a716ef8bf9e3a9	2026-01-16 21:31:53.457+00	2026-01-16 21:31:53.457+00	5ad3a3fb-e713-4aa4-bdfa-c64897be84c4	17814177-3623-4279-b7cf-c52271b8f123
3f4fd538-fd42-4527-9140-46b51b16048a	608	67	2025	MC	1	2025-04-30	2025-06-16	COALSA SEGUNDO	7841	e619c0f060d4b868b7044d3fa9b6729a	2026-01-16 21:31:53.475+00	2026-01-16 21:31:53.475+00	edb87fd9-19c0-438c-a893-5b99fcecf2e6	3193e0fd-04bc-4567-a56d-e44b975312d0
2a529804-cf79-4134-aa7c-bb8cbb853ff7	616	71	2025	MC	1	2025-04-30	2025-06-05	MINTA	7796	6ddfb8ffa84c9b9072dcc5083103db8e	2026-01-16 21:31:53.491+00	2026-01-16 21:31:53.491+00	e15a4939-ae23-4991-8ac4-5ed84361e229	dc28d960-10d7-45e3-b33e-e61bcf7e679b
296e6743-cf75-40ce-bf34-68c7b1d8b66a	627	73	2025	MC	2	2025-04-30	2025-05-06	CENTAURO 2000	186	be94c0e2229d14c2fbd0217827935724	2026-01-16 21:31:53.509+00	2026-01-16 21:31:53.509+00	5ad3a3fb-e713-4aa4-bdfa-c64897be84c4	27102d32-1b6f-4dbe-a315-ff516570b127
bb15a045-f775-45fe-9474-8f2fa3996734	631	77	2025	MC	1	2025-05-04	2025-06-03	GEMINIS	7855	bf57418fa469fc4872830bc5a2408769	2026-01-16 21:31:53.526+00	2026-01-16 21:31:53.526+00	ad6ff68c-97d6-4ccf-99e7-09705901ef24	1e995e88-4520-43e1-b51f-48635b05f93d
928408f7-16ce-489e-823d-db4b3259fb28	649	78	2025	MC	1	2025-05-07	2025-06-09	MATEO I	7860	54dc7af91e51ca69579672688f5f2aaf	2026-01-16 21:31:53.544+00	2026-01-16 21:31:53.544+00	ac5ff8a0-6a36-4e59-a826-099cad6c260a	1e27eeb6-a775-412e-a766-c42f9573e029
4188f04d-0ca1-4f1d-a6b0-899e4db5fb8a	650	79	2025	MC	1	2025-05-07	2025-06-10	NATALIA	7859	9e40f6ef968c0e91b91a25452fc1ee2a	2026-01-16 21:31:53.561+00	2026-01-16 21:31:53.561+00	92c833ed-110f-423d-bb0f-42eb1a3cc410	1b010a98-ed5b-4a6f-b05b-319862e3c748
52da414f-353a-4f18-82e7-44299ac7534b	651	76	2025	MC	1	2025-05-07	2025-06-10	MISS TIDE	4840	562dfdec559fc628bd040987d34c9737	2026-01-16 21:31:53.579+00	2026-01-16 21:31:53.579+00	d1345931-2377-4835-b707-56cffe0d23b7	3d71f003-89db-440f-b8de-fc425109df6c
14584e46-874b-46a2-b7d1-6c383acc0f36	656	30	2025	MC	2	2025-03-26	2025-05-07	VALERIA DEL ATLANTICO	7838	1b0fb862bfc75aca0b56cba0aeee02aa	2026-01-16 21:31:53.597+00	2026-01-16 21:31:53.597+00	7701800b-8c67-4f60-80ea-c72a68a80f7d	\N
24f44f7c-59ff-4fc0-8ea0-fd43601aa869	657	73	2025	MC	3	2025-05-08	2025-05-17	CENTAURO 2000	186	4c3ede3101bfc3af42044d0cc8d09998	2026-01-16 21:31:53.616+00	2026-01-16 21:31:53.616+00	5ad3a3fb-e713-4aa4-bdfa-c64897be84c4	0f90c115-66cd-4848-b78d-203dcc9478ca
10598511-b153-4e95-965f-979b508b8f9f	658	75	2025	MC	1	2025-05-08	2025-06-17	VALERIA DEL ATLANTICO	7843	8830a5b3c0b54477e6b907406506ecfd	2026-01-16 21:31:53.633+00	2026-01-16 21:31:53.633+00	5ca55e94-ec43-4870-a024-53c6fd3899e0	48b29034-8595-451f-9c4c-a4dfe562f46d
9d3df482-a148-4f55-b7ae-44a92f6e2f89	726	70	2025	MC	1	2025-05-02	2025-05-10	ANDRES JORGE	7730	3ece237e70a6931bfed5113199831e39	2026-01-16 21:31:53.65+00	2026-01-16 21:31:53.65+00	6b0da04b-0dd6-421a-bd51-67a1f0c1a56a	98857039-ae1e-45f3-9680-fbd75efe9413
91f27fc5-cfc7-4e0c-a734-70e055ac137b	727	70	2025	MC	2	2025-05-12	2025-05-21	ANDRES JORGE	7730	4292ee9443232fcf48df95a9c02c2a77	2026-01-16 21:31:53.668+00	2026-01-16 21:31:53.668+00	6b0da04b-0dd6-421a-bd51-67a1f0c1a56a	4a1a9bb2-8aa1-4080-8a01-b6b61c6f1bf4
f9ba851e-a3bb-426d-8bf1-10b91b4d7f23	798	45	2025	MC	1	2025-03-11	2025-03-20	DON GAETANO	9467	f48fa204f10e89dd33de2b5daf95d88a	2026-01-16 21:31:53.685+00	2026-01-16 21:31:53.685+00	921652f0-4013-4808-98fb-9234429ecfdf	baae2ec9-ad48-4f50-94af-e4b9375c1bec
efb8a4ee-1c3a-4a5f-be78-70552f2f761d	799	45	2025	MC	2	2025-03-22	2025-03-27	DON GAETANO	9467	091150b68f18dc72766c03cc205118aa	2026-01-16 21:31:53.702+00	2026-01-16 21:31:53.702+00	921652f0-4013-4808-98fb-9234429ecfdf	f3fe276f-35b7-49a4-8a1b-2b3e3e2922f2
031a2190-ec66-4d9b-9b9e-2b8e845276ec	800	23	2025	MC	1	2025-01-29	2025-02-23	ARBUMASA XXVIII	7843	325782527a7dbfde6cb1920f8fcf3daa	2026-01-16 21:31:53.719+00	2026-01-16 21:31:53.719+00	0f730c5f-a6f1-4aed-be91-93320107ef3c	76a9cb5f-3f75-4acd-ac63-5220e64e7131
976e1a23-8cf1-4d68-a341-f5ceaae34166	801	23	2025	MC	2	2025-02-25	2025-04-06	ARBUMASA XXVIII	7843	7d092bd9bac2ad13ec838e2b471af79b	2026-01-16 21:31:53.736+00	2026-01-16 21:31:53.736+00	0f730c5f-a6f1-4aed-be91-93320107ef3c	8a88e19d-9760-4749-be31-7156968c30fa
d36a749d-b507-4869-894c-1b77f3ecb3e4	802	81	2025	MC	1	2025-05-15	2025-05-27	ATLANTIC EXPRESS	7842	6a77bd8e0b94475ddd0c3d55c97e98f6	2026-01-16 21:31:53.753+00	2026-01-16 21:31:53.753+00	896cabea-e6b1-4027-9da4-4cd64d9b8173	cc1ff641-fefd-44d9-af4d-989631d891c7
c608600d-7724-4089-9301-c228c771bce9	807	80	2025	MC	1	2025-05-11	2025-05-18	MAR SUR	2021	f9965af767ea9abaec649b32dc72a7d8	2026-01-16 21:31:53.769+00	2026-01-16 21:31:53.769+00	1ee1160e-1fe6-4523-a965-5d081f225006	8eeadbc4-2299-46d1-86c5-876e0874a3ab
24b317c7-32e3-4a8d-a280-da99ab8a3ae9	810	59	2025	MC	1	2025-04-22	2025-06-06	ATLANTIC SURF III	7853	b17d9c293a6608df35a7528decfb6334	2026-01-16 21:31:53.785+00	2026-01-16 21:31:53.785+00	02d0bd10-2761-47e9-a460-30e179e77b9d	c34aeca6-6397-4a8e-bd65-8c968b1f91d0
79c7394b-1f53-4f7f-bd27-b99de8d6315d	812	68	2025	MC	1	2025-04-26	2025-05-04	GRACIELA I	7767	31e0b88152b1fe2028bb8e00e3fc5ce2	2026-01-16 21:31:53.802+00	2026-01-16 21:31:53.802+00	cc26c06e-063a-4f03-ba93-dc1548da8b5f	99e6e73f-2e31-4bfb-9c59-4b6ce4305e15
f1d32a50-f3d5-4b78-8730-09277000da5d	813	68	2025	MC	2	2025-05-06	2025-05-15	GRACIELA I	7767	822049d72d718c7b4dded09c6a2d3452	2026-01-16 21:31:53.818+00	2026-01-16 21:31:53.818+00	cc26c06e-063a-4f03-ba93-dc1548da8b5f	2838cc2e-66be-4d23-bd94-01121597f25c
4967962e-ae38-4b79-89fe-c416b4b435f4	818	68	2025	MC	3	2025-05-17	2025-05-27	GRACIELA I	7767	c539f3d52f6770789c547d8292e3dc5b	2026-01-16 21:31:53.835+00	2026-01-16 21:31:53.835+00	cc26c06e-063a-4f03-ba93-dc1548da8b5f	c2414831-796a-41e0-ae5e-d2e056735a28
702b3e3f-4c28-4c3b-b5b4-47df87bf51b1	831	83	2025	MC	1	2025-05-17	2025-07-13	DON PEDRO	7828	961e73f199f0cf5cbcb83bd0462238ec	2026-01-16 21:31:53.852+00	2026-01-16 21:31:53.852+00	6536a509-e9ff-4c6c-86ac-c29d35e250a1	9a840e34-3f0a-4b11-8c95-26d118b9aa63
19f4f2f8-d0f7-4482-95f8-e7cd41c48890	838	2	2025	MC	1	2025-01-04	2025-01-28	ARGENOVA XXI	9480	0a9baed54f0e14c1601e26d16c894c30	2026-01-16 21:31:53.876+00	2026-01-16 21:31:53.876+00	88d8de1d-3229-4290-bd9b-8bac988cb4ae	1a14a7d0-1bed-4e13-aee7-f5ed3c10d6f3
3253be0e-b2d7-493e-9a7d-0545dfbc6933	839	24	2025	MC	2	2025-02-01	2025-02-22	ARGENOVA XXI	9480	10ec14a805f79359ab90a7becab708f4	2026-01-16 21:31:53.894+00	2026-01-16 21:31:53.894+00	04b6229f-7d19-4b8a-9237-a519202222a0	\N
c2b16f79-9bdf-4c43-abcf-c8233f8f8272	840	19	2025	MC	1	2025-01-31	2025-03-03	TANGO I	7846	25afb71444bd9381c8fb5a575e0a7e9f	2026-01-16 21:31:53.911+00	2026-01-16 21:31:53.911+00	4c7760d3-eef2-49a2-bd90-ec74d9d2b3ed	d3717f48-3cd5-4a17-a2f7-a7db7f28f2bc
32736a45-c7f6-4132-b87e-2f069adcaa67	841	19	2025	MC	2	2025-03-07	2025-03-14	TANGO I	7846	d614dd70fdecdf6151684313fa19a8e1	2026-01-16 21:31:53.928+00	2026-01-16 21:31:53.928+00	4c7760d3-eef2-49a2-bd90-ec74d9d2b3ed	\N
a4515391-8db3-4bf6-9e25-46ec31c0dda9	843	49	2025	MC	2	2025-03-19	2025-04-23	CAROLINA P	9474	a22cf51ece59cbe1ca0dbda6dd65d05e	2026-01-16 21:31:53.946+00	2026-01-16 21:31:53.946+00	9b158375-56d3-4207-a70b-32eb6f7e4a1f	\N
493e29e8-7893-4876-8189-7d9a3963befa	844	46	2025	MC	1	2025-03-07	2025-03-12	TESON	7847	e660a3cefe28ad65bfa9f5d5f826b963	2026-01-16 21:31:53.962+00	2026-01-16 21:31:53.962+00	eab63893-ae5b-4bb9-81f5-82073dd5a928	5ea22ed4-f675-4b7e-8519-a131ffd0c97d
c0990bd2-d6b3-4f78-9537-ec16d6236bda	845	46	2025	MC	2	2025-03-15	2025-03-18	TESON	7847	2779de8c035c4adbc39cc8bfdc204d14	2026-01-16 21:31:53.981+00	2026-01-16 21:31:53.981+00	eab63893-ae5b-4bb9-81f5-82073dd5a928	46eb726d-24b6-42ec-87b2-4f17ea8bd326
b20cd9ed-fe43-4737-bdcc-597761c53a71	846	57	2025	MC	1	2025-04-09	2025-04-28	TANGO I	7847	40a7d0db1172707f34bedd009d734153	2026-01-16 21:31:53.999+00	2026-01-16 21:31:53.999+00	75b63bea-982a-4151-8923-cdc3ca09d56e	c3c6c893-1c29-48bf-8a9d-25092a69e2f7
60795275-8840-490e-b559-64fe743a9975	847	57	2025	MC	2	2025-04-28	2025-04-30	TANGO I	7847	d74f04990fdfa14125e4008a088b9900	2026-01-16 21:31:54.016+00	2026-01-16 21:31:54.016+00	75b63bea-982a-4151-8923-cdc3ca09d56e	\N
73fccd9a-4788-418a-a684-7a16891c554e	848	60	2025	MC	1	2025-04-12	2025-05-08	ATLANTIC EXPRESS	179	7752486a6c06d985943afccd515b3b16	2026-01-16 21:31:54.034+00	2026-01-16 21:31:54.034+00	13eeb6f9-9d7e-48d0-8d5d-d72695620833	732207d1-4352-4953-b114-809c06bf4a00
2cbbf94f-fbc8-4621-ac1d-326d88f958f6	849	60	2025	MC	2	2025-05-08	2025-05-12	ATLANTIC EXPRESS	179	46a964af89a8df3bcaa5132d16935174	2026-01-16 21:31:54.052+00	2026-01-16 21:31:54.052+00	13eeb6f9-9d7e-48d0-8d5d-d72695620833	\N
eaa7de91-8e3c-4b37-a292-bc417695e8bd	853	3	2025	MC	1	2025-01-04	2025-01-08	ATLANTIC EXPRESS	179	68146197bc09e7d0827458d3d9bc3366	2026-01-16 21:31:54.069+00	2026-01-16 21:31:54.069+00	855ed6f3-5a13-41d4-a6b3-bf85b2fd720f	89abf8a8-1795-43b8-9d32-a6ddf115b379
0f0289ab-ebce-4e13-954f-487a94517311	854	3	2025	MC	2	2025-01-08	2025-01-13	ATLANTIC EXPRESS	179	a8f646896d710a629c88514a77588609	2026-01-16 21:31:54.086+00	2026-01-16 21:31:54.086+00	855ed6f3-5a13-41d4-a6b3-bf85b2fd720f	\N
245e69cf-941f-46c1-a5bf-95d5deac6407	855	3	2025	MC	3	2025-01-14	2025-02-04	ATLANTIC EXPRESS	179	e40ade9601bbbedf886d9f7d97a441e1	2026-01-16 21:31:54.104+00	2026-01-16 21:31:54.104+00	855ed6f3-5a13-41d4-a6b3-bf85b2fd720f	\N
efd7c39f-1356-4f4a-adf7-ca24a0d869a1	856	3	2025	MC	4	2025-02-06	2025-02-22	ATLANTIC EXPRESS	179	d26e7319627e40b62b03eea7cdb1da87	2026-01-16 21:31:54.123+00	2026-01-16 21:31:54.123+00	855ed6f3-5a13-41d4-a6b3-bf85b2fd720f	\N
dc96f497-4dea-4e00-a8ab-571437cb7b8d	864	87	2025	MC	1	2025-05-22	2025-06-21	TAI AN	9480	3a6476823454f0a3c6b9d8260dd185e4	2026-01-16 21:31:54.142+00	2026-01-16 21:31:54.142+00	3dd68328-0ea1-4d1a-9142-b67088fedcda	12effdc4-5a42-40cb-a4b9-1d2f06974cde
0fced67d-4dac-449d-ae9f-eebfcf36c445	865	86	2025	MC	1	2025-05-22	2025-06-05	SCIROCCO	7852	90928967c339b2f4c919e8cd28a281e2	2026-01-16 21:31:54.161+00	2026-01-16 21:31:54.161+00	ce6b184a-27cc-4e69-9b54-1de1c90c1dec	36ed6f7c-ac14-4bf9-a0e0-c6bd18edef6a
e52c6211-98b8-48d2-8381-31f3a70b54fa	866	73	2025	MC	4	2025-05-22	2025-05-29	CENTAURO 2000	186	0fa5f56f0296045a0b99ef59817c4fb4	2026-01-16 21:31:54.179+00	2026-01-16 21:31:54.179+00	5ad3a3fb-e713-4aa4-bdfa-c64897be84c4	\N
e9bb6f7b-4d84-4027-bc5c-39ead7889277	867	84	2025	MC	1	2025-05-22	2025-06-17	LUIGI	7850	d13d16708a0c91e39d85daa0d124ee27	2026-01-16 21:31:54.2+00	2026-01-16 21:31:54.2+00	d97a833e-1094-4499-acd3-abe345f14bf6	7b11b129-39ee-454e-b242-f8ca50b38e3c
951d1fd5-fb6e-4aaf-a84d-65102f7fd5f2	868	82	2025	MC	1	2025-05-22	2025-07-10	ECHIZEN MARU	7726	d77d201c116a58bc88cfe6ba5b7eb48b	2026-01-16 21:31:54.219+00	2026-01-16 21:31:54.219+00	24de7801-3383-4693-90a3-d4e2f389ebc2	88ab7e6c-9a34-4d13-addb-804a897facd1
204bcda0-a829-4c7b-8e6e-d96b87c43736	872	62	2025	MC	2	2025-04-16	2025-05-27	PUENTE VALDEZ	9467	3df439e13a02e87fd9c68e69dd3ebd7e	2026-01-16 21:31:54.236+00	2026-01-16 21:31:54.236+00	7d09cfaa-19da-4ab3-8ce5-b891a4b9d215	\N
e3b23d2c-425d-4b6e-970a-69ce9839b8aa	874	69	2025	MC	1	2025-04-26	2025-05-28	NANINA	7848	9ce6a475a0cf589fa76dc25fcbec20cc	2026-01-16 21:31:54.253+00	2026-01-16 21:31:54.253+00	9a6c3e8b-124a-4c95-bf49-94f903004ab6	5896af70-02cf-4b19-b4ad-c034960aefe0
ed63d167-fa9d-4368-bb22-d046acd5060a	875	88	2025	MC	1	2025-05-28	2025-07-12	ERIN BRUCE II	9465	2456168b271a821277ecf010e9b51ae1	2026-01-16 21:31:54.271+00	2026-01-16 21:31:54.271+00	12634231-f4e9-4b82-9958-26972ac58975	5e09b86c-63de-45cf-8b20-27564b31cc6b
db6897bc-1d22-4025-bee9-8a3268b4efd0	877	91	2025	MC	1	2025-05-31	2025-06-07	NANINA	7846	2b31a9f8c5141ba50feddbd64fcca6b9	2026-01-16 21:31:54.289+00	2026-01-16 21:31:54.289+00	d824e9ee-9849-4b51-9fcd-517af440e4d0	3e4aeb48-cbe9-4f57-9d59-3e0d5c3d076f
1a37c905-36f9-4a04-9098-67c6d5b34d7f	878	89	2025	MC	1	2025-05-31	2025-07-11	CAPESANTE	166	048cbb90882373513bc8fe34d742b041	2026-01-16 21:31:54.308+00	2026-01-16 21:31:54.308+00	26fe3877-c712-44bf-90da-4e8fe9d152d2	73401057-2b48-49ba-b414-e0837acf6093
1a071766-0266-4f3e-b5f6-e54dc48d8e76	881	96	2025	MC	1	2025-06-05	2025-07-06	VENTARRON 1º	174	0d10499f1623bdb8ac09cde77005c4b8	2026-01-16 21:31:54.328+00	2026-01-16 21:31:54.328+00	019284e5-0c48-42be-ae75-5706530352fd	d9c9a8ff-1c77-40cb-9d3f-0f6d5cabb62b
768f3e6f-3860-4e63-ac0d-185db934cfcb	882	99	2025	MC	1	2025-06-10	2025-06-17	CENTAURO 2000	7838	7d0b8b2c6500bff1855eec3f245cec0b	2026-01-16 21:31:54.348+00	2026-01-16 21:31:54.348+00	924f4e58-334a-4279-8770-9fb785bd3daa	d42dced3-c7c4-496c-ad9b-11047573768d
f274f540-1fa9-44c5-8d48-6ac7b5f8974f	883	63	2025	MC	1	2025-04-12	2025-04-20	MAR SUR	9471	dd83c01f02256e1548af11eb56aaa6b6	2026-01-16 21:31:54.369+00	2026-01-16 21:31:54.369+00	9eb6be1f-e0cd-43b6-876e-3303f8238252	95dfa235-56f5-4877-9ff0-74e54d569585
f995f13b-8ec7-4317-b403-de80f1a77af3	884	63	2025	MC	2	2025-04-21	2025-05-01	MAR SUR	9471	f8dfaa16eb15fdbf1b5c1d8af03c89a9	2026-01-16 21:31:54.387+00	2026-01-16 21:31:54.387+00	9eb6be1f-e0cd-43b6-876e-3303f8238252	c9747462-e6ee-4baf-b7a0-49b8df7f51cb
d4599782-2651-4f0d-bb02-25c09d2be123	885	63	2025	MC	3	2025-05-02	2025-05-10	MAR SUR	9471	91c28100b73d464187ba358dd81a7a03	2026-01-16 21:31:54.405+00	2026-01-16 21:31:54.405+00	9eb6be1f-e0cd-43b6-876e-3303f8238252	a93f27af-970c-42b2-b72b-505333b05510
b4057241-a0a5-40f8-8ee8-b45839f688d2	886	174	2024	MC	1	2024-12-29	2025-02-04	TALISMAN	7828	b58806ae7137f1a019041681d4d92256	2026-01-16 21:31:54.423+00	2026-01-16 21:31:54.423+00	\N	\N
eb729e9c-fa59-4614-9d99-a8cd7b36f4fa	887	174	2024	MC	2	2025-02-06	2025-03-11	TALISMAN	7828	8081127638b6f315b9ba1b9cdd450217	2026-01-16 21:31:54.44+00	2026-01-16 21:31:54.44+00	\N	\N
7056563a-84cc-4693-8eaf-fca034fa466b	929	101	2025	MC	1	2025-06-18	2025-06-25	SFIDA	7627	899d6dc16b8e263209f244a10ff8eb87	2026-01-16 21:31:54.458+00	2026-01-16 21:31:54.458+00	d776c633-7d6a-41a8-b83c-5996b880b452	075c5467-de40-46c2-98e4-7177146cfcb0
755b6cb0-7020-4a93-82cb-b86bd31eedee	930	103	2025	MC	1	2025-06-18	2025-06-25	FRANCO	9476	4621e5721cecaf3301e1b2c1ec3ed147	2026-01-16 21:31:54.476+00	2026-01-16 21:31:54.476+00	1797ca1f-77e5-46cf-bb03-f54cf2656699	4464a998-a87d-4dc5-a5cd-f83b88bc1b7e
598e3f70-473b-4a1a-a281-b1382533f2e8	932	106	2025	MC	1	2025-06-19	2025-06-25	SAN MATIAS	9467	214637501e37dd2de61765604873626e	2026-01-16 21:31:54.493+00	2026-01-16 21:31:54.493+00	35f620eb-aae7-4b01-9a49-83de0709e695	be31af4e-e9c2-4faf-a18f-07ec8c24953b
22b2d9b4-c185-4a7b-aa40-c76805373f67	933	99	2025	MC	2	2025-06-19	2025-06-22	CENTAURO 2000	7838	a1642b3cf1af95847e14de757e9d9b7e	2026-01-16 21:31:54.512+00	2026-01-16 21:31:54.512+00	924f4e58-334a-4279-8770-9fb785bd3daa	3c86675d-fc50-4fa1-a205-b8a4fe8fd75d
3d0580b5-0200-456a-973e-a6f64bf13864	934	98	2025	MC	1	2025-06-19	2025-07-02	VALERIA DEL ATLANTICO	7848	9fbbd34cba02d97c602cddd75c21b327	2026-01-16 21:31:54.529+00	2026-01-16 21:31:54.529+00	07d31e6d-26f8-42db-a71d-f2ba8f440b76	2a5782a6-61a7-431c-9e63-39e6296fe248
019610c2-c6c0-45d4-9c97-3c4ea3fc7880	936	104	2025	MC	1	2025-06-18	2025-06-25	SALVADOR R	2021	6b5f647b586a267f01c7cfeb097386fa	2026-01-16 21:31:54.547+00	2026-01-16 21:31:54.547+00	cc5da30e-92da-4a31-a6a9-367f12538f5d	88bdbae4-fabf-4c97-8c4c-6f4dcd8b8c76
da667d26-21fc-4352-9357-cf7a42fec899	939	99	2025	MC	3	2025-06-28	2025-07-04	CENTAURO 2000	7838	ae4fcc4f80d4766646b331c03650c46e	2026-01-16 21:31:54.564+00	2026-01-16 21:31:54.564+00	924f4e58-334a-4279-8770-9fb785bd3daa	c161a510-e646-4b38-baa0-9560137da36d
d259694e-bfea-43aa-8765-c320054359b7	998	105	2025	MC	1	2025-06-18	2025-06-25	ACRUX	9471	328d74798bbcb66ab9c3882077fc9071	2026-01-16 21:31:54.583+00	2026-01-16 21:31:54.583+00	54116fc8-0376-4e98-8e06-51d69391c0db	40b6291a-fc00-4a0a-8f58-682cf3e55350
e2c243a2-5547-44f4-a6be-f3db89057b0f	1007	106	2024	MC	1	2024-07-04	2024-07-09	ESPARDEL	9467	f551bfe0c18ae25535bf37b7af673dc5	2026-01-16 21:31:54.601+00	2026-01-16 21:31:54.601+00	\N	\N
8f4e7d03-6e6c-47b6-a5bb-563f2c512a30	1008	106	2024	MC	1	2024-07-09	2024-07-12	ESPARDEL	9467	924cc2b098fc5e52857982f8d0d1b511	2026-01-16 21:31:54.617+00	2026-01-16 21:31:54.617+00	\N	\N
368d8893-3331-45a1-a950-0587fe6fcd69	1009	106	2024	MC	1	2024-07-12	2024-07-15	ESPARDEL	9467	70f1b2e07c3740b137d06040dc246e98	2026-01-16 21:31:54.634+00	2026-01-16 21:31:54.634+00	\N	\N
b2f4542a-fd86-4755-83db-d980830d54d2	1010	106	2024	MC	1	2024-07-15	2024-07-19	ESPARDEL	9467	de7db570b00e76f03effd6fb8c06e69b	2026-01-16 21:31:54.651+00	2026-01-16 21:31:54.651+00	\N	\N
9ff6babc-4406-4204-96b8-1ab4f385856e	1011	106	2024	MC	1	2024-07-19	2024-07-23	ESPARDEL	9467	bc90a076911eec6c591a060a84ab8421	2026-01-16 21:31:54.668+00	2026-01-16 21:31:54.668+00	\N	\N
ca66d2b0-9c46-489a-af73-4631e57d6ba1	1012	106	2024	MC	1	2024-07-23	2024-07-27	ESPARDEL	9467	952afe5d9c3bb8432b135ba01e8bc26e	2026-01-16 21:31:54.685+00	2026-01-16 21:31:54.685+00	\N	\N
2896ff55-8f44-497a-8678-45b6df902067	1020	111	2025	MC	1	2025-06-27	2025-07-03	ACRUX	9476	6bf4d1b1d828a5aac256ce71407d8eae	2026-01-16 21:31:54.703+00	2026-01-16 21:31:54.703+00	75b8e60b-8e72-4110-a02a-4a9c89d3247a	86ef3408-c132-4d65-bafa-33388ee99a73
58fa5b48-b748-4d0a-b91e-87a65feaeed3	1021	101	2025	MC	1	2025-06-27	2025-07-04	SFIDA	7627	ca3ba273ef7bc55261399c9daae72cc6	2026-01-16 21:31:54.722+00	2026-01-16 21:31:54.722+00	d776c633-7d6a-41a8-b83c-5996b880b452	075c5467-de40-46c2-98e4-7177146cfcb0
57a48bdc-e5f3-4c17-97ca-114372006909	1022	112	2025	MC	1	2025-06-27	2025-07-03	NONO PASCUAL	7847	b41e7639051a83ee4069a43cd13d4efe	2026-01-16 21:31:54.739+00	2026-01-16 21:31:54.739+00	8efb8972-ce3d-4cab-9bdd-74404194c448	aad0cb5a-9398-461b-905d-e52bbbaa5175
447fcbbb-174c-4284-83b1-e46e38334f81	1024	106	2025	MC	1	2025-06-27	2025-07-04	SAN MATIAS	9467	1012e5cbad1ec854a470ce58197f2d09	2026-01-16 21:31:54.756+00	2026-01-16 21:31:54.756+00	35f620eb-aae7-4b01-9a49-83de0709e695	be31af4e-e9c2-4faf-a18f-07ec8c24953b
640c37cc-ae84-4604-a9b3-a027b2f8666b	1163	111	2025	MC	2	2025-07-04	2025-07-09	ACRUX	9476	b6c178c102d2d9ed496657811fe64e74	2026-01-16 21:31:54.774+00	2026-01-16 21:31:54.774+00	75b8e60b-8e72-4110-a02a-4a9c89d3247a	43639668-64b7-48ee-8359-17811e02b32c
17972d82-05e7-42c5-80c9-7ead22eb9fe5	1166	99	2025	MC	4	2025-07-06	2025-07-10	CENTAURO 2000	7838	2414ecad39b858a515202bbfff42095f	2026-01-16 21:31:54.791+00	2026-01-16 21:31:54.791+00	924f4e58-334a-4279-8770-9fb785bd3daa	9b6dd9d2-3e01-4921-a077-09cf5b950404
70d577bf-3c15-4fde-b3ec-310c88437616	1169	112	2025	MC	2	2025-07-03	2025-07-09	NONO PASCUAL	7847	3ea5df0d1640c3ca71ece522e6d6f7d0	2026-01-16 21:31:54.808+00	2026-01-16 21:31:54.808+00	8efb8972-ce3d-4cab-9bdd-74404194c448	\N
7f0b43d9-bec8-4fa3-86a0-56bd1c6a6372	1171	101	2025	MC	2	2025-07-04	2025-07-09	SFIDA	7627	fc0e76fb73279a898d8220ed40f1e01d	2026-01-16 21:31:54.824+00	2026-01-16 21:31:54.824+00	d776c633-7d6a-41a8-b83c-5996b880b452	b6d47884-e45b-4058-955d-1edbe0837079
39a173cc-e6ec-406c-99af-3fc06ed70a4a	1173	112	2025	MC	3	2025-07-09	2025-07-12	NONO PASCUAL	7847	47dd87f6e577efa0ea9baf9993567d62	2026-01-16 21:31:54.841+00	2026-01-16 21:31:54.841+00	8efb8972-ce3d-4cab-9bdd-74404194c448	\N
2dbe1352-1831-430a-bbcf-7cfa7d66a3ad	1200	114	2025	MC	1	2025-07-10	2025-08-29	ATLANTIC SURF III	7621	daaf9dc08ef8f1e758610bd56758ab64	2026-01-16 21:31:54.859+00	2026-01-16 21:31:54.859+00	b044574d-b57e-4aee-84f9-52dd22d71c02	691b96d9-a0e4-43b2-b23b-2fa018f6ea71
55f20706-6dde-445c-b070-f80fb43cf850	1202	117	2025	MC	1	2025-07-11	2025-07-18	MAR SUR	179	1afeeaa5fc1cfa6d94837d173044d9c1	2026-01-16 21:31:54.876+00	2026-01-16 21:31:54.876+00	530ef634-901c-438f-a0f5-4f52cab7a969	5bc15d47-2006-4379-8b9c-5f9e48dafda4
526d890a-8c63-4404-b648-bc407b6b28dc	1205	99	2025	MC	5	2025-07-12	2025-07-16	CENTAURO 2000	7838	ec9103d0582e00028952196f05bcf23d	2026-01-16 21:31:54.893+00	2026-01-16 21:31:54.893+00	924f4e58-334a-4279-8770-9fb785bd3daa	d714fd53-3f75-44aa-9dbd-74d8cd46160b
b109dc3b-d7a4-4666-ad58-7dec95d4753c	1206	112	2025	MC	4	2025-07-12	2025-07-16	NONO PASCUAL	7847	83efc4ee61fcbd374eae2aa7ea9027d7	2026-01-16 21:31:54.911+00	2026-01-16 21:31:54.911+00	8efb8972-ce3d-4cab-9bdd-74404194c448	\N
771cf0ba-48a1-4751-aa10-9df73aeb484a	1208	119	2025	MC	1	2025-07-14	2025-08-23	VERDEL	7843	b74241172329dcfdca797c6fccbceb8f	2026-01-16 21:31:54.928+00	2026-01-16 21:31:54.928+00	e27c7ba0-3f80-49f0-b52e-2c79c199401b	0be05fd0-f356-4663-94ab-7c2ca60ddea9
4ad62c54-8b1b-4444-b51f-60ae07fa20f1	1209	116	2025	MC	1	2025-07-15	2025-08-28	CAPESANTE	9480	393389182452ed41e8f2597198b07830	2026-01-16 21:31:54.945+00	2026-01-16 21:31:54.945+00	8b387d1b-5ce1-4ef9-bdc7-40c0dee441b0	3bb8ac0a-cbf8-49cb-a79e-e8ba2a5d742b
ea47e505-2f5c-45f7-b1fa-1fcf21265a12	1212	122	2025	MC	1	2025-07-17	2025-09-04	ERIN BRUCE II	9465	368ad21140a6b57113adb0fa2362739a	2026-01-16 21:31:54.964+00	2026-01-16 21:31:54.964+00	f97ca208-0509-49cf-acef-922455403fe3	b982cb17-5fe8-4071-b6fc-d9769f5018ac
03dae72c-d5ea-49b2-9881-90f3cdf35dd7	1431	133	2025	MC	2	2025-08-11	2025-08-24	SAN JUAN B	174	79c2dc03c35fcb21843d16e00b5adde9	2026-01-16 21:31:56.625+00	2026-01-16 21:31:56.625+00	b935a58b-d0c4-4d60-9acd-7ed83c647978	\N
e282c222-dbfa-48d1-9ff7-4ca0a1fd0bd8	1215	121	2025	MC	1	2025-07-18	2025-07-25	JOSE MARCELO	9461	8c445a344d735ec6487973ff7203945f	2026-01-16 21:31:54.981+00	2026-01-16 21:31:54.981+00	e2c1a54c-7a35-4aa2-b615-386313d039c5	38d4c115-acd6-49b5-932f-72c5a24f61bb
f3feadd8-c9a9-4135-8236-8b56dff84a06	1216	128	2025	MC	1	2025-07-19	2025-08-23	ITXAS LUR	9474	01b718a21b092c392cd538b690d5c416	2026-01-16 21:31:54.999+00	2026-01-16 21:31:54.999+00	2bde3e6b-fcb6-43ef-a637-7f1e075ae3b7	728ab33b-12c6-4c6b-b255-b8745590f080
60336502-8672-40e7-a59b-0950ea9d05f0	1218	124	2025	MC	1	2025-07-19	2025-08-19	GEMINIS	7729	e3103e2980580268478f048b2ae2000a	2026-01-16 21:31:55.017+00	2026-01-16 21:31:55.017+00	a0aeb842-95d6-413d-9ccd-8f67cbc51b38	a89824c6-8f7f-49e0-9393-a4361b717836
4977651a-5e07-446b-a012-4c265a19e2b2	1221	110	2025	MC	1	2025-06-27	2025-07-03	FRANCO	2021	3a75e543da58235669792f823adbf8db	2026-01-16 21:31:55.037+00	2026-01-16 21:31:55.037+00	de7f7699-c09a-4cf4-bceb-3c8fa0eef107	66b0f599-8550-4a00-9875-643761430c4f
45159970-e849-46bf-b4a1-55777baf9ce1	1222	110	2025	MC	2	2025-07-04	2025-07-10	FRANCO	2021	9ee1ce8f2ef5b6d6d3af0a4ec62f9bc3	2026-01-16 21:31:55.055+00	2026-01-16 21:31:55.055+00	de7f7699-c09a-4cf4-bceb-3c8fa0eef107	\N
7a6b5916-6a6f-4e6c-ac10-b10b2ff3a81b	1223	110	2025	MC	3	2025-07-11	2025-07-16	FRANCO	2021	43063315a02002f16d3d6b52371fb448	2026-01-16 21:31:55.073+00	2026-01-16 21:31:55.073+00	de7f7699-c09a-4cf4-bceb-3c8fa0eef107	\N
82028770-82ff-4b48-b92d-18dab5b77395	1224	110	2025	MC	4	2025-07-17	2025-07-20	FRANCO	2021	ecf33d19b2245a8ec56cd8512b0546b8	2026-01-16 21:31:55.09+00	2026-01-16 21:31:55.09+00	de7f7699-c09a-4cf4-bceb-3c8fa0eef107	\N
7e7fd0f9-0ae3-4457-b3dd-2551aaf5debf	1225	94	2025	MC	1	2025-06-13	2025-06-20	UR ERTZA	186	de1742ccb8918658a33bfceea78f3aeb	2026-01-16 21:31:55.109+00	2026-01-16 21:31:55.109+00	7b5ef1bd-4eb4-489c-976b-477525f660a5	eb7bc134-8265-4238-bbcf-75a61b04ef8f
e0bcde9b-5845-401a-a8ad-e85ebe72e05c	1226	94	2025	MC	2	2025-06-25	2025-07-05	UR ERTZA	186	36eba531f29e3a50de2773b9fa2e644b	2026-01-16 21:31:55.128+00	2026-01-16 21:31:55.128+00	7b5ef1bd-4eb4-489c-976b-477525f660a5	8653764f-7fc9-4deb-b3f5-80f40aef1e9e
8cef38d6-4150-4822-9ea6-5197db4450eb	1227	94	2025	MC	3	2025-07-08	2025-07-16	UR ERTZA	186	b515dcbfcaf4bd6855c7ff1db6b3c08d	2026-01-16 21:31:55.146+00	2026-01-16 21:31:55.146+00	7b5ef1bd-4eb4-489c-976b-477525f660a5	f896387b-1381-4e0a-9088-7fb7a0d4140b
788d6e8d-f7d6-4d15-9bb5-1c8308d7d245	1228	94	2025	MC	4	2025-07-19	2025-07-25	UR ERTZA	186	e5d33722b67a9fef9ecedf4a18e7efaa	2026-01-16 21:31:55.164+00	2026-01-16 21:31:55.164+00	7b5ef1bd-4eb4-489c-976b-477525f660a5	f58cb791-22f4-4e10-a9f9-761e6b0657b6
3500da54-1a93-489a-9517-5d17d0c4bcdc	1230	117	2025	MC	2	2025-07-19	2025-07-29	MAR SUR	179	d1bf76e8c679eb07120e3e96ccd828c1	2026-01-16 21:31:55.183+00	2026-01-16 21:31:55.183+00	530ef634-901c-438f-a0f5-4f52cab7a969	\N
a4bb4310-df47-4654-a23d-8ea606a34b03	1238	129	2025	MC	1	2025-07-23	2025-07-30	GRACIELA I	7847	85de947575e5bb784dfddca3a66c685f	2026-01-16 21:31:55.202+00	2026-01-16 21:31:55.202+00	abb71f7e-66c2-4fad-a06c-023f67a1485f	4508cbf2-577e-4f73-a8f4-4219d0ed6198
b10f1520-1c69-413b-b04a-d3eceda37124	1247	47	2025	MC	1	2025-03-13	2025-04-14	DUKAT	7855	4a3fc80da4598013a2635850fadaac1b	2026-01-16 21:31:55.221+00	2026-01-16 21:31:55.221+00	f772b482-10e8-4dbd-b54d-18ad99ee8da4	db8f7163-5186-4c49-ab66-9d7a94545a48
0f1f46a0-e9a2-4bac-8651-e478b1916188	1248	47	2025	MC	2	2025-04-16	2025-04-19	DUKAT	7855	c04d244e733118f8f749f430bf40edb2	2026-01-16 21:31:55.238+00	2026-01-16 21:31:55.238+00	f772b482-10e8-4dbd-b54d-18ad99ee8da4	\N
2a5f40b7-83ee-4303-8baa-b0ba6362e426	1252	137	2025	MC	1	2025-07-30	2025-08-04	LUCA SANTINO	9467	464df37245eb96f23c9987226cda2de3	2026-01-16 21:31:55.256+00	2026-01-16 21:31:55.256+00	7c0f420c-18e3-4c11-a8ee-688eaba8c013	4081428c-48ed-4bdf-9c09-d252db487ce4
742e4fd1-4b5d-447f-a572-2a5a000d81c0	1253	117	2025	MC	3	2025-07-30	2025-08-06	MAR SUR	179	8e12bb117527804d9ab384003aa06cf7	2026-01-16 21:31:55.273+00	2026-01-16 21:31:55.273+00	530ef634-901c-438f-a0f5-4f52cab7a969	\N
f79e2788-6f69-4f90-840b-5eabcbdb2094	1254	129	2025	MC	2	2025-07-31	2025-08-07	GRACIELA I	7847	a917c950348be1f47586b90be21f3c05	2026-01-16 21:31:55.29+00	2026-01-16 21:31:55.29+00	abb71f7e-66c2-4fad-a06c-023f67a1485f	\N
1514e630-c019-43c0-a0f8-03f701b03c63	1269	134	2025	MC	4	2025-08-03	2025-08-07	CENTAURO 2000	7841	c71362c5f0ecf891beb63099d5624ea4	2026-01-16 21:31:55.306+00	2026-01-16 21:31:55.306+00	73edad49-21e4-4680-b848-8cc046436440	\N
0cdb936a-f811-44c2-a704-5ff332251840	1288	134	2025	MC	1	2025-07-25	2025-07-25	CENTAURO 2000	7841	9bf3a45d3aefee36abbdad0aecaed7dc	2026-01-16 21:31:55.324+00	2026-01-16 21:31:55.324+00	73edad49-21e4-4680-b848-8cc046436440	6eede3ee-d055-41eb-b1ff-8a43ee5fcc42
d0be45e5-964b-4897-823e-34cf0c23c9e3	1289	134	2025	MC	2	2025-07-25	2025-07-29	CENTAURO 2000	7841	ff896888941a6ca8dd02c3cf951e46d5	2026-01-16 21:31:55.341+00	2026-01-16 21:31:55.341+00	73edad49-21e4-4680-b848-8cc046436440	\N
75c84244-74e5-49cc-9f51-2da8697b39f4	1290	134	2025	MC	3	2025-07-30	2025-08-03	CENTAURO 2000	7841	18979186f567b706a5087a208d891cb1	2026-01-16 21:31:55.358+00	2026-01-16 21:31:55.358+00	73edad49-21e4-4680-b848-8cc046436440	\N
3181faf0-be75-47dc-9735-7b193a582612	1291	118	2025	MC	1	2025-07-13	2025-07-17	DON SANTIAGO	172	c85b6b194e5e6dd0546214cb79d5691f	2026-01-16 21:31:55.375+00	2026-01-16 21:31:55.375+00	f2d0a1d7-4867-4b46-befe-e7aca3ef945b	a4826e22-f637-4417-90ff-41363b4c9cef
8fbbd521-4f21-4e67-ba32-86a51a0a12bc	1292	118	2025	MC	2	2025-07-17	2025-07-21	DON SANTIAGO	172	445d81031f25c06225c4ae186ca25ecd	2026-01-16 21:31:55.391+00	2026-01-16 21:31:55.391+00	f2d0a1d7-4867-4b46-befe-e7aca3ef945b	\N
b4db14c4-ecab-4d1d-990e-8fedc8de8e18	1293	118	2025	MC	3	2025-07-21	2025-07-24	DON SANTIAGO	172	295f28b16199be319c2d50b2073f075a	2026-01-16 21:31:55.409+00	2026-01-16 21:31:55.409+00	f2d0a1d7-4867-4b46-befe-e7aca3ef945b	\N
49984027-2d3a-434f-a425-f622902352ae	1294	118	2025	MC	4	2025-07-25	2025-07-29	DON SANTIAGO	172	8396d216b0d9c8688e553e856dbe41c8	2026-01-16 21:31:55.425+00	2026-01-16 21:31:55.425+00	f2d0a1d7-4867-4b46-befe-e7aca3ef945b	\N
baf716f5-4026-4535-808a-ce4c18693ba2	1295	118	2025	MC	5	2025-07-30	2025-08-03	DON SANTIAGO	172	70f5de485c58b8f20ab8d24fe00df79d	2026-01-16 21:31:55.442+00	2026-01-16 21:31:55.442+00	f2d0a1d7-4867-4b46-befe-e7aca3ef945b	\N
2f84f42c-3968-476b-a8f0-2b2b59974d1d	1297	138	2025	MC	1	2025-08-04	2025-08-14	DESTINY	7848	dc3de78d5f5935d3a93e78889bc1a04e	2026-01-16 21:31:55.458+00	2026-01-16 21:31:55.458+00	c54a944e-148b-4d71-9003-cf1a602eea67	7c3e9ec2-3ac1-48d7-9f44-288bca2d4444
11f2f44e-5c1a-48fe-a361-826ff4695c73	1300	90	2025	MC	1	2025-05-26	2025-06-03	MAR SUR	9471	ceb3de54d27e8d5857e439e973319dbd	2026-01-16 21:31:55.475+00	2026-01-16 21:31:55.475+00	ec6c04a5-0942-4932-bf6d-e8f11745ad45	37f4e6eb-a0cc-4c14-a624-c49724465951
54d219a4-c3d8-4716-bfb6-51d56a05af1a	1301	90	2025	MC	2	2025-06-05	2025-06-11	MAR SUR	9471	1833d4fada5c6101586e34768b660772	2026-01-16 21:31:55.492+00	2026-01-16 21:31:55.492+00	ec6c04a5-0942-4932-bf6d-e8f11745ad45	1fad73a6-4b80-4eed-abcc-c94722cf67dc
3d2bc07c-d846-4743-961e-b4db1098313a	1302	102	2025	MC	1	2025-06-17	2025-06-28	MAR SUR	179	fd1196cfe33e05846f3e58893ba5f956	2026-01-16 21:31:55.509+00	2026-01-16 21:31:55.509+00	8c1b9863-f3de-4725-8100-d31306ab7a9f	5bf48722-339a-4141-ae6d-c911ae67c85c
816fac66-a5d0-41e1-9d11-056d28545fb5	1303	102	2025	MC	2	2025-06-28	2025-07-10	MAR SUR	179	7e4d2a2d03a27963f18972cfab49f2e4	2026-01-16 21:31:55.527+00	2026-01-16 21:31:55.527+00	8c1b9863-f3de-4725-8100-d31306ab7a9f	\N
e4dc50f8-d0a5-4fa9-9f0a-107b1f941fab	1304	141	2025	MC	1	2025-08-05	2025-08-13	ARBUMASA XV	9471	b144f31b3531788ffc94b7baf9c260f2	2026-01-16 21:31:55.545+00	2026-01-16 21:31:55.545+00	a1964669-a378-41ef-a0ce-2da11a1fb8a8	67e9c2f5-6d4e-4e5f-86b9-148aa3592da2
b4970770-7862-426a-af25-f9bbc2e41d4d	1306	113	2025	MC	1	2025-07-12	2025-07-14	ATREVIDO	7796	031cdf0498dd34ed28327b7181a4d222	2026-01-16 21:31:55.562+00	2026-01-16 21:31:55.562+00	1b88cb74-d1ee-4175-82bd-133e4851a9c0	7f301173-684e-453f-85af-20ed1319e77b
ddd9abb6-dfff-4901-9f12-b9449d58439a	1307	113	2025	MC	2	2025-07-18	2025-07-23	ATREVIDO	7796	ab109d443fa286aaa18282264ee36710	2026-01-16 21:31:55.58+00	2026-01-16 21:31:55.58+00	1b88cb74-d1ee-4175-82bd-133e4851a9c0	3d7d3823-eacb-45eb-be45-fa78c0367887
38e2fc65-8c3e-4055-b99b-ea845cfbf199	1308	113	2025	MC	3	2025-07-27	2025-08-01	ATREVIDO	7796	fbf8d0019ff821f14374ba88ad72ff0f	2026-01-16 21:31:55.598+00	2026-01-16 21:31:55.598+00	1b88cb74-d1ee-4175-82bd-133e4851a9c0	e9c54d4c-5e00-484b-a840-c21c54d4dcc1
f25e3f32-2f59-476d-ad83-ece23947bf16	1311	117	2025	MC	4	2025-08-07	2025-08-13	MAR SUR	179	6982b8e1686d94d723e24e57b43c0524	2026-01-16 21:31:55.614+00	2026-01-16 21:31:55.614+00	530ef634-901c-438f-a0f5-4f52cab7a969	\N
aac5f885-1285-424a-87a1-7164889e84da	1312	129	2025	MC	3	2025-08-08	2025-08-13	GRACIELA I	7847	55dbc406a1c6d6eb3e99173ed8337170	2026-01-16 21:31:55.632+00	2026-01-16 21:31:55.632+00	abb71f7e-66c2-4fad-a06c-023f67a1485f	\N
8fb46f23-03a1-418b-91c6-547a6b2436c4	1315	134	2025	MC	5	2025-08-08	2025-08-12	CENTAURO 2000	7841	bc61ff66ea19eea2c35cdd3fe9ed8a7b	2026-01-16 21:31:55.65+00	2026-01-16 21:31:55.65+00	73edad49-21e4-4680-b848-8cc046436440	\N
54333880-384e-4db9-aa6b-2f2b642f019c	1317	140	2025	MC	1	2025-08-05	2025-08-13	ARBUMASA XIX	2021	d2744d0a88f98d2d1fe02cb439db0ea1	2026-01-16 21:31:55.667+00	2026-01-16 21:31:55.667+00	971cd500-4f71-46d7-9b36-5cd570dd538e	25566314-ab8b-4d36-b3b9-7012e1830136
b7f5f1a5-f92b-4022-9459-80bf2d937551	1318	121	2025	MC	3	2025-08-11	2025-08-17	JOSE MARCELO	9461	fe92cb09f764b7bece19a75ac30841cb	2026-01-16 21:31:55.685+00	2026-01-16 21:31:55.685+00	e2c1a54c-7a35-4aa2-b615-386313d039c5	0fad13a0-d866-4c7a-89a4-3a2fc22a8d71
cd3bd610-3444-496c-b46d-cadd076c78e4	1323	134	2025	MC	6	2025-08-12	2025-08-15	CENTAURO 2000	7841	e8ffa4ada04266c326384eb86aa49599	2026-01-16 21:31:55.701+00	2026-01-16 21:31:55.701+00	73edad49-21e4-4680-b848-8cc046436440	\N
46c4babc-1ee8-419b-b96e-8f671c1ebeac	1331	8	2025	MC	1	2025-01-11	2025-01-19	VIRGEN MARIA	7767	a65c05840c3b0fd9f23fe5d1f9c33084	2026-01-16 21:31:55.718+00	2026-01-16 21:31:55.718+00	8ed5e8f3-27ff-46bf-b7b1-aba4bf533087	9530471e-a089-440c-bf93-e06b7e7b4b75
f0905b86-da47-49c6-ada8-19c9718d12d0	1332	8	2025	MC	2	2025-01-22	2025-01-29	VIRGEN MARIA	7767	03be9cd40a28077261d2b88bd6c1fcdd	2026-01-16 21:31:55.734+00	2026-01-16 21:31:55.734+00	8ed5e8f3-27ff-46bf-b7b1-aba4bf533087	bcf49c27-bc7e-48ca-8965-cd370c6a620b
b4089ece-1f17-440f-afe2-dd9f53f69445	1333	8	2025	MC	3	2025-01-31	2025-02-11	VIRGEN MARIA	7767	83954fc71c57c6abdfac25dd51ba0722	2026-01-16 21:31:55.754+00	2026-01-16 21:31:55.754+00	8ed5e8f3-27ff-46bf-b7b1-aba4bf533087	1737535b-682b-48d8-9393-7a9bbe0018f8
eb07c331-21e8-4494-9f8b-8437030e7965	1334	15	2025	MC	1	2025-01-12	2025-01-19	ATREVIDO	174	3a15c3969d8d64bcf76a642c0d099dfb	2026-01-16 21:31:55.771+00	2026-01-16 21:31:55.771+00	f547dedc-96f2-4ad3-86da-92a1373f5109	28796850-9a35-415e-97e1-a9b0b27c3379
ba8e14a1-546a-4c47-bf87-2f35f7ca97f2	1335	15	2025	MC	2	2025-01-20	2025-01-26	ATREVIDO	174	ebbbe6006e519224fc773cca83321154	2026-01-16 21:31:55.789+00	2026-01-16 21:31:55.789+00	f547dedc-96f2-4ad3-86da-92a1373f5109	9efd8fe7-233a-4488-ac04-1661bf77f23b
cc1d6505-2d54-45a4-aa1e-5ac896be900b	1336	15	2025	MC	3	2025-01-28	2025-02-02	ATREVIDO	174	ef2e27e68c1cb6031707fdfc326765fc	2026-01-16 21:31:55.806+00	2026-01-16 21:31:55.806+00	f547dedc-96f2-4ad3-86da-92a1373f5109	06a34e5a-5c0f-4696-a80a-47669daebeab
e01b18c0-4f59-4379-86a3-0b9a4c991c45	1337	15	2025	MC	4	2025-02-03	2025-02-12	ATREVIDO	174	e63f1cf5e255b7e585e186df5056873a	2026-01-16 21:31:55.822+00	2026-01-16 21:31:55.822+00	f547dedc-96f2-4ad3-86da-92a1373f5109	db058076-c652-4623-8c27-24a36499ae1f
f212fcb4-b7ae-4c93-9720-25ca88b3ae63	1338	65	2025	MC	1	2025-04-21	2025-04-29	ANITA	9476	a0dbe1b292eba18deb041388f5f282ed	2026-01-16 21:31:55.839+00	2026-01-16 21:31:55.839+00	a7b198f6-2669-4367-8dca-b1cf27ac4f51	9e2dc75a-115d-420e-b8f4-4d7cd22944ad
e39bd7f1-4cd3-40e7-bb31-314dfe4bf920	1339	65	2025	MC	2	2025-05-02	2025-05-10	ANITA	9476	559a5ce306cdce8bb8702bd707473f79	2026-01-16 21:31:55.856+00	2026-01-16 21:31:55.856+00	a7b198f6-2669-4367-8dca-b1cf27ac4f51	b722095c-3420-49fc-835b-c4dc6196be40
d37cb814-cf61-43b3-b553-7d209fba4505	1340	65	2025	MC	3	2025-05-14	2025-05-26	ANITA	9476	3d07b49f9432a392a54ce4de19c189db	2026-01-16 21:31:55.873+00	2026-01-16 21:31:55.873+00	a7b198f6-2669-4367-8dca-b1cf27ac4f51	97d36b33-a691-4585-8483-80885c723e14
d38b7903-affa-46a7-8266-ecd7c86a6a37	1341	66	2025	MC	1	2025-05-02	2025-05-09	FEIXA	7729	fb0ecf449d1944f5ca0e755710997868	2026-01-16 21:31:55.889+00	2026-01-16 21:31:55.889+00	12560a8d-1d4d-4c20-a734-8ee0ff62a0e6	d8234ba3-6d11-4cf4-ab12-47a3992a9982
f146c77a-b615-413e-97bf-0414907d279f	1343	108	2025	MC	1	2025-06-25	2025-07-03	ANITA	7842	69c2ecef1d90f1607373d7d5c3a2a25c	2026-01-16 21:31:55.905+00	2026-01-16 21:31:55.905+00	affe4a6b-5ae3-4188-b88b-82cb7d46e835	1fd3e31a-1807-42f5-9d8c-4573497402d8
6fe614b2-c9e7-4225-bf3a-7028f1f50633	1344	108	2025	MC	2	2025-07-05	2025-07-11	ANITA	7842	81dd368702cd07850d05d889ace8e795	2026-01-16 21:31:55.924+00	2026-01-16 21:31:55.924+00	affe4a6b-5ae3-4188-b88b-82cb7d46e835	50243639-6c86-4b71-8ecb-650853120909
052a4c3f-831c-4e07-a77b-c24d83fb79ab	1345	108	2025	MC	3	2025-07-20	2025-07-26	ANITA	7842	a3108476eca3746c5eb78df2011546ae	2026-01-16 21:31:55.94+00	2026-01-16 21:31:55.94+00	affe4a6b-5ae3-4188-b88b-82cb7d46e835	84ceae64-77e7-4acf-9146-e20930822cf9
06b873f5-65b0-4982-af2d-b80749c2a515	1346	108	2025	MC	4	2025-07-28	2025-08-04	ANITA	7842	5729d6ad1dd3ab521e9a72a6b01b7a81	2026-01-16 21:31:55.957+00	2026-01-16 21:31:55.957+00	affe4a6b-5ae3-4188-b88b-82cb7d46e835	edde090c-9ecb-4ce8-8575-3cbe50426215
82133bc7-cc42-4954-ab55-76e0e2531141	1347	95	2025	MC	1	2025-06-05	2025-07-06	GEMINIS	7729	0c114a6276e70079b687de9d99c3ca6d	2026-01-16 21:31:55.974+00	2026-01-16 21:31:55.974+00	5ae0c35c-5c3b-4fae-b112-b5ae6d8217eb	1e8691fa-31d0-4ba9-9144-7b2880a2384b
243501d2-31d9-4169-a6c6-3bf05c59c680	1349	117	2025	MC	5	2025-08-14	2025-08-20	MAR SUR	179	8612ee7c3046ce0fefa53c18b9f5c80f	2026-01-16 21:31:55.991+00	2026-01-16 21:31:55.991+00	530ef634-901c-438f-a0f5-4f52cab7a969	\N
909d4fe9-f695-4640-9bfe-c1e1c51cba7e	1351	129	2025	MC	4	2025-08-14	2025-08-21	GRACIELA I	7847	6069c187a8246ccd839eaedcccadf2d3	2026-01-16 21:31:56.009+00	2026-01-16 21:31:56.009+00	abb71f7e-66c2-4fad-a06c-023f67a1485f	\N
eec56ed7-7bd7-4f84-a053-0fad698db8bd	1361	134	2025	MC	7	2025-08-16	2025-08-20	CENTAURO 2000	7841	006c91eca8277efded5bf11dbb9feb90	2026-01-16 21:31:56.026+00	2026-01-16 21:31:56.026+00	73edad49-21e4-4680-b848-8cc046436440	\N
a9988993-34f1-4952-bfde-0412c108e86a	1373	121	2025	MC	1	2025-07-26	2025-08-02	JOSE MARCELO	9461	1a1583a3a182e8b51c8bcdb10fc6cbcf	2026-01-16 21:31:56.044+00	2026-01-16 21:31:56.044+00	e2c1a54c-7a35-4aa2-b615-386313d039c5	38d4c115-acd6-49b5-932f-72c5a24f61bb
6d443cfd-edfb-4c9b-ab50-70a7a3411320	1374	121	2025	MC	2	2025-08-04	2025-08-10	JOSE MARCELO	9461	a1df2f4b4a9ce0cd4c248fd51bb903d9	2026-01-16 21:31:56.061+00	2026-01-16 21:31:56.061+00	e2c1a54c-7a35-4aa2-b615-386313d039c5	5ee48ec4-e5d6-4180-8559-500e05c5bc9f
fd9af8db-b9b3-436e-a240-8fc048c04079	1375	148	2025	MC	1	2025-08-20	2025-08-30	MARIA ALEJANDRA 1º	7627	196c38216875ab3ddd7679e7426bd121	2026-01-16 21:31:56.078+00	2026-01-16 21:31:56.078+00	40e14f88-15d9-43e3-aaa1-a0cb6c1479d5	476604d9-1cfc-4099-8383-4f84c52d21b2
765e163b-6dd2-4626-b78e-b2b4c2f12236	1379	129	2025	MC	5	2025-08-22	2025-08-28	GRACIELA I	7847	223cc54914bab718ae74c68540a37da5	2026-01-16 21:31:56.095+00	2026-01-16 21:31:56.095+00	abb71f7e-66c2-4fad-a06c-023f67a1485f	\N
fab31687-eb3c-4079-9917-4dc649569090	1380	147	2025	MC	1	2025-08-23	2025-09-22	GEMINIS	7853	56601defff6254758aac0af6c2a2413b	2026-01-16 21:31:56.112+00	2026-01-16 21:31:56.112+00	0f59cfcd-2244-4399-a8ef-14c52bffef07	bd85f525-5ef2-452d-abe8-0725ae287e8d
d65a4fa6-74dc-47e9-b766-90e0978e5fb3	1382	140	2025	MC	2	2025-08-14	2025-08-22	ARBUMASA XIX	2021	34cdda21f3448d6c71144363a2289804	2026-01-16 21:31:56.131+00	2026-01-16 21:31:56.131+00	971cd500-4f71-46d7-9b36-5cd570dd538e	\N
2d63ebf4-be8d-48bd-829e-1143fc5090ed	1384	138	2025	MC	2	2025-08-15	2025-08-26	DESTINY	7848	15b2df56af75385b4db524b648a8f98a	2026-01-16 21:31:56.147+00	2026-01-16 21:31:56.147+00	c54a944e-148b-4d71-9003-cf1a602eea67	dbfe29a0-3379-4e2f-9456-999a62fc652b
e0c556cc-bba6-4de1-bc53-637afc0f578e	1385	139	2025	MC	1	2025-08-03	2025-08-07	DON SANTIAGO	7838	58b3f3150e7f0f88d9343aad651346e5	2026-01-16 21:31:56.165+00	2026-01-16 21:31:56.165+00	bc922ab1-8a89-4fbd-8ff0-b92cb23f7ee3	cc0d0588-eafd-419e-89de-c5ae023c1286
c2b50626-7369-4bdb-9e49-d83e1435da82	1386	139	2025	MC	2	2025-08-08	2025-08-12	DON SANTIAGO	7838	14c2d0bf9c62b4c4b2e351c43933a848	2026-01-16 21:31:56.183+00	2026-01-16 21:31:56.183+00	bc922ab1-8a89-4fbd-8ff0-b92cb23f7ee3	\N
170a36eb-7bf4-4580-acd3-2f8ff26cfdf1	1387	139	2025	MC	3	2025-08-12	2025-08-15	DON SANTIAGO	7838	5688a5d0d622092e82761cd0992f5690	2026-01-16 21:31:56.202+00	2026-01-16 21:31:56.202+00	bc922ab1-8a89-4fbd-8ff0-b92cb23f7ee3	\N
f8859247-2c97-4ee9-8525-7fec44977a9c	1388	139	2025	MC	4	2025-08-15	2025-08-18	DON SANTIAGO	7838	f93abd45050a0016f0a66af17f259897	2026-01-16 21:31:56.221+00	2026-01-16 21:31:56.221+00	bc922ab1-8a89-4fbd-8ff0-b92cb23f7ee3	\N
befd4d55-d725-490d-aca0-7af1f4f1cdca	1389	139	2025	MC	5	2025-08-18	2025-08-22	DON SANTIAGO	7838	4e94619876ff062fd69849cd9cab4c2a	2026-01-16 21:31:56.239+00	2026-01-16 21:31:56.239+00	bc922ab1-8a89-4fbd-8ff0-b92cb23f7ee3	\N
435f6cdd-8e62-496d-8001-1adef64663c1	1392	149	2025	MC	1	2025-08-21	2025-09-02	XEITOSIÑO	4840	251b1c91e9eef00bee8126acf8a27dd7	2026-01-16 21:31:56.257+00	2026-01-16 21:31:56.257+00	92f748e6-da70-4fd1-894d-89134404ab5a	ce3bf09e-b850-48e1-a7fc-e17579c5f7af
29172817-9f01-4d83-b160-d88d69f3713a	1401	151	2025	MC	1	2025-08-30	2025-08-30	CERES	7796	41b48a4f11ce7060ba7aad5293b35ca5	2026-01-16 21:31:56.273+00	2026-01-16 21:31:56.273+00	de64d728-4a6c-4b29-a242-4165b7338f2d	\N
6139112c-25ee-4c9f-a15a-d92416f5fab3	1402	153	2025	MC	1	2025-08-30	2025-10-06	ITXAS LUR	7726	45157204c3a0adfb3600d8efa040c8da	2026-01-16 21:31:56.29+00	2026-01-16 21:31:56.29+00	4aeeeb58-99d3-490a-8434-be89120f4762	65500d82-fb05-4548-8e3b-c2a87b8b4c7c
3fabc1cc-e8e1-4c0a-a19e-f56e3ad7fdb1	1403	152	2025	MC	1	2025-09-01	2025-09-12	FEDERICO C	9471	92e7fc8fa829f2499b9cb17110827f2c	2026-01-16 21:31:56.307+00	2026-01-16 21:31:56.307+00	a07196ce-0524-4b05-b36d-04450033c584	615f49e5-a36f-43d1-a7b5-62db9d6c7dff
9611ac59-0af7-4d2a-86d3-d00951e43727	1409	138	2025	MC	3	2025-08-28	2025-09-05	DESTINY	7848	21326decd69b7708796ea1171896eca6	2026-01-16 21:31:56.323+00	2026-01-16 21:31:56.323+00	c54a944e-148b-4d71-9003-cf1a602eea67	\N
3703b7bc-2eb8-4df8-980b-95ef52767067	1411	143	2025	MC	2	2025-09-03	2025-09-22	NINA	9467	fccb4fb438b27dc6a6e0d01fff2f453e	2026-01-16 21:31:56.34+00	2026-01-16 21:31:56.34+00	2807c518-ee18-46b9-be03-54ee4d5ed4f9	\N
632c3dec-e9b5-4a1e-a371-66c7d0c2f119	1412	143	2025	MC	3	2025-08-20	2025-09-01	NINA	9467	78dea357033a02b5293c663c55cad890	2026-01-16 21:31:56.357+00	2026-01-16 21:31:56.357+00	2807c518-ee18-46b9-be03-54ee4d5ed4f9	\N
5705ed97-a026-4412-9296-518a2b44c442	1413	144	2025	MC	1	2025-08-08	2025-08-20	JOSE AMERICO	73	8ff77fc52281f4d5f4c6394fa5bc24f0	2026-01-16 21:31:56.374+00	2026-01-16 21:31:56.374+00	d9f9aaf9-d19d-4317-8719-29ae41e9cd59	e99ef4de-38b1-49e0-b81f-8542b642138d
1c1dbe05-8d7f-4580-9da8-9b2bf2cbca5b	1414	144	2025	MC	2	2025-08-21	2025-09-03	JOSE AMERICO	73	1b9f67a778d0fa54122762ade886a866	2026-01-16 21:31:56.392+00	2026-01-16 21:31:56.392+00	d9f9aaf9-d19d-4317-8719-29ae41e9cd59	\N
134a9325-a998-4d4b-ad40-85d70df12ba8	1415	144	2025	MC	3	2025-09-04	2025-09-21	JOSE AMERICO	73	b644928cd1985a4d99fdb17dd4aee568	2026-01-16 21:31:56.411+00	2026-01-16 21:31:56.411+00	d9f9aaf9-d19d-4317-8719-29ae41e9cd59	\N
0927a5dc-04f5-4b01-9791-19fa8081404b	1418	142	2025	MC	1	2025-08-07	2025-08-14	VIRGEN MARIA	7844	654218ff4cf449eda5adbc14a4e67cb5	2026-01-16 21:31:56.43+00	2026-01-16 21:31:56.43+00	d3cd4728-744f-438e-8ec7-cc2f2dc6571e	f44f68a4-e69f-4d0d-9449-2895511b8341
71c29aa9-63b3-4052-8c41-a05fe8586cf2	1419	142	2025	MC	2	2025-08-20	2025-08-27	VIRGEN MARIA	7844	953fa0a950d3c124d90a1cb8fdf6ee1c	2026-01-16 21:31:56.448+00	2026-01-16 21:31:56.448+00	d3cd4728-744f-438e-8ec7-cc2f2dc6571e	2c2d2c86-3df6-4f5a-9ab5-67163b97fbb9
614bf398-eca4-431c-8585-8056051994e5	1420	142	2025	MC	3	2025-08-29	2025-09-05	VIRGEN MARIA	7844	d8ca9b9a3fd1c51ba0c72a02e2300355	2026-01-16 21:31:56.469+00	2026-01-16 21:31:56.469+00	d3cd4728-744f-438e-8ec7-cc2f2dc6571e	c36e4b13-86ff-4cbd-9381-e8587ccd68df
736feea5-4f15-42dd-9569-db58d76a426b	1421	154	2025	MC	1	2025-09-06	2025-09-15	ARGENOVA XXII	9474	2894e1b4d419ea29bb904e421c32c5e0	2026-01-16 21:31:56.486+00	2026-01-16 21:31:56.486+00	fbaf8efe-0c9a-4b2d-8b80-ca8a7f3a1f15	43dde686-8247-4c1d-97a7-ac08708c0ed9
99733227-68c1-421f-b155-0651652ffc73	1422	132	2025	MC	1	2025-07-24	2025-08-09	PEDRITO	7798	4032a30acb06d9ec19904a0c76bfcc18	2026-01-16 21:31:56.505+00	2026-01-16 21:31:56.505+00	8f6e1c1b-d8be-491e-82e1-1ced1843b47a	941828bd-77da-4cc7-915b-3767e72ce94c
fcb55f2d-26ca-42c1-a89f-702682f9ed3e	1423	132	2025	MC	2	2025-08-12	2025-08-12	PEDRITO	7798	0f00b0f2788ccb97ef652a9f81740436	2026-01-16 21:31:56.522+00	2026-01-16 21:31:56.522+00	8f6e1c1b-d8be-491e-82e1-1ced1843b47a	\N
d8298097-56c9-44ef-903f-b52e48818e6d	1424	132	2025	MC	3	2025-08-13	2025-08-26	PEDRITO	7798	dc0d90ce41a9131061a9a80d0de0648d	2026-01-16 21:31:56.539+00	2026-01-16 21:31:56.539+00	8f6e1c1b-d8be-491e-82e1-1ced1843b47a	\N
d9dd5060-de1b-4f09-9176-2ca9a4808f05	1425	132	2025	MC	4	2025-08-26	2025-09-07	PEDRITO	7798	2d2d494ad63ae192eb9a6b12078c4a24	2026-01-16 21:31:56.555+00	2026-01-16 21:31:56.555+00	8f6e1c1b-d8be-491e-82e1-1ced1843b47a	\N
de0093e7-35fe-4666-8907-5072498390e5	1428	146	2025	MC	1	2025-08-17	2025-08-25	ANDRES JORGE	186	c8653c0a49924aad43124c4b877bc833	2026-01-16 21:31:56.575+00	2026-01-16 21:31:56.575+00	0d9d50b5-0b9b-459c-91bc-1830f753b625	ec1cdbaf-7576-471b-b080-fe26d89b42e1
a32665ad-c62c-4fd0-8c47-6a9f20f0369a	1429	146	2025	MC	2	2025-08-28	2025-09-06	ANDRES JORGE	186	d1e1611d95c88f6325bc77c0584cebd5	2026-01-16 21:31:56.593+00	2026-01-16 21:31:56.593+00	0d9d50b5-0b9b-459c-91bc-1830f753b625	ed221fc3-13d2-46db-b8a9-149a40f088a5
98b35b44-0724-42b3-92a2-398de456d928	1430	133	2025	MC	1	2025-07-23	2025-08-09	SAN JUAN B	174	ec5c028d3e89b51dfc158c6fd8f29e31	2026-01-16 21:31:56.609+00	2026-01-16 21:31:56.609+00	b935a58b-d0c4-4d60-9acd-7ed83c647978	5a96abb2-0f95-49f7-8468-10dbf9188788
e294981f-59f7-4d1f-9f37-0287bf318302	1432	133	2025	MC	3	2025-08-25	2025-09-07	SAN JUAN B	174	69bea3f7950774b0388e1ab401db66cc	2026-01-16 21:31:56.642+00	2026-01-16 21:31:56.642+00	b935a58b-d0c4-4d60-9acd-7ed83c647978	\N
b75fc1fa-3c3c-4cf8-af4a-55a53ca466e9	1433	150	2025	MC	1	2025-08-26	2025-09-07	DON JUAN ALVAREZ	179	37906570e5f50789d3c780f150925e20	2026-01-16 21:31:56.66+00	2026-01-16 21:31:56.66+00	0ad77221-e2c0-4c45-a650-6a0bc4154eb4	e85d8e00-ebb3-4563-af7a-c3a4e91220e5
16bdd132-264b-4f48-8360-0031de43ed37	1434	142	2025	MC	4	2025-09-08	2025-09-16	VIRGEN MARIA	7844	105b02fd9c21ada3053046d67521a954	2026-01-16 21:31:56.677+00	2026-01-16 21:31:56.677+00	d3cd4728-744f-438e-8ec7-cc2f2dc6571e	1cfda69f-753d-4789-97b0-1c6df6fc76a7
e50816f7-1cbb-4934-a5c9-300b453d0059	1435	146	2025	MC	3	2025-09-08	2025-09-18	ANDRES JORGE	186	182640df17363d5913b20462eb497347	2026-01-16 21:31:56.696+00	2026-01-16 21:31:56.696+00	0d9d50b5-0b9b-459c-91bc-1830f753b625	e6ae4bf7-a806-4510-b1d0-b535874128d4
1259d581-8a30-413b-b01f-0d939a73ca72	1442	157	2025	MC	1	2025-09-11	2025-10-18	LUCA MARIO	7729	ec3e47bc0e59e8294bb9c6a3e6d9207b	2026-01-16 21:31:56.713+00	2026-01-16 21:31:56.713+00	cc24d84d-ba71-40b9-8151-92323119d482	e8bf872e-f85a-476d-a1fe-a5889a422726
9cc12f97-140c-418c-a1e0-1d213c356d95	1452	132	2025	MC	5	2025-09-08	2025-09-23	PEDRITO	7798	6b6df4d8e661437efde8f0d73dab629b	2026-01-16 21:31:56.731+00	2026-01-16 21:31:56.731+00	8f6e1c1b-d8be-491e-82e1-1ced1843b47a	\N
f87991bb-a15f-402d-aaf1-f8c89760bca2	1453	133	2025	MC	4	2025-09-08	2025-09-25	SAN JUAN B	174	59ba9f29caa873d5cc6ddf557689adbb	2026-01-16 21:31:56.749+00	2026-01-16 21:31:56.749+00	b935a58b-d0c4-4d60-9acd-7ed83c647978	\N
1f8b2456-003a-44c4-9990-f3d158c77f60	1456	158	2025	MC	1	2025-09-13	2025-09-22	ARBUMASA XV	7796	edc6bce7ea3215a95d00fa71ffdb4672	2026-01-16 21:31:56.767+00	2026-01-16 21:31:56.767+00	64504245-b7b7-4e92-80ad-cfdb7d18e83b	09696e39-6ced-4dd4-ab03-2b34e68d68c4
f20883cb-af16-411c-8623-e300a91b0fdf	1457	156	2025	MC	1	2025-09-13	2025-10-01	CHIYO MARU NO.3	183	b0d7ff248926be3cdc149ed33ff0ce60	2026-01-16 21:31:56.784+00	2026-01-16 21:31:56.784+00	b7434a04-3b64-4168-80b6-2e3b7a9f8675	4af56a05-9a53-4f82-954a-483e586659d5
8d5c113c-a8d5-4b00-b81c-d57c18e5b1d0	1458	152	2025	MC	2	2025-09-13	2025-09-25	FEDERICO C	9471	5dd5f5de1c52f81693c9f442b891a110	2026-01-16 21:31:56.803+00	2026-01-16 21:31:56.803+00	a07196ce-0524-4b05-b36d-04450033c584	\N
669cdc3e-c6a0-4674-949f-180d84c14a71	1460	145	2025	MC	1	2025-08-14	2025-08-22	MELLINO VI	7860	ced096b491cc9fce6cace8344ad4fb1a	2026-01-16 21:31:56.819+00	2026-01-16 21:31:56.819+00	b178ba43-a1c2-4518-9734-e042d4790fce	8f373327-c3f4-4dda-af28-2a19a6af411b
44846d58-a988-4523-aaf9-6f987a27a75a	1461	145	2025	MC	2	2025-08-26	2025-09-05	MELLINO VI	7860	9ec47dcee162505e0383a5b5338101e1	2026-01-16 21:31:56.838+00	2026-01-16 21:31:56.838+00	b178ba43-a1c2-4518-9734-e042d4790fce	fbaca7f9-b7a8-483e-82a3-5cfeaee4dc72
e32fe2b7-4729-49c1-8daa-0486aa56479d	1462	145	2025	MC	3	2025-09-09	2025-09-09	MELLINO VI	7860	df92bf63cd499bd3d99bc2bdbd0abc37	2026-01-16 21:31:56.853+00	2026-01-16 21:31:56.853+00	b178ba43-a1c2-4518-9734-e042d4790fce	6790a4f4-86a8-4eb0-997d-ba832431edc8
d2b78d6e-2e8f-4b40-8516-f450d0021438	1463	145	2025	MC	4	2025-09-13	2025-09-23	MELLINO VI	7860	bdcedeebeecb290f26691747194591bb	2026-01-16 21:31:56.871+00	2026-01-16 21:31:56.871+00	b178ba43-a1c2-4518-9734-e042d4790fce	b1923c4e-86a8-47da-8e2b-6e7ec50e321c
c640c380-a599-481f-8ec4-60a089ec7c41	1464	136	2025	MC	1	2025-07-31	2025-08-05	CHIYO MARU NO.3	190	9e8fb93d7206bc12b01f378da8c0d34e	2026-01-16 21:31:56.887+00	2026-01-16 21:31:56.887+00	65604077-1344-40c8-8aa5-530a80524667	4056ec32-0e4f-4788-87c0-6d039f8766a6
922a60ac-8f03-48f1-bd1f-fd364e293df7	1465	136	2025	MC	2	2025-08-07	2025-09-12	CHIYO MARU NO.3	190	5fd0c522949be2e82506084bc214b5e3	2026-01-16 21:31:56.905+00	2026-01-16 21:31:56.905+00	65604077-1344-40c8-8aa5-530a80524667	\N
469ef8ca-4026-4b26-83bd-fffbab34827e	1466	163	2025	MC	1	2025-09-17	2025-11-17	ECHIZEN MARU	9461	b14178f9f1cac5f90a37ba3c906c0c89	2026-01-16 21:31:56.922+00	2026-01-16 21:31:56.922+00	54cef98c-4772-40b4-9f04-80a878694497	509f98e2-0dcf-4f96-bd20-bd2ecf3ac1f1
21a65558-3046-41d0-80f0-1a1bc702138a	1474	158	2025	MC	2	2025-09-23	2025-10-12	ARBUMASA XV	7796	285e75f1cb4ef68b67db0a510bfed200	2026-01-16 21:31:56.941+00	2026-01-16 21:31:56.941+00	64504245-b7b7-4e92-80ad-cfdb7d18e83b	\N
49fa46e7-4e1e-4344-b7f1-70339a018b16	1475	132	2025	MC	6	2025-09-26	2025-10-07	PEDRITO	7798	ebc5328163468f08553f7ad4e31f15e6	2026-01-16 21:31:56.959+00	2026-01-16 21:31:56.959+00	8f6e1c1b-d8be-491e-82e1-1ced1843b47a	\N
8b293e85-0489-48f9-b880-f7f4be323563	1476	152	2025	MC	3	2025-09-26	2025-10-08	FEDERICO C	9471	0d8289c67b40838fabcafdc6151198c6	2026-01-16 21:31:56.977+00	2026-01-16 21:31:56.977+00	a07196ce-0524-4b05-b36d-04450033c584	\N
5ea8208b-d114-41e3-9080-c16ff120d1ba	1477	165	2025	MC	1	2025-09-29	2025-10-03	VALERIA DEL ATLANTICO	7776	a8909555217c30ea7d0f9ae7aff9d1c4	2026-01-16 21:31:56.995+00	2026-01-16 21:31:56.995+00	911f04d3-2611-418a-ab6c-85273c1c54f4	98a492c7-9d72-4b82-8208-5cab5fa82c3d
c8768a27-b9be-431e-93ea-918f9fe4a082	1479	165	2025	MC	2	2025-10-05	2025-10-29	VALERIA DEL ATLANTICO	7776	53647c2a63bdfb2845679284f75d3975	2026-01-16 21:31:57.012+00	2026-01-16 21:31:57.012+00	911f04d3-2611-418a-ab6c-85273c1c54f4	\N
91183611-0ea7-46b4-91af-25fa8b102ebd	1480	164	2025	MC	1	2025-09-20	2025-10-07	XEITOSIÑO	4840	cf0f6e9b9e6a8d891b13003b7752ddaa	2026-01-16 21:31:57.027+00	2026-01-16 21:31:57.027+00	d6df112f-d895-4076-89b7-b17f522b77c1	2f8caf01-752b-42cf-8b7b-0a75ed69ed46
50b302a6-ba45-4aab-b34c-07266c41b361	1481	166	2025	MC	1	2025-09-30	2025-10-19	ARGENOVA XXI	7848	6fa7de87ced6e11b1f931c8ed77bc2dc	2026-01-16 21:31:57.045+00	2026-01-16 21:31:57.045+00	dccb9d7c-b9d8-4f58-9269-ec88c8221976	ebd7b98e-c498-4ba4-8835-682c8c8613b6
b5d8efca-3306-49bb-98f9-5282ce61b87e	1484	159	2025	MC	2	2025-10-13	2025-11-08	ATLANTIC EXPRESS	7845	d9714389098d78823a575d72651c80a4	2026-01-16 21:31:57.062+00	2026-01-16 21:31:57.062+00	08476a6d-7120-4f53-b222-7958aa0ff895	\N
da22997d-e08d-49da-b1f2-6af467e6bb03	1491	162	2025	MC	2	2025-10-14	2025-11-02	TANGO I	7852	7fd75300f540c2c3de2491929ab388eb	2026-01-16 21:31:57.08+00	2026-01-16 21:31:57.08+00	26138cad-87d4-482f-9e82-3a5b24e0c2c8	\N
08fa0047-374b-44b6-a45b-7a2cdeb7d434	1492	168	2025	MC	1	2025-10-14	2025-11-23	ITXAS LUR	9467	a10928afd193f753d421334a9f52ded2	2026-01-16 21:31:57.097+00	2026-01-16 21:31:57.097+00	5676b02b-3aa8-4744-a6a1-9d16eaec0a3f	321d5189-7c90-4d2b-b9c9-bf28963c772e
95f01640-f7ca-402f-aa35-92e9d87d6322	1493	135	2025	MC	1	2025-07-28	2025-08-03	UR ERTZA	7832	cbda3ba2d43ee372929e0724f13a9425	2026-01-16 21:31:57.115+00	2026-01-16 21:31:57.115+00	a670a10e-b396-43cf-9e4f-da854c216802	6933c7a1-851e-40b5-aa9e-564d1832ca2a
feec908b-fe89-4f71-abd3-846ea344e6f6	1494	135	2025	MC	2	2025-08-06	2025-08-14	UR ERTZA	7832	7338fd6cc3ee118d15b943e1b6a454cd	2026-01-16 21:31:57.133+00	2026-01-16 21:31:57.133+00	a670a10e-b396-43cf-9e4f-da854c216802	548560de-742c-4a97-824b-ca061633a1d9
17776de2-6824-466f-8cbd-43db484cb2ef	1495	135	2025	MC	3	2025-08-16	2025-08-23	UR ERTZA	7832	8f7c2942196d121a066f97f4ac393779	2026-01-16 21:31:57.151+00	2026-01-16 21:31:57.151+00	a670a10e-b396-43cf-9e4f-da854c216802	54c9df77-aa4f-481c-ac1b-fe8bd63f2adc
9144db13-e324-4145-b7f0-78d6af481b54	1497	160	2025	MC	2	2025-10-17	2025-11-06	TALISMAN	7832	d42bc4486f8cfa3be289e7b612d7f044	2026-01-16 21:31:57.168+00	2026-01-16 21:31:57.168+00	63a550cb-4b46-4392-aa6b-daf68171a61a	\N
a2027d6a-6838-4c50-850b-16f1770fd59b	1499	66	2025	MC	2	2025-05-14	2025-05-25	FEIXA	7729	ffb1a754aecffab55c1032e13adefbf8	2026-01-16 21:31:57.186+00	2026-01-16 21:31:57.186+00	12560a8d-1d4d-4c20-a734-8ee0ff62a0e6	06b11cde-5352-4b36-95d0-5aedaad5055c
5e54a3b3-3c33-4d07-b678-eeff5987b054	1501	155	2025	MC	1	2025-09-10	2025-09-22	ERIN BRUCE II	166	4253f17e8167d61c8a770baaa444689c	2026-01-16 21:31:57.203+00	2026-01-16 21:31:57.203+00	3c2cce97-783f-4d0c-a9f9-fb9b8d7b2d17	a3024323-0840-4254-80d6-b630ceb34325
fe1f422f-47e8-4178-b925-ea3756a97a6c	1502	155	2025	MC	2	2025-09-22	2025-10-20	ERIN BRUCE II	166	3d1100bcc598117a66bc089f8fb15889	2026-01-16 21:31:57.221+00	2026-01-16 21:31:57.221+00	3c2cce97-783f-4d0c-a9f9-fb9b8d7b2d17	\N
f17beee8-1ed4-487a-b0d8-0b2441036cc5	1503	166	2025	MC	2	2025-10-22	2025-11-01	ARGENOVA XXI	7848	ef700131b8a0bf97fc506440333d41df	2026-01-16 21:31:57.239+00	2026-01-16 21:31:57.239+00	dccb9d7c-b9d8-4f58-9269-ec88c8221976	\N
a1b32644-d99a-433c-bce4-258e411aa5b5	1504	170	2025	MC	1	2025-10-19	2025-10-23	CENTAURO 2000	73	c581cbc3cd95eb69b91ecc44e8d75f1a	2026-01-16 21:31:57.257+00	2026-01-16 21:31:57.257+00	deb918b8-73e6-4c2d-9cd7-1e614d2e048e	4df3a410-28b7-4605-afa9-33f95f52539b
4f0df74f-f79f-4f39-9f12-d54e00ddc885	1505	172	2025	MC	1	2025-10-23	2025-11-24	CHIYO MARU NO.3	183	e1f31371a8f9177a5594f74020b10be1	2026-01-16 21:31:57.275+00	2026-01-16 21:31:57.275+00	fec0ddd6-f0b4-40ae-bf31-03d15f45241b	7ecd74a4-e5f2-4f9f-a9cd-746cdc77fde5
a97d1716-7fef-4470-8f4d-97c3ad0d795e	1506	170	2025	MC	2	2025-10-24	2025-10-29	CENTAURO 2000	73	b3f30b351ddd7038355e4038e6b0fd1b	2026-01-16 21:31:57.293+00	2026-01-16 21:31:57.293+00	deb918b8-73e6-4c2d-9cd7-1e614d2e048e	9ce50dd9-54cd-419f-bee5-a2b990ac6942
34477ec7-5356-48ea-87a5-b46647130f19	1507	174	2025	MC	1	2025-10-27	2025-12-07	ERIN BRUCE II	7853	3d3f2b62fb2713331ca4276be1878a93	2026-01-16 21:31:57.309+00	2026-01-16 21:31:57.309+00	12b7645b-a848-44ac-a2c7-f47f748f1cc6	dbdb79b5-1477-4137-b5c9-6680edf4d83b
58273b34-202d-40db-bea1-4bb18d78fb69	1508	149	2025	MC	2	2025-09-03	2025-09-19	XEITOSIÑO	4840	e86694fd711dcf5bb0a69af3126a6cf0	2026-01-16 21:31:57.328+00	2026-01-16 21:31:57.328+00	92f748e6-da70-4fd1-894d-89134404ab5a	\N
2ab6949a-1a4c-4794-b65e-ab7f693737ec	1509	173	2025	MC	1	2025-10-30	2025-11-19	VALERIA DEL ATLANTICO	7724	6fccc674ecd912d45efa2c1d09582e06	2026-01-16 21:31:57.346+00	2026-01-16 21:31:57.346+00	2dcf9357-bd8b-4020-9594-c42604b0ea0a	dfcec0df-ab98-4439-b860-0b6f55313063
3c01c198-ef10-48e8-b215-f7bfe4b3d2c4	1510	171	2025	MC	1	2025-10-30	2025-12-04	CAPESANTE	190	1e2c15a2504e0f6ab837f30fa88aa834	2026-01-16 21:31:57.363+00	2026-01-16 21:31:57.363+00	840d1c7b-9747-4b06-b53b-697e644a53ea	974b7578-e578-4db0-8ea8-e3a202cc561d
1dc0b5e5-8880-404c-b857-a7541e669ed8	1512	176	2025	MC	1	2025-11-01	2025-11-12	MELLINO VI	7730	dd6b6eb2d831c2b067aadbbe8a9284c5	2026-01-16 21:31:57.381+00	2026-01-16 21:31:57.381+00	42c2367a-8542-4763-9f89-02780bbeea8e	745376ad-ad11-4c73-8259-cac35cf67f4c
609d2ff9-2a3b-43e4-b02e-8a136483f60a	1513	170	2025	MC	3	2025-11-03	2025-11-08	CENTAURO 2000	73	ec9847b3541bbe498bd6f1cc9dcd4ca8	2026-01-16 21:31:57.399+00	2026-01-16 21:31:57.399+00	deb918b8-73e6-4c2d-9cd7-1e614d2e048e	d5724a7a-410a-40c5-a8f0-a139db1a29e4
6d3930a3-e34f-47a9-9dc3-04dcc92411f3	1514	179	2025	MC	1	2025-11-04	2025-11-11	RAFFAELA	7838	2855dde0aca93a7148e0d1a53a3754de	2026-01-16 21:31:57.416+00	2026-01-16 21:31:57.416+00	89a552ad-3649-45e6-9e48-9029a4629763	5afa14bf-7e09-4001-aa18-ee216a125059
d1f54ae0-ecee-4c38-8bc5-1cae5025eb6c	1515	177	2025	MC	1	2025-11-03	2025-11-12	UR ERTZA	9474	b49a0baaa313fb511c253b83a5b16ef7	2026-01-16 21:31:57.433+00	2026-01-16 21:31:57.433+00	dd030597-448a-41db-b591-608b47597a5e	e274df2b-2ad6-4afe-9f56-607f3c84cd10
38bc338f-6d90-4d73-8d9c-0f24eec40c48	1519	178	2025	MC	1	2025-11-07	2025-11-25	TALISMAN	7841	5e6c78508d15ad8bfa8341907a59d270	2026-01-16 21:31:57.451+00	2026-01-16 21:31:57.451+00	e1421d6b-6654-4314-b373-0c7aef292054	d9302d5f-6309-4585-9bd5-62b36b690c56
e653d1d8-15ad-452c-bbac-7a72a299b76e	1523	167	2025	MC	1	2025-09-30	2025-10-05	ATREVIDO	186	785221878989f58cc3aa8b4ce43f9300	2026-01-16 21:31:57.468+00	2026-01-16 21:31:57.468+00	d8a1275d-9257-41a4-ae2b-b82d52c3b637	91023c89-61fa-478d-b3a8-1420f9515dc3
77f9dfb7-a067-471e-a01e-b01208fbf736	1524	167	2025	MC	2	2025-10-07	2025-10-12	ATREVIDO	186	388e4852bf5981730de6f3138c858447	2026-01-16 21:31:57.486+00	2026-01-16 21:31:57.486+00	d8a1275d-9257-41a4-ae2b-b82d52c3b637	f7f31945-46fd-4de5-b3fe-5d8f416e0408
079e6760-0d8a-45c6-af92-b66f2c378a4f	1525	167	2025	MC	3	2025-10-14	2025-10-18	ATREVIDO	186	eea8812d27dca8d1eb6e31f08199aee5	2026-01-16 21:31:57.504+00	2026-01-16 21:31:57.504+00	d8a1275d-9257-41a4-ae2b-b82d52c3b637	dbdb2aba-8e6a-4002-b42c-92626ec38904
3ebef561-3bfa-4e84-bc4d-ae7070ace5b2	1526	167	2025	MC	4	2025-10-20	2025-10-24	ATREVIDO	186	84d8e46daea7c005881054f0d0ddd807	2026-01-16 21:31:57.521+00	2026-01-16 21:31:57.521+00	d8a1275d-9257-41a4-ae2b-b82d52c3b637	da5eba55-1a3a-4dc7-a141-eaeee4ef238e
2dde7c29-0e7e-470d-98e6-cd53499fb234	1527	167	2025	MC	5	2025-10-26	2025-11-01	ATREVIDO	186	c34885c10c1d282362e996dac6a18dca	2026-01-16 21:31:57.538+00	2026-01-16 21:31:57.538+00	d8a1275d-9257-41a4-ae2b-b82d52c3b637	479f323a-bb6b-4e27-9f68-ba67e6b25b6b
297efe46-4013-45b7-9e9d-54a0fdd1f3d2	1528	167	2025	MC	6	2025-11-01	2025-11-07	ATREVIDO	186	80c43e2e3f9ce67c3e34210ad9741448	2026-01-16 21:31:57.557+00	2026-01-16 21:31:57.557+00	d8a1275d-9257-41a4-ae2b-b82d52c3b637	4b56a3ab-00c3-4075-80c7-a1a82284e116
af7c8dad-932e-4f0e-b66e-856907fe19bc	1534	180	2025	MC	1	2025-11-12	2025-12-16	ATLANTIC EXPRESS	179	d6b5ba3a8a1eff2e2c486753c1910523	2026-01-16 21:31:57.575+00	2026-01-16 21:31:57.575+00	ecfe7292-b255-4865-bb32-5949e22b7802	45611c7a-4060-42d6-b0de-4ed6013dc781
aa3c15d8-bf7a-46bb-a8ed-01453cd065f9	1536	175	2025	MC	1	2025-11-04	2025-11-12	ANITA	7767	3bac213b0f80ab8029ba5c16ad63db0c	2026-01-16 21:31:57.592+00	2026-01-16 21:31:57.592+00	70ec1fd8-6559-4e17-850f-dfbffe164b2b	fcec85f8-6c40-4a3a-9144-40bd7d59bc86
d02e84a3-2b07-4f81-877f-a625a316f58b	1542	162	2025	MC	3	2025-11-05	2025-12-04	TANGO I	7852	e317e12a3b5503fa0478bfc139f9640a	2026-01-16 21:31:57.611+00	2026-01-16 21:31:57.611+00	26138cad-87d4-482f-9e82-3a5b24e0c2c8	\N
29e892c1-4982-4da4-ae55-bb87f948dbd1	1543	169	2025	MC	1	2025-10-12	2025-10-14	DUKAT	7843	c10bd56bc66a5dad7c1610a0bd491abd	2026-01-16 21:31:57.629+00	2026-01-16 21:31:57.629+00	80616398-f6b9-4201-b08d-b39d5eb67ca4	3f1cf111-a5b1-470f-bee5-684bd201c28a
04278d70-5746-46d2-a347-9bfb091b1691	1544	169	2025	MC	2	2025-10-16	2025-11-12	DUKAT	7843	a6f149e048fb7a893637131ce7dd27fd	2026-01-16 21:31:57.647+00	2026-01-16 21:31:57.647+00	80616398-f6b9-4201-b08d-b39d5eb67ca4	\N
1bc4547a-8a63-41bf-80e8-291fa9f938e8	1545	169	2025	MC	3	2025-11-14	2025-12-05	DUKAT	7843	b27d3ad5982d1effcbd532dacc3f397d	2026-01-16 21:31:57.663+00	2026-01-16 21:31:57.663+00	80616398-f6b9-4201-b08d-b39d5eb67ca4	\N
ff28eb42-5aa2-44e5-a908-d2cf0e629097	1546	177	2025	MC	2	2025-11-14	2025-11-21	UR ERTZA	9474	b8e7498e6558c27eeb2c8d852f6025cb	2026-01-16 21:31:57.68+00	2026-01-16 21:31:57.68+00	dd030597-448a-41db-b591-608b47597a5e	6dab3a91-422d-4104-a0f1-83a4420ab0c4
bb2faf03-897d-43d0-9c5b-a5d7c1da1b7f	1547	177	2025	MC	3	2025-11-23	2025-12-01	UR ERTZA	9474	46dcbce7d6413ea71883f7a794e06fda	2026-01-16 21:31:57.698+00	2026-01-16 21:31:57.698+00	dd030597-448a-41db-b591-608b47597a5e	6fd36f3e-b092-4535-92c3-4fdfcead634c
d1adc29b-9bc0-4c5c-8120-589dd0196a7b	1548	181	2025	MC	1	2025-11-10	2025-12-12	MISS TIDE	4840	927a9e5369481cbdecf2e2bea9652762	2026-01-16 21:31:57.716+00	2026-01-16 21:31:57.716+00	18873c09-e4fc-493b-b80b-ec01ae1eb66e	c7471cca-cf46-43f5-af61-87844c00e374
d01fbce2-3f41-4ef2-ae53-c2f182173cbf	1549	182	2025	MC	1	2025-11-22	2026-01-12	ECHIZEN MARU	7838	e3d78f4f0350651f74b862706a9df01a	2026-01-16 21:31:57.733+00	2026-01-16 21:31:57.733+00	1d3796e9-5936-4785-9a48-2b5ecb48a7be	3800b073-14dc-4e2f-81cd-6bfb26da12c9
578e13d6-36d8-48ab-9f97-0e89edc31fde	1550	183	2025	MC	1	2025-11-26	2026-01-04	CHIYO MARU NO.3	7726	b7cfaa37fc065b99b2142ddedae2a002	2026-01-16 21:31:57.752+00	2026-01-16 21:31:57.752+00	fc13e177-c80d-4b35-98ed-bdfb707663cc	71f99bac-46dc-49dc-af66-07213f5d9b90
c72d2646-5886-47dd-bdfc-4e41c26b40e0	1552	184	2025	MC	1	2025-11-27	\N	TAI AN	7798	abbc59ff531dafd18625d8841e31708c	2026-01-16 21:31:57.769+00	2026-01-16 21:31:57.769+00	c7504351-7144-4384-bd61-a5968f0bfe57	c746c1d4-1b8f-405a-b3ac-f8c384c225c8
4e528605-f493-46a6-8ec6-65c137d77534	1557	171	2025	MC	2	2025-12-04	\N	CAPESANTE	190	2776d9a8acb7a33e9c752462d7e06e9c	2026-01-16 21:31:57.785+00	2026-01-16 21:31:57.785+00	840d1c7b-9747-4b06-b53b-697e644a53ea	\N
d98ac849-fe54-4dd9-993f-9b7a840e0f41	1558	175	2025	MC	2	2025-11-14	2025-11-18	ANITA	7767	3d9f895e77aa40402678caaa32b30d25	2026-01-16 21:31:57.801+00	2026-01-16 21:31:57.801+00	70ec1fd8-6559-4e17-850f-dfbffe164b2b	4a7a1d75-4456-4421-b91b-695c2fd874d1
589ea283-b174-46c4-9a75-11e8d09ddcd5	1559	175	2025	MC	3	2025-11-22	2025-11-27	ANITA	7767	6d5641f44df1da16376de79567ecdaa9	2026-01-16 21:31:57.818+00	2026-01-16 21:31:57.818+00	70ec1fd8-6559-4e17-850f-dfbffe164b2b	cbfeab2c-6896-4b24-957b-a80c27d6dc38
cf772167-319a-4cee-b07e-c1d077ad8976	1560	175	2025	MC	4	2025-11-30	2025-12-06	ANITA	7767	fb00d00a21df5b4c070a89cf89e91373	2026-01-16 21:31:57.835+00	2026-01-16 21:31:57.835+00	70ec1fd8-6559-4e17-850f-dfbffe164b2b	b752f199-5120-4278-89ed-d81eefa6acb2
a065b47d-2984-4207-82f2-e58f8b5345ee	1561	171	2025	MC	5	\N	2025-12-11	CAPESANTE	190	ab44c9ef5c6941099d40502241b27a9a	2026-01-16 21:31:57.852+00	2026-01-16 21:31:57.852+00	840d1c7b-9747-4b06-b53b-697e644a53ea	\N
ad773dc7-ce53-47a3-889d-de627f303658	1564	13	2025	MC	1	2025-01-11	2025-01-11	PIONEROS	7847	4c4332a30e7333a4b59ada4ddaa64423	2026-01-16 21:31:57.87+00	2026-01-16 21:31:57.87+00	89b33858-f91c-4971-ab64-227f9ba17371	db57eee6-facc-4f0b-8b0f-543b8abd5ddf
89d4d86f-99c7-4b24-b305-fb2284e54929	1565	13	2025	MC	2	2025-01-14	2025-01-15	PIONEROS	7847	36f2c47357f31d9abb0ff6c5df48b18b	2026-01-16 21:31:57.888+00	2026-01-16 21:31:57.888+00	89b33858-f91c-4971-ab64-227f9ba17371	\N
c353823e-f9d9-42d3-b1f6-c1ab661b1a25	1566	13	2025	MC	3	2025-01-15	2025-01-16	PIONEROS	7847	de30d1b7eba5e8b988c02dd6485c52e0	2026-01-16 21:31:57.906+00	2026-01-16 21:31:57.906+00	89b33858-f91c-4971-ab64-227f9ba17371	\N
6777e3c0-5e3c-4e1f-9c5f-1ca740f56a83	1567	13	2025	MC	4	2025-01-17	2025-01-17	PIONEROS	7847	43604325fe29fdf38e50ea78b2df33dd	2026-01-16 21:31:57.923+00	2026-01-16 21:31:57.923+00	89b33858-f91c-4971-ab64-227f9ba17371	\N
16debb61-cc2e-4ee5-903e-a9dfb8700013	1568	13	2025	MC	5	2025-01-17	2025-01-19	PIONEROS	7847	95499094f61b660f637ce0208c4fa123	2026-01-16 21:31:57.94+00	2026-01-16 21:31:57.94+00	89b33858-f91c-4971-ab64-227f9ba17371	\N
4fb1c0fc-0f08-4ddc-9a6a-533d748145ad	1569	13	2025	MC	6	2025-02-02	2025-02-05	PIONEROS	7847	348503aa0f66b6a67d002c00e79db7a6	2026-01-16 21:31:57.957+00	2026-01-16 21:31:57.957+00	89b33858-f91c-4971-ab64-227f9ba17371	\N
95c5560e-c780-48dd-92b9-e793f920b17e	1570	13	2025	MC	7	2025-02-12	2025-02-15	PIONEROS	7847	4f715cccc05ab5d212358fa6c8508039	2026-01-16 21:31:57.974+00	2026-01-16 21:31:57.974+00	89b33858-f91c-4971-ab64-227f9ba17371	\N
f0fe8440-312b-4fe2-9290-e245c3803e83	1571	186	2025	MC	1	2025-12-16	\N	CAPESANTE	190	3ce41e6a5bdbaa4e92cc32a92aae13e0	2026-01-16 21:31:57.992+00	2026-01-16 21:31:57.992+00	d06453ee-c376-4333-986f-e02f13988014	504dbc20-29fe-4273-b1da-afe4d9b32f56
4acd20fe-9f93-4c80-aa92-21bc26301d30	1572	187	2025	MC	1	2025-12-15	\N	ERIN BRUCE II	7844	af02bbef65885966d662ebc361a74228	2026-01-16 21:31:58.009+00	2026-01-16 21:31:58.009+00	a5e4657e-38f5-4130-a6ef-08d685fbddad	3788c947-4062-48fd-a08c-88821b936ae9
89f4ab53-b205-4e04-8e76-24c1f6d13d61	1574	185	2025	MC	1	2025-12-02	2025-12-06	ATREVIDO	7612	a12b30b64a5c629b13d269aedf61c410	2026-01-16 21:31:58.026+00	2026-01-16 21:31:58.026+00	68d4e4c7-151f-4a33-a2d6-a1a2ac165e9f	18dfb601-91e3-40e8-b56a-b7f70e8e722b
03b9fabc-02c3-46fa-a696-a6b7c4fdf9e4	1575	185	2025	MC	2	2025-12-09	2025-12-13	ATREVIDO	7612	4b3b4e52df5fef4fbc12d32625445f75	2026-01-16 21:31:58.044+00	2026-01-16 21:31:58.044+00	68d4e4c7-151f-4a33-a2d6-a1a2ac165e9f	\N
aac057bb-9b6e-4528-be88-14f2b378f6bf	1577	170	2024	MC	1	2024-12-27	2025-02-17	TAI AN	7798	3c18dc0708aff7539f911cd44159a1e9	2026-01-16 21:31:58.061+00	2026-01-16 21:31:58.061+00	\N	\N
694f5ed2-7d19-499b-b68c-4ae60e1ac2ca	1578	44	2025	MC	1	2025-03-12	2025-03-15	MISS PATAGONIA	7729	fc716eb54686ac5b2187fc4868134457	2026-01-16 21:31:58.078+00	2026-01-16 21:31:58.078+00	daff9983-9b0f-46a5-87a0-21d52c16b234	1aea25f0-ca74-434f-90d2-db9168be3607
d7a6a903-233d-4364-a598-a6b79488f4aa	1579	44	2025	MC	2	2025-03-15	2025-03-17	MISS PATAGONIA	7729	03a45921462146d2e092cc29af3300d6	2026-01-16 21:31:58.096+00	2026-01-16 21:31:58.096+00	daff9983-9b0f-46a5-87a0-21d52c16b234	ec452251-be4d-437c-8d60-783b24424b46
b6044fcd-bb8f-41eb-9de4-6677f294955f	1580	44	2025	MC	3	2025-03-18	2025-03-29	MISS PATAGONIA	7729	d43c289c8bc4be0bce55003426a4ea82	2026-01-16 21:31:58.113+00	2026-01-16 21:31:58.113+00	daff9983-9b0f-46a5-87a0-21d52c16b234	\N
f38de030-0d83-4147-a18c-20b34fcb4e9c	1581	48	2025	MC	1	2025-03-13	2025-04-14	TALISMAN	7842	b5afa0f17db2071329e623fccce5194e	2026-01-16 21:31:58.13+00	2026-01-16 21:31:58.13+00	661d8e7c-b0ee-4bb4-addd-d927d95de530	addc4d3e-fb88-49a9-a749-0a0381141b15
ef19a8a1-62e8-4e37-9da4-ad25b02c678a	1582	48	2025	MC	2	2025-04-16	2025-04-23	TALISMAN	7842	16f5b4830b352b37e4304089dc629709	2026-01-16 21:31:58.147+00	2026-01-16 21:31:58.147+00	661d8e7c-b0ee-4bb4-addd-d927d95de530	\N
fb4df1bd-3240-48fc-a538-e350badfc8b5	1583	48	2025	MC	3	2025-04-23	2025-04-28	TALISMAN	7842	72edc0322ea661ce0d1594c42c06efa5	2026-01-16 21:31:58.164+00	2026-01-16 21:31:58.164+00	661d8e7c-b0ee-4bb4-addd-d927d95de530	\N
6b63435c-9038-40bf-bf36-7b546c184110	1584	143	2025	MC	1	2025-08-08	2025-08-19	NINA	9467	70ec3f28eee341875dfb2d0d301a7670	2026-01-16 21:31:58.182+00	2026-01-16 21:31:58.182+00	2807c518-ee18-46b9-be03-54ee4d5ed4f9	17de929f-2973-4620-b616-ec80a70daf5c
6b72524e-d057-49b5-a419-cded571ef6fa	1587	177	2025	MC	4	2025-12-03	2025-12-11	UR ERTZA	9474	5c004e501b1b71260786f82a78083fd1	2026-01-16 21:31:58.201+00	2026-01-16 21:31:58.201+00	dd030597-448a-41db-b591-608b47597a5e	d5d9e985-9d3d-481e-8b01-f9497ffc4fb5
487702bd-b36d-4fac-ad60-225f6a7933c3	1589	196	2025	MC	1	2025-12-23	2025-12-27	TANGO II	7861	4c61752a585c3c770719756e702afdd9	2026-01-16 21:31:58.218+00	2026-01-16 21:31:58.218+00	d0080183-5a28-4940-8b62-d0916fb6ea45	96f71fc0-19c3-4a74-ba9c-5fb8d5ebcd94
51c17d49-8ee3-4713-b07b-88687f5531cc	1590	180	2025	MC	2	2025-12-18	2025-12-24	ATLANTIC EXPRESS	179	486f996998145adf16397d589dd1a67e	2026-01-16 21:31:58.235+00	2026-01-16 21:31:58.235+00	ecfe7292-b255-4865-bb32-5949e22b7802	\N
883637f0-203f-4e46-b7f4-112364a9c8f5	1591	161	2025	MC	1	2025-10-14	2025-10-30	TANGO II	7842	1ce5e0785661b5324b686035e2e46d5f	2026-01-16 21:31:58.254+00	2026-01-16 21:31:58.254+00	7e201eae-7c97-485c-9670-915d228402e3	7ffa9cd2-a40a-4d9b-bb15-3eb7cda32fda
f33f509a-44e8-4070-bc3d-44ebbba448e3	1592	\N	2025	CI	2	2025-09-18	2025-10-10	TANGO II	7842	39f97a46487afdd9de187e79ac17abc7	2026-01-16 21:31:58.272+00	2026-01-16 21:31:58.272+00	\N	\N
6ae4c1e2-61ef-45fb-88f1-cdaeabe6a02a	1593	178	2025	MC	2	2025-11-28	2025-12-21	TALISMAN	7841	addf672d20ea628f236f5a0d9f8efc63	2026-01-16 21:31:58.288+00	2026-01-16 21:31:58.288+00	e1421d6b-6654-4314-b373-0c7aef292054	54681b8d-41c9-4ee7-bd71-dd26e1605244
85079b8e-e265-435d-9e73-ef2db284bb64	1594	191	2025	MC	1	2025-12-29	\N	HUYU 962	7868	4097f08158aa6223d21892ba71461e84	2026-01-16 21:31:58.305+00	2026-01-16 21:31:58.305+00	6a925c67-2c02-43e9-9496-fd3975160424	4030df33-e313-4da4-9a55-ea22058bb755
297a08a1-c3b8-4b1d-9535-c0fd33b7a7e4	1595	200	2025	MC	1	2025-12-29	\N	SCIROCCO	7900	abc7011314542ed1ba899bd056749282	2026-01-16 21:31:58.322+00	2026-01-16 21:31:58.322+00	e6685824-1f78-44d1-a67e-61b80de14ac0	355ea204-2e97-47d2-9b82-92a5c77307ee
4c81f413-65b7-4f98-bd92-869088dcc03a	1596	201	2025	MC	1	2025-12-29	\N	NAVEGANTES III	7873	6c9d5f3d95f2efb509f35ca6e8c8f050	2026-01-16 21:31:58.339+00	2026-01-16 21:31:58.339+00	99da2fe8-8c72-4174-a1f5-26e38069ba49	87fb2325-8144-46e6-986c-cb0221973208
4fa31c6a-987f-4996-8335-2fafae70b696	1597	189	2025	MC	1	2025-12-29	2026-01-04	MINTA	7871	4d4e0d7f1a09405485a7cd453d6bae1d	2026-01-16 21:31:58.356+00	2026-01-16 21:31:58.356+00	1499b680-ec86-4123-8e28-0bead9519301	72543581-2475-44a7-8b85-804161fa8213
1f99377c-937c-4678-b833-088622ebbc91	1598	198	2025	MC	1	2025-12-29	2026-01-05	DON LUIS I	7612	39986df3911de8d795c3d2a0f182cebc	2026-01-16 21:31:58.375+00	2026-01-16 21:31:58.375+00	239c4c23-fbcd-43fd-88d5-02c4d4601349	8d7c7b92-155d-4761-977b-51fbc5798a3a
99fa1066-a9bf-4284-8588-e3a57b4ce48b	1600	\N	2025	CI	1	2025-10-02	2025-10-21	CHIYO MARU NO.3	183	622399b53cdf7e85b17927da6b1b63b6	2026-01-17 01:38:53.738+00	2026-01-17 01:38:53.738+00	\N	\N
19de77bd-f369-4d8e-be12-71340b748e6b	1602	\N	2025	CI	2	2025-09-13	2025-10-12	ATLANTIC EXPRESS	7845	a39ac601225a1f583cb034d93204bdcf	2026-01-17 01:38:53.776+00	2026-01-17 01:38:53.776+00	\N	\N
15447c1a-77fa-4160-8308-faa633811533	1603	\N	2025	CI	2	2025-09-13	2025-10-12	ATLANTIC EXPRESS	7838	c1459241ad28a261610db0b8f27b95e1	2026-01-17 01:38:53.796+00	2026-01-17 01:38:53.796+00	\N	\N
f5250fec-c868-4d89-9a7e-602a355e6779	1604	190	2025	MC	1	2025-12-30	\N	SOHO MARU N 58	7860	585140cd0255b52e7bc5ed97a2250347	2026-01-17 01:38:53.816+00	2026-01-17 01:38:53.816+00	841c4ec4-edbf-4b07-8063-2e84f2680fff	d2804c2e-a528-4b87-9231-f8da2e283aa3
18a25160-f4cf-4953-83f4-67bc33269f73	1605	\N	2025	CI	3	2025-09-15	2025-10-10	TANGO I	7852	28485f27e499b83bb4184d24e1041c33	2026-01-17 01:38:53.834+00	2026-01-17 01:38:53.834+00	\N	\N
4fd1d669-357f-45ef-94a8-6003bf9914a5	1606	3	2025	MC	4	2025-02-24	2025-03-02	ATLANTIC EXPRESS	179	27c700746a6d56a79c387c9d926f26fa	2026-01-17 01:38:53.853+00	2026-01-17 01:38:53.853+00	855ed6f3-5a13-41d4-a6b3-bf85b2fd720f	\N
f4dfa7a8-bcee-4505-9b82-2da6e47853a9	1607	3	2025	MC	4	2025-02-25	2025-03-02	ATLANTIC EXPRESS	179	b3aed200636465137db5c5111d482355	2026-01-17 01:38:53.871+00	2026-01-17 01:38:53.871+00	855ed6f3-5a13-41d4-a6b3-bf85b2fd720f	\N
15b24449-a73d-48ff-9783-0c1ad31c1bea	1608	188	2025	MC	1	2025-12-30	\N	VALERIA DEL ATLANTICO	7729	59456f2955c2df0a0ba74c4a3765e8b8	2026-01-17 01:38:53.889+00	2026-01-17 01:38:53.889+00	47bc925f-8a76-467f-8a92-30b22cf33c75	f366d627-4a7d-485b-bf15-acf869dcb4cb
2606312c-74d5-4e4f-9a3b-9d0e7ee67f79	1614	193	2025	MC	1	2025-12-29	\N	HAI XIANG 17	7872	950298304752d1c67126bab6f2a93170	2026-01-17 01:38:53.906+00	2026-01-17 01:38:53.906+00	32942ae8-dac2-4d9e-8ef2-3ffe43237c17	3f7a9e2a-866a-4cb1-b260-6bf8e6005087
2be162d6-1dbd-45de-be1b-7bf414681475	1616	189	2025	MC	2	2026-01-06	\N	MINTA	7871	c57ee530e334ece86a882ef0625a7513	2026-01-17 01:38:53.924+00	2026-01-17 01:38:53.924+00	1499b680-ec86-4123-8e28-0bead9519301	\N
a90dece5-b04a-47da-ae37-4c3b6a586bab	1617	198	2025	MC	2	2026-01-06	\N	DON LUIS I	7612	30e5b22309681f6bc7ab66ea81951302	2026-01-17 01:38:53.942+00	2026-01-17 01:38:53.942+00	239c4c23-fbcd-43fd-88d5-02c4d4601349	\N
771062f6-d781-401d-a08f-a7050217267c	1618	3	2026	MC	1	2026-01-06	\N	VENTARRON 1º	7865	a4f3dfcd44956d5a25faac504099b904	2026-01-17 01:38:53.961+00	2026-01-17 01:38:53.961+00	\N	\N
9cdb01cb-2271-4b22-a0ed-3e63e69da7ca	1619	8	2026	MC	1	2026-01-06	\N	CHIYO MARU NO.3	7726	5972dd068be07aa8aa328479782f429c	2026-01-17 01:38:53.982+00	2026-01-17 01:38:53.982+00	\N	\N
7ad50b4c-e849-4c6c-bbc2-22d50edbfd46	1621	4	2026	MC	1	2026-01-06	2026-01-12	ATREVIDO	9467	f8d2cd975c68813985e0132a75480078	2026-01-17 01:38:54+00	2026-01-17 01:38:54+00	\N	\N
28ad8ce4-9594-4b41-9427-34f221ac88c4	1622	5	2026	MC	1	2026-01-06	\N	DON PEDRO	9474	ea5fcafebbee897d06d3885fc1914c9a	2026-01-17 01:38:54.02+00	2026-01-17 01:38:54.02+00	\N	\N
cc3635cd-7d63-4f59-b527-d553f46ac773	1623	199	2025	MC	1	2026-01-09	\N	ATLANTIC SURF III	166	d741d5a96e518552301492b50d94b40d	2026-01-17 01:38:54.038+00	2026-01-17 01:38:54.038+00	f091515a-3a09-4d2d-aaad-839f884a6ec5	6282e5de-d67c-4ef0-a5f1-fae17ddae5cf
481b49a9-0052-4fb1-9feb-624a60a8c0c5	1625	4	2026	MC	2	2026-01-13	\N	ATREVIDO	9467	7e1e78e471103ef248e20e302c38988a	2026-01-17 01:38:54.056+00	2026-01-17 01:38:54.056+00	\N	\N
581ab7c8-dcc1-4a7e-a373-0d6721053932	1626	6	2026	MC	1	2026-01-06	\N	NATALIA	7850	53fdbc40003a4434b99e5b2f04f6da71	2026-01-17 01:38:54.074+00	2026-01-17 01:38:54.074+00	\N	\N
9c3b7908-8070-424c-be0e-3a9f0f1e213d	1627	3	2026	MC	1	\N	2026-01-14	VENTARRON 1º	7865	4d97dc5cf58694ae75e7f5ddb630865d	2026-01-17 01:38:54.092+00	2026-01-17 01:38:54.092+00	\N	\N
e3dd4b1d-4301-4218-a3ec-a5dc4e5bbf0d	1609	194	2025	MC	1	2025-12-30	2026-01-15	TALISMAN	7866	edb0d3e3b846ec5223c4015ab4abee75	2026-01-17 01:38:54.116+00	2026-01-17 01:38:54.116+00	7d5358c9-5ca9-4d3d-a59a-e2363c9f6d8d	4992fd90-c4e2-4a72-85ac-39e5a1f5b974
31ed42c1-8713-414e-a784-ff60b03a7d05	1610	195	2025	MC	1	2025-12-30	\N	DUKAT	7874	4bf338efbba898af98feeb5101905ec8	2026-01-17 01:38:54.133+00	2026-01-17 01:38:54.133+00	6d1f181a-37a4-40a6-83fb-4a4ad95c332e	5227126d-7419-482a-936f-aa47ebca2486
defba999-686d-4253-8ec7-28d30fcd92cb	1611	197	2025	MC	1	2025-12-30	\N	TANGO I	9461	27a40f3e59412e277c8f6308942b9fec	2026-01-17 01:38:54.153+00	2026-01-17 01:38:54.153+00	de4b51fc-abf4-4fa4-b1bc-027e6d33908c	cd83dde5-4c4c-4583-9b81-da03688ddc1f
0bb1ecf9-827a-490f-99ab-b41b3b383500	1612	196	2025	MC	2	2026-01-01	\N	TANGO II	7861	79e7f482ef40e7f094916a672572740e	2026-01-17 01:38:54.17+00	2026-01-17 01:38:54.17+00	d0080183-5a28-4940-8b62-d0916fb6ea45	\N
6f1f4fed-0fad-49c4-95bf-484886764ba7	1613	1	2026	MC	1	2026-01-03	\N	ARGENOVA XXI	9480	98f8196b24cb0f0113739c6e2680520d	2026-01-17 01:38:54.186+00	2026-01-17 01:38:54.186+00	\N	\N
837179e4-df91-4509-8402-1fd955a20787	1615	192	2025	MC	1	2025-12-29	\N	HAI XIANG 16	7796	8a61985f08a0cddf5757015eb42e92fa	2026-01-17 01:38:54.206+00	2026-01-17 01:38:54.206+00	abde28b8-9542-4be9-8694-da80f5e0b196	3bb673ef-c7b0-40e4-81a9-74da58971c86
f917a5c4-2b7d-49de-8f49-6df37e54b365	1624	2	2026	MC	1	2026-01-05	\N	CENTURION DEL ATLANTICO	7848	2f13a9ceab7a5fd7e3309a1144ae58e6	2026-01-17 01:38:54.223+00	2026-01-17 01:38:54.223+00	\N	\N
c4c49c18-9368-4a9e-ae12-0535d67ff29a	1601	159	2025	MC	2	2025-10-13	2025-11-08	ATLANTIC EXPRESS	7838	22e0ce87d1d21cdc53cac9cf5adb73cc	2026-01-17 01:38:54.24+00	2026-01-17 01:38:54.24+00	08476a6d-7120-4f53-b222-7958aa0ff895	\N
\.


--
-- Data for Name: lances; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.lances (id, etapa_id, numero_lance, fecha, cod_arte_pesca, tipo_arte_pesca, hora_inicio, lat_inicio, long_inicio, prof_inicio, hora_final, lat_final, long_final, prof_final, rumbo, distancia_red, velocidad_arrastre, tiempo_red, estacion_gral, calador, fondo_min, fondo_max, tamiz, area_barrida, captura_total_kg, descarte_total_kg, observaciones_lance, mus, fuente_dato) FROM stdin;
\.


--
-- Data for Name: mareas; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.mareas (id, anio_marea, nro_marea, id_buque, id_arte_principal, id_estado_actual, fecha_zarpada_estimada, fecha_inicio_observador, fecha_fin_observador, dias_zona_austral, tipo_calculo_zona_austral, nro_protocolizacion, anio_protocolizacion, fecha_protocolizacion, fecha_creacion, fecha_ultima_actualizacion, activo, observaciones, tipo_marea, dias_estimados, id_observador_principal) FROM stdin;
10ea10e1-04e8-4255-ac99-b5e9b437ecad	2025	3	a16cce31-d12d-458a-b212-6846185933bf	1f5e5c39-7fd2-4fb1-8697-d5e0e9a4022b	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-01-04 13:43:00+00	2025-02-22 11:35:00+00	\N	AUTOMATICO	\N	\N	2025-04-08 11:35:00+00	2026-01-17 21:31:15.433+00	2026-01-18 16:02:40.231+00	t	\N	COMERCIAL	30	8ced3542-9444-4153-b141-27ed65a5995b
0af952a3-aed1-469d-a089-e5ad54ad8e8d	2025	100	4a837a56-b513-4568-b2d7-61bc1d66d22b	fedc5975-2697-4b57-b26d-492a64ef6cc8	2ea71871-f6e2-480b-bb64-6d2f436ffa6f	2025-06-17 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-18 23:07:32.031+00	2026-01-18 23:16:29.475+00	t	\N	COMERCIAL	30	b500d7bc-3760-4c88-9a21-4294b2395c71
059cf9fd-83b7-45b7-aa2a-e337d9fff8ba	2024	146	adc23180-9487-47ad-9e3d-62eade83623a	1f5e5c39-7fd2-4fb1-8697-d5e0e9a4022b	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-11-04 05:55:00+00	2024-11-28 19:40:00+00	\N	AUTOMATICO	\N	\N	2025-01-12 19:40:00+00	2026-01-17 21:31:13.725+00	2026-01-17 21:31:13.725+00	t	\N	COMERCIAL	30	dfbdeeff-4e60-46c2-9ce0-7becb9a494a2
679ca681-471c-4ccc-8379-c9f7c00191e0	2025	181	4a837a56-b513-4568-b2d7-61bc1d66d22b	fedc5975-2697-4b57-b26d-492a64ef6cc8	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-11-10 19:15:00+00	2025-12-12 12:00:00+00	\N	AUTOMATICO	\N	\N	2026-01-26 12:00:00+00	2026-01-17 21:31:16.187+00	2026-01-18 16:03:25.774+00	t	\N	COMERCIAL	30	b500d7bc-3760-4c88-9a21-4294b2395c71
0b65ae30-067e-4442-835d-fd3629796ec0	2025	107	34a96d23-cf3a-4eea-b136-56b64fa5239c	acea052d-e5d1-4ced-b98c-2d01eb79122a	2ea71871-f6e2-480b-bb64-6d2f436ffa6f	2025-06-21 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-18 23:08:31.645+00	2026-01-18 23:16:35.528+00	t	\N	COMERCIAL	60	6abcf5ef-ae58-4e8c-ae86-335d1478ee3c
3e6c3a44-c73f-428f-bc15-02cb35b6f777	2025	172	7d23c84f-115a-4318-9e29-aa24a4809280	1f5e5c39-7fd2-4fb1-8697-d5e0e9a4022b	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-10-23 14:05:00+00	2025-11-24 09:40:00+00	\N	AUTOMATICO	\N	\N	2026-01-08 09:40:00+00	2026-01-17 21:31:16.058+00	2026-01-18 16:04:13.256+00	t	\N	COMERCIAL	30	7c20bb25-01f0-48ad-99ac-5c3b6fe11aec
ca6ca4b9-876b-4003-bd21-2a5cdeb9cf0a	2025	109	2df50464-9916-4b3e-b5c3-3a645623d525	fedc5975-2697-4b57-b26d-492a64ef6cc8	2ea71871-f6e2-480b-bb64-6d2f436ffa6f	2025-06-23 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-18 23:09:12.474+00	2026-01-18 23:16:41.061+00	t	\N	COMERCIAL	60	e82e6994-7b2a-4fd4-a699-665a2c81d083
ca604291-5e1b-4dec-98df-82a55b73a147	2025	136	7d23c84f-115a-4318-9e29-aa24a4809280	1f5e5c39-7fd2-4fb1-8697-d5e0e9a4022b	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-07-31 13:05:00+00	2025-09-12 00:44:00+00	\N	AUTOMATICO	\N	\N	2025-10-27 00:44:00+00	2026-01-17 21:31:15.735+00	2026-01-18 16:08:14.941+00	t	\N	COMERCIAL	30	9ca0a15b-a857-4fab-9747-b620717776dd
52795b66-5ac8-41a0-9e5d-081ab92281e0	2025	115	4a837a56-b513-4568-b2d7-61bc1d66d22b	fedc5975-2697-4b57-b26d-492a64ef6cc8	2ea71871-f6e2-480b-bb64-6d2f436ffa6f	2025-07-08 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-18 23:09:52.282+00	2026-01-18 23:16:47.887+00	t	\N	COMERCIAL	30	b500d7bc-3760-4c88-9a21-4294b2395c71
525fac11-e408-44cb-a043-43d3ed0c5a43	2025	38	a16cce31-d12d-458a-b212-6846185933bf	1f5e5c39-7fd2-4fb1-8697-d5e0e9a4022b	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-03-06 13:02:00+00	2025-03-26 17:12:00+00	\N	AUTOMATICO	\N	\N	2025-05-10 17:12:00+00	2026-01-17 21:31:15.067+00	2026-01-18 16:14:38.838+00	t	\N	COMERCIAL	30	9ca0a15b-a857-4fab-9747-b620717776dd
e51d0bf4-6d91-4f27-a2f4-557099679f82	2025	120	af23e539-baa2-4cdd-9c30-b3126af01ce0	acea052d-e5d1-4ced-b98c-2d01eb79122a	2ea71871-f6e2-480b-bb64-6d2f436ffa6f	2025-07-11 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-18 23:10:59.755+00	2026-01-18 23:16:52.911+00	t	\N	COMERCIAL	30	e148f60c-2aeb-442f-b302-491f4e0eca2b
32bfea20-71c1-4832-9f5f-09b9a0ee1edc	2025	173	04b53087-52e8-4656-be93-714c343c47d6	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-10-30 08:05:00+00	2025-11-19 07:17:00+00	\N	AUTOMATICO	\N	\N	2026-01-03 07:17:00+00	2026-01-17 21:31:16.073+00	2026-01-17 21:31:16.073+00	t	\N	COMERCIAL	60	d88e7e56-7d2c-4edc-aef4-f61e755c586a
391add8f-3134-4e53-9367-f5a7764b3b24	2025	17	ba0b91e3-29d6-4028-acb8-c8256fa2aaf8	57d68d17-afe4-47b5-baf5-4e4791069319	2ea71871-f6e2-480b-bb64-6d2f436ffa6f	2025-01-17 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-18 22:56:00.758+00	2026-01-18 23:01:35.176+00	t	\N	COMERCIAL	40	b33fd685-31a6-4510-a970-09a2d428a1bb
9454fc29-d82f-49bb-b91c-653d5e025262	2025	123	c6c6fcdc-e445-4e60-8a3f-a70b8e33aab7	acea052d-e5d1-4ced-b98c-2d01eb79122a	2ea71871-f6e2-480b-bb64-6d2f436ffa6f	2025-07-19 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-18 23:11:35.016+00	2026-01-18 23:16:57.778+00	t	\N	COMERCIAL	60	372bbb60-ca31-49ff-9ef9-fd5d49beb720
3bdea548-8948-49d9-b143-da80881041a3	2025	39	adc23180-9487-47ad-9e3d-62eade83623a	1f5e5c39-7fd2-4fb1-8697-d5e0e9a4022b	2ea71871-f6e2-480b-bb64-6d2f436ffa6f	2025-03-06 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-18 23:03:39.655+00	2026-01-18 23:15:32.173+00	t	\N	COMERCIAL	30	b9333c64-fa8a-4d22-971b-8447d9cec902
7423dc3b-41f8-4168-9a76-44e80eb6b85d	2025	125	66098466-a6dd-4982-8347-335fe023e588	fedc5975-2697-4b57-b26d-492a64ef6cc8	2ea71871-f6e2-480b-bb64-6d2f436ffa6f	2025-07-18 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-18 23:12:47.505+00	2026-01-18 23:17:02.579+00	t	\N	COMERCIAL	30	e148f60c-2aeb-442f-b302-491f4e0eca2b
c5fe963a-7da5-4c98-9d7c-d9113050fdfe	2026	130	34a96d23-cf3a-4eea-b136-56b64fa5239c	acea052d-e5d1-4ced-b98c-2d01eb79122a	3af8b7d1-f41d-4029-83ae-ef5e178ff565	2025-07-22 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-18 23:14:15.899+00	2026-01-18 23:14:15.899+00	t	\N	COMERCIAL	60	b500d7bc-3760-4c88-9a21-4294b2395c71
fd32e256-3a58-4b30-9706-6c293fd32ff2	2025	85	b88d3a8d-a83a-4a6b-a566-85bf97fb3fb7	acea052d-e5d1-4ced-b98c-2d01eb79122a	2ea71871-f6e2-480b-bb64-6d2f436ffa6f	2025-05-20 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-18 23:05:06.677+00	2026-01-18 23:15:43.517+00	t	\N	COMERCIAL	60	fb61c911-79f8-45ed-8e0e-23bfa3a9ad2b
11612246-9e7f-413a-87c8-f76054478acd	2025	92	66098466-a6dd-4982-8347-335fe023e588	fedc5975-2697-4b57-b26d-492a64ef6cc8	2ea71871-f6e2-480b-bb64-6d2f436ffa6f	2025-05-29 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-18 23:06:10.778+00	2026-01-18 23:15:56.558+00	t	\N	COMERCIAL	30	6abcf5ef-ae58-4e8c-ae86-335d1478ee3c
790cc62b-34f2-470f-aa00-f462a23b4bb4	2024	147	49144ac0-7330-40cf-8ed7-3dd909542a0e	1f5e5c39-7fd2-4fb1-8697-d5e0e9a4022b	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-10-31 00:16:00+00	2024-11-26 20:20:00+00	\N	AUTOMATICO	\N	\N	2025-01-10 20:20:00+00	2026-01-17 21:31:13.734+00	2026-01-17 21:31:13.734+00	t	\N	COMERCIAL	30	a8bff414-46d6-4502-9537-eeda82ec5fa8
86bb8d63-7f71-472e-afa6-6e2fe37ff081	2024	156	56ea7c96-54cb-4759-ba2a-74dd8a4fe0a2	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-11-01 16:38:00+00	2024-11-07 08:00:00+00	\N	AUTOMATICO	\N	\N	2024-12-22 08:00:00+00	2026-01-17 21:31:13.742+00	2026-01-17 21:31:13.742+00	t	\N	COMERCIAL	30	1f6c3850-8006-4a96-a8b9-96c068b8dbee
5a4d18cd-966c-41c8-94fc-4eb834cbcb4f	2024	166	196d90c9-4a16-4fac-98ca-948f955d17d2	1f5e5c39-7fd2-4fb1-8697-d5e0e9a4022b	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-11-20 07:15:00+00	2024-12-10 13:30:00+00	\N	AUTOMATICO	\N	\N	2025-01-24 13:30:00+00	2026-01-17 21:31:13.75+00	2026-01-17 21:31:13.75+00	t	\N	COMERCIAL	30	8ced3542-9444-4153-b141-27ed65a5995b
4f41563b-a778-4d8e-97ce-1fbaa60bf4eb	2024	6	196d90c9-4a16-4fac-98ca-948f955d17d2	1f5e5c39-7fd2-4fb1-8697-d5e0e9a4022b	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-10-03 20:30:00+00	2024-10-29 12:55:00+00	\N	AUTOMATICO	\N	\N	2024-12-13 12:55:00+00	2026-01-17 21:31:13.757+00	2026-01-17 21:31:13.757+00	t	\N	CI	30	7210834c-47be-440a-81d2-a5fc53a8934b
f288f24a-3e1c-4257-9af9-53288b123f02	2024	145	e70330eb-bcaf-472c-9906-1096de4235dd	1f5e5c39-7fd2-4fb1-8697-d5e0e9a4022b	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-10-28 20:10:00+00	2024-11-22 06:00:00+00	\N	AUTOMATICO	\N	\N	2025-01-06 06:00:00+00	2026-01-17 21:31:13.766+00	2026-01-17 21:31:13.766+00	t	\N	COMERCIAL	30	e148f60c-2aeb-442f-b302-491f4e0eca2b
71d876df-245a-444b-8bf8-8fdf9427d9f6	2024	138	863ff4de-02ab-477a-b726-83d3e9148648	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-09-05 12:26:00+00	2024-09-25 08:50:00+00	\N	AUTOMATICO	\N	\N	2024-11-09 08:50:00+00	2026-01-17 21:31:13.774+00	2026-01-17 21:31:13.774+00	t	\N	COMERCIAL	60	df1d26fb-7984-43c7-8831-6c8fa0d6b4f5
9b1af2f9-4566-4622-a677-fefa8daa7455	2024	47	69ff7a7d-9417-4f5c-9693-8e2835fef39b	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-03-26 22:35:00+00	2024-05-15 23:00:00+00	\N	AUTOMATICO	\N	\N	2024-06-29 23:00:00+00	2026-01-17 21:31:13.783+00	2026-01-17 21:31:13.783+00	t	\N	COMERCIAL	60	d88e7e56-7d2c-4edc-aef4-f61e755c586a
2c3e50f2-80fa-4235-8ea5-479884e5badb	2024	78	69ff7a7d-9417-4f5c-9693-8e2835fef39b	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-05-17 18:30:00+00	2024-07-02 05:25:00+00	\N	AUTOMATICO	\N	\N	2024-08-16 05:25:00+00	2026-01-17 21:31:13.791+00	2026-01-17 21:31:13.791+00	t	\N	COMERCIAL	60	d88e7e56-7d2c-4edc-aef4-f61e755c586a
6e638471-4781-4546-84a6-a74de5ce8be5	2024	7	4a837a56-b513-4568-b2d7-61bc1d66d22b	fedc5975-2697-4b57-b26d-492a64ef6cc8	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-01-03 19:15:00+00	2024-01-23 13:30:00+00	\N	AUTOMATICO	\N	\N	2024-03-08 13:30:00+00	2026-01-17 21:31:13.8+00	2026-01-17 21:31:13.8+00	t	\N	COMERCIAL	30	d1d949b7-00fd-4756-8021-bc80d98ecf71
98ff9c03-9728-47f8-8173-870ffe061b51	2024	26	0ddb5663-8ab9-4ad5-ab76-fb98b2e5d15d	fedc5975-2697-4b57-b26d-492a64ef6cc8	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-02-16 18:45:00+00	2024-03-24 14:45:00+00	\N	AUTOMATICO	\N	\N	2024-05-08 14:45:00+00	2026-01-17 21:31:13.808+00	2026-01-17 21:31:13.808+00	t	\N	COMERCIAL	40	d1d949b7-00fd-4756-8021-bc80d98ecf71
04ebbeee-f08e-4ae1-8035-f5241f6ee33c	2024	49	0ddb5663-8ab9-4ad5-ab76-fb98b2e5d15d	fedc5975-2697-4b57-b26d-492a64ef6cc8	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-03-28 17:55:00+00	2024-05-09 21:45:00+00	\N	AUTOMATICO	\N	\N	2024-06-23 21:45:00+00	2026-01-17 21:31:13.817+00	2026-01-17 21:31:13.817+00	t	\N	COMERCIAL	40	d1d949b7-00fd-4756-8021-bc80d98ecf71
98d2d67b-09ec-4038-a941-d5710411fc05	2024	101	0ddb5663-8ab9-4ad5-ab76-fb98b2e5d15d	fedc5975-2697-4b57-b26d-492a64ef6cc8	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-06-26 22:10:00+00	2024-08-07 15:00:00+00	\N	AUTOMATICO	\N	\N	2024-09-21 15:00:00+00	2026-01-17 21:31:13.825+00	2026-01-17 21:31:13.825+00	t	\N	COMERCIAL	40	d1d949b7-00fd-4756-8021-bc80d98ecf71
ff8f6af0-a796-4c89-ad9d-314b7ce1c8d8	2024	60	5fa98bd7-f095-4d3e-8e98-7761568ec108	fedc5975-2697-4b57-b26d-492a64ef6cc8	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-04-19 12:00:00+00	2024-05-13 18:04:00+00	\N	AUTOMATICO	\N	\N	2024-06-27 18:04:00+00	2026-01-17 21:31:13.833+00	2026-01-17 21:31:13.833+00	t	\N	COMERCIAL	45	4d019608-ebd1-4e3c-95eb-e9a505274ae9
ac4bf302-24a6-485d-a1a7-309c2342d3f5	2024	79	5fa98bd7-f095-4d3e-8e98-7761568ec108	fedc5975-2697-4b57-b26d-492a64ef6cc8	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-05-16 18:20:00+00	2024-06-05 07:54:00+00	\N	AUTOMATICO	\N	\N	2024-07-20 07:54:00+00	2026-01-17 21:31:13.841+00	2026-01-17 21:31:13.841+00	t	\N	COMERCIAL	45	4d019608-ebd1-4e3c-95eb-e9a505274ae9
39282870-0c57-4bda-9358-be22d04d0d20	2023	167	adc23180-9487-47ad-9e3d-62eade83623a	1f5e5c39-7fd2-4fb1-8697-d5e0e9a4022b	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2023-12-30 16:20:00+00	2024-02-01 21:15:00+00	\N	AUTOMATICO	\N	\N	2024-03-17 21:15:00+00	2026-01-17 21:31:13.849+00	2026-01-17 21:31:13.849+00	t	\N	COMERCIAL	30	e148f60c-2aeb-442f-b302-491f4e0eca2b
fcc06c4a-b1d5-46f4-a943-e9b4ff52a069	2024	55	37fb0bff-71cf-474c-ac99-dfe32eb068d3	fedc5975-2697-4b57-b26d-492a64ef6cc8	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-03-27 17:15:00+00	2024-04-14 07:49:00+00	\N	AUTOMATICO	\N	\N	2024-05-29 07:49:00+00	2026-01-17 21:31:13.856+00	2026-01-17 21:31:13.856+00	t	\N	COMERCIAL	\N	e148f60c-2aeb-442f-b302-491f4e0eca2b
c2e7ef07-c76b-4f6b-8dc6-153062b64f1b	2024	89	37fb0bff-71cf-474c-ac99-dfe32eb068d3	fedc5975-2697-4b57-b26d-492a64ef6cc8	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-05-22 17:05:00+00	2024-06-02 17:05:00+00	\N	AUTOMATICO	\N	\N	2024-07-17 17:05:00+00	2026-01-17 21:31:13.864+00	2026-01-17 21:31:13.864+00	t	\N	COMERCIAL	\N	e148f60c-2aeb-442f-b302-491f4e0eca2b
4653b095-9a0d-4b35-8f85-ec87c0be1399	2024	45	546c200e-da22-4c78-8c7d-cbdeab4535cd	57d68d17-afe4-47b5-baf5-4e4791069319	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-03-21 10:05:00+00	2024-04-16 15:40:00+00	\N	AUTOMATICO	\N	\N	2024-05-31 15:40:00+00	2026-01-17 21:31:13.872+00	2026-01-17 21:31:13.872+00	t	\N	COMERCIAL	40	0ba0a4ea-eaa3-4d11-b737-5f80e0651fb5
f18d88c6-3877-4252-9eed-2ad5fd9011fe	2023	165	8efda3ce-fc8d-49b0-8e1b-74751bb52960	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2023-12-29 15:30:00+00	2024-01-29 02:25:00+00	\N	AUTOMATICO	\N	\N	2024-03-14 02:25:00+00	2026-01-17 21:31:13.881+00	2026-01-17 21:31:13.881+00	t	\N	COMERCIAL	\N	c8fdee90-2d16-4800-8a4d-e6b470cf152d
d91a3eb7-7b10-49d9-819f-687656fd12e4	2024	29	56ea7c96-54cb-4759-ba2a-74dd8a4fe0a2	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-02-19 16:20:00+00	2024-02-23 08:03:00+00	\N	AUTOMATICO	\N	\N	2024-04-08 08:03:00+00	2026-01-17 21:31:13.888+00	2026-01-17 21:31:13.888+00	t	\N	COMERCIAL	30	c8fdee90-2d16-4800-8a4d-e6b470cf152d
e5846c98-42ce-4b54-915c-84ab4fbb1f3f	2024	41	9a35efaa-cc4c-4fb6-afaa-f48e7709c800	57d68d17-afe4-47b5-baf5-4e4791069319	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-03-06 18:55:00+00	2024-04-16 11:04:00+00	\N	AUTOMATICO	\N	\N	2024-05-31 11:04:00+00	2026-01-17 21:31:13.895+00	2026-01-17 21:31:13.895+00	t	\N	COMERCIAL	40	c8fdee90-2d16-4800-8a4d-e6b470cf152d
fc6c5995-b96c-462e-a0b0-c45c2a58c92c	2024	86	5aea6ce4-ca56-4bb7-83dc-071dd9161524	fedc5975-2697-4b57-b26d-492a64ef6cc8	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-05-23 23:18:00+00	2024-06-05 06:32:00+00	\N	AUTOMATICO	\N	\N	2024-07-20 06:32:00+00	2026-01-17 21:31:13.904+00	2026-01-17 21:31:13.904+00	t	\N	COMERCIAL	30	c8fdee90-2d16-4800-8a4d-e6b470cf152d
c5a2a674-c908-4d03-bb9e-ed695854c91b	2023	157	69ff7a7d-9417-4f5c-9693-8e2835fef39b	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2023-11-30 23:00:00+00	2024-02-06 05:38:00+00	\N	AUTOMATICO	\N	\N	2024-03-22 05:38:00+00	2026-01-17 21:31:13.912+00	2026-01-17 21:31:13.912+00	t	\N	COMERCIAL	60	66d4eb59-5d54-446b-9ee0-88fa9c133899
b8fb446b-ca68-4d0b-acbc-bc9f395a22be	2024	44	4a837a56-b513-4568-b2d7-61bc1d66d22b	fedc5975-2697-4b57-b26d-492a64ef6cc8	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-03-14 14:41:00+00	2024-04-16 12:43:00+00	\N	AUTOMATICO	\N	\N	2024-05-31 12:43:00+00	2026-01-17 21:31:13.92+00	2026-01-17 21:31:13.92+00	t	\N	COMERCIAL	30	66d4eb59-5d54-446b-9ee0-88fa9c133899
a15d1b4d-e699-4e4b-98ea-a005115cf2fa	2024	63	4a837a56-b513-4568-b2d7-61bc1d66d22b	fedc5975-2697-4b57-b26d-492a64ef6cc8	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-04-20 13:20:00+00	2024-05-22 08:43:00+00	\N	AUTOMATICO	\N	\N	2024-07-06 08:43:00+00	2026-01-17 21:31:13.927+00	2026-01-17 21:31:13.927+00	t	\N	COMERCIAL	30	66d4eb59-5d54-446b-9ee0-88fa9c133899
7ad4d9b6-f2d8-4f2e-a135-0aa268bba021	2024	98	e157b89c-77da-4efc-936a-642f986b9147	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-06-18 19:47:00+00	2024-06-29 11:58:00+00	\N	AUTOMATICO	\N	\N	2024-08-13 11:58:00+00	2026-01-17 21:31:13.935+00	2026-01-17 21:31:13.935+00	t	\N	COMERCIAL	30	66d4eb59-5d54-446b-9ee0-88fa9c133899
6f5dddac-436f-4846-bf6d-2b34f7d2e046	2026	1	863ff4de-02ab-477a-b726-83d3e9148648	acea052d-e5d1-4ced-b98c-2d01eb79122a	97219917-fdf2-4aca-b415-96de17cc505e	\N	2026-01-03 17:30:00+00	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-17 21:31:16.387+00	2026-01-17 21:31:16.387+00	t	\N	COMERCIAL	60	ba8ec778-639d-4dcd-9db2-d7100c84e8f5
6680accc-6af4-4d54-9e60-ae7a16f5d3ea	2025	192	8fbf968b-b9aa-4316-ac14-c65ecb2bc56b	57d68d17-afe4-47b5-baf5-4e4791069319	97219917-fdf2-4aca-b415-96de17cc505e	\N	2025-12-29 00:00:00+00	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-17 21:31:16.393+00	2026-01-17 21:31:16.393+00	t	\N	COMERCIAL	40	1f6c3850-8006-4a96-a8b9-96c068b8dbee
0ced05ba-d9e9-409f-b2e0-320f664db7fd	2026	2	8e64df56-3b39-4321-8c31-98bff1ad28b3	acea052d-e5d1-4ced-b98c-2d01eb79122a	97219917-fdf2-4aca-b415-96de17cc505e	\N	2026-01-05 00:00:00+00	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-17 21:31:16.401+00	2026-01-17 21:31:16.401+00	t	\N	COMERCIAL	60	06979c36-da6e-4fb0-840e-07533a1d41c7
73e7be2d-d116-4a9f-b4d0-6ca2b40896a8	2024	129	5fa98bd7-f095-4d3e-8e98-7761568ec108	fedc5975-2697-4b57-b26d-492a64ef6cc8	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-08-14 22:32:00+00	2024-09-03 07:18:00+00	\N	AUTOMATICO	\N	\N	2024-10-18 07:18:00+00	2026-01-17 21:31:13.942+00	2026-01-17 21:31:13.942+00	t	\N	COMERCIAL	45	66d4eb59-5d54-446b-9ee0-88fa9c133899
4d043d8d-83c9-4429-ae2e-330feea0d166	2024	139	5fa98bd7-f095-4d3e-8e98-7761568ec108	fedc5975-2697-4b57-b26d-492a64ef6cc8	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-09-05 14:10:00+00	2024-10-10 08:43:00+00	\N	AUTOMATICO	\N	\N	2024-11-24 08:43:00+00	2026-01-17 21:31:13.95+00	2026-01-17 21:31:13.95+00	t	\N	COMERCIAL	45	66d4eb59-5d54-446b-9ee0-88fa9c133899
48ad14c2-66fc-4547-b0a0-75f8ec3452f5	2023	163	196d90c9-4a16-4fac-98ca-948f955d17d2	1f5e5c39-7fd2-4fb1-8697-d5e0e9a4022b	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2023-12-30 12:50:00+00	2024-02-03 21:20:00+00	\N	AUTOMATICO	\N	\N	2024-03-19 21:20:00+00	2026-01-17 21:31:13.957+00	2026-01-17 21:31:13.957+00	t	\N	COMERCIAL	30	a8bff414-46d6-4502-9537-eeda82ec5fa8
a133d62b-cef6-42f6-8fe8-e9de6681e91b	2024	32	a16cce31-d12d-458a-b212-6846185933bf	1f5e5c39-7fd2-4fb1-8697-d5e0e9a4022b	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-02-23 19:20:00+00	2024-03-21 08:10:00+00	\N	AUTOMATICO	\N	\N	2024-05-05 08:10:00+00	2026-01-17 21:31:13.965+00	2026-01-17 21:31:13.965+00	t	\N	COMERCIAL	30	a8bff414-46d6-4502-9537-eeda82ec5fa8
a5e25e55-470f-4c95-ab7a-4b71d272b8f3	2024	67	56ea7c96-54cb-4759-ba2a-74dd8a4fe0a2	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-04-29 17:02:00+00	2024-05-12 06:35:00+00	\N	AUTOMATICO	\N	\N	2024-06-26 06:35:00+00	2026-01-17 21:31:13.973+00	2026-01-17 21:31:13.973+00	t	\N	COMERCIAL	30	a8bff414-46d6-4502-9537-eeda82ec5fa8
aaafd387-c375-4978-922e-e08c3dfdf4a3	2024	118	bf9011e3-436b-477e-adc9-5fdf755c9b63	fedc5975-2697-4b57-b26d-492a64ef6cc8	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-07-28 17:54:00+00	2024-08-07 10:50:00+00	\N	AUTOMATICO	\N	\N	2024-09-21 10:50:00+00	2026-01-17 21:31:13.981+00	2026-01-17 21:31:13.981+00	t	\N	COMERCIAL	30	a8bff414-46d6-4502-9537-eeda82ec5fa8
ffb110ad-dd2a-45c3-a118-d5804de758b8	2024	15	2df50464-9916-4b3e-b5c3-3a645623d525	fedc5975-2697-4b57-b26d-492a64ef6cc8	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-01-10 13:50:00+00	2024-02-18 14:06:00+00	\N	AUTOMATICO	\N	\N	2024-04-03 14:06:00+00	2026-01-17 21:31:13.989+00	2026-01-17 21:31:13.989+00	t	\N	COMERCIAL	60	9a9b3bcd-4b8f-4aba-8ea5-3ec890e23fee
a1aa4e4f-f2b6-4910-bf54-93f0e7b7014c	2024	36	2df50464-9916-4b3e-b5c3-3a645623d525	fedc5975-2697-4b57-b26d-492a64ef6cc8	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-02-22 20:45:00+00	2024-04-04 07:46:00+00	\N	AUTOMATICO	\N	\N	2024-05-19 07:46:00+00	2026-01-17 21:31:13.997+00	2026-01-17 21:31:13.997+00	t	\N	COMERCIAL	60	9a9b3bcd-4b8f-4aba-8ea5-3ec890e23fee
f49de315-ea20-4c72-9376-7a26db6b2ed8	2024	57	2df50464-9916-4b3e-b5c3-3a645623d525	fedc5975-2697-4b57-b26d-492a64ef6cc8	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-04-08 11:05:00+00	2024-05-30 10:07:00+00	\N	AUTOMATICO	\N	\N	2024-07-14 10:07:00+00	2026-01-17 21:31:14.005+00	2026-01-17 21:31:14.005+00	t	\N	COMERCIAL	60	9a9b3bcd-4b8f-4aba-8ea5-3ec890e23fee
5fbe62ae-8105-49a1-84e5-5b81f209776d	2024	115	2df50464-9916-4b3e-b5c3-3a645623d525	fedc5975-2697-4b57-b26d-492a64ef6cc8	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-07-26 14:32:00+00	2024-09-11 09:37:00+00	\N	AUTOMATICO	\N	\N	2024-10-26 09:37:00+00	2026-01-17 21:31:14.012+00	2026-01-17 21:31:14.012+00	t	\N	COMERCIAL	60	9a9b3bcd-4b8f-4aba-8ea5-3ec890e23fee
8f5a12a1-3780-43d5-b7e2-f9f57634c032	2024	4	82d93396-176a-4d74-a5de-5addaf47520f	57d68d17-afe4-47b5-baf5-4e4791069319	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-01-08 10:57:00+00	2024-02-01 05:21:00+00	\N	AUTOMATICO	\N	\N	2024-03-17 05:21:00+00	2026-01-17 21:31:14.021+00	2026-01-17 21:31:14.021+00	t	\N	COMERCIAL	40	ea89e630-34ba-4705-98d9-8b662af90e3c
e1166e1f-e00f-416a-b261-2a97c40e6b23	2024	100	649e5ded-9a48-4bf8-aaa1-2edf147fe587	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-07-06 12:20:00+00	2024-07-14 12:54:00+00	\N	AUTOMATICO	\N	\N	2024-08-28 12:54:00+00	2026-01-17 21:31:14.03+00	2026-01-17 21:31:14.03+00	t	\N	COMERCIAL	30	ea89e630-34ba-4705-98d9-8b662af90e3c
6e9effd2-5b3f-44dd-b304-cafce82bb49d	2024	2	2df50464-9916-4b3e-b5c3-3a645623d525	fedc5975-2697-4b57-b26d-492a64ef6cc8	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-01-06 15:49:00+00	2024-01-08 20:15:00+00	\N	AUTOMATICO	\N	\N	2024-02-22 20:15:00+00	2026-01-17 21:31:14.039+00	2026-01-17 21:31:14.039+00	t	\N	COMERCIAL	60	df1d26fb-7984-43c7-8831-6c8fa0d6b4f5
41cd7cc2-7087-44c2-aeba-b76145a048e0	2024	42	c7c5892b-d6ee-4b44-b3a6-24dc9ded90aa	57d68d17-afe4-47b5-baf5-4e4791069319	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-03-14 15:32:00+00	2024-04-22 09:00:00+00	\N	AUTOMATICO	\N	\N	2024-06-06 09:00:00+00	2026-01-17 21:31:14.047+00	2026-01-17 21:31:14.047+00	t	\N	COMERCIAL	40	df1d26fb-7984-43c7-8831-6c8fa0d6b4f5
1a98c017-8f47-4970-825c-2725c6ec292b	2023	154	7d23c84f-115a-4318-9e29-aa24a4809280	1f5e5c39-7fd2-4fb1-8697-d5e0e9a4022b	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2023-12-07 22:50:00+00	2024-01-14 10:25:00+00	\N	AUTOMATICO	\N	\N	2024-02-28 10:25:00+00	2026-01-17 21:31:14.055+00	2026-01-17 21:31:14.055+00	t	\N	COMERCIAL	30	a21b30af-c563-4c43-9d68-bafd0243c5e6
9fc1b93f-4239-48ee-a433-e449a87412ce	2024	37	04b53087-52e8-4656-be93-714c343c47d6	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-02-29 21:05:00+00	2024-04-09 02:50:00+00	\N	AUTOMATICO	\N	\N	2024-05-24 02:50:00+00	2026-01-17 21:31:14.063+00	2026-01-17 21:31:14.063+00	t	\N	COMERCIAL	60	a21b30af-c563-4c43-9d68-bafd0243c5e6
5f747fdc-f223-4f3e-ae8f-620f80e95aa9	2024	82	64782920-6598-4760-ba21-7ead251ff1e1	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-05-22 15:40:00+00	2024-06-11 10:10:00+00	\N	AUTOMATICO	\N	\N	2024-07-26 10:10:00+00	2026-01-17 21:31:14.072+00	2026-01-17 21:31:14.072+00	t	\N	COMERCIAL	\N	a21b30af-c563-4c43-9d68-bafd0243c5e6
931a55f5-dd14-4d7a-86d9-63145e4562ce	2024	10	83a5f4d8-12bb-48e4-8b31-6fda9cd9eb5f	57d68d17-afe4-47b5-baf5-4e4791069319	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-01-09 18:45:00+00	2024-02-11 09:08:00+00	\N	AUTOMATICO	\N	\N	2024-03-27 09:08:00+00	2026-01-17 21:31:14.079+00	2026-01-17 21:31:14.079+00	t	\N	COMERCIAL	40	b6df959e-faf0-4d11-a4a3-9795c56105d4
660894c9-79ec-4569-8eee-55d151bfb915	2024	30	83a5f4d8-12bb-48e4-8b31-6fda9cd9eb5f	57d68d17-afe4-47b5-baf5-4e4791069319	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-02-14 18:40:00+00	2024-03-17 08:00:00+00	\N	AUTOMATICO	\N	\N	2024-05-01 08:00:00+00	2026-01-17 21:31:14.086+00	2026-01-17 21:31:14.086+00	t	\N	COMERCIAL	40	b6df959e-faf0-4d11-a4a3-9795c56105d4
d88782e8-957f-45f1-b052-be1be632650a	2024	18	49144ac0-7330-40cf-8ed7-3dd909542a0e	1f5e5c39-7fd2-4fb1-8697-d5e0e9a4022b	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-02-03 18:25:00+00	2024-03-06 18:20:00+00	\N	AUTOMATICO	\N	\N	2024-04-20 18:20:00+00	2026-01-17 21:31:14.093+00	2026-01-17 21:31:14.093+00	t	\N	COMERCIAL	30	458ab479-cec1-4ab1-ac65-362875121109
c643bb24-15ff-4562-a7df-5213b71a2a3c	2024	111	07acb95b-f5c8-4ed4-b6d7-d69ae4ba57ad	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-07-13 09:00:00+00	2024-08-20 06:07:00+00	\N	AUTOMATICO	\N	\N	2024-10-04 06:07:00+00	2026-01-17 21:31:14.102+00	2026-01-17 21:31:14.102+00	t	\N	COMERCIAL	60	458ab479-cec1-4ab1-ac65-362875121109
a3925499-5d96-442f-bf17-5ec4b9847a3b	2024	8	c7c5892b-d6ee-4b44-b3a6-24dc9ded90aa	57d68d17-afe4-47b5-baf5-4e4791069319	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-01-09 11:53:00+00	2024-02-05 18:37:00+00	\N	AUTOMATICO	\N	\N	2024-03-21 18:37:00+00	2026-01-17 21:31:14.109+00	2026-01-17 21:31:14.109+00	t	\N	COMERCIAL	40	7210834c-47be-440a-81d2-a5fc53a8934b
f4567039-49af-49b5-b976-1b3ad11a0060	2024	68	e7ed7f8b-9e82-48db-94f1-c9c63d3391eb	57d68d17-afe4-47b5-baf5-4e4791069319	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-04-30 18:40:00+00	2024-05-16 00:00:00+00	\N	AUTOMATICO	\N	\N	2024-06-30 00:00:00+00	2026-01-17 21:31:14.117+00	2026-01-17 21:31:14.117+00	t	\N	COMERCIAL	40	7210834c-47be-440a-81d2-a5fc53a8934b
083ee690-9c5d-4210-afee-9837772fb42c	2024	92	face2a5f-184c-41f8-b3a8-9beebc3635ee	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-05-29 17:45:00+00	2024-06-29 17:05:00+00	\N	AUTOMATICO	\N	\N	2024-08-13 17:05:00+00	2026-01-17 21:31:14.124+00	2026-01-17 21:31:14.124+00	t	\N	COMERCIAL	60	7210834c-47be-440a-81d2-a5fc53a8934b
8836e79f-d707-4f13-a88f-34f778687995	2024	148	196d90c9-4a16-4fac-98ca-948f955d17d2	1f5e5c39-7fd2-4fb1-8697-d5e0e9a4022b	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-10-27 23:30:00+00	2024-10-29 15:55:00+00	\N	AUTOMATICO	\N	\N	2024-12-13 15:55:00+00	2026-01-17 21:31:14.133+00	2026-01-17 21:31:14.133+00	t	\N	COMERCIAL	30	7210834c-47be-440a-81d2-a5fc53a8934b
ec5c3dff-621d-4a7b-9ecc-b7c40fe6243f	2023	162	e70330eb-bcaf-472c-9906-1096de4235dd	1f5e5c39-7fd2-4fb1-8697-d5e0e9a4022b	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2023-12-30 12:30:00+00	2024-02-03 20:47:00+00	\N	AUTOMATICO	\N	\N	2024-03-19 20:47:00+00	2026-01-17 21:31:14.141+00	2026-01-17 21:31:14.141+00	t	\N	COMERCIAL	30	df1d26fb-7984-43c7-8831-6c8fa0d6b4f5
9710cc6b-acba-47be-9e6e-d8eb493af822	2024	74	f66cbd4a-6e7c-4e91-a8e8-4c5e5542dae1	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-05-10 13:25:00+00	2024-06-14 19:30:00+00	\N	AUTOMATICO	\N	\N	2024-07-29 19:30:00+00	2026-01-17 21:31:14.15+00	2026-01-17 21:31:14.15+00	t	\N	COMERCIAL	60	cded2d3e-5f9e-4de6-9269-a1da3eeeff0a
97d0ea61-1676-43ef-bf16-417d28e9aaa7	2024	108	b88d3a8d-a83a-4a6b-a566-85bf97fb3fb7	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-07-10 19:19:00+00	2024-08-09 18:50:00+00	\N	AUTOMATICO	\N	\N	2024-09-23 18:50:00+00	2026-01-17 21:31:14.16+00	2026-01-17 21:31:14.16+00	t	\N	COMERCIAL	60	cded2d3e-5f9e-4de6-9269-a1da3eeeff0a
71dd9b9e-0e5d-43fc-95c9-d5a6f8b7628d	2024	76	73c502e2-397a-499f-b4f7-cb8dce8260b7	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-05-11 13:50:00+00	2024-05-20 11:37:00+00	\N	AUTOMATICO	\N	\N	2024-07-04 11:37:00+00	2026-01-17 21:31:14.168+00	2026-01-17 21:31:14.168+00	t	\N	COMERCIAL	30	6abcf5ef-ae58-4e8c-ae86-335d1478ee3c
5875eb9a-b82e-4600-96aa-055f428891b6	2024	126	28951b47-241f-46bb-9aa3-97f42bd51686	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-08-07 11:38:00+00	2024-08-15 00:52:00+00	\N	AUTOMATICO	\N	\N	2024-09-29 00:52:00+00	2026-01-17 21:31:14.177+00	2026-01-17 21:31:14.177+00	t	\N	COMERCIAL	30	6abcf5ef-ae58-4e8c-ae86-335d1478ee3c
ae796a8c-4350-452d-bfa6-6b77dbc8bfad	2024	150	04b53087-52e8-4656-be93-714c343c47d6	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-09-30 00:45:00+00	2024-10-29 23:51:00+00	\N	AUTOMATICO	\N	\N	2024-12-13 23:51:00+00	2026-01-17 21:31:14.186+00	2026-01-17 21:31:14.186+00	t	\N	COMERCIAL	60	6abcf5ef-ae58-4e8c-ae86-335d1478ee3c
04e8f3de-0742-4da7-8158-662ac3801ec5	2024	16	abfe526f-bf85-4dc2-89c7-557bfa93dbc3	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-01-17 15:00:00+00	2024-01-25 05:38:00+00	\N	AUTOMATICO	\N	\N	2024-03-10 05:38:00+00	2026-01-17 21:31:14.193+00	2026-01-17 21:31:14.193+00	t	\N	COMERCIAL	30	30fef00d-f9ee-4362-b430-5819b4bde400
0c171979-f122-4d6f-babc-c7087075176e	2024	64	cf8cfd8b-6f05-4ea9-af17-0426de2c550f	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-04-24 16:30:00+00	2024-05-04 17:08:00+00	\N	AUTOMATICO	\N	\N	2024-06-18 17:08:00+00	2026-01-17 21:31:14.201+00	2026-01-17 21:31:14.201+00	t	\N	COMERCIAL	30	30fef00d-f9ee-4362-b430-5819b4bde400
e6f73891-571b-4a76-b66b-55c6cbaa4faf	2024	142	246d498c-f08a-4cb4-a801-841d2f4d3df5	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-09-06 18:10:00+00	2024-09-13 17:00:00+00	\N	AUTOMATICO	\N	\N	2024-10-28 17:00:00+00	2026-01-17 21:31:14.208+00	2026-01-17 21:31:14.208+00	t	\N	COMERCIAL	30	30fef00d-f9ee-4362-b430-5819b4bde400
42a6786f-0b3f-4d79-9380-fd02f165c498	2024	167	649e5ded-9a48-4bf8-aaa1-2edf147fe587	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-12-03 16:49:00+00	2024-12-11 08:35:00+00	\N	AUTOMATICO	\N	\N	2025-01-25 08:35:00+00	2026-01-17 21:31:14.218+00	2026-01-17 21:31:14.218+00	t	\N	COMERCIAL	30	30fef00d-f9ee-4362-b430-5819b4bde400
2850ea5b-01df-461e-a24c-3f9415b724aa	2024	17	196d90c9-4a16-4fac-98ca-948f955d17d2	1f5e5c39-7fd2-4fb1-8697-d5e0e9a4022b	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-02-06 22:12:00+00	2024-02-23 08:25:00+00	\N	AUTOMATICO	\N	\N	2024-04-08 08:25:00+00	2026-01-17 21:31:14.228+00	2026-01-17 21:31:14.228+00	t	\N	COMERCIAL	30	7c20bb25-01f0-48ad-99ac-5c3b6fe11aec
a1fdd29f-6f3f-417c-a379-f6ff11cc3bc7	2024	59	04b53087-52e8-4656-be93-714c343c47d6	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-04-10 19:30:00+00	2024-04-13 20:34:00+00	\N	AUTOMATICO	\N	\N	2024-05-28 20:34:00+00	2026-01-17 21:31:14.236+00	2026-01-17 21:31:14.236+00	t	\N	COMERCIAL	60	7c20bb25-01f0-48ad-99ac-5c3b6fe11aec
39a26a14-74b7-48cc-a407-2d89a65f22f5	2024	102	bf9011e3-436b-477e-adc9-5fdf755c9b63	fedc5975-2697-4b57-b26d-492a64ef6cc8	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-06-26 12:00:00+00	2024-07-12 23:00:00+00	\N	AUTOMATICO	\N	\N	2024-08-26 23:00:00+00	2026-01-17 21:31:14.244+00	2026-01-17 21:31:14.244+00	t	\N	COMERCIAL	30	7c20bb25-01f0-48ad-99ac-5c3b6fe11aec
1ee93311-5973-4e68-b987-e387fbd314f2	2024	5	12964f37-2ef3-4932-9d34-b7ec4410c90b	57d68d17-afe4-47b5-baf5-4e4791069319	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-01-06 13:00:00+00	2024-01-31 23:50:00+00	\N	AUTOMATICO	\N	\N	2024-03-16 23:50:00+00	2026-01-17 21:31:14.252+00	2026-01-17 21:31:14.252+00	t	\N	COMERCIAL	40	df1d26fb-7984-43c7-8831-6c8fa0d6b4f5
15a5f229-bb4a-4cc5-a643-c7dc9114ae7a	2024	117	a1b563e1-607a-4532-8d14-0ecc7ee1fe20	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-07-28 17:59:00+00	2024-08-04 08:40:00+00	\N	AUTOMATICO	\N	\N	2024-09-18 08:40:00+00	2026-01-17 21:31:14.259+00	2026-01-17 21:31:14.259+00	t	\N	COMERCIAL	30	df1d26fb-7984-43c7-8831-6c8fa0d6b4f5
6bfb5856-619a-4c4c-9c53-f39abd0d8fbe	2024	140	a1b563e1-607a-4532-8d14-0ecc7ee1fe20	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-09-06 10:57:00+00	2024-09-13 07:08:00+00	\N	AUTOMATICO	\N	\N	2024-10-28 07:08:00+00	2026-01-17 21:31:14.267+00	2026-01-17 21:31:14.267+00	t	\N	COMERCIAL	30	df1d26fb-7984-43c7-8831-6c8fa0d6b4f5
a4008fa3-866a-48fa-9473-44f51d28e824	2023	159	49144ac0-7330-40cf-8ed7-3dd909542a0e	1f5e5c39-7fd2-4fb1-8697-d5e0e9a4022b	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2023-12-30 20:00:00+00	2024-01-30 20:00:00+00	\N	AUTOMATICO	\N	\N	2024-03-15 20:00:00+00	2026-01-17 21:31:14.274+00	2026-01-17 21:31:14.274+00	t	\N	COMERCIAL	30	e82e6994-7b2a-4fd4-a699-665a2c81d083
1b98b893-fa13-4f68-a34e-6c747a6640e1	2024	31	7d23c84f-115a-4318-9e29-aa24a4809280	1f5e5c39-7fd2-4fb1-8697-d5e0e9a4022b	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-02-26 23:10:00+00	2024-03-12 20:30:00+00	\N	AUTOMATICO	\N	\N	2024-04-26 20:30:00+00	2026-01-17 21:31:14.283+00	2026-01-17 21:31:14.283+00	t	\N	COMERCIAL	30	e82e6994-7b2a-4fd4-a699-665a2c81d083
aaaef184-4e9c-438e-a5fd-d6147a99b797	2024	65	c7c5892b-d6ee-4b44-b3a6-24dc9ded90aa	57d68d17-afe4-47b5-baf5-4e4791069319	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-04-25 18:11:00+00	2024-05-24 10:52:00+00	\N	AUTOMATICO	\N	\N	2024-07-08 10:52:00+00	2026-01-17 21:31:14.291+00	2026-01-17 21:31:14.291+00	t	\N	COMERCIAL	40	e82e6994-7b2a-4fd4-a699-665a2c81d083
ba85e27b-d69f-4b27-8d1e-44ef3497ecc5	2024	132	4a837a56-b513-4568-b2d7-61bc1d66d22b	fedc5975-2697-4b57-b26d-492a64ef6cc8	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-08-24 13:21:00+00	2024-09-27 08:17:00+00	\N	AUTOMATICO	\N	\N	2024-11-11 08:17:00+00	2026-01-17 21:31:14.299+00	2026-01-17 21:31:14.299+00	t	\N	COMERCIAL	30	e82e6994-7b2a-4fd4-a699-665a2c81d083
1c6328f4-771e-4088-975f-27f450b625ef	2024	165	4a837a56-b513-4568-b2d7-61bc1d66d22b	fedc5975-2697-4b57-b26d-492a64ef6cc8	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-11-15 16:53:00+00	2024-12-16 16:46:00+00	\N	AUTOMATICO	\N	\N	2025-01-30 16:46:00+00	2026-01-17 21:31:14.307+00	2026-01-17 21:31:14.307+00	t	\N	COMERCIAL	30	e82e6994-7b2a-4fd4-a699-665a2c81d083
bd6816fc-6cc4-40da-a94d-bf18acf313ad	2024	6	a16cce31-d12d-458a-b212-6846185933bf	1f5e5c39-7fd2-4fb1-8697-d5e0e9a4022b	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-01-06 08:40:00+00	2024-01-11 08:40:00+00	\N	AUTOMATICO	\N	\N	2024-02-25 08:40:00+00	2026-01-17 21:31:14.315+00	2026-01-17 21:31:14.315+00	t	\N	COMERCIAL	30	bf697cb0-a6fa-42ba-8b0a-5f27c9738ec9
e3f52376-56bd-4f89-a093-107b5a1c1e61	2024	77	0ddb5663-8ab9-4ad5-ab76-fb98b2e5d15d	fedc5975-2697-4b57-b26d-492a64ef6cc8	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-05-15 15:17:00+00	2024-06-23 11:40:00+00	\N	AUTOMATICO	\N	\N	2024-08-07 11:40:00+00	2026-01-17 21:31:14.323+00	2026-01-17 21:31:14.323+00	t	\N	COMERCIAL	40	f0a415e0-9538-4336-b681-9d23e0753e26
a14da35d-822e-4f88-a2c8-d2784ba2db91	2024	168	69ff7a7d-9417-4f5c-9693-8e2835fef39b	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-12-06 23:45:00+00	2025-02-04 04:35:00+00	\N	AUTOMATICO	\N	\N	2025-03-21 04:35:00+00	2026-01-17 21:31:14.329+00	2026-01-17 21:31:14.329+00	t	\N	COMERCIAL	60	f0a415e0-9538-4336-b681-9d23e0753e26
fa20f9ac-79a3-483c-8e3b-1d7c664244b9	2024	12	c82bf74e-e7d0-45f9-a472-82d0127b3694	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-01-13 13:30:00+00	2024-02-25 08:04:00+00	\N	AUTOMATICO	\N	\N	2024-04-10 08:04:00+00	2026-01-17 21:31:14.336+00	2026-01-17 21:31:14.336+00	t	\N	COMERCIAL	60	d7785cda-1f2e-4d29-a52d-335b2096bde6
f713edcb-c2f9-40c5-8fc6-dcf9f69c15e4	2024	52	1362f018-3a09-4fca-a2fe-bdf2b160e79a	fedc5975-2697-4b57-b26d-492a64ef6cc8	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-03-27 05:50:00+00	2024-04-13 17:30:00+00	\N	AUTOMATICO	\N	\N	2024-05-28 17:30:00+00	2026-01-17 21:31:14.343+00	2026-01-17 21:31:14.343+00	t	\N	COMERCIAL	30	d7785cda-1f2e-4d29-a52d-335b2096bde6
eb1adbfe-ece8-4b96-95eb-0fad3f4a452d	2024	72	a1b563e1-607a-4532-8d14-0ecc7ee1fe20	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-05-11 12:08:00+00	2024-05-22 12:06:00+00	\N	AUTOMATICO	\N	\N	2024-07-06 12:06:00+00	2026-01-17 21:31:14.351+00	2026-01-17 21:31:14.351+00	t	\N	COMERCIAL	30	d7785cda-1f2e-4d29-a52d-335b2096bde6
7ea24710-2630-4e67-96a7-ed638722270d	2024	128	face2a5f-184c-41f8-b3a8-9beebc3635ee	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-08-15 15:21:00+00	2024-09-14 09:30:00+00	\N	AUTOMATICO	\N	\N	2024-10-29 09:30:00+00	2026-01-17 21:31:14.358+00	2026-01-17 21:31:14.358+00	t	\N	COMERCIAL	60	d7785cda-1f2e-4d29-a52d-335b2096bde6
8fbdd4e5-081b-49bb-8233-4d2e7d91e0fe	2024	25	69ff7a7d-9417-4f5c-9693-8e2835fef39b	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-02-09 18:23:00+00	2024-03-18 02:20:00+00	\N	AUTOMATICO	\N	\N	2024-05-02 02:20:00+00	2026-01-17 21:31:14.365+00	2026-01-17 21:31:14.365+00	t	\N	COMERCIAL	60	02ed999f-1a0c-460a-8c38-0cc464af9b6f
96d5f474-06d9-4fcc-9112-d0002553408a	2026	7	69ff7a7d-9417-4f5c-9693-8e2835fef39b	acea052d-e5d1-4ced-b98c-2d01eb79122a	97219917-fdf2-4aca-b415-96de17cc505e	2026-01-15 03:00:00+00	2026-01-15 03:00:00+00	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-17 22:43:54.258+00	2026-01-17 22:44:23.744+00	t	\N	COMERCIAL	60	b6f9e1cc-7022-4f80-8f1d-a8392c9193df
6acfcdc1-ba2b-4b99-baab-146eb9ef1efd	2024	54	0956ea0a-4aa0-4aa0-a2ac-72e3732ff025	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-03-27 03:45:00+00	2024-04-27 18:56:00+00	\N	AUTOMATICO	\N	\N	2024-06-11 18:56:00+00	2026-01-17 21:31:14.372+00	2026-01-17 21:31:14.372+00	t	\N	COMERCIAL	60	02ed999f-1a0c-460a-8c38-0cc464af9b6f
c33db762-16e5-4002-8eb4-2827a953ecff	2024	85	d90139c7-b316-4228-8bea-b47432cf51e2	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-05-24 22:30:00+00	2024-05-29 09:40:00+00	\N	AUTOMATICO	\N	\N	2024-07-13 09:40:00+00	2026-01-17 21:31:14.379+00	2026-01-17 21:31:14.379+00	t	\N	COMERCIAL	30	02ed999f-1a0c-460a-8c38-0cc464af9b6f
dad3d9ba-17f7-4b65-b695-a44e93d758d3	2024	96	87fc1c47-b658-4994-beae-d69e1eedead4	fedc5975-2697-4b57-b26d-492a64ef6cc8	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-06-11 21:15:00+00	2024-06-21 15:10:00+00	\N	AUTOMATICO	\N	\N	2024-08-05 15:10:00+00	2026-01-17 21:31:14.385+00	2026-01-17 21:31:14.385+00	t	\N	COMERCIAL	30	02ed999f-1a0c-460a-8c38-0cc464af9b6f
0de14eab-0bc3-4f45-9c9f-7821dee3921f	2024	113	87fc1c47-b658-4994-beae-d69e1eedead4	fedc5975-2697-4b57-b26d-492a64ef6cc8	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-07-16 00:00:00+00	2024-07-28 00:00:00+00	\N	AUTOMATICO	\N	\N	2024-09-11 00:00:00+00	2026-01-17 21:31:14.392+00	2026-01-17 21:31:14.392+00	t	\N	COMERCIAL	30	02ed999f-1a0c-460a-8c38-0cc464af9b6f
ad90e5dc-8fb9-4672-9683-984e7a21797c	2024	13	73c502e2-397a-499f-b4f7-cb8dce8260b7	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-01-22 13:55:00+00	2024-02-03 00:04:00+00	\N	AUTOMATICO	\N	\N	2024-03-19 00:04:00+00	2026-01-17 21:31:14.401+00	2026-01-17 21:31:14.401+00	t	\N	COMERCIAL	30	0d45342c-ecad-45a7-bb51-ebce9779c000
23f7081f-2528-4c34-b9fe-059c0ee8bc3c	2024	50	73c502e2-397a-499f-b4f7-cb8dce8260b7	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-03-28 18:23:00+00	2024-04-09 18:00:00+00	\N	AUTOMATICO	\N	\N	2024-05-24 18:00:00+00	2026-01-17 21:31:14.408+00	2026-01-17 21:31:14.408+00	t	\N	COMERCIAL	30	0d45342c-ecad-45a7-bb51-ebce9779c000
a666d894-1b48-4554-836c-61926f218458	2024	80	56ea7c96-54cb-4759-ba2a-74dd8a4fe0a2	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-05-18 11:00:00+00	2024-05-22 18:07:00+00	\N	AUTOMATICO	\N	\N	2024-07-06 18:07:00+00	2026-01-17 21:31:14.416+00	2026-01-17 21:31:14.416+00	t	\N	COMERCIAL	30	0d45342c-ecad-45a7-bb51-ebce9779c000
e79de911-d64b-4455-971e-0b8ff6aac36e	2024	104	56ea7c96-54cb-4759-ba2a-74dd8a4fe0a2	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-06-20 06:55:00+00	2024-06-24 14:00:00+00	\N	AUTOMATICO	\N	\N	2024-08-08 14:00:00+00	2026-01-17 21:31:14.422+00	2026-01-17 21:31:14.422+00	t	\N	COMERCIAL	30	0d45342c-ecad-45a7-bb51-ebce9779c000
3ccfda38-a32f-4e0a-9bf8-8931e56f971d	2024	131	2ea49417-f407-4cad-8214-3f84ef261e65	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-08-20 19:05:00+00	2024-08-28 08:29:00+00	\N	AUTOMATICO	\N	\N	2024-10-12 08:29:00+00	2026-01-17 21:31:14.429+00	2026-01-17 21:31:14.429+00	t	\N	COMERCIAL	30	0d45342c-ecad-45a7-bb51-ebce9779c000
da30d478-7db0-4a1e-8e52-4a2e469a1190	2024	9	08da59fb-fa52-49da-b7ec-6e276d53b841	57d68d17-afe4-47b5-baf5-4e4791069319	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-01-19 20:37:00+00	2024-02-14 08:23:00+00	\N	AUTOMATICO	\N	\N	2024-03-30 08:23:00+00	2026-01-17 21:31:14.437+00	2026-01-17 21:31:14.437+00	t	\N	COMERCIAL	40	dfbdeeff-4e60-46c2-9ce0-7becb9a494a2
f682980b-267e-49ee-9788-17095d2bbc23	2024	39	196d90c9-4a16-4fac-98ca-948f955d17d2	1f5e5c39-7fd2-4fb1-8697-d5e0e9a4022b	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-03-02 20:35:00+00	2024-04-04 07:00:00+00	\N	AUTOMATICO	\N	\N	2024-05-19 07:00:00+00	2026-01-17 21:31:14.443+00	2026-01-17 21:31:14.443+00	t	\N	COMERCIAL	30	dfbdeeff-4e60-46c2-9ce0-7becb9a494a2
5e6b131a-0482-4575-83cd-5cd930d2c314	2024	71	0b05adc0-bf86-40b7-a0f0-21db3b022436	fedc5975-2697-4b57-b26d-492a64ef6cc8	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-04-29 18:20:00+00	2024-05-20 08:40:00+00	\N	AUTOMATICO	\N	\N	2024-07-04 08:40:00+00	2026-01-17 21:31:14.451+00	2026-01-17 21:31:14.451+00	t	\N	COMERCIAL	30	dfbdeeff-4e60-46c2-9ce0-7becb9a494a2
e39be39d-6966-49ae-bda4-bf9854457ea2	2024	83	df12f2d3-a96c-42b0-bb93-dfe21c48e3cf	fedc5975-2697-4b57-b26d-492a64ef6cc8	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-05-23 19:35:00+00	2024-06-09 11:55:00+00	\N	AUTOMATICO	\N	\N	2024-07-24 11:55:00+00	2026-01-17 21:31:14.458+00	2026-01-17 21:31:14.458+00	t	\N	COMERCIAL	30	dfbdeeff-4e60-46c2-9ce0-7becb9a494a2
94ac3cd9-8841-4408-957c-ef20afb4c8a2	2024	116	0a7aed5b-7fc3-4b95-aeea-754431932603	fedc5975-2697-4b57-b26d-492a64ef6cc8	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-07-21 13:05:00+00	2024-07-27 16:40:00+00	\N	AUTOMATICO	\N	\N	2024-09-10 16:40:00+00	2026-01-17 21:31:14.466+00	2026-01-17 21:31:14.466+00	t	\N	COMERCIAL	30	dfbdeeff-4e60-46c2-9ce0-7becb9a494a2
4788e4e0-fab8-4291-8f68-72aba2235e0b	2024	3	863ff4de-02ab-477a-b726-83d3e9148648	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-01-05 20:05:00+00	2024-01-25 20:15:00+00	\N	AUTOMATICO	\N	\N	2024-03-10 20:15:00+00	2026-01-17 21:31:14.473+00	2026-01-17 21:31:14.473+00	t	\N	COMERCIAL	60	ba8ec778-639d-4dcd-9db2-d7100c84e8f5
9c1c0779-c291-45d4-af85-342437c32f8d	2024	22	863ff4de-02ab-477a-b726-83d3e9148648	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-01-27 20:00:00+00	2024-02-24 17:45:00+00	\N	AUTOMATICO	\N	\N	2024-04-09 17:45:00+00	2026-01-17 21:31:14.478+00	2026-01-17 21:31:14.478+00	t	\N	COMERCIAL	60	ba8ec778-639d-4dcd-9db2-d7100c84e8f5
fbb6e4bf-2de7-4267-864a-f65cf15f4816	2024	34	863ff4de-02ab-477a-b726-83d3e9148648	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-02-27 18:45:00+00	2024-03-23 23:00:00+00	\N	AUTOMATICO	\N	\N	2024-05-07 23:00:00+00	2026-01-17 21:31:14.485+00	2026-01-17 21:31:14.485+00	t	\N	COMERCIAL	60	ba8ec778-639d-4dcd-9db2-d7100c84e8f5
cc7efcb3-225d-4e87-8c53-b011b88c3218	2024	75	f0cfd06a-b006-4dc5-ada1-3a7e9ba760ad	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-05-06 17:20:00+00	2024-06-26 04:30:00+00	\N	AUTOMATICO	\N	\N	2024-08-10 04:30:00+00	2026-01-17 21:31:14.492+00	2026-01-17 21:31:14.492+00	t	\N	COMERCIAL	60	ba8ec778-639d-4dcd-9db2-d7100c84e8f5
6957ee46-f622-4dc6-8ba8-3f1c21eac19e	2024	105	f0cfd06a-b006-4dc5-ada1-3a7e9ba760ad	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-07-04 02:35:00+00	2024-09-05 10:25:00+00	\N	AUTOMATICO	\N	\N	2024-10-20 10:25:00+00	2026-01-17 21:31:14.5+00	2026-01-17 21:31:14.5+00	t	\N	COMERCIAL	60	ba8ec778-639d-4dcd-9db2-d7100c84e8f5
dce343dd-5ad0-4c8b-b9d7-4842818340e0	2024	58	9feec5a5-4b57-4bd9-98ed-770ea7509a63	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-04-04 15:15:00+00	2024-05-15 10:05:00+00	\N	AUTOMATICO	\N	\N	2024-06-29 10:05:00+00	2026-01-17 21:31:14.507+00	2026-01-17 21:31:14.507+00	t	\N	COMERCIAL	60	1a7c0412-7201-4145-afa5-3169b023b255
9d8e8990-3a41-45a4-b3ab-2770607e2797	2024	94	c6c6fcdc-e445-4e60-8a3f-a70b8e33aab7	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-06-06 20:00:00+00	2024-07-05 20:50:00+00	\N	AUTOMATICO	\N	\N	2024-08-19 20:50:00+00	2026-01-17 21:31:14.514+00	2026-01-17 21:31:14.514+00	t	\N	COMERCIAL	60	1a7c0412-7201-4145-afa5-3169b023b255
b6107140-d329-434f-a111-3a70cd72dc7b	2024	127	a12653df-c0ca-4814-8442-78636dfa6d94	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-08-16 09:34:00+00	2024-10-05 12:23:00+00	\N	AUTOMATICO	\N	\N	2024-11-19 12:23:00+00	2026-01-17 21:31:14.52+00	2026-01-17 21:31:14.52+00	t	\N	COMERCIAL	60	1a7c0412-7201-4145-afa5-3169b023b255
9dfefc30-ee66-4ba6-9dcd-e957301b6c64	2023	164	ba0b91e3-29d6-4028-acb8-c8256fa2aaf8	57d68d17-afe4-47b5-baf5-4e4791069319	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2023-12-31 08:50:00+00	2024-01-23 05:55:00+00	\N	AUTOMATICO	\N	\N	2024-03-08 05:55:00+00	2026-01-17 21:31:14.527+00	2026-01-17 21:31:14.527+00	t	\N	COMERCIAL	40	df1d26fb-7984-43c7-8831-6c8fa0d6b4f5
fd68f884-463e-4f67-b928-9232ec37a082	2024	38	649e5ded-9a48-4bf8-aaa1-2edf147fe587	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-03-06 10:00:00+00	2024-03-13 13:33:00+00	\N	AUTOMATICO	\N	\N	2024-04-27 13:33:00+00	2026-01-17 21:31:14.536+00	2026-01-17 21:31:14.536+00	t	\N	COMERCIAL	30	df1d26fb-7984-43c7-8831-6c8fa0d6b4f5
23299e73-66ef-44b6-9158-07778facae32	2024	93	2df50464-9916-4b3e-b5c3-3a645623d525	fedc5975-2697-4b57-b26d-492a64ef6cc8	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-06-07 18:08:00+00	2024-07-21 16:45:00+00	\N	AUTOMATICO	\N	\N	2024-09-04 16:45:00+00	2026-01-17 21:31:14.543+00	2026-01-17 21:31:14.543+00	t	\N	COMERCIAL	60	df1d26fb-7984-43c7-8831-6c8fa0d6b4f5
33883a42-4791-4ec5-861f-a21774e74223	2024	135	542c0a22-02f9-4816-ba4c-be8655ccbedc	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-09-05 08:50:00+00	2024-10-15 17:15:00+00	\N	AUTOMATICO	\N	\N	2024-11-29 17:15:00+00	2026-01-17 21:31:14.55+00	2026-01-17 21:31:14.55+00	t	\N	COMERCIAL	60	df1d26fb-7984-43c7-8831-6c8fa0d6b4f5
f169a737-fd78-40da-8345-5f087071eeea	2024	19	ba0b91e3-29d6-4028-acb8-c8256fa2aaf8	57d68d17-afe4-47b5-baf5-4e4791069319	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-01-24 23:00:00+00	2024-02-12 10:25:00+00	\N	AUTOMATICO	\N	\N	2024-03-28 10:25:00+00	2026-01-17 21:31:14.557+00	2026-01-17 21:31:14.557+00	t	\N	COMERCIAL	40	8ced3542-9444-4153-b141-27ed65a5995b
c335e9f7-fc2d-48a3-a946-e808d9e5e30f	2024	28	ba0b91e3-29d6-4028-acb8-c8256fa2aaf8	57d68d17-afe4-47b5-baf5-4e4791069319	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-02-13 19:36:00+00	2024-03-03 13:48:00+00	\N	AUTOMATICO	\N	\N	2024-04-17 13:48:00+00	2026-01-17 21:31:14.563+00	2026-01-17 21:31:14.563+00	t	\N	COMERCIAL	40	8ced3542-9444-4153-b141-27ed65a5995b
a9f46833-a6ba-4e06-947e-bbbe4aa9b0a7	2024	40	ba0b91e3-29d6-4028-acb8-c8256fa2aaf8	57d68d17-afe4-47b5-baf5-4e4791069319	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-03-05 18:35:00+00	2024-04-03 20:35:00+00	\N	AUTOMATICO	\N	\N	2024-05-18 20:35:00+00	2026-01-17 21:31:14.57+00	2026-01-17 21:31:14.57+00	t	\N	COMERCIAL	40	8ced3542-9444-4153-b141-27ed65a5995b
641baec2-6bb5-4759-8670-a8229f62de7b	2024	87	7133431c-daa5-4b41-a710-a3f8fa9bc6f5	fedc5975-2697-4b57-b26d-492a64ef6cc8	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-05-24 17:25:00+00	2024-06-01 08:39:00+00	\N	AUTOMATICO	\N	\N	2024-07-16 08:39:00+00	2026-01-17 21:31:14.577+00	2026-01-17 21:31:14.577+00	t	\N	COMERCIAL	30	8ced3542-9444-4153-b141-27ed65a5995b
758bd9c8-7b5e-4373-b807-89d9a013ac1a	2024	97	3e1e8d2a-eb33-4277-a59f-47d0b61fd8a3	fedc5975-2697-4b57-b26d-492a64ef6cc8	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-06-18 13:30:00+00	2024-06-27 07:50:00+00	\N	AUTOMATICO	\N	\N	2024-08-11 07:50:00+00	2026-01-17 21:31:14.584+00	2026-01-17 21:31:14.584+00	t	\N	COMERCIAL	30	8ced3542-9444-4153-b141-27ed65a5995b
65e3a68b-7aac-4be5-b4f9-3595df9fefef	2024	1	0ddb5663-8ab9-4ad5-ab76-fb98b2e5d15d	fedc5975-2697-4b57-b26d-492a64ef6cc8	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-01-06 18:45:00+00	2024-02-13 21:55:00+00	\N	AUTOMATICO	\N	\N	2024-03-29 21:55:00+00	2026-01-17 21:31:14.592+00	2026-01-17 21:31:14.592+00	t	\N	COMERCIAL	40	c317e912-8dab-40e0-84f0-2b58bf034f54
c8e6882f-275b-48e9-adb6-bd22dba98ae3	2023	148	0ddb5663-8ab9-4ad5-ab76-fb98b2e5d15d	fedc5975-2697-4b57-b26d-492a64ef6cc8	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2023-11-24 11:35:00+00	2024-01-03 20:20:00+00	\N	AUTOMATICO	\N	\N	2024-02-17 20:20:00+00	2026-01-17 21:31:14.6+00	2026-01-17 21:31:14.6+00	t	\N	COMERCIAL	40	cd4b5edd-c793-4367-869f-a955a17d8a11
3eac54fc-f538-46a1-abfc-e5e57f23d094	2024	11	a1b563e1-607a-4532-8d14-0ecc7ee1fe20	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-01-16 14:27:00+00	2024-01-27 19:06:00+00	\N	AUTOMATICO	\N	\N	2024-03-12 19:06:00+00	2026-01-17 21:31:14.608+00	2026-01-17 21:31:14.608+00	t	\N	COMERCIAL	30	cd4b5edd-c793-4367-869f-a955a17d8a11
db0c7768-131c-4cd3-8591-9d93bf4759b6	2024	43	abfe526f-bf85-4dc2-89c7-557bfa93dbc3	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-03-17 10:10:00+00	2024-03-26 14:27:00+00	\N	AUTOMATICO	\N	\N	2024-05-10 14:27:00+00	2026-01-17 21:31:14.616+00	2026-01-17 21:31:14.616+00	t	\N	COMERCIAL	30	cd4b5edd-c793-4367-869f-a955a17d8a11
8f89610d-38d0-4c42-944a-a4b3b8f5962c	2024	88	0ef3fcf7-ae31-4330-864c-347c4617e5e8	fedc5975-2697-4b57-b26d-492a64ef6cc8	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-05-23 18:50:00+00	2024-06-05 08:06:00+00	\N	AUTOMATICO	\N	\N	2024-07-20 08:06:00+00	2026-01-17 21:31:14.624+00	2026-01-17 21:31:14.624+00	t	\N	COMERCIAL	30	cd4b5edd-c793-4367-869f-a955a17d8a11
1b20a08a-80aa-4dc0-b0ab-5b11e65fe22e	2024	123	06f7654a-cc4f-4331-8e87-c998dc86c2ab	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-08-06 16:58:00+00	2024-08-20 12:45:00+00	\N	AUTOMATICO	\N	\N	2024-10-04 12:45:00+00	2026-01-17 21:31:14.631+00	2026-01-17 21:31:14.631+00	t	\N	COMERCIAL	\N	cd4b5edd-c793-4367-869f-a955a17d8a11
51af0c3b-d2bc-45d7-834d-44232171b6bd	2024	157	3b35cd9f-9541-41a4-94d2-9e1de955c892	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-10-13 10:43:00+00	2024-10-20 10:33:00+00	\N	AUTOMATICO	\N	\N	2024-12-04 10:33:00+00	2026-01-17 21:31:14.638+00	2026-01-17 21:31:14.638+00	t	\N	COMERCIAL	\N	cd4b5edd-c793-4367-869f-a955a17d8a11
9a2a7a01-d3f3-41fd-8094-de47b9825640	2024	164	a1b563e1-607a-4532-8d14-0ecc7ee1fe20	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-11-16 12:51:00+00	2024-11-24 22:49:00+00	\N	AUTOMATICO	\N	\N	2025-01-08 22:49:00+00	2026-01-17 21:31:14.645+00	2026-01-17 21:31:14.645+00	t	\N	COMERCIAL	30	cd4b5edd-c793-4367-869f-a955a17d8a11
9afe4a67-600d-44be-9d16-5bb66484bfa0	2024	46	cf8cfd8b-6f05-4ea9-af17-0426de2c550f	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-03-19 19:32:00+00	2024-03-30 18:39:00+00	\N	AUTOMATICO	\N	\N	2024-05-14 18:39:00+00	2026-01-17 21:31:14.653+00	2026-01-17 21:31:14.653+00	t	\N	COMERCIAL	30	df1d26fb-7984-43c7-8831-6c8fa0d6b4f5
55fb1619-09e7-497c-9569-177e432a74f4	2025	129	a1b563e1-607a-4532-8d14-0ecc7ee1fe20	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-07-23 12:30:00+00	2025-08-28 19:29:00+00	\N	AUTOMATICO	\N	\N	2025-10-12 19:29:00+00	2026-01-17 21:31:15.677+00	2026-01-17 21:31:15.677+00	t	\N	COMERCIAL	30	dae8fea3-9440-4fd0-8212-7c8d9c5f4f20
d99e478b-398a-4558-b8e3-89b530097589	2025	47	e70330eb-bcaf-472c-9906-1096de4235dd	1f5e5c39-7fd2-4fb1-8697-d5e0e9a4022b	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-03-13 08:00:00+00	2025-04-19 12:20:00+00	\N	AUTOMATICO	\N	\N	2025-06-03 12:20:00+00	2026-01-17 21:31:15.716+00	2026-01-17 21:31:15.716+00	t	\N	COMERCIAL	30	b9333c64-fa8a-4d22-971b-8447d9cec902
b5a4644d-22c2-4337-a2ad-29a068c202b8	2025	137	ac67da65-198f-43a9-b853-eea2da891505	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-07-30 11:15:00+00	2025-08-04 09:25:00+00	\N	AUTOMATICO	\N	\N	2025-09-18 09:25:00+00	2026-01-17 21:31:15.724+00	2026-01-17 21:31:15.724+00	t	\N	COMERCIAL	30	d7785cda-1f2e-4d29-a52d-335b2096bde6
bdfc0141-d9a4-4433-8cc8-d119e6f7fa16	2025	135	28951b47-241f-46bb-9aa3-97f42bd51686	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-07-28 16:00:00+00	2025-08-23 10:37:00+00	\N	AUTOMATICO	\N	\N	2025-10-07 10:37:00+00	2026-01-17 21:31:15.742+00	2026-01-17 21:31:15.742+00	t	\N	COMERCIAL	30	6abcf5ef-ae58-4e8c-ae86-335d1478ee3c
2362e0e1-bce4-4f40-8b92-700e39fabc4f	2025	134	1f6cbb5f-d134-4ee3-9315-bf24ae2a7946	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-07-25 17:15:00+00	2025-08-20 09:55:00+00	\N	AUTOMATICO	\N	\N	2025-10-04 09:55:00+00	2026-01-17 21:31:15.75+00	2026-01-17 21:31:15.75+00	t	\N	COMERCIAL	30	e148f60c-2aeb-442f-b302-491f4e0eca2b
f88eedea-aab4-4ebd-84b4-69bd28a4d44c	2025	138	dd7184b3-9ccd-4515-a117-02184abda5ff	fedc5975-2697-4b57-b26d-492a64ef6cc8	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-08-04 21:10:00+00	2025-09-05 11:50:00+00	\N	AUTOMATICO	\N	\N	2025-10-20 11:50:00+00	2026-01-17 21:31:15.765+00	2026-01-17 21:31:15.765+00	t	\N	COMERCIAL	30	06979c36-da6e-4fb0-840e-07533a1d41c7
bb0520ea-8ca8-4dfc-9a89-05ca05098859	2025	90	c1fb290e-10a9-4cef-9075-929f585122f3	fedc5975-2697-4b57-b26d-492a64ef6cc8	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-05-26 17:21:00+00	2025-06-11 01:15:00+00	\N	AUTOMATICO	\N	\N	2025-07-26 01:15:00+00	2026-01-17 21:31:15.772+00	2026-01-17 21:31:15.772+00	t	\N	COMERCIAL	30	cd4b5edd-c793-4367-869f-a955a17d8a11
0e414192-e858-4cf7-beb0-0763eabcfcea	2025	118	8b82f567-6be0-4696-b40d-a587b3ed4e22	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-07-13 19:50:00+00	2025-08-03 08:40:00+00	\N	AUTOMATICO	\N	\N	2025-09-17 08:40:00+00	2026-01-17 21:31:15.757+00	2026-01-18 16:09:53.095+00	t	\N	COMERCIAL	10	0b3c7262-8ba3-4ce3-83f7-cc96080f73f0
2187fa4d-c865-4773-b3b6-5f77b1b55376	2025	102	c1fb290e-10a9-4cef-9075-929f585122f3	fedc5975-2697-4b57-b26d-492a64ef6cc8	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-06-17 18:22:00+00	2025-07-10 17:49:00+00	\N	AUTOMATICO	\N	\N	2025-08-24 17:49:00+00	2026-01-17 21:31:15.779+00	2026-01-18 16:10:56.153+00	t	\N	COMERCIAL	30	8ced3542-9444-4153-b141-27ed65a5995b
76a2a093-7a3a-4073-b94f-ff94de76a022	2025	141	03bf8fc0-df37-48c1-bf28-22df463a42ff	fedc5975-2697-4b57-b26d-492a64ef6cc8	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-08-05 12:41:00+00	2025-08-13 19:20:00+00	\N	AUTOMATICO	\N	\N	2025-09-27 19:20:00+00	2026-01-17 21:31:15.802+00	2026-01-17 21:31:15.802+00	t	\N	COMERCIAL	30	cd4b5edd-c793-4367-869f-a955a17d8a11
90d978d5-f61e-4dff-9c65-57bd9383dea0	2025	113	7a5c52c3-f87e-4405-a08e-f3b2ae274460	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-07-12 09:51:00+00	2025-08-01 14:59:00+00	\N	AUTOMATICO	\N	\N	2025-09-15 14:59:00+00	2026-01-17 21:31:15.81+00	2026-01-17 21:31:15.81+00	t	\N	COMERCIAL	30	1f6c3850-8006-4a96-a8b9-96c068b8dbee
49f96334-e0b5-4f97-950d-befd443e7f6c	2025	140	d744066d-a334-4b07-93d0-c5017a925720	fedc5975-2697-4b57-b26d-492a64ef6cc8	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-08-05 14:33:00+00	2025-08-22 11:50:00+00	\N	AUTOMATICO	\N	\N	2025-10-06 11:50:00+00	2026-01-17 21:31:15.822+00	2026-01-17 21:31:15.822+00	t	\N	COMERCIAL	30	dfbdeeff-4e60-46c2-9ce0-7becb9a494a2
1d5d4f83-7a86-4b7a-b761-1977cbf81e5e	2025	8	649e5ded-9a48-4bf8-aaa1-2edf147fe587	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-01-11 11:45:00+00	2025-02-11 11:40:00+00	\N	AUTOMATICO	\N	\N	2025-03-28 11:40:00+00	2026-01-17 21:31:15.83+00	2026-01-17 21:31:15.83+00	t	\N	COMERCIAL	30	0d45342c-ecad-45a7-bb51-ebce9779c000
618fdd7e-84ab-4d3f-9ead-59f41e59161e	2025	65	cad32064-7964-4a41-9f30-a1998363ab99	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-04-21 14:15:00+00	2025-05-26 14:14:00+00	\N	AUTOMATICO	\N	\N	2025-07-10 14:14:00+00	2026-01-17 21:31:15.845+00	2026-01-17 21:31:15.845+00	t	\N	COMERCIAL	\N	ccd3c2b4-fdfd-4d4e-b6c6-1a0dbbc02cf3
3d249765-b8c1-4ad2-8a4e-76ec128ddb2b	2025	66	abfe526f-bf85-4dc2-89c7-557bfa93dbc3	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-05-02 14:40:00+00	2025-05-25 15:35:00+00	\N	AUTOMATICO	\N	\N	2025-07-09 15:35:00+00	2026-01-17 21:31:15.853+00	2026-01-17 21:31:15.853+00	t	\N	COMERCIAL	30	cded2d3e-5f9e-4de6-9269-a1da3eeeff0a
23319c73-a2b2-4cb7-ab2f-a828534113ef	2025	108	cad32064-7964-4a41-9f30-a1998363ab99	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-06-25 12:30:00+00	2025-08-04 08:33:00+00	\N	AUTOMATICO	\N	\N	2025-09-18 08:33:00+00	2026-01-17 21:31:15.86+00	2026-01-17 21:31:15.86+00	t	\N	COMERCIAL	\N	7210834c-47be-440a-81d2-a5fc53a8934b
9a6419d7-b065-47ad-bd2a-0566630e98a1	2025	95	face2a5f-184c-41f8-b3a8-9beebc3635ee	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-06-05 17:40:00+00	2025-07-06 07:53:00+00	\N	AUTOMATICO	\N	\N	2025-08-20 07:53:00+00	2026-01-17 21:31:15.867+00	2026-01-17 21:31:15.867+00	t	\N	COMERCIAL	60	cded2d3e-5f9e-4de6-9269-a1da3eeeff0a
ebe416fb-d85b-41db-b2f0-e7a493ed6544	2025	148	87fc1c47-b658-4994-beae-d69e1eedead4	fedc5975-2697-4b57-b26d-492a64ef6cc8	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-08-20 12:58:00+00	2025-08-30 07:00:00+00	\N	AUTOMATICO	\N	\N	2025-10-14 07:00:00+00	2026-01-17 21:31:15.873+00	2026-01-17 21:31:15.873+00	t	\N	COMERCIAL	30	02ed999f-1a0c-460a-8c38-0cc464af9b6f
195e5644-2982-4476-a62f-7cf736f166b6	2025	147	face2a5f-184c-41f8-b3a8-9beebc3635ee	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-08-23 12:00:00+00	2025-09-22 13:34:00+00	\N	AUTOMATICO	\N	\N	2025-11-06 13:34:00+00	2026-01-17 21:31:15.879+00	2026-01-17 21:31:15.879+00	t	\N	COMERCIAL	60	f644ca0f-bf5f-4449-9c40-7eba742654de
fbc6fdad-c8c7-4ae1-bfef-855b2db3105b	2025	139	8b82f567-6be0-4696-b40d-a587b3ed4e22	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-08-03 18:40:00+00	2025-08-22 10:25:00+00	\N	AUTOMATICO	\N	\N	2025-10-06 10:25:00+00	2026-01-17 21:31:15.886+00	2026-01-17 21:31:15.886+00	t	\N	COMERCIAL	10	20b0118b-9612-4fa8-b90c-5e11e27b07e3
99035dd7-310e-4a9f-9344-cf001f1a5bfb	2025	151	b88d3a8d-a83a-4a6b-a566-85bf97fb3fb7	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-08-30 10:49:00+00	2025-08-30 16:01:00+00	\N	AUTOMATICO	\N	\N	2025-10-14 16:01:00+00	2026-01-17 21:31:15.902+00	2026-01-17 21:31:15.902+00	t	\N	COMERCIAL	60	1f6c3850-8006-4a96-a8b9-96c068b8dbee
3fe38b1e-d987-4002-9581-00f2b1691c5a	2025	153	71ac58df-bb35-4d50-902c-4b8805d03488	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-08-30 17:07:00+00	2025-10-06 19:53:00+00	\N	AUTOMATICO	\N	\N	2025-11-20 19:53:00+00	2026-01-17 21:31:15.909+00	2026-01-17 21:31:15.909+00	t	\N	COMERCIAL	60	66d4eb59-5d54-446b-9ee0-88fa9c133899
87cf10f1-16ae-4092-8aaa-b3f16c5166d3	2025	152	37fb0bff-71cf-474c-ac99-dfe32eb068d3	fedc5975-2697-4b57-b26d-492a64ef6cc8	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-09-01 20:30:00+00	2025-10-08 08:15:00+00	\N	AUTOMATICO	\N	\N	2025-11-22 08:15:00+00	2026-01-17 21:31:15.916+00	2026-01-17 21:31:15.916+00	t	\N	COMERCIAL	\N	cd4b5edd-c793-4367-869f-a955a17d8a11
cc243c97-15d3-4c18-ab36-56cc60ed2c2c	2025	143	844026fe-c6be-4b40-b4f4-4758a4437c2d	fedc5975-2697-4b57-b26d-492a64ef6cc8	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-08-08 15:34:00+00	2025-09-01 12:18:00+00	\N	AUTOMATICO	\N	\N	2025-10-16 12:18:00+00	2026-01-17 21:31:15.924+00	2026-01-17 21:31:15.924+00	t	\N	COMERCIAL	30	d7785cda-1f2e-4d29-a52d-335b2096bde6
072ce4c8-1350-4690-b850-d9174e1a5d0b	2025	142	649e5ded-9a48-4bf8-aaa1-2edf147fe587	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-08-07 12:50:00+00	2025-09-16 09:29:00+00	\N	AUTOMATICO	\N	\N	2025-10-31 09:29:00+00	2026-01-17 21:31:15.94+00	2026-01-17 21:31:15.94+00	t	\N	COMERCIAL	30	4b60b333-fea6-45cd-bec9-c5eb06a8cd1c
3b74f5a0-c9b3-4595-8652-c4b4f488d16b	2025	154	79b204c7-5ff4-42e9-a7de-de8ea34d8555	fedc5975-2697-4b57-b26d-492a64ef6cc8	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-09-06 08:00:00+00	2025-09-15 07:00:00+00	\N	AUTOMATICO	\N	\N	2025-10-30 07:00:00+00	2026-01-17 21:31:15.947+00	2026-01-17 21:31:15.947+00	t	\N	COMERCIAL	40	fb61c911-79f8-45ed-8e0e-23bfa3a9ad2b
5dc80ed4-86df-46fa-893a-9710b6e78ce7	2025	132	32e93528-46a4-40d8-8576-89d228fa5dda	fedc5975-2697-4b57-b26d-492a64ef6cc8	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-07-24 13:40:00+00	2025-10-07 12:18:00+00	\N	AUTOMATICO	\N	\N	2025-11-21 12:18:00+00	2026-01-17 21:31:15.954+00	2026-01-17 21:31:15.954+00	t	\N	COMERCIAL	\N	a21b30af-c563-4c43-9d68-bafd0243c5e6
a6e8461f-7350-4b53-9756-d9357d73e14b	2025	145	d7cc59c9-d446-4271-b0cf-9df6242b41fd	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-08-14 17:45:00+00	2025-09-23 04:49:00+00	\N	AUTOMATICO	\N	\N	2025-11-07 04:49:00+00	2026-01-17 21:31:15.978+00	2026-01-17 21:31:15.978+00	t	\N	COMERCIAL	30	a4846d61-d1ba-4641-b155-1dc30725e33a
d0cb9716-56c4-416c-b79c-23196280035b	2025	157	9feec5a5-4b57-4bd9-98ed-770ea7509a63	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-09-11 09:33:00+00	2025-10-18 06:53:00+00	\N	AUTOMATICO	\N	\N	2025-12-02 06:53:00+00	2026-01-17 21:31:15.986+00	2026-01-17 21:31:15.986+00	t	\N	COMERCIAL	60	cded2d3e-5f9e-4de6-9269-a1da3eeeff0a
0bca43f5-41fc-4b81-9025-f74859d6c782	2025	158	03bf8fc0-df37-48c1-bf28-22df463a42ff	fedc5975-2697-4b57-b26d-492a64ef6cc8	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-09-13 18:00:00+00	2025-10-12 10:20:00+00	\N	AUTOMATICO	\N	\N	2025-11-26 10:20:00+00	2026-01-17 21:31:15.993+00	2026-01-17 21:31:15.993+00	t	\N	COMERCIAL	30	1f6c3850-8006-4a96-a8b9-96c068b8dbee
9105353f-4e21-4492-95ad-d7cc91f10215	2025	163	69ff7a7d-9417-4f5c-9693-8e2835fef39b	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-09-17 16:55:00+00	2025-11-17 20:50:00+00	\N	AUTOMATICO	\N	\N	2026-01-01 20:50:00+00	2026-01-17 21:31:16.008+00	2026-01-17 21:31:16.008+00	t	\N	COMERCIAL	60	f0a415e0-9538-4336-b681-9d23e0753e26
697c7010-7044-4595-8ef7-3d80fb9937bd	2025	161	49144ac0-7330-40cf-8ed7-3dd909542a0e	1f5e5c39-7fd2-4fb1-8697-d5e0e9a4022b	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-10-14 15:40:00+00	2025-10-30 07:30:00+00	\N	AUTOMATICO	\N	\N	2025-12-14 07:30:00+00	2026-01-17 21:31:16.023+00	2026-01-17 21:31:16.023+00	t	\N	COMERCIAL	30	7210834c-47be-440a-81d2-a5fc53a8934b
0aee1677-c774-4d72-ba7a-b34f18f8c0c3	2025	160	196d90c9-4a16-4fac-98ca-948f955d17d2	1f5e5c39-7fd2-4fb1-8697-d5e0e9a4022b	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-10-17 10:30:00+00	2025-11-06 07:50:00+00	\N	AUTOMATICO	\N	\N	2025-12-21 07:50:00+00	2026-01-17 21:31:16.037+00	2026-01-17 21:31:16.037+00	t	\N	COMERCIAL	30	6abcf5ef-ae58-4e8c-ae86-335d1478ee3c
9252e17a-595d-4d52-85e5-764edb3d103a	2025	166	863ff4de-02ab-477a-b726-83d3e9148648	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-09-30 15:15:00+00	2025-11-01 16:20:00+00	\N	AUTOMATICO	\N	\N	2025-12-16 16:20:00+00	2026-01-17 21:31:16.044+00	2026-01-17 21:31:16.044+00	t	\N	COMERCIAL	60	06979c36-da6e-4fb0-840e-07533a1d41c7
22a69311-5dca-450d-8c8d-1b8ea3973f6d	2025	174	5fa98bd7-f095-4d3e-8e98-7761568ec108	fedc5975-2697-4b57-b26d-492a64ef6cc8	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-10-27 16:46:00+00	2025-12-07 09:47:00+00	\N	AUTOMATICO	\N	\N	2026-01-21 09:47:00+00	2026-01-17 21:31:16.065+00	2026-01-17 21:31:16.065+00	t	\N	COMERCIAL	45	f644ca0f-bf5f-4449-9c40-7eba742654de
452fb368-0ab5-4625-942f-fd1264bd805f	2025	176	d7cc59c9-d446-4271-b0cf-9df6242b41fd	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-11-01 16:32:00+00	2025-11-12 08:22:00+00	\N	AUTOMATICO	\N	\N	2025-12-27 08:22:00+00	2026-01-17 21:31:16.086+00	2026-01-17 21:31:16.086+00	t	\N	COMERCIAL	30	30fef00d-f9ee-4362-b430-5819b4bde400
e280195a-928b-41e3-bf05-d6560363e6ff	2025	179	366e3631-c4fe-4001-960d-c816b3a08a1c	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-11-04 20:21:00+00	2025-11-11 06:35:00+00	\N	AUTOMATICO	\N	\N	2025-12-26 06:35:00+00	2026-01-17 21:31:16.093+00	2026-01-17 21:31:16.093+00	t	\N	COMERCIAL	30	20b0118b-9612-4fa8-b90c-5e11e27b07e3
30ea49cf-d1d9-4168-ad83-26baf57805a1	2025	177	28951b47-241f-46bb-9aa3-97f42bd51686	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-11-03 20:30:00+00	2025-12-11 15:30:00+00	\N	AUTOMATICO	\N	\N	2026-01-25 15:30:00+00	2026-01-17 21:31:16.1+00	2026-01-17 21:31:16.1+00	t	\N	COMERCIAL	30	fb61c911-79f8-45ed-8e0e-23bfa3a9ad2b
3c89fd49-ceb1-4a86-9ef4-7faa79581dd2	2025	178	196d90c9-4a16-4fac-98ca-948f955d17d2	1f5e5c39-7fd2-4fb1-8697-d5e0e9a4022b	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-11-07 00:00:00+00	2025-12-21 23:30:00+00	\N	AUTOMATICO	\N	\N	2026-02-04 23:30:00+00	2026-01-17 21:31:16.109+00	2026-01-17 21:31:16.109+00	t	\N	COMERCIAL	30	e148f60c-2aeb-442f-b302-491f4e0eca2b
98ef92a3-2704-4829-8b08-05e9a4988ae6	2025	170	1f6cbb5f-d134-4ee3-9315-bf24ae2a7946	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-10-19 11:02:00+00	2025-11-08 20:15:00+00	\N	AUTOMATICO	\N	\N	2025-12-23 20:15:00+00	2026-01-17 21:31:16.051+00	2026-01-18 16:04:31.045+00	t	\N	COMERCIAL	30	b6f9e1cc-7022-4f80-8f1d-a8392c9193df
776de334-8e34-4d8e-b65c-5cca453a5102	2025	167	7a5c52c3-f87e-4405-a08e-f3b2ae274460	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-09-30 20:58:00+00	2025-11-07 15:40:00+00	\N	AUTOMATICO	\N	\N	2025-12-22 15:40:00+00	2026-01-17 21:31:16.117+00	2026-01-18 16:04:55.415+00	t	\N	COMERCIAL	30	c8fdee90-2d16-4800-8a4d-e6b470cf152d
d824ca87-7e34-4b92-a1ee-7c3ba9098bd4	2025	156	7d23c84f-115a-4318-9e29-aa24a4809280	1f5e5c39-7fd2-4fb1-8697-d5e0e9a4022b	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-09-13 19:00:00+00	2025-10-01 00:00:00+00	\N	AUTOMATICO	\N	\N	2025-11-15 00:00:00+00	2026-01-17 21:31:16.001+00	2026-01-18 16:05:46.283+00	t	\N	COMERCIAL	30	7c20bb25-01f0-48ad-99ac-5c3b6fe11aec
a10109a2-0eeb-4ba5-8ac5-d721b1c63b4b	2025	155	5fa98bd7-f095-4d3e-8e98-7761568ec108	fedc5975-2697-4b57-b26d-492a64ef6cc8	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-09-10 23:05:00+00	2025-10-20 18:20:00+00	\N	AUTOMATICO	\N	\N	2025-12-04 18:20:00+00	2026-01-17 21:31:16.016+00	2026-01-18 16:06:04.904+00	t	\N	COMERCIAL	45	d1d949b7-00fd-4756-8021-bc80d98ecf71
ab45e4db-3e59-4a57-b42b-622339466b8a	2025	150	7520156b-6cda-40e7-a4c4-69d870022e74	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-08-26 00:00:00+00	2025-09-07 00:00:00+00	\N	AUTOMATICO	\N	\N	2025-10-22 00:00:00+00	2026-01-17 21:31:16.03+00	2026-01-18 16:06:28.741+00	t	\N	COMERCIAL	\N	8ced3542-9444-4153-b141-27ed65a5995b
3936555e-956d-499c-bd26-2043cb4d2835	2025	149	0956ea0a-4aa0-4aa0-a2ac-72e3732ff025	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-08-21 19:40:00+00	2025-09-19 09:35:00+00	\N	AUTOMATICO	\N	\N	2025-11-03 09:35:00+00	2026-01-17 21:31:15.894+00	2026-01-18 16:06:50.256+00	t	\N	COMERCIAL	60	b500d7bc-3760-4c88-9a21-4294b2395c71
8c916720-0434-4233-8c81-a7ee1c23b027	2025	146	3f5729dd-4d20-4e27-a7f1-ef46d30e973d	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-08-17 13:50:00+00	2025-09-18 13:08:00+00	\N	AUTOMATICO	\N	\N	2025-11-02 13:08:00+00	2026-01-17 21:31:15.962+00	2026-01-18 16:07:20.348+00	t	\N	COMERCIAL	30	c8fdee90-2d16-4800-8a4d-e6b470cf152d
100fc1c4-e838-431f-b7d8-4941a97e5c34	2025	144	bf9011e3-436b-477e-adc9-5fdf755c9b63	fedc5975-2697-4b57-b26d-492a64ef6cc8	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-08-08 13:53:00+00	2025-09-21 08:50:00+00	\N	AUTOMATICO	\N	\N	2025-11-05 08:50:00+00	2026-01-17 21:31:15.932+00	2026-01-18 16:07:42.21+00	t	\N	COMERCIAL	30	b6f9e1cc-7022-4f80-8f1d-a8392c9193df
730ea452-6c88-4649-b661-14a8e90df97f	2025	133	64782920-6598-4760-ba21-7ead251ff1e1	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-07-23 20:10:00+00	2025-09-25 10:34:00+00	\N	AUTOMATICO	\N	\N	2025-11-09 10:34:00+00	2026-01-17 21:31:15.97+00	2026-01-18 16:08:40.069+00	t	\N	COMERCIAL	\N	372bbb60-ca31-49ff-9ef9-fd5d49beb720
02f86ac6-fdc0-4ec6-b90a-3eeb4704083f	2025	15	7a5c52c3-f87e-4405-a08e-f3b2ae274460	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-01-12 20:59:00+00	2025-02-12 14:07:00+00	\N	AUTOMATICO	\N	\N	2025-03-29 14:07:00+00	2026-01-17 21:31:15.838+00	2026-01-18 16:15:36.463+00	t	\N	COMERCIAL	30	372bbb60-ca31-49ff-9ef9-fd5d49beb720
d704c984-c420-4bd1-8786-9fdcd168393d	2025	169	e70330eb-bcaf-472c-9906-1096de4235dd	1f5e5c39-7fd2-4fb1-8697-d5e0e9a4022b	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-10-12 01:35:00+00	2025-12-05 06:24:00+00	\N	AUTOMATICO	\N	\N	2026-01-19 06:24:00+00	2026-01-17 21:31:16.125+00	2026-01-17 21:31:16.125+00	t	\N	COMERCIAL	30	b33fd685-31a6-4510-a970-09a2d428a1bb
34f92e6a-e85f-4672-81a3-43c14cb41220	2025	165	04b53087-52e8-4656-be93-714c343c47d6	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-09-29 22:30:00+00	2025-10-29 03:30:00+00	\N	AUTOMATICO	\N	\N	2025-12-13 03:30:00+00	2026-01-17 21:31:16.132+00	2026-01-17 21:31:16.132+00	t	\N	COMERCIAL	60	42b34bed-97d4-466f-a7c2-3dc5a4a821ff
bac274c6-39f7-41f2-b344-f5938ea8d9a4	2025	159	a16cce31-d12d-458a-b212-6846185933bf	1f5e5c39-7fd2-4fb1-8697-d5e0e9a4022b	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-10-13 21:15:00+00	2025-11-08 07:50:00+00	\N	AUTOMATICO	\N	\N	2025-12-23 07:50:00+00	2026-01-17 21:31:16.147+00	2026-01-17 21:31:16.147+00	t	\N	COMERCIAL	30	6216f910-4b2f-49bc-b238-f3e15147152c
84bb51d2-bc04-48fc-82e0-eefcb3d6181c	2025	162	adc23180-9487-47ad-9e3d-62eade83623a	1f5e5c39-7fd2-4fb1-8697-d5e0e9a4022b	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-10-14 16:17:00+00	2025-12-04 11:51:00+00	\N	AUTOMATICO	\N	\N	2026-01-18 11:51:00+00	2026-01-17 21:31:16.155+00	2026-01-17 21:31:16.155+00	t	\N	COMERCIAL	30	f60ed9ea-004f-41a9-9d6a-4f34923b1728
4608c6ff-2a5c-4376-aab0-2ecc5ad57077	2025	168	71ac58df-bb35-4d50-902c-4b8805d03488	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-10-14 18:50:00+00	2025-11-23 08:22:00+00	\N	AUTOMATICO	\N	\N	2026-01-07 08:22:00+00	2026-01-17 21:31:16.164+00	2026-01-17 21:31:16.164+00	t	\N	COMERCIAL	60	d7785cda-1f2e-4d29-a52d-335b2096bde6
af99bccf-1c39-4b7f-9e32-5cca1f6ab9e4	2025	175	cad32064-7964-4a41-9f30-a1998363ab99	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-11-04 00:00:00+00	2025-12-06 19:45:00+00	\N	AUTOMATICO	\N	\N	2026-01-20 19:45:00+00	2026-01-17 21:31:16.179+00	2026-01-17 21:31:16.179+00	t	\N	COMERCIAL	\N	0d45342c-ecad-45a7-bb51-ebce9779c000
4bd07a16-56ce-4045-b817-946f150adb44	2025	184	f0cfd06a-b006-4dc5-ada1-3a7e9ba760ad	acea052d-e5d1-4ced-b98c-2d01eb79122a	97219917-fdf2-4aca-b415-96de17cc505e	\N	2025-11-27 22:30:00+00	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-17 21:31:16.212+00	2026-01-17 21:31:16.212+00	t	\N	COMERCIAL	60	a21b30af-c563-4c43-9d68-bafd0243c5e6
4907e1c7-7fb0-435e-bf14-91e735744633	2025	13	50a5014a-b7c0-432c-a620-a5f096fabe15	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-01-11 07:45:00+00	2025-02-15 00:35:00+00	\N	AUTOMATICO	\N	\N	2025-04-01 00:35:00+00	2026-01-17 21:31:16.219+00	2026-01-17 21:31:16.219+00	t	\N	COMERCIAL	30	dae8fea3-9440-4fd0-8212-7c8d9c5f4f20
7130be8a-57d0-4e14-b224-469ab59150d1	2025	187	5fa98bd7-f095-4d3e-8e98-7761568ec108	fedc5975-2697-4b57-b26d-492a64ef6cc8	97219917-fdf2-4aca-b415-96de17cc505e	\N	2025-12-15 14:50:00+00	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-17 21:31:16.233+00	2026-01-17 21:31:16.233+00	t	\N	COMERCIAL	45	4b60b333-fea6-45cd-bec9-c5eb06a8cd1c
c5f7c42f-2cb4-4bfc-8853-694ab027ceb1	2025	185	7a5c52c3-f87e-4405-a08e-f3b2ae274460	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-12-02 20:03:00+00	2025-12-13 07:05:00+00	\N	AUTOMATICO	\N	\N	2026-01-27 07:05:00+00	2026-01-17 21:31:16.241+00	2026-01-17 21:31:16.241+00	t	\N	COMERCIAL	30	ea89e630-34ba-4705-98d9-8b662af90e3c
3ad14786-cabe-4acb-9f33-b24802773374	2024	170	f0cfd06a-b006-4dc5-ada1-3a7e9ba760ad	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-12-27 23:50:00+00	2025-02-17 04:35:00+00	\N	AUTOMATICO	\N	\N	2025-04-03 04:35:00+00	2026-01-17 21:31:16.248+00	2026-01-17 21:31:16.248+00	t	\N	COMERCIAL	60	a21b30af-c563-4c43-9d68-bafd0243c5e6
e87b2a8d-35b5-4d8a-97c4-23f7950477b5	2024	169	8e64df56-3b39-4321-8c31-98bff1ad28b3	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-12-12 16:15:00+00	2025-01-02 00:00:00+00	\N	AUTOMATICO	\N	\N	2025-02-16 00:00:00+00	2026-01-17 21:31:16.255+00	2026-01-17 21:31:16.255+00	t	\N	COMERCIAL	60	1f6c3850-8006-4a96-a8b9-96c068b8dbee
84674b0e-e4e3-427b-b62c-130db2a65be4	2025	196	49144ac0-7330-40cf-8ed7-3dd909542a0e	1f5e5c39-7fd2-4fb1-8697-d5e0e9a4022b	97219917-fdf2-4aca-b415-96de17cc505e	\N	2025-12-23 17:20:00+00	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-17 21:31:16.262+00	2026-01-17 21:31:16.262+00	t	\N	COMERCIAL	30	42a44075-32a8-4cf3-ac88-e674cec0c736
15a34aa8-8293-4969-ae18-ff41fb647a52	2025	191	ba0b91e3-29d6-4028-acb8-c8256fa2aaf8	57d68d17-afe4-47b5-baf5-4e4791069319	97219917-fdf2-4aca-b415-96de17cc505e	\N	2025-12-29 13:00:00+00	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-17 21:31:16.269+00	2026-01-17 21:31:16.269+00	t	\N	COMERCIAL	40	8e978fd7-df5d-495f-aedb-668e0a0eee76
b1bbf611-cad8-49fe-abb5-5da8074b1b40	2025	200	43ed857e-e69f-467e-a977-3590327e0708	57d68d17-afe4-47b5-baf5-4e4791069319	97219917-fdf2-4aca-b415-96de17cc505e	\N	2025-12-29 16:26:00+00	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-17 21:31:16.276+00	2026-01-17 21:31:16.276+00	t	\N	COMERCIAL	40	c4d0d648-9ce5-427e-a92a-05bbad8caab8
1f6c1163-1923-4533-856c-1cf7e106cd12	2025	201	83a5f4d8-12bb-48e4-8b31-6fda9cd9eb5f	57d68d17-afe4-47b5-baf5-4e4791069319	97219917-fdf2-4aca-b415-96de17cc505e	\N	2025-12-29 17:15:00+00	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-17 21:31:16.283+00	2026-01-17 21:31:16.283+00	t	\N	COMERCIAL	40	2636748e-dbca-4b8b-a7df-53a7499b9937
9eda1a8e-eba3-4a62-b9bd-be326506060e	2025	189	82d93396-176a-4d74-a5de-5addaf47520f	57d68d17-afe4-47b5-baf5-4e4791069319	97219917-fdf2-4aca-b415-96de17cc505e	\N	2025-12-29 18:35:00+00	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-17 21:31:16.29+00	2026-01-17 21:31:16.29+00	t	\N	COMERCIAL	40	61c44b6c-785b-4418-82b4-f2f2d3173e8d
81597411-4e0a-49a7-8234-522f8b140369	2025	198	12964f37-2ef3-4932-9d34-b7ec4410c90b	57d68d17-afe4-47b5-baf5-4e4791069319	97219917-fdf2-4aca-b415-96de17cc505e	\N	2025-12-29 19:02:00+00	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-17 21:31:16.297+00	2026-01-17 21:31:16.297+00	t	\N	COMERCIAL	40	ea89e630-34ba-4705-98d9-8b662af90e3c
78596501-cedf-4b64-bf27-5efac9aee7ef	2025	190	3c111b3e-1c42-49b4-b579-168516f1dc1f	57d68d17-afe4-47b5-baf5-4e4791069319	97219917-fdf2-4aca-b415-96de17cc505e	\N	2025-12-30 09:45:00+00	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-17 21:31:16.303+00	2026-01-17 21:31:16.303+00	t	\N	COMERCIAL	40	a4846d61-d1ba-4641-b155-1dc30725e33a
58d653ae-6399-455f-b255-38a05b3b28a3	2025	188	04b53087-52e8-4656-be93-714c343c47d6	acea052d-e5d1-4ced-b98c-2d01eb79122a	97219917-fdf2-4aca-b415-96de17cc505e	\N	2025-12-30 18:05:00+00	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-17 21:31:16.31+00	2026-01-17 21:31:16.31+00	t	\N	COMERCIAL	60	cded2d3e-5f9e-4de6-9269-a1da3eeeff0a
c01f8f0f-c212-4d56-83f2-c421e26acc0e	2025	193	4c346349-604d-4835-9682-3f7ab65c240d	57d68d17-afe4-47b5-baf5-4e4791069319	97219917-fdf2-4aca-b415-96de17cc505e	\N	2025-12-29 00:00:00+00	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-17 21:31:16.318+00	2026-01-17 21:31:16.318+00	t	\N	COMERCIAL	40	96431afb-2b4f-474c-8348-78a155e9adb8
638cf5c9-4b0b-48c7-98ec-2af423cdce18	2026	8	7d23c84f-115a-4318-9e29-aa24a4809280	1f5e5c39-7fd2-4fb1-8697-d5e0e9a4022b	97219917-fdf2-4aca-b415-96de17cc505e	\N	2026-01-06 18:15:00+00	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-17 21:31:16.332+00	2026-01-17 21:31:16.332+00	t	\N	COMERCIAL	30	66d4eb59-5d54-446b-9ee0-88fa9c133899
ad5cfd1d-aa79-4239-92fd-32342423ee9b	2026	4	7a5c52c3-f87e-4405-a08e-f3b2ae274460	acea052d-e5d1-4ced-b98c-2d01eb79122a	97219917-fdf2-4aca-b415-96de17cc505e	\N	2026-01-06 15:00:00+00	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-17 21:31:16.339+00	2026-01-17 21:31:16.339+00	t	\N	COMERCIAL	30	d7785cda-1f2e-4d29-a52d-335b2096bde6
b318ed5b-dc0b-49fb-9f37-e499358515a7	2026	5	a12653df-c0ca-4814-8442-78636dfa6d94	acea052d-e5d1-4ced-b98c-2d01eb79122a	97219917-fdf2-4aca-b415-96de17cc505e	\N	2026-01-06 21:46:00+00	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-17 21:31:16.345+00	2026-01-17 21:31:16.345+00	t	\N	COMERCIAL	60	fb61c911-79f8-45ed-8e0e-23bfa3a9ad2b
b2122bed-a672-447d-8e23-541659de9239	2026	6	c7c5892b-d6ee-4b44-b3a6-24dc9ded90aa	57d68d17-afe4-47b5-baf5-4e4791069319	97219917-fdf2-4aca-b415-96de17cc505e	\N	2026-01-06 19:50:00+00	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-17 21:31:16.359+00	2026-01-17 21:31:16.359+00	t	\N	COMERCIAL	40	8644b80c-97af-46cf-9f4d-711749582de1
1e7c7bf8-eadb-4129-97aa-6a8aa0382b8e	2025	182	69ff7a7d-9417-4f5c-9693-8e2835fef39b	acea052d-e5d1-4ced-b98c-2d01eb79122a	97219917-fdf2-4aca-b415-96de17cc505e	\N	2025-11-22 00:30:00+00	2026-01-12 20:00:00+00	\N	AUTOMATICO	\N	\N	2026-02-26 20:00:00+00	2026-01-17 21:31:16.195+00	2026-01-17 21:31:16.195+00	t	\N	COMERCIAL	60	20b0118b-9612-4fa8-b90c-5e11e27b07e3
1c0090cb-f67a-4eae-a1e8-c27f179a2ef0	2025	183	7d23c84f-115a-4318-9e29-aa24a4809280	1f5e5c39-7fd2-4fb1-8697-d5e0e9a4022b	45672467-a4db-462d-8228-2a21ce82cc37	\N	2025-11-26 20:00:00+00	2026-01-04 19:00:00+00	\N	AUTOMATICO	\N	\N	2026-02-18 19:00:00+00	2026-01-17 21:31:16.203+00	2026-01-17 21:31:16.203+00	t	\N	COMERCIAL	30	66d4eb59-5d54-446b-9ee0-88fa9c133899
0e9185ba-8450-436a-aea1-1e20447d56f0	2025	194	196d90c9-4a16-4fac-98ca-948f955d17d2	1f5e5c39-7fd2-4fb1-8697-d5e0e9a4022b	97219917-fdf2-4aca-b415-96de17cc505e	\N	2025-12-30 22:10:00+00	2026-01-15 17:03:00+00	\N	AUTOMATICO	\N	\N	2026-03-01 17:03:00+00	2026-01-17 21:31:16.366+00	2026-01-17 21:31:16.366+00	t	\N	COMERCIAL	30	ea018f17-bf86-4148-906a-520c058f3deb
cc550723-a07b-4a96-88ca-a49a4f00c859	2026	3	c6c6fcdc-e445-4e60-8a3f-a70b8e33aab7	acea052d-e5d1-4ced-b98c-2d01eb79122a	97219917-fdf2-4aca-b415-96de17cc505e	\N	\N	2026-01-14 16:15:00+00	\N	AUTOMATICO	\N	\N	2026-02-28 16:15:00+00	2026-01-17 21:31:16.324+00	2026-01-17 21:31:16.324+00	t	\N	COMERCIAL	60	3c122437-a51d-4597-816c-84cdd15e151f
a57f20ba-0fed-4e37-bc68-15add34d9f35	2025	195	e70330eb-bcaf-472c-9906-1096de4235dd	1f5e5c39-7fd2-4fb1-8697-d5e0e9a4022b	97219917-fdf2-4aca-b415-96de17cc505e	\N	2025-12-30 21:40:00+00	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-17 21:31:16.374+00	2026-01-17 21:31:16.374+00	t	\N	COMERCIAL	30	b1260fb6-8960-4630-8970-15e24b1d76e9
c6661b7f-33c9-44f9-b1b4-3a7b70ec3f2f	2025	197	adc23180-9487-47ad-9e3d-62eade83623a	1f5e5c39-7fd2-4fb1-8697-d5e0e9a4022b	97219917-fdf2-4aca-b415-96de17cc505e	\N	2025-12-30 22:40:00+00	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-17 21:31:16.38+00	2026-01-17 21:31:16.38+00	t	\N	COMERCIAL	30	f0a415e0-9538-4336-b681-9d23e0753e26
85c49d03-b74d-46d5-9d0b-f316cbd54b19	2024	153	4a837a56-b513-4568-b2d7-61bc1d66d22b	fedc5975-2697-4b57-b26d-492a64ef6cc8	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-10-04 17:24:00+00	2024-10-20 08:31:00+00	\N	AUTOMATICO	\N	\N	2024-12-04 08:31:00+00	2026-01-17 21:31:13.567+00	2026-01-17 21:31:13.567+00	t	\N	COMERCIAL	30	9a9b3bcd-4b8f-4aba-8ea5-3ec890e23fee
af072108-d149-4c43-acc4-07ada07f95b8	2024	152	2df50464-9916-4b3e-b5c3-3a645623d525	fedc5975-2697-4b57-b26d-492a64ef6cc8	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-10-04 20:45:00+00	2024-11-13 08:14:00+00	\N	AUTOMATICO	\N	\N	2024-12-28 08:14:00+00	2026-01-17 21:31:13.596+00	2026-01-17 21:31:13.596+00	t	\N	COMERCIAL	60	d1d949b7-00fd-4756-8021-bc80d98ecf71
83b11bd1-fa53-42e8-ae48-1636d8895333	2025	199	2df50464-9916-4b3e-b5c3-3a645623d525	fedc5975-2697-4b57-b26d-492a64ef6cc8	97219917-fdf2-4aca-b415-96de17cc505e	\N	2026-01-09 10:32:00+00	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-17 21:31:16.352+00	2026-01-17 21:31:16.352+00	t	\N	COMERCIAL	60	d1d949b7-00fd-4756-8021-bc80d98ecf71
44d2a899-840d-4c2e-b2ec-cdf3a83e1644	2024	155	5fa98bd7-f095-4d3e-8e98-7761568ec108	fedc5975-2697-4b57-b26d-492a64ef6cc8	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-10-15 19:25:00+00	2024-11-02 18:30:00+00	\N	AUTOMATICO	\N	\N	2024-12-17 18:30:00+00	2026-01-17 21:31:13.606+00	2026-01-17 21:31:13.606+00	t	\N	COMERCIAL	45	df1d26fb-7984-43c7-8831-6c8fa0d6b4f5
7ce9a44f-8e20-4350-9d01-6bcf948dad0a	2024	143	f0cfd06a-b006-4dc5-ada1-3a7e9ba760ad	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-09-18 14:45:00+00	2024-10-30 19:05:00+00	\N	AUTOMATICO	\N	\N	2024-12-14 19:05:00+00	2026-01-17 21:31:13.616+00	2026-01-17 21:31:13.616+00	t	\N	COMERCIAL	60	cded2d3e-5f9e-4de6-9269-a1da3eeeff0a
7ae496f6-98c7-4340-a670-20e35fc8f09a	2024	158	0ddb5663-8ab9-4ad5-ab76-fb98b2e5d15d	fedc5975-2697-4b57-b26d-492a64ef6cc8	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-10-19 07:00:00+00	2024-11-25 14:15:00+00	\N	AUTOMATICO	\N	\N	2025-01-09 14:15:00+00	2026-01-17 21:31:13.625+00	2026-01-17 21:31:13.625+00	t	\N	COMERCIAL	40	ba8ec778-639d-4dcd-9db2-d7100c84e8f5
e6d4776a-48a2-414b-9a82-52c25364fd88	2024	154	56ea7c96-54cb-4759-ba2a-74dd8a4fe0a2	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-01-01 06:46:00+00	2024-10-13 23:39:00+00	\N	AUTOMATICO	\N	\N	2024-11-27 23:39:00+00	2026-01-17 21:31:13.634+00	2026-01-17 21:31:13.634+00	t	\N	COMERCIAL	30	1f6c3850-8006-4a96-a8b9-96c068b8dbee
a2340655-447b-4e2e-b22d-ff9fa6a250cb	2024	1	728cb01c-9ba3-4d4e-baf1-4c14f3b40e35	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-10-21 00:00:00+00	2024-11-29 00:00:00+00	\N	AUTOMATICO	\N	\N	2025-01-13 00:00:00+00	2026-01-17 21:31:13.642+00	2026-01-17 21:31:13.642+00	t	\N	CI	10	02ed999f-1a0c-460a-8c38-0cc464af9b6f
43957680-f42e-4eb2-b639-0510e32efdf6	2024	151	69ff7a7d-9417-4f5c-9693-8e2835fef39b	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-10-10 21:45:00+00	2024-12-03 05:45:00+00	\N	AUTOMATICO	\N	\N	2025-01-17 05:45:00+00	2026-01-17 21:31:13.651+00	2026-01-17 21:31:13.651+00	t	\N	COMERCIAL	60	20b0118b-9612-4fa8-b90c-5e11e27b07e3
355b5b34-b8c2-4371-b4ec-3e27808826bc	2025	180	a16cce31-d12d-458a-b212-6846185933bf	1f5e5c39-7fd2-4fb1-8697-d5e0e9a4022b	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-11-12 14:03:00+00	2025-12-24 06:11:00+00	\N	AUTOMATICO	\N	\N	2026-02-07 06:11:00+00	2026-01-17 21:31:16.172+00	2026-01-18 16:03:48.781+00	t	\N	COMERCIAL	30	8ced3542-9444-4153-b141-27ed65a5995b
3ff7e132-327c-481a-9a91-4e2ed0c0f71a	2025	164	0956ea0a-4aa0-4aa0-a2ac-72e3732ff025	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-09-20 15:40:00+00	2025-10-07 06:28:00+00	\N	AUTOMATICO	\N	\N	2025-11-21 06:28:00+00	2026-01-17 21:31:16.14+00	2026-01-18 16:05:19.251+00	t	\N	COMERCIAL	60	b500d7bc-3760-4c88-9a21-4294b2395c71
898de745-6ac9-4bbc-9097-9f3500965a67	2024	2	a16cce31-d12d-458a-b212-6846185933bf	1f5e5c39-7fd2-4fb1-8697-d5e0e9a4022b	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-10-04 19:18:00+00	2025-10-12 00:00:00+00	\N	AUTOMATICO	\N	\N	2025-11-26 00:00:00+00	2026-01-17 21:31:13.66+00	2026-01-17 21:31:13.66+00	t	\N	CI	30	df1d26fb-7984-43c7-8831-6c8fa0d6b4f5
44c12995-f99a-470b-8421-e882db22530f	2024	3	49144ac0-7330-40cf-8ed7-3dd909542a0e	1f5e5c39-7fd2-4fb1-8697-d5e0e9a4022b	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-10-08 21:25:00+00	2025-10-10 00:00:00+00	\N	AUTOMATICO	\N	\N	2025-11-24 00:00:00+00	2026-01-17 21:31:13.669+00	2026-01-17 21:31:13.669+00	t	\N	CI	30	f0a415e0-9538-4336-b681-9d23e0753e26
b3d84470-5b1c-40c3-beaa-91c86ad13cc7	2024	4	7d23c84f-115a-4318-9e29-aa24a4809280	1f5e5c39-7fd2-4fb1-8697-d5e0e9a4022b	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-08-02 13:25:00+00	2024-12-15 11:05:00+00	\N	AUTOMATICO	\N	\N	2025-01-29 11:05:00+00	2026-01-17 21:31:13.677+00	2026-01-17 21:31:13.677+00	t	\N	CI	30	df1d26fb-7984-43c7-8831-6c8fa0d6b4f5
f9e034a6-27d4-4ab9-a649-d5c4eeb306a0	2024	5	e70330eb-bcaf-472c-9906-1096de4235dd	1f5e5c39-7fd2-4fb1-8697-d5e0e9a4022b	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-10-03 15:15:00+00	2024-10-26 06:59:00+00	\N	AUTOMATICO	\N	\N	2024-12-10 06:59:00+00	2026-01-17 21:31:13.685+00	2026-01-17 21:31:13.685+00	t	\N	CI	30	e148f60c-2aeb-442f-b302-491f4e0eca2b
0d54087a-ae0a-4241-83ac-f10f72456ebe	2024	159	4a837a56-b513-4568-b2d7-61bc1d66d22b	fedc5975-2697-4b57-b26d-492a64ef6cc8	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-10-23 19:20:00+00	2024-11-08 14:05:00+00	\N	AUTOMATICO	\N	\N	2024-12-23 14:05:00+00	2026-01-17 21:31:13.693+00	2026-01-17 21:31:13.693+00	t	\N	COMERCIAL	30	9a9b3bcd-4b8f-4aba-8ea5-3ec890e23fee
9a69138b-eb69-476a-b861-8d3c25332438	2024	160	04b53087-52e8-4656-be93-714c343c47d6	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-11-01 07:25:00+00	2024-12-12 21:10:00+00	\N	AUTOMATICO	\N	\N	2025-01-26 21:10:00+00	2026-01-17 21:31:13.701+00	2026-01-17 21:31:13.701+00	t	\N	COMERCIAL	60	66d4eb59-5d54-446b-9ee0-88fa9c133899
584cd44a-972d-4075-a258-df2a58e3267a	2024	162	a16cce31-d12d-458a-b212-6846185933bf	1f5e5c39-7fd2-4fb1-8697-d5e0e9a4022b	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-11-02 23:35:00+00	2024-11-23 08:30:00+00	\N	AUTOMATICO	\N	\N	2025-01-07 08:30:00+00	2026-01-17 21:31:13.709+00	2026-01-17 21:31:13.709+00	t	\N	COMERCIAL	30	df1d26fb-7984-43c7-8831-6c8fa0d6b4f5
f18a9b09-baa6-4914-a3fa-f241b0d08c5d	2023	161	f0cfd06a-b006-4dc5-ada1-3a7e9ba760ad	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2023-12-28 00:50:00+00	2024-02-01 09:30:00+00	\N	AUTOMATICO	\N	\N	2024-03-17 09:30:00+00	2026-01-17 21:31:13.718+00	2026-01-17 21:31:13.718+00	t	\N	COMERCIAL	60	6174f8ea-bada-4606-8acd-463215aef2f0
d01f9b5f-933d-4ddf-9287-225434351659	2024	110	1f6cbb5f-d134-4ee3-9315-bf24ae2a7946	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-07-05 19:50:00+00	2024-07-09 11:00:00+00	\N	AUTOMATICO	\N	\N	2024-08-23 11:00:00+00	2026-01-17 21:31:14.66+00	2026-01-17 21:31:14.66+00	t	\N	COMERCIAL	30	df1d26fb-7984-43c7-8831-6c8fa0d6b4f5
3f78129e-a816-4f18-be79-9c3a00c39927	2024	124	55b9680b-a422-457c-b103-efc7f46c952e	fedc5975-2697-4b57-b26d-492a64ef6cc8	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-08-06 22:10:00+00	2024-08-19 11:35:00+00	\N	AUTOMATICO	\N	\N	2024-10-03 11:35:00+00	2026-01-17 21:31:14.668+00	2026-01-17 21:31:14.668+00	t	\N	COMERCIAL	30	df1d26fb-7984-43c7-8831-6c8fa0d6b4f5
c5461ddf-2277-442c-9790-c8c8289d8cd8	2024	14	7d23c84f-115a-4318-9e29-aa24a4809280	1f5e5c39-7fd2-4fb1-8697-d5e0e9a4022b	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-01-16 16:25:00+00	2024-02-02 00:00:00+00	\N	AUTOMATICO	\N	\N	2024-03-18 00:00:00+00	2026-01-17 21:31:14.675+00	2026-01-17 21:31:14.675+00	t	\N	COMERCIAL	30	9ca0a15b-a857-4fab-9747-b620717776dd
7166cd74-d9ad-4c53-b39e-53a1a5894cfc	2024	81	04b53087-52e8-4656-be93-714c343c47d6	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-05-24 22:00:00+00	2024-06-09 12:30:00+00	\N	AUTOMATICO	\N	\N	2024-07-24 12:30:00+00	2026-01-17 21:31:14.683+00	2026-01-17 21:31:14.683+00	t	\N	COMERCIAL	60	9ca0a15b-a857-4fab-9747-b620717776dd
5910e5b7-2db5-480e-836c-0019c41f8fbf	2024	122	7d23c84f-115a-4318-9e29-aa24a4809280	1f5e5c39-7fd2-4fb1-8697-d5e0e9a4022b	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-08-02 13:25:00+00	2024-09-11 10:50:00+00	\N	AUTOMATICO	\N	\N	2024-10-26 10:50:00+00	2026-01-17 21:31:14.69+00	2026-01-17 21:31:14.69+00	t	\N	COMERCIAL	30	9ca0a15b-a857-4fab-9747-b620717776dd
c85de383-4138-4970-8edc-067391d7912d	2024	163	7d23c84f-115a-4318-9e29-aa24a4809280	1f5e5c39-7fd2-4fb1-8697-d5e0e9a4022b	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-10-31 00:00:00+00	2024-11-11 14:55:00+00	\N	AUTOMATICO	\N	\N	2024-12-26 14:55:00+00	2026-01-17 21:31:14.697+00	2026-01-17 21:31:14.697+00	t	\N	COMERCIAL	30	9ca0a15b-a857-4fab-9747-b620717776dd
9580c648-783e-472a-841c-98fd0edd43d1	2024	53	bf9011e3-436b-477e-adc9-5fdf755c9b63	fedc5975-2697-4b57-b26d-492a64ef6cc8	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-03-28 18:12:00+00	2024-04-26 21:05:00+00	\N	AUTOMATICO	\N	\N	2024-06-10 21:05:00+00	2026-01-17 21:31:14.705+00	2026-01-17 21:31:14.705+00	t	\N	COMERCIAL	30	db07cb61-a820-4e11-9f7b-ea45e577d167
5292e83c-d5fc-4991-91ba-4b0398aab882	2024	69	dd7184b3-9ccd-4515-a117-02184abda5ff	fedc5975-2697-4b57-b26d-492a64ef6cc8	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-04-30 14:30:00+00	2024-05-19 10:49:00+00	\N	AUTOMATICO	\N	\N	2024-07-03 10:49:00+00	2026-01-17 21:31:14.711+00	2026-01-17 21:31:14.711+00	t	\N	COMERCIAL	30	db07cb61-a820-4e11-9f7b-ea45e577d167
686dc608-e3cd-47bd-9497-c0898cdde0a3	2024	90	854c142e-a45b-4022-9411-52c786baa572	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-05-23 18:15:00+00	2024-06-13 14:36:00+00	\N	AUTOMATICO	\N	\N	2024-07-28 14:36:00+00	2026-01-17 21:31:14.718+00	2026-01-17 21:31:14.718+00	t	\N	COMERCIAL	30	db07cb61-a820-4e11-9f7b-ea45e577d167
ed8dd927-59bb-47b8-9efb-1aaa4a1f623c	2024	99	dd7184b3-9ccd-4515-a117-02184abda5ff	fedc5975-2697-4b57-b26d-492a64ef6cc8	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-06-19 21:40:00+00	2024-08-02 11:20:00+00	\N	AUTOMATICO	\N	\N	2024-09-16 11:20:00+00	2026-01-17 21:31:14.727+00	2026-01-17 21:31:14.727+00	t	\N	COMERCIAL	30	db07cb61-a820-4e11-9f7b-ea45e577d167
03b57cb0-979d-47bd-a034-a3b7b775ca66	2024	121	dd7184b3-9ccd-4515-a117-02184abda5ff	fedc5975-2697-4b57-b26d-492a64ef6cc8	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-08-03 17:47:00+00	2024-08-13 13:15:00+00	\N	AUTOMATICO	\N	\N	2024-09-27 13:15:00+00	2026-01-17 21:31:14.734+00	2026-01-17 21:31:14.734+00	t	\N	COMERCIAL	30	db07cb61-a820-4e11-9f7b-ea45e577d167
0a66aeb0-6995-43d6-94b2-7620092d85b1	2024	21	f0cfd06a-b006-4dc5-ada1-3a7e9ba760ad	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-02-03 09:55:00+00	2024-03-20 03:00:00+00	\N	AUTOMATICO	\N	\N	2024-05-04 03:00:00+00	2026-01-17 21:31:14.741+00	2026-01-17 21:31:14.741+00	t	\N	COMERCIAL	60	b6f9e1cc-7022-4f80-8f1d-a8392c9193df
5e83bbb9-37aa-47bd-ace2-ac7770bcc64b	2024	61	863ff4de-02ab-477a-b726-83d3e9148648	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-04-20 14:15:00+00	2024-05-25 12:45:00+00	\N	AUTOMATICO	\N	\N	2024-07-09 12:45:00+00	2026-01-17 21:31:14.747+00	2026-01-17 21:31:14.747+00	t	\N	COMERCIAL	60	b6f9e1cc-7022-4f80-8f1d-a8392c9193df
dfee9dad-b4dd-4454-bb0c-908beff14d7a	2024	103	face2a5f-184c-41f8-b3a8-9beebc3635ee	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-07-02 20:50:00+00	2024-07-31 16:31:00+00	\N	AUTOMATICO	\N	\N	2024-09-14 16:31:00+00	2026-01-17 21:31:14.754+00	2026-01-17 21:31:14.754+00	t	\N	COMERCIAL	60	b6f9e1cc-7022-4f80-8f1d-a8392c9193df
f1920acc-85c6-44df-86a8-41c546609916	2024	27	face2a5f-184c-41f8-b3a8-9beebc3635ee	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-02-07 18:15:00+00	2024-03-13 15:10:00+00	\N	AUTOMATICO	\N	\N	2024-04-27 15:10:00+00	2026-01-17 21:31:14.762+00	2026-01-17 21:31:14.762+00	t	\N	COMERCIAL	60	fb61c911-79f8-45ed-8e0e-23bfa3a9ad2b
6685e8d6-f452-4a7e-8c14-a2ec3807405c	2024	66	b88d3a8d-a83a-4a6b-a566-85bf97fb3fb7	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-04-26 16:40:00+00	2024-05-26 18:50:00+00	\N	AUTOMATICO	\N	\N	2024-07-10 18:50:00+00	2026-01-17 21:31:14.769+00	2026-01-17 21:31:14.769+00	t	\N	COMERCIAL	60	fb61c911-79f8-45ed-8e0e-23bfa3a9ad2b
f18fe2b0-89fc-432a-b30d-dc67532e0ef2	2024	91	b88d3a8d-a83a-4a6b-a566-85bf97fb3fb7	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-05-29 15:40:00+00	2024-06-30 08:20:00+00	\N	AUTOMATICO	\N	\N	2024-08-14 08:20:00+00	2026-01-17 21:31:14.776+00	2026-01-17 21:31:14.776+00	t	\N	COMERCIAL	60	fb61c911-79f8-45ed-8e0e-23bfa3a9ad2b
7bf159fd-2222-40d6-b731-ca8142eb9759	2024	114	9feec5a5-4b57-4bd9-98ed-770ea7509a63	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-07-17 08:42:00+00	2024-08-20 07:31:00+00	\N	AUTOMATICO	\N	\N	2024-10-04 07:31:00+00	2026-01-17 21:31:14.784+00	2026-01-17 21:31:14.784+00	t	\N	COMERCIAL	60	fb61c911-79f8-45ed-8e0e-23bfa3a9ad2b
7200da53-4fdc-459e-80f8-71d581ecfd82	2024	134	9feec5a5-4b57-4bd9-98ed-770ea7509a63	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-09-02 19:00:00+00	2024-10-09 06:50:00+00	\N	AUTOMATICO	\N	\N	2024-11-23 06:50:00+00	2026-01-17 21:31:14.792+00	2026-01-17 21:31:14.792+00	t	\N	COMERCIAL	60	fb61c911-79f8-45ed-8e0e-23bfa3a9ad2b
6222e8ae-a7f8-4728-a647-55067706fc00	2024	20	7a5c52c3-f87e-4405-a08e-f3b2ae274460	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-01-22 03:08:00+00	2024-01-29 01:42:00+00	\N	AUTOMATICO	\N	\N	2024-03-14 01:42:00+00	2026-01-17 21:31:14.799+00	2026-01-17 21:31:14.799+00	t	\N	COMERCIAL	30	20b0118b-9612-4fa8-b90c-5e11e27b07e3
e3fcbb6e-adab-45c0-8abd-ba8994822850	2024	56	d623606d-b5f4-4a44-be99-7f1b7b891651	fedc5975-2697-4b57-b26d-492a64ef6cc8	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-03-28 09:10:00+00	2024-04-15 12:45:00+00	\N	AUTOMATICO	\N	\N	2024-05-30 12:45:00+00	2026-01-17 21:31:14.806+00	2026-01-17 21:31:14.806+00	t	\N	COMERCIAL	30	20b0118b-9612-4fa8-b90c-5e11e27b07e3
e172c7c7-293d-4002-bbb2-e2083806984b	2024	84	e5248c3a-7a81-49fa-a6a2-466a1cdc60df	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-05-22 00:00:00+00	2024-06-09 00:00:00+00	\N	AUTOMATICO	\N	\N	2024-07-24 00:00:00+00	2026-01-17 21:31:14.812+00	2026-01-17 21:31:14.812+00	t	\N	COMERCIAL	30	20b0118b-9612-4fa8-b90c-5e11e27b07e3
3f2d7f2d-22b2-46a5-8172-b6974418d645	2024	125	37fb0bff-71cf-474c-ac99-dfe32eb068d3	fedc5975-2697-4b57-b26d-492a64ef6cc8	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-08-08 19:15:00+00	2024-08-22 15:00:00+00	\N	AUTOMATICO	\N	\N	2024-10-06 15:00:00+00	2026-01-17 21:31:14.819+00	2026-01-17 21:31:14.819+00	t	\N	COMERCIAL	\N	20b0118b-9612-4fa8-b90c-5e11e27b07e3
d904c6d9-3744-4cb6-a107-5d9d81e9a006	2024	62	9a35efaa-cc4c-4fb6-afaa-f48e7709c800	57d68d17-afe4-47b5-baf5-4e4791069319	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-04-20 16:22:00+00	2024-05-15 09:06:00+00	\N	AUTOMATICO	\N	\N	2024-06-29 09:06:00+00	2026-01-17 21:31:14.826+00	2026-01-17 21:31:14.826+00	t	\N	COMERCIAL	40	08b99f65-0ed6-4e7b-ad1c-1496777a7263
cb82ee3f-5e33-423e-9642-70420dd66759	2024	95	73c502e2-397a-499f-b4f7-cb8dce8260b7	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-06-12 10:33:00+00	2024-06-18 10:54:00+00	\N	AUTOMATICO	\N	\N	2024-08-02 10:54:00+00	2026-01-17 21:31:14.833+00	2026-01-17 21:31:14.833+00	t	\N	COMERCIAL	30	08b99f65-0ed6-4e7b-ad1c-1496777a7263
2d7d92a3-99e9-45e4-9994-d7e70e755b2c	2024	136	8e64df56-3b39-4321-8c31-98bff1ad28b3	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-09-02 22:00:00+00	2024-09-24 06:05:00+00	\N	AUTOMATICO	\N	\N	2024-11-08 06:05:00+00	2026-01-17 21:31:14.84+00	2026-01-17 21:31:14.84+00	t	\N	COMERCIAL	60	08b99f65-0ed6-4e7b-ad1c-1496777a7263
089b3c97-73cb-4c31-960b-30f6a6584f90	2024	35	3f5729dd-4d20-4e27-a7f1-ef46d30e973d	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-02-22 18:00:00+00	2024-03-03 11:34:00+00	\N	AUTOMATICO	\N	\N	2024-04-17 11:34:00+00	2026-01-17 21:31:14.846+00	2026-01-17 21:31:14.846+00	t	\N	COMERCIAL	30	ccd3c2b4-fdfd-4d4e-b6c6-1a0dbbc02cf3
df1c0975-7245-4b63-857d-b8e50070b832	2024	119	abfe526f-bf85-4dc2-89c7-557bfa93dbc3	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-08-02 18:10:00+00	2024-08-09 08:59:00+00	\N	AUTOMATICO	\N	\N	2024-09-23 08:59:00+00	2026-01-17 21:31:14.853+00	2026-01-17 21:31:14.853+00	t	\N	COMERCIAL	30	ccd3c2b4-fdfd-4d4e-b6c6-1a0dbbc02cf3
107ee663-91ec-4bcb-bfca-d6456178f532	2024	141	28951b47-241f-46bb-9aa3-97f42bd51686	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-09-06 17:10:00+00	2024-09-13 06:27:00+00	\N	AUTOMATICO	\N	\N	2024-10-28 06:27:00+00	2026-01-17 21:31:14.859+00	2026-01-17 21:31:14.859+00	t	\N	COMERCIAL	30	ccd3c2b4-fdfd-4d4e-b6c6-1a0dbbc02cf3
3aa4d800-112e-431c-ab78-16836a5c9227	2024	33	3e0c8867-184b-437a-a2b6-482cf522af0a	57d68d17-afe4-47b5-baf5-4e4791069319	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-02-23 10:40:00+00	2024-03-25 17:15:00+00	\N	AUTOMATICO	\N	\N	2024-05-09 17:15:00+00	2026-01-17 21:31:14.866+00	2026-01-17 21:31:14.866+00	t	\N	COMERCIAL	40	df1d26fb-7984-43c7-8831-6c8fa0d6b4f5
08ae1dc1-b6a1-40da-a2d2-38f9ecd2cd2d	2024	73	0a7aed5b-7fc3-4b95-aeea-754431932603	fedc5975-2697-4b57-b26d-492a64ef6cc8	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-05-02 15:55:00+00	2024-05-20 09:30:00+00	\N	AUTOMATICO	\N	\N	2024-07-04 09:30:00+00	2026-01-17 21:31:14.874+00	2026-01-17 21:31:14.874+00	t	\N	COMERCIAL	30	df1d26fb-7984-43c7-8831-6c8fa0d6b4f5
a5f5f381-9934-468a-aec3-8d76c001ec33	2024	24	e70330eb-bcaf-472c-9906-1096de4235dd	1f5e5c39-7fd2-4fb1-8697-d5e0e9a4022b	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-02-06 21:35:00+00	2024-03-03 09:15:00+00	\N	AUTOMATICO	\N	\N	2024-04-17 09:15:00+00	2026-01-17 21:31:14.88+00	2026-01-17 21:31:14.88+00	t	\N	COMERCIAL	30	b500d7bc-3760-4c88-9a21-4294b2395c71
6ba4a39a-a4ab-4162-b4eb-b41f9a05a79c	2024	112	5fa98bd7-f095-4d3e-8e98-7761568ec108	fedc5975-2697-4b57-b26d-492a64ef6cc8	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-07-11 16:50:00+00	2024-08-07 12:35:00+00	\N	AUTOMATICO	\N	\N	2024-09-21 12:35:00+00	2026-01-17 21:31:14.887+00	2026-01-17 21:31:14.887+00	t	\N	COMERCIAL	45	b500d7bc-3760-4c88-9a21-4294b2395c71
835a98e2-e457-4ded-9785-1a9d25954896	2024	130	649e5ded-9a48-4bf8-aaa1-2edf147fe587	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-08-16 15:46:00+00	2024-08-24 12:50:00+00	\N	AUTOMATICO	\N	\N	2024-10-08 12:50:00+00	2026-01-17 21:31:14.895+00	2026-01-17 21:31:14.895+00	t	\N	COMERCIAL	30	b500d7bc-3760-4c88-9a21-4294b2395c71
2a021427-35d8-4735-80f1-f3713ea5eb1a	2024	133	0ddb5663-8ab9-4ad5-ab76-fb98b2e5d15d	fedc5975-2697-4b57-b26d-492a64ef6cc8	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-08-29 14:05:00+00	2024-10-15 18:40:00+00	\N	AUTOMATICO	\N	\N	2024-11-29 18:40:00+00	2026-01-17 21:31:14.902+00	2026-01-17 21:31:14.902+00	t	\N	COMERCIAL	40	b500d7bc-3760-4c88-9a21-4294b2395c71
1925f7e5-6f32-4848-ac54-f981b7beb94e	2024	173	ba0b91e3-29d6-4028-acb8-c8256fa2aaf8	57d68d17-afe4-47b5-baf5-4e4791069319	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-12-28 13:10:00+00	2025-01-16 14:00:00+00	\N	AUTOMATICO	\N	\N	2025-03-02 14:00:00+00	2026-01-17 21:31:14.908+00	2026-01-17 21:31:14.908+00	t	\N	COMERCIAL	40	ea89e630-34ba-4705-98d9-8b662af90e3c
33b8e975-708b-4e2c-9079-3babbff08524	2024	161	f0cfd06a-b006-4dc5-ada1-3a7e9ba760ad	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-11-03 18:35:00+00	2024-12-19 04:00:00+00	\N	AUTOMATICO	\N	\N	2025-02-02 04:00:00+00	2026-01-17 21:31:14.915+00	2026-01-17 21:31:14.915+00	t	\N	COMERCIAL	60	a21b30af-c563-4c43-9d68-bafd0243c5e6
bccaa707-1b57-4ff6-8033-4e7817e1c5f2	2024	7	adc23180-9487-47ad-9e3d-62eade83623a	1f5e5c39-7fd2-4fb1-8697-d5e0e9a4022b	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-10-06 22:40:00+00	2025-10-10 00:00:00+00	\N	AUTOMATICO	\N	\N	2025-11-24 00:00:00+00	2026-01-17 21:31:14.923+00	2026-01-17 21:31:14.923+00	t	\N	CI	30	dfbdeeff-4e60-46c2-9ce0-7becb9a494a2
30a55e75-b984-4d3a-a9a3-6cc79261c835	2024	176	adc23180-9487-47ad-9e3d-62eade83623a	1f5e5c39-7fd2-4fb1-8697-d5e0e9a4022b	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-12-30 22:34:00+00	2025-01-27 04:45:00+00	\N	AUTOMATICO	\N	\N	2025-03-13 04:45:00+00	2026-01-17 21:31:14.929+00	2026-01-17 21:31:14.929+00	t	\N	COMERCIAL	30	dfbdeeff-4e60-46c2-9ce0-7becb9a494a2
b5bfa7b0-e16f-42e8-b421-5ccb2d65b2bb	2024	175	e70330eb-bcaf-472c-9906-1096de4235dd	1f5e5c39-7fd2-4fb1-8697-d5e0e9a4022b	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-12-31 05:20:00+00	2025-02-04 04:52:00+00	\N	AUTOMATICO	\N	\N	2025-03-21 04:52:00+00	2026-01-17 21:31:14.936+00	2026-01-17 21:31:14.936+00	t	\N	COMERCIAL	30	7210834c-47be-440a-81d2-a5fc53a8934b
87919b14-60c2-4f58-8b2d-d2c8cea655b1	2025	1	04b53087-52e8-4656-be93-714c343c47d6	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-01-03 04:35:00+00	2025-02-03 01:35:00+00	\N	AUTOMATICO	\N	\N	2025-03-20 01:35:00+00	2026-01-17 21:31:14.942+00	2026-01-17 21:31:14.942+00	t	\N	COMERCIAL	60	cded2d3e-5f9e-4de6-9269-a1da3eeeff0a
251206d0-7b9e-4247-905d-44ad002516c2	2024	149	face2a5f-184c-41f8-b3a8-9beebc3635ee	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-10-04 10:09:00+00	2024-10-07 08:05:00+00	\N	AUTOMATICO	\N	\N	2024-11-21 08:05:00+00	2026-01-17 21:31:14.957+00	2026-01-17 21:31:14.957+00	t	\N	COMERCIAL	60	d7785cda-1f2e-4d29-a52d-335b2096bde6
79040bac-e3f9-4f9f-b0fc-93360063ef7c	2025	7	3c111b3e-1c42-49b4-b579-168516f1dc1f	57d68d17-afe4-47b5-baf5-4e4791069319	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-01-07 16:40:00+00	2025-01-30 08:50:00+00	\N	AUTOMATICO	\N	\N	2025-03-16 08:50:00+00	2026-01-17 21:31:14.964+00	2026-01-17 21:31:14.964+00	t	\N	COMERCIAL	40	d7785cda-1f2e-4d29-a52d-335b2096bde6
ac7e03d7-42e1-4902-a530-8afd2e8c2750	2025	9	4a837a56-b513-4568-b2d7-61bc1d66d22b	fedc5975-2697-4b57-b26d-492a64ef6cc8	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-01-06 20:55:00+00	2025-02-07 09:45:00+00	\N	AUTOMATICO	\N	\N	2025-03-24 09:45:00+00	2026-01-17 21:31:14.97+00	2026-01-17 21:31:14.97+00	t	\N	COMERCIAL	30	9a9b3bcd-4b8f-4aba-8ea5-3ec890e23fee
16904ecf-f79d-4434-9445-1e6e9f33ddfc	2025	14	c7c5892b-d6ee-4b44-b3a6-24dc9ded90aa	57d68d17-afe4-47b5-baf5-4e4791069319	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-01-09 11:25:00+00	2025-02-08 21:54:00+00	\N	AUTOMATICO	\N	\N	2025-03-25 21:54:00+00	2026-01-17 21:31:14.991+00	2026-01-17 21:31:14.991+00	t	\N	COMERCIAL	40	8644b80c-97af-46cf-9f4d-711749582de1
8caf5618-e1b6-4fd8-84db-e744a800b5c6	2025	11	3e0c8867-184b-437a-a2b6-482cf522af0a	57d68d17-afe4-47b5-baf5-4e4791069319	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-01-09 15:00:00+00	2025-02-02 19:58:00+00	\N	AUTOMATICO	\N	\N	2025-03-19 19:58:00+00	2026-01-17 21:31:14.999+00	2026-01-17 21:31:14.999+00	t	\N	COMERCIAL	40	e82e6994-7b2a-4fd4-a699-665a2c81d083
73e9a605-4d0f-43e1-ad45-332ac496af8b	2025	4	a12653df-c0ca-4814-8442-78636dfa6d94	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-01-11 12:37:00+00	2025-03-07 11:14:00+00	\N	AUTOMATICO	\N	\N	2025-04-21 11:14:00+00	2026-01-17 21:31:15.007+00	2026-01-17 21:31:15.007+00	t	\N	COMERCIAL	60	fb61c911-79f8-45ed-8e0e-23bfa3a9ad2b
6e9d2370-746c-4ad1-be73-b8810eb0a9b0	2025	16	0ddb5663-8ab9-4ad5-ab76-fb98b2e5d15d	fedc5975-2697-4b57-b26d-492a64ef6cc8	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-01-17 23:35:00+00	2025-03-01 19:40:00+00	\N	AUTOMATICO	\N	\N	2025-04-15 19:40:00+00	2026-01-17 21:31:15.014+00	2026-01-17 21:31:15.014+00	t	\N	COMERCIAL	40	66d4eb59-5d54-446b-9ee0-88fa9c133899
d0c53136-1cee-43f9-bb0c-cd1ab21647da	2025	28	69ff7a7d-9417-4f5c-9693-8e2835fef39b	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-02-05 00:00:00+00	2025-04-07 00:00:00+00	\N	AUTOMATICO	\N	\N	2025-05-22 00:00:00+00	2026-01-17 21:31:15.027+00	2026-01-17 21:31:15.027+00	t	\N	COMERCIAL	60	e148f60c-2aeb-442f-b302-491f4e0eca2b
e9cce076-b230-4d2f-8781-4d6354a46d0e	2025	33	7a5c52c3-f87e-4405-a08e-f3b2ae274460	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-02-18 11:27:00+00	2025-02-25 20:17:00+00	\N	AUTOMATICO	\N	\N	2025-04-11 20:17:00+00	2026-01-17 21:31:15.034+00	2026-01-17 21:31:15.034+00	t	\N	COMERCIAL	30	d7785cda-1f2e-4d29-a52d-335b2096bde6
2c7e0f5f-b5c2-4c9b-8565-2ad257bf4810	2025	32	f0cfd06a-b006-4dc5-ada1-3a7e9ba760ad	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-02-19 00:00:00+00	2025-04-11 09:30:00+00	\N	AUTOMATICO	\N	\N	2025-05-26 09:30:00+00	2026-01-17 21:31:15.04+00	2026-01-17 21:31:15.04+00	t	\N	COMERCIAL	60	dfbdeeff-4e60-46c2-9ce0-7becb9a494a2
af84f355-8af5-4320-8eee-7c7c40b9704e	2025	37	7d23c84f-115a-4318-9e29-aa24a4809280	1f5e5c39-7fd2-4fb1-8697-d5e0e9a4022b	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-02-22 09:10:00+00	2025-03-26 16:15:00+00	\N	AUTOMATICO	\N	\N	2025-05-10 16:15:00+00	2026-01-17 21:31:15.047+00	2026-01-17 21:31:15.047+00	t	\N	COMERCIAL	30	9a9b3bcd-4b8f-4aba-8ea5-3ec890e23fee
4ce967fa-c707-460d-858c-70bcfce11ef9	2025	34	2df50464-9916-4b3e-b5c3-3a645623d525	fedc5975-2697-4b57-b26d-492a64ef6cc8	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-03-01 13:40:00+00	2025-04-07 11:48:00+00	\N	AUTOMATICO	\N	\N	2025-05-22 11:48:00+00	2026-01-17 21:31:15.059+00	2026-01-17 21:31:15.059+00	t	\N	COMERCIAL	60	e82e6994-7b2a-4fd4-a699-665a2c81d083
e7f4968e-21f5-477b-a740-0c7ab0d2a968	2024	171	7d23c84f-115a-4318-9e29-aa24a4809280	1f5e5c39-7fd2-4fb1-8697-d5e0e9a4022b	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-12-30 23:14:00+00	2025-02-19 11:11:00+00	\N	AUTOMATICO	\N	\N	2025-04-05 11:11:00+00	2026-01-17 21:31:15.074+00	2026-01-17 21:31:15.074+00	t	\N	COMERCIAL	30	df1d26fb-7984-43c7-8831-6c8fa0d6b4f5
e6920a77-cb20-476f-8096-546b90bc72ae	2025	41	08da59fb-fa52-49da-b7ec-6e276d53b841	57d68d17-afe4-47b5-baf5-4e4791069319	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-03-07 16:25:00+00	2025-04-07 12:56:00+00	\N	AUTOMATICO	\N	\N	2025-05-22 12:56:00+00	2026-01-17 21:31:15.08+00	2026-01-17 21:31:15.08+00	t	\N	COMERCIAL	40	6abcf5ef-ae58-4e8c-ae86-335d1478ee3c
9a267a5d-70f1-45c3-9f38-ba35a54b9c69	2025	40	0ddb5663-8ab9-4ad5-ab76-fb98b2e5d15d	fedc5975-2697-4b57-b26d-492a64ef6cc8	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-03-06 18:20:00+00	2025-04-13 23:40:00+00	\N	AUTOMATICO	\N	\N	2025-05-28 23:40:00+00	2026-01-17 21:31:15.093+00	2026-01-17 21:31:15.093+00	t	\N	COMERCIAL	40	66d4eb59-5d54-446b-9ee0-88fa9c133899
31e27489-d08a-4cf3-804d-7d60e7fe3aca	2025	18	28367073-f657-41aa-9604-7adfa455458c	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-01-17 18:40:00+00	2025-03-09 20:51:00+00	\N	AUTOMATICO	\N	\N	2025-04-23 20:51:00+00	2026-01-17 21:31:15.099+00	2026-01-17 21:31:15.099+00	t	\N	COMERCIAL	\N	f644ca0f-bf5f-4449-9c40-7eba742654de
5c53a631-b7a7-4a7e-80bf-e9cf0237b6bb	2025	21	e70330eb-bcaf-472c-9906-1096de4235dd	1f5e5c39-7fd2-4fb1-8697-d5e0e9a4022b	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-02-06 00:08:00+00	2025-03-11 12:30:00+00	\N	AUTOMATICO	\N	\N	2025-04-25 12:30:00+00	2026-01-17 21:31:15.106+00	2026-01-17 21:31:15.106+00	t	\N	COMERCIAL	30	6216f910-4b2f-49bc-b238-f3e15147152c
e5b35988-850d-431f-9172-96a9cf16fb76	2025	22	546c200e-da22-4c78-8c7d-cbdeab4535cd	57d68d17-afe4-47b5-baf5-4e4791069319	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-01-31 14:50:00+00	2025-03-24 09:35:00+00	\N	AUTOMATICO	\N	\N	2025-05-08 09:35:00+00	2026-01-17 21:31:15.113+00	2026-01-17 21:31:15.113+00	t	\N	COMERCIAL	40	0ba0a4ea-eaa3-4d11-b737-5f80e0651fb5
f5af9e00-7d55-424f-b3d8-255e47dab9c9	2025	25	49144ac0-7330-40cf-8ed7-3dd909542a0e	1f5e5c39-7fd2-4fb1-8697-d5e0e9a4022b	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-02-01 12:55:00+00	2025-02-26 06:55:00+00	\N	AUTOMATICO	\N	\N	2025-04-12 06:55:00+00	2026-01-17 21:31:15.12+00	2026-01-17 21:31:15.12+00	t	\N	COMERCIAL	30	06979c36-da6e-4fb0-840e-07533a1d41c7
650dd08b-c34c-4f25-a6b6-60278918e41d	2025	27	82d93396-176a-4d74-a5de-5addaf47520f	57d68d17-afe4-47b5-baf5-4e4791069319	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-02-01 13:18:00+00	2025-03-08 06:19:00+00	\N	AUTOMATICO	\N	\N	2025-04-22 06:19:00+00	2026-01-17 21:31:15.126+00	2026-01-17 21:31:15.126+00	t	\N	COMERCIAL	40	8321194c-0126-4b76-a497-2b06980a61e3
f6c9d06f-029e-4bd4-934a-611687d257ad	2025	29	246d498c-f08a-4cb4-a801-841d2f4d3df5	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-02-08 12:35:00+00	2025-02-22 07:36:00+00	\N	AUTOMATICO	\N	\N	2025-04-08 07:36:00+00	2026-01-17 21:31:15.133+00	2026-01-17 21:31:15.133+00	t	\N	COMERCIAL	30	ccd3c2b4-fdfd-4d4e-b6c6-1a0dbbc02cf3
51249ac3-1cea-4ffa-a9f0-a745dfb07368	2025	30	04b53087-52e8-4656-be93-714c343c47d6	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-02-13 17:05:00+00	2025-05-07 04:20:00+00	\N	AUTOMATICO	\N	\N	2025-06-21 04:20:00+00	2026-01-17 21:31:15.14+00	2026-01-17 21:31:15.14+00	t	\N	COMERCIAL	60	20b0118b-9612-4fa8-b90c-5e11e27b07e3
1bd1e044-82a7-4663-986a-360a74d46039	2025	31	4a837a56-b513-4568-b2d7-61bc1d66d22b	fedc5975-2697-4b57-b26d-492a64ef6cc8	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-02-12 16:34:00+00	2025-03-20 19:07:00+00	\N	AUTOMATICO	\N	\N	2025-05-04 19:07:00+00	2026-01-17 21:31:15.147+00	2026-01-17 21:31:15.147+00	t	\N	COMERCIAL	30	4b60b333-fea6-45cd-bec9-c5eb06a8cd1c
77532613-0fe8-4b42-b0bd-1ff846bc2f8a	2025	50	e7ed7f8b-9e82-48db-94f1-c9c63d3391eb	57d68d17-afe4-47b5-baf5-4e4791069319	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-03-24 00:00:00+00	2025-04-23 00:00:00+00	\N	AUTOMATICO	\N	\N	2025-06-07 00:00:00+00	2026-01-17 21:31:15.155+00	2026-01-17 21:31:15.155+00	t	\N	COMERCIAL	40	06979c36-da6e-4fb0-840e-07533a1d41c7
a7064b43-b18d-4eb5-9651-6ffe9132095a	2025	53	c7c5892b-d6ee-4b44-b3a6-24dc9ded90aa	57d68d17-afe4-47b5-baf5-4e4791069319	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-03-28 00:00:00+00	2025-05-05 00:00:00+00	\N	AUTOMATICO	\N	\N	2025-06-19 00:00:00+00	2026-01-17 21:31:15.161+00	2026-01-17 21:31:15.161+00	t	\N	COMERCIAL	40	3aab4c36-1982-4957-8f29-192aba668488
821e19a4-9b0c-4ff3-814c-f30c8e211731	2025	43	b1fedb55-7446-4027-aa7c-1a5dcfcb4ba5	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-03-11 17:05:00+00	2025-03-28 11:35:00+00	\N	AUTOMATICO	\N	\N	2025-05-12 11:35:00+00	2026-01-17 21:31:15.168+00	2026-01-17 21:31:15.168+00	t	\N	COMERCIAL	30	f0a415e0-9538-4336-b681-9d23e0753e26
baaad5c2-fe5b-4e3d-a372-16afe7c895b1	2025	35	863ff4de-02ab-477a-b726-83d3e9148648	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-02-25 00:00:00+00	2025-03-30 00:00:00+00	\N	AUTOMATICO	\N	\N	2025-05-14 00:00:00+00	2026-01-17 21:31:15.054+00	2026-01-18 16:14:57.459+00	t	\N	COMERCIAL	60	b500d7bc-3760-4c88-9a21-4294b2395c71
93d15057-5468-4c3f-a6d2-1b25145fc1a8	2025	20	12964f37-2ef3-4932-9d34-b7ec4410c90b	57d68d17-afe4-47b5-baf5-4e4791069319	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-02-04 16:05:00+00	2025-03-11 04:30:00+00	\N	AUTOMATICO	\N	\N	2025-04-25 04:30:00+00	2026-01-17 21:31:15.087+00	2026-01-18 16:15:14.543+00	t	\N	COMERCIAL	40	c8fdee90-2d16-4800-8a4d-e6b470cf152d
6cecfbac-9a2c-4dd2-b976-45d7e7f4c408	2025	12	5fa98bd7-f095-4d3e-8e98-7761568ec108	fedc5975-2697-4b57-b26d-492a64ef6cc8	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-01-09 23:07:00+00	2025-02-16 22:33:00+00	\N	AUTOMATICO	\N	\N	2025-04-02 22:33:00+00	2026-01-17 21:31:14.984+00	2026-01-18 16:15:55.879+00	t	\N	COMERCIAL	45	b500d7bc-3760-4c88-9a21-4294b2395c71
07da4ec3-6188-4928-8ef9-38c935b76fc8	2025	10	2df50464-9916-4b3e-b5c3-3a645623d525	fedc5975-2697-4b57-b26d-492a64ef6cc8	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-01-13 19:00:00+00	2025-02-24 09:48:00+00	\N	AUTOMATICO	\N	\N	2025-04-10 09:48:00+00	2026-01-17 21:31:15.02+00	2026-01-18 16:16:09.334+00	t	\N	COMERCIAL	60	d1d949b7-00fd-4756-8021-bc80d98ecf71
cd7bd96e-6327-4749-8a87-3c2a7741a499	2025	6	12964f37-2ef3-4932-9d34-b7ec4410c90b	57d68d17-afe4-47b5-baf5-4e4791069319	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-01-09 19:25:00+00	2025-02-02 21:30:00+00	\N	AUTOMATICO	\N	\N	2025-03-19 21:30:00+00	2026-01-17 21:31:14.976+00	2026-01-18 16:16:23.702+00	t	\N	COMERCIAL	40	c8fdee90-2d16-4800-8a4d-e6b470cf152d
8b646927-5b1b-4602-9049-c6fbd485b45f	2025	5	face2a5f-184c-41f8-b3a8-9beebc3635ee	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-01-07 21:42:00+00	2025-01-28 06:45:00+00	\N	AUTOMATICO	\N	\N	2025-03-14 06:45:00+00	2026-01-17 21:31:14.95+00	2026-01-18 16:16:39.29+00	t	\N	COMERCIAL	60	b6f9e1cc-7022-4f80-8f1d-a8392c9193df
fcb1937e-02c8-4b8a-ac45-5560fd9e2306	2025	42	1abed229-2379-475a-aa42-f5799e65c9c8	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-03-11 16:15:00+00	2025-03-28 17:49:00+00	\N	AUTOMATICO	\N	\N	2025-05-12 17:49:00+00	2026-01-17 21:31:15.176+00	2026-01-17 21:31:15.176+00	t	\N	COMERCIAL	30	cd4b5edd-c793-4367-869f-a955a17d8a11
560dfca7-b22c-41c9-bab7-5b421398e1df	2025	36	5fa98bd7-f095-4d3e-8e98-7761568ec108	fedc5975-2697-4b57-b26d-492a64ef6cc8	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-02-21 18:09:00+00	2025-04-02 08:19:00+00	\N	AUTOMATICO	\N	\N	2025-05-17 08:19:00+00	2026-01-17 21:31:15.19+00	2026-01-17 21:31:15.19+00	t	\N	COMERCIAL	45	f60ed9ea-004f-41a9-9d6a-4f34923b1728
35b15911-3cdd-471d-9cd5-d18c28087ed4	2025	1	6a4b71d5-4789-40b2-b402-f0e266a9fdd7	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-04-16 00:00:00+00	2025-05-16 00:00:00+00	\N	AUTOMATICO	\N	\N	2025-06-30 00:00:00+00	2026-01-17 21:31:15.205+00	2026-01-17 21:31:15.205+00	t	\N	CI	\N	02ed999f-1a0c-460a-8c38-0cc464af9b6f
e9928820-e2c0-4aec-8909-e283ad16b46c	2025	61	0ddb5663-8ab9-4ad5-ab76-fb98b2e5d15d	fedc5975-2697-4b57-b26d-492a64ef6cc8	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-04-17 17:00:00+00	2025-05-27 15:20:00+00	\N	AUTOMATICO	\N	\N	2025-07-11 15:20:00+00	2026-01-17 21:31:15.213+00	2026-01-17 21:31:15.213+00	t	\N	COMERCIAL	40	f0a415e0-9538-4336-b681-9d23e0753e26
69c9cad2-be9a-4d93-b729-5451a19af823	2025	52	863ff4de-02ab-477a-b726-83d3e9148648	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-04-01 00:00:00+00	2025-04-27 00:00:00+00	\N	AUTOMATICO	\N	\N	2025-06-11 00:00:00+00	2026-01-17 21:31:15.226+00	2026-01-17 21:31:15.226+00	t	\N	COMERCIAL	60	d88e7e56-7d2c-4edc-aef4-f61e755c586a
42432120-cdf2-4ddc-be23-8294bb6aa44e	2025	26	c6c6fcdc-e445-4e60-8a3f-a70b8e33aab7	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-02-04 12:54:00+00	2025-03-10 13:19:00+00	\N	AUTOMATICO	\N	\N	2025-04-24 13:19:00+00	2026-01-17 21:31:15.232+00	2026-01-17 21:31:15.232+00	t	\N	COMERCIAL	60	e920c268-7682-4e36-8222-bc6cbf215b83
5787dd21-a869-457f-a731-9cd5a2092f2f	2025	58	feea603c-78ed-43b9-85f3-27b6966506bd	57d68d17-afe4-47b5-baf5-4e4791069319	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-04-23 00:00:00+00	2025-05-14 00:00:00+00	\N	AUTOMATICO	\N	\N	2025-06-28 00:00:00+00	2026-01-17 21:31:15.239+00	2026-01-17 21:31:15.239+00	t	\N	COMERCIAL	40	6abcf5ef-ae58-4e8c-ae86-335d1478ee3c
dc63e6ad-2b5c-4a7a-8bbc-b505417a579a	2025	55	f0cfd06a-b006-4dc5-ada1-3a7e9ba760ad	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-04-18 00:00:00+00	2025-05-19 00:00:00+00	\N	AUTOMATICO	\N	\N	2025-07-03 00:00:00+00	2026-01-17 21:31:15.245+00	2026-01-17 21:31:15.245+00	t	\N	COMERCIAL	60	ba8ec778-639d-4dcd-9db2-d7100c84e8f5
b8ff18cb-c296-41a9-957f-adc0e551ffe9	2025	72	863ff4de-02ab-477a-b726-83d3e9148648	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-04-29 17:20:00+00	2025-06-02 19:10:00+00	\N	AUTOMATICO	\N	\N	2025-07-17 19:10:00+00	2026-01-17 21:31:15.259+00	2026-01-17 21:31:15.259+00	t	\N	COMERCIAL	60	a21b30af-c563-4c43-9d68-bafd0243c5e6
56ecf6ac-ea06-442b-a2e3-17055769c9fd	2025	74	b88d3a8d-a83a-4a6b-a566-85bf97fb3fb7	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-04-29 21:15:00+00	2025-05-15 14:45:00+00	\N	AUTOMATICO	\N	\N	2025-06-29 14:45:00+00	2026-01-17 21:31:15.265+00	2026-01-17 21:31:15.265+00	t	\N	COMERCIAL	60	fb61c911-79f8-45ed-8e0e-23bfa3a9ad2b
dff305d8-d504-49aa-ab9c-7e9e1312bd1b	2025	67	c82bf74e-e7d0-45f9-a472-82d0127b3694	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-04-30 15:15:00+00	2025-06-16 18:05:00+00	\N	AUTOMATICO	\N	\N	2025-07-31 18:05:00+00	2026-01-17 21:31:15.28+00	2026-01-17 21:31:15.28+00	t	\N	COMERCIAL	60	e148f60c-2aeb-442f-b302-491f4e0eca2b
6ec3d107-e1c8-46c5-baa5-cf1cad837a19	2025	71	82d93396-176a-4d74-a5de-5addaf47520f	57d68d17-afe4-47b5-baf5-4e4791069319	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-04-30 18:47:00+00	2025-06-05 07:50:00+00	\N	AUTOMATICO	\N	\N	2025-07-20 07:50:00+00	2026-01-17 21:31:15.287+00	2026-01-17 21:31:15.287+00	t	\N	COMERCIAL	40	1f6c3850-8006-4a96-a8b9-96c068b8dbee
b14f6463-136d-4587-adfa-3b4619b0b8e2	2025	77	face2a5f-184c-41f8-b3a8-9beebc3635ee	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-05-04 00:20:00+00	2025-06-03 17:48:00+00	\N	AUTOMATICO	\N	\N	2025-07-18 17:48:00+00	2026-01-17 21:31:15.293+00	2026-01-17 21:31:15.293+00	t	\N	COMERCIAL	60	b9333c64-fa8a-4d22-971b-8447d9cec902
2915796f-f22a-4947-8d55-ae6b613e68fd	2025	78	3e0c8867-184b-437a-a2b6-482cf522af0a	57d68d17-afe4-47b5-baf5-4e4791069319	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-05-07 13:55:00+00	2025-06-09 16:02:00+00	\N	AUTOMATICO	\N	\N	2025-07-24 16:02:00+00	2026-01-17 21:31:15.3+00	2026-01-17 21:31:15.3+00	t	\N	COMERCIAL	40	a4846d61-d1ba-4641-b155-1dc30725e33a
9068cc0b-d9c6-4368-bd9b-16f58da6c34f	2025	79	c7c5892b-d6ee-4b44-b3a6-24dc9ded90aa	57d68d17-afe4-47b5-baf5-4e4791069319	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-05-07 14:55:00+00	2025-06-10 11:07:00+00	\N	AUTOMATICO	\N	\N	2025-07-25 11:07:00+00	2026-01-17 21:31:15.307+00	2026-01-17 21:31:15.307+00	t	\N	COMERCIAL	40	8ef5a63a-64fd-4821-bc0b-a785c10a056f
69b3ac7a-3942-4dfa-a91c-0d8aa99eda98	2025	75	04b53087-52e8-4656-be93-714c343c47d6	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-05-08 16:25:00+00	2025-06-17 04:30:00+00	\N	AUTOMATICO	\N	\N	2025-08-01 04:30:00+00	2026-01-17 21:31:15.32+00	2026-01-17 21:31:15.32+00	t	\N	COMERCIAL	60	b33fd685-31a6-4510-a970-09a2d428a1bb
6594b694-a981-4ed1-8b72-83f6096bc71e	2025	70	3f5729dd-4d20-4e27-a7f1-ef46d30e973d	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-05-02 15:10:00+00	2025-05-21 09:23:00+00	\N	AUTOMATICO	\N	\N	2025-07-05 09:23:00+00	2026-01-17 21:31:15.326+00	2026-01-17 21:31:15.326+00	t	\N	COMERCIAL	30	30fef00d-f9ee-4362-b430-5819b4bde400
b24cff8b-4a57-4f85-8498-6ae2e97bab5b	2025	45	887ff179-0c25-4956-9165-09125f9152f0	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-03-11 20:36:00+00	2025-03-27 21:00:00+00	\N	AUTOMATICO	\N	\N	2025-05-11 21:00:00+00	2026-01-17 21:31:15.333+00	2026-01-17 21:31:15.333+00	t	\N	COMERCIAL	30	d7785cda-1f2e-4d29-a52d-335b2096bde6
2d6a680f-efb4-43fa-99fc-7c29b5170260	2025	23	a55f3785-99ec-4342-84b4-1920e07cbda0	57d68d17-afe4-47b5-baf5-4e4791069319	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-01-29 05:23:00+00	2025-04-06 17:20:00+00	\N	AUTOMATICO	\N	\N	2025-05-21 17:20:00+00	2026-01-17 21:31:15.339+00	2026-01-17 21:31:15.339+00	t	\N	COMERCIAL	40	b33fd685-31a6-4510-a970-09a2d428a1bb
f5a5762b-184c-4534-82ae-fa407a1c970b	2025	81	a16cce31-d12d-458a-b212-6846185933bf	1f5e5c39-7fd2-4fb1-8697-d5e0e9a4022b	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-05-15 10:47:00+00	2025-05-27 12:47:00+00	\N	AUTOMATICO	\N	\N	2025-07-11 12:47:00+00	2026-01-17 21:31:15.346+00	2026-01-17 21:31:15.346+00	t	\N	COMERCIAL	30	7210834c-47be-440a-81d2-a5fc53a8934b
4cb75125-40df-42e6-9d4d-81112eddb56b	2025	80	c1fb290e-10a9-4cef-9075-929f585122f3	fedc5975-2697-4b57-b26d-492a64ef6cc8	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-05-11 07:00:00+00	2025-05-18 10:25:00+00	\N	AUTOMATICO	\N	\N	2025-07-02 10:25:00+00	2026-01-17 21:31:15.352+00	2026-01-17 21:31:15.352+00	t	\N	COMERCIAL	30	dfbdeeff-4e60-46c2-9ce0-7becb9a494a2
d15515d9-a8e4-414e-b3cb-f2a7e77f9da4	2025	59	2df50464-9916-4b3e-b5c3-3a645623d525	fedc5975-2697-4b57-b26d-492a64ef6cc8	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-04-22 17:42:00+00	2025-06-06 07:51:00+00	\N	AUTOMATICO	\N	\N	2025-07-21 07:51:00+00	2026-01-17 21:31:15.358+00	2026-01-17 21:31:15.358+00	t	\N	COMERCIAL	60	f644ca0f-bf5f-4449-9c40-7eba742654de
701fcc04-0fb7-411b-9b2e-67f8e48bccba	2025	68	a1b563e1-607a-4532-8d14-0ecc7ee1fe20	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-04-26 11:30:00+00	2025-05-27 12:46:00+00	\N	AUTOMATICO	\N	\N	2025-07-11 12:46:00+00	2026-01-17 21:31:15.365+00	2026-01-17 21:31:15.365+00	t	\N	COMERCIAL	30	0d45342c-ecad-45a7-bb51-ebce9779c000
c7f2727f-b7d2-4f05-b7e7-2a715d90a560	2025	83	a12653df-c0ca-4814-8442-78636dfa6d94	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-05-17 15:42:00+00	2025-07-13 10:03:00+00	\N	AUTOMATICO	\N	\N	2025-08-27 10:03:00+00	2026-01-17 21:31:15.372+00	2026-01-17 21:31:15.372+00	t	\N	COMERCIAL	60	a8bff414-46d6-4502-9537-eeda82ec5fa8
013a62c5-d08a-41db-b8d8-a2733f29d13e	2025	2	863ff4de-02ab-477a-b726-83d3e9148648	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-01-04 21:00:00+00	2025-01-28 15:40:00+00	\N	AUTOMATICO	\N	\N	2025-03-14 15:40:00+00	2026-01-17 21:31:15.379+00	2026-01-17 21:31:15.379+00	t	\N	COMERCIAL	60	ba8ec778-639d-4dcd-9db2-d7100c84e8f5
3d688d09-cdae-4b40-9b23-3fc49fb71f05	2025	24	863ff4de-02ab-477a-b726-83d3e9148648	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-02-01 01:00:00+00	2025-02-22 21:00:00+00	\N	AUTOMATICO	\N	\N	2025-04-08 21:00:00+00	2026-01-17 21:31:15.385+00	2026-01-17 21:31:15.385+00	t	\N	COMERCIAL	60	ba8ec778-639d-4dcd-9db2-d7100c84e8f5
e826e24f-56fd-4258-9d1d-830e442aa085	2025	44	c5d2228b-36be-4674-8c03-14f817316ca7	fedc5975-2697-4b57-b26d-492a64ef6cc8	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-03-12 11:32:00+00	2025-03-29 11:00:00+00	\N	AUTOMATICO	\N	\N	2025-05-13 11:00:00+00	2026-01-17 21:31:15.392+00	2026-01-17 21:31:15.392+00	t	\N	COMERCIAL	30	cded2d3e-5f9e-4de6-9269-a1da3eeeff0a
00d390a4-c119-47a8-9284-94044f94f718	2025	19	adc23180-9487-47ad-9e3d-62eade83623a	1f5e5c39-7fd2-4fb1-8697-d5e0e9a4022b	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-01-31 17:45:00+00	2025-03-14 21:00:00+00	\N	AUTOMATICO	\N	\N	2025-04-28 21:00:00+00	2026-01-17 21:31:15.399+00	2026-01-17 21:31:15.399+00	t	\N	COMERCIAL	30	3aab4c36-1982-4957-8f29-192aba668488
695ea99f-bce2-4c73-a9a6-bdf16c8bd89e	2025	49	1552d8ac-53ec-4246-a410-f2c7bf19e516	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-03-19 17:40:00+00	2025-04-23 19:50:00+00	\N	AUTOMATICO	\N	\N	2025-06-07 19:50:00+00	2026-01-17 21:31:15.406+00	2026-01-17 21:31:15.406+00	t	\N	COMERCIAL	60	fb61c911-79f8-45ed-8e0e-23bfa3a9ad2b
489e836e-493f-492c-b15e-791e08a03b56	2025	46	57eeedea-6643-47ae-9017-be61cf330cb5	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-03-07 16:05:00+00	2025-03-18 17:35:00+00	\N	AUTOMATICO	\N	\N	2025-05-02 17:35:00+00	2026-01-17 21:31:15.412+00	2026-01-17 21:31:15.412+00	t	\N	COMERCIAL	30	dae8fea3-9440-4fd0-8212-7c8d9c5f4f20
ebaae4a6-4500-4ddc-b454-5263f261f9fe	2025	57	adc23180-9487-47ad-9e3d-62eade83623a	1f5e5c39-7fd2-4fb1-8697-d5e0e9a4022b	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-04-09 22:00:00+00	2025-04-30 21:00:00+00	\N	AUTOMATICO	\N	\N	2025-06-14 21:00:00+00	2026-01-17 21:31:15.419+00	2026-01-17 21:31:15.419+00	t	\N	COMERCIAL	30	dae8fea3-9440-4fd0-8212-7c8d9c5f4f20
25b9b21f-09c5-4718-ba3f-331e95f8aa76	2025	87	f0cfd06a-b006-4dc5-ada1-3a7e9ba760ad	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-05-22 05:10:00+00	2025-06-21 07:50:00+00	\N	AUTOMATICO	\N	\N	2025-08-05 07:50:00+00	2026-01-17 21:31:15.441+00	2026-01-17 21:31:15.441+00	t	\N	COMERCIAL	60	ba8ec778-639d-4dcd-9db2-d7100c84e8f5
5498f43f-ffb6-4450-9601-bde3b96de204	2025	86	43ed857e-e69f-467e-a977-3590327e0708	57d68d17-afe4-47b5-baf5-4e4791069319	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-05-22 11:32:00+00	2025-06-05 08:10:00+00	\N	AUTOMATICO	\N	\N	2025-07-20 08:10:00+00	2026-01-17 21:31:15.447+00	2026-01-17 21:31:15.447+00	t	\N	COMERCIAL	40	f60ed9ea-004f-41a9-9d6a-4f34923b1728
7b044b8b-18b1-49a3-a4d7-22c5813826f2	2025	76	4a837a56-b513-4568-b2d7-61bc1d66d22b	fedc5975-2697-4b57-b26d-492a64ef6cc8	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-05-07 17:05:00+00	2025-06-10 17:15:00+00	\N	AUTOMATICO	\N	\N	2025-07-25 17:15:00+00	2026-01-17 21:31:15.313+00	2026-01-18 16:12:13.686+00	t	\N	COMERCIAL	30	b500d7bc-3760-4c88-9a21-4294b2395c71
ff020898-60fd-40ba-af9f-a7affe0156a7	2025	73	1f6cbb5f-d134-4ee3-9315-bf24ae2a7946	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-04-30 11:25:00+00	2025-05-29 01:42:00+00	\N	AUTOMATICO	\N	\N	2025-07-13 01:42:00+00	2026-01-17 21:31:15.273+00	2026-01-18 16:12:32.171+00	t	\N	COMERCIAL	30	c8fdee90-2d16-4800-8a4d-e6b470cf152d
d874ece1-ce8c-4624-a07e-59eb94fc594a	2025	64	c6c6fcdc-e445-4e60-8a3f-a70b8e33aab7	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-04-27 07:55:00+00	2025-05-31 08:19:00+00	\N	AUTOMATICO	\N	\N	2025-07-15 08:19:00+00	2026-01-17 21:31:15.253+00	2026-01-18 16:13:02.482+00	t	\N	COMERCIAL	60	372bbb60-ca31-49ff-9ef9-fd5d49beb720
764b2c49-7743-475a-82b3-2742d44f1511	2025	60	a16cce31-d12d-458a-b212-6846185933bf	1f5e5c39-7fd2-4fb1-8697-d5e0e9a4022b	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-04-12 11:10:00+00	2025-05-12 21:00:00+00	\N	AUTOMATICO	\N	\N	2025-06-26 21:00:00+00	2026-01-17 21:31:15.425+00	2026-01-18 16:13:17.39+00	t	\N	COMERCIAL	30	8ced3542-9444-4153-b141-27ed65a5995b
bb642f3e-1917-4044-86ff-f1dcbc9084e9	2025	56	69ff7a7d-9417-4f5c-9693-8e2835fef39b	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-04-09 00:00:00+00	2025-05-20 00:00:00+00	\N	AUTOMATICO	\N	\N	2025-07-04 00:00:00+00	2026-01-17 21:31:15.197+00	2026-01-18 16:13:36.109+00	t	\N	COMERCIAL	60	b6f9e1cc-7022-4f80-8f1d-a8392c9193df
50b60f7e-00d1-4145-9fdc-64c07172ee12	2025	54	5fa98bd7-f095-4d3e-8e98-7761568ec108	fedc5975-2697-4b57-b26d-492a64ef6cc8	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-04-08 00:00:00+00	2025-05-17 00:00:00+00	\N	AUTOMATICO	\N	\N	2025-07-01 00:00:00+00	2026-01-17 21:31:15.183+00	2026-01-18 16:13:58.718+00	t	\N	COMERCIAL	45	9ca0a15b-a857-4fab-9747-b620717776dd
405d0b35-56d8-422f-b91d-8c045bb687ca	2025	51	4a837a56-b513-4568-b2d7-61bc1d66d22b	fedc5975-2697-4b57-b26d-492a64ef6cc8	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-03-28 00:00:00+00	2025-04-30 00:00:00+00	\N	AUTOMATICO	\N	\N	2025-06-14 00:00:00+00	2026-01-17 21:31:15.22+00	2026-01-18 16:14:18.071+00	t	\N	COMERCIAL	30	d1d949b7-00fd-4756-8021-bc80d98ecf71
a8ad916d-6023-4251-8f93-85dacb93b4a8	2025	84	854c142e-a45b-4022-9411-52c786baa572	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-05-22 15:40:00+00	2025-06-17 07:33:00+00	\N	AUTOMATICO	\N	\N	2025-08-01 07:33:00+00	2026-01-17 21:31:15.454+00	2026-01-17 21:31:15.454+00	t	\N	COMERCIAL	30	8644b80c-97af-46cf-9f4d-711749582de1
e5ad3f4d-53e3-4908-806a-a276d6a30231	2025	82	69ff7a7d-9417-4f5c-9693-8e2835fef39b	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-05-22 19:05:00+00	2025-07-10 14:40:00+00	\N	AUTOMATICO	\N	\N	2025-08-24 14:40:00+00	2026-01-17 21:31:15.46+00	2026-01-17 21:31:15.46+00	t	\N	COMERCIAL	60	66d4eb59-5d54-446b-9ee0-88fa9c133899
807cc3de-3f61-4a67-827d-ef08f116871a	2025	62	21c0f3cb-e6e8-43bc-929b-99c24f15bf83	57d68d17-afe4-47b5-baf5-4e4791069319	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-04-16 00:30:00+00	2025-05-27 08:09:00+00	\N	AUTOMATICO	\N	\N	2025-07-11 08:09:00+00	2026-01-17 21:31:15.468+00	2026-01-17 21:31:15.468+00	t	\N	COMERCIAL	40	d7785cda-1f2e-4d29-a52d-335b2096bde6
7c781ec3-673c-40aa-adf2-d61ca9fb92d7	2025	69	e7ed7f8b-9e82-48db-94f1-c9c63d3391eb	57d68d17-afe4-47b5-baf5-4e4791069319	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-04-26 13:42:00+00	2025-05-28 14:11:00+00	\N	AUTOMATICO	\N	\N	2025-07-12 14:11:00+00	2026-01-17 21:31:15.475+00	2026-01-17 21:31:15.475+00	t	\N	COMERCIAL	40	06979c36-da6e-4fb0-840e-07533a1d41c7
8b8bdb40-0d08-458c-bb0f-645104fbf0ca	2025	88	5fa98bd7-f095-4d3e-8e98-7761568ec108	fedc5975-2697-4b57-b26d-492a64ef6cc8	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-05-28 11:51:00+00	2025-07-12 12:17:00+00	\N	AUTOMATICO	\N	\N	2025-08-26 12:17:00+00	2026-01-17 21:31:15.482+00	2026-01-17 21:31:15.482+00	t	\N	COMERCIAL	45	9a9b3bcd-4b8f-4aba-8ea5-3ec890e23fee
52f9cd5e-ed40-455e-916b-595a04235bd9	2025	91	e7ed7f8b-9e82-48db-94f1-c9c63d3391eb	57d68d17-afe4-47b5-baf5-4e4791069319	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-05-31 12:41:00+00	2025-06-07 00:00:00+00	\N	AUTOMATICO	\N	\N	2025-07-22 00:00:00+00	2026-01-17 21:31:15.489+00	2026-01-17 21:31:15.489+00	t	\N	COMERCIAL	40	3aab4c36-1982-4957-8f29-192aba668488
46d84b6c-c194-454b-af6c-bab2d401622b	2025	48	196d90c9-4a16-4fac-98ca-948f955d17d2	1f5e5c39-7fd2-4fb1-8697-d5e0e9a4022b	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-03-13 14:45:00+00	2025-04-28 16:05:00+00	\N	AUTOMATICO	\N	\N	2025-06-12 16:05:00+00	2026-01-17 21:31:15.502+00	2026-01-17 21:31:15.502+00	t	\N	COMERCIAL	30	7210834c-47be-440a-81d2-a5fc53a8934b
64abcf64-5b1d-457d-a044-87a592c4323d	2025	99	1f6cbb5f-d134-4ee3-9315-bf24ae2a7946	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-06-10 18:15:00+00	2025-07-16 11:05:00+00	\N	AUTOMATICO	\N	\N	2025-08-30 11:05:00+00	2026-01-17 21:31:15.518+00	2026-01-17 21:31:15.518+00	t	\N	COMERCIAL	30	20b0118b-9612-4fa8-b90c-5e11e27b07e3
930ca829-af44-4e25-93e3-2858fcf9e61e	2025	63	c1fb290e-10a9-4cef-9075-929f585122f3	fedc5975-2697-4b57-b26d-492a64ef6cc8	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-04-12 17:09:00+00	2025-05-10 00:00:00+00	\N	AUTOMATICO	\N	\N	2025-06-24 00:00:00+00	2026-01-17 21:31:15.527+00	2026-01-17 21:31:15.527+00	t	\N	COMERCIAL	30	cd4b5edd-c793-4367-869f-a955a17d8a11
11d7815a-a230-48c3-8d76-aa0dc52c6f32	2024	174	196d90c9-4a16-4fac-98ca-948f955d17d2	1f5e5c39-7fd2-4fb1-8697-d5e0e9a4022b	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-12-29 06:27:00+00	2025-03-11 12:42:00+00	\N	AUTOMATICO	\N	\N	2025-04-25 12:42:00+00	2026-01-17 21:31:15.533+00	2026-01-17 21:31:15.533+00	t	\N	COMERCIAL	30	a8bff414-46d6-4502-9537-eeda82ec5fa8
a986aa1a-1569-45e8-b1c0-4305e1dbc9b5	2025	101	d90139c7-b316-4228-8bea-b47432cf51e2	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-06-18 18:35:00+00	2025-07-09 18:00:00+00	\N	AUTOMATICO	\N	\N	2025-08-23 18:00:00+00	2026-01-17 21:31:15.541+00	2026-01-17 21:31:15.541+00	t	\N	COMERCIAL	30	02ed999f-1a0c-460a-8c38-0cc464af9b6f
1b071f3e-4ad2-438e-9b14-0a5a3f5256f9	2025	103	eebc3d53-9595-43b6-9c09-b24c1202fd35	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-06-18 22:31:00+00	2025-06-25 15:24:00+00	\N	AUTOMATICO	\N	\N	2025-08-09 15:24:00+00	2026-01-17 21:31:15.548+00	2026-01-17 21:31:15.548+00	t	\N	COMERCIAL	30	ccd3c2b4-fdfd-4d4e-b6c6-1a0dbbc02cf3
22b5f131-5ae2-424b-a904-515b396c9704	2025	106	e23b91fc-22bf-4cbc-8dcd-778a8ca8f574	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-06-19 00:04:00+00	2025-06-25 15:03:00+00	\N	AUTOMATICO	\N	\N	2025-08-09 15:03:00+00	2026-01-17 21:31:15.554+00	2026-01-17 21:31:15.554+00	t	\N	COMERCIAL	30	d7785cda-1f2e-4d29-a52d-335b2096bde6
63232f8c-edf4-4fb1-8605-185b46f08cc0	2025	98	04b53087-52e8-4656-be93-714c343c47d6	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-06-19 10:10:00+00	2025-07-02 09:55:00+00	\N	AUTOMATICO	\N	\N	2025-08-16 09:55:00+00	2026-01-17 21:31:15.561+00	2026-01-17 21:31:15.561+00	t	\N	COMERCIAL	60	06979c36-da6e-4fb0-840e-07533a1d41c7
677da877-084d-4a80-b13a-602d61e4d25b	2025	104	0e2a5c62-db26-40fc-b1b1-13f426e36388	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-06-18 19:04:00+00	2025-06-25 15:02:00+00	\N	AUTOMATICO	\N	\N	2025-08-09 15:02:00+00	2026-01-17 21:31:15.567+00	2026-01-17 21:31:15.567+00	t	\N	COMERCIAL	30	dfbdeeff-4e60-46c2-9ce0-7becb9a494a2
0d04dd05-291e-44aa-9f34-4feb5feaae26	2025	105	83fb4a61-ef1b-4b26-acf5-80204da01607	fedc5975-2697-4b57-b26d-492a64ef6cc8	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-06-18 21:10:00+00	2025-06-25 16:30:00+00	\N	AUTOMATICO	\N	\N	2025-08-09 16:30:00+00	2026-01-17 21:31:15.574+00	2026-01-17 21:31:15.574+00	t	\N	COMERCIAL	30	cd4b5edd-c793-4367-869f-a955a17d8a11
3713d350-d9be-467f-b6a1-8e6cf6030eaf	2024	106	11b8b3e8-bada-48d2-9696-ec894c5cb1ed	fedc5975-2697-4b57-b26d-492a64ef6cc8	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2024-07-04 11:58:00+00	2024-07-09 07:50:00+00	\N	AUTOMATICO	\N	\N	2024-08-23 07:50:00+00	2026-01-17 21:31:15.581+00	2026-01-17 21:31:15.581+00	t	\N	COMERCIAL	\N	d7785cda-1f2e-4d29-a52d-335b2096bde6
f764627c-e645-40d1-a54e-6f211baf4a5b	2025	111	83fb4a61-ef1b-4b26-acf5-80204da01607	fedc5975-2697-4b57-b26d-492a64ef6cc8	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-06-27 20:45:00+00	2025-07-09 23:58:00+00	\N	AUTOMATICO	\N	\N	2025-08-23 23:58:00+00	2026-01-17 21:31:15.587+00	2026-01-17 21:31:15.587+00	t	\N	COMERCIAL	30	ccd3c2b4-fdfd-4d4e-b6c6-1a0dbbc02cf3
111d7d81-fd11-4d58-b315-81a89e358f99	2025	112	b422b4ce-70c9-4b52-aa4f-15ccf351575a	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-06-27 23:17:00+00	2025-07-16 04:10:00+00	\N	AUTOMATICO	\N	\N	2025-08-30 04:10:00+00	2026-01-17 21:31:15.594+00	2026-01-17 21:31:15.594+00	t	\N	COMERCIAL	10	dae8fea3-9440-4fd0-8212-7c8d9c5f4f20
2afdcab7-0d3d-4879-966e-5e765240ba69	2025	114	2df50464-9916-4b3e-b5c3-3a645623d525	fedc5975-2697-4b57-b26d-492a64ef6cc8	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-07-10 15:05:00+00	2025-08-29 07:09:00+00	\N	AUTOMATICO	\N	\N	2025-10-13 07:09:00+00	2026-01-17 21:31:15.602+00	2026-01-17 21:31:15.602+00	t	\N	COMERCIAL	60	e82e6994-7b2a-4fd4-a699-665a2c81d083
25f87ce8-5f19-4a37-9f00-6153202f6e7b	2025	119	129a7390-74a6-453e-896e-309f65fed7c8	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-07-14 09:50:00+00	2025-08-23 10:14:00+00	\N	AUTOMATICO	\N	\N	2025-10-07 10:14:00+00	2026-01-17 21:31:15.617+00	2026-01-17 21:31:15.617+00	t	\N	COMERCIAL	60	b33fd685-31a6-4510-a970-09a2d428a1bb
ff5003de-9a66-4ea0-8724-2802c54456ed	2025	116	0ddb5663-8ab9-4ad5-ab76-fb98b2e5d15d	fedc5975-2697-4b57-b26d-492a64ef6cc8	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-07-15 22:10:00+00	2025-08-28 14:13:00+00	\N	AUTOMATICO	\N	\N	2025-10-12 14:13:00+00	2026-01-17 21:31:15.624+00	2026-01-17 21:31:15.624+00	t	\N	COMERCIAL	40	ba8ec778-639d-4dcd-9db2-d7100c84e8f5
37e9fbd6-5e73-49e7-a9da-a53416bf5885	2025	122	5fa98bd7-f095-4d3e-8e98-7761568ec108	fedc5975-2697-4b57-b26d-492a64ef6cc8	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-07-17 16:00:00+00	2025-09-04 08:40:00+00	\N	AUTOMATICO	\N	\N	2025-10-19 08:40:00+00	2026-01-17 21:31:15.631+00	2026-01-17 21:31:15.631+00	t	\N	COMERCIAL	45	9a9b3bcd-4b8f-4aba-8ea5-3ec890e23fee
d096a5e6-f44f-4da9-90b2-b42a19f7b4b2	2025	121	73c502e2-397a-499f-b4f7-cb8dce8260b7	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-07-18 17:28:00+00	2025-08-17 08:08:00+00	\N	AUTOMATICO	\N	\N	2025-10-01 08:08:00+00	2026-01-17 21:31:15.638+00	2026-01-17 21:31:15.638+00	t	\N	COMERCIAL	30	f0a415e0-9538-4336-b681-9d23e0753e26
85424ebb-d0d6-4927-b41e-3c5705f00d46	2025	128	71ac58df-bb35-4d50-902c-4b8805d03488	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-07-19 10:10:00+00	2025-08-23 08:15:00+00	\N	AUTOMATICO	\N	\N	2025-10-07 08:15:00+00	2026-01-17 21:31:15.645+00	2026-01-17 21:31:15.645+00	t	\N	COMERCIAL	60	fb61c911-79f8-45ed-8e0e-23bfa3a9ad2b
ad935f05-8e3f-4cd4-951c-6cb36058c10e	2025	124	face2a5f-184c-41f8-b3a8-9beebc3635ee	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-07-19 17:00:00+00	2025-08-19 14:02:00+00	\N	AUTOMATICO	\N	\N	2025-10-03 14:02:00+00	2026-01-17 21:31:15.653+00	2026-01-17 21:31:15.653+00	t	\N	COMERCIAL	60	cded2d3e-5f9e-4de6-9269-a1da3eeeff0a
6726eb24-f7e9-40f0-bee8-57e2d5011db6	2025	110	eebc3d53-9595-43b6-9c09-b24c1202fd35	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-06-27 22:43:00+00	2025-07-20 12:40:00+00	\N	AUTOMATICO	\N	\N	2025-09-03 12:40:00+00	2026-01-17 21:31:15.66+00	2026-01-17 21:31:15.66+00	t	\N	COMERCIAL	30	dfbdeeff-4e60-46c2-9ce0-7becb9a494a2
a5ee89fd-138a-41bf-b094-dfbae4da6651	2025	171	0ddb5663-8ab9-4ad5-ab76-fb98b2e5d15d	fedc5975-2697-4b57-b26d-492a64ef6cc8	45672467-a4db-462d-8228-2a21ce82cc37	\N	2025-10-30 21:10:00+00	2025-12-11 03:00:00+00	\N	AUTOMATICO	\N	\N	2026-01-25 03:00:00+00	2026-01-17 21:31:16.079+00	2026-01-17 22:29:50.71+00	t	\N	COMERCIAL	40	9ca0a15b-a857-4fab-9747-b620717776dd
bb93f6d5-50a1-44e9-a1b1-ced70f7b44ae	2025	186	0ddb5663-8ab9-4ad5-ab76-fb98b2e5d15d	fedc5975-2697-4b57-b26d-492a64ef6cc8	97219917-fdf2-4aca-b415-96de17cc505e	\N	2025-12-16 07:30:00+00	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-17 21:31:16.225+00	2026-01-17 21:31:16.225+00	t	\N	COMERCIAL	40	9ca0a15b-a857-4fab-9747-b620717776dd
9d83d69c-6865-482b-91ea-d9a138e1282b	2025	117	c1fb290e-10a9-4cef-9075-929f585122f3	fedc5975-2697-4b57-b26d-492a64ef6cc8	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-07-11 18:30:00+00	2025-08-20 16:20:00+00	\N	AUTOMATICO	\N	\N	2025-10-04 16:20:00+00	2026-01-17 21:31:15.61+00	2026-01-18 16:10:41.994+00	t	\N	COMERCIAL	30	8ced3542-9444-4153-b141-27ed65a5995b
3fc93ae9-f30a-40a4-810c-d5810780eb84	2025	96	c6c6fcdc-e445-4e60-8a3f-a70b8e33aab7	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-06-05 18:42:00+00	2025-07-06 09:14:00+00	\N	AUTOMATICO	\N	\N	2025-08-20 09:14:00+00	2026-01-17 21:31:15.51+00	2026-01-18 16:11:19.398+00	t	\N	COMERCIAL	60	372bbb60-ca31-49ff-9ef9-fd5d49beb720
c4e63591-e94a-4843-873a-bac0dfc487df	2025	94	28951b47-241f-46bb-9aa3-97f42bd51686	acea052d-e5d1-4ced-b98c-2d01eb79122a	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-06-13 17:00:00+00	2025-07-25 15:09:00+00	\N	AUTOMATICO	\N	\N	2025-09-08 15:09:00+00	2026-01-17 21:31:15.669+00	2026-01-18 16:11:34.684+00	t	\N	COMERCIAL	30	c8fdee90-2d16-4800-8a4d-e6b470cf152d
482edf1c-cf2d-48ed-9e89-a268b9f9829c	2025	89	0ddb5663-8ab9-4ad5-ab76-fb98b2e5d15d	fedc5975-2697-4b57-b26d-492a64ef6cc8	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	2025-05-31 20:30:00+00	2025-07-11 07:00:00+00	\N	AUTOMATICO	\N	\N	2025-08-25 07:00:00+00	2026-01-17 21:31:15.495+00	2026-01-18 16:11:52.123+00	t	\N	COMERCIAL	40	d1d949b7-00fd-4756-8021-bc80d98ecf71
80926a39-5773-4465-b5b8-73d7e78dbae5	2025	97	887ff179-0c25-4956-9165-09125f9152f0	acea052d-e5d1-4ced-b98c-2d01eb79122a	2ea71871-f6e2-480b-bb64-6d2f436ffa6f	2025-06-17 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-18 23:06:51.998+00	2026-01-18 23:16:21.536+00	t	\N	COMERCIAL	30	d7785cda-1f2e-4d29-a52d-335b2096bde6
\.


--
-- Data for Name: mareas_archivos; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.mareas_archivos (id, id_marea, id_movimiento_origen, tipo_archivo, formato, version, ruta_archivo, fecha_subida, id_usuario_subio, descripcion) FROM stdin;
\.


--
-- Data for Name: mareas_etapas; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.mareas_etapas (id, id_marea, nro_etapa, id_pesqueria, id_puerto_zarpada, id_puerto_arribo, fecha_zarpada, fecha_arribo, tipo_etapa, observaciones) FROM stdin;
c2b10052-8f91-4191-a114-36a1183e4f17	a5ee89fd-138a-41bf-b094-dfbae4da6651	1	6af901f6-bd7d-4bc7-8c9d-f441e526e65c	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-10-30 21:10:00+00	2025-12-04 20:10:00+00	COMERCIAL	
773fbb0e-a04a-4d3c-9788-80a94aedac9c	a5ee89fd-138a-41bf-b094-dfbae4da6651	2	6af901f6-bd7d-4bc7-8c9d-f441e526e65c	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-12-04 20:10:00+00	2025-12-11 03:00:00+00	COMERCIAL	
4f0fe646-8ed7-4f2c-bec2-91b185d7d965	fbc6fdad-c8c7-4ae1-bfef-855b2db3105b	2	4167beb8-ce39-4fd3-8314-8b3487879d92	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-08-08 11:28:00+00	2025-08-12 05:02:00+00	PESCA	\N
55a055e2-7605-4798-aaf2-9f291ef3ff7a	e6f73891-571b-4a76-b66b-55c6cbaa4faf	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2024-09-06 18:10:00+00	2024-09-13 17:00:00+00	PESCA	\N
304caa96-a0bf-4b55-9c4d-b606fbd341ed	42a6786f-0b3f-4d79-9380-fd02f165c498	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2024-12-03 16:49:00+00	2024-12-11 08:35:00+00	PESCA	\N
a996a07a-476c-4a89-a0c1-24b09c20db78	2850ea5b-01df-461e-a24c-3f9415b724aa	1	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2024-02-06 22:12:00+00	2024-02-23 08:25:00+00	PESCA	\N
3a686538-0f8f-4643-835c-0138e6bf4dd3	a1fdd29f-6f3f-417c-a379-f6ff11cc3bc7	1	92d9acc2-3590-474f-a773-73e8af728e83	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2024-04-10 19:30:00+00	2024-04-13 20:34:00+00	PESCA	\N
7090cefe-4bf1-4ce2-8e0e-722f00cd5ae9	39a26a14-74b7-48cc-a407-2d89a65f22f5	1	4167beb8-ce39-4fd3-8314-8b3487879d92	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2024-06-26 12:00:00+00	2024-07-12 23:00:00+00	PESCA	\N
795d0310-71a8-42e9-bf64-b91e43b955fc	fbc6fdad-c8c7-4ae1-bfef-855b2db3105b	3	4167beb8-ce39-4fd3-8314-8b3487879d92	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-08-12 16:40:00+00	2025-08-15 03:25:00+00	PESCA	\N
0a7d0aba-2f41-48eb-a335-091e8e3cb408	fbc6fdad-c8c7-4ae1-bfef-855b2db3105b	4	4167beb8-ce39-4fd3-8314-8b3487879d92	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-08-15 14:52:00+00	2025-08-18 02:05:00+00	PESCA	\N
01f65b0d-1937-458e-8877-27834f4ebe35	1ee93311-5973-4e68-b987-e387fbd314f2	1	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2024-01-06 13:00:00+00	2024-01-31 23:50:00+00	PESCA	\N
5c180873-0a2f-4bae-aa84-850c36391c44	15a5f229-bb4a-4cc5-a643-c7dc9114ae7a	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2024-07-28 17:59:00+00	2024-08-04 08:40:00+00	PESCA	\N
f68d36b7-8e9c-4429-ac13-73e1f9111704	6bfb5856-619a-4c4c-9c53-f39abd0d8fbe	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2024-09-06 10:57:00+00	2024-09-13 07:08:00+00	PESCA	\N
98a25697-4ebe-4177-af74-20d15f20a7aa	a4008fa3-866a-48fa-9473-44f51d28e824	1	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2023-12-30 20:00:00+00	2024-01-30 20:00:00+00	PESCA	\N
bde299aa-4b0b-4915-a9cd-2b3a6c3cfada	fbc6fdad-c8c7-4ae1-bfef-855b2db3105b	5	4167beb8-ce39-4fd3-8314-8b3487879d92	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-08-18 14:44:00+00	2025-08-22 10:25:00+00	PESCA	\N
e7b943b0-805a-45a5-86f9-9054f1e15d43	1b98b893-fa13-4f68-a34e-6c747a6640e1	1	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2024-02-26 23:10:00+00	2024-03-12 20:30:00+00	PESCA	\N
6a01767b-5cef-4e89-a2c2-2ba4001d3d43	aaaef184-4e9c-438e-a5fd-d6147a99b797	1	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2024-04-25 18:11:00+00	2024-05-24 10:52:00+00	PESCA	\N
e4d75a1e-179e-49c2-aa8a-1ae521da23e0	ba85e27b-d69f-4b27-8d1e-44ef3497ecc5	1	6af901f6-bd7d-4bc7-8c9d-f441e526e65c	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2024-08-24 13:21:00+00	2024-09-27 08:17:00+00	PESCA	\N
a51d5eaa-f0fd-45ab-b562-d8205068f7c2	1c6328f4-771e-4088-975f-27f450b625ef	1	6af901f6-bd7d-4bc7-8c9d-f441e526e65c	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2024-11-15 16:53:00+00	2024-12-16 16:46:00+00	PESCA	\N
67ca9bc5-cd5d-4f2b-bd61-f25e579cb79b	bd6816fc-6cc4-40da-a94d-bf18acf313ad	1	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2024-01-06 08:40:00+00	2024-01-11 08:40:00+00	PESCA	\N
0807a61e-5e20-451c-bcb9-2944bcd47161	e3f52376-56bd-4f89-a093-107b5a1c1e61	1	6af901f6-bd7d-4bc7-8c9d-f441e526e65c	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2024-05-15 15:17:00+00	2024-06-23 11:40:00+00	PESCA	\N
b73a3953-edc2-4765-8cfa-1044da13bb83	a14da35d-822e-4f88-a2c8-d2784ba2db91	1	92d9acc2-3590-474f-a773-73e8af728e83	b8a55941-9f65-4e90-bea1-3683753d42b5	b8a55941-9f65-4e90-bea1-3683753d42b5	2024-12-06 23:45:00+00	2025-02-04 04:35:00+00	PESCA	\N
d7a72c55-cf90-4464-99c5-afe1845f36e6	fa20f9ac-79a3-483c-8e3b-1d7c664244b9	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2024-01-13 13:30:00+00	2024-02-25 08:04:00+00	PESCA	\N
e8be4f59-d353-4331-83ee-f28e631478ff	96d5f474-06d9-4fcc-9112-d0002553408a	1	92d9acc2-3590-474f-a773-73e8af728e83	b8a55941-9f65-4e90-bea1-3683753d42b5	\N	2026-01-15 03:00:00+00	\N	COMERCIAL	
2fa8ba13-7c20-4aeb-aef0-b2c871b9b36e	99035dd7-310e-4a9f-9344-cf001f1a5bfb	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-08-30 10:49:00+00	2025-08-30 16:01:00+00	PESCA	\N
63c53e13-0e3d-4caa-b8b9-5dd85ced77f2	f713edcb-c2f9-40c5-8fc6-dcf9f69c15e4	1	4167beb8-ce39-4fd3-8314-8b3487879d92	105b0349-a9ed-49bf-9336-aad8d3867f0b	105b0349-a9ed-49bf-9336-aad8d3867f0b	2024-03-27 05:50:00+00	2024-04-13 17:30:00+00	PESCA	\N
258b3bb4-9c44-448a-92f7-af265ae76cfa	3fe38b1e-d987-4002-9581-00f2b1691c5a	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-08-30 17:07:00+00	2025-10-06 19:53:00+00	PESCA	\N
6109e4bb-c119-45d3-9e0f-d0852e2a276e	87cf10f1-16ae-4092-8aaa-b3f16c5166d3	1	4167beb8-ce39-4fd3-8314-8b3487879d92	\N	\N	2025-09-01 20:30:00+00	2025-09-12 14:10:00+00	PESCA	\N
c993ce3e-b50d-4f4d-90f7-51e6ceb09c3d	87cf10f1-16ae-4092-8aaa-b3f16c5166d3	2	4167beb8-ce39-4fd3-8314-8b3487879d92	\N	\N	2025-09-13 20:25:00+00	2025-09-25 16:00:00+00	PESCA	\N
038decba-d0ae-4db7-b79c-d26801129f1f	87cf10f1-16ae-4092-8aaa-b3f16c5166d3	3	4167beb8-ce39-4fd3-8314-8b3487879d92	\N	\N	2025-09-26 17:15:00+00	2025-10-08 08:15:00+00	PESCA	\N
2d54ab38-0e78-4a43-82b3-8a24fc3f0fd2	eb1adbfe-ece8-4b96-95eb-0fad3f4a452d	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2024-05-11 12:08:00+00	2024-05-22 12:06:00+00	PESCA	\N
1f3df273-7d9a-45dc-a865-195f55b134f7	cc243c97-15d3-4c18-ab36-56cc60ed2c2c	1	4167beb8-ce39-4fd3-8314-8b3487879d92	\N	\N	2025-08-08 15:34:00+00	2025-08-19 16:01:00+00	PESCA	\N
291e2e50-329b-41a1-ba25-3d73110d74af	cc243c97-15d3-4c18-ab36-56cc60ed2c2c	2	4167beb8-ce39-4fd3-8314-8b3487879d92	\N	\N	2025-09-03 09:50:00+00	2025-09-22 12:15:00+00	PESCA	\N
52719a1c-5f91-4ab8-b07c-ae9fc2d80cab	cc243c97-15d3-4c18-ab36-56cc60ed2c2c	3	4167beb8-ce39-4fd3-8314-8b3487879d92	\N	\N	2025-08-20 17:20:00+00	2025-09-01 12:18:00+00	PESCA	\N
065e00d1-8a93-4c72-9915-3e5a7d50c424	072ce4c8-1350-4690-b850-d9174e1a5d0b	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-08-07 12:50:00+00	2025-08-14 05:38:00+00	PESCA	\N
ffc2d71f-2228-4ba4-8e40-d0a7acca9d72	072ce4c8-1350-4690-b850-d9174e1a5d0b	2	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-08-20 15:26:00+00	2025-08-27 09:00:00+00	PESCA	\N
cf129718-6f9b-4119-959e-50d40f4d955e	7ea24710-2630-4e67-96a7-ed638722270d	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2024-08-15 15:21:00+00	2024-09-14 09:30:00+00	PESCA	\N
25e03777-a972-4e49-a30b-d5ea5c175751	072ce4c8-1350-4690-b850-d9174e1a5d0b	3	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-08-29 11:36:00+00	2025-09-05 13:36:00+00	PESCA	\N
1c74136f-fb9b-4747-8d66-06ca0dcf50d0	072ce4c8-1350-4690-b850-d9174e1a5d0b	4	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-09-08 17:45:00+00	2025-09-16 09:29:00+00	PESCA	\N
91def48b-7e06-48c6-a984-ec1d4b52807c	8fbdd4e5-081b-49bb-8233-4d2e7d91e0fe	1	92d9acc2-3590-474f-a773-73e8af728e83	b8a55941-9f65-4e90-bea1-3683753d42b5	b8a55941-9f65-4e90-bea1-3683753d42b5	2024-02-09 18:23:00+00	2024-03-18 02:20:00+00	PESCA	\N
35f32f3a-77b4-45f2-a104-71ae6868e71f	6acfcdc1-ba2b-4b99-baab-146eb9ef1efd	1	4167beb8-ce39-4fd3-8314-8b3487879d92	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2024-03-27 03:45:00+00	2024-04-27 18:56:00+00	PESCA	\N
d461c937-142f-4ef9-9bb3-dbc07417a611	c33db762-16e5-4002-8eb4-2827a953ecff	1	4167beb8-ce39-4fd3-8314-8b3487879d92	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2024-05-24 22:30:00+00	2024-05-29 09:40:00+00	PESCA	\N
85b24f04-56e0-4bf3-aa46-764a7cf520ed	dad3d9ba-17f7-4b65-b695-a44e93d758d3	1	4167beb8-ce39-4fd3-8314-8b3487879d92	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2024-06-11 21:15:00+00	2024-06-21 15:10:00+00	PESCA	\N
d79f20e9-d15e-44de-b24e-e29d344e2ab0	0de14eab-0bc3-4f45-9c9f-7821dee3921f	1	4167beb8-ce39-4fd3-8314-8b3487879d92	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2024-07-16 00:00:00+00	2024-07-28 00:00:00+00	PESCA	\N
1c97ef78-b8d4-4abb-a1bf-b80b03577a1c	ad90e5dc-8fb9-4672-9683-984e7a21797c	1	4167beb8-ce39-4fd3-8314-8b3487879d92	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2024-01-22 13:55:00+00	2024-02-03 00:04:00+00	PESCA	\N
fe6cbe54-7b27-411a-a09b-b2ac1bae618b	23f7081f-2528-4c34-b9fe-059c0ee8bc3c	1	4167beb8-ce39-4fd3-8314-8b3487879d92	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2024-03-28 18:23:00+00	2024-04-09 18:00:00+00	PESCA	\N
e3272b23-d087-4167-bc13-22de1b8a7d32	a666d894-1b48-4554-836c-61926f218458	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2024-05-18 11:00:00+00	2024-05-22 18:07:00+00	PESCA	\N
5f1c76db-0fea-49c5-aadf-089fdc04814e	e79de911-d64b-4455-971e-0b8ff6aac36e	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2024-06-20 06:55:00+00	2024-06-24 14:00:00+00	PESCA	\N
fdbbf0fe-7ffe-48a4-87b8-125be1f25d74	3ccfda38-a32f-4e0a-9bf8-8931e56f971d	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2024-08-20 19:05:00+00	2024-08-28 08:29:00+00	PESCA	\N
84a66f3e-885c-48df-9948-160b68d605da	3b74f5a0-c9b3-4595-8652-c4b4f488d16b	1	4167beb8-ce39-4fd3-8314-8b3487879d92	f41ff939-bc00-4bbd-8ce8-c451922ba284	f41ff939-bc00-4bbd-8ce8-c451922ba284	2025-09-06 08:00:00+00	2025-09-15 07:00:00+00	PESCA	\N
3c06e78f-1d57-4a1f-81c1-6494c8b2d686	da30d478-7db0-4a1e-8e52-4a2e469a1190	1	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2024-01-19 20:37:00+00	2024-02-14 08:23:00+00	PESCA	\N
2e0d71b2-26a8-42c6-b710-ced5ca18316e	100fc1c4-e838-431f-b7d8-4941a97e5c34	1	4167beb8-ce39-4fd3-8314-8b3487879d92	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-08-08 13:53:00+00	2025-08-20 07:22:00+00	PESCA	\N
b5e7a7a7-36a7-4e11-b142-80516aff5d7f	100fc1c4-e838-431f-b7d8-4941a97e5c34	2	4167beb8-ce39-4fd3-8314-8b3487879d92	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-08-21 18:05:00+00	2025-09-03 05:30:00+00	PESCA	\N
859ee0a4-fa5f-46d3-9738-1b1ea6f8c00f	f682980b-267e-49ee-9788-17095d2bbc23	1	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2024-03-02 20:35:00+00	2024-04-04 07:00:00+00	PESCA	\N
f3da3031-8cec-4502-bf95-6180e678a89f	5e6b131a-0482-4575-83cd-5cd930d2c314	1	4167beb8-ce39-4fd3-8314-8b3487879d92	f41ff939-bc00-4bbd-8ce8-c451922ba284	f41ff939-bc00-4bbd-8ce8-c451922ba284	2024-04-29 18:20:00+00	2024-05-20 08:40:00+00	PESCA	\N
6d066022-585d-4f4b-b6cb-d9a2ef1d305d	e39be39d-6966-49ae-bda4-bf9854457ea2	1	4167beb8-ce39-4fd3-8314-8b3487879d92	f41ff939-bc00-4bbd-8ce8-c451922ba284	f41ff939-bc00-4bbd-8ce8-c451922ba284	2024-05-23 19:35:00+00	2024-06-09 11:55:00+00	PESCA	\N
2f09bd91-7f2d-43f2-8aa8-709989e0fee1	94ac3cd9-8841-4408-957c-ef20afb4c8a2	1	4167beb8-ce39-4fd3-8314-8b3487879d92	f41ff939-bc00-4bbd-8ce8-c451922ba284	f41ff939-bc00-4bbd-8ce8-c451922ba284	2024-07-21 13:05:00+00	2024-07-27 16:40:00+00	PESCA	\N
07c31cd8-c112-4be8-aad8-25da76439d86	4788e4e0-fab8-4291-8f68-72aba2235e0b	1	92d9acc2-3590-474f-a773-73e8af728e83	f41ff939-bc00-4bbd-8ce8-c451922ba284	f41ff939-bc00-4bbd-8ce8-c451922ba284	2024-01-05 20:05:00+00	2024-01-25 20:15:00+00	PESCA	\N
620a46c9-fa88-44b9-9d0c-b98ec712d270	9c1c0779-c291-45d4-af85-342437c32f8d	1	92d9acc2-3590-474f-a773-73e8af728e83	f41ff939-bc00-4bbd-8ce8-c451922ba284	f41ff939-bc00-4bbd-8ce8-c451922ba284	2024-01-27 20:00:00+00	2024-02-24 17:45:00+00	PESCA	\N
5b914444-96f9-49a0-a3e4-f3ada0707969	fbb6e4bf-2de7-4267-864a-f65cf15f4816	1	92d9acc2-3590-474f-a773-73e8af728e83	f41ff939-bc00-4bbd-8ce8-c451922ba284	f41ff939-bc00-4bbd-8ce8-c451922ba284	2024-02-27 18:45:00+00	2024-03-23 23:00:00+00	PESCA	\N
46f2ea54-8581-498f-9ed3-e9362ba9ff9f	cc7efcb3-225d-4e87-8c53-b011b88c3218	1	92d9acc2-3590-474f-a773-73e8af728e83	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2024-05-06 17:20:00+00	2024-06-26 04:30:00+00	PESCA	\N
b3542a37-b2e8-42cb-814d-3386bcd8f1fb	5dc80ed4-86df-46fa-893a-9710b6e78ce7	1	4167beb8-ce39-4fd3-8314-8b3487879d92	\N	\N	2025-07-24 13:40:00+00	2025-08-09 23:30:00+00	PESCA	\N
c8f7e3fb-a04b-4468-80c5-c378e1a1c62c	6957ee46-f622-4dc6-8ba8-3f1c21eac19e	1	92d9acc2-3590-474f-a773-73e8af728e83	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2024-07-04 02:35:00+00	2024-09-05 10:25:00+00	PESCA	\N
f6bfec2d-29fd-42cf-b201-b94d86a6fd75	dce343dd-5ad0-4c8b-b9d7-4842818340e0	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2024-04-04 15:15:00+00	2024-05-15 10:05:00+00	PESCA	\N
35b33d02-9587-430f-bde6-511c3b2d468c	9d8e8990-3a41-45a4-b3ab-2770607e2797	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	105b0349-a9ed-49bf-9336-aad8d3867f0b	105b0349-a9ed-49bf-9336-aad8d3867f0b	2024-06-06 20:00:00+00	2024-07-05 20:50:00+00	PESCA	\N
17a11882-7a79-47f6-a159-ed719e0d9ffc	b6107140-d329-434f-a111-3a70cd72dc7b	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2024-08-16 09:34:00+00	2024-10-05 12:23:00+00	PESCA	\N
76218d67-d90d-4081-b473-f8fac3995f98	9dfefc30-ee66-4ba6-9dcd-e957301b6c64	1	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	105b0349-a9ed-49bf-9336-aad8d3867f0b	105b0349-a9ed-49bf-9336-aad8d3867f0b	2023-12-31 08:50:00+00	2024-01-23 05:55:00+00	PESCA	\N
2e2e7ce6-bef5-4b1d-95c6-effb94b9e60e	fd68f884-463e-4f67-b928-9232ec37a082	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2024-03-06 10:00:00+00	2024-03-13 13:33:00+00	PESCA	\N
3008118d-2674-4227-979d-bee2015610dd	23299e73-66ef-44b6-9158-07778facae32	1	6af901f6-bd7d-4bc7-8c9d-f441e526e65c	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2024-06-07 18:08:00+00	2024-07-21 16:45:00+00	PESCA	\N
daf17bec-d17d-4449-9382-7cbe79afd5d9	33883a42-4791-4ec5-861f-a21774e74223	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2024-09-05 08:50:00+00	2024-10-15 17:15:00+00	PESCA	\N
36e39ae2-9f39-4f18-a970-ffbbbbae90e4	f169a737-fd78-40da-8345-5f087071eeea	1	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	105b0349-a9ed-49bf-9336-aad8d3867f0b	105b0349-a9ed-49bf-9336-aad8d3867f0b	2024-01-24 23:00:00+00	2024-02-12 10:25:00+00	PESCA	\N
fd6da6f5-70f3-48d1-b6cc-67b1749ac9cb	c335e9f7-fc2d-48a3-a946-e808d9e5e30f	1	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	105b0349-a9ed-49bf-9336-aad8d3867f0b	105b0349-a9ed-49bf-9336-aad8d3867f0b	2024-02-13 19:36:00+00	2024-03-03 13:48:00+00	PESCA	\N
311a7cf7-7ce9-4255-830f-e7ec3149e748	a9f46833-a6ba-4e06-947e-bbbe4aa9b0a7	1	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	105b0349-a9ed-49bf-9336-aad8d3867f0b	105b0349-a9ed-49bf-9336-aad8d3867f0b	2024-03-05 18:35:00+00	2024-04-03 20:35:00+00	PESCA	\N
e6f5e571-8f41-49a8-8814-02a68abe8c77	641baec2-6bb5-4759-8670-a8229f62de7b	1	4167beb8-ce39-4fd3-8314-8b3487879d92	\N	\N	2024-05-24 17:25:00+00	2024-06-01 08:39:00+00	PESCA	\N
fde9ab49-359a-435d-af36-41e941bd4578	758bd9c8-7b5e-4373-b807-89d9a013ac1a	1	4167beb8-ce39-4fd3-8314-8b3487879d92	f41ff939-bc00-4bbd-8ce8-c451922ba284	f41ff939-bc00-4bbd-8ce8-c451922ba284	2024-06-18 13:30:00+00	2024-06-27 07:50:00+00	PESCA	\N
b0f44db6-b4a3-47a3-9aa8-4c920dec7024	65e3a68b-7aac-4be5-b4f9-3595df9fefef	1	6af901f6-bd7d-4bc7-8c9d-f441e526e65c	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2024-01-06 18:45:00+00	2024-02-13 21:55:00+00	PESCA	\N
d5d91fcd-2377-45fb-9d6e-29697874c7d8	c8e6882f-275b-48e9-adb6-bd22dba98ae3	1	6af901f6-bd7d-4bc7-8c9d-f441e526e65c	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2023-11-24 11:35:00+00	2024-01-03 20:20:00+00	PESCA	\N
f4280ee8-9ee4-44a2-899b-efb6753f423b	3eac54fc-f538-46a1-abfc-e5e57f23d094	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2024-01-16 14:27:00+00	2024-01-27 19:06:00+00	PESCA	\N
47484709-f846-4883-a969-b7af02b64bf6	db0c7768-131c-4cd3-8591-9d93bf4759b6	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2024-03-17 10:10:00+00	2024-03-26 14:27:00+00	PESCA	\N
972b4a1a-1ffa-4f0d-8bb3-8e6f5811a0dc	8f89610d-38d0-4c42-944a-a4b3b8f5962c	1	4167beb8-ce39-4fd3-8314-8b3487879d92	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2024-05-23 18:50:00+00	2024-06-05 08:06:00+00	PESCA	\N
eef3e424-0225-41bd-89ed-43880267bc42	1b20a08a-80aa-4dc0-b0ab-5b11e65fe22e	1	4167beb8-ce39-4fd3-8314-8b3487879d92	105b0349-a9ed-49bf-9336-aad8d3867f0b	105b0349-a9ed-49bf-9336-aad8d3867f0b	2024-08-06 16:58:00+00	2024-08-20 12:45:00+00	PESCA	\N
6a6f8312-9fe2-47a6-bee5-800f93334d79	51af0c3b-d2bc-45d7-834d-44232171b6bd	1	a67a623b-9bd3-45ae-8512-9c6b22645469	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2024-10-13 10:43:00+00	2024-10-20 10:33:00+00	PESCA	\N
5fd738e6-d4e3-4d41-8924-7d426871479e	9a2a7a01-d3f3-41fd-8094-de47b9825640	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2024-11-16 12:51:00+00	2024-11-24 22:49:00+00	PESCA	\N
b959b796-fcfd-425a-a04e-a31002afb2f2	9afe4a67-600d-44be-9d16-5bb66484bfa0	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2024-03-19 19:32:00+00	2024-03-30 18:39:00+00	PESCA	\N
5b67a8d4-81ee-4a2a-89fc-3979a4ebc243	d01f9b5f-933d-4ddf-9287-225434351659	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2024-07-05 19:50:00+00	2024-07-09 11:00:00+00	PESCA	\N
c3632eea-7fdf-47da-b742-ca99a19f2cd9	3f78129e-a816-4f18-be79-9c3a00c39927	1	4167beb8-ce39-4fd3-8314-8b3487879d92	105b0349-a9ed-49bf-9336-aad8d3867f0b	105b0349-a9ed-49bf-9336-aad8d3867f0b	2024-08-06 22:10:00+00	2024-08-19 11:35:00+00	PESCA	\N
6a34fd75-e8eb-4324-acd9-9aea72d9ca95	c5461ddf-2277-442c-9790-c8c8289d8cd8	1	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2024-01-16 16:25:00+00	2024-02-02 00:00:00+00	PESCA	\N
9074f4c3-7557-4981-8704-41c0ba1294c0	7166cd74-d9ad-4c53-b39e-53a1a5894cfc	1	92d9acc2-3590-474f-a773-73e8af728e83	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2024-05-24 22:00:00+00	2024-06-09 12:30:00+00	PESCA	\N
c6499713-4474-485b-99f9-f5a111817036	5910e5b7-2db5-480e-836c-0019c41f8fbf	1	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2024-08-02 13:25:00+00	2024-09-11 10:50:00+00	PESCA	\N
9aa05c65-9050-47a6-87cc-5401ba692874	c85de383-4138-4970-8edc-067391d7912d	1	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2024-10-31 00:00:00+00	2024-11-11 14:55:00+00	PESCA	\N
f2bd22d9-446d-49eb-a7e9-52f5e7474973	9580c648-783e-472a-841c-98fd0edd43d1	1	4167beb8-ce39-4fd3-8314-8b3487879d92	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2024-03-28 18:12:00+00	2024-04-26 21:05:00+00	PESCA	\N
9aad261f-04f4-4794-b934-6b544e4c1de7	5292e83c-d5fc-4991-91ba-4b0398aab882	1	4167beb8-ce39-4fd3-8314-8b3487879d92	\N	\N	2024-04-30 14:30:00+00	2024-05-19 10:49:00+00	PESCA	\N
fc17cd3e-d5ef-46c6-875b-f8a9aa5f6897	686dc608-e3cd-47bd-9497-c0898cdde0a3	1	4167beb8-ce39-4fd3-8314-8b3487879d92	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2024-05-23 18:15:00+00	2024-06-13 14:36:00+00	PESCA	\N
b298dabe-708a-468d-a4f5-e4a4aab5a408	ed8dd927-59bb-47b8-9efb-1aaa4a1f623c	1	4167beb8-ce39-4fd3-8314-8b3487879d92	\N	\N	2024-06-19 21:40:00+00	2024-08-02 11:20:00+00	PESCA	\N
423e964e-4154-4096-ac93-17adfd921b4e	03b57cb0-979d-47bd-a034-a3b7b775ca66	1	4167beb8-ce39-4fd3-8314-8b3487879d92	\N	\N	2024-08-03 17:47:00+00	2024-08-13 13:15:00+00	PESCA	\N
9fae8e62-f827-447c-8ac9-dac9f347532e	f88eedea-aab4-4ebd-84b4-69bd28a4d44c	1	4167beb8-ce39-4fd3-8314-8b3487879d92	\N	\N	2025-08-04 21:10:00+00	2025-08-14 07:33:00+00	PESCA	\N
13a55f38-ed54-48c5-ad33-4a3579a07363	85c49d03-b74d-46d5-9d0b-f316cbd54b19	1	6af901f6-bd7d-4bc7-8c9d-f441e526e65c	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2024-10-04 17:24:00+00	2024-10-20 08:31:00+00	PESCA	\N
1093089f-3c79-4afd-adf7-1c47e8b7a18e	af072108-d149-4c43-acc4-07ada07f95b8	1	6af901f6-bd7d-4bc7-8c9d-f441e526e65c	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2024-10-04 20:45:00+00	2024-11-13 08:14:00+00	PESCA	\N
f0894aac-c666-46ab-9810-dabc26ba100f	f88eedea-aab4-4ebd-84b4-69bd28a4d44c	2	4167beb8-ce39-4fd3-8314-8b3487879d92	\N	\N	2025-08-15 12:55:00+00	2025-08-26 22:45:00+00	PESCA	\N
f46e4cbe-ab2b-4356-912f-dd3983ece1f9	f88eedea-aab4-4ebd-84b4-69bd28a4d44c	3	4167beb8-ce39-4fd3-8314-8b3487879d92	\N	\N	2025-08-28 00:41:00+00	2025-09-05 11:50:00+00	PESCA	\N
70cf2b1d-7bcf-4da8-bb2a-5454bfe57953	bb0520ea-8ca8-4dfc-9a89-05ca05098859	1	4167beb8-ce39-4fd3-8314-8b3487879d92	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-05-26 17:21:00+00	2025-06-03 23:45:00+00	PESCA	\N
60b83090-5aac-4a00-a31a-3d9bc0e72a90	bb0520ea-8ca8-4dfc-9a89-05ca05098859	2	4167beb8-ce39-4fd3-8314-8b3487879d92	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-06-05 00:13:00+00	2025-06-11 01:15:00+00	PESCA	\N
f57f877e-b063-43be-bc0c-bd72c883a08a	44d2a899-840d-4c2e-b2ec-cdf3a83e1644	1	6af901f6-bd7d-4bc7-8c9d-f441e526e65c	\N	\N	2024-10-15 19:25:00+00	2024-11-02 18:30:00+00	PESCA	\N
89ae59ae-5a21-40ad-874a-c77a97a6a7b2	7ce9a44f-8e20-4350-9d01-6bcf948dad0a	1	92d9acc2-3590-474f-a773-73e8af728e83	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2024-09-18 14:45:00+00	2024-10-30 19:05:00+00	PESCA	\N
a9656b55-1b90-4d7c-b2e3-9291dd7032d9	7ae496f6-98c7-4340-a670-20e35fc8f09a	1	6af901f6-bd7d-4bc7-8c9d-f441e526e65c	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2024-10-19 07:00:00+00	2024-11-25 14:15:00+00	PESCA	\N
f6ac7e22-ba9e-4991-8fb5-24698a584980	e6d4776a-48a2-414b-9a82-52c25364fd88	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-01-01 06:46:00+00	2024-10-13 23:39:00+00	PESCA	\N
60d3df79-00ce-4ffe-8c9e-6d121f73a95d	a2340655-447b-4e2e-b22d-ff9fa6a250cb	1	822d18e6-569a-40fc-a58f-429b6bef4613	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2024-10-21 00:00:00+00	2024-11-29 00:00:00+00	PESCA	\N
f554aa7a-7aaf-4769-82cc-bbd2c7ff7d5d	2187fa4d-c865-4773-b3b6-5f77b1b55376	1	4167beb8-ce39-4fd3-8314-8b3487879d92	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-06-17 18:22:00+00	2025-06-28 07:11:00+00	PESCA	\N
4a90d6ac-3c8c-4ba8-9c0c-c2f596a86dbb	43957680-f42e-4eb2-b639-0510e32efdf6	1	92d9acc2-3590-474f-a773-73e8af728e83	b8a55941-9f65-4e90-bea1-3683753d42b5	b8a55941-9f65-4e90-bea1-3683753d42b5	2024-10-10 21:45:00+00	2024-12-03 05:45:00+00	PESCA	\N
a0135430-8f7a-4205-9314-680a77f286fc	898de745-6ac9-4bbc-9097-9f3500965a67	1	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2024-10-04 19:18:00+00	2024-10-28 20:00:00+00	PESCA	\N
95fec4d1-96c4-4ab4-a3dd-1cfdd0666896	898de745-6ac9-4bbc-9097-9f3500965a67	2	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-09-13 00:00:00+00	2025-10-12 00:00:00+00	PESCA	\N
0bc10cf9-3cf0-4e11-8e81-dc69078858b1	44c12995-f99a-470b-8421-e882db22530f	1	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2024-10-08 21:25:00+00	2024-10-29 07:00:00+00	PESCA	\N
b8de18fa-4f00-46d7-975e-34b05c69132a	44c12995-f99a-470b-8421-e882db22530f	2	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-09-18 00:00:00+00	2025-10-10 00:00:00+00	PESCA	\N
5baac800-9b37-4274-9e0e-f46189c3f3b4	b3d84470-5b1c-40c3-beaa-91c86ad13cc7	1	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2024-08-02 13:25:00+00	2024-12-15 11:05:00+00	PESCA	\N
e2bd885b-ce6e-444c-855f-c3daa37ac413	f9e034a6-27d4-4ab9-a649-d5c4eeb306a0	1	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2024-10-03 15:15:00+00	2024-10-26 06:59:00+00	PESCA	\N
758161d1-6447-4cfd-835a-ac976100f059	0d54087a-ae0a-4241-83ac-f10f72456ebe	1	6af901f6-bd7d-4bc7-8c9d-f441e526e65c	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2024-10-23 19:20:00+00	2024-11-08 14:05:00+00	PESCA	\N
b320f2e6-1645-4bcc-88f2-775005d164c0	9a69138b-eb69-476a-b861-8d3c25332438	1	92d9acc2-3590-474f-a773-73e8af728e83	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2024-11-01 07:25:00+00	2024-12-12 21:10:00+00	PESCA	\N
19073ae6-f42b-4fc1-8d92-cfea0dd0a31b	584cd44a-972d-4075-a258-df2a58e3267a	1	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2024-11-02 23:35:00+00	2024-11-23 08:30:00+00	PESCA	\N
9c3988fa-1d9b-401c-8c34-a71d09169db5	f18a9b09-baa6-4914-a3fa-f241b0d08c5d	1	92d9acc2-3590-474f-a773-73e8af728e83	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2023-12-28 00:50:00+00	2024-02-01 09:30:00+00	PESCA	\N
9d4074a9-2608-491d-830f-9c0734403de2	059cf9fd-83b7-45b7-aa2a-e337d9fff8ba	1	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2024-11-04 05:55:00+00	2024-11-28 19:40:00+00	PESCA	\N
9e361870-3a2f-4b72-ad5f-3937d64aead3	790cc62b-34f2-470f-aa00-f462a23b4bb4	1	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2024-10-31 00:16:00+00	2024-11-26 20:20:00+00	PESCA	\N
7908933e-c3a0-4c01-92ef-7703dff0ce4b	86bb8d63-7f71-472e-afa6-6e2fe37ff081	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2024-11-01 16:38:00+00	2024-11-07 08:00:00+00	PESCA	\N
60bfe49d-22dd-41a6-aeca-d8d0dd553f9a	5a4d18cd-966c-41c8-94fc-4eb834cbcb4f	1	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2024-11-20 07:15:00+00	2024-12-10 13:30:00+00	PESCA	\N
9ce0fd2e-8580-42d1-94cb-a2db75c7fd79	4f41563b-a778-4d8e-97ce-1fbaa60bf4eb	1	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2024-10-03 20:30:00+00	2024-10-29 12:55:00+00	PESCA	\N
f61eafa9-71b4-4eba-ab8e-58519cdf160e	f288f24a-3e1c-4257-9af9-53288b123f02	1	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2024-10-28 20:10:00+00	2024-11-22 06:00:00+00	PESCA	\N
d81a2ec0-b542-4fff-ba4c-7c545e7763f2	71d876df-245a-444b-8bf8-8fdf9427d9f6	1	92d9acc2-3590-474f-a773-73e8af728e83	f41ff939-bc00-4bbd-8ce8-c451922ba284	f41ff939-bc00-4bbd-8ce8-c451922ba284	2024-09-05 12:26:00+00	2024-09-25 08:50:00+00	PESCA	\N
edcf163f-12e3-4bc9-9fe5-8d178a64691d	9b1af2f9-4566-4622-a677-fefa8daa7455	1	92d9acc2-3590-474f-a773-73e8af728e83	b8a55941-9f65-4e90-bea1-3683753d42b5	b8a55941-9f65-4e90-bea1-3683753d42b5	2024-03-26 22:35:00+00	2024-05-15 23:00:00+00	PESCA	\N
2b74bf07-0a12-4167-be01-a520774a0add	76a2a093-7a3a-4073-b94f-ff94de76a022	1	4167beb8-ce39-4fd3-8314-8b3487879d92	\N	\N	2025-08-05 12:41:00+00	2025-08-13 19:20:00+00	PESCA	\N
e0a1ade2-92e1-4d4c-a3f2-fcf21de98c8a	2c3e50f2-80fa-4235-8ea5-479884e5badb	1	92d9acc2-3590-474f-a773-73e8af728e83	b8a55941-9f65-4e90-bea1-3683753d42b5	b8a55941-9f65-4e90-bea1-3683753d42b5	2024-05-17 18:30:00+00	2024-07-02 05:25:00+00	PESCA	\N
ded4fdfc-2d6f-41e6-ad7b-745dcd62a2f0	6e638471-4781-4546-84a6-a74de5ce8be5	1	6af901f6-bd7d-4bc7-8c9d-f441e526e65c	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2024-01-03 19:15:00+00	2024-01-23 13:30:00+00	PESCA	\N
a41e48d6-12cd-4a8c-9f6d-f25374a0eec9	98ff9c03-9728-47f8-8173-870ffe061b51	1	6af901f6-bd7d-4bc7-8c9d-f441e526e65c	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2024-02-16 18:45:00+00	2024-03-24 14:45:00+00	PESCA	\N
8e08816c-0403-4a81-8d0d-537d7e5f38d7	04ebbeee-f08e-4ae1-8035-f5241f6ee33c	1	6af901f6-bd7d-4bc7-8c9d-f441e526e65c	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2024-03-28 17:55:00+00	2024-05-09 21:45:00+00	PESCA	\N
b51cdacf-6656-438a-b189-ad8f9fd744c4	98d2d67b-09ec-4038-a941-d5710411fc05	1	6af901f6-bd7d-4bc7-8c9d-f441e526e65c	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2024-06-26 22:10:00+00	2024-08-07 15:00:00+00	PESCA	\N
0714a24f-1e85-4d34-9a86-83f3ed14b05f	ff8f6af0-a796-4c89-ad9d-314b7ce1c8d8	1	6af901f6-bd7d-4bc7-8c9d-f441e526e65c	\N	\N	2024-04-19 12:00:00+00	2024-05-13 18:04:00+00	PESCA	\N
15d8176b-15e8-435d-adad-235fcd19adfa	ac4bf302-24a6-485d-a1a7-309c2342d3f5	1	6af901f6-bd7d-4bc7-8c9d-f441e526e65c	\N	\N	2024-05-16 18:20:00+00	2024-06-05 07:54:00+00	PESCA	\N
f3071606-cd62-4ea5-9004-1363e85a3616	39282870-0c57-4bda-9358-be22d04d0d20	1	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2023-12-30 16:20:00+00	2024-02-01 21:15:00+00	PESCA	\N
42a20011-47e9-41e3-9ce4-9cdd194003e7	fcc06c4a-b1d5-46f4-a943-e9b4ff52a069	1	4167beb8-ce39-4fd3-8314-8b3487879d92	\N	\N	2024-03-27 17:15:00+00	2024-04-14 07:49:00+00	PESCA	\N
99492c0f-e20a-46d6-ba8e-1e8e1bb5e87b	c2e7ef07-c76b-4f6b-8dc6-153062b64f1b	1	4167beb8-ce39-4fd3-8314-8b3487879d92	\N	\N	2024-05-22 17:05:00+00	2024-06-02 17:05:00+00	PESCA	\N
1b2a2ad3-06c6-405a-9f64-19bdaaff8814	4653b095-9a0d-4b35-8f85-ec87c0be1399	1	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	f41ff939-bc00-4bbd-8ce8-c451922ba284	f41ff939-bc00-4bbd-8ce8-c451922ba284	2024-03-21 10:05:00+00	2024-04-16 15:40:00+00	PESCA	\N
887081b2-de47-4dec-8479-5b8c5e4ccfa0	f18d88c6-3877-4252-9eed-2ad5fd9011fe	1	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2023-12-29 15:30:00+00	2024-01-29 02:25:00+00	PESCA	\N
67e98e39-f871-4528-b6f8-f540884a192a	d91a3eb7-7b10-49d9-819f-687656fd12e4	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2024-02-19 16:20:00+00	2024-02-23 08:03:00+00	PESCA	\N
eae72ee0-725e-4de7-844c-640eb195eb4c	e5846c98-42ce-4b54-915c-84ab4fbb1f3f	1	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2024-03-06 18:55:00+00	2024-04-16 11:04:00+00	PESCA	\N
9f35817d-ff5a-40d6-b0d6-21cb19c3c3f4	fc6c5995-b96c-462e-a0b0-c45c2a58c92c	1	4167beb8-ce39-4fd3-8314-8b3487879d92	105b0349-a9ed-49bf-9336-aad8d3867f0b	105b0349-a9ed-49bf-9336-aad8d3867f0b	2024-05-23 23:18:00+00	2024-06-05 06:32:00+00	PESCA	\N
77d62f69-d437-45c6-b71e-2a70dcf9a9de	c5a2a674-c908-4d03-bb9e-ed695854c91b	1	92d9acc2-3590-474f-a773-73e8af728e83	b8a55941-9f65-4e90-bea1-3683753d42b5	b8a55941-9f65-4e90-bea1-3683753d42b5	2023-11-30 23:00:00+00	2024-02-06 05:38:00+00	PESCA	\N
f8999aa9-db2e-4d93-aec7-c67038afe21c	b8fb446b-ca68-4d0b-acbc-bc9f395a22be	1	6af901f6-bd7d-4bc7-8c9d-f441e526e65c	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2024-03-14 14:41:00+00	2024-04-16 12:43:00+00	PESCA	\N
f951144e-a432-4f86-95ec-48aa421ef53e	a15d1b4d-e699-4e4b-98ea-a005115cf2fa	1	6af901f6-bd7d-4bc7-8c9d-f441e526e65c	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2024-04-20 13:20:00+00	2024-05-22 08:43:00+00	PESCA	\N
83e65e94-70fa-47fb-956b-2b1da0e1a0f6	7ad4d9b6-f2d8-4f2e-a135-0aa268bba021	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2024-06-18 19:47:00+00	2024-06-29 11:58:00+00	PESCA	\N
b99e5eca-f87f-4167-8b4e-617c16923b7e	73e7be2d-d116-4a9f-b4d0-6ca2b40896a8	1	6af901f6-bd7d-4bc7-8c9d-f441e526e65c	\N	\N	2024-08-14 22:32:00+00	2024-09-03 07:18:00+00	PESCA	\N
08c2df0e-2fdb-4b41-9f50-95f821cb4e92	4d043d8d-83c9-4429-ae2e-330feea0d166	1	6af901f6-bd7d-4bc7-8c9d-f441e526e65c	\N	\N	2024-09-05 14:10:00+00	2024-10-10 08:43:00+00	PESCA	\N
b5fb3016-fd9b-407a-9515-bd1b8e047693	48ad14c2-66fc-4547-b0a0-75f8ec3452f5	1	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2023-12-30 12:50:00+00	2024-02-03 21:20:00+00	PESCA	\N
3bfc9df5-5c3f-477f-a4a7-579710f30405	a133d62b-cef6-42f6-8fe8-e9de6681e91b	1	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2024-02-23 19:20:00+00	2024-03-21 08:10:00+00	PESCA	\N
f077edef-6e75-4148-918a-eac931c33629	a5e25e55-470f-4c95-ab7a-4b71d272b8f3	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2024-04-29 17:02:00+00	2024-05-12 06:35:00+00	PESCA	\N
f3bea1b5-b075-4f7f-b85d-da25432cbeef	aaafd387-c375-4978-922e-e08c3dfdf4a3	1	4167beb8-ce39-4fd3-8314-8b3487879d92	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2024-07-28 17:54:00+00	2024-08-07 10:50:00+00	PESCA	\N
b1e47509-1bb2-486a-a929-b323535c60e3	ffb110ad-dd2a-45c3-a118-d5804de758b8	1	6af901f6-bd7d-4bc7-8c9d-f441e526e65c	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2024-01-10 13:50:00+00	2024-02-18 14:06:00+00	PESCA	\N
f2962082-c615-4af0-9cbc-135e02b0c13b	a1aa4e4f-f2b6-4910-bf54-93f0e7b7014c	1	6af901f6-bd7d-4bc7-8c9d-f441e526e65c	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2024-02-22 20:45:00+00	2024-04-04 07:46:00+00	PESCA	\N
1c195e7c-fb59-46df-90b6-026a19b62132	f49de315-ea20-4c72-9376-7a26db6b2ed8	1	6af901f6-bd7d-4bc7-8c9d-f441e526e65c	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2024-04-08 11:05:00+00	2024-05-30 10:07:00+00	PESCA	\N
c63fbb7d-7507-4ed7-ad72-8859b10e4fe3	5fbe62ae-8105-49a1-84e5-5b81f209776d	1	6af901f6-bd7d-4bc7-8c9d-f441e526e65c	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2024-07-26 14:32:00+00	2024-09-11 09:37:00+00	PESCA	\N
8646f562-d14b-453b-96c1-248966897473	90d978d5-f61e-4dff-9c65-57bd9383dea0	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-07-12 09:51:00+00	2025-07-14 14:17:00+00	PESCA	\N
0e70a3dc-6387-4f62-90e9-65086075022a	90d978d5-f61e-4dff-9c65-57bd9383dea0	2	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-07-18 10:00:00+00	2025-07-23 14:35:00+00	PESCA	\N
e5118fdb-8d11-4977-b05e-12e52d363b51	8f5a12a1-3780-43d5-b7e2-f9f57634c032	1	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2024-01-08 10:57:00+00	2024-02-01 05:21:00+00	PESCA	\N
058f9818-4a91-453e-b567-7cfb98be1a03	e1166e1f-e00f-416a-b261-2a97c40e6b23	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2024-07-06 12:20:00+00	2024-07-14 12:54:00+00	PESCA	\N
6ed577a3-4adf-4c81-8a5e-4d60f93398b8	6e9effd2-5b3f-44dd-b304-cafce82bb49d	1	6af901f6-bd7d-4bc7-8c9d-f441e526e65c	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2024-01-06 15:49:00+00	2024-01-08 20:15:00+00	PESCA	\N
3ac4fe20-edd2-46b1-98d1-49ffc597a79b	41cd7cc2-7087-44c2-aeba-b76145a048e0	1	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2024-03-14 15:32:00+00	2024-04-22 09:00:00+00	PESCA	\N
a1ae28ce-0744-436f-ac9d-e1ae2e9c7e90	90d978d5-f61e-4dff-9c65-57bd9383dea0	3	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-07-27 14:00:00+00	2025-08-01 14:59:00+00	PESCA	\N
13eaa0b4-164c-4b90-9c5c-4f1f36711bd1	49f96334-e0b5-4f97-950d-befd443e7f6c	1	4167beb8-ce39-4fd3-8314-8b3487879d92	f41ff939-bc00-4bbd-8ce8-c451922ba284	f41ff939-bc00-4bbd-8ce8-c451922ba284	2025-08-05 14:33:00+00	2025-08-13 16:05:00+00	PESCA	\N
c1f27251-b94a-4138-858c-fa993e579037	49f96334-e0b5-4f97-950d-befd443e7f6c	2	4167beb8-ce39-4fd3-8314-8b3487879d92	f41ff939-bc00-4bbd-8ce8-c451922ba284	f41ff939-bc00-4bbd-8ce8-c451922ba284	2025-08-14 17:15:00+00	2025-08-22 11:50:00+00	PESCA	\N
5ba79707-1678-4caf-9d11-6f4375641353	1d5d4f83-7a86-4b7a-b761-1977cbf81e5e	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-01-11 11:45:00+00	2025-01-19 07:50:00+00	PESCA	\N
f16e4bc4-c59a-42fe-a4bf-5600738d2a09	1d5d4f83-7a86-4b7a-b761-1977cbf81e5e	2	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-01-22 11:56:00+00	2025-01-29 21:50:00+00	PESCA	\N
fb5a9a94-73b4-4335-8dd0-60abaf0c2428	1d5d4f83-7a86-4b7a-b761-1977cbf81e5e	3	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-01-31 18:49:00+00	2025-02-11 11:40:00+00	PESCA	\N
99255092-6aca-4d0c-b4ae-f82cdb59f018	1a98c017-8f47-4970-825c-2725c6ec292b	1	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2023-12-07 22:50:00+00	2024-01-14 10:25:00+00	PESCA	\N
73af99ac-92e8-4914-9768-4be8f579903b	618fdd7e-84ab-4d3f-9ead-59f41e59161e	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-04-21 14:15:00+00	2025-04-29 16:36:00+00	PESCA	\N
70aa67b4-b059-4c5c-9775-07458e78ec9e	618fdd7e-84ab-4d3f-9ead-59f41e59161e	2	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-05-02 13:00:00+00	2025-05-10 17:40:00+00	PESCA	\N
f6085cd2-8a53-410e-b505-3461b8f20328	9fc1b93f-4239-48ee-a433-e449a87412ce	1	92d9acc2-3590-474f-a773-73e8af728e83	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2024-02-29 21:05:00+00	2024-04-09 02:50:00+00	PESCA	\N
5602f877-1b71-4b6c-9e54-bdb2804bdf27	5f747fdc-f223-4f3e-ae8f-620f80e95aa9	1	4167beb8-ce39-4fd3-8314-8b3487879d92	\N	\N	2024-05-22 15:40:00+00	2024-06-11 10:10:00+00	PESCA	\N
06e6b990-7108-484a-944a-a5de9159c866	931a55f5-dd14-4d7a-86d9-63145e4562ce	1	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2024-01-09 18:45:00+00	2024-02-11 09:08:00+00	PESCA	\N
4eb9a469-cd96-418c-bb19-2e6ae132a44f	660894c9-79ec-4569-8eee-55d151bfb915	1	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2024-02-14 18:40:00+00	2024-03-17 08:00:00+00	PESCA	\N
f4ba8c1f-64a4-4f7a-a3c5-091b7038f559	618fdd7e-84ab-4d3f-9ead-59f41e59161e	3	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-05-14 08:52:00+00	2025-05-26 14:14:00+00	PESCA	\N
58dfa3fe-a84d-42aa-8f28-7d81587ecb83	3d249765-b8c1-4ad2-8a4e-76ec128ddb2b	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-05-02 14:40:00+00	2025-05-09 09:45:00+00	PESCA	\N
b60b31b4-d8c7-4aa1-a2d8-c8965c160516	d88782e8-957f-45f1-b052-be1be632650a	1	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2024-02-03 18:25:00+00	2024-03-06 18:20:00+00	PESCA	\N
9a7343a0-06b1-46d5-82f8-dbda929ec2e3	c643bb24-15ff-4562-a7df-5213b71a2a3c	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	105b0349-a9ed-49bf-9336-aad8d3867f0b	105b0349-a9ed-49bf-9336-aad8d3867f0b	2024-07-13 09:00:00+00	2024-08-20 06:07:00+00	PESCA	\N
93375966-210a-4ad2-ab33-eb92a299a85d	a3925499-5d96-442f-bf17-5ec4b9847a3b	1	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2024-01-09 11:53:00+00	2024-02-05 18:37:00+00	PESCA	\N
f97bd7dc-baed-4bb7-a9e8-aef009d5f678	f4567039-49af-49b5-b976-1b3ad11a0060	1	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2024-04-30 18:40:00+00	2024-05-16 00:00:00+00	PESCA	\N
bce0d4a6-e72b-4de9-bb06-5af0538ee237	083ee690-9c5d-4210-afee-9837772fb42c	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2024-05-29 17:45:00+00	2024-06-29 17:05:00+00	PESCA	\N
cbe7e705-17bf-4c66-8992-4b694e557a86	8836e79f-d707-4f13-a88f-34f778687995	1	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2024-10-27 23:30:00+00	2024-10-29 15:55:00+00	PESCA	\N
86c104f7-74b7-4c1f-9b30-27c3d0cb0edb	ec5c3dff-621d-4a7b-9ecc-b7c40fe6243f	1	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2023-12-30 12:30:00+00	2024-02-03 20:47:00+00	PESCA	\N
a0f55711-94ae-4515-840d-6e4745d47cbc	9710cc6b-acba-47be-9e6e-d8eb493af822	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2024-05-10 13:25:00+00	2024-06-14 19:30:00+00	PESCA	\N
915707d0-d4c8-4cd8-9072-43420026c283	97d0ea61-1676-43ef-bf16-417d28e9aaa7	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2024-07-10 19:19:00+00	2024-08-09 18:50:00+00	PESCA	\N
c8335bf5-c81c-47c6-b0f0-37cdc135a011	71dd9b9e-0e5d-43fc-95c9-d5a6f8b7628d	1	4167beb8-ce39-4fd3-8314-8b3487879d92	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2024-05-11 13:50:00+00	2024-05-20 11:37:00+00	PESCA	\N
9fe856ac-78e9-497d-bf4e-991c5ba5716a	5875eb9a-b82e-4600-96aa-055f428891b6	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2024-08-07 11:38:00+00	2024-08-15 00:52:00+00	PESCA	\N
1ea53439-123d-473b-be82-c4dc358d4e44	ae796a8c-4350-452d-bfa6-6b77dbc8bfad	1	92d9acc2-3590-474f-a773-73e8af728e83	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2024-09-30 00:45:00+00	2024-10-29 23:51:00+00	PESCA	\N
d2f2f5e0-3787-402c-8cb5-7dde3d700bac	3d249765-b8c1-4ad2-8a4e-76ec128ddb2b	2	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-05-14 12:35:00+00	2025-05-25 15:35:00+00	PESCA	\N
295ed017-75a6-4fc1-b74b-be3487c94e9c	23319c73-a2b2-4cb7-ab2f-a828534113ef	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-06-25 12:30:00+00	2025-07-03 17:16:00+00	PESCA	\N
f0293f99-ea83-425a-b6eb-1171791d912f	04e8f3de-0742-4da7-8158-662ac3801ec5	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2024-01-17 15:00:00+00	2024-01-25 05:38:00+00	PESCA	\N
9e84b1c6-038b-4ba5-84a2-efe0f5e7eae8	0c171979-f122-4d6f-babc-c7087075176e	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2024-04-24 16:30:00+00	2024-05-04 17:08:00+00	PESCA	\N
98c95cce-031c-480d-8af5-5ae04837e1e2	23319c73-a2b2-4cb7-ab2f-a828534113ef	2	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-07-05 12:44:00+00	2025-07-11 10:25:00+00	PESCA	\N
5d6edab8-88ee-4c3f-9ee9-dad72d73d0a1	23319c73-a2b2-4cb7-ab2f-a828534113ef	3	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-07-20 10:35:00+00	2025-07-26 10:40:00+00	PESCA	\N
66201fd3-e276-4aa7-a76b-208a5f869e1a	23319c73-a2b2-4cb7-ab2f-a828534113ef	4	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-07-28 16:17:00+00	2025-08-04 08:33:00+00	PESCA	\N
bd6e6b3a-5102-4ed2-ba07-3ea6cebc812b	9a6419d7-b065-47ad-bd2a-0566630e98a1	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-06-05 17:40:00+00	2025-07-06 07:53:00+00	PESCA	\N
ad7eee49-fceb-4a05-ac15-0ab3ebdbd7f8	ebe416fb-d85b-41db-b2f0-e7a493ed6544	1	4167beb8-ce39-4fd3-8314-8b3487879d92	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-08-20 12:58:00+00	2025-08-30 07:00:00+00	PESCA	\N
5df0f2e2-df3f-4edd-b201-a02fec8c9a65	195e5644-2982-4476-a62f-7cf736f166b6	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-08-23 12:00:00+00	2025-09-22 13:34:00+00	PESCA	\N
93d07369-7159-4e4f-bb09-bdfcc7e0123b	fbc6fdad-c8c7-4ae1-bfef-855b2db3105b	1	4167beb8-ce39-4fd3-8314-8b3487879d92	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-08-03 18:40:00+00	2025-08-07 15:49:00+00	PESCA	\N
2cf98e04-bd58-486c-8619-0c26145db110	0a66aeb0-6995-43d6-94b2-7620092d85b1	1	92d9acc2-3590-474f-a773-73e8af728e83	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2024-02-03 09:55:00+00	2024-03-20 03:00:00+00	PESCA	\N
6ccfbd08-46f1-438f-af6d-17d3202aae97	5e83bbb9-37aa-47bd-ace2-ac7770bcc64b	1	92d9acc2-3590-474f-a773-73e8af728e83	f41ff939-bc00-4bbd-8ce8-c451922ba284	f41ff939-bc00-4bbd-8ce8-c451922ba284	2024-04-20 14:15:00+00	2024-05-25 12:45:00+00	PESCA	\N
127d6894-98b1-46b0-8303-8fd640a0cc9a	dfee9dad-b4dd-4454-bb0c-908beff14d7a	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2024-07-02 20:50:00+00	2024-07-31 16:31:00+00	PESCA	\N
387b5fce-9de0-43ed-977d-59a250f33855	f1920acc-85c6-44df-86a8-41c546609916	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2024-02-07 18:15:00+00	2024-03-13 15:10:00+00	PESCA	\N
fbdb0f35-d8d7-472a-9ad9-f5e58a2108bb	6685e8d6-f452-4a7e-8c14-a2ec3807405c	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2024-04-26 16:40:00+00	2024-05-26 18:50:00+00	PESCA	\N
32a25513-d440-465a-be49-845638b691ed	f18fe2b0-89fc-432a-b30d-dc67532e0ef2	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2024-05-29 15:40:00+00	2024-06-30 08:20:00+00	PESCA	\N
27f170f7-6fad-442e-90a7-a110f7043bdf	7bf159fd-2222-40d6-b731-ca8142eb9759	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2024-07-17 08:42:00+00	2024-08-20 07:31:00+00	PESCA	\N
cd0e4aa3-a6d7-412d-8715-36833a19e0ef	7200da53-4fdc-459e-80f8-71d581ecfd82	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2024-09-02 19:00:00+00	2024-10-09 06:50:00+00	PESCA	\N
dc9fc1b5-d235-41b0-87ef-ad79973e4277	6222e8ae-a7f8-4728-a647-55067706fc00	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2024-01-22 03:08:00+00	2024-01-29 01:42:00+00	PESCA	\N
55a2e6cd-afff-43f1-857b-e98b255033c0	e3fcbb6e-adab-45c0-8abd-ba8994822850	1	4167beb8-ce39-4fd3-8314-8b3487879d92	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2024-03-28 09:10:00+00	2024-04-15 12:45:00+00	PESCA	\N
9e156d78-2c23-42da-951a-8dcdc4fc8c5d	e172c7c7-293d-4002-bbb2-e2083806984b	1	4167beb8-ce39-4fd3-8314-8b3487879d92	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2024-05-22 00:00:00+00	2024-06-09 00:00:00+00	PESCA	\N
224d9828-cd9b-4d1c-ac7f-fd1a27c41026	3f2d7f2d-22b2-46a5-8172-b6974418d645	1	4167beb8-ce39-4fd3-8314-8b3487879d92	\N	\N	2024-08-08 19:15:00+00	2024-08-22 15:00:00+00	PESCA	\N
e4e0de6c-f19c-460c-90fc-6e859104f45e	d904c6d9-3744-4cb6-a107-5d9d81e9a006	1	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2024-04-20 16:22:00+00	2024-05-15 09:06:00+00	PESCA	\N
ebd59b3d-637c-4a91-8145-5ba4d4f01c15	cb82ee3f-5e33-423e-9642-70420dd66759	1	4167beb8-ce39-4fd3-8314-8b3487879d92	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2024-06-12 10:33:00+00	2024-06-18 10:54:00+00	PESCA	\N
07f3fb44-b7b2-4412-aa72-18368374947c	2d7d92a3-99e9-45e4-9994-d7e70e755b2c	1	92d9acc2-3590-474f-a773-73e8af728e83	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2024-09-02 22:00:00+00	2024-09-24 06:05:00+00	PESCA	\N
e9a8589a-b4c4-4a77-bf6d-07b03b6ca825	089b3c97-73cb-4c31-960b-30f6a6584f90	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2024-02-22 18:00:00+00	2024-03-03 11:34:00+00	PESCA	\N
36d796f4-d210-4a9a-9225-ffcf01989bfe	df1c0975-7245-4b63-857d-b8e50070b832	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2024-08-02 18:10:00+00	2024-08-09 08:59:00+00	PESCA	\N
24d040fb-2418-4b47-8988-04e297093d73	107ee663-91ec-4bcb-bfca-d6456178f532	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2024-09-06 17:10:00+00	2024-09-13 06:27:00+00	PESCA	\N
2de9fe26-fc65-4ab8-a997-86a86fe8728e	3aa4d800-112e-431c-ab78-16836a5c9227	1	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2024-02-23 10:40:00+00	2024-03-25 17:15:00+00	PESCA	\N
b4567dea-68fc-4cee-b09e-0b7d319ff0f9	08ae1dc1-b6a1-40da-a2d2-38f9ecd2cd2d	1	4167beb8-ce39-4fd3-8314-8b3487879d92	f41ff939-bc00-4bbd-8ce8-c451922ba284	f41ff939-bc00-4bbd-8ce8-c451922ba284	2024-05-02 15:55:00+00	2024-05-20 09:30:00+00	PESCA	\N
9c277d6f-3f92-4d41-8967-c463d6e85a15	a5f5f381-9934-468a-aec3-8d76c001ec33	1	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2024-02-06 21:35:00+00	2024-03-03 09:15:00+00	PESCA	\N
f47c2a2b-230e-4ff7-8da8-0d45b5bfe1e2	6ba4a39a-a4ab-4162-b4eb-b41f9a05a79c	1	6af901f6-bd7d-4bc7-8c9d-f441e526e65c	\N	\N	2024-07-11 16:50:00+00	2024-08-07 12:35:00+00	PESCA	\N
1dbb37e6-cdae-42f5-bfe2-09cb80f4af6f	835a98e2-e457-4ded-9785-1a9d25954896	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2024-08-16 15:46:00+00	2024-08-24 12:50:00+00	PESCA	\N
7a77ad6e-9a32-4736-ae7f-8485e3aa128e	2a021427-35d8-4735-80f1-f3713ea5eb1a	1	6af901f6-bd7d-4bc7-8c9d-f441e526e65c	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2024-08-29 14:05:00+00	2024-10-15 18:40:00+00	PESCA	\N
32055b02-18c1-4c9f-b9a1-04e6f866e856	1925f7e5-6f32-4848-ac54-f981b7beb94e	1	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	105b0349-a9ed-49bf-9336-aad8d3867f0b	105b0349-a9ed-49bf-9336-aad8d3867f0b	2024-12-28 13:10:00+00	2025-01-16 14:00:00+00	PESCA	\N
2721b418-9bd1-4fdb-a27d-968c022cf91d	33b8e975-708b-4e2c-9079-3babbff08524	1	92d9acc2-3590-474f-a773-73e8af728e83	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2024-11-03 18:35:00+00	2024-12-19 04:00:00+00	PESCA	\N
d8589619-6ec3-4760-8985-618140646814	bccaa707-1b57-4ff6-8033-4e7817e1c5f2	1	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2024-10-06 22:40:00+00	2024-10-31 08:40:00+00	PESCA	\N
d572a779-a73a-4f65-8c9f-895397468c1d	bccaa707-1b57-4ff6-8033-4e7817e1c5f2	3	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-09-15 00:00:00+00	2025-10-10 00:00:00+00	PESCA	\N
70a30e9b-53d7-4d4c-9d00-3b9b071495cd	30a55e75-b984-4d3a-a9a3-6cc79261c835	1	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2024-12-30 22:34:00+00	2025-01-27 04:45:00+00	PESCA	\N
8d39ce14-e4df-4d50-9932-d71b1c6710d1	b5bfa7b0-e16f-42e8-b421-5ccb2d65b2bb	1	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2024-12-31 05:20:00+00	2025-02-04 04:52:00+00	PESCA	\N
afcbe897-f2a1-4a25-a2f5-b0f4dc820bb8	87919b14-60c2-4f58-8b2d-d2c8cea655b1	1	92d9acc2-3590-474f-a773-73e8af728e83	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-01-03 04:35:00+00	2025-02-03 01:35:00+00	PESCA	\N
94d9e9dc-a913-4073-b2d5-1de963479456	251206d0-7b9e-4247-905d-44ad002516c2	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2024-10-04 10:09:00+00	2024-10-07 08:05:00+00	PESCA	\N
79d8fd87-dd94-46ed-8d29-ce85051cb82e	79040bac-e3f9-4f9f-b0fc-93360063ef7c	1	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	f41ff939-bc00-4bbd-8ce8-c451922ba284	f41ff939-bc00-4bbd-8ce8-c451922ba284	2025-01-07 16:40:00+00	2025-01-30 08:50:00+00	PESCA	\N
ec873ad2-1480-4704-aca0-e367f0433152	ac7e03d7-42e1-4902-a530-8afd2e8c2750	1	6af901f6-bd7d-4bc7-8c9d-f441e526e65c	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-01-06 20:55:00+00	2025-02-07 09:45:00+00	PESCA	\N
9ce3d08c-415b-4a2a-a2da-3dfe3959ae45	16904ecf-f79d-4434-9445-1e6e9f33ddfc	1	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-01-09 11:25:00+00	2025-02-08 21:54:00+00	PESCA	\N
63ba2b06-0d4f-4774-91c9-98c94bb65589	8caf5618-e1b6-4fd8-84db-e744a800b5c6	1	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-01-09 15:00:00+00	2025-02-02 19:58:00+00	PESCA	\N
f12b2249-d8b7-4980-bc7c-2005bfdffd8e	73e9a605-4d0f-43e1-ad45-332ac496af8b	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-01-11 12:37:00+00	2025-03-07 11:14:00+00	PESCA	\N
599238fc-cdae-4095-80c3-49615ff8dd33	6e9d2370-746c-4ad1-be73-b8810eb0a9b0	1	6af901f6-bd7d-4bc7-8c9d-f441e526e65c	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-01-17 23:35:00+00	2025-03-01 19:40:00+00	PESCA	\N
eaefdc64-6afc-4f56-a121-87cc0dfd115d	d0c53136-1cee-43f9-bb0c-cd1ab21647da	1	92d9acc2-3590-474f-a773-73e8af728e83	b8a55941-9f65-4e90-bea1-3683753d42b5	b8a55941-9f65-4e90-bea1-3683753d42b5	2025-02-05 00:00:00+00	2025-04-07 00:00:00+00	PESCA	\N
7f8f6fa7-995d-4c89-a7c6-131891efcfed	e9cce076-b230-4d2f-8781-4d6354a46d0e	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-02-18 11:27:00+00	2025-02-25 20:17:00+00	PESCA	\N
d80e3679-7fa5-4f14-83d7-149990d0aba4	2c7e0f5f-b5c2-4c9b-8565-2ad257bf4810	1	92d9acc2-3590-474f-a773-73e8af728e83	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-02-19 00:00:00+00	2025-04-11 09:30:00+00	PESCA	\N
09b0b5c9-e1d1-4402-bbb8-8ab5a94b2cd1	af84f355-8af5-4320-8eee-7c7c40b9704e	1	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-02-22 09:10:00+00	2025-03-26 16:15:00+00	PESCA	\N
101e3a8c-cde1-427b-94b8-b4cb93673424	4ce967fa-c707-460d-858c-70bcfce11ef9	1	6af901f6-bd7d-4bc7-8c9d-f441e526e65c	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-03-01 13:40:00+00	2025-04-07 11:48:00+00	PESCA	\N
d2e25001-bcc8-449a-8015-9bf037732d5b	5dc80ed4-86df-46fa-893a-9710b6e78ce7	2	4167beb8-ce39-4fd3-8314-8b3487879d92	\N	\N	2025-08-12 21:44:00+00	2025-08-12 23:11:00+00	PESCA	\N
81bd2fe1-5cd3-4c73-aa53-f9d517a4d91a	5dc80ed4-86df-46fa-893a-9710b6e78ce7	3	4167beb8-ce39-4fd3-8314-8b3487879d92	\N	\N	2025-08-13 18:21:00+00	2025-08-26 03:25:00+00	PESCA	\N
58586d35-4baa-41a7-a784-accf87509dd4	5dc80ed4-86df-46fa-893a-9710b6e78ce7	4	4167beb8-ce39-4fd3-8314-8b3487879d92	\N	\N	2025-08-26 23:50:00+00	2025-09-07 08:15:00+00	PESCA	\N
c2f19a1e-41e5-49d6-b461-d6298f9c3ff5	5dc80ed4-86df-46fa-893a-9710b6e78ce7	5	4167beb8-ce39-4fd3-8314-8b3487879d92	\N	\N	2025-09-08 22:05:00+00	2025-09-23 18:55:00+00	PESCA	\N
c18e079d-972c-4eca-a28a-09786394cf2c	e7f4968e-21f5-477b-a740-0c7ab0d2a968	1	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2024-12-30 23:14:00+00	2025-02-03 08:45:00+00	PESCA	\N
af63a8c5-d17c-4d76-9b44-0a255aefd291	e7f4968e-21f5-477b-a740-0c7ab0d2a968	2	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-02-04 19:40:00+00	2025-02-19 11:11:00+00	PESCA	\N
06bc0496-1e3f-4587-9f98-832db1d5bc4f	e6920a77-cb20-476f-8096-546b90bc72ae	1	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-03-07 16:25:00+00	2025-04-07 12:56:00+00	PESCA	\N
53ac7a1d-13c4-4c50-aaac-5a13a034c5c9	5dc80ed4-86df-46fa-893a-9710b6e78ce7	6	4167beb8-ce39-4fd3-8314-8b3487879d92	\N	\N	2025-09-26 11:00:00+00	2025-10-07 12:18:00+00	PESCA	\N
9c4f62e0-d752-4eea-9b92-5e24a6d34e51	9a267a5d-70f1-45c3-9f38-ba35a54b9c69	1	6af901f6-bd7d-4bc7-8c9d-f441e526e65c	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-03-06 18:20:00+00	2025-04-13 23:40:00+00	PESCA	\N
3c2e9c28-e74c-4c83-abc6-b7cb6733f06f	31e27489-d08a-4cf3-804d-7d60e7fe3aca	1	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	\N	\N	2025-01-17 18:40:00+00	2025-03-09 20:51:00+00	PESCA	\N
f45719f5-bd91-4050-aefd-18c4cacc8aa6	5c53a631-b7a7-4a7e-80bf-e9cf0237b6bb	1	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-02-06 00:08:00+00	2025-03-11 12:30:00+00	PESCA	\N
37d5766f-c991-4130-a5d2-f7b7c60e2de9	e5b35988-850d-431f-9172-96a9cf16fb76	1	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	f41ff939-bc00-4bbd-8ce8-c451922ba284	f41ff939-bc00-4bbd-8ce8-c451922ba284	2025-01-31 14:50:00+00	2025-03-24 09:35:00+00	PESCA	\N
2876ec79-6ef2-4653-8462-32ce0ea68663	f5af9e00-7d55-424f-b3d8-255e47dab9c9	1	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-02-01 12:55:00+00	2025-02-26 06:55:00+00	PESCA	\N
3e61f879-e4b0-4309-b0d8-20fee3ea9002	650dd08b-c34c-4f25-a6b6-60278918e41d	1	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-02-01 13:18:00+00	2025-03-08 06:19:00+00	PESCA	\N
7cf2f8f4-e807-41af-b969-83f1064e05e3	f6c9d06f-029e-4bd4-934a-611687d257ad	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-02-08 12:35:00+00	2025-02-22 07:36:00+00	PESCA	\N
921d3fb9-0416-4caa-9cd6-fdaca1176594	51249ac3-1cea-4ffa-a9f0-a745dfb07368	1	92d9acc2-3590-474f-a773-73e8af728e83	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-02-13 17:05:00+00	2025-03-24 17:05:00+00	PESCA	\N
d8370ea1-2b34-4cb1-a0a3-75e8642fc567	51249ac3-1cea-4ffa-a9f0-a745dfb07368	2	92d9acc2-3590-474f-a773-73e8af728e83	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-03-26 21:20:00+00	2025-05-07 04:20:00+00	PESCA	\N
542b1d8d-3757-4f84-917a-8e6d834e5f9b	1bd1e044-82a7-4663-986a-360a74d46039	1	6af901f6-bd7d-4bc7-8c9d-f441e526e65c	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-02-12 16:34:00+00	2025-03-20 19:07:00+00	PESCA	\N
346eff0f-a99b-4a8f-9dda-b3dda4709007	525fac11-e408-44cb-a043-43d3ed0c5a43	1	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-03-06 13:02:00+00	2025-03-26 17:12:00+00	PESCA	\N
91458793-7141-4a68-a68c-b28b80364a64	baaad5c2-fe5b-4e3d-a372-16afe7c895b1	1	92d9acc2-3590-474f-a773-73e8af728e83	f41ff939-bc00-4bbd-8ce8-c451922ba284	f41ff939-bc00-4bbd-8ce8-c451922ba284	2025-02-25 00:00:00+00	2025-03-30 00:00:00+00	PESCA	\N
54966478-b449-4f8b-83ed-690ae990ba2c	93d15057-5468-4c3f-a6d2-1b25145fc1a8	1	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-02-04 16:05:00+00	2025-03-11 04:30:00+00	PESCA	\N
acd27b33-b437-466f-a88d-c48b7fe79ce3	6cecfbac-9a2c-4dd2-b976-45d7e7f4c408	1	6af901f6-bd7d-4bc7-8c9d-f441e526e65c	\N	\N	2025-01-09 23:07:00+00	2025-02-16 22:33:00+00	PESCA	\N
b276c18a-ec6b-4faa-be69-733a4f800d67	07da4ec3-6188-4928-8ef9-38c935b76fc8	1	6af901f6-bd7d-4bc7-8c9d-f441e526e65c	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-01-13 19:00:00+00	2025-02-24 09:48:00+00	PESCA	\N
8c9b2b58-41f8-441b-8ba4-b20fa8e6f3ed	cd7bd96e-6327-4749-8a87-3c2a7741a499	1	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-01-09 19:25:00+00	2025-02-02 21:30:00+00	PESCA	\N
d1118d1c-8424-4d62-a31e-0c15ad9a8da9	8b646927-5b1b-4602-9049-c6fbd485b45f	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-01-07 21:42:00+00	2025-01-28 06:45:00+00	PESCA	\N
daeeb4d2-2e6d-4943-aba8-4db16aa01a91	77532613-0fe8-4b42-b0bd-1ff846bc2f8a	1	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-03-24 00:00:00+00	2025-04-23 00:00:00+00	PESCA	\N
6ce8c535-95f4-4dd1-8bd4-cbe7cae7e1f3	a7064b43-b18d-4eb5-9651-6ffe9132095a	1	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-03-28 00:00:00+00	2025-05-05 00:00:00+00	PESCA	\N
d8f76701-0a4d-4dde-b78d-b16d1bf86a06	821e19a4-9b0c-4ff3-814c-f30c8e211731	1	e16a6ea7-08d9-4891-b3ab-3ac866d647c2	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-03-11 17:05:00+00	2025-03-16 03:13:00+00	PESCA	\N
713dcd9c-0699-41bc-bded-6ca8bb2448c0	821e19a4-9b0c-4ff3-814c-f30c8e211731	2	e16a6ea7-08d9-4891-b3ab-3ac866d647c2	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-03-19 19:40:00+00	2025-03-28 11:35:00+00	PESCA	\N
402672a5-c24f-4205-91f3-036b4e73f561	fcb1937e-02c8-4b8a-ac45-5560fd9e2306	1	e16a6ea7-08d9-4891-b3ab-3ac866d647c2	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-03-11 16:15:00+00	2025-03-18 19:00:00+00	PESCA	\N
b0edcf94-f36a-4c0c-8c11-c707f07bede2	fcb1937e-02c8-4b8a-ac45-5560fd9e2306	2	e16a6ea7-08d9-4891-b3ab-3ac866d647c2	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-03-21 20:52:00+00	2025-03-28 17:49:00+00	PESCA	\N
9b6928ae-200a-40c9-a1cc-532bf05f0390	560dfca7-b22c-41c9-bab7-5b421398e1df	1	6af901f6-bd7d-4bc7-8c9d-f441e526e65c	\N	\N	2025-02-21 18:09:00+00	2025-04-02 08:19:00+00	PESCA	\N
d773679b-2048-4e66-96e8-b8f5ee6b9f0e	35b15911-3cdd-471d-9cd5-d18c28087ed4	1	6af901f6-bd7d-4bc7-8c9d-f441e526e65c	\N	\N	2025-04-16 00:00:00+00	2025-05-16 00:00:00+00	PESCA	\N
4765c380-f97d-4511-9f8b-a45e978405c9	e9928820-e2c0-4aec-8909-e283ad16b46c	1	6af901f6-bd7d-4bc7-8c9d-f441e526e65c	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-04-17 17:00:00+00	2025-05-27 15:20:00+00	PESCA	\N
4a3fb61e-750f-486e-9927-c2cb801a9013	69c9cad2-be9a-4d93-b729-5451a19af823	1	92d9acc2-3590-474f-a773-73e8af728e83	f41ff939-bc00-4bbd-8ce8-c451922ba284	f41ff939-bc00-4bbd-8ce8-c451922ba284	2025-04-01 00:00:00+00	2025-04-27 00:00:00+00	PESCA	\N
3a2a2dfb-12f7-4377-bebc-bb6dbb9a689e	42432120-cdf2-4ddc-be23-8294bb6aa44e	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	105b0349-a9ed-49bf-9336-aad8d3867f0b	105b0349-a9ed-49bf-9336-aad8d3867f0b	2025-02-04 12:54:00+00	2025-03-10 13:19:00+00	PESCA	\N
be6f853a-a30e-41c8-9121-74499b296491	5787dd21-a869-457f-a731-9cd5a2092f2f	1	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-04-23 00:00:00+00	2025-05-14 00:00:00+00	PESCA	\N
0db8dad1-f13e-40b2-87aa-94a09eb37efd	dc63e6ad-2b5c-4a7a-8bbc-b505417a579a	1	92d9acc2-3590-474f-a773-73e8af728e83	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-04-18 00:00:00+00	2025-05-19 00:00:00+00	PESCA	\N
dfdb0f5c-99cc-4826-a895-f6343d423402	b8ff18cb-c296-41a9-957f-adc0e551ffe9	1	92d9acc2-3590-474f-a773-73e8af728e83	f41ff939-bc00-4bbd-8ce8-c451922ba284	f41ff939-bc00-4bbd-8ce8-c451922ba284	2025-04-29 17:20:00+00	2025-06-02 19:10:00+00	PESCA	\N
2a149435-b1b8-4ae4-a2f1-11aa25816118	56ecf6ac-ea06-442b-a2e3-17055769c9fd	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-04-29 21:15:00+00	2025-05-15 14:45:00+00	PESCA	\N
5f9d5afd-dd91-457e-a60a-fe14e5937a6b	dff305d8-d504-49aa-ab9c-7e9e1312bd1b	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-04-30 15:15:00+00	2025-06-16 18:05:00+00	PESCA	\N
2d0d9d35-cfb7-4771-8ad7-919d6dcee40b	6ec3d107-e1c8-46c5-baa5-cf1cad837a19	1	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-04-30 18:47:00+00	2025-06-05 07:50:00+00	PESCA	\N
9f44c5da-29fc-4906-8fa6-10e5728933d8	b14f6463-136d-4587-adfa-3b4619b0b8e2	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-05-04 00:20:00+00	2025-06-03 17:48:00+00	PESCA	\N
72d8990f-c459-438b-a4fa-8762d729d53b	2915796f-f22a-4947-8d55-ae6b613e68fd	1	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-05-07 13:55:00+00	2025-06-09 16:02:00+00	PESCA	\N
8b4689cd-0124-42ec-9819-0e8750927c8a	9068cc0b-d9c6-4368-bd9b-16f58da6c34f	1	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-05-07 14:55:00+00	2025-06-10 11:07:00+00	PESCA	\N
4c32c3b5-f822-4f3e-80eb-65b6327ace1c	69b3ac7a-3942-4dfa-a91c-0d8aa99eda98	1	92d9acc2-3590-474f-a773-73e8af728e83	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-05-08 16:25:00+00	2025-06-17 04:30:00+00	PESCA	\N
50169b4a-dff5-4dad-902e-37317c3d99c3	6594b694-a981-4ed1-8b72-83f6096bc71e	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-05-02 15:10:00+00	2025-05-10 05:18:00+00	PESCA	\N
5c04671f-72a1-4b83-b28f-a878e0f7a8e7	6594b694-a981-4ed1-8b72-83f6096bc71e	2	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-05-12 16:12:00+00	2025-05-21 09:23:00+00	PESCA	\N
a6517174-3baf-4723-aa2e-cf360ce427c9	b24cff8b-4a57-4f85-8498-6ae2e97bab5b	1	e16a6ea7-08d9-4891-b3ab-3ac866d647c2	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-03-11 20:36:00+00	2025-03-20 21:33:00+00	PESCA	\N
214473bd-2ffe-4bb9-a44c-24270dd50e8e	b24cff8b-4a57-4f85-8498-6ae2e97bab5b	2	e16a6ea7-08d9-4891-b3ab-3ac866d647c2	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-03-22 18:55:00+00	2025-03-27 21:00:00+00	PESCA	\N
66355cf3-7bc5-4ce6-ab73-3f409915e9a3	2d6a680f-efb4-43fa-99fc-7c29b5170260	1	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	f41ff939-bc00-4bbd-8ce8-c451922ba284	f41ff939-bc00-4bbd-8ce8-c451922ba284	2025-01-29 05:23:00+00	2025-02-23 20:15:00+00	PESCA	\N
c2226138-e27e-45dd-b9ae-00151569fd2b	2d6a680f-efb4-43fa-99fc-7c29b5170260	2	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	f41ff939-bc00-4bbd-8ce8-c451922ba284	f41ff939-bc00-4bbd-8ce8-c451922ba284	2025-02-25 19:00:00+00	2025-04-06 17:20:00+00	PESCA	\N
d5d01336-c52e-4b35-bb38-6085b76065dd	f5a5762b-184c-4534-82ae-fa407a1c970b	1	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-05-15 10:47:00+00	2025-05-27 12:47:00+00	PESCA	\N
2c781bc0-f6b8-49cb-9d31-ed17fdbff040	4cb75125-40df-42e6-9d4d-81112eddb56b	1	4167beb8-ce39-4fd3-8314-8b3487879d92	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-05-11 07:00:00+00	2025-05-18 10:25:00+00	PESCA	\N
e13bb06f-ed9d-4920-a37e-41503fbf62ab	d15515d9-a8e4-414e-b3cb-f2a7e77f9da4	1	6af901f6-bd7d-4bc7-8c9d-f441e526e65c	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-04-22 17:42:00+00	2025-06-06 07:51:00+00	PESCA	\N
5cb0596b-babd-47a1-8332-e1254efdabba	701fcc04-0fb7-411b-9b2e-67f8e48bccba	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-04-26 11:30:00+00	2025-05-04 14:35:00+00	PESCA	\N
b7af67b5-f1d2-4e7f-9c4b-3e9dc3e4589c	701fcc04-0fb7-411b-9b2e-67f8e48bccba	2	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-05-06 19:50:00+00	2025-05-15 08:48:00+00	PESCA	\N
d0ccc13b-d526-498c-a994-92b224020610	701fcc04-0fb7-411b-9b2e-67f8e48bccba	3	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-05-17 12:29:00+00	2025-05-27 12:46:00+00	PESCA	\N
3915dec0-3d24-4794-9991-1a999de529ed	c7f2727f-b7d2-4f05-b7e7-2a715d90a560	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-05-17 15:42:00+00	2025-07-13 10:03:00+00	PESCA	\N
27a7d1fb-2796-4073-bb18-227ddd77decd	013a62c5-d08a-41db-b8d8-a2733f29d13e	1	92d9acc2-3590-474f-a773-73e8af728e83	f41ff939-bc00-4bbd-8ce8-c451922ba284	f41ff939-bc00-4bbd-8ce8-c451922ba284	2025-01-04 21:00:00+00	2025-01-28 15:40:00+00	PESCA	\N
5e4088c3-8697-4754-a88a-646f9c393b54	3d688d09-cdae-4b40-9b23-3fc49fb71f05	2	92d9acc2-3590-474f-a773-73e8af728e83	f41ff939-bc00-4bbd-8ce8-c451922ba284	f41ff939-bc00-4bbd-8ce8-c451922ba284	2025-02-01 01:00:00+00	2025-02-22 21:00:00+00	PESCA	\N
e0bedf20-6472-4cc1-a644-e76f96cb969f	e826e24f-56fd-4258-9d1d-830e442aa085	1	e16a6ea7-08d9-4891-b3ab-3ac866d647c2	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-03-12 11:32:00+00	2025-03-15 06:20:00+00	PESCA	\N
e6ad28ab-9e7c-4920-8bff-ec5a55d44945	e826e24f-56fd-4258-9d1d-830e442aa085	2	e16a6ea7-08d9-4891-b3ab-3ac866d647c2	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-03-15 20:55:00+00	2025-03-17 12:57:00+00	PESCA	\N
c88686ab-6f92-412c-949f-6cc89dfb23b2	e826e24f-56fd-4258-9d1d-830e442aa085	3	e16a6ea7-08d9-4891-b3ab-3ac866d647c2	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-03-18 21:05:00+00	2025-03-29 11:00:00+00	PESCA	\N
e085d56e-f898-4bb3-ae58-a8cceb079a5a	00d390a4-c119-47a8-9284-94044f94f718	1	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-01-31 17:45:00+00	2025-03-03 13:00:00+00	PESCA	\N
5fbed664-aa1e-4708-a95f-42162110159e	00d390a4-c119-47a8-9284-94044f94f718	2	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-03-07 19:05:00+00	2025-03-14 21:00:00+00	PESCA	\N
371462cb-e07f-46f7-8de0-03fb454773ba	695ea99f-bce2-4c73-a9a6-bdf16c8bd89e	2	c1692b3c-2c33-4957-8bcb-208f45e4534b	105b0349-a9ed-49bf-9336-aad8d3867f0b	105b0349-a9ed-49bf-9336-aad8d3867f0b	2025-03-19 17:40:00+00	2025-04-23 19:50:00+00	PESCA	\N
551c949b-1d8e-4f9a-8781-ce4f224e74bb	489e836e-493f-492c-b15e-791e08a03b56	1	e16a6ea7-08d9-4891-b3ab-3ac866d647c2	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-03-07 16:05:00+00	2025-03-12 23:35:00+00	PESCA	\N
11881c29-daa2-41d0-9218-df11b794e04e	489e836e-493f-492c-b15e-791e08a03b56	2	e16a6ea7-08d9-4891-b3ab-3ac866d647c2	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-03-15 13:38:00+00	2025-03-18 17:35:00+00	PESCA	\N
d4809ae7-0cc7-465b-85f0-179988b4e653	ebaae4a6-4500-4ddc-b454-5263f261f9fe	1	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-04-09 22:00:00+00	2025-04-28 10:22:00+00	PESCA	\N
e71594b6-fb7d-4761-a69a-c682480b5edc	7b044b8b-18b1-49a3-a4d7-22c5813826f2	1	6af901f6-bd7d-4bc7-8c9d-f441e526e65c	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-05-07 17:05:00+00	2025-06-10 17:15:00+00	PESCA	\N
017a620c-518f-4005-a465-23fb4713f5c7	ff020898-60fd-40ba-af9f-a7affe0156a7	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-04-30 11:25:00+00	2025-04-30 13:20:00+00	PESCA	\N
360fe31d-6cdf-403c-9efd-9020553dc823	d874ece1-ce8c-4624-a07e-59eb94fc594a	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	105b0349-a9ed-49bf-9336-aad8d3867f0b	105b0349-a9ed-49bf-9336-aad8d3867f0b	2025-04-27 07:55:00+00	2025-05-31 08:19:00+00	PESCA	\N
73347df4-907f-4bf7-91a1-9ba944ce12c9	bb642f3e-1917-4044-86ff-f1dcbc9084e9	1	92d9acc2-3590-474f-a773-73e8af728e83	b8a55941-9f65-4e90-bea1-3683753d42b5	b8a55941-9f65-4e90-bea1-3683753d42b5	2025-04-09 00:00:00+00	2025-05-20 00:00:00+00	PESCA	\N
39a3943b-c67a-424d-88d7-42034ffef3eb	50b60f7e-00d1-4145-9fdc-64c07172ee12	1	6af901f6-bd7d-4bc7-8c9d-f441e526e65c	\N	\N	2025-04-08 00:00:00+00	2025-05-17 00:00:00+00	PESCA	\N
0081709c-149f-4a67-a783-0c61e8c82163	405d0b35-56d8-422f-b91d-8c045bb687ca	1	6af901f6-bd7d-4bc7-8c9d-f441e526e65c	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-03-28 00:00:00+00	2025-04-30 00:00:00+00	PESCA	\N
9e767155-0a8a-4e72-affc-c50dad7e1d35	ebaae4a6-4500-4ddc-b454-5263f261f9fe	2	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-04-28 19:15:00+00	2025-04-30 21:00:00+00	PESCA	\N
2462236f-6b08-4d3b-bb29-086435afd73b	25b9b21f-09c5-4718-ba3f-331e95f8aa76	1	92d9acc2-3590-474f-a773-73e8af728e83	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-05-22 05:10:00+00	2025-06-21 07:50:00+00	PESCA	\N
198963e2-9aa8-407c-93de-0a5804dea861	5498f43f-ffb6-4450-9601-bde3b96de204	1	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-05-22 11:32:00+00	2025-06-05 08:10:00+00	PESCA	\N
4059acfe-e1c2-4871-9d8f-b44f61a8cea3	a8ad916d-6023-4251-8f93-85dacb93b4a8	1	4167beb8-ce39-4fd3-8314-8b3487879d92	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-05-22 15:40:00+00	2025-06-17 07:33:00+00	PESCA	\N
406e2f23-d3e2-402c-9fb9-45b062f76da6	a6e8461f-7350-4b53-9756-d9357d73e14b	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-08-14 17:45:00+00	2025-08-22 19:10:00+00	PESCA	\N
12913242-e715-43d3-b9a1-43c1f53eb956	a6e8461f-7350-4b53-9756-d9357d73e14b	2	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-08-26 19:51:00+00	2025-09-05 06:11:00+00	PESCA	\N
305fc3cb-1b9e-44d4-87ab-8dff3e227698	a6e8461f-7350-4b53-9756-d9357d73e14b	3	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-09-09 15:00:00+00	2025-09-09 18:40:00+00	PESCA	\N
34de85ce-2fa2-4223-be6b-5430857685d2	a6e8461f-7350-4b53-9756-d9357d73e14b	4	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-09-13 17:47:00+00	2025-09-23 04:49:00+00	PESCA	\N
e3ecc584-ce01-4a57-b4e3-f4e59f12a5e6	d0cb9716-56c4-416c-b79c-23196280035b	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-09-11 09:33:00+00	2025-10-18 06:53:00+00	PESCA	\N
64ce89e2-276a-4abd-a428-4b17b42d373c	0bca43f5-41fc-4b81-9025-f74859d6c782	1	4167beb8-ce39-4fd3-8314-8b3487879d92	\N	\N	2025-09-13 18:00:00+00	2025-09-22 15:30:00+00	PESCA	\N
0ee8cf7e-7438-441f-94a8-90d7e0c05e94	0bca43f5-41fc-4b81-9025-f74859d6c782	2	4167beb8-ce39-4fd3-8314-8b3487879d92	\N	\N	2025-09-23 18:15:00+00	2025-10-12 10:20:00+00	PESCA	\N
44bebf19-e027-4467-b703-2178bbfa985c	9105353f-4e21-4492-95ad-d7cc91f10215	1	92d9acc2-3590-474f-a773-73e8af728e83	b8a55941-9f65-4e90-bea1-3683753d42b5	b8a55941-9f65-4e90-bea1-3683753d42b5	2025-09-17 16:55:00+00	2025-11-17 20:50:00+00	PESCA	\N
a598d20a-30d2-4892-98b4-ece761bc7a3e	697c7010-7044-4595-8ef7-3d80fb9937bd	1	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-10-14 15:40:00+00	2025-10-30 07:30:00+00	PESCA	\N
5e3c1af6-5370-42a8-a65b-f5caf4f85e03	0aee1677-c774-4d72-ba7a-b34f18f8c0c3	2	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-10-17 10:30:00+00	2025-11-06 07:50:00+00	PESCA	\N
09ef8740-069c-4ae8-9221-20f9eaf4ef34	9252e17a-595d-4d52-85e5-764edb3d103a	1	92d9acc2-3590-474f-a773-73e8af728e83	f41ff939-bc00-4bbd-8ce8-c451922ba284	f41ff939-bc00-4bbd-8ce8-c451922ba284	2025-09-30 15:15:00+00	2025-10-19 19:35:00+00	PESCA	\N
890aa12e-5a77-4f46-a89c-a327673e5b9f	9252e17a-595d-4d52-85e5-764edb3d103a	2	92d9acc2-3590-474f-a773-73e8af728e83	f41ff939-bc00-4bbd-8ce8-c451922ba284	f41ff939-bc00-4bbd-8ce8-c451922ba284	2025-10-22 19:30:00+00	2025-11-01 16:20:00+00	PESCA	\N
0423a219-59b3-4248-a5a6-85283c937f5f	22a69311-5dca-450d-8c8d-1b8ea3973f6d	1	6af901f6-bd7d-4bc7-8c9d-f441e526e65c	\N	\N	2025-10-27 16:46:00+00	2025-12-07 09:47:00+00	PESCA	\N
9c36d0bc-1841-41d7-b1aa-e49eef323747	32bfea20-71c1-4832-9f5f-09b9a0ee1edc	1	92d9acc2-3590-474f-a773-73e8af728e83	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-10-30 08:05:00+00	2025-11-19 07:17:00+00	PESCA	\N
95c3daa3-0c7d-4439-a1bb-7d89461857ff	452fb368-0ab5-4625-942f-fd1264bd805f	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-11-01 16:32:00+00	2025-11-12 08:22:00+00	PESCA	\N
7ff44655-c942-43ac-856a-991739871cf2	e280195a-928b-41e3-bf05-d6560363e6ff	1	822d18e6-569a-40fc-a58f-429b6bef4613	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-11-04 20:21:00+00	2025-11-11 06:35:00+00	PESCA	\N
1fbf6e80-8fe6-44e9-9835-e7119b5d6be8	30ea49cf-d1d9-4168-ad83-26baf57805a1	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-11-03 20:30:00+00	2025-11-12 02:10:00+00	PESCA	\N
60d3f504-9ec1-429a-a0b7-53c138500452	30ea49cf-d1d9-4168-ad83-26baf57805a1	2	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-11-14 13:44:00+00	2025-11-21 13:31:00+00	PESCA	\N
43693d89-7880-4045-94b1-461490f83fff	30ea49cf-d1d9-4168-ad83-26baf57805a1	3	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-11-23 12:45:00+00	2025-12-01 16:12:00+00	PESCA	\N
4240ada1-a6ce-43d6-a4b4-ae91c19f4a21	30ea49cf-d1d9-4168-ad83-26baf57805a1	4	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-12-03 19:20:00+00	2025-12-11 15:30:00+00	PESCA	\N
400ea0d0-29de-43ff-85df-23b5aa987cf2	3c89fd49-ceb1-4a86-9ef4-7faa79581dd2	1	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-11-07 00:00:00+00	2025-11-25 00:00:00+00	PESCA	\N
63768e48-7ab1-4072-91b8-e67a033f28ee	3c89fd49-ceb1-4a86-9ef4-7faa79581dd2	2	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-11-28 21:20:00+00	2025-12-21 23:30:00+00	PESCA	\N
ae509bf9-440d-4b12-951b-46e2cd5c6742	d704c984-c420-4bd1-8786-9fdcd168393d	1	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-10-12 01:35:00+00	2025-10-14 19:05:00+00	PESCA	\N
27be0445-53a8-46b6-adf2-0f528e52f4b9	d704c984-c420-4bd1-8786-9fdcd168393d	2	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-10-16 19:51:00+00	2025-11-12 21:40:00+00	PESCA	\N
1bb92cf4-9611-4569-8939-5e72e665c705	d704c984-c420-4bd1-8786-9fdcd168393d	3	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-11-14 15:40:00+00	2025-12-05 06:24:00+00	PESCA	\N
346c8e17-3996-4add-96df-b7e68098e370	34f92e6a-e85f-4672-81a3-43c14cb41220	1	92d9acc2-3590-474f-a773-73e8af728e83	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-09-29 22:30:00+00	2025-10-03 01:53:00+00	PESCA	\N
6b895c44-2275-4cbc-8ac6-c244d8a14fb6	34f92e6a-e85f-4672-81a3-43c14cb41220	2	92d9acc2-3590-474f-a773-73e8af728e83	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-10-05 21:16:00+00	2025-10-29 03:30:00+00	PESCA	\N
beafaefe-b2e6-4b90-82ad-6688d26e9f6e	bac274c6-39f7-41f2-b344-f5938ea8d9a4	2	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-10-13 21:15:00+00	2025-11-08 07:50:00+00	PESCA	\N
01f7d9ff-3318-47b0-9865-dc14e66411cb	3e6c3a44-c73f-428f-bc15-02cb35b6f777	1	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-10-23 14:05:00+00	2025-11-24 09:40:00+00	PESCA	\N
0ccfce51-a4b0-4bcb-a0c3-c4d26f1c876f	98ef92a3-2704-4829-8b08-05e9a4988ae6	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-10-19 11:02:00+00	2025-10-23 19:27:00+00	PESCA	\N
269beefb-8d28-4de8-a2e8-f90b73c7e9a5	98ef92a3-2704-4829-8b08-05e9a4988ae6	2	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-10-24 19:42:00+00	2025-10-29 14:00:00+00	PESCA	\N
c3d75bb4-7530-4311-a3fb-9c361d01c2eb	98ef92a3-2704-4829-8b08-05e9a4988ae6	3	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-11-03 12:10:00+00	2025-11-08 20:15:00+00	PESCA	\N
d23a59f3-b027-49cd-88fa-8824aa558d0b	776de334-8e34-4d8e-b65c-5cca453a5102	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-09-30 20:58:00+00	2025-10-05 21:00:00+00	PESCA	\N
0705abfa-36af-4bef-9b8c-0ab67e9921a0	776de334-8e34-4d8e-b65c-5cca453a5102	2	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-10-07 19:50:00+00	2025-10-12 09:18:00+00	PESCA	\N
113def7b-f1f1-4426-8b6a-edcccab17437	776de334-8e34-4d8e-b65c-5cca453a5102	3	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-10-14 12:55:00+00	2025-10-18 07:24:00+00	PESCA	\N
5abcce0d-05ee-4243-99b9-e4580525514b	776de334-8e34-4d8e-b65c-5cca453a5102	4	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-10-20 06:22:00+00	2025-10-24 19:43:00+00	PESCA	\N
5d150f36-a8d8-4e23-bbad-0b6957cc179d	3ff7e132-327c-481a-9a91-4e2ed0c0f71a	1	4167beb8-ce39-4fd3-8314-8b3487879d92	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-09-20 15:40:00+00	2025-10-07 06:28:00+00	PESCA	\N
69e36060-ff59-496c-8832-251a19c9dc49	d824ca87-7e34-4b92-a1ee-7c3ba9098bd4	1	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-09-13 19:00:00+00	2025-10-01 00:00:00+00	PESCA	\N
ef174a40-c54a-4c8d-8387-a0c655d2e4ea	a10109a2-0eeb-4ba5-8ac5-d721b1c63b4b	1	6af901f6-bd7d-4bc7-8c9d-f441e526e65c	\N	\N	2025-09-10 23:05:00+00	2025-09-22 09:53:00+00	PESCA	\N
e8fe567a-684f-45b8-ba1f-6c0a7d6a2fac	a10109a2-0eeb-4ba5-8ac5-d721b1c63b4b	2	6af901f6-bd7d-4bc7-8c9d-f441e526e65c	\N	\N	2025-09-22 19:33:00+00	2025-10-20 18:20:00+00	PESCA	\N
e58d51f3-16b9-4d48-bdfc-9daf4ccb3c49	ab45e4db-3e59-4a57-b42b-622339466b8a	1	4167beb8-ce39-4fd3-8314-8b3487879d92	\N	\N	2025-08-26 00:00:00+00	2025-09-07 00:00:00+00	PESCA	\N
6f1d3af1-d77e-4efa-967e-dfde8ee10fdd	730ea452-6c88-4649-b661-14a8e90df97f	1	4167beb8-ce39-4fd3-8314-8b3487879d92	\N	\N	2025-07-23 20:10:00+00	2025-08-09 23:30:00+00	PESCA	\N
cdb679a4-7e08-4cd3-8f5c-950294e8b116	730ea452-6c88-4649-b661-14a8e90df97f	2	4167beb8-ce39-4fd3-8314-8b3487879d92	\N	\N	2025-08-11 22:53:00+00	2025-08-24 07:16:00+00	PESCA	\N
d98d388a-10a5-4875-bd6a-af39cd1e1361	730ea452-6c88-4649-b661-14a8e90df97f	3	4167beb8-ce39-4fd3-8314-8b3487879d92	\N	\N	2025-08-25 19:00:00+00	2025-09-07 08:45:00+00	PESCA	\N
eab5cf6d-e350-45d5-9b2b-60bd1d078e63	730ea452-6c88-4649-b661-14a8e90df97f	4	4167beb8-ce39-4fd3-8314-8b3487879d92	\N	\N	2025-09-08 20:20:00+00	2025-09-25 10:34:00+00	PESCA	\N
8359e42e-f983-48db-a768-e4c6fb804770	764b2c49-7743-475a-82b3-2742d44f1511	1	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-04-12 11:10:00+00	2025-05-08 08:45:00+00	PESCA	\N
8e4e1e60-6289-47e9-8aba-73793dc72ba8	764b2c49-7743-475a-82b3-2742d44f1511	2	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-05-08 16:51:00+00	2025-05-12 21:00:00+00	PESCA	\N
ddecce4f-dfc6-4003-af51-f6b1dd5c1036	84bb51d2-bc04-48fc-82e0-eefcb3d6181c	2	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-10-14 16:17:00+00	2025-11-02 02:25:00+00	PESCA	\N
d957eea0-92ad-47cc-a36c-f7648b629880	84bb51d2-bc04-48fc-82e0-eefcb3d6181c	3	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-11-05 23:13:00+00	2025-12-04 11:51:00+00	PESCA	\N
d8f15acc-b2fe-4fb0-9015-8031cafb2c7f	4608c6ff-2a5c-4376-aab0-2ecc5ad57077	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-10-14 18:50:00+00	2025-11-23 08:22:00+00	PESCA	\N
502e09d9-a9f8-48e1-8fe1-c664a4cb5b07	af99bccf-1c39-4b7f-9e32-5cca1f6ab9e4	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-11-04 00:00:00+00	2025-11-12 09:25:00+00	PESCA	\N
cb49912f-2823-4ba2-b0f8-51d1755ef95e	af99bccf-1c39-4b7f-9e32-5cca1f6ab9e4	2	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-11-14 12:40:00+00	2025-11-18 21:54:00+00	PESCA	\N
48e9acff-4f51-4b91-957b-bfa38e0f4a96	e5ad3f4d-53e3-4908-806a-a276d6a30231	1	92d9acc2-3590-474f-a773-73e8af728e83	b8a55941-9f65-4e90-bea1-3683753d42b5	b8a55941-9f65-4e90-bea1-3683753d42b5	2025-05-22 19:05:00+00	2025-07-10 14:40:00+00	PESCA	\N
006c239a-f47d-4fab-a90f-57bd1b0242a5	807cc3de-3f61-4a67-827d-ef08f116871a	2	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	105b0349-a9ed-49bf-9336-aad8d3867f0b	105b0349-a9ed-49bf-9336-aad8d3867f0b	2025-04-16 00:30:00+00	2025-05-27 08:09:00+00	PESCA	\N
3295986d-0bed-488f-8331-99d9c89545bc	7c781ec3-673c-40aa-adf2-d61ca9fb92d7	1	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-04-26 13:42:00+00	2025-05-28 14:11:00+00	PESCA	\N
fc923200-0015-4fb7-b17e-70cd6b6b15b2	8b8bdb40-0d08-458c-bb0f-645104fbf0ca	1	6af901f6-bd7d-4bc7-8c9d-f441e526e65c	\N	\N	2025-05-28 11:51:00+00	2025-07-12 12:17:00+00	PESCA	\N
3e593a53-68ea-43f6-b405-516d6278a610	52f9cd5e-ed40-455e-916b-595a04235bd9	1	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-05-31 12:41:00+00	2025-06-07 00:00:00+00	PESCA	\N
ae1a83c1-7500-42cd-b136-1fa33a192b76	46d84b6c-c194-454b-af6c-bab2d401622b	1	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-03-13 14:45:00+00	2025-04-14 10:20:00+00	PESCA	\N
8bbdf56c-c9c1-45b0-88fe-319b78e4d000	46d84b6c-c194-454b-af6c-bab2d401622b	2	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-04-16 15:00:00+00	2025-04-23 09:45:00+00	PESCA	\N
ff72bdbf-74c5-4474-8c88-fde82106b88a	46d84b6c-c194-454b-af6c-bab2d401622b	3	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-04-23 17:05:00+00	2025-04-28 16:05:00+00	PESCA	\N
2c8c6356-72e8-4a06-ab21-84eeca03363c	64abcf64-5b1d-457d-a044-87a592c4323d	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-06-10 18:15:00+00	2025-06-17 02:25:00+00	PESCA	\N
ae2ace8a-4f5a-4f31-ab65-9dd1e35dbaa7	64abcf64-5b1d-457d-a044-87a592c4323d	2	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-06-19 14:09:00+00	2025-06-22 14:56:00+00	PESCA	\N
fde3b358-b456-4ce1-a786-2480f49f0cde	64abcf64-5b1d-457d-a044-87a592c4323d	3	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-06-28 12:06:00+00	2025-07-04 14:16:00+00	PESCA	\N
1b150d1b-d505-4bd9-8f98-44538bdc0fa9	64abcf64-5b1d-457d-a044-87a592c4323d	4	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-07-06 17:05:00+00	2025-07-10 07:59:00+00	PESCA	\N
40f20d27-2bab-4abe-9ab0-75a570ba3892	64abcf64-5b1d-457d-a044-87a592c4323d	5	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-07-12 12:25:00+00	2025-07-16 11:05:00+00	PESCA	\N
166a77cb-2501-472d-ac53-446a12f0467f	930ca829-af44-4e25-93e3-2858fcf9e61e	1	4167beb8-ce39-4fd3-8314-8b3487879d92	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-04-12 17:09:00+00	2025-04-20 01:00:00+00	PESCA	\N
9920aa0c-ab66-4e93-aca3-d134652143e7	930ca829-af44-4e25-93e3-2858fcf9e61e	2	4167beb8-ce39-4fd3-8314-8b3487879d92	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-04-21 16:20:00+00	2025-05-01 08:40:00+00	PESCA	\N
35c5bf18-bf10-4803-bb93-1e07d68f8cae	930ca829-af44-4e25-93e3-2858fcf9e61e	3	4167beb8-ce39-4fd3-8314-8b3487879d92	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-05-02 13:20:00+00	2025-05-10 00:00:00+00	PESCA	\N
4b2b2c68-3a4d-4883-9134-7a342f904b9c	11d7815a-a230-48c3-8d76-aa0dc52c6f32	1	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2024-12-29 06:27:00+00	2025-02-04 03:00:00+00	PESCA	\N
793d0408-d56d-4cc3-8bdd-c4c9cdabe15b	11d7815a-a230-48c3-8d76-aa0dc52c6f32	2	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-02-06 19:45:00+00	2025-03-11 12:42:00+00	PESCA	\N
19ffd329-d528-4bd4-89e8-e90639cfaa7b	a986aa1a-1569-45e8-b1c0-4305e1dbc9b5	1	4167beb8-ce39-4fd3-8314-8b3487879d92	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-06-18 18:35:00+00	2025-06-25 15:55:00+00	PESCA	\N
5553497e-5ff8-475a-b9bc-b51f72ad9ce7	a986aa1a-1569-45e8-b1c0-4305e1dbc9b5	2	4167beb8-ce39-4fd3-8314-8b3487879d92	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-07-04 13:45:00+00	2025-07-09 18:00:00+00	PESCA	\N
9c7ec074-376f-4a7f-b4b1-9e11533c4cbd	1b071f3e-4ad2-438e-9b14-0a5a3f5256f9	1	4167beb8-ce39-4fd3-8314-8b3487879d92	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-06-18 22:31:00+00	2025-06-25 15:24:00+00	PESCA	\N
0092d2c7-02a4-40b0-8dd5-e1a71838490b	22b5f131-5ae2-424b-a904-515b396c9704	1	4167beb8-ce39-4fd3-8314-8b3487879d92	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-06-19 00:04:00+00	2025-06-25 15:03:00+00	PESCA	\N
11ffe006-c5be-4494-9955-770b0b26b81d	63232f8c-edf4-4fb1-8605-185b46f08cc0	1	92d9acc2-3590-474f-a773-73e8af728e83	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-06-19 10:10:00+00	2025-07-02 09:55:00+00	PESCA	\N
e173ed5a-0798-4b92-98cb-6a6de7a254dd	af99bccf-1c39-4b7f-9e32-5cca1f6ab9e4	3	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-11-22 11:28:00+00	2025-11-27 21:06:00+00	PESCA	\N
dbb4a29b-597a-48b4-acd9-f77fbb01a0a7	af99bccf-1c39-4b7f-9e32-5cca1f6ab9e4	4	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-11-30 11:19:00+00	2025-12-06 19:45:00+00	PESCA	\N
d6818ba3-b30a-4b47-8385-eef075b28f9a	1e7c7bf8-eadb-4129-97aa-6a8aa0382b8e	1	92d9acc2-3590-474f-a773-73e8af728e83	b8a55941-9f65-4e90-bea1-3683753d42b5	b8a55941-9f65-4e90-bea1-3683753d42b5	2025-11-22 00:30:00+00	2026-01-12 20:00:00+00	PESCA	\N
3fc0bcf6-9d69-4a90-ad87-99a42ff6b2ef	1c0090cb-f67a-4eae-a1e8-c27f179a2ef0	1	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-11-26 20:00:00+00	2026-01-04 19:00:00+00	PESCA	\N
12247394-bf5c-4d0f-a65a-48084bfc8eaf	4bd07a16-56ce-4045-b817-946f150adb44	1	92d9acc2-3590-474f-a773-73e8af728e83	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-11-27 22:30:00+00	\N	PESCA	\N
297dbf53-37f1-4688-92db-2f87b3052473	4907e1c7-7fb0-435e-bf14-91e735744633	1	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-01-11 07:45:00+00	2025-01-11 21:06:00+00	PESCA	\N
4f381739-3709-4420-b8d4-96501f4c317a	4907e1c7-7fb0-435e-bf14-91e735744633	2	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-01-14 09:52:00+00	2025-01-15 00:06:00+00	PESCA	\N
36c26d5a-0182-4a78-bf38-e9e322803cee	4907e1c7-7fb0-435e-bf14-91e735744633	3	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-01-15 14:25:00+00	2025-01-16 12:12:00+00	PESCA	\N
7a0b9f00-6169-4448-8708-717a29f1b25b	4907e1c7-7fb0-435e-bf14-91e735744633	4	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-01-17 00:12:00+00	2025-01-17 12:48:00+00	PESCA	\N
550417d8-5d67-4137-bce5-2412975abd6f	4907e1c7-7fb0-435e-bf14-91e735744633	5	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-01-17 14:40:00+00	2025-01-19 14:18:00+00	PESCA	\N
bef02291-1304-4f39-8869-a08a4893b078	4907e1c7-7fb0-435e-bf14-91e735744633	6	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-02-02 13:35:00+00	2025-02-05 06:00:00+00	PESCA	\N
6e80a465-ee68-4d7d-9c81-0593e101e19f	4907e1c7-7fb0-435e-bf14-91e735744633	7	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-02-12 22:56:00+00	2025-02-15 00:35:00+00	PESCA	\N
2e767dcc-5441-486f-9556-dff42f3c630c	bb93f6d5-50a1-44e9-a1b1-ced70f7b44ae	1	6af901f6-bd7d-4bc7-8c9d-f441e526e65c	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-12-16 07:30:00+00	\N	PESCA	\N
ae91b92e-2fbf-469d-9169-9528030b8a62	7130be8a-57d0-4e14-b224-469ab59150d1	1	6af901f6-bd7d-4bc7-8c9d-f441e526e65c	\N	\N	2025-12-15 14:50:00+00	\N	PESCA	\N
8830948a-d724-4206-956d-402e53ed318e	c5f7c42f-2cb4-4bfc-8853-694ab027ceb1	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-12-02 20:03:00+00	2025-12-06 21:05:00+00	PESCA	\N
9ce5d4f5-9b1d-49f7-83ef-b4799b563f1a	c5f7c42f-2cb4-4bfc-8853-694ab027ceb1	2	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-12-09 13:01:00+00	2025-12-13 07:05:00+00	PESCA	\N
dcad3fb3-a595-4945-8602-e8292f728f1f	3ad14786-cabe-4acb-9f33-b24802773374	1	92d9acc2-3590-474f-a773-73e8af728e83	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2024-12-27 23:50:00+00	2025-02-17 04:35:00+00	PESCA	\N
adf71ed2-2804-450d-8380-809b72d429d6	e87b2a8d-35b5-4d8a-97c4-23f7950477b5	1	92d9acc2-3590-474f-a773-73e8af728e83	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2024-12-12 16:15:00+00	2025-01-02 00:00:00+00	PESCA	\N
41579fba-3a5c-4a56-ba3c-cf76f1455c4f	84674b0e-e4e3-427b-b62c-130db2a65be4	1	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-12-23 17:20:00+00	2025-12-27 14:10:00+00	PESCA	\N
21ecb4c7-8707-46a4-a365-4200d690ac39	84674b0e-e4e3-427b-b62c-130db2a65be4	2	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2026-01-01 18:30:00+00	\N	PESCA	\N
45bd1ade-9e0d-4a00-bc0f-40fac96c12cd	15a34aa8-8293-4969-ae18-ff41fb647a52	1	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	105b0349-a9ed-49bf-9336-aad8d3867f0b	105b0349-a9ed-49bf-9336-aad8d3867f0b	2025-12-29 13:00:00+00	\N	PESCA	\N
e69fc573-fe07-4701-951b-4afee2fad5b5	b1bbf611-cad8-49fe-abb5-5da8074b1b40	1	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-12-29 16:26:00+00	\N	PESCA	\N
a98c2e7d-b854-4bea-a8d5-0369ae9a3331	1f6c1163-1923-4533-856c-1cf7e106cd12	1	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-12-29 17:15:00+00	\N	PESCA	\N
1d4ce04e-8232-413c-a15c-29a4748f053b	3fc93ae9-f30a-40a4-810c-d5810780eb84	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	105b0349-a9ed-49bf-9336-aad8d3867f0b	105b0349-a9ed-49bf-9336-aad8d3867f0b	2025-06-05 18:42:00+00	2025-07-06 09:14:00+00	PESCA	\N
726bf448-374e-4f9e-a7d8-8a02a1ed7321	482edf1c-cf2d-48ed-9e89-a268b9f9829c	1	6af901f6-bd7d-4bc7-8c9d-f441e526e65c	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-05-31 20:30:00+00	2025-07-11 07:00:00+00	PESCA	\N
14824e26-7c66-42dd-92f4-439ba86f0b66	9eda1a8e-eba3-4a62-b9bd-be326506060e	1	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-12-29 18:35:00+00	2026-01-04 09:10:00+00	PESCA	\N
6bc23bf1-af6b-45a9-b3ce-81eb14f024b9	9eda1a8e-eba3-4a62-b9bd-be326506060e	2	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2026-01-06 17:43:00+00	\N	PESCA	\N
ade5fa80-52d3-43c6-8465-8171756dcee1	81597411-4e0a-49a7-8234-522f8b140369	1	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-12-29 19:02:00+00	2026-01-05 19:45:00+00	PESCA	\N
34d5c82f-6f17-4618-8e85-def6c94fa710	81597411-4e0a-49a7-8234-522f8b140369	2	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2026-01-06 18:50:00+00	\N	PESCA	\N
3ffa6b14-84d7-4ee0-9142-a42c890b0f06	78596501-cedf-4b64-bf27-5efac9aee7ef	1	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	f41ff939-bc00-4bbd-8ce8-c451922ba284	f41ff939-bc00-4bbd-8ce8-c451922ba284	2025-12-30 09:45:00+00	\N	PESCA	\N
ebaeb3d8-23a4-470d-84f5-c1cebe4d8318	58d653ae-6399-455f-b255-38a05b3b28a3	1	92d9acc2-3590-474f-a773-73e8af728e83	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-12-30 18:05:00+00	\N	PESCA	\N
1e0b0560-aaa4-4558-bd0f-7592a6e78f07	c01f8f0f-c212-4d56-83f2-c421e26acc0e	1	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	\N	\N	2025-12-29 00:00:00+00	\N	PESCA	\N
faf5fde5-3699-4d4b-a9f4-69364c501a32	cc550723-a07b-4a96-88ca-a49a4f00c859	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	105b0349-a9ed-49bf-9336-aad8d3867f0b	105b0349-a9ed-49bf-9336-aad8d3867f0b	\N	2026-01-14 16:15:00+00	PESCA	\N
60714a21-3197-4b82-8bc7-9e62f5b61b9f	638cf5c9-4b0b-48c7-98ec-2af423cdce18	1	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2026-01-06 18:15:00+00	\N	PESCA	\N
572724e9-3369-46f9-b7bb-8f9983a5190c	ad5cfd1d-aa79-4239-92fd-32342423ee9b	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2026-01-06 15:00:00+00	2026-01-12 18:19:00+00	PESCA	\N
c8ffc2d5-d6ac-435d-b36f-ae9d8438c90c	ad5cfd1d-aa79-4239-92fd-32342423ee9b	2	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2026-01-13 18:27:00+00	\N	PESCA	\N
84f1667b-d165-41ce-8efc-9c996a2efde0	b318ed5b-dc0b-49fb-9f37-e499358515a7	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2026-01-06 21:46:00+00	\N	PESCA	\N
79cf25eb-8ace-4796-8fb2-7969bd677691	83b11bd1-fa53-42e8-ae48-1636d8895333	1	6af901f6-bd7d-4bc7-8c9d-f441e526e65c	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2026-01-09 10:32:00+00	\N	PESCA	\N
fc9305ef-fb7c-45c4-a0a0-8e3c953797d7	b2122bed-a672-447d-8e23-541659de9239	1	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2026-01-06 19:50:00+00	\N	PESCA	\N
5ab117a8-561e-4ca1-b62a-594e33ec0da3	0e9185ba-8450-436a-aea1-1e20447d56f0	1	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-12-30 22:10:00+00	2026-01-15 17:03:00+00	PESCA	\N
36e6bc21-f75b-4b48-98d1-cd1ff0b78c18	a57f20ba-0fed-4e37-bc68-15add34d9f35	1	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-12-30 21:40:00+00	\N	PESCA	\N
6398295a-3de4-433d-a6cd-f75e57ad37af	c6661b7f-33c9-44f9-b1b4-3a7b70ec3f2f	1	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-12-30 22:40:00+00	\N	PESCA	\N
e01feba4-5abc-4334-a948-989d0342d106	6f5dddac-436f-4846-bf6d-2b34f7d2e046	1	92d9acc2-3590-474f-a773-73e8af728e83	f41ff939-bc00-4bbd-8ce8-c451922ba284	f41ff939-bc00-4bbd-8ce8-c451922ba284	2026-01-03 17:30:00+00	\N	PESCA	\N
c571aafd-26aa-4ad5-8a14-773232ac6cf9	6680accc-6af4-4d54-9e60-ae7a16f5d3ea	1	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	\N	\N	2025-12-29 00:00:00+00	\N	PESCA	\N
61af0d39-183c-42ae-bead-6a75b60dfc25	0ced05ba-d9e9-409f-b2e0-320f664db7fd	1	92d9acc2-3590-474f-a773-73e8af728e83	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2026-01-05 00:00:00+00	\N	PESCA	\N
4902872c-0ec8-4d88-965b-6b39eddabc0b	677da877-084d-4a80-b13a-602d61e4d25b	1	4167beb8-ce39-4fd3-8314-8b3487879d92	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-06-18 19:04:00+00	2025-06-25 15:02:00+00	PESCA	\N
f317759b-5a5c-40ae-9ea1-c5cd1bea98ac	0d04dd05-291e-44aa-9f34-4feb5feaae26	1	4167beb8-ce39-4fd3-8314-8b3487879d92	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-06-18 21:10:00+00	2025-06-25 16:30:00+00	PESCA	\N
2e316e4c-8785-45cb-8f3c-d52c66cdbe8e	3713d350-d9be-467f-b6a1-8e6cf6030eaf	1	4167beb8-ce39-4fd3-8314-8b3487879d92	\N	\N	2024-07-04 11:58:00+00	2024-07-09 07:50:00+00	PESCA	\N
10d579ef-3af2-400a-b52e-90f2b494ce2e	f764627c-e645-40d1-a54e-6f211baf4a5b	1	4167beb8-ce39-4fd3-8314-8b3487879d92	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-06-27 20:45:00+00	2025-07-03 15:10:00+00	PESCA	\N
f647bac9-802f-415d-bc5e-706c648bbb26	f764627c-e645-40d1-a54e-6f211baf4a5b	2	4167beb8-ce39-4fd3-8314-8b3487879d92	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-07-04 22:41:00+00	2025-07-09 23:58:00+00	PESCA	\N
117de468-ef26-4f7d-a015-5403adf1b90b	111d7d81-fd11-4d58-b315-81a89e358f99	1	4167beb8-ce39-4fd3-8314-8b3487879d92	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-06-27 23:17:00+00	2025-07-03 07:19:00+00	PESCA	\N
11a804fa-32fe-4299-bf4b-81f06b0cf2b5	111d7d81-fd11-4d58-b315-81a89e358f99	2	4167beb8-ce39-4fd3-8314-8b3487879d92	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-07-03 17:55:00+00	2025-07-09 10:40:00+00	PESCA	\N
654cc762-729c-483a-b34d-1176fd859b8d	111d7d81-fd11-4d58-b315-81a89e358f99	3	4167beb8-ce39-4fd3-8314-8b3487879d92	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-07-09 19:55:00+00	2025-07-12 10:44:00+00	PESCA	\N
af7a2b7c-d2d1-4b99-9feb-47c190d3ff3a	111d7d81-fd11-4d58-b315-81a89e358f99	4	4167beb8-ce39-4fd3-8314-8b3487879d92	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-07-12 19:00:00+00	2025-07-16 04:10:00+00	PESCA	\N
3f94852d-fd99-42d8-8e2a-6f27323b031c	2afdcab7-0d3d-4879-966e-5e765240ba69	1	6af901f6-bd7d-4bc7-8c9d-f441e526e65c	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-07-10 15:05:00+00	2025-08-29 07:09:00+00	PESCA	\N
4a64a93f-a993-4b78-a5bf-99df4bb1e831	25f87ce8-5f19-4a37-9f00-6153202f6e7b	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	5b1bcc08-58a5-499b-b2cc-d02d0df392fa	5b1bcc08-58a5-499b-b2cc-d02d0df392fa	2025-07-14 09:50:00+00	2025-08-23 10:14:00+00	PESCA	\N
2fc5398f-7119-4024-856d-c9cb911f6469	ff5003de-9a66-4ea0-8724-2802c54456ed	1	6af901f6-bd7d-4bc7-8c9d-f441e526e65c	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-07-15 22:10:00+00	2025-08-28 14:13:00+00	PESCA	\N
05c80913-cddf-46c0-a260-90fa30f47685	37e9fbd6-5e73-49e7-a9da-a53416bf5885	1	6af901f6-bd7d-4bc7-8c9d-f441e526e65c	\N	\N	2025-07-17 16:00:00+00	2025-09-04 08:40:00+00	PESCA	\N
ea2aa031-0925-449c-97e1-306b0c149537	d096a5e6-f44f-4da9-90b2-b42a19f7b4b2	1	4167beb8-ce39-4fd3-8314-8b3487879d92	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-07-18 17:28:00+00	2025-07-25 11:28:00+00	PESCA	\N
35c59011-d8dc-4ba6-b2c5-f3234bc4c947	d096a5e6-f44f-4da9-90b2-b42a19f7b4b2	2	4167beb8-ce39-4fd3-8314-8b3487879d92	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-08-04 12:10:00+00	2025-08-10 08:26:00+00	PESCA	\N
2d4e1159-08fa-4a01-98ab-12f95f5a0e7c	d096a5e6-f44f-4da9-90b2-b42a19f7b4b2	3	4167beb8-ce39-4fd3-8314-8b3487879d92	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-08-11 14:55:00+00	2025-08-17 08:08:00+00	PESCA	\N
f2e6118a-2188-4944-b145-a10457edeb3e	85424ebb-d0d6-4927-b41e-3c5705f00d46	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-07-19 10:10:00+00	2025-08-23 08:15:00+00	PESCA	\N
9c009a5d-f425-4461-8558-12181d74430c	ad935f05-8e3f-4cd4-951c-6cb36058c10e	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-07-19 17:00:00+00	2025-08-19 14:02:00+00	PESCA	\N
d5164dd6-74d2-4fff-8c68-ecb0d212895a	6726eb24-f7e9-40f0-bee8-57e2d5011db6	1	4167beb8-ce39-4fd3-8314-8b3487879d92	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-06-27 22:43:00+00	2025-07-03 15:28:00+00	PESCA	\N
1af2d060-4e51-4a70-af0b-1ee73159ff76	6726eb24-f7e9-40f0-bee8-57e2d5011db6	2	4167beb8-ce39-4fd3-8314-8b3487879d92	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-07-04 22:41:00+00	2025-07-10 05:37:00+00	PESCA	\N
03ca0e2a-72d7-420b-9323-9a1045b2f04b	6726eb24-f7e9-40f0-bee8-57e2d5011db6	3	4167beb8-ce39-4fd3-8314-8b3487879d92	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-07-11 08:32:00+00	2025-07-16 12:21:00+00	PESCA	\N
76fba6d7-4f68-4177-8db6-60ed880ea5d9	6726eb24-f7e9-40f0-bee8-57e2d5011db6	4	4167beb8-ce39-4fd3-8314-8b3487879d92	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-07-17 01:02:00+00	2025-07-20 12:40:00+00	PESCA	\N
0c453048-effb-43f3-98b0-d984090434f1	55fb1619-09e7-497c-9569-177e432a74f4	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-07-23 12:30:00+00	2025-07-30 09:25:00+00	PESCA	\N
9c062c38-1ced-4110-8ff9-d6efc3541e28	55fb1619-09e7-497c-9569-177e432a74f4	2	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-07-31 11:45:00+00	2025-08-07 08:32:00+00	PESCA	\N
20c02907-3890-427d-b206-49790775af7f	55fb1619-09e7-497c-9569-177e432a74f4	3	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-08-08 11:57:00+00	2025-08-13 19:12:00+00	PESCA	\N
702e0448-ec5f-452a-8f18-a6cc8436e836	55fb1619-09e7-497c-9569-177e432a74f4	4	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-08-14 19:05:00+00	2025-08-21 08:29:00+00	PESCA	\N
7a34ee3c-e126-4fac-abf8-4adad4ddfc82	55fb1619-09e7-497c-9569-177e432a74f4	5	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-08-22 17:12:00+00	2025-08-28 19:29:00+00	PESCA	\N
f68c0564-a098-4377-8be2-73f11d1855de	c4e63591-e94a-4843-873a-bac0dfc487df	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-06-13 17:00:00+00	2025-06-20 15:08:00+00	PESCA	\N
cbf124e7-5629-4a49-a222-38b74a51b988	c4e63591-e94a-4843-873a-bac0dfc487df	2	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-06-25 20:39:00+00	2025-07-05 02:29:00+00	PESCA	\N
09375485-c65c-4de5-a212-e514c62b6d5b	c4e63591-e94a-4843-873a-bac0dfc487df	3	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-07-08 17:40:00+00	2025-07-16 20:34:00+00	PESCA	\N
2424e5be-c456-4f11-aece-86d7ecb7f70d	c4e63591-e94a-4843-873a-bac0dfc487df	4	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-07-19 10:52:00+00	2025-07-25 15:09:00+00	PESCA	\N
185b85c8-ba6c-42f1-828a-0d018eac8b9e	d99e478b-398a-4558-b8e3-89b530097589	1	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-03-13 08:00:00+00	2025-04-14 09:31:00+00	PESCA	\N
b89c3053-43b2-4602-ac74-c887b125e978	d99e478b-398a-4558-b8e3-89b530097589	2	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-04-16 14:10:00+00	2025-04-19 12:20:00+00	PESCA	\N
7fa88f54-2d70-4c4c-88cb-9be3429b321b	b5a4644d-22c2-4337-a2ad-29a068c202b8	1	4167beb8-ce39-4fd3-8314-8b3487879d92	\N	\N	2025-07-30 11:15:00+00	2025-08-04 09:25:00+00	PESCA	\N
bbe8bb01-02bc-4eb2-8618-f56bddbce3ae	bdfc0141-d9a4-4433-8cc8-d119e6f7fa16	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-07-28 16:00:00+00	2025-08-03 11:05:00+00	PESCA	\N
003d28ed-328d-4a34-949d-54dae29787e2	bdfc0141-d9a4-4433-8cc8-d119e6f7fa16	2	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-08-06 18:52:00+00	2025-08-14 06:11:00+00	PESCA	\N
8fd3042e-555e-462c-9704-0e680a4383ad	bdfc0141-d9a4-4433-8cc8-d119e6f7fa16	3	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-08-16 10:37:00+00	2025-08-23 10:37:00+00	PESCA	\N
f3e5b3c3-2787-4ade-ab37-5558ed5a7e69	2362e0e1-bce4-4f40-8b92-700e39fabc4f	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-07-25 17:15:00+00	2025-07-25 17:25:00+00	PESCA	\N
b00c05ae-14da-45f8-97a9-bb45aaeca979	2362e0e1-bce4-4f40-8b92-700e39fabc4f	2	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-07-25 18:12:00+00	2025-07-29 11:35:00+00	PESCA	\N
f2bf7fb8-2800-48fe-9364-9acd9d150cb6	2362e0e1-bce4-4f40-8b92-700e39fabc4f	3	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-07-30 08:58:00+00	2025-08-03 05:25:00+00	PESCA	\N
9d990e15-c570-4dc8-8fb2-b09a392043fa	2362e0e1-bce4-4f40-8b92-700e39fabc4f	4	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-08-03 18:33:00+00	2025-08-07 15:44:00+00	PESCA	\N
6540fe98-a90a-45d5-8546-72084c808ef7	2362e0e1-bce4-4f40-8b92-700e39fabc4f	5	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-08-08 14:30:00+00	2025-08-12 04:43:00+00	PESCA	\N
f0d723ea-eaae-4d01-9090-f614ee61dd3d	2362e0e1-bce4-4f40-8b92-700e39fabc4f	6	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-08-12 20:25:00+00	2025-08-15 05:50:00+00	PESCA	\N
789f154e-32c2-48df-8683-ee2c4afa8b83	2362e0e1-bce4-4f40-8b92-700e39fabc4f	7	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-08-16 09:25:00+00	2025-08-20 09:55:00+00	PESCA	\N
e0c4d4c6-65d1-40f1-b53c-e3d1e1cbec14	10ea10e1-04e8-4255-ac99-b5e9b437ecad	1	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-01-04 13:43:00+00	2025-01-08 01:02:00+00	PESCA	\N
45ea6dbe-db3a-4f81-b750-6c0ae646a95c	10ea10e1-04e8-4255-ac99-b5e9b437ecad	2	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-01-08 15:45:00+00	2025-01-13 08:30:00+00	PESCA	\N
408f4026-93a7-4d30-90ba-3c249940507e	10ea10e1-04e8-4255-ac99-b5e9b437ecad	3	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-01-14 13:40:00+00	2025-02-04 08:15:00+00	PESCA	\N
f9a53086-e1a8-4907-8906-7755100ae13e	10ea10e1-04e8-4255-ac99-b5e9b437ecad	4	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-02-06 14:23:00+00	2025-02-22 11:35:00+00	PESCA	\N
ec522e26-0a60-4f25-95ae-f4cff3d9fab8	679ca681-471c-4ccc-8379-c9f7c00191e0	1	6af901f6-bd7d-4bc7-8c9d-f441e526e65c	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-11-10 19:15:00+00	2025-12-12 12:00:00+00	PESCA	\N
179513f8-4425-4037-9a9a-5a4e760bd060	355b5b34-b8c2-4371-b4ec-3e27808826bc	1	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-11-12 14:03:00+00	2025-12-16 00:00:00+00	PESCA	\N
d6d152e3-7d6e-40bb-b9d1-66de5bb60a6c	355b5b34-b8c2-4371-b4ec-3e27808826bc	2	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-12-18 00:00:00+00	2025-12-24 06:11:00+00	PESCA	\N
0158e076-7414-476d-9de3-5171d0162380	776de334-8e34-4d8e-b65c-5cca453a5102	5	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-10-26 23:50:00+00	2025-11-01 00:15:00+00	PESCA	\N
06a38a3e-a3be-41c8-bccb-3fff8cd9a9d6	776de334-8e34-4d8e-b65c-5cca453a5102	6	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-11-01 23:40:00+00	2025-11-07 15:40:00+00	PESCA	\N
c06f2cb5-ef25-401b-8d46-b0438e12d512	3936555e-956d-499c-bd26-2043cb4d2835	1	4167beb8-ce39-4fd3-8314-8b3487879d92	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-08-21 19:40:00+00	2025-09-02 16:30:00+00	PESCA	\N
8b10452b-3bf9-4374-acd5-f5da7631f4f4	3936555e-956d-499c-bd26-2043cb4d2835	2	4167beb8-ce39-4fd3-8314-8b3487879d92	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-09-03 20:02:00+00	2025-09-19 09:35:00+00	PESCA	\N
85e4ec3c-1e53-4846-b910-293a06fc6040	8c916720-0434-4233-8c81-a7ee1c23b027	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-08-17 13:50:00+00	2025-08-25 07:47:00+00	PESCA	\N
1b81e739-b402-4381-977f-ed4ce14d82cc	8c916720-0434-4233-8c81-a7ee1c23b027	2	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-08-28 14:37:00+00	2025-09-06 17:07:00+00	PESCA	\N
93b0ac03-cd8c-4796-864b-334f4c928307	8c916720-0434-4233-8c81-a7ee1c23b027	3	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-09-08 20:10:00+00	2025-09-18 13:08:00+00	PESCA	\N
69eb3a4f-8f54-484b-be8c-ba5761ae4479	100fc1c4-e838-431f-b7d8-4941a97e5c34	3	4167beb8-ce39-4fd3-8314-8b3487879d92	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-09-04 17:50:00+00	2025-09-21 08:50:00+00	PESCA	\N
1f31441c-87f8-4108-8f1f-c5fc33c3aa9b	ca604291-5e1b-4dec-98df-82a55b73a147	1	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-07-31 13:05:00+00	2025-08-05 07:05:00+00	PESCA	\N
10cec50c-a318-41d7-b992-45c5b94b8573	ca604291-5e1b-4dec-98df-82a55b73a147	2	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-08-07 08:55:00+00	2025-09-12 00:44:00+00	PESCA	\N
e48f2c7f-1c07-4070-8590-696bed6b7ed4	0e414192-e858-4cf7-beb0-0763eabcfcea	1	4167beb8-ce39-4fd3-8314-8b3487879d92	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-07-13 19:50:00+00	2025-07-17 15:03:00+00	PESCA	\N
975b80f9-9d49-4a68-8372-eef478fcfabc	0e414192-e858-4cf7-beb0-0763eabcfcea	2	4167beb8-ce39-4fd3-8314-8b3487879d92	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-07-17 22:40:00+00	2025-07-21 06:10:00+00	PESCA	\N
aa2699e0-796d-4930-b896-af38e271967b	0e414192-e858-4cf7-beb0-0763eabcfcea	3	4167beb8-ce39-4fd3-8314-8b3487879d92	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-07-21 13:55:00+00	2025-07-24 19:40:00+00	PESCA	\N
cc555d15-4ee5-437b-8fea-e14ee2fd84c1	0e414192-e858-4cf7-beb0-0763eabcfcea	4	4167beb8-ce39-4fd3-8314-8b3487879d92	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-07-25 15:52:00+00	2025-07-29 16:34:00+00	PESCA	\N
45d28eae-8f14-46d8-aca9-94de1dee3167	0e414192-e858-4cf7-beb0-0763eabcfcea	5	4167beb8-ce39-4fd3-8314-8b3487879d92	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-07-30 08:29:00+00	2025-08-03 08:40:00+00	PESCA	\N
34aa210b-ff28-486a-9bf4-de8a67884bd2	9d83d69c-6865-482b-91ea-d9a138e1282b	1	4167beb8-ce39-4fd3-8314-8b3487879d92	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-07-11 18:30:00+00	2025-07-18 00:40:00+00	PESCA	\N
99d9bb85-cfcd-402e-843c-504e09b7c561	9d83d69c-6865-482b-91ea-d9a138e1282b	2	4167beb8-ce39-4fd3-8314-8b3487879d92	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-07-19 00:20:00+00	2025-07-29 23:35:00+00	PESCA	\N
e0861599-0d97-4694-9a57-0b225112308c	9d83d69c-6865-482b-91ea-d9a138e1282b	3	4167beb8-ce39-4fd3-8314-8b3487879d92	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-07-30 23:36:00+00	2025-08-06 19:45:00+00	PESCA	\N
89b3a652-44ba-47ca-9909-095623f27052	9d83d69c-6865-482b-91ea-d9a138e1282b	4	4167beb8-ce39-4fd3-8314-8b3487879d92	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-08-07 20:12:00+00	2025-08-13 11:10:00+00	PESCA	\N
d4639598-9ac3-4ac4-ab61-d50fa448e87b	9d83d69c-6865-482b-91ea-d9a138e1282b	5	4167beb8-ce39-4fd3-8314-8b3487879d92	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-08-14 12:50:00+00	2025-08-20 16:20:00+00	PESCA	\N
bd6b7bcf-42ed-49cf-b9de-764689fc29e9	2187fa4d-c865-4773-b3b6-5f77b1b55376	2	4167beb8-ce39-4fd3-8314-8b3487879d92	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-06-28 15:25:00+00	2025-07-10 17:49:00+00	PESCA	\N
94fe0338-f936-46f8-b7b8-32cc267e9a0e	ff020898-60fd-40ba-af9f-a7affe0156a7	2	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-04-30 19:30:00+00	2025-05-06 12:08:00+00	PESCA	\N
e2c848bc-7010-4461-bf53-a8278a61bc31	ff020898-60fd-40ba-af9f-a7affe0156a7	3	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-05-08 14:42:00+00	2025-05-17 03:28:00+00	PESCA	\N
c61072de-0a56-4450-ab3d-112e40f803bd	ff020898-60fd-40ba-af9f-a7affe0156a7	4	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-05-22 10:50:00+00	2025-05-29 01:42:00+00	PESCA	\N
8673d157-1482-4e30-bf99-b6956d537849	02f86ac6-fdc0-4ec6-b90a-3eeb4704083f	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-01-12 20:59:00+00	2025-01-19 14:35:00+00	PESCA	\N
853f75c8-2f7e-49f4-9952-a05b45c84dfe	02f86ac6-fdc0-4ec6-b90a-3eeb4704083f	2	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-01-20 19:07:00+00	2025-01-26 19:05:00+00	PESCA	\N
df1ccbca-8268-4d73-9006-a1546329267b	02f86ac6-fdc0-4ec6-b90a-3eeb4704083f	3	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-01-28 17:30:00+00	2025-02-02 23:37:00+00	PESCA	\N
3969bfcc-0783-4efb-ba75-9030206849f7	02f86ac6-fdc0-4ec6-b90a-3eeb4704083f	4	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-02-03 14:51:00+00	2025-02-12 14:07:00+00	PESCA	\N
\.


--
-- Data for Name: mareas_etapas_observadores; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.mareas_etapas_observadores (id, id_etapa, id_observador, rol, es_designado) FROM stdin;
\.


--
-- Data for Name: mareas_movimientos; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.mareas_movimientos (id, id_marea, fecha_hora, id_usuario, tipo_evento, id_estado_desde, id_estado_hasta, cantidad_muestras_otolitos, detalle, comentarios) FROM stdin;
6a42ca3f-19e3-4abf-a43a-b6909b0ca7f1	a5ee89fd-138a-41bf-b094-dfbae4da6651	2026-01-17 22:28:43.74+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	EDICION_ESTRUCTURA	\N	\N	\N	Edición manual de etapas y fechas de observador.	\N
c2de5fd8-e66b-4eee-ad2e-4a7e6d967c86	a5ee89fd-138a-41bf-b094-dfbae4da6651	2026-01-17 22:29:50.724+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CAMBIO_ESTADO	97219917-fdf2-4aca-b415-96de17cc505e	45672467-a4db-462d-8228-2a21ce82cc37	\N	Fin Marea. Obs: 11/12/2025	\N
b32f47db-cf1e-4f55-b4df-8f22752a851a	96d5f474-06d9-4fcc-9112-d0002553408a	2026-01-17 22:43:54.272+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	3af8b7d1-f41d-4029-83ae-ef5e178ff565	\N	Marea creada por Administrador Sistema	\N
1723e49a-d0d0-4c48-9538-b032a8c08a35	96d5f474-06d9-4fcc-9112-d0002553408a	2026-01-17 22:44:23.75+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CAMBIO_ESTADO	3af8b7d1-f41d-4029-83ae-ef5e178ff565	97219917-fdf2-4aca-b415-96de17cc505e	\N	Inicio Marea. Obs: 15/1/2026	\N
1874da56-67f2-429a-ac6b-b7296087dd1b	391add8f-3134-4e53-9367-f5a7764b3b24	2026-01-18 22:56:00.769+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	3af8b7d1-f41d-4029-83ae-ef5e178ff565	\N	Marea creada por Administrador Sistema	\N
9478d1b4-e2b0-4e56-abf2-e3bcbf96a67c	391add8f-3134-4e53-9367-f5a7764b3b24	2026-01-18 23:01:35.199+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CAMBIO_ESTADO	3af8b7d1-f41d-4029-83ae-ef5e178ff565	2ea71871-f6e2-480b-bb64-6d2f436ffa6f	\N	Acción: Cancelar	Motivo desconocido
2b98b942-fff9-4c0c-b830-57cda53dc104	3bdea548-8948-49d9-b143-da80881041a3	2026-01-18 23:03:39.67+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	3af8b7d1-f41d-4029-83ae-ef5e178ff565	\N	Marea creada por Administrador Sistema	\N
e0e694bd-5b72-4cfd-a14c-06fc39dc337e	fd32e256-3a58-4b30-9706-6c293fd32ff2	2026-01-18 23:05:06.69+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	3af8b7d1-f41d-4029-83ae-ef5e178ff565	\N	Marea creada por Administrador Sistema	\N
050e7ac8-3959-441b-a3c0-5af0514458ff	11612246-9e7f-413a-87c8-f76054478acd	2026-01-18 23:06:10.792+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	3af8b7d1-f41d-4029-83ae-ef5e178ff565	\N	Marea creada por Administrador Sistema	\N
c208f1b8-56f1-45a0-8d29-19d53f46cdcd	80926a39-5773-4465-b5b8-73d7e78dbae5	2026-01-18 23:06:52.011+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	3af8b7d1-f41d-4029-83ae-ef5e178ff565	\N	Marea creada por Administrador Sistema	\N
a5a37231-da87-4405-9a3b-ca826701a4c9	0af952a3-aed1-469d-a089-e5ad54ad8e8d	2026-01-18 23:07:32.04+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	3af8b7d1-f41d-4029-83ae-ef5e178ff565	\N	Marea creada por Administrador Sistema	\N
f69d7208-a8c8-43a3-bbae-47444679d188	0b65ae30-067e-4442-835d-fd3629796ec0	2026-01-18 23:08:31.657+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	3af8b7d1-f41d-4029-83ae-ef5e178ff565	\N	Marea creada por Administrador Sistema	\N
6cb1b092-4cce-4d59-ba01-ba3309073863	ca6ca4b9-876b-4003-bd21-2a5cdeb9cf0a	2026-01-18 23:09:12.484+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	3af8b7d1-f41d-4029-83ae-ef5e178ff565	\N	Marea creada por Administrador Sistema	\N
6125cddc-5131-46d4-a988-ec7741490e49	52795b66-5ac8-41a0-9e5d-081ab92281e0	2026-01-18 23:09:52.294+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	3af8b7d1-f41d-4029-83ae-ef5e178ff565	\N	Marea creada por Administrador Sistema	\N
0794d195-93eb-444e-a8e4-757a713dfdc4	e51d0bf4-6d91-4f27-a2f4-557099679f82	2026-01-18 23:10:59.767+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	3af8b7d1-f41d-4029-83ae-ef5e178ff565	\N	Marea creada por Administrador Sistema	\N
0edda8e2-a1e3-49dd-9102-f279dd5af747	9454fc29-d82f-49bb-b91c-653d5e025262	2026-01-18 23:11:35.027+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	3af8b7d1-f41d-4029-83ae-ef5e178ff565	\N	Marea creada por Administrador Sistema	\N
9b037de3-574a-4441-b60b-01c1a23431bf	7423dc3b-41f8-4168-9a76-44e80eb6b85d	2026-01-18 23:12:47.511+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	3af8b7d1-f41d-4029-83ae-ef5e178ff565	\N	Marea creada por Administrador Sistema	\N
65bb4f60-13fc-49b4-80e9-248dd07b890e	c5fe963a-7da5-4c98-9d7c-d9113050fdfe	2026-01-18 23:14:15.911+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	3af8b7d1-f41d-4029-83ae-ef5e178ff565	\N	Marea creada por Administrador Sistema	\N
d0486d00-2836-4a72-93b2-5b0d6f5dac49	3bdea548-8948-49d9-b143-da80881041a3	2026-01-18 23:15:32.185+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CAMBIO_ESTADO	3af8b7d1-f41d-4029-83ae-ef5e178ff565	2ea71871-f6e2-480b-bb64-6d2f436ffa6f	\N	Acción: Cancelar	Desconocido
0e3b909b-035e-48d3-8d83-1b2ce1d364a7	fd32e256-3a58-4b30-9706-6c293fd32ff2	2026-01-18 23:15:43.523+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CAMBIO_ESTADO	3af8b7d1-f41d-4029-83ae-ef5e178ff565	2ea71871-f6e2-480b-bb64-6d2f436ffa6f	\N	Acción: Cancelar	Desconocido
5b1d8894-fe4d-4ee5-8ef7-e5e84937baaa	11612246-9e7f-413a-87c8-f76054478acd	2026-01-18 23:15:56.565+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CAMBIO_ESTADO	3af8b7d1-f41d-4029-83ae-ef5e178ff565	2ea71871-f6e2-480b-bb64-6d2f436ffa6f	\N	Acción: Cancelar	Desconocido
09c0b386-b1e4-47cd-bf95-aa8fcfab484a	80926a39-5773-4465-b5b8-73d7e78dbae5	2026-01-18 23:16:21.546+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CAMBIO_ESTADO	3af8b7d1-f41d-4029-83ae-ef5e178ff565	2ea71871-f6e2-480b-bb64-6d2f436ffa6f	\N	Acción: Cancelar	Desconocido
5afbf20d-c825-4001-9ead-e684bb63466c	0af952a3-aed1-469d-a089-e5ad54ad8e8d	2026-01-18 23:16:29.482+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CAMBIO_ESTADO	3af8b7d1-f41d-4029-83ae-ef5e178ff565	2ea71871-f6e2-480b-bb64-6d2f436ffa6f	\N	Acción: Cancelar	Desconocido
fd4b621d-b38e-40ec-87a2-ed489faa823b	0b65ae30-067e-4442-835d-fd3629796ec0	2026-01-18 23:16:35.533+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CAMBIO_ESTADO	3af8b7d1-f41d-4029-83ae-ef5e178ff565	2ea71871-f6e2-480b-bb64-6d2f436ffa6f	\N	Acción: Cancelar	Desconocido
178362e7-e3fa-43b9-b57d-07c2bf13e7ee	ca6ca4b9-876b-4003-bd21-2a5cdeb9cf0a	2026-01-18 23:16:41.065+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CAMBIO_ESTADO	3af8b7d1-f41d-4029-83ae-ef5e178ff565	2ea71871-f6e2-480b-bb64-6d2f436ffa6f	\N	Acción: Cancelar	Desconocido
8b14ffa2-359a-43f7-9002-7513305c077f	52795b66-5ac8-41a0-9e5d-081ab92281e0	2026-01-18 23:16:47.893+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CAMBIO_ESTADO	3af8b7d1-f41d-4029-83ae-ef5e178ff565	2ea71871-f6e2-480b-bb64-6d2f436ffa6f	\N	Acción: Cancelar	Desconocido
a4212b76-bd20-4c96-b007-1207a2ac3470	e51d0bf4-6d91-4f27-a2f4-557099679f82	2026-01-18 23:16:52.918+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CAMBIO_ESTADO	3af8b7d1-f41d-4029-83ae-ef5e178ff565	2ea71871-f6e2-480b-bb64-6d2f436ffa6f	\N	Acción: Cancelar	Desconocido
70f41c9a-776f-49bc-863d-a3ea0bed5628	9454fc29-d82f-49bb-b91c-653d5e025262	2026-01-18 23:16:57.783+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CAMBIO_ESTADO	3af8b7d1-f41d-4029-83ae-ef5e178ff565	2ea71871-f6e2-480b-bb64-6d2f436ffa6f	\N	Acción: Cancelar	Desconocido
2aacd9d0-02ab-4745-92e4-a5748022c2da	7423dc3b-41f8-4168-9a76-44e80eb6b85d	2026-01-18 23:17:02.586+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CAMBIO_ESTADO	3af8b7d1-f41d-4029-83ae-ef5e178ff565	2ea71871-f6e2-480b-bb64-6d2f436ffa6f	\N	Acción: Cancelar	Desconocido
\.


--
-- Data for Name: muestras; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.muestras (id, lance_id, especie_id, tipo_muestra, peso_muestra_kg, fact_ponderacion, unidad_largo, primera_talla, ultima_talla, intervalo_mm, total_mediciones, observaciones) FROM stdin;
\.


--
-- Data for Name: muestras_detalle_talla; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.muestras_detalle_talla (id, muestra_id, talla_mm, cantidad_machos, cantidad_hembras, cantidad_indet, cantidad_total, indice_original) FROM stdin;
\.


--
-- Data for Name: observador_pesquerias; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.observador_pesquerias (id, id_observador, id_pesqueria, modo, activo, motivo, fecha_desde, fecha_hasta, id_especie) FROM stdin;
\.


--
-- Data for Name: observadores; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.observadores (id, codigo_interno, nombre, apellido, foto_url, tipo_observador, tipo_contrato, activo, disponible, fecha_proxima_disponibilidad, observaciones, con_impedimento, email, motivo_impedimento) FROM stdin;
0b3c7262-8ba3-4ce3-83f7-cc96080f73f0	7613	Federico Nicolás	Garcia	\N	OBSERVADOR	1109	t	f	\N		t	fede.gaarciaa@gmail.com	Accidente en motocicleta
dfbdeeff-4e60-46c2-9ce0-7becb9a494a2	2021	Claudio	Noale	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	t	claudionoale@hotmail.com	Cambio de trabajo
0ba0a4ea-eaa3-4d11-b737-5f80e0651fb5	7149	Gustavo	Cano	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	\N	\N
4d019608-ebd1-4e3c-95eb-e9a505274ae9	7562	Lucas	Bentos	\N	TECNICO	LEY MARCO	t	t	\N	\N	f	\N	\N
d1d949b7-00fd-4756-8021-bc80d98ecf71	7610	Raul Bernardo	Bargas Peña	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	rbbargas@gmail.com	\N
c8fdee90-2d16-4800-8a4d-e6b470cf152d	7611	Cristian Emmanuel	Cerrina	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	manucerrina2@gmail.com	\N
ea89e630-34ba-4705-98d9-8b662af90e3c	7612	Richard Javier	Espinola Gysin	\N	OBSERVADOR	1109	t	t	\N	\N	f	richardjesp@gmail.com	\N
7c20bb25-01f0-48ad-99ac-5c3b6fe11aec	7616	Jorge Guillermo	Herrera	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	herrerajorgeguillermo@gmail.com	\N
6174f8ea-bada-4606-8acd-463215aef2f0	7617	Leonardo Marcos	Kren	\N	OBSERVADOR	MONOTRIBUTISTA	f	t	\N	\N	t	lmlemark@gmail.com	Licencia médica
372bbb60-ca31-49ff-9ef9-fd5d49beb720	7620	Diego Sebastian	Marchiori	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	brugmasia@hotmail.com	\N
e82e6994-7b2a-4fd4-a699-665a2c81d083	7621	Luis Gabriel	Martinez Tecco	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	lgmt666@hotmail.com	\N
8ced3542-9444-4153-b141-27ed65a5995b	7624	Teresa Beatriz	Reinaga	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	tere2361@hotmail.com	\N
9ca0a15b-a857-4fab-9747-b620717776dd	7625	Eduardo	Silvester	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	eduwolfsilvester@hotmail.com	\N
02ed999f-1a0c-460a-8c38-0cc464af9b6f	7627	Jorge Luis	Morales	\N	OBSERVADOR	PLANTA PERMANENTE	t	t	\N	\N	f	didiinidep1980@gmail.com	\N
d88e7e56-7d2c-4edc-aef4-f61e755c586a	7724	Eduardo Esteban	Aguilar	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	edu81aguilar@gmail.com	\N
66d4eb59-5d54-446b-9ee0-88fa9c133899	7726	Juan José	Coppa	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	juancoppa@hotmail.com	\N
b6df959e-faf0-4d11-a4a3-9795c56105d4	7728	Adrian Pascual	Galluzzo	\N	OBSERVADOR	MONOTRIBUTISTA	f	t	\N	\N	t	apgalluzzo@hotmail.com	Jubilación
cded2d3e-5f9e-4de6-9269-a1da3eeeff0a	7729	Walter Alejandro	Glavina	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	glavinawalter@hotmail.com	\N
30fef00d-f9ee-4362-b430-5819b4bde400	7730	Carlos Daniel	Herrera	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	aquimardel@gmail.com	\N
bf697cb0-a6fa-42ba-8b0a-5f27c9738ec9	7733	Maria Lucila	Maydana	\N	OBSERVADOR	MONOTRIBUTISTA	f	t	\N	\N	f	\N	\N
8e688295-bd22-4219-9e03-709875019ec9	7735	Sergio Fabian	Najle	\N	OBSERVADOR	MONOTRIBUTISTA	f	t	\N	\N	t	najlesergio@yahoo.com.ar	Licencia médica
b6f9e1cc-7022-4f80-8f1d-a8392c9193df	7740	Leonardo Luis	Spagnuolo Rey	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	leospagnuolorey@yahoo.com.ar	\N
08b99f65-0ed6-4e7b-ad1c-1496777a7263	7742	Héctor Luis	Teves	\N	OBSERVADOR	MONOTRIBUTISTA	f	t	\N	\N	t	hecluteves@hotmail.com	Jubilación
0d45342c-ecad-45a7-bb51-ebce9779c000	7767	Claudio Alberto	Nadal	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	nadal-claudio@hotmail.com	\N
42b34bed-97d4-466f-a7c2-3dc5a4a821ff	7776	Gonzalo	Troccoli	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	gtroccoli@inidep.edu.ar	\N
1f6c3850-8006-4a96-a8b9-96c068b8dbee	7796	Fernando Alberto	Schwartz	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	gallococo@hotmail.com	\N
a21b30af-c563-4c43-9d68-bafd0243c5e6	7798	Marcelo Simón	Freyre	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	freyre.ms@gmail.com	\N
a8bff414-46d6-4502-9537-eeda82ec5fa8	7828	Fabian Eduardo	Desojo	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	t	pachappppp@gmail.com	Cambio de empleo a engrasador
6abcf5ef-ae58-4e8c-ae86-335d1478ee3c	7832	Maximiliano Adrian	Godoy	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	maxigodox@gmail.com	\N
20b0118b-9612-4fa8-b90c-5e11e27b07e3	7838	Nicolas Facundo	Staneff Rotela	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	nicolas.staneff@gmail.com	\N
b500d7bc-3760-4c88-9a21-4294b2395c71	7840	Durbal	Villalba	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	villalbadurbal@gmail.com	\N
e148f60c-2aeb-442f-b302-491f4e0eca2b	7841	Nicolas Agustin	Caballero	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	Nicck934@gmail.com	\N
7210834c-47be-440a-81d2-a5fc53a8934b	7842	Gabriel Osvaldo Catriel	Gimenez Salinas	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	pikyred123@gmail.com	\N
b33fd685-31a6-4510-a970-09a2d428a1bb	7843	Johnatan	Challier	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	jonhychallier@gmail.com	\N
4b60b333-fea6-45cd-bec9-c5eb06a8cd1c	7844	Sebastían Roque	Garcia	\N	OBSERVADOR	MONOTRIBUTISTA	f	t	\N	\N	f	sebastianroquegarcia4@gmail.com	\N
6216f910-4b2f-49bc-b238-f3e15147152c	7845	Alexia	Aguilar	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	aguilaralexia00@gmail.com	\N
3aab4c36-1982-4957-8f29-192aba668488	7846	Oriana	Retamar Mendez	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	t	orianaretamarm@gmail.com	Restricción operativa para embarque de mujeres
dae8fea3-9440-4fd0-8212-7c8d9c5f4f20	7847	Gianfranco	Alvarez	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	gianalvarezobs@gmail.com	\N
06979c36-da6e-4fb0-840e-07533a1d41c7	7848	Diego	Gorosito	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	diegojavierg158@gmail.com	\N
e920c268-7682-4e36-8222-bc6cbf215b83	7849	Leonardo	Prado Escobar	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	t	estudioprado02@gmail.com	Inactivo según reporte
8644b80c-97af-46cf-9f4d-711749582de1	7850	María Laura	Monterisi	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	mlm.vlady@gmail.com	\N
af794d59-786f-4769-be8b-4211e743821e	7851	Alvaro	Benitez	\N	OBSERVADOR	MONOTRIBUTISTA	f	t	\N	\N	t	alvarobeni89@gmail.com	En otro trabajo
f60ed9ea-004f-41a9-9d6a-4f34923b1728	7852	Camila	Corti	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	camilacorti95@gmail.com	\N
f644ca0f-bf5f-4449-9c40-7eba742654de	7853	Luciano	Matte Casietto	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	lucianomcassietto@hotmail.com.ar	\N
8321194c-0126-4b76-a497-2b06980a61e3	7854	Gisele	Garcia	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	t	garciagiselealejandra@gmail.com	Desempeño insuficiente reportado
b9333c64-fa8a-4d22-971b-8447d9cec902	7855	Nicolas	Pereyra	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	nicolasagustinpereyra777@gmail.com	\N
82091161-589b-430f-9612-471d6adb2c7f	7858	Franco	Ibarra	\N	OBSERVADOR	MONOTRIBUTISTA	t	f	\N	\N	t	francoadrianibarra@gmail.com	En otro empleo
8ef5a63a-64fd-4821-bc0b-a785c10a056f	7859	Melisa	Garcia	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	t	melipg7@gmail.com	Restricción operativa para embarque de mujeres
a4846d61-d1ba-4641-b155-1dc30725e33a	7860	Nahuel	Ramirez	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	nahuelramirezm@gmail.com	\N
42a44075-32a8-4cf3-ac88-e674cec0c736	7861	Daiana Anabella	Molina Riquelme	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
0f156796-6226-43d5-8a36-41bc33cf453c	7862	Christian Enderson	Fenco Chavesta	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
fcf613e5-2646-4b6a-a45c-ef0e88b95651	7863	Daniel Enrique	Ramunno	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
ff35f1b6-dfb8-4137-ba73-a9440804e848	7864	Manuel Agustín	Palos	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
3c122437-a51d-4597-816c-84cdd15e151f	7865	Gabriel Alejandro	Dumrauf	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
ea018f17-bf86-4148-906a-520c058f3deb	7866	Francisco German	Sette	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
98dc9fa4-86d7-4548-a132-19dda1aa873c	7867	Cintia Daiana	Magrini Quiroga	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
8e978fd7-df5d-495f-aedb-668e0a0eee76	7868	Lucas Oscar	Gaona	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
4207dcc8-7064-4a42-8610-dea6784b2f85	7869	Sergio Gastón	Frontera	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
61c44b6c-785b-4418-82b4-f2f2d3173e8d	7871	Sergio Javier	Gomez Mapiz	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
96431afb-2b4f-474c-8348-78a155e9adb8	7872	Juan Francisco	Rodriguez Fulco	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
2636748e-dbca-4b8b-a7df-53a7499b9937	7873	Lucas David	Carabeta	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
b1260fb6-8960-4630-8970-15e24b1d76e9	7874	Morena Aylen	Ledesma	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
c70489cf-9e72-48ad-839e-7179065e93cd	7875	Leonardo Ezequiel	Andrade	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
f71eb27b-5be5-4b0e-a8a5-a48ef01b4c17	7876	Walter Alejandro	Leon	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
4adac598-f71e-4c8b-b3fb-931f45455a1e	7879	Lucía	Martinez Ta	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
c4d0d648-9ce5-427e-a92a-05bbad8caab8	7900	Paola Alejandra	Navarro Grassi	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
db07cb61-a820-4e11-9f7b-ea45e577d167	8002	Julio Roberto	Sinconegui	\N	OBSERVADOR	MONOTRIBUTISTA	f	t	\N	\N	f	jrsinconegui@inidep.edu.ar	\N
458ab479-cec1-4ab1-ac65-362875121109	9442	Sebastian	Garcia	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
c317e912-8dab-40e0-84f0-2b58bf034f54	9451	Jorge Fernando	Repetto	\N	OBSERVADOR	MONOTRIBUTISTA	f	t	\N	\N	t	cotoperca23@hotmail.com	Jubilación
1a7c0412-7201-4145-afa5-3169b023b255	9459	Raúl Antonio Ceferino	Puliafito	\N	OBSERVADOR	MONOTRIBUTISTA	f	t	\N	\N	t	raul.puliafito@gmail.com	Traslado a otro programa
47b76dd3-1f4d-49c8-8eff-081942bb08ff	9460	Pablo Alejandro	Ramos	\N	OBSERVADOR	MONOTRIBUTISTA	f	t	\N	\N	t	pabloramos64@yahoo.com.ar	Licencia médica
f0a415e0-9538-4336-b681-9d23e0753e26	9461	Alejandro José	Mazzei	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	alejandromazzei525@gmail.com	\N
9a9b3bcd-4b8f-4aba-8ea5-3ec890e23fee	9465	Daniel Alejandro	Di Tullio	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	ddi@inidep.edu.ar	\N
d7785cda-1f2e-4d29-a52d-335b2096bde6	9467	Pablo Julian	Miranda	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	pablojmiranda65@gmail.com	\N
cd4b5edd-c793-4367-869f-a955a17d8a11	9471	Estanislao	Rodriguez Fulco	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	rfestanislao@gmail.com	\N
fb61c911-79f8-45ed-8e0e-23bfa3a9ad2b	9474	Juan Manuel	Staneff	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	juanmanuel_jotis@hotmail.com	\N
ccd3c2b4-fdfd-4d4e-b6c6-1a0dbbc02cf3	9476	Héctor Eduardo	Vera	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	t	veraeduardo1971@gmail.com	Licencia médica
ba8ec778-639d-4dcd-9db2-d7100c84e8f5	9480	Cristian Oscar	Piriz	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	cristianpiriz36@gmail.com	
df1d26fb-7984-43c7-8831-6c8fa0d6b4f5	9999	No	Identificado	\N	OBSERVADOR	MONOTRIBUTISTA	f	f	\N		f	nn@inidep.edu.ar	\N
\.


--
-- Data for Name: password_reset_tokens; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.password_reset_tokens (id, token, expires_at, used, requested_ip, created_at, user_id) FROM stdin;
da9be825-6ee4-493d-9bc8-6f16fbefced9	78b30c629dfee2ae69c35fbdf790dd7464ffa40e9fa68128fbf77948c9c8957c	2026-01-18 01:11:14.324+00	f	\N	2026-01-18 00:41:14.327+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9
\.


--
-- Data for Name: pesquerias; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.pesquerias (id, codigo, nombre, descripcion, grupo, orden, activo) FROM stdin;
e16a6ea7-08d9-4891-b3ab-3ac866d647c2	ABADEJO	Abadejo	\N	Peces	\N	t
822d18e6-569a-40fc-a58f-429b6bef4613	ANCHOITA	Anchoíta	\N	Peces	\N	t
a67a623b-9bd3-45ae-8512-9c6b22645469	CABALLA	Caballa	\N	Peces	\N	t
543aa4a7-f29e-4c08-b04f-62377d3cc0e6	CALAMAR	Calamar	\N	Moluscos	\N	t
7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	CENTOLLA	Centolla	\N	Crustáceos	\N	t
92d9acc2-3590-474f-a773-73e8af728e83	AUSTRALES	Especies australes	\N	Peces	\N	t
4167beb8-ce39-4fd3-8314-8b3487879d92	LANGOSTINO	Langostino	\N	Crustáceos	\N	t
c1692b3c-2c33-4957-8bcb-208f45e4534b	MERLUZA_COMUN	Merluza común	\N	Peces	\N	t
d47be3ca-6602-4648-a74f-74faa2029965	MERLUZA_NEGRA	Merluza negra	\N	Peces	\N	t
6af901f6-bd7d-4bc7-8c9d-f441e526e65c	VIEIRA	Vieira	\N	Moluscos	\N	t
\.


--
-- Data for Name: producciones; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.producciones (id, marea_id, especie_id, fecha, producto, categoria, factor_conversion, kg_produccion, operarios) FROM stdin;
\.


--
-- Data for Name: product_images; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.product_images (id, url, "productId") FROM stdin;
\.


--
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.products (id, title, price, description, slug, stock, sizes, gender, tags, "userId") FROM stdin;
\.


--
-- Data for Name: puertos; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.puertos (id, nombre, provincia, pais, codigo_interno, codigo_externo, es_local, activo, orden, observaciones, latitud, longitud) FROM stdin;
ddb996af-13db-4b51-b5e5-f41a6a683362	Punta Quilla	\N	\N	23	\N	f	t	\N	\N	-50.11666	-68.41666
7b621a00-2ec9-43e9-b9bb-211095252cfe	Rio Gallegos	\N	\N	19	\N	f	t	\N	\N	-51.63334	-69.2
b8a55941-9f65-4e90-bea1-3683753d42b5	Ushuaia	\N	\N	10	\N	f	t	\N	\N	-54.83333	-68.3
11c64a29-e693-4bef-b734-8162f86cbbcc	Buenos Aires	\N	\N	12	\N	f	t	\N	\N	-34.58333	-58.38334
a6afac84-a3d2-4985-9b4d-8e257e17a9a6	Rio Grande (brasil)	\N	\N	20	\N	f	t	\N	\N	-32.13334	-52.08333
ed1e9411-3c86-45fd-8e62-7f0af877d241	Montevideo	\N	\N	XX	\N	f	t	\N	\N	-34.9	-56.2
8fdbcf7a-c032-436b-93c6-de7d6d1ceef2	Samborombon	\N	\N	21	\N	f	t	\N	\N	-35.73333	-57.31667
5b8f16df-6ef5-4385-8480-952d58d6a069	San Clemente	\N	\N	14	\N	f	t	\N	\N	-36.33333	-56.78333
34aeab48-9c9b-4c06-8a45-3469f866cf88	Mar Del Plata	\N	\N	1	\N	t	t	\N	\N	-38.06667	-57.55
870f9cce-6059-4b9f-8a9d-25b976fefa40	Quequen	\N	\N	2	\N	f	t	\N	\N	-38.58333	-58.7
5b1bcc08-58a5-499b-b2cc-d02d0df392fa	Bahia Blanca	\N	\N	3	\N	f	t	\N	\N	-38.75	-62.16667
5611bcea-75b9-4bba-9c08-e2a6f6cbf3c1	Bahia San Blas	\N	\N	15	\N	f	t	\N	\N	-40.55	-62.23333
b1ec7a4f-f3e1-4ebc-8814-3951987690d7	San Antonio Oeste	\N	\N	9	\N	f	t	\N	\N	-40.73333	-64.96667
110bdd1d-ae1a-4fae-b080-9553e8763b05	Viedma	\N	\N	22	\N	f	t	\N	\N	-40.9	-62.86666
105b0349-a9ed-49bf-9336-aad8d3867f0b	Puerto Madryn	\N	\N	4	\N	f	t	\N	\N	-42.76667	-65.05
bea22adf-383f-4cc0-8c0b-bd514132fb77	Rawson	\N	\N	7	\N	f	t	\N	\N	-43.33333	-65.06667
cc39eea9-e598-4902-afc4-72981ecb1199	Bahia Camarones	\N	\N	11	\N	f	t	\N	\N	-44.8	-65.73333
5f58a58c-0cbb-4d6f-b987-f60d562a279c	Comod, Rivad,	\N	\N	6	\N	f	t	\N	\N	-45.88334	-67.5
2862549a-2a96-4d94-aacc-b4939b81fb04	Caleta Olivia	\N	\N	16	\N	f	t	\N	\N	-46.43333	-67.53333
f41ff939-bc00-4bbd-8ce8-c451922ba284	Deseado	\N	\N	5	\N	f	t	\N	\N	-47.76667	-65.91666
6a480bdd-caa0-4f3f-b671-b21defcd10c8	San Julian	\N	\N	17	\N	f	t	\N	\N	-49.31667	-67.73333
\.


--
-- Data for Name: submuestras; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.submuestras (id, muestra_id, numero_ejemplar, largo_total, largo_estandar, peso_total_g, peso_gonadas_g, sexo, estadio_madurez, replecion, contenido_estomacal, observaciones_ejemplar) FROM stdin;
\.


--
-- Data for Name: tipos_flota; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.tipos_flota (id, codigo, nombre, descripcion, orden, activo, codigo_numerico) FROM stdin;
04d57c5c-390c-4334-bba9-d4635e1cb0c0	COSTERO	Costero	\N	\N	t	21
a1373c68-08c7-4c4c-b9a5-b23ccf0abdcc	RADA_RIA	Rada o Ría	\N	\N	t	11
991d17ee-9376-401c-8883-c0409127d0af	ALTURA_FRESQUERO	Altura (Fresquero)	\N	\N	t	31
bbebd1ff-edd5-48dd-925c-9735bb61b50d	ALTURA_CONGELADOR	Altura (Congelador)	\N	\N	t	32
1e6f3be0-9af3-40cf-8306-e1358231f214	INVESTIGACION	Investigación	\N	\N	t	90
a4a18385-067c-481b-97e9-56dc132240d8	INDETERMINADO	Indeterminado	\N	\N	t	99
\.


--
-- Data for Name: transiciones_estados; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.transiciones_estados (id, id_estado_origen, id_estado_destino, accion, etiqueta, clase_boton, requiere_observaciones, activo) FROM stdin;
96938c1f-28b5-4f2f-9120-33e2e4741df0	3af8b7d1-f41d-4029-83ae-ef5e178ff565	97219917-fdf2-4aca-b415-96de17cc505e	REGISTRAR_INICIO	Registrar Inicio	primary	f	t
88aae826-56a1-4f2c-a2a9-44d87f347da3	97219917-fdf2-4aca-b415-96de17cc505e	45672467-a4db-462d-8228-2a21ce82cc37	REGISTRAR_ARRIBO	Confirmar Arribo	primary	f	t
f6efc3ab-d781-42b1-9219-9503405f5212	45672467-a4db-462d-8228-2a21ce82cc37	90b003ac-517d-4a4e-8f2e-c4be43110b5a	RECIBIR_DATOS	Recibir Archivos de Marea	primary	f	t
45cb2a06-a0ae-4fd2-a476-b87c8f4d5d05	90b003ac-517d-4a4e-8f2e-c4be43110b5a	b05afd0d-7633-4e10-acfe-94348fd0594b	INICIAR_VERIFICACION	Iniciar Verificación	primary	f	t
c2a8b4a8-cdfb-41b7-a89c-4df5db7e1482	b05afd0d-7633-4e10-acfe-94348fd0594b	6cc45c99-3bae-4e9a-89b9-111236860b37	ABRIR_CORRECCION	Abrir Corrección	secondary	f	t
227d89eb-04f7-41e7-9fc6-d57f831608f8	b05afd0d-7633-4e10-acfe-94348fd0594b	f7efe5ec-56fe-49a0-ad06-780fc4d7d6b9	PASAR_A_INFORME	Pasar a Informe	primary	f	t
c3c4c1b5-5e54-4660-8f9c-b9c01df13b71	6cc45c99-3bae-4e9a-89b9-111236860b37	f7efe5ec-56fe-49a0-ad06-780fc4d7d6b9	FINALIZAR_CORRECCION	Finalizar Corrección	primary	f	t
6d0061f3-d2ef-4748-9bae-02166f9e834a	6cc45c99-3bae-4e9a-89b9-111236860b37	2c81a996-634d-4153-af0d-d8d9250a6870	DELEGAR_EXTERNA	Derivar a Proyecto	secondary	f	t
3e0618cb-3f0e-4ace-8baf-f4a795167fe4	2c81a996-634d-4153-af0d-d8d9250a6870	6cc45c99-3bae-4e9a-89b9-111236860b37	RETORNAR_CORRECCION	Devolución Externa	primary	f	t
a2e7a891-ead3-4b53-bac2-7685cbaf39e9	f7efe5ec-56fe-49a0-ad06-780fc4d7d6b9	62d21e2c-9542-437f-9979-057c4595cdbc	ENVIAR_A_REVISION	Enviar a Revisión	primary	f	t
a2c81e32-b495-4f6b-9895-ff46372babd7	62d21e2c-9542-437f-9979-057c4595cdbc	e1582fe4-d48e-46fb-b156-7f7aaf3f9983	APROBAR_INFORME	Aprobar Informe	primary	f	t
e6c7b5a0-7c3e-4926-b8dd-85c0e00169c6	62d21e2c-9542-437f-9979-057c4595cdbc	f7efe5ec-56fe-49a0-ad06-780fc4d7d6b9	RECHAZAR_INFORME	Observaciones en Informe	secondary	f	t
ab4da773-12e4-43b0-9920-ccb7adaccb8e	e1582fe4-d48e-46fb-b156-7f7aaf3f9983	d5ccab4b-9a9f-4c2b-97e9-560fafdffbfd	INICIAR_TRAMITE	Iniciar Protocolización	primary	f	t
39394af0-e0d0-42d5-998f-c51be9d35c3f	d5ccab4b-9a9f-4c2b-97e9-560fafdffbfd	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	FINALIZAR_PROTOCOLIZACION	Finalizar Protocolización	primary	f	t
18fe0d9e-fb57-4960-ab05-d8fbe61b3473	3af8b7d1-f41d-4029-83ae-ef5e178ff565	2ea71871-f6e2-480b-bb64-6d2f436ffa6f	CANCELAR	Cancelar	error	t	t
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.users (id, email, password, "fullName", "isActive", roles, "themePreference", "avatarUrl") FROM stdin;
a1eaea70-9aa0-4432-acbf-305ab5fab6f9	admin@obs.com	$2b$10$jYY7zTkIRlh4ZcDM2uyYEumzno9sXiBDznifDWTxb3Zf/9l4nmrdW	Administrador Sistema	t	{admin}	system	\N
ee60e2bc-94fe-45aa-8358-c66ebb920af3	coordinador@obs.com	$2b$10$jYY7zTkIRlh4ZcDM2uyYEumzno9sXiBDznifDWTxb3Zf/9l4nmrdW	Coordinador Operativo	t	{coordinador}	system	\N
3e6b512c-53e0-4d96-9959-b09a6d353067	tecnico@obs.com	$2b$10$jYY7zTkIRlh4ZcDM2uyYEumzno9sXiBDznifDWTxb3Zf/9l4nmrdW	Técnico de Datos	t	{tecnico_datos}	system	\N
a68658ae-266a-47c5-ad6e-61a9552abd84	asistente@obs.com	$2b$10$jYY7zTkIRlh4ZcDM2uyYEumzno9sXiBDznifDWTxb3Zf/9l4nmrdW	Asistente Administrativo	t	{asistente_administrativo}	system	\N
20feb9da-69af-4b7e-9f9f-47ec73ae954f	danieldt2000@hotmail.com	$2b$10$jYY7zTkIRlh4ZcDM2uyYEumzno9sXiBDznifDWTxb3Zf/9l4nmrdW	Daniel Di Tullio	t	{tecnico_datos,coordinador,asistente_administrativo}	system	\N
\.


--
-- Name: product_images_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.product_images_id_seq', 1, false);


--
-- Name: _prisma_migrations _prisma_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public._prisma_migrations
    ADD CONSTRAINT _prisma_migrations_pkey PRIMARY KEY (id);


--
-- Name: alertas_eventos alertas_eventos_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.alertas_eventos
    ADD CONSTRAINT alertas_eventos_pkey PRIMARY KEY (id);


--
-- Name: alertas alertas_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.alertas
    ADD CONSTRAINT alertas_pkey PRIMARY KEY (id);


--
-- Name: artes_pesca artes_pesca_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.artes_pesca
    ADD CONSTRAINT artes_pesca_pkey PRIMARY KEY (id);


--
-- Name: buque_trayectoria_puntos buque_trayectoria_puntos_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.buque_trayectoria_puntos
    ADD CONSTRAINT buque_trayectoria_puntos_pkey PRIMARY KEY (id);


--
-- Name: buque_trayectorias buque_trayectorias_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.buque_trayectorias
    ADD CONSTRAINT buque_trayectorias_pkey PRIMARY KEY (id);


--
-- Name: buques buques_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.buques
    ADD CONSTRAINT buques_pkey PRIMARY KEY (id);


--
-- Name: capturas capturas_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.capturas
    ADD CONSTRAINT capturas_pkey PRIMARY KEY (id);


--
-- Name: error_logs error_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.error_logs
    ADD CONSTRAINT error_logs_pkey PRIMARY KEY (id);


--
-- Name: especies especies_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.especies
    ADD CONSTRAINT especies_pkey PRIMARY KEY (id);


--
-- Name: estados_marea estados_marea_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.estados_marea
    ADD CONSTRAINT estados_marea_pkey PRIMARY KEY (id);


--
-- Name: importacion_access_snapshots importacion_access_snapshots_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.importacion_access_snapshots
    ADD CONSTRAINT importacion_access_snapshots_pkey PRIMARY KEY (id);


--
-- Name: lances lances_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lances
    ADD CONSTRAINT lances_pkey PRIMARY KEY (id);


--
-- Name: mareas_archivos mareas_archivos_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mareas_archivos
    ADD CONSTRAINT mareas_archivos_pkey PRIMARY KEY (id);


--
-- Name: mareas_etapas_observadores mareas_etapas_observadores_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mareas_etapas_observadores
    ADD CONSTRAINT mareas_etapas_observadores_pkey PRIMARY KEY (id);


--
-- Name: mareas_etapas mareas_etapas_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mareas_etapas
    ADD CONSTRAINT mareas_etapas_pkey PRIMARY KEY (id);


--
-- Name: mareas_movimientos mareas_movimientos_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mareas_movimientos
    ADD CONSTRAINT mareas_movimientos_pkey PRIMARY KEY (id);


--
-- Name: mareas mareas_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mareas
    ADD CONSTRAINT mareas_pkey PRIMARY KEY (id);


--
-- Name: muestras_detalle_talla muestras_detalle_talla_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.muestras_detalle_talla
    ADD CONSTRAINT muestras_detalle_talla_pkey PRIMARY KEY (id);


--
-- Name: muestras muestras_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.muestras
    ADD CONSTRAINT muestras_pkey PRIMARY KEY (id);


--
-- Name: observador_pesquerias observador_pesquerias_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.observador_pesquerias
    ADD CONSTRAINT observador_pesquerias_pkey PRIMARY KEY (id);


--
-- Name: observadores observadores_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.observadores
    ADD CONSTRAINT observadores_pkey PRIMARY KEY (id);


--
-- Name: password_reset_tokens password_reset_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.password_reset_tokens
    ADD CONSTRAINT password_reset_tokens_pkey PRIMARY KEY (id);


--
-- Name: pesquerias pesquerias_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pesquerias
    ADD CONSTRAINT pesquerias_pkey PRIMARY KEY (id);


--
-- Name: producciones producciones_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.producciones
    ADD CONSTRAINT producciones_pkey PRIMARY KEY (id);


--
-- Name: product_images product_images_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_images
    ADD CONSTRAINT product_images_pkey PRIMARY KEY (id);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- Name: puertos puertos_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.puertos
    ADD CONSTRAINT puertos_pkey PRIMARY KEY (id);


--
-- Name: submuestras submuestras_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.submuestras
    ADD CONSTRAINT submuestras_pkey PRIMARY KEY (id);


--
-- Name: tipos_flota tipos_flota_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tipos_flota
    ADD CONSTRAINT tipos_flota_pkey PRIMARY KEY (id);


--
-- Name: transiciones_estados transiciones_estados_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transiciones_estados
    ADD CONSTRAINT transiciones_estados_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: alertas_asignado_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX alertas_asignado_id_idx ON public.alertas USING btree (asignado_id);


--
-- Name: alertas_codigo_unico_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX alertas_codigo_unico_key ON public.alertas USING btree (codigo_unico);


--
-- Name: alertas_estado_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX alertas_estado_idx ON public.alertas USING btree (estado);


--
-- Name: alertas_eventos_alerta_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX alertas_eventos_alerta_id_idx ON public.alertas_eventos USING btree (alerta_id);


--
-- Name: alertas_referencia_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX alertas_referencia_id_idx ON public.alertas USING btree (referencia_id);


--
-- Name: artes_pesca_codigo_numerico_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX artes_pesca_codigo_numerico_key ON public.artes_pesca USING btree (codigo_numerico);


--
-- Name: buque_trayectoria_puntos_buque_id_timestamp_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX buque_trayectoria_puntos_buque_id_timestamp_idx ON public.buque_trayectoria_puntos USING btree (buque_id, "timestamp");


--
-- Name: buque_trayectoria_puntos_buque_id_timestamp_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX buque_trayectoria_puntos_buque_id_timestamp_key ON public.buque_trayectoria_puntos USING btree (buque_id, "timestamp");


--
-- Name: buque_trayectoria_puntos_trayectoria_id_timestamp_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX buque_trayectoria_puntos_trayectoria_id_timestamp_idx ON public.buque_trayectoria_puntos USING btree (trayectoria_id, "timestamp");


--
-- Name: buque_trayectorias_buque_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX buque_trayectorias_buque_id_idx ON public.buque_trayectorias USING btree (buque_id);


--
-- Name: buque_trayectorias_buque_id_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX buque_trayectorias_buque_id_key ON public.buque_trayectorias USING btree (buque_id);


--
-- Name: buques_matricula_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX buques_matricula_key ON public.buques USING btree (matricula);


--
-- Name: capturas_lance_id_especie_id_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX capturas_lance_id_especie_id_key ON public.capturas USING btree (lance_id, especie_id);


--
-- Name: capturas_lance_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX capturas_lance_id_idx ON public.capturas USING btree (lance_id);


--
-- Name: especies_codigo_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX especies_codigo_key ON public.especies USING btree (codigo);


--
-- Name: estados_marea_codigo_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX estados_marea_codigo_key ON public.estados_marea USING btree (codigo);


--
-- Name: importacion_access_snapshots_id_externo_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX importacion_access_snapshots_id_externo_key ON public.importacion_access_snapshots USING btree (id_externo);


--
-- Name: importacion_access_snapshots_nro_marea_anio_marea_tipo_mare_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX importacion_access_snapshots_nro_marea_anio_marea_tipo_mare_idx ON public.importacion_access_snapshots USING btree (nro_marea, anio_marea, tipo_marea);


--
-- Name: lances_etapa_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX lances_etapa_id_idx ON public.lances USING btree (etapa_id);


--
-- Name: lances_etapa_id_numero_lance_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX lances_etapa_id_numero_lance_key ON public.lances USING btree (etapa_id, numero_lance);


--
-- Name: mareas_anio_marea_nro_marea_id_buque_tipo_marea_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX mareas_anio_marea_nro_marea_id_buque_tipo_marea_key ON public.mareas USING btree (anio_marea, nro_marea, id_buque, tipo_marea);


--
-- Name: mareas_archivos_id_marea_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX mareas_archivos_id_marea_idx ON public.mareas_archivos USING btree (id_marea);


--
-- Name: mareas_etapas_id_marea_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX mareas_etapas_id_marea_idx ON public.mareas_etapas USING btree (id_marea);


--
-- Name: mareas_etapas_id_marea_nro_etapa_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX mareas_etapas_id_marea_nro_etapa_key ON public.mareas_etapas USING btree (id_marea, nro_etapa);


--
-- Name: mareas_etapas_observadores_id_etapa_id_observador_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX mareas_etapas_observadores_id_etapa_id_observador_key ON public.mareas_etapas_observadores USING btree (id_etapa, id_observador);


--
-- Name: mareas_etapas_observadores_id_etapa_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX mareas_etapas_observadores_id_etapa_idx ON public.mareas_etapas_observadores USING btree (id_etapa);


--
-- Name: mareas_etapas_observadores_id_observador_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX mareas_etapas_observadores_id_observador_idx ON public.mareas_etapas_observadores USING btree (id_observador);


--
-- Name: mareas_movimientos_id_marea_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX mareas_movimientos_id_marea_idx ON public.mareas_movimientos USING btree (id_marea);


--
-- Name: muestras_detalle_talla_muestra_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX muestras_detalle_talla_muestra_id_idx ON public.muestras_detalle_talla USING btree (muestra_id);


--
-- Name: muestras_detalle_talla_muestra_id_talla_mm_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX muestras_detalle_talla_muestra_id_talla_mm_key ON public.muestras_detalle_talla USING btree (muestra_id, talla_mm);


--
-- Name: muestras_lance_id_especie_id_tipo_muestra_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX muestras_lance_id_especie_id_tipo_muestra_key ON public.muestras USING btree (lance_id, especie_id, tipo_muestra);


--
-- Name: muestras_lance_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX muestras_lance_id_idx ON public.muestras USING btree (lance_id);


--
-- Name: observador_pesquerias_id_observador_id_pesqueria_modo_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX observador_pesquerias_id_observador_id_pesqueria_modo_key ON public.observador_pesquerias USING btree (id_observador, id_pesqueria, modo);


--
-- Name: observador_pesquerias_id_observador_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX observador_pesquerias_id_observador_idx ON public.observador_pesquerias USING btree (id_observador);


--
-- Name: observador_pesquerias_id_pesqueria_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX observador_pesquerias_id_pesqueria_idx ON public.observador_pesquerias USING btree (id_pesqueria);


--
-- Name: observadores_codigo_interno_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX observadores_codigo_interno_key ON public.observadores USING btree (codigo_interno);


--
-- Name: observadores_email_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX observadores_email_key ON public.observadores USING btree (email);


--
-- Name: pesquerias_codigo_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX pesquerias_codigo_key ON public.pesquerias USING btree (codigo);


--
-- Name: producciones_marea_id_especie_id_fecha_producto_categoria_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX producciones_marea_id_especie_id_fecha_producto_categoria_key ON public.producciones USING btree (marea_id, especie_id, fecha, producto, categoria);


--
-- Name: producciones_marea_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX producciones_marea_id_idx ON public.producciones USING btree (marea_id);


--
-- Name: products_slug_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX products_slug_key ON public.products USING btree (slug);


--
-- Name: products_title_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX products_title_key ON public.products USING btree (title);


--
-- Name: puertos_codigo_interno_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX puertos_codigo_interno_key ON public.puertos USING btree (codigo_interno);


--
-- Name: submuestras_muestra_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX submuestras_muestra_id_idx ON public.submuestras USING btree (muestra_id);


--
-- Name: submuestras_muestra_id_numero_ejemplar_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX submuestras_muestra_id_numero_ejemplar_key ON public.submuestras USING btree (muestra_id, numero_ejemplar);


--
-- Name: tipos_flota_codigo_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX tipos_flota_codigo_key ON public.tipos_flota USING btree (codigo);


--
-- Name: tipos_flota_codigo_numerico_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX tipos_flota_codigo_numerico_key ON public.tipos_flota USING btree (codigo_numerico);


--
-- Name: transiciones_estados_id_estado_origen_id_estado_destino_acc_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX transiciones_estados_id_estado_origen_id_estado_destino_acc_key ON public.transiciones_estados USING btree (id_estado_origen, id_estado_destino, accion);


--
-- Name: users_email_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX users_email_key ON public.users USING btree (email);


--
-- Name: alertas alertas_asignado_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.alertas
    ADD CONSTRAINT alertas_asignado_id_fkey FOREIGN KEY (asignado_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: alertas alertas_creado_por_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.alertas
    ADD CONSTRAINT alertas_creado_por_id_fkey FOREIGN KEY (creado_por_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: alertas_eventos alertas_eventos_alerta_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.alertas_eventos
    ADD CONSTRAINT alertas_eventos_alerta_id_fkey FOREIGN KEY (alerta_id) REFERENCES public.alertas(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: alertas_eventos alertas_eventos_usuario_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.alertas_eventos
    ADD CONSTRAINT alertas_eventos_usuario_id_fkey FOREIGN KEY (usuario_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: buque_trayectoria_puntos buque_trayectoria_puntos_buque_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.buque_trayectoria_puntos
    ADD CONSTRAINT buque_trayectoria_puntos_buque_id_fkey FOREIGN KEY (buque_id) REFERENCES public.buques(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: buque_trayectoria_puntos buque_trayectoria_puntos_trayectoria_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.buque_trayectoria_puntos
    ADD CONSTRAINT buque_trayectoria_puntos_trayectoria_id_fkey FOREIGN KEY (trayectoria_id) REFERENCES public.buque_trayectorias(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: buque_trayectorias buque_trayectorias_buque_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.buque_trayectorias
    ADD CONSTRAINT buque_trayectorias_buque_id_fkey FOREIGN KEY (buque_id) REFERENCES public.buques(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: buques buques_id_arte_habitual_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.buques
    ADD CONSTRAINT buques_id_arte_habitual_fkey FOREIGN KEY (id_arte_habitual) REFERENCES public.artes_pesca(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: buques buques_id_pesqueria_habitual_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.buques
    ADD CONSTRAINT buques_id_pesqueria_habitual_fkey FOREIGN KEY (id_pesqueria_habitual) REFERENCES public.pesquerias(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: buques buques_id_puerto_base_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.buques
    ADD CONSTRAINT buques_id_puerto_base_fkey FOREIGN KEY (id_puerto_base) REFERENCES public.puertos(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: buques buques_id_tipo_flota_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.buques
    ADD CONSTRAINT buques_id_tipo_flota_fkey FOREIGN KEY (id_tipo_flota) REFERENCES public.tipos_flota(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: capturas capturas_especie_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.capturas
    ADD CONSTRAINT capturas_especie_id_fkey FOREIGN KEY (especie_id) REFERENCES public.especies(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: capturas capturas_lance_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.capturas
    ADD CONSTRAINT capturas_lance_id_fkey FOREIGN KEY (lance_id) REFERENCES public.lances(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: lances lances_cod_arte_pesca_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lances
    ADD CONSTRAINT lances_cod_arte_pesca_fkey FOREIGN KEY (cod_arte_pesca) REFERENCES public.artes_pesca(codigo_numerico) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: lances lances_etapa_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lances
    ADD CONSTRAINT lances_etapa_id_fkey FOREIGN KEY (etapa_id) REFERENCES public.mareas_etapas(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: mareas_archivos mareas_archivos_id_marea_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mareas_archivos
    ADD CONSTRAINT mareas_archivos_id_marea_fkey FOREIGN KEY (id_marea) REFERENCES public.mareas(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: mareas_archivos mareas_archivos_id_movimiento_origen_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mareas_archivos
    ADD CONSTRAINT mareas_archivos_id_movimiento_origen_fkey FOREIGN KEY (id_movimiento_origen) REFERENCES public.mareas_movimientos(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: mareas_archivos mareas_archivos_id_usuario_subio_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mareas_archivos
    ADD CONSTRAINT mareas_archivos_id_usuario_subio_fkey FOREIGN KEY (id_usuario_subio) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: mareas_etapas mareas_etapas_id_marea_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mareas_etapas
    ADD CONSTRAINT mareas_etapas_id_marea_fkey FOREIGN KEY (id_marea) REFERENCES public.mareas(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: mareas_etapas mareas_etapas_id_pesqueria_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mareas_etapas
    ADD CONSTRAINT mareas_etapas_id_pesqueria_fkey FOREIGN KEY (id_pesqueria) REFERENCES public.pesquerias(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: mareas_etapas mareas_etapas_id_puerto_arribo_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mareas_etapas
    ADD CONSTRAINT mareas_etapas_id_puerto_arribo_fkey FOREIGN KEY (id_puerto_arribo) REFERENCES public.puertos(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: mareas_etapas mareas_etapas_id_puerto_zarpada_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mareas_etapas
    ADD CONSTRAINT mareas_etapas_id_puerto_zarpada_fkey FOREIGN KEY (id_puerto_zarpada) REFERENCES public.puertos(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: mareas_etapas_observadores mareas_etapas_observadores_id_etapa_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mareas_etapas_observadores
    ADD CONSTRAINT mareas_etapas_observadores_id_etapa_fkey FOREIGN KEY (id_etapa) REFERENCES public.mareas_etapas(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: mareas_etapas_observadores mareas_etapas_observadores_id_observador_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mareas_etapas_observadores
    ADD CONSTRAINT mareas_etapas_observadores_id_observador_fkey FOREIGN KEY (id_observador) REFERENCES public.observadores(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: mareas mareas_id_arte_principal_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mareas
    ADD CONSTRAINT mareas_id_arte_principal_fkey FOREIGN KEY (id_arte_principal) REFERENCES public.artes_pesca(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: mareas mareas_id_buque_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mareas
    ADD CONSTRAINT mareas_id_buque_fkey FOREIGN KEY (id_buque) REFERENCES public.buques(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: mareas mareas_id_estado_actual_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mareas
    ADD CONSTRAINT mareas_id_estado_actual_fkey FOREIGN KEY (id_estado_actual) REFERENCES public.estados_marea(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: mareas mareas_id_observador_principal_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mareas
    ADD CONSTRAINT mareas_id_observador_principal_fkey FOREIGN KEY (id_observador_principal) REFERENCES public.observadores(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: mareas_movimientos mareas_movimientos_id_estado_desde_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mareas_movimientos
    ADD CONSTRAINT mareas_movimientos_id_estado_desde_fkey FOREIGN KEY (id_estado_desde) REFERENCES public.estados_marea(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: mareas_movimientos mareas_movimientos_id_estado_hasta_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mareas_movimientos
    ADD CONSTRAINT mareas_movimientos_id_estado_hasta_fkey FOREIGN KEY (id_estado_hasta) REFERENCES public.estados_marea(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: mareas_movimientos mareas_movimientos_id_marea_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mareas_movimientos
    ADD CONSTRAINT mareas_movimientos_id_marea_fkey FOREIGN KEY (id_marea) REFERENCES public.mareas(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: mareas_movimientos mareas_movimientos_id_usuario_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mareas_movimientos
    ADD CONSTRAINT mareas_movimientos_id_usuario_fkey FOREIGN KEY (id_usuario) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: muestras_detalle_talla muestras_detalle_talla_muestra_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.muestras_detalle_talla
    ADD CONSTRAINT muestras_detalle_talla_muestra_id_fkey FOREIGN KEY (muestra_id) REFERENCES public.muestras(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: muestras muestras_especie_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.muestras
    ADD CONSTRAINT muestras_especie_id_fkey FOREIGN KEY (especie_id) REFERENCES public.especies(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: muestras muestras_lance_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.muestras
    ADD CONSTRAINT muestras_lance_id_fkey FOREIGN KEY (lance_id) REFERENCES public.lances(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: observador_pesquerias observador_pesquerias_id_especie_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.observador_pesquerias
    ADD CONSTRAINT observador_pesquerias_id_especie_fkey FOREIGN KEY (id_especie) REFERENCES public.especies(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: observador_pesquerias observador_pesquerias_id_observador_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.observador_pesquerias
    ADD CONSTRAINT observador_pesquerias_id_observador_fkey FOREIGN KEY (id_observador) REFERENCES public.observadores(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: observador_pesquerias observador_pesquerias_id_pesqueria_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.observador_pesquerias
    ADD CONSTRAINT observador_pesquerias_id_pesqueria_fkey FOREIGN KEY (id_pesqueria) REFERENCES public.pesquerias(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: password_reset_tokens password_reset_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.password_reset_tokens
    ADD CONSTRAINT password_reset_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: producciones producciones_especie_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.producciones
    ADD CONSTRAINT producciones_especie_id_fkey FOREIGN KEY (especie_id) REFERENCES public.especies(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: producciones producciones_marea_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.producciones
    ADD CONSTRAINT producciones_marea_id_fkey FOREIGN KEY (marea_id) REFERENCES public.mareas(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: product_images product_images_productId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_images
    ADD CONSTRAINT "product_images_productId_fkey" FOREIGN KEY ("productId") REFERENCES public.products(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: products products_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT "products_userId_fkey" FOREIGN KEY ("userId") REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: submuestras submuestras_muestra_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.submuestras
    ADD CONSTRAINT submuestras_muestra_id_fkey FOREIGN KEY (muestra_id) REFERENCES public.muestras(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: transiciones_estados transiciones_estados_id_estado_destino_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transiciones_estados
    ADD CONSTRAINT transiciones_estados_id_estado_destino_fkey FOREIGN KEY (id_estado_destino) REFERENCES public.estados_marea(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: transiciones_estados transiciones_estados_id_estado_origen_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transiciones_estados
    ADD CONSTRAINT transiciones_estados_id_estado_origen_fkey FOREIGN KEY (id_estado_origen) REFERENCES public.estados_marea(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- PostgreSQL database dump complete
--

\unrestrict G4hltDSVwUhSG8L5SzlZ3cwg84wOix3giivgN1wjr87drbgngBjhIc8cJnYHAKb

