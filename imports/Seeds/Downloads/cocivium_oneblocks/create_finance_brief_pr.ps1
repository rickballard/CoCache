
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
  [switch]$NoPR
)

Ensure-Repo -RepoRoot $RepoRoot | Out-Null
Assert-GH

$branch = "domain/finance-brief-" + (New-Timestamp)
git switch -c $branch | Out-Null

if (-not (Test-Path "domains")) { New-Item -ItemType Directory -Force domains | Out-Null }

$md = @'
---
title: "Domain Brief: Finance & Budgeting"
canonical_slug: domain-finance-budgeting
source:
  repo: CoCivium
  original_path: ./domains/finance.md
  imported_on: 2025-08-14
  version: c1
  date: 20250814
supersedes: []
---

# Finance & Budgeting — Consentful Patterns

**Goal:** fund work with dignity and transparency while avoiding power capture.

## Context
Money flows shape incentives and trust. We keep ledgers open, roles separated, and decisions reviewable.

## Practices worth copying
- **Open ledgers** with monthly notes (cash in/out, cash on hand).
- **Ring-fenced grants** tied to obligations & review dates.
- **Separation of concerns:** proposer vs implementer vs approver vs auditor.
- **Budget caps** and default sunsets; renew on evidence.
- **Public caps on steward discretion**; larger spends require stronger signals.
- **Portable records** (plain files, hashable when needed).

## Minimum Viable Flow
1) Proposal: context → options → risks → obligations → review date  
2) Consent check → if stalled, escalate to risk-scaled vote  
3) Record outcome + ledger entry + steward owner  
4) Review on date; renew/retire; publish note

```mermaid
flowchart TD
  P[Proposal] --> C{Consent?}
  C -- yes --> L[Ledger entry + Obligations + Review date]
  C -- no --> V[Vote (proportional to risk)]
  V --> L
  L --> R[Review → renew/retire → publish note]
```

## Risks & anti-patterns
- “Single keyholder” treasury risk → require dual control + logs.
- Discretion creep → set explicit caps & publish them.
- Hidden obligations (grants without recorded deliverables).
- Over-voting routine spend (burns attention, slows work).

## Experiments we’ll run
- Monthly finance notes in `notes/finances/`.
- Pilot small, ring-fenced grants with clear review dates.
- “Decision → ledger” provenance links (bot/script).
- External audit buddy for quarterly spot checks.

## Measures
- # decisions with linked ledger entries
- % spends with on-time reviews
- Median time from proposal → decision recorded
- # objections raised/resolved in finance decisions

## Next
See **docs/FUNDING.md** and **docs/funding/OPEN_COLLECTIVE.md**.

*Version:* c1 (2025-08-14)

'@

$changed = Write-IfChanged -Path "domains/finance.md" -Content $md
if ($changed) { Write-Host "Wrote domains/finance.md" } else { Write-Host "No changes to domains/finance.md" }

$did = Safe-CommitPush -Message "domain: Finance & Budgeting brief (c1) — practices, flow, risks, experiments, measures"
if ($did -and -not $NoPR) {
  gh pr create --head $branch -t "domain: Finance & Budgeting brief (c1)" -b "Adds the first domain brief with consentful finance patterns, MVP flow (mermaid), risks, experiments, and measures."
}
