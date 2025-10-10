<# ---
title: "DO-rollback-failure-sim"
session_id: "manual"
repo: { name: "Sandbox", path: "C:\Users\Chris\Desktop\CoAgent_SandboxRepo" }
risk: { writes: true, network: false, secrets: false, destructive: false }
brief: "Create a commit then throw (for rollback drills)."
consent: { allow_writes: false, allow_network: false }
--- #>
# [PASTE IN POWERSHELL]
$repo = "$env:USERPROFILE\Desktop\CoAgent_SandboxRepo"

if ($env:COAGENT_ALLOW_WRITES -ne '1') {
  Write-Host "WOULD CREATE COMMIT in $repo (set $env:COAGENT_ALLOW_WRITES=1 to enable)"
  return
}

# Make a tiny change and commit
$f = Join-Path $repo ("fail-" + (Get-Date -Format "yyyyMMdd-HHmmss") + ".txt")
"temp" | Set-Content -Encoding UTF8 $f
git -C $repo add -A
git -C $repo commit -m "simulated change before failure" | Out-Null

# Human rollback instructions (quotes preserved around path)
"git -C `"$repo`" reset --hard HEAD~1" | Set-Content -Encoding UTF8 (Join-Path $repo "Rollback_Instructions.txt")

throw "Simulated failure after commit — run the command in Rollback_Instructions.txt to revert."
