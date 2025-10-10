# CoAgent_v2 (proto-repo)

This is a reorganized working tree prepared from your prior CoAgent materials.
Use it as a drop-in replacement for your current `CoAgent` folder on Desktop.

## What's inside

- `docs/` — planning, roadmap, test plans (public-safe); `docs/private/` for sensitive content.
- `docs/diagrams/` — Draw.io stubs for runtime, UX flow, and roadmap visuals.
- `tools/StatusPack/` — helper scripts to snapshot the local runtime and harvest docs into a repo.
- `scripts/` — local utilities (generators, smokes).
- `runtime/` — placeholders for your CoTemp launcher/runtime (optional copy from your local env).

> **Note:** `docs/private/` is ignored by git via `.gitignore`. Keep sensitive strategy, pricing, and partner lists there.
> The public business plan can be generated with `tools/Export-Public-BP.ps1`.

## Quick Start

1. Unzip this archive to your Desktop as `CoAgent` (or rename the existing folder first).
2. (Optional) Initialize a repo:
   ```powershell
   cd $HOME\Desktop\CoAgent
   git init
   git add .
   git commit -m "CoAgent_v2 scaffold"
   ```
3. Run status tools (PowerShell):
   ```powershell
   .\tools\StatusPack\Capture-StatusSnapshot.ps1
   ```
