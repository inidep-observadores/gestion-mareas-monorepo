---
name: versionamiento-semantico
description: "Herramienta para gestionar versionamiento semántico (SemVer) en el monorepo SIGMA, integrada con Conventional Commits y automatización de archivos package.json."
allowed-tools: Read, Write, Edit, Bash
---

# Skill: Versionamiento Semántico (SIGMA)

Esta skill proporciona herramientas y directrices para automatizar y estandarizar el versionado semántico en el monorepo SIGMA, vinculándolo con los mensajes de commit (Conventional Commits) y permitiendo el bump automático de archivos `package.json`.

## 📋 Propósito

Automatizar y estandarizar el proceso de:
- **Determinar** el siguiente número de versión basado en los commits desde el último tag.
- **Crear** tags anotados de versión en Git.
- **Generar** changelogs automáticos a partir de los commits agrupados por tipo.
- **Validar** el formato de versiones semánticas (SemVer 2.0.0).
- **Actualizar** automáticamente los archivos `package.json` del monorepo (raíz, backend y frontend).

## 🚀 Cuándo usar

- Antes de realizar un release o subir cambios a producción.
- Para calcular cuál debería ser la siguiente versión según los commits agregados: `semver.ps1 next`
- Para generar el borrador de los cambios del changelog: `semver.ps1 changelog`
- Para incrementar la versión en todos los archivos de configuración del monorepo: `semver.ps1 bump --version vX.Y.Z`
- Para etiquetar la versión en Git de forma segura: `semver.ps1 tag vX.Y.Z`

## 🏗️ Estructura de la Skill

Los archivos de la skill están localizados en:
```
.agent/skills/versionamiento-semantico/
├── SKILL.md                            (esta guía)
└── scripts/
    ├── semver.ps1                     (script de PowerShell principal)
    └── semver-functions.ps1           (funciones de parsing de commits y actualización de package.json)
```

## ✍️ Flujo de Trabajo para Releases

1. **Determinar la versión recomendada**:
   ```powershell
   ./.agent/skills/versionamiento-semantico/scripts/semver.ps1 next
   ```
   *Esto lee el último tag `vX.Y.Z` y analiza los commits hasta `HEAD` para proponer la siguiente versión.*

2. **Aplicar el incremento de versión (Bump)**:
   ```powershell
   ./.agent/skills/versionamiento-semantico/scripts/semver.ps1 bump v0.5.0
   ```
   *Esto actualizará automáticamente el campo `version` en:*
   - `package.json` (Raíz)
   - `app/backend/package.json`
   - `app/frontend/package.json`

3. **Generar borrador del Changelog**:
   ```powershell
   ./.agent/skills/versionamiento-semantico/scripts/semver.ps1 changelog
   ```
   *Agrupa los commits de tipo `feat`, `fix`, `perf` y breaking changes para documentar la nueva versión.*

4. **Crear Etiqueta (Tag)**:
   ```powershell
   ./.agent/skills/versionamiento-semantico/scripts/semver.ps1 tag v0.5.0 "Mensaje de Release"
   ```

## ⚠️ Reglas y Buenas Prácticas

- **Consistencia en Monorepo**: El backend, el frontend y la raíz deben estar sincronizados en la misma versión principal del release.
- **Uso de Conventional Commits**: Para que el cálculo de `next` funcione correctamente, los commits deben seguir el formato de la skill `git-commits-spanish` (ej. `feat(scope): ...`, `fix(scope): ...`, o romper con `!:`).
