-- Normalizar fechas truncando la componente de hora a 00:00:00
-- Tabla mareas
UPDATE mareas SET 
  fecha_zarpada_estimada = date_trunc('day', fecha_zarpada_estimada),
  fecha_inicio_observador = date_trunc('day', fecha_inicio_observador),
  fecha_fin_observador = date_trunc('day', fecha_fin_observador),
  fecha_protocolizacion = date_trunc('day', fecha_protocolizacion)
WHERE 
  fecha_zarpada_estimada IS NOT NULL OR 
  fecha_inicio_observador IS NOT NULL OR 
  fecha_fin_observador IS NOT NULL OR 
  fecha_protocolizacion IS NOT NULL;

-- Tabla mareas_etapas
UPDATE mareas_etapas SET 
  fecha_zarpada = date_trunc('day', fecha_zarpada),
  fecha_arribo = date_trunc('day', fecha_arribo)
WHERE 
  fecha_zarpada IS NOT NULL OR 
  fecha_arribo IS NOT NULL;
