# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [v0.12.0] - 2026-08-03

### Added
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
- **planificacion:** usar BaseModal y v-form-nav para dialogos y dblclick en recursos
- **planificacion:** desacoplar logica de presentismo y crear endpoint nativo para simulacion
