param(
  [string]$RepoRoot = (Join-Path $HOME 'Documents\GitHub\MeritRank'),
  [string]$Base = 'main'
)
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'

function Get-RepoSlug([string]$root) {
  $url = git -C $root remote get-url origin
  if ($url -match 'github\.com[:/](.+?)(?:\.git)?$') { return $Matches[1] }
  throw "Cannot derive GitHub slug from origin url: $url"
}

if (-not (Test-Path $RepoRoot)) { throw "Repo not found: $RepoRoot" }
$RepoRoot = (Resolve-Path $RepoRoot).Path
$slug = Get-RepoSlug $RepoRoot

Push-Location $RepoRoot
git fetch --all --prune | Out-Null

# Ensure base branch exists locally and is up to date
if (-not (git rev-parse --verify $Base 2>$null)) { git checkout -b $Base "origin/$Base" | Out-Null } else { git checkout $Base | Out-Null }
git pull --ff-only | Out-Null

# Make a branch
$stamp  = (Get-Date -Format 'yyyyMMdd-HHmmss')
$branch = "chore/branding-digital-halo-$stamp"
git checkout -b $branch | Out-Null

# === Write brand pack ===
$brandDir = Join-Path $RepoRoot 'docs\brand'
New-Item -ItemType Directory -Force -Path $brandDir | Out-Null

$brandMd = @"
# MeritRank Brand Pack: *Digital Halo*

**Canonical tagline:** **Your digital halo — verifiable kudos, not callouts.**

**One-liners (alternates):**
- MeritRank: build your digital halo.
- A positive, tamper‑evident ledger of good work.
- Proof of contribution, not a gossip feed.
- Kudos you can cite; receipts you can trust.
- Friendly reputation: attestations over accusations.

**Short pitch (≈40 words):**
MeritRank turns verifiable contributions into a **digital halo** — a positive, tamper‑evident stream of kudos and impact receipts. It favors attestations and proofs, not allegations. Optional public anchoring makes records harder to tamper with and easier to audit.

**Positioning notes:**
- **Positive‑only:** We index compliments and verified wins; we do not host accusations or smears.
- **Tamper‑evident first:** “Blockchain‑anchored” where appropriate; otherwise we still keep an append‑only, signed log.
- **Consent & controls:** Clear opt‑out/removal of self‑identifiers; dispute and redaction routes for mistakenly attached evidence.
- **Not a credit score:** No opaque down‑ranking; a transparent feed you can inspect.

**Legal/claims guidance (marketing safe):**
- Prefer “tamper‑evident” to “immutable.”
- Say “optionally anchored to public chains” rather than “on the blockchain,” unless the default implementation truly anchors every record.
- Avoid implying endorsement by listed organizations or sources.
"@
Set-Content -LiteralPath (Join-Path $brandDir 'BRAND.md') -Encoding UTF8 -Value $brandMd

$readmeSnippet = @"
> **Your digital halo — verifiable kudos, not callouts.**

MeritRank collects attestations and positive, verifiable contributions into a tamper‑evident feed. We prefer proofs over accusations. *Optionally* records can be anchored to public chains for additional auditability.
"@
Set-Content -LiteralPath (Join-Path $brandDir 'README_SNIPPET.md') -Encoding UTF8 -Value $readmeSnippet

