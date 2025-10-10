Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
$root = Join-Path $HOME 'Downloads\CoTemp'
. (Join-Path $root 'Join-CoAgent.ps1') | Out-Null
try { . (Join-Path $root 'common\CoWatcher.ps1') | Out-Null } catch {}
try { . (Join-Path $root 'common\CoPanels.ps1')  | Out-Null } catch {}

foreach ($sid in 'co-planning','co-migrate') {
  $jn = "CoQueueWatcher-$sid"
  Get-Job -Name $jn -ErrorAction SilentlyContinue | Remove-Job -Force -ErrorAction SilentlyContinue
  Start-CoQueueWatcherJob -SessionId $sid -PanelName ($sid -replace '^co-','' )
}
& (Join-Path $root 'scripts\Status-QuickCheck.ps1')
