param([string]$Target='co-migrate',[string]$ScanPath=(Join-Path $HOME 'Desktop\CoAgent_SandboxRepo'))
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
$root = Join-Path $HOME 'Downloads\CoTemp'
. (Join-Path $root 'Join-CoAgent.ps1') | Out-Null
try { . (Join-Path $root 'common\CoPanels.ps1') | Out-Null } catch {}

Drop-CoDO -To $Target -Title 'DO-RepoScan-ReadOnly' -Body @"
"Repo scan at $(Get-Date -Format o) — $ScanPath"
Get-ChildItem -LiteralPath "$ScanPath" -Recurse -File -ErrorAction SilentlyContinue |
  Select-Object FullName, Length, LastWriteTime -First 50
"@
