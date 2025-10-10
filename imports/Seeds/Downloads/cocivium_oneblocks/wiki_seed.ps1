
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function New-Timestamp { Get-Date -Format yyyyMMdd_HHmm }

function Ensure-Repo {
  param([string]$RepoRoot = "$HOME\Documents\GitHub\CoCivium")
  if (-not (Test-Path $RepoRoot)) { throw "RepoRoot not found: $RepoRoot" }
  Set-Location $RepoRoot
  $null = git rev-parse --is-inside-work-tree 2>$null
  if ($LASTEXITCODE -ne 0) { throw "Not a git repo: $RepoRoot" }
  return $RepoRoot
}

function Write-IfChanged {
  param([string]$Path,[string]$Content)
  $dir = Split-Path -Parent $Path
  if ($dir -and -not (Test-Path $dir)) { New-Item -ItemType Directory -Force $dir | Out-Null }
  if (Test-Path $Path) {
    $existing = Get-Content $Path -Raw
    if ($existing -eq $Content) { return $false }
  }
  Set-Content $Path $Content -Encoding UTF8
  return $true
}

function Assert-GH {
  $null = gh auth status 2>$null
  if ($LASTEXITCODE -ne 0) { throw "GitHub CLI not authenticated. Run: gh auth login" }
}

function Safe-CommitPush {
  param([string]$Message, [switch]$NoPush)
  $null = git add -A
  $status = git status --porcelain
  if ($status) {
    git commit -m $Message | Out-Null
    if (-not $NoPush) { git push -u origin HEAD | Out-Null }
    return $true
  } else {
    Write-Host "Nothing to commit."
    return $false
  }
}

param(
  [string]$RepoRoot = "$HOME\Documents\GitHub\CoCivium",
  [string]$Owner = "rickballard",
  [string]$Repo = "CoCivium"
)

Ensure-Repo -RepoRoot $RepoRoot | Out-Null
Assert-GH

gh repo edit "$Owner/$Repo" --enable-wiki

$wikiDir = Join-Path $env:TEMP "$Repo.wiki"
if (Test-Path $wikiDir) { Remove-Item $wikiDir -Recurse -Force }
git clone "https://github.com/$Owner/$Repo.wiki.git" $wikiDir | Out-Null
Set-Location $wikiDir

$homePageContent = @'
# CoCivium Wiki

CoCivium is a practical path toward **consentful, polycentric governance**.

Start here:
- [[Getting-Started]]
- [[Decision-Flow]]
- [[Roles]]
- [[Domains]]
- [[FAQ]]
- [[Links]]

**See the repo for:**
- Vision → docs/vision/CoCivium_Vision.md
- Charter (Cognocarta: Consenti) → scroll/Cognocarta_Consenti.md
'@
Set-Content "Home.md" $homePageContent -Encoding UTF8

Set-Content "Getting-Started.md" @'
# Getting Started
See repo layout in README and docs/STYLE.md. Promote → canonicalize → retire drafts.
'@ -Encoding UTF8

Set-Content "Decision-Flow.md" @'
# Decision Flow
Consent before coercion; escalate to voting only when consent stalls.
'@ -Encoding UTF8

Set-Content "Roles.md" @'
# Roles
Contributor • Steward • Resolver • Auditor (time-boxed, recallable).
'@ -Encoding UTF8

Set-Content "Domains.md" @'
# Domains
See `/domains` in the repo for full briefs. This page is an index.
'@ -Encoding UTF8

Set-Content "FAQ.md" @'
# FAQ
**Is this “no leaders”?**  
No—**stewardship** over rule; authority = maintained trust.
'@ -Encoding UTF8

Set-Content "Links.md" @'
# Links
Repo: https://github.com/rickballard/CoCivium
'@ -Encoding UTF8

git add -A
git commit -m "wiki: seed Home + basic pages" | Out-Null
git push | Out-Null
