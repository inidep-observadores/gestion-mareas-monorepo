-- Insertar tipo de novedad para Actualización de Cédula de Embarque
INSERT INTO "tipos_novedad" ("id", "codigo", "descripcion", "afecta_presentismo", "tipos_contrato_permitidos", "activo")
VALUES (gen_random_uuid(), 'ACTUALIZACION_CEDULA', 'Actualización de Cédula de Embarque', false, ARRAY[]::TEXT[], true)
ON CONFLICT ("codigo") DO UPDATE SET
  "descripcion" = EXCLUDED."descripcion",
  "afecta_presentismo" = EXCLUDED."afecta_presentismo",
  "tipos_contrato_permitidos" = EXCLUDED."tipos_contrato_permitidos",
  "activo" = EXCLUDED."activo";
