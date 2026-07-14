-- CreateTable
CREATE TABLE "public"."novedades_email_logs_detalles" (
    "id" UUID NOT NULL,
    "id_email_log" UUID NOT NULL,
    "fuente" TEXT NOT NULL,
    "extraccion_ai" JSONB,
    "numero_gde" TEXT,
    "estado" TEXT NOT NULL,
    "error_detalle" TEXT,
    "id_novedad" UUID,

    CONSTRAINT "novedades_email_logs_detalles_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "novedades_email_logs_detalles_id_email_log_idx" ON "public"."novedades_email_logs_detalles"("id_email_log");

-- CreateIndex
CREATE INDEX "novedades_email_logs_detalles_estado_idx" ON "public"."novedades_email_logs_detalles"("estado");

-- AddForeignKey
ALTER TABLE "public"."novedades_email_logs_detalles" ADD CONSTRAINT "novedades_email_logs_detalles_id_email_log_fkey" FOREIGN KEY ("id_email_log") REFERENCES "public"."novedades_email_logs"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."novedades_email_logs_detalles" ADD CONSTRAINT "novedades_email_logs_detalles_id_novedad_fkey" FOREIGN KEY ("id_novedad") REFERENCES "public"."observadores_novedades"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- MIGRACIÓN DE DATOS SEGURA: Mover datos de novedades_email_logs a novedades_email_logs_detalles
INSERT INTO "public"."novedades_email_logs_detalles" ("id", "id_email_log", "fuente", "extraccion_ai", "estado", "error_detalle", "id_novedad")
SELECT 
    gen_random_uuid(), 
    "id", 
    'CUERPO', 
    "extraccion_ai", 
    "estado", 
    "error_detalle", 
    "id_novedad"
FROM "public"."novedades_email_logs";

-- DropForeignKey
ALTER TABLE "public"."novedades_email_logs" DROP CONSTRAINT "novedades_email_logs_id_novedad_fkey";

-- AlterTable (Drop columns from novedades_email_logs)
ALTER TABLE "public"."novedades_email_logs" DROP COLUMN "error_detalle",
DROP COLUMN "estado",
DROP COLUMN "extraccion_ai",
DROP COLUMN "id_novedad";

-- Re-add estado column to novedades_email_logs with a default value
ALTER TABLE "public"."novedades_email_logs" ADD COLUMN "estado" TEXT NOT NULL DEFAULT 'PROCESADO';

-- Update the new estado column based on the details
UPDATE "public"."novedades_email_logs"
SET "estado" = 
  CASE 
    WHEN EXISTS (SELECT 1 FROM "public"."novedades_email_logs_detalles" d WHERE d."id_email_log" = "novedades_email_logs"."id" AND d."estado" = 'ERROR') THEN 'CON_ERRORES'
    WHEN EXISTS (SELECT 1 FROM "public"."novedades_email_logs_detalles" d WHERE d."id_email_log" = "novedades_email_logs"."id" AND d."estado" = 'REQUIERE_REVISION') THEN 'CON_ADVERTENCIAS'
    ELSE 'PROCESADO'
  END;

-- AlterTable (Add new columns to observadores)
ALTER TABLE "public"."observadores" ADD COLUMN "cuil" TEXT,
ADD COLUMN "dni" TEXT,
ADD COLUMN "telefono_principal" TEXT;
