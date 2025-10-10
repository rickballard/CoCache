# Queue Watcher (P0)

Goal: Safely discover and run DO scripts only after they are stable.
- Watch path: Downloads\CoTemp\sessions\<session>\inbox.
- File-stability gate: size+SHA256 unchanged N consecutive checks (default N=4, 400ms).
- State machine: queued -> stabilizing -> processing -> done/failed.
- Isolation: deny writes/network by default; allow only when explicit consent set.

Acceptance:
- Never executes a partially written file.
- Logs every transition with timestamps.
- Idempotent: re-seeing same artifact does not re-run it unless version changes.
