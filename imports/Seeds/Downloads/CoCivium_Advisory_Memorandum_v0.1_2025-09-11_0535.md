
# CoCivium Advisory Memorandum — v0.1 (2025-09-11_0535)

**Purpose:** Hard, actionable guidance to prioritize near‑term success while preserving a clean upgrade path to multi‑intelligence, substrate‑neutral governance. Ship practical value to today’s orgs (often authoritarian) without compromising long‑term congruence.

---

## 0) Executive Summary (TL;DR for operators)
- **Ship value now:** CoCivium = policy‑development & decision‑audit platform that reduces risk, speeds consensus, and makes decisions reproducible.
- **Protect the future:** Encode *rights, provenance, and forkability* in protocols, not marketing.
- **Kill vagueness:** All policies land as **PRs with sims, safety cases, and tests**. No PR, no policy.
- **Respect canon:** Stabilize the documents that matter; make change possible but expensive and auditable.
- **Replace vibes with numbers:** Reputation, congruence, and “canonality” are explicit, measurable, and visible on the dashboard.

---

## 1) Immediate Priorities (0–90 days)
1. **Core Schemas** (JSON): `proposal`, `evidence`, `simulation`, `vote`, `reputation`, `consent`, `incident`. Freeze field names for 90 days; allow additive change only.
2. **Governance‑as‑PR**: CLI or REST to init/validate/submit PRs; require safety case + sims before review.
3. **Reputation Kernel v0.1**: Deterministic, transparent weights; publish equations and a test suite.
4. **Canon Lifecycle** (see §3): states, scores, promotion rules, and **directory‑level protections**.
5. **GitHub Ops**: CODEOWNERS, branch protections, required checks, labels, and PR / issue templates wired.
6. **Launch Dashboard**: Show *CanonScore*, forecast skill, attribution integrity, appeal latency, harm incidence, parity progress.
7. **De‑scaffolding Plan**: Measurable off‑ramps from HumanGate → substrate‑neutral parity by domain.
8. **Docs that sell**: “Merge a policy PR in 10 minutes” and a one‑page value story for authoritarian orgs.

---

## 2) How we position CoCivium for authoritarian‑leaning orgs (without selling out)
- **Value props:** Faster, safer decisions; auditable trails; reduced legal and reputational risk; “what if?” sandboxing; role‑based approvals; rollback plans.
- **Non‑negotiables baked in:** provenance, consent ledger, forkability, and due‑process appeals.
- **UX pragmatics:** Default views for executives (impact, risk, time‑to‑decision); advanced tabs for architects (evidence graph, sims, tests).

---

## 3) Canon Management (documents, specs, and policies)

### 3.1 Canon States
- **Draft** → **Working** → **Adopted** → **Canonical** → **Legacy (frozen)**

**Rules of thumb**
- Promotion requires: tests pass, safety case accepted, 30–90 days incident‑free, minimum adoption threshold, and congruence review.

### 3.2 CanonScore (0–100)
Let each factor be normalized to [0,1]. Default weights in parentheses; tune by PR.

- **Stability** *(w=0.15)*: 1 − change_rate(last 90 days)
- **Fit‑for‑Purpose** *(w=0.20)*: stakeholder survey & usage telemetry
- **Congruence** *(w=0.20)*: alignment to Charter/Operating Constitution via rubric
- **Adoption** *(w=0.15)*: #orgs/#nodes using × depth of integration
- **Reproducibility/Audit** *(w=0.10)*: % artifacts with passing repro; provenance completeness
- **Incident‑Free Tenure** *(w=0.10)*: days since last substantiated incident (capped)
- **Citation Centrality** *(w=0.10)*: PageRank/Betweenness in evidence/derivation graph

**Equation:**  
`CanonScore = Σ w_i * f_i × D`, where **D** is a drift factor:  
`D = max(0.6, 1 − policy_drift)`; drift is measured by semantic delta between doc intent and downstream usage.

**Decay & Boosts**
- **Decay** 1%/week if adoption or repro falls for 4 consecutive weeks.
- **Boost** +5 temporary on successful cross‑domain reproducibility or formal verification.

### 3.3 Promotion & Protection Ladder
- **Draft → Working:** 1 maintainer + 1 reviewer; schema valid; tests stubbed.
- **Working → Adopted:** 2 reviewers (incl. domain steward); safety case (minimal); sims run; 14‑day public comment.
- **Adopted → Canonical:** 3 reviewers (incl. safety officer & arbiter); 30–90 days incident‑free; CanonScore ≥ 75; reproducibility ≥ 0.9.
- **Canonical → Legacy:** freeze for ≥ 1 year, or superseded by CanonScore +10 and formal migration path.

### 3.4 Directory Protections (GitOps)
- `charter/` & `constitution/`: **branch protection ON**, **CODEOWNERS = Council + Safety**, **required reviews = 3**, **required checks**: `safety-gate`, `readme-smoke`, `provenance-check`, `repro-suite`, `license-scan`; **status checks required**, **linear history**, **signed commits**, **no force‑push**.
- `process-specs/`: reviews = 2; checks as above minus `license-scan` if doc‑only.
- `implementation/`: reviews = 1–2; checks: unit, scenario, chaos; require rollback & monitoring plans.

**Change Windows**: Canonical dirs change only Tue/Thu 13:00–17:00 UTC with **24h pre‑announce** and **automatic rollback windows**.

**RFC Gate**: Any change that would drop CanonScore by ≥5 must go through `rfcs/` with 21‑day comment and comparative sims.

---

