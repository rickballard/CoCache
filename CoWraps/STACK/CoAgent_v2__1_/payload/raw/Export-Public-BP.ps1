param(
  [string]$In  = (Join-Path $HOME "Desktop/CoAgent/docs/private/CoAgent_BusinessPlan_PRIVATE_v2.md"),
  [string]$Out = (Join-Path $HOME "Desktop/CoAgent/docs/CoAgent_BusinessPlan_PUBLIC.md")
)
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
if (-not (Test-Path $In)) { throw "Private plan not found: $In" }
$t = Get-Content -Raw -LiteralPath $In
# Remove PRIVATE fenced blocks
$t = [regex]::Replace($t, '(?s)<!--\s*PRIVATE:BEGIN\s*-->.*?<!--\s*PRIVATE:END\s*-->', '')
# Drop investor-only sections by heading (tight list)
$dropHeads = @('^## 7\) Secret Sauce.*','^## 10\) 10-Year Scenarios.*','^## 13\) Near-Term Use of Funds.*','^## Appendix A.*')
foreach($h in $dropHeads){ $t = [regex]::Replace($t, "(?s)$h(?:.*?)(?=^##|\Z)", '', 'Multiline') }
Set-Content -LiteralPath $Out -Encoding UTF8 -Value $t
"Exported public plan -> $Out"
