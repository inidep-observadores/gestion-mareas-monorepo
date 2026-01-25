/*
  Warnings:

  - Changed the type of `estado` on the `alertas` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.
  - Changed the type of `prioridad` on the `alertas` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.

*/
-- CreateEnum
CREATE TYPE "AlertaEstado" AS ENUM ('PENDIENTE', 'SEGUIMIENTO', 'RESUELTA', 'DESCARTADA', 'VENCIDA');

-- CreateEnum
CREATE TYPE "AlertaPrioridad" AS ENUM ('URGENTE', 'ALTA', 'MEDIA', 'BAJA');

-- DropIndex
DROP INDEX IF EXISTS "alertas_estado_idx";

-- AlterTable
ALTER TABLE "alertas" ALTER COLUMN "estado" TYPE "AlertaEstado" USING ("estado"::"AlertaEstado");
ALTER TABLE "alertas" ALTER COLUMN "prioridad" TYPE "AlertaPrioridad" USING ("prioridad"::"AlertaPrioridad");

-- CreateIndex
CREATE INDEX "alertas_estado_idx" ON "alertas"("estado");
