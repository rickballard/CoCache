param(
  [string]$Steps = '00,10,20,40,41,60'
)
Set-StrictMode -Version Latest
$ErrorActionPreference='Stop'
function Note($m){ Write-Host "[MVP3] $m" }
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$packRoot = Split-Path -Parent $here
$stateDir = Join-Path $packRoot 'state'
$logsDir  = Join-Path $packRoot 'logs'
New-Item -ItemType Directory -Force -Path $stateDir,$logsDir | Out-Null
$map = @{
  '00' = (Join-Path $here 'scripts/00-Prep-Paths.ps1')
  '10' = (Join-Path $here 'scripts/10-SessionRegistry.ps1')
  '20' = (Join-Path $here 'scripts/20-Orchestrator-Patch.ps1')
  '40' = (Join-Path $here 'scripts/40-RepoPlan-Update.ps1')
  '41' = (Join-Path $here 'scripts/41-Help-And-Training.ps1')
  '60' = (Join-Path $here 'scripts/60-Build-Package.ps1')
}
$steps = $Steps.Split(',') | ForEach-Object { $_.Trim() } | Where-Object { $_ }
foreach($s in $steps){
  if(-not $map.ContainsKey($s)){ Note "Unknown step $s (skipped)"; continue }
  $script = $map[$s]
  if(-not (Test-Path $script)){ Note "Missing step $s -> $script (skipped)"; continue }
  Note "Running $([IO.Path]::GetFileName($script))"
  & $script
  Note "OK  $([IO.Path]::GetFileName($script))"
}
Note "Assembly complete."
