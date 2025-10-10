$root = Join-Path $HOME 'Downloads\CoTemp'
$rows = @()
$sessionsDir = Join-Path $root 'sessions'
if (Test-Path $sessionsDir) {
  Get-ChildItem $sessionsDir -Directory -ErrorAction SilentlyContinue | ForEach-Object {
    $sid = $_.Name
    $outbox = Join-Path $_.FullName 'logs'
    $inbox  = Join-Path $root 'inbox'
    $pid = ($sid -split '-')[-1]
    $rows += [pscustomobject]@{
      name      = if ($sid -match '-([^-]+)-\d+$') { 'Session' } else { 'Session' }
      session   = $sid
      pid       = $pid
      inbox_ps1 = (Get-ChildItem $inbox -Filter *.ps1 -ErrorAction SilentlyContinue | Measure-Object).Count
      outbox_ps1= (Get-ChildItem $outbox -Filter *.log -ErrorAction SilentlyContinue | Measure-Object).Count
      last_log  = (Get-ChildItem $outbox -Filter *.log -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 1).Name
    }
  }
}
$rows | Format-Table -AutoSize

""
"Jobs:"
Get-Job | Where-Object { $_.Name -like 'CoInboxWatcher' } | Format-Table Id,Name,State
