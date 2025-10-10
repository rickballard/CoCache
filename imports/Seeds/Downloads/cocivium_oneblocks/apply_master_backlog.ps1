
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

$branch = "ops/master-backlog-" + (New-Timestamp)
git switch -c $branch | Out-Null

$md = @'
# CoCivium — Master Backlog & Operating Plan
_Date: 2025-08-14 • Owner: @rickballard • Source of truth for work planning_

This backlog replaces scattered TODOs/notes as we converge. New work should be added here (and linked to issues/PRs).

---

## 0) How to use this file
- Treat this as the **single backlog**. When we pull tasks from older TODOs, **delete or link back** here.
- Every line item should become a **GitHub issue** (labels: `content`, `refactor`, `funding`, `product`, `domain`, `wiki`, `ci`, `ops`).
- **Cadence:** weekly review → update priorities → close won’t-do items quickly.

---

## P0 — Now (next 7–14 days)
- [ ] **Merge PRs**: #69 (Consenti c2 uplift), #67 (structure & hygiene) after a quick read-through on mobile/desktop.
- [ ] **Enable GitHub Wiki** and publish: Home, Getting Started, Decision Flow, Roles, Domains (index), FAQ, Links.
- [ ] **Vision page polish** (`docs/vision/CoCivium_Vision.md`): add 1-page overview (“Why now / How it works / What’s different”) + embed a simple flow diagram.
- [ ] **Consenti landing polish** (`scroll/Cognocarta_Consenti.md`): add mermaid decision diagram + “Adopt this charter” snippet.
- [ ] **Create `docs/sources/`** with `annotated-bibliography.md` (seed 10 credible references) and `comparable-initiatives.md`.
- [ ] **Domains: draft first 3 briefs** (`domains/finance.md`, `domains/identity_privacy.md`, `domains/public_records.md`) with “practices / risks / experiments / measures”.
- [ ] **Open Collective setup** (see `docs/funding/OPEN_COLLECTIVE.md`): choose fiscal host, create **cocivium**, test $1 donation.  
      _When live_: switch `.github/FUNDING.yml` → `open_collective: cocivium`, remove temporary DogsnHomes callouts/badge.
- [ ] **Monthly transparency note scaffold**: create `notes/finances/2025-08.md`.
- [ ] **Stub hygiene**: run `scripts/stubscan.ps1` → bring any canonical doc < 500 bytes to minimum content.
- [ ] **README mobile pass**: ensure CTA image + Consenti blurb read well on small screens; add one-sentence value prop.

---

## P1 — Next (this month)

### Narrative & UX
- [ ] OG image + small section icons.
- [ ] Slides/one-pager for Vision + Consenti.

### Domains (more briefs)
- [ ] Social safety, health, taxation & redistribution, wealth inequality, education/credentials, civic tech.
- [ ] For each: context → harms/risks → practices → experiments → citations.

### Products (revenue-adjacent pilots)
- [ ] Decision Log MVP (plain-file → static viewer).
- [ ] Consent Clinic (fixed-fee; checklist + deliverable).
- [ ] Templates Pack (proposal/decision/role/review).
- [ ] Workshops (2–3 hrs); recording + slides.
- [ ] Annual field report (pay-what-you-want PDF).

### Funding & Ops
- [ ] Publish Funding & Gifts link; set OC tiers.
- [ ] Start monthly finance notes; reconcile to OC ledger.

### CI & Quality
- [ ] markdownlint Action.
- [ ] spell-check with custom lexicon.
- [ ] Tune Lychee timeouts/accept list.

---

## P2 — Later
- [ ] Interactive Decision Flow site.
- [ ] Case studies (2–3).
- [ ] Translations scaffolding (docs/i18n/).

---

## Wiki Backlog
- [ ] Home, Getting Started, Decision Flow, Roles, Domains Index, FAQ, Links.

---

## Consenti (deepening)
- [ ] Review cadence; “Adopt this Charter” block; remedy ladder details.

---

## Vision (deepening)
- [ ] Why now; federation vs centralization; internet→real-world compliance.

---

## Domains — pipeline
- [ ] Finance & budgeting; Identity & privacy; Public records; Social safety; Health; Tax & redistribution; Wealth inequality; Education & credentials.

---

## External sources
- [ ] docs/sources/annotated-bibliography.md (10+ refs).
- [ ] docs/sources/comparable-initiatives.md.
- [ ] Prefer paraphrase + link; short quotes sparingly.

---

## Editorial & Design
- [ ] Section icons/banners; figure captions; standardize frontmatter.

---

## Engineering & CI
- [ ] markdownlint + codespell; Lychee pragmatics; index-rebuilder script.

---

## Funding & Finance
- [ ] Choose OC host; switch Sponsor to OC; monthly notes; keep Gift Policy linked.

---

## Migration & Cleanup
- [ ] Triage staging/_imported; promote drafts; keep folder READMEs.

---

## Artistic safeguards
- [ ] CODEOWNERS checks; editorial rubric for artistic pieces.

---

## Cross-repo consolidation
- [ ] notes/cross-repo-index.md; mark migrated items; pull high-signal docs.

---

## Tracking & Metrics
- [ ] Signals: #adoptions, #decisions, #objections resolved, #reviews/mo.
- [ ] notes/metrics.md monthly.

---

## Review cadence
- Weekly: backlog groom (10m). Monthly: finance+metrics. Quarterly: rule review.

---

## Changelog
- _2025-08-14 — initial master backlog._

'@

$changed = Write-IfChanged -Path "notes/master_backlog.md" -Content $md
if ($changed) { Write-Host "Wrote notes/master_backlog.md" } else { Write-Host "No changes to notes/master_backlog.md" }

$did = Safe-CommitPush -Message "ops: add master backlog & operating plan"
if ($did -and -not $NoPR) {
  gh pr create --head $branch -t "ops: master backlog & operating plan" -b "Single source of truth for priorities, domains, products, funding, CI, and migration."
}
