#!/usr/bin/env pwsh
# Gestor de Versionamiento Semántico para SIGMA

param(
    [Parameter(Position = 0, Mandatory = $true)]
    [string]$Command,
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$OtherArgs
)

# Obtener rutas de forma robusta
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Definition
$repoRoot = (Resolve-Path "$scriptPath\..\..\..\..").Path

# Cargar funciones auxiliares
. "$scriptPath\semver-functions.ps1"

function Show-Help {
    Write-Host "SIGMA Versioning Tool (SemVer)" -ForegroundColor Cyan
    Write-Host "`nComandos disponibles:" -ForegroundColor Cyan
    Write-Host "  next                - Determinar la siguiente version recomendada basada en commits" -ForegroundColor Gray
    Write-Host "  commits             - Listar commits nuevos desde la ultima version" -ForegroundColor Gray
    Write-Host "  changelog           - Generar el borrador del changelog para la version actual" -ForegroundColor Gray
    Write-Host "  bump [vX.Y.Z]       - Sincronizar y actualizar todos los package.json a la version dada" -ForegroundColor Gray
    Write-Host "  tag [vX.Y.Z] [msg]  - Crear y firmar un tag Git para la version dada" -ForegroundColor Gray
    Write-Host "  validate [vX.Y.Z]   - Validar si el formato cumple con la especificacion SemVer" -ForegroundColor Gray
    Write-Host "  help                - Mostrar esta ayuda" -ForegroundColor Gray
    Write-Host ""
    exit 0
}

# ============================================================================
# COMANDO: next
# ============================================================================
if ($Command -eq 'next') {
    Write-Host "Analizando historial de commits para sugerir version..." -ForegroundColor Cyan

    $lastTag = Get-LastTag
    Write-Host "Ultimo tag de version detectado: $lastTag" -ForegroundColor Gray

    $commits = Get-CommitsSinceTag $lastTag

    if ($commits.Count -eq 0) {
        Write-Host "No hay commits nuevos desde la version actual ($lastTag)" -ForegroundColor Yellow
        exit 0
    }

    Write-Host "Nuevos commits evaluados: $($commits.Count)" -ForegroundColor Gray

    $analysis = Analyze-Commits -Commits $commits
    $nextVersion = Calculate-NextVersion -CurrentVersion $lastTag -Analysis $analysis

    Write-Host "`nSugerencia de version: " -NoNewline
    Write-Host $nextVersion -ForegroundColor Green

    Write-Host "`nResumen de cambios:" -ForegroundColor Cyan
    Write-Host "  Tipo de incremento: $($analysis.BumpType.ToUpper())" -ForegroundColor Cyan
    if ($analysis.HasBreakingChanges) { Write-Host "  [BREAKING] Contiene BREAKING CHANGES (Cambios mayores)" -ForegroundColor Red }
    if ($analysis.HasFeatures) { Write-Host "  [FEATURE]  Contiene Features (Nuevas funcionalidades)" -ForegroundColor Green }
    if ($analysis.HasFixes) { Write-Host "  [FIX]      Contiene Correcciones o mejoras de rendimiento" -ForegroundColor Yellow }

    exit 0
}

# ============================================================================
# COMANDO: commits
# ============================================================================
elseif ($Command -eq 'commits') {
    $lastTag = Get-LastTag
    Write-Host "Listando commits desde el ultimo tag ($lastTag)..." -ForegroundColor Cyan

    $commits = Get-CommitsSinceTag $lastTag

    if ($commits.Count -eq 0) {
        Write-Host "No hay commits nuevos desde $lastTag" -ForegroundColor Yellow
        exit 0
    }

    Write-Host "`nTotal: $($commits.Count) commits`n" -ForegroundColor Gray

    foreach ($commit in $commits) {
        $emoji = Get-CommitTypeEmoji $commit.Type
        $breakingSymbol = if ($commit.IsBreakingChange) { " ⚠️ " } else { "" }
        Write-Host "$($commit.ShortHash) - $emoji [$($commit.Type)] $($commit.Description)$breakingSymbol" -ForegroundColor Gray
    }

    exit 0
}

