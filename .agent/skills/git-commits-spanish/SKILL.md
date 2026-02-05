---
name: git-commits-spanish
description: "Genera mensajes de commit de alta calidad en español siguiendo Conventional Commits y mejores prácticas para mantener un historial de Git profesional y semántico."
allowed-tools: Read, Write, Edit
---

# 📝 Git Commits de Alta Calidad (Español)

Esta habilidad garantiza mensajes de commit profesionales, descriptivos y consistentes siguiendo el estándar de **Conventional Commits** en español.

## 🎯 Formato Estándar

```
tipo(alcance): descripción corta en español

[cuerpo opcional]

[nota de pie opcional]
```

## 📋 Tipos de Commit

| Tipo | Descripción | Ejemplo |
|------|-------------|---------|
| `feat` | Nueva característica | `feat(frontend): añadir formulario de gastos compartidos` |
| `fix` | Corrección de error | `fix(backend): corregir cálculo de totales en gastos` |
| `docs` | Solo documentación | `docs: actualizar guía de instalación` |
| `style` | Formato, espacios (sin cambio lógico) | `style(frontend): formatear componentes con Prettier` |
| `refactor` | Reestructuración sin cambio funcional | `refactor(backend): extraer lógica de validación a servicio` |
| `perf` | Mejora de rendimiento | `perf(frontend): implementar lazy loading en rutas` |
| `test` | Añadir o corregir pruebas | `test(backend): añadir pruebas unitarias para ExpensesService` |
| `build` | Sistema de build o dependencias | `build: actualizar dependencias de Vite a v6` |
| `ci` | Integración continua | `ci: añadir workflow de GitHub Actions` |
| `chore` | Mantenimiento general | `chore: actualizar .gitignore` |
| `revert` | Revertir commit anterior | `revert: revertir "feat(frontend): añadir modal"` |

## 🎯 Alcances (Scopes) del Proyecto

### Por Aplicación
- `frontend`: Cambios en `apps/frontend/`
- `backend`: Cambios en `apps/backend/`
- `root`: Cambios en la raíz del monorepo

### Por Capa/Dominio (Backend)
- `api`: Endpoints y controladores
- `db`: Prisma schemas, migraciones
- `auth`: Autenticación y autorización
- `expenses`: Módulo de gastos
- `users`: Módulo de usuarios
- `groups`: Módulo de grupos

### Por Subsistema (Frontend)
- `ui`: Componentes del sistema de diseño
- `store`: Pinia stores
- `router`: Vue Router
- `styles`: Tailwind, CSS

### General
- `deps`: Dependencias
- `config`: Configuración
- `agent`: Skills y workflows del agente

## ✅ Reglas de Oro

### 1. Idioma
**Siempre en español**

```bash
# ✅ CORRECTO
git commit -m "feat(backend): añadir endpoint de autenticación"

# ❌ INCORRECTO
git commit -m "feat(backend): add authentication endpoint"
```

### 2. Modo Imperativo
Usar presente imperativo (como dar una orden), no pasado.

```bash
# ✅ CORRECTO
"añadir", "corregir", "actualizar", "eliminar", "refactorizar"

# ❌ INCORRECTO
"añadido", "corregido", "actualizado", "eliminado", "refactorizado"
```

### 3. Minúsculas
La descripción corta empieza en minúsculas (excepto nombres propios).

```bash
# ✅ CORRECTO
feat(frontend): añadir componente ExpenseCard
fix(db): corregir migración de tabla Users

# ❌ INCORRECTO
feat(frontend): Añadir componente ExpenseCard
fix(db): Corregir migración de tabla Users
```

### 4. Longitud
- **Línea de asunto**: Máximo 72 caracteres (ideal: 50-60)
- **Cuerpo**: Máximo 72 caracteres por línea

```bash
# ✅ CORRECTO (48 caracteres)
feat(backend): añadir validación de email único

# ❌ INCORRECTO (87 caracteres)
feat(backend): añadir validación para verificar que el email del usuario sea único en la BD
```

### 5. Sin Punto Final
La línea de asunto no termina en punto.

```bash
# ✅ CORRECTO
fix(api): corregir formato de fecha en respuesta

# ❌ INCORRECTO
fix(api): corregir formato de fecha en respuesta.
```

### 6. Actualización de Changelog
Para cambios importantes (nuevas funcionalidades, correcciones lógicas significativas, mejoras de UX), **siempre** debe actualizarse el archivo de changelog correspondiente en `docs/changelog/`.
- **Ignorar**: Correcciones triviales, cambios de formato (`style`), ajustes de documentación menor o cambios menores de mantenimiento (`chore`).
- **Verificar**: Usar siempre el archivo de la versión actual definida en el `package.json` raíz.

## 📝 Estructura del Mensaje Completo

### Mensaje Simple (Cambios Obvios)
```
feat(frontend): añadir botón de cerrar sesión
```

### Mensaje con Cuerpo (Cambios Complejos)
```
refactor(backend): migrar de TypeORM a Prisma

Se refactorizó completamente la capa de acceso a datos
para utilizar Prisma ORM en lugar de TypeORM. Esto mejora
el rendimiento de las consultas y proporciona mejor soporte
de TypeScript.

Cambios principales:
- Migración de entidades a schema.prisma
- Actualización de todos los repositorios
- Ajuste de pruebas unitarias
```

### Mensaje con Breaking Change
```
feat(api)!: cambiar estructura de respuesta de gastos

BREAKING CHANGE: El endpoint GET /api/expenses ahora devuelve
un objeto con paginación en lugar de un array directo.

Antes: { data: [...] }
Ahora: { data: [...], total: 100, page: 1, pageSize: 20 }

Los clientes deben actualizar su código para acceder a la
propiedad 'data' del objeto de respuesta.
```

