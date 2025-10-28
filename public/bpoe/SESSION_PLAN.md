# CoPrime Session Plan (seed, live)

> **Single cloud pointer** for the next CoPrime. Source of truth is CoCache (cloud).  
> BPOE is **machine-first**; human views are renders. Receipts are files, not chat.

## Canonical Links (open these first)
- Machine SoT (BPOE): `private/bpoe/registry.json`
- Public BPOE table:   `public/bpoe/BPOE_Rules.md`
- Receipts root:       `public/bpoe/receipts/`
- Harvest inventory:   `private/bpoe/harvest/20251028/inventory.json`
- CoCivium PR (seed):  https://github.com/rickballard/CoCivium/pull/426

---

## TODAY (must do)
- [ ] **Merge** CoCivium PR #426 (adds CoSync seeds; verify no diagram paths touched).
- [ ] Open/merge PRs for CoCache branches (registry seed, receipt+harvest, this plan).
- [ ] Publish a **RECEIPT** under `public/bpoe/receipts/YYYY/MM/DD/` for this handoff.

---

## BPOE Centralization (this week)
- [ ] Harvest **all** legacy BPOE from every repo → `private/bpoe/harvest/YYYYMMDD/` (rolling).
- [ ] Flip **all repos** to thin pointers back to CoCache/public (no divergent rule copies).
- [ ] Ownership: rules (machine) → **CoPrime**; human views → **Docs** (enforced via CODEOWNERS).

---

## Indexing, Validation & Drift Control
- [ ] JSON Schema: `private/bpoe/registry.schema.json` (validate registry).
- [ ] JSON Schema: `private/bpoe/harvest.inventory.schema.json` (validate harvest inventories).
- [ ] CI: render `public/bpoe/BPOE_Rules.md` from registry; **fail on diff**.
- [ ] CI: org-wide **drift scan** for stray `docs/bpoe/**`; auto-open issues with fix suggestions.
- [ ] AI-index: `public/bpoe/index.json` mapping rule → receipts, harvest anchors, owning repos.

---

## Canonicality, Versioning & Licensing
- [ ] Machine-first canonical; human renders include footer with canonical path + version.
- [ ] Rule IDs: time-vector format (`BPOE-YYYY-MM-DD-RNNN`) supports insertions & reprioritization.
- [ ] License classes per asset: `public`, `community`, `restricted`, `HP57`. Renders show class.

---

## HP57 (lock before outreach)
- [ ] Add `sops` + `.sops.yaml` (Age keys) for `private/hp57/**` (machine SoT).
- [ ] CI: redact to `public/hp57/_index.md` with non-sensitive, time-boxed cues.
- [ ] **Advice-bomb ingest** → update `private/hp57/plan/HP_MASTER.json`; then deprecate zip; write stub.

---

## Parallelism (machine → human → multilingual)
- [ ] Define machine-first doc pipeline (GIBindex grammar) → human MD.
- [ ] Add multilingual renders via AI translation from machine source; mark render provenance and date.

---

## CoSync Discipline
- [ ] Every session emits a **RECEIPT.md** file (not chat).  
- [ ] Prefer **CoSync Stash** single-pointer handoffs; no local-only references.
- [ ] Open **CoSync-Delta** issues for anything found “only in chat.”

---

## Intent Harvest (auto-inputs for planning)
This plan expects ingestion from three sources:
1. `public/bpoe/receipts/**` → extract **next-3** and **risks/assumptions**
2. `advice/inbox/**.zip` → ingest ledger entries; map to HP57 chapters
3. Issues/PRs with labels `bpoe` / `seed:cosync` / `cosync` across org → append actionable deltas

*(See “Automation hooks” at end.)*

---

## Diagrams & Owned Paths (don’t break)
- Diagrams session owns: `docs/diagrams/**`, `docs/DIAGRAMS.md` (PRs must request owner review).
- Add CI check: JSON → Mermaid/D2 regenerators close fences; fail on diff.

---

## Outreach Readiness (gates)
- [ ] HP57 lock routine reviewed (no leaks); public cues intentional and time-boxed.
- [ ] BPOE rules stable; drift checks green for 7 days.
- [ ] Receipts cadence demonstrated across ≥3 sessions.

---

## Risk Log (rolling)
- [ ] Repo sprawl regression risk (mitigated by org-wide drift scan + pointer READMEs)
- [ ] Advice-bomb duplications (mitigated by ledger + stubs on deprecation)
- [ ] Multilingual render inconsistencies (mitigated by machine-first provenance & date footers)

---

## Done / Receipts
- [ ] Seeded registry + first public table
- [ ] Initial harvest + inventory captured
- [ ] This SESSION_PLAN.md published and PR opened

---

### Automation hooks (expected)
- `scripts/ci/bpoe-validate.ts` → schema-validate registry + inventories
- `scripts/ci/bpoe-render.ts`   → render public/BPOE_Rules.md and public/bpoe/index.json
- `scripts/ci/org-drift.ts`     → scan for stray `docs/bpoe/**`, open issues
- `scripts/hp57/ingest.ts`      → ledger → HP_MASTER updates, move zip to `advice/deprecated/`, create stub

## Megascroller — Linked Assets (discovered)

- Latest harvest inventory: private/bpoe/harvest/20251028/megascroller/  
  - JSON: private/bpoe/harvest/20251028/megascroller/inventory.megascroller.20251028_192027Z.json
  - Index: private/bpoe/harvest/20251028/megascroller/INDEX.megascroller.20251028_192027Z.md

### Next actions
- [ ] Review linked assets and decide **evolve vs deprecate**.
- [ ] If evolvable, reference canonical file(s) here and retire duplicates.
- [ ] If deprecated, add a short tombstone note in-place and point to canonical.

