---
description: Experto en migraciones con Prisma y PostgreSQL. Diseña migraciones seguras que evitan el reset del esquema y la pérdida de datos.
---
# Skill: Prisma Migrations Expert

## Descripción
Esta skill proporciona directrices estrictas para gestionar migraciones de base de datos en entornos de producción o con datos críticos. El objetivo principal es **evitar la pérdida de datos** y garantizar que las migraciones sean reversibles y seguras, prohibiendo el uso de comandos destructivos como `prisma migrate reset`.

## Principios Fundamentales
1.  **Datos Sagrados**: Nunca realices una operación que elimine datos sin una estrategia de respaldo o migración previa.
2.  **No Reset**: En entornos con datos, `prisma migrate reset` está terminantemente prohibido.
3.  **Migraciones Hacia Adelante**: Los cambios deben diseñarse para ser aplicados de forma incremental.
4.  **Validación Previa**: Siempre genera el SQL de la migración (`--create-only`) antes de aplicarla para revisar qué hará Prisma "bajo el capó".

## Estrategias de Migración Segura

### 1. Añadir Columnas `NOT NULL`
Prisma genera un error si intentas añadir una columna `NOT NULL` a una tabla que ya tiene registros.
**Procedimiento Correcto:**
1.  Añadir la columna como opcional (`?`) en `schema.prisma`.
2.  Generar la migración: `npx prisma migrate dev --create-only`.
3.  Crear una migración de datos (SQL) para rellenar los valores nulos en los registros existentes.
4.  Modificar el esquema para que la columna sea requerida (`NOT NULL`).
5.  Generar y aplicar la migración final.

### 2. Renombrar Columnas
Prisma suele interpretar un renombramiento como `DROP COLUMN` + `ADD COLUMN`, lo cual causa pérdida de datos.
**Procedimiento Correcto:**
1.  Usa el mapeo de nombres en Prisma: `@map("nombre_antiguo")`.
2.  Si es un renombramiento real en la DB:
    -   Crea la migración con `--create-only`.
    -   Modifica el SQL generado para usar `ALTER TABLE ... RENAME COLUMN ...`.

### 3. Cambios de Tipo de Datos
**Procedimiento Correcto:**
1.  Añadir una nueva columna temporal con el nuevo tipo.
2.  Migrar los datos de la vieja a la nueva usando SQL (ej. `UPDATE table SET new_col = CAST(old_col AS new_type)`).
3.  Actualizar la aplicación para usar la nueva columna.
4.  Eliminar la columna antigua en una migración posterior.

## Manejo de Migraciones Fallidas
Si una migración falla en producción:
1.  **NO uses `migrate reset`**.
2.  Identifica el estado actual en la tabla `_prisma_migrations`.
3.  Usa `npx prisma migrate resolve --rolled-back "nombre_migracion"` o `--applied "nombre_migracion"` con extrema precaución para sincronizar el estado.
4.  Corrige el SQL de la migración manualmente si es necesario.

## Checklist de Seguridad
- [ ] ¿He revisado el SQL generado con `--create-only`?
- [ ] ¿La migración contiene algún `DROP` (TABLE o COLUMN)?
- [ ] ¿Añade alguna restricción `NOT NULL` a una tabla con datos?
- [ ] ¿Tengo un backup antes de proceder? (Recomendado)
- [ ] ¿He probado la migración en un entorno de staging/desarrollo local con datos reales duplicados?

## Comandos Recomendados
-   `npx prisma migrate dev --create-only`: Para previsualizar y editar el SQL.
-   `npx prisma migrate deploy`: Para aplicar migraciones en entornos de staging/prod (nunca usa reset).
-   `npx prisma migrate status`: Para verificar el estado de la base de datos.
