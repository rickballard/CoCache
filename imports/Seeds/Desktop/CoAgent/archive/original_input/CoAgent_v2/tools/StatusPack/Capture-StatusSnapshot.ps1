param([string]$OutDir)
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
$root = Join-Path $HOME 'Downloads\CoTemp'
try { . (Join-Path $root 'Join-CoAgent.ps1') | Out-Null } catch {}
$ts   = Get-Date -Format 'yyyyMMdd-HHmmss'
$dest = if ($OutDir) { $OutDir } else { Join-Path $HOME ("Desktop\CoAgent_Snapshot_{0}" -f $ts) }
New-Item -ItemType Directory -Force -Path $dest | Out-Null

# panels
$panels = Join-Path $root 'panels'
if (Test-Path $panels) {
  $pd = Join-Path $dest 'panels'; New-Item -ItemType Directory -Force -Path $pd | Out-Null
  Get-ChildItem -LiteralPath $panels -Filter *.json -ErrorAction SilentlyContinue | Copy-Item -Destination $pd -Force
}

# jobs
(Get-Job -Name 'CoQueueWatcher-*' -ErrorAction SilentlyContinue |
  Select-Object Name, State, HasMoreData, PSBeginTime, PSEndTime |
  Format-Table -AutoSize | Out-String) |
  Set-Content -LiteralPath (Join-Path $dest 'jobs.txt') -Encoding UTF8

# logs (latest few per session)
$sessions = @('co-planning','co-migrate')
foreach ($sid in $sessions) {
  $ld = Join-Path $root (Join-Path "sessions\$sid" 'logs')
  $dd = Join-Path $dest ("logs-$sid")
  if (Test-Path $ld) {
    New-Item -ItemType Directory -Force -Path $dd | Out-Null
    $latest = Get-ChildItem -LiteralPath $ld -Filter *.txt -ErrorAction SilentlyContinue |
      Sort-Object LastWriteTime -Descending | Select-Object -First 3
    foreach ($f in $latest) { if ($null -ne $f) { Copy-Item -LiteralPath $f.FullName -Destination $dd -Force } }
  }
}

# greetings
$gsrc = Join-Path $root 'greetings'
if (Test-Path $gsrc) {
  $gdst = Join-Path $dest 'greetings'; New-Item -ItemType Directory -Force -Path $gdst | Out-Null
  Get-ChildItem -LiteralPath $gsrc -Filter *.txt -ErrorAction SilentlyContinue | Copy-Item -Destination $gdst -Force
}
"Snapshot written to $dest"
