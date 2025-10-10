param(
  [string]$RepoRoot = (Join-Path $HOME 'Documents\GitHub\MeritRank'),
  [string]$Base = 'main'
)
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'

function New-BranchName([string]$prefix) {
  return "$prefix-" + (Get-Date -Format 'yyyyMMdd-HHmmss')
}

if (-not (Test-Path $RepoRoot)) { throw "Repo not found: $RepoRoot" }
Push-Location $RepoRoot
git fetch --all --prune | Out-Null
git checkout $Base        | Out-Null
git pull --ff-only        | Out-Null

$branch = New-BranchName "advice/coeve-mapper-tests"
git checkout -b $branch   | Out-Null

# Ensure tests folder
$testsDir = 'tools/score_demo/tests'
New-Item -ItemType Directory -Force -Path $testsDir | Out-Null

$testPath = Join-Path $testsDir 'test_mapper_basic.py'
$testBody = @"
import json, os, subprocess, sys, pathlib

ROOT = pathlib.Path(__file__).resolve().parents[3]  # repo root
SEEDER = ROOT / 'components' / 'seeder' / 'seeder.py'
SCORER = ROOT / 'tools' / 'score_demo' / 'score.py'
ALLOW  = ROOT / 'components' / 'seeder' / 'config' / 'allowlist.txt'
OUT    = ROOT / 'components' / 'seeder' / 'out' / 'events.ndjson'
SCORE  = ROOT / 'tools' / 'score_demo' / 'out.json'
FIX    = ROOT / 'components' / 'seeder' / 'fixtures' / 'sample_cred.html'

ALLOW.parent.mkdir(parents=True, exist_ok=True)
OUT.parent.mkdir(parents=True, exist_ok=True)

uri = FIX.resolve().as_uri()
existing = ALLOW.read_text(encoding='utf-8').splitlines() if ALLOW.exists() else []
if uri not in existing:
    with open(ALLOW, 'a', encoding='utf-8') as f:
        f.write(uri + '\n')

subprocess.run([sys.executable, str(SEEDER), '--mapper', 'basic',
                '--allowlist', str(ALLOW), '--out', str(OUT)],
               check=True)
subprocess.run([sys.executable, str(SCORER), '--in', str(OUT), '--out', str(SCORE)], check=True)

res = json.load(open(SCORE, 'r', encoding='utf-8'))
assert res['status'] == 'ok', res
assert float(res.get('score') or 0) >= 50.0, res
"@

Set-Content -LiteralPath $testPath -Encoding UTF8 -Value $testBody

# Commit/push/PR
git add --all
git commit -m "test: mapper basic smoke (seed + score >= 50)" | Out-Null
git push -u origin $branch | Out-Null

# Open PR if needed
$existing = gh pr list --state open --base $Base --head $branch --json number | ConvertFrom-Json
if (-not $existing -or $existing.Count -eq 0) {
  gh pr create --title "test: mapper basic smoke (seed + score ≥ 50)" `
               --body  "Adds pytest covering seeder.py --mapper basic using local sample cred page; asserts status=ok and score≥50." `
               --base $Base --head $branch | Out-Null
}
try {
  gh pr merge $branch --squash --delete-branch | Out-Null
  Write-Host "[OK] Tests merged to $Base." -ForegroundColor Green
} catch {
  Write-Host "[INFO] Merge blocked; PR left open." -ForegroundColor Yellow
}

Pop-Location
