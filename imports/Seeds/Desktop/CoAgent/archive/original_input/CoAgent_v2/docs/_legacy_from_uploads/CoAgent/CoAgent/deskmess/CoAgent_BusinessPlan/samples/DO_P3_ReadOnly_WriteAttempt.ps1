<# ---
title: "DO-readonly-write-attempt"
session_id: "manual"
repo: { name: "Sandbox", path: "C:\Users\Chris\Desktop\CoAgent_SandboxRepo" }
risk: { writes: true, network: false, secrets: false, destructive: false }
brief: "Attempt to write a file; echo by default."
consent: { allow_writes: false, allow_network: false }
--- #>
# [PASTE IN POWERSHELL]
$target = Join-Path "$env:USERPROFILE\Desktop\CoAgent_SandboxRepo" "touchme.txt"
if ($env:COAGENT_ALLOW_WRITES -eq '1') {
  "written by DO at $(Get-Date -Format o)" | Set-Content -Encoding UTF8 $target
  Write-Warning "WROTE: $target"
} else {
  Write-Host "WOULD WRITE: $target  (set $env:COAGENT_ALLOW_WRITES=1 to actually write)"
}
