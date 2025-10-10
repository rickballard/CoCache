param(
  [string]$Target='co-migrate',
  [string]$RepoPath = (Join-Path $HOME 'Desktop\CoAgent_SandboxRepo')
)
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'

$root = Join-Path $HOME 'Downloads\CoTemp'
. (Join-Path $root 'Join-CoAgent.ps1') | Out-Null
try { . (Join-Path $root 'common\CoPanels.ps1') | Out-Null } catch {}

$t = Resolve-CoTarget -To $Target
$name = "DO_RepoScan_ReadOnly_{0}.ps1" -f (Get-Date -Format 'HHmmss')
$path = Join-Path $t.inbox $name

$body = @'
<# ---
title: "DO-RepoScan-ReadOnly"
session_id: "{0}"
repo: { name: "Sandbox", path: "{1}" }
risk: { writes: false, network: false, secrets: false, destructive: false }
brief: "List up to 50 files with size and last write time; read-only."
consent: { allow_writes: false, allow_network: false }
--- #>
# [PASTE IN POWERSHELL]
"repo-scan-readonly at $(Get-Date -Format o) - {1}"
Get-ChildItem -LiteralPath "{1}" -Recurse -File -ErrorAction SilentlyContinue |
  Select-Object FullName, Length, LastWriteTime -First 50
$PSVersionTable.PSVersion
'@ -f $t.session_id, $RepoPath

Set-Content -LiteralPath $path -Value $body -Encoding UTF8
Write-Host ("Queued -> {0}" -f $path) -ForegroundColor Green
return $path
