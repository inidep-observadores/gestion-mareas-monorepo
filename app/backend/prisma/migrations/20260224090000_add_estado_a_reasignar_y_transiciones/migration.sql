-- Inserción del estado A_REASIGNAR
-- INSERT INTO "public"."estados_marea" ("id", "codigo", "nombre", "categoria", "orden", "es_inicial", "es_final", "permite_carga_archivos", "permite_correccion", "permite_informe", "activo", "mostrar_en_panel", "descripcion")
-- VALUES ('8b19bd88-6927-4a0b-9db6-3a7b68603683', 'A_REASIGNAR', 'A reasignar', 'PENDIENTE', 14, false, false, false, false, false, true, true, NULL)
-- ON CONFLICT ("codigo") DO NOTHING;

-- Inserción de Transiciones
-- DESIGNADA -> A_REASIGNAR
-- INSERT INTO "public"."transiciones_estados" ("id", "id_estado_origen", "id_estado_destino", "accion", "etiqueta", "clase_boton", "requiere_observaciones", "activo")
-- VALUES ('18b387ba-ed7a-4cce-9a1b-bd0828decd2e', '3af8b7d1-f41d-4029-83ae-ef5e178ff565', '8b19bd88-6927-4a0b-9db6-3a7b68603683', 'PASAR_A_REASIGNAR', 'Guardar para Reasignar', 'warning', true, true)
-- ON CONFLICT ("id") DO NOTHING;

-- A_REASIGNAR -> DESIGNADA
-- INSERT INTO "public"."transiciones_estados" ("id", "id_estado_origen", "id_estado_destino", "accion", "etiqueta", "clase_boton", "requiere_observaciones", "activo")
-- VALUES ('24f0c904-747f-4b07-afb0-2b1ed8b54da7', '8b19bd88-6927-4a0b-9db6-3a7b68603683', '3af8b7d1-f41d-4029-83ae-ef5e178ff565', 'RESTAURAR_DESIGNACION', 'Restaurar Designación', 'primary', false, true)
-- ON CONFLICT ("id") DO NOTHING;

-- A_REASIGNAR -> CANCELADA
-- INSERT INTO "public"."transiciones_estados" ("id", "id_estado_origen", "id_estado_destino", "accion", "etiqueta", "clase_boton", "requiere_observaciones", "activo")
-- VALUES ('4bd075db-c3ea-448f-bb7e-f63b2f567083', '8b19bd88-6927-4a0b-9db6-3a7b68603683', '2ea71871-f6e2-480b-bb64-6d2f436ffa6f', 'CANCELAR', 'Cancelar', 'error', true, true)
-- ON CONFLICT ("id") DO NOTHING;
