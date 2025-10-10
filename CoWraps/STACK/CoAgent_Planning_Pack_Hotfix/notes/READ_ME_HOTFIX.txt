CoAgent Planning Pack — Hotfix
==============================

This hotfix replaces two scripts that threw errors on your machine:

1) scripts/Enforce-SingleWatcher.ps1
   - Ensures exactly *one* watcher per session (co-planning, co-migrate)
   - Repairs the panel registry (drop dead PIDs, dedupe newest per name)
   - Restarts the watchers and prints status

2) scripts/New-DO-CCTS-Fallback-Test.ps1
   - Queues a clean, headered, **ccts fallback** smoke DO to a target session
   - Usage:
       & "$HOME\Downloads\CoTemp\PlanningPack\scripts\New-DO-CCTS-Fallback-Test.ps1"           # default target co-migrate
       & "$HOME\Downloads\CoTemp\PlanningPack\scripts\New-DO-CCTS-Fallback-Test.ps1" -Target co-planning
       & "$HOME\Downloads\CoTemp\PlanningPack\scripts\New-DO-CCTS-Fallback-Test.ps1" -AllowWrites -AllowNetwork

Also included:
- scripts/Status-QuickCheck-Alt.ps1 (safe status report)

Install
-------
1) Unzip to your existing PlanningPack folder, allowing overwrite, e.g.:

   Expand-Archive "$HOME\Downloads\CoAgent_Planning_Pack_Hotfix.zip" `
     -DestinationPath "$HOME\Downloads\CoTemp\PlanningPack" -Force

2) Then run, for example:

   & "$HOME\Downloads\CoTemp\PlanningPack\scripts\Enforce-SingleWatcher.ps1"
   & "$HOME\Downloads\CoTemp\PlanningPack\scripts\New-DO-CCTS-Fallback-Test.ps1"
   & "$HOME\Downloads\CoTemp\PlanningPack\scripts\Status-QuickCheck-Alt.ps1"
