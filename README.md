# Project Launcher - PowerShell Automation

![PowerShell](https://img.shields.io/badge/PowerShell-blue?logo=powershell&logoColor=white)
![Version](https://img.shields.io/badge/Version-1.0-brightgreen)

Un lanzador de proyectos de desarrollo que permite abrir automáticamente proyectos válidos de programación, detectar subcarpetas como `frontend` o `backend`, ejecutar los comandos adecuados, abrir VSCode y navegar a la URL del proyecto si aplica. Optimiza el flujo de trabajo para desarrolladores que manejan múltiples proyectos.

---

## Tabla de Contenido

- [Instalación](#instalación)  
- [Configuración de PowerShell](#configuración-de-powershell)  
- [Configuración del script](#configuración-del-script)  
- [Uso](#uso)  
- [Atajo de teclado (opcional)](#atajo-de-teclado-opcional)  
- [Seguridad](#seguridad)  
- [Contribuciones](#contribuciones)  
- [Notas finales](#notas-finales)  

---

## Instalación
Clona o descarga este repositorio en tu máquina usando:

```markdown
git clone https://github.com/RodrigoKND/launcher.git
cd path\to\launcher
```

## Configuración de PowerShell
Para ejecutar scripts locales, debes ajustar la política de ejecución a preferencia. Existen varias opciones:

### Permitir scripts locales para todos los usuarios (menos seguro)
```markdown
Set-ExecutionPolicy RemoteSigned -Scope LocalMachine
```
### Permitir scripts solo para tu usuario (recomendado)
```markdown
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```
### Permitir temporalmente para esta sesión
```markdown
Set-ExecutionPolicy Bypass -Scope Process
```
Para ejecutar scripts locales, debes ajustar la política de ejecución. Existen varias opciones:

### Permitir scripts locales para todos los usuarios (menos seguro)
```markdown
Set-ExecutionPolicy RemoteSigned -Scope LocalMachine
```
### Permitir scripts solo para tu usuario (recomendado)
```markdown
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```
### Permitir temporalmente para esta sesión
```markdown
Set-ExecutionPolicy Bypass -Scope Process
```
## Configuración del script
Dentro del archivo launcher.ps1, puedes ajustar las siguientes configuraciones según tu entorno:

## Ruta base de proyectos
```markdown
$rootDir = "Downloads"
$baseUrl = "C:\Users\usuario\$rootDir\"
```
#### Cambia "Downloads" y "C:\Users\usuario\" según la carpeta donde guardas tus proyectos

## Carpeta de configuración y último proyecto
```markdown
$configPath = Join-Path $env:USERPROFILE ".launchers"
$configsFolder = Join-Path $configPath "configs"
$lastFile = Join-Path $configPath "last_project.json"
```
#### No es necesario cambiar estas rutas a menos que quieras otro lugar para almacenar la configuración

## Archivos detectables de proyectos
```markdown
$validFiles = @(
    "package.json", "requirements.txt", "*.sln", "*.csproj",
    "vite.config.js", "vite.config.ts", "*.astro",
    "next.config.js",
    "manage.py", "app.py",
    "pom.xml", "build.gradle",
    "go.mod", "Cargo.toml"
)
```

#### Puedes agregar o quitar archivos según los tipos de proyectos que uses
#### El script detecta automáticamente subcarpetas como frontend y backend
#### Puedes modificarlas si tus proyectos usan otros nombres


## Uso
Ejecuta el script desde PowerShell con:
```markdown
.\launcher.ps1
```
El flujo de ejecución es el siguiente:

1. Si existe un último proyecto registrado, preguntará si quieres abrirlo.
2. Si no seleccionas el último, mostrará un listado de todos los proyectos válidos detectados.
3. Si el proyecto tiene subcarpetas (frontend o backend), te pedirá seleccionar cuál usar:
   - Presionando ENTER sin seleccionar volverás al listado inicial de proyectos.
   - Presionando X cerrará inmediatamente PowerShell.

Se abrirá automáticamente:

- La terminal con el comando detectado (npm run dev, python manage.py runserver, etc.)
- VSCode en la carpeta del proyecto
- La URL predeterminada si aplica

## Atajo de teclado (Recomendado)
Para mayor comodidad puedes crear un atajo de teclado que ejecute directamente el script:

1. Crea un acceso directo al archivo launcher.ps1 o a un comando de PowerShell.
2. Para que el acceso directo ejecute PowerShell con el script, usa este comando en el campo "Destino" del acceso directo:

powershell.exe -ExecutionPolicy Bypass -File "C:\ruta\a\launcher.ps1"

3. En Propiedades → Acceso directo → Tecla de método abreviado, asigna la combinación deseada (por ejemplo Ctrl + Alt + L)

Asegúrate de que PowerShell permita ejecutar scripts según la configuración de seguridad mencionada arriba.

## Seguridad
Se recomienda ejecutar scripts solo para tu usuario (CurrentUser) para no afectar la configuración global del sistema.
Evita usar Unrestricted a menos que confíes plenamente en el script.
El script no requiere permisos de administrador para la mayoría de operaciones.

## Contribuciones
Si encuentras bugs o quieres sugerir mejoras, abre una Issue en este repositorio.
Para contribuir directamente, haz un fork, realiza tus cambios y crea un Pull Request.
Se agradecerán mejoras en detección de tecnologías, subcarpetas o integración con otros frameworks.

## Notas Finales
Este script está diseñado para Windows PowerShell.
Compatible con proyectos de Node.js, Python, .NET, Java, Rust y Go, según los archivos detectables.
Revisa $baseUrl y las subcarpetas a detectar si tus proyectos difieren de la convención frontend / backend.
Guarda automáticamente el último proyecto abierto para acelerar el flujo de trabajo.



