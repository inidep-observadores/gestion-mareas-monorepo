-- Migración: Agregar estado DESESTIMADA y corregir nombre de CANCELADA
-- Fecha: 2026-04-02
--
-- DESESTIMADA: identifica mareas que sí se ejecutaron pero cuyos datos fueron
-- descartados por calidad deficiente, planillas no entregadas u otros motivos.
-- A diferencia de CANCELADA (nunca ejecutadas), estas mareas existieron operativamente
-- pero no se incorporarán a la base de datos histórica institucional.

-- 1. Corregir nombre de CANCELADA (era 'Cancelada / Desestimada', ambiguo)
UPDATE "public"."estados_marea"
SET "nombre" = 'Cancelada'
WHERE "codigo" = 'CANCELADA';

-- 2. Insertar el nuevo estado DESESTIMADA
INSERT INTO "public"."estados_marea" (
  "id", "codigo", "nombre", "categoria", "orden",
  "es_inicial", "es_final",
  "permite_carga_archivos", "permite_correccion", "permite_informe",
  "activo", "mostrar_en_panel", "descripcion"
)
VALUES (
  gen_random_uuid(), 'DESESTIMADA', 'Desestimada', 'CANCELADO', 14,
  false, true,
  false, false, false,
  true, false, NULL
)
ON CONFLICT ("codigo") DO NOTHING;

-- 3. Insertar transiciones hacia DESESTIMADA desde todos los estados post-ejecución
-- Se usa DO $$ para poder resolver los IDs de estados por código
DO $$
DECLARE
  id_desestimada        UUID;
  id_en_ejecucion       UUID;
  id_esperando_entrega  UUID;
  id_entregada_recibida UUID;
  id_verificacion       UUID;
  id_en_correccion      UUID;
  id_delegada_externa   UUID;
  id_pendiente_informe  UUID;
BEGIN
  SELECT id INTO id_desestimada        FROM public.estados_marea WHERE codigo = 'DESESTIMADA';
  SELECT id INTO id_en_ejecucion       FROM public.estados_marea WHERE codigo = 'EN_EJECUCION';
  SELECT id INTO id_esperando_entrega  FROM public.estados_marea WHERE codigo = 'ESPERANDO_ENTREGA';
  SELECT id INTO id_entregada_recibida FROM public.estados_marea WHERE codigo = 'ENTREGADA_RECIBIDA';
  SELECT id INTO id_verificacion       FROM public.estados_marea WHERE codigo = 'VERIFICACION_INICIAL';
  SELECT id INTO id_en_correccion      FROM public.estados_marea WHERE codigo = 'EN_CORRECCION';
  SELECT id INTO id_delegada_externa   FROM public.estados_marea WHERE codigo = 'DELEGADA_EXTERNA';
  SELECT id INTO id_pendiente_informe  FROM public.estados_marea WHERE codigo = 'PENDIENTE_DE_INFORME';

  INSERT INTO public.transiciones_estados (id, id_estado_origen, id_estado_destino, accion, etiqueta, clase_boton, requiere_observaciones, activo, mostrar_en_panel)
  VALUES
    (gen_random_uuid(), id_en_ejecucion,       id_desestimada, 'DESESTIMAR', 'Desestimar', 'error', true, true, true),
    (gen_random_uuid(), id_esperando_entrega,  id_desestimada, 'DESESTIMAR', 'Desestimar', 'error', true, true, true),
    (gen_random_uuid(), id_entregada_recibida, id_desestimada, 'DESESTIMAR', 'Desestimar', 'error', true, true, true),
    (gen_random_uuid(), id_verificacion,       id_desestimada, 'DESESTIMAR', 'Desestimar', 'error', true, true, true),
    (gen_random_uuid(), id_en_correccion,      id_desestimada, 'DESESTIMAR', 'Desestimar', 'error', true, true, true),
    (gen_random_uuid(), id_delegada_externa,   id_desestimada, 'DESESTIMAR', 'Desestimar', 'error', true, true, true),
    (gen_random_uuid(), id_pendiente_informe,  id_desestimada, 'DESESTIMAR', 'Desestimar', 'error', true, true, true)
  ON CONFLICT (id_estado_origen, id_estado_destino, accion) DO NOTHING;
END $$;
