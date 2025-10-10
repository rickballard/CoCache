param([string]$SessionId)
$root = Join-Path $HOME 'Downloads\CoTemp'
$shared = Join-Path $root '_shared'
$scripts = Join-Path $root 'scripts'
$inbox = Join-Path $root 'inbox'
$logs = Join-Path $root 'logs'
New-Item -ItemType Directory -Force -Path $shared,$scripts,$inbox,$logs | Out-Null

if (-not $env:COTEMP_SID) {
  $tag = if ($env:COTEMP_TAG) { $env:COTEMP_TAG } else { 'gmig' }
  $sid = (Get-Date -Format 'yyyyMMdd-HHmmss') + '-' + $tag + '-' + $PID
  $env:COTEMP_SID = $sid
}
$env:COTEMP_ROOT = $root
$env:COTEMP_SHARED = $shared
$env:COTEMP_BIN = Join-Path $root 'bin'
$env:COTEMP_LOG = $logs

$sessionId = if ($SessionId) { $SessionId } elseif ($env:COSESSION_ID) { $env:COSESSION_ID } else { 'co-migrate' }
$env:COTEMP_SESSION = Join-Path $root ("sessions\{0}" -f $sessionId)
New-Item -ItemType Directory -Force -Path $env:COTEMP_SESSION | Out-Null

Write-Host ("CoTemp session ready: {0}" -f (Split-Path $env:COTEMP_SESSION -Leaf))
