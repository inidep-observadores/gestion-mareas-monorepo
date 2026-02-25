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
- **Backend (Prisma)**: Integradas salvaguardas ambientales (`NODE_ENV` y `DATABASE_URL`) en `seed-static.ts` para prevenir la ejecución accidental de operaciones destructivas (`cleanAll`) en entornos de producción.
- **Frontend (Mareas)**: Se mapearon correctamente las `initialData` nativas (en camelCase) en la consulta compacta de `getDashboardOperativo` para que `EditMareaDesignadaDialog` pueda hidratar la información ya existente.
- **Backend (Tracking/PNA)**: Corregida la pérdida de `puertoArriboId` y `fuentesArribo` en las alertas de recomendación de fin de marea. Ahora el `portId` se inyecta correctamente en el array de `sources`.
- **Backend (Alert Automation)**: Mejorada la robustez de la extracción de metadatos de alertas con un fallback prioritario para `portId`.
- **Frontend (Mareas)**: Corregido el componente `NavigationStagesEditor` que no recibía `mareaId`, impidiendo guardar la intención de cierre manual.
- **Base de Datos (Prisma)**: Eliminada carpeta de migración corrupta (`_add_marea_etapa_metadata`) que bloqueaba el despliegue de cambios en el esquema.
- **Backend (Mareas Service)**: Ajustada la descripción del historial en cierres automáticos para mayor claridad semántica.

