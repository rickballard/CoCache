@echo off
setlocal
set CT=%USERPROFILE%\Downloads\CoTemp

REM Prefer PowerShell 7; fall back to Windows PowerShell
where pwsh >nul 2>nul
if %ERRORLEVEL%==0 ( set PWSH=pwsh ) else (
  echo PowerShell 7 not found. You can install from: https://aka.ms/powershell
  set PWSH=powershell
)

start "%USERNAME% - CoAgent: Planning" %PWSH% -NoLogo -NoProfile -ExecutionPolicy Bypass -NoExit -Command ^
  "$env:COSESSION_ID='co-planning'; Set-ExecutionPolicy -Scope Process Bypass -Force; " ^
  "& '$CT\scripts\Start-CoWatchers.ps1' -Tag 'gmig'; " ^
  "Write-Host 'Planning pane ready.' -ForegroundColor Green"

start "%USERNAME% - CoAgent: Migrate" %PWSH% -NoLogo -NoProfile -ExecutionPolicy Bypass -NoExit -Command ^
  "$env:COSESSION_ID='co-migrate'; Set-ExecutionPolicy -Scope Process Bypass -Force; " ^
  "& '$CT\scripts\Start-CoWatchers.ps1' -Tag 'gmig'; " ^
  "Write-Host 'Migrate pane ready.' -ForegroundColor Green"

endlocal
