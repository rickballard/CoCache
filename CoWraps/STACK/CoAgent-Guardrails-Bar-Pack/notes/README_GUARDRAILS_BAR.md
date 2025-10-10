# CoAgent Guardrails Bar Pack
Generated: 2025-09-16 00:17:32

What you get:
- **Guardrails status bar** fixed to the bottom with SLAM metric and placeholders.
- **Click-only** Guardrails info modal (no hover annoyances).
- **DO-block compactor**: Code blocks collapse to an icon, expand on click, auto-collapse unless interacted with; manual edit flags risk red.
- **Backend Gate patcher**: Adds a fallback to local `index.html` when `127.0.0.1:7681` is down.
- Optional **Section Banners trim** to reduce console demark noise.

## Install
```powershell
$repo = "$HOME\Documents\GitHub\CoAgent"
$dl   = Join-Path $HOME 'Downloads'
Expand-Archive -Path (Join-Path $dl 'CoAgent-Guardrails-Bar-Pack.zip') -DestinationPath (Join-Path $dl 'CoAgent-Guardrails-Bar-Pack') -Force

# Inject bar + DO-block behavior
pwsh -File (Join-Path $dl 'CoAgent-Guardrails-Bar-Pack\scripts\Apply-Guardrails-Bar.ps1') -RepoPath $repo

# Add backend fallback automatically
pwsh -File (Join-Path $dl 'CoAgent-Guardrails-Bar-Pack\scripts\Patch-Backend-Gate.ps1') -RepoPath $repo

# Optional: trim demark banners in PS console
pwsh -File (Join-Path $dl 'CoAgent-Guardrails-Bar-Pack\scripts\Patch-Section-Banners.ps1') -RepoPath $repo

# Rebuild
pushd "$repo\electron"; & "$env:ProgramFiles\nodejs\npx.cmd" electron-builder -w dir; popd
```