### Mensaje con Issue Reference
```
fix(backend): corregir cálculo de deuda en grupos

Corrige el algoritmo de división de gastos cuando hay
participantes con diferentes porcentajes de participación.

Closes #23
```

## 🎨 Ejemplos por Categoría

### Features (feat)
```bash
feat(frontend): añadir página de estadísticas de gastos
feat(backend): implementar endpoint de exportación a PDF
feat(ui): crear componente AppDatePicker
feat(auth): añadir autenticación con JWT
feat(db): añadir tabla de categorías de gastos
```

### Fixes (fix)
```bash
fix(frontend): corregir redondeo en cálculo de totales
fix(backend): resolver error 500 en endpoint de grupos
fix(ui): corregir alineación de botones en móvil
fix(store): corregir duplicación de gastos en caché
fix(db): corregir migración fallida de foreign keys
```

### Documentación (docs)
```bash
docs: añadir guía de instalación local
docs(api): documentar endpoint de autenticación
docs: actualizar README con comandos de desarrollo
docs(backend): añadir JSDoc a ExpensesService
```

### Refactorización (refactor)
```bash
refactor(frontend): extraer lógica de validación a composable
refactor(backend): simplificar estructura de DTOs
refactor(ui): unificar estilos de botones
refactor(store): migrar a Composition API en stores
```

### Performance (perf)
```bash
perf(frontend): implementar virtualización en lista de gastos
perf(backend): añadir índice a columna email en Users
perf(api): implementar caché en consultas frecuentes
perf(db): optimizar query de gastos por fecha
```

### Pruebas (test)
```bash
test(backend): añadir pruebas e2e para autenticación
test(frontend): añadir pruebas unitarias para ExpenseCard
test(api): aumentar cobertura de pruebas al 80%
```

### Build/Dependencias (build)
```bash
build: actualizar Node.js a v20 LTS
build(deps): actualizar Tailwind CSS a v4
build(frontend): migrar de Vite 5 a Vite 6
build: configurar Vitest para pruebas
```

### Chores (chore)
```bash
chore: actualizar .gitignore
chore(deps): actualizar dependencias menores
chore: limpiar archivos temporales de build
chore(agent): añadir nueva skill de documentación
```

## 🚫 Anti-Patrones Comunes

### ❌ Mensajes Vagos
```bash
# ❌ MAL
fix: arreglar bug
feat: cambios en el frontend
chore: actualizar cosas

# ✅ BIEN
fix(auth): corregir validación de token expirado
feat(frontend): añadir gráfico de gastos mensuales
chore(deps): actualizar Vue Router a v4.3
```

### ❌ Mezclar Múltiples Cambios
```bash
# ❌ MAL
feat: añadir login, corregir bug de totales y actualizar README

# ✅ BIEN - Dividir en commits separados
feat(auth): añadir página de login
fix(expenses): corregir cálculo de totales
docs: actualizar README con sección de autenticación
```

### ❌ Descripción en Pasado
```bash
# ❌ MAL
feat(backend): añadido endpoint de usuarios
fix(frontend): corregido error en formulario

# ✅ BIEN
feat(backend): añadir endpoint de usuarios
fix(frontend): corregir error en formulario
```

### ❌ Sin Alcance en Cambios Específicos
```bash
# ❌ MAL
feat: añadir validación de email
fix: corregir error de autenticación

# ✅ BIEN (con alcance apropiado)
feat(backend): añadir validación de email en DTOs
fix(auth): corregir error de autenticación con tokens expirados
```

## 🔍 Guía de Decisión Rápida

### ¿Qué tipo usar?

```
¿Añade funcionalidad nueva?
├─ Sí → feat
└─ No
    ├─ ¿Corrige un error?
    │  └─ Sí → fix
    └─ No
        ├─ ¿Solo cambia documentación?
        │  └─ Sí → docs
        └─ No
            ├─ ¿Cambia estructura sin afectar comportamiento?
            │  └─ Sí → refactor
            └─ No
                ├─ ¿Mejora el rendimiento?
                │  └─ Sí → perf
                └─ No
                    ├─ ¿Solo añade/modifica pruebas?
                    │  └─ Sí → test
                    └─ No
                        ├─ ¿Cambia build/dependencias?
                        │  └─ Sí → build
                        └─ No → chore
```

### ¿Qué alcance usar?

```
¿Dónde está el cambio?
├─ apps/frontend/ → frontend
├─ apps/backend/ → backend
│   ├─ src/auth/ → auth
│   ├─ src/expenses/ → expenses
│   ├─ src/users/ → users
│   └─ prisma/ → db
├─ .agent/ → agent
└─ raíz, package.json, etc. → root
```

## 🎓 Recursos Adicionales

- [Conventional Commits](https://www.conventionalcommits.org/es/)
- [Semantic Versioning](https://semver.org/lang/es/)
- [How to Write a Git Commit Message](https://cbea.ms/git-commit/)

## ✨ Checklist Pre-Commit

Antes de hacer commit, verifica:
- [ ] El tipo de commit es correcto
- [ ] El alcance (scope) es apropiado
- [ ] La descripción está en español
- [ ] Usa modo imperativo (presente)
- [ ] Empieza en minúsculas
- [ ] No excede 72 caracteres
- [ ] No termina en punto
- [ ] El mensaje describe QUÉ y POR QUÉ, no CÓMO
- [ ] Se han registrado los cambios importantes en el changelog (si aplica)

---

> **Recuerda**: Un buen mensaje de commit explica el contexto del cambio y facilita entender el historial del proyecto en el futuro.
