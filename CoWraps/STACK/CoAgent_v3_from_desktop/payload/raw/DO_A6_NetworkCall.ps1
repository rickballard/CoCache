<# ---
title: "DO-network-call-sim"
session_id: "manual"
repo: { name: "Sandbox", path: "C:\Users\Chris\Desktop\CoAgent_SandboxRepo" }
risk: { writes: false, network: true, secrets: false, destructive: false }
brief: "Fetch example.com; echo unless COAGENT_ALLOW_NETWORK=1."
consent: { allow_writes: false, allow_network: false }
--- #>
# [PASTE IN POWERSHELL]
$url = 'https://example.com'
if ($env:COAGENT_ALLOW_NETWORK -eq '1') {
  Write-Host "FETCHING: $url"
  Invoke-WebRequest -UseBasicParsing -Uri $url | Select-Object -First 1 | Out-Null
  Write-Host "OK"
} else {
  Write-Host "WOULD FETCH: $url  (set $env:COAGENT_ALLOW_NETWORK=1 to enable)"
}
