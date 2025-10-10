param([Parameter(Mandatory)][string]$Path,[switch]$Dots)

$Path = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Path)

$logs = $env:COTEMP_LOG
if (-not $logs) {
  $logs = Join-Path (Join-Path $HOME 'Downloads/CoTemp') 'logs'
  New-Item -ItemType Directory -Force -Path $logs | Out-Null
}

$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$leaf  = Split-Path $Path -Leaf
$base  = [IO.Path]::GetFileNameWithoutExtension($leaf)
$log   = Join-Path $logs ("{0}-{1}.log" -f $stamp, $base)

$runner = { & $using:Path *>&1 | Tee-Object -FilePath $using:log }

if ($Dots -and (Get-Command dots -ErrorAction SilentlyContinue)) {
  dots $runner -Label $leaf | Out-Null
} else {
  & $runner | Out-Null
}
Write-Host "Log: $log"
