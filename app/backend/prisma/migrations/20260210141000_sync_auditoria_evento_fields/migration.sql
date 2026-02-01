
-- Redefinir columnas en auditoria_eventos para permitir campos nulos y añadir criticidad
ALTER TABLE "audit"."auditoria_eventos" ALTER COLUMN "entidad_principal" DROP NOT NULL;
ALTER TABLE "audit"."auditoria_eventos" ADD COLUMN "es_critico" BOOLEAN NOT NULL DEFAULT false;
