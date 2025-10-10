param(
  [string]$RepoRoot = (Join-Path $HOME 'Documents\GitHub\MeritRank'),
  [string]$Base = 'main'
)
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'

function Touch-EmptyFile([string]$Path) {
  if (-not (Test-Path $Path)) {
    New-Item -ItemType File -Path $Path -Force | Out-Null
  }
}

if (-not (Test-Path $RepoRoot)) { throw "Repo not found: $RepoRoot" }
Push-Location $RepoRoot

git fetch --all --prune | Out-Null
git checkout $Base | Out-Null
try { git pull --ff-only | Out-Null } catch { Write-Host "[WARN] Fast-forward failed; attempting rebase..." -ForegroundColor Yellow; git rebase "origin/$Base" }

$stamp = (Get-Date -Format 'yyyyMMdd-HHmmss')
$branch = "chore/ci-pythonpath-fix-$stamp"
git checkout -b $branch | Out-Null

# Ensure packages for imports
New-Item -ItemType Directory -Force -Path "tools","tools/score_demo" | Out-Null
Touch-EmptyFile "tools/__init__.py"
Touch-EmptyFile "tools/score_demo/__init__.py"

# Patch CI: ensure pytest runs with repo on PYTHONPATH
$ci = ".github/workflows/ci.yml"
if (-not (Test-Path $ci)) { throw "Missing CI workflow: $ci" }
$y = Get-Content -LiteralPath $ci -Raw

# Normalize the pytest command to include PYTHONPATH
$patched = $false
$y2 = $y -replace "(?m)^\s*pytest\s+-q\s*$","      PYTHONPATH=\$GITHUB_WORKSPACE python -m pytest -q"
if ($y2 -ne $y) { $patched = $true; $y = $y2 }
$y2 = $y -replace "(?m)^\s*python\s+-m\s+pytest\s+-q\s*$","      PYTHONPATH=\$GITHUB_WORKSPACE python -m pytest -q"
if ($y2 -ne $y) { $patched = $true; $y = $y2 }

if (-not $patched) {
  # If no plain pytest step found, try to inject a new step after setup-python
  $y = $y -replace "(?ms)(- uses:\s*actions/setup-python@v5.*?$)","`$1`r`n    - name: Run tests`r`n      run: PYTHONPATH=\$GITHUB_WORKSPACE python -m pytest -q"
  $patched = $true
}

Set-Content -LiteralPath $ci -Encoding UTF8 -Value $y

# Commit/PR/merge
$changed = git status --porcelain
if ([string]::IsNullOrWhiteSpace($changed)) {
  Write-Host "[SKIP] No changes to commit." -ForegroundColor Yellow
  git checkout $Base | Out-Null
  git branch -D $branch | Out-Null
  Pop-Location; exit 0
}

git add --all
git commit -m "CI: ensure repo on PYTHONPATH; add __init__.py for tools/*" | Out-Null
git push -u origin $branch

# Open PR if needed
$pr = gh pr list --state open --base $Base --head $branch --json number | ConvertFrom-Json
if (-not $pr -or $pr.Count -eq 0) {
  gh pr create --title "CI: fix test imports (PYTHONPATH + package inits)" `
               --body "Sets PYTHONPATH to \${{ github.workspace }} during pytest and adds __init__.py to tools/ packages." `
               --base $Base --head $branch | Out-Null
}

# Try to merge
try {
  gh pr merge $branch --squash --delete-branch | Out-Null
  Write-Host "[OK] PR merged to $Base." -ForegroundColor Green
} catch {
  Write-Host "[INFO] Merge blocked; PR left open." -ForegroundColor Yellow
  try { gh pr view $branch --web | Out-Null } catch {}
}

Pop-Location
Write-Host "[DONE] CI PYTHONPATH fix finished." -ForegroundColor Green
