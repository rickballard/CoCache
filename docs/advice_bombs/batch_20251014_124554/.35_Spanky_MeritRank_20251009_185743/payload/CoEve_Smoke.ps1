param([string]$RepoRoot = (Join-Path $HOME 'Documents\GitHub\MeritRank'))
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
$here = Resolve-Path $RepoRoot
$allow = Join-Path $here 'components\seeder\config\allowlist.txt'
$out   = Join-Path $here 'components\seeder\out\events.ndjson'
$score = Join-Path $here 'tools\score_demo\out.json'
if (-not (Test-Path $allow)) {
  New-Item -ItemType Directory -Force -Path (Split-Path $allow) | Out-Null
  "https://example.org/" | Set-Content -Encoding UTF8 $allow
}
Push-Location $here
python .\components\seeder\seeder.py --mapper basic --allowlist "$allow" --out "$out"
Pop-Location
python "$RepoRoot\tools\score_demo\score.py" --in "$out" --out "$score"
Get-Content "$score"

