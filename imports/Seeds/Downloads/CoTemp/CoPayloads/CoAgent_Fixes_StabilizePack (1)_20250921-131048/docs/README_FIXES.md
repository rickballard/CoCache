# CoAgent Fixes – Stabilize Pack

This pack fixes two issues you hit:
1) `$PSVersionTable.PSVersion` expanding too early inside DOs.
2) Greeting text encoding (smart quotes / dashes).

## Apply
```powershell
$fx = "$HOME\Downloads\CoAgent_Fixes_StabilizePack"
Expand-Archive "$HOME\Downloads\CoAgent_Fixes_StabilizePack.zip" -DestinationPath "$HOME\Downloads" -Force
& "$fx\scripts\Stabilize-CoTemp.ps1"
& "$fx\scripts\New-DO-Smoke-Minimal.ps1"
```
