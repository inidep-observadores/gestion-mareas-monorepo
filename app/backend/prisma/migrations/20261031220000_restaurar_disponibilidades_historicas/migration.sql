-- Migración para restaurar novedades de disponibilidad y no disponibilidad indebidamente anuladas por rectificación previa
-- cuando existió al menos una marea intermedia entre la novedad original y su supuesto reemplazo.

DO $$
DECLARE
    r RECORD;
    v_usuario_sistema_id UUID;
BEGIN
    -- Obtener un ID de usuario para auditoría (o NULL si no existe)
    SELECT id INTO v_usuario_sistema_id FROM users WHERE email LIKE '%admin%' OR email LIKE '%sistema%' LIMIT 1;

    -- Cursor de novedades DISPONIBLE o NO_DISPONIBLE anuladas indebidamente
    FOR r IN
        SELECT DISTINCT n.id, n.id_observador, n.fecha_inicio, n.fecha_fin, n.id_tipo_novedad, tn.codigo as tipo_codigo
        FROM observadores_novedades n
        JOIN tipos_novedad tn ON tn.id = n.id_tipo_novedad
        WHERE tn.codigo IN ('DISPONIBLE', 'NO_DISPONIBLE')
          AND n.activo = false
          AND n.estado_aprobacion = 'RECHAZADA'
          AND EXISTS (
              SELECT 1 
              FROM observadores_novedades_movimientos m 
              WHERE m.id_novedad = n.id 
                AND m.tipo_evento IN ('REEMPLAZADA_POR_CORRECCION', 'REEMPLAZADA_POR_DISPONIBILIDAD', 'REEMPLAZADA_POR_EMAIL')
          )
          -- Verificar si existió al menos una marea activa del observador entre la fecha_inicio y la fecha del reemplazo
          AND EXISTS (
              SELECT 1 
              FROM mareas mar
              WHERE mar.activo = true
                AND (
                    mar.id_observador_principal = n.id_observador
                    OR EXISTS (
                        SELECT 1 
                        FROM mareas_etapas et
                        JOIN mareas_etapas_observadores eo ON eo.id_etapa = et.id
                        WHERE et.id_marea = mar.id 
                          AND eo.id_observador = n.id_observador
                    )
                )
                AND (
                    COALESCE(mar.fecha_inicio_observador, mar.fecha_zarpada_estimada) >= n.fecha_inicio
                    AND COALESCE(mar.fecha_inicio_observador, mar.fecha_zarpada_estimada) <= (
                        SELECT COALESCE(MAX(mov.fecha_hora), NOW())
                        FROM observadores_novedades_movimientos mov
                        WHERE mov.id_novedad = n.id
                          AND mov.tipo_evento IN ('REEMPLAZADA_POR_CORRECCION', 'REEMPLAZADA_POR_DISPONIBILIDAD', 'REEMPLAZADA_POR_EMAIL')
                    )
                )
          )
    LOOP
        -- 1. Restaurar la novedad histórica
        UPDATE observadores_novedades
        SET activo = true,
            estado_aprobacion = 'APROBADA'
        WHERE id = r.id;

        -- 2. Registrar el movimiento de auditoría
        INSERT INTO observadores_novedades_movimientos (
            id,
            id_novedad,
            tipo_evento,
            estado_anterior,
            estado_nuevo,
            comentarios,
            fecha_hora,
            id_usuario
        ) VALUES (
            gen_random_uuid(),
            r.id,
            'APROBACION',
            'RECHAZADA',
            'APROBADA',
            'Restaurada automáticamente por migración de sistema: disponibilidad válida de ciclo de marea previo.',
            NOW(),
            v_usuario_sistema_id
        );

        -- 3. Limpiar en las novedades que la apuntaban erróneamente como novedadOriginalId
        UPDATE observadores_novedades
        SET metadata = (metadata - 'esCorreccion') - 'novedadOriginalId'
        WHERE metadata->>'novedadOriginalId' = r.id::text;

    END LOOP;
END $$;

