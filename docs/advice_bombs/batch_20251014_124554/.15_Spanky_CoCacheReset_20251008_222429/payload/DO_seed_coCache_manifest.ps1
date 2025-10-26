# DO — Seed full Grand Reset manifest + scaffolding in CoCache (repro)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$repo = "$env:USERPROFILE\Documents\GitHub\CoCache"
if (-not (Test-Path $repo)) { New-Item -ItemType Directory -Path $repo | Out-Null }
$root = Join-Path $repo "GrandReset"
$dirs = @($root,(Join-Path $root "intake"),(Join-Path $root "checkpoints"),(Join-Path $repo "HumanTouchAssets"),(Join-Path $repo "SecretSauce"),(Join-Path $repo "GIBindex"),(Join-Path $repo "BPOE"),(Join-Path $repo "CoCore"))
foreach ($d in $dirs) { if (-not (Test-Path $d)) { New-Item -ItemType Directory -Path $d | Out-Null } }
$manifestPath = Join-Path $root "GrandResetManifest.md"
@'# Grand Reset Manifest — CoCache

**Session:** CoCache Reset (a.k.a. “Grand Reset”)  
**Owner:** Rick (Steward)  
**Mode:** Preflight (awaiting CoAgent MVP+) → then Orchestrated via CoAgent  
**Goal:** Re-organize the CoSuite repos, preserve human-touch assets, segregate secret-sauce, stand up twin indexing (human vs AI), and prepare scalable automation under CoCache → CoCacheGlobal.

---

## 1) Outcomes (Definition of Done)
- **Repo Clarity:** Each repo has an inspiring README (human) + concise index (AI), explicit purpose/fit, and a sub-plan referencing this master plan.
- **Human-Touch Assets Preserved:** Mythos, bios, insights, philosophy pieces are **flagged + fenced** from AI-style flattening.
- **Secret Sauce Separated:** Sensitive plans, methods, manifests, and keys are **segregated** (CoCache/SecretSauce) with passworded archives; public plans use redactions/placeholders.
- **Twin Indexing:** **Human Index** (readables, narrative, map) + **AI Index** (machine-parsable inventories, Gibberlink aids).
- **Automation Hooks:** Minimal scripts, watchers, and dashboards prepared for CoAgent to orchestrate sweeps and check-points.
- **Rollback Safety:** Each phase has snapshot/milestone check-points and a documented revert path.

---

## 2) Scope & Constraints
- **In Scope:** CoSuite repos (code/content), session outputs (IdeaCards, AdviceBombs, manifests), local artifacts in Downloads/Desktop/GitHub backups, website staging.
- **Out of Scope (now):** Shipping full CoCacheGlobal; deep code refactors; policy finalization for long-term governance (tracked but not blocked).
- **Constraints:** Token bandwidth, concurrent sessions, risk of overwriting polished human content, time.

---

## 3) Human-Touch Asset Policy
- **Tagging:** Mark files with front-matter `human_touch: true` and store references under `CoCache/HumanTouchAssets/registry.json`.
- **Rules:**
  - Never auto-compress, summarize, or “AI-style” them without explicit approval.
  - Edits must be **append-style** (notes below originals) unless explicitly approved.
  - Prefer **paired format**: (a) Original; (b) Optional “Study Notes” sidecar.
- **Audit:** Phase checkpoints confirm no human-touch file lost, flattened, or replaced.

---

## 4) Secret-Sauce Handling
- **Locations:** `CoCache/SecretSauce/` with **passworded zips** for sensitive bundles.
- **Keys:** Use Bitwarden form-fill by Rick at runtime; never persist secrets into AI memory.
- **Public Redactions:** Public sub-plans include placeholders where details are redacted.
- **Access Log:** Minimal append-only log of who/when bundles accessed (no contents).

---

