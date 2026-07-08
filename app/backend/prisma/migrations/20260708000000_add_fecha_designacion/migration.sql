-- AlterTable
ALTER TABLE "public"."mareas" ADD COLUMN "fecha_designacion" TIMESTAMPTZ(6);

-- Backfill data (using fecha_creacion with time truncated to 00:00:00)
UPDATE "public"."mareas" 
SET "fecha_designacion" = DATE_TRUNC('day', "fecha_creacion");

-- Make column NOT NULL
ALTER TABLE "public"."mareas" ALTER COLUMN "fecha_designacion" SET NOT NULL;
