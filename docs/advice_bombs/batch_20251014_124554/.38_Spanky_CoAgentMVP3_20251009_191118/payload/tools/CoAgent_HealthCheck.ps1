# CoAgent_HealthCheck.ps1 — light BPOE recheck
param([switch]$Silent)
$CT = Join-Path $env:USERPROFILE "Downloads\CoTemp"
$result = [pscustomobject]@{
  time = Get-Date -Format o
  has_CT = (Test-Path $CT)
  has_runner = Test-Path (Join-Path $CT 'tools\CoPayloadRunner.ps1')
  pwsh = (Get-Command pwsh -ErrorAction SilentlyContinue | Select -Expand Source -First 1)
}
if (-not $Silent) { $result | ConvertTo-Json -Depth 5 }

