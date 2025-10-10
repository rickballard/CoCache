param(
  [int]$Last = 15,
  [string]$Url
)
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
if(-not $Url){
  $Desktop = [Environment]::GetFolderPath('Desktop')
  $Beacon  = Join-Path $Desktop "CoCivBus_Beacon.json"
  if(-not (Test-Path $Beacon)){ throw "No -Url provided and Desktop beacon not found." }
  $Url = (Get-Content $Beacon -Raw | ConvertFrom-Json).bus_url
}
try {
  $raw = (Invoke-WebRequest -UseBasicParsing -Uri $Url -TimeoutSec 30).Content
} catch {
  throw "Failed to fetch $Url — $($_.Exception.Message)"
}
# Print last N lines
$lines = $raw -split "`r?`n" | Where-Object { $_.Trim().Length -gt 0 }
$tail = $lines | Select-Object -Last $Last
$tail -join "`n" | Write-Output
