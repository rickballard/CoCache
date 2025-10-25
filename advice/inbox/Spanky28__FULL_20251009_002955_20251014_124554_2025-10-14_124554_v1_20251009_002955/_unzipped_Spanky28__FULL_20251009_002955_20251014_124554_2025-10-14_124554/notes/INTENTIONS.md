# Intentions
- Keep CoAgent focused on productization; CoModules handoff lives in CoModules repo.
- Maintain orchestrator pairing robustness (pair file + safe key).
- Add watchdog to auto Ctrl+C if PS7 pane hangs >2 min (blank `>>` prompt).
- CI: build artifacts + size checks; release guards w/ SHA256; adapter to validate against JSON Schemas and write Evidence Ledger.
## Unfinished
- Watchdog implementation.
- CI jobs (artifact build/size, release guard).
- Add `_schema` folder + adapter.
