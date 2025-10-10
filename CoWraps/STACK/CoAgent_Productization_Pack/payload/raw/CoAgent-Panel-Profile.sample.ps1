# CoAgent-Panel-Profile.sample.ps1
if (-not $env:CO_TEMP) { $env:CO_TEMP = Join-Path $HOME 'Downloads\CoTemp' }
$wrapper = Join-Path $PSScriptRoot '..\scripts\Ensure-InboxWatcher.ps1'
if (Test-Path $wrapper) { & $wrapper } else { Write-Warning "Ensure-InboxWatcher.ps1 missing" }