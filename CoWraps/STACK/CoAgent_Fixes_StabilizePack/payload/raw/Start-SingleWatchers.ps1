
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
$root = Join-Path $HOME 'Downloads\CoTemp'
. (Join-Path $root 'Join-CoAgent.ps1') | Out-Null
try { . (Join-Path $root 'common\CoWatcher.ps1') | Out-Null } catch {}

$targets = @('co-planning','co-migrate')
foreach($sid in $targets){
  Get-Job -Name ("CoQueueWatcher-{0}" -f $sid) -ErrorAction SilentlyContinue | Remove-Job -Force -ErrorAction SilentlyContinue
}
Start-CoQueueWatcherJob -SessionId 'co-planning' -PanelName 'Planning'
Start-CoQueueWatcherJob -SessionId 'co-migrate'  -PanelName 'Migrate'
"Started watchers."
