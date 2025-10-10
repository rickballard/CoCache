# Scope Freeze — P0 (CoAgent)

Included ONLY:
- Queue Watcher (file-stability gate)
- Repo Mutex
- Read-Only default (writes/network/secrets/destructive = denied)
- Per-run logging (human + JSON)
- Basic rollback (manual instructions)
- DO Header Spec v0.1 parser

Out of scope (separate RFC): UI, multi-repo orchestration, auto-rollback, advanced policy engine, networked integrations.
