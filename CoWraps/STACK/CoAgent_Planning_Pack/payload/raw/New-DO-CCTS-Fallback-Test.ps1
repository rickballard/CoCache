Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
param([string]$Target='co-migrate', [switch]$AllowWrites, [switch]$AllowNetwork)
$root = Join-Path $HOME 'Downloads\CoTemp'
. (Join-Path $root 'Join-CoAgent.ps1') | Out-Null

$body = @"
# [PASTE IN POWERSHELL]
"`"CCTS fallback smoke`" at $(Get-Date -Format o)"
# TODO: insert real checks here
'OK'
"@

Drop-CoDO -To $Target -Title 'DO-CCTS-Fallback-Smoke' -Brief 'Ensure fallback path returns OK' -AllowWrites:$AllowWrites -AllowNetwork:$AllowNetwork -Body $body
