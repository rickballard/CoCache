[CmdletBinding()]
param([string]$RepoPath="$HOME\Documents\GitHub\CoAgent")
Set-StrictMode -Version Latest
$ErrorActionPreference='Stop'
$pair = Join-Path (Resolve-Path $RepoPath) 'tools\Pair-CoSession.ps1'
if (-not (Test-Path $pair)) { throw "Pair-CoSession.ps1 not found at $pair" }
$raw = Get-Content -Raw $pair
$raw = $raw -replace 'throw "chrome_100_percent\.pak missing; rebuild required\."', 'Write-Warning "chrome_100_percent.pak missing; attempting launch anyway (run a clean rebuild if launch fails)."'
Set-Content -Encoding UTF8 $pair $raw
Write-Host "[INFO] Relaxed .pak hard-fail in Pair-CoSession.ps1"
