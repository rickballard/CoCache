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

$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$branch = "advice/ci-test-fix-$stamp"
git checkout -b $branch

$testsDir = 'tools/score_demo/tests'
New-Item -ItemType Directory -Force -Path $testsDir | Out-Null

# test_score.py
$test1 = @'
from tools.score_demo.score import score
from datetime import datetime, timezone

def mk(sev, imp, conf=1.0, ts=None):
    if ts is None:
        ts = datetime.now(timezone.utc).isoformat()
    return {"severity": sev, "impact": imp, "confidence": conf, "timestamp": ts}

def test_neg_dominance():
    # Small positive set plus one severe negative -> overall score should fall below neutral (50)
    evts = [mk(0.2, 1.0) for _ in range(2)] + [mk(0.9, -1.0, 0.8)]
    r = score(evts)
    assert r["status"] == "ok"
    assert r["score"] is not None and r["score"] < 50
'@
Set-Content -LiteralPath "$testsDir/test_score.py" -Value $test1 -Encoding UTF8

# test_scoring.py
$test2 = @'
from tools.score_demo.score import score, load_constants
from datetime import datetime, timezone

def mk(sev, imp, conf=1.0, ts=None):
    if ts is None:
        ts = datetime.now(timezone.utc).isoformat()
    return {"severity": sev, "impact": imp, "confidence": conf, "timestamp": ts}

def test_insufficient_when_no_signal():
    assert score([])["status"] == "insufficient_evidence"

def test_negative_dominance_affects_score():
    # A severe negative should pull the logistic score under 50 even with a few positives.
    evts = [mk(0.2, 1.0, 1.0) for _ in range(3)] + [mk(0.9, -1.0, 0.8)]
    r = score(evts)
    assert r["status"] == "ok" and r["score"] < 50

def test_constants_load():
    C = load_constants()
    assert "negative_dominance" in C and "decay_half_life_days" in C
'@
Set-Content -LiteralPath "$testsDir/test_scoring.py" -Value $test2 -Encoding UTF8

$changed = git status --porcelain
if ([string]::IsNullOrWhiteSpace($changed)) {
  Write-Host "[SKIP] No changes to commit" -ForegroundColor Yellow
  git checkout $Base | Out-Null
  git branch -D $branch | Out-Null
  Pop-Location; exit 0
}

git add --all
git commit -m "tests: stabilize dominance expectations (assert score<50 with severe negative; small positive set)" | Out-Null
git push -u origin $branch

# Open PR if missing
try {
  $existing = gh pr list --state open --base $Base --head $branch --json number | ConvertFrom-Json
} catch { $existing = @() }
if (-not $existing -or $existing.Count -eq 0) {
  gh pr create --title "tests: stabilize dominance expectations" `
               --body "Use small positive set; assert final score < 50 when severe negative present. Keeps negative_dominance sane." `
               --base $Base --head $branch | Out-Null
}

# Try merge
try {
  gh pr merge $branch --squash --delete-branch | Out-Null
  Write-Host "[OK] Tests merged to $Base." -ForegroundColor Green
} catch {
  Write-Host "[INFO] Merge blocked; PR left open." -ForegroundColor Yellow
  try { gh pr view $branch --web | Out-Null } catch {}
}
Pop-Location
