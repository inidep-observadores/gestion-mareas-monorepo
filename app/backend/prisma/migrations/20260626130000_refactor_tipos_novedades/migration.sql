-- CreateTable
CREATE TABLE "tipos_novedad" (
    "id" UUID NOT NULL,
    "codigo" TEXT NOT NULL,
    "descripcion" TEXT NOT NULL,
    "afecta_presentismo" BOOLEAN NOT NULL DEFAULT true,
    "tipos_contrato_permitidos" TEXT[] DEFAULT ARRAY[]::TEXT[],
    "activo" BOOLEAN NOT NULL DEFAULT true,
    "metadata" JSONB,

    CONSTRAINT "tipos_novedad_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "tipos_novedad_codigo_key" ON "tipos_novedad"("codigo");

-- Seed data from existing novedades (para capturar históricos no estándar)
INSERT INTO "tipos_novedad" ("id", "codigo", "descripcion", "afecta_presentismo")
SELECT DISTINCT gen_random_uuid(), "estado_disponibilidad", "estado_disponibilidad", true
FROM "observadores_novedades"
WHERE "estado_disponibilidad" IS NOT NULL
ON CONFLICT ("codigo") DO NOTHING;

-- Populate all missing and update descriptions/contracts for the known catalog
INSERT INTO "tipos_novedad" ("id", "codigo", "descripcion", "afecta_presentismo", "tipos_contrato_permitidos", "activo") VALUES
(gen_random_uuid(), 'LICEN', 'Licencia / Vacaciones', true, ARRAY['LEY MARCO', 'PLANTA PERMANENTE', '1109']::TEXT[], true),
(gen_random_uuid(), 'FC', 'Franco Compensatorio', true, ARRAY['LEY MARCO', 'PLANTA PERMANENTE', '1109']::TEXT[], true),
(gen_random_uuid(), 'RP', 'Razones Particulares', true, ARRAY['LEY MARCO', 'PLANTA PERMANENTE', '1109']::TEXT[], true),
(gen_random_uuid(), 'ENFERMEDAD', 'Enfermedad', true, ARRAY['LEY MARCO', 'PLANTA PERMANENTE', '1109']::TEXT[], true),
(gen_random_uuid(), 'MATERNIDAD', 'Maternidad', true, ARRAY['LEY MARCO', 'PLANTA PERMANENTE', '1109']::TEXT[], true),
(gen_random_uuid(), 'NACIMIENTO', 'Nacimiento', true, ARRAY['LEY MARCO', 'PLANTA PERMANENTE', '1109']::TEXT[], true),
(gen_random_uuid(), 'FALLECIMIENTO', 'Fallecimiento', true, ARRAY['LEY MARCO', 'PLANTA PERMANENTE', '1109']::TEXT[], true),
(gen_random_uuid(), 'EXAMEN', 'Examen', true, ARRAY['LEY MARCO', 'PLANTA PERMANENTE', '1109']::TEXT[], true),
(gen_random_uuid(), 'DONACION_SANGRE', 'Donación de Sangre', true, ARRAY['LEY MARCO', 'PLANTA PERMANENTE', '1109']::TEXT[], true),
(gen_random_uuid(), 'VIAJE_INICIO', 'Aviso de Viaje (Inicio)', false, ARRAY[]::TEXT[], true),
(gen_random_uuid(), 'VIAJE_FIN', 'Aviso de Viaje (Fin)', false, ARRAY[]::TEXT[], true),
(gen_random_uuid(), 'DISPONIBLE', 'Declaración de Disponibilidad', false, ARRAY[]::TEXT[], true),
(gen_random_uuid(), 'NO_DISPONIBLE', 'Declaración de No Disponibilidad', false, ARRAY[]::TEXT[], true)
ON CONFLICT ("codigo") DO UPDATE SET
  "descripcion" = EXCLUDED."descripcion",
  "afecta_presentismo" = EXCLUDED."afecta_presentismo",
  "tipos_contrato_permitidos" = EXCLUDED."tipos_contrato_permitidos";

-- AddColumn (Nullable initially for backfill)
ALTER TABLE "observadores_novedades" ADD COLUMN "id_tipo_novedad" UUID;

-- Backfill id_tipo_novedad
UPDATE "observadores_novedades" o
SET "id_tipo_novedad" = (SELECT t."id" FROM "tipos_novedad" t WHERE t."codigo" = o."estado_disponibilidad");

-- AlterColumn (Make it NOT NULL)
ALTER TABLE "observadores_novedades" ALTER COLUMN "id_tipo_novedad" SET NOT NULL;

-- Drop Column (Now it's safe)
ALTER TABLE "observadores_novedades" DROP COLUMN "estado_disponibilidad";

-- AddForeignKey
ALTER TABLE "observadores_novedades" ADD CONSTRAINT "observadores_novedades_id_tipo_novedad_fkey" FOREIGN KEY ("id_tipo_novedad") REFERENCES "tipos_novedad"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
