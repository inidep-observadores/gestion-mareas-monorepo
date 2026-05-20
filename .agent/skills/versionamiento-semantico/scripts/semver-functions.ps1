#!/usr/bin/env pwsh

<#
.SYNOPSIS
    Funciones auxiliares para gestión de versionamiento semántico en SIGMA
#>

# ============================================================================
# FUNCIONES: Obtener versiones y tags
# ============================================================================

function Get-CurrentVersion {
    <#
    .SYNOPSIS
        Obtiene la versión actual del repositorio
    #>
    $tag = Get-LastTag
    if ($tag -and $tag -ne "v0.0.0") {
        return $tag
    }
    return "v0.0.0"
}

function Get-LastTag {
    <#
    .SYNOPSIS
        Obtiene el último tag de versión (formato v*)
    #>
    try {
        $tag = git describe --tags --match "v*" --abbrev=0 2>$null
        if ($tag) {
            return $tag
        }
    } catch {
        # No hay tags aún
    }
    return "v0.0.0"
}

function Get-CommitsSinceTag {
    <#
    .SYNOPSIS
        Obtiene commits desde un tag específico (o desde el inicio si no existe)
    #>
    param(
        [Parameter(Mandatory = $true)]
        [string]$FromTag
    )

    try {
        $range = if ($FromTag -eq "v0.0.0" -or -not $FromTag) { "HEAD" } else { "$FromTag..HEAD" }
        $commits = git log $range --pretty=format:"%H|%h|%s|%b" --no-decorate 2>$null

        if (-not $commits) {
            return @()
        }

        $result = @()

        # Procesar commits
        if ($commits -is [string]) {
            $commits = @($commits -split "`n")
        }

        foreach ($line in $commits) {
            if ([string]::IsNullOrWhiteSpace($line)) { continue }

            $parts = $line -split "\|"
            $hash = $parts[0]
            $shortHash = $parts[1]
            $subject = $parts[2]
            $body = if ($parts.Count -gt 3) { $parts[3] } else { "" }

            $commit = Parse-CommitMessage $subject $body
            $commit.Hash = $hash
            $commit.ShortHash = $shortHash

            $result += $commit
        }

        return $result
    } catch {
        Write-Host "[WARNING] Error obteniendo commits: $_" -ForegroundColor Yellow
        return @()
    }
}

# ============================================================================
# FUNCIONES: Analizar commits
# ============================================================================

function Parse-CommitMessage {
    <#
    .SYNOPSIS
        Parsea un mensaje de commit en formato Conventional Commits
    #>
    param(
        [string]$Subject,
        [string]$Body
    )

    $commit = @{
        Subject = $Subject
        Body = $Body
        Type = ""
        Scope = ""
        Description = ""
        IsBreakingChange = $false
        Hash = ""
        ShortHash = ""
    }

    # Detectar breaking change en el asunto o cuerpo
    if ($Subject -like "*!:*" -or $Body -like "*BREAKING CHANGE:*") {
        $commit.IsBreakingChange = $true
    }

    # Parsear tipo(scope): descripción
    $pattern = "^([a-z]+)(\([^)]+\))?!?:\s*(.+)$"
    if ($Subject -match $pattern) {
        $commit.Type = $matches[1]
        $commit.Scope = if ($matches[2]) { $matches[2] -replace "[()]", "" } else { "" }
        $commit.Description = $matches[3]

        # Detectar breaking change por signo de exclamación antes de los dos puntos
        if ($Subject -match "^[a-z]+(\([^)]+\))?!:") {
            $commit.IsBreakingChange = $true
        }
    } else {
        # Si no cumple el patrón, se clasifica como desconocido
        $commit.Type = "unknown"
        $commit.Description = $Subject
    }

    # Parsear breaking change específico en el body
    if ($Body -match "BREAKING CHANGE:\s*(.+)") {
        $commit.IsBreakingChange = $true
    }

    return $commit
}

