# Changelog

## [Unreleased]

### Added
- **Backend (Mareas)**: Nuevo estado `A_REASIGNAR` para clasificar mareas que no pudieron ser ejecutadas y deben ser reasignadas.
- **Frontend (Mareas)**: Implementado `EditMareaDesignadaDialog` para edición simplificada de mareas en estado `DESIGNADA`.
- **Frontend (Mareas)**: Visualización y opciones de filtrado del estado `A_REASIGNAR` en `PanelOperativoView`.
- **Frontend (Mareas)**: Autocompletado automático de Pesquería y Arte de pesca principal al seleccionar o cambiar el buque en la nueva dialog de edición.
- **Frontend (Mareas)**: Visualización de comentarios de movimientos en la actividad reciente del panel de detalle.
- **Frontend (Mareas)**: Implementada visibilidad condicional en el panel de detalle para ocultar secciones operativas (Avance y Logística) en estados `DESIGNADA` y `A_REASIGNAR`.
- Soporte para persistencia automática de fuentes de arribo en cierres sugeridos por intención de usuario.

### Fixed
- **Backend (Auth)**: Corregidas las rutas de importación de decoradores y guardias en el nuevo controlador de planificación para alinearlas con la estructura del proyecto.
- **Backend (Testing)**: Actualizados los archivos de pruebas unitarias (`.spec.ts`) del módulo de planificación para incluir los proveedores necesarios (`PrismaService`).

