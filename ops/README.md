# CoSuite Ops (central scheduler in CoCache)

**Source of truth** for scheduled jobs that co-evolve the repos:
- Heartbeats & ingestion snapshots
- Cross-repo dashboards/badges (e.g., RickDo)
- Sanitation scans, Hitchhiker scaffolding
- Future: repo-dispatch events to specialized workers (lint, doc refresh, evals)

## Where things live
- `.github/workflows/ops-heartbeat.yml` — schedules and triggers.
- `tools/update-rickdo.ps1` — renders metrics/badges and updates `rickballard/RickDo`.
- `STATUS/` — heartbeat and session logs that can trigger runs.

## Adding a new task
1. Create a script under `tools/`.
2. Add a job/step to the workflow to call it.
3. If pushing to another repo, add a fine-grained token in CoCache secrets and use `actions/checkout` with `token`.

> All automation runs *from CoCache*, so we can monitor & tune centrally.
