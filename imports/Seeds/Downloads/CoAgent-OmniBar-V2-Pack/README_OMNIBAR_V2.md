# CoAgent OmniBar v2 Pack
Generated: 2025-09-16 00:49:26

- **OmniBar v2**: single bar; SLAM (higher=better), KPI popups for all, and a **Guardrails Index** rainbow bar with slider.
- **Installer**: robust HTML/TSX injection (removes old bars).
- **Backend Gate v2**: replaces direct `loadURL(127.0.0.1:7681)` with resilient loader; falls back to local `index.html` if backend is down.

## Apply
```powershell
$repo = "$HOME\Documents\GitHub\CoAgent"
$dl   = Join-Path $HOME 'Downloads'
Expand-Archive -Path (Join-Path $dl 'CoAgent-OmniBar-V2-Pack.zip') -DestinationPath (Join-Path $dl 'CoAgent-OmniBar-V2-Pack') -Force

pwsh -File (Join-Path $dl 'CoAgent-OmniBar-V2-Pack\scripts\Install-OmniBarV2.ps1') -RepoPath $repo
pwsh -File (Join-Path $dl 'CoAgent-OmniBar-V2-Pack\scripts\Patch-Backend-GateV2.ps1') -RepoPath $repo

pushd "$repo\electron"; & "$env:ProgramFiles\nodejs\npx.cmd" electron-builder -w dir; popd
$env:COAGENT_SESSION = 'Productize backchatter'
& "$repo\tools\Pair-CoSession.ps1" -SkipBuild -WaitExec:$false -AutoExec:$false
```
