# Reglas de Base de Datos - SIGMA

Estas reglas son de obligado cumplimiento para todos los agentes que trabajen en este proyecto.

## 🚨 Prohibición de Comandos Destructivos

**NUNCA** ejecutes comandos que impliquen la pérdida de datos o el reinicio de la base de datos de desarrollo/producción sin el consentimiento explícito y por escrito del usuario.

### Comandos Prohibidos (sin autorización):
- `prisma db push --force-reset` ❌
- `prisma migrate dev --create-only` seguido de un reset manual ❌
- `drop table`, `truncate table` o similares vía scripts de shell ❌
- Cualquier comando que provoque el mensaje "Prisma needs to reset the database" ❌

### Procedimiento Correcto:
1. Si un cambio de esquema requiere un reset, **detente inmediatamente**.
2. Explica al usuario por qué es necesario el reset y qué datos se perderán.
3. Espera la confirmación afirmativa del usuario ("Sí, puedes resetear la base de datos").
4. Si se autoriza, asegúrate de tener un plan para ejecutar los `seeds` inmediatamente después.

## 📂 Gestión de Migraciones
- Prioriza siempre `prisma migrate dev` para generar archivos de migración rastreables.
- Si usas `db push` para prototipado rápido, hazlo solo para cambios aditivos.
- Al renombrar tablas, usa `migrate dev --create-only` para editar el SQL y usar `ALTER TABLE ... RENAME TO ...` en lugar de borrar y crear.
