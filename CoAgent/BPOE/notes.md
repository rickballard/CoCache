# BPOE Notes (live)

- Prefer **queue-based ingestion** over monolithic scans.
- Use **robocopy** for UNC single-file copy (resilient + quiet flags).
- Print a **heartbeat** every 250 items → `STATUS/ingest_progress.txt`.
- Add **stale watchdog**; auto-retry slice if no heartbeat >90s.
- Keep **main-only** branching during seed phase; branches allowed only for safety in protected repos.
