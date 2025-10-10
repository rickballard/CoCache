@echo off
setlocal
set "CT=%USERPROFILE%\Downloads\CoTemp"
if not exist "%CT%" mkdir "%CT%"
rem Launch the runner (PowerShell 7 preferred, falls back to Windows PowerShell).
set "PS7=%ProgramFiles%\PowerShell\7\pwsh.exe"
if exist "%PS7%" (
  "%PS7%" -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0tools\CoPayloadRunner.ps1"
) else (
  powershell -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0tools\CoPayloadRunner.ps1"
)
