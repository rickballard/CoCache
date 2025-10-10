# Migration Session: Stand Down & Status

This pack gives two small, PS 5.1–safe tools for the pre-CoAgent two-session setup.

## What is already running

- A shared CoTemp folder at `~/Downloads/CoTemp`
- Two sessions by convention: `co-planning` and `co-migrate`
- One background watcher job per session (started by `CoAgentLauncher.ps1`):
  - Watches `.../sessions/<session-id>/inbox` for DO_*.ps1 (after stable-file gate)
  - Writes outputs to `outbox/` and logs to `logs/`

**Do not** install another watcher; it’s already handled.

## Files in this pack

- `scripts/Mark-MigrateStandDown.ps1` — leaves a “stand down” note in `co-migrate` (and optionally notifies `co-planning`).
- `scripts/Status-QuickCheck.ps1` — shows a quick table of per-session inbox/outbox counts and the latest log file, plus watcher jobs.

## Quick use

```powershell
. "$HOME\Downloads\CoTemp\Join-CoAgent.ps1"

# Leave a stand-down note in co-migrate and notify planning
& "$HOME\Downloads\CoTemp\scripts\Mark-MigrateStandDown.ps1" -NotifyPlanning

# Or only mark migrate:
& "$HOME\Downloads\CoTemp\scripts\Mark-MigrateStandDown.ps1"

# See quick status
& "$HOME\Downloads\CoTemp\scripts\Status-QuickCheck.ps1"
```

## Still pending (separate work)

- Continue fixing the ccts fallback issue (tracked separately).

If anything looks off, run: `Get-CoAgentStatus` from `CoAgentLauncher.ps1`.
