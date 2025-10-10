param(
  [string]$RepoRoot = (Join-Path $HOME 'Documents\GitHub\MeritRank'),
  [string]$Base = 'main'
)
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'

if (-not (Test-Path $RepoRoot)) { throw "Repo not found: $RepoRoot" }
Push-Location $RepoRoot
git fetch --all --prune
git checkout $Base
git pull --ff-only

$stamp  = (Get-Date -Format 'yyyyMMdd-HHmmss')
$branch = "chore/ci-pythonpath-$stamp"
git checkout -b $branch

# Ensure packages for importable tests
$initFiles = @('tools\__init__.py','tools\score_demo\__init__.py')
foreach ($f in $initFiles) {
  $dir = Split-Path -Parent $f
  New-Item -ItemType Directory -Force -Path $dir | Out-Null
  if (-not (Test-Path $f)) { "# package" | Set-Content -Encoding UTF8 $f }
}

# Write a stable CI that exports PYTHONPATH via $GITHUB_ENV (no ${{ }} needed)
$ci = '.github/workflows/ci.yml'
New-Item -ItemType Directory -Force -Path (Split-Path $ci) | Out-Null
$ciBody = @'
name: CI
on:
  push:
    branches: [ "main" ]
  pull_request:
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: "3.11"
      - name: Install pytest
        run: python -m pip install -U pip pytest
      - name: Export PYTHONPATH
        shell: bash
        run: echo "PYTHONPATH=$GITHUB_WORKSPACE" >> "$GITHUB_ENV"
      - name: Run tests
        run: python -m pytest -q
'@
Set-Content -Encoding UTF8 -LiteralPath $ci -Value $ciBody

# Commit/push/PR
$changed = git status --porcelain
if ([string]::IsNullOrWhiteSpace($changed)) {
  Write-Host "[SKIP] No changes to commit" -ForegroundColor Yellow
  git checkout $Base | Out-Null
  git branch -D $branch | Out-Null
  Pop-Location; exit 0
}
git add --all
git commit -m "CI: ensure PYTHONPATH and add __init__ files for tests" | Out-Null
git push -u origin $branch

$pr = gh pr list --state open --base $Base --head $branch --json number | ConvertFrom-Json
if (-not $pr -or $pr.Count -eq 0) {
  gh pr create --title "CI: ensure PYTHONPATH + init packages" `
               --body "Sets PYTHONPATH via GITHUB_ENV and adds missing __init__.py so tests can import `tools`." `
               --base $Base --head $branch | Out-Null
}
try {
  gh pr merge $branch --squash --delete-branch | Out-Null
  Write-Host "[OK] Merged to $Base." -ForegroundColor Green
} catch {
  Write-Host "[INFO] Merge blocked; PR left open." -ForegroundColor Yellow
  try { gh pr view $branch --web | Out-Null } catch {}
}
Pop-Location
Write-Host "[DONE] CI PythonPath fix complete." -ForegroundColor Green
