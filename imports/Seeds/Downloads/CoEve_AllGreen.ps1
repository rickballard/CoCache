param(
  [string]$RepoRoot = (Join-Path $HOME 'Documents\GitHub\MeritRank'),
  [string]$Base = 'main'
)
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'

if (-not (Test-Path $RepoRoot)) { throw "Repo not found: $RepoRoot" }

# 1) Sync main (rebase onto origin)
Push-Location $RepoRoot
git fetch --all --prune | Out-Null
git checkout $Base | Out-Null
try {
  git rebase origin/$Base | Out-Null
  Write-Host "[OK] $Base up to date." -ForegroundColor Green
} catch {
  git rebase --abort 2>$null
  Write-Host "[WARN] Rebase conflict; leaving as-is." -ForegroundColor Yellow
}

# 2) Ensure allowlist contains local sample + example domains
$allow = Join-Path $RepoRoot 'components\seeder\config\allowlist.txt'
$allowDir = Split-Path -Parent $allow
New-Item -ItemType Directory -Force -Path $allowDir | Out-Null

$fixture = Join-Path $RepoRoot 'components\seeder\fixtures\sample_cred.html'
$uri = (Get-Item $fixture).FullName.Replace('\','/')
$uri = 'file:///' + $uri
$lines = @()
if (Test-Path $allow) { $lines = Get-Content $allow -Raw -ErrorAction SilentlyContinue -Encoding UTF8 -ea SilentlyContinue -TotalCount 99999 -ReadCount 0 -Delimiter "`n" -Tail 0 | % { $_ } }
$need = @($uri, 'https://example.org/','https://www.iana.org/domains/reserved') | Where-Object { $_ -and ($lines -notcontains $_) }
if ($need.Count -gt 0) { Add-Content -LiteralPath $allow -Value ($need -join "`n") }

# 3) Seed (mapper=basic) and score
python "$RepoRoot\components\seeder\seeder.py" --mapper basic `
  --allowlist "$allow" `
  --out "$RepoRoot\components\seeder\out\events.ndjson"

python "$RepoRoot\tools\score_demo\score.py" `
  --in "$RepoRoot\components\seeder\out\events.ndjson" `
  --out "$RepoRoot\tools\score_demo\out.json"

Write-Host (Get-Content "$RepoRoot\tools\score_demo\out.json" -Raw)

# 4) Run pytest locally if available (install if missing)
function Ensure-PyTest {
  if (Get-Command pytest -ErrorAction SilentlyContinue) { return }
  try { python -m pip install --upgrade pip -q } catch {}
  python -m pip install pytest -q
}
try {
  Ensure-PyTest
  Push-Location $RepoRoot
  pytest -q
  Pop-Location
  Write-Host "[OK] Pytest passed." -ForegroundColor Green
} catch {
  Write-Host "[WARN] Pytest failed or not available." -ForegroundColor Yellow
}

# 5) Kick CI smoke if gh exists
if (Get-Command gh -ErrorAction SilentlyContinue) {
  try {
    gh workflow run mapper-smoke.yml --ref $Base | Out-Null
    Write-Host "[OK] Triggered mapper-smoke CI." -ForegroundColor Green
  } catch {
    Write-Host "[INFO] Could not trigger CI (gh auth?)." -ForegroundColor Yellow
  }
}

Pop-Location
