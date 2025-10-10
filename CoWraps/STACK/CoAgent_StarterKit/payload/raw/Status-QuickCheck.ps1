Set-StrictMode -Version Latest; $ErrorActionPreference = 'Stop'

# Make sure session paths + helpers are in scope
. (Join-Path $HOME 'Downloads\CoTemp\Join-CoAgent.ps1') | Out-Null
try { . (Join-Path $HOME 'Downloads\CoTemp\common\CoPanels.ps1') | Out-Null } catch {}

function _Count {
  param([Parameter(Mandatory)][string]$Path,[string]$Pattern='*')
  if (-not (Test-Path -LiteralPath $Path)) { return 0 }
  return @(Get-ChildItem -LiteralPath $Path -Filter $Pattern -ErrorAction SilentlyContinue).Count
}

function _LatestFileName {
  param([Parameter(Mandatory)][string]$Path,[string]$Pattern='*')
  if (-not (Test-Path -LiteralPath $Path)) { return '' }
  $f = Get-ChildItem -LiteralPath $Path -Filter $Pattern -File -ErrorAction SilentlyContinue |
       Sort-Object LastWriteTime -Descending | Select-Object -First 1
  if ($null -eq $f) { return '' } else { return $f.Name }
}

$rows = @()
foreach ($r in @(Get-CoPanels)) {
  $rows += [pscustomobject]@{
    name       = $r.name
    session    = $r.session_id
    pid        = $r.pid
    inbox_ps1  = _Count $r.inbox  '*.ps1'
    outbox_ps1 = _Count $r.outbox '*.ps1'
    last_log   = _LatestFileName $r.logs '*.txt'
  }
}

$rows | Sort-Object name, pid | Format-Table -AutoSize

"`nJobs:`n"
Get-Job | Where-Object { $_.Name -like 'CoQueueWatcher-*' } |
  Select-Object Name, State, HasMoreData |
  Format-Table -AutoSize
