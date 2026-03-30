-- CreateEnum
CREATE TYPE "public"."Sexo" AS ENUM ('Masculino', 'Femenino');

-- AlterTable
ALTER TABLE "public"."observadores" ADD COLUMN     "eventual" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "sexo" "public"."Sexo" NOT NULL DEFAULT 'Masculino';
