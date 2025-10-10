# Operations Runbook — Panels & Watchers v0

## Daily
1. **Launch**: CoAgentLauncher.ps1 -OpenBrowser
2. **Status**: scripts\Status-QuickCheck.ps1
3. **Send a note**: Send-CoNote -ToSessionId 'co-planning' -Text '...''
4. **Queue a DO**: Drop-CoDO -To 'Migrate' -Title '...' -Body @' ... '@

## Repair
### Dedupe panel registry
(Use the repair snippet you pasted earlier.)

### Restart watchers
Get-Job | ? Name -like 'CoQueueWatcher-*' | Remove-Job -Force
Start-CoQueueWatcherJob -SessionId 'co-planning' -PanelName 'Planning'
Start-CoQueueWatcherJob -SessionId 'co-migrate' -PanelName 'Migrate'
## Guardrails
- One watcher per session.
- Don’t run unreviewed DOs with writes/network unless explicitly allowed.
- Keep scripts\ under source control once CoAgent repo is live.

## Known work-in-progress
- **ccts fallback** remediation (Migrate).
- Panel registry compaction on exit (future).
