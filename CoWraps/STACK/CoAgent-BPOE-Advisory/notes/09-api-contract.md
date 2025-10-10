# API Contract: CoAgent ↔ Repos

CoAgent MUST provide:
- `preflight(repoPath) -> Report`: runs local BPOE checks, auto-fixes safe items, returns structured findings.
- `postflight(repoPath, prNumber?) -> Report`: verifies remote refs, labels, CI status; posts a minimal PR note.

Reports:
```json
{
  "version": "1.0",
  "fixes": [{"path":"...","change":"added .gitattributes"}],
  "alerts": [{"severity":"error","code":"BPOE_PLACEHOLDER","path":"bpoe/..." }]
}
```
No secrets, no raw line contents beyond small redacted snippets for local UI (never uploaded).
