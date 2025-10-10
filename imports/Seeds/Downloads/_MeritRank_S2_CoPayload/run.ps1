param([string]$RepoRoot = (Get-Location).Path)
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
$mapper = Join-Path $PSScriptRoot 'scripts\mapper_demo.ps1'
$scorer = Join-Path $PSScriptRoot 'scripts\score_demo.ps1'
if (-not (Test-Path $mapper) -or -not (Test-Path $scorer)) { throw "Missing demo scripts." }
pwsh -File $mapper -RepoRoot $RepoRoot -OutDir (Join-Path $RepoRoot 'out')
pwsh -File $scorer -MapPath (Join-Path $RepoRoot 'out\map_demo.json') -OutDir (Join-Path $RepoRoot 'out')
Get-Content (Join-Path $RepoRoot 'out\meritrank_score.txt')