function Analyze-Commits {
    <#
    .SYNOPSIS
        Analiza una lista de commits para determinar tipo de versión requerida
    #>
    param(
        [Parameter(Mandatory = $true)]
        [array]$Commits
    )

    $analysis = @{
        HasBreakingChanges = $false
        HasFeatures = $false
        HasFixes = $false
        Features = @()
        Fixes = @()
        Others = @()
        BumpType = "patch"  # patch, minor, major
    }

    foreach ($commit in $Commits) {
        if ($commit.IsBreakingChange) {
            $analysis.HasBreakingChanges = $true
            $analysis.BumpType = "major"
        } 
        
        if ($commit.Type -eq "feat") {
            $analysis.HasFeatures = $true
            if ($analysis.BumpType -ne "major") {
                $analysis.BumpType = "minor"
            }
            $analysis.Features += $commit
        } elseif ($commit.Type -eq "fix" -or $commit.Type -eq "perf") {
            $analysis.HasFixes = $true
            $analysis.Fixes += $commit
        } else {
            $analysis.Others += $commit
        }
    }

    return $analysis
}

function Group-CommitsByType {
    <#
    .SYNOPSIS
        Agrupa commits por tipo
    #>
    param(
        [array]$Commits
    )

    $grouped = @{}

    $types = @('feat', 'fix', 'perf', 'docs', 'refactor', 'test', 'build', 'ci', 'chore', 'unknown')

    foreach ($type in $types) {
        $grouped[$type] = @($Commits | Where-Object { $_.Type -eq $type })
    }

    return $grouped
}

# ============================================================================
# FUNCIONES: Versionamiento
# ============================================================================

function Parse-Version {
    <#
    .SYNOPSIS
        Parsea una versión semántica en componentes
    #>
    param(
        [string]$Version
    )

    # Remover 'v' si existe
    $v = $Version -replace "^v", ""

    # Patrón: MAJOR.MINOR.PATCH[-PRERELEASE][+BUILD]
    $pattern = "^(\d+)\.(\d+)\.(\d+)(?:-([a-zA-Z0-9.-]+))?(?:\+([a-zA-Z0-9.-]+))?$"

    if ($v -match $pattern) {
        return @{
            Major = [int]$matches[1]
            Minor = [int]$matches[2]
            Patch = [int]$matches[3]
            PreRelease = if ($matches[4]) { $matches[4] } else { "" }
            Build = if ($matches[5]) { $matches[5] } else { "" }
            IsValid = $true
        }
    }

    return @{
        IsValid = $false
    }
}

function Validate-Version {
    <#
    .SYNOPSIS
        Valida que una versión cumple formato SemVer
    #>
    param(
        [string]$Version
    )

    $parsed = Parse-Version $Version
    return $parsed.IsValid
}

function Calculate-NextVersion {
    <#
    .SYNOPSIS
        Calcula la siguiente versión basada en análisis de commits
    #>
    param(
        [string]$CurrentVersion,
        [hashtable]$Analysis,
        [switch]$PreRelease
    )

    $parsed = Parse-Version $CurrentVersion

    $major = $parsed.Major
    $minor = $parsed.Minor
    $patch = $parsed.Patch

    if ($Analysis.BumpType -eq "major") {
        $major++
        $minor = 0
        $patch = 0
    } elseif ($Analysis.BumpType -eq "minor") {
        $minor++
        $patch = 0
    } else {
        $patch++
    }

    $newVersion = "v$major.$minor.$patch"

    if ($PreRelease) {
        # Agregar identificador de pre-release
        $timestamp = Get-Date -Format "yyyyMMdd.HHmmss"
        $newVersion += "-rc.$timestamp"
    }

    return $newVersion
}

# ============================================================================
# FUNCIONES: Validación de commits
# ============================================================================

function Test-CommitMessage {
    <#
    .SYNOPSIS
        Valida que un mensaje de commit sigue Conventional Commits
    #>
    param(
        [string]$Message
    )

    # Patrón: tipo[(scope)][!]: descripción
    $pattern = "^(feat|fix|docs|style|refactor|perf|test|build|ci|chore|revert)(\([^)]*\))?!?:\s*.+"
    return $Message -match $pattern
}

# ============================================================================
# FUNCIONES: Generación de changelog
# ============================================================================

