-- =====================================================================
-- MIGRACIÓN SEGURA SISTEMA DE AUDITORÍA
-- =====================================================================
-- Este script crea el esquema 'audit' y sus tablas asociadas.
-- NO elimina ni modifica tablas existentes en el esquema 'public'.
-- Es seguro para ejecutar en producción.

-- 1. Crear esquema si no existe
CREATE SCHEMA IF NOT EXISTS "audit";

-- 2. Crear tabla AuditoriaApi
CREATE TABLE "audit"."auditoria_api" (
    "id" UUID NOT NULL,
    "timestamp" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "usuario_id" UUID,
    "usuario_email" TEXT,
    "session_id" TEXT,
    "metodo_http" TEXT NOT NULL,
    "ruta" TEXT NOT NULL,
    "ruta_base" TEXT NOT NULL,
    "query_params" JSONB,
    "request_body" JSONB,
    "status_code" INTEGER NOT NULL,
    "response_body" JSONB,
    "response_time_ms" INTEGER NOT NULL,
    "ip" TEXT,
    "user_agent" TEXT,
    "categoria" TEXT NOT NULL,
    "accion" TEXT,
    "entidad_tipo" TEXT,
    "entidad_id" TEXT,
    "es_error" BOOLEAN NOT NULL DEFAULT false,
    "es_critico" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "auditoria_api_pkey" PRIMARY KEY ("id")
);

-- Indices AuditoriaApi
CREATE INDEX "auditoria_api_usuario_id_timestamp_idx" ON "audit"."auditoria_api"("usuario_id", "timestamp");
CREATE INDEX "auditoria_api_ruta_timestamp_idx" ON "audit"."auditoria_api"("ruta", "timestamp");
CREATE INDEX "auditoria_api_categoria_timestamp_idx" ON "audit"."auditoria_api"("categoria", "timestamp");
CREATE INDEX "auditoria_api_es_error_timestamp_idx" ON "audit"."auditoria_api"("es_error", "timestamp");
CREATE INDEX "auditoria_api_es_critico_timestamp_idx" ON "audit"."auditoria_api"("es_critico", "timestamp");

-- 3. Crear tabla AuditoriaNavegacion
CREATE TABLE "audit"."auditoria_navegacion" (
    "id" UUID NOT NULL,
    "timestamp" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "usuario_id" UUID,
    "session_id" TEXT NOT NULL,
    "ruta_origen" TEXT,
    "ruta_destino" TEXT NOT NULL,
    "parametros" JSONB,
    "tiempo_vista_ms" INTEGER,

    CONSTRAINT "auditoria_navegacion_pkey" PRIMARY KEY ("id")
);

-- Indices AuditoriaNavegacion
CREATE INDEX "auditoria_navegacion_usuario_id_timestamp_idx" ON "audit"."auditoria_navegacion"("usuario_id", "timestamp");
CREATE INDEX "auditoria_navegacion_session_id_idx" ON "audit"."auditoria_navegacion"("session_id");

-- 4. Crear tabla AuditoriaEntidad
CREATE TABLE "audit"."auditoria_entidad" (
    "id" UUID NOT NULL,
    "timestamp" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "usuario_id" UUID,
    "usuario_email" TEXT,
    "entidad_tipo" TEXT NOT NULL,
    "entidad_id" TEXT NOT NULL,
    "operacion" TEXT NOT NULL,
    "valores_anteriores" JSONB,
    "valores_nuevos" JSONB,
    "campos_modificados" TEXT[],
    "contexto" JSONB,

    CONSTRAINT "auditoria_entidad_pkey" PRIMARY KEY ("id")
);

-- Indices AuditoriaEntidad
CREATE INDEX "auditoria_entidad_entidad_tipo_entidad_id_timestamp_idx" ON "audit"."auditoria_entidad"("entidad_tipo", "entidad_id", "timestamp");
CREATE INDEX "auditoria_entidad_usuario_id_timestamp_idx" ON "audit"."auditoria_entidad"("usuario_id", "timestamp");
CREATE INDEX "auditoria_entidad_operacion_timestamp_idx" ON "audit"."auditoria_entidad"("operacion", "timestamp");

-- 5. Crear tabla AuditoriaEvento
CREATE TABLE "audit"."auditoria_eventos" (
    "id" UUID NOT NULL,
    "timestamp" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "usuario_id" UUID,
    "usuario_email" TEXT,
    "tipo_evento" TEXT NOT NULL,
    "categoria" TEXT NOT NULL,
    "entidad_principal" JSONB NOT NULL,
    "entidades_relacionadas" JSONB,
    "descripcion" TEXT NOT NULL,
    "metadata" JSONB,
    "resultado" TEXT NOT NULL,
    "mensaje_error" TEXT,

    CONSTRAINT "auditoria_eventos_pkey" PRIMARY KEY ("id")
);

-- Indices AuditoriaEvento
CREATE INDEX "auditoria_eventos_tipo_evento_timestamp_idx" ON "audit"."auditoria_eventos"("tipo_evento", "timestamp");
CREATE INDEX "auditoria_eventos_usuario_id_timestamp_idx" ON "audit"."auditoria_eventos"("usuario_id", "timestamp");
CREATE INDEX "auditoria_eventos_categoria_timestamp_idx" ON "audit"."auditoria_eventos"("categoria", "timestamp");
CREATE INDEX "auditoria_eventos_resultado_timestamp_idx" ON "audit"."auditoria_eventos"("resultado", "timestamp");

-- 6. Agregar claves foráneas a User (en public)
ALTER TABLE "audit"."auditoria_api" ADD CONSTRAINT "auditoria_api_usuario_id_fkey" FOREIGN KEY ("usuario_id") REFERENCES "public"."users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE "audit"."auditoria_navegacion" ADD CONSTRAINT "auditoria_navegacion_usuario_id_fkey" FOREIGN KEY ("usuario_id") REFERENCES "public"."users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE "audit"."auditoria_entidad" ADD CONSTRAINT "auditoria_entidad_usuario_id_fkey" FOREIGN KEY ("usuario_id") REFERENCES "public"."users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE "audit"."auditoria_eventos" ADD CONSTRAINT "auditoria_eventos_usuario_id_fkey" FOREIGN KEY ("usuario_id") REFERENCES "public"."users"("id") ON DELETE SET NULL ON UPDATE CASCADE;
