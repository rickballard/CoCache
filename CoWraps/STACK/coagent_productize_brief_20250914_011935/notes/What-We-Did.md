# What We Did (Grand Migration → Productize handoff)

**Date:** 2025-09-14 01:19:35Z

## Observations
- Boot displayed PS7 popups (“Launch Profile”, “CoAgent Migrate”, “CoAgent Planning”). A blank popup flickered and stole focus, interrupting typing.
- CoAgent behavior felt non-ephemeral and intrusive when no repo context existed.
- Inter-session communication via `CoTemp` needed top-level `inbox` and quiet watchers; some sessions didn’t see earlier messages.

## Steps Taken
- Dropped standardized messages into **top-level** `~/Downloads/CoTemp/inbox`:
  - `productize_*.json` (to: `productize` tag)
  - `profile_*.json` (to: `profile` tag)
  - `ping_productize_*.json` smoke ping
- Provided a quiet watcher (`Start-CoInboxWatcher.ps1`) that filters by `to` tag and writes acks to `~/Downloads/CoTemp/Logs`.
- Rebuilt a **CoOps** module (in user environment) to:
  - Sweep stale `gm/*` branches with no open PR (local + remote, age ≥ 7 days).
  - Generate constellation reports: `PR-TRIAGE.md`, `MASTER-MANIFEST.md`, `STALE-GM.md` (written under `CoCache/docs/status`).

## Requirements Emphasized
- Ephemeral by default; resident only with explicit consent.
- Stealth: no focus steal; surface only on repo-context.
- Device-local, transparent profile at `~/Downloads/CoTemp/Profile`.
- Respect session priority: GM leads; Productize observes and leaves breadcrumbs.
- Standard CoTemp protocol; quiet, backoff polling; write acks.
