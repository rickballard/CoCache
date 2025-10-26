param(
  [string]$RepoRoot = (Join-Path $HOME 'Documents\GitHub\MeritRank'),
  [string]$Base = 'main'
)
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
if (-not (Test-Path $RepoRoot)) { throw "Repo not found: $RepoRoot" }
Push-Location $RepoRoot
git fetch --all --prune
if (-not (git rev-parse --verify $Base 2>$null)) { git checkout -b $Base origin/$Base } else { git checkout $Base }
try { git rebase origin/$Base; Write-Host "[OK] $Base rebased onto origin/$Base" -ForegroundColor Green }
catch { git rebase --abort 2>$null; Write-Host "[WARN] Rebase conflict. Resolve or reset to origin/$Base." -ForegroundColor Yellow }
Pop-Location
