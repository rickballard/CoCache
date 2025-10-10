# CoAgent Bootstrap Pack

Purpose: fast, repeatable onboarding for a first-time CoAgent user without touching a repo manually.

## Contents
- `tools/Setup-GitHub.ps1` – guides/automates GitHub CLI auth, creates a public repo, relaxes protections, enables Pages.
- `tools/Run-CoAgent.ps1` – launches the product: opens guides, probes Pages, optional sandbox/local backup.
- `tools/Test-MVP.ps1` – probes a Pages site (status, UI mock) and kicks a CI smoke job if found.
- `docs/Onboarding.html` – browser guide the scripts open to keep the user "on the right page".
- `docs/QuickStart.md` – one-pager you can paste to any repo README.

## Quick start
```powershell
# PowerShell 7+
pwsh -ExecutionPolicy Bypass -File .\tools\Setup-GitHub.ps1 -Owner "<githubUser>" -Repo "CoAgent" -Public -Relax Protections -EnablePages

# Then launch product UX against that repo:
pwsh -ExecutionPolicy Bypass -File .\tools\Run-CoAgent.ps1 -BaseUrl "https://<githubUser>.github.io/CoAgent" -OpenGuides -Sandbox
```
Generated 2025-10-03T01:29:15Z.
