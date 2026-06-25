---
name: prisma-migrations
description: Reglas estrictas y obligatorias para la gestión de migraciones de base de datos con Prisma. Garantiza la persistencia de datos, prevención de borrados y generación explícita de archivos SQL de migración.
---

# Gestión de Migraciones de Base de Datos (Prisma)

Esta habilidad establece las **condiciones obligatorias e irrenunciables** para cualquier cambio en el esquema de la base de datos (Prisma) dentro del ecosistema SIGMA. 

Siempre que se modifique `schema.prisma` y deba aplicarse a la base de datos, se **DEBEN** seguir las siguientes reglas.

## Reglas de Oro (Obligatorias)

1. **Archivos Explícitos Obligatorios**:
   - Toda migración que se realice en la base de datos **DEBE** hacerse a través de un archivo de migración explícito (`.sql` dentro de la carpeta `prisma/migrations`).
   - NUNCA se debe aplicar directamente una migración a la base de datos de desarrollo (ej. usar `prisma db push` para evitar migraciones formales), ya que luego la base de datos de producción no tiene manera de recibir la actualización y aplicarla trazablemente.

2. **Seguridad y No Destructividad**:
   - Toda migración **debe estar codificada de manera que sea segura y no destructiva**.
   - Debe asegurarse la conservación e integridad de los datos existentes. 
   - Si se detecta un cambio potencialmente destructivo (como renombrar una tabla, eliminar una columna o cambiar un tipo de dato restrictivo), se debe revisar el código SQL e incluir scripts manuales de migración de datos (backfill) dentro del archivo generado antes de aplicar la migración final.

3. **Prohibición de Resets**:
   - Es **inadmisible en cualquier caso aplicar un reset** a la base de datos de los entornos de desarrollo consolidados, staging o producción.
   - NUNCA se debe ejecutar comandos como `npx prisma migrate reset` o forzar borrados masivos.

## Flujo de Trabajo Técnico (Safe Workflow)

Para aplicar cambios a la base de datos cumpliendo estas reglas, se debe utilizar el siguiente flujo:

1. **Crear el archivo SQL explícito (SIN APLICARLO AÚN):**
   ```bash
   pnpm dlx prisma migrate dev --create-only --name <nombre_descriptivo_migracion>
   ```

2. **Auditar y/o Editar el SQL generado:**
   - Navegar a `app/backend/prisma/migrations/` y revisar el archivo `migration.sql` recién creado.
   - Si es necesario, añadir sentencias de inserción, actualización masiva u otras garantías para los datos preexistentes.

3. **Aplicar la migración de forma segura:**
   ```bash
   pnpm dlx prisma migrate deploy
   ```

4. **Regenerar el cliente de Prisma:**
   ```bash
   pnpm dlx prisma generate
   ```
