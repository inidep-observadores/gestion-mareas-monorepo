/*
  Warnings:

  - Made the column `updated_at` on table `mareas_etapas` required. This step will fail if there are existing NULL values in that column.

*/
-- AlterTable
-- Primero inicializamos los valores NULL con la fecha actual para que la restricción NOT NULL sea segura
UPDATE "mareas_etapas" SET "updated_at" = NOW() WHERE "updated_at" IS NULL;

ALTER TABLE "mareas_etapas" ALTER COLUMN "updated_at" SET NOT NULL;
