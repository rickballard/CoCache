Set-StrictMode -Version Latest; $ErrorActionPreference="Stop"
$root = Join-Path $HOME "Downloads\CoTemp"
. (Join-Path $root "Join-CoAgent.ps1") | Out-Null
try { . (Join-Path $root "common\CoPanels.ps1") | Out-Null } catch {}
try { . (Join-Path $root "common\CoWatcher.ps1") | Out-Null } catch {}

# Unblock everything
Get-ChildItem -LiteralPath $root -Recurse -Filter *.ps1 -ErrorAction SilentlyContinue | Unblock-File

# Stop existing watcher jobs
foreach($sid in @("co-planning","co-migrate")){
  Get-Job -Name ("CoQueueWatcher-{0}" -f $sid) -ErrorAction SilentlyContinue | Remove-Job -Force -ErrorAction SilentlyContinue
}

# Clean panel registry (drop dead PIDs; keep newest per name)
$panelDir = Join-Path $root "panels"
$recs = Get-ChildItem "$panelDir\*.json" -ErrorAction SilentlyContinue | %{
  try { $j = Get-Content -Raw -LiteralPath $_.FullName | ConvertFrom-Json; $j | Add-Member file $_.FullName -Force; $j } catch {}
}
$alive = foreach($r in $recs){ if(Get-Process -Id $r.pid -ErrorAction SilentlyContinue){$r}else{ Remove-Item -LiteralPath $r.file -Force } }
$alive | Group-Object name | ForEach-Object {
  $keep = $_.Group | Sort-Object ts -Descending | Select-Object -First 1
  $_.Group | Where-Object { $_ -ne $keep } | ForEach-Object { Remove-Item -LiteralPath $_.file -Force }
}

# Re-register panels and start exactly one watcher per session
Register-CoPanel -Name "Planning" -SessionId "co-planning" | Out-Null
Register-CoPanel -Name "Migrate"  -SessionId "co-migrate"  | Out-Null
Start-CoQueueWatcherJob -SessionId "co-planning" -PanelName "Planning"
Start-CoQueueWatcherJob -SessionId "co-migrate"  -PanelName "Migrate"

# Policy notes to both panes (idempotent)
$note = @"
# Watcher policy — centralized
Status: $(Get-Date -Format o)

ONE watcher per session is active:
- CoQueueWatcher-co-planning
- CoQueueWatcher-co-migrate

Coordinate via:
- Drop-CoDO (runnable tasks)
- Send-CoNote (status/coordination)
"@
foreach($sid in "co-planning","co-migrate"){
  $in = Join-Path $root ("sessions\{0}\inbox" -f $sid)
  $null = New-Item -ItemType Directory -Force -Path $in | Out-Null
  Set-Content -LiteralPath (Join-Path $in ("NOTE_WATCHER_POLICY_{0}.md" -f (Get-Date -Format "yyyyMMdd-HHmmss"))) -Encoding UTF8 -Value $note
}

# Status
$sc = Join-Path $root "scripts\Status-QuickCheck.ps1"
if (Test-Path $sc) { & $sc } else { "Watchers restarted; status script not found." }
