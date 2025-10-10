# Two-Chat Operations (Pre‑CoAgent)

This setup runs two synchronized chat panes — **Planning** (`co-planning`) and **Migrate** (`co-migrate`) —
coordinated by a local CoTemp backchannel and two background watcher jobs.

## Key paths
- CoTemp root: `%USERPROFILE%\Downloads\CoTemp`
- Session inboxes/outboxes/logs live under: `CoTemp\sessions\<id>\…`

## Commands
```powershell
# join + autoload helpers
. "$HOME\Downloads\CoTemp\Join-CoAgent.ps1"

# start watchers (as jobs)
& "$HOME\Downloads\CoTemp\CoAgentLauncher.ps1" -OpenBrowser

# quick status
& "$HOME\Downloads\CoTemp\scripts\Status-QuickCheck.ps1"

# send a note from Migrate to Planning
Send-CoNote -ToSessionId 'co-planning' -Text "ccts fallback checkpoint …"
```

## Rules of engagement
- **Do not** spin up ad-hoc watchers inside Migrate—launcher already runs centralized watchers.
- Use **DO** files for work units and **NOTE** files for status/handshake.  
- Prefer Planning → Migrate handoffs for repo-affecting changes.
