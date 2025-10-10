# NEXT_ACTIONS — CoAgent Pickup

Focus on outcome, not archaeology. If something is unclear, prefer filing a TODO with a concrete owner/date over speculative refactoring.

## Priorities

- **P0**: Review `signals/` for any `DO` blocks or migration scripts that must be run first.
- **P0**: Ensure local environment: PowerShell 7.5+, `gh` CLI auth, repo cloned and clean.
- **P1**: Create/confirm working branch in `CoAgent` (e.g., `pickup/{datetime.datetime.now().strftime('%Y%m%d')}`) and commit this kit under `tools/CoAgent-Pickup/`.
- **P1**: Skim `inventory.csv` to spot candidate scripts (`.ps1`, `.psm1`) worth promoting to `tools/`.
- **P2**: Normalize script headers to the CoAgent style (StrictMode, `Stop` on error, transcript, idempotent paths).
- **P2**: Convert any loose 'advice bomb' notes into GitHub Issues with labels `advice`, `ops`, `bpoe`.
- **P3**: Wire a CI smoke check for `tools/CoAgent-Pickup/` to prevent regressions.

## Candidate TODOs Discovered (auto-harvest)

The following files looked promising (text-like or code). Inspect as needed:

- CoWrap-CoAgent-Supplement/README.md
- CoWrap-CoAgent-Supplement/NEXT-STEPS.md
- CoWrap-CoAgent-Supplement/BPOE-GUIDE.md
- CoWrap-CoAgent-Supplement/WORKFLOW.md
- CoWrap-CoAgent-Supplement/TROUBLESHOOTING.md
- CoWrap-CoAgent-Supplement/SCOPE-NEXT-SESSION.md
- CoWrap-CoAgent-Supplement/CoCache-NOTES.md
- CoWrap-CoAgent-Supplement/Check-Environment.ps1
- CoWrap-CoAgent-NextSession/CoWrap-CoAgent-NextSession/README-CoWrap.md
- CoWrap-CoAgent-NextSession/CoWrap-CoAgent-NextSession/Do-All.ps1
- CoWrap-CoAgent-NextSession/CoWrap-CoAgent-NextSession/Install-Icons-And-Shortcuts.ps1
- CoWrap-CoAgent-NextSession/CoWrap-CoAgent-NextSession/Patch-Section-Banners.ps1
- CoWrap-CoAgent-NextSession/CoWrap-CoAgent-NextSession/Repair-Profile-EnterKey.ps1
