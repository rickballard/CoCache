@echo off
setlocal
set "PS1=%~dp0tools\CoAgent_SendHealth.ps1"
rem TODO: set your repo owner/name below
powershell -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%PS1%" YOUR-ORG-OR-USER YOUR-REPO
pause
