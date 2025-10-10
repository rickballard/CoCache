# QUICK_CMDS for Migrate panel
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'

# Ensure env
. "$HOME\Downloads\CoTemp\Join-CoAgent.ps1"

Write-Host "Session: $env:COSESSION_ID" -ForegroundColor Cyan

# Status
& "$HOME\Downloads\CoTemp\scripts\Status-QuickCheck.ps1"

# Example note to Planning
# Send-CoNote -ToSessionId 'co-planning' -Text "Migrate: ccts fallback progressing."

# Tail latest log
$S = Join-Path $HOME "Downloads\CoTemp\sessions\$env:COSESSION_ID"
$last = Get-ChildItem "$S\logs" -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -desc | Select-Object -First 1
if ($last) { "`n--- Tail: $($last.Name) ---"; Get-Content -LiteralPath $last.FullName -Tail 40 }

