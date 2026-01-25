--
-- PostgreSQL database dump
--

\restrict p2s7beggCRZItlr0cgcuZVRsL2jzHE6065iL4JFC7IDoUFFCdRyeqtIaZTJg1ba

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
ALTER TABLE IF EXISTS ONLY public.mareas DROP CONSTRAINT IF EXISTS mareas_id_pesqueria_fkey;
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
DROP INDEX IF EXISTS public.tracking_event_snapshots_hash_key;
DROP INDEX IF EXISTS public.tracking_event_snapshots_hash_idx;
DROP INDEX IF EXISTS public.tracking_event_snapshots_buque_id_idx;
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
DROP INDEX IF EXISTS public.mareas_anio_marea_nro_marea_tipo_marea_key;
DROP INDEX IF EXISTS public.lances_etapa_id_numero_lance_key;
DROP INDEX IF EXISTS public.lances_etapa_id_idx;
DROP INDEX IF EXISTS public.importacion_access_snapshots_nro_marea_anio_marea_tipo_mare_idx;
DROP INDEX IF EXISTS public.importacion_access_snapshots_id_externo_key;
DROP INDEX IF EXISTS public."identificadorMarea";
DROP INDEX IF EXISTS public.estados_marea_codigo_key;
DROP INDEX IF EXISTS public.especies_codigo_key;
DROP INDEX IF EXISTS public.capturas_lance_id_idx;
DROP INDEX IF EXISTS public.capturas_lance_id_especie_id_key;
DROP INDEX IF EXISTS public.buques_nombre_buque_key;
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
ALTER TABLE IF EXISTS ONLY public.tracking_event_snapshots DROP CONSTRAINT IF EXISTS tracking_event_snapshots_pkey;
ALTER TABLE IF EXISTS ONLY public.tipos_flota DROP CONSTRAINT IF EXISTS tipos_flota_pkey;
ALTER TABLE IF EXISTS ONLY public.system_status DROP CONSTRAINT IF EXISTS system_status_pkey;
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
DROP TABLE IF EXISTS public.tracking_event_snapshots;
DROP TABLE IF EXISTS public.tipos_flota;
DROP TABLE IF EXISTS public.system_status;
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
DROP TYPE IF EXISTS public."TipoMarea";
DROP TYPE IF EXISTS public."TipoEtapa";
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


--
-- Name: TipoEtapa; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."TipoEtapa" AS ENUM (
    'MC',
    'CI'
);


--
-- Name: TipoMarea; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."TipoMarea" AS ENUM (
    'MC',
    'CI'
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
    tipo_marea public."TipoMarea" DEFAULT 'MC'::public."TipoMarea" NOT NULL,
    dias_estimados integer,
    id_observador_principal uuid,
    id_pesqueria uuid
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
    tipo_etapa public."TipoEtapa" NOT NULL,
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
-- Name: system_status; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.system_status (
    key text NOT NULL,
    value text,
    last_update timestamp(6) with time zone NOT NULL
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
-- Name: tracking_event_snapshots; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tracking_event_snapshots (
    id uuid NOT NULL,
    buque_id uuid NOT NULL,
    event_type text NOT NULL,
    "timestamp" timestamp(6) with time zone NOT NULL,
    puerto_id uuid,
    hash text NOT NULL,
    created_at timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
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
fc1104d3-ba35-4cff-a99f-4324d27b7efa	8b51a60aa7bea02329d71f988d56e18c5c93ba298725769cb6f1b3c0dfff3ba1	2026-01-20 02:59:39.001438+00	20260120025938_fix_marea_unique_constraint	\N	\N	2026-01-20 02:59:38.964138+00	1
87532b83-9ddc-45f4-87ad-96cee15b80cc	172950499511e7964fb056ef2a03196a26b8987f9d75909d4e5c2e76afa849d3	2026-01-20 14:22:53.863776+00	20260120124511_add_pesqueria_to_marea	\N	\N	2026-01-20 14:22:53.846478+00	1
35c698e3-611c-4ece-b58f-d466986afbb5	737d7022302c3b8d6b58d19c77fdb901e04047553126c66afdc4de7fd0e3502e	2026-01-22 02:53:17.120032+00	20260121023559_text_to_enum_tipo_etapa	\N	\N	2026-01-22 02:53:16.840319+00	1
463ecf3b-9eb0-4142-8532-eb36be85ccb0	c1d07bc51c0e65da1d0b060779edf0856934d7daa1d31111ff4700238ae0f818	2026-01-22 02:53:17.171781+00	20260121183000_add_cascade_delete_trayectorias	\N	\N	2026-01-22 02:53:17.122389+00	1
\.


--
-- Data for Name: alertas; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.alertas (id, codigo_unico, referencia_id, tipo, titulo, descripcion, estado, prioridad, fecha_detectada, fecha_vencimiento, fecha_cierre, asignado_id, creado_por_id, ultima_actualizacion, metadata, referencia_tipo, visible) FROM stdin;
514c7be9-7e61-4868-835e-8dc8c6419e6e	RETRASO_DATOS-8d0f0c3c-e975-4b8b-b7c5-15fc642bd830	8d0f0c3c-e975-4b8b-b7c5-15fc642bd830	RETRASO_DATOS	Retraso en Entrega de Datos	Marea MC-171-25 (CAPESANTE) - 44 días de demora.	PENDIENTE	URGENTE	2026-01-24 13:17:17.899+00	\N	\N	\N	\N	2026-01-24 13:17:17.9+00	{"vessel": "CAPESANTE", "busDays": 44, "mareaCode": "MC-171-25", "observerName": "Sin Asignar"}	MAREA	t
be061bb9-fac0-4f57-94cc-cd9dda37d0ea	RETRASO_DATOS-ad02fd80-86df-4475-a900-a6ae9b15d231	ad02fd80-86df-4475-a900-a6ae9b15d231	RETRASO_DATOS	Retraso en Entrega de Datos	Marea MC-183-25 (CHIYO MARU Nº 3) - 19 días de demora.	PENDIENTE	URGENTE	2026-01-24 13:17:17.939+00	\N	\N	\N	\N	2026-01-24 13:17:17.94+00	{"vessel": "CHIYO MARU Nº 3", "busDays": 19, "mareaCode": "MC-183-25", "observerName": "Sin Asignar"}	MAREA	t
\.


--
-- Data for Name: alertas_eventos; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.alertas_eventos (id, alerta_id, fecha_hora, usuario_id, tipo_evento, detalle) FROM stdin;
4bb76404-a9b1-4782-8098-e9006f2c9d00	514c7be9-7e61-4868-835e-8dc8c6419e6e	2026-01-24 13:17:17.93+00	\N	CREACION	Alerta detectada/creada
b716f5e7-1c74-4242-899a-f19d4ee96afe	be061bb9-fac0-4f57-94cc-cd9dda37d0ea	2026-01-24 13:17:17.943+00	\N	CREACION	Alerta detectada/creada
\.


--
-- Data for Name: artes_pesca; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.artes_pesca (id, codigo_numerico, activo, nombre) FROM stdin;
9e25d139-f360-4a6d-aece-eaddec5adb62	2	t	Red de arrastre de fondo
752eb4a9-ae1f-4fec-a466-67b105069b50	6	t	Red de arrastre de media agua
ccb87b1c-b61f-46a0-b0f7-1dd403267490	3	t	Red de lampara
f2b9eace-3466-44ae-88a2-0192b3598d6b	5	t	Espinel
4910489f-80e9-4c86-8b28-8c8b405626eb	4	t	Red de enmalle
e4e50911-c2bd-4455-84f2-a62ab1dc8158	18	t	Red agallera de deriva
f226ec5a-5b42-44aa-9e7d-947924dfced4	16	t	Palangre de fondo
26770861-4a70-4a22-a9d5-ec35f89966ec	1	t	Red de cerco
3fdbcb10-4b3a-4990-a8c4-ac821cbdd5b8	19	t	Red Bongo 300
17665430-56a7-4fb1-a2f4-b68011ad48c4	20	t	Red Bongo 500
5cc3da9a-03ed-459e-8980-f09e9f0e2c69	21	t	Red Nakthai
7862a464-1909-4d29-8df3-7f7fc44c1ea3	22	t	Red Isaac-Kidd
197dfc9e-593a-4efb-88c8-5d3f7cee3bf0	7	t	Rastra
88c6ab71-7e87-4abd-990a-6e710fd71922	8	t	Nasa
224f215e-14ab-448d-a577-b97065b2e674	9	t	Linea
cdde6df7-955b-442a-802a-35e3c0c5b430	10	t	Raño
4f54264c-4a35-48b2-adf7-15a31cd493f0	11	t	Poteras
019e0fe8-9ebb-486e-a05f-fd1fa2ba74a2	12	t	Red de fondeo
1eeb0dff-da3b-4dfa-8fe2-e415f817921d	13	t	Trampa centollera
ef49b6e8-8d95-4c40-91aa-a431dbea41b5	14	t	Red de arrastre de fondo con tangones
19b1d911-350b-4330-9dda-340318b1b4d0	32	t	Currican
b47f4df6-39ad-4416-8dde-042b0d58b8f2	15	t	Red de arrastre de fondo en pareja
4ff92128-2a10-4fc6-9e1e-dd980e4c7335	80	t	Otros
b2dcadf8-6508-4536-8766-d6c2488a2141	0	t	Sin Especificar
1b2bc63f-9fb0-47f3-97ef-9a897cdb8e28	90	t	No Identificado
\.


--
-- Data for Name: buques; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.buques (id, nombre_buque, matricula, codigo_interno, id_tipo_flota, id_arte_habitual, id_pesqueria_habitual, dias_marea_estimada, eslora_m, potencia_hp, id_puerto_base, empresa_nombre, empresa_localidad, empresa_telefono, empresa_fax, empresa_correo_principal, empresa_correo_secundario, armador_nombre, armador_telefono, agencia_maritima_nombre, activo, fecha_alta, fecha_baja, observaciones) FROM stdin;
a3651180-875d-412f-a557-1b05afd454ff	CONARPESA I	0200	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	\N	52.50	1482	953117a0-3c04-4129-ab96-5eddf3a8d43a	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
75820a88-a86b-466b-8aea-296867c791ce	CAPITAN OCA BALDA	060F	\N	48bb265f-b2b9-4f62-9419-24773575b6f1	\N	\N	\N	\N	\N	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
4c2beed7-288c-4b68-a3b7-c70e37e28ab6	CARMEN A	02045	\N	472b1dab-fa91-4394-a855-d972ba9d3441	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	15.30	223	5fb86b04-e3a4-47af-81fa-11ec0d974b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
750e51ac-80f9-4323-97d2-0c02edd64cc2	CEIBE DOUS	0336	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	40.70	738	953117a0-3c04-4129-ab96-5eddf3a8d43a	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
4a174cd3-2b31-43f5-adf8-711e62961051	CHANG BO GO I	06190	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	\N	\N	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
728c8bc9-03a7-402f-8327-52d9dc0c5558	CHATKA I	02893	\N	472b1dab-fa91-4394-a855-d972ba9d3441	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	16.73	195	953117a0-3c04-4129-ab96-5eddf3a8d43a	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
3fe174c9-43b1-4c88-9ef2-08f2e066c6cb	CHIARPESCA 56	01090	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	\N	\N	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
5fa76aa4-02fa-4536-a619-191038f87440	CHIARPESCA 57	01029	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	\N	\N	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
b4d42a80-c6f4-431c-b16c-64f17a5e3971	CHIARPESCA 902	02110	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	\N	\N	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
c0e72603-4976-4664-9f1b-132c3995b4ae	CHIARPESCA 903	02109	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	\N	\N	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
b9b26176-1565-4f61-81be-9ed5aeb30b41	CHOCO MARU 68	JA13	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	\N	\N	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
fcbab8b6-4b5c-4865-a3f0-86286d554096	CINCOMAR 1	0439	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	\N	\N	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
6cff1394-2fea-43ce-92ec-b5a8471a4850	CINCOMAR 5	02351	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	\N	\N	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
71b52a0e-9fa5-43a1-a26d-d0afe6f1d780	CLAUDIA	02183	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	\N	\N	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
8c4a2b51-49a6-4bb5-b58f-7f3fde7c4790	CLAUDINA	02345	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	53.58	937	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
311a2a22-b55a-4cb3-b1ae-f4774fd68ca2	CODEPECA  I	0497	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	\N	\N	\N	\N	953117a0-3c04-4129-ab96-5eddf3a8d43a	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
c48967a9-12cc-4f1f-a301-b1450a7f8ca9	CODEPECA  II	0498	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	\N	\N	\N	\N	953117a0-3c04-4129-ab96-5eddf3a8d43a	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
d4b3b5ed-0c2d-416d-b262-7f2120e90fde	CODEPECA  III	0506	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	\N	\N	\N	\N	953117a0-3c04-4129-ab96-5eddf3a8d43a	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
2d5a767a-1fbe-4236-ae0a-3dc6e6372a3f	COMETA	0919	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	\N	\N	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
01f6f2bd-58c6-4af1-9475-4c2cdc2403b4	CONARA I	0201	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	\N	\N	\N	\N	953117a0-3c04-4129-ab96-5eddf3a8d43a	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
2b02a6ea-4fcd-496d-905e-183dc5e63f36	CORAL  AZUL	06127	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	\N	\N	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
b4a27630-887f-4e20-b3d2-55a3e6f961be	CORAL BLANCO	06137	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	\N	\N	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
bfd0648b-2667-4653-93ad-c8dbc0a128d4	CORMORAN	01611	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	\N	\N	\N	\N	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
87dc863a-5365-4087-b4e5-d14b714adb68	COSTAMAR	01549	\N	472b1dab-fa91-4394-a855-d972ba9d3441	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	\N	\N	5fb86b04-e3a4-47af-81fa-11ec0d974b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
83a7eba2-e74e-4243-8608-b860f4641b65	DASA 508	0499	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	\N	\N	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
c8d563a8-9280-4447-ada2-c24dc430f7cf	DASA 757	02200	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	\N	\N	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
39bc6d95-0b60-417c-bbbb-6b3f1b77d208	DEMOSTENES	0113	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	\N	\N	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
646dfdfe-5cfa-4187-8830-18ebf6069b73	DEPASUR  I	0330	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	\N	\N	953117a0-3c04-4129-ab96-5eddf3a8d43a	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
8783f8f4-0ec7-4ed0-9859-77e8f32e972a	HAMPON	01410	\N	472b1dab-fa91-4394-a855-d972ba9d3441	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	18.99	497	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
9da1c921-7ee5-4d2e-aea5-856859297876	CENTAURO 2000	6491	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	1985bde5-8964-4250-b775-74cc7469ed58	\N	35.50	1302	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
673c0f77-1eb5-417b-a222-7791be50ce45	CENTURION DEL ATLANTICO	6230	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	9e25d139-f360-4a6d-aece-eaddec5adb62	cb20a7a1-e40f-4cb1-af07-8e5273dd0237	\N	112.80	8111	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
2cca5af3-d619-4bd8-adcb-f327c1d2134a	CIUDAD FELIZ	5802	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	28.56	458	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
75e2c0d5-e4da-4370-8ae3-00c7dddad930	COMANDANTE LUIS PIEDRABUENA	5358	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	25.00	501	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
a8ebed73-272d-46ec-a0af-8fa0af9a877b	CORAJE	5653	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	\N	\N	\N	28.28	426	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
40af42d0-7b9c-4107-8596-2440b28cf120	CRISTO REDENTOR	4680	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	31.00	642	aa748f6a-602b-4346-b964-50cbcea76146	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
4c9ebdc1-a5b7-44c1-bc1d-afb5439051c4	CAROLINA P	6454	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	9e25d139-f360-4a6d-aece-eaddec5adb62	1985bde5-8964-4250-b775-74cc7469ed58	\N	71.60	1976	953117a0-3c04-4129-ab96-5eddf3a8d43a	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
5690f647-1f35-44a6-a4ef-e88eff2f7623	CHOKYU MARU Nº 18.	02584	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	68.70	1777	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
63f6107b-beea-4b36-9774-25cf88d83e48	COALSA SEGUNDO	6211	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	9e25d139-f360-4a6d-aece-eaddec5adb62	1985bde5-8964-4250-b775-74cc7469ed58	\N	76.20	2960	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
0e4e5915-4bad-491b-94e1-629147dd16e2	CODEPECA IV	5999	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	\N	\N	\N	\N	953117a0-3c04-4129-ab96-5eddf3a8d43a	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
db49fb1b-1a50-441a-a74d-2003716ec34c	CIUDAD DE HUELVA	5861	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	27.45	426	953117a0-3c04-4129-ab96-5eddf3a8d43a	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
d0e72f51-a671-4744-937d-154f5c520b69	HARENGUS	0510	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	\N	\N	953117a0-3c04-4129-ab96-5eddf3a8d43a	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
34ec5cb8-f80e-43f0-99dc-bae75531bc03	HOKO 31	05934	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	\N	\N	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
a967d1fe-bbc2-49bd-856c-8edcd716c7bb	HOPE N°7	06130	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	50.60	1235	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
f4ddfcd5-0792-40fc-aee2-919535680649	HSIANG LAI FU	80	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	\N	\N	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
f7f31452-879f-4748-8b8d-7c869dbde578	HU YU 910	81	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	\N	\N	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
b194f13d-ded4-4645-aaf5-5ee69599c88d	HUAFENG 815	0554A	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	\N	\N	25.28	419	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
955b8b42-8b5e-4076-80b1-0bf4fd318a35	HUAFENG 820 (ex INFINITUS PEZ)	01472A	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	\N	\N	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
e0e29119-4189-43f9-a975-8760d13df4da	HUAFENG 821 (ex INITIO PEZ)	01471A	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	\N	\N	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
72d98dc7-dbbc-4a67-98a3-c78c2598b3f2	IARA	06207	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	\N	\N	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
4d9280b5-4aec-4fa0-a927-3a355a0240d9	IGLU I	01423	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	32.75	660	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
2ad4c8ea-fb36-4a01-986a-a9f44455d7c1	ILLEX I	125	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	\N	\N	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
615018a1-9c47-4872-97c0-93c4fa32e99e	INARI MARU N° 25	0261	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	\N	\N	aa748f6a-602b-4346-b964-50cbcea76146	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
46150252-5ae8-4c72-ae7e-462b11a89575	INFINITUS PEZ	01472	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	\N	\N	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
5ac34cdb-7071-4a19-bb09-19970250a0f3	INITIO PEZ	01471	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	\N	\N	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
4b89844a-387f-42ea-bba6-a5f90638c88d	JOLUMA	5403	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	\N	\N	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
9e36374c-61e6-4150-989c-a90d3cf382c7	JOSE LUIS ALVAREZ	0618	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	\N	\N	\N	\N	953117a0-3c04-4129-ab96-5eddf3a8d43a	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
e3dc8e60-dd87-4a81-b2d8-66b65248fcba	JUAN ALVAREZ	0619	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	\N	\N	36.60	1168	953117a0-3c04-4129-ab96-5eddf3a8d43a	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
051a05b0-f013-428e-93bf-6474ece39ff7	JUAN PABLO II	02695	\N	472b1dab-fa91-4394-a855-d972ba9d3441	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	22.49	326	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
42e21c46-cd56-4970-b8b4-14988e52a48d	JUDITH I	0908	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	\N	\N	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
ceccc1e6-e0f6-4b31-ba3e-a710cd3c2fc9	MARIA  EUGENIA	01173	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	\N	\N	\N	\N	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
5bb19f7f-a95b-4d0e-b8db-bfa8ab593fc7	KALEU KALEU	01963	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	\N	\N	\N	\N	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
689b905e-e8b2-4224-8f01-16eda9c7df09	KANTXOPE	01065	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	\N	\N	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
87f5a819-8c96-440d-a9a8-06e685cfd383	LAIA	06521	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	53.00	1185	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
5ab06c13-e250-456e-ba86-9a37d5f39700	LATINA  N° 8	0291	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	\N	\N	aa748f6a-602b-4346-b964-50cbcea76146	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
9830e51a-8b84-49bf-b2a0-6857113f3af7	ANTARTIC II	0263	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	f226ec5a-5b42-44aa-9e7d-947924dfced4	\N	\N	\N	\N	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
4002c897-d26d-4ba6-bf41-ce723c6bc84e	ANTARTIC III	0262	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	f226ec5a-5b42-44aa-9e7d-947924dfced4	\N	\N	\N	\N	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
80a91104-b031-4e3c-8308-fbdff126f6dc	GEMINIS	6569	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	9e25d139-f360-4a6d-aece-eaddec5adb62	1985bde5-8964-4250-b775-74cc7469ed58	\N	68.90	2141	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
4fb8e545-033a-4813-88be-9e7994602845	GRACIELA I	0003137	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	1985bde5-8964-4250-b775-74cc7469ed58	\N	39.94	\N	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
77fc8874-0665-4c30-8f0b-65c795f4eaa0	HUAFENG 801	0003013	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	65.04	1973	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
751ec7e0-2540-41ab-8cbf-32f98f542d5c	HUAFENG 802	0003014	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	65.04	1973	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
6339ce97-a36d-4a32-84b8-e1a54c5d7e33	HUA I 616	6301	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	\N	\N	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
b356568d-61f4-4118-846e-e5dd2055f933	HUYU 906	0003026	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	65.92	1579	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
99aa6d59-9ea9-416a-8c00-3bd45e7b17b3	HUYU 961	0003057	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	\N	127f273e-086c-4e23-bb9e-0557fc9270aa	\N	65.70	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
edd87f10-eea7-4484-85b5-c4e725767ea8	HUYU 962	0003056	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	127f273e-086c-4e23-bb9e-0557fc9270aa	\N	65.60	\N	953117a0-3c04-4129-ab96-5eddf3a8d43a	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
da480794-40eb-4d00-9284-08992815d854	JUEVES SANTO	6255	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	\N	\N	39.50	1244	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
f3ad8d91-7825-424b-8e0e-0d2631877306	JUPITER II	6597	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	27.90	791	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
e932fc7e-25ea-4e54-9c7a-68da116ebd39	KARINA	6075	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	\N	\N	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
833a06fb-02f2-4425-b980-5fc6b313335f	LANZA SECA	5424	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	\N	\N	\N	24.80	514	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
6a282f04-a119-47a0-85fb-c79754512ad8	ANTARTIDA	0678	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	\N	\N	953117a0-3c04-4129-ab96-5eddf3a8d43a	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
ddf4f886-9078-48b5-959d-1b3a4a18b31b	API II	0679	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	\N	\N	953117a0-3c04-4129-ab96-5eddf3a8d43a	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
ceaaab4d-6899-4915-a811-1e69782e9d1f	API IV	0680	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	\N	\N	953117a0-3c04-4129-ab96-5eddf3a8d43a	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
dede25ae-df11-41db-bd97-df96918cf46a	API VI	02812	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	\N	\N	36.35	1201	953117a0-3c04-4129-ab96-5eddf3a8d43a	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
93cdc169-1d64-49f0-916a-209cfa28388e	ARBUMASA X	6183	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	\N	\N	35.30	1087	aa748f6a-602b-4346-b964-50cbcea76146	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
8ec05675-e6da-4124-8780-58ce13b80655	ARBUMASA  XVII	0216	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	\N	\N	\N	\N	aa748f6a-602b-4346-b964-50cbcea76146	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
d5613068-53e5-4764-a45e-44bffa169436	ARBUMASA XIV	0213	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	\N	\N	36.40	1047	aa748f6a-602b-4346-b964-50cbcea76146	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
5cbe37e2-3ca9-4bcd-ad47-63d181d090a3	ARBUMASA XVIII	0217	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	\N	\N	36.40	870	aa748f6a-602b-4346-b964-50cbcea76146	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
aef5c286-a93c-40be-aca3-24e7260b238d	ARBUMASA XXIX	02561	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	65.60	1776	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
a2a7a936-ba14-478b-bcf6-8a1438b4aacc	ARBUMASA XXVI	01958	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	62.80	2403	aa748f6a-602b-4346-b964-50cbcea76146	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
208416c6-4785-4947-ba1d-aa48b7407623	ARCANGEL	79	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	\N	\N	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
0141faa1-221b-4ac3-9f69-a5971a7b2f70	ARESIT	02265	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	\N	\N	36.26	1085	953117a0-3c04-4129-ab96-5eddf3a8d43a	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
20fde841-e14c-4dc0-8b67-0c1dbd944bea	ARBUMASA XV	214	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	\N	36.40	870	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
d3f42698-725b-403f-9ca4-08c49e127dd3	ARBUMASA XIX	06440	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	\N	36.40	870	aa748f6a-602b-4346-b964-50cbcea76146	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
cff19edb-4d41-4a8a-92ed-2a57683ba0fe	ATLANTIC EXPRESS	02936	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	1eeb0dff-da3b-4dfa-8fe2-e415f817921d	13c3c551-df0d-4c62-a185-d36a0298672a	\N	53.70	3426	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
30b1a0cb-0656-4dd5-a54e-e9c5feb7a50d	BOGAVANTE SEGUNDO	02994	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	\N	37.45	867	953117a0-3c04-4129-ab96-5eddf3a8d43a	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
234013ad-b9f2-4d94-aeaf-6ce06a7df5ca	BUENA PESCA	01475	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	\N	\N	39.10	1479	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
d51b66b7-9c62-4682-bbdc-e29bcd3130eb	CABO BUEN TIEMPO	025	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	\N	\N	953117a0-3c04-4129-ab96-5eddf3a8d43a	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
7644b215-3283-43d5-8df7-3e1ddb0bc138	CABO BUENA ESPERANZA	02482	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	\N	\N	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
42c25503-2131-41d9-9a55-eb886e3ecc2b	CABO DOS BAHIAS	02483	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	\N	\N	953117a0-3c04-4129-ab96-5eddf3a8d43a	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
61acd33d-d928-4039-8a38-9e457526e3cf	CABO SAN JUAN	023	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	\N	\N	953117a0-3c04-4129-ab96-5eddf3a8d43a	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
50748279-f575-4562-ad67-27313b825b0f	CABO SAN SEBASTIAN	022	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	\N	\N	953117a0-3c04-4129-ab96-5eddf3a8d43a	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
ac47b729-d351-4edc-93b0-b3d2e1b95137	CABO TRES PUNTAS	01483	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	31.43	721	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
ab56ad96-e4f0-4cf1-b845-9d195a6931a3	CABO VIRGENES	024	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	\N	\N	953117a0-3c04-4129-ab96-5eddf3a8d43a	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
174c5b77-9524-423b-8402-1905e408766a	CALABRIA	0567	\N	472b1dab-fa91-4394-a855-d972ba9d3441	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	19.63	266	953117a0-3c04-4129-ab96-5eddf3a8d43a	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
dada4f38-4556-466a-b9a6-1f7940a0898f	CALIZ	02809	\N	472b1dab-fa91-4394-a855-d972ba9d3441	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	20.20	545	5fb86b04-e3a4-47af-81fa-11ec0d974b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
93c8037b-3e97-454f-bdfd-86b0bb056e82	CALLEJA	06276	\N	472b1dab-fa91-4394-a855-d972ba9d3441	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	21.83	503	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
cabdc202-1c32-47de-8fad-db5e124b6083	CAMERIGE	01406	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	27.90	652	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
966957c4-0ca9-4ae5-ac57-3854256b1c10	CAPITAN CANEPA	059F	\N	48bb265f-b2b9-4f62-9419-24773575b6f1	\N	\N	\N	\N	\N	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
019e7b35-d762-4370-bb72-bed65a4c91bb	CAPITAN GIACHINO	0151	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	\N	\N	38.42	1062	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
d1f76c19-03e4-4e43-8e06-8d33a8acf63e	PALOMA V	64	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	f226ec5a-5b42-44aa-9e7d-947924dfced4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
ec976353-f1fb-4f24-8ff0-c77281d104ec	API V	02781	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	9e25d139-f360-4a6d-aece-eaddec5adb62	1985bde5-8964-4250-b775-74cc7469ed58	\N	77.40	2960	953117a0-3c04-4129-ab96-5eddf3a8d43a	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
1ee4fd4d-3387-47b5-ad36-c89ea8609d5b	Dr. EDUARDO L. HOLMBERG	061F	\N	48bb265f-b2b9-4f62-9419-24773575b6f1	\N	\N	\N	\N	\N	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
0f6efb74-0b7f-4297-8c1e-1cc91cb079fd	ANTONIO ALVAREZ	0001429	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	\N	\N	36.60	1168	953117a0-3c04-4129-ab96-5eddf3a8d43a	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
8025c58d-386f-49ef-b686-533eedb8d540	ARBUMASA XVI	6366	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	\N	36.40	1047	aa748f6a-602b-4346-b964-50cbcea76146	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
56d47c7e-9c61-403f-b9d2-0d2680d7be1d	CABO DE HORNOS	5323	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	\N	\N	\N	\N	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
554ade41-f4ac-4793-be90-98c7e1a595c6	CANAL DE BEAGLE	5409	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	23.90	501	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
aeb1c939-78bd-4a60-a082-f9a46ed969d3	ARGENTINO	6305	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	1985bde5-8964-4250-b775-74cc7469ed58	\N	33.77	1001	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
a804a734-5f37-4dfd-9036-49e47902739d	ACRUX	0003086	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	\N	28.00	\N	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
05bcda73-0d39-41dd-b4e9-c8865cad2a69	ANDRES JORGE	1065	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	1985bde5-8964-4250-b775-74cc7469ed58	\N	50.10	1102	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
586875c1-3fc8-4030-95b9-5ab951eb4775	ARGENOVA I	02180	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	\N	\N	35.00	655	aa748f6a-602b-4346-b964-50cbcea76146	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
8ae504c3-f997-4f9a-a523-0cc3ef700cb7	ARGENOVA IV	02157	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	\N	\N	\N	36.26	675	aa748f6a-602b-4346-b964-50cbcea76146	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
72ff2e05-84aa-4e7d-b3d6-7a67267eabc0	ARGENOVA X	02329	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	\N	\N	32.50	550	aa748f6a-602b-4346-b964-50cbcea76146	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
9e69f77a-6359-4045-8e64-11ad6dcc4102	ARGENOVA XI	02199	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	f226ec5a-5b42-44aa-9e7d-947924dfced4	\N	\N	\N	\N	aa748f6a-602b-4346-b964-50cbcea76146	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
f1fbdc94-a39a-4ad7-a19c-42e63cd69fae	ARGENOVA XXIII	02713	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	\N	\N	37.19	678	aa748f6a-602b-4346-b964-50cbcea76146	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
fa3366aa-4342-4a3b-a6be-e6a893c29c5c	ARGENOVA XXVI	02849	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	\N	\N	37.15	1086	aa748f6a-602b-4346-b964-50cbcea76146	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
21e18fad-7d94-45c1-8b7c-b9e198ea5989	ARGENOVA III	02156	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	\N	\N	\N	\N	aa748f6a-602b-4346-b964-50cbcea76146	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
bb88cda6-c4f8-4593-b2a6-aecd1e2b491d	PAOLA  S	0557	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
01adb776-0aea-494d-a190-94df9ee100ec	ARGENOVA IX	02328	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	\N	\N	32.50	550	aa748f6a-602b-4346-b964-50cbcea76146	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
02412f75-bb85-4d82-8bba-1f2c5ed9ea0e	ARGENOVA XII	0199	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	f226ec5a-5b42-44aa-9e7d-947924dfced4	\N	\N	\N	\N	aa748f6a-602b-4346-b964-50cbcea76146	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
b972f86d-6dc2-407b-a507-69db2f47e248	ARGENOVA XV	0198	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	f226ec5a-5b42-44aa-9e7d-947924dfced4	\N	\N	\N	\N	aa748f6a-602b-4346-b964-50cbcea76146	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
5a1effd7-847b-44aa-acbd-638e8ab6e7c5	ARKOFISH	0236	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	\N	\N	953117a0-3c04-4129-ab96-5eddf3a8d43a	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
c51c2ff3-742a-4cce-ba14-e46d61be366a	ARKOFISH I	6004	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	\N	\N	953117a0-3c04-4129-ab96-5eddf3a8d43a	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
eea43745-cd3f-45a8-a0af-74d290853459	ASUDEPES II	6363	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	\N	\N	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
51917c96-4006-4860-9ac5-8069af0022a5	ASUDEPES III	6062	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	\N	\N	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
42ca9303-a801-46ff-8a25-221dc6ac8911	ATLANTIC SURF I	0350	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	\N	\N	\N	\N	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
a042a5fa-b960-4219-91dd-d3d3e3080abb	BEAGLE I	6052	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	59.90	2369	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
1f62a965-9d1f-475c-aee4-0c4855200288	BONFIGLIO	01234	\N	472b1dab-fa91-4394-a855-d972ba9d3441	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	\N	\N	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
a0a7acd7-9cd1-4920-9dff-1cb2605d4af5	AURORA	02581	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	127f273e-086c-4e23-bb9e-0557fc9270aa	\N	67.55	1776	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
cca93d4f-fccb-4a0f-ad3b-752351938359	ARGENOVA XXV	028011	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	\N	39.70	859	aa748f6a-602b-4346-b964-50cbcea76146	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
4f52eba5-a69e-4bf2-9ea9-bf6a8e733136	ARGENOVA XXIV	02752	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	\N	38.80	675	aa748f6a-602b-4346-b964-50cbcea76146	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
4e395848-f29c-4bed-b5f7-3f633bad01a2	ARGENOVA II	02177	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	\N	38.50	1168	aa748f6a-602b-4346-b964-50cbcea76146	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
8edc52e7-45b1-4e9a-9df8-02eac46e8b3f	BOUCIÑA	01637	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	\N	0.00	\N	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
93f4623a-17c8-4e5f-bb4f-28ad962199e5	ARGENOVA XXII	02714	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	\N	37.70	663	aa748f6a-602b-4346-b964-50cbcea76146	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
94c1a2ae-bf95-4d8c-96eb-7d4855006eff	ALDEBARAN	01741	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	26.42	426	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
695c346a-e79c-4e7c-a682-6cb69907aa27	ALTALENA	0181	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	55.80	1350	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
d0d68d8e-b70e-4e4f-937d-1dc4f73372ac	ARGENOVA XIV	6010	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	f226ec5a-5b42-44aa-9e7d-947924dfced4	\N	\N	52.30	1352	aa748f6a-602b-4346-b964-50cbcea76146	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
72a1b6c1-a12e-4eee-a022-7db78860e773	BAHIA DESVELOS	6162	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	\N	\N	37.05	791	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
ae3d4e22-1208-4514-9403-30fd4a94f051	ATREVIDO	6194	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	1985bde5-8964-4250-b775-74cc7469ed58	\N	32.50	901	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
ad2b1eb2-683e-4cec-8e99-2891751ef175	BELVEDERE	6336	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	26.50	624	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
933ac46a-b225-455c-90da-e0927a03de76	ARRUFO	5239	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	\N	39.16	1102	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
642a1919-275d-4362-a1f9-785c61d0c12a	BORRASCA	5241	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	\N	\N	39.16	1083	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
8db03d13-addd-4682-861a-3c010fb5e5a9	ALVAREZ ENTRENA I	02454	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	\N	\N	39.43	988	953117a0-3c04-4129-ab96-5eddf3a8d43a	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
58b89ef9-c8da-4a18-9375-beda3fc94040	ALVAREZ ENTRENA II	02465	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	\N	\N	39.50	988	953117a0-3c04-4129-ab96-5eddf3a8d43a	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
9ab7a333-0816-41c0-86a1-a44c90ba1692	ALVAREZ ENTRENA III	02379	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	\N	\N	\N	\N	953117a0-3c04-4129-ab96-5eddf3a8d43a	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
01127d29-2025-4ab8-8bab-525eb79da108	BAFFETTA	02635	\N	472b1dab-fa91-4394-a855-d972ba9d3441	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	\N	\N	19.45	295	953117a0-3c04-4129-ab96-5eddf3a8d43a	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
a0ce7ab8-aee0-410a-8fff-51accd4c97a9	AMBITION	01324	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	\N	\N	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
b8e3ba55-0d7d-487e-8ca3-ce16bb98df7d	ANABELLA  M	0175	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	\N	\N	953117a0-3c04-4129-ab96-5eddf3a8d43a	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
ea681355-a994-4d91-b93e-c51e80fb1732	ANGELUS	01953	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	52.60	1337	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
d10f1fd9-54db-4b1e-8e05-446e7d8b3b7d	ANITA ALVAREZ	02138	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	\N	\N	\N	\N	953117a0-3c04-4129-ab96-5eddf3a8d43a	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
c5494956-b211-452b-bc82-f20fe69367f3	ANTARTIC  I	0232	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	f226ec5a-5b42-44aa-9e7d-947924dfced4	\N	\N	\N	\N	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
3de3548f-5c64-4cbe-852e-74963ee56c13	DEPEMAS 51	0239	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	\N	\N	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
eabd3f55-194e-4815-b3f1-49223ac8bbd1	DEPEMAS 81	0281	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	\N	\N	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
57f0d8a1-1a98-471f-8c68-3808a7203cda	DESEADO	01598	\N	472b1dab-fa91-4394-a855-d972ba9d3441	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	19.00	301	5fb86b04-e3a4-47af-81fa-11ec0d974b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
72f0e30e-1774-4e69-8374-3511c1e01724	DIEGO PRIMERO	01725	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	\N	\N	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
ed577841-aa7a-4790-b78b-429e0d4bfe55	DON  NATALIO	01183	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	\N	\N	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
c9ebee19-17bd-4c2c-b2b2-7adae9936a70	DON ANTONIO	0029	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	27.80	549	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
d5c8c5b7-f9c9-47c6-94ac-452bc0a45c50	DON JOSE DI BONA	02241	\N	472b1dab-fa91-4394-a855-d972ba9d3441	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	19.85	301	5fb86b04-e3a4-47af-81fa-11ec0d974b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
d2e10743-aa35-46cb-b4a1-5dfd07883d49	DON JUAN	01397	\N	472b1dab-fa91-4394-a855-d972ba9d3441	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	\N	\N	27.00	425	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
db6608eb-dac2-4be4-82eb-d5e5b7e4b3cb	DON JUAN D´AMBRA	5174	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	\N	\N	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
42ea44c9-b59c-495c-9876-ff8695519ec2	DON LUCIANO	069	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	\N	\N	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
734bfe3e-8a5d-4d2b-9f69-856071eca09d	DON MIGUEL 1°	0748	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	\N	\N	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
df1456bc-155d-4529-b1eb-66a96cabce63	DON OSCAR	02184	\N	472b1dab-fa91-4394-a855-d972ba9d3441	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	\N	\N	5fb86b04-e3a4-47af-81fa-11ec0d974b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
fb3b141b-abd3-4275-9a6d-2f779efa7bcb	DESTINY	3209	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
e0d77c1f-8409-433c-9834-e4ab7b5460e6	DON ROMEO ERSINI	0972	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	\N	\N	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
34b1ed26-1709-4f56-a000-8bbb42f9abde	DON TOMASSO	02310	\N	472b1dab-fa91-4394-a855-d972ba9d3441	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	17.00	356	5fb86b04-e3a4-47af-81fa-11ec0d974b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
30921d30-27e7-4bf8-bad0-db3b671ed3d1	DOÑA ALFIA	0512	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	20.70	426	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
b4199ef8-7fe0-4fd3-808d-54c581d59690	EL MALO I	02350	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	\N	\N	\N	\N	5fb86b04-e3a4-47af-81fa-11ec0d974b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
5bd690d7-96ce-43f0-bf3e-2c8d0680ef4a	ANA III	5962	\N	472b1dab-fa91-4394-a855-d972ba9d3441	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	\N	\N	19.95	443	953117a0-3c04-4129-ab96-5eddf3a8d43a	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
f3b83055-e2c0-4b10-be5f-feaf85c08a10	DON AGUSTIN	6326	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	\N	\N	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
23933ebc-25ed-4076-a660-918914e94ff8	DON CARMELO	6126	\N	472b1dab-fa91-4394-a855-d972ba9d3441	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	19.04	424	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
987cf484-ea9e-42f3-87a0-b61c1276b402	DON FRANCISCO I	02562	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	66.55	1776	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
2765e72c-d892-498e-bc4e-2bab9203a6bd	DON GIULIANO	0002025	\N	472b1dab-fa91-4394-a855-d972ba9d3441	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	17.10	220	5fb86b04-e3a4-47af-81fa-11ec0d974b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
fbcd49eb-f023-4a1c-81fb-576b8d552781	DON JOSE	6044	\N	472b1dab-fa91-4394-a855-d972ba9d3441	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	16.49	269	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
0c3cb200-f011-4dff-a053-092fa3567310	DON JUAN ALVAREZ	0003300	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	9e25d139-f360-4a6d-aece-eaddec5adb62	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
25191258-3e0b-4319-b0f2-1edef479630f	DON NICOLA	6545	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	28.14	856	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
b4b86d73-4128-4924-890a-552cf3b2fecc	DON RAIMUNDO	6277	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	25.60	624	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
889920d2-e9aa-4c4c-9d3b-715ff67c87ff	DON TURI	6424	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	28.62	839	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
15660837-e683-416e-bc41-30543dcf54dc	DON VICENTE VUOSO	5439	\N	472b1dab-fa91-4394-a855-d972ba9d3441	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	20.69	537	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
261693e5-a863-48cb-bbae-8d605add7b3f	DON GAETANO	6513	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	a7c270d2-3ec4-436a-bbfe-4359d46b0b22	\N	32.10	889	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
db92560f-358e-446b-90cb-04d47bb9cf3d	DESAFIO	6125	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	29.56	850	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
222bdd21-a2be-40f3-851c-b7ee93de58c8	EL MARISCO I	0912	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	27.22	426	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
4e9a0baf-3dd4-4263-b102-2d324d945ed6	EMPESUR II	01439	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	\N	\N	\N	\N	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
d82afb3f-f7cd-4ba2-9c97-9ead2fd27360	EMPESUR III	01438	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	\N	\N	\N	\N	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
88f587a2-9553-470c-ad0b-80c56930fcd4	EMPESUR V	02650	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	\N	\N	30.52	1369	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
e606212c-15dd-4c10-927a-1de712821143	EMPESUR VI	02983	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	\N	\N	35.03	1289	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
539876b6-91fe-4be0-8b5f-1edaa00df3fb	EMPESUR VII	03045	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	\N	\N	35.03	1290	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
3c64a01e-e4f4-40e6-bd97-37b2182c2c1a	El marisco s.a	02070	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	\N	\N	\N	\N	953117a0-3c04-4129-ab96-5eddf3a8d43a	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
1d7738aa-e620-4cb8-b5e3-67b666ab2fcc	ENTRENA UNO	02069	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	\N	\N	33.10	839	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
9c4301d9-619e-4720-ba46-e93af5ff432d	ERIN BRUCE	0537	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	\N	\N	53.60	2252	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
c80de1a0-34ec-49f4-9362-5f68ed8c6c78	ESAMAR N° 4	0467	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	\N	\N	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
d635b12a-acfe-47cc-8d66-2792c15d81b0	ESPADARTE	02048	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	68.20	1529	aa748f6a-602b-4346-b964-50cbcea76146	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
8504ec84-b013-43cb-bf94-9d574f26b451	ESPERANZA 909	02577	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	72.34	1678	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
f7bb5c59-bac0-4435-a454-0d7fd854c351	ESPERANZA DEL SUR	02751	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	\N	\N	792484d9-dc51-4a9d-b9a5-d28c9047bcf0	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
ad0f88f3-4c5b-4b66-9172-3431d5995675	ESPERANZA DOS	06264	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	\N	\N	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
6bfb3cdf-e05b-426b-931c-d73c3e58bbbd	ESPERANZA UNO	06113	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	\N	\N	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
fc8a6a87-8f2f-447d-a417-da9cecc5178d	ESTEIRO	6328	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	\N	\N	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
ccd2a97c-965a-4ef6-bb66-a8ab45583314	ESTHER 153	02058	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	55.10	1252	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
6e1142f4-9f91-4f58-9536-0c8c1a857684	ESTRELLA N° 5	0246	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	54.20	1601	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
701a8b60-deb8-4299-928c-d6e41955c338	ESTRELLA N° 6	012	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	55.85	1581	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
84861910-cc58-42a8-8307-fad1dd39c54c	ESTRELLA N° 8	0242	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	\N	\N	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
c0d13f3c-47a3-4e5e-afcc-9ddc38abb92c	FE EN PESCA	0226	\N	12be2a02-6821-4e6f-9980-9d80b0866c8f	\N	\N	\N	\N	\N	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
0cb80167-3447-48b2-bdee-7c6c3d7e09e8	FELIX AUGUSTO	0581	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	\N	\N	27.80	601	953117a0-3c04-4129-ab96-5eddf3a8d43a	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
9af58d33-ac30-493f-9f39-9aa549076346	EL MARISCO II	0915	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	1985bde5-8964-4250-b775-74cc7469ed58	\N	56.30	1407	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
b2d6a59b-7aba-4b63-b683-bc25aca8091f	API XII	3213	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	9e25d139-f360-4a6d-aece-eaddec5adb62	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	\N	\N	\N	953117a0-3c04-4129-ab96-5eddf3a8d43a	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	
040eac5c-9520-4870-bbeb-08f72b1257cd	FEDERICO C	3190	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	\N	37.68	1400	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
a4d7c454-cc68-4c7f-a668-73f965a7b421	FERNANDO ALVAREZ	0013	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	\N	36.60	1168	953117a0-3c04-4129-ab96-5eddf3a8d43a	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
add36cbf-e4bc-4a04-9e59-a5cc3394e128	FLORIDABLANCA II	0252	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	\N	\N	\N	\N	953117a0-3c04-4129-ab96-5eddf3a8d43a	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
19a914b0-7e1d-4d04-af2c-89116f46c26f	FLORIDABLANCA IV	0255	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	\N	\N	\N	\N	c08082e7-f85e-4434-ab74-860bc02f07a1	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
653ced42-7927-4af2-ba3b-2bb6e30525aa	FONSECA	0920	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	62.40	2003	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
43fd7b21-e679-4e06-9933-9dacba479815	FU YUAN YU 636	02195	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	\N	\N	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
c2b8da78-a4a0-4ac1-898c-e8cbfc3e104a	FUEGUINO I	0331	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	\N	\N	953117a0-3c04-4129-ab96-5eddf3a8d43a	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
23461cb3-9755-4524-b26a-57eeb57a2255	GALA	02722	\N	472b1dab-fa91-4394-a855-d972ba9d3441	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	15.20	256	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
494c0700-4073-4fb7-a5d6-64b6afb5c37e	FRANCA	5926	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	27.29	493	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
e8e309ec-757a-4d86-9094-2162f96db0fe	FLORIDABLANCA	5936	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	27.67	541	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
84d1ea11-7769-4e70-abd9-6b716ba2c1b6	EMILIA MARIA	5977	\N	472b1dab-fa91-4394-a855-d972ba9d3441	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	22.60	521	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
49b605b3-5ac0-40ee-8c58-cca6fe0cbb30	ESPARDEL	0003211	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	
ce913a90-01c5-45ec-be08-2d1dfb5d47b8	DON SANTIAGO	6285	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	\N	26.55	776	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
bcc3e1f2-37c5-4732-b92e-eeb0d4da3934	ESTEFANY	6279	\N	472b1dab-fa91-4394-a855-d972ba9d3441	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	23.60	530	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
3e2da17d-9de8-4654-a574-15301de07b22	GALEMAR	5078	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	\N	\N	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
a03b8648-7869-4c74-914a-807118aa33ba	GIANFRANCO	01075	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	\N	\N	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
337ea87d-bbea-4f00-adcc-bc753aac9cad	GIULIANA	02633	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	\N	\N	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
ba71c5dc-1a4c-4f90-bde4-89f260da6622	GLORIA DEL MAR I	01983	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	54.30	1600	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
b0bc83c6-50f7-404e-8f6c-7a251e94bb70	GRACIELA	0578	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	\N	\N	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
de862f81-ac48-4e60-9070-5e59f9d4f61b	GURISES	01386	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	25.20	546	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
cae6df3f-8d02-43c9-b7dd-801412b1bf3f	GUSTAVO R	0075	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	\N	\N	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
2df3ab40-a0dd-4ff4-bed9-a6fcd6241182	HAMAZEN MARU N° 68	JA05	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	\N	\N	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
9cc83f28-33df-4dee-8752-19f6aedaa19c	LIBERTAD DEL MAR 1°	02186	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	\N	\N	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
213766ec-31ae-4ae2-b405-0b40d60bf726	LING SHUI N° 3	02210	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	\N	\N	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
411f4c24-f270-4104-a8e9-6a030bef2e00	LING SHUI N° 5	02211	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	\N	\N	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
bdc04ca1-2000-498d-8efa-40eccd9009b2	LUCIA LUISA	0623	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	27.90	463	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
f239fec6-c5b4-434d-a100-6efd2b3938c5	LUNES SANTO	01132	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	\N	\N	\N	\N	953117a0-3c04-4129-ab96-5eddf3a8d43a	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
4819cff5-8c9e-41eb-a44b-649d1ac9e712	MADRE DIVINA	01556	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	26.12	518	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
fb3b8a8a-5693-4194-994f-ee5ef8fb18b3	MADRE MARGARITA	02728	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	25.60	541	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
88e583f5-7122-4d72-ae94-f154c4b1a7ae	MAGDALENA MARIA  II	02208	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	\N	\N	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
51bbfa48-1947-4117-801c-33ef9d83a0b9	MALVINAS ARGENTINAS	0577	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	28.40	458	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
08ba4323-c66c-4a4f-aa62-f7e473735df0	MAR  AUSTRAL  I	0208	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	\N	\N	\N	\N	aa748f6a-602b-4346-b964-50cbcea76146	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
0e796127-c1d8-4c12-a8f5-d17f0db5e6c2	MAR AZUL	0934	\N	12be2a02-6821-4e6f-9980-9d80b0866c8f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
e81456a2-5c94-4b6f-8fc3-1291242db58d	JOSE AMERICO	03071	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	\N	44.21	\N	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
f7387d35-bd26-4af4-8c93-d64262662a69	MAR MARÍA	02960	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	\N	\N	37.80	1248	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
3a102c9b-0bb2-4ff4-b87a-93c7562297b4	MAR NOVIA 1	0115	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	\N	\N	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
78a4cd33-8258-4d3d-998d-4eadd01bc293	MAR NOVIA 2	0116	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	\N	\N	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
a28f62b9-edc5-4f48-a0b1-06d6f39296e6	SANTIAGO  I	02280	\N	12be2a02-6821-4e6f-9980-9d80b0866c8f	\N	\N	\N	\N	\N	953117a0-3c04-4129-ab96-5eddf3a8d43a	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
b3db4024-0ad6-482f-b7cc-18c2fbebb72c	MARA II	0209	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	\N	\N	\N	\N	953117a0-3c04-4129-ab96-5eddf3a8d43a	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
30cb9bc6-5739-4f87-9d39-2f3832cd7b1d	MARCALA IV	0351	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	\N	\N	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
06f815b6-1fc8-4a56-a596-6db23d9079fd	MAREJADA	01107	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	\N	\N	27.98	624	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
f389722c-85fb-4ef9-b45d-d36cf585afa0	LEAL	5914	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	27.45	601	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
83d08c9d-0eb0-4774-9bbc-97347c418bc8	LEKHAN I	6237	\N	472b1dab-fa91-4394-a855-d972ba9d3441	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	18.45	530	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
1fcee1ed-f340-4156-90c4-7b5a961686b3	LUCA SANTINO	0003121	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	\N	26.31	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
e78dcbb5-36d9-4aca-a151-e9c42a70cc09	LUIGI	0003244	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	\N	\N	\N	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
9f4add74-1811-4500-989d-ed8e40689cb2	MADONNINA DEL MARE	6086	\N	472b1dab-fa91-4394-a855-d972ba9d3441	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	23.78	601	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
9114dce3-f445-4554-897c-6657a2c0674c	MADRE INMACULADA	02378	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	62.80	1852	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
2732f2cf-d09a-46be-b4cb-d64e04f1790d	MARCALA I	6572	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	\N	\N	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
5a2c04fc-356e-46a8-9feb-e94ba81347b8	MAR ESMERALDA	000925	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	\N	\N	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
9fff7bc8-f541-4ae5-990c-ddfd0a0c7718	MARBELLA	6399	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	27.38	736	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
79841e78-cd00-4ede-ae56-ee11250a4ac0	ITXAS LUR	6459	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	9e25d139-f360-4a6d-aece-eaddec5adb62	1985bde5-8964-4250-b775-74cc7469ed58	\N	63.30	1952	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
5fd3c13c-0f2b-4dfd-911a-50c7460cad54	MAR DEL CHUBUT	5966	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	28.20	721	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
852ac376-cf3b-4b65-961d-4cbc3443e7f5	LETARE	5706	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	\N	\N	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
d0b2393d-528f-428d-9241-af06ad70b3d3	MARA I	6129	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	\N	\N	35.31	1209	953117a0-3c04-4129-ab96-5eddf3a8d43a	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
47b9f0b0-635d-440b-989f-f41657f7cab0	MARIA  LILIANA	01174	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	\N	\N	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
3b1315f7-65a5-4fb2-b1fe-e0686fc389cb	MARIA RITA	0436	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	30.95	541	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
9e042eaf-38d9-4b17-a753-fa0ee718f9b8	MARIA DEL VALLE	02126	\N	472b1dab-fa91-4394-a855-d972ba9d3441	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	16.29	196	5fb86b04-e3a4-47af-81fa-11ec0d974b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
a07f94e5-8ce7-495c-a565-054aaf5de08e	MARIA GLORIA	02738	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	28.05	851	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
5cd5d2dc-5396-4b94-8ed5-f9f03066158e	MATACO II	02243	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	\N	\N	953117a0-3c04-4129-ab96-5eddf3a8d43a	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
1a2d6b83-8c4d-452f-9a77-2c98c299eefb	MELLINO I	0379	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	47.25	1185	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
9649a473-87c4-49ce-afad-b9d834f9512d	PASA  82	0338	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	\N	\N	953117a0-3c04-4129-ab96-5eddf3a8d43a	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
95fbb557-9fcf-4953-9ffa-ae469e7621f1	MELLINO II	01424	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	38.91	795	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
874681b5-4db9-4188-af75-3cb78ac5e475	MERCEA C	0318	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	\N	\N	\N	29.15	866	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
ff0c6bf0-5f7c-4314-b1d9-dd05fcbe7249	MESSINA I	01089	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	27.29	650	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
fb5350a9-6d4e-4b84-9de7-98d8542220e0	MEVIMAR	01508A	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	\N	\N	\N	\N	953117a0-3c04-4129-ab96-5eddf3a8d43a	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
d6a30888-327d-4548-bfed-d71007b2a2dc	MILLENNIUM	0466	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	55.05	1329	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
c4e9bea8-2eec-4f6d-b958-fdf4424b19c1	MINCHOS OCTAVO	03022	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	\N	\N	39.30	579	953117a0-3c04-4129-ab96-5eddf3a8d43a	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
5f599afc-4e7c-4168-b114-a3d5a41c542c	MIRIAM	0370	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	\N	\N	36.35	1446	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
44e89bf0-7aed-4085-85c2-da3bbb8fc02a	MISHIMA MARU N°8	02175	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	63.43	1579	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
8e3dbbe7-0a31-4563-86b5-b33766d63eb2	MISTER BIG	0534	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	\N	\N	\N	\N	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
9a6a25b6-a686-4dfd-87ff-565f28a92d0d	MONTE DE VIOS	0664	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	\N	\N	\N	\N	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
84fa549b-42f6-46de-9d8e-458b2c4f652b	MAR SUR	0341	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	\N	36.40	889	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
42c2376e-1bf8-4960-82df-e66e8649671c	MISS PATAGONIA	0555	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	a7c270d2-3ec4-436a-bbfe-4359d46b0b22	\N	28.20	667	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
a00fb9df-72ef-4774-b4e8-2660c65f57ae	NINA	3171	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	\N	44.00	1620	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
07a74d76-74eb-41da-aa75-e2dc05a6923d	MARIA ALEJANDRA 1º	03074	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	\N	39.20	\N	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
c730a093-6360-4bd5-9c8a-125cc8fad7d7	MATEO I	02172	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	127f273e-086c-4e23-bb9e-0557fc9270aa	\N	67.97	1776	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
46a03afc-c320-432d-855d-d67e887a864b	NAVEGANTES II	01451	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	63.70	1603	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
f3a1d496-d7f0-4adf-8fd9-f6fb27d8269b	NEPTUNIA I	02125	\N	472b1dab-fa91-4394-a855-d972ba9d3441	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	\N	\N	5fb86b04-e3a4-47af-81fa-11ec0d974b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
693cd79d-4066-4582-828e-a98db6449339	NUEVA NEPTUNIA I	02634	\N	472b1dab-fa91-4394-a855-d972ba9d3441	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	20.00	403	5fb86b04-e3a4-47af-81fa-11ec0d974b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
161d07c1-1764-4410-a237-1187bd2cd1da	NUEVO ANITA	02100	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	\N	\N	30.90	765	953117a0-3c04-4129-ab96-5eddf3a8d43a	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
94b81f61-f4d2-43ab-9595-fc59453dc141	OMEGA 3	01391	\N	472b1dab-fa91-4394-a855-d972ba9d3441	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	\N	\N	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
00bff05d-89b4-4e6a-9637-f6f86106b08a	ORION  2	01492	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	\N	\N	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
63b9c992-804d-4246-9f88-e3bcb18d70f4	ORION 5	02637	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	65.62	1776	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
d5faf031-5e43-4cc4-85ba-a0fb88a8dafb	MARIANELA	5958	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	a7c270d2-3ec4-436a-bbfe-4359d46b0b22	\N	25.60	541	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
749e9cc2-277e-41ab-911d-e261516d5658	MARTA S	6012	\N	472b1dab-fa91-4394-a855-d972ba9d3441	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	23.90	503	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
e0d5ee3a-4a06-4bd7-bbfe-5219884f5058	MIERCOLES SANTO	6254	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	\N	\N	38.50	1244	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
025a4912-d514-4915-8022-ca6869387c40	MIURA MARU	5996	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	53.20	1482	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
d14ddc4a-523b-4cc2-a0ea-cdab105b0311	NIÑO JESUS DE PRAGA	0003194	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	27.74	1180	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
9698d1d7-e120-4b3b-adc4-ad136be492bd	NUEVA LUCIA MADRE	3967	\N	e087c76f-c23b-4bb8-b606-a61a7b0fba75	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	14.37	416	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
01848dba-0ced-4aec-8d7e-9325bec66253	MELLINO VI	5265	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	1985bde5-8964-4250-b775-74cc7469ed58	\N	64.87	1235	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
94cdec3d-4b9a-404e-85fd-09f39c8c15ce	NUEVO VIENTO	6092	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	22.23	541	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
aae37745-bc4e-4c34-8699-71dbd285a263	NDDANDDU	5956	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	\N	\N	28.20	856	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
d7c2aff3-460e-4b21-975b-d2c69e0aeaac	SIEMPRE SAN SALVADOR	00801	\N	472b1dab-fa91-4394-a855-d972ba9d3441	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	22.35	600	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
a47c8abe-c986-4863-9e80-84ea71cec992	ORION 1	01943	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	\N	\N	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
ee1fd88f-2c3a-460f-aaa8-40d6d5770cda	ORION 3	02167	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	63.10	1776	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
3d8e9fcd-268b-47a3-a4e3-b44306ece576	ORYONG  756	02092	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	\N	\N	953117a0-3c04-4129-ab96-5eddf3a8d43a	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
6c0f2d2f-d162-4a9b-8bb2-4b1994cf0b24	PACHACA	02572	\N	472b1dab-fa91-4394-a855-d972ba9d3441	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	17.64	320	5fb86b04-e3a4-47af-81fa-11ec0d974b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
c2f37dcf-e8d9-48bb-b2dc-3e515330af61	PADRE PIO	02822	\N	472b1dab-fa91-4394-a855-d972ba9d3441	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	24.00	451	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
9a69d9eb-bd33-4d0a-964a-96228e270aa0	PAGRUS II	01393	\N	472b1dab-fa91-4394-a855-d972ba9d3441	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	\N	\N	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
e2aa3397-f33b-42b5-b37b-324225a43687	PATAGONIA 1	02163	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	\N	\N	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
c5eba9d4-baa1-47d0-8ea5-eb32d55aa464	PATAGONIA 2	02164	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	\N	\N	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
3e85252d-59a2-46a0-8a5d-7936751e3b65	PATAGONIA BLUES	02176	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	64.45	1776	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
9bb47252-266c-4759-8dc8-d2193142da7a	PELAGOS	83	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	\N	\N	953117a0-3c04-4129-ab96-5eddf3a8d43a	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
67880b5f-d10b-408f-b879-5041372cd179	PENSACOLA I	0747	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	\N	\N	25.20	380	4a66c074-2c54-4ee1-bd44-9fe59a8de18f	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
371e228f-99c5-4dbd-88bb-03757151b160	PESCAPUERTA CUARTO	0171	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	\N	\N	953117a0-3c04-4129-ab96-5eddf3a8d43a	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
2205e156-fe1f-4818-b798-3623941abef3	PESCAPUERTA QUINTO	0538	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	\N	\N	953117a0-3c04-4129-ab96-5eddf3a8d43a	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
c36f19ab-4864-4ad9-8954-a1ca76bb8b3a	PESCARGEN  V	078	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	\N	\N	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
3a4038fc-dc73-4329-b2a6-3041f5db508e	PESCARGEN III	021	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	\N	\N	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
baa08ce8-be2b-4b83-b196-a32c4c6e6bba	PESCARGEN IV	0150	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	63.20	1603	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
3b1dbc72-3d7b-4ed5-855a-1e085727006a	PESPASA  II	0212	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	\N	\N	\N	\N	aa748f6a-602b-4346-b964-50cbcea76146	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
e89109bc-b664-4783-84e0-bb029ed1c21e	NONO PASCUAL	02854	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	\N	24.00	451	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
e9fbeea4-0b6f-4eb5-b322-36cc38037b2f	PEDRITO	TEMP-0005	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	\N	39.92	1201	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
498c3f95-ae8b-4fb2-842e-32f77a63cd5b	NATALIA	02066	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	127f273e-086c-4e23-bb9e-0557fc9270aa	\N	68.45	1779	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
80ff2772-dff0-42e3-b4af-371c1f446a5f	NANINA	02576	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	127f273e-086c-4e23-bb9e-0557fc9270aa	\N	72.08	1678	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
8460336f-582c-4a36-ac46-df3cd01972ec	PESPASA I	0211	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	\N	\N	\N	\N	aa748f6a-602b-4346-b964-50cbcea76146	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
9a8e9ff2-a69b-4076-a7df-c948223c17db	PETREL	01445	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	29.85	776	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
0bfc8bfc-4b33-40f1-82d5-8fafe1f9b137	PEVEGASA QUINTO	02312	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	\N	\N	38.65	740	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
51c99923-5b92-4477-9ad9-310f1ba3519c	POLARBORG I	02122	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	\N	\N	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
ce2bb353-4ef0-4ec8-a5f1-53d2d44dca77	POLARBORG II	02117	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	\N	\N	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
897997bb-b441-46b5-80db-7aa8a71177b6	PORTO BELO I	02699	\N	472b1dab-fa91-4394-a855-d972ba9d3441	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	23.98	600	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
dabaaa7c-4dda-45b7-a705-b49b9c79fe2c	PORTO BELO II	02790	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	23.98	601	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
c75ea5d7-a2ff-44e7-b2ee-c1eec3de270a	PROMAC	4815	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	33.45	721	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
861b42c1-ec07-4164-8a1d-6aa84363d701	PROMARSA I	072	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	\N	\N	\N	\N	953117a0-3c04-4129-ab96-5eddf3a8d43a	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
8979d7b4-c0a3-4505-8c67-dce58c5a1f0c	PROMARSA II	073	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	\N	\N	\N	\N	953117a0-3c04-4129-ab96-5eddf3a8d43a	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
e81f379a-ec61-48b2-bc12-c5eb4a559eb4	PROMARSA III	02096	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	\N	\N	35.84	1062	953117a0-3c04-4129-ab96-5eddf3a8d43a	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
768a90e8-09cd-42d0-b7ae-50c8bcfacf69	PUENTE AMERICA	0164	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	\N	\N	953117a0-3c04-4129-ab96-5eddf3a8d43a	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
6d392156-18f2-4798-a3a1-f08ccc547d8f	PUENTE MAYOR	02630	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	66.86	2416	953117a0-3c04-4129-ab96-5eddf3a8d43a	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
81b8893c-29ce-4df1-9c6e-90b3982e568d	ORION I	6011	\N	472b1dab-fa91-4394-a855-d972ba9d3441	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	20.90	520	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
e6aaeb6b-df2b-4024-ae09-19c98798c796	PATAGONIA	4645	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	30.95	660	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
035913c0-1bc6-4b1a-8656-1b2a92fcef90	PUENTE CHICO	6528	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	\N	\N	37.00	1175	953117a0-3c04-4129-ab96-5eddf3a8d43a	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
e83596ad-343b-4a98-aae9-36a776272408	PAKU	5211	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	\N	\N	39.16	1087	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
a1611fad-71d6-498c-947e-db5039df8d48	PUNTA BALLENA	65	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	f226ec5a-5b42-44aa-9e7d-947924dfced4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
069567ec-0121-419d-9dfe-611621673288	RAQUEL	01074	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	\N	\N	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
b138d5e1-2180-4de7-8fcf-14d0d9c96f97	REPUNTE	01120	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	\N	\N	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
bab28e8a-2172-42dd-850b-28a528d3fcd7	REYES DEL MAR II	0408	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	\N	\N	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
1440274d-d43b-44c0-83bf-f5a58fc453f6	RIBAZON DORINE	0921	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	\N	\N	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
58ff3fa6-5366-41f7-86cf-af180382e2e5	RIBAZON INES	0751	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	38.50	720	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
2e4e1268-64aa-4cb0-9d6e-09a914cd09ac	RIGEL	0266	\N	472b1dab-fa91-4394-a855-d972ba9d3441	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	\N	\N	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
8b086173-3c13-4f35-acdb-afbb690ca4fc	ROSARIO  G	0549	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	\N	\N	\N	\N	953117a0-3c04-4129-ab96-5eddf3a8d43a	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
b3d403b5-4105-4964-8026-f72d74be259c	RUMBO ESPERANZA	01211	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	\N	\N	\N	\N	4a66c074-2c54-4ee1-bd44-9fe59a8de18f	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
fe649a49-540e-4bd0-a797-4ee90dd3e6cc	RYOUN MARU N° 17	JA06-03	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	\N	\N	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
d9783513-e71a-4d07-9066-1ccfafb613e2	SAN ANTONINO	0375	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	\N	\N	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
2074f38b-7579-4d69-b4c6-a4006b6be9ff	SAN BENEDETTO	02643	\N	472b1dab-fa91-4394-a855-d972ba9d3441	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	15.38	220	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
f2f9778b-4afa-4729-80c5-e42a5d92afd4	SAN GENARO	0763	\N	472b1dab-fa91-4394-a855-d972ba9d3441	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	\N	\N	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
e0ddb3b7-34f4-4473-8211-0e6c585ab6bd	PIONEROS	02735	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	13c3c551-df0d-4c62-a185-d36a0298672a	\N	\N	\N	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
7e7de950-28ea-49ac-af70-269988863345	VALERIA DEL ATLÁNTICO	02098	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	9e25d139-f360-4a6d-aece-eaddec5adb62	cb20a7a1-e40f-4cb1-af07-8e5273dd0237	\N	56.46	4698	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
881c9a5b-7d9d-45d9-91b1-ac3bb7b43e48	SAN JUAN B	TEMP-0007	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	\N	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	\N	39.94	1204	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
ddc66628-733e-4983-889a-c00b2d4cc9a2	PUENTE VALDES	02205	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	127f273e-086c-4e23-bb9e-0557fc9270aa	\N	58.15	1383	953117a0-3c04-4129-ab96-5eddf3a8d43a	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
6a6a1777-bd99-4215-8322-e830aa58e9fc	SALVADOR R	02755	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	\N	27.73	420	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
897bfc6b-83fc-4712-a1e3-79d0bbcfefe8	SAN LUCAS  I	06147	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	\N	\N	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
446a5668-1100-490a-945a-46a59e85ccde	SAN MATEO	06306	\N	472b1dab-fa91-4394-a855-d972ba9d3441	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	54.10	1234	5fb86b04-e3a4-47af-81fa-11ec0d974b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
41647240-a474-456d-9de4-7202716d3c53	SAN PABLO	0759	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	\N	\N	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
c33c39c4-a06c-4de5-986b-c2982832dfb8	SAN PASCUAL	0367	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	\N	\N	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
b5b3355c-d19d-4b54-931e-c350a3a8773c	SAN PEDRO APOSTOL	01975	\N	472b1dab-fa91-4394-a855-d972ba9d3441	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	\N	\N	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
5bc27a37-ed86-417a-b011-68edcafd47b8	SANT ANTONIO	0974	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	\N	\N	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
a8932205-b6ff-43fa-baf9-167758ad018d	SANTA BARBARA	5857	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	56.96	1679	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
ead9827d-d466-4bb8-a5a4-4da0b14f4c21	SANTA ANGELA	009	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	\N	\N	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
e1be23ed-e3b4-4b38-a766-6cc0cfa2c974	SCOMBRUS	0509	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	\N	\N	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
8fcb3120-3e08-4f9e-9883-644d7ed066e7	SCOMBRUS  II	02245	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	\N	\N	\N	\N	953117a0-3c04-4129-ab96-5eddf3a8d43a	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
372acf58-c75b-45e7-a79a-a2402ec21913	SHUNYO MARU 178	JA04	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	\N	\N	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
db3de0e6-b104-402d-95a7-b8d320d01fd0	SIEMPRE DON JOSE MOSCUZZA	02257	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	38.00	1128	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
a8d851f1-a200-4f16-b44c-4525abec1b0b	SIEMPRE DON VICENTE	02654	\N	472b1dab-fa91-4394-a855-d972ba9d3441	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	18.94	341	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
43ecc3bd-4313-44c4-a825-1143e2674fc9	Hai Xiang 16	0003329	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	127f273e-086c-4e23-bb9e-0557fc9270aa	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
7ab5a2ca-ba98-4b02-b7c2-f144a5f055d4	PUENTE SAN JORGE	6095	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	\N	\N	35.30	1001	953117a0-3c04-4129-ab96-5eddf3a8d43a	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
bbc5a90f-2320-46fa-af87-93519487a696	RAFFAELA	6224	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	3750f533-77c8-405f-8a00-bf0ba0353a4d	\N	26.50	624	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
93a954ca-e193-4df5-b21a-1b61045498c7	ROCIO DEL MAR	6089	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	22.60	541	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
c993cfea-a690-4457-964f-b45d769f1da8	JOSE LUCIANO	0003230	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	351bae45-1535-472c-91c4-1a8a22bb3ff1	\N	\N	\N	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	
487561a4-9930-4a0b-8236-6c6ae0315686	PONTE DE RANDE	6483	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	9e25d139-f360-4a6d-aece-eaddec5adb62	1985bde5-8964-4250-b775-74cc7469ed58	\N	79.14	2964	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
7292335b-0d19-48d1-bdf2-f123123004e9	SAN JORGE MARTIR	5242	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	56.10	1408	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
afe66325-7065-42be-a358-c5df5e779e63	SERMILIK	6501	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	\N	\N	\N	\N	953117a0-3c04-4129-ab96-5eddf3a8d43a	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
449dabd7-2871-46b6-a9b1-f596fa19815f	QUEQUEN SALADO	5066	\N	472b1dab-fa91-4394-a855-d972ba9d3441	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	19.45	271	5fb86b04-e3a4-47af-81fa-11ec0d974b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
c76fb833-f54e-4004-b49f-c77e0faa2e5a	SAN ANDRES APOSTOL	5900	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	54.56	2269	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
cdcaf051-9d97-4637-a32b-7cc3279dd245	SIMBAD	0754	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	\N	\N	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
d691bb70-7c9c-40bb-b188-a8c2c9091b32	SIRIUS	0905	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	\N	\N	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
fb23ddbb-42f9-413e-a845-b57ed8297aeb	SIRIUS III	0937	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	\N	\N	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
9d8ee5b2-a5e5-44fd-b76f-2b028316e1ea	SOL MARINO	77	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	\N	\N	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
63b0e1e2-181d-4152-b7a5-1a2e5300515e	STELLA MARIS 1°	0926	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	\N	\N	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
b21a0079-98af-4f76-bb56-af57b9368e61	SUEMAR	6186	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	\N	\N	36.60	1168	953117a0-3c04-4129-ab96-5eddf3a8d43a	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
58617ac8-da9b-428e-b526-e48eb11cc128	SUEMAR DOS	01508	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	\N	\N	\N	\N	953117a0-3c04-4129-ab96-5eddf3a8d43a	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
df7207a7-5194-49fe-a3b2-2205ba5201b3	SUMATRA	01105	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	33.15	750	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
bee38621-698d-4595-a9f3-57c9e34b3e7d	SUR ESTE 501	01077	\N	12be2a02-6821-4e6f-9980-9d80b0866c8f	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	\N	\N	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
c8803619-9272-4f45-bbb6-e6b7a0816eb7	SUR ESTE 502	02201	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	54.60	1670	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
31987990-b984-4b50-ab0e-d04200d9487a	SURIMI I	06143	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	\N	\N	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
0d29fb06-e629-4323-b90b-d338bd6f3556	TABEIRON	02233	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	\N	\N	34.15	889	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
1b3f62a8-6a18-4f45-9de0-2c67af1d2bdc	TABEIRON DOS	02323	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	\N	\N	\N	\N	aa748f6a-602b-4346-b964-50cbcea76146	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
3d9d190e-1ba7-4cae-93bc-8489506c92e2	Nº 75 TAE BAEK	02364	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	55.70	1302	953117a0-3c04-4129-ab96-5eddf3a8d43a	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
7dccb7c6-f37b-4212-8b98-ad35442b3d7a	Nº 606 TAE BAEK	02361	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	55.22	1036	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
7f612c31-bf98-4428-b0b5-3ecf7bb6fd3b	TAI SEI MARU N°8	02207	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	\N	\N	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
f1b37e20-ec28-442f-aecb-290a35045124	SOHO MARU 58	02611	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	127f273e-086c-4e23-bb9e-0557fc9270aa	\N	65.67	1776	aa748f6a-602b-4346-b964-50cbcea76146	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
23b0b034-d3ff-4ffc-84cc-8d1e6d3f2b98	TIAN YUAN	02173	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	\N	\N	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
e5d48bb8-0412-438a-93ee-be82aecbdb6a	TOBA MARU	0241	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	\N	\N	953117a0-3c04-4129-ab96-5eddf3a8d43a	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
a7e20a7e-54d4-4489-87cc-33538e84307f	TORNYY	240	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	1eeb0dff-da3b-4dfa-8fe2-e415f817921d	\N	\N	\N	\N	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
25247dca-ab95-4be1-9bd4-e545985bbde6	TRABAJAMOS	02904	\N	472b1dab-fa91-4394-a855-d972ba9d3441	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	19.94	592	aa748f6a-602b-4346-b964-50cbcea76146	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
4de14196-8801-4195-b42d-53ef78369722	UCHI	01901	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	\N	\N	54.23	1552	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
7cc154cf-ac66-46d5-88e8-c48de994f99a	UNION	01539	\N	472b1dab-fa91-4394-a855-d972ba9d3441	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	\N	\N	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
73c9a934-c3ad-4f1e-bc08-57bbdb5727a3	URABAIN	0612	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	\N	\N	953117a0-3c04-4129-ab96-5eddf3a8d43a	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
64246c0f-89f7-43a9-97d9-fd5d4fc11676	VERONICA ALEJANDRA N	02292	\N	472b1dab-fa91-4394-a855-d972ba9d3441	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	15.30	223	5fb86b04-e3a4-47af-81fa-11ec0d974b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
d1fa8b6e-e070-4316-a980-025f9e778da1	VICTOR ANGELESCU	9798820	\N	48bb265f-b2b9-4f62-9419-24773575b6f1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
3428d93d-9fd1-4183-8157-f536dcb51429	VICTORIA DEL MAR 1°	0929	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	\N	\N	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
aa457a2e-2121-4ac7-a22d-9899026781b1	VICTORIA P	02246	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	\N	\N	\N	\N	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
bc28ce31-85ab-4234-8ad6-5165bbed8964	VIEIRASA DIECISEIS	0240	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	\N	\N	36.13	702	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
b96eb56c-f54e-4a39-ad03-f7d68245044e	SCIROCCO	02574	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	127f273e-086c-4e23-bb9e-0557fc9270aa	\N	65.93	1589	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
de912164-b6dd-4126-a5aa-4ec563018825	SFIDA	6222	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	\N	26.50	624	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
20e56eef-3ce3-4d93-9038-bb71d42a87e1	SIEMPRE SANTA ROSA	5879	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	27.80	548	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
46080556-856a-437c-9110-16505a9c3e52	SIEMPRE VIEJO PANCHO	02937	\N	472b1dab-fa91-4394-a855-d972ba9d3441	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	17.98	601	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
82494cce-5a6c-4fdd-a45a-fecad9b29ce4	VICTORIA I	5847	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	\N	\N	953117a0-3c04-4129-ab96-5eddf3a8d43a	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
12408400-f817-4ac0-a18d-8896aeb8dd9c	VIEIRASA DIECIOCHO	02563	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	67.78	1803	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
b55704fd-af0d-4312-8374-0c457812e9a2	VICTORIA II	5892	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	\N	\N	27.40	601	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
1ae949b6-6424-4a96-9c9f-4d959d87a0c5	SIRIUS II	5355	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	1985bde5-8964-4250-b775-74cc7469ed58	\N	59.25	1289	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
0acac712-430b-4fbf-a9da-8557f3efa085	VALIENTE II	6185	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	\N	\N	35.30	1001	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
07bf4873-dc67-4644-b743-28302ef7f218	VIEIRASA QUINCE	0179	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	\N	\N	\N	\N	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
dc6b8be3-f0e9-4306-8b76-88b9f81f9d11	VIENTO DEL SUR	01858	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	\N	\N	aa748f6a-602b-4346-b964-50cbcea76146	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
31a2add6-4adc-45fd-a5d3-2f3dc0f5bd46	VILLARINO	02178	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	64.50	1776	e6506238-633f-446e-a498-2eedf4f5dcc5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
d84d1a10-13d2-4952-aab7-dd8c41799563	VIRGEN DEL CARMEN	0550	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	\N	\N	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
6ca0de1f-72ce-47a2-a7d1-8640bfb53e7e	VIRGEN DEL MILAGRO	02767	\N	472b1dab-fa91-4394-a855-d972ba9d3441	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	19.93	380	aa748f6a-602b-4346-b964-50cbcea76146	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
56a7aa73-510d-4d91-8d04-de6b58b05ae1	VIRGEN DEL ROCIO	0194	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	\N	\N	\N	\N	953117a0-3c04-4129-ab96-5eddf3a8d43a	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
bf9cc2cb-aa31-4603-a1ae-952613640e31	VIRGEN MARIA INMACULADA	0369	\N	472b1dab-fa91-4394-a855-d972ba9d3441	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
4d7e1e39-66c1-4d00-b18e-ae28a3e4fdba	WIRON  IV	01476	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	\N	\N	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
779608ae-f2fd-4055-a151-b69bb6239351	XIN SHI DAI N° 28	02165	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	62.40	1579	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
dba3dda6-71cd-4d9b-84d6-7d52195b4c23	XIN SHI JI N° 88	02182	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	\N	\N	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
95606ecc-d28e-4cd9-b894-dcc25d25c893	XIN SHI JI N° 99	02181	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	65.10	2173	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
5eb2fb48-c87e-4b12-a8b0-c40d58328777	YAMATO	077	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	\N	\N	792484d9-dc51-4a9d-b9a5-d28c9047bcf0	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
5e6a164c-0033-4b3e-bed1-34dd6b81f8f8	YENU	0498A	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	\N	\N	\N	\N	c08082e7-f85e-4434-ab74-860bc02f07a1	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
f67407ef-4e7a-4aed-86ab-4e3b5aa1c6f1	YOKO MARU	UY252	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	\N	\N	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
15997dea-a301-4800-a7f0-01f6895fc2c6	ZHOU YU YI HAO	CH251	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	\N	\N	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
5c4ff6be-aee4-4b9c-a8ba-5dcc44e12164	MAR ARGENTINO	9883833	\N	48bb265f-b2b9-4f62-9419-24773575b6f1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
0b03eed0-e253-4914-8683-24e4f03a00f7	CAPESANTE	02929	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	83867dcf-3fe0-4b78-8470-aabe5c344bda	\N	50.15	2550	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
377b5ead-3c81-4651-ba39-035d8aa8057d	TANGO I	02724	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	1eeb0dff-da3b-4dfa-8fe2-e415f817921d	13c3c551-df0d-4c62-a185-d36a0298672a	\N	50.40	1302	aa748f6a-602b-4346-b964-50cbcea76146	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
f749d131-dad5-4391-9239-d3eff37d4e93	TANGO II	02791	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	1eeb0dff-da3b-4dfa-8fe2-e415f817921d	13c3c551-df0d-4c62-a185-d36a0298672a	\N	50.40	1302	aa748f6a-602b-4346-b964-50cbcea76146	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
a8956f2f-f8e4-4387-8fa3-48ea20c38489	ARGENOVA XXI	02661	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	9e25d139-f360-4a6d-aece-eaddec5adb62	cb20a7a1-e40f-4cb1-af07-8e5273dd0237	\N	55.80	1826	aa748f6a-602b-4346-b964-50cbcea76146	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
c9e13553-2541-4186-a463-7d27e0278645	MYRDOMA F	02771	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	\N	38.55	1430	953117a0-3c04-4129-ab96-5eddf3a8d43a	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
c4e6cd7e-ba70-4080-b4dd-49361dd03287	XEITOSIÑO	6307	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	9e25d139-f360-4a6d-aece-eaddec5adb62	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	\N	51.72	1502	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
cbe3f8c1-3200-4a53-b521-0aa4d2c8d9d1	HOYO MARU 37	02624	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	127f273e-086c-4e23-bb9e-0557fc9270aa	\N	\N	\N	aa748f6a-602b-4346-b964-50cbcea76146	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
f0ceae5a-078a-4fd8-a6e7-7fb772f058c2	TOZUDO	6040	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	a7c270d2-3ec4-436a-bbfe-4359d46b0b22	\N	26.74	624	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
4ce964a6-9e77-43e3-9dff-6609a4675e41	UR ERTZA	6508	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	1985bde5-8964-4250-b775-74cc7469ed58	\N	51.00	1482	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
b5f9e522-e915-4778-abfc-e0b5bb4ff42e	VERDEL	6593	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	9e25d139-f360-4a6d-aece-eaddec5adb62	1985bde5-8964-4250-b775-74cc7469ed58	\N	71.70	1975	c08082e7-f85e-4434-ab74-860bc02f07a1	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
606a0825-f4e0-4d10-a6d0-add35c837a28	VIEIRASA DIECISIETE	02568	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	127f273e-086c-4e23-bb9e-0557fc9270aa	\N	59.03	1401	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
4a8e0a76-a896-4f17-ab23-56cbb32a6d4b	VIRGEN MARIA	5327	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	1985bde5-8964-4250-b775-74cc7469ed58	\N	56.65	1803	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
e5f98dee-98ed-435f-9428-cea5c885ea77	XIN SHI JI 25	0003092	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	70.50	\N	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
ff865d20-56b0-4132-a43f-946880a0cfae	XIN SHI JI Nº 98	0002995	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	\N	\N	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
db5184e9-a320-47ba-92fe-461816b15ebd	XIN SHI JI Nº 89	0002903	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	68.58	2685	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
a3f2bab0-fe16-4116-9fdd-68bd3b61ceec	XIN SHI JI Nº 91	0002924	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	68.58	2685	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
fca5c56d-d00d-437d-98cb-b419abdebf07	XIN SHI JI Nº 92	0002930	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	68.58	2685	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
10223029-25d4-4d43-9e15-c592b8c57e39	XIN SHI JI Nº 95	0002933	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	68.58	2685	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
9f856e4d-b432-438b-a642-57c8fdc43e38	TESON	6079	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	a7c270d2-3ec4-436a-bbfe-4359d46b0b22	\N	25.97	765	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
70bb03e8-6c63-4397-a603-64b7e0f28e97	VALIENTE I	6184	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	\N	\N	\N	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
abc3ee47-f2ee-42bf-9637-d22f3a7935dc	PONTE CORUXO	0975	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	1985bde5-8964-4250-b775-74cc7469ed58	\N	52.85	1383	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
d1f683c2-69b1-4ab5-86e2-51f1a456b827	MINTA	02196	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	127f273e-086c-4e23-bb9e-0557fc9270aa	\N	65.10	1603	f3d2726d-273b-4876-8181-2bad234708b5	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
bf67761e-0c77-4360-8eee-fdec0487fef9	NAVEGANTES III	02065	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	127f273e-086c-4e23-bb9e-0557fc9270aa	\N	68.60	2203	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
c8f549d2-ef48-4931-82db-5f6650dd4dfb	DON LUIS I	02093	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	127f273e-086c-4e23-bb9e-0557fc9270aa	\N	67.95	1803	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
9ae2162e-df62-40f7-8d62-8d1da7dc803c	ALVAREZ ENTRENA V	2279	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	
169f1b5f-2325-4dd6-af4f-72cb7e86b741	ARBUMASA XXVII	02057	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	127f273e-086c-4e23-bb9e-0557fc9270aa	\N	64.21	1154	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
f8654d33-21f3-41fe-88ab-adfda41d4871	ARBUMASA XXVIII	02569	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	127f273e-086c-4e23-bb9e-0557fc9270aa	\N	64.40	1776	aa748f6a-602b-4346-b964-50cbcea76146	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
75c6f9df-0db0-4c13-98ed-8b3bc4c475e4	HOLMBERG	7918189	\N	48bb265f-b2b9-4f62-9419-24773575b6f1	\N	83867dcf-3fe0-4b78-8470-aabe5c344bda	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
d73fdcef-e978-44ca-a105-6066e9d96445	MISS TIDE	02439	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	83867dcf-3fe0-4b78-8470-aabe5c344bda	\N	52.52	2254	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
f4f48e38-8826-4db0-a659-951dee4e373f	ATLANTIC SURF III	02030	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	83867dcf-3fe0-4b78-8470-aabe5c344bda	\N	49.60	3020	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
d6a63e1c-e893-4c06-9425-2f9f8b8c1f37	PRINCIPE AZUL	TEMP-0006	\N	472b1dab-fa91-4394-a855-d972ba9d3441	9e25d139-f360-4a6d-aece-eaddec5adb62	3750f533-77c8-405f-8a00-bf0ba0353a4d	\N	\N	\N	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
1b2c15e0-ece3-4c58-8334-079d6d844c0e	DUKAT	02775	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	1eeb0dff-da3b-4dfa-8fe2-e415f817921d	13c3c551-df0d-4c62-a185-d36a0298672a	\N	50.80	1302	aa748f6a-602b-4346-b964-50cbcea76146	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
2682d1b5-20fd-4a53-b251-7ddcdab963c1	CHIYO MARU Nº 3	02987	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	1eeb0dff-da3b-4dfa-8fe2-e415f817921d	13c3c551-df0d-4c62-a185-d36a0298672a	\N	52.80	937	792484d9-dc51-4a9d-b9a5-d28c9047bcf0	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
7a0ed70d-e0c9-40ed-8167-389c0fe10e52	DON PEDRO	6205	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	9e25d139-f360-4a6d-aece-eaddec5adb62	1985bde5-8964-4250-b775-74cc7469ed58	\N	\N	\N	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
9501be2a-5bc6-4062-ad1e-2aebfa92af0c	VENTARRON 1º	6041	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	9e25d139-f360-4a6d-aece-eaddec5adb62	1985bde5-8964-4250-b775-74cc7469ed58	\N	63.07	1969	953117a0-3c04-4129-ab96-5eddf3a8d43a	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
2fcd5f0c-5940-4e70-83a9-f1408ec444f3	7 de Diciembre	5908	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	27.20	521	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
bff09be7-99bd-4c7a-8448-3a2887ee2930	ALVAREZ ENTRENA VI	0003047	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	\N	\N	30.50	1033	953117a0-3c04-4129-ab96-5eddf3a8d43a	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
b5b9faa1-ba43-465c-a3c1-3c828aaeb561	ANTONINO	6317	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	27.60	541	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
ebdb90ca-16a1-4523-ab69-aacd1cfdae6b	API VII	0003081	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	9e25d139-f360-4a6d-aece-eaddec5adb62	1985bde5-8964-4250-b775-74cc7469ed58	\N	72.20	\N	953117a0-3c04-4129-ab96-5eddf3a8d43a	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
b7b3a805-a054-4d0a-b905-9ef6b9ae8548	PUERTO WILLIAMS	0003178	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	\N	\N	792484d9-dc51-4a9d-b9a5-d28c9047bcf0	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
fadfa149-546e-4dd2-b3b8-caea5b867715	CERES	6422	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	9e25d139-f360-4a6d-aece-eaddec5adb62	1985bde5-8964-4250-b775-74cc7469ed58	\N	60.74	1969	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
efde9ce0-55e7-4fc1-a21c-feb6884fd56b	DON CAYETANO	5874	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	47.10	1503	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
5b11295e-6b0b-4983-ade2-4c94e98cc8d0	ECHIZEN MARU	6488	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	9e25d139-f360-4a6d-aece-eaddec5adb62	cb20a7a1-e40f-4cb1-af07-8e5273dd0237	\N	89.59	4702	792484d9-dc51-4a9d-b9a5-d28c9047bcf0	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
a397d1d5-26e5-4ffc-ac41-178ce080b586	EL SANTO	5970	\N	472b1dab-fa91-4394-a855-d972ba9d3441	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	\N	\N	aa748f6a-602b-4346-b964-50cbcea76146	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
af79bace-7650-4a0c-bc89-093d01dae7c5	ERIN BRUCE II	0003251	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	83867dcf-3fe0-4b78-8470-aabe5c344bda	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
eb1c36cf-265e-49d0-be00-373d54d77413	FRANCO	6080	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	\N	\N	\N	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
2aff9c4d-d433-40ee-b8e8-4b65c87e599a	GRAN CAPITAN	5301	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	25.43	541	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
88b34cd5-d857-4431-ae65-85acf97b13aa	Hai Xiang 17	0003286	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	127f273e-086c-4e23-bb9e-0557fc9270aa	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
d92e08b1-d48d-4984-84b5-6de5c5c4f0d7	HUAFENG 816	5994	\N	472b1dab-fa91-4394-a855-d972ba9d3441	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	22.60	521	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
6e9f9214-77a7-4b73-888e-25044de6192d	HUYU 907	0003027	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	4f54264c-4a35-48b2-adf7-15a31cd493f0	\N	\N	72.17	1678	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
18b98431-a4a2-463b-ae58-c784bcf1ae44	JOSE MARCELO	0003138	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	\N	39.94	\N	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
57564db2-64d0-48ce-950d-1a6b7c9202cc	MARGOT	5008	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	1985bde5-8964-4250-b775-74cc7469ed58	\N	58.75	1481	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
db0b87f1-28e5-477e-abcf-9a990bccfaf6	NAVEGANTES	6246	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	9e25d139-f360-4a6d-aece-eaddec5adb62	1985bde5-8964-4250-b775-74cc7469ed58	\N	58.00	1925	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
fd6812be-a614-4ab3-83f5-6c888962c269	SAN MATIAS	01213	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	\N	\N	\N	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
7b0a7e6a-a71b-43b0-b9e2-cca0b5518ab0	TAI AN	01530	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	9e25d139-f360-4a6d-aece-eaddec5adb62	cb20a7a1-e40f-4cb1-af07-8e5273dd0237	\N	100.50	4506	792484d9-dc51-4a9d-b9a5-d28c9047bcf0	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
945b3158-6a8c-4360-97ad-0f50574e46a9	TALISMAN	6327	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	1eeb0dff-da3b-4dfa-8fe2-e415f817921d	13c3c551-df0d-4c62-a185-d36a0298672a	\N	49.95	1302	aa748f6a-602b-4346-b964-50cbcea76146	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
a8bd988c-969c-4a2e-89ae-d0f409866ac0	VERAZ	5943	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	\N	\N	27.45	604	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
210ffb51-daba-4d2b-93fb-b4915bd47552	LUCA MARIO	6571	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	9e25d139-f360-4a6d-aece-eaddec5adb62	1985bde5-8964-4250-b775-74cc7469ed58	\N	79.14	3952	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
1bc94c4d-8291-4f35-abaf-dfd4bab5f0ee	LU QING YUAN YU 288	0003142	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	\N	127f273e-086c-4e23-bb9e-0557fc9270aa	\N	\N	\N	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	
23ae899a-a70a-49e5-830f-811203300785	API VIII	0003188	\N	e85d7441-0ea6-4a35-8a9e-cc4762739d78	\N	\N	\N	\N	\N	953117a0-3c04-4129-ab96-5eddf3a8d43a	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	
15687486-8080-4a88-8dcc-b2cf1f38f297	FEIXA	6227	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	1985bde5-8964-4250-b775-74cc7469ed58	\N	41.50	1101	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
a85da69b-7566-40ce-8da5-7a6535f7b9e1	GAUCHO GRANDE	0000339	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	\N	\N	\N	27.64	\N	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
1ea649cb-98cf-4d9a-9874-a1fa4259aa57	ANITA	0003278	\N	33b72a9c-7955-4676-bfa9-88037bde19ea	9e25d139-f360-4a6d-aece-eaddec5adb62	1985bde5-8964-4250-b775-74cc7469ed58	\N	\N	\N	4ad4e569-c081-4820-895e-e86131bc5b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N
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
\.


--
-- Data for Name: especies; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.especies (id, codigo, nombre_cientifico, nombre_vulgar, activo, observaciones) FROM stdin;
59a605a0-987f-4f1f-a8eb-86c592ae58eb	0000000001	Genypterus blacodes	Abadejo	t	\N
cc9f7166-c859-4504-8545-0849e09da284	0000000002	Engraulis anchoita	Anchoíta	t	\N
4d1cb9dc-87fd-418a-a912-5c2d0cff14cd	0000000003	Scomber japonicus	Caballa	t	\N
229d6cd0-dfdc-4f36-8210-1ea9b3a87420	0000000004	Illex argentinus	Calamar	t	\N
b13167f2-0410-4798-9fcf-5e386d272e3b	0000000005	Lithodes santolla	Centolla	t	\N
3b629615-d66e-4a61-b867-f53435c27249	0000000006	-	Especies australes	t	\N
b26b4103-fbf4-4a22-8803-676e2e039a81	0000000007	Pleoticus muelleri	Langostino	t	\N
366b1386-e276-4a7e-a057-15e3ff60c6f2	0000000008	Merluccius hubbsi	Merluza común	t	\N
9ac125af-c600-40ca-a84c-dc1a636bf64b	0000000009	Dissostichus eleginoides	Merluza negra	t	\N
40a931a8-830e-458a-96ed-393afbfa218c	0000000010	Zygochlamys patagonica	Vieira	t	\N
\.


--
-- Data for Name: estados_marea; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.estados_marea (id, codigo, nombre, descripcion, categoria, orden, es_inicial, es_final, permite_carga_archivos, permite_correccion, permite_informe, activo, mostrar_en_panel) FROM stdin;
0e446e48-221f-4190-9d34-17af75f9a406	DESIGNADA	Designada	\N	PENDIENTE	1	t	f	f	f	f	t	t
9acdf957-9a1a-4786-8463-f69262b0d65d	EN_EJECUCION	En ejecución	\N	PENDIENTE	2	f	f	f	f	f	t	t
94c1d788-a09b-4d7d-a45a-fab7eeeab437	ESPERANDO_ENTREGA	Esperando entrega de datos	\N	PENDIENTE	3	f	f	f	f	f	t	t
2580411e-8f93-49c9-ab14-6d247ed373ae	ENTREGADA_RECIBIDA	Entregada / Recibida	\N	PENDIENTE	4	f	f	t	f	f	t	t
fdf092bc-e7f6-4d03-8cda-9f25d483cecf	VERIFICACION_INICIAL	Verificación inicial	\N	EN_CURSO	5	f	f	t	f	f	t	t
9d108311-d1b7-49eb-b57e-cf8383b42f73	EN_CORRECCION	En corrección interna	\N	EN_CURSO	6	f	f	t	t	f	t	t
5f9a8c90-a1ff-4c7d-a11d-26571f257799	DELEGADA_EXTERNA	Delegada / En espera externa	\N	EN_CURSO	7	f	f	t	f	f	t	f
80836557-9617-4c74-a903-089230c085b3	PENDIENTE_DE_INFORME	Pendiente de informe	\N	EN_CURSO	8	f	f	f	f	t	t	t
57669ce7-ad00-4862-a3b7-ded380ddb616	ESPERANDO_REVISION	Esperando revisión de informe	\N	EN_CURSO	9	f	f	f	f	t	t	f
84c07a8f-84e9-4b3b-931e-553534c24b01	PARA_PROTOCOLIZAR	Para protocolizar	\N	EN_CURSO	10	f	f	f	f	t	t	f
c9c6f43a-3167-442b-8c19-e04895934ae0	ESPERANDO_PROTOCOLIZACION	Esperando protocolización	\N	EN_CURSO	11	f	f	f	f	t	t	f
9958d706-2c00-447c-b303-b8a2fa2ce060	PROTOCOLIZADA	Protocolizada / Finalizada	\N	COMPLETADO	12	f	t	f	f	t	t	f
c56c252a-8a98-4dd6-9c2d-de6135686d71	CANCELADA	Cancelada / Desestimada	\N	CANCELADO	13	f	t	f	f	f	t	f
\.


--
-- Data for Name: importacion_access_snapshots; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.importacion_access_snapshots (id, id_externo, nro_marea, anio_marea, tipo_marea, nro_etapa, fecha_zarpada, fecha_arribo, buque_nombre, observador_codigo, hash_contenido, fecha_primera_lectura, fecha_ultima_lectura, marea_id, etapa_id) FROM stdin;
\.


--
-- Data for Name: lances; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.lances (id, etapa_id, numero_lance, fecha, cod_arte_pesca, tipo_arte_pesca, hora_inicio, lat_inicio, long_inicio, prof_inicio, hora_final, lat_final, long_final, prof_final, rumbo, distancia_red, velocidad_arrastre, tiempo_red, estacion_gral, calador, fondo_min, fondo_max, tamiz, area_barrida, captura_total_kg, descarte_total_kg, observaciones_lance, mus, fuente_dato) FROM stdin;
\.


--
-- Data for Name: mareas; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.mareas (id, anio_marea, nro_marea, id_buque, id_arte_principal, id_estado_actual, fecha_zarpada_estimada, fecha_inicio_observador, fecha_fin_observador, dias_zona_austral, tipo_calculo_zona_austral, nro_protocolizacion, anio_protocolizacion, fecha_protocolizacion, fecha_creacion, fecha_ultima_actualizacion, activo, observaciones, tipo_marea, dias_estimados, id_observador_principal, id_pesqueria) FROM stdin;
5dd1781f-bf16-43d5-9dd9-0af6015e0253	2024	26	0b03eed0-e253-4914-8683-24e4f03a00f7	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-02-16 18:45:00+00	2024-03-24 14:45:00+00	\N	AUTOMATICO	\N	\N	2024-05-08 14:45:00+00	2026-01-24 13:17:05.58+00	2026-01-24 13:17:05.58+00	t	\N	MC	40	\N	\N
e6802052-f25b-4bf1-8c9e-8e8a85392008	2024	49	0b03eed0-e253-4914-8683-24e4f03a00f7	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-03-28 17:55:00+00	2024-05-09 21:45:00+00	\N	AUTOMATICO	\N	\N	2024-06-23 21:45:00+00	2026-01-24 13:17:05.595+00	2026-01-24 13:17:05.595+00	t	\N	MC	40	\N	\N
f20b023a-4ce3-4cce-98cc-911bdcedbc03	2024	101	0b03eed0-e253-4914-8683-24e4f03a00f7	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-06-26 22:10:00+00	2024-08-07 15:00:00+00	\N	AUTOMATICO	\N	\N	2024-09-21 15:00:00+00	2026-01-24 13:17:05.61+00	2026-01-24 13:17:05.61+00	t	\N	MC	40	\N	\N
a0a3821d-bd0f-4755-aec7-93f2f5d68bfd	2024	60	af79bace-7650-4a0c-bc89-093d01dae7c5	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-04-19 12:00:00+00	2024-05-13 18:04:00+00	\N	AUTOMATICO	\N	\N	2024-06-27 18:04:00+00	2026-01-24 13:17:05.625+00	2026-01-24 13:17:05.625+00	t	\N	MC	45	\N	\N
3e2b7c0e-1f3d-4843-a7ea-53e54946f96e	2024	79	af79bace-7650-4a0c-bc89-093d01dae7c5	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-05-16 18:20:00+00	2024-06-05 07:54:00+00	\N	AUTOMATICO	\N	\N	2024-07-20 07:54:00+00	2026-01-24 13:17:05.637+00	2026-01-24 13:17:05.637+00	t	\N	MC	45	\N	\N
73c13f8b-845a-4246-aa87-585374cd818e	2023	167	377b5ead-3c81-4651-ba39-035d8aa8057d	1eeb0dff-da3b-4dfa-8fe2-e415f817921d	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2023-12-30 16:20:00+00	2024-02-01 21:15:00+00	\N	AUTOMATICO	\N	\N	2024-03-17 21:15:00+00	2026-01-24 13:17:05.65+00	2026-01-24 13:17:05.65+00	t	\N	MC	30	\N	\N
97c232b8-b59c-43ee-b99a-ee092bce107e	2024	55	040eac5c-9520-4870-bbeb-08f72b1257cd	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-03-27 17:15:00+00	2024-04-14 07:49:00+00	\N	AUTOMATICO	\N	\N	2024-05-29 07:49:00+00	2026-01-24 13:17:05.669+00	2026-01-24 13:17:05.669+00	t	\N	MC	\N	\N	\N
d8be8d26-35dc-46f4-b2ba-ef7bde6bddc5	2024	89	040eac5c-9520-4870-bbeb-08f72b1257cd	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-05-22 17:05:00+00	2024-06-02 17:05:00+00	\N	AUTOMATICO	\N	\N	2024-07-17 17:05:00+00	2026-01-24 13:17:05.684+00	2026-01-24 13:17:05.684+00	t	\N	MC	\N	\N	\N
6e4835d6-4c4e-4b5a-8a7f-ee6db3ac8f15	2024	45	cbe3f8c1-3200-4a53-b521-0aa4d2c8d9d1	4f54264c-4a35-48b2-adf7-15a31cd493f0	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-03-21 10:05:00+00	2024-04-16 15:40:00+00	\N	AUTOMATICO	\N	\N	2024-05-31 15:40:00+00	2026-01-24 13:17:05.699+00	2026-01-24 13:17:05.699+00	t	\N	MC	40	\N	\N
67cd79d1-9f58-4aee-bc03-43367153054e	2023	165	1bc94c4d-8291-4f35-abaf-dfd4bab5f0ee	\N	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2023-12-29 15:30:00+00	2024-01-29 02:25:00+00	\N	AUTOMATICO	\N	\N	2024-03-14 02:25:00+00	2026-01-24 13:17:05.713+00	2026-01-24 13:17:05.713+00	t	\N	MC	\N	\N	\N
5c47ab58-6e79-49a6-80fb-da2dbe24ec33	2024	29	aeb1c939-78bd-4a60-a082-f9a46ed969d3	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-02-19 16:20:00+00	2024-02-23 08:03:00+00	\N	AUTOMATICO	\N	\N	2024-04-08 08:03:00+00	2026-01-24 13:17:05.728+00	2026-01-24 13:17:05.728+00	t	\N	MC	30	\N	\N
489c7453-ce53-4ec5-8e8a-123f31046d41	2024	41	169f1b5f-2325-4dd6-af4f-72cb7e86b741	4f54264c-4a35-48b2-adf7-15a31cd493f0	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-03-06 18:55:00+00	2024-04-16 11:04:00+00	\N	AUTOMATICO	\N	\N	2024-05-31 11:04:00+00	2026-01-24 13:17:05.742+00	2026-01-24 13:17:05.742+00	t	\N	MC	40	\N	\N
82d9d3ca-6efe-4e53-8410-cc934deb4a54	2024	86	c9e13553-2541-4186-a463-7d27e0278645	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-05-23 23:18:00+00	2024-06-05 06:32:00+00	\N	AUTOMATICO	\N	\N	2024-07-20 06:32:00+00	2026-01-24 13:17:05.754+00	2026-01-24 13:17:05.754+00	t	\N	MC	30	\N	\N
db5f82ad-4ed7-49bc-99eb-ed9bfc53cabe	2023	157	5b11295e-6b0b-4983-ade2-4c94e98cc8d0	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2023-11-30 23:00:00+00	2024-02-06 05:38:00+00	\N	AUTOMATICO	\N	\N	2024-03-22 05:38:00+00	2026-01-24 13:17:05.769+00	2026-01-24 13:17:05.769+00	t	\N	MC	60	\N	\N
4234dd03-97b4-4543-89bf-abd1deba1733	2025	136	2682d1b5-20fd-4a53-b251-7ddcdab963c1	1eeb0dff-da3b-4dfa-8fe2-e415f817921d	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-07-31 13:05:00+00	2025-09-12 00:44:00+00	\N	AUTOMATICO	\N	\N	2025-10-27 00:44:00+00	2026-01-24 13:17:05.784+00	2026-01-24 13:17:05.784+00	t	\N	MC	30	\N	\N
7ecdf5f5-f405-4632-9677-d62deb1c09ad	2024	44	d73fdcef-e978-44ca-a105-6066e9d96445	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-03-14 14:41:00+00	2024-04-16 12:43:00+00	\N	AUTOMATICO	\N	\N	2024-05-31 12:43:00+00	2026-01-24 13:17:05.801+00	2026-01-24 13:17:05.801+00	t	\N	MC	30	\N	\N
fb205b67-0cb0-4b7f-b159-1a17bc5010c8	2024	63	d73fdcef-e978-44ca-a105-6066e9d96445	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-04-20 13:20:00+00	2024-05-22 08:43:00+00	\N	AUTOMATICO	\N	\N	2024-07-06 08:43:00+00	2026-01-24 13:17:05.817+00	2026-01-24 13:17:05.817+00	t	\N	MC	30	\N	\N
eee00978-801e-47f0-8c55-6ee16b010379	2024	98	abc3ee47-f2ee-42bf-9637-d22f3a7935dc	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-06-18 19:47:00+00	2024-06-29 11:58:00+00	\N	AUTOMATICO	\N	\N	2024-08-13 11:58:00+00	2026-01-24 13:17:05.833+00	2026-01-24 13:17:05.833+00	t	\N	MC	30	\N	\N
4d891826-447b-479e-b99d-eb4507fcf5ba	2024	129	af79bace-7650-4a0c-bc89-093d01dae7c5	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-08-14 22:32:00+00	2024-09-03 07:18:00+00	\N	AUTOMATICO	\N	\N	2024-10-18 07:18:00+00	2026-01-24 13:17:05.847+00	2026-01-24 13:17:05.847+00	t	\N	MC	45	\N	\N
8f495773-1fd5-49db-849c-b4ef984ef43f	2024	139	af79bace-7650-4a0c-bc89-093d01dae7c5	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-09-05 14:10:00+00	2024-10-10 08:43:00+00	\N	AUTOMATICO	\N	\N	2024-11-24 08:43:00+00	2026-01-24 13:17:05.86+00	2026-01-24 13:17:05.86+00	t	\N	MC	45	\N	\N
a8f6adc9-09fe-4f64-a002-0bab440dae7c	2023	163	945b3158-6a8c-4360-97ad-0f50574e46a9	1eeb0dff-da3b-4dfa-8fe2-e415f817921d	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2023-12-30 12:50:00+00	2024-02-03 21:20:00+00	\N	AUTOMATICO	\N	\N	2024-03-19 21:20:00+00	2026-01-24 13:17:05.872+00	2026-01-24 13:17:05.872+00	t	\N	MC	30	\N	\N
bd157ef7-7d47-4ded-8ca2-11ab62821954	2024	32	cff19edb-4d41-4a8a-92ed-2a57683ba0fe	1eeb0dff-da3b-4dfa-8fe2-e415f817921d	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-02-23 19:20:00+00	2024-03-21 08:10:00+00	\N	AUTOMATICO	\N	\N	2024-05-05 08:10:00+00	2026-01-24 13:17:05.888+00	2026-01-24 13:17:05.888+00	t	\N	MC	30	\N	\N
a261f6dd-91b4-465e-84da-50da968b9d0b	2024	67	aeb1c939-78bd-4a60-a082-f9a46ed969d3	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-04-29 17:02:00+00	2024-05-12 06:35:00+00	\N	AUTOMATICO	\N	\N	2024-06-26 06:35:00+00	2026-01-24 13:17:05.902+00	2026-01-24 13:17:05.902+00	t	\N	MC	30	\N	\N
35d2fffe-790f-4376-be9d-e1639ee87fdd	2024	118	e81456a2-5c94-4b6f-8fc3-1291242db58d	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-07-28 17:54:00+00	2024-08-07 10:50:00+00	\N	AUTOMATICO	\N	\N	2024-09-21 10:50:00+00	2026-01-24 13:17:05.918+00	2026-01-24 13:17:05.918+00	t	\N	MC	30	\N	\N
f4d70f61-21d6-41ea-b802-8619d521e8f8	2024	15	f4f48e38-8826-4db0-a659-951dee4e373f	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-01-10 13:50:00+00	2024-02-18 14:06:00+00	\N	AUTOMATICO	\N	\N	2024-04-03 14:06:00+00	2026-01-24 13:17:05.933+00	2026-01-24 13:17:05.933+00	t	\N	MC	60	\N	\N
1f7e81e0-e295-43c0-8b96-299483589a3f	2024	36	f4f48e38-8826-4db0-a659-951dee4e373f	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-02-22 20:45:00+00	2024-04-04 07:46:00+00	\N	AUTOMATICO	\N	\N	2024-05-19 07:46:00+00	2026-01-24 13:17:05.948+00	2026-01-24 13:17:05.948+00	t	\N	MC	60	\N	\N
a8b6da09-dccb-4552-9617-a76925b833e8	2024	57	f4f48e38-8826-4db0-a659-951dee4e373f	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-04-08 11:05:00+00	2024-05-30 10:07:00+00	\N	AUTOMATICO	\N	\N	2024-07-14 10:07:00+00	2026-01-24 13:17:05.963+00	2026-01-24 13:17:05.963+00	t	\N	MC	60	\N	\N
da188ba1-8ee5-4ff4-99ad-27214968243e	2024	115	f4f48e38-8826-4db0-a659-951dee4e373f	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-07-26 14:32:00+00	2024-09-11 09:37:00+00	\N	AUTOMATICO	\N	\N	2024-10-26 09:37:00+00	2026-01-24 13:17:05.98+00	2026-01-24 13:17:05.98+00	t	\N	MC	60	\N	\N
5390aca8-ef01-483e-8c9c-12da08d57aec	2024	4	d1f683c2-69b1-4ab5-86e2-51f1a456b827	4f54264c-4a35-48b2-adf7-15a31cd493f0	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-01-08 10:57:00+00	2024-02-01 05:21:00+00	\N	AUTOMATICO	\N	\N	2024-03-17 05:21:00+00	2026-01-24 13:17:05.994+00	2026-01-24 13:17:05.994+00	t	\N	MC	40	\N	\N
d2bdc49a-f26e-49d6-8f94-98ed942951dd	2024	100	4a8e0a76-a896-4f17-ab23-56cbb32a6d4b	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-07-06 12:20:00+00	2024-07-14 12:54:00+00	\N	AUTOMATICO	\N	\N	2024-08-28 12:54:00+00	2026-01-24 13:17:06.008+00	2026-01-24 13:17:06.008+00	t	\N	MC	30	\N	\N
cf7ee3dc-5f63-4abb-a305-a977bd6671ee	2024	2	f4f48e38-8826-4db0-a659-951dee4e373f	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-01-06 15:49:00+00	2024-01-08 20:15:00+00	\N	AUTOMATICO	\N	\N	2024-02-22 20:15:00+00	2026-01-24 13:17:06.022+00	2026-01-24 13:17:06.022+00	t	\N	MC	60	\N	\N
a03d8cc4-1d65-4a73-9a40-e4ca294241f2	2024	42	498c3f95-ae8b-4fb2-842e-32f77a63cd5b	4f54264c-4a35-48b2-adf7-15a31cd493f0	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-03-14 15:32:00+00	2024-04-22 09:00:00+00	\N	AUTOMATICO	\N	\N	2024-06-06 09:00:00+00	2026-01-24 13:17:06.036+00	2026-01-24 13:17:06.036+00	t	\N	MC	40	\N	\N
51666c22-e869-4151-b83c-856f8b77f10d	2023	154	2682d1b5-20fd-4a53-b251-7ddcdab963c1	1eeb0dff-da3b-4dfa-8fe2-e415f817921d	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2023-12-07 22:50:00+00	2024-01-14 10:25:00+00	\N	AUTOMATICO	\N	\N	2024-02-28 10:25:00+00	2026-01-24 13:17:06.053+00	2026-01-24 13:17:06.053+00	t	\N	MC	30	\N	\N
1ecf1604-0e9b-4946-ba25-880499a9b72c	2024	37	7e7de950-28ea-49ac-af70-269988863345	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-02-29 21:05:00+00	2024-04-09 02:50:00+00	\N	AUTOMATICO	\N	\N	2024-05-24 02:50:00+00	2026-01-24 13:17:06.068+00	2026-01-24 13:17:06.068+00	t	\N	MC	60	\N	\N
341949b8-9fae-4aa9-a984-3faf13cccb68	2024	82	881c9a5b-7d9d-45d9-91b1-ac3bb7b43e48	\N	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-05-22 15:40:00+00	2024-06-11 10:10:00+00	\N	AUTOMATICO	\N	\N	2024-07-26 10:10:00+00	2026-01-24 13:17:06.083+00	2026-01-24 13:17:06.083+00	t	\N	MC	\N	\N	\N
cb8cc24f-c786-4b11-a682-6aa04e148caa	2024	10	bf67761e-0c77-4360-8eee-fdec0487fef9	4f54264c-4a35-48b2-adf7-15a31cd493f0	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-01-09 18:45:00+00	2024-02-11 09:08:00+00	\N	AUTOMATICO	\N	\N	2024-03-27 09:08:00+00	2026-01-24 13:17:06.095+00	2026-01-24 13:17:06.095+00	t	\N	MC	40	\N	\N
7a6a70a7-2677-42c8-9ab2-af68f63d7db2	2024	30	bf67761e-0c77-4360-8eee-fdec0487fef9	4f54264c-4a35-48b2-adf7-15a31cd493f0	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-02-14 18:40:00+00	2024-03-17 08:00:00+00	\N	AUTOMATICO	\N	\N	2024-05-01 08:00:00+00	2026-01-24 13:17:06.109+00	2026-01-24 13:17:06.109+00	t	\N	MC	40	\N	\N
5eb58775-4c52-4cf9-9142-7901799b386a	2024	18	f749d131-dad5-4391-9239-d3eff37d4e93	1eeb0dff-da3b-4dfa-8fe2-e415f817921d	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-02-03 18:25:00+00	2024-03-06 18:20:00+00	\N	AUTOMATICO	\N	\N	2024-04-20 18:20:00+00	2026-01-24 13:17:06.124+00	2026-01-24 13:17:06.124+00	t	\N	MC	30	\N	\N
8a78f9d8-e0f6-4b0e-bcd1-5a4fd9c9d98f	2024	111	ec976353-f1fb-4f24-8ff0-c77281d104ec	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-07-13 09:00:00+00	2024-08-20 06:07:00+00	\N	AUTOMATICO	\N	\N	2024-10-04 06:07:00+00	2026-01-24 13:17:06.137+00	2026-01-24 13:17:06.137+00	t	\N	MC	60	\N	\N
eaad608f-4f9a-420b-8e63-0e2aa28cc631	2024	8	498c3f95-ae8b-4fb2-842e-32f77a63cd5b	4f54264c-4a35-48b2-adf7-15a31cd493f0	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-01-09 11:53:00+00	2024-02-05 18:37:00+00	\N	AUTOMATICO	\N	\N	2024-03-21 18:37:00+00	2026-01-24 13:17:06.151+00	2026-01-24 13:17:06.151+00	t	\N	MC	40	\N	\N
0e36dc1a-2dc5-477e-a719-ebb304a65b44	2024	68	80ff2772-dff0-42e3-b4af-371c1f446a5f	4f54264c-4a35-48b2-adf7-15a31cd493f0	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-04-30 18:40:00+00	2024-05-16 00:00:00+00	\N	AUTOMATICO	\N	\N	2024-06-30 00:00:00+00	2026-01-24 13:17:06.166+00	2026-01-24 13:17:06.166+00	t	\N	MC	40	\N	\N
a25f941a-a404-4a5e-bc44-a0e5e0b8ec4d	2024	92	80a91104-b031-4e3c-8308-fbdff126f6dc	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-05-29 17:45:00+00	2024-06-29 17:05:00+00	\N	AUTOMATICO	\N	\N	2024-08-13 17:05:00+00	2026-01-24 13:17:06.181+00	2026-01-24 13:17:06.181+00	t	\N	MC	60	\N	\N
5d187221-c421-484d-9a94-ae56f87acce1	2024	148	945b3158-6a8c-4360-97ad-0f50574e46a9	1eeb0dff-da3b-4dfa-8fe2-e415f817921d	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-10-27 23:30:00+00	2024-10-29 15:55:00+00	\N	AUTOMATICO	\N	\N	2024-12-13 15:55:00+00	2026-01-24 13:17:06.195+00	2026-01-24 13:17:06.195+00	t	\N	MC	30	\N	\N
891574a1-010e-49a0-aea1-4b43f8f15658	2023	162	1b2c15e0-ece3-4c58-8334-079d6d844c0e	1eeb0dff-da3b-4dfa-8fe2-e415f817921d	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2023-12-30 12:30:00+00	2024-02-03 20:47:00+00	\N	AUTOMATICO	\N	\N	2024-03-19 20:47:00+00	2026-01-24 13:17:06.211+00	2026-01-24 13:17:06.211+00	t	\N	MC	30	\N	\N
82d9e8a0-5610-4617-9a4b-55eeac6d96ec	2024	74	db0b87f1-28e5-477e-abcf-9a990bccfaf6	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-05-10 13:25:00+00	2024-06-14 19:30:00+00	\N	AUTOMATICO	\N	\N	2024-07-29 19:30:00+00	2026-01-24 13:17:06.228+00	2026-01-24 13:17:06.228+00	t	\N	MC	60	\N	\N
acfa3d72-1582-4d71-b7e1-abffe4fd613b	2024	108	fadfa149-546e-4dd2-b3b8-caea5b867715	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-07-10 19:19:00+00	2024-08-09 18:50:00+00	\N	AUTOMATICO	\N	\N	2024-09-23 18:50:00+00	2026-01-24 13:17:06.243+00	2026-01-24 13:17:06.243+00	t	\N	MC	60	\N	\N
d546ddc0-8630-4376-9453-9bbe49c3f9ef	2024	76	18b98431-a4a2-463b-ae58-c784bcf1ae44	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-05-11 13:50:00+00	2024-05-20 11:37:00+00	\N	AUTOMATICO	\N	\N	2024-07-04 11:37:00+00	2026-01-24 13:17:06.257+00	2026-01-24 13:17:06.257+00	t	\N	MC	30	\N	\N
4aee24df-1523-4946-9cc8-c7549aa3a78d	2024	126	4ce964a6-9e77-43e3-9dff-6609a4675e41	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-08-07 11:38:00+00	2024-08-15 00:52:00+00	\N	AUTOMATICO	\N	\N	2024-09-29 00:52:00+00	2026-01-24 13:17:06.273+00	2026-01-24 13:17:06.273+00	t	\N	MC	30	\N	\N
0bbd25df-07ab-4373-9d6b-0fea75deb7ff	2024	150	7e7de950-28ea-49ac-af70-269988863345	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-09-30 00:45:00+00	2024-10-29 23:51:00+00	\N	AUTOMATICO	\N	\N	2024-12-13 23:51:00+00	2026-01-24 13:17:06.293+00	2026-01-24 13:17:06.293+00	t	\N	MC	60	\N	\N
503a17e8-d9db-4884-9cb4-1750a9796231	2024	16	15687486-8080-4a88-8dcc-b2cf1f38f297	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-01-17 15:00:00+00	2024-01-25 05:38:00+00	\N	AUTOMATICO	\N	\N	2024-03-10 05:38:00+00	2026-01-24 13:17:06.306+00	2026-01-24 13:17:06.306+00	t	\N	MC	30	\N	\N
f1cd7188-c626-4483-bf3c-c2e85225d7fd	2024	64	9af58d33-ac30-493f-9f39-9aa549076346	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-04-24 16:30:00+00	2024-05-04 17:08:00+00	\N	AUTOMATICO	\N	\N	2024-06-18 17:08:00+00	2026-01-24 13:17:06.322+00	2026-01-24 13:17:06.322+00	t	\N	MC	30	\N	\N
d6f11abd-28c4-4047-89d5-cada8a9dbabb	2024	142	1ae949b6-6424-4a96-9c9f-4d959d87a0c5	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-09-06 18:10:00+00	2024-09-13 17:00:00+00	\N	AUTOMATICO	\N	\N	2024-10-28 17:00:00+00	2026-01-24 13:17:06.337+00	2026-01-24 13:17:06.337+00	t	\N	MC	30	\N	\N
66993fe2-82c8-4826-aa9b-1eb410b1b016	2024	167	4a8e0a76-a896-4f17-ab23-56cbb32a6d4b	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-12-03 16:49:00+00	2024-12-11 08:35:00+00	\N	AUTOMATICO	\N	\N	2025-01-25 08:35:00+00	2026-01-24 13:17:06.351+00	2026-01-24 13:17:06.351+00	t	\N	MC	30	\N	\N
210fbf0a-2daf-4d64-b738-d04cc216b583	2024	17	945b3158-6a8c-4360-97ad-0f50574e46a9	1eeb0dff-da3b-4dfa-8fe2-e415f817921d	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-02-06 22:12:00+00	2024-02-23 08:25:00+00	\N	AUTOMATICO	\N	\N	2024-04-08 08:25:00+00	2026-01-24 13:17:06.366+00	2026-01-24 13:17:06.366+00	t	\N	MC	30	\N	\N
16a326ac-b7b0-4437-9a8a-74fcc7b829af	2024	59	7e7de950-28ea-49ac-af70-269988863345	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-04-10 19:30:00+00	2024-04-13 20:34:00+00	\N	AUTOMATICO	\N	\N	2024-05-28 20:34:00+00	2026-01-24 13:17:06.381+00	2026-01-24 13:17:06.381+00	t	\N	MC	60	\N	\N
913ceb70-a52e-49c5-bddd-5cb7b3f466b3	2024	102	e81456a2-5c94-4b6f-8fc3-1291242db58d	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-06-26 12:00:00+00	2024-07-12 23:00:00+00	\N	AUTOMATICO	\N	\N	2024-08-26 23:00:00+00	2026-01-24 13:17:06.396+00	2026-01-24 13:17:06.396+00	t	\N	MC	30	\N	\N
4c9d8c24-82b8-4155-b437-98ba08a37887	2024	5	c8f549d2-ef48-4931-82db-5f6650dd4dfb	4f54264c-4a35-48b2-adf7-15a31cd493f0	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-01-06 13:00:00+00	2024-01-31 23:50:00+00	\N	AUTOMATICO	\N	\N	2024-03-16 23:50:00+00	2026-01-24 13:17:06.41+00	2026-01-24 13:17:06.41+00	t	\N	MC	40	\N	\N
be32e8e7-af31-4698-a87d-9390e360c0ee	2024	117	4fb8e545-033a-4813-88be-9e7994602845	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-07-28 17:59:00+00	2024-08-04 08:40:00+00	\N	AUTOMATICO	\N	\N	2024-09-18 08:40:00+00	2026-01-24 13:17:06.423+00	2026-01-24 13:17:06.423+00	t	\N	MC	30	\N	\N
8513f6d3-0db3-4e09-8392-f60fc146c9e0	2024	140	4fb8e545-033a-4813-88be-9e7994602845	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-09-06 10:57:00+00	2024-09-13 07:08:00+00	\N	AUTOMATICO	\N	\N	2024-10-28 07:08:00+00	2026-01-24 13:17:06.437+00	2026-01-24 13:17:06.437+00	t	\N	MC	30	\N	\N
7530322d-4dfc-419d-bed0-e8cc7dd690ea	2023	159	f749d131-dad5-4391-9239-d3eff37d4e93	1eeb0dff-da3b-4dfa-8fe2-e415f817921d	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2023-12-30 20:00:00+00	2024-01-30 20:00:00+00	\N	AUTOMATICO	\N	\N	2024-03-15 20:00:00+00	2026-01-24 13:17:06.451+00	2026-01-24 13:17:06.451+00	t	\N	MC	30	\N	\N
e07dfdbb-0069-439b-8a09-061e82bc6bd3	2024	31	2682d1b5-20fd-4a53-b251-7ddcdab963c1	1eeb0dff-da3b-4dfa-8fe2-e415f817921d	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-02-26 23:10:00+00	2024-03-12 20:30:00+00	\N	AUTOMATICO	\N	\N	2024-04-26 20:30:00+00	2026-01-24 13:17:06.467+00	2026-01-24 13:17:06.467+00	t	\N	MC	30	\N	\N
a718fba8-b7d9-41ef-9992-ffbd23506956	2024	65	498c3f95-ae8b-4fb2-842e-32f77a63cd5b	4f54264c-4a35-48b2-adf7-15a31cd493f0	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-04-25 18:11:00+00	2024-05-24 10:52:00+00	\N	AUTOMATICO	\N	\N	2024-07-08 10:52:00+00	2026-01-24 13:17:06.483+00	2026-01-24 13:17:06.483+00	t	\N	MC	40	\N	\N
3636e297-22f9-4efa-9f94-d47f1b0030c7	2024	132	d73fdcef-e978-44ca-a105-6066e9d96445	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-08-24 13:21:00+00	2024-09-27 08:17:00+00	\N	AUTOMATICO	\N	\N	2024-11-11 08:17:00+00	2026-01-24 13:17:06.498+00	2026-01-24 13:17:06.498+00	t	\N	MC	30	\N	\N
41546177-9a22-4dc6-a9ea-b9f591dc21da	2024	165	d73fdcef-e978-44ca-a105-6066e9d96445	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-11-15 16:53:00+00	2024-12-16 16:46:00+00	\N	AUTOMATICO	\N	\N	2025-01-30 16:46:00+00	2026-01-24 13:17:06.512+00	2026-01-24 13:17:06.512+00	t	\N	MC	30	\N	\N
07ab166e-0c45-4471-8512-83ad0ba8d6bf	2024	6	cff19edb-4d41-4a8a-92ed-2a57683ba0fe	1eeb0dff-da3b-4dfa-8fe2-e415f817921d	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-01-06 08:40:00+00	2024-01-11 08:40:00+00	\N	AUTOMATICO	\N	\N	2024-02-25 08:40:00+00	2026-01-24 13:17:06.528+00	2026-01-24 13:17:06.528+00	t	\N	MC	30	\N	\N
41349fe9-7643-4de0-b554-993d520c198d	2024	77	0b03eed0-e253-4914-8683-24e4f03a00f7	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-05-15 15:17:00+00	2024-06-23 11:40:00+00	\N	AUTOMATICO	\N	\N	2024-08-07 11:40:00+00	2026-01-24 13:17:06.542+00	2026-01-24 13:17:06.542+00	t	\N	MC	40	\N	\N
893f8b43-88e4-44ff-b895-af1628e9b8e1	2024	168	5b11295e-6b0b-4983-ade2-4c94e98cc8d0	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-12-06 23:45:00+00	2025-02-04 04:35:00+00	\N	AUTOMATICO	\N	\N	2025-03-21 04:35:00+00	2026-01-24 13:17:06.558+00	2026-01-24 13:17:06.558+00	t	\N	MC	60	\N	\N
7ab4da54-a46d-4f6f-bebd-9a0233ec6fca	2024	12	63f6107b-beea-4b36-9774-25cf88d83e48	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-01-13 13:30:00+00	2024-02-25 08:04:00+00	\N	AUTOMATICO	\N	\N	2024-04-10 08:04:00+00	2026-01-24 13:17:06.574+00	2026-01-24 13:17:06.574+00	t	\N	MC	60	\N	\N
ae47e344-c7bd-492e-9d8d-9102d8e8b64d	2024	52	30b1a0cb-0656-4dd5-a54e-e9c5feb7a50d	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-03-27 05:50:00+00	2024-04-13 17:30:00+00	\N	AUTOMATICO	\N	\N	2024-05-28 17:30:00+00	2026-01-24 13:17:06.588+00	2026-01-24 13:17:06.588+00	t	\N	MC	30	\N	\N
58c3cb74-3fa8-430b-83bf-5dc32f9977e1	2024	72	4fb8e545-033a-4813-88be-9e7994602845	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-05-11 12:08:00+00	2024-05-22 12:06:00+00	\N	AUTOMATICO	\N	\N	2024-07-06 12:06:00+00	2026-01-24 13:17:06.603+00	2026-01-24 13:17:06.603+00	t	\N	MC	30	\N	\N
6bc2c3d5-ed76-4a68-b518-42b63b234427	2024	128	80a91104-b031-4e3c-8308-fbdff126f6dc	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-08-15 15:21:00+00	2024-09-14 09:30:00+00	\N	AUTOMATICO	\N	\N	2024-10-29 09:30:00+00	2026-01-24 13:17:06.619+00	2026-01-24 13:17:06.619+00	t	\N	MC	60	\N	\N
8015addd-6ac6-4e48-b831-4723f02ee687	2024	25	5b11295e-6b0b-4983-ade2-4c94e98cc8d0	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-02-09 18:23:00+00	2024-03-18 02:20:00+00	\N	AUTOMATICO	\N	\N	2024-05-02 02:20:00+00	2026-01-24 13:17:06.634+00	2026-01-24 13:17:06.634+00	t	\N	MC	60	\N	\N
2051da06-42ad-4e62-9cae-c6db658936c0	2026	7	5b11295e-6b0b-4983-ade2-4c94e98cc8d0	9e25d139-f360-4a6d-aece-eaddec5adb62	9acdf957-9a1a-4786-8463-f69262b0d65d	2026-01-15 03:00:00+00	2026-01-15 03:00:00+00	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-24 13:17:06.651+00	2026-01-24 13:17:06.651+00	t	\N	MC	60	\N	\N
3fe0dadb-018d-468b-9d67-c24956f31b73	2024	54	c4e6cd7e-ba70-4080-b4dd-49361dd03287	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-03-27 03:45:00+00	2024-04-27 18:56:00+00	\N	AUTOMATICO	\N	\N	2024-06-11 18:56:00+00	2026-01-24 13:17:06.671+00	2026-01-24 13:17:06.671+00	t	\N	MC	60	\N	\N
d0914875-9ace-45c0-9575-de87a7477ce1	2024	85	de912164-b6dd-4126-a5aa-4ec563018825	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-05-24 22:30:00+00	2024-05-29 09:40:00+00	\N	AUTOMATICO	\N	\N	2024-07-13 09:40:00+00	2026-01-24 13:17:06.687+00	2026-01-24 13:17:06.687+00	t	\N	MC	30	\N	\N
e3939cce-f7db-4bb9-a1b2-1342f710cb04	2024	96	07a74d76-74eb-41da-aa75-e2dc05a6923d	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-06-11 21:15:00+00	2024-06-21 15:10:00+00	\N	AUTOMATICO	\N	\N	2024-08-05 15:10:00+00	2026-01-24 13:17:06.702+00	2026-01-24 13:17:06.702+00	t	\N	MC	30	\N	\N
2580512b-1f53-465f-99bf-a4a1aaedd385	2024	113	07a74d76-74eb-41da-aa75-e2dc05a6923d	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-07-16 00:00:00+00	2024-07-28 00:00:00+00	\N	AUTOMATICO	\N	\N	2024-09-11 00:00:00+00	2026-01-24 13:17:06.717+00	2026-01-24 13:17:06.717+00	t	\N	MC	30	\N	\N
40a2e86a-7673-40a8-b76d-c8fd6bd3c7da	2024	13	18b98431-a4a2-463b-ae58-c784bcf1ae44	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-01-22 13:55:00+00	2024-02-03 00:04:00+00	\N	AUTOMATICO	\N	\N	2024-03-19 00:04:00+00	2026-01-24 13:17:06.733+00	2026-01-24 13:17:06.733+00	t	\N	MC	30	\N	\N
4be3bb24-6688-4b99-863d-577c80cbc58e	2024	50	18b98431-a4a2-463b-ae58-c784bcf1ae44	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-03-28 18:23:00+00	2024-04-09 18:00:00+00	\N	AUTOMATICO	\N	\N	2024-05-24 18:00:00+00	2026-01-24 13:17:06.748+00	2026-01-24 13:17:06.748+00	t	\N	MC	30	\N	\N
87c8e125-7eb0-40ca-8e8e-69bf0e037a9c	2024	80	aeb1c939-78bd-4a60-a082-f9a46ed969d3	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-05-18 11:00:00+00	2024-05-22 18:07:00+00	\N	AUTOMATICO	\N	\N	2024-07-06 18:07:00+00	2026-01-24 13:17:06.763+00	2026-01-24 13:17:06.763+00	t	\N	MC	30	\N	\N
8055fb95-d469-4a19-bd0d-568025b021d4	2024	104	aeb1c939-78bd-4a60-a082-f9a46ed969d3	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-06-20 06:55:00+00	2024-06-24 14:00:00+00	\N	AUTOMATICO	\N	\N	2024-08-08 14:00:00+00	2026-01-24 13:17:06.779+00	2026-01-24 13:17:06.779+00	t	\N	MC	30	\N	\N
32eca87e-c32c-4a94-aadc-fb79d02e15b2	2024	131	57564db2-64d0-48ce-950d-1a6b7c9202cc	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-08-20 19:05:00+00	2024-08-28 08:29:00+00	\N	AUTOMATICO	\N	\N	2024-10-12 08:29:00+00	2026-01-24 13:17:06.795+00	2026-01-24 13:17:06.795+00	t	\N	MC	30	\N	\N
24771909-d5a2-4a9f-8240-8fd54be6a37f	2024	9	a0a7acd7-9cd1-4920-9dff-1cb2605d4af5	4f54264c-4a35-48b2-adf7-15a31cd493f0	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-01-19 20:37:00+00	2024-02-14 08:23:00+00	\N	AUTOMATICO	\N	\N	2024-03-30 08:23:00+00	2026-01-24 13:17:06.81+00	2026-01-24 13:17:06.81+00	t	\N	MC	40	\N	\N
cca3e6c3-8733-48ec-8567-28e86f52f432	2024	39	945b3158-6a8c-4360-97ad-0f50574e46a9	1eeb0dff-da3b-4dfa-8fe2-e415f817921d	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-03-02 20:35:00+00	2024-04-04 07:00:00+00	\N	AUTOMATICO	\N	\N	2024-05-19 07:00:00+00	2026-01-24 13:17:06.824+00	2026-01-24 13:17:06.824+00	t	\N	MC	30	\N	\N
86e2d809-bb36-48b0-af10-f6f8e5ba4eda	2024	71	cca93d4f-fccb-4a0f-ad3b-752351938359	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-04-29 18:20:00+00	2024-05-20 08:40:00+00	\N	AUTOMATICO	\N	\N	2024-07-04 08:40:00+00	2026-01-24 13:17:06.838+00	2026-01-24 13:17:06.838+00	t	\N	MC	30	\N	\N
e5f7200a-3441-4d5b-8eb2-175092d9e7f2	2024	83	4f52eba5-a69e-4bf2-9ea9-bf6a8e733136	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-05-23 19:35:00+00	2024-06-09 11:55:00+00	\N	AUTOMATICO	\N	\N	2024-07-24 11:55:00+00	2026-01-24 13:17:06.853+00	2026-01-24 13:17:06.853+00	t	\N	MC	30	\N	\N
e2488908-b66f-41cf-885e-61652b3898c7	2024	116	4e395848-f29c-4bed-b5f7-3f633bad01a2	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-07-21 13:05:00+00	2024-07-27 16:40:00+00	\N	AUTOMATICO	\N	\N	2024-09-10 16:40:00+00	2026-01-24 13:17:06.869+00	2026-01-24 13:17:06.869+00	t	\N	MC	30	\N	\N
df8941e8-61c5-48c4-bcf6-2d7bdb7d826b	2024	3	a8956f2f-f8e4-4387-8fa3-48ea20c38489	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-01-05 20:05:00+00	2024-01-25 20:15:00+00	\N	AUTOMATICO	\N	\N	2024-03-10 20:15:00+00	2026-01-24 13:17:06.885+00	2026-01-24 13:17:06.885+00	t	\N	MC	60	\N	\N
9a78af6b-2406-46c1-b427-8781c67bcdda	2024	22	a8956f2f-f8e4-4387-8fa3-48ea20c38489	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-01-27 20:00:00+00	2024-02-24 17:45:00+00	\N	AUTOMATICO	\N	\N	2024-04-09 17:45:00+00	2026-01-24 13:17:06.902+00	2026-01-24 13:17:06.902+00	t	\N	MC	60	\N	\N
f0d2bcd0-0a46-4f7c-ae73-e8d00fc94609	2024	34	a8956f2f-f8e4-4387-8fa3-48ea20c38489	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-02-27 18:45:00+00	2024-03-23 23:00:00+00	\N	AUTOMATICO	\N	\N	2024-05-07 23:00:00+00	2026-01-24 13:17:06.918+00	2026-01-24 13:17:06.918+00	t	\N	MC	60	\N	\N
b5dfface-103b-479b-8dd8-a582b2745c46	2024	75	7b0a7e6a-a71b-43b0-b9e2-cca0b5518ab0	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-05-06 17:20:00+00	2024-06-26 04:30:00+00	\N	AUTOMATICO	\N	\N	2024-08-10 04:30:00+00	2026-01-24 13:17:06.933+00	2026-01-24 13:17:06.933+00	t	\N	MC	60	\N	\N
402f10be-a827-46dc-8247-3551b2ca4a4e	2024	105	7b0a7e6a-a71b-43b0-b9e2-cca0b5518ab0	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-07-04 02:35:00+00	2024-09-05 10:25:00+00	\N	AUTOMATICO	\N	\N	2024-10-20 10:25:00+00	2026-01-24 13:17:06.949+00	2026-01-24 13:17:06.949+00	t	\N	MC	60	\N	\N
e63e966e-1768-48c1-820b-7826b2a2676b	2024	58	210ffb51-daba-4d2b-93fb-b4915bd47552	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-04-04 15:15:00+00	2024-05-15 10:05:00+00	\N	AUTOMATICO	\N	\N	2024-06-29 10:05:00+00	2026-01-24 13:17:06.965+00	2026-01-24 13:17:06.965+00	t	\N	MC	60	\N	\N
d9478508-50ed-4116-976b-b1a9e52fea86	2024	94	9501be2a-5bc6-4062-ad1e-2aebfa92af0c	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-06-06 20:00:00+00	2024-07-05 20:50:00+00	\N	AUTOMATICO	\N	\N	2024-08-19 20:50:00+00	2026-01-24 13:17:06.98+00	2026-01-24 13:17:06.98+00	t	\N	MC	60	\N	\N
b9bac716-fd70-45fd-b44d-1adaa80746fe	2024	127	7a0ed70d-e0c9-40ed-8167-389c0fe10e52	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-08-16 09:34:00+00	2024-10-05 12:23:00+00	\N	AUTOMATICO	\N	\N	2024-11-19 12:23:00+00	2026-01-24 13:17:06.995+00	2026-01-24 13:17:06.995+00	t	\N	MC	60	\N	\N
e8ef9e23-7ac3-423c-bbe7-ef93e89eceba	2023	164	edd87f10-eea7-4484-85b5-c4e725767ea8	4f54264c-4a35-48b2-adf7-15a31cd493f0	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2023-12-31 08:50:00+00	2024-01-23 05:55:00+00	\N	AUTOMATICO	\N	\N	2024-03-08 05:55:00+00	2026-01-24 13:17:07.013+00	2026-01-24 13:17:07.013+00	t	\N	MC	40	\N	\N
edef113f-2693-43d0-9361-76ae82180db7	2024	38	4a8e0a76-a896-4f17-ab23-56cbb32a6d4b	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-03-06 10:00:00+00	2024-03-13 13:33:00+00	\N	AUTOMATICO	\N	\N	2024-04-27 13:33:00+00	2026-01-24 13:17:07.03+00	2026-01-24 13:17:07.03+00	t	\N	MC	30	\N	\N
d1442c54-7a29-4bdb-8a22-e4ce6284241f	2024	93	f4f48e38-8826-4db0-a659-951dee4e373f	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-06-07 18:08:00+00	2024-07-21 16:45:00+00	\N	AUTOMATICO	\N	\N	2024-09-04 16:45:00+00	2026-01-24 13:17:07.046+00	2026-01-24 13:17:07.046+00	t	\N	MC	60	\N	\N
efe65554-104f-4323-8617-e16c61dc1235	2024	135	487561a4-9930-4a0b-8236-6c6ae0315686	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-09-05 08:50:00+00	2024-10-15 17:15:00+00	\N	AUTOMATICO	\N	\N	2024-11-29 17:15:00+00	2026-01-24 13:17:07.061+00	2026-01-24 13:17:07.061+00	t	\N	MC	60	\N	\N
2a33f80b-90b3-4c89-940d-c089ae9d4c9c	2024	19	edd87f10-eea7-4484-85b5-c4e725767ea8	4f54264c-4a35-48b2-adf7-15a31cd493f0	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-01-24 23:00:00+00	2024-02-12 10:25:00+00	\N	AUTOMATICO	\N	\N	2024-03-28 10:25:00+00	2026-01-24 13:17:07.074+00	2026-01-24 13:17:07.074+00	t	\N	MC	40	\N	\N
9d4e9e20-6b4d-4137-b195-ed203ad5200f	2024	28	edd87f10-eea7-4484-85b5-c4e725767ea8	4f54264c-4a35-48b2-adf7-15a31cd493f0	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-02-13 19:36:00+00	2024-03-03 13:48:00+00	\N	AUTOMATICO	\N	\N	2024-04-17 13:48:00+00	2026-01-24 13:17:07.087+00	2026-01-24 13:17:07.087+00	t	\N	MC	40	\N	\N
6ef79d64-f2ea-4c3e-9af7-8274f1167fea	2024	40	edd87f10-eea7-4484-85b5-c4e725767ea8	4f54264c-4a35-48b2-adf7-15a31cd493f0	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-03-05 18:35:00+00	2024-04-03 20:35:00+00	\N	AUTOMATICO	\N	\N	2024-05-18 20:35:00+00	2026-01-24 13:17:07.103+00	2026-01-24 13:17:07.103+00	t	\N	MC	40	\N	\N
c4318b2e-10f9-4598-af90-8424804d1aa8	2024	87	9ae2162e-df62-40f7-8d62-8d1da7dc803c	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-05-24 17:25:00+00	2024-06-01 08:39:00+00	\N	AUTOMATICO	\N	\N	2024-07-16 08:39:00+00	2026-01-24 13:17:07.118+00	2026-01-24 13:17:07.118+00	t	\N	MC	30	\N	\N
ab5bba2f-82ce-47eb-900a-6b0e8d8890a3	2024	97	8025c58d-386f-49ef-b686-533eedb8d540	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-06-18 13:30:00+00	2024-06-27 07:50:00+00	\N	AUTOMATICO	\N	\N	2024-08-11 07:50:00+00	2026-01-24 13:17:07.131+00	2026-01-24 13:17:07.131+00	t	\N	MC	30	\N	\N
9daed517-413a-4ccc-9fd7-633e46fd083b	2024	1	0b03eed0-e253-4914-8683-24e4f03a00f7	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-01-06 18:45:00+00	2024-02-13 21:55:00+00	\N	AUTOMATICO	\N	\N	2024-03-29 21:55:00+00	2026-01-24 13:17:07.145+00	2026-01-24 13:17:07.145+00	t	\N	MC	40	\N	\N
120d71ed-ee6f-4eaf-a6a2-7cef4b602200	2023	148	0b03eed0-e253-4914-8683-24e4f03a00f7	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2023-11-24 11:35:00+00	2024-01-03 20:20:00+00	\N	AUTOMATICO	\N	\N	2024-02-17 20:20:00+00	2026-01-24 13:17:07.16+00	2026-01-24 13:17:07.16+00	t	\N	MC	40	\N	\N
c20d247f-0aa3-452b-a539-21ab0cce4ac0	2024	11	4fb8e545-033a-4813-88be-9e7994602845	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-01-16 14:27:00+00	2024-01-27 19:06:00+00	\N	AUTOMATICO	\N	\N	2024-03-12 19:06:00+00	2026-01-24 13:17:07.174+00	2026-01-24 13:17:07.174+00	t	\N	MC	30	\N	\N
b8f1db6f-fb63-4432-bdcb-0593563f069f	2024	43	15687486-8080-4a88-8dcc-b2cf1f38f297	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-03-17 10:10:00+00	2024-03-26 14:27:00+00	\N	AUTOMATICO	\N	\N	2024-05-10 14:27:00+00	2026-01-24 13:17:07.189+00	2026-01-24 13:17:07.189+00	t	\N	MC	30	\N	\N
51f28ec9-3f3c-4696-8e27-25a63c056114	2024	88	933ac46a-b225-455c-90da-e0927a03de76	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-05-23 18:50:00+00	2024-06-05 08:06:00+00	\N	AUTOMATICO	\N	\N	2024-07-20 08:06:00+00	2026-01-24 13:17:07.204+00	2026-01-24 13:17:07.204+00	t	\N	MC	30	\N	\N
e2c4cbb3-e24d-4a93-93d4-4595f3cf43c4	2024	123	b2d6a59b-7aba-4b63-b683-bc25aca8091f	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-08-06 16:58:00+00	2024-08-20 12:45:00+00	\N	AUTOMATICO	\N	\N	2024-10-04 12:45:00+00	2026-01-24 13:17:07.219+00	2026-01-24 13:17:07.219+00	t	\N	MC	\N	\N	\N
262f3fb1-843d-41c9-8917-dac45f95cb07	2024	157	c993cfea-a690-4457-964f-b45d769f1da8	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-10-13 10:43:00+00	2024-10-20 10:33:00+00	\N	AUTOMATICO	\N	\N	2024-12-04 10:33:00+00	2026-01-24 13:17:07.235+00	2026-01-24 13:17:07.235+00	t	\N	MC	\N	\N	\N
2c04ffd6-0715-4130-8432-a32caf9d27f5	2024	164	4fb8e545-033a-4813-88be-9e7994602845	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-11-16 12:51:00+00	2024-11-24 22:49:00+00	\N	AUTOMATICO	\N	\N	2025-01-08 22:49:00+00	2026-01-24 13:17:07.251+00	2026-01-24 13:17:07.251+00	t	\N	MC	30	\N	\N
3ef54356-57c7-43b1-b8ee-c67bd097fe6d	2024	46	9af58d33-ac30-493f-9f39-9aa549076346	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-03-19 19:32:00+00	2024-03-30 18:39:00+00	\N	AUTOMATICO	\N	\N	2024-05-14 18:39:00+00	2026-01-24 13:17:07.266+00	2026-01-24 13:17:07.266+00	t	\N	MC	30	\N	\N
9ca62b20-c29e-427c-9919-8712bd3dc653	2025	129	4fb8e545-033a-4813-88be-9e7994602845	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-07-23 12:30:00+00	2025-08-28 19:29:00+00	\N	AUTOMATICO	\N	\N	2025-10-12 19:29:00+00	2026-01-24 13:17:07.283+00	2026-01-24 13:17:07.283+00	t	\N	MC	30	\N	\N
32535562-6f5e-4c93-9e3e-af9d09056343	2025	47	1b2c15e0-ece3-4c58-8334-079d6d844c0e	1eeb0dff-da3b-4dfa-8fe2-e415f817921d	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-03-13 08:00:00+00	2025-04-19 12:20:00+00	\N	AUTOMATICO	\N	\N	2025-06-03 12:20:00+00	2026-01-24 13:17:07.31+00	2026-01-24 13:17:07.31+00	t	\N	MC	30	\N	\N
62e43cbe-a312-4534-a620-7765d83f9ec9	2025	137	1fcee1ed-f340-4156-90c4-7b5a961686b3	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-07-30 11:15:00+00	2025-08-04 09:25:00+00	\N	AUTOMATICO	\N	\N	2025-09-18 09:25:00+00	2026-01-24 13:17:07.327+00	2026-01-24 13:17:07.327+00	t	\N	MC	30	\N	\N
af818919-7f60-4f33-bb3d-f0446ab81506	2025	135	4ce964a6-9e77-43e3-9dff-6609a4675e41	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-07-28 16:00:00+00	2025-08-23 10:37:00+00	\N	AUTOMATICO	\N	\N	2025-10-07 10:37:00+00	2026-01-24 13:17:07.342+00	2026-01-24 13:17:07.342+00	t	\N	MC	30	\N	\N
103842ed-863c-43ce-900b-728c937c607b	2025	138	fb3b141b-abd3-4275-9a6d-2f779efa7bcb	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-08-04 21:10:00+00	2025-09-05 11:50:00+00	\N	AUTOMATICO	\N	\N	2025-10-20 11:50:00+00	2026-01-24 13:17:07.364+00	2026-01-24 13:17:07.364+00	t	\N	MC	30	\N	\N
961b3624-a638-423f-843d-64b222441e1b	2025	90	84fa549b-42f6-46de-9d8e-458b2c4f652b	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-05-26 17:21:00+00	2025-06-11 01:15:00+00	\N	AUTOMATICO	\N	\N	2025-07-26 01:15:00+00	2026-01-24 13:17:07.382+00	2026-01-24 13:17:07.382+00	t	\N	MC	30	\N	\N
083c465b-795f-4879-8bcd-995012b7ac84	2025	102	84fa549b-42f6-46de-9d8e-458b2c4f652b	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-06-17 18:22:00+00	2025-07-10 17:49:00+00	\N	AUTOMATICO	\N	\N	2025-08-24 17:49:00+00	2026-01-24 13:17:07.401+00	2026-01-24 13:17:07.401+00	t	\N	MC	30	\N	\N
096a05bc-0667-41e0-b7e7-d1f055055304	2025	141	20fde841-e14c-4dc0-8b67-0c1dbd944bea	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-08-05 12:41:00+00	2025-08-13 19:20:00+00	\N	AUTOMATICO	\N	\N	2025-09-27 19:20:00+00	2026-01-24 13:17:07.419+00	2026-01-24 13:17:07.419+00	t	\N	MC	30	\N	\N
3306220d-f1bb-447d-8aed-296a365bb403	2025	113	ae3d4e22-1208-4514-9403-30fd4a94f051	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-07-12 09:51:00+00	2025-08-01 14:59:00+00	\N	AUTOMATICO	\N	\N	2025-09-15 14:59:00+00	2026-01-24 13:17:07.434+00	2026-01-24 13:17:07.434+00	t	\N	MC	30	\N	\N
3dfefa7b-819d-416e-af81-f5222293a93a	2025	140	d3f42698-725b-403f-9ca4-08c49e127dd3	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-08-05 14:33:00+00	2025-08-22 11:50:00+00	\N	AUTOMATICO	\N	\N	2025-10-06 11:50:00+00	2026-01-24 13:17:07.455+00	2026-01-24 13:17:07.455+00	t	\N	MC	30	\N	\N
40121aee-6473-49e1-91a2-c90ff9cc9196	2025	8	4a8e0a76-a896-4f17-ab23-56cbb32a6d4b	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-01-11 11:45:00+00	2025-02-11 11:40:00+00	\N	AUTOMATICO	\N	\N	2025-03-28 11:40:00+00	2026-01-24 13:17:07.477+00	2026-01-24 13:17:07.477+00	t	\N	MC	30	\N	\N
c07c571b-64ea-4e1d-923e-a247e33977cd	2025	65	1ea649cb-98cf-4d9a-9874-a1fa4259aa57	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-04-21 14:15:00+00	2025-05-26 14:14:00+00	\N	AUTOMATICO	\N	\N	2025-07-10 14:14:00+00	2026-01-24 13:17:07.499+00	2026-01-24 13:17:07.499+00	t	\N	MC	\N	\N	\N
0a0a9aed-1beb-4024-b4c4-9f1a0f46b573	2025	66	15687486-8080-4a88-8dcc-b2cf1f38f297	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-05-02 14:40:00+00	2025-05-25 15:35:00+00	\N	AUTOMATICO	\N	\N	2025-07-09 15:35:00+00	2026-01-24 13:17:07.521+00	2026-01-24 13:17:07.521+00	t	\N	MC	30	\N	\N
ef527485-da69-42d4-951e-798b20ee9af8	2025	108	1ea649cb-98cf-4d9a-9874-a1fa4259aa57	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-06-25 12:30:00+00	2025-08-04 08:33:00+00	\N	AUTOMATICO	\N	\N	2025-09-18 08:33:00+00	2026-01-24 13:17:07.54+00	2026-01-24 13:17:07.54+00	t	\N	MC	\N	\N	\N
3a433221-8591-4f3b-8cef-31084e1f828c	2025	95	80a91104-b031-4e3c-8308-fbdff126f6dc	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-06-05 17:40:00+00	2025-07-06 07:53:00+00	\N	AUTOMATICO	\N	\N	2025-08-20 07:53:00+00	2026-01-24 13:17:07.565+00	2026-01-24 13:17:07.565+00	t	\N	MC	60	\N	\N
555b4f0e-c83e-44b1-a5de-c379cfde7d14	2025	148	07a74d76-74eb-41da-aa75-e2dc05a6923d	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-08-20 12:58:00+00	2025-08-30 07:00:00+00	\N	AUTOMATICO	\N	\N	2025-10-14 07:00:00+00	2026-01-24 13:17:07.581+00	2026-01-24 13:17:07.581+00	t	\N	MC	30	\N	\N
b57e72de-3e87-4a74-9a05-b100c3bec284	2025	147	80a91104-b031-4e3c-8308-fbdff126f6dc	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-08-23 12:00:00+00	2025-09-22 13:34:00+00	\N	AUTOMATICO	\N	\N	2025-11-06 13:34:00+00	2026-01-24 13:17:07.597+00	2026-01-24 13:17:07.597+00	t	\N	MC	60	\N	\N
07e6845b-64e4-454d-b71a-c8c6faa56252	2025	139	ce913a90-01c5-45ec-be08-2d1dfb5d47b8	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-08-03 18:40:00+00	2025-08-22 10:25:00+00	\N	AUTOMATICO	\N	\N	2025-10-06 10:25:00+00	2026-01-24 13:17:07.616+00	2026-01-24 13:17:07.616+00	t	\N	MC	10	\N	\N
7c7e2bdb-377b-4a46-a30b-66b50374ec9d	2025	151	fadfa149-546e-4dd2-b3b8-caea5b867715	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-08-30 10:49:00+00	2025-08-30 16:01:00+00	\N	AUTOMATICO	\N	\N	2025-10-14 16:01:00+00	2026-01-24 13:17:07.642+00	2026-01-24 13:17:07.642+00	t	\N	MC	60	\N	\N
89f84f11-855d-4ce0-a05e-dd4d879e51d5	2025	153	79841e78-cd00-4ede-ae56-ee11250a4ac0	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-08-30 17:07:00+00	2025-10-06 19:53:00+00	\N	AUTOMATICO	\N	\N	2025-11-20 19:53:00+00	2026-01-24 13:17:07.656+00	2026-01-24 13:17:07.656+00	t	\N	MC	60	\N	\N
eb02571d-39b4-4e07-a678-133a60a00726	2025	152	040eac5c-9520-4870-bbeb-08f72b1257cd	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-09-01 20:30:00+00	2025-10-08 08:15:00+00	\N	AUTOMATICO	\N	\N	2025-11-22 08:15:00+00	2026-01-24 13:17:07.672+00	2026-01-24 13:17:07.672+00	t	\N	MC	\N	\N	\N
e2654362-e9f9-4bfe-adc5-f35f3dba5cd5	2025	134	9da1c921-7ee5-4d2e-aea5-856859297876	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-07-25 17:15:00+00	2025-08-20 09:55:00+00	\N	AUTOMATICO	\N	\N	2025-10-04 09:55:00+00	2026-01-24 13:17:07.694+00	2026-01-24 13:17:07.694+00	t	\N	MC	30	\N	\N
b9c4964e-3892-48ca-83b5-33887d833744	2025	143	a00fb9df-72ef-4774-b4e8-2660c65f57ae	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-08-08 15:34:00+00	2025-09-01 12:18:00+00	\N	AUTOMATICO	\N	\N	2025-10-16 12:18:00+00	2026-01-24 13:17:07.732+00	2026-01-24 13:17:07.732+00	t	\N	MC	30	\N	\N
fc9e057a-a06b-426f-bf4a-ef4a1f3ea33e	2025	142	4a8e0a76-a896-4f17-ab23-56cbb32a6d4b	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-08-07 12:50:00+00	2025-09-16 09:29:00+00	\N	AUTOMATICO	\N	\N	2025-10-31 09:29:00+00	2026-01-24 13:17:07.747+00	2026-01-24 13:17:07.747+00	t	\N	MC	30	\N	\N
10c022c0-8e4e-4591-bd67-e2c700a0b734	2025	145	01848dba-0ced-4aec-8d7e-9325bec66253	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-08-14 17:45:00+00	2025-09-23 04:49:00+00	\N	AUTOMATICO	\N	\N	2025-11-07 04:49:00+00	2026-01-24 13:17:07.773+00	2026-01-24 13:17:07.773+00	t	\N	MC	30	\N	\N
4b414822-7ad3-47b7-8221-d7150a666d05	2025	157	210ffb51-daba-4d2b-93fb-b4915bd47552	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-09-11 09:33:00+00	2025-10-18 06:53:00+00	\N	AUTOMATICO	\N	\N	2025-12-02 06:53:00+00	2026-01-24 13:17:07.798+00	2026-01-24 13:17:07.798+00	t	\N	MC	60	\N	\N
5cce0b2b-7598-46a2-b04a-0fb6febbdcbd	2025	158	20fde841-e14c-4dc0-8b67-0c1dbd944bea	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-09-13 18:00:00+00	2025-10-12 10:20:00+00	\N	AUTOMATICO	\N	\N	2025-11-26 10:20:00+00	2026-01-24 13:17:07.813+00	2026-01-24 13:17:07.813+00	t	\N	MC	30	\N	\N
9713ce47-d321-4be6-9cd9-bdd14b46cc4c	2025	163	5b11295e-6b0b-4983-ade2-4c94e98cc8d0	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-09-17 16:55:00+00	2025-11-17 20:50:00+00	\N	AUTOMATICO	\N	\N	2026-01-01 20:50:00+00	2026-01-24 13:17:07.827+00	2026-01-24 13:17:07.827+00	t	\N	MC	60	\N	\N
a79d2260-26ca-432a-8ed9-740f67ea76de	2025	160	945b3158-6a8c-4360-97ad-0f50574e46a9	1eeb0dff-da3b-4dfa-8fe2-e415f817921d	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-10-17 10:30:00+00	2025-11-06 07:50:00+00	\N	AUTOMATICO	\N	\N	2025-12-21 07:50:00+00	2026-01-24 13:17:07.84+00	2026-01-24 13:17:07.84+00	t	\N	MC	30	\N	\N
75ac6df5-7e24-4b50-895f-97dc0a066b08	2025	166	a8956f2f-f8e4-4387-8fa3-48ea20c38489	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-09-30 15:15:00+00	2025-11-01 16:20:00+00	\N	AUTOMATICO	\N	\N	2025-12-16 16:20:00+00	2026-01-24 13:17:07.855+00	2026-01-24 13:17:07.855+00	t	\N	MC	60	\N	\N
76acf2e6-dc4c-477b-811f-9bac3abeeb35	2025	174	af79bace-7650-4a0c-bc89-093d01dae7c5	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-10-27 16:46:00+00	2025-12-07 09:47:00+00	\N	AUTOMATICO	\N	\N	2026-01-21 09:47:00+00	2026-01-24 13:17:07.873+00	2026-01-24 13:17:07.873+00	t	\N	MC	45	\N	\N
f00ea4ef-0c6c-4c64-bb5a-d4488f445bde	2025	176	01848dba-0ced-4aec-8d7e-9325bec66253	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-11-01 16:32:00+00	2025-11-12 08:22:00+00	\N	AUTOMATICO	\N	\N	2025-12-27 08:22:00+00	2026-01-24 13:17:07.886+00	2026-01-24 13:17:07.886+00	t	\N	MC	30	\N	\N
1ccf9f45-796c-4b1f-a5bd-4b7fa3b0b41b	2025	179	bbc5a90f-2320-46fa-af87-93519487a696	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-11-04 20:21:00+00	2025-11-11 06:35:00+00	\N	AUTOMATICO	\N	\N	2025-12-26 06:35:00+00	2026-01-24 13:17:07.901+00	2026-01-24 13:17:07.901+00	t	\N	MC	30	\N	\N
ee86dfed-f026-4771-ba14-74524f130003	2025	177	4ce964a6-9e77-43e3-9dff-6609a4675e41	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-11-03 20:30:00+00	2025-12-11 15:30:00+00	\N	AUTOMATICO	\N	\N	2026-01-25 15:30:00+00	2026-01-24 13:17:07.919+00	2026-01-24 13:17:07.919+00	t	\N	MC	30	\N	\N
cc47ae74-fcf9-4ae5-b89f-8bba2cff094b	2025	170	9da1c921-7ee5-4d2e-aea5-856859297876	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-10-19 11:02:00+00	2025-11-08 20:15:00+00	\N	AUTOMATICO	\N	\N	2025-12-23 20:15:00+00	2026-01-24 13:17:07.944+00	2026-01-24 13:17:07.944+00	t	\N	MC	30	\N	\N
8169f516-50a4-4345-b7a6-30502d36ec64	2025	167	ae3d4e22-1208-4514-9403-30fd4a94f051	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-09-30 20:58:00+00	2025-11-07 15:40:00+00	\N	AUTOMATICO	\N	\N	2025-12-22 15:40:00+00	2026-01-24 13:17:07.966+00	2026-01-24 13:17:07.966+00	t	\N	MC	30	\N	\N
6bec345b-7a6b-436c-bfcc-6448a2a72928	2025	156	2682d1b5-20fd-4a53-b251-7ddcdab963c1	1eeb0dff-da3b-4dfa-8fe2-e415f817921d	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-09-13 19:00:00+00	2025-10-01 00:00:00+00	\N	AUTOMATICO	\N	\N	2025-11-15 00:00:00+00	2026-01-24 13:17:07.996+00	2026-01-24 13:17:07.996+00	t	\N	MC	30	\N	\N
dda05ff7-1cf0-444c-b1a2-0e317fef64be	2025	155	af79bace-7650-4a0c-bc89-093d01dae7c5	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-09-10 23:05:00+00	2025-10-20 18:20:00+00	\N	AUTOMATICO	\N	\N	2025-12-04 18:20:00+00	2026-01-24 13:17:08.01+00	2026-01-24 13:17:08.01+00	t	\N	MC	45	\N	\N
b6cfb478-75d9-49ba-b170-18c94c80e46e	2025	150	0c3cb200-f011-4dff-a053-092fa3567310	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-08-26 00:00:00+00	2025-09-07 00:00:00+00	\N	AUTOMATICO	\N	\N	2025-10-22 00:00:00+00	2026-01-24 13:17:08.023+00	2026-01-24 13:17:08.023+00	t	\N	MC	\N	\N	\N
1bcb4ace-f305-411d-89fd-275511c4289e	2025	149	c4e6cd7e-ba70-4080-b4dd-49361dd03287	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-08-21 19:40:00+00	2025-09-19 09:35:00+00	\N	AUTOMATICO	\N	\N	2025-11-03 09:35:00+00	2026-01-24 13:17:08.036+00	2026-01-24 13:17:08.036+00	t	\N	MC	60	\N	\N
6be05dc6-fa9d-4498-937b-b55a632be4ee	2025	146	05bcda73-0d39-41dd-b4e9-c8865cad2a69	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-08-17 13:50:00+00	2025-09-18 13:08:00+00	\N	AUTOMATICO	\N	\N	2025-11-02 13:08:00+00	2026-01-24 13:17:08.055+00	2026-01-24 13:17:08.055+00	t	\N	MC	30	\N	\N
797967f5-0771-4c14-b776-a8d3b8dcc807	2025	144	e81456a2-5c94-4b6f-8fc3-1291242db58d	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-08-08 13:53:00+00	2025-09-21 08:50:00+00	\N	AUTOMATICO	\N	\N	2025-11-05 08:50:00+00	2026-01-24 13:17:08.079+00	2026-01-24 13:17:08.079+00	t	\N	MC	30	\N	\N
f06c8a0b-03d2-4af3-9393-37c1e9aad51c	2025	133	881c9a5b-7d9d-45d9-91b1-ac3bb7b43e48	\N	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-07-23 20:10:00+00	2025-09-25 10:34:00+00	\N	AUTOMATICO	\N	\N	2025-11-09 10:34:00+00	2026-01-24 13:17:08.1+00	2026-01-24 13:17:08.1+00	t	\N	MC	\N	\N	\N
cd6833f3-26c4-48cb-a309-97923e607819	2025	15	ae3d4e22-1208-4514-9403-30fd4a94f051	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-01-12 20:59:00+00	2025-02-12 14:07:00+00	\N	AUTOMATICO	\N	\N	2025-03-29 14:07:00+00	2026-01-24 13:17:08.12+00	2026-01-24 13:17:08.12+00	t	\N	MC	30	\N	\N
4f4c8356-a77a-4fe5-9d94-4fc503d4dd2f	2025	169	1b2c15e0-ece3-4c58-8334-079d6d844c0e	1eeb0dff-da3b-4dfa-8fe2-e415f817921d	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-10-12 01:35:00+00	2025-12-05 06:24:00+00	\N	AUTOMATICO	\N	\N	2026-01-19 06:24:00+00	2026-01-24 13:17:08.144+00	2026-01-24 13:17:08.144+00	t	\N	MC	30	\N	\N
1c4df91d-ef85-4e6b-82f0-903f1f436093	2025	165	7e7de950-28ea-49ac-af70-269988863345	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-09-29 22:30:00+00	2025-10-29 03:30:00+00	\N	AUTOMATICO	\N	\N	2025-12-13 03:30:00+00	2026-01-24 13:17:08.165+00	2026-01-24 13:17:08.165+00	t	\N	MC	60	\N	\N
7afcf1c4-8e13-4db8-96e7-2840b865a386	2025	159	cff19edb-4d41-4a8a-92ed-2a57683ba0fe	1eeb0dff-da3b-4dfa-8fe2-e415f817921d	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-10-13 21:15:00+00	2025-11-08 07:50:00+00	\N	AUTOMATICO	\N	\N	2025-12-23 07:50:00+00	2026-01-24 13:17:08.188+00	2026-01-24 13:17:08.188+00	t	\N	MC	30	\N	\N
59e197e9-2351-425b-bfbb-b426a7a9778f	2025	162	377b5ead-3c81-4651-ba39-035d8aa8057d	1eeb0dff-da3b-4dfa-8fe2-e415f817921d	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-10-14 16:17:00+00	2025-12-04 11:51:00+00	\N	AUTOMATICO	\N	\N	2026-01-18 11:51:00+00	2026-01-24 13:17:08.203+00	2026-01-24 13:17:08.203+00	t	\N	MC	30	\N	\N
bd74cbb2-d9fa-4488-8f5a-9028c8228439	2025	168	79841e78-cd00-4ede-ae56-ee11250a4ac0	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-10-14 18:50:00+00	2025-11-23 08:22:00+00	\N	AUTOMATICO	\N	\N	2026-01-07 08:22:00+00	2026-01-24 13:17:08.22+00	2026-01-24 13:17:08.22+00	t	\N	MC	60	\N	\N
e60f8e79-f5fb-4de4-990c-15e85fc61682	2025	175	1ea649cb-98cf-4d9a-9874-a1fa4259aa57	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-11-04 00:00:00+00	2025-12-06 19:45:00+00	\N	AUTOMATICO	\N	\N	2026-01-20 19:45:00+00	2026-01-24 13:17:08.236+00	2026-01-24 13:17:08.236+00	t	\N	MC	\N	\N	\N
f3defc2c-0329-4dce-b377-73ea790aa984	2025	13	e0ddb3b7-34f4-4473-8211-0e6c585ab6bd	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-01-11 07:45:00+00	2025-02-15 00:35:00+00	\N	AUTOMATICO	\N	\N	2025-04-01 00:35:00+00	2026-01-24 13:17:08.264+00	2026-01-24 13:17:08.264+00	t	\N	MC	30	\N	\N
980e2222-7add-4d66-a760-18d57de0f8c6	2025	185	ae3d4e22-1208-4514-9403-30fd4a94f051	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-12-02 20:03:00+00	2025-12-13 07:05:00+00	\N	AUTOMATICO	\N	\N	2026-01-27 07:05:00+00	2026-01-24 13:17:08.298+00	2026-01-24 13:17:08.298+00	t	\N	MC	30	\N	\N
8a58a426-eff9-4e1a-8d8d-4e53ffa5bff9	2024	170	7b0a7e6a-a71b-43b0-b9e2-cca0b5518ab0	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-12-27 23:50:00+00	2025-02-17 04:35:00+00	\N	AUTOMATICO	\N	\N	2025-04-03 04:35:00+00	2026-01-24 13:17:08.315+00	2026-01-24 13:17:08.315+00	t	\N	MC	60	\N	\N
0f54a12f-e40c-4a1c-aa90-0ffc1f27ed36	2024	169	673c0f77-1eb5-417b-a222-7791be50ce45	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-12-12 16:15:00+00	2025-01-02 00:00:00+00	\N	AUTOMATICO	\N	\N	2025-02-16 00:00:00+00	2026-01-24 13:17:08.331+00	2026-01-24 13:17:08.331+00	t	\N	MC	60	\N	\N
e2c05b14-ff8e-420a-9da2-7433d0cfca64	2025	200	b96eb56c-f54e-4a39-ad03-f7d68245044e	4f54264c-4a35-48b2-adf7-15a31cd493f0	9acdf957-9a1a-4786-8463-f69262b0d65d	\N	2025-12-29 16:26:00+00	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-24 13:17:08.346+00	2026-01-24 13:17:08.346+00	t	\N	MC	40	\N	\N
d475ea64-c7f6-426e-960f-b42eb00a2482	2025	201	bf67761e-0c77-4360-8eee-fdec0487fef9	4f54264c-4a35-48b2-adf7-15a31cd493f0	9acdf957-9a1a-4786-8463-f69262b0d65d	\N	2025-12-29 17:15:00+00	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-24 13:17:08.362+00	2026-01-24 13:17:08.362+00	t	\N	MC	40	\N	\N
31d0887c-0bd7-4020-b987-1df21da96751	2025	161	f749d131-dad5-4391-9239-d3eff37d4e93	1eeb0dff-da3b-4dfa-8fe2-e415f817921d	9958d706-2c00-447c-b303-b8a2fa2ce060	2025-11-06 03:00:00+00	2025-10-14 15:40:00+00	2025-12-19 07:30:00+00	\N	AUTOMATICO	\N	\N	2025-12-14 07:30:00+00	2026-01-24 13:17:08.379+00	2026-01-24 13:17:08.379+00	t	\N	MC	30	\N	\N
eafcf984-b27a-42e2-bc66-3e5327ce9556	2024	153	d73fdcef-e978-44ca-a105-6066e9d96445	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-10-04 17:24:00+00	2024-10-20 08:31:00+00	\N	AUTOMATICO	\N	\N	2024-12-04 08:31:00+00	2026-01-24 13:17:08.4+00	2026-01-24 13:17:08.4+00	t	\N	MC	30	\N	\N
1b489224-3e5c-4ad6-9687-020e4d013a27	2024	152	f4f48e38-8826-4db0-a659-951dee4e373f	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-10-04 20:45:00+00	2024-11-13 08:14:00+00	\N	AUTOMATICO	\N	\N	2024-12-28 08:14:00+00	2026-01-24 13:17:08.415+00	2026-01-24 13:17:08.415+00	t	\N	MC	60	\N	\N
62352c42-cc04-4af7-88b9-c0f13d39e859	2025	199	f4f48e38-8826-4db0-a659-951dee4e373f	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	9acdf957-9a1a-4786-8463-f69262b0d65d	\N	2026-01-09 10:32:00+00	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-24 13:17:08.43+00	2026-01-24 13:17:08.43+00	t	\N	MC	60	\N	\N
f86c05c6-0fe3-4d30-846e-f510a804f1dd	2024	155	af79bace-7650-4a0c-bc89-093d01dae7c5	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-10-15 19:25:00+00	2024-11-02 18:30:00+00	\N	AUTOMATICO	\N	\N	2024-12-17 18:30:00+00	2026-01-24 13:17:08.444+00	2026-01-24 13:17:08.444+00	t	\N	MC	45	\N	\N
fe404f4e-e2c5-4fd8-9895-2dce4943cdd0	2024	143	7b0a7e6a-a71b-43b0-b9e2-cca0b5518ab0	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-09-18 14:45:00+00	2024-10-30 19:05:00+00	\N	AUTOMATICO	\N	\N	2024-12-14 19:05:00+00	2026-01-24 13:17:08.455+00	2026-01-24 13:17:08.455+00	t	\N	MC	60	\N	\N
89039635-7283-41b5-a759-7091a984f4fa	2024	158	0b03eed0-e253-4914-8683-24e4f03a00f7	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-10-19 07:00:00+00	2024-11-25 14:15:00+00	\N	AUTOMATICO	\N	\N	2025-01-09 14:15:00+00	2026-01-24 13:17:08.47+00	2026-01-24 13:17:08.47+00	t	\N	MC	40	\N	\N
f2bd35f9-f2b3-4142-8ee9-f309b78a44b8	2024	154	aeb1c939-78bd-4a60-a082-f9a46ed969d3	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-01-01 06:46:00+00	2024-10-13 23:39:00+00	\N	AUTOMATICO	\N	\N	2024-11-27 23:39:00+00	2026-01-24 13:17:08.486+00	2026-01-24 13:17:08.486+00	t	\N	MC	30	\N	\N
40aef3ca-6766-4d63-a9f5-10ae792eabc4	2024	151	5b11295e-6b0b-4983-ade2-4c94e98cc8d0	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-10-10 21:45:00+00	2024-12-03 05:45:00+00	\N	AUTOMATICO	\N	\N	2025-01-17 05:45:00+00	2026-01-24 13:17:08.501+00	2026-01-24 13:17:08.501+00	t	\N	MC	60	\N	\N
5a135385-e24c-47b3-ab02-df8bb56422db	2025	180	cff19edb-4d41-4a8a-92ed-2a57683ba0fe	1eeb0dff-da3b-4dfa-8fe2-e415f817921d	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-11-12 14:03:00+00	2025-12-24 06:11:00+00	\N	AUTOMATICO	\N	\N	2026-02-07 06:11:00+00	2026-01-24 13:17:08.517+00	2026-01-24 13:17:08.517+00	t	\N	MC	30	\N	\N
4900b0ef-f70d-4825-97e6-1b111f6a8f72	2025	164	c4e6cd7e-ba70-4080-b4dd-49361dd03287	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-09-20 15:40:00+00	2025-10-07 06:28:00+00	\N	AUTOMATICO	\N	\N	2025-11-21 06:28:00+00	2026-01-24 13:17:08.536+00	2026-01-24 13:17:08.536+00	t	\N	MC	60	\N	\N
d7ffdde0-c397-4c6e-90da-071048d351f9	2024	159	d73fdcef-e978-44ca-a105-6066e9d96445	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-10-23 19:20:00+00	2024-11-08 14:05:00+00	\N	AUTOMATICO	\N	\N	2024-12-23 14:05:00+00	2026-01-24 13:17:08.551+00	2026-01-24 13:17:08.551+00	t	\N	MC	30	\N	\N
53bd145c-4aa0-485a-a4c0-53cfa2d5b51c	2024	160	7e7de950-28ea-49ac-af70-269988863345	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-11-01 07:25:00+00	2024-12-12 21:10:00+00	\N	AUTOMATICO	\N	\N	2025-01-26 21:10:00+00	2026-01-24 13:17:08.567+00	2026-01-24 13:17:08.567+00	t	\N	MC	60	\N	\N
e1f0e324-31f8-47fc-8f50-436e727df1ae	2024	162	cff19edb-4d41-4a8a-92ed-2a57683ba0fe	1eeb0dff-da3b-4dfa-8fe2-e415f817921d	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-11-02 23:35:00+00	2024-11-23 08:30:00+00	\N	AUTOMATICO	\N	\N	2025-01-07 08:30:00+00	2026-01-24 13:17:08.583+00	2026-01-24 13:17:08.583+00	t	\N	MC	30	\N	\N
19ff0885-8396-4d47-97ac-eb619eee0f74	2023	161	7b0a7e6a-a71b-43b0-b9e2-cca0b5518ab0	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2023-12-28 00:50:00+00	2024-02-01 09:30:00+00	\N	AUTOMATICO	\N	\N	2024-03-17 09:30:00+00	2026-01-24 13:17:08.598+00	2026-01-24 13:17:08.598+00	t	\N	MC	60	\N	\N
d890b49f-e166-477e-9243-046732717708	2024	110	9da1c921-7ee5-4d2e-aea5-856859297876	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-07-05 19:50:00+00	2024-07-09 11:00:00+00	\N	AUTOMATICO	\N	\N	2024-08-23 11:00:00+00	2026-01-24 13:17:08.614+00	2026-01-24 13:17:08.614+00	t	\N	MC	30	\N	\N
591d31d6-8bd5-4c4b-b35c-5f5341eb1029	2024	124	a4d7c454-cc68-4c7f-a668-73f965a7b421	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-08-06 22:10:00+00	2024-08-19 11:35:00+00	\N	AUTOMATICO	\N	\N	2024-10-03 11:35:00+00	2026-01-24 13:17:08.631+00	2026-01-24 13:17:08.631+00	t	\N	MC	30	\N	\N
5e781767-f7eb-4add-916c-235bf92b347f	2024	14	2682d1b5-20fd-4a53-b251-7ddcdab963c1	1eeb0dff-da3b-4dfa-8fe2-e415f817921d	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-01-16 16:25:00+00	2024-02-02 00:00:00+00	\N	AUTOMATICO	\N	\N	2024-03-18 00:00:00+00	2026-01-24 13:17:08.646+00	2026-01-24 13:17:08.646+00	t	\N	MC	30	\N	\N
e8162f7d-18a9-4220-a2dc-b57a3738046b	2024	81	7e7de950-28ea-49ac-af70-269988863345	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-05-24 22:00:00+00	2024-06-09 12:30:00+00	\N	AUTOMATICO	\N	\N	2024-07-24 12:30:00+00	2026-01-24 13:17:08.66+00	2026-01-24 13:17:08.66+00	t	\N	MC	60	\N	\N
e2baf9fd-91da-4ffd-acc5-1145fde03a87	2024	122	2682d1b5-20fd-4a53-b251-7ddcdab963c1	1eeb0dff-da3b-4dfa-8fe2-e415f817921d	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-08-02 13:25:00+00	2024-09-11 10:50:00+00	\N	AUTOMATICO	\N	\N	2024-10-26 10:50:00+00	2026-01-24 13:17:08.674+00	2026-01-24 13:17:08.674+00	t	\N	MC	30	\N	\N
efafcdf6-7595-43c5-bbbc-cb7031f6650f	2024	163	2682d1b5-20fd-4a53-b251-7ddcdab963c1	1eeb0dff-da3b-4dfa-8fe2-e415f817921d	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-10-31 00:00:00+00	2024-11-11 14:55:00+00	\N	AUTOMATICO	\N	\N	2024-12-26 14:55:00+00	2026-01-24 13:17:08.688+00	2026-01-24 13:17:08.688+00	t	\N	MC	30	\N	\N
e2a6438c-34c7-4863-a6ad-cf188aa87224	2024	53	e81456a2-5c94-4b6f-8fc3-1291242db58d	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-03-28 18:12:00+00	2024-04-26 21:05:00+00	\N	AUTOMATICO	\N	\N	2024-06-10 21:05:00+00	2026-01-24 13:17:08.703+00	2026-01-24 13:17:08.703+00	t	\N	MC	30	\N	\N
8468cb61-f4a8-4b25-b077-5b670e2e20b9	2024	69	fb3b141b-abd3-4275-9a6d-2f779efa7bcb	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-04-30 14:30:00+00	2024-05-19 10:49:00+00	\N	AUTOMATICO	\N	\N	2024-07-03 10:49:00+00	2026-01-24 13:17:08.718+00	2026-01-24 13:17:08.718+00	t	\N	MC	30	\N	\N
d8515180-194f-41ba-aedd-cda1f08c8121	2024	90	e78dcbb5-36d9-4aca-a151-e9c42a70cc09	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-05-23 18:15:00+00	2024-06-13 14:36:00+00	\N	AUTOMATICO	\N	\N	2024-07-28 14:36:00+00	2026-01-24 13:17:08.731+00	2026-01-24 13:17:08.731+00	t	\N	MC	30	\N	\N
9cb68e49-ace8-4584-84f4-402a94514ec6	2024	99	fb3b141b-abd3-4275-9a6d-2f779efa7bcb	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-06-19 21:40:00+00	2024-08-02 11:20:00+00	\N	AUTOMATICO	\N	\N	2024-09-16 11:20:00+00	2026-01-24 13:17:08.745+00	2026-01-24 13:17:08.745+00	t	\N	MC	30	\N	\N
f82d0e5c-f8d3-427a-976f-254202b454b4	2025	191	edd87f10-eea7-4484-85b5-c4e725767ea8	4f54264c-4a35-48b2-adf7-15a31cd493f0	94c1d788-a09b-4d7d-a45a-fab7eeeab437	\N	2025-12-29 13:00:00+00	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-24 13:17:08.759+00	2026-01-24 13:17:08.759+00	t	\N	MC	40	\N	\N
2d704937-98e2-451f-87b2-4c5bcbf9ceb0	2025	198	c8f549d2-ef48-4931-82db-5f6650dd4dfb	4f54264c-4a35-48b2-adf7-15a31cd493f0	9acdf957-9a1a-4786-8463-f69262b0d65d	\N	2025-12-29 19:02:00+00	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-24 13:17:08.781+00	2026-01-24 13:17:08.781+00	t	\N	MC	40	\N	\N
ad02fd80-86df-4475-a900-a6ae9b15d231	2025	183	2682d1b5-20fd-4a53-b251-7ddcdab963c1	1eeb0dff-da3b-4dfa-8fe2-e415f817921d	94c1d788-a09b-4d7d-a45a-fab7eeeab437	\N	2025-11-26 20:00:00+00	2026-01-04 19:00:00+00	\N	AUTOMATICO	\N	\N	2026-02-18 19:00:00+00	2026-01-24 13:17:08.799+00	2026-01-24 13:17:08.799+00	t	\N	MC	30	\N	\N
56179c3f-3e6a-4a21-bc62-8ce00aea1c67	2025	189	d1f683c2-69b1-4ab5-86e2-51f1a456b827	4f54264c-4a35-48b2-adf7-15a31cd493f0	9acdf957-9a1a-4786-8463-f69262b0d65d	\N	2025-12-29 18:35:00+00	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-24 13:17:08.815+00	2026-01-24 13:17:08.815+00	t	\N	MC	40	\N	\N
8017564a-6168-4454-a6a3-6bf4505d1f03	2025	195	1b2c15e0-ece3-4c58-8334-079d6d844c0e	1eeb0dff-da3b-4dfa-8fe2-e415f817921d	9acdf957-9a1a-4786-8463-f69262b0d65d	\N	2025-12-30 21:40:00+00	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-24 13:17:08.834+00	2026-01-24 13:17:08.834+00	t	\N	MC	30	\N	\N
25e40b6e-feee-4555-a6ba-62bfbc7f58ef	2025	197	377b5ead-3c81-4651-ba39-035d8aa8057d	1eeb0dff-da3b-4dfa-8fe2-e415f817921d	9acdf957-9a1a-4786-8463-f69262b0d65d	\N	2025-12-30 22:40:00+00	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-24 13:17:08.85+00	2026-01-24 13:17:08.85+00	t	\N	MC	30	\N	\N
8c6f48f4-807c-4012-865a-3a3420d96bab	2025	196	f749d131-dad5-4391-9239-d3eff37d4e93	1eeb0dff-da3b-4dfa-8fe2-e415f817921d	9acdf957-9a1a-4786-8463-f69262b0d65d	2025-12-21 03:00:00+00	2025-12-23 17:20:00+00	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-24 13:17:08.868+00	2026-01-24 13:17:08.868+00	t	\N	MC	30	\N	\N
8e8e3e0e-7361-4f1e-8ba9-ec61cdb41b1e	2024	121	fb3b141b-abd3-4275-9a6d-2f779efa7bcb	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-08-03 17:47:00+00	2024-08-13 13:15:00+00	\N	AUTOMATICO	\N	\N	2024-09-27 13:15:00+00	2026-01-24 13:17:08.889+00	2026-01-24 13:17:08.889+00	t	\N	MC	30	\N	\N
b6ef2475-dd87-4735-9868-30bf32eea7f6	2024	21	7b0a7e6a-a71b-43b0-b9e2-cca0b5518ab0	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-02-03 09:55:00+00	2024-03-20 03:00:00+00	\N	AUTOMATICO	\N	\N	2024-05-04 03:00:00+00	2026-01-24 13:17:08.902+00	2026-01-24 13:17:08.902+00	t	\N	MC	60	\N	\N
07d0498b-93cb-4ce6-a0e4-1b2119aa41fc	2024	61	a8956f2f-f8e4-4387-8fa3-48ea20c38489	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-04-20 14:15:00+00	2024-05-25 12:45:00+00	\N	AUTOMATICO	\N	\N	2024-07-09 12:45:00+00	2026-01-24 13:17:08.917+00	2026-01-24 13:17:08.917+00	t	\N	MC	60	\N	\N
e6c3ed40-333d-48dc-bba4-3d0054f74f6b	2024	27	80a91104-b031-4e3c-8308-fbdff126f6dc	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-02-07 18:15:00+00	2024-03-13 15:10:00+00	\N	AUTOMATICO	\N	\N	2024-04-27 15:10:00+00	2026-01-24 13:17:08.932+00	2026-01-24 13:17:08.932+00	t	\N	MC	60	\N	\N
1db04fe3-2c1e-4586-9fd5-42821e21fb2e	2024	66	fadfa149-546e-4dd2-b3b8-caea5b867715	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-04-26 16:40:00+00	2024-05-26 18:50:00+00	\N	AUTOMATICO	\N	\N	2024-07-10 18:50:00+00	2026-01-24 13:17:08.947+00	2026-01-24 13:17:08.947+00	t	\N	MC	60	\N	\N
beb03c38-1778-4d73-9257-26c76167226a	2024	91	fadfa149-546e-4dd2-b3b8-caea5b867715	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-05-29 15:40:00+00	2024-06-30 08:20:00+00	\N	AUTOMATICO	\N	\N	2024-08-14 08:20:00+00	2026-01-24 13:17:08.962+00	2026-01-24 13:17:08.962+00	t	\N	MC	60	\N	\N
2f831662-44f0-47d0-9772-8105d4d30abc	2024	114	210ffb51-daba-4d2b-93fb-b4915bd47552	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-07-17 08:42:00+00	2024-08-20 07:31:00+00	\N	AUTOMATICO	\N	\N	2024-10-04 07:31:00+00	2026-01-24 13:17:08.974+00	2026-01-24 13:17:08.974+00	t	\N	MC	60	\N	\N
60a78da6-36ba-45ad-9bb1-906e5b2a7e15	2024	134	210ffb51-daba-4d2b-93fb-b4915bd47552	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-09-02 19:00:00+00	2024-10-09 06:50:00+00	\N	AUTOMATICO	\N	\N	2024-11-23 06:50:00+00	2026-01-24 13:17:08.988+00	2026-01-24 13:17:08.988+00	t	\N	MC	60	\N	\N
a0e2f188-6522-40e5-8aa4-15033fb8225a	2024	20	ae3d4e22-1208-4514-9403-30fd4a94f051	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-01-22 03:08:00+00	2024-01-29 01:42:00+00	\N	AUTOMATICO	\N	\N	2024-03-14 01:42:00+00	2026-01-24 13:17:09.003+00	2026-01-24 13:17:09.003+00	t	\N	MC	30	\N	\N
dc78d927-913d-47a0-a78f-98cc235011e2	2024	56	70bb03e8-6c63-4397-a603-64b7e0f28e97	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-03-28 09:10:00+00	2024-04-15 12:45:00+00	\N	AUTOMATICO	\N	\N	2024-05-30 12:45:00+00	2026-01-24 13:17:09.018+00	2026-01-24 13:17:09.018+00	t	\N	MC	30	\N	\N
f64cb623-f276-49a7-b803-ec9b4fab0c17	2024	84	8edc52e7-45b1-4e9a-9df8-02eac46e8b3f	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-05-22 00:00:00+00	2024-06-09 00:00:00+00	\N	AUTOMATICO	\N	\N	2024-07-24 00:00:00+00	2026-01-24 13:17:09.034+00	2026-01-24 13:17:09.034+00	t	\N	MC	30	\N	\N
261a9424-6017-457f-9ede-0d834c0893c8	2024	125	040eac5c-9520-4870-bbeb-08f72b1257cd	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-08-08 19:15:00+00	2024-08-22 15:00:00+00	\N	AUTOMATICO	\N	\N	2024-10-06 15:00:00+00	2026-01-24 13:17:09.049+00	2026-01-24 13:17:09.049+00	t	\N	MC	\N	\N	\N
904c8609-d1e9-4dea-a0a2-c9824e164341	2024	62	169f1b5f-2325-4dd6-af4f-72cb7e86b741	4f54264c-4a35-48b2-adf7-15a31cd493f0	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-04-20 16:22:00+00	2024-05-15 09:06:00+00	\N	AUTOMATICO	\N	\N	2024-06-29 09:06:00+00	2026-01-24 13:17:09.063+00	2026-01-24 13:17:09.063+00	t	\N	MC	40	\N	\N
3937d6c3-6ad3-43b9-bc98-c7fa4de04c74	2024	95	18b98431-a4a2-463b-ae58-c784bcf1ae44	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-06-12 10:33:00+00	2024-06-18 10:54:00+00	\N	AUTOMATICO	\N	\N	2024-08-02 10:54:00+00	2026-01-24 13:17:09.077+00	2026-01-24 13:17:09.077+00	t	\N	MC	30	\N	\N
0760f5f9-afa4-4c90-a3cd-2cd9093eb2b2	2024	136	673c0f77-1eb5-417b-a222-7791be50ce45	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-09-02 22:00:00+00	2024-09-24 06:05:00+00	\N	AUTOMATICO	\N	\N	2024-11-08 06:05:00+00	2026-01-24 13:17:09.09+00	2026-01-24 13:17:09.09+00	t	\N	MC	60	\N	\N
f316b80a-01dc-427d-828c-fcf285b2e178	2024	35	05bcda73-0d39-41dd-b4e9-c8865cad2a69	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-02-22 18:00:00+00	2024-03-03 11:34:00+00	\N	AUTOMATICO	\N	\N	2024-04-17 11:34:00+00	2026-01-24 13:17:09.105+00	2026-01-24 13:17:09.105+00	t	\N	MC	30	\N	\N
6ceb334f-e35d-40d9-84c7-42caa6851f66	2024	119	15687486-8080-4a88-8dcc-b2cf1f38f297	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-08-02 18:10:00+00	2024-08-09 08:59:00+00	\N	AUTOMATICO	\N	\N	2024-09-23 08:59:00+00	2026-01-24 13:17:09.121+00	2026-01-24 13:17:09.121+00	t	\N	MC	30	\N	\N
826d1152-e4a1-4c52-8fd7-db181a9592f4	2024	141	4ce964a6-9e77-43e3-9dff-6609a4675e41	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-09-06 17:10:00+00	2024-09-13 06:27:00+00	\N	AUTOMATICO	\N	\N	2024-10-28 06:27:00+00	2026-01-24 13:17:09.136+00	2026-01-24 13:17:09.136+00	t	\N	MC	30	\N	\N
039eba13-308c-454b-b868-ede9323738d7	2024	33	c730a093-6360-4bd5-9c8a-125cc8fad7d7	4f54264c-4a35-48b2-adf7-15a31cd493f0	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-02-23 10:40:00+00	2024-03-25 17:15:00+00	\N	AUTOMATICO	\N	\N	2024-05-09 17:15:00+00	2026-01-24 13:17:09.153+00	2026-01-24 13:17:09.153+00	t	\N	MC	40	\N	\N
4cd1e100-0941-41d9-85c8-a02c11f95feb	2024	73	4e395848-f29c-4bed-b5f7-3f633bad01a2	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-05-02 15:55:00+00	2024-05-20 09:30:00+00	\N	AUTOMATICO	\N	\N	2024-07-04 09:30:00+00	2026-01-24 13:17:09.169+00	2026-01-24 13:17:09.169+00	t	\N	MC	30	\N	\N
bfe8941e-81ab-4671-bf1c-2c76cb572a7a	2024	24	1b2c15e0-ece3-4c58-8334-079d6d844c0e	1eeb0dff-da3b-4dfa-8fe2-e415f817921d	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-02-06 21:35:00+00	2024-03-03 09:15:00+00	\N	AUTOMATICO	\N	\N	2024-04-17 09:15:00+00	2026-01-24 13:17:09.184+00	2026-01-24 13:17:09.184+00	t	\N	MC	30	\N	\N
1330caa3-a5ea-46ea-9723-e3abd35dc4e2	2024	112	af79bace-7650-4a0c-bc89-093d01dae7c5	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-07-11 16:50:00+00	2024-08-07 12:35:00+00	\N	AUTOMATICO	\N	\N	2024-09-21 12:35:00+00	2026-01-24 13:17:09.198+00	2026-01-24 13:17:09.198+00	t	\N	MC	45	\N	\N
c14f74b4-a9f1-4c9a-8351-34f8449d5260	2024	130	4a8e0a76-a896-4f17-ab23-56cbb32a6d4b	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-08-16 15:46:00+00	2024-08-24 12:50:00+00	\N	AUTOMATICO	\N	\N	2024-10-08 12:50:00+00	2026-01-24 13:17:09.21+00	2026-01-24 13:17:09.21+00	t	\N	MC	30	\N	\N
ab9ceceb-3e72-4ddd-bfbe-02c3ec853962	2024	133	0b03eed0-e253-4914-8683-24e4f03a00f7	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-08-29 14:05:00+00	2024-10-15 18:40:00+00	\N	AUTOMATICO	\N	\N	2024-11-29 18:40:00+00	2026-01-24 13:17:09.223+00	2026-01-24 13:17:09.223+00	t	\N	MC	40	\N	\N
e31f7d95-5ab8-4752-86bc-9751ed519f14	2024	173	edd87f10-eea7-4484-85b5-c4e725767ea8	4f54264c-4a35-48b2-adf7-15a31cd493f0	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-12-28 13:10:00+00	2025-01-16 14:00:00+00	\N	AUTOMATICO	\N	\N	2025-03-02 14:00:00+00	2026-01-24 13:17:09.238+00	2026-01-24 13:17:09.238+00	t	\N	MC	40	\N	\N
e137ca35-4445-49ce-8e91-bf77fc8381e6	2024	161	7b0a7e6a-a71b-43b0-b9e2-cca0b5518ab0	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-11-03 18:35:00+00	2024-12-19 04:00:00+00	\N	AUTOMATICO	\N	\N	2025-02-02 04:00:00+00	2026-01-24 13:17:09.253+00	2026-01-24 13:17:09.253+00	t	\N	MC	60	\N	\N
31665fe3-0e2d-4027-9350-d021825083a1	2024	176	377b5ead-3c81-4651-ba39-035d8aa8057d	1eeb0dff-da3b-4dfa-8fe2-e415f817921d	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-12-30 22:34:00+00	2025-01-27 04:45:00+00	\N	AUTOMATICO	\N	\N	2025-03-13 04:45:00+00	2026-01-24 13:17:09.267+00	2026-01-24 13:17:09.267+00	t	\N	MC	30	\N	\N
04ba68d5-d4cd-4f54-a9fa-099543eee5a2	2024	175	1b2c15e0-ece3-4c58-8334-079d6d844c0e	1eeb0dff-da3b-4dfa-8fe2-e415f817921d	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-12-31 05:20:00+00	2025-02-04 04:52:00+00	\N	AUTOMATICO	\N	\N	2025-03-21 04:52:00+00	2026-01-24 13:17:09.282+00	2026-01-24 13:17:09.282+00	t	\N	MC	30	\N	\N
5d391bd6-0297-4e27-94bb-e1ed7fccc520	2025	1	7e7de950-28ea-49ac-af70-269988863345	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-01-03 04:35:00+00	2025-02-03 01:35:00+00	\N	AUTOMATICO	\N	\N	2025-03-20 01:35:00+00	2026-01-24 13:17:09.296+00	2026-01-24 13:17:09.296+00	t	\N	MC	60	\N	\N
65e34e09-47c5-4622-8ac2-1332f04df0f5	2024	149	80a91104-b031-4e3c-8308-fbdff126f6dc	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-10-04 10:09:00+00	2024-10-07 08:05:00+00	\N	AUTOMATICO	\N	\N	2024-11-21 08:05:00+00	2026-01-24 13:17:09.309+00	2026-01-24 13:17:09.309+00	t	\N	MC	60	\N	\N
b8008b59-a9c1-41be-9e9c-dff160947474	2025	7	f1b37e20-ec28-442f-aecb-290a35045124	4f54264c-4a35-48b2-adf7-15a31cd493f0	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-01-07 16:40:00+00	2025-01-30 08:50:00+00	\N	AUTOMATICO	\N	\N	2025-03-16 08:50:00+00	2026-01-24 13:17:09.322+00	2026-01-24 13:17:09.322+00	t	\N	MC	40	\N	\N
9b04ac72-d1a7-4c9e-a66d-caf4ea37e63b	2025	9	d73fdcef-e978-44ca-a105-6066e9d96445	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-01-06 20:55:00+00	2025-02-07 09:45:00+00	\N	AUTOMATICO	\N	\N	2025-03-24 09:45:00+00	2026-01-24 13:17:09.338+00	2026-01-24 13:17:09.338+00	t	\N	MC	30	\N	\N
d6b7ab71-4e86-4c51-8655-593d696c5057	2025	14	498c3f95-ae8b-4fb2-842e-32f77a63cd5b	4f54264c-4a35-48b2-adf7-15a31cd493f0	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-01-09 11:25:00+00	2025-02-08 21:54:00+00	\N	AUTOMATICO	\N	\N	2025-03-25 21:54:00+00	2026-01-24 13:17:09.353+00	2026-01-24 13:17:09.353+00	t	\N	MC	40	\N	\N
16e90a14-5b24-44b5-a008-81483ba1658f	2025	11	c730a093-6360-4bd5-9c8a-125cc8fad7d7	4f54264c-4a35-48b2-adf7-15a31cd493f0	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-01-09 15:00:00+00	2025-02-02 19:58:00+00	\N	AUTOMATICO	\N	\N	2025-03-19 19:58:00+00	2026-01-24 13:17:09.368+00	2026-01-24 13:17:09.368+00	t	\N	MC	40	\N	\N
60917dfc-88b1-4bc5-8791-6ae6ade27aeb	2025	4	7a0ed70d-e0c9-40ed-8167-389c0fe10e52	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-01-11 12:37:00+00	2025-03-07 11:14:00+00	\N	AUTOMATICO	\N	\N	2025-04-21 11:14:00+00	2026-01-24 13:17:09.383+00	2026-01-24 13:17:09.383+00	t	\N	MC	60	\N	\N
da5e8b57-028d-4d92-94cb-513bfe318ab6	2025	16	0b03eed0-e253-4914-8683-24e4f03a00f7	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-01-17 23:35:00+00	2025-03-01 19:40:00+00	\N	AUTOMATICO	\N	\N	2025-04-15 19:40:00+00	2026-01-24 13:17:09.399+00	2026-01-24 13:17:09.399+00	t	\N	MC	40	\N	\N
cc142ddb-9ddf-4249-8a3d-894a19fc254f	2025	33	ae3d4e22-1208-4514-9403-30fd4a94f051	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-02-18 11:27:00+00	2025-02-25 20:17:00+00	\N	AUTOMATICO	\N	\N	2025-04-11 20:17:00+00	2026-01-24 13:17:09.412+00	2026-01-24 13:17:09.412+00	t	\N	MC	30	\N	\N
c21f5a9c-c140-41c9-ad1c-708bf3c26b2a	2025	32	7b0a7e6a-a71b-43b0-b9e2-cca0b5518ab0	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-02-19 00:00:00+00	2025-04-11 09:30:00+00	\N	AUTOMATICO	\N	\N	2025-05-26 09:30:00+00	2026-01-24 13:17:09.425+00	2026-01-24 13:17:09.425+00	t	\N	MC	60	\N	\N
e53e2253-c732-4932-9db1-5b10963c2b02	2025	37	2682d1b5-20fd-4a53-b251-7ddcdab963c1	1eeb0dff-da3b-4dfa-8fe2-e415f817921d	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-02-22 09:10:00+00	2025-03-26 16:15:00+00	\N	AUTOMATICO	\N	\N	2025-05-10 16:15:00+00	2026-01-24 13:17:09.439+00	2026-01-24 13:17:09.439+00	t	\N	MC	30	\N	\N
1e824fd2-b41c-44d2-b96c-1f3bcce11028	2025	34	f4f48e38-8826-4db0-a659-951dee4e373f	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-03-01 13:40:00+00	2025-04-07 11:48:00+00	\N	AUTOMATICO	\N	\N	2025-05-22 11:48:00+00	2026-01-24 13:17:09.454+00	2026-01-24 13:17:09.454+00	t	\N	MC	60	\N	\N
8f4b3fd9-bac3-49e7-91d5-33830c337687	2024	171	2682d1b5-20fd-4a53-b251-7ddcdab963c1	1eeb0dff-da3b-4dfa-8fe2-e415f817921d	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-12-30 23:14:00+00	2025-02-19 11:11:00+00	\N	AUTOMATICO	\N	\N	2025-04-05 11:11:00+00	2026-01-24 13:17:09.469+00	2026-01-24 13:17:09.469+00	t	\N	MC	30	\N	\N
8635ded9-667b-4d2f-b4eb-11314fc2f93c	2025	41	a0a7acd7-9cd1-4920-9dff-1cb2605d4af5	4f54264c-4a35-48b2-adf7-15a31cd493f0	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-03-07 16:25:00+00	2025-04-07 12:56:00+00	\N	AUTOMATICO	\N	\N	2025-05-22 12:56:00+00	2026-01-24 13:17:09.487+00	2026-01-24 13:17:09.487+00	t	\N	MC	40	\N	\N
ea75be2d-11ae-4101-9d5b-e2e2d248afe1	2025	18	99aa6d59-9ea9-416a-8c00-3bd45e7b17b3	\N	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-01-17 18:40:00+00	2025-03-09 20:51:00+00	\N	AUTOMATICO	\N	\N	2025-04-23 20:51:00+00	2026-01-24 13:17:09.503+00	2026-01-24 13:17:09.503+00	t	\N	MC	\N	\N	\N
087134ea-2e52-4e88-8f12-a552df1141c9	2025	21	1b2c15e0-ece3-4c58-8334-079d6d844c0e	1eeb0dff-da3b-4dfa-8fe2-e415f817921d	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-02-06 00:08:00+00	2025-03-11 12:30:00+00	\N	AUTOMATICO	\N	\N	2025-04-25 12:30:00+00	2026-01-24 13:17:09.516+00	2026-01-24 13:17:09.516+00	t	\N	MC	30	\N	\N
e846f80f-3656-4b29-8adc-fd66355deba4	2025	22	cbe3f8c1-3200-4a53-b521-0aa4d2c8d9d1	4f54264c-4a35-48b2-adf7-15a31cd493f0	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-01-31 14:50:00+00	2025-03-24 09:35:00+00	\N	AUTOMATICO	\N	\N	2025-05-08 09:35:00+00	2026-01-24 13:17:09.531+00	2026-01-24 13:17:09.531+00	t	\N	MC	40	\N	\N
a36b8a24-7125-4e93-a452-2e26397924fe	2025	25	f749d131-dad5-4391-9239-d3eff37d4e93	1eeb0dff-da3b-4dfa-8fe2-e415f817921d	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-02-01 12:55:00+00	2025-02-26 06:55:00+00	\N	AUTOMATICO	\N	\N	2025-04-12 06:55:00+00	2026-01-24 13:17:09.542+00	2026-01-24 13:17:09.542+00	t	\N	MC	30	\N	\N
a0198db1-afc7-4cd4-a628-344216ca6a24	2025	27	d1f683c2-69b1-4ab5-86e2-51f1a456b827	4f54264c-4a35-48b2-adf7-15a31cd493f0	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-02-01 13:18:00+00	2025-03-08 06:19:00+00	\N	AUTOMATICO	\N	\N	2025-04-22 06:19:00+00	2026-01-24 13:17:09.556+00	2026-01-24 13:17:09.556+00	t	\N	MC	40	\N	\N
7525c091-0463-43c4-ad28-60bdcd31b009	2025	29	1ae949b6-6424-4a96-9c9f-4d959d87a0c5	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-02-08 12:35:00+00	2025-02-22 07:36:00+00	\N	AUTOMATICO	\N	\N	2025-04-08 07:36:00+00	2026-01-24 13:17:09.571+00	2026-01-24 13:17:09.571+00	t	\N	MC	30	\N	\N
33c0a1ec-d31c-439e-8d97-5dc7bf148792	2025	30	7e7de950-28ea-49ac-af70-269988863345	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-02-13 17:05:00+00	2025-05-07 04:20:00+00	\N	AUTOMATICO	\N	\N	2025-06-21 04:20:00+00	2026-01-24 13:17:09.586+00	2026-01-24 13:17:09.586+00	t	\N	MC	60	\N	\N
1cb34559-4516-4bfb-b972-2cd1f6ca049a	2025	31	d73fdcef-e978-44ca-a105-6066e9d96445	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-02-12 16:34:00+00	2025-03-20 19:07:00+00	\N	AUTOMATICO	\N	\N	2025-05-04 19:07:00+00	2026-01-24 13:17:09.605+00	2026-01-24 13:17:09.605+00	t	\N	MC	30	\N	\N
7ff02790-fbc0-4496-8a76-86db0a9b0e87	2025	50	80ff2772-dff0-42e3-b4af-371c1f446a5f	4f54264c-4a35-48b2-adf7-15a31cd493f0	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-03-24 00:00:00+00	2025-04-23 00:00:00+00	\N	AUTOMATICO	\N	\N	2025-06-07 00:00:00+00	2026-01-24 13:17:09.621+00	2026-01-24 13:17:09.621+00	t	\N	MC	40	\N	\N
f96d36f0-d576-4f94-ab71-2203df60279c	2025	53	498c3f95-ae8b-4fb2-842e-32f77a63cd5b	4f54264c-4a35-48b2-adf7-15a31cd493f0	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-03-28 00:00:00+00	2025-05-05 00:00:00+00	\N	AUTOMATICO	\N	\N	2025-06-19 00:00:00+00	2026-01-24 13:17:09.635+00	2026-01-24 13:17:09.635+00	t	\N	MC	40	\N	\N
56a28366-0adb-4932-b62d-c6d18f510c42	2025	43	d5faf031-5e43-4cc4-85ba-a0fb88a8dafb	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-03-11 17:05:00+00	2025-03-28 11:35:00+00	\N	AUTOMATICO	\N	\N	2025-05-12 11:35:00+00	2026-01-24 13:17:09.65+00	2026-01-24 13:17:09.65+00	t	\N	MC	30	\N	\N
7bc2920f-a8f2-4905-ae4a-132d688c7e03	2025	35	a8956f2f-f8e4-4387-8fa3-48ea20c38489	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-02-25 00:00:00+00	2025-03-30 00:00:00+00	\N	AUTOMATICO	\N	\N	2025-05-14 00:00:00+00	2026-01-24 13:17:09.67+00	2026-01-24 13:17:09.67+00	t	\N	MC	60	\N	\N
0a5310e4-2f6e-4cf4-8b5b-176d32f805b4	2025	20	c8f549d2-ef48-4931-82db-5f6650dd4dfb	4f54264c-4a35-48b2-adf7-15a31cd493f0	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-02-04 16:05:00+00	2025-03-11 04:30:00+00	\N	AUTOMATICO	\N	\N	2025-04-25 04:30:00+00	2026-01-24 13:17:09.686+00	2026-01-24 13:17:09.686+00	t	\N	MC	40	\N	\N
45593af6-fcbb-4405-bcd1-8c4d8765b178	2025	12	af79bace-7650-4a0c-bc89-093d01dae7c5	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-01-09 23:07:00+00	2025-02-16 22:33:00+00	\N	AUTOMATICO	\N	\N	2025-04-02 22:33:00+00	2026-01-24 13:17:09.702+00	2026-01-24 13:17:09.702+00	t	\N	MC	45	\N	\N
f023f042-bbdc-4a60-872e-d1e21e084ac8	2025	10	f4f48e38-8826-4db0-a659-951dee4e373f	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-01-13 19:00:00+00	2025-02-24 09:48:00+00	\N	AUTOMATICO	\N	\N	2025-04-10 09:48:00+00	2026-01-24 13:17:09.716+00	2026-01-24 13:17:09.716+00	t	\N	MC	60	\N	\N
feb59314-0df2-45e8-84bc-78052046a370	2025	6	c8f549d2-ef48-4931-82db-5f6650dd4dfb	4f54264c-4a35-48b2-adf7-15a31cd493f0	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-01-09 19:25:00+00	2025-02-02 21:30:00+00	\N	AUTOMATICO	\N	\N	2025-03-19 21:30:00+00	2026-01-24 13:17:09.729+00	2026-01-24 13:17:09.729+00	t	\N	MC	40	\N	\N
5eb8661e-51ce-49d7-97c5-d19f92544740	2025	5	80a91104-b031-4e3c-8308-fbdff126f6dc	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-01-07 21:42:00+00	2025-01-28 06:45:00+00	\N	AUTOMATICO	\N	\N	2025-03-14 06:45:00+00	2026-01-24 13:17:09.743+00	2026-01-24 13:17:09.743+00	t	\N	MC	60	\N	\N
be484c9c-09ca-462c-95bb-c25eee9501ec	2025	42	f0ceae5a-078a-4fd8-a6e7-7fb772f058c2	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-03-11 16:15:00+00	2025-03-28 17:49:00+00	\N	AUTOMATICO	\N	\N	2025-05-12 17:49:00+00	2026-01-24 13:17:09.758+00	2026-01-24 13:17:09.758+00	t	\N	MC	30	\N	\N
1231ddcf-bf24-4cd4-a0d1-1de4e73a7f47	2025	36	af79bace-7650-4a0c-bc89-093d01dae7c5	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-02-21 18:09:00+00	2025-04-02 08:19:00+00	\N	AUTOMATICO	\N	\N	2025-05-17 08:19:00+00	2026-01-24 13:17:09.775+00	2026-01-24 13:17:09.775+00	t	\N	MC	45	\N	\N
cf18e5e1-80fd-433a-ad01-8d7d34068033	2025	61	0b03eed0-e253-4914-8683-24e4f03a00f7	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-04-17 17:00:00+00	2025-05-27 15:20:00+00	\N	AUTOMATICO	\N	\N	2025-07-11 15:20:00+00	2026-01-24 13:17:09.788+00	2026-01-24 13:17:09.788+00	t	\N	MC	40	\N	\N
563747df-f9ee-4682-882d-9217931e353a	2025	52	a8956f2f-f8e4-4387-8fa3-48ea20c38489	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-04-01 00:00:00+00	2025-04-27 00:00:00+00	\N	AUTOMATICO	\N	\N	2025-06-11 00:00:00+00	2026-01-24 13:17:09.804+00	2026-01-24 13:17:09.804+00	t	\N	MC	60	\N	\N
037f33b0-bb12-4a3c-9db5-3a077fc13c25	2025	26	9501be2a-5bc6-4062-ad1e-2aebfa92af0c	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-02-04 12:54:00+00	2025-03-10 13:19:00+00	\N	AUTOMATICO	\N	\N	2025-04-24 13:19:00+00	2026-01-24 13:17:09.819+00	2026-01-24 13:17:09.819+00	t	\N	MC	60	\N	\N
0fbad4f9-17e7-41f9-806b-33aa89cdf920	2025	58	606a0825-f4e0-4d10-a6d0-add35c837a28	4f54264c-4a35-48b2-adf7-15a31cd493f0	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-04-23 00:00:00+00	2025-05-14 00:00:00+00	\N	AUTOMATICO	\N	\N	2025-06-28 00:00:00+00	2026-01-24 13:17:09.834+00	2026-01-24 13:17:09.834+00	t	\N	MC	40	\N	\N
77d9037c-5697-43d2-a9b6-63b7573ab634	2025	55	7b0a7e6a-a71b-43b0-b9e2-cca0b5518ab0	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-04-18 00:00:00+00	2025-05-19 00:00:00+00	\N	AUTOMATICO	\N	\N	2025-07-03 00:00:00+00	2026-01-24 13:17:09.847+00	2026-01-24 13:17:09.847+00	t	\N	MC	60	\N	\N
e3564104-bbf6-4fb4-ac96-528b2739f411	2025	72	a8956f2f-f8e4-4387-8fa3-48ea20c38489	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-04-29 17:20:00+00	2025-06-02 19:10:00+00	\N	AUTOMATICO	\N	\N	2025-07-17 19:10:00+00	2026-01-24 13:17:09.861+00	2026-01-24 13:17:09.861+00	t	\N	MC	60	\N	\N
4c5fd41e-35d5-4a16-a34b-870dac9f95c7	2025	74	fadfa149-546e-4dd2-b3b8-caea5b867715	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-04-29 21:15:00+00	2025-05-15 14:45:00+00	\N	AUTOMATICO	\N	\N	2025-06-29 14:45:00+00	2026-01-24 13:17:09.874+00	2026-01-24 13:17:09.874+00	t	\N	MC	60	\N	\N
7ed632a1-b04e-409a-83b6-4cff98b3900a	2025	67	63f6107b-beea-4b36-9774-25cf88d83e48	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-04-30 15:15:00+00	2025-06-16 18:05:00+00	\N	AUTOMATICO	\N	\N	2025-07-31 18:05:00+00	2026-01-24 13:17:09.889+00	2026-01-24 13:17:09.889+00	t	\N	MC	60	\N	\N
7e38f2f8-5683-4aa6-a80f-d0f1c2e552b9	2025	71	d1f683c2-69b1-4ab5-86e2-51f1a456b827	4f54264c-4a35-48b2-adf7-15a31cd493f0	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-04-30 18:47:00+00	2025-06-05 07:50:00+00	\N	AUTOMATICO	\N	\N	2025-07-20 07:50:00+00	2026-01-24 13:17:09.904+00	2026-01-24 13:17:09.904+00	t	\N	MC	40	\N	\N
84cd59ab-19c3-4e16-a79c-369a15f3ad98	2025	77	80a91104-b031-4e3c-8308-fbdff126f6dc	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-05-04 00:20:00+00	2025-06-03 17:48:00+00	\N	AUTOMATICO	\N	\N	2025-07-18 17:48:00+00	2026-01-24 13:17:09.92+00	2026-01-24 13:17:09.92+00	t	\N	MC	60	\N	\N
a084b657-a47b-44e1-a45d-78a6953aa01a	2025	78	c730a093-6360-4bd5-9c8a-125cc8fad7d7	4f54264c-4a35-48b2-adf7-15a31cd493f0	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-05-07 13:55:00+00	2025-06-09 16:02:00+00	\N	AUTOMATICO	\N	\N	2025-07-24 16:02:00+00	2026-01-24 13:17:09.936+00	2026-01-24 13:17:09.936+00	t	\N	MC	40	\N	\N
60eaa75e-46b6-49eb-90c4-0bfe6d389eaa	2025	79	498c3f95-ae8b-4fb2-842e-32f77a63cd5b	4f54264c-4a35-48b2-adf7-15a31cd493f0	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-05-07 14:55:00+00	2025-06-10 11:07:00+00	\N	AUTOMATICO	\N	\N	2025-07-25 11:07:00+00	2026-01-24 13:17:09.948+00	2026-01-24 13:17:09.948+00	t	\N	MC	40	\N	\N
3f2d62fb-cd2e-44b4-9392-45694d508758	2025	75	7e7de950-28ea-49ac-af70-269988863345	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-05-08 16:25:00+00	2025-06-17 04:30:00+00	\N	AUTOMATICO	\N	\N	2025-08-01 04:30:00+00	2026-01-24 13:17:09.96+00	2026-01-24 13:17:09.96+00	t	\N	MC	60	\N	\N
b3cdec65-4d6d-43ee-95be-a219779a543a	2025	70	05bcda73-0d39-41dd-b4e9-c8865cad2a69	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-05-02 15:10:00+00	2025-05-21 09:23:00+00	\N	AUTOMATICO	\N	\N	2025-07-05 09:23:00+00	2026-01-24 13:17:09.975+00	2026-01-24 13:17:09.975+00	t	\N	MC	30	\N	\N
2f3b3c22-997e-4bc2-85e3-b7a56c7629ac	2025	45	261693e5-a863-48cb-bbae-8d605add7b3f	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-03-11 20:36:00+00	2025-03-27 21:00:00+00	\N	AUTOMATICO	\N	\N	2025-05-11 21:00:00+00	2026-01-24 13:17:09.994+00	2026-01-24 13:17:09.994+00	t	\N	MC	30	\N	\N
c5343015-af9a-4374-b661-fb4dc7367146	2025	23	f8654d33-21f3-41fe-88ab-adfda41d4871	4f54264c-4a35-48b2-adf7-15a31cd493f0	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-01-29 05:23:00+00	2025-04-06 17:20:00+00	\N	AUTOMATICO	\N	\N	2025-05-21 17:20:00+00	2026-01-24 13:17:10.016+00	2026-01-24 13:17:10.016+00	t	\N	MC	40	\N	\N
04e248a5-5ce7-450a-9c3c-565a39f9155a	2025	81	cff19edb-4d41-4a8a-92ed-2a57683ba0fe	1eeb0dff-da3b-4dfa-8fe2-e415f817921d	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-05-15 10:47:00+00	2025-05-27 12:47:00+00	\N	AUTOMATICO	\N	\N	2025-07-11 12:47:00+00	2026-01-24 13:17:10.034+00	2026-01-24 13:17:10.034+00	t	\N	MC	30	\N	\N
6c961bba-3ba0-4eed-b5c9-8f1666f370a8	2025	80	84fa549b-42f6-46de-9d8e-458b2c4f652b	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-05-11 07:00:00+00	2025-05-18 10:25:00+00	\N	AUTOMATICO	\N	\N	2025-07-02 10:25:00+00	2026-01-24 13:17:10.049+00	2026-01-24 13:17:10.049+00	t	\N	MC	30	\N	\N
64d3eceb-4ce4-4ba9-b7d6-ac95de18c94e	2025	59	f4f48e38-8826-4db0-a659-951dee4e373f	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-04-22 17:42:00+00	2025-06-06 07:51:00+00	\N	AUTOMATICO	\N	\N	2025-07-21 07:51:00+00	2026-01-24 13:17:10.062+00	2026-01-24 13:17:10.062+00	t	\N	MC	60	\N	\N
067536b6-2790-4ce3-a499-575189c9632d	2025	68	4fb8e545-033a-4813-88be-9e7994602845	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-04-26 11:30:00+00	2025-05-27 12:46:00+00	\N	AUTOMATICO	\N	\N	2025-07-11 12:46:00+00	2026-01-24 13:17:10.076+00	2026-01-24 13:17:10.076+00	t	\N	MC	30	\N	\N
e73ffb8a-e102-4029-8169-1e597e5215dc	2025	83	7a0ed70d-e0c9-40ed-8167-389c0fe10e52	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-05-17 15:42:00+00	2025-07-13 10:03:00+00	\N	AUTOMATICO	\N	\N	2025-08-27 10:03:00+00	2026-01-24 13:17:10.097+00	2026-01-24 13:17:10.097+00	t	\N	MC	60	\N	\N
9b039da1-0d80-4df9-916c-e45c57fecf8e	2025	2	a8956f2f-f8e4-4387-8fa3-48ea20c38489	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-01-04 21:00:00+00	2025-01-28 15:40:00+00	\N	AUTOMATICO	\N	\N	2025-03-14 15:40:00+00	2026-01-24 13:17:10.109+00	2026-01-24 13:17:10.109+00	t	\N	MC	60	\N	\N
31a9c494-ebb7-4c70-8839-1da7503c9cff	2025	44	42c2376e-1bf8-4960-82df-e66e8649671c	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-03-12 11:32:00+00	2025-03-29 11:00:00+00	\N	AUTOMATICO	\N	\N	2025-05-13 11:00:00+00	2026-01-24 13:17:10.126+00	2026-01-24 13:17:10.126+00	t	\N	MC	30	\N	\N
a9dae374-df94-4aa5-a623-9d8144978ccc	2025	49	4c9ebdc1-a5b7-44c1-bc1d-afb5439051c4	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-03-19 17:40:00+00	2025-04-23 19:50:00+00	\N	AUTOMATICO	\N	\N	2025-06-07 19:50:00+00	2026-01-24 13:17:10.147+00	2026-01-24 13:17:10.147+00	t	\N	MC	60	\N	\N
7921bdce-9e65-4d72-9a1d-f8af57783669	2025	46	9f856e4d-b432-438b-a642-57c8fdc43e38	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-03-07 16:05:00+00	2025-03-18 17:35:00+00	\N	AUTOMATICO	\N	\N	2025-05-02 17:35:00+00	2026-01-24 13:17:10.16+00	2026-01-24 13:17:10.16+00	t	\N	MC	30	\N	\N
426df63e-b2cc-4eaa-b88b-efe2f9491256	2025	87	7b0a7e6a-a71b-43b0-b9e2-cca0b5518ab0	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-05-22 05:10:00+00	2025-06-21 07:50:00+00	\N	AUTOMATICO	\N	\N	2025-08-05 07:50:00+00	2026-01-24 13:17:10.177+00	2026-01-24 13:17:10.177+00	t	\N	MC	60	\N	\N
872b6b79-3026-4b2b-9d0a-f94a1a356ae4	2025	86	b96eb56c-f54e-4a39-ad03-f7d68245044e	4f54264c-4a35-48b2-adf7-15a31cd493f0	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-05-22 11:32:00+00	2025-06-05 08:10:00+00	\N	AUTOMATICO	\N	\N	2025-07-20 08:10:00+00	2026-01-24 13:17:10.194+00	2026-01-24 13:17:10.194+00	t	\N	MC	40	\N	\N
4e63e615-31bd-4749-8f26-e2ac10079b78	2025	76	d73fdcef-e978-44ca-a105-6066e9d96445	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-05-07 17:05:00+00	2025-06-10 17:15:00+00	\N	AUTOMATICO	\N	\N	2025-07-25 17:15:00+00	2026-01-24 13:17:10.207+00	2026-01-24 13:17:10.207+00	t	\N	MC	30	\N	\N
57aeda51-1344-4b3d-8aa5-7974aadce5d7	2025	64	9501be2a-5bc6-4062-ad1e-2aebfa92af0c	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-04-27 07:55:00+00	2025-05-31 08:19:00+00	\N	AUTOMATICO	\N	\N	2025-07-15 08:19:00+00	2026-01-24 13:17:10.222+00	2026-01-24 13:17:10.222+00	t	\N	MC	60	\N	\N
65be28e1-bb22-4743-a89d-69a3d7f245f7	2025	60	cff19edb-4d41-4a8a-92ed-2a57683ba0fe	1eeb0dff-da3b-4dfa-8fe2-e415f817921d	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-04-12 11:10:00+00	2025-05-12 21:00:00+00	\N	AUTOMATICO	\N	\N	2025-06-26 21:00:00+00	2026-01-24 13:17:10.237+00	2026-01-24 13:17:10.237+00	t	\N	MC	30	\N	\N
1e353aec-59d4-4bd1-87ee-29f37202c7a4	2025	51	d73fdcef-e978-44ca-a105-6066e9d96445	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-03-28 00:00:00+00	2025-04-30 00:00:00+00	\N	AUTOMATICO	\N	\N	2025-06-14 00:00:00+00	2026-01-24 13:17:10.254+00	2026-01-24 13:17:10.254+00	t	\N	MC	30	\N	\N
bb7f40fc-b77a-42a2-91d7-f5ec0de39a95	2025	84	e78dcbb5-36d9-4aca-a151-e9c42a70cc09	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-05-22 15:40:00+00	2025-06-17 07:33:00+00	\N	AUTOMATICO	\N	\N	2025-08-01 07:33:00+00	2026-01-24 13:17:10.269+00	2026-01-24 13:17:10.269+00	t	\N	MC	30	\N	\N
658c41aa-3738-44e7-b495-67c2b5868b99	2025	82	5b11295e-6b0b-4983-ade2-4c94e98cc8d0	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-05-22 19:05:00+00	2025-07-10 14:40:00+00	\N	AUTOMATICO	\N	\N	2025-08-24 14:40:00+00	2026-01-24 13:17:10.283+00	2026-01-24 13:17:10.283+00	t	\N	MC	60	\N	\N
c06ba6a8-5afe-48d9-8cc2-614b42898727	2025	62	ddc66628-733e-4983-889a-c00b2d4cc9a2	4f54264c-4a35-48b2-adf7-15a31cd493f0	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-04-16 00:30:00+00	2025-05-27 08:09:00+00	\N	AUTOMATICO	\N	\N	2025-07-11 08:09:00+00	2026-01-24 13:17:10.297+00	2026-01-24 13:17:10.297+00	t	\N	MC	40	\N	\N
69c812ec-5da2-4460-a15b-b6dee85db80c	2025	69	80ff2772-dff0-42e3-b4af-371c1f446a5f	4f54264c-4a35-48b2-adf7-15a31cd493f0	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-04-26 13:42:00+00	2025-05-28 14:11:00+00	\N	AUTOMATICO	\N	\N	2025-07-12 14:11:00+00	2026-01-24 13:17:10.31+00	2026-01-24 13:17:10.31+00	t	\N	MC	40	\N	\N
cc7753b3-fffa-4aaf-9e5d-f53b975b95f6	2025	88	af79bace-7650-4a0c-bc89-093d01dae7c5	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-05-28 11:51:00+00	2025-07-12 12:17:00+00	\N	AUTOMATICO	\N	\N	2025-08-26 12:17:00+00	2026-01-24 13:17:10.326+00	2026-01-24 13:17:10.326+00	t	\N	MC	45	\N	\N
4c798852-af1a-4d49-b2bc-90164c8381ec	2025	91	80ff2772-dff0-42e3-b4af-371c1f446a5f	4f54264c-4a35-48b2-adf7-15a31cd493f0	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-05-31 12:41:00+00	2025-06-07 00:00:00+00	\N	AUTOMATICO	\N	\N	2025-07-22 00:00:00+00	2026-01-24 13:17:10.34+00	2026-01-24 13:17:10.34+00	t	\N	MC	40	\N	\N
a120ecf7-5311-4528-b8d3-f4318b3246b3	2025	48	945b3158-6a8c-4360-97ad-0f50574e46a9	1eeb0dff-da3b-4dfa-8fe2-e415f817921d	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-03-13 14:45:00+00	2025-04-28 16:05:00+00	\N	AUTOMATICO	\N	\N	2025-06-12 16:05:00+00	2026-01-24 13:17:10.357+00	2026-01-24 13:17:10.357+00	t	\N	MC	30	\N	\N
4f7c6bd0-e3bb-4ddf-ae94-8b3eaede0b10	2025	99	9da1c921-7ee5-4d2e-aea5-856859297876	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-06-10 18:15:00+00	2025-07-16 11:05:00+00	\N	AUTOMATICO	\N	\N	2025-08-30 11:05:00+00	2026-01-24 13:17:10.381+00	2026-01-24 13:17:10.381+00	t	\N	MC	30	\N	\N
9250e417-2c74-41f7-ab92-83462b20a339	2025	63	84fa549b-42f6-46de-9d8e-458b2c4f652b	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-04-12 17:09:00+00	2025-05-10 00:00:00+00	\N	AUTOMATICO	\N	\N	2025-06-24 00:00:00+00	2026-01-24 13:17:10.408+00	2026-01-24 13:17:10.408+00	t	\N	MC	30	\N	\N
d78a9d78-2e2a-4ae8-8852-7006e0d841ee	2024	174	945b3158-6a8c-4360-97ad-0f50574e46a9	1eeb0dff-da3b-4dfa-8fe2-e415f817921d	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-12-29 06:27:00+00	2025-03-11 12:42:00+00	\N	AUTOMATICO	\N	\N	2025-04-25 12:42:00+00	2026-01-24 13:17:10.43+00	2026-01-24 13:17:10.43+00	t	\N	MC	30	\N	\N
ff3da8d4-a29b-42e5-aeca-4e7a68069654	2025	103	eb1c36cf-265e-49d0-be00-373d54d77413	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-06-18 22:31:00+00	2025-06-25 15:24:00+00	\N	AUTOMATICO	\N	\N	2025-08-09 15:24:00+00	2026-01-24 13:17:10.446+00	2026-01-24 13:17:10.446+00	t	\N	MC	30	\N	\N
53aeca7b-eb90-41ae-a826-fac9bcabafae	2025	98	7e7de950-28ea-49ac-af70-269988863345	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-06-19 10:10:00+00	2025-07-02 09:55:00+00	\N	AUTOMATICO	\N	\N	2025-08-16 09:55:00+00	2026-01-24 13:17:10.459+00	2026-01-24 13:17:10.459+00	t	\N	MC	60	\N	\N
db77c250-a362-4b16-9e34-a2c474d343cc	2025	104	6a6a1777-bd99-4215-8322-e830aa58e9fc	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-06-18 19:04:00+00	2025-06-25 15:02:00+00	\N	AUTOMATICO	\N	\N	2025-08-09 15:02:00+00	2026-01-24 13:17:10.474+00	2026-01-24 13:17:10.474+00	t	\N	MC	30	\N	\N
0a8c36ba-ecfc-4fc5-932e-a71d7cdf5f4a	2025	105	a804a734-5f37-4dfd-9036-49e47902739d	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-06-18 21:10:00+00	2025-06-25 16:30:00+00	\N	AUTOMATICO	\N	\N	2025-08-09 16:30:00+00	2026-01-24 13:17:10.489+00	2026-01-24 13:17:10.489+00	t	\N	MC	30	\N	\N
9df62148-2ade-43dc-9013-2760050f7658	2024	106	49b605b3-5ac0-40ee-8c58-cca6fe0cbb30	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-07-04 11:58:00+00	2024-07-09 07:50:00+00	\N	AUTOMATICO	\N	\N	2024-08-23 07:50:00+00	2026-01-24 13:17:10.503+00	2026-01-24 13:17:10.503+00	t	\N	MC	\N	\N	\N
c6ca57c5-9568-478e-9814-d92624a8081b	2025	111	a804a734-5f37-4dfd-9036-49e47902739d	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-06-27 20:45:00+00	2025-07-09 23:58:00+00	\N	AUTOMATICO	\N	\N	2025-08-23 23:58:00+00	2026-01-24 13:17:10.516+00	2026-01-24 13:17:10.516+00	t	\N	MC	30	\N	\N
11c8ead9-63e2-4aff-ba19-009c46f5c288	2025	24	a8956f2f-f8e4-4387-8fa3-48ea20c38489	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-02-01 01:00:00+00	2025-02-22 21:00:00+00	\N	AUTOMATICO	\N	\N	2025-04-08 21:00:00+00	2026-01-24 13:17:10.534+00	2026-01-24 13:17:10.534+00	t	\N	MC	60	\N	\N
07dd69ed-a7c6-437e-9324-e9dde8b2a739	2025	54	af79bace-7650-4a0c-bc89-093d01dae7c5	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-04-08 00:00:00+00	2025-05-17 00:00:00+00	\N	AUTOMATICO	\N	\N	2025-07-01 00:00:00+00	2026-01-24 13:17:10.549+00	2026-01-24 13:17:10.549+00	t	\N	MC	45	\N	\N
d52d6553-242c-45ad-b151-ee30331c31f0	2025	56	5b11295e-6b0b-4983-ade2-4c94e98cc8d0	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-04-09 00:00:00+00	2025-05-20 00:00:00+00	\N	AUTOMATICO	\N	\N	2025-07-04 00:00:00+00	2026-01-24 13:17:10.56+00	2026-01-24 13:17:10.56+00	t	\N	MC	60	\N	\N
55fd91f2-630e-4c3a-88cd-ffdd92a812f6	2025	57	377b5ead-3c81-4651-ba39-035d8aa8057d	1eeb0dff-da3b-4dfa-8fe2-e415f817921d	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-04-09 22:00:00+00	2025-04-30 21:00:00+00	\N	AUTOMATICO	\N	\N	2025-06-14 21:00:00+00	2026-01-24 13:17:10.576+00	2026-01-24 13:17:10.576+00	t	\N	MC	30	\N	\N
8cc4851e-d918-461c-b788-7dc2961374fb	2025	73	9da1c921-7ee5-4d2e-aea5-856859297876	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-04-30 11:25:00+00	2025-05-29 01:42:00+00	\N	AUTOMATICO	\N	\N	2025-07-13 01:42:00+00	2026-01-24 13:17:10.595+00	2026-01-24 13:17:10.595+00	t	\N	MC	30	\N	\N
8de387fe-6e7b-477b-b812-01de6454c5be	2025	101	de912164-b6dd-4126-a5aa-4ec563018825	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-06-18 18:35:00+00	2025-07-09 18:00:00+00	\N	AUTOMATICO	\N	\N	2025-08-23 18:00:00+00	2026-01-24 13:17:10.63+00	2026-01-24 13:17:10.63+00	t	\N	MC	30	\N	\N
890b8f6f-f171-4a76-9c01-f3fbbc074658	2025	106	fd6812be-a614-4ab3-83f5-6c888962c269	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-06-19 00:04:00+00	2025-06-25 15:03:00+00	\N	AUTOMATICO	\N	\N	2025-08-09 15:03:00+00	2026-01-24 13:17:10.647+00	2026-01-24 13:17:10.647+00	t	\N	MC	30	\N	\N
3a6a70ed-3411-4c55-b373-a58a59ad69b1	2025	112	e89109bc-b664-4783-84e0-bb029ed1c21e	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-06-27 23:17:00+00	2025-07-16 04:10:00+00	\N	AUTOMATICO	\N	\N	2025-08-30 04:10:00+00	2026-01-24 13:17:10.667+00	2026-01-24 13:17:10.667+00	t	\N	MC	10	\N	\N
cf876105-045b-4006-bab6-e7e6046ba59a	2025	114	f4f48e38-8826-4db0-a659-951dee4e373f	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-07-10 15:05:00+00	2025-08-29 07:09:00+00	\N	AUTOMATICO	\N	\N	2025-10-13 07:09:00+00	2026-01-24 13:17:10.69+00	2026-01-24 13:17:10.69+00	t	\N	MC	60	\N	\N
202291e5-c8e3-42ea-8414-1bc7327bb1fa	2025	119	b5f9e522-e915-4778-abfc-e0b5bb4ff42e	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-07-14 09:50:00+00	2025-08-23 10:14:00+00	\N	AUTOMATICO	\N	\N	2025-10-07 10:14:00+00	2026-01-24 13:17:10.706+00	2026-01-24 13:17:10.706+00	t	\N	MC	60	\N	\N
96decf3b-5fff-4464-9da7-fdb0f4c15634	2025	116	0b03eed0-e253-4914-8683-24e4f03a00f7	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-07-15 22:10:00+00	2025-08-28 14:13:00+00	\N	AUTOMATICO	\N	\N	2025-10-12 14:13:00+00	2026-01-24 13:17:10.721+00	2026-01-24 13:17:10.721+00	t	\N	MC	40	\N	\N
2b2a87c7-0939-41d3-9aa7-d066916160db	2025	122	af79bace-7650-4a0c-bc89-093d01dae7c5	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-07-17 16:00:00+00	2025-09-04 08:40:00+00	\N	AUTOMATICO	\N	\N	2025-10-19 08:40:00+00	2026-01-24 13:17:10.736+00	2026-01-24 13:17:10.736+00	t	\N	MC	45	\N	\N
9cb89474-d62d-414e-a1da-ef5e9714ab2f	2025	121	18b98431-a4a2-463b-ae58-c784bcf1ae44	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-07-18 17:28:00+00	2025-08-17 08:08:00+00	\N	AUTOMATICO	\N	\N	2025-10-01 08:08:00+00	2026-01-24 13:17:10.751+00	2026-01-24 13:17:10.751+00	t	\N	MC	30	\N	\N
4b9cff2d-d996-4916-b84a-e368b6e6eee4	2025	128	79841e78-cd00-4ede-ae56-ee11250a4ac0	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-07-19 10:10:00+00	2025-08-23 08:15:00+00	\N	AUTOMATICO	\N	\N	2025-10-07 08:15:00+00	2026-01-24 13:17:10.771+00	2026-01-24 13:17:10.771+00	t	\N	MC	60	\N	\N
ad5c2f47-6377-46d2-876b-185ea093ca7c	2025	96	9501be2a-5bc6-4062-ad1e-2aebfa92af0c	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-06-05 18:42:00+00	2025-07-06 09:14:00+00	\N	AUTOMATICO	\N	\N	2025-08-20 09:14:00+00	2026-01-24 13:17:10.786+00	2026-01-24 13:17:10.786+00	t	\N	MC	60	\N	\N
2ee02778-51f0-46d2-951d-0c3dfef5ad38	2025	94	4ce964a6-9e77-43e3-9dff-6609a4675e41	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-06-13 17:00:00+00	2025-07-25 15:09:00+00	\N	AUTOMATICO	\N	\N	2025-09-08 15:09:00+00	2026-01-24 13:17:10.801+00	2026-01-24 13:17:10.801+00	t	\N	MC	30	\N	\N
23638708-b51b-494c-b782-13e83e2c6dd7	2025	89	0b03eed0-e253-4914-8683-24e4f03a00f7	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-05-31 20:30:00+00	2025-07-11 07:00:00+00	\N	AUTOMATICO	\N	\N	2025-08-25 07:00:00+00	2026-01-24 13:17:10.824+00	2026-01-24 13:17:10.824+00	t	\N	MC	40	\N	\N
421cb77c-8989-4d2c-87d8-2db539173f65	2025	97	261693e5-a863-48cb-bbae-8d605add7b3f	9e25d139-f360-4a6d-aece-eaddec5adb62	c56c252a-8a98-4dd6-9c2d-de6135686d71	2025-06-17 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-24 13:17:10.839+00	2026-01-24 13:17:10.839+00	t	\N	MC	30	\N	\N
256ea07a-1bfa-476e-95b6-3f74cfd49224	2025	130	ebdb90ca-16a1-4523-ab69-aacd1cfdae6b	9e25d139-f360-4a6d-aece-eaddec5adb62	c56c252a-8a98-4dd6-9c2d-de6135686d71	2025-07-22 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-24 13:17:10.856+00	2026-01-24 13:17:10.856+00	t	\N	MC	60	\N	\N
fee69d57-0fcd-4e86-bb58-f29680b2aa65	2025	19	377b5ead-3c81-4651-ba39-035d8aa8057d	1eeb0dff-da3b-4dfa-8fe2-e415f817921d	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-01-31 17:45:00+00	2025-03-14 21:00:00+00	\N	AUTOMATICO	\N	\N	2025-04-28 21:00:00+00	2026-01-24 13:17:10.872+00	2026-01-24 13:17:10.872+00	t	No completó la marea por sentirse mal a bordo	MC	30	\N	\N
bdbe259e-6f9f-44b1-8015-cebefd9f61c2	2025	28	5b11295e-6b0b-4983-ade2-4c94e98cc8d0	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-02-05 00:00:00+00	2025-04-07 00:00:00+00	\N	AUTOMATICO	\N	\N	2025-05-22 00:00:00+00	2026-01-24 13:17:10.887+00	2026-01-24 13:17:10.887+00	t	\N	MC	60	\N	\N
80581ca9-1851-45dc-b490-7d303a888518	2025	118	ce913a90-01c5-45ec-be08-2d1dfb5d47b8	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-07-13 19:50:00+00	2025-08-03 08:40:00+00	\N	AUTOMATICO	\N	\N	2025-09-17 08:40:00+00	2026-01-24 13:17:10.904+00	2026-01-24 13:17:10.904+00	t	\N	MC	10	\N	\N
0bd77f71-ee98-4a77-bee1-1abfbac1eb43	2025	178	945b3158-6a8c-4360-97ad-0f50574e46a9	1eeb0dff-da3b-4dfa-8fe2-e415f817921d	9958d706-2c00-447c-b303-b8a2fa2ce060	2025-11-06 03:00:00+00	2025-11-07 00:00:00+00	2025-12-21 23:30:00+00	\N	AUTOMATICO	\N	\N	2026-02-04 23:30:00+00	2026-01-24 13:17:10.932+00	2026-01-24 13:17:10.932+00	t	\N	MC	30	\N	\N
948c2dcb-95f6-4baa-bd94-2c72d4b6f8b6	2026	12	f749d131-dad5-4391-9239-d3eff37d4e93	1eeb0dff-da3b-4dfa-8fe2-e415f817921d	0e446e48-221f-4190-9d34-17af75f9a406	2026-01-25 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-24 13:17:10.947+00	2026-01-24 13:17:10.947+00	t	\N	MC	30	\N	\N
8a6e79e2-7d61-462f-9441-15eb9db3813c	2026	11	d73fdcef-e978-44ca-a105-6066e9d96445	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	9acdf957-9a1a-4786-8463-f69262b0d65d	2025-01-14 03:00:00+00	2026-01-16 03:00:00+00	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-24 13:17:10.961+00	2026-01-24 13:17:10.961+00	t	\N	MC	30	\N	\N
fd80d971-0822-45a4-99e9-1c87ab8aa701	2026	2	673c0f77-1eb5-417b-a222-7791be50ce45	9e25d139-f360-4a6d-aece-eaddec5adb62	9acdf957-9a1a-4786-8463-f69262b0d65d	\N	2026-01-05 00:00:00+00	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-24 13:17:10.985+00	2026-01-24 13:17:10.985+00	t	\N	MC	60	\N	\N
8cf51ad1-3e30-4eb1-aa50-057f236054b0	2026	3	9501be2a-5bc6-4062-ad1e-2aebfa92af0c	9e25d139-f360-4a6d-aece-eaddec5adb62	9acdf957-9a1a-4786-8463-f69262b0d65d	2026-01-05 03:00:00+00	2026-01-06 03:00:00+00	2026-01-14 16:15:00+00	\N	AUTOMATICO	\N	\N	2026-02-28 16:15:00+00	2026-01-24 13:17:11+00	2026-01-24 13:17:11+00	t	\N	MC	60	\N	\N
8e08a989-1f06-4d01-bdc8-620650f4c872	2026	9	7b0a7e6a-a71b-43b0-b9e2-cca0b5518ab0	9e25d139-f360-4a6d-aece-eaddec5adb62	9acdf957-9a1a-4786-8463-f69262b0d65d	2026-01-15 03:00:00+00	2026-01-15 03:00:00+00	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-24 13:17:11.019+00	2026-01-24 13:17:11.019+00	t	\N	MC	60	\N	\N
fca98c94-3979-4e49-882c-f0cc4c0dbe97	2025	187	af79bace-7650-4a0c-bc89-093d01dae7c5	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	94c1d788-a09b-4d7d-a45a-fab7eeeab437	2025-12-15 03:00:00+00	2025-12-15 14:50:00+00	2026-01-20 03:00:00+00	\N	AUTOMATICO	\N	\N	\N	2026-01-24 13:17:11.038+00	2026-01-24 13:17:11.038+00	t	\N	MC	45	\N	\N
68e36007-c8a0-4df3-865f-998dc50adbbf	2026	4	ae3d4e22-1208-4514-9403-30fd4a94f051	9e25d139-f360-4a6d-aece-eaddec5adb62	9acdf957-9a1a-4786-8463-f69262b0d65d	\N	2026-01-06 15:00:00+00	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-24 13:17:11.057+00	2026-01-24 13:17:11.057+00	t	\N	MC	30	\N	\N
dd8ac789-934e-4807-b229-809487d35b8f	2025	190	f1b37e20-ec28-442f-aecb-290a35045124	4f54264c-4a35-48b2-adf7-15a31cd493f0	9acdf957-9a1a-4786-8463-f69262b0d65d	\N	2025-12-30 09:45:00+00	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-24 13:17:11.079+00	2026-01-24 13:17:11.079+00	t	\N	MC	40	\N	\N
48efa277-e6aa-4814-b490-edf2a4a31318	2025	182	5b11295e-6b0b-4983-ade2-4c94e98cc8d0	9e25d139-f360-4a6d-aece-eaddec5adb62	57669ce7-ad00-4862-a3b7-ded380ddb616	\N	2025-11-22 00:30:00+00	2026-01-16 03:00:00+00	\N	AUTOMATICO	\N	\N	2026-02-26 20:00:00+00	2026-01-24 13:17:11.098+00	2026-01-24 13:17:11.098+00	t	\N	MC	60	\N	\N
2f26774c-4c79-4019-907e-34a81c0fb8ee	2025	184	7b0a7e6a-a71b-43b0-b9e2-cca0b5518ab0	9e25d139-f360-4a6d-aece-eaddec5adb62	94c1d788-a09b-4d7d-a45a-fab7eeeab437	2025-11-26 03:00:00+00	2025-11-27 22:30:00+00	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-24 13:17:11.126+00	2026-01-24 13:17:11.126+00	t	\N	MC	60	\N	\N
3e06427d-367c-48dd-ba35-48fcd50caff1	2025	186	0b03eed0-e253-4914-8683-24e4f03a00f7	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	9acdf957-9a1a-4786-8463-f69262b0d65d	\N	2025-12-16 07:30:00+00	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-24 13:17:11.143+00	2026-01-24 13:17:11.143+00	t	\N	MC	40	\N	\N
8f90beb5-b58a-4b49-bfdb-fcf1acbe4630	2025	192	43ecc3bd-4313-44c4-a825-1143e2674fc9	4f54264c-4a35-48b2-adf7-15a31cd493f0	9acdf957-9a1a-4786-8463-f69262b0d65d	\N	2025-12-29 00:00:00+00	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-24 13:17:11.159+00	2026-01-24 13:17:11.159+00	t	\N	MC	40	\N	\N
7a65e5f9-92de-40df-8378-0441eb753710	2025	194	945b3158-6a8c-4360-97ad-0f50574e46a9	1eeb0dff-da3b-4dfa-8fe2-e415f817921d	9acdf957-9a1a-4786-8463-f69262b0d65d	\N	2025-12-30 22:10:00+00	2026-01-15 17:03:00+00	\N	AUTOMATICO	\N	\N	2026-03-01 17:03:00+00	2026-01-24 13:17:11.175+00	2026-01-24 13:17:11.175+00	t	\N	MC	30	\N	\N
8d0f0c3c-e975-4b8b-b7c5-15fc642bd830	2025	171	0b03eed0-e253-4914-8683-24e4f03a00f7	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	94c1d788-a09b-4d7d-a45a-fab7eeeab437	\N	2025-10-29 21:10:00+00	2025-12-11 03:00:00+00	\N	AUTOMATICO	\N	\N	2026-01-25 03:00:00+00	2026-01-24 13:17:11.195+00	2026-01-24 13:17:11.195+00	t	\N	MC	40	\N	\N
2f6ab9b8-a5e8-4118-92e5-3474dfd4af50	2026	10	18b98431-a4a2-463b-ae58-c784bcf1ae44	9e25d139-f360-4a6d-aece-eaddec5adb62	9acdf957-9a1a-4786-8463-f69262b0d65d	2025-01-13 03:00:00+00	2026-01-19 03:00:00+00	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-24 13:17:11.219+00	2026-01-24 13:17:11.219+00	t	\N	MC	30	\N	\N
71432415-f2fd-4885-9b14-755e89d31d7d	2026	13	1ea649cb-98cf-4d9a-9874-a1fa4259aa57	9e25d139-f360-4a6d-aece-eaddec5adb62	0e446e48-221f-4190-9d34-17af75f9a406	2026-01-26 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-24 13:17:11.238+00	2026-01-24 13:17:11.238+00	t	20/01/2026 - Salida cancelada. La empresa bajó al observador designado	MC	30	\N	\N
c4314176-3b59-4e0a-96fe-7ce13f6e9abc	2026	14	377b5ead-3c81-4651-ba39-035d8aa8057d	1eeb0dff-da3b-4dfa-8fe2-e415f817921d	0e446e48-221f-4190-9d34-17af75f9a406	2026-01-29 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-24 13:17:11.251+00	2026-01-24 13:17:11.251+00	t	\N	MC	30	\N	\N
2aff96d3-bc36-4ead-9e21-c3abeb5d740b	2026	16	cff19edb-4d41-4a8a-92ed-2a57683ba0fe	1eeb0dff-da3b-4dfa-8fe2-e415f817921d	0e446e48-221f-4190-9d34-17af75f9a406	2026-01-26 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-24 13:17:11.263+00	2026-01-24 13:17:11.263+00	t	\N	MC	30	\N	\N
1def5441-0919-4f32-90ab-1498356eee58	2026	15	606a0825-f4e0-4d10-a6d0-add35c837a28	4f54264c-4a35-48b2-adf7-15a31cd493f0	0e446e48-221f-4190-9d34-17af75f9a406	2026-01-25 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-24 13:17:11.275+00	2026-01-24 13:17:11.275+00	t	\N	MC	30	\N	\N
843119e3-8559-4305-823f-8cdd721fe5ae	2025	3	cff19edb-4d41-4a8a-92ed-2a57683ba0fe	1eeb0dff-da3b-4dfa-8fe2-e415f817921d	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-01-04 13:43:00+00	2025-02-22 11:35:00+00	\N	AUTOMATICO	\N	\N	2025-04-08 11:35:00+00	2026-01-24 13:17:04.715+00	2026-01-24 13:17:04.715+00	t	\N	MC	30	\N	\N
9d5b7aa8-fbbc-443c-a350-9ac4f2f8181a	2026	1	a8956f2f-f8e4-4387-8fa3-48ea20c38489	9e25d139-f360-4a6d-aece-eaddec5adb62	9acdf957-9a1a-4786-8463-f69262b0d65d	\N	2026-01-03 17:30:00+00	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-24 13:17:04.782+00	2026-01-24 13:17:04.782+00	t	\N	MC	60	\N	\N
7d2df6b7-0671-4978-9d88-31684e298979	2025	154	93f4623a-17c8-4e5f-bb4f-28ad962199e5	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-09-06 08:00:00+00	2025-09-15 07:00:00+00	\N	AUTOMATICO	\N	\N	2025-10-30 07:00:00+00	2026-01-24 13:17:04.801+00	2026-01-24 13:17:04.801+00	t	\N	MC	40	\N	\N
d305ef9a-5850-450a-b870-1ce6214029f1	2025	132	e9fbeea4-0b6f-4eb5-b322-36cc38037b2f	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-07-24 13:40:00+00	2025-10-07 12:18:00+00	\N	AUTOMATICO	\N	\N	2025-11-21 12:18:00+00	2026-01-24 13:17:04.818+00	2026-01-24 13:17:04.818+00	t	\N	MC	\N	\N	\N
70565483-1c48-4cdd-ad5c-b904cd1b6c03	2024	1	d6a63e1c-e893-4c06-9425-2f9f8b8c1f37	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-10-21 00:00:00+00	2024-11-29 00:00:00+00	\N	AUTOMATICO	\N	\N	2025-01-13 00:00:00+00	2026-01-24 13:17:04.845+00	2026-01-24 13:17:04.845+00	t	\N	CI	10	\N	\N
e6cd8178-47fd-4e1f-a641-63b45db13b08	2026	8	2682d1b5-20fd-4a53-b251-7ddcdab963c1	1eeb0dff-da3b-4dfa-8fe2-e415f817921d	9acdf957-9a1a-4786-8463-f69262b0d65d	\N	2026-01-06 18:15:00+00	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-24 13:17:04.861+00	2026-01-24 13:17:04.861+00	t	\N	MC	30	\N	\N
d62f27cc-89d8-411f-ab23-d9c982ea4722	2026	5	7a0ed70d-e0c9-40ed-8167-389c0fe10e52	9e25d139-f360-4a6d-aece-eaddec5adb62	9acdf957-9a1a-4786-8463-f69262b0d65d	\N	2026-01-06 21:46:00+00	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-24 13:17:04.877+00	2026-01-24 13:17:04.877+00	t	\N	MC	60	\N	\N
3ac7d6c8-160e-4188-a7c2-71651f8ff9a3	2026	6	498c3f95-ae8b-4fb2-842e-32f77a63cd5b	4f54264c-4a35-48b2-adf7-15a31cd493f0	9acdf957-9a1a-4786-8463-f69262b0d65d	\N	2026-01-06 19:50:00+00	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-24 13:17:04.889+00	2026-01-24 13:17:04.889+00	t	\N	MC	40	\N	\N
f15b7a2c-1745-48ce-bb0b-36b8313a66be	2024	103	80a91104-b031-4e3c-8308-fbdff126f6dc	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-07-02 20:50:00+00	2024-07-31 16:31:00+00	\N	AUTOMATICO	\N	\N	2024-09-14 16:31:00+00	2026-01-24 13:17:04.904+00	2026-01-24 13:17:04.904+00	t	\N	MC	60	\N	\N
38da7911-3796-4e05-b527-e12b97f77148	2025	40	0b03eed0-e253-4914-8683-24e4f03a00f7	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-03-06 18:20:00+00	2025-04-13 23:40:00+00	\N	AUTOMATICO	\N	\N	2025-05-28 23:40:00+00	2026-01-24 13:17:04.92+00	2026-01-24 13:17:04.92+00	t	\N	MC	40	\N	\N
1946b945-d4b0-4d9d-88af-7d28ed6f91bd	2024	6	945b3158-6a8c-4360-97ad-0f50574e46a9	1eeb0dff-da3b-4dfa-8fe2-e415f817921d	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-10-03 20:30:00+00	2024-10-29 12:55:00+00	\N	AUTOMATICO	\N	\N	2024-12-13 12:55:00+00	2026-01-24 13:17:04.936+00	2026-01-24 13:17:04.936+00	t	\N	CI	30	\N	\N
e80c962c-c948-40df-b845-a5e1cf9ecda1	2024	2	cff19edb-4d41-4a8a-92ed-2a57683ba0fe	1eeb0dff-da3b-4dfa-8fe2-e415f817921d	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-10-04 19:18:00+00	2025-10-12 00:00:00+00	\N	AUTOMATICO	\N	\N	2025-11-26 00:00:00+00	2026-01-24 13:17:04.953+00	2026-01-24 13:17:04.953+00	t	\N	CI	30	\N	\N
519207f0-5525-49a1-9a73-dc5677c8052a	2024	3	f749d131-dad5-4391-9239-d3eff37d4e93	1eeb0dff-da3b-4dfa-8fe2-e415f817921d	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-10-08 21:25:00+00	2025-10-10 00:00:00+00	\N	AUTOMATICO	\N	\N	2025-11-24 00:00:00+00	2026-01-24 13:17:04.972+00	2026-01-24 13:17:04.972+00	t	\N	CI	30	\N	\N
c279aa7d-4b40-4ef6-a258-dcc99fecf12e	2024	4	2682d1b5-20fd-4a53-b251-7ddcdab963c1	1eeb0dff-da3b-4dfa-8fe2-e415f817921d	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-08-02 13:25:00+00	2024-12-15 11:05:00+00	\N	AUTOMATICO	\N	\N	2025-01-29 11:05:00+00	2026-01-24 13:17:04.991+00	2026-01-24 13:17:04.991+00	t	\N	CI	30	\N	\N
a99d8ff2-a070-4fa5-b63d-8e995754d143	2025	124	80a91104-b031-4e3c-8308-fbdff126f6dc	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-07-19 17:00:00+00	2025-08-19 14:02:00+00	\N	AUTOMATICO	\N	\N	2025-10-03 14:02:00+00	2026-01-24 13:17:05.007+00	2026-01-24 13:17:05.007+00	t	\N	MC	60	\N	\N
aea55b70-cb05-4ddd-bca5-7f8150d51c25	2025	110	eb1c36cf-265e-49d0-be00-373d54d77413	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-06-27 22:43:00+00	2025-07-20 12:40:00+00	\N	AUTOMATICO	\N	\N	2025-09-03 12:40:00+00	2026-01-24 13:17:05.025+00	2026-01-24 13:17:05.025+00	t	\N	MC	30	\N	\N
85262687-d1c9-47bf-8150-3ef63dcf0729	2024	5	1b2c15e0-ece3-4c58-8334-079d6d844c0e	1eeb0dff-da3b-4dfa-8fe2-e415f817921d	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-10-03 15:15:00+00	2024-10-26 06:59:00+00	\N	AUTOMATICO	\N	\N	2024-12-10 06:59:00+00	2026-01-24 13:17:05.053+00	2026-01-24 13:17:05.053+00	t	\N	CI	30	\N	\N
aa5d695f-6652-4e07-a1c4-95fb0ba0ea60	2025	100	d73fdcef-e978-44ca-a105-6066e9d96445	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	c56c252a-8a98-4dd6-9c2d-de6135686d71	2025-06-17 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-24 13:17:05.073+00	2026-01-24 13:17:05.073+00	t	\N	MC	30	\N	\N
8b3f1a6a-94ca-435d-88ee-1073be5e6b1c	2024	146	377b5ead-3c81-4651-ba39-035d8aa8057d	1eeb0dff-da3b-4dfa-8fe2-e415f817921d	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-11-04 05:55:00+00	2024-11-28 19:40:00+00	\N	AUTOMATICO	\N	\N	2025-01-12 19:40:00+00	2026-01-24 13:17:05.106+00	2026-01-24 13:17:05.106+00	t	\N	MC	30	\N	\N
9f980d1b-c296-4220-8d3d-2073323dde53	2025	181	d73fdcef-e978-44ca-a105-6066e9d96445	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-11-10 19:15:00+00	2025-12-12 12:00:00+00	\N	AUTOMATICO	\N	\N	2026-01-26 12:00:00+00	2026-01-24 13:17:05.122+00	2026-01-24 13:17:05.122+00	t	\N	MC	30	\N	\N
aa3f62fe-ca9c-47e4-a453-e86269747aa1	2025	107	ebdb90ca-16a1-4523-ab69-aacd1cfdae6b	9e25d139-f360-4a6d-aece-eaddec5adb62	c56c252a-8a98-4dd6-9c2d-de6135686d71	2025-06-21 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-24 13:17:05.137+00	2026-01-24 13:17:05.137+00	t	\N	MC	60	\N	\N
c8626863-6de0-4db6-9da9-36f4fae1d429	2025	172	2682d1b5-20fd-4a53-b251-7ddcdab963c1	1eeb0dff-da3b-4dfa-8fe2-e415f817921d	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-10-23 14:05:00+00	2025-11-24 09:40:00+00	\N	AUTOMATICO	\N	\N	2026-01-08 09:40:00+00	2026-01-24 13:17:05.154+00	2026-01-24 13:17:05.154+00	t	\N	MC	30	\N	\N
347a3b51-068b-4061-b5ee-d4bc9d85f91e	2025	117	84fa549b-42f6-46de-9d8e-458b2c4f652b	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-07-11 18:30:00+00	2025-08-20 16:20:00+00	\N	AUTOMATICO	\N	\N	2025-10-04 16:20:00+00	2026-01-24 13:17:05.172+00	2026-01-24 13:17:05.172+00	t	\N	MC	30	\N	\N
28fdcb18-d8e2-4b94-97a5-7fa0f94b3efe	2024	7	377b5ead-3c81-4651-ba39-035d8aa8057d	1eeb0dff-da3b-4dfa-8fe2-e415f817921d	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-10-06 22:40:00+00	2025-10-10 00:00:00+00	\N	AUTOMATICO	\N	\N	2025-11-24 00:00:00+00	2026-01-24 13:17:05.199+00	2026-01-24 13:17:05.199+00	t	\N	CI	30	\N	\N
06450b8c-301e-4bb0-bf9a-15bc1d5fa7a9	2025	1	75c6f9df-0db0-4c13-98ed-8b3bc4c475e4	\N	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-04-16 00:00:00+00	2025-05-16 00:00:00+00	\N	AUTOMATICO	\N	\N	2025-06-30 00:00:00+00	2026-01-24 13:17:05.217+00	2026-01-24 13:17:05.217+00	t	\N	CI	\N	\N	\N
e4607759-69d1-4726-bf88-839b4573dbd1	2025	109	f4f48e38-8826-4db0-a659-951dee4e373f	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	c56c252a-8a98-4dd6-9c2d-de6135686d71	2025-06-23 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-24 13:17:05.231+00	2026-01-24 13:17:05.231+00	t	\N	MC	60	\N	\N
d56971fb-f4fe-46ac-a75c-9dd8b341be9f	2025	115	d73fdcef-e978-44ca-a105-6066e9d96445	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	c56c252a-8a98-4dd6-9c2d-de6135686d71	2025-07-08 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-24 13:17:05.249+00	2026-01-24 13:17:05.249+00	t	\N	MC	30	\N	\N
d24e14d1-7d1a-4265-8364-965765f5548e	2025	38	cff19edb-4d41-4a8a-92ed-2a57683ba0fe	1eeb0dff-da3b-4dfa-8fe2-e415f817921d	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-03-06 13:02:00+00	2025-03-26 17:12:00+00	\N	AUTOMATICO	\N	\N	2025-05-10 17:12:00+00	2026-01-24 13:17:05.265+00	2026-01-24 13:17:05.265+00	t	\N	MC	30	\N	\N
b882bd42-86d4-4653-b810-3beb2845fc22	2025	120	d14ddc4a-523b-4cc2-a0ea-cdab105b0311	9e25d139-f360-4a6d-aece-eaddec5adb62	c56c252a-8a98-4dd6-9c2d-de6135686d71	2025-07-11 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-24 13:17:05.281+00	2026-01-24 13:17:05.281+00	t	\N	MC	30	\N	\N
020f5b3a-817d-4ef4-9308-d7da35261b8a	2025	173	7e7de950-28ea-49ac-af70-269988863345	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2025-10-30 08:05:00+00	2025-11-19 07:17:00+00	\N	AUTOMATICO	\N	\N	2026-01-03 07:17:00+00	2026-01-24 13:17:05.299+00	2026-01-24 13:17:05.299+00	t	\N	MC	60	\N	\N
9e8943bb-9556-450d-bb55-2885d89473ce	2025	17	edd87f10-eea7-4484-85b5-c4e725767ea8	4f54264c-4a35-48b2-adf7-15a31cd493f0	c56c252a-8a98-4dd6-9c2d-de6135686d71	2025-01-17 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-24 13:17:05.316+00	2026-01-24 13:17:05.316+00	t	\N	MC	40	\N	\N
bb60421c-7a27-4de4-9f3f-c3a1b3ed38ca	2025	123	9501be2a-5bc6-4062-ad1e-2aebfa92af0c	9e25d139-f360-4a6d-aece-eaddec5adb62	c56c252a-8a98-4dd6-9c2d-de6135686d71	2025-07-19 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-24 13:17:05.334+00	2026-01-24 13:17:05.334+00	t	\N	MC	60	\N	\N
9bd1f61d-6d04-4749-badd-a280983dafa3	2025	39	377b5ead-3c81-4651-ba39-035d8aa8057d	1eeb0dff-da3b-4dfa-8fe2-e415f817921d	c56c252a-8a98-4dd6-9c2d-de6135686d71	2025-03-06 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-24 13:17:05.354+00	2026-01-24 13:17:05.354+00	t	\N	MC	30	\N	\N
71802c9f-7a01-4119-aff7-ffc082c3cf28	2025	125	a3651180-875d-412f-a557-1b05afd454ff	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	c56c252a-8a98-4dd6-9c2d-de6135686d71	2025-07-18 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-24 13:17:05.371+00	2026-01-24 13:17:05.371+00	t	\N	MC	30	\N	\N
656431c5-0e35-42ae-9165-a58e446382ab	2025	85	fadfa149-546e-4dd2-b3b8-caea5b867715	9e25d139-f360-4a6d-aece-eaddec5adb62	c56c252a-8a98-4dd6-9c2d-de6135686d71	2025-05-20 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-24 13:17:05.388+00	2026-01-24 13:17:05.388+00	t	\N	MC	60	\N	\N
590b2227-e71f-456b-a060-b6a830524615	2025	92	a3651180-875d-412f-a557-1b05afd454ff	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	c56c252a-8a98-4dd6-9c2d-de6135686d71	2025-05-29 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-24 13:17:05.404+00	2026-01-24 13:17:05.404+00	t	\N	MC	30	\N	\N
5375bc9a-34b7-489a-9989-87215650a63d	2024	147	f749d131-dad5-4391-9239-d3eff37d4e93	1eeb0dff-da3b-4dfa-8fe2-e415f817921d	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-10-31 00:16:00+00	2024-11-26 20:20:00+00	\N	AUTOMATICO	\N	\N	2025-01-10 20:20:00+00	2026-01-24 13:17:05.421+00	2026-01-24 13:17:05.421+00	t	\N	MC	30	\N	\N
2a5635f9-466a-4f43-9ed6-faf9157e30af	2024	156	aeb1c939-78bd-4a60-a082-f9a46ed969d3	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-11-01 16:38:00+00	2024-11-07 08:00:00+00	\N	AUTOMATICO	\N	\N	2024-12-22 08:00:00+00	2026-01-24 13:17:05.436+00	2026-01-24 13:17:05.436+00	t	\N	MC	30	\N	\N
ef369980-3be8-421c-8f75-ffc239043303	2024	166	945b3158-6a8c-4360-97ad-0f50574e46a9	1eeb0dff-da3b-4dfa-8fe2-e415f817921d	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-11-20 07:15:00+00	2024-12-10 13:30:00+00	\N	AUTOMATICO	\N	\N	2025-01-24 13:30:00+00	2026-01-24 13:17:05.453+00	2026-01-24 13:17:05.453+00	t	\N	MC	30	\N	\N
51e88a0f-d28d-4638-8865-d4cc7e8e1bb8	2024	145	1b2c15e0-ece3-4c58-8334-079d6d844c0e	1eeb0dff-da3b-4dfa-8fe2-e415f817921d	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-10-28 20:10:00+00	2024-11-22 06:00:00+00	\N	AUTOMATICO	\N	\N	2025-01-06 06:00:00+00	2026-01-24 13:17:05.468+00	2026-01-24 13:17:05.468+00	t	\N	MC	30	\N	\N
317b1c0b-a899-4d1f-80f9-b3473921ff73	2025	188	7e7de950-28ea-49ac-af70-269988863345	9e25d139-f360-4a6d-aece-eaddec5adb62	9acdf957-9a1a-4786-8463-f69262b0d65d	\N	2025-12-30 18:05:00+00	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-24 13:17:05.483+00	2026-01-24 13:17:05.483+00	t	\N	MC	60	\N	\N
49097f16-3982-4fc0-91cc-ea400517493c	2025	193	88b34cd5-d857-4431-ae65-85acf97b13aa	4f54264c-4a35-48b2-adf7-15a31cd493f0	9acdf957-9a1a-4786-8463-f69262b0d65d	\N	2025-12-29 00:00:00+00	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-24 13:17:05.498+00	2026-01-24 13:17:05.498+00	t	\N	MC	40	\N	\N
aea183a8-53d7-45c9-9626-a7c9615929e4	2024	138	a8956f2f-f8e4-4387-8fa3-48ea20c38489	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-09-05 12:26:00+00	2024-09-25 08:50:00+00	\N	AUTOMATICO	\N	\N	2024-11-09 08:50:00+00	2026-01-24 13:17:05.517+00	2026-01-24 13:17:05.517+00	t	\N	MC	60	\N	\N
e45e3637-a667-4169-87fb-9512df52de90	2024	47	5b11295e-6b0b-4983-ade2-4c94e98cc8d0	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-03-26 22:35:00+00	2024-05-15 23:00:00+00	\N	AUTOMATICO	\N	\N	2024-06-29 23:00:00+00	2026-01-24 13:17:05.535+00	2026-01-24 13:17:05.535+00	t	\N	MC	60	\N	\N
883166f6-5ec0-44fd-984f-e8e8a75a28df	2024	78	5b11295e-6b0b-4983-ade2-4c94e98cc8d0	9e25d139-f360-4a6d-aece-eaddec5adb62	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-05-17 18:30:00+00	2024-07-02 05:25:00+00	\N	AUTOMATICO	\N	\N	2024-08-16 05:25:00+00	2026-01-24 13:17:05.55+00	2026-01-24 13:17:05.55+00	t	\N	MC	60	\N	\N
54df0379-3ab1-48b0-a1d6-7abb1693a501	2024	7	d73fdcef-e978-44ca-a105-6066e9d96445	ef49b6e8-8d95-4c40-91aa-a431dbea41b5	9958d706-2c00-447c-b303-b8a2fa2ce060	\N	2024-01-03 19:15:00+00	2024-01-23 13:30:00+00	\N	AUTOMATICO	\N	\N	2024-03-08 13:30:00+00	2026-01-24 13:17:05.565+00	2026-01-24 13:17:05.565+00	t	\N	MC	30	\N	\N
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
4cba3640-f9d8-474f-9fdf-a8b2ec63850c	f20b023a-4ce3-4cce-98cc-911bdcedbc03	1	83867dcf-3fe0-4b78-8470-aabe5c344bda	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2024-06-26 22:10:00+00	2024-08-07 15:00:00+00	MC	\N
5b37f581-c77c-4fdf-b617-14931a037ed6	a0a3821d-bd0f-4755-aec7-93f2f5d68bfd	1	83867dcf-3fe0-4b78-8470-aabe5c344bda	\N	\N	2024-04-19 12:00:00+00	2024-05-13 18:04:00+00	MC	\N
edf93b3c-05cd-4f0e-925a-8e657ab98625	3e2b7c0e-1f3d-4843-a7ea-53e54946f96e	1	83867dcf-3fe0-4b78-8470-aabe5c344bda	\N	\N	2024-05-16 18:20:00+00	2024-06-05 07:54:00+00	MC	\N
a2506295-c3ed-49e5-a02c-a196682f0363	73c13f8b-845a-4246-aa87-585374cd818e	1	13c3c551-df0d-4c62-a185-d36a0298672a	f3d2726d-273b-4876-8181-2bad234708b5	f3d2726d-273b-4876-8181-2bad234708b5	2023-12-30 16:20:00+00	2024-02-01 21:15:00+00	MC	\N
4e326e3e-84a8-4e8e-a80a-2af8dc02a8a8	97c232b8-b59c-43ee-b99a-ee092bce107e	1	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	\N	\N	2024-03-27 17:15:00+00	2024-04-14 07:49:00+00	MC	\N
df173cd2-fcac-47aa-bfae-91e1d29fb495	d8be8d26-35dc-46f4-b2ba-ef7bde6bddc5	1	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	\N	\N	2024-05-22 17:05:00+00	2024-06-02 17:05:00+00	MC	\N
94bcc11a-8f70-43c3-a08d-c13969cc2928	6e4835d6-4c4e-4b5a-8a7f-ee6db3ac8f15	1	127f273e-086c-4e23-bb9e-0557fc9270aa	aa748f6a-602b-4346-b964-50cbcea76146	aa748f6a-602b-4346-b964-50cbcea76146	2024-03-21 10:05:00+00	2024-04-16 15:40:00+00	MC	\N
c8cf46af-de92-4557-b1fe-fc4bed0bf44e	67cd79d1-9f58-4aee-bc03-43367153054e	1	127f273e-086c-4e23-bb9e-0557fc9270aa	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2023-12-29 15:30:00+00	2024-01-29 02:25:00+00	MC	\N
eab17adb-ec74-459e-b9c9-947c195e3146	5c47ab58-6e79-49a6-80fb-da2dbe24ec33	1	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2024-02-19 16:20:00+00	2024-02-23 08:03:00+00	MC	\N
8694f564-ffa8-4fdf-8562-5fed754f1bb6	489c7453-ce53-4ec5-8e8a-123f31046d41	1	127f273e-086c-4e23-bb9e-0557fc9270aa	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2024-03-06 18:55:00+00	2024-04-16 11:04:00+00	MC	\N
20857ad6-7701-4d8d-9f60-6cf7eee1e24d	82d9d3ca-6efe-4e53-8410-cc934deb4a54	1	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	953117a0-3c04-4129-ab96-5eddf3a8d43a	953117a0-3c04-4129-ab96-5eddf3a8d43a	2024-05-23 23:18:00+00	2024-06-05 06:32:00+00	MC	\N
388a4a69-5d90-43d1-add6-faff1afd1334	db5f82ad-4ed7-49bc-99eb-ed9bfc53cabe	1	cb20a7a1-e40f-4cb1-af07-8e5273dd0237	792484d9-dc51-4a9d-b9a5-d28c9047bcf0	792484d9-dc51-4a9d-b9a5-d28c9047bcf0	2023-11-30 23:00:00+00	2024-02-06 05:38:00+00	MC	\N
f5389f5e-bb89-4915-bee4-a5a02464f416	4234dd03-97b4-4543-89bf-abd1deba1733	2	13c3c551-df0d-4c62-a185-d36a0298672a	792484d9-dc51-4a9d-b9a5-d28c9047bcf0	aa748f6a-602b-4346-b964-50cbcea76146	2025-08-06 08:55:00+00	2025-09-13 00:44:00+00	MC	\N
d33376a6-5b33-451b-896c-af38af70b972	4234dd03-97b4-4543-89bf-abd1deba1733	1	13c3c551-df0d-4c62-a185-d36a0298672a	aa748f6a-602b-4346-b964-50cbcea76146	792484d9-dc51-4a9d-b9a5-d28c9047bcf0	2025-07-31 13:05:00+00	2025-08-05 07:05:00+00	MC	\N
bf996b58-c08f-4d4f-9f12-0fbbbd59cba0	7ecdf5f5-f405-4632-9677-d62deb1c09ad	1	83867dcf-3fe0-4b78-8470-aabe5c344bda	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2024-03-14 14:41:00+00	2024-04-16 12:43:00+00	MC	\N
ae36a8dd-26e2-4b30-82ab-e0ee0614dd73	fb205b67-0cb0-4b7f-b159-1a17bc5010c8	1	83867dcf-3fe0-4b78-8470-aabe5c344bda	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2024-04-20 13:20:00+00	2024-05-22 08:43:00+00	MC	\N
a1c99045-4fd7-4721-a79e-4d49cb078a93	eee00978-801e-47f0-8c55-6ee16b010379	1	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2024-06-18 19:47:00+00	2024-06-29 11:58:00+00	MC	\N
fb0f48b5-4381-4610-8e78-38e5990a97f5	4d891826-447b-479e-b99d-eb4507fcf5ba	1	83867dcf-3fe0-4b78-8470-aabe5c344bda	\N	\N	2024-08-14 22:32:00+00	2024-09-03 07:18:00+00	MC	\N
f6588277-b03f-47ce-a03b-b6591bea266d	8f495773-1fd5-49db-849c-b4ef984ef43f	1	83867dcf-3fe0-4b78-8470-aabe5c344bda	\N	\N	2024-09-05 14:10:00+00	2024-10-10 08:43:00+00	MC	\N
b2989f82-2672-43af-b81b-7a260599afc7	a8f6adc9-09fe-4f64-a002-0bab440dae7c	1	13c3c551-df0d-4c62-a185-d36a0298672a	f3d2726d-273b-4876-8181-2bad234708b5	f3d2726d-273b-4876-8181-2bad234708b5	2023-12-30 12:50:00+00	2024-02-03 21:20:00+00	MC	\N
2bfd80f2-7733-4833-bae4-4094bfe48336	bd157ef7-7d47-4ded-8ca2-11ab62821954	1	13c3c551-df0d-4c62-a185-d36a0298672a	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2024-02-23 19:20:00+00	2024-03-21 08:10:00+00	MC	\N
244ff0a0-8e8e-4962-a70e-07c237bd246e	a261f6dd-91b4-465e-84da-50da968b9d0b	1	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2024-04-29 17:02:00+00	2024-05-12 06:35:00+00	MC	\N
1f4792ae-8dfb-4fcc-bbbd-83322f8c5bba	35d2fffe-790f-4376-be9d-e1639ee87fdd	1	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2024-07-28 17:54:00+00	2024-08-07 10:50:00+00	MC	\N
e5deced6-e8e0-4351-be1d-617fda2b912b	f4d70f61-21d6-41ea-b802-8619d521e8f8	1	83867dcf-3fe0-4b78-8470-aabe5c344bda	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2024-01-10 13:50:00+00	2024-02-18 14:06:00+00	MC	\N
fd94cb2a-e001-43c9-9a22-4a595413e0d8	1f7e81e0-e295-43c0-8b96-299483589a3f	1	83867dcf-3fe0-4b78-8470-aabe5c344bda	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2024-02-22 20:45:00+00	2024-04-04 07:46:00+00	MC	\N
ab5826f0-496e-4cb4-acce-b4ebfa60d0af	a8b6da09-dccb-4552-9617-a76925b833e8	1	83867dcf-3fe0-4b78-8470-aabe5c344bda	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2024-04-08 11:05:00+00	2024-05-30 10:07:00+00	MC	\N
55da8053-1da4-4798-92a4-9527f5eef96e	da188ba1-8ee5-4ff4-99ad-27214968243e	1	83867dcf-3fe0-4b78-8470-aabe5c344bda	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2024-07-26 14:32:00+00	2024-09-11 09:37:00+00	MC	\N
00865a2b-996d-4198-9b44-4288cb0292f0	5390aca8-ef01-483e-8c9c-12da08d57aec	1	127f273e-086c-4e23-bb9e-0557fc9270aa	f3d2726d-273b-4876-8181-2bad234708b5	f3d2726d-273b-4876-8181-2bad234708b5	2024-01-08 10:57:00+00	2024-02-01 05:21:00+00	MC	\N
d2af380f-9556-4208-8c6b-a71717163c5b	d2bdc49a-f26e-49d6-8f94-98ed942951dd	1	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2024-07-06 12:20:00+00	2024-07-14 12:54:00+00	MC	\N
a206eee7-9d95-4189-93e9-72478c82c1ee	cf7ee3dc-5f63-4abb-a305-a977bd6671ee	1	83867dcf-3fe0-4b78-8470-aabe5c344bda	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2024-01-06 15:49:00+00	2024-01-08 20:15:00+00	MC	\N
f6c39f3a-8092-4a1f-b572-8723f9e79e79	a03d8cc4-1d65-4a73-9a40-e4ca294241f2	1	127f273e-086c-4e23-bb9e-0557fc9270aa	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2024-03-14 15:32:00+00	2024-04-22 09:00:00+00	MC	\N
7f04933c-bbaf-4306-bdbc-6bd2c40195e8	51666c22-e869-4151-b83c-856f8b77f10d	1	13c3c551-df0d-4c62-a185-d36a0298672a	f3d2726d-273b-4876-8181-2bad234708b5	f3d2726d-273b-4876-8181-2bad234708b5	2023-12-07 22:50:00+00	2024-01-14 10:25:00+00	MC	\N
b617efe9-a65b-4e19-8a68-c2eb414060b1	1ecf1604-0e9b-4946-ba25-880499a9b72c	1	cb20a7a1-e40f-4cb1-af07-8e5273dd0237	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2024-02-29 21:05:00+00	2024-04-09 02:50:00+00	MC	\N
1ed47b0f-b2bc-40bb-8085-764c41620415	341949b8-9fae-4aa9-a984-3faf13cccb68	1	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	\N	\N	2024-05-22 15:40:00+00	2024-06-11 10:10:00+00	MC	\N
f4fd7bea-b737-4ac7-9b3a-27c32fa189c1	cb8cc24f-c786-4b11-a682-6aa04e148caa	1	127f273e-086c-4e23-bb9e-0557fc9270aa	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2024-01-09 18:45:00+00	2024-02-11 09:08:00+00	MC	\N
f3c3222a-9c04-44c4-8907-a8a5943d46b2	7a6a70a7-2677-42c8-9ab2-af68f63d7db2	1	127f273e-086c-4e23-bb9e-0557fc9270aa	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2024-02-14 18:40:00+00	2024-03-17 08:00:00+00	MC	\N
275e4ac2-2041-4768-ba74-74bb1dc5fb7c	5eb58775-4c52-4cf9-9142-7901799b386a	1	13c3c551-df0d-4c62-a185-d36a0298672a	f3d2726d-273b-4876-8181-2bad234708b5	f3d2726d-273b-4876-8181-2bad234708b5	2024-02-03 18:25:00+00	2024-03-06 18:20:00+00	MC	\N
f5dad6f3-ad63-4894-b40b-95e93dedd115	8a78f9d8-e0f6-4b0e-bcd1-5a4fd9c9d98f	1	1985bde5-8964-4250-b775-74cc7469ed58	953117a0-3c04-4129-ab96-5eddf3a8d43a	953117a0-3c04-4129-ab96-5eddf3a8d43a	2024-07-13 09:00:00+00	2024-08-20 06:07:00+00	MC	\N
79f4ebbf-2d4d-4b48-a527-a4e84f705fdc	eaad608f-4f9a-420b-8e63-0e2aa28cc631	1	127f273e-086c-4e23-bb9e-0557fc9270aa	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2024-01-09 11:53:00+00	2024-02-05 18:37:00+00	MC	\N
8ba8cc13-04c6-4f98-9061-74d7931a6911	0e36dc1a-2dc5-477e-a719-ebb304a65b44	1	127f273e-086c-4e23-bb9e-0557fc9270aa	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2024-04-30 18:40:00+00	2024-05-16 00:00:00+00	MC	\N
a628b79a-b20c-478e-a29d-4e5b3db5e732	a25f941a-a404-4a5e-bc44-a0e5e0b8ec4d	1	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2024-05-29 17:45:00+00	2024-06-29 17:05:00+00	MC	\N
4f299a67-ede0-470d-8c65-68ce29af748f	5d187221-c421-484d-9a94-ae56f87acce1	1	13c3c551-df0d-4c62-a185-d36a0298672a	f3d2726d-273b-4876-8181-2bad234708b5	f3d2726d-273b-4876-8181-2bad234708b5	2024-10-27 23:30:00+00	2024-10-29 15:55:00+00	MC	\N
ddf73c20-7b8a-4e92-8fc7-d39f317277aa	891574a1-010e-49a0-aea1-4b43f8f15658	1	13c3c551-df0d-4c62-a185-d36a0298672a	f3d2726d-273b-4876-8181-2bad234708b5	f3d2726d-273b-4876-8181-2bad234708b5	2023-12-30 12:30:00+00	2024-02-03 20:47:00+00	MC	\N
2a8d6b87-c027-4dce-b116-47deca09b310	82d9e8a0-5610-4617-9a4b-55eeac6d96ec	1	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2024-05-10 13:25:00+00	2024-06-14 19:30:00+00	MC	\N
76d05e57-fb45-4857-804d-bdc28bbbe1dc	acfa3d72-1582-4d71-b7e1-abffe4fd613b	1	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2024-07-10 19:19:00+00	2024-08-09 18:50:00+00	MC	\N
ceab2344-07c9-4b11-8f22-3b806f39e1df	d546ddc0-8630-4376-9453-9bbe49c3f9ef	1	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2024-05-11 13:50:00+00	2024-05-20 11:37:00+00	MC	\N
7cfd83c4-621c-4af8-90ef-cbc0d387e25e	4aee24df-1523-4946-9cc8-c7549aa3a78d	1	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2024-08-07 11:38:00+00	2024-08-15 00:52:00+00	MC	\N
8538298e-7378-4b40-91f9-9ac0224acd08	0bbd25df-07ab-4373-9d6b-0fea75deb7ff	1	cb20a7a1-e40f-4cb1-af07-8e5273dd0237	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2024-09-30 00:45:00+00	2024-10-29 23:51:00+00	MC	\N
ae692016-ab19-49d9-b927-bf3b7107b0e6	503a17e8-d9db-4884-9cb4-1750a9796231	1	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2024-01-17 15:00:00+00	2024-01-25 05:38:00+00	MC	\N
0e3e56af-f097-4d92-ac8d-18b9fd5e84b4	f1cd7188-c626-4483-bf3c-c2e85225d7fd	1	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2024-04-24 16:30:00+00	2024-05-04 17:08:00+00	MC	\N
9e4df87a-193b-4d0b-81a2-4cc71aa04a42	d6f11abd-28c4-4047-89d5-cada8a9dbabb	1	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2024-09-06 18:10:00+00	2024-09-13 17:00:00+00	MC	\N
89fbdec0-af5c-4a94-aa21-80e0eeb61210	66993fe2-82c8-4826-aa9b-1eb410b1b016	1	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2024-12-03 16:49:00+00	2024-12-11 08:35:00+00	MC	\N
e6d01a20-7d28-441e-bf0a-fd0485975118	210fbf0a-2daf-4d64-b738-d04cc216b583	1	13c3c551-df0d-4c62-a185-d36a0298672a	f3d2726d-273b-4876-8181-2bad234708b5	f3d2726d-273b-4876-8181-2bad234708b5	2024-02-06 22:12:00+00	2024-02-23 08:25:00+00	MC	\N
238a1aaf-ea9e-432d-b32f-aea7b0ab0bd8	16a326ac-b7b0-4437-9a8a-74fcc7b829af	1	cb20a7a1-e40f-4cb1-af07-8e5273dd0237	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2024-04-10 19:30:00+00	2024-04-13 20:34:00+00	MC	\N
3b157fc9-338d-48c3-b9cf-814f98791e7e	913ceb70-a52e-49c5-bddd-5cb7b3f466b3	1	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2024-06-26 12:00:00+00	2024-07-12 23:00:00+00	MC	\N
1ad4b45e-fae6-4333-99ec-42b7fc05083e	4c9d8c24-82b8-4155-b437-98ba08a37887	1	127f273e-086c-4e23-bb9e-0557fc9270aa	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2024-01-06 13:00:00+00	2024-01-31 23:50:00+00	MC	\N
b4ea4b91-d1e0-4c81-ae38-6d52364d0cef	be32e8e7-af31-4698-a87d-9390e360c0ee	1	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2024-07-28 17:59:00+00	2024-08-04 08:40:00+00	MC	\N
84f20e71-8d81-4bd7-a103-f31e0f023073	8513f6d3-0db3-4e09-8392-f60fc146c9e0	1	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2024-09-06 10:57:00+00	2024-09-13 07:08:00+00	MC	\N
f3bb534b-a934-4301-922c-bb50d82821bb	7530322d-4dfc-419d-bed0-e8cc7dd690ea	1	13c3c551-df0d-4c62-a185-d36a0298672a	f3d2726d-273b-4876-8181-2bad234708b5	f3d2726d-273b-4876-8181-2bad234708b5	2023-12-30 20:00:00+00	2024-01-30 20:00:00+00	MC	\N
43908e86-0048-40b7-8450-3e916da2835e	e07dfdbb-0069-439b-8a09-061e82bc6bd3	1	13c3c551-df0d-4c62-a185-d36a0298672a	f3d2726d-273b-4876-8181-2bad234708b5	f3d2726d-273b-4876-8181-2bad234708b5	2024-02-26 23:10:00+00	2024-03-12 20:30:00+00	MC	\N
18175b50-da59-47aa-aeb0-5547c4f236d8	a718fba8-b7d9-41ef-9992-ffbd23506956	1	127f273e-086c-4e23-bb9e-0557fc9270aa	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2024-04-25 18:11:00+00	2024-05-24 10:52:00+00	MC	\N
2b14e38c-d836-4ee4-8863-d9e4e0ac825d	3636e297-22f9-4efa-9f94-d47f1b0030c7	1	83867dcf-3fe0-4b78-8470-aabe5c344bda	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2024-08-24 13:21:00+00	2024-09-27 08:17:00+00	MC	\N
0a180c77-7f00-4a11-84ae-541e0439d1dd	41546177-9a22-4dc6-a9ea-b9f591dc21da	1	83867dcf-3fe0-4b78-8470-aabe5c344bda	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2024-11-15 16:53:00+00	2024-12-16 16:46:00+00	MC	\N
ce38759d-d27e-44b6-a795-3c4aa26f7747	07ab166e-0c45-4471-8512-83ad0ba8d6bf	1	13c3c551-df0d-4c62-a185-d36a0298672a	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2024-01-06 08:40:00+00	2024-01-11 08:40:00+00	MC	\N
77946be2-77a0-4f08-8143-81af5492d3b4	41349fe9-7643-4de0-b554-993d520c198d	1	83867dcf-3fe0-4b78-8470-aabe5c344bda	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2024-05-15 15:17:00+00	2024-06-23 11:40:00+00	MC	\N
ee701eda-8aa4-43c9-b88b-04050758ea1c	893f8b43-88e4-44ff-b895-af1628e9b8e1	1	cb20a7a1-e40f-4cb1-af07-8e5273dd0237	792484d9-dc51-4a9d-b9a5-d28c9047bcf0	792484d9-dc51-4a9d-b9a5-d28c9047bcf0	2024-12-06 23:45:00+00	2025-02-04 04:35:00+00	MC	\N
cbb7bc38-9acf-41ff-bd41-9e13d5982315	7ab4da54-a46d-4f6f-bebd-9a0233ec6fca	1	1985bde5-8964-4250-b775-74cc7469ed58	f3d2726d-273b-4876-8181-2bad234708b5	f3d2726d-273b-4876-8181-2bad234708b5	2024-01-13 13:30:00+00	2024-02-25 08:04:00+00	MC	\N
570f3ac8-e643-4e4b-a1df-9cd68be02d35	ae47e344-c7bd-492e-9d8d-9102d8e8b64d	1	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	953117a0-3c04-4129-ab96-5eddf3a8d43a	953117a0-3c04-4129-ab96-5eddf3a8d43a	2024-03-27 05:50:00+00	2024-04-13 17:30:00+00	MC	\N
07ea6cc9-6de0-4aaf-a0d3-99e83bb86b55	58c3cb74-3fa8-430b-83bf-5dc32f9977e1	1	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2024-05-11 12:08:00+00	2024-05-22 12:06:00+00	MC	\N
4903ab1d-a6f5-4d95-b997-4ca5aa2d54ea	6bc2c3d5-ed76-4a68-b518-42b63b234427	1	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2024-08-15 15:21:00+00	2024-09-14 09:30:00+00	MC	\N
91485a49-8755-47dd-90b5-71103d424d28	8015addd-6ac6-4e48-b831-4723f02ee687	1	cb20a7a1-e40f-4cb1-af07-8e5273dd0237	792484d9-dc51-4a9d-b9a5-d28c9047bcf0	792484d9-dc51-4a9d-b9a5-d28c9047bcf0	2024-02-09 18:23:00+00	2024-03-18 02:20:00+00	MC	\N
96d8ed24-cdfc-4438-a44e-b527675a306e	2051da06-42ad-4e62-9cae-c6db658936c0	1	cb20a7a1-e40f-4cb1-af07-8e5273dd0237	792484d9-dc51-4a9d-b9a5-d28c9047bcf0	\N	2026-01-15 03:00:00+00	\N	MC	
907a73db-5475-4753-9913-7326bb4e28a2	3fe0dadb-018d-468b-9d67-c24956f31b73	1	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2024-03-27 03:45:00+00	2024-04-27 18:56:00+00	MC	\N
e191d0e1-e26e-4c84-ad32-c8ffdefd1a64	d0914875-9ace-45c0-9575-de87a7477ce1	1	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2024-05-24 22:30:00+00	2024-05-29 09:40:00+00	MC	\N
0f070f44-fab8-42ec-a0eb-f4cf66d2a810	e3939cce-f7db-4bb9-a1b2-1342f710cb04	1	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2024-06-11 21:15:00+00	2024-06-21 15:10:00+00	MC	\N
94fb51e5-7354-42bb-a5ae-bd3a9aa2f92a	2580512b-1f53-465f-99bf-a4a1aaedd385	1	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2024-07-16 00:00:00+00	2024-07-28 00:00:00+00	MC	\N
7cc9805e-40a3-43eb-9982-3c6b7d7798c3	40a2e86a-7673-40a8-b76d-c8fd6bd3c7da	1	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2024-01-22 13:55:00+00	2024-02-03 00:04:00+00	MC	\N
46d76f56-b9bc-4648-ae35-516ae99c7f88	4be3bb24-6688-4b99-863d-577c80cbc58e	1	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2024-03-28 18:23:00+00	2024-04-09 18:00:00+00	MC	\N
d2f241aa-f4bb-490d-8c2d-189b02f6aa46	87c8e125-7eb0-40ca-8e8e-69bf0e037a9c	1	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2024-05-18 11:00:00+00	2024-05-22 18:07:00+00	MC	\N
d67d1626-2163-4d2c-a4d4-c9bff818d8fa	8055fb95-d469-4a19-bd0d-568025b021d4	1	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2024-06-20 06:55:00+00	2024-06-24 14:00:00+00	MC	\N
3ea48988-5734-4785-880f-2fdb2aaf7e49	32eca87e-c32c-4a94-aadc-fb79d02e15b2	1	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2024-08-20 19:05:00+00	2024-08-28 08:29:00+00	MC	\N
225bfd4f-f93a-437a-9405-1b660e8d2544	24771909-d5a2-4a9f-8240-8fd54be6a37f	1	127f273e-086c-4e23-bb9e-0557fc9270aa	f3d2726d-273b-4876-8181-2bad234708b5	f3d2726d-273b-4876-8181-2bad234708b5	2024-01-19 20:37:00+00	2024-02-14 08:23:00+00	MC	\N
eebacce3-6a41-46a8-b327-6cde149636db	cca3e6c3-8733-48ec-8567-28e86f52f432	1	13c3c551-df0d-4c62-a185-d36a0298672a	f3d2726d-273b-4876-8181-2bad234708b5	f3d2726d-273b-4876-8181-2bad234708b5	2024-03-02 20:35:00+00	2024-04-04 07:00:00+00	MC	\N
ca5e77e2-7628-41fc-82af-02b8aca65afc	86e2d809-bb36-48b0-af10-f6f8e5ba4eda	1	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	aa748f6a-602b-4346-b964-50cbcea76146	aa748f6a-602b-4346-b964-50cbcea76146	2024-04-29 18:20:00+00	2024-05-20 08:40:00+00	MC	\N
71af674e-f0f8-4502-8b6b-e63d6a7df801	e5f7200a-3441-4d5b-8eb2-175092d9e7f2	1	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	aa748f6a-602b-4346-b964-50cbcea76146	aa748f6a-602b-4346-b964-50cbcea76146	2024-05-23 19:35:00+00	2024-06-09 11:55:00+00	MC	\N
dd8bfca5-ee78-472d-b594-9c0ef07070fb	e2488908-b66f-41cf-885e-61652b3898c7	1	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	aa748f6a-602b-4346-b964-50cbcea76146	aa748f6a-602b-4346-b964-50cbcea76146	2024-07-21 13:05:00+00	2024-07-27 16:40:00+00	MC	\N
1fb7073d-2ad4-469a-95d3-35d25bd812e3	df8941e8-61c5-48c4-bcf6-2d7bdb7d826b	1	cb20a7a1-e40f-4cb1-af07-8e5273dd0237	aa748f6a-602b-4346-b964-50cbcea76146	aa748f6a-602b-4346-b964-50cbcea76146	2024-01-05 20:05:00+00	2024-01-25 20:15:00+00	MC	\N
1cea5515-93aa-44a8-a1ff-556d405b3fe3	9a78af6b-2406-46c1-b427-8781c67bcdda	1	cb20a7a1-e40f-4cb1-af07-8e5273dd0237	aa748f6a-602b-4346-b964-50cbcea76146	aa748f6a-602b-4346-b964-50cbcea76146	2024-01-27 20:00:00+00	2024-02-24 17:45:00+00	MC	\N
e21422be-c230-4b13-9aff-6b254d5ff040	f0d2bcd0-0a46-4f7c-ae73-e8d00fc94609	1	cb20a7a1-e40f-4cb1-af07-8e5273dd0237	aa748f6a-602b-4346-b964-50cbcea76146	aa748f6a-602b-4346-b964-50cbcea76146	2024-02-27 18:45:00+00	2024-03-23 23:00:00+00	MC	\N
26c62f9b-1c02-4343-8ffc-87ca2df5bf27	b5dfface-103b-479b-8dd8-a582b2745c46	1	cb20a7a1-e40f-4cb1-af07-8e5273dd0237	f3d2726d-273b-4876-8181-2bad234708b5	f3d2726d-273b-4876-8181-2bad234708b5	2024-05-06 17:20:00+00	2024-06-26 04:30:00+00	MC	\N
c9c2be6d-69a0-43e3-a717-e82d5cbe5b42	402f10be-a827-46dc-8247-3551b2ca4a4e	1	cb20a7a1-e40f-4cb1-af07-8e5273dd0237	f3d2726d-273b-4876-8181-2bad234708b5	f3d2726d-273b-4876-8181-2bad234708b5	2024-07-04 02:35:00+00	2024-09-05 10:25:00+00	MC	\N
c219afdf-3e66-4fcc-aecd-75eb35fa7d04	e63e966e-1768-48c1-820b-7826b2a2676b	1	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2024-04-04 15:15:00+00	2024-05-15 10:05:00+00	MC	\N
41576eb4-2ba3-4436-9425-f5a234091dd2	d9478508-50ed-4116-976b-b1a9e52fea86	1	1985bde5-8964-4250-b775-74cc7469ed58	953117a0-3c04-4129-ab96-5eddf3a8d43a	953117a0-3c04-4129-ab96-5eddf3a8d43a	2024-06-06 20:00:00+00	2024-07-05 20:50:00+00	MC	\N
5a77b10f-4403-4efe-ae49-905c7de70ecc	b9bac716-fd70-45fd-b44d-1adaa80746fe	1	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2024-08-16 09:34:00+00	2024-10-05 12:23:00+00	MC	\N
556d68b6-5884-44a4-93fd-eedbba46bd66	e8ef9e23-7ac3-423c-bbe7-ef93e89eceba	1	127f273e-086c-4e23-bb9e-0557fc9270aa	953117a0-3c04-4129-ab96-5eddf3a8d43a	953117a0-3c04-4129-ab96-5eddf3a8d43a	2023-12-31 08:50:00+00	2024-01-23 05:55:00+00	MC	\N
7ed29826-e2a1-4982-9e3d-ed2c0df99b70	edef113f-2693-43d0-9361-76ae82180db7	1	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2024-03-06 10:00:00+00	2024-03-13 13:33:00+00	MC	\N
b3e9381d-a1d2-4a55-a7ed-c6d17d9954a0	d1442c54-7a29-4bdb-8a22-e4ce6284241f	1	83867dcf-3fe0-4b78-8470-aabe5c344bda	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2024-06-07 18:08:00+00	2024-07-21 16:45:00+00	MC	\N
6ce57503-9028-4103-ab46-a539c4066343	efe65554-104f-4323-8617-e16c61dc1235	1	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2024-09-05 08:50:00+00	2024-10-15 17:15:00+00	MC	\N
e9cc457d-70e2-4ea2-9332-9483b7e34f09	2a33f80b-90b3-4c89-940d-c089ae9d4c9c	1	127f273e-086c-4e23-bb9e-0557fc9270aa	953117a0-3c04-4129-ab96-5eddf3a8d43a	953117a0-3c04-4129-ab96-5eddf3a8d43a	2024-01-24 23:00:00+00	2024-02-12 10:25:00+00	MC	\N
d1cdf8ca-6b68-4d71-a6b2-9479761a6371	9d4e9e20-6b4d-4137-b195-ed203ad5200f	1	127f273e-086c-4e23-bb9e-0557fc9270aa	953117a0-3c04-4129-ab96-5eddf3a8d43a	953117a0-3c04-4129-ab96-5eddf3a8d43a	2024-02-13 19:36:00+00	2024-03-03 13:48:00+00	MC	\N
11172e8e-5216-486f-a92f-13200cbfe2a4	6ef79d64-f2ea-4c3e-9af7-8274f1167fea	1	127f273e-086c-4e23-bb9e-0557fc9270aa	953117a0-3c04-4129-ab96-5eddf3a8d43a	953117a0-3c04-4129-ab96-5eddf3a8d43a	2024-03-05 18:35:00+00	2024-04-03 20:35:00+00	MC	\N
b3cedccf-c984-4c5b-81da-2d1bd4cabeb3	c4318b2e-10f9-4598-af90-8424804d1aa8	1	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	\N	\N	2024-05-24 17:25:00+00	2024-06-01 08:39:00+00	MC	\N
09077af2-a0d9-41d8-98dd-8472c566731d	ab5bba2f-82ce-47eb-900a-6b0e8d8890a3	1	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	aa748f6a-602b-4346-b964-50cbcea76146	aa748f6a-602b-4346-b964-50cbcea76146	2024-06-18 13:30:00+00	2024-06-27 07:50:00+00	MC	\N
b60fcf0f-4dbc-4403-9464-4627e7c91dfe	9daed517-413a-4ccc-9fd7-633e46fd083b	1	83867dcf-3fe0-4b78-8470-aabe5c344bda	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2024-01-06 18:45:00+00	2024-02-13 21:55:00+00	MC	\N
f680480e-616c-4f42-8678-598c76477a9d	120d71ed-ee6f-4eaf-a6a2-7cef4b602200	1	83867dcf-3fe0-4b78-8470-aabe5c344bda	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2023-11-24 11:35:00+00	2024-01-03 20:20:00+00	MC	\N
97984868-2e30-4e6a-99b0-662205c2ad72	c20d247f-0aa3-452b-a539-21ab0cce4ac0	1	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2024-01-16 14:27:00+00	2024-01-27 19:06:00+00	MC	\N
48fea17d-324d-4bf7-a9b1-01ea0196e3db	b8f1db6f-fb63-4432-bdcb-0593563f069f	1	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2024-03-17 10:10:00+00	2024-03-26 14:27:00+00	MC	\N
196d09dd-0a5c-479d-b7a1-533ad2006fcc	51f28ec9-3f3c-4696-8e27-25a63c056114	1	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2024-05-23 18:50:00+00	2024-06-05 08:06:00+00	MC	\N
bc9ec424-3821-402e-aedd-6af360b073da	e2c4cbb3-e24d-4a93-93d4-4595f3cf43c4	1	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	953117a0-3c04-4129-ab96-5eddf3a8d43a	953117a0-3c04-4129-ab96-5eddf3a8d43a	2024-08-06 16:58:00+00	2024-08-20 12:45:00+00	MC	\N
7b1eac7c-de13-4221-a178-fc134567313b	262f3fb1-843d-41c9-8917-dac45f95cb07	1	351bae45-1535-472c-91c4-1a8a22bb3ff1	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2024-10-13 10:43:00+00	2024-10-20 10:33:00+00	MC	\N
10e3e20f-ab4f-447d-8cba-2899c5a91810	2c04ffd6-0715-4130-8432-a32caf9d27f5	1	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2024-11-16 12:51:00+00	2024-11-24 22:49:00+00	MC	\N
4a22f29e-6a2a-412b-a388-44a68bff5493	3ef54356-57c7-43b1-b8ee-c67bd097fe6d	1	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2024-03-19 19:32:00+00	2024-03-30 18:39:00+00	MC	\N
07f099c4-3b2d-4c14-aee2-95590f701d2c	9ca62b20-c29e-427c-9919-8712bd3dc653	5	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-08-22 17:12:00+00	2025-08-28 19:29:00+00	MC	\N
42ed1d66-5b2b-4acf-a133-b203f08792ba	9ca62b20-c29e-427c-9919-8712bd3dc653	4	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-08-14 19:05:00+00	2025-08-21 08:29:00+00	MC	\N
41fb66da-5aa3-41bd-a9b7-e8a2c16272bd	9ca62b20-c29e-427c-9919-8712bd3dc653	3	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-08-08 11:57:00+00	2025-08-13 19:12:00+00	MC	\N
306c1759-eb70-4669-9b47-bc406c694a31	9ca62b20-c29e-427c-9919-8712bd3dc653	2	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-07-31 11:45:00+00	2025-08-07 08:32:00+00	MC	\N
2a3fe0e1-7c4c-4ee6-a5d5-0b86c3e5ad2e	9ca62b20-c29e-427c-9919-8712bd3dc653	1	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-07-23 12:30:00+00	2025-07-30 09:25:00+00	MC	\N
c5b41424-ab6b-488c-9fac-9f142891b8c7	32535562-6f5e-4c93-9e3e-af9d09056343	2	13c3c551-df0d-4c62-a185-d36a0298672a	f3d2726d-273b-4876-8181-2bad234708b5	f3d2726d-273b-4876-8181-2bad234708b5	2025-04-16 14:10:00+00	2025-04-19 12:20:00+00	MC	\N
18e75bb0-9bae-4d8e-8a46-bd529875f67e	32535562-6f5e-4c93-9e3e-af9d09056343	1	13c3c551-df0d-4c62-a185-d36a0298672a	f3d2726d-273b-4876-8181-2bad234708b5	f3d2726d-273b-4876-8181-2bad234708b5	2025-03-13 08:00:00+00	2025-04-14 09:31:00+00	MC	\N
862e4fd8-0739-4579-9134-c724195aec27	62e43cbe-a312-4534-a620-7765d83f9ec9	1	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	\N	\N	2025-07-30 11:15:00+00	2025-08-04 09:25:00+00	MC	\N
ac1f84f2-0a29-4b8a-9ef6-efa7b51bf0b8	af818919-7f60-4f33-bb3d-f0446ab81506	3	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-08-16 10:37:00+00	2025-08-23 10:37:00+00	MC	\N
8f976c96-48ba-4c3a-8f30-3a01d35d2104	af818919-7f60-4f33-bb3d-f0446ab81506	2	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-08-06 18:52:00+00	2025-08-14 06:11:00+00	MC	\N
b9766162-1b71-47ef-8a52-13ad196fbfae	af818919-7f60-4f33-bb3d-f0446ab81506	1	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-07-28 16:00:00+00	2025-08-03 11:05:00+00	MC	\N
47433e82-6399-4b4f-a9ad-844f74b37950	103842ed-863c-43ce-900b-728c937c607b	3	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	\N	\N	2025-08-28 00:41:00+00	2025-09-05 11:50:00+00	MC	\N
6452c53f-8486-4f12-bc60-2ac80f8ff091	103842ed-863c-43ce-900b-728c937c607b	2	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	\N	\N	2025-08-15 12:55:00+00	2025-08-26 22:45:00+00	MC	\N
2e6a6f49-e53f-46ba-bfbd-5492383d722c	103842ed-863c-43ce-900b-728c937c607b	1	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	\N	\N	2025-08-04 21:10:00+00	2025-08-14 07:33:00+00	MC	\N
fd15401a-f5dd-4e71-a393-ae9e5ffce09e	961b3624-a638-423f-843d-64b222441e1b	2	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	f3d2726d-273b-4876-8181-2bad234708b5	f3d2726d-273b-4876-8181-2bad234708b5	2025-06-05 00:13:00+00	2025-06-11 01:15:00+00	MC	\N
553e618a-bc7e-434c-a290-d889ba454d0d	961b3624-a638-423f-843d-64b222441e1b	1	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	f3d2726d-273b-4876-8181-2bad234708b5	f3d2726d-273b-4876-8181-2bad234708b5	2025-05-26 17:21:00+00	2025-06-03 23:45:00+00	MC	\N
7d2b5e7e-3e2c-47c5-b7a3-7dd4a66955c3	083c465b-795f-4879-8bcd-995012b7ac84	2	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	f3d2726d-273b-4876-8181-2bad234708b5	f3d2726d-273b-4876-8181-2bad234708b5	2025-06-28 15:25:00+00	2025-07-10 17:49:00+00	MC	\N
42815ca9-8fbf-4e72-afc4-3d21eb25f8f1	083c465b-795f-4879-8bcd-995012b7ac84	1	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	f3d2726d-273b-4876-8181-2bad234708b5	f3d2726d-273b-4876-8181-2bad234708b5	2025-06-17 18:22:00+00	2025-06-28 07:11:00+00	MC	\N
45f54ea8-71c1-4986-889e-f807f98f158c	096a05bc-0667-41e0-b7e7-d1f055055304	1	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	\N	\N	2025-08-05 12:41:00+00	2025-08-13 19:20:00+00	MC	\N
59daf149-a1fc-406e-bced-c418c942f9c2	3306220d-f1bb-447d-8aed-296a365bb403	3	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-07-27 14:00:00+00	2025-08-01 14:59:00+00	MC	\N
ad42fc84-4695-4739-af54-c78ac8366d4b	3306220d-f1bb-447d-8aed-296a365bb403	2	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-07-18 10:00:00+00	2025-07-23 14:35:00+00	MC	\N
24e53fad-9580-45fa-bb0b-647032a2fd23	3306220d-f1bb-447d-8aed-296a365bb403	1	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-07-12 09:51:00+00	2025-07-14 14:17:00+00	MC	\N
31febfb9-30b3-4341-b5fb-8fbe32fd4d55	3dfefa7b-819d-416e-af81-f5222293a93a	2	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	aa748f6a-602b-4346-b964-50cbcea76146	aa748f6a-602b-4346-b964-50cbcea76146	2025-08-14 17:15:00+00	2025-08-22 11:50:00+00	MC	\N
708e6c1a-33a3-496c-ab7e-90f4ae4a68fa	3dfefa7b-819d-416e-af81-f5222293a93a	1	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	aa748f6a-602b-4346-b964-50cbcea76146	aa748f6a-602b-4346-b964-50cbcea76146	2025-08-05 14:33:00+00	2025-08-13 16:05:00+00	MC	\N
ae867570-0459-4afa-8f71-ea3f887ba65c	40121aee-6473-49e1-91a2-c90ff9cc9196	3	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-01-31 18:49:00+00	2025-02-11 11:40:00+00	MC	\N
06e76e5b-6264-49f9-8338-b0af07ea1904	40121aee-6473-49e1-91a2-c90ff9cc9196	2	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-01-22 11:56:00+00	2025-01-29 21:50:00+00	MC	\N
d08cefe3-a283-4391-b022-83066b39742b	40121aee-6473-49e1-91a2-c90ff9cc9196	1	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-01-11 11:45:00+00	2025-01-19 07:50:00+00	MC	\N
7cc2222a-3566-4b53-9941-c83b835abc6b	c07c571b-64ea-4e1d-923e-a247e33977cd	3	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-05-14 08:52:00+00	2025-05-26 14:14:00+00	MC	\N
4a3c4d0a-9658-44fd-8fc9-1d8c38a482df	c07c571b-64ea-4e1d-923e-a247e33977cd	2	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-05-02 13:00:00+00	2025-05-10 17:40:00+00	MC	\N
6f66ac47-a50f-438e-9b59-76bbc09c934c	c07c571b-64ea-4e1d-923e-a247e33977cd	1	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-04-21 14:15:00+00	2025-04-29 16:36:00+00	MC	\N
3f110528-a000-4daf-8e50-4dacce1c6c89	0a0a9aed-1beb-4024-b4c4-9f1a0f46b573	2	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-05-14 12:35:00+00	2025-05-25 15:35:00+00	MC	\N
d3009c53-62c3-4f5d-9bbe-fa6d02318582	0a0a9aed-1beb-4024-b4c4-9f1a0f46b573	1	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-05-02 14:40:00+00	2025-05-09 09:45:00+00	MC	\N
53805aec-8faf-42c9-be9d-318aa82666f2	ef527485-da69-42d4-951e-798b20ee9af8	4	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-07-28 16:17:00+00	2025-08-04 08:33:00+00	MC	\N
cbfa57b2-e8c0-435f-b313-47af7bbb1f12	ef527485-da69-42d4-951e-798b20ee9af8	3	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-07-20 10:35:00+00	2025-07-26 10:40:00+00	MC	\N
e8c80a19-a2ee-44b5-a9b0-677e7c2ffeb9	ef527485-da69-42d4-951e-798b20ee9af8	2	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-07-05 12:44:00+00	2025-07-11 10:25:00+00	MC	\N
109a8158-8112-4814-9560-788a3d13f2a0	ef527485-da69-42d4-951e-798b20ee9af8	1	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-06-25 12:30:00+00	2025-07-03 17:16:00+00	MC	\N
d84c4d4a-f46e-43fe-817e-4b0ac63b6190	3a433221-8591-4f3b-8cef-31084e1f828c	1	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-06-05 17:40:00+00	2025-07-06 07:53:00+00	MC	\N
315f18f6-8095-4c32-bf71-87471dfd1a33	555b4f0e-c83e-44b1-a5de-c379cfde7d14	1	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-08-20 12:58:00+00	2025-08-30 07:00:00+00	MC	\N
5d3902e6-b65f-4015-9a1a-4a117f97637a	b57e72de-3e87-4a74-9a05-b100c3bec284	1	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-08-23 12:00:00+00	2025-09-22 13:34:00+00	MC	\N
c5701b9e-fad6-41f9-8b5b-cd13498aec88	07e6845b-64e4-454d-b71a-c8c6faa56252	1	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-08-03 18:40:00+00	2025-08-07 15:49:00+00	MC	\N
f4e36744-f768-4b64-b8f8-264b8dab7718	07e6845b-64e4-454d-b71a-c8c6faa56252	5	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-08-18 14:44:00+00	2025-08-22 10:25:00+00	MC	\N
e6ee4475-ff53-483e-9e5f-06ca42825299	07e6845b-64e4-454d-b71a-c8c6faa56252	4	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-08-15 14:52:00+00	2025-08-18 02:05:00+00	MC	\N
e66e1135-c9d4-4db5-87c0-6fb8ca61cb48	07e6845b-64e4-454d-b71a-c8c6faa56252	3	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-08-12 16:40:00+00	2025-08-15 03:25:00+00	MC	\N
4e80bd4f-af53-4d01-baed-72741620262b	07e6845b-64e4-454d-b71a-c8c6faa56252	2	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-08-08 11:28:00+00	2025-08-12 05:02:00+00	MC	\N
283c0dd5-ecc5-4651-bb8a-0396654e1cfa	7c7e2bdb-377b-4a46-a30b-66b50374ec9d	1	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-08-30 10:49:00+00	2025-08-30 16:01:00+00	MC	\N
3e290ce3-0d09-49aa-b014-4536f5cee2a6	89f84f11-855d-4ce0-a05e-dd4d879e51d5	1	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-08-30 17:07:00+00	2025-10-06 19:53:00+00	MC	\N
bde39d00-f468-434e-9624-078d04df6e81	eb02571d-39b4-4e07-a678-133a60a00726	3	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	\N	\N	2025-09-26 17:15:00+00	2025-10-08 08:15:00+00	MC	\N
d0cdbd6f-97ad-480b-a4f7-097de9589155	eb02571d-39b4-4e07-a678-133a60a00726	2	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	\N	\N	2025-09-13 20:25:00+00	2025-09-25 16:00:00+00	MC	\N
069c2b1a-0f0c-4400-9b7e-64b1f6737b03	eb02571d-39b4-4e07-a678-133a60a00726	1	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	\N	\N	2025-09-01 20:30:00+00	2025-09-12 14:10:00+00	MC	\N
05a80dc5-6f5b-45ee-9e36-5dbef01eea00	e2654362-e9f9-4bfe-adc5-f35f3dba5cd5	7	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-08-16 09:25:00+00	2025-08-20 09:55:00+00	MC	\N
28100d2a-4216-44b2-b281-5408e48bf114	e2654362-e9f9-4bfe-adc5-f35f3dba5cd5	6	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-08-12 20:25:00+00	2025-08-15 05:50:00+00	MC	\N
4177824f-ce0c-43d9-8ba5-008e810ae9e2	e2654362-e9f9-4bfe-adc5-f35f3dba5cd5	5	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-08-08 14:30:00+00	2025-08-12 04:43:00+00	MC	\N
dad3dcef-312c-4eb6-813a-8488afb5e882	e2654362-e9f9-4bfe-adc5-f35f3dba5cd5	4	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-08-03 18:33:00+00	2025-08-07 15:44:00+00	MC	\N
26f331e5-6a3c-438e-876d-78fc24de83b0	e2654362-e9f9-4bfe-adc5-f35f3dba5cd5	3	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-07-30 08:58:00+00	2025-08-03 05:25:00+00	MC	\N
23dc615d-c6e1-471c-b233-ebdad3a62363	e2654362-e9f9-4bfe-adc5-f35f3dba5cd5	2	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-07-25 18:12:00+00	2025-07-29 11:35:00+00	MC	\N
15572653-4178-4391-ada5-c36c30b1a030	e2654362-e9f9-4bfe-adc5-f35f3dba5cd5	1	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-07-25 17:15:00+00	2025-07-25 17:25:00+00	MC	\N
503ae38a-a817-4361-bcc8-49a45dbe6c05	e2654362-e9f9-4bfe-adc5-f35f3dba5cd5	8	1985bde5-8964-4250-b775-74cc7469ed58	953117a0-3c04-4129-ab96-5eddf3a8d43a	953117a0-3c04-4129-ab96-5eddf3a8d43a	2025-08-21 03:00:00+00	2025-08-24 03:00:00+00	MC	\N
91d85f39-7f90-4b42-b12d-13290c5d75fb	b9c4964e-3892-48ca-83b5-33887d833744	3	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	\N	\N	2025-08-20 17:20:00+00	2025-09-01 12:18:00+00	MC	\N
e96d0ade-0133-429e-810d-d247d803cd4b	b9c4964e-3892-48ca-83b5-33887d833744	2	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	\N	\N	2025-09-03 09:50:00+00	2025-09-22 12:15:00+00	MC	\N
8ade11bb-97eb-4e4a-b961-691bf26f28db	b9c4964e-3892-48ca-83b5-33887d833744	1	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	\N	\N	2025-08-08 15:34:00+00	2025-08-19 16:01:00+00	MC	\N
f7c24d1a-5abf-4aa7-b947-8c6d768f1dd2	fc9e057a-a06b-426f-bf4a-ef4a1f3ea33e	4	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-09-08 17:45:00+00	2025-09-16 09:29:00+00	MC	\N
502cd3e2-9276-4cd9-827f-2abdc3b39310	fc9e057a-a06b-426f-bf4a-ef4a1f3ea33e	3	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-08-29 11:36:00+00	2025-09-05 13:36:00+00	MC	\N
abd0d9c1-6b34-4ae4-b1b7-43696bdd63ad	fc9e057a-a06b-426f-bf4a-ef4a1f3ea33e	2	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-08-20 15:26:00+00	2025-08-27 09:00:00+00	MC	\N
87d955cf-5f3a-44a4-983a-64e46b026eea	fc9e057a-a06b-426f-bf4a-ef4a1f3ea33e	1	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-08-07 12:50:00+00	2025-08-14 05:38:00+00	MC	\N
3c11f36f-8f8e-4af6-9b04-04a4b1814166	10c022c0-8e4e-4591-bd67-e2c700a0b734	4	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-09-13 17:47:00+00	2025-09-23 04:49:00+00	MC	\N
3f323b20-6d39-4a02-80c6-fbdb23561f01	10c022c0-8e4e-4591-bd67-e2c700a0b734	3	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-09-09 15:00:00+00	2025-09-09 18:40:00+00	MC	\N
bcda246e-852e-4f08-9473-b9f89991c74d	10c022c0-8e4e-4591-bd67-e2c700a0b734	2	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-08-26 19:51:00+00	2025-09-05 06:11:00+00	MC	\N
78e3ecf2-8668-4297-81a6-2c1f76687e12	10c022c0-8e4e-4591-bd67-e2c700a0b734	1	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-08-14 17:45:00+00	2025-08-22 19:10:00+00	MC	\N
ff76e1d1-02e0-4448-b915-23ec8e94814a	4b414822-7ad3-47b7-8221-d7150a666d05	1	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-09-11 09:33:00+00	2025-10-18 06:53:00+00	MC	\N
fe59a92d-e8ff-4bb6-8cae-a1fec7a30525	5cce0b2b-7598-46a2-b04a-0fb6febbdcbd	2	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	\N	\N	2025-09-23 18:15:00+00	2025-10-12 10:20:00+00	MC	\N
cec79bf1-5bdf-4e48-8ed1-f0babc76592e	5cce0b2b-7598-46a2-b04a-0fb6febbdcbd	1	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	\N	\N	2025-09-13 18:00:00+00	2025-09-22 15:30:00+00	MC	\N
1f4e26de-8c7c-4dcb-9cfe-d4fc5b38fc2a	9713ce47-d321-4be6-9cd9-bdd14b46cc4c	1	cb20a7a1-e40f-4cb1-af07-8e5273dd0237	792484d9-dc51-4a9d-b9a5-d28c9047bcf0	792484d9-dc51-4a9d-b9a5-d28c9047bcf0	2025-09-17 16:55:00+00	2025-11-17 20:50:00+00	MC	\N
1103f337-a1dd-44e3-9018-25d6a66f0214	a79d2260-26ca-432a-8ed9-740f67ea76de	2	13c3c551-df0d-4c62-a185-d36a0298672a	f3d2726d-273b-4876-8181-2bad234708b5	f3d2726d-273b-4876-8181-2bad234708b5	2025-10-17 10:30:00+00	2025-11-06 07:50:00+00	MC	\N
01aa16a7-9733-45da-adfa-d3021b409f90	75ac6df5-7e24-4b50-895f-97dc0a066b08	2	cb20a7a1-e40f-4cb1-af07-8e5273dd0237	aa748f6a-602b-4346-b964-50cbcea76146	aa748f6a-602b-4346-b964-50cbcea76146	2025-10-22 19:30:00+00	2025-11-01 16:20:00+00	MC	\N
f6b9d9e6-45de-4879-8dbd-cd4e13b49df8	75ac6df5-7e24-4b50-895f-97dc0a066b08	1	cb20a7a1-e40f-4cb1-af07-8e5273dd0237	aa748f6a-602b-4346-b964-50cbcea76146	aa748f6a-602b-4346-b964-50cbcea76146	2025-09-30 15:15:00+00	2025-10-19 19:35:00+00	MC	\N
dfc0634f-65b3-4d52-b855-a21012432867	76acf2e6-dc4c-477b-811f-9bac3abeeb35	1	83867dcf-3fe0-4b78-8470-aabe5c344bda	\N	\N	2025-10-27 16:46:00+00	2025-12-07 09:47:00+00	MC	\N
2c3501e7-a18d-41e5-a866-cdfe81ffb442	f00ea4ef-0c6c-4c64-bb5a-d4488f445bde	1	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-11-01 16:32:00+00	2025-11-12 08:22:00+00	MC	\N
5f0c5eca-c943-48bd-bd30-4c61ab92e4ef	1ccf9f45-796c-4b1f-a5bd-4b7fa3b0b41b	1	3750f533-77c8-405f-8a00-bf0ba0353a4d	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-11-04 20:21:00+00	2025-11-11 06:35:00+00	MC	\N
76f14166-dfe6-4038-a9fd-703bb6fc73ad	ee86dfed-f026-4771-ba14-74524f130003	4	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-12-03 19:20:00+00	2025-12-11 15:30:00+00	MC	\N
cafa3d18-00ef-4311-b644-7929113911ab	ee86dfed-f026-4771-ba14-74524f130003	3	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-11-23 12:45:00+00	2025-12-01 16:12:00+00	MC	\N
a36dbd33-bde1-4b7f-89ca-b11ca1750ae9	ee86dfed-f026-4771-ba14-74524f130003	2	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-11-14 13:44:00+00	2025-11-21 13:31:00+00	MC	\N
65ce71cd-1c5c-46ba-8f46-1d6549e9bf02	ee86dfed-f026-4771-ba14-74524f130003	1	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-11-03 20:30:00+00	2025-11-12 02:10:00+00	MC	\N
d976acf5-51dd-41d3-ac14-3e923da1729f	cc47ae74-fcf9-4ae5-b89f-8bba2cff094b	3	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-11-03 12:10:00+00	2025-11-08 20:15:00+00	MC	\N
f147d353-5acb-487b-9686-a376159c6452	cc47ae74-fcf9-4ae5-b89f-8bba2cff094b	2	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-10-24 19:42:00+00	2025-10-29 14:00:00+00	MC	\N
b17f882a-8fef-4afb-9497-9101b087f5b6	cc47ae74-fcf9-4ae5-b89f-8bba2cff094b	1	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-10-19 11:02:00+00	2025-10-23 19:27:00+00	MC	\N
68b796a9-37c0-4e05-9913-d07b51f6215c	8169f516-50a4-4345-b7a6-30502d36ec64	6	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-11-01 23:40:00+00	2025-11-07 15:40:00+00	MC	\N
1945e68c-6b7a-4473-8443-0c5f55b56117	8169f516-50a4-4345-b7a6-30502d36ec64	5	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-10-26 23:50:00+00	2025-11-01 00:15:00+00	MC	\N
94fa1ba7-6599-4d70-9424-ba245196cd7a	8169f516-50a4-4345-b7a6-30502d36ec64	4	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-10-20 06:22:00+00	2025-10-24 19:43:00+00	MC	\N
916d4ce6-34f6-4879-beb1-7a5a76057a95	8169f516-50a4-4345-b7a6-30502d36ec64	3	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-10-14 12:55:00+00	2025-10-18 07:24:00+00	MC	\N
50713426-ddbc-487a-883b-5b620a9d7e2b	8169f516-50a4-4345-b7a6-30502d36ec64	2	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-10-07 19:50:00+00	2025-10-12 09:18:00+00	MC	\N
9668f6b1-73be-45e9-a226-cef311235495	8169f516-50a4-4345-b7a6-30502d36ec64	1	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-09-30 20:58:00+00	2025-10-05 21:00:00+00	MC	\N
edf87f0c-041d-4b8c-9c49-c714a7b945ee	6bec345b-7a6b-436c-bfcc-6448a2a72928	1	13c3c551-df0d-4c62-a185-d36a0298672a	f3d2726d-273b-4876-8181-2bad234708b5	f3d2726d-273b-4876-8181-2bad234708b5	2025-09-13 19:00:00+00	2025-10-01 00:00:00+00	MC	\N
587ea398-e46f-4f37-af8e-aa16f608e85c	dda05ff7-1cf0-444c-b1a2-0e317fef64be	2	83867dcf-3fe0-4b78-8470-aabe5c344bda	\N	\N	2025-09-22 19:33:00+00	2025-10-20 18:20:00+00	MC	\N
2a50d126-2865-421d-aed2-7b71362a30b7	dda05ff7-1cf0-444c-b1a2-0e317fef64be	1	83867dcf-3fe0-4b78-8470-aabe5c344bda	\N	\N	2025-09-10 23:05:00+00	2025-09-22 09:53:00+00	MC	\N
6f9b3d0e-83c3-4428-b053-26b81535c94d	b6cfb478-75d9-49ba-b170-18c94c80e46e	1	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	\N	\N	2025-08-26 00:00:00+00	2025-09-07 00:00:00+00	MC	\N
726fefed-5829-46b9-81a6-a7fd0108635b	1bcb4ace-f305-411d-89fd-275511c4289e	2	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-09-03 20:02:00+00	2025-09-19 09:35:00+00	MC	\N
d31aaaa1-b7f3-4668-a8b9-9fd59019a883	1bcb4ace-f305-411d-89fd-275511c4289e	1	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-08-21 19:40:00+00	2025-09-02 16:30:00+00	MC	\N
6ec2fb8d-c56a-41d4-8177-8e056c86be46	6be05dc6-fa9d-4498-937b-b55a632be4ee	3	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-09-08 20:10:00+00	2025-09-18 13:08:00+00	MC	\N
a7258095-bf95-48f6-b5b8-e00959e7e449	6be05dc6-fa9d-4498-937b-b55a632be4ee	2	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-08-28 14:37:00+00	2025-09-06 17:07:00+00	MC	\N
f4d823a2-2274-440d-99a3-e12f61579c24	6be05dc6-fa9d-4498-937b-b55a632be4ee	1	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-08-17 13:50:00+00	2025-08-25 07:47:00+00	MC	\N
9eab90e3-3fb4-4126-9a03-36bf7adc433a	797967f5-0771-4c14-b776-a8d3b8dcc807	3	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-09-04 17:50:00+00	2025-09-21 08:50:00+00	MC	\N
0bd0547e-4877-4452-a311-79e3fc1a106e	797967f5-0771-4c14-b776-a8d3b8dcc807	2	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-08-21 18:05:00+00	2025-09-03 05:30:00+00	MC	\N
a13eedf4-8bb1-4473-ab29-8d30bb9c9ea5	797967f5-0771-4c14-b776-a8d3b8dcc807	1	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-08-08 13:53:00+00	2025-08-20 07:22:00+00	MC	\N
2bf96e0c-1ba8-4833-848b-d4b1e1cacd83	f06c8a0b-03d2-4af3-9393-37c1e9aad51c	4	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	\N	\N	2025-09-08 20:20:00+00	2025-09-25 10:34:00+00	MC	\N
1334268e-0262-472c-9ed7-4f287b304b01	f06c8a0b-03d2-4af3-9393-37c1e9aad51c	3	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	\N	\N	2025-08-25 19:00:00+00	2025-09-07 08:45:00+00	MC	\N
f1aab0a1-d2e1-494d-98b3-c9a007f379b4	f06c8a0b-03d2-4af3-9393-37c1e9aad51c	2	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	\N	\N	2025-08-11 22:53:00+00	2025-08-24 07:16:00+00	MC	\N
b0c815ed-ea52-44ef-8af1-8811546f62f0	f06c8a0b-03d2-4af3-9393-37c1e9aad51c	1	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	\N	\N	2025-07-23 20:10:00+00	2025-08-09 23:30:00+00	MC	\N
616ffea8-f687-4bd8-a0d5-a9a30f733ebf	cd6833f3-26c4-48cb-a309-97923e607819	4	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-02-03 14:51:00+00	2025-02-12 14:07:00+00	MC	\N
cf45645c-37af-44b6-bc57-6071824a75f0	cd6833f3-26c4-48cb-a309-97923e607819	3	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-01-28 17:30:00+00	2025-02-02 23:37:00+00	MC	\N
05152255-dcfc-41a2-baa3-f8090c437918	cd6833f3-26c4-48cb-a309-97923e607819	2	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-01-20 19:07:00+00	2025-01-26 19:05:00+00	MC	\N
27c0bfbc-900a-43a3-839e-65e106ebe985	cd6833f3-26c4-48cb-a309-97923e607819	1	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-01-12 20:59:00+00	2025-01-19 14:35:00+00	MC	\N
46c90385-18e2-4faa-88b6-b89d03a96b96	4f4c8356-a77a-4fe5-9d94-4fc503d4dd2f	3	13c3c551-df0d-4c62-a185-d36a0298672a	f3d2726d-273b-4876-8181-2bad234708b5	f3d2726d-273b-4876-8181-2bad234708b5	2025-11-14 15:40:00+00	2025-12-05 06:24:00+00	MC	\N
09c77720-e2c2-48d8-b246-588a0ddc7cc9	4f4c8356-a77a-4fe5-9d94-4fc503d4dd2f	2	13c3c551-df0d-4c62-a185-d36a0298672a	f3d2726d-273b-4876-8181-2bad234708b5	f3d2726d-273b-4876-8181-2bad234708b5	2025-10-16 19:51:00+00	2025-11-12 21:40:00+00	MC	\N
9851cb06-d9b1-4c53-bc2d-37d42e203b16	4f4c8356-a77a-4fe5-9d94-4fc503d4dd2f	1	13c3c551-df0d-4c62-a185-d36a0298672a	f3d2726d-273b-4876-8181-2bad234708b5	f3d2726d-273b-4876-8181-2bad234708b5	2025-10-12 01:35:00+00	2025-10-14 19:05:00+00	MC	\N
a45cf723-1923-447b-b7a1-8ce7ffb67661	1c4df91d-ef85-4e6b-82f0-903f1f436093	2	cb20a7a1-e40f-4cb1-af07-8e5273dd0237	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-10-05 21:16:00+00	2025-10-29 03:30:00+00	MC	\N
0d07e849-9246-4ee2-9b70-f0e0ee6eae89	1c4df91d-ef85-4e6b-82f0-903f1f436093	1	cb20a7a1-e40f-4cb1-af07-8e5273dd0237	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-09-29 22:30:00+00	2025-10-03 01:53:00+00	MC	\N
efda6bd0-56b7-488a-92f0-ee87048e21d9	7afcf1c4-8e13-4db8-96e7-2840b865a386	2	13c3c551-df0d-4c62-a185-d36a0298672a	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-10-13 21:15:00+00	2025-11-08 07:50:00+00	MC	\N
72734c14-3e54-4900-ab8a-bacba4cea6d3	59e197e9-2351-425b-bfbb-b426a7a9778f	3	13c3c551-df0d-4c62-a185-d36a0298672a	f3d2726d-273b-4876-8181-2bad234708b5	f3d2726d-273b-4876-8181-2bad234708b5	2025-11-05 23:13:00+00	2025-12-04 11:51:00+00	MC	\N
6832093e-a944-486c-9394-9f03b8123080	59e197e9-2351-425b-bfbb-b426a7a9778f	2	13c3c551-df0d-4c62-a185-d36a0298672a	f3d2726d-273b-4876-8181-2bad234708b5	f3d2726d-273b-4876-8181-2bad234708b5	2025-10-14 16:17:00+00	2025-11-02 02:25:00+00	MC	\N
51dbbc58-d436-4c65-ac98-a3608cc10a2b	bd74cbb2-d9fa-4488-8f5a-9028c8228439	1	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-10-14 18:50:00+00	2025-11-23 08:22:00+00	MC	\N
b186f514-73db-4018-95b5-6c0f630c3916	e60f8e79-f5fb-4de4-990c-15e85fc61682	4	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-11-30 11:19:00+00	2025-12-06 19:45:00+00	MC	\N
d8e741f6-176c-4c83-82db-a0ee401d2b9c	e60f8e79-f5fb-4de4-990c-15e85fc61682	3	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-11-22 11:28:00+00	2025-11-27 21:06:00+00	MC	\N
be553200-f384-449b-bd98-61a585fbc735	e60f8e79-f5fb-4de4-990c-15e85fc61682	2	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-11-14 12:40:00+00	2025-11-18 21:54:00+00	MC	\N
3e9cc60b-351f-4925-bb65-d55e158a5576	e60f8e79-f5fb-4de4-990c-15e85fc61682	1	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-11-04 00:00:00+00	2025-11-12 09:25:00+00	MC	\N
6f19f46a-b9fe-4892-b42e-0909ac8666d1	f3defc2c-0329-4dce-b377-73ea790aa984	7	13c3c551-df0d-4c62-a185-d36a0298672a	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-02-12 22:56:00+00	2025-02-15 00:35:00+00	MC	\N
0fde1aec-da5b-44d4-9246-c96337ba5f83	f3defc2c-0329-4dce-b377-73ea790aa984	6	13c3c551-df0d-4c62-a185-d36a0298672a	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-02-02 13:35:00+00	2025-02-05 06:00:00+00	MC	\N
687e44f5-b9e2-4775-a0b7-bc0be1ffa513	f3defc2c-0329-4dce-b377-73ea790aa984	5	13c3c551-df0d-4c62-a185-d36a0298672a	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-01-17 14:40:00+00	2025-01-19 14:18:00+00	MC	\N
17ac6ca1-4307-4920-b519-0b1d7bc83c66	f3defc2c-0329-4dce-b377-73ea790aa984	4	13c3c551-df0d-4c62-a185-d36a0298672a	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-01-17 00:12:00+00	2025-01-17 12:48:00+00	MC	\N
36f7bf70-e046-43eb-8d86-5a167daf1883	f3defc2c-0329-4dce-b377-73ea790aa984	3	13c3c551-df0d-4c62-a185-d36a0298672a	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-01-15 14:25:00+00	2025-01-16 12:12:00+00	MC	\N
aeac0f66-f565-48e9-8e2e-85939ea40600	f3defc2c-0329-4dce-b377-73ea790aa984	2	13c3c551-df0d-4c62-a185-d36a0298672a	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-01-14 09:52:00+00	2025-01-15 00:06:00+00	MC	\N
f92d563d-c367-408b-9c6f-1f81d22dfef5	f3defc2c-0329-4dce-b377-73ea790aa984	1	13c3c551-df0d-4c62-a185-d36a0298672a	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-01-11 07:45:00+00	2025-01-11 21:06:00+00	MC	\N
fca1102d-a160-4863-bc82-1ced5cdf86a5	980e2222-7add-4d66-a760-18d57de0f8c6	2	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-12-09 13:01:00+00	2025-12-13 07:05:00+00	MC	\N
2ddce7b6-086f-49ca-adac-b88d118f06c3	980e2222-7add-4d66-a760-18d57de0f8c6	1	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-12-02 20:03:00+00	2025-12-06 21:05:00+00	MC	\N
19fc6f09-1ef9-4e7c-a4f6-10ce4bd84f62	8a58a426-eff9-4e1a-8d8d-4e53ffa5bff9	1	cb20a7a1-e40f-4cb1-af07-8e5273dd0237	f3d2726d-273b-4876-8181-2bad234708b5	f3d2726d-273b-4876-8181-2bad234708b5	2024-12-27 23:50:00+00	2025-02-17 04:35:00+00	MC	\N
a0126400-aa16-4d22-927a-ba5ce86d1e93	0f54a12f-e40c-4a1c-aa90-0ffc1f27ed36	1	cb20a7a1-e40f-4cb1-af07-8e5273dd0237	f3d2726d-273b-4876-8181-2bad234708b5	f3d2726d-273b-4876-8181-2bad234708b5	2024-12-12 16:15:00+00	2025-01-02 00:00:00+00	MC	\N
e0622b2c-44c0-4a97-9836-16fefc5a7831	e2c05b14-ff8e-420a-9da2-7433d0cfca64	1	127f273e-086c-4e23-bb9e-0557fc9270aa	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-12-29 16:26:00+00	\N	MC	\N
9e6ec04f-3896-447e-8998-85ae7da53381	d475ea64-c7f6-426e-960f-b42eb00a2482	1	127f273e-086c-4e23-bb9e-0557fc9270aa	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-12-29 17:15:00+00	\N	MC	\N
cb726276-0404-48eb-b4c2-779184f03a04	31d0887c-0bd7-4020-b987-1df21da96751	2	13c3c551-df0d-4c62-a185-d36a0298672a	aa748f6a-602b-4346-b964-50cbcea76146	aa748f6a-602b-4346-b964-50cbcea76146	2025-10-31 03:00:00+00	2025-11-13 03:00:00+00	MC	\N
cfcde469-422e-4937-8835-c521ae1bf6a3	31d0887c-0bd7-4020-b987-1df21da96751	3	13c3c551-df0d-4c62-a185-d36a0298672a	aa748f6a-602b-4346-b964-50cbcea76146	aa748f6a-602b-4346-b964-50cbcea76146	2025-11-19 03:00:00+00	2025-12-19 03:00:00+00	MC	\N
08c98842-e712-47e4-89af-963d1f56ebf1	31d0887c-0bd7-4020-b987-1df21da96751	1	13c3c551-df0d-4c62-a185-d36a0298672a	aa748f6a-602b-4346-b964-50cbcea76146	aa748f6a-602b-4346-b964-50cbcea76146	2025-10-14 15:40:00+00	2025-10-30 07:30:00+00	MC	\N
fe3f2c7f-c6a8-4073-b2bd-036afa46e169	eafcf984-b27a-42e2-bc66-3e5327ce9556	1	83867dcf-3fe0-4b78-8470-aabe5c344bda	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2024-10-04 17:24:00+00	2024-10-20 08:31:00+00	MC	\N
f44a1daa-b48f-4113-a3df-deb6b76edb2e	1b489224-3e5c-4ad6-9687-020e4d013a27	1	83867dcf-3fe0-4b78-8470-aabe5c344bda	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2024-10-04 20:45:00+00	2024-11-13 08:14:00+00	MC	\N
3b961286-6d92-47e7-9547-42c45d9ad475	62352c42-cc04-4af7-88b9-c0f13d39e859	1	83867dcf-3fe0-4b78-8470-aabe5c344bda	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2026-01-09 10:32:00+00	\N	MC	\N
2fcfaee6-2ad4-48e3-8612-f3098f5efaec	f86c05c6-0fe3-4d30-846e-f510a804f1dd	1	83867dcf-3fe0-4b78-8470-aabe5c344bda	\N	\N	2024-10-15 19:25:00+00	2024-11-02 18:30:00+00	MC	\N
96f23466-cea8-45d9-80bd-c40a396c9767	fe404f4e-e2c5-4fd8-9895-2dce4943cdd0	1	cb20a7a1-e40f-4cb1-af07-8e5273dd0237	f3d2726d-273b-4876-8181-2bad234708b5	f3d2726d-273b-4876-8181-2bad234708b5	2024-09-18 14:45:00+00	2024-10-30 19:05:00+00	MC	\N
0e43806a-71b0-4506-86e3-b833fbd38377	89039635-7283-41b5-a759-7091a984f4fa	1	83867dcf-3fe0-4b78-8470-aabe5c344bda	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2024-10-19 07:00:00+00	2024-11-25 14:15:00+00	MC	\N
9ef5d3d6-6b95-4693-8dc1-c2c59a3f80b9	f2bd35f9-f2b3-4142-8ee9-f309b78a44b8	1	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-01-01 06:46:00+00	2024-10-13 23:39:00+00	MC	\N
46cba253-9801-4861-98f3-c8ab2a98c97e	40aef3ca-6766-4d63-a9f5-10ae792eabc4	1	cb20a7a1-e40f-4cb1-af07-8e5273dd0237	792484d9-dc51-4a9d-b9a5-d28c9047bcf0	792484d9-dc51-4a9d-b9a5-d28c9047bcf0	2024-10-10 21:45:00+00	2024-12-03 05:45:00+00	MC	\N
6975d6ae-a1ae-44dc-bf1d-79dd316cf99b	5a135385-e24c-47b3-ab02-df8bb56422db	2	13c3c551-df0d-4c62-a185-d36a0298672a	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-12-18 00:00:00+00	2025-12-24 06:11:00+00	MC	\N
dda572c9-dd61-4f4b-b0a3-daa1da3670e7	5a135385-e24c-47b3-ab02-df8bb56422db	1	13c3c551-df0d-4c62-a185-d36a0298672a	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-11-12 14:03:00+00	2025-12-16 00:00:00+00	MC	\N
4118a8bd-d41e-4bda-9cd6-b8c723d0d298	4900b0ef-f70d-4825-97e6-1b111f6a8f72	1	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-09-20 15:40:00+00	2025-10-07 06:28:00+00	MC	\N
1367a57c-3aeb-4244-a69f-fd3393fa251b	d7ffdde0-c397-4c6e-90da-071048d351f9	1	83867dcf-3fe0-4b78-8470-aabe5c344bda	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2024-10-23 19:20:00+00	2024-11-08 14:05:00+00	MC	\N
faccae8f-40c1-492a-b81a-f38c8f63315d	53bd145c-4aa0-485a-a4c0-53cfa2d5b51c	1	cb20a7a1-e40f-4cb1-af07-8e5273dd0237	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2024-11-01 07:25:00+00	2024-12-12 21:10:00+00	MC	\N
33291a69-50c5-4fb1-ad18-0e7e7214811c	e1f0e324-31f8-47fc-8f50-436e727df1ae	1	13c3c551-df0d-4c62-a185-d36a0298672a	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2024-11-02 23:35:00+00	2024-11-23 08:30:00+00	MC	\N
951057e8-7682-4e82-a104-9224d9715630	19ff0885-8396-4d47-97ac-eb619eee0f74	1	cb20a7a1-e40f-4cb1-af07-8e5273dd0237	f3d2726d-273b-4876-8181-2bad234708b5	f3d2726d-273b-4876-8181-2bad234708b5	2023-12-28 00:50:00+00	2024-02-01 09:30:00+00	MC	\N
b5825c17-78dd-4c05-a34e-4d5db7905ef5	d890b49f-e166-477e-9243-046732717708	1	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2024-07-05 19:50:00+00	2024-07-09 11:00:00+00	MC	\N
7204230e-350b-4515-a18e-45d1d8a3eee1	591d31d6-8bd5-4c4b-b35c-5f5341eb1029	1	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	953117a0-3c04-4129-ab96-5eddf3a8d43a	953117a0-3c04-4129-ab96-5eddf3a8d43a	2024-08-06 22:10:00+00	2024-08-19 11:35:00+00	MC	\N
3e39abe5-6a62-4d33-9eee-7482fd2eeec0	5e781767-f7eb-4add-916c-235bf92b347f	1	13c3c551-df0d-4c62-a185-d36a0298672a	f3d2726d-273b-4876-8181-2bad234708b5	f3d2726d-273b-4876-8181-2bad234708b5	2024-01-16 16:25:00+00	2024-02-02 00:00:00+00	MC	\N
d387630a-955d-480b-95be-dfc967221baa	e8162f7d-18a9-4220-a2dc-b57a3738046b	1	cb20a7a1-e40f-4cb1-af07-8e5273dd0237	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2024-05-24 22:00:00+00	2024-06-09 12:30:00+00	MC	\N
b6c46f82-3749-46f8-8a29-0f1bc8da8d53	e2baf9fd-91da-4ffd-acc5-1145fde03a87	1	13c3c551-df0d-4c62-a185-d36a0298672a	f3d2726d-273b-4876-8181-2bad234708b5	f3d2726d-273b-4876-8181-2bad234708b5	2024-08-02 13:25:00+00	2024-09-11 10:50:00+00	MC	\N
4992ffde-7655-42e0-be22-e20bb6f899fb	efafcdf6-7595-43c5-bbbc-cb7031f6650f	1	13c3c551-df0d-4c62-a185-d36a0298672a	f3d2726d-273b-4876-8181-2bad234708b5	f3d2726d-273b-4876-8181-2bad234708b5	2024-10-31 00:00:00+00	2024-11-11 14:55:00+00	MC	\N
4c513ddb-4840-4bbf-bc16-db0f07058080	e2a6438c-34c7-4863-a6ad-cf188aa87224	1	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2024-03-28 18:12:00+00	2024-04-26 21:05:00+00	MC	\N
792d5fb0-614a-47a4-908c-e1e7f91e4b70	8468cb61-f4a8-4b25-b077-5b670e2e20b9	1	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	\N	\N	2024-04-30 14:30:00+00	2024-05-19 10:49:00+00	MC	\N
20706dcf-5515-4361-801e-a184bee2295d	d8515180-194f-41ba-aedd-cda1f08c8121	1	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2024-05-23 18:15:00+00	2024-06-13 14:36:00+00	MC	\N
24499190-584e-4594-af9f-94446ce1d9ae	9cb68e49-ace8-4584-84f4-402a94514ec6	1	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	\N	\N	2024-06-19 21:40:00+00	2024-08-02 11:20:00+00	MC	\N
7f211bd5-2f15-4cf2-89cc-7acaee81fcc2	f82d0e5c-f8d3-427a-976f-254202b454b4	1	127f273e-086c-4e23-bb9e-0557fc9270aa	c08082e7-f85e-4434-ab74-860bc02f07a1	953117a0-3c04-4129-ab96-5eddf3a8d43a	2025-12-29 13:00:00+00	2026-01-19 03:30:00+00	MC	
5d3fc805-e638-411a-a87b-7fd51429fd72	2d704937-98e2-451f-87b2-4c5bcbf9ceb0	2	127f273e-086c-4e23-bb9e-0557fc9270aa	aa748f6a-602b-4346-b964-50cbcea76146	\N	2026-01-06 18:50:00+00	\N	MC	
9a066b0d-6b7e-437c-97f8-306644f323d8	2d704937-98e2-451f-87b2-4c5bcbf9ceb0	1	127f273e-086c-4e23-bb9e-0557fc9270aa	4ad4e569-c081-4820-895e-e86131bc5b38	aa748f6a-602b-4346-b964-50cbcea76146	2025-12-29 19:02:00+00	2026-01-05 19:45:00+00	MC	
2fa504fb-15dd-4391-a586-5eb0156813e5	ad02fd80-86df-4475-a900-a6ae9b15d231	1	13c3c551-df0d-4c62-a185-d36a0298672a	792484d9-dc51-4a9d-b9a5-d28c9047bcf0	792484d9-dc51-4a9d-b9a5-d28c9047bcf0	2025-11-26 20:00:00+00	2026-01-04 19:00:00+00	MC	\N
9ca4d05d-d649-41f4-944f-1ab3ccd64f4f	56179c3f-3e6a-4a21-bc62-8ce00aea1c67	2	127f273e-086c-4e23-bb9e-0557fc9270aa	4ad4e569-c081-4820-895e-e86131bc5b38	\N	2026-01-06 17:43:00+00	\N	MC	
00f27346-e889-40f2-8c8f-f54cba393e44	56179c3f-3e6a-4a21-bc62-8ce00aea1c67	1	127f273e-086c-4e23-bb9e-0557fc9270aa	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-12-29 18:35:00+00	2026-01-04 09:10:00+00	MC	
680495a0-2a5e-4cbd-a458-083cb8868081	8017564a-6168-4454-a6a3-6bf4505d1f03	1	13c3c551-df0d-4c62-a185-d36a0298672a	aa748f6a-602b-4346-b964-50cbcea76146	\N	2025-12-30 21:40:00+00	\N	MC	
6d494a55-87a1-478b-b8ef-a2248c60f067	25e40b6e-feee-4555-a6ba-62bfbc7f58ef	1	13c3c551-df0d-4c62-a185-d36a0298672a	aa748f6a-602b-4346-b964-50cbcea76146	\N	2025-12-30 22:40:00+00	\N	MC	
2d970d59-8d51-4b09-867e-0519ddf9f9c4	8c6f48f4-807c-4012-865a-3a3420d96bab	1	13c3c551-df0d-4c62-a185-d36a0298672a	aa748f6a-602b-4346-b964-50cbcea76146	aa748f6a-602b-4346-b964-50cbcea76146	2025-12-23 17:20:00+00	2025-12-27 14:10:00+00	MC	
78f7bc8b-7fd5-4df7-85cc-a9e4a6593c09	8c6f48f4-807c-4012-865a-3a3420d96bab	2	13c3c551-df0d-4c62-a185-d36a0298672a	aa748f6a-602b-4346-b964-50cbcea76146	\N	2026-01-01 18:30:00+00	\N	MC	
8f16a469-0f86-464b-ae30-66edf98e980f	8e8e3e0e-7361-4f1e-8ba9-ec61cdb41b1e	1	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	\N	\N	2024-08-03 17:47:00+00	2024-08-13 13:15:00+00	MC	\N
b20ed9fb-c575-4b40-8a44-552c11ea680d	b6ef2475-dd87-4735-9868-30bf32eea7f6	1	cb20a7a1-e40f-4cb1-af07-8e5273dd0237	f3d2726d-273b-4876-8181-2bad234708b5	f3d2726d-273b-4876-8181-2bad234708b5	2024-02-03 09:55:00+00	2024-03-20 03:00:00+00	MC	\N
e47d9cac-63e6-4c16-bc54-5a5d4d70ab65	07d0498b-93cb-4ce6-a0e4-1b2119aa41fc	1	cb20a7a1-e40f-4cb1-af07-8e5273dd0237	aa748f6a-602b-4346-b964-50cbcea76146	aa748f6a-602b-4346-b964-50cbcea76146	2024-04-20 14:15:00+00	2024-05-25 12:45:00+00	MC	\N
98d3a60d-2eb0-46e4-93a7-2cae1496c0ed	e6c3ed40-333d-48dc-bba4-3d0054f74f6b	1	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2024-02-07 18:15:00+00	2024-03-13 15:10:00+00	MC	\N
d7f78c91-39e3-47a6-b983-8aa3eebc61f4	1db04fe3-2c1e-4586-9fd5-42821e21fb2e	1	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2024-04-26 16:40:00+00	2024-05-26 18:50:00+00	MC	\N
f0b3a9d2-0f5d-4a6d-8ba0-69b76274548c	beb03c38-1778-4d73-9257-26c76167226a	1	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2024-05-29 15:40:00+00	2024-06-30 08:20:00+00	MC	\N
84535e05-8bac-44df-b946-817056b863d5	2f831662-44f0-47d0-9772-8105d4d30abc	1	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2024-07-17 08:42:00+00	2024-08-20 07:31:00+00	MC	\N
71b0156d-f3ed-4ec2-990a-4461cac16d4c	60a78da6-36ba-45ad-9bb1-906e5b2a7e15	1	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2024-09-02 19:00:00+00	2024-10-09 06:50:00+00	MC	\N
0d2988d4-7ae2-4256-8930-f4ec9090143d	a0e2f188-6522-40e5-8aa4-15033fb8225a	1	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2024-01-22 03:08:00+00	2024-01-29 01:42:00+00	MC	\N
6d4d2252-205d-49d6-ad9f-3add349eb614	dc78d927-913d-47a0-a78f-98cc235011e2	1	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2024-03-28 09:10:00+00	2024-04-15 12:45:00+00	MC	\N
71f087fe-72d9-4f96-82f8-fdd9a4d3dccc	f64cb623-f276-49a7-b803-ec9b4fab0c17	1	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2024-05-22 00:00:00+00	2024-06-09 00:00:00+00	MC	\N
bd7f90d9-0b12-48e1-b074-d6065e7d40fb	261a9424-6017-457f-9ede-0d834c0893c8	1	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	\N	\N	2024-08-08 19:15:00+00	2024-08-22 15:00:00+00	MC	\N
fa508887-2095-41d5-b10a-a513f71f3e78	904c8609-d1e9-4dea-a0a2-c9824e164341	1	127f273e-086c-4e23-bb9e-0557fc9270aa	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2024-04-20 16:22:00+00	2024-05-15 09:06:00+00	MC	\N
ed3f447f-a32a-4eff-8829-b60a31f5fcd7	3937d6c3-6ad3-43b9-bc98-c7fa4de04c74	1	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2024-06-12 10:33:00+00	2024-06-18 10:54:00+00	MC	\N
82835ffe-9121-43cf-bfb7-00b093a64ba2	0760f5f9-afa4-4c90-a3cd-2cd9093eb2b2	1	cb20a7a1-e40f-4cb1-af07-8e5273dd0237	f3d2726d-273b-4876-8181-2bad234708b5	f3d2726d-273b-4876-8181-2bad234708b5	2024-09-02 22:00:00+00	2024-09-24 06:05:00+00	MC	\N
fd861364-4068-4e73-a8ae-c629fe03c939	f316b80a-01dc-427d-828c-fcf285b2e178	1	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2024-02-22 18:00:00+00	2024-03-03 11:34:00+00	MC	\N
9628b073-a8b4-4dce-a6cd-2b525c0358bf	6ceb334f-e35d-40d9-84c7-42caa6851f66	1	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2024-08-02 18:10:00+00	2024-08-09 08:59:00+00	MC	\N
766fdf31-b2fd-44f0-b058-45e1270f093b	826d1152-e4a1-4c52-8fd7-db181a9592f4	1	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2024-09-06 17:10:00+00	2024-09-13 06:27:00+00	MC	\N
a1c751a4-146b-4742-91cc-a621740d2289	039eba13-308c-454b-b868-ede9323738d7	1	127f273e-086c-4e23-bb9e-0557fc9270aa	f3d2726d-273b-4876-8181-2bad234708b5	f3d2726d-273b-4876-8181-2bad234708b5	2024-02-23 10:40:00+00	2024-03-25 17:15:00+00	MC	\N
fc81595b-96f4-4ffe-ac5f-797e3cb19531	4cd1e100-0941-41d9-85c8-a02c11f95feb	1	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	aa748f6a-602b-4346-b964-50cbcea76146	aa748f6a-602b-4346-b964-50cbcea76146	2024-05-02 15:55:00+00	2024-05-20 09:30:00+00	MC	\N
f0fea44d-1af5-41af-961d-568c6b54bcda	bfe8941e-81ab-4671-bf1c-2c76cb572a7a	1	13c3c551-df0d-4c62-a185-d36a0298672a	f3d2726d-273b-4876-8181-2bad234708b5	f3d2726d-273b-4876-8181-2bad234708b5	2024-02-06 21:35:00+00	2024-03-03 09:15:00+00	MC	\N
316bcd86-46b5-470c-8a3b-633086b77178	1330caa3-a5ea-46ea-9723-e3abd35dc4e2	1	83867dcf-3fe0-4b78-8470-aabe5c344bda	\N	\N	2024-07-11 16:50:00+00	2024-08-07 12:35:00+00	MC	\N
496d0d2c-5c5d-4b35-aac7-e0e4c7f60482	c14f74b4-a9f1-4c9a-8351-34f8449d5260	1	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2024-08-16 15:46:00+00	2024-08-24 12:50:00+00	MC	\N
7943d952-54ed-423f-80e3-c469338f2074	ab9ceceb-3e72-4ddd-bfbe-02c3ec853962	1	83867dcf-3fe0-4b78-8470-aabe5c344bda	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2024-08-29 14:05:00+00	2024-10-15 18:40:00+00	MC	\N
0e01c0c5-ed46-4ff7-9f23-a32a27b044f5	e31f7d95-5ab8-4752-86bc-9751ed519f14	1	127f273e-086c-4e23-bb9e-0557fc9270aa	953117a0-3c04-4129-ab96-5eddf3a8d43a	953117a0-3c04-4129-ab96-5eddf3a8d43a	2024-12-28 13:10:00+00	2025-01-16 14:00:00+00	MC	\N
fb4604f9-2513-4e3f-b9da-7a9592b505e7	e137ca35-4445-49ce-8e91-bf77fc8381e6	1	cb20a7a1-e40f-4cb1-af07-8e5273dd0237	f3d2726d-273b-4876-8181-2bad234708b5	f3d2726d-273b-4876-8181-2bad234708b5	2024-11-03 18:35:00+00	2024-12-19 04:00:00+00	MC	\N
8050bf72-5d42-43fd-a2db-5d56f1b40b8f	31665fe3-0e2d-4027-9350-d021825083a1	1	13c3c551-df0d-4c62-a185-d36a0298672a	f3d2726d-273b-4876-8181-2bad234708b5	f3d2726d-273b-4876-8181-2bad234708b5	2024-12-30 22:34:00+00	2025-01-27 04:45:00+00	MC	\N
7b0c2e60-6dc0-46fd-bf0a-c6340a509568	04ba68d5-d4cd-4f54-a9fa-099543eee5a2	1	13c3c551-df0d-4c62-a185-d36a0298672a	f3d2726d-273b-4876-8181-2bad234708b5	f3d2726d-273b-4876-8181-2bad234708b5	2024-12-31 05:20:00+00	2025-02-04 04:52:00+00	MC	\N
297d0bc4-a753-45a4-843b-3ab1782c1384	5d391bd6-0297-4e27-94bb-e1ed7fccc520	1	cb20a7a1-e40f-4cb1-af07-8e5273dd0237	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-01-03 04:35:00+00	2025-02-03 01:35:00+00	MC	\N
fec41af0-d81b-42fe-8b82-1e5e15d8a097	65e34e09-47c5-4622-8ac2-1332f04df0f5	1	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2024-10-04 10:09:00+00	2024-10-07 08:05:00+00	MC	\N
801784c6-69b5-421e-9830-e62b75db241d	b8008b59-a9c1-41be-9e9c-dff160947474	1	127f273e-086c-4e23-bb9e-0557fc9270aa	aa748f6a-602b-4346-b964-50cbcea76146	aa748f6a-602b-4346-b964-50cbcea76146	2025-01-07 16:40:00+00	2025-01-30 08:50:00+00	MC	\N
9c8a5abc-8751-4089-bb6d-d014947266e7	9b04ac72-d1a7-4c9e-a66d-caf4ea37e63b	1	83867dcf-3fe0-4b78-8470-aabe5c344bda	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-01-06 20:55:00+00	2025-02-07 09:45:00+00	MC	\N
04a734cf-1bba-4aaa-a437-de564cddfc8a	d6b7ab71-4e86-4c51-8655-593d696c5057	1	127f273e-086c-4e23-bb9e-0557fc9270aa	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-01-09 11:25:00+00	2025-02-08 21:54:00+00	MC	\N
554ab226-e21b-4cfa-ac48-3966a6f0e447	16e90a14-5b24-44b5-a008-81483ba1658f	1	127f273e-086c-4e23-bb9e-0557fc9270aa	f3d2726d-273b-4876-8181-2bad234708b5	f3d2726d-273b-4876-8181-2bad234708b5	2025-01-09 15:00:00+00	2025-02-02 19:58:00+00	MC	\N
fa7ac94a-2903-49c9-9a85-3cb2f25ce8f8	60917dfc-88b1-4bc5-8791-6ae6ade27aeb	1	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-01-11 12:37:00+00	2025-03-07 11:14:00+00	MC	\N
3a27100e-fe44-4365-879b-fef1d3a492fd	da5e8b57-028d-4d92-94cb-513bfe318ab6	1	83867dcf-3fe0-4b78-8470-aabe5c344bda	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-01-17 23:35:00+00	2025-03-01 19:40:00+00	MC	\N
3d2c7e30-7e0b-4ac4-b1a5-14fd0225701a	cc142ddb-9ddf-4249-8a3d-894a19fc254f	1	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-02-18 11:27:00+00	2025-02-25 20:17:00+00	MC	\N
b64653e9-91f5-40fd-b581-7dac8e1b5567	c21f5a9c-c140-41c9-ad1c-708bf3c26b2a	1	cb20a7a1-e40f-4cb1-af07-8e5273dd0237	f3d2726d-273b-4876-8181-2bad234708b5	f3d2726d-273b-4876-8181-2bad234708b5	2025-02-19 00:00:00+00	2025-04-11 09:30:00+00	MC	\N
0aabfc5c-b507-4fd8-b63e-e734b9e361bb	e53e2253-c732-4932-9db1-5b10963c2b02	1	13c3c551-df0d-4c62-a185-d36a0298672a	f3d2726d-273b-4876-8181-2bad234708b5	f3d2726d-273b-4876-8181-2bad234708b5	2025-02-22 09:10:00+00	2025-03-26 16:15:00+00	MC	\N
27f64d68-3962-44d2-9bae-9eabcfc78b7f	1e824fd2-b41c-44d2-b96c-1f3bcce11028	1	83867dcf-3fe0-4b78-8470-aabe5c344bda	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-03-01 13:40:00+00	2025-04-07 11:48:00+00	MC	\N
765b3a41-194c-4c44-858f-311b281d3b0a	8f4b3fd9-bac3-49e7-91d5-33830c337687	2	13c3c551-df0d-4c62-a185-d36a0298672a	f3d2726d-273b-4876-8181-2bad234708b5	f3d2726d-273b-4876-8181-2bad234708b5	2025-02-04 19:40:00+00	2025-02-19 11:11:00+00	MC	\N
cbaa73c1-f901-4454-b77e-2db6b428c2ef	8f4b3fd9-bac3-49e7-91d5-33830c337687	1	13c3c551-df0d-4c62-a185-d36a0298672a	f3d2726d-273b-4876-8181-2bad234708b5	f3d2726d-273b-4876-8181-2bad234708b5	2024-12-30 23:14:00+00	2025-02-03 08:45:00+00	MC	\N
36770a10-3718-4e6c-9cf4-609c0dbe630c	8635ded9-667b-4d2f-b4eb-11314fc2f93c	1	127f273e-086c-4e23-bb9e-0557fc9270aa	f3d2726d-273b-4876-8181-2bad234708b5	f3d2726d-273b-4876-8181-2bad234708b5	2025-03-07 16:25:00+00	2025-04-07 12:56:00+00	MC	\N
82f94bfb-394e-40e8-a513-4b53a0c32c0c	ea75be2d-11ae-4101-9d5b-e2e2d248afe1	1	127f273e-086c-4e23-bb9e-0557fc9270aa	\N	\N	2025-01-17 18:40:00+00	2025-03-09 20:51:00+00	MC	\N
a2bfae84-b052-4703-86b3-cdd405387152	087134ea-2e52-4e88-8f12-a552df1141c9	1	13c3c551-df0d-4c62-a185-d36a0298672a	f3d2726d-273b-4876-8181-2bad234708b5	f3d2726d-273b-4876-8181-2bad234708b5	2025-02-06 00:08:00+00	2025-03-11 12:30:00+00	MC	\N
7841fb9b-a0bb-47cd-8c4f-adfea667f883	e846f80f-3656-4b29-8adc-fd66355deba4	1	127f273e-086c-4e23-bb9e-0557fc9270aa	aa748f6a-602b-4346-b964-50cbcea76146	aa748f6a-602b-4346-b964-50cbcea76146	2025-01-31 14:50:00+00	2025-03-24 09:35:00+00	MC	\N
0b427a57-4918-4c04-b926-cbe8dbf3a378	a36b8a24-7125-4e93-a452-2e26397924fe	1	13c3c551-df0d-4c62-a185-d36a0298672a	f3d2726d-273b-4876-8181-2bad234708b5	f3d2726d-273b-4876-8181-2bad234708b5	2025-02-01 12:55:00+00	2025-02-26 06:55:00+00	MC	\N
681888ac-5757-4977-89be-7eca33d6ce4b	a0198db1-afc7-4cd4-a628-344216ca6a24	1	127f273e-086c-4e23-bb9e-0557fc9270aa	f3d2726d-273b-4876-8181-2bad234708b5	f3d2726d-273b-4876-8181-2bad234708b5	2025-02-01 13:18:00+00	2025-03-08 06:19:00+00	MC	\N
1025070d-a0d3-46d3-8866-72b8bac1a979	7525c091-0463-43c4-ad28-60bdcd31b009	1	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-02-08 12:35:00+00	2025-02-22 07:36:00+00	MC	\N
14b2dc06-db3f-4e22-95bb-6c9c330b05ce	33c0a1ec-d31c-439e-8d97-5dc7bf148792	2	cb20a7a1-e40f-4cb1-af07-8e5273dd0237	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-03-26 21:20:00+00	2025-05-07 04:20:00+00	MC	\N
8f21b562-e539-4262-adb0-3eed969a78fb	33c0a1ec-d31c-439e-8d97-5dc7bf148792	1	cb20a7a1-e40f-4cb1-af07-8e5273dd0237	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-02-13 17:05:00+00	2025-03-24 17:05:00+00	MC	\N
148602db-d4cb-4aa8-9078-8f09fa53e365	1cb34559-4516-4bfb-b972-2cd1f6ca049a	1	83867dcf-3fe0-4b78-8470-aabe5c344bda	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-02-12 16:34:00+00	2025-03-20 19:07:00+00	MC	\N
380a8db3-9aae-4eb4-8edd-4de3985a5d59	7ff02790-fbc0-4496-8a76-86db0a9b0e87	1	127f273e-086c-4e23-bb9e-0557fc9270aa	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-03-24 00:00:00+00	2025-04-23 00:00:00+00	MC	\N
81855e8d-5576-480c-9a0a-b5ec93d8330a	f96d36f0-d576-4f94-ab71-2203df60279c	1	127f273e-086c-4e23-bb9e-0557fc9270aa	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-03-28 00:00:00+00	2025-05-05 00:00:00+00	MC	\N
8387d466-0196-4ec2-b908-e02398122ac9	56a28366-0adb-4932-b62d-c6d18f510c42	2	a7c270d2-3ec4-436a-bbfe-4359d46b0b22	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-03-19 19:40:00+00	2025-03-28 11:35:00+00	MC	\N
a431cdf5-2f60-4f20-86ef-f27a71dbfb74	56a28366-0adb-4932-b62d-c6d18f510c42	1	a7c270d2-3ec4-436a-bbfe-4359d46b0b22	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-03-11 17:05:00+00	2025-03-16 03:13:00+00	MC	\N
5cc0074e-743f-4a33-9cca-928c0419f4dd	7bc2920f-a8f2-4905-ae4a-132d688c7e03	1	cb20a7a1-e40f-4cb1-af07-8e5273dd0237	aa748f6a-602b-4346-b964-50cbcea76146	aa748f6a-602b-4346-b964-50cbcea76146	2025-02-25 00:00:00+00	2025-03-30 00:00:00+00	MC	\N
34f21bac-200a-49f7-adcb-6924254470d7	0a5310e4-2f6e-4cf4-8b5b-176d32f805b4	1	127f273e-086c-4e23-bb9e-0557fc9270aa	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-02-04 16:05:00+00	2025-03-11 04:30:00+00	MC	\N
b06718f2-6a46-49f5-a148-af9c9c79f4f3	45593af6-fcbb-4405-bcd1-8c4d8765b178	1	83867dcf-3fe0-4b78-8470-aabe5c344bda	\N	\N	2025-01-09 23:07:00+00	2025-02-16 22:33:00+00	MC	\N
b395a885-4b3c-447a-9b8a-a8b0a877ed56	f023f042-bbdc-4a60-872e-d1e21e084ac8	1	83867dcf-3fe0-4b78-8470-aabe5c344bda	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-01-13 19:00:00+00	2025-02-24 09:48:00+00	MC	\N
0fcad127-1cfb-49ad-b172-4c3981740825	feb59314-0df2-45e8-84bc-78052046a370	1	127f273e-086c-4e23-bb9e-0557fc9270aa	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-01-09 19:25:00+00	2025-02-02 21:30:00+00	MC	\N
0d29ecd0-635f-430b-b134-22715044e495	5eb8661e-51ce-49d7-97c5-d19f92544740	1	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-01-07 21:42:00+00	2025-01-28 06:45:00+00	MC	\N
5c5d87e4-0a7f-4f6f-a7c4-7e041c948f98	be484c9c-09ca-462c-95bb-c25eee9501ec	2	a7c270d2-3ec4-436a-bbfe-4359d46b0b22	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-03-21 20:52:00+00	2025-03-28 17:49:00+00	MC	\N
5cedd875-0ff0-48b6-99f1-b233b8020ea9	be484c9c-09ca-462c-95bb-c25eee9501ec	1	a7c270d2-3ec4-436a-bbfe-4359d46b0b22	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-03-11 16:15:00+00	2025-03-18 19:00:00+00	MC	\N
63fbadba-377f-4a0e-8be7-5db237e75e3f	1231ddcf-bf24-4cd4-a0d1-1de4e73a7f47	1	83867dcf-3fe0-4b78-8470-aabe5c344bda	\N	\N	2025-02-21 18:09:00+00	2025-04-02 08:19:00+00	MC	\N
f326985a-54be-48d2-978b-4201f3503e14	cf18e5e1-80fd-433a-ad01-8d7d34068033	1	83867dcf-3fe0-4b78-8470-aabe5c344bda	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-04-17 17:00:00+00	2025-05-27 15:20:00+00	MC	\N
ab4fbef6-46e0-4485-a6f1-b3623e85eda4	563747df-f9ee-4682-882d-9217931e353a	1	cb20a7a1-e40f-4cb1-af07-8e5273dd0237	aa748f6a-602b-4346-b964-50cbcea76146	aa748f6a-602b-4346-b964-50cbcea76146	2025-04-01 00:00:00+00	2025-04-27 00:00:00+00	MC	\N
eda77455-9a51-470d-8a77-cf5cdecb26b6	037f33b0-bb12-4a3c-9db5-3a077fc13c25	1	1985bde5-8964-4250-b775-74cc7469ed58	953117a0-3c04-4129-ab96-5eddf3a8d43a	953117a0-3c04-4129-ab96-5eddf3a8d43a	2025-02-04 12:54:00+00	2025-03-10 13:19:00+00	MC	\N
9e227ebe-245d-4e9b-82dd-ad76e2beae7e	0fbad4f9-17e7-41f9-806b-33aa89cdf920	1	127f273e-086c-4e23-bb9e-0557fc9270aa	f3d2726d-273b-4876-8181-2bad234708b5	f3d2726d-273b-4876-8181-2bad234708b5	2025-04-23 00:00:00+00	2025-05-14 00:00:00+00	MC	\N
54a34141-65d5-447f-9869-06a61b71285e	77d9037c-5697-43d2-a9b6-63b7573ab634	1	cb20a7a1-e40f-4cb1-af07-8e5273dd0237	f3d2726d-273b-4876-8181-2bad234708b5	f3d2726d-273b-4876-8181-2bad234708b5	2025-04-18 00:00:00+00	2025-05-19 00:00:00+00	MC	\N
a5240a1f-1e4f-4f99-bab5-1e8c9fbb4b67	e3564104-bbf6-4fb4-ac96-528b2739f411	1	cb20a7a1-e40f-4cb1-af07-8e5273dd0237	aa748f6a-602b-4346-b964-50cbcea76146	aa748f6a-602b-4346-b964-50cbcea76146	2025-04-29 17:20:00+00	2025-06-02 19:10:00+00	MC	\N
e6b202fb-e555-4963-88bb-84c9c59b1d8c	4c5fd41e-35d5-4a16-a34b-870dac9f95c7	1	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-04-29 21:15:00+00	2025-05-15 14:45:00+00	MC	\N
8f9e8447-59f2-4f85-bdff-40281cde5997	7ed632a1-b04e-409a-83b6-4cff98b3900a	1	1985bde5-8964-4250-b775-74cc7469ed58	f3d2726d-273b-4876-8181-2bad234708b5	f3d2726d-273b-4876-8181-2bad234708b5	2025-04-30 15:15:00+00	2025-06-16 18:05:00+00	MC	\N
9a673876-c125-441c-a9ff-a6546918bfb1	7e38f2f8-5683-4aa6-a80f-d0f1c2e552b9	1	127f273e-086c-4e23-bb9e-0557fc9270aa	f3d2726d-273b-4876-8181-2bad234708b5	f3d2726d-273b-4876-8181-2bad234708b5	2025-04-30 18:47:00+00	2025-06-05 07:50:00+00	MC	\N
f22b33a4-5429-4f3e-8cb4-d5637df16fd0	84cd59ab-19c3-4e16-a79c-369a15f3ad98	1	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-05-04 00:20:00+00	2025-06-03 17:48:00+00	MC	\N
0baa1e82-22b8-4bd0-9b5a-2fc0d78d9422	a084b657-a47b-44e1-a45d-78a6953aa01a	1	127f273e-086c-4e23-bb9e-0557fc9270aa	f3d2726d-273b-4876-8181-2bad234708b5	f3d2726d-273b-4876-8181-2bad234708b5	2025-05-07 13:55:00+00	2025-06-09 16:02:00+00	MC	\N
410d3465-4001-410a-93d8-a1619c173432	60eaa75e-46b6-49eb-90c4-0bfe6d389eaa	1	127f273e-086c-4e23-bb9e-0557fc9270aa	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-05-07 14:55:00+00	2025-06-10 11:07:00+00	MC	\N
e97a461c-6b0e-42d4-80ad-71b1313f1a9b	3f2d62fb-cd2e-44b4-9392-45694d508758	1	cb20a7a1-e40f-4cb1-af07-8e5273dd0237	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-05-08 16:25:00+00	2025-06-17 04:30:00+00	MC	\N
4263fb8f-2736-4c78-97b7-853abfa04459	b3cdec65-4d6d-43ee-95be-a219779a543a	2	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-05-12 16:12:00+00	2025-05-21 09:23:00+00	MC	\N
bbf36482-2a80-491c-813c-f7ff1d0c2d29	b3cdec65-4d6d-43ee-95be-a219779a543a	1	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-05-02 15:10:00+00	2025-05-10 05:18:00+00	MC	\N
c5f6ffe1-7797-4d79-aadd-24cb7a07949c	2f3b3c22-997e-4bc2-85e3-b7a56c7629ac	2	a7c270d2-3ec4-436a-bbfe-4359d46b0b22	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-03-22 18:55:00+00	2025-03-27 21:00:00+00	MC	\N
01a068a3-dedf-4b9b-8de1-85600992fdac	2f3b3c22-997e-4bc2-85e3-b7a56c7629ac	1	a7c270d2-3ec4-436a-bbfe-4359d46b0b22	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-03-11 20:36:00+00	2025-03-20 21:33:00+00	MC	\N
867a4f3a-39a8-4e40-b162-632f3f70bad9	c5343015-af9a-4374-b661-fb4dc7367146	2	127f273e-086c-4e23-bb9e-0557fc9270aa	aa748f6a-602b-4346-b964-50cbcea76146	aa748f6a-602b-4346-b964-50cbcea76146	2025-02-25 19:00:00+00	2025-04-06 17:20:00+00	MC	\N
3cd86a00-4700-46a6-a354-9c4533e7e433	c5343015-af9a-4374-b661-fb4dc7367146	1	127f273e-086c-4e23-bb9e-0557fc9270aa	aa748f6a-602b-4346-b964-50cbcea76146	aa748f6a-602b-4346-b964-50cbcea76146	2025-01-29 05:23:00+00	2025-02-23 20:15:00+00	MC	\N
858c9bc8-c4ae-4f92-b9cc-9586a8e8043e	04e248a5-5ce7-450a-9c3c-565a39f9155a	1	13c3c551-df0d-4c62-a185-d36a0298672a	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-05-15 10:47:00+00	2025-05-27 12:47:00+00	MC	\N
f15d66d9-f5d1-4d96-b50b-933713308bd9	6c961bba-3ba0-4eed-b5c9-8f1666f370a8	1	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	f3d2726d-273b-4876-8181-2bad234708b5	f3d2726d-273b-4876-8181-2bad234708b5	2025-05-11 07:00:00+00	2025-05-18 10:25:00+00	MC	\N
b7dd5b3f-a606-4473-a9d9-97aa2549dc47	64d3eceb-4ce4-4ba9-b7d6-ac95de18c94e	1	83867dcf-3fe0-4b78-8470-aabe5c344bda	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-04-22 17:42:00+00	2025-06-06 07:51:00+00	MC	\N
5ee577e7-691c-4446-bd82-33e916db1e3f	067536b6-2790-4ce3-a499-575189c9632d	3	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-05-17 12:29:00+00	2025-05-27 12:46:00+00	MC	\N
a7dd51c0-ad75-42c0-a487-0ce266944a8f	067536b6-2790-4ce3-a499-575189c9632d	2	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-05-06 19:50:00+00	2025-05-15 08:48:00+00	MC	\N
8f6d528d-93e4-44c0-968b-097c63a18d8a	067536b6-2790-4ce3-a499-575189c9632d	1	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-04-26 11:30:00+00	2025-05-04 14:35:00+00	MC	\N
ad81c7c3-9539-4825-bc3f-7ad226560b3e	e73ffb8a-e102-4029-8169-1e597e5215dc	1	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-05-17 15:42:00+00	2025-07-13 10:03:00+00	MC	\N
fb47f630-9135-4170-9941-357fdf6e4bf6	9b039da1-0d80-4df9-916c-e45c57fecf8e	1	cb20a7a1-e40f-4cb1-af07-8e5273dd0237	aa748f6a-602b-4346-b964-50cbcea76146	aa748f6a-602b-4346-b964-50cbcea76146	2025-01-04 21:00:00+00	2025-01-28 15:40:00+00	MC	\N
10a19f7b-3d79-4dd6-a09f-c65d1e90bc04	31a9c494-ebb7-4c70-8839-1da7503c9cff	3	a7c270d2-3ec4-436a-bbfe-4359d46b0b22	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-03-18 21:05:00+00	2025-03-29 11:00:00+00	MC	\N
abeb193a-fbe4-4919-9f42-dd5aa2daf048	31a9c494-ebb7-4c70-8839-1da7503c9cff	2	a7c270d2-3ec4-436a-bbfe-4359d46b0b22	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-03-15 20:55:00+00	2025-03-17 12:57:00+00	MC	\N
f1a6ba2b-8d4d-4c54-b471-2b0294ad9e16	31a9c494-ebb7-4c70-8839-1da7503c9cff	1	a7c270d2-3ec4-436a-bbfe-4359d46b0b22	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-03-12 11:32:00+00	2025-03-15 06:20:00+00	MC	\N
7bc42361-24dc-4e99-afc6-b77ff755c5eb	a9dae374-df94-4aa5-a623-9d8144978ccc	2	1985bde5-8964-4250-b775-74cc7469ed58	953117a0-3c04-4129-ab96-5eddf3a8d43a	953117a0-3c04-4129-ab96-5eddf3a8d43a	2025-03-19 17:40:00+00	2025-04-23 19:50:00+00	MC	\N
0fe3a48a-2e81-438b-a03e-ec7b40615c13	7921bdce-9e65-4d72-9a1d-f8af57783669	2	a7c270d2-3ec4-436a-bbfe-4359d46b0b22	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-03-15 13:38:00+00	2025-03-18 17:35:00+00	MC	\N
861f32d9-a20e-4638-8474-68605d488dde	7921bdce-9e65-4d72-9a1d-f8af57783669	1	a7c270d2-3ec4-436a-bbfe-4359d46b0b22	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-03-07 16:05:00+00	2025-03-12 23:35:00+00	MC	\N
a4ca4aa6-1da6-4a0e-8fda-a12a5e88a5f0	426df63e-b2cc-4eaa-b88b-efe2f9491256	1	cb20a7a1-e40f-4cb1-af07-8e5273dd0237	f3d2726d-273b-4876-8181-2bad234708b5	f3d2726d-273b-4876-8181-2bad234708b5	2025-05-22 05:10:00+00	2025-06-21 07:50:00+00	MC	\N
2897bfbf-a786-4363-9efa-b39133879db6	872b6b79-3026-4b2b-9d0a-f94a1a356ae4	1	127f273e-086c-4e23-bb9e-0557fc9270aa	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-05-22 11:32:00+00	2025-06-05 08:10:00+00	MC	\N
4668a45a-6929-49a3-9881-9180bdab1985	4e63e615-31bd-4749-8f26-e2ac10079b78	1	83867dcf-3fe0-4b78-8470-aabe5c344bda	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-05-07 17:05:00+00	2025-06-10 17:15:00+00	MC	\N
af2dac44-ee2c-4f35-b2a2-5edaa3534a1c	57aeda51-1344-4b3d-8aa5-7974aadce5d7	1	1985bde5-8964-4250-b775-74cc7469ed58	953117a0-3c04-4129-ab96-5eddf3a8d43a	953117a0-3c04-4129-ab96-5eddf3a8d43a	2025-04-27 07:55:00+00	2025-05-31 08:19:00+00	MC	\N
a68078c4-5de4-4267-b376-3e50e530c8a2	65be28e1-bb22-4743-a89d-69a3d7f245f7	2	13c3c551-df0d-4c62-a185-d36a0298672a	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-05-08 16:51:00+00	2025-05-12 21:00:00+00	MC	\N
d685ca5f-9445-439b-aa3d-34e878b4144a	65be28e1-bb22-4743-a89d-69a3d7f245f7	1	13c3c551-df0d-4c62-a185-d36a0298672a	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-04-12 11:10:00+00	2025-05-08 08:45:00+00	MC	\N
320fe15d-66ec-4bd8-92ab-addf7fe5b28a	1e353aec-59d4-4bd1-87ee-29f37202c7a4	1	83867dcf-3fe0-4b78-8470-aabe5c344bda	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-03-28 00:00:00+00	2025-04-30 00:00:00+00	MC	\N
a3e59014-1dac-403e-a3e8-8eb97b301db6	bb7f40fc-b77a-42a2-91d7-f5ec0de39a95	1	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-05-22 15:40:00+00	2025-06-17 07:33:00+00	MC	\N
cb604e3f-717d-44a8-9cff-e3b5a7dfe5aa	658c41aa-3738-44e7-b495-67c2b5868b99	1	cb20a7a1-e40f-4cb1-af07-8e5273dd0237	792484d9-dc51-4a9d-b9a5-d28c9047bcf0	792484d9-dc51-4a9d-b9a5-d28c9047bcf0	2025-05-22 19:05:00+00	2025-07-10 14:40:00+00	MC	\N
713e093c-e2b0-473c-b269-73a16189a38b	c06ba6a8-5afe-48d9-8cc2-614b42898727	2	127f273e-086c-4e23-bb9e-0557fc9270aa	953117a0-3c04-4129-ab96-5eddf3a8d43a	953117a0-3c04-4129-ab96-5eddf3a8d43a	2025-04-16 00:30:00+00	2025-05-27 08:09:00+00	MC	\N
dede0bd6-51fd-46db-a12d-9d24dae0e3e5	69c812ec-5da2-4460-a15b-b6dee85db80c	1	127f273e-086c-4e23-bb9e-0557fc9270aa	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-04-26 13:42:00+00	2025-05-28 14:11:00+00	MC	\N
057edcc9-cb24-4ebe-8971-866459265eee	cc7753b3-fffa-4aaf-9e5d-f53b975b95f6	1	83867dcf-3fe0-4b78-8470-aabe5c344bda	\N	\N	2025-05-28 11:51:00+00	2025-07-12 12:17:00+00	MC	\N
2067440c-89d6-4e04-b67a-05f26d5eab18	4c798852-af1a-4d49-b2bc-90164c8381ec	1	127f273e-086c-4e23-bb9e-0557fc9270aa	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-05-31 12:41:00+00	2025-06-07 00:00:00+00	MC	\N
d13d3a49-ab53-42ec-b376-4bdb99235269	a120ecf7-5311-4528-b8d3-f4318b3246b3	3	13c3c551-df0d-4c62-a185-d36a0298672a	f3d2726d-273b-4876-8181-2bad234708b5	f3d2726d-273b-4876-8181-2bad234708b5	2025-04-23 17:05:00+00	2025-04-28 16:05:00+00	MC	\N
3575a732-a02d-43fb-b8d1-5fa9314df95e	a120ecf7-5311-4528-b8d3-f4318b3246b3	2	13c3c551-df0d-4c62-a185-d36a0298672a	f3d2726d-273b-4876-8181-2bad234708b5	f3d2726d-273b-4876-8181-2bad234708b5	2025-04-16 15:00:00+00	2025-04-23 09:45:00+00	MC	\N
c6c523c3-d57e-4266-ade0-c9efd97d868d	a120ecf7-5311-4528-b8d3-f4318b3246b3	1	13c3c551-df0d-4c62-a185-d36a0298672a	f3d2726d-273b-4876-8181-2bad234708b5	f3d2726d-273b-4876-8181-2bad234708b5	2025-03-13 14:45:00+00	2025-04-14 10:20:00+00	MC	\N
dc73a497-edeb-407f-91a5-d6b84514dbff	4f7c6bd0-e3bb-4ddf-ae94-8b3eaede0b10	5	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-07-12 12:25:00+00	2025-07-16 11:05:00+00	MC	\N
838bd357-d5b0-4b28-959e-f50517416343	4f7c6bd0-e3bb-4ddf-ae94-8b3eaede0b10	4	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-07-06 17:05:00+00	2025-07-10 07:59:00+00	MC	\N
f4475438-b66b-4ea0-b8ef-21aa4db6abe3	4f7c6bd0-e3bb-4ddf-ae94-8b3eaede0b10	3	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-06-28 12:06:00+00	2025-07-04 14:16:00+00	MC	\N
56ed4100-6e62-4e5a-86e8-6e69334176cb	4f7c6bd0-e3bb-4ddf-ae94-8b3eaede0b10	2	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-06-19 14:09:00+00	2025-06-22 14:56:00+00	MC	\N
2e90ca30-4c0a-4a31-aa80-7b73631cdf72	4f7c6bd0-e3bb-4ddf-ae94-8b3eaede0b10	1	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-06-10 18:15:00+00	2025-06-17 02:25:00+00	MC	\N
f5935a95-5320-4db1-8fdf-f9c91a43d0ed	9250e417-2c74-41f7-ab92-83462b20a339	3	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	f3d2726d-273b-4876-8181-2bad234708b5	f3d2726d-273b-4876-8181-2bad234708b5	2025-05-02 13:20:00+00	2025-05-10 00:00:00+00	MC	\N
bc43c23b-6a6e-4c8f-8a72-a094adc69bd9	9250e417-2c74-41f7-ab92-83462b20a339	2	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	f3d2726d-273b-4876-8181-2bad234708b5	f3d2726d-273b-4876-8181-2bad234708b5	2025-04-21 16:20:00+00	2025-05-01 08:40:00+00	MC	\N
3a0f7306-641d-460f-bea8-2541ec86f0a5	9250e417-2c74-41f7-ab92-83462b20a339	1	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	f3d2726d-273b-4876-8181-2bad234708b5	f3d2726d-273b-4876-8181-2bad234708b5	2025-04-12 17:09:00+00	2025-04-20 01:00:00+00	MC	\N
8953f8d9-583b-4238-9011-58a915133a5b	d78a9d78-2e2a-4ae8-8852-7006e0d841ee	2	13c3c551-df0d-4c62-a185-d36a0298672a	f3d2726d-273b-4876-8181-2bad234708b5	f3d2726d-273b-4876-8181-2bad234708b5	2025-02-06 19:45:00+00	2025-03-11 12:42:00+00	MC	\N
07c99090-f453-4231-9e3e-bab7be5d2eb5	d78a9d78-2e2a-4ae8-8852-7006e0d841ee	1	13c3c551-df0d-4c62-a185-d36a0298672a	f3d2726d-273b-4876-8181-2bad234708b5	f3d2726d-273b-4876-8181-2bad234708b5	2024-12-29 06:27:00+00	2025-02-04 03:00:00+00	MC	\N
59870a24-d01e-4f0c-bde2-77894ed8a208	ff3da8d4-a29b-42e5-aeca-4e7a68069654	1	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-06-18 22:31:00+00	2025-06-25 15:24:00+00	MC	\N
0e178dfb-d86c-43ac-9ded-1140bde8af5b	53aeca7b-eb90-41ae-a826-fac9bcabafae	1	cb20a7a1-e40f-4cb1-af07-8e5273dd0237	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-06-19 10:10:00+00	2025-07-02 09:55:00+00	MC	\N
68111420-d476-4a21-8fa8-9006817c97be	db77c250-a362-4b16-9e34-a2c474d343cc	1	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-06-18 19:04:00+00	2025-06-25 15:02:00+00	MC	\N
5e971266-d07b-4c80-b142-acedb09bc4bc	0a8c36ba-ecfc-4fc5-932e-a71d7cdf5f4a	1	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-06-18 21:10:00+00	2025-06-25 16:30:00+00	MC	\N
2ad9ef81-cf42-4515-9aa3-9758bba01566	9df62148-2ade-43dc-9013-2760050f7658	1	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	\N	\N	2024-07-04 11:58:00+00	2024-07-09 07:50:00+00	MC	\N
b2909a72-b728-4172-ac3c-9dd5068d5556	c6ca57c5-9568-478e-9814-d92624a8081b	2	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-07-04 22:41:00+00	2025-07-09 23:58:00+00	MC	\N
b494de48-7dd3-4a74-9f28-ac90866c699e	c6ca57c5-9568-478e-9814-d92624a8081b	1	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-06-27 20:45:00+00	2025-07-03 15:10:00+00	MC	\N
6d2f07a1-eba3-4851-8091-e965927e72be	11c8ead9-63e2-4aff-ba19-009c46f5c288	2	cb20a7a1-e40f-4cb1-af07-8e5273dd0237	aa748f6a-602b-4346-b964-50cbcea76146	aa748f6a-602b-4346-b964-50cbcea76146	2025-02-01 01:00:00+00	2025-02-23 21:00:00+00	MC	\N
a44fd426-6a88-4855-b7b4-152eb82cacc4	07dd69ed-a7c6-437e-9324-e9dde8b2a739	1	83867dcf-3fe0-4b78-8470-aabe5c344bda	\N	\N	2025-04-12 00:00:00+00	2025-05-18 00:00:00+00	MC	\N
01fb1689-4243-44fc-82bf-a596b4cf5b9c	d52d6553-242c-45ad-b151-ee30331c31f0	1	cb20a7a1-e40f-4cb1-af07-8e5273dd0237	792484d9-dc51-4a9d-b9a5-d28c9047bcf0	792484d9-dc51-4a9d-b9a5-d28c9047bcf0	2025-04-13 00:00:00+00	2025-05-21 00:00:00+00	MC	\N
7ddaea08-d95e-4b4e-b475-3e50634129bd	55fd91f2-630e-4c3a-88cd-ffdd92a812f6	2	13c3c551-df0d-4c62-a185-d36a0298672a	f3d2726d-273b-4876-8181-2bad234708b5	f3d2726d-273b-4876-8181-2bad234708b5	2025-04-28 19:15:00+00	2025-05-01 21:00:00+00	MC	\N
4f07046c-8241-4216-b68e-3006a3f74d1e	55fd91f2-630e-4c3a-88cd-ffdd92a812f6	1	13c3c551-df0d-4c62-a185-d36a0298672a	f3d2726d-273b-4876-8181-2bad234708b5	f3d2726d-273b-4876-8181-2bad234708b5	2025-04-09 22:00:00+00	2025-04-28 10:22:00+00	MC	\N
75352162-cd13-49f7-af85-89c8aa662ed4	8cc4851e-d918-461c-b788-7dc2961374fb	4	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-05-24 10:50:00+00	2025-05-30 01:42:00+00	MC	\N
b9fe0cf5-96b8-4832-8394-a0865a69d7f4	8cc4851e-d918-461c-b788-7dc2961374fb	3	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-05-22 14:42:00+00	2025-05-24 03:28:00+00	MC	\N
3f27adc5-8687-4fcd-948f-68523f6c0e10	8cc4851e-d918-461c-b788-7dc2961374fb	2	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-05-08 19:30:00+00	2025-05-17 12:08:00+00	MC	\N
2d3de6c0-301a-49f5-9093-3390bad69bec	8cc4851e-d918-461c-b788-7dc2961374fb	1	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-04-30 11:25:00+00	2025-05-06 13:20:00+00	MC	\N
6177de87-3b0f-4628-a085-0334f21abb0d	8de387fe-6e7b-477b-b812-01de6454c5be	2	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-06-27 13:45:00+00	2025-07-09 18:00:00+00	MC	\N
0bc1cd7d-452c-493e-8eef-ca23cb1150b6	8de387fe-6e7b-477b-b812-01de6454c5be	1	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-06-18 18:35:00+00	2025-06-25 15:55:00+00	MC	\N
c662dee4-fdff-445b-b243-31b260ef1ab2	890b8f6f-f171-4a76-9c01-f3fbbc074658	3	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-06-27 03:00:00+00	2025-07-04 03:00:00+00	MC	\N
2f5ff427-c36c-4b16-9ca3-13036136b659	890b8f6f-f171-4a76-9c01-f3fbbc074658	2	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	953117a0-3c04-4129-ab96-5eddf3a8d43a	4ad4e569-c081-4820-895e-e86131bc5b38	2025-06-23 03:00:00+00	2025-06-25 03:00:00+00	MC	\N
2c963608-e06e-49c3-96a6-d98c2e524e46	890b8f6f-f171-4a76-9c01-f3fbbc074658	1	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	4ad4e569-c081-4820-895e-e86131bc5b38	953117a0-3c04-4129-ab96-5eddf3a8d43a	2025-06-19 00:04:00+00	2025-06-21 15:03:00+00	MC	\N
2736f736-1d42-445b-8a43-e1a1de335f39	3a6a70ed-3411-4c55-b373-a58a59ad69b1	4	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-07-12 19:00:00+00	2025-07-16 04:10:00+00	MC	\N
0d65851d-7e9c-4007-b0e1-83f145fa24e2	3a6a70ed-3411-4c55-b373-a58a59ad69b1	3	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-07-09 19:55:00+00	2025-07-12 10:44:00+00	MC	\N
05ac6ba1-3493-4d88-896c-d1ad205de2f2	3a6a70ed-3411-4c55-b373-a58a59ad69b1	2	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-07-03 17:55:00+00	2025-07-09 10:40:00+00	MC	\N
b274ee1a-1d4a-44d9-aa9d-ebc6d10bc409	3a6a70ed-3411-4c55-b373-a58a59ad69b1	1	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-06-27 23:17:00+00	2025-07-03 07:19:00+00	MC	\N
9b13f4a6-44b4-4f34-ad78-0d104be3971f	cf876105-045b-4006-bab6-e7e6046ba59a	1	83867dcf-3fe0-4b78-8470-aabe5c344bda	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-07-10 15:05:00+00	2025-08-29 07:09:00+00	MC	\N
960c6179-ad00-48ef-ae90-71178b5c9df1	202291e5-c8e3-42ea-8414-1bc7327bb1fa	1	1985bde5-8964-4250-b775-74cc7469ed58	c08082e7-f85e-4434-ab74-860bc02f07a1	c08082e7-f85e-4434-ab74-860bc02f07a1	2025-07-14 09:50:00+00	2025-08-23 10:14:00+00	MC	\N
46f159b0-8dcc-4535-b65b-868755b6e05b	96decf3b-5fff-4464-9da7-fdb0f4c15634	1	83867dcf-3fe0-4b78-8470-aabe5c344bda	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-07-15 22:10:00+00	2025-08-28 14:13:00+00	MC	\N
50249ae6-80d0-4ceb-a64b-5e03a8bbedad	2b2a87c7-0939-41d3-9aa7-d066916160db	1	83867dcf-3fe0-4b78-8470-aabe5c344bda	\N	\N	2025-07-17 16:00:00+00	2025-09-04 08:40:00+00	MC	\N
6b1c2711-8388-424c-9597-b4a0a62c3f38	9cb89474-d62d-414e-a1da-ef5e9714ab2f	3	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-08-11 14:55:00+00	2025-08-17 08:08:00+00	MC	\N
54888ebf-b445-4b60-9de1-3b1f60f5d8a5	9cb89474-d62d-414e-a1da-ef5e9714ab2f	2	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-08-04 12:10:00+00	2025-08-10 08:26:00+00	MC	\N
8b869a54-46c1-462d-abe2-e8b03d72aae0	9cb89474-d62d-414e-a1da-ef5e9714ab2f	1	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-07-18 17:28:00+00	2025-07-25 11:28:00+00	MC	\N
dba1176e-9021-41d1-9597-ec036125b209	4b9cff2d-d996-4916-b84a-e368b6e6eee4	1	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-07-19 10:10:00+00	2025-08-23 08:15:00+00	MC	\N
e17b5bfa-b997-4720-9f89-d620c5b130db	ad5c2f47-6377-46d2-876b-185ea093ca7c	1	1985bde5-8964-4250-b775-74cc7469ed58	953117a0-3c04-4129-ab96-5eddf3a8d43a	953117a0-3c04-4129-ab96-5eddf3a8d43a	2025-06-05 18:42:00+00	2025-07-06 09:14:00+00	MC	\N
b049b0ec-801e-4ce4-be48-40050b33cea5	2ee02778-51f0-46d2-951d-0c3dfef5ad38	4	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-07-19 10:52:00+00	2025-07-25 15:09:00+00	MC	\N
4c6a2079-3dbd-4918-a3a0-1b1cebba7903	2ee02778-51f0-46d2-951d-0c3dfef5ad38	3	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-07-08 17:40:00+00	2025-07-16 20:34:00+00	MC	\N
eba360bc-2a66-4724-aeab-7196e3c939f5	2ee02778-51f0-46d2-951d-0c3dfef5ad38	2	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-06-25 20:39:00+00	2025-07-05 02:29:00+00	MC	\N
7fbfce29-65c1-4502-91dd-cea915d748da	2ee02778-51f0-46d2-951d-0c3dfef5ad38	1	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-06-13 17:00:00+00	2025-06-20 15:08:00+00	MC	\N
cf9dcfae-b36b-44ee-acd9-fa8a416ecfcc	23638708-b51b-494c-b782-13e83e2c6dd7	1	83867dcf-3fe0-4b78-8470-aabe5c344bda	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-05-31 20:30:00+00	2025-07-11 07:00:00+00	MC	\N
1a9956ef-5018-454b-b907-7f1e7018e494	fee69d57-0fcd-4e86-bb58-f29680b2aa65	1	13c3c551-df0d-4c62-a185-d36a0298672a	f3d2726d-273b-4876-8181-2bad234708b5	f3d2726d-273b-4876-8181-2bad234708b5	2025-01-31 17:45:00+00	2025-02-06 13:00:00+00	MC	Se desembarca por problemas de salud
3d7a3601-18f2-4b13-83b1-9104eb07ef1d	bdbe259e-6f9f-44b1-8015-cebefd9f61c2	1	cb20a7a1-e40f-4cb1-af07-8e5273dd0237	792484d9-dc51-4a9d-b9a5-d28c9047bcf0	792484d9-dc51-4a9d-b9a5-d28c9047bcf0	2025-02-08 00:00:00+00	2025-04-08 00:00:00+00	MC	\N
743e3662-af9f-4cc1-ac19-c4cff3772565	80581ca9-1851-45dc-b490-7d303a888518	5	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-07-30 08:29:00+00	2025-08-03 08:40:00+00	MC	\N
ff8ee586-e74b-4a62-a905-b80a3d02ee77	80581ca9-1851-45dc-b490-7d303a888518	4	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-07-25 15:52:00+00	2025-07-29 16:34:00+00	MC	\N
0057f085-aba6-46c5-aab0-dfc6cd857b7c	80581ca9-1851-45dc-b490-7d303a888518	3	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-07-21 13:55:00+00	2025-07-24 19:40:00+00	MC	\N
d87f0ac1-d12c-4d87-81ca-aaf1b1e5322b	80581ca9-1851-45dc-b490-7d303a888518	2	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-07-17 22:40:00+00	2025-07-21 06:10:00+00	MC	\N
12450a38-4cfd-48c9-af1c-d25b20025f50	80581ca9-1851-45dc-b490-7d303a888518	1	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-07-13 19:50:00+00	2025-07-17 15:03:00+00	MC	\N
098a2d20-abd7-42f2-96e9-a2d89553e5f2	0bd77f71-ee98-4a77-bee1-1abfbac1eb43	2	13c3c551-df0d-4c62-a185-d36a0298672a	aa748f6a-602b-4346-b964-50cbcea76146	aa748f6a-602b-4346-b964-50cbcea76146	2025-11-28 21:20:00+00	2025-12-21 23:30:00+00	MC	\N
4a750892-beda-479d-9b8c-d52c574c674d	0bd77f71-ee98-4a77-bee1-1abfbac1eb43	1	13c3c551-df0d-4c62-a185-d36a0298672a	aa748f6a-602b-4346-b964-50cbcea76146	aa748f6a-602b-4346-b964-50cbcea76146	2025-11-08 00:00:00+00	2025-11-26 00:00:00+00	MC	\N
e6719acc-527f-4ae7-8eb1-3abf41c7c2a5	8a6e79e2-7d61-462f-9441-15eb9db3813c	2	83867dcf-3fe0-4b78-8470-aabe5c344bda	4ad4e569-c081-4820-895e-e86131bc5b38	\N	2026-01-19 03:00:00+00	\N	MC	
4077a07f-24d6-4de2-a9b4-e6bc686f13f0	8a6e79e2-7d61-462f-9441-15eb9db3813c	1	83867dcf-3fe0-4b78-8470-aabe5c344bda	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2026-01-16 03:00:00+00	2026-01-19 03:00:00+00	MC	
f3a708dc-9fc1-4ef7-a24a-4da47bfd6e46	fd80d971-0822-45a4-99e9-1c87ab8aa701	1	cb20a7a1-e40f-4cb1-af07-8e5273dd0237	792484d9-dc51-4a9d-b9a5-d28c9047bcf0	\N	2026-01-05 00:00:00+00	\N	MC	
804605f4-d689-4b79-8889-832061db2299	8cf51ad1-3e30-4eb1-aa50-057f236054b0	1	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	aa748f6a-602b-4346-b964-50cbcea76146	2026-01-06 03:00:00+00	2026-01-14 16:15:00+00	MC	\N
f67efbc3-4d46-4ed7-8a74-22fee27f909b	8cf51ad1-3e30-4eb1-aa50-057f236054b0	2	1985bde5-8964-4250-b775-74cc7469ed58	aa748f6a-602b-4346-b964-50cbcea76146	\N	2026-01-16 03:00:00+00	\N	MC	\N
7eea183b-6442-4b28-8e8f-d85afe23bf00	8e08a989-1f06-4d01-bdc8-620650f4c872	1	cb20a7a1-e40f-4cb1-af07-8e5273dd0237	792484d9-dc51-4a9d-b9a5-d28c9047bcf0	\N	2026-01-21 03:00:00+00	\N	MC	
65028900-935e-4b8e-8804-cf620a68ea36	fca98c94-3979-4e49-882c-f0cc4c0dbe97	1	83867dcf-3fe0-4b78-8470-aabe5c344bda	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-12-15 14:50:00+00	2026-01-20 03:00:00+00	MC	
ea8f7134-84d8-47fe-927a-7c257c052be9	68e36007-c8a0-4df3-865f-998dc50adbbf	3	1985bde5-8964-4250-b775-74cc7469ed58	4a66c074-2c54-4ee1-bd44-9fe59a8de18f	\N	2026-01-20 03:00:00+00	\N	MC	
7c0dccca-15de-453b-9d37-62d58572675c	68e36007-c8a0-4df3-865f-998dc50adbbf	2	1985bde5-8964-4250-b775-74cc7469ed58	4a66c074-2c54-4ee1-bd44-9fe59a8de18f	4a66c074-2c54-4ee1-bd44-9fe59a8de18f	2026-01-13 18:27:00+00	2026-01-18 15:23:00+00	MC	
b1e17555-09ad-44dd-9395-f947902c61a9	68e36007-c8a0-4df3-865f-998dc50adbbf	1	1985bde5-8964-4250-b775-74cc7469ed58	4cda5033-1882-436d-b1ce-c7ec772cb8fa	4a66c074-2c54-4ee1-bd44-9fe59a8de18f	2026-01-06 15:00:00+00	2026-01-12 18:19:00+00	MC	
7b3473f2-e48f-4580-a007-425b709fd891	dd8ac789-934e-4807-b229-809487d35b8f	1	127f273e-086c-4e23-bb9e-0557fc9270aa	aa748f6a-602b-4346-b964-50cbcea76146	aa748f6a-602b-4346-b964-50cbcea76146	2025-12-30 09:45:00+00	2026-01-22 03:00:00+00	MC	
d1f143ea-6e33-4e8e-b9b5-1c283ca34163	48efa277-e6aa-4814-b490-edf2a4a31318	1	cb20a7a1-e40f-4cb1-af07-8e5273dd0237	792484d9-dc51-4a9d-b9a5-d28c9047bcf0	792484d9-dc51-4a9d-b9a5-d28c9047bcf0	2025-11-23 00:30:00+00	2026-01-12 20:00:00+00	MC	
f6cd7c78-923f-42e4-b76d-1580d8ebe271	2f26774c-4c79-4019-907e-34a81c0fb8ee	1	cb20a7a1-e40f-4cb1-af07-8e5273dd0237	792484d9-dc51-4a9d-b9a5-d28c9047bcf0	792484d9-dc51-4a9d-b9a5-d28c9047bcf0	2025-11-27 22:30:00+00	2026-01-18 03:00:00+00	MC	
5be0282e-bcd6-499e-8355-b24f6faaeba8	3e06427d-367c-48dd-ba35-48fcd50caff1	1	83867dcf-3fe0-4b78-8470-aabe5c344bda	792484d9-dc51-4a9d-b9a5-d28c9047bcf0	\N	2025-12-16 07:30:00+00	\N	MC	
0fd3e6a6-699f-46c3-b275-427d6e3fedd6	8f90beb5-b58a-4b49-bfdb-fcf1acbe4630	1	127f273e-086c-4e23-bb9e-0557fc9270aa	4ad4e569-c081-4820-895e-e86131bc5b38	\N	2025-12-29 00:00:00+00	\N	MC	
10ece3a9-adc4-40fc-9fab-5b2107032bf8	7a65e5f9-92de-40df-8378-0441eb753710	2	13c3c551-df0d-4c62-a185-d36a0298672a	4a66c074-2c54-4ee1-bd44-9fe59a8de18f	\N	2026-01-17 13:01:00+00	\N	MC	
ec549980-262f-4c32-bac2-f5ce20e5a051	843119e3-8559-4305-823f-8cdd721fe5ae	4	13c3c551-df0d-4c62-a185-d36a0298672a	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-02-06 14:23:00+00	2025-02-22 11:35:00+00	MC	\N
a0ceb9d8-1a55-4eef-b2ff-d7b11bbe38f7	843119e3-8559-4305-823f-8cdd721fe5ae	3	13c3c551-df0d-4c62-a185-d36a0298672a	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-01-14 13:40:00+00	2025-02-04 08:15:00+00	MC	\N
400f203e-31a6-4293-97af-9ce35885fdb1	843119e3-8559-4305-823f-8cdd721fe5ae	2	13c3c551-df0d-4c62-a185-d36a0298672a	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-01-08 15:45:00+00	2025-01-13 08:30:00+00	MC	\N
510d036b-cc2c-42bb-b132-1f8b6e80ea29	843119e3-8559-4305-823f-8cdd721fe5ae	1	13c3c551-df0d-4c62-a185-d36a0298672a	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-01-04 13:43:00+00	2025-01-08 01:02:00+00	MC	\N
ae39774e-af5e-4122-af44-eb20016b90b6	9d5b7aa8-fbbc-443c-a350-9ac4f2f8181a	1	cb20a7a1-e40f-4cb1-af07-8e5273dd0237	aa748f6a-602b-4346-b964-50cbcea76146	aa748f6a-602b-4346-b964-50cbcea76146	2026-01-03 17:30:00+00	\N	MC	\N
3ccda49e-6a4a-4d4e-ad81-252ed30a7c25	7d2df6b7-0671-4978-9d88-31684e298979	1	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	aa748f6a-602b-4346-b964-50cbcea76146	aa748f6a-602b-4346-b964-50cbcea76146	2025-09-06 08:00:00+00	2025-09-15 07:00:00+00	MC	\N
36f02a76-9a98-462f-baf0-d2f59a9b9baf	d305ef9a-5850-450a-b870-1ce6214029f1	6	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	\N	\N	2025-09-26 11:00:00+00	2025-10-07 12:18:00+00	MC	\N
96ca93b5-6845-4cc5-a37d-8fa867e8c43e	d305ef9a-5850-450a-b870-1ce6214029f1	5	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	\N	\N	2025-09-08 22:05:00+00	2025-09-23 18:55:00+00	MC	\N
fb62b9f5-2721-459f-b6e3-b473a9c9727c	d305ef9a-5850-450a-b870-1ce6214029f1	4	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	\N	\N	2025-08-26 23:50:00+00	2025-09-07 08:15:00+00	MC	\N
8106202f-18de-497b-8dae-b7fb238e313c	d305ef9a-5850-450a-b870-1ce6214029f1	3	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	\N	\N	2025-08-13 18:21:00+00	2025-08-26 03:25:00+00	MC	\N
27bdb468-b304-42ef-8891-115c5edd382f	d305ef9a-5850-450a-b870-1ce6214029f1	2	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	\N	\N	2025-08-12 21:44:00+00	2025-08-12 23:11:00+00	MC	\N
8ee5abcb-50c9-4f46-ab11-a5865be320f0	d305ef9a-5850-450a-b870-1ce6214029f1	1	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	\N	\N	2025-07-24 13:40:00+00	2025-08-09 23:30:00+00	MC	\N
9e8afabd-b0d0-4fa0-aecd-cb422d0d3c34	70565483-1c48-4cdd-ad5c-b904cd1b6c03	1	3750f533-77c8-405f-8a00-bf0ba0353a4d	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2024-10-21 00:00:00+00	2024-11-29 00:00:00+00	MC	\N
22d4015b-e7ef-4338-8cf5-aa6d5cf4d7ec	e6cd8178-47fd-4e1f-a641-63b45db13b08	1	13c3c551-df0d-4c62-a185-d36a0298672a	f3d2726d-273b-4876-8181-2bad234708b5	f3d2726d-273b-4876-8181-2bad234708b5	2026-01-06 18:15:00+00	\N	MC	\N
c06ea48a-d23b-4702-a536-974078a38c6c	d62f27cc-89d8-411f-ab23-d9c982ea4722	1	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2026-01-06 21:46:00+00	\N	MC	\N
4dc6dbc4-52dd-4004-b577-1c395dbfcc31	3ac7d6c8-160e-4188-a7c2-71651f8ff9a3	1	127f273e-086c-4e23-bb9e-0557fc9270aa	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2026-01-06 19:50:00+00	\N	MC	\N
a689bf9c-b461-4dc6-bddc-c8022f194b6d	f15b7a2c-1745-48ce-bb0b-36b8313a66be	1	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2024-07-02 20:50:00+00	2024-07-31 16:31:00+00	MC	\N
07559c30-f351-4e51-a54d-1094b68b4b45	38da7911-3796-4e05-b527-e12b97f77148	1	83867dcf-3fe0-4b78-8470-aabe5c344bda	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-03-06 18:20:00+00	2025-04-13 23:40:00+00	MC	\N
edf0ae52-96e5-48e0-929e-405d7cb8328e	1946b945-d4b0-4d9d-88af-7d28ed6f91bd	1	13c3c551-df0d-4c62-a185-d36a0298672a	f3d2726d-273b-4876-8181-2bad234708b5	f3d2726d-273b-4876-8181-2bad234708b5	2024-10-03 20:30:00+00	2024-10-29 12:55:00+00	MC	\N
ae14797f-0fea-4e2d-b449-ef55bf3c5593	e80c962c-c948-40df-b845-a5e1cf9ecda1	2	13c3c551-df0d-4c62-a185-d36a0298672a	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-09-13 00:00:00+00	2025-10-12 00:00:00+00	MC	\N
cca50426-8ba9-46a5-94f0-4318ae20eb5c	e80c962c-c948-40df-b845-a5e1cf9ecda1	1	13c3c551-df0d-4c62-a185-d36a0298672a	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2024-10-04 19:18:00+00	2024-10-28 20:00:00+00	MC	\N
6ac79f4f-4d40-47d3-a335-10d3497b0962	519207f0-5525-49a1-9a73-dc5677c8052a	2	13c3c551-df0d-4c62-a185-d36a0298672a	f3d2726d-273b-4876-8181-2bad234708b5	f3d2726d-273b-4876-8181-2bad234708b5	2025-09-18 00:00:00+00	2025-10-10 00:00:00+00	MC	\N
4ac4fc81-c1ed-410f-9325-f6dde98c4f93	519207f0-5525-49a1-9a73-dc5677c8052a	1	13c3c551-df0d-4c62-a185-d36a0298672a	f3d2726d-273b-4876-8181-2bad234708b5	f3d2726d-273b-4876-8181-2bad234708b5	2024-10-08 21:25:00+00	2024-10-29 07:00:00+00	MC	\N
e0f18dff-4b7e-42f8-a2a9-da39a4aecb43	c279aa7d-4b40-4ef6-a258-dcc99fecf12e	1	13c3c551-df0d-4c62-a185-d36a0298672a	f3d2726d-273b-4876-8181-2bad234708b5	f3d2726d-273b-4876-8181-2bad234708b5	2024-08-02 13:25:00+00	2024-12-15 11:05:00+00	MC	\N
f15f9dcc-b729-486d-9d2b-6ee057fe5974	a99d8ff2-a070-4fa5-b63d-8e995754d143	1	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-07-19 17:00:00+00	2025-08-19 14:02:00+00	MC	\N
1f279c09-3956-4704-ba4c-4a34c5158e11	aea55b70-cb05-4ddd-bca5-7f8150d51c25	4	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-07-17 01:02:00+00	2025-07-20 12:40:00+00	MC	\N
b189efe2-57ec-4676-af42-358c6c5bc1ca	aea55b70-cb05-4ddd-bca5-7f8150d51c25	3	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-07-11 08:32:00+00	2025-07-16 12:21:00+00	MC	\N
7e3f480d-2745-43fb-8f87-67fc96f02872	aea55b70-cb05-4ddd-bca5-7f8150d51c25	2	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-07-04 22:41:00+00	2025-07-10 05:37:00+00	MC	\N
ce7f5c44-d659-465c-a452-e22b30bd4978	aea55b70-cb05-4ddd-bca5-7f8150d51c25	1	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-06-27 22:43:00+00	2025-07-03 15:28:00+00	MC	\N
c603d5ac-88a1-4992-8179-889facf803da	85262687-d1c9-47bf-8150-3ef63dcf0729	1	13c3c551-df0d-4c62-a185-d36a0298672a	f3d2726d-273b-4876-8181-2bad234708b5	f3d2726d-273b-4876-8181-2bad234708b5	2024-10-03 15:15:00+00	2024-10-26 06:59:00+00	MC	\N
c07cf1b1-507e-4f3a-a25e-d9a92255abf4	8b3f1a6a-94ca-435d-88ee-1073be5e6b1c	1	13c3c551-df0d-4c62-a185-d36a0298672a	f3d2726d-273b-4876-8181-2bad234708b5	f3d2726d-273b-4876-8181-2bad234708b5	2024-11-04 05:55:00+00	2024-11-28 19:40:00+00	MC	\N
789a4327-3d8a-4f60-a481-501053501d41	9f980d1b-c296-4220-8d3d-2073323dde53	1	83867dcf-3fe0-4b78-8470-aabe5c344bda	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-11-10 19:15:00+00	2025-12-12 12:00:00+00	MC	\N
ed0aca05-b7bd-4636-9593-15378b111dfd	c8626863-6de0-4db6-9da9-36f4fae1d429	1	13c3c551-df0d-4c62-a185-d36a0298672a	f3d2726d-273b-4876-8181-2bad234708b5	f3d2726d-273b-4876-8181-2bad234708b5	2025-10-23 14:05:00+00	2025-11-24 09:40:00+00	MC	\N
69da5e63-b76a-4d44-b8c7-11e6b74df1b5	347a3b51-068b-4061-b5ee-d4bc9d85f91e	5	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	f3d2726d-273b-4876-8181-2bad234708b5	f3d2726d-273b-4876-8181-2bad234708b5	2025-08-14 12:50:00+00	2025-08-20 16:20:00+00	MC	\N
c0a41599-72e4-463c-bbbe-7b3d6d17cbe7	347a3b51-068b-4061-b5ee-d4bc9d85f91e	4	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	f3d2726d-273b-4876-8181-2bad234708b5	f3d2726d-273b-4876-8181-2bad234708b5	2025-08-07 20:12:00+00	2025-08-13 11:10:00+00	MC	\N
22ecf905-4f83-4cd7-8535-666af6381102	347a3b51-068b-4061-b5ee-d4bc9d85f91e	3	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	f3d2726d-273b-4876-8181-2bad234708b5	f3d2726d-273b-4876-8181-2bad234708b5	2025-07-30 23:36:00+00	2025-08-06 19:45:00+00	MC	\N
2b464065-8c9e-4cbc-a496-53a7878515c0	347a3b51-068b-4061-b5ee-d4bc9d85f91e	2	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	f3d2726d-273b-4876-8181-2bad234708b5	f3d2726d-273b-4876-8181-2bad234708b5	2025-07-19 00:20:00+00	2025-07-29 23:35:00+00	MC	\N
454d2117-b26a-4c80-8740-512b83542f4c	347a3b51-068b-4061-b5ee-d4bc9d85f91e	1	f9515f1d-0e10-41a6-92b1-2f512a4f25c4	f3d2726d-273b-4876-8181-2bad234708b5	f3d2726d-273b-4876-8181-2bad234708b5	2025-07-11 18:30:00+00	2025-07-18 00:40:00+00	MC	\N
d7dadc81-e629-43a1-8605-acda1ce3561c	28fdcb18-d8e2-4b94-97a5-7fa0f94b3efe	3	13c3c551-df0d-4c62-a185-d36a0298672a	f3d2726d-273b-4876-8181-2bad234708b5	f3d2726d-273b-4876-8181-2bad234708b5	2025-09-15 00:00:00+00	2025-10-10 00:00:00+00	MC	\N
8a80cfeb-d317-43c6-9a92-425716162511	28fdcb18-d8e2-4b94-97a5-7fa0f94b3efe	1	13c3c551-df0d-4c62-a185-d36a0298672a	f3d2726d-273b-4876-8181-2bad234708b5	f3d2726d-273b-4876-8181-2bad234708b5	2024-10-06 22:40:00+00	2024-10-31 08:40:00+00	MC	\N
bfcb49c2-9062-46d2-a82f-60a8a979245b	06450b8c-301e-4bb0-bf9a-15bc1d5fa7a9	1	83867dcf-3fe0-4b78-8470-aabe5c344bda	\N	\N	2025-04-16 00:00:00+00	2025-05-16 00:00:00+00	MC	\N
0e990b95-7886-46ee-a390-b14f946505c4	d24e14d1-7d1a-4265-8364-965765f5548e	1	13c3c551-df0d-4c62-a185-d36a0298672a	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-03-06 13:02:00+00	2025-03-26 17:12:00+00	MC	\N
4e90b290-d7c1-4a60-8a85-3505ac7a216b	020f5b3a-817d-4ef4-9308-d7da35261b8a	1	cb20a7a1-e40f-4cb1-af07-8e5273dd0237	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2025-10-30 08:05:00+00	2025-11-19 07:17:00+00	MC	\N
f3df73e8-a1a7-4d52-9c7c-c918f45f26f2	5375bc9a-34b7-489a-9989-87215650a63d	1	13c3c551-df0d-4c62-a185-d36a0298672a	f3d2726d-273b-4876-8181-2bad234708b5	f3d2726d-273b-4876-8181-2bad234708b5	2024-10-31 00:16:00+00	2024-11-26 20:20:00+00	MC	\N
e7eb589b-7b6a-481f-925d-c469d89cddb7	2a5635f9-466a-4f43-9ed6-faf9157e30af	1	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2024-11-01 16:38:00+00	2024-11-07 08:00:00+00	MC	\N
4ffdd9fc-5508-4006-beb4-03225e432d4c	ef369980-3be8-421c-8f75-ffc239043303	1	13c3c551-df0d-4c62-a185-d36a0298672a	f3d2726d-273b-4876-8181-2bad234708b5	f3d2726d-273b-4876-8181-2bad234708b5	2024-11-20 07:15:00+00	2024-12-10 13:30:00+00	MC	\N
7ae81806-01a0-47b4-b5b1-3bbe2ad80e95	51e88a0f-d28d-4638-8865-d4cc7e8e1bb8	1	13c3c551-df0d-4c62-a185-d36a0298672a	f3d2726d-273b-4876-8181-2bad234708b5	f3d2726d-273b-4876-8181-2bad234708b5	2024-10-28 20:10:00+00	2024-11-22 06:00:00+00	MC	\N
a00595a1-8208-45b6-9179-bd6b7a294112	317b1c0b-a899-4d1f-80f9-b3473921ff73	1	cb20a7a1-e40f-4cb1-af07-8e5273dd0237	792484d9-dc51-4a9d-b9a5-d28c9047bcf0	\N	2025-12-30 18:05:00+00	\N	MC	\N
5805fed1-5d1d-4f90-8556-61c1a0373803	49097f16-3982-4fc0-91cc-ea400517493c	1	127f273e-086c-4e23-bb9e-0557fc9270aa	4ad4e569-c081-4820-895e-e86131bc5b38	aa748f6a-602b-4346-b964-50cbcea76146	2025-12-29 00:00:00+00	2026-01-22 03:00:00+00	MC	
6ed8d3f6-a078-4e88-8f32-5b61cf2e2e88	aea183a8-53d7-45c9-9626-a7c9615929e4	1	cb20a7a1-e40f-4cb1-af07-8e5273dd0237	aa748f6a-602b-4346-b964-50cbcea76146	aa748f6a-602b-4346-b964-50cbcea76146	2024-09-05 12:26:00+00	2024-09-25 08:50:00+00	MC	\N
865c86b0-a064-4958-9056-b28292be8200	e45e3637-a667-4169-87fb-9512df52de90	1	cb20a7a1-e40f-4cb1-af07-8e5273dd0237	792484d9-dc51-4a9d-b9a5-d28c9047bcf0	792484d9-dc51-4a9d-b9a5-d28c9047bcf0	2024-03-26 22:35:00+00	2024-05-15 23:00:00+00	MC	\N
ca8fc2da-17dc-4a08-ad95-ab44688369ee	883166f6-5ec0-44fd-984f-e8e8a75a28df	1	cb20a7a1-e40f-4cb1-af07-8e5273dd0237	792484d9-dc51-4a9d-b9a5-d28c9047bcf0	792484d9-dc51-4a9d-b9a5-d28c9047bcf0	2024-05-17 18:30:00+00	2024-07-02 05:25:00+00	MC	\N
0289311d-1e1d-40e9-b881-d9cb4f9bb030	54df0379-3ab1-48b0-a1d6-7abb1693a501	1	83867dcf-3fe0-4b78-8470-aabe5c344bda	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2024-01-03 19:15:00+00	2024-01-23 13:30:00+00	MC	\N
1abd27ef-b0e2-4e5a-a872-d72475aa713d	5dd1781f-bf16-43d5-9dd9-0af6015e0253	1	83867dcf-3fe0-4b78-8470-aabe5c344bda	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2024-02-16 18:45:00+00	2024-03-24 14:45:00+00	MC	\N
464bd619-67ec-49f7-b835-8402c425f6ec	e6802052-f25b-4bf1-8c9e-8e8a85392008	1	83867dcf-3fe0-4b78-8470-aabe5c344bda	4ad4e569-c081-4820-895e-e86131bc5b38	4ad4e569-c081-4820-895e-e86131bc5b38	2024-03-28 17:55:00+00	2024-05-09 21:45:00+00	MC	\N
5ceb69dc-9571-4b0e-ab42-3e6319664d68	7a65e5f9-92de-40df-8378-0441eb753710	1	13c3c551-df0d-4c62-a185-d36a0298672a	aa748f6a-602b-4346-b964-50cbcea76146	4a66c074-2c54-4ee1-bd44-9fe59a8de18f	2025-12-30 22:10:00+00	2026-01-15 17:03:00+00	MC	
b2c858e6-61d6-4660-bca5-428c8acd1996	8d0f0c3c-e975-4b8b-b7c5-15fc642bd830	2	83867dcf-3fe0-4b78-8470-aabe5c344bda	792484d9-dc51-4a9d-b9a5-d28c9047bcf0	4ad4e569-c081-4820-895e-e86131bc5b38	2025-12-04 20:10:00+00	2025-12-11 03:00:00+00	MC	
be13f756-cad3-458f-8178-281af8cedf61	8d0f0c3c-e975-4b8b-b7c5-15fc642bd830	1	83867dcf-3fe0-4b78-8470-aabe5c344bda	792484d9-dc51-4a9d-b9a5-d28c9047bcf0	792484d9-dc51-4a9d-b9a5-d28c9047bcf0	2025-10-30 21:10:00+00	2025-12-04 20:10:00+00	MC	
f62b2ebf-834d-4bf4-afb6-f52d4cfd2f09	2f6ab9b8-a5e8-4118-92e5-3474dfd4af50	1	1985bde5-8964-4250-b775-74cc7469ed58	4ad4e569-c081-4820-895e-e86131bc5b38	\N	2026-01-19 03:00:00+00	\N	MC	
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
0984e856-5823-47fc-85f0-4a6ef474d637	49097f16-3982-4fc0-91cc-ea400517493c	2026-01-22 20:39:09.901+00	20feb9da-69af-4b7e-9f9f-47ec73ae954f	EDICION_ESTRUCTURA	\N	\N	\N	Edición manual de etapas y fechas de observador.	\N
f2598fbc-25b9-45da-a336-fe44b93cdd8a	2051da06-42ad-4e62-9cae-c6db658936c0	2026-01-17 22:44:23.75+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CAMBIO_ESTADO	0e446e48-221f-4190-9d34-17af75f9a406	9acdf957-9a1a-4786-8463-f69262b0d65d	\N	Inicio Marea. Obs: 15/1/2026	\N
87b4ffea-4812-4f16-a1f6-8a9f0e3536df	2051da06-42ad-4e62-9cae-c6db658936c0	2026-01-17 22:43:54.272+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	0e446e48-221f-4190-9d34-17af75f9a406	\N	Marea creada por Administrador Sistema	\N
1b7bf545-9496-4ab8-b89e-bca4ee6d334b	f82d0e5c-f8d3-427a-976f-254202b454b4	2026-01-22 18:04:01.867+00	20feb9da-69af-4b7e-9f9f-47ec73ae954f	CAMBIO_ESTADO	9acdf957-9a1a-4786-8463-f69262b0d65d	94c1d788-a09b-4d7d-a45a-fab7eeeab437	\N	Fin Marea. Obs: Sin fecha definida	\N
48364098-29b2-4f10-98e8-43c88d5fdc2d	2d704937-98e2-451f-87b2-4c5bcbf9ceb0	2026-01-22 20:41:37.923+00	20feb9da-69af-4b7e-9f9f-47ec73ae954f	EDICION_ESTRUCTURA	\N	\N	\N	Edición manual de etapas y fechas de observador.	\N
95daeeaa-9a64-426f-aa06-a474cb8886ce	56179c3f-3e6a-4a21-bc62-8ce00aea1c67	2026-01-22 20:38:21.754+00	20feb9da-69af-4b7e-9f9f-47ec73ae954f	EDICION_ESTRUCTURA	\N	\N	\N	Edición manual de etapas y fechas de observador.	\N
d013b567-71b3-4e0c-87b1-22856e672ac5	8017564a-6168-4454-a6a3-6bf4505d1f03	2026-01-22 20:39:52.971+00	20feb9da-69af-4b7e-9f9f-47ec73ae954f	EDICION_ESTRUCTURA	\N	\N	\N	Edición manual de etapas y fechas de observador.	\N
de6ea933-a31c-43c8-9c26-35f6b6821943	25e40b6e-feee-4555-a6ba-62bfbc7f58ef	2026-01-22 20:40:32.56+00	20feb9da-69af-4b7e-9f9f-47ec73ae954f	EDICION_ESTRUCTURA	\N	\N	\N	Edición manual de etapas y fechas de observador.	\N
6fdc1613-bb10-4332-a39e-1ff3bf1fd51d	8c6f48f4-807c-4012-865a-3a3420d96bab	2026-01-22 22:42:44.301+00	20feb9da-69af-4b7e-9f9f-47ec73ae954f	EDICION_ESTRUCTURA	\N	\N	\N	Edición manual de etapas y fechas de observador.	\N
5b90a07e-b9e4-42e8-8f00-724bf95b58f3	8c6f48f4-807c-4012-865a-3a3420d96bab	2026-01-22 20:40:44.429+00	20feb9da-69af-4b7e-9f9f-47ec73ae954f	EDICION_ESTRUCTURA	\N	\N	\N	Edición manual de etapas y fechas de observador.	\N
93ee1515-9f6a-4d28-ae50-030b2e4794d9	421cb77c-8989-4d2c-87d8-2db539173f65	2026-01-18 23:16:21.546+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CAMBIO_ESTADO	0e446e48-221f-4190-9d34-17af75f9a406	c56c252a-8a98-4dd6-9c2d-de6135686d71	\N	Acción: Cancelar	\N
f5eab502-cf07-486e-9d6e-10864e955978	421cb77c-8989-4d2c-87d8-2db539173f65	2026-01-18 23:06:52.011+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	0e446e48-221f-4190-9d34-17af75f9a406	\N	Marea creada por Administrador Sistema	\N
d7fef3c9-26f8-4532-85b1-4c6379076dfb	256ea07a-1bfa-476e-95b6-3f74cfd49224	2026-01-19 11:12:10.343+00	20feb9da-69af-4b7e-9f9f-47ec73ae954f	CAMBIO_ESTADO	0e446e48-221f-4190-9d34-17af75f9a406	c56c252a-8a98-4dd6-9c2d-de6135686d71	\N	Acción: Cancelar	\N
fa1020e1-fa3a-431b-b60f-4acd55dd7cda	256ea07a-1bfa-476e-95b6-3f74cfd49224	2026-01-18 23:14:15.911+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	0e446e48-221f-4190-9d34-17af75f9a406	\N	Marea creada por Administrador Sistema	\N
f84a02a3-96a7-4a1a-b402-c00706a66e77	948c2dcb-95f6-4baa-bd94-2c72d4b6f8b6	2026-01-20 02:54:26.486+00	20feb9da-69af-4b7e-9f9f-47ec73ae954f	CREACION	\N	0e446e48-221f-4190-9d34-17af75f9a406	\N	Marea creada por Daniel Di Tullio	\N
6c8610bd-c593-4dc7-8aaf-36c31dc84467	8a6e79e2-7d61-462f-9441-15eb9db3813c	2026-01-20 12:55:27.212+00	20feb9da-69af-4b7e-9f9f-47ec73ae954f	EDICION_ESTRUCTURA	\N	\N	\N	Edición manual de etapas y fechas de observador.	\N
0282d89c-2f91-424e-8325-5a50fbae3702	8a6e79e2-7d61-462f-9441-15eb9db3813c	2026-01-20 02:56:32.725+00	20feb9da-69af-4b7e-9f9f-47ec73ae954f	CAMBIO_ESTADO	0e446e48-221f-4190-9d34-17af75f9a406	9acdf957-9a1a-4786-8463-f69262b0d65d	\N	Inicio Marea. Obs: 16/1/2026	\N
61644f6c-d03f-4a3e-a839-027ddd9b8a63	8a6e79e2-7d61-462f-9441-15eb9db3813c	2026-01-20 02:53:42.401+00	20feb9da-69af-4b7e-9f9f-47ec73ae954f	CREACION	\N	0e446e48-221f-4190-9d34-17af75f9a406	\N	Marea creada por Daniel Di Tullio	\N
0e5c65a5-8dd8-489e-b2fe-bdeec5c4f5bd	fd80d971-0822-45a4-99e9-1c87ab8aa701	2026-01-20 12:58:02.996+00	20feb9da-69af-4b7e-9f9f-47ec73ae954f	EDICION_ESTRUCTURA	\N	\N	\N	Edición manual de etapas y fechas de observador.	\N
07492ca2-b159-4dc1-8094-9b5db2bebdbb	8e08a989-1f06-4d01-bdc8-620650f4c872	2026-01-22 12:40:52.878+00	20feb9da-69af-4b7e-9f9f-47ec73ae954f	CAMBIO_ESTADO	0e446e48-221f-4190-9d34-17af75f9a406	9acdf957-9a1a-4786-8463-f69262b0d65d	\N	Inicio Marea. Obs: 15/1/2026	\N
2d6d4e44-686a-49b1-b33a-377aade7f839	8e08a989-1f06-4d01-bdc8-620650f4c872	2026-01-20 02:49:38.151+00	20feb9da-69af-4b7e-9f9f-47ec73ae954f	CREACION	\N	0e446e48-221f-4190-9d34-17af75f9a406	\N	Marea creada por Daniel Di Tullio	\N
9a0684e9-5808-48ec-97a8-3477efcbf916	fca98c94-3979-4e49-882c-f0cc4c0dbe97	2026-01-22 12:42:16.468+00	20feb9da-69af-4b7e-9f9f-47ec73ae954f	CAMBIO_ESTADO	9acdf957-9a1a-4786-8463-f69262b0d65d	94c1d788-a09b-4d7d-a45a-fab7eeeab437	\N	Fin Marea. Obs: 20/1/2026	\N
f0252c72-1a66-41b7-ab0d-8c91c4edbef4	68e36007-c8a0-4df3-865f-998dc50adbbf	2026-01-22 12:43:34.549+00	20feb9da-69af-4b7e-9f9f-47ec73ae954f	EDICION_ESTRUCTURA	\N	\N	\N	Edición manual de etapas y fechas de observador.	\N
b5ca0b86-2098-45cb-aaed-f398ab4715af	dd8ac789-934e-4807-b229-809487d35b8f	2026-01-22 12:49:47.813+00	20feb9da-69af-4b7e-9f9f-47ec73ae954f	EDICION_ESTRUCTURA	\N	\N	\N	Edición manual de etapas y fechas de observador.	\N
ff50152f-7912-475c-9379-29c9d1f51477	48efa277-e6aa-4814-b490-edf2a4a31318	2026-01-22 17:05:41.137+00	20feb9da-69af-4b7e-9f9f-47ec73ae954f	CAMBIO_ESTADO	80836557-9617-4c74-a903-089230c085b3	57669ce7-ad00-4862-a3b7-ded380ddb616	\N	Acción: Enviar a Revisión	\N
e348dee4-71cc-41d6-8bd4-9a38e7bf1598	48efa277-e6aa-4814-b490-edf2a4a31318	2026-01-20 11:17:26.721+00	20feb9da-69af-4b7e-9f9f-47ec73ae954f	CAMBIO_ESTADO	fdf092bc-e7f6-4d03-8cda-9f25d483cecf	80836557-9617-4c74-a903-089230c085b3	\N	Acción: Pasar a Informe	\N
b154707a-8efb-4e03-910a-c24e2a95a40d	48efa277-e6aa-4814-b490-edf2a4a31318	2026-01-20 11:17:02.329+00	20feb9da-69af-4b7e-9f9f-47ec73ae954f	CAMBIO_ESTADO	2580411e-8f93-49c9-ab14-6d247ed373ae	fdf092bc-e7f6-4d03-8cda-9f25d483cecf	\N	Acción: Iniciar Verificación	\N
1dc097df-0e65-4ebb-a467-a6b305305869	48efa277-e6aa-4814-b490-edf2a4a31318	2026-01-20 11:03:24.43+00	20feb9da-69af-4b7e-9f9f-47ec73ae954f	CAMBIO_ESTADO	94c1d788-a09b-4d7d-a45a-fab7eeeab437	2580411e-8f93-49c9-ab14-6d247ed373ae	\N	Acción: Recibir Archivos de Marea	\N
8de3eb60-0431-4a61-9da4-660676c66e75	48efa277-e6aa-4814-b490-edf2a4a31318	2026-01-19 16:09:29.173+00	20feb9da-69af-4b7e-9f9f-47ec73ae954f	CAMBIO_ESTADO	9acdf957-9a1a-4786-8463-f69262b0d65d	94c1d788-a09b-4d7d-a45a-fab7eeeab437	\N	Fin Marea. Obs: 16/1/2026	\N
9044f07e-ab07-4662-a79d-4f48ab7ae0c4	2f26774c-4c79-4019-907e-34a81c0fb8ee	2026-01-22 14:23:24.582+00	20feb9da-69af-4b7e-9f9f-47ec73ae954f	CAMBIO_ESTADO	9acdf957-9a1a-4786-8463-f69262b0d65d	94c1d788-a09b-4d7d-a45a-fab7eeeab437	\N	Fin Marea. Obs: Sin fecha definida	\N
161f3a04-00a2-480c-aee3-f297e866a8a2	3e06427d-367c-48dd-ba35-48fcd50caff1	2026-01-22 20:36:01.136+00	20feb9da-69af-4b7e-9f9f-47ec73ae954f	EDICION_ESTRUCTURA	\N	\N	\N	Edición manual de etapas y fechas de observador.	\N
542a05cd-0c62-4bb1-9b52-0eb69473d48c	8f90beb5-b58a-4b49-bfdb-fcf1acbe4630	2026-01-22 20:39:00.948+00	20feb9da-69af-4b7e-9f9f-47ec73ae954f	EDICION_ESTRUCTURA	\N	\N	\N	Edición manual de etapas y fechas de observador.	\N
f78f9e2a-6a66-403e-96ff-76c5f12194ea	7a65e5f9-92de-40df-8378-0441eb753710	2026-01-22 20:39:19.748+00	20feb9da-69af-4b7e-9f9f-47ec73ae954f	EDICION_ESTRUCTURA	\N	\N	\N	Edición manual de etapas y fechas de observador.	\N
87c77614-c03a-4adf-9ed6-9f9038dbb073	8d0f0c3c-e975-4b8b-b7c5-15fc642bd830	2026-01-17 22:29:50.724+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CAMBIO_ESTADO	9acdf957-9a1a-4786-8463-f69262b0d65d	94c1d788-a09b-4d7d-a45a-fab7eeeab437	\N	Fin Marea. Obs: 11/12/2025	\N
848cb87f-d419-4fe7-a545-f11194e20961	8d0f0c3c-e975-4b8b-b7c5-15fc642bd830	2026-01-17 22:28:43.74+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	EDICION_ESTRUCTURA	\N	\N	\N	Edición manual de etapas y fechas de observador.	\N
fde0e471-cb23-4cbd-aa36-3c92127fe9b5	2f6ab9b8-a5e8-4118-92e5-3474dfd4af50	2026-01-20 12:52:02.71+00	20feb9da-69af-4b7e-9f9f-47ec73ae954f	CAMBIO_ESTADO	0e446e48-221f-4190-9d34-17af75f9a406	9acdf957-9a1a-4786-8463-f69262b0d65d	\N	Inicio Marea. Obs: 19/1/2026	\N
4a1e6155-c587-4bd7-a9ed-b7b59b02ddb9	2f6ab9b8-a5e8-4118-92e5-3474dfd4af50	2026-01-20 02:50:58.959+00	20feb9da-69af-4b7e-9f9f-47ec73ae954f	CREACION	\N	0e446e48-221f-4190-9d34-17af75f9a406	\N	Marea creada por Daniel Di Tullio	\N
502c7e4e-9b63-4c6e-9a5d-84ca12baf87c	71432415-f2fd-4885-9b14-755e89d31d7d	2026-01-20 02:55:01.884+00	20feb9da-69af-4b7e-9f9f-47ec73ae954f	CREACION	\N	0e446e48-221f-4190-9d34-17af75f9a406	\N	Marea creada por Daniel Di Tullio	\N
0a566acb-d227-4a59-9bb3-6af96e5cde48	c4314176-3b59-4e0a-96fe-7ce13f6e9abc	2026-01-23 16:46:39.169+00	20feb9da-69af-4b7e-9f9f-47ec73ae954f	CREACION	\N	0e446e48-221f-4190-9d34-17af75f9a406	\N	Marea creada por Daniel Di Tullio	\N
8a9571cf-0a0d-44cd-8b02-800638ab34d4	2aff96d3-bc36-4ead-9e21-c3abeb5d740b	2026-01-23 16:48:18.606+00	20feb9da-69af-4b7e-9f9f-47ec73ae954f	CREACION	\N	0e446e48-221f-4190-9d34-17af75f9a406	\N	Marea creada por Daniel Di Tullio	\N
1ffe0ac4-5074-478f-9b1b-f83785678deb	1def5441-0919-4f32-90ab-1498356eee58	2026-01-23 16:47:41.989+00	20feb9da-69af-4b7e-9f9f-47ec73ae954f	CREACION	\N	0e446e48-221f-4190-9d34-17af75f9a406	\N	Marea creada por Daniel Di Tullio	\N
0d640b35-bf06-4dcc-aacd-29c5180c70bb	aa5d695f-6652-4e07-a1c4-95fb0ba0ea60	2026-01-18 23:16:29.482+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CAMBIO_ESTADO	0e446e48-221f-4190-9d34-17af75f9a406	c56c252a-8a98-4dd6-9c2d-de6135686d71	\N	Acción: Cancelar	\N
6f41b07e-4734-4d09-a395-1cdf028bc540	aa5d695f-6652-4e07-a1c4-95fb0ba0ea60	2026-01-18 23:07:32.04+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	0e446e48-221f-4190-9d34-17af75f9a406	\N	Marea creada por Administrador Sistema	\N
044477ea-5535-428e-9fee-9553347d672d	aa3f62fe-ca9c-47e4-a453-e86269747aa1	2026-01-18 23:16:35.533+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CAMBIO_ESTADO	0e446e48-221f-4190-9d34-17af75f9a406	c56c252a-8a98-4dd6-9c2d-de6135686d71	\N	Acción: Cancelar	\N
e4cd12f0-df1f-4195-9a2d-cd3f7b5e0027	aa3f62fe-ca9c-47e4-a453-e86269747aa1	2026-01-18 23:08:31.657+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	0e446e48-221f-4190-9d34-17af75f9a406	\N	Marea creada por Administrador Sistema	\N
6199953a-003b-457e-a66d-d895ebdbc35b	e4607759-69d1-4726-bf88-839b4573dbd1	2026-01-18 23:16:41.065+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CAMBIO_ESTADO	0e446e48-221f-4190-9d34-17af75f9a406	c56c252a-8a98-4dd6-9c2d-de6135686d71	\N	Acción: Cancelar	\N
2ab44c9f-4550-4b21-8e4e-704930277088	e4607759-69d1-4726-bf88-839b4573dbd1	2026-01-18 23:09:12.484+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	0e446e48-221f-4190-9d34-17af75f9a406	\N	Marea creada por Administrador Sistema	\N
6ecc42c3-c3dd-4f96-a0d7-d15b65a7a5a1	d56971fb-f4fe-46ac-a75c-9dd8b341be9f	2026-01-18 23:16:47.893+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CAMBIO_ESTADO	0e446e48-221f-4190-9d34-17af75f9a406	c56c252a-8a98-4dd6-9c2d-de6135686d71	\N	Acción: Cancelar	\N
5b85eed2-da03-4a3b-aa6c-41e5fbd209d3	d56971fb-f4fe-46ac-a75c-9dd8b341be9f	2026-01-18 23:09:52.294+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	0e446e48-221f-4190-9d34-17af75f9a406	\N	Marea creada por Administrador Sistema	\N
2b18d3d6-d237-417c-b88b-bc881085548c	b882bd42-86d4-4653-b810-3beb2845fc22	2026-01-18 23:16:52.918+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CAMBIO_ESTADO	0e446e48-221f-4190-9d34-17af75f9a406	c56c252a-8a98-4dd6-9c2d-de6135686d71	\N	Acción: Cancelar	\N
d7500ea0-a807-48b4-b882-93777bb4afc2	b882bd42-86d4-4653-b810-3beb2845fc22	2026-01-18 23:10:59.767+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	0e446e48-221f-4190-9d34-17af75f9a406	\N	Marea creada por Administrador Sistema	\N
602853f3-ce00-4da8-9511-f6f4fa603312	9e8943bb-9556-450d-bb55-2885d89473ce	2026-01-18 23:01:35.199+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CAMBIO_ESTADO	0e446e48-221f-4190-9d34-17af75f9a406	c56c252a-8a98-4dd6-9c2d-de6135686d71	\N	Acción: Cancelar	\N
4aa6dc79-b633-4bd5-a946-a6d4f64b9a72	9e8943bb-9556-450d-bb55-2885d89473ce	2026-01-18 22:56:00.769+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	0e446e48-221f-4190-9d34-17af75f9a406	\N	Marea creada por Administrador Sistema	\N
c24a112d-2b2c-4635-b256-17b8ac7416d1	bb60421c-7a27-4de4-9f3f-c3a1b3ed38ca	2026-01-18 23:16:57.783+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CAMBIO_ESTADO	0e446e48-221f-4190-9d34-17af75f9a406	c56c252a-8a98-4dd6-9c2d-de6135686d71	\N	Acción: Cancelar	\N
3304ed39-8fe0-4f19-97ef-ea50704ad4e6	bb60421c-7a27-4de4-9f3f-c3a1b3ed38ca	2026-01-18 23:11:35.027+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	0e446e48-221f-4190-9d34-17af75f9a406	\N	Marea creada por Administrador Sistema	\N
af384d02-8218-4547-b029-20ec8fa9a6c3	9bd1f61d-6d04-4749-badd-a280983dafa3	2026-01-18 23:15:32.185+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CAMBIO_ESTADO	0e446e48-221f-4190-9d34-17af75f9a406	c56c252a-8a98-4dd6-9c2d-de6135686d71	\N	Acción: Cancelar	\N
a9e60743-a3a7-4d06-8b20-a0886cd7a66d	9bd1f61d-6d04-4749-badd-a280983dafa3	2026-01-18 23:03:39.67+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	0e446e48-221f-4190-9d34-17af75f9a406	\N	Marea creada por Administrador Sistema	\N
b3489255-e749-4de5-9412-eb8f588224bd	71802c9f-7a01-4119-aff7-ffc082c3cf28	2026-01-18 23:17:02.586+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CAMBIO_ESTADO	0e446e48-221f-4190-9d34-17af75f9a406	c56c252a-8a98-4dd6-9c2d-de6135686d71	\N	Acción: Cancelar	\N
74e14b69-cc07-4638-9b83-5c89831c15b8	71802c9f-7a01-4119-aff7-ffc082c3cf28	2026-01-18 23:12:47.511+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	0e446e48-221f-4190-9d34-17af75f9a406	\N	Marea creada por Administrador Sistema	\N
906d95dc-55f6-49cf-99fd-6de87ecf410d	656431c5-0e35-42ae-9165-a58e446382ab	2026-01-18 23:15:43.523+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CAMBIO_ESTADO	0e446e48-221f-4190-9d34-17af75f9a406	c56c252a-8a98-4dd6-9c2d-de6135686d71	\N	Acción: Cancelar	\N
96225577-b18f-4ad7-9a55-b8dcaea6ca1a	656431c5-0e35-42ae-9165-a58e446382ab	2026-01-18 23:05:06.69+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	0e446e48-221f-4190-9d34-17af75f9a406	\N	Marea creada por Administrador Sistema	\N
f5582178-7394-4367-b247-0ef79d081370	590b2227-e71f-456b-a060-b6a830524615	2026-01-18 23:15:56.565+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CAMBIO_ESTADO	0e446e48-221f-4190-9d34-17af75f9a406	c56c252a-8a98-4dd6-9c2d-de6135686d71	\N	Acción: Cancelar	\N
ef48ae72-d56a-4fa1-a102-de9106042cc3	590b2227-e71f-456b-a060-b6a830524615	2026-01-18 23:06:10.792+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	0e446e48-221f-4190-9d34-17af75f9a406	\N	Marea creada por Administrador Sistema	\N
c1ecc24c-11ca-4dcf-8ac5-d6e06971fa03	49097f16-3982-4fc0-91cc-ea400517493c	2026-01-23 12:41:19.256+00	20feb9da-69af-4b7e-9f9f-47ec73ae954f	EDICION_ESTRUCTURA	\N	\N	\N	Edición manual de etapas y fechas de observador.	\N
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
32c8c10b-9339-4530-b694-a7cde12303d7	7828	Fabian Eduardo	Desojo	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	t	pachappppp@gmail.com	Cambio de empleo a engrasador
badf311e-83d6-49d9-85dc-81a1e3f01435	7832	Maximiliano Adrian	Godoy	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	maxigodox@gmail.com	\N
66457c81-75a2-46eb-9479-d6d06f9f0caa	7838	Nicolas Facundo	Staneff Rotela	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	nicolas.staneff@gmail.com	\N
6256edd6-52a0-4059-acd3-b29ded481cab	7840	Durbal	Villalba	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	villalbadurbal@gmail.com	\N
a5881d77-7bed-446c-a875-9d188704abf2	7841	Nicolas Agustin	Caballero	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	Nicck934@gmail.com	\N
953e1b54-3b89-439e-95d8-a87552a4769c	7842	Gabriel Osvaldo Catriel	Gimenez Salinas	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	pikyred123@gmail.com	\N
4da6b8bc-b660-41cc-a5f8-860a5f0c289e	7843	Johnatan	Challier	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	jonhychallier@gmail.com	\N
44163918-8c39-4c86-b0ce-8851d4499a57	7844	Sebastían Roque	Garcia	\N	OBSERVADOR	MONOTRIBUTISTA	f	t	\N	\N	f	sebastianroquegarcia4@gmail.com	\N
aa018cb5-a18c-461f-8a48-97e948725511	7845	Alexia	Aguilar	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	aguilaralexia00@gmail.com	\N
1c851730-c8e9-45ce-92f9-6b31b0383fb7	7846	Oriana	Retamar Mendez	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	t	orianaretamarm@gmail.com	Restricción operativa para embarque de mujeres
28c25115-5e49-4c59-88b8-ac774ebc9b38	7847	Gianfranco	Alvarez	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	gianalvarezobs@gmail.com	\N
faa80470-d4d4-43d1-9af1-79e2c1de0f95	7848	Diego	Gorosito	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	diegojavierg158@gmail.com	\N
3bc926c7-1487-4607-bd8f-7455c9b9c34f	7849	Leonardo	Prado Escobar	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	t	estudioprado02@gmail.com	Inactivo según reporte
62da3091-6360-4064-9fe9-6c1dfc9310eb	7850	María Laura	Monterisi	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	mlm.vlady@gmail.com	\N
93b1ccb3-f9f2-4f2f-8556-5648ca503563	7851	Alvaro	Benitez	\N	OBSERVADOR	MONOTRIBUTISTA	f	t	\N	\N	t	alvarobeni89@gmail.com	En otro trabajo
c36be44b-3fe8-47fe-92d0-4df80a22ba51	7852	Camila	Corti	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	camilacorti95@gmail.com	\N
71f42b51-88eb-414d-9c9b-828a27da8790	7853	Luciano	Matte Casietto	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	lucianomcassietto@hotmail.com.ar	\N
80952148-a7b0-4af9-8d8b-a9ce94bb5a98	7854	Gisele	Garcia	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	t	garciagiselealejandra@gmail.com	Desempeño insuficiente reportado
1e7ab278-6343-482c-9b50-17f80fb7f013	7855	Nicolas	Pereyra	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	nicolasagustinpereyra777@gmail.com	\N
9fb37300-59e2-4cb1-97a9-52b8e75aeacb	7858	Franco	Ibarra	\N	OBSERVADOR	MONOTRIBUTISTA	t	f	\N	\N	t	francoadrianibarra@gmail.com	En otro empleo
a9e1d8a6-fea5-452a-b5f4-6a8ef843cd1d	7859	Melisa	Garcia	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	t	melipg7@gmail.com	Restricción operativa para embarque de mujeres
3e4d67b9-f914-4636-830d-1f3d40b8470a	7860	Nahuel	Ramirez	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	nahuelramirezm@gmail.com	\N
9192ba12-5bf6-4480-8ff3-ac7141e9045d	7861	Daiana Anabella	Molina Riquelme	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
732d569e-7e97-43d8-9bf1-862a3b6f50d7	7862	Christian Enderson	Fenco Chavesta	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
ae868cc6-18bc-4502-a70f-48fdca9a5643	7863	Daniel Enrique	Ramunno	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
563b5d9a-ab4c-4c3f-9976-87d5db0d4029	7864	Manuel Agustín	Palos	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
16816e22-5e78-4a99-926b-0f9a2a915b08	7865	Gabriel Alejandro	Dumrauf	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
19a5abb9-250a-4df7-aee5-01152c380f96	7866	Francisco German	Sette	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
3e2b17b3-8c34-443a-8604-4c227bfef3c1	7867	Cintia Daiana	Magrini Quiroga	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
4dfdc163-8a86-40dd-a2bd-6f47ab75aeb2	7868	Lucas Oscar	Gaona	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
c2abe2e4-eba1-4f7f-852d-d86ec28f4a06	7869	Sergio Gastón	Frontera	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
ed52a7dd-27dc-456e-9880-f37b7f93efb7	7871	Sergio Javier	Gomez Mapiz	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
aa061475-2e01-422c-b7e3-896a39b88d16	7872	Juan Francisco	Rodriguez Fulco	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
6e042fa0-9468-47fb-9bcb-b0b89db50b2b	7873	Lucas David	Carabeta	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
9f7f690d-4f44-4da7-a1ec-cb4f1862ede8	7874	Morena Aylen	Ledesma	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
ce06ab1e-39fb-4e7b-9bb1-2afb1060b9b2	7875	Leonardo Ezequiel	Andrade	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
78905073-1f37-4630-8208-8087e2b7c8d6	7876	Walter Alejandro	Leon	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
f4058374-6484-4a27-9214-3bda3f1e451f	7879	Lucía	Martinez Ta	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
c7deb864-8c2e-4c35-9c8e-efd3ef4cb8f4	7900	Paola Alejandra	Navarro Grassi	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
8e051b00-7caf-44b3-a63c-72070f31ab8e	8002	Julio Roberto	Sinconegui	\N	OBSERVADOR	MONOTRIBUTISTA	f	t	\N	\N	f	jrsinconegui@inidep.edu.ar	\N
7def5c23-8e10-47ad-bb0c-21f2cdd9f65b	9442	Sebastian	Garcia	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	\N	\N
a7317b26-7dc6-4194-be8a-7430c589aef5	9451	Jorge Fernando	Repetto	\N	OBSERVADOR	MONOTRIBUTISTA	f	t	\N	\N	t	cotoperca23@hotmail.com	Jubilación
5d7daaa8-b542-4655-a345-2bce20bd9154	9459	Raúl Antonio Ceferino	Puliafito	\N	OBSERVADOR	MONOTRIBUTISTA	f	t	\N	\N	t	raul.puliafito@gmail.com	Traslado a otro programa
c8b194fa-a849-475e-a4c0-9bd0b6885f45	9460	Pablo Alejandro	Ramos	\N	OBSERVADOR	MONOTRIBUTISTA	f	t	\N	\N	t	pabloramos64@yahoo.com.ar	Licencia médica
f83d7510-1ca7-4a65-aa76-0c04cfe30e3d	9461	Alejandro José	Mazzei	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	alejandromazzei525@gmail.com	\N
89c5ee5f-5134-4e03-8563-1db8f9bc765c	9465	Daniel Alejandro	Di Tullio	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	ddi@inidep.edu.ar	\N
3c57a456-c0f9-4e76-9390-06974f9d8af7	9467	Pablo Julian	Miranda	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	pablojmiranda65@gmail.com	\N
12e77af4-57a5-4e1a-9403-ea4170ae031e	9471	Estanislao	Rodriguez Fulco	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	rfestanislao@gmail.com	\N
204cd137-ce2d-4fa1-a653-05246541e7c9	9474	Juan Manuel	Staneff	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	juanmanuel_jotis@hotmail.com	\N
b3606d29-5c9e-46ff-9c7f-8413190258b0	9480	Cristian Oscar	Piriz	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	cristianpiriz36@gmail.com	
ae38bfdc-bf9c-4784-b0fd-699667fc53bb	9476	Héctor Eduardo	Vera	\N	OBSERVADOR	LEY MARCO	t	f	\N		t	veraeduardo1971@gmail.com	Presentó renuncia. Sale a trabajar de marinero
ad6f9497-8011-432e-a708-b6d63dd8db49	7724	Eduardo Esteban	Aguilar	\N	TECNICO	LEY MARCO	t	t	\N		f	edu81aguilar@gmail.com	\N
65847298-7f70-4422-bcaf-50ecd7f71bf3	9999	No	Identificado	\N	OBSERVADOR	MONOTRIBUTISTA	f	f	\N	Genérico para casos donde no se puede identificar al observador relacionado a una marea	f	nn@inidep.edu.ar	\N
f92c6137-c63e-4d5f-9061-718cf0b50a79	7613	Federico Nicolás	Garcia	\N	OBSERVADOR	1109	t	f	\N		t	fede.gaarciaa@gmail.com	Accidente en motocicleta
0282e854-cb23-4c6c-8928-c615d8710d1b	2021	Claudio	Noale	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	t	claudionoale@hotmail.com	Cambio de trabajo
fd15e053-e765-4c08-acd1-a78ac6e30c96	7149	Gustavo	Cano	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	\N	\N
449133c7-dff0-417d-b983-fa181eb92109	7562	Lucas	Bentos	\N	TECNICO	LEY MARCO	t	t	\N	\N	f	\N	\N
331acb3e-ad80-4b97-8fdd-f521293e7843	7610	Raul Bernardo	Bargas Peña	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	rbbargas@gmail.com	\N
7ba6a2a2-0d7b-48e9-be56-36ca1570a97d	7611	Cristian Emmanuel	Cerrina	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	manucerrina2@gmail.com	\N
7f0d9229-087a-4c49-833e-e4725c49e8b2	7612	Richard Javier	Espinola Gysin	\N	OBSERVADOR	1109	t	t	\N	\N	f	richardjesp@gmail.com	\N
1f6f43ad-8ec5-4632-acc1-9d1f8f74bd3f	7616	Jorge Guillermo	Herrera	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	herrerajorgeguillermo@gmail.com	\N
9b798cad-862b-4607-8f63-0c78a8e7e19d	7617	Leonardo Marcos	Kren	\N	OBSERVADOR	MONOTRIBUTISTA	f	t	\N	\N	t	lmlemark@gmail.com	Licencia médica
958b4d6d-2857-4f20-9356-3f57699663dc	7620	Diego Sebastian	Marchiori	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	brugmasia@hotmail.com	\N
6d19fba1-728f-4af8-942a-909beac18e9c	7621	Luis Gabriel	Martinez Tecco	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	lgmt666@hotmail.com	\N
98da2023-db66-4008-83d1-b3050581a23f	7624	Teresa Beatriz	Reinaga	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	tere2361@hotmail.com	\N
285206ab-195f-4e45-801e-3cb607f94755	7625	Eduardo	Silvester	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	eduwolfsilvester@hotmail.com	\N
3d658943-3952-468d-848e-f7027b6e06ef	7627	Jorge Luis	Morales	\N	OBSERVADOR	PLANTA PERMANENTE	t	t	\N	\N	f	didiinidep1980@gmail.com	\N
04d8aeaa-8ea9-42e4-8825-1c7c7e023346	7726	Juan José	Coppa	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	juancoppa@hotmail.com	\N
b83fb938-aba7-498d-956a-888ad840d094	7728	Adrian Pascual	Galluzzo	\N	OBSERVADOR	MONOTRIBUTISTA	f	t	\N	\N	t	apgalluzzo@hotmail.com	Jubilación
1bd42b21-35f1-4049-8e4e-28acae994ace	7729	Walter Alejandro	Glavina	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	glavinawalter@hotmail.com	\N
f664f50e-3dbd-479d-843e-93457b9c5bba	7730	Carlos Daniel	Herrera	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	aquimardel@gmail.com	\N
3d8b3d8c-18f4-4f71-923d-8c6a0e59fe06	7733	Maria Lucila	Maydana	\N	OBSERVADOR	MONOTRIBUTISTA	f	t	\N	\N	f	\N	\N
2f4e3703-412b-4cf0-b046-ed896ec9ba6d	7735	Sergio Fabian	Najle	\N	OBSERVADOR	MONOTRIBUTISTA	f	t	\N	\N	t	najlesergio@yahoo.com.ar	Licencia médica
934fc3fd-d1c0-4f2c-a116-572384e0a1db	7740	Leonardo Luis	Spagnuolo Rey	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	leospagnuolorey@yahoo.com.ar	\N
65e8b492-4125-4774-b6e9-ebc5cdfa54b0	7742	Héctor Luis	Teves	\N	OBSERVADOR	MONOTRIBUTISTA	f	t	\N	\N	t	hecluteves@hotmail.com	Jubilación
1bf5bc51-f7e6-40c6-a7b3-acaa383d4605	7767	Claudio Alberto	Nadal	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	nadal-claudio@hotmail.com	\N
0cb75f9a-f4d5-43fd-a3bf-d6dca3540540	7776	Gonzalo	Troccoli	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	gtroccoli@inidep.edu.ar	\N
78cfc00f-af4b-47ab-b3c5-fd4582cdb8ae	7796	Fernando Alberto	Schwartz	\N	OBSERVADOR	MONOTRIBUTISTA	t	t	\N	\N	f	gallococo@hotmail.com	\N
19b905ca-6e34-4167-b9a7-9e7cd54f857c	7798	Marcelo Simón	Freyre	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	freyre.ms@gmail.com	\N
\.


--
-- Data for Name: password_reset_tokens; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.password_reset_tokens (id, token, expires_at, used, requested_ip, created_at, user_id) FROM stdin;
\.


--
-- Data for Name: pesquerias; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.pesquerias (id, codigo, nombre, descripcion, grupo, orden, activo) FROM stdin;
a7c270d2-3ec4-436a-bbfe-4359d46b0b22	ABADEJO	Abadejo	\N	Peces	\N	t
3750f533-77c8-405f-8a00-bf0ba0353a4d	ANCHOITA	Anchoíta	\N	Peces	\N	t
351bae45-1535-472c-91c4-1a8a22bb3ff1	CABALLA	Caballa	\N	Peces	\N	t
127f273e-086c-4e23-bb9e-0557fc9270aa	CALAMAR	Calamar	\N	Moluscos	\N	t
13c3c551-df0d-4c62-a185-d36a0298672a	CENTOLLA	Centolla	\N	Crustáceos	\N	t
cb20a7a1-e40f-4cb1-af07-8e5273dd0237	AUSTRALES	Especies australes	\N	Peces	\N	t
f9515f1d-0e10-41a6-92b1-2f512a4f25c4	LANGOSTINO	Langostino	\N	Crustáceos	\N	t
1985bde5-8964-4250-b775-74cc7469ed58	MERLUZA_COMUN	Merluza común	\N	Peces	\N	t
3f80dbc5-1ac0-43c6-a2d5-f291899c2e7f	MERLUZA_NEGRA	Merluza negra	\N	Peces	\N	t
83867dcf-3fe0-4b78-8470-aabe5c344bda	VIEIRA	Vieira	\N	Moluscos	\N	t
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
35d76fd7-fbcb-4f0b-a620-f2cecbe5fd53	Punta Quilla	\N	\N	23	\N	f	t	\N	\N	-50.11666	-68.41666
b8b1c3bd-4cb4-4e4b-94b5-f78a2b935fe6	Rio Gallegos	\N	\N	19	\N	f	t	\N	\N	-51.63334	-69.2
792484d9-dc51-4a9d-b9a5-d28c9047bcf0	Ushuaia	\N	\N	10	\N	f	t	\N	\N	-54.83333	-68.3
f3d2726d-273b-4876-8181-2bad234708b5	Buenos Aires	\N	\N	12	\N	f	t	\N	\N	-34.58333	-58.38334
7161407b-424c-4f40-8aeb-d7c77d9f4a17	Rio Grande (brasil)	\N	\N	20	\N	f	t	\N	\N	-32.13334	-52.08333
3c4f2d8a-1891-4c52-8905-f6bbb2aeaa48	Montevideo	\N	\N	XX	\N	f	t	\N	\N	-34.9	-56.2
911dfc2b-fde2-497c-ac18-8fdc06b8a0f5	Samborombon	\N	\N	21	\N	f	t	\N	\N	-35.73333	-57.31667
712f2d11-5528-41f0-94d4-bf4d645ca9af	San Clemente	\N	\N	14	\N	f	t	\N	\N	-36.33333	-56.78333
4ad4e569-c081-4820-895e-e86131bc5b38	Mar Del Plata	\N	\N	1	\N	t	t	\N	\N	-38.06667	-57.55
ff898649-618b-4d9a-9194-0049e6e37f4a	Quequen	\N	\N	2	\N	f	t	\N	\N	-38.58333	-58.7
c08082e7-f85e-4434-ab74-860bc02f07a1	Bahia Blanca	\N	\N	3	\N	f	t	\N	\N	-38.75	-62.16667
f990b17b-6a5b-4dd1-b76a-ca8e1a775f11	Bahia San Blas	\N	\N	15	\N	f	t	\N	\N	-40.55	-62.23333
e6506238-633f-446e-a498-2eedf4f5dcc5	San Antonio Oeste	\N	\N	9	\N	f	t	\N	\N	-40.73333	-64.96667
3786f63c-0253-4a7c-b195-c4cde77f9e43	Viedma	\N	\N	22	\N	f	t	\N	\N	-40.9	-62.86666
953117a0-3c04-4129-ab96-5eddf3a8d43a	Puerto Madryn	\N	\N	4	\N	f	t	\N	\N	-42.76667	-65.05
5fb86b04-e3a4-47af-81fa-11ec0d974b38	Rawson	\N	\N	7	\N	f	t	\N	\N	-43.33333	-65.06667
875ac428-3ca1-4503-a101-73be10d01795	Bahia Camarones	\N	\N	11	\N	f	t	\N	\N	-44.8	-65.73333
4a66c074-2c54-4ee1-bd44-9fe59a8de18f	Comod, Rivad,	\N	\N	6	\N	f	t	\N	\N	-45.88334	-67.5
4cda5033-1882-436d-b1ce-c7ec772cb8fa	Caleta Olivia	\N	\N	16	\N	f	t	\N	\N	-46.43333	-67.53333
aa748f6a-602b-4346-b964-50cbcea76146	Deseado	\N	\N	5	\N	f	t	\N	\N	-47.76667	-65.91666
60e1c07c-98a8-4183-83d0-03f423b861a6	San Julian	\N	\N	17	\N	f	t	\N	\N	-49.31667	-67.73333
\.


--
-- Data for Name: submuestras; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.submuestras (id, muestra_id, numero_ejemplar, largo_total, largo_estandar, peso_total_g, peso_gonadas_g, sexo, estadio_madurez, replecion, contenido_estomacal, observaciones_ejemplar) FROM stdin;
\.


--
-- Data for Name: system_status; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.system_status (key, value, last_update) FROM stdin;
\.


--
-- Data for Name: tipos_flota; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.tipos_flota (id, codigo, nombre, descripcion, orden, activo, codigo_numerico) FROM stdin;
472b1dab-fa91-4394-a855-d972ba9d3441	COSTERO	Costero	\N	\N	t	21
e087c76f-c23b-4bb8-b606-a61a7b0fba75	RADA_RIA	Rada o Ría	\N	\N	t	11
33b72a9c-7955-4676-bfa9-88037bde19ea	ALTURA_FRESQUERO	Altura (Fresquero)	\N	\N	t	31
e85d7441-0ea6-4a35-8a9e-cc4762739d78	ALTURA_CONGELADOR	Altura (Congelador)	\N	\N	t	32
48bb265f-b2b9-4f62-9419-24773575b6f1	INVESTIGACION	Investigación	\N	\N	t	90
12be2a02-6821-4e6f-9980-9d80b0866c8f	INDETERMINADO	Indeterminado	\N	\N	t	99
\.


--
-- Data for Name: tracking_event_snapshots; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.tracking_event_snapshots (id, buque_id, event_type, "timestamp", puerto_id, hash, created_at) FROM stdin;
\.


--
-- Data for Name: transiciones_estados; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.transiciones_estados (id, id_estado_origen, id_estado_destino, accion, etiqueta, clase_boton, requiere_observaciones, activo) FROM stdin;
c27c46c8-6b2f-4d89-9f66-e8646b885be5	0e446e48-221f-4190-9d34-17af75f9a406	9acdf957-9a1a-4786-8463-f69262b0d65d	REGISTRAR_INICIO	Registrar Inicio	primary	f	t
4acceff1-24ad-44f1-81b4-8e307144c3a1	9acdf957-9a1a-4786-8463-f69262b0d65d	94c1d788-a09b-4d7d-a45a-fab7eeeab437	REGISTRAR_ARRIBO	Confirmar Arribo	primary	f	t
9617126c-f3fa-4734-9e4d-9cb613b529c7	94c1d788-a09b-4d7d-a45a-fab7eeeab437	2580411e-8f93-49c9-ab14-6d247ed373ae	RECIBIR_DATOS	Recibir Archivos de Marea	primary	f	t
f5557bec-4f35-46a1-8fe0-69ec47c52120	2580411e-8f93-49c9-ab14-6d247ed373ae	fdf092bc-e7f6-4d03-8cda-9f25d483cecf	INICIAR_VERIFICACION	Iniciar Verificación	primary	f	t
f9b94c27-d6ae-4952-b1d9-e7fdfbf01e35	fdf092bc-e7f6-4d03-8cda-9f25d483cecf	9d108311-d1b7-49eb-b57e-cf8383b42f73	ABRIR_CORRECCION	Abrir Corrección	secondary	f	t
898ac663-dd6f-4885-9eed-8bccf87ff514	fdf092bc-e7f6-4d03-8cda-9f25d483cecf	80836557-9617-4c74-a903-089230c085b3	PASAR_A_INFORME	Pasar a Informe	primary	f	t
37f6a2d5-1cbe-4ff9-ba21-f470ec18690b	9d108311-d1b7-49eb-b57e-cf8383b42f73	80836557-9617-4c74-a903-089230c085b3	FINALIZAR_CORRECCION	Finalizar Corrección	primary	f	t
e7099bb7-25b0-4b44-ab6e-b336bf101503	9d108311-d1b7-49eb-b57e-cf8383b42f73	5f9a8c90-a1ff-4c7d-a11d-26571f257799	DELEGAR_EXTERNA	Derivar a Proyecto	secondary	f	t
fa460e67-446d-4649-8aa8-428ba724fd68	5f9a8c90-a1ff-4c7d-a11d-26571f257799	9d108311-d1b7-49eb-b57e-cf8383b42f73	RETORNAR_CORRECCION	Devolución Externa	primary	f	t
fa60b6c5-72e0-4aca-9b98-9491fa0a706c	80836557-9617-4c74-a903-089230c085b3	57669ce7-ad00-4862-a3b7-ded380ddb616	ENVIAR_A_REVISION	Enviar a Revisión	primary	f	t
c3462be9-8c41-4385-aa33-03d9ba2786d0	57669ce7-ad00-4862-a3b7-ded380ddb616	84c07a8f-84e9-4b3b-931e-553534c24b01	APROBAR_INFORME	Aprobar Informe	primary	f	t
9d079a89-9762-4602-8235-606223adff5d	57669ce7-ad00-4862-a3b7-ded380ddb616	80836557-9617-4c74-a903-089230c085b3	RECHAZAR_INFORME	Observaciones en Informe	secondary	f	t
3ccc9fa7-94a1-4a89-a66e-19dfa2ad01d5	84c07a8f-84e9-4b3b-931e-553534c24b01	c9c6f43a-3167-442b-8c19-e04895934ae0	INICIAR_TRAMITE	Iniciar Protocolización	primary	f	t
850c62f6-2138-4278-b3b6-d3eda5c7c542	c9c6f43a-3167-442b-8c19-e04895934ae0	9958d706-2c00-447c-b303-b8a2fa2ce060	FINALIZAR_PROTOCOLIZACION	Finalizar Protocolización	primary	f	t
27378880-d32f-4a95-9990-0be112b8f0e5	0e446e48-221f-4190-9d34-17af75f9a406	c56c252a-8a98-4dd6-9c2d-de6135686d71	CANCELAR	Cancelar	error	t	t
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.users (id, email, password, "fullName", "isActive", roles, "themePreference", "avatarUrl") FROM stdin;
a1eaea70-9aa0-4432-acbf-305ab5fab6f9	admin@obs.com	$2b$10$jYY7zTkIRlh4ZcDM2uyYEumzno9sXiBDznifDWTxb3Zf/9l4nmrdW	Administrador Sistema	t	{admin}	system	\N
20feb9da-69af-4b7e-9f9f-47ec73ae954f	danieldt2000@hotmail.com	$2b$10$jYY7zTkIRlh4ZcDM2uyYEumzno9sXiBDznifDWTxb3Zf/9l4nmrdW	Daniel Di Tullio	t	{tecnico_datos,coordinador,asistente_administrativo,admin}	system	\N
7cb77421-dae2-43f6-92ba-d11a77fca75d	rfestanislao@gmail.com	$2b$10$v.8JXQpTT.qQOxtEcgNJ0OdGzclutvxgGyj35MBQJTdtcOxg/XoEu	Estanislao Rodriguez	t	{tecnico_datos,coordinador,asistente_administrativo}	system	\N
c2480f39-a7fe-4bc6-85aa-3d4a6f7a8d38	gc@inidep.edu.ar	$2b$10$gdJH9O3E59vz3PpIn2Zad.Q6imVLnFGQXTGq1.lrWo425NxFzk/QO	Gustavo Cadaveira	t	{coordinador,tecnico_datos,asistente_administrativo}	system	\N
a68658ae-266a-47c5-ad6e-61a9552abd84	asistente@obs.com	$2b$10$jYY7zTkIRlh4ZcDM2uyYEumzno9sXiBDznifDWTxb3Zf/9l4nmrdW	Asistente Administrativo	f	{asistente_administrativo}	system	\N
ee60e2bc-94fe-45aa-8358-c66ebb920af3	coordinador@obs.com	$2b$10$jYY7zTkIRlh4ZcDM2uyYEumzno9sXiBDznifDWTxb3Zf/9l4nmrdW	Coordinador Operativo	f	{coordinador}	system	\N
3e6b512c-53e0-4d96-9959-b09a6d353067	tecnico@obs.com	$2b$10$jYY7zTkIRlh4ZcDM2uyYEumzno9sXiBDznifDWTxb3Zf/9l4nmrdW	Usuario de Prueba	t	{tecnico_datos}	system	\N
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
-- Name: system_status system_status_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.system_status
    ADD CONSTRAINT system_status_pkey PRIMARY KEY (key);


--
-- Name: tipos_flota tipos_flota_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tipos_flota
    ADD CONSTRAINT tipos_flota_pkey PRIMARY KEY (id);


--
-- Name: tracking_event_snapshots tracking_event_snapshots_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tracking_event_snapshots
    ADD CONSTRAINT tracking_event_snapshots_pkey PRIMARY KEY (id);


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
-- Name: buques_nombre_buque_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX buques_nombre_buque_key ON public.buques USING btree (nombre_buque);


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
-- Name: identificadorMarea; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "identificadorMarea" ON public.mareas USING btree (anio_marea, nro_marea, tipo_marea);


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
-- Name: mareas_anio_marea_nro_marea_tipo_marea_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX mareas_anio_marea_nro_marea_tipo_marea_key ON public.mareas USING btree (anio_marea, nro_marea, tipo_marea);


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
-- Name: tracking_event_snapshots_buque_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX tracking_event_snapshots_buque_id_idx ON public.tracking_event_snapshots USING btree (buque_id);


--
-- Name: tracking_event_snapshots_hash_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX tracking_event_snapshots_hash_idx ON public.tracking_event_snapshots USING btree (hash);


--
-- Name: tracking_event_snapshots_hash_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX tracking_event_snapshots_hash_key ON public.tracking_event_snapshots USING btree (hash);


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
    ADD CONSTRAINT buque_trayectoria_puntos_trayectoria_id_fkey FOREIGN KEY (trayectoria_id) REFERENCES public.buque_trayectorias(id) ON UPDATE CASCADE ON DELETE CASCADE;


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
-- Name: mareas mareas_id_pesqueria_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mareas
    ADD CONSTRAINT mareas_id_pesqueria_fkey FOREIGN KEY (id_pesqueria) REFERENCES public.pesquerias(id) ON UPDATE CASCADE ON DELETE SET NULL;


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

\unrestrict p2s7beggCRZItlr0cgcuZVRsL2jzHE6065iL4JFC7IDoUFFCdRyeqtIaZTJg1ba

