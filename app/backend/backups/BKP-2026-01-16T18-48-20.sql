--
-- PostgreSQL database dump
--

\restrict jikYhBxDXfM4NhXO2DBrkVdpbFBBa0Hs5ndLOtmb020aG0toM7QKfovOuxIc2zw

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
-- *not* dropping schema, since initdb creates it
--
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

-- *not* creating schema, since initdb creates it


--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA public IS '';


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
    dias_estimados integer
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
\.


--
-- Data for Name: alertas; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.alertas (id, codigo_unico, referencia_id, tipo, titulo, descripcion, estado, prioridad, fecha_detectada, fecha_vencimiento, fecha_cierre, asignado_id, creado_por_id, ultima_actualizacion, metadata, referencia_tipo) FROM stdin;
3e9e8b6d-28cf-4ff3-8a5b-ed2b5351d85b	FATIGA-62c16919-f33c-49d1-b3ad-24fe015c7264-2025	62c16919-f33c-49d1-b3ad-24fe015c7264	FATIGA	Fatiga Crítica Detectada	El observador Nicolas Agustin Caballero ha navegado 193 días en el año.	PENDIENTE	ALTA	2026-01-09 02:51:56.256+00	\N	\N	\N	\N	2026-01-09 02:51:56.257+00	{"days": 193, "observerName": "Nicolas Agustin Caballero"}	OBSERVADOR
0173beb3-6800-41ed-a011-d64a1ceaad67	FATIGA-63a38f88-b458-4702-898d-2e601a72f46e-2025	63a38f88-b458-4702-898d-2e601a72f46e	FATIGA	Fatiga Crítica Detectada	El observador Héctor Eduardo Vera ha navegado 166 días en el año.	PENDIENTE	ALTA	2026-01-09 02:51:56.267+00	\N	\N	\N	\N	2026-01-09 02:51:56.268+00	{"days": 166, "observerName": "Héctor Eduardo Vera"}	OBSERVADOR
b99901e3-8d16-47b7-a99a-4b4b10646c1a	FATIGA-67dd05bf-c7d9-46c9-8ecb-4acd56e08b2c-2025	67dd05bf-c7d9-46c9-8ecb-4acd56e08b2c	FATIGA	Fatiga Crítica Detectada	El observador Nicolas Facundo Staneff Rotela ha navegado 196 días en el año.	PENDIENTE	ALTA	2026-01-09 02:51:56.279+00	\N	\N	\N	\N	2026-01-09 02:51:56.28+00	{"days": 196, "observerName": "Nicolas Facundo Staneff Rotela"}	OBSERVADOR
c8330bb3-838f-4880-ada4-c077fff1d7ac	FATIGA-b288e78b-597d-4077-8eed-4a751481a764-2025	b288e78b-597d-4077-8eed-4a751481a764	FATIGA	Fatiga Crítica Detectada	El observador Eduardo Silvester ha navegado 173 días en el año.	PENDIENTE	ALTA	2026-01-09 02:51:56.29+00	\N	\N	\N	\N	2026-01-09 02:51:56.291+00	{"days": 173, "observerName": "Eduardo Silvester"}	OBSERVADOR
42dc3018-c11b-401b-8178-42e213b6411a	RETRASO_DATOS-20c472b3-fabb-4fb4-aff1-52bf1e7824e2	20c472b3-fabb-4fb4-aff1-52bf1e7824e2	RETRASO_DATOS	Retraso en Entrega de Datos	Marea MC-162-25 (TANGO I) - 32 días de demora.	PENDIENTE	ALTA	2026-01-09 02:51:56.337+00	\N	\N	\N	\N	2026-01-09 02:51:56.338+00	{"vessel": "TANGO I", "busDays": 32, "mareaCode": "MC-162-25"}	MAREA
c1e5dbb6-f887-461f-9d7f-03d09293e572	RETRASO_DATOS-5a6bbfa4-a098-4b19-99aa-cc3ffdfbaafb	5a6bbfa4-a098-4b19-99aa-cc3ffdfbaafb	RETRASO_DATOS	Retraso en Entrega de Datos	Marea MC-169-25 (DUKAT) - 32 días de demora.	PENDIENTE	ALTA	2026-01-09 02:51:56.347+00	\N	\N	\N	\N	2026-01-09 02:51:56.348+00	{"vessel": "DUKAT", "busDays": 32, "mareaCode": "MC-169-25"}	MAREA
efd8dfbd-a539-463b-8592-d25d05af3274	FATIGA-366c1b74-afac-4cb3-99bc-4b7114bff512-2025	366c1b74-afac-4cb3-99bc-4b7114bff512	FATIGA	Fatiga Crítica Detectada	El observador Alejandro José Mazzei ha navegado 168 días en el año.	DESCARTADA	ALTA	2026-01-09 02:51:56.301+00	\N	2026-01-09 03:25:49.511+00	\N	\N	2026-01-09 03:25:49.513+00	{"days": 168, "observerName": "Alejandro José Mazzei"}	OBSERVADOR
e57713b2-e86f-45dd-9773-795a9162185b	RETRASO_DATOS-aec58204-f489-4d6f-a981-3b42ca4a341b	aec58204-f489-4d6f-a981-3b42ca4a341b	RETRASO_DATOS	Retraso en Entrega de Datos	Marea MC-174-25 (ERIN BRUCE II) - 32 días de demora.	PENDIENTE	ALTA	2026-01-09 02:51:56.358+00	\N	\N	\N	\N	2026-01-09 02:51:56.359+00	{"vessel": "ERIN BRUCE II", "busDays": 32, "mareaCode": "MC-174-25"}	MAREA
9d782478-26b2-43f3-a6ae-54e5188fe351	RETRASO_DATOS-8e16409e-972b-48dd-9ed5-e9c74a66d9f5	8e16409e-972b-48dd-9ed5-e9c74a66d9f5	RETRASO_DATOS	Retraso en Entrega de Datos	Marea MC-181-25 (MISS TIDE) - 27 días de demora.	PENDIENTE	ALTA	2026-01-09 02:51:56.388+00	\N	\N	\N	\N	2026-01-09 02:51:56.389+00	{"vessel": "MISS TIDE", "busDays": 27, "mareaCode": "MC-181-25"}	MAREA
321fd7b3-b54f-44e2-b8ea-006eb60eeabe	RETRASO_DATOS-d5596483-4141-4dbe-b48b-89012e691760	d5596483-4141-4dbe-b48b-89012e691760	RETRASO_DATOS	Retraso en Entrega de Datos	Marea MC-178-25 (TALISMAN) - 18 días de demora.	PENDIENTE	ALTA	2026-01-09 02:51:56.408+00	\N	\N	\N	\N	2026-01-09 02:51:56.408+00	{"vessel": "TALISMAN", "busDays": 18, "mareaCode": "MC-178-25"}	MAREA
7bb781c2-caec-4c3d-bff6-43a7e9564484	RETRASO_INFORME-04a1cdbe-7149-4e8d-977c-44f6d2f4a7e8	04a1cdbe-7149-4e8d-977c-44f6d2f4a7e8	RETRASO_INFORME	Informe Demorado	Marea MC-185-25 (ATREVIDO) - 23 días desde recepción.	PENDIENTE	MEDIA	2026-01-09 02:51:56.417+00	\N	\N	\N	\N	2026-01-09 02:51:56.418+00	{"vessel": "ATREVIDO", "busDays": 23, "mareaCode": "MC-185-25"}	MAREA
d31a1444-b753-4b4f-9aa0-3495be72dff6	RETRASO_INFORME-75a873cf-209e-4153-9151-bf4bb2d1458a	75a873cf-209e-4153-9151-bf4bb2d1458a	RETRASO_INFORME	Informe Demorado	Marea MC-161-25 (TANGO II) - 18 días desde recepción.	PENDIENTE	MEDIA	2026-01-09 02:51:56.426+00	\N	\N	\N	\N	2026-01-09 02:51:56.427+00	{"vessel": "TANGO II", "busDays": 18, "mareaCode": "MC-161-25"}	MAREA
43684dbf-7bea-4adf-b747-a111182a9099	RETRASO_DATOS-361d3933-1f72-4b73-9a61-b6e0f59c8765	361d3933-1f72-4b73-9a61-b6e0f59c8765	RETRASO_DATOS	Retraso en Entrega de Datos	Marea MC-180-25 (ATLANTIC EXPRESS) - 16 días de demora.	PENDIENTE	ALTA	2026-01-09 03:07:26.743+00	\N	\N	\N	\N	2026-01-09 03:07:26.747+00	{"vessel": "ATLANTIC EXPRESS", "busDays": 16, "mareaCode": "MC-180-25"}	MAREA
c120f37a-68bf-47c0-8b75-90ecb9ec3f76	FATIGA-bf21c0ee-9b33-4fac-83f0-694133cfd351-2025	bf21c0ee-9b33-4fac-83f0-694133cfd351	FATIGA	Fatiga Crítica Detectada	El observador Gabriel Osvaldo Catriel Gimenez Salinas ha navegado 166 días en el año.	RESUELTA	ALTA	2026-01-09 02:51:56.312+00	\N	2026-01-09 03:20:10.735+00	\N	\N	2026-01-09 03:20:10.74+00	{"days": 166, "observerName": "Gabriel Osvaldo Catriel Gimenez Salinas"}	OBSERVADOR
b4e1b87f-5abb-4c25-821f-d18e28e125c5	RETRASO_DATOS-29b952e7-e297-4266-9291-8620c4ac7f07	29b952e7-e297-4266-9291-8620c4ac7f07	RETRASO_DATOS	Retraso en Entrega de Datos	Marea MC-171-25 (CAPESANTE) - 28 días de demora.	RESUELTA	ALTA	2026-01-09 02:51:56.368+00	2026-01-16 00:00:00+00	2026-01-09 03:39:24.511+00	\N	\N	2026-01-09 03:39:24.512+00	{"vessel": "CAPESANTE", "busDays": 28, "mareaCode": "MC-171-25"}	MAREA
cb4cf2a9-c76c-41a7-8c7a-aa0a534cfc35	RETRASO_INFORME-424cd44c-1238-4a44-8b91-f642c33169e4	424cd44c-1238-4a44-8b91-f642c33169e4	RETRASO_INFORME	Informe Demorado	Marea MC-175-25 (ANITA) - 38 días desde recepción.	PENDIENTE	MEDIA	2026-01-13 23:40:18.848+00	\N	\N	\N	\N	2026-01-13 23:40:18.854+00	{"vessel": "ANITA", "busDays": 38, "mareaCode": "MC-175-25"}	MAREA
5573dafc-0fc2-42cc-9c39-cc5251d9c046	RETRASO_INFORME-5a6bbfa4-a098-4b19-99aa-cc3ffdfbaafb	5a6bbfa4-a098-4b19-99aa-cc3ffdfbaafb	RETRASO_INFORME	Informe Demorado	Marea MC-169-25 (DUKAT) - 37 días desde recepción.	PENDIENTE	MEDIA	2026-01-13 23:40:18.953+00	\N	\N	\N	\N	2026-01-13 23:40:18.954+00	{"vessel": "DUKAT", "busDays": 37, "mareaCode": "MC-169-25"}	MAREA
3ddb3668-b43d-4265-9aa2-b718e86a0031	RETRASO_INFORME-29b952e7-e297-4266-9291-8620c4ac7f07	29b952e7-e297-4266-9291-8620c4ac7f07	RETRASO_INFORME	Informe Demorado	Marea MC-171-25 (CAPESANTE) - 33 días desde recepción.	PENDIENTE	MEDIA	2026-01-13 23:40:18.964+00	\N	\N	\N	\N	2026-01-13 23:40:18.965+00	{"vessel": "CAPESANTE", "busDays": 33, "mareaCode": "MC-171-25"}	MAREA
b2b4c756-b480-40d3-a8ec-a5d008fdc6b2	RETRASO_INFORME-d5596483-4141-4dbe-b48b-89012e691760	d5596483-4141-4dbe-b48b-89012e691760	RETRASO_INFORME	Informe Demorado	Marea MC-178-25 (TALISMAN) - 23 días desde recepción.	PENDIENTE	MEDIA	2026-01-13 23:40:18.978+00	\N	\N	\N	\N	2026-01-13 23:40:18.979+00	{"vessel": "TALISMAN", "busDays": 23, "mareaCode": "MC-178-25"}	MAREA
b2b0a40d-a4ae-443e-a258-c586f2ac2db3	RETRASO_INFORME-361d3933-1f72-4b73-9a61-b6e0f59c8765	361d3933-1f72-4b73-9a61-b6e0f59c8765	RETRASO_INFORME	Informe Demorado	Marea MC-180-25 (ATLANTIC EXPRESS) - 20 días desde recepción.	PENDIENTE	MEDIA	2026-01-13 23:40:18.987+00	\N	\N	\N	\N	2026-01-13 23:40:18.989+00	{"vessel": "ATLANTIC EXPRESS", "busDays": 20, "mareaCode": "MC-180-25"}	MAREA
08b93fd3-5732-4cbe-981b-c85f2f9ccab7	RETRASO_DATOS-bb26bbcb-ee6d-4370-9c16-84f03d8d362b	bb26bbcb-ee6d-4370-9c16-84f03d8d362b	RETRASO_DATOS	Retraso en Entrega de Datos	Marea MC-183-25 (CHIYO MARU Nº 3) - 23 días de demora.	VENCIDA	ALTA	2026-01-09 02:51:56.397+00	2026-01-14 03:00:00+00	\N	\N	\N	2026-01-14 03:01:18.553+00	{"vessel": "CHIYO MARU Nº 3", "busDays": 23, "mareaCode": "MC-183-25"}	MAREA
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
4848871a-143e-4e91-890f-f27af4a75130	RETRASO_DATOS-16769449-70e9-4830-91df-fdb05cfda24f	16769449-70e9-4830-91df-fdb05cfda24f	RETRASO_DATOS	Retraso en Entrega de Datos	Marea MC-177-25 (UR ERTZA) - 28 días de demora.	PENDIENTE	ALTA	2026-01-13 23:44:45.96+00	2026-01-12 00:00:00+00	\N	\N	\N	2026-01-13 23:44:45.961+00	{"vessel": "UR ERTZA", "busDays": 28, "mareaCode": "MC-177-25"}	MAREA
15fedab0-a6a7-44d5-b2af-d0bb21bebef3	RETRASO_DATOS-70ec1fd8-6559-4e17-850f-dfbffe164b2b	70ec1fd8-6559-4e17-850f-dfbffe164b2b	RETRASO_DATOS	Retraso en Entrega de Datos	Marea MC-175-25 (ANITA) - 38 días de demora.	PENDIENTE	ALTA	2026-01-14 00:42:22.797+00	\N	\N	\N	\N	2026-01-14 00:42:22.798+00	{"vessel": "ANITA", "busDays": 38, "mareaCode": "MC-175-25"}	MAREA
594fadd0-7852-4317-98ec-25c14b05ed5b	RETRASO_DATOS-26138cad-87d4-482f-9e82-3a5b24e0c2c8	26138cad-87d4-482f-9e82-3a5b24e0c2c8	RETRASO_DATOS	Retraso en Entrega de Datos	Marea MC-162-25 (TANGO I) - 37 días de demora.	PENDIENTE	ALTA	2026-01-14 00:42:22.848+00	\N	\N	\N	\N	2026-01-14 00:42:22.849+00	{"vessel": "TANGO I", "busDays": 37, "mareaCode": "MC-162-25"}	MAREA
f3021041-ac84-412d-95d4-36f0ff400a45	RETRASO_DATOS-80616398-f6b9-4201-b08d-b39d5eb67ca4	80616398-f6b9-4201-b08d-b39d5eb67ca4	RETRASO_DATOS	Retraso en Entrega de Datos	Marea MC-169-25 (DUKAT) - 37 días de demora.	PENDIENTE	ALTA	2026-01-14 00:42:22.859+00	\N	\N	\N	\N	2026-01-14 00:42:22.859+00	{"vessel": "DUKAT", "busDays": 37, "mareaCode": "MC-169-25"}	MAREA
ca78eedb-86f7-4705-9863-6e5f3fd1911d	RETRASO_DATOS-12b7645b-a848-44ac-a2c7-f47f748f1cc6	12b7645b-a848-44ac-a2c7-f47f748f1cc6	RETRASO_DATOS	Retraso en Entrega de Datos	Marea MC-174-25 (ERIN BRUCE II) - 37 días de demora.	PENDIENTE	ALTA	2026-01-14 00:42:22.868+00	\N	\N	\N	\N	2026-01-14 00:42:22.87+00	{"vessel": "ERIN BRUCE II", "busDays": 37, "mareaCode": "MC-174-25"}	MAREA
1835185a-29e3-43a7-af75-e1e7b48f881b	RETRASO_DATOS-840d1c7b-9747-4b06-b53b-697e644a53ea	840d1c7b-9747-4b06-b53b-697e644a53ea	RETRASO_DATOS	Retraso en Entrega de Datos	Marea MC-171-25 (CAPESANTE) - 33 días de demora.	PENDIENTE	ALTA	2026-01-14 00:42:22.878+00	\N	\N	\N	\N	2026-01-14 00:42:22.878+00	{"vessel": "CAPESANTE", "busDays": 33, "mareaCode": "MC-171-25"}	MAREA
833af2d3-4285-4f6f-b83a-c179a60de0f8	RETRASO_DATOS-dd030597-448a-41db-b591-608b47597a5e	dd030597-448a-41db-b591-608b47597a5e	RETRASO_DATOS	Retraso en Entrega de Datos	Marea MC-177-25 (UR ERTZA) - 33 días de demora.	PENDIENTE	ALTA	2026-01-14 00:42:22.888+00	\N	\N	\N	\N	2026-01-14 00:42:22.889+00	{"vessel": "UR ERTZA", "busDays": 33, "mareaCode": "MC-177-25"}	MAREA
603589d8-bf4f-4e53-ab14-fbd299e335e1	RETRASO_DATOS-18873c09-e4fc-493b-b80b-ec01ae1eb66e	18873c09-e4fc-493b-b80b-ec01ae1eb66e	RETRASO_DATOS	Retraso en Entrega de Datos	Marea MC-181-25 (MISS TIDE) - 32 días de demora.	PENDIENTE	ALTA	2026-01-14 00:42:22.896+00	\N	\N	\N	\N	2026-01-14 00:42:22.896+00	{"vessel": "MISS TIDE", "busDays": 32, "mareaCode": "MC-181-25"}	MAREA
aa2bc414-ebcd-43f7-b19b-f666e6cc13f6	RETRASO_DATOS-68d4e4c7-151f-4a33-a2d6-a1a2ac165e9f	68d4e4c7-151f-4a33-a2d6-a1a2ac165e9f	RETRASO_DATOS	Retraso en Entrega de Datos	Marea MC-185-25 (ATREVIDO) - 28 días de demora.	PENDIENTE	ALTA	2026-01-14 00:42:22.906+00	\N	\N	\N	\N	2026-01-14 00:42:22.907+00	{"vessel": "ATREVIDO", "busDays": 28, "mareaCode": "MC-185-25"}	MAREA
d77f8f79-ff3a-4f07-98d0-161a517130b3	RETRASO_DATOS-7e201eae-7c97-485c-9670-915d228402e3	7e201eae-7c97-485c-9670-915d228402e3	RETRASO_DATOS	Retraso en Entrega de Datos	Marea MC-161-25 (TANGO II) - 23 días de demora.	PENDIENTE	ALTA	2026-01-14 00:42:22.915+00	\N	\N	\N	\N	2026-01-14 00:42:22.916+00	{"vessel": "TANGO II", "busDays": 23, "mareaCode": "MC-161-25"}	MAREA
88a530f0-0ad2-460c-9ed0-16ded3dcb04e	RETRASO_DATOS-e1421d6b-6654-4314-b373-0c7aef292054	e1421d6b-6654-4314-b373-0c7aef292054	RETRASO_DATOS	Retraso en Entrega de Datos	Marea MC-178-25 (TALISMAN) - 23 días de demora.	PENDIENTE	ALTA	2026-01-14 00:42:22.926+00	\N	\N	\N	\N	2026-01-14 00:42:22.928+00	{"vessel": "TALISMAN", "busDays": 23, "mareaCode": "MC-178-25"}	MAREA
051c29cb-a7e4-44fa-9365-78273a8b1dc3	RETRASO_DATOS-ecfe7292-b255-4865-bb32-5949e22b7802	ecfe7292-b255-4865-bb32-5949e22b7802	RETRASO_DATOS	Retraso en Entrega de Datos	Marea MC-180-25 (ATLANTIC EXPRESS) - 20 días de demora.	PENDIENTE	ALTA	2026-01-14 00:42:22.939+00	\N	\N	\N	\N	2026-01-14 00:42:22.939+00	{"vessel": "ATLANTIC EXPRESS", "busDays": 20, "mareaCode": "MC-180-25"}	MAREA
fc57a6cd-1345-4b32-bc37-71d33ddbd039	FATIGA-b33fd685-31a6-4510-a970-09a2d428a1bb-2025	b33fd685-31a6-4510-a970-09a2d428a1bb	FATIGA	Fatiga Crítica Detectada	El observador Johnatan Challier ha navegado 216 días en el año.	PENDIENTE	ALTA	2026-01-15 18:53:34.65+00	\N	\N	\N	\N	2026-01-15 18:53:34.658+00	{"days": 216, "observerName": "Johnatan Challier"}	OBSERVADOR
0450dc10-76bc-41b8-a7f4-3e8297f41b3f	FATIGA-06979c36-da6e-4fb0-840e-07533a1d41c7-2025	06979c36-da6e-4fb0-840e-07533a1d41c7	FATIGA	Fatiga Crítica Detectada	El observador Diego Gorosito ha navegado 185 días en el año.	PENDIENTE	ALTA	2026-01-15 18:53:34.797+00	\N	\N	\N	\N	2026-01-15 18:53:34.798+00	{"days": 185, "observerName": "Diego Gorosito"}	OBSERVADOR
a4bc5ee3-e256-4eb8-93d0-60391836a6ac	FATIGA-e148f60c-2aeb-442f-b302-491f4e0eca2b-2025	e148f60c-2aeb-442f-b302-491f4e0eca2b	FATIGA	Fatiga Crítica Detectada	El observador Nicolas Agustin Caballero ha navegado 193 días en el año.	PENDIENTE	ALTA	2026-01-15 18:53:34.805+00	\N	\N	\N	\N	2026-01-15 18:53:34.807+00	{"days": 193, "observerName": "Nicolas Agustin Caballero"}	OBSERVADOR
be1c876d-1dc5-4f68-b3a4-953e21c729d3	FATIGA-ccd3c2b4-fdfd-4d4e-b6c6-1a0dbbc02cf3-2025	ccd3c2b4-fdfd-4d4e-b6c6-1a0dbbc02cf3	FATIGA	Fatiga Crítica Detectada	El observador Héctor Eduardo Vera ha navegado 166 días en el año.	PENDIENTE	ALTA	2026-01-15 18:53:34.817+00	\N	\N	\N	\N	2026-01-15 18:53:34.818+00	{"days": 166, "observerName": "Héctor Eduardo Vera"}	OBSERVADOR
7cec15a4-7fbb-46f8-a668-6d3cbc9f2542	FATIGA-20b0118b-9612-4fa8-b90c-5e11e27b07e3-2025	20b0118b-9612-4fa8-b90c-5e11e27b07e3	FATIGA	Fatiga Crítica Detectada	El observador Nicolas Facundo Staneff Rotela ha navegado 188 días en el año.	PENDIENTE	ALTA	2026-01-15 18:53:34.829+00	\N	\N	\N	\N	2026-01-15 18:53:34.83+00	{"days": 188, "observerName": "Nicolas Facundo Staneff Rotela"}	OBSERVADOR
f75c519c-ea60-477b-8389-6183f59f7aa6	FATIGA-d7785cda-1f2e-4d29-a52d-335b2096bde6-2025	d7785cda-1f2e-4d29-a52d-335b2096bde6	FATIGA	Fatiga Crítica Detectada	El observador Pablo Julian Miranda ha navegado 202 días en el año.	PENDIENTE	ALTA	2026-01-15 18:53:34.837+00	\N	\N	\N	\N	2026-01-15 18:53:34.838+00	{"days": 202, "observerName": "Pablo Julian Miranda"}	OBSERVADOR
c9660ef5-0eed-4ee2-a6ad-194591726f0d	FATIGA-b500d7bc-3760-4c88-9a21-4294b2395c71-2025	b500d7bc-3760-4c88-9a21-4294b2395c71	FATIGA	Fatiga Crítica Detectada	El observador Durbal Villalba ha navegado 192 días en el año.	PENDIENTE	ALTA	2026-01-15 18:53:34.848+00	\N	\N	\N	\N	2026-01-15 18:53:34.849+00	{"days": 192, "observerName": "Durbal Villalba"}	OBSERVADOR
52c116f3-43c8-4503-8687-43ef3711750a	FATIGA-9a9b3bcd-4b8f-4aba-8ea5-3ec890e23fee-2025	9a9b3bcd-4b8f-4aba-8ea5-3ec890e23fee	FATIGA	Fatiga Crítica Detectada	El observador Daniel Alejandro Di Tullio ha navegado 166 días en el año.	PENDIENTE	ALTA	2026-01-15 18:53:34.856+00	\N	\N	\N	\N	2026-01-15 18:53:34.857+00	{"days": 166, "observerName": "Daniel Alejandro Di Tullio"}	OBSERVADOR
18867423-de19-4ab5-8ce9-29cfdcdf4e5b	FATIGA-66d4eb59-5d54-446b-9ee0-88fa9c133899-2025	66d4eb59-5d54-446b-9ee0-88fa9c133899	FATIGA	Fatiga Crítica Detectada	El observador Juan José Coppa ha navegado 217 días en el año.	PENDIENTE	ALTA	2026-01-15 18:53:34.866+00	\N	\N	\N	\N	2026-01-15 18:53:34.866+00	{"days": 217, "observerName": "Juan José Coppa"}	OBSERVADOR
2f847b88-a344-409c-9b6f-f4c336e84da7	FATIGA-dae8fea3-9440-4fd0-8212-7c8d9c5f4f20-2025	dae8fea3-9440-4fd0-8212-7c8d9c5f4f20	FATIGA	Fatiga Crítica Detectada	El observador Gianfranco Alvarez ha navegado 266 días en el año.	PENDIENTE	ALTA	2026-01-15 18:53:34.874+00	\N	\N	\N	\N	2026-01-15 18:53:34.875+00	{"days": 266, "observerName": "Gianfranco Alvarez"}	OBSERVADOR
a72d93c0-2ae7-4edd-9ae4-2f4c76e64317	FATIGA-7210834c-47be-440a-81d2-a5fc53a8934b-2025	7210834c-47be-440a-81d2-a5fc53a8934b	FATIGA	Fatiga Crítica Detectada	El observador Gabriel Osvaldo Catriel Gimenez Salinas ha navegado 166 días en el año.	PENDIENTE	ALTA	2026-01-15 18:53:34.883+00	\N	\N	\N	\N	2026-01-15 18:53:34.884+00	{"days": 166, "observerName": "Gabriel Osvaldo Catriel Gimenez Salinas"}	OBSERVADOR
65aa5daa-096a-4af6-926a-7f34f73d0d2c	FATIGA-fb61c911-79f8-45ed-8e0e-23bfa3a9ad2b-2025	fb61c911-79f8-45ed-8e0e-23bfa3a9ad2b	FATIGA	Fatiga Crítica Detectada	El observador Juan Manuel Staneff ha navegado 198 días en el año.	PENDIENTE	ALTA	2026-01-15 18:53:34.895+00	\N	\N	\N	\N	2026-01-15 18:53:34.895+00	{"days": 198, "observerName": "Juan Manuel Staneff"}	OBSERVADOR
0a9c7224-4a0f-436a-ba68-96d523ee28b6	FATIGA-d1d949b7-00fd-4756-8021-bc80d98ecf71-2025	d1d949b7-00fd-4756-8021-bc80d98ecf71	FATIGA	Fatiga Crítica Detectada	El observador Raul Bernardo Bargas Peña ha navegado 166 días en el año.	PENDIENTE	ALTA	2026-01-15 18:53:34.902+00	\N	\N	\N	\N	2026-01-15 18:53:34.903+00	{"days": 166, "observerName": "Raul Bernardo Bargas Peña"}	OBSERVADOR
c5c79307-b8c8-4031-b433-013a8a07563c	FATIGA-f644ca0f-bf5f-4449-9c40-7eba742654de-2025	f644ca0f-bf5f-4449-9c40-7eba742654de	FATIGA	Fatiga Crítica Detectada	El observador Luciano Matte Casietto ha navegado 187 días en el año.	PENDIENTE	ALTA	2026-01-15 18:53:34.911+00	\N	\N	\N	\N	2026-01-15 18:53:34.912+00	{"days": 187, "observerName": "Luciano Matte Casietto"}	OBSERVADOR
372e8049-2d38-49d7-ba5c-53388fa55346	FATIGA-8ced3542-9444-4153-b141-27ed65a5995b-2025	8ced3542-9444-4153-b141-27ed65a5995b	FATIGA	Fatiga Crítica Detectada	El observador Teresa Beatriz Reinaga ha navegado 216 días en el año.	PENDIENTE	ALTA	2026-01-15 18:53:34.918+00	\N	\N	\N	\N	2026-01-15 18:53:34.919+00	{"days": 216, "observerName": "Teresa Beatriz Reinaga"}	OBSERVADOR
aa41bbbd-cf00-4053-b7d4-1ff13710f14d	FATIGA-372bbb60-ca31-49ff-9ef9-fd5d49beb720-2025	372bbb60-ca31-49ff-9ef9-fd5d49beb720	FATIGA	Fatiga Crítica Detectada	El observador Diego Sebastian Marchiori ha navegado 165 días en el año.	PENDIENTE	ALTA	2026-01-15 18:53:34.928+00	\N	\N	\N	\N	2026-01-15 18:53:34.928+00	{"days": 165, "observerName": "Diego Sebastian Marchiori"}	OBSERVADOR
63ee38ca-8d6c-4021-8c28-1d383cadf1fe	FATIGA-c8fdee90-2d16-4800-8a4d-e6b470cf152d-2025	c8fdee90-2d16-4800-8a4d-e6b470cf152d	FATIGA	Fatiga Crítica Detectada	El observador Cristian Emmanuel Cerrina ha navegado 193 días en el año.	PENDIENTE	ALTA	2026-01-15 18:53:34.936+00	\N	\N	\N	\N	2026-01-15 18:53:34.937+00	{"days": 193, "observerName": "Cristian Emmanuel Cerrina"}	OBSERVADOR
\.


--
-- Data for Name: alertas_eventos; Type: TABLE DATA; Schema: public; Owner: -
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
5263a683-25df-4a04-adaa-08718460d6e9	cb4cf2a9-c76c-41a7-8c7a-aa0a534cfc35	2026-01-13 23:40:18.894+00	\N	CREACION	Alerta detectada/creada
a7a2a34c-174f-46cc-a8d8-58cf703f3bc7	5573dafc-0fc2-42cc-9c39-cc5251d9c046	2026-01-13 23:40:18.959+00	\N	CREACION	Alerta detectada/creada
e4919df2-381f-4a51-a1a3-0b0dcc3b9de5	3ddb3668-b43d-4265-9aa2-b718e86a0031	2026-01-13 23:40:18.968+00	\N	CREACION	Alerta detectada/creada
e76293b2-4ad5-41e0-bab8-93f05753b19f	b2b4c756-b480-40d3-a8ec-a5d008fdc6b2	2026-01-13 23:40:18.983+00	\N	CREACION	Alerta detectada/creada
1577cb5f-3769-4bb2-b69a-777afa3561d2	b2b0a40d-a4ae-443e-a258-c586f2ac2db3	2026-01-13 23:40:18.993+00	\N	CREACION	Alerta detectada/creada
5da00b40-f719-4566-a2b5-c0a2a019f668	4848871a-143e-4e91-890f-f27af4a75130	2026-01-13 23:40:19.03+00	\N	CAMBIO_ESTADO	Estado: SEGUIMIENTO -> VENCIDA. Notas: Re-check vencido el 11/1/2026.
9b0f9535-d841-4c21-99d0-b82dead55089	c120f37a-68bf-47c0-8b75-90ecb9ec3f76	2026-01-09 03:20:10.768+00	\N	CAMBIO_ESTADO	Estado: PENDIENTE -> RESUELTA. Notas: Llamar
f604bc00-b695-44b5-a817-8ed5b550034b	efd8dfbd-a539-463b-8592-d25d05af3274	2026-01-09 03:25:49.537+00	\N	CAMBIO_ESTADO	Estado: PENDIENTE -> DESCARTADA. Notas: Va a seguir navegando
9aff6b9c-89a1-464c-86cb-2b8836d444cf	b4e1b87f-5abb-4c25-821f-d18e28e125c5	2026-01-09 03:33:27.427+00	\N	CAMBIO_ESTADO	Estado: PENDIENTE -> SEGUIMIENTO. Notas: Se llamó para preguntar
86a90bb2-73f5-432d-bc36-f40deba45005	b4e1b87f-5abb-4c25-821f-d18e28e125c5	2026-01-09 03:38:54.156+00	\N	COMENTARIO	Se llamó para reclamar
71dbbe69-9b84-4c99-84c3-0f5b8cb5c0f5	b4e1b87f-5abb-4c25-821f-d18e28e125c5	2026-01-09 03:39:24.519+00	\N	CAMBIO_ESTADO	Estado: SEGUIMIENTO -> RESUELTA. Notas: Se llamó para reclamar
6e274db6-5d26-42c7-8756-b162ea036de1	4848871a-143e-4e91-890f-f27af4a75130	2026-01-09 03:39:43.923+00	\N	CAMBIO_ESTADO	Estado: PENDIENTE -> SEGUIMIENTO. Notas: Llamada de reclamo
1b85fca4-c982-4736-afc6-528d55879c28	4848871a-143e-4e91-890f-f27af4a75130	2026-01-09 03:40:04.04+00	\N	COMENTARIO	Se llamó otra vez
09d546ca-bf8e-4097-bf51-f44a3b729595	08b93fd3-5732-4cbe-981b-c85f2f9ccab7	2026-01-10 01:34:12.938+00	\N	COMENTARIO	Se envió un reclamo de documentación por correo electrónico el 09/01/2026.
4e92e67f-6884-4acb-912b-0202be938833	08b93fd3-5732-4cbe-981b-c85f2f9ccab7	2026-01-10 01:34:32.252+00	\N	CAMBIO_ESTADO	Estado: PENDIENTE -> SEGUIMIENTO. Notas: Se envió nota de reclamo
3061ab56-78d6-4dab-b0b6-7d39fc2ec893	08b93fd3-5732-4cbe-981b-c85f2f9ccab7	2026-01-14 01:21:30.618+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	COMENTARIO	Se cambia fecha de recordatorio
1f920a2e-2c89-4164-a4ae-2a0113834750	08b93fd3-5732-4cbe-981b-c85f2f9ccab7	2026-01-14 01:33:32.633+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	COMENTARIO	Corregir fecha de recordatorio
a1102658-8b95-4c13-8244-acea7c7630d5	fc57a6cd-1345-4b32-bc37-71d33ddbd039	2026-01-15 18:53:34.719+00	\N	CREACION	Alerta detectada/creada
01b42c48-282a-444f-a38b-d1a7ecda0d6f	0450dc10-76bc-41b8-a7f4-3e8297f41b3f	2026-01-15 18:53:34.801+00	\N	CREACION	Alerta detectada/creada
0206aeea-ba3f-4087-8d02-6002add42c1b	a4bc5ee3-e256-4eb8-93d0-60391836a6ac	2026-01-15 18:53:34.812+00	\N	CREACION	Alerta detectada/creada
00c74c92-3173-48cb-8a52-ce1ce1f6f28d	be1c876d-1dc5-4f68-b3a4-953e21c729d3	2026-01-15 18:53:34.822+00	\N	CREACION	Alerta detectada/creada
d1e30322-f125-4525-be0b-22f87b1e7bd1	7cec15a4-7fbb-46f8-a668-6d3cbc9f2542	2026-01-15 18:53:34.833+00	\N	CREACION	Alerta detectada/creada
6679cdbb-ef9a-41c0-9dd2-11571ecced38	f75c519c-ea60-477b-8389-6183f59f7aa6	2026-01-15 18:53:34.843+00	\N	CREACION	Alerta detectada/creada
5e5eaecb-f267-43db-9ec8-b61fcf861983	c9660ef5-0eed-4ee2-a6ad-194591726f0d	2026-01-15 18:53:34.851+00	\N	CREACION	Alerta detectada/creada
10fea4d0-4320-4d76-8696-8612df217193	52c116f3-43c8-4503-8687-43ef3711750a	2026-01-15 18:53:34.861+00	\N	CREACION	Alerta detectada/creada
bfeeff20-92ea-48fd-bf98-0be1bee29fb4	18867423-de19-4ab5-8ce9-29cfdcdf4e5b	2026-01-15 18:53:34.869+00	\N	CREACION	Alerta detectada/creada
828520b1-0475-429a-b3dc-b329803ca219	2f847b88-a344-409c-9b6f-f4c336e84da7	2026-01-15 18:53:34.879+00	\N	CREACION	Alerta detectada/creada
df07da2d-b34f-4edb-8e59-ae1a66b14123	15fedab0-a6a7-44d5-b2af-d0bb21bebef3	2026-01-14 00:42:22.827+00	\N	CREACION	Alerta detectada/creada
0facfc16-a4fa-4e6c-b47b-a3f67beb1bfe	594fadd0-7852-4317-98ec-25c14b05ed5b	2026-01-14 00:42:22.853+00	\N	CREACION	Alerta detectada/creada
b96dd4bd-80a2-4c53-9870-6dcec86000e1	f3021041-ac84-412d-95d4-36f0ff400a45	2026-01-14 00:42:22.863+00	\N	CREACION	Alerta detectada/creada
8207602c-7695-4a44-8091-05f0d2ff7400	ca78eedb-86f7-4705-9863-6e5f3fd1911d	2026-01-14 00:42:22.874+00	\N	CREACION	Alerta detectada/creada
4abdd851-708c-490b-83b9-5f4f68527350	1835185a-29e3-43a7-af75-e1e7b48f881b	2026-01-14 00:42:22.882+00	\N	CREACION	Alerta detectada/creada
3ba28f8c-ce08-461d-bd33-9d59924bb336	833af2d3-4285-4f6f-b83a-c179a60de0f8	2026-01-14 00:42:22.892+00	\N	CREACION	Alerta detectada/creada
a1d71396-763b-49b9-b7e2-a8f64dffb3e9	603589d8-bf4f-4e53-ab14-fbd299e335e1	2026-01-14 00:42:22.9+00	\N	CREACION	Alerta detectada/creada
5014bcb1-f072-40f3-8ea8-8979490b5483	aa2bc414-ebcd-43f7-b19b-f666e6cc13f6	2026-01-14 00:42:22.91+00	\N	CREACION	Alerta detectada/creada
775b51d2-049c-4672-8a81-60911d01174a	d77f8f79-ff3a-4f07-98d0-161a517130b3	2026-01-14 00:42:22.921+00	\N	CREACION	Alerta detectada/creada
306458ba-b467-4d56-9c91-dc1002e013ae	88a530f0-0ad2-460c-9ed0-16ded3dcb04e	2026-01-14 00:42:22.932+00	\N	CREACION	Alerta detectada/creada
2c09d6c6-d0f2-483b-b483-44ce55c4d4e2	051c29cb-a7e4-44fa-9365-78273a8b1dc3	2026-01-14 00:42:22.943+00	\N	CREACION	Alerta detectada/creada
c368a406-0b4d-4672-9989-6781e434e4b7	08b93fd3-5732-4cbe-981b-c85f2f9ccab7	2026-01-14 01:22:00.949+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	COMENTARIO	Cambiar fecha de recordatorio
7435c44e-e77e-45eb-b7e7-435d210b778d	08b93fd3-5732-4cbe-981b-c85f2f9ccab7	2026-01-14 03:01:18.58+00	\N	CAMBIO_ESTADO	Estado: SEGUIMIENTO -> VENCIDA. Notas: Re-check vencido el 14/1/2026.
864ba0fe-7ba3-4b2b-b0c7-ee9542e26ef8	a72d93c0-2ae7-4edd-9ae4-2f4c76e64317	2026-01-15 18:53:34.888+00	\N	CREACION	Alerta detectada/creada
1c481046-f86a-4a59-849b-b9325553a6a7	65aa5daa-096a-4af6-926a-7f34f73d0d2c	2026-01-15 18:53:34.898+00	\N	CREACION	Alerta detectada/creada
5811b76a-fbe2-4b52-9268-83348222ec47	0a9c7224-4a0f-436a-ba68-96d523ee28b6	2026-01-15 18:53:34.907+00	\N	CREACION	Alerta detectada/creada
c7c0a216-0405-4cd9-bb3f-fb98e64bbbee	c5c79307-b8c8-4031-b433-013a8a07563c	2026-01-15 18:53:34.915+00	\N	CREACION	Alerta detectada/creada
0ff40c65-1bd0-496e-af06-257135f1205a	372e8049-2d38-49d7-ba5c-53388fa55346	2026-01-15 18:53:34.923+00	\N	CREACION	Alerta detectada/creada
c08c0763-a1b5-408f-9b3b-bdd89186f948	aa41bbbd-cf00-4053-b7d4-1ff13710f14d	2026-01-15 18:53:34.931+00	\N	CREACION	Alerta detectada/creada
bffbccba-7471-40f6-aba5-ad9b504fc5df	63ee38ca-8d6c-4021-8c28-1d383cadf1fe	2026-01-15 18:53:34.941+00	\N	CREACION	Alerta detectada/creada
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
6b91cf15-15c5-4548-a9e3-104dceb65a6b	7 de Diciembre	TEMP-0001	1013	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	27.20	521	34aeab48-9c9b-4c06-8a45-3469f866cf88		Mar del Plata	4895032		\N	operacionesconsultoramaritima@gmail.com	\N	\N	Consultora Maritima	t	\N	\N	\N
83fb4a61-ef1b-4b26-acf5-80204da01607	ACRUX	03086	0	991d17ee-9376-401c-8883-c0409127d0af	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	28.00	0	34aeab48-9c9b-4c06-8a45-3469f866cf88	DE ANGELIS Y LOGGHE S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
7d8026d0-9add-4472-a8c5-f57d13c4db0c	ALDEBARAN	01741	1038	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	26.42	426	34aeab48-9c9b-4c06-8a45-3469f866cf88	PESQUERA SAN ROQUE	Mar del Plata		480-0573	\N		\N	\N		t	\N	\N	\N
2f549778-30fe-4489-8358-5102e9188bec	ALTALENA	0181	1051	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	55.80	1350	34aeab48-9c9b-4c06-8a45-3469f866cf88	MARONTI  S.A.	Mar del Plata	4800005		\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi	t	\N	\N	\N
92841747-cb76-4be9-a489-87a264d732ae	ALVAREZ ENTRENA I	02454	1055	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	39.43	988	105b0349-a9ed-49bf-9336-aad8d3867f0b	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
b97c8b73-de15-4a34-a786-8d75cce848e8	ALVAREZ ENTRENA II	02465	1056	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	39.50	988	105b0349-a9ed-49bf-9336-aad8d3867f0b	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
eb2ca33e-a33f-49a4-84e0-7d5b77ddaa2f	ALVAREZ ENTRENA III	02379	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	\N	\N	105b0349-a9ed-49bf-9336-aad8d3867f0b	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
a69891b1-b1e6-434b-a28b-b08d5c9ae148	BAFFETTA	02635	0	04d57c5c-390c-4334-bba9-d4635e1cb0c0	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	19.45	295	105b0349-a9ed-49bf-9336-aad8d3867f0b	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
8a186007-01dd-4b03-9288-09cfa051ee2a	ALVAREZ ENTRENA VI	01	2774	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	30.50	1033	105b0349-a9ed-49bf-9336-aad8d3867f0b	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
b4a25742-4678-4c44-80c1-816286bda5ef	AMBITION	01324	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	PESQUERA TRES MARIAS  S.A.	Mar del Plata		480-0336	\N		\N	\N		t	\N	\N	\N
cad32064-7964-4a41-9f30-a1998363ab99	ANITA	3	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	\N	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	SOLIMENO	Mar del Plata			\N		\N	\N		t	\N	\N	\N
2be15b59-6090-4cdb-8c35-9949cfce4a7f	ANA III	278	1069	04d57c5c-390c-4334-bba9-d4635e1cb0c0	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	19.95	443	105b0349-a9ed-49bf-9336-aad8d3867f0b	POSEIDON  S.A.	Puerto Madryn		0280-445-7786	\N		\N	\N		t	\N	\N	\N
4e307e7b-e807-416f-9eeb-e45a92cea4c9	ANABELLA  M	0175	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	60	\N	\N	105b0349-a9ed-49bf-9336-aad8d3867f0b	PESCAPUERTA ARGENTINA  S.A.	Puerto Madryn		0280-445-4407	\N		\N	\N		t	\N	\N	\N
3f5729dd-4d20-4e27-a7f1-ef46d30e973d	ANDRES JORGE	1065	2760	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	50.10	1102	34aeab48-9c9b-4c06-8a45-3469f866cf88	MARONTI  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
54ad51f8-1cb9-4c43-a194-b541f45e442a	ANGELUS	01953	1087	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	52.60	1337	11c64a29-e693-4bef-b734-8162f86cbbcc	PESQUERA CRUZ DEL SUR  S.A.	Ciudad Autónoma de Buenos Aires		011-4784-1760	\N		\N	\N		t	\N	\N	\N
bd1575b6-e2ff-4f4f-8f74-88b7e0f0d789	ANITA ALVAREZ	02138	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	\N	\N	105b0349-a9ed-49bf-9336-aad8d3867f0b	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
c08f87a4-7d05-4410-9742-9f2016366f8b	ANTARTIC  I	0232	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	3b9fe535-63a2-4982-b7d4-71229ab250dc	\N	60	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	ESTREMAR  S.A.	Ciudad Autónoma de Buenos Aires		011-6533-7853 / 4345-1102	\N		\N	\N		t	\N	\N	\N
57cbf349-236a-4456-b04f-b3edc0a901f3	ANTARTIC II	0263	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	3b9fe535-63a2-4982-b7d4-71229ab250dc	\N	60	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	ESTREMAR  S.A.	Ciudad Autónoma de Buenos Aires		011-6533-7853 / 4345-1102	\N		\N	\N		t	\N	\N	\N
b06f99bb-c7ab-4fe2-9512-664c85f00f94	ANTARTIC III	0262	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	3b9fe535-63a2-4982-b7d4-71229ab250dc	\N	60	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	ESTREMAR  S.A.	Ciudad Autónoma de Buenos Aires		011-6533-7853 / 4345-1102	\N		\N	\N		t	\N	\N	\N
fcf8ba53-a4f6-4ba2-b0f9-7b8b4b08e04b	ANTARTIDA	0678	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	60	\N	\N	105b0349-a9ed-49bf-9336-aad8d3867f0b	IBERCONSA  DE ARGENTINA  S.A.	Puerto Madryn	4891227	0280-445-4324	\N	serviciosmaritimosmdq@gmail.com	\N	\N	Servicio Maritimo Integral	t	\N	\N	\N
719eb0f1-d0e5-4131-b3e7-dc30f1a7ea9b	ANTONINO	0877	1099	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	27.60	541	34aeab48-9c9b-4c06-8a45-3469f866cf88	AGLIPESCA  S.A.	Mar del Plata		480-2886	\N		\N	\N		t	\N	\N	\N
603c1c20-9b81-44a9-a414-a31724275500	ANTONIO ALVAREZ	01429	1100	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	36.60	1168	105b0349-a9ed-49bf-9336-aad8d3867f0b	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
3b348b9c-3d4e-449c-abf7-4de19cda2339	API II	0679	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	60	\N	\N	105b0349-a9ed-49bf-9336-aad8d3867f0b	IBERCONSA  DE ARGENTINA  S.A.	Puerto Madryn		0280-445-4324	\N		\N	\N		t	\N	\N	\N
5967b416-f988-4c0b-9cf0-d7bef41f7e41	API IV	0680	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	60	\N	\N	105b0349-a9ed-49bf-9336-aad8d3867f0b	IBERCONSA  DE ARGENTINA  S.A.	Puerto Madryn		0280-445-4324	\N		\N	\N		t	\N	\N	\N
07acb95b-f5c8-4ed4-b6d7-d69ae4ba57ad	API V	02781	2711	bbebd1ff-edd5-48dd-925c-9735bb61b50d	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	60	77.40	2960	105b0349-a9ed-49bf-9336-aad8d3867f0b	IBERCONSA  DE ARGENTINA  S.A.	Puerto Madryn		0280-445-4324	\N		\N	\N		t	\N	\N	\N
f90590d9-8b70-4045-b68e-8e79e9317e2c	API VI	02812	2734	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	40	36.35	1201	105b0349-a9ed-49bf-9336-aad8d3867f0b	IBERCONSA  DE ARGENTINA  S.A.	Puerto Madryn		0280-445-4324	\N		\N	\N		t	\N	\N	\N
34a96d23-cf3a-4eea-b136-56b64fa5239c	API VII	03081	2777	bbebd1ff-edd5-48dd-925c-9735bb61b50d	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	60	72.20	0	105b0349-a9ed-49bf-9336-aad8d3867f0b	IBERCONSA  DE ARGENTINA  S.A.	Puerto Madryn		0280-445-4324	\N		\N	\N		t	\N	\N	\N
dada5ece-cf56-4aab-996b-f8151039567e	ARBUMASA X	6183	1114	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	35.30	1087	f41ff939-bc00-4bbd-8ce8-c451922ba284	ARBUMASA  S.A.	Puerto Deseado		0297-487-2807 / 444-5338 / 444-1201	\N		\N	\N		t	\N	\N	\N
d744066d-a334-4b07-93d0-c5017a925720	ARBUMASA XIX	06440	1117	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	36.40	870	f41ff939-bc00-4bbd-8ce8-c451922ba284	ARBUMASA  S.A.	Puerto Deseado		0297-487-2807 / 444-5338 / 444-1201	\N		\N	\N		t	\N	\N	\N
343d01a4-d945-444f-be6f-265324c9413b	ARBUMASA  XVII	0216	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	\N	\N	f41ff939-bc00-4bbd-8ce8-c451922ba284	ARBUMASA  S.A.	Puerto Deseado		0297-487-2807 / 444-5338 / 444-1201	\N		\N	\N		t	\N	\N	\N
ca667a2a-0e37-471c-b798-6448c4841ac8	ARBUMASA XIV	0213	1116	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	36.40	1047	f41ff939-bc00-4bbd-8ce8-c451922ba284	ARBUMASA  S.A.	Puerto Deseado		0297-487-2807 / 444-5338 / 444-1201	\N		\N	\N		t	\N	\N	\N
03bf8fc0-df37-48c1-bf28-22df463a42ff	ARBUMASA XV	214	1118	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	36.40	870	\N	ARBUMASA  S.A.				\N		\N	\N		t	\N	\N	\N
3e1e8d2a-eb33-4277-a59f-47d0b61fd8a3	ARBUMASA XVI	0215	1119	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	36.40	1047	f41ff939-bc00-4bbd-8ce8-c451922ba284	ARBUMASA  S.A.	Puerto Deseado		0297-487-2807 / 444-5338 / 444-1201	\N		\N	\N		t	\N	\N	\N
78f9dfcb-3e2a-401e-b30c-ca0123adf957	ARBUMASA XVIII	0217	1121	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	36.40	870	f41ff939-bc00-4bbd-8ce8-c451922ba284	ARBUMASA  S.A.	Puerto Deseado	4893758	0297-487-2807 / 444-5338 / 444-1201	\N	miguel-visoso@hotmail.com	\N	\N	Agencia Maritima Solvox	t	\N	\N	\N
10d710cd-fd2f-4fd5-9730-d67e11b64329	ARBUMASA XXIX	02561	1126	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	65.60	1776	34aeab48-9c9b-4c06-8a45-3469f866cf88	BAL - FISH  S.A.	Mar del Plata		489-6522	\N		\N	\N		t	\N	\N	\N
47f407c7-9b97-48a2-a5d2-f1654d4067df	ARBUMASA XXVI	01958	1127	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	62.80	2403	f41ff939-bc00-4bbd-8ce8-c451922ba284	ARBUMASA  S.A.	Puerto Deseado	4893758	0297-487-2807 / 444-5338 / 444-1201	\N	miguel-visoso@hotmail.com	\N	\N	Agencia Maritima Solvox	t	\N	\N	\N
9a35efaa-cc4c-4fb6-afaa-f48e7709c800	ARBUMASA XXVII	02057	1128	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	64.21	1154	34aeab48-9c9b-4c06-8a45-3469f866cf88	BAL - FISH  S.A.	Mar del Plata		489-6522	\N		\N	\N		t	\N	\N	\N
a55f3785-99ec-4342-84b4-1920e07cbda0	ARBUMASA XXVIII	02569	1129	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	64.40	1776	f41ff939-bc00-4bbd-8ce8-c451922ba284	ARBUMASA  S.A.	Puerto Deseado		0297-487-2807 / 444-5338 / 444-1201	\N		\N	\N		t	\N	\N	\N
78c79d24-52cd-4c2a-b51c-6b3e238d2d72	ARCANGEL	79	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	CALME  S.A.	Mar del Plata		480-3545	\N		\N	\N		t	\N	\N	\N
58a214be-3946-4800-b7ba-fd90134ca406	ARESIT	02265	1134	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	36.26	1085	105b0349-a9ed-49bf-9336-aad8d3867f0b	HARENGUS  S.A.	Puerto Madryn	4808331/4808332	0280-445-0822	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
15d3efd3-e46e-4a45-9a33-d2623e1b3bf0	ARGENOVA I	02180	1137	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	35.00	655	f41ff939-bc00-4bbd-8ce8-c451922ba284	ARGENOVA  S.A.	Puerto Deseado	4808331/4808332	0297- 487-0550  (447-2818  Com. Riv )	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
3cfb8bb0-4cd7-4870-a38b-257a9d46f9e8	ARGENOVA IV	02157	1140	bbebd1ff-edd5-48dd-925c-9735bb61b50d	\N	\N	0	36.26	675	f41ff939-bc00-4bbd-8ce8-c451922ba284	MAR DE LAS PALMAS  S.A.	Puerto Deseado	4808331/4808332	0297-487-2112	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
37d9084a-1678-4c14-98c6-4e0e95404158	ARGENOVA X	02329	1146	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	32.50	550	f41ff939-bc00-4bbd-8ce8-c451922ba284	ARGENOVA  S.A.	Puerto Deseado	4808331/4808332	0297- 487-0550  (447-2818  Com. Riv )	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
f9937a01-2466-4204-83be-d7e1bd958ef8	ARGENOVA XI	02199	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	3b9fe535-63a2-4982-b7d4-71229ab250dc	\N	60	\N	\N	f41ff939-bc00-4bbd-8ce8-c451922ba284	ARGENOVA  S.A.	Puerto Deseado	4808331/4808332	0297- 487-0550  (447-2818  Com. Riv )	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
863ff4de-02ab-477a-b726-83d3e9148648	ARGENOVA XXI	02661	2704	bbebd1ff-edd5-48dd-925c-9735bb61b50d	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	60	55.80	1826	f41ff939-bc00-4bbd-8ce8-c451922ba284	ARGENOVA  S.A.	Puerto Deseado	4808331/4808332	0297- 487-0550  (447-2818  Com. Riv )	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
79b204c7-5ff4-42e9-a7de-de8ea34d8555	ARGENOVA XXII	02714	2713	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	40	37.70	663	f41ff939-bc00-4bbd-8ce8-c451922ba284	ARGENOVA  S.A.	Puerto Deseado	4808331/4808332	0297- 487-0550  (447-2818  Com. Riv )	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
f825612e-17ba-46cb-a573-b6951867ade3	ARGENOVA XXIII	02713	2707	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	37.19	678	f41ff939-bc00-4bbd-8ce8-c451922ba284	ARGENOVA  S.A.	Puerto Deseado	4808331/4808332	0297- 487-0550  (447-2818  Com. Riv )	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
df12f2d3-a96c-42b0-bb93-dfe21c48e3cf	ARGENOVA XXIV	02752	2731	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	38.80	675	f41ff939-bc00-4bbd-8ce8-c451922ba284	ARGENOVA  S.A.	Puerto Deseado	4808331/4808332	0297- 487-0550  (447-2818  Com. Riv )	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
0b05adc0-bf86-40b7-a0f0-21db3b022436	ARGENOVA XXV	028011	2740	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	39.70	859	f41ff939-bc00-4bbd-8ce8-c451922ba284	ARGENOVA  S.A.	Puerto Deseado	4808331/4808332	0297- 487-0550  (447-2818  Com. Riv )	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
73bf08ce-9b6f-49c6-9bc6-1d813ec65612	ARGENOVA XXVI	02849	2739	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	37.15	1086	f41ff939-bc00-4bbd-8ce8-c451922ba284	ARGENOVA  S.A.	Puerto Deseado	4808331/4808332	0297- 487-0550  (447-2818  Com. Riv )	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
0a7aed5b-7fc3-4b95-aeea-754431932603	ARGENOVA II	02177	1138	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	38.50	1168	f41ff939-bc00-4bbd-8ce8-c451922ba284	ARGENOVA  S.A.	Puerto Deseado	4808331/4808332	0297- 487-0550  (447-2818  Com. Riv )	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
f6c23971-fea0-4edb-9f23-f6dc8d1db49f	ARGENOVA III	02156	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	\N	\N	f41ff939-bc00-4bbd-8ce8-c451922ba284	ARGENOVA  S.A.	Puerto Deseado		0297- 487-0550  (447-2818  Com. Riv )	\N		\N	\N		t	\N	\N	\N
1efe2272-764f-43ca-a530-f385cedd031d	ARGENOVA IX	02328	1141	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	32.50	550	f41ff939-bc00-4bbd-8ce8-c451922ba284	ARGENOVA  S.A.	Puerto Deseado	4808331/4808332	0297- 487-0550  (447-2818  Com. Riv )	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
9fab8c3e-616e-4557-a11a-888a9919a2e5	ARGENOVA XII	0199	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	3b9fe535-63a2-4982-b7d4-71229ab250dc	\N	60	\N	\N	f41ff939-bc00-4bbd-8ce8-c451922ba284	ARGENOVA  S.A.	Puerto Deseado	4808331/4808332	0297- 487-0550  (447-2818  Com. Riv )	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
c163d5e5-5d60-4da4-9b33-f0b9e16ceccd	ARGENOVA XIV	0197	1149	bbebd1ff-edd5-48dd-925c-9735bb61b50d	3b9fe535-63a2-4982-b7d4-71229ab250dc	\N	60	52.30	1352	f41ff939-bc00-4bbd-8ce8-c451922ba284	ARGENOVA  S.A.	Puerto Deseado	4808331/4808332	0297- 487-0550  (447-2818  Com. Riv )	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
f85c4fc2-bf5d-4c58-94c4-1b9bdc6649c5	ARGENOVA XV	0198	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	3b9fe535-63a2-4982-b7d4-71229ab250dc	\N	60	\N	\N	f41ff939-bc00-4bbd-8ce8-c451922ba284	ARGENOVA  S.A.	Puerto Deseado	4800274	0297- 487-0550  (447-2818  Com. Riv )	\N	amalfitanoycia@hotmail.com	\N	\N	Agencia Maritima Almafitano	t	\N	\N	\N
56ea7c96-54cb-4759-ba2a-74dd8a4fe0a2	ARGENTINO	0142	1157	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	33.77	1001	34aeab48-9c9b-4c06-8a45-3469f866cf88	PESQUERA VERAZ  S.A.	Mar del Plata		489-4624 / 489-0314 (astillero)	\N		\N	\N		t	\N	\N	\N
6ba941e5-6de0-41c5-b1de-2a45d42e534c	ARKOFISH	0236	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	105b0349-a9ed-49bf-9336-aad8d3867f0b	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
f109f4ad-02e1-4b66-bd7c-61d6c9c8ca5c	ARKOFISH I	6004	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	105b0349-a9ed-49bf-9336-aad8d3867f0b	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
0ef3fcf7-ae31-4330-864c-347c4617e5e8	ARRUFO	0540	1165	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	39.16	1102	34aeab48-9c9b-4c06-8a45-3469f866cf88	LUIS SOLIMENO e HIJOS  S.A.	Mar del Plata		489-3030	\N		\N	\N		t	\N	\N	\N
fc45cb2f-6a50-4eb8-a70c-42ed0cae19ae	ASUDEPES II	6363	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	ASUDEPES  S.A.	Ciudad Autónoma de Buenos Aires		011-4383-9756	\N		\N	\N		t	\N	\N	\N
96da2dba-ee2f-404e-a032-9c4bede0fc8c	ASUDEPES III	6062	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	ASUDEPES  S.A.	Ciudad Autónoma de Buenos Aires		011-4383-9756	\N		\N	\N		t	\N	\N	\N
a16cce31-d12d-458a-b212-6846185933bf	ATLANTIC EXPRESS	02936	2727	bbebd1ff-edd5-48dd-925c-9735bb61b50d	1f5e5c39-7fd2-4fb1-8697-d5e0e9a4022b	\N	30	53.70	3426	34aeab48-9c9b-4c06-8a45-3469f866cf88	WANCHESE ARGENTINA  S.A.	Mar del Plata		489-1236	\N		\N	\N		t	\N	\N	\N
7f9ea3c8-1751-4a92-baa8-99cd0beb6d1e	ATLANTIC SURF I	0350	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	40	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	GLACIAR PESQUERA  S.A.	Mar del Plata	4890960	492-2216	\N	agencia@maritimavidal.com.ar	\N	\N	Agencia Maritima Vidal	t	\N	\N	\N
2df50464-9916-4b3e-b5c3-3a645623d525	ATLANTIC SURF III	02030	1176	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	60	49.60	3020	34aeab48-9c9b-4c06-8a45-3469f866cf88	GLACIAR PESQUERA  S.A.	Mar del Plata	4800274	492-2216	\N	amalfitanoycia@hotmail.com	\N	\N	Agencia Maritima Almafitano	t	\N	\N	\N
7a5c52c3-f87e-4405-a08e-f3b2ae274460	ATREVIDO	0145	1180	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	32.50	901	34aeab48-9c9b-4c06-8a45-3469f866cf88	PESQUERA VERAZ  S.A.	Mar del Plata	4800005	489-4624 / 489-0314 (astillero)	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
08da59fb-fa52-49da-b7ec-6e276d53b841	AURORA	02581	1183	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	67.55	1776	11c64a29-e693-4bef-b734-8162f86cbbcc	KALEU KALEU  S.A.	Ciudad Autónoma de Buenos Aires		011-3220-2130  / 5093-1215	\N		\N	\N		t	\N	\N	\N
639bb7e1-7b76-4fbe-aeb5-58e4b0726d2e	BAHIA DESVELOS	0665	1194	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	37.05	791	11c64a29-e693-4bef-b734-8162f86cbbcc	PESQUERA SANTA CRUZ  S.A.	Ciudad Autónoma de Buenos Aires		011-4305-4706	\N		\N	\N		t	\N	\N	\N
47c70ae2-4523-4db5-b475-41c8469eabdc	BEAGLE I	6052	1207	bbebd1ff-edd5-48dd-925c-9735bb61b50d	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	60	59.90	2369	11c64a29-e693-4bef-b734-8162f86cbbcc	YUKEN  S.A.	Ciudad Autónoma de Buenos Aires	4891553-154179360-154179860-154179062	011-5279-1302 / 5236-6069	\N	agenciasmiriglio@speedy.com.ar	\N	\N	Agencia Maritima Smiriglio	t	\N	\N	\N
8229e32a-4aa8-4aaf-bad4-799c00c9f968	BELVEDERE	01398	1210	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	26.50	624	34aeab48-9c9b-4c06-8a45-3469f866cf88	PRINMAR  S.A. Buque Motor Belvedere	Mar del Plata		480-0883	\N		\N	\N		t	\N	\N	\N
1362f018-3a09-4fca-a2fe-bdf2b160e79a	BOGAVANTE SEGUNDO	02994	2743	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	37.45	867	105b0349-a9ed-49bf-9336-aad8d3867f0b	IBERCONSA  DE ARGENTINA  S.A.	Puerto Madryn		0280-445-4324	\N		\N	\N		t	\N	\N	\N
718a77d2-3a1a-4d20-9096-eba352617f86	BONFIGLIO	01234	\N	04d57c5c-390c-4334-bba9-d4635e1cb0c0	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	10	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	COSTA BRAVA  S.A.	Mar del Plata		489-7538	\N		\N	\N		t	\N	\N	\N
baec3aa4-13af-4331-823a-f97b94a04deb	BORRASCA	01095	1218	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	39.16	1083	34aeab48-9c9b-4c06-8a45-3469f866cf88	LUIS SOLIMENO e HIJOS  S.A.	Mar del Plata		489-3030	\N		\N	\N		t	\N	\N	\N
e5248c3a-7a81-49fa-a6a2-466a1cdc60df	BOUCIÑA	01637	1221	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	0.00	0	34aeab48-9c9b-4c06-8a45-3469f866cf88	CALME  S.A.	Mar del Plata	4800005	480-3545	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
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
0ddb5663-8ab9-4ad5-ab76-fb98b2e5d15d	CAPESANTE	02929	2723	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	40	50.15	2550	34aeab48-9c9b-4c06-8a45-3469f866cf88	GLACIAR PESQUERA  S.A.	Mar del Plata		492-2216	\N		\N	\N		t	\N	\N	\N
f22e38f3-53ae-443b-aaeb-42c7e7962bd1	CAPITAN CANEPA	059F	\N	1e6f3be0-9af3-40cf-8306-e1358231f214	\N	\N	28	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	INIDEP	Mar del Plata		451-7442 ó 486-2586 int 162	\N		\N	\N		t	\N	\N	\N
22511ee6-0e7f-4efa-9eb9-738365c224e0	CAPITAN GIACHINO	0151	1260	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	38.42	1062	34aeab48-9c9b-4c06-8a45-3469f866cf88	KALARI S.A.	Mar del Plata		489-1959	\N		\N	\N		t	\N	\N	\N
e7789831-81f7-4e16-bef3-fbdf0f6f1bc0	CAPITAN OCA BALDA	060F	\N	1e6f3be0-9af3-40cf-8306-e1358231f214	\N	\N	21	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	INIDEP	Mar del Plata		451-7442 ó 486-2586 int 162	\N		\N	\N		t	\N	\N	\N
a7a8af60-4087-4af9-a56d-4d78984dbcb0	CARMEN A	02045	1269	04d57c5c-390c-4334-bba9-d4635e1cb0c0	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	4	15.30	223	bea22adf-383f-4cc0-8c0b-bd514132fb77	FLOTA AMARILLA RAWSON	Rawson			\N		\N	\N		t	\N	\N	\N
1552d8ac-53ec-4246-a410-f2c7bf19e516	CAROLINA P	0176	1272	bbebd1ff-edd5-48dd-925c-9735bb61b50d	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	60	71.60	1976	105b0349-a9ed-49bf-9336-aad8d3867f0b	ESTRELLA PATAGONICA S.A.	Puerto Madryn		0280-445-4407	\N		\N	\N		t	\N	\N	\N
783483ec-abbe-497c-b71b-5fd04ec3bee0	CEIBE DOUS	0336	1276	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	40.70	738	105b0349-a9ed-49bf-9336-aad8d3867f0b	IBERCONSA  DE ARGENTINA  S.A.	Puerto Madryn	4800274	0280-445-4324	\N	amalfitanoycia@hotmail.com	\N	\N	Agencia Maritima Almafitano	t	\N	\N	\N
1f6cbb5f-d134-4ee3-9315-bf24ae2a7946	CENTAURO 2000	0482	1278	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	35.50	1302	34aeab48-9c9b-4c06-8a45-3469f866cf88	PESQUERA VERAZ  S.A.	Mar del Plata		489-4624 / 489-0314 (astillero)	\N		\N	\N		t	\N	\N	\N
8e64df56-3b39-4321-8c31-98bff1ad28b3	CENTURION DEL ATLANTICO	0237	1280	bbebd1ff-edd5-48dd-925c-9735bb61b50d	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	60	112.80	8111	11c64a29-e693-4bef-b734-8162f86cbbcc	ESTREMAR  S.A.	Ciudad Autónoma de Buenos Aires		011-6533-7853 / 4345-1102	\N		\N	\N		t	\N	\N	\N
b88d3a8d-a83a-4a6b-a566-85bf97fb3fb7	CERES	01420	1281	bbebd1ff-edd5-48dd-925c-9735bb61b50d	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	60	60.74	1969	34aeab48-9c9b-4c06-8a45-3469f866cf88	PESQUERA CERES  S.A.	Mar del Plata		410-0051 / 7	\N		\N	\N		t	\N	\N	\N
363330e3-6ebe-44dd-a02f-3c83e2a733d1	CHANG BO GO I	06190	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	ARPEPA  M.C.I.S.A.	Ciudad Autónoma de Buenos Aires		011-4382-1605	\N		\N	\N		t	\N	\N	\N
788ac2e2-ee37-4ed9-907d-c6fcb20890be	CHATKA I	02893	0	04d57c5c-390c-4334-bba9-d4635e1cb0c0	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	16.73	195	105b0349-a9ed-49bf-9336-aad8d3867f0b	FOOD PARTNERS PATAGONIA S.A.	Puerto Madryn		0280-4458579 / 5225	\N		\N	\N		t	\N	\N	\N
6058618d-4253-4e70-934c-249efc0279c1	CHIARPESCA 56	01090	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	APOLO FISH  S.A.	Mar del Plata		489-4519 / 489-1133	\N		\N	\N		t	\N	\N	\N
4bb7ccc5-7326-48f1-a5fb-7bae226cb6df	CHIARPESCA 57	01029	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	CHIARPESCA  S.A.	Mar del Plata		489-1385	\N		\N	\N		t	\N	\N	\N
8ecc80ba-1dab-47a5-8b90-863bd1c60263	CHIARPESCA 902	02110	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	CHIARPESCA  S.A.	Mar del Plata		489-1385	\N		\N	\N		t	\N	\N	\N
56fc94f1-667a-499e-a358-47309d2355e4	CHIARPESCA 903	02109	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	CHIARPESCA  S.A.	Mar del Plata		489-1385	\N		\N	\N		t	\N	\N	\N
7d23c84f-115a-4318-9e29-aa24a4809280	CHIYO MARU Nº 3	02987	2745	bbebd1ff-edd5-48dd-925c-9735bb61b50d	1f5e5c39-7fd2-4fb1-8697-d5e0e9a4022b	\N	30	52.80	937	11c64a29-e693-4bef-b734-8162f86cbbcc	CRUSTACEOS DEL SUR  S.A.	Ciudad Autónoma de Buenos Aires		011-5218-4287	\N		\N	\N		t	\N	\N	\N
53da9d5e-3f42-40e4-8cfc-7c6ed3d2868c	CHOCO MARU 68	JA13	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	PESQUERA COMERCIAL  S.A.	Mar del Plata		489-3030	\N		\N	\N		t	\N	\N	\N
44f0a423-727c-4f76-99da-8dfa56aa3551	CHOKYU MARU Nº 18.	2584	1312	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	68.70	1777	11c64a29-e693-4bef-b734-8162f86cbbcc	BAHIA GRANDE  S.A.	Ciudad Autónoma de Buenos Aires		011-5272-0850 / 5254-1133	\N		\N	\N		t	\N	\N	\N
307fe712-ba5c-4ad3-a709-8bdde1a3b458	CINCOMAR 1	0439	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	CINCOMAR  S.A.	Ciudad Autónoma de Buenos Aires		011-4326-4991	\N		\N	\N		t	\N	\N	\N
01520e11-717f-4197-b851-f24d9fcdf9aa	CINCOMAR 5	02351	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	CINCOMAR  S.A.	Ciudad Autónoma de Buenos Aires		011-4326-4991	\N		\N	\N		t	\N	\N	\N
4feed10c-be1d-4f75-b736-875456bc8d05	CIUDAD DE HUELVA	01519	1324	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	27.45	426	105b0349-a9ed-49bf-9336-aad8d3867f0b	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
4accfb3f-bca2-4335-a38b-d37f383a7ca2	CIUDAD FELIZ	0910	2721	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	28.56	458	34aeab48-9c9b-4c06-8a45-3469f866cf88	CARAVON S.A.	Mar del Plata		489-9404	\N		\N	\N		t	\N	\N	\N
2e162db8-e039-4401-a816-52ba4d9588f3	CLAUDIA	02183	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	LUXMARINO  S.A.	Ciudad Autónoma de Buenos Aires		011-4342-2621	\N		\N	\N		t	\N	\N	\N
f0c98258-3f72-4b3d-8685-db05bc6d847f	CLAUDINA	02345	1331	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	53.58	937	11c64a29-e693-4bef-b734-8162f86cbbcc	ARMADORA  ACRUX  S.A.	Ciudad Autónoma de Buenos Aires		011-4312-6470	\N		\N	\N		t	\N	\N	\N
c82bf74e-e7d0-45f9-a472-82d0127b3694	COALSA SEGUNDO	0790	1333	bbebd1ff-edd5-48dd-925c-9735bb61b50d	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	60	76.20	2960	11c64a29-e693-4bef-b734-8162f86cbbcc	YUKEN  S.A.	Ciudad Autónoma de Buenos Aires		011-5279-1302 / 5236-6069	\N		\N	\N		t	\N	\N	\N
c8a262d2-bbd0-4620-af04-9ec6709a5a64	CODEPECA  I	0497	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	\N	\N	105b0349-a9ed-49bf-9336-aad8d3867f0b	HARENGUS  S.A.	Puerto Madryn		0280-445-0822	\N		\N	\N		t	\N	\N	\N
a8f3b87a-d0df-4ac5-a9fe-d2e87eb691d9	CODEPECA  II	0498	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	\N	\N	105b0349-a9ed-49bf-9336-aad8d3867f0b	HARENGUS  S.A.	Puerto Madryn		0280-445-0822	\N		\N	\N		t	\N	\N	\N
e5550fb9-7d59-47d6-83d8-7658ff088523	CODEPECA  III	0506	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	\N	\N	105b0349-a9ed-49bf-9336-aad8d3867f0b	HARENGUS  S.A.	Puerto Madryn		0280-445-0822	\N		\N	\N		t	\N	\N	\N
f60954c7-2f50-4c26-9230-e5a5c47cf1b3	CODEPECA IV	01012	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	\N	\N	105b0349-a9ed-49bf-9336-aad8d3867f0b	PEREIRA  ARGENTINA  S.A.	Puerto Madryn		0280-445-7377 / 447-2249	\N		\N	\N		t	\N	\N	\N
c1102f81-4ae9-4743-9df6-57b197b7f705	COMANDANTE LUIS PIEDRABUENA	0767	1340	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	25.00	501	34aeab48-9c9b-4c06-8a45-3469f866cf88	COMANDANTE PIEDRABUENA  S.R.L.	Mar del Plata		489-9404	\N		\N	\N		t	\N	\N	\N
d35cb7f9-f2b8-4160-9a8e-476c8b6e1f1f	COMETA	0919	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	VICARP  S.A.	Mar del Plata		480-4378	\N		\N	\N		t	\N	\N	\N
d2bf4dea-5b8a-4158-943f-7422b5d19562	CONARA I	0201	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	\N	\N	105b0349-a9ed-49bf-9336-aad8d3867f0b	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
66098466-a6dd-4982-8347-335fe023e588	CONARPESA I	0200	1344	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	52.50	1482	105b0349-a9ed-49bf-9336-aad8d3867f0b	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
f276f930-15e3-4acd-be59-0c58471745d9	CORAJE	0645	1359	991d17ee-9376-401c-8883-c0409127d0af	\N	\N	0	28.28	426	34aeab48-9c9b-4c06-8a45-3469f866cf88	IBERCONSA  DE ARGENTINA  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
076b009b-8450-4e7e-b7a8-8095b2699572	CORAL  AZUL	06127	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	NOVAMAR  S.A.	Ciudad Autónoma de Buenos Aires		011-4345-6688	\N		\N	\N		t	\N	\N	\N
1daf8877-72ec-4fd8-9753-b728782261da	CORAL BLANCO	06137	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	NOVAMAR  S.A.	Ciudad Autónoma de Buenos Aires		011-4345-6688	\N		\N	\N		t	\N	\N	\N
d5f99cf0-5de6-4445-9d64-5d0e11a127ab	CORMORAN	01611	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	ANTONIO BARILLARI  S.A.	Mar del Plata		481-1173  / 489-0872	\N		\N	\N		t	\N	\N	\N
b10ac37d-e0f8-4d98-b3ff-492ede84f7b4	COSTAMAR	01549	\N	04d57c5c-390c-4334-bba9-d4635e1cb0c0	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	4	\N	\N	bea22adf-383f-4cc0-8c0b-bd514132fb77	INDUSTRIA  PESQUERA  PATAGONICA  S.A.	Trelew		0280-444-6577	\N		\N	\N		t	\N	\N	\N
a08ad5a1-988e-4782-a843-99d87389522a	CRISTO REDENTOR	01185	1374	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	31.00	642	f41ff939-bc00-4bbd-8ce8-c451922ba284	PESQUERA DESEADO  S.A.	Puerto Deseado		0297-487-0884 / 0327 / 2407	\N		\N	\N		t	\N	\N	\N
e8f508b9-2966-40a9-854e-d24a0b91533a	DASA 508	0499	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	PESQUERA  DONGAH  ARGENTINA  S.A.	Ciudad Autónoma de Buenos Aires		011-4815-5525	\N		\N	\N		t	\N	\N	\N
e38079ba-a943-4489-b795-2393d2d82d42	DASA 757	02200	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	PESQUERA  DONGAH  ARGENTINA  S.A.	Ciudad Autónoma de Buenos Aires		011-4815-5525	\N		\N	\N		t	\N	\N	\N
d0100242-f25c-4ae1-9ab1-c4cc9220a0d3	DEMOSTENES	0113	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	AGUA MARINA  S.A.	Ciudad Autónoma de Buenos Aires		011-4342-0605 / 5656 / 1709	\N		\N	\N		t	\N	\N	\N
dd7184b3-9ccd-4515-a117-02184abda5ff	DESTINY	3209	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	\N	\N	\N	WANCHESE ARGENTINA  S.A.				\N		\N	\N		t	\N	\N	\N
6c2d041f-c99b-494b-a78f-2ef3ffcf80e1	DEPASUR  I	0330	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	105b0349-a9ed-49bf-9336-aad8d3867f0b	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
45a35f87-38a5-4b3f-9bb0-5e148467217a	DEPEMAS 51	0239	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	DEPEMAS  S.A.	Ciudad Autónoma de Buenos Aires		011-4372-7909  /  4382-5382	\N		\N	\N		t	\N	\N	\N
d6e59f74-5c64-40cc-a52e-8e3d458c621b	DEPEMAS 81	0281	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	PESQUERA ORION  S.A.	Ciudad Autónoma de Buenos Aires		011-4343-9327	\N		\N	\N		t	\N	\N	\N
b7878859-bcba-4bc9-bb14-bbf441557755	DESAFIO	0177	1398	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	29.56	850	34aeab48-9c9b-4c06-8a45-3469f866cf88	PESQUERA VERAZ  S.A.	Mar del Plata		489-4624 / 489-0314 (astillero)	\N		\N	\N		t	\N	\N	\N
5d4e5fc5-cf2a-4ab5-96d1-63326350d730	DESEADO	01598	1400	04d57c5c-390c-4334-bba9-d4635e1cb0c0	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	4	19.00	301	bea22adf-383f-4cc0-8c0b-bd514132fb77	FLOTA AMARILLA RAWSON	Rawson			\N		\N	\N		t	\N	\N	\N
27331717-f9bd-4c5c-ab0a-6be7cd40993d	DIEGO PRIMERO	01725	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	PESQUERA DIEGO PRIMERO  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
7520156b-6cda-40e7-a4c4-69d870022e74	DON JUAN ALVAREZ	3300	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	\N	\N	\N	\N	CONARPESA  S.A.				\N		\N	\N		t	\N	\N	\N
f6503904-0323-4a3c-9d20-8cf8890d0845	DON  NATALIO	01183	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	14 DE JULIO  S.A.	Mar del Plata		480-3545	\N		\N	\N		t	\N	\N	\N
d2674585-33ae-4905-a22d-42bc8fb6e76e	DON AGUSTIN	0968	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	PESQUERA  MARGARITA  S.A.	Mar del Plata		489-4645   /   489-2946	\N		\N	\N		t	\N	\N	\N
2fabb2fc-b0d2-4fe2-8a36-2030d476b63e	DON ANTONIO	0029	1411	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	27.80	549	34aeab48-9c9b-4c06-8a45-3469f866cf88	GIORNO  S.A.	Mar del Plata		410-0051 / 0057	\N		\N	\N		t	\N	\N	\N
2c81f698-d737-45d3-abf7-d70c5f994499	DON CARMELO	01320	1416	04d57c5c-390c-4334-bba9-d4635e1cb0c0	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	8	19.04	424	34aeab48-9c9b-4c06-8a45-3469f866cf88	MARFE  S.A.	Mar del Plata	4800005	480-0102	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
9043effb-7dea-4502-b49c-0a61d3a31957	DON CAYETANO	0579	1417	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	47.10	1503	34aeab48-9c9b-4c06-8a45-3469f866cf88	PEDRO MOSCUZZA e HIJOS  S.A.	Mar del Plata	4890960	489-7287	\N	agencia@maritimavidal.com.ar	\N	\N	Agencia Maritima Vidal	t	\N	\N	\N
633b6aaa-910d-4c43-8de8-643592fc7f26	DON FRANCISCO I	2562	1428	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	66.55	1776	34aeab48-9c9b-4c06-8a45-3469f866cf88	EL MARISCO  S.A.	Mar del Plata	480-7779 - HERNAN	489-0384	\N	agenciasenoransmdp@yahoo.com	\N	\N	Agencia Maritima SEÑORANS	t	\N	\N	\N
887ff179-0c25-4956-9165-09125f9152f0	DON GAETANO	071	1430	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	32.10	889	34aeab48-9c9b-4c06-8a45-3469f866cf88	LINEAERRE  S.A.	Mar del Plata		480-0312	\N		\N	\N		t	\N	\N	\N
ada0292c-c3cc-4dd6-94bb-98fd98c52928	DON GIULIANO	02025	1431	04d57c5c-390c-4334-bba9-d4635e1cb0c0	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	4	17.10	220	bea22adf-383f-4cc0-8c0b-bd514132fb77	FLOTA AMARILLA RAWSON	Rawson			\N		\N	\N		t	\N	\N	\N
38459045-c273-4711-a592-7e0c8d9bae23	DON JOSE	00892	1434	04d57c5c-390c-4334-bba9-d4635e1cb0c0	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	8	16.49	269	34aeab48-9c9b-4c06-8a45-3469f866cf88	VENTO DI TERRA  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
590c2f26-2a9b-4589-ab55-3b8c356c88c5	DON JOSE DI BONA	02241	1435	04d57c5c-390c-4334-bba9-d4635e1cb0c0	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	4	19.85	301	bea22adf-383f-4cc0-8c0b-bd514132fb77	PROA  AL SUR  S.R.L.	Rawson			\N		\N	\N		t	\N	\N	\N
e3aa489c-84b8-4324-aa08-0f19f35238ed	DON JUAN	01397	1437	04d57c5c-390c-4334-bba9-d4635e1cb0c0	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	27.00	425	\N	PESQUERA DON JUAN  S.A.				\N		\N	\N		t	\N	\N	\N
2821573e-103d-4bbb-926d-ec4f5e71b5a3	DON JUAN D´AMBRA	5174	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	PESCA ANGELA  S.A.	Mar del Plata		626-2236 /37	\N		\N	\N		t	\N	\N	\N
6e004ad2-fc82-4b26-aa81-7a0132ea0159	DON LUCIANO	069	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	TATURIELLO  S.A.	Mar del Plata		489-3833	\N		\N	\N		t	\N	\N	\N
12964f37-2ef3-4932-9d34-b7ec4410c90b	DON LUIS I	02093	1445	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	67.95	1803	34aeab48-9c9b-4c06-8a45-3469f866cf88	PESQUERA CERES  S.A.	Mar del Plata		410-0051 / 7	\N		\N	\N		t	\N	\N	\N
46c27bad-1d14-4b95-990b-d4ec9dad6c78	DON MIGUEL 1°	0748	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	PESQUERA EL NAZARENO	Mar del Plata	4895032 Emanuel	489-9414 (of. Pers. Emb.)	\N	operacionesconsultoramaritima@gmail.com	\N	\N	Consultora Maritima Merlini	t	\N	\N	\N
a7e98086-55d6-49bb-80e8-a75acec98e92	DON NICOLA	0893	1450	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	28.14	856	34aeab48-9c9b-4c06-8a45-3469f866cf88	PEZ ESPADA  S.A.	Mar del Plata		480-0846	\N		\N	\N		t	\N	\N	\N
638e86fa-0885-4363-8ab1-6e7a773dbbdf	DON OSCAR	02184	\N	04d57c5c-390c-4334-bba9-d4635e1cb0c0	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	4	\N	\N	bea22adf-383f-4cc0-8c0b-bd514132fb77	FLOTA AMARILLA RAWSON	Rawson	4800005		\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
a12653df-c0ca-4814-8442-78636dfa6d94	DON PEDRO	068	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	60	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	PEDRO MOSCUZZA e HIJOS  S.A.	Mar del Plata		489-7287	\N		\N	\N		t	\N	\N	\N
23b49a79-006b-4fbb-9555-4aca5585029f	DON RAIMUNDO	01431	1463	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	10	25.60	624	34aeab48-9c9b-4c06-8a45-3469f866cf88	DON RAIMUNDO S.R.L.	Mar del Plata		489-3780	\N		\N	\N		t	\N	\N	\N
0c1d3746-1b32-4d1e-a979-6d69fe31a28e	DON ROMEO ERSINI	0972	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	PESQUERA  MARGARITA  S.A.	Mar del Plata	4891553-154179360-154179860-154179062	489-4645   /   489-2946	\N	agenciasmiriglio@speedy.com.ar	\N	\N	Agencia Smiriglio	t	\N	\N	\N
8b82f567-6be0-4696-b40d-a587b3ed4e22	DON SANTIAGO	01733	1467	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	10	26.55	776	34aeab48-9c9b-4c06-8a45-3469f866cf88	SAN JORGE S.A.	Mar del Plata		480-6611	\N		\N	\N		t	\N	\N	\N
6cca8e88-74a5-41a5-a160-f90db30eb2df	DON TOMASSO	02310	1468	04d57c5c-390c-4334-bba9-d4635e1cb0c0	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	4	17.00	356	bea22adf-383f-4cc0-8c0b-bd514132fb77	FLOTA AMARILLA RAWSON	Rawson			\N		\N	\N		t	\N	\N	\N
575aa9ae-0910-48fb-9576-dee870b0e50b	DON TURI	01540	1470	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	28.62	839	34aeab48-9c9b-4c06-8a45-3469f866cf88	DON TURI  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
9e80ad53-de6a-45ff-8bc4-5d92cac44639	DON VICENTE VUOSO	0539	1474	04d57c5c-390c-4334-bba9-d4635e1cb0c0	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	20.69	537	34aeab48-9c9b-4c06-8a45-3469f866cf88	VUOSO HNOS. S.R.L.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
3a35e0d6-53a6-4ee1-9e9f-aa5223fe1d3f	DOÑA ALFIA	0512	1483	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	20.70	426	34aeab48-9c9b-4c06-8a45-3469f866cf88	ANTONIO BARILLARI  S.A.	Mar del Plata		481-1173  / 489-0872	\N		\N	\N		t	\N	\N	\N
4da8857e-915b-4cd9-96d6-4148a78d664c	Dr. EDUARDO L. HOLMBERG	061F	\N	1e6f3be0-9af3-40cf-8306-e1358231f214	\N	\N	24	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	INIDEP	Mar del Plata		451-7442 ó 486-2586 int 162	\N		\N	\N		t	\N	\N	\N
e70330eb-bcaf-472c-9906-1096de4235dd	DUKAT	02775	2712	bbebd1ff-edd5-48dd-925c-9735bb61b50d	1f5e5c39-7fd2-4fb1-8697-d5e0e9a4022b	\N	30	50.80	1302	11c64a29-e693-4bef-b734-8162f86cbbcc	CRUSTACEOS DEL SUR  S.A.	Ciudad Autónoma de Buenos Aires		011-5218-4287	\N		\N	\N		t	\N	\N	\N
69ff7a7d-9417-4f5c-9693-8e2835fef39b	ECHIZEN MARU	0326	1495	bbebd1ff-edd5-48dd-925c-9735bb61b50d	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	60	89.59	4702	b8a55941-9f65-4e90-bea1-3683753d42b5	PESANTAR  S.A. ( Empresa Pesq de la Patagonia y Antartida )	Ushuaia		02901-43-3449 / 43-0008 / 43-0708	\N		\N	\N		t	\N	\N	\N
755be1df-61f5-430f-bb86-0fc017601ca8	EL MALO I	02350	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	4	\N	\N	bea22adf-383f-4cc0-8c0b-bd514132fb77	NOGALES NOGALES  S. De HECHO	Rawson	4890960		\N	agencia@maritimavidal.com.ar	\N	\N	Agencia Maritima Vidal	t	\N	\N	\N
f6fa9b93-7a4e-4bec-b34b-3882cbfc8121	EL MARISCO I	0912	1516	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	27.22	426	34aeab48-9c9b-4c06-8a45-3469f866cf88	EL MARISCO  S.A.	Mar del Plata	4890960	489-0384	\N	agencia@maritimavidal.com.ar	\N	\N	Agencia Maritima Vidal	t	\N	\N	\N
cf8cfd8b-6f05-4ea9-af17-0426de2c550f	EL MARISCO II	0915	1517	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	56.30	1407	34aeab48-9c9b-4c06-8a45-3469f866cf88	EL MARISCO  S.A.	Mar del Plata		489-0384	\N		\N	\N		t	\N	\N	\N
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
5fa98bd7-f095-4d3e-8e98-7761568ec108	ERIN BRUCE II	TEMP-0002	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	\N	\N	\N	\N					\N		\N	\N		t	\N	\N	\N
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
37fb0bff-71cf-474c-ac99-dfe32eb068d3	FEDERICO C	3190	2776	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	\N	37.68	1400	\N	PESQUERA VERAZ  S.A.				\N		\N	\N		t	\N	\N	\N
abfe526f-bf85-4dc2-89c7-557bfa93dbc3	FEIXA	0529	1592	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	41.50	1101	34aeab48-9c9b-4c06-8a45-3469f866cf88	ANTONIO BARILLARI  S.A.	Mar del Plata		481-1173  / 489-0872	\N		\N	\N		t	\N	\N	\N
2285c55a-7ab8-469f-b7af-ff1a594e9624	FELIX AUGUSTO	0581	1595	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	27.80	601	105b0349-a9ed-49bf-9336-aad8d3867f0b	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
55b9680b-a422-457c-b103-efc7f46c952e	FERNANDO ALVAREZ	0013	1597	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	36.60	1168	105b0349-a9ed-49bf-9336-aad8d3867f0b	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
66e7abfd-d9ab-478b-8300-e9be65838297	FLORIDABLANCA	0969	1606	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	27.67	541	34aeab48-9c9b-4c06-8a45-3469f866cf88	DESAFIO  S.A.	Mar del Plata		489-4788 / 3659	\N		\N	\N		t	\N	\N	\N
549d9f8c-46cd-49fe-8138-a2014681b239	FLORIDABLANCA II	0252	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	\N	\N	105b0349-a9ed-49bf-9336-aad8d3867f0b	PESQUERA SAN ISIDRO S.A.	Puerto Madryn		0280-447-2697	\N		\N	\N		t	\N	\N	\N
b0646571-a745-4278-bf46-84a4feac5359	FLORIDABLANCA IV	0255	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	\N	\N	5b1bcc08-58a5-499b-b2cc-d02d0df392fa	MARITIMA MONACHESI  S.A.	Bahia Blanca		0291-452-5913	\N		\N	\N		t	\N	\N	\N
3a28ba59-de98-4803-90b1-3e765708b934	FONSECA	0920	1610	bbebd1ff-edd5-48dd-925c-9735bb61b50d	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	60	62.40	2003	34aeab48-9c9b-4c06-8a45-3469f866cf88	FONSECA  S.A.	Mar del Plata	4891553-154179360-154179860-154179062	489-4645	\N	agenciasmiriglio@speedy.com.ar	\N	\N	Agencia Maritima Smiriglio	t	\N	\N	\N
03df67d1-d008-4b42-90fb-36c611ea16de	FRANCA	0495	1612	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	27.29	493	34aeab48-9c9b-4c06-8a45-3469f866cf88	AUGUSTA MEGARA  S.A.	Mar del Plata		480-2260	\N		\N	\N		t	\N	\N	\N
eebc3d53-9595-43b6-9c09-b24c1202fd35	FRANCO	01458	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	FRIGORIFICO DON LUIS  S.R.L.	Mar del Plata		489-4645	\N		\N	\N		t	\N	\N	\N
aeef4aee-ac05-4178-9428-e09ff58cc65f	FU YUAN YU 636	02195	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	BAHIA GRANDE  S.A.	Ciudad Autónoma de Buenos Aires		011-5272-0850 / 5254-1133	\N		\N	\N		t	\N	\N	\N
738dcc04-d768-49d2-8663-ce69b6057d02	FUEGUINO I	0331	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	105b0349-a9ed-49bf-9336-aad8d3867f0b	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
aff5335c-01e5-4bf3-937d-0a769eea266b	GALA	02722	0	04d57c5c-390c-4334-bba9-d4635e1cb0c0	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	15	15.20	256	34aeab48-9c9b-4c06-8a45-3469f866cf88	DISTRIBUIDORA MARECHIARE S.R.L.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
c21dba67-5adc-4cd4-a353-68366c2f194b	GALEMAR	0904	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	ANTONIO BARILLARI  S.A.	Mar del Plata		481-1173  / 489-0872	\N		\N	\N		t	\N	\N	\N
791abbde-36b2-45ab-ad29-164c37c7c1dd	GAUCHO GRANDE	0339	1642	991d17ee-9376-401c-8883-c0409127d0af	\N	\N	30	27.64	0	34aeab48-9c9b-4c06-8a45-3469f866cf88	VICARP  S.A.	Mar del Plata	4890960	480-4378	\N	agencia@maritimavidal.com.ar	\N	\N	Agencia Maritima Vidal	t	\N	\N	\N
face2a5f-184c-41f8-b3a8-9beebc3635ee	GEMINIS	01421	1643	bbebd1ff-edd5-48dd-925c-9735bb61b50d	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	60	68.90	2141	34aeab48-9c9b-4c06-8a45-3469f866cf88	PESQUERA GEMINIS  S.A.	Mar del Plata		410-0051 / 7	\N		\N	\N		t	\N	\N	\N
7567c718-ded8-46a7-a023-00847d0d8e04	GIANFRANCO	01075	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	PIEA  S.A.	Mar del Plata		489-6317 /489-1367	\N		\N	\N		t	\N	\N	\N
7dbf4dcf-f689-44f9-9f6b-a94d771ad4aa	GIULIANA	02633	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	PESQUERA  MARGARITA  S.A.	Mar del Plata		489-4645   /   489-2946	\N		\N	\N		t	\N	\N	\N
f676b225-78ca-4d2c-b668-faa7e7e3192c	GLORIA DEL MAR I	01983	1651	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	54.30	1600	34aeab48-9c9b-4c06-8a45-3469f866cf88	PESQUERA  DEL  ESTE  S.A.	Mar del Plata	4800005	489-1567	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
353f1ebe-dcef-4570-b76c-9794f634c3cf	GRACIELA	0578	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	PEDRO MOSCUZZA e HIJOS  S.A.	Mar del Plata		489-7287	\N		\N	\N		t	\N	\N	\N
a1b563e1-607a-4532-8d14-0ecc7ee1fe20	GRACIELA I	3994	2765	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	39.94	0	34aeab48-9c9b-4c06-8a45-3469f866cf88	PEDRO MOSCUZZA e HIJOS  S.A.	Mar del Plata		489-7287	\N		\N	\N		t	\N	\N	\N
142b2a4b-c2b3-49bd-8a33-4a4f1dded656	GRAN CAPITAN	01538	1656	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	25.43	541	34aeab48-9c9b-4c06-8a45-3469f866cf88	ORTIGIA  S.A.	Mar del Plata		489-2679	\N		\N	\N		t	\N	\N	\N
7218342b-2da4-4deb-925c-45d9d0e8c63c	GURISES	01386	1667	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	25.20	546	34aeab48-9c9b-4c06-8a45-3469f866cf88	A.B.H. PESQUERA  S.A.	Mar del Plata		489-6522	\N		\N	\N		t	\N	\N	\N
2dda3abd-f7a0-4c52-8006-6427dea0484d	GUSTAVO R	0075	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	60	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	ARGEMER  S.A.	Mar del Plata		451-1247	\N		\N	\N		t	\N	\N	\N
722ea305-dfd7-48b0-81f1-a4f90a28a1aa	HAMAZEN MARU N° 68	JA05	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	PESQUERA SANTA CRUZ  S.A.	Ciudad Autónoma de Buenos Aires		011-4305-4706	\N		\N	\N		t	\N	\N	\N
a1ac7e18-57ed-4184-9f72-a1018b3b40fe	HAMPON	01410	1673	04d57c5c-390c-4334-bba9-d4635e1cb0c0	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	10	18.99	497	34aeab48-9c9b-4c06-8a45-3469f866cf88	PESQUERA HAMPON S.R.L	Mar del Plata			\N		\N	\N		t	\N	\N	\N
8b2c914b-3d05-42b8-bcba-19acb5e8e174	HARENGUS	0510	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	60	\N	\N	105b0349-a9ed-49bf-9336-aad8d3867f0b	HARENGUS  S.A.	Puerto Madryn		0280-445-0822	\N		\N	\N		t	\N	\N	\N
bb3e36c2-f9f8-4bef-b47f-08a67ec51fa0	HOKO 31	05934	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	FARO DEL SUR TRADING  S.A.	Ciudad Autónoma de Buenos Aires		011-4555-4956	\N		\N	\N		t	\N	\N	\N
eaf01ef3-c6c7-4232-9cc2-df09320b6a99	HOPE N°7	06130	1690	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	50.60	1235	11c64a29-e693-4bef-b734-8162f86cbbcc	ALUNAMAR  S.A.	Ciudad Autónoma de Buenos Aires	4808331/4808332	011-4382-4194	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
546c200e-da22-4c78-8c7d-cbdeab4535cd	HOYO MARU 37	JA01	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	f41ff939-bc00-4bbd-8ce8-c451922ba284	ARGENOVA  S.A.	Puerto Deseado		0297- 487-0550  (447-2818  Com. Riv )	\N		\N	\N		t	\N	\N	\N
d93be244-efd7-40b4-bf2b-795ab164bc4e	HSIANG LAI FU	80	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	EL MARISCO  S.A.	Mar del Plata		489-0384	\N		\N	\N		t	\N	\N	\N
28367073-f657-41aa-9604-7adfa455458c	HUYU 961	TEMP-0003	0	bbebd1ff-edd5-48dd-925c-9735bb61b50d	\N	\N	\N	65.70	0	\N					\N		\N	\N		t	\N	\N	\N
ba0b91e3-29d6-4028-acb8-c8256fa2aaf8	HUYU 962	03056	0	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	65.60	0	105b0349-a9ed-49bf-9336-aad8d3867f0b	ALTAMARE  S.A.	Puerto Madryn		0280-445-7377 / 447-2249	\N		\N	\N		t	\N	\N	\N
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
4a69d7f5-53b8-4ebf-820b-27f67de26c7c	INARI MARU N° 25	0261	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	f41ff939-bc00-4bbd-8ce8-c451922ba284	ARGENOVA  S.A.	Puerto Deseado		0297- 487-0550  (447-2818  Com. Riv )	\N		\N	\N		t	\N	\N	\N
08478cc8-a374-46f4-b5e0-b64b5c46ed66	INFINITUS PEZ	01472	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	GIORNO  S.A.	Mar del Plata		410-0051 / 0057	\N		\N	\N		t	\N	\N	\N
fb79753f-ddda-44ba-abe2-b9f22ac9e7d6	INITIO PEZ	01471	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	GIORNO  S.A.	Mar del Plata	4800005	410-0051 / 0057	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi	t	\N	\N	\N
71ac58df-bb35-4d50-902c-4b8805d03488	ITXAS LUR	0927	1735	bbebd1ff-edd5-48dd-925c-9735bb61b50d	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	60	63.30	1952	34aeab48-9c9b-4c06-8a45-3469f866cf88	HISPANO PATAGONICA  S.A.	Mar del Plata		480-1002 / 489-3165 / 489-7144	\N		\N	\N		t	\N	\N	\N
578e85e3-dab1-4ce9-bb14-6f7c798a7317	JOLUMA	5403	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	ARDAPEZ  S.A.	Mar del Plata	4800005	480-1561 / 480-1568 / 480-1549	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
bf9011e3-436b-477e-adc9-5fdf755c9b63	JOSÉ AMÉRICO	03071	2756	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	44.21	0	34aeab48-9c9b-4c06-8a45-3469f866cf88	PEDRO MOSCUZZA e HIJOS  S.A.	Mar del Plata		489-7287	\N		\N	\N		t	\N	\N	\N
2649a320-9061-4e6d-b907-f7ad1554a472	JOSE LUIS ALVAREZ	0618	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	\N	\N	105b0349-a9ed-49bf-9336-aad8d3867f0b	PESQUERA SAN ISIDRO S.A.	Puerto Madryn		0280-447-2697	\N		\N	\N		t	\N	\N	\N
73c502e2-397a-499f-b4f7-cb8dce8260b7	JOSE MARCELO	3138	2764	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	39.94	0	34aeab48-9c9b-4c06-8a45-3469f866cf88	PEDRO MOSCUZZA e HIJOS  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
38aa57ab-e25e-4387-bd8c-b750f65d010f	JUAN ALVAREZ	0619	1755	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	36.60	1168	105b0349-a9ed-49bf-9336-aad8d3867f0b	PESQUERA SAN ISIDRO S.A.	Puerto Madryn		0280-447-2697	\N		\N	\N		t	\N	\N	\N
467ba951-bd03-4854-aac6-3c0727b71a91	JUAN PABLO II	02695	0	04d57c5c-390c-4334-bba9-d4635e1cb0c0	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	8	22.49	326	\N	ISLA DE LOS ESTADOS  S.A.	Vivoratá			\N		\N	\N		t	\N	\N	\N
3ed8104e-d850-4b37-9ac4-581cca785a3f	JUDITH I	0908	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	ANTONIO BARILLARI  S.A.	Mar del Plata		481-1173  / 489-0872	\N		\N	\N		t	\N	\N	\N
8fab37fc-023e-4fbc-9fa2-2f47f395bc8d	JUEVES SANTO	0667	1762	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	39.50	1244	11c64a29-e693-4bef-b734-8162f86cbbcc	NUVCONSA  S.A.	Ciudad Autónoma de Buenos Aires	4891553-154179360-154179860-154179062	011-4305-4706	\N	agenciasmiriglio@speedy.com.ar	\N	\N	Agencia Maritima Smiriglio	t	\N	\N	\N
21732f76-cac4-4ed8-a4dd-c8a06c1668fb	JUPITER II	0406	1769	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	27.90	791	34aeab48-9c9b-4c06-8a45-3469f866cf88	VENUS  PESQUERA S.R.L.	Mar del Plata	4800005	489-0186	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
b6a3bebe-8dea-45a7-aa1f-73e6c6eb0e42	KALEU KALEU	01963	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	KALEU KALEU  S.A.	Ciudad Autónoma de Buenos Aires	4800005	011-3220-2130  / 5093-1215	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi	t	\N	\N	\N
35b2b309-b992-49a4-844d-9702d0a691a0	KANTXOPE	01065	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	ANTONIO BARILLARI  S.A.	Mar del Plata		481-1173  / 489-0872	\N		\N	\N		t	\N	\N	\N
2eda1624-a1d2-4233-a309-4504ae7d80f3	KARINA	01462	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	FRIGORIFICO DON LUIS  S.R.L.	Mar del Plata		489-4645	\N		\N	\N		t	\N	\N	\N
f8b21dcd-1675-44e5-9f9c-9538907bb0cd	LAIA	06521	0	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	53.00	1185	11c64a29-e693-4bef-b734-8162f86cbbcc	PESQUERA MADRYN  S.A.	Ciudad Autónoma de Buenos Aires		011-4394-1452	\N		\N	\N		t	\N	\N	\N
e87e38bf-8166-4eb6-a23e-04e12cd0ad9a	LANZA SECA	01181	1852	991d17ee-9376-401c-8883-c0409127d0af	\N	\N	0	24.80	514	34aeab48-9c9b-4c06-8a45-3469f866cf88	LANZAMAR  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
3cff8010-86cf-4235-be60-81dfbdf9203a	LATINA  N° 8	0291	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	f41ff939-bc00-4bbd-8ce8-c451922ba284	ARGENOVA  S.A.	Puerto Deseado		0297- 487-0550  (447-2818  Com. Riv )	\N		\N	\N		t	\N	\N	\N
6a14192b-b497-4393-a925-fcd619418ec3	LEAL	0143	1863	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	27.45	601	34aeab48-9c9b-4c06-8a45-3469f866cf88	PESQUERA LEAL  S.A.	Mar del Plata		489-4624 / 489-0314 (astillero )	\N		\N	\N		t	\N	\N	\N
a229783a-b570-4e6c-baff-994cbb7cf094	LEKHAN I	00752	1865	04d57c5c-390c-4334-bba9-d4635e1cb0c0	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	8	18.45	530	34aeab48-9c9b-4c06-8a45-3469f866cf88	LEKHAN I  S.R.L.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
e12f5b2a-dd64-4c98-b5b0-e2de886a5a85	LETARE	0245	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	LUIS SOLIMENO e HIJOS  S.A.	Mar del Plata		489-3030	\N		\N	\N		t	\N	\N	\N
24c98bdd-72cb-4bd5-914a-6945e668aa49	LIBERTAD DEL MAR 1°	02186	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	TATURIELLO  S.A.	Mar del Plata		489-3833	\N		\N	\N		t	\N	\N	\N
8f782df7-ec37-426a-ada4-a2e213b9e762	LING SHUI N° 3	02210	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	MUELLE OCHO  S.A.	Ciudad Autónoma de Buenos Aires		011-4381-1337	\N		\N	\N		t	\N	\N	\N
7ee207e1-80f7-4b2a-8c21-8a79be3d17b5	LING SHUI N° 5	02211	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	MUELLE OCHO  S.A.	Ciudad Autónoma de Buenos Aires		011-4381-1337	\N		\N	\N		t	\N	\N	\N
854c142e-a45b-4022-9411-52c786baa572	LUIGI	3244	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	LUIS SOLIMENO e HIJOS  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
9feec5a5-4b57-4bd9-98ed-770ea7509a63	LUCA MARIO	0546	2715	bbebd1ff-edd5-48dd-925c-9735bb61b50d	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	60	79.14	3952	34aeab48-9c9b-4c06-8a45-3469f866cf88	PESCASOL  S.A.	Mar del Plata	4800274	480-9608 / 481-0464	\N	amalfitanoycia@hotmail.com	\N	\N	Agencia Maritima Almafitano	t	\N	\N	\N
ac67da65-198f-43a9-b853-eea2da891505	LUCA SANTINO	3121	0	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	26.31	0	\N	CENTOMAR  S.A.				\N		\N	\N		t	\N	\N	\N
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
747dd411-950e-4d05-9c64-7b10f5950133	MAR MARÍA	02960	2738	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	37.80	1248	11c64a29-e693-4bef-b734-8162f86cbbcc	PESQUERA SANTA CRUZ  S.A.	Ciudad Autónoma de Buenos Aires		011-4305-4706	\N		\N	\N		t	\N	\N	\N
0078e584-dd7b-46b8-8edf-c2ac303cf972	MAR NOVIA 1	0115	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	CINCOMAR  S.A.	Ciudad Autónoma de Buenos Aires		011-4326-4991	\N		\N	\N		t	\N	\N	\N
0d29cf61-4ee5-4369-ba7c-24ac3c0b0948	MAR NOVIA 2	0116	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	MIREMAR  S.A.	Ciudad Autónoma de Buenos Aires		011-4328-4963 / 4	\N		\N	\N		t	\N	\N	\N
c1fb290e-10a9-4cef-9075-929f585122f3	MAR SUR	0341	1957	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	36.40	889	11c64a29-e693-4bef-b734-8162f86cbbcc	PESCARGEN  S.A.	Ciudad Autónoma de Buenos Aires		011-5219-0065 ó 5276-9499	\N		\N	\N		t	\N	\N	\N
25cf13fb-87dc-4506-9150-eafd87561fa5	MARA I	0210	1960	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	35.31	1209	105b0349-a9ed-49bf-9336-aad8d3867f0b	PESCAPUERTA ARGENTINA  S.A.	Puerto Madryn		0280-445-4407	\N		\N	\N		t	\N	\N	\N
bc2916d9-5611-4ebe-9641-ad738eeb200c	MARA II	0209	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	\N	\N	105b0349-a9ed-49bf-9336-aad8d3867f0b	PESCAPUERTA ARGENTINA  S.A.	Puerto Madryn		0280-445-4407	\N		\N	\N		t	\N	\N	\N
b0d844de-b7f8-4f53-afbb-afd29f92db6a	MARBELLA	01073	1966	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	27.38	736	34aeab48-9c9b-4c06-8a45-3469f866cf88	MAR DE MESSINA  S.A.	Mar del Plata	beagle1	489-3824	\N		\N	\N		t	\N	\N	\N
9ec2716e-af9c-4cc4-8abe-cef1737fbb3e	MARCALA I	0532	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	PESANFLOR  S.A.	Mar del Plata		489-6522	\N		\N	\N		t	\N	\N	\N
a0da1df8-98b2-457d-ab9c-3eb0ed30616b	MARCALA IV	0351	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	MARCALA  S.A.	Ciudad Autónoma de Buenos Aires		011-4342-9601 / 4283	\N		\N	\N		t	\N	\N	\N
b2129247-34b9-4f84-932e-9e11a088ffbe	MAREJADA	01107	1974	991d17ee-9376-401c-8883-c0409127d0af	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	27.98	624	34aeab48-9c9b-4c06-8a45-3469f866cf88	VICARP  S.A.	Mar del Plata		480-4378	\N		\N	\N		t	\N	\N	\N
2ea49417-f407-4cad-8214-3f84ef261e65	MARGOT	0360	1976	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	58.75	1481	34aeab48-9c9b-4c06-8a45-3469f866cf88	GIORNO  S.A.	Mar del Plata	4800005	410-0051 / 0057	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
04ecd152-99b1-4e4a-8394-616032314ee9	MARIA  EUGENIA	01173	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	PEDRO MOSCUZZA e HIJOS  S.A.	Mar del Plata		489-7287	\N		\N	\N		t	\N	\N	\N
e0b5953e-9992-4daa-b981-44d5ab0f3352	HUAFENG 816	05994	0	04d57c5c-390c-4334-bba9-d4635e1cb0c0	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	4	22.60	521	34aeab48-9c9b-4c06-8a45-3469f866cf88	COSTA BRAVA  S.A.	Mar del Plata	4800005	489-7538	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
82f27fe1-cf7a-437f-87fc-7be940af0176	MARIA  LILIANA	01174	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	60	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	PEDRO MOSCUZZA e HIJOS  S.A.	Mar del Plata	4893758	489-7287	\N	miguel-visoso@hotmail.com	\N	\N	Agencia Maritima Solvox	t	\N	\N	\N
f2a36f97-d363-47d5-9a9d-52cc812a09eb	MARIA RITA	0436	2000	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	30.95	541	34aeab48-9c9b-4c06-8a45-3469f866cf88	BAL - FISH  S.A.	Mar del Plata		489-6522	\N		\N	\N		t	\N	\N	\N
87fc1c47-b658-4994-beae-d69e1eedead4	MARIA ALEJANDRA 1º	03074	2750	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	39.20	0	34aeab48-9c9b-4c06-8a45-3469f866cf88	XEITOSIÑO S.A.	Mar del Plata		410-0051 / 7	\N		\N	\N		t	\N	\N	\N
753193ce-0aa1-4a8b-911c-d1bc9548195c	MARIA DEL VALLE	02126	1986	04d57c5c-390c-4334-bba9-d4635e1cb0c0	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	4	16.29	196	bea22adf-383f-4cc0-8c0b-bd514132fb77	FARO CHUBUT  S.R.L.	Rawson		0280-449-6311	\N		\N	\N		t	\N	\N	\N
f3248362-ab06-49bf-95da-8a472ebe8f67	MARIA GLORIA	02738	2763	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	28.05	851	34aeab48-9c9b-4c06-8a45-3469f866cf88	CAYO LARGO  S.A.	Mar del Plata		480-4378	\N		\N	\N		t	\N	\N	\N
b1fedb55-7446-4027-aa7c-1a5dcfcb4ba5	MARIANELA	01002	2007	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	25.60	541	34aeab48-9c9b-4c06-8a45-3469f866cf88	AGLIANO  SRL	Mar del Plata		480-2886	\N		\N	\N		t	\N	\N	\N
edd0b459-9fdd-4da5-9cf1-422188daa525	MARTA S	01001	0	04d57c5c-390c-4334-bba9-d4635e1cb0c0	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	8	23.90	503	34aeab48-9c9b-4c06-8a45-3469f866cf88	WERZOWA  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
e091039b-a9b6-41d3-b440-de5c82087f12	MATACO II	02243	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	60	\N	\N	105b0349-a9ed-49bf-9336-aad8d3867f0b	HAMALTAL  S.A.	Puerto Madryn	4800005	0280-445-0822	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
3e0c8867-184b-437a-a2b6-482cf522af0a	MATEO I	02172	2028	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	67.97	1776	11c64a29-e693-4bef-b734-8162f86cbbcc	KALEU KALEU  S.A.	Ciudad Autónoma de Buenos Aires		011-3220-2130  / 5093-1215	\N		\N	\N		t	\N	\N	\N
11843bbd-14ce-4e56-85c8-f72cc6d6ac6e	MELLINO I	0379	2032	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	47.25	1185	34aeab48-9c9b-4c06-8a45-3469f866cf88	GIORNO  S.A.	Mar del Plata		410-0051 / 0057	\N		\N	\N		t	\N	\N	\N
a3a665f8-8586-48fd-a35a-0f55eb05247a	MELLINO II	01424	0	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	38.91	795	34aeab48-9c9b-4c06-8a45-3469f866cf88	GIORNO  S.A.	Mar del Plata	AVENIDA DE LOS PESCADORES 195	410-0051 / 0057	\N		\N	\N	Agencia AMALFITANO	t	\N	\N	\N
d7cc59c9-d446-4271-b0cf-9df6242b41fd	MELLINO VI	0378	2034	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	64.87	1235	34aeab48-9c9b-4c06-8a45-3469f866cf88	GIORNO  S.A.	Mar del Plata		410-0051 / 0057	\N		\N	\N		t	\N	\N	\N
d4745593-c290-49d4-a2ff-bf4cbe864b28	MERCEA C	0318	2036	991d17ee-9376-401c-8883-c0409127d0af	\N	\N	0	29.15	866	34aeab48-9c9b-4c06-8a45-3469f866cf88	ALLELOCCIC  S.A.	Mar del Plata		495-4467 / 480-8565	\N		\N	\N		t	\N	\N	\N
73bb4866-5b6c-453e-8dcc-2306b96e26d0	MESSINA I	01089	2038	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	27.29	650	34aeab48-9c9b-4c06-8a45-3469f866cf88	MAR DE MESSINA  S.A.	Mar del Plata		489-3824	\N		\N	\N		t	\N	\N	\N
68a1aaa8-4011-4920-8865-d05c62f145d1	MEVIMAR	01508A	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	\N	\N	105b0349-a9ed-49bf-9336-aad8d3867f0b	RIMINIMARR  S.A.	Puerto Madryn		0280-445-2248	\N		\N	\N		t	\N	\N	\N
382e10eb-865b-4147-9366-5d76d841fb75	MIERCOLES SANTO	0666	2041	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	38.50	1244	11c64a29-e693-4bef-b734-8162f86cbbcc	NUVCONSA  S.A.	Ciudad Autónoma de Buenos Aires		011-4305-4706	\N		\N	\N		t	\N	\N	\N
49ea472e-409e-4547-83fb-3199e5ee8db1	MILLENNIUM	0466	2046	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	55.05	1329	11c64a29-e693-4bef-b734-8162f86cbbcc	PESQUERA CRUZ DEL SUR  S.A.	Ciudad Autónoma de Buenos Aires		011-4784-1760	\N		\N	\N		t	\N	\N	\N
0cebcd19-614f-4e7a-9c89-8f8ec1eeadf2	MINCHOS OCTAVO	03022	2744	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	39.30	579	105b0349-a9ed-49bf-9336-aad8d3867f0b	IBERCONSA  DE ARGENTINA  S.A.	Puerto Madryn		0280-445-4324	\N		\N	\N		t	\N	\N	\N
844026fe-c6be-4b40-b4f4-4758a4437c2d	NINA	3171	2770	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	44.00	1620	\N	PEDRO MOSCUZZA e HIJOS  S.A.				\N		\N	\N		t	\N	\N	\N
82d93396-176a-4d74-a5de-5addaf47520f	MINTA	02196	2050	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	65.10	1603	11c64a29-e693-4bef-b734-8162f86cbbcc	LIYA  S.A.	Ciudad Autónoma de Buenos Aires		011-4964-2227	\N		\N	\N		t	\N	\N	\N
2c33dae2-6632-468a-abdd-2c35e16fa478	MIRIAM	0370	2051	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	36.35	1446	11c64a29-e693-4bef-b734-8162f86cbbcc	VIEIRA ARGENTINA  S.A.	Ciudad Autónoma de Buenos Aires	4800005		\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi	t	\N	\N	\N
b2ed178e-eb23-49ed-8c17-5e6b422cb186	MISHIMA MARU N°8	02175	2054	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	63.43	1579	34aeab48-9c9b-4c06-8a45-3469f866cf88	BAL - FISH  S.A.	Mar del Plata	4800274	489-6522	\N	amalfitanoycia@hotmail.com	\N	\N	Agencia Maritima Almafitano	t	\N	\N	\N
c5d2228b-36be-4674-8c03-14f817316ca7	MISS PATAGONIA	0555	2055	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	28.20	667	34aeab48-9c9b-4c06-8a45-3469f866cf88	PESQUERA VERAZ  S.A.	Mar del Plata	4805743	489-4624 / 489-0314 (astillero)	\N	agenciadiyorio@hotmail.com -joseph@hotmail.com	\N	\N	Agencia Di Yorio	t	\N	\N	\N
4a837a56-b513-4568-b2d7-61bc1d66d22b	MISS TIDE	02439	2056	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	52.52	2254	34aeab48-9c9b-4c06-8a45-3469f866cf88	WANCHESE ARGENTINA  S.A.	Mar del Plata		489-1236	\N		\N	\N		t	\N	\N	\N
49087f92-c34f-4ac7-9312-baf546c7fb07	MISTER BIG	0534	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	WANCHESE ARGENTINA  S.A.	Mar del Plata		489-1236	\N		\N	\N		t	\N	\N	\N
113c933d-0413-4909-998e-45614ee4ba7e	MIURA MARU	05996	2058	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	53.20	1482	11c64a29-e693-4bef-b734-8162f86cbbcc	LIYA  S.A.	Ciudad Autónoma de Buenos Aires		011-4964-2227	\N		\N	\N		t	\N	\N	\N
bd400468-dd52-4817-95dd-b124bdb272f7	MONTE DE VIOS	0664	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	PESQUERA SANTA CRUZ  S.A.	Ciudad Autónoma de Buenos Aires		011-4305-4706	\N		\N	\N		t	\N	\N	\N
5aea6ce4-ca56-4bb7-83dc-071dd9161524	MYRDOMA F	02771	2735	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	38.55	1430	105b0349-a9ed-49bf-9336-aad8d3867f0b	LANZAR S.A.	Puerto Madryn	4800005	0280-445-6280	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
e7ed7f8b-9e82-48db-94f1-c9c63d3391eb	NANINA	02576	2073	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	72.08	1678	34aeab48-9c9b-4c06-8a45-3469f866cf88	PEDRO MOSCUZZA e HIJOS  S.A.	Mar del Plata	4800005	489-7287	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi Hugo Omar	t	\N	\N	\N
c7c5892b-d6ee-4b44-b3a6-24dc9ded90aa	NATALIA	02066	2075	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	68.45	1779	34aeab48-9c9b-4c06-8a45-3469f866cf88	PEDRO MOSCUZZA e HIJOS  S.A.	Mar del Plata		489-7287	\N		\N	\N		t	\N	\N	\N
f66cbd4a-6e7c-4e91-a8e8-4c5e5542dae1	NAVEGANTES	0542	2079	bbebd1ff-edd5-48dd-925c-9735bb61b50d	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	60	58.00	1925	34aeab48-9c9b-4c06-8a45-3469f866cf88	PESQUERA COMERCIAL  S.A.	Mar del Plata		489-3030	\N		\N	\N		t	\N	\N	\N
a568597e-e77e-453b-a7cc-f7bee580616e	NAVEGANTES II	01451	2080	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	63.70	1603	34aeab48-9c9b-4c06-8a45-3469f866cf88	PESQUERA COMERCIAL  S.A.	Mar del Plata		489-3030	\N		\N	\N		t	\N	\N	\N
83a5f4d8-12bb-48e4-8b31-6fda9cd9eb5f	NAVEGANTES III	02065	2081	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	68.60	2203	34aeab48-9c9b-4c06-8a45-3469f866cf88	PESQUERA COMERCIAL  S.A.	Mar del Plata	4800274	489-3030	\N	amalfitanoycia@hotmail.com	\N	\N	Agencia Maritima Almafitano	t	\N	\N	\N
27337aa3-35fa-4d2b-9696-98255bbf2493	NDDANDDU	0141	2082	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	28.20	856	34aeab48-9c9b-4c06-8a45-3469f866cf88	PESQUERA VERAZ  S.A.	Mar del Plata		489-4624 / 489-0314 (astillero)	\N		\N	\N		t	\N	\N	\N
9b255813-442b-40a9-b3e7-a49072133133	NEPTUNIA I	02125	\N	04d57c5c-390c-4334-bba9-d4635e1cb0c0	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	4	\N	\N	bea22adf-383f-4cc0-8c0b-bd514132fb77	FLOTA AMARILLA RAWSON	Rawson	4891553-154179360-154179860-154179062		\N	agenciasmiriglio@speedy.com.ar	\N	\N	Agencia Maritima SMIRIGLIO	t	\N	\N	\N
af23e539-baa2-4cdd-9c30-b3126af01ce0	NIÑO JESUS DE PRAGA	3194	2775	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	27.74	1180	34aeab48-9c9b-4c06-8a45-3469f866cf88	RITORNO SALLUSTIO Y CICCIOTTI  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
b422b4ce-70c9-4b52-aa4f-15ccf351575a	NONO PASCUAL	02854	2729	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	10	24.00	451	34aeab48-9c9b-4c06-8a45-3469f866cf88	CANAL DE BEAGLE  S.R.L.	Mar del Plata		480-4447 / 5004265 PASCUAL	\N		\N	\N		t	\N	\N	\N
064f64a5-44ec-4050-8174-c63df9c72250	NUEVA LUCIA MADRE	01501	2113	a1373c68-08c7-4c4c-b9a5-b23ccf0abdcc	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	8	14.37	416	34aeab48-9c9b-4c06-8a45-3469f866cf88	NUEVA LUCIA MADRE  S.R.L.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
667810ff-6a43-437d-943a-fda2d7e0a32f	NUEVA NEPTUNIA I	02634	0	04d57c5c-390c-4334-bba9-d4635e1cb0c0	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	4	20.00	403	bea22adf-383f-4cc0-8c0b-bd514132fb77	ORION S.R.L.	Rawson			\N		\N	\N		t	\N	\N	\N
fbf252c4-77e3-44c8-893e-55c0bf2e28b5	NUEVO ANITA	02100	2128	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	30.90	765	105b0349-a9ed-49bf-9336-aad8d3867f0b	IBERCONSA  DE ARGENTINA  S.A.	Puerto Madryn		0280-445-4324	\N		\N	\N		t	\N	\N	\N
52ec724f-b8e2-45c7-98c5-e28a44dc63f3	NUEVO VIENTO	01449	2135	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	22.23	541	34aeab48-9c9b-4c06-8a45-3469f866cf88	NUEVO VIENTO  SRL	Mar del Plata		480-8565	\N		\N	\N		t	\N	\N	\N
4950e2cb-c0cb-48c7-a016-46bae464d4f0	OMEGA 3	01391	\N	04d57c5c-390c-4334-bba9-d4635e1cb0c0	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	10	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	COSTA BRAVA  S.A.	Mar del Plata		489-7538	\N		\N	\N		t	\N	\N	\N
e41a745e-ad41-4a17-85f2-811fc596a249	ORION  2	01492	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	PESQUERA SANTA CRUZ  S.A.	Ciudad Autónoma de Buenos Aires		011-4305-4706	\N		\N	\N	norberto.lopez@iberconsa.com	t	\N	\N	\N
27cc2237-493e-4d8d-9138-30a13c472f90	ORION 5	02637	2757	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	65.62	1776	11c64a29-e693-4bef-b734-8162f86cbbcc	PESQUERA SANTA CRUZ  S.A.	Ciudad Autónoma de Buenos Aires		011-4305-4706	\N		\N	\N		t	\N	\N	\N
8215a9ae-ebb4-4954-afec-630ec6244731	ORION I	01943A	0	04d57c5c-390c-4334-bba9-d4635e1cb0c0	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	20.90	520	11c64a29-e693-4bef-b734-8162f86cbbcc	PESQUERA CRUZ DEL SUR  S.A.	Ciudad Autónoma de Buenos Aires		011-4784-1760	\N		\N	\N		t	\N	\N	\N
f0d0cff4-7236-4b1a-a9b8-f5f3ffe54af9	ORION 1	01943	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	PESQUERA SANTA CRUZ  S.A.	Ciudad Autónoma de Buenos Aires		011-4305-4706	\N		\N	\N		t	\N	\N	\N
d78c10f2-ab4b-4c03-9e5e-75f68bb6b2ce	ORION 3	02167	2170	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	63.10	1776	11c64a29-e693-4bef-b734-8162f86cbbcc	PESQUERA SANTA CRUZ  S.A.	Ciudad Autónoma de Buenos Aires		011-4305-4706	\N		\N	\N		t	\N	\N	\N
f7ff96b3-746f-4a6f-9175-2d2cf8e30368	ORYONG  756	02092	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	105b0349-a9ed-49bf-9336-aad8d3867f0b	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
a886c32f-4bd8-4790-9638-1a0b86a26712	PACHACA	02572	2180	04d57c5c-390c-4334-bba9-d4635e1cb0c0	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	4	17.64	320	bea22adf-383f-4cc0-8c0b-bd514132fb77	FLOTA AMARILLA RAWSON	Rawson			\N		\N	\N		t	\N	\N	\N
ab0be5b8-6db2-44da-89e6-07ce671f3382	PADRE PIO	02822	2737	04d57c5c-390c-4334-bba9-d4635e1cb0c0	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	24.00	451	34aeab48-9c9b-4c06-8a45-3469f866cf88	RITORNO SALLUSTIO Y CICCIOTTI  S.A.	Mar del Plata		480-5508	\N		\N	\N		t	\N	\N	\N
e45932f8-f9c7-4111-a897-516028a4172d	PAGRUS II	01393	\N	04d57c5c-390c-4334-bba9-d4635e1cb0c0	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	4	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	COSTA BRAVA  S.A.	Mar del Plata		489-7538	\N		\N	\N		t	\N	\N	\N
24426440-6674-4867-981b-44bb1389da7d	PAKU	0250	2186	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	39.16	1087	34aeab48-9c9b-4c06-8a45-3469f866cf88	LUIS SOLIMENO e HIJOS  S.A.	Mar del Plata		489-3030	\N		\N	\N		t	\N	\N	\N
c720b08b-6e20-469e-b1df-ad18511028d1	PALOMA V	64	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	3b9fe535-63a2-4982-b7d4-71229ab250dc	\N	60	\N	\N	\N					\N		\N	\N		t	\N	\N	\N
8faaea19-772e-4c92-b384-2e316179c3f3	PAOLA  S	0557	\N	991d17ee-9376-401c-8883-c0409127d0af	\N	\N	30	\N	\N	\N					\N		\N	\N		t	\N	\N	\N
67335a25-9bc6-4b53-a09a-43b6aac3e6ba	PASA  82	0338	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	105b0349-a9ed-49bf-9336-aad8d3867f0b	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
ed85a95e-7cd5-44fd-8f4e-2f33017bd8b1	PATAGONIA	0284	2196	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	30.95	660	34aeab48-9c9b-4c06-8a45-3469f866cf88	LUIS SOLIMENO e HIJOS  S.A.	Mar del Plata		489-3030	\N		\N	\N		t	\N	\N	\N
674051b2-f81d-4369-a039-fe6771c25e3d	PATAGONIA 1	02163	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	PATAGONIA  FISHING  S.A.	Ciudad Autónoma de Buenos Aires		011-4932-2777	\N		\N	\N		t	\N	\N	\N
50b3cfd9-5d94-4626-9ee3-6eb49c74f8df	PATAGONIA 2	02164	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	PATAGONIA  FISHING  S.A.	Ciudad Autónoma de Buenos Aires		011-4932-2777	\N		\N	\N		t	\N	\N	\N
f696cd30-1a04-48d6-b3a2-0813169ef71b	PATAGONIA BLUES	02176	2199	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	64.45	1776	11c64a29-e693-4bef-b734-8162f86cbbcc	PESQUERA CRUZ DEL SUR  S.A.	Ciudad Autónoma de Buenos Aires		011-4784-1760	\N		\N	\N		t	\N	\N	\N
32e93528-46a4-40d8-8576-89d228fa5dda	PEDRITO	TEMP-0005	0	991d17ee-9376-401c-8883-c0409127d0af	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	\N	39.92	1201	\N					\N		\N	\N		t	\N	\N	\N
846e2d5c-f17a-4862-ae80-910157d4cdb5	PELAGOS	83	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	105b0349-a9ed-49bf-9336-aad8d3867f0b	PESQUERA SAN ISIDRO S.A.	Puerto Madryn		0280-447-2697	\N		\N	\N		t	\N	\N	\N
c8592fbd-f499-4881-873f-307b5bd00df8	PENSACOLA I	0747	2207	991d17ee-9376-401c-8883-c0409127d0af	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	25.20	380	5f58a58c-0cbb-4d6f-b987-f60d562a279c	FRANGELA  S.A.	Comodoro Rivadavia			\N		\N	\N		t	\N	\N	\N
b044b4ca-8e7a-4bf1-a053-873b7fd2e130	PESCAPUERTA CUARTO	0171	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	60	\N	\N	105b0349-a9ed-49bf-9336-aad8d3867f0b	PESCAPUERTA ARGENTINA  S.A.	Puerto Madryn		0280-445-4407	\N		\N	\N		t	\N	\N	\N
d4d9d60e-8b41-4030-961a-13b72d66deaf	PESCAPUERTA QUINTO	0538	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	60	\N	\N	105b0349-a9ed-49bf-9336-aad8d3867f0b	PESCAPUERTA ARGENTINA  S.A.	Puerto Madryn		0280-445-4407	\N		\N	\N		t	\N	\N	\N
8e4949a7-bacf-4cda-96e9-3d39392f152f	PESCARGEN  V	078	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	60	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	PESCARGEN  S.A.	Ciudad Autónoma de Buenos Aires		011-5219-0065 ó 5276-9499	\N		\N	\N		t	\N	\N	\N
59563532-cad8-48ec-96f6-684de72e78a6	PESCARGEN III	021	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	60	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	PESCARGEN  S.A.	Ciudad Autónoma de Buenos Aires		011-5219-0065 ó 5276-9499	\N		\N	\N		t	\N	\N	\N
9711d47c-8da4-412d-9310-a34876679a3c	PESCARGEN IV	0150	2217	bbebd1ff-edd5-48dd-925c-9735bb61b50d	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	60	63.20	1603	11c64a29-e693-4bef-b734-8162f86cbbcc	PESCARGEN  S.A.	Ciudad Autónoma de Buenos Aires		011-5219-0065 ó 5276-9499	\N		\N	\N		t	\N	\N	\N
3144ab32-e078-4b48-9f32-52846853a9fe	PESPASA  II	0212	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	\N	\N	f41ff939-bc00-4bbd-8ce8-c451922ba284	PESPASA  S.A.	Puerto Deseado		0297-487-2030  int 12	\N		\N	\N		t	\N	\N	\N
e929f655-7f4c-4bb0-91e4-79726eebc616	PESPASA I	0211	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	\N	\N	f41ff939-bc00-4bbd-8ce8-c451922ba284	PESPASA  S.A.	Puerto Deseado		0297-487-2030  int 12	\N		\N	\N		t	\N	\N	\N
925d47d0-e997-46fc-8b4f-30c3c9c8b4ac	PETREL	01445	2224	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	29.85	776	34aeab48-9c9b-4c06-8a45-3469f866cf88	OLAMAR  S.A.	Mar del Plata		480-3573	\N		\N	\N		t	\N	\N	\N
849509b7-39c6-47e0-88cb-c8d108d036ad	PEVEGASA QUINTO	02312	2225	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	38.65	740	11c64a29-e693-4bef-b734-8162f86cbbcc	PUNTA BUSTAMANTE  S.A.	Ciudad Autónoma de Buenos Aires		011-4305-4710 / 4712	\N		\N	\N		t	\N	\N	\N
50a5014a-b7c0-432c-a620-a5f096fabe15	PIONEROS	02735	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	CALME  S.A.	Mar del Plata		480-3545	\N		\N	\N		t	\N	\N	\N
bc30d59b-dbfe-481b-b43d-2502573cbdb0	POLARBORG I	02122	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	GRINFIN  S.A.	Ciudad Autónoma de Buenos Aires		011-4343-5626	\N		\N	\N		t	\N	\N	\N
52386e5a-b83c-4a2f-a0bd-356376f8de2a	POLARBORG II	02117	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	GRINFIN  S.A.	Ciudad Autónoma de Buenos Aires	4800005	011-4343-5626	\N	agenciasimonazzi@hotmail.com	\N	\N	Agencia Simonazzi	t	\N	\N	\N
e157b89c-77da-4efc-936a-642f986b9147	PONTE CORUXO	0975	2242	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	52.85	1383	34aeab48-9c9b-4c06-8a45-3469f866cf88	BAL - FISH  S.A.	Mar del Plata		489-6522	\N		\N	\N		t	\N	\N	\N
542c0a22-02f9-4816-ba4c-be8655ccbedc	PONTE DE RANDE	0244	2243	bbebd1ff-edd5-48dd-925c-9735bb61b50d	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	60	79.14	2964	34aeab48-9c9b-4c06-8a45-3469f866cf88	COSTA MARINA  S.A.	Mar del Plata		480-9608 / 481-0464	\N		\N	\N		t	\N	\N	\N
472a56b8-017a-4315-8ca9-4dce9e563d65	PORTO BELO I	02699	2736	04d57c5c-390c-4334-bba9-d4635e1cb0c0	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	8	23.98	600	34aeab48-9c9b-4c06-8a45-3469f866cf88	FARO RECALADA  S.A	Mar del Plata		480-2442	\N		\N	\N		t	\N	\N	\N
d3b94e96-f2a9-423c-b5f1-1d35cb5522f2	PORTO BELO II	02790	2728	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	10	23.98	601	34aeab48-9c9b-4c06-8a45-3469f866cf88	MARITIMA PORTO BELO  S.A.	Mar del Plata		489-1553	\N		\N	\N		t	\N	\N	\N
728cb01c-9ba3-4d4e-baf1-4c14f3b40e35	PRINCIPE AZUL	TEMP-0006	\N	04d57c5c-390c-4334-bba9-d4635e1cb0c0	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	10	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88		Mar del Plata			\N		\N	\N		t	\N	\N	\N
afe2a164-9b83-49b3-832a-91372f5ff648	PROMAC	4815	2257	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	33.45	721	34aeab48-9c9b-4c06-8a45-3469f866cf88	LUIS SOLIMENO e HIJOS  S.A.	Mar del Plata		489-3030	\N		\N	\N		t	\N	\N	\N
41c637b4-58ab-408d-8d66-99fb98f1cd48	PROMARSA I	072	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	\N	\N	105b0349-a9ed-49bf-9336-aad8d3867f0b	ALPESCA  S.A.	Puerto Madryn		0280-447-4958 / 45-1069	\N		\N	\N		t	\N	\N	\N
4bd14408-6581-4067-97dd-7f9a8a09a6fb	PROMARSA II	073	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	\N	\N	105b0349-a9ed-49bf-9336-aad8d3867f0b	ALPESCA  S.A.	Puerto Madryn		0280-447-4958 / 45-1069	\N		\N	\N		t	\N	\N	\N
01a61000-af30-42f8-b164-cefa8372eaaf	PROMARSA III	02096	0	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	35.84	1062	105b0349-a9ed-49bf-9336-aad8d3867f0b	ALPESCA  S.A.	Puerto Madryn		0280-447-4958 / 45-1069	\N		\N	\N		t	\N	\N	\N
21c0f3cb-e6e8-43bc-929b-99c24f15bf83	PUENTE VALDES	02205	2266	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	58.15	1383	105b0349-a9ed-49bf-9336-aad8d3867f0b	PEREIRA  ARGENTINA  S.A.	Puerto Madryn		0280-445-7377 / 447-2249	\N		\N	\N		t	\N	\N	\N
f773f7e8-075c-4899-a2e1-141d10e5e08b	PUENTE AMERICA	0164	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	\N	\N	105b0349-a9ed-49bf-9336-aad8d3867f0b	PEREIRA  ARGENTINA  S.A.	Puerto Madryn		0280-445-7377 / 447-2249	\N		\N	\N		t	\N	\N	\N
7bb107ac-e355-4336-a5dc-2e4b38eb2502	PUENTE CHICO	0756	2263	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	37.00	1175	105b0349-a9ed-49bf-9336-aad8d3867f0b	PEREIRA  ARGENTINA  S.A.	Puerto Madryn		0280-445-7377 / 447-2249	\N		\N	\N		t	\N	\N	\N
ee4ff734-9a8b-4c09-86f2-b11c61925109	PUENTE MAYOR	02630	2703	bbebd1ff-edd5-48dd-925c-9735bb61b50d	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	60	66.86	2416	105b0349-a9ed-49bf-9336-aad8d3867f0b	PEREIRA  ARGENTINA  S.A.	Puerto Madryn		0280-445-7377 / 447-2249	\N		\N	\N		t	\N	\N	\N
cf5b3906-dbe3-46c2-aa50-e10756b4ffae	PUENTE SAN JORGE	0207	2265	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	35.30	1001	105b0349-a9ed-49bf-9336-aad8d3867f0b	PEREIRA  ARGENTINA  S.A.	Puerto Madryn		0280-445-7377 / 447-2249	\N		\N	\N		t	\N	\N	\N
97182de0-ac10-4044-a633-41569ba3fd66	PUERTO WILLIAMS	3178	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	60	\N	\N	b8a55941-9f65-4e90-bea1-3683753d42b5	DERIS  S.A.	Punta Arenas -  Chile		+613 6224-8744	\N		\N	\N		t	\N	\N	\N
91fa52d5-cd1f-4bc1-9a0d-3bebfc7742a9	PUNTA BALLENA	65	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	3b9fe535-63a2-4982-b7d4-71229ab250dc	\N	60	\N	\N	\N					\N		\N	\N		t	\N	\N	\N
7a01f717-05f2-4d87-b3e4-ee8592238fdc	QUEQUEN SALADO	0580	2277	04d57c5c-390c-4334-bba9-d4635e1cb0c0	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	4	19.45	271	bea22adf-383f-4cc0-8c0b-bd514132fb77	PISCAL  S.A.	Rawson			\N		\N	\N		t	\N	\N	\N
366e3631-c4fe-4001-960d-c816b3a08a1c	RAFFAELA	01401	2280	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	26.50	624	34aeab48-9c9b-4c06-8a45-3469f866cf88	PESQUERA RAFFAELA  S.A.	Mar del Plata		489-56574 int 203	\N		\N	\N		t	\N	\N	\N
690bb690-71e8-4099-a740-ab8d10b464ae	RAQUEL	01074	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	PIEA  S.A.	Mar del Plata		489-6317 /489-1367	\N		\N	\N		t	\N	\N	\N
e6427e55-c856-48d7-979b-5095f244365e	REPUNTE	01120	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	OSTRAMAR  S.A.	Mar del Plata		489-1959	\N		\N	\N		t	\N	\N	\N
56ea9769-5bb5-42c6-b95f-b656c0f1d411	REYES DEL MAR II	0408	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	AGUA MARINA  S.A.	Ciudad Autónoma de Buenos Aires		011-4342-0605 / 5656 / 1709	\N		\N	\N		t	\N	\N	\N
62374dc2-3b23-4108-87a0-167a2098f95e	RIBAZON DORINE	0921	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	KALEU KALEU  S.A.	Ciudad Autónoma de Buenos Aires		011-3220-2130  / 5093-1215	\N		\N	\N		t	\N	\N	\N
23afca1d-a1cf-4031-89af-c9cb1abaf5fd	RIBAZON INES	0751	2306	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	38.50	720	34aeab48-9c9b-4c06-8a45-3469f866cf88	SOUTH FISH  S.A.	Mar del Plata		480-5202	\N		\N	\N		t	\N	\N	\N
cfc3468e-e58e-4a40-8240-867715beca37	RIGEL	0266	\N	04d57c5c-390c-4334-bba9-d4635e1cb0c0	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	10	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	LUIS SOLIMENO e HIJOS  S.A.	Mar del Plata		489-3030	\N		\N	\N		t	\N	\N	\N
e3c438f7-54f1-4646-a1d2-587704ac0f9e	ROCIO DEL MAR	01568	2313	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	15	22.60	541	34aeab48-9c9b-4c06-8a45-3469f866cf88	ROCIO DEL MAR  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
f4172705-eccd-4843-913a-f64293b045ae	ROSARIO  G	0549	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	\N	\N	105b0349-a9ed-49bf-9336-aad8d3867f0b	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
7aa7ce10-657a-4c2a-be88-85fd0aa015e7	RUMBO ESPERANZA	01211	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	\N	\N	5f58a58c-0cbb-4d6f-b987-f60d562a279c	CAPAC  SRL	Comodoro Rivadavia		0297-446-1499  /  444-2233	\N		\N	\N		t	\N	\N	\N
d439d226-c16b-4ed8-b224-51f4e0067c0b	RYOUN MARU N° 17	JA06-03	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	BAHIA GRANDE  S.A.	Ciudad Autónoma de Buenos Aires	4891553-154179360-154179860-154179062	011-5272-0850 / 5254-1133	\N	agenciasmiriglio@speedy.com.ar	\N	\N	Agencia Maritima Smiriglio	t	\N	\N	\N
0e2a5c62-db26-40fc-b1b1-13f426e36388	SALVADOR R	02755	2761	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	27.73	420	34aeab48-9c9b-4c06-8a45-3469f866cf88	URBIPEZ  S.A.	Mar del Plata		4892793	\N		\N	\N		t	\N	\N	\N
c5cfd6c0-a38b-4fa2-b001-47f62e495b82	SAN ANDRES APOSTOL	0569	2340	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	54.56	2269	34aeab48-9c9b-4c06-8a45-3469f866cf88	PESANFLOR  S.A.	Mar del Plata		489-6522	\N		\N	\N		t	\N	\N	\N
5a80fa66-051c-46cf-ac41-5a71f597b202	SAN ANTONINO	0375	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	SEA FISH  S.A.	Mar del Plata	51-11-65337853	480-0336	\N		\N	\N	Natalia Cedrato	t	\N	\N	\N
04b53087-52e8-4656-be93-714c343c47d6	VALERIA DEL ATLÁNTICO	02098	2346	bbebd1ff-edd5-48dd-925c-9735bb61b50d	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	60	56.46	4698	34aeab48-9c9b-4c06-8a45-3469f866cf88	SAN ARAWA  S.A.	Mar del Plata		492-2216 / 492-0450	\N		\N	\N		t	\N	\N	\N
9d787749-f123-436e-b686-da4f3f4786c0	SAN BENEDETTO	02643	0	04d57c5c-390c-4334-bba9-d4635e1cb0c0	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	8	15.38	220	34aeab48-9c9b-4c06-8a45-3469f866cf88	PESQUERA SAN BENEDETTO  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
66f53f6d-f483-4da5-b83e-515756eaec5d	SAN GENARO	0763	\N	04d57c5c-390c-4334-bba9-d4635e1cb0c0	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	10	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	LESAUMON  S.A.	Mar del Plata			\N		\N	\N		t	\N	\N	\N
64782920-6598-4760-ba21-7ead251ff1e1	SAN JUAN B	TEMP-0007	2780	bbebd1ff-edd5-48dd-925c-9735bb61b50d	\N	\N	\N	39.94	1204	\N					\N		\N	\N		t	\N	\N	\N
36b6f732-26de-4021-aaa5-2276f16c729a	SAN JORGE MARTIR	02152	2367	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	56.10	1408	34aeab48-9c9b-4c06-8a45-3469f866cf88	PESANFLOR  S.A.	Mar del Plata		489-6522	\N		\N	\N		t	\N	\N	\N
508ba80b-09eb-44f3-a0b8-5a33152949e8	SAN LUCAS  I	06147	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	AGUA MARINA  S.A.	Ciudad Autónoma de Buenos Aires		011-4342-0605 / 5656 / 1709	\N		\N	\N		t	\N	\N	\N
0e3f3e30-87fe-4d95-80dd-2174a3146bde	SAN MATEO	06306	0	04d57c5c-390c-4334-bba9-d4635e1cb0c0	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	54.10	1234	bea22adf-383f-4cc0-8c0b-bd514132fb77	IBERPESCA  S.A.	Rawson		0280-449-8176	\N		\N	\N		t	\N	\N	\N
e23b91fc-22bf-4cbc-8dcd-778a8ca8f574	SAN MATIAS	0289	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	PESCA  ANTIGUA  S.A.	Mar del Plata		489-2340	\N		\N	\N		t	\N	\N	\N
a0968010-bc04-4b2e-a2d5-15f1db080474	SAN PABLO	0759	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	PRODUCTORA ARGEN-PESCA  S.A.	Mar del Plata		480-1444	\N		\N	\N		t	\N	\N	\N
fba5bf87-0034-443e-a48b-43adb82991aa	SAN PASCUAL	0367	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	BUENOS AIRES PESCA  S.A.	Mar del Plata		489-6522	\N		\N	\N		t	\N	\N	\N
2df433f7-49df-41f3-b516-c0220ec981c8	SAN PEDRO APOSTOL	01975	\N	04d57c5c-390c-4334-bba9-d4635e1cb0c0	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	10	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	GAAD GROUP S.A.	Mar del Plata		480-9327	\N		\N	\N		t	\N	\N	\N
b91c1a55-8f51-4006-9ae1-dcc278d053a3	SANT ANTONIO	0974	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	A.B.H. PESQUERA  S.A.	Mar del Plata	4895032	489-6522	\N	operacionesconsultoramaritima@gmail.com.ar	\N	\N	Agencia Merlini	t	\N	\N	\N
412972d9-80c2-4345-9a3f-aa2d29532c11	SANTA BARBARA	5857	2409	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	56.96	1679	34aeab48-9c9b-4c06-8a45-3469f866cf88	PESCA ANGELA  S.A.	Mar del Plata		626-2236 /37	\N		\N	\N		t	\N	\N	\N
49f81da9-ff18-401a-9f1a-2b6372fbad1d	SANTA ANGELA	009	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	OSTRAMAR  S.A.	Mar del Plata		489-1959	\N		\N	\N		t	\N	\N	\N
9f1c8494-2359-4d8f-b918-bc6e999fdc25	SANTIAGO  I	02280	\N	a4a18385-067c-481b-97e9-56dc132240d8	\N	\N	0	\N	\N	105b0349-a9ed-49bf-9336-aad8d3867f0b	FISHING WORLD  S.A.	Puerto Madryn		0280-445-6533	\N		\N	\N		t	\N	\N	\N
43ed857e-e69f-467e-a977-3590327e0708	SCIROCCO	2574	2430	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	65.93	1589	34aeab48-9c9b-4c06-8a45-3469f866cf88	PESQUERA COMERCIAL  S.A.	Mar del Plata		489-3030	\N		\N	\N		t	\N	\N	\N
09e5dde1-a169-4f8d-b0e3-dc4eb9677e0f	SCOMBRUS	0509	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	KALEU KALEU  S.A.	Ciudad Autónoma de Buenos Aires		011-3220-2130  / 5093-1215	\N		\N	\N		t	\N	\N	\N
f29321e0-4d64-48d1-b575-0e35cb4782bf	SCOMBRUS  II	02245	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	\N	\N	105b0349-a9ed-49bf-9336-aad8d3867f0b	HARENGUS  S.A.	Puerto Madryn		0280-445-0822	\N		\N	\N		t	\N	\N	\N
25ffca34-3c0f-44f2-bc05-4a30e28df4dc	SERMILIK	0505	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	\N	\N	105b0349-a9ed-49bf-9336-aad8d3867f0b	HARENGUS  S.A.	Puerto Madryn	4891553-154179360-154179860-154179062	0280-445-0822	\N	agenciasmiriglio@speedy.com.ar	\N	\N	Agencia Smiriglio	t	\N	\N	\N
d90139c7-b316-4228-8bea-b47432cf51e2	SFIDA	01567	2439	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	26.50	624	34aeab48-9c9b-4c06-8a45-3469f866cf88	SAN JORGE S.A.	Mar del Plata		480-6611	\N		\N	\N		t	\N	\N	\N
61dd0857-0ee1-4469-9c3f-cdd9c82f8ef0	SHUNYO MARU 178	JA04	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	VIEIRA ARGENTINA  S.A.	Ciudad Autónoma de Buenos Aires			\N		\N	\N		t	\N	\N	\N
dc8e38b7-a2aa-4d8e-8cef-1949d0a3ffe5	SIEMPRE DON JOSE MOSCUZZA	02257	2460	bbebd1ff-edd5-48dd-925c-9735bb61b50d	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	38.00	1128	34aeab48-9c9b-4c06-8a45-3469f866cf88	FRESCOMAR ARGENTINA  S.A.	Mar del Plata		489-7287	\N		\N	\N		t	\N	\N	\N
c7acce82-8e2d-47b2-940f-48633fd755ad	SIEMPRE DON VICENTE	02654	2706	04d57c5c-390c-4334-bba9-d4635e1cb0c0	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	18.94	341	34aeab48-9c9b-4c06-8a45-3469f866cf88	PESQUERA VIRGEN DE ITATI  S.R.L.	Mar del Plata		480-2921	\N		\N	\N		t	\N	\N	\N
7bddf2fc-485f-4cce-9eef-c2c33cfd117b	SIEMPRE SAN SALVADOR	00801	2475	04d57c5c-390c-4334-bba9-d4635e1cb0c0	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	8	22.35	600	34aeab48-9c9b-4c06-8a45-3469f866cf88	LOURDESMAR  S.R.L.	Mar del Plata		476-2916	\N		\N	\N		t	\N	\N	\N
8b5f68e8-2e5d-47ac-9ffc-3f951ec2770f	SIEMPRE SANTA ROSA	0494	2476	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	27.80	548	34aeab48-9c9b-4c06-8a45-3469f866cf88	GIORNO  S.A.	Mar del Plata		410-0051 / 0057	\N		\N	\N		t	\N	\N	\N
fa2d4e51-8e48-4b80-bb12-27f53c1bbc45	SIEMPRE VIEJO PANCHO	2937	2755	04d57c5c-390c-4334-bba9-d4635e1cb0c0	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	15	17.98	601	\N					\N		\N	\N		t	\N	\N	\N
c89c450a-9ad9-405e-83a1-36bf29c5e3ac	SIMBAD	0754	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	SOUTH FISH  S.A.	Mar del Plata		480-5202	\N		\N	\N		t	\N	\N	\N
7c71c56e-11c0-4c1a-afe2-fea702449d49	SIRIUS	0905	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	LOBA PESQUERA  S.A.M.C.I.	Mar del Plata	4890960	489-0494  /  481-1814	\N	agencia@maritimavidal.com.ar	\N	\N	Agencia Maritima Vidal	t	\N	\N	\N
246d498c-f08a-4cb4-a801-841d2f4d3df5	SIRIUS II	0936	2489	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	59.25	1289	34aeab48-9c9b-4c06-8a45-3469f866cf88	EL MARISCO  S.A.	Mar del Plata	4890960	489-0384	\N	agencia@maritimavidal.com.ar	\N	\N	Agencia Maritima Vidal	t	\N	\N	\N
ddf1b6b7-a4c0-4dc3-92f9-d2dc4f47bdfc	SIRIUS III	0937	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	EL MARISCO  S.A.	Mar del Plata	4808331/4808332	489-0384	\N	marinamdq@speedy.com.ar	\N	\N	Agencia Port Services SRL	t	\N	\N	\N
3c111b3e-1c42-49b4-b579-168516f1dc1f	SOHO MARU Nº 58	02611	2492	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	65.67	1776	f41ff939-bc00-4bbd-8ce8-c451922ba284	ARGENOVA  S.A.	Puerto Deseado		0297- 487-0550  (447-2818  Com. Riv )	\N		\N	\N		t	\N	\N	\N
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
f0cfd06a-b006-4dc5-ada1-3a7e9ba760ad	TAI AN	1530	2533	bbebd1ff-edd5-48dd-925c-9735bb61b50d	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	60	100.50	4506	11c64a29-e693-4bef-b734-8162f86cbbcc	PRODESUR S.A	Ciudad Autónoma de Buenos Aires		492-2216 / 492-0450	\N		\N	\N	54 – 9 - 1141714381	t	\N	\N	\N
692d1013-3f28-4d5f-934c-a013258c46ef	TAI SEI MARU N°8	02207	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	CORPORACION DEL ATLANTICO SUR  S.A.	Ciudad Autónoma de Buenos Aires		011-4105-1133 int 30	\N		\N	\N		t	\N	\N	\N
196d90c9-4a16-4fac-98ca-948f955d17d2	TALISMAN	02263	2541	bbebd1ff-edd5-48dd-925c-9735bb61b50d	1f5e5c39-7fd2-4fb1-8697-d5e0e9a4022b	\N	30	49.95	1302	11c64a29-e693-4bef-b734-8162f86cbbcc	CENTOMAR  S.A.	Ciudad Autónoma de Buenos Aires		011-4816-6245 / 6260  int  * 35	\N		\N	\N		t	\N	\N	\N
adc23180-9487-47ad-9e3d-62eade83623a	TANGO I	02724	2709	bbebd1ff-edd5-48dd-925c-9735bb61b50d	1f5e5c39-7fd2-4fb1-8697-d5e0e9a4022b	\N	30	50.40	1302	11c64a29-e693-4bef-b734-8162f86cbbcc	BENTONICOS DE ARGENTINA  S.A.	Ciudad Autónoma de Buenos Aires		011-5258-2400 / 4407-8240	\N		\N	\N		t	\N	\N	\N
49144ac0-7330-40cf-8ed7-3dd909542a0e	TANGO II	02791	2714	bbebd1ff-edd5-48dd-925c-9735bb61b50d	1f5e5c39-7fd2-4fb1-8697-d5e0e9a4022b	\N	30	50.40	1302	11c64a29-e693-4bef-b734-8162f86cbbcc	BENTONICOS DE ARGENTINA  S.A.	Ciudad Autónoma de Buenos Aires	4891227	011-5258-2400 / 4407-8240	\N	serviciosmaritimosmdq@gmail.com	\N	\N	Servicios maritimos	t	\N	\N	\N
57eeedea-6643-47ae-9017-be61cf330cb5	TESON	01541	2552	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	25.97	765	34aeab48-9c9b-4c06-8a45-3469f866cf88	RITORNO SALLUSTIO Y CICCIOTTI  S.A.	Mar del Plata		480-5508	\N		\N	\N		t	\N	\N	\N
0b4157ee-a026-44f8-a1e6-1116535e2d26	TIAN YUAN	02173	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	CORPORACION DEL ATLANTICO SUR  S.A.	Ciudad Autónoma de Buenos Aires		011-4105-1133 int 30	\N		\N	\N		t	\N	\N	\N
e35f8610-22cd-4e58-89b4-84bfa82f68a3	TOBA MARU	0241	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	105b0349-a9ed-49bf-9336-aad8d3867f0b	CONARPESA  S.A.	Puerto Madryn		0280-445-1731 / 445-4536	\N		\N	\N		t	\N	\N	\N
9e5703f1-2438-4640-a445-9d7a843ac5a3	TORNYY	240	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	1f5e5c39-7fd2-4fb1-8697-d5e0e9a4022b	\N	30	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	CRUSTACEOS DEL SUR  S.A.	Ciudad Autónoma de Buenos Aires		011-5218-4287	\N		\N	\N		t	\N	\N	\N
1abed229-2379-475a-aa42-f5799e65c9c8	TOZUDO	01219	2566	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	26.74	624	34aeab48-9c9b-4c06-8a45-3469f866cf88	CABO VERDE  S.A.	Mar del Plata		489-4645	\N		\N	\N		t	\N	\N	\N
e40ee692-dd27-4f9b-87ba-dc7b20ad103a	TRABAJAMOS	02904	2726	04d57c5c-390c-4334-bba9-d4635e1cb0c0	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	4	19.94	592	f41ff939-bc00-4bbd-8ce8-c451922ba284	DESEADO FISH  S.A.	Puerto Deseado			\N		\N	\N		t	\N	\N	\N
e22e8e02-9cbe-4d76-b41f-0e8c22ea3e15	UCHI	01901	2580	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	54.23	1552	11c64a29-e693-4bef-b734-8162f86cbbcc	PESQUERA SANTA ELENA S.A.I.C.	Ciudad Autónoma de Buenos Aires		011-4328-9909	\N		\N	\N		t	\N	\N	\N
f1a84c8a-5feb-4aa7-b233-4b31764a149e	UNION	01539	\N	04d57c5c-390c-4334-bba9-d4635e1cb0c0	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	10	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	RITORNO SALLUSTIO Y CICCIOTTI  S.A.	Mar del Plata		480-5508	\N		\N	\N		t	\N	\N	\N
e5699f88-21fe-4939-b71f-ca3b630a5a1a	URABAIN	0612	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	60	\N	\N	105b0349-a9ed-49bf-9336-aad8d3867f0b	IBERCONSA  DE ARGENTINA  S.A.	Puerto Madryn	mariano@maritimavidal.com.ar	0280-445-4324	\N		\N	\N	raul@maritimavidal.com.ar	t	\N	\N	\N
28951b47-241f-46bb-9aa3-97f42bd51686	UR ERTZA	0377	2587	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	51.00	1482	34aeab48-9c9b-4c06-8a45-3469f866cf88	LUIS SOLIMENO e HIJOS  S.A.	Mar del Plata		489-3030	\N		\N	\N		t	\N	\N	\N
d623606d-b5f4-4a44-be99-7f1b7b891651	VALIENTE I	0211A	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	EXPLOTACION PESQ. DE LA PATAGONIA  S.A.	Mar del Plata		489-4624  /  489-0314 (astillero)	\N		\N	\N		t	\N	\N	\N
e514c52b-97fa-4ad2-b641-209075d86b82	VALIENTE II	0212A	2718	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	35.30	1001	34aeab48-9c9b-4c06-8a45-3469f866cf88	EXPLOTACION PESQ. DE LA PATAGONIA  S.A.	Mar del Plata		489-4624  /  489-0314 (astillero)	\N		\N	\N	agencia@maritimavidal.com.ar	t	\N	\N	\N
c6c6fcdc-e445-4e60-8a3f-a70b8e33aab7	VENTARRON 1º	0479	2708	bbebd1ff-edd5-48dd-925c-9735bb61b50d	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	60	63.07	1969	105b0349-a9ed-49bf-9336-aad8d3867f0b	ATUNERA  ARGENTINA  S.A.	Puerto Madryn		0280-445-4324	\N		\N	\N		t	\N	\N	\N
8469be80-7002-421a-ab82-e3f2598ea5d0	VERAZ	0144	2603	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	27.45	604	34aeab48-9c9b-4c06-8a45-3469f866cf88	PESQUERA VERAZ  S.A.	Mar del Plata		489-4624 / 489-0314 (astillero)	\N		\N	\N		t	\N	\N	\N
129a7390-74a6-453e-896e-309f65fed7c8	VERDEL	0174	2604	bbebd1ff-edd5-48dd-925c-9735bb61b50d	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	60	71.70	1975	5b1bcc08-58a5-499b-b2cc-d02d0df392fa	IBERMAR  S.A.	Bahia Blanca		0291-457-2427	\N		\N	\N		t	\N	\N	\N
be2c657b-8113-47da-a3a7-5f5cfebd1dbf	VERONICA ALEJANDRA N	02292	2606	04d57c5c-390c-4334-bba9-d4635e1cb0c0	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	4	15.30	223	bea22adf-383f-4cc0-8c0b-bd514132fb77	FARO CHUBUT  S.R.L.	Rawson		0280-449-6311	\N		\N	\N		t	\N	\N	\N
ddfec106-6e47-411c-b2d4-adf1dd5b8746	VICTOR ANGELESCU	9798820	\N	1e6f3be0-9af3-40cf-8306-e1358231f214	\N	\N	\N	\N	\N	\N	INIDEP				\N		\N	\N		t	\N	\N	\N
629d964d-9ac3-4ee8-9a55-09d56fc7673f	VICTORIA DEL MAR 1°	0929	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	RIPSA  S.A. ( ROSALES INDUSTRIAL PESQ. )	Mar del Plata		489-7881	\N		\N	\N		t	\N	\N	\N
305c8108-ded6-455d-a6a5-1e0a21484f20	VICTORIA I	0554	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	\N	\N	105b0349-a9ed-49bf-9336-aad8d3867f0b	PEREIRA  ARGENTINA  S.A.	Puerto Madryn		0280-445-7377 / 447-2249	\N		\N	\N		t	\N	\N	\N
760287d4-30c2-445a-ad41-cd2dfc6564f5	VICTORIA II	0556	2611	991d17ee-9376-401c-8883-c0409127d0af	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	27.40	601	34aeab48-9c9b-4c06-8a45-3469f866cf88	CRESTAS  S.A.	Mar del Plata		410-5170	\N		\N	\N		t	\N	\N	\N
3f90c51b-044b-4e79-bd54-e12843faea49	VICTORIA P	02246	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	PESQUERA SANTA ELENA S.A.I.C.	Ciudad Autónoma de Buenos Aires		011-4328-9909	\N		\N	\N		t	\N	\N	\N
3bd2ac38-9e26-401a-9e80-80c27a57f9e6	VIEIRASA DIECIOCHO	2563	2615	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	67.78	1803	11c64a29-e693-4bef-b734-8162f86cbbcc	VIEIRA ARGENTINA  S.A.	Ciudad Autónoma de Buenos Aires			\N		\N	\N		t	\N	\N	\N
a85ab5c8-5b56-493d-a825-43ada90f6396	VIEIRASA DIECISEIS	0240	2616	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	36.13	702	11c64a29-e693-4bef-b734-8162f86cbbcc	VIEIRA ARGENTINA  S.A.	Ciudad Autónoma de Buenos Aires			\N		\N	\N		t	\N	\N	\N
feea603c-78ed-43b9-85f3-27b6966506bd	VIEIRASA DIECISIETE	2568	2752	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	59.03	1401	11c64a29-e693-4bef-b734-8162f86cbbcc	VIEIRA ARGENTINA  S.A.	Ciudad Autónoma de Buenos Aires			\N		\N	\N		t	\N	\N	\N
419b6840-3a4c-4e03-95dd-ced646525de2	VIEIRASA QUINCE	0179	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	VIEIRA ARGENTINA  S.A.	Ciudad Autónoma de Buenos Aires			\N		\N	\N		t	\N	\N	\N
9962a6a8-0968-45c3-a7a3-12be0107769b	VIENTO DEL SUR	01858	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	60	\N	\N	f41ff939-bc00-4bbd-8ce8-c451922ba284	PESPASA  S.A.	Puerto Deseado		0297-487-2030  int 12	\N		\N	\N		t	\N	\N	\N
d934c9a4-f550-4b90-9dbd-6bf1b56d97ab	VILLARINO	02178	2629	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	64.50	1776	b1ec7a4f-f3e1-4ebc-8814-3951987690d7	PESCA AUSTRAL  S.A.	San Antonio Oeste		02934-49-2111	\N		\N	\N		t	\N	\N	\N
d213091a-9f2b-4b35-ba64-2b57a28e7069	VIRGEN DEL CARMEN	0550	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	MAR PURO  S.A.	Mar del Plata		451-1830	\N		\N	\N		t	\N	\N	\N
b3c5dd0f-33a9-457e-a73e-d4a7feb3ea1d	VIRGEN DEL MILAGRO	02767	2725	04d57c5c-390c-4334-bba9-d4635e1cb0c0	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	4	19.93	380	f41ff939-bc00-4bbd-8ce8-c451922ba284	UNION PESQUERA PATAGONIA  S.A.	Puerto Deseado			\N		\N	\N		t	\N	\N	\N
1bd67057-e996-4987-859b-486fe29cf4e7	VIRGEN DEL ROCIO	0194	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	fedc5975-2697-4b57-b26d-492a64ef6cc8	\N	30	\N	\N	105b0349-a9ed-49bf-9336-aad8d3867f0b	ALPESCA  S.A.	Puerto Madryn		0280-447-4958 / 45-1069	\N		\N	\N		t	\N	\N	\N
649e5ded-9a48-4bf8-aaa1-2edf147fe587	VIRGEN MARIA	0541	2645	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	56.65	1803	34aeab48-9c9b-4c06-8a45-3469f866cf88	LUIS SOLIMENO e HIJOS  S.A.	Mar del Plata		489-3030	\N		\N	\N		t	\N	\N	\N
7f600131-a0a9-4257-bc7d-8461f73f8708	VIRGEN MARIA INMACULADA	0369	\N	04d57c5c-390c-4334-bba9-d4635e1cb0c0	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	10	\N	\N	\N					\N		\N	\N		t	\N	\N	\N
85c8d99b-103f-45ca-b786-9031f8664ff5	WIRON  IV	01476	\N	991d17ee-9376-401c-8883-c0409127d0af	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	30	\N	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	TATURIELLO  S.A.	Mar del Plata		489-3833	\N		\N	\N		t	\N	\N	\N
0956ea0a-4aa0-4aa0-a2ac-72e3732ff025	XEITOSIÑO	0403	2668	bbebd1ff-edd5-48dd-925c-9735bb61b50d	acea052d-e5d1-4ced-b98c-2d01eb79122a	\N	60	51.72	1502	34aeab48-9c9b-4c06-8a45-3469f866cf88	PESQUERA EL NAZARENO	Mar del Plata		489-9414 (of. Pers. Emb.)	\N		\N	\N		t	\N	\N	\N
54ba7518-621f-4152-93de-64a68fbe47bf	XIN SHI DAI N° 28	02165	2669	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	62.40	1579	11c64a29-e693-4bef-b734-8162f86cbbcc	MUELLE OCHO  S.A.	Ciudad Autónoma de Buenos Aires		011-4381-1337	\N		\N	\N		t	\N	\N	\N
f66e1f1b-90e1-4735-8859-0f6bc27bcaf2	XIN SHI JI 25	03092	2753	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	70.50	0	11c64a29-e693-4bef-b734-8162f86cbbcc	PESQUERA  20  DE NOVIEMBRE  S.A.	Ciudad Autónoma de Buenos Aires		011-4382-5011 / 4381-1337	\N		\N	\N		t	\N	\N	\N
c961b3c2-ee1e-4168-93e5-8f3e6ce121f0	XIN SHI JI N° 88	02182	\N	bbebd1ff-edd5-48dd-925c-9735bb61b50d	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	11c64a29-e693-4bef-b734-8162f86cbbcc	FENIX  INTERNATIONAL  S.A.	Ciudad Autónoma de Buenos Aires		011-4381-1337	\N		\N	\N		t	\N	\N	\N
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
6a4b71d5-4789-40b2-b402-f0e266a9fdd7	HOLMBERG	7918189	\N	1e6f3be0-9af3-40cf-8306-e1358231f214	\N	\N	\N	\N	\N	\N	INIDEP				\N		\N	\N		t	\N	\N	\N
4f75a080-0d2a-4778-98d8-51734f69f160	MAR ARGENTINO	9883833	\N	1e6f3be0-9af3-40cf-8306-e1358231f214	\N	\N	\N	\N	\N	\N	INIDEP				\N		\N	\N		t	\N	\N	\N
8fbf968b-b9aa-4316-ac14-c65ecb2bc56b	Hai Xiang 16	LW5157	\N	a4a18385-067c-481b-97e9-56dc132240d8	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	\N	PESQUERA RÍO QUEQUEN				\N		\N	\N		t	\N	\N	\N
4c346349-604d-4835-9682-3f7ab65c240d	Hai Xiang 17	LW3286	\N	a4a18385-067c-481b-97e9-56dc132240d8	57d68d17-afe4-47b5-baf5-4e4791069319	\N	40	\N	\N	\N	PESQUERA RÍO QUEQUEN				\N		\N	\N		t	\N	\N	\N
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
\.


--
-- Data for Name: lances; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.lances (id, etapa_id, numero_lance, fecha, cod_arte_pesca, tipo_arte_pesca, hora_inicio, lat_inicio, long_inicio, prof_inicio, hora_final, lat_final, long_final, prof_final, rumbo, distancia_red, velocidad_arrastre, tiempo_red, estacion_gral, calador, fondo_min, fondo_max, tamiz, area_barrida, captura_total_kg, descarte_total_kg, observaciones_lance, mus, fuente_dato) FROM stdin;
\.


--
-- Data for Name: mareas; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.mareas (id, anio_marea, nro_marea, id_buque, id_arte_principal, id_estado_actual, fecha_zarpada_estimada, fecha_inicio_observador, fecha_fin_observador, dias_zona_austral, tipo_calculo_zona_austral, nro_protocolizacion, anio_protocolizacion, fecha_protocolizacion, fecha_creacion, fecha_ultima_actualizacion, activo, observaciones, tipo_marea, dias_estimados) FROM stdin;
04b6229f-7d19-4b8a-9237-a519202222a0	2025	24	863ff4de-02ab-477a-b726-83d3e9148648	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-01-31 03:00:00+00	\N	\N	22	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:09.614+00	2026-01-14 00:41:09.614+00	t	Importada de JSONL. Empresa: ARGENOVA. Especie: MERLUZA AUSTRAL	MC	30
e6f7ebb4-26d6-4bc1-b14e-db07fdf479f5	2025	25	49144ac0-7330-40cf-8ed7-3dd909542a0e	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-02-01 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:09.628+00	2026-01-14 00:41:09.628+00	t	Importada de JSONL. Empresa: BENTONICOS DE ARGENTINA. Especie: CENTOLLA	MC	30
55f52d76-0c76-490c-81d3-5a03b292c9c3	2025	26	c6c6fcdc-e445-4e60-8a3f-a70b8e33aab7	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-02-02 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:09.64+00	2026-01-14 00:41:09.64+00	t	Importada de JSONL. Empresa: GIORNO. Especie: MERLUZA	MC	30
b8d25e78-d9c7-4416-977b-ebf6e60ca6cc	2025	27	82d93396-176a-4d74-a5de-5addaf47520f	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-01-31 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:09.649+00	2026-01-14 00:41:09.649+00	t	Importada de JSONL. Empresa: CHIARPESCA. Especie: CALAMAR	MC	30
e30b483b-ea05-4b41-93f0-c89e7c97b7a6	2025	28	69ff7a7d-9417-4f5c-9693-8e2835fef39b	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-02-06 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:09.658+00	2026-01-14 00:41:09.658+00	t	Importada de JSONL. Empresa: PESANTAR. Especie: CALAMAR	MC	60
e5d2e37b-a388-47fd-b3a7-a09b73fa0158	2025	29	246d498c-f08a-4cb4-a801-841d2f4d3df5	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-02-03 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:09.667+00	2026-01-14 00:41:09.667+00	t	Importada de JSONL. Empresa: EL MARISCO. Especie: MERLUZA	MC	30
7701800b-8c67-4f60-80ea-c72a68a80f7d	2025	30	04b53087-52e8-4656-be93-714c343c47d6	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-02-12 03:00:00+00	\N	\N	83	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:09.676+00	2026-01-14 00:41:09.676+00	t	Importada de JSONL. Empresa: ESTREMAR. Especie: MERLUZA AUSTRAL	MC	30
3d1e676b-21d2-45cd-8f2d-d93f4727b01c	2025	31	4a837a56-b513-4568-b2d7-61bc1d66d22b	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-02-02 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:09.684+00	2026-01-14 00:41:09.684+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: VIEIRA	MC	30
0ac9a3b7-fead-4b51-b1c3-51c7333154ef	2025	32	f0cfd06a-b006-4dc5-ada1-3a7e9ba760ad	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-02-19 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:09.696+00	2026-01-14 00:41:09.696+00	t	Importada de JSONL. Empresa: PRODESUR. Especie: MERLUZA AUSTRAL	MC	60
4fd2c3f7-68a3-458e-bd8b-5e2c62ec60ed	2025	33	7a5c52c3-f87e-4405-a08e-f3b2ae274460	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-02-14 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:09.709+00	2026-01-14 00:41:09.709+00	t	Importada de JSONL. Empresa: PESQUERA VERAZ. Especie: MERLUZA	MC	30
1a54b40d-84c1-4c94-a3d6-a2b52391b780	2025	34	2df50464-9916-4b3e-b5c3-3a645623d525	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-02-27 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:09.721+00	2026-01-14 00:41:09.721+00	t	Importada de JSONL. Empresa: GLACIAR PESQUERA. Especie: VIEIRA	MC	30
6da5576d-2280-48a7-8d72-be325aafe103	2025	35	863ff4de-02ab-477a-b726-83d3e9148648	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-02-25 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:09.731+00	2026-01-14 00:41:09.731+00	t	Importada de JSONL. Empresa: ARGENOVA. Especie: MERLUZA AUSTRAL	MC	30
9f71d41a-5a5b-4ee1-8076-f8ef65eb3583	2025	36	5fa98bd7-f095-4d3e-8e98-7761568ec108	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-02-20 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:09.74+00	2026-01-14 00:41:09.74+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: VIEIRA	MC	30
e21b90dc-df99-4eba-8a8a-1624de4dc936	2025	37	7d23c84f-115a-4318-9e29-aa24a4809280	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-02-21 03:00:00+00	\N	\N	29	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:09.75+00	2026-01-14 00:41:09.75+00	t	Importada de JSONL. Empresa: CRUSTACEOS DEL SUR S.A. Especie: CENTOLLA	MC	30
da24bf7d-9642-4503-81d1-58fd1fbe8ffe	2025	38	a16cce31-d12d-458a-b212-6846185933bf	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-03-05 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:09.762+00	2026-01-14 00:41:09.762+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: CENTOLLA	MC	30
b6f7a234-a1b5-464f-82e1-f691d1d61c0d	2025	39	adc23180-9487-47ad-9e3d-62eade83623a	\N	2ea71871-f6e2-480b-bb64-6d2f436ffa6f	2025-03-06 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:09.774+00	2026-01-14 00:41:09.774+00	t	Importada de JSONL. Empresa: BENTONICOS DE ARGENTINA. Especie: CENTOLLA	MC	30
e4dfb9b7-1dc7-4838-bd5b-65bda33b7062	2025	40	0ddb5663-8ab9-4ad5-ab76-fb98b2e5d15d	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-03-06 03:00:00+00	\N	\N	6	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:09.78+00	2026-01-14 00:41:09.78+00	t	Importada de JSONL. Empresa: GLACIAR PESQUERA. Especie: VIEIRA	MC	30
90bf9a4a-3233-43e0-bceb-4843a6424ff1	2025	41	08da59fb-fa52-49da-b7ec-6e276d53b841	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-03-03 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:09.787+00	2026-01-14 00:41:09.787+00	t	Importada de JSONL. Empresa: FOOD ARTS S.A. Especie: CALAMAR	MC	30
c29d8cf7-bdde-4596-8fda-d1911fbe68ec	2025	42	1abed229-2379-475a-aa42-f5799e65c9c8	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-03-07 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:09.795+00	2026-01-14 00:41:09.795+00	t	Importada de JSONL. Empresa: TOZUDO. Especie: P.ABADEJO	MC	30
e06c2441-b7b0-4922-9aad-dbc981bbc1d3	2025	43	b1fedb55-7446-4027-aa7c-1a5dcfcb4ba5	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-03-07 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:09.805+00	2026-01-14 00:41:09.805+00	t	Importada de JSONL. Empresa: PESQUERA SIEMPRE GAUCHO. Especie: P.ABADEJO	MC	30
daff9983-9b0f-46a5-87a0-21d52c16b234	2025	44	c5d2228b-36be-4674-8c03-14f817316ca7	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-03-07 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:09.814+00	2026-01-14 00:41:09.814+00	t	Importada de JSONL. Empresa: LOBA PESQUERA. Especie: P.ABADEJO	MC	30
921652f0-4013-4808-98fb-9234429ecfdf	2025	45	887ff179-0c25-4956-9165-09125f9152f0	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-03-07 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:09.824+00	2026-01-14 00:41:09.824+00	t	Importada de JSONL. Empresa: ROMFIOC S.R.L. Especie: P.ABADEJO	MC	30
eab63893-ae5b-4bb9-81f5-82073dd5a928	2025	46	57eeedea-6643-47ae-9017-be61cf330cb5	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-03-07 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:09.832+00	2026-01-14 00:41:09.832+00	t	Importada de JSONL. Empresa: MAREA OPTIMA. Especie: P.ABADEJO	MC	30
f772b482-10e8-4dbd-b54d-18ad99ee8da4	2025	47	e70330eb-bcaf-472c-9906-1096de4235dd	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-03-12 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:09.844+00	2026-01-14 00:41:09.844+00	t	Importada de JSONL. Empresa: CRUSTACEOS DEL SUR S.A. Especie: CENTOLLA	MC	30
661d8e7c-b0ee-4bb4-addd-d927d95de530	2025	48	196d90c9-4a16-4fac-98ca-948f955d17d2	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-03-12 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:09.851+00	2026-01-14 00:41:09.851+00	t	Importada de JSONL. Empresa: CENTOMAR S.A. Especie: CENTOLLA	MC	30
9b158375-56d3-4207-a70b-32eb6f7e4a1f	2025	49	1552d8ac-53ec-4246-a410-f2c7bf19e516	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-03-18 03:00:00+00	\N	\N	27	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:09.86+00	2026-01-14 00:41:09.86+00	t	Importada de JSONL. Empresa: ESTRELLA PATAGONICA. Especie: MERLUZA	MC	30
134e771f-508a-40df-a6ac-76f532bdaeb6	2025	50	e7ed7f8b-9e82-48db-94f1-c9c63d3391eb	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-03-22 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:09.869+00	2026-01-14 00:41:09.869+00	t	Importada de JSONL. Empresa: MOSCUZZA. Especie: CALAMAR	MC	30
a82d5e41-b695-4a9d-aea9-0f3194d52b67	2025	51	4a837a56-b513-4568-b2d7-61bc1d66d22b	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-03-24 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:09.876+00	2026-01-14 00:41:09.876+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: VIEIRA	MC	30
36d0f8b0-0c70-4822-9a1f-17486328b822	2025	52	863ff4de-02ab-477a-b726-83d3e9148648	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-03-27 03:00:00+00	\N	\N	25	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:09.884+00	2026-01-14 00:41:09.884+00	t	Importada de JSONL. Empresa: ARGENOVA. Especie: MERLUZA AUSTRAL	MC	30
8ca1a435-51b3-4cdb-8323-d12132f30070	2025	53	c7c5892b-d6ee-4b44-b3a6-24dc9ded90aa	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-03-28 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:09.896+00	2026-01-14 00:41:09.896+00	t	Importada de JSONL. Empresa: PEDRO MOSCUZZA E HIJO. Especie: CALAMAR	MC	30
f4602bf8-6141-4e7c-9a9b-9d3d1e63761f	2025	54	5fa98bd7-f095-4d3e-8e98-7761568ec108	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-04-09 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:09.905+00	2026-01-14 00:41:09.905+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: VIEIRA	MC	30
4f5e867f-2277-4990-89a0-8e621d229020	2025	55	f0cfd06a-b006-4dc5-ada1-3a7e9ba760ad	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-04-17 03:00:00+00	\N	\N	1	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:09.916+00	2026-01-14 00:41:09.916+00	t	Importada de JSONL. Empresa: PRODESUR. Especie: MERLUZA AUSTRAL	MC	60
ab688bbc-76e4-4967-9d8b-79141f666795	2025	56	69ff7a7d-9417-4f5c-9693-8e2835fef39b	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-04-10 03:00:00+00	\N	\N	39	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:09.925+00	2026-01-14 00:41:09.925+00	t	Importada de JSONL. Empresa: PESANTAR. Especie: MERLUZA AUSTRAL	MC	60
75b63bea-982a-4151-8923-cdc3ca09d56e	2025	57	adc23180-9487-47ad-9e3d-62eade83623a	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-04-09 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:09.935+00	2026-01-14 00:41:09.935+00	t	Importada de JSONL. Empresa: BENTONICOS DE ARGENTINA. Especie: CENTOLLA	MC	30
83254676-7d69-46bb-839c-fcb352334c92	2025	58	feea603c-78ed-43b9-85f3-27b6966506bd	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-04-22 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:09.943+00	2026-01-14 00:41:09.943+00	t	Importada de JSONL. Empresa: VIERA ARGENTINA. Especie: CALAMAR	MC	30
02d0bd10-2761-47e9-a460-30e179e77b9d	2025	59	2df50464-9916-4b3e-b5c3-3a645623d525	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-04-10 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:09.953+00	2026-01-14 00:41:09.953+00	t	Importada de JSONL. Empresa: GLACIAR PESQUERA. Especie: VIEIRA	MC	30
13eeb6f9-9d7e-48d0-8d5d-d72695620833	2025	60	a16cce31-d12d-458a-b212-6846185933bf	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-04-10 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:09.961+00	2026-01-14 00:41:09.961+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: CENTOLLA	MC	30
bc9edd1c-bfb7-4fc2-a452-e6cf557ca733	2025	61	0ddb5663-8ab9-4ad5-ab76-fb98b2e5d15d	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-04-17 03:00:00+00	\N	\N	6	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:09.968+00	2026-01-14 00:41:09.968+00	t	Importada de JSONL. Empresa: GLACIAR PESQUERA. Especie: VIEIRA	MC	30
7d09cfaa-19da-4ab3-8ce5-b891a4b9d215	2025	62	21c0f3cb-e6e8-43bc-929b-99c24f15bf83	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-04-15 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:09.976+00	2026-01-14 00:41:09.976+00	t	Importada de JSONL. Empresa: ALTAMARE S.AS. Especie: CALAMAR	MC	30
9eb6be1f-e0cd-43b6-876e-3303f8238252	2025	63	c1fb290e-10a9-4cef-9075-929f585122f3	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-04-11 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:09.984+00	2026-01-14 00:41:09.984+00	t	Importada de JSONL. Empresa: PESCARGEN. Especie: LANGOSTINO	MC	30
2e03db0e-0f5a-4bee-a9ce-62275877178f	2025	64	c6c6fcdc-e445-4e60-8a3f-a70b8e33aab7	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-04-22 03:00:00+00	\N	\N	6	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:09.999+00	2026-01-14 00:41:09.999+00	t	Importada de JSONL. Empresa: GIORNO. Especie: MERLUZA	MC	30
a7b198f6-2669-4367-8dca-b1cf27ac4f51	2025	65	cad32064-7964-4a41-9f30-a1998363ab99	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-04-15 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.01+00	2026-01-14 00:41:10.01+00	t	Importada de JSONL. Empresa: LUIS SOLIMENO. Especie: MERLUZA	MC	30
12560a8d-1d4d-4c20-a734-8ee0ff62a0e6	2025	66	abfe526f-bf85-4dc2-89c7-557bfa93dbc3	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-04-21 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.023+00	2026-01-14 00:41:10.023+00	t	Importada de JSONL. Empresa: MARÍTIMA COMERCIAL. Especie: MERLUZA	MC	30
edb87fd9-19c0-438c-a893-5b99fcecf2e6	2025	67	c82bf74e-e7d0-45f9-a472-82d0127b3694	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-04-29 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.034+00	2026-01-14 00:41:10.034+00	t	Importada de JSONL. Empresa: NIETOS ANTONIO BALDINO. Especie: MERLUZA	MC	30
cc26c06e-063a-4f03-ba93-dc1548da8b5f	2025	68	a1b563e1-607a-4532-8d14-0ecc7ee1fe20	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-04-23 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.041+00	2026-01-14 00:41:10.041+00	t	Importada de JSONL. Empresa: MOSCUZZA. Especie: MERLUZA	MC	30
9a6c3e8b-124a-4c95-bf49-94f903004ab6	2025	69	e7ed7f8b-9e82-48db-94f1-c9c63d3391eb	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-04-26 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.053+00	2026-01-14 00:41:10.053+00	t	Importada de JSONL. Empresa: MOSCUZZA. Especie: CALAMAR	MC	30
6b0da04b-0dd6-421a-bd51-67a1f0c1a56a	2025	70	3f5729dd-4d20-4e27-a7f1-ef46d30e973d	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-04-25 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.06+00	2026-01-14 00:41:10.06+00	t	Importada de JSONL. Empresa: MARONTI  S.A.. Especie: MERLUZA	MC	30
e15a4939-ae23-4991-8ac4-5ed84361e229	2025	71	82d93396-176a-4d74-a5de-5addaf47520f	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-04-24 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.072+00	2026-01-14 00:41:10.072+00	t	Importada de JSONL. Empresa: GRUPO CHIAR PESCA. Especie: CALAMAR	MC	30
61639206-bb3b-4e02-a43b-571ffe935af8	2025	72	863ff4de-02ab-477a-b726-83d3e9148648	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-04-29 03:00:00+00	\N	\N	24	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.08+00	2026-01-14 00:41:10.08+00	t	Importada de JSONL. Empresa: ARGENOVA. Especie: MERLUZA AUSTRAL	MC	30
5ad3a3fb-e713-4aa4-bdfa-c64897be84c4	2025	73	1f6cbb5f-d134-4ee3-9315-bf24ae2a7946	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-04-26 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.087+00	2026-01-14 00:41:10.087+00	t	Importada de JSONL. Empresa: BUENA PROA. Especie: MERLUZA	MC	30
23bec926-2e1e-48ac-a34e-b021931e5c4a	2025	74	b88d3a8d-a83a-4a6b-a566-85bf97fb3fb7	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-04-30 03:00:00+00	\N	\N	7	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.1+00	2026-01-14 00:41:10.1+00	t	Importada de JSONL. Empresa: GIORNO. Especie: MERLUZA	MC	30
5ca55e94-ec43-4870-a024-53c6fd3899e0	2025	75	04b53087-52e8-4656-be93-714c343c47d6	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-05-07 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.108+00	2026-01-14 00:41:10.108+00	t	Importada de JSONL. Empresa: ESTREMAR. Especie: MERLUZA AUSTRAL	MC	30
d1345931-2377-4835-b707-56cffe0d23b7	2025	76	4a837a56-b513-4568-b2d7-61bc1d66d22b	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-05-07 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.116+00	2026-01-14 00:41:10.116+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: VIEIRA	MC	30
ad6ff68c-97d6-4ccf-99e7-09705901ef24	2025	77	face2a5f-184c-41f8-b3a8-9beebc3635ee	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-05-04 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.124+00	2026-01-14 00:41:10.124+00	t	Importada de JSONL. Empresa: GIORNO. Especie: MERLUZA	MC	30
ac5ff8a0-6a36-4e59-a826-099cad6c260a	2025	78	3e0c8867-184b-437a-a2b6-482cf522af0a	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-05-06 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.132+00	2026-01-14 00:41:10.132+00	t	Importada de JSONL. Empresa: FOOD ARTS S.A. Especie: CALAMAR	MC	30
92c833ed-110f-423d-bb0f-42eb1a3cc410	2025	79	c7c5892b-d6ee-4b44-b3a6-24dc9ded90aa	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-05-06 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.141+00	2026-01-14 00:41:10.141+00	t	Importada de JSONL. Empresa: MOSCUZZA. Especie: CALAMAR	MC	30
1ee1160e-1fe6-4523-a965-5d081f225006	2025	80	c1fb290e-10a9-4cef-9075-929f585122f3	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-05-10 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.148+00	2026-01-14 00:41:10.148+00	t	Importada de JSONL. Empresa: PESCAREN S.A. Especie: LANGOSTINO	MC	30
896cabea-e6b1-4027-9da4-4cd64d9b8173	2025	81	a16cce31-d12d-458a-b212-6846185933bf	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-05-15 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.155+00	2026-01-14 00:41:10.155+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: CENTOLLA	MC	30
24de7801-3383-4693-90a3-d4e2f389ebc2	2025	82	69ff7a7d-9417-4f5c-9693-8e2835fef39b	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-05-22 03:00:00+00	\N	\N	50	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.162+00	2026-01-14 00:41:10.162+00	t	Importada de JSONL. Empresa: PESANTAR. Especie: MERLUZA AUSTRAL	MC	60
6536a509-e9ff-4c6c-86ac-c29d35e250a1	2025	83	a12653df-c0ca-4814-8442-78636dfa6d94	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-05-17 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.169+00	2026-01-14 00:41:10.169+00	t	Importada de JSONL. Empresa: MOSCUZZA. Especie: MERLUZA	MC	30
d97a833e-1094-4499-acd3-abe345f14bf6	2025	84	854c142e-a45b-4022-9411-52c786baa572	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-05-20 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.178+00	2026-01-14 00:41:10.178+00	t	Importada de JSONL. Empresa: LUIS SOLIMENO. Especie: MERLUZA	MC	30
8c663be4-70ad-4605-b929-e131899c47a2	2025	85	b88d3a8d-a83a-4a6b-a566-85bf97fb3fb7	\N	2ea71871-f6e2-480b-bb64-6d2f436ffa6f	2025-05-20 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.187+00	2026-01-14 00:41:10.187+00	t	Importada de JSONL. Empresa: GIORNO. Especie: MERLUZA	MC	30
ce6b184a-27cc-4e69-9b54-1de1c90c1dec	2025	86	43ed857e-e69f-467e-a977-3590327e0708	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-05-20 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.192+00	2026-01-14 00:41:10.192+00	t	Importada de JSONL. Empresa: LUIS SOLIMENO. Especie: CALAMAR	MC	30
3dd68328-0ea1-4d1a-9142-b67088fedcda	2025	87	f0cfd06a-b006-4dc5-ada1-3a7e9ba760ad	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-05-20 03:00:00+00	\N	\N	31	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.2+00	2026-01-14 00:41:10.2+00	t	Importada de JSONL. Empresa: PRODESUR. Especie: MERLUZA AUSTRAL	MC	60
12634231-f4e9-4b82-9958-26972ac58975	2025	88	5fa98bd7-f095-4d3e-8e98-7761568ec108	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-05-26 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.207+00	2026-01-14 00:41:10.207+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: VIEIRA	MC	30
26fe3877-c712-44bf-90da-4e8fe9d152d2	2025	89	0ddb5663-8ab9-4ad5-ab76-fb98b2e5d15d	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-05-31 03:00:00+00	\N	\N	6	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.214+00	2026-01-14 00:41:10.214+00	t	Importada de JSONL. Empresa: GLACIAR PESQUERA. Especie: VIEIRA	MC	30
ec6c04a5-0942-4932-bf6d-e8f11745ad45	2025	90	c1fb290e-10a9-4cef-9075-929f585122f3	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-05-28 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.222+00	2026-01-14 00:41:10.222+00	t	Importada de JSONL. Empresa: PESCARGEN. Especie: LANGOSTINO	MC	30
d824e9ee-9849-4b51-9fcd-517af440e4d0	2025	91	e7ed7f8b-9e82-48db-94f1-c9c63d3391eb	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-05-29 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.232+00	2026-01-14 00:41:10.232+00	t	Importada de JSONL. Empresa: MOSCUZZA. Especie: CALAMAR	MC	30
edc5129c-6579-4b84-bc23-ae7baff116fc	2025	92	66098466-a6dd-4982-8347-335fe023e588	\N	2ea71871-f6e2-480b-bb64-6d2f436ffa6f	2025-05-29 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.239+00	2026-01-14 00:41:10.239+00	t	Importada de JSONL. Empresa: CONARPESA. Especie: LANGOSTINO	MC	30
de435656-8da8-430d-891a-def2e8aa5c3c	2025	93	2df50464-9916-4b3e-b5c3-3a645623d525	\N	2ea71871-f6e2-480b-bb64-6d2f436ffa6f	2025-06-11 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.244+00	2026-01-14 00:41:10.244+00	t	Importada de JSONL. Empresa: GLACIAR PESQUERA. Especie: VIERA	MC	30
7b5ef1bd-4eb4-489c-976b-477525f660a5	2025	94	28951b47-241f-46bb-9aa3-97f42bd51686	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-06-09 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.249+00	2026-01-14 00:41:10.249+00	t	Importada de JSONL. Empresa: ARPES. Especie: MERLUZA	MC	30
5ae0c35c-5c3b-4fae-b112-b5ae6d8217eb	2025	95	face2a5f-184c-41f8-b3a8-9beebc3635ee	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-06-06 03:00:00+00	\N	\N	1	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.263+00	2026-01-14 00:41:10.263+00	t	Importada de JSONL. Empresa: GIORNO. Especie: MERLUZA	MC	30
019284e5-0c48-42be-ae75-5706530352fd	2025	96	c6c6fcdc-e445-4e60-8a3f-a70b8e33aab7	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-06-06 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.27+00	2026-01-14 00:41:10.27+00	t	Importada de JSONL. Empresa: GIORNO. Especie: MERLUZA	MC	30
a81a062c-885f-4c3e-9169-e19436645419	2025	97	887ff179-0c25-4956-9165-09125f9152f0	\N	2ea71871-f6e2-480b-bb64-6d2f436ffa6f	2025-06-17 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.278+00	2026-01-14 00:41:10.278+00	t	Importada de JSONL. Empresa: ROMFIOC S.R.L. Especie: MERLUZA	MC	30
07d31e6d-26f8-42db-a71d-f2ba8f440b76	2025	98	04b53087-52e8-4656-be93-714c343c47d6	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-06-17 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.283+00	2026-01-14 00:41:10.283+00	t	Importada de JSONL. Empresa: ESTREMAR. Especie: MERLUZA AUSTRAL	MC	30
924f4e58-334a-4279-8770-9fb785bd3daa	2025	99	1f6cbb5f-d134-4ee3-9315-bf24ae2a7946	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-06-12 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.29+00	2026-01-14 00:41:10.29+00	t	Importada de JSONL. Empresa: BUENA PROA. Especie: MERLUZA	MC	30
0710af5c-cc4e-48c2-a163-f244db38a34f	2025	100	4a837a56-b513-4568-b2d7-61bc1d66d22b	\N	2ea71871-f6e2-480b-bb64-6d2f436ffa6f	2025-06-17 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.306+00	2026-01-14 00:41:10.306+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: VIERA	MC	30
d776c633-7d6a-41a8-b83c-5996b880b452	2025	101	d90139c7-b316-4228-8bea-b47432cf51e2	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-06-18 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.311+00	2026-01-14 00:41:10.311+00	t	Importada de JSONL. Empresa: BUENA PROA. Especie: P. LANGOSTINO	MC	30
8c1b9863-f3de-4725-8100-d31306ab7a9f	2025	102	c1fb290e-10a9-4cef-9075-929f585122f3	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-06-17 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.321+00	2026-01-14 00:41:10.321+00	t	Importada de JSONL. Empresa: PESCARGEN. Especie: P. LANGOSTINO	MC	30
1797ca1f-77e5-46cf-bb03-f54cf2656699	2025	103	eebc3d53-9595-43b6-9c09-b24c1202fd35	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-06-17 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.33+00	2026-01-14 00:41:10.33+00	t	Importada de JSONL. Empresa: FRIGORÍFICO DON LUIS. Especie: P. LANGOSTINO	MC	30
cc5da30e-92da-4a31-a6a9-367f12538f5d	2025	104	0e2a5c62-db26-40fc-b1b1-13f426e36388	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-06-18 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.338+00	2026-01-14 00:41:10.338+00	t	Importada de JSONL. Empresa: URLIPEZ. Especie: P. LANGOSTINO	MC	30
54116fc8-0376-4e98-8e06-51d69391c0db	2025	105	83fb4a61-ef1b-4b26-acf5-80204da01607	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-06-19 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.346+00	2026-01-14 00:41:10.346+00	t	Importada de JSONL. Empresa: DE ANGELIS Y LOGGHE. Especie: P. LANGOSTINO	MC	30
35f620eb-aae7-4b01-9a49-83de0709e695	2025	106	e23b91fc-22bf-4cbc-8dcd-778a8ca8f574	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-06-17 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.353+00	2026-01-14 00:41:10.353+00	t	Importada de JSONL. Empresa: PESCA ANTIGUA. Especie: P. LANGOSTINO	MC	30
3f8caf63-2609-461b-b823-c0b1f4cf062e	2025	107	34a96d23-cf3a-4eea-b136-56b64fa5239c	\N	2ea71871-f6e2-480b-bb64-6d2f436ffa6f	2025-06-21 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.362+00	2026-01-14 00:41:10.362+00	t	Importada de JSONL. Empresa: IBERCONSA. Especie: MERLUZA	MC	30
affe4a6b-5ae3-4188-b88b-82cb7d46e835	2025	108	cad32064-7964-4a41-9f30-a1998363ab99	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-06-24 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.366+00	2026-01-14 00:41:10.366+00	t	Importada de JSONL. Empresa: SOLIMENO E HIJOS. Especie: MERLUZA	MC	30
fa57c969-9c6b-4101-850c-ae5fae7b81e3	2025	109	2df50464-9916-4b3e-b5c3-3a645623d525	\N	2ea71871-f6e2-480b-bb64-6d2f436ffa6f	2025-06-23 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.38+00	2026-01-14 00:41:10.38+00	t	Importada de JSONL. Empresa: GLACIAR PESQUERA. Especie: VIERA	MC	30
de7f7699-c09a-4cf4-bceb-3c8fa0eef107	2025	110	eebc3d53-9595-43b6-9c09-b24c1202fd35	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-06-27 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.384+00	2026-01-14 00:41:10.384+00	t	Importada de JSONL. Empresa: FRIGORÍFICO DON LUIS. Especie: P. LANGOSTINO	MC	30
75b8e60b-8e72-4110-a02a-4a9c89d3247a	2025	111	83fb4a61-ef1b-4b26-acf5-80204da01607	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-06-27 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.391+00	2026-01-14 00:41:10.391+00	t	Importada de JSONL. Empresa: DE ANGELIS Y LOGGHE. Especie: P. LANGOSTINO	MC	30
8efb8972-ce3d-4cab-9bdd-74404194c448	2025	112	b422b4ce-70c9-4b52-aa4f-15ccf351575a	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-06-27 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.402+00	2026-01-14 00:41:10.402+00	t	Importada de JSONL. Empresa: CANAL DE BEAGLE. Especie: P. LANGOSTINO	MC	30
1b88cb74-d1ee-4175-82bd-133e4851a9c0	2025	113	7a5c52c3-f87e-4405-a08e-f3b2ae274460	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-07-01 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.411+00	2026-01-14 00:41:10.411+00	t	Importada de JSONL. Empresa: PESQUERA VERAZ. Especie: MERLUZA	MC	30
b044574d-b57e-4aee-84f9-52dd22d71c02	2025	114	2df50464-9916-4b3e-b5c3-3a645623d525	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-07-10 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.424+00	2026-01-14 00:41:10.424+00	t	Importada de JSONL. Empresa: GLACIAR PESQUERA. Especie: VIERA	MC	30
d3ca30c5-22be-4532-a93f-f238a35e605e	2025	115	4a837a56-b513-4568-b2d7-61bc1d66d22b	\N	2ea71871-f6e2-480b-bb64-6d2f436ffa6f	2025-07-08 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.432+00	2026-01-14 00:41:10.432+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: VIERA	MC	30
8b387d1b-5ce1-4ef9-bdc7-40c0dee441b0	2025	116	0ddb5663-8ab9-4ad5-ab76-fb98b2e5d15d	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-07-15 03:00:00+00	\N	\N	3	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.437+00	2026-01-14 00:41:10.437+00	t	Importada de JSONL. Empresa: GLACIAR PESQUERA. Especie: VIERA	MC	30
530ef634-901c-438f-a0f5-4f52cab7a969	2025	117	c1fb290e-10a9-4cef-9075-929f585122f3	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-07-11 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.444+00	2026-01-14 00:41:10.444+00	t	Importada de JSONL. Empresa: PESCARGEN. Especie: LANGOSTINO	MC	30
f2d0a1d7-4867-4b46-befe-e7aca3ef945b	2025	118	8b82f567-6be0-4696-b40d-a587b3ed4e22	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-07-11 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.451+00	2026-01-14 00:41:10.451+00	t	Importada de JSONL. Empresa: BUENA PROA. Especie: LANGOSTINO	MC	30
e27c7ba0-3f80-49f0-b52e-2c79c199401b	2025	119	129a7390-74a6-453e-896e-309f65fed7c8	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-07-12 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.459+00	2026-01-14 00:41:10.459+00	t	Importada de JSONL. Empresa: IBERCONSA. Especie: MERLUZA	MC	30
89d9e3b6-9a07-4613-bb96-1e92fe8374e9	2025	120	af23e539-baa2-4cdd-9c30-b3126af01ce0	\N	2ea71871-f6e2-480b-bb64-6d2f436ffa6f	2025-07-11 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.467+00	2026-01-14 00:41:10.467+00	t	Importada de JSONL. Empresa: RITONDO SALLUSTIO Y CICCIOTTI. Especie: LANGOSTINO	MC	30
e2c1a54c-7a35-4aa2-b615-386313d039c5	2025	121	73c502e2-397a-499f-b4f7-cb8dce8260b7	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-07-15 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.471+00	2026-01-14 00:41:10.471+00	t	Importada de JSONL. Empresa: MOSCUZZA. Especie: LANGOSTINO	MC	30
f97ca208-0509-49cf-acef-922455403fe3	2025	122	5fa98bd7-f095-4d3e-8e98-7761568ec108	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-07-16 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.485+00	2026-01-14 00:41:10.485+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: VIEIRA	MC	30
132c8654-f29d-436e-bdca-a6bfaee87c37	2025	123	c6c6fcdc-e445-4e60-8a3f-a70b8e33aab7	\N	2ea71871-f6e2-480b-bb64-6d2f436ffa6f	2025-07-19 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.492+00	2026-01-14 00:41:10.492+00	t	Importada de JSONL. Empresa: GIORNO S.A. Especie: MERLUZA	MC	30
a0aeb842-95d6-413d-9ccd-8f67cbc51b38	2025	124	face2a5f-184c-41f8-b3a8-9beebc3635ee	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-07-19 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.497+00	2026-01-14 00:41:10.497+00	t	Importada de JSONL. Empresa: GIORNO S.A. Especie: MERLUZA	MC	30
ca0004a4-1eb0-406e-b534-6bed5fc1f656	2025	125	66098466-a6dd-4982-8347-335fe023e588	\N	2ea71871-f6e2-480b-bb64-6d2f436ffa6f	2025-07-18 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.507+00	2026-01-14 00:41:10.507+00	t	Importada de JSONL. Empresa: CONARPESA. Especie: LANGOSTINO	MC	30
a9725964-cd70-4286-8b86-cc50e89f307d	2025	126	1f6cbb5f-d134-4ee3-9315-bf24ae2a7946	\N	2ea71871-f6e2-480b-bb64-6d2f436ffa6f	2025-07-18 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.511+00	2026-01-14 00:41:10.511+00	t	Importada de JSONL. Empresa: BUENA PROA. Especie: LANGOSTINO	MC	30
5c2caebd-9c90-4a7d-83a3-91cfdd69b246	2025	127	603c1c20-9b81-44a9-a414-a31724275500	\N	2ea71871-f6e2-480b-bb64-6d2f436ffa6f	2025-07-18 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.516+00	2026-01-14 00:41:10.516+00	t	Importada de JSONL. Empresa: CONARPESA. Especie: LANGOSTINO	MC	30
2bde3e6b-fcb6-43ef-a637-7f1e075ae3b7	2025	128	71ac58df-bb35-4d50-902c-4b8805d03488	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-07-18 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.521+00	2026-01-14 00:41:10.521+00	t	Importada de JSONL. Empresa: PEDRO MOSCUZZA E HIJO. Especie: MERLUZA	MC	30
abb71f7e-66c2-4fad-a06c-023f67a1485f	2025	129	a1b563e1-607a-4532-8d14-0ecc7ee1fe20	\N	97219917-fdf2-4aca-b415-96de17cc505e	2025-07-21 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.528+00	2026-01-14 00:41:10.528+00	t	Importada de JSONL. Empresa: PEDRO MOSCUZZA E HIJO. Especie: LANGOSTINO	MC	30
0a2ca322-9c41-4c85-8f5f-0f9cda6e6230	2025	130	34a96d23-cf3a-4eea-b136-56b64fa5239c	\N	2ea71871-f6e2-480b-bb64-6d2f436ffa6f	2025-07-22 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.536+00	2026-01-14 00:41:10.536+00	t	Importada de JSONL. Empresa: IBERCONSA. Especie: LANGOSTINO	MC	30
c5c2f85f-a0ac-45c9-bd6d-9d93eef21ede	2025	131	d5d6734f-6104-4cca-acdb-e222f8e0978c	\N	2ea71871-f6e2-480b-bb64-6d2f436ffa6f	2025-07-22 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.54+00	2026-01-14 00:41:10.54+00	t	Importada de JSONL. Empresa: EMPESUR. Especie: LANGOSTINO	MC	30
8f6e1c1b-d8be-491e-82e1-1ced1843b47a	2025	132	32e93528-46a4-40d8-8576-89d228fa5dda	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-07-23 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.546+00	2026-01-14 00:41:10.546+00	t	Importada de JSONL. Empresa: BUENOS AIRES PESCA S.A. Especie: LANGOSTINO	MC	30
b935a58b-d0c4-4d60-9acd-7ed83c647978	2025	133	64782920-6598-4760-ba21-7ead251ff1e1	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-07-23 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.553+00	2026-01-14 00:41:10.553+00	t	Importada de JSONL. Empresa: BUENOS AIRES PESCA S.A. Especie: LANGOSTINO	MC	30
73edad49-21e4-4680-b848-8cc046436440	2025	134	1f6cbb5f-d134-4ee3-9315-bf24ae2a7946	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-07-25 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.561+00	2026-01-14 00:41:10.561+00	t	Importada de JSONL. Empresa: BUENA PROA. Especie: LANGOSTINO	MC	30
a670a10e-b396-43cf-9e4f-da854c216802	2025	135	28951b47-241f-46bb-9aa3-97f42bd51686	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-07-27 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.567+00	2026-01-14 00:41:10.567+00	t	Importada de JSONL. Empresa: ARPES. Especie: MERLUZA	MC	30
65604077-1344-40c8-8aa5-530a80524667	2025	136	7d23c84f-115a-4318-9e29-aa24a4809280	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-07-28 03:00:00+00	\N	\N	42	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.578+00	2026-01-14 00:41:10.578+00	t	Importada de JSONL. Empresa: CRUSTACEOS DEL SUR S.A. Especie: CENTOLLA	MC	60
7c0f420c-18e3-4c11-a8ee-688eaba8c013	2025	137	ac67da65-198f-43a9-b853-eea2da891505	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-07-29 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.585+00	2026-01-14 00:41:10.585+00	t	Importada de JSONL. Empresa: CENTOMAR S.A. Especie: LANGOSTINO	MC	30
c54a944e-148b-4d71-9003-cf1a602eea67	2025	138	dd7184b3-9ccd-4515-a117-02184abda5ff	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-08-04 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.591+00	2026-01-14 00:41:10.591+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: LANGOSTINO	MC	30
bc922ab1-8a89-4fbd-8ff0-b92cb23f7ee3	2025	139	8b82f567-6be0-4696-b40d-a587b3ed4e22	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-08-02 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.602+00	2026-01-14 00:41:10.602+00	t	Importada de JSONL. Empresa: BUENA PROA. Especie: LANGOSTINO	MC	30
971cd500-4f71-46d7-9b36-5cd570dd538e	2025	140	d744066d-a334-4b07-93d0-c5017a925720	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-08-05 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.609+00	2026-01-14 00:41:10.609+00	t	Importada de JSONL. Empresa: ARBUMASA S.A. Especie: LANGOSTINO	MC	30
a1964669-a378-41ef-a0ce-2da11a1fb8a8	2025	141	03bf8fc0-df37-48c1-bf28-22df463a42ff	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-08-05 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.616+00	2026-01-14 00:41:10.616+00	t	Importada de JSONL. Empresa: ARBUMASA S.A. Especie: LANGOSTINO	MC	30
d3cd4728-744f-438e-8ec7-cc2f2dc6571e	2025	142	649e5ded-9a48-4bf8-aaa1-2edf147fe587	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-08-06 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.624+00	2026-01-14 00:41:10.624+00	t	Importada de JSONL. Empresa: SOLIMENO E HIJOS. Especie: MERLUZA	MC	30
2807c518-ee18-46b9-be03-54ee4d5ed4f9	2025	143	844026fe-c6be-4b40-b4f4-4758a4437c2d	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-08-07 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.638+00	2026-01-14 00:41:10.638+00	t	Importada de JSONL. Empresa: PEDRO MOSCUZZA E HIJO. Especie: LANGOSTINO	MC	30
d9f9aaf9-d19d-4317-8719-29ae41e9cd59	2025	144	bf9011e3-436b-477e-adc9-5fdf755c9b63	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-08-07 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.646+00	2026-01-14 00:41:10.646+00	t	Importada de JSONL. Empresa: PEDRO MOSCUZZA E HIJO. Especie: LANGOSTINO	MC	30
b178ba43-a1c2-4518-9734-e042d4790fce	2025	145	d7cc59c9-d446-4271-b0cf-9df6242b41fd	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-08-12 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.653+00	2026-01-14 00:41:10.653+00	t	Importada de JSONL. Empresa: ANTONIO BALDINO E HIJOS. Especie: MERLUZA	MC	30
0d9d50b5-0b9b-459c-91bc-1830f753b625	2025	146	3f5729dd-4d20-4e27-a7f1-ef46d30e973d	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-08-14 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.668+00	2026-01-14 00:41:10.668+00	t	Importada de JSONL. Empresa: MARONTI  S.A.. Especie: MERLUZA	MC	30
0f59cfcd-2244-4399-a8ef-14c52bffef07	2025	147	face2a5f-184c-41f8-b3a8-9beebc3635ee	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-08-19 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.68+00	2026-01-14 00:41:10.68+00	t	Importada de JSONL. Empresa: GIORNO S.A. Especie: MERLUZA	MC	30
40e14f88-15d9-43e3-aaa1-a0cb6c1479d5	2025	148	87fc1c47-b658-4994-beae-d69e1eedead4	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-08-18 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.687+00	2026-01-14 00:41:10.687+00	t	Importada de JSONL. Empresa: XEITOSIÑO. Especie: LANGOSTINO	MC	30
92f748e6-da70-4fd1-894d-89134404ab5a	2025	149	0956ea0a-4aa0-4aa0-a2ac-72e3732ff025	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-08-19 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.694+00	2026-01-14 00:41:10.694+00	t	Importada de JSONL. Empresa: XEITOSIÑO. Especie: LANGOSTINO	MC	30
0ad77221-e2c0-4c45-a650-6a0bc4154eb4	2025	150	7520156b-6cda-40e7-a4c4-69d870022e74	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-08-25 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.701+00	2026-01-14 00:41:10.701+00	t	Importada de JSONL. Empresa: CONARPESA. Especie: LANGOSTINO	MC	30
de64d728-4a6c-4b29-a242-4165b7338f2d	2025	151	b88d3a8d-a83a-4a6b-a566-85bf97fb3fb7	\N	2ea71871-f6e2-480b-bb64-6d2f436ffa6f	2025-08-29 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.707+00	2026-01-14 00:41:10.707+00	t	Importada de JSONL. Empresa: GIORNO. Especie: LANGOSTINO	MC	30
a07196ce-0524-4b05-b36d-04450033c584	2025	152	37fb0bff-71cf-474c-ac99-dfe32eb068d3	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-08-29 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.712+00	2026-01-14 00:41:10.712+00	t	Importada de JSONL. Empresa: PESQUERA VERAZ SA. Especie: LANGOSTINO	MC	30
4aeeeb58-99d3-490a-8434-be89120f4762	2025	153	71ac58df-bb35-4d50-902c-4b8805d03488	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-08-30 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.72+00	2026-01-14 00:41:10.72+00	t	Importada de JSONL. Empresa: PEDRO MOSCUZZA E HIJO. Especie: MERLUZA	MC	30
fbaf8efe-0c9a-4b2d-8b80-ca8a7f3a1f15	2025	154	79b204c7-5ff4-42e9-a7de-de8ea34d8555	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-09-05 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.727+00	2026-01-14 00:41:10.727+00	t	Importada de JSONL. Empresa: ARGENOVA S.A. Especie: LANGOSTINO	MC	30
3c2cce97-783f-4d0c-a9f9-fb9b8d7b2d17	2025	155	5fa98bd7-f095-4d3e-8e98-7761568ec108	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-09-08 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.735+00	2026-01-14 00:41:10.735+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: VIEIRA	MC	30
b7434a04-3b64-4168-80b6-2e3b7a9f8675	2025	156	7d23c84f-115a-4318-9e29-aa24a4809280	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-09-11 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.742+00	2026-01-14 00:41:10.742+00	t	Importada de JSONL. Empresa: CRUSTACEOS DEL SUR S.A. Especie: CENTOLLA	MC	30
cc24d84d-ba71-40b9-8151-92323119d482	2025	157	9feec5a5-4b57-4bd9-98ed-770ea7509a63	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-09-10 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.749+00	2026-01-14 00:41:10.749+00	t	Importada de JSONL. Empresa: PESCASOL S.A. Especie: MERLUZA	MC	30
64504245-b7b7-4e92-80ad-cfdb7d18e83b	2025	158	03bf8fc0-df37-48c1-bf28-22df463a42ff	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-09-13 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.756+00	2026-01-14 00:41:10.756+00	t	Importada de JSONL. Empresa: ARBUMASA S.A. Especie: LANGOSTINO	MC	30
08476a6d-7120-4f53-b222-7958aa0ff895	2025	159	a16cce31-d12d-458a-b212-6846185933bf	\N	e1582fe4-d48e-46fb-b156-7f7aaf3f9983	2025-09-11 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.764+00	2026-01-14 00:41:10.764+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: CENTOLLA	MC	30
63a550cb-4b46-4392-aa6b-daf68171a61a	2025	160	196d90c9-4a16-4fac-98ca-948f955d17d2	\N	e1582fe4-d48e-46fb-b156-7f7aaf3f9983	2025-09-11 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.771+00	2026-01-14 00:41:10.771+00	t	Importada de JSONL. Empresa: CENTOMAR S.A. Especie: CENTOLLA	MC	30
7e201eae-7c97-485c-9670-915d228402e3	2025	161	49144ac0-7330-40cf-8ed7-3dd909542a0e	\N	45672467-a4db-462d-8228-2a21ce82cc37	2025-09-11 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.778+00	2026-01-14 00:41:10.778+00	t	Importada de JSONL. Empresa: BENTONICOS DE ARGENTINA. Especie: CENTOLLA	MC	30
26138cad-87d4-482f-9e82-3a5b24e0c2c8	2025	162	adc23180-9487-47ad-9e3d-62eade83623a	\N	45672467-a4db-462d-8228-2a21ce82cc37	2025-09-11 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.786+00	2026-01-14 00:41:10.786+00	t	Importada de JSONL. Empresa: BENTONICOS DE ARGENTINA. Especie: CENTOLLA	MC	30
54cef98c-4772-40b4-9f04-80a878694497	2025	163	69ff7a7d-9417-4f5c-9693-8e2835fef39b	\N	e1582fe4-d48e-46fb-b156-7f7aaf3f9983	2025-09-17 03:00:00+00	\N	\N	61	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.795+00	2026-01-14 00:41:10.795+00	t	Importada de JSONL. Empresa: PESANTAR. Especie: MERLUZA AUSTRAL	MC	30
d6df112f-d895-4076-89b7-b17f522b77c1	2025	164	0956ea0a-4aa0-4aa0-a2ac-72e3732ff025	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-09-19 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.804+00	2026-01-14 00:41:10.804+00	t	Importada de JSONL. Empresa: XEITOSIÑO. Especie: LANGOSTINO	MC	30
911f04d3-2611-418a-ab6c-85273c1c54f4	2025	165	04b53087-52e8-4656-be93-714c343c47d6	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-09-29 03:00:00+00	\N	\N	31	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.812+00	2026-01-14 00:41:10.812+00	t	Importada de JSONL. Empresa: ESTREMAR. Especie: MERLUZA AUSTRAL	MC	30
dccb9d7c-b9d8-4f58-9269-ec88c8221976	2025	166	863ff4de-02ab-477a-b726-83d3e9148648	\N	e1582fe4-d48e-46fb-b156-7f7aaf3f9983	2025-09-29 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.818+00	2026-01-14 00:41:10.818+00	t	Importada de JSONL. Empresa: ARGENOVA. Especie: MERLUZA AUSTRAL	MC	30
d8a1275d-9257-41a4-ae2b-b82d52c3b637	2025	167	7a5c52c3-f87e-4405-a08e-f3b2ae274460	\N	e1582fe4-d48e-46fb-b156-7f7aaf3f9983	2025-09-26 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.825+00	2026-01-14 00:41:10.825+00	t	Importada de JSONL. Empresa: PESQUERA VERAZ S.A. Especie: MERLUZA	MC	30
5676b02b-3aa8-4744-a6a1-9d16eaec0a3f	2025	168	71ac58df-bb35-4d50-902c-4b8805d03488	\N	e1582fe4-d48e-46fb-b156-7f7aaf3f9983	2025-10-14 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.842+00	2026-01-14 00:41:10.842+00	t	Importada de JSONL. Empresa: PEDRO MOSCUZZA E HIJO. Especie: MERLUZA	MC	30
80616398-f6b9-4201-b08d-b39d5eb67ca4	2025	169	e70330eb-bcaf-472c-9906-1096de4235dd	\N	45672467-a4db-462d-8228-2a21ce82cc37	2025-10-12 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.848+00	2026-01-14 00:41:10.848+00	t	Importada de JSONL. Empresa: CRUSTACEOS DEL SUR S.A. Especie: CENTOLLA	MC	60
deb918b8-73e6-4c2d-9cd7-1e614d2e048e	2025	170	1f6cbb5f-d134-4ee3-9315-bf24ae2a7946	\N	e1582fe4-d48e-46fb-b156-7f7aaf3f9983	2025-10-18 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.856+00	2026-01-14 00:41:10.856+00	t	Importada de JSONL. Empresa: BUENA PROA. Especie: MERLUZA	MC	30
840d1c7b-9747-4b06-b53b-697e644a53ea	2025	171	0ddb5663-8ab9-4ad5-ab76-fb98b2e5d15d	\N	45672467-a4db-462d-8228-2a21ce82cc37	2025-10-30 03:00:00+00	\N	\N	6	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.867+00	2026-01-14 00:41:10.867+00	t	Importada de JSONL. Empresa: GLACIAR PESQUERA. Especie: VIEIRA	MC	60
fec0ddd6-f0b4-40ae-bf31-03d15f45241b	2025	172	7d23c84f-115a-4318-9e29-aa24a4809280	\N	e1582fe4-d48e-46fb-b156-7f7aaf3f9983	2025-10-23 03:00:00+00	\N	\N	30	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.873+00	2026-01-14 00:41:10.873+00	t	Importada de JSONL. Empresa: CRUSTACEOS DEL SUR S.A. Especie: CENTOLLA	MC	30
2dcf9357-bd8b-4020-9594-c42604b0ea0a	2025	173	04b53087-52e8-4656-be93-714c343c47d6	\N	e1582fe4-d48e-46fb-b156-7f7aaf3f9983	2025-09-29 03:00:00+00	\N	\N	22	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.88+00	2026-01-14 00:41:10.88+00	t	Importada de JSONL. Empresa: ESTREMAR. Especie: MERLUZA AUSTRAL	MC	30
12b7645b-a848-44ac-a2c7-f47f748f1cc6	2025	174	5fa98bd7-f095-4d3e-8e98-7761568ec108	\N	45672467-a4db-462d-8228-2a21ce82cc37	2025-10-27 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.887+00	2026-01-14 00:41:10.887+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: VIEIRA	MC	30
70ec1fd8-6559-4e17-850f-dfbffe164b2b	2025	175	cad32064-7964-4a41-9f30-a1998363ab99	\N	45672467-a4db-462d-8228-2a21ce82cc37	2025-10-31 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.894+00	2026-01-14 00:41:10.894+00	t	Importada de JSONL. Empresa: SOLIMENO e HIJOS S.A. Especie: MERLUZA	MC	30
42c2367a-8542-4763-9f89-02780bbeea8e	2025	176	d7cc59c9-d446-4271-b0cf-9df6242b41fd	\N	e1582fe4-d48e-46fb-b156-7f7aaf3f9983	2025-11-01 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.907+00	2026-01-14 00:41:10.907+00	t	Importada de JSONL. Empresa: ROTELLO S.A. Especie: MERLUZA	MC	30
dd030597-448a-41db-b591-608b47597a5e	2025	177	28951b47-241f-46bb-9aa3-97f42bd51686	\N	45672467-a4db-462d-8228-2a21ce82cc37	2025-11-03 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.915+00	2026-01-14 00:41:10.915+00	t	Importada de JSONL. Empresa: ARPES S.A. Especie: MERLUZA	MC	30
e1421d6b-6654-4314-b373-0c7aef292054	2025	178	196d90c9-4a16-4fac-98ca-948f955d17d2	\N	45672467-a4db-462d-8228-2a21ce82cc37	2025-11-06 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.928+00	2026-01-14 00:41:10.928+00	t	Importada de JSONL. Empresa: CENTOMAR S.A. Especie: CENTOLLA	MC	30
89a552ad-3649-45e6-9e48-9029a4629763	2025	179	366e3631-c4fe-4001-960d-c816b3a08a1c	\N	e1582fe4-d48e-46fb-b156-7f7aaf3f9983	2025-11-04 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.942+00	2026-01-14 00:41:10.942+00	t	Importada de JSONL. Empresa: AIRE MARINO. Especie: ANCHOÍTA	MC	30
ecfe7292-b255-4865-bb32-5949e22b7802	2025	180	a16cce31-d12d-458a-b212-6846185933bf	\N	45672467-a4db-462d-8228-2a21ce82cc37	2025-11-10 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.949+00	2026-01-14 00:41:10.949+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: CENTOLLA	MC	30
18873c09-e4fc-493b-b80b-ec01ae1eb66e	2025	181	4a837a56-b513-4568-b2d7-61bc1d66d22b	\N	45672467-a4db-462d-8228-2a21ce82cc37	2025-11-10 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.956+00	2026-01-14 00:41:10.956+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: VIEIRA	MC	30
1d3796e9-5936-4785-9a48-2b5ecb48a7be	2025	182	69ff7a7d-9417-4f5c-9693-8e2835fef39b	\N	97219917-fdf2-4aca-b415-96de17cc505e	2025-11-20 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.964+00	2026-01-14 00:41:10.964+00	t	Importada de JSONL. Empresa: PESANTAR. Especie: MERLUZA AUSTRAL	MC	30
fc13e177-c80d-4b35-98ed-bdfb707663cc	2025	183	7d23c84f-115a-4318-9e29-aa24a4809280	\N	97219917-fdf2-4aca-b415-96de17cc505e	2025-11-20 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.972+00	2026-01-14 00:41:10.972+00	t	Importada de JSONL. Empresa: CRUSTACEOS DEL SUR S.A. Especie: CENTOLLA	MC	30
c7504351-7144-4384-bd61-a5968f0bfe57	2025	184	f0cfd06a-b006-4dc5-ada1-3a7e9ba760ad	\N	97219917-fdf2-4aca-b415-96de17cc505e	2025-11-26 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.979+00	2026-01-14 00:41:10.979+00	t	Importada de JSONL. Empresa: PRODESUR. Especie: MERLUZA AUSTRAL	MC	60
68d4e4c7-151f-4a33-a2d6-a1a2ac165e9f	2025	185	7a5c52c3-f87e-4405-a08e-f3b2ae274460	\N	45672467-a4db-462d-8228-2a21ce82cc37	2025-12-01 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.986+00	2026-01-14 00:41:10.986+00	t	Importada de JSONL. Empresa: PESQUERA VERAZ S.A. Especie: MERLUZA	MC	30
a5e4657e-38f5-4130-a6ef-08d685fbddad	2025	187	5fa98bd7-f095-4d3e-8e98-7761568ec108	\N	97219917-fdf2-4aca-b415-96de17cc505e	2025-12-15 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:11.001+00	2026-01-14 00:41:11.001+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: VIEIRA	MC	30
47bc925f-8a76-467f-8a92-30b22cf33c75	2025	188	04b53087-52e8-4656-be93-714c343c47d6	\N	3af8b7d1-f41d-4029-83ae-ef5e178ff565	2025-12-29 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:11.009+00	2026-01-14 00:41:11.009+00	t	Importada de JSONL. Empresa: ESTREMAR S.A. Especie: MERLUZA AUSTRAL	MC	30
1499b680-ec86-4123-8e28-0bead9519301	2025	189	82d93396-176a-4d74-a5de-5addaf47520f	\N	3af8b7d1-f41d-4029-83ae-ef5e178ff565	2025-12-26 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:11.016+00	2026-01-14 00:41:11.016+00	t	Importada de JSONL. Empresa: CHIARPESCA. Especie: CALAMAR	MC	30
841c4ec4-edbf-4b07-8063-2e84f2680fff	2025	190	3c111b3e-1c42-49b4-b579-168516f1dc1f	\N	3af8b7d1-f41d-4029-83ae-ef5e178ff565	2025-12-29 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:11.023+00	2026-01-14 00:41:11.023+00	t	Importada de JSONL. Empresa: ARGENOVA. Especie: CALAMAR	MC	30
6a925c67-2c02-43e9-9496-fd3975160424	2025	191	ba0b91e3-29d6-4028-acb8-c8256fa2aaf8	\N	3af8b7d1-f41d-4029-83ae-ef5e178ff565	2025-12-29 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:11.031+00	2026-01-14 00:41:11.031+00	t	Importada de JSONL. Empresa: ALTAMARE S.AS. Especie: CALAMAR	MC	30
abde28b8-9542-4be9-8694-da80f5e0b196	2025	192	8fbf968b-b9aa-4316-ac14-c65ecb2bc56b	\N	3af8b7d1-f41d-4029-83ae-ef5e178ff565	2025-12-26 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:11.038+00	2026-01-14 00:41:11.038+00	t	Importada de JSONL. Empresa: PESQUERÍA  RÍO QUEQUEN. Especie: CALAMAR	MC	30
32942ae8-dac2-4d9e-8ef2-3ffe43237c17	2025	193	4c346349-604d-4835-9682-3f7ab65c240d	\N	3af8b7d1-f41d-4029-83ae-ef5e178ff565	2025-12-26 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:11.048+00	2026-01-14 00:41:11.048+00	t	Importada de JSONL. Empresa: PESQUERÍA  RÍO QUEQUEN. Especie: CALAMAR	MC	30
7d5358c9-5ca9-4d3d-a59a-e2363c9f6d8d	2025	194	196d90c9-4a16-4fac-98ca-948f955d17d2	\N	3af8b7d1-f41d-4029-83ae-ef5e178ff565	2025-12-26 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:11.059+00	2026-01-14 00:41:11.059+00	t	Importada de JSONL. Empresa: CENTOMAR S.A. Especie: CENTOLLA	MC	30
6d1f181a-37a4-40a6-83fb-4a4ad95c332e	2025	195	e70330eb-bcaf-472c-9906-1096de4235dd	\N	3af8b7d1-f41d-4029-83ae-ef5e178ff565	2025-12-30 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:11.066+00	2026-01-14 00:41:11.066+00	t	Importada de JSONL. Empresa: CRUSTACEOS DEL SUR S.A. Especie: CENTOLLA	MC	30
d0080183-5a28-4940-8b62-d0916fb6ea45	2025	196	49144ac0-7330-40cf-8ed7-3dd909542a0e	\N	97219917-fdf2-4aca-b415-96de17cc505e	2025-12-23 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:11.073+00	2026-01-14 00:41:11.073+00	t	Importada de JSONL. Empresa: BENTONICOS DE ARGENTINA. Especie: CENTOLLA	MC	30
de4b51fc-abf4-4fa4-b1bc-027e6d33908c	2025	197	adc23180-9487-47ad-9e3d-62eade83623a	\N	3af8b7d1-f41d-4029-83ae-ef5e178ff565	2025-12-30 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:11.08+00	2026-01-14 00:41:11.08+00	t	Importada de JSONL. Empresa: BENTONICOS DE ARGENTINA. Especie: CENTOLLA	MC	30
239c4c23-fbcd-43fd-88d5-02c4d4601349	2025	198	12964f37-2ef3-4932-9d34-b7ec4410c90b	\N	3af8b7d1-f41d-4029-83ae-ef5e178ff565	2025-12-29 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:11.087+00	2026-01-14 00:41:11.087+00	t	Importada de JSONL. Empresa: GIORNO. Especie: CALAMAR	MC	30
f091515a-3a09-4d2d-aaad-839f884a6ec5	2025	199	2df50464-9916-4b3e-b5c3-3a645623d525	\N	3af8b7d1-f41d-4029-83ae-ef5e178ff565	2025-12-26 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:11.094+00	2026-01-14 00:41:11.094+00	t	Importada de JSONL. Empresa: GLACIAR PESQUERA. Especie: VIEIRA	MC	30
e6685824-1f78-44d1-a67e-61b80de14ac0	2025	200	43ed857e-e69f-467e-a977-3590327e0708	\N	3af8b7d1-f41d-4029-83ae-ef5e178ff565	2025-12-28 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:11.1+00	2026-01-14 00:41:11.1+00	t	Importada de JSONL. Empresa: LUIS SOLIMENO. Especie: CALAMAR	MC	30
99da2fe8-8c72-4174-a1f5-26e38069ba49	2025	201	83a5f4d8-12bb-48e4-8b31-6fda9cd9eb5f	\N	3af8b7d1-f41d-4029-83ae-ef5e178ff565	2025-12-28 03:00:00+00	\N	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:11.107+00	2026-01-14 00:41:11.107+00	t	Importada de JSONL. Empresa: PESQUERA COMERCIAL. Especie: CALAMAR	MC	30
d06453ee-c376-4333-986f-e02f13988014	2025	186	0ddb5663-8ab9-4ad5-ab76-fb98b2e5d15d	\N	97219917-fdf2-4aca-b415-96de17cc505e	2025-12-15 03:00:00+00	2025-12-15 03:00:00+00	\N	\N	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:10.993+00	2026-01-14 21:47:52.416+00	t	Importada de JSONL. Empresa: GLACIAR PESQUERA. Especie: VIEIRA	MC	30
2ffe1eb4-87db-49fc-bba7-f89f742be443	2025	1	04b53087-52e8-4656-be93-714c343c47d6	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-01-03 03:00:00+00	\N	\N	32	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:09.356+00	2026-01-14 00:41:09.356+00	t	Importada de JSONL. Empresa: ESTREMAR. Especie: MERLUZA AUSTRAL	MC	60
88d8de1d-3229-4290-bd9b-8bac988cb4ae	2025	2	863ff4de-02ab-477a-b726-83d3e9148648	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-01-03 03:00:00+00	\N	\N	23	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:09.387+00	2026-01-14 00:41:09.387+00	t	Importada de JSONL. Empresa: ARGENOVA. Especie: MERLUZA AUSTRAL	MC	60
855ed6f3-5a13-41d4-a6b3-bf85b2fd720f	2025	3	a16cce31-d12d-458a-b212-6846185933bf	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-01-03 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:09.398+00	2026-01-14 00:41:09.398+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: CENTOLLA	MC	30
1009a963-f453-4721-8488-ee5f5e7d710b	2025	4	a12653df-c0ca-4814-8442-78636dfa6d94	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-01-12 03:00:00+00	\N	\N	4	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:09.411+00	2026-01-14 00:41:09.411+00	t	Importada de JSONL. Empresa: PEDRO MOSCUZZA E HIJO. Especie: MERLUZA	MC	30
891568fd-cfd2-4c4c-bfd0-4d9c57f82198	2025	5	face2a5f-184c-41f8-b3a8-9beebc3635ee	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-01-08 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:09.423+00	2026-01-14 00:41:09.423+00	t	Importada de JSONL. Empresa: PESQUERA GEMINIS. Especie: MERLUZA	MC	30
d7097607-d295-4981-a72f-090793ba8c33	2025	6	12964f37-2ef3-4932-9d34-b7ec4410c90b	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-01-09 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:09.432+00	2026-01-14 00:41:09.432+00	t	Importada de JSONL. Empresa: PESQUERA CERES. Especie: CALAMAR	MC	30
30770969-bb3b-49c0-b015-1420bf2d18ee	2025	7	3c111b3e-1c42-49b4-b579-168516f1dc1f	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-01-07 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:09.441+00	2026-01-14 00:41:09.441+00	t	Importada de JSONL. Empresa: ARGENOVA. Especie: CALAMAR	MC	30
8ed5e8f3-27ff-46bf-b7b1-aba4bf533087	2025	8	649e5ded-9a48-4bf8-aaa1-2edf147fe587	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-01-09 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:09.449+00	2026-01-14 00:41:09.449+00	t	Importada de JSONL. Empresa: LUIS SOLIMENO. Especie: MERLUZA	MC	30
61f3c95e-a80a-4bd0-8498-9eab710811ec	2025	9	4a837a56-b513-4568-b2d7-61bc1d66d22b	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-01-06 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:09.462+00	2026-01-14 00:41:09.462+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: VIEIRA	MC	30
8997039d-e6d9-4bca-8463-838ac5f6b1fb	2025	10	2df50464-9916-4b3e-b5c3-3a645623d525	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-01-11 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:09.473+00	2026-01-14 00:41:09.473+00	t	Importada de JSONL. Empresa: GLACIAR PESQUERA. Especie: VIEIRA	MC	30
cce1ecad-81c4-4625-b825-48009137d8c3	2025	11	3e0c8867-184b-437a-a2b6-482cf522af0a	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-01-08 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:09.481+00	2026-01-14 00:41:09.481+00	t	Importada de JSONL. Empresa: FOOD ARTZ S.A.. Especie: CALAMAR	MC	30
e492153b-241c-4895-a772-67ad78b6be33	2025	12	5fa98bd7-f095-4d3e-8e98-7761568ec108	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-01-09 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:09.489+00	2026-01-14 00:41:09.489+00	t	Importada de JSONL. Empresa: WANCHESE ARGENTINA. Especie: VIEIRA	MC	30
89b33858-f91c-4971-ab64-227f9ba17371	2025	13	50a5014a-b7c0-432c-a620-a5f096fabe15	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-01-09 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:09.497+00	2026-01-14 00:41:09.497+00	t	Importada de JSONL. Empresa: FOOD PARTNERS PATAGONIA. Especie: CENTOLLA	MC	30
e6b7d05c-171a-4ecb-90fb-fb31337da507	2025	14	c7c5892b-d6ee-4b44-b3a6-24dc9ded90aa	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-01-09 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:09.505+00	2026-01-14 00:41:09.505+00	t	Importada de JSONL. Empresa: PEDRO MOSCUZZA E HIJO. Especie: CALAMAR	MC	30
f547dedc-96f2-4ad3-86da-92a1373f5109	2025	15	7a5c52c3-f87e-4405-a08e-f3b2ae274460	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-01-11 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:09.512+00	2026-01-14 00:41:09.512+00	t	Importada de JSONL. Empresa: PESQUERA VERAZ. Especie: MERLUZA	MC	30
38c30a58-515e-4bb0-b785-783a38baab82	2025	16	0ddb5663-8ab9-4ad5-ab76-fb98b2e5d15d	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-01-16 03:00:00+00	\N	\N	11	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:09.526+00	2026-01-14 00:41:09.526+00	t	Importada de JSONL. Empresa: GLACIAR PESQUERA. Especie: VIEIRA	MC	30
9c7616fa-5388-4f5a-a182-323048a74273	2025	17	ba0b91e3-29d6-4028-acb8-c8256fa2aaf8	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-01-17 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:09.534+00	2026-01-14 00:41:09.534+00	t	Importada de JSONL. Empresa: ALTAMARE S.AS. Especie: CALAMAR	MC	30
640d4643-f206-4c34-a756-ef14e6c99a79	2025	18	28367073-f657-41aa-9604-7adfa455458c	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-01-17 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:09.544+00	2026-01-14 00:41:09.544+00	t	Importada de JSONL. Empresa: ALTAMARE S.AS. Especie: CALAMAR	MC	30
4c7760d3-eef2-49a2-bd90-ec74d9d2b3ed	2025	19	adc23180-9487-47ad-9e3d-62eade83623a	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-01-28 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:09.552+00	2026-01-14 00:41:09.552+00	t	Importada de JSONL. Empresa: BENTONICOS DE ARGENTINA. Especie: CENTOLLA	MC	30
6f309917-3dfe-408c-bb64-c2f226f2316c	2025	20	12964f37-2ef3-4932-9d34-b7ec4410c90b	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-01-28 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:09.56+00	2026-01-14 00:41:09.56+00	t	Importada de JSONL. Empresa: GIORNO. Especie: CALAMAR	MC	30
71b5feb8-c564-4834-845c-a91318c6492e	2025	21	e70330eb-bcaf-472c-9906-1096de4235dd	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-02-04 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:09.569+00	2026-01-14 00:41:09.569+00	t	Importada de JSONL. Empresa: CRUSTACEOS DEL SUR S.A. Especie: CENTOLLA	MC	30
98d6da59-bc8f-49ff-a776-aff6e36ccb0a	2025	22	546c200e-da22-4c78-8c7d-cbdeab4535cd	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-02-01 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:09.585+00	2026-01-14 00:41:09.585+00	t	Importada de JSONL. Empresa: ARGENOVA. Especie: CALAMAR	MC	30
0f730c5f-a6f1-4aed-be91-93320107ef3c	2025	23	a55f3785-99ec-4342-84b4-1920e07cbda0	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	2025-01-28 03:00:00+00	\N	\N	0	AUTOMATICO	\N	\N	\N	2026-01-14 00:41:09.601+00	2026-01-14 00:41:09.601+00	t	Importada de JSONL. Empresa: ARBUMASA S.A. Especie: CALAMAR	MC	30
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
466227be-bca2-420c-9724-d417540e7f2a	71b5feb8-c564-4834-845c-a91318c6492e	1	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-02-03 03:00:00+00	2025-03-12 03:00:00+00	COMERCIAL	Etapa 1 importada
2d73d1e4-eded-4548-af91-fa306895854c	98d6da59-bc8f-49ff-a776-aff6e36ccb0a	1	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	f41ff939-bc00-4bbd-8ce8-c451922ba284	f41ff939-bc00-4bbd-8ce8-c451922ba284	2025-01-31 03:00:00+00	2025-03-24 03:00:00+00	COMERCIAL	Etapa 1 importada
76a9cb5f-3f75-4acd-ac63-5220e64e7131	0f730c5f-a6f1-4aed-be91-93320107ef3c	1	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	f41ff939-bc00-4bbd-8ce8-c451922ba284	f41ff939-bc00-4bbd-8ce8-c451922ba284	2025-01-28 03:00:00+00	2025-02-23 03:00:00+00	COMERCIAL	Etapa 1 importada
8a88e19d-9760-4749-be31-7156968c30fa	0f730c5f-a6f1-4aed-be91-93320107ef3c	2	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	f41ff939-bc00-4bbd-8ce8-c451922ba284	f41ff939-bc00-4bbd-8ce8-c451922ba284	2025-02-25 03:00:00+00	2025-04-06 03:00:00+00	COMERCIAL	Etapa 2 importada
8218a590-5b3d-4f0f-ae66-aa509888075f	04b6229f-7d19-4b8a-9237-a519202222a0	1	92d9acc2-3590-474f-a773-73e8af728e83	f41ff939-bc00-4bbd-8ce8-c451922ba284	f41ff939-bc00-4bbd-8ce8-c451922ba284	2025-01-29 03:00:00+00	2025-02-23 03:00:00+00	COMERCIAL	Etapa 1 importada
2a817b6f-286d-4906-8161-42cc90b912a0	e6f7ebb4-26d6-4bc1-b14e-db07fdf479f5	1	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-01-30 03:00:00+00	2025-02-27 03:00:00+00	COMERCIAL	Etapa 1 importada
ce2fad78-fc03-43b8-a20b-1f5fea8be357	55f52d76-0c76-490c-81d3-5a03b292c9c3	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	105b0349-a9ed-49bf-9336-aad8d3867f0b	105b0349-a9ed-49bf-9336-aad8d3867f0b	2025-02-03 03:00:00+00	2025-03-10 03:00:00+00	COMERCIAL	Etapa 1 importada
b2aa34fb-6551-45eb-9999-79aacdcf1c9d	b8d25e78-d9c7-4416-977b-ebf6e60ca6cc	1	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-01-30 03:00:00+00	2025-03-11 03:00:00+00	COMERCIAL	Etapa 1 importada
d6b39e9e-7b11-4e02-a282-635a600c64b0	e30b483b-ea05-4b41-93f0-c89e7c97b7a6	1	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	b8a55941-9f65-4e90-bea1-3683753d42b5	b8a55941-9f65-4e90-bea1-3683753d42b5	2025-02-05 03:00:00+00	2025-04-09 03:00:00+00	COMERCIAL	Etapa 1 importada
e2c55b2f-dd63-4ffb-adc5-2d8120e7bfd5	e5d2e37b-a388-47fd-b3a7-a09b73fa0158	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-02-07 03:00:00+00	2025-02-22 03:00:00+00	COMERCIAL	Etapa 1 importada
0e7ed4fe-5f1f-4fdb-8773-4dda588cda6b	7701800b-8c67-4f60-80ea-c72a68a80f7d	1	92d9acc2-3590-474f-a773-73e8af728e83	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-02-11 03:00:00+00	2025-05-07 03:00:00+00	COMERCIAL	Etapa 1 importada
3e870e30-a3ae-4401-b8c1-f377021129ee	3d1e676b-21d2-45cd-8f2d-d93f4727b01c	1	6af901f6-bd7d-4bc7-8c9d-f441e526e65c	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-02-12 03:00:00+00	2025-03-20 03:00:00+00	COMERCIAL	Etapa 1 importada
9af08888-e32c-4062-a997-5290e7b4dec4	0ac9a3b7-fead-4b51-b1c3-51c7333154ef	1	92d9acc2-3590-474f-a773-73e8af728e83	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-02-19 03:00:00+00	2025-04-13 03:00:00+00	COMERCIAL	Etapa 1 importada
d7d2bb40-f676-4899-906a-7dde7ea3bd0c	4fd2c3f7-68a3-458e-bd8b-5e2c62ec60ed	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-02-18 03:00:00+00	2025-02-25 03:00:00+00	COMERCIAL	Etapa 1 importada
58a24d0b-fdd3-4046-8ced-257f2e367924	1a54b40d-84c1-4c94-a3d6-a2b52391b780	1	6af901f6-bd7d-4bc7-8c9d-f441e526e65c	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-02-27 03:00:00+00	2025-04-07 03:00:00+00	COMERCIAL	Etapa 1 importada
1418505d-4efc-4f00-9498-09c7197a7f33	6da5576d-2280-48a7-8d72-be325aafe103	1	92d9acc2-3590-474f-a773-73e8af728e83	f41ff939-bc00-4bbd-8ce8-c451922ba284	f41ff939-bc00-4bbd-8ce8-c451922ba284	2025-02-24 03:00:00+00	2025-03-31 03:00:00+00	COMERCIAL	Etapa 1 importada
1bb1b2c6-fbb9-41e8-bd47-224fc90ebc66	9f71d41a-5a5b-4ee1-8076-f8ef65eb3583	1	6af901f6-bd7d-4bc7-8c9d-f441e526e65c	\N	\N	2025-02-21 03:00:00+00	2025-04-02 03:00:00+00	COMERCIAL	Etapa 1 importada
2a7b5234-e133-4150-bd79-7cb8337da1c6	e21b90dc-df99-4eba-8a8a-1624de4dc936	1	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-02-21 03:00:00+00	2025-03-28 03:00:00+00	COMERCIAL	Etapa 1 importada
29d58fb0-f7bf-42b7-b475-2034e40266de	da24bf7d-9642-4503-81d1-58fd1fbe8ffe	1	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-03-06 03:00:00+00	2025-03-26 03:00:00+00	COMERCIAL	Etapa 1 importada
edad3627-6e29-4620-aa6e-de7ccb7c85e4	e4dfb9b7-1dc7-4838-bd5b-65bda33b7062	1	6af901f6-bd7d-4bc7-8c9d-f441e526e65c	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-03-06 03:00:00+00	2025-04-13 03:00:00+00	COMERCIAL	Etapa 1 importada
1b19284e-c88e-4710-a914-83b06e5e7bbb	90bf9a4a-3233-43e0-bceb-4843a6424ff1	1	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-03-07 03:00:00+00	2025-04-07 03:00:00+00	COMERCIAL	Etapa 1 importada
01c6479f-a8e8-4ada-a0eb-5efa6a684a5d	c29d8cf7-bdde-4596-8fda-d1911fbe68ec	1	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-03-11 03:00:00+00	2025-03-18 03:00:00+00	COMERCIAL	Etapa 1 importada
e266f665-24dc-468c-ac5f-20bada3eb06e	c29d8cf7-bdde-4596-8fda-d1911fbe68ec	2	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-03-21 03:00:00+00	2025-03-28 03:00:00+00	COMERCIAL	Etapa 2 importada
bcddb3e9-5a97-44c1-989a-35cb627c0f9a	e06c2441-b7b0-4922-9aad-dbc981bbc1d3	1	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-03-11 03:00:00+00	2025-03-16 03:00:00+00	COMERCIAL	Etapa 1 importada
c0972778-9663-497f-99de-6ed0e8a32b05	e06c2441-b7b0-4922-9aad-dbc981bbc1d3	2	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-03-17 03:00:00+00	2025-03-28 03:00:00+00	COMERCIAL	Etapa 2 importada
1aea25f0-ca74-434f-90d2-db9168be3607	daff9983-9b0f-46a5-87a0-21d52c16b234	1	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-03-12 03:00:00+00	2025-03-17 03:00:00+00	COMERCIAL	Etapa 1 importada
ec452251-be4d-437c-8d60-783b24424b46	daff9983-9b0f-46a5-87a0-21d52c16b234	2	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-03-18 03:00:00+00	2025-03-29 03:00:00+00	COMERCIAL	Etapa 2 importada
baae2ec9-ad48-4f50-94af-e4b9375c1bec	921652f0-4013-4808-98fb-9234429ecfdf	1	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-03-11 03:00:00+00	2025-03-20 03:00:00+00	COMERCIAL	Etapa 1 importada
f3fe276f-35b7-49a4-8a1b-2b3e3e2922f2	921652f0-4013-4808-98fb-9234429ecfdf	2	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-03-22 03:00:00+00	2025-03-27 03:00:00+00	COMERCIAL	Etapa 2 importada
5ea22ed4-f675-4b7e-8519-a131ffd0c97d	eab63893-ae5b-4bb9-81f5-82073dd5a928	1	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-03-07 03:00:00+00	2025-03-12 03:00:00+00	COMERCIAL	Etapa 1 importada
46eb726d-24b6-42ec-87b2-4f17ea8bd326	eab63893-ae5b-4bb9-81f5-82073dd5a928	2	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-03-15 03:00:00+00	2025-03-18 03:00:00+00	COMERCIAL	Etapa 2 importada
db8f7163-5186-4c49-ab66-9d7a94545a48	f772b482-10e8-4dbd-b54d-18ad99ee8da4	1	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-03-11 03:00:00+00	2025-04-23 03:00:00+00	COMERCIAL	Etapa 1 importada
addc4d3e-fb88-49a9-a749-0a0381141b15	661d8e7c-b0ee-4bb4-addd-d927d95de530	1	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-03-12 03:00:00+00	2025-04-30 03:00:00+00	COMERCIAL	Etapa 1 importada
046fca90-a1f5-48e0-ac88-db2fde6b0c9c	9b158375-56d3-4207-a70b-32eb6f7e4a1f	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	105b0349-a9ed-49bf-9336-aad8d3867f0b	105b0349-a9ed-49bf-9336-aad8d3867f0b	2025-03-17 03:00:00+00	2025-04-25 03:00:00+00	COMERCIAL	Etapa 1 importada
2298767a-e9dd-484c-86f8-c0c21ba485be	134e771f-508a-40df-a6ac-76f532bdaeb6	1	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-03-24 03:00:00+00	2025-04-23 03:00:00+00	COMERCIAL	Etapa 1 importada
749d60a0-d908-4523-9474-b7cfecb5b597	a82d5e41-b695-4a9d-aea9-0f3194d52b67	1	6af901f6-bd7d-4bc7-8c9d-f441e526e65c	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-03-28 03:00:00+00	2025-04-30 03:00:00+00	COMERCIAL	Etapa 1 importada
4fd45a64-46ee-45cd-a09b-09eb77f07011	36d0f8b0-0c70-4822-9a1f-17486328b822	1	92d9acc2-3590-474f-a773-73e8af728e83	f41ff939-bc00-4bbd-8ce8-c451922ba284	f41ff939-bc00-4bbd-8ce8-c451922ba284	2025-04-01 03:00:00+00	2025-04-27 03:00:00+00	COMERCIAL	Etapa 1 importada
dddfddcd-6808-49fe-93a1-b525e266e339	8ca1a435-51b3-4cdb-8323-d12132f30070	1	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-03-28 03:00:00+00	2025-05-05 03:00:00+00	COMERCIAL	Etapa 1 importada
500ac431-1c89-4bad-a558-a9a8ad38ff23	f4602bf8-6141-4e7c-9a9b-9d3d1e63761f	1	6af901f6-bd7d-4bc7-8c9d-f441e526e65c	\N	\N	2025-04-11 03:00:00+00	2025-05-17 03:00:00+00	COMERCIAL	Etapa 1 importada
9c454da8-a2ce-47ce-b75b-d887753651af	4f5e867f-2277-4990-89a0-8e621d229020	1	92d9acc2-3590-474f-a773-73e8af728e83	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-04-18 03:00:00+00	2025-05-19 03:00:00+00	COMERCIAL	Etapa 1 importada
157b4484-7417-4b78-99f4-b387d84bd271	ab688bbc-76e4-4967-9d8b-79141f666795	1	92d9acc2-3590-474f-a773-73e8af728e83	b8a55941-9f65-4e90-bea1-3683753d42b5	b8a55941-9f65-4e90-bea1-3683753d42b5	2025-04-12 03:00:00+00	2025-05-20 03:00:00+00	COMERCIAL	Etapa 1 importada
c3c6c893-1c29-48bf-8a9d-25092a69e2f7	75b63bea-982a-4151-8923-cdc3ca09d56e	1	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-05-08 03:00:00+00	2025-06-06 03:00:00+00	COMERCIAL	Etapa 1 importada
dedcc07e-2050-4653-bc46-11d26579a2dd	83254676-7d69-46bb-839c-fcb352334c92	1	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-04-21 03:00:00+00	2025-05-15 03:00:00+00	COMERCIAL	Etapa 1 importada
c34aeca6-6397-4a8e-bd65-8c968b1f91d0	02d0bd10-2761-47e9-a460-30e179e77b9d	1	6af901f6-bd7d-4bc7-8c9d-f441e526e65c	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-04-10 03:00:00+00	2025-06-06 03:00:00+00	COMERCIAL	Etapa 1 importada
732207d1-4352-4953-b114-809c06bf4a00	13eeb6f9-9d7e-48d0-8d5d-d72695620833	1	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-04-12 03:00:00+00	2025-05-14 03:00:00+00	COMERCIAL	Etapa 1 importada
c62465fa-1330-4c44-87d2-d6250ea4e2d0	bc9edd1c-bfb7-4fc2-a452-e6cf557ca733	1	6af901f6-bd7d-4bc7-8c9d-f441e526e65c	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-04-16 03:00:00+00	2025-05-29 03:00:00+00	COMERCIAL	Etapa 1 importada
151eeecb-6871-4103-af86-36db2ad853e8	7d09cfaa-19da-4ab3-8ce5-b891a4b9d215	1	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	105b0349-a9ed-49bf-9336-aad8d3867f0b	105b0349-a9ed-49bf-9336-aad8d3867f0b	2025-04-15 03:00:00+00	2025-05-27 03:00:00+00	COMERCIAL	Etapa 1 importada
95dfa235-56f5-4877-9ff0-74e54d569585	9eb6be1f-e0cd-43b6-876e-3303f8238252	1	4167beb8-ce39-4fd3-8314-8b3487879d92	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-04-12 03:00:00+00	2025-04-20 03:00:00+00	COMERCIAL	Etapa 1 importada
c9747462-e6ee-4baf-b7a0-49b8df7f51cb	9eb6be1f-e0cd-43b6-876e-3303f8238252	2	4167beb8-ce39-4fd3-8314-8b3487879d92	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-04-21 03:00:00+00	2025-05-01 03:00:00+00	COMERCIAL	Etapa 2 importada
a93f27af-970c-42b2-b72b-505333b05510	9eb6be1f-e0cd-43b6-876e-3303f8238252	3	4167beb8-ce39-4fd3-8314-8b3487879d92	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-05-02 03:00:00+00	2025-05-10 03:00:00+00	COMERCIAL	Etapa 3 importada
486d631a-9717-43cf-8b51-096d77904347	2e03db0e-0f5a-4bee-a9ce-62275877178f	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	105b0349-a9ed-49bf-9336-aad8d3867f0b	105b0349-a9ed-49bf-9336-aad8d3867f0b	2025-04-27 03:00:00+00	2025-05-31 03:00:00+00	COMERCIAL	Etapa 1 importada
9e2dc75a-115d-420e-b8f4-4d7cd22944ad	a7b198f6-2669-4367-8dca-b1cf27ac4f51	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	0205-04-21 03:53:48+00	2025-04-29 03:00:00+00	COMERCIAL	Etapa 1 importada
b722095c-3420-49fc-835b-c4dc6196be40	a7b198f6-2669-4367-8dca-b1cf27ac4f51	2	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-05-02 03:00:00+00	2025-05-10 03:00:00+00	COMERCIAL	Etapa 2 importada
97d36b33-a691-4585-8483-80885c723e14	a7b198f6-2669-4367-8dca-b1cf27ac4f51	3	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-05-12 03:00:00+00	2025-05-26 03:00:00+00	COMERCIAL	Etapa 3 importada
d8234ba3-6d11-4cf4-ab12-47a3992a9982	12560a8d-1d4d-4c20-a734-8ee0ff62a0e6	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-05-02 03:00:00+00	2025-05-09 03:00:00+00	COMERCIAL	Etapa 1 importada
06b11cde-5352-4b36-95d0-5aedaad5055c	12560a8d-1d4d-4c20-a734-8ee0ff62a0e6	2	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-05-14 03:00:00+00	2025-05-25 03:00:00+00	COMERCIAL	Etapa 2 importada
3193e0fd-04bc-4567-a56d-e44b975312d0	edb87fd9-19c0-438c-a893-5b99fcecf2e6	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-04-30 03:00:00+00	2025-06-16 03:00:00+00	COMERCIAL	Etapa 1 importada
99e6e73f-2e31-4bfb-9c59-4b6ce4305e15	cc26c06e-063a-4f03-ba93-dc1548da8b5f	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-04-26 03:00:00+00	2025-05-04 03:00:00+00	COMERCIAL	Etapa 1 importada
2838cc2e-66be-4d23-bd94-01121597f25c	cc26c06e-063a-4f03-ba93-dc1548da8b5f	2	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-05-06 03:00:00+00	2025-05-15 03:00:00+00	COMERCIAL	Etapa 2 importada
c2414831-796a-41e0-ae5e-d2e056735a28	cc26c06e-063a-4f03-ba93-dc1548da8b5f	3	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-05-17 03:00:00+00	2025-05-27 03:00:00+00	COMERCIAL	Etapa 3 importada
5896af70-02cf-4b19-b4ad-c034960aefe0	9a6c3e8b-124a-4c95-bf49-94f903004ab6	1	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-04-26 03:00:00+00	2025-05-28 03:00:00+00	COMERCIAL	Etapa 1 importada
98857039-ae1e-45f3-9680-fbd75efe9413	6b0da04b-0dd6-421a-bd51-67a1f0c1a56a	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-05-02 03:00:00+00	2025-05-10 03:00:00+00	COMERCIAL	Etapa 1 importada
4a1a9bb2-8aa1-4080-8a01-b6b61c6f1bf4	6b0da04b-0dd6-421a-bd51-67a1f0c1a56a	2	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-05-12 03:00:00+00	2025-05-21 03:00:00+00	COMERCIAL	Etapa 2 importada
dc28d960-10d7-45e3-b33e-e61bcf7e679b	e15a4939-ae23-4991-8ac4-5ed84361e229	1	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-04-30 03:00:00+00	2025-06-05 03:00:00+00	COMERCIAL	Etapa 1 importada
22b25059-a61a-4e74-9dcd-59cf9e8efc38	61639206-bb3b-4e02-a43b-571ffe935af8	1	92d9acc2-3590-474f-a773-73e8af728e83	f41ff939-bc00-4bbd-8ce8-c451922ba284	f41ff939-bc00-4bbd-8ce8-c451922ba284	2025-04-28 03:00:00+00	2025-06-04 03:00:00+00	COMERCIAL	Etapa 1 importada
17814177-3623-4279-b7cf-c52271b8f123	5ad3a3fb-e713-4aa4-bdfa-c64897be84c4	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-04-30 03:00:00+00	2025-05-06 03:00:00+00	COMERCIAL	Etapa 1 importada
27102d32-1b6f-4dbe-a315-ff516570b127	5ad3a3fb-e713-4aa4-bdfa-c64897be84c4	2	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-05-08 03:00:00+00	2025-05-17 03:00:00+00	COMERCIAL	Etapa 2 importada
0f90c115-66cd-4848-b78d-203dcc9478ca	5ad3a3fb-e713-4aa4-bdfa-c64897be84c4	3	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-05-22 03:00:00+00	2025-05-29 03:00:00+00	COMERCIAL	Etapa 3 importada
10405f4f-6608-49fc-a0f5-bc59d82b6f8a	23bec926-2e1e-48ac-a34e-b021931e5c4a	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-04-29 03:00:00+00	2025-05-15 03:00:00+00	COMERCIAL	Etapa 1 importada
48b29034-8595-451f-9c4c-a4dfe562f46d	5ca55e94-ec43-4870-a024-53c6fd3899e0	1	92d9acc2-3590-474f-a773-73e8af728e83	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-05-06 03:00:00+00	2025-06-18 03:00:00+00	COMERCIAL	Etapa 1 importada
3d71f003-89db-440f-b8de-fc425109df6c	d1345931-2377-4835-b707-56cffe0d23b7	1	6af901f6-bd7d-4bc7-8c9d-f441e526e65c	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-05-07 03:00:00+00	2025-06-10 03:00:00+00	COMERCIAL	Etapa 1 importada
1e995e88-4520-43e1-b51f-48635b05f93d	ad6ff68c-97d6-4ccf-99e7-09705901ef24	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-05-02 03:00:00+00	2025-06-05 03:00:00+00	COMERCIAL	Etapa 1 importada
1e27eeb6-a775-412e-a766-c42f9573e029	ac5ff8a0-6a36-4e59-a826-099cad6c260a	1	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-05-07 03:00:00+00	2025-06-09 03:00:00+00	COMERCIAL	Etapa 1 importada
1b010a98-ed5b-4a6f-b05b-319862e3c748	92c833ed-110f-423d-bb0f-42eb1a3cc410	1	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-05-07 03:00:00+00	2025-06-10 03:00:00+00	COMERCIAL	Etapa 1 importada
8eeadbc4-2299-46d1-86c5-876e0874a3ab	1ee1160e-1fe6-4523-a965-5d081f225006	1	4167beb8-ce39-4fd3-8314-8b3487879d92	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-05-09 03:00:00+00	2025-05-19 03:00:00+00	COMERCIAL	Etapa 1 importada
cc1ff641-fefd-44d9-af4d-989631d891c7	896cabea-e6b1-4027-9da4-4cd64d9b8173	1	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-05-15 03:00:00+00	2025-05-27 03:00:00+00	COMERCIAL	Etapa 1 importada
88ab7e6c-9a34-4d13-addb-804a897facd1	24de7801-3383-4693-90a3-d4e2f389ebc2	1	92d9acc2-3590-474f-a773-73e8af728e83	b8a55941-9f65-4e90-bea1-3683753d42b5	b8a55941-9f65-4e90-bea1-3683753d42b5	2025-05-21 03:00:00+00	2025-07-13 03:00:00+00	COMERCIAL	Etapa 1 importada
9a840e34-3f0a-4b11-8c95-26d118b9aa63	6536a509-e9ff-4c6c-86ac-c29d35e250a1	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-05-17 03:00:00+00	2025-07-13 03:00:00+00	COMERCIAL	Etapa 1 importada
7b11b129-39ee-454e-b242-f8ca50b38e3c	d97a833e-1094-4499-acd3-abe345f14bf6	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-05-22 03:00:00+00	2025-06-17 03:00:00+00	COMERCIAL	Etapa 1 importada
36ed6f7c-ac14-4bf9-a0e0-c6bd18edef6a	ce6b184a-27cc-4e69-9b54-1de1c90c1dec	1	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-05-22 03:00:00+00	2025-06-05 03:00:00+00	COMERCIAL	Etapa 1 importada
12effdc4-5a42-40cb-a4b9-1d2f06974cde	3dd68328-0ea1-4d1a-9142-b67088fedcda	1	92d9acc2-3590-474f-a773-73e8af728e83	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-05-20 03:00:00+00	2025-06-21 03:00:00+00	COMERCIAL	Etapa 1 importada
5e09b86c-63de-45cf-8b20-27564b31cc6b	12634231-f4e9-4b82-9958-26972ac58975	1	6af901f6-bd7d-4bc7-8c9d-f441e526e65c	\N	\N	2025-05-27 03:00:00+00	2025-07-12 03:00:00+00	COMERCIAL	Etapa 1 importada
73401057-2b48-49ba-b414-e0837acf6093	26fe3877-c712-44bf-90da-4e8fe9d152d2	1	6af901f6-bd7d-4bc7-8c9d-f441e526e65c	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-05-31 03:00:00+00	2025-07-11 03:00:00+00	COMERCIAL	Etapa 1 importada
37f4e6eb-a0cc-4c14-a624-c49724465951	ec6c04a5-0942-4932-bf6d-e8f11745ad45	1	4167beb8-ce39-4fd3-8314-8b3487879d92	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-05-26 03:00:00+00	2025-06-03 03:00:00+00	COMERCIAL	Etapa 1 importada
1fad73a6-4b80-4eed-abcc-c94722cf67dc	ec6c04a5-0942-4932-bf6d-e8f11745ad45	2	4167beb8-ce39-4fd3-8314-8b3487879d92	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-06-04 03:00:00+00	2025-06-10 03:00:00+00	COMERCIAL	Etapa 2 importada
3e4aeb48-cbe9-4f57-9d59-3e0d5c3d076f	d824e9ee-9849-4b51-9fcd-517af440e4d0	1	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-05-31 03:00:00+00	2025-06-07 03:00:00+00	COMERCIAL	Etapa 1 importada
eb7bc134-8265-4238-bbcf-75a61b04ef8f	7b5ef1bd-4eb4-489c-976b-477525f660a5	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-06-12 03:00:00+00	2025-06-20 03:00:00+00	COMERCIAL	Etapa 1 importada
8653764f-7fc9-4deb-b3f5-80f40aef1e9e	7b5ef1bd-4eb4-489c-976b-477525f660a5	2	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-06-24 03:00:00+00	2025-07-05 03:00:00+00	COMERCIAL	Etapa 2 importada
f896387b-1381-4e0a-9088-7fb7a0d4140b	7b5ef1bd-4eb4-489c-976b-477525f660a5	3	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-07-08 03:00:00+00	2025-07-16 03:00:00+00	COMERCIAL	Etapa 3 importada
f58cb791-22f4-4e10-a9f9-761e6b0657b6	7b5ef1bd-4eb4-489c-976b-477525f660a5	4	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-07-19 03:00:00+00	2025-07-25 03:00:00+00	COMERCIAL	Etapa 4 importada
1e8691fa-31d0-4ba9-9144-7b2880a2384b	5ae0c35c-5c3b-4fae-b112-b5ae6d8217eb	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-06-05 03:00:00+00	2025-07-06 03:00:00+00	COMERCIAL	Etapa 1 importada
d9c9a8ff-1c77-40cb-9d3f-0f6d5cabb62b	019284e5-0c48-42be-ae75-5706530352fd	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	105b0349-a9ed-49bf-9336-aad8d3867f0b	105b0349-a9ed-49bf-9336-aad8d3867f0b	2025-06-05 03:00:00+00	2025-07-06 03:00:00+00	COMERCIAL	Etapa 1 importada
2a5782a6-61a7-431c-9e63-39e6296fe248	07d31e6d-26f8-42db-a71d-f2ba8f440b76	1	92d9acc2-3590-474f-a773-73e8af728e83	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-06-18 03:00:00+00	2025-07-03 03:00:00+00	COMERCIAL	Etapa 1 importada
d42dced3-c7c4-496c-ad9b-11047573768d	924f4e58-334a-4279-8770-9fb785bd3daa	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-06-10 03:00:00+00	2025-06-17 03:00:00+00	COMERCIAL	Etapa 1 importada
3c86675d-fc50-4fa1-a205-b8a4fe8fd75d	924f4e58-334a-4279-8770-9fb785bd3daa	2	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-06-19 03:00:00+00	2025-06-22 03:00:00+00	COMERCIAL	Etapa 2 importada
c161a510-e646-4b38-baa0-9560137da36d	924f4e58-334a-4279-8770-9fb785bd3daa	3	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-06-28 03:00:00+00	2025-07-04 03:00:00+00	COMERCIAL	Etapa 3 importada
9b6dd9d2-3e01-4921-a077-09cf5b950404	924f4e58-334a-4279-8770-9fb785bd3daa	4	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-07-06 03:00:00+00	2025-07-10 03:00:00+00	COMERCIAL	Etapa 4 importada
d714fd53-3f75-44aa-9dbd-74d8cd46160b	924f4e58-334a-4279-8770-9fb785bd3daa	5	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-07-12 03:00:00+00	2025-07-16 03:00:00+00	COMERCIAL	Etapa 5 importada
075c5467-de40-46c2-98e4-7177146cfcb0	d776c633-7d6a-41a8-b83c-5996b880b452	1	4167beb8-ce39-4fd3-8314-8b3487879d92	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-06-18 03:00:00+00	2025-06-25 03:00:00+00	COMERCIAL	Etapa 1 importada
b6d47884-e45b-4058-955d-1edbe0837079	d776c633-7d6a-41a8-b83c-5996b880b452	2	4167beb8-ce39-4fd3-8314-8b3487879d92	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-06-27 03:00:00+00	2025-07-11 03:00:00+00	COMERCIAL	Etapa 2 importada
5bf48722-339a-4141-ae6d-c911ae67c85c	8c1b9863-f3de-4725-8100-d31306ab7a9f	1	4167beb8-ce39-4fd3-8314-8b3487879d92	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-06-17 03:00:00+00	2025-07-10 03:00:00+00	COMERCIAL	Etapa 1 importada
4464a998-a87d-4dc5-a5cd-f83b88bc1b7e	1797ca1f-77e5-46cf-bb03-f54cf2656699	1	4167beb8-ce39-4fd3-8314-8b3487879d92	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-06-18 03:00:00+00	2025-06-25 03:00:00+00	COMERCIAL	Etapa 1 importada
88bdbae4-fabf-4c97-8c4c-6f4dcd8b8c76	cc5da30e-92da-4a31-a6a9-367f12538f5d	1	4167beb8-ce39-4fd3-8314-8b3487879d92	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-06-18 03:00:00+00	2025-06-25 03:00:00+00	COMERCIAL	Etapa 1 importada
40b6291a-fc00-4a0a-8f58-682cf3e55350	54116fc8-0376-4e98-8e06-51d69391c0db	1	4167beb8-ce39-4fd3-8314-8b3487879d92	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-06-18 03:00:00+00	2025-06-25 03:00:00+00	COMERCIAL	Etapa 1 importada
be31af4e-e9c2-4faf-a18f-07ec8c24953b	35f620eb-aae7-4b01-9a49-83de0709e695	1	4167beb8-ce39-4fd3-8314-8b3487879d92	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-06-18 03:00:00+00	2025-06-25 03:00:00+00	COMERCIAL	Etapa 1 importada
86f75df3-2cdf-4ca9-b9b1-643792471d26	35f620eb-aae7-4b01-9a49-83de0709e695	2	4167beb8-ce39-4fd3-8314-8b3487879d92	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-06-27 03:00:00+00	2025-07-04 03:00:00+00	COMERCIAL	Etapa 2 importada
1fd3e31a-1807-42f5-9d8c-4573497402d8	affe4a6b-5ae3-4188-b88b-82cb7d46e835	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-06-25 03:00:00+00	2025-07-03 03:00:00+00	COMERCIAL	Etapa 1 importada
50243639-6c86-4b71-8ecb-650853120909	affe4a6b-5ae3-4188-b88b-82cb7d46e835	2	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-07-05 03:00:00+00	2025-07-11 03:00:00+00	COMERCIAL	Etapa 2 importada
84ceae64-77e7-4acf-9146-e20930822cf9	affe4a6b-5ae3-4188-b88b-82cb7d46e835	3	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-07-20 03:00:00+00	2025-07-26 03:00:00+00	COMERCIAL	Etapa 3 importada
edde090c-9ecb-4ce8-8575-3cbe50426215	affe4a6b-5ae3-4188-b88b-82cb7d46e835	4	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-07-28 03:00:00+00	2025-08-04 03:00:00+00	COMERCIAL	Etapa 4 importada
66b0f599-8550-4a00-9875-643761430c4f	de7f7699-c09a-4cf4-bceb-3c8fa0eef107	1	4167beb8-ce39-4fd3-8314-8b3487879d92	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-06-27 03:00:00+00	2025-07-21 03:00:00+00	COMERCIAL	Etapa 1 importada
86ef3408-c132-4d65-bafa-33388ee99a73	75b8e60b-8e72-4110-a02a-4a9c89d3247a	1	4167beb8-ce39-4fd3-8314-8b3487879d92	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-06-27 03:00:00+00	2025-07-03 03:00:00+00	COMERCIAL	Etapa 1 importada
43639668-64b7-48ee-8359-17811e02b32c	75b8e60b-8e72-4110-a02a-4a9c89d3247a	2	4167beb8-ce39-4fd3-8314-8b3487879d92	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-07-04 03:00:00+00	2025-07-11 03:00:00+00	COMERCIAL	Etapa 2 importada
aad0cb5a-9398-461b-905d-e52bbbaa5175	8efb8972-ce3d-4cab-9bdd-74404194c448	1	4167beb8-ce39-4fd3-8314-8b3487879d92	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-06-27 03:00:00+00	2025-07-17 03:00:00+00	COMERCIAL	Etapa 1 importada
7f301173-684e-453f-85af-20ed1319e77b	1b88cb74-d1ee-4175-82bd-133e4851a9c0	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-07-12 03:00:00+00	2025-07-14 03:00:00+00	COMERCIAL	Etapa 1 importada
3d7d3823-eacb-45eb-be45-fa78c0367887	1b88cb74-d1ee-4175-82bd-133e4851a9c0	2	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-07-18 03:00:00+00	2025-07-23 03:00:00+00	COMERCIAL	Etapa 2 importada
e9c54d4c-5e00-484b-a840-c21c54d4dcc1	1b88cb74-d1ee-4175-82bd-133e4851a9c0	3	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-07-27 03:00:00+00	2025-08-01 03:00:00+00	COMERCIAL	Etapa 3 importada
691b96d9-a0e4-43b2-b23b-2fa018f6ea71	b044574d-b57e-4aee-84f9-52dd22d71c02	1	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-07-10 03:00:00+00	2025-08-29 03:00:00+00	COMERCIAL	Etapa 1 importada
3bb8ac0a-cbf8-49cb-a79e-e8ba2a5d742b	8b387d1b-5ce1-4ef9-bdc7-40c0dee441b0	1	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-07-14 03:00:00+00	2025-08-28 03:00:00+00	COMERCIAL	Etapa 1 importada
5bc15d47-2006-4379-8b9c-5f9e48dafda4	530ef634-901c-438f-a0f5-4f52cab7a969	1	4167beb8-ce39-4fd3-8314-8b3487879d92	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-07-11 03:00:00+00	2025-08-20 03:00:00+00	COMERCIAL	Etapa 1 importada
a4826e22-f637-4417-90ff-41363b4c9cef	f2d0a1d7-4867-4b46-befe-e7aca3ef945b	1	4167beb8-ce39-4fd3-8314-8b3487879d92	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-07-13 03:00:00+00	2025-08-05 03:00:00+00	COMERCIAL	Etapa 1 importada
0be05fd0-f356-4663-94ab-7c2ca60ddea9	e27c7ba0-3f80-49f0-b52e-2c79c199401b	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	5b1bcc08-58a5-499b-b2cc-d02d0df392fa	5b1bcc08-58a5-499b-b2cc-d02d0df392fa	2025-07-12 03:00:00+00	2025-08-23 03:00:00+00	COMERCIAL	Etapa 1 importada
38d4c115-acd6-49b5-932f-72c5a24f61bb	e2c1a54c-7a35-4aa2-b615-386313d039c5	1	4167beb8-ce39-4fd3-8314-8b3487879d92	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-07-18 03:00:00+00	2025-07-25 03:00:00+00	COMERCIAL	Etapa 1 importada
5ee48ec4-e5d6-4180-8559-500e05c5bc9f	e2c1a54c-7a35-4aa2-b615-386313d039c5	2	4167beb8-ce39-4fd3-8314-8b3487879d92	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-07-26 03:00:00+00	2025-08-03 03:00:00+00	COMERCIAL	Etapa 2 importada
0fad13a0-d866-4c7a-89a4-3a2fc22a8d71	e2c1a54c-7a35-4aa2-b615-386313d039c5	3	4167beb8-ce39-4fd3-8314-8b3487879d92	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-08-04 03:00:00+00	2025-08-10 03:00:00+00	COMERCIAL	Etapa 3 importada
a8298bc5-c34e-43b5-8a4d-eee2c8c3b838	e2c1a54c-7a35-4aa2-b615-386313d039c5	4	4167beb8-ce39-4fd3-8314-8b3487879d92	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-08-11 03:00:00+00	2025-08-17 03:00:00+00	COMERCIAL	Etapa 4 importada
b982cb17-5fe8-4071-b6fc-d9769f5018ac	f97ca208-0509-49cf-acef-922455403fe3	1	6af901f6-bd7d-4bc7-8c9d-f441e526e65c	\N	\N	2025-07-17 03:00:00+00	2025-09-04 03:00:00+00	COMERCIAL	Etapa 1 importada
a89824c6-8f7f-49e0-9393-a4361b717836	a0aeb842-95d6-413d-9ccd-8f67cbc51b38	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-07-19 03:00:00+00	2025-08-19 03:00:00+00	COMERCIAL	Etapa 1 importada
728ab33b-12c6-4c6b-b255-b8745590f080	2bde3e6b-fcb6-43ef-a637-7f1e075ae3b7	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-07-19 03:00:00+00	2025-08-23 03:00:00+00	COMERCIAL	Etapa 1 importada
4508cbf2-577e-4f73-a8f4-4219d0ed6198	abb71f7e-66c2-4fad-a06c-023f67a1485f	1	4167beb8-ce39-4fd3-8314-8b3487879d92	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-07-21 03:00:00+00	\N	COMERCIAL	Etapa generada automáticamente (sin desglose)
941828bd-77da-4cc7-915b-3767e72ce94c	8f6e1c1b-d8be-491e-82e1-1ced1843b47a	1	4167beb8-ce39-4fd3-8314-8b3487879d92	\N	\N	2025-07-23 03:00:00+00	2025-10-07 03:00:00+00	COMERCIAL	Etapa 1 importada
5a96abb2-0f95-49f7-8468-10dbf9188788	b935a58b-d0c4-4d60-9acd-7ed83c647978	1	4167beb8-ce39-4fd3-8314-8b3487879d92	\N	\N	2025-07-23 03:00:00+00	2025-09-27 03:00:00+00	COMERCIAL	Etapa 1 importada
6eede3ee-d055-41eb-b1ff-8a43ee5fcc42	73edad49-21e4-4680-b848-8cc046436440	1	4167beb8-ce39-4fd3-8314-8b3487879d92	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-07-24 03:00:00+00	2025-08-30 03:00:00+00	COMERCIAL	Etapa 1 importada
6933c7a1-851e-40b5-aa9e-564d1832ca2a	a670a10e-b396-43cf-9e4f-da854c216802	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-07-29 03:00:00+00	2025-08-03 03:00:00+00	COMERCIAL	Etapa 1 importada
548560de-742c-4a97-824b-ca061633a1d9	a670a10e-b396-43cf-9e4f-da854c216802	2	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-08-06 03:00:00+00	2025-08-14 03:00:00+00	COMERCIAL	Etapa 2 importada
54c9df77-aa4f-481c-ac1b-fe8bd63f2adc	a670a10e-b396-43cf-9e4f-da854c216802	3	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-08-16 03:00:00+00	2025-08-23 03:00:00+00	COMERCIAL	Etapa 3 importada
4056ec32-0e4f-4788-87c0-6d039f8766a6	65604077-1344-40c8-8aa5-530a80524667	1	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-07-29 03:00:00+00	2025-09-13 03:00:00+00	COMERCIAL	Etapa 1 importada
4081428c-48ed-4bdf-9c09-d252db487ce4	7c0f420c-18e3-4c11-a8ee-688eaba8c013	1	4167beb8-ce39-4fd3-8314-8b3487879d92	\N	\N	2025-07-30 03:00:00+00	2025-08-04 03:00:00+00	COMERCIAL	Etapa 1 importada
7c3e9ec2-3ac1-48d7-9f44-288bca2d4444	c54a944e-148b-4d71-9003-cf1a602eea67	1	4167beb8-ce39-4fd3-8314-8b3487879d92	\N	\N	2025-08-04 03:00:00+00	2025-08-14 03:00:00+00	COMERCIAL	Etapa 1 importada
dbfe29a0-3379-4e2f-9456-999a62fc652b	c54a944e-148b-4d71-9003-cf1a602eea67	2	4167beb8-ce39-4fd3-8314-8b3487879d92	\N	\N	2025-08-15 03:00:00+00	2025-09-07 03:00:00+00	COMERCIAL	Etapa 2 importada
cc0d0588-eafd-419e-89de-c5ae023c1286	bc922ab1-8a89-4fbd-8ff0-b92cb23f7ee3	1	4167beb8-ce39-4fd3-8314-8b3487879d92	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-08-01 03:00:00+00	2025-08-23 03:00:00+00	COMERCIAL	Etapa 1 importada
25566314-ab8b-4d36-b3b9-7012e1830136	971cd500-4f71-46d7-9b36-5cd570dd538e	1	4167beb8-ce39-4fd3-8314-8b3487879d92	f41ff939-bc00-4bbd-8ce8-c451922ba284	f41ff939-bc00-4bbd-8ce8-c451922ba284	2025-08-03 03:00:00+00	2025-08-23 03:00:00+00	COMERCIAL	Etapa 1 importada
67e9c2f5-6d4e-4e5f-86b9-148aa3592da2	a1964669-a378-41ef-a0ce-2da11a1fb8a8	1	4167beb8-ce39-4fd3-8314-8b3487879d92	\N	\N	2025-08-05 03:00:00+00	2025-08-13 03:00:00+00	COMERCIAL	Etapa 1 importada
f44f68a4-e69f-4d0d-9449-2895511b8341	d3cd4728-744f-438e-8ec7-cc2f2dc6571e	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-08-07 03:00:00+00	2025-08-14 03:00:00+00	COMERCIAL	Etapa 1 importada
2c2d2c86-3df6-4f5a-9ab5-67163b97fbb9	d3cd4728-744f-438e-8ec7-cc2f2dc6571e	2	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-08-20 03:00:00+00	2025-08-27 03:00:00+00	COMERCIAL	Etapa 2 importada
c36e4b13-86ff-4cbd-9381-e8587ccd68df	d3cd4728-744f-438e-8ec7-cc2f2dc6571e	3	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-08-29 03:00:00+00	2025-09-05 03:00:00+00	COMERCIAL	Etapa 3 importada
1cfda69f-753d-4789-97b0-1c6df6fc76a7	d3cd4728-744f-438e-8ec7-cc2f2dc6571e	4	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-09-08 03:00:00+00	2025-09-16 03:00:00+00	COMERCIAL	Etapa 4 importada
17de929f-2973-4620-b616-ec80a70daf5c	2807c518-ee18-46b9-be03-54ee4d5ed4f9	1	4167beb8-ce39-4fd3-8314-8b3487879d92	\N	\N	2025-08-08 03:00:00+00	2025-09-24 03:00:00+00	COMERCIAL	Etapa 1 importada
e99ef4de-38b1-49e0-b81f-8542b642138d	d9f9aaf9-d19d-4317-8719-29ae41e9cd59	1	4167beb8-ce39-4fd3-8314-8b3487879d92	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-08-07 03:00:00+00	2025-09-23 03:00:00+00	COMERCIAL	Etapa 1 importada
8f373327-c3f4-4dda-af28-2a19a6af411b	b178ba43-a1c2-4518-9734-e042d4790fce	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-08-14 03:00:00+00	2025-08-22 03:00:00+00	COMERCIAL	Etapa 1 importada
fbaca7f9-b7a8-483e-82a3-5cfeaee4dc72	b178ba43-a1c2-4518-9734-e042d4790fce	2	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-08-26 03:00:00+00	2025-09-05 03:00:00+00	COMERCIAL	Etapa 2 importada
6790a4f4-86a8-4eb0-997d-ba832431edc8	b178ba43-a1c2-4518-9734-e042d4790fce	3	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-09-09 03:00:00+00	2025-09-09 03:00:00+00	COMERCIAL	Etapa 3 importada
b1923c4e-86a8-47da-8e2b-6e7ec50e321c	b178ba43-a1c2-4518-9734-e042d4790fce	4	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-09-13 03:00:00+00	2025-09-23 03:00:00+00	COMERCIAL	Etapa 4 importada
ec1cdbaf-7576-471b-b080-fe26d89b42e1	0d9d50b5-0b9b-459c-91bc-1830f753b625	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-08-16 03:00:00+00	2025-08-25 03:00:00+00	COMERCIAL	Etapa 1 importada
ed221fc3-13d2-46db-b8a9-149a40f088a5	0d9d50b5-0b9b-459c-91bc-1830f753b625	2	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-08-28 03:00:00+00	2025-09-06 03:00:00+00	COMERCIAL	Etapa 2 importada
e6ae4bf7-a806-4510-b1d0-b535874128d4	0d9d50b5-0b9b-459c-91bc-1830f753b625	3	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-09-08 03:00:00+00	2025-09-18 03:00:00+00	COMERCIAL	Etapa 3 importada
bd85f525-5ef2-452d-abe8-0725ae287e8d	0f59cfcd-2244-4399-a8ef-14c52bffef07	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-08-22 03:00:00+00	2025-09-22 03:00:00+00	COMERCIAL	Etapa 1 importada
476604d9-1cfc-4099-8383-4f84c52d21b2	40e14f88-15d9-43e3-aaa1-a0cb6c1479d5	1	4167beb8-ce39-4fd3-8314-8b3487879d92	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-08-19 03:00:00+00	2025-08-31 03:00:00+00	COMERCIAL	Etapa 1 importada
ce3bf09e-b850-48e1-a7fc-e17579c5f7af	92f748e6-da70-4fd1-894d-89134404ab5a	1	4167beb8-ce39-4fd3-8314-8b3487879d92	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-08-20 03:00:00+00	2025-09-18 03:00:00+00	COMERCIAL	Etapa 1 importada
e85d8e00-ebb3-4563-af7a-c3a4e91220e5	0ad77221-e2c0-4c45-a650-6a0bc4154eb4	1	4167beb8-ce39-4fd3-8314-8b3487879d92	\N	\N	2025-08-25 03:00:00+00	2025-09-07 03:00:00+00	COMERCIAL	Etapa 1 importada
615f49e5-a36f-43d1-a7b5-62db9d6c7dff	a07196ce-0524-4b05-b36d-04450033c584	1	4167beb8-ce39-4fd3-8314-8b3487879d92	\N	\N	2025-08-31 03:00:00+00	2025-10-08 03:00:00+00	COMERCIAL	Etapa 1 importada
65500d82-fb05-4548-8e3b-c2a87b8b4c7c	4aeeeb58-99d3-490a-8434-be89120f4762	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-08-30 03:00:00+00	2025-10-06 03:00:00+00	COMERCIAL	Etapa 1 importada
43dde686-8247-4c1d-97a7-ac08708c0ed9	fbaf8efe-0c9a-4b2d-8b80-ca8a7f3a1f15	1	4167beb8-ce39-4fd3-8314-8b3487879d92	f41ff939-bc00-4bbd-8ce8-c451922ba284	f41ff939-bc00-4bbd-8ce8-c451922ba284	2025-09-04 03:00:00+00	2025-09-16 03:00:00+00	COMERCIAL	Etapa 1 importada
a3024323-0840-4254-80d6-b630ceb34325	3c2cce97-783f-4d0c-a9f9-fb9b8d7b2d17	1	6af901f6-bd7d-4bc7-8c9d-f441e526e65c	\N	\N	2025-09-10 03:00:00+00	2025-10-20 03:00:00+00	COMERCIAL	Etapa 1 importada
4af56a05-9a53-4f82-954a-483e586659d5	b7434a04-3b64-4168-80b6-2e3b7a9f8675	1	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-09-11 03:00:00+00	2025-10-01 03:00:00+00	COMERCIAL	Etapa 1 importada
e8bf872e-f85a-476d-a1fe-a5889a422726	cc24d84d-ba71-40b9-8151-92323119d482	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-09-11 03:00:00+00	2025-10-18 03:00:00+00	COMERCIAL	Etapa 1 importada
09696e39-6ced-4dd4-ab03-2b34e68d68c4	64504245-b7b7-4e92-80ad-cfdb7d18e83b	1	4167beb8-ce39-4fd3-8314-8b3487879d92	\N	\N	2025-09-13 03:00:00+00	2025-10-13 03:00:00+00	COMERCIAL	Etapa 1 importada
3dcaa194-232b-4a88-bbb6-48ddab3bb271	08476a6d-7120-4f53-b222-7958aa0ff895	1	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-10-14 03:00:00+00	2025-11-08 03:00:00+00	COMERCIAL	Etapa 1 importada
10a39459-405c-45dc-bafe-1da03c4adff3	63a550cb-4b46-4392-aa6b-daf68171a61a	1	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-10-15 03:00:00+00	2025-11-08 03:00:00+00	COMERCIAL	Etapa 1 importada
7ffa9cd2-a40a-4d9b-bb15-3eb7cda32fda	7e201eae-7c97-485c-9670-915d228402e3	1	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-10-11 03:00:00+00	2025-12-21 03:00:00+00	COMERCIAL	Etapa 1 importada
0981e11d-eaa6-418f-800b-a31604de7ab1	26138cad-87d4-482f-9e82-3a5b24e0c2c8	1	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-10-11 03:00:00+00	2025-12-07 03:00:00+00	COMERCIAL	Etapa 1 importada
509f98e2-0dcf-4f96-bd20-bd2ecf3ac1f1	54cef98c-4772-40b4-9f04-80a878694497	1	92d9acc2-3590-474f-a773-73e8af728e83	b8a55941-9f65-4e90-bea1-3683753d42b5	b8a55941-9f65-4e90-bea1-3683753d42b5	2025-09-16 03:00:00+00	2025-11-19 03:00:00+00	COMERCIAL	Etapa 1 importada
2f8caf01-752b-42cf-8b7b-0a75ed69ed46	d6df112f-d895-4076-89b7-b17f522b77c1	1	4167beb8-ce39-4fd3-8314-8b3487879d92	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-09-19 03:00:00+00	2025-10-07 03:00:00+00	COMERCIAL	Etapa 1 importada
98a492c7-9d72-4b82-8208-5cab5fa82c3d	911f04d3-2611-418a-ab6c-85273c1c54f4	1	92d9acc2-3590-474f-a773-73e8af728e83	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-09-29 03:00:00+00	2025-10-30 03:00:00+00	COMERCIAL	Etapa 1 importada
ebd7b98e-c498-4ba4-8835-682c8c8613b6	dccb9d7c-b9d8-4f58-9269-ec88c8221976	1	92d9acc2-3590-474f-a773-73e8af728e83	f41ff939-bc00-4bbd-8ce8-c451922ba284	f41ff939-bc00-4bbd-8ce8-c451922ba284	2025-09-28 03:00:00+00	2025-11-07 03:00:00+00	COMERCIAL	Etapa 1 importada
91023c89-61fa-478d-b3a8-1420f9515dc3	d8a1275d-9257-41a4-ae2b-b82d52c3b637	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-09-30 03:00:00+00	2025-10-05 03:00:00+00	COMERCIAL	Etapa 1 importada
f7f31945-46fd-4de5-b3fe-5d8f416e0408	d8a1275d-9257-41a4-ae2b-b82d52c3b637	2	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-10-07 03:00:00+00	2025-10-12 03:00:00+00	COMERCIAL	Etapa 2 importada
dbdb2aba-8e6a-4002-b42c-92626ec38904	d8a1275d-9257-41a4-ae2b-b82d52c3b637	3	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-10-14 03:00:00+00	2025-10-18 03:00:00+00	COMERCIAL	Etapa 3 importada
da5eba55-1a3a-4dc7-a141-eaeee4ef238e	d8a1275d-9257-41a4-ae2b-b82d52c3b637	4	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-10-20 03:00:00+00	2025-10-24 03:00:00+00	COMERCIAL	Etapa 4 importada
479f323a-bb6b-4e27-9f68-ba67e6b25b6b	d8a1275d-9257-41a4-ae2b-b82d52c3b637	5	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-10-26 03:00:00+00	2025-10-31 03:00:00+00	COMERCIAL	Etapa 5 importada
4b56a3ab-00c3-4075-80c7-a1a82284e116	d8a1275d-9257-41a4-ae2b-b82d52c3b637	6	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-11-01 03:00:00+00	2025-11-09 03:00:00+00	COMERCIAL	Etapa 6 importada
321d5189-7c90-4d2b-b9c9-bf28963c772e	5676b02b-3aa8-4744-a6a1-9d16eaec0a3f	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-10-14 03:00:00+00	2025-11-23 03:00:00+00	COMERCIAL	Etapa 1 importada
3f1cf111-a5b1-470f-bee5-684bd201c28a	80616398-f6b9-4201-b08d-b39d5eb67ca4	1	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-10-11 03:00:00+00	2025-12-07 03:00:00+00	COMERCIAL	Etapa 1 importada
4df3a410-28b7-4605-afa9-33f95f52539b	deb918b8-73e6-4c2d-9cd7-1e614d2e048e	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-10-19 03:00:00+00	2025-10-23 03:00:00+00	COMERCIAL	Etapa 1 importada
9ce50dd9-54cd-419f-bee5-a2b990ac6942	deb918b8-73e6-4c2d-9cd7-1e614d2e048e	2	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-10-24 03:00:00+00	2025-10-29 03:00:00+00	COMERCIAL	Etapa 2 importada
d5724a7a-410a-40c5-a8f0-a139db1a29e4	deb918b8-73e6-4c2d-9cd7-1e614d2e048e	3	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-11-03 03:00:00+00	2025-11-10 03:00:00+00	COMERCIAL	Etapa 3 importada
974b7578-e578-4db0-8ea8-e3a202cc561d	840d1c7b-9747-4b06-b53b-697e644a53ea	1	6af901f6-bd7d-4bc7-8c9d-f441e526e65c	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-10-30 03:00:00+00	2025-12-11 03:00:00+00	COMERCIAL	Etapa 1 importada
7ecd74a4-e5f2-4f9f-a9cd-746cdc77fde5	fec0ddd6-f0b4-40ae-bf31-03d15f45241b	1	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-10-23 03:00:00+00	2025-11-26 03:00:00+00	COMERCIAL	Etapa 1 importada
dfcec0df-ab98-4439-b860-0b6f55313063	2dcf9357-bd8b-4020-9594-c42604b0ea0a	1	92d9acc2-3590-474f-a773-73e8af728e83	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-10-29 03:00:00+00	2025-11-20 03:00:00+00	COMERCIAL	Etapa 1 importada
dbdb79b5-1477-4137-b5c9-6680edf4d83b	12b7645b-a848-44ac-a2c7-f47f748f1cc6	1	6af901f6-bd7d-4bc7-8c9d-f441e526e65c	\N	\N	2025-10-27 03:00:00+00	2025-12-07 03:00:00+00	COMERCIAL	Etapa 1 importada
fcec85f8-6c40-4a3a-9144-40bd7d59bc86	70ec1fd8-6559-4e17-850f-dfbffe164b2b	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-11-04 03:00:00+00	2025-11-12 03:00:00+00	COMERCIAL	Etapa 1 importada
4a7a1d75-4456-4421-b91b-695c2fd874d1	70ec1fd8-6559-4e17-850f-dfbffe164b2b	2	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-11-14 03:00:00+00	2025-11-18 03:00:00+00	COMERCIAL	Etapa 2 importada
cbfeab2c-6896-4b24-957b-a80c27d6dc38	70ec1fd8-6559-4e17-850f-dfbffe164b2b	3	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-11-22 03:00:00+00	2025-11-27 03:00:00+00	COMERCIAL	Etapa 3 importada
b752f199-5120-4278-89ed-d81eefa6acb2	70ec1fd8-6559-4e17-850f-dfbffe164b2b	4	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-11-30 03:00:00+00	2025-12-06 03:00:00+00	COMERCIAL	Etapa 4 importada
745376ad-ad11-4c73-8259-cac35cf67f4c	42c2367a-8542-4763-9f89-02780bbeea8e	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-11-01 03:00:00+00	2025-11-12 03:00:00+00	COMERCIAL	Etapa 1 importada
e274df2b-2ad6-4afe-9f56-607f3c84cd10	dd030597-448a-41db-b591-608b47597a5e	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-11-03 03:00:00+00	2025-11-12 03:00:00+00	COMERCIAL	Etapa 1 importada
6dab3a91-422d-4104-a0f1-83a4420ab0c4	dd030597-448a-41db-b591-608b47597a5e	2	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-11-14 03:00:00+00	2025-11-21 03:00:00+00	COMERCIAL	Etapa 2 importada
6fd36f3e-b092-4535-92c3-4fdfcead634c	dd030597-448a-41db-b591-608b47597a5e	3	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-11-23 03:00:00+00	2025-12-01 03:00:00+00	COMERCIAL	Etapa 3 importada
d5d9e985-9d3d-481e-8b01-f9497ffc4fb5	dd030597-448a-41db-b591-608b47597a5e	4	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-12-03 03:00:00+00	2025-12-11 03:00:00+00	COMERCIAL	Etapa 4 importada
d9302d5f-6309-4585-9bd5-62b36b690c56	e1421d6b-6654-4314-b373-0c7aef292054	1	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-11-07 03:00:00+00	2025-11-25 03:00:00+00	COMERCIAL	Etapa 1 importada
54681b8d-41c9-4ee7-bd71-dd26e1605244	e1421d6b-6654-4314-b373-0c7aef292054	2	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-11-28 03:00:00+00	2025-12-21 03:00:00+00	COMERCIAL	Etapa 2 importada
5afa14bf-7e09-4001-aa18-ee216a125059	89a552ad-3649-45e6-9e48-9029a4629763	1	\N	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-11-04 03:00:00+00	2025-11-11 03:00:00+00	COMERCIAL	Etapa 1 importada
45611c7a-4060-42d6-b0de-4ed6013dc781	ecfe7292-b255-4865-bb32-5949e22b7802	1	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-11-12 03:00:00+00	2025-12-24 03:00:00+00	COMERCIAL	Etapa 1 importada
c7471cca-cf46-43f5-af61-87844c00e374	18873c09-e4fc-493b-b80b-ec01ae1eb66e	1	6af901f6-bd7d-4bc7-8c9d-f441e526e65c	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-11-10 03:00:00+00	2025-12-12 03:00:00+00	COMERCIAL	Etapa 1 importada
3800b073-14dc-4e2f-81cd-6bfb26da12c9	1d3796e9-5936-4785-9a48-2b5ecb48a7be	1	92d9acc2-3590-474f-a773-73e8af728e83	b8a55941-9f65-4e90-bea1-3683753d42b5	b8a55941-9f65-4e90-bea1-3683753d42b5	2025-11-20 03:00:00+00	\N	COMERCIAL	Etapa generada automáticamente (sin desglose)
71f99bac-46dc-49dc-af66-07213f5d9b90	fc13e177-c80d-4b35-98ed-bdfb707663cc	1	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-11-20 03:00:00+00	\N	COMERCIAL	Etapa generada automáticamente (sin desglose)
c746c1d4-1b8f-405a-b3ac-f8c384c225c8	c7504351-7144-4384-bd61-a5968f0bfe57	1	92d9acc2-3590-474f-a773-73e8af728e83	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-11-26 03:00:00+00	\N	COMERCIAL	Etapa generada automáticamente (sin desglose)
18dfb601-91e3-40e8-b56a-b7f70e8e722b	68d4e4c7-151f-4a33-a2d6-a1a2ac165e9f	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-12-01 03:00:00+00	2025-12-16 03:00:00+00	COMERCIAL	Etapa 1 importada
3788c947-4062-48fd-a08c-88821b936ae9	a5e4657e-38f5-4130-a6ef-08d685fbddad	1	6af901f6-bd7d-4bc7-8c9d-f441e526e65c	\N	\N	2025-12-15 03:00:00+00	\N	COMERCIAL	Etapa generada automáticamente (sin desglose)
f366d627-4a7d-485b-bf15-acf869dcb4cb	47bc925f-8a76-467f-8a92-30b22cf33c75	1	92d9acc2-3590-474f-a773-73e8af728e83	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-12-29 03:00:00+00	\N	COMERCIAL	Etapa generada automáticamente (sin desglose)
72543581-2475-44a7-8b85-804161fa8213	1499b680-ec86-4123-8e28-0bead9519301	1	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-12-26 03:00:00+00	\N	COMERCIAL	Etapa generada automáticamente (sin desglose)
d2804c2e-a528-4b87-9231-f8da2e283aa3	841c4ec4-edbf-4b07-8063-2e84f2680fff	1	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	f41ff939-bc00-4bbd-8ce8-c451922ba284	f41ff939-bc00-4bbd-8ce8-c451922ba284	2025-12-29 03:00:00+00	\N	COMERCIAL	Etapa generada automáticamente (sin desglose)
4030df33-e313-4da4-9a55-ea22058bb755	6a925c67-2c02-43e9-9496-fd3975160424	1	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	105b0349-a9ed-49bf-9336-aad8d3867f0b	105b0349-a9ed-49bf-9336-aad8d3867f0b	2025-12-29 03:00:00+00	\N	COMERCIAL	Etapa generada automáticamente (sin desglose)
3bb673ef-c7b0-40e4-81a9-74da58971c86	abde28b8-9542-4be9-8694-da80f5e0b196	1	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	\N	\N	2025-12-26 03:00:00+00	\N	COMERCIAL	Etapa generada automáticamente (sin desglose)
3f7a9e2a-866a-4cb1-b260-6bf8e6005087	32942ae8-dac2-4d9e-8ef2-3ffe43237c17	1	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	\N	\N	2025-12-26 03:00:00+00	\N	COMERCIAL	Etapa generada automáticamente (sin desglose)
4992fd90-c4e2-4a72-85ac-39e5a1f5b974	7d5358c9-5ca9-4d3d-a59a-e2363c9f6d8d	1	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-12-26 03:00:00+00	\N	COMERCIAL	Etapa generada automáticamente (sin desglose)
5227126d-7419-482a-936f-aa47ebca2486	6d1f181a-37a4-40a6-83fb-4a4ad95c332e	1	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-12-30 03:00:00+00	\N	COMERCIAL	Etapa generada automáticamente (sin desglose)
96f71fc0-19c3-4a74-ba9c-5fb8d5ebcd94	d0080183-5a28-4940-8b62-d0916fb6ea45	1	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-12-23 03:00:00+00	\N	COMERCIAL	Etapa generada automáticamente (sin desglose)
cd83dde5-4c4c-4583-9b81-da03688ddc1f	de4b51fc-abf4-4fa4-b1bc-027e6d33908c	1	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-12-30 03:00:00+00	\N	COMERCIAL	Etapa generada automáticamente (sin desglose)
8d7c7b92-155d-4761-977b-51fbc5798a3a	239c4c23-fbcd-43fd-88d5-02c4d4601349	1	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-12-29 03:00:00+00	\N	COMERCIAL	Etapa generada automáticamente (sin desglose)
6282e5de-d67c-4ef0-a5f1-fae17ddae5cf	f091515a-3a09-4d2d-aaad-839f884a6ec5	1	6af901f6-bd7d-4bc7-8c9d-f441e526e65c	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-12-26 03:00:00+00	\N	COMERCIAL	Etapa generada automáticamente (sin desglose)
355ea204-2e97-47d2-9b82-92a5c77307ee	e6685824-1f78-44d1-a67e-61b80de14ac0	1	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-12-28 03:00:00+00	\N	COMERCIAL	Etapa generada automáticamente (sin desglose)
87fb2325-8144-46e6-986c-cb0221973208	99da2fe8-8c72-4174-a1f5-26e38069ba49	1	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-12-28 03:00:00+00	\N	COMERCIAL	Etapa generada automáticamente (sin desglose)
504dbc20-29fe-4273-b1da-afe4d9b32f56	d06453ee-c376-4333-986f-e02f13988014	1	6af901f6-bd7d-4bc7-8c9d-f441e526e65c	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-12-15 03:00:00+00	2025-12-19 03:00:00+00	COMERCIAL	
9d1653fc-8774-4198-8a13-6d7ccda90032	1009a963-f453-4721-8488-ee5f5e7d710b	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-01-11 03:00:00+00	2025-03-07 03:00:00+00	COMERCIAL	Etapa 1 importada
ce9a362d-bb0e-4e94-85ed-de69994ead91	891568fd-cfd2-4c4c-bfd0-4d9c57f82198	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-01-07 03:00:00+00	2025-01-28 03:00:00+00	COMERCIAL	Etapa 1 importada
37998e8c-e6e6-4a93-9c88-613f9180ae65	d7097607-d295-4981-a72f-090793ba8c33	1	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-01-08 03:00:00+00	2025-02-02 03:00:00+00	COMERCIAL	Etapa 1 importada
e161c3a6-63b0-449d-97a3-857bfb55d218	30770969-bb3b-49c0-b015-1420bf2d18ee	1	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	f41ff939-bc00-4bbd-8ce8-c451922ba284	f41ff939-bc00-4bbd-8ce8-c451922ba284	2025-01-07 03:00:00+00	2025-01-30 03:00:00+00	COMERCIAL	Etapa 1 importada
9530471e-a089-440c-bf93-e06b7e7b4b75	8ed5e8f3-27ff-46bf-b7b1-aba4bf533087	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-01-11 03:00:00+00	2025-01-19 03:00:00+00	COMERCIAL	Etapa 1 importada
bcf49c27-bc7e-48ca-8965-cd370c6a620b	8ed5e8f3-27ff-46bf-b7b1-aba4bf533087	2	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-01-22 03:00:00+00	2025-01-29 03:00:00+00	COMERCIAL	Etapa 2 importada
1737535b-682b-48d8-9393-7a9bbe0018f8	8ed5e8f3-27ff-46bf-b7b1-aba4bf533087	3	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-01-31 03:00:00+00	2025-02-02 03:00:00+00	COMERCIAL	Etapa 3 importada
ad6f7971-625c-4c82-be7d-87350c567fd9	61f3c95e-a80a-4bd0-8498-9eab710811ec	1	6af901f6-bd7d-4bc7-8c9d-f441e526e65c	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-01-06 03:00:00+00	2025-02-07 03:00:00+00	COMERCIAL	Etapa 1 importada
860d11e5-310c-4c4c-a7b0-cf31163d04d7	8997039d-e6d9-4bca-8463-838ac5f6b1fb	1	6af901f6-bd7d-4bc7-8c9d-f441e526e65c	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-01-13 03:00:00+00	2025-02-24 03:00:00+00	COMERCIAL	Etapa 1 importada
1f339cd7-94ca-41f2-9fb9-6ef03f968fbd	cce1ecad-81c4-4625-b825-48009137d8c3	1	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-01-08 03:00:00+00	2025-02-02 03:00:00+00	COMERCIAL	Etapa 1 importada
1dff4349-b566-41d1-b70e-9348a0576aed	e492153b-241c-4895-a772-67ad78b6be33	1	6af901f6-bd7d-4bc7-8c9d-f441e526e65c	\N	\N	2025-01-09 03:00:00+00	2025-02-16 03:00:00+00	COMERCIAL	Etapa 1 importada
db57eee6-facc-4f0b-8b0f-543b8abd5ddf	89b33858-f91c-4971-ab64-227f9ba17371	1	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-01-08 03:00:00+00	2025-02-17 03:00:00+00	COMERCIAL	Etapa 1 importada
71413536-ea05-4ef2-b73d-050be1411c67	e6b7d05c-171a-4ecb-90fb-fb31337da507	1	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-01-09 03:00:00+00	2025-02-13 03:00:00+00	COMERCIAL	Etapa 1 importada
28796850-9a35-415e-97e1-a9b0b27c3379	f547dedc-96f2-4ad3-86da-92a1373f5109	1	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-01-12 03:00:00+00	2025-01-19 03:00:00+00	COMERCIAL	Etapa 1 importada
9efd8fe7-233a-4488-ac04-1661bf77f23b	f547dedc-96f2-4ad3-86da-92a1373f5109	2	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-01-20 03:00:00+00	2025-01-26 03:00:00+00	COMERCIAL	Etapa 2 importada
06a34e5a-5c0f-4696-a80a-47669daebeab	f547dedc-96f2-4ad3-86da-92a1373f5109	3	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-01-28 03:00:00+00	2025-02-06 03:00:00+00	COMERCIAL	Etapa 3 importada
db058076-c652-4623-8c27-24a36499ae1f	f547dedc-96f2-4ad3-86da-92a1373f5109	4	c1692b3c-2c33-4957-8bcb-208f45e4534b	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-02-07 03:00:00+00	2025-02-12 03:00:00+00	COMERCIAL	Etapa 4 importada
e65c26a3-52aa-41fb-a88f-7f2f737abde1	38c30a58-515e-4bb0-b785-783a38baab82	1	6af901f6-bd7d-4bc7-8c9d-f441e526e65c	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-01-17 03:00:00+00	2025-03-01 03:00:00+00	COMERCIAL	Etapa 1 importada
9b467eaf-0059-4f3b-a738-815d83de5089	9c7616fa-5388-4f5a-a182-323048a74273	1	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	105b0349-a9ed-49bf-9336-aad8d3867f0b	105b0349-a9ed-49bf-9336-aad8d3867f0b	2025-01-16 03:00:00+00	2025-01-18 03:00:00+00	COMERCIAL	Etapa 1 importada
ba0b8574-30a9-46a9-a3a9-65a2231052c5	640d4643-f206-4c34-a756-ef14e6c99a79	1	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	\N	\N	2025-01-16 03:00:00+00	2025-03-11 03:00:00+00	COMERCIAL	Etapa 1 importada
d3717f48-3cd5-4a17-a2f7-a7db7f28f2bc	4c7760d3-eef2-49a2-bd90-ec74d9d2b3ed	1	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	11c64a29-e693-4bef-b734-8162f86cbbcc	11c64a29-e693-4bef-b734-8162f86cbbcc	2025-01-27 03:00:00+00	2025-02-07 03:00:00+00	COMERCIAL	Etapa 1 importada
a4ac087b-9be4-41eb-9eea-0374230d5289	6f309917-3dfe-408c-bb64-c2f226f2316c	1	543aa4a7-f29e-4c08-b04f-62377d3cc0e6	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-02-03 03:00:00+00	2025-03-11 03:00:00+00	COMERCIAL	Etapa 1 importada
243ddbe2-4dfe-447c-b79f-39bdadfc840e	2ffe1eb4-87db-49fc-bba7-f89f742be443	1	92d9acc2-3590-474f-a773-73e8af728e83	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-01-03 03:00:00+00	2025-01-03 03:00:00+00	COMERCIAL	Etapa 1 importada
1a14a7d0-1bed-4e13-aee7-f5ed3c10d6f3	88d8de1d-3229-4290-bd9b-8bac988cb4ae	1	92d9acc2-3590-474f-a773-73e8af728e83	f41ff939-bc00-4bbd-8ce8-c451922ba284	f41ff939-bc00-4bbd-8ce8-c451922ba284	2025-01-28 03:00:00+00	2025-01-28 03:00:00+00	COMERCIAL	Etapa 1 importada
89abf8a8-1795-43b8-9d32-a6ddf115b379	855ed6f3-5a13-41d4-a6b3-bf85b2fd720f	1	7f47bb40-1035-438a-ba95-a0ac1b2cf3ad	34aeab48-9c9b-4c06-8a45-3469f866cf88	34aeab48-9c9b-4c06-8a45-3469f866cf88	2025-01-03 03:00:00+00	2025-03-04 03:00:00+00	COMERCIAL	Etapa 1 importada
\.


--
-- Data for Name: mareas_etapas_observadores; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.mareas_etapas_observadores (id, id_etapa, id_observador, rol, es_designado) FROM stdin;
db58ddea-412e-4094-a894-a6fcd23f6d98	3e870e30-a3ae-4401-b8c1-f377021129ee	4b60b333-fea6-45cd-bec9-c5eb06a8cd1c	PRINCIPAL	t
12b0c3e9-fcd8-48c3-a634-dd1868e54d6e	9af08888-e32c-4062-a997-5290e7b4dec4	dfbdeeff-4e60-46c2-9ce0-7becb9a494a2	PRINCIPAL	t
bff9dcbe-8564-4802-b1b3-53a8b6b1ffd0	d7d2bb40-f676-4899-906a-7dde7ea3bd0c	d7785cda-1f2e-4d29-a52d-335b2096bde6	PRINCIPAL	t
5ecafc34-da0b-4620-86e2-a98e6a85423b	58a24d0b-fdd3-4046-8ced-257f2e367924	e82e6994-7b2a-4fd4-a699-665a2c81d083	PRINCIPAL	t
84e537a9-97a8-499c-a980-19f5429bb597	1418505d-4efc-4f00-9498-09c7197a7f33	b500d7bc-3760-4c88-9a21-4294b2395c71	PRINCIPAL	t
6e6a9c4b-700e-49c3-b5a0-a9a208256e14	1bb1b2c6-fbb9-41e8-bd47-224fc90ebc66	f60ed9ea-004f-41a9-9d6a-4f34923b1728	PRINCIPAL	t
df8ec6f7-5187-4441-a227-fad0967969f2	2a7b5234-e133-4150-bd79-7cb8337da1c6	9a9b3bcd-4b8f-4aba-8ea5-3ec890e23fee	PRINCIPAL	t
458deeb9-7d1c-4f5f-8fdc-2a42e84771c0	29d58fb0-f7bf-42b7-b475-2034e40266de	9ca0a15b-a857-4fab-9747-b620717776dd	PRINCIPAL	t
43409cf2-dcf1-459c-a4f2-914e04af9fd0	edad3627-6e29-4620-aa6e-de7ccb7c85e4	66d4eb59-5d54-446b-9ee0-88fa9c133899	PRINCIPAL	t
140450d6-0e52-4e0e-8cd8-ba4c5a962ff1	1b19284e-c88e-4710-a914-83b06e5e7bbb	6abcf5ef-ae58-4e8c-ae86-335d1478ee3c	PRINCIPAL	t
6678e8cf-92db-425c-bc62-0041bc0b5882	01c6479f-a8e8-4ada-a0eb-5efa6a684a5d	cd4b5edd-c793-4367-869f-a955a17d8a11	PRINCIPAL	t
10f8cad8-80ad-4730-b49c-48d353a236f8	e266f665-24dc-468c-ac5f-20bada3eb06e	cd4b5edd-c793-4367-869f-a955a17d8a11	PRINCIPAL	t
11228c30-d946-4ad8-a801-130a6bf18b58	bcddb3e9-5a97-44c1-989a-35cb627c0f9a	f0a415e0-9538-4336-b681-9d23e0753e26	PRINCIPAL	t
a89252bc-8080-4931-9e96-00e4a64a430f	c0972778-9663-497f-99de-6ed0e8a32b05	f0a415e0-9538-4336-b681-9d23e0753e26	PRINCIPAL	t
fade8265-b71e-4b98-9c8c-3de65f41153b	1aea25f0-ca74-434f-90d2-db9168be3607	cded2d3e-5f9e-4de6-9269-a1da3eeeff0a	PRINCIPAL	t
8ce65237-33f8-4e7e-b16c-a16120f2ee16	ec452251-be4d-437c-8d60-783b24424b46	cded2d3e-5f9e-4de6-9269-a1da3eeeff0a	PRINCIPAL	t
08b1cf70-678a-4554-9642-f711d68f565b	baae2ec9-ad48-4f50-94af-e4b9375c1bec	d7785cda-1f2e-4d29-a52d-335b2096bde6	PRINCIPAL	t
67a76916-0ddc-48c0-8ba3-f1135aff46f1	f3fe276f-35b7-49a4-8a1b-2b3e3e2922f2	d7785cda-1f2e-4d29-a52d-335b2096bde6	PRINCIPAL	t
35425469-5500-466d-bebe-b19bb51cbaf4	5ea22ed4-f675-4b7e-8519-a131ffd0c97d	dae8fea3-9440-4fd0-8212-7c8d9c5f4f20	PRINCIPAL	t
460514dd-9937-4ccf-b890-eda57dd86338	46eb726d-24b6-42ec-87b2-4f17ea8bd326	dae8fea3-9440-4fd0-8212-7c8d9c5f4f20	PRINCIPAL	t
b1a51cbb-f2ea-4f90-b709-f1d18b3cdc29	db8f7163-5186-4c49-ab66-9d7a94545a48	b9333c64-fa8a-4d22-971b-8447d9cec902	PRINCIPAL	t
4d963c80-2407-4d99-8f77-305b69945079	addc4d3e-fb88-49a9-a749-0a0381141b15	7210834c-47be-440a-81d2-a5fc53a8934b	PRINCIPAL	t
4e8b7348-9ece-489b-84d6-b1805cd824d7	046fca90-a1f5-48e0-ac88-db2fde6b0c9c	fb61c911-79f8-45ed-8e0e-23bfa3a9ad2b	PRINCIPAL	t
17c073ab-1dc6-4469-b6d6-6938e60455f7	2298767a-e9dd-484c-86f8-c0c21ba485be	06979c36-da6e-4fb0-840e-07533a1d41c7	PRINCIPAL	t
cb4edd4d-84f9-4bda-a697-a57514642c3e	749d60a0-d908-4523-9474-b7cfecb5b597	d1d949b7-00fd-4756-8021-bc80d98ecf71	PRINCIPAL	t
c7c1332e-2ed4-4371-aace-f40d39fa9a4a	4fd45a64-46ee-45cd-a09b-09eb77f07011	d88e7e56-7d2c-4edc-aef4-f61e755c586a	PRINCIPAL	t
20a552d1-0eb0-40bc-baba-6625f0ae6ec3	dddfddcd-6808-49fe-93a1-b525e266e339	3aab4c36-1982-4957-8f29-192aba668488	PRINCIPAL	t
550dfc37-c98e-4c55-8493-6d3d4ec2c259	500ac431-1c89-4bad-a558-a9a8ad38ff23	9ca0a15b-a857-4fab-9747-b620717776dd	PRINCIPAL	t
c0a59d1c-7b7b-4421-93bd-49711ecefceb	9c454da8-a2ce-47ce-b75b-d887753651af	ba8ec778-639d-4dcd-9db2-d7100c84e8f5	PRINCIPAL	t
55a7317a-5912-466b-9936-2c1d3bc3354d	157b4484-7417-4b78-99f4-b387d84bd271	b6f9e1cc-7022-4f80-8f1d-a8392c9193df	PRINCIPAL	t
36e19282-99f9-48a8-acff-bb82a8162c27	c3c6c893-1c29-48bf-8a9d-25092a69e2f7	dae8fea3-9440-4fd0-8212-7c8d9c5f4f20	PRINCIPAL	t
d5ff0d2d-ff3e-437c-a42d-418636e9a610	dedcc07e-2050-4653-bc46-11d26579a2dd	6abcf5ef-ae58-4e8c-ae86-335d1478ee3c	PRINCIPAL	t
dbd125b2-36fe-48af-ad13-bc6d8c622100	c34aeca6-6397-4a8e-bd65-8c968b1f91d0	f644ca0f-bf5f-4449-9c40-7eba742654de	PRINCIPAL	t
d67d2d35-b25c-48d7-bc0d-9419e8b472c3	732207d1-4352-4953-b114-809c06bf4a00	8ced3542-9444-4153-b141-27ed65a5995b	PRINCIPAL	t
08ba51cd-11e4-4580-8869-98eda0ca2fc7	c62465fa-1330-4c44-87d2-d6250ea4e2d0	f0a415e0-9538-4336-b681-9d23e0753e26	PRINCIPAL	t
ee8c0de0-bd59-4562-9e05-b6870e6ca19d	151eeecb-6871-4103-af86-36db2ad853e8	d7785cda-1f2e-4d29-a52d-335b2096bde6	PRINCIPAL	t
58849662-54d8-4deb-bb36-ca29bccef1da	95dfa235-56f5-4877-9ff0-74e54d569585	cd4b5edd-c793-4367-869f-a955a17d8a11	PRINCIPAL	t
10510b87-48c3-4c67-86d6-f5db59f713a1	c9747462-e6ee-4baf-b7a0-49b8df7f51cb	cd4b5edd-c793-4367-869f-a955a17d8a11	PRINCIPAL	t
02580117-1e86-4de3-98a9-cd99580acbc9	a93f27af-970c-42b2-b72b-505333b05510	cd4b5edd-c793-4367-869f-a955a17d8a11	PRINCIPAL	t
776f0df6-3c1b-46b9-99e0-f336f68cab05	486d631a-9717-43cf-8b51-096d77904347	372bbb60-ca31-49ff-9ef9-fd5d49beb720	PRINCIPAL	t
f2adb0b7-b540-4a56-b011-297c47036878	9e2dc75a-115d-420e-b8f4-4d7cd22944ad	ccd3c2b4-fdfd-4d4e-b6c6-1a0dbbc02cf3	PRINCIPAL	t
750659ae-10f9-42e5-b9bb-e0465cb1a5ae	b722095c-3420-49fc-835b-c4dc6196be40	ccd3c2b4-fdfd-4d4e-b6c6-1a0dbbc02cf3	PRINCIPAL	t
c1f10f5e-32ef-447d-96f1-db5c924dd24e	97d36b33-a691-4585-8483-80885c723e14	ccd3c2b4-fdfd-4d4e-b6c6-1a0dbbc02cf3	PRINCIPAL	t
c5c6fea4-6c48-426d-a8c5-11f46d5ae410	d8234ba3-6d11-4cf4-ab12-47a3992a9982	cded2d3e-5f9e-4de6-9269-a1da3eeeff0a	PRINCIPAL	t
5f1f159a-fffb-40cb-a3a5-4c18b4ec89ab	06b11cde-5352-4b36-95d0-5aedaad5055c	cded2d3e-5f9e-4de6-9269-a1da3eeeff0a	PRINCIPAL	t
1c7865f0-1b0b-4aee-8885-36d67ab8651d	3193e0fd-04bc-4567-a56d-e44b975312d0	e148f60c-2aeb-442f-b302-491f4e0eca2b	PRINCIPAL	t
89d2c4e2-96c4-45fc-8098-8de32ddd2e91	99e6e73f-2e31-4bfb-9c59-4b6ce4305e15	0d45342c-ecad-45a7-bb51-ebce9779c000	PRINCIPAL	t
324e673c-4a3e-45f0-8784-fdbbccc75307	2838cc2e-66be-4d23-bd94-01121597f25c	0d45342c-ecad-45a7-bb51-ebce9779c000	PRINCIPAL	t
2b94da0d-7a6f-4cb0-8703-da45145e07ee	c2414831-796a-41e0-ae5e-d2e056735a28	0d45342c-ecad-45a7-bb51-ebce9779c000	PRINCIPAL	t
4365988e-6f1b-405b-b7f3-df6223466118	5896af70-02cf-4b19-b4ad-c034960aefe0	06979c36-da6e-4fb0-840e-07533a1d41c7	PRINCIPAL	t
321f1c23-2172-4c33-bd43-16098a3dfc0e	98857039-ae1e-45f3-9680-fbd75efe9413	30fef00d-f9ee-4362-b430-5819b4bde400	PRINCIPAL	t
0c7c547c-9737-4a7d-a012-6d69f4a76bd7	4a1a9bb2-8aa1-4080-8a01-b6b61c6f1bf4	30fef00d-f9ee-4362-b430-5819b4bde400	PRINCIPAL	t
27be8d7c-b104-4f37-a5e6-bf503027dc2e	dc28d960-10d7-45e3-b33e-e61bcf7e679b	1f6c3850-8006-4a96-a8b9-96c068b8dbee	PRINCIPAL	t
02eb7460-6923-4da3-acfb-ee2e201c5005	22b25059-a61a-4e74-9dcd-59cf9e8efc38	a21b30af-c563-4c43-9d68-bafd0243c5e6	PRINCIPAL	t
e3a62ffd-98d8-43dc-968f-65637841616e	17814177-3623-4279-b7cf-c52271b8f123	c8fdee90-2d16-4800-8a4d-e6b470cf152d	PRINCIPAL	t
5d71f3ce-3414-45bf-b6c7-d9b1629db38e	27102d32-1b6f-4dbe-a315-ff516570b127	c8fdee90-2d16-4800-8a4d-e6b470cf152d	PRINCIPAL	t
014306bd-0eb3-4fca-abcc-3825432a4d43	0f90c115-66cd-4848-b78d-203dcc9478ca	c8fdee90-2d16-4800-8a4d-e6b470cf152d	PRINCIPAL	t
7ead851c-fa36-4510-a0e2-8c80b4783d90	10405f4f-6608-49fc-a0f5-bc59d82b6f8a	fb61c911-79f8-45ed-8e0e-23bfa3a9ad2b	PRINCIPAL	t
cb20b7e3-0116-44ab-909c-7c8aac4aaa83	48b29034-8595-451f-9c4c-a4dfe562f46d	b33fd685-31a6-4510-a970-09a2d428a1bb	PRINCIPAL	t
d9fc2dba-48bf-4066-90c5-1318c70a5607	3d71f003-89db-440f-b8de-fc425109df6c	b500d7bc-3760-4c88-9a21-4294b2395c71	PRINCIPAL	t
476b9279-b916-4b4a-9c7f-7ba3f92bc6d1	1e995e88-4520-43e1-b51f-48635b05f93d	b9333c64-fa8a-4d22-971b-8447d9cec902	PRINCIPAL	t
5816108e-7e50-4e54-bacc-14f177b93223	1e27eeb6-a775-412e-a766-c42f9573e029	a4846d61-d1ba-4641-b155-1dc30725e33a	PRINCIPAL	t
a24a6128-e994-4502-9bc5-67f63e97b443	1b010a98-ed5b-4a6f-b05b-319862e3c748	8ef5a63a-64fd-4821-bc0b-a785c10a056f	PRINCIPAL	t
8588d936-7ffb-400b-a80e-54299f70168e	8eeadbc4-2299-46d1-86c5-876e0874a3ab	dfbdeeff-4e60-46c2-9ce0-7becb9a494a2	PRINCIPAL	t
864a5a96-be96-4cf3-8315-892c25efaa43	cc1ff641-fefd-44d9-af4d-989631d891c7	7210834c-47be-440a-81d2-a5fc53a8934b	PRINCIPAL	t
bc6678eb-65d0-405e-baff-0c407258a1b3	88ab7e6c-9a34-4d13-addb-804a897facd1	66d4eb59-5d54-446b-9ee0-88fa9c133899	PRINCIPAL	t
1f80e581-5714-4d08-8922-4f3db1b32ec8	9a840e34-3f0a-4b11-8c95-26d118b9aa63	a8bff414-46d6-4502-9537-eeda82ec5fa8	PRINCIPAL	t
d8a93df2-c457-47bf-b0c4-8f6fc6c5d24b	7b11b129-39ee-454e-b242-f8ca50b38e3c	8644b80c-97af-46cf-9f4d-711749582de1	PRINCIPAL	t
463ef5fb-8ea4-4aac-84fd-15f2563a5661	36ed6f7c-ac14-4bf9-a0e0-c6bd18edef6a	f60ed9ea-004f-41a9-9d6a-4f34923b1728	PRINCIPAL	t
c3b3ae3b-cb86-4217-8cf6-e12eddfb1398	12effdc4-5a42-40cb-a4b9-1d2f06974cde	ba8ec778-639d-4dcd-9db2-d7100c84e8f5	PRINCIPAL	t
0f67af63-4105-45db-bfa6-baa058103d62	5e09b86c-63de-45cf-8b20-27564b31cc6b	9a9b3bcd-4b8f-4aba-8ea5-3ec890e23fee	PRINCIPAL	t
754a8286-96c1-483f-aa87-7ef6d09ac429	73401057-2b48-49ba-b414-e0837acf6093	d1d949b7-00fd-4756-8021-bc80d98ecf71	PRINCIPAL	t
7ef41c92-a207-4aea-98ca-7340f9f9255b	37f4e6eb-a0cc-4c14-a624-c49724465951	cd4b5edd-c793-4367-869f-a955a17d8a11	PRINCIPAL	t
3346c083-111e-4f8b-af13-e5c53af5a4f5	1fad73a6-4b80-4eed-abcc-c94722cf67dc	cd4b5edd-c793-4367-869f-a955a17d8a11	PRINCIPAL	t
60857f3c-b005-457a-bc4b-63902fc7a0ac	3e4aeb48-cbe9-4f57-9d59-3e0d5c3d076f	3aab4c36-1982-4957-8f29-192aba668488	PRINCIPAL	t
357034ae-6ca2-4ab3-b821-8d4db8c74137	eb7bc134-8265-4238-bbcf-75a61b04ef8f	c8fdee90-2d16-4800-8a4d-e6b470cf152d	PRINCIPAL	t
b1f4c6ab-5d77-4ac6-abf3-2e8fec180cc3	8653764f-7fc9-4deb-b3f5-80f40aef1e9e	c8fdee90-2d16-4800-8a4d-e6b470cf152d	PRINCIPAL	t
ba1e11b1-7952-4427-b48b-3af83babc261	f896387b-1381-4e0a-9088-7fb7a0d4140b	c8fdee90-2d16-4800-8a4d-e6b470cf152d	PRINCIPAL	t
8b3d5962-4f2f-4bee-8891-111fd32e4a4a	f58cb791-22f4-4e10-a9f9-761e6b0657b6	c8fdee90-2d16-4800-8a4d-e6b470cf152d	PRINCIPAL	t
0ef5b604-8c90-4f9c-adf1-51bc06a5ca96	1e8691fa-31d0-4ba9-9144-7b2880a2384b	cded2d3e-5f9e-4de6-9269-a1da3eeeff0a	PRINCIPAL	t
cf332a4e-f9c9-4d3c-b64e-1a49b7f704c0	d9c9a8ff-1c77-40cb-9d3f-0f6d5cabb62b	372bbb60-ca31-49ff-9ef9-fd5d49beb720	PRINCIPAL	t
2eeab2ae-9d97-4b7e-a9f6-ffc8624e46a4	2a5782a6-61a7-431c-9e63-39e6296fe248	06979c36-da6e-4fb0-840e-07533a1d41c7	PRINCIPAL	t
2571a6a0-455c-4c9f-aece-c6cc39fa83c2	d42dced3-c7c4-496c-ad9b-11047573768d	20b0118b-9612-4fa8-b90c-5e11e27b07e3	PRINCIPAL	t
10213762-f641-42c4-8da9-91f92f73f8e3	3c86675d-fc50-4fa1-a205-b8a4fe8fd75d	20b0118b-9612-4fa8-b90c-5e11e27b07e3	PRINCIPAL	t
018ffa0f-0615-4dfa-abf3-39b9852b6cf9	c161a510-e646-4b38-baa0-9560137da36d	20b0118b-9612-4fa8-b90c-5e11e27b07e3	PRINCIPAL	t
da574fc2-6202-4e13-a9cf-ae7d932544b9	9b6dd9d2-3e01-4921-a077-09cf5b950404	20b0118b-9612-4fa8-b90c-5e11e27b07e3	PRINCIPAL	t
00555ac2-c3ad-46dc-b994-17463b33a2a6	d714fd53-3f75-44aa-9dbd-74d8cd46160b	20b0118b-9612-4fa8-b90c-5e11e27b07e3	PRINCIPAL	t
e82bbb2d-6037-4f0a-8ecd-79b8d7d8527f	075c5467-de40-46c2-98e4-7177146cfcb0	02ed999f-1a0c-460a-8c38-0cc464af9b6f	PRINCIPAL	t
86fbf50f-9d9e-4f65-b4e4-f682ebc50d62	b6d47884-e45b-4058-955d-1edbe0837079	02ed999f-1a0c-460a-8c38-0cc464af9b6f	PRINCIPAL	t
fc0b3420-4026-43e6-8c11-d2f4fc7a3c69	5bf48722-339a-4141-ae6d-c911ae67c85c	8ced3542-9444-4153-b141-27ed65a5995b	PRINCIPAL	t
842acc67-38e4-4116-b99f-f2b153bfd14a	4464a998-a87d-4dc5-a5cd-f83b88bc1b7e	ccd3c2b4-fdfd-4d4e-b6c6-1a0dbbc02cf3	PRINCIPAL	t
9de9591a-71d3-4885-8e7c-16e45539a3a1	88bdbae4-fabf-4c97-8c4c-6f4dcd8b8c76	dfbdeeff-4e60-46c2-9ce0-7becb9a494a2	PRINCIPAL	t
583989bc-3d97-45e8-b831-cfe15a7bd8c0	40b6291a-fc00-4a0a-8f58-682cf3e55350	cd4b5edd-c793-4367-869f-a955a17d8a11	PRINCIPAL	t
b317dd74-7560-47c6-a8c0-3731ac3eae87	be31af4e-e9c2-4faf-a18f-07ec8c24953b	d7785cda-1f2e-4d29-a52d-335b2096bde6	PRINCIPAL	t
7ea3d2fb-4225-4e81-ae5a-69420d0a091f	86f75df3-2cdf-4ca9-b9b1-643792471d26	d7785cda-1f2e-4d29-a52d-335b2096bde6	PRINCIPAL	t
bae3abde-b122-4c3f-820c-00b32c5187f3	1fd3e31a-1807-42f5-9d8c-4573497402d8	7210834c-47be-440a-81d2-a5fc53a8934b	PRINCIPAL	t
c5bcbd63-2396-4857-b8a2-21d26fa7403d	50243639-6c86-4b71-8ecb-650853120909	7210834c-47be-440a-81d2-a5fc53a8934b	PRINCIPAL	t
3c14b036-0dde-497c-b22b-767027567bd0	84ceae64-77e7-4acf-9146-e20930822cf9	7210834c-47be-440a-81d2-a5fc53a8934b	PRINCIPAL	t
b6a356dd-bc9f-4ff6-ace2-91ca97990272	edde090c-9ecb-4ce8-8575-3cbe50426215	7210834c-47be-440a-81d2-a5fc53a8934b	PRINCIPAL	t
3ab4f56d-f865-457c-afd9-ef13cca746a8	66b0f599-8550-4a00-9875-643761430c4f	dfbdeeff-4e60-46c2-9ce0-7becb9a494a2	PRINCIPAL	t
726690c3-e75f-4564-bddf-06771b2c572d	86ef3408-c132-4d65-bafa-33388ee99a73	ccd3c2b4-fdfd-4d4e-b6c6-1a0dbbc02cf3	PRINCIPAL	t
d85ca0e9-8a4a-492f-9686-d9789626216e	43639668-64b7-48ee-8359-17811e02b32c	ccd3c2b4-fdfd-4d4e-b6c6-1a0dbbc02cf3	PRINCIPAL	t
af940c9b-3012-4484-ad49-947d8ac62d65	aad0cb5a-9398-461b-905d-e52bbbaa5175	dae8fea3-9440-4fd0-8212-7c8d9c5f4f20	PRINCIPAL	t
3501aacd-9a3d-4932-a6d5-eb6460fca9a8	7f301173-684e-453f-85af-20ed1319e77b	1f6c3850-8006-4a96-a8b9-96c068b8dbee	PRINCIPAL	t
423cbf59-c61d-4eb1-87ea-24085810eb62	3d7d3823-eacb-45eb-be45-fa78c0367887	1f6c3850-8006-4a96-a8b9-96c068b8dbee	PRINCIPAL	t
4e3ad8b8-b9aa-48ba-b559-b8ba34415414	e9c54d4c-5e00-484b-a840-c21c54d4dcc1	1f6c3850-8006-4a96-a8b9-96c068b8dbee	PRINCIPAL	t
cce28d11-31a1-428f-8277-46e743a8efb0	691b96d9-a0e4-43b2-b23b-2fa018f6ea71	e82e6994-7b2a-4fd4-a699-665a2c81d083	PRINCIPAL	t
5978d6bb-0f53-4ce4-8843-ce5600366797	3bb8ac0a-cbf8-49cb-a79e-e8ba2a5d742b	ba8ec778-639d-4dcd-9db2-d7100c84e8f5	PRINCIPAL	t
1d30f115-9975-44d9-90a0-9830612ce64a	5bc15d47-2006-4379-8b9c-5f9e48dafda4	8ced3542-9444-4153-b141-27ed65a5995b	PRINCIPAL	t
b87c6c1a-6bb2-4e57-b25e-aa2ed17f7d8e	a4826e22-f637-4417-90ff-41363b4c9cef	0b3c7262-8ba3-4ce3-83f7-cc96080f73f0	PRINCIPAL	t
bc4b278c-c9b6-4a9d-92da-622b8e0cdaa5	0be05fd0-f356-4663-94ab-7c2ca60ddea9	b33fd685-31a6-4510-a970-09a2d428a1bb	PRINCIPAL	t
4e9f4c47-1614-4d3c-801d-5751a64a18f7	38d4c115-acd6-49b5-932f-72c5a24f61bb	f0a415e0-9538-4336-b681-9d23e0753e26	PRINCIPAL	t
2e96e5ab-2fe9-44d0-bd37-89649d647a30	5ee48ec4-e5d6-4180-8559-500e05c5bc9f	f0a415e0-9538-4336-b681-9d23e0753e26	PRINCIPAL	t
7816f54c-1bb4-4c50-b0ef-fb1f3b1715b0	0fad13a0-d866-4c7a-89a4-3a2fc22a8d71	f0a415e0-9538-4336-b681-9d23e0753e26	PRINCIPAL	t
4c0ee9a0-2717-47ae-a33d-e9811a1de2b8	a8298bc5-c34e-43b5-8a4d-eee2c8c3b838	f0a415e0-9538-4336-b681-9d23e0753e26	PRINCIPAL	t
f7a9dbcb-e544-450a-bdca-237129facce4	b982cb17-5fe8-4071-b6fc-d9769f5018ac	9a9b3bcd-4b8f-4aba-8ea5-3ec890e23fee	PRINCIPAL	t
ab8daf79-3d03-4b82-8542-1d999708d4c7	a89824c6-8f7f-49e0-9393-a4361b717836	cded2d3e-5f9e-4de6-9269-a1da3eeeff0a	PRINCIPAL	t
8498d2e1-3098-45dc-91d7-d09f0b117be2	728ab33b-12c6-4c6b-b255-b8745590f080	fb61c911-79f8-45ed-8e0e-23bfa3a9ad2b	PRINCIPAL	t
fe2cf0fd-a44f-49ac-be4e-920e9ced70a4	4508cbf2-577e-4f73-a8f4-4219d0ed6198	dae8fea3-9440-4fd0-8212-7c8d9c5f4f20	PRINCIPAL	t
637f86a1-ed8c-44f8-b5fa-4f9fd58be63f	941828bd-77da-4cc7-915b-3767e72ce94c	a21b30af-c563-4c43-9d68-bafd0243c5e6	PRINCIPAL	t
de1cfa73-adf9-4240-a4b2-a0c4245e1822	5a96abb2-0f95-49f7-8468-10dbf9188788	372bbb60-ca31-49ff-9ef9-fd5d49beb720	PRINCIPAL	t
6ccfb0c7-6aa9-4e87-8c63-810d51ba80ab	6eede3ee-d055-41eb-b1ff-8a43ee5fcc42	e148f60c-2aeb-442f-b302-491f4e0eca2b	PRINCIPAL	t
eb68c6c4-47ae-4af9-b3e9-add00d09d927	6933c7a1-851e-40b5-aa9e-564d1832ca2a	6abcf5ef-ae58-4e8c-ae86-335d1478ee3c	PRINCIPAL	t
54098533-53ca-4793-a6f7-55ff17967303	548560de-742c-4a97-824b-ca061633a1d9	6abcf5ef-ae58-4e8c-ae86-335d1478ee3c	PRINCIPAL	t
d6acc7c0-c9a8-413c-a964-fd6336a6a756	54c9df77-aa4f-481c-ac1b-fe8bd63f2adc	6abcf5ef-ae58-4e8c-ae86-335d1478ee3c	PRINCIPAL	t
715adc83-3e85-466b-bd8f-6369ba78dd3f	4056ec32-0e4f-4788-87c0-6d039f8766a6	9ca0a15b-a857-4fab-9747-b620717776dd	PRINCIPAL	t
fce986c8-e542-4fca-ad36-e6bd5f975f20	4081428c-48ed-4bdf-9c09-d252db487ce4	d7785cda-1f2e-4d29-a52d-335b2096bde6	PRINCIPAL	t
67ff8482-9890-488c-8074-2a8a436a59fa	7c3e9ec2-3ac1-48d7-9f44-288bca2d4444	06979c36-da6e-4fb0-840e-07533a1d41c7	PRINCIPAL	t
b4bcf7aa-f6bd-4795-84d1-c3b006b337b2	dbfe29a0-3379-4e2f-9456-999a62fc652b	06979c36-da6e-4fb0-840e-07533a1d41c7	PRINCIPAL	t
3c95ae69-de2c-4126-8f85-85b7581cfca2	cc0d0588-eafd-419e-89de-c5ae023c1286	20b0118b-9612-4fa8-b90c-5e11e27b07e3	PRINCIPAL	t
b8fcf94c-5e43-40ad-8448-a15877c39bed	25566314-ab8b-4d36-b3b9-7012e1830136	dfbdeeff-4e60-46c2-9ce0-7becb9a494a2	PRINCIPAL	t
5c376d72-99f2-47e1-94d5-03c77dfecb30	67e9c2f5-6d4e-4e5f-86b9-148aa3592da2	cd4b5edd-c793-4367-869f-a955a17d8a11	PRINCIPAL	t
5b966b1a-cedd-4a5a-8330-afb9ccd9c012	f44f68a4-e69f-4d0d-9449-2895511b8341	4b60b333-fea6-45cd-bec9-c5eb06a8cd1c	PRINCIPAL	t
1c40ed8d-87c8-45c4-9620-d03053a4a0e2	2c2d2c86-3df6-4f5a-9ab5-67163b97fbb9	4b60b333-fea6-45cd-bec9-c5eb06a8cd1c	PRINCIPAL	t
dd26321e-19d5-4025-92bf-aa8f5579e0a8	c36e4b13-86ff-4cbd-9381-e8587ccd68df	4b60b333-fea6-45cd-bec9-c5eb06a8cd1c	PRINCIPAL	t
13dd028e-2c4f-4ea9-8d03-3c3a9ce1d028	1cfda69f-753d-4789-97b0-1c6df6fc76a7	4b60b333-fea6-45cd-bec9-c5eb06a8cd1c	PRINCIPAL	t
ae8af6d4-8691-41a4-badc-43f02f9a147b	17de929f-2973-4620-b616-ec80a70daf5c	d7785cda-1f2e-4d29-a52d-335b2096bde6	PRINCIPAL	t
a26ed820-588a-49ab-a14c-e384bafaf8a7	e99ef4de-38b1-49e0-b81f-8542b642138d	b6f9e1cc-7022-4f80-8f1d-a8392c9193df	PRINCIPAL	t
dd03e47d-6397-4f48-8a82-6de16fec2d98	8f373327-c3f4-4dda-af28-2a19a6af411b	a4846d61-d1ba-4641-b155-1dc30725e33a	PRINCIPAL	t
63afbbd5-b0d9-432e-ba80-f00eb7cfc3f9	fbaca7f9-b7a8-483e-82a3-5cfeaee4dc72	a4846d61-d1ba-4641-b155-1dc30725e33a	PRINCIPAL	t
e94f287a-ff97-482f-9e69-9cb598a69aa1	6790a4f4-86a8-4eb0-997d-ba832431edc8	a4846d61-d1ba-4641-b155-1dc30725e33a	PRINCIPAL	t
99350b3f-7f91-40b3-9605-f0d501d77c32	b1923c4e-86a8-47da-8e2b-6e7ec50e321c	a4846d61-d1ba-4641-b155-1dc30725e33a	PRINCIPAL	t
d94aadad-8880-4958-abd4-d03c748b091e	ec1cdbaf-7576-471b-b080-fe26d89b42e1	c8fdee90-2d16-4800-8a4d-e6b470cf152d	PRINCIPAL	t
bc95366d-83d3-445a-a2d3-7717abb4757b	ed221fc3-13d2-46db-b8a9-149a40f088a5	c8fdee90-2d16-4800-8a4d-e6b470cf152d	PRINCIPAL	t
92c1923c-8e9f-4bb1-8768-2d19df476690	e6ae4bf7-a806-4510-b1d0-b535874128d4	c8fdee90-2d16-4800-8a4d-e6b470cf152d	PRINCIPAL	t
79b1c21b-8ea5-419e-a032-c88b0b7332f1	bd85f525-5ef2-452d-abe8-0725ae287e8d	f644ca0f-bf5f-4449-9c40-7eba742654de	PRINCIPAL	t
f05f793e-4ba1-4e5b-82a5-481c32fb8a5e	476604d9-1cfc-4099-8383-4f84c52d21b2	02ed999f-1a0c-460a-8c38-0cc464af9b6f	PRINCIPAL	t
2bf2103b-2fa7-4585-9e2a-8e8c28be6b08	ce3bf09e-b850-48e1-a7fc-e17579c5f7af	b500d7bc-3760-4c88-9a21-4294b2395c71	PRINCIPAL	t
b5462eff-6db4-430f-9fa0-4fb01c877529	e85d8e00-ebb3-4563-af7a-c3a4e91220e5	8ced3542-9444-4153-b141-27ed65a5995b	PRINCIPAL	t
41a7213d-63c9-49bc-9dee-bf4c3520b756	615f49e5-a36f-43d1-a7b5-62db9d6c7dff	cd4b5edd-c793-4367-869f-a955a17d8a11	PRINCIPAL	t
124d97f8-dd1d-481b-ac0c-f21c970f3de3	65500d82-fb05-4548-8e3b-c2a87b8b4c7c	66d4eb59-5d54-446b-9ee0-88fa9c133899	PRINCIPAL	t
5e2870f1-ed06-4b7f-aaa7-7b7239c5d8cc	43dde686-8247-4c1d-97a7-ac08708c0ed9	fb61c911-79f8-45ed-8e0e-23bfa3a9ad2b	PRINCIPAL	t
a619cd38-23dc-49fc-8b46-c863c03b0b5d	a3024323-0840-4254-80d6-b630ceb34325	d1d949b7-00fd-4756-8021-bc80d98ecf71	PRINCIPAL	t
beaf0409-0beb-4f6c-b76c-1e64e4c492fb	4af56a05-9a53-4f82-954a-483e586659d5	7c20bb25-01f0-48ad-99ac-5c3b6fe11aec	PRINCIPAL	t
db9dcee4-a4cd-4fd1-9688-fad42a5267dc	e8bf872e-f85a-476d-a1fe-a5889a422726	cded2d3e-5f9e-4de6-9269-a1da3eeeff0a	PRINCIPAL	t
7ff8c566-eae3-4eb0-9336-47a45c00c579	09696e39-6ced-4dd4-ab03-2b34e68d68c4	1f6c3850-8006-4a96-a8b9-96c068b8dbee	PRINCIPAL	t
81afd08e-6ebd-460c-b0e8-c818835f5bc9	3dcaa194-232b-4a88-bbb6-48ddab3bb271	6216f910-4b2f-49bc-b238-f3e15147152c	PRINCIPAL	t
8c920ecf-7d90-40d0-b21e-3e9a275f0796	10a39459-405c-45dc-bafe-1da03c4adff3	6abcf5ef-ae58-4e8c-ae86-335d1478ee3c	PRINCIPAL	t
80d3123b-74e8-4243-b431-1375e8572cff	7ffa9cd2-a40a-4d9b-bb15-3eb7cda32fda	7210834c-47be-440a-81d2-a5fc53a8934b	PRINCIPAL	t
39382afc-7fad-475c-9696-8189eb114b44	0981e11d-eaa6-418f-800b-a31604de7ab1	f60ed9ea-004f-41a9-9d6a-4f34923b1728	PRINCIPAL	t
b062b847-02ab-44dd-8845-00a3caf6b4ab	509f98e2-0dcf-4f96-bd20-bd2ecf3ac1f1	f0a415e0-9538-4336-b681-9d23e0753e26	PRINCIPAL	t
389d8727-1649-420f-93cc-90cf8a1b843c	2f8caf01-752b-42cf-8b7b-0a75ed69ed46	b500d7bc-3760-4c88-9a21-4294b2395c71	PRINCIPAL	t
f2f6d5a8-6830-4471-a828-6427726838d4	98a492c7-9d72-4b82-8208-5cab5fa82c3d	42b34bed-97d4-466f-a7c2-3dc5a4a821ff	PRINCIPAL	t
8425abb5-85a4-48fd-8f86-959aef5688a7	ebd7b98e-c498-4ba4-8835-682c8c8613b6	06979c36-da6e-4fb0-840e-07533a1d41c7	PRINCIPAL	t
cb9c36df-b3ac-49d3-9f3f-fd7e5a489f74	91023c89-61fa-478d-b3a8-1420f9515dc3	c8fdee90-2d16-4800-8a4d-e6b470cf152d	PRINCIPAL	t
b4bbff87-0c1f-4b6f-ac50-a6fc5b14dcd4	f7f31945-46fd-4de5-b3fe-5d8f416e0408	c8fdee90-2d16-4800-8a4d-e6b470cf152d	PRINCIPAL	t
b2eda4c5-1394-4c9d-9719-4373944508fd	dbdb2aba-8e6a-4002-b42c-92626ec38904	c8fdee90-2d16-4800-8a4d-e6b470cf152d	PRINCIPAL	t
41d895dc-f7a1-41e3-bee0-ef0d5c858d61	da5eba55-1a3a-4dc7-a141-eaeee4ef238e	c8fdee90-2d16-4800-8a4d-e6b470cf152d	PRINCIPAL	t
bdb53187-a034-48cb-9bf0-4265589381b1	479f323a-bb6b-4e27-9f68-ba67e6b25b6b	c8fdee90-2d16-4800-8a4d-e6b470cf152d	PRINCIPAL	t
09a2540c-644e-4798-b438-57c0f9512e0e	4b56a3ab-00c3-4075-80c7-a1a82284e116	c8fdee90-2d16-4800-8a4d-e6b470cf152d	PRINCIPAL	t
685a4983-182b-4f67-a6b0-7ee7f520806b	321d5189-7c90-4d2b-b9c9-bf28963c772e	d7785cda-1f2e-4d29-a52d-335b2096bde6	PRINCIPAL	t
ff281c8e-90a9-4da6-aa03-94de71d8f59f	3f1cf111-a5b1-470f-bee5-684bd201c28a	b33fd685-31a6-4510-a970-09a2d428a1bb	PRINCIPAL	t
67d82fce-8473-4aa9-8899-e9a85b0683cb	4df3a410-28b7-4605-afa9-33f95f52539b	b6f9e1cc-7022-4f80-8f1d-a8392c9193df	PRINCIPAL	t
a2611ac4-28de-4119-9be6-8720a49b4e22	9ce50dd9-54cd-419f-bee5-a2b990ac6942	b6f9e1cc-7022-4f80-8f1d-a8392c9193df	PRINCIPAL	t
500f0ed3-fb0d-46f4-aae4-96d3de3f856f	d5724a7a-410a-40c5-a8f0-a139db1a29e4	b6f9e1cc-7022-4f80-8f1d-a8392c9193df	PRINCIPAL	t
25130f8e-0bc5-43b5-9af3-0ca60e55d3b2	974b7578-e578-4db0-8ea8-e3a202cc561d	9ca0a15b-a857-4fab-9747-b620717776dd	PRINCIPAL	t
29ac14b9-0cef-45e4-a304-baeb4be02074	7ecd74a4-e5f2-4f9f-a9cd-746cdc77fde5	7c20bb25-01f0-48ad-99ac-5c3b6fe11aec	PRINCIPAL	t
4d2d674f-7b66-498b-8946-d4a8b887c7a7	dfcec0df-ab98-4439-b860-0b6f55313063	d88e7e56-7d2c-4edc-aef4-f61e755c586a	PRINCIPAL	t
097bcafa-dfb2-45a2-ab1f-34dd2b135de9	dbdb79b5-1477-4137-b5c9-6680edf4d83b	f644ca0f-bf5f-4449-9c40-7eba742654de	PRINCIPAL	t
484250dd-3b33-4a59-bf11-2a9fbcbfd341	fcec85f8-6c40-4a3a-9144-40bd7d59bc86	0d45342c-ecad-45a7-bb51-ebce9779c000	PRINCIPAL	t
f2f9b7af-42ae-4e36-9d21-3f28bfd6eba6	4a7a1d75-4456-4421-b91b-695c2fd874d1	0d45342c-ecad-45a7-bb51-ebce9779c000	PRINCIPAL	t
2bf6037a-8cf1-4815-b3e5-61a0bfc7355a	cbfeab2c-6896-4b24-957b-a80c27d6dc38	0d45342c-ecad-45a7-bb51-ebce9779c000	PRINCIPAL	t
a524f869-6bf3-4eb0-b37f-c74459b6cddf	b752f199-5120-4278-89ed-d81eefa6acb2	0d45342c-ecad-45a7-bb51-ebce9779c000	PRINCIPAL	t
090573c5-418c-4608-ad67-155c08673e78	745376ad-ad11-4c73-8259-cac35cf67f4c	30fef00d-f9ee-4362-b430-5819b4bde400	PRINCIPAL	t
0ead3136-eb6b-4476-9fc3-6f8879dac81f	e274df2b-2ad6-4afe-9f56-607f3c84cd10	fb61c911-79f8-45ed-8e0e-23bfa3a9ad2b	PRINCIPAL	t
5fd5d5c3-fe7e-4b2c-a006-9be47d6d33ec	6dab3a91-422d-4104-a0f1-83a4420ab0c4	fb61c911-79f8-45ed-8e0e-23bfa3a9ad2b	PRINCIPAL	t
4a0b41de-eab2-429a-bece-46ee786ac20e	6fd36f3e-b092-4535-92c3-4fdfcead634c	fb61c911-79f8-45ed-8e0e-23bfa3a9ad2b	PRINCIPAL	t
1004e760-044c-4d8c-b7ec-d5ed4bad21d6	d5d9e985-9d3d-481e-8b01-f9497ffc4fb5	fb61c911-79f8-45ed-8e0e-23bfa3a9ad2b	PRINCIPAL	t
71aac79c-f1f2-4493-a353-01c4ca136a7c	d9302d5f-6309-4585-9bd5-62b36b690c56	e148f60c-2aeb-442f-b302-491f4e0eca2b	PRINCIPAL	t
a917c396-17d3-4855-95ee-421b7373be27	54681b8d-41c9-4ee7-bd71-dd26e1605244	e148f60c-2aeb-442f-b302-491f4e0eca2b	PRINCIPAL	t
3637613f-a15e-48df-97fa-420891a7ca22	5afa14bf-7e09-4001-aa18-ee216a125059	20b0118b-9612-4fa8-b90c-5e11e27b07e3	PRINCIPAL	t
91fc6906-d52a-4235-8403-4247c5193c37	45611c7a-4060-42d6-b0de-4ed6013dc781	8ced3542-9444-4153-b141-27ed65a5995b	PRINCIPAL	t
0254b633-87af-493a-b38e-0c4299625821	c7471cca-cf46-43f5-af61-87844c00e374	b500d7bc-3760-4c88-9a21-4294b2395c71	PRINCIPAL	t
a6634c05-3e06-43da-8d72-b97d2a9ec5c7	3800b073-14dc-4e2f-81cd-6bfb26da12c9	20b0118b-9612-4fa8-b90c-5e11e27b07e3	PRINCIPAL	t
d33cc715-47e6-436e-b009-bdd91562a986	71f99bac-46dc-49dc-af66-07213f5d9b90	66d4eb59-5d54-446b-9ee0-88fa9c133899	PRINCIPAL	t
2f6d204a-a6b2-49c3-a61c-e57b3c6df150	c746c1d4-1b8f-405a-b3ac-f8c384c225c8	a21b30af-c563-4c43-9d68-bafd0243c5e6	PRINCIPAL	t
d0bafc80-aaae-4f39-84e1-db37b63c78f3	18dfb601-91e3-40e8-b56a-b7f70e8e722b	ea89e630-34ba-4705-98d9-8b662af90e3c	PRINCIPAL	t
898c8a73-8f62-43dc-9b6c-980fd2f774f2	504dbc20-29fe-4273-b1da-afe4d9b32f56	9ca0a15b-a857-4fab-9747-b620717776dd	PRINCIPAL	t
75845902-a00c-47e8-9a75-d251486cd477	3788c947-4062-48fd-a08c-88821b936ae9	4b60b333-fea6-45cd-bec9-c5eb06a8cd1c	PRINCIPAL	t
43093a44-907a-4da6-a459-cdf264b060f0	f366d627-4a7d-485b-bf15-acf869dcb4cb	cded2d3e-5f9e-4de6-9269-a1da3eeeff0a	PRINCIPAL	t
1e83ab2b-ec20-48a2-bb65-b454b32001aa	72543581-2475-44a7-8b85-804161fa8213	61c44b6c-785b-4418-82b4-f2f2d3173e8d	PRINCIPAL	t
92dfd43d-ea14-43bb-abc4-f8d9e386b264	d2804c2e-a528-4b87-9231-f8da2e283aa3	a4846d61-d1ba-4641-b155-1dc30725e33a	PRINCIPAL	t
58221652-7389-4bcf-8f8b-6dd7f9404bc5	4030df33-e313-4da4-9a55-ea22058bb755	8e978fd7-df5d-495f-aedb-668e0a0eee76	PRINCIPAL	t
b36a634c-ba79-4f16-8b86-4bb1c604c245	3bb673ef-c7b0-40e4-81a9-74da58971c86	1f6c3850-8006-4a96-a8b9-96c068b8dbee	PRINCIPAL	t
3c002f0d-3d17-4ea2-9833-d7597ee88429	3f7a9e2a-866a-4cb1-b260-6bf8e6005087	96431afb-2b4f-474c-8348-78a155e9adb8	PRINCIPAL	t
880b3ce9-ef6b-47a5-96e8-0b54125ceeee	4992fd90-c4e2-4a72-85ac-39e5a1f5b974	ea018f17-bf86-4148-906a-520c058f3deb	PRINCIPAL	t
c8bc80e4-488f-4140-a8a7-4a7fc237f129	5227126d-7419-482a-936f-aa47ebca2486	b1260fb6-8960-4630-8970-15e24b1d76e9	PRINCIPAL	t
e55ec487-1f9d-475c-8c9c-6b950c63ad5a	96f71fc0-19c3-4a74-ba9c-5fb8d5ebcd94	42a44075-32a8-4cf3-ac88-e674cec0c736	PRINCIPAL	t
97aeaa14-08ec-472c-906e-78bcabe16ff9	cd83dde5-4c4c-4583-9b81-da03688ddc1f	f0a415e0-9538-4336-b681-9d23e0753e26	PRINCIPAL	t
b8c60873-2275-4073-b65e-fc3cdeef5304	8d7c7b92-155d-4761-977b-51fbc5798a3a	ea89e630-34ba-4705-98d9-8b662af90e3c	PRINCIPAL	t
29cb5fe9-d775-4092-88f0-3e356a8ea60d	6282e5de-d67c-4ef0-a5f1-fae17ddae5cf	d1d949b7-00fd-4756-8021-bc80d98ecf71	PRINCIPAL	t
f4bce34a-d6ef-41c1-8924-999887141335	355ea204-2e97-47d2-9b82-92a5c77307ee	c4d0d648-9ce5-427e-a92a-05bbad8caab8	PRINCIPAL	t
c5788cd0-10e2-4db5-b2bc-4cc28c7215e2	87fb2325-8144-46e6-986c-cb0221973208	2636748e-dbca-4b8b-a7df-53a7499b9937	PRINCIPAL	t
914c4451-78b6-44a4-a0e7-b052353238ff	243ddbe2-4dfe-447c-b79f-39bdadfc840e	cded2d3e-5f9e-4de6-9269-a1da3eeeff0a	PRINCIPAL	t
989db96e-2179-46d6-b11e-0e10716412f6	1a14a7d0-1bed-4e13-aee7-f5ed3c10d6f3	ba8ec778-639d-4dcd-9db2-d7100c84e8f5	PRINCIPAL	t
794dfc13-7d1d-49d4-8a29-835b761ee3ae	89abf8a8-1795-43b8-9d32-a6ddf115b379	8ced3542-9444-4153-b141-27ed65a5995b	PRINCIPAL	t
0443c2d2-d42f-40f7-8b25-8aecca2bca1f	9d1653fc-8774-4198-8a13-6d7ccda90032	fb61c911-79f8-45ed-8e0e-23bfa3a9ad2b	PRINCIPAL	t
02a6e6b4-bee8-462a-99a7-99f016d21e76	ce9a362d-bb0e-4e94-85ed-de69994ead91	b6f9e1cc-7022-4f80-8f1d-a8392c9193df	PRINCIPAL	t
547f6178-531e-43cc-b18f-57c9ab658b22	37998e8c-e6e6-4a93-9c88-613f9180ae65	c8fdee90-2d16-4800-8a4d-e6b470cf152d	PRINCIPAL	t
1b6616a0-7cd6-45b2-9f8a-a8e0106e7ae9	e161c3a6-63b0-449d-97a3-857bfb55d218	d7785cda-1f2e-4d29-a52d-335b2096bde6	PRINCIPAL	t
1e7b209f-ce5a-4598-984d-5313893a7cf1	9530471e-a089-440c-bf93-e06b7e7b4b75	0d45342c-ecad-45a7-bb51-ebce9779c000	PRINCIPAL	t
43ec3e2c-6ef3-441e-aae5-22634de764bc	bcf49c27-bc7e-48ca-8965-cd370c6a620b	0d45342c-ecad-45a7-bb51-ebce9779c000	PRINCIPAL	t
025455c6-bc95-4a9a-8519-d9b63b2c078d	1737535b-682b-48d8-9393-7a9bbe0018f8	0d45342c-ecad-45a7-bb51-ebce9779c000	PRINCIPAL	t
0de5a479-5034-4c9c-b58c-e642fd775cda	ad6f7971-625c-4c82-be7d-87350c567fd9	9a9b3bcd-4b8f-4aba-8ea5-3ec890e23fee	PRINCIPAL	t
de73466e-8216-43d0-b006-3d182c2230fc	860d11e5-310c-4c4c-a7b0-cf31163d04d7	d1d949b7-00fd-4756-8021-bc80d98ecf71	PRINCIPAL	t
dbfad039-b20a-4eb9-acbb-8267c039cb56	1f339cd7-94ca-41f2-9fb9-6ef03f968fbd	e82e6994-7b2a-4fd4-a699-665a2c81d083	PRINCIPAL	t
3833fe35-175c-4a2b-a849-813be963a894	1dff4349-b566-41d1-b70e-9348a0576aed	b500d7bc-3760-4c88-9a21-4294b2395c71	PRINCIPAL	t
f32c9e5a-e613-45aa-acfa-386fc134bf87	db57eee6-facc-4f0b-8b0f-543b8abd5ddf	dae8fea3-9440-4fd0-8212-7c8d9c5f4f20	PRINCIPAL	t
3b50fff7-52ab-4156-be22-021ac94a4b9d	71413536-ea05-4ef2-b73d-050be1411c67	8644b80c-97af-46cf-9f4d-711749582de1	PRINCIPAL	t
4f61cf25-0cdf-4f63-a7d7-e17a486d8898	28796850-9a35-415e-97e1-a9b0b27c3379	372bbb60-ca31-49ff-9ef9-fd5d49beb720	PRINCIPAL	t
a6548a3a-ed19-484e-b5b7-a04d3dc63328	9efd8fe7-233a-4488-ac04-1661bf77f23b	372bbb60-ca31-49ff-9ef9-fd5d49beb720	PRINCIPAL	t
32210f51-e29b-4806-965a-ec4b0147b417	06a34e5a-5c0f-4696-a80a-47669daebeab	372bbb60-ca31-49ff-9ef9-fd5d49beb720	PRINCIPAL	t
1bc4cdb7-ff4a-4216-943b-a653d2279b9a	db058076-c652-4623-8c27-24a36499ae1f	372bbb60-ca31-49ff-9ef9-fd5d49beb720	PRINCIPAL	t
b2118df1-b318-4a4f-8fdc-8716c958af44	e65c26a3-52aa-41fb-a88f-7f2f737abde1	66d4eb59-5d54-446b-9ee0-88fa9c133899	PRINCIPAL	t
8f901405-3008-400f-86c1-36a3cf09e725	9b467eaf-0059-4f3b-a738-815d83de5089	b33fd685-31a6-4510-a970-09a2d428a1bb	PRINCIPAL	t
186cb536-cf63-4b59-acdc-10eb11f78f3e	ba0b8574-30a9-46a9-a3a9-65a2231052c5	f644ca0f-bf5f-4449-9c40-7eba742654de	PRINCIPAL	t
9e42bea3-9a5d-4dbf-8617-0cbe29f8019e	d3717f48-3cd5-4a17-a2f7-a7db7f28f2bc	3aab4c36-1982-4957-8f29-192aba668488	PRINCIPAL	t
92784a7c-4fff-491c-b514-aa86501e65fc	a4ac087b-9be4-41eb-9eea-0374230d5289	c8fdee90-2d16-4800-8a4d-e6b470cf152d	PRINCIPAL	t
79b1e272-f8bb-43ba-a134-dd31a617021e	466227be-bca2-420c-9724-d417540e7f2a	6216f910-4b2f-49bc-b238-f3e15147152c	PRINCIPAL	t
cba97af0-f435-401b-a308-af2e4e8303a9	2d73d1e4-eded-4548-af91-fa306895854c	0ba0a4ea-eaa3-4d11-b737-5f80e0651fb5	PRINCIPAL	t
dd600180-10ad-412c-a8ba-7450bd59b923	76a9cb5f-3f75-4acd-ac63-5220e64e7131	b33fd685-31a6-4510-a970-09a2d428a1bb	PRINCIPAL	t
2a65cf96-71a2-407c-a5af-aed71748b5ea	8a88e19d-9760-4749-be31-7156968c30fa	b33fd685-31a6-4510-a970-09a2d428a1bb	PRINCIPAL	t
9a3f499d-2041-4464-928a-872b2d47a2c7	8218a590-5b3d-4f0f-ae66-aa509888075f	ba8ec778-639d-4dcd-9db2-d7100c84e8f5	PRINCIPAL	t
0b4e3633-62e7-4216-9009-cc51f1b4d47b	2a817b6f-286d-4906-8161-42cc90b912a0	06979c36-da6e-4fb0-840e-07533a1d41c7	PRINCIPAL	t
f6dbaa22-bed3-4a22-b58c-8e6bdfa34207	ce2fad78-fc03-43b8-a20b-1f5fea8be357	e920c268-7682-4e36-8222-bc6cbf215b83	PRINCIPAL	t
6c59db96-09d8-446f-a6aa-89b2794766ce	b2aa34fb-6551-45eb-9999-79aacdcf1c9d	8321194c-0126-4b76-a497-2b06980a61e3	PRINCIPAL	t
0878c550-0fd0-4017-81b6-9354960437b1	d6b39e9e-7b11-4e02-a282-635a600c64b0	e148f60c-2aeb-442f-b302-491f4e0eca2b	PRINCIPAL	t
fa9cbd0b-6ab6-4955-bd82-6f7d1b73ff6e	e2c55b2f-dd63-4ffb-adc5-2d8120e7bfd5	ccd3c2b4-fdfd-4d4e-b6c6-1a0dbbc02cf3	PRINCIPAL	t
fd5f5020-9808-4264-9c20-8b940bebb81f	0e7ed4fe-5f1f-4fdb-8773-4dda588cda6b	20b0118b-9612-4fa8-b90c-5e11e27b07e3	PRINCIPAL	t
\.


--
-- Data for Name: mareas_movimientos; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.mareas_movimientos (id, id_marea, fecha_hora, id_usuario, tipo_evento, id_estado_desde, id_estado_hasta, cantidad_muestras_otolitos, detalle, comentarios) FROM stdin;
56ebd2d0-9c19-4855-8314-213eb4619ce4	e21b90dc-df99-4eba-8a8a-1624de4dc936	2026-01-14 00:41:09.751+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
260dbd31-e5a2-491b-b476-161ff3668bb5	d06453ee-c376-4333-986f-e02f13988014	2026-01-14 21:47:52.477+00	20feb9da-69af-4b7e-9f9f-47ec73ae954f	EDICION_ESTRUCTURA	\N	\N	\N	Edición manual de etapas y fechas de observador.	\N
a055c47c-f754-4d54-b7e0-5fa6ed803407	da24bf7d-9642-4503-81d1-58fd1fbe8ffe	2026-01-14 00:41:09.763+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
3cc70eeb-367c-419e-a648-d458ac042cac	b6f7a234-a1b5-464f-82e1-f691d1d61c0d	2026-01-14 00:41:09.776+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	2ea71871-f6e2-480b-bb64-6d2f436ffa6f	\N	Marea importada de seguimiento 2025 (JSONL)	\N
d0c5007d-07b8-47f8-9e15-79b1c4ed40b1	e4dfb9b7-1dc7-4838-bd5b-65bda33b7062	2026-01-14 00:41:09.781+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
81cc8d5c-3ed8-42b1-898f-f4892e4dea12	90bf9a4a-3233-43e0-bceb-4843a6424ff1	2026-01-14 00:41:09.788+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
27d76efa-1d9c-4984-9851-6d182dfa9729	c29d8cf7-bdde-4596-8fda-d1911fbe68ec	2026-01-14 00:41:09.796+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
4d165b7f-5d2b-4bbb-801f-24695a8c4f3c	e06c2441-b7b0-4922-9aad-dbc981bbc1d3	2026-01-14 00:41:09.806+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
d895553c-4355-49da-8b30-44a73c3d5cf3	daff9983-9b0f-46a5-87a0-21d52c16b234	2026-01-14 00:41:09.815+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
48907d67-6403-44b5-9553-64248271044d	921652f0-4013-4808-98fb-9234429ecfdf	2026-01-14 00:41:09.825+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
9668d8c6-cde6-4a1b-aa77-3d7c920acb5f	eab63893-ae5b-4bb9-81f5-82073dd5a928	2026-01-14 00:41:09.833+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
a9a5dabf-17a2-4037-afd1-9b3650ac5a36	f772b482-10e8-4dbd-b54d-18ad99ee8da4	2026-01-14 00:41:09.845+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
ba5c1e6e-7404-4054-9c00-f9ff00d95fd3	661d8e7c-b0ee-4bb4-addd-d927d95de530	2026-01-14 00:41:09.852+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
20ed300e-cafd-4242-abd2-1b143f7c1257	9b158375-56d3-4207-a70b-32eb6f7e4a1f	2026-01-14 00:41:09.861+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
6797157e-48bf-4510-bc9d-912e8a85b685	134e771f-508a-40df-a6ac-76f532bdaeb6	2026-01-14 00:41:09.87+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
58234637-4fb1-4b58-b45d-2bbd148d00da	a82d5e41-b695-4a9d-aea9-0f3194d52b67	2026-01-14 00:41:09.878+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
974db6fb-a4d2-4e71-8b72-0a3381338224	36d0f8b0-0c70-4822-9a1f-17486328b822	2026-01-14 00:41:09.885+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
1e75b1de-be42-44dc-831d-e0011bf9d8f9	8ca1a435-51b3-4cdb-8323-d12132f30070	2026-01-14 00:41:09.897+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
f78598b0-77ca-4b3e-812f-c6cd62eded73	f4602bf8-6141-4e7c-9a9b-9d3d1e63761f	2026-01-14 00:41:09.906+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
ffdc1254-83ef-4408-a777-0f062a8a96ad	4f5e867f-2277-4990-89a0-8e621d229020	2026-01-14 00:41:09.917+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
7a7532e0-7059-4ef4-8118-a80b5aaf74a6	ab688bbc-76e4-4967-9d8b-79141f666795	2026-01-14 00:41:09.929+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
344a5748-d9b9-4717-b2b6-820ef130c3d0	75b63bea-982a-4151-8923-cdc3ca09d56e	2026-01-14 00:41:09.936+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
582995be-916a-4d9e-afed-6b290ff685a4	83254676-7d69-46bb-839c-fcb352334c92	2026-01-14 00:41:09.944+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
e9aaa38b-9abf-4605-9400-fae377c74246	02d0bd10-2761-47e9-a460-30e179e77b9d	2026-01-14 00:41:09.955+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
7efa0b14-24e3-428f-af03-dc5451548998	13eeb6f9-9d7e-48d0-8d5d-d72695620833	2026-01-14 00:41:09.962+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
15233a8d-86c9-47e7-8e3a-631da2dbf92a	bc9edd1c-bfb7-4fc2-a452-e6cf557ca733	2026-01-14 00:41:09.969+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
2eb09705-e98e-4f35-b219-e08aa0e73820	7d09cfaa-19da-4ab3-8ce5-b891a4b9d215	2026-01-14 00:41:09.977+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
6e435029-6339-4880-9b6e-0a795973ac0c	9eb6be1f-e0cd-43b6-876e-3303f8238252	2026-01-14 00:41:09.985+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
38a188a4-bae0-4613-9355-0c2331b7d19e	2e03db0e-0f5a-4bee-a9ce-62275877178f	2026-01-14 00:41:10.001+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
19d8cfd1-5564-4ca4-b994-7919e6b1e596	a7b198f6-2669-4367-8dca-b1cf27ac4f51	2026-01-14 00:41:10.011+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
08707dd2-1f7c-4264-8d96-4a13a275b66a	12560a8d-1d4d-4c20-a734-8ee0ff62a0e6	2026-01-14 00:41:10.025+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
6581d89b-1cb8-4828-ac34-d8243069af5a	edb87fd9-19c0-438c-a893-5b99fcecf2e6	2026-01-14 00:41:10.035+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
cbc2c173-c32d-4de2-8847-42e4c41ba34a	cc26c06e-063a-4f03-ba93-dc1548da8b5f	2026-01-14 00:41:10.042+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
5cdbfe66-0db0-4fe3-86ce-41865d74c390	9a6c3e8b-124a-4c95-bf49-94f903004ab6	2026-01-14 00:41:10.053+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
8695e9ea-cc4b-4d29-97cb-482e96c6b96c	6b0da04b-0dd6-421a-bd51-67a1f0c1a56a	2026-01-14 00:41:10.061+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
90e132c5-d5c8-40a7-b617-f37f070802cd	e15a4939-ae23-4991-8ac4-5ed84361e229	2026-01-14 00:41:10.073+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
214d45ef-1a48-407e-8e6f-882f97fc7062	61639206-bb3b-4e02-a43b-571ffe935af8	2026-01-14 00:41:10.081+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
c336bd5e-368f-4a21-b5f5-8fda5a0990fe	5ad3a3fb-e713-4aa4-bdfa-c64897be84c4	2026-01-14 00:41:10.088+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
491c308d-55ed-4c1a-a03c-301b4d6ebb58	23bec926-2e1e-48ac-a34e-b021931e5c4a	2026-01-14 00:41:10.101+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
e663d653-eff9-4239-a291-887e66afcdc1	5ca55e94-ec43-4870-a024-53c6fd3899e0	2026-01-14 00:41:10.11+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
ff772a24-bf2a-4fd3-8794-c1caee946938	d1345931-2377-4835-b707-56cffe0d23b7	2026-01-14 00:41:10.117+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
31cfd4ee-c513-4b16-8be4-147084873460	ad6ff68c-97d6-4ccf-99e7-09705901ef24	2026-01-14 00:41:10.124+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
bdebb2d3-22d7-43d3-b01e-b25116882592	ac5ff8a0-6a36-4e59-a826-099cad6c260a	2026-01-14 00:41:10.133+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
e1ed8d4a-dd40-494b-8de4-bf40bdc1798a	92c833ed-110f-423d-bb0f-42eb1a3cc410	2026-01-14 00:41:10.142+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
12639014-3069-4050-9a03-688f928bda19	1ee1160e-1fe6-4523-a965-5d081f225006	2026-01-14 00:41:10.149+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
5bc23c83-bf76-4caa-a0df-6034552d7a96	896cabea-e6b1-4027-9da4-4cd64d9b8173	2026-01-14 00:41:10.156+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
cdd641bd-f00d-4bbb-b6b2-4120c7e5af9f	24de7801-3383-4693-90a3-d4e2f389ebc2	2026-01-14 00:41:10.163+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
ad80e72b-e520-4183-a85c-b8e2e6e2f77d	6536a509-e9ff-4c6c-86ac-c29d35e250a1	2026-01-14 00:41:10.17+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
fcfa4fc2-f11e-4ed8-9a0d-79916e854c43	d97a833e-1094-4499-acd3-abe345f14bf6	2026-01-14 00:41:10.179+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
ac57bd83-2fd5-4c15-8104-60176604c3ec	8c663be4-70ad-4605-b929-e131899c47a2	2026-01-14 00:41:10.188+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	2ea71871-f6e2-480b-bb64-6d2f436ffa6f	\N	Marea importada de seguimiento 2025 (JSONL)	\N
ce5ed6c8-797b-43ca-b91c-c21b3cb524ac	ce6b184a-27cc-4e69-9b54-1de1c90c1dec	2026-01-14 00:41:10.193+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
fe82c488-13be-40e6-8f3c-b572f6c725b8	3dd68328-0ea1-4d1a-9142-b67088fedcda	2026-01-14 00:41:10.201+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
1880b576-4335-48dc-b702-1e0a5e0b7272	12634231-f4e9-4b82-9958-26972ac58975	2026-01-14 00:41:10.208+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
aae3f40f-b788-411d-8116-345654f8dcd5	26fe3877-c712-44bf-90da-4e8fe9d152d2	2026-01-14 00:41:10.215+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
1ab63a25-2246-47ab-88be-9a6bb503217f	ec6c04a5-0942-4932-bf6d-e8f11745ad45	2026-01-14 00:41:10.223+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
ffed4587-92b7-45bc-a4ad-05def71ca99d	d824e9ee-9849-4b51-9fcd-517af440e4d0	2026-01-14 00:41:10.233+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
4add90c5-090e-42a7-9547-bc75f7336e43	edc5129c-6579-4b84-bc23-ae7baff116fc	2026-01-14 00:41:10.24+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	2ea71871-f6e2-480b-bb64-6d2f436ffa6f	\N	Marea importada de seguimiento 2025 (JSONL)	\N
bf0af528-c2a1-4e03-b354-0b3fc5c9498f	de435656-8da8-430d-891a-def2e8aa5c3c	2026-01-14 00:41:10.245+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	2ea71871-f6e2-480b-bb64-6d2f436ffa6f	\N	Marea importada de seguimiento 2025 (JSONL)	\N
4467b370-14a9-4b1b-8a7d-16c2c5756b3a	7b5ef1bd-4eb4-489c-976b-477525f660a5	2026-01-14 00:41:10.25+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
2bed1094-59a7-4470-8747-14390ad228a5	5ae0c35c-5c3b-4fae-b112-b5ae6d8217eb	2026-01-14 00:41:10.264+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
18a4b6f0-1b2c-4795-90e1-9461412123c8	019284e5-0c48-42be-ae75-5706530352fd	2026-01-14 00:41:10.271+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
2dfea218-836a-42e4-9661-ae63551a0791	a81a062c-885f-4c3e-9169-e19436645419	2026-01-14 00:41:10.278+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	2ea71871-f6e2-480b-bb64-6d2f436ffa6f	\N	Marea importada de seguimiento 2025 (JSONL)	\N
a84b9eaf-e197-480d-9458-4d3926c86b0c	07d31e6d-26f8-42db-a71d-f2ba8f440b76	2026-01-14 00:41:10.284+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
d5bf0dfb-c41d-4cdf-b66d-7b4ba4776352	924f4e58-334a-4279-8770-9fb785bd3daa	2026-01-14 00:41:10.291+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
298e5a37-9b88-476d-98b5-ea1c6e9152be	0710af5c-cc4e-48c2-a163-f244db38a34f	2026-01-14 00:41:10.307+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	2ea71871-f6e2-480b-bb64-6d2f436ffa6f	\N	Marea importada de seguimiento 2025 (JSONL)	\N
3dbcb380-9f83-4f7b-8356-accbbf569c6b	d776c633-7d6a-41a8-b83c-5996b880b452	2026-01-14 00:41:10.312+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
8b73a04f-f2a1-4523-8fda-0188cfb02144	8c1b9863-f3de-4725-8100-d31306ab7a9f	2026-01-14 00:41:10.321+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
5508e231-dd00-46f8-9521-b3a4798ec8cb	1797ca1f-77e5-46cf-bb03-f54cf2656699	2026-01-14 00:41:10.331+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
cef014ab-f72c-405f-a1e2-88a9841b2d2b	cc5da30e-92da-4a31-a6a9-367f12538f5d	2026-01-14 00:41:10.339+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
f3dad219-7418-422a-8fd6-df3935410ce4	54116fc8-0376-4e98-8e06-51d69391c0db	2026-01-14 00:41:10.346+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
5180ad82-db27-47c2-bee1-deca0a5313ba	35f620eb-aae7-4b01-9a49-83de0709e695	2026-01-14 00:41:10.354+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
71282dc4-8193-4a45-a6fb-7306a27d4891	3f8caf63-2609-461b-b823-c0b1f4cf062e	2026-01-14 00:41:10.363+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	2ea71871-f6e2-480b-bb64-6d2f436ffa6f	\N	Marea importada de seguimiento 2025 (JSONL)	\N
7a201463-63d9-468a-bfbb-6d5d131b9c0a	affe4a6b-5ae3-4188-b88b-82cb7d46e835	2026-01-14 00:41:10.367+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
fe47eae5-a7b0-412d-a84c-54337cb23e6a	fa57c969-9c6b-4101-850c-ae5fae7b81e3	2026-01-14 00:41:10.38+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	2ea71871-f6e2-480b-bb64-6d2f436ffa6f	\N	Marea importada de seguimiento 2025 (JSONL)	\N
4b354f0a-db94-42a6-a959-3adc3dc5eef4	de7f7699-c09a-4cf4-bceb-3c8fa0eef107	2026-01-14 00:41:10.385+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
a35bee87-cc30-46ec-8d53-fb79b3443004	75b8e60b-8e72-4110-a02a-4a9c89d3247a	2026-01-14 00:41:10.393+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
a759dd52-6b05-4c0d-9027-e999e8f9ddf8	8efb8972-ce3d-4cab-9bdd-74404194c448	2026-01-14 00:41:10.403+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
a2d3604f-6930-4094-9198-515c1b9a4625	1b88cb74-d1ee-4175-82bd-133e4851a9c0	2026-01-14 00:41:10.413+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
bf527e4e-e72e-4ad4-aeae-02dfd7624051	b044574d-b57e-4aee-84f9-52dd22d71c02	2026-01-14 00:41:10.425+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
d7538e8b-3d3a-402e-a2f4-e28a8445c243	d3ca30c5-22be-4532-a93f-f238a35e605e	2026-01-14 00:41:10.432+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	2ea71871-f6e2-480b-bb64-6d2f436ffa6f	\N	Marea importada de seguimiento 2025 (JSONL)	\N
fa75546d-3191-4e81-9af1-0fe78133cb67	8b387d1b-5ce1-4ef9-bdc7-40c0dee441b0	2026-01-14 00:41:10.437+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
d7067cc4-1929-4473-a9b0-65d622a41041	530ef634-901c-438f-a0f5-4f52cab7a969	2026-01-14 00:41:10.445+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
85129c1b-79a3-4802-a2c7-d97212087f83	f2d0a1d7-4867-4b46-befe-e7aca3ef945b	2026-01-14 00:41:10.452+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
9be4f868-d090-4c29-80c1-3befeb499ec0	e27c7ba0-3f80-49f0-b52e-2c79c199401b	2026-01-14 00:41:10.46+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
5685f1e1-4b38-4ced-af05-102706280c2f	89d9e3b6-9a07-4613-bb96-1e92fe8374e9	2026-01-14 00:41:10.467+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	2ea71871-f6e2-480b-bb64-6d2f436ffa6f	\N	Marea importada de seguimiento 2025 (JSONL)	\N
0953837c-366b-4605-b429-04ba87fcec27	e2c1a54c-7a35-4aa2-b615-386313d039c5	2026-01-14 00:41:10.472+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
2733a89f-f8b9-49f2-977f-5562b4a9831f	f97ca208-0509-49cf-acef-922455403fe3	2026-01-14 00:41:10.485+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
3b98184e-508a-47c9-ab8a-e6c1a17171c6	132c8654-f29d-436e-bdca-a6bfaee87c37	2026-01-14 00:41:10.493+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	2ea71871-f6e2-480b-bb64-6d2f436ffa6f	\N	Marea importada de seguimiento 2025 (JSONL)	\N
07e542a7-818f-46ac-9c9c-52db25989e4e	a0aeb842-95d6-413d-9ccd-8f67cbc51b38	2026-01-14 00:41:10.5+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
25d2724f-9e11-4d15-be0f-04ef49a3ee62	ca0004a4-1eb0-406e-b534-6bed5fc1f656	2026-01-14 00:41:10.507+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	2ea71871-f6e2-480b-bb64-6d2f436ffa6f	\N	Marea importada de seguimiento 2025 (JSONL)	\N
e8e5f2bf-2723-4465-b4bc-09d65a5b6996	a9725964-cd70-4286-8b86-cc50e89f307d	2026-01-14 00:41:10.512+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	2ea71871-f6e2-480b-bb64-6d2f436ffa6f	\N	Marea importada de seguimiento 2025 (JSONL)	\N
04278a61-f164-48f4-bf57-2b222549e92f	5c2caebd-9c90-4a7d-83a3-91cfdd69b246	2026-01-14 00:41:10.517+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	2ea71871-f6e2-480b-bb64-6d2f436ffa6f	\N	Marea importada de seguimiento 2025 (JSONL)	\N
2a42df61-20f7-479d-a6f2-d9707017e44e	2bde3e6b-fcb6-43ef-a637-7f1e075ae3b7	2026-01-14 00:41:10.521+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
3f378243-f7a3-453d-8685-a132b466bf1b	abb71f7e-66c2-4fad-a06c-023f67a1485f	2026-01-14 00:41:10.53+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	97219917-fdf2-4aca-b415-96de17cc505e	\N	Marea importada de seguimiento 2025 (JSONL)	\N
83a2e1ab-1f93-4900-ab7c-cd8d22025303	0a2ca322-9c41-4c85-8f5f-0f9cda6e6230	2026-01-14 00:41:10.537+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	2ea71871-f6e2-480b-bb64-6d2f436ffa6f	\N	Marea importada de seguimiento 2025 (JSONL)	\N
e80beaef-bd36-4511-ae35-eb90ebb3fa8b	c5c2f85f-a0ac-45c9-bd6d-9d93eef21ede	2026-01-14 00:41:10.541+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	2ea71871-f6e2-480b-bb64-6d2f436ffa6f	\N	Marea importada de seguimiento 2025 (JSONL)	\N
0e099bd9-a2a4-44e1-a14f-f1192f7febf1	8f6e1c1b-d8be-491e-82e1-1ced1843b47a	2026-01-14 00:41:10.547+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
a97820be-55ae-4f68-baea-6bace5506ee1	b935a58b-d0c4-4d60-9acd-7ed83c647978	2026-01-14 00:41:10.554+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
b93adc66-ed16-4e42-ac04-a75a1e9f8cb1	73edad49-21e4-4680-b848-8cc046436440	2026-01-14 00:41:10.561+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
b18626d0-faa7-4dd4-9092-52c5f6d74d49	a670a10e-b396-43cf-9e4f-da854c216802	2026-01-14 00:41:10.569+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
b7473511-43f9-4012-aaab-24a2540aab8b	65604077-1344-40c8-8aa5-530a80524667	2026-01-14 00:41:10.579+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
660003c7-dbb6-42b9-9604-3eb403893318	7c0f420c-18e3-4c11-a8ee-688eaba8c013	2026-01-14 00:41:10.586+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
58d2aa9e-91e8-4f58-a3fe-9ec74ce73715	c54a944e-148b-4d71-9003-cf1a602eea67	2026-01-14 00:41:10.593+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
d47e676a-58f0-403c-8027-dcb58a529db3	bc922ab1-8a89-4fbd-8ff0-b92cb23f7ee3	2026-01-14 00:41:10.603+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
7eeca1bb-ea3c-4782-b964-205092700081	971cd500-4f71-46d7-9b36-5cd570dd538e	2026-01-14 00:41:10.61+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
20d90296-5e2a-4a42-b0b4-078763dd4bc2	a1964669-a378-41ef-a0ce-2da11a1fb8a8	2026-01-14 00:41:10.617+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
243ed865-5ffd-48e2-990b-eb235405d19f	d3cd4728-744f-438e-8ec7-cc2f2dc6571e	2026-01-14 00:41:10.625+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
0167827d-afc6-41d3-9164-ad5663029948	2807c518-ee18-46b9-be03-54ee4d5ed4f9	2026-01-14 00:41:10.639+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
bfffac90-0a16-4934-b274-c50ba9730b5f	d9f9aaf9-d19d-4317-8719-29ae41e9cd59	2026-01-14 00:41:10.647+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
38d3de4f-b4d0-4d6f-b266-b854e2c826d6	b178ba43-a1c2-4518-9734-e042d4790fce	2026-01-14 00:41:10.655+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
40828285-18ac-46c5-8e95-0da05a9269b1	0d9d50b5-0b9b-459c-91bc-1830f753b625	2026-01-14 00:41:10.669+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
16f320d0-d5e4-4fbe-8123-aad14040774c	0f59cfcd-2244-4399-a8ef-14c52bffef07	2026-01-14 00:41:10.681+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
a614192a-fba9-45e1-8e9b-3c67acd3121e	40e14f88-15d9-43e3-aaa1-a0cb6c1479d5	2026-01-14 00:41:10.688+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
520d89da-412c-4adc-ac50-45ef53d6fd2d	92f748e6-da70-4fd1-894d-89134404ab5a	2026-01-14 00:41:10.695+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
49aeb490-dd6d-4951-85a0-65b3979fe129	0ad77221-e2c0-4c45-a650-6a0bc4154eb4	2026-01-14 00:41:10.702+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
0c010e7b-4c2f-4fe7-b923-a9acdffc3e7c	de64d728-4a6c-4b29-a242-4165b7338f2d	2026-01-14 00:41:10.708+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	2ea71871-f6e2-480b-bb64-6d2f436ffa6f	\N	Marea importada de seguimiento 2025 (JSONL)	\N
6844997d-a0ef-4b69-afb3-f1b7bc34b032	a07196ce-0524-4b05-b36d-04450033c584	2026-01-14 00:41:10.713+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
20e4cf7e-e2b4-451c-b3af-8e12225bd89e	4aeeeb58-99d3-490a-8434-be89120f4762	2026-01-14 00:41:10.721+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
6b7bf351-333f-4b0d-bd06-c9f6faab8cf9	fbaf8efe-0c9a-4b2d-8b80-ca8a7f3a1f15	2026-01-14 00:41:10.729+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
3503186a-557d-4cb8-a62c-69b3930b4133	3c2cce97-783f-4d0c-a9f9-fb9b8d7b2d17	2026-01-14 00:41:10.736+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
f89ce6dc-2909-47cf-8c14-01cf160b9f0f	b7434a04-3b64-4168-80b6-2e3b7a9f8675	2026-01-14 00:41:10.742+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
2dab3a05-b8d5-4e1c-a1f4-7e783070330b	cc24d84d-ba71-40b9-8151-92323119d482	2026-01-14 00:41:10.751+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
0a765e71-9fb8-4db4-8515-d8c531faf495	64504245-b7b7-4e92-80ad-cfdb7d18e83b	2026-01-14 00:41:10.758+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
f4ba236a-0485-4c14-a3b6-0649df1cda3b	08476a6d-7120-4f53-b222-7958aa0ff895	2026-01-14 00:41:10.765+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	e1582fe4-d48e-46fb-b156-7f7aaf3f9983	\N	Marea importada de seguimiento 2025 (JSONL)	\N
349f51e2-f06c-47de-a6a2-0e69c264ad4c	63a550cb-4b46-4392-aa6b-daf68171a61a	2026-01-14 00:41:10.772+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	e1582fe4-d48e-46fb-b156-7f7aaf3f9983	\N	Marea importada de seguimiento 2025 (JSONL)	\N
9e944c45-d013-46af-b4d4-88a470907113	7e201eae-7c97-485c-9670-915d228402e3	2026-01-14 00:41:10.779+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	45672467-a4db-462d-8228-2a21ce82cc37	\N	Marea importada de seguimiento 2025 (JSONL)	\N
29b36562-00e4-4766-a34d-5def59dee05c	26138cad-87d4-482f-9e82-3a5b24e0c2c8	2026-01-14 00:41:10.787+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	45672467-a4db-462d-8228-2a21ce82cc37	\N	Marea importada de seguimiento 2025 (JSONL)	\N
609874ab-752f-45be-a9a4-9c4b753a31fd	54cef98c-4772-40b4-9f04-80a878694497	2026-01-14 00:41:10.797+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	e1582fe4-d48e-46fb-b156-7f7aaf3f9983	\N	Marea importada de seguimiento 2025 (JSONL)	\N
0da2b12b-15cf-4db9-a978-0f4546ff7e1d	d6df112f-d895-4076-89b7-b17f522b77c1	2026-01-14 00:41:10.805+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
6453f91b-1c54-4aca-bf30-76187e62c766	911f04d3-2611-418a-ab6c-85273c1c54f4	2026-01-14 00:41:10.813+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
095cbe7f-304d-4678-9c87-8365d11ae044	dccb9d7c-b9d8-4f58-9269-ec88c8221976	2026-01-14 00:41:10.819+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	e1582fe4-d48e-46fb-b156-7f7aaf3f9983	\N	Marea importada de seguimiento 2025 (JSONL)	\N
2e03e34f-43ed-4772-b3c4-eed6dd8717d9	d8a1275d-9257-41a4-ae2b-b82d52c3b637	2026-01-14 00:41:10.826+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	e1582fe4-d48e-46fb-b156-7f7aaf3f9983	\N	Marea importada de seguimiento 2025 (JSONL)	\N
e3ca9baf-1b6a-47ab-a420-e102389e34c6	5676b02b-3aa8-4744-a6a1-9d16eaec0a3f	2026-01-14 00:41:10.843+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	e1582fe4-d48e-46fb-b156-7f7aaf3f9983	\N	Marea importada de seguimiento 2025 (JSONL)	\N
440afaa8-7a82-4811-a38c-8fbc7f38cc74	80616398-f6b9-4201-b08d-b39d5eb67ca4	2026-01-14 00:41:10.849+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	45672467-a4db-462d-8228-2a21ce82cc37	\N	Marea importada de seguimiento 2025 (JSONL)	\N
3270e766-ee8d-403f-867a-5d0fa2afff56	deb918b8-73e6-4c2d-9cd7-1e614d2e048e	2026-01-14 00:41:10.857+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	e1582fe4-d48e-46fb-b156-7f7aaf3f9983	\N	Marea importada de seguimiento 2025 (JSONL)	\N
68a627d5-bbc7-46d2-bc88-dc3af99aac6e	840d1c7b-9747-4b06-b53b-697e644a53ea	2026-01-14 00:41:10.868+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	45672467-a4db-462d-8228-2a21ce82cc37	\N	Marea importada de seguimiento 2025 (JSONL)	\N
8b34e8b2-03a2-43b9-bac8-9d6e7085902f	fec0ddd6-f0b4-40ae-bf31-03d15f45241b	2026-01-14 00:41:10.874+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	e1582fe4-d48e-46fb-b156-7f7aaf3f9983	\N	Marea importada de seguimiento 2025 (JSONL)	\N
76951ada-1c95-430b-8c50-b810dede4359	2dcf9357-bd8b-4020-9594-c42604b0ea0a	2026-01-14 00:41:10.881+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	e1582fe4-d48e-46fb-b156-7f7aaf3f9983	\N	Marea importada de seguimiento 2025 (JSONL)	\N
7ec379b1-07cb-4cb4-8e6c-c5823fa70cd0	12b7645b-a848-44ac-a2c7-f47f748f1cc6	2026-01-14 00:41:10.888+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	45672467-a4db-462d-8228-2a21ce82cc37	\N	Marea importada de seguimiento 2025 (JSONL)	\N
333ba172-28c4-4f85-8b99-4a24ab701745	70ec1fd8-6559-4e17-850f-dfbffe164b2b	2026-01-14 00:41:10.895+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	45672467-a4db-462d-8228-2a21ce82cc37	\N	Marea importada de seguimiento 2025 (JSONL)	\N
f4c8ab51-77f4-4778-bec0-2fcd01d3ad9c	42c2367a-8542-4763-9f89-02780bbeea8e	2026-01-14 00:41:10.908+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	e1582fe4-d48e-46fb-b156-7f7aaf3f9983	\N	Marea importada de seguimiento 2025 (JSONL)	\N
b5700702-23b4-4325-b6a5-da37fc90df3b	dd030597-448a-41db-b591-608b47597a5e	2026-01-14 00:41:10.915+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	45672467-a4db-462d-8228-2a21ce82cc37	\N	Marea importada de seguimiento 2025 (JSONL)	\N
f1768fc0-567e-40c1-9111-68ddffb395d0	e1421d6b-6654-4314-b373-0c7aef292054	2026-01-14 00:41:10.93+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	45672467-a4db-462d-8228-2a21ce82cc37	\N	Marea importada de seguimiento 2025 (JSONL)	\N
875cfa74-3456-4f31-be01-dd70aeb48cec	89a552ad-3649-45e6-9e48-9029a4629763	2026-01-14 00:41:10.943+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	e1582fe4-d48e-46fb-b156-7f7aaf3f9983	\N	Marea importada de seguimiento 2025 (JSONL)	\N
7d5f7f68-76f5-4526-ad0e-578898f28058	ecfe7292-b255-4865-bb32-5949e22b7802	2026-01-14 00:41:10.949+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	45672467-a4db-462d-8228-2a21ce82cc37	\N	Marea importada de seguimiento 2025 (JSONL)	\N
37a17b88-3aef-48dc-b680-eb1c96621ea4	18873c09-e4fc-493b-b80b-ec01ae1eb66e	2026-01-14 00:41:10.957+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	45672467-a4db-462d-8228-2a21ce82cc37	\N	Marea importada de seguimiento 2025 (JSONL)	\N
d2978d12-65c4-4499-9568-50d0dd93d151	1d3796e9-5936-4785-9a48-2b5ecb48a7be	2026-01-14 00:41:10.965+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	97219917-fdf2-4aca-b415-96de17cc505e	\N	Marea importada de seguimiento 2025 (JSONL)	\N
670e9148-324a-46f8-a848-8e3831332e7d	fc13e177-c80d-4b35-98ed-bdfb707663cc	2026-01-14 00:41:10.973+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	97219917-fdf2-4aca-b415-96de17cc505e	\N	Marea importada de seguimiento 2025 (JSONL)	\N
c278bf3d-7060-4d20-9df6-9005022fe8a1	c7504351-7144-4384-bd61-a5968f0bfe57	2026-01-14 00:41:10.98+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	97219917-fdf2-4aca-b415-96de17cc505e	\N	Marea importada de seguimiento 2025 (JSONL)	\N
5590f9f8-5b5d-4bd9-813d-05c4f1c38445	68d4e4c7-151f-4a33-a2d6-a1a2ac165e9f	2026-01-14 00:41:10.987+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	45672467-a4db-462d-8228-2a21ce82cc37	\N	Marea importada de seguimiento 2025 (JSONL)	\N
e2c2aee2-437e-403d-a62b-749a2347f486	d06453ee-c376-4333-986f-e02f13988014	2026-01-14 00:41:10.994+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	97219917-fdf2-4aca-b415-96de17cc505e	\N	Marea importada de seguimiento 2025 (JSONL)	\N
16142294-b07a-49a4-86b7-6820fee01de5	a5e4657e-38f5-4130-a6ef-08d685fbddad	2026-01-14 00:41:11.002+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	97219917-fdf2-4aca-b415-96de17cc505e	\N	Marea importada de seguimiento 2025 (JSONL)	\N
0418da58-65a3-4347-a472-bf53c8459cf9	47bc925f-8a76-467f-8a92-30b22cf33c75	2026-01-14 00:41:11.01+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	3af8b7d1-f41d-4029-83ae-ef5e178ff565	\N	Marea importada de seguimiento 2025 (JSONL)	\N
058b82fe-9c70-459a-8fa5-5be7a8c23467	1499b680-ec86-4123-8e28-0bead9519301	2026-01-14 00:41:11.017+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	3af8b7d1-f41d-4029-83ae-ef5e178ff565	\N	Marea importada de seguimiento 2025 (JSONL)	\N
ebb6ce98-6d1f-4f00-8814-17181d3260da	841c4ec4-edbf-4b07-8063-2e84f2680fff	2026-01-14 00:41:11.024+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	3af8b7d1-f41d-4029-83ae-ef5e178ff565	\N	Marea importada de seguimiento 2025 (JSONL)	\N
329e531c-2210-4e6e-9d8f-9ed50df3af91	6a925c67-2c02-43e9-9496-fd3975160424	2026-01-14 00:41:11.032+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	3af8b7d1-f41d-4029-83ae-ef5e178ff565	\N	Marea importada de seguimiento 2025 (JSONL)	\N
5eec7431-0f50-4b91-a382-3c1f29c8e88f	abde28b8-9542-4be9-8694-da80f5e0b196	2026-01-14 00:41:11.039+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	3af8b7d1-f41d-4029-83ae-ef5e178ff565	\N	Marea importada de seguimiento 2025 (JSONL)	\N
d07c8010-a9d1-429f-b353-002854d95a10	32942ae8-dac2-4d9e-8ef2-3ffe43237c17	2026-01-14 00:41:11.052+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	3af8b7d1-f41d-4029-83ae-ef5e178ff565	\N	Marea importada de seguimiento 2025 (JSONL)	\N
f80a700b-7edc-42aa-865c-3c136372e2a8	7d5358c9-5ca9-4d3d-a59a-e2363c9f6d8d	2026-01-14 00:41:11.06+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	3af8b7d1-f41d-4029-83ae-ef5e178ff565	\N	Marea importada de seguimiento 2025 (JSONL)	\N
1fa9a40c-b41d-485d-8662-d56c02ab9f94	6d1f181a-37a4-40a6-83fb-4a4ad95c332e	2026-01-14 00:41:11.067+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	3af8b7d1-f41d-4029-83ae-ef5e178ff565	\N	Marea importada de seguimiento 2025 (JSONL)	\N
59c32597-2baf-49fb-8b43-60ab5febe7e1	d0080183-5a28-4940-8b62-d0916fb6ea45	2026-01-14 00:41:11.074+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	97219917-fdf2-4aca-b415-96de17cc505e	\N	Marea importada de seguimiento 2025 (JSONL)	\N
bba9c445-7d26-40cd-9787-d4b309813585	de4b51fc-abf4-4fa4-b1bc-027e6d33908c	2026-01-14 00:41:11.081+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	3af8b7d1-f41d-4029-83ae-ef5e178ff565	\N	Marea importada de seguimiento 2025 (JSONL)	\N
3092518e-af1a-4ca9-8f8f-2984b7bf1b9e	239c4c23-fbcd-43fd-88d5-02c4d4601349	2026-01-14 00:41:11.088+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	3af8b7d1-f41d-4029-83ae-ef5e178ff565	\N	Marea importada de seguimiento 2025 (JSONL)	\N
a33b6fcf-2a13-4f09-ae20-298f49a6be0a	f091515a-3a09-4d2d-aaad-839f884a6ec5	2026-01-14 00:41:11.094+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	3af8b7d1-f41d-4029-83ae-ef5e178ff565	\N	Marea importada de seguimiento 2025 (JSONL)	\N
878d45b2-9ac0-4a16-a721-ea895138bd79	e6685824-1f78-44d1-a67e-61b80de14ac0	2026-01-14 00:41:11.101+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	3af8b7d1-f41d-4029-83ae-ef5e178ff565	\N	Marea importada de seguimiento 2025 (JSONL)	\N
75b59460-093c-4969-9d97-ed5c9688e0f5	99da2fe8-8c72-4174-a1f5-26e38069ba49	2026-01-14 00:41:11.108+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	3af8b7d1-f41d-4029-83ae-ef5e178ff565	\N	Marea importada de seguimiento 2025 (JSONL)	\N
4e1e7808-394d-4c77-8f5b-42dea34ecb15	2ffe1eb4-87db-49fc-bba7-f89f742be443	2026-01-14 00:41:09.364+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
466d212a-f937-4006-922e-47d0f782c9d2	88d8de1d-3229-4290-bd9b-8bac988cb4ae	2026-01-14 00:41:09.388+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
fb3ebcf9-65ce-4fa8-b7d5-1f9994669b37	855ed6f3-5a13-41d4-a6b3-bf85b2fd720f	2026-01-14 00:41:09.4+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
7b0afba4-654f-44f2-992d-471b9a6b34b1	1009a963-f453-4721-8488-ee5f5e7d710b	2026-01-14 00:41:09.413+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
feaf594a-c371-4956-ac83-1db1a1e86d74	891568fd-cfd2-4c4c-bfd0-4d9c57f82198	2026-01-14 00:41:09.425+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
56ba3e2c-2aed-4a52-9a0a-50f33ace7d8f	d7097607-d295-4981-a72f-090793ba8c33	2026-01-14 00:41:09.434+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
87e6ca33-c40d-478b-b9e4-98b6b9d20f32	30770969-bb3b-49c0-b015-1420bf2d18ee	2026-01-14 00:41:09.442+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
9b96ddfd-edd0-4720-ba8c-f488bbf2f4c7	8ed5e8f3-27ff-46bf-b7b1-aba4bf533087	2026-01-14 00:41:09.45+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
f5ef2a2c-b333-4825-9640-69dcba3bd1da	61f3c95e-a80a-4bd0-8498-9eab710811ec	2026-01-14 00:41:09.464+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
cae12180-9f8b-4fea-9bc8-bf55cc6d773a	8997039d-e6d9-4bca-8463-838ac5f6b1fb	2026-01-14 00:41:09.474+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
7fac56da-4ab4-478f-bbc0-870221a04d0a	cce1ecad-81c4-4625-b825-48009137d8c3	2026-01-14 00:41:09.482+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
759e0abf-57ae-481a-a81b-234db044fa2a	e492153b-241c-4895-a772-67ad78b6be33	2026-01-14 00:41:09.491+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
6eb4d8f2-d9ad-47c2-88a5-b1961b0a74c8	89b33858-f91c-4971-ab64-227f9ba17371	2026-01-14 00:41:09.498+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
ad1e4a33-03e8-4de4-be82-5b1e8bf98777	e6b7d05c-171a-4ecb-90fb-fb31337da507	2026-01-14 00:41:09.506+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
67df201e-724c-4444-b4e8-99d1a094e680	f547dedc-96f2-4ad3-86da-92a1373f5109	2026-01-14 00:41:09.513+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
609e5a02-5fb8-459d-9940-cf0ebfcfbcad	38c30a58-515e-4bb0-b785-783a38baab82	2026-01-14 00:41:09.527+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
efea7c11-0304-4c81-8b7f-dcf04b0f0f90	9c7616fa-5388-4f5a-a182-323048a74273	2026-01-14 00:41:09.535+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
078ff99f-ba39-4012-9bbb-4e7c72620cec	640d4643-f206-4c34-a756-ef14e6c99a79	2026-01-14 00:41:09.545+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
3e8ef9ee-2631-4190-81ec-43f7138e339f	4c7760d3-eef2-49a2-bd90-ec74d9d2b3ed	2026-01-14 00:41:09.553+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
ae2482a5-f5a0-4c4b-b43e-1af39d538a40	6f309917-3dfe-408c-bb64-c2f226f2316c	2026-01-14 00:41:09.561+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
ec840f52-4f65-4189-bdc6-3299eff24064	71b5feb8-c564-4834-845c-a91318c6492e	2026-01-14 00:41:09.57+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
a8669539-934e-4fb4-8481-417a8722df05	98d6da59-bc8f-49ff-a776-aff6e36ccb0a	2026-01-14 00:41:09.588+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
ef4bad51-7034-443a-a0ae-72fd6314d93d	0f730c5f-a6f1-4aed-be91-93320107ef3c	2026-01-14 00:41:09.602+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
e66fd64f-a8cf-4392-833c-369271a93c32	04b6229f-7d19-4b8a-9237-a519202222a0	2026-01-14 00:41:09.618+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
027cd66e-da54-4828-9883-b0ca68167b39	e6f7ebb4-26d6-4bc1-b14e-db07fdf479f5	2026-01-14 00:41:09.63+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
b52aaab7-881e-41cc-ac11-020437bec1f5	55f52d76-0c76-490c-81d3-5a03b292c9c3	2026-01-14 00:41:09.642+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
18c2ad34-4367-4864-a916-058b1d90bc5e	b8d25e78-d9c7-4416-977b-ebf6e60ca6cc	2026-01-14 00:41:09.65+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
2f798d94-fca4-4e3f-b5c8-f891be6bf65c	e30b483b-ea05-4b41-93f0-c89e7c97b7a6	2026-01-14 00:41:09.659+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
03a3106c-d6cb-44a2-bcaf-a44b6ac1200c	e5d2e37b-a388-47fd-b3a7-a09b73fa0158	2026-01-14 00:41:09.668+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
9bf10aab-8980-4f04-bc48-739cad1e080a	7701800b-8c67-4f60-80ea-c72a68a80f7d	2026-01-14 00:41:09.677+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
8dff3c79-7809-41a2-8ea4-695fe59d4f87	3d1e676b-21d2-45cd-8f2d-d93f4727b01c	2026-01-14 00:41:09.685+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
7f1bb5c6-0ac7-42e4-8be2-96a8ca7b75cd	0ac9a3b7-fead-4b51-b1c3-51c7333154ef	2026-01-14 00:41:09.697+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
14136575-9fed-43f9-bcb7-e68b486108fd	4fd2c3f7-68a3-458e-bd8b-5e2c62ec60ed	2026-01-14 00:41:09.711+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
f3d5da53-bfe7-43e5-ad37-8732c6bced28	1a54b40d-84c1-4c94-a3d6-a2b52391b780	2026-01-14 00:41:09.723+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
522137c8-cddc-4c8c-af2a-72a7ee63c2cd	6da5576d-2280-48a7-8d72-be325aafe103	2026-01-14 00:41:09.733+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
0eed38db-1553-41d0-b0d4-f01ec7f03b31	9f71d41a-5a5b-4ee1-8076-f8ef65eb3583	2026-01-14 00:41:09.742+00	a1eaea70-9aa0-4432-acbf-305ab5fab6f9	CREACION	\N	76819a0c-c2c4-4a6a-aaa6-2468fdc9fb2c	\N	Marea importada de seguimiento 2025 (JSONL)	\N
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
dfbdeeff-4e60-46c2-9ce0-7becb9a494a2	2021	Claudio	Noale	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	t	claudionoale@hotmail.com	Cambio de trabajo
0ba0a4ea-eaa3-4d11-b737-5f80e0651fb5	7149	Gustavo	Cano	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	\N	\N
4d019608-ebd1-4e3c-95eb-e9a505274ae9	7562	Lucas	Bentos	\N	TECNICO	LEY MARCO	t	t	\N	\N	f	\N	\N
d1d949b7-00fd-4756-8021-bc80d98ecf71	7610	Raul Bernardo	Bargas Peña	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	rbbargas@gmail.com	\N
c8fdee90-2d16-4800-8a4d-e6b470cf152d	7611	Cristian Emmanuel	Cerrina	\N	OBSERVADOR	LEY MARCO	t	t	\N	\N	f	manucerrina2@gmail.com	\N
ea89e630-34ba-4705-98d9-8b662af90e3c	7612	Richard Javier	Espinola Gysin	\N	OBSERVADOR	1109	t	t	\N	\N	f	richardjesp@gmail.com	\N
0b3c7262-8ba3-4ce3-83f7-cc96080f73f0	7613	Federico Nicolás	Garcia	\N	OBSERVADOR	1109	t	f	\N	\N	t	fede.gaarciaa@gmail.com	Accidente en motocicleta
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
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.users (id, email, password, "fullName", "isActive", roles, "themePreference", "avatarUrl") FROM stdin;
a1eaea70-9aa0-4432-acbf-305ab5fab6f9	admin@obs.com	$2b$10$jYY7zTkIRlh4ZcDM2uyYEumzno9sXiBDznifDWTxb3Zf/9l4nmrdW	Administrador Sistema	t	{admin}	system	\N
ee60e2bc-94fe-45aa-8358-c66ebb920af3	coordinador@obs.com	$2b$10$jYY7zTkIRlh4ZcDM2uyYEumzno9sXiBDznifDWTxb3Zf/9l4nmrdW	Coordinador Operativo	t	{coordinador}	system	\N
3e6b512c-53e0-4d96-9959-b09a6d353067	tecnico@obs.com	$2b$10$jYY7zTkIRlh4ZcDM2uyYEumzno9sXiBDznifDWTxb3Zf/9l4nmrdW	Técnico de Datos	t	{tecnico_datos}	system	\N
a68658ae-266a-47c5-ad6e-61a9552abd84	asistente@obs.com	$2b$10$jYY7zTkIRlh4ZcDM2uyYEumzno9sXiBDznifDWTxb3Zf/9l4nmrdW	Asistente Administrativo	t	{asistente_administrativo}	system	\N
20feb9da-69af-4b7e-9f9f-47ec73ae954f	danieldt2000@hotmail.com	$2b$10$jYY7zTkIRlh4ZcDM2uyYEumzno9sXiBDznifDWTxb3Zf/9l4nmrdW	Daniel Di Tullio	t	{tecnico_datos}	system	\N
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

\unrestrict jikYhBxDXfM4NhXO2DBrkVdpbFBBa0Hs5ndLOtmb020aG0toM7QKfovOuxIc2zw

