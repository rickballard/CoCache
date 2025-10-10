# CoAgent Workbench Min-Kit

This kit launches a repo-independent workbench with a small CoTemp toolset and a file-based backchannel.

## Install
1. Extract this folder anywhere (e.g., `C:\Users\YOU\Downloads\CoAgent.Workbench\`).
2. Create a desktop shortcut to `Start-Workbench.bat`.
3. Double-click the shortcut. If PowerShell 7 isn't installed, the official install page opens.

## What you get
- Self-contained startup (`Start-Workbench.bat` → `Start-CoAgent.ps1`), no local repo required.
- CoTemp folders under `Downloads\CoTemp\` with `_shared` helpers and `scripts`.
- A lightweight inbox watcher that runs only files whose names match an optional tag.
- Clipboard helpers for "DO" snippets.

## Common commands (inside the launched PS7 window)
Paste something to the clipboard and save/run it:
```powershell
Save-DOFromClipboard.ps1 -Name "hello" -Tag "gmig" -Run
```

Drop an inbox DO (processed by the watcher):
```powershell
'inbox ping' | Set-Content "$HOME\Downloads\CoTemp\inbox\$(Get-Date -Format yyyyMMdd-HHmmss)-gmig-ping.ps1"
```

Start/stop watcher manually:
```powershell
& "$HOME\Downloads\CoTemp\scripts\Start-CoWatchers.ps1" -Tag 'gmig'
& "$HOME\Downloads\CoTemp\scripts\Stop-CoWatchers.ps1"
```

Check status:
```powershell
& "$HOME\Downloads\CoTemp\scripts\Status-QuickCheck.ps1"
```

## Notes
- All effects are process-scoped; closing the workbench window leaves your system untouched.
- The kit seeds/updates `Downloads\CoTemp\_shared` and `scripts` on every launch (safe and idempotent).
- The watcher ignores files that don’t match the tag (if a tag is supplied).
