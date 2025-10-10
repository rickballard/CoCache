param(
  [string]$RepoRoot = (Join-Path $HOME 'Documents\GitHub\MeritRank'),
  [string]$Base = 'main',
  [switch]$TriggerCI
)
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'

if (-not (Test-Path $RepoRoot)) { throw "Repo not found: $RepoRoot" }
Push-Location $RepoRoot

# Sync base
git fetch --all --prune
if (-not (git rev-parse --verify $Base 2>$null)) { git checkout -b $Base origin/$Base } else { git checkout $Base }
try {
  git -c rebase.autoStash=true rebase origin/$Base
  Write-Host "[OK] $Base rebased onto origin/$Base" -ForegroundColor Green
} catch {
  git rebase --abort 2>$null
  Write-Host "[WARN] Rebase conflict; continuing with local $Base. (Run CoEve_SyncMain to resolve.)" -ForegroundColor Yellow
}

$allow = Join-Path $RepoRoot 'components\seeder\config\allowlist.txt'
$fixture = Join-Path $RepoRoot 'components\seeder\fixtures\sample_cred.html'
$uri = 'file:///' + $fixture.Replace('\','/')

# Ensure allowlist
New-Item -ItemType Directory -Force -Path (Split-Path $allow) | Out-Null
$lines = @()
if (Test-Path $allow) { $lines = Get-Content -LiteralPath $allow -Encoding UTF8 }
if ($lines -notcontains 'https://example.org/') { Add-Content -LiteralPath $allow -Value 'https://example.org/' }
if ($lines -notcontains 'https://www.iana.org/domains/reserved') { Add-Content -LiteralPath $allow -Value 'https://www.iana.org/domains/reserved' }
if ($lines -notcontains $uri) { Add-Content -LiteralPath $allow -Value $uri }

# Seed (mapper=basic)
$out = Join-Path $RepoRoot 'components\seeder\out\events.ndjson'
python "$RepoRoot\components\seeder\seeder.py" --mapper basic --allowlist "$allow" --out "$out"
if (-not (Test-Path $out)) { throw "Seeder did not produce $out" }
Write-Host "[OK] Seeded -> $out" -ForegroundColor Green

# Score
$score = Join-Path $RepoRoot 'tools\score_demo\out.json'
python "$RepoRoot\tools\score_demo\score.py" --in "$out" --out "$score"
if (-not (Test-Path $score)) { throw "Score did not produce $score" }
Write-Host "[OK] Scored -> $score" -ForegroundColor Green
Get-Content -LiteralPath $score

# Dev venv + pytest
$venv = Join-Path $RepoRoot '.venv'
if (-not (Test-Path $venv)) {
  python -m venv "$venv"
}
$pyExe = Join-Path $venv 'Scripts\python.exe'
& $pyExe -m pip install -U pip pytest | Out-Null

# Run tests
& $pyExe -m pytest -q
$code = $LASTEXITCODE
if ($code -eq 0) {
  Write-Host "[OK] pytest passed." -ForegroundColor Green
} else {
  Write-Host "[FAIL] pytest exit code $code" -ForegroundColor Red
}

# Optional CI trigger
if ($TriggerCI) {
  try {
    gh workflow run mapper-smoke.yml --ref $Base | Out-Null
    gh run watch --exit-status
    Write-Host "[OK] CI mapper-smoke completed." -ForegroundColor Green
  } catch {
    Write-Host "[INFO] CI trigger/watch not available here." -ForegroundColor Yellow
  }
}

Pop-Location
Write-Host "[DONE] AllGreen v4 complete." -ForegroundColor Green
