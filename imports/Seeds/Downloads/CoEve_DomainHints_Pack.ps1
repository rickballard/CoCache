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
git checkout $Base      | Out-Null
git pull --ff-only      | Out-Null

$branch = New-BranchName "advice/coeve-domain-hints"
git checkout -b $branch | Out-Null

$hintsPath = "components/seeder/config/domain_hints.json"
$hintsDir  = Split-Path -Parent $hintsPath
New-Item -ItemType Directory -Force -Path $hintsDir | Out-Null

# Read existing or start fresh
$hints = @{}
if (Test-Path $hintsPath) {
  try { $hints = Get-Content $hintsPath -Raw | ConvertFrom-Json -AsHashtable } catch {}
}

# Ensure keys
$hints['example.org'] = @{
  type = 'cred_page'
  selector = "meta[name='co-tag'][content='credential']"
  signals = @(@{ impact = 0.1; severity = 0.2 })
}
$hints['www.iana.org'] = @{
  type = 'info'
  selector = 'title'
  signals = @(@{ impact = 0.05; severity = 0.1 })
}

# Write back (pretty)
($hints | ConvertTo-Json -Depth 5) | Set-Content -Encoding UTF8 -LiteralPath $hintsPath

# Update docs
$doc = "docs/specs/mapper.md"
New-Item -ItemType File -Force -Path $doc | Out-Null
$append = @"
## Domain hints (v0)

The seeder's **basic** mapper can optionally consult `components/seeder/config/domain_hints.json`
to inject low-confidence signals for specific hosts (e.g., `example.org`, `www.iana.org`) or to
supply CSS selectors for scraping simple meta tags. Hints are strictly optional and carry small
weights to avoid false confidence.

"@
Add-Content -LiteralPath $doc -Encoding UTF8 -Value $append

git add --all
git commit -m "feat: seed domain_hints.json + docs for basic mapper" | Out-Null
git push -u origin $branch | Out-Null

$existing = gh pr list --state open --base $Base --head $branch --json number | ConvertFrom-Json
if (-not $existing -or $existing.Count -eq 0) {
  gh pr create --title "feat: domain hints (v0) + mapper docs" `
               --body  "Adds example hints for example.org / iana.org and docs/specs/mapper.md note." `
               --base $Base --head $branch | Out-Null
}
try {
  gh pr merge $branch --squash --delete-branch | Out-Null
  Write-Host "[OK] Hints merged to $Base." -ForegroundColor Green
} catch {
  Write-Host "[INFO] Merge blocked; PR left open." -ForegroundColor Yellow
}

Pop-Location
