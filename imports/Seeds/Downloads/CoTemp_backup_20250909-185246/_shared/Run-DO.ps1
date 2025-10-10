param([Parameter(Mandatory)][string]$Path,[switch]$Dots)

$Path = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Path)
$logs = $env:COTEMP_LOG
if (-not $logs) {
  $logs = Join-Path (Join-Path $HOME 'Downloads/CoTemp') 'logs'
  New-Item -ItemType Directory -Force -Path $logs | Out-Null
}

$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$leaf  = Split-Path $Path -Leaf
$log   = Join-Path $logs "$stamp-$leaf.log"

if ($Dots -and (Get-Command dots -ErrorAction SilentlyContinue)) {
  dots { & $Path *>&1 | Tee-Object -FilePath $log } -Label $leaf | Out-Null
} else {
  & $Path *>&1 | Tee-Object -FilePath $log | Out-Null
}
Write-Host "Log: $log"
