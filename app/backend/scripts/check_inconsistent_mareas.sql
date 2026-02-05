-- SQL para identificar todas las mareas con inconsistencias de año
-- Regla: (Año Zarpada == Año Marea) OR (Año Zarpada == Año Marea + 1 AND Mes == Enero)

SELECT 
    m.id, 
    m.anio_marea, 
    m.nro_marea, 
    m.tipo_marea, 
    m.fecha_zarpada_estimada AT TIME ZONE 'UTC' as fecha_zarpada_utc,
    EXTRACT(YEAR FROM m.fecha_zarpada_estimada) as anio_real_zarpada,
    EXTRACT(MONTH FROM m.fecha_zarpada_estimada) as mes_real_zarpada,
    b.nombre_buque as buque
FROM public.mareas m
LEFT JOIN public.buques b ON m.id_buque = b.id
WHERE m.activo = true 
  AND m.fecha_zarpada_estimada IS NOT NULL 
  AND NOT (
      EXTRACT(YEAR FROM m.fecha_zarpada_estimada) = m.anio_marea 
      OR (
          EXTRACT(YEAR FROM m.fecha_zarpada_estimada) = m.anio_marea + 1 
          AND EXTRACT(MONTH FROM m.fecha_zarpada_estimada) = 1
      )
  )
ORDER BY m.anio_marea DESC, m.nro_marea DESC;
