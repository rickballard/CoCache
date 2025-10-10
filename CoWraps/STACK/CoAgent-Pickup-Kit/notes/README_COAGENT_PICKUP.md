# CoAgent Pickup Kit

**Generated:** 2025-09-15 22:14:36  
**Source Zips:** `CoWrap-CoAgent-Supplement.zip`, `CoWrap-CoAgent-NextSession.zip`

This kit productizes the handoff from a bloated session into a concise, actionable package.

## What’s Inside

- `MANIFEST.json` — provenance and file index
- `NEXT_ACTIONS.md` — prioritized, low-ambiguity tasks to resume work fast
- `scripts/Start-CoAgent-Pickup.ps1` — idempotent bootstrap for Windows PowerShell 7+
- `ingested/` — original CoWrap materials (verbatim), for traceability
- `signals/` — extracted text snippets (first 50 lines) to quickly locate key bits
- `inventory.csv` — full file inventory from the uploads

## Quickstart

1. Open **PowerShell 7+**.
2. `cd` to this kit’s folder.
3. Run:

```powershell
# Non-destructive dry run
pwsh -File .\scripts\Start-CoAgent-Pickup.ps1 -WhatIf

# Real run
pwsh -File .\scripts\Start-CoAgent-Pickup.ps1
```

The script:
- Creates a local working branch in your **CoAgent** repo if present.
- Copies in useful scripts/snippets found here into `tools/CoAgent-Pickup/` (non-destructive; preserves existing).
- Writes a **MANIFEST** note and a **NEXT_ACTIONS.md** stub (idempotent).
- Prints a **Resume Checklist**.

> Safe by default: it refuses to overwrite existing files unless `-Force` is provided.

## Resume Checklist (TL;DR)

- [ ] Open `NEXT_ACTIONS.md` and knock off the top Priority 0/1 items.
- [ ] If a previous session left DO-blocks, review `signals/` for those and fast-track them.
- [ ] Confirm repo health: `git status`, branch name, CI green.
- [ ] Record outcomes back into `NEXT_ACTIONS.md` and commit.

