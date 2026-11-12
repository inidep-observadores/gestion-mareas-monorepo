-- AlterTable: Agregar documentación de embarque a observadores de forma segura y no destructiva
ALTER TABLE "public"."observadores" 
ADD COLUMN IF NOT EXISTS "numero_cedula" INTEGER,
ADD COLUMN IF NOT EXISTS "vencimiento_cedula" DATE,
ADD COLUMN IF NOT EXISTS "vencimiento_apto_medico" DATE,
ADD COLUMN IF NOT EXISTS "fecha_actualizacion_documentacion" TIMESTAMPTZ(6);
