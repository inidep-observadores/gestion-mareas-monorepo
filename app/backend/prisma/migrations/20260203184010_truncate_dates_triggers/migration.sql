-- DropIndex
DROP INDEX "audit"."auditoria_api_categoria_timestamp_idx";

-- DropIndex
DROP INDEX "audit"."auditoria_api_es_critico_timestamp_idx";

-- DropIndex
DROP INDEX "audit"."auditoria_api_es_error_timestamp_idx";

-- DropIndex
DROP INDEX "audit"."auditoria_api_ruta_timestamp_idx";

-- DropIndex
DROP INDEX "audit"."auditoria_api_usuario_id_timestamp_idx";

-- DropIndex
DROP INDEX "audit"."auditoria_entidad_entidad_tipo_entidad_id_timestamp_idx";

-- DropIndex
DROP INDEX "audit"."auditoria_entidad_operacion_timestamp_idx";

-- DropIndex
DROP INDEX "audit"."auditoria_entidad_usuario_id_timestamp_idx";

-- DropIndex
DROP INDEX "audit"."auditoria_eventos_categoria_timestamp_idx";

-- DropIndex
DROP INDEX "audit"."auditoria_eventos_resultado_timestamp_idx";

-- DropIndex
DROP INDEX "audit"."auditoria_eventos_tipo_evento_timestamp_idx";

-- DropIndex
DROP INDEX "audit"."auditoria_eventos_usuario_id_timestamp_idx";

-- DropIndex
DROP INDEX "audit"."auditoria_navegacion_session_id_idx";

-- DropIndex
DROP INDEX "audit"."auditoria_navegacion_usuario_id_timestamp_idx";

-- --- Custom Triggers for Truncating Dates to 00:00:00 ---

CREATE OR REPLACE FUNCTION truncate_timestamp_fields()
RETURNS TRIGGER AS $$
BEGIN
    -- Logic for 'mareas' table
    IF TG_TABLE_NAME = 'mareas' THEN
        IF NEW.fecha_zarpada_estimada IS NOT NULL THEN
            NEW.fecha_zarpada_estimada := date_trunc('day', NEW.fecha_zarpada_estimada);
        END IF;
        IF NEW.fecha_inicio_observador IS NOT NULL THEN
            NEW.fecha_inicio_observador := date_trunc('day', NEW.fecha_inicio_observador);
        END IF;
        IF NEW.fecha_fin_observador IS NOT NULL THEN
            NEW.fecha_fin_observador := date_trunc('day', NEW.fecha_fin_observador);
        END IF;
        IF NEW.fecha_protocolizacion IS NOT NULL THEN
            NEW.fecha_protocolizacion := date_trunc('day', NEW.fecha_protocolizacion);
        END IF;
    -- Logic for 'mareas_etapas' table
    ELSIF TG_TABLE_NAME = 'mareas_etapas' THEN
        IF NEW.fecha_zarpada IS NOT NULL THEN
            NEW.fecha_zarpada := date_trunc('day', NEW.fecha_zarpada);
        END IF;
        IF NEW.fecha_arribo IS NOT NULL THEN
            NEW.fecha_arribo := date_trunc('day', NEW.fecha_arribo);
        END IF;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger for 'mareas'
DROP TRIGGER IF EXISTS trg_truncate_dates_mareas ON public.mareas;
CREATE TRIGGER trg_truncate_dates_mareas
    BEFORE INSERT OR UPDATE ON public.mareas
    FOR EACH ROW
    EXECUTE FUNCTION truncate_timestamp_fields();

-- Trigger for 'mareas_etapas'
DROP TRIGGER IF EXISTS trg_truncate_dates_mareas_etapas ON public.mareas_etapas;
CREATE TRIGGER trg_truncate_dates_mareas_etapas
    BEFORE INSERT OR UPDATE ON public.mareas_etapas
    FOR EACH ROW
    EXECUTE FUNCTION truncate_timestamp_fields();
