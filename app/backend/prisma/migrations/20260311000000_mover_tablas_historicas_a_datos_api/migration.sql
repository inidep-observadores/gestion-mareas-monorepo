-- Migration: Mover tablas históricas de API al esquema 'datos_api'
-- Motivo: Estas tablas crecen a ritmo muy alto y separarlas en un esquema
-- independiente permite hacer backups del esquema 'public' más pequeños
-- y programar copias de seguridad independientes por esquema.

-- 1. Crear el nuevo esquema
CREATE SCHEMA IF NOT EXISTS datos_api;

-- 2. Mover las tablas históricas de buque trayectorias
--    Se preservan todos los datos, índices y restricciones.
ALTER TABLE public.buque_trayectorias SET SCHEMA datos_api;
ALTER TABLE public.buque_trayectoria_puntos SET SCHEMA datos_api;

-- 3. Mover la tabla histórica de PNA zarpadas/arribos
ALTER TABLE public.pna_zarpadas_arribos SET SCHEMA datos_api;
