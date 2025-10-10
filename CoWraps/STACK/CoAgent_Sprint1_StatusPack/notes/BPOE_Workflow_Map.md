# BPOE / Workflow Map (Sprint 1)

**Boundary:** Local dev host, two sessions (Planning, Migrate), file-based broker under `Downloads\CoTemp`.

## Flow
1) Launcher registers two panels and starts one watcher per session
2) Operators exchange DOs (YAML‑headed scripts) and Notes (plaintext) via per‑session inboxes
3) Watcher gates on stable file + header; runs; logs to session logs/outbox
4) Status checked via `Status-QuickCheck`

## Guards
- Exactly one watcher per session
- DOs require header: title, repo, risk, consent
- Writes/network off unless explicitly allowed

## Artifacts to keep in repo
- Runbooks (`docs/OPS_Quickstart.md`), PRD, roadmap, positioning, smoke tests
- DO generators (read‑only variants) as examples
- NOT the live logs — keep those local or in a separate evidence bundle
