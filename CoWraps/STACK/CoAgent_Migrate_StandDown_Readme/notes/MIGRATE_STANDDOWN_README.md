# Migrate Session — Stand Down (pre‑CoAgent watcher)

Timestamp: 2025-09-09 06:04:31

This workstation is running a **shared CoTemp watcher**. Two sessions are paired:

- **Planning** — `co-planning`
- **Migrate**  — `co-migrate`

The watcher jobs are already started and coordinate through `~/Downloads/CoTemp/sessions/<id>/`.

## What to do (Migrate)

1) **Do NOT start another inbox watcher** here.
2) Keep working on the **ccts fallback** remediation (priority), and send checkpoints to Planning.

### How to message Planning
```powershell
Send-CoNote -ToSessionId 'co-planning' -Text "Migrate: ccts fallback checkpoint — <one-liner status>."
```

### How to check status
```powershell
& "$HOME\Downloads\CoTemp\scripts\Status-QuickCheck.ps1"
```

### How to queue a task (DO) to Planning
Create a `.ps1` with the standard header and drop it in:
```
$HOME\Downloads\CoTemp\sessions\co-planning\inbox
```

Example helper (if `Drop-CoDO` is loaded):
```powershell
Drop-CoDO -To 'co-planning' -Title 'DO-Example' -Body @'
"Ran at $(Get-Date -Format o)"
$PSVersionTable.PSVersion
'@
```

## Tips & Maintenance

- To surface incoming notes here:
```powershell
Start-CoNoteReader -Loop
```

- To keep watchers in the background:
```powershell
Start-CoQueueWatcherJob -SessionId 'co-planning' -PanelName 'Planning'
Start-CoQueueWatcherJob -SessionId 'co-migrate'  -PanelName 'Migrate'
```

- To stop all watcher jobs:
```powershell
Get-Job | Where-Object {{ $_.Name -like 'CoQueueWatcher-*' }} | Stop-Job -PassThru | Remove-Job
```

- If `Status-QuickCheck` shows duplicate panel rows, clean stale panel records:
```powershell
$panelDir = Join-Path $HOME 'Downloads\CoTemp\panels'
Get-ChildItem "$panelDir\*.json" -ea SilentlyContinue | ForEach-Object {{
  try { $rec = Get-Content -Raw -LiteralPath $_.FullName | ConvertFrom-Json
        if (-not (Get-Process -Id $rec.pid -ErrorAction SilentlyContinue)) {{ Remove-Item -LiteralPath $_.FullName -Force }} }
  catch {{}} }}
```

## Why stand down?
Having multiple watchers per session races file moves and logs, creating duplicate runs and noise. The shared watcher keeps **Planning** and **Migrate** in sync and prevents conflicts until **CoAgent** replaces this with first‑class orchestration.

— End —