-- AlterTable: Agregar calificacion con default 3 y cambiar default de habitabilidad_femenina_apta a false
ALTER TABLE "buques" ADD COLUMN "calificacion" INTEGER NOT NULL DEFAULT 3;
ALTER TABLE "buques" ALTER COLUMN "habitabilidad_femenina_apta" SET DEFAULT false;

-- Data migration: Convertir todos los valores actuales de habitabilidad_femenina_apta a false
UPDATE "buques" SET "habitabilidad_femenina_apta" = false;
