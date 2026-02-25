-- Paso 1: Añadir el valor 'PNA_API_SYNC' al enum 'JobType' de forma segura
-- Nota: ALTER TYPE ... ADD VALUE no puede ejecutarse dentro de un bloque transaccional DO en PostgreSQL.
-- Por lo tanto, usamos una consulta directa para verificar si existe antes de intentar agregarlo.

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 
        FROM pg_type t 
        JOIN pg_enum e ON t.oid = e.enumtypid 
        JOIN pg_catalog.pg_namespace n ON n.oid = t.typnamespace
        WHERE t.typname = 'JobType' 
        AND n.nspname = 'public' 
        AND e.enumlabel = 'PNA_API_SYNC'
    ) THEN
        ALTER TYPE "public"."JobType" ADD VALUE 'PNA_API_SYNC';
    END IF;
END $$;
