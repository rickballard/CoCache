# CoAgent Ready Pack v3 — Apply Instructions

This pack adds *missing docs* and *ready-to-run scripts* for the two-pane workflow (Planning + Migrate)
and the CoTemp backchannel. It is **idempotent**—safe to apply even if you already have pieces in place.

## TL;DR
1. Unzip this file.
2. **If you're on Windows:** copy the `CoTemp` folder into `C:\Users\<you>\Downloads\CoTemp` (merge).
3. Copy the `BusinessPlan_Additions` contents into `C:\Users\<you>\Desktop\CoAgent_BusinessPlan` (merge).
4. Open a PowerShell window and run:
   ```powershell
   . "$HOME\Downloads\CoTemp\Join-CoAgent.ps1"
   & "$HOME\Downloads\CoTemp\scripts\Verify-CoAgentSetup.ps1"
   ```
5. If anything is **Missing**, run:
   ```powershell
   & "$HOME\Downloads\CoTemp\scripts\Install-CoAgent-ReadyPack.ps1"
   ```
6. Launch the two-pane watchers and open two Chat tabs:
   ```powershell
   & "$HOME\Downloads\CoTemp\CoAgentLauncher.ps1" -OpenBrowser
   ```

---

## What’s inside

### 1) `BusinessPlan_Additions/`
- `RFCs/RFC-0002_MultiModel_Orchestration_v0.1.md` — consensus & multi-model architecture
- `Tests/Consensus_Test_Plan_P1.md` — test plan for P1 consensus
- `Runbooks/Two-Chat_Operations.md` — how the two chat panes and CoTemp watchers work
- `Notes/CCTS_Fallback_Fix_Notes.md` — placeholder for the current “ccts fallback” effort

### 2) `CoTemp/`
- `Join-CoAgent.ps1` — session bootstrap (autoloads `common\*.ps1`)
- `CoAgentLauncher.ps1` — starts **two** watcher jobs (co-planning + co-migrate) and can open two ChatGPT tabs with greetings
- `common/`
  - `CoWatcher.ps1` — stable-file gate + queue watcher (PS 5.1–compatible)
  - `CoPanels.ps1` — panel registry + cross-drop helpers
  - `New-CoHelloDO.ps1` — convenience to queue a hello “DO” file
  - `NoteBridge.ps1` — simple note backchannel (optional)
- `scripts/`
  - `Verify-CoAgentSetup.ps1` — checks what’s present
  - `Install-CoAgent-ReadyPack.ps1` — idempotent installer that (re)lays down the above
  - `Mark-MigrateStandDown.ps1` — sends a “stand down” note to Migrate and info note to Planning
  - `Status-QuickCheck.ps1` — quick status table + jobs

- `greetings/` — “Planning” and “Migrate” greetings (also copied to clipboard by launcher).

---

## After applying

- **Migrate** pane should *stand down* from building its own watcher. Use the shared watchers started by the launcher.
- Keep working on the **ccts fallback** issue in the Migrate pane; use `Send-CoNote` to checkpoint status to Planning.
- If a pane gets out of sync, you can safely re-run the launcher:
  ```powershell
  & "$HOME\Downloads\CoTemp\CoAgentLauncher.ps1" -OpenBrowser
  ```

