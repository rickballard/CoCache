param([string]$Target='co-migrate')
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
$root = Join-Path $HOME 'Downloads\CoTemp'
. (Join-Path $root 'Join-CoAgent.ps1') | Out-Null
try { . (Join-Path $root 'common\CoPanels.ps1') | Out-Null } catch {}

Drop-CoDO -To $Target -Title 'DO-Smoke' -Body @'
"Smoke test at $(Get-Date -Format o)"
$($PSVersionTable.PSVersion)
'@
