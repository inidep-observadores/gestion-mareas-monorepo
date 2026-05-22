-- Migración: Agregar transiciones de flexibilidad desde EN_EJECUCION
-- Fecha: 2026-03-12

DO $$ 
DECLARE
    id_en_ejecucion UUID;
    id_cancelada UUID;
    id_a_reasignar UUID;
    id_designada UUID;
BEGIN
    -- Obtener IDs de los estados
    SELECT id INTO id_en_ejecucion FROM public.estados_marea WHERE codigo = 'EN_EJECUCION';
    SELECT id INTO id_cancelada FROM public.estados_marea WHERE codigo = 'CANCELADA';
    SELECT id INTO id_a_reasignar FROM public.estados_marea WHERE codigo = 'A_REASIGNAR';
    SELECT id INTO id_designada FROM public.estados_marea WHERE codigo = 'DESIGNADA';

    -- Insertar transiciones si no existen
    
    -- EN_EJECUCION -> CANCELADA
    -- INSERT INTO public.transiciones_estados (id, id_estado_origen, id_estado_destino, accion, etiqueta, clase_boton, requiere_observaciones, activo)
    -- VALUES (gen_random_uuid(), id_en_ejecucion, id_cancelada, 'CANCELAR', 'Cancelar Marea', 'error', true, true)
    -- ON CONFLICT (id_estado_origen, id_estado_destino, accion) DO NOTHING;

    -- EN_EJECUCION -> A_REASIGNAR
    -- INSERT INTO public.transiciones_estados (id, id_estado_origen, id_estado_destino, accion, etiqueta, clase_boton, requiere_observaciones, activo)
    -- VALUES (gen_random_uuid(), id_en_ejecucion, id_a_reasignar, 'PASAR_A_REASIGNAR', 'Reasignar Observador', 'error', true, true)
    -- ON CONFLICT (id_estado_origen, id_estado_destino, accion) DO NOTHING;

    -- EN_EJECUCION -> DESIGNADA (Deshacer Inicio)
    -- INSERT INTO public.transiciones_estados (id, id_estado_origen, id_estado_destino, accion, etiqueta, clase_boton, requiere_observaciones, activo)
    -- VALUES (gen_random_uuid(), id_en_ejecucion, id_designada, 'DESHACER_INICIO', 'Deshacer Inicio', 'error', true, true)
    -- ON CONFLICT (id_estado_origen, id_estado_destino, accion) DO NOTHING;

END $$;
