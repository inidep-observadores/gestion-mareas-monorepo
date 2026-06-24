-- AlterTable
ALTER TABLE "public"."buques" ADD COLUMN "habitabilidad_femenina_apta" BOOLEAN DEFAULT false;

-- AlterTable
ALTER TABLE "public"."observadores" ADD COLUMN "habilitado_congeladores" BOOLEAN DEFAULT false,
ADD COLUMN "habilitado_fresqueros" BOOLEAN DEFAULT false;

-- CreateTable
CREATE TABLE "public"."feriados" (
    "id" SERIAL NOT NULL,
    "fecha" TIMESTAMP(3) NOT NULL,
    "motivo" TEXT NOT NULL,
    "tipo" TEXT NOT NULL,
    "opcional" TEXT,
    CONSTRAINT "feriados_pkey" PRIMARY KEY ("id")
);
CREATE UNIQUE INDEX "feriados_fecha_key" ON "public"."feriados"("fecha");

-- CreateTable
CREATE TABLE "public"."observadores_novedades" (
    "id" UUID NOT NULL,
    "id_observador" UUID NOT NULL,
    "estado_disponibilidad" TEXT NOT NULL,
    "fecha_inicio" TIMESTAMP(3) NOT NULL,
    "fecha_fin" TIMESTAMP(3),
    "motivo" TEXT,
    "creado_por_id" UUID,
    "creado_en" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "actualizado_en" TIMESTAMP(3) NOT NULL,
    "permite_urgencia" BOOLEAN NOT NULL DEFAULT false,
    CONSTRAINT "observadores_novedades_pkey" PRIMARY KEY ("id")
);
CREATE INDEX "observadores_novedades_id_observador_idx" ON "public"."observadores_novedades"("id_observador");
CREATE INDEX "observadores_novedades_fecha_inicio_fecha_fin_idx" ON "public"."observadores_novedades"("fecha_inicio", "fecha_fin");
ALTER TABLE "public"."observadores_novedades" ADD CONSTRAINT "observadores_novedades_id_observador_fkey" FOREIGN KEY ("id_observador") REFERENCES "public"."observadores"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "public"."observadores_novedades" ADD CONSTRAINT "observadores_novedades_creado_por_id_fkey" FOREIGN KEY ("creado_por_id") REFERENCES "public"."User"("id") ON DELETE SET NULL ON UPDATE CASCADE;
