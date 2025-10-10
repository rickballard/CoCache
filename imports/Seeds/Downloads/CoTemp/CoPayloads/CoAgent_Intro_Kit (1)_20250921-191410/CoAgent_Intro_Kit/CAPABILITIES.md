# CoAgent Capabilities (MVP-2)

**Supported now**
- Watches `Downloads` for `*.zip` and executes if ZIP has root-level `run.ps1`
- PowerShell 7 execution with output capture
- Work folder per run under `Downloads\CoTemp\CoPayloads\...`
- CoPong markdown summary under `Downloads\CoTemp\CoPong\...`
- Routing via `_copayload.meta.json` (preferred) or filename `__FROM_<session>__`
- Optional local co-signing if Rick has `CoSign-Text.ps1` installed

**Not supported (yet)**
- Browser tab / chat-pane auto-binding
- Background scheduling or privileged operations
- Long-running daemons without explicit consent
- Internet access unless your script does it and Rick approves

**Best practices**
- Keep tasks small and idempotent
- Emit artifacts (markdown, JSON, CSV) to `$PSScriptRoot`
- Log clearly; assume your log tail appears in CoPong
- Offer a `-WhatIf` or a read-only mode when practical
