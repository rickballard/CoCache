<# ---
title: "DO-Hello"
session_id: "co-migrate"
repo: { name: "Sandbox", path: "C:\Users\Chris\Desktop\CoAgent_SandboxRepo" }
risk: { writes: false, network: false, secrets: false, destructive: false }
brief: "Ad-hoc DO"
consent: { allow_writes: false, allow_network: false }
--- #>
# [PASTE IN POWERSHELL]
"Hello from Planning at $(Get-Date -Format o)"
$PSVersionTable.PSVersion
