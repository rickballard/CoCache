# tools/zip-rebuild.ps1 (excerpt mirror)
param([string]$OutCareer='dist/careerOS',[string]$OutLife='dist/lifeOS')
Set-StrictMode -Version Latest
$ErrorActionPreference='Stop'
function Ensure-Dir([string]$p){ if(-not (Test-Path $p)){ New-Item -ItemType Directory -Path $p | Out-Null } }
# ...see repo for full body (commit adding deterministic rebuilds) ...


