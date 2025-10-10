<# ---
title: "CCTS Fallback Smoke"
session_id: "co-migrate"
repo: { name: "Sandbox", path: "C:\Users\Chris\Desktop\CoAgent_SandboxRepo" }
risk: { writes: false, network: false, secrets: false, destructive: false }
brief: "Check that the fallback path returns a sane default without side effects."
consent: { allow_writes: false, allow_network: false }
--- #>
# [PASTE IN POWERSHELL]
"ccts-fallback-smoke at 2025-09-09T17:06:11.9042426-04:00"
System.Collections.Hashtable.PSVersion
