param([string]$Target='co-migrate',[switch]$AllowWrites,[switch]$AllowNetwork)
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
$root = Join-Path $HOME 'Downloads\CoTemp'
. (Join-Path $root 'Join-CoAgent.ps1') | Out-Null
try { . (Join-Path $root 'common\CoPanels.ps1') | Out-Null } catch {}
$t = Resolve-CoTarget -To $Target
$name = "DO_Smoke_Minimal_{0}.ps1" -f (Get-Date -Format 'HHmmss')
$path = Join-Path $t.inbox $name
$aw=$AllowWrites.IsPresent.ToString().ToLower(); $an=$AllowNetwork.IsPresent.ToString().ToLower()

$header = @"
<# ---
title: "Smoke Minimal"
session_id: "$($t.session_id)"
repo: { name: "Sandbox", path: "$(Join-Path $HOME 'Desktop\CoAgent_SandboxRepo')" }
risk: { writes: $aw, network: $an, secrets: false, destructive: false }
brief: "Prints a timestamp and PS version. No side effects."
consent: { allow_writes: $aw, allow_network: $an }
--- #>
"@

$body = @'
# [PASTE IN POWERSHELL]
"Smoke test at $(Get-Date -Format o)"
$PSVersionTable.PSVersion
'@

Set-Content -LiteralPath $path -Value ($header + "`r`n" + $body) -Encoding UTF8
Write-Host ("Queued -> {0}" -f $path) -ForegroundColor Green
return $path
