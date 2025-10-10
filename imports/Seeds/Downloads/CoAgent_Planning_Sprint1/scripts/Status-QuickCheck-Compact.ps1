param([switch]$Compact)
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
$root = Join-Path $HOME 'Downloads\CoTemp'
. (Join-Path $root 'Join-CoAgent.ps1') | Out-Null
try { . (Join-Path $root 'common\CoPanels.ps1') | Out-Null } catch {}

function _Count([string]$Path,[string]$Pattern='*'){
  if (-not (Test-Path -LiteralPath $Path)) { return 0 }
  return @(Get-ChildItem -LiteralPath $Path -Filter $Pattern -ErrorAction SilentlyContinue).Count
}
function _Latest([string]$Path,[string]$Pattern='*'){
  if (-not (Test-Path -LiteralPath $Path)) { return '' }
  $f = Get-ChildItem -LiteralPath $Path -Filter $Pattern -File -ErrorAction SilentlyContinue |
       Sort-Object LastWriteTime -Descending | Select-Object -First 1
  if ($null -eq $f) { return '' } else { return $f.Name }
}

if ($Compact) {
  $panelDir = Join-Path $root 'panels'
  $recs = Get-ChildItem "$panelDir\*.json" -ErrorAction SilentlyContinue | ForEach-Object {
    try { $j = Get-Content -Raw -LiteralPath $_.FullName | ConvertFrom-Json; $j | Add-Member -NotePropertyName file -NotePropertyValue $_.FullName -Force; $j } catch {}
  }
  $alive = foreach($r in $recs){ if (Get-Process -Id $r.pid -ErrorAction SilentlyContinue) { $r } else { Remove-Item -LiteralPath $r.file -Force } }
  $alive | Group-Object name | ForEach-Object {
    $keep = $_.Group | Sort-Object ts -Descending | Select-Object -First 1
    $_.Group | Where-Object { $_ -ne $keep } | ForEach-Object { Remove-Item -LiteralPath $_.file -Force }
  }
}

$rows = foreach ($r in @(Get-CoPanels)) {
  [pscustomobject]@{
    name       = $r.name
    session    = $r.session_id
    pid        = $r.pid
    inbox_ps1  = _Count $r.inbox  '*.ps1'
    outbox_ps1 = _Count $r.outbox '*.ps1'
    last_log   = _Latest $r.logs '*.txt'
  }
}
$rows | Sort-Object name, pid | Format-Table -AutoSize

"`nJobs:`n"
Get-Job | Where-Object { $_.Name -like 'CoQueueWatcher-*' } |
  Select-Object Name, State, HasMoreData |
  Format-Table -AutoSize
