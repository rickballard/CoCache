param([string[]]$Sessions=@('co-planning','co-migrate'))
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'

$root = Join-Path $HOME 'Downloads\CoTemp'

# Ensure runtime helpers are in scope
. (Join-Path $root 'Join-CoAgent.ps1') | Out-Null
try { . (Join-Path $root 'common\CoPanels.ps1')  | Out-Null } catch {}
try { . (Join-Path $root 'common\CoWatcher.ps1') | Out-Null } catch {}

# A) Kill any existing watcher jobs for the target sessions
foreach ($sid in $Sessions) {
  Get-Job -Name ("CoQueueWatcher-{0}" -f $sid) -ErrorAction SilentlyContinue |
    Remove-Job -Force -ErrorAction SilentlyContinue
}

# B) Repair the panel registry (drop dead PIDs, dedupe by name keep newest)
$panelDir = Join-Path $root 'panels'
$files = Get-ChildItem "$panelDir\*.json" -ErrorAction SilentlyContinue
$recs = @()
foreach($f in $files){
  try {
    $j = Get-Content -Raw -LiteralPath $f.FullName | ConvertFrom-Json
    $j | Add-Member -NotePropertyName file -NotePropertyValue $f.FullName -Force
    $recs += $j
  } catch {}
}

$alive = @()
foreach($r in $recs){
  if (Get-Process -Id $r.pid -ErrorAction SilentlyContinue){ $alive += $r }
  else { Remove-Item -LiteralPath $r.file -Force }
}

$alive | Group-Object name | ForEach-Object {
  $keep = $_.Group | Sort-Object ts -Descending | Select-Object -First 1
  $_.Group | Where-Object { $_ -ne $keep } | ForEach-Object { Remove-Item -LiteralPath $_.file -Force }
}

function _PanelName([string]$sid){
  switch -Regex ($sid){
    '^co-planning$' { return 'Planning' }
    '^co-migrate$'  { return 'Migrate'  }
    default         { return "Panel-$sid" }
  }
}

# C) Re-register and start exactly one watcher per session
foreach($sid in $Sessions){
  $name = _PanelName $sid
  try { Register-CoPanel -Name $name -SessionId $sid | Out-Null } catch {}
  Start-CoQueueWatcherJob -SessionId $sid -PanelName $name
}

# D) Status (use whichever status script exists)
$scA = Join-Path $root 'scripts\Status-QuickCheck.ps1'
$scB = Join-Path $root 'scripts\Status-QuickCheck-Alt.ps1'
if (Test-Path $scA) { & $scA } elseif (Test-Path $scB) { & $scB } else { "Watchers restarted for: $($Sessions -join ', ')" }
