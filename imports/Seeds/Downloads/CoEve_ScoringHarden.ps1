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

$stamp  = (Get-Date -Format 'yyyyMMdd-HHmmss')
$branch = "advice/coeve-scoring-harden-$stamp"
git checkout -b $branch

# Ensure config dir and constants.json
$cfgDir = 'config/scoring'
New-Item -ItemType Directory -Force -Path $cfgDir | Out-Null
$constants = @"
{
  "negative_dominance": 4.0,
  "decay_half_life_days": 90,
  "min_events_for_score": 1
}
"@
Set-Content -Encoding UTF8 -LiteralPath "$cfgDir/constants.json" -Value $constants

# README (idempotent)
$readme = 'tools/score_demo/README.md'
New-Item -ItemType Directory -Force -Path (Split-Path $readme) | Out-Null
$readmeBody = @"
# Score Demo
python tools/score_demo/score.py --in components/seeder/out/events.ndjson --out tools/score_demo/out.json
"@
Set-Content -Encoding UTF8 -LiteralPath $readme -Value $readmeBody

# scorer loads constants
$scorePy = 'tools/score_demo/score.py'
$pyBody = @"
#!/usr/bin/env python3
import argparse, json, math, os
from datetime import datetime, timezone

DEFAULTS = {"negative_dominance": 4.0, "decay_half_life_days": 90, "min_events_for_score": 1}

def load_constants():
    root = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
    p = os.path.join(root, "config", "scoring", "constants.json")
    try:
        return {**DEFAULTS, **json.load(open(p, "r", encoding="utf-8"))}
    except Exception:
        return DEFAULTS

def parse_ts(s):
    return datetime.fromisoformat(s.replace("Z","+00:00")).astimezone(timezone.utc)

def decay(ts, half_days):
    dt = (datetime.now(timezone.utc)-ts).total_seconds()/86400.0
    return 0.5**(max(0.0, dt)/float(half_days))

def score(events):
    C = load_constants()
    pos = 0.0; neg = 0.0
    n   = len(events)

    for e in events:
        ts  = parse_ts(e.get("timestamp")) if e.get("timestamp") else datetime.now(timezone.utc)
        w   = decay(ts, C["decay_half_life_days"]) * float(e.get("confidence", 0.5))
        imp = float(e.get("impact", 0.0))
        sev = float(e.get("severity", 0.0))
        if sev >= 0.7 and imp < 0:
            neg += C["negative_dominance"] * abs(imp) * w
        else:
            pos += imp * w

    if n < int(C["min_events_for_score"]) or (pos == 0.0 and neg == 0.0):
        return {"score": None, "status": "insufficient_evidence", "n_events": n}

    s = max(0.0, 100.0 * (1/(1+math.exp(-(pos - neg)))))
    return {"score": s, "status": "ok", "components": {"pos": pos, "neg": neg}, "n_events": n}

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--in",  dest="inp",  required=True)
    ap.add_argument("--out", dest="out",  required=True)
    a = ap.parse_args()
    evts = [json.loads(l) for l in open(a.inp, encoding="utf-8") if l.strip()]
    json.dump(score(evts), open(a.out, "w", encoding="utf-8"), indent=2)
    print("[OK]", a.out)

if __name__ == "__main__":
    main()
"@
Set-Content -Encoding UTF8 -LiteralPath $scorePy -Value $pyBody

# Minimal tests
$tests = 'tools/score_demo/tests'
New-Item -ItemType Directory -Force -Path $tests | Out-Null
$testBody = @"
from tools.score_demo.score import score, load_constants

def mk(sev, imp, conf=1.0, ts=None):
    from datetime import datetime, timezone
    if ts is None: ts = datetime.now(timezone.utc).isoformat()
    return {"severity":sev,"impact":imp,"confidence":conf,"timestamp":ts}

def test_insufficient_when_no_signal():
    assert score([])["status"] == "insufficient_evidence"

def test_negative_dominance_overrides_positives():
    evts=[mk(0.2,1.0,1.0) for _ in range(10)] + [mk(0.9,-1.0,0.8)]
    r=score(evts)
    assert r["status"]=="ok" and r["components"]["neg"]>r["components"]["pos"]

def test_constants_load():
    C = load_constants()
    assert "negative_dominance" in C and "decay_half_life_days" in C
"@
Set-Content -Encoding UTF8 -LiteralPath "$tests/test_scoring.py" -Value $testBody

# Commit/PR/merge only if real changes
$changed = git status --porcelain
if ([string]::IsNullOrWhiteSpace($changed)) {
  Write-Host "[SKIP] No changes to commit" -ForegroundColor Yellow
  git checkout $Base | Out-Null
  git branch -D $branch | Out-Null
  Pop-Location; exit
}
git add --all
git commit -m "Feat: externalize scoring constants; tests for dominance/insufficient" | Out-Null
git push -u origin $branch

$pr = gh pr list --state open --base $Base --head $branch --json number | ConvertFrom-Json
if (-not $pr -or $pr.Count -eq 0) {
  gh pr create --title "Feat: externalize scoring constants + tests" `
               --body "Adds config/scoring/constants.json; scorer now loads it; adds pytest coverage." `
               --base $Base --head $branch | Out-Null
}
try { gh pr merge $branch --squash --delete-branch | Out-Null; Write-Host "[OK] Merged" -ForegroundColor Green }
catch { Write-Host "[INFO] Merge blocked; PR open." -ForegroundColor Yellow; try { gh pr view $branch --web | Out-Null } catch {} }
Pop-Location
