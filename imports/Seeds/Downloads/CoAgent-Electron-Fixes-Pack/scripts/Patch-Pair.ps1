# P A T C H E D   P A I R   S C R I P T
# Drop this file over tools\Pair-CoSession.ps1
[CmdletBinding()]
param(
  [switch]$SkipBuild,
  [switch]$WaitExec = $false,
  [switch]$AutoExec = $false
)
Set-StrictMode -Version Latest
$ErrorActionPreference='Stop'

$repo   = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$unpack = Join-Path $repo 'electron\dist\win-unpacked'

function Stop-CoAgent {
  Get-Process coagent-shell, CoAgent -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
}

if (-not $SkipBuild) {
  Stop-CoAgent
  Push-Location (Join-Path $repo 'electron')
  try {
    & "$env:ProgramFiles\nodejs\npx.cmd" electron-builder -w dir
  } finally {
    Pop-Location
  }
}

# Robust exe discovery + resource sanity
$exe = Get-ChildItem -Path $unpack -Filter '*.exe' -File -ErrorAction SilentlyContinue | Sort-Object Length -Descending | Select-Object -First 1
if (-not $exe) { throw "No .exe found under $unpack. Build may have failed." }
$pakTop = Join-Path $unpack 'chrome_100_percent.pak'
$pakRes = Join-Path $unpack 'resources\chrome_100_percent.pak'
if (-not (Test-Path $pakTop) -and -not (Test-Path $pakRes)) {
  throw "chrome_100_percent.pak missing; rebuild required."
}

Start-Process $exe.FullName -WorkingDirectory $unpack
Write-Host "CoAgent launched"