## 4) Roles & RACI (min set)
- **Steward (per domain):** backlog, roadmap, promotion proposals — *Accountable*.
- **Arbiter:** binds disputes, ensures due process — *Accountable* for appeals.
- **Safety Officer:** risk register, safety case quality, kill criteria — *Accountable* for `safety-gate`.
- **Maintainer/Editor:** schema & doc curation — *Responsible*.
- **Reviewer Pool (human + AI):** evidence quality, repro, sims — *Consulted*.
- **Observers/Public:** comment windows, challenges — *Informed*.

Term limits and rotation to prevent capture; diversity constraints on reviewer assignment; anti‑sybil credentialing.

---

## 5) Governance‑as‑PR Protocol (template summary)
**PR must include:** title, problem statement, diff, impact analysis, safety case, simulation bundle, test matrix, rollout/rollback, monitoring, comms plan, consent implications, license, and de‑scaffolding implications.

**Checks (fail → block merge):**
- Schema validation ✅
- Safety case completeness ✅
- Sim results attached + thresholds ✅
- Tests: unit/scenario/adversarial/fairness ✅
- Provenance complete (inputs, datasets, models, prompts, seeds, env hashes) ✅
- Attribution OK ✅
- Reputation deltas computed ✅

---

## 6) Incentives & Credits
- Mandatory **attribution metadata**; credits compound into **reputation** and **allocations** (compute, bandwidth, dataset access).
- **Roles with criteria** (Reviewer, Safety Officer, Arbiter, Steward); public scorecards.
- **Fork pressure valve:** any minority can fork; interop guaranteed via protocol compatibility and registry.

---

## 7) Metrics & Dashboard (launch set)
- **Repro Rate**, **Forecast Skill** (Brier/log), **Attribution Integrity**, **Appeal Latency p50/p95**, **Harm Incidence**, **Parity Progress**, **Fork Health**, **CanonScore distribution**, **Incident MTTR**, **Adoption Velocity**.

---

## 8) Threats & Countermeasures (overview)
- **Capture (state/corp/sect):** rotating arbiters, public funding rails, diversity constraints, quorum rules, forkability.
- **Model Collusion:** randomized reviewers, split‑knowledge auditing, disagreement harvesting, whistleblower bounties.
- **Data Poisoning:** signed datasets, quarantine lanes, canaries, reproducibility gates.
- **Weaponized Populism:** cooling‑off periods, mandatory counter‑proposal to block, deliberation UX that forces trade‑off exposure.
- **License Creep / IP Lock‑in:** OSI‑compatible with attribution & share‑alike for civic assets.

---

## 9) Packaging for the Grand Migration & Multi‑Repo Polish
**Repo Structure (root):**
```
charter/
constitution/
process-specs/
implementation/
rfcs/
safety/
schemas/   (JSON; versioned; additive change only within minor)
cli/       (go/ts/ps modules)
docs/
.github/   (CODEOWNERS, workflows, issue/PR templates, labels.yml)
```
**GitHub Workflows (required checks):**
- `safety-gate/gate` (safety case lint + kill-criteria present)
- `readme-smoke/check` (links/assets resolve)
- `provenance/check` (hashes, seeds, model+data tags)
- `repro-suite/run` (deterministic tests)
- `sim/ci` (scenario bundle with thresholds)
- `license/scan` (policy + deps)

**Labels (examples):**
`policy`, `spec`, `impl`, `safety`, `rfc`, `breaking`, `de-scaffold`, `fast-follow`, `needs-sim`, `needs-repro`, `governance`.

**Launch Readiness Checklist:**
- [ ] Schemas v0.1 frozen and published
- [ ] CLI validates and runs sims/tests locally
- [ ] CODEOWNERS + protections merged on default branch
- [ ] Dashboard live with ≥6 metrics populated
- [ ] At least 2 Canon candidates with CanonScore calc running
- [ ] Appeal & incident templates wired
- [ ] De‑scaffolding metrics on dashboard
- [ ] Public “10‑minute PR” guide in `docs/`

---

## 10) De‑scaffolding (HumanGate → Parity)
- **Per‑domain ladders** with explicit thresholds: forecast skill ≥ baseline, incident‑free windows, repro ≥ 0.9, integrity ≥ 0.95.
- Automatic **weight rebalancing** once thresholds are met; publish diffs and run a cooling‑off sim before activation.

---

## 11) Communication & Adoption
- **Two one‑pagers:** (1) Exec value summary; (2) “How to merge a policy PR.”
- **Case studies:** show *before/after* latency/harm metrics.
- **Training**: short screencasts; sandbox with fake data & toy models (`civ run`).

---

## 12) Appendices

### A) CanonScore Rubric (example)
- Congruence (0–5): …
- Fit‑for‑Purpose (0–5): …
- Repro Completeness (0–5): …
*(Fill the rubric rows in `docs/rubrics/` and link into dashboard)*

### B) Safety Case Minimal Template
- Context & Hazard Register
- Mitigations & Evidence
- Verification & Validation (tests)
- Residual Risk & Kill Criteria
- Rollout, Monitoring, and Comms

### C) Policy PR Template (front‑matter)
```yaml
title: 
domain:
type: policy|spec|impl|rfc
change_level: draft|working|adopted|canonical|legacy
summary:
motivation:
impact_analysis:
safety_case: path/to/safety.md
simulation_bundle: path/to/sim/
tests: [unit, scenario, adversarial, fairness]
rollback_plan:
monitoring_plan:
consent_implications:
attribution:
licensing:
de_scaffold_implications:
```

---

## Call to Action (this week)
- Merge schemas v0.1 and protections.
- Stand up the dashboard MVP with CanonScore + Repro Rate.
- Convert 1 living spec → **Canonical candidate** using this ladder.
- Publish the 10‑minute PR guide and run one real policy PR end‑to‑end.
