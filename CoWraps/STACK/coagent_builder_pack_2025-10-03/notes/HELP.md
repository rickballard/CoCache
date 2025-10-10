# CoAgent — HELP (User Guide, MVP)

## What this is
A minimal public MVP with a live UI mock, status panel, and guardrails smoke test.

## Quick start
1. Visit your Pages site (e.g., `https://<owner>.github.io/CoAgent/`).
2. UI Mock: `/ui-mock/quad.html`
3. Status Panel: `/status.html` (reads `status.json`)
4. MVP Smoke: `pwsh -File tools\Test-MVP.ps1`

## Guardrails
- Heuristic scanner: `tools/Scan-AtRisk.ps1`.
- CI smoke workflow: `.github/workflows/guardrail-smoke.yml`.

## Release
- Tag with `tools\CoAgent_Release_MVP.ps1` (on main, clean tree).

## Support & Security
- See SUPPORT.md and SECURITY.md.
