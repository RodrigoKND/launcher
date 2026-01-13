# Project Launcher - PowerShell Automation

![PowerShell](https://img.shields.io/badge/PowerShell-blue?logo=powershell&logoColor=white)
![Version](https://img.shields.io/badge/Version-1.0-brightgreen)

Un lanzador de proyectos de desarrollo que permite abrir automáticamente proyectos válidos de programación, detectar subcarpetas como `frontend` o `backend`, ejecutar los comandos adecuados, abrir VSCode y navegar a la URL del proyecto si aplica. Optimiza el flujo de trabajo para desarrolladores que manejan múltiples proyectos.

---

## Instalación
```markdown
Clona el repositorio:
git clone https://github.com/RodrigoKND/launcher.git
```
## Configuración rápida

### 1. Permite ejecutar scripts (PowerShell)
Ejecuta esto una vez:
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

### 2. Configura tu carpeta de proyectos
Edita `launcher.ps1` y cambia:

$baseUrl = "C:\Users\tu_usuario\Downloads\"
Y el rootDir según a la carpeta dónde guardas tus proyectos de programación, por defecto está en Downloads

## Uso

Ejecuta el script:
.\launcher.ps1

El script hará:
1. Mostrará tus proyectos disponibles
2. Detectará subcarpetas si es frontend/backend para visualizarlo en el editor
3. Abrirá VSCode
4. Ejecutará el comando de inicialización según a la configuración de tu proyecto
5. Abrirá el navegador automáticamente si tu proyecto corresponde a una web

## Ejecuta el script con un atajo de teclado - Recomendada

Crea un acceso directo en tu escritorio y después copia y pega el comando:
```markdown
powershell.exe -ExecutionPolicy Bypass -File "ruta\launcher.ps1"
```
Asigna una combinación de teclas como `Ctrl + Alt + L`

## Contribuciones
Si encuentras bugs o quieres sugerir mejoras, abre una Issue en este repositorio.
Para contribuir directamente, haz un fork, realiza tus cambios y crea un Pull Request.
Se agradecerán mejoras en detección de tecnologías, subcarpetas o integración con otros frameworks.

## Notas Finales
Este script está diseñado para Windows PowerShell.
Compatible con proyectos de Node.js, Python, .NET, Java, Rust y Go, según los archivos detectables.
Revisa $baseUrl y las subcarpetas a detectar si tus proyectos difieren de la convención frontend / backend.
Guarda automáticamente el último proyecto abierto para acelerar el flujo de trabajo.



