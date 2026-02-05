-- Migration: Protecciones de Integridad de Mareas (Triggers y Constraints)
-- Fecha: 2026-02-05
-- Refinamiento: Permite designaciones concurrentes, bloquea solapamiento de ejecución (navegación).

-- 1. Check Constraint de Año Flexible
ALTER TABLE "public"."mareas" 
DROP CONSTRAINT IF EXISTS check_marea_year_coherence;

ALTER TABLE "public"."mareas" 
ADD CONSTRAINT check_marea_year_coherence
CHECK (
    fecha_zarpada_estimada IS NULL OR
    EXTRACT(YEAR FROM fecha_zarpada_estimada) = anio_marea OR
    (EXTRACT(YEAR FROM fecha_zarpada_estimada) = anio_marea + 1 AND EXTRACT(MONTH FROM fecha_zarpada_estimada) = 1)
);

-- 2. Función de validación de disponibilidad optimizada
CREATE OR REPLACE FUNCTION check_marea_availability()
RETURNS TRIGGER AS $$
DECLARE
    v_new_status_code TEXT;
    v_conflict_exists BOOLEAN;
BEGIN
    -- Obtener el código del estado al que se intenta mover la marea
    SELECT codigo INTO v_new_status_code 
    FROM "public"."estados_marea" 
    WHERE id = NEW.id_estado_actual;

    -- REGLA DE NEGOCIO:
    -- Un buque/observador puede estar DESIGNADO para mareas futuras mientras navega o está en otra designación.
    -- El BLOQUEO FÍSICO solo debe ocurrir cuando se intenta poner una marea "EN_EJECUCION"
    -- si ya existe otra marea "EN_EJECUCION" para el mismo recurso.
    
    IF v_new_status_code = 'EN_EJECUCION' THEN
        
        -- Verificar disponibilidad del Buque
        SELECT EXISTS (
            SELECT 1 FROM "public"."mareas" m
            JOIN "public"."estados_marea" e ON m.id_estado_actual = e.id
            WHERE m.id_buque = NEW.id_buque
              AND m.activo = true
              AND m.id <> COALESCE(NEW.id, '00000000-0000-0000-0000-000000000000'::uuid)
              AND e.codigo = 'EN_EJECUCION'
        ) INTO v_conflict_exists;

        IF v_conflict_exists THEN
            RAISE EXCEPTION 'El buque ya tiene una marea en ejecución. Debe finalizar la navegación actual antes de iniciar otra.';
        END IF;

        -- Verificar disponibilidad del Observador Principal
        IF NEW.id_observador_principal IS NOT NULL THEN
            SELECT EXISTS (
                SELECT 1 FROM "public"."mareas" m
                JOIN "public"."estados_marea" e ON m.id_estado_actual = e.id
                WHERE m.id_observador_principal = NEW.id_observador_principal
                  AND m.activo = true
                  AND m.id <> COALESCE(NEW.id, '00000000-0000-0000-0000-000000000000'::uuid)
                  AND e.codigo = 'EN_EJECUCION'
            ) INTO v_conflict_exists;

            IF v_conflict_exists THEN
                RAISE EXCEPTION 'El observador ya se encuentra navegando en otra marea en ejecución.';
            END IF;
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 3. Trigger de Disponibilidad
DROP TRIGGER IF EXISTS trg_check_marea_availability ON "public"."mareas";
CREATE TRIGGER trg_check_marea_availability
    BEFORE INSERT OR UPDATE ON "public"."mareas"
    FOR EACH ROW
    EXECUTE FUNCTION check_marea_availability();
