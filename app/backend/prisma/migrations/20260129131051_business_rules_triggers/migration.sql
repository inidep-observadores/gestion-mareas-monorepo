-- 1. check_observador_disponibilidad
CREATE OR REPLACE FUNCTION check_observador_disponibilidad()
RETURNS TRIGGER AS $$
BEGIN
    -- Si tiene impedimento, NO puede estar disponible
    IF NEW.con_impedimento = true AND NEW.disponible = true THEN
        RAISE EXCEPTION 'Un observador no puede estar disponible y tener impedimento al mismo tiempo.';
    END IF;

    -- Limpieza automática: Si no tiene impedimento, motivo debe ser NULL
    IF NEW.con_impedimento = false THEN
        NEW.motivo_impedimento := NULL;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_check_observador_disponibilidad ON observadores;
CREATE TRIGGER trg_check_observador_disponibilidad
    BEFORE INSERT OR UPDATE ON observadores
    FOR EACH ROW
    EXECUTE FUNCTION check_observador_disponibilidad();


-- 2. check_marea_observador_fechas
CREATE OR REPLACE FUNCTION check_marea_observador_fechas()
RETURNS TRIGGER AS $$
BEGIN
    -- Validar consistencia de fechas si ambas están precentes
    IF NEW.fecha_fin_observador IS NOT NULL THEN
        IF NEW.fecha_inicio_observador IS NULL THEN
             RAISE EXCEPTION 'Si se especifica la fecha de fin del observador, la fecha de inicio es obligatoria.';
        END IF;

        IF NEW.fecha_inicio_observador > NEW.fecha_fin_observador THEN
            RAISE EXCEPTION 'La fecha de inicio del observador no puede ser posterior a la de fin.';
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_check_marea_observador_fechas ON mareas;
CREATE TRIGGER trg_check_marea_observador_fechas
    BEFORE INSERT OR UPDATE ON mareas
    FOR EACH ROW
    EXECUTE FUNCTION check_marea_observador_fechas();


-- 3. check_marea_estado_cierre
CREATE OR REPLACE FUNCTION check_marea_estado_cierre()
RETURNS TRIGGER AS $$
DECLARE
    v_estado_codigo VARCHAR;
BEGIN
    -- Solo validar si se está estableciendo fecha de fin (y antes no tenía o ha cambiado)
    IF NEW.fecha_fin_observador IS NOT NULL THEN
        
        -- Obtener código del estado RESULTANTE (NEW.id_estado_actual)
        SELECT codigo INTO v_estado_codigo
        FROM estados_marea
        WHERE id = NEW.id_estado_actual;

        -- Si el estado resultante es Activo, error
        IF v_estado_codigo IN ('DESIGNADA', 'EN_EJECUCION') THEN
             RAISE EXCEPTION 'No se puede establecer la fecha de fin del observador mientras la marea esté (o permanezca) en estado %.', v_estado_codigo;
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_check_marea_estado_cierre ON mareas;
CREATE TRIGGER trg_check_marea_estado_cierre
    BEFORE UPDATE ON mareas
    FOR EACH ROW
    EXECUTE FUNCTION check_marea_estado_cierre();


-- 4. check_protocolizacion_atomica
CREATE OR REPLACE FUNCTION check_protocolizacion_atomica()
RETURNS TRIGGER AS $$
DECLARE
    v_has_nro BOOLEAN;
    v_has_anio BOOLEAN;
    v_has_fecha BOOLEAN;
BEGIN
    v_has_nro := NEW.nro_protocolizacion IS NOT NULL;
    v_has_anio := NEW.anio_protocolizacion IS NOT NULL;
    v_has_fecha := NEW.fecha_protocolizacion IS NOT NULL;

    -- O todos true, o todos false
    IF (v_has_nro AND v_has_anio AND v_has_fecha) OR 
       (NOT v_has_nro AND NOT v_has_anio AND NOT v_has_fecha) THEN
       -- OK
       RETURN NEW;
    ELSE
       RAISE EXCEPTION 'Los campos de protocolización (número, año y fecha) deben completarse todos juntos o permanecer todos vacíos.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_check_protocolizacion_atomica ON mareas;
CREATE TRIGGER trg_check_protocolizacion_atomica
    BEFORE INSERT OR UPDATE ON mareas
    FOR EACH ROW
    EXECUTE FUNCTION check_protocolizacion_atomica();


-- 5. check_marea_etapas_abiertas
CREATE OR REPLACE FUNCTION check_marea_etapas_abiertas()
RETURNS TRIGGER AS $$
DECLARE
    v_open_stages_count INTEGER;
BEGIN
    -- Solo si se intenta cerrar el observador
    IF NEW.fecha_fin_observador IS NOT NULL THEN
        
        SELECT COUNT(*) INTO v_open_stages_count
        FROM mareas_etapas
        WHERE id_marea = NEW.id AND fecha_arribo IS NULL;

        IF v_open_stages_count > 0 THEN
             RAISE EXCEPTION 'No se puede establecer la fecha de fin del observador si existen etapas sin fecha de arribo.';
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_check_marea_etapas_abiertas ON mareas;
CREATE TRIGGER trg_check_marea_etapas_abiertas
    BEFORE UPDATE ON mareas
    FOR EACH ROW
    EXECUTE FUNCTION check_marea_etapas_abiertas();