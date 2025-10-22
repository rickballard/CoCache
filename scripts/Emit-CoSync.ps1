param(
  [Parameter(Mandatory)][string]$Area,
  [Parameter(Mandatory)][ValidateSet("status","decision","intent","metric","error")][string]$Type,
  [Parameter(Mandatory)][string]$Summary,
  [hashtable]$Data
)
$ErrorActionPreference='Stop'
$root = Split-Path -Parent $PSScriptRoot
$emit = Join-Path $root 'scripts\Emit-CoSyncReceipt.ps1'
if (-not (Test-Path $emit)) { throw "Missing $emit" }
$evt = "${Area}:${Type}"
$payload = [ordered]@{ area=$Area; type=$Type; summary=$Summary; data=$Data }
& $emit -Event $evt -DataJson ($payload | ConvertTo-Json -Depth 12 -Compress)