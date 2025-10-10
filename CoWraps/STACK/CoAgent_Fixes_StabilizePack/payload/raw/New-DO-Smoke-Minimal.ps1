
param([string]$Target='co-migrate')
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
$root = Join-Path $HOME 'Downloads\CoTemp'
. (Join-Path $root 'Join-CoAgent.ps1') | Out-Null
try { . (Join-Path $root 'common\CoPanels.ps1') | Out-Null } catch {}
$t = Resolve-CoTarget -To $Target
$path = Join-Path $t.inbox ("DO_SmokeMinimal_{0}.ps1" -f (Get-Date -Format 'HHmmss'))
$code = @'
"smoke-minimal at $(Get-Date -Format o)"
$PSVersionTable.PSVersion
'@
Set-Content -LiteralPath $path -Value @"
<# ---
title: "Smoke Minimal"
session_id: "$($t.session_id)"
repo: { name: "Sandbox", path: "$(Join-Path $HOME 'Desktop\CoAgent_SandboxRepo')" }
risk: { writes: false, network: false, secrets: false, destructive: false }
brief: "Minimal sanity echo and PS version."
consent: { allow_writes: false, allow_network: false }
--- #>
# [PASTE IN POWERSHELL]
"@ + "`r`n" + $code -Encoding UTF8
"Queued -> $path"
