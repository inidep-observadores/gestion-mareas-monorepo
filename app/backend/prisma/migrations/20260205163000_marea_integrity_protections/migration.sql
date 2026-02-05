-- Migration: Protecciones de Integridad de Mareas (Triggers y Constraints)
-- Fecha: 2026-02-05

-- 1. Check Constraint de Año Flexible
-- Permite que una marea del año X tenga fecha de zarpada en el año X o en enero del año X+1
ALTER TABLE "public"."mareas" 
DROP CONSTRAINT IF EXISTS check_marea_year_coherence;

ALTER TABLE "public"."mareas" 
ADD CONSTRAINT check_marea_year_coherence
CHECK (
    fecha_zarpada_estimada IS NULL OR
    EXTRACT(YEAR FROM fecha_zarpada_estimada) = anio_marea OR
    (EXTRACT(YEAR FROM fecha_zarpada_estimada) = anio_marea + 1 AND EXTRACT(MONTH FROM fecha_zarpada_estimada) = 1)
);

-- 2. Función de validación de disponibilidad de Buque y Observador
CREATE OR REPLACE FUNCTION check_marea_availability()
RETURNS TRIGGER AS $$
DECLARE
    v_vessel_occupied BOOLEAN;
    v_observer_occupied BOOLEAN;
BEGIN
    -- Verificar disponibilidad del Buque (si cambió o es inserción)
    IF (TG_OP = 'INSERT') OR (NEW.id_buque <> OLD.id_buque) THEN
        SELECT EXISTS (
            SELECT 1 FROM "public"."mareas" m
            JOIN "public"."estados_marea" e ON m.id_estado_actual = e.id
            WHERE m.id_buque = NEW.id_buque
              AND m.activo = true
              AND m.id <> COALESCE(NEW.id, '00000000-0000-0000-0000-000000000000'::uuid)
              AND e.codigo IN ('DESIGNADA', 'ACTIVA', 'EJEC')
        ) INTO v_vessel_occupied;

        IF v_vessel_occupied THEN
            RAISE EXCEPTION 'El buque ya tiene una marea activa o designada y no puede ser asignado.';
        END IF;
    END IF;

    -- Verificar disponibilidad del Observador Principal (si cambió o es inserción)
    IF (NEW.id_observador_principal IS NOT NULL) AND 
       ((TG_OP = 'INSERT') OR (COALESCE(NEW.id_observador_principal, '00000000-0000-0000-0000-000000000000'::uuid) <> COALESCE(OLD.id_observador_principal, '00000000-0000-0000-0000-000000000000'::uuid))) THEN
        
        SELECT EXISTS (
            SELECT 1 FROM "public"."mareas" m
            JOIN "public"."estados_marea" e ON m.id_estado_actual = e.id
            WHERE m.id_observador_principal = NEW.id_observador_principal
              AND m.activo = true
              AND m.id <> COALESCE(NEW.id, '00000000-0000-0000-0000-000000000000'::uuid)
              AND e.codigo IN ('DESIGNADA', 'ACTIVA', 'EJEC')
        ) INTO v_vessel_occupied; -- Reuso variable para ahorrar memoria

        IF v_vessel_occupied THEN
            RAISE EXCEPTION 'El observador seleccionado ya se encuentra asignado a otra marea activa.';
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
