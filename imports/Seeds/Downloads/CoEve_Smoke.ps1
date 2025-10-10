param(
  [string]$RepoRoot = (Join-Path $HOME 'Documents\GitHub\MeritRank')
)
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
$here = Resolve-Path $RepoRoot

$allow = Join-Path $here 'components\seeder\config\allowlist.txt'
$out   = Join-Path $here 'components\seeder\out\events.ndjson'
$score = Join-Path $here 'tools\score_demo\out.json'

# Ensure allowlist
if (-not (Test-Path $allow)) {
  New-Item -ItemType Directory -Force -Path (Split-Path $allow) | Out-Null
  "https://example.org/" | Set-Content -Encoding UTF8 $allow
  Write-Host "[INIT] Wrote $allow" -ForegroundColor Cyan
}

# Run polite seeder (Python)
Push-Location $here
python .\components\seeder\seeder.py --allowlist "$allow" --out "$out"
Pop-Location

# Score it
python "$RepoRoot\tools\score_demo\score.py" --in "$out" --out "$score"
Get-Content "$score"
