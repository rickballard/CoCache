# Migrate Stand‑Down Explainer

This note pack tells the **Migrate** pane to *stand down* from creating its own inbox watcher.
You already have a centralized watcher arrangement via CoTemp.

## What’s running

- `Start-CoQueueWatcher` jobs are launched by your launcher for the sessions:
  - `co-planning`
  - `co-migrate`

These jobs move safe, structured “DO” tasks from `sessions\<session>\inbox` to `outbox`, writing logs in `logs\`.

## Why stand down here?

Two independent watchers on the same machine can race and cause duplicate executions.
Until **CoAgent** is installed (with first‑class orchestration), keep a single coordinated watcher setup.

## What to keep doing in Migrate

- Continue the **ccts fallback** remediation work.
- Handle repository move/ops tasks.
- Use `Drop-CoDO` or place a DO into `Downloads\CoTemp\sessions\co-planning\inbox` to signal Planning.

## Utilities included

- `scripts/Mark-MigrateStandDown.ps1` — writes a stand‑down NOTE into `co-migrate` (and optional heads‑up to `co-planning`).
- `scripts/Status-QuickCheck.ps1` — quick inventory of inbox/outbox counts and last log, plus list of watcher jobs.

## Quick commands

```powershell
. "$HOME\Downloads\CoTemp\Join-CoAgent.ps1"
& "$HOME\Downloads\CoTemp\scripts\Mark-MigrateStandDown.ps1" -NotifyPlanning
& "$HOME\Downloads\CoTemp\scripts\Status-QuickCheck.ps1"
```
