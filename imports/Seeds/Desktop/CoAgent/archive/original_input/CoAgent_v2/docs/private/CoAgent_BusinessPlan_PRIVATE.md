# CoAgent — Business Plan (PRIVATE)

**Status:** 2025-09-10T05:05:55.645033  
**Owner:** Chris  
**Location:** docs/private (kept out of public remote)

## 1) Executive Summary
CoAgent coordinates multi-session repo work with guardrails (one watcher/session, structured DO handoffs, provenance). MVP builds on the current CoTemp runtime, then graduates to policy-gated orchestration for teams.

## 2) Market & Problem (“Future‑Needs”)
- Converging needs: multi-model + multi-session development, reproducible automations, and human-in-the-loop safety.
- Pain today: duplicated watchers, conflicting automations, unclear ownership, weak audit trails, and inconsistent provenance.
- Target early adopters: solo builders, OSS maintainers, small internal tool teams.

## 3) Solution Overview
- Local runtime → CoAgent MVP → Policy/consent gates → Conflict awareness + provenance ledger.
- Two-pane workflow (Planning/Migrate) proven locally; generalizes to small teams and beyond.
- File-based queues and idempotent scripts keep the system transparent and auditable.

## 4) Staged Product Roadmap
- **Stage 0 (now):** CoTemp runtime, DO/Note bridge, launcher, status tooling.
- **Stage 1 (MVP):** packaging, consent prompts, debounce/lockfile, compact-on-exit, minimal telemetry.
- **Stage 2:** policy modules, conflict detection & prompts, repo intents.
- **Stage 3:** team workflows, integrations, managed agent service.

(See diagrams in `docs/diagrams/`.)

## 5) UX Process Flow
Swimlanes: Human (Planning), Human (Migrate), Watchers, Filesystem Queues.  
Key interactions: bounded DOs with headers → watcher validation → logs → notes for cross-pane comms.

## 6) Architecture (Runtime → CoAgent)
- File queues per session (`inbox/`, `outbox/`, `logs/`).
- Watchers (one per session) with YAML header checks and audits.
- Policy layer (MVP+): consent flags, risk gates, provenance ledger (append-only).
- Extensible “DO schema” for richer tasks (risk, repo, intent, consent).

## 7) Business Model
- Free local kit; paid tiers for policy packs, team orchestration, and managed service.
- Pricing hypotheses (to validate):
  - Indie: $12–$19/mo
  - Team: $15–$29/seat/mo
  - Enterprise: $10k–$50k/yr (bundle seats + policy packs + SSO/compliance)

<!-- PRIVATE:BEGIN -->
## 8) Secret Sauce (PRIVATE)
- Lightweight, air‑gapped‑friendly coordination with *provable* safety rails.
- DO/Note primitives + policy gates produce an audit path competitors lack.
- Upgrade path: same local behaviors scale to team/managed without retraining users.
- Conflict‑aware heuristics and provenance hooks reduce review load at scale.
- Opinionated two‑pane workflow crafts a repeatable “day-2” ops story for agents.
<!-- PRIVATE:END -->

## 9) Go‑To‑Market (GTM)
- Seed with OSS / solo builders; showcase “minutes to safe concurrency.”
- Content: smokes, reproducible demos, starter repos; partnerships with small OSS teams.
- Channels: GitHub, Discord/Slack communities, developer podcasts.
- Land‑and‑expand: individual → small teams → enterprise departmental licenses.

## 10) Implementation Plan
- **Sprint 1:** stabilize runtime, docs/readme, smokes, two‑tab launcher.
- **Sprint 2:** debounce/lockfile, compact-on-exit, minimal telemetry.
- **Sprint 3:** packaging (zip/winget), consent prompts, basic policy gates.
- Exit criteria: time‑to‑first‑DO < 5 min; header pass > 95%; 0 duplicate watchers post‑stabilize.

## 11) Metrics
- Leading: TTFD (time‑to‑first‑DO), header pass rate, duplicate‑watcher incidents.
- Lagging: weekly active repos, task success rate w/ consent, paid seat conversion.

## 12) Risks & Mitigations
- User confusion on watchers → Enforce‑SingleWatcher + docs/checklists.
- Fragile DO headers → schema + validation + examples.
- Overreach into CI/secrets → keep secrets out of MVP; explicit consent gates.
- Competitive pressure → lean wedge (two‑pane + provenance) and tight scope.

## 13) Competitive Landscape (summary)
- IDE‑embedded assistants and code‑gen tools: strong at single‑shot tasks, weak at multi‑session provenance.
- Agent frameworks: powerful orchestration but heavy/opaque for day‑to‑day repo work.
- CoAgent’s wedge: explicit, auditable handoffs; guardrails that match how humans actually collaborate.

## 14) Financial Model (10‑yr scenarios — illustrative only)
See `docs/private/Financials_10yr_model.csv` for conservative/base/upside scenarios based on adoption and pricing assumptions.

## 15) Appendices
- Repo layout, DO header schema, risk flags, example smokes.
