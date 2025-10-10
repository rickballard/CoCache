Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'

$root = Join-Path $HOME 'Downloads\CoTemp'

function Count-Files([string]$Path,[string]$Filter='*'){
  try { return @(Get-ChildItem -LiteralPath $Path -Filter $Filter -File -ErrorAction SilentlyContinue).Count } catch { return 0 }
}

function Get-LastFileName([string]$Path,[string]$Filter='*'){
  try {
    $f = Get-ChildItem -LiteralPath $Path -Filter $Filter -File -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -desc | Select-Object -First 1
    if ($f) { return $f.Name } else { return '' }
  } catch { return '' }
}

$dbPath = Join-Path $root 'panels'
$panels = @(Get-ChildItem -LiteralPath $dbPath -Filter '*.json' -File -ErrorAction SilentlyContinue | ForEach-Object { try { Get-Content -Raw -LiteralPath $_.FullName | ConvertFrom-Json } catch {} })

$rows = foreach($r in $panels){
  $inbox  = $r.inbox
  $outbox = $r.outbox
  $logs   = $r.logs
  [pscustomobject]@{
    name       = $r.name
    session    = $r.session_id
    pid        = $r.pid
    inbox_ps1  = Count-Files $inbox  '*.ps1'
    outbox_ps1 = Count-Files $outbox '*.ps1'
    last_log   = Get-LastFileName $logs '*.txt'
  }
}

$rows | Sort-Object name | Format-Table -AutoSize

"`nJobs:"
Get-Job | Where-Object { $_.Name -like 'CoQueueWatcher-*' } | Select-Object Name, State, HasMoreData | Format-Table -AutoSize
