# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [v0.12.0] - 2026-08-08

### Added
- **observadores:** agregar detailMode al calendario para mostrar detalle en modal o vista lateral
- **observadores:** integrar calendario en panel lateral con autogestión de novedades
- **observadores:** mostrar historial completo y agregar flota en timeline
- **mareas:** mejoras UX/UI y carga de datos en calendario de observadores
- **calendario:** integración de mareas en el calendario del observador
- **frontend:** añadir navegación mensual premium en matriz de presentismo
- **frontend:** añadir estilos específicos para DISPONIBLE y NO_DISPONIBLE
- **admin:** agregar vista de calendario de novedades por observador
- **admin:** añadir pesquería en historial del observador
- **mareas:** implementar subida diferida de archivos a Drive
- **planificacion:** bloquear modificacion de adjuntos en novedades autogeneradas
- **planificacion:** restringir adjuntos de Novedades a imagenes y PDFs
- **planificacion:** permitir adjuntos en novedades manuales via Google Drive
- **planificacion:** simplificar matriz de experiencia aglutinando por pesqueria y remover desglose por flota
- **planificacion:** implementar modal de detalle de mareas en matriz de experiencia
- **planificacion:** vincular simulador al store de configuracion y cargar horizonte de 5 años
- **planificacion:** mensaje de error de solapamiento mas especifico
- **planificacion:** autofocus en modal de recursos
- **planificacion:** bloquear fechas pasadas para proyecciones de mareas
- **planificacion:** tooltip con fechas en bloques y snap a dias enteros
- **planificacion:** autocerrar recursos y agregar simulador al sidebar
- **planificacion:** devolver marea proyectada a requerimientos pendientes y editar parametros en timeline
- **planificacion:** usar SearchableSelect para catalogos en el simulador y permitir editar/eliminar recursos
- **planificacion:** mejorar UI/UX de bloques del simulador y corregir estados
- **presentismo:** implementar y pulir vis-timeline para matriz de presentismo

### Fixed
- **mareas:** ajustar margen superior del panel lateral para no ocultarse bajo navbar
- **backend:** mejorar extracción de fechas en pasajes con IA
- **novedades:** gestión de novedades eliminadas lógicamente
- **admin:** restaurar logica de dias a disponibilidad en puerto local
- **mail:** optimizar procesamiento de pasajes por IA y habilitar rango de fechas
- **planificacion:** agregar debounce al buscador del simulador de cobertura para evitar lag al escribir
- **backend:** generar iteradores de fechas en zona local en lugar de utc para evitar desfasaje de 1 dia en timeline
- **planificacion:** operador non-null assertion para editar buqueId en modal
- **planificacion:** corregir binding de buqueId en modal editar marea simulada
- **planificacion:** restaurar opcionalidad de buqueId en MareaSimuladaItem
- **planificacion:** corregir errores de tipos TS en SimuladorCoberturaView
- **planificacion:** aumentar ancho modal editar marea simulada a xl
- **planificacion:** agrandar modal editar marea simulada y mejorar texto boton
- **planificacion:** incluir novedades sin afecta_presentismo en timeline de simulador
- **planificacion:** tooltip con fecha de fin inclusiva correcta
- **planificacion:** corregir mensaje al mover marea simulada en timeline
- **planificacion:** corregir bugs de scope de vue css con selectores globales para dark mode
- **planificacion:** corregir selectores css para dark mode en simulador
- **planificacion:** restaurar estilos visuales de bloques proyectados
- **planificacion:** excluir mareas canceladas del simulador de cobertura
- **planificacion:** corregir comportamiento de drag and drop en simulador
- **frontend:** aumentar timeout de envío a protocolización a 5 minutos
- **presentismo:** ocultar linea de tiempo actual y resolver advertencias de TS en Vis-Timeline

### Refactored
- **mail:** procesar contenido de adjuntos en triage para mejorar precision
- **frontend:** migrar calendario de novedades a v-calendar y aplicar rediseño responsive
- **planificacion:** usar BaseModal y v-form-nav para dialogos y dblclick en recursos
- **planificacion:** desacoplar logica de presentismo y crear endpoint nativo para simulacion
