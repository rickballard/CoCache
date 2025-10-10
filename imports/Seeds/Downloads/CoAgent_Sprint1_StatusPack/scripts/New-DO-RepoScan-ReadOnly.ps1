param([string]$Target='co-migrate',[string]$RepoPath = (Join-Path $HOME 'Desktop\CoAgent_SandboxRepo'))
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
$root = Join-Path $HOME 'Downloads\CoTemp'
. (Join-Path $root 'Join-CoAgent.ps1') | Out-Null
try { . (Join-Path $root 'common\CoPanels.ps1') | Out-Null } catch {}

$t       = Resolve-CoTarget -To $Target
$repo    = $RepoPath
$repoEsc = $repo -replace '"','`"'
$name    = 'DO_RepoScan_ReadOnly_{0}.ps1' -f (Get-Date -Format 'HHmmss')
$dest    = Join-Path $t.inbox $name

$header = @"
<# ---
title: "Repo Scan (read-only)"
session_id: "$($t.session_id)"
repo:
  name: "Sandbox"
  path: "$repo"
risk:
  writes: false
  network: false
  secrets: false
  destructive: false
brief: "List up to 50 files with sizes and timestamps. No writes."
consent:
  allow_writes: false
  allow_network: false
--- #>
"@

$script = @"
# [PASTE IN POWERSHELL]
"RepoScan (read-only) at $(Get-Date -Format o)"
Get-ChildItem -LiteralPath "$repoEsc" -Recurse -File -ErrorAction SilentlyContinue |
  Select-Object FullName, Length, LastWriteTime -First 50
"@

Set-Content -LiteralPath $dest -Encoding UTF8 -Value ($header + $script)
"Queued DO -> $dest"
