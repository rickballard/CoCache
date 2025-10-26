# BPOE — Best Possible Operational Experience

- **Timestamped local drops**: name as Name_YYYYMMDD_HHMMSS.ext to avoid Windows (1) collisions.
- **Repo-first**: prefer committing scripts/content to repos; use Downloads only as a launchpad.
- **Idempotent scripts**: safe re-runs; no assuming working directory; verbose success/failure.
- **Handoffs**: every session ends with a docs/HANDOFFS/HANDOFF_*.md.

## Canonical BPOE Pipeline (rev 2025-10-17 17:41:43Z)

**Stage → Verify → Drop to ~/Downloads/CoOps → Execute via one DO Block → Record (CoPingPong) → Clean up → Persist signals to repos.**

Guardrails:
- **Stage**: scripts live in timestamped files under ~/Downloads/CoOps (no Windows “(1)” collisions).
- **Verify**: write metrics/coops_manifest.json before execution (name/size/SHA256/mtime).
- **Execute (DO Block)**: orchestration is pasted once in PS7; *no* long-lived background tasks.
- **Record (CoPingPong)**: append run lines to docs/HEARTBEATS/copings.log; run scripts/metrics_harvest.ps1.
- **Clean up**: coops_cleanup.ps1 removes staged files older than the grace window, logging deletions.
- **Persist**: commit/push docs/HEARTBEATS, metrics/latest.json, and metrics/history/*.

Operators: prefer repo-first, idempotent scripts, readable timestamps, and explicit success/failure echoes.

