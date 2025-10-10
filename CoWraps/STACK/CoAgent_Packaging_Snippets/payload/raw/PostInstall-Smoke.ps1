Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
$root = Join-Path $HOME 'Downloads\CoTemp'
. (Join-Path $root 'Join-CoAgent.ps1')
try { . (Join-Path $root 'common\CoPanels.ps1') } catch {}
try { . (Join-Path $root 'common\NoteBridge.ps1') } catch {}

# Ensure one watcher per session
$sessions = @('co-planning','co-migrate')
foreach($sid in $sessions){
  Get-Job -Name ("CoQueueWatcher-{0}" -f $sid) -ErrorAction SilentlyContinue | Remove-Job -Force -ErrorAction SilentlyContinue
}
foreach($sid in $sessions){
  try { Register-CoPanel -Name ($(if($sid == 'co-planning'){'Planning'}else{'Migrate'})) -SessionId $sid | Out-Null } catch {}
  try { Start-CoQueueWatcherJob -SessionId $sid -PanelName ($(if($sid == 'co-planning'){'Planning'}else{'Migrate'})) } catch {}
}

# Queue a smoke DO and show last log
$null = Drop-CoDO -To 'co-migrate' -Title 'DO-Smoke' -Body @'
"Smoke test at $(Get-Date -Format o)"
$($PSVersionTable.PSVersion)
'@
$S = Join-Path $HOME 'Downloads\CoTemp\sessions\co-migrate'
Start-Sleep -Seconds 2
$last = Get-ChildItem "$S\logs\*.txt" | Sort-Object LastWriteTime -Desc | Select-Object -First 1
if ($last) {
  Write-Host "Last log: $($last.FullName)" -ForegroundColor Cyan
  Get-Content -LiteralPath $last.FullName -Tail 30
} else {
  Write-Warning "No logs yet. Watcher may still be starting."
}
