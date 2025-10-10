<# ---
title: "DO-hello"
session_id: "manual"
repo: { name: "Sandbox", path: "C:\Users\Chris\Desktop\CoAgent_SandboxRepo" }
risk: { writes: false, network: false, secrets: false, destructive: false }
est_runtime: "PT5S"
requires: ["ps7>=7.0"]
brief: "Print hello and PS version."
effects: { files_touched: [], services_touched: [] }
rollback: "none"
outputs: { logs: true, artifacts: [] }
consent: { allow_writes: false, allow_network: false }
sign: { alg: "none", by: "Manual" }
--- #>
# [PASTE IN POWERSHELL]
Write-Host "Hello from DO — $(Get-Date -Format o)"
$PSVersionTable.PSVersion
