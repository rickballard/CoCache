# Watcher policy — centralized (pre-CoAgent)
Status: 2025-09-09T15:51:14.9509525-04:00

We just restarted cleanly and enforced **ONE watcher per session**:
- co-planning  → CoQueueWatcher-co-planning (background job)
- co-migrate   → CoQueueWatcher-co-migrate  (background job)

Please do **not** start additional watchers.  
Coordinate via:
- **Drop-CoDO** to send runnable DOs to the other pane
- **Send-CoNote** for non-executable updates

Migrate focus: **ccts fallback** remediation continues.
