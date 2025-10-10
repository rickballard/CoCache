Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
. (Join-Path $HOME 'Downloads\CoTemp\Join-CoAgent.ps1')

function _Count($p,$pattern){ try { return (Get-ChildItem -LiteralPath $p -Filter $pattern -ErrorAction SilentlyContinue).Count } catch { return 0 } }

$db = @(Get-CoPanels)
$rows = foreach($r in $db){
  $inbox  = $r.inbox; $outbox=$r.outbox; $logs=$r.logs
  [pscustomobject]@{
    name       = $r.name
    session    = $r.session_id
    pid        = $r.pid
    inbox_ps1  = _Count $inbox '*.ps1'
    outbox_ps1 = _Count $outbox '*.ps1'
    last_log   = (Get-ChildItem -LiteralPath $logs -Filter '*.txt' -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -desc | Select-Object -First 1).Name
  }
}
$rows | Format-Table -AutoSize
"`nJobs:`n"
Get-Job | Where-Object { $_.Name -like 'CoQueueWatcher-*' } | Format-Table Name, State, HasMoreData -AutoSize
