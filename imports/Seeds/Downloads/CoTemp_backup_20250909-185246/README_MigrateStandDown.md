# CoTemp Dual‑Session Orchestration — **Migrate** Panel Stand‑Down

**Status:** Active dual‑session setup is already running. This pane (“Migrate”) is paired with **Planning**.
Background watchers were launched by **CoAgentLauncher** and are supervising both sessions.

---

## What’s running

- **Sessions:** `co-planning` (Planning) and `co-migrate` (Migrate)
- **Roots:** `~/Downloads/CoTemp/sessions/<session-id>/`
  - `inbox/`  — drop‑zone for tasks (**DO_*.ps1**) and notes (**NOTE_*.md**)
  - `outbox/` — processed tasks copied here with run id in the name
  - `logs/`   — `*.txt` human logs and `*.json` structured logs per run
- **Watchers:** Started as background jobs by `CoAgentLauncher.ps1`
  - Jobs are named like `CoQueueWatcher-<session-id>`
  - They implement a file‑stability gate and a minimal DO‑header check

**Important:** Do **not** start additional watchers from this pane (to avoid double execution).
Focus this pane on migration tasks only.

---

## Your remit in this pane

1) **Stand down** from building another watcher/autorun system.
2) Continue working on the **“ccts fallback issue”** as a separate effort.
3) Use the shared CoTemp back‑channel for coordination:
   - Send simple notes to Planning:
     ```powershell
     Send-CoNote -ToSessionId 'co-planning' -Text "Migrate: ccts fallback fix underway, next checkpoint <time>."
     ```
   - Queue a structured DO for Planning (optional):
     ```powershell
     Drop-CoDO -To 'co-planning' -Title 'DO-MigrateStatus' -Body @'
"Status ping at $(Get-Date -Format o)"
'@
     ```

---

## Quick checks

```powershell
# Load env + helpers (idempotent)
. "$HOME\Downloads\CoTemp\Join-CoAgent.ps1"

# One-line status table
& "$HOME\Downloads\CoTemp\scripts\Status-QuickCheck.ps1"

# Watcher jobs
Get-Job | Where-Object { $_.Name -like 'CoQueueWatcher-*' } | Format-Table -Auto

# Latest log for this session
$S = Join-Path $HOME "Downloads\CoTemp\sessions\$env:COSESSION_ID"
Get-ChildItem "$S\logs" | Sort-Object LastWriteTime -desc | Select-Object -First 1 | % { gc $_.FullName -Tail 40 }
```

If you ever need to **restart** the jobs:
```powershell
# Stop all CoAgent watcher jobs
Stop-CoAgentLauncher

# Start them again (also able to open docs/tabs if you pass -OpenBrowser)
& "$HOME\Downloads\CoTemp\CoAgentLauncher.ps1"
```

---

## Safety defaults (pre‑CoAgent mode)

- DOs must start with a header block between `<# --- ... --- #>` containing:
  `title`, `repo`, `risk`, `consent`.  
- Execution defaults are **read‑only**, no network, no secrets, no destructive ops
  unless consent flags are explicitly set true in the DO header.
- Logs contain **no secrets**; per‑run JSON + TXT are produced.

---

## Directory map (Windows)

```
%USERPROFILE%\Downloads\CoTemp\
  common\            # helpers autoloaded by Join-CoAgent.ps1
  panels\            # panel registry (JSON), used for addressing
  sessions\
    co-planning\ {inbox,outbox,logs}
    co-migrate\  {inbox,outbox,logs}
  scripts\           # utility scripts (e.g., Status-QuickCheck.ps1)
  CoAgentLauncher.ps1
  Join-CoAgent.ps1
```

---

## Pasteable greeting for this Chat tab (Migrate)

Use this in the “Migrate” Chat tab so both sides are aligned.

> Hi! I’m **CoAgentLauncher – Migrate panel** (`co-migrate`).  
> A paired **Planning** chat (`co-planning`) is already running; both are coordinated via **CoTemp** watchers.  
> I’m standing down from building another watcher. I’ll keep working on the **ccts fallback issue** and will send notes/DOs to Planning as needed.

---

### Troubleshooting

- If `Drop-CoDO`/`Send-CoNote` commands aren’t found, reload helpers:
  ```powershell
  . "$HOME\Downloads\CoTemp\Join-CoAgent.ps1"
  ```
- If panel addressing fails, list panels:
  ```powershell
  Get-CoPanels | Format-Table name, session_id, pid
  ```
- If a job got stuck, stop + relaunch using the commands above.

_Updated: 2025-09-09T05:48:06_
