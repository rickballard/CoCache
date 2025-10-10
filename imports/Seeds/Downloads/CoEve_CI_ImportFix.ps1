param(
  [string]$RepoRoot = (Join-Path $HOME 'Documents\GitHub\MeritRank'),
  [string]$Base = 'main'
)
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'

function Write-Info($msg){ Write-Host "[INFO] $msg" -ForegroundColor Cyan }
function Write-Ok($msg){ Write-Host "[OK] $msg" -ForegroundColor Green }
function Write-Warn($msg){ Write-Host "[WARN] $msg" -ForegroundColor Yellow }

if (-not (Test-Path $RepoRoot)) { throw "Repo not found: $RepoRoot" }

Push-Location $RepoRoot
git fetch --all --prune | Out-Null
git checkout $Base | Out-Null
git pull --ff-only | Out-Null

$stamp  = (Get-Date -Format 'yyyyMMdd-HHmmss')
$branch = "chore/ci-importfix-$stamp"
git checkout -b $branch | Out-Null

# 1) Ensure packages are discoverable on CI: add __init__.py files
$files = @(
  'tools/__init__.py',
  'tools/score_demo/__init__.py'
)
foreach($f in $files){
  $dir = Split-Path -Parent $f
  if($dir){ New-Item -ItemType Directory -Force -Path $dir | Out-Null }
  if(-not (Test-Path $f)){ New-Item -ItemType File -Path $f | Out-Null }
}

# 2) (Safe) tighten CI: prefer invoking pytest via the active interpreter
$ci = '.github/workflows/ci.yml'
if(Test-Path $ci){
  $orig = Get-Content $ci -Raw -Encoding UTF8
  $patched = $orig -replace '(?m)^\s*pytest\s+-q\s*$', 'python -m pytest -q'
  if($patched -ne $orig){
    $patched | Set-Content -LiteralPath $ci -Encoding UTF8
    Write-Info "Patched ci.yml to use 'python -m pytest -q'"
  }
}

# Commit if there are real changes
$changed = git status --porcelain
if([string]::IsNullOrWhiteSpace($changed)){
  Write-Warn "No changes to commit. Exiting."
  git checkout $Base | Out-Null
  git branch -D $branch | Out-Null
  Pop-Location
  exit 0
}

git add --all
git commit -m "chore(ci): fix package import for tests (add __init__.py); run pytest via python -m" | Out-Null
git push -u origin $branch | Out-Null

# PR + attempt merge
$pr = gh pr list --state open --base $Base --head $branch --json number | ConvertFrom-Json
if(-not $pr -or $pr.Count -eq 0){
  gh pr create `
    --title "CI: make tests importable + prefer python -m pytest" `
    --body  "Adds __init__.py under tools/ and tools/score_demo/ so pytest can import modules on CI; tweaks CI to run via python -m pytest for interpreter consistency." `
    --base $Base --head $branch | Out-Null
}

try{
  gh pr merge $branch --squash --delete-branch | Out-Null
  Write-Ok "Merged to $Base."
} catch {
  Write-Warn "Merge blocked; PR left open."
  try { gh pr view $branch --web | Out-Null } catch {}
}

Pop-Location
Write-Ok "Import fix script finished."