# === Update README.md (idempotent) ===
$readmePath = Join-Path $RepoRoot 'README.md'
if (-not (Test-Path $readmePath)) {
  @"
# MeritRank

$($readmeSnippet)

## What is a digital halo?
A concise stream of verified kudos and impact receipts. It showcases positive contributions; it is **not** a venue for allegations or call‑outs. MeritRank maintains a tamper‑evident history and can optionally anchor batches to public chains for auditability.

## Status
See CI and smoke test badges below.
"@ | Set-Content -LiteralPath $readmePath -Encoding UTF8
} else {
  $readme = Get-Content -LiteralPath $readmePath -Raw -Encoding UTF8
  if ($readme -match '^\s*#\s*MeritRank\b') {
    if ($readme -notmatch 'Your digital halo') {
      $readme = $readme -replace '(^\s*#\s*MeritRank.*?$)', "`$1`r`n`r`n$([regex]::Escape($readmeSnippet))", 1
    }
  } else {
    $readme = "# MeritRank`r`n`r`n$readmeSnippet`r`n`r`n$readme"
  }
  if ($readme -notmatch '## What is a digital halo\?') {
    $readme += "`r`n`r`n## What is a digital halo?`r`nA concise stream of verified kudos and impact receipts. It showcases positive contributions; it is **not** a venue for allegations or call‑outs. MeritRank maintains a tamper‑evident history and can optionally anchor batches to public chains for auditability.`r`n"
  }
  Set-Content -LiteralPath $readmePath -Encoding UTF8 -Value $readme
}

# === Insert badges (CI & mapper-smoke) ===
$badgesLine = "[![](https://github.com/$slug/actions/workflows/ci.yml/badge.svg?branch=$Base)](https://github.com/$slug/actions/workflows/ci.yml) [![](https://github.com/$slug/actions/workflows/mapper-smoke.yml/badge.svg?branch=$Base)](https://github.com/$slug/actions/workflows/mapper-smoke.yml)"
$readme = Get-Content -LiteralPath $readmePath -Raw -Encoding UTF8
if ($readme -notmatch 'actions/workflows/ci\.yml/badge\.svg') {
  if ($readme -match '^\s*#\s*MeritRank.*?$') {
    $readme = $readme -replace '(^\s*#\s*MeritRank.*?$)', "`$1`r`n$badgesLine", 1
  } else {
    $readme = "# MeritRank`r`n$badgesLine`r`n`r`n$readme"
  }
  Set-Content -LiteralPath $readmePath -Encoding UTF8 -Value $readme
}

# === Try to edit repo description & topics (best effort) ===
try {
  gh repo edit $slug --description "MeritRank — your digital halo: verifiable kudos, not callouts." | Out-Null
  $topics = @('digital-halo','reputation','attestations','trust-and-safety','civic-tech')
  foreach ($t in $topics) {
    try { gh repo edit $slug --add-topic $t | Out-Null } catch {}
  }
} catch { Write-Host "[WARN] gh repo edit failed (unauthenticated?). Skipping description/topics." -ForegroundColor Yellow }

# === Commit / PR / (try) merge ===
$changed = git status --porcelain
if ([string]::IsNullOrWhiteSpace($changed)) {
  Write-Host "[SKIP] No changes to commit" -ForegroundColor Yellow
  git checkout $Base | Out-Null
  git branch -D $branch | Out-Null
  Pop-Location
  return
}

git add --all
git commit -m "Branding: add 'digital halo' positioning; README tagline/badges; brand pack" | Out-Null
git push -u origin $branch | Out-Null

# Create PR if missing
$pr = gh pr list --state open --base $Base --head $branch --json number | ConvertFrom-Json
if (-not $pr -or $pr.Count -eq 0) {
  gh pr create --title "Branding: 'digital halo' tagline & brand pack" `
               --body "Adds docs/brand/BRAND.md and README tagline ('Your digital halo — verifiable kudos, not callouts.'). Also inserts CI and mapper-smoke badges. Updates repo description & topics (best effort)." `
               --base $Base --head $branch | Out-Null
}

# Try squash-merge, else leave PR open
try {
  gh pr merge $branch --squash --delete-branch | Out-Null
  Write-Host "[OK] Branding merged to $Base." -ForegroundColor Green
} catch {
  Write-Host "[INFO] Merge blocked; PR left open." -ForegroundColor Yellow
  try { gh pr view $branch --web | Out-Null } catch {}
}

Pop-Location
Write-Host "[DONE] Branding pack applied." -ForegroundColor Green