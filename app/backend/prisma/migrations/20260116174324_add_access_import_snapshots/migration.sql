/*
  Warnings:

  - A unique constraint covering the columns `[anio_marea,nro_marea,id_buque,tipo_marea]` on the table `mareas` will be added. If there are existing duplicate values, this will fail.

*/
-- DropIndex
DROP INDEX "mareas_anio_marea_nro_marea_tipo_marea_key";

-- CreateTable
CREATE TABLE "importacion_access_snapshots" (
    "id" UUID NOT NULL,
    "id_externo" INTEGER NOT NULL,
    "nro_marea" INTEGER,
    "anio_marea" INTEGER NOT NULL,
    "tipo_marea" TEXT NOT NULL,
    "nro_etapa" INTEGER NOT NULL,
    "fecha_zarpada" DATE,
    "fecha_arribo" DATE,
    "buque_nombre" TEXT,
    "observador_codigo" INTEGER,
    "hash_contenido" TEXT NOT NULL,
    "fecha_primera_lectura" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "fecha_ultima_lectura" TIMESTAMPTZ(6) NOT NULL,
    "marea_id" UUID,
    "etapa_id" UUID,

    CONSTRAINT "importacion_access_snapshots_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "importacion_access_snapshots_id_externo_key" ON "importacion_access_snapshots"("id_externo");

-- CreateIndex
CREATE INDEX "importacion_access_snapshots_nro_marea_anio_marea_tipo_mare_idx" ON "importacion_access_snapshots"("nro_marea", "anio_marea", "tipo_marea");

-- CreateIndex
CREATE UNIQUE INDEX "mareas_anio_marea_nro_marea_id_buque_tipo_marea_key" ON "mareas"("anio_marea", "nro_marea", "id_buque", "tipo_marea");
