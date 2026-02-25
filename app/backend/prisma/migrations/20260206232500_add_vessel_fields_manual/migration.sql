-- Migración Aditiva Segura para campos de API Oficial de Buques
-- Aplicada manualmente por el usuario para evitar reset

ALTER TABLE "public"."buques" 
  ADD COLUMN IF NOT EXISTS "id_mbpc" TEXT,
  ADD COLUMN IF NOT EXISTS "bandera" TEXT,
  ADD COLUMN IF NOT EXISTS "anio_construccion" INTEGER,
  ADD COLUMN IF NOT EXISTS "mmsi" TEXT,
  ADD COLUMN IF NOT EXISTS "tipo_buque" TEXT,
  ADD COLUMN IF NOT EXISTS "senal_distintiva" TEXT,
  ADD COLUMN IF NOT EXISTS "velocidad" DOUBLE PRECISION,
  ADD COLUMN IF NOT EXISTS "puntal" DECIMAL(6,2),
  ADD COLUMN IF NOT EXISTS "arqueo_total" DECIMAL(10,2),
  ADD COLUMN IF NOT EXISTS "calado_max" DECIMAL(6,2),
  ADD COLUMN IF NOT EXISTS "puerto_asiento" TEXT,
  ADD COLUMN IF NOT EXISTS "arqueo_neto" DECIMAL(10,2),
  ADD COLUMN IF NOT EXISTS "dotacion_minima" INTEGER,
  ADD COLUMN IF NOT EXISTS "tipo" TEXT,
  ADD COLUMN IF NOT EXISTS "estado_reg" TEXT,
  ADD COLUMN IF NOT EXISTS "fecha_ultima_actualizacion_api" TIMESTAMPTZ(6);