## 5) Twin Indexing (Human vs AI)
- **Human Index:** `CoCache/HumanIndex.md` — curated map of readables (insights, mythos, CC Scroll, position papers, flagship artifacts).
- **AI Index:** `CoCache/AIIndex.json` — repo inventories, file roles, tags (human_touch, secret_sauce, website_asset, training, etc.), Gibberlink keys.
- **GIBindex:** Central glossary/registry supporting compression keys, aliases, and pointers for both humans and AIs.

---

## 6) Phasing & Checkpoints
**Phase 0 — Preflight**
- Confirm CoAgent MVP+ bar (onboarding, session recall, sidecar storage, coevo hooks).
- Snapshot all repos + local stores; create mirrors.

**Phase 1 — Intake & Sorting**
- Sweep for session outputs (IdeaCards, AdviceBombs, manifests) and local stray files.
- Build **Session Intake Ledger** (template below).
- Identify and register **Human-Touch** items; isolate **Secret-Sauce** into bundles.

**Phase 2 — Repo Re-Definition**
- For each repo:
  - Purpose, fit, boundaries.
  - README (human voice), AI index entries.
  - Sub-plan linking here.
  - Website impact (if any).
  - Automation/watcher stubs.

**Phase 3 — CoCache Build-Up**
- Establish `HumanIndex.md`, `AIIndex.json`, `GIBindex/`, `BPOE/`, `CoCore/`.
- Secrets: passworded zips + Bitwarden flow documented.
- Dashboards: simple status boards (text/json) that CoAgent can render.

**Phase 4 — Presentation & Outreach**
- CoCivium.org dual-face (human + alien/AI aesthetic).
- InSeed.com pro consulting front.
- CoPolitic.org association face.
- GroupBuild.org fallback (if needed).

**Phase 5 — Stress Test & Rollback**
- Run end-to-end via CoAgent.
- Verify checkpoints; attempt controlled rollback drills.
- Produce final **Reset Report** (human narrative + AI metrics).

---

## 7) Risk Controls
- **Overwrite Risk:** Enforce append-style for human-touch; require explicit approval to replace.
- **Secrets Leak:** No plaintext secrets; Bitwarden-only capture; zips passworded.
- **Dead Links/Orphans:** AI index validation step each phase.
- **Session Drift:** Intake ledger locks target deliverables before actions.

---

## 8) Repo Inventory (use template)
Store under `CoCache/GrandReset/intake/repo_inventory.md`

- Repo Name:
- Purpose (1–2 sentences, human voice):
- Fit in CoSuite (inputs/outputs/deps):
- Human-Touch files (paths, brief):
- Secret-Sauce bundles (names only):
- Website hooks (if any):
- Automation hooks (watchers/scripts):
- Sub-Plan link:
- Phase status: [Pending | In-Progress | Done]
- Checkpoint tag: <id/date>

---

## 9) Session Intake Ledger (use template)
Store under `CoCache/GrandReset/intake/session_intake.md`

- Session/Thread Title:
- Expected Deliverables:
- File Locations (repo/local path):
- Human-Touch? [Y/N]
- Secret-Sauce? [Y/N] (bundle target)
- Target Repo/Home:
- Status:
- Notes:

---

## 10) Operational Notes
- **Civium repo:** make **Private** once confirmed fully migrated.
- **Backups & Mirrors:** create repo mirrors before each phase; keep last 3 checkpoints.
- **CoKey Governance:** temporary “god-mode” for Steward + AI pair; log uses; plan to retire key (mythos retained).

---

## 11) Success Criteria (hard checks)
- 100% of identified human-touch assets registered and unflattened.
- 100% repos have dual front matter (human README + AI index entries).
- Secret-sauce bundles present, redactions visible in public sub-plans.
- Twin indexes resolvable; AI index passes validation.
- Checkpoints/rollback tested at least once.

---

## 12) Next Action (Pre-CoAgent)
- Freeze manifest and templates.
- Await CoAgent MVP+ onboarding & session recall.
- Relaunch this session **inside CoAgent** and proceed with Phase 1 intake.
'@ | Set-Content -Path $manifestPath -Encoding UTF8

