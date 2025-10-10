# Primary User Flows

1) **Launch**
   - Run `CoAgentLauncher.ps1 -OpenBrowser`
   - Two chat tabs open; clipboard primed with greeting
   - Watchers started for `co-planning` and `co-migrate`

2) **Send a DO from Planning to Migrate**
   - `Drop-CoDO -To 'co-migrate' -Title 'DO-Task' -Body @' ... '@`
   - Watcher executes; logs in `sessions\co-migrate\logs`

3) **Send a status note**
   - `Send-CoNote -ToSessionId 'co-planning' -Text 'checkpoint...'`

4) **Repair (if needed)**
   - Run `Enforce-SingleWatcher.ps1`
   - Confirm with `Status-QuickCheck.ps1`
