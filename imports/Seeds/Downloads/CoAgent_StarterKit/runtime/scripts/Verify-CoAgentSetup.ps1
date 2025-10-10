Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
$root = Join-Path $HOME 'Downloads\CoTemp'
$need = @()

function _has($rel){ Test-Path (Join-Path $root $rel) }
function _req($rel){ if (-not (_has $rel)) { $need += $rel } }

_req 'Join-CoAgent.ps1'
_req 'CoAgentLauncher.ps1'
_req 'common\CoWatcher.ps1'
_req 'common\CoPanels.ps1'
_req 'common\New-CoHelloDO.ps1'
_req 'common\NoteBridge.ps1'
_req 'scripts\Status-QuickCheck.ps1'
_req 'scripts\Mark-MigrateStandDown.ps1'

if ($need.Count -eq 0) {
  Write-Host "✅ CoAgent CoTemp runtime looks complete." -ForegroundColor Green
} else {
  Write-Host "⚠️ Missing pieces:" -ForegroundColor Yellow
  $need | ForEach-Object { " - $_" }
  Write-Host "Run: & \"$root\scripts\Install-CoAgent-ReadyPack.ps1\"" -ForegroundColor Yellow
}
