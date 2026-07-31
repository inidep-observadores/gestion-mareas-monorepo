-- AlterTable
ALTER TABLE "buques" ADD COLUMN     "habitabilidad_femenina_apta" BOOLEAN NOT NULL DEFAULT true;

-- AlterTable
ALTER TABLE "observadores" ADD COLUMN     "habilitado_congeladores" BOOLEAN NOT NULL DEFAULT true,
ADD COLUMN     "habilitado_fresqueros" BOOLEAN NOT NULL DEFAULT true;

-- CreateTable
CREATE TABLE "observadores_novedades" (
    "id" UUID NOT NULL,
    "id_observador" UUID NOT NULL,
    "estado_disponibilidad" TEXT NOT NULL,
    "fecha_inicio" DATE NOT NULL,
    "fecha_fin" DATE,
    "permite_urgencia" BOOLEAN NOT NULL DEFAULT false,
    "motivo" TEXT,
    "estado_aprobacion" TEXT NOT NULL DEFAULT 'APROBADA',
    "origen" TEXT NOT NULL DEFAULT 'MANUAL',
    "metadata" JSONB,
    "creado_por_id" UUID,
    "fecha_creacion" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "fecha_actualizacion" TIMESTAMPTZ(6) NOT NULL,

    CONSTRAINT "observadores_novedades_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "feriados" (
    "fecha" DATE NOT NULL,
    "nombre" TEXT NOT NULL,
    "tipo" TEXT NOT NULL,
    "origen" TEXT NOT NULL DEFAULT 'API',

    CONSTRAINT "feriados_pkey" PRIMARY KEY ("fecha")
);

-- CreateIndex
CREATE INDEX "observadores_novedades_id_observador_idx" ON "observadores_novedades"("id_observador");

-- CreateIndex
CREATE INDEX "observadores_novedades_fecha_inicio_fecha_fin_idx" ON "observadores_novedades"("fecha_inicio", "fecha_fin");

-- AddForeignKey
ALTER TABLE "observadores_novedades" ADD CONSTRAINT "observadores_novedades_id_observador_fkey" FOREIGN KEY ("id_observador") REFERENCES "observadores"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "observadores_novedades" ADD CONSTRAINT "observadores_novedades_creado_por_id_fkey" FOREIGN KEY ("creado_por_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;
