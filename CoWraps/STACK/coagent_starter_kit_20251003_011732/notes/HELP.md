
# CoAgent — HELP (MVP)

**What this is:** a minimal, self-contained training + ops kit with:
- Sandbox toggle (no egress)
- Status file generator
- MVP smoke against a hosted Pages site
- BPOE metrics over local JSONL logs

## Quick start
```pwsh
pwsh -ExecutionPolicy Bypass -File tools\Run-CoAgent.ps1
```
That will (1) enable sandbox, (2) write `docs/status.json`, (3) smoke your hosted site, and (4) open guides.

## Common scripts
- `tools/Enter-Sandbox.ps1` — set `NO_NETWORK=1` and write `.coagent/sandbox.config.json`.
- `tools/Write-Status.ps1` — refresh `docs/status.json`.
- `tools/Test-MVP.ps1 -BaseUrl https://...` — probe 4 public URLs.
- `tools/Generate-MockLogs.ps1` + `tools/Analyze-BPOE.ps1` — demo metrics pipeline.

All scripts are local-only and safe to run in a locked-down environment.
