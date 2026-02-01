
-- Función genérica de auditoría para triggers ACTUALIZADA con soporte de email
CREATE OR REPLACE FUNCTION audit.auditar_entidad() RETURNS TRIGGER AS $$
DECLARE
    v_usuario_id UUID;
    v_usuario_email TEXT;
    v_valores_anteriores JSONB;
    v_valores_nuevos JSONB;
    v_operacion TEXT;
BEGIN
    -- Obtener ID de usuario de la sesión
    BEGIN
        v_usuario_id := NULLIF(current_setting('app.current_user_id', true), '')::UUID;
    EXCEPTION WHEN OTHERS THEN
        v_usuario_id := NULL;
    END;

    -- Obtener Email de usuario de la sesión
    BEGIN
        v_usuario_email := NULLIF(current_setting('app.current_user_email', true), '');
    EXCEPTION WHEN OTHERS THEN
        v_usuario_email := NULL;
    END;

    v_operacion := TG_OP;

    IF (TG_OP = 'INSERT') THEN
        v_valores_anteriores := NULL;
        v_valores_nuevos := to_jsonb(NEW);
    ELSIF (TG_OP = 'UPDATE') THEN
        v_valores_anteriores := to_jsonb(OLD);
        v_valores_nuevos := to_jsonb(NEW);
    ELSIF (TG_OP = 'DELETE') THEN
        v_valores_anteriores := to_jsonb(OLD);
        v_valores_nuevos := NULL;
    END IF;

    INSERT INTO "audit"."auditoria_entidad" (
        "id",
        "timestamp",
        "usuario_id",
        "usuario_email",
        "entidad_tipo",
        "entidad_id",
        "operacion",
        "valores_anteriores",
        "valores_nuevos",
        "contexto"
    ) VALUES (
        gen_random_uuid(),
        CURRENT_TIMESTAMP,
        v_usuario_id,
        v_usuario_email,
        TG_TABLE_NAME,
        COALESCE(NEW.id, OLD.id)::TEXT,
        v_operacion,
        v_valores_anteriores,
        v_valores_nuevos,
        jsonb_build_object('schema', TG_TABLE_SCHEMA, 'trigger', TG_NAME)
    );

    RETURN NULL; 
END;
$$ LANGUAGE plpgsql;
