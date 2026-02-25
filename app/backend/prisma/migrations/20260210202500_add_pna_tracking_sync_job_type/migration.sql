-- Paso 1: Añadir el valor 'PNA_TRACKING_SYNC' al enum 'JobType' de forma segura
-- Usamos una consulta directa para verificar si existe antes de intentar agregarlo.

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 
        FROM pg_type t 
        JOIN pg_enum e ON t.oid = e.enumtypid 
        JOIN pg_catalog.pg_namespace n ON n.oid = t.typnamespace
        WHERE t.typname = 'JobType' 
        AND n.nspname = 'public' 
        AND e.enumlabel = 'PNA_TRACKING_SYNC'
    ) THEN
        ALTER TYPE "public"."JobType" ADD VALUE 'PNA_TRACKING_SYNC';
    END IF;
END $$;
