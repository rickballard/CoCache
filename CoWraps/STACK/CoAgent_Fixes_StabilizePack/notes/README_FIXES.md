
# CoAgent Fixes & Stabilize Pack

Normalize the two-pane CoTemp runtime, fix the CCTS smoke DO (so `$PSVersionTable.PSVersion` evaluates at run time), and provide ASCII-safe greetings.

## Quick Start
1. Download and unzip this pack (anywhere, e.g., `Downloads\CoAgent_Fixes_StabilizePack`).
2. In PowerShell:
```
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
$fx = "$HOME/Downloads/CoAgent_Fixes_StabilizePack"
& "$fx/scripts/Stabilize-CoTemp.ps1"
```
3. Verify:
```
& "$HOME/Downloads/CoTemp/scripts/Status-QuickCheck.ps1"
$S = Join-Path $HOME 'Downloads/CoTemp/sessions/co-migrate'
Get-ChildItem "$S/logs/*.txt" | Sort-Object LastWriteTime -Desc | Select -First 1 | % { "Log: $($_.FullName)"; Get-Content $_.FullName -Tail 50 }
```
4. Re-queue a smoke:
```
& "$fx/scripts/New-DO-Smoke-Minimal.ps1"
```

Notes:
- Greetings are ASCII-only to avoid mojibake in console windows.
- The CCTS DO generator writes `$PSVersionTable.PSVersion` literally into the DO, so it executes correctly when the watcher runs it.
