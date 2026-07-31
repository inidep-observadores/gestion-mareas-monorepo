-- Migración explícita no destructiva para convertir fechas a timestamptz
-- Se asume zona horaria de Buenos Aires (-3) para que la hora local quede en 00:00:00

ALTER TABLE "observadores_novedades" 
  ALTER COLUMN "fecha_inicio" TYPE TIMESTAMPTZ(6) USING ("fecha_inicio"::TIMESTAMP AT TIME ZONE 'America/Argentina/Buenos_Aires'),
  ALTER COLUMN "fecha_fin" TYPE TIMESTAMPTZ(6) USING ("fecha_fin"::TIMESTAMP AT TIME ZONE 'America/Argentina/Buenos_Aires');
