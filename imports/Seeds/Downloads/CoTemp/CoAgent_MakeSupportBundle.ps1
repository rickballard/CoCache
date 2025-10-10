param([string]$OutZip)
$ErrorActionPreference = "Stop"
$CT = Join-Path $env:USERPROFILE "Downloads\CoTemp"
if (-not $OutZip) {
  $OutZip = Join-Path $CT ("CoWrap_CoAgent_{0:yyyyMMdd-HHmmss}.zip" -f (Get-Date))
}
$pick = @(
  (Join-Path $CT "CoAgent_Harness.log"),
  (Join-Path $CT "CoAgent_Health_*.json"),
  (Join-Path $CT "BPOE_Status_*.txt"),
  (Join-Path $CT "CoSession_Sanity.txt")
) | Where-Object { Test-Path $_ }
if (-not $pick) { Write-Warning "Nothing to bundle yet."; exit 0 }
Compress-Archive -Path $pick -DestinationPath $OutZip -Force
Write-Host "Support bundle -> $OutZip" -ForegroundColor Yellow
