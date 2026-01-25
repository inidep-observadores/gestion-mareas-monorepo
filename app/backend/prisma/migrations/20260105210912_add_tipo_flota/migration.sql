/*
  Warnings:

  - A unique constraint covering the columns `[codigo_numerico]` on the table `tipos_flota` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `codigo_numerico` to the `tipos_flota` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "tipos_flota" ADD COLUMN     "codigo_numerico" INTEGER NOT NULL;

-- CreateIndex
CREATE UNIQUE INDEX "tipos_flota_codigo_numerico_key" ON "tipos_flota"("codigo_numerico");
