<# ---
title: "DO-Sample"
session_id: "<set by Join-CoAgent>"
repo: { name: "Sandbox", path: "<path-to-repo>" }
risk: { writes: false, network: false, secrets: false, destructive: false }
brief: "Sample DO body"
consent: { allow_writes: false, allow_network: false }
--- #>
# [PASTE IN POWERSHELL]
"Sample ran at $(Get-Date -Format o)"
