# BPOE Guardrails
- Branches: `feat/*`, `fix/*`, `ops/*`; commit titles `verb: scope` (e.g., `ops: add release guard checks`).
- Deterministic builds only via `tools/zip-rebuild.ps1`; tag releases; send release-pinned links.
- CI: PowerShell lint + here-string sanity (present); PR artifacts + size gates (next); release guards (next).
- PR checklist enforces “close strings / encoding / deterministic output”.
- CoCache as single source of truth; RESUME.md for new sessions; release-pinned comms.

