# RFC-0003 — CoTemp Panel Registry & Watcher Runtime (pre-CoAgent)

**Status:** Adopted  
**Scope:** Local dev host; two-session coordination (Planning / Migrate)

## Summary
A lightweight runtime coordinates two Chat sessions via Downloads\CoTemp, with:
- **Panel registry** (per-PID JSON) → maps friendly panel name → session id → inbox/outbox/logs.
- **Queue watcher** (one per session) → stable-file gate, header check, execution, logs + JSON audit.
- **Note/DO bridge** → Send-CoNote, Drop-CoDO, and New-CoHelloDO.

## Invariants
- Max one watcher per session (CoQueueWatcher-<session> job).
- DOs must include YAML header: 	itle, repo, risk, consent.
- No secrets logged; PII and tokens are out-of-scope at this stage.

## Operations
- Launch: CoAgentLauncher.ps1 -OpenBrowser
- Status: scripts\Status-QuickCheck.ps1
- Repair panels: *see Repair snippet in runbook*.
- Stand down a pane: scripts\Mark-MigrateStandDown.ps1 -NotifyPlanning

## Road to CoAgent
This runtime becomes CoAgent’s local **OE daemon**: policy-gated cross-session routing, conflict handling, and provenance for consensus/adjudication layers (see RFC-0002).
