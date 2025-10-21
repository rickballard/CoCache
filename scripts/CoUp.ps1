param([string]$RepoRoot = (Split-Path -Parent $PSScriptRoot))
$ErrorActionPreference="Stop"
Set-Location $RepoRoot
# 1) Refresh metrics (writes status/codrift.json)
if(Test-Path "scripts/Measure-CoDrift.ps1"){ pwsh -NoProfile -ExecutionPolicy Bypass -File "scripts/Measure-CoDrift.ps1" | Out-Host }
# 2) Update README status block
if(Test-Path "scripts/Update-StatusBlock.ps1"){ pwsh -NoProfile -ExecutionPolicy Bypass -File "scripts/Update-StatusBlock.ps1" | Out-Host }
# 3) Stage, commit (if needed), push
$hadChanges=$false
git add status/ README.md 2>$null | Out-Null
if(git diff --cached --name-only){
  $hadChanges=$true
  # Try to enrich commit message with CDI if available
  $msg="status: CoUp"
  if(Test-Path "status/codrift.json"){
    try{ $j=Get-Content "status/codrift.json" -Raw | ConvertFrom-Json; $msg=("status: CoUp (CDI {0}% {1})" -f [int]$j.score,[string]$j.status) }catch{}
  }
  git commit -m $msg | Out-Null
}
$pushed=$false
try{ if($hadChanges){ git push | Out-Null; $pushed=$true } }catch{}
# 4) Print concise summary for PS7
$cdi="n/a"; $stat="n/a"
if(Test-Path "status/codrift.json"){ try{ $j=Get-Content "status/codrift.json" -Raw | ConvertFrom-Json; $cdi=[int]$j.score; $stat=[string]$j.status }catch{} }
Write-Host ("CoUp: CDI {0}% ({1}); committed: {2}; pushed: {3}" -f $cdi,$stat,([bool]$hadChanges),([bool]$pushed))
