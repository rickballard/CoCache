[CmdletBinding()]
param([string]$RepoPath="$HOME\Documents\GitHub\CoAgent")
Set-StrictMode -Version Latest
$ErrorActionPreference='Stop'
$repo = Resolve-Path $RepoPath -ErrorAction SilentlyContinue
if (-not $repo) { throw "Repo not found: $RepoPath" }
$unpack = Join-Path $repo 'electron\dist\win-unpacked'

Write-Host "[INFO] Stopping any running Electron/CoAgent processes..."
$names = 'coagent-shell','CoAgent','electron','app-builder','app-builder-bin'
foreach($n in $names){ Get-Process $n -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue }

# Try to delete; if locked, rename to a stale folder
if (Test-Path $unpack) {
  try { Remove-Item $unpack -Recurse -Force -ErrorAction Stop; Write-Host "[INFO] Removed $unpack" }
  catch {
    $stamp = Get-Date -Format 'yyyyMMddHHmmss'
    $stale = "$unpack.stale.$stamp"
    try { Rename-Item $unpack $stale -ErrorAction Stop; Write-Host "[INFO] Renamed locked dist to $stale" } catch {}
  }
}

Write-Host "[INFO] Rebuilding Electron (dir)..."
Push-Location (Join-Path $repo 'electron')
try { & "$env:ProgramFiles\nodejs\npx.cmd" electron-builder -w dir } finally { Pop-Location }
Write-Host "[INFO] Rebuild complete."
