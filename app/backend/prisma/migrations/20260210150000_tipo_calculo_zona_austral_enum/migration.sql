-- CreateEnum
CREATE TYPE "public"."TipoCalculoZonaAustral" AS ENUM ('AUTOMATICO', 'MANUAL');

-- AlterTable
ALTER TABLE "mareas" ALTER COLUMN "tipo_calculo_zona_austral" DROP DEFAULT;
ALTER TABLE "mareas" ALTER COLUMN "tipo_calculo_zona_austral" TYPE "public"."TipoCalculoZonaAustral" USING "tipo_calculo_zona_austral"::"public"."TipoCalculoZonaAustral";
ALTER TABLE "mareas" ALTER COLUMN "tipo_calculo_zona_austral" SET DEFAULT 'AUTOMATICO';
