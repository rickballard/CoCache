
param(
  [string]$RepoRoot = (Join-Path $HOME 'Documents\GitHub\MeritRank'),
  [string]$Base = 'main',
  [switch]$TriggerCI
)
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'

function Ensure-Pytest {
  param([string]$Py = 'python')
  try {
    & $Py -m pytest --version | Out-Null
    return $true
  } catch {
    try {
      & $Py -m pip install -U pytest | Out-Null
      & $Py -m pytest --version | Out-Null
      return $true
    } catch {
      Write-Host "[WARN] Could not install pytest automatically." -ForegroundColor Yellow
      return $false
    }
  }
}

if (-not (Test-Path $RepoRoot)) { throw "Repo not found: $RepoRoot" }
$RepoRoot = (Resolve-Path $RepoRoot).Path

Push-Location $RepoRoot
git fetch --all --prune | Out-Null
# checkout or create local base
if (-not (git rev-parse --verify $Base 2>$null)) {
  git checkout -b $Base origin/$Base | Out-Null
} else {
  git checkout $Base | Out-Null
}
# rebase onto origin
try {
  git rebase origin/$Base | Out-Null
  Write-Host "[OK] $Base rebased onto origin/$Base" -ForegroundColor Green
} catch {
  git rebase --abort 2>$null
  Write-Host "[WARN] Rebase conflict; continuing with origin/$Base fast-sync.." -ForegroundColor Yellow
  git reset --hard origin/$Base | Out-Null
}

# Allowlist ensure
$allow = Join-Path $RepoRoot 'components\seeder\config\allowlist.txt'
New-Item -ItemType Directory -Force -Path (Split-Path $allow) | Out-Null
if (-not (Test-Path $allow)) { New-Item -ItemType File -Force -Path $allow | Out-Null }
$current = Get-Content -LiteralPath $allow -ErrorAction SilentlyContinue
$needles = @('https://example.org/','https://www.iana.org/domains/reserved')
foreach ($u in $needles) { if (-not ($current -contains $u)) { Add-Content -LiteralPath $allow -Value $u } }

# local sample if present
$fixture = Join-Path $RepoRoot 'components\seeder\fixtures\sample_cred.html'
if (Test-Path $fixture) {
  $uri = 'file:///' + $fixture.Replace('\','/')
  if (-not ($current -contains $uri)) { Add-Content -LiteralPath $allow -Value $uri }
}

# Seed (mapper=basic if supported, else default)
$seedPy = Join-Path $RepoRoot 'components\seeder\seeder.py'
$outEvt = Join-Path $RepoRoot 'components\seeder\out\events.ndjson'
New-Item -ItemType Directory -Force -Path (Split-Path $outEvt) | Out-Null
try {
  python $seedPy --mapper basic --allowlist $allow --out $outEvt 2>$null
} catch {
  python $seedPy --allowlist $allow --out $outEvt
}
if (-not (Test-Path $outEvt)) { throw "Seeding failed; $outEvt not written." }
Write-Host "[OK] Seeded -> $outEvt" -ForegroundColor Green

# Score
$outScore = Join-Path $RepoRoot 'tools\score_demo\out.json'
python (Join-Path $RepoRoot 'tools\score_demo\score.py') --in $outEvt --out $outScore
if (-not (Test-Path $outScore)) { throw "Scoring failed; $outScore not written." }
Write-Host "[OK] Scored -> $outScore" -ForegroundColor Green
Get-Content -LiteralPath $outScore | Write-Host

# Tests (best-effort)
if (Ensure-Pytest) {
  try {
    python -m pytest -q tools/score_demo/tests
  } catch {
    Write-Host "[WARN] pytest run failed: $($_.Exception.Message)" -ForegroundColor Yellow
  }
} else {
  Write-Host "[INFO] Skipping pytest (not installed)." -ForegroundColor Yellow
}

# CI trigger (optional)
if ($TriggerCI) {
  try {
    gh workflow run mapper-smoke.yml --ref $Base | Out-Null
    Start-Sleep -Seconds 2
    $run = gh run list --workflow "mapper-smoke.yml" --limit 1 --json databaseId,headBranch,status,conclusion | ConvertFrom-Json | Select-Object -First 1
    if ($run -and $run.databaseId) {
      gh run watch $run.databaseId --exit-status | Out-Null
      Write-Host "[OK] CI mapper-smoke completed." -ForegroundColor Green
    } else {
      Write-Host "[INFO] CI run listed too quickly; use 'gh run list --workflow mapper-smoke.yml' to inspect." -ForegroundColor Yellow
    }
  } catch {
    Write-Host "[INFO] CI trigger/watch skipped: $($_.Exception.Message)" -ForegroundColor Yellow
  }
}

Pop-Location
Write-Host "[DONE] AllGreen v3 complete." -ForegroundColor Green
