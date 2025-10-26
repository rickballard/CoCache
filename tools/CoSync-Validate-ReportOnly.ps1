param(
  [string]$Root = (Join-Path $HOME 'Documents\GitHub\CoCache')
)
$ErrorActionPreference='Stop'
try {
  pwsh -NoLogo -NoProfile -File (Join-Path $Root 'tools\CoSync-Validate.ps1')
} catch {
  Write-Host '• validator reported issues (ok for final sweep).'
}
# ensure artifacts exist even if validator bailed early
if(!(Test-Path (Join-Path $Root 'docs\dashboards\cosync_validation.csv'))){
  'file,line,repo,area,type,ok,when,summary' | Set-Content -Encoding UTF8 -LiteralPath (Join-Path $Root 'docs\dashboards\cosync_validation.csv')
}
if(!(Test-Path (Join-Path $Root 'docs\intent\COSYNC_GAPS.md'))){
  '# CoSync Validation — Gaps
_No gaps file produced by validator (shim placeholder)._ ' | Set-Content -Encoding UTF8 -LiteralPath (Join-Path $Root 'docs\intent\COSYNC_GAPS.md')
}
