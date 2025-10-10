# CoAgent Electron Fixes Pack
Generated: 2025-09-15 23:59:09

## What's inside
- `scripts\Patch-Pair.ps1` — **replacement** for `tools\Pair-CoSession.ps1` with:
  - `-SkipBuild` (avoid rebuilding when just relaunching)
  - robust exe discovery
  - resource sanity check for `.pak` files
  - auto-kill running exe before rebuild

- `scripts\Backend-Gate-HowTo.md` — snippet to add a **fallback** when `http://127.0.0.1:7681/` is down.

## Install
```powershell
$repo = "$HOME\Documents\GitHub\CoAgent"
$dl   = Join-Path $HOME 'Downloads'
Expand-Archive -Path (Join-Path $dl 'CoAgent-Electron-Fixes-Pack.zip') -DestinationPath (Join-Path $dl 'CoAgent-Electron-Fixes-Pack') -Force

# Replace the Pair script with the patched one
Copy-Item (Join-Path $dl 'CoAgent-Electron-Fixes-Pack\scripts\Patch-Pair.ps1') (Join-Path $repo 'tools\Pair-CoSession.ps1') -Force

# Optional: add backend gate in electron main (see how-to)
```

## Safe flow
```powershell
Get-Process coagent-shell, CoAgent -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
Remove-Item "$repo\electron\dist\win-unpacked" -Recurse -Force -ErrorAction SilentlyContinue
pushd "$repo\electron"; & "$env:ProgramFiles\nodejs\npx.cmd" electron-builder -w dir; popd

$env:COAGENT_SESSION = 'Productize backchatter'
& "$repo\tools\Pair-CoSession.ps1" -SkipBuild -WaitExec:$false -AutoExec:$false
```
