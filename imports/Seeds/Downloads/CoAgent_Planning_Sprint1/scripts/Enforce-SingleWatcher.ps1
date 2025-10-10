param(
  [string[]]$Sessions = @('co-planning','co-migrate')
)
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
$root = Join-Path $HOME 'Downloads\CoTemp'
. (Join-Path $root 'Join-CoAgent.ps1') | Out-Null
try { . (Join-Path $root 'common\CoPanels.ps1') | Out-Null } catch {}
try { . (Join-Path $root 'common\CoWatcher.ps1') | Out-Null } catch {}

# Stop any existing watcher jobs for the target sessions
foreach($sid in $Sessions){
  Get-Job -Name ("CoQueueWatcher-{0}" -f $sid) -ErrorAction SilentlyContinue |
    Remove-Job -Force -ErrorAction SilentlyContinue
}

# Repair panel registry: remove dead PIDs and dedupe by panel name
$panelDir = Join-Path $root 'panels'
$recs = Get-ChildItem "$panelDir\*.json" -ErrorAction SilentlyContinue | ForEach-Object {
  try {
    $j = Get-Content -Raw -LiteralPath $_.FullName | ConvertFrom-Json
    $j | Add-Member -NotePropertyName file -NotePropertyValue $_.FullName -Force
    $j
  } catch {}
}

$alive = foreach($r in $recs){
  if (Get-Process -Id $r.pid -ErrorAction SilentlyContinue) { $r }
  else { Remove-Item -LiteralPath $r.file -Force }
}

$alive | Group-Object name | ForEach-Object {
  $keep = $_.Group | Sort-Object ts -Descending | Select-Object -First 1
  $_.Group | Where-Object { $_ -ne $keep } | ForEach-Object { Remove-Item -LiteralPath $_.file -Force }
}

function Get-PanelName($sid){
  if ($sid -match 'planning') { return 'Planning' }
  elseif ($sid -match 'migrate') { return 'Migrate' }
  else { return "Panel-$sid" }
}

foreach($sid in $Sessions){
  try { Register-CoPanel -Name (Get-PanelName $sid) -SessionId $sid | Out-Null } catch {}
  Start-CoQueueWatcherJob -SessionId $sid -PanelName (Get-PanelName $sid)
}

& (Join-Path $root 'scripts\Status-QuickCheck.ps1')
