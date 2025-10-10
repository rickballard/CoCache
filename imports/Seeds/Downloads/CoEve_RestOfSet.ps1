param(
  [string]$RepoRoot = (Join-Path $HOME 'Documents\GitHub\MeritRank'),
  [string]$Base = 'main'
)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if (-not (Test-Path $RepoRoot)) { throw "Repo not found: $RepoRoot" }
Push-Location $RepoRoot
git fetch --all --prune
git checkout $Base
git pull --ff-only

$stamp  = (Get-Date -Format 'yyyyMMdd-HHmmss')
$branch = "advice/coeve-rest-$stamp"
git checkout -b $branch

# --- mkdirs
$dirs = @('schemas','api/openapi','components/seeder/config','components/seeder/out','.github/ISSUE_TEMPLATE','.github/workflows','tools/score-demo/tests')
$dirs | ForEach-Object { New-Item -ItemType Directory -Force -Path $_ | Out-Null }

# --- .gitignore
$gi = '.gitignore'
$adds = @('components/seeder/out/','__pycache__/','tools/score-demo/.venv/')
if (Test-Path $gi) {
  $cur = Get-Content $gi -ErrorAction SilentlyContinue
  foreach ($ln in $adds) { if ($cur -notcontains $ln) { Add-Content $gi $ln } }
} else { $adds | Set-Content $gi -Encoding UTF8 }

# --- Files (minimal content)
Set-Content schemas/identity.schema.json -Encoding UTF8 -Value @'
{ "$schema":"https://json-schema.org/draft/2020-12/schema",
  "title":"Identity","type":"object","required":["did","created_at","labels","status"],
  "properties":{"did":{"type":"string"},"created_at":{"type":"string","format":"date-time"},
  "labels":{"type":"array","items":{"type":"string"}},"status":{"type":"string"} } }
'@
Set-Content schemas/event.schema.json -Encoding UTF8 -Value @'
{ "$schema":"https://json-schema.org/draft/2020-12/schema",
  "title":"Event","type":"object","required":["id","actor_did","type","timestamp","confidence"],
  "properties":{"id":{"type":"string"},"actor_did":{"type":["string","null"]},
  "type":{"type":"string"},"verb":{"type":"string"},"timestamp":{"type":"string","format":"date-time"},
  "confidence":{"type":"number"},"severity":{"type":"number"},"impact":{"type":"number"},
  "evidence_uri":{"type":"string"},"content_sha256":{"type":"string"} } }
'@
Set-Content api/openapi/registry.yml -Encoding UTF8 -Value @'
openapi: 3.0.3
info: { title: MeritRank Registry API, version: 0.1.0 }
paths:
  /api/identities/{did}:
    get:
      parameters: [{ in: path, name: did, required: true, schema: { type: string } }]
      responses: { "200": { description: OK } }
  /api/events:
    post:
      requestBody: { required: true, content: { application/json: { } } }
      responses: { "202": { description: Accepted } }
  /api/scores/{did}:
    get:
      parameters: [{ in: path, name: did, required: true, schema: { type: string } }]
      responses: { "200": { description: OK } }
'@

# Seeder stubs
Set-Content components/seeder/config/allowlist.txt -Encoding UTF8 -Value @'
# One URL per line
https://example.com/
'@
Set-Content components/seeder/seeder.ps1 -Encoding UTF8 -Value @'
param(
  [string]$AllowList = "components/seeder/config/allowlist.txt",
  [string]$Out = "components/seeder/out/events.ndjson"
)
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
if (-not (Test-Path $AllowList)) { throw "AllowList not found: $AllowList" }
$urls = Get-Content $AllowList | Where-Object { $_ -and -not $_.StartsWith("#") } | ForEach-Object { $_.Trim() } | Where-Object { $_ }
New-Item -ItemType File -Path $Out -Force | Out-Null
$sha = [System.Security.Cryptography.SHA256]::Create()
Add-Type -AssemblyName System.Net.Http
$http = [System.Net.Http.HttpClient]::new()
foreach ($u in $urls) {
  try {
    $b = $http.GetByteArrayAsync($u).GetAwaiter().GetResult()
    $h = ($sha.ComputeHash($b) | ForEach-Object { $_.ToString("x2") }) -join ""
    $evt = @{ id="ext_"+[guid]::NewGuid().ToString("n"); actor_did=$null; type="external"; verb="observe"; confidence=0.3; timestamp=(Get-Date).ToUniversalTime().ToString("o"); evidence_uri=$u; content_sha256=$h }
    ($evt | ConvertTo-Json -Compress) | Add-Content $Out
  } catch {}
}
Write-Host "[DONE] Seeded -> $Out"
'@
Set-Content components/seeder/seeder.py -Encoding UTF8 -Value @'
#!/usr/bin/env python3
import argparse, json, hashlib, urllib.request
from datetime import datetime, timezone
ap=argparse.ArgumentParser(); ap.add_argument("--allowlist",default="components/seeder/config/allowlist.txt"); ap.add_argument("--out",default="components/seeder/out/events.ndjson"); a=ap.parse_args()
urls=[l.strip() for l in open(a.allowlist,encoding="utf-8") if l.strip() and not l.startswith("#")]
with open(a.out,"w",encoding="utf-8") as out:
  for u in urls:
    try:
      data=urllib.request.urlopen(urllib.request.Request(u,headers={"User-Agent":"CoEveSeeder/0.0.1"}),timeout=20).read()
      h=hashlib.sha256(data).hexdigest()
      evt={"id":"ext_"+h[:16],"actor_did":None,"type":"external","verb":"observe","confidence":0.3,"timestamp":datetime.now(timezone.utc).isoformat(),"evidence_uri":u,"content_sha256":h}
      out.write(json.dumps(evt,separators=(",",":"))+"\n")
    except Exception:
      pass
