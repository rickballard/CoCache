param(
  [string]$RepoRoot = (Join-Path $HOME 'Documents\GitHub\MeritRank'),
  [string]$Base = 'main'
)
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'

function Write-Step($msg,[ConsoleColor]$c=[ConsoleColor]::Cyan){ $fc=$Host.UI.RawUI.ForegroundColor; $Host.UI.RawUI.ForegroundColor=$c; Write-Host $msg; $Host.UI.RawUI.ForegroundColor=$fc }

if (-not (Test-Path $RepoRoot)) { throw "Repo not found: $RepoRoot" }
Push-Location $RepoRoot
git fetch --all --prune | Out-Null

# Ensure base branch
if (-not (git rev-parse --verify $Base 2>$null)) {
  git checkout -b $Base "origin/$Base" | Out-Null
} else {
  git checkout $Base | Out-Null
}
# Try to rebase for a clean PR
try { git rebase "origin/$Base" | Out-Null } catch { git rebase --abort 2>$null }

$stamp  = (Get-Date -Format 'yyyyMMdd-HHmmss')
$branch = "advice/coeve-mapper-pr-$stamp"
git checkout -b $branch | Out-Null

# --- Files -----------------------------------------------------------------
# Fixture HTML with DID + PGP + C2PA markers
$fixDir = 'components/seeder/fixtures'
New-Item -ItemType Directory -Force -Path $fixDir | Out-Null
$fixture = @"
<!doctype html>
<html><head>
<meta charset="utf-8"/>
<title>CoEve Cred Sample</title>
<meta name="c2pa.version" content="1.3.0"/>
</head><body>
<pre>DID: did:key:z6MkjThh9P77credSampleDemoOnly</pre>
<pre>-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: OpenPGP
Comment: demo only, not a real key

xjMEYCred
=demo
-----END PGP PUBLIC KEY BLOCK-----</pre>
</body></html>
"@
Set-Content -Encoding UTF8 -LiteralPath (Join-Path $fixDir 'sample_cred.html') -Value $fixture

# Domain hints (baseline signal for curated hosts)
$cfgDir = 'components/seeder/config'
New-Item -ItemType Directory -Force -Path $cfgDir | Out-Null
$hintsPath = Join-Path $cfgDir 'domain_hints.json'
if (-not (Test-Path $hintsPath)) {
  $hints = @'
{
  "example.org": { "confidence": 0.5, "impact": 0.05, "severity": 0.2 },
  "www.iana.org": { "confidence": 0.4, "impact": 0.03, "severity": 0.15 }
}
'@
  Set-Content -Encoding UTF8 -LiteralPath $hintsPath -Value $hints
}

# README additions
$seederReadme = 'components/seeder/README.md'
if (-not (Test-Path $seederReadme)) { New-Item -ItemType File -Force -Path $seederReadme | Out-Null }
$append = @"
## Mapper (basic)

The `--mapper basic` pass assigns small, positive signal when it detects **cred markers** in fetched content:

- `DID:` strings (e.g., \`did:key:\`)
- OpenPGP block headers (\`-----BEGIN PGP PUBLIC KEY BLOCK-----\`)
- C2PA presence via \`<meta name="c2pa.version">\`
- Optional domain baselines from \`components/seeder/config/domain_hints.json\` with fields: \`confidence\`, \`impact\`, \`severity\`

### Local smoke
```powershell
$here   = Resolve-Path .
$allow  = Join-Path $here 'components\seeder\config\allowlist.txt'
$sample = Join-Path $here 'components\seeder\fixtures\sample_cred.html'
"file:///$((Resolve-Path $sample).Path -replace '\\','/') " | Add-Content $allow
python components/seeder/seeder.py --mapper basic --allowlist "$allow" --out components/seeder/out/events.ndjson
python tools/score_demo/score.py --in components/seeder/out/events.ndjson --out tools/score_demo/out.json
type tools/score_demo/out.json
```
"@
Add-Content -Encoding UTF8 -LiteralPath $seederReadme -Value $append

# Mapper spec stub
$specDir = 'docs/specs'
New-Item -ItemType Directory -Force -Path $specDir | Out-Null
$mapperSpec = @"
# Mapper (basic) — detection and mapping (stub)

**Signals:**
- DID presence → small +impact, low severity
- OpenPGP key presence → small +impact, low severity
- C2PA meta presence → small +impact, low severity
- Domain baseline from \`domain_hints.json\` merged into event if host matches

**Output event fields:** \`impact\`, \`severity\`, \`confidence\` plus provenance (\`evidence_uri\`, \`content_sha256\`).

**Notes:** No PII extraction. This pass is deliberately conservative.
"@
Set-Content -Encoding UTF8 -LiteralPath (Join-Path $specDir 'mapper.md') -Value $mapperSpec

# CI workflow: deterministic mapper smoke using file:// fixture
$wfDir = '.github/workflows'
New-Item -ItemType Directory -Force -Path $wfDir | Out-Null
$wf = @"
name: mapper-smoke
on:
  workflow_dispatch:
  schedule:
    - cron: '13 3 * * 1'  # weekly sanity check
jobs:
  smoke:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with: { python-version: '3.x' }
      - name: Build file URI
        id: uri
        run: |
          fp=\$GITHUB_WORKSPACE/components/seeder/fixtures/sample_cred.html
          echo "uri=file://\$fp" >> \$GITHUB_OUTPUT
      - name: Allowlist
        run: |
          mkdir -p components/seeder/config
          echo "${{ steps.uri.outputs.uri }}" > components/seeder/config/allowlist.txt
      - name: Seed (mapper basic)
        run: python components/seeder/seeder.py --mapper basic --allowlist components/seeder/config/allowlist.txt --out components/seeder/out/events.ndjson
      - name: Score
        run: python tools/score_demo/score.py --in components/seeder/out/events.ndjson --out tools/score_demo/out.json
      - name: Assert OK
        run: |
          python - <<'PY'
          import json,sys
          d=json.load(open('tools/score_demo/out.json'))
          print(d)
          assert d.get('status')=='ok', d
          PY
"@
Set-Content -Encoding UTF8 -LiteralPath (Join-Path $wfDir 'mapper-smoke.yml') -Value $wf

# Stage/commit/PR
git add --all
$changed = git status --porcelain
if ([string]::IsNullOrWhiteSpace($changed)) {
  Write-Step "[SKIP] No changes to commit." 'Yellow'
  git checkout $Base | Out-Null
  git branch -D $branch | Out-Null
  Pop-Location
  exit 0
}

git commit -m "feat: mapper fixtures/spec, domain hints, and CI smoke" | Out-Null
git push -u origin $branch | Out-Null

# PR + attempt squash merge
$pr = gh pr list --state open --base $Base --head $branch --json number | ConvertFrom-Json
if (-not $pr -or $pr.Count -eq 0) {
  gh pr create --title "feat: mapper fixtures/spec + CI smoke" `
               --body "Adds local cred fixture, domain hints, seeder README notes, mapper spec stub, and a deterministic mapper-smoke workflow." `
               --base $Base --head $branch | Out-Null
}
try {
  gh pr merge $branch --squash --delete-branch | Out-Null
  Write-Step "[OK] Merged to $Base." 'Green'
} catch {
  Write-Step "[INFO] Merge blocked; PR left open." 'Yellow'
  try { gh pr view $branch --web | Out-Null } catch {}
}

Pop-Location
