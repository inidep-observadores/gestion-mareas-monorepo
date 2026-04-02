-- AlterTable: agrega columna mostrar_en_panel a transiciones_estados
-- Por defecto true para no afectar transiciones existentes.
-- Las transiciones de protocolización (INICIAR_TRAMITE, FINALIZAR_PROTOCOLIZACION)
-- se actualizan a false ya que se gestionan desde la vista especializada de protocolización.

ALTER TABLE "public"."transiciones_estados"
  ADD COLUMN "mostrar_en_panel" BOOLEAN NOT NULL DEFAULT true;

UPDATE "public"."transiciones_estados"
  SET "mostrar_en_panel" = false
  WHERE "accion" IN ('INICIAR_TRAMITE', 'FINALIZAR_PROTOCOLIZACION');