print("[DONE]",a.out)
'@

# Score demo
Set-Content tools/score-demo/README.md -Encoding UTF8 -Value @'
# Score Demo
python tools/score-demo/score.py --in components/seeder/out/events.ndjson --out tools/score-demo/out.json
'@
Set-Content tools/score-demo/score.py -Encoding UTF8 -Value @'
#!/usr/bin/env python3
import argparse, json, math
from datetime import datetime, timezone
def parse_ts(s): return datetime.fromisoformat(s.replace("Z","+00:00")).astimezone(timezone.utc)
def decay(ts,half=90.0): 
  dt=(datetime.now(timezone.utc)-ts).total_seconds()/86400.0
  return 0.5**(max(0.0,dt)/half)
def score(events):
  pos=neg=0.0
  for e in events:
    ts=parse_ts(e.get("timestamp")) if e.get("timestamp") else datetime.now(timezone.utc)
    w=decay(ts)*float(e.get("confidence",0.5))
    imp=float(e.get("impact",0.0)); sev=float(e.get("severity",0.0))
    if sev>=0.7 and imp<0: neg+=4.0*abs(imp)*w
    else: pos+=imp*w
  s=max(0.0,100.0*(1/(1+math.exp(-(pos-neg)))))
  return {"score":s,"components":{"pos":pos,"neg":neg}}
def main():
  ap=argparse.ArgumentParser(); ap.add_argument("--in",dest="inp",required=True); ap.add_argument("--out",dest="out",required=True); a=ap.parse_args()
  evts=[json.loads(l) for l in open(a.inp,encoding="utf-8") if l.strip()]
  json.dump(score(evts), open(a.out,"w",encoding="utf-8"), indent=2); print("[OK]",a.out)
if __name__=="__main__": main()
'@
Set-Content tools/score-demo/tests/test_score.py -Encoding UTF8 -Value @'
from tools.score_demo.score import score
from datetime import datetime, timezone
def mk(sev,imp,conf=1.0): return {"severity":sev,"impact":imp,"confidence":conf,"timestamp":datetime.now(timezone.utc).isoformat()}
def test_neg_dominance():
  evts=[mk(0.2,1.0) for _ in range(10)] + [mk(0.9,-1.0)]
  r=score(evts); assert r["components"]["neg"]>r["components"]["pos"]
'@

# Templates + CI
Set-Content .github/ISSUE_TEMPLATE/bug.md -Encoding UTF8 -Value @'
name: Bug report
labels: bug
body:
  - type: textarea
    attributes: { label: What happened? }
  - type: textarea
    attributes: { label: Repro steps }
'@
Set-Content .github/ISSUE_TEMPLATE/feature.md -Encoding UTF8 -Value @'
name: Feature request
labels: enhancement
body:
  - type: textarea
    attributes: { label: Problem / context }
  - type: textarea
    attributes: { label: Proposal }
'@
Set-Content .github/PULL_REQUEST_TEMPLATE.md -Encoding UTF8 -Value @'
## Summary
-

## Checklist
- [ ] Docs updated if needed
- [ ] Security impact considered
'@
Set-Content .github/workflows/ci.yml -Encoding UTF8 -Value @'
name: CI
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with: { python-version: "3.11" }
      - run: |
          python -m pip install -U pip pytest
          pytest -q
'@

# Commit + PR + attempt squash-merge
git add --all
git commit -m "AdviceBomb: CoEve rest-of-set (schemas, openapi, seeder, score-demo, templates, CI)" 2>$null | Out-Null
git push -u origin $branch

$prTitle = "AdviceBomb: CoEve — rest-of-set (schemas/openapi/seeder/score-demo/templates/CI)"
$prBody  = "Adds schemas, OpenAPI stub, seeder stubs (PS+Py), score demo, templates, CI."
$open = gh pr list --state open --base $Base --head $branch --json number | ConvertFrom-Json
if (-not $open -or $open.Count -eq 0) { gh pr create --title $prTitle --body $prBody --base $Base --head $branch | Out-Null }

try { gh pr merge $branch --squash --delete-branch | Out-Null; Write-Host "[OK] Merged to $Base." -ForegroundColor Green }
catch { Write-Host "[INFO] Merge blocked; PR left open." -ForegroundColor Yellow; gh pr view $branch --web | Out-Null }

Pop-Location
Write-Host "[DONE] Rest-of-set shipped." -ForegroundColor Green
