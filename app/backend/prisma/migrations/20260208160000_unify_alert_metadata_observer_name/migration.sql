-- Unificación de metadatos de alertas: observadorNombre -> observerName
-- Esta migración mueve el valor de la clave 'observadorNombre' a 'observerName' si esta última no existe,
-- y luego elimina la clave redundante 'observadorNombre' del campo JSON 'metadata'.

-- 1. Copiar valor a observerName si no existe
UPDATE public.alertas
SET metadata = metadata || jsonb_build_object('observerName', metadata->>'observadorNombre')
WHERE metadata ? 'observadorNombre' 
  AND (NOT metadata ? 'observerName' OR metadata->>'observerName' IS NULL OR metadata->>'observerName' = '');

-- 2. Eliminar la clave observadorNombre
UPDATE public.alertas
SET metadata = metadata - 'observadorNombre'
WHERE metadata ? 'observadorNombre';
