@echo off
setlocal
pushd %~dp0
powershell -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "app\bin\ps\Enter-Sandbox.ps1"  1>nul 2>nul
powershell -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "app\bin\ps\Write-Status.ps1"   1>nul 2>nul
start "" "%cd%\app\CoAgent.html"
powershell -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "app\bin\ps\Analyze-BPOE.ps1"   1>nul 2>nul
popd
exit /b 0
