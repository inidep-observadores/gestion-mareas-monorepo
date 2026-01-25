---
description: "Cómo gestionar migraciones de base de datos y ejecutar el backend."
---

# Workflow: Desarrollo Backend

Este workflow guía al agente en las tareas comunes del backend.

## Pasos

1. Asegúrate de estar en el directorio raíz o en `app/backend`.
2. Para aplicar migraciones de Prisma:
   ```bash
   pnpm --filter backend exec prisma migrate dev
   ```
3. Para ejecutar el backend en modo desarrollo:
// turbo
   ```bash
   pnpm --filter backend dev
   ```
4. Los esquemas de base de datos se definen en `app/backend/prisma/schema.prisma`.
