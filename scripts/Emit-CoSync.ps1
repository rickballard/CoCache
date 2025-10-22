param(
  [Parameter(Mandatory)][string]$Area,
  [Parameter(Mandatory)][ValidateSet("status","decision","intent","metric","error")][string]$Type,
  [Parameter(Mandatory)][string]$Summary,
  [object]$Data,          # accepts hashtable or string
  [string]$DataJson       # accepts JSON string when using -File
)
$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$emit = Join-Path $root "scripts\Emit-CoSyncReceipt.ps1"
if (-not (Test-Path $emit)) { throw "Missing $emit" }

# Normalize to JSON
if ($null -ne $Data -and [string]::IsNullOrWhiteSpace($DataJson)) {
  if ($Data -is [string]) { $DataJson = $Data } else { $DataJson = ($Data | ConvertTo-Json -Depth 20 -Compress) }
}
if ([string]::IsNullOrWhiteSpace($DataJson)) { $DataJson = "{}" }

$evt = "${Area}:${Type}"
$payload = [ordered]@{
  area    = $Area
  type    = $Type
  summary = $Summary
  data    = ($DataJson | ConvertFrom-Json -Depth 20)
}

& $emit -Event $evt -DataJson ($payload | ConvertTo-Json -Depth 20 -Compress)