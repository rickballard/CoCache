param(
  [string]$OutDir = (Join-Path $HOME ("Desktop\CoAgent_Status_{0}" -f (Get-Date -Format 'yyyyMMdd-HHmmss')))
)
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
$root = Join-Path $HOME 'Downloads\CoTemp'
. (Join-Path $root 'Join-CoAgent.ps1') | Out-Null
try { . (Join-Path $root 'common\CoPanels.ps1') | Out-Null } catch {}

$null = New-Item -ItemType Directory -Force -Path $OutDir | Out-Null

# Status table
$sc = @'
CoTemp session ready: $env:COSESSION_ID

name     session       pid inbox_ps1 outbox_ps1 last_log
----     -------       --- --------- ---------- --------
'@
$rows = foreach ($r in @(Get-CoPanels)) {
  $inbox  = $r.inbox
  $outbox = $r.outbox
  $logs   = $r.logs
  $last = (Get-ChildItem -LiteralPath $logs -Filter *.txt -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -desc | Select-Object -First 1).Name
  [pscustomobject]@{
    name=$r.name; session=$r.session_id; pid=$r.pid
    inbox_ps1=@(Get-ChildItem -LiteralPath $inbox -Filter *.ps1 -ErrorAction SilentlyContinue).Count
    outbox_ps1=@(Get-ChildItem -LiteralPath $outbox -Filter *.ps1 -ErrorAction SilentlyContinue).Count
    last_log=$last
  }
}
$rows | Sort-Object name, pid | Format-Table -AutoSize | Out-String | Set-Content -LiteralPath (Join-Path $OutDir 'STATUS.txt')

# Copy greetings and current scripts (read-only snapshot)
foreach($p in 'greetings','scripts','common'){
  $src = Join-Path $root $p
  if (Test-Path $src) { Copy-Item -Recurse -Force $src (Join-Path $OutDir $p) }
}

"Snapshot written to $OutDir"
