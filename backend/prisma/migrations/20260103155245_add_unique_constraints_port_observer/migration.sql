/*
  Warnings:

  - A unique constraint covering the columns `[codigo_interno]` on the table `observadores` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[codigo_interno]` on the table `puertos` will be added. If there are existing duplicate values, this will fail.

*/
-- CreateIndex
CREATE UNIQUE INDEX "observadores_codigo_interno_key" ON "observadores"("codigo_interno");

-- CreateIndex
CREATE UNIQUE INDEX "puertos_codigo_interno_key" ON "puertos"("codigo_interno");
