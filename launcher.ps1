# Ruta base - Puedes cambiarla según en que directorio guardes tus proyectos
$rootDir = "Downloads"
$baseUrl = "C:\Users\usuario\$rootDir\"

# Configuración base
$configPath = Join-Path $env:USERPROFILE ".launchers"
$configsFolder = Join-Path $configPath "configs"
$lastFile = Join-Path $configPath "last_project.json"

# Crear carpetas necesarias
New-Item -ItemType Directory -Force -Path $configsFolder | Out-Null

# Recorrer subcarpetas
function Get-SubFolders {
    param (
        [Parameter(Mandatory)]
        [string]$rootPath,

        [Parameter(Mandatory)]
        [bool]$found,

        [Parameter(Mandatory)]
        [string[]]$validFiles
    )

    if (-not $found) {
        foreach ($sub in @("frontend", "backend")) {
            $subPath = Join-Path $rootPath $sub
            if (Test-Path $subPath) {
                foreach ($file in $validFiles) {
                    if (Test-Path (Join-Path $subPath $file)) {
                        return $true
                    }
                }
            }
        }
    }
    return $found
}

# Detectar proyectos válidos para poder listarlos - solo proyectos de programación
function Get-ValidProjects {
    $validFiles = @(
        "package.json", "requirements.txt", "*.sln", "*.csproj",
        "vite.config.js", "vite.config.ts", "*.astro",
        "next.config.js",
        "manage.py", "app.py",
        "pom.xml", "build.gradle",
        "go.mod", "Cargo.toml"
    )

    $projects = @()

    Get-ChildItem $baseUrl -Directory | ForEach-Object {
        $root = $_.FullName
        $found = $false

        # Revisar root
        foreach ($file in $validFiles) {
            if (Test-Path (Join-Path $root $file)) {
                $found = $true
                break
            }
        }

        # Revisar subcarpetas
        $found = Get-SubFolders -rootPath $root -found $found -validFiles $validFiles

        if ($found) {
            $projects += $_
        }
    }

    return $projects | Sort-Object Name -Unique
}

# Último proyecto
function Get-LastProject {
    if (Test-Path $lastFile) {
        return Get-Content $lastFile | ConvertFrom-Json
    }
    return $null
}

# Gestor de paquetes
function Get-PackageManager {
    param ([string]$ProjectPath)
    $packagesFiles = @(
        @{ file = "pnpm-lock.yaml"; manager = "pnpm" },
        @{ file = "yarn.lock"; manager = "yarn" },
        @{ file = "package-lock.json"; manager = "npm" }
    )
    foreach ($file in $packagesFiles) {
        if (Test-Path (Join-Path $ProjectPath $file.file)) {
            return $file.manager
        }
    }
    return $packagesFiles[$packagesFiles.Length -1].manager
}

# Detectar tecnología
function Detect-ProjectConfig {
    param ([string]$ProjectPath)

    $pm = Get-PackageManager $ProjectPath
    $detectors = @(
        @{ Match = { (Test-Path "$ProjectPath/vite.config.js") -or (Test-Path "$ProjectPath/vite.config.ts") }; Cmd = "$pm run dev"; Url = "http://localhost:5173" },
        @{ Match = { Test-Path "$ProjectPath/next.config.js" }; Cmd = "$pm run dev"; Url = "http://localhost:3000" },
        @{ Match = { Test-Path "$ProjectPath/manage.py" }; Cmd = "python manage.py runserver"; Url = "http://127.0.0.1:8000" },
        @{ Match = { (Test-Path "$ProjectPath/app.py") -and (Test-Path "$ProjectPath/requirements.txt") }; Cmd = "python app.py"; Url = "http://127.0.0.1:5000" },
        @{ Match = { Test-Path "$ProjectPath/*.astro" }; Cmd = "$pm run dev"; Url = "http://localhost:4321" }
    )

    foreach ($d in $detectors) {
        if (& $d.Match) {
            return @{ cmd = $d.Cmd; url = $d.Url }
        }
    }

    return $null
}

# Subcarpetas comunes
function Detect-SubFolder($projectPath) {
    $subs = Get-ChildItem $projectPath -Directory | Where-Object { $_.Name -in @("frontend","backend") }

    if ($subs.Count -eq 1) { return $subs[0].Name }

    if ($subs.Count -gt 1) {
        while ($true) {
            $choice = $subs.Name | Out-GridView -Title "Selecciona subcarpeta" -PassThru
            if ($choice) { return $choice }

            $key = Read-Host "No seleccionaste una subcarpeta. Presiona ENTER para volver a proyectos o X para salir"
            if ($key -match "^[Xx]$") { Stop-Process -Id $PID }
            if ($key -eq "") { return $null }
        }
    }

    return $null
}

# Seleccionar proyecto
function Get-ProjectPath {
    $last = Get-LastProject
    $projectPath = $null

    while ($true) {
        $useLast = $false
        if ($last) {
            $r = Read-Host "Abrir ultimo proyecto ($($last.name)) - [S/N]"
            if ($r -match "^[Ss]$") { $useLast = $true }
        }

        if ($useLast) {
            $projectPath = $last.path
            break
        }

        # Selección de proyecto
        $projects = Get-ValidProjects
        if (!$projects) {
            Write-Host "No hay proyectos validos. Presiona ENTER para reintentar..."
            Read-Host
            continue
        }

        $name = $projects.Name | Out-GridView -Title "Selecciona proyecto" -PassThru
        if (!$name) {
            Write-Host "No seleccionaste proyecto, volviendo a mostrar listado..."
            continue
        }

        $projectPath = Join-Path $baseUrl $name
        break
    }

    return $projectPath
}

# Función principal
function Main {
    while ($true) {
        $projectPath = Get-ProjectPath

        # Detectar subcarpeta (runtime)
        $sub = Detect-SubFolder $projectPath

        # Si no se seleccionó subcarpeta, volver al listado inicial
        if ($sub -eq $null -and (Get-ChildItem $projectPath -Directory | Where-Object { $_.Name -in @("frontend","backend") }).Count -gt 1) {
            continue
        }

        $runPath = if ($sub) { Join-Path $projectPath $sub } else { $projectPath }

        # Detectar cómo ejecutar
        $detected = Detect-ProjectConfig $runPath
        if (-not $detected) {
            Write-Host "No se pudo detectar como ejecutar el proyecto"
            Stop-Process -Id $PID
        }

        # Guardar último proyecto
        @{
            name = Split-Path $projectPath -Leaf
            path = $projectPath
            cmd  = $detected.cmd
            url  = $detected.url
            subFolder = $sub
        } | ConvertTo-Json | Out-File $lastFile

        # Ejecutar
        $cmdLine = "cd /d `"$runPath`" && $($detected.cmd)"
        Start-Process cmd.exe "/k $cmdLine"
        code $runPath

        if ($detected.url) { Start-Process $detected.url }

        # Cerrar PowerShell
        Stop-Process -Id $PID
    }
}

Main
