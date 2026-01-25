/*
  Warnings:

  - You are about to drop the column `descripcion` on the `artes_pesca` table. All the data in the column will be lost.
  - Added the required column `nombre` to the `artes_pesca` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "artes_pesca" DROP COLUMN "descripcion",
ADD COLUMN     "nombre" TEXT NOT NULL;
