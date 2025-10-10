# CoAgent MVP Backlog (Execution-Ready)

## P0 — Must Ship (MVP)
- Queue Watcher: detect new DO files, file-stability (size+hash) gate, “press Enter to run”.
- Repo Mutex: one writer per repo path; visible lock banner; timeout + manual override.
- Read-Only Default: require --allow-writes and --allow-network toggles per run.
- Logs: per-run JSON log + human .txt; mask secrets; include risk flags & exit code.
- Rollback Bundle (basic): pre-run worktree snapshot or stash, auto-revert on failure.

## P1 — Near-Term
- Dry-Run Renderer: show effective commands; typed confirmation on destructive ops.
- Risk Linter v0: regex detectors (writes/network/secrets/destructive) → badges + blocks.
- Auto-CoPong: write .pong.json on success/fail with run metadata; surface in UI.
- Companion GPT: emits spec-compliant DOs; links to CoAgent download.

## P2 — Pull-Through to CoModules (Monetization)
- Policy Audit Module (paid): check HR/hiring/discipline docs; produce change diffs.
- Decision Log Viewer (free→paid dashboards).
- RepTag Engine (paid): merit-weighted voting.

## Metrics (for launch review)
- Time-to-PR median ↓ 30–50%
- Rollbacks working ratio ≥ 95%
- User NPS ≥ 50
- Module trials per 100 runs ≥ 15
