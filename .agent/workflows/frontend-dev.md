---
description: "Cómo ejecutar el servidor de desarrollo y realizar cambios en el frontend."
---

# Workflow: Desarrollo Frontend

Este workflow guía al agente en las tareas comunes del frontend.

## Pasos

1. Asegúrate de estar en el directorio raíz o en `app/frontend`.
2. Instala dependencias si es necesario:
   ```bash
   pnpm install
   ```
3. Ejecuta el servidor de desarrollo:
// turbo
   ```bash
   pnpm --filter frontend dev
   ```
4. Los componentes de UI se encuentran en `app/frontend/src/components/ui`.
5. Las rutas están definidas en `app/frontend/src/router/index.ts`.
