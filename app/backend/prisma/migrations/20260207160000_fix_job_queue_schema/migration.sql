-- Paso 1: Agregar campos faltantes a la tabla job_queue
ALTER TABLE "public"."job_queue" 
  ADD COLUMN IF NOT EXISTS "result" JSONB,
  ADD COLUMN IF NOT EXISTS "duration" INTEGER,
  ADD COLUMN IF NOT EXISTS "stack_trace" TEXT,
  ADD COLUMN IF NOT EXISTS "error_message" TEXT,
  ADD COLUMN IF NOT EXISTS "worker_id" TEXT;

-- Paso 2: Migrar datos de last_error a error_message si existe
DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_schema = 'public' 
    AND table_name = 'job_queue' 
    AND column_name = 'last_error'
  ) THEN
    UPDATE "public"."job_queue" 
    SET "error_message" = "last_error" 
    WHERE "last_error" IS NOT NULL AND "error_message" IS NULL;
    
    ALTER TABLE "public"."job_queue" DROP COLUMN "last_error";
  END IF;
END $$;

-- Paso 3: Crear los enums si no existen
DO $$ BEGIN
  CREATE TYPE "public"."JobStatus" AS ENUM ('PENDING', 'PROCESSING', 'COMPLETED', 'FAILED', 'CANCELLED');
EXCEPTION
  WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
  CREATE TYPE "public"."JobType" AS ENUM ('VESSEL_SYNC', 'TRAJECTORY_SYNC', 'NOTIFICATION', 'REPORT_GENERATION');
EXCEPTION
  WHEN duplicate_object THEN null;
END $$;

-- Paso 4: Validar y corregir datos existentes en type
-- Eliminar registros con valores inválidos o convertirlos a valores válidos
UPDATE "public"."job_queue" 
SET "type" = 'VESSEL_SYNC' 
WHERE "type" NOT IN ('VESSEL_SYNC', 'TRAJECTORY_SYNC', 'NOTIFICATION', 'REPORT_GENERATION');

-- Paso 5: Validar y corregir datos existentes en status
UPDATE "public"."job_queue" 
SET "status" = 'PENDING' 
WHERE "status" NOT IN ('PENDING', 'PROCESSING', 'COMPLETED', 'FAILED', 'CANCELLED');

-- Paso 6: Convertir columna type de TEXT a enum JobType usando columna temporal
ALTER TABLE "public"."job_queue" ADD COLUMN "type_new" "public"."JobType";
UPDATE "public"."job_queue" SET "type_new" = "type"::"public"."JobType";
ALTER TABLE "public"."job_queue" DROP COLUMN "type";
ALTER TABLE "public"."job_queue" RENAME COLUMN "type_new" TO "type";
ALTER TABLE "public"."job_queue" ALTER COLUMN "type" SET NOT NULL;

-- Paso 7: Convertir columna status de TEXT a enum JobStatus usando columna temporal
ALTER TABLE "public"."job_queue" ADD COLUMN "status_new" "public"."JobStatus";
UPDATE "public"."job_queue" SET "status_new" = "status"::"public"."JobStatus";
ALTER TABLE "public"."job_queue" DROP COLUMN "status";
ALTER TABLE "public"."job_queue" RENAME COLUMN "status_new" TO "status";
ALTER TABLE "public"."job_queue" ALTER COLUMN "status" SET NOT NULL;
ALTER TABLE "public"."job_queue" ALTER COLUMN "status" SET DEFAULT 'PENDING'::"public"."JobStatus";

-- Paso 8: Agregar índices faltantes
CREATE INDEX IF NOT EXISTS "job_queue_type_idx" ON "public"."job_queue"("type");
CREATE INDEX IF NOT EXISTS "job_queue_updated_at_idx" ON "public"."job_queue"("updated_at");
