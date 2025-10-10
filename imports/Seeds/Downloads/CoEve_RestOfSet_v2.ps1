param(
  [string]$RepoRoot = (Join-Path $HOME 'Documents\GitHub\MeritRank'),
  [string]$Base = 'main'
)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if (-not (Test-Path $RepoRoot)) { throw "Repo not found: $RepoRoot" }
Push-Location $RepoRoot
git fetch --all --prune
git checkout $Base
git pull --ff-only

$stamp  = (Get-Date -Format 'yyyyMMdd-HHmmss')
$branch = "advice/coeve-rest-$stamp"
git checkout -b $branch

# Stage everything first
git add --all
$changed = (git status --porcelain)

if ([string]::IsNullOrWhiteSpace($changed)) {
  Write-Host "[SKIP] No changes to commit; repo already up-to-date." -ForegroundColor Yellow
  git checkout $Base | Out-Null
  git branch -D $branch | Out-Null
  Pop-Location
  exit 0
}

git commit -m "AdviceBomb: CoEve rest-of-set update" | Out-Null
git push -u origin $branch

# Create PR if missing
$pr = gh pr list --state open --base $Base --head $branch --json number | ConvertFrom-Json
if (-not $pr -or $pr.Count -eq 0) {
  gh pr create --title "AdviceBomb: CoEve — rest-of-set update" `
               --body "Auto-PR from helper: commits staged changes only when present." `
               --base $Base --head $branch | Out-Null
}

# Try squash-merge, else leave PR open
try {
  gh pr merge $branch --squash --delete-branch | Out-Null
  Write-Host "[OK] Merged to $Base." -ForegroundColor Green
} catch {
  Write-Host "[INFO] Merge blocked; PR left open." -ForegroundColor Yellow
  try { gh pr view $branch --web | Out-Null } catch {}
}

Pop-Location
Write-Host "[DONE] Rest-of-set helper finished." -ForegroundColor Green
