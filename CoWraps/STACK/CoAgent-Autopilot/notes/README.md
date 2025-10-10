# CoAgent Autopilot

Generated: 2025-09-15 22:32:26

## What this does
- Installs the **CoAgent Pickup Kit** from your Downloads (zip or folder).
- Repairs the profile dropper snippet so it's not duplicated.
- Builds and verifies the Electron **win-unpacked** app (so Pair-CoSession can launch it).
- Creates a hidden Startup VBS to run InboxWatcher silently.
- Creates three desktop shortcuts (PS7 Tabs, CoAgent Panel, Dev two-tab).
- Pairs your session (`COAGENT_SESSION`) non-blockingly.
- Optionally pulls in a protected CoAgent Business Plan ZIP from **CoCache** if present (prompts for password).
- Optionally opens a PR (squash) if a git remote and `gh` are available.

## Usage
Open **PowerShell 7** and run:

```powershell
Set-ExecutionPolicy -Scope CurrentUser Bypass -Force
pwsh -File .\CoAgent-Autopilot.ps1
```

Flags:
- `-RepoPath "C:\Users\Chris\Documents\GitHub\CoAgent"` (default)
- `-Session "Productize backchatter"`
- `-SkipPR` (to avoid PR creation)
- `-Force` (allow overwrites when safe)
