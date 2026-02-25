-- Migración Manual Segura (No destructiva) para agregar la tabla pna_zarpadas_arribos

-- 1. Crear la tabla
CREATE TABLE IF NOT EXISTS "public"."pna_zarpadas_arribos" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "id_costera" TEXT NOT NULL,
    "nombre_costera" TEXT NOT NULL,
    "id_buque_mbpc" TEXT NOT NULL,
    "matricula" TEXT NOT NULL,
    "sdist" TEXT,
    "nombre" TEXT NOT NULL,
    "latitud" TEXT NOT NULL,
    "longitud" TEXT NOT NULL,
    "estado" TEXT NOT NULL,
    "fecha" TIMESTAMPTZ(6) NOT NULL,
    "fecha_modificacion" TIMESTAMPTZ(6) NOT NULL,
    "cantidad_tripulantes" INTEGER NOT NULL,
    "observaciones" TEXT,
    "borrado" BOOLEAN NOT NULL DEFAULT false,
    "external_combo_id" TEXT NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "pna_zarpadas_arribos_pkey" PRIMARY KEY ("id")
);

-- 2. Crear el índice único para deduplicación
CREATE UNIQUE INDEX IF NOT EXISTS "pna_zarpadas_arribos_external_combo_id_key" ON "public"."pna_zarpadas_arribos"("external_combo_id");

-- 3. Crear los índices de búsqueda optimizada
CREATE INDEX IF NOT EXISTS "pna_zarpadas_arribos_id_buque_mbpc_idx" ON "public"."pna_zarpadas_arribos"("id_buque_mbpc");
CREATE INDEX IF NOT EXISTS "pna_zarpadas_arribos_fecha_idx" ON "public"."pna_zarpadas_arribos"("fecha");
CREATE INDEX IF NOT EXISTS "pna_zarpadas_arribos_estado_idx" ON "public"."pna_zarpadas_arribos"("estado");
CREATE INDEX IF NOT EXISTS "pna_zarpadas_arribos_external_combo_id_idx" ON "public"."pna_zarpadas_arribos"("external_combo_id");
