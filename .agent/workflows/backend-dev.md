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
   pnpm --filter backend dev
   ```
4. Los esquemas de base de datos se definen en `app/backend/prisma/schema.prisma`.

## Manejo de Fechas y Timezone

**IMPORTANTE**: Para obtener la fecha actual en cualquier lógica de negocio, NUNCA uses `new Date()` ni `DateTime.now()` directamente.
Debes usar siempre la utilidad centralizada que respeta la configuración de `APP_TIMEZONE`:

```typescript
import { DateUtils } from '../../common/utils/date.utils';

// Para obtener solo la fecha (calendario, 00:00:00 del día actual en la zona horaria)
const today = DateUtils.getNow(); 

// Para obtener fecha y hora exacta actual
const now = DateUtils.getNow(true);
```
