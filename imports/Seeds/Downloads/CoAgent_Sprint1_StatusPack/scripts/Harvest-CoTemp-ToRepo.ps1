param(
  [Parameter(Mandatory)][string]$RepoPath
)
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
$root = Join-Path $HOME 'Downloads\CoTemp'

if (-not (Test-Path $RepoPath)) { throw "RepoPath not found: $RepoPath" }
$dstDocs = Join-Path $RepoPath 'docs'
$dstTools = Join-Path $RepoPath 'tools\CoTempRuntime'
$null = New-Item -ItemType Directory -Force -Path $dstDocs,$dstTools | Out-Null

# Copy public-safe docs from this pack
$packDocs = Join-Path $PSScriptRoot '..\docs'
Copy-Item -Recurse -Force (Join-Path $packDocs '*') $dstDocs

# Copy select runtime helpers (not logs)
Copy-Item -Force (Join-Path $root 'Join-CoAgent.ps1') $dstTools -ErrorAction SilentlyContinue
Copy-Item -Force (Join-Path $root 'CoAgentLauncher.ps1') $dstTools -ErrorAction SilentlyContinue
Copy-Item -Recurse -Force (Join-Path $root 'common') (Join-Path $dstTools 'common') -ErrorAction SilentlyContinue
Copy-Item -Recurse -Force (Join-Path $root 'scripts') (Join-Path $dstTools 'scripts') -ErrorAction SilentlyContinue

# README for the tools folder
$readme = @"
This folder contains the pre‑CoAgent local runtime used during Sprint 1 to coordinate two sessions.
It is provided for reproducibility; these scripts do not auto‑run in the repo.
"@
Set-Content -LiteralPath (Join-Path $dstTools 'README.md') -Encoding UTF8 -Value $readme

"Harvest complete. Review changes in: $RepoPath"
