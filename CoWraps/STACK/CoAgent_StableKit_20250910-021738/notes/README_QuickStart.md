# CoAgent Stable Kit (Minimal)

This kit stabilizes your pre‑CoAgent workflow using **CoTemp** folders:

- Global logs in `~/Downloads/CoTemp/logs`
- One background watcher job (`CoInboxWatcher`) that runs `*.ps1` dropped into `~/Downloads/CoTemp/inbox` (optionally tag-filtered)
- Reliable DO runner that prints which engine ran (pwsh vs powershell)

## Install

1. Extract this zip **into** `~/Downloads/CoTemp` (overwrite is fine).
2. Start the watcher:
   ```powershell
   Set-ExecutionPolicy -Scope Process Bypass -Force
   & "$HOME\Downloads\CoTemp\scripts\Start-CoWatchers.ps1" -Tag 'gmig'
   ```
3. Queue a smoke:
   ```powershell
   'Write-Host ("PSHOME={0}" -f $PSHOME); $PSVersionTable.PSVersion' | Set-Clipboard
   & "$HOME\Downloads\CoTemp\_shared\Send-DOFromClipboard.ps1" -Name 'ping' -Tag 'gmig'
   ```
4. Tail latest log:
   ```powershell
   Get-ChildItem "$HOME\Downloads\CoTemp\logs" -File |
     Sort LastWriteTime -desc | Select -First 1 |
     % {{ "Log: $($_.FullName)"; Get-Content $_.FullName -Tail 40 }}
   ```

## Two-pane launcher (optional)
Double‑click `Start-CoAgentLauncher.bat` to open **Planning** and **Migrate** panes; it prefers PS7, falls back to Windows PowerShell.
