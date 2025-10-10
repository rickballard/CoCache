param(
  [string]$In  = (Join-Path $PSScriptRoot "..\docs\private\CoAgent_BusinessPlan_PRIVATE.md"),
  [string]$Out = (Join-Path $PSScriptRoot "..\docs\CoAgent_BusinessPlan_PUBLIC.md")
)
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
$t = Get-Content -Raw -LiteralPath $In
# Remove PRIVATE blocks
$t = [regex]::Replace($t, '(?s)<!--\s*PRIVATE:BEGIN\s*-->.*?<!--\s*PRIVATE:END\s*-->', '')
# Drop lines beginning with [PRIVATE]
$t = ($t -split "`r?`n") | Where-Object { $_ -notmatch '^\s*\[PRIVATE\]' } -join "`r`n"
Set-Content -LiteralPath $Out -Encoding UTF8 -Value $t
"Exported public plan -> $Out"
