# CoAgent OmniBar + Fixes Pack
Generated: 2025-09-16 00:24:50

Includes:
- **OmniBar** assets and installer (merges Guardrails + BPOE + IssueOps + Backend + SLAM into ONE bottom bar; hides legacy bars).
- **Relax Pair .pak hard-fail** (warn instead of throw).
- **Unstick Electron Builder** (kill locks, rename stale dist, rebuild clean).
- **Fix Section-Banners** (compact demarker; previous script bug fixed).

## Apply
```powershell
$repo = "$HOME\Documents\GitHub\CoAgent"
$dl   = Join-Path $HOME 'Downloads'
Expand-Archive -Path (Join-Path $dl 'CoAgent-OmniBar-Fixes-Pack.zip') -DestinationPath (Join-Path $dl 'CoAgent-OmniBar-Fixes-Pack') -Force

# Single bar
pwsh -File (Join-Path $dl 'CoAgent-OmniBar-Fixes-Pack\scripts\Install-OmniBar.ps1') -RepoPath $repo

# Optional fixes you asked for
pwsh -File (Join-Path $dl 'CoAgent-OmniBar-Fixes-Pack\scripts\Relax-Pair-LoosePakCheck.ps1') -RepoPath $repo
pwsh -File (Join-Path $dl 'CoAgent-OmniBar-Fixes-Pack\scripts\Fix-Section-Banners.ps1') -RepoPath $repo

# Rebuild safely if builder was stuck
pwsh -File (Join-Path $dl 'CoAgent-OmniBar-Fixes-Pack\scripts\Unstick-ElectronBuilder.ps1') -RepoPath $repo

# Launch without rebuild-on-launch
$env:COAGENT_SESSION = 'Productize backchatter'
& "$repo\tools\Pair-CoSession.ps1" -SkipBuild -WaitExec:$false -AutoExec:$false
```
