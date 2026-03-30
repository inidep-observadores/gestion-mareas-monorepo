-- Trigger para restringir la edición de año, número y tipo de marea
-- Solo se permiten cambios si el estado es 'DESIGNADA'

CREATE OR REPLACE FUNCTION public.fn_validate_marea_designation_fields_change()
RETURNS TRIGGER AS $$
DECLARE
    estado_designada_id UUID;
    estado_actual_codigo TEXT;
BEGIN
    -- Obtener el ID del estado 'DESIGNADA'
    SELECT id INTO estado_designada_id FROM public.estados_marea WHERE codigo = 'DESIGNADA';

    -- Si no existe el estado DESIGNADA (raro), no podemos validar
    IF estado_designada_id IS NULL THEN
        RETURN NEW;
    END IF;

    -- Solo validar si el estado actual NO es DESIGNADA
    IF OLD.id_estado_actual != estado_designada_id THEN
        -- Verificar si cambiaron campos protegidos
        IF (NEW.anio_marea != OLD.anio_marea) OR
           (NEW.nro_marea != OLD.nro_marea) OR
           (NEW.tipo_marea != OLD.tipo_marea) THEN
            
            RAISE EXCEPTION 'Solo se puede modificar el número, año y tipo de marea si la misma está en estado "DESIGNADA".'
                USING ERRCODE = 'P0001'; -- Custom error code for application handling
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Eliminar si existe para recrear
DROP TRIGGER IF EXISTS trg_validate_marea_designation_fields ON public.mareas;

-- Crear el trigger
CREATE TRIGGER trg_validate_marea_designation_fields
BEFORE UPDATE ON public.mareas
FOR EACH ROW
EXECUTE FUNCTION public.fn_validate_marea_designation_fields_change();
