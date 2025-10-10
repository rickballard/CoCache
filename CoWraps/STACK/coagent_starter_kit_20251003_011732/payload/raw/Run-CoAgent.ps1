
Set-StrictMode -Version Latest; $ErrorActionPreference = 'Stop'

param(
  [string]$BaseUrl = "https://rickballard.github.io/CoAgent",
  [switch]$Sandbox = $true,
  [switch]$OpenGuides = $true
)

Write-Host "== CoAgent Starter ==" -ForegroundColor Cyan

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$root = (Resolve-Path (Join-Path $here "..")).Path

# 1) Optional sandbox
if($Sandbox) { & (Join-Path $here "Enter-Sandbox.ps1") | Out-Host }

# 2) Status file (local)
& (Join-Path $here "Write-Status.ps1") | Out-Host

# 3) Quick MVP smoke against a hosted site (safe to skip if offline)
try { & (Join-Path $here "Test-MVP.ps1") -BaseUrl $BaseUrl | Out-Host } catch { Write-Host "Smoke skipped: $($_.Exception.Message)" -ForegroundColor Yellow }

# 4) Open guides
if($OpenGuides) { 
  $guide = Join-Path $root "docs\TRAINING.md"
  $help  = Join-Path $root "docs\HELP.md"
  foreach($p in @($guide,$help)){
    if(Test-Path $p) { Start-Process $p }
  }
}

Write-Host "== Done. Next: run tools\Generate-MockLogs.ps1 then tools\Analyze-BPOE.ps1 to see metrics. ==" -ForegroundColor Cyan
