-- AlterEnum
ALTER TYPE "JobType" ADD VALUE 'NOVEDADES_EMAIL_SYNC';

-- CreateTable
CREATE TABLE "observadores_novedades_archivos" (
    "id" UUID NOT NULL,
    "id_novedad" UUID NOT NULL,
    "ruta_archivo" TEXT NOT NULL,
    "tipo_archivo" TEXT NOT NULL,
    "nombre_original" TEXT,
    "drive_file_id" TEXT,
    "fecha_subida" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "observadores_novedades_archivos_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "observadores_novedades_archivos_id_novedad_idx" ON "observadores_novedades_archivos"("id_novedad");

-- AddForeignKey
ALTER TABLE "observadores_novedades_archivos" ADD CONSTRAINT "observadores_novedades_archivos_id_novedad_fkey" FOREIGN KEY ("id_novedad") REFERENCES "observadores_novedades"("id") ON DELETE CASCADE ON UPDATE CASCADE;

