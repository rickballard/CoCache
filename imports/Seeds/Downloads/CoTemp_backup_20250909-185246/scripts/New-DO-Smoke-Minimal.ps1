param([string]$Target="co-migrate")
Set-StrictMode -Version Latest; $ErrorActionPreference="Stop"
$root = Join-Path $HOME "Downloads\CoTemp"
. (Join-Path $root "Join-CoAgent.ps1") | Out-Null
try { . (Join-Path $root "common\CoPanels.ps1") | Out-Null } catch {}
$t    = Resolve-CoTarget -To $Target
$name = "DO_Smoke_{0}.ps1" -f (Get-Date -Format "HHmmss")
$path = Join-Path $t.inbox $name
$body = @"
<# ---
title: "Smoke"
session_id: "$($t.session_id)"
repo: { name: "Sandbox", path: "$(Join-Path $HOME 'Desktop\CoAgent_SandboxRepo')" }
risk: { writes: false, network: false, secrets: false, destructive: false }
brief: "PS version smoke"
consent: { allow_writes: false, allow_network: false }
--- #>
# [PASTE IN POWERSHELL]
"Smoke test at $(Get-Date -Format o)"
`$PSVersionTable.PSVersion
"@
Set-Content -LiteralPath $path -Encoding UTF8 -Value $body
Write-Host ("Queued -> {0}" -f $path) -ForegroundColor Green
return $path
