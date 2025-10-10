# CoAgent — MVP PRD (Draft)

## Problem
Concurrent repo work across chats/terminals causes conflicts, duplicate automations, and weak provenance.

## Audience
- Solo builders (first tester), then small OSS teams (e.g., GroupBuild.org).
- OSS contributors coordinating via issue/PR workflows.

## Jobs To Be Done
- Run two+ coordinated agent sessions against one/more repos with minimal setup.
- Queue bounded, reviewable tasks (DOs) and status notes across sessions.
- Avoid conflicting automations; keep a single, auditable runtime path.

## Value Proposition
- **Safer concurrency** via one watcher/session + structured DO handoff.
- **Low‑friction** local runtime that upgrades to full CoAgent later.
- **Provenance**: logs/audits per DO and session.

## MVP Scope
- CoTemp runtime (Join script, panel registry, one watcher per session).
- DO/Note bridge: `Drop-CoDO`, `Send-CoNote`.
- Launcher: two chat tabs + optional docs tabs.
- Status tooling: `Status-QuickCheck`.
- Packaging: Starter Kit zip with README_FIRST and runbook.

## Non-Goals (MVP)
- Cloud orchestration, auth/secrets brokering, multi-repo transactional merges.
- Full conflict adjudication UI (log + prompt only).

## Principles
- Idempotent scripts; no writes/network without explicit consent.
- Human-in-the-loop for risky actions.
- Plain files in `Downloads\CoTemp` for easy debugging.

## Architecture
- Two PS watcher jobs (Planning & Migrate) monitor per-session inboxes.
- DOs carry YAML headers: title, repo, risk, consent.
- Notes are plain text; logging to per-session logs/outbox.

## Risks & Mitigations
- Duplicate watchers → Enforce-SingleWatcher + registry compaction.
- Bad DO headers → header test + reject to outbox.
- Paste errors → Launcher opens tabs and drops greetings; clipboard primed.

## Success Metrics
- Time-to-first-successful-DO (<5 min), header pass rate (>95%).
- Zero duplicate watchers after stabilize; <1 conflict/day during migration work.

## Release Plan
- Sprint 1: stabilize runtime, docs/readme, smoke tests, two-tab launch.
- Sprint 2: debounce/lockfile, compact-on-exit, minimal telemetry.
- Sprint 3: packaging prototype; policy gates; simple consent prompts.

## Ops
See: `docs/OPS_Quickstart.md`

## Open Questions
- Packaging target (winget/zip/choco)?
- Default repo sandbox location & permissions?
- Consent prompts UI vs. DO flags?

— end —
