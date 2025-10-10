
param(
  [string]$RepoRoot = (Join-Path $HOME 'Documents\GitHub\MeritRank'),
  [string]$Base = 'main'
)
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'

if (-not (Test-Path $RepoRoot)) { throw "Repo not found: $RepoRoot" }
Push-Location $RepoRoot
git fetch --all --prune
if (-not (git rev-parse --verify $Base 2>$null)) { git checkout -b $Base origin/$Base } else { git checkout $Base }
git pull --ff-only

$stamp  = (Get-Date -Format 'yyyyMMdd-HHmmss')
$branch = "advice/coeve-ci-smoke-$stamp"
git checkout -b $branch

$wfDir = ".github/workflows"
New-Item -ItemType Directory -Force -Path $wfDir | Out-Null
$wf = @"
name: seeder-smoke
on:
  schedule: [ { cron: '17 3 * * *' } ]  # daily, 03:17 UTC
  workflow_dispatch:
jobs:
  smoke:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with: { python-version: '3.11' }
      - name: Seed (polite, mapper basic)
        run: |
          python components/seeder/seeder.py --mapper basic --allowlist components/seeder/config/allowlist.txt --out components/seeder/out/events.ndjson || true
      - name: Score
        run: |
          python tools/score_demo/score.py --in components/seeder/out/events.ndjson --out tools/score_demo/out.json || true
          cat tools/score_demo/out.json || true
      - name: Upload artifacts
        if: always()
        uses: actions/upload-artifact@v4
        with:
          name: seeder-smoke
          path: |
            components/seeder/out/events.ndjson
            tools/score_demo/out.json
"@
Set-Content -LiteralPath "$wfDir/seeder-smoke.yml" -Encoding UTF8 -Value $wf

git add --all
git commit -m "CI: daily seeder-smoke (mapper basic) + artifact upload" | Out-Null
git push -u origin $branch

$pr = gh pr list --state open --base $Base --head $branch --json number | ConvertFrom-Json
if (-not $pr -or $pr.Count -eq 0) {
  gh pr create --title "CI: daily seeder-smoke + score artifact" `
               --body "Runs polite seeder (with optional mapper) and uploads events & score as artifacts. Manual dispatch supported." `
               --base $Base --head $branch | Out-Null
}
try { gh pr merge $branch --squash --delete-branch | Out-Null; Write-Host "[OK] Merged" -ForegroundColor Green }
catch { Write-Host "[INFO] Merge blocked; PR left open." -ForegroundColor Yellow; try { gh pr view $branch --web | Out-Null } catch {} }

Pop-Location
