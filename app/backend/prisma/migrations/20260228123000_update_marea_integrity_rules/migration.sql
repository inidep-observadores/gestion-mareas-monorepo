-- Actualización de la función de validación de integridad de marea
-- Permite cambios solo en estados preparatorios (DESIGNADA y A_REASIGNAR)
-- Protege campos de identidad, Buque, Observador Principal, Pesquería y Arte de Pesca Principal

CREATE OR REPLACE FUNCTION public.fn_validate_marea_designation_fields_change()
RETURNS TRIGGER AS $$
DECLARE
    estado_designada_id UUID;
    estado_a_reasignar_id UUID;
BEGIN
    -- Obtener IDs de los estados exceptuados
    SELECT id INTO estado_designada_id FROM public.estados_marea WHERE codigo = 'DESIGNADA';
    SELECT id INTO estado_a_reasignar_id FROM public.estados_marea WHERE codigo = 'A_REASIGNAR';

    -- Si el estado actual es uno de los exceptuados, permitir todos los cambios
    IF OLD.id_estado_actual = estado_designada_id OR OLD.id_estado_actual = estado_a_reasignar_id THEN
        RETURN NEW;
    END IF;

    -- Si NO estamos en un estado exceptuado, validar que no cambien campos críticos
    -- Utilizamos IS DISTINCT FROM para manejar correctamente valores NULL en campos opcionales
    IF (NEW.anio_marea != OLD.anio_marea) OR
       (NEW.nro_marea != OLD.nro_marea) OR
       (NEW.tipo_marea != OLD.tipo_marea) OR
       (NEW.id_buque != OLD.id_buque) OR
       (NEW.id_observador_principal IS DISTINCT FROM OLD.id_observador_principal) OR
       (NEW.id_pesqueria IS DISTINCT FROM OLD.id_pesqueria) OR
       (NEW.id_arte_principal IS DISTINCT FROM OLD.id_arte_principal) THEN
        
        RAISE EXCEPTION 'No se pueden modificar los datos de identidad, buque, observador, pesquería o arte de pesca una vez que la marea ha salido de los estados de planificación (DESIGNADA/A_REASIGNAR).'
            USING ERRCODE = 'P0001';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
