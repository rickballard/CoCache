param(
  [string]$RepoRoot = (Join-Path $HOME 'Documents\GitHub\MeritRank'),
  [string]$Base = 'main'
)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function _msg($t,$c='Gray'){ Write-Host $t -ForegroundColor $c }

if (-not (Test-Path $RepoRoot)) { throw "Repo not found: $RepoRoot" }

Push-Location $RepoRoot
git fetch --all --prune | Out-Null

# Ensure local base exists and is checked out
try {
  git rev-parse --verify $Base 2>$null | Out-Null
  git checkout $Base | Out-Null
} catch {
  git checkout -b $Base origin/$Base | Out-Null
}

git pull --ff-only | Out-Null

$stamp  = (Get-Date -Format 'yyyyMMdd-HHmmss')
$branch = "advice/coeve-mapper-basic-$stamp"
git checkout -b $branch | Out-Null

# --- Paths
$fixturesDir = 'components/seeder/fixtures'
$confDir     = 'components/seeder/config'
$readmePath  = 'components/seeder/README.md'
$hintsPath   = Join-Path $confDir 'domain_hints.json'
$sampleHtml  = Join-Path $fixturesDir 'sample_cred.html'
$mapperSpec  = 'docs/specs/mapper.md'
$wfDir       = '.github/workflows'
$wfPath      = Join-Path $wfDir 'mapper-smoke.yml'

# --- Ensure folders
$null = New-Item -ItemType Directory -Force -Path $fixturesDir, $confDir, (Split-Path $mapperSpec), $wfDir

# --- Sample credential-ish page (for local file:// smoke)
@'
<!doctype html>
<html><head>
  <meta charset="utf-8"/>
  <title>CoEve Cred Sample</title>
  <!-- Basic discoverable hints for the mapper -->
  <meta name="coeve:did" content="did:key:z6MkfSampleAliceKey1234567890"/>
  <meta name="coeve:pgp" content="ABCD 1234 EFGH 5678 IJKL 9ABC DEF0 1234 5678 9ABC"/>
  <meta name="coeve:c2pa" content="present"/>
</head>
<body>
  <h1>Credential Signals (Sample)</h1>
  <p>This page intentionally carries simple, discoverable markers for the basic mapper.</p>
</body></html>
'@ | Set-Content -LiteralPath $sampleHtml -Encoding UTF8

# --- Domain hints (very lightweight exemplar)
@'
{
  "example.org": { "org": "Example Org", "weight": 0.2 },
  "iana.org":    { "org": "IANA",        "weight": 0.4 }
}
'@ | Set-Content -LiteralPath $hintsPath -Encoding UTF8

# --- README section (append or create)
$mapperReadme = @'
## Mapper (basic)

The basic mapper extracts simple credibility signals (DID/PGP/C2PA hints) from allowed pages.

Local smoke (uses `file://` URI of a repo fixture):

```powershell
# seed against local fixture
python components/seeder/seeder.py --mapper basic `
  --allowlist components/seeder/config/allowlist.txt `
  --out       components/seeder/out/events.ndjson

# score
python tools/score_demo/score.py `
  --in  components/seeder/out/events.ndjson `
  --out tools/score_demo/out.json
type tools/score_demo/out.json
```

**Notes**
- `robots.txt` is respected for http(s). Local `file://` URIs skip robots.
- No PII is stored on-chain; this mapper only emits external observation events.
'@

if (Test-Path $readmePath) {
  Add-Content -LiteralPath $readmePath -Value "`n`n$mapperReadme"
} else {
  "# Seeder" | Set-Content -LiteralPath $readmePath -Encoding UTF8
  Add-Content -LiteralPath $readmePath -Value "`n$mapperReadme"
}

# --- Spec stub
@'
# Mapper Spec (v0)

**Scope (v0):**
- Parse allowed pages for light-weight markers:
  - `<meta name="coeve:did" content="...">`
  - `<meta name="coeve:pgp" content="...">`
  - `<meta name="coeve:c2pa" content="present">`
- Emit external observation events with provenance and confidence.
- Apply optional domain hints (`components/seeder/config/domain_hints.json`) to weight trust.
- No forced entity merges; only candidate evidence.

**Out of scope (v0):**
- Full ER (entity resolution), cryptographic verification, or KERI rotations.
- Any scraping behind auth or ignoring robots.
'@ | Set-Content -LiteralPath $mapperSpec -Encoding UTF8

# --- CI workflow (single-quoted here-string preserves ${{ }} intact)
@'
name: mapper-smoke
on:
  workflow_dispatch:
  schedule:
    - cron: "21 7 * * 1"
jobs:
  smoke:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: "3.x"
      - name: Prepare local sample URI
        id: uri
        run: |
          echo "uri=file://$GITHUB_WORKSPACE/components/seeder/fixtures/sample_cred.html" >> $GITHUB_OUTPUT
      - name: Allowlist local sample
        run: |
          mkdir -p components/seeder/config components/seeder/out
          echo "${{ steps.uri.outputs.uri }}" > components/seeder/config/allowlist.txt
      - name: Seed (mapper=basic)
        run: python components/seeder/seeder.py --mapper basic --allowlist components/seeder/config/allowlist.txt --out components/seeder/out/events.ndjson
      - name: Score
        run: python tools/score_demo/score.py --in components/seeder/out/events.ndjson --out tools/score_demo/out.json
      - name: Show result
        run: cat tools/score_demo/out.json
'@ | Set-Content -LiteralPath $wfPath -Encoding UTF8

# --- Commit / PR / attempt merge
git add --all
$changed = git status --porcelain
if ([string]::IsNullOrWhiteSpace($changed)) {
  _msg "[SKIP] No changes to commit; leaving branch as-is ($branch)" 'Yellow'
} else {
  git commit -m "feat: mapper (basic) fixtures, hints, README, mapper-smoke workflow" | Out-Null
  git push -u origin $branch | Out-Null
  $pr = gh pr list --state open --base $Base --head $branch --json number | ConvertFrom-Json
  if (-not $pr -or $pr.Count -eq 0) {
    gh pr create --title "feat: mapper (basic) + smoke CI" `
                 --body  "Adds basic mapper fixtures, domain_hints.json, README, and mapper-smoke CI workflow." `
                 --base  $Base --head $branch | Out-Null
  }
  try {
    gh pr merge $branch --squash --delete-branch | Out-Null
    _msg "[OK] Merged" 'Green'
  } catch {
    _msg "[INFO] Merge blocked; PR left open." 'Yellow'
    try { gh pr view $branch --web | Out-Null } catch {}
  }
}

Pop-Location
