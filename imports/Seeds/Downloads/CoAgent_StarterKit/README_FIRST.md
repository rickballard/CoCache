# CoAgent Starter Kit (pre-CoAgent runtime)

This kit gives you:
- **runtime/**: Join script, two background watchers, panel registry, DO/Note bridge, and a launcher that can open two Chat tabs with greetings.
- **docs/**: RFC-0002 (consensus plan), RFC-0003 (panel registry + watcher runtime), Ops runbook, tests (if present).

## Quick start
1. Open PowerShell.
2. Run: .\runtime\CoAgentLauncher.ps1 -OpenBrowser
3. Paste the PLANNING greeting in the first Chat tab; Migrate will have its own.
4. Use the Ops runbook for day-to-day (docs\Runbooks\Ops_Runbook_Panels_Watchers_v0.md).

### Guardrails
- Exactly **one** watcher per session.
- DO files must include the YAML header (title, repo, risk, consent).
- Keep writes/network off unless explicitly approved.

### What’s next
- Migrate continues **ccts fallback** remediation.
- Planning continues CoAgent packaging + MVP scoping.

— end —
