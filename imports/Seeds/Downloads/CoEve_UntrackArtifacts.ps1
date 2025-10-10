param(
  [string]$RepoRoot = (Join-Path $HOME 'Documents\GitHub\MeritRank'),
  [string]$Base = 'main'
)
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'

if (-not (Test-Path $RepoRoot)) { throw "Repo not found: $RepoRoot" }
Push-Location $RepoRoot
git fetch --all --prune | Out-Null

# Ensure local base exists and is current
if (-not (git rev-parse --verify $Base 2>$null)) { git checkout -b $Base origin/$Base | Out-Null } else { git checkout $Base | Out-Null }
git pull --ff-only | Out-Null

$gi = '.gitignore'
$want = @(
  'components/seeder/out/',
  'tools/score_demo/out.json'
)
if (-not (Test-Path $gi)) { New-Item -ItemType File -Path $gi | Out-Null }

$existing = Get-Content $gi -ErrorAction SilentlyContinue
$added = $false
foreach ($p in $want) {
  if (-not ($existing -contains $p)) { Add-Content $gi $p; $added = $true }
}

# Untrack if currently tracked (ignore errors)
git rm -r --cached --quiet --ignore-unmatch components/seeder/out 2>$null
git rm     --cached --quiet --ignore-unmatch tools/score_demo/out.json 2>$null

$changed = git status --porcelain
if (-not [string]::IsNullOrWhiteSpace($changed)) {
  $branch = "chore/untrack-artifacts-" + (Get-Date -Format 'yyyyMMdd-HHmmss')
  git checkout -b $branch | Out-Null
  git add -A
  git commit -m "chore: ignore generated artifacts (seeder out/, score_demo/out.json)" | Out-Null
  git push -u origin $branch | Out-Null

  try {
    gh pr create --title "chore: ignore generated artifacts" `
                 --body "Add ignore for seeder outputs and score json; remove tracked artifacts." `
                 --base $Base --head $branch | Out-Null
  } catch {}

  try {
    gh pr merge $branch --squash --delete-branch | Out-Null
    Write-Host "[OK] Merged PR to $Base." -ForegroundColor Green
  } catch {
    Write-Host "[INFO] Merge protections; PR left open." -ForegroundColor Yellow
  }
} else {
  Write-Host "[OK] Nothing to change." -ForegroundColor Green
}
Pop-Location