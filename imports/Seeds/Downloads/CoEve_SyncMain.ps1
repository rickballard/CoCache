param(
  [string]$RepoRoot = (Join-Path $HOME 'Documents\GitHub\MeritRank'),
  [string]$Base = 'main'
)
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'

if (-not (Test-Path $RepoRoot)) { throw "Repo not found: $RepoRoot" }
Push-Location $RepoRoot
git fetch --all --prune

# ensure local base exists and tracks origin
if (-not (git rev-parse --verify $Base 2>$null)) { git checkout -b $Base origin/$Base } else { git checkout $Base }

# rebase onto origin/$Base; if it fails, abort and tell the user
try {
  git rebase origin/$Base
  Write-Host "[OK] $Base rebased onto origin/$Base" -ForegroundColor Green
} catch {
  git rebase --abort 2>$null
  Write-Host "[WARN] Rebase conflict. Resolve manually or run:" -ForegroundColor Yellow
  Write-Host "       git reset --hard origin/$Base   # WARNING: discards local commits"
}
Pop-Location
