# Changelog

## [Unreleased]

### Fixed
- **Backend (Tracking/PNA)**: Corregida la pérdida de `puertoArriboId` y `fuentesArribo` en las alertas de recomendación de fin de marea. Ahora el `portId` se inyecta correctamente en el array de `sources`.
- **Backend (Alert Automation)**: Mejorada la robustez de la extracción de metadatos de alertas con un fallback prioritario para `portId`.
- **Frontend (Mareas)**: Corregido el componente `NavigationStagesEditor` que no recibía `mareaId`, impidiendo guardar la intención de cierre manual.
- **Base de Datos (Prisma)**: Eliminada carpeta de migración corrupta (`_add_marea_etapa_metadata`) que bloqueaba el despliegue de cambios en el esquema.
- **Backend (Mareas Service)**: Ajustada la descripción del historial en cierres automáticos para mayor claridad semántica.

### Added
- Soporte para persistencia automática de fuentes de arribo en cierres sugeridos por intención de usuario.
