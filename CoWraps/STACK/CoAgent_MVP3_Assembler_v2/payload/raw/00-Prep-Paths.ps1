Set-StrictMode -Version Latest
$ErrorActionPreference='Stop'
$packRoot = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$logs = Join-Path $packRoot 'logs'
$state= Join-Path $packRoot 'state'
New-Item -ItemType Directory -Force -Path $logs,$state | Out-Null
Write-Host "[00-Prep] Logs:  $logs"
Write-Host "[00-Prep] State: $state"