function Generate-Changelog {
    <#
    .SYNOPSIS
        Genera texto de changelog a partir del análisis de commits
    #>
    param(
        [string]$Version,
        [hashtable]$Analysis,
        [string]$BaseVersion
    )

    $date = Get-Date -Format "yyyy-MM-dd"
    $changelog = "## [$Version] - $date`n`n"

    # Breaking changes
    if ($Analysis.HasBreakingChanges) {
        $changelog += "### BREAKING CHANGES`n"
        # Buscar en todos los commits
        foreach ($commit in $Analysis.Features + $Analysis.Fixes + $Analysis.Others) {
            if ($commit.IsBreakingChange) {
                $changelog += "- $($commit.Description)`n"
            }
        }
        $changelog += "`n"
    }

    # Added (features)
    $feats = @($Analysis.Features | Where-Object { -not $_.IsBreakingChange })
    if ($feats.Count -gt 0) {
        $changelog += "### Added`n"
        foreach ($commit in $feats) {
            $scope = if ($commit.Scope) { "**$($commit.Scope):** " } else { "" }
            $changelog += "- $scope$($commit.Description)`n"
        }
        $changelog += "`n"
    }

    # Fixed (fixes)
    $fixes = @($Analysis.Fixes | Where-Object { -not $_.IsBreakingChange })
    if ($fixes.Count -gt 0) {
        $changelog += "### Fixed`n"
        foreach ($commit in $fixes) {
            $scope = if ($commit.Scope) { "**$($commit.Scope):** " } else { "" }
            $changelog += "- $scope$($commit.Description)`n"
        }
        $changelog += "`n"
    }

    # Otros cambios relevantes
    $others = @($Analysis.Others | Where-Object { $_.Type -in @('docs', 'perf', 'refactor') })
    if ($others.Count -gt 0) {
        $perf = @($others | Where-Object { $_.Type -eq 'perf' })
        if ($perf.Count -gt 0) {
            $changelog += "### Performance`n"
            foreach ($commit in $perf) {
                $scope = if ($commit.Scope) { "**$($commit.Scope):** " } else { "" }
                $changelog += "- $scope$($commit.Description)`n"
            }
            $changelog += "`n"
        }

        $refactor = @($others | Where-Object { $_.Type -eq 'refactor' })
        if ($refactor.Count -gt 0) {
            $changelog += "### Refactored`n"
            foreach ($commit in $refactor) {
                $scope = if ($commit.Scope) { "**$($commit.Scope):** " } else { "" }
                $changelog += "- $scope$($commit.Description)`n"
            }
            $changelog += "`n"
        }
    }

    return $changelog.TrimEnd()
}

# ============================================================================
# FUNCIONES: Utilidades de archivo (Monorepo Node.js / package.json)
# ============================================================================

function Update-PackageJsonVersion {
    <#
    .SYNOPSIS
        Actualiza el campo "version" en un archivo package.json preservando el formato original y codificación UTF-8 sin BOM
    #>
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path,
        [Parameter(Mandatory = $true)]
        [string]$NewVersion
    )
    
    # Limpiar la 'v' inicial de la versión (ej: "v0.5.0" -> "0.5.0")
    $cleanVersion = $NewVersion -replace "^v", ""
    
    if (Test-Path $Path) {
        try {
            # Leer el archivo completo
            $content = Get-Content $Path -Raw -Encoding utf8 -ErrorAction Stop
            
            # Patrón para buscar "version": "VALOR"
            $pattern = '("version"\s*:\s*")[^"]*(")'
            $newContent = $content -replace $pattern, ('${1}' + $cleanVersion + '${2}')
            
            # Escribir usando UTF-8 sin BOM para cumplir estándares Node.js
            $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
            [System.IO.File]::WriteAllText($Path, $newContent, $utf8NoBom)
            
            Write-Host "[OK] Sincronizado ${Path} a version $cleanVersion (Preservando formato)" -ForegroundColor Green
        } catch {
            Write-Host "[ERROR] Error actualizando ${Path}: $_" -ForegroundColor Red
        }
    } else {
        Write-Host "[WARNING] No se encontro el archivo en la ruta: ${Path}" -ForegroundColor Yellow
    }
}

function Get-CommitTypeEmoji {
    <#
    .SYNOPSIS
        Retorna prefijo ASCII para tipo de commit (evita problemas de encoding de emojis)
    #>
    param(
        [string]$Type
    )

    $prefixes = @{
        'feat' = '[FEAT]'
        'fix' = '[FIX]'
        'docs' = '[DOCS]'
        'style' = '[STYLE]'
        'refactor' = '[REFACTOR]'
        'perf' = '[PERF]'
        'test' = '[TEST]'
        'build' = '[BUILD]'
        'ci' = '[CI]'
        'chore' = '[CHORE]'
        'revert' = '[REVERT]'
    }

    $val = $prefixes[$Type]
    if (-not $val) {
        return '[OTHER]'
    }
    return $val
}


