# Packaging Plan (MVP)

- Ship as a signed ZIP initially
- Contents:
  - runtime/ (Join-CoAgent, CoAgentLauncher, common/, scripts/)
  - docs/ (PRD, Runbook, Roadmap, Risk Register)
- Post-install checklist:
  - Unblock files; set ExecutionPolicy Process=Bypass
  - Run `CoAgentLauncher.ps1 -OpenBrowser`
  - Run smoke DO
- Future: winget/choco; add signature and versioning