# ============================================================================
# COMANDO: changelog
# ============================================================================
elseif ($Command -eq 'changelog') {
    $lastTag = Get-LastTag
    $commits = Get-CommitsSinceTag $lastTag

    if ($commits.Count -eq 0) {
        Write-Host "No hay commits nuevos para generar un changelog." -ForegroundColor Yellow
        exit 0
    }

    $analysis = Analyze-Commits -Commits $commits
    $nextVersion = Calculate-NextVersion -CurrentVersion $lastTag -Analysis $analysis

    $changelogContent = Generate-Changelog -Version $nextVersion -Analysis $analysis -BaseVersion $lastTag
    
    Write-Host "Borrador de cambios generado exitosamente para la version ${nextVersion}:" -ForegroundColor Green
    Write-Host "`n$changelogContent" -ForegroundColor Gray
    exit 0
}

# ============================================================================
# COMANDO: bump
# ============================================================================
elseif ($Command -eq 'bump') {
    if ($OtherArgs.Count -eq 0) {
        Write-Host "ERROR: Especifique la version para realizar el bump. Ejemplo: semver.ps1 bump v0.5.0" -ForegroundColor Red
        exit 1
    }
    
    $version = $OtherArgs[0]
    
    if (-not (Validate-Version $version)) {
        Write-Host "ERROR: Formato de version invalido '$version'. Debe cumplir con la especificacion SemVer (ej: v0.5.0)." -ForegroundColor Red
        exit 1
    }
    
    Write-Host "Sincronizando versiones de package.json a la version: $version" -ForegroundColor Cyan
    
    # Mapeo de archivos package.json del monorepo
    $rootPackage = "$repoRoot\package.json"
    $backendPackage = "$repoRoot\app\backend\package.json"
    $frontendPackage = "$repoRoot\app\frontend\package.json"
    
    Update-PackageJsonVersion -Path $rootPackage -NewVersion $version
    Update-PackageJsonVersion -Path $backendPackage -NewVersion $version
    Update-PackageJsonVersion -Path $frontendPackage -NewVersion $version
    
    Write-Host "`nSincronizacion completada con exito." -ForegroundColor Green
    exit 0
}

# ============================================================================
# COMANDO: tag
# ============================================================================
elseif ($Command -eq 'tag') {
    if ($OtherArgs.Count -eq 0) {
        Write-Host "ERROR: Especifique la version para el tag. Uso: semver.ps1 tag v1.0.0 [Mensaje]" -ForegroundColor Red
        exit 1
    }

    $version = $OtherArgs[0]
    $message = if ($OtherArgs.Count -gt 1) { $OtherArgs[1..($OtherArgs.Count-1)] -join " " } else { "Release $version" }

    if (-not (Validate-Version $version)) {
        Write-Host "ERROR: Version invalida: $version. Debe cumplir SemVer." -ForegroundColor Red
        exit 1
    }

    Write-Host "Creando tag en Git: $version" -ForegroundColor Cyan
    Write-Host "Mensaje: $message" -ForegroundColor Gray

    try {
        git tag -a $version -m $message
        Write-Host "Tag Git creado con exito." -ForegroundColor Green
        Write-Host "Siguiente paso: git push origin $version" -ForegroundColor Gray
    } catch {
        Write-Host "ERROR al crear el tag en Git: $_" -ForegroundColor Red
        exit 1
    }

    exit 0
}

# ============================================================================
# COMANDO: validate
# ============================================================================
elseif ($Command -eq 'validate') {
    if ($OtherArgs.Count -eq 0) {
        Write-Host "ERROR: Especifique la version a validar. Uso: semver.ps1 validate v1.0.0" -ForegroundColor Red
        exit 1
    }

    $version = $OtherArgs[0]

    if (Validate-Version $version) {
        Write-Host "Correcto: '$version' cumple con SemVer 2.0.0" -ForegroundColor Green
        exit 0
    } else {
        Write-Host "Error: '$version' NO cumple con SemVer" -ForegroundColor Red
        Write-Host "Formato esperado: vMAJOR.MINOR.PATCH (ej: v1.0.0, v0.5.1)" -ForegroundColor Gray
        exit 1
    }
}

# ============================================================================
# COMANDO: help
# ============================================================================
elseif ($Command -eq 'help' -or $Command -eq '--help' -or $Command -eq '-h') {
    Show-Help
}

# ============================================================================
# Comando desconocido
# ============================================================================
else {
    Write-Host "ERROR: Comando desconocido: $Command" -ForegroundColor Red
    Show-Help
}
