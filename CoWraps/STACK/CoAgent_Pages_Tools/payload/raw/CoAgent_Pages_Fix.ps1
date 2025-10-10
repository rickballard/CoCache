# Requires: gh CLI authenticated, git installed.
# Run INSIDE: C:\Users\Chris\Documents\GitHub\CoAgent
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'

# --- Sanity
$repo = gh repo view --json nameWithOwner --jq .nameWithOwner
if ($repo -ne 'rickballard/CoAgent') { throw "Run inside CoAgent. Current repo: $repo" }

# --- 1) Ensure /docs exists and has a page to publish
New-Item -ItemType Directory -Force .\docs | Out-Null
if (-not (Test-Path .\docs\index.html)) {
  # If there is a mock, link to it; else simple landing
  $index = @"
<!doctype html>
<title>CoAgent Docs</title>
<meta charset="utf-8">
<h1>CoAgent — Docs</h1>
<p>UI mock: <a href="./ui-mock/quad.html">docs/ui-mock/quad.html</a></p>
"@
  $index | Set-Content -Encoding UTF8 .\docs\index.html
}

# --- 2) Create/refresh gh-pages branch directly from docs (no workflow dependency)
$cur = git branch --show-current
$hadBranch = (git ls-remote --heads origin gh-pages) -ne $null

# Create a clean worktree for gh-pages to avoid polluting current branch
$wt = Join-Path $env:TEMP ("coagent-ghpages-" + [Guid]::NewGuid())
git worktree add $wt gh-pages 2>$null | Out-Null
if ($LASTEXITCODE -ne 0) {
  git worktree add -B gh-pages $wt origin/gh-pages 2>$null | Out-Null
}
# Clear the worktree and copy docs
Push-Location $wt
git rm -r * 2>$null | Out-Null
Remove-Item -Recurse -Force -ErrorAction SilentlyContinue *

Copy-Item -Recurse -Force (Join-Path (Split-Path $PSScriptRoot -Parent) "docs\*") .
# Make sure there is no Jekyll processing
' ' | Set-Content -Encoding ASCII .nojekyll
# Commit
git add -A
git -c user.name="CoAgent Bot" -c user.email="coagent@users.noreply.github.com" commit -m "Publish docs to gh-pages" 2>$null | Out-Null
git push -u origin HEAD:gh-pages
Pop-Location

# Cleanup worktree
git worktree remove $wt --force 2>$null | Out-Null

# --- 3) Enable Pages to serve from gh-pages (root)
try {
  gh api -X POST repos/rickballard/CoAgent/pages `
    -H "Accept: application/vnd.github+json" `
    -f build_type=legacy `
    -f source[branch]=gh-pages `
    -f source[path]=/ 2>$null | Out-Null
} catch {
  # If already exists, update
  gh api -X PUT repos/rickballard/CoAgent/pages `
    -H "Accept: application/vnd.github+json" `
    -f build_type=legacy `
    -f source[branch]=gh-pages `
    -f source[path]=/ 2>$null | Out-Null
}

# --- 4) Print URLs
$baseUrl = "https://rickballard.github.io/CoAgent"
$mockUrl = "$baseUrl/ui-mock/quad.html"
$indexUrl = "$baseUrl/index.html"

Write-Host ""
Write-Host "✅ GitHub Pages published for CoAgent." -ForegroundColor Green
Write-Host "   Index: $indexUrl"
Write-Host "   Mock : $mockUrl"