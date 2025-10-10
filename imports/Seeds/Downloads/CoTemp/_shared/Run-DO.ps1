param([Parameter(Mandatory)][string]$Path,[switch]$Dots)
$Path = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Path)
$logs = $env:COTEMP_LOG
if (-not $logs -or -not (Test-Path $logs)) { $root = Join-Path $env:USERPROFILE 'Downloads\CoTemp'; $logs = Join-Path $root 'logs'; New-Item -ItemType Directory -Force -Path $logs | Out-Null }
$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$leaf  = Split-Path $Path -Leaf
$log   = Join-Path $logs "$stamp-$leaf.log"

# Prefer pwsh, fallback to Windows PowerShell
$exe = $null
try { $cmd = Get-Command pwsh -ErrorAction Stop;       $exe = $cmd.Source } catch {}
if (-not $exe) {
  try { $cmd = Get-Command powershell -ErrorAction Stop; $exe = $cmd.Source } catch {}
}
$engineLabel = "ENGINE: " + ($(if ($exe) { [IO.Path]::GetFileName($exe) } else { 'direct-invoke' }))

$runner = {
  param($e,$p,$eng)
  Write-Output $eng
  if ($e) { & $e -NoLogo -NoProfile -ExecutionPolicy Bypass -File $p } else { & $p }
}

if ($Dots -and (Get-Command dots -ErrorAction SilentlyContinue)) {
  dots { & $runner $using:exe $using:Path $using:engineLabel *>&1 | Tee-Object -FilePath $using:log } -Label $leaf | Out-Null
} else {
  & $runner $exe $Path $engineLabel *>&1 | Tee-Object -FilePath $log | Out-Null
}
Write-Host "Log: $log"
