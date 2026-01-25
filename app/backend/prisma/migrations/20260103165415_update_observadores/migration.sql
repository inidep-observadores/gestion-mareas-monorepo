/*
  Warnings:

  - A unique constraint covering the columns `[email]` on the table `observadores` will be added. If there are existing duplicate values, this will fail.

*/
-- AlterTable
ALTER TABLE "observadores" ADD COLUMN     "con_impedimento" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "email" TEXT,
ADD COLUMN     "motivo_impedimento" TEXT;

-- CreateIndex
CREATE UNIQUE INDEX "observadores_email_key" ON "observadores"("email");
