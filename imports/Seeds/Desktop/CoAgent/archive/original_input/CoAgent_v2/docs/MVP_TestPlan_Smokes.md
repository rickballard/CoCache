# MVP Smoke Tests

## T-01 Watchers
- Expect exactly one job each: CoQueueWatcher-co-planning, CoQueueWatcher-co-migrate

## T-02 DO-Smoke
- Queue simple echo; log shows timestamp and PowerShell version

## T-03 RepoScan (Read-Only)
- List up to 50 files in Sandbox repo (no writes); clean UTF-8 output

## T-04 Cross-pane Note
- Send-CoNote between sessions; note appears in the other inbox

## Pass/Fail Gates
- 0 duplicate watchers; all DOs have headers; logs written without errors
