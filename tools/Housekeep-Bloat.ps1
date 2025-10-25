param(
  [string[]]$Repos = @(
    (Join-Path $HOME "Documents\GitHub\CoCache"),
    (Join-Path $HOME "Documents\GitHub\CoCivium"),
    (Join-Path $HOME "Documents\GitHub\CoSteward"),
    (Join-Path $HOME "Documents\GitHub\RickPublic")
  ),
  [int]$KeepReceiptDays = 365
)
$ErrorActionPreference='Stop'
$ProgressPreference='SilentlyContinue'
$PSModuleAutoLoadingPreference='None'
$env:GIT_TERMINAL_PROMPT='0'

foreach($r in $Repos){
  if(!(Test-Path $r)){ continue }
  Write-Host "• Quick-clean $r"
  # ultra-fast: no --aggressive
  git -C $r maintenance run --auto 2>$null | Out-Null
  git -C $r gc --prune=now 2>$null | Out-Null
}

# trim very old receipts (keep 1y)
$logDir = Join-Path (Join-Path $HOME "Documents\GitHub\CoCache") "status\log"
if(Test-Path $logDir){
  $cut = (Get-Date).AddDays(-$KeepReceiptDays)
  Get-ChildItem $logDir -Filter 'cosync_*.jsonl' -File -ea SilentlyContinue |
    Where-Object { $_.LastWriteTime -lt $cut } |
    Remove-Item -Force -ea SilentlyContinue
}

"✔ Housekeeping: quick pass done."
