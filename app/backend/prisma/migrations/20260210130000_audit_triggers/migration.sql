-- Función genérica de auditoría para triggers
CREATE OR REPLACE FUNCTION audit.auditar_entidad() RETURNS TRIGGER AS $$
DECLARE
    v_usuario_id UUID;
    v_valores_anteriores JSONB;
    v_valores_nuevos JSONB;
    v_operacion TEXT;
BEGIN
    -- Intentar obtener el ID del usuario de la configuración de la sesión (seteado por la app)
    BEGIN
        v_usuario_id := NULLIF(current_setting('app.current_user_id', true), '')::UUID;
    EXCEPTION WHEN OTHERS THEN
        v_usuario_id := NULL;
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
        TG_TABLE_NAME, -- Usar nombre de la tabla como tipo
        COALESCE(NEW.id, OLD.id)::TEXT,
        v_operacion,
        v_valores_anteriores,
        v_valores_nuevos,
        jsonb_build_object('schema', TG_TABLE_SCHEMA, 'trigger', TG_NAME)
    );

    RETURN NULL; 
END;
$$ LANGUAGE plpgsql;

-- Trigger para tabla USERS
DROP TRIGGER IF EXISTS trg_audit_users ON "public"."users";
CREATE TRIGGER trg_audit_users
AFTER INSERT OR UPDATE OR DELETE ON "public"."users"
FOR EACH ROW EXECUTE FUNCTION audit.auditar_entidad();

-- Trigger para tabla MAREAS
DROP TRIGGER IF EXISTS trg_audit_mareas ON "public"."mareas";
CREATE TRIGGER trg_audit_mareas
AFTER INSERT OR UPDATE OR DELETE ON "public"."mareas"
FOR EACH ROW EXECUTE FUNCTION audit.auditar_entidad();

-- Trigger para tabla OBSERVADORES
DROP TRIGGER IF EXISTS trg_audit_observadores ON "public"."observadores";
CREATE TRIGGER trg_audit_observadores
AFTER INSERT OR UPDATE OR DELETE ON "public"."observadores"
FOR EACH ROW EXECUTE FUNCTION audit.auditar_entidad();

-- Trigger para tabla BUQUES (Opcional, pero útil)
DROP TRIGGER IF EXISTS trg_audit_buques ON "public"."buques";
CREATE TRIGGER trg_audit_buques
AFTER INSERT OR UPDATE OR DELETE ON "public"."buques"
FOR EACH ROW EXECUTE FUNCTION audit.auditar_entidad();
