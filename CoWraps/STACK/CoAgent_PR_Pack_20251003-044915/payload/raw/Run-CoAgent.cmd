@echo off
setlocal
REM CoAgent launcher (no PowerShell visible to end users)
start "" "%~dp0..\app\index.html"
exit /b 0
