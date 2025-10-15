# Handoff — Repo Reorg Session (What To Do)
**Goal:** Install CoSteward into **CoCache**, open a PR with checks, and make it obvious for the Steward to start using it.

## Fast path (recommended)
1) Unzip this package into your Downloads folder.
2) Open PS7, then run:
   ```powershell
   cd $HOME\Downloads\AB_CoSteward_Spine_UPG_*
   pwsh .\DO_InstallTo_CoCache_and_PR.ps1
   ```
   - Creates `/CoSteward` inside CoCache (non-destructive merge)
   - Creates branch `feature/costeward-seed`
   - Pushes branch and opens a PR (uses `gh` if available)
3) Add/adjust `streams.yml` if needed (≤4 human streams).
4) (Optional) Run:
   ```powershell
   pwsh .\scripts\new_heartbeat.ps1
   ```
5) Merge PR when checks pass.

## Manual path (if no gh / branch protections)
```powershell
cd $HOME\Downloads\AB_CoSteward_Spine_UPG_*
pwsh .\run.ps1 -TargetRoot "$HOME\Documents\GitHub\CoCache"

cd $HOME\Documents\GitHub\CoCache
git checkout -b feature/costeward-seed
git add CoSteward
git commit -m "Seed CoSteward (human WIP cap + Co: sandbox + IdeaCards + weekly ritual)"
git push -u origin feature/costeward-seed
# open PR in browser to main
```

## What this installs
- `/CoSteward/streams.yml` — human WIP cap (AI streams tracked elsewhere)
- `/CoSteward/scripts/*` — heartbeat, IdeaCards render, WIP checker
- `/CoSteward/.github/workflows/*` — WIP cap + heartbeat presence
- `/CoSteward/templates/*` — DOR/DoD template
- `/CoSteward/governance/Steward-Code.md` — role clarity
- `/CoSteward/sandbox/*` — intake + mined + IdeaCards view

## Acceptance (Definition of Done)
- PR merged into CoCache
- `streams.yml` edited to actual 3–4 human streams
- First weekly heartbeat scheduled
- Link to CoSteward added to CoCache global index
