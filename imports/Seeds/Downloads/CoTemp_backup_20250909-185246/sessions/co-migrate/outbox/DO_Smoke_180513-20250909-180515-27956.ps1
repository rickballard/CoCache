<# ---
title: "Smoke"
session_id: "co-migrate"
repo: { name: "Sandbox", path: "C:\Users\Chris\Desktop\CoAgent_SandboxRepo" }
risk: { writes: false, network: false, secrets: false, destructive: false }
brief: "PS version smoke"
consent: { allow_writes: false, allow_network: false }
--- #>
# [PASTE IN POWERSHELL]
"Smoke test at 2025-09-09T18:05:13.9742684-04:00"
$PSVersionTable.PSVersion
