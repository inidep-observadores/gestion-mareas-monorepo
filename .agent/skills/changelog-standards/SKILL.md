---
name: changelog-standards
description: "Estándares y mejores prácticas para la redacción de changelogs profesionales y bien estructurados."
allowed-tools: Read, Write, Edit
---

# Skill: Changelog Standards

Esta habilidad proporciona las mejores prácticas y estándares para mantener un changelog profesional, claro y útil.

## 📋 Principios Fundamentales

### 1. Keep a Changelog
Seguimos los principios de [Keep a Changelog](https://keepachangelog.com/):
- Los changelogs son para **humanos**, no máquinas
- Debe haber una entrada por cada versión
- Los cambios del mismo tipo deben agruparse
- Las versiones y secciones deben ser enlazables
- La última versión va primero
- Se debe mostrar la fecha de lanzamiento de cada versión

### 2. Versionado Semántico
Usamos [Semantic Versioning](https://semver.org/):
- **MAJOR** (X.0.0): Cambios incompatibles con versiones anteriores
- **MINOR** (0.X.0): Nueva funcionalidad compatible con versiones anteriores
- **PATCH** (0.0.X): Correcciones de bugs compatibles

## 🏗️ Estructura del Changelog

### Formato de Archivo
```markdown
# Changelog v0.1.0

## [v0.1.0] - UNRELEASED

### Backend
#### [NEW] Título de la Funcionalidad
- Descripción detallada del cambio
- Puntos clave de implementación

#### [MOD] Título de la Modificación
- Qué se modificó y por qué
- Impacto en el sistema

#### [FIX] Título de la Corrección
- Problema que se solucionó
- Cómo se resolvió

### Frontend
#### [NEW] Título de la Funcionalidad
...

### General
- Cambios que afectan a todo el sistema
```

### Categorías de Cambios

| Prefijo | Uso | Ejemplo |
|---------|-----|---------|
| `[NEW]` | Nueva funcionalidad | `[NEW] Sistema de Autenticación` |
| `[MOD]` | Modificación de funcionalidad existente | `[MOD] Validación de Formularios` |
| `[FIX]` | Corrección de bugs | `[FIX] Error en Cálculo de Totales` |
| `[PERF]` | Mejoras de rendimiento | `[PERF] Optimización de Consultas` |
| `[REFACTOR]` | Refactorización sin cambio funcional | `[REFACTOR] Estructura de Módulos` |
| `[TEST]` | Añadir o mejorar tests | `[TEST] Cobertura de Servicios` |
| `[DOCS]` | Cambios en documentación | `[DOCS] Guía de Instalación` |
| `[BREAKING]` | Cambios incompatibles | `[BREAKING] Nueva API de Usuarios` |

## ✍️ Guía de Redacción

### Títulos Descriptivos
✅ **BIEN:**
```markdown
#### [NEW] Sistema de Sincronización de Buques con API Externa
- Integración con API del Ministerio de Pesca
- Sincronización automática de datos oficiales
```

❌ **MAL:**
```markdown
#### [NEW] Nueva funcionalidad
- Se agregó algo nuevo
```

### Detalles Técnicos Relevantes
Incluir información que ayude a entender el cambio:

```markdown
#### [NEW] Sistema de Cola de Tareas (JobQueue)
- **Infraestructura**: Nueva tabla `job_queue` con soporte para reintentos automáticos
- **Configuración**: Variables de entorno `JOB_SCHEDULER_INTERVAL_CRON`, `VESSEL_SYNC_RATE_LIMIT_MS`
- **Ventajas**:
  - No bloquea operaciones críticas
  - Reintentos con backoff exponencial
  - Monitoreo centralizado
```

### Impacto en el Usuario
Cuando aplique, mencionar cómo afecta al usuario final:

```markdown
#### [MOD] Visualización de Mapas
- **Cambio**: Migración de OpenStreetMap a Argenmap (IGN)
- **Beneficio**: Mapas oficiales de Argentina con mejor detalle local
- **Capas disponibles**: Estándar, Gris, Oscuro, Topográfico
```

### Cambios Breaking
Destacar claramente los cambios incompatibles:

```markdown
#### [BREAKING] Nueva Estructura de DTOs
> [!WARNING]
> Este cambio requiere actualizar todos los clientes de la API

- El campo `userId` ahora es `user_id` (snake_case)
- Eliminado campo deprecado `legacyField`
- **Migración**: Ver guía en `docs/migration/v2.0.0.md`
```

## 📅 Organización Temporal

### Entradas por Fecha
Para versiones en desarrollo, agrupar por fecha de implementación:

```markdown
## 2026-02-07 - Sistema de Sincronización de Buques

### ✨ Nuevas Funcionalidades
- **Cliente Fishery**: Integración con API externa
...

### 🛠️ Mejoras y Refactorizaciones
- **VesselSyncService**: Sincronización inteligente
...

### 🧪 Testing
- Pruebas unitarias del sistema de tareas
...
```

### Versiones Liberadas
Para versiones publicadas, usar formato estándar:

```markdown
## [v0.2.0] - 2026-02-15

### Added
- Sistema de notificaciones por email
- Dashboard de administración

### Changed
- Mejorado rendimiento de consultas en 40%

### Fixed
- Corrección de bug en cálculo de totales
```

## 🎨 Formato y Estilo

### Uso de Markdown
```markdown
- **Negrita** para conceptos clave
- `Código` para nombres técnicos (tablas, campos, funciones)
- [Enlaces](url) para referencias externas
- > Blockquotes para notas importantes
```

### Emojis Semánticos (Opcional)
```markdown
### ✨ Nuevas Funcionalidades
### 🛠️ Mejoras y Refactorizaciones
### 🐛 Correcciones de Errores
### 🧪 Testing
### 📚 Documentación
### ⚡ Rendimiento
### 🔒 Seguridad
### 🏰 Integridad de Datos
```

### Listas y Jerarquía
```markdown
#### [NEW] Sistema de Autenticación
- **JWT Tokens**: Implementación de autenticación basada en tokens
  - Refresh tokens con rotación automática
  - Expiración configurable vía `JWT_EXPIRATION`
- **Roles y Permisos**: Sistema RBAC completo
  - Roles: Admin, Coordinador, Observador
  - Guards personalizados para protección de rutas
```

## 🚫 Qué NO Incluir

### ❌ Detalles de Implementación Internos
```markdown
<!-- MAL -->
- Refactorizado método privado `_calculateTotal()` en línea 245
- Cambiado nombre de variable `x` a `total`

<!-- BIEN -->
- Optimizado cálculo de totales para mejorar rendimiento en 30%
```

### ❌ Commits Individuales
```markdown
<!-- MAL -->
- fix: typo in comment
- refactor: rename variable
- chore: update dependencies

<!-- BIEN -->
#### [REFACTOR] Limpieza de Código Base
- Mejora de legibilidad en módulo de cálculos
- Actualización de dependencias a versiones LTS
```

### ❌ Cambios Triviales
No documentar:
- Cambios de formato de código
- Actualización de comentarios
- Reorganización de imports
- Cambios en archivos de configuración de desarrollo

## 📊 Ejemplos Completos

### Ejemplo: Nueva Funcionalidad Compleja
```markdown
## 2026-02-07 - Sistema de Sincronización de Buques

### ✨ Nuevas Funcionalidades
#### [NEW] Integración con API Externa de Buques
- **Cliente Fishery**: Sistema de adaptadores para consumir datos oficiales del Ministerio de Pesca
  - Arquitectura basada en patrón Strategy con `FisheryApiAdapter` (producción) y `FisheryMockAdapter` (desarrollo)
  - Configuración: `USE_MOCK_FISHERY_API`, `FISHERY_API_ENDPOINT`, `FISHERY_API_TIMEOUT`
- **Sincronización Automática**: Nuevo servicio `VesselSyncService`
  - Sincronización inteligente basada en umbral configurable (`VESSEL_SYNC_THRESHOLD_DAYS`)
  - Enriquecimiento de datos: matrícula, bandera, MMSI, dimensiones, arqueo, etc.
- **Migración de BD**: 15 nuevos campos en tabla `buques`
  - Migración aditiva segura sin pérdida de datos
  - Campo `fecha_ultima_actualizacion_api` para tracking

#### [NEW] Sistema de Cola de Tareas (JobQueue)
- **Infraestructura**: Procesamiento asíncrono de trabajos en segundo plano
  - Nueva tabla `job_queue` con reintentos automáticos y backoff exponencial
  - `SchedulerService` con bloqueo distribuido para entornos multi-instancia
  - Configuración: `JOB_SCHEDULER_INTERVAL_CRON`
- **Procesadores**: Arquitectura extensible basada en interfaz `JobProcessor`
  - `VesselSyncProcessor` con rate limiting (`VESSEL_SYNC_RATE_LIMIT_MS`)
  - Preparado para futuras tareas (sincronización de trayectorias)
- **Ventajas**:
  - No bloquea operaciones críticas (ej: importación CSV)
  - Evita saturación de APIs externas
  - Monitoreo centralizado del estado de tareas

### 🧪 Testing
- Suite de pruebas para adaptadores de API
- Validación de sincronización con datos mock
```

### Ejemplo: Corrección de Bug
```markdown
## 2026-02-06 - Correcciones de Estabilidad

### 🐛 Correcciones de Errores
#### [FIX] Error en Descarga de Backups Grandes
- **Problema**: Archivos >150MB fallaban al descargar sin mensaje de error
- **Causa**: Buffer insuficiente en proxy y nivel de compresión alto
- **Solución**:
  - Reducido nivel de compresión de ZIP de 9 a 6
  - Desactivado buffering en stream de descarga
  - Añadido overlay de feedback visual durante generación
- **Impacto**: Backups completos ahora se descargan exitosamente
```

## 🔄 Mantenimiento del Changelog

### Cuándo Actualizar
- ✅ Al completar una funcionalidad significativa
- ✅ Al corregir un bug importante
- ✅ Al hacer cambios que afecten a usuarios
- ✅ Antes de cada release

### Cuándo NO Actualizar
- ❌ Por cada commit individual
- ❌ Por cambios de desarrollo interno
- ❌ Por refactorizaciones sin impacto funcional
- ❌ Por actualizaciones de dependencias menores

### Proceso Recomendado
1. Desarrollar funcionalidad
2. Documentar en changelog al finalizar
3. Revisar y consolidar antes de merge
4. Actualizar fecha y versión en release

## 📚 Referencias

- [Keep a Changelog](https://keepachangelog.com/)
- [Semantic Versioning](https://semver.org/)
- [Conventional Commits](https://www.conventionalcommits.org/)
- [GitHub Changelog Guidelines](https://github.com/olivierlacan/keep-a-changelog)

## 🔄 Actualización de esta Skill

Esta skill debe actualizarse cuando:
- Se adopten nuevas convenciones de changelog
- Cambien los estándares del proyecto
- Surjan nuevos patrones de documentación
- Se identifiquen mejoras en claridad o estructura
