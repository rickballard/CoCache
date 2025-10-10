# Watcher policy â€” centralized (preâ€‘CoAgent)
Status: 2025-09-09T16:22:49.8957136-04:00

We enforce **one watcher per session**:
- co-planning  â†’ CoQueueWatcher-co-planning
- co-migrate   â†’ CoQueueWatcher-co-migrate

Please do **not** start additional watchers.
Coordinate via:
- Drop-CoDO  (runnable tasks)
- Send-CoNote (human notes)

Migrate focus: **ccts fallback** remediation continues.
