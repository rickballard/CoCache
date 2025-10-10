param(
  [string]$In  = (Join-Path $env:USERPROFILE "Desktop\\CoAgent\\docs\\private\\CoAgent_BusinessPlan_PRIVATE.md"),
  [string]$Out = (Join-Path $env:USERPROFILE "Desktop\\CoAgent\\docs\\CoAgent_BusinessPlan_PUBLIC.md")
)
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
$t = Get-Content -Raw -LiteralPath $In
# Remove PRIVATE blocks
$t = [regex]::Replace($t, '(?s)<!--\\s*PRIVATE:BEGIN\\s*-->.*?<!--\\s*PRIVATE:END\\s*-->', '')
# Drop lines starting with [PRIVATE] (if you add any)
$t = ($t -split "`r?`n") | Where-Object { $_ -notmatch '^\\s*\\[PRIVATE\\]' } -join "`r`n"
Set-Content -LiteralPath $Out -Encoding UTF8 -Value $t
"Exported public plan -> $Out"
