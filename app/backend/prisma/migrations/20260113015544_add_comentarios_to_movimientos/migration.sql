/*
  Warnings:

  - A unique constraint covering the columns `[anio_marea,nro_marea,tipo_marea]` on the table `mareas` will be added. If there are existing duplicate values, this will fail.

*/
-- DropIndex
DROP INDEX "mareas_anio_marea_nro_marea_id_buque_tipo_marea_key";

-- AlterTable
ALTER TABLE "mareas_movimientos" ADD COLUMN     "comentarios" TEXT;

-- CreateIndex
CREATE UNIQUE INDEX "mareas_anio_marea_nro_marea_tipo_marea_key" ON "mareas"("anio_marea", "nro_marea", "tipo_marea");
