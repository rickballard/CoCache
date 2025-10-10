# CoAgent Roadmap Pack — Drop-In
**Purpose:** suggestion pack from one session to another. Unzip into the **CoAgent** repo root.

## Files
- docs/roadmap/ROADMAP.md
- docs/product/ONEPAGER.md
- docs/status/RELEASES.md
- docs/index/COAGENT-INDEX.md
- Sidecars: `.meta.json` for each doc (canonicality=3, status=active)

## How to import (PowerShell, from CoAgent repo root)
```powershell
Expand-Archive -Path .\coagent_roadmap_pack.zip -DestinationPath . -Force
git add docs/*
git commit -m "docs(roadmap): seed CoAgent roadmap, index, notes [+sidecars]"
git push
```
Optional: add the snippet in `snippets/COCACHE_HUMAN_INDEX_APPEND.md` to `CoCache/docs/index/HUMAN-INDEX.md`.
_Updated 2025-09-14T05:21:37Z_
