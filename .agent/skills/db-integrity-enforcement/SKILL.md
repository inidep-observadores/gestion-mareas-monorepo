---
description: Garantiza la implementación de reglas de negocio críticas mediante triggers y constraints en la base de datos.
---
# Skill: Database Integrity Enforcement

## Descripción
Esta skill instruye al agente sobre la **filosofía de "Defensa en Profundidad"** para la integridad de datos. Las reglas de negocio críticas NO deben vivir solo en la capa de aplicación (NestJS/Services), sino que deben ser reforzadas por la base de datos (PostgreSQL) para prevenir corrupción por ediciones manuales, importaciones masivas o bugs de software.

## Cuándo usar esta Skill
- Al crear o modificar **Reglas de Negocio** en Services (`*.service.ts`).
- Al diseñar nuevas tablas o modificar esquemas en `schema.prisma`.
- Al encontrar inconsistencias de datos que requieren corrección manual frecuente.

## Checklist de Implementación
Cada vez que implementes una validación en TypeScript (ej. "Fecha fin no puede ser menor a inicio"), pregúntate:
1.  **¿Esta regla es crítica?** (Si se viola, ¿se rompe el sistema o reports?)
2.  **¿Se puede garantizar con un Check Constraint?** (Ej. `CHECK (fecha_fin >= fecha_inicio)`)
3.  **¿Requiere lógica compleja o cruce de tablas?** -> Usar **Trigger**.

## Guía de Triggers en este Proyecto

### 1. Convención de Nombres
- Función: `check_<entidad>_<regla>` (snake_case)
- Trigger: `trg_check_<entidad>_<regla>`

### 2. Estructura Estándar PL/pgSQL
```sql
CREATE OR REPLACE FUNCTION check_nombre_regla()
RETURNS TRIGGER AS $$
BEGIN
    -- Lógica de validación usando NEW y OLD
    IF NEW.campo_critico = 'VALOR_INVALIDO' THEN
        RAISE EXCEPTION 'Mensaje de error claro para el usuario/dev';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_check_nombre_regla ON tabla_destino;
CREATE TRIGGER trg_check_nombre_regla
    BEFORE INSERT OR UPDATE ON tabla_destino
    FOR EACH ROW
    EXECUTE FUNCTION check_nombre_regla();
```

### 3. Buenas Prácticas
- **Atomicidad**: Validar estados resultantes (`NEW.estado_id`) en lugar de transiciones específicas si es posible, para permitir actualizaciones masivas.
- **Performance**: Evitar SELECTs pesados dentro de triggers que se ejecuten en cada fila (FOR EACH ROW) si se prevén cargas masivas.
- **Mensajes**: Usar mensajes de error descriptivos en español.

## Referencias
- Archivo de reglas centralizado: `business_rules.md` (Checkear artifacts si existe).
- Migraciones existentes en `prisma/migrations`.
