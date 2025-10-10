# Test Plan — Smoke & Regression

## Smoke
- One watcher per session
- Queue `DO-Smoke` and verify PSVersion prints correctly

## Regression
- Header missing → rejected to outbox
- Duplicate watchers → repaired by Enforce-SingleWatcher
