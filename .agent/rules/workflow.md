# Reglas de Workflow y Compromisos (Git Hygiene) - SIGMA

Estas reglas garantizan que el código que llega al repositorio remoto (`origin`) sea limpio, estable y no contenga basura técnica de la fase de desarrollo.

## 🧹 Limpieza del Working Tree

**NUNCA** realices un commit o push que incluya:
- Scripts de diagnóstico temporales (ej. `test-db.ts`, `check-data.ts`, `debug.ts`).
- Archivos de salida de tests o logs persistidos (ej. `test-output.log`, `db_status.txt`).
- Archivos `.sql` generados manualmente para migración (a menos que se hayan integrado formalmente en `prisma/migrations`).
- Comentarios "TODO" o "DEBUG" que no tengan una justificación clara para permanecer en el código.

### Procedimiento Obligatorio antes de `git commit`:
1.  **Revisión de Archivos**: Verifica el estado de Git (`git status`) para identificar archivos que no pertenezcan a la funcionalidad core.
2.  **Eliminación de Basura**: Borra físicamente los scripts temporales creados para pruebas rápidas.
3.  **Verificación de Build**: Asegúrate de que los cambios no rompan el build localmente (`pnpm build`) antes de subir nada al remoto.
4.  **Confirmación con el Usuario**: Si tienes dudas sobre si un script debe ser preservado (ej. una herramienta de utilidad), pregunta al usuario antes de borrarlo o ignorarlo en el commit.

## 🚀 Despliegue en Staging
- Siempre verifica que el build pase localmente antes de sugerir un deploy a staging.
- Reporta cualquier fallo en el build de staging inmediatamente y prioriza su corrección mediante la eliminación de archivos mal tipados o conflictivos.
