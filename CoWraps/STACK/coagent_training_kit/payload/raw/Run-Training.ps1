Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
$root = (Get-Location).Path
Write-Host "== CoAgent Training Runner =="

# 0) Status refresh
if (Test-Path "$root\tools\Write-Status.ps1") {
  pwsh -File "$root\tools\Write-Status.ps1" | Write-Host
}

# 1) Enter sandbox
if (Test-Path "$root\tools\Enter-Sandbox.ps1") {
  pwsh -File "$root\tools\Enter-Sandbox.ps1" | Write-Host
}

# 2) MVP smoke
if (Test-Path "$root\tools\Test-MVP.ps1") {
  pwsh -File "$root\tools\Test-MVP.ps1"
}

# 3) Generate mock logs
if (Test-Path "$root\tools\Generate-MockLogs.ps1") {
  pwsh -File "$root\tools\Generate-MockLogs.ps1" -Count 30 | Write-Host
}

# 4) Analyze BPOE
if (Test-Path "$root\tools\Analyze-BPOE.ps1") {
  pwsh -File "$root\tools\Analyze-BPOE.ps1"
}

Write-Host "== Training complete =="
