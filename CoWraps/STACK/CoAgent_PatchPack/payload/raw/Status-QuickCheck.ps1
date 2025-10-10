Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'

$root    = Join-Path $HOME 'Downloads\CoTemp'
$panelDb = Join-Path $root 'panels'

function _CountFiles([string]$p,[string]$pattern){
  if (-not (Test-Path $p)) { return 0 }
  return (Get-ChildItem -LiteralPath $p -Filter $pattern -ErrorAction SilentlyContinue).Count
}

# Collect sessions from panel registry (if any)
$sessions = @()
if (Test-Path $panelDb) {
  $files = Get-ChildItem -LiteralPath $panelDb -Filter '*.json' -File -ErrorAction SilentlyContinue
  foreach($f in $files){
    try {
      $rec = Get-Content -Raw -LiteralPath $f.FullName | ConvertFrom-Json
      if ($rec -and $rec.session_id) { $sessions += $rec }
    } catch {}
  }
}

# Ensure current session is present
if ($env:COSESSION_ID -and -not ($sessions | Where-Object { $_.session_id -eq $env:COSESSION_ID })) {
  $sid = $env:COSESSION_ID
  $sessRoot = Join-Path $root ("sessions\{0}" -f $sid)
  $sessions += [pscustomobject]@{
    name='(current)'
    session_id=$sid
    inbox=Join-Path $sessRoot 'inbox'
    outbox=Join-Path $sessRoot 'outbox'
    logs=Join-Path $sessRoot 'logs'
    pid=$PID
  }
}

if ($sessions.Count -eq 0) {
  Write-Warning "No panels found. Try running CoAgentLauncher or Register-CoPanel."
  return
}

$rows = foreach($r in $sessions){
  $inbox  = $r.inbox
  $outbox = $r.outbox
  $logs   = $r.logs
  $last = $null
  if (Test-Path $logs) {
    $last = Get-ChildItem -LiteralPath $logs -Filter '*.txt' -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -desc | Select-Object -First 1
  }
  [pscustomobject]@{
    name       = $r.name
    session    = $r.session_id
    pid        = $r.pid
    inbox_ps1  = _CountFiles $inbox  '*.ps1'
    outbox_ps1 = _CountFiles $outbox '*.ps1'
    last_log   = if ($last) { $last.Name } else { '' }
  }
}

$rows | Sort-Object name | Format-Table -AutoSize

"`nJobs:"
Get-Job | Where-Object { $_.Name -like 'CoQueueWatcher-*' } | Select-Object Name, State, HasMoreData | Format-Table -AutoSize
