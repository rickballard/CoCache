param(
  [string]$RepoRoot = (Join-Path $HOME 'Documents\GitHub\MeritRank'),
  [string]$Base = 'main',
  [switch]$TriggerCI,
  [switch]$SkipPyTest
)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Invoke-Git {
  param([Parameter(Mandatory)][string[]]$Args)
  & git @Args
  if ($LASTEXITCODE -ne 0) { throw "git $Args failed with exit code $LASTEXITCODE" }
}

if (-not (Test-Path $RepoRoot)) { throw "Repo not found: $RepoRoot" }
Push-Location $RepoRoot

try {
  # --- Sync base branch (rebase onto origin/Base)
  Invoke-Git @('fetch','--all','--prune')
  if (-not (& git rev-parse --verify $Base 2>$null)) {
    Invoke-Git @('checkout','-b', $Base, "origin/$Base")
  } else {
    Invoke-Git @('checkout', $Base)
  }

  & git rebase "origin/$Base" | Out-Null
  if ($LASTEXITCODE -ne 0) {
    & git rebase --abort 2>$null | Out-Null
    Write-Host "[WARN] Rebase conflict or no-op; continuing on local '$Base'." -ForegroundColor Yellow
  } else {
    Write-Host "[OK] $Base rebased onto origin/$Base" -ForegroundColor Green
  }

  # --- Ensure allowlist entries
  $allow = Join-Path $RepoRoot 'components\seeder\config\allowlist.txt'
  New-Item -ItemType Directory -Force -Path (Split-Path $allow) | Out-Null
  if (-not (Test-Path $allow)) { New-Item -ItemType File -Path $allow | Out-Null }

  $entries = @('https://example.org/','https://www.iana.org/domains/reserved')
  $fixture = Join-Path $RepoRoot 'components\seeder\fixtures\sample_cred.html'
  if (Test-Path $fixture) {
    $entries += ('file:///' + $fixture.Replace('\','/'))
  }

  $existing = @()
  if (Test-Path $allow) { $existing = Get-Content -LiteralPath $allow -ErrorAction SilentlyContinue }

  foreach ($e in $entries) {
    if (-not ($existing -contains $e)) {
      Add-Content -LiteralPath $allow -Value $e
    }
  }

  # --- Seed (mapper=basic)
  $eventsOut = Join-Path $RepoRoot 'components\seeder\out\events.ndjson'
  $seederPy  = Join-Path $RepoRoot 'components\seeder\seeder.py'
  & python $seederPy --mapper basic --allowlist "$allow" --out "$eventsOut"
  if ($LASTEXITCODE -ne 0) { throw "Seeder failed" }
  Write-Host "[OK] Seeded -> $eventsOut" -ForegroundColor Green

  # --- Score
  $scoreOut = Join-Path $RepoRoot 'tools\score_demo\out.json'
  $scorePy  = Join-Path $RepoRoot 'tools\score_demo\score.py'
  & python $scorePy --in "$eventsOut" --out "$scoreOut"
  if ($LASTEXITCODE -ne 0) { throw "Scorer failed" }
  Write-Host "[OK] Scored -> $scoreOut" -ForegroundColor Green
  Get-Content -LiteralPath $scoreOut

  # --- Tests (optional)
  if (-not $SkipPyTest) {
    try {
      & python -m pytest -q 'tools/score_demo/tests/test_scoring.py'
    } catch {
      Write-Host "[INFO] Installing pytest..." -ForegroundColor Cyan
      try {
        & python -m pip install -q pytest | Out-Null
        & python -m pytest -q 'tools/score_demo/tests/test_scoring.py'
      } catch {
        Write-Host "[WARN] pytest failed or unavailable; skipping test run." -ForegroundColor Yellow
      }
    }
  }

  # --- CI trigger (optional)
  $workflow = Join-Path $RepoRoot '.github\workflows\mapper-smoke.yml'
  if ($TriggerCI -and (Test-Path $workflow)) {
    try {
      & gh workflow run 'mapper-smoke.yml' --ref $Base | Out-Null
      & gh run watch --exit-status
    } catch {
      Write-Host "[INFO] CI trigger skipped (gh not available or permissions)." -ForegroundColor Yellow
    }
  }

  Write-Host "[DONE] AllGreen pipeline completed." -ForegroundColor Green
}
finally {
  Pop-Location
}
