# Migrate Pane — Stand-Down & Status Pack

This folder explains what is already running and gives you one-click helpers to
**stand down** from spinning up your own watcher while you continue fixing the
**ccts fallback issue**.

## What is already running

- Two sessions are paired by the launcher you installed:
  - **Planning** session id: `co-planning`
  - **Migrate**  session id: `co-migrate`
- Each has a background watcher job that reads safe DO files from
  `Downloads\CoTemp\sessions\<session>\inbox` and moves results to `outbox` and `logs`.

The watcher was started by: `CoAgentLauncher.ps1` (which in turn uses
`Join-CoAgent.ps1`, `common\CoWatcher.ps1`, and `common\CoPanels.ps1`).

## Verify in the MIGRATE PowerShell pane

```powershell
# 1) Load session helpers
. "$HOME\Downloads\CoTemp\Join-CoAgent.ps1"

# 2) Confirm panels and jobs
Get-CoPanels | Format-Table name,session_id,pid
Get-Job | Where-Object { $_.Name -like 'CoQueueWatcher-*' } | Format-Table Name, State

# 3) Quick counts
$S = Join-Path $HOME "Downloads\CoTemp\sessions\co-migrate"
dir "$S\inbox"  -ErrorAction SilentlyContinue | measure
dir "$S\outbox" -ErrorAction SilentlyContinue | measure
dir "$S\logs"   -ErrorAction SilentlyContinue | sort LastWriteTime -desc | select -first 2 Name,LastWriteTime
```

## Stand down from spinning up another watcher

Run the helper (writes a `STAND_DOWN.txt` marker and notifies Planning):

```powershell
. "$HOME\Downloads\CoTemp\Join-CoAgent.ps1"
& "<unzipped>\scripts\Mark-MigrateStandDown.ps1"
```

If `Send-CoNote` is not available, the script will drop a `NOTE_*.md` into
`co-planning\inbox` so the Planning watcher will see it in the next loop.

## Continue with the ccts fallback issue

Work this separately from the watcher. Suggested checklist:

- [ ] Reproduce the ccts fallback behavior with a minimal case.
- [ ] Identify the fallback trigger (config flag / missing resource / error path).
- [ ] Add guard and explicit log when fallback is engaged.
- [ ] Provide a bypass or deterministic selection if multiple fallbacks exist.
- [ ] Write a unit-style DO that asserts the non-fallback path and logs the decision.
- [ ] Add notes to `ISSUEOPS.md` about how to detect and recover.

## Open reference docs

```powershell
& "<unzipped>\scripts\Open-CoDocs.ps1"
```

## What not to do (to avoid conflicts)

- Do **not** start another watcher loop in the migrate pane.
- Do **not** write directly into `outbox` or modify `logs` files.
- Keep using `Drop-CoDO` / `New-CoHelloDO` or manual DO files in **inbox** only.
- If you must change watcher behavior, patch the copy under `Downloads\CoTemp\common`
  and restart the jobs from the **launcher**, not from here.

--
Generated: 2025-09-09 05:08:34
