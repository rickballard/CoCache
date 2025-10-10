# CoAgent — Business Plan (PRIVATE)

**Status:** 2025-09-10T00:38:33.6129529-04:00
**Owner:** Chris  
**Location:** docs/private (kept out of public remote)

## 1) Executive Summary
CoAgent coordinates multi-session repo work with guardrails (one watcher/session, structured DO handoffs, provenance). MVP builds on your current CoTemp runtime, then graduates to policy-gated orchestration.

## 2) Future-Needs Market & Problem
- Converging needs: multi-model + multi-session development, reproducible automations, human-in-the-loop safety.
- Pain today: duplicated watchers, conflicting automations, unclear ownership, weak audit trails.

## 3) Solution Overview
- Local runtime → CoAgent MVP → Policy/consent gates → Conflict awareness + provenance.
- Two-pane workflow (Planning/Migrate) proven on your box; generalizes to small teams.

## 4) Staged Product Roadmap
- **Stage 0 (now):** CoTemp runtime, DO/Note bridge, launcher, status tooling.
- **Stage 1 (MVP):** packaging, consent prompts, debounce/lockfile, compact-on-exit, minimal telemetry.
- **Stage 2:** policy modules, conflict detection & prompts, repo intents.
- **Stage 3:** team workflows, integrations, managed agent service.

(See diagram: `docs/private/diagrams/03_roadmap_sprints.drawio`)

## 5) UX Process Flow
Swimlanes: Human (Planning), Human (Migrate), Watchers, Filesystem Queues.  
(See diagram: `docs/private/diagrams/02_ux_flow.drawio`)

## 6) Architecture (Runtime → CoAgent)
- File queues per session (`inbox/`, `outbox/`, `logs/`)
- Watchers (one per session) with YAML header checks and audits
- Policy layer (MVP+): consent flags, risk gates, provenance ledger

(See diagram: `docs/private/diagrams/01_runtime.drawio`)

## 7) Business Model
- Free local kit; paid tiers for policy packs, team orchestration, managed service.
- Pricing hypotheses: Indie $X/mo; Team $Y/seat; Enterprise site license.

<!-- PRIVATE:BEGIN -->
## 8) Secret Sauce (PRIVATE)
- Lightweight, air-gapped-friendly coordination with *provable* safety rails.
- DO/Note primitives + policy gates produce an audit path competitors lack.
- Upgrade path: same local behaviors scale to team/managed without retraining users.
- Planned conflict heuristics + provenance hooks reduce review load at scale.
<!-- PRIVATE:END -->

## 9) GTM
- Seed with OSS / solo builders; showcase “minutes to safe concurrency.”
- Content: smokes, reproducible demos, starter repos; partner with small OSS teams.

## 10) Implementation Plan
- **Sprint 1:** stabilize runtime, docs/readme, smokes, two-tab launcher.
- **Sprint 2:** debounce/lockfile, compact-on-exit, minimal telemetry.
- **Sprint 3:** packaging (zip/winget), consent prompts, basic policy gates.
- Exit criteria: time-to-first-DO < 5 min; header pass > 95%; 0 duplicate watchers post-stabilize.

## 11) Metrics
- Leading: TTFD (time-to-first-DO), header pass rate, duplicate-watcher incidents.
- Lagging: retained weekly active repos; task success rate w/ consent.

## 12) Risks & Mitigations
- User confusion on watchers → Enforce-SingleWatcher + docs.
- Fragile DO headers → schema + validation + examples.
- Overreach into CI secrets → keep secrets out of MVP; explicit consent gates.

## 13) Competitive Landscape (summary)
- DIY scripts and generic agents lack policy/provenance and clean two-pane workflow.

## 14) Appendices
- Repo layout, DO header schema, risk flags, example smokes.
