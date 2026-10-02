# Changelog

All notable changes to this project will be documented in this file.

## [v0.15.0] - 2026-10-02

### Added
- **planificacion:** exportación a Excel de cobertura/planificación con reportes estructurados
- **planificacion:** mejoras de persistencia y UI en el simulador
- **planificacion:** refactorización UX del simulador, filtros avanzados y detección cruzada de conflictos
- **planificacion:** refinar UX del simulador de cobertura y persistencia
- **planificacion:** reubicar buscador y permitir filtrar buques
- **planificacion:** mejorar mensajes de conflicto de mareas
- **planificacion:** agrupar timeline de buques por pesquería
- **planificacion:** refactor de timeline e integracion de modo buques
- **planificacion:** agregar sistema de solapas (tabs) para vistas por observador y por buque en simulador
- **backend:** agregar exportación de track en formato geojson al bundle

### Fixed
- **planificacion:** reordena campos en modales de marea simulada y auto-calcula dias estimados
- **planificacion:** restaurar y optimizar drag and drop en linea de tiempo
- **backend:** agregar puntos individuales con fecha, velocidad y rumbo al exportar geojson

### Refactored
- **planificacion:** unificar logica y UI de linea de tiempo del simulador con vista de disponibilidad

## [v0.14.0] - 2026-09-20

### Added
- **maps:** integrar múltiples proveedores y persistencia de configuración
- **monitor:** importar capas GeoJSON de usuario en el mapa interactivo
- **observadores:** agregar botonera de filtros de estado y contrato, y desmarcar tecnico en disponibilidad
- **disponibilidad:** refinar proyecciones de marea en curso, horizonte temporal y excluir cedula
- **disponibilidad:** bloquear disponibilidad indefinidamente por documentacion vencida
- **novedades:** incorporar triage por IA y actualizacion de cedula de embarco NIDO
- **mareas:** agregar indicadores de estado documental de observadores en asignacion de mareas
- **observadores:** registrar documentacion de embarque y alertas de vencimiento
- **frontend:** añadir filtro para ocultar no disponibles entre fechas con slider doble
- **disponibilidad:** incorporar dos niveles de disponibilidad, estilos diferenciados y mejoras en el dashboard
- **disponibilidad:** implementar vista y servicio de disponibilidad de observadores con timeline dinámico
- **novedades:** implementar reprocesamiento individual de correos y busqueda de observador por remitente
- **presentismo:** mejorar generacion de pdf y nombre de archivo para novedades por email
- **mareas:** agregar validaciones para observadores secundarios planificados

### Fixed
- **mareas:** validar y auditar guardado de observadores secundarios
- **db:** convertir vencimientos de documentacion de observadores a timestamptz
- **backend:** priorizar navegacion sobre aviso previo de disponibilidad en timeline
- **admin:** corregir bloqueo de emails en estado procesando y habilitar reprocesamiento
- **mail:** actualizar modelo fallback a gemma-4 y sanitizar respuesta json de IA
- **backend/stats:** corregir cálculo de días en exportación excel de auditoría
- **novedades:** restringir ajuste de periodos a disponibilidad y autocerrar tipos puntuales

### Refactored
- **frontend:** estandarizar formato de fecha y hora a 24h en la interfaz
