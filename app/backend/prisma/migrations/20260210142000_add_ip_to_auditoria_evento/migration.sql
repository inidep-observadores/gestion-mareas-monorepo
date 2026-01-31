
-- Añadir columna ip a auditoria_eventos
ALTER TABLE "audit"."auditoria_eventos" ADD COLUMN "ip" TEXT;
