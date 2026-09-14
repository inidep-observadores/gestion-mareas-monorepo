-- Convertir columnas de vencimiento en observadores a TIMESTAMPTZ(6)
-- Asegurando que la fecha local en 'America/Argentina/Buenos_Aires' preserve el día correcto a las 00:00:00

ALTER TABLE "observadores"
  ALTER COLUMN "vencimiento_cedula" TYPE TIMESTAMPTZ(6) USING (
    CASE 
      WHEN "vencimiento_cedula" IS NOT NULL THEN ("vencimiento_cedula"::TIMESTAMP AT TIME ZONE 'America/Argentina/Buenos_Aires')
      ELSE NULL
    END
  ),
  ALTER COLUMN "vencimiento_apto_medico" TYPE TIMESTAMPTZ(6) USING (
    CASE 
      WHEN "vencimiento_apto_medico" IS NOT NULL THEN ("vencimiento_apto_medico"::TIMESTAMP AT TIME ZONE 'America/Argentina/Buenos_Aires')
      ELSE NULL
    END
  );
