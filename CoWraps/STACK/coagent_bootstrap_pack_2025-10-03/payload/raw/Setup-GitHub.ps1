Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
param(
  [Parameter(Mandatory=$true)][string]$Owner,
  [string]$Repo = "CoAgent",
  [switch]$Public,
  [switch]$RelaxProtections,
  [switch]$EnablePages
)
function Need($cmd){ if(-not (Get-Command $cmd -ErrorAction SilentlyContinue)){ throw "Missing prerequisite: $cmd" } }
Need git; Need gh; Need pwsh
# Auth
try{
  gh auth status | Out-Null
}catch{
  Write-Host "→ Launching gh auth login (device flow)…"
  gh auth login
}
# Create repo if missing
$exists = (gh repo view "$Owner/$Repo" --json name -q .name 2>$null)
if(-not $exists){
  $visibility = ($Public.IsPresent) ? "public" : "private"
  gh repo create "$Owner/$Repo" --$visibility --confirm
  Write-Host "✓ Repo created: $Owner/$Repo"
}
# Clone or pull
$target = Join-Path (Get-Location) $Repo
if(-not (Test-Path $target)){ gh repo clone "$Owner/$Repo" $target }
Push-Location $target
git fetch origin --prune | Out-Null
git checkout -B main origin/main 2>$null | Out-Null

# Seed docs if empty
New-Item -ItemType Directory -Force docs | Out-Null
$index = @'
<!doctype html><meta charset="utf-8"><title>CoAgent Docs</title>
<h1>CoAgent /docs</h1>
<ul>
  <li><a href="./ui-mock/quad.html">UI Mock (quad.html)</a></li>
  <li><a href="./status.html">Status Panel</a></li>
  <li><a href="./status.json">Status JSON</a></li>
</ul>
'@
$status_html = @'
<!doctype html><meta charset="utf-8"><title>CoAgent Status</title>
<h1>CoAgent · Status</h1><div id="card"><em>Loading status.json…</em></div>
<script>
(async()=>{const el=document.getElementById('card');
 try{const r=await fetch('./status.json',{cache:'no-store'}); if(!r.ok) throw new Error('HTTP '+r.status);
  const j=await r.json(); el.innerHTML=Object.entries(j).map(([k,v])=> `<div><b>${k}</b>: <code>${(typeof v=='object')?JSON.stringify(v):v}</code></div>`).join('');
 }catch(e){ el.innerHTML = '<b>Could not load status.json</b>'; }} )();
</script>
'@
$quad = '<!doctype html><meta charset="utf-8"><title>CoAgent Quad Mock</title><h1>CoAgent — Quad Mock</h1><p>Placeholder.</p>'
$status_json = @{ auth="linked"; safeguards="PR-first"; index=("updated @"+(Get-Date).ToString("s")); deliverable="ok" } | ConvertTo-Json

if(-not (Test-Path docs/index.html)){ $index | Set-Content -Encoding UTF8 docs/index.html }
New-Item -ItemType Directory -Force docs/ui-mock | Out-Null
if(-not (Test-Path docs/ui-mock/quad.html)){ $quad | Set-Content -Encoding UTF8 docs/ui-mock/quad.html }
$status_html | Set-Content -Encoding UTF8 docs/status.html
$status_json | Set-Content -Encoding UTF8 docs/status.json

# gh-pages workflow (docs → gh-pages)
New-Item -ItemType Directory -Force .github/workflows | Out-Null
$wf = @'
name: gh-pages
on:
  push:
    branches: [ main ]
    paths:
      - "docs/**"
      - ".github/workflows/gh-pages.yml"
  workflow_dispatch:

permissions:
  contents: write

concurrency:
  group: pages-deploy
  cancel-in-progress: true

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Publish docs/ to gh-pages
        uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./docs
'@
$wf | Set-Content -Encoding UTF8 .github/workflows/gh-pages.yml

git add .
if(-not (git diff --cached --quiet 2>$null)){ git commit -m "seed: docs + gh-pages workflow" }

git push -u origin HEAD

# Enable Pages
if($EnablePages){
  gh api -X PUT "repos/$Owner/$Repo/pages" -H "Accept: application/vnd.github+json" -f "source[branch]=gh-pages" -f "source[path]=/"
  Write-Host "✓ Pages source set to gh-pages"
}

# Branch protection modes
if($RelaxProtections){
  $payload = @{
    required_status_checks = @{ strict = $true; checks = @(
      @{ context = 'gh-pages/deploy (push)' }
    ) }
    enforce_admins = $true
    required_pull_request_reviews = @{ required_approving_review_count = 0 }
    restrictions = $null
    required_linear_history = $true
  } | ConvertTo-Json -Depth 6
  $payload | gh api -X PUT "repos/$Owner/$Repo/branches/main/protection" -H "Accept: application/vnd.github+json" --input -
  Write-Host "✓ Branch protection set to fast+pages-check"
}

# Open site when likely ready
Write-Host "⏳ Waiting briefly for Pages…"
Start-Sleep -Seconds 8
$base = "https://{0}.github.io/{1}" -f $Owner,$Repo
.\tools\Test-MVP.ps1 -BaseUrl $base
Pop-Location
