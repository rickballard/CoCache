param([Parameter(Mandatory)][string]$Path,[switch]$Dots)

$Path = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Path)
$logs = $env:COTEMP_LOG; if (-not $logs) { $logs = Join-Path (Join-Path $HOME "Downloads\CoTemp") "logs"; New-Item -ItemType Directory -Force -Path $logs | Out-Null }
$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$leaf  = Split-Path $Path -Leaf
$log   = Join-Path $logs "$stamp-$leaf.log"

$exe = (Get-Command pwsh -ErrorAction SilentlyContinue)?.Source
if (-not $exe) { $exe = (Get-Command powershell -ErrorAction SilentlyContinue)?.Source }

# Emit engine line into the log
$engineLabel = if ($exe) { "ENGINE: " + ([IO.Path]::GetFileName($exe)) } else { "ENGINE: direct-invoke" }

$runner = if ($exe) {
  { param($e,$p,$eng) Write-Output $eng; & $e -NoLogo -NoProfile -ExecutionPolicy Bypass -File $p }
} else {
  { param($e,$p,$eng) Write-Output $eng; & $p }
}

if ($Dots -and (Get-Command dots -ErrorAction SilentlyContinue)) {
  dots { & $runner $exe $using:Path $using:engineLabel *>&1 | Tee-Object -FilePath $using:log } -Label $leaf | Out-Null
} else {
  & $runner $exe $Path $engineLabel *>&1 | Tee-Object -FilePath $log | Out-Null
}
Write-Host "Log: $log"